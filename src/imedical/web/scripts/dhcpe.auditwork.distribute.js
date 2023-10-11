/**
 * �ܼ칤��������   dhcpe.auditwork.distribute.js
 * @Author   wangguoying
 * @DateTime 2021-01-28
 */


var _GV = {
    FlowType: "",
    WDocList: [],
    HDocList: []
}

function init() {
    setLayout();
    initDate();
    $("#S_RegNo").keydown(function(e) {
        if (e.keyCode == 13) {
            RegNoChange();
        }
    });
}
/*
var VIPObj = $HUI.combobox("#S_VIPLevel",{
	url:$URL+"?ClassName=web.DHCPE.HISUICommon&QueryName=FindVIP&ResultSetType=array",
	valueField:'id',
	textField:'desc',
	onSelect:function(record){
	}
});
*/
//VIP-��Ժ��
var VIPObj = $HUI.combobox("#S_VIPLevel", {
    url: $URL + "?ClassName=web.DHCPE.CT.HISUICommon&QueryName=FindVIP&ResultSetType=array&LocID=" + session['LOGON.CTLOCID'],
    valueField: 'id',
    textField: 'desc'
});

var TypeObj = $HUI.combobox("#S_Type", {
    url: $URL + "?ClassName=web.DHCPE.WorkDistribution&QueryName=QueryWorkType&ResultSetType=array&Active=Y",
    valueField: 'TCode',
    textField: 'TDesc',
    editable: false,
    onSelect: function(record) {},
    onLoadSuccess: function(data) {
        if (data.length > 0) {
            $("#S_Type").combobox("setValue", data[0].TCode);
        }
    },
    onChange: TypeChange
});


var GIDObj = $HUI.combogrid("#S_GID", {
    panelWidth: 520,
    url: $URL + "?ClassName=web.DHCPE.PreGADM&QueryName=SearchPreGADMShort",
    mode: 'remote',
    delay: 200,
    idField: 'Hidden',
    textField: 'Name',
    onBeforeLoad: function(param) {
        param.Code = param.q;
    },
    onChange: function() {
        GTeamObj.clear();
    },
    columns: [
        [
            { field: 'Hidden', hidden: true },
            { field: 'Name', title: '��������', width: 140 },
            { field: 'Code', title: '����', width: 100 },
            { field: 'Begin', title: '��ʼ����', width: 100 },
            { field: 'End', title: '��ֹ����', width: 100 },
            { field: 'DelayDate', title: '״̬', width: 50 }
        ]
    ],
    pagination: true,
    pageSize: 20
});

var GTeamObj = $HUI.combogrid("#S_TeamID", {
    panelWidth: 260,
    url: $URL + "?ClassName=web.DHCPE.PreGTeam&QueryName=SearchGTeam",
    mode: 'remote',
    delay: 200,
    idField: 'PGT_RowId',
    textField: 'PGT_Desc',
    onBeforeLoad: function(param) {
        var PreGId = $("#S_GID").combogrid("getValue");
        param.ParRef = PreGId;
    },
    onShowPanel: function() {
        $('#S_TeamID').combogrid('grid').datagrid('reload');
    },
    columns: [
        [
            { field: 'PGT_RowId', hidden: true },
            { field: 'PGT_ParRef_Name', title: '��������', width: 140 },
            { field: 'PGT_Desc', title: '��������', width: 100 }
        ]
    ]
});


function TypeChange(newValue, oldValue) {
    _GV.FlowType = newValue;
    initDocKeys();
    initNoDistribute();
}

function clean_onclick() {
    $("#S_RegNo").val("");
    $("#S_VIPLevel").combobox("setValue", "");
    $("#S_GID").combogrid("setValue", "");
    $("#S_TeamID").combogrid("setValue", "");
    initDate();
    unselect_all_doc();
    find_onclick();
}

