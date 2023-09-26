// ����:��Ӧ���û���Ϣ����
// ��д����:2013-05-15
//��д��:�쳬

//=========================��Ӧ�����=============================
var VendorUserGridUrl = 'dhcstm.vendoruseraction.csp';
var vendorGroupRowID = tkMakeServerCall("web.DHCSTM.VendorUser","getVendorUserGroup");

var Vendor = new Ext.ux.VendorComboBox({
	fieldLabel : '��Ӧ��',
	id : 'Vendor',
	name : 'Vendor',
	anchor : '90%',
	emptyText : '��Ӧ��...'
});

var ActiveStore = new Ext.data.SimpleStore({
	fields:['key', 'keyValue'],
	data:[["Y",'ʹ��'], ["N",'ͣ��'], ["",'ȫ��']]
});
var ActiveStoreField = new Ext.form.ComboBox({
	id:'ActiveStoreField',
	fieldLabel:'ʹ��״̬',
	anchor:'90%',
	allowBlank:true,
	store:ActiveStore,
	value:'', // Ĭ��ֵ"ȫ����ѯ"
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
	fieldLabel:'�û�ID',
	width:200,
	listWidth:200,
	emptyText:'�û�ID',
	anchor:'90%',
	selectOnFocus:true
});

var Category = new Ext.ux.ComboBox({
	id: 'Category',
	fieldLabel: '����',
	anchor: '90%',
	store: GetVendorCatStore,
	triggerAction: 'all'
});

	
//��������Դ
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

//ģ��
var VendorUserGridCm = new Ext.grid.ColumnModel([
	new Ext.grid.RowNumberer(),
	{
		header:"��Ӧ������",
		dataIndex:'Apcvmdesc',
		width:220,
		align:'left',
		sortable:true
	},{
		header:"ȱʡ��½����",
		dataIndex:'StockLoc',
		width:200,
		align:'left',
		sortable:true
	},{
		header:"�û�ID",
		dataIndex:'Userid',
		width:150,
		align:'left',
		sortable:true
	},{
		header:"�û�����",
		dataIndex:'Username',
		width:150,
		align:'left',
		sortable:true
	},{
		header:"��ʼ����",
		dataIndex:'Datefrom',
		width:150,
		align:'left',
		sortable:false
	},{
		header:"��������",
		dataIndex:'Dateto',
		width:150,
		align:'left',
		sortable:false
	},{
		header:"ʹ�ñ�־",
		dataIndex:'Active',
		width:150,
		align:'left',
		sortable:false,
		renderer:function(v){
			if (v=="Y"){
				return "ʹ��";
			}else{
				return "δʹ��";
			}
		}
	}
]);

