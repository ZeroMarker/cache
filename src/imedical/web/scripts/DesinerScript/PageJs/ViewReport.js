// 设定访问地址
var accessURL = "../../web/web.DHCPrintDesigner.cls";
var SC_CHILD_WINDOW = null;

Ext.onReady(function() {
    ShowPage();
    Ext.getCmp("gridReport").loadData();
    window.onunload = SC_WinClose;
});

function ShowPage() {
    var allItems = InitControl();
    var frmReport = new Ext.form.FormPanel({
        width: '100%',
        height: 600,
        id: 'frmReport',
        layout: 'absolute',
        renderTo: Ext.getBody(),
        region: 'center',
        frame: true,
        items: allItems
    });
}

function InitControl() {
    var controls = new Array();
    var btnArray = InitGridButtons();
    var gridReport = new FW.Ctrl.ListGrid({
        allColumns: [{ header: 'ID', dataIndex: 'ID', sortable: false, width: 50 },
        { header: '标识', dataIndex: 'XPC_Flag', sortable: false, width: 150 },
        { header: '备注', dataIndex: 'XPC_Note1', sortable: false, width: 300}],
        queryParams: { 'ExcuteAction': 'ReadAll'},
        buttons: [btnArray],
        id: 'gridReport',
        width: 541,
        height: 413,
        x: '100',
        y: '80',
        title: '报表列表',
        queryUrl: accessURL,
        queryCtrlId: 'txtReport',
        pageSize: 30,
        showRowNo: false
    });
    controls.push(gridReport);

    var lblReportName = new Ext.form.Label({
        id: 'lblReportName',
        width: 66,
        height: 20,
        x: '200',
        y: '32',
        text: '报表名：'
    });
    controls.push(lblReportName);

    var txtReport = new FW.Ctrl.TextBox({
        id: 'txtReport',
        name: 'reportName',
        width: 130,
        height: 20,
        submitValue: false,
        x: '260',
        y: '30'
    });
    controls.push(txtReport);

    var btnSeach = new Ext.Button({
        id: 'btnSeach',
        width: 80,
        x: '480',
        y: '30',
        text: '查询',
        handler: SearchData
    });

    controls.push(btnSeach);
    return controls;
}


function InitGridButtons() {
    var btnCreateReport = new Ext.Button({ id: 'btnCreateReport', text: '新建报表', width: 80, handler: CreateReport });
    var btnOpenReport = new Ext.Button({ id: 'btnOpenReport', text: '修改报表', width: 80, handler: OpenReport });
    var btnDeleteReport = new Ext.Button({ id: 'btnDeleteReport', text: '删除报表', width: 80, handler: DeleteReport });
    return [btnCreateReport, btnOpenReport,btnDeleteReport];
}

//需要实现的方法
function CreateReport() {
    if (SC_IsHasChild()) {
        return;
    }
	//&accessURL=" + encodeURI(accessURL)
    SC_WinOpenWithSize("Desiner/DesinerPage.csp?action=Add", "报表设计", "960px", "700px");
}

function OpenReport() {
    if (SC_IsHasChild()) {
        return;
    }
    var rows = Ext.getCmp("gridReport").getSelectionModel().getSelections();
    if (rows.length == 0 || rows.length > 1) {
        FW.CommonMethod.ShowMessage("I", "请你选择一行数据进行操作！");
        return;
    }
    ReportID = rows[0].get("ID");
    var reportNote = rows[0].get("XPC_Note1");
    var reportName = rows[0].get("XPC_Flag");
	//+ "&accessURL=" + encodeURI(accessURL)
    SC_WinOpenWithSize("Desiner/DesinerPage.csp?action=Update&reportId=" + ReportID + "&reportNote=" + encodeURI(reportNote) + "&reportName=" + reportName , "报表设计", "960px", "700px");
}

function DeleteReport() {
    var rows = Ext.getCmp("gridReport").getSelectionModel().getSelections();
    if (rows.length == 0) {
        FW.CommonMethod.ShowMessage("I", "请至少选择一行数据！");
        return;
    }
    FW.CommonMethod.ShowConfirmMessage("确实要删除所选的记录吗?", DeleteData);
}

function DeleteData(btn) {
    if (btn == "ok") {
        var rows = Ext.getCmp("gridReport").getSelectionModel().getSelections();
        var deleteId = "";
        for (var index = 0; index < rows.length; index++) {
            if (index == 0) {
                deleteId = rows[index].get("ID");
            }
            else {
                deleteId = rows[index].get("ID");
            }
        }

        var actionParams = { 'ExcuteAction': 'Delete', 'reportID': deleteId };
        FW.CommonMethod.SubmitForm("frmReport", actionParams, "gridReport");
    }
}

function SearchData() {
    Ext.getCmp("gridReport").loadData();
}

//打开画面(指定大小)
function SC_WinOpenWithSize(url, name, width, height) {
    var wndWidth = width.toString().replace("px", "");
    var wndHeight = height.toString().replace("px", "");

    var wndLeft = Math.round((screen.width - wndWidth) / 2);
    var wndTop = Math.round((screen.height - wndHeight) / 2);
    newUrl = url;

    SC_CHILD_WINDOW = window.open(newUrl, name, "width=" + width + ",height=" + height + ", statusbar=no,menubar=no,toolbar=no,resizable=yes,left=" + wndLeft + ",top=" + wndTop);
}

//检查是否存在子画面
function SC_IsHasChild() {
    if (SC_CHILD_WINDOW == null) return false;
    if (SC_CHILD_WINDOW.closed == true) {
        SC_CHILD_WINDOW = null;
        return false;
    }
    return true;
}

//关闭画面
function SC_WinClose() {
    if (SC_CHILD_WINDOW != null) {
        SC_CHILD_WINDOW.close();
        SC_CHILD_WINDOW = null;
    }
}

