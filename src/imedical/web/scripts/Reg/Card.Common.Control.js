/*
CreateDate: 2023-02-02
FileName:   scripts/Reg/Card.Common.Control.js
Description: * 重新设计封装中间层,独立出对外方法+内部方法
             * 封装方法,统一管理第三方接口调用,参照 产品配置->医生站配置->外部接口测试->对外接口接入管理下的关联开启数据
             * 第三方调用与卡类型的关联关系，详见 产品配置->患者主做引管理->卡类型配置(外部卡关联、外部卡号可为空等)
             * 调用逻辑: 业务层(具体界面js) --> 中间层(本js)  -->  接口层(对接对外接口js)
             * 本js为中间层js
☆☆☆ 中间层js调用说明 ☆☆☆
    ● InterfaceArr: 存储第三方接口对象，此数组会在加载各接口层的时候赋值
        接口层示例: CardCardCommon_ControlObj.InterfaceArr.push(TZWYElecCardObj)
    ● Init: 初始化方法
        业务层调用方式: CardCommon_ControlObj.Init(argObj);
        返回值: 统一返回false
    ● GetQRPatInfo: 根据卡号二维码等获取患者信息【建卡】
        业务层调用方式: CardCommon_ControlObj.GetQRPatInfo(argObj);
    ● PrintQRCode: 打印卡二维码(条码)【建卡】
        业务层调用方式: CardCommon_ControlObj.PrintQRCode(argObj);
        返回值: 打印失败false, 打印成功true
        说明: 入参中的卡类型如果传空,默认打外部卡条码
    ● ReadQRCard: 通过二维码(或弹窗扫码)获取卡号【非建卡界面】
        业务层调用方式: CardCommon_ControlObj.ReadQRCard(argObj);
        返回值: 失败flse, 成功: 0^实际卡号^校验码(空)
        说明: 默认通过二维码等获取卡号信息
             当卡类型卡号等信息为空时，可弹窗扫码,此时卡类型读卡方式为:Read Card,读卡设备为空【选做功能,用于项目需要点击读卡弹窗扫码】(如果卡类型对应多个接口层,每个js应都有ReadMagCard方法。卡类型卡号为空的判断条件,应只写在最后一个接口层里。)
    ● Interface: 项目个性化接口:用于项目不按标版流程或需新增接口
        业务层调用方式: CardCommon_ControlObj.Interface(func,argObj); 
                    调用接口层中 obj.Funcs[func]方法
        入参：func: 个性化方法 方法名,命名要和接口层Funcs中方法对应起来。如 "QCodeRegClick"注册电子健康卡
            argObj: 入参对象
        返回值: 失败: false,成功: 其他有效值(和业务层代码对应)
    ● UtilFuns: 工具类(内部调用)    
        CallInterface: 调用接口层方法处理
        GetQRCardFlag: 判断是否开启外部卡关联(根据卡类型卡号等判断是否为当前js对应卡类型)
        AnalysisArg: 解析入参匹配外部方法,并调用接口层代码

依赖的js(接口层)(若需要使用对应封装的接口方法): 
    卡管理: scripts/dhcdoc/interface/"_LinkObj.CompanyCode_"/"_LinkObj.ModuleCode_".js
*/

