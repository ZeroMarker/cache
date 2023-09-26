FormPlugin = function(msg) {
	// 构造函数中完成
	this.init = function(cmp) {
		// 控件渲染时触发
		cmp.on("render",function() {
			cmp.el.insertHtml("afterEnd","<font color='red'>*</font><font color='blue'>"+ msg + "</font>");
		});
	}
}
 
var smObj = new Ext.grid.RowSelectionModel({
	moveEditorOnEnter : true,
	onEditorKey : function(field, e) {
		var k = e.getKey(), newCell, g = this.grid, last = g.lastEdit, ed = g.activeEditor, ae, last, r, c;
		var shift = e.shiftKey;

		if (k === TAB) {
			e.stopEvent();
			ed.completeEdit();

			if (shift) {
				newCell = g.walkCells(ed.row, ed.col - 1, -1, this.acceptsNav,
						this);
			} else {

				newCell = g.walkCells(ed.row + 1, ed.col, 1, this.acceptsNav,
						this);
			}
			if (newCell) {
				r = newCell[0];
				c = newCell[1];
				tmpRow = r;
				tmpColumn = c;

				if (g.isEditor && g.editing) { // *** handle tabbing while
					// editorgrid is in edit mode
					ae = g.activeEditor;
					if (ae && ae.field.triggerBlur) {

						ae.field.triggerBlur();
					}
				}
				g.startEditing(r, c);
			}

		}

	}
});
var value = "http: //www.baidu.com";

function DomUrl() {

	return "<a href=>" + value + "</a>";
}

var tabUrl = '../csp/dhc.bonus.bonustargetcollectexe.csp';
var userCode=session['LOGON.USERCODE'];
// 核算年度
var yearDs = new Ext.data.Store({
	autoLoad:true,
	proxy:"",
	reader:new Ext.data.JsonReader({
		totalProperty:'results',
		root:'rows'
	}, ['rowid','name'])
});

yearDs.on('beforeload',function(ds,o) {
	ds.proxy = new Ext.data.HttpProxy({
		url:tabUrl+'?action=yearlist'
	})
});

var yearField = new Ext.form.ComboBox({
	id:'yearField',
	fieldLabel:'年  度',
	width:80,
	listWidth:60,
	allowBlank:false,
	store:yearDs,
	valueField:'rowid',
	displayField:'name',
	triggerAction:'all',
	emptyText:'',
	minChars:1,
	pageSize:10,
	selectOnFocus:false,
	forceSelection:'true',
	editable:true
});

var periodTypeStore = new Ext.data.SimpleStore({
	fields:['key', 'keyValue'],
	data:[['M', '月份'], ['Q', '季度'], ['H', '半年'], ['Y', '年度']]
});
var periodTypeField = new Ext.form.ComboBox({
	id : 'periodTypeField',
	fieldLabel : '期间类型',
	width : 60,
	listWidth : 40,
	selectOnFocus : true,
	allowBlank : false,
	store : periodTypeStore,
	anchor : '90%',
	value : '', // 默认值
	valueNotFoundText : '',
	displayField : 'keyValue',
	valueField : 'key',
	triggerAction : 'all',
	emptyText : '',
	mode : 'local', // 本地模式
	editable : false,
	pageSize : 10,
	minChars : 1,
	selectOnFocus : true,
	forceSelection : true
});

periodTypeField.on("select", function(cmb, rec, id) {
	if (cmb.getValue() == "M") {
		data = [['M01', '01月'], ['M02', '02月'], ['M03', '03月'], ['M04', '04月'],
				['M05', '05月'], ['M06', '06月'], ['M07', '07月'], ['M08', '08月'],
				['M09', '09月'], ['M10', '10月'], ['M11', '11月'], ['M12', '12月']];
	}
	if (cmb.getValue() == "Q") {
		data = [['Q01', '01季度'], ['Q02', '02季度'], ['Q03', '03季度'],
				['Q04', '04季度']];
	}
	if (cmb.getValue() == "H") {
		data = [['H01', '上半年'], ['H02', '下半年']];
	}
	if (cmb.getValue() == "Y") {
		data = [['0', '00']];
	}
	periodStore.loadData(data);
});


