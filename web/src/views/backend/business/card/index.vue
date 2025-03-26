<template>
    <div class="default-main ba-table-box">
        <el-alert class="ba-table-alert" v-if="baTable.table.remark" :title="baTable.table.remark" type="info" show-icon />

        <!-- 表格顶部菜单 -->
        <!-- 自定义按钮请使用插槽，甚至公共搜索也可以使用具名插槽渲染，参见文档 -->
        <TableHeader
            :buttons="['refresh', 'add', 'edit', 'delete', 'comSearch']"
            :quick-search-placeholder="t('Quick search placeholder', { fields: t('business.card.quick Search Fields') })"
        ></TableHeader>

        <!-- 表格 -->
        <!-- 表格列有多种自定义渲染方式，比如自定义组件、具名插槽等，参见文档 -->
        <!-- 要使用 el-table 组件原有的属性，直接加在 Table 标签上即可 -->
        <Table ref="tableRef">

            <template #phone_info>
                <!-- 在插槽内，您可以随意发挥，通常使用 el-table-column 组件 -->
                <el-table-column prop="video_url" label="联系方式" width="460" align="center" >

                    <template #default="scope">
                        <div style="float:left;width: 70%;text-align: left;font-size: 12px">
                            <img :src="scope.row.phone_icon" alt="" style="width:20px"> 电话：{{scope.row.phone}}<br>
                            <img :src="scope.row.wechat_icon" alt="" style="width:20px"> 微信：{{scope.row.wechat}}<br>
                            <img :src="scope.row.address_icon" alt="" style="width:20px"> 地址：{{scope.row.address}}<br>
                        </div>
                        <div style="float: right">
                            <img :src="scope.row.wechat_qrcode" alt="" style="width: 80px">
                        </div>
                        <!--                        <video :src="scope.row.video_url"></video>-->
                        <!--                            <span style="margin-left: 10px">{{ scope.row.video_url }}</span>-->
                    </template>
                </el-table-column>

            </template>

        </Table>

        <!-- 表单 -->
        <PopupForm />

        <el-dialog v-model="dialogFormVisible" :title="`视频列表 - ${selectCard.name}`" width="80%">
           <videos :card="selectCard" ref="videosRef"/>
        </el-dialog>

        <el-dialog v-model="dialogFormImageVisible" :title="`图片集 - ${selectCard.name}`" width="98%">

           <galleryimgs :card="selectCard" ref="galleryimgsRef"/>

        </el-dialog>

        <el-dialog v-model="dialogQrcodeVisible" :title="`访问小程序码- ${selectCard.name}`" width="340px">
<!--            <galleryimgs :card="selectCard" ref="galleryimgsRef"/>-->
            <div style="width: 200px;margin: 0 auto">
                <img :src="cardQrcode" style="width: 100%"/>
            </div>


            <el-descriptions title="小程序信息"
                             :column="1"
                             :size="'small'"
                             border>
            <el-descriptions-item>
                <template #label>
                    <div class="cell-item">
                        <el-icon :style="iconStyle">
                            <user />
                        </el-icon>
                        访问路径
                    </div>
                </template>
                /pages/cardDetail/index
            </el-descriptions-item>
                <el-descriptions-item>
                <template #label>
                    <div class="cell-item">
                        <el-icon :style="iconStyle">
                            <user />
                        </el-icon>
                        访问参数
                    </div>
                </template>
                    cardId={{selectCard.id}}
            </el-descriptions-item>
                <el-descriptions-item>
                <template #label>
                    <div class="cell-item">
                        <el-icon :style="iconStyle">
                            <user />
                        </el-icon>
                        Scheme
                    </div>
                </template>
                    <div style="white-space: break-spaces;word-break: break-all"> {{cardScheme}}</div>

            </el-descriptions-item>

            </el-descriptions>
        </el-dialog>
    </div>
</template>

