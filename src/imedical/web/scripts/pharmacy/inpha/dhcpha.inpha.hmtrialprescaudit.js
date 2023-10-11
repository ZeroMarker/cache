/*
ģ��:		��ҩ��
��ģ��:		��ҩ��-סԺ��ҩ��
Creator:	hulihua
CreateDate:	2018-12-19
*/
var NowTAB = "#div-presc-condition"; // ��¼��ǰtab
var AppType = "IA";
DHCPHA_CONSTANT.VAR.TIMER = "";
DHCPHA_CONSTANT.VAR.TIMERSTEP = 20 * 1000;
DHCPHA_CONSTANT.URL.THIS_URL = ChangeCspPathToAll("dhcpha.outpha.outmonitor.save.csp");

var MONITOR_PROP_STR=tkMakeServerCall("web.DHCINPHA.InfoCommon", "GetMonitorPropStr", DHCPHA_CONSTANT.SESSION.GROUP_ROWID, DHCPHA_CONSTANT.SESSION.GCTLOC_ROWID, DHCPHA_CONSTANT.SESSION.GUSER_ROWID);
var MONITOR_PROP_ARR=MONITOR_PROP_STR.split("^");
var RePassNeedCancle = MONITOR_PROP_ARR[1];
var PatientInfo = {
    adm: 0,
    patientID: 0,
    episodeID: 0,
    admType: "I",
    prescno: 0,
    orditem: 0,
    wardid: 0
};
$(function () {
    InitPhaConfig();
    /* ��ʼ����� start*/
    var daterangeoptions = {
        singleDatePicker: true
    }
    $("#date-start").dhcphaDateRange(daterangeoptions);
    $("#date-end").dhcphaDateRange(daterangeoptions);
    InitPhaLoc();
    InitPhaWard();
    InitGridPrescList();
    InitGridAdm();
    InitGridAdmPrescList();
    InitTrialDispTab();
    $("#monitor-condition").children().not("#div-presc-condition").hide();

    /* ��Ԫ���¼� start*/
    //�ǼǺŻس��¼�
    $('#txt-patno').on('keypress', function (event) {
        if (window.event.keyCode == "13") {
            var patno = $.trim($("#txt-patno").val());
            if (patno != "") {
                var newpatno = NumZeroPadding(patno, DHCPHA_CONSTANT.DEFAULT.PATNOLEN);
                $(this).val(newpatno);
                QueryGridPrescAudit();
            }
        }
    });

    //�������лس��¼�
    $("input[type=text]").on("keypress", function (e) {
        if (window.event.keyCode == "13") {
            return false;
        }
    })

    //�������а�ť�¼�
    $("button").on("keypress", function (e) {
        if (window.event.keyCode == "13") {
            return false;
        }
    })
    /* ��Ԫ���¼� end*/

    $("#chk-audit").on("ifChanged", function () {
        QueryGridPrescAudit()
    })

    InitIPOrderModalTab();
    InitBodyStyle();
})

window.onload = function () {
    if (LoadPatNo == "") {
        // �˵�����
        setTimeout("QueryGridPrescAudit()", 500);
    } else {
        // ��Ϣ����
        $("#tab-ipmonitor a").click();
        $("#txt-patno").val(LoadPatNo);
        InitParams();
        setTimeout("QueryGridPrescAudit()", 500);
    }
}
function InitParams(){
	if(LoadOrdItmId==""){return;}
	var retVal=tkMakeServerCall("PHA.COM.Method","GetOrdItmInfoForTipMess",LoadOrdItmId);
    if(retVal!="{}"){
	    var retJson=JSON.parse(retVal)
		var ordDate=retJson.ordDate;
		 $("#date-start").data('daterangepicker').setStartDate(ordDate);
		 $("#date-start").data('daterangepicker').setEndDate(ordDate);
	}
}
//��ʼ��ҩ������
function InitPhaConfig() {
    $.ajax({
        type: 'POST', //�ύ��ʽ post ����get  
        url: ChangeCspPathToAll(LINK_CSP) + "?ClassName=web.DHCSTPharmacyCommon&MethodName=GetInPhaConfig&locId=" + gLocId,
        data: "",
        success: function (value) {
            if (value != "") {
                SetPhaLocConfig(value)
            }
        },
        error: function () {
            alert("��ȡסԺҩ����������ʧ��!");
        }
    });
}
//����ҩ������
function SetPhaLocConfig(configstr) {
    var configarr = configstr.split("^");
    var startdate = configarr[2];
    var enddate = configarr[3];
    startdate = FormatDateT(startdate);
    enddate = FormatDateT(enddate);
    $("#date-start").data('daterangepicker').setStartDate(startdate);
    $("#date-start").data('daterangepicker').setEndDate(startdate);
    $("#date-end").data('daterangepicker').setStartDate(enddate);
    $("#date-end").data('daterangepicker').setEndDate(enddate);
    $("#sel-locinci").empty();
}

