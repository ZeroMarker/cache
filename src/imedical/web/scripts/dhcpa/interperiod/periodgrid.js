var periodUrl = '../csp/dhc.pa.interperiodexe.csp';
var periodProxy = new Ext.data.HttpProxy({url:periodUrl + '?action=list'});

var locSetDs = new Ext.data.Store({
	autoLoad:true,
	proxy:"",
	reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','name'])
});

locSetDs.on('beforeload', function(ds, o){
	ds.proxy=new Ext.data.HttpProxy({
		url:'../csp/dhc.pa.interperiodexe.csp?action=locset&start=0&limit='+periodPagingToolbar.pageSize+'&str='+encodeURIComponent(Ext.getCmp('locSetField').getRawValue()),method:'POST'})
});

var locSetField = new Ext.form.ComboBox({
	id: 'locSetField',
	fieldLabel:'接口套',
	width:200,
	listWidth : 200,
	allowBlank: false,
	store: locSetDs,
	valueField: 'rowid',
	displayField: 'name',
	triggerAction: 'all',
	emptyText:'请选择接口套...',
	name:'locSetField',
	minChars:1,
	pageSize:10,
	selectOnFocus:true,
	forceSelection:'true',
	editable:true
});
		
locSetField.on("select",function(cmb,rec,id){
	periodDs.load({params:{start:0,limit:periodPagingToolbar.pageSize,locSetDr:cmb.getValue()}});
});

//数据源
var periodDs = new Ext.data.Store({
	proxy: periodProxy,
	reader: new Ext.data.JsonReader({
		root: 'rows',
		totalProperty: 'results'
	}, [
		'rowid',
		'period',
		'periodType',
		'periodTypeName',
		'locSetDr',
		'locSetName',
		'quote',
		'quoteName',
		'startDate',
		'endDate',
		'remark',
		'active',
		'corrType',
		'corrTypeName'
	]),
	remoteSort: true
});

periodDs.setDefaultSort('rowid', 'asc');

var periodCm = new Ext.grid.ColumnModel([
	new Ext.grid.RowNumberer(),
	{
		header: '绩效期间',
		dataIndex: 'period',
		width: 40,
		align: 'left',
		sortable: true
	},{
		header: '期间类型',
		dataIndex: 'periodTypeName',
		width: 40,
		align: 'left',
		sortable: true
	},{
		header: '所属套名称',
		dataIndex: 'locSetName',
		width: 60,
		align: 'left',
		sortable: true
	},{
		header:'对照类型',
		dataIndex:'corrTypeName',
		align:'center',
		width:60,
		sortable:true
	},{
		header:'引用期间',
		dataIndex:'quoteName',
		align:'center',
		width:300,
		sortable:true
	},{
		header: '起始日期',
		dataIndex: 'startDate',
		width: 50,
		sortable: true
	},{
		header: '结束日期',
		dataIndex: 'endDate',
		width: 50,
		sortable: true
	},{
		header: "备注",
		dataIndex: 'remark',
		width: 60,
		align: 'center',
		sortable: true
	},{
		header: "有效标志",
		dataIndex: 'active',
		width: 50,
		align: 'center',
		sortable: true,
		renderer : function(v, p, record){
			p.css += ' x-grid3-check-col-td';
			return '<div class="x-grid3-check-col'+(v=='Y'?'-on':'')+' x-grid3-cc-'+this.id+'">&#160;</div>';
		}
	}
]);

