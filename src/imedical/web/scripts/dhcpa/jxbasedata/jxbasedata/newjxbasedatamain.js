/**
  *name:tab of database
  *author:limingzhong
  *Date:2009-11-6
 */

var uploadUrl = 'http://132.147.160.114:8080/uploadexcel/uploadexcel';
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
	width:210,
	listWidth : 210,
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
	width:180,
	listWidth : 180,
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
		'desc'
	]),
    // turn on remote sorting
    remoteSort: true
});

//设置默认排序字段和排序方向
JXBaseDataTabDs.setDefaultSort('rowid', 'desc');

//数据库数据模型
var JXBaseDataTabCm = new Ext.grid.ColumnModel([
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
		width: 170,
		sortable: true
	},{
		header: "实际值",
		dataIndex: 'actualValue',
		width: 100,
		sortable: true,
		renderer:format,
		align: 'right'
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
var addButton = new Ext.Toolbar.Button({
	text: '添加',
    tooltip:'添加',        
    iconCls:'add',
	handler:function(){
		addFun(Ext.getCmp('pType').getValue(),Ext.getCmp('periodField').getRawValue(),JXBaseDataTabDs,JXBaseDataTabPagingToolbar);
	}
});

//导入按钮
var importButton = new Ext.Toolbar.Button({
	text: '导入接口数据',
    tooltip:'导入接口数据',        
    iconCls:'add',
	handler:function(){
		var PeriodField = new Ext.form.TextField({
			id:'PeriodField',
			fieldLabel: '考核期间',
			allowBlank: false,
			width:230,
			listWidth : 230,
			emptyText:'请填写考核期间...',
			anchor: '90%',
			selectOnFocus:'true'
		});

		var periodTypeStore = new Ext.data.SimpleStore({
			fields: ['key','keyValue'],
			data:[['M','月'],['Q','季'],['H','半年'],['Y','年']]
		});
		var PeriodType = new Ext.form.ComboBox({
			id: 'PeriodType',
			fieldLabel: '期间类型',
			width:230,
			listWidth : 230,
			allowBlank: false,
			store: periodTypeStore,
			anchor: '90%',
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
		
		var formPanel = new Ext.form.FormPanel({
			baseCls: 'x-plain',
			labelWidth:60,
			items: [
				PeriodField,
				PeriodType
			]
		});
		
		//定义按钮
		var importB = new Ext.Toolbar.Button({
			text:'导入'
		});
			
		//添加处理函数
		var importHandler = function(){
			var period = PeriodField.getValue();
			period = trim(period);
			if(period==""){
				Ext.Msg.show({title:'提示',msg:'考核期间为空!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
				return false;
			};
			var periodTypeDr = PeriodType.getValue();
			periodTypeDr = trim(periodTypeDr);
			if(periodTypeDr==""){
				Ext.Msg.show({title:'提示',msg:'期间类型为空!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
				return false;
			};
			Ext.Ajax.request({
				url:'dhc.pa.jxbasedataexe.csp?action=import&period='+period+'&periodType='+periodTypeDr,
				waitMsg:'添加中..',
				failure: function(result, request){
					Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
				},
				success: function(result, request){
					var jsonData = Ext.util.JSON.decode( result.responseText );
					if (jsonData.success=='true'){
						Ext.Msg.show({title:'提示',msg:'添加成功!',icon:Ext.MessageBox.INFO,buttons:Ext.Msg.OK});
						store.load({params:{start:0,limit:pagingToolbar.pageSize,parRef:parRef,period:periodValue,periodType:Ext.getCmp('pType').getValue(),dir:'asc',sort:'childSub',userID:userID }});
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
			height:150,
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
});

var aduitButton  = new Ext.Toolbar.Button({
	text:'审核',
	tooltip:'审核',
	iconCls:'remove',
	handler: function(){
		var period = periodField.getValue();
			period = trim(period);
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
									var message="审核错误";
									Ext.Msg.show({title:'错误',msg:message,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
								}
							},
							scope: this
						});
					}
				}
				)
	}
});

var delButton  = new Ext.Toolbar.Button({
	text:'删除',
	tooltip:'删除',
	iconCls:'add',
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
						Ext.Ajax.request({
							url:'dhc.pa.jxbasedataexe.csp?action=del&rowid='+rowObj[0].get("rowid"),
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
			)
		}
	}
});

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
			checked: true,
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
              B['userID']=userID
		B['dir']="asc";
		B['sort']="childSub";
		if(this.fireEvent("beforechange",this,B)!==false){
			this.store.load({params:B});
		}
	}
});

//表格
var JXBaseDataTab = new Ext.grid.GridPanel({
	title: '基本数据管理',
	store: JXBaseDataTabDs,
	cm: JXBaseDataTabCm,
	trackMouseOver: true,
	stripeRows: true,
	sm: new Ext.grid.RowSelectionModel({singleSelect:true}),
	loadMask: true,
	tbar:['考核期间:',periodField,'-','期间类型:',pType,'-',addButton,'-',importButton,'-',delButton],
	bbar:JXBaseDataTabPagingToolbar
});


