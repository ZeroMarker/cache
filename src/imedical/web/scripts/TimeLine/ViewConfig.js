//页面加载完毕，开始执行
Ext.onReady(function() {
    ShowPage();
});

//显示页面
function ShowPage() {
    var ctrl1 = new Array();
    var ctrl2 = new Array();
    if (CategroyData) {
        var items = CategroyData.CategroyConfig;
        if (items) {
            for (var index = 0; index < items.length; index++) {
                var oneItem = items[index];
                var ctrlValue = oneItem.CategroyCode + ":" + oneItem.DataTypeCode + ":" + oneItem.ViewType;
                var checkState = true;
                if (oldSearchCode != "") {
                    if (oldSearchCode.indexOf(ctrlValue) > -1) {
                        checkState = true;
                    }
                    else {
                        checkState = false;
                    }
                }
                var oneControl = new Ext.form.Checkbox({
                    id: "cbx" + index,
                    boxLabel: oneItem.DataTypeDesc,
                    checked: checkState,
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
        icon:'../images/uiimages/ok.png',
        height: 20,
        width: 80,
        handler: SetConfig
    });
    var btnSelectAll = new Ext.Button({
        id: "btnSelectAll",
        text: "全选",
        height: 20,
        width: 80,
        icon:'../images/uiimages/all_selected.png',
        handler: SelectAll
    });
    var btnClearSelect = new Ext.Button({
        id: "btnClearSelect",
        text: "取消全选",
        height: 20,
        width: 110,
        icon:'../images/uiimages/cancel_all_selected.png',
        handler: ClearSelect
    });
    var frmArea = new Ext.FormPanel({
        id: "frmViewConfig",
        buttonAlign: 'center',
        applyTo: divMain,
        width: 500,
        labelWidth:10,
        frame: true,
        title: '设定显示项',
        onSubmit: Ext.emptyFn,
        submit: FormSubmit,
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
    if (CategroyData) {
        var items = CategroyData.CategroyConfig;
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
            }
        }
    }
    if (searchCode == "") {
        Ext.MessageBox.show({
            title: "提示信息",
            msg: "请您选择要显示的数据",
            width: 400,
            buttons: Ext.MessageBox.OK,
            icon: Ext.MessageBox.INFO
        });
        return;
    }
    Ext.getCmp("queryCode").setValue(searchCode);
    Ext.getCmp("frmViewConfig").form.submit();
}

//提交
function FormSubmit() {
    this.getEl().dom.action = location.href.replace("&SettingFlg=1","");
    this.getEl().dom.submit();
}

//清空所有选择项
function SelectAll() {
    if (CategroyData) {
        var items = CategroyData.CategroyConfig;
        if (items) {
            for (var index = 0; index < items.length; index++) {
                if (!Ext.getCmp("cbx" + index).checked) {
                    Ext.getCmp("cbx" + index).setValue(true);
                }
            }
        }
    }
}

//清空所有选择项
function ClearSelect() {
    if (CategroyData) {
        var items = CategroyData.CategroyConfig;
        if (items) {
            for (var index = 0; index < items.length; index++) {
                Ext.getCmp("cbx" + index).setValue(false);
            }
        }
    }
}