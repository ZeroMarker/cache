//全局变量定义
var GET_SIGN_SCRIPT          = 1;   //获取笔迹图片
var GET_SIGN_FINGERPRINT     = 2;   //获取指纹图片
var GET_SIGN_CERT            = 3;   //获取事件证书
var GET_SIGN_TIMESTAMP       = 4;   //获取时间戳
var GET_CERT_SIGNER          = 5;   //获取签名人
var GET_SIGN_TIME            = 6;   //获取签名时间
var GET_TS_PLAINDATA         = 7;   //获取时间戳原文
var GET_SIGN_PHOTO           = 8;   //获取签名时拍摄的照片

//非移动版数据签名
function Sign(plaintext, user, cardtype, cardNo)
{
    var idCard =
    {
        Type: cardtype,
        Number: cardNo
    }
    
    var signinfo =
    {
        Signer:user,
        IDCard:idCard
    }
    var inputjson = $.toJSON(signinfo);
    var signvalue = "";
    
    try
    {
        var signvalue = anysign.sign_data(inputjson, plaintext);
    }
    catch(err)
    {
        return 67;
    }
    
    if(signvalue == "")
    {
        var lastError = anysign.getLastError();
        
        return lastError;
    }
    else
    {
        return signvalue;
    }
    
}

function VerifySignature(plaintext, signaturejson)
{
    var signtime = "";
    var verifyStr = "";
    var plaintext;
    
    var ret = anysign.verify_sign_value(signaturejson,plaintext);
    if(ret == 0)
    {
        return ret;
    }
    else
    {
        var lastError = anysign.getLastError();
        return lastError;
    }
}

//移动端签名，推送签名信息
function pushSignInfo(DocName, DocID, UserName, UserID, DoctorName, DoctorID, plaintext, pdfPath)
{
    var signinfo =
    {
        DocName : DocName.split("-")[0],//字符串，文档名称
        DocID : DocID,//字符串，文档编号，业务唯一编号
        UserName : UserName,//字符串，患者姓名
        UserID : UserID,//字符串，患者ID
        DoctorName : DoctorName,//字符串，医生姓名
        DoctorID : DoctorID,//字符串，医生ID
        UserData : plaintext//字符串，附加数据
    }
    var inputjson = $.toJSON(signinfo);
    
    var pushret = "";
    try
    {
        var ba64path = anysign.Base64Encode(pdfPath,"GBK");
        var pdfsha1 = anysign.hash_file(ba64path , 1);
        if (pdfsha1==DocName.split("-")[1])
        {
            pushret = mobilesign.AnySignUploadPdf(inputjson, pdfPath);
        }
        //pushret = mobilesign.AnySignUploadPdf(inputjson, pdfPath);
    }
    catch(err)
    {
        return 67;
    }
    
    return pushret;
}

function getMobileSignStatus(DocName, DocID, UserName, UserID, DoctorName, DoctorID, plaintext)
{
    var signinfo =
    {
        DocName : DocName,
        DocID : DocID,
        UserName : UserName,
        UserID : UserID,
        DoctorName : DoctorName,
        DoctorID : DoctorID,
        UserData : plaintext
    }
    var inputjson = $.toJSON(signinfo);
    
    var signvalue = "";
    try
    {
        var signvalue = mobilesign.AnySignUpdatePdfsStatus(inputjson, 1);
        signvalue = anysign.Base64Decode(signvalue);
    }
    catch(err)
    {
        return 67;
    }
    
    if(signvalue == "")
    {
        //var lastError = anysign.getLastError();
        var lastError = mobilesign.AnySignGetLastError()
        return lastError;
    }
    else
    {
        var delret = deletePDF(inputjson);
        if(delret == 0)
        {
            //alert("删除PDF成功");
            return signvalue
        }
        else
        {
            alert("查询签名状态错误，错误码 = " + delret);
            return 1000;
        }
    }
}

function getSignCount(signvalue)
{
    return anysign.get_count_signature(signvalue)
}

function getScatterSign(signvalue,signindex)
{
    return anysign.get_index_signature(signvalue,signindex);
}

function deletePDF(inputjson)
{
    var delret = mobilesign.AnySignDeletePdfs(inputjson);
    return delret;
}