var findVendorUser = new Ext.Toolbar.Button({
	text:'��ѯ',
	tooltip:'��ѯ',
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

//�����༭����(����)
//rowid :��Ӧ��rowid
function CreateEditWin(rowid)
{	
	//�û�ID
	var userid = new Ext.form.TextField({
		id:'userid',
		fieldLabel:'�û�ID',
		width:200,
		listWidth:200,
		emptyText:'�û�ID',
		anchor:'90%',
		disabled:true,
		selectOnFocus:true
	});
	
	//�û�����
	var username = new Ext.form.TextField({
		id:'username',
		fieldLabel:'�û���',
		allowBlank:false,
		width:200,
		listWidth:200,
		//emptyText:'��Ӧ������...',
		anchor:'90%',
		selectOnFocus:true
	});
	
	//����
	
	var password = new Ext.form.TextField({
		id:'password',
		fieldLabel:'����',
		allowBlank:false,
		width:200,
		listWidth:200,
		anchor:'90%',
		selectOnFocus:true
	});
	
	var winvendor = new Ext.ux.VendorComboBox({
		fieldLabel : '��Ӧ��',
		id : 'winvendor',
		name : 'winvendor',
		width:200,
		listWidth:200,
		anchor : '90%',
		selectOnFocus:true,
		emptyText : '��Ӧ��...'
	});
	

	var stockloc = new Ext.ux.LocComboBox({
		fieldLabel : 'ȱʡ��½����',
		id : 'stockloc',
		name : 'stockloc',
		width:200,
		listWidth:200,
		anchor : '90%',
		selectOnFocus:true,
		emptyText : 'ȱʡ��½����...',
		groupId:vendorGroupRowID,
		hidden : true		//�˽�������,���ٴ���ss_user,�ÿؼ���ʱ����
	});
	
	//��ʼ����
	var datefrom = new Ext.ux.DateField({ 
		id:'datefrom',
		fieldLabel:'��ʼ����',
		allowBlank:true,
		anchor : '90%'
	});
	
	//��ֹ����
	var dateto = new Ext.ux.DateField({ 
		id:'dateto',
		fieldLabel:'��ֹ����', 
		allowBlank:true,
		anchor : '90%'
	});

	//״̬
	var stateStore = new Ext.data.SimpleStore({
		fields:['key', 'keyValue'],
		data:[["Y",'ʹ��'], ["N",'ͣ��']]
	});	
	var stateField = new Ext.form.ComboBox({
		id:'stateField',
		fieldLabel:'ʹ��״̬',
		anchor : '90%',
		allowBlank:true,
		store:stateStore,
		value:'Y', // Ĭ��ֵ"ʹ��"
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
		text:'����/ע��',
		handler:function(){	
			var ss=getVendorUserDataStr();
			if(ss!=false){
				InsVendorUserInfo(ss);  //ִ�в���
			}
		}
	});
	
	//��ʼ��ȡ����ť
	var cancelButton = new Ext.Toolbar.Button({
		text:'ȡ��',
		handler:function()
		{
			if (window){window.close();}
			
		}
	});
	
	//��ʼ�����
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
	
	//��ʼ������
	var window = new Ext.Window({
		title:'ע�ṩӦ���û���Ϣ',
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
	
	//��ʾ��Ӧ����Ϣ
	function SetVendorUserInfo(rowid)
	{
		Ext.Ajax.request({
			url: VendorUserGridUrl+'?actiontype=queryByRowId&rowid='+rowid,
			success: function(result, request) {
				var jsonData = Ext.util.JSON.decode( result.responseText );
				if (jsonData.success=='true') {
					var value = jsonData.info;
					var arr = value.split("^");
					//������Ϣ
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

	//ȡ�ù�Ӧ�̴�
	function  getVendorUserDataStr()
	{
		var userid = Ext.getCmp('userid').getValue();
		var username = Ext.getCmp('username').getValue();
		var password = Ext.getCmp('password').getValue();
		var winvendor = Ext.getCmp('winvendor').getValue();
		var stockloc = Ext.getCmp('stockloc').getValue();
		if(username.trim()==""){
			Msg.info("warning","�û�������Ϊ��!");
			return false;
		}
		if(password.trim()==""){
			Msg.info("warning","���벻��Ϊ��!");
			return false;
		}
		if(winvendor.trim()==""){
			Msg.info("warning","��Ӧ�̲���Ϊ��!");
			return false;
		}
//		if(stockloc.trim()==""){
//			Msg.info("warning","ȱʡ��½���Ҳ���Ϊ��!");
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
		//ƴdata�ַ���
		var data=userid+"^"+username+"^"+password+"^"+winvendor+"^"+datefrom+"^"+dateto+"^"+state+"^"+stockloc;
		return data;
	}

	//����
	function InsVendorUserInfo(data){
		var mask=ShowLoadMask(Ext.getBody(),"���������Ժ�...");
		Ext.Ajax.request({
			url: VendorUserGridUrl+'?actiontype=insert',
			params : {data : data},
			method:'post',
			waitMsg:'������...',
			failure: function(result, request) {
				Msg.info("error","������������!");
			},
			success: function(result, request) {
				var jsonData = Ext.util.JSON.decode( result.responseText );
				mask.hide();
				if (jsonData.success=='true') {
					var newRowid = jsonData.info;
					Msg.info("success", "����ɹ�!");
					window.close();
					Ext.getCmp('useridf').setValue(newRowid);
					findVendorUser.handler();
				}else{
					Msg.info("error", "����ʧ��!");
				}
			},
			scope: this
		});	
	}
}
	
var addVendorUser = new Ext.Toolbar.Button({
	text:'�½��û�',
	tooltip:'�½�',
	iconCls:'page_add',
	width : 70,
	height : 30,
	handler:function(){
		CreateEditWin('');
	}
});

var editVendorUser = new Ext.Toolbar.Button({
	text:'�޸ı༭',
	tooltip:'�༭',
	iconCls:'page_edit',
	width : 70,
	height : 30,
	handler:function(){
		var rowObj = VendorUserGrid.getSelectionModel().getSelections(); 
		var len = rowObj.length;
		if(len < 1){
			Msg.info("error","��ѡ������!");
			return false;
		}else{
			var userid = rowObj[0].get('Userid');
			//������ʾ
			CreateEditWin(userid);
		}
	}
});

var formPanel = new Ext.ux.FormPanel({
	title:'��Ӧ���û�ά��',
	tbar:[findVendorUser,'-',addVendorUser,'-',editVendorUser],
	items : [{
		xtype : 'fieldset',
		title : '��ѯ����',
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

//��ҳ������
var VendorUserPagingToolbar = new Ext.PagingToolbar({
	store:VendorUserGridDs,
	pageSize:40,
	displayInfo:true
});

//���
VendorUserGrid = new Ext.grid.EditorGridPanel({
	store:VendorUserGridDs,
	cm:VendorUserGridCm,
	title:'��Ӧ���û���ϸ��Ϣ',
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