periodStore = new Ext.data.SimpleStore({
	fields : ['key', 'keyValue'],
	data: [['M01', '01月'], ['M02', '02月'], ['M03', '03月'], ['M04', '04月'],
				['M05', '05月'], ['M06', '06月'], ['M07', '07月'], ['M08', '08月'],
				['M09', '09月'], ['M10', '10月'], ['M11', '11月'], ['M12', '12月']]
});



var periodField = new Ext.form.ComboBox({
	id:'periodField',
	fieldLabel:'',
	width:80,
	listWidth:60,
	selectOnFocus:true,
	allowBlank:false,
	store:periodStore,
	anchor:'90%',
	valueNotFoundText:'',
	displayField:'keyValue',
	valueField:'key',
	triggerAction:'all',
	emptyText:'',
	mode:'local', // 本地模式
	editable:false,
	pageSize:10,
	minChars:1,
	selectOnFocus:true,
	forceSelection:true
});
// 核算项目
var itemDs = new Ext.data.Store({
	autoLoad:true,
	proxy:"",
	reader:new Ext.data.JsonReader({
		totalProperty:'results',
		root:'rows'
	}, ['rowid','name'])
});

itemDs.on('beforeload',function(ds,o) {
	ds.proxy = new Ext.data.HttpProxy({
		url:'../csp/dhc.bonus.bonusissexe.csp?action=itemlist&year='+Ext.getCmp('yearField').getValue()+'&period='+Ext.getCmp('periodField').getValue()+'&userCode='+userCode
	})
});

var itemField = new Ext.form.ComboBox({
	id:'itemField',
	fieldLabel:'核算项目',
	width:150,
	listWidth:150,
	allowBlank:false,
	store:itemDs,
	valueField:'rowid',
	displayField:'name',
	triggerAction:'all',
	emptyText:'',
	minChars:1,
	pageSize:10,
	selectOnFocus:false,
	forceSelection:'true',
	editable:true
});

var queryButton = new Ext.Toolbar.Button({
	text:'查  询',
	tooltip:'查询',
	iconCls:'option',
	handler:function(){
		var year = Ext.getCmp('yearField').getValue();
		if(year==""){
			Ext.Msg.show({title:'提示',msg:'请选择年度!',buttons:Ext.Msg.OK,icon:Ext.MessageBox.INFOR});
			return;
		}
		var period = Ext.getCmp('periodField').getValue();
		if(period==""){
			Ext.Msg.show({title:'提示',msg:'请选择期间!',buttons:Ext.Msg.OK,icon:Ext.MessageBox.INFOR});
			return;
		}
		var itemId = Ext.getCmp('itemField').getValue();
		scheme1Ds.load({params:{start:0,limit:schemePagingToolbar.pageSize,itemId:itemId,year:year,period:period,userCode:userCode}});
	}
});

var upButton = new Ext.Toolbar.Button({
	text:'数据同步',
	tooltip:'数据同步',
	iconCls:'option',
	handler:function(){
		var rowObj=scheme1Main.getSelections();
		var total = rowObj[0].get("downmoeny");
		var rowid = rowObj[0].get("rowid");
		Ext.Ajax.request({
			url:'../csp/dhc.bonus.bonusissexe.csp?action=yz&rowid='+rowid+'&total='+total,
			failure : function(result, request) {
				Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons:Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
			},
			success : function(result, request) {
				var jsonData = Ext.util.JSON.decode(result.responseText);
				if (jsonData.success == 'true') {
					Ext.MessageBox.confirm('提示', '验证成功,确定要上报数据吗?', callback);
				} else {
					Ext.MessageBox.confirm('提示', '数据不等,确定要上报数据吗?', callback);
				}
			},
			scope : this
		});
	}
});
var uploadButton = new Ext.Toolbar.Button({
			text : 'Excel数据导入',
			tooltip : '导入数据(Excel格式)',
			iconCls : 'add',
			handler : function() {

				importExcel('incomeCollect');

				return;

			}

		});
