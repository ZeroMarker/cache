/*!
 *@creator:yunhaibao
 *@createdate:2016-08-06
 *@description:ҩ����һЩĬ������
 *@others:
 */
var DhcphaGridTrHeight = 34;
var LastEditSel = ""; //���༭��
var JqGridCanEdit = true;
var DhcphaReadCardCommon_ops;
var OPKey_HotKey;
var OPKey_MainGrid = "";
var HospId = session['LOGON.HOSPID'];
var userAgent=navigator.userAgent;			//��ȡ����������� 
$(function() {
    var pathname = window.location.pathname;
    pathname = pathname.split("/csp/")[0];
    DHCPHA_CONSTANT.URL.PATH = pathname;
    DHCPHA_CONSTANT.URL.COMMON_OUTPHA_URL = pathname + "/csp/" + DHCPHA_CONSTANT.URL.COMMON_OUTPHA_URL;
    DHCPHA_CONSTANT.URL.COMMON_INPHA_URL = pathname + "/csp/" + DHCPHA_CONSTANT.URL.COMMON_INPHA_URL;
    DHCPHA_CONSTANT.URL.COMMON_PHA_URL = pathname + "/csp/" + DHCPHA_CONSTANT.URL.COMMON_PHA_URL;
    DHCPHA_CONSTANT.URL.EASYUI_QUERY_URL = pathname + "/csp/" + DHCPHA_CONSTANT.URL.EASYUI_QUERY_URL;
    $("input[type=checkbox][name!=swich]").dhcphaCheck(); //����checkbox
    $("input[type=text]").on("keypress", function(e) {
        if (window.event.keyCode == "13") {
            KeyDownListener();
        }
    });
    GetPhaHisCommonParmas();
});

//�������λس��Ƿ�̫��
function KeyDownListener() {
    var keydowndate = new Date();
    var keydowntime = keydowndate.getTime();
    if (DHCPHA_CONSTANT.VAR.LASTENTERTIME != "" && DHCPHA_CONSTANT.VAR.LASTENTERTIME != undefined) {
        var minustime = keydowntime - DHCPHA_CONSTANT.VAR.LASTENTERTIME;
        if (minustime < 600) {
            alert("�س��ٶ�̫��!");
        }
    }
    DHCPHA_CONSTANT.VAR.LASTENTERTIME = keydowntime;
}
//@description ��ʼ��������
//@params id
function InitSelectCardType(_options) {
    var selectoption = {
        url: DHCPHA_CONSTANT.URL.COMMON_PHA_URL + "?action=GetCardType&style=select2",
        minimumResultsForSearch: Infinity,
        width: "8em",
        allowClear: false
    };
    $(_options.id).dhcphaSelect(selectoption);
    $("_options.id").on("select2:select", function(event) {
        //alert(event)
    });
    //Ĭ�Ͽ�����
    $.ajax({
        type: "POST", //�ύ��ʽ post ����get
        url: DHCPHA_CONSTANT.URL.COMMON_PHA_URL + "?action=GetCardType&style=select2",
        data: "json",
        success: function(data) {
            //var jsondata=eval(data);  //��������eval
            var jsondata = JSON.parse(data);
            var jsondatalen = jsondata.length;
            for (var i = 0; i < jsondatalen; i++) {
                var idata = jsondata[i];
                var idatadesc = idata.text;
                var idataid = idata.id;
                var idataidarr = idataid.split("^");
                var defaultflag = idataidarr[8];
                if (defaultflag == "Y") {
                    var select2option = "<option value=" + "'" + idataid + "'" + "selected>" + idatadesc + "</option>";
                    $(_options.id).append(select2option);
                }
            }
        },
        error: function() {
            alert("��ȡĬ�Ͽ�����ʧ��!");
        }
    });
}
//@description:��������
//@params:��������,�ص�����
//@csp need add:DHCWeb.OPCommonManageCard.JS
DhcphaReadCardCommon_CallBack=null; // ��Ӽ�¼�ص�
DhcphaReadCardCommon_ops=null;
function DhcphaReadCardCommon(_options, _fn) {
    if (_fn == undefined) {
        _fn = "";
		DhcphaReadCardCommon_CallBack=_fn;
    }else{
		DhcphaReadCardCommon_CallBack=_fn;
	}
    var txtcardno = _options.CardNoId;
    var txtpatno = _options.PatNoId;
    DhcphaReadCardCommon_ops=_options;
    var patCarNo = $("#" + txtcardno).val();
    var readRet;
	// �ص� 
    if (patCarNo != "") {
        readRet=DHCACC_GetAccInfo("", patCarNo, "", "PatInfo", CardTypeCallBack);
    } else {
        readRet=DHCACC_GetAccInfo7(CardTypeCallBack);
    }
	
}

