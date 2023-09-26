/**
 * ģ��:		����ҩ��
 * ��ģ��:		����ҩ��-�������
 * createdate:	2016-08-04
 * creator:		yunhaibao
 * others:		ȫ�ֱ�����ô��ڶ�����,���� "OA"
 */
DHCPHA_CONSTANT.DEFAULT.PHLOC = "";
DHCPHA_CONSTANT.DEFAULT.PHUSER = "";
DHCPHA_CONSTANT.DEFAULT.CYFLAG = "";
DHCPHA_CONSTANT.URL.THIS_URL = ChangeCspPathToAll("dhcpha.outpha.outmonitor.save.csp");
DHCPHA_CONSTANT.DEFAULT.APPTYPE = "OA";

var str=tkMakeServerCall("web.DHCOutPhCommon", "GetPassProp", DHCPHA_CONSTANT.SESSION.GROUP_ROWID, DHCPHA_CONSTANT.SESSION.GCTLOC_ROWID, DHCPHA_CONSTANT.SESSION.GUSER_ROWID);
var strArr=str.split("^");
DHCPHA_CONSTANT.DEFAULT.PASS =strArr[0];
var RePassNeedCancle=strArr[1];
var PatientInfo = {
    adm: 0,
    patientID: 0,
    episodeID: 0,
    admType: "I",
    prescno: 0,
    orditem: 0,
    zcyflag: 0
};
$(function () {
    CheckPermission();
    /* ��ʼ����� start*/
    var daterangeoptions={
		singleDatePicker:true
	}
	$("#date-start").dhcphaDateRange(daterangeoptions);
	$("#date-end").dhcphaDateRange(daterangeoptions);
    
    InitPhaLoc();

    InitPrescModalTab();
    InitGridPresc();
    InitGirdPrescDetail();
    /* ��ʼ����� end*/
    /* ��Ԫ���¼� start*/
    //�ǼǺŻس��¼�
    $('#txt-patno').on('keypress', function (event) {
        if (window.event.keyCode == "13") {
            var patno = $.trim($("#txt-patno").val());
            if (patno != "") {
                var newpatno = NumZeroPadding(patno, DHCPHA_CONSTANT.DEFAULT.PATNOLEN);
                $(this).val(newpatno);
                QueryGridPresc();
            }
        }
    });
    //���Żس��¼�
    $('#txt-cardno').on('keypress', function (event) {
        if (window.event.keyCode == "13") {
            var cardno = $.trim($("#txt-cardno").val());
            if (cardno != "") {
                BtnReadCardHandler();
            }
        }
    });
    //�������лس��¼�
    $("input[type=text]").on("keypress", function (e) {
        if (window.event.keyCode == "13") {
            return false;
        }
    })
    /* ��Ԫ���¼� end*/

    /* �󶨰�ť�¼� start*/
    $("#btn-find").on("click", QueryGridPresc);
    $("#btn-prepresc").on("click", ViewPrescAddInfo);
    $("#btn-viewlog").on("click", ViewPrescMonitorLog);
    $("#btn-pass").on("click", PassPresc);
    $("#btn-refuse").on("click", RefusePresc);
    $("#btn-analysis").on("click", PrescAnalyse) //��������
    $("#btn-readcard").on("click", BtnReadCardHandler); //����
    /* �󶨰�ť�¼� end*/
    ;
})
window.onload = function () {
    if (LoadPatNo != "") {
        $('#txt-patno').val(LoadPatNo);
    }
    QueryGridPresc();
}