function initNoDistribute() {
    var NoDistributeDataGrid = $HUI.datagrid("#NoDistributeList", {
        url: $URL,
        bodyCls: 'panel-body-gray',
        singleSelect: false,
        queryParams: {
            ClassName: "web.DHCPE.WorkDistribution",
            QueryName: "QueryDistribution",
            RegNo: $("#S_RegNo").val(),
            BeginDate: $("#S_StartDate").datebox("getValue"),
            EndDate: $("#S_EndDate").datebox("getValue"),
            GroupDR: $("#S_GID").combogrid("getValue"),
            GTeamDR: $("#S_TeamID").combogrid("getValue"),
            VIPLevel: $("#S_VIPLevel").combobox("getValue"),
            Type: _GV.FlowType
        },
        onSelect: function(rowIndex, rowData) {

        },
        onDblClickRow: function(index, row) {

        },
        columns: [
            [
                { idField: 'TPAADM', hidden: true },
                { field: 'TCheck', checkbox: true },
                { field: 'TRegNo', width: 120, title: '�ǼǺ�' },
                { field: 'TPatName', width: 80, title: '����' },
                { field: 'TSex', width: 60, title: '�Ա�' },
                { field: 'TAge', width: 80, title: '����' },
                { field: 'TVIPLevel', width: 120, title: 'VIP�ȼ�' },
                { field: 'TCheckDate', width: 100, title: '�������' },
                { field: 'TStatus', width: 100, title: '״̬' },
                { field: 'TReportStatus', width: 100, title: '����״̬' }
            ]
        ],
        toolbar: [{
            id: "DistributeBtn",
            iconCls: 'icon-stamp-pass',
            text: '����',
            handler: distribute_handler
        }],
        fitColumns: true,
        pagination: true,
        pageSize: 50,
        fit: true
    });
}

function RegNoChange() {
    var CTLocID = session["LOGON.CTLOCID"];
    var RegNoLength = tkMakeServerCall("web.DHCPE.DHCPECommon", "GetRegNoLength", CTLocID);
    var iRegNo = $("#S_RegNo").val();
    if (iRegNo.length < RegNoLength && iRegNo.length > 0) {
        iRegNo = tkMakeServerCall("web.DHCPE.DHCPECommon", "RegNoMask", iRegNo, CTLocID);
        $("#S_RegNo").val(iRegNo);
    }
    find_onclick();
}

function initDocKeys() {
    _GV.WDocList = [], _GV.HDocList = [];
    unselect_all_doc();
    $.cm({
        wantreturnval: 1,
        ClassName: 'web.DHCPE.WorkDistribution',
        MethodName: 'GetDocKeysByType',
        Code: _GV.FlowType,
        LocID: session["LOGON.CTLOCID"]
    }, function(data) {
        if (data.length == 0) {
            $.messager.alert("��ʾ", "�÷���������û��ָ����ҽ��!", "info");
        }
        _GV.WDocList = data;
        $("#WDocKeys").pekeywords({
            labelCls: "blue",
            onSelect: select_doc,
            onUnselect: unselect_doc,
            items: data
        });
        $("#HDocKeys").pekeywords({
            onSelect: select_doc,
            onUnselect: unselect_doc,
            items: _GV.HDocList
        });
    });

}

/**
 * [ȫѡҽ��]
 * @Author   wangguoying
 * @DateTime 2021-01-29
 */
function select_all_doc() {
    $("#WDocKeys").find("li").each(function() {
        if (!$(this).hasClass("selected")) {
            $("#WDocKeys").pekeywords("select", this.id);
        }
    });
    $("#HDocKeys").find("li").each(function() {
        if (!$(this).hasClass("selected")) {
            $("#HDocKeys").pekeywords("select", this.id);
        }
    });
}
/**
 * [ȫ������ѡ��]
 * @Author   wangguoying
 * @DateTime 2021-01-29
 */
function unselect_all_doc() {
    $("#WDocKeys").find("li").each(function() {
        if ($(this).hasClass("selected")) {
            $("#WDocKeys").pekeywords("switchById", this.id);
        }
    });
    $("#HDocKeys").find("li").each(function() {
        if ($(this).hasClass("selected")) {
            $("#HDocKeys").pekeywords("switchById", this.id);
        }
    });
}
/**
 * [ѡ��ҽ��]
 * @param    {[Object]}    v [ѡ�еĽڵ�]
 * @Author   wangguoying
 * @DateTime 2021-01-29
 */
function select_doc(v) {
    createDocPanel(v);
}
/**
 * [����ѡ��ҽ��]
 * @param    {[Object]}    v [ѡ�еĽڵ�]
 * @Author   wangguoying
 * @DateTime 2021-01-29
 */
function unselect_doc(v) {
    var id = "TD_" + v.id;
    if (document.getElementById(id)) {
        $("#" + id).remove();
    }
}

/**
 * [��������ҽ���ѷ����б�]
 * @Author   wangguoying
 * @DateTime 2021-02-01
 */
