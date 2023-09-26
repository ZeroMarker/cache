/**
  *name:schemaudit 
  *author:limingzhong
  *Date:2010-8-19
 */
//================去掉字符串空格==============================
function trim(str){
	var tmp=str.replace(/(^\s*)|(\s*$)/g, "");
	return tmp;
}
//============================================================

//================定义获取要操作节点的函数====================
//获取要操作的节点
var getNode = function(){
	return detailReport.getSelectionModel().getSelectedNode(); 
}
//============================================================

var schemDs = new Ext.data.Store({
	autoLoad:true,
	proxy:"",
	reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','parRef','code','name','shortcut','appSysDr','frequency','KPIDr','KPIName','desc','level','appSys','quency','shortCutFreQuency'])
});

schemDs.on('beforeload', function(ds, o){
	ds.proxy=new Ext.data.HttpProxy({
		url:'../csp/dhc.pa.disttargetexe.csp?action=schem&searchField=name&searchValue='+encodeURIComponent(Ext.getCmp('schemField').getRawValue())+'&active=Y',method:'POST'})
});
var schemField = new Ext.form.ComboBox({
	id:'schemField',
	fieldLabel:'当前方案',
	width:180,
	listWidth:200,
	selectOnFocus:true,
	allowBlank:false,
	store:schemDs,
	anchor:'90%',
	displayField:'shortCutFreQuency',
	valueField: 'rowid',
	triggerAction: 'all',
	emptyText:'选择当前方案...',
	editable:true,
	pageSize: 10,
	minChars: 1,
	selectOnFocus: true,
	forceSelection: true
});

schemField.on("select",function(cmb,rec,id){
	detailTreeLoader.load(detailTreeRoot,function(){
		detailTreeRoot.expand();
	});
});

