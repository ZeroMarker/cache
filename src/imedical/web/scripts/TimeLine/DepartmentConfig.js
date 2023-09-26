//页面加载完毕，开始执行
//var delim = "|";
var accessURL = "extgetoutpatientdata.csp";
Ext.onReady(function() {
    ShowPage();
});

//显示页面
function ShowPage() {
    var ctrl1 = new Array();
    var ctrl2 = new Array();
    if (departmentNames) {
        var items = departmentNames.split("|");
        if (items) {
            for (var index = 0; index < items.length; index++) {
                var oneItem = items[index];
                var ctrlValue = items[index];
                var checkedValue = true;
                if (parent.ShowDepart != null && parent.ShowDepart != "") {
                    if (parent.ShowDepart.indexOf(ctrlValue) < 0) {
                        checkedValue = false;
                    }
                }
                var oneControl = new Ext.form.Checkbox({
                    id: "cbx" + index,
                    boxLabel: items[index],
                    checked: checkedValue,
                    submitValue:false,
                    value: ctrlValue
                });
                if (index % 2 > 0) {
                    ctrl2.push(oneControl);
                }
                else {
                    ctrl1.push(oneControl);
                }
            }
        }
    }
    var txtSearchCode = new Ext.form.TextField({
        id: "queryCode",
        hidden:true
    });
    ctrl1.push(txtSearchCode);
    var btnSet = new Ext.Button({
        id: "btnSet",
        text: "确定",
        height: 20,
        width: 80,
        handler: SetConfig
    });
    var btnSelectAll = new Ext.Button({
        id: "btnSelectAll",
        text: "全选",
        height: 20,
        width: 80,
        handler: SelectAll
    });
    var btnClearSelect = new Ext.Button({
        id: "btnClearSelect",
        text: "清空",
        height: 20,
        width: 80,
        handler: ClearSelect
    });
    var frmDepartConfig = new Ext.FormPanel({
        id: "frmDepartConfig",
        buttonAlign: 'center',
        applyTo: divMain,
        width: 500,
        labelWidth: 10,
        autoScroll:true,
        frame: true,
        title: '设定显示科室',
        onSubmit: Ext.emptyFn,
        //submit: FormSubmit,
        cls: '',
        items: [{layout:'column',
                 border: false,
                 cls:'',
                 items:[{
                 columnWidth:.5,
                 layout: 'form',
                 border:false,
                 items:ctrl1},
                 {
                 columnWidth:.5,
                 layout: 'form',
                 border:false,
                 items:ctrl2}]
        }],
        buttons: [btnSet, btnSelectAll, btnClearSelect]
    });
}

//设定显示项
function SetConfig() {
    var searchCode = "";
    var haveChange = false;
    if (departmentNames) {
        var items = departmentNames.split("|");
        if (items) {
            for (var index = 0; index < items.length; index++) {
                if (Ext.getCmp("cbx" + index).checked) {
                    if (searchCode != "") {
                        searchCode = searchCode + "|" + Ext.getCmp("cbx" + index).value;
                    }
                    else {
                        searchCode = Ext.getCmp("cbx" + index).value;
                    }
                }
                else {
                    haveChange = true;
                }
            }
        }
    
    if (searchCode == "" && items.length >0) {
        Ext.MessageBox.show({
            title: "提示信息",
            msg: "请您选择要显示的科室",
            width: 400,
            buttons: Ext.MessageBox.OK,
            icon: Ext.MessageBox.INFO
        });
        return;
    }
    SetDepartConfig(searchCode);
   }
}

//清空所有选择项
function SelectAll() {
    if (departmentNames) {
        var items = departmentNames.split("|");
        if (items) {
            for (var index = 0; index < items.length; index++) {
                if (!Ext.getCmp("cbx" + index).checked) {
                    Ext.getCmp("cbx" + index).setValue(true);
                }
                else {
                    //Ext.getCmp("cbx" + index).setValue(true);
                }
            }
        }
    }
}

//清空所有选择项
function ClearSelect() {
    if (departmentNames) {
        var items = departmentNames.split("|");
        if (items) {
            for (var index = 0; index < items.length; index++) {
                 Ext.getCmp("cbx" + index).setValue(false);
            }
        }
    }
}

//设定显示的科室
function SetDepartConfig(departNames) {
    var actionParams = { 'PatientID': patientID, 'DepartNames': departNames };
    Ext.Ajax.request({
        url: accessURL,
        success: SetConfigSuccess,
        failure: null,
        params: actionParams
    });
}

//设定成功
function SetConfigSuccess(resp, opts) {
    parent.SetShowDepart();
}