function reSelectDoc() {
    var Wdocs = $("#WDocKeys").pekeywords("getSelected");
    var Hdocs = $("#HDocKeys").pekeywords("getSelected");
    unselect_all_doc();
    Wdocs.forEach(function(element, index) {
        $("#WDocKeys").pekeywords("switchById", element.id);
    });

    Hdocs.forEach(function(element, index) {
        $("#HDocKeys").pekeywords("switchById", element.id);
    });
}

/**
 * [����]
 * @Author   wangguoying
 * @DateTime 2021-01-30
 */
function distribute_handler() {
    var rows = $("#NoDistributeList").datagrid("getChecked");
    if (rows.length == 0) {
        $.messager.alert("��ʾ", "����ѡ����Ҫ����ļ�¼", "info");
        return false;
    }
    var docs = $("#WDocKeys").pekeywords("getSelected");
    var HDocs = $("#HDocKeys").pekeywords("getSelected");
    if (HDocs.length > 0) {
        docs.push(...HDocs);
    }
    if (docs.length == 0) {
        $.messager.alert("��ʾ", "δѡ�����ҽ��", "info");
        return false;
    }
    var admIds = "";
    rows.forEach(function(value, index, arr) {
        admIds = admIds != "" ? admIds + "^" + value.TPAADM : value.TPAADM;
    });
    var docIds = "";
    docs.forEach(function(value, index, arr) {
        var docParam = value.id + "," + (value.type ? value.type : "W");
        docIds = docIds != "" ? docIds + "^" + docParam : docParam;
    });
    var ret = tkMakeServerCall("web.DHCPE.WorkDistribution", "Distribute", docIds, admIds, _GV.FlowType, session["LOGON.USERID"]);
    if (ret != "") {
        $.messager.alert("����", $g("����ʧ��") + "��" + ret, "error");
        return false;
    } else {
        $.messager.alert("��ʾ", "����ɹ�", "success", function() {
            $("#NoDistributeList").datagrid("reload");
            reSelectDoc();
        });
    }

}


/**
 * [����ҽ�������б�]
 * @param    {[Object]}    docObj [ҽ���ؼ��ֶ���]
 * @Author   wangguoying
 * @DateTime 2021-01-30
 */
function createDocPanel(docObj) {
    if (docObj == "") return false;
    $cm({
        ClassName: "web.DHCPE.WorkDistribution",
        QueryName: "QueryDistribution",
        DoctorID: docObj.id,
        RegNo: $("#S_RegNo").val(),
        BeginDate: $("#S_StartDate").datebox("getValue"),
        EndDate: $("#S_EndDate").datebox("getValue"),
        GroupDR: $("#S_GID").combogrid("getValue"),
        GTeamDR: $("#S_TeamID").combogrid("getValue"),
        VIPLevel: $("#S_VIPLevel").combobox("getValue"),
        Type: _GV.FlowType
    }, function(rs) {
        paintDragDiv(docObj, rs);
    });
}

/**
 * [���Ϸ�����]
 * @param    {[Object]}    docObj [ҽ���ؼ���]
 * @param    {[Array]}    	rs     [ҽ���ѷ��伯��]
 * @Author   wangguoying
 * @DateTime 2021-01-30
 */
