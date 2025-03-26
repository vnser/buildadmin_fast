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
<!--                    <FormItem :label="t('business.galleryimgs.card_id')" type="remoteSelect" v-model="baTable.form.items!.card_id" prop="card_id" :input-attr="{ pk: 'zb_business_card.id', field: 'name', remoteUrl: '/admin/business.Card/index' }" :placeholder="t('Please select field', { field: t('business.galleryimgs.card_id') })" />-->
                    <FormItem :label="t('business.galleryimgs.images')" type="images" v-model="baTable.form.items!.images" prop="images" />
                    <FormItem :label="t('business.galleryimgs.images1')" type="images" v-model="baTable.form.items!.images1" prop="images1" />
                    <FormItem :label="t('business.galleryimgs.images2')" type="images" v-model="baTable.form.items!.images2" prop="images2" />
                    <FormItem :label="t('business.galleryimgs.images3')" type="images" v-model="baTable.form.items!.images3" prop="images3" />
<!--                    <FormItem :label="t('business.galleryimgs.status')" type="switch" v-model="baTable.form.items!.status" prop="status" :input-attr="{ content: { '0': t('business.galleryimgs.status 0'), '1': t('business.galleryimgs.status 1') } }" />-->
<!--                    <FormItem :label="t('business.galleryimgs.weigh')" type="number" prop="weigh" :input-attr="{ step: 1 }" v-model.number="baTable.form.items!.weigh" :placeholder="t('Please input field', { field: t('business.galleryimgs.weigh') })" />-->
                </el-form>
            </div>
        </el-scrollbar>
        <template #footer>
            <div :style="'width: calc(100% - ' + baTable.form.labelWidth! / 1.8 + 'px)'">
                <el-button @click="baTable.toggleForm()">{{ t('Cancel') }}</el-button>
                <el-button v-blur :loading="baTable.form.submitLoading" @click="baTable.form.items.card_id = props.card.id ;baTable.onSubmit(formRef)" type="primary">
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
const props = defineProps({
    card: {
        type: Object,
        required: false,
    },
});
const rules: Partial<Record<string, FormItemRule[]>> = reactive({
    update_time: [buildValidatorData({ name: 'date', title: t('business.galleryimgs.update_time') })],
    create_time: [buildValidatorData({ name: 'date', title: t('business.galleryimgs.create_time') })],
})
</script>

<style scoped lang="scss"></style>
