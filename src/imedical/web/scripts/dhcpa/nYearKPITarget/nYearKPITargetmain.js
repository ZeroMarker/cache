/**
  *目标分类维护窗口
 */

function trim(str){
  var tmp=str.replace(/(^\s*)|(\s*$)/g, "");
  return tmp;
}

//配件数据源

var KPITargetUrl = '../csp/dhc.pa.nYearKPITargetexe.csp';
var KPITargetTabProxy= new Ext.data.HttpProxy({url:KPITargetUrl + '?action=list'});
var KPITargetTabDs = new Ext.data.Store({
	proxy: KPITargetTabProxy,
    reader: new Ext.data.JsonReader({
        root: 'rows',
        totalProperty: 'results'
    }, [
		'rowid',
		'kpiDr',
		'targetName',
		'targetCode',
		'coefficient',
		'changeNum'
	]),
    // turn on remote sorting
    remoteSort: true
});

//设置默认排序字段和排序方向
KPITargetTabDs.setDefaultSort('rowid', 'kpiDr');

//数据库数据模型
var KPITargetTabCm = new Ext.grid.ColumnModel([
	 new Ext.grid.RowNumberer(),
	 {
    	header: '指标名称',
        dataIndex: 'kpiDr',
        width: 200,
        sortable: true
    },{
        header: "目标类型名称",
        dataIndex: 'targetName',
        width: 100,
        align: 'left',
        sortable: true
    },{
        header: "目标类型的代码",
        dataIndex: 'targetCode',
        width: 100,
        align: 'center',
        sortable: true
    },{
        header: "年数",
        dataIndex: 'coefficient',
        width: 60,
        align: 'center',
        sortable: true
    },{
        header: "增减率",
        dataIndex: 'changeNum',
        width: 100,
        align: 'right',
        sortable: true
    }
]);
var KPIIndexProxy = new Ext.data.HttpProxy({url: 'dhc.pa.kpiindexexe.csp?action=kpi&start=0&limit=25'});	
	var KPIIndexDs = new Ext.data.Store({
			proxy:KPIIndexProxy,
			reader: new Ext.data.JsonReader({
			root: 'rows',
			totalProperty: 'results'
			}, [
            	'rowid','name'
 
			]),
    	remoteSort: true
	});
	KPIIndexDs.on('beforeload', function(ds, o){
		ds.proxy=new Ext.data.HttpProxy({url:'dhc.pa.kpiindexexe.csp?action=kpi&&start=0&limit=999&str='+encodeURIComponent(Ext.getCmp('unitField').getRawValue())});
	});
//初始化默认排序功能
KPITargetTabCm.defaultSortable = true;
//添加按钮
var addKPITarget = new Ext.Toolbar.Button({
	text: '添加目标',
    tooltip:'添加目标',        
    iconCls:'add',
	handler:function(){
		add();
	}
});

//修改按钮
var editKPITarget = new Ext.Toolbar.Button({
	text: '修改',
    tooltip:'修改',        
    iconCls:'add',
	handler:function(){
		edit();
	}
});

//删除按钮
var delKPITarget = new Ext.Toolbar.Button({
	text: '作废',
    tooltip:'作废',        
    iconCls:'add',
	handler:function(){
		//定义并初始化行对象
		//var rowObj=KPITargetTab.getSelections();
		var rowObj=KPITargetTab.getSelectionModel().getSelections();
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
			
					Ext.Ajax.request({
						url:'../csp/dhc.pa.nYearKPITargetexe.csp?action=del&rowid='+rowid,
						waitMsg:'删除中...',
						failure: function(result, request){
							Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
						},
						success: function(result, request){
							var jsonData = Ext.util.JSON.decode( result.responseText );
							if (jsonData.success=='true'){
								Ext.Msg.show({title:'注意',msg:'删除成功!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
								KPITargetTabDs.load({params:{start:0,limit:KPITargetTabPagingToolbar.pageSize}});
							}else{
								Ext.Msg.show({title:'错误',msg:'删除失败!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							}
						},
						scope: this
					});
				
			}else{
				return;
			}
		}
		Ext.MessageBox.confirm('提示','确实要删除该条记录吗?',handler);
	}
});
/*
//初始化搜索字段
var KPITargetSearchField ='name';

//搜索过滤器
var KPITargetFilterItem = new Ext.Toolbar.MenuButton({
	text: '过滤器',
	tooltip: '关键字所属类别',
	menu: {items: [
		new Ext.menu.CheckItem({ 
			text: '代码',
			value: 'code',
			checked: false ,
			group: 'KPITargetFilter',
			checkHandler: onKPITargetItemCheck 
		}),
		new Ext.menu.CheckItem({ 
			text: '名称',
			value: 'targetName',
			checked: false,
			group: 'KPITargetFilter',
			checkHandler: onKPITargetItemCheck 
		})/*,
		new Ext.menu.CheckItem({ 
			text: '应用系统类别',
			value: 'appSysName',
			checked: false,
			group: 'DimensTypeFilter',
			checkHandler: onDimensTypeItemCheck 
		})*/
/*	]}
});

//定义搜索响应函数
function onKPITargetItemCheck(item, checked){
	if(checked) {
		KPITargetSearchField = item.value;
		KPITargetFilterItem.setText(item.text + ':');
	}
};

//查找按钮
var KPITargetSearchBox = new Ext.form.TwinTriggerField({
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
			KPITargetTabDs.proxy = new Ext.data.HttpProxy({url: KPITargetUrl + '?action=list'});
			KPITargetTabDs.load({params:{start:0, limit:KPITargetTabPagingToolbar.pageSize}});
		}
	},
	onTrigger2Click: function() {
		if(this.getValue()) {
			KPITargetTabDs.proxy = new Ext.data.HttpProxy({
				url: KPITargetUrl + '?action=list&searchField=' + KPITargetSearchField + '&searchValue=' + this.getValue()});
	        	KPITargetTabDs.load({params:{start:0, limit:KPITargetTabPagingToolbar.pageSize}});
	    	}
	}
});
*/
//分页工具栏
var KPITargetTabPagingToolbar = new Ext.PagingToolbar({
    store: KPITargetTabDs,
	pageSize:25,
    displayInfo: true,
    displayMsg: '第 {0} 条到 {1}条 ，一共 {2} 条',
    emptyMsg: "没有记录"
	//buttons: ['-',KPITargetFilterItem,'-',KPITargetSearchBox]
});

//表格
var KPITargetTab = new Ext.grid.GridPanel({
	title: '目标分类维护窗口',
	store: KPITargetTabDs,
	cm: KPITargetTabCm,
	trackMouseOver: true,
	stripeRows: true,
	sm: new Ext.grid.RowSelectionModel({singleSelect:true}),
	loadMask: true,
	tbar:[addKPITarget,'-',editKPITarget,'-',delKPITarget],
	bbar:KPITargetTabPagingToolbar
});

//加载
KPITargetTabDs.load({params:{start:0, limit:KPITargetTabPagingToolbar.pageSize}});

/*
DimensTypeTab.on('contextmenu',function(e){
    if(!this.menu){
		this.menu = new Ext.menu.Menu({
			items:[
				{
					text: 'Add Product',
					handler: addProduct
				},{
					text: 'Edit Product(s)'
					//handler: editProduct
				},{
					text: 'Delete Product(s)'
					//handler: deleteProduct
				}
			]
		});
    }
	e.preventDefault(); 
    this.menu.showAt(e.getXY());
});
	
addProduct=function(){
	alert("你是天才!");
	edit();
}

*/
