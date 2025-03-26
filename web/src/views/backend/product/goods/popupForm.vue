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
                    <FormItem :label="t('product.goods.title')" type="string" v-model="baTable.form.items!.title"
                              prop="title" :placeholder="t('Please input field', { field: t('product.goods.title') })"/>
                    <FormItem :label="t('product.goods.price')" type="string" prop="price"
                              v-model="baTable.form.items!.price"
                              :placeholder="t('Please input field', { field: t('product.goods.price') })"/>

                    <FormItem :label="t('product.goods.core_param')" type="string" prop="core_param"
                              v-model="baTable.form.items!.core_param"
                              :placeholder="t('Please input field', { field: t('product.goods.core_param') })"/>
                    <FormItem :label="t('product.goods.product_classify_ids')"

                              v-model="baTable.form.items!.product_classify_ids" prop="product_classify_ids"
                              type="remoteSelects"
                              :input-attr="{ pk: 'mm_product_classify.id', field: 'categories_batch_name', remoteUrl: '/admin/product.Classify/index?goods_select=1&isTree=true' }"
                              :placeholder="t('Please select field', { field: t('product.goods.product_classify_ids') })"/>
                    <FormItem :label="t('product.goods.images')" type="images" v-model="baTable.form.items!.images"
                              blockHelp="建议尺寸：1125x777"
                              prop="images"/>
                    <FormItem :label="t('product.goods.status')" type="switch" v-model="baTable.form.items!.status"
                              prop="status"
                              :input-attr="{ content: { '0': t('product.goods.status 0'), '1': t('product.goods.status 1') } }"/>
                    <FormItem :label="t('product.goods.weigh')" type="number" prop="weigh" :input-attr="{ step: 1 }"
                              v-model.number="baTable.form.items!.weigh"
                              :placeholder="t('Please input field', { field: t('product.goods.weigh') })"/>

                    <el-form-item label="回收属性" label-position="right" prop="goods_attr">
                        <el-button @click="addAttr">+ 增加</el-button>
                        <el-table :data="baTable.form.items!.goods_attr" style="width: 100%">
                            <el-table-column prop="name" label="名称" width="180">
                                <template #default="scope">
                                    <el-form-item :prop="`goods_attr.${scope.$index}.name`" :rules="rules.goods_attr_name">
                                         <el-input v-model="scope.row.name" placeholder="名称项"></el-input>
                                    </el-form-item>
                                </template>
                            </el-table-column>
                            <el-table-column prop="price" label="价格" width="180">
                                <template #default="scope">
                                    <el-form-item :prop="`goods_attr.${scope.$index}.payback_price`" :rules="rules.goods_attr_price">
                                        <el-input v-model="scope.row.payback_price"  placeholder="回收价格"></el-input>
                                    </el-form-item>
                                </template>
                            </el-table-column>
                            <el-table-column prop="price" label="单位" width="180">
                                <template #default="scope">
                                    <el-form-item :prop="`goods_attr.${scope.$index}.unit`" :rules="rules.goods_attr_unit">
                                        <el-input v-model="scope.row.unit"  placeholder="单位"></el-input>
                                    </el-form-item>
                                </template>
                            </el-table-column>
                            <el-table-column prop="address" label="操作">
                                <template #default="scope">

                                    <el-button @click="delAttr( scope.$index)"><i class="fa fa-trash-o"></i></el-button>
                                </template>

                            </el-table-column>
                        </el-table>
                    </el-form-item>
                </el-form>
            </div>
        </el-scrollbar>
        <template #footer>
            <div :style="'width: calc(100% - ' + baTable.form.labelWidth! / 1.8 + 'px)'">
                <el-button @click="baTable.toggleForm()">{{ t('Cancel') }}</el-button>
                <el-button v-blur :loading="baTable.form.submitLoading" @click="submit(formRef)"
                           type="primary">
                    {{
                        baTable.form.operateIds && baTable.form.operateIds.length > 1 ? t('Save and edit next item') : t('Save')
                    }}
                </el-button>
            </div>
        </template>
    </el-dialog>
</template>

<script setup lang="ts">
import type {FormInstance, FormItemRule} from 'element-plus'
import {inject, reactive, ref} from 'vue'
import {useI18n} from 'vue-i18n'
import FormItem from '/@/components/formItem/index.vue'
import {useConfig} from '/@/stores/config'
import type baTableClass from '/@/utils/baTable'

const config = useConfig()
const formRef = ref<FormInstance>()
const baTable = inject('baTable') as baTableClass

const {t} = useI18n()
// const delAttrData = ref([]);
const addAttr = () => {
    baTable.form.items!.goods_attr.push({
        payback_price: '',
        name: ''
    })
}

const delAttr = (indexToRemove)=>{
    // console.log(indexToRemove)
    let del = baTable.form.items!.goods_attr[indexToRemove]
    if (del.id){
        if (!baTable.form.items!.delattr){
            baTable.form.items!.delattr = []
        }
        baTable.form.items!.delattr.push(del)
    }
    baTable.form.items!.goods_attr = baTable.form.items!.goods_attr.filter((_, index) => index !== indexToRemove);

}


const submit = () => {
    baTable.form.items!.isattr = 1
    baTable.onSubmit(formRef.value)
}
const rules: Partial<Record<string, FormItemRule[]>> = reactive({
    price: [
        // buildValidatorData({name: 'number', title: t('product.goods.price')}),
        { required: true, message: '请输入金额', trigger: 'change' }
    ],
    title: [
        { required: true, message: '请输入标题', trigger: 'change' }
    ],
    product_classify_ids: [
        { required: true, message: '请选择分类', trigger: 'change' }
    ],
    images: [
        { required: true, message: '请选择产品图', trigger: 'change' }
    ],
    // weigh: [
    //     { required: true, message: '请输入排序值', trigger: 'change' }
    // ],
/*    goods_attr: [
        { required: true, message: '请添加回收属性', trigger: 'change' }
    ],*/
    goods_attr_price: [
        { required: true, message: '请添加回收属性价格', trigger: 'change' }
    ],
    goods_attr_name: [
        { required: true, message: '请添加回收属性项', trigger: 'change' }
    ],
    goods_attr_unit: [
        { required: true, message: '请添加回收属性项', trigger: 'change' }
    ],
    // create_time: [buildValidatorData({name: 'date', title: t('product.goods.create_time')})],
})
</script>

<style scoped lang="scss"></style>