//function getSignInfo(signvalue, infotype, plaintext,infoindex)
function getSignInfo(signvalue, infotype, plaintext)
{
    if(infotype == "1")
    {
        var scriptimage = anysign.get_sign_script(signvalue, 1);
        if(scriptimage == "")
        {
            //alert("获取笔迹图片失败");
            var lastError = anysign.getLastError();
            
            return lastError;
        }
        
        return scriptimage;
    }
    
    if(infotype == "2")
    {
        var fingerimage = anysign.get_sign_fingerprint(signvalue, 2);
        if(fingerimage == "")
        {
            var lastError = anysign.getLastError();
            
            //alert("获取指纹图片失败");
            return lastError;
        }
        
        return fingerimage;
    }
    
    if(infotype == "3")
    {
        //事件证书
        var signCert = anysign.get_sign_cert(signvalue);
        if(signCert != "")
        {
            return signCert;
        }
        else
        {
            var lastError = anysign.getLastError();
            
            return lastError;
        }
    }
    
    if(infotype == "4")
    {
        var tsvalue = anysign.get_ts_value(signvalue);
        if(tsvalue == "")
        {
            var lastError = anysign.getLastError();
            
            return lastError;
        }
        return tsvalue;
    }
    
    if(infotype == "5")
    {
        var csvalue = anysign.get_cert_signer(signvalue);
        if(csvalue == "")
        {
            var lastError = anysign.getLastError();
            
            return lastError;
        }
        return csvalue
    }
    
    if(infotype == "6")
    {
        var signtime = anysign.get_sign_time(signvalue);
        if(signtime == "")
        {
            var lastError = anysign.getLastError();
            
            return lastError;
        }
        return signtime;
    }
    
    if(infotype == "7")
    {
        var tsplaindata = anysign.get_ts_plaindata(signvalue, plaintext);
        if(tsplaindata == "")
        {
            var lastError = anysign.getLastError();
            
            return lastError;
        }
        return tsplaindata;
    }
    
     if(infotype == "8")
    {
        var photoCount = anysign.get_count_sign_photo(signvalue);
        //var signvalue = signRet3;
        if(photoCount>0)
        {
            var patphoto = anysign.get_sign_photo(signvalue, 0);
            if(patphoto == "")
            {
                var lastError = anysign.getLastError();
                
                return lastError;
            }
            return patphoto;
        }
    }
}