function CardTypeCallBack(rtn) {

	var readRet=rtn;
	if (readRet == false) {
        dhcphaMsgBox.alert("����Ч!");
        return;
    }
    
    var txtcardno = DhcphaReadCardCommon_ops.CardNoId;
    var txtpatno = DhcphaReadCardCommon_ops.PatNoId;

    var readRetArr = readRet.split("^");
    var readRtn = readRetArr[0];
    switch (readRtn) {
        case "0":
            //����Ч
            PatientID = readRetArr[4];
            PatientNo = readRetArr[5];
            CardNo = readRetArr[1];
            $("#"+txtcardno).val(CardNo);
            $("#"+txtpatno).val(PatientNo);
            //$("#txt-patno").val(PatientNo);
            //$("#txt-cardno").val(CardNo);
			if(typeof DhcphaReadCardCommon_CallBack==='function'){
				DhcphaReadCardCommon_CallBack();
			}
            break;
        case "-1":
        	dhcphaMsgBox.alert("������������������뿨�ź����ԣ�");
			break;
        case "-200":
            dhcphaMsgBox.alert("����Ч!");
            break;
        case "-201":
            //�ֽ�
            PatientID = readRetArr[4];
            PatientNo = readRetArr[5];
            CardNo = readRetArr[1];
            $("#"+txtcardno).val(CardNo);
            $("#"+txtpatno).val(PatientNo);

            //$("#txt-patno").val(PatientNo);
            //$("#txt-cardno").val(CardNo);
			if(typeof DhcphaReadCardCommon_CallBack==='function'){
				DhcphaReadCardCommon_CallBack();
			}
            break;
            
        default:
    }

}