//================定义工具栏以及添加、修改、删除按钮==========
//审核按钮
var auditButton=new Ext.Toolbar.Button({
	text:'审核',
	tooltip:'审核',
	iconCls: 'remove',
	handler:function(){
		function handler(id){
			if(id=="yes"){
				Ext.Ajax.request({
					url:'../csp/dhc.pa.schemauditexe.csp?action=audit',
					waitMsg:'审核中...',
					failure: function(result, request){
						Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
					},
					success: function(result, request){
						var jsonData = Ext.util.JSON.decode( result.responseText );
						if(jsonData.info=='NoCurrRecord'){
							Ext.Msg.show({title:'提示',msg:'没有当前战略,审核失败,程序终止!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
						}
						if(jsonData.info=='RepCurrRecord'){
							Ext.Msg.show({title:'提示',msg:'多个当前战略,审核失败,程序终止!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
						}
						if(jsonData.info=='false'){
							Ext.Msg.show({title:'提示',msg:'审核失败,数据已回滚!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
						}
						if(jsonData.info=='true'){
							Ext.Msg.show({title:'提示',msg:'审核成功!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
						}
					},
					scope: this
				});
			}else{
				return false;
			}
		}
		Ext.MessageBox.confirm('提示','确实要审核绩效方案吗?',handler);
	}
});

//工具栏
var menubar = ['绩效考核方案:',schemField,'-',auditButton];

//================定义ColumnTree的相关信息====================
var colObj=[
		{	
			header:'维度、指标、根名称',
			align: 'right',
			width:250,
			dataIndex:'name'
		},{
			header:'维度、指标、根代码',
			width:160,
			dataIndex:'code'
		},{
			header:'评测目标',
			align: 'right',
			width:100,
			dataIndex:'target'
		},{
			header:'计量单位',
			align:'right',
			width:100,
			dataIndex:'calUnitName'
		},{
			header:'评分方法',
			align: 'right',
			width:100,
			dataIndex:'scoreMethodName'
		},{
			header:'收集部门',
			align: 'right',
			width:100,
			dataIndex:'colDeptName'
		},{
			header:'计算公式',
			align: 'right',
			width:250,
			dataIndex:'expName'
		}
	];

//树型结构定义
var detailReport = new Ext.tree.ColumnTree({
	id:'detailReport',
	height:590,
    rootVisible:true,
    autoScroll:true,
    title:'绩效方案明细管理',
	columns:colObj,
    loader:detailTreeLoader,
    root:detailTreeRoot,
	listeners:{click:{fn:nodeClicked}}
});


function nodeClicked(node){
	//定义一个数组
	var oldArray=new Array();
	//获取列对象
	var cols=detailReport.columns;
	//操作列对象
	for(var i=0;i<cols.length;i++){
		//获取单列
		var colObj=detailReport.columns[i];
		//获取单列dataIndex
		var dataIndex=colObj.dataIndex;
		//获取该节点单列的原始值
		var colValue=node.attributes[dataIndex];
		//组合字符串
		var objStr=i+"^"+dataIndex+"^"+colValue;
		
		oldArray.push(objStr);
	}
}

/*
function nodeClicked(node){
	var methodCode=node.attributes.scoreMethodCode;
	if(methodCode!=""){
		//点击出节点信息
		var DetailsUrl = '../csp/dhc.pa.schemauditexe.csp';
		var DetailsProxy = new Ext.data.HttpProxy({url:DetailsUrl+'?action=jxunitmethoddetails'});
		var DetailsDs = new Ext.data.Store({
			proxy: DetailsProxy,
			reader: new Ext.data.JsonReader({
				root: 'rows',
				totalProperty: 'results'
			}, [
				'jxUnitDr',
				'jxUnitName',
				'extreMum',
				'extreMumName',
				'info'
			]),
			// turn on remote sorting
			remoteSort: true
		});

		//设置默认排序字段和排序方向
		//DetailsDs.setDefaultSort('AssLocDr', 'Desc');

		//明细数据模型
		var DetailsCm = new Ext.grid.ColumnModel([
			new Ext.grid.RowNumberer(),
			{
				header:"科室名称",
				dataIndex:'jxUnitName',
				width:100,
				align:'left',
				sortable:true
			},{
				header:"目标值",
				dataIndex:'extreMumName',
				width:100,
				align:'center',
				sortable:true
			},{
				header:"评价标准",
				dataIndex:'info',
				width:500,
				align:'center',
				sortable:true
			}
		]);

		//表格
		var BusItemDetails = new Ext.grid.GridPanel({
			store:DetailsDs,
			cm:DetailsCm,
			trackMouseOver:true,
			stripeRows:true,
			sm:new Ext.grid.RowSelectionModel({singleSelect:true}),
			loadMask:true
		});
	
		//定义并初始化叶子节点数据明细窗口
		var win = new Ext.Window({
			title:Ext.getCmp('schemField').getRawValue().split("!")[0]+'-评价标准',
			width:700,
			height:400,
			minWidth:700,
			minHeight:400,
			layout:'fit',
			plain:true,
			modal:true,
			bodyBorder:false, 
			buttonAlign:'center',
			border:false,
			items:BusItemDetails
		});
	
		//窗口显示
		win.show();
			
		DetailsDs.load();
	}else{
		Ext.Msg.show({title:'提示',msg:'非末级不能查看信息',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
		return false;
	}
}
*/
/*
//节点可编辑关键代码
var teEditor = new Ext.tree.ColumnTreeEditor(detailReport,{
    completeOnEnter:true,
    autosize:true,
    ignoreNoChange:true,
	expanded:true,
	grow:true, 
	listeners:{
		specialkey:function(field,e){
			if (e.getKey() == Ext.EventObject.ENTER){
				//alert(index);
				
				//获取节点
				var sm = detailReport.getSelectionModel();
				var node = sm.getSelectedNode();
				
				alert(this.editColIndex);
				
				//重新获取该单元格的值
				var newValue=teEditor.getValue();
				//var colsObj=detailReport.columns[i];
				//var dataIndex=colsObj.dataIndex;
				
				
				var cols=detailReport.columns;
				//操作列对象
				for(var i=0;i<cols.length;i++){
					//获取单列
					var colObj=detailReport.columns[i];
					
					
					//获取单列dataIndex
					var dataIndex=colObj.dataIndex;
					//获取该节点单列的原始值
					var colValue=node.attributes[dataIndex];
					//组合字符串
					var objStr=i+"^"+dataIndex+"^"+colValue;
				}
				
			}
		}
	}
});
*/

