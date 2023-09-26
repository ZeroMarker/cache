var incomeDatasUrl = 'dhc.ca.incomedatasexe.csp';
var incomeDatasProxy = new Ext.data.HttpProxy({url: incomeDatasUrl + '?action=list'});
var monthDr = "";

var user=session['GROUPDESC'];

function formatDate(value){
	return value?value.dateFormat('Y-m-d'):'';
};
var incomeDatasDs = new Ext.data.Store({
		proxy: incomeDatasProxy,
    reader: new Ext.data.JsonReader({
        root: 'rows',
        totalProperty: 'results'
        }, [
            'rowid',
			'intervalDr',
			'intervalName',
			{name:'feeDate',type:'date',dateFormat:'Y-m-d'},
			'patType',
			'itemCode',
			'itemName',
			'itemDr',
			'inItemCode',
			'inItemName',
			'fee',
			'cost',
			'fDeptCode',
			'fDeptName',
			'fDeptDr',
			'inFDeptCode',
			'inFDeptName',
			'tDeptCode',
			'tDeptName',
			'tDeptDr',
			'inTDeptCode',
			'inTDeptName',
			'patDeptCode',
			'patDeptName',
			'patDeptDr',
			'inPatDeptCode',
			'inPatDeptName',
			'inType',
			'personDr',
			'personName',
			{name:'inDate',type:'date',dateFormat:'Y-m-d'},
			'remark',
			'patWardCode',
			'patWardDesc',
			'patWardDr',
			'inPatWardCode',
			'inPatWardDesc',
			'patDocCode',
			'patDocDesc',
			'patDocDr',
			'inPatDocCode',
			'inPatDocDesc',
			'fDocCode',
			'fDocName',
			'fDocDr',
			'fInDocName'
			
		]),
    // turn on remote sorting
    remoteSort: true
});

incomeDatasDs.setDefaultSort('rowid', 'desc');

