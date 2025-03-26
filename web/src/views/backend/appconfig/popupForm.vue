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
                    <FormItem :label="t('appconfig.service_name')" type="string" v-model="baTable.form.items!.service_name" prop="service_name" :placeholder="t('Please input field', { field: t('appconfig.service_name') })" />
                    <FormItem :label="t('appconfig.service_phone')" type="string" v-model="baTable.form.items!.service_phone" prop="service_phone" :placeholder="t('Please input field', { field: t('appconfig.service_phone') })" />
                    <FormItem :label="t('appconfig.service_wechat_qrcode')" type="image" v-model="baTable.form.items!.service_wechat_qrcode" prop="service_wechat_qrcode" />
                    <FormItem :label="t('appconfig.service_address')" type="string" v-model="baTable.form.items!.service_address" prop="service_address" :placeholder="t('Please input field', { field: t('appconfig.service_address') })" />
                    <FormItem :label="t('appconfig.disclaimer')" type="editor" v-model="baTable.form.items!.disclaimer" prop="disclaimer" @keyup.enter.stop="" @keyup.ctrl.enter="baTable.onSubmit(formRef)" :placeholder="t('Please input field', { field: t('appconfig.disclaimer') })" />
                    <FormItem :label="t('appconfig.platform_policy')" type="editor" v-model="baTable.form.items!.platform_policy" prop="platform_policy" @keyup.enter.stop="" @keyup.ctrl.enter="baTable.onSubmit(formRef)" :placeholder="t('Please input field', { field: t('appconfig.platform_policy') })" />
                    <FormItem :label="t('appconfig.about_platform')" type="editor" v-model="baTable.form.items!.about_platform" prop="about_platform" @keyup.enter.stop="" @keyup.ctrl.enter="baTable.onSubmit(formRef)" :placeholder="t('Please input field', { field: t('appconfig.about_platform') })" />
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
import { inject, reactive, ref } from 'vue'
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
    disclaimer: [buildValidatorData({ name: 'editorRequired', title: t('appconfig.disclaimer') })],
    platform_policy: [buildValidatorData({ name: 'editorRequired', title: t('appconfig.platform_policy') })],
    about_platform: [buildValidatorData({ name: 'editorRequired', title: t('appconfig.about_platform') })],
    update_time: [buildValidatorData({ name: 'date', title: t('appconfig.update_time') })],
})
</script>

<style scoped lang="scss"></style>
