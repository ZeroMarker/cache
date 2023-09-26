// 名称:供应商用户信息管理
// 编写日期:2013-05-15
//编写人:徐超

//=========================供应商类别=============================
var VendorUserGridUrl = 'dhcstm.vendoruseraction.csp';
var vendorGroupRowID = tkMakeServerCall("web.DHCSTM.VendorUser","getVendorUserGroup");

var Vendor = new Ext.ux.VendorComboBox({
	fieldLabel : '供应商',
	id : 'Vendor',
	name : 'Vendor',
	anchor : '90%',
	emptyText : '供应商...'
});

var ActiveStore = new Ext.data.SimpleStore({
	fields:['key', 'keyValue'],
	data:[["Y",'使用'], ["N",'停用'], ["",'全部']]
});
var ActiveStoreField = new Ext.form.ComboBox({
	id:'ActiveStoreField',
	fieldLabel:'使用状态',
	anchor:'90%',
	allowBlank:true,
	store:ActiveStore,
	value:'', // 默认值"全部查询"
	valueField:'key',
	displayField:'keyValue',
	triggerAction:'all',
	emptyText:'',
	pageSize:10,
	selectOnFocus:true,
	forceSelection:true,
	editable:true	,
	mode:'local'
});

var useridf = new Ext.form.TextField({
	id:'useridf',
	fieldLabel:'用户ID',
	width:200,
	listWidth:200,
	emptyText:'用户ID',
	anchor:'90%',
	selectOnFocus:true
});

var Category = new Ext.ux.ComboBox({
	id: 'Category',
	fieldLabel: '分类',
	anchor: '90%',
	store: GetVendorCatStore,
	triggerAction: 'all'
});

	
//配置数据源
var VendorUserGridProxy= new Ext.data.HttpProxy({url:VendorUserGridUrl+'?actiontype=query',method:'POST'});
var VendorUserGridDs = new Ext.data.Store({
	proxy:VendorUserGridProxy,
	reader:new Ext.data.JsonReader({
		root:'rows',
		totalProperty:'results'
	}, [
		{name:'RowId'},
		{name:'Apcvmdr'},
		{name:'Apcvmdesc'},
		{name:'Userid'},
		{name:'Username'},
		{name:'UserPassword'},
		{name:'Ssuserid'},
		{name:'Groupdr'},
		{name:'Datefrom'},
		{name:'Dateto'},
		{name:'Active'},
		{name:'StockLoc'}
	]),
    remoteSort:false
});

//模型
var VendorUserGridCm = new Ext.grid.ColumnModel([
	new Ext.grid.RowNumberer(),
	{
		header:"供应商名称",
		dataIndex:'Apcvmdesc',
		width:220,
		align:'left',
		sortable:true
	},{
		header:"缺省登陆科室",
		dataIndex:'StockLoc',
		width:200,
		align:'left',
		sortable:true
	},{
		header:"用户ID",
		dataIndex:'Userid',
		width:150,
		align:'left',
		sortable:true
	},{
		header:"用户名称",
		dataIndex:'Username',
		width:150,
		align:'left',
		sortable:true
	},{
		header:"开始日期",
		dataIndex:'Datefrom',
		width:150,
		align:'left',
		sortable:false
	},{
		header:"结束日期",
		dataIndex:'Dateto',
		width:150,
		align:'left',
		sortable:false
	},{
		header:"使用标志",
		dataIndex:'Active',
		width:150,
		align:'left',
		sortable:false,
		renderer:function(v){
			if (v=="Y"){
				return "使用";
			}else{
				return "未使用";
			}
		}
	}
]);

var findVendorUser = new Ext.Toolbar.Button({
	text:'查询',
	tooltip:'查询',
	iconCls:'page_find',
	width : 70,
	height : 30,
	handler:function(){
		var Vendorrowid = Ext.getCmp('Vendor').getValue();
		var Active=Ext.getCmp('ActiveStoreField').getValue();
		var userid =Ext.getCmp('useridf').getValue();
		var Category = Ext.getCmp('Category').getValue();
		var StrParam = Vendorrowid + '^' + Active + '^' + userid + '^' + Category;
		VendorUserGridDs.setBaseParam('StrParam', StrParam);
		VendorUserGridDs.load({params:{start:0,limit:VendorUserPagingToolbar.pageSize,sort:'RowId',dir:'DESC'}});
	}
});