//@description ��ȡ����ҽ����Ϣ,������Ϣ��ָ��div
//@params ҽ��id
function AppendPatientOrdInfo(_options) {
    $.ajax({
        type: "POST", //�ύ��ʽ post ����get
        url: DHCPHA_CONSTANT.URL.COMMON_PHA_URL + "?action=GetPatientOrdInfo&orditem=" + _options.orditem,
        data: "json",
        success: function(data) {
            var retdata = JSON.parse(data)[0];
            var imageid = "";
            if (retdata.patsex == "Ů") {
                //��Ů����
                imageid = "icon-female.png";
            } else if (retdata.patsex == "��") {
                imageid = "icon-male.png";
            } else {
                imageid = "icon-unmale.png";
            }
            if ($("#patInfo")) {
                $("#patInfo").remove();
            }
            var patname = retdata.patname;
            var patordinfo = "";
            if (retdata.patage != "") {
                patordinfo = "<span>&nbsp;&nbsp;" + retdata.patage + "&nbsp;&nbsp;</span>|&nbsp;&nbsp;";
            }
            if (retdata.prescno != "") {
                patordinfo = patordinfo + "<span>" + retdata.prescno + "&nbsp;&nbsp;</span>|&nbsp;&nbsp;";
            }
            if (retdata.patweight != "") {
                patordinfo = patordinfo + "<span>" + retdata.patweight + "&nbsp;&nbsp;</span>|&nbsp;&nbsp;";
            }
            if (retdata.patbilltype != "") {
                patordinfo = patordinfo + "<span>" + retdata.patbilltype + "&nbsp;&nbsp;</span>|&nbsp;&nbsp;";
            }
            if (retdata.admlocdesc != "") {
                patordinfo = patordinfo + "<span>" + retdata.admlocdesc + "&nbsp;&nbsp;</span>|&nbsp;&nbsp;";
            }
            if (retdata.presctitle != "") {
                patordinfo = patordinfo + "<span>" + retdata.presctitle + "&nbsp;&nbsp;</span>|&nbsp;&nbsp;";
            }
            var pathtml = ' <div class="col-md-12" id="patInfo"><div class="col-md-1">' + '<a href="#" class="thumbnail" style="border:0px;height:20px;">' + "<img src=" + DHCPHA_CONSTANT.URL.PATH + "/scripts/pharmacy/images/" + imageid + ' style="border-radius:35px;height:50px;width:50px">' + "</a>" + "</div>" + ' <div class="col-md-11 col-md_style">' + ' <span style="font-size:17px">' + patname + "&nbsp;&nbsp;&nbsp;</span>" + patordinfo + " </div></div>";
            $(_options.id).append(pathtml);
        },
        error: function() {
            alert("��ȡ����ҽ����Ϣʧ��!");
        }
    });
}
//@description ��ȡ���˻�����Ϣ,������Ϣ��ָ��div
//@params ҽ��id
function AppendPatientBasicInfo(_options) {
    var retdata = GetPatientBasicInfo(_options.input, _options.gettype);
    var imageid = "";
    if (retdata.patsex == "Ů") {
        //��Ů����
        imageid = "icon-female.png";
    } else if (retdata.patsex == "��") {
        imageid = "icon-male.png";
    } else {
        imageid = "icon-unmale.png";
    }
    if ($("#patInfo")) {
        $("#patInfo").remove();
    }
    var patname = retdata.patname;
    var patage = retdata.patage;
    if (patname == undefined) {
        return;
    }
    var pathtml = ' <div class="col-md-12" id="patInfo" style="padding-top:0.3em">' + ' <div style="float:right;padding-top:5px;padding-left:5px">' + patname + "</br>" + patage + "</div>" + '<div style="float:right">' + '<img src="' + DHCPHA_CONSTANT.URL.PATH + "/scripts/pharmacy/images/" + imageid + '" style="border-radius:35px;height:50px;width:50px">' + "</div>" + " </div>";
    $(_options.id).append(pathtml);
}

//@description ��ȡ���˻�����Ϣ
//@params ����/�ǼǺ� , ����(�ǼǺ�:patno/����:cardno)
function GetPatientBasicInfo(inputNo, noType) {
    var patinfo = tkMakeServerCall("web.DHCSTPharmacyCommon", "GetPatientBasicInfo", inputNo, noType);
    patinfo = JSON.parse(patinfo)[0];
    return patinfo;
}
//@description ��ȡhis��Ϣ�Ĺ�����������
//@params �ǼǺų���,���ų���
function GetPhaHisCommonParmas() {
    $.ajax({
        type: "POST", //�ύ��ʽ post ����get
        url: DHCPHA_CONSTANT.URL.COMMON_PHA_URL + "?action=GetPhaHisCommonParmas",
        data: "json",
        success: function(data) {
            var jsondata = JSON.parse(data); // data��Ҫ˫����
            var hisPatNoLen = jsondata[0].patNoLen;
            if (hisPatNoLen > 0) {
                DHCPHA_CONSTANT.DEFAULT.PATNOLEN = hisPatNoLen;
            }
        },
        error: function() {
            alert("��ȡ��������ʧ��!");
        }
    });
}
//@description ���ֲ�0
//@input: no,length
function NumZeroPadding(inputNum, numLength) {
    if (inputNum == "") {
        return inputNum;
    }
    var inputNumLen = inputNum.length;
    if (inputNumLen > numLength) {
        //$.messager.alert('������ʾ',"�������");
        dhcphaMsgBox.alert("�������");
        return "";
    }
    for (var i = 0; i < inputNumLen; i++) {
        var para = inputNum[i];
        if (isNaN(para) || para.trim() == "" || String(para).indexOf(".") > -1 || !(parseInt(inputNum) > 0)) {
            dhcphaMsgBox.alert("�������");
            return "";
        }
    }
    for (var i = 1; i <= numLength - inputNumLen; i++) {
        inputNum = "0" + inputNum;
    }
    return inputNum;
}

