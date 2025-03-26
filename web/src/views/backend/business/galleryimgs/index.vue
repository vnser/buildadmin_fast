<template>
    <div class="default-main ba-table-box">
        <el-alert class="ba-table-alert" v-if="baTable.table.remark" :title="baTable.table.remark" type="info" show-icon />

        <!-- 表格顶部菜单 -->
        <!-- 自定义按钮请使用插槽，甚至公共搜索也可以使用具名插槽渲染，参见文档 -->
        <TableHeader
            :buttons="['add','refresh',  'edit']"
            :quick-search-placeholder="t('Quick search placeholder', { fields: t('business.galleryimgs.quick Search Fields') })"
        ></TableHeader>

        <!-- 表格 -->
        <!-- 表格列有多种自定义渲染方式，比如自定义组件、具名插槽等，参见文档 -->
        <!-- 要使用 el-table 组件原有的属性，直接加在 Table 标签上即可 -->
        <Table ref="tableRef"></Table>

        <!-- 表单 -->
        <PopupForm :card="props.card"/>
    </div>
</template>

<script setup lang="ts">
import { onMounted, provide, ref } from 'vue'
import { useI18n } from 'vue-i18n'
import PopupForm from './popupForm.vue'
import { baTableApi } from '/@/api/common'
import { defaultOptButtons } from '/@/components/table'
import TableHeader from '/@/components/table/header/index.vue'
import Table from '/@/components/table/index.vue'
import baTableClass from '/@/utils/baTable'

defineOptions({
    name: 'business/galleryimgs',
})

const { t } = useI18n()
const tableRef = ref()
const optButtons: OptButton[] = defaultOptButtons([ 'edit'])

/**
 * baTable 内包含了表格的所有数据且数据具备响应性，然后通过 provide 注入给了后代组件
 */
const baTable = new baTableClass(
    new baTableApi('/admin/business.Galleryimgs/'),
    {
        pk: 'id',
        column: [
            { type: 'selection', align: 'center', operator: false },
            // { label: t('business.galleryimgs.id'), prop: 'id', align: 'center', width: 70, operator: 'RANGE', sortable: 'custom' },
            { label: t('business.galleryimgs.card__name'), prop: 'card.name', align: 'center', operatorPlaceholder: t('Fuzzy query'), render: 'tags', operator: 'LIKE' },
            { label: t('business.galleryimgs.images'), prop: 'images', align: 'center', render: 'images', operator: false },
            { label: t('business.galleryimgs.images1'), prop: 'images1', align: 'center', render: 'images', operator: false },
            { label: t('business.galleryimgs.images2'), prop: 'images2', align: 'center', render: 'images', operator: false },
            { label: t('business.galleryimgs.images3'), prop: 'images3', align: 'center', render: 'images', operator: false },
            // { label: t('business.galleryimgs.status'), prop: 'status', align: 'center', render: 'switch', operator: 'eq', sortable: false, replaceValue: { '0': t('business.galleryimgs.status 0'), '1': t('business.galleryimgs.status 1') } },
            // { label: t('business.galleryimgs.weigh'), prop: 'weigh', align: 'center', operator: 'RANGE', sortable: 'custom' },
            { label: t('business.galleryimgs.update_time'), prop: 'update_time', align: 'center', render: 'datetime', operator: false, sortable: 'custom', width: 160, timeFormat: 'yyyy-mm-dd hh:MM:ss' },
            { label: t('business.galleryimgs.create_time'), prop: 'create_time', align: 'center', render: 'datetime', operator: false, sortable: 'custom', width: 160, timeFormat: 'yyyy-mm-dd hh:MM:ss' },
            { label: t('Operate'), align: 'center', width: 140, render: 'buttons', buttons: optButtons, operator: false },
        ],
        dblClickNotEditColumn: [undefined, 'status'],
        defaultOrder: { prop: 'weigh', order: 'desc' },
    },
    {
        defaultItems: { status: '1' },
    }
)
const props = defineProps({
    card: {
        type: Object,
        required: false,
    },
});
provide('baTable', baTable)
const reloadList = ()=>{
    baTable.table.filter  = {
        initKey:'card_id',
        initValue:props.card.id,
        use_limit:10,

    }
    baTable.getIndex()?.then(() => {
        baTable.initSort()
        baTable.dragSort()
    })
}
onMounted(() => {
    baTable.table.ref = tableRef.value
    baTable.mount()
    reloadList()
})

defineExpose({
    reloadList,
})
</script>

<style scoped lang="scss"></style>
