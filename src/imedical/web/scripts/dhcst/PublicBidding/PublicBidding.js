// 名称:招标名称维护
// 编写日期:2017-07-27

var ActiveFlag = new Ext.grid.CheckColumn({
    header: '启用',
    align: 'center',
    dataIndex: 'ActiveFlag',
    width: 80,
    sortable: true
});
var PublicBiddingDetailGrid = '';
//配置数据源
var Url = 'dhcst.publicbidding.action.csp';
var PublicBiddingDetailGridProxy = new Ext.data.HttpProxy({ url: Url + '?actiontype=GetPublicBidding', method: 'POST' });
var PublicBiddingDetailGridDs = new Ext.data.Store({
    proxy: PublicBiddingDetailGridProxy,
    reader: new Ext.data.JsonReader(
        {
            totalProperty: 'results',
            root: 'rows'
        },
        [{ name: 'RowID' }, { name: 'Code' }, { name: 'Desc' }, { name: 'Tenderee' }, { name: 'Date', type: 'date', dateFormat: App_StkDateFormat }, { name: 'EfficDateFrom', type: 'date', dateFormat: App_StkDateFormat }, { name: 'EfficDateTo', type: 'date', dateFormat: App_StkDateFormat }, { name: 'Type' }, { name: 'Remark' }, { name: 'ActiveFlag' }, { name: 'Level' }]
    ),
    pruneModifiedRecords: true,
    remoteSort: false
});

//模型
var nm = new Ext.grid.RowNumberer();
var PublicBiddingDetailGridCm = new Ext.grid.ColumnModel([
    nm,
    {
        header: 'RowID',
        dataIndex: 'RowID',
        width: 50,
        sortable: true,
        hidden: true
    },
    {
        header: '代码',
        dataIndex: 'Code',
        width: 100,
        sortable: true,
        editor: new Ext.form.TextField({
            id: 'codeField',
            allowBlank: false,
            listeners: {
                specialKey: function(field, e) {
                    if (e.getKey() == Ext.EventObject.ENTER) {
                        DetailGrid.startEditing(PublicBiddingDetailGridDs.getCount() - 1, 3);
                    }
                }
            }
        })
    },
    {
        header: '名称',
        dataIndex: 'Desc',
        width: 200,
        sortable: false,
        editor: new Ext.form.TextField({
            id: 'descField',
            allowBlank: false,
            listeners: {
                specialKey: function(field, e) {
                    if (e.getKey() == Ext.EventObject.ENTER) {
                        AddNewRow();
                    }
                }
            }
        })
    },
    {
        header: '代理机构名称',
        dataIndex: 'Tenderee',
        width: 200,
        sortable: true,
        editor: new Ext.form.TextField({
            id: 'tendereeField',
            allowBlank: true,
            listeners: {
                specialKey: function(field, e) {
                    if (e.getKey() == Ext.EventObject.ENTER) {
                        AddNewRow();
                    }
                }
            }
        })
    },
    {
        header: '招标日期',
        dataIndex: 'Date',
        width: 100,
        align: 'center',
        sortable: true,
        renderer: Ext.util.Format.dateRenderer(App_StkDateFormat),
        editor: new Ext.ux.DateField({
            allowBlank: false,
            listeners: {
                specialKey: function(field, e) {
                    if (e.getKey() == Ext.EventObject.ENTER) {
                        AddNewRow();
                    }
                }
            }
        })
    },
    {
        header: '开始日期',
        dataIndex: 'EfficDateFrom',
        width: 100,
        align: 'center',
        sortable: false,
        renderer: Ext.util.Format.dateRenderer(App_StkDateFormat),
        editor: new Ext.ux.DateField({
            id: 'efficDateFromField',
            allowBlank: false,
            listeners: {
                specialKey: function(field, e) {
                    if (e.getKey() == Ext.EventObject.ENTER) {
                        AddNewRow();
                    }
                }
            }
        })
    },
    {
        header: '结束日期',
        dataIndex: 'EfficDateTo',
        width: 100,
        align: 'center',
        sortable: true,
        renderer: Ext.util.Format.dateRenderer(App_StkDateFormat),
        editor: new Ext.ux.DateField({
            id: 'efficDateToField',
            allowBlank: false,
            listeners: {
                specialKey: function(field, e) {
                    if (e.getKey() == Ext.EventObject.ENTER) {
                        AddNewRow();
                    }
                }
            }
        })
    },
    ActiveFlag,
    {
        header: '备注',
        dataIndex: 'Remark',
        width: 100,
        sortable: false,
        editor: new Ext.form.TextField({
            id: 'remarkField',
            allowBlank: true,
            listeners: {
                specialKey: function(field, e) {
                    if (e.getKey() == Ext.EventObject.ENTER) {
                        AddNewRow();
                    }
                }
            }
        })
    }
    /*,{
		header:'等级',
		dataIndex:'Level',
		width:100,
		sortable:true,
		editor: new Ext.form.TextField({
			id:'levelField',
            allowBlank:false,
			listeners:{
				specialKey:function(field, e) {
					if (e.getKey() == Ext.EventObject.ENTER) {
						AddNewRow();
					}
				}
			}
        })
	}*/
]);