//@description:jqGrid�ɱ༭�����ݵ���ɫ
function addTextCellAttr(rowId, val, rawObject, cm, rdata) {
    if (rawObject.planId == null) {
        return "style='color:black;font-weight:bold;'";
    }
}
//@description:�жϱ�������Ƿ�Ϊ��
//@return: true:��
function DhcphaGridIsEmpty(_grid_id, _grid_type) {
    if (_grid_type == undefined) {
        _grid_type = "";
    }
    if (_grid_type == "") {
        //Ĭ��jqGrid
        var grid_records = $(_grid_id).getGridParam("records");
        if (grid_records == 0) {
            dhcphaMsgBox.alert("��ǰ������������ϸ����!");
            return true;
        }
        return false;
    }
}
//@description:�жϱ�������Ƿ�ѡ��
//@return: true:ѡ��
function DhcphaGridIsSelect(_grid_id, _grid_type) {
    if (_grid_type == undefined) {
        _grid_type = "";
    }
    if (_grid_type == "") {
        //Ĭ��jqGrid
        var grid_select = $(_grid_id).jqGrid("getGridParam", "selrow");
        if (grid_select == "" || grid_select == null) {
            dhcphaMsgBox.alert("����ѡ������,�ٽ��в���!");
            return false;
        }
        return true;
    }
}
//@description:jqGrid�ɱ༭�����ݵ���ɫ
function addTextCellAttr(rowId, val, rawObject, cm, rdata) {
    if (rawObject.planId == null) {
        return "style='color:black;font-weight:bold;'";
    }
}
//@description:��ʼ��inci����
function InitLocInci(_options) {
    var selectoption = {
        url: DHCPHA_CONSTANT.URL.COMMON_PHA_URL + "?action=GetLocInciDsByAlias&style=select2&locId=" + _options.locid,
        placeholder: "ҩƷ����...",
        allowClear: true,
        minimumInputLength: 2,
        width: 250,
        dropdownAutoWidth: true
    };
    if (_options.width != undefined) {
        selectoption.width = _options.width;
    }
    $(_options.id).dhcphaSelect(selectoption);
}
//@description:setcookie
function setCookie(name, value) {
    var oDate = new Date();
    oDate.setDate(oDate.getDate());
    document.cookie = name + "=" + encodeURIComponent(value) + ";expires=" + oDate;
}
//@description:getcookie
function getCookie(name) {
    var cookiearr = document.cookie.split("; ");
    var i = 0;
    for (i = 0; i < cookiearr.length; i++) {
        var cookiearri = cookiearr[i].split("=");
        if (cookiearri[0] == name) {
            var getCookieValue = decodeURIComponent(cookiearri[1]);
            return getCookieValue;
        }
    }
    return "";
}
//@description:removecookie
function removeCookie(name) {
    setCookie(name, "1", -1);
}
//@description:ת������Ϊyyyy-MM-dd��ʽ
//@params: (t-1)
function FormatDateT(input) {
    input = input.trim();
    input = input.toUpperCase();
    var formatdate = tkMakeServerCall("web.DHCSTKUTIL", "GetDate", "", "", input);
    return formatdate;
}

