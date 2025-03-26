<template>
    <div class="default-main ba-table-box">
        <el-alert class="ba-table-alert" v-if="baTable.table.remark" :title="baTable.table.remark" type="info"
                  show-icon/>

        <!-- 表格顶部菜单 -->
        <!-- 自定义按钮请使用插槽，甚至公共搜索也可以使用具名插槽渲染，参见文档 -->
        <!--        <TableHeader-->
        <!--            :buttons="['refresh', ]"-->
        <!--            :quick-search-placeholder="t('Quick search placeholder', { fields: t('appconfig.quick Search Fields') })"-->
        <!--        ></TableHeader>-->


        <div class="default-main ">
            <el-row v-loading="loading" :gutter="40">
                <el-col class="xs-mb-40" :xs="40" :sm="20">
                    <el-tabs v-model="tabCheck" type="border-card">
                        <el-tab-pane class="config-tab-pane" name="basic" label="应用配置">
                            <el-form
                                v-if="!baTable.form.loading"
                                ref="formRef"
                                @submit.prevent=""
                                @keyup.enter="baTable.onSubmit(formRef)"
                                :model="baTable.form.items"
                                :label-position="config.layout.shrink ? 'top' : 'right'"
                                :label-width="baTable.form.labelWidth + 'px'"
                                :rules="rules"
                            >
                                <FormItem :label="t('appconfig.mobile_division')" type="string"
                                          v-model="baTable.form.items!.mobile_division"
                                          blockHelp="格式：appid@path,如: a231321211@/pages/index/index"
                                          prop="mobile_division"
                                          :placeholder="t('Please input field', { field: t('appconfig.mobile_division') })"/>
                                <FormItem :label="t('appconfig.service_name')" type="string"
                                          v-model="baTable.form.items!.service_name" prop="service_name"
                                          :placeholder="t('Please input field', { field: t('appconfig.service_name') })"/>


                                <FormItem :label="t('appconfig.service_phone')" type="string"
                                          v-model="baTable.form.items!.service_phone" prop="service_phone"
                                          :placeholder="t('Please input field', { field: t('appconfig.service_phone') })"/>
                                <FormItem :label="t('appconfig.service_wechat_qrcode')" type="image"
                                          v-model="baTable.form.items!.service_wechat_qrcode"
                                          prop="service_wechat_qrcode"/>
                                <FormItem :label="t('appconfig.service_address')" type="string"
                                          v-model="baTable.form.items!.service_address" prop="service_address"
                                          :placeholder="t('Please input field', { field: t('appconfig.service_address') })"/>

                                <FormItem :label="t('appconfig.want_sell_img')" type="image"
                                          v-model="baTable.form.items!.want_sell_img"
                                          blockHelp="建议尺寸：330x204"
                                          prop="want_sell_img"/>
                                <FormItem :label="t('appconfig.quick_price_img')" type="image"
                                          v-model="baTable.form.items!.quick_price_img"
                                          blockHelp="建议尺寸：330x204"
                                          prop="quick_price_img"/>
                                <FormItem :label="t('appconfig.invite_friend_img')" type="image"
                                          v-model="baTable.form.items!.invite_friend_img"
                                          blockHelp="建议尺寸：330x204"
                                          prop="invite_friend_img"/>
                                <FormItem :label="t('appconfig.disclaimer')" type="editor"
                                          v-model="baTable.form.items!.disclaimer" prop="disclaimer"
                                          @keyup.enter.stop="" @keyup.ctrl.enter="baTable.onSubmit(formRef)"
                                          :placeholder="t('Please input field', { field: t('appconfig.disclaimer') })"/>
                                <FormItem :label="t('appconfig.platform_policy')" type="editor"
                                          v-model="baTable.form.items!.platform_policy" prop="platform_policy"
                                          @keyup.enter.stop="" @keyup.ctrl.enter="baTable.onSubmit(formRef)"
                                          :placeholder="t('Please input field', { field: t('appconfig.platform_policy') })"/>
                                <FormItem :label="t('appconfig.about_platform')" type="editor"
                                          v-model="baTable.form.items!.about_platform" prop="about_platform"
                                          @keyup.enter.stop="" @keyup.ctrl.enter="baTable.onSubmit(formRef)"
                                          :placeholder="t('Please input field', { field: t('appconfig.about_platform') })"/>
                            </el-form>


                            <div :style="'width: calc(100% - ' + baTable.form.labelWidth! / 1.8 + 'px)'">
                                <!--                        <el-button @click="baTable.toggleForm()">{{ t('Cancel') }}</el-button>-->
                                <el-button v-blur :loading="baTable.form.submitLoading" @click="submit" type="primary">
                                    {{ baTable.form.operateIds && baTable.form.operateIds.length > 1 ? t('Save and edit next item') : t('Save') }}
                                </el-button>
                            </div>
                        </el-tab-pane>
                    </el-tabs>
                </el-col>
            </el-row>
        </div>
        <!-- 表格 -->
        <!-- 表格列有多种自定义渲染方式，比如自定义组件、具名插槽等，参见文档 -->
        <!-- 要使用 el-table 组件原有的属性，直接加在 Table 标签上即可 -->
        <!--        <Table ref="tableRef"></Table>-->

        <!-- 表单 -->