var schemeValue = new Array(	
	{header:'数据ID',dataIndex:'rowid'},
	{header:'文件名称',dataIndex:'locId'},	
	{header:'描   述',dataIndex:'locName'}, 					
	{header:'当前月份',dataIndex:'itemId'},
	{header:'数据状态',dataIndex:'itemName'},               
	{header:'导入时间',dataIndex:'downmoeny'},
	{header:'同步时间',dataIndex:'upStatus'}
);
var schemeUrl = 'dhc.bonus.bonusissexe.csp';
var schemeProxy = new Ext.data.HttpProxy({url:schemeUrl+'?action=locinfo'});

var scheme1Ds = new Ext.data.Store({
	proxy:schemeProxy,
	reader:new Ext.data.JsonReader({
		root:'rows',
		totalProperty:'results'
	},[
		schemeValue[0].dataIndex,
		schemeValue[1].dataIndex,
		schemeValue[2].dataIndex,
		schemeValue[3].dataIndex,
		schemeValue[4].dataIndex,
		schemeValue[5].dataIndex,
		schemeValue[6].dataIndex


	]),
	remoteSort: true
});

scheme1Ds.setDefaultSort('rowid', 'Desc');

var inDeptsCm = new Ext.grid.ColumnModel([
	new Ext.grid.RowNumberer(),
	{
		header:schemeValue[0].header,
		dataIndex:schemeValue[0].dataIndex,
		width:50,
		align:'center',
		sortable:true
	},{
		header:schemeValue[1].header,
		dataIndex:schemeValue[1].dataIndex,
		width:80,
		align:'center',
		sortable:true
	},{
		header:schemeValue[2].header,
		dataIndex:schemeValue[2].dataIndex,
		width:100,
		align:'center',
		sortable:true
	},{
		header:schemeValue[3].header,
		dataIndex:schemeValue[3].dataIndex,
		width:60,
		align:'center',
		sortable:true
	},{
		header:schemeValue[4].header,
		dataIndex:schemeValue[4].dataIndex,
		width:60,
		align:'center',
		sortable:true
	},{
		header:schemeValue[5].header,
		dataIndex:schemeValue[5].dataIndex,
		width:90,
		align:'center',
		sortable:true
	},{
		header:schemeValue[6].header,
		dataIndex:schemeValue[6].dataIndex,
		width:90,
		align:'center',
		sortable:true
	}
]);

var schemePagingToolbar = new Ext.PagingToolbar({
	pageSize: 25,
	store: scheme1Ds,
	displayInfo: true,
	displayMsg: '当前显示{0} - {1}，共计{2}',
	emptyMsg:"没有数据",
	doLoad:function(C){
		var B={},
		A=this.paramNames;
		B[A.start]=C;
		B[A.limit]=this.pageSize;
		B['period']=Ext.getCmp('periodField').getValue();
		B['itemId']=Ext.getCmp('itemField').getValue();
		B['userCode']=userCode;
		B['year']=Ext.getCmp('yearField').getValue();
		B['dir']="desc";
		B['sort']="rowid";
		if(this.fireEvent("beforechange",this,B)!==false){
			this.store.load({params:B});
		}
	}
});

var schemeSM= new Ext.grid.RowSelectionModel({singleSelect:true});

var scheme1Main = new Ext.grid.GridPanel({
	title:'人员数据导入记录',
	region:'north',
	//width:600,
	height:300,
	store: scheme1Ds,
	cm: inDeptsCm,
	trackMouseOver: true,
	stripeRows: true,
	sm: schemeSM,
	loadMask: true,
	viewConfig: {forceFit:true},
	tbar:['年  度',yearField,'-','月  份',periodField,'-',queryButton,'-',upButton,'-',uploadButton],
	bbar: schemePagingToolbar
});
//,'-','项目名称',itemField


