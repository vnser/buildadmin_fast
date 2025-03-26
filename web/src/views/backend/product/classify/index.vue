<template>
    <div class="default-main ba-table-box">
        <el-alert class="ba-table-alert" v-if="baTable.table.remark" :title="baTable.table.remark" type="info" show-icon />

        <!-- 表格顶部菜单 -->
        <!-- 自定义按钮请使用插槽，甚至公共搜索也可以使用具名插槽渲染，参见文档 -->
        <TableHeader
            :buttons="['refresh', 'add', 'edit', 'delete']"
            :quick-search-placeholder="t('Quick search placeholder', { fields: t('product.classify.quick Search Fields') })"

        ></TableHeader>

        <!-- 表格 -->
        <!-- 表格列有多种自定义渲染方式，比如自定义组件、具名插槽等，参见文档 -->
        <!-- 要使用 el-table 组件原有的属性，直接加在 Table 标签上即可 -->
        <Table ref="tableRef"   :pagination="false"   @expand-change="handleExpandChange"
        >
            <template #parent_title>
                <el-table-column prop="parent_title" label="上级" align="center">
                    <template #default="scope">
                        <div
                            class="dataset"
                            :data-id="scope.row.id"
                            :data-parent-id="scope.row.pid"
                        >
                        <el-tag size="small">
                            {{scope.row.parent?.title??'顶级'}}
                        </el-tag>
                        </div>
                    </template>
                </el-table-column>
            </template>
        </Table>

        <!-- 表单 -->
        <PopupForm />
    </div>
</template>

<script setup lang="ts">
import {computed, nextTick, onMounted, provide, ref, watch} from 'vue'
import { useI18n } from 'vue-i18n'
import PopupForm from './popupForm.vue'
import { baTableApi } from '/@/api/common'
import { defaultOptButtons } from '/@/components/table'
import TableHeader from '/@/components/table/header/index.vue'
import Table from '/@/components/table/index.vue'
import baTableClass from '/@/utils/baTable'

defineOptions({
    name: 'product/classify',
})

const { t } = useI18n()
const tableRef = ref()
const optButtons: OptButton[] = defaultOptButtons([ 'weigh-sort','edit', 'delete'])

/**
 * baTable 内包含了表格的所有数据且数据具备响应性，然后通过 provide 注入给了后代组件
 */
const baTable = new baTableClass(
    new baTableApi('/admin/product.Classify/'),
    {
        pk: 'id',
        column: [
            { type: 'selection', align: 'center', operator: false },
            { label: t('product.classify.title'),width: 220, prop: 'title', align: 'left', operatorPlaceholder: "k60、小米...,支持查找顶级", operator: false, sortable: false },
            // { label: t('product.classify.id'), prop: 'id', align: 'center', width: 120, operator: 'RANGE', sortable: 'custom' },
            // { label: t('product.classify.pid'), prop: 'pid', align: 'center', operator: 'RANGE', sortable: false },
            { label: t('product.classify.pid'),prop: 'parent.title', align: 'center', operator: false, sortable: false ,render:'slot',slotName:'parent_title'},

            // { label: t('product.classify.depth'), prop: 'depth', align: 'center', operator: 'RANGE', sortable: false },
            { label: t('product.classify.status'), prop: 'status', align: 'center', render: 'switch', operator: 'eq', sortable: false, replaceValue: { '0': t('product.classify.status 0'), '1': t('product.classify.status 1') } },
            { label: t('product.classify.weigh'), prop: 'weigh', align: 'center', operator: false, sortable: 'custom' },
            { label: t('product.classify.create_time'), prop: 'create_time', align: 'center', render: 'datetime', operator: false, sortable: 'custom', width: 160, timeFormat: 'yyyy-mm-dd hh:MM:ss' },
            { label: t('Operate'), align: 'center', width: 140, render: 'buttons', buttons: optButtons, operator: false },
        ],
        dblClickNotEditColumn: [undefined, 'status'],
        defaultOrder: { prop: 'weigh', order: 'desc' },
        // dragSortLimitField:''
    },
    {
        defaultItems: { status: '1' ,weigh: '0'},
    },{},{


    }
)

provide('baTable', baTable)

onMounted(() => {
    baTable.table.ref = tableRef.value
    baTable.mount()
    baTable.getIndex()?.then(() => {
        baTable.initSort()
        baTable.dragSort()
    })

    // 监听数据变化，恢复展开状态
    watch(
        data,
        () => {
            // console.log(1)
            nextTick(() => {
                restoreExpandedRows();
            });
        },
        { deep: true }
    );
})
const expandedRows = ref({}); // 用于存储展开状态
// const table = ref(null); // 表格实例

// 监听展开状态变化
const handleExpandChange = (row, expanded) => {
    // console.log(123)
    // console.log(expanded)
    if (expanded) {
        expandedRows.value[row.id] = true; // 记录展开状态
    } else {
        delete expandedRows.value[row.id]; // 移除未展开的行
    }
};

// 恢复展开行状态
const restoreExpandedRows = () => {
    if (!tableRef.value) return;
    data.value.forEach((row) => {
        // 检查当前节点及其子节点的展开状态
        if (expandedRows.value[row.id]) {
            tableRef.value.getRef().toggleRowExpansion(row, true); // 展开当前节点
        }
        // 如果子节点有展开状态，递归处理
        if (row.children && row.children.length) {
            restoreChildrenExpanded(row.children);
        }
    });
};

// 恢复子节点的展开状态
const restoreChildrenExpanded = (children) => {
    children.forEach((child) => {
        if (expandedRows.value[child.id]) {
            tableRef.value.getRef().toggleRowExpansion(child, true); // 展开子节点
        }
        if (child.children && child.children.length) {
            restoreChildrenExpanded(child.children); // 递归处理更深层的子节点
        }
    });
};

const data = computed(()=>{
    return baTable.table.data
})

</script>

<style scoped lang="scss"></style>
