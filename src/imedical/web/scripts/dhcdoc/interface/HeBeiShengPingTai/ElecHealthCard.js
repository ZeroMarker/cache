/*
Creater:	
CreateDate：2023-02-02
FileName:   scripts/dhcdoc/interface/HeBeiShengPingTai/ElecHealthCard.js
Description: * 河北省平台电子健康卡统一封装js
             * 本js为接口层js
注意事项: 
    ● 报错弹窗在接口层js(本js)
入参说明:
    入参要和 应用层js入参对象对应属性名一致
方法说明:
    ● Name: 配置页面的厂家代码_模块代码 （必须正确）    
    ● Init: 界面初始化，只加载一次   
        返回值: 统一返回false
    ● GetQRPatInfo: 根据卡号二维码等获取患者信息【建卡】
        入参:   medStepCode: 诊疗环节(必须,由各个界面csp传入,应用层js不传入)
                CardTypeDR: 卡类型id, 
                CardNo: 卡号(二维码信息), 
        返回值: 失败false, 成功: XML患者信息串(包含CardNo节点),用于填充建卡界面
            XML串: <gRoot><CardNo></CardNo><Name></Name><Sex></Sex><Birth></Birth><TelHome></TelHome><Address></Address><ProvinceInfoLookUpRowID></ProvinceInfoLookUpRowID><CityDescLookUpRowID></CityDescLookUpRowID><CityAreaLookUpRowID></CityAreaLookUpRowID><NationDescLookUpRowID></NationDescLookUpRowID><Vocation></Vocation></gRoot>
    ● PrintQRCode: 打印电子健康卡【建卡】
        入参：  PatientID: 病人表id
                QRCodeImageData 打印二维码信息(可能为空)
        返回值：打印失败false, 打印成功true
    ● GetCardEnableFlag: 根据卡类型卡号等判断是否为当前js对应卡类型【其他业务界面,HISUI版本无卡类型】
        入参:   CardTypeDR: 卡类型id,(可能为空)           
                CardNo: 卡号(二维码信息), 
        返回值: 否false, 是true
    ● ReadQRCard: 读卡(或通过二维码等)获取卡号【其他业务界面】
        入参:   medStepCode: 诊疗环节(必须,由各个界面csp传入,应用层js不传入)
                CardTypeDR: 卡类型id, 
                CardNo: 卡号(二维码信息), 
        返回值: 失败: 非0^失败原因(可为空) "-200"卡无效 "-201"卡有效无帐户
                成功: 0^实际卡号^校验码(空)
        说明:   1. 默认通过二维码等获取卡号信息
                2. 当卡类型卡号等信息为空时，可弹窗扫码,此时卡类型读卡方式为:Read Card,读卡设备为空【选做功能,用于项目需要点击读卡弹窗扫码】(如果卡类型对应多个接口层,每个js应都有ReadMagCard方法。卡类型卡号为空的判断条件,应只写在最后一个接口层里。)
                3. 如果his无卡，可考虑调用后台自动建卡(接口层自行写逻辑)
    ● Funcs: 项目个性化接口
        入参：和应用层js入参对象一一对应
        返回值: 失败false,成功: 其他有效值(和应用层代码对应)
        说明:   如"QCodeRegClick"调用第三方外部卡保存接口,具体方法根据实际情况定义。
                    返回卡类型串(CardTypeDR_"^"_$g(^DHCCARDTYPEDef(CardTypeDR)) $  卡号)
*/
$(function () {
    if (typeof CardCommon_ControlObj != "object") return;
    if (typeof CardCommon_ControlObj.InterfaceArr != "object") return;

    var ElecCardObj = {
        Name: "HeBeiShengPingTai_DZJKK",
        // 业务初始化
        Init: function () {
            return false;
        },
        // 根据二维码等获取患者信息【建卡】
        // 失败false, 成功: XML患者信息串(包含CardNo节点),用于填充建卡界面 
        GetQRPatInfo: function (medStepCode, CardTypeDR, CardNo) {
            var CardInfo = false;
            if (CardNo != "") {
                var CardNo = CardNo.split(":")[0];
                var InInfo = "^^" + CardNo + "^3";
                var ReInfo = tkMakeServerCall("DHCDoc.Interface.Outside.ElecHealthCardService.ElecHealthCardMethods", "getPersonInfo", InInfo);
                if ((ReInfo.split("^")[0] == "0") && (ReInfo != "")) {
                    CardInfo = ReInfo.split("^")[2];
                }
            } else {  // 弹窗扫码

            }
            return CardInfo;
        },
        // 打印电子健康卡【建卡】
        // 入参：  PatientID: 病人表id
        //         QRCodeImageData 打印二维码信息(可能为空)
        // 返回值：false打印失败,true打印成功
        PrintQRCode: function (PatientID, QRCodeImageData) {
            if (PatientID == "") {
                $.messager.alert("提示", "病人ID不能为空!");
                return false;
            }
            var rtn = ElecCardFuncs.EmrCard_click(PatientID, QRCodeImageData);
            return rtn;
        },
        // 通过卡号等判断是否为当前接口层对应卡【其他业务界面,HISUI版本无卡类型】
        // 入参:   CardTypeDR: 卡类型id,(可能为空)                 
        //         CardNo: 卡号(二维码信息), 
        // 返回值: 否false,是true
        GetCardEnableFlag: function (CardTypeDR, CardNo) {
            var rtn = false;
            if (CardNo.indexOf(":") > -1 || CardNo.length == 64) rtn = true;
            return rtn;
        },
        // 读卡(或通过二维码等)获取卡号【其他业务界面】
        // 入参:   medStepCode: 诊疗环节(必须,由各个界面csp传入,应用层js不传入)
        //         CardTypeDR: 卡类型id, 
        //         CardNo: 卡号(二维码信息), 
        // 返回值: 失败flse, 成功: 0^实际卡号^校验码(空)
        ReadQRCard: function (medStepCode, CardTypeDR, CardNo) {
            var rtn = "";
            if (CardNo != "") {
                var CardInfo = ElecCardFuncs.DHCWebCheckCard(CardNo, medStepCode);
                if (!CardInfo) {
                    return "-2";
                }
                var CardNo = CardInfo;
                rtn = "0" + "^" + CardNo + "^" + "";
            } else {  // 弹窗扫码

            }
            return rtn;
        },
        // 项目新增接口
        Funcs: {
            QCodeRegClick: function (InputInfo) {
                if (InputInfo == "") {
                    $.messager.alert("提示", "电子健康卡注册失败,失败原因:" + "患者信息不能为空");
                    return false;
                }

                var qCode = tkMakeServerCall("DHCDoc.Interface.Outside.ElecHealthCardService.ElecHealthCardMethods", "createVmcardQRcode", InputInfo);
                if (qCode == "") {
                    alert("电子健康卡注册失败");
                    return false;
                } else {
                    alert("电子健康卡注册成功");
                    //alert(qCode)
                    //var CardType="06^电子健康卡^NP^N^^^Y^N^65294^^IE^^^^^Handle^^N^^^^^N^CL^^^^^^^N^N^N^^^N^N"
                    var CardType = $.cm({
                        ClassName: "DHCDoc.Interface.Outside.ElecHealthCardService.ElecHealthCardMethods",
                        MethodName: "ReadCardTypeByDesc1",
                        Desc: "",
                        dataType: "text"
                    }, false);

                    var rtn = CardType + "$" + qCode;
                    return rtn;
                }
            },
        }
    };
    CardCommon_ControlObj.InterfaceArr.push(ElecCardObj);

    var ElecCardFuncs = {
        /*
        CardNo	居民健康电子卡二维码信息
        medStepCode 诊疗环节
        010101挂号,010102诊断,010106开方,010103取药,010104检查,010107手术,010105收费,000000其他
        */
        DHCWebCheckCard: function (CardNo, medStepCode) {
            var terminalCode = "cdyxyfsyysm001";  //识读终端编码 需传输在卡管系统中注册过的设备码
			var CardFlag=CardNo.split(":")[1]
			if (CardFlag==0){  // 动态码要验证
				var Info=myCardNo+"^"+terminalCode+"^"+medStepCode+"^"+appMode
				var ret=tkMakeServerCall("DHCDoc.Interface.Outside.ElecHealthCardService.ElecHealthCardMethods","getPersonInfoByQrCode",Info);
				if (ret=="-1"){
					alert("电子建卡卡动态码已经失效，请重新生成后使用！")
					return false;
				}	
			}
			return CardNo.split(":")[0];
        },
        EmrCard_click: function (PatientID, QRCodeImageData) {
            var ReInfo = "";
            var PAPMINo = tkMakeServerCall("DHCExternalService.CardInterface.CardManager", "PatientIDToNo", PatientID);
            ReInfo = tkMakeServerCall("DHCDoc.Interface.Outside.ElecHealthCardService.ElecHealthCardMethods", "GetCodeCardInfoByPatNo", PAPMINo);
            if (ReInfo == "") {
                ReInfo = tkMakeServerCall("DHCDoc.Interface.Outside.ElecHealthCardService.ElecHealthCardMethods", "GetCodeCardInfo", QRCodeImageData);
            }
            if (ReInfo == "") {
                $.messager.alert("提示", "卡号无效或登记号没有对应的电子建卡信息!");
                return false;
            }
            var Name = ReInfo.split("^")[0];
            var Sex = ReInfo.split("^")[1];
            var PatientNo = ReInfo.split("^")[2];
            var Age = ReInfo.split("^")[3];
            var TCardNo = ReInfo.split("^")[4];

            var TxtInfo = "Name" + String.fromCharCode(2) + Name;
            TxtInfo = TxtInfo + "^Sex" + String.fromCharCode(2) + Sex;
            TxtInfo = TxtInfo + "^PAPMINo" + String.fromCharCode(2) + PAPMINo;
            TxtInfo = TxtInfo + "^Age" + String.fromCharCode(2) + Age;
            TxtInfo = TxtInfo + "^TCardNo" + String.fromCharCode(2) + TCardNo;
            var ListInfo = "";
            var PatInfoXMLPrint = "DZJKKPrintEncrypt";
            DHCP_GetXMLConfig("DepositPrintEncrypt", PatInfoXMLPrint);
            var myobj = document.getElementById("ClsBillPrint");
            DHCP_PrintFun(myobj, TxtInfo, ListInfo);
            return true;
        }
    };
});