//初始化默认排序功能
PublicBiddingDetailGridCm.defaultSortable = true;

var AddBT = new Ext.Toolbar.Button({
    text: '增加',
    tooltip: '增加',
    iconCls: 'page_add',
    width: 70,
    height: 30,
    handler: function() {
        AddNewRow();
    }
});

var SaveBT = new Ext.Toolbar.Button({
    text: '保存',
    tooltip: '保存',
    iconCls: 'page_save',
    width: 70,
    height: 30,
    handler: function() {
        SaveRow();
    }
});

var DelBT = new Ext.Toolbar.Button({
    text: '删除',
    tooltip: '删除',
    iconCls: 'page_delete',
    width: 70,
    height: 30,
    handler: function() {
        DelRow();
    }
});

//=========================招标名称=============================

///增加
function AddNewRow() {
    var rowCount = PublicBiddingDetailGrid.getStore().getCount();
    if (rowCount > 0) {
        var rowData = PublicBiddingDetailGridDs.data.items[rowCount - 1];
        if (rowData.get('RowID') == '') {
            Msg.info('warning', '已存在新建行!');
            return;
        }
    }

    var record = Ext.data.Record.create([
        {
            name: 'RowID',
            type: 'int'
        },
        {
            name: 'Code',
            type: 'string'
        },
        {
            name: 'Desc',
            type: 'string'
        },
        {
            name: 'Tenderee',
            type: 'string'
        },
        {
            name: 'Date',
            type: 'date'
        },
        {
            name: 'EfficDateFrom',
            type: 'date'
        },
        {
            name: 'EfficDateTo',
            type: 'date'
        },
        {
            name: 'Type',
            type: 'string'
        },
        {
            name: 'Remark',
            type: 'string'
        },
        {
            name: 'ActiveFlag',
            type: 'string'
        },
        {
            name: 'Level',
            type: 'string'
        }
    ]);
    var NewRecord = new record({
        RowID: '',
        Code: '',
        Desc: '',
        Tenderee: '',
        Date: '',
        EfficDateFrom: '',
        EfficDateTo: '',
        Type: '',
        Remark: '',
        ActiveFlag: '',
        Level: ''
    });

    PublicBiddingDetailGridDs.add(NewRecord);
    PublicBiddingDetailGrid.startEditing(PublicBiddingDetailGridDs.getCount() - 1, 2);
}

///保存
function SaveRow() {
    if (HospId == '') {
        Msg.info('warning', '请先选择医院!');
        return false;
    }
    //获取所有的新记录
    var mr = PublicBiddingDetailGridDs.getModifiedRecords();
    var ListData = '';
    for (var i = 0; i < mr.length; i++) {
        var code = mr[i].data['Code'].trim();
        var desc = mr[i].data['Desc'].trim();
        var tenderee = mr[i].data['Tenderee'].trim();
        var date = mr[i].data['Date'];
        date = date != '' ? Ext.util.Format.date(date, App_StkDateFormat) : '';
        var efficdatefromb, efficdatetob;
        var efficdatefrom = mr[i].data['EfficDateFrom'];
        if (efficdatefrom != '') {
            efficdatefromb = Ext.util.Format.date(efficdatefrom, 'Y-m-d');
            efficdatefrom = Ext.util.Format.date(efficdatefrom, App_StkDateFormat);
        }
        var efficdateto = mr[i].data['EfficDateTo'];
        if (efficdateto != '') {
            efficdatetob = Ext.util.Format.date(efficdateto, 'Y-m-d');
            efficdateto = Ext.util.Format.date(efficdateto, App_StkDateFormat);
        }
        if (efficdatetob != '' && efficdatefromb != '' && efficdatetob < efficdatefromb) {
            Msg.info('warning', desc + ',结束日期小于开始日期!');
            return;
        }
        var type = mr[i].data['Type'].trim();
        var remark = mr[i].data['Remark'].trim();
        var activeflag = mr[i].data['ActiveFlag'];
        var level = mr[i].data['Level'].trim();
        if (code != '' && desc != '') {
            var dataRow = mr[i].data['RowID'] + '^' + code + '^' + desc + '^' + tenderee + '^' + date + '^' + efficdatefrom + '^' + efficdateto + '^' + type + '^' + remark + '^' + activeflag + '^' + level;
            ListData = ListData == '' ? dataRow : ListData + '#' + dataRow;
        }
    }
    if (ListData == '') {
        Msg.info('warning', '没有修改或添加新数据!');
        return false;
    } else {
        var mask = ShowLoadMask(Ext.getBody(), '处理中请稍候...');
        Ext.Ajax.request({
            url: Url + '?actiontype=SavePublicBidding',
            params: { ListData: ListData },
            failure: function(result, request) {
                mask.hide();
                Msg.info('error', '请检查网络连接!');
            },
            success: function(result, request) {
                var jsonData = Ext.util.JSON.decode(result.responseText);
                mask.hide();
                if (jsonData.success == 'true') {
                    Msg.info('success', '保存成功!');
                    PublicBiddingDetailGridDs.load({ params: { start: 0, limit: 30 } });
                } else {
                    var errMsg = jsonData.info;
                    if (errMsg.indexOf('^') >= 0) {
                        errMsg = errMsg.split('^')[1];
                    }
                    Msg.info('error', '保存失败,' + errMsg);
                    //PublicBiddingDetailGridDs.load({params:{start:0,limit:30}});
                }
            },
            scope: this
        });
    }
}

