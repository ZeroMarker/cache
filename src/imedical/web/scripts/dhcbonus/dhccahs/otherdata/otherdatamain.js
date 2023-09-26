var otherdataUrl = 'dhc.ca.otherdataexe.csp';
var otherdataProxy = new Ext.data.HttpProxy({ url: otherdataUrl + '?action=list' });
var intervalDr = "";
var itemTypeId = "";
function formatDate(value) {
    //alert(value);
    return value ? value.dateFormat('Y-m-d') : '';
};

//接口部门套数据源
var otherdataDs = new Ext.data.Store({
    proxy: otherdataProxy,
    reader: new Ext.data.JsonReader({
        root: 'rows',
        totalProperty: 'results'
    }, [
            'rowid',
			'intervalDr',
			'intervalName',
			'sysDataType',
			'dataTypeDr',
			'dataTypeName',
			{ name: 'busDate', type: 'date', dateFormat: 'Y-m-d' },
			'itemDr',
			'itemInName',
			'itemCode',
			'itemName',
			'servedDeptDr',
			'servedInDeptName',
			'servedDeptCode',
			'servedDeptName',
			'receiverDr',
			'receiverInName',
			'receiverCode',
			'receiverName',
			'fee',
			'operType',
			{ name: 'operDate', type: 'date', dateFormat: 'Y-m-d' },
			'operDr',
			'operName',
			'operDeptDr',
			'operDeptName',
			'remark',
			'remark1',
			'remark2'
		]),
    // turn on remote sorting
    remoteSort: true
});

otherdataDs.setDefaultSort('order', 'asc');

var otherdataCm = new Ext.grid.ColumnModel([
	new Ext.grid.RowNumberer(),new Ext.grid.CheckboxSelectionModel(),
	{
	    header: '核算业务项',
	    dataIndex: 'itemInName',
	    width: 100,
	    align: 'left',
	    renderer:color,
	    sortable: true
	},
	{
	    header: '业务项代码',
	    dataIndex: 'itemCode',
	    width: 100,
	    align: 'left',
	    sortable: true
	},
	{
	    header: '业务项名称',
	    dataIndex: 'itemName',
	    width: 150,
	    align: 'left',
	    sortable: true
	},
	{
	    header: '核算部门名称',
	    dataIndex: 'servedInDeptName',
	    width: 150,
	    align: 'left',
	    renderer:color,
	    sortable: true
	},
	{
	    header: '部门代码',
	    dataIndex: 'servedDeptCode',
	    width: 100,
	    align: 'left',
	    sortable: true
	},
	{
	    header: '部门名称',
	    dataIndex: 'servedDeptName',
	    width: 150,
	    align: 'left',
	    sortable: true
	},
	{
	    header: '金额',
	    dataIndex: 'fee',
	    width: 100,
	    align: 'left',
	    sortable: true
	},
	{
	    header: '操作类别',
	    dataIndex: 'operType',
	    width: 100,
	    align: 'left',
	    sortable: true
	},
	{
	    header: "操作日期",
	    dataIndex: 'operDate',
	    width: 90,
	    renderer: formatDate,
	    align: 'left',
	    sortable: true
	},
	{
	    header: '执行人',
	    dataIndex: 'operName',
	    width: 150,
	    align: 'left',
	    sortable: true
	},
	{
	    header: '执行科室',
	    dataIndex: 'operDeptName',
	    width: 150,
	    align: 'left',
	    sortable: true
	},
	{
	    header: '备注',
	    dataIndex: 'remark',
	    width: 150,
	    align: 'left',
	    sortable: true
	}
]);
var monthsDs = new Ext.data.Store({
    proxy: "",
    reader: new Ext.data.JsonReader({ totalProperty: "results", root: 'rows' }, ['rowid', 'code', 'name', 'desc', 'start', 'end', 'dataFinish'])
});
var months = new Ext.form.ComboBox({
    id: 'months',
    fieldLabel: '核算区间',
    width: 100,
    listWidth: 260,
    allowBlank: false,
    store: monthsDs,
    //readOnly:true,
    valueField: 'rowid',
    displayField: 'name',
    triggerAction: 'all',
    emptyText: '选择核算区间...',
    pageSize: 10,
    minChars: 1,
    selectOnFocus: true,
    forceSelection: true
});
monthsDs.on('beforeload', function(ds, o) {
    ds.proxy = new Ext.data.HttpProxy({ url: 'dhc.ca.vouchdatasexe.csp?action=months&searchValue=' + Ext.getCmp('months').getRawValue(), method: 'GET' });
});
months.on("select", function(cmb, rec, id) {
    intervalDr = cmb.getValue();
    otherdataDs.load({ params: { start: 0, limit: otherdataPagingToolbar.pageSize, intervalDr: intervalDr, dataTypeDr: itemTypeId} });
});
var addDataTypesButton = new Ext.Toolbar.Button({
    text: '添加',
    tooltip: '添加新的接口部门套',
    iconCls: 'add',
    handler: function() { addFun(otherdataDs, otherdataMain, otherdataPagingToolbar); }
});