var tmpSelectedScheme='';
var itemDr="";
scheme1Main.on('rowclick',function(grid,rowIndex,e){
	var selectedRow = scheme1Ds.data.items[rowIndex];
	tmpSelectedScheme=selectedRow.data['rowid'];
	itemDr=selectedRow.data['itemId'];
	if(itemDr==""){
		Ext.Msg.show({title:'提示',msg:'项目为空!',buttons:Ext.Msg.OK,icon:Ext.MessageBox.INFOR});
		return;
	}
	if(tmpSelectedScheme==""){
		Ext.Msg.show({title:'提示',msg:'主表记录为空!',buttons:Ext.Msg.OK,icon:Ext.MessageBox.INFOR});
		return;
	}
	scheme02Ds.proxy = new Ext.data.HttpProxy({url:scheme02Url+'?action=detail&parent='+tmpSelectedScheme+'&itemId='+itemDr});
	scheme02Ds.load({params:{start:0, limit:scheme02PagingToolbar.pageSize,year:Ext.getCmp('yearField').getValue(),period:Ext.getCmp('periodField').getValue()}});
});

var scheme02Value = new Array(
	{header:'数据ID',dataIndex:'rowid'},						
	{header:'工  号',dataIndex:'year'}, 				
	{header:'姓  名',dataIndex:'period'},      
	{header:'原来所属科室',dataIndex:'personId'},	
	{header:'变动后科室',dataIndex:'personName'},      
	{header:'变动时间',dataIndex:'downmoeny'}

);

var scheme02Url = 'dhc.bonus.bonusissexe.csp';
var scheme02Ds = new Ext.data.Store({
	proxy: '',
	reader: new Ext.data.JsonReader({
		root: 'rows',
		totalProperty: 'results'
	},[
		scheme02Value[0].dataIndex,
		scheme02Value[1].dataIndex,
		scheme02Value[2].dataIndex,
		scheme02Value[3].dataIndex,
		scheme02Value[4].dataIndex,
		scheme02Value[5].dataIndex

	]),
	remoteSort: true
});

scheme02Ds.setDefaultSort('BonusUnitCode', 'Desc');

var inDeptsCm = new Ext.grid.ColumnModel([
	new Ext.grid.RowNumberer(),
	{
		header:scheme02Value[1].header,
		dataIndex:scheme02Value[1].dataIndex,
		width:100,
		align:'center',
		sortable:true
	},{
		header:scheme02Value[2].header,
		dataIndex:scheme02Value[2].dataIndex,
		width:100,
		align:'center',
		sortable:true
	},{
		header: scheme02Value[3].header,
		dataIndex: scheme02Value[3].dataIndex,
		width: 120,
		align:'center',
		sortable: true
	},{
		header: scheme02Value[4].header,
		dataIndex: scheme02Value[4].dataIndex,
		width: 120,
		align:'center',
		sortable: true
	},{
		header: scheme02Value[5].header,
		dataIndex: scheme02Value[5].dataIndex,
		width: 150,
		align:'center',
		sortable: true
	}
]);


var scheme02PagingToolbar = new Ext.PagingToolbar({
	pageSize: 25,
	store: scheme02Ds,
	displayInfo: true,
	displayMsg: '当前显示{0} - {1}，共计{2}',
	emptyMsg: "没有数据",
	doLoad:function(C){
		var B={},
		A=this.paramNames;
		B[A.start]=C;
		B[A.limit]=this.pageSize;
		B['parent']=tmpSelectedScheme;
		B['period']=Ext.getCmp('periodField').getValue();
		B['itemId']=itemDr;
		B['year']=Ext.getCmp('yearField').getValue();
		B['dir']="desc";
		B['sort']="rowid";
		if(this.fireEvent("beforechange",this,B)!==false){
			this.store.load({params:B});
		}
	}
});

var codeField = new Ext.form.TextField({
	id: 'codeField',
	name:'code',
	fieldLabel: '方案代码',
	allowBlank: false,
	emptyText: '必填',
	anchor: '100%'
});

var nameField = new Ext.form.TextField({
	id: 'nameField',
	name:'name',
	fieldLabel: '方案名称',
	allowBlank: false,
	emptyText: '必填',
	anchor: '100%'
});

var descField = new Ext.form.TextField({
	id: 'descField',
	name:'desc',
	fieldLabel: '方案描述',
	emptyText: '',
	anchor: '100%'
});