function paintDragDiv(docObj, rs) {
    var num = rs.total;
    var tdNums = $("#DistributeTR").find("td").length;
    // if(tdNums>2){
    // 	var width = (tdNums+1)*300;
    // 	$("#DistributeTab").css("width",width);
    // }
    var td = document.createElement("td");
    td.id = "TD_" + docObj.id;
    td.style.width = "300px";
    td.style.height = "100%";
    td.style.verticalAlign = "top";
    td.style.padding = '5px 0px 5px 5px';
    var drPanel = document.createElement("div");
    drPanel.id = "DragPanel_" + docObj.id;
    drPanel.className = "hisui-panel panel-header-gray droppable";
    drPanel.style.padding = '10px';
    var docType = docObj.type ? docObj.type == "H" ? "(����)" : "(ȫ��)" : "(ȫ��)"
    drPanel.title = "<span>" + docObj.text + docType + "</span>";
    drPanel.setAttribute("data-options", "fit:true,headerCls:'panel-header-card'");
    var tipDiv = document.createElement("div");
    tipDiv.style.width = '280px';
    tipDiv.style.textAlign = 'center';
    var HISUIStyleCode = tkMakeServerCall("websys.StandardTypeItem", "GetIdFromCodeOrDescription", "websys", "HISUIDefVersion");
    if (HISUIStyleCode == 'blue') {
        tipDiv.style.paddingTop = "10px";
    }
    var tip = "<a href='#'' onclick='deleteByDocDate(" + docObj.id + ");' style='background:#ee0f0f;border-radius:2px;margin:0 10px 5px 0;' class='hisui-linkbutton' >" + $g("��������") + "</a>";
    tip += "<div style='display:inline'>" + $g("��") + "<b><label style='color:red;' id='TIP_" + docObj.id + "'>" + num + "</label></b>" + $g("��") + "</div>"
    tipDiv.innerHTML = tip;
    $(drPanel).append(tipDiv);
    rs.rows.forEach(function(element, index) {
        var dragDiv = document.createElement("div");
        dragDiv.id = "DragDiv_" + element.TPAADM;
        if (element.TFinishStatus == $g("δ���")) {
            dragDiv.className = "drag hisui-tooltip";
        } else {
            dragDiv.className = "no-drag hisui-tooltip";
        }

        dragDiv.title = $g("�ǼǺ�") + "��" + element.TRegNo + "<br>" + $g("����") + "��" + element.TPatName + "<br>" + $g("����") + "��" + element.TAge + "<br>" + $g("VIP�ȼ�") + "��" + element.TVIPLevel + "<br>" + $g("����״̬") + "��" + element.TReportStatus + "<br>" + $g("���״̬") + "��" + element.TFinishStatus;
        var html = "<table style='width:100%; color:#ffffff;'><tr>";
        var sexImg = "";
        var HISUIStyleCode = tkMakeServerCall("websys.StandardTypeItem", "GetIdFromCodeOrDescription", "websys", "HISUIDefVersion");
        if (element.TSex == $g("��")) {
            if (HISUIStyleCode == "blue") {
                sexImg = "<img src='../images/man.png' />";
            } else {
                sexImg = "<img style='width:30px;height:30px;border-radius:30px;border:none;' src='../images/man_lite.png' />";
            }
        } else {
            if (HISUIStyleCode == "blue") {
                sexImg = "<img  src='../images/woman.png' />";
            } else {
                sexImg = "<img style='width:30px;height:30px;border-radius:30px;border:none;' src='../images/woman_lite.png' />";
            }
        }
        html += "<td style='width: 45px;'>" + sexImg + "</td>";
        var patName = element.TPatName;
        if (patName.length > 5) {
            patName = patName.substring(0, 4) + "*";
        }
        var baseInfo = "<td class='base autocut' style='width: 80px;'>" + patName + "</td>";
        //baseInfo+="<td class='base '>"+element.TAge+"abcdyһ����</td>";
        //baseInfo+="<td class='base'>"+element.TVIPLevel+"</td>"  
        baseInfo += "<td class='base' style='width:120px;'>" + element.TCheckDate + "</td>"
        if (element.TFinishStatus == $g("δ���")) {
            baseInfo += "<td class='base ' style='text-align:right;'><span style='cursor:pointer;top:2px;margin-right:5px;' class='icon-cancel' onclick='deletAdmByDoc(" + element.TPAADM + ")'>&nbsp;&nbsp;&nbsp;&nbsp;</span></td>"
        }
        html += baseInfo + "</tr></table>";
        dragDiv.innerHTML = html;
        $(drPanel).append(dragDiv);
    });
    $(td).append(drPanel);
    $("#DistributeTR").append(td);
    $.parser.parse("#TD_" + docObj.id); //�ػ�HISUI��ʽ	
    initDragEvent();
}

/**
 * [��������]
 * @param    {[int]}    admId [����]
 * @Author   wangguoying
 * @DateTime 2021-01-30
 */
function deletAdmByDoc(admId) {
    var docId = $("#DragDiv_" + admId)[0].parentNode.id.split("_")[1];
    var ret = tkMakeServerCall("web.DHCPE.WorkDistribution", "DeleteAdmDoc", admId, docId, _GV.FlowType)
    if (ret != "") {
        $.messager.alert("����", ret, "error");
        return false;
    }
    $("#DragDiv_" + admId).tooltip("hide");
    $("#DragDiv_" + admId).remove();
    $("#TIP_" + docId).html(parseInt($("#TIP_" + docId).html()) - 1);
    $("#NoDistributeList").datagrid("reload");
    $.messager.popover({ msg: '��������ɹ���', type: 'success', timeout: 1000 });
}