function errorInfo(errCode)
{
    var errInfo = "";
    
    switch(errCode)
    {
        case 0  :
            errInfo = '操作正常';
            break;
        case 1  :
            errInfo = '输入json为空';
            break;
        case 2  :
            errInfo = '输入json解析失败';
            break;
        case 3  :
            errInfo = 'IDCard解析失败';
            break;
        case 4  :
            errInfo = 'IDCard不是object';
            break;
        case 5  :
            errInfo = '证件类型不是字符串';
            break;
        case 6  :
            errInfo = '证件号码不是字符串';
            break;
        case 7  :
            errInfo = '指纹图片数据为空';
            break;
        case 8  :
            errInfo = '手写轨迹图片为空';
            break;
        case 9  :
            errInfo = 'DeviceID为空';
            break;
        case 10 :
            errInfo = '获取手写图片失败';
            break;
        case 11 :
            errInfo = '获取指纹图片失败';
            break;
        case 12 :
            errInfo = '加密后BIO_FEATURE数据为空';
            break;
        case 13 :
            errInfo = '加密BIO_FEATURE数据失败';
            break;
        case 14 :
            errInfo = '签名人不是字符串';
            break;
        case 15 :
            errInfo = 'init_XTX失败';
            break;
        case 16 :
            errInfo = '获取的签名值为空';
            break;
        case 17 :
            errInfo = '获取签名值失败';
            break;
        case 18 :
            errInfo = '申请证书失败';
            break;
        case 19 :
            errInfo = '时间戳为空';
            break;
        case 20 :
            errInfo = '请求时间戳失败';
            break;
        case 21 :
            errInfo = '打开安全签名板失败，请检查签名板是否连接正常！';
            break;
        case 22 :
            errInfo = '事件证书为空';
            break;
        case 23 :
            errInfo = '证书请求数据为空';
            break;
        case 24 :
            errInfo = 'Init AnySignClient失败';
            break;
        case 25 :
            errInfo = '手写轨迹数据为空';
            break;
        case 26 :
            errInfo = '签名包数据为空';
            break;
        case 27 :
            errInfo = '对称解密失败';
            break;
        case 28 :
            errInfo = '对称解密返回数据为空';
            break;
        case 29 :
            errInfo = '解析BioFeature失败';
            break;
        case 30 :
            errInfo = '输入的签名包为空';
            break;
        case 31 :
            errInfo = '输入的原文为空';
            break;
        case 32 :
            errInfo = '解析输入的签名包数据格式错误';
            break;
        case 33 :
            errInfo = '签名值验证失败';
            break;
        case 34 :
            errInfo = '获取证书内容数据失败';
            break;
        case 35 :
            errInfo = '使用不支持的图片格式';
            break;
        case 36 :
            errInfo = '设置笔迹宽度和颜色失败';
            break;
        case 37 :
            errInfo = '设置signDevice失败';
            break;
        case 38 :
            errInfo = 'showdialog失败';
            break;
        case 39 :
            errInfo = '获取手写指纹信息失败';
            break;
        case 40 :
            errInfo = '设置adaptor对象失败';
            break;
        case 41 :
            errInfo = '设置证件类型失败';
            break;
        case 42 :
            errInfo = '设置证件号码失败';
            break;
        case 43 :
            errInfo = '设置签名人姓名失败';
            break;
        case 44 :
            errInfo = '设置原文数据失败';
            break;
        case 45 :
            errInfo = '设置crypto对象失败';
            break;
        case 46 :
            errInfo = '构造证书请求格式json失败';
            break;
        case 47 :
            errInfo = '获取证书请求失败';
            break;
        case 48 :
            errInfo = '签名包中EventCert为空';
            break;
        case 49 :
            errInfo = '签名包中TSValue为空';
            break;
        case 50 :
            errInfo = '输入的签名算法不是有效参数';
            break;
        case 51 :
            errInfo = '获取签名包数据中指纹图片为空';
            break;
        case 52 :
            errInfo = '获取签名包手写轨迹图片为空';
            break;
        case 53 :
            errInfo = '计算Biofeature哈希失败';
            break;
        case 54 :
            errInfo = 'Biofeatur哈希值为空';
            break;
        case 55 :
            errInfo = '设置bio_hash失败';
            break;
        case 56 :
            errInfo = '获取证书中BIO_HASH失败';
            break;
        case 57 :
            errInfo = '或者证书BIO_HASH内容为空';
            break;
        case 58 :
            errInfo = '比较证书BIO_HASH失败';
            break;
        case 59 :
            errInfo = '没有检测到签名设备';
            break;
        case 60 :
            errInfo = '签名设备不是安全签名板,当前只支持安全签名板';
            break;
        case 61 :
            errInfo = '用户取消签名';
            break;
        case 62 :
            errInfo = '获取证书签名人失败';
            break;
        case 63 :
            errInfo = '获取证书签名人为空';
            break;
        case 64 :
            errInfo = '证件类型不正确';
            break;
        case 65 :
            errInfo = '解析后的json不是json object';
            break;
        case 66 :
            errInfo = '签名时间数据为空';
            break;
        case 67 :
            errInfo = "请检查客户端环境是否安装！";
            break;
        //case 67:
        //    errInfo = "创建签名句柄失败";
        //    break;
        case 68:
            errInfo = "输入的签名句柄为空";
            break;
        case 69:
            errInfo = "调用sign_begin接口失败";
            break;
        case 70:
            errInfo = "输入的文件名为空";
            break;
        case 71:
            errInfo = "base64解码失败";
            break;
        case 72:
            errInfo = "输入的文件太大，无法签名或者验证。";
            break;
        case 73:
            errInfo = "未输入签名人姓名";
            break;
        case 74:
            errInfo = "未输入签名人证件信息";
            break;
        case 75:
            errInfo = "输入的时间戳签名值为空";
            break;
        case 76:
            errInfo = "输入的时间戳原文为空";
            break;
        case 77:
            errInfo = "格式化时间戳时间失败";
            break;
        case 78:
            errInfo = "验证时间戳签名失败";
            break;
        case 79:
            errInfo = "读取文件内容失败";
            break;
        case 80:
            errInfo = "验证证书有效性失败";
            break;
        case 81:
            errInfo = "获取时间戳原文为空";
            break;
        case 82:
            errInfo = "对图像进行缩放发生错误";
            break;
        case 83:
            errInfo = "对图像进行格式转换发生错误";
            break;
        case 84:
            errInfo = "未连接扩展屏";
            break;
        case 85:
            errInfo = "不支持的扩展屏型号";
            break;
        case 86:
            errInfo = "解析证书中的哈希值失败";
            break;
        case 87:
            errInfo = "比较证书中的哈希与手写笔迹哈希失败";
            break;
        case 88:
            errInfo = "设置签名对话框宽度不正确";
            break;
        case 89:
            errInfo = "加载签名界面配置失败";
            break;
        case 90:
            errInfo = "获取照片失败";
            break;
        case 91:
            errInfo = "获取视频失败";
            break;
        case 92:
            errInfo = "打开摄像头失败";
            break;
        case 93:
            errInfo = "拍照失败";
            break;
        case 94:
            errInfo = "照片存储路径错误";
            break;
        case 95:
            errInfo = "录音存储路径错误";
            break;
        case 96:
            errInfo = "录像存储路径错误";
            break;
        case 97:
            errInfo = "打开麦克风失败";
            break;
        case 98:
            errInfo = "未找到编码器xvid";
            break;
        case 99:
            errInfo = "签名板未打开";
            break;
        case 100:
            errInfo = "签名板已经打开";
            break;
        case 101:
            errInfo = "访问签名板失败";
            break;
        case 102:
            errInfo = "签名板服务程序未启动";
            break;
        case 103:
            errInfo = "签名板服务程序错误";
            break;
        case 104:
            errInfo = "签名板被移除";
            break;
        case 105:
            errInfo = "缺少证据信息";
            break;
        case 1000:
            errInfo = "该文档未签署";
            break;
        case 10051:
            errInfo = "没有在服务器查询到签名信息，请先生成待签文档";
            break;
        default:
            errInfo = "未知错误：" + errCode;
            break;
    }
    
    return errInfo;
}