/*
☆☆☆ 接口层调用说明： ☆☆☆
js名称: 
    ● scripts/dhcdoc/interface/"_LinkObj.CompanyCode_"/"_LinkObj.ModuleCode_".js
    LinkObj.CompanyCode: 厂商代码
    LinkObj.ModuleCode: 模块代码
注意事项: 
    ● 报错弹窗在接口层js
入参说明:
    ● 接口层入参要和 业务层对象的属性名一一对应,且名称一致
方法说明:
    ● Name: 配置页面的厂家代码_模块代码
        (必有)
    ● Init: 界面初始化
        返回值: 统一返回false
    ● GetQRCardFlag: 无卡类型时，根据卡号等判断是否为当前js对应卡类型【其他业务界面,HISUI版本无卡类型】中间层使用
        (必有)
        入参:   CardTypeDR: 卡类型id,(可能为空)，       
                CardNo: 卡号(二维码信息), 
        返回值: 否false, 是true    
    ● GetQRPatInfo: 根据卡号二维码等获取患者信息【建卡】
        (必有)
        入参:   medStepCode: 诊疗环节(必须,由各个界面csp传入,业务层js不传入)
                    详情见 web.UDHCCardCommLinkRegister.GetCardHardInfo 方法入参说明
                CardTypeDR: 卡类型id, 
                CardNo: 卡号(二维码信息), 
        返回值: 失败false, 成功: XML患者信息串(包含CardNo节点),用于填充建卡界面
            XML串: <gRoot><CardNo></CardNo><Name></Name><Sex></Sex><Birth></Birth><TelHome></TelHome><Address></Address><ProvinceInfoLookUpRowID></ProvinceInfoLookUpRowID><CityDescLookUpRowID></CityDescLookUpRowID><CityAreaLookUpRowID></CityAreaLookUpRowID><NationDescLookUpRowID></NationDescLookUpRowID><Vocation></Vocation></gRoot>
    ● PrintQRCode: 打印电子健康卡【建卡】
        入参：  CardTypeDR  卡类型id, 
                CardNo: 卡号, 
                PatientID: 病人表id
        返回值：打印失败false, 打印成功true
    ● ReadQRCard: 读卡(或通过二维码等)获取卡号【其他业务界面】
        (必有)
        入参:   medStepCode: 诊疗环节(必须,由各个界面csp传入,业务层js不传入)
                    详情见 web.UDHCCardCommLinkRegister.GetCardHardInfo 方法入参说明
                CardTypeDR: 卡类型id, 
                CardNo: 卡号(二维码信息), 
        返回值: 失败: 非0^失败原因(可为空) "-200"卡无效 "-201"卡有效无帐户,
                成功: 0^实际卡号^校验码(空)
        说明:   1. 默认通过二维码等获取卡号信息
                2. 当卡类型卡号等信息为空时，可弹窗扫码,此时卡类型读卡方式为:Read Card,读卡设备为空【选做功能,用于项目需要点击读卡弹窗扫码】(如果卡类型对应多个接口层,每个js应都有ReadMagCard方法。卡类型卡号为空的判断条件,应只写在最后一个接口层里。)
                3. 如果his无卡，可考虑调用后台自动建卡(接口层自行写逻辑)
    ● Funcs: 项目个性化接口
        入参：和业务层js入参对象一一对应
        返回值: 失败false,成功: 其他有效值(和业务层代码对应)
        说明:   如"QCodeRegClick"调用第三方外部卡保存接口,具体方法根据实际情况定义。
                    返回卡类型串(CardTypeDR_"^"_$g(^DHCCARDTYPEDef(CardTypeDR)) $  卡号)
简要示例：
$(function () {
    if (typeof CardCommon_ControlObj != "object") return;
    if (typeof CardCommon_ControlObj.InterfaceArr != "object") return;
    var TZWYElecCardObj = {
        Name: "TongZhiWeiYe_DZJKK",
        Init: function () {},
        GetQRCardFlag: function (CardTypeDR, CardNo) {},
        GetCardInfo: function (medStepCode, CardTypeDR, CardNo) {},
        SaveCardInfo: function (CardTypeDR, CardNo) {},
        PrintQRCode: function (CardTypeDR, CardNo, PatientID) {},
        
        ReadQRCard: function (medStepCode, CardTypeDR, CardNo) {},
        // 项目新增接口
        Funcs: {
            GetCardNoByPatInfo: function (para1,para2,……) {},
            GetCardNoByPatInfo2: function(para1,para2,……) {},
            ……
        }
    };
    CardCommon_ControlObj.InterfaceArr.push(TZWYElecCardObj);
});
*/