//创建编辑窗口(弹出)
//rowid :供应商rowid
function CreateEditWin(rowid)
{	
	//用户ID
	var userid = new Ext.form.TextField({
		id:'userid',
		fieldLabel:'用户ID',
		width:200,
		listWidth:200,
		emptyText:'用户ID',
		anchor:'90%',
		disabled:true,
		selectOnFocus:true
	});
	
	//用户名称
	var username = new Ext.form.TextField({
		id:'username',
		fieldLabel:'用户名',
		allowBlank:false,
		width:200,
		listWidth:200,
		//emptyText:'供应商名称...',
		anchor:'90%',
		selectOnFocus:true
	});
	
	//密码
	
	var password = new Ext.form.TextField({
		id:'password',
		fieldLabel:'密码',
		allowBlank:false,
		width:200,
		listWidth:200,
		anchor:'90%',
		selectOnFocus:true
	});
	
	var winvendor = new Ext.ux.VendorComboBox({
		fieldLabel : '供应商',
		id : 'winvendor',
		name : 'winvendor',
		width:200,
		listWidth:200,
		anchor : '90%',
		selectOnFocus:true,
		emptyText : '供应商...'
	});
	

	var stockloc = new Ext.ux.LocComboBox({
		fieldLabel : '缺省登陆科室',
		id : 'stockloc',
		name : 'stockloc',
		width:200,
		listWidth:200,
		anchor : '90%',
		selectOnFocus:true,
		emptyText : '缺省登陆科室...',
		groupId:vendorGroupRowID,
		hidden : true		//此界面改造后,不再处理ss_user,该控件暂时隐藏
	});
	
	//开始日期
	var datefrom = new Ext.ux.DateField({ 
		id:'datefrom',
		fieldLabel:'开始日期',
		allowBlank:true,
		anchor : '90%'
	});
	
	//截止日期
	var dateto = new Ext.ux.DateField({ 
		id:'dateto',
		fieldLabel:'截止日期', 
		allowBlank:true,
		anchor : '90%'
	});

	//状态
	var stateStore = new Ext.data.SimpleStore({
		fields:['key', 'keyValue'],
		data:[["Y",'使用'], ["N",'停用']]
	});	
	var stateField = new Ext.form.ComboBox({
		id:'stateField',
		fieldLabel:'使用状态',
		anchor : '90%',
		allowBlank:true,
		store:stateStore,
		value:'Y', // 默认值"使用"
		valueField:'key',
		displayField:'keyValue',
		triggerAction:'all',
		minChars:1,
		pageSize:10,
		selectOnFocus:true,
		forceSelection:true,
		editable:true,
		mode:'local'
	});
	
	var okButton = new Ext.Toolbar.Button({
		text:'保存/注册',
		handler:function(){	
			var ss=getVendorUserDataStr();
			if(ss!=false){
				InsVendorUserInfo(ss);  //执行插入
			}
		}
	});
	
	//初始化取消按钮
	var cancelButton = new Ext.Toolbar.Button({
		text:'取消',
		handler:function()
		{
			if (window){window.close();}
			
		}
	});
	
	//初始化面板
	var vendorUserPanel = new Ext.form.FormPanel({
		labelwidth : 30,
		labelAlign : 'right',
		frame : true,
		autoScroll : true,
		bodyStyle : 'padding:5px;',
		autoHeight : true,
		layout:'form',
		height:25,
		items : [
			[userid],
			[username],
			[password],
			[winvendor],
			[stockloc],
			[datefrom],
			[dateto],
			[stateField]
		]	
	});
	
	//初始化窗口
	var window = new Ext.Window({
		title:'注册供应商用户信息',
		width:400,
		height:320,
		layout:'fit',
		plain:true,
		modal:true,
		bodyStyle:'padding:5px;',
		buttonAlign:'right',
		items:vendorUserPanel,
		buttons:[okButton, cancelButton],
		listeners:{
			'show':function(){
				if (rowid!=''){SetVendorUserInfo(rowid);}
			}
		}
	});
	
	window.show();
	
	//显示供应商信息
	function SetVendorUserInfo(rowid)
	{
		Ext.Ajax.request({
			url: VendorUserGridUrl+'?actiontype=queryByRowId&rowid='+rowid,
			success: function(result, request) {
				var jsonData = Ext.util.JSON.decode( result.responseText );
				if (jsonData.success=='true') {
					var value = jsonData.info;
					var arr = value.split("^");
					//基础信息
					Ext.getCmp('userid').setValue(arr[1]);
					Ext.getCmp('username').setValue(arr[2]);
					Ext.getCmp('password').setValue(arr[3]);
					addComboData(winvendor.getStore(),arr[0],arr[7]);
					Ext.getCmp('winvendor').setValue(arr[0]);
					addComboData(winvendor.getStore(),arr[9],arr[8]);
					Ext.getCmp('stockloc').setValue(arr[9]);
					Ext.getCmp('datefrom').setValue(arr[4]);
					Ext.getCmp('dateto').setValue(arr[5]);
					addComboData(stateStore,arr[6],arr[10]);
					Ext.getCmp('stateField').setValue(arr[6]);
				}
			},
			scope: this
		});
	}

	//取得供应商串
	function  getVendorUserDataStr()
	{
		var userid = Ext.getCmp('userid').getValue();
		var username = Ext.getCmp('username').getValue();
		var password = Ext.getCmp('password').getValue();
		var winvendor = Ext.getCmp('winvendor').getValue();
		var stockloc = Ext.getCmp('stockloc').getValue();
		if(username.trim()==""){
			Msg.info("warning","用户名不能为空!");
			return false;
		}
		if(password.trim()==""){
			Msg.info("warning","密码不能为空!");
			return false;
		}
		if(winvendor.trim()==""){
			Msg.info("warning","供应商不能为空!");
			return false;
		}
//		if(stockloc.trim()==""){
//			Msg.info("warning","缺省登陆科室不能为空!");
//			return false;
//		}
		var datefrom = Ext.getCmp('datefrom').getValue();
		if((datefrom!="")&&(datefrom!=null)){
			datefrom = datefrom.format(ARG_DATEFORMAT);
		}
		var dateto = Ext.getCmp('dateto').getValue();
		if((dateto!="")&&(dateto!=null)){
			dateto = dateto.format(ARG_DATEFORMAT);
		}
		var state= Ext.getCmp('stateField').getValue()
		//拼data字符串
		var data=userid+"^"+username+"^"+password+"^"+winvendor+"^"+datefrom+"^"+dateto+"^"+state+"^"+stockloc;
		return data;
	}

	//插入
	function InsVendorUserInfo(data){
		var mask=ShowLoadMask(Ext.getBody(),"处理中请稍候...");
		Ext.Ajax.request({
			url: VendorUserGridUrl+'?actiontype=insert',
			params : {data : data},
			method:'post',
			waitMsg:'处理中...',
			failure: function(result, request) {
				Msg.info("error","请检查网络连接!");
			},
			success: function(result, request) {
				var jsonData = Ext.util.JSON.decode( result.responseText );
				mask.hide();
				if (jsonData.success=='true') {
					var newRowid = jsonData.info;
					Msg.info("success", "保存成功!");
					window.close();
					Ext.getCmp('useridf').setValue(newRowid);
					findVendorUser.handler();
				}else{
					Msg.info("error", "保存失败!");
				}
			},
			scope: this
		});	
	}
}
	