<script setup lang="ts">
import {nextTick, onMounted, provide, ref, watch} from 'vue'
import { useI18n } from 'vue-i18n'
import PopupForm from './popupForm.vue'
import { baTableApi } from '/@/api/common'
import { defaultOptButtons } from '/@/components/table'
import TableHeader from '/@/components/table/header/index.vue'
import Table from '/@/components/table/index.vue'
import baTableClass from '/@/utils/baTable'
import videos from '../video/index.vue'
import galleryimgs from '../galleryimgs/index.vue'
import {mergeMessage} from "/@/lang";
import createAxios from "/@/utils/axios";
defineOptions({
    name: 'business/card',
})
const dialogFormVisible = ref(false)
const dialogFormImageVisible = ref(false)
const dialogQrcodeVisible = ref(false)
const selectCard = ref({});
const cardQrcode = ref('');
const cardScheme = ref('');
const { t } = useI18n()
const tableRef = ref()
const videosRef = ref()
const galleryimgsRef = ref()
let optButtons: OptButton[] = defaultOptButtons(['edit', 'delete'])

const getQrcodeLoad = ref(false)

let newButton: OptButton[] = [
    {
        // 渲染方式:tipButton=带tip的按钮,confirmButton=带确认框的按钮,moveButton=移动按钮
        render: 'tipButton',
        // 按钮名称
        name: 'info',
        // 鼠标放置时的 title 提示
        title: '名片小程序码',
        // 直接在按钮内显示的文字，title 有值时可为空
        text: '',
        // 按钮类型，请参考 element plus 的按钮类型
        type: 'primary',
        // 按钮 icon
        icon: 'fa fa-qrcode',
        class: 'table-row-info',
        attr:{
            loading:getQrcodeLoad
        },
        // 自定义点击事件
        click: (row: TableRow, field: TableColumn) => {
            getQrcodeLoad.value = true
            selectCard.value = row
            // console.log({card_id:selectCard.value.id})
            createAxios<TableDefaultData>({
                url: '/admin/business.card/qrcode',
                method: 'post',
                data: {card_id:selectCard.value.id},
            }).then((res)=>{
                getQrcodeLoad.value = false
                if (res.code){
                    dialogQrcodeVisible.value = true
                    cardQrcode.value = res.data.src
                    cardScheme.value = res.data.scheme
                }
                // console.log(res)
                })

        },
    },
    {
        // 渲染方式:tipButton=带tip的按钮,confirmButton=带确认框的按钮,moveButton=移动按钮
        render: 'tipButton',
        // 按钮名称
        name: 'info',
        // 鼠标放置时的 title 提示
        title: '视频列表',
        // 直接在按钮内显示的文字，title 有值时可为空
        text: '',
        // 按钮类型，请参考 element plus 的按钮类型
        type: 'primary',
        // 按钮 icon
        icon: 'fa fa-file-video-o',
        class: 'table-row-info',
        // 自定义点击事件
        click: (row: TableRow, field: TableColumn) => {
            dialogFormVisible.value = true
            selectCard.value = row
            nextTick( ()=>{
                console.log(videosRef.value.reloadList())
            })
        },
    },
    {
        // 渲染方式:tipButton=带tip的按钮,confirmButton=带确认框的按钮,moveButton=移动按钮
        render: 'tipButton',
        // 按钮名称
        name: 'info',
        // 鼠标放置时的 title 提示
        title: '图片集',
        // 直接在按钮内显示的文字，title 有值时可为空
        text: '',
        // 按钮类型，请参考 element plus 的按钮类型
        type: 'primary',
        // 按钮 icon
        icon: 'fa fa-file-photo-o',
        class: 'table-row-info',
        // 自定义点击事件
        click: (row: TableRow, field: TableColumn) => {
            dialogFormImageVisible.value = true
            selectCard.value = row
            nextTick( ()=>{
                console.log(galleryimgsRef.value.reloadList())
            })
        },
    },
]

// 新按钮合入到默认的按钮数组
optButtons = newButton.concat(optButtons)
/**
 * baTable 内包含了表格的所有数据且数据具备响应性，然后通过 provide 注入给了后代组件
 */
