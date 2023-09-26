var PageLogicObj = {
    m_DHCTimeRangeConfigListDataGrid: "",
    m_ReHospitalDataGrid: "",
    dw: $(window).width() - 150,
    dh: $(window).height() - 100
};
$(function () {
    var hospComp = GenUserHospComp();
    //ҳ�����ݳ�ʼ��
    Init();
    //�¼���ʼ��
    InitEvent();
    hospComp.jdata.options.onSelect = function (e, t) {
        //���س���ʱ���б�����
        DHCTimeRangeConfigListDataGridLoad();
    }
    hospComp.jdata.options.onLoadSuccess = function (data) {
        //���س���ʱ���б�����
        DHCTimeRangeConfigListDataGridLoad();
    }
});

function InitEvent() {
    var myobj = websys_$('TRStartTime');
    if (myobj) myobj.onchange = CheckTRStartTime;

    var myobj = websys_$('TRCancelTime');
    if (myobj) myobj.onchange = CheckTRCancelTime;

    var myobj = websys_$('TREndTime');
    if (myobj) myobj.onchange = CheckTREndTime;

    var myobj = websys_$('TRReturnTime');
    if (myobj) myobj.onchange = CheckTRReturnTime;

    var myobj = websys_$('TRRegSTTime');
    if (myobj) myobj.onchange = CheckTRRegSTTime;

    var myobj = websys_$('TRRegEndTime');
    if (myobj) myobj.onchange = CheckTRRegEndTime;

    $("#BtnSearch").click(DHCTimeRangeConfigListDataGridLoad);
    $("#BtnClear").click(ClearClickHander);
    $("#BtnAdd").click(AddClickHandle);
    $("#BtnUpdate").click(UpdateClickHandle);
}
function Init() {
    PageLogicObj.m_DHCTimeRangeConfigListDataGrid = InitDHCTimeRangeConfigListDataGrid();
}
function InitDHCTimeRangeConfigListDataGrid() {
    var Columns = [[
        { field: 'TID', hidden: true, title: '' },
        { field: 'TTRCode', title: '����', width: 40, align: 'center' },
        { field: 'TTRDesc', title: '����', width: 60, align: 'center' },
        { field: 'TTRStartTime', title: '���￪ʼʱ��', width: 100, align: 'center' },
        { field: 'TTREndTime', title: '�������ʱ��', width: 100, align: 'center' },
        { field: 'TTRReturnTime', title: 'ԤԼ�Żع�ʱ���', width: 125, align: 'center' },
        { field: 'TTRCancelTime', title: '�˺�ʱ���', width: 90, align: 'center' },
        {
            field: 'TTRValidStartDate', title: '��Ч��ʼ����', width: 100, align: 'center', formatter: function (value, row, index) {
                if (value != "") {
                    return tkMakeServerCall("websys.Conversions", "DateLogicalToHtml", value);
                }
            }
        },
        {
            field: 'TRValidEndDate', title: '��Ч��ֹ����', width: 100, align: 'center', formatter: function (value, row, index) {
                if (value != "") {
                    return tkMakeServerCall("websys.Conversions", "DateLogicalToHtml", value);
                }
            }
        },
        { field: 'TTRRegSTTime', title: '�Һſ�ʼʱ��', width: 100, align: 'center' },
        { field: 'TTRRegEndTime', title: '�ҺŽ���ʱ��', width: 100, align: 'center' },
        { field: 'TRAllowSpaceReturnDay', title: '��������պ��˺�����', width: 150, align: 'center' },
        { field: 'TRCheckin', title: '��Ҫ����', width: 60, align: 'center' },
    ]]
    var DHCTimeRangeConfigListDataGrid = $("#DHCTimeRangeConfigList").datagrid({
        fit: true,
        border: false,
        striped: false,
        singleSelect: true,
        fitColumns: true,
        autoRowHeight: false,
        rownumbers: true,
        pagination: true,
        pageSize: 20,
        pageList: [20, 100, 200],
        idField: 'TID',
        toolbar: [{
            text: '��ȨҽԺ',
            iconCls: 'icon-house',
            handler: ReHospitalHandle
        }],
        columns: Columns,
        onCheck: function (index, row) {
            SetSelRowData(row);
        },
        onUnselect: function (index, row) {
            ClearClickHander();
        },
        onBeforeSelect: function (index, row) {
            var selrow = PageLogicObj.m_DHCTimeRangeConfigListDataGrid.datagrid('getSelected');
            if (selrow) {
                var oldIndex = PageLogicObj.m_DHCTimeRangeConfigListDataGrid.datagrid('getRowIndex', selrow);
                if (oldIndex == index) {
                    PageLogicObj.m_DHCTimeRangeConfigListDataGrid.datagrid('unselectRow', index);
                    return false;
                }
            }
        }
    });
    return DHCTimeRangeConfigListDataGrid;
}
function DHCTimeRangeConfigListDataGridLoad() {
    $.q({
        ClassName: "web.DHCBL.CARD.DHCTimeRange",
        QueryName: "QueryTimeRange",
        TRCode: $("#TRCode").val(),
        TRDesc: $("#TRDesc").val(),
        HospID: $HUI.combogrid('#_HospUserList').getValue(),
        Pagerows: PageLogicObj.m_DHCTimeRangeConfigListDataGrid.datagrid("options").pageSize, rows: 99999
    }, function (GridData) {
        PageLogicObj.m_DHCTimeRangeConfigListDataGrid.datagrid({ loadFilter: DocToolsHUI.lib.pagerFilter }).datagrid('loadData', GridData);
    });
}
function ClearClickHander() {
    $("#ID").val("");
    $("#TRCode").val("");
    $("#TRDesc").val("");
    $("#TRCancelTime").val("");
    $("#TRStartTime").val("");
    $("#TREndTime").val("");
    $("#TRReturnTime").val("");
    $("#TRRegSTTime").val("");
    $("#TRRegEndTime").val("");
    $("#AllowSpaceReturnDay").val("");

    $HUI.datebox("#TRValidStartDate").setValue("");
    $HUI.datebox("#TRValidEndDate").setValue("");

    $("#Checkin").checkbox("setValue", false)
}