//��ʼ��table
function InitGridPresc() {
    var columns = [{
            header: '������ҩ',
            index: 'druguse',
            name: 'druguse',
            width: 50,
            formatter: druguseFormatter
        },
        {
            header: 'ע����Ŀ',
            index: 'warningmsg',
            name: 'warningmsg',
            width: 50
        },
        {
            header: '���',
            index: 'result',
            name: 'result',
            width: 50,
            cellattr: addPassStatCellAttr
        },
        {
            header: '�ǼǺ�',
            index: 'patid',
            name: 'patid',
            width: 150
        },
        {
            header: '����',
            index: 'patname',
            name: 'patname',
            width: 100
        },
        {
            header: '�Ա�',
            index: 'patsex',
            name: 'patsex',
            width: 40
        },
        {
            header: '����',
            index: 'patage',
            name: 'patage',
            width: 40
        },
        {
            header: '���',
            index: 'path',
            name: 'path',
            width: 50
        },
        {
            header: '����',
            index: 'patw',
            name: 'patw',
            width: 50
        },
        {
            header: '�ѱ�',
            index: 'billtype',
            name: 'billtype',
            width: 100
        },
        {
            header: '������',
            index: 'prescno',
            name: 'prescno',
            width: 125
        },
        {
            header: '���',
            index: 'diag',
            name: 'diag',
            width: 200,
            align: 'left'
        },
        {
            header: 'adm',
            index: 'adm',
            name: 'adm',
            width: 200,
            hidden: true
        },
        {
            header: 'papmi',
            index: 'papmi',
            name: 'papmi',
            width: 200,
            hidden: true
        },
        {
            header: 'orditem',
            index: 'orditem',
            name: 'orditem',
            width: 200,
            hidden: true
        },
        {
            header: 'zcyflag',
            index: 'zcyflag',
            name: 'zcyflag',
            width: 200,
            hidden: true
        },
        {
            header: 'dspstatus',
            index: 'dspstatus',
            name: 'dspstatus',
            width: 200,
            hidden: true
        },
        {
            header: '�������',
            index: 'druguseresult',
            name: 'druguseresult',
            width: 100,
            hidden: true
        },
        {
            header: '���Ƶȼ�',
            index: 'manLevel',
            name: 'manLevel',
            width: 100,
            hidden: true
        },
        {
            header: '�������',
            index: 'analyseResult',
            name: 'analyseResult',
            width: 100,
            hidden: true
        }
    ];
    var input = GetQueryParams();
    var jqOptions = {
        colModel: columns, //��
        url: DHCPHA_CONSTANT.URL.THIS_URL + '?action=GetAdmPrescList&style=jqGrid&input=' + input, //��ѯ��̨	
        height: DhcphaJqGridHeight(2, 3) * 0.5,
        multiselect: true,
        datatype: "local",
        //shrinkToFit:false,
        pager: "#jqGridPager", //��ҳ�ؼ���id  
        onSelectRow: function (id, status) {
            var prescno = "";
            var audit = false;
            var id = $(this).jqGrid('getGridParam', 'selrow');
            if (id) {
                var selrowdata = $(this).jqGrid('getRowData', id);
                prescno = selrowdata.prescno;
                if ($("#chk-audit").is(':checked')) {
                    audit = true;
                }
                var params = audit;
            }
            $("#grid-prescdetail").setGridParam({
                page: 1,
                datatype: 'json',
                postData: {
                    'PrescNo': prescno,
                    'Input': audit
                }
            }).trigger("reloadGrid");
            PatientInfo.adm = selrowdata.adm;
            PatientInfo.prescno = selrowdata.prescno;
            PatientInfo.zcyflag = selrowdata.zcyflag;
            PatientInfo.patientID = selrowdata.papmi;
        },
        loadComplete: function () {
            var grid_records = $(this).getGridParam('records');
            if (grid_records == 0) {
                $("#grid-prescdetail").clearJqGrid();
            } else {
                $(this).jqGrid('setSelection', 1);
            }
        },
        onCellSelect: function (rowIndex, iCol, cellcontent, e) {
            var field = $(this).jqGrid('getGridParam', 'colModel')[iCol].index;
            if (field != "druguse") {
                return
            }
            var content = $(this).jqGrid('getRowData', rowIndex).druguseresult;
            DHCSTPHCMPASS.AnalysisTips({
                Content: content
            })
        }
    };
    $('#grid-presc').dhcphaJqGrid(jqOptions);
}
//��ʼ����ϸtable
function InitGirdPrescDetail() {
    //var prescdetailWidth=$(".div_content").width();
    var columns = [{
            header: '״̬',
            index: 'ordstat',
            name: 'ordstat',
            width: 100,
            cellattr: addStatCellAttr
        },
        {
            header: 'ҩƷ����',
            index: 'incidesc',
            name: 'incidesc',
            width: 200,
            align: 'left',
            formatter: function (cellvalue, options, rowObject) {
                if (DHCPHA_CONSTANT.DEFAULT.PASS != "") {
                    return "<a onclick=\"DrugTips()\" style='text-decoration:underline;cursor:pointer;'>" + cellvalue + "</a>";
                } else {
                    return cellvalue;
                }  
            }
        },
        {
            header: '����',
            index: 'qty',
            name: 'qty',
            width: 40
        },
        {
            header: '��λ',
            index: 'uomdesc',
            name: 'uomdesc',
            width: 60
        },
        {
            header: '����',
            index: 'dosage',
            name: 'dosage',
            width: 60
        },
        {
            header: 'Ƶ��',
            index: 'freq',
            name: 'freq',
            width: 60
        },
        {
            header: '���',
            index: 'spec',
            name: 'spec',
            width: 80,
            hidden: true
        },
        {
            header: '�÷�',
            index: 'instruc',
            name: 'instruc',
            width: 80
        },
        {
            header: '��ҩ�Ƴ�',
            index: 'dura',
            name: 'dura',
            width: 80
        },
        {
            header: 'ʵ���Ƴ�',
            index: 'realdura',
            name: 'realdura',
            width: 80,
            hidden: true
        },
        {
            header: '����',
            index: 'form',
            name: 'form',
            width: 80
        },
        {
            header: '����ҩ��',
            index: 'basflag',
            name: 'basflag',
            width: 80
        },
        {
            header: 'ҽ��',
            index: 'doctor',
            name: 'doctor',
            width: 60
        },
        {
            header: 'ҽ����������',
            index: 'orddate',
            name: 'orddate',
            width: 120
        },
        {
            header: 'ҽ����ע',
            index: 'remark',
            name: 'remark',
            width: 70,
            align: 'left'
        },
        {
            header: '����',
            index: 'manf',
            name: 'manf',
            width: 150,
            align: 'left',
            hidden: true
        },
        {
            header: 'orditm',
            index: 'orditm',
            name: 'orditm',
            width: 150,
            hidden: true
        }


    ];
    var jqOptions = {
        colModel: columns, //��
        url: DHCPHA_CONSTANT.URL.THIS_URL + '?action=FindOrdDetailData&style=jqGrid',
        height: DhcphaJqGridHeight(2, 3) * 0.5,
        shrinkToFit: true,
        datatype: "local"

    };
    $('#grid-prescdetail').dhcphaJqGrid(jqOptions);
}

