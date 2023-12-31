var schemUrl = '../csp/dhc.pa.deptschemexe.csp';
var schemProxy = new Ext.data.HttpProxy({url:schemUrl + '?action=schemlist'});

var periodTypeStore = new Ext.data.SimpleStore({
	fields: ['key','keyValue'],
	data : [['M','M-月'],['Q','Q-季'],['H','H-半年'],['Y','Y-年']]
});
var periodTypeField = new Ext.form.ComboBox({
	id: 'periodTypeField',
	fieldLabel: '期间类型',
	width:210,
	listWidth : 210,
	selectOnFocus: true,
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
	pageSize: 10,
	minChars: 1,
	selectOnFocus: true,
	forceSelection: true
});

periodTypeField.on("select",function(cmb,rec,id){
	schemDs.load({params:{start:0, limit:schemPagingToolbar.pageSize,active:'Y',period:Ext.getCmp('periodTypeField').getValue(),dir:'asc',sort:'rowid'}});
});

//业务类别数据源
var schemDs = new Ext.data.Store({
	proxy: schemProxy,
	reader: new Ext.data.JsonReader({
		root: 'rows',
		totalProperty: 'results'
	}, [
		'rowid',
		'parRef',
		'code',
		'name',
		'shortcut',
		'appSysDr',
		'frequency',
		'KPIDr',
		'KPIName',
		'desc',
		'level',
		'appSys',
		'quency'
	]),
	remoteSort: true
});

schemDs.setDefaultSort('rowid', 'desc');

var schemCm = new Ext.grid.ColumnModel([
	new Ext.grid.RowNumberer(),
	{
		header: '方案代码',
		dataIndex: 'code',
		width: 100,
		sortable: true
	},{
		header: "方案名称",
		dataIndex: 'name',
		width: 180,
		align: 'left',
		sortable: true
	},{
		header: "考核期间",
		dataIndex: 'frequency',
		width: 90,
		align: 'left',
		sortable: true
	}/*,{
		header: "方案明细",
		dataIndex: '',
		width: 90,
		align: 'left',
		sortable: true,
		renderer : function(v, p, record){
			return '<font color=blue>明细</font>';
		}
	}*/
]);

//按钮
var findButton = new Ext.Toolbar.Button({
	text: '查询明细',
    tooltip:'查询明细',        
    iconCls:'remove',
	handler:function(){
		var rowObj = SchemGrid.getSelections();
		var len = rowObj.length;
		if(len < 1){
			Ext.Msg.show({title:'注意',msg:'请选择方案数据!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			return false;
		}else{
			var schemDr=rowObj[0].get('rowid');
			//弹出窗口
			var detailTreeLoader = new Ext.tree.TreeLoader({
				dataUrl:'../scripts/ext2/cost/report/test11.csp',
				clearOnLoad:true,
				uiProviders:{
					'col': Ext.tree.ColumnNodeUI
				}
			});
			//加载前事件
			detailTreeLoader.on('beforeload', function(detailTreeLoader,node){
				if(detailTreeRoot.value!="undefined"){
					var url="../csp/dhc.pa.deptschemexe.csp?action=schemdetaillist";
					detailTreeLoader.dataUrl=url+"&parent="+node.id+"&schemDr="+schemDr;
				}
			});
			//树形结构的根
			var detailTreeRoot = new Ext.tree.AsyncTreeNode({
				id:'roo',
				text:'方案明细管理',
				value:'',
				expanded:false
			});

			//树型结构定义
			var detailReport = new Ext.tree.ColumnTree({
				id:'detailReport',
				height:590,
				rootVisible:true,
				autoScroll:true,
				columns:[
					{
						header:'维度、指标、根名称',
						align: 'right',
						width:200,
						dataIndex:'name'
					},{
						header:'维度、指标、根代码',
						width:140,
						dataIndex:'code'
					},{
						header:'计量单位',
						align: 'right',
						width:80,
						dataIndex:'calUnitName'
					},{
						header:'考核方法',
						align: 'right',
						width:80,
						dataIndex:'scoreMethodName'
					},{
						header:'收集部门',
						align: 'right',
						width:80,
						dataIndex:'colDeptName'
					},{
						header:'极值',
						align: 'right',
						width:80,
						dataIndex:'extreMumName'
					},{
						header:'评测目标',
						align: 'right',
						width:120,
						dataIndex:'target'
					}
				],
				loader:detailTreeLoader,
				root:detailTreeRoot
			});
			//=================窗口================
			var window = new Ext.Window({
				title: '查询方案明细',
				width: 800,
				height:400,
				layout: 'fit',
				plain:true,
				modal:true,
				buttonAlign:'center',
				bodyBorder:false, 
				border:false,
				items: detailReport,
				buttons: [{
					text: '关闭',
					handler: function(){window.close();}
				}]
			});
			window.show();
		}
	}
});

var schemPagingToolbar = new Ext.PagingToolbar({//分页工具栏
	pageSize:25,
	store: schemDs,
	displayInfo: true,
	displayMsg: '当前显示{0} - {1}，共计{2}',
	emptyMsg: "没有数据",
	doLoad:function(C){
		var B={},
		A=this.paramNames;
		B[A.start]=C;
		B[A.limit]=this.pageSize;
		B['period']=Ext.getCmp('periodTypeField').getValue();
		B['dir']="asc";
		B['sort']="rowid";
		if(this.fireEvent("beforechange",this,B)!==false){
			this.store.load({params:B});
		}
	}
});

var SchemGrid = new Ext.grid.GridPanel({//表格
	title: '绩效方案记录',
	region: 'west',
	width: 400,
	minSize: 350,
	maxSize: 450,
	split: true,
	collapsible: true,
	containerScroll: true,
	xtype: 'grid',
	store: schemDs,
	cm: schemCm,
	trackMouseOver: true,
	stripeRows: true,
	sm: new Ext.grid.RowSelectionModel({singleSelect:true}),
	loadMask: true,
	viewConfig: {forceFit:true},
	tbar: ['考核期间类型:',periodTypeField,'-',findButton],
	bbar: schemPagingToolbar
});

var schemRowId = "";
var schemName = "";

SchemGrid.on('rowclick',function(grid,rowIndex,e){
	//单击绩效方案后刷新绩效单元
	var selectedRow = schemDs.data.items[rowIndex];

	schemRowId = selectedRow.data["rowid"];
	schemName = selectedRow.data["name"];
	jxUnitGrid.setTitle(schemName+"-所对应绩效单元信息");
	jxUnitDs.proxy = new Ext.data.HttpProxy({url:jxUnitUrl+'?action=jxunitlist&schemDr='+schemRowId+'&sort=rowid&dir=DESC'});
	jxUnitDs.load({params:{start:0, limit:jxUnitPagingToolbar.pageSize}});
});

schemDs.on("beforeload",function(ds){
	jxUnitDs.removeAll();
	schemRowId = "";
	jxUnitGrid.setTitle("绩效单元信息");
});
	