//@description:ת������Ϊyyyy-MM-dd��ʽ
//@params: (t-1)
function FormatDateYMD(input) {
    input = input.trim();
    input = input.toUpperCase();
    var formatdate = tkMakeServerCall("web.DHCSTKUTIL", "GetYMDDate", "", "", input);
    return formatdate;
}

//@description:�ж����������
function BrowserType() {
    var userAgent = navigator.userAgent; //ȡ���������userAgent�ַ���
}
//@description:��ȡ��������mac��ַ,IE
function GetComputerValidMac() {
	if ((typeof isIECore!="undefined")&&(isIECore==false)){
		if("undefined"!=typeof EnableLocalWeb && EnableLocalWeb==1){
		    if (getClientIP) {
			    var ipData = getClientIP();
			    if (ipData!=""){
					return ipData.split("^")[2];
				}
		    }
		}
	}
    var macAddr = "";
    var locator = new ActiveXObject("WbemScripting.SWbemLocator");
    var service = locator.ConnectServer("."); //���ӱ���������
    var properties = service.ExecQuery("SELECT * FROM Win32_NetworkAdapterConfiguration Where IPEnabled =True"); //��ѯʹ��SQL��׼
    var e = new Enumerator(properties);
    var p = e.item();
    for (; !e.atEnd(); e.moveNext()) {
        var p = e.item();
        if (p.MACAddress == null) {
            continue;
        }
        macAddr = p.MACAddress;
        if (macAddr) break;
    }
    return macAddr;
}
//�ж��������Ƿ����Ԫ��
Array.prototype.contains = function(obj) {
    var i = this.length;
    while (i--) {
        if (this[i] === obj) {
            return true;
        }
    }
    return false;
};
///ǰ̨daterange��ʽת��,������̨ͳһ��"-"�ָ�
function FormatDateRangePicker(inputValue) {
    if (inputValue == "") {
        return inputValue;
    }
    inputValue = inputValue.replace("��", "-");
    return inputValue;
}
///��ѯ����ĳ�������ı��߶�
///contentcnt:panel div_content ����
function GridCanUseHeight(contentcnt) {
    var height1 = $("[class='container-fluid dhcpha-condition-container']").height();
    var height2 = parseFloat($("[class='panel div_content']").css("margin-top"));
    var height3 = parseFloat($("[class='panel div_content']").css("margin-bottom"));
    var height4 = parseFloat($("[class='panel-heading']").outerHeight());
    var contenth = height1 + height2 + height3 + height4 + 20;
    var tableheight = $(window).height() - contenth * contentcnt;
    return tableheight;
}
///��ѯ�����߶�,��ѯ������div����
function QueryConditionHeight() {
    var conditionheight = $("#dhcpha-query-condition").height() + $("#dhcpha-query-condition").offset().top;
    return conditionheight;
}
///�����panelheading�߶�
function PanelHeadingHeight(num) {
    if (num == undefined) {
        num = 1;
    }
    var height1 = parseFloat($("[class='panel div_content']").css("margin-top"));
    var height2 = parseFloat($("[class='panel div_content']").css("margin-bottom"));
    var height3 = parseFloat($("[class='panel-heading']").outerHeight());
    var panelheight = (height1 + height2 + height3) * num;
    return panelheight;
}
///���Ϊjqgridʱ������������ø߶�,tnum��ͷҳ�������ܸ���
function DhcphaJqGridHeight(pnum, tnum) {
    if (pnum == undefined) {
        pnum = 1;
    }
    var dgheight = $(window).height() - PanelHeadingHeight(pnum) - QueryConditionHeight() - tnum * DhcphaGridTrHeight;
    if (tnum == 1) {
        dgheight = dgheight - 9;
    }
    return dgheight;
}
/// �޸�csp·��Ϊ����·��
function ChangeCspPathToAll(pathcsp) {
    var pathname = window.location.pathname;
    pathname = pathname.split("/csp/")[0];
    pathcsp = pathname + "/csp/" + pathcsp;
    return pathcsp;
}