//��ʼ�������б�table
function InitGridPrescList() {
    var columns = [{
            name: 'druguse',
            index: 'druguse',
            header: '�������',
            width: 65,
            formatter: druguseFormatter
        },
        {
            name: "TAuditResult",
            index: "TAuditResult",
            header: '�󷽽��',
            width: 62,
            cellattr: addPhDispStatCellAttr
        },{
            name: "TDispState",
            index: "TDispState",
            header: '��ҩ״̬',
            width: 62,
            hidden: true
        },
        {
            name: "TPrescEmergen",
            index: "TPrescEmergen",
            header: '�Ƿ�Ӽ�',
            width: 70,
            cellattr: addStatCellAttr,
            formatter: function(value, options, rowdata){
				if(value == "Y"){
					return "��";	
				}else{
					return "��";	
				}
			}
        },
        {
            name: "TWardLoc",
            index: "TWardLoc",
            header: '����',
            width: 160,
            align: 'left',
            formatter: splitFormatter
        },
        {
            name: "TBedNo",
            index: "TBedNo",
            header: '����',
            width: 60
        },
        {
            name: "TPatNo",
            index: "TPatNo",
            header: '�ǼǺ�',
            width: 90
        },
        {
            name: "TPatName",
            index: "TPatName",
            header: '����',
            width: 80
        },
        {
            name: "TPrescNo",
            index: "TPrescNo",
            header: '������',
            width: 120
        },
        {
            name: "TPrescForm",
            index: "TPrescForm",
            header: '��������',
            width: 60
        },
        {
            name: "TFactor",
            index: "TFactor",
            header: '����',
            width: 50
        },
        {
            name: "TSeekUserName",
            index: "TSeekUserName",
            header: '�ύ��ʿ',
            width: 100
        },
        {
            name: "TSeekDate",
            index: "TSeekDate",
            header: '�ύʱ��',
            width: 155
        },
        {
            name: "TPhaomName",
            index: "TPhaomName",
            header: '���ҩʦ',
            width: 100
        },
        {
            name: "TPhaomDate",
            index: "TPhaomDate",
            header: '���ʱ��',
            width: 155
        },
        {
            name: "TRefResult",
            index: "TRefResult",
            header: '�ܾ�����',
            width: 300,
            align: 'left'
        },
        {
            name: "TDocNote",
            index: "TDocNote",
            header: '��������',
            width: 300,
            align: 'left'
        },
        {
            name: "TWardLocId",
            index: "TWardLocId",
            header: 'TWardLocId',
            width: 10,
            hidden: true
        },
        {
            name: "TAdmDr",
            index: "TAdmDr",
            header: 'TAdmDr',
            width: 10,
            hidden: true
        },
        {
            name: "TPapmiDr",
            index: "TPapmiDr",
            header: 'TPapmiDr',
            width: 10,
            hidden: true
        },
        {
            name: "TMoeori",
            index: "TMoeori",
            header: 'TMoeori',
            width: 10,
            hidden: true
        },
        {
            name: 'druguseresult',
            index: 'druguseresult',
            header: '����������',
            width: 65,
            hidden: true
        }
    ];
    var jqOptions = {
        colModel: columns, //��
        url: ChangeCspPathToAll(LINK_CSP) + '?ClassName=web.DHCINPHA.HMPrescPhaAudit.PrescPhaAuditQuery&MethodName=jsGetInAuditPrescList', //��ѯ��̨	
        fit: true,
        multiselect: false,
        pager: "#jqGridPager", //��ҳ�ؼ���id
        shrinkToFit: false,
        rownumbers: true,
        datatype: "local",
        onSelectRow: function (id, status) {
            if (id) {
                var selrowdata = $(this).jqGrid('getRowData', id);
                PatientInfo.adm = selrowdata.TAdmDr;
                PatientInfo.patientID = selrowdata.TPapmiDr;
            }
            QueryGridDispSub()
        },
        loadComplete: function () {
            var grid_records = $(this).getGridParam('records');
            if (grid_records == 0) {
                $("#ifrm-cypresc").attr("src", "");
            } else {
                $(this).jqGrid('setSelection', 1);
            }
        },
        gridComplete: function () {
            var ids = $("#grid-presclist").jqGrid("getDataIDs");
            var rowDatas = $("#grid-presclist").jqGrid("getRowData");
            for (var i = 0; i < rowDatas.length; i++) {
                var rowData = rowDatas[i];
                var warnLevel = rowData.TAuditResult;
                if (warnLevel.indexOf("����") >= 0) {
                    $("#grid-presclist" + " #" + ids[i] + " td").css({
                        color: '#FF0000',
                        'font-weight': 'bold'
                    });
                }
                var prescemergen = rowData.TPrescEmergen;
                if (prescemergen == "Y") {
                    $("#grid-presclist" + " #" + ids[i] + " td").css({
                        'color': '#000000',
                        'font-weight': 'bold'
                    });
                }
            }
            return true;
        }
    };
    $('#grid-presclist').dhcphaJqGrid(jqOptions);
}

//��ʼ���˾���table
function InitGridAdm() {
    var columns = [{
            name: "TAdm",
            index: "TAdm",
            header: 'TAdm',
            width: 10,
            hidden: true
        },
        {
            name: "TCurrWard",
            index: "TCurrWard",
            header: '����',
            width: 100,
            align: 'left',
            formatter: splitFormatter
        },
        {
            name: "TPatNo",
            index: "TPatNo",
            header: '�ǼǺ�',
            width: 80
        },
        {
            name: "TCurrentBed",
            index: "TCurrentBed",
            header: '����',
            width: 60
        },
        {
            name: "TDoctor",
            index: "TDoctor",
            header: 'ҽ��',
            width: 60
        },
        {
            name: "TAdmDate",
            index: "TAdmDate",
            header: '��������',
            width: 80
        },
        {
            name: "TAdmTime",
            index: "TAdmTime",
            header: '����ʱ��',
            width: 80
        },
        {
            name: "TAdmLoc",
            index: "TAdmLoc",
            header: '�������',
            width: 80,
            align: 'left',
            formatter: splitFormatter
        },
        {
            name: "TPapmi",
            index: "TPapmi",
            header: 'papmi',
            width: 80,
            align: 'left',
            hidden: true
        }
    ];

    var jqOptions = {
        colModel: columns, //��
        url: ChangeCspPathToAll(LINK_CSP) + '?ClassName=web.DHCINPHA.HMTrialDrugDisp.TrialDrugDispQuery&MethodName=jsQueryDispAdmList', //��ѯ��̨
        height: DhcphaJqGridHeight(2, 3) * 0.35,
        multiselect: false,
        onSelectRow: function (id, status) {
            var id = $(this).jqGrid('getGridParam', 'selrow');
            if (id) {
                var selrowdata = $(this).jqGrid('getRowData', id);
                var adm = selrowdata.TAdm;
                PatientInfo.adm = selrowdata.TAdm;
                PatientInfo.patientID = selrowdata.TPapmi;
                $("#grid-admpresclist").jqGrid("clearGridData");
                var params = GetMainCodParams();
                params = params + "^" + adm;
                $("#grid-admpresclist").setGridParam({
                    datatype: 'json',
                    page: 1,
                    postData: {
                        'params': params
                    }
                }).trigger("reloadGrid");
            }
        },
        loadComplete: function () {
            var grid_records = $(this).getGridParam('records');
            if (grid_records == 0) {
                $("#grid-admpresclist").jqGrid("clearGridData");
            } else {
                $(this).jqGrid('setSelection', 1);
            }
        }
    };
    $('#grid-admlist').dhcphaJqGrid(jqOptions);
}

