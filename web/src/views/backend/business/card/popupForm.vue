<template>
    <!-- 对话框表单 -->
    <!-- 建议使用 Prettier 格式化代码 -->
    <!-- el-form 内可以混用 el-form-item、FormItem、ba-input 等输入组件 -->
    <el-dialog
        class="ba-operate-dialog"
        :close-on-click-modal="false"
        :model-value="['Add', 'Edit'].includes(baTable.form.operate!)"
        @close="baTable.toggleForm"
        width="50%"
    >
        <template #header>
            <div class="title" v-drag="['.ba-operate-dialog', '.el-dialog__header']" v-zoom="'.ba-operate-dialog'">
                {{ baTable.form.operate ? t(baTable.form.operate) : '' }}
            </div>
        </template>
        <el-scrollbar v-loading="baTable.form.loading" class="ba-table-form-scrollbar">
            <div
                class="ba-operate-form"
                :class="'ba-' + baTable.form.operate + '-form'"
                :style="config.layout.shrink ? '':'width: calc(100% - ' + baTable.form.labelWidth! / 2 + 'px)'"
            >
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
                    <FormItem :label="t('business.card.name')" type="string" v-model="baTable.form.items!.name" prop="name" :placeholder="t('Please input field', { field: t('business.card.name') })" />
                    <FormItem label="主题颜色" type="color" v-model="baTable.form.items!.theme_color" prop="theme_color" :placeholder="t('Please input field', { field: t('business.card.theme_color') })" />
                    <FormItem label="头像" type="image" v-model="baTable.form.items!.avatar" prop="avatar" />
                    <FormItem label="分组" type="remoteSelects" v-model="baTable.form.items!.classify_ids" prop="classify_ids" :input-attr="{ pk: 'zb_business_classify.id', field: 'string', remoteUrl: '/admin/business.Classify/index' }" placeholder="请选择名片分组" />

                    <FormItem :label="t('business.card.banner')" type="images" v-model="baTable.form.items!.banner" prop="banner" />
                    <FormItem :label="t('business.card.phone')" type="string" v-model="baTable.form.items!.phone" prop="phone" :placeholder="t('Please input field', { field: t('business.card.phone') })" />
                    <FormItem :label="t('business.card.wechat')" type="string" v-model="baTable.form.items!.wechat" prop="wechat" :placeholder="t('Please input field', { field: t('business.card.wechat') })" />
                    <FormItem :label="t('business.card.address')" type="string" v-model="baTable.form.items!.address" prop="address" :placeholder="t('Please input field', { field: t('business.card.address') })" />
<!--                    <FormItem :label="t('business.card.latitude')" type="string" v-model="baTable.form.items!.latitude" prop="latitude" :placeholder="t('Please input field', { field: t('business.card.latitude') })" />-->
<!--                    <FormItem :label="t('business.card.longitude')" type="string" v-model="baTable.form.items!.longitude" prop="longitude" :placeholder="t('Please input field', { field: t('business.card.longitude') })" />-->
                    <FormItem :label="t('business.card.wechat_qrcode')" type="image" v-model="baTable.form.items!.wechat_qrcode" prop="wechat_qrcode" />
                    <FormItem :label="t('business.card.phone_icon')" type="image" v-model="baTable.form.items!.phone_icon" prop="phone_icon" />

                    <FormItem :label="t('business.card.wechat_icon')" type="image" v-model="baTable.form.items!.wechat_icon" prop="wechat_icon" />
                    <FormItem :label="t('business.card.address_icon')" type="image" v-model="baTable.form.items!.address_icon" prop="address_icon" />
                    <FormItem :label="`内容图集`" type="images" v-model="baTable.form.items!.content_imgs" prop="content_imgs" :placeholder="`请选择内容图集`" />
                    <FormItem :label="t('business.card.content')+'(即将废弃)'" type="editor" v-model="baTable.form.items!.content" prop="content" @keyup.enter.stop="" @keyup.ctrl.enter="baTable.onSubmit(formRef)" :placeholder="t('Please input field', { field: t('business.card.content') })" />
                    <FormItem :label="`分享标题`"
                              :tip="{content:'如果不填写，则不开启该功能，默认为微信默认分享规则',rawContent:true}"
                              type="string" v-model="baTable.form.items!.share_title" prop="share_title" :placeholder="`请输入分享标题`" />
                    <FormItem :label="`分享图`"

                              type="image" v-model="baTable.form.items!.share_img" prop="share_img" :placeholder="`请输入分享图`" />
                    <FormItem label="状态" type="switch" v-model="baTable.form.items!.status" prop="status" :placeholder="t('Please input field', { field: t('business.card.content') })" :input-attr="{ content: { '0': '禁用', '1':'正常' } }"/>
                </el-form>
            </div>
        </el-scrollbar>
        <template #footer>
            <div :style="'width: calc(100% - ' + baTable.form.labelWidth! / 1.8 + 'px)'">
                <el-button @click="baTable.toggleForm()">{{ t('Cancel') }}</el-button>
                <el-button v-blur :loading="baTable.form.submitLoading" @click="baTable.onSubmit(formRef)" type="primary">
                    {{ baTable.form.operateIds && baTable.form.operateIds.length > 1 ? t('Save and edit next item') : t('Save') }}
                </el-button>
            </div>
        </template>
    </el-dialog>
</template>

<script setup lang="ts">
import type { FormInstance, FormItemRule } from 'element-plus'
import {inject, onMounted, reactive, ref, watch} from 'vue'
import { useI18n } from 'vue-i18n'
import FormItem from '/@/components/formItem/index.vue'
import { useConfig } from '/@/stores/config'
import type baTableClass from '/@/utils/baTable'
import { buildValidatorData } from '/@/utils/validate'

const config = useConfig()
const formRef = ref<FormInstance>()
const baTable = inject('baTable') as baTableClass

const { t } = useI18n()

const rules: Partial<Record<string, FormItemRule[]>> = reactive({
    // content: [
    //     buildValidatorData({ name: 'editorRequired', title: t('business.card.content') })
    // ],
    content_imgs:[
        buildValidatorData({ name: 'required', title: '内容图片集' })
    ],
    name:[
        buildValidatorData({ name: 'required', title: '姓名' })
    ],
    avatar:[
        buildValidatorData({ name: 'required', title: '头像' })
    ],
    phone: [
        buildValidatorData({ name: 'required', title: '电话' })
    ],
    wechat: [
        buildValidatorData({ name: 'required', title: '微信号' })
    ],
    wechat_qrcode: [
        buildValidatorData({ name: 'required', title: '微信二维码' })
    ],
    address_icon: [
        buildValidatorData({ name: 'required', title: '地址图标' })
    ],
    wechat_icon: [
        buildValidatorData({ name: 'required', title: '微信图标' })
    ],
    phone_icon: [
        buildValidatorData({ name: 'required', title: '电话图标' })
    ],banner: [
        buildValidatorData({ name: 'required', title: 'banner' })
    ],

    address: [
        buildValidatorData({ name: 'required', title: '地址' })
    ],
    createtime: [buildValidatorData({ name: 'date', title: t('business.card.createtime') })],
    updatetime: [buildValidatorData({ name: 'date', title: t('business.card.updatetime') })],
})
// watch(baTable.form, (val)=>{
//     console.log(baTable.form.operate)
// })
/*console.log(baTable.form.operate)
onMounted(() => {
    console.log(baTable.form.operate)
    if (!baTable.form.items!.theme_color){

        baTable.form.items.theme_color = '#2982E1'
    }

})*/
</script>

<style scoped lang="scss"></style>