//��λ�ķ���
//��һ��Ŀ����
//�ڶ�������λ��
//������������Ԫ��
function coverPosition(par1, par2, par3) {
    if (par1.length < par2) {
        for (i = 1; i < par2; i++) {
            par1 = par3 + "" + par1;
        }
    }
    return par1;
}

function DhcCardPayCommon(_ops, _fn) {
    if (_fn == undefined) {
        _fn = "";
    }
    var txtcardno = _ops.CardNoId;
    var txtpatno = _ops.PatNoId;
    var StDate = _ops.StDate;
    var EndDate = _ops.EndDate;
    var CardNo = $("#" + txtcardno).val();
    var PatNo = $("#" + txtpatno).val();
    var PatInfo = tkMakeServerCall("PHA.OP.COM.Method", "GetPatInfoByNo", PatNo);
    if (PatInfo == "") {
        dhcphaMsgBox.alert("�û����޶�Ӧ����Ϣ,���ܽ���Ԥ�۷�!");
        return false;
    }
    var ArrPatInfo = PatInfo.split("^");
    var Adm = ArrPatInfo[0];
    var Papmi = ArrPatInfo[1];
    var guser = session["LOGON.USERID"];
    var groupDR = session["LOGON.GROUPID"];
    var locDR = session["LOGON.CTLOCID"];
    var hospDR = session["LOGON.HOSPID"];

    $("#CardBillCardTypeValue").val(PatInfo.split("^").slice(3,PatInfo.split("^").length).join("^")); 
    var mode = tkMakeServerCall("PHA.FACE.IN.Com", "GetCheckOutMode", groupDR+"^"+locDR+"^"+hospDR);
    if (mode == 1) {
        if (CardNo == "") {
            dhcphaMsgBox.alert("�û����޶�Ӧ����Ϣ,���ܽ���Ԥ�۷�!");
            return false;
        }
        dhcphaMsgBox.confirm("�Ƿ�ȷ�Ͽ۷�? ���[ȷ��]���ɣ����[ȡ��]�˳�", function(r) {
            if (r == true) {
                var insType = "";
                var oeoriIDStr = ""; //tkMakeServerCall("PHA.OP.COM.Method", "GetPatOrdInfo",Papmi,StDate,EndDate,Recloc);;
                var rtn = checkOut(CardNo, Papmi, Adm, insType, oeoriIDStr, guser, groupDR, locDR, hospDR);
                if (_fn != "") {
                    _fn();
                }
            } else {
                return;
            }
        });
        return;
    } else {
        var CardTypeValue = GetCustomVal("CardBillCardTypeValue");
        var CardTypeRowId = CardTypeValue != "" ? CardTypeValue.split("^")[0] : "";
        var url = "dhcbill.opbill.charge.main.csp?ReloadFlag=3&CardNo=" + CardNo + "&SelectAdmRowId=" + Adm + "&SelectPatRowId=" + Papmi + "&CardTypeRowId=" + CardTypeRowId;
        websys_showModal({
            url: url,
            title: "Ԥ�۷�",
            iconCls: "icon-w-inv",
            width: "97%",
            height: "85%",
            onClose: function() {
                if (_fn != "") {
                    _fn();
                }
                var ret=tkMakeServerCall("PHA.FACE.IN.Com","UnLockOPAdm",Adm,"User.OEOrder");
                if (top) {
                    top.$(this).window("destroy");
                }
            }
        });
    }
}
function GetCustomVal(custom) {
    var obj_PrescBillTypeID = document.getElementById(custom);
    if (obj_PrescBillTypeID) {
        return obj_PrescBillTypeID.value;
    } else {
        return "";
    }
}

