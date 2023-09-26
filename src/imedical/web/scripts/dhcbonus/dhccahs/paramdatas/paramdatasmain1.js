var paramDatasUrl = 'dhc.ca.paramdatasexe.csp';
var paramDatasProxy = new Ext.data.HttpProxy({
    url: paramDatasUrl + '?action=list'
});
var monthDr = "";
var itemDr = "";
/////////
//tmpItemType:itemType根据情况修改
var tmpItemType = 3;
/////////
//tmpUnitDr:UnitDr根据情况修改
var tmpUnitDr = 1;

/////////////////王莹///上传///////////////////
var editAAccCycleButton  = new Ext.Toolbar.Button({
		text: '上传文件',
		tooltip: '上传',
		iconCls: 'remove',
		handler: function(){editAAccCycleFun();}
});

var typeStore = new Ext.data.SimpleStore({
	fields: ['key','keyValue'],
	data : [['3','参数数据-供应室'],['4','参数数据-电工班'],['5','参数数据-电话班'],['7','参数数据-接诊'],['8','参数数据-技工'],['9','参数数据-司机'],['B','参数数据-洗衣'],['C','参数数据-院容'],['D','参数数据-门诊人次']]
});
var typeField = new Ext.form.ComboBox({
	id: 'typeField',
	fieldLabel: '导入数据类型',
	listWidth : 200,
	selectOnFocus: true,
	allowBlank: false,
	store: typeStore,
	anchor: '90%',
	value:'Y', //默认值
	valueNotFoundText:'导入数据类型',
	displayField: 'keyValue',
	valueField: 'key',
	triggerAction: 'all',
	emptyText:'选择标志...',
	mode: 'local', //本地模式
	editable:false,
	pageSize: 10,
	minChars: 1,
	selectOnFocus: true,
	forceSelection: true
});
var excelButton = new Ext.Toolbar.Button({
	id:'excelButton',
	text:'数据导入',        
	tooltip:'导入',
	iconCls:'add',        
	handler: function(){ 
				//location.href = 'http://localhost:8080/etl/CostTrance';	
				var r=confirm("确定要导入数据吗？");
				if(r==true)
				{
				if(typeField.getValue()==""){
				  Ext.Msg.show({title:'错误',msg:'请选择类型',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
      			  return;
				}
				
				var user = session['LOGON.USERID'];
				var data = "";
				var type = typeField.getValue()
				if((type=="1")||(type=="2")){
				   data = monthDr;
				}
				else{
				   data = monthDr+'^'+user+'^load'+'^'+itemDr;
				}
				Ext.Ajax.request({
								url:ServletURL+'/etl/CostTrance?data='+data+'&type='+type,
								waitMsg:'正在导入...',
								failure: function(result, request) {
								Ext.Msg.show({title:'提示',msg:'错误',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							    },
								success: function(result,request){
								
                                var jsonData = Ext.util.JSON.decode( result.responseText );
								//alert(jsonData.success);
								var suc=jsonData.success;
						  	   if (suc) {
							   alert
						  		Ext.Msg.show({title:'提示',msg:jsonData.message,buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
								}
								else
								{
								  Ext.Msg.show({title:'错误',msg:jsonData.message,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
								}
								}
							});
							}
		}
});
///////////////////////////////////////////////

function formatDate(value){
    return value ? value.dateFormat('Y-m-d') : '';
};
var paramDatasDs = new Ext.data.Store({
    proxy: paramDatasProxy,
    reader: new Ext.data.JsonReader({
        root: 'rows',
        totalProperty: 'results'
    }, ['rowid', 'intervalDr', 'intervalName', 'itemDr', 'itemCode', 'itemName', 'servDeptDr', 'servDeptCode', 'servDeptName', 'servedDeptDr', 'servedDeptCode', 'servedDeptName', 'value', 'inType', 'inPersonDr', 'inPersonName', 'remark', {
        name: 'inDate',
        type: 'date',
        dateFormat: 'Y-m-d'
    }, 'outServDeptCode', 'outServDeptName', 'outServedDeptCode', 'outServedDeptName', 'outItemCode', 'outItemName', 'fDocCode', 'fDocName', 'fDocDr', 'fInDocName']),
    // turn on remote sorting 
    remoteSort: true
});

paramDatasDs.setDefaultSort('rowid', 'desc');

var paramDatasCm = new Ext.grid.ColumnModel([new Ext.grid.RowNumberer(), {
    header: '服务部门',
    dataIndex: 'servDeptName',
    width: 120,
    align: 'left',
    sortable: true
}, {
    header: '被服务部门',
    dataIndex: 'servedDeptName',
    width: 120,
    align: 'left',
    sortable: true
}, {
    header: '项目',
    dataIndex: 'itemName',
    width: 120,
    align: 'left',
    sortable: true
}, {
    header: '参数数值',
    dataIndex: 'value',
    width: 60,
    align: 'left',
    sortable: true
}, {
    header: '备注',
    dataIndex: 'remark',
    width: 100,
    align: 'left',
    sortable: true
}, {
    header: '项目代码',
    dataIndex: 'outItemCode',
    width: 100,
    align: 'left',
    sortable: true
}, {
    header: '项目名称',
    dataIndex: 'outItemName',
    width: 120,
    align: 'left',
    sortable: true
}, {
    header: '服务部门代码',
    dataIndex: 'outServDeptCode',
    width: 100,
    align: 'left',
    sortable: true
}, {
    header: '服务部门名称',
    dataIndex: 'outServDeptName',
    width: 120,
    align: 'left',
    sortable: true
}, {
    header: '被服务部门代码',
    dataIndex: 'outServedDeptCode',
    width: 100,
    align: 'left',
    sortable: true
}, {
    header: '被服务部门名称',
    dataIndex: 'outServedDeptName',
    width: 120,
    align: 'left',
    sortable: true
}, {
    header: '采集方式',
    dataIndex: 'inType',
    width: 70,
    align: 'left',
    sortable: true
}, {
    header: '采集人',
    dataIndex: 'inPersonName',
    width: 70,
    align: 'left',
    sortable: true
}, {
    header: '日期',
    dataIndex: 'inDate',
    width: 70,
    renderer: formatDate,
    align: 'left',
    sortable: true
}, {
    header: '开单医生代码',
    dataIndex: 'fDocCode',
    width: 70,
    align: 'left',
    sortable: true
}, {
    header: '开单医生名称',
    dataIndex: 'fDocName',
    width: 70,
    align: 'left',
    sortable: true
}, {
    header: '开单医生',
    dataIndex: 'fInDocName',
    width: 70,
    align: 'left',
    sortable: true
}]);

var monthsDs = new Ext.data.Store({
    proxy: "",
    reader: new Ext.data.JsonReader({
        totalProperty: "results",
        root: 'rows'
    }, ['rowid', 'code', 'name', 'desc', 'start', 'end', 'dataFinish'])
});
var months = new Ext.form.ComboBox({
    id: 'months',
    fieldLabel: '核算区间',
    width: 100,
    listWidth: 260,
    allowBlank: false,
    store: monthsDs,
    valueField: 'rowid',
    displayField: 'name',
    triggerAction: 'all',
    emptyText: '选择核算区间...',
    pageSize: 10,
    minChars: 1,
    selectOnFocus: true,
    forceSelection: true
});
monthsDs.on('beforeload', function(ds, o){
    ds.proxy = new Ext.data.HttpProxy({
        url: 'dhc.ca.paramdatasexe.csp?action=months&searchValue=' + Ext.getCmp('months').getRawValue(),
        method: 'GET'
    });
});
months.on("select", function(cmb, rec, id){
    monthDr = cmb.getValue();
    if ((monthDr != "") && (itemDr != "")) {
        Ext.Ajax.request({
            url: 'dhc.ca.paramdatasexe.csp?action=checkMonth&monthDr=' + monthDr,
            waitMsg: '保存中...',
            failure: function(result, request){
                Ext.Msg.show({
                    title: '错误',
                    msg: '请检查网络连接!',
                    buttons: Ext.Msg.OK,
                    icon: Ext.MessageBox.ERROR
                });
            },
            success: function(result, request){
                var jsonData = Ext.util.JSON.decode(result.responseText);
                if (jsonData.success != 'true') {
                    //addDataTypesButton.setDisabled(true);
                    //editDataTypesButton.setDisabled(true);
                    //delDataTypesButton.setDisabled(true);
                    //copeOtherMonthButton.setDisabled(true);
                }
                else {
                    addDataTypesButton.setDisabled(false);
                    editDataTypesButton.setDisabled(false);
                    delDataTypesButton.setDisabled(false);
                    copeOtherMonthButton.setDisabled(false);
                }
            },
            scope: this
        });
        paramDatasDs.load({
            params: {
                start: 0,
                limit: paramDatasPagingToolbar.pageSize,
                monthDr: monthDr,
                itemDr: itemDr
            }
        });
    }
});


var itemsDs = new Ext.data.Store({
    autoLoad: true,
    proxy: "",
    reader: new Ext.data.JsonReader({
        totalProperty: "results",
        root: 'rows'
    }, ['rowid', 'typeDr', 'typeName', 'typeShortCut', 'order', 'itemDr', 'itemCode', 'itemName', 'itemShortCut'])
});

itemsDs.on('beforeload', function(ds, o){
    ds.proxy = new Ext.data.HttpProxy({
        url: 'dhc.ca.vouchdatasexe.csp?action=items&searchField=itemShortCut&searchValue=' + Ext.getCmp('items').getRawValue() + '&id=' + tmpItemType,
        method: 'GET'
    });
});

var items = new Ext.form.ComboBox({
    id: 'items',
    fieldLabel: '项目',
    store: itemsDs,
    valueField: 'itemDr',
    displayField: 'itemShortCut',
    typeAhead: true,
    pageSize: 10,
    minChars: 1,
    width: 100,
    listWidth: 250,
    triggerAction: 'all',
    emptyText: '选择项目...',
    allowBlank: false,
    name: 'items',
    selectOnFocus: true,
    forceSelection: true
});

items.on("select", function(cmb, rec, id){
    itemDr = cmb.getValue();
    if ((monthDr != "") && (itemDr != "")) {
        Ext.Ajax.request({
            url: 'dhc.ca.paramdatasexe.csp?action=checkMonth&monthDr=' + monthDr,
            waitMsg: '保存中...',
            failure: function(result, request){
                Ext.Msg.show({
                    title: '错误',
                    msg: '请检查网络连接!',
                    buttons: Ext.Msg.OK,
                    icon: Ext.MessageBox.ERROR
                });
            },
            success: function(result, request){
                var jsonData = Ext.util.JSON.decode(result.responseText);
                if (jsonData.success != 'true') {
                    //addDataTypesButton.setDisabled(true);
                    //editDataTypesButton.setDisabled(true);
                    //delDataTypesButton.setDisabled(true);
                    //copeOtherMonthButton.setDisabled(true);
                }
                else {
                    addDataTypesButton.setDisabled(false);
                    editDataTypesButton.setDisabled(false);
                    delDataTypesButton.setDisabled(false);
                    copeOtherMonthButton.setDisabled(false);
                }
            },
            scope: this
        });
        paramDatasDs.load({
            params: {
                start: 0,
                limit: paramDatasPagingToolbar.pageSize,
                monthDr: monthDr,
                itemDr: itemDr
            }
        });
    }
});

var addDataTypesButton = {
    text: '添加',
    tooltip: '添加参数数据表',
    iconCls: 'add',
    handler: function(){
        addFun(paramDatasDs, paramDatasMain, paramDatasPagingToolbar);
    }
};

var editDataTypesButton = {
    text: '修改',
    tooltip: '修改参数数据表',
    iconCls: 'remove',
    handler: function(){
        editFun(paramDatasDs, paramDatasMain, paramDatasPagingToolbar);
    }
};

var delDataTypesButton = {
    text: '删除',
    tooltip: '删除参数数据表',
    iconCls: 'remove',
    //disabled: true,
    handler: function(){
        delFun(paramDatasDs, paramDatasMain, paramDatasPagingToolbar);
    }
};

var relationButton = new Ext.Toolbar.Button({
    text: '执行对照',
    tooltip: '执行对照',
    iconCls: 'remove',
    handler: function(){
        refreshFun(paramDatasDs, paramDatasMain, paramDatasPagingToolbar)
    }
});

var importButton = {
    text: '文件导入',
    tooltip: '文件导入',
    iconCls: 'remove',
    handler: function(){
        if (monthDr == "" || itemDr == "") {
            Ext.Msg.show({
                title: '错误',
                msg: '请先选择核算区间和项目!',
                buttons: Ext.Msg.OK,
                icon: Ext.MessageBox.ERROR
            });
            return;
        }
        paramDataLoad(monthDr, itemDr, userCode);
    }
};

var hisImportButton = {
    text: 'HIS参数导入',
    tooltip: 'HIS参数导入',
    iconCls: 'remove',
    handler: function(){
        if (monthDr == "" || itemDr == "") {
            Ext.Msg.show({
                title: '错误',
                msg: '请先选择核算区间和项目!',
                buttons: Ext.Msg.OK,
                icon: Ext.MessageBox.ERROR
            });
            return;
        }
        Ext.MessageBox.confirm('提示', '确定要导入数据么?', function(btn){
            if (btn == 'yes') {
                Ext.Ajax.request({
                    url: 'dhc.ca.paramdatasexe.csp?action=import&userCode=' + userCode + '&intervalDr=' + monthDr + '&itemDr=' + itemDr,
                    waitMsg: '导入中...',
                    failure: function(result, request){
                        Ext.Msg.show({
                            title: '错误',
                            msg: '请检查网络连接!',
                            buttons: Ext.Msg.OK,
                            icon: Ext.MessageBox.ERROR
                        });
                    },
                    success: function(result, request){
                        var jsonData = Ext.util.JSON.decode(result.responseText);
                        if (jsonData.success == 'true') {
                            Ext.MessageBox.alert('提示', '导入成功!');
                            dataStore.load({
                                params: {
                                    start: pagingTool.cursor,
                                    limit: pagingTool.pageSize,
                                    monthDr: monthDr,
                                    itemDr: itemDr
                                }
                            });
                            window.close();
                        }
                        else {
                            var message = "SQLErr: " + jsonData.info;
                            Ext.Msg.show({
                                title: '错误',
                                msg: message,
                                buttons: Ext.Msg.OK,
                                icon: Ext.MessageBox.ERROR
                            });
                        }
                    },
                    scope: this
                });
                
            }
        });
    }
};
var summaryButton = {
    text: '汇总导入',
    tooltip: '汇总导入',
    iconCls: 'remove',
    handler: function(){
        Ext.MessageBox.confirm('提示', '确定要导入数据么?', function(btn){
            if (monthDr == "") {
                Ext.Msg.show({
                    title: '错误',
                    msg: '请先选择核算区间!',
                    buttons: Ext.Msg.OK,
                    icon: Ext.MessageBox.ERROR
                });
                return;
            }
            if (btn == 'yes') {
                Ext.Ajax.request({
                    url: 'dhc.ca.paramdatasexe.csp?action=summary&inPersonDr=' + userDr + '&intervalDr=' + monthDr,
                    waitMsg: '导入中...',
                    failure: function(result, request){
                        Ext.Msg.show({
                            title: '错误',
                            msg: '请检查网络连接!',
                            buttons: Ext.Msg.OK,
                            icon: Ext.MessageBox.ERROR
                        });
                    },
                    success: function(result, request){
                        var jsonData = Ext.util.JSON.decode(result.responseText);
                        if (jsonData.success == 'true') {
                            Ext.MessageBox.alert('提示', '导入成功!');
                            dataStore.load({
                                params: {
                                    start: pagingTool.cursor,
                                    limit: pagingTool.pageSize,
                                    monthDr: monthDr,
                                    itemDr: itemDr
                                }
                            });
                            window.close();
                        }
                        else {
                            var message = "SQLErr: " + jsonData.info;
                            Ext.Msg.show({
                                title: '错误',
                                msg: message,
                                buttons: Ext.Msg.OK,
                                icon: Ext.MessageBox.ERROR
                            });
                        }
                    },
                    scope: this
                });
                
            }
        });
    }
};
var opMenu = new Ext.menu.Menu({
    id: 'opMenu',
    items: [addDataTypesButton, editDataTypesButton, delDataTypesButton]
});
var opTool = new Ext.Toolbar([{
    text: '基本操作',
    iconCls: 'add',
    menu: opMenu
}]);

var importMenu = new Ext.menu.Menu({
    id: 'importMenu',
    items: [hisImportButton, importButton, summaryButton]
});
var importTool = new Ext.Toolbar([{
    text: '数据导入',
    iconCls: 'add',
    menu: importMenu
}]);

var unAddDeptButton = new Ext.Toolbar.Button({
    text: '未添加部门',
    tooltip: '未添加部门',
    iconCls: 'remove',
    handler: function(){
        if (monthDr == "" || itemDr == "") {
            Ext.Msg.show({
                title: '错误',
                msg: '请先选择核算区间和项目!',
                buttons: Ext.Msg.OK,
                icon: Ext.MessageBox.ERROR
            });
            return;
        }
        var unitDeptsDs = new Ext.data.Store({
            proxy: new Ext.data.HttpProxy({
                url: paramDatasUrl + '?action=unAddDept&itemDr=' + itemDr + '&unitDr=' + tmpUnitDr + '&intervalDr=' + monthDr
            }),
            reader: new Ext.data.JsonReader({
                root: 'rows',
                totalProperty: 'results'
            }, ['rowId', 'code', 'name', 'shortcut', 'address', 'remark', {
                name: 'startTime',
                type: 'date',
                dateFormat: 'Y-m-d'
            }, {
                name: 'stop',
                type: 'date',
                dateFormat: 'Y-m-d'
            }, 'unitDr', 'propertyDr', 'active']),
            // turn on remote sorting
            remoteSort: true
        });
        
        unitDeptsDs.setDefaultSort('rowId', 'Desc');
        
        function formatDate(value){
            return value ? value.dateFormat('Y-m-d') : '';
        };
        
        var unitDeptsCm = new Ext.grid.ColumnModel([new Ext.grid.RowNumberer(), {
            header: '代码',
            dataIndex: 'code',
            width: 60,
            align: 'left',
            sortable: true
        }, {
            header: "名称",
            dataIndex: 'name',
            width: 200,
            align: 'left',
            sortable: true
        }]);
        
        var unitDeptsPagingToolbar = new Ext.PagingToolbar({//分页工具栏
            pageSize: 25,
            store: unitDeptsDs,
            displayInfo: true,
            displayMsg: '当前显示{0} - {1}，共计{2}',
            emptyMsg: "没有数据"
        });
        
        var unitDeptsMain = new Ext.grid.GridPanel({//表格
            //title: '未添加的部门',
            store: unitDeptsDs,
            cm: unitDeptsCm,
            trackMouseOver: true,
            stripeRows: true,
            sm: new Ext.grid.RowSelectionModel({
                singleSelect: true
            }),
            loadMask: true,
            bbar: unitDeptsPagingToolbar
        });
        
        var awindow = new Ext.Window({
            title: '未添加的部门',
            width: 400,
            height: 300,
            minWidth: 200,
            minHeight: 150,
            layout: 'fit',
            plain: true,
            modal: true,
            bodyStyle: 'padding:5px;',
            buttonAlign: 'center',
            items: unitDeptsMain
        
        });
        awindow.show();
        unitDeptsDs.load({
            params: {
                start: 0,
                limit: 25
            }
        });
    }
});

var copeOtherMonthButton = new Ext.Toolbar.Button({
    text: '复制其它月份数据',
    tooltip: '复制其它月份数据到本月',
    iconCls: 'remove',
    handler: function(){
    
        if (monthDr == "" || itemDr == "") {
            Ext.Msg.show({
                title: '错误',
                msg: '请先选择核算区间和项目!',
                buttons: Ext.Msg.OK,
                icon: Ext.MessageBox.ERROR
            });
            return;
        }
        var oldMonthsDs = new Ext.data.Store({
            proxy: "",
            reader: new Ext.data.JsonReader({
                totalProperty: "results",
                root: 'rows'
            }, ['rowid', 'code', 'name', 'desc', 'start', 'end', 'dataFinish'])
        });
        var oldMonths = new Ext.form.ComboBox({
            id: 'oldMonths',
            fieldLabel: '被复制区间',
            anchor: '90%',
            listWidth: 260,
            allowBlank: false,
            store: oldMonthsDs,
            valueField: 'rowid',
            displayField: 'name',
            triggerAction: 'all',
            emptyText: '选择被复制核算区间...',
            pageSize: 10,
            minChars: 1,
            selectOnFocus: true,
            forceSelection: true
        });
        oldMonthsDs.on('beforeload', function(ds, o){
            ds.proxy = new Ext.data.HttpProxy({
                url: 'dhc.ca.paramdatasexe.csp?action=months&searchValue=' + Ext.getCmp('oldMonths').getRawValue(),
                method: 'GET'
            });
        });
        
        oldMonths.on("select", function(cmb, rec, id){
            if (monthDr == cmb.getValue()) {
                Ext.Msg.show({
                    title: '错误',
                    msg: '不要选择当前月份!',
                    buttons: Ext.Msg.OK,
                    icon: Ext.MessageBox.ERROR
                });
                cmb.setValue('');
                return;
            }
        });
        
        var formPanel = new Ext.form.FormPanel({
            baseCls: 'x-plain',
            labelWidth: 70,
            items: [oldMonths]
        });
        
        // define window and show it in desktop
        var awindow = new Ext.Window({
            title: '复制其它月份数据',
            width: 300,
            height: 150,
            minWidth: 200,
            minHeight: 150,
            layout: 'fit',
            plain: true,
            modal: true,
            bodyStyle: 'padding:5px;',
            buttonAlign: 'center',
            items: formPanel,
            buttons: [{
                text: '保存',
                handler: function(){
                
                    if (formPanel.form.isValid()) {
                        Ext.Ajax.request({
                            url: paramDatasUrl + '?action=copy&itemDr=' + itemDr + '&oldMon=' + oldMonths.getValue() + '&intervalDr=' + monthDr + '&inPersonDr=' + userDr,
                            waitMsg: '保存中...',
                            failure: function(result, request){
                                Ext.Msg.show({
                                    title: '错误',
                                    msg: '请检查网络连接!',
                                    buttons: Ext.Msg.OK,
                                    icon: Ext.MessageBox.ERROR
                                });
                            },
                            success: function(result, request){
                                var jsonData = Ext.util.JSON.decode(result.responseText);
                                if (jsonData.success == 'true') {
                                    Ext.Msg.show({
                                        title: '注意',
                                        msg: '添加成功!',
                                        buttons: Ext.Msg.OK,
                                        icon: Ext.MessageBox.INFO
                                    });
                                    paramDatasDs.setDefaultSort('rowid', 'desc');
                                    paramDatasDs.load({
                                        params: {
                                            start: 0,
                                            limit: paramDatasPagingToolbar.pageSize,
                                            monthDr: monthDr,
                                            itemDr: itemDr
                                        }
                                    });
                                    awindow.close();
                                }
                                else {
                                    var message = "";
                                    message = "SQLErr: " + jsonData.info;
                                    if (jsonData.info == 'EmptyName') 
                                        message = '输入的名称为空!';
                                    if (jsonData.info == 'EmptyOrder') 
                                        message = '输入的序号为空!';
                                    if (jsonData.info == 'RepName') 
                                        message = '输入的名称已经存在!';
                                    if (jsonData.info == 'RepOrder') 
                                        message = '输入的序号已经存在!';
                                    Ext.Msg.show({
                                        title: '错误',
                                        msg: message,
                                        buttons: Ext.Msg.OK,
                                        icon: Ext.MessageBox.ERROR
                                    });
                                }
                            },
                            scope: this
                        });
                    }
                    else {
                        Ext.Msg.show({
                            title: '错误',
                            msg: '请修正页面提示的错误后提交。',
                            buttons: Ext.Msg.OK,
                            icon: Ext.MessageBox.ERROR
                        });
                    }
                }
            }, {
                text: '取消',
                handler: function(){
                    awindow.close();
                }
            }]
        });
        awindow.show();
    }
});

var paramDatasSearchField = 'value';

var paramDatasFilterItem = new Ext.Toolbar.MenuButton({
    text: '过滤器',
    tooltip: '关键字所属类别',
    menu: {
        items: [new Ext.menu.CheckItem({
            text: '服务部门',
            value: 'servDeptName',
            checked: false,
            group: 'DataTypesFilter',
            checkHandler: onDataTypesItemCheck
        }), new Ext.menu.CheckItem({
            text: '被服务部门',
            value: 'servedDeptName',
            checked: false,
            group: 'DataTypesFilter',
            checkHandler: onDataTypesItemCheck
        }), new Ext.menu.CheckItem({
            text: '参数数值',
            value: 'value',
            checked: true,
            group: 'DataTypesFilter',
            checkHandler: onDataTypesItemCheck
        }), new Ext.menu.CheckItem({
            text: '备注',
            value: 'remark',
            checked: false,
            group: 'DataTypesFilter',
            checkHandler: onDataTypesItemCheck
        }), //new Ext.menu.CheckItem({ text: '项目代码',value: 'itemCode',checked: false,group: 'DataTypesFilter',checkHandler: onDataTypesItemCheck }),
        //new Ext.menu.CheckItem({ text: '项目名称',value: 'itemName',checked: false,group: 'DataTypesFilter',checkHandler: onDataTypesItemCheck }),
        new Ext.menu.CheckItem({
            text: '服务部门代码',
            value: 'outServDeptCode',
            checked: false,
            group: 'DataTypesFilter',
            checkHandler: onDataTypesItemCheck
        }), new Ext.menu.CheckItem({
            text: '服务部门名称',
            value: 'outServDeptName',
            checked: false,
            group: 'DataTypesFilter',
            checkHandler: onDataTypesItemCheck
        }), new Ext.menu.CheckItem({
            text: '被服务部门代码',
            value: 'outServedDeptCode',
            checked: false,
            group: 'DataTypesFilter',
            checkHandler: onDataTypesItemCheck
        }), new Ext.menu.CheckItem({
            text: '被服务部门名称',
            value: 'outServedDeptName',
            checked: false,
            group: 'DataTypesFilter',
            checkHandler: onDataTypesItemCheck
        }), new Ext.menu.CheckItem({
            text: '采集方式',
            value: 'inType',
            checked: false,
            group: 'DataTypesFilter',
            checkHandler: onDataTypesItemCheck
        }), new Ext.menu.CheckItem({
            text: '采集人',
            value: 'inPersonName',
            checked: false,
            group: 'DataTypesFilter',
            checkHandler: onDataTypesItemCheck
        }), new Ext.menu.CheckItem({
            text: '日期',
            value: 'inDate',
            checked: false,
            group: 'DataTypesFilter',
            checkHandler: onDataTypesItemCheck
        }), new Ext.menu.CheckItem({
            text: '开单医生代码',
            value: 'fDocCode',
            checked: false,
            group: 'DataTypesFilter',
            checkHandler: onDataTypesItemCheck
        }), new Ext.menu.CheckItem({
            text: '开单医生名称',
            value: 'fDocName',
            checked: false,
            group: 'DataTypesFilter',
            checkHandler: onDataTypesItemCheck
        })]
    }
});

function onDataTypesItemCheck(item, checked){
    if (checked) {
        paramDatasSearchField = item.value;
        paramDatasFilterItem.setText(item.text + ':');
    }
};

var paramDatasSearchBox = new Ext.form.TwinTriggerField({//查找按钮
    width: 180,
    trigger1Class: 'x-form-clear-trigger',
    trigger2Class: 'x-form-search-trigger',
    emptyText: '搜索...',
    listeners: {
        specialkey: {
            fn: function(field, e){
                var key = e.getKey();
                if (e.ENTER === key) {
                    this.onTrigger2Click();
                }
            }
        }
    },
    grid: this,
    onTrigger1Click: function(){
        if (this.getValue()) {
            this.setValue('');
            paramDatasDs.proxy = new Ext.data.HttpProxy({
                url: paramDatasUrl + '?action=list'
            });
            paramDatasDs.load({
                params: {
                    start: 0,
                    limit: paramDatasPagingToolbar.pageSize,
                    monthDr: monthDr,
                    itemDr: itemDr
                }
            });
        }
    },
    onTrigger2Click: function(){
        if (this.getValue()) {
            paramDatasDs.proxy = new Ext.data.HttpProxy({
                url: paramDatasUrl + '?action=list&searchField=' + paramDatasSearchField + '&searchValue=' + this.getValue()
            });
            paramDatasDs.load({
                params: {
                    start: 0,
                    limit: paramDatasPagingToolbar.pageSize,
                    monthDr: monthDr,
                    itemDr: itemDr
                }
            });
        }
    }
});

var paramDatasPagingToolbar = new Ext.PagingToolbar({//分页工具栏
    pageSize: 25,
    store: paramDatasDs,
    displayInfo: true,
    displayMsg: '当前显示{0} - {1}，共计{2}',
    emptyMsg: "没有数据",
    buttons: ['-', paramDatasFilterItem, '-', paramDatasSearchBox],
    doLoad: function(C){
        var B = {}, A = this.paramNames;
        B[A.start] = C;
        B[A.limit] = this.pageSize;
        B['monthDr'] = monthDr;
        B['itemDr'] = itemDr;
        if (this.fireEvent("beforechange", this, B) !== false) {
            this.store.load({
                params: B
            });
        }
    }
});

var paramDatasMain = new Ext.grid.GridPanel({//表格
    title: '参数数据表',
    store: paramDatasDs,
    cm: paramDatasCm,
    trackMouseOver: true,
    stripeRows: true,
    sm: new Ext.grid.RowSelectionModel({
        singleSelect: true
    }),
    loadMask: true,
    tbar: ['核算区间:', months, '-', '项目:', items, '-', opTool, '-', copeOtherMonthButton, '-', unAddDeptButton, '-', relationButton, '-', importTool,'-',editAAccCycleButton,'-',typeField,'-',excelButton],
    bbar: paramDatasPagingToolbar
});