function AddClickHandle() {
    var rtn = CheckNull();
    if (!rtn) {
        return false;
    }

    //�������˽�������
    var ParseInfo = "TransContent^ID^TRCancelTime^TRCode^TRDesc^TREndTime^TRReturnTime^TRStartTime^TRRegSTTime^TRRegEndTime^AllowSpaceReturnDay";
    var DHCTimeRange = DHCDOM_GetEntityClassInfoToXML(ParseInfo);
    //alert(DHCTimeRange);

    var TRValidStartDate = $HUI.datebox("#TRValidStartDate").getValue();
    var TRValidEndDate = $HUI.datebox("#TRValidEndDate").getValue();
    var TRCheckin = "N"
    if ($("#Checkin").checkbox("getValue")) TRCheckin = "Y"
    var DHCTimeRange = DHCTimeRange.split("</TransContent>")[0] + "<TRValidStartDate>" + TRValidStartDate + "</TRValidStartDate>" + "<TRValidEndDate>" + TRValidEndDate + "</TRValidEndDate>"

    var DHCTimeRange = DHCTimeRange + "<TRCheckin>" + TRCheckin + "</TRCheckin>" + "</TransContent>"

    $.cm({
        ClassName: "web.DHCBL.CARD.DHCTimeRangeBuilder",
        MethodName: "DHCTimeRangeInsert",
        dataType: "text",
        DHCTimeRangeInfo: DHCTimeRange,
        HospID: $HUI.combogrid('#_HospUserList').getValue()
    }, function (rtn) {
        if (rtn == '10') {
            $.messager.alert("��ʾ", "�����ɹ�!����������Ѿ�����!", "info", function () {
                $("#TRCode").focus();
            });
        } else if (rtn != '-100' && rtn != '10') {
            $.messager.popover({ msg: '�����ɹ�!', type: 'success', timeout: 1000 });
            DHCTimeRangeConfigListDataGridLoad()
        } else {
            $.messager.alert("��ʾ", "����ʧ��!")
        }
    });
}