//接口函数封装
var CardCommon_ControlObj = (function () {
    // 接口方法,此数组会在加载各接口层的时候填充
    var InterfaceArr = new Array();

    // 全局初始化
    function Init() {
        var re = /function\s*(\w*)/i;
        var MethodName = re.exec(arguments.callee.toString())[1];  // 当前函数方法名
        var argObj = {};
        var rtn = UtilFuns.CallInterface(MethodName, argObj);
        return rtn;
    };

    // 根据卡信息获取患者信息[用于填充建卡界面],失败返回false,成功返回患者信息XML串
    function GetQRPatInfo(argObj) {
        var re = /function\s*(\w*)/i;
        var MethodName = re.exec(arguments.callee.toString())[1];  // 当前函数方法名
        var PatInfo = UtilFuns.CallInterface(MethodName, argObj);
        return PatInfo;
    }

    // 打印卡信息
    function PrintQRCode(argObj) {
        var re = /function\s*(\w*)/i;
        var MethodName = re.exec(arguments.callee.toString())[1];  // 当前函数方法名
        var rtn = UtilFuns.CallInterface(MethodName, argObj);
        return rtn;
    }

    // 通过二维码等获取卡号
    function ReadQRCard(argObj) {
        var re = /function\s*(\w*)/i;
        var MethodName = re.exec(arguments.callee.toString())[1];  // 当前函数方法名
        var CardInfo = "0" + "^" + argObj.CardNo + "^" + "";
        CardInfo = UtilFuns.CallInterface(MethodName, argObj, CardInfo);
        return CardInfo;
    }

    // 项目个性化接口
    // 入参：func: 个性化方法 方法名,命名要和接口层Funcs中方法对应起来。如 "GetCardNoByPatInfo"
    //      argObj: 入参对象
    // 返回值: 失败: false,成功: 其他有效值
    function Interface(func, argObj) {
        var rtn = false;
        $.each(this.InterfaceArr, function (i, obj) {
            if ((typeof obj == "object") && (typeof obj.Funcs == "object") && (typeof obj.Funcs[func] == "function")) {
                // 是否开启外部卡关联
                var QRCardFlag = UtilFuns.GetQRCardFlag(argObj, obj);
                if (!QRCardFlag) return true;  // 退出本次循环

                rtn = UtilFuns.AnalysisArg(obj.Funcs[func], argObj);
                if (rtn) {
                    return false;  // 退出循环
                }
            }
        });
        return rtn;
    };

    var UtilFuns = {
        // 调用接口层方法处理
        CallInterface: function (MethodName, argObj, rtn) {
            var QRCardFlag;
            if (typeof rtn == "undefined") {
                rtn = false;
            }
            $.each(CardCommon_ControlObj.InterfaceArr, function (i, obj) {
                // break    用return false;
                // continue 用return true;
                if ((typeof obj == "object") && (typeof obj[MethodName] == "function")) {
                    // 是否开启外部卡关联
                    QRCardFlag = UtilFuns.GetQRCardFlag(argObj, obj);
                    if (!QRCardFlag) return true;  // 退出本次循环

                    // 解析入参并调用接口层代码
                    rtn = UtilFuns.AnalysisArg(obj[MethodName], argObj);
                    if (MethodName == "ReadQRCard") {
                        if (rtn.split("^") == "0") {
                            return false;  // 退出循环
                        }
                    } else {
                        if (rtn) {
                            return false;  // 退出循环
                        }
                    }
                }
            });
            return rtn;
        },

        // 是否开启外部卡关联
        GetQRCardFlag: function (argObj, obj) {
            var QRCardFlag;
            if (argObj.CardTypeDR != "" && typeof argObj.CardTypeDR != "undefined") {  // HISUI版本无卡类型
                QRCardFlag = tkMakeServerCall("DHCDoc.Interface.CardManage", "GetQRCardFlagByCardType", argObj.CardTypeDR, session['LOGON.CTLOCID'], obj.Name);
                // break----用return false;
                // continue --用return true;
                if (QRCardFlag != "1") return false;
            }
            if (argObj.CardNo != "" && typeof argObj.CardNo != "undefined") {
                // 解析入参并调用接口层代码
                QRCardFlag = UtilFuns.AnalysisArg(obj.GetQRCardFlag, argObj);
                if (!QRCardFlag) {
                    return false;
                }
            }
            return true;
        },

        // 解析方法入参变量名,并从传入数据中获取到匹配的数据
        // func接口层方法,dataObj入参对象
        AnalysisArg: function (func, dataObj) {
            // var medStepCode = document.getElementById('CardScript').getAttribute('medStepCode');  // 诊疗环节
            var medStepCode = $("#CardScript").attr('medStepCode');  // 诊疗环节

            var funcName = func.toString();
            var argList = [];
            funcName = funcName.replace(/\s*/g, "");
            var argStr = funcName.split(")")[0].split("(")[1];
            if (argStr != "") {
                var argArr = argStr.split(",");
                $.each(argArr, function (i, argName) {
                    var argValue = dataObj[argName];
                    if (argName == "medStepCode") argValue = medStepCode;
                    if (typeof argValue == "undefined") argValue = "";
                    argValue = argValue.replace(/：/g, ":");
                    argList.push(argValue);
                });
            }
            var rtn = "";
            if (argList.length == 0) {
                rtn = func();
            } else {
                rtn = func.apply(null, argList);
            }
            return rtn;
        },
    };
    return {
        "InterfaceArr": InterfaceArr,
        "Init": Init,
        "GetQRPatInfo": GetQRPatInfo,
        "PrintQRCode": PrintQRCode,
        "ReadQRCard": ReadQRCard,
        "Interface": Interface,  // 项目个性化接口
    };
})();