//��ʼ�����˾��ﴦ���б�table
function InitGridAdmPrescList() {
    var columns = [{
            name: 'druguse',
            index: 'druguse',
            header: '�������',
            width: 65,
            formatter: druguseFormatter
        },
        {
            name: "TAuditResult",
            index: "TAuditResult",
            header: '�󷽽��',
            width: 62
        },{
            name: "TDispState",
            index: "TDispState",
            header: '��ҩ״̬',
            width: 62,
            hidden: true
        },
        {
            name: "TPrescEmergen",
            index: "TPrescEmergen",
            header: '�Ƿ�Ӽ�',
            width: 70,
            cellattr: addStatCellAttr,
            formatter: function(value, options, rowdata){
				if(value == "Y"){
					return "��";	
				}else{
					return "��";	
				}
			}
        },
        {
            name: "TWardLoc",
            index: "TWardLoc",
            header: '����',
            width: 160,
            align: 'left',
            formatter: splitFormatter
        },
        {
            name: "TBedNo",
            index: "TBedNo",
            header: '����',
            width: 60
        },
        {
            name: "TPatNo",
            index: "TPatNo",
            header: '�ǼǺ�',
            width: 90
        },
        {
            name: "TPatName",
            index: "TPatName",
            header: '����',
            width: 80
        },
        {
            name: "TPrescNo",
            index: "TPrescNo",
            header: '������',
            width: 120
        },
        {
            name: "TPrescForm",
            index: "TPrescForm",
            header: '��������',
            width: 60
        },
        {
            name: "TFactor",
            index: "TFactor",
            header: '����',
            width: 50
        },
        {
            name: "TSeekUserName",
            index: "TSeekUserName",
            header: '�ύ��ʿ',
            width: 100
        },
        {
            name: "TSeekDate",
            index: "TSeekDate",
            header: '�ύʱ��',
            width: 155
        },
        {
            name: "TPhaomName",
            index: "TPhaomName",
            header: '���ҩʦ',
            width: 100
        },
        {
            name: "TPhaomDate",
            index: "TPhaomDate",
            header: '���ʱ��',
            width: 155
        },
        {
            name: "TRefResult",
            index: "TRefResult",
            header: '�ܾ�����',
            width: 300,
            align: 'left'
        },
        {
            name: "TDocNote",
            index: "TDocNote",
            header: '��������',
            width: 300,
            align: 'left'
        },
        {
            name: "TWardLocId",
            index: "TWardLocId",
            header: 'TWardLocId',
            width: 10,
            hidden: true
        },
        {
            name: "TAdmDr",
            index: "TAdmDr",
            header: 'TAdmDr',
            width: 10,
            hidden: true
        },
        {
            name: "TPapmiDr",
            index: "TPapmiDr",
            header: 'TPapmiDr',
            width: 10,
            hidden: true
        },
        {
            name: "TMoeori",
            index: "TMoeori",
            header: 'TMoeori',
            width: 10,
            hidden: true
        },
        {
            name: 'druguseresult',
            index: 'druguseresult',
            header: '����������',
            width: 65,
            hidden: true
        }
    ];
    var jqOptions = {
        colModel: columns, //��
        url: ChangeCspPathToAll(LINK_CSP) + '?ClassName=web.DHCINPHA.HMPrescPhaAudit.PrescPhaAuditQuery&MethodName=jsGetInAuditPrescList', //��ѯ��̨	
        height: DhcphaJqGridHeight(2, 3) * 0.55,
        fit: true,
        multiselect: false,
        shrinkToFit: false,
        datatype: "local",
        pager: "#jqGridPager1",
        onSelectRow: function (id, status) {
            QueryGridDispSub()
        },
        loadComplete: function () {
            var grid_records = $(this).getGridParam('records');
            if (grid_records == 0) {
                $("#ifrm-cypresc").attr("src", "");
            } else {
                $(this).jqGrid('setSelection', 1);
            }
        },
        gridComplete: function () {
            var ids = $("#grid-admpresclist").jqGrid("getDataIDs");
            var rowDatas = $("#grid-admpresclist").jqGrid("getRowData");
            for (var i = 0; i < rowDatas.length; i++) {
                var rowData = rowDatas[i];
                var warnLevel = rowData.TAuditResult;
                if (warnLevel.indexOf("����") >= 0) {
                    $("#grid-admpresclist" + " #" + ids[i] + " td").css({
                        color: '#FF0000',
                        'font-weight': 'bold'
                    });
                }
                var prescemergen = rowData.TPrescEmergen;
                if (prescemergen == "Y") {
                    $("#grid-admpresclist" + " #" + ids[i] + " td").css({
                        color: '#000000',
                        'font-weight': 'bold'
                    });
                }
            }
            return true;
        }
    };
    $('#grid-admpresclist').dhcphaJqGrid(jqOptions);
}

function ClearConditons() {
    $('#grid-presclist').clearJqGrid();
}

function InitTrialDispTab() {
    $("#tab-ipmonitor a").on('click', function () {
        $("#ifrm-cypresc").empty();
        var tabId = $(this).attr("id");
        var tmpTabId = "#div-" + tabId.split("-")[1] + "-condition";
        $(tmpTabId).show();
        $("#monitor-condition").children().not(tmpTabId).hide();
        NowTAB = tmpTabId;
        QueryGridPrescAudit();
    })
}

