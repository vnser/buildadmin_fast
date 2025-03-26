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
                    <FormItem :label="t('storeinfo.title')" type="string" v-model="baTable.form.items!.title" prop="title" :placeholder="t('Please input field', { field: t('storeinfo.title') })" />
                    <FormItem :label="t('storeinfo.name')" type="string" v-model="baTable.form.items!.name" prop="name" :placeholder="t('Please input field', { field: t('storeinfo.name') })" />
                    <FormItem :label="t('storeinfo.phone')" type="string" v-model="baTable.form.items!.phone" @update:modelValue="args => {baTable.form.items!.wechat=args}" prop="phone" :placeholder="t('Please input field', { field: t('storeinfo.phone') })" />
                    <FormItem :label="t('storeinfo.wechat')" type="string" v-model="baTable.form.items!.wechat" prop="wechat" :placeholder="t('Please input field', { field: t('storeinfo.wechat') })" />
                    <FormItem :label="t('storeinfo.address')" type="string" v-model="baTable.form.items!.address" prop="address" :placeholder="t('Please input field', { field: t('storeinfo.address') })" />
<!--                    <FormItem :label="t('storeinfo.lat')" type="number" prop="lat" :input-attr="{ step: 1 }" v-model.number="baTable.form.items!.lat" :placeholder="t('Please input field', { field: t('storeinfo.lat') })" />-->
<!--                    <FormItem :label="t('storeinfo.lng')" type="number" prop="lng" :input-attr="{ step: 1 }" v-model.number="baTable.form.items!.lng" :placeholder="t('Please input field', { field: t('storeinfo.lng') })" />-->
                    <FormItem :label="t('storeinfo.weigh')" type="number" prop="weigh" :input-attr="{ step: 1 }" v-model.number="baTable.form.items!.weigh" :placeholder="t('Please input field', { field: t('storeinfo.weigh') })" />
                    <FormItem :label="t('storeinfo.status')" type="switch" v-model="baTable.form.items!.status" prop="status" :input-attr="{ content: { '0': t('storeinfo.status 0'), '1': t('storeinfo.status 1') } }" />
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

    title: [
        { required: true, message: '请输入门店标题', trigger: 'change' }
    ],
    name: [
        { required: true, message: '请输入门店联系人', trigger: 'change' }
    ],
    phone: [
        { required: true, message: '请输入门店联系人电话', trigger: 'change' }
    ],
    wechat: [
        { required: true, message: '请输入门店联系人微信', trigger: 'change' }
    ],
    address: [
        { required: true, message: '请输入门店地址', trigger: 'change' }
    ],
})
</script>

<style scoped lang="scss"></style>
