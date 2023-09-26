/**
  *name:tab of database
  *author:limingzhong
  *Date:2009-11-6
 */

var uploadUrl = 'http://10.0.1.142:8080/uploadexcel/uploadexcel';
//var uploadUrl = 'http://127.0.0.1:8080/uploadexcel/uploadexcel';
var userCode = session['LOGON.USERCODE'];
var userID = session['LOGON.USERID'];
function trim(str){
  var tmp=str.replace(/(^\s*)|(\s*$)/g, "");
  return tmp;
}

function format(value){
	//alert(value);
	re=/(\d{1,3})(?=(\d{3})+(?:$|\D))/g;
	value=value.replace(re,"$1,")
	return value?value:'';
};


var periodDs = new Ext.data.Store({
	autoLoad:true,
	proxy:"",
	reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['period'])
});

periodDs.on('beforeload', function(ds, o){
	ds.proxy=new Ext.data.HttpProxy({
		url:'dhc.pa.jxbasedataexe.csp?action=period&str='+Ext.getCmp('periodField').getRawValue(),method:'POST'})
});

var periodField = new Ext.form.ComboBox({
	id: 'periodField',
	fieldLabel: '考核期间',
	width:130,
	listWidth : 200,
	allowBlank: false,
	store: periodDs,
	valueField: 'period',
	displayField: 'period',
	triggerAction: 'all',
	emptyText:'请选择考核期间...',
	name: 'periodField',
	minChars: 1,
	pageSize: 10,
	selectOnFocus:true,
	forceSelection:'true',
	editable:true
});

var periodTypeDataStore = new Ext.data.SimpleStore({
	fields: ['key','keyValue'],
	data:[['M','月'],['Q','季'],['H','半年'],['Y','年']]
});
var pType = new Ext.form.ComboBox({
	id: 'pType',
	fieldLabel: '期间类型',
	width:130,
	listWidth : 200,
	selectOnFocus: true,
	allowBlank: false,
	store: periodTypeDataStore,
	anchor: '90%',
	value:'', //默认值
	valueNotFoundText:'',
	displayField: 'keyValue',
	valueField: 'key',
	triggerAction: 'all',
	emptyText:'选择期间类型...',
	mode: 'local', //本地模式
	editable:false,
	pageSize: 10,
	minChars: 1,
	selectOnFocus: true,
	forceSelection: true
});


pType.on("select",function(cmb,rec,id){
	JXBaseDataTabDs.load({params:{start:0, limit:JXBaseDataTabPagingToolbar.pageSize,period:Ext.getCmp('periodField').getRawValue(),periodType:Ext.getCmp('pType').getValue(),userID:userID }});
});


 
//配件数据源
var JXBaseDataTabUrl = 'dhc.pa.jxbasedataexe.csp';
var JXBaseDataTabProxy= new Ext.data.HttpProxy({url:JXBaseDataTabUrl + '?action=list'});
var JXBaseDataTabDs = new Ext.data.Store({
	proxy: JXBaseDataTabProxy,
    reader: new Ext.data.JsonReader({
        root: 'rows',
        totalProperty: 'results'
    }, [
		'parRef',
		'parRefName',
		'rowid',
		'childSub',
		'period',
		'periodType',
		'periodTypeName',
		'KPIDr',
		'KPIName',
		'actualValue',
		'auditDate',
		'auditUserDr',
		'auditUserName',
		'dataState',
		'dataStateName',
		'desc',
		'calUnitName'
	]),
    // turn on remote sorting
    remoteSort: true
});

//设置默认排序字段和排序方向
JXBaseDataTabDs.setDefaultSort('KPIName', 'desc');

//数据库数据模型
var JXBaseDataTabCm = new Ext.grid.ColumnModel([
	new Ext.grid.CheckboxSelectionModel(),
	
	 new Ext.grid.RowNumberer(),
	 {
		header: "所属绩效单元",
		dataIndex: 'parRefName',
		width: 130,
		sortable: true
	},{
		header: "考核期间",
		dataIndex: 'period',
		width: 90,
		sortable: true,
		align: 'center'
	},{
		header: '期间类型',
		dataIndex: 'periodTypeName',
		width: 90,
		sortable: true,
		align: 'center'
	},{
		header: '考核指标',
		dataIndex: 'KPIName',
		width: 210,
		sortable: true
	}


	,{
		header: '计量单位',
		dataIndex: 'calUnitName',
		width: 90,
		sortable: true,
		align: 'center'
	}



	,{
		header: "实际值",
		dataIndex: 'actualValue',
		width: 100,
		sortable: true,
		renderer:format,
		align: 'right',
		editor:new Ext.form.TextField({
		
		//regex:/^\d$/, 
		//regex:/^[0-9]+\.{0,1}[0-9]{0,2}$/,
		regex:/[-]?\d+(?:\.\d+)?$/,
		
		regexText:"只能够输入数字",
		allowBlank:false
		
		
		})
		
		
	},{
		header: "审核时间",
		dataIndex: 'auditDate',
		width: 90,
		sortable: true,
		align: 'center'
	},{
		header: "审核人员",
		dataIndex: 'auditUserName',
		width: 90,
		sortable: true,
		align: 'center'
	},{
		header: "数据状态",
		dataIndex: 'dataStateName',
		width: 90,
		sortable: true,
		align: 'center'
	},
	{
		header: "描述",
		dataIndex: 'desc',
		width:400,
		sortable: true,
		align: 'left'
	}
]);