function QueryGridPrescAudit() {
    if (NowTAB == "#div-presc-condition") {
        var params = GetMainCodParams();
        $("#grid-presclist").setGridParam({
            datatype: 'json',
            page: 1,
            postData: {
                'params': params
            }
        }).trigger("reloadGrid");
    } else {
        var patno = $("#txt-patno").val();
        if (patno == "") {
            var selectid = $("#grid-admlist").jqGrid('getGridParam', 'selrow');
            var selrowdata = $("#grid-admlist").jqGrid('getRowData', selectid);
            patno = selrowdata.TPatNo;
        }
        $("#grid-admlist").setGridParam({
            page: 1,
            datatype: 'json',
            postData: {
                'params': patno,
                'logonLocId': DHCPHA_CONSTANT.SESSION.GCTLOC_ROWID
            }
        }).trigger("reloadGrid");
    }

    $("#txt-patno").val("");
    return true;
}

//��ѯ��ҩ��ϸ
function QueryGridDispSub() {
    if (NowTAB == "#div-presc-condition") {
        var selectid = $("#grid-presclist").jqGrid('getGridParam', 'selrow');
        var selrowdata = $("#grid-presclist").jqGrid('getRowData', selectid);
    } else {
        var selectid = $("#grid-admpresclist").jqGrid('getGridParam', 'selrow');
        var selrowdata = $("#grid-admpresclist").jqGrid('getRowData', selectid);
    }
    var prescno = selrowdata.TPrescNo;
    var prescform = selrowdata.TPrescForm;
    QueryPrescDetail(prescno);
}

function QueryPrescDetail(prescno) {
    $("#ifrm-cypresc").empty();
    //var htmlstr = GetPrescHtml(prescno);
    //$("#ifrm-cypresc").append(htmlstr);
    GetPrescHtml(prescno);
}

function GetPrescHtml(prescNo) {
	var phartype = "IP";		// סԺ����
	var zfFlag = "�׷�"
	var useFlag = "2" 			// �������
	var cyflag = "Y"

    PHA_PRESC.PREVIEW({
		prescNo: prescNo,			
		preAdmType: phartype,
		zfFlag: zfFlag,
		prtType: 'DISPPREVIEW',
		useFlag: useFlag,
		iframeID: 'ifrm-cypresc',
		cyFlag: cyflag
	});
    //$("#ifrm-cypresc").attr("src", ChangeCspPathToAll("dhcpha/dhcpha.common.prescpreview.csp") + "?paramsstr=" + paramsstr + "&PrtType=DISPPREVIEW");
}

//��ȡ��ѯ����
function GetMainCodParams() {
    var startdate = $("#date-start").val();
    var enddate = $("#date-end").val();
    var phaloc = $('#sel-phaloc').val();
    if (phaloc == null) {
        phaLoc = ""
    }
    if (phaloc == "") {
        dhcphaMsgBox.alert("ҩ��������Ϊ��!");
        return;
    }
    var wardloc = $('#sel-phaward').val();
    if (wardloc == null) {
        wardloc = ""
    };
    var chkaudit = "";
    if ($("#chk-audit").is(':checked')) {
        chkaudit = "Y";
    } else {
        chkaudit = "";
    }
    var params = startdate + "^" + enddate + "^" + phaloc + "^" + wardloc + "^" + chkaudit;
    return params;
}

function splitFormatter(cellvalue, options, rowObject) {
    if (cellvalue.indexOf("-") >= 0) {
        cellvalue = cellvalue.split("-")[1];
    }
    return cellvalue;
};

//��ͨ��
function PassIPOrder() {
    if (NowTAB == "#div-presc-condition") {
        var grid_records = $("#grid-presclist").getGridParam('records');
        var selectid = $("#grid-presclist").jqGrid('getGridParam', 'selrow');
        var selrowdata = $("#grid-presclist").jqGrid('getRowData', selectid);
    } else {
        var grid_records = $("#grid-admpresclist").getGridParam('records');
        var selectid = $("#grid-admpresclist").jqGrid('getGridParam', 'selrow');
        var selrowdata = $("#grid-admpresclist").jqGrid('getRowData', selectid);
    }
    if (grid_records == 0) {
        dhcphaMsgBox.alert("�����б�û������!");
        return;
    }
    if ((selectid == "") || (selectid == null)) {
        dhcphaMsgBox.alert("����ѡ����Ҫ��ͨ���Ĵ���!");
        return;
    }
    var dispStatus = selrowdata.TDispState;
    if (dispStatus.indexOf("�ѷ�ҩ")>-1) {
        dhcphaMsgBox.alert("�ô����Ѿ���ҩ,�������ͨ��!");
        return;
    }
    var auditresult = selrowdata.TAuditResult;
    if (auditresult.indexOf("����")>-1) {
        dhcphaMsgBox.alert("�ô������Ѿ�����,�������ͨ��!");
        return;
    }
    if(RePassNeedCancle=="Y"){
	    if (auditresult == "ͨ��") {
	        dhcphaMsgBox.alert("��ѡ��Ĵ�����ͨ��,�����ٴ����ͨ�� !");
	        return;
	    }
	    else if (auditresult.indexOf("�ܾ�") != "-1"){
		    dhcphaMsgBox.alert("��ѡ��Ĵ����Ѿܾ�,�賷��֮ǰ����˼�¼�����ٴ���� !");
	        return;
		}
    }
    var PrescNo = selrowdata.TPrescNo;
    var resultstr = tkMakeServerCall("web.DHCINPHA.HMTrialDrugDisp.TrialDrugDispQuery", "GetOrdStrByPrescno", PrescNo);
    var orditmstr = resultstr.split("&&")[0];
    if (orditmstr == "") {
        dhcphaMsgBox.alert("�ô���û����Ч��ϸ��Ϣ!");
        return;
    }
    var orditemStr = tkMakeServerCall("web.DHCINPHA.HMTrialDrugDisp.TrialDrugDispQuery", "GetOrdStrByPrescno", PrescNo);
    var orditem = orditemStr.split("&&")[1];
    var ret = "Y";
    var reasondr = "";
    var advicetxt = "";
    var factxt = "";
    var phnote = "";
    var guser = session['LOGON.USERID'];
    var ggroup = session['LOGON.GROUPID'];
    var input = ret + "^" + guser + "^" + advicetxt + "^" + factxt + "^" + phnote + "^" + ggroup + "^" + orditem;
    var input = input + "^" + AppType;
    SaveCommontResult(reasondr, input, PrescNo);
}