/**
 * ת������,��Ҫ��jqgrid��������keyup��ʱ���ж�,Ŀǰû����������,���ֱ��ת��
 * @param {String} str
 */
function ParseToNum(str) {
    str = str.toString();
    if (str == "") {
        return "";
    }
    var dpos = str.indexOf(".");
    if (dpos >= 0) {
        var num1 = str.substring(0, dpos);
        num1 = num1.replace(/[^0-9]/g, "") * 1; // �滻������Ϊ��
        var num2 = str.substring(dpos + 1, str.length);
        num2 = num2.replace(/[^0-9]/g, "");
        var num = num1 + "." + num2;
    } else {
        var num = str.replace(/[^0-9]/g, "") * 1;
    }
    return num;
}

/**
 * ������˾ܾ�ԭ��ѡ��,����Load csp,�����ϵͳ�Ѿ����ع�,��֮�󲻻��ظ�����
 */
function ShowPHAPRASelReason(paramOpts, callBack, origOpts) {
    var reasonURL = ChangeCspPathToAll("pha.pra.v1.selreason.csp");
    var wayId = paramOpts.wayId || "";
    var oeori = paramOpts.oeori || "";
    var prescNo = paramOpts.prescNo || "";
    var selType = paramOpts.selType || "";
    if (top.$("#PHA_PRA_V1_SELREASON").html() != undefined) {
        top.$("#PHA_PRA_V1_SELREASON").panel("options").onBeforeClose = DoReturn;
        top.$("#PHA_PRA_V1_SELREASON").window("open");
        // ����������¼���,�������޸�����
        var reasonFrm;
        var frms = top.frames;
        for (var i = frms.length - 1; i >= 0; i--) {
            if (frms[i].TRELOADPAGE == "pha.pra.v1.selreason.csp") {
                reasonFrm = frms[i];
                break;
            }
        }
        reasonFrm.PRA_WAYID = wayId;
        reasonFrm.PRA_OEORI = oeori;
        reasonFrm.PRA_PRESCNO = prescNo;
        reasonFrm.PRA_SELTYPE = selType;
        reasonFrm.ReLoadPRASelReason();
        return;
    }
    websys_showModal({
        id: "PHA_PRA_V1_SELREASON",
        url: reasonURL + "?oeori=" + oeori + "&wayId=" + wayId + "&selType=" + selType + "&prescNo=" + prescNo,
        title: "�ܾ�ԭ��ѡ����¼��",
        iconCls: "icon-w-list",
        width: "80%",
        height: "80%",
        closable: false,
        onClose: function() {}, // ����ȥ��,����Ĭ�����ٴ���
        onBeforeClose: DoReturn
    });
    function DoReturn() {
        var reasonStr = "";
        if (top) {
            var reasonFrm;
            var frms = top.frames;
            for (var i = frms.length - 1; i >= 0; i--) {
                if (frms[i].TRELOADPAGE == "pha.pra.v1.selreason.csp") {
                    reasonFrm = frms[i];
                    break;
                }
            }
            if (reasonFrm != "") {
                var reasonStr = reasonFrm.PRA_SELREASON_RET;
            }
        }
        callBack(reasonStr, origOpts);
    }
}