var editDataTypesButton = new Ext.Toolbar.Button({
    text: '修改',
    tooltip: '修改选定的接口部门套',
    iconCls: 'remove',
    disabled: true,
    handler: function() { editFun(otherdataDs, otherdataMain, otherdataPagingToolbar); }
});

var delDataTypesButton = new Ext.Toolbar.Button({
    text: '删除',
    tooltip: '删除选定的接口部门套',
    iconCls: 'remove',
    //disabled: true,
    handler: function() { delFun(otherdataDs, otherdataMain, otherdataPagingToolbar); }
});

var relationButton = new Ext.Toolbar.Button({
    text: '执行对照',
    tooltip: '执行对照',
    iconCls: 'remove',
    handler: function() {refreshFun(otherdataDs, otherdataMain, otherdataPagingToolbar)}
});

var importButton = new Ext.Toolbar.Button({
    text: 'Excel上传',
    tooltip: '导入数据',
    iconCls: 'remove',
    handler: function() { loadBusData(otherdataDs,otherdataPagingToolbar) }
});
//----------------人员接口归集

var PersonTogetherButton  = {
    text: '人员接口归集',
    tooltip: '人员接口归集',
    iconCls: 'remove',
    handler: function(){
        if (intervalDr == "") {
            Ext.Msg.show({
                title: '错误',
                msg: '请先选择核算区间!',
                buttons: Ext.Msg.OK,
                icon: Ext.MessageBox.ERROR
            });
            return;
        }
        
        Ext.MessageBox.confirm('提示', '确定要人员归集么?', function(btn){
            if (btn == 'yes') {
	            var loadMask = new Ext.LoadMask(document.body, {msg : '正在向服务器发送请求...'});	
                loadMask.show();
                Ext.Ajax.request({
                    url: otherdataUrl+'?action=move&intervalDr=' + intervalDr,
                    waitMsg: '归集中...',
                    failure: function(result, request){loadMask.hide();
                        Ext.Msg.show({
                            title: '错误',
                            msg: '请检查网络连接!',
                            buttons: Ext.Msg.OK,
                            icon: Ext.MessageBox.ERROR
                        });
                    },
                    success: function(result, request){ loadMask.hide();
                        var jsonData = Ext.util.JSON.decode(result.responseText);
                        if (jsonData.success == 'true') {
                            Ext.MessageBox.alert('提示', '导入成功!');
                            //paramDatasDs.load({
                            //    params: {
                            //        start: paramDatasPagingToolbar.cursor,
                            //        limit: paramDatasPagingToolbar.pageSize,
                            //        monthDr: monthDr,
                            //        itemDr: itemDr
                            //    }
                            //});
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
//----------U8财务总账导入
var importButtonU8  = {
		text: '导入财务总账',        
		tooltip: '导入财务总账数据',
		iconCls: 'remove',
		//disabled: true,
		handler: function(){
			
			Ext.MessageBox.confirm('提示', 
    	    '确认导入数据?', 
    	    function(btn) {
	    	     if(btn == 'yes')
		         {
					//var itemTypeId=itemTypeSelecter.getValue();
	    	         		var loadMask = new Ext.LoadMask(document.body, {msg : '正在向服务器发送请求...'});								
					if(intervalDr==""){
						Ext.Msg.show({title:'错误',msg:'请选择核算周期再试!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
						return;
					}
					else if(itemTypeId==""){
						Ext.Msg.show({title:'错误',msg:'请选择数据项类别再试!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
						return;
					}else{
                               	 	  loadMask.show();
						Ext.Ajax.request({
							url: 'dhc.ca.otherdataexe.csp?action=ImportGLaccass&intervalDr='+intervalDr+'&dataTypeDr='+itemTypeId+'&userCode='+userCode,
							waitMsg:'保存中...',
							failure: function(result, request) {
	    	                 			loadMask.hide();
								Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
								},
							success: function(result, request) {
	    	                 		loadMask.hide();
								var jsonData = Ext.util.JSON.decode( result.responseText );
								if (jsonData.success=='true') {
									Ext.Msg.show({title:'注意',msg:jsonData.info,buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
									otherdataDs.load({ params: { start: 0, limit: otherdataPagingToolbar.pageSize, intervalDr: intervalDr, dataTypeDr: itemTypeId} });
								}else{
									Ext.Msg.show({title:'注意',msg:'导入失败!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
								}
							},
							scope: this
						});
					}
				 }
			})
			
			
		}
};
//var YPRatio = new Ext.form.NumberField({
var YPRatio = new Ext.form.TextField({
		id: 'YPRatio',
		fieldLabel: '总药品与收入药品比例',
		//allowDecimals:false,
		allowBlank: false,
		iconCls: 'remove',
		//value:0,
		emptyText: '填写比值...',
		width:80,
		align: 'left',
		anchor: '50%'
	});

//----------按照药品收入比例导入药品成本
var importButtonYP = {
		text: '导入药品成本',        
		tooltip: '导入药品成本数据',
		iconCls: 'remove',
		//disabled: true,
		handler: function(){
			var Ratio = YPRatio.getValue();
			Ext.MessageBox.confirm('提示', 
    	    '确认导入数据?', 
    	    function(btn) {
	    	     if(btn == 'yes')
		         {
					//var itemTypeId=itemTypeSelecter.getValue();
	    	         		var loadMask = new Ext.LoadMask(document.body, {msg : '正在向服务器发送请求...'});								
					if(intervalDr==""){
						Ext.Msg.show({title:'错误',msg:'请选择核算周期再试!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
						return;
					}
					else if(itemTypeId==""){
						Ext.Msg.show({title:'错误',msg:'请选择数据项类别再试!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
						return;
					}else if(Ratio==""){
						Ext.Msg.show({title:'错误',msg:'请填写总药品与药品收入比值后再试!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
						return;
					}
					else{
                               	 	  loadMask.show();
						Ext.Ajax.request({
							url: 'dhc.ca.otherdataexe.csp?action=ImportYPData&intervalDr='+intervalDr+'&dataTypeDr='+itemTypeId+'&Ratio='+Ratio+'&userCode='+userCode,
							waitMsg:'保存中...',
							failure: function(result, request) {
	    	                 			loadMask.hide();
								Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
								},
							success: function(result, request) {
	    	                 		loadMask.hide();
								var jsonData = Ext.util.JSON.decode( result.responseText );
								if (jsonData.success=='true') {
									Ext.Msg.show({title:'注意',msg:jsonData.info,buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
									otherdataDs.load({ params: { start: 0, limit: otherdataPagingToolbar.pageSize, intervalDr: intervalDr, dataTypeDr: itemTypeId} });
								}else{
									Ext.Msg.show({title:'注意',msg:'导入失败!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
								}
							},
							scope: this
						});
					}
				 }
			})
			
			
		}
};

//----------折旧成本导入 20160324 zjw
var importButtonZJ  = {
		text: '导入折旧成本数据',        
		tooltip: '导入折旧数据',
		iconCls: 'remove',
		disabled: true,
		handler: function(){
			
			Ext.MessageBox.confirm('提示', 
    	    '确认导入数据?', 
    	    function(btn) {
	    	     if(btn == 'yes')
		         {
					//var itemTypeId=itemTypeSelecter.getValue();
	    	         		var loadMask = new Ext.LoadMask(document.body, {msg : '正在向服务器发送请求...'});								
					if(intervalDr==""){
						Ext.Msg.show({title:'错误',msg:'请选择核算周期再试!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
						return;
					}
					else if(itemTypeId==""){
						Ext.Msg.show({title:'错误',msg:'请选择数据项类别再试!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
						return;
					}else{
                               	 	  loadMask.show();
						Ext.Ajax.request({
							url: 'dhc.ca.otherdataexe.csp?action=ImportZJs&intervalDr='+intervalDr+'&dataTypeDr='+itemTypeId+'&userCode='+userCode,
							waitMsg:'保存中...',
							failure: function(result, request) {
	    	                 			loadMask.hide();
								Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
								},
							success: function(result, request) {
	    	                 		loadMask.hide();
								var jsonData = Ext.util.JSON.decode( result.responseText );
								if (jsonData.success=='true') {
									Ext.Msg.show({title:'注意',msg:jsonData.info,buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
									otherdataDs.load({ params: { start: 0, limit: otherdataPagingToolbar.pageSize, intervalDr: intervalDr, dataTypeDr: itemTypeId} });
								}else{
									Ext.Msg.show({title:'注意',msg:'导入失败!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
								}
							},
							scope: this
						});
					}
				 }
			})
			
			
		}
};



//----------

var totalButton = new Ext.Toolbar.Button({
    text: '统计汇总',
    tooltip: '统计汇总',
    iconCls: 'remove',
    handler: function() { CommFindFun(otherdataDs, otherdataMain, otherdataPagingToolbar) }
});
	var itemTypeDs = new Ext.data.Store({
		autoLoad: true,
		proxy: '',
		reader: new Ext.data.JsonReader({totalProperty:"results",root:'rows',id: 'rowid'},['shortcut','rowid'])
	});
	
	itemTypeDs.on(
		'beforeload',
		function(ds, o){
			ds.proxy = new Ext.data.HttpProxy({url:otherdataUrl+'?action=listItemType&active=Y&searchField=shortcut&searchValue='+Ext.getCmp('itemTypeSelecter').getRawValue()+'&id='+DATATYPEID, method:'GET'});
		}
	);
	
	var itemTypeSelecter = new Ext.form.ComboBox({
		id:'itemTypeSelecter',
		fieldLabel:'数据类',
		store: itemTypeDs,
		valueField:'rowid',
		//disabled:true,
		displayField:'shortcut',
		typeAhead:true,
		pageSize:10,
		minChars:1,
		width:100,
		listWidth:250,
		triggerAction:'all',
		emptyText:'选择数据项类别...',
		allowBlank: true,
		selectOnFocus: true,
		forceSelection: true
	});
	itemTypeSelecter.on("select", function(cmb, rec, id) {
		if (intervalDr == "") {
			Ext.Msg.show({ title: '错误', msg: '请选择核算区间再试!', buttons: Ext.Msg.OK, icon: Ext.MessageBox.ERROR });
			return;
		}
		itemTypeId = cmb.getValue();
		otherdataDs.load({ params: { start: 0, limit: otherdataPagingToolbar.pageSize, intervalDr: intervalDr, dataTypeDr: itemTypeId} });
	});
var otherdataSearchField = 'itemInName';

var otherdataFilterItem = new Ext.Toolbar.MenuButton({
    text: '过滤器',
    tooltip: '关键字所属类别',
    menu: { items: [
				new Ext.menu.CheckItem({ text: '<span style="color:blue;">核算项目</span>', value: 'itemInName', checked: true, group: 'DataTypesFilter', checkHandler: onDataTypesItemCheck }),
				new Ext.menu.CheckItem({ text: '项目代码', value: 'itemCode', checked: false, group: 'DataTypesFilter', checkHandler: onDataTypesItemCheck }),
				new Ext.menu.CheckItem({ text: '项目名称', value: 'itemName', checked: false, group: 'DataTypesFilter', checkHandler: onDataTypesItemCheck }),
				new Ext.menu.CheckItem({ text: '<span style="color:blue;">核算部门</span>', value: 'servedInDeptName', checked: false, group: 'DataTypesFilter', checkHandler: onDataTypesItemCheck }),
				new Ext.menu.CheckItem({ text: '部门代码', value: 'servedDeptCode', checked: false, group: 'DataTypesFilter', checkHandler: onDataTypesItemCheck }),
				new Ext.menu.CheckItem({ text: '部门名称', value: 'servedDeptName', checked: false, group: 'DataTypesFilter', checkHandler: onDataTypesItemCheck }),
				//new Ext.menu.CheckItem({ text: '内部人员', value: 'receiverInName', checked: false, group: 'DataTypesFilter', checkHandler: onDataTypesItemCheck }),
				//new Ext.menu.CheckItem({ text: '人员代码', value: 'receiverCode', checked: false, group: 'DataTypesFilter', checkHandler: onDataTypesItemCheck }),
				//new Ext.menu.CheckItem({ text: '人员名称', value: 'receiverName', checked: false, group: 'DataTypesFilter', checkHandler: onDataTypesItemCheck }),
				new Ext.menu.CheckItem({ text: '金额', value: 'fee', checked: false, group: 'DataTypesFilter', checkHandler: onDataTypesItemCheck }),
				new Ext.menu.CheckItem({ text: '操作日期', value: 'operDate', checked: false, group: 'DataTypesFilter', checkHandler: onDataTypesItemCheck }),
				new Ext.menu.CheckItem({ text: '操作人', value: 'operName', checked: false, group: 'DataTypesFilter', checkHandler: onDataTypesItemCheck }),
				new Ext.menu.CheckItem({ text: '备注', value: 'remark', checked: false, group: 'DataTypesFilter', checkHandler: onDataTypesItemCheck })
		]
    }
});

function onDataTypesItemCheck(item, checked) {
    if (checked) {
        otherdataSearchField = item.value;
        otherdataFilterItem.setText(item.text + ':');
    }
};

var otherdataSearchBox = new Ext.form.TwinTriggerField({//查找按钮
    width: 180,
    trigger1Class: 'x-form-clear-trigger',
    trigger2Class: 'x-form-search-trigger',
    emptyText: '搜索...',
    listeners: {
        specialkey: { fn: function(field, e) {
            var key = e.getKey();
            if (e.ENTER === key) { this.onTrigger2Click(); } 
        } 
        }
    },
    grid: this,
    onTrigger1Click: function() {
        if (this.getValue()) {
            this.setValue('');
            otherdataDs.proxy = new Ext.data.HttpProxy({ url: otherdataUrl + '?action=list' });
            otherdataDs.load({ params: { start: 0, limit: otherdataPagingToolbar.pageSize, intervalDr: intervalDr, dataTypeDr: itemTypeId} });
        }
    },
    onTrigger2Click: function() {
        if (this.getValue()) {
            otherdataDs.proxy = new Ext.data.HttpProxy({
                url: otherdataUrl + '?action=list&searchField=' + otherdataSearchField + '&searchValue=' + this.getValue()
            });
            otherdataDs.load({ params: { start: 0, limit: otherdataPagingToolbar.pageSize, intervalDr: intervalDr, dataTypeDr: itemTypeId} });
        }
    }
});

var otherdataPagingToolbar = new Ext.PagingToolbar({//分页工具栏
    pageSize: 25,
    store: otherdataDs,
    displayInfo: true,
    displayMsg: '当前显示{0} - {1}，共计{2}',
    emptyMsg: "没有数据",
    buttons: ['-', otherdataFilterItem, '-', otherdataSearchBox],
    doLoad: function(C) {
        var B = {},
		A = this.paramNames;
        B[A.start] = C;
        B[A.limit] = this.pageSize;
        B['intervalDr'] = intervalDr;
        B['dataTypeDr'] = itemTypeId;
        if (this.fireEvent("beforechange", this, B) !== false) {
            this.store.load({ params: B });
        }
    }

});

var otherdataMain = new Ext.grid.GridPanel({//表格
    title: '其他数据',
    store: otherdataDs,
    cm: otherdataCm,
    trackMouseOver: true,
    stripeRows: true,
    //sm: new Ext.grid.RowSelectionModel({ singleSelect: true }),
    sm: new Ext.grid.CheckboxSelectionModel(),
    loadMask: true,
    //tbar: ['核算周期:', months,"数据项类别", '-',itemTypeSelecter,'-', addDataTypesButton, '-', delDataTypesButton, '-', importButton, '-',importButtonU8, '-','总药品/药品收入:', YPRatio,'-', importButtonYP, '-', relationButton, '-', totalButton],
    tbar: ['核算周期:', months,"数据项类别", '-',itemTypeSelecter,'-', addDataTypesButton, '-', delDataTypesButton, '-', importButton, '-',importButtonU8, '-',importButtonZJ, '-', relationButton, '-', totalButton],
    bbar: otherdataPagingToolbar
});

//otherdataDs.load({params:{start:0, limit:otherdataPagingToolbar.pageSize}});