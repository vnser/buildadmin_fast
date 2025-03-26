<?php

namespace app\manman\controller;
use app\admin\model\AdminLog;
use app\common\library\Upload;

class Util extends Base
{
    public function upload_img(): void
    {
//        AdminLog::instance()->setTitle(__('upload'));
        $file   = $this->request->file('file');
        $driver = $this->request->param('driver', 'local');
        $topic  = $this->request->param('topic', 'default');
        try {
            $upload     = new Upload();
            $attachment = $upload
                ->setFile($file)
                ->setDriver($driver)
                ->setTopic($topic)
                ->setIsImage(true);

//            print_r($attachment);
            $attachment = $attachment->upload(null,0, $this->auth->user->user_id);
            unset($attachment['create_time'], $attachment['quote']);
        } catch (\Throwable $e) {
            $this->error($e->getMessage());
        }

        $this->success(__('File uploaded successfully'), [
            'file' => $attachment ?? []
        ]);
    }
}