function HotKeyInit(domCode, gridId) {
    OPKey_HotKey = tkMakeServerCall("PHA.OP.COM.Method", "GetHotKey", domCode, session["LOGON.GROUPID"], session["LOGON.CTLOCID"], session["LOGON.USERID"]);
    if (OPKey_HotKey != "{}") {
        OPKey_HotKey = JSON.parse(OPKey_HotKey);
        for (var item in OPKey_HotKey) {
            var doitmid = OPKey_HotKey[item];
            if (!$("#" + doitmid)) {
                continue;
            }
            var domDescOld = $("#" + doitmid)[0].textContent;
            var domDescNew = $("#" + doitmid)[0].textContent + "[" + item + "]";
            var htmlStr = $("#" + doitmid).html();
            $("#" + doitmid)[0].innerHTML = htmlStr.replace(domDescOld, domDescNew);
        }
    }
    OPKey_MainGrid = gridId;
    if (OPKey_MainGrid != "" && $("#" + OPKey_MainGrid)) {
        $("#" + OPKey_MainGrid).focus();
    }
    $(document).keydown(function(event) {
	    
        if (event.keyCode == "40") {
            //���������ӿ�ݼ������¼�ѡ��ҩ�б�����
            if (OPKey_MainGrid == undefined || OPKey_MainGrid == "" || !$("#" + OPKey_MainGrid)) {
                return;
            }
            var selectid = $("#" + OPKey_MainGrid).jqGrid("getGridParam", "selrow");
            var nextSelectid = parseInt(selectid) + 1;

            var rowDatas = $("#" + OPKey_MainGrid).jqGrid("getRowData");
            if (nextSelectid <= rowDatas.length) {
                $("#" + OPKey_MainGrid).setSelection(nextSelectid);
            }
        } else if (event.keyCode == "38") {
            //���������ӿ�ݼ������ϼ�ѡ��ҩ�б�����
            if (OPKey_MainGrid == undefined || OPKey_MainGrid == "" || !$("#" + OPKey_MainGrid)) {
                return;
            }
            var selectid = $("#" + OPKey_MainGrid).jqGrid("getGridParam", "selrow");
            var prveSelectid = parseInt(selectid) - 1;
            if (prveSelectid > 0) {
                $("#" + OPKey_MainGrid).setSelection(prveSelectid);
            }
        } else {
            //���������ӿ�ݼ�
            if(userAgent.indexOf("Chrome")>-1)
            {
	            if (OPKey_HotKey[event.originalEvent.code] != undefined) {
	                var domId = OPKey_HotKey[event.originalEvent.code];
	                if ($(domId)) {
	                    $("#" + domId).click();
	                }
	            }
            }else{
	            if (OPKey_HotKey[event.key] != undefined) {
	                var domId = OPKey_HotKey[event.key];
	                if ($(domId)) {
	                    $("#" + domId).click();
	                }
	            }
            }
        }
    });
}
/**
 * BootStrapǶ��HISUIҩѧ����
 */
function ShowPHAINPhcCat(paramOpts, callBack) {
    var phccatURL = ChangeCspPathToAll("pha.in.v3.ux.phccat.csp");
	var uxId="PHA_IN_V3_UX_PHCCAT"
    if (top.$("#"+uxId).html() != undefined) {
        top.$("#"+uxId).panel("options").onBeforeClose = DoReturn;
        top.$("#"+uxId).window("open");
        // ����������¼���,�������޸�����
        var returnFrm;
        var frms = top.frames;
        for (var i = frms.length - 1; i >= 0; i--) {
            if (frms[i].TRELOADPAGE == "pha.in.v3.ux.phccat.csp") {
                returnFrm = frms[i];
                break;
            }
        }
        returnFrm.ReLoadUXPhcCat();
        return;
    }
    websys_showModal({
        id: uxId,
        url: phccatURL,
        title: "ҩѧ����",
        iconCls: "icon-w-list",
        width: "600",
        height: "500",
        closable: true,
        onClose: function() {}, // ����ȥ��,����Ĭ�����ٴ���
        onBeforeClose: DoReturn
    });
    function DoReturn() {
        var phccatObj = {};
        if (top) {
            var returnFrm;
            var frms = top.frames;
            for (var i = frms.length - 1; i >= 0; i--) {
                if (frms[i].TRELOADPAGE == "pha.in.v3.ux.phccat.csp") {
                    returnFrm = frms[i];
                    break;
                }
            }
            if (returnFrm != "") {
                phccat = returnFrm.PHA_IN_V1_UX_PHCCAT_RET;
            }
        }
        callBack(phccat);
    }
}
