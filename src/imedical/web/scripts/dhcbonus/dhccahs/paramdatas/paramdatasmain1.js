var paramDatasUrl = 'dhc.ca.paramdatasexe.csp';
var paramDatasProxy = new Ext.data.HttpProxy({
    url: paramDatasUrl + '?action=list'
});
var monthDr = "";
var itemDr = "";
/////////
//tmpItemType:itemType��������޸�
var tmpItemType = 3;
/////////
//tmpUnitDr:UnitDr��������޸�
var tmpUnitDr = 1;

/////////////////��Ө///�ϴ�///////////////////
var editAAccCycleButton  = new Ext.Toolbar.Button({
		text: '�ϴ��ļ�',
		tooltip: '�ϴ�',
		iconCls: 'remove',
		handler: function(){editAAccCycleFun();}
});

var typeStore = new Ext.data.SimpleStore({
	fields: ['key','keyValue'],
	data : [['3','��������-��Ӧ��'],['4','��������-�繤��'],['5','��������-�绰��'],['7','��������-����'],['8','��������-����'],['9','��������-˾��'],['B','��������-ϴ��'],['C','��������-Ժ��'],['D','��������-�����˴�']]
});
var typeField = new Ext.form.ComboBox({
	id: 'typeField',
	fieldLabel: '������������',
	listWidth : 200,
	selectOnFocus: true,
	allowBlank: false,
	store: typeStore,
	anchor: '90%',
	value:'Y', //Ĭ��ֵ
	valueNotFoundText:'������������',
	displayField: 'keyValue',
	valueField: 'key',
	triggerAction: 'all',
	emptyText:'ѡ���־...',
	mode: 'local', //����ģʽ
	editable:false,
	pageSize: 10,
	minChars: 1,
	selectOnFocus: true,
	forceSelection: true
});
var excelButton = new Ext.Toolbar.Button({
	id:'excelButton',
	text:'���ݵ���',        
	tooltip:'����',
	iconCls:'add',        
	handler: function(){ 
				//location.href = 'http://localhost:8080/etl/CostTrance';	
				var r=confirm("ȷ��Ҫ����������");
				if(r==true)
				{
				if(typeField.getValue()==""){
				  Ext.Msg.show({title:'����',msg:'��ѡ������',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
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
								waitMsg:'���ڵ���...',
								failure: function(result, request) {
								Ext.Msg.show({title:'��ʾ',msg:'����',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							    },
								success: function(result,request){
								
                                var jsonData = Ext.util.JSON.decode( result.responseText );
								//alert(jsonData.success);
								var suc=jsonData.success;
						  	   if (suc) {
							   alert
						  		Ext.Msg.show({title:'��ʾ',msg:jsonData.message,buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
								}
								else
								{
								  Ext.Msg.show({title:'����',msg:jsonData.message,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
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
    header: '������',
    dataIndex: 'servDeptName',
    width: 120,
    align: 'left',
    sortable: true
}, {
    header: '��������',
    dataIndex: 'servedDeptName',
    width: 120,
    align: 'left',
    sortable: true
}, {
    header: '��Ŀ',
    dataIndex: 'itemName',
    width: 120,
    align: 'left',
    sortable: true
}, {
    header: '������ֵ',
    dataIndex: 'value',
    width: 60,
    align: 'left',
    sortable: true
}, {
    header: '��ע',
    dataIndex: 'remark',
    width: 100,
    align: 'left',
    sortable: true
}, {
    header: '��Ŀ����',
    dataIndex: 'outItemCode',
    width: 100,
    align: 'left',
    sortable: true
}, {
    header: '��Ŀ����',
    dataIndex: 'outItemName',
    width: 120,
    align: 'left',
    sortable: true
}, {
    header: '�����Ŵ���',
    dataIndex: 'outServDeptCode',
    width: 100,
    align: 'left',
    sortable: true
}, {
    header: '����������',
    dataIndex: 'outServDeptName',
    width: 120,
    align: 'left',
    sortable: true
}, {
    header: '�������Ŵ���',
    dataIndex: 'outServedDeptCode',
    width: 100,
    align: 'left',
    sortable: true
}, {
    header: '������������',
    dataIndex: 'outServedDeptName',
    width: 120,
    align: 'left',
    sortable: true
}, {
    header: '�ɼ���ʽ',
    dataIndex: 'inType',
    width: 70,
    align: 'left',
    sortable: true
}, {
    header: '�ɼ���',
    dataIndex: 'inPersonName',
    width: 70,
    align: 'left',
    sortable: true
}, {
    header: '����',
    dataIndex: 'inDate',
    width: 70,
    renderer: formatDate,
    align: 'left',
    sortable: true
}, {
    header: '����ҽ������',
    dataIndex: 'fDocCode',
    width: 70,
    align: 'left',
    sortable: true
}, {
    header: '����ҽ������',
    dataIndex: 'fDocName',
    width: 70,
    align: 'left',
    sortable: true
}, {
    header: '����ҽ��',
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
    fieldLabel: '��������',
    width: 100,
    listWidth: 260,
    allowBlank: false,
    store: monthsDs,
    valueField: 'rowid',
    displayField: 'name',
    triggerAction: 'all',
    emptyText: 'ѡ���������...',
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
            waitMsg: '������...',
            failure: function(result, request){
                Ext.Msg.show({
                    title: '����',
                    msg: '������������!',
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
    fieldLabel: '��Ŀ',
    store: itemsDs,
    valueField: 'itemDr',
    displayField: 'itemShortCut',
    typeAhead: true,
    pageSize: 10,
    minChars: 1,
    width: 100,
    listWidth: 250,
    triggerAction: 'all',
    emptyText: 'ѡ����Ŀ...',
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
            waitMsg: '������...',
            failure: function(result, request){
                Ext.Msg.show({
                    title: '����',
                    msg: '������������!',
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
    text: '���',
    tooltip: '��Ӳ������ݱ�',
    iconCls: 'add',
    handler: function(){
        addFun(paramDatasDs, paramDatasMain, paramDatasPagingToolbar);
    }
};

var editDataTypesButton = {
    text: '�޸�',
    tooltip: '�޸Ĳ������ݱ�',
    iconCls: 'remove',
    handler: function(){
        editFun(paramDatasDs, paramDatasMain, paramDatasPagingToolbar);
    }
};

var delDataTypesButton = {
    text: 'ɾ��',
    tooltip: 'ɾ���������ݱ�',
    iconCls: 'remove',
    //disabled: true,
    handler: function(){
        delFun(paramDatasDs, paramDatasMain, paramDatasPagingToolbar);
    }
};

var relationButton = new Ext.Toolbar.Button({
    text: 'ִ�ж���',
    tooltip: 'ִ�ж���',
    iconCls: 'remove',
    handler: function(){
        refreshFun(paramDatasDs, paramDatasMain, paramDatasPagingToolbar)
    }
});

var importButton = {
    text: '�ļ�����',
    tooltip: '�ļ�����',
    iconCls: 'remove',
    handler: function(){
        if (monthDr == "" || itemDr == "") {
            Ext.Msg.show({
                title: '����',
                msg: '����ѡ������������Ŀ!',
                buttons: Ext.Msg.OK,
                icon: Ext.MessageBox.ERROR
            });
            return;
        }
        paramDataLoad(monthDr, itemDr, userCode);
    }
};

var hisImportButton = {
    text: 'HIS��������',
    tooltip: 'HIS��������',
    iconCls: 'remove',
    handler: function(){
        if (monthDr == "" || itemDr == "") {
            Ext.Msg.show({
                title: '����',
                msg: '����ѡ������������Ŀ!',
                buttons: Ext.Msg.OK,
                icon: Ext.MessageBox.ERROR
            });
            return;
        }
        Ext.MessageBox.confirm('��ʾ', 'ȷ��Ҫ��������ô?', function(btn){
            if (btn == 'yes') {
                Ext.Ajax.request({
                    url: 'dhc.ca.paramdatasexe.csp?action=import&userCode=' + userCode + '&intervalDr=' + monthDr + '&itemDr=' + itemDr,
                    waitMsg: '������...',
                    failure: function(result, request){
                        Ext.Msg.show({
                            title: '����',
                            msg: '������������!',
                            buttons: Ext.Msg.OK,
                            icon: Ext.MessageBox.ERROR
                        });
                    },
                    success: function(result, request){
                        var jsonData = Ext.util.JSON.decode(result.responseText);
                        if (jsonData.success == 'true') {
                            Ext.MessageBox.alert('��ʾ', '����ɹ�!');
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
                                title: '����',
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
    text: '���ܵ���',
    tooltip: '���ܵ���',
    iconCls: 'remove',
    handler: function(){
        Ext.MessageBox.confirm('��ʾ', 'ȷ��Ҫ��������ô?', function(btn){
            if (monthDr == "") {
                Ext.Msg.show({
                    title: '����',
                    msg: '����ѡ���������!',
                    buttons: Ext.Msg.OK,
                    icon: Ext.MessageBox.ERROR
                });
                return;
            }
            if (btn == 'yes') {
                Ext.Ajax.request({
                    url: 'dhc.ca.paramdatasexe.csp?action=summary&inPersonDr=' + userDr + '&intervalDr=' + monthDr,
                    waitMsg: '������...',
                    failure: function(result, request){
                        Ext.Msg.show({
                            title: '����',
                            msg: '������������!',
                            buttons: Ext.Msg.OK,
                            icon: Ext.MessageBox.ERROR
                        });
                    },
                    success: function(result, request){
                        var jsonData = Ext.util.JSON.decode(result.responseText);
                        if (jsonData.success == 'true') {
                            Ext.MessageBox.alert('��ʾ', '����ɹ�!');
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
                                title: '����',
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
    text: '��������',
    iconCls: 'add',
    menu: opMenu
}]);

var importMenu = new Ext.menu.Menu({
    id: 'importMenu',
    items: [hisImportButton, importButton, summaryButton]
});
var importTool = new Ext.Toolbar([{
    text: '���ݵ���',
    iconCls: 'add',
    menu: importMenu
}]);

var unAddDeptButton = new Ext.Toolbar.Button({
    text: 'δ��Ӳ���',
    tooltip: 'δ��Ӳ���',
    iconCls: 'remove',
    handler: function(){
        if (monthDr == "" || itemDr == "") {
            Ext.Msg.show({
                title: '����',
                msg: '����ѡ������������Ŀ!',
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
            header: '����',
            dataIndex: 'code',
            width: 60,
            align: 'left',
            sortable: true
        }, {
            header: "����",
            dataIndex: 'name',
            width: 200,
            align: 'left',
            sortable: true
        }]);
        
        var unitDeptsPagingToolbar = new Ext.PagingToolbar({//��ҳ������
            pageSize: 25,
            store: unitDeptsDs,
            displayInfo: true,
            displayMsg: '��ǰ��ʾ{0} - {1}������{2}',
            emptyMsg: "û������"
        });
        
        var unitDeptsMain = new Ext.grid.GridPanel({//���
            //title: 'δ��ӵĲ���',
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
            title: 'δ��ӵĲ���',
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
    text: '���������·�����',
    tooltip: '���������·����ݵ�����',
    iconCls: 'remove',
    handler: function(){
    
        if (monthDr == "" || itemDr == "") {
            Ext.Msg.show({
                title: '����',
                msg: '����ѡ������������Ŀ!',
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
            fieldLabel: '����������',
            anchor: '90%',
            listWidth: 260,
            allowBlank: false,
            store: oldMonthsDs,
            valueField: 'rowid',
            displayField: 'name',
            triggerAction: 'all',
            emptyText: 'ѡ�񱻸��ƺ�������...',
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
                    title: '����',
                    msg: '��Ҫѡ��ǰ�·�!',
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
            title: '���������·�����',
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
                text: '����',
                handler: function(){
                
                    if (formPanel.form.isValid()) {
                        Ext.Ajax.request({
                            url: paramDatasUrl + '?action=copy&itemDr=' + itemDr + '&oldMon=' + oldMonths.getValue() + '&intervalDr=' + monthDr + '&inPersonDr=' + userDr,
                            waitMsg: '������...',
                            failure: function(result, request){
                                Ext.Msg.show({
                                    title: '����',
                                    msg: '������������!',
                                    buttons: Ext.Msg.OK,
                                    icon: Ext.MessageBox.ERROR
                                });
                            },
                            success: function(result, request){
                                var jsonData = Ext.util.JSON.decode(result.responseText);
                                if (jsonData.success == 'true') {
                                    Ext.Msg.show({
                                        title: 'ע��',
                                        msg: '��ӳɹ�!',
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
                                        message = '���������Ϊ��!';
                                    if (jsonData.info == 'EmptyOrder') 
                                        message = '��������Ϊ��!';
                                    if (jsonData.info == 'RepName') 
                                        message = '����������Ѿ�����!';
                                    if (jsonData.info == 'RepOrder') 
                                        message = '���������Ѿ�����!';
                                    Ext.Msg.show({
                                        title: '����',
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
                            title: '����',
                            msg: '������ҳ����ʾ�Ĵ�����ύ��',
                            buttons: Ext.Msg.OK,
                            icon: Ext.MessageBox.ERROR
                        });
                    }
                }
            }, {
                text: 'ȡ��',
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
    text: '������',
    tooltip: '�ؼ����������',
    menu: {
        items: [new Ext.menu.CheckItem({
            text: '������',
            value: 'servDeptName',
            checked: false,
            group: 'DataTypesFilter',
            checkHandler: onDataTypesItemCheck
        }), new Ext.menu.CheckItem({
            text: '��������',
            value: 'servedDeptName',
            checked: false,
            group: 'DataTypesFilter',
            checkHandler: onDataTypesItemCheck
        }), new Ext.menu.CheckItem({
            text: '������ֵ',
            value: 'value',
            checked: true,
            group: 'DataTypesFilter',
            checkHandler: onDataTypesItemCheck
        }), new Ext.menu.CheckItem({
            text: '��ע',
            value: 'remark',
            checked: false,
            group: 'DataTypesFilter',
            checkHandler: onDataTypesItemCheck
        }), //new Ext.menu.CheckItem({ text: '��Ŀ����',value: 'itemCode',checked: false,group: 'DataTypesFilter',checkHandler: onDataTypesItemCheck }),
        //new Ext.menu.CheckItem({ text: '��Ŀ����',value: 'itemName',checked: false,group: 'DataTypesFilter',checkHandler: onDataTypesItemCheck }),
        new Ext.menu.CheckItem({
            text: '�����Ŵ���',
            value: 'outServDeptCode',
            checked: false,
            group: 'DataTypesFilter',
            checkHandler: onDataTypesItemCheck
        }), new Ext.menu.CheckItem({
            text: '����������',
            value: 'outServDeptName',
            checked: false,
            group: 'DataTypesFilter',
            checkHandler: onDataTypesItemCheck
        }), new Ext.menu.CheckItem({
            text: '�������Ŵ���',
            value: 'outServedDeptCode',
            checked: false,
            group: 'DataTypesFilter',
            checkHandler: onDataTypesItemCheck
        }), new Ext.menu.CheckItem({
            text: '������������',
            value: 'outServedDeptName',
            checked: false,
            group: 'DataTypesFilter',
            checkHandler: onDataTypesItemCheck
        }), new Ext.menu.CheckItem({
            text: '�ɼ���ʽ',
            value: 'inType',
            checked: false,
            group: 'DataTypesFilter',
            checkHandler: onDataTypesItemCheck
        }), new Ext.menu.CheckItem({
            text: '�ɼ���',
            value: 'inPersonName',
            checked: false,
            group: 'DataTypesFilter',
            checkHandler: onDataTypesItemCheck
        }), new Ext.menu.CheckItem({
            text: '����',
            value: 'inDate',
            checked: false,
            group: 'DataTypesFilter',
            checkHandler: onDataTypesItemCheck
        }), new Ext.menu.CheckItem({
            text: '����ҽ������',
            value: 'fDocCode',
            checked: false,
            group: 'DataTypesFilter',
            checkHandler: onDataTypesItemCheck
        }), new Ext.menu.CheckItem({
            text: '����ҽ������',
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

var paramDatasSearchBox = new Ext.form.TwinTriggerField({//���Ұ�ť
    width: 180,
    trigger1Class: 'x-form-clear-trigger',
    trigger2Class: 'x-form-search-trigger',
    emptyText: '����...',
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

var paramDatasPagingToolbar = new Ext.PagingToolbar({//��ҳ������
    pageSize: 25,
    store: paramDatasDs,
    displayInfo: true,
    displayMsg: '��ǰ��ʾ{0} - {1}������{2}',
    emptyMsg: "û������",
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

var paramDatasMain = new Ext.grid.GridPanel({//���
    title: '�������ݱ�',
    store: paramDatasDs,
    cm: paramDatasCm,
    trackMouseOver: true,
    stripeRows: true,
    sm: new Ext.grid.RowSelectionModel({
        singleSelect: true
    }),
    loadMask: true,
    tbar: ['��������:', months, '-', '��Ŀ:', items, '-', opTool, '-', copeOtherMonthButton, '-', unAddDeptButton, '-', relationButton, '-', importTool,'-',editAAccCycleButton,'-',typeField,'-',excelButton],
    bbar: paramDatasPagingToolbar
});