//��˾ܾ�
function RefuseIPOrder() {
    if (NowTAB == "#div-presc-condition") {
        var grid_records = $("#grid-presclist").getGridParam('records');
        var selectid = $("#grid-presclist").jqGrid('getGridParam', 'selrow');
        var selrowdata = $("#grid-presclist").jqGrid('getRowData', selectid);
    } else {
        var grid_records = $("#grid-admpresclist").getGridParam('records');
        var selectid = $("#grid-admpresclist").jqGrid('getGridParam', 'selrow');
        var selrowdata = $("#grid-admpresclist").jqGrid('getRowData', selectid);
    }
    if (grid_records == 0) {
        dhcphaMsgBox.alert("�����б�û������!");
        return;
    }
    if ((selectid == "") || (selectid == null)) {
        dhcphaMsgBox.alert("����ѡ����Ҫ�ܾ��Ĵ���!");
        return;
    }
    var dispStatus = selrowdata.TDispState;
    if (dispStatus.indexOf("�ѷ�ҩ")>-1) {
        dhcphaMsgBox.alert("�ô����Ѿ���ҩ,������˾ܾ�!");
        return;
    }
    var auditresult = selrowdata.TAuditResult;
    if (auditresult.indexOf("����")>-1) {
        dhcphaMsgBox.alert("�ô������Ѿ�����,������˾ܾ�!");
        return;
    }
    if(RePassNeedCancle=="Y"){
	    if (auditresult == "ͨ��") {
	        dhcphaMsgBox.alert("��ѡ��Ĵ�����ͨ��,�賷��֮ǰ����˼�¼�����ٴ���� !");
	        return;
	    }
	    else if (auditresult.indexOf("�ܾ�") != "-1"){
		    dhcphaMsgBox.alert("��ѡ��Ĵ����Ѿܾ�,�賷��֮ǰ����˼�¼�����ٴ���� !");
	        return;
		}
    }
    var PrescNo = selrowdata.TPrescNo;
    var resultstr = tkMakeServerCall("web.DHCINPHA.HMTrialDrugDisp.TrialDrugDispQuery", "GetOrdStrByPrescno", PrescNo);
    //console.log(resultstr)
    var orditmstr = resultstr.split("&&")[0];
    if (orditmstr == "") {
        dhcphaMsgBox.alert("�ô���û����Ч��ϸ��Ϣ!");
        return;
    }else if(orditmstr == "-1"){
	    dhcphaMsgBox.alert(resultstr.split("&&")[1]);
        return;
	}
    var waycode = InPhaWay;
    ShowPHAPRASelReason({
		wayId:waycode,
		oeori:"",
		prescNo:PrescNo,
		selType:"PRESCNO"
	},SaveCommontResultEX,{PrescNo:PrescNo,resultstr:resultstr});   
}
function SaveCommontResultEX(reasonStr,origOpts){
	if (reasonStr==""){
		return;
	}
	var resultstr=origOpts.resultstr;
    var retarr = reasonStr.split("@");
    var ret = "N";
    var reasondr = retarr[0];
    var advicetxt = retarr[2];
    var factxt = retarr[1];
    var phnote = retarr[3];
    var APPTYPE = "IA";
    var mainorditm = resultstr.split("&&")[1];
    var input = ret + "^" + gUserID + "^" + advicetxt + "^" + factxt + "^" + phnote + "^" + gGroupId + "^" + mainorditm + "^" + APPTYPE;
    SaveCommontResult(reasondr, input, origOpts.PrescNo)
}

//���ͨ��/�ܾ�
function SaveCommontResult(reasondr, input, prescno) {
    $.ajax({
        url: DHCPHA_CONSTANT.URL.THIS_URL + '?action=SaveItmResultIPMo&Input=' + encodeURI(input) + '&ReasonDr=' + encodeURI(reasondr) + '&PrescNo=' + encodeURI(prescno),
        type: 'post',
        success: function (data) {
            var retjson = JSON.parse(data);
            if (retjson.retvalue == 0) {
                QueryGridPrescAudit();
                if (top && top.HideExecMsgWin) {
                    top.HideExecMsgWin();
                }
            } else {
                dhcphaMsgBox.alert(retjson.retinfo);
                return
            }
        },
        error: function () {}
    })
}

//ҽ�������չ��Ϣmodal
function ViewIPOrderAddInfo() {
    if (NowTAB == "#div-presc-condition") {
        var grid_records = $("#grid-presclist").getGridParam('records');
        var selectid = $("#grid-presclist").jqGrid('getGridParam', 'selrow');
        var selrowdata = $("#grid-presclist").jqGrid('getRowData', selectid);
    } else {
        var grid_records = $("#grid-admpresclist").getGridParam('records');
        var selectid = $("#grid-admpresclist").jqGrid('getGridParam', 'selrow');
        var selrowdata = $("#grid-admpresclist").jqGrid('getRowData', selectid);
    }
    if (grid_records == 0) {
        dhcphaMsgBox.alert("�����б�û������!");
        return;
    }
    if ((selectid == "") || (selectid == null)) {
        dhcphaMsgBox.alert("����ѡ����Ҫ�鿴�Ĵ�����¼!");
        return;
    }
    $("#modal-prescinfo").modal('show');
}