function UpdateClickHandle() {
    var rtn = CheckNull();
    if (!rtn) {
        return false;
    }

    //�������˽�������
    var ParseInfo = "TransContent^ID^TRCancelTime^TRCode^TRDesc^TREndTime^TRReturnTime^TRStartTime^TRRegSTTime^TRRegEndTime^AllowSpaceReturnDay";
    var DHCTimeRange = DHCDOM_GetEntityClassInfoToXML(ParseInfo);
    //alert(DHCTimeRange);

    //��Ч��ʼ����������
    var TRValidStartDate = $HUI.datebox("#TRValidStartDate").getValue();
    var TRValidEndDate = $HUI.datebox("#TRValidEndDate").getValue();
    // CheckIn��Ҫ����
    var TRCheckin = "N"
    if ($("#Checkin").checkbox("getValue")) TRCheckin = "Y"
    var DHCTimeRange = DHCTimeRange.split("</TransContent>")[0] + "<TRValidStartDate>" + TRValidStartDate + "</TRValidStartDate>" + "<TRValidEndDate>" + TRValidEndDate + "</TRValidEndDate>"
    var DHCTimeRange = DHCTimeRange + "<TRCheckin>" + TRCheckin + "</TRCheckin>" + "</TransContent>"

    $.cm({
        ClassName: "web.DHCBL.CARD.DHCTimeRangeBuilder",
        MethodName: "DHCTimeRangeUpdate",
        dataType: "text",
        DHCTimeRangeInfo: DHCTimeRange,
    }, function (rtn) {
        if ((rtn == '-100') || (rtn == "0")) {
            $.messager.popover({ msg: '���³ɹ�!', type: 'success', timeout: 1000 });
            ClearClickHander()
            DHCTimeRangeConfigListDataGridLoad()
        } else if (rtn == '10') {
            $.messager.alert("��ʾ", "����ʧ��!����������ظ�!");
        } else {
            $.messager.alert("��ʾ", "����ʧ��!")
        }
    });
}

function createModalDialog(id, _title, _width, _height, _icon, _btntext, _content, _event) {
    $("body").append("<div id='" + id + "' class='hisui-dialog'></div>");
    if (_width == null)
        _width = 800;
    if (_height == null)
        _height = 500;
    $("#" + id).dialog({
        title: _title,
        width: _width,
        height: _height,
        cache: false,
        iconCls: _icon,
        //href: _url,
        collapsible: false,
        minimizable: false,
        maximizable: false,
        resizable: false,
        modal: true,
        closed: false,
        closable: true,
        content: _content,
        onClose: function () {
            destroyDialog(id);
        }
    });
}

function destroyDialog(id) {
    //�Ƴ����ڵ�Dialog
    $("body").remove("#" + id);
    $("#" + id).dialog('destroy');
}

function SetSelRowData(row) {
    $("#ID").val(row["TID"]);
    $("#TRCode").val(row["TTRCode"]);
    $("#TRDesc").val(row["TTRDesc"]);
    $("#TRCancelTime").val(row["TTRCancelTime"]);
    $("#TRStartTime").val(row["TTRStartTime"]);
    $("#TREndTime").val(row["TTREndTime"]);
    $("#TRReturnTime").val(row["TTRReturnTime"]);
    $("#TRRegSTTime").val(row["TTRRegSTTime"]);
    $("#TRRegEndTime").val(row["TTRRegEndTime"]);
    $("#AllowSpaceReturnDay").val(row["TRAllowSpaceReturnDay"]);
    var ValidStartDate = row["TTRValidStartDate"]
    if (ValidStartDate != "") var ValidStartDate = tkMakeServerCall("websys.Conversions", "DateLogicalToHtml", ValidStartDate);
    var ValidEndDate = row["TRValidEndDate"]
    if (ValidEndDate != "") var ValidEndDate = tkMakeServerCall("websys.Conversions", "DateLogicalToHtml", ValidEndDate);
    $HUI.datebox("#TRValidStartDate").setValue(ValidStartDate);
    $HUI.datebox("#TRValidEndDate").setValue(ValidEndDate);
    $("#Checkin").checkbox("setValue", (row["TRCheckin"] == "Y") ? true : false)
}

