<?php

namespace app\common\model;

use think\model;

class UserScoreLog extends model
{
    protected $name               = '_user_score_log';
    protected $autoWriteTimestamp = true;
    protected $updateTime         = false;
}