var addVendorUser = new Ext.Toolbar.Button({
	text:'新建用户',
	tooltip:'新建',
	iconCls:'page_add',
	width : 70,
	height : 30,
	handler:function(){
		CreateEditWin('');
	}
});

var editVendorUser = new Ext.Toolbar.Button({
	text:'修改编辑',
	tooltip:'编辑',
	iconCls:'page_edit',
	width : 70,
	height : 30,
	handler:function(){
		var rowObj = VendorUserGrid.getSelectionModel().getSelections(); 
		var len = rowObj.length;
		if(len < 1){
			Msg.info("error","请选择数据!");
			return false;
		}else{
			var userid = rowObj[0].get('Userid');
			//窗口显示
			CreateEditWin(userid);
		}
	}
});

var formPanel = new Ext.ux.FormPanel({
	title:'供应商用户维护',
	tbar:[findVendorUser,'-',addVendorUser,'-',editVendorUser],
	items : [{
		xtype : 'fieldset',
		title : '查询条件',
		layout : 'column',
		style : 'padding:5px 0px 0px 5px',
		defaults:{border:false,columnWidth : .25,xtype:'fieldset',labelWidth:60},
		items : [{
				items : [Category]
			}, {
				items : [Vendor]
			}, {
				items : [useridf]
			}, {
				items : [ActiveStoreField]
			}
		]
	}]
});

//分页工具栏
var VendorUserPagingToolbar = new Ext.PagingToolbar({
	store:VendorUserGridDs,
	pageSize:40,
	displayInfo:true
});

//表格
VendorUserGrid = new Ext.grid.EditorGridPanel({
	store:VendorUserGridDs,
	cm:VendorUserGridCm,
	title:'供应商用户明细信息',
	trackMouseOver:true,
	region:'center',
	stripeRows:true,
	sm:new Ext.grid.RowSelectionModel({singleSelect:false}),
	loadMask:true,
	bbar:VendorUserPagingToolbar,
	listeners:{
		'rowdblclick':function(){
			editVendorUser.handler();
		}
	}
});

Ext.onReady(function(){
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	
	var mainPanel = new Ext.ux.Viewport({
		layout:'border',
		items:[formPanel,VendorUserGrid],
		renderTo:'mainPanel'
	});
});
findVendorUser.handler();
