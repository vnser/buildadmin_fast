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
                    <FormItem :label="t('quotation.compute.user_id')" type="number" prop="user_id" :input-attr="{ step: 1 }" v-model.number="baTable.form.items!.user_id" :placeholder="t('Please input field', { field: t('quotation.compute.user_id') })" />
                    <FormItem :label="t('quotation.compute.quotation_sn')" type="string" v-model="baTable.form.items!.quotation_sn" prop="quotation_sn" :placeholder="t('Please input field', { field: t('quotation.compute.quotation_sn') })" />
                    <FormItem :label="t('quotation.compute.inventory_files_type')" type="select" v-model="baTable.form.items!.inventory_files_type" prop="inventory_files_type" :input-attr="{ content: { '0': t('quotation.compute.inventory_files_type 0'), '1': t('quotation.compute.inventory_files_type 1'), '2': t('quotation.compute.inventory_files_type 2') } }" :placeholder="t('Please select field', { field: t('quotation.compute.inventory_files_type') })" />
                    <FormItem :label="t('quotation.compute.inventory_files_ids')" type="string" v-model="baTable.form.items!.inventory_files_ids" prop="inventory_files_ids" :placeholder="t('Please input field', { field: t('quotation.compute.inventory_files_ids') })" />
                    <FormItem :label="t('quotation.compute.status')" type="switch" v-model="baTable.form.items!.status" prop="status" :input-attr="{ content: { '0': t('quotation.compute.status 0'), '1': t('quotation.compute.status 1'), '2': t('quotation.compute.status 2'), '3': t('quotation.compute.status 3') } }" />
                    <FormItem :label="t('quotation.compute.remark')" type="textarea" v-model="baTable.form.items!.remark" prop="remark" :input-attr="{ rows: 3 }" @keyup.enter.stop="" @keyup.ctrl.enter="baTable.onSubmit(formRef)" :placeholder="t('Please input field', { field: t('quotation.compute.remark') })" />
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
    user_id: [buildValidatorData({ name: 'number', title: t('quotation.compute.user_id') })],
    handletime: [buildValidatorData({ name: 'date', title: t('quotation.compute.handletime') })],
    createtime: [buildValidatorData({ name: 'date', title: t('quotation.compute.createtime') })],
})
</script>

<style scoped lang="scss"></style>
