/*
ģ��:		סԺ��ҩ��
��ģ��:		סԺ��ҩ��-��ҩ�ѷ�ҩ��ѯ
Creator:	hulihua
CreateDate:	2018-12-11
*/
var NowTAB = "#div-presc-condition"; // ��¼��ǰtab

$(function () {
    InitPhaConfig();
    /* ��ʼ����� start*/
    var daterangeoptions = {
        timePicker: true,
        timePickerIncrement: 1,
        timePicker24Hour: true,
        timePickerSeconds: true,
        singleDatePicker: true,
        locale: {
            format: DHCPHA_CONSTANT.PLUGINS.DATEFMT + " HH:mm:ss"
        }
    }
    $("#date-start").dhcphaDateRange(daterangeoptions);
    $("#date-end").dhcphaDateRange(daterangeoptions);
    InitPhaLoc(); //ҩ������
    InitPhaWard(); //����
    InitGridPrescList(); //��ʼ�������б�
    InitGridAdm(); //��ʼ�����˾����б�
    InitGridAdmPrescList(); //��ʼ�����˾��ﴦ����
    InitTrialDispTab(); //��ҳ��tab
    $("#monitor-condition").children().not("#div-presc-condition").hide();

    /* ��Ԫ���¼� start*/
    //�ǼǺŻس��¼�
    $('#txt-patno').on('keypress', function (event) {
        if (window.event.keyCode == "13") {
            var patno = $.trim($("#txt-patno").val());
            if (patno != "") {
                var newpatno = NumZeroPadding(patno, DHCPHA_CONSTANT.DEFAULT.PATNOLEN);
                $(this).val(newpatno);
                QueryInPhDispList();
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
    SetButAutty();
    ResizeHMPrescDispQuery();
})

window.onload = function () {
    setTimeout(QueryInPhDispList, 500);
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
    var startdate = configarr[6] || "";
    var enddate = configarr[7] || "";
    if (startdate == "") {
        startdate = "t";
    }
    if (enddate == "") {
        enddate = "t";
    }
    startdate = FormatDateT(startdate);
    enddate = FormatDateT(enddate);
    $("#date-start").data('daterangepicker').setStartDate(startdate + " 00:00:00");
    $("#date-start").data('daterangepicker').setEndDate(startdate + " 00:00:00");
    $("#date-end").data('daterangepicker').setStartDate(startdate + " 23:59:59");
    $("#date-end").data('daterangepicker').setEndDate(startdate + " 23:59:59");
    InitAgreeRetModal();
}

//Ȩ�޿����Ƿ���˰�ť�ɲ�����
function SetButAutty() {
    var Params = gGroupId + "^" + gLocId + "^" + gUserID + "^" + gHospID;
    var ParamStr = tkMakeServerCall("web.DHCINPHA.MTCommon.PublicServiceMethod", "GetParamProp", Params);
    var IfAgreeReturn = ParamStr.split("^")[4];
    if (IfAgreeReturn != "Y") {
        $("#btn-agreeret").attr({
            "disabled": "disabled"
        });
    }
}

//��ʼ�������б�table
function InitGridPrescList() {
    var columns = [{
            name: "TPhac",
            index: "TPhac",
            header: 'TPhac',
            width: 10,
            hidden: true
        },
        {
            name: "TWardLocId",
            index: "TWardLocId",
            header: 'TWardLocId',
            width: 10,
            hidden: true
        },
        {
            name: "TWardLoc",
            index: "TWardLoc",
            header: '����',
            width: 150,
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
            width: 100
        },
        {
            name: "TPatName",
            index: "TPatName",
            header: '����',
            width: 140
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
            width: 80
        },
        {
            name: "TFactor",
            index: "TFactor",
            header: '����',
            width: 50
        },
        {
            name: "TPrescCount",
            index: "TPrescCount",
            header: 'ζ��',
            width: 50
        },
        {
            name: "TOptorType",
            index: "TOptorType",
            header: '������ʽ',
            width: 70
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
            header: '�ύ����',
            width: 150
        },
        {
            name: "TmonitorName",
            index: "TmonitorName",
            header: '���ҩʦ',
            width: 100
        },
        {
            name: "TmonitorDateTime",
            index: "TmonitorDateTime",
            header: '�������',
            width: 150
        },
        {
            name: "TOperatorUser",
            index: "TOperatorUser",
            header: '������',
            width: 100
        },
        {
            name: "TOperatorDate",
            index: "TOperatorDate",
            header: '��������',
            width: 150
        },
        {
            name: "TCollectUser",
            index: "TCollectUser",
            header: '��ҩ��',
            width: 100
        },
        {
            name: "TCollectDate",
            index: "TCollectDate",
            header: '��ҩ����',
            width: 150
        },
        {
            name: "TAgreeRetFlag",
            index: "TAgreeRetFlag",
            header: '���˱�־',
            width: 70
        },
        {
            name: "TAgreeRetUser",
            index: "TAgreeRetUser",
            header: '�ÿ�����',
            width: 100
        },
        {
            name: "TAgreeRetDate",
            index: "TAgreeRetDate",
            header: '�ÿ�������',
            width: 150
        },
        {
            name: "TAgreeRetRemark",
            index: "TAgreeRetRemark",
            header: '�ÿ��˱�ע',
            width: 200
        }
    ];
    var jqOptions = {
        colModel: columns, //��
        url: ChangeCspPathToAll(LINK_CSP) + '?ClassName=web.DHCINPHA.HMTrialDrugDisp.TrialDrugDispQuery&MethodName=jsQueryAlrDispPrescList', //��ѯ��̨	
        height: DhcphaJqGridHeight(1, 1),
        fit: true,
        multiselect: false,
        shrinkToFit: false,
        rownumbers: true,
        datatype: "local",
        pager: "#jqGridPager", //��ҳ�ؼ���id  
        onSelectRow: function (id, status) {
            QueryGridDispSub()
        },
        loadComplete: function () {
            var grid_records = $(this).getGridParam('records');
            if (grid_records == 0) {
                $("#ifrm-presc").attr("src", "");
            } else {
                $(this).jqGrid('setSelection', 1);
            }
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
                $("#grid-admpresclist").jqGrid("clearGridData");
                var params = GetMainCodParams();
                params = params + "^^" + adm;
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
            name: "TPhac",
            index: "TPhac",
            header: 'TPhac',
            width: 10,
            hidden: true
        },
        {
            name: "TWardLocId",
            index: "TWardLocId",
            header: 'TWardLocId',
            width: 10,
            hidden: true
        },
        {
            name: "TWardLoc",
            index: "TWardLoc",
            header: '����',
            width: 150,
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
            width: 100
        },
        {
            name: "TPatName",
            index: "TPatName",
            header: '����',
            width: 140
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
            width: 80
        },
        {
            name: "TFactor",
            index: "TFactor",
            header: '����',
            width: 50
        },
        {
            name: "TPrescCount",
            index: "TPrescCount",
            header: 'ζ��',
            width: 50
        },
        {
            name: "TOptorType",
            index: "TOptorType",
            header: '������ʽ',
            width: 70
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
            header: '�ύ����',
            width: 150
        },
        {
            name: "TmonitorName",
            index: "TmonitorName",
            header: '���ҩʦ',
            width: 100
        },
        {
            name: "TmonitorDateTime",
            index: "TmonitorDateTime",
            header: '�������',
            width: 150
        },
        {
            name: "TOperatorUser",
            index: "TOperatorUser",
            header: '������',
            width: 100
        },
        {
            name: "TOperatorDate",
            index: "TOperatorDate",
            header: '��������',
            width: 150
        },
        {
            name: "TCollectUser",
            index: "TCollectUser",
            header: '��ҩ��',
            width: 100
        },
        {
            name: "TCollectDate",
            index: "TCollectDate",
            header: '��ҩ����',
            width: 150
        },
        {
            name: "TAgreeRetFlag",
            index: "TAgreeRetFlag",
            header: '���˱�־',
            width: 70
        },
        {
            name: "TAgreeRetUser",
            index: "TAgreeRetUser",
            header: '�ÿ�����',
            width: 100
        },
        {
            name: "TAgreeRetDate",
            index: "TAgreeRetDate",
            header: '�ÿ�������',
            width: 150
        },
        {
            name: "TAgreeRetRemark",
            index: "TAgreeRetRemark",
            header: '�ÿ��˱�ע',
            width: 200
        }
    ];
    var jqOptions = {
        colModel: columns, //��
        url: ChangeCspPathToAll(LINK_CSP) + '?ClassName=web.DHCINPHA.HMTrialDrugDisp.TrialDrugDispQuery&MethodName=jsQueryAlrDispPrescList', //��ѯ��̨	
        height: DhcphaJqGridHeight(2, 3) * 0.6,
        fit: true,
        multiselect: false,
        shrinkToFit: false,
        datatype: "local",
        onSelectRow: function (id, status) {
            QueryGridDispSub()
        },
        loadComplete: function () {
            var grid_records = $(this).getGridParam('records');
            if (grid_records == 0) {
                $("#ifrm-presc").attr("src", "");
            } else {
                $(this).jqGrid('setSelection', 1);
            }
        }
    };
    $('#grid-admpresclist').dhcphaJqGrid(jqOptions);
}

function ClearConditons() {
    $('#grid-presclist').clearJqGrid();
}

function InitTrialDispTab() {
    $("#tab-ipmonitor a").on('click', function () {
        $("#ifrm-presc").empty();
        var tabId = $(this).attr("id");
        var tmpTabId = "#div-" + tabId.split("-")[1] + "-condition";
        $(tmpTabId).show();
        $("#monitor-condition").children().not(tmpTabId).hide();
        NowTAB = tmpTabId;
        QueryInPhDispList();
    })
}

function QueryInPhDispList() {
    //ClearConditons();
    var params = GetMainCodParams();
    if (NowTAB == "#div-presc-condition") {
        var wardloc = $('#sel-phaward').val();
        if (wardloc == null) {
            wardloc = ""
        };
        params = params + "^" + wardloc;
        $("#grid-presclist").setGridParam({
            datatype: 'json',
            page: 1,
            postData: {
                'params': params
            }
        }).trigger("reloadGrid");
    } else {
        var patno = $("#txt-patno").val();
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
    var prescno = GetSelPrescNo();
    QueryPrescDetail(prescno);
}

function QueryPrescDetail(prescno) {
    $("#ifrm-presc").empty();
    var htmlstr = GetPrescHtml(prescno);
    $("#ifrm-presc").append(htmlstr);
}

function GetPrescHtml(prescno) {
    var cyflag = "Y";
    var phartype = "DHCINPHA";
    var paramsstr = phartype + "^" + prescno + "^" + cyflag;
    $("#ifrm-presc").attr("src", ChangeCspPathToAll("dhcpha/dhcpha.common.prescpreview.csp") + "?paramsstr=" + paramsstr + "&PrtType=DISPPREVIEW");
}

//��ȡ��ѯ����
function GetMainCodParams() {
    var startdatetime = $("#date-start").val();
    var enddatetime = $("#date-end").val();
    var startdate = startdatetime.split(" ")[0];
    var starttime = startdatetime.split(" ")[1];
    var enddate = enddatetime.split(" ")[0];
    var endtime = enddatetime.split(" ")[1];
    var phaloc = $('#sel-phaloc').val();
    if (phaloc == null) {
        phaLoc = ""
    }
    if (phaloc == "") {
        dhcphaMsgBox.alert("ҩ��������Ϊ��!");
        return;
    }
    var params = startdate + "^" + starttime + "^" + enddate + "^" + endtime + "^" + phaloc;
    return params;
}

//��ȡ���ѡ�еĴ�����
function GetSelPrescNo() {
    if (NowTAB == "#div-presc-condition") {
        var selectid = $("#grid-presclist").jqGrid('getGridParam', 'selrow');
        var selrowdata = $("#grid-presclist").jqGrid('getRowData', selectid);
    } else {
        var selectid = $("#grid-admpresclist").jqGrid('getGridParam', 'selrow');
        var selrowdata = $("#grid-admpresclist").jqGrid('getRowData', selectid);
    }
    var prescno = selrowdata.TPrescNo;
    return prescno;
}
//��ȡ���ѡ�еĴ�����
function GetSelAgreeRetFlag() {
    if (NowTAB == "#div-presc-condition") {
        var selectid = $("#grid-presclist").jqGrid('getGridParam', 'selrow');
        var selrowdata = $("#grid-presclist").jqGrid('getRowData', selectid);
    } else {
        var selectid = $("#grid-admpresclist").jqGrid('getGridParam', 'selrow');
        var selrowdata = $("#grid-admpresclist").jqGrid('getRowData', selectid);
    }
    var agreeFlag = selrowdata.TAgreeRetFlag;
    return agreeFlag;
}

//�ش��ҩ��ǩ
function RePrintLabel() {
    var prescno = GetSelPrescNo();
    var PhacRowid = tkMakeServerCall("web.DHCINPHA.HMTrialDrugDisp.TrialDrugDispQuery", "GetPhacByPres", prescno);
    if (PhacRowid != "") {
        PrintDispSheet(PhacRowid, "1");
    }
}

//��д�ÿ��˵�ԭ��
function InitAgreeRetModal() {
    $("#btn-agreeret-sure").on("click", function () {
        if (NowTAB == "#div-presc-condition") {
            var prescrowdata = $("#grid-presclist").jqGrid('getRowData');
            var selectid = $("#grid-presclist").jqGrid('getGridParam', 'selrow');
            var selrowdata = $("#grid-presclist").jqGrid('getRowData', selectid);
        } else {
            var prescrowdata = $("#grid-admpresclist").jqGrid('getRowData');
            var selectid = $("#grid-admpresclist").jqGrid('getGridParam', 'selrow');
            var selrowdata = $("#grid-admpresclist").jqGrid('getRowData', selectid);
        }
        var prescridrows = prescrowdata.length;
        if (prescridrows <= 0) {
            dhcphaMsgBox.alert("�ѷ������б�������!");
            return;
        }
        var phacid = selrowdata.TPhac;
        if ((phacid == "") || (phacid == null)) {
            dhcphaMsgBox.alert("����ѡ����Ҫ�ÿ��˵Ĵ���!");
            return;
        }
        var agrretremark = $.trim($('#txt-agrretremark').val());
        $("#modal-agreereturn").modal('hide');
        var ParamData = phacid + "^" + gUserID + "^" + agrretremark;
        var RetResult = tkMakeServerCall("web.DHCINPHA.HMTrialDrugDisp.TrialDrugDispQuery", "SaveAgreeRet", ParamData);
        var RetCode = RetResult.split("^")[0];
        var RetMessage = RetResult.split("^")[1];
        if (RetCode != "0") {
            dhcphaMsgBox.alert(RetMessage);
            return;
        } else {
            dhcphaMsgBox.alert("�ô�����Ϊ���˳ɹ�!", "success");
            QueryInPhDispList();
        }

    });
}

//�������ҩ��ť�����ķ���
function SaveAgreeRet() {
    var prescno = GetSelPrescNo();
    if ((prescno == "") || (prescno == null)) {
        dhcphaMsgBox.alert("����ѡ����Ҫ�ÿ��˵Ĵ���!");
        return;
    }
    if (GetSelAgreeRetFlag() == "Y") {
        dhcphaMsgBox.alert("�ô����Ѿ���Ϊ���ˣ������ٴβ���!");
        return;
    }
    $('#modal-agreereturn').modal('show');
    $('#txt-agrretremark').text("");
    var timeout = setTimeout(function () {
        $(window).focus();
        $('#txt-agrretremark').focus();
    }, 500);
}

///��������������������
function ReSendMechine() {
    if (NowTAB == "#div-presc-condition") {
        var selectid = $("#grid-presclist").jqGrid('getGridParam', 'selrow');
        var selrowdata = $("#grid-presclist").jqGrid('getRowData', selectid);
    } else {
        var selectid = $("#grid-admpresclist").jqGrid('getGridParam', 'selrow');
        var selrowdata = $("#grid-admpresclist").jqGrid('getRowData', selectid);
    }
    var pharowid = selrowdata.TPhac;
    if ((pharowid == "") || (pharowid == null)) {
        dhcphaMsgBox.alert("�ô���ҩ����δ������������!");
        return;
    }
    var phaloc = $('#sel-phaloc').val();
    if (phaloc == null) {
        phaLoc = ""
    }
    if (phaloc == "") {
        dhcphaMsgBox.alert("ҩ��������Ϊ��!");
        return;
    }
    var configstr = tkMakeServerCall("web.DHCSTPHALOC", "GetPhaflag", phaloc);
    var configarr = configstr.split("^");
    var SendFlag = configarr[31];
    if (SendFlag == "Y") {
        var sendret = tkMakeServerCall("web.DHCSTInterfacePH", "SendOrderToMechine", pharowid);
        if (sendret != 0) {
            var retString = sendret.split("^")[1];
            dhcphaMsgBox.alert("���Ͱ�ҩ��ʧ��,�������:" + retString, "error");
            return;
        }
    }
}

function splitFormatter(cellvalue, options, rowObject) {
    if (cellvalue.indexOf("-") >= 0) {
        cellvalue = cellvalue.split("-")[1];
    }
    return cellvalue;
};
window.onresize = ResizeHMPrescDispQuery;
function ResizeHMPrescDispQuery(){
    var wardtitleheight = $("#gview_grid-presclist .ui-jqgrid-hbox").height();
    var wardheight = DhcphaJqGridHeight(1, 1) - wardtitleheight - 32;
    var prescheight = DhcphaJqGridHeight(1, 0) - 17;
    var admpressheight = DhcphaJqGridHeight(2, 1)*0.5 -47 ; ;
        //alert("admpressheight:"+admpressheight)
    $("#grid-presclist").setGridHeight(wardheight).setGridWidth("");
    $("#ifrm-presc").height(prescheight);
    $("#grid-admlist").setGridHeight(admpressheight).setGridWidth("");
    $("#grid-admpresclist").setGridHeight(admpressheight).setGridWidth("");
    
}