///删除
function DelRow() {
    if (HospId == '') {
        Msg.info('warning', '请先选择医院!');
        return false;
    }
    var cell = PublicBiddingDetailGrid.getSelectionModel().getSelectedCell();
    if (cell == null) {
        Msg.info('warning', '请选择数据!');
        return false;
    } else {
        var record = PublicBiddingDetailGrid.getStore().getAt(cell[0]);
        var RowId = record.get('RowID');
        if (RowId != '') {
            Ext.MessageBox.confirm('提示', '确定要删除选定的行?', function(btn) {
                if (btn == 'yes') {
                    var mask = ShowLoadMask(Ext.getBody(), '处理中请稍候...');
                    Ext.Ajax.request({
                        url: Url + '?actiontype=DelPublicBidding&RowId=' + RowId,
                        waitMsg: '删除中...',
                        failure: function(result, request) {
                            mask.hide();
                            Msg.info('error', '请检查网络连接!');
                        },
                        success: function(result, request) {
                            var jsonData = Ext.util.JSON.decode(result.responseText);
                            mask.hide();
                            if (jsonData.success == 'true') {
                                Msg.info('success', '删除成功!');
                                PublicBiddingDetailGridDs.load({ params: { start: 0, limit: 30 } });
                            } else {
                                Msg.info('error', '删除失败!');
                            }
                        },
                        scope: this
                    });
                }
            });
        } else {
            Ext.MessageBox.confirm('提示', '确定要删除选定的行?', function(btn) {
                if (btn == 'yes') {
                    PublicBiddingDetailGridDs.remove(record);
                }
            });
        }
    }
}

//表格
var PublicBiddingDetailGrid = new Ext.grid.EditorGridPanel({
    id: 'DetailGrid',
    height: 770,
    region: 'center',
    store: PublicBiddingDetailGridDs,
    loadMask: true,
    cm: PublicBiddingDetailGridCm,
    sm: new Ext.grid.CellSelectionModel({}),
    takeMouseOver: true,
    clicksToEdit: 1,
    plugins: [ActiveFlag],
    tbar: [AddBT, '-', SaveBT, '-', DelBT]
});

PublicBiddingDetailGridDs.load({
    params: { start: 0, limit: 30  },
    callback: function(o, response, success) {
        if (success == false) {
            Ext.MessageBox.alert('查询错误', PublicBiddingDetailGridDs.reader.jsonData.Error);
        }
    }
});

var HospPanel = InitHospCombo('DHC_PublicBiddingList',function(combo, record, index){
	HospId = this.value; 
	PublicBiddingDetailGridDs.reload();
});
//=========================招标名称=============================

//===========模块主页面===============================================
Ext.onReady(function() {
    Ext.QuickTips.init();
    Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
    
    var panel = new Ext.Panel({
	    id:"panel",
        title: '招标名称维护',
        activeTab: 0,
        region: 'center',
        items: [PublicBiddingDetailGrid]
    });

    var mainPanel = new Ext.Viewport({
        layout: 'border',
        items: [HospPanel,panel]
    });
});
//===========模块主页面===============================================