var incomeDatasCm = new Ext.grid.ColumnModel([
	new Ext.grid.RowNumberer(),new Ext.grid.CheckboxSelectionModel(),
	{
		header: '病人类型',
		dataIndex: 'patType',
		width: 40,
		align: 'left',
		sortable: true
    },
	{
		header: '项目代码',
		dataIndex: 'itemCode',
		width: 100,
		align: 'left',
		sortable: true
    },
	{
        header: '项目名称',
        dataIndex: 'itemName',
        width: 100,
        align: 'left',
        sortable: true
    },
	{
        header: '核算项目名称',
        dataIndex: 'inItemName',
        width: 100,
        align: 'left',
        renderer:color,
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
        header: '开单部门代码',
        dataIndex: 'fDeptCode',
        width: 100,
        align: 'left',
        sortable: true
    },
	{
        header: '开单部门名称',
        dataIndex: 'fDeptName',
        width: 100,
        align: 'left',
        sortable: true
    },
	{
        header: '核算开单部门名称',
        dataIndex: 'inFDeptName',
        width: 100,
        align: 'left',
        renderer:color,
        sortable: true
    },
	{
        header: '接收部门代码',
        dataIndex: 'tDeptCode',
        width: 100,
        align: 'left',
        sortable: true
    },
	{
        header: '接收部门名称',
        dataIndex: 'tDeptName',
        width: 100,
        align: 'left',
        sortable: true
    },
	{
        header: '核算接收部门名称',
        dataIndex: 'inTDeptName',
        width: 100,
        align: 'left',
        renderer:color,
        sortable: true
    },
	{
        header: '病人部门代码',
        dataIndex: 'patDeptCode',
        width: 100,
        align: 'left',
        sortable: true
    },
	{
        header: '病人部门名称',
        dataIndex: 'patDeptName',
        width: 100,
        align: 'left',
        sortable: true
    },
	{
        header: '核算病人部门名称',
        dataIndex: 'inPatDeptName',
        width: 100,
        align: 'left',
        renderer:color,
        sortable: true
    },/*zjw 20160809 pingbi
	{
        header: '外部病人病区代码',
        dataIndex: 'patWardCode',
        width: 100,
        align: 'left',
	hidden:true,
        sortable: true
    },
	{
        header: '外部病人病区名称',
        dataIndex: 'patWardDesc',
        width: 100,
        align: 'left',
	hidden:true,
        sortable: true
    },
	{
        header: '核算病人病区名称',
        dataIndex: 'inPatWardDesc',
        width: 100,
        align: 'left',
        renderer:color,
	hidden:true,
        sortable: true
    },
	{
        header: '外部病人医生代码',
        dataIndex: 'patDocCode',
        width: 100,
        align: 'left',
	hidden:true,
        sortable: true
    },
	{
        header: '外部病人医生名称',
        dataIndex: 'patDocDesc',
        width: 100,
        align: 'left',
	hidden:true,
        sortable: true
    },
	{
        header: '内部病人医生名称',
        dataIndex: 'inPatWardDesc',
        width: 100,
        align: 'left',
        hidden:true,
        sortable: true
    },*/
	{
        header: '录入类型',
        dataIndex: 'inType',
        width: 100,
        align: 'left',
        sortable: true
    },{
        header: '采集人',
        dataIndex: 'personName',
        width: 70,
        align: 'left',
        sortable: true
    },
	{
        header: '采集日期',
        dataIndex: 'inDate',
        width: 70,
	renderer:formatDate,
        align: 'left',
        sortable: true
    },
	{
        header: '备注',
        dataIndex: 'remark',
        width: 100,
        align: 'left',
	//hidden:true,
        sortable: true
    }/*zjw 20160809 pingbi, 
{
    header: '开单医生代码',
    dataIndex: 'fDocCode',
    width: 70,
    align: 'left',
    hidden:true,
    sortable: true
}, 
{
    header: '开单医生名称',
    dataIndex: 'fDocName',
    width: 70,
    align: 'left',
    hidden:true,
    sortable: true
}, {
    header: '开单医生',
    dataIndex: 'fInDocName',
    width: 70,
    align: 'left',
    hidden:true,
    sortable: true
}*/
]);
var monthsDs = new Ext.data.Store({
	proxy: "",                                                           
	reader: new Ext.data.JsonReader({totalProperty:"results",root:'rows'},['rowid','code','name','desc','start','end','dataFinish'])
});
var months = new Ext.form.ComboBox({
	id: 'months',
	fieldLabel: '核算区间',
	width: 80,
	listWidth : 200,
	allowBlank: false,
	store: monthsDs,
	//readOnly:true,
	valueField: 'rowid',
	displayField: 'name',
	triggerAction: 'all',
	emptyText:'选择核算区间...',
	pageSize: 10,
	minChars: 1,
	selectOnFocus: true,
	forceSelection: true
});
monthsDs.on('beforeload', function(ds, o){
	ds.proxy=new Ext.data.HttpProxy({url:'dhc.ca.vouchdatasexe.csp?action=months&searchValue='+Ext.getCmp('months').getRawValue(),method:'GET'});
});	

//----------------------------------------------------------------------------------------------
var loadRulesDs = new Ext.data.Store({
	proxy: "",                                                           
	reader: new Ext.data.JsonReader({totalProperty:"results",root:'rows'},['rowId','order','code','name','deptSetDr','itemSetDr','itemTypeDr','deptSetName','itemSetName','itemTypeName'])
});
var loadRules = new Ext.form.ComboBox({
	id: 'loadRules',
	fieldLabel: '导入规则',
	width: 80,
	listWidth : 200,
	allowBlank: false,
	store: loadRulesDs,
	valueField: 'rowId',
	displayField: 'name',
	triggerAction: 'all',
	//readOnly:true,
	emptyText:'选择导入规则...',
	pageSize: 10,
	minChars: 1,
	selectOnFocus: true,
	forceSelection: true
});
loadRulesDs.on('beforeload', function(ds, o){
	ds.proxy=new Ext.data.HttpProxy({url:'dhc.ca.incomedatasexe.csp?action=loadrules&searchValue='+Ext.getCmp('loadRules').getRawValue(),method:'GET'});
});	
//---------------------------------------------------------------------------------------------