//��֤�����ֶ�
function CheckNull() {
    if ($("#TRCode").val() == "") {
        $.messager.alert("��ʾ", "�����������!");
        $("#TRCode").focus();
        return false;
    }

    if ($("#TRDesc").val() == "") {
        $.messager.alert("��ʾ", "���Ʊ�������!");
        $("#TRDesc").focus();
        return false;
    }

    if ($("#TRCancelTime").val() == "") {
        $.messager.alert("��ʾ", "�˺�ʱ��㲻��Ϊ��!");
        $("#TRCancelTime").focus();
        return false;
    }

    if ($("#TRReturnTime").val() == "") {
        $.messager.alert("��ʾ", "ԤԼ�Żع�ʱ��㲻��Ϊ��!");
        $("#TRReturnTime").focus();
        return false;
    }

    if ($("#TRStartTime").val() == "") {
        $.messager.alert("��ʾ", "���￪ʼʱ�䲻��Ϊ��!");
        $("#TRStartTime").focus();
        return false;
    }

    if ($("#TREndTime").val() == "") {
        $.messager.alert("��ʾ", "�������ʱ�䲻��Ϊ��!");
        $("#TREndTime").focus();
        return false;
    }

    return true;
}

function CheckTRReturnTime() {
    var myobj = websys_$('TRReturnTime');
    CheckTime(myobj);
}

function CheckTREndTime() {
    var myobj = websys_$('TREndTime');
    CheckTime(myobj);
}
function CheckTRStartTime() {
    var myobj = websys_$('TRStartTime');
    CheckTime(myobj);
}

function CheckTRCancelTime() {
    var myobj = websys_$('TRCancelTime');
    CheckTime(myobj);
}

function CheckTRRegSTTime() {
    var myobj = websys_$('TRRegSTTime');
    CheckTime(myobj);
}
function CheckTRRegEndTime() {
    var myobj = websys_$('TRRegEndTime');
    CheckTime(myobj);
}

