/*
Creater:	
CreateDate：2023-02-02
FileName:   scripts/dhcdoc/interface/TongZhiWeiYe/ElecHealthCard.js
Description: * 山东省同智伟业电子健康卡统一封装js
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
        Name: "TongZhiWeiYe_ElecHealthCard",
        // 业务初始化
        Init: function () {
            //界面加载时调用生成图片的方法(低版本his需要)
            //document.write("<OBJECT ID='ClsSaveBase64IMG' CLASSID='CLSID:F6E5F767-D0E0-4311-AAFF-5EB0385F68A8' CODEBASE='../addins/client/ClsSaveBase64IMG.CAB#version=1,0,0,5'></OBJECT>");
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
                var CardInfo = ElecCardFuncs.CheckElecHealthCard(CardNo, medStepCode);
                if (CardInfo == false) {
                    return CardInfo;
                }
                CardInfo = CardInfo.split("^")[1];
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
                var CardInfo = ElecCardFuncs.CheckElecHealthCard(CardNo, medStepCode);
                if (!CardInfo) {
                    return "-2";
                }
                var CardNo = CardInfo.split("^")[0];
                rtn = "0" + "^" + CardNo + "^" + "";
            } else {  // 弹窗扫码

            }
            return rtn;
        },
        // 项目新增接口
        Funcs: {
            QRCodeRegClick: function (InputInfo) {
                /* if (InputInfo == "") {
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
                        ClassName: "web.DHCPATCardUnite",
                        MethodName: "ReadCardTypeByDesc1",
                        Desc: "",
                        dataType: "text"
                    }, false);

                    var rtn = CardType + "$" + qCode;
                    return rtn;
                } */
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
        // 返回卡号可用正常使用，返回空为验证失败
        // 返回 false 说明验证失败
        CheckElecHealthCard: function (CardNo, medStepCode) {
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

            var LocID = session['LOGON.CTLOCID'];
            var deptCode = tkMakeServerCall("DHCDoc.Interface.Outside.TZWYHealthCard.Methods", "GetDeptCode", LocID);
            var rtn = tkMakeServerCall("DHCDoc.Interface.Outside.TZWYHealthCard.Methods", "GetPatInfoByQrCode", CardNo, medStepCode, deptCode);
            if ((rtn != "undefined") && (rtn != "")) {
                var myarr = rtn.split("^");
                var Flag = myarr[0];
                var Msg = myarr[1];
                if (Flag == 1) {
                    var PatInfo = myarr[2];
                    var XMLData = ElecCardFuncs.GetElecHealthCardXMLData(PatInfo);
                    var CardNo = PatInfo.split("|")[4];
                    return CardNo + "^" + XMLData;
                } else {
                    $.messager.alert("提示", "电子建卡验证失败！" + Msg);
                    return false;
                }
            } else {
                $.messager.alert("提示", "电子建卡验证失败！" + Msg);
                return false;
            }
        },
        GetElecHealthCardXMLData: function (PatInfo) {
            var PatInfoArry = PatInfo.split("|");
            if (PatInfoArry[0] == "") { return ""; }
            // 姓名|手机号|证件类型|证件号码|电子健康卡卡号
            var myXMLData = "";
            var Name = PatInfoArry[0];
            var Phone = PatInfoArry[1];
            var CredType = PatInfoArry[2];
            var CredNo = PatInfoArry[3];
            var CardNo = PatInfoArry[4];

            myXMLData = myXMLData + "<CredNo>" + CredNo + "</CredNo>";
            myXMLData = myXMLData + "<Name>" + Name + "</Name>";
            //myXMLData=myXMLData+"<Sex>"+Sex+"</Sex>"
            //myXMLData=myXMLData+"<Birth>"+NewBirthDay+"</Birth>"
            myXMLData = myXMLData + "<TelHome>" + Phone + "</TelHome>";
            //myXMLData=myXMLData+"<Address>"+Address+"</Address>"
            //myXMLData=myXMLData+"<PatType>"+Social+"</PatType>"
            myXMLData = myXMLData + "<CardNo>" + CardNo + "</CardNo>";
            myXMLData = "<gRoot>" + myXMLData + "</gRoot>";
            return myXMLData;
        },
        EmrCard_click: function (PatientID, QRCodeImageData) {
            //如果登记号存在去后台取患者姓名
            if (PatientID != "") {
                var PatStr = tkMakeServerCall("web.DHCDocOrderEntry", "GetPatientByRowid", PatientID);
                if (PatStr != "") {
                    Name = PatStr.split("^")[2];
                    var sex = PatStr.split("^")[3];
                }
            }
            if ((QRCodeImageData == "") || (QRCodeImageData == undefined)) {
                var IDCardNo = tkMakeServerCall("DHCDoc.Interface.Outside.TZWYHealthCard.Public", "getIDCardNobypapmi", PatientID);
                // 根据身份证获取二维码
                var QRCodeImageInfo = tkMakeServerCall("DHCDoc.Interface.Outside.TZWYHealthCard.Methods", "GetQrCodeByIdCard", IDCardNo);
                var ReturnCode = QRCodeImageInfo.split("^")[0];
                if (ReturnCode == "1") {
                    QRCodeImageData = QRCodeImageInfo.split("^")[3];
                } else {
                    $.messager.alert("提示", "未查询到二维码信息");
                    return false;
                }
            }
            //alert(QRCodeImageData)
            if (QRCodeImageData == "") {
                $.messager.alert("提示", "电子健康卡二维码数据为空!");
                return false;
            }

            var TxtInfo = "PAPMIRowID" + "\2" + PatientID + "^Name" + "\2" + Name + "^sex" + "\2" + sex + "^qrcode" + "\2" + QRCodeImageData;
            var ListInfo = "";
            DHCP_GetXMLConfig("DepositPrintEncrypt", "DZJKK");
            var myobj = document.getElementById("ClsBillPrint");
            DHCP_PrintFun(myobj, TxtInfo, ListInfo);
            return true;
        }
    };
});
