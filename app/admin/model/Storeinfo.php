<?php

namespace app\admin\model;

use app\common\library\QQMap;
use think\Model;

/**
 * Storeinfo
 */
class Storeinfo extends Model
{
    use ApiScopeTrait;
    // 表名
    protected $name = 'storeinfo';

    // 自动写入时间戳字段
    protected $autoWriteTimestamp = true;
    protected $updateTime = false;

    protected static function onAfterInsert($model): void
    {
        if ($model->weigh == 0) {
            $pk = $model->getPk();
            if (strlen($model[$pk]) >= 19) {
                $model->where($pk, $model[$pk])->update(['weigh' => $model->count()]);
            } else {
                $model->where($pk, $model[$pk])->update(['weigh' => $model[$pk]]);
            }
        }
    }

    public function setAddressAttr($value,$data)
    {
        try{
            $res = QQMap::qeocoderByAddress($value);
            $this->set('lat',$res['result']['location']['lat']);
            $this->set('lng',$res['result']['location']['lng']);
        }catch (\Exception $e){

        }

        return $value;
    }

    /**
     * 写入属性操作
     * @param $data
     * @return void
     * @throws \think\db\exception\DbException
     */
    static protected function onBeforeWrite($data)
    {
        if (!empty($data->address)){
            try{
                $res = QQMap::qeocoderByAddress($data->address);
                $data->set('lat',$res['result']['location']['lat']);
                $data->set('lng',$res['result']['location']['lng']);
            }catch (\Exception $e){

            }
        }
    }

}