<!--        <PopupForm/>-->
    </div>
</template>

<script setup lang="ts">
import {onMounted, provide, reactive, ref} from 'vue'
import {useI18n} from 'vue-i18n'
import PopupForm from './popupForm.vue'
import {baTableApi} from '/@/api/common'
import {defaultOptButtons} from '/@/components/table'
import TableHeader from '/@/components/table/header/index.vue'
import Table from '/@/components/table/index.vue'
import baTableClass from '/@/utils/baTable'
import FormItem from "/@/components/formItem/index.vue";
import {useConfig} from '/@/stores/config'
import type {FormItemRule} from "element-plus";
import {buildValidatorData} from "/@/utils/validate";

defineOptions({
    name: 'appconfig',
})

const config = useConfig()
const {t} = useI18n()
const tabCheck = ref('basic')
const optButtons: OptButton[] = defaultOptButtons(['edit'])

/**
 * baTable 内包含了表格的所有数据且数据具备响应性，然后通过 provide 注入给了后代组件
 */
const baTable = new baTableClass(
    new baTableApi('/admin/Appconfig/'),
    {
        pk: 'id',
        column: []
    },
    {
        defaultItems: {disclaimer: '', platform_policy: '', about_platform: ''},
    }
)
const formRef = ref()
const loading = ref(true)
provide('baTable', baTable)

onMounted(() => {
    /*  baTable.table.ref = tableRef.value
      baTable.mount()
      baTable.getIndex()?.then(() => {
          baTable.initSort()
          baTable.dragSort()
      })*/

    baTable.requestEdit([1]).then(() => {
        loading.value = false
    })
})


const submit = () => {
    baTable.form.operate = 'Edit'
    baTable.onSubmit(formRef.value[0])
}

const rules: Partial<Record<string, FormItemRule[]>> = reactive({
    disclaimer: [buildValidatorData({ name: 'editorRequired', title: t('appconfig.disclaimer') })],
    platform_policy: [buildValidatorData({ name: 'editorRequired', title: t('appconfig.platform_policy') })],
    about_platform: [buildValidatorData({ name: 'editorRequired', title: t('appconfig.about_platform') })],
    update_time: [buildValidatorData({ name: 'date', title: t('appconfig.update_time') })],
})
</script>

<style scoped lang="scss">
.send-test-mail {
    padding-bottom: 20px;
}
.el-tabs--border-card {
    border: none;
    box-shadow: var(--el-box-shadow-light);
    border-radius: var(--el-border-radius-base);
}
.el-tabs--border-card :deep(.el-tabs__header) {
    background-color: var(--ba-bg-color);
    border-bottom: none;
    border-top-left-radius: var(--el-border-radius-base);
    border-top-right-radius: var(--el-border-radius-base);
}
.el-tabs--border-card :deep(.el-tabs__item.is-active) {
    border: 1px solid transparent;
}
.el-tabs--border-card :deep(.el-tabs__nav-wrap) {
    border-top-left-radius: var(--el-border-radius-base);
    border-top-right-radius: var(--el-border-radius-base);
}
.el-card :deep(.el-card__header) {
    height: 40px;
    padding: 0;
    line-height: 40px;
    border: none;
    padding-left: 20px;
    background-color: var(--ba-bg-color);
}
</style>