const baTable = new baTableClass(
    new baTableApi('/admin/business.Card/'),
    {
        pk: 'id',
        column: [
            { type: 'selection', align: 'center', operator: false },
            { label: t('business.card.id'), prop: 'id', align: 'center', width: 70, operator: false, sortable: 'custom' },
            { label: t('business.card.name'), prop: 'name', align: 'center',width: 90, operatorPlaceholder: t('Fuzzy query'), operator: 'LIKE', sortable: false },
            { label:"主题色", prop: 'theme_color', align: 'center',width: 90, render: 'color', operator: false },
            // { label: "头像", prop: 'avatar', align: 'center', render: 'image', operator: false },
            { label: t('business.card.banner'), prop: 'banner', align: 'center', render: 'images', operator: false , width: 160},
            // { label: "分组", prop: 'banner', align: 'center', render: 'images', operator: false , width: 160},
            { label: "分组", prop: 'classify.string', align: 'center', render: 'tags', operator: false ,width:160},
            { label:"分组", prop: 'classify_ids', align: 'center', operator: 'FIND_IN_SET', show: false, comSearchRender: 'remoteSelect', remote: { pk: 'zb_business_classify.id', field: 'string', remoteUrl: '/admin/business.Classify/index', multiple: true } },
            { label: t('business.card.phone'), prop: 'phone',align: 'center', operatorPlaceholder: t('Fuzzy query'), operator: 'LIKE', sortable: false,render:'slot',slotName: 'phone_info' },
            // { label: t('business.card.wechat'), prop: 'wechat', align: 'center', operatorPlaceholder: t('Fuzzy query'), operator: 'LIKE', sortable: false },
            // { label: t('business.card.address'), prop: 'address', align: 'center', operatorPlaceholder: t('Fuzzy query'), operator: 'LIKE', sortable: false },
            // { label: t('business.card.latitude'), prop: 'latitude', align: 'center', operatorPlaceholder: t('Fuzzy query'), operator: 'LIKE', sortable: false },
            // { label: t('business.card.longitude'), prop: 'longitude', align: 'center', operatorPlaceholder: t('Fuzzy query'), operator: 'LIKE', sortable: false },
            // { label: t('business.card.phone_icon'), prop: 'phone_icon', align: 'center', render: 'image', operator: false },
            // { label: t('business.card.wechat_icon'), prop: 'wechat_icon', align: 'center', render: 'image', operator: false },
            // { label: t('business.card.address_icon'), prop: 'address_icon', align: 'center', render: 'image', operator: false },
            { label:"状态", prop: 'status', align: 'center', render: 'switch', operator: 'eq', sortable: false, replaceValue: { '0': t('business.video.status 0'), '1': t('business.video.status 1') },width:100 },
            { label: t('business.card.createtime'), prop: 'createtime', align: 'center', render: 'datetime', operator: 'RANGE', sortable: 'custom', width: 160, timeFormat: 'yyyy-mm-dd hh:MM:ss' },
            // { label: t('business.card.updatetime'), prop: 'updatetime', align: 'center', render: 'datetime', operator: 'RANGE', sortable: 'custom', width: 160, timeFormat: 'yyyy-mm-dd hh:MM:ss' },
            { label: t('Operate'), align: 'center',  render: 'buttons', buttons: optButtons, operator: false },
        ],
        dblClickNotEditColumn: [undefined],
    },
    {
        defaultItems: { content: '',theme_color:'#2982E1' ,status:1},
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
    //加载语言
    window.loadLangHandle['./backend/zh-cn/business/video.ts']().then((res)=>{
        mergeMessage(res.default, 'business/video')
    })

    window.loadLangHandle['./backend/zh-cn/business/galleryimgs.ts']().then((res)=>{
        mergeMessage(res.default, 'business/galleryimgs')
    })
    // console.log('baTable', baTable)
})
</script>

<style scoped lang="scss"></style>