months.on("select",function(cmb,rec,id ){
	monthDr=cmb.getValue();
	/**
	Ext.Ajax.request({
		url: 'dhc.ca.vouchdatasexe.csp?action=checkMonth&monthDr='+monthDr,
		waitMsg:'保存中...',
		failure: function(result, request) {
			Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
		},
		success: function(result, request) {
			var jsonData = Ext.util.JSON.decode( result.responseText );
			if (jsonData.success!='true') {
				addDataTypesButton.setDisabled(true);
				editDataTypesButton.setDisabled(true);
				delDataTypesButton.setDisabled(true);
			}else{
				addDataTypesButton.setDisabled(false);
				editDataTypesButton.setDisabled(false);
				delDataTypesButton.setDisabled(false);
			}
		},
		scope: this
	});
	*/
	incomeDatasDs.load({params:{start:0, limit:incomeDatasPagingToolbar.pageSize, monthDr:monthDr}});
});

var addDataTypesButton = new Ext.Toolbar.Button({
		text: '添加',
		tooltip: '添加新的收入数据表',        
		iconCls: 'add',
		handler: function(){addFun(incomeDatasDs,incomeDatasMain,incomeDatasPagingToolbar);}
});

var editDataTypesButton  = new Ext.Toolbar.Button({
		text: '修改',        
		tooltip: '修改选定的收入数据表',
		iconCls: 'remove',
		handler: function(){editFun(incomeDatasDs,incomeDatasMain,incomeDatasPagingToolbar);}
});

var delDataTypesButton  = new Ext.Toolbar.Button({
		text: '按选行/当月删除',        
		tooltip: '删除选定的收入数据表',
		iconCls: 'remove',
		//disabled: true,
		handler: function(){delFun(incomeDatasDs,incomeDatasMain,incomeDatasPagingToolbar);}
});

