var PageLogicObj = {
    m_ScheduleTemplateListDataGrid: "",
    m_tabAppQtyListDataGrid: "",
    m_ClassName: 'DHCDoc.DHCDocConfig.ScheduleTemp',
    m_QueryName: 'FindScheduleTemp',
    m_ComboJsonCSP: './dhcdoc.cure.query.combo.easyui.csp',
    m_GridJsonCSP: './dhcdoc.cure.query.grid.easyui.csp',
    m_TreeJsonCSP: './dhcdoc.cure.query.tree.easyui.csp',
    m_SelectTimeRange: "",
    m_LoadSessTimer: "",
    m_AddFlag: 1,
    m_ASLoad: ""
}
var EditRow = -1;
$(function () {
    //��ʼ��
    //Init();
    InitHospList();
    //�¼���ʼ��
    InitEvent();
    //ҳ��Ԫ�س�ʼ��
    PageHandle();
})
function InitHospList() {
    var hospComp = GenUserHospComp();
    hospComp.jdata.options.onSelect = function (e, t) {
        Init();
    }
    hospComp.jdata.options.onLoadSuccess = function (data) {
        Init();
    }
}
function InitEvent() {
    $("#BAddDoc").click(function () {
        PageLogicObj.m_AddFlag = 1;
        ResClick("", "", "");
    });
    $("#PrintSchedule").click(function () {
        PrintScheduleClick("Print");
    });
    $("#ExportSchedule").click(function () {
        //var path=BrowseFolder();
        //if(path)
        PrintScheduleClick("Export"); //path
    });
    $("#BatchSchedule").click(GenSche);
    $("#BtnAddSess").click(function () {
        SaveClick("Add");
    });
    $("#BtnSaveSess").click(function () {
        SaveClick("Update");
    });
    $("#BtnDeleteSess").click(function () {
        DeleteSess();
    });
    $("#mm-weekclose").click(DeleteSessByWeek);
    $HUI.checkbox("#TRFlag", {
        onCheckChange: function (e, value) {
            TRFlag_Click();
            //Calc_TRInfo();
        }
    });
    //$("#TRStartTime,#TREndTime").on("change", Calc_TRInfo);
    //$("#TRRegNum,#TRLength").numberbox({onChange:Calc_TRInfo});
    $('#BTRGen').click(TRGenClick);
    $HUI.radio("input[name='ClickType']", {
        onCheckChange: function (e, value) {
            if (e.currentTarget.value == 3) {
                $('.datagrid-body [class*="datagrid-cell-c2-Week"]').parent().draggable('enable');
            } else {
                $('.datagrid-body [class*="datagrid-cell-c2-Week"]').parent().draggable('disable');
            }
            $(".droppable").unbind("mousedown");
            //$(document).unbind("mousedown");
        }
    });

    /*$("input[name='ClickType']").change(function(){
        if($(this).val()==3){
            $('.datagrid-body [class*="datagrid-cell-c2-Week"]').parent().draggable('enable');
        }else{
            $('.datagrid-body [class*="datagrid-cell-c2-Week"]').parent().draggable('disable');
        }
    });*/
    $("#TRLength").change(TRLengthChange);
    $("#BFind").click(function () { $('#ScheduleTemplateList').datagrid('reload'); });
    $('#BTRTempSave').click(TRTempSaveClick);
    //$(document.body).bind("keydown",BodykeydownHandler);
    document.onkeydown = Doc_OnKeyDown;
}
function Doc_OnKeyDown(e) {
    //��ֹ�ڿհ״����˸���������Զ����˵���һ������
    if (!websys_cancelBackspace(e)) return false;
    //�������Backspace������  
    var keyEvent;
    if (e.keyCode == 8) {
        var d = e.srcElement || e.target;
        if (d.tagName.toUpperCase() == 'INPUT' || d.tagName.toUpperCase() == 'TEXTAREA') {
            keyEvent = d.readOnly || d.disabled;
        } else {
            keyEvent = true;
        }
    } else {
        keyEvent = false;
    }
    if (keyEvent) {
        e.preventDefault();
    }
}
function PageHandle() {
}
function Init() {
    InitSingleCombo('ScheduleLines_Search', 'RSLRowId', 'Desc', 'RBScheduleLinesList');
    InitSingleCombo('Zone_Search', 'rowid', 'desc', 'QueryZoneList');
    InitSingleCombo('Loc_Search', 'rowid', 'desc', 'QueryLocList');
    InitSingleCombo('Doc_Search', 'rowid', 'desc', 'QueryDocList');
    InitSingleCombo('AdmLoc', 'rowid', 'desc', 'QueryLocList');
    InitSingleCombo('AdmDoc', 'rowid', 'desc', 'QueryDocList');
    InitSingleCombo('TimeRange', 'TRRowid', 'TRDesc', 'QueryTimeRange');
    InitSingleCombo('DocSession', 'ID', 'Desc', 'RBCSessionTypeQuery', false, "web.DHCBL.BaseReg.BaseDataQuery");
    InitSingleCombo('ClinicGroup', 'CLGRPRowId', 'CLGRPDesc', 'GetClinicGroupByLocNew', true, "web.DHCRBResSession");
    InitSingleCombo('LocArea', 'RoomRowid', 'RoomDesc', 'QueryRoom');
    InitSingleCombo('DayOfWeek', 'DOWRowid', 'DOWDesc', 'QueryDOW');
    InitDOWTabs();
    InitTRTabs();
}
function InitScheduleTemplateListDataGrid() {
    var weekObj = {
        field: '', title: '', align: 'center', width: 90, resizable: true,
        styler: function (value, row, index) {
            var style = 'cursor:pointer;';
            if (value) {
                var flag = value.split('^')[1];
                if (flag != 'Y') {
                    style += 'background-color:#f64c60;'	//#F4F6F5
                }
                return style;
            }
        },
        formatter: function (value, row, index) {
            if (value) {
                return value.split('^')[0];
            }
        }
    };
    var ListColumns = [[
        { field: 'LocDesc', title: '����', align: 'center', width: 200, resizable: true },
        { field: 'ResDesc', title: 'ҽ��', align: 'center', width: 200, resizable: true },
        { field: 'TimeRange', title: 'ʱ��', align: 'center', width: 90, resizable: true },
        $.extend({}, weekObj, { field: 'Week1', title: '����һ' }),
        $.extend({}, weekObj, { field: 'Week2', title: '���ڶ�' }),
        $.extend({}, weekObj, { field: 'Week3', title: '������' }),
        $.extend({}, weekObj, { field: 'Week4', title: '������' }),
        $.extend({}, weekObj, { field: 'Week5', title: '������' }),
        $.extend({}, weekObj, { field: 'Week6', title: '������' }),
        $.extend({}, weekObj, { field: 'Week7', title: '������' }),
        { field: 'RowId', hidden: true },
        { field: 'LocRowid', hidden: true },
        { field: 'DocRowid', hidden: true },
        { field: 'TimeRangeDr', hidden: true },

    ]]
    var ScheduleTemplateListDataGrid = $("#ScheduleTemplateList").datagrid({
        fit: true,
        border: false,
        width: 'auto',
        autoRowHeight: false,
        striped: false,
        singleSelect: true,
        fitColumns: true,
        nowrap: true,
        url: PageLogicObj.m_GridJsonCSP,
        loadMsg: '������..',
        pagination: true,
        rownumbers: false,
        idField: "RowId",
        pageSize: 30,
        pageList: [30, 50, 100, 200],
        columns: ListColumns,
        toolbar: "#tb",
        onBeforeLoad: function (param) {
            var ScheduleLinesRowId = $("#ScheduleLines_Search").combobox('getValue');
            if (ScheduleLinesRowId == "") return false;
            param.ClassName = PageLogicObj.m_ClassName;
            param.QueryName = PageLogicObj.m_QueryName;
            param.Arg1 = getValue('Loc_Search');
            param.Arg2 = session['LOGON.USERID'];
            param.Arg3 = getValue('Doc_Search');
            param.Arg4 = getValue('Zone_Search');
            param.Arg5 = ScheduleLinesRowId;
            param.Arg6 = "";
            param.Arg7 = "";
            param.Arg8 = $HUI.combogrid('#_HospUserList').getValue();;
            param.ArgCnt = 8;
        },
        onLoadSuccess: function (data) {
            MergeCell(data, 0, data.rows.length - 1, "LocDesc");
            InitDragItem();
        },
        onClickCell: function (rowIndex, field, value) {
            if (field.indexOf("Week") == -1) return;
            var eve = event || window.event;
            var target = eve.target || eve.srcElement;
            var $obj = $(target);
            if (target.nodeName == "DIV") $obj = $(target).parent();
            value = $obj.text();
            var DataArr = $(this).datagrid('getData');
            var DateRowid = DataArr.rows[rowIndex].RowId.split("^")[0];
            var ClickType = $("input[name='ClickType']:checked").val();
            //ά��ģ��
            if (ClickType == '1') {
                var LocRowid = DataArr.rows[rowIndex].LocRowid;
                var DocRowid = DataArr.rows[rowIndex].DocRowid;
                var TimeRange = DataArr.rows[rowIndex].TimeRange;
                var Week = "", WeekIndex = "";
                for (var i = 0; i < ListColumns[0].length; i++) {
                    if (ListColumns[0][i].field == field) {
                        Week = ListColumns[0][i].title;
                        WeekIndex = field.replace("Week", "");
                        break;
                    }
                }
                if (value == "") {
                    var TimeRange = DataArr.rows[rowIndex].TimeRangeDr;
                    var Week = WeekIndex;
                    //����ģ��
                    PageLogicObj.m_AddFlag = 1;
                } else {
                    PageLogicObj.m_AddFlag = 0;
                }
                ResClick(DateRowid, LocRowid, DocRowid, Week, TimeRange);
            } else if (ClickType == '2') { //ģ�弤��/ȡ������
                if (value == "") return;
                var WeekNo = field.split("Week")[1];
                var TimeRange = DataArr.rows[rowIndex].RowId.split("^")[1];
                var ret = tkMakeServerCall(PageLogicObj.m_ClassName, "ActiveSess", DateRowid, WeekNo, TimeRange);
                if (ret == '0') {
                    var Info = "����ģ��ɹ�!";
                    if ($obj.hasClass('inactive') || ($obj.attr('style'))) {
                        $obj.removeAttr("style");
                        $obj.removeClass('inactive');
                    } else {
                        $obj.addClass('inactive');
                        Info = "ȡ��" + Info;
                    }
                    $.messager.popover({ msg: Info, type: 'success' });
                } else {
                    $.messager.alert('��ʾ', "����/ȡ������ʧ��:" + ret);
                }
            }
        }
    });
    return ScheduleTemplateListDataGrid;
}
function MergeCell(Data, StartIndex, EndIndex, Field) {
    if (StartIndex == EndIndex) return;
    var InfoObj = { Index: StartIndex, Rows: 1, Value: "" };
    for (var i = StartIndex; i <= EndIndex; i++) {
        var cmd = "var value=Data.rows[i]." + Field;
        eval(cmd);
        if (i == StartIndex) {
            InfoObj.Value = value;
            continue;
        }
        if ((InfoObj.Value == value) && (EndIndex != i)) {
            InfoObj.Rows += 1;
        } else {
            if ((EndIndex == i) && (InfoObj.Value == value)) InfoObj.Rows += 1;
            if (InfoObj.Rows > 1) {
                $('#ScheduleTemplateList').datagrid('mergeCells', {
                    index: InfoObj.Index,
                    field: Field,
                    rowspan: InfoObj.Rows
                });
                if (Field == "LocDesc")
                    MergeCell(Data, InfoObj.Index, InfoObj.Index + InfoObj.Rows - 1, 'ResDesc');
            }
            InfoObj = { Index: i, Rows: 1, Value: value };
        }
    }
}
function InitDragItem() {
    var DragDisabled = true;
    var ClickType = $("input[name='ClickType']:checked").val();
    if (ClickType == 3) DragDisabled = false;
    var DragObj = {
        revert: true,
        disabled: DragDisabled,
        proxy: function (source) {
            var p = $('<div style="border:1px solid #ccc"></div>');
            p.html($(source).html()).appendTo('body');
            return p;
        }
    };
    $('.datagrid-body [class*="datagrid-cell-c2-Week"]').parent().each(function () {
        if ($(this).text() != "") {
            $(this).draggable(DragObj);
        } else {
            $(this).droppable({
                onDrop: function (e, source) {
                    var className = $(source).children()[0].className;
                    var WeekNo = Number(className.charAt(className.length - 1));
                    var RowId = $(source).parent().find('.datagrid-cell-c2-RowId').text();
                    var DateRowid = RowId.split("^")[0];
                    var CopyFromTimeRange = RowId.split("^")[1];
                    var SessRowid = tkMakeServerCall(PageLogicObj.m_ClassName, 'GetResDataWeeks', DateRowid, WeekNo, CopyFromTimeRange);
                    if (SessRowid == "") return false;
                    var ResSessData = SetResSessData(SessRowid);
                    //$("#ClinicGroup,#LocArea").combobox("setValue","");
                    //ͬ���ҵĿ��Ը�����רҵ
                    var ResLocID = "";
                    if (ResSessData != "") {
                        var RetArr = ResSessData.split("!");
                        var ResLocID = RetArr[2];
                    }
                    var LocRowid = $(this).parent().find('.datagrid-cell-c2-LocRowid').text();
                    if ((ResLocID != "") && (LocRowid != ResLocID)) {
                        dhcsys_alert("��ͬ���Ҳ���������רҵ,��רҵ����δ����,��ȷ�ϲ��޸�!")
                        $("#ClinicGroup").combobox("setValue", "");
                    }
                    var DocRowid = $(this).parent().find('.datagrid-cell-c2-DocRowid').text();
                    var className = $(this).children()[0].className;
                    var WeekNo = Number(className.charAt(className.length - 1));
                    var RowId = $(this).parent().find('.datagrid-cell-c2-RowId').text();
                    var TimeRange = RowId.split("^")[1];
                    var DOWArr = $("#DayOfWeek").combobox('getData');
                    var WeekId = DOWArr[WeekNo - 1].DOWRowid;
                    $("#DayOfWeek").combobox("setValue", WeekId);
                    $("#TimeRange").combobox("select", TimeRange);
                    $("#AdmLoc").combobox("select", LocRowid);
                    $("#AdmDoc").combobox("setValue", DocRowid);
                    var RoomStr = tkMakeServerCall("DHCDoc.DHCDocConfig.ScheduleTemp", 'QueryRoomBroker', "", session['LOGON.USERID'], LocRowid);
                    var LocAreaID = $("#LocArea").combobox("getValue");
                    if ((RoomStr != "") && (LocAreaID != "")) {
                        if (("^" + RoomStr + "^").indexOf("^" + LocAreaID + "^") == -1) {
                            //dhcsys_alert("��������δ����,��ȷ�ϲ��޸�!")
                            $("#LocArea").combobox("setValue", "");
                        }
                    } else {
                        $("#LocArea").combobox("setValue", "");
                    }
                    var LocAreaID = $("#LocArea").combobox("getValue");
                    if (LocAreaID != "") {
                        var GenerFlag = "N";
                        if ($("#ScheduleGenerFlag").checkbox('getValue')) GenerFlag = "Y";
                        var find = tkMakeServerCall("web.DHCRBResSession", 'FindSessionByWeekTRRoom', WeekId, TimeRange, $("#LocArea").combobox("getValue"), "");
                        if ((find != "") && (GenerFlag != "N")) {
                            dhcsys_alert("ͬʱ��ͬ���������Ű�ģ��,��������δ����,��ȷ�ϲ��޸�!")
                            $("#LocArea").combobox("setValue", "");
                        }
                    }
                    TRFlag_Click();
                    LoadApptabAppMethodInfo(SessRowid);
                    LoadtabTRInfo(SessRowid);
                    //Calc_TRInfo();
                    var ret = SaveClick("CopyAdd", CopyFromTimeRange);
                    if (ret) {
                        $.messager.popover({ msg: "����ģ��ɹ�!", type: 'success' });
                        $(this).html($(source).html());
                        $(this).children().attr('class', className)
                        $(this).droppable('disable');
                        $(this).draggable($.extend({}, DragObj, { disabled: false, proxy: "" }));
                        PageLogicObj.m_AddFlag = 0;
                        ResClick(RowId.split("^")[0], LocRowid, DocRowid, WeekNo, $("#TimeRange").combobox("getText"));
                        setTimeout(function () {
                            $('#tabWeek').tabs('select', DOWArr[WeekNo - 1]['DOWDesc']);
                            $('#tabTimeRange').tabs('select', $("#TimeRange").combobox("getText"));
                        })
                    }
                    return ret;
                }
            });
            $("td .droppable").unbind("mousedown");
        }
    });
    //$(document).unbind("mousedown");
}
function ResClick(DateRowid, LocRowid, DocRowid, Week, TimeRange) {
    $("#tips").html("");
    $("#BtnSaveSess,#BtnDeleteSess,#BtnAddSess,#tabWeek,#tabTimeRange").show();
    var WinTitle = "�޸�ҽ��ģ��";
    if (PageLogicObj.m_AddFlag == "1") {
        WinTitle = "����ҽ��ģ��";
        if (DateRowid != "") {
            ClearTabs('tabWeek');
            ClearTabs('tabTimeRange');
            $("#AdmLoc").combobox("disable").combobox("select", LocRowid);
            $("#AdmDoc").combobox("disable").combobox("select", DocRowid);
            setTimeout(function () {
                $("#TRStartTime,#TREndTime").timespinner('setValue', '');
                $("#TRLength,#TRRegNum,#PositiveMax,#ApptMax,#EStartPrefix").numberbox('setValue', '');
                $("#TRRegNumStr,#TRRegInfoStr").val('');
                $("#TimeRange,#ClinicGroup").combobox('setValue', '');
                $('#TRFlag').checkbox('uncheck');
                TRFlag_Click();
                /*if (PageLogicObj.m_tabAppQtyListDataGrid!=""){
                    $('#tabAppQtyList').datagrid('loadData',{"total":0,"rows":[]});
                }*/
                $("#TimeRange").combobox('select', TimeRange);
                $("#DayOfWeek").combobox('setValue', Week);
                var sessTypeDr = tkMakeServerCall("web.DhcResEffDateSessionClass", "GetSessTypeByDocId", DocRowid, LocRowid);
                if (sessTypeDr != "") {
                    $("#DocSession").combobox("select", sessTypeDr.toString());
                }
                DocSelectFun();
                InitTRDataGrid();
                InitAppMethodGrid();
                LoadApptabAppMethodInfo("");
                LoadtabTRInfo("");
            }, 500);
        } else {
            $("#AdmLoc,#AdmDoc").combobox("setText", "");
            $("#AdmLoc,#AdmDoc").combobox("select", "").combobox("enable");
            $("#AdmDoc").combobox("loadData", []);
            ClearTabs('tabWeek');
            ClearTabs('tabTimeRange');
            $('#TRFlag').checkbox('uncheck');
            setTimeout(function () { SetResSessData(""); }, 100);
        }
        $("#BtnSaveSess,#BtnDeleteSess,#tabWeek,#tabTimeRange").hide();
        /*if (PageLogicObj.m_tabAppQtyListDataGrid!=""){
            $('#tabAppQtyList').datagrid('loadData',{"total":0,"rows":[]});
        }*/
        $("#LocArea").combobox('select', '');
    } else {
        $("#AdmLoc").combobox("disable").combobox("select", LocRowid);
        SetDocList(LocRowid, 'AdmDoc');
        $("#AdmDoc").combobox("disable").combobox("select", DocRowid);
        setTimeout(function () {
            LoadWeekTabs(DateRowid, Week, TimeRange)
        }
        );
    }
    //$("#ApptMax,#EStartPrefix").attr("disabled",true);
    if ($("#SessEditWindow").hasClass('window-body')) {
        $('#SessEditWindow').window('open'); //window('setTitle',WinTitle).
    } else {
        InitWindow(WinTitle);
    }
    setTimeout(function () {
        if (DateRowid != "") {
            var selLoc = $("#AdmLoc").combobox("getText");
            var selDoc = $("#AdmDoc").combobox("getText");
            //var oldTitle=$('#SessEditWindow').window('options').title;
            $('#SessEditWindow').window('setTitle', WinTitle + " <font color='yellow'>" + selLoc + "  " + selDoc + "<font>");
        }
    }, 1000)
    return;
}
function InitWindow(WinTitle) {
    $('#SessEditWindow').window({
        title: WinTitle,
        zIndex: 9999,
        iconCls: 'icon-w-edit',
        inline: false,
        minimizable: false,
        maximizable: false,
        collapsible: false,
        closable: true,
        onBeforeClose: function () {
            $('#tabWeek,#tabTimeRange').tabs({
                onSelect: function () {
                }
            })
            ClearTabs('tabWeek');
            ClearTabs('tabTimeRange');
            $('#SessEditWindow').window('setTitle', '');
            clearTimeout(PageLogicObj.m_LoadSessTimer);
            $('#ScheduleTemplateList').datagrid('reload');
            PageLogicObj.m_AddFlag = 0;
            InitDOWTabs();
            InitTRTabs();
        }
    });
}
function SetDocList(LocID, ID) {
    var url = PageLogicObj.m_ComboJsonCSP + '?ClassName=' + PageLogicObj.m_ClassName + '&QueryName=QueryDocList';
    url += "&Arg1=" + LocID + '&ArgCnt=' + 1;
    $("#" + ID).combobox('setValue', '');
    $("#" + ID).combobox('reload', url);
}
function SetLocList(ZoneID, ID) {
    var HospID = $HUI.combogrid('#_HospUserList').getValue();
    var url = PageLogicObj.m_ComboJsonCSP + '?ClassName=' + PageLogicObj.m_ClassName + '&QueryName=QueryLocList';
    url += "&Arg1=" + session['LOGON.USERID'] + '&Arg2=' + ZoneID + '&Arg3=' + HospID + '&ArgCnt=' + 3;
    $("#" + ID).combobox('setValue', '');
    $("#" + ID).combobox('reload', url);
}
function ClearTabs(ID) {
    var tabs = $('#' + ID).tabs('tabs');
    for (var i = tabs.length; i > 0; i--) {
        var index = $('#' + ID).tabs('getTabIndex', tabs[i - 1]);
        $('#' + ID).tabs('close', index);
    }
}
function LoadWeekTabs(DateRowid, DefWeek, DefTimeRange) {
    PageLogicObj.m_SelectTimeRange = DefTimeRange;
    ClearTabs('tabWeek');
    var DOWStr = tkMakeServerCall(PageLogicObj.m_ClassName, "GetResDataWeeks", DateRowid);
    var DOWArr = DOWStr.split("^");
    for (var i = 0; i < DOWArr.length; i++) {
        var title = DOWArr[i].split(":")[0];
        var id = DOWArr[i].split(":")[1];
        var tabWeekObj = { id: id, title: title, closable: false, selected: false };
        if ((DefWeek != undefined) && (DefWeek != "") && (title == DefWeek)) $.extend(tabWeekObj, { selected: true });
        else if (i == 0) $.extend(tabWeekObj, { selected: true });
        $('#tabWeek').tabs('add', tabWeekObj);
    }
}
function SetResSessData(SessRowid) {
    /*if (PageLogicObj.m_tabAppQtyListDataGrid==""){
        PageLogicObj.m_tabAppQtyListDataGrid=InitAppQtyList();
    }*/
    InitTRDataGrid();
    InitAppMethodGrid();
    //$('#tabAppQtyList').datagrid('unselectAll').datagrid('endEdit',EditRow); 
    EditRow = -1;
    /*var data=$.cm({
         ClassName:"web.DHCRBResEffDateSessAppQty",
         QueryName:"GetSessAppQtys",
         ResSessRowId:SessRowid,
         rows:99999
    },false);
    $('#tabAppQtyList').datagrid('loadData',data);*/
    /*$('#tabAppQtyList').datagrid('load',{
        ClassName:'web.DHCRBResEffDateSessAppQty',
        QueryName:'GetSessAppQtys',
        Arg1:SessRowid,
        ArgCnt:1
    });*/
    //SessRowid��Ϊ��ʱ�ڼ������ں�ʱ��ʱ������load��ʱ�����ݣ��ʴ˴������ظ�����
    /*if (SessRowid=="") {
        LoadApptabAppMethodInfo(SessRowid);
        LoadtabTRInfo(SessRowid);
    }*/
    if (SessRowid) $("#BtnSaveSess").show();
    else $("#BtnSaveSess").hide();
    var RetData = "";
    if (SessRowid != "") {
        var RetData = tkMakeServerCall(PageLogicObj.m_ClassName, "GetSessData", SessRowid);
        var RetArr = RetData.split("!");
        var SessArr = RetArr[0].split("^");
        var TRArr = RetArr[1].split("^");
        var ResLocID = RetArr[2];
        $("#ApptMax").numberbox('setValue', SessArr[0]);
        $("#DayOfWeek").combobox("setValue", SessArr[1]);
        $("#TimeRange").combobox("setValue", SessArr[2]);
        $("#PositiveMax").numberbox('setValue', SessArr[7]);
        PageLogicObj.m_ASLoad = SessArr[7];
        $("#DocSession").combobox("setValue", SessArr[8]);
        $("#AddtionMax").numberbox('setValue', SessArr[13]);
        $("#LocArea").combobox("setValue", SessArr[18]);
        $("#EStartPrefix").numberbox('setValue', SessArr[20]);
        //$("#ClinicGroup").combobox("setValue",SessArr[34]);
        if ((SessArr[41] != "") && (typeof (SessArr[41]) != "undefined")) {
            $("#ClinicGroup").combobox("setValues", SessArr[41].split(","));
        } else {
            $("#ClinicGroup").combobox("setValue", "");
        }
        var GenerFlag = SessArr[15];
        if (GenerFlag == "Y") $('#ScheduleGenerFlag').checkbox('check');
        else if (GenerFlag == "N") $('#ScheduleGenerFlag').checkbox('uncheck');

        if ((TRArr[1] != undefined) && (TRArr[1] != "")) $("#TRStartTime").timespinner("setValue", TRArr[1]);
        else $("#TRStartTime").timespinner("setValue", SessArr[3]);
        if ((TRArr[2] != undefined) && (TRArr[2] != "")) $("#TREndTime").timespinner("setValue", TRArr[2]);
        else $("#TREndTime").timespinner("setValue", SessArr[4]);

        if (TRArr[3] != undefined) $("#TRLength").numberbox('setValue', TRArr[3]);
        else $("#TRLength").numberbox('setValue', "");
        if (TRArr[4] != undefined) $("#TRRegNum").numberbox('setValue', TRArr[4]);
        else $("#TRRegNum").numberbox('setValue', "");
        if (TRArr[5] != undefined) $("#TRRegNumStr").val(TRArr[5]);
        else $("#TRRegNumStr").val("");
        if (TRArr[6] != undefined) $("#TRRegInfoStr").val(TRArr[6]);
        else $("#TRRegInfoStr").val("");
        var onCheckChange = $("#TRFlag").checkbox('options').onCheckChange;
        $("#TRFlag").checkbox('options').onCheckChange = function () { }
        var TRFlag = TRArr[0];
        if (TRFlag == "Y") {
            $('#TRFlag').checkbox('check');
        } else {
            $('#TRFlag').checkbox('uncheck');
        }
        $("#TRFlag").checkbox('options').onCheckChange = onCheckChange;
        /*setTimeout(function(){
            var TRFlag=TRArr[0];
            if(TRFlag=="Y"){
                $('#TRFlag').checkbox('check');
            }else{
                $('#TRFlag').checkbox('uncheck');
            }
        },700);*/
    } else {
        $("#ApptMax,#PositiveMax,#AddtionMax,#EStartPrefix,#TRLength,#TRRegNum").numberbox('setValue', '');
        $("#DayOfWeek,#TimeRange,#DocSession,#LocArea,#ClinicGroup").combobox("setValue", '').combobox("setText", '');
        $('#ScheduleGenerFlag').checkbox('check');
        $('#TRFlag').checkbox('uncheck');
        TRFlag_Click();
        $("#TRStartTime,#TREndTime").timespinner("setValue", "");
        $("#TRRegNumStr,#TRRegInfoStr").val("");
    }
    return RetData;
}
function TRFlag_Click() {
    if ($("#TRFlag").checkbox('getValue')) {
        $('#pTREdit').show();
        $("#tabTRInfo,#tabTRAppMethodInfo").datagrid("resize");
        var data = GetElementValue('tabTRInfo');
        if (!data.length) {
            var SessRowid = ""
            var tab = $('#tabTimeRange').tabs('getSelected');
            if (!tab) return;
            var index = $('#tabTimeRange').tabs('getTabIndex', tab);
            var tab = $('#tabTimeRange').tabs('getTab', index);
            var SessRowid = tab[0].id;
            $('#TRGenWin').window('open');
            var TRASLoad = $.cm({
                ClassName: 'DHCDoc.OPAdm.ScheduleTemp',
                MethodName: 'GetTRASLoad',
                SessRowid: SessRowid,
                dataType: "text"
            }, false);
            $('#TRTemp').singleCombo({
                valueField: 'ID',
                textField: 'Name',
                ClassName: 'DHCDoc.OPAdm.TimeRangeTemp',
                QueryName: 'QueryTemp',
                loadFilter: function (data) {
                    for (var i = 0; i < data.length; i++) {
                        data[i].Name = data[i].TimeRange + "-" + data[i].Name;
                    }
                    return data;
                },
                onBeforeLoad: function (param) {
                    param.TRRowid = $("#TimeRange").combobox('getValue'); //GetElementValue('TimeRange');
                    param.SumLoad = TRASLoad;
                    param.HospID = $HUI.combogrid('#_HospUserList').getValue();
                }
            });

            SetElementValue('TRASLoad', TRASLoad);
            SetElementValue('IntervalTime', "");
            GenWayChecked();
        }
        /*$("#TRStartTime,#TREndTime").timespinner("enable");
        $('#TRLength,#TRRegNum').numberbox('enable');
        $('#TRRegNumStr,#TRRegInfoStr').attr('disabled',false);*/
    } else {
        $('#pTREdit').hide();
        $('#ASLoad').numberbox('enable');
        /*$("#TRStartTime,#TREndTime").timespinner("disable");
        $('#TRLength,#TRRegNum').numberbox('setValue','').numberbox('disable');
        $('#TRRegNumStr,#TRRegInfoStr').val('').attr('disabled',true);*/

    }
}
function SetDocList(LocID, ID) {
    var url = PageLogicObj.m_ComboJsonCSP + '?ClassName=' + PageLogicObj.m_ClassName + '&QueryName=QueryDocList';
    url += "&Arg1=" + LocID + '&ArgCnt=' + 1;
    $("#" + ID).combobox('setValue', '');
    $("#" + ID).combobox('reload', url);
}
function InitAppQtyList() {

    var Cloumns = [[
        { field: 'AQRowId', hidden: true },
        { field: 'AQMethodDR', hidden: true },
        {
            field: 'AQMethod', title: 'ԤԼ��ʽ', align: 'center', width: 180, resizable: true,
            editor: {
                type: 'combobox', options: {
                    editable: false,
                    panelHeight: 'auto',
                    valueField: 'Rowid',
                    textField: 'Desc',
                    required: true,
                    data: APTMArr,
                    loadFilter: function (data) {
                        var rows = $('#tabAppQtyList').datagrid('getRows');
                        var AQMStr = "^"
                        for (var i = 0; i < rows.length; i++) {
                            if (EditRow == i) continue;
                            var AQMethodDR = rows[i].AQMethodDR;
                            if (AQMethodDR) {
                                AQMStr += AQMethodDR + "^";
                            }
                        }
                        if (AQMStr == "^") return data;
                        var newData = new Array();
                        for (var i in data) {
                            if (AQMStr.indexOf("^" + data[i].Rowid + "^") == -1) {
                                newData[newData.length] = data[i];
                            }
                        }
                        return newData;
                    },
                    onLoadSuccess: function (data) {
                        var rows = $('#tabAppQtyList').datagrid('getRows');
                        if (rows[EditRow].AQMethodDR)
                            $(this).combobox('setValue', rows[EditRow].AQMethodDR);
                    },
                    onSelect: function (record) {
                        if (record != undefined) {
                            var rows = $('#tabAppQtyList').datagrid("selectRow", EditRow).datagrid("getSelected");
                            rows['AQMethodDR'] = record['Rowid'];
                            rows['AQMethod'] = record['Desc'];
                        }
                    },
                    onChange: function (newValue, oldValue) {
                        if (newValue == "") {
                            var rows = $('#tabAppQtyList').datagrid("selectRow", EditRow).datagrid("getSelected");
                            rows['AQMethodDR'] = "";
                        }
                    }
                }
            }
        },
        {
            field: 'AQStartNum', title: '��ʼ��', align: 'center', width: 100, resizable: true,
            editor: {
                type: 'numberbox',
                options: {
                    required: true,
                    onChange: function (newValue, oldValue) {
                        if (newValue > 0) {
                            var editors = $('#tabAppQtyList').datagrid('getEditors', EditRow);
                            var AppQty = editors[2].target.val();
                            var AppStartNum = newValue;
                            $($("#datagrid-row-r2-2-" + EditRow + " td")[8]).children(0)[0].innerHTML = (+AppQty) + (+AppStartNum) - 1;
                        }
                    }
                },
            },
        },
        {
            field: 'AQQty', title: '����', align: 'center', width: 100, resizable: true,
            editor: {
                type: 'numberbox',
                options: {
                    required: true,
                    onChange: function (newValue, oldValue) {
                        if (newValue > 0) {
                            var editors = $('#tabAppQtyList').datagrid('getEditors', EditRow);
                            var AppQty = newValue;
                            var AppStartNum = editors[1].target.val();
                            $($("#datagrid-row-r2-2-" + EditRow + " td")[8]).children(0)[0].innerHTML = (+AppQty) + (+AppStartNum) - 1;
                        }
                    }
                },
            },
        },
        {
            field: 'AppEndNum', title: '������', align: 'center', width: 100,
            formatter: function (value, row, index) {
                return (+row['AQQty']) + (+row['AQStartNum']) - 1;
            }
        }

    ]];
    var ToolBar = [{
        iconCls: 'icon-add',
        text: '����',
        handler: function () {
            var tab = $('#tabTimeRange').tabs('getSelected');
            if (!tab) {
                $.messager.alert('��ʾ', '���ȱ���ģ����ٱ༭ԤԼ��ʽ�޶�');
                return;
            }
            if (EditRow != -1) {
                //if(!$('#tabAppQtyList').datagrid('validateRow',EditRow)){
                $.messager.alert('��ʾ', '�����ڱ༭�����뱣�������!');
                return false;
                //}
            }
            var tab = $('#tabTimeRange').tabs('getSelected');
            var index = $('#tabTimeRange').tabs('getTabIndex', tab);
            var tab = $('#tabTimeRange').tabs('getTab', index);
            var SessRowid = tab[0].id;
            if (!SessRowid) return;
            $('#tabAppQtyList').datagrid('appendRow', {});
            var rowArr = $('#tabAppQtyList').datagrid('getRows');
            var rowIndex = rowArr.length - 1;
            $('#tabAppQtyList').datagrid("beginEdit", rowIndex);
            $($("#datagrid-row-r2-2-" + EditRow + " td")[8]).children(0)[0].innerHTML = '';
        }
    }, {
        iconCls: 'icon-cancel',
        text: 'ɾ��',
        handler: function () {
            var row = $('#tabAppQtyList').datagrid('getSelected');
            if (!row) {
                $.messager.alert('��ʾ', '��ѡ����Ҫɾ������');
                return false;
            }
            $.messager.confirm("��ʾ", "�Ƿ�ɾ����ԤԼ��ʽ�޶�?", function (data) {
                if (data) {
                    var AQRowId = row.AQRowId;
                    if (AQRowId) {
                        var ret = tkMakeServerCall('web.DHCRBResEffDateSessAppQty', 'Delete', AQRowId);
                        if (ret == 0) {
                            $.messager.popover({ msg: 'ɾ���ɹ�!', type: 'success' });
                        } else {
                            $.messager.alert('��ʾ', 'ɾ��ʧ��:' + ret);
                            return false;
                        }
                    }
                    var rowIndex = $('#tabAppQtyList').datagrid("getRowIndex", row);
                    $('#tabAppQtyList').datagrid("deleteRow", rowIndex);
                    if (EditRow > rowIndex) EditRow--;
                    else if (EditRow == rowIndex) EditRow = -1;
                    var AppQtySum = 0, minEStartPrefix = 0;
                    var rows = $('#tabAppQtyList').datagrid('getRows');
                    for (var i = 0; i < rows.length; i++) {
                        var oneAppQty = rows[i].AQQty;
                        var oneAppStartNum = rows[i].AQStartNum;
                        AppQtySum = AppQtySum + (+oneAppQty);
                        if (((+oneAppStartNum) < minEStartPrefix) || (minEStartPrefix == 0)) {
                            minEStartPrefix = oneAppStartNum;
                        }
                    }
                    $("#ApptMax").numberbox('setValue', AppQtySum);
                    $("#EStartPrefix").numberbox('setValue', minEStartPrefix);
                }
            });
        }
    }, {
        iconCls: 'icon-save',
        text: '����',
        handler: function () {
            if (EditRow != -1) {
                if (!$('#tabAppQtyList').datagrid('validateRow', EditRow)) {
                    $.messager.alert('��ʾ', '�༭����Ϣ������,���ܱ���');
                    return false;
                }
                var editors = $('#tabAppQtyList').datagrid('getEditors', EditRow);
                var row = $('#tabAppQtyList').datagrid("selectRow", EditRow).datagrid("getSelected");
                var AQMethodDR = row['AQMethodDR'];
                var AQQty = editors[2].target.val();
                var AQStartNum = editors[1].target.val();
                var AQRowId = row['AQRowId'];
                if (AQRowId == undefined) { AQRowId = ""; }
                var tab = $('#tabTimeRange').tabs('getSelected');
                var index = $('#tabTimeRange').tabs('getTabIndex', tab);
                var tab = $('#tabTimeRange').tabs('getTab', index);
                var SessRowid = tab[0].id;
                var AppQtySum = 0, minEStartPrefix = 0;
                var rows = $('#tabAppQtyList').datagrid('getRows');
                for (var i = 0; i < rows.length; i++) {
                    var oneAppQty = rows[i].AQQty;
                    var oneAppStartNum = rows[i].AQStartNum;
                    if (i == EditRow) {
                        oneAppStartNum = AQStartNum;
                        oneAppQty = AQQty;
                        var r = /^[1-9]*[1-9][0-9]*$/
                        if (!r.test(oneAppStartNum)) {
                            $.messager.alert('��ʾ', "ԤԼ��ʼ��ֻ��Ϊ������!");
                            return false;
                        }
                        if (!r.test(oneAppQty)) {
                            $.messager.alert('��ʾ', "ԤԼ��ʽ����ֻ��Ϊ������!");
                            return false;
                        }
                        var AppEndNum = +$($("#datagrid-row-r2-2-" + i + " td")[8]).children(0)[0].innerHTML;
                    } else {
                        var AppEndNum = (+oneAppQty) + (+oneAppStartNum) - 1;
                    }
                    if (AppEndNum > (+PageLogicObj.m_ASLoad)) {
                        $.messager.alert("��ʾ", "ԤԼ��ʽ������" + AppEndNum + "���ܴ��������޶�:" + PageLogicObj.m_ASLoad + ",���޸�ԤԼ��ʼ�Ż�����!");
                        return false;
                    }
                    AppQtySum = AppQtySum + (+oneAppQty);
                    if (((+oneAppStartNum) < minEStartPrefix) || (minEStartPrefix == 0)) {
                        minEStartPrefix = oneAppStartNum;
                    }
                }
                if (!AQRowId) {
                    var tab = $('#tabTimeRange').tabs('getSelected');
                    if (!tab) {
                        $.messager.alert('��ʾ', '���ȱ���ģ����ٱ༭ԤԼ��ʽ�޶�');
                        return false;
                    }
                    var Para = AQMethodDR + "^" + AQQty + "^" + AQStartNum;
                    var ret = tkMakeServerCall('web.DHCRBResEffDateSessAppQty', 'Insert', SessRowid, Para);
                    var retArr = ret.split("^");
                    if (retArr[0] == 0) {
                        AQRowId = retArr[1];
                        $.messager.popover({ msg: '��ӳɹ�!', type: 'success' });
                        $("#ApptMax").numberbox('setValue', AppQtySum);
                        $("#EStartPrefix").numberbox('setValue', minEStartPrefix);
                    } else if (retArr[0] == "-201") {
                        $.messager.alert('��ʾ', '���ʧ��!ԤԼ�޶��������ܴ��������޶�!');
                        return false;
                    } else {
                        $.messager.alert('��ʾ', '���ʧ��:' + ret, "info", function () {
                            $('#tabAppQtyList').datagrid("beginEdit", EditRow);
                        });
                        return false;
                    }
                } else {
                    var Para = AQRowId + "^" + AQMethodDR + "^" + AQQty + "^" + AQStartNum;
                    var ret = tkMakeServerCall('web.DHCRBResEffDateSessAppQty', 'Update', Para);
                    if (ret == 0) {
                        $.messager.popover({ msg: '���³ɹ�!', type: 'success' });
                        $("#ApptMax").numberbox('setValue', AppQtySum);
                        $("#EStartPrefix").numberbox('setValue', minEStartPrefix);
                    } else if (retArr[0] == "-201") {
                        $.messager.alert('��ʾ', '����ʧ��!ԤԼ�޶��������ܴ��������޶�!');
                        return false;
                    } else {
                        $.messager.alert('��ʾ', '����ʧ��:' + ret);
                        return false;
                    }
                }
                $("#tabAppQtyList").datagrid('endEdit', EditRow);
                EditRow = -1;
                var AQMethod = "";
                for (var i = 0; i < APTMArr.length; i++) {
                    if (APTMArr[i].Rowid == AQMethodDR) {
                        AQMethod = APTMArr[i].Desc;
                        break;
                    }
                }
                $('#tabAppQtyList').datagrid('unselectAll');
                $('#tabAppQtyList').datagrid('load', {
                    ClassName: 'web.DHCRBResEffDateSessAppQty',
                    QueryName: 'GetSessAppQtys',
                    Arg1: SessRowid,
                    ArgCnt: 1
                });
                return true;
            }
        }
    }];
    var tabAppQtyListDataGrid = $('#tabAppQtyList').datagrid({
        idField: 'AQRowId',
        border: false,
        singleSelect: true,
        columns: Cloumns,
        toolbar: ToolBar,
        fit: true,
        fitColumns: true,
        pagination: false,
        striped: true,
        url: PageLogicObj.m_GridJsonCSP,
        onDblClickRow: function (rowIndex, rowData) {
            $('#tabAppQtyList').datagrid('beginEdit', rowIndex);
            if (rowData['AQMethodDR'] != "") {
                var et = $('#tabAppQtyList').datagrid('getEditor', { index: rowIndex, field: 'AQMethod' });
                if (et) $(et.target).combobox('disable');// ֻ��
            }
        },
        onBeforeEdit: function (rowIndex, rowData) {
            if (EditRow != -1) {
                //if(!$('#tabAppQtyList').datagrid('validateRow',EditRow)){
                $.messager.alert('��ʾ', '�����ڱ༭�����뱣�������!');
                return false;
                //}
                $('#tabAppQtyList').datagrid('endEdit', EditRow);
            }
            EditRow = rowIndex;
        },
        onAfterEdit: function (rowIndex, rowData, changes) {
        },
        onLoadSuccess: function (data) {
            $('#tabAppQtyList').datagrid('unselectAll');
            EditRow = -1;
        }
    });
    return tabAppQtyListDataGrid;
}
function InitSingleCombo(id, valueField, textField, Query, multipleField, ClassName) {
    if ((typeof (multipleField) == "undefined") || (multipleField == "")) {
        multipleField = false
    }
    if (typeof (ClassName) == "undefined") ClassName = "";
    var HospID = $HUI.combogrid('#_HospUserList').getValue();
    var ComboObj = {
        editable: true,
        panelHeight: 200,
        multiple: multipleField,
        mode: "local",
        method: "GET",
        valueField: valueField,
        textField: textField,
        url: $URL + '?ClassName=' + (ClassName == "" ? PageLogicObj.m_ClassName : ClassName) + '&QueryName=' + Query + '&HospId=' + HospID + "&HospID=" + HospID + '&ResultSetType=array',
        filter: function (q, row) {
            var opts = $(this).combobox('options');
            return (row[opts.textField].toUpperCase().indexOf(q.toUpperCase()) >= 0) || (row['code'].toUpperCase().indexOf(q.toUpperCase()) >= 0);
        }
    };
    if (id == "AdmLoc") {
        $.extend(ComboObj, {
            onSelect: function (record) {
                if (record != undefined) {
                    $("#ClinicGroup").combobox("select", '');
                    SetDocList(record.rowid, "AdmDoc");
                    LoadClinicGroup(record.rowid, "ClinicGroup");
                    LoadLocArea(record.rowid, "LocArea");
                }
            }
        });
    } else if (id == "AdmDoc") {
        $.extend(ComboObj, {
            onSelect: function (record) {
                if (record != undefined) {
                    var sessTypeDr = tkMakeServerCall("web.DhcResEffDateSessionClass", "GetSessTypeByDocId", record['rowid'], $("#AdmLoc").combobox("getValue"));
                    if (sessTypeDr != "") {
                        $("#DocSession").combobox("select", sessTypeDr.toString());
                    }
                    DocSelectFun();
                }
            }
        });
    } else if (id == "Loc_Search") {
        $.extend(ComboObj, {
            onSelect: function (record) {
                SetDocList(record.rowid, "Doc_Search");
                $('#ScheduleTemplateList').datagrid('reload');
            }
        });
    } else if (id == "Doc_Search") {
        $.extend(ComboObj, {
            onSelect: function (record) {
                $('#ScheduleTemplateList').datagrid('reload');
            }
        });
    } else if (id == "Zone_Search") {
        $.extend(ComboObj, {
            onSelect: function (record) {
                if (record != undefined) {
                    SetLocList(record.rowid, "Loc_Search");
                    SetDocList("", "Doc_Search");
                    $('#ScheduleTemplateList').datagrid('reload');
                }
            },
            onChange: function (newValue, oldValue) {
                if (newValue == "") {
                    SetLocList("", "Loc_Search");
                    SetDocList("", "Doc_Search");
                    $('#ScheduleTemplateList').datagrid('reload');
                }
            }
        });
    } else if (id == "TimeRange") {
        $.extend(ComboObj, {
            editable: false,
            onSelect: function (record) {
                if (record != undefined) {
                    var TRStr = TRArr[record.TRRowid];
                    $("#TRStartTime").timespinner("setValue", TRStr.split("^")[0]);
                    $("#TREndTime").timespinner("setValue", TRStr.split("^")[1]);
                    DocSelectFun();
                }
            }
        });
    } else if (id == "ScheduleLines_Search") {
        $.extend(ComboObj, {
            editable: false,
            onSelect: function (record) {
                if (PageLogicObj.m_ScheduleTemplateListDataGrid == "") {
                    PageLogicObj.m_ScheduleTemplateListDataGrid = InitScheduleTemplateListDataGrid();
                } else {
                    $('#ScheduleTemplateList').datagrid('reload');
                }
            },
            onLoadSuccess: function () {
                var data = $("#ScheduleLines_Search").combobox('getData');
                if (data.length > 0) {
                    var DefaultRowid = "";
                    for (var i = 0; i < data.length; i++) {
                        if (data[i]['Default'] == "Y") {
                            DefaultRowid = data[i]['RSLRowId'];
                            break;
                        }
                    }
                    if (DefaultRowid == "") DefaultRowid = data[0]['RSLRowId'];
                    $("#ScheduleLines_Search").combobox('select', DefaultRowid);
                }
            }
        });
    } else if (id == "ClinicGroup") {
        $.extend(ComboObj, {
            rowStyle: 'checkbox', //��ʾ�ɹ�ѡ����ʽ
            selectOnNavigation: false,
            editable: false,
        });
    }
    $("#" + id).combobox(ComboObj);
}
function InitDOWTabs() {
    $('#tabWeek').tabs({
        selected: '',
        tabWidth: '90px',
        onSelect: function (title, index) {
            $('#tabTimeRange').tabs({
                onSelect: function () {
                }
            });
            ClearTabs('tabTimeRange');
            InitTRTabs();
            var tab = $(this).tabs('getTab', index);
            var id = tab[0].id;
            var TRArr = id.split("#");
            for (var i = 0; i < TRArr.length; i++) {
                var tabTRObj = { id: TRArr[i].split("@")[1], title: TRArr[i].split("@")[0], closable: false, selected: false };
                if (PageLogicObj.m_SelectTimeRange == tabTRObj.title) $.extend(tabTRObj, { selected: true });
                else if ((i == 0) && (PageLogicObj.m_SelectTimeRange == "")) $.extend(tabTRObj, { selected: true });
                $('#tabTimeRange').tabs('add', tabTRObj);
            }
            var selTab = $('#tabTimeRange').tabs('getSelected');
            if (!selTab) {
                var tabs = $('#tabTimeRange').tabs('tabs');
                if (tabs.length > 0) {
                    $('#tabTimeRange').tabs('select', 0);
                }
            }
        },
        onContextMenu: function (e, title, index) {
            e.preventDefault(); //��ֹ����������Ҽ��¼�
            $('#mm-week').menu('show', {
                left: e.pageX,
                top: e.pageY,
            });
        }

    });
}
function InitTRTabs() {
    $('#tabTimeRange').tabs({
        selected: '',
        //tabWidth:'100px',
        onSelect: function (title, index) {
            var tab = $(this).tabs('getTab', index);
            var SessRowid = tab[0].id;
            clearTimeout(PageLogicObj.m_LoadSessTimer);	//����ÿ��tab��ʼ���ظ�����
            PageLogicObj.m_LoadSessTimer = setTimeout(function () { SetResSessData(SessRowid) }, 50);
            setTimeout(function () {
                LoadApptabAppMethodInfo(SessRowid);
                LoadtabTRInfo(SessRowid);
            }, 500);
        }
    });
}
function DeleteSessByWeek() {
    var tabweek = $('#tabWeek').tabs('getSelected');
    var week = tabweek.panel("options").title;
    var index = $('#tabWeek').tabs('getTabIndex', tabweek);
    $.messager.confirm("��ʾ", "�Ƿ�ɾ�� <font color='red'>" + week + "</font> ������ʱ�ε�ģ��?", function (data) {
        if (data) {
            var tabs = $('#tabTimeRange').tabs('tabs');
            for (var i = 0; i < tabs.length; i++) {
                var SessRowid = tabs[i][0].id;
                var ret = tkMakeServerCall("web.DHCRBResSession", "Delete", SessRowid);
            }
            if (ret == '0') {
                $.messager.popover({ msg: 'ɾ���ɹ�!', type: 'success' });
                $('#tabWeek').tabs('close', index);
            }
        }
    });
}
function DeleteSess() {
    $.messager.defaults = { ok: "��", cancel: "��" };
    var tab = $('#tabTimeRange').tabs('getSelected');
    var TimeRange = tab.panel("options").title;
    var tabweek = $('#tabWeek').tabs('getSelected');
    var week = tabweek.panel("options").title;
    $.messager.confirm("��ʾ", "�Ƿ�ɾ�� <font color='red'>" + week + " " + TimeRange + "</font> ��ģ��?", function (data) {
        if (data) {
            var tab = $('#tabTimeRange').tabs('getSelected');
            var SessRowid = tab[0].id;
            var ret = tkMakeServerCall("web.DHCRBResSession", "Delete", SessRowid);
            if (ret == '0') {
                $.messager.popover({ msg: 'ɾ���ɹ�!', type: 'success' });
                var index = $('#tabTimeRange').tabs('getTabIndex', tab);
                $('#tabTimeRange').tabs('close', index);
                var tab = $('#tabTimeRange').tabs('getSelected');
                if (!tab) {
                    var tab = $('#tabWeek').tabs('getSelected');
                    var index = $('#tabWeek').tabs('getTabIndex', tab);
                    $('#tabWeek').tabs('close', index);
                }
            } else {
                $.messager.alert("��ʾ", "ɾ��ʧ��:" + ret);
            }
        }
    });
}
function Calc_TRInfo() {
    var TRStartTime = $("#TRStartTime").timespinner('getValue');
    var TREndTime = $("#TREndTime").timespinner('getValue');
    var TRLength = $("#TRLength").numberbox('getValue');
    var TRRegNum = $("#TRRegNum").numberbox('getValue');
    var TRStartNum = $("#EStartPrefix").numberbox('getValue');
    if ((TRStartTime != "") && (TREndTime != "") && (TRLength != "") && (TRRegNum != "") && (TRStartNum != "")) {
        return TRInfoCalculate(TRStartTime, TREndTime, TRLength, TRRegNum, TRStartNum);
    }
    return true;
}
function TRInfoCalculate(TRStartTime, TREndTime, TRLength, TRRegNum, TRStartNum) {
    if (TRStartTime == "") {
        $.messager.alert('��ʾ', "��ʱ�ο�ʼʱ���ʽ����ȷ")
        return false;
    }
    if (TREndTime == "") {
        $.messager.alert('��ʾ', "��ʱ�ν���ʱ���ʽ����ȷ")
        return false;
    }

    if ((TRLength == "") || (TRLength < 0)) {
        $.messager.alert('��ʾ', "��ʱ��ʱ������ʽ����ȷ")
        return false;
    }

    if ((TRRegNum == "") || (TRRegNum < 0)) {
        $.messager.alert('��ʾ', "��ʱ�κ�Դ������ʽ����ȷ")
        return false;
    }

    /*if ((TRStartNum=="")||(TRStartNum<0)){
        $.messager.alert('��ʾ', "ԤԼ��ʼ�Ÿ�ʽ����ȷ")
        return false;
    }*/
    var ret = tkMakeServerCall("web.DHCRBResSession", "TRInfoCalculate", TRStartTime, TREndTime, TRLength, TRRegNum)
    var arr = ret.split("^");
    if (arr[0] != "0") {
        $.messager.alert('��ʾ', arr[1]);
        return false;
    } else {
        $("#TRRegNumStr").val(arr[1]);
        $("#TRRegInfoStr").val(arr[2]);
        return true;
    }
    return true;
}
function PrintScheduleClick(ResultSetTypeDo) //path
{
    $cm({
        localDir: ResultSetTypeDo == "Export" ? "Self" : "",
        ResultSetType: "ExcelPlugin",
        ResultSetTypeDo: ResultSetTypeDo,    //Ĭ��Export����������Ϊ��Print
        ExcelName: "�Ű��¼",				 //Ĭ��DHCCExcel
        ClassName: PageLogicObj.m_ClassName,
        QueryName: "FindScheduleTempExport",
        LocRowid: $("#Loc_Search").combobox('getValue'),
        UserRowid: session['LOGON.USERID'],
        DocRowid: $("#Doc_Search").combobox('getValue'),
        ZoneID: $("#Zone_Search").combobox('getValue'),
        ScheduleLinesRowId: $("#ScheduleLines_Search").combobox('getValue'),
        ILocDesc: "",
        IDocDesc: "",
        HospId: $HUI.combogrid('#_HospUserList').getValue(),
        rows: 99999
    }, false);
    /*$.ajax({
        type: 'POST',
        url : PageLogicObj.m_GridJsonCSP,
        data: {
            ClassName:PageLogicObj.m_ClassName,
            QueryName:PageLogicObj.m_QueryName,
            Arg1:$("#Loc_Search").combobox('getValue'),
            Arg2:session['LOGON.USERID'],
            Arg3:$("#Doc_Search").combobox('getValue'),
            Arg4:$("#Zone_Search").combobox('getValue'),
            Arg5:$("#ScheduleLines_Search").combobox('getValue'),
            ArgCnt:5
        },
        dataType: 'json',
        success: function(data, textStatus, jqXHR){
            try{
                var rowArr=data.rows;
                if(rowArr.length==0) return;
                var ServerPath=tkMakeServerCall('web.UDHCJFCOMMON','getpath');
                var Templatefilepath=ServerPath+"DHCSchedulePrint.xls";
                xlApp = new ActiveXObject("Excel.Application");  //�̶�
                xlBook = xlApp.Workbooks.Add(Templatefilepath);  //�̶�
                xlsheet = xlBook.WorkSheets("Sheet1");     //Excel�±������
                var columns=$('#ScheduleTemplateList').datagrid('options').columns[0];
                for(var i=0;i<rowArr.length;i++){
                    for(var j=0;j<columns.length;j++){
                        if(columns[j].hidden) continue;
                        if(i==0) xlsheet.cells(i+1,j+1)=columns[j].title;
                        var cmd="var val=rowArr[i]."+columns[j].field
                        eval(cmd);
                        if(columns[j].formatter) val=columns[j].formatter(val);
                        xlsheet.cells(i+2,j+1)=val;
                    }
                }
                MergeExcelCell(xlsheet,2,1,2,rowArr.length+1);
                if(path){
                    path+="\\�Ű��¼.xls"
                    xlsheet.SaveAs(path);
                    $.messager.popover({msg: '�����ɹ�!',type:'success'});
                }else{
                    xlsheet.PrintOut();
                    $.messager.popover({msg: '��ӡ�ɹ�!',type:'success'});
                }
                xlBook.Close(savechanges=false);
                xlApp.Quit();
            }catch(e){
                alert(e.message);
            }
            CollectGarbage();
        }
      });*/
}
function MergeExcelCell(xlsheet, TotalCols, CurrentCol, StartRow, EndRow) {
    var ColName = String.fromCharCode(64 + CurrentCol);
    var OldVal = "", OldRow = StartRow;
    for (var i = StartRow; i <= EndRow; i++) {
        var CellVal = xlsheet.cells(i, CurrentCol).Value;
        if (((i - OldRow) > 1) && ((OldVal != CellVal) || ((i == EndRow) && (CellVal == OldVal)))) {
            var row = i - 1;
            if (i == EndRow) row = i;
            xlsheet.Cells(row, CurrentCol).ClearContents;
            xlsheet.Range(ColName + OldRow + ":" + ColName + row).MergeCells = true;
            var NewCol = CurrentCol + 1;
            if (NewCol <= TotalCols)
                MergeExcelCell(xlsheet, TotalCols, NewCol, OldRow, row);
            OldVal = CellVal, OldRow = i;
        } else {
            if (CellVal != OldVal) OldRow = i, OldVal = CellVal;
            else xlsheet.Cells(i, CurrentCol).ClearContents;
        }
    }
}
function BrowseFolder() {
    try {
        var Message = "��ѡ���ļ���";  //ѡ�����ʾ��Ϣ
        var Shell = new ActiveXObject("Shell.Application");
        //var Folder = Shell.BrowseForFolder(0,Message,0x0040,0x11);//��ʼĿ¼Ϊ���ҵĵ���
        var Folder = Shell.BrowseForFolder(0, Message, 0); //��ʼĿ¼Ϊ������
        if (Folder != null) {
            //Folder = Folder.items();  // ���� FolderItems ����
            Folder = Folder.Self.Path;   // ����·��
            return Folder;
        }
    } catch (e) {
        alert(e.message);
    }
}
function SaveClick(Type, CopyFromTimeRange) {
    if (!CheckBeforeSave()) return false;
    var AdmLoc = getValue("AdmLoc");
    var AdmDoc = $("#AdmDoc").combobox("getValue");
    var ApptMax = $("#ApptMax").numberbox('getValue');
    var DOW = getValue("DayOfWeek");
    var TimeRange = getValue("TimeRange");
    var Load = $("#PositiveMax").numberbox('getValue');
    var SessType = getValue("DocSession");
    var AddtionMax = $("#AddtionMax").numberbox('getValue');
    var Room = getValue("LocArea");;
    var AppStartNo = $("#EStartPrefix").numberbox('getValue');
    var ClinicGroup = getValue("ClinicGroup");
    var GenerFlag = "N";
    if ($("#ScheduleGenerFlag").checkbox('getValue')) GenerFlag = "Y";

    var TRStartTime = $("#TRStartTime").timespinner('getValue');
    var TREndTime = $("#TREndTime").timespinner('getValue');
    var TRLength = "" //$("#TRLength").numberbox('getValue');
    var TRRegNum = "" //$("#TRRegNum").numberbox('getValue');
    var TRStartNum = "" //$("#EStartPrefix").numberbox('getValue');

    var SessNoSlots = parseInt(Load) - parseInt(ApptMax);
    var SessPatientType = "O";
    var AutoLoad = "";
    var ExtLoad = "";

    var TRFlag = "N";
    if ($("#TRFlag").checkbox('getValue')) {
        TRFlag = "Y";
        //if(!TRInfoCalculate(TRStartTime,TREndTime,TRLength,TRRegNum,TRStartNum))
        //return false;
    }
    var TRRegNumStr = ""; $("#TRRegNumStr").val();
    var TRRegInfoStr = ""; $("#TRRegInfoStr").val();
    if ((Type == "Add") || (Type == "CopyAdd")) {
        var ScheduleLinesRowId = $("#ScheduleLines_Search").combobox('getValue');
        var SameSess = tkMakeServerCall(PageLogicObj.m_ClassName, "CheckBeforeSaveSess", "", AdmLoc, AdmDoc, DOW, TimeRange, ScheduleLinesRowId);
        if (SameSess.split("^")[0] != '0') {
            $.messager.alert('��ʾ', SameSess.split("^")[1]);
            return false;
        }
        /*if (Type=="Add"){
            var ApptMax=""; 
            var AppStartNo="";
        }*/
        var InsertData = "" + "^" + DOW + "^" + TRStartTime + "^" + TREndTime + "^^" + Load + "^" + SessNoSlots + "^" + ApptMax;
        InsertData = InsertData + "^" + AppStartNo + "^" + AddtionMax + "^" + Room + "^" + SessType + "^" + ClinicGroup + "^" + SessPatientType + "^" + TimeRange + "^" + GenerFlag;
        InsertData = InsertData + "^" + TRFlag + "^" + "" + "^" + "" + "^" + TRLength + "^" + TRRegNum + "^" + TRRegNumStr + "^" + TRRegInfoStr + "^" + AutoLoad + "^" + ExtLoad
        var ResDateRet = tkMakeServerCall(PageLogicObj.m_ClassName, "GetDocDateRowid", AdmLoc, AdmDoc, ScheduleLinesRowId)
        if (ResDateRet.split("^")[0] != "0") {
            $.messager.alert('��ʾ', ResDateRet.split("^")[1]);
            return false;
        }
        var ResDateRowid = ResDateRet.split("^")[1];
        var ret1 = tkMakeServerCall("web.DHCRBResSession", "Insert", ResDateRowid, InsertData);
        var temparr = ret1.split("^");
        var retCode = temparr[0];
        if (retCode == 0) {
            var SessRowId = temparr[1];
            var Info = '����ģ��ɹ�!'
            if (temparr[2] != "") {
                Info += '<font color=red>ͬʱ��ͬ���������Ű�ģ��' + ":" + temparr[2] + '</font>';
                $.messager.alert('��ʾ', Info);
                //return false;
            } else {
                $.messager.popover({ msg: Info, type: 'success' });
                var ClickType = $("input[name='ClickType']:checked").val();
                if ((ClickType == 3) && (Type == "CopyAdd")) {
                    var paraString = "";
                    /*var rows=$('#tabAppQtyList').datagrid('getRows');
                    for(var i=0;i<rows.length;i++){
                        var AppQty =rows[i].AQQty;
                        var AppStartNum =rows[i].AQStartNum;
                        var ApptMethodDr =rows[i].AQMethodDR;
                        if(paraString=="") paraString=SessRowId+"^"+ApptMethodDr+"^"+AppQty+"^"+AppStartNum;
                            else paraString=paraString+","+SessRowId+"^"+ApptMethodDr+"^"+AppQty+"^"+AppStartNum;
                    }
                    if (paraString!=""){
                        var retcode = tkMakeServerCall("web.DHCRBResEffDateSessAppQty","SaveScheduleAppQty",paraString);
                        if(retcode!=0){
                              $.messager.alert('��ʾ', "����ԤԼ��ʽ�޶�ʧ��!"+retcode);
                        }
                    }*/
                    ScheduleObj = GetElementValue('tabAppMethodInfo');
                    var retJson = $.cm({
                        ClassName: 'DHCDoc.OPAdm.ScheduleTemp',
                        MethodName: 'SaveTempAppMethodNew',
                        SessRowid: SessRowId,
                        AMObjStr: JSON.stringify(ScheduleObj),
                        dataType: "json"
                    }, false);
                    //�Ű�ģ�帴��ʱ�����Ƶ�ʱ����ͬʱ���Ʒ�ʱ����Ϣ
                    if (TimeRange == CopyFromTimeRange) {
                        ScheduleObj1 = GetElementValue('tabTRInfo');
                        var retJson = $.cm({
                            ClassName: 'DHCDoc.OPAdm.ScheduleTemp',
                            MethodName: 'SaveTempTRNew',
                            SessRowid: SessRowId,
                            TRInfoObjStr: JSON.stringify(ScheduleObj1),
                            dataType: "json"
                        }, false);
                    }
                    return SessRowId;
                }
            }
        } else {
            if (retcode == "-201") {
                $.messager.alert('��ʾ', 'ͬʱ��ͬ���������Ű�ģ��' + ":" + temparr[1]);
            } else {
                $.messager.alert('��ʾ', '�����Ű�ģ��ʧ��');
            }
            return false;
        }
    } else if (Type == "Update") {
        var tab = $('#tabTimeRange').tabs('getSelected');
        var ASRowID = tab[0].id;
        var SameSess = tkMakeServerCall(PageLogicObj.m_ClassName, "CheckBeforeSaveSess", ASRowID, "", "", DOW, TimeRange);
        if (SameSess.split("^")[0] != '0') {
            $.messager.alert('��ʾ', SameSess.split("^")[1]);
            return false;
        }
        var ResDateRowid = ASRowID;
        var UpdateData = ASRowID + "^" + DOW + "^" + TRStartTime + "^" + TREndTime + "^^" + Load + "^" + SessNoSlots + "^" + ApptMax;
        UpdateData = UpdateData + "^" + AppStartNo + "^" + AddtionMax + "^" + Room + "^" + SessType + "^" + ClinicGroup + "^" + SessPatientType + "^" + TimeRange + "^" + GenerFlag;
        UpdateData = UpdateData + "^" + TRFlag + "^" + TRStartTime + "^" + TREndTime + "^" + TRLength + "^" + TRRegNum + "^" + TRRegNumStr + "^" + TRRegInfoStr + "^" + AutoLoad + "^" + ExtLoad
        var ret1 = tkMakeServerCall("web.DHCRBResSession", "Update", UpdateData);
        var temparr = ret1.split("^");
        var retcode = temparr[0];
        if (retcode == 0) {
            var Info = '����ģ��ɹ�!'
            if (temparr[1] != "") {
                Info += '<font color=red>ͬʱ��ͬ���������Ű�ģ��' + ":" + temparr[1] + '</font>';
            }
            $.messager.popover({ msg: Info, type: 'success' });
            //����ܺͲ����ڷ�ʱ���ܺ���Ҫ�������ɣ���ʱ������Ҫ��������
            if (TRFlag == "Y") {
                TRInfoTotal = 0
                var rows = $('#tabTRInfo').datagrid('getData').originalRows;
                for (var i = 0; i < rows.length; i++) {
                    var Editors = $('#tabTRInfo').datagrid('getEditors', i);
                    if (Editors.length) {
                        rows[i].Load = GetElementValue(Editors[0].target);
                    }
                    TRInfoTotal += Number(rows[i].Load);
                }
                if (parseFloat(TRInfoTotal) != parseFloat(Load)) {
                    var SessRowid = ""
                    var tab = $('#tabTimeRange').tabs('getSelected');
                    var index = $('#tabTimeRange').tabs('getTabIndex', tab);
                    var tab = $('#tabTimeRange').tabs('getTab', index);
                    var SessRowid = tab[0].id;
                    $('#TRGenWin').window('open');
                    var TRASLoad = $.cm({
                        ClassName: 'DHCDoc.OPAdm.ScheduleTemp',
                        MethodName: 'GetTRASLoad',
                        SessRowid: SessRowid,
                        dataType: "text"
                    }, false);
                    $('#TRTemp').singleCombo({
                        valueField: 'ID',
                        textField: 'Name',
                        ClassName: 'DHCDoc.OPAdm.TimeRangeTemp',
                        QueryName: 'QueryTemp',
                        loadFilter: function (data) {
                            for (var i = 0; i < data.length; i++) {
                                data[i].Name = data[i].TimeRange + "-" + data[i].Name;
                            }
                            return data;
                        },
                        onBeforeLoad: function (param) {
                            param.TRRowid = $("#TimeRange").combobox('getValue'); //GetElementValue('TimeRange');
                            param.SumLoad = TRASLoad;
                            param.HospID = $HUI.combogrid('#_HospUserList').getValue();
                        }
                    });

                    SetElementValue('TRASLoad', TRASLoad);
                    SetElementValue('IntervalTime', "");
                    //$("#TRASLoad").val(TRASLoad);
                    GenWayChecked()
                }
            }
        } else {
            if (retcode == "-201") {
                $.messager.alert('��ʾ', "ͬʱ��ͬ���������Ű�ģ��" + ":" + temparr[1]);
            } else {
                $.messager.alert('��ʾ', "�����Ű�ģ��ʧ��");
            }
            return false;
        }
    }
    var Week = $("#DayOfWeek").combobox("getText");
    var TimeRange = $("#TimeRange").combobox("getText");
    $("#BtnSaveSess,#BtnDeleteSess,#BtnAddSess,#tabWeek,#tabTimeRange").show();
    LoadWeekTabs(ResDateRowid, Week, TimeRange);
    return true;
}
function CheckBeforeSave() {
    var AdmLoc = getValue("AdmLoc");
    if (AdmLoc == '') {
        $.messager.alert('��ʾ', "��ѡ�������ң�", "info", function () {
            $('#AdmLoc').next('span').find('input').focus();
        });
        return false;
    }
    var AdmDoc = $("#AdmDoc").combobox("getValue");
    if (AdmDoc == '') {
        $.messager.alert('��ʾ', "��ѡ�����ҽ����", "info", function () {
            $('#AdmDoc').next('span').find('input').focus();
        });
        return false;
    }
    var TimeRange = getValue("TimeRange"); //$("#TimeRange").combogrid("getValue");	
    if (TimeRange == '') {
        $.messager.alert('��ʾ', "��ѡ�����ʱ�Σ�", "info", function () {
            $('#TimeRange').next('span').find('input').focus();
        });
        return false;
    }
    var EPositiveMax = $("#PositiveMax").numberbox('getValue');//�����޶�
    var EApptMax = $("#ApptMax").numberbox('getValue');			//ԤԼ�޶�
    var EAddtionMax = $("#AddtionMax").numberbox('getValue');		//�Ӻ��޶�
    var EStartPrefix = $("#EStartPrefix").numberbox('getValue');	//ԤԼ��ʼ��
    var ESessionType = getValue("DocSession"); //$("#DocSession").combobox("getValue");
    if (ESessionType == '') {
        $.messager.alert('��ʾ', "��ѡ��Һ�ְ�ƣ� ", "info", function () {
            $('#DocSession').next('span').find('input').focus();
        });
        return false;
    }
    if (EPositiveMax == '') {
        $.messager.alert('��ʾ', "�����޶��Ϊ�գ� ");
        return false;
    }
    if ((EApptMax != "") && (+EStartPrefix == 0)) {
        $.messager.alert('��ʾ', "ԤԼ�޶Ϊ��ʱ,ԤԼ��ʼ�Ų���Ϊ��!", "info", function () {
            $("#EStartPrefix").focus();
        });
        return false;
    }
    if ((parseInt(EPositiveMax)) < (parseInt(EApptMax))) {
        $.messager.alert('��ʾ', "�����޶��С��ԤԼ�޶ ");
        return false;
    }
    if (parseInt(EApptMax) != 0) {
        if ((parseInt(EPositiveMax) - parseInt(EStartPrefix) + 1) < (parseInt(EApptMax))) {
            $.messager.alert('��ʾ', "�����޶��ȥԤԼ��ʼ��Ҫ���ڵ���ԤԼ�޶  ");
            return false;
        }
    }
    if (parseInt(EPositiveMax) > 999) {
        $.messager.alert('��ʾ', "�����޶�ܳ���999!");
        return false;
    }
    var rows = $('#tabAppMethodInfo').datagrid('getRows');
    var TotalQty = 0
    for (var i = 0; i < rows.length; i++) {
        var Editors = $('#tabAppMethodInfo').datagrid('getEditors', i);
        if (Editors.length) {
            rows[i].AppMethodID = GetElementValue(Editors[0].target);
            rows[i].AppMethod = $(Editors[0].target).combobox('getText');
            rows[i].MaxQty = GetElementValue(Editors[1].target);
            rows[i].ReserveQty = GetElementValue(Editors[2].target);
        }
        if (rows[i].AppMethodID) {
            TotalQty += Number(rows[i].ReserveQty);
            if (parseInt(TotalQty) > parseInt(EApptMax)) {
                $.messager.alert('��ʾ', 'ԤԼ��ʽ�����ϼ�:' + TotalQty + ',������ԤԼ��������:' + EApptMax);
                return false;
            }
            MaxQty = Number(rows[i].MaxQty)
            if (parseInt(MaxQty) > parseInt(EApptMax)) {
                $.messager.alert('��ʾ', 'ԤԼ��ʽ���ԤԼ�޶�:' + MaxQty + ',������ԤԼ��������:' + EApptMax);
                return false;
            }
        }
    }
    return true;
}
function DocSelectFun() {
    if ((!$('#AdmLoc').combobox('getValue')) || (!$('#AdmDoc').combobox('getValue'))) return false;
    var LocSelectedId = $('#AdmLoc').combobox('getValue');
    var DocSelectedId = $('#AdmDoc').combobox('getValue');
    var TimeRange = $("#TimeRange").combobox('getValue');
    if (PageLogicObj.m_AddFlag == 1) {
        var ret = tkMakeServerCall("web.DhcResEffDateSessionClass", "GetDataStrByDocIdAndLocId", DocSelectedId, LocSelectedId, TimeRange)
        var retArray = ret.split("^")
        var SessTypeDR = retArray[0]
        var RESLoad = retArray[1]
        var RESAppLoad = retArray[2]
        var RESAppStartNum = retArray[3]
        var RESAddLoad = retArray[4]
        var RESTRLength = retArray[5]
        var RESTRRegNum = retArray[6]
        var ClinicGroupDR = retArray[7]
        if ((TimeRange != "") && (retArray.length > 8)) {
            var ClinicGroupDR = retArray[9]
        }
        if (ClinicGroupDR == undefined) ClinicGroupDR = "";
        $("#PositiveMax").numberbox('setValue', RESLoad);
        PageLogicObj.m_ASLoad = RESLoad;
        $("#ApptMax").numberbox('setValue', RESAppLoad);
        $("#EStartPrefix").numberbox('setValue', RESAppStartNum);
        $("#AddtionMax").numberbox('setValue', RESAddLoad);
        $("#ClinicGroup").combobox("select", ClinicGroupDR.toString());
    }
}
function LoadClinicGroup(LocId, ID) {
    var url = PageLogicObj.m_ComboJsonCSP + '?ClassName=web.DHCRBResSession&QueryName=GetClinicGroupByLocNew';
    url += "&Arg1=" + LocId + '&Arg2=' + $HUI.combogrid('#_HospUserList').getValue() + '&ArgCnt=' + 2;
    $("#" + ID).combobox('setValue', '');
    $("#" + ID).combobox('reload', url);
}
function LoadLocArea(LocId, ID) {
    var url = PageLogicObj.m_ComboJsonCSP + '?ClassName=' + PageLogicObj.m_ClassName + '&QueryName=QueryRoom';
    url += "&Arg1=" + "&Arg2=" + session['LOGON.USERID'] + "&Arg3=" + LocId + '&ArgCnt=' + 3;
    $("#" + ID).combobox('setValue', '');
    $("#" + ID).combobox('reload', url);
}
function GenSche() {
    var ScheduleLinesRowId = $("#ScheduleLines_Search").combobox('getValue');
    var src = "opadm.schedulegen.hui.csp?ScheduleLinesRowId=" + ScheduleLinesRowId;
    var $code = "<iframe width='100%' height='100%' scrolling='auto' frameborder='0' src='" + src + "'></iframe>";
    createModalDialog("GenSche", "�����Ű�", "410", "700", "icon-w-edit", "", $code, "");
}
function getValue(id) {
    var className = $("#" + id).attr("class")
    if (typeof className == "undefined") {
        return $("#" + id).val()
    }
    if (className.indexOf("hisui-lookup") >= 0) {
        var txt = $("#" + id).lookup("getText")
        //����Ŵ��ı����ֵΪ��,�򷵻ؿ�ֵ
        if (txt != "") {
            var val = $("#" + id).val()
        } else {
            var val = ""
            $("#" + id + "Id").val("")
        }
        return val
    } else if (className.indexOf("hisui-combobox") >= 0) {
        var optobj = $("#" + id).combobox("options");
        var mulval = optobj.multiple;
        if (mulval) {
            var tmpval = new Array();
            var val = $("#" + id).combobox("getValues");
            for (var i = 0; i < val.length; i++) {
                if (val[i] != "") {
                    tmpval.push(val[i])
                }
            }
            val = tmpval.join(",");
        } else {
            var val = $("#" + id).combobox("getValue");
            var data = $("#" + id).combobox("getData");
            if ($.hisui.indexOfArray(data, optobj.valueField, val) < 0) {
                val = "";
            }
        }
        if (typeof val == "undefined") val = "";
        return val
    } else if (className.indexOf("hisui-datebox") >= 0) {
        return $("#" + id).datebox("getValue")
    } else {
        return $("#" + id).val()
    }
    return ""
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
function TRLengthChange() {
    var TRStartTime = $("#TRStartTime").timespinner('getValue');
    var TREndTime = $("#TREndTime").timespinner('getValue');
    var TRLength = $("#TRLength").val(); //numberbox('getValue')
    if ((TRStartTime == "") || (TREndTime == "") || (TRLength == "")) {
        $("#tips").html("");
    } else {
        var Min = getMinute(TRStartTime, TREndTime);
        $("#tips").html("Ϊ��֤ʱ�����к�,��Сʱ�κ���Ϊ" + Math.ceil(Min / TRLength));
    }
}
function getMinute(s1, s2) {
    var reDate = /\d{4}-\d{1,2}-\d{1,2} /;
    s1 = new Date((reDate.test(s1) ? s1 : '2017-1-1 ' + s1).replace(/-/g, '/'));
    s2 = new Date((reDate.test(s2) ? s2 : '2017-1-1 ' + s2).replace(/-/g, '/'));
    var ms = s2.getTime() - s1.getTime();
    if (ms < 0) return 0;
    return Math.ceil(ms / 1000 / 60);
}

////�µ�ԤԼ���޸Ĵ���
function InitAppMethodGrid() {
    $('#tabAppMethodInfo').datagrid({
        url: '',
        fit: true,
        border: false,
        striped: true,
        rownumbers: false,
        singleSelect: true,
        fitColumns: true,
        autoRowHeight: false,
        pagination: true,
        pageSize: 15,
        pageList: [15, 100, 200],
        columns: [[
            { field: 'AQRowid', hidden: true },
            { field: 'AppMethodID', hidden: true },
            {
                field: 'AppMethod', title: 'ԤԼ��ʽ', align: 'center', width: 200,
                editor: {
                    type: 'combobox',
                    options: {
                        onBeforeLoad: function (param) {
                            param.ClassName = 'DHCDoc.OPAdm.ScheduleTemp';
                            param.QueryName = 'QueryAppMethod';
                            param.ArgCnt = 0;
                        }
                    }
                }
            },
            {
                field: 'MaxQty', title: '���ԤԼ��', align: 'center', width: 160,
                editor: {
                    type: 'numberbox', options: {
                        min: 0,
                        onChange: function (val, oldVal) {
                            QtyChange('tabAppMethodInfo', this);
                        }
                    }
                }
            },
            {
                field: 'ReserveQty', title: '������', align: 'center', width: 110,
                editor: {
                    type: 'numberbox', options: {
                        min: 0,
                        onChange: function (val, oldVal) {
                            QtyChange('tabAppMethodInfo', this);
                        }
                    }
                }
            }
        ]],
        toolbar: [{
            text: '����',
            iconCls: 'icon-add',
            handler: function () {
                $('#tabAppMethodInfo').datagrid('appendRow', {});
                var rows = $('#tabAppMethodInfo').datagrid('getRows');
                $('#tabAppMethodInfo').datagrid('beginEdit', rows.length - 1);
            }
        }, {
            text: 'ɾ��',
            iconCls: 'icon-remove',
            handler: function () {
                var AMData = GetElementValue('tabAppMethodInfo');
                var oldAMData = new Array();
                for (var i = 0; i < AMData.length; i++) {
                    if (!AMData[i].AppMethodID) continue;
                    oldAMData.push($.extend({}, $.extend({}, AMData[i])));
                }
                var Selected = $('#tabAppMethodInfo').datagrid('getSelected');
                if (!Selected) {
                    $.messager.popover({ msg: "��ѡ����Ҫɾ������!", type: 'alert' });
                    return;
                }
                var index = $('#tabAppMethodInfo').datagrid('getRowIndex', Selected);
                $('#tabAppMethodInfo').datagrid('deleteRow', index);
                if (!AppMethodQtySave()) {
                    SetElementValue('tabAppMethodInfo', oldAMData);
                }
            }
        }, {
            text: '����',
            iconCls: 'icon-save',
            handler: function () {
                AppMethodQtySave();
            }
        }],
        onDblClickRow: function (index, row) {
            $(this).datagrid('beginEdit', index);
        },
        onBeginEdit: function (index, row) {
            var ed = $(this).datagrid('getEditor', { index: index, field: 'AppMethod' });
            SetElementValue(ed.target, row.AppMethodID);
            AddDGTBSaveTip('tabAppMethodInfo');
        }
    });
}
function InitTRDataGrid() {
    $('#tabTRInfo').datagrid({
        url: '',
        fit: true,
        border: false,
        striped: true,
        rownumbers: true,
        singleSelect: true,
        fitColumns: true,
        autoRowHeight: false,
        pagination: true,
        pageSize: 15,
        pageList: [15, 100, 200],
        columns: [[
            { field: 'AQTRRowid', hidden: true },
            { field: 'SttTime', title: '��ʼʱ��', align: 'center', width: 150 },
            { field: 'EndTime', title: '����ʱ��', align: 'center', width: 150 },
            {
                field: 'Load', title: '����', align: 'center', width: 100,
                editor: { type: 'numberbox', options: { min: 1 } }
            },
            { field: 'tabTRAppMethodInfo', hidden: true }
        ]],
        toolbar: [{
            text: '����',
            iconCls: 'icon-save',
            handler: function () {
                var rows = $('#tabTRInfo').datagrid('getData').originalRows;
                var total = 0
                var PositiveMaxLoad = $("#PositiveMax").numberbox('getValue');
                for (var i = 0; i < rows.length; i++) {
                    var Editors = $('#tabTRInfo').datagrid('getEditors', i);
                    if (Editors.length) {
                        rows[i].Load = GetElementValue(Editors[0].target);
                    }
                    if (rows[i].Load == "") {
                        $.messager.popover({ msg: '��ʱ���޶��Ϊ��', type: 'error' });
                        return;
                    }
                    total += Number(rows[i].Load)
                    if (rows[i].tabTRAppMethodInfo) {
                        var ResverNum = 0, MaxQty = 0;
                        for (var j = 0; j < rows[i].tabTRAppMethodInfo.length; j++) {
                            var OneReserveQty = rows[i].tabTRAppMethodInfo[j].ReserveQty;
                            var OneMaxQty = rows[i].tabTRAppMethodInfo[j].MaxQty;
                            ResverNum = parseFloat(ResverNum) + parseFloat(OneReserveQty);
                            if (OneMaxQty > MaxQty) {
                                MaxQty = OneMaxQty;
                            }
                        }
                        if (parseFloat(ResverNum) > parseFloat(rows[i].Load)) {
                            $.messager.popover({ msg: '��ʱ���޶���ԤԼ��ʽ���ܱ�����Ӧ��С�ڷ�ʱ���޶�', type: 'error' });
                            return;
                        }
                        if (parseFloat(MaxQty) > parseFloat(rows[i].Load)) {
                            $.messager.popover({ msg: '��ʱ���޶���ԤԼ��ʽ�����ԤԼ��Ӧ��С�ڷ�ʱ���޶�', type: 'error' });
                            return;
                        }
                    }
                }

                var SessRowid = "";
                var tab = $('#tabTimeRange').tabs('getSelected');
                var index = $('#tabTimeRange').tabs('getTabIndex', tab);
                var tab = $('#tabTimeRange').tabs('getTab', index);
                var SessRowid = tab[0].id;
                if (SessRowid == "") {
                    $.messager.popover({ msg: "���ȱ����Ű�ģ��", type: 'error' });
                    return false;
                }
                if (PositiveMaxLoad != total) {
                    $.messager.popover({ msg: "�����޶���ڷ�ʱ�������ܺ�", type: 'error' });
                    return false;
                }
                SetElementValue('tabTRInfo', rows);
                AddSaveTip($('#BUpdate').find('.l-btn-text'));
                ScheduleObj = GetElementValue('tabTRInfo');
                var retJson = $.cm({
                    ClassName: 'DHCDoc.OPAdm.ScheduleTemp',
                    MethodName: 'SaveTempTRNew',
                    SessRowid: SessRowid,
                    TRInfoObjStr: JSON.stringify(ScheduleObj),
                    dataType: "json"
                }, false);
                if (retJson == "0") {
                    $.messager.popover({ msg: "����ɹ�!", type: 'success' });
                    LoadtabTRInfo(SessRowid)
                }
            }
        }, '-', {
            text: '��������',
            iconCls: 'icon-init',
            handler: function () {
                if (CheckGridEditing('tabAppMethodInfo')) {
                    $.messager.popover({ msg: "���ȱ���ԤԼ��ʽ���ٽ��з�ʱ�β���", type: 'alert' });
                    return false;
                }
                var SessRowid = ""
                var tab = $('#tabTimeRange').tabs('getSelected');
                var index = $('#tabTimeRange').tabs('getTabIndex', tab);
                var tab = $('#tabTimeRange').tabs('getTab', index);
                var SessRowid = tab[0].id;
                $('#TRGenWin').window('open');
                var TRASLoad = $.cm({
                    ClassName: 'DHCDoc.OPAdm.ScheduleTemp',
                    MethodName: 'GetTRASLoad',
                    SessRowid: SessRowid,
                    dataType: "text"
                }, false);
                $('#TRTemp').singleCombo({
                    valueField: 'ID',
                    textField: 'Name',
                    ClassName: 'DHCDoc.OPAdm.TimeRangeTemp',
                    QueryName: 'QueryTemp',
                    loadFilter: function (data) {
                        for (var i = 0; i < data.length; i++) {
                            data[i].Name = data[i].TimeRange + "-" + data[i].Name;
                        }
                        return data;
                    },
                    onBeforeLoad: function (param) {
                        param.TRRowid = $("#TimeRange").combobox('getValue'); //GetElementValue('TimeRange');
                        param.SumLoad = TRASLoad;
                        param.HospID = $HUI.combogrid('#_HospUserList').getValue();
                    }
                });

                SetElementValue('TRASLoad', TRASLoad);
                SetElementValue('IntervalTime', "");
                //$("#TRASLoad").val(TRASLoad);
                GenWayChecked()
            }
        }, '-', {
            text: '���Ϊģ��',
            iconCls: 'icon-save-to',
            handler: function () {
                var Data = GetElementValue('tabTRInfo');
                if (!Data.length) {
                    $.messager.alert('��ʾ', 'û��ʱ�����ݲ��ܱ���');
                } else {
                    $('#TRTempSaveWin').window('open');
                    $("#TempName").val("").focus();
                }
            }
        }],
        onDblClickRow: function (index, row) {
            $(this).datagrid('beginEdit', index);
        },
        onBeforeSelect: function (index, row) {
            if (CheckGridEditing('tabAppMethodInfo')) {
                $.messager.popover({ msg: "���ȱ���ԤԼ��ʽ���ٽ��з�ʱ�β���", type: 'alert' });
                return false;
            }
            if (CheckGridEditing('tabTRAppMethodInfo')) {
                var UnsaveFlag = dhcsys_confirm('��δ����ķ�ʱ��ԤԼ��ʽ��Ϣ,�Ƿ����?');
                if (UnsaveFlag == false) {
                    return UnsaveFlag;
                } else {
                    return CheckBeforAppMedthod();
                }
            }
            return true;
        },
        onSelect: function (index, row) {
            var tabTRAppMethodInfo = row.tabTRAppMethodInfo;
            if (!tabTRAppMethodInfo) tabTRAppMethodInfo = [];
            if (typeof (tabTRAppMethodInfo) == 'string') {
                tabTRAppMethodInfo = JSON.parse(tabTRAppMethodInfo);
            }
            $('#tabTRAppMethodInfo').datagrid("rejectChanges").datagrid("unselectAll");
            SetElementValue('tabTRAppMethodInfo', tabTRAppMethodInfo);
        },
        onLoadSuccess: function (data) {
            $(this).datagrid('unselectAll');
            SetElementValue('tabTRAppMethodInfo', []);
            if (GetElementValue('TRFlag')) {
                ResetASLoad();
            }
            DeleteDGTBSaveTip('tabTRInfo');
        },
        onBeginEdit: function () {
            AddDGTBSaveTip('tabTRInfo');
        },
        onAfterEdit: function (index, row, changes) {
            ResetASLoad();
        }
    }).datagrid({ loadFilter: DocToolsHUI.lib.pagerFilter });
    var tabTRAppMethodInfoEditRow = ""
    function ResetASLoad() {
        var ASLoad = 0;
        var rows = GetElementValue('tabTRInfo');
        for (var i = 0; i < rows.length; i++) {
            ASLoad += Number(rows[i].Load);
        }
        SetElementValue('ASLoad', ASLoad);
        //ASQtyChange("",'#ASLoad');
    }
    $('#tabTRAppMethodInfo').datagrid({
        url: '',
        fit: true,
        border: false,
        striped: true,
        rownumbers: false,
        singleSelect: true,
        fitColumns: true,
        autoRowHeight: false,
        pagination: true,
        pageSize: 15,
        pageList: [15, 100, 200],
        columns: [[
            { field: 'TRAMRowid', hidden: true },
            { field: 'AppMethodID', hidden: true },
            {
                field: 'AppMethod', title: 'ԤԼ��ʽ', align: 'center', width: 250,
                editor: {
                    type: 'combobox',
                    options: {
                        onBeforeLoad: function (param) {
                            param.ClassName = 'DHCDoc.OPAdm.ScheduleTemp';
                            param.QueryName = 'QueryAppMethod';
                            param.ArgCnt = 0;
                        }
                    }
                }
            },
            {
                field: 'MaxQty', title: '���ԤԼ����', align: 'center', width: 160,
                editor: {
                    type: 'numberbox', options: {
                        min: 0,
                        onChange: function (val, oldVal) {
                            QtyChange('tabTRAppMethodInfo', this);
                        }
                    }
                }
            },
            {
                field: 'ReserveQty', title: '��������', align: 'center', width: 110,
                editor: {
                    type: 'numberbox', options: {
                        min: 0,
                        onChange: function (val, oldVal) {
                            QtyChange('tabTRAppMethodInfo', this);
                        }
                    }
                }
            }
        ]],
        toolbar: [{
            text: '����',
            iconCls: 'icon-add',
            handler: function () {
                var TRInfoSelected = $('#tabTRInfo').datagrid('getSelected');
                if (!TRInfoSelected) {
                    $.messager.popover({ msg: '��ѡ��ʱ�κ���ά��ʱ��ԤԼ��ʽ', type: 'error' });
                    return;
                }
                $('#tabTRAppMethodInfo').datagrid('appendRow', {});
                var rows = $('#tabTRAppMethodInfo').datagrid('getRows');
                $('#tabTRAppMethodInfo').datagrid('beginEdit', rows.length - 1);
                tabTRAppMethodInfoEditRow = rows.length - 1
            }
        }, {
            text: 'ɾ��',
            iconCls: 'icon-remove',
            handler: function () {
                var Selected = $('#tabTRAppMethodInfo').datagrid('getSelected');
                if ((!Selected) && (tabTRAppMethodInfoEditRow != "")) {
                    $.messager.popover({ msg: '��ѡ����Ҫɾ������', type: 'alert' });
                    return;
                }
                if (Selected) {
                    var index = $('#tabTRAppMethodInfo').datagrid('getRowIndex', Selected);
                } else {
                    var index = tabTRAppMethodInfoEditRow
                }
                $('#tabTRAppMethodInfo').datagrid('deleteRow', index);
                AddDGTBSaveTip('tabTRAppMethodInfo');
                //$('#tabTRAppMethodInfo').datagrid('options').toolbar[4].handler();
            }
        }, {
            text: '����',
            iconCls: 'icon-save',
            handler: function () {
                var CheckFlag = CheckBeforAppMedthod()
                if (CheckFlag == false) return;
                var TRInfoSelected = $('#tabTRInfo').datagrid('getSelected');
                var newRows = new Array();
                var AMArr = new Array();
                var ReserveQtySum = 0;
                var TRLoad = TRInfoSelected.Load;
                var ed = $('#tabTRInfo').datagrid('getEditor', { index: TRInfoIndex, field: 'Load' });
                if (ed) TRLoad = GetElementValue(ed.target);
                var TRInfoIndex = $('#tabTRInfo').datagrid('getRowIndex', TRInfoSelected);
                var TRRows = GetElementValue('tabTRInfo');
                var AppStartNo = Number(GetElementValue('AppStartNo'));
                var LoadSum = 0
                for (var i = 0; i < TRInfoIndex; i++) { //������ʼ��,����ʵ�ʿ��ú�
                    var Load = TRRows[i].Load;
                    var ed = $('#tabTRInfo').datagrid('getEditor', { index: i, field: 'Load' });
                    if (ed) Load = GetElementValue(ed.target);
                    LoadSum += Number(Load);
                }
                if (LoadSum < AppStartNo) {
                    TRLoad = Number(TRLoad) + LoadSum - AppStartNo + 1
                    if (TRLoad < 0) TRLoad = 0;
                }
                var rows = GetElementValue('tabTRAppMethodInfo');
                for (var i = 0; i < rows.length; i++) {
                    var Editors = $('#tabTRAppMethodInfo').datagrid('getEditors', i);
                    if (Editors.length) {
                        rows[i].AppMethodID = GetElementValue(Editors[0].target);
                        rows[i].AppMethod = $(Editors[0].target).combobox('getText');
                        rows[i].MaxQty = GetElementValue(Editors[1].target);
                        rows[i].ReserveQty = GetElementValue(Editors[2].target);
                    }
                    if (rows[i].AppMethodID) {
                        ReserveQtySum += Number(rows[i].ReserveQty);
                        newRows.push(rows[i]);
                        AMArr[rows[i].AppMethodID] = 1
                    }
                }
                SetElementValue('tabTRAppMethodInfo', newRows);
                TRInfoSelected.tabTRAppMethodInfo = newRows;
                var Editors = $('#tabTRInfo').datagrid('getEditors', TRInfoIndex);
                if (Editors.length) {
                    TRInfoSelected.Load = GetElementValue(Editors[0].target);
                }
                $('#tabTRInfo').datagrid('updateRow', { index: TRInfoIndex, row: TRInfoSelected });
                AddDGTBSaveTip('tabTRInfo');
            }
        }],
        onDblClickRow: function (index, row) {
            $(this).datagrid('beginEdit', index);
        },
        onLoadSuccess: function () {
            DeleteDGTBSaveTip('tabTRAppMethodInfo');
        },
        onBeginEdit: function (index, row) {
            var ed = $(this).datagrid('getEditor', { index: index, field: 'AppMethod' });
            SetElementValue(ed.target, row.AppMethodID);
            AddDGTBSaveTip('tabTRAppMethodInfo');
            tabTRAppMethodInfoEditRow = index
        }
    });
}
function QtyChange(id, that) {
    var index = GetDGEditRowIndex(that);
    var Editors = $('#' + id).datagrid('getEditors', index);
    var MaxQty = GetElementValue(Editors[1].target);
    var ReserveQty = GetElementValue(Editors[2].target);
    if (Number(MaxQty) < Number(ReserveQty)) {
        $.messager.popover({ msg: "���������ܴ������ԤԼ��!", type: 'error' });
        //SetElementValue(Editors[2].target,ReserveQty);
        return false;
    }
    return true;
}
function ASQtyChange(oldVal, that) {
    var TotalQty = 0
    var AvailAppQty = Number(GetElementValue('ApptMax'));
    var AMData = GetElementValue('tabAppMethodInfo');
    for (var i = 0; i < AMData.length; i++) {
        if (Number(AMData[i].MaxQty) > AvailAppQty) {
            $.messager.popover({ msg: "��ԤԼ������:" + AvailAppQty + ",С��" + AMData[i].AppMethod + "��ԤԼ�������:" + Number(AMData[i].MaxQty), type: 'error' });
            //SetElementValue('AppStartNo',oldVal);
            $(that).select();
            return false;
        }
        TotalQty += Number(AMData[i].ReserveQty);
    }
    if (TotalQty > AvailAppQty) {
        $.messager.popover({ msg: "��ԤԼ������:" + AvailAppQty + ",С��ԤԼ��ʽ���������ܺ�:" + TotalQty + "!", type: 'error' });
        //SetElementValue(that,oldVal);
        $(that).select();
        return false;
    }
    //SetElementValue('AppLoad',AvailAppQty);
    return true;
}
function TRGenClick() {
    var value = $("input[name='GenTRRadio']:checked").val();
    if (value == 'GenTRTemp') {
        if (GenTRInfoByTemp()) {
            AddSaveTip($('#BUpdate').find('.l-btn-text'));
            $('#TRGenWin').window('close');
            ReCheckAppMethod();
        }
    } else {
        var SttTime = GetElementValue('TRStartTime');
        var EndTime = GetElementValue('TREndTime');
        var IntervalTime = GetElementValue('IntervalTime');
        var ASLoad = GetElementValue('TRASLoad');
        if (CalculateTRInfo(SttTime, EndTime, IntervalTime, ASLoad)) {
            AddSaveTip($('#BUpdate').find('.l-btn-text'));
            $('#TRGenWin').window('close');
            ReCheckAppMethod();
        }
    }
}
function CalculateTRInfo(SttTime, EndTime, IntervalTime, ASLoad) {
    if ((IntervalTime == "") || (SttTime == "") || (EndTime == "") || (ASLoad == "")) return false;
    var SttMin = TimeToMin(SttTime);
    var EndMin = TimeToMin(EndTime);
    var IntervalTime = Number(IntervalTime);
    var ASLoad = Number(ASLoad);
    var TRLength = EndMin - SttMin;
    if (TRLength % IntervalTime) {
        $.messager.popover({ msg: "��ʱ�μ��ʱ�䲻�ܾ���ʱ��!", type: 'error' });
        $('#IntervalTime').select();
        return false;
    }
    var DataArr = new Array();
    var TRCount = TRLength / IntervalTime;
    for (var i = 1; i <= TRCount; i++) {
        var SttTime = SttMin + (i - 1) * IntervalTime;
        var EndTime = SttMin + i * IntervalTime;
        var Load = Math.floor(ASLoad / (TRCount - i + 1));
        ASLoad -= Load;
        var obj = { SttTime: MinToTime(SttTime), EndTime: MinToTime(EndTime), Load: Load };
        DataArr.push(obj);
    }
    SetElementValue('tabTRInfo', DataArr);
    return true;
    function TimeToMin(TimStr) {
        return Number(TimStr.split(':')[0]) * 60 + Number(TimStr.split(':')[1]);
    }
    function MinToTime(Mins) {
        var hour = Math.floor(Mins / 60);
        if (hour < 10) hour = '0' + hour;
        var min = (Mins % 60);
        if (min < 10) min = '0' + min;
        return hour + ":" + min;
    }
}
function GenTRInfoByTemp() {
    var ID = GetElementValue('TRTemp');
    if (!ID) {
        $.messager.popover({ msg: "��ѡ��ģ��!", type: 'error' });
        return false;
    }
    var TempData = $('#TRTemp').combobox('getData');
    for (var i = 0; i < TempData.length; i++) {
        if (TempData[i].ID == ID) {
            var Data = TempData[i].Data;
            if (!Data) Data = [];
            if (typeof (Data) == 'string') {
                Data = JSON.parse(Data);
            }
            SetElementValue('tabTRInfo', Data);
            return true;
        }
    }
    return false;
}
//��ʱ��ԤԼ��ʽ ���� ԤԼ��ʽ���� JS����ֵ��һ��������extend
function ReCheckAppMethod() {
    var AMArr = new Array();
    var AMData = GetElementValue('tabAppMethodInfo');
    var oldAMData = new Array();
    for (var i = 0; i < AMData.length; i++) {
        if (!AMData[i].AppMethodID) continue;
        AMArr[AMData[i].AppMethodID] = $.extend({}, AMData[i]);
        AMArr[AMData[i].AppMethodID].index = i;
        oldAMData.push($.extend({}, $.extend({}, AMData[i])));
    }
    var TRAMArr = GetTRAppMethodInfo();
    for (var AppMethodID in TRAMArr) {
        if (AMArr[AppMethodID]) {
            if (Number(TRAMArr[AppMethodID].MaxQty) > Number(AMArr[AppMethodID].MaxQty)) {
                AMArr[AppMethodID].MaxQty = TRAMArr[AppMethodID].MaxQty;
            }
            if (Number(TRAMArr[AppMethodID].ReserveQty) > Number(AMArr[AppMethodID].ReserveQty)) {
                AMArr[AppMethodID].ReserveQty = TRAMArr[AppMethodID].ReserveQty;
            }
            $('#tabAppMethodInfo').datagrid('updateRow', { index: AMArr[AppMethodID].index, row: AMArr[AppMethodID] });
        } else {
            $('#tabAppMethodInfo').datagrid('appendRow', TRAMArr[AppMethodID]);
        }
    }
    if (!AppMethodQtySave()) {    // ԤԼ��ʽ����������֤ʧ��,��ԭԤԼ��ʽ����
        SetElementValue('tabAppMethodInfo', oldAMData);
        return false;
    }
    return true;
}
function GetTRAppMethodInfo() {
    var TRAMArr = new Array();
    var TRData = GetElementValue('tabTRInfo');
    for (var i = 0; i < TRData.length; i++) {
        var tabTRAppMethodInfo = TRData[i].tabTRAppMethodInfo;
        if (!tabTRAppMethodInfo) tabTRAppMethodInfo = [];
        if (typeof (tabTRAppMethodInfo) == 'string') {
            tabTRAppMethodInfo = JSON.parse(tabTRAppMethodInfo);
        }
        var TRAMData = $.extend({}, tabTRAppMethodInfo);
        for (var j in TRAMData) {
            var AppMethodID = TRAMData[j].AppMethodID;
            if (!AppMethodID) continue;
            if (TRAMArr[AppMethodID]) {
                var ReserveQty = Number(TRAMArr[AppMethodID].ReserveQty);
                TRAMArr[AppMethodID].ReserveQty = ReserveQty + Number(TRAMData[j].ReserveQty);
                var MaxQty = Number(TRAMArr[AppMethodID].MaxQty);
                TRAMArr[AppMethodID].MaxQty = MaxQty + Number(TRAMData[j].MaxQty);
            } else {
                TRAMArr[AppMethodID] = $.extend({}, TRAMData[j]);
            }
        }
    }
    return TRAMArr;
}
function AppMethodQtySave() {
    var newRows = new Array();
    var AMArr = new Array();
    var tab = $('#tabTimeRange').tabs('getSelected');
    var index = $('#tabTimeRange').tabs('getTabIndex', tab);
    var tab = $('#tabTimeRange').tabs('getTab', index);
    var SessRowid = tab[0].id;
    if (SessRowid == "") {
        $.messager.popover({ msg: "���ȱ����Ű�ģ��", type: 'error' });
        return false;
    }
    var TotalQty = 0;
    var NewAvailAppQty = Number(GetElementValue('ApptMax')) //Number(GetElementValue('ASLoad'))-Number(GetElementValue('AppStartNo'))+1;
    var RetData = tkMakeServerCall(PageLogicObj.m_ClassName, "GetSessData", SessRowid);
    var RetArr = RetData.split("!");
    var SessArr = RetArr[0].split("^");
    var AvailAppQty = +SessArr[0];
    if (NewAvailAppQty != AvailAppQty) {
        $.messager.alert("��ʾ", "���ȱ����Ű�ģ��ԤԼ�޶�!", "info", function () {
            $("#ApptMax").focus();
        });
        return false;
    } else if ((NewAvailAppQty == "0") && (AvailAppQty > 0)) {
        $.messager.alert("��ʾ", "ԤԼ�޶�Ϊ0����ά��ԤԼ�޶�", "info", function () {
            $("#ApptMax").focus();
        });
        return false;
    }
    var TRAMArr = GetTRAppMethodInfo();
    var rows = $('#tabAppMethodInfo').datagrid('getRows');
    for (var i = 0; i < rows.length; i++) {
        var Editors = $('#tabAppMethodInfo').datagrid('getEditors', i);
        if (Editors.length) {
            rows[i].AppMethodID = GetElementValue(Editors[0].target);
            rows[i].AppMethod = $(Editors[0].target).combobox('getText');
            rows[i].MaxQty = GetElementValue(Editors[1].target);
            rows[i].ReserveQty = GetElementValue(Editors[2].target);
        }
        if (rows[i].AppMethodID) {
            if (AMArr[rows[i].AppMethodID]) {
                $.messager.popover({ msg: rows[i].AppMethod + "��ʽ�ظ�ά��!", type: 'error' });
                return false;
            }
            if (Number(rows[i].ReserveQty) > Number(rows[i].MaxQty)) {
                $.messager.popover({ msg: rows[i].AppMethod + " �����������С�ڱ�������!", type: 'error' });
                return false;
            }
            TotalQty += Number(rows[i].ReserveQty);
            if (TotalQty > AvailAppQty) {
                $.messager.popover({ msg: 'ԤԼ��ʽ�����ϼ�:' + TotalQty + ',������ԤԼ��������:' + AvailAppQty, type: 'error' });
                return false;
            }
            if (Number(rows[i].MaxQty) > AvailAppQty) {
                $.messager.popover({ msg: rows[i].AppMethod + " ���ԤԼ�������Ű�ģ��ԤԼ�޶�!", type: 'error' });
                return false;
            }
            if (TRAMArr[rows[i].AppMethodID]) {
                /*if(Number(TRAMArr[rows[i].AppMethodID].MaxQty)>Number(rows[i].MaxQty)){
                    $.messager.popover({
                        msg:rows[i].AppMethod+'��ʱ�����ԤԼ�ϼ�:'+TRAMArr[rows[i].AppMethodID].MaxQty+"����ԤԼ�ϼ�:"+rows[i].MaxQty,
                        type:'error'
                    });
                    return false;
                }*/
                if (Number(TRAMArr[rows[i].AppMethodID].ReserveQty) > Number(rows[i].ReserveQty)) {
                    $.messager.popover({
                        msg: rows[i].AppMethod + '��ʱ�α����ϼ�:' + TRAMArr[rows[i].AppMethodID].ReserveQty + "���ڱ����ϼ�:" + rows[i].ReserveQty,
                        type: 'error'
                    });
                    return false;
                }
                delete TRAMArr[rows[i].AppMethodID];
            }
            newRows.push(rows[i]);
            AMArr[rows[i].AppMethodID] = 1

        }
    }
    for (var AppMethodID in TRAMArr) {
        $.messager.popover({ msg: TRAMArr[AppMethodID].AppMethod + '��ʱ�δ���ά������,����ɾ����ʱ��ԤԼ��ʽ', type: 'error' });
        return false;
    }
    SetElementValue('tabAppMethodInfo', newRows);
    DeleteDGTBSaveTip('tabAppMethodInfo');
    AddSaveTip($('#BUpdate').find('.l-btn-text'));
    ScheduleObj = GetElementValue('tabAppMethodInfo');
    var retJson = $.cm({
        ClassName: 'DHCDoc.OPAdm.ScheduleTemp',
        MethodName: 'SaveTempAppMethodNew',
        SessRowid: SessRowid,
        AMObjStr: JSON.stringify(ScheduleObj),
        dataType: "json"
    }, false);
    if (retJson == "0") {
        $.messager.popover({ msg: "����ɹ�!", type: 'success' });
        $('#tabAppMethodInfo').datagrid("rejectChanges").datagrid("unselectAll");
        LoadApptabAppMethodInfo(SessRowid)
    }
    return true;
}
function LoadApptabAppMethodInfo(SessRowid) {
    var retJson = $.cm({
        ClassName: 'DHCDoc.OPAdm.ScheduleTemp',
        MethodName: 'GetTempAppMethodNew',
        SessRowid: SessRowid,
        dataType: "json"
    }, false);
    SetElementValue("tabAppMethodInfo", retJson);
}
function LoadtabTRInfo(SessRowid) {
    var retJson = $.cm({
        ClassName: 'DHCDoc.OPAdm.ScheduleTemp',
        MethodName: 'GetTempTRInfoNew',
        SessRowid: SessRowid,
        dataType: "json"
    }, false);
    SetElementValue("tabTRInfo", retJson);
}
function TRTempSaveClick() {
    var TempName = $('#TempName').val();
    if (TempName == '') {
        $.messager.popover({ msg: "����дģ������!", type: 'alert' });
        return;
    }
    var SaveObj = {
        Name: TempName,
        Data: GetElementValue('tabTRInfo'),
        TimeRangeDR: $("#TimeRange").combobox('getValue'),
        InsertUserDR: session['LOGON.USERID']
    };
    var SaveArr = new Array(SaveObj);
    var retJson = $.cm({
        ClassName: 'DHCDoc.OPAdm.TimeRangeTemp',
        MethodName: 'Update',
        InputJson: JSON.stringify(SaveArr),
        HospID: $HUI.combogrid('#_HospUserList').getValue(),
        dataType: "json"
    }, false);
    if (retJson.Code == 0) {
        $.messager.popover({ msg: "����ģ��ɹ�!", type: 'success' });
        $('#TRTempSaveWin').window('close');
        return true;
    } else {
        $.messager.alert('ʧ��', "����ʧ��:" + retJson.msg);
        return false;
    }
}
function SaveScheduleTemp(TYPE) {
    if (CheckGridEditing('tabAppMethodInfo')) {
        $.messager.popover({ msg: "���ȱ���ԤԼ��ʽ���ٱ���", type: 'alert' });
        return false;
    }
    if (CheckGridEditing('tabTRInfo')) {
        $.messager.popover({ msg: "���ȱ����ʱ����Ϣ���ٱ���", type: 'alert' });
        return false;
    }
    var SessRowid = ""
    var tab = $('#tabTimeRange').tabs('getSelected');
    if (tab) {
        SessRowid = tab.panel('options').SessRowid;
        if (!SessRowid) SessRowid = "";
    }
    if (TYPE == 'ADD') SessRowid = "";
    var ScheduleObj = { SessRowid: SessRowid, UserID: session['LOGON.USERID'] };
    var $obj = $('ul.schedule-edit li').find('input[id]');
    for (var i = 0; i < $obj.size(); i++) {  //��ͬeach�첽,��֤���ݱ�����
        var id = $obj.eq(i).attr('id');
        if (id) {
            ScheduleObj[id] = GetElementValue($obj.eq(i));
            if ((ScheduleObj[id] == "") && ($obj.eq(i).hasClass('combobox-f'))) {
                if ($obj.eq(i).combobox('options').required) {
                    var text = $obj.eq(i).prev().text();
                    $.messager.popover({ msg: text + "Ϊ������,��ѡ��", type: 'alert' });
                    $obj.eq(i).next().find('input').focus();
                    return false;
                }
            }
        }
    }
    ScheduleObj.ScheduleLinesRowId = GetElementValue('ScheduleLinesList');
    if (GetElementValue('GenerFlag')) {
        ScheduleObj.GenerFlag = "Y";
    } else {
        ScheduleObj.GenerFlag = "N";
    }
    if (GetElementValue('TRFlag')) {
        ScheduleObj.TRFlag = "Y";
    } else {
        ScheduleObj.TRFlag = "N";
    }
    ScheduleObj.tabAppMethodInfo = GetElementValue('tabAppMethodInfo');
    ScheduleObj.tabTRInfo = GetElementValue('tabTRInfo');
    var retJson = SaveSessData(ScheduleObj);
    if (retJson.Code == 0) {
        $.messager.popover({ msg: "����ɹ�!", type: 'success' });
        if (SessRowid) {
            SetSessInfo(SessRowid);
        } else {
            EditScheduleTemp(retJson.SessRowid);
        }
        DeleteSaveTip($('#BUpdate').find('.l-btn-text'));
        return true;
    } else {
        $.messager.alert('����ʧ��', retJson.msg);
        return false;
    }
}
function SaveSessData(ScheduleObj) {
    return $.cm({
        ClassName: 'DHCDoc.OPAdm.ScheduleTemp',
        MethodName: 'SaveScheduleTemp',
        InputJson: JSON.stringify(ScheduleObj),
        dataType: "json"
    }, false);
}
function GenWayChecked() {
    var value = $("input[name='GenTRRadio']:checked").val();
    $('.search-table').find('tr[name="' + value + '"]').show();
    $('.search-table').find('tr[name]').not('[name="' + value + '"]').hide();
    if (value == "GenTRTemp") {
        $('#TRTemp').next('span').find('input').focus();
    } else {
        $("#TRASLoad").attr("disabled", true);
        $("#IntervalTime").focus();
    }
}
function CheckBeforAppMedthod() {
    var TRInfoSelected = $('#tabTRInfo').datagrid('getSelected');
    if (!TRInfoSelected) {
        $.messager.popover({ msg: '��ѡ��ʱ�κ���ά��ʱ��ԤԼ��ʽ', type: 'error' });
        return false;
    }
    var newRows = new Array();
    var AMArr = new Array();
    var ReserveQtySum = 0;
    var TRLoad = TRInfoSelected.Load;
    var ed = $('#tabTRInfo').datagrid('getEditor', { index: TRInfoIndex, field: 'Load' });
    if (ed) TRLoad = GetElementValue(ed.target);
    var TRInfoIndex = $('#tabTRInfo').datagrid('getRowIndex', TRInfoSelected);
    var TRRows = GetElementValue('tabTRInfo');
    var AppStartNo = Number(GetElementValue('AppStartNo'));
    var LoadSum = 0
    for (var i = 0; i < TRInfoIndex; i++) { //������ʼ��,����ʵ�ʿ��ú�
        var Load = TRRows[i].Load;
        var ed = $('#tabTRInfo').datagrid('getEditor', { index: i, field: 'Load' });
        if (ed) Load = GetElementValue(ed.target);
        LoadSum += Number(Load);
    }
    if (LoadSum < AppStartNo) {
        TRLoad = Number(TRLoad) + LoadSum - AppStartNo + 1
        if (TRLoad < 0) TRLoad = 0;
    }
    //����ԤԼ��ʽ�޶����ԤԼ��/������
    var APPMethodArr = new Array();
    var AppMethosRows = GetElementValue('tabAppMethodInfo');
    for (var i = 0; i < AppMethosRows.length; i++) {
        var AppMethodID = AppMethosRows[i].AppMethodID;
        var MaxQty = AppMethosRows[i].MaxQty;
        var ReserveQty = AppMethosRows[i].ReserveQty;
        APPMethodArr[AppMethodID] = { "MaxQty": MaxQty, "ReserveQty": ReserveQty };
    }
    var TRMethodArr = new Array();
    var rows = GetElementValue('tabTRAppMethodInfo');
    for (var i = 0; i < rows.length; i++) {
        var Editors = $('#tabTRAppMethodInfo').datagrid('getEditors', i);
        if (Editors.length) {
            rows[i].AppMethodID = GetElementValue(Editors[0].target);
            rows[i].AppMethod = $(Editors[0].target).combobox('getText');
            rows[i].MaxQty = GetElementValue(Editors[1].target);
            rows[i].ReserveQty = GetElementValue(Editors[2].target);
        }
        if (rows[i].AppMethodID) {
            if (rows[i].AppMethodID == "") {
                $.messager.alert("��ʾ", "��ά��ԤԼ��ʽ");
                return false;
            }
            if (AMArr[rows[i].AppMethodID]) {
                $.messager.popover({ msg: rows[i].AppMethod + "��ʽ�ظ�ά��!", type: 'error' });
                return false;
            }
            if (!APPMethodArr[rows[i].AppMethodID]) {
                $.messager.popover({ msg: rows[i].AppMethod + " ����ά��ԤԼ��ʽ�޶�!", type: 'error' });
                return false;
            }
            if (rows[i].MaxQty == "") {
                $.messager.popover({ msg: rows[i].AppMethod + "���ԤԼ������Ϊ��!", type: 'error' });
                return false;
            }
            if (Number(rows[i].MaxQty) > Number(APPMethodArr[rows[i].AppMethodID].MaxQty)) {
                $.messager.popover({ msg: rows[i].AppMethod + "��ʽ���ԤԼ�������ܳ���ԤԼ��ʽ�޶�:" + APPMethodArr[rows[i].AppMethodID].MaxQty + "!", type: 'error' });
                return false;
            }
            if (Number(rows[i].MaxQty) > Number(TRLoad)) {
                $.messager.popover({ msg: rows[i].AppMethod + "��ʽ���ԤԼ�������ܳ���ʱ������:" + TRLoad + "!", type: 'error' });
                return false;
            }
            if (Number(rows[i].ReserveQty) > Number(rows[i].MaxQty)) {
                $.messager.popover({ msg: rows[i].AppMethod + "��ʽ�����������ܴ������ԤԼ����!", type: 'error' });
                return false;
            }
            if (Number(rows[i].ReserveQty) > Number(APPMethodArr[rows[i].AppMethodID].ReserveQty)) {
                $.messager.popover({ msg: rows[i].AppMethod + "��ʽ�����������ܴ���ԤԼ��ʽ������:" + APPMethodArr[rows[i].AppMethodID].ReserveQty + "!", type: 'error' });
                return false;
            }
            ReserveQtySum += Number(rows[i].ReserveQty);
            newRows.push(rows[i]);
            AMArr[rows[i].AppMethodID] = 1
            TRMethodArr[rows[i].AppMethodID] = { "MaxQty": rows[i].MaxQty, "ReserveQty": rows[i].ReserveQty, "AppMethod": rows[i].AppMethod };
        } else {
            $.messager.alert("��ʾ", "��ά��ԤԼ��ʽ");
            return false;
        }
    }
    if (ReserveQtySum > Number(TRLoad)) {
        $.messager.popover({ msg: "���������ϼ�:" + ReserveQtySum + ",���ܳ���ʱ������:" + TRLoad + "!", type: 'error' });
        return false;
    }
    //��ʱ����Ϣ��ѡ���и���ԤԼ��ʽ������
    for (var i = 0; i < TRRows.length; i++) {
        if (i == TRInfoIndex) continue;
        if (TRRows[i].tabTRAppMethodInfo) {
            for (var j = 0; j < TRRows[i].tabTRAppMethodInfo.length; j++) {
                var AppMethodID = TRRows[i].tabTRAppMethodInfo[j].AppMethodID;
                var MaxQty = TRRows[i].tabTRAppMethodInfo[j].MaxQty;
                var ReserveQty = TRRows[i].tabTRAppMethodInfo[j].ReserveQty;
                var AppMethod = TRRows[i].tabTRAppMethodInfo[j].AppMethod;
                if (TRMethodArr[AppMethodID]) {
                    MaxQty = Number(MaxQty) + Number(TRMethodArr[AppMethodID]["MaxQty"]);
                    ReserveQty = Number(ReserveQty) + Number(TRMethodArr[AppMethodID]["ReserveQty"]);
                    TRMethodArr[AppMethodID] = { "MaxQty": MaxQty, "ReserveQty": ReserveQty, "AppMethod": AppMethod };
                } else {
                    TRMethodArr[AppMethodID] = { "MaxQty": MaxQty, "ReserveQty": ReserveQty, "AppMethod": AppMethod };
                }
            }
        }
    }
    for (var AppMethodID in TRMethodArr) {
        /*if (Number(TRMethodArr[AppMethodID].MaxQty)>Number(APPMethodArr[AppMethodID].MaxQty)){
            $.messager.popover({msg:TRMethodArr[AppMethodID].AppMethod+" ��ʽ���ԤԼ�����ϼ�:"+TRMethodArr[AppMethodID].MaxQty+",���ܳ���ԤԼ��ʽ�޶����ԤԼ��:"+APPMethodArr[AppMethodID].MaxQty+"!",type:'error'});
            return false;
        }*/
        if (Number(TRMethodArr[AppMethodID].ReserveQty) > Number(APPMethodArr[AppMethodID].MaxQty)) {
            $.messager.popover({ msg: TRMethodArr[AppMethodID].AppMethod + " ��ʽ���������ϼ�:" + TRMethodArr[AppMethodID].ReserveQty + ",���ܳ���ԤԼ��ʽ�޶����ԤԼ��:" + APPMethodArr[AppMethodID].MaxQty + "!", type: 'error' });
            return false;
        }
        if (Number(TRMethodArr[AppMethodID].ReserveQty) > Number(APPMethodArr[AppMethodID].ReserveQty)) {
            $.messager.popover({ msg: TRMethodArr[AppMethodID].AppMethod + " ��ʽ���������ϼ�:" + TRMethodArr[AppMethodID].ReserveQty + ",���ܳ���ԤԼ��ʽ�޶����:" + APPMethodArr[AppMethodID].ReserveQty + "!", type: 'error' });
            return false;
        }
    }
    /*if (ReserveQtySum>Number()){
        $.messager.popover({msg:"���������ϼ�:"+ReserveQtySum+",���ܳ���ʱ������:"+TRLoad+"!",type:'error'});
        return false;
    }*/
    /*if(!ReCheckAppMethod()){
        return false;
    }*/
    return true;
}
