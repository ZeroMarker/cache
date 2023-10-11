/*
Creater:	
CreateDate：2023-02-02
FileName:   scripts/dhcdoc/interface/GuanXinKeJi/ElecHealthCard.js
Description: * 冠新科技电子健康卡统一封装js
             * 本js为接口层js
注意事项: 
    ● 报错弹窗在接口层js(本js)
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
                2. 当卡类型卡号等信息为空时，可弹窗扫码,此时卡类型读卡方式为:Read Card,读卡设备为空【选做功能,用于项目需要点击读卡弹窗扫码】(如果卡类型对应多个接口层,每个js应都有ReadQRCard方法。卡类型卡号为空的判断条件,应只写在最后一个接口层里。)
                3. 如果his无卡，可考虑调用后台自动建卡(接口层自行写逻辑)
    ● Funcs: 项目个性化接口
        入参：和业务层js入参对象一一对应
        返回值: 失败false,成功: 其他有效值(和业务层代码对应)
        说明:   如"QRCodeRegClick"调用第三方外部卡注册接口,具体方法根据实际情况定义。
                    返回卡类型串(CardTypeDR_"^"_$g(^DHCCARDTYPEDef(CardTypeDR)) $  卡号)
*/
$(function () {
    if (typeof CardCommon_ControlObj != "object") return;
    if (typeof CardCommon_ControlObj.InterfaceArr != "object") return;

    var ElecCardObj = {
        Name: "GuanXinKeJi_ElecHealthCard",
        // 业务初始化
        Init: function () {
            return false;
        },

        // 通过卡号等判断是否为当前接口层对应卡【其他业务界面,HISUI版本无卡类型】
        // 入参:   CardTypeDR: 卡类型id,(可能为空)                 
        //         CardNo: 卡号(二维码信息), 
        // 返回值: 否false,是true
        GetQRCardFlag: function (CardTypeDR, CardNo) {
            var rtn = false;
            if (CardNo.indexOf(":") > -1 || CardNo.length == 64) rtn = true;
            return rtn;
        },
        // 根据二维码等获取患者信息【建卡】
        // 入参:   medStepCode: 诊疗环节(必须,由各个界面csp传入,业务层js不传入)
        //			 	详情见 web.UDHCCardCommLinkRegister.GetCardHardInfo 方法入参说明
        //		   CardTypeDR: 卡类型id, 
        //		   CardNo: 卡号(二维码信息)
        // 失败false, 成功: XML患者信息串(包含CardNo节点),用于填充建卡界面 
        GetQRPatInfo: function (medStepCode, CardTypeDR, CardNo) {
            var CardInfo = false;
            if (CardNo != "") {
                CardNo = CardNo.split(":")[0];
                var InInfo = "^^" + CardNo + "^3";
                var ReInfo = tkMakeServerCall("DHCDoc.Interface.Outside.GDHealthCardService.Public", "getPersonInfo", InInfo);
                if (ReInfo.split("^")[0] == "0") {
                    CardInfo = ReInfo.split("^")[2];
                }
            } else {  // 弹窗扫码

            }
            return CardInfo;
        },
        // 打印电子健康卡【建卡】
        // 入参：  CardTypeDR  卡类型id, 
        //	CardNo: 卡号, 
        //	PatientID: 病人表id
        // 返回值：打印失败false, 打印成功true
        PrintQRCode: function (CardTypeDR, CardNo, PatientID) {
            if (PatientID == "") {
                $.messager.alert("提示", "病人ID不能为空!");
                return false;
            }
            var rtn = ElecCardFuncs.EmrCard_click(PatientID, "");
            return rtn;
        },
        // 读卡(或通过二维码等)获取卡号【其他业务界面】
        // 入参:   medStepCode: 诊疗环节(必须,由各个界面csp传入,业务层js不传入)
        //				详情见 web.UDHCCardCommLinkRegister.GetCardHardInfo 方法入参说明
        //         CardTypeDR: 卡类型id, 
        //         CardNo: 卡号(二维码信息), 
        // 返回值: 失败: 非0^失败原因(可为空) "-200"卡无效 "-201"卡有效无帐户, 
        //         成功: 0^实际卡号^校验码(空)
        ReadQRCard: function (medStepCode, CardTypeDR, CardNo) {
            var rtn = "";
            if (CardNo != "") {
                var CardInfo = ElecCardFuncs.DHCWebCheckCard(CardNo, medStepCode);
                if (!CardInfo) {
                    return "-200";
                }
                var CardNo = CardInfo;
                rtn = "0" + "^" + CardNo + "^" + "";
            } else {  // 弹窗扫码

            }
            return rtn;
        },
        // 项目新增接口
        Funcs: {
            QRCodeRegClick: function (InputInfo) {
                if (InputInfo == "") {
                    $.messager.alert("提示", "电子健康卡注册失败,失败原因:" + "患者信息不能为空");
                    return false;
                }
                var qCode = tkMakeServerCall("DHCDoc.Interface.Outside.GDHealthCardService.Public", "createVmcardQRcode", InputInfo);
                var qCodeArr = qCode.split("^");
                var success = qCodeArr[0];
                var ehcCardNo = qCodeArr[1];
                var ehcQRCode = qCodeArr[2];

                if (success != "0") {
                    $.messager.alert("提示", "电子健康卡注册失败,失败原因:" + qCode);
                    return false;
                } else {
                    $.messager.alert("提示", "电子健康卡注册成功,请发卡");
                    var DZJJKCardTypeStr = tkMakeServerCall("DHCDoc.Interface.Outside.GDHealthCardService.Util", "ReadCardTypeByDesc");
                    var rtn = DZJJKCardTypeStr + "$" + ehcCardNo;
                    return rtn;
                }
            },
        }
    };
    CardCommon_ControlObj.InterfaceArr.push(ElecCardObj);

    var ElecCardFuncs = {
        /*
        CardNo	居民健康电子卡二维码信息
        medStepCode 诊疗环节（传值详情见 web.UDHCCardCommLinkRegister.GetCardHardInfo 方法入参说明）
            010101挂号,010102诊断,010106开方,010103取药,010104检查,010107手术,010105收费,000000其他
        */
        DHCWebCheckCard: function (CardNo, medStepCode) {
            var medStep010101 = ",CardReg,CardManage,OPAdmReg,Update,Triage,InPatReg,InAdmReg,BlackList,PEReg,";
            var medStep010102 = ",AdmQuery,Diag,EMR,EMRCopy,";
            var medStep010106 = ",Order,Cure,";
            var medStep010103 = ",Disp,CMReturn,CMDisp,PY,Return,NarcRec,";
            var medStep010104 = ",Exam,";
            var medStep010107 = ",Opera,";
            var medStep010105 = ",PrintBill,Bill,PEBill,";
            var medStep000000 = ",Other,";
            var medStepCodeStr = "," + medStepCode + ",";
            switch (medStepCodeStr) {
                case (medStep010101.match(medStepCodeStr) || {})[0]:
                    medStepCode = "010101";
                    break;
                case (medStep010102.match(medStepCodeStr) || {})[0]:
                    medStepCode = "010102";
                    break;
                case (medStep010106.match(medStepCodeStr) || {})[0]:
                    medStepCode = "010106";
                    break;
                case (medStep010103.match(medStepCodeStr) || {})[0]:
                    medStepCode = "010103";
                    break;
                case (medStep010104.match(medStepCodeStr) || {})[0]:
                    medStepCode = "010104";
                    break;
                case (medStep010107.match(medStepCodeStr) || {})[0]:
                    medStepCode = "010107";
                    break;
                case (medStep010105.match(medStepCodeStr) || {})[0]:
                    medStepCode = "010105";
                    break;
                case (medStep000000.match(medStepCodeStr) || {})[0]:
                    medStepCode = "000000";
                    break;
                default:
                    medStepCode = "000000";
                    break;
            }

            var terminalCode = "";  //识读终端编码 需传输在卡管系统中注册过的设备码
            var appMode = 3; //操作方式
            /* var CardNo = CardNo.split(":")[0];
            return CardNo; */
            var QrCodeInfo = CardNo + "^" + terminalCode + "^" + medStepCode + "^" + appMode;
            var ret = tkMakeServerCall("DHCDoc.Interface.Outside.GDHealthCardService.Public", "getPersonInfoByQrCode", QrCodeInfo);
            var rtnArr = ret.split("^");
            if ((rtnArr[0] != 0)) {
                alert("电子健康卡验证失败！" + rtnArr[1]);
                return false;
            }
            CardNo = rtnArr[1];
            return CardNo;
        },
        EmrCard_click: function (PatientID, QRCodeImageData) {
            var erhcCardNo = tkMakeServerCall("DHCDoc.Interface.Outside.GDHealthCardService.Util", "GetEHCHealthCardByPat", PatientID);
            if ((PatientID == "") || (erhcCardNo == "")) {
                $.messager.alert("提示", "未查询到电子健康卡,请先发卡");
                return false;
            }
            var PatInfo = "", myCredNo = "";
            PatInfo = tkMakeServerCall("DHCDoc.Interface.Outside.GDHealthCardService.Util", "GetPatInfoByPatientID", PatientID);
            var myCredTypeDR = PatInfo.split("^")[4];
            var myCredNo = PatInfo.split("^")[5];
            var myNO = PatInfo.split("^")[0];
            var myPAPMIName = PatInfo.split("^")[1];

            if (myCredNo == "") {
                $.messager.alert("提示", "患者证件号码不能为空!");
                return false;
            }
            var appMode = "3";
            var InputInfo = myCredTypeDR + "^" + myCredNo + "^" + appMode;
            var Rtn = tkMakeServerCall("DHCDoc.Interface.Outside.GDHealthCardService.Public", "queryIfHasRegistered", InputInfo);
            var RtnArr = Rtn.split("^");
            if (RtnArr[0] != 0) {
                $.messager.alert("提示", "调用电子健康卡判断账户是否注册接口失败，失败原因：" + RtnArr[1]);
                return false;
            }
            var parameters = RtnArr[1];  // 0:未查到此用户 1:已注册
            if (parameters == "1") {
                var base64code = tkMakeServerCall("DHCDoc.Interface.Outside.GDHealthCardService.Public", "activateVmcardQRcode", InputInfo);
                var RtnArr = base64code.split("^");
                if (RtnArr[0] != 0) {
                    $.messager.alert("提示", "调用电子健康卡激活申领接口失败，失败原因：" + RtnArr[1]);
                    return false;
                }
                base64code = RtnArr[1];
                if (base64code != "") {
                    var TxtInfo = "Qrcode" + String.fromCharCode(2) + base64code + String.fromCharCode(2) + "^myNO" + String.fromCharCode(2) + myNO + String.fromCharCode(2) + "^myPAPMIName" + String.fromCharCode(2) + myPAPMIName;
                    var ListInfo = "";
                    var PatInfoXMLPrint = "DZJKKPrintEncrypt2";
                    DHCP_GetXMLConfig("DepositPrintEncrypt", PatInfoXMLPrint);
                    var LODOP = getLodop();
                    if (LODOP) DHC_PrintByLodop(LODOP, TxtInfo, ListInfo, "", "DepositPrintEncrypt");
                } else {
                    $.messager.alert("提示", "二维码获取失败");
                    return false;
                }
            } else if (parameters == "0") {
                $.messager.alert("提示", "该患者未注册电子健康卡,请先发健康卡!");
                return false;
            } else {
                $.messager.alert("提示", "操作失败!");
                return false;
            }
            return true;
        }
    };
});