/**
 * [��������]
 * @param    {[int]}    docId [ҽ��ID]
 * @Author   wangguoying
 * @DateTime 2021-02-01
 */
function deleteByDocDate(docId) {
    var beginDate = $("#S_StartDate").datebox("getValue");
    var endDate = $("#S_EndDate").datebox("getValue");
    var ret = tkMakeServerCall("web.DHCPE.WorkDistribution", "DeleteByDocDate", docId, beginDate, endDate, _GV.FlowType);
    if (ret != "") {
        $.messager.alert("����", ret, "error");
        return false;
    }
    $("#WDocKeys").pekeywords("switchById", docId);
    $("#HDocKeys").pekeywords("switchById", docId);
    $("#NoDistributeList").datagrid("reload");
    $.messager.popover({ msg: '��������ɹ���', type: 'success', timeout: 1000 });
}

/**
 * [ȫ����������]
 * @Author   wangguoying
 * @DateTime 2021-02-01
 */
function undistribute_all() {
    if (_GV.FlowType == "") {
        $.messager.alert("��ʾ", "�޷�������", "info");
        return false;
    }
    var beginDate = $("#S_StartDate").datebox("getValue");
    var endDate = $("#S_EndDate").datebox("getValue");
    var ret = tkMakeServerCall("web.DHCPE.WorkDistribution", "DeleteByDate", beginDate, endDate, _GV.FlowType);
    if (ret != "") {
        $.messager.alert("����", ret, "error");
        return false;
    }
    $("#NoDistributeList").datagrid("reload");
    reSelectDoc();
    $.messager.popover({ msg: '��������ɹ���', type: 'success', timeout: 1000 });
}

/**
 * [�����Ϸ��¼�]
 * @Author   wangguoying
 * @DateTime 2021-01-30
 */
function initDragEvent() {
    $('.drag').draggable({
        proxy: 'clone',
        revert: true,
        cursor: 'Move',
        onStartDrag: function() {
            $(this).draggable('options').cursor = 'not-allowed';
            $(this).draggable('proxy').addClass('dp');
        },
        onStopDrag: function() {
            $(this).draggable('options').cursor = 'auto';
        }
    });
    $('.droppable').droppable({
        onDragEnter: function(e, source) {
            if (this.id == source.parentNode.id) return false;
            $(source).draggable('options').cursor = 'auto';
            $(source).draggable('proxy').css('border', '1px solid red');
            $(this).addClass('over');
        },
        onDragLeave: function(e, source) {
            if (this.id == source.parentNode.id) return false;
            $(source).draggable('options').cursor = 'not-allowed';
            $(source).draggable('proxy').css('border', '1px solid #ccc');
            $(this).removeClass('over');
        },
        onDrop: function(e, source) {
            if (this.id == source.parentNode.id) return false;

            var admId = source.id.split("_")[1];
            var sourceDoc = source.parentNode.id.split("_")[1];
            var targetDoc = this.id.split("_")[1];
            var ret = tkMakeServerCall("web.DHCPE.WorkDistribution", "Move", admId, sourceDoc, targetDoc, _GV.FlowType, session["LOGON.USERID"]);
            if (ret != "") {
                $.messager.alert("����", ret, "error");
                return false;
            }

            $("#TIP_" + sourceDoc).html(parseInt($("#TIP_" + sourceDoc).html()) - 1);
            $("#TIP_" + targetDoc).html(parseInt($("#TIP_" + targetDoc).html()) + 1);
            $(source).draggable('options').cursor = 'Move';
            $(this).append(source)
            $(this).removeClass('over');
            $.messager.popover({ msg: 'ת�Ƴɹ���', type: 'success', timeout: 1000 });
        }
    });
}


/**
 * [��ʼ������]
 * @Author   wangguoying
 * @DateTime 2021-01-28
 */
function initDate() {
    var now = new Date();
    var foramtNow = myformatter(now);
    var beginDate = new Date(now.setDate(now.getDate() - 60));
    var formatBegin = myformatter(beginDate);
    $('#S_StartDate').datebox('setValue', formatBegin);
    $("#S_EndDate").datebox('setValue', foramtNow);
}

/**
 * [��ʽ������]
 * @param    {[Date]}    date [����]
 * @return   {[String]}         [��ʽ��������]
 * @Author   wangguoying
 * @DateTime 2021-01-28
 */
