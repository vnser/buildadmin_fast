<template>
    <div class="default-main ba-table-box">
        <el-alert class="ba-table-alert" v-if="baTable.table.remark" :title="baTable.table.remark" type="info"
                  show-icon/>

        <!-- 表格顶部菜单 -->
        <!-- 自定义按钮请使用插槽，甚至公共搜索也可以使用具名插槽渲染，参见文档 -->
        <TableHeader
            :buttons="['refresh', 'add', 'edit', 'delete', 'comSearch', 'quickSearch', 'columnDisplay']"
            :quick-search-placeholder="t('Quick search placeholder', { fields: t('storeinfo.quick Search Fields') })"
        ></TableHeader>

        <!-- 表格 -->
        <!-- 表格列有多种自定义渲染方式，比如自定义组件、具名插槽等，参见文档 -->
        <!-- 要使用 el-table 组件原有的属性，直接加在 Table 标签上即可 -->
        <Table ref="tableRef">
            <template #address>
                <el-table-column prop="parent_title" label="地址" align="center">
                    <template #default="scope">
                        {{scope.row.address}}
                        <a target="_blank" :href="`https://apis.map.qq.com/uri/v1/marker?marker=coord:${scope.row.lat},${scope.row.lng};title:${scope.row.title};addr:${scope.row.address}&referer=myapp`">
                            <el-button type="primary" size="small">打开地图</el-button>
                        </a>
                    </template>
                </el-table-column>
            </template>

        </Table>

        <!-- 表单 -->
        <PopupForm/>
    </div>
</template>

<script setup lang="ts">
import {onMounted, provide, ref} from 'vue'
import {useI18n} from 'vue-i18n'
import PopupForm from './popupForm.vue'
import {baTableApi} from '/@/api/common'
import {defaultOptButtons} from '/@/components/table'
import TableHeader from '/@/components/table/header/index.vue'
import Table from '/@/components/table/index.vue'
import baTableClass from '/@/utils/baTable'

defineOptions({
    name: 'storeinfo',
})

const {t} = useI18n()
const tableRef = ref()
const optButtons: OptButton[] = defaultOptButtons(['weigh-sort', 'edit', 'delete'])

/**
 * baTable 内包含了表格的所有数据且数据具备响应性，然后通过 provide 注入给了后代组件
 */
const baTable = new baTableClass(
    new baTableApi('/admin/Storeinfo/'),
    {
        pk: 'id',
        column: [
            {type: 'selection', align: 'center', operator: false},
            {label: t('storeinfo.id'), prop: 'id', align: 'center', width: 70, operator: false, sortable: 'custom'},
            {
                label: t('storeinfo.title'),
                prop: 'title',
                render: 'tag',
                align: 'center',
                operatorPlaceholder: "重庆、北京...",
                operator: 'LIKE',
                sortable: false
            },
            {
                label: t('storeinfo.name'),
                prop: 'name',
                align: 'center',
                operatorPlaceholder: t('Fuzzy query'),
                operator: false,
                sortable: false
            },
            {
                label: t('storeinfo.phone'),
                prop: 'phone',
                align: 'center',
                operatorPlaceholder: "1358888...",
                operator: 'LIKE',
                sortable: false
            },
            {
                label: t('storeinfo.wechat'),
                prop: 'wechat',
                align: 'center',
                operatorPlaceholder: t('Fuzzy query'),
                operator: false,
                sortable: false
            },
            {
                label: t('storeinfo.address'),
                prop: 'address',
                align: 'center',
                operatorPlaceholder: "重庆市...",
                operator: 'LIKE',
                sortable: false,
                render: 'slot',
                slotName: 'address'
            },
            {label: t('storeinfo.lat'), prop: 'lat', render: 'tag', align: 'center', operator: false, sortable: false},
            {label: t('storeinfo.lng'), prop: 'lng', render: 'tag', align: 'center', operator: false, sortable: false},
            {label: t('storeinfo.weigh'), prop: 'weigh', align: 'center', operator: false, sortable: 'custom'},
            {
                label: t('storeinfo.status'),
                prop: 'status',
                align: 'center',
                render: 'switch',
                operator: false,
                sortable: false,
                replaceValue: {'0': t('storeinfo.status 0'), '1': t('storeinfo.status 1')}
            },
            {
                label: t('storeinfo.create_time'),
                prop: 'create_time',
                align: 'center',
                render: 'datetime',
                operator: false,
                sortable: 'custom',
                width: 160,
                timeFormat: 'yyyy-mm-dd hh:MM:ss'
            },
            {label: t('Operate'), align: 'center', width: 140, render: 'buttons', buttons: optButtons, operator: false},
        ],
        dblClickNotEditColumn: [undefined, 'status'],
        defaultOrder: {prop: 'weigh', order: 'desc',},
    },
    {
        defaultItems: {status: '1', weigh: 0},
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
})
</script>

<style scoped lang="scss"></style>