function CheckTime(myobj) {
    var tstr = myobj.value;
    if (tstr) {
        var tstr_Split = tstr.split(":")
        var hour = tstr_Split[0];
        var minuts = tstr_Split[1];
        var seconds = tstr_Split[2];
        if (seconds == undefined) seconds = "00"
        if (minuts) {
            if (minuts.length > 2) {
                minuts = minuts.substring(0, 2);
            }
            else if (minuts.length == 1) {
                minuts = '0' + minuts;
            }
            if (hour.length > 2) {
                hour = hour.substring(0, 2);
            }
            else if (hour.length == 1) {
                hour = '0' + hour;
            }
        }
        else {
            switch (hour.length) {
                case 1: { hour = '0' + hour; minuts = '00'; break; }
                case 2: { minuts = '00'; break; }
                case 3: { minuts = hour.substring(2, 4); hour = hour.substring(0, 2); minuts = '0' + minuts; break; }
                case 4: { minuts = hour.substring(2, 4); hour = hour.substring(0, 2); break; }
            }
        }
        if (hour >= 24) {
            hour = 23;
        }
        if (minuts >= 60) {
            minuts = 59;
        }
        if (seconds >= 60) {
            seconds = 59;
        }
        //myobj.value=hour+':'+minuts+':00';
        myobj.value = hour + ':' + minuts + ':' + seconds;
    }
}
function ReHospitalHandle() {
    var row = PageLogicObj.m_DHCTimeRangeConfigListDataGrid.datagrid('getSelected');
    if ((!row) || (row.length == 0)) {
        $.messager.alert("��ʾ", "��ѡ��һ�У�")
        return false
    }
    GenHospWin("DHC_TimeRange", row.TID);
    /*$("#ReHospital-dialog").dialog("open");
    $.cm({
            ClassName:"DHCDoc.DHCDocConfig.InstrArcim",
            QueryName:"GetHos",
            rows:99999
        },function(GridData){
            var cbox = $HUI.combobox("#Hosp", {
                editable:false,
                valueField: 'HOSPRowId',
                textField: 'HOSPDesc', 
                data: GridData["rows"],
                onLoadSuccess:function(){
                    $("#Hosp").combobox('select','');
                }
             });
    });
    PageLogicObj.m_ReHospitalDataGrid=ReHospitalDataGrid();
    LoadReHospitalDataGrid();*/
}
function ReHospitalDataGrid() {
    var toobar = [{
        text: '����',
        iconCls: 'icon-add',
        handler: function () { ReHospitaladdClickHandle(); }
    }, {
        text: 'ɾ��',
        iconCls: 'icon-remove',
        handler: function () { ReHospitaldelectClickHandle(); }
    }];
    var Columns = [[
        { field: 'Rowid', hidden: true, title: 'Rowid' },
        { field: 'HospID', hidden: true, title: 'HospID' },
        { field: 'HospDesc', title: 'ҽԺ', width: 100 }
    ]]
    var ReHospitalDataGrid = $("#ReHospitalTab").datagrid({
        fit: true,
        border: false,
        striped: false,
        singleSelect: true,
        fitColumns: true,
        autoRowHeight: false,
        rownumbers: true,
        pagination: true,
        rownumbers: true,
        pageSize: 20,
        pageList: [20, 50, 100],
        idField: 'Rowid',
        columns: Columns,
        toolbar: toobar
    });
    return ReHospitalDataGrid;
}
function LoadReHospitalDataGrid() {
    var row = PageLogicObj.m_DHCTimeRangeConfigListDataGrid.datagrid('getSelected');
    if ((!row) || (row.length == 0)) {
        $.messager.alert("��ʾ", "��ѡ��һ�У�")
        return false
    }
    var ID = row["TID"]
    $.q({
        ClassName: "web.DHCOPRegConfig",
        QueryName: "FindHopital",
        BDPMPHTableName: "DHC_TimeRange",
        BDPMPHDataReference: ID,
        Pagerows: PageLogicObj.m_ReHospitalDataGrid.datagrid("options").pageSize, rows: 99999
    }, function (GridData) {
        PageLogicObj.m_ReHospitalDataGrid.datagrid("unselectAll");
        PageLogicObj.m_ReHospitalDataGrid.datagrid({ loadFilter: DocToolsHUI.lib.pagerFilter }).datagrid('loadData', GridData);
    });
}
function ReHospitaladdClickHandle() {
    var HospID = $("#Hosp").combobox("getValue")
    if (HospID == "") {
        $.messager.alert("��ʾ", "��ѡ��ҽԺ", "info");
        return false;
    }
    var row = PageLogicObj.m_DHCTimeRangeConfigListDataGrid.datagrid('getSelected');
    if ((!row) || (row.length == 0)) {
        $.messager.alert("��ʾ", "��ѡ��һ�У�")
        return false
    }
    var ID = row["TID"]
    $.cm({
        ClassName: "web.DHCBL.BDP.BDPMappingHOSP",
        MethodName: "SaveHOSP",
        BDPMPHTableName: "DHC_TimeRange",
        BDPMPHDataReference: ID,
        BDPMPHHospital: HospID,
        dataType: "text",
    }, function (data) {
        if (data == "1") {
            $.messager.alert("��ʾ", "�����ظ�", "info");
        } else {
            $.messager.popover({ msg: data.split("^")[1], type: 'success', timeout: 1000 });
            LoadReHospitalDataGrid();
        }
    })
}
function ReHospitaldelectClickHandle() {
    var SelectedRow = PageLogicObj.m_ReHospitalDataGrid.datagrid('getSelected');
    if (!SelectedRow) {
        $.messager.alert("��ʾ", "��ѡ��һ��", "info");
        return false;
    }
    var row = PageLogicObj.m_DHCTimeRangeConfigListDataGrid.datagrid('getSelected');
    if ((!row) || (row.length == 0)) {
        $.messager.alert("��ʾ", "��ѡ��һ�У�")
        return false
    }
    var ID = row["TID"]
    $.cm({
        ClassName: "web.DHCBL.BDP.BDPMappingHOSP",
        MethodName: "DeleteHospital",
        BDPMPHTableName: "DHC_TimeRange",
        BDPMPHDataReference: ID,
        BDPMPHHospital: SelectedRow.HospID,
        dataType: "text",
    }, function (data) {
        $.messager.popover({ msg: 'ɾ���ɹ�!', type: 'success', timeout: 1000 });
        LoadReHospitalDataGrid();
    })

}