//验证
var yzButton = new Ext.Toolbar.Button({
	text: '数据验证',
	tooltip: '数据验证',
	iconCls: 'add',
	handler: function(){
		var rowObj=scheme1Main.getSelections();
		var total = rowObj[0].get("downmoeny");
		var rowid = rowObj[0].get("rowid");
		Ext.Ajax.request({
			url:'../csp/dhc.bonus.bonusissexe.csp?action=yz&rowid='+rowid+'&total='+total,
			failure : function(result, request) {
				Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons:Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
			},
			success : function(result, request) {
				var jsonData = Ext.util.JSON.decode(result.responseText);
				if (jsonData.success == 'true') {
					Ext.Msg.show({title:'提示',msg:'验证成功!',buttons:Ext.Msg.OK,icon:Ext.MessageBox.INFO});
				} else {
					Ext.Msg.show({title:'错误',msg:'数据不等!',buttons:Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
				}
			},
			scope : this
		});
	}
});
function callback(id){
	if (id == "yes"){
		var rowObj=scheme1Main.getSelections();
		var rowid = rowObj[0].get("rowid");
		Ext.Ajax.request({
			url:'../csp/dhc.bonus.bonusissexe.csp?action=up&rowid='+rowid+'&userCode='+userCode,
			failure : function(result, request) {
				Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons:Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
			},
			success : function(result, request) {
				var jsonData = Ext.util.JSON.decode(result.responseText);
				if (jsonData.success == 'true') {
					Ext.Msg.show({title:'提示',msg:'数据上报成功!',buttons:Ext.Msg.OK,icon:Ext.MessageBox.INFO});
					scheme1Ds.load({params:{start:0,limit:schemePagingToolbar.pageSize,itemId:Ext.getCmp('itemField').getValue(),year:Ext.getCmp('yearField').getValue(),period:Ext.getCmp('periodField').getValue(),userCode:userCode}});
				} else {
					Ext.Msg.show({title:'提示',msg:'数据上报失败!',buttons:Ext.Msg.OK,icon:Ext.MessageBox.INFO});
				}
			},
			scope : this
		});
	}else{
		return;
	}
}

var scheme02Main = new Ext.grid.EditorGridPanel({
	title: '人员所属科室变动情况',
	region:'center',
	store: scheme02Ds,
	cm: inDeptsCm,
	trackMouseOver: true,
	stripeRows: true,
	clicksToEdit:1,
	sm: new Ext.grid.RowSelectionModel({singleSelect:true}),
	loadMask: true,
	//tbar:[yzButton,'-',upButton],
	bbar: scheme02PagingToolbar
});

function afterEdit(rowObj) {
	var obj = scheme1Main.getSelections();
	var upFlag = obj[0].get("upStatus");
	if(upFlag=="已上报"){
		Ext.Msg.show({title:'提示',msg:'已经上报的数据不允许被修改!',buttons:Ext.Msg.OK,icon:Ext.MessageBox.INFO});
		return;
	}else{

		var rowid = rowObj.record.get("rowid");
		var tzmoeny = rowObj.record.get("tzmoeny");
		var downmoeny = rowObj.record.get("downmoeny");
		Ext.Ajax.request({
			url:'../csp/dhc.bonus.bonusissexe.csp?action=update&rowid='+rowid+'&userCode='+userCode+'&tzmoeny='+tzmoeny+'&downmoeny='+downmoeny,
			failure : function(result, request) {
				Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons:Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
			},
			success : function(result, request) {
				var jsonData = Ext.util.JSON.decode(result.responseText);
				if (jsonData.success == 'true') {
					scheme02Ds.load({params:{start:0,limit:scheme02PagingToolbar.pageSize,parent:tmpSelectedScheme,itemId:itemDr,year:Ext.getCmp('yearField').getValue(),period:Ext.getCmp('periodField').getValue()}});
					this.store.commitChanges(); 
					var view = scheme02Main.getView();
				} else {
					Ext.Msg.show({title:'错误',msg:'失败',buttons:Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
				}
			},
			scope : this
		});
	}
}

scheme02Main.on("afteredit", afterEdit, scheme02Main);