//�鿴��־
function ViewIPOrderMonitorLog() {
    if (NowTAB == "#div-presc-condition") {
        var grid_records = $("#grid-presclist").getGridParam('records');
        var selectid = $("#grid-presclist").jqGrid('getGridParam', 'selrow');
        var selrowdata = $("#grid-presclist").jqGrid('getRowData', selectid);
    } else {
        var grid_records = $("#grid-admpresclist").getGridParam('records');
        var selectid = $("#grid-admpresclist").jqGrid('getGridParam', 'selrow');
        var selrowdata = $("#grid-admpresclist").jqGrid('getRowData', selectid);
    }
    if (grid_records == 0) {
        dhcphaMsgBox.alert("�����б�û������!");
        return;
    }
    if ((selectid == "") || (selectid == null)) {
        dhcphaMsgBox.alert("����ѡ����Ҫ�鿴�Ĵ�����¼!");
        return;
    }
    var orditm = selrowdata.TMoeori;
    var logoptions = {
        id: "#modal-monitorlog",
        orditm: orditm,
        fromgrid: "#grid-cypresc",
        fromgridselid: selectid
    };
    InitOutMonitorLogBody(logoptions)
}

//��������
function PrescAnalyse() {
    var passType = tkMakeServerCall("web.DHCINPHA.InfoCommon", "GetPassProp", gGroupId, gLocId, gUserID);
    if (passType == "") {
        dhcphaMsgBox.alert("δ���ô��������ӿڣ����ڲ�������-סԺҩ��-������ҩ�����������Ӧ����");
        return;
    }
    if (passType == "DHC") {
        if (NowTAB == "#div-presc-condition") {
            var grid = "grid-presclist";
        } else {
            var grid = "grid-admpresclist";
        }
        // ����֪ʶ��
        DHCSTPHCMPASS.PassAnalysis({
            GridId: grid,
            MOeori: "TMoeori",
            PrescNo: "TPrescNo",
            GridType: "JqGrid",
            Field: "druguse",
            ResultField: "druguseresult"
        });
    } else if (passType == "DT") {
        // ��ͨ
        // StartDaTongDll(); 
        // DaTongPrescAnalyse();  
    } else if (passType == "MK") {
        // ����
        //MKPrescAnalyse(); 
    } else if (passType == "YY") {}
}

//�Զ�ˢ��
function AutoRefreshMonitor() {
    if ($("#btn-autorefresh").children("strong").text().indexOf("�Զ�")) {
        $("#btn-autorefresh").css("color", "#727272");
        $("#btn-autorefresh").children("i").css("color", "#999999");
        $("#btn-autorefresh").children("strong").css("color", "#727272");
        $("#btn-autorefresh").children("strong").text("�Զ�ˢ��");
        clearInterval(DHCPHA_CONSTANT.VAR.TIMER);
    } else {
        $("#btn-autorefresh").css("color", "#40A2DE");
        $("#btn-autorefresh").children("i").css("color", "#40A2DE");
        $("#btn-autorefresh").children("strong").css("color", "#40A2DE");
        $("#btn-autorefresh").children("strong").text("ֹͣˢ��");
        DHCPHA_CONSTANT.VAR.TIMER = setInterval("QueryGridPrescAudit();", DHCPHA_CONSTANT.VAR.TIMERSTEP);
    }
}

function addPhDispStatCellAttr(rowId, val, rawObject, cm, rdata) {
    if (val == "ͨ��") {
        return "class=dhcpha-record-passed";
    } else if (val == "����") {
        return "class=dhcpha-record-appeal";
    } else if (val == "�ܾ�") {
        return "class=dhcpha-record-refused";
    } else if (val == "�ܾ�(����)") {
        return "class=dhcpha-record-reaccept";
    } else {
        return "";
    }
}

function addStatCellAttr(rowId, val, rawObject, cm, rdata) {
    if (val == "Y") {
        return "class=dhcpha-record-refused";
    } else {
        return "";
    }
}

function InitBodyStyle() {

    var wardtitleheight = $("#gview_grid-presclist .ui-jqgrid-hbox").height();
    var wardheight = DhcphaJqGridHeight(1, 0) - wardtitleheight - 48;
    var prescheight = DhcphaJqGridHeight(1, 0) - 15;
    $("#grid-presclist").setGridHeight(wardheight);
    $("#ifrm-cypresc").height(prescheight);
}