//添加按钮
var add = new Ext.Toolbar.Button({
	text: '添加',
    tooltip:'添加绩效期间',        
    iconCls:'add',
	handler:function(){
		if(Ext.getCmp('locSetField').getValue()!=""){
			addFun(locSetField,PeriodGrid,periodDs,periodPagingToolbar);
		}else{
			Ext.Msg.show({title:'提示',msg:'请选择接口套!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
			return false;
		}
	}
});

//修改按钮
var edit = new Ext.Toolbar.Button({
	text: '修改',
    tooltip:'修改绩效期间',        
    iconCls:'edit',
	handler:function(){
		if(Ext.getCmp('locSetField').getValue()!=""){
			editFun(locSetField,PeriodGrid,periodDs,periodPagingToolbar);
		}else{
			Ext.Msg.show({title:'提示',msg:'请选择接口套!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
			return false;
		}
	}
});

//删除按钮
var del = new Ext.Toolbar.Button({
	text: '删除',
    tooltip:'删除绩效期间',        
    iconCls:'remove',
	handler:function(){
		//定义并初始化行对象
		var rowObj=PeriodGrid.getSelections();
		//定义并初始化行对象长度变量
		var len = rowObj.length;
		//判断是否选择了要修改的数据
		if(len < 1){
			Ext.Msg.show({title:'注意',msg:'请选择需要删除的数据!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			return;
		}else{
			var rowid = rowObj[0].get("rowid");
		}
		function handler(id){
			if(id=="yes"){
				var active = rowObj[0].get("active");
				//判断是否是内置数据,如果是则不允许删除,否则可以被删除
				if(active=="Y"||active=="Yes"||active=="y"||active=="yes"){
					Ext.Msg.show({title:'注意',msg:'有效数据,不允许被删除!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
				}else{
					Ext.Ajax.request({
						url:'../csp/dhc.pa.interperiodexe.csp?action=del&rowid='+rowid,
						waitMsg:'删除中...',
						failure: function(result, request){
							Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
						},
						success: function(result, request){
							var jsonData = Ext.util.JSON.decode( result.responseText );
							if (jsonData.success=='true'){
								Ext.Msg.show({title:'提示',msg:'删除成功!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
								periodDs.load({params:{start:0,limit:periodPagingToolbar.pageSize,locSetDr:Ext.getCmp('locSetField').getValue()}});
							}else{
								Ext.Msg.show({title:'提示',msg:'删除失败!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
							}
						},
						scope: this
					});
				}
			}else{
				return;
			}
		}
		Ext.MessageBox.confirm('提示','确实要删除该条记录吗?',handler);
	}
});
//************生成本年期间********************
	//月期间
	var MBtn = {
		text: '月期间',
		iconCls:'add',
		id:'MBtn',
		handler:function(){
			var locSetFieldValue=Ext.getCmp('locSetField').getValue();
			if(locSetFieldValue!=""){
				autoPeriod(locSetFieldValue,"M","月",periodDs,periodPagingToolbar);
			}else{
				Ext.Msg.show({title:'提示',msg:'请选择接口套!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
				return false;
			}
		}
	}; 
	//季度期间
	var QBtn = {
		text: '季度期间',
		iconCls:'add',
		id:'QBtn',
		handler:function(){
			var locSetFieldValue=Ext.getCmp('locSetField').getValue();
			if(locSetFieldValue!=""){
				autoPeriod(locSetFieldValue,"Q","季度",periodDs,periodPagingToolbar);
			}else{
				Ext.Msg.show({title:'提示',msg:'请选择接口套!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
				return false;
			}
		}
	}; 
	//半年期间
	var HBtn = {
		text: '半年期间',
		iconCls:'add',
		id:'HBtn',
		handler:function(){
			var locSetFieldValue=Ext.getCmp('locSetField').getValue();
			if(locSetFieldValue!=""){
				autoPeriod(locSetFieldValue,"H","半年",periodDs,periodPagingToolbar);
			}else{
				Ext.Msg.show({title:'提示',msg:'请选择接口套!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
				return false;
			}
		}
	}; 
	//年期间
	var YBtn = {
		text: '年期间',
		iconCls:'add',
		id:'YBtn',
		handler:function(){
			var locSetFieldValue=Ext.getCmp('locSetField').getValue();
			if(locSetFieldValue!=""){
				autoPeriod(locSetFieldValue,"Y","全年",periodDs,periodPagingToolbar);
			}else{
				Ext.Msg.show({title:'提示',msg:'请选择接口套!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
				return false;
			}
		}
	}; 
	var addMenuI = new Ext.menu.Menu({
		id: 'addMenu',
		items: [MBtn,QBtn,HBtn,YBtn] //initButton,  
	});
	var addMenu = new Ext.Toolbar([{
		text: '生成本年度期间',
		iconCls:'option',
		menu: addMenuI
	}]);
	//初始化搜索字段
var PeriodSearchField ='period';

//搜索过滤器
var PeriodFilterItem = new Ext.Toolbar.MenuButton({
	text: '过滤器',
	tooltip: '关键字所属类别',
	menu: {items: [
		new Ext.menu.CheckItem({ 
			text: '绩效期间',
			value: 'period',
			checked: false ,
			group: 'InterLocSetFilter',
			checkHandler: onPeriodItemCheck 
		}),
		new Ext.menu.CheckItem({ 
			text: '期间类别',
			value: 'periodTypeName',
			checked: false,
			group: 'InterLocSetFilter',
			checkHandler: onPeriodItemCheck 
		})
	]}
});


//定义搜索响应函数
function onPeriodItemCheck(item, checked){
	if(checked) {
		PeriodSearchField = item.value;
		PeriodFilterItem.setText(item.text + ':');
	}
};

//查找按钮
var PeriodSearchBox = new Ext.form.TwinTriggerField({
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
			periodDs.proxy = new Ext.data.HttpProxy({url: periodUrl + '?action=list&locSetDr='+Ext.getCmp('locSetField').getValue()});
			periodDs.load({params:{start:0, limit:periodPagingToolbar.pageSize}});
		}
	},
	onTrigger2Click: function() {
		if(this.getValue()) {
			periodDs.proxy = new Ext.data.HttpProxy({
				url: periodUrl + '?action=list&searchField=' + PeriodSearchField + '&searchValue=' + encodeURIComponent(this.getValue())+'&locSetDr='+Ext.getCmp('locSetField').getValue()});
	        	periodDs.load({params:{start:0, limit:periodPagingToolbar.pageSize}});
	    	}
	}
});

var periodPagingToolbar = new Ext.PagingToolbar({//分页工具栏
	pageSize:25,
	store: periodDs,
	displayInfo: true,
	displayMsg: '当前显示{0} - {1}，共计{2}',
	emptyMsg: "没有数据",
	buttons:['-',PeriodFilterItem,'-',PeriodSearchBox],
	doLoad:function(C){
		var B={},
		A=this.paramNames;
		B[A.start]=C;
		B[A.limit]=this.pageSize;
		B['locSetDr']=Ext.getCmp('locSetField').getValue();
		B['dir']="asc";
		B['sort']="rowid";
		if(this.fireEvent("beforechange",this,B)!==false){
			this.store.load({params:B});
		}
	
	}
});

var PeriodGrid = new Ext.grid.GridPanel({//表格
	region: 'center',
	width: 400,
	minSize: 350,
	maxSize: 450,
	split: true,
	collapsible: true,
	containerScroll: true,
	xtype: 'grid',
	store: periodDs,
	cm: periodCm,
	trackMouseOver: true,
	stripeRows: true,
	sm: new Ext.grid.RowSelectionModel({singleSelect:true}),
	loadMask: true,
	viewConfig: {forceFit:true},
	tbar: ['接口套:',locSetField,'-',add,'-',edit,'-',del,'-',addMenu],
	bbar: periodPagingToolbar
	
});