function InitPhaLoc() {
    var selectoption = {
        url: DHCPHA_CONSTANT.URL.COMMON_INPHA_URL +
            "?action=GetStockPhlocDs&style=select2&groupId=" +
            DHCPHA_CONSTANT.SESSION.GROUP_ROWID,
        allowClear: false
    }
    $("#sel-phaloc").dhcphaSelect(selectoption)
    var select2option = '<option value=' + "'" + DHCPHA_CONSTANT.DEFAULT.LOC.id + "'" + 'selected>' + DHCPHA_CONSTANT.DEFAULT.LOC.text + '</option>'
    $("#sel-phaloc").append(select2option); //��Ĭ��ֵ,û�뵽�ð취,yunhaibao20160805
    $('#sel-phaloc').on('select2:select', function (event) {
        //alert(event)
    });
}
//��ѯδ��˴���
function QueryGridPresc() {
    var params = GetQueryParams();
    $("#grid-presc").setGridParam({
        page: 1,
        datatype: 'json',
        postData: {
            'input': params
        }
    }).trigger("reloadGrid");
    return true
}

function GetQueryParams() {
    var phaloc = $("#sel-phaloc").val();
    var stdate = $("#date-start").val();
    var enddate = $("#date-end").val();
    daterange=stdate+" - "+enddate
    
    var audit = false;
    if ($("#chk-audit").is(':checked')) {
        audit = true;
    }
    var patno = $("#txt-patno").val();
    var params = daterange + "^" + phaloc + "^" + patno + "^" + audit;
    return params;
}
//���������չ��Ϣmodal
function ViewPrescAddInfo() {
    var grid_records = $("#grid-presc").getGridParam('records');
    if (grid_records == 0) {
        dhcphaMsgBox.alert("��ǰ����������!");
        return;
    }
    var selectid = $("#grid-presc").jqGrid('getGridParam', 'selrow');
    if (selectid == null) {
        dhcphaMsgBox.alert("����ѡ����Ҫ�鿴�Ĵ�����¼!");
        return;
    }
    //$("#modal-prescinfo").find(".modal-dialog").css({height:"200px"});
    $("#modal-prescinfo").modal('show');
}
//�鿴��־
function ViewPrescMonitorLog() {
    var grid_records = $("#grid-presc").getGridParam('records');
    if (grid_records == 0) {
        dhcphaMsgBox.alert("��ǰ����������!");
        return;
    }
    var selectid = $("#grid-presc").jqGrid('getGridParam', 'selrow');
    if (selectid == null) {
        dhcphaMsgBox.alert("����ѡ����Ҫ�鿴�Ĵ�����¼!");
        return;
    }
    var selectdata = $('#grid-presc').jqGrid('getRowData', selectid);
    var orditm = selectdata.orditem;
    var logoptions = {
        id: "#modal-monitorlog",
        orditm: orditm,
        fromgrid: "#grid-presc",
        fromgridselid: selectid
    };
    InitOutMonitorLogBody(logoptions);
}
//ע��modaltab�¼�
function InitPrescModalTab() {
    $("#ul-monitoraddinfo a").on('click', function () {
        var adm = PatientInfo.adm;
        var prescno = PatientInfo.prescno;
        var zcyflag = PatientInfo.zcyflag;
        var patientID = PatientInfo.patientID;
        var tabId = $(this).attr("id")
        if (tabId == "tab-allergy") {
            $('iframe').attr('src', ChangeCspPathToAll('dhcdoc.allergyenter.csp' + '?PatientID=' + patientID + '&EpisodeID=' + adm + "&IsOnlyShowPAList=Y"));
        }
        if (tabId == "tab-risquery") {
            $('iframe').attr('src', ChangeCspPathToAll('dhcapp.inspectrs.csp' + '?PatientID=' + patientID + '&EpisodeID=' + adm));
        }
        if (tabId == "tab-libquery") {
            $('iframe').attr('src', ChangeCspPathToAll('dhcapp.seepatlis.csp' + '?PatientID=' + patientID + '&EpisodeID=' + adm + '&NoReaded=' + '1'));
        }
        if (tabId == "tab-eprquery") {
            $('iframe').attr('src', ChangeCspPathToAll('emr.interface.browse.episode.csp' + '?PatientID=' + patientID + '&EpisodeID=' + adm + '&EpisodeLocID=' + session['LOGON.CTLOCID']));
        }
        if (tabId == "tab-orderquery") {
            $('iframe').attr('src', ChangeCspPathToAll('oeorder.opbillinfo.csp' + '?EpisodeID=' + adm));
        }
        if (tabId == "tab-viewpresc") {
            var phartype = "DHCOUTPHA";
            var paramsstr = phartype + "^" + prescno + "^" + DHCPHA_CONSTANT.DEFAULT.CYFLAG;
            $("iframe").attr("src", ChangeCspPathToAll("dhcpha/dhcpha.common.prescpreview.csp") + "?paramsstr=" + paramsstr + "&PrtType=DISPPREVIEW");
        }
    })

    $('#modal-prescinfo').on('show.bs.modal', function () {
        $("#modal-prescinfo .modal-dialog").width($(window).width() * 0.9);
        //$("#modal-prescinfo .modal-body").height($(window).height()*0.9);
        //$("#modal-prescinfo .modal-body").height($(window).height()*0.85);
        //var tmpiframeheight=$(window).height()*0.85
        //					-$("#modal-prescinfo .modal-header").height()
        //					-$("#modal-prescinfo #ul-monitoraddinfo").height()
        //					-40;
        $("#ifrm-outmonitor").height($(window).height() * 0.9 - 140)
        $('iframe').attr('src', "dhcpha.comment.queryorditemds.csp?EpisodeID=" + PatientInfo.adm);
        var selectid = $("#grid-presc").jqGrid('getGridParam', 'selrow');
        var selectdata = $('#grid-presc').jqGrid('getRowData', selectid);
        var patoptions = {
            id: "#dhcpha-patinfo",
            orditem: selectdata.orditem
        };
        AppendPatientOrdInfo(patoptions);
        var tabId = $(this).attr("id");
        if (tabId != "tab-viewpresc") {
            $("#tab-viewpresc").click()
        }
    })
    $("#modal-prescinfo").on("hidden.bs.modal", function () {
        //$(this).removeData("bs.modal");
    });
    $("#tab-beforeindrug").hide();
}
//���ͨ��
function PassPresc() {
    var selectids = $("#grid-presc").jqGrid('getGridParam', 'selarrrow');
    if (selectids == "") {
        dhcphaMsgBox.alert("����ѡ����Ҫ��˵ļ�¼");
        return;
    }
    var canpass = 0;
    canpassi = 0;
    var i = 0;
    $.each(selectids, function () {
        var rowdata = $('#grid-presc').jqGrid('getRowData', this);
        var rowresult = rowdata.result;
        var manLevel = rowdata.manLevel;
        var analyseResult= rowdata.analyseResult;
        canpassi = canpassi + 1;
        if (rowresult == "ͨ��") {
            canpass = "1"
            return false; //false �˳�ѭ��
        } else if (rowresult.indexOf("�ܾ�") != "-1") {
            canpass = "2"
            return false; //false �˳�ѭ��
        }
        if ((analyseResult!="0")&&(manLevel == "C")) {
            canpass = "3"
            return false; //false �˳�ѭ��
        }
    })
    if(RePassNeedCancle=="Y"){
	    if (canpass == 1) {
	        dhcphaMsgBox.alert("��ѡ��ĵ�" + canpassi + "����ͨ��,�����ٴ����ͨ�� !");
	        return;
	    } else if (canpass == 2) {
	        dhcphaMsgBox.alert("��ѡ��ĵ�" + canpassi + "���Ѿܾ�,����ֱ�����ͨ�� !");
	        return;
	    } 
    }
    if(canpass == 3) {
        dhcphaMsgBox.alert("��ѡ��ĵ�" + canpassi + "���������ҿ��Ƶȼ�Ϊ����,����ֱ�����ͨ�� !");
        return;
    }
    var orditem = "";
    var ret = "Y";
    var reasondr = "";
    var advicetxt = "";
    var factxt = "";
    var phnote = "";
    var guser = session['LOGON.USERID'];
    var ggroup = session['LOGON.GROUPID'];
    var i = 0;
    $.each(selectids, function () {
        var rowdata = $('#grid-presc').jqGrid('getRowData', this);
        var orditem = rowdata.orditem;
        var input = ret + "^" + guser + "^" + advicetxt + "^" + factxt + "^" + phnote + "^" + ggroup + "^" + orditem;
        var input = input + "^" + DHCPHA_CONSTANT.DEFAULT.APPTYPE;
        SaveCommontResult(reasondr, input)
    })

}
//��˾ܾ�
function RefusePresc() {
    var grid_records = $("#grid-prescdetail").getGridParam('records');
    if (grid_records == 0) {
        dhcphaMsgBox.alert("��������ϸ����!");
        return;
    }
    var firstrowdata = $("#grid-prescdetail").jqGrid("getRowData", 1); //��ȡ��һ������
    var orditm = firstrowdata.orditm;
    if (orditm == "") {
        dhcphaMsgBox.alert("ҽ������Ϊ��!");
        return;
    }
    var selectid = $("#grid-presc").jqGrid('getGridParam', 'selrow');
    if (selectid == "") {
        dhcphaMsgBox.alert("����ѡ����Ҫ�ܾ��ļ�¼!");
        return;
    }
    var selectdata = $('#grid-presc').jqGrid('getRowData', selectid);
    var dspstatus = selectdata.dspstatus;
    if (dspstatus.indexOf("��") >= 0) {
        dhcphaMsgBox.alert("��ѡ��ļ�¼״̬Ϊ:" + dspstatus + ",�޷��ܾ�!");
        return;
    }
    var oaresult = selectdata.result;
    if(RePassNeedCancle=="Y"){
	    if (oaresult.indexOf("�ܾ�") != "-1") {
	        dhcphaMsgBox.alert("��ѡ��ļ�¼�Ѿ��ܾ�!");
	        return;
	    }
	    if (oaresult == "ͨ��") {
	        dhcphaMsgBox.alert("��ѡ��ļ�¼�Ѿ�ͨ��!");
	        return;
	    }
    }
    var prescNo=selectdata.prescno;
    var waycode = OutPhaWay;
    ShowPHAPRASelReason({
		wayId:waycode,
		oeori:"",
		prescNo:prescNo,
		selType:"PRESCNO"
	},SaveCommontResultEX,{orditm:orditm}); 
}
function SaveCommontResultEX(reasonStr,origOpts){
	if (reasonStr==""){
		return "";
	}
    var retarr = reasonStr.split("@");
    var ret = "N";
    var reasondr = retarr[0];
    var advicetxt = retarr[2];
    var factxt = retarr[1];
    var phnote = retarr[3];
    var User = session['LOGON.USERID'];
    var grpdr = session['LOGON.GROUPID'];
    var input = ret + "^" + User + "^" + advicetxt + "^" + factxt + "^" + phnote + "^" + grpdr + "^" + origOpts.orditm;
    var input = input + "^" + DHCPHA_CONSTANT.DEFAULT.APPTYPE;
    SaveCommontResult(reasondr, input);
}
//���ͨ��/�ܾ�
function SaveCommontResult(reasondr, input) {
    $.ajax({
        url: DHCPHA_CONSTANT.URL.THIS_URL + '?action=SaveOPAuditResult&Input=' + encodeURI(input) + '&ReasonDr=' + reasondr,
        type: 'post',
        success: function (data) {
            var retjson = JSON.parse(data);
            if (retjson.retvalue == 0) {
                QueryGridPresc();
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
//��������
function PrescAnalyse() {
    var passType = DHCPHA_CONSTANT.DEFAULT.PASS;
    if (passType == "") {
        dhcphaMsgBox.alert("δ���ô��������ӿڣ����ڲ�������-����ҩ��-������ҩ�����������Ӧ����");
        return;
    }
    if (passType == "DHC") {
        // ����֪ʶ��
        DHCSTPHCMPASS.PassAnalysis({
            GridId: "grid-presc",
            MOeori: "orditem",
            PrescNo: "prescno",
            GridType: "JqGrid",
            Field: "druguse",
            valField:"analyseResult",
            ResultField: "druguseresult",
            ManLevel: "manLevel" //add by MaYuqiang
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

function GridOrdItemCellTip() {}
//Ȩ����֤
function CheckPermission() {
    $.ajax({
        url: DHCPHA_CONSTANT.URL.COMMON_OUTPHA_URL + '?action=CheckPermission' +
            '&groupId=' + DHCPHA_CONSTANT.SESSION.GROUP_ROWID +
            '&gUserId=' + DHCPHA_CONSTANT.SESSION.GUSER_ROWID +
            '&gLocId=' + DHCPHA_CONSTANT.SESSION.GCTLOC_ROWID,
        type: 'post',
        success: function (data) {
            var retjson = JSON.parse(data);
            var retdata = retjson[0];
            var permissionmsg = "",
                permissioninfo = "";
            if (retdata.phloc == "") {
                permissionmsg = "ҩ������:" + defaultLocDesc;
                permissioninfo = "��δ������ҩ����Ա����ά��!"
            } else {
                permissionmsg = "����:" + DHCPHA_CONSTANT.SESSION.GUSER_CODE + "��������:" + DHCPHA_CONSTANT.SESSION.GUSER_NAME;
                if (retdata.phuser == "") {
                    permissioninfo = "��δ������ҩ����Ա����ά��!"
                } else if (retdata.phnouse == "Y") {
                    permissioninfo = "����ҩ����Ա����ά����������Ϊ��Ч!"
                } else if (retdata.phaudit != "Y") {
                    permissioninfo = "����ҩ����Ա����ά����δ�������Ȩ��!"
                }
            }
            if (permissioninfo != "") {
                $('#modal-dhcpha-permission').modal({
                    backdrop: 'static',
                    keyboard: false
                }); //���ɫ���򲻹ر�
                $('#modal-dhcpha-permission').on('show.bs.modal', function () {
                    $("#lb-permission").text(permissionmsg)
                    $("#lb-permissioninfo").text(permissioninfo)

                })
                $("#modal-dhcpha-permission").modal('show');
            } else {
                DHCPHA_CONSTANT.DEFAULT.PHLOC = retdata.phloc;
                DHCPHA_CONSTANT.DEFAULT.PHUSER = retdata.phuser;
                DHCPHA_CONSTANT.DEFAULT.CYFLAG = retdata.phcy;
            }
        },
        error: function () {}
    })
}

function addPassStatCellAttr(rowId, val, rawObject, cm, rdata) {
    if (val == "ͨ��") {
        return "class=dhcpha-record-passed";
    } else if ((val == "�ܾ�") || ((val == "�ܾ���ҩ"))) {
        return "class=dhcpha-record-refused";
    } else if (val == "����") {
        return "class=dhcpha-record-appeal";
    } else {
        return "";
    }
}
//����
function BtnReadCardHandler() {
    var readcardoptions = {
        CardTypeId: "sel-cardtype",
        CardNoId: "txt-cardno",
        PatNoId: "txt-patno"
    }
    DhcphaReadCardCommon(readcardoptions, ReadCardReturn)
}
//�������ز���
function ReadCardReturn() {
    QueryGridPresc();
}

///ҩ����ʾ
function DrugTips() {
    var passType = DHCPHA_CONSTANT.DEFAULT.PASS;
    if (passType == "") {
        dhcphaMsgBox.alert("δ����ҩ��ӿڣ����ڲ�������-����ҩ��-������ҩ�����������Ӧ����");
        return;
    }
    var $td = $(event.target).closest("td");
	var rowid=$td.closest("tr.jqgrow").attr("id");
	var selectdata=$('#grid-prescdetail').jqGrid('getRowData',rowid);	
	var incDesc=$.jgrid.stripHtml(selectdata.incidesc);
	var orditm=selectdata.orditm;
    if (passType == "DHC") {
        // ����֪ʶ��
        var userInfo = session['LOGON.USERID'] + "^" + session['LOGON.CTLOCID'] + "^" + session['LOGON.GROUPID'];
        DHCSTPHCMPASS.MedicineTips({
            Oeori: orditm,
            UserInfo: userInfo,
            IncDesc: incDesc
        })
    } else if (passType == "MK") {
	     //dhcphaMsgBox.alert("�ӿ���δ����")
        // ����
        MKPrescTips(orditm); 
    } else if (passType == "YY") {
		dhcphaMsgBox.alert("�ӿ���δ����")
	}
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
    //return '<img src="'+DHCPHA_CONSTANT.URL.PATH+'/scripts/pharmacy/images/'+imageid+'" alt="' + cellvalue + '" ></img>'
    //return '<img src="../scripts/pharmacy/images/' + imageid + '" ></img>'
    return '<img src="'+DHCPHA_CONSTANT.URL.PATH+'/scripts/pharmacy/images/' + imageid + '" ></img>'
}

function addStatCellAttr(rowId, val, rawObject, cm, rdata) {
    if ((val.indexOf("����") >= 0) || (val.indexOf("ֹͣ") >= 0)) {
        return "class=dhcpha-record-ordstop";
    } else {
        return "";
    }
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
    pass.CheckMode = "mzyf" //MC_global_CheckMode;
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
    var ret = tkMakeServerCall("web.DHCDocHLYYMK", "GetPrescInfo", EpisodeID, Orders, DocName);
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
        drug.Num = OrderArr[15]; //ҩƷ��������
        drug.NumUnit = OrderArr[16]; //ҩƷ����������λ          
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

// ����ҩ����ʾ
function MKPrescTips(orditm){
	if((orditm=="")||(orditm==null)){
	  	dhcphaMsgBox.alert("����ѡ����Ҫ�鿴�ļ�¼!");
		return;
	}
	var ordInfoStr = tkMakeServerCall("web.DHCSTPIVADaTongInterface","GetOrderMainInfo",oeori)
	var ordData = ordInfoStr.split("^")
	var inciCode = ordData[8]
	var inciDesc = ordData[9]
	var prescNo = ordData[10]
	var cyFlag = ordData[11]
	MCInit1(prescNo);
	HisQueryData(inciCode,inciDesc);
	if (cyFlag == "Y"){
		MDC_DoRefDrug(24)	
	}
	else {
		MDC_DoRefDrug(11)
	}
	
}

function HisQueryData(inciCode,inciDesc) {
	
 	var drug = new Params_MC_queryDrug_In();
    drug.ReferenceCode = inciCode; 	//ҩƷ���
    drug.CodeName = inciDesc;       	//ҩƷ����
    MC_global_queryDrug = drug;
} 

/***********************������� end  ****************************/