//ע��modaltab�¼�
function InitIPOrderModalTab() {
    $("#ul-monitoraddinfo a").on('click', function () {
        var adm = PatientInfo.adm;
        var patientID = PatientInfo.patientID;
        var tabId = $(this).attr("id")
        /* MaYuqiang 20220517 ��������Ϣ����ͷ�˵����������ý��洮���� */
        var menuWin = websys_getMenuWin();  // ���ͷ�˵�Window����
        if (menuWin){		
            var frm = dhcsys_getmenuform(); //menuWin.document.forms['fEPRMENU'];
            if((frm) &&(frm.EpisodeID.value != adm)){
                if (menuWin.MainClearEpisodeDetails) menuWin.MainClearEpisodeDetails();  //���ͷ�˵������в��������Ϣ
                frm.EpisodeID.value = adm; 
                frm.PatientID.value = patientID;
            }
        }
        if (tabId == "tab-allergy") {
            $('#ifrm-outmonitor').attr('src', ChangeCspPathToAll('dhcdoc.allergyenter.csp') + '?PatientID=' + patientID + '&EpisodeID=' + adm + "&IsOnlyShowPAList=Y");
        }
        if (tabId == "tab-risquery") {
            $('#ifrm-outmonitor').attr('src', ChangeCspPathToAll('dhcapp.inspectrs.csp') + '?PatientID=' + patientID + '&EpisodeID=' + adm);
        }
        if (tabId == "tab-libquery") {
            $('#ifrm-outmonitor').attr('src', ChangeCspPathToAll('dhcapp.seepatlis.csp') + '?PatientID=' + patientID + '&EpisodeID=' + adm + '&NoReaded=' + '1');
        }
        if (tabId == "tab-eprquery") {
        	$('#ifrm-outmonitor').attr('src', ChangeCspPathToAll('emr.browse.manage.csp') + '?PatientID=' + patientID + '&EpisodeID=' + adm + '&EpisodeLocID=' + gLocId);
            //$('#ifrm-outmonitor').attr('src', ChangeCspPathToAll('emr.interface.browse.episode.csp') + '?PatientID=' + patientID + '&EpisodeID=' + adm + '&EpisodeLocID=' + gLocId);
        }
        if (tabId == "tab-orderquery") {
            $('#ifrm-outmonitor').attr('src', ChangeCspPathToAll('ipdoc.patorderview.csp')  +'?EpisodeID=' + adm + '&PageShowFromWay=ShowFromEmrList&DefaultOrderPriorType=ALL');
            //$('#ifrm-outmonitor').attr('src', ChangeCspPathToAll('oeorder.opbillinfo.csp'+'?EpisodeID=' +adm)); 
        }
        if (tabId == "tab-beforeindrug") {
            $('#ifrm-outmonitor').attr('src', ChangeCspPathToAll('dhcpha.comment.othmedquery.csp') + '?EpisodeID=' + adm);
        }
    })

    $('#modal-prescinfo').on('show.bs.modal', function () {
        $("#modal-prescinfo .modal-dialog").width($(window).width() * 0.9);
        $("#modal-prescinfo .modal-body").height($(window).height() * 0.85);
        var tmpiframeheight = $(window).height() * 0.85 -
            $("#modal-prescinfo .modal-header").height() -
            $("#modal-prescinfo #ul-monitoraddinfo").height() -
            50
        $("#ifrm-outmonitor").height(tmpiframeheight)
        //$("#ifrm-outmonitor").attr('src', ChangeCspPathToAll("dhcpha.comment.queryorditemds.csp") + "?EpisodeID=" + PatientInfo.adm);
        $('#ifrm-outmonitor').attr('src', ChangeCspPathToAll('dhcdoc.allergyenter.csp') + '?PatientID=' + PatientInfo.patientID + '&EpisodeID=' + PatientInfo.adm + "&IsOnlyShowPAList=Y");
        var selectid = $("#grid-presclist").jqGrid('getGridParam', 'selrow');
        var selectdata = $('#grid-presclist').jqGrid('getRowData', selectid);
        var orditem = selectdata.TMoeori;
        var patoptions = {
            id: "#dhcpha-patinfo",
            orditem: orditem
        };
        AppendPatientOrdInfo(patoptions);
        var tabId = $(this).attr("id");
        if (tabId != "tab-allergy") {
            setTimeout("ClickAllergy()",100);
        }
    })
    $("#modal-prescinfo").on("hidden.bs.modal", function () {
        //$(this).removeData("bs.modal");
    });
    $("#tab-viewpresc").hide();
}

function ClickAllergy()
{
	$("#tab-allergy").click();
}

//��ʽ����
function druguseFormatter(cellvalue, options, rowdata) {
    if (cellvalue == undefined) {
        cellvalue = "";
    }
    var imageid = "";
    if (cellvalue == "0") {
        imageid = "warning0.gif";
    } else if (cellvalue == "1") {
        imageid = "yellowlight.gif";
    } else if (cellvalue == "2") {
        imageid = "warning2.gif"
    } else if (cellvalue == "3") {
        imageid = "warning3.gif"
    } else if (cellvalue == "4") {
        imageid = "warning4.gif"
    }
    if (imageid == "") {
        return cellvalue;
    }
    return '<img src="'+DHCPHA_CONSTANT.URL.PATH+'/scripts/pharmacy/images/'+imageid+'" alt="' + cellvalue + '" ></img>'
    //return '<img src="../scripts/pharmacy/images/' + imageid + '" ></img>'
}

/***********************������� start****************************/
// add by MaYuqiang 20181025	
function MKPrescAnalyse() {

    var mainrows = $("#grid-presc").getGridParam('records');
    if (mainrows == 0) {
        dhcphaMsgBox.alert("û����ϸ��¼!");
        return;
    }

    for (var i = 1; i <= mainrows; i++) {
        var tmprowdata = $('#grid-presc').jqGrid('getRowData', i);
        var orditem = tmprowdata.orditem;
        var prescno = tmprowdata.prescno;

        var myrtn = HLYYPreseCheck(prescno, 0);

        var newdata = {
            druguse: myrtn
        };
        $("#grid-presc").jqGrid('setRowData', i, newdata);
    }
}


function HLYYPreseCheck(prescno, flag) {
    var XHZYRetCode = 0 //������鷵�ش���
    MKXHZY1(prescno, flag);
    //��Ϊͬ������,ȡ��McPASS.ScreenHighestSlcode
    //��Ϊ�첽����,����ûص���������.
    //ͬ���첽ΪMcConfig.js MC_Is_SyncCheck true-ͬ��;false-�첽
    XHZYRetCode = McPASS.ScreenHighestSlcode;
    return XHZYRetCode
}

function MKXHZY1(prescno, flag) {
    MCInit1(prescno);
    HisScreenData1(prescno);
    MDC_DoCheck(HIS_dealwithPASSCheck, flag);
}

function MCInit1(prescno) {
    var PrescStr = tkMakeServerCall("web.DHCSTPIVADaTongInterface", "GetPrescMainInfo", prescno);
    var prescdetail = PrescStr.split("^")
    var pass = new Params_MC_PASSclient_In();
    pass.HospID = prescdetail[0];
    pass.UserID = prescdetail[1];
    pass.UserName = prescdetail[2];
    pass.DeptID = prescdetail[3];
    pass.DeptName = prescdetail[4];
    pass.CheckMode = "zyf" //MC_global_CheckMode;
    MCPASSclient = pass;
}

function HIS_dealwithPASSCheck(result) {
    if (result > 0) {} else {
        //alert("û����");
    }

    return result;
}


