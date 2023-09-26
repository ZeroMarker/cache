///名称: 库存分类维护
///描述: 库存分类维护
///编写者：zhangxiao
///编写日期: 2013.10.17
function addNewRow() {
    var record = Ext.data.Record.create([
        {
            name: 'RowId',
            type: 'int'
        },
        {
            name: 'Code',
            type: 'string'
        },
        {
            name: 'Desc',
            type: 'string'
        }
    ]);
    var NewRecord = new record({
        RowId: '',
        Code: '',
        Desc: ''
    });
    StkCatGriDs.add(NewRecord);
    StkCatGrid.startEditing(StkCatGriDs.getCount() - 1, 1);
}
var StkCatGrid = '';
//配置数据源
var StkCatGridUrl = 'dhcst.stkcataction.csp';
var StkCatGridProxy = new Ext.data.HttpProxy({ url: StkCatGridUrl + '?actiontype=query', method: 'POST' });
var StkCatGriDs = new Ext.data.Store({
    proxy: StkCatGridProxy,
    reader: new Ext.data.JsonReader(
        {
            root: 'rows',
            totalProperty: 'results',
            pagesize: 35
        },
        [{ name: 'RowId' }, { name: 'Code' }, { name: 'Desc' }]
    ),
    remoteSort: true,
    pruneModifiedRecords: true
});
//模型
var StkCatGridCm = new Ext.grid.ColumnModel([
    new Ext.grid.RowNumberer(),
    {
        header: '代码',
        dataIndex: 'Code',
        width: 180,
        align: 'left',
        sortable: true,
        editor: new Ext.form.TextField({
            id: 'codeField',
            allowBlank: false,
            listeners: {
                specialKey: function (field, e) {
                    if (e.getKey() == Ext.EventObject.ENTER) {
                        StkCatGrid.startEditing(StkCatGriDs.getCount() - 1, 2);
                    }
                }
            }
        })
    },
    {
        header: '名称',
        dataIndex: 'Desc',
        width: 300,
        align: 'left',
        sortable: true,
        editor: new Ext.form.TextField({
            id: 'descField',
            allowBlank: false,
            listeners: {
                specialKey: function (field, e) {
                    if (e.getKey() == Ext.EventObject.ENTER) {
                        addNewRow();
                    }
                }
            }
        })
    }
]);
//初始化默认排序功能
StkCatGridCm.defaultSortable = true;
var addStkCat = new Ext.Toolbar.Button({
    text: '新建',
    tooltip: '新建',
    iconCls: 'page_add',
    width: 70,
    height: 30,
    handler: function () {
        addNewRow();
    }
});
var saveStkCat = new Ext.Toolbar.Button({
    text: '保存',
    tooltip: '保存',
    iconCls: 'page_save',
    width: 70,
    height: 30,
    handler: function () {
        if (HospId == '') {
            Msg.info('warning', '请先选择医院!');
            return false;
        }
        //获取所有的新记录
        var mr = StkCatGriDs.getModifiedRecords();
        var data = '';
        for (i = 0; i < mr.length; i++) {
            var code = mr[i].data['Code'].trim();
            var desc = mr[i].data['Desc'].trim();
            if (code != '' && desc != '') {
                var dataRow = mr[i].data['RowId'] + '^' + code + '^' + desc;
                if (data == '') {
                    data = dataRow;
                } else {
                    data = data + xRowDelim() + dataRow;
                }
            }
        }

        if (data == '') {
            Msg.info('error', '没有修改或添加新数据!');
            return false;
        } else {
            var mask = ShowLoadMask(Ext.getBody(), '处理中请稍候...');
            Ext.Ajax.request({
                url: StkCatGridUrl + '?actiontype=save',
                params: { data: data },
                failure: function (result, request) {
                    mask.hide();
                    Msg.info('error', '请检查网络连接!');
                },
                success: function (result, request) {
                    var jsonData = Ext.util.JSON.decode(result.responseText);
                    mask.hide();
                    if (jsonData.success == 'true') {
                        Msg.info('success', '保存成功!');
                        StkCatGriDs.load();
                    } else {
                        Msg.info('warning', jsonData.info);
                        StkCatGriDs.load();
                    }
                },
                scope: this
            });
        }
    }
});

var deleteStkCat = new Ext.Toolbar.Button({
    text: '删除',
    tooltip: '删除',
    iconCls: 'page_delete',
    width: 70,
    height: 30,
    handler: function () {
        if (HospId == '') {
            Msg.info('warning', '请先选择医院!');
            return false;
        }
        deleteDetail();
    }
});
//删除函数
function deleteDetail() {
    var cell = StkCatGrid.getSelectionModel().getSelectedCell();
    if (cell == null) {
        Msg.info('error', '请选择数据!');
        return false;
    } else {
        var record = StkCatGrid.getStore().getAt(cell[0]);
        var RowId = record.get('RowId');
        if (RowId != '') {
            Ext.MessageBox.confirm('提示', '确定要删除选定的行?', function (btn) {
                if (btn == 'yes') {
                    var mask = ShowLoadMask(Ext.getBody(), '处理中请稍候...');
                    Ext.Ajax.request({
                        url: StkCatGridUrl + '?actiontype=delete&rowid=' + RowId,
                        waitMsg: '删除中...',
                        failure: function (result, request) {
                            mask.hide();
                            Msg.info('error', '请检查网络连接!');
                        },
                        success: function (result, request) {
                            var jsonData = Ext.util.JSON.decode(result.responseText);
                            mask.hide();
                            if (jsonData.success == 'true') {
                                Msg.info('success', '删除成功!');
                                StkCatGriDs.load();
                            } else {
                                Msg.info('error', '删除失败!');
                            }
                        },
                        scope: this
                    });
                }
            });
        } else {
            var rowInd = cell[0];
            if (rowInd >= 0) {
                StkCatGrid.getStore().removeAt(rowInd);
            }
        }
    }
}
//表格
StkCatGrid = new Ext.grid.EditorGridPanel({
    store: StkCatGriDs,
    cm: StkCatGridCm,
    trackMouseOver: true,
    region: 'center',
    height: 690,
    stripeRows: true,
    sm: new Ext.grid.CellSelectionModel({}),
    loadMast: true,
    tbar: [addStkCat, '-', saveStkCat], //,'-',deleteStkCat],
    clicksToEdit: 1
});
StkCatGriDs.load();

var HospPanel = InitHospCombo('INC_StkCat',function(combo, record, index){
	HospId = this.value; 
	StkCatGriDs.reload();	
});
//===========模块主页面===============================================
Ext.onReady(function () {
    Ext.QuickTips.init();
    Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;

    var HisListTab = new Ext.form.FormPanel({
        labelwidth: 30,
        height: 30,
        labelAlign: 'right',
        title: '库存分类维护',
        region: 'center',
        frame: true,
        autoHeight: true
    });
    // 5.2.页面布局
    var mainPanel = new Ext.Viewport({
        layout: 'border',
        items: [
            HisListTab,
			HospPanel,
            {
                id: 'stkcat',
                region: 'center',
                title: '库存分类',
                layout: 'fit', // specify layout manager for items
                items: StkCatGrid
            }
        ],
        renderTo: 'mainPanel'
    });
});

//===========模块主页面===============================================