var delMonthDataButton  = {
		text: '按月份删除',        
		tooltip: '删除选定的月份收入数据表',
		iconCls: 'remove',
		//disabled: true,
		handler: function(){
			if(monthDr=="")
			{
				Ext.Msg.show({title:'注意',msg:'请选择月份后再试!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
				return;
			}
				Ext.MessageBox.confirm('提示', 
					'确定要删除此月的数据?', 
					function(btn) {
						if(btn == 'yes'){
							//--------------------------------------
							Ext.Ajax.request({
								url: incomeDatasUrl+'?action=delMonth&monthDr='+monthDr,
								waitMsg:'保存中...',
								failure: function(result, request) {
									Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
								},
								success: function(result, request) {
									var jsonData = Ext.util.JSON.decode( result.responseText );
								if (jsonData.success=='true') {
									Ext.Msg.show({title:'注意',msg:'删除成功!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
										incomeDatasDs.setDefaultSort('rowid', 'desc');
										incomeDatasDs.load({params:{start:0, limit:incomeDatasPagingToolbar.pageSize, monthDr:monthDr}});
										//window.close();
									}
									else
									{
										var message = "";
										message = "SQLErr: " + jsonData.info;
										Ext.Msg.show({title:'错误',msg:message,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
									}
								},
							scope: this
							});
							//--------------------------------------
						}
					}
				)
		}
};



var importButtonO  = {
		text: '导入门诊',        
		tooltip: '导入门诊收入数据',
		iconCls: 'remove',
		//disabled: true,[
		handler: function(){
			Ext.MessageBox.confirm('提示', 
    	    '确认导入数据?', 
    	    function(btn) {
	    	     if(btn == 'yes')
		         {
					var ruleDr=loadRules.getValue();
	    	         		var loadMask = new Ext.LoadMask(document.body, {msg : '正在向服务器发送请求...'});								
					if(monthDr==""){
						Ext.Msg.show({title:'错误',msg:'请选择核算区间再试!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
						return;
					}
					else if(ruleDr==""){
						Ext.Msg.show({title:'错误',msg:'请选择导入规则再试!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
						return;
					}else{
                               	 	  loadMask.show();
						Ext.Ajax.request({
                                               
							url: 'dhc.ca.incomedatasexe.csp?action=importo&monthDr='+monthDr+'&ruleDr='+ruleDr+'&userCode='+userCode,
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
									incomeDatasDs.load({params:{start:0, limit:incomeDatasPagingToolbar.pageSize, monthDr:monthDr}});
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

var importButtonGh  = {
		text: '导入挂号',
		hidden:true,        
		tooltip: '导入挂号数据',
		iconCls: 'remove',
		//disabled: true,
		handler: function(){
			Ext.MessageBox.confirm('提示', 
    	    '确认导入数据?', 
    	    function(btn) {
	    	     if(btn == 'yes')
		         {
					var ruleDr=loadRules.getValue();
					if(monthDr==""){
						Ext.Msg.show({title:'错误',msg:'请选择核算区间再试!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
						return;
					}
					else if(ruleDr==""){
						Ext.Msg.show({title:'错误',msg:'请选择导入规则再试!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
						return;
					}else{
						Ext.Ajax.request({
							url: 'dhc.ca.incomedatasexe.csp?action=importG&monthDr='+monthDr+'&ruleDr='+ruleDr+'&userCode='+userCode,
							waitMsg:'保存中...',
							failure: function(result, request) {
								loadMask.hide();
								Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							},
							success: function(result, request) {
								var jsonData = Ext.util.JSON.decode( result.responseText );
								if (jsonData.success=='true') {
									Ext.Msg.show({title:'注意',msg:jsonData.info,buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
									incomeDatasDs.load({params:{start:0, limit:incomeDatasPagingToolbar.pageSize, monthDr:monthDr}});
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

var importButtonI  = {
		text: '导入住院',        
		tooltip: '导入住院收入数据',
		 //hidden:true,
		iconCls: 'remove',
		//disabled: true,
		handler: function(){
			Ext.MessageBox.confirm('提示', 
    	    '确认导入数据?', 
    	    function(btn) {
	    	     if(btn == 'yes')
		         {
					var ruleDr=loadRules.getValue();
	    	         		var loadMask = new Ext.LoadMask(document.body, {msg : '正在向服务器发送请求...'});								
					
					if(monthDr==""){
						Ext.Msg.show({title:'错误',msg:'请选择核算区间再试!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
						return;
					}
					else if(ruleDr==""){
						Ext.Msg.show({title:'错误',msg:'请选择导入规则再试!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
						return;
					}else{
                               	 	  loadMask.show();
						Ext.Ajax.request({
							url: 'dhc.ca.incomedatasexe.csp?action=importi&monthDr='+monthDr+'&ruleDr='+ruleDr+'&userCode='+userCode,
							waitMsg:'保存中...',
							failure: function(result, request) {
								Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							},
							success: function(result, request) {
								loadMask.hide();
								var jsonData = Ext.util.JSON.decode( result.responseText );
								if (jsonData.success=='true') {
									Ext.Msg.show({title:'注意',msg:jsonData.info,buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
									incomeDatasDs.load({params:{start:0, limit:incomeDatasPagingToolbar.pageSize, monthDr:monthDr}});
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

var importButtonE  = {
		text: '导入急诊',        
		tooltip: '导入急诊收入数据',
         //hidden:true,
		iconCls: 'remove',
		//disabled: true,
		handler: function(){
			Ext.MessageBox.confirm('提示', 
    	    '确认导入数据?', 
    	    function(btn) {
	    	     if(btn == 'yes')
		         {
					var ruleDr=loadRules.getValue();
					var loadMask = new Ext.LoadMask(document.body, {msg : '正在向服务器发送请求...'});								
					
					if(monthDr==""){
						Ext.Msg.show({title:'错误',msg:'请选择核算区间再试!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
						return;
					}
					else if(ruleDr==""){
						Ext.Msg.show({title:'错误',msg:'请选择导入规则再试!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
						return;
					}else{
						  loadMask.show();
						Ext.Ajax.request({
							url: 'dhc.ca.incomedatasexe.csp?action=importe&monthDr='+monthDr+'&ruleDr='+ruleDr+'&userCode='+userCode,
							waitMsg:'保存中...',
							failure: function(result, request) {
								Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							},
							success: function(result, request) {
								loadMask.hide();
								var jsonData = Ext.util.JSON.decode( result.responseText );
								if (jsonData.success=='true') {
									Ext.Msg.show({title:'注意',msg:jsonData.info,buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
									incomeDatasDs.load({params:{start:0, limit:incomeDatasPagingToolbar.pageSize, monthDr:monthDr}});
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

var importButtonH  = {
		text: '导入体检',      
		tooltip: '导入体检收入数据',
        hidden:true,        
		iconCls: 'remove',
		//disabled: true,
		handler: function(){
			Ext.MessageBox.confirm('提示', 
    	    '确认导入数据?', 
    	    function(btn) {
	    	     if(btn == 'yes')
		         {
					var ruleDr=loadRules.getValue();
					var loadMask = new Ext.LoadMask(document.body, {msg : '正在向服务器发送请求...'});								
					
					if(monthDr==""){
						Ext.Msg.show({title:'错误',msg:'请选择核算区间再试!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
						return;
					}
					else if(ruleDr==""){
						Ext.Msg.show({title:'错误',msg:'请选择导入规则再试!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
						return;
					}else{
						loadMask.show();
						Ext.Ajax.request({
							url: 'dhc.ca.incomedatasexe.csp?action=importh&monthDr='+monthDr+'&ruleDr='+ruleDr+'&userCode='+userCode,
							waitMsg:'保存中...',
							failure: function(result, request) {
								Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							},
							success: function(result, request) {
								loadMask.hide();
								var jsonData = Ext.util.JSON.decode( result.responseText );
								if (jsonData.success=='true') {
									Ext.Msg.show({title:'注意',msg:jsonData.info,buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
									incomeDatasDs.load({params:{start:0, limit:incomeDatasPagingToolbar.pageSize, monthDr:monthDr}});
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

var SearchUnrefreshButton  = new Ext.Toolbar.Button({
		text: '查看未对照数据',        
		tooltip: '查看未对照数据',
		iconCls: 'remove',
		//disabled: true,
		handler: function(){CommFindFun();}
});

var findcompreButton  = new Ext.Toolbar.Button({
		text: '综合查询',        
		tooltip: '综合查询...',
		iconCls: 'remove',
                disabled: true,
		handler: function(){CompreFindFun();}
});
var refreshButton  = new Ext.Toolbar.Button({
		text: '执行数据对照',        
		tooltip: '对应数据项与科室',
		iconCls: 'remove',
		//disabled: true,
		handler: function(){refresh(incomeDatasDs,incomeDatasMain,incomeDatasPagingToolbar,monthDr,"1");}
});
/*
var refreshButton  = new Ext.Toolbar.Button({
		text: '刷新数据',        
		tooltip: '对应数据项与科室',
		iconCls: 'remove',
		//disabled: true,
		handler: function(){
			var ruleDr=loadRules.getValue();
			if(monthDr==""){
				Ext.Msg.show({title:'错误',msg:'请选择核算区间再试!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
				return;
			}
			else if(ruleDr==""){
				Ext.Msg.show({title:'错误',msg:'请选择导入规则再试!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
				return;
			}else{
				Ext.Ajax.request({
					url: 'dhc.ca.incomedatasexe.csp?action=refresh&monthDr='+monthDr+'&ruleDr='+ruleDr, //+'&userCode='+userCode, 
					waitMsg:'保存中...',
					failure: function(result, request) {
						Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
					},
					success: function(result, request) {
						var jsonData = Ext.util.JSON.decode( result.responseText );
						if (jsonData.success=='true') {
							Ext.Msg.show({title:'注意',msg:'刷新成功!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
							incomeDatasDs.load({params:{start:0, limit:incomeDatasPagingToolbar.pageSize, monthDr:monthDr}});
						}else{
							Ext.Msg.show({title:'注意',msg:'导入失败!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
						}
					},
					scope: this
				});
			}
		}
});*/
//--------------------------------------------
var innerDeptControlButton  = new Ext.Toolbar.Button({
		text: '内部部门转换',        
		tooltip: '内部部门转换',
		iconCls: 'remove',
		//disabled: true,
		handler: function(){
			var ruleDr=loadRules.getValue();
			if(monthDr==""){
				Ext.Msg.show({title:'错误',msg:'请选择核算区间再试!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
				return;
			}else{
				InnerDeptControl();
			}
		}
});
//--------------------------------------------
var opMenu = new Ext.menu.Menu({
    id: 'opMenu',
    //items: [importButtonO,importButtonI,importButtonE,importButtonH,importButtonGh]
    items: [importButtonO,importButtonI]
});
var opTool = new Ext.Toolbar([{
    text: '数据导入',
    iconCls: 'add',
    //disabled: true,
    menu: opMenu
}]);


var importButton = ({
    text: 'EXCEL上传',
    tooltip: '上传收入',
    iconCls: 'add',
    handler: function() { loadIncomeDatas(incomeDatasDs,incomeDatasPagingToolbar) }
});



//----------zjw 20160718 按照可是项目收入比例拆解冲销额并导
//var YPRatio = new Ext.form.NumberField({
//var CXMoney = new Ext.form.TextField
var WriteOffCharge = new Ext.form.TextField({
		id: 'WriteOffCharge',
		fieldLabel: '收入冲销额',
		//allowDecimals:false,
		allowBlank: false,
		iconCls: 'remove',
		//value:0,
		emptyText: '冲销额...',
		width:60,
		align: 'left',
		anchor: '50%'
	});
var importButtonCX = {
		text: '拆解冲销额',        
		tooltip: '拆解收入冲销',
		iconCls: 'remove',
		//disabled: true,
		handler: function(){
			
			
			
			Ext.MessageBox.confirm('提示', 
    	    '确认导入数据?', 
    	    function(btn) {
	    	     if(btn == 'yes')
		         {
					//var itemTypeId=itemTypeSelecter.getValue();
					var ruleDr=loadRules.getValue();
					//alert(ruleDr)
					var CXMoney=WriteOffCharge.getValue();
					//alert(CXMoney)
	    	         		var loadMask = new Ext.LoadMask(document.body, {msg : '正在向服务器发送请求...'});								
					if(monthDr==""){
						Ext.Msg.show({title:'错误',msg:'请选择核算周期再试!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
						return;
					}
					else if(ruleDr==""){
						Ext.Msg.show({title:'错误',msg:'请选择导入规则再试!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
						return;
					}else if(CXMoney==""){
						Ext.Msg.show({title:'错误',msg:'请填写收入冲销额后再试!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
						return;
					}else if(CXMoney<=0){
						Ext.Msg.show({title:'错误',msg:'请填入大于零的收入冲销额后再试!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
						return;
					}
					else{
                               	 	  loadMask.show();
						Ext.Ajax.request({
							url: 'dhc.ca.incomedatasexe.csp?action=ImportCXData&monthDr='+monthDr+'&CXMoney='+CXMoney+'&userCode='+userCode,
							waitMsg:'保存中...',
							failure: function(result, request) {
								//alert("1")
	    	                 			loadMask.hide();
								Ext.Msg.show({title:'错误',msg:jsonData.info,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
								},
							success: function(result, request) {
								//alert("2")
	    	                 		loadMask.hide();
								var jsonData = Ext.util.JSON.decode( result.responseText );
								if (jsonData.success=='true') {
									Ext.Msg.show({title:'注意',msg:jsonData.info,buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
									incomeDatasDs.load({ params: { start: 0, limit: incomeDatasPagingToolbar.pageSize, monthDr:monthDr} });
								}else{
									Ext.Msg.show({title:'注意',msg:jsonData.info,buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
								}
							},
							scope: this
						});
					}
				 }
			})
			
			
		}
};
//----------------------

var IncomeDataTypesButton  = new Ext.Toolbar.Button({
		text: '统计收入',        
		tooltip: '统计收入数据',
		iconCls: 'remove',
		handler: function(){CommFindIncomeFun();}
});
    
var incomeDatasSearchField = 'patType';

var incomeDatasFilterItem = new Ext.Toolbar.MenuButton({
		text: '过滤器',
		tooltip: '关键字所属类别',
		menu: {items: [
				new Ext.menu.CheckItem({ text: '收入日期',value: 'feeDate',checked: false,group: 'DataTypesFilter',checkHandler: onDataTypesItemCheck }),
				new Ext.menu.CheckItem({ text: '病人类型',value: 'patType',checked: true,group: 'DataTypesFilter',checkHandler: onDataTypesItemCheck }),
				new Ext.menu.CheckItem({ text: '项目代码',value: 'itemCode',checked: false,group: 'DataTypesFilter',checkHandler: onDataTypesItemCheck }),
				new Ext.menu.CheckItem({ text: '项目名称',value: 'itemName',checked: false,group: 'DataTypesFilter',checkHandler: onDataTypesItemCheck }),
				new Ext.menu.CheckItem({ text: '<span style="color:blue;">核算项目名称</span>',value: 'inItemName',checked: false,group: 'DataTypesFilter',checkHandler: onDataTypesItemCheck }),
				new Ext.menu.CheckItem({ text: '金额',value: 'fee',checked: false,group: 'DataTypesFilter',checkHandler: onDataTypesItemCheck }),
				//new Ext.menu.CheckItem({ text: '成本',value: 'cost',checked: false,group: 'DataTypesFilter',checkHandler: onDataTypesItemCheck }),
				new Ext.menu.CheckItem({ text: '开单部门代码',value: 'fDeptCode',checked: true,group: 'DataTypesFilter',checkHandler: onDataTypesItemCheck }),
				new Ext.menu.CheckItem({ text: '开单部门名称',value: 'fDeptName',checked: false,group: 'DataTypesFilter',checkHandler: onDataTypesItemCheck }),
				new Ext.menu.CheckItem({ text: '<span style="color:blue;">核算开单部门名称</span>',value: 'inFDeptName',checked: false,group: 'DataTypesFilter',checkHandler: onDataTypesItemCheck }),				
				new Ext.menu.CheckItem({ text: '接收部门代码',value: 'tDeptCode',checked: true,group: 'DataTypesFilter',checkHandler: onDataTypesItemCheck }),
				new Ext.menu.CheckItem({ text: '接收部门名称',value: 'tDeptName',checked: false,group: 'DataTypesFilter',checkHandler: onDataTypesItemCheck }),
				new Ext.menu.CheckItem({ text: '<span style="color:blue;">核算接收部门名称</span>',value: 'inTDeptName',checked: false,group: 'DataTypesFilter',checkHandler: onDataTypesItemCheck }),
				new Ext.menu.CheckItem({ text: '病人部门代码',value: 'patDeptCode',checked: true,group: 'DataTypesFilter',checkHandler: onDataTypesItemCheck }),
				new Ext.menu.CheckItem({ text: '病人部门名称',value: 'patDeptName',checked: false,group: 'DataTypesFilter',checkHandler: onDataTypesItemCheck }),
				new Ext.menu.CheckItem({ text: '<span style="color:blue;">核算病人部门名称</span>',value: 'inPatDeptName',checked: false,group: 'DataTypesFilter',checkHandler: onDataTypesItemCheck }),
				new Ext.menu.CheckItem({ text: '采集人',value: 'personName',checked: false,group: 'DataTypesFilter',checkHandler: onDataTypesItemCheck }),
				new Ext.menu.CheckItem({ text: '备注',value: 'remark',checked: false,group: 'DataTypesFilter',checkHandler: onDataTypesItemCheck }),
				new Ext.menu.CheckItem({ text: '采集日期',value: 'inDate',checked: false,group: 'DataTypesFilter',checkHandler: onDataTypesItemCheck })//,
				//new Ext.menu.CheckItem({ text: '开单医生代码',value: 'fDocCode',checked: false,group: 'DataTypesFilter',checkHandler: onDataTypesItemCheck}), 
				//new Ext.menu.CheckItem({ text: '开单医生名称',value: 'fDocName',checked: false,group: 'DataTypesFilter',checkHandler: onDataTypesItemCheck})
		]}
});

function onDataTypesItemCheck(item, checked)
{
		if(checked) {
				incomeDatasSearchField = item.value;
				incomeDatasFilterItem.setText(item.text + ':');
		}
};

var incomeDatasSearchBox = new Ext.form.TwinTriggerField({//查找按钮
		width: 180,
		trigger1Class: 'x-form-clear-trigger',
		trigger2Class: 'x-form-search-trigger',
		emptyText:'搜索...',
		listeners: {
				specialkey: {fn:function(field, e) {
				var key = e.getKey();
	      	  if(e.ENTER === key) {this.onTrigger2Click();}}}
	    	},
		grid: this,
		onTrigger1Click: function() {
				if(this.getValue()) {
					this.setValue('');    
					incomeDatasDs.proxy = new Ext.data.HttpProxy({url: incomeDatasUrl + '?action=list'});
					incomeDatasDs.load({params:{start:0, limit:incomeDatasPagingToolbar.pageSize, monthDr:monthDr}});
				}
		},
		onTrigger2Click: function() {
				if(this.getValue()) {
				incomeDatasDs.proxy = new Ext.data.HttpProxy({
				url: incomeDatasUrl + '?action=list&searchField=' + incomeDatasSearchField + '&searchValue=' + this.getValue()});
	        	incomeDatasDs.load({params:{start:0, limit:incomeDatasPagingToolbar.pageSize, monthDr:monthDr}});
	    	}
		}
});

var incomeDatasPagingToolbar = new Ext.PagingToolbar({//分页工具栏
		pageSize: 25,
		store: incomeDatasDs,
		displayInfo: true,
		displayMsg: '当前显示{0} - {1}，共计{2}',
		emptyMsg: "没有数据",
		buttons: ['-',incomeDatasFilterItem,'-',incomeDatasSearchBox],
		doLoad:function(C){
			var B={},
			A=this.paramNames;
			B[A.start]=C;
			B[A.limit]=this.pageSize;
			B['monthDr']=monthDr;
			if(this.fireEvent("beforechange",this,B)!==false){
				this.store.load({params:B});
			}
				}
});

var incomeDatasMain = new Ext.grid.GridPanel({ //表格
		title: '收入数据表维护',
		store: incomeDatasDs,
		cm: incomeDatasCm,
		trackMouseOver: true,
		stripeRows: true,
		sm: new Ext.grid.CheckboxSelectionModel(),
		loadMask: true,
		//tbar: ['核算区间:',months,'-','导入规则:',loadRules,'-',addDataTypesButton,'-',delDataTypesButton,'-',opTool,'-',refreshButton,'-',innerDeptControlButton,'-',editDataTypesButton,'-',findcompreButton,'-',delMonthDataButton],
		//tbar: ['核算区间:',months,'-','导入规则:',loadRules,'-',BaseTool,'-',opTool,'-',importButton,'-',refreshButton,'-',innerDeptControlButton,'-',SearchUnrefreshButton,'-',IncomeDataTypesButton],
		//tbar: ['核算区间:',months,'-','导入规则:',loadRules,'-',addDataTypesButton,'-',delDataTypesButton,'-',opTool,'-',importButton,'-',WriteOffCharge,"万元",'-',importButtonCX,'-',refreshButton,'-',innerDeptControlButton,'-',SearchUnrefreshButton,'-',IncomeDataTypesButton],
		tbar: ['核算区间:',months,'-','导入规则:',loadRules,'-',addDataTypesButton,'-',delDataTypesButton,'-',opTool,'-',importButton,'-',refreshButton,'-',innerDeptControlButton,'-',SearchUnrefreshButton,'-',IncomeDataTypesButton],
		
		bbar: incomeDatasPagingToolbar
});

//incomeDatasDs.load({params:{start:0, limit:incomeDatasPagingToolbar.pageSize}});