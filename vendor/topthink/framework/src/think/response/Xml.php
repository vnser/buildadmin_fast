<?php
// +----------------------------------------------------------------------
// | ThinkPHP [ WE CAN DO IT JUST THINK ]
// +----------------------------------------------------------------------
// | Copyright (c) 2006~2025 http://thinkphp.cn All rights reserved.
// +----------------------------------------------------------------------
// | Licensed ( http://www.apache.org/licenses/LICENSE-2.0 )
// +----------------------------------------------------------------------
// | Author: liu21st <liu21st@gmail.com>
// +----------------------------------------------------------------------
declare(strict_types=1);

namespace think\response;

use think\Collection;
use think\Cookie;
use think\Model;
use think\Response;

/**
 * XML Response
 */
class Xml extends Response
{
    // 输出参数
    protected $options = [
        // 根节点名
        'root_node' => 'think',
        // 根节点属性
        'root_attr' => '',
        //数字索引的子节点名
        'item_node' => 'item',
        // 数字索引子节点key转换的属性名
        'item_key'  => 'id',
        // 数据编码
        'encoding'  => 'utf-8',
    ];

    protected $contentType = 'text/xml';

    public function __construct(Cookie $cookie, $data = '', int $code = 200)
    {
        $this->init($data, $code);
        $this->cookie = $cookie;
    }

    /**
     * 处理数据
     * @access protected
     * @param  mixed $data 要处理的数据
     * @return mixed
     */
    protected function output($data): string
    {
        if (is_string($data)) {
            if (!str_starts_with($data, '<?xml')) {
                $encoding = $this->options['encoding'];
                $xml      = "<?xml version=\"1.0\" encoding=\"{$encoding}\"?>";
                $data     = $xml . $data;
            }
            return $data;
        }

        // XML数据转换
        return $this->xmlEncode($data, $this->options['root_node'], $this->options['item_node'], $this->options['root_attr'], $this->options['item_key'], $this->options['encoding']);
    }

    /**
     * XML编码
     * @access protected
     * @param  mixed $data 数据
     * @param  string $root 根节点名
     * @param  string $item 数字索引的子节点名
     * @param  mixed  $attr 根节点属性
     * @param  string $id   数字索引子节点key转换的属性名
     * @param  string $encoding 数据编码
     * @return string
     */
    protected function xmlEncode($data, string $root, string $item, $attr, string $id, string $encoding): string
    {
        if (is_array($attr)) {
            $array = [];
            foreach ($attr as $key => $value) {
                $array[] = "{$key}=\"{$value}\"";
            }
            $attr = implode(' ', $array);
        }

        $attr = trim($attr);
        $attr = empty($attr) ? '' : " {$attr}";
        $xml  = "<?xml version=\"1.0\" encoding=\"{$encoding}\"?>";
        $xml .= "<{$root}{$attr}>";
        $xml .= $this->dataToXml($data, $item, $id);
        $xml .= "</{$root}>";

        return $xml;
    }

    /**
     * 数据XML编码
     * @access protected
     * @param  mixed  $data 数据
     * @param  string $item 数字索引时的节点名称
     * @param  string $id   数字索引key转换为的属性名
     * @return string
     */
    protected function dataToXml($data, string $item, string $id): string
    {
        $xml = $attr = '';

        if ($data instanceof Collection || $data instanceof Model) {
            $data = $data->toArray();
        }

        foreach ($data as $key => $val) {
            if (is_numeric($key)) {
                $id && $attr = " {$id}=\"{$key}\"";
                $key         = $item;
            }
            $xml .= "<{$key}{$attr}>";
            $xml .= (is_array($val) || is_object($val)) ? $this->dataToXml($val, $item, $id) : $val;
            $xml .= "</{$key}>";
        }

        return $xml;
    }
}