function HisScreenData1(prescno) {
    var Orders = "";
    var Para1 = ""

    var PrescMStr = tkMakeServerCall("web.DHCSTPIVADaTongInterface", "GetPrescMainInfo", prescno);
    var PrescMInfo = PrescMStr.split("^")
    var Orders = tkMakeServerCall("web.DHCSTPIVADaTongInterface", "GetPrescDetailInfo", prescno);
    if (Orders == "") {
        return;
    }
    var DocName = PrescMInfo[2];
    var EpisodeID = PrescMInfo[5];
    if (EpisodeID == "") {
        return
    }
    var ret = tkMakeServerCall("web.DHCHLYY", "GetPrescInfo", EpisodeID, Orders, DocName);
    var TempArr = ret.split(String.fromCharCode(2));
    var PatInfo = TempArr[0];
    var MedCondInfo = TempArr[1];
    var AllergenInfo = TempArr[2];
    var OrderInfo = TempArr[3];
    var PatArr = PatInfo.split("^");


    var ppi = new Params_MC_Patient_In();
    ppi.PatCode = PatArr[0]; // ���˱���
    ppi.InHospNo = PatArr[11]
    ppi.VisitCode = PatArr[7] // סԺ����
    ppi.Name = PatArr[1]; // ��������
    ppi.Sex = PatArr[2]; // �Ա�
    ppi.Birthday = PatArr[3]; // ��������

    ppi.HeightCM = PatArr[5]; // ���
    ppi.WeighKG = PatArr[6]; // ����
    ppi.DeptCode = PatArr[8]; // סԺ����
    ppi.DeptName = PatArr[12]
    ppi.DoctorCode = PatArr[13]; // ҽ��
    ppi.DoctorName = PatArr[9]
    ppi.PatStatus = 1
    ppi.UseTime = PatArr[4]; // ʹ��ʱ��
    ppi.CheckMode = MC_global_CheckMode
    ppi.IsDoSave = 1
    MCpatientInfo = ppi;
    var arrayDrug = new Array();
    var pri;
    var OrderInfoArr = OrderInfo.split(String.fromCharCode(1));
    //alert(OrderInfo)
    McRecipeCheckLastLightStateArr = new Array();
    for (var i = 0; i < OrderInfoArr.length; i++) {
        var OrderArr = OrderInfoArr[i].split("^");
        //����core�ģ�������core���ر�Ƶ�Ψһ��ţ�����ĵ�div��idҲӦ�ú���������
        drug = new Params_Mc_Drugs_In();

        drug.Index = OrderArr[0]; //ҩƷ���
        drug.OrderNo = OrderArr[0]; //ҽ����
        drug.DrugUniqueCode = OrderArr[1]; //ҩƷ����
        drug.DrugName = OrderArr[2]; //ҩƷ����
        drug.DosePerTime = OrderArr[3]; //��������
        drug.DoseUnit = OrderArr[4]; //��ҩ��λ      
        drug.Frequency = OrderArr[5]; //��ҩƵ��
        drug.RouteCode = OrderArr[8]; //��ҩ;������
        drug.RouteName = OrderArr[8]; //��ҩ;������
        drug.StartTime = OrderArr[6]; //����ʱ��
        drug.EndTime = OrderArr[7]; //ͣ��ʱ��
        drug.ExecuteTime = ""; //ִ��ʱ��
        drug.GroupTag = OrderArr[10]; //������
        drug.IsTempDrug = OrderArr[11]; //�Ƿ���ʱ��ҩ 0-���� 1-��ʱ
        drug.OrderType = 0; //ҽ������� 0-����(Ĭ��);1-������;2-��ͣ��;3-��Ժ��ҩ
        drug.DeptCode = PrescMInfo[7].split("-")[1]; //�������ұ���
        drug.DeptName = PrescMInfo[4]; //������������
        drug.DoctorCode = PrescMInfo[6]; //����ҽ������
        drug.DoctorName = PrescMInfo[2]; //����ҽ������
        drug.RecipNo = ""; //������
        drug.Num = ""; //ҩƷ��������
        drug.NumUnit = ""; //ҩƷ����������λ          
        drug.Purpose = 0; //��ҩĿ��(1Ԥ����2���ƣ�3Ԥ��+����, 0Ĭ��)  
        drug.OprCode = ""; //�������,���Ӧ������,��','����,��ʾ��ҩΪ�ñ�Ŷ�Ӧ��������ҩ
        drug.MediTime = ""; //��ҩʱ��(��ǰ,����,����)(0-δʹ��1- 0.5h����,2-0.5-2h,3-��2h)
        drug.Remark = ""; //ҽ����ע 
        arrayDrug[arrayDrug.length] = drug;

    }
    McDrugsArray = arrayDrug;
    var arrayAllergen = new Array();
    var pai;
    var AllergenInfoArr = AllergenInfo.split(String.fromCharCode(1));
    for (var i = 0; i < AllergenInfoArr.length; i++) {
        var AllergenArr = AllergenInfoArr[i].split("^");

        var allergen = new Params_Mc_Allergen_In();
        allergen.Index = i; //���  
        allergen.AllerCode = AllergenArr[0]; //����
        allergen.AllerName = AllergenArr[1]; //����  
        allergen.AllerSymptom = AllergenArr[3]; //����֢״ 

        arrayAllergen[arrayAllergen.length] = allergen;
    }
    McAllergenArray = arrayAllergen;
    //����״̬������
    var arrayMedCond = new Array();
    var pmi;
    var MedCondInfoArr = MedCondInfo.split(String.fromCharCode(1));
    for (var i = 0; i < MedCondInfoArr.length; i++) {
        var MedCondArr = MedCondInfoArr[i].split("^");

        var medcond;
        medcond = new Params_Mc_MedCond_In();
        medcond.Index = i; //������
        medcond.DiseaseCode = MedCondArr[0]; //��ϱ���
        medcond.DiseaseName = MedCondArr[1]; //�������
        medcond.RecipNo = ""; //������
        arrayMedCond[arrayMedCond.length] = medcond;

    }
    var arrayoperation = new Array();
    McOperationArray = arrayoperation;
}

/***********************������� end  ****************************/
