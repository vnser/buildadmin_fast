<template>
    <div class="default-main ba-table-box">
        <el-alert class="ba-table-alert" v-if="baTable.table.remark" :title="baTable.table.remark" type="info" show-icon />

        <!-- 表格顶部菜单 -->
        <!-- 自定义按钮请使用插槽，甚至公共搜索也可以使用具名插槽渲染，参见文档 -->
        <TableHeader
            :buttons="['refresh', 'add', 'edit', 'delete', 'comSearch', 'quickSearch', 'columnDisplay']"
            :quick-search-placeholder="t('Quick search placeholder', { fields: t('business.video.quick Search Fields') })"
        ></TableHeader>

        <!-- 表格 -->
        <!-- 表格列有多种自定义渲染方式，比如自定义组件、具名插槽等，参见文档 -->
        <!-- 要使用 el-table 组件原有的属性，直接加在 Table 标签上即可 -->
        <Table ref="tableRef">

            <template #video_url>
                <!-- 在插槽内，您可以随意发挥，通常使用 el-table-column 组件 -->
                <el-table-column prop="video_url" label="视频" width="180" align="center" >

                    <template #default="scope">
                        <el-button size="small" @click="videoPlay( scope.row.video_url)">
                            <div class="fa fa-play"></div>
                        </el-button>
<!--                        <video :src="scope.row.video_url"></video>-->
<!--                            <span style="margin-left: 10px">{{ scope.row.video_url }}</span>-->
                    </template>
                </el-table-column>

            </template>

        </Table>

        <!-- 表单 -->
        <PopupForm :card="props.card"/>

        <el-dialog v-model="dialogVideoVisible" :title="`播放`" width="50%">
            <video width="100%" :src="playUrl" autoplay controls></video>
        </el-dialog>
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
    name: 'business/video',
})
const props = defineProps({
    card: {
        type: Object,
        required: false,
    },
});
const { t } = useI18n()
const tableRef = ref()
const optButtons: OptButton[] = defaultOptButtons(['weigh-sort', 'edit', 'delete'])
const dialogVideoVisible = ref(false)
const playUrl = ref('')
const videoPlay = (video_url)=>{
    // console.log(video_url)
    dialogVideoVisible.value = true;
    playUrl.value = video_url;
    document.querySelector('video').paly()
}
/**
 * baTable 内包含了表格的所有数据且数据具备响应性，然后通过 provide 注入给了后代组件
 */

const baTable = new baTableClass(
    new baTableApi('/admin/business.Video/'),
    {
        pk: 'id',
        column: [
            { type: 'selection', align: 'center', operator: false },
            // { label: t('business.video.id'), prop: 'id', align: 'center', width: 180, operator: 'RANGE', sortable: 'custom' },
            { label: t('business.video.title'), prop: 'title', align: 'center', operatorPlaceholder: t('Fuzzy query'), operator: 'LIKE', sortable: false },
            // { label: t('business.video.card__name'), prop: 'card.name', align: 'center', operatorPlaceholder: t('Fuzzy query'), render: 'tags', operator: 'LIKE' },
            // { label: t('business.video.card__phone'), prop: 'card.phone', align: 'center', operatorPlaceholder: t('Fuzzy query'), render: 'tags', operator: 'LIKE' },
            // { label: t('business.video.card__wechat'), prop: 'card.wechat', align: 'center', operatorPlaceholder: t('Fuzzy query'), render: 'tags', operator: 'LIKE' },

            { label: t('business.video.video_bg_img'), prop: 'video_bg_img', align: 'center', render: 'image', operator: false },
            { label: "视频", prop: 'video_url', align: 'center', operator: 'eq', sortable: false ,render:'slot',slotName: 'video_url'},
            { label: t('business.video.weigh'), prop: 'weigh', align: 'center', operator: 'RANGE', sortable: 'custom' },
            { label: t('business.video.status'), prop: 'status', align: 'center', render: 'switch', operator: 'eq', sortable: false, replaceValue: { '0': t('business.video.status 0'), '1': t('business.video.status 1') } },

            { label: t('business.video.update_time'), prop: 'update_time', align: 'center', render: 'datetime', operator: 'RANGE', sortable: 'custom', width: 160, timeFormat: 'yyyy-mm-dd hh:MM:ss' },
            { label: t('business.video.create_time'), prop: 'create_time', align: 'center', render: 'datetime', operator: 'RANGE', sortable: 'custom', width: 160, timeFormat: 'yyyy-mm-dd hh:MM:ss' },
            { label: t('Operate'), align: 'center', width: 140, render: 'buttons', buttons: optButtons, operator: false },
        ],
        dblClickNotEditColumn: [undefined],
        // data:"dsadsa"
        filter:{
            initKey:'card_id',
            initValue:props.card.id
        }
    },
    {
        defaultItems: { status: '1' },
    }
)

provide('baTable', baTable)

const reloadList = ()=>{
    baTable.table.filter  = {
        initKey:'card_id',
        initValue:props.card.id,
        use_limit:1
    }
    baTable.getIndex()?.then(() => {
        baTable.initSort()
        baTable.dragSort()
    })
}

onMounted(() => {
    baTable.table.ref = tableRef.value
    baTable.mount()
    // console.log(baTable.table)
    reloadList();
})
defineExpose({
    reloadList,
})
</script>

<style scoped lang="scss"></style>