function myformatter(date) {
    var y = date.getFullYear();
    var m = date.getMonth() + 1;
    var d = date.getDate();
    var ret = y + "-" + (m < 10 ? ('0' + m) : m) + "-" + (d < 10 ? ('0' + d) : d);
    return ret;
}


function find_onclick() {
    var type = $("#S_Type").combobox("getValue");
    if (type == "") {
        $.messager.alert("��ʾ", "�������Ͳ���Ϊ��", "info");
        return false;
    }
    $("#NoDistributeList").datagrid("load", {
        ClassName: "web.DHCPE.WorkDistribution",
        QueryName: "QueryDistribution",
        RegNo: $("#S_RegNo").val(),
        BeginDate: $("#S_StartDate").datebox("getValue"),
        EndDate: $("#S_EndDate").datebox("getValue"),
        GroupDR: $("#S_GID").combogrid("getValue"),
        GTeamDR: $("#S_TeamID").combogrid("getValue"),
        VIPLevel: $("#S_VIPLevel").combobox("getValue"),
        Type: _GV.FlowType
    });
    reSelectDoc();
}



/**
 * [���ò���]
 * @Author   wangguoying
 * @DateTime 2021-01-28
 */
function setLayout() {
    $(".panel-header.panel-header-gray").css("border-radius", "4px 4px 0 0");
    /** ������尴ť��ʽ */
    $(".icon-canel-distribute").html("<span class='pe-panel-tool'>" + $g("ȫ����������") + "</span>");
    $(".icon-canel-distribute").css("display", "inline");
    $(".icon-canel-distribute").css("vertical-align", "middle");
    $(".panel-tool").css("height", "30px");
    $(".panel-tool").css("margin-top", "-10px");
}

/** ����ҽ��  */
function doc_setting() {
    unselect_all_doc();
    var lnk = "dhcpe.splitcommon.csp"
    if (!document.getElementById("H_DragWin")) { $("<div id='H_DragWin' style='overflow:hidden;'></div>").appendTo($("body")); }
    $('#H_DragWin').dialog({
        title: '���',
        iconCls: "icon-w-switch",
        width: 620,
        height: 520,
        cache: false,
        closable: false,
        content: "<iframe id='H_Iframe_Drag' src='" + lnk + "' style='width:100%;height:100%;border:0' onload='drag_frame_loaded()'></iframe> ",
        modal: true,
        buttons: [{
            text: 'ȷ��',
            iconCls: 'icon-ok',
            handler: function() {
                get_split_list();
            }
        }, {
            text: '�ر�',
            iconCls: 'icon-cancel',
            handler: function() { $HUI.dialog('#H_DragWin').close(); }
        }]
    });
}


/** ҽ�����ô��ڼ������¼�  */
function drag_frame_loaded() {
    var dragWin = $("#H_Iframe_Drag")[0].contentWindow;
    _GV.WDocList.forEach((el, idx) => {
        dragWin.$("#LeftUR").append("<li id='" + el.id + "' class='dragable'>" + el.text + "</li>");
    });
    _GV.HDocList.forEach((el, idx) => {
        dragWin.$("#RightUR").append("<li id='" + el.id + "' class='dragable'>" + el.text + "</li>");
    });
    dragWin.init_drag_event();
}

/**
 * ��ȡ��ֺ�����ݼ���
 */
function get_split_list() {
    _GV.WDocList = [], _GV.HDocList = [];
    var dragWin = $("#H_Iframe_Drag")[0].contentWindow;
    dragWin.$("#LeftUR").find("li").each((idx, el) => {
        _GV.WDocList.push({
            id: $(el).attr("id"),
            text: $(el).text(),
            type: "W" //���ȫ��ҽ��
        });
    });
    dragWin.$("#RightUR").find("li").each((idx, el) => {
        _GV.HDocList.push({
            id: $(el).attr("id"),
            text: $(el).text(),
            labelCls: 'red', //���ñ���ɫ
            type: "H" //��ǰ���ҽ��
        });
    });
    renderDoc_after_split();
    $HUI.dialog('#H_DragWin').close();
}

/** ��ֺ�������Ⱦ */
function renderDoc_after_split() {
    $("#WDocKeys").pekeywords({
        onSelect: select_doc,
        onUnselect: unselect_doc,
        items: _GV.WDocList
    });
    $("#HDocKeys").pekeywords({
        onSelect: select_doc,
        onUnselect: unselect_doc,
        items: _GV.HDocList
    });
}

$(init);