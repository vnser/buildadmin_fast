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
                    <FormItem :label="t('merchant.wxpay.infirmary_id')" type="number" prop="infirmary_id" :input-attr="{ step: 1 }" v-model.number="baTable.form.items!.infirmary_id" :placeholder="t('Please input field', { field: t('merchant.wxpay.infirmary_id') })" />
                    <FormItem :label="t('merchant.wxpay.merchant_no')" type="string" v-model="baTable.form.items!.merchant_no" prop="merchant_no" :placeholder="t('Please input field', { field: t('merchant.wxpay.merchant_no') })" />
                    <FormItem :label="t('merchant.wxpay.apikey')" type="string" v-model="baTable.form.items!.apikey" prop="apikey" :placeholder="t('Please input field', { field: t('merchant.wxpay.apikey') })" />
                    <FormItem :label="t('merchant.wxpay.cert_file')" type="string" v-model="baTable.form.items!.cert_file" prop="cert_file" :placeholder="t('Please input field', { field: t('merchant.wxpay.cert_file') })" />
                    <FormItem :label="t('merchant.wxpay.key_file')" type="string" v-model="baTable.form.items!.key_file" prop="key_file" :placeholder="t('Please input field', { field: t('merchant.wxpay.key_file') })" />
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
    infirmary_id: [buildValidatorData({ name: 'number', title: t('merchant.wxpay.infirmary_id') })],
    createtime: [buildValidatorData({ name: 'date', title: t('merchant.wxpay.createtime') })],
})
</script>

<style scoped lang="scss"></style>