//初始化默认排序功能
JXBaseDataTabCm.defaultSortable = true;






//添加按钮
var addButton = {
	text: '添加数据',
    tooltip:'添加', 
	disabled:((userCode=='demo')||(userCode=='jx001'))?false:true,	
    iconCls:'add',
	handler:function(){
		addFun(Ext.getCmp('pType').getValue(),Ext.getCmp('periodField').getRawValue(),JXBaseDataTabDs,JXBaseDataTabPagingToolbar);
	}
};

//导入按钮
var importButton = {
	text: '导入接口数据',
    tooltip:'导入接口数据',
	disabled:((userCode=='demo')||(userCode=='jx001'))?false:true,	
    iconCls:'add',
	handler:function(){
	var cycleDs = new Ext.data.Store({
	autoLoad:true,
	proxy:"",
	reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','code','name','shortcut','desc','active'])
});

cycleDs.on('beforeload', function(ds, o){
	ds.proxy=new Ext.data.HttpProxy({
		url:'dhc.pa.stratagemexe.csp?action=cycle&searchValue='+Ext.getCmp('cycleField').getRawValue()+'&active=Y',method:'POST'})
});

var cycleField = new Ext.form.ComboBox({
	id: 'cycleField',
	fieldLabel:'年度',
	width:200,
	listWidth : 200,
	allowBlank: false,
	store: cycleDs,
	valueField: 'rowid',
	displayField: 'name',
	triggerAction: 'all',
	emptyText:'请选择考核周期...',
	name: 'cycleField',
	minChars: 1,
	pageSize: 10,
	selectOnFocus:true,
	forceSelection:'true',
	editable:true
});
	
	
	
		var PeriodField = new Ext.form.TextField({
			id:'PeriodField',
			fieldLabel: '考核期间',
			allowBlank: false,
			width:200,
			listWidth : 200,
			emptyText:'请填写考核期间...',
			anchor: '90%',
			selectOnFocus:'true'
		});

		var periodTypeStore = new Ext.data.SimpleStore({
			fields: ['key','keyValue'],
			data:[['M','月'],['Q','季'],['H','半年'],['Y','年']]
		});
		var PeriodType3 = new Ext.form.ComboBox({
			id: 'PeriodType3',
			fieldLabel: '期间类型',
			width:200,
			listWidth : 200,
			allowBlank: false,
			store: periodTypeStore,
			//anchor: '90%',
			value:'', //默认值
			valueNotFoundText:'',
			displayField: 'keyValue',
			valueField: 'key',
			triggerAction: 'all',
			emptyText:'选择期间类型...',
			mode: 'local', //本地模式
			editable:false,
			selectOnFocus: true,
			forceSelection: true
		});
		
				PeriodType3.on("select",function(cmb,rec,id){
	if(cmb.getValue()=="M"){
		data=[['01','01月'],['02','02月'],['03','03月'],['04','04月'],['05','05月'],['06','06月'],['07','07月'],['08','08月'],['09','09月'],['10','10月'],['11','11月'],['12','12月']];
	}
	if(cmb.getValue()=="Q"){
		data=[['01','01季度'],['02','02季度'],['03','03季度'],['04','04季度']];
	}
	if(cmb.getValue()=="H"){
		data=[['01','1~6上半年'],['02','7~12下半年']];
	}
	if(cmb.getValue()=="Y"){
		data=[['0','全年']];
	}
	periodStore.loadData(data);
});
periodStore = new Ext.data.SimpleStore({
	fields:['key','keyValue']
});

var periodField1 = new Ext.form.ComboBox({
	id: 'periodField1',
	fieldLabel: '期间',
	width:200,
	listWidth : 200,
	selectOnFocus: true,
	allowBlank: false,
	store: periodStore,
	//anchor: '90%',
	valueNotFoundText:'',
	displayField: 'keyValue',
	valueField: 'key',
	triggerAction: 'all',
	emptyText:'请选择...',
	mode: 'local', //本地模式
	editable:false,
	pageSize: 12,
	minChars: 1,
	selectOnFocus: true,
	forceSelection: true
});
		
		
		var formPanel = new Ext.form.FormPanel({
			baseCls: 'x-plain',
			labelWidth:60,
			items: [
				cycleField,
				PeriodType3,
				periodField1
			]
		});
		
		//定义按钮
		var importB = new Ext.Toolbar.Button({
			text:'导入'
		});
			
		//添加处理函数
		var importHandler = function(){
		var cycle = cycleField.getRawValue();
			var period = periodField1.getValue();
			period = trim(period);
			cycle=cycle.substr(0,4);
			var Period=cycle+period;
			//alert(Period);
			if(cycle==""){
				Ext.Msg.show({title:'提示',msg:'年度为空!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
				return false;
			};
			
			var periodTypeDr = PeriodType3.getValue();
			periodTypeDr = trim(periodTypeDr);
			if(periodTypeDr==""){
				Ext.Msg.show({title:'提示',msg:'期间类型为空!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
				return false;
			};
			
			if(period==""){
				Ext.Msg.show({title:'提示',msg:'考核期间为空!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
				return false;
			};
			//alert(Period+"^"+periodTypeDr);
			Ext.Ajax.request({
				url:'dhc.pa.jxbasedataexe.csp?action=import&period='+Period+'&periodType='+periodTypeDr,
				waitMsg:'添加中..',
				failure: function(result, request){
					Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
				},
				success: function(result, request){
					var jsonData = Ext.util.JSON.decode( result.responseText );
					if (jsonData.success=='true'){
						Ext.Msg.show({title:'提示',msg:'添加成功!',icon:Ext.MessageBox.INFO,buttons:Ext.Msg.OK});
						//JXBaseDataTabDs.load({params:{start:0, limit:JXBaseDataTabPagingToolbar.pageSize,period:Ext.getCmp('periodField').getRawValue(),periodType:Ext.getCmp('pType').getValue(),dir:'asc',sort:'childSub',userID:userID}});
					    JXBaseDataTabDs.load({params:{start:0, limit:JXBaseDataTabPagingToolbar.pageSize,period:Period,periodType:periodTypeDr,dir:'asc',sort:'childSub',userID:userID}});
					
					}else{
						if(jsonData.info==''){
							Ext.Msg.show({title:'提示',msg:'传递参数丢失!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
						}
						if(jsonData.info==1){
							Ext.Msg.show({title:'错误',msg:'数据导入失败,已回滚!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
						}
					}
				},
				scope: this
			});
		}

		//添加按钮的响应事件
		importB.addListener('click',importHandler,false);

		//定义取消按钮
		var cancelB = new Ext.Toolbar.Button({
			text:'取消'
		});

		//取消处理函数
		var cancelHandler = function(){
			win.close();
		}

		//取消按钮的响应事件
		cancelB.addListener('click',cancelHandler,false);

		var win = new Ext.Window({
			title: '导入接口数据',
			width: 355,
			height:180,
			minWidth: 355,
			minHeight: 150,
			layout: 'fit',
			plain:true,
			modal:true,
			bodyStyle:'padding:5px;',
			buttonAlign:'center',
			items: formPanel,
			buttons: [
				importB,
				cancelB
			]
		});
		win.show();
	}
};


//手工初始化按钮
var initButton = {
	text: '初始化数据',
       tooltip:'初始化数据',  
	
	disabled:userCode!='demo'?false:true,    
       iconCls:'add',
	handler:function(){
	var cycleDs = new Ext.data.Store({
	autoLoad:true,
	proxy:"",
	reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','code','name','shortcut','desc','active'])
});

cycleDs.on('beforeload', function(ds, o){
	ds.proxy=new Ext.data.HttpProxy({
		url:'dhc.pa.stratagemexe.csp?action=cycle&searchValue='+Ext.getCmp('cycleField').getRawValue()+'&active=Y',method:'POST'})
});

var cycleField = new Ext.form.ComboBox({
	id: 'cycleField',
	fieldLabel:'年度',
	width:200,
	listWidth : 200,
	allowBlank: false,
	store: cycleDs,
	valueField: 'rowid',
	displayField: 'name',
	triggerAction: 'all',
	emptyText:'请选择考核周期...',
	name: 'cycleField',
	minChars: 1,
	pageSize: 10,
	selectOnFocus:true,
	forceSelection:'true',
	editable:true
});

		var periodTypeStore = new Ext.data.SimpleStore({
			fields: ['key','keyValue'],
			data:[['M','月'],['Q','季'],['H','半年'],['Y','年']]
		});
		var PeriodType1= new Ext.form.ComboBox({
			id: 'PeriodType1',
			fieldLabel: '期间类型',
			width:200,
			listWidth : 200,
			allowBlank: false,
			store: periodTypeStore,
			//anchor: '90%',
			value:'', //默认值
			valueNotFoundText:'',
			displayField: 'keyValue',
			valueField: 'key',
			triggerAction: 'all',
			emptyText:'选择期间类型...',
			mode: 'local', //本地模式
			editable:false,
			selectOnFocus: true,
			forceSelection: true
		});
		
		
		
		PeriodType1.on("select",function(cmb,rec,id){
	if(cmb.getValue()=="M"){
		data=[['01','01月'],['02','02月'],['03','03月'],['04','04月'],['05','05月'],['06','06月'],['07','07月'],['08','08月'],['09','09月'],['10','10月'],['11','11月'],['12','12月']];
	}
	if(cmb.getValue()=="Q"){
		data=[['1','01季度'],['2','02季度'],['3','03季度'],['4','04季度']];
	}
	if(cmb.getValue()=="H"){
		data=[['1','1~6上半年'],['2','7~12下半年']];
	}
	if(cmb.getValue()=="Y"){
		data=[['0','全年']];
	}
	periodStore.loadData(data);
});
periodStore = new Ext.data.SimpleStore({
	fields:['key','keyValue']
});

var periodField1 = new Ext.form.ComboBox({
	id: 'periodField1',
	fieldLabel: '期间',
	width:200,
	listWidth : 200,
	selectOnFocus: true,
	allowBlank: false,
	store: periodStore,
	//anchor: '90%',
	valueNotFoundText:'',
	displayField: 'keyValue',
	valueField: 'key',
	triggerAction: 'all',
	emptyText:'请选择...',
	mode: 'local', //本地模式
	editable:false,
	pageSize: 10,
	minChars: 1,
	selectOnFocus: true,
	forceSelection: true
});
		
		var formPanel = new Ext.form.FormPanel({
			baseCls: 'x-plain',
			labelWidth:60,
			items: [
				cycleField,
				PeriodType1,
				periodField1
			]
		});
		
		//定义按钮
		var initB = new Ext.Toolbar.Button({
			text:'初始化'
		});
			
		//添加处理函数
		var importHandler = function(){
			var cycle = cycleField.getRawValue();
			var period = periodField1.getValue();
			period = trim(period);
			
			var Period=cycle+period
			//alert(Period);
			if(cycle==""){
				Ext.Msg.show({title:'提示',msg:'年度为空!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
				return false;
			};
			
			var periodTypeDr = PeriodType1.getValue();
			periodTypeDr = trim(periodTypeDr);
			if(periodTypeDr==""){
				Ext.Msg.show({title:'提示',msg:'期间类型为空!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
				return false;
			};
			
			if(period==""){
				Ext.Msg.show({title:'提示',msg:'考核期间为空!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
				return false;
			};
			Ext.Ajax.request({
				url:'dhc.pa.jxbasedataexe.csp?action=init&period='+Period+'&periodType='+periodTypeDr+'&userID='+userID,
				waitMsg:'添加中..',
				failure: function(result, request){
					Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
				},
				success: function(result, request){
					var jsonData = Ext.util.JSON.decode( result.responseText );
					if (jsonData.success=='true'){
						Ext.Msg.show({title:'提示',msg:'初始化成功!',icon:Ext.MessageBox.INFO,buttons:Ext.Msg.OK});
						
						
						//JXBaseDataTabDs.load({params:{start:0, limit:JXBaseDataTabPagingToolbar.pageSize,period:Ext.getCmp('periodField').getRawValue(),periodType:Ext.getCmp('pType').getValue(),dir:'asc',sort:'childSub',userID:userID}});
						JXBaseDataTabDs.load({params:{start:0, limit:JXBaseDataTabPagingToolbar.pageSize,period:Period,periodType:periodTypeDr,dir:'asc',sort:'childSub',userID:userID}});
					
					}else{
						if(jsonData.info==''){
							Ext.Msg.show({title:'提示',msg:'传递参数丢失!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
						}
						if(jsonData.info==1){
							Ext.Msg.show({title:'错误',msg:'数据导入失败,已回滚!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
						}
					}
				},
				scope: this
			});
		}

		//添加按钮的响应事件
		initB.addListener('click',importHandler,false);

		//定义取消按钮
		var cancelB = new Ext.Toolbar.Button({
			text:'取  消'
		});

		//取消处理函数
		var cancelHandler = function(){
			win.close();
		}

		//取消按钮的响应事件
		cancelB.addListener('click',cancelHandler,false);

		var win = new Ext.Window({
			title: '数据初始化',
			width: 355,
			height:200,
			minWidth: 355,
			minHeight: 150,
			layout: 'fit',
			plain:true,
			modal:true,
			bodyStyle:'padding:5px;',
			buttonAlign:'center',
			items: formPanel,
			buttons: [
				initB,
				cancelB
			]
		});
		win.show();
	}
};

var aduitButton1  = new Ext.Toolbar.Button({
	text:'审核',
	tooltip:'审核',
	disabled:userCode=='1'?false:true,
	iconCls:'remove',
	handler: function(){
		var period = periodField.getValue();
			period = trim(period);
			//alert(period);
			
			if(period==""){
				Ext.Msg.show({title:'提示',msg:'考核期间为空!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
				return false;
			};
			
			
			var periodTypeDr = pType.getValue();
			periodTypeDr = trim(periodTypeDr);
			
			if(periodTypeDr==""){
				Ext.Msg.show({title:'提示',msg:'期间类型为空!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
				return false;
			};
			
		var rowObj = JXBaseDataTab.getSelections();
		var len = rowObj.length;
		if(len < 1){
			Ext.Msg.show({title:'注意',msg:'请选择审核的基本数据!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			return false;
		}else{
			
		Ext.MessageBox.confirm('提示','确定要审核?',
				function(btn) {
					if(btn == 'yes'){
					for(var i = 0; i < len; i++){
					
						Ext.Ajax.request({
							
						
							url:'dhc.pa.jxbasedataexe.csp?action=aduit&period='+period+'&periodType='+periodTypeDr+'&userCode='+userCode+'&rowid='+rowObj[i].get("rowid"),
							waitMsg:'审核中...',
							failure: function(result, request) {
								Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							},
							success: function(result, request) {
								var jsonData = Ext.util.JSON.decode( result.responseText );
								if (jsonData.success=='true') {
									Ext.Msg.show({title:'注意',msg:'审核成功!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
									JXBaseDataTabDs.load({params:{start:0, limit:JXBaseDataTabPagingToolbar.pageSize,period:Ext.getCmp('periodField').getRawValue(),periodType:Ext.getCmp('pType').getValue(),dir:'asc',sort:'childSub',userID:userID }});
								}else{
								
								if (jsonData.info==100) {
								var message="没有需要审核的数据！";
									Ext.Msg.show({title:'错误',msg:message,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
								}
								else{
									var message="审核错误";
									Ext.Msg.show({title:'错误',msg:message,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
								}
								}
							},
							scope: this
						});
					}
					
					}
				}
				)
				
				}
	}
});
////////////////////取消审核按钮/////////////////////////////////


var aduitButton  = new Ext.Toolbar.Button({
	text:'审核',
	tooltip:'审核',
	disabled:userCode!='demo1'?false:true,
	iconCls:'remove',
	handler: function(){
			
		var period = periodField.getValue();
			period = trim(period);
			//alert(period);
			if(period==""){
				Ext.Msg.show({title:'提示',msg:'考核期间为空!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
				return false;
			};
			var periodTypeDr = pType.getValue();
			periodTypeDr = trim(periodTypeDr);
			
			if(periodTypeDr==""){
				Ext.Msg.show({title:'提示',msg:'期间类型为空!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
				return false;
			};
				
		Ext.MessageBox.confirm('提示','确定要审核?',
				function(btn) {
					if(btn == 'yes'){
						Ext.Ajax.request({
							url:'dhc.pa.jxbasedataexe.csp?action=aduit&period='+period+'&periodType='+periodTypeDr+'&userCode='+userCode,
							waitMsg:'审核中...',
							failure: function(result, request) {
								Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							},
							success: function(result, request) {
								var jsonData = Ext.util.JSON.decode( result.responseText );
								if (jsonData.success=='true') {
									Ext.Msg.show({title:'注意',msg:'审核成功!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
									JXBaseDataTabDs.load({params:{start:0, limit:JXBaseDataTabPagingToolbar.pageSize,period:Ext.getCmp('periodField').getRawValue(),periodType:Ext.getCmp('pType').getValue(),dir:'asc',sort:'childSub',userID:userID }});
								}else{
								
								if (jsonData.info==100) {
								var message="没有需要审核的数据！";
									Ext.Msg.show({title:'错误',msg:message,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
								}
								else{
									var message="审核错误";
									Ext.Msg.show({title:'错误',msg:message,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
								}
								}
							},
							scope: this
						});
					}
				}
				)
	}
});


var CancelAduitButton  = new Ext.Toolbar.Button({
	text:'取消审核',
	tooltip:'取消审核',
	//disabled:(userCode!='demo')&(userCode!='512')?false:true,
	disabled:(userCode!='demo')?false:true,
	iconCls:'remove',
	handler: function(){
		var rowObj = JXBaseDataTab.getSelections();
		var len = rowObj.length;
		if(len < 1){
			Ext.Msg.show({title:'注意',msg:'请选择取消审核的基本数据!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			return false;
		}else{
		Ext.MessageBox.confirm('提示','确定要取消?',
				function(btn) {
					if(btn == 'yes'){
					for(var i = 0; i < len; i++){
					
						Ext.Ajax.request({
							url:'dhc.pa.jxbasedataexe.csp?action=canceladuit&rowid='+rowObj[i].get("rowid"),
							waitMsg:'审核中...',
							failure: function(result, request) {
								Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							},
							success: function(result, request) {
								var jsonData = Ext.util.JSON.decode( result.responseText );
								if (jsonData.success=='true') {
									Ext.Msg.show({title:'注意',msg:'取消审核成功!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
									JXBaseDataTabDs.load({params:{start:0, limit:JXBaseDataTabPagingToolbar.pageSize,period:Ext.getCmp('periodField').getRawValue(),periodType:Ext.getCmp('pType').getValue(),dir:'asc',sort:'childSub',userID:userID }});
								}else{
									var message="审核错误";
									Ext.Msg.show({title:'错误',msg:message,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
								}
							},
							scope: this
						});
					
					}
					}
				}
	
				)
				}
	}
});
/////////////////////////////////////////////////

var CorrectButton  = new Ext.Toolbar.Button({
	text:'修改',
	tooltip:'修改',
	iconCls:'remove',
	handler: function(){
		var rowObj = JXBaseDataTab.getSelections();
		var len = rowObj.length;
		if(len < 1){
			Ext.Msg.show({title:'注意',msg:'请选择修改的基本数据!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			return false;
		}
		else{
		Ext.MessageBox.confirm('提示','确定要修改?',
				function(btn) {
					if(btn == 'yes'){
					if(rowObj[0].get("dataStateName") == '审核通过'){
					Ext.Msg.show({title:'注意',msg:'审核通过的数据不允许修改!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
					return false;
					
					}
						else{
						CorrectFun(rowObj[0].get("rowid"),rowObj[0].get("parRefName"),rowObj[0].get("period"),rowObj[0].get("KPIName"),rowObj[0].get("actualValue"));
						}
					}
				}
				)
				}
	}
});
//////////////////保存按钮//////////////////////////////////
//定义按钮
		var saveB = new Ext.Toolbar.Button({
			text:'保存',
			tooltip:'保存',
			iconCls:'remove',
	handler: function(){
	
			
		var rowObj = JXBaseDataTab.getStore().getModifiedRecords();  //获得所有修改的记录 返回数组
		var length=rowObj.length;
		
		if(length < 1){
			Ext.Msg.show({title:'注意',msg:'请选择保存的基本数据!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			return false;
		}
			
		else{

			Ext.MessageBox.confirm('提示','确定要确定要保存?',
					function(btn) {
						if(btn == 'yes'){
						
						
						for(var i = 0; i < length; i++){
							
							var aValue = rowObj[i].get("actualValue");
							aValue = trim(aValue);
							
							
							Ext.Ajax.request({
							url:'dhc.pa.jxbasedataexe.csp?action=update&rowid='+rowObj[i].get("rowid")+'&aValue='+aValue,
							waitMsg:'审核中...',
							failure: function(result, request) {
								Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							},
							success: function(result, request) {
								var jsonData = Ext.util.JSON.decode( result.responseText );
								if (jsonData.success=='true') {
									Ext.Msg.show({title:'注意',msg:'数据保存成功!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
									JXBaseDataTabDs.load({params:{start:0, limit:JXBaseDataTabPagingToolbar.pageSize,period:Ext.getCmp('periodField').getRawValue(),periodType:Ext.getCmp('pType').getValue(),dir:'asc',sort:'childSub',userID:userID }});
									JXBaseDataTab.getStore().modified =[];  //清空store的修改数据组的记录
								
								
								}else{
									var message="数据保存失败";
									Ext.Msg.show({title:'错误',msg:message,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
								}
							},
							scope: this
						});
						}
						
						}
					}
					)
					
			}
	}
		});



////////////////////////////////////////////////////
//导入按钮
var excelButton = {
	text: '导入excel数据',
    tooltip:'导入',
	//disabled:userCode=='demo1'?false:true,	
    iconCls:'add',
	handler:function(){importExcel()}
			
};
var delButton  = new Ext.Toolbar.Button({
	text:'删除',
	tooltip:'删除',
	disabled:userCode=='demo'?false:true,
	iconCls:'remove',
	
	handler: function(){
		var rowObj = JXBaseDataTab.getSelections();
		var len = rowObj.length;
		if(len < 1){
			Ext.Msg.show({title:'注意',msg:'请选择需要删除的基本数据!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			return false;
		}else{
			Ext.MessageBox.confirm('提示','确定要删除选定的行?',
				function(btn) {
					if(btn == 'yes'){
					for(var i = 0; i < len; i++){
					
					
						if (rowObj[i].get("dataState")==1)
		
						{
			
							Ext.Msg.show({title:'错误',msg:'审核通过的数据不可删除!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							return false;
						}
					
						Ext.Ajax.request({
							url:'dhc.pa.jxbasedataexe.csp?action=del&rowid='+rowObj[i].get("rowid"),
							waitMsg:'删除中...',
							failure: function(result, request) {
								Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							},
							success: function(result, request) {
								var jsonData = Ext.util.JSON.decode( result.responseText );
								if (jsonData.success=='true') {
									Ext.Msg.show({title:'注意',msg:'删除成功!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
									JXBaseDataTabDs.load({params:{start:0, limit:JXBaseDataTabPagingToolbar.pageSize,period:Ext.getCmp('periodField').getRawValue(),periodType:Ext.getCmp('pType').getValue(),dir:'asc',sort:'childSub',userID:userID}});
								}else{
									var message="删除错误";
									Ext.Msg.show({title:'错误',msg:message,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
								}
							},
							scope: this
						});
					}
					}
				}
			)
		}
	}
});




var delButton1  = new Ext.Toolbar.Button({
	text:'删除接口指标',
	tooltip:'删除接口指标',
	disabled:userCode=='demo'?false:true,
	iconCls:'remove',
	handler: function(){
		var rowObj = JXBaseDataTab.getSelections();
		var len = rowObj.length;
		
			var period = periodField.getValue();
			periodTypeDr = pType.getValue();
			if(period==""){
				Ext.Msg.show({title:'提示',msg:'考核期间为空!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
				return false;
			};
			
			if(periodTypeDr==""){
				Ext.Msg.show({title:'提示',msg:'期间类型为空!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
				return false;
			};



			Ext.MessageBox.confirm('提示','确定要删除数据吗?',
				function(btn) {
					if(btn == 'yes'){
					
					
						Ext.Ajax.request({
							url:'dhc.pa.jxbasedataexe.csp?action=del1&period='+period+'&periodType='+periodTypeDr,
							waitMsg:'删除中...',
							failure: function(result, request) {
								Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							},
							success: function(result, request) {
								var jsonData = Ext.util.JSON.decode( result.responseText );
								if (jsonData.success=='true') {
									Ext.Msg.show({title:'注意',msg:'删除成功!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
									JXBaseDataTabDs.load({params:{start:0, limit:JXBaseDataTabPagingToolbar.pageSize,period:Ext.getCmp('periodField').getRawValue(),periodType:Ext.getCmp('pType').getValue(),dir:'asc',sort:'childSub',userID:userID}});
								}else{
									
									if (jsonData.info==100) {
								var message="没有需要删除的数据！";
									Ext.Msg.show({title:'错误',msg:message,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
								}
								else
								{
									var message="删除错误";
									Ext.Msg.show({title:'错误',msg:message,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
								
								}
								}
							},
							scope: this
						
					
					
				}
			)
		
	}
});

}});


var initSum  = new Ext.Toolbar.Button({
	text:'生成季度、半年、年数据',
	tooltip:'生成季度、半年、年数据',
	disabled:false,
	iconCls:'add',
	handler: function(){
		var period = periodField.getValue();
			period = trim(period);
			//alert(period);
			if(period==""){
				Ext.Msg.show({title:'提示',msg:'考核期间为空!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
				return false;
			};
			var periodTypeDr = pType.getValue();
			periodTypeDr = trim(periodTypeDr);
			
			if(periodTypeDr==""){
				Ext.Msg.show({title:'提示',msg:'期间类型为空!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
				return false;
			};
			if(periodTypeDr=="M"){
				Ext.Msg.show({title:'提示',msg:'不生成月份数据!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
				return false;
			};
		Ext.MessageBox.confirm('提示','确定要生成?',
				function(btn) {
					if(btn == 'yes'){
						Ext.Ajax.request({
							url:'dhc.pa.jxbasedataexe.csp?action=initSum&period='+period+'&periodType='+periodTypeDr+'&userID='+userID,
							waitMsg:'审核中...',
							failure: function(result, request) {
								Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							},
							success: function(result, request) {
								var jsonData = Ext.util.JSON.decode( result.responseText );
								if (jsonData.success=='true') {
									Ext.Msg.show({title:'注意',msg:'生成成功!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
									JXBaseDataTabDs.load({params:{start:0, limit:JXBaseDataTabPagingToolbar.pageSize,period:Ext.getCmp('periodField').getRawValue(),periodType:Ext.getCmp('pType').getValue(),dir:'asc',sort:'childSub',userID:userID }});
								}else{
								
								if (jsonData.info==100) {
								var message="没有需要生成的数据！";
									Ext.Msg.show({title:'错误',msg:message,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
								}
								if (jsonData.info=="re") {
								var message="不在此次生成月份数据！";
									Ext.Msg.show({title:'错误',msg:message,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
								}
								else{
									var message="生成错误";
									Ext.Msg.show({title:'错误',msg:message,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
								}
								}
							},
							scope: this
						});
					}
				}
				)
	}
});


/**
//按钮权限
if(userCode!='demo')
{	addButton.setDisabled(true);
	importButton.setDisabled(true);
	aduitButton.setDisabled(true);
	CancelAduitButton.setDisabled(true);
	delButton.setDisabled(true);
	delButton1.setDisabled(true);  

};
**/


var addMenu = new Ext.menu.Menu({
    id: 'addMenu',
    items: [importButton,excelButton,addButton] //initButton,  
});
var addMenu = new Ext.Toolbar([{
    text: '导入数据',
    iconCls: 'add',
	//disabled:true,
    menu: addMenu
}]);





//tbar:['考核期间:',periodField,'-','期间类型:',pType,'-',addButton,'-',
//initButton,'-',importButton,'-',excelButton,
//'-',saveB,'-',delButton,'-',aduitButton,'-',CancelAduitButton,'-',delButton1],
//初始化搜索字段
var JXBaseDataSearchField ='KPIName';

//搜索过滤器
var JXBaseDataFilterItem = new Ext.Toolbar.MenuButton({
	text: '过滤器',
	tooltip: '关键字所属类别',
	menu: {items: [
		new Ext.menu.CheckItem({ 
			text: '绩效单元',
			value: 'parRefName',
			checked: false ,
			group: 'JXBaseDataFilter',
			checkHandler: onJXBaseDataItemCheck 
		}),
		new Ext.menu.CheckItem({ 
			text: '考核指标',
			value: 'KPIName',
			checked: false,
			group: 'JXBaseDataFilter',
			checkHandler: onJXBaseDataItemCheck 
		})
	]}
});

//定义搜索响应函数
function onJXBaseDataItemCheck(item, checked){
	if(checked) {
		JXBaseDataSearchField = item.value;
		JXBaseDataFilterItem.setText(item.text + ':');
	}
};

//查找按钮
var JXBaseDataSearchBox = new Ext.form.TwinTriggerField({
	width: 180,
	trigger1Class: 'x-form-clear-trigger',
	trigger2Class: 'x-form-search-trigger',
	emptyText:'搜索...',
	listeners: {
		specialkey: {
			fn:function(field, e) {
				var key = e.getKey();
	      	  		if(e.ENTER === key) {
					this.onTrigger2Click();
				}
			}
		}
	},
	grid: this,
	onTrigger1Click: function() {
		if(this.getValue()) {
			this.setValue('');    
			JXBaseDataTabDs.proxy = new Ext.data.HttpProxy({url: JXBaseDataTabUrl + '?action=list'});
			JXBaseDataTabDs.load({params:{start:0, limit:JXBaseDataTabPagingToolbar.pageSize,period:Ext.getCmp('periodField').getRawValue(),periodType:Ext.getCmp('pType').getValue(),userID:userID}});
		}
	},
	onTrigger2Click: function() {
		if(this.getValue()) {
		    //alert(this.getValue());
			JXBaseDataTabDs.proxy = new Ext.data.HttpProxy({
				url: JXBaseDataTabUrl + '?action=list&searchField=' + JXBaseDataSearchField + '&searchValue=' + this.getValue()});
	        	JXBaseDataTabDs.load({params:{start:0, limit:JXBaseDataTabPagingToolbar.pageSize,period:Ext.getCmp('periodField').getRawValue(),periodType:Ext.getCmp('pType').getValue(),userID:userID}});
	    	}
	    else{
		        JXBaseDataTabDs.proxy = new Ext.data.HttpProxy({
				url: JXBaseDataTabUrl + '?action=list&searchField=' + JXBaseDataSearchField + '&searchValue=' + this.getValue()});
	        	JXBaseDataTabDs.load({params:{start:0, limit:JXBaseDataTabPagingToolbar.pageSize,period:Ext.getCmp('periodField').getRawValue(),periodType:Ext.getCmp('pType').getValue(),userID:userID}});
		}
	}
});

//分页工具栏
var JXBaseDataTabPagingToolbar = new Ext.PagingToolbar({
    store: JXBaseDataTabDs,
	pageSize:25,
    displayInfo: true,
    displayMsg: '第 {0} 条到 {1}条 ，一共 {2} 条',
    emptyMsg: "没有记录",
	buttons: ['-',JXBaseDataFilterItem,'-',JXBaseDataSearchBox],
	doLoad:function(C){
		var B={},
		A=this.paramNames;
		B[A.start]=C;
		B[A.limit]=this.pageSize;
		B['period']=Ext.getCmp('periodField').getRawValue();
		B['periodType']=Ext.getCmp('pType').getValue();
        B['userID']=userID;
		B['dir']="asc";
		B['sort']="childSub";
		if(this.fireEvent("beforechange",this,B)!==false){
			this.store.load({params:B});
		}
	}
});



 var tbar1 = new Ext.Toolbar({  
                
                renderTo: Ext.grid.GridPanel.tbar,  
                items:[
				
				{xtype:'label',text: '提示：'}
				
				]  
            }) ; 
 var tbar2 = new Ext.Toolbar({  
				//height:25,
                renderTo: Ext.grid.GridPanel.tbar,  
                items:[
				{columnWidth:.01,xtype:''},
				{xtype:'label',text: '1.点击导入数据->初始化数据，请注意指标名称和计量单位认真填写指标实际值!'}
				//new Ext.form.TextField({  
                //    fieldLabel:"测试"  
                //  width:100  
                    //height:30  
                //})
				]  
            }) ; 
			
 var tbar3 = new Ext.Toolbar({  
				
                renderTo: Ext.grid.GridPanel.tbar,  
                items:[
				{columnWidth:.01,xtype:''},
				{xtype:'label',text: '2.点击指标值修改，无需填写计量单位，例如80%请填写为80!'}
				
				]  
            }) ; 
			
			
var tbar4 = new Ext.Toolbar({  
                renderTo: Ext.grid.GridPanel.tbar,  
                items:[
				{columnWidth:.01,xtype:''},
				{xtype:'label',text: '3.有部分指标值为是否达标，达标填100，未达标填0，不要填写汉字!'}
				
				]  
            }) ;


var tbar5 = new Ext.Toolbar({  
                renderTo: Ext.grid.GridPanel.tbar,  
                items:[
				{columnWidth:.01,xtype:''},
				{xtype:'label',text: '4.数据填写完毕，请审核![ “审核”是按照期间、期间类型、权限人等审核数据的，所以不需要选择；“取消审核”需要选择数据，逐个进行取消审核！]'}
				
				]  
            }) ;






//表格
var JXBaseDataTab = new Ext.grid.EditorGridPanel({
	title: '基本数据管理',
	store: JXBaseDataTabDs,
	
	cm: JXBaseDataTabCm,
	region:'center',
	clicksToEdit:1,
	trackMouseOver: true,
	stripeRows: true,
	sm: new Ext.grid.CheckboxSelectionModel(),
	loadMask: true,
	//tbar:['考核期间:',periodField,'-','期间类型:',pType,'-',addButton,'-',initButton,'-',importButton,'-',excelButton,'-',saveB,'-',delButton,'-',aduitButton,'-',CancelAduitButton,'-',delButton1],
	//tbar:['考核期间:',periodField,'-','期间类型:',pType,'-',addMenu,'-',saveB,'-',delButton1,'-',aduitButton,'-',CancelAduitButton],
	tbar:['考核期间:',periodField,'-','期间类型:',pType,'-',addMenu,'-',initSum,'-',delButton1,'-',aduitButton,'-',CancelAduitButton],
	 listeners : { 
       'render': function(){ 
            tbar1.render(this.tbar); 
			tbar2.render(this.tbar); 
			tbar3.render(this.tbar); 
			tbar4.render(this.tbar); 
			tbar5.render(this.tbar); 
        } 
     } ,



	bbar:JXBaseDataTabPagingToolbar
	});


JXBaseDataTab.on('cellclick',function( g, rowIndex, columnIndex, e ){

//alert(columnIndex);
JXBaseDataTabCm.setEditable (7,true);
	if(columnIndex==7){

	var tmpRec=JXBaseDataTab.getStore().data.items[rowIndex];


	if (tmpRec.data['dataState']==1)
		
		{
			JXBaseDataTabCm.setEditable (7,false);
			Ext.Msg.show({title:'错误',msg:'审核通过的数据不可修改!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
			return false;
			}
		
		}

});

//----------------------------------实际值修改后直接保存---------------------------------------------------------


function afterEdit(obj){    //每次更改后，触发一次该事件   
          var mr=JXBaseDataTabDs.getModifiedRecords();//获取所有更新过的记录 
		   for(var i=0;i<mr.length;i++){   
       
				var actualValue = mr[i].data["actualValue"].trim();
             
				var myRowid = mr[i].data["rowid"].trim();
     }  
	Ext.Ajax.request({
							url:'dhc.pa.jxbasedataexe.csp?action=update&rowid='+myRowid+'&aValue='+actualValue,
							//waitMsg:'审核中...',
							failure: function(result, request) {
								Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							},
							success: function(result, request) {
								var jsonData = Ext.util.JSON.decode( result.responseText );
								if (jsonData.success=='true') {
									//Ext.Msg.show({title:'注意',msg:'数据保存成功!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
									JXBaseDataTabDs.load({params:{start:0, limit:JXBaseDataTabPagingToolbar.pageSize,period:Ext.getCmp('periodField').getRawValue(),periodType:Ext.getCmp('pType').getValue(),dir:'asc',sort:'childSub',userID:userID }});
									//JXBaseDataTab.getStore().modified =[];  //清空store的修改数据组的记录
								   //this.store.commitChanges(); 
								
								}else{
									var message="数据保存失败,请检查数据格式！";
									Ext.Msg.show({title:'错误',msg:message,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
								}
							},
							scope: this
						});
	 
}
JXBaseDataTab.on("afteredit", afterEdit, JXBaseDataTab);    

//-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
