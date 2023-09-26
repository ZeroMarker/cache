/**
  *name:tab of database
  *author:limingzhong
  *Date:2009-11-6
 */

function trim(str){
  var tmp=str.replace(/(^\s*)|(\s*$)/g, "");
  return tmp;
}

//配件数据源
var JXUnitAuditTabUrl = '../csp/dhc.pa.jxunitauditexe.csp';
var JXUnitAuditTabProxy= new Ext.data.HttpProxy({url:JXUnitAuditTabUrl + '?action=list'});
var JXUnitAuditTabDs = new Ext.data.Store({
	proxy: JXUnitAuditTabProxy,
    reader: new Ext.data.JsonReader({
        root: 'rows',
        totalProperty: 'results'
    }, [
		'rowid',
		'jxUnitDr',
		'jxUnitName',
		'userDr',
		'userName',
		'isRead',
		'isWrite'
	]),
    // turn on remote sorting
    remoteSort: true
});

//设置默认排序字段和排序方向
JXUnitAuditTabDs.setDefaultSort('rowid', 'desc');

//数据库数据模型
var JXUnitAuditTabCm = new Ext.grid.ColumnModel([
	 new Ext.grid.RowNumberer(),
	 {
		header: "用户名称",
		dataIndex: 'userName',
		width: 150,
		sortable: true
	},{
		header: "所属单元",
		dataIndex: 'jxUnitName',
		width: 150,
		sortable: true
	},{
		header:'读权限',
		align: 'center',
		width:120,
		sortable: true,
		dataIndex:'isRead',
		renderer : function(v, p, record){
			p.css += ' x-grid3-check-col-td';
			return '<div class="x-grid3-check-col'+(v=='Y'?'-on':'')+' x-grid3-cc-'+this.id+'">&#160;</div>';
		}
	},{
		header:'写权限',
		align: 'center',
		width:120,
		sortable: true,
		dataIndex:'isWrite',
		renderer : function(v, p, record){
			p.css += ' x-grid3-check-col-td';
			return '<div class="x-grid3-check-col'+(v=='Y'?'-on':'')+' x-grid3-cc-'+this.id+'">&#160;</div>';
		}
	}
]);

//初始化默认排序功能
JXUnitAuditTabCm.defaultSortable = true;

//添加按钮
var addButton = new Ext.Toolbar.Button({
	text: '添加',
    tooltip:'添加',        
    iconCls:'add',
	handler:function(){
		addFun(JXUnitAuditTabDs,JXUnitAuditTabPagingToolbar);
	}
});

//导入按钮
var editButton = new Ext.Toolbar.Button({
	text: '修改',
    tooltip:'修改',        
    iconCls:'add',
	handler:function(){
		editFun(JXUnitAuditTabDs,JXUnitAuditTab,JXUnitAuditTabPagingToolbar);
	}
});

var delButton  = new Ext.Toolbar.Button({
	text:'删除',
	tooltip:'删除',
	iconCls:'add',
	handler: function(){
		var rowObj = JXUnitAuditTab.getSelections();
		var len = rowObj.length;
		if(len < 1){
			Ext.Msg.show({title:'注意',msg:'请选择需要删除的基本数据!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			return false;
		}else{
			Ext.MessageBox.confirm('提示','确定要删除选定的行?',
				function(btn) {
					if(btn == 'yes'){
						Ext.Ajax.request({
							url:'../csp/dhc.pa.jxunitauditexe.csp?action=del&rowid='+rowObj[0].get("rowid"),
							waitMsg:'删除中...',
							failure: function(result, request) {
								Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							},
							success: function(result, request) {
								var jsonData = Ext.util.JSON.decode( result.responseText );
								if (jsonData.success=='true') {
									Ext.Msg.show({title:'注意',msg:'删除成功!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
									JXUnitAuditTabDs.load({params:{start:JXUnitAuditTabPagingToolbar.cursor, limit:JXUnitAuditTabPagingToolbar.pageSize,dir:'asc',sort:'rowid'}});
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
var JXUnitAuditSearchField ='jxUnitName';

//搜索过滤器
var JXUnitAuditFilterItem = new Ext.Toolbar.MenuButton({
	text: '过滤器',
	tooltip: '关键字所属类别',
	menu: {items: [
		new Ext.menu.CheckItem({ 
			text: '用户名称',
			value: 'userName',
			checked: false ,
			group: 'JXUnitAuditFilter',
			checkHandler: onJXUnitAuditItemCheck 
		}),
		new Ext.menu.CheckItem({ 
			text: '绩效单元',
			value: 'jxUnitName',
			checked: false,
			group: 'JXUnitAuditFilter',
			checkHandler: onJXUnitAuditItemCheck 
		})
	]}
});

//定义搜索响应函数
function onJXUnitAuditItemCheck(item, checked){
	if(checked) {
		JXUnitAuditSearchField = item.value;
		JXUnitAuditFilterItem.setText(item.text + ':');
	}
};

//查找按钮
var JXUnitAuditSearchBox = new Ext.form.TwinTriggerField({
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
			JXUnitAuditTabDs.proxy = new Ext.data.HttpProxy({url: JXUnitAuditTabUrl + '?action=list'});
			JXUnitAuditTabDs.load({params:{start:0, limit:JXUnitAuditTabPagingToolbar.pageSize}});
		}
	},
	onTrigger2Click: function() {
		if(this.getValue()) {
			JXUnitAuditTabDs.proxy = new Ext.data.HttpProxy({
				url: JXUnitAuditTabUrl + '?action=list&searchField=' + JXUnitAuditSearchField + '&searchValue=' + encodeURIComponent(this.getValue())});
	        	JXUnitAuditTabDs.load({params:{start:0, limit:JXUnitAuditTabPagingToolbar.pageSize}});
	    	}
	}
});

//分页工具栏
var JXUnitAuditTabPagingToolbar = new Ext.PagingToolbar({
    store: JXUnitAuditTabDs,
	pageSize:25,
    displayInfo: true,
    displayMsg: '第 {0} 条到 {1}条 ，一共 {2} 条',
    emptyMsg: "没有记录",
	buttons: ['-',JXUnitAuditFilterItem,'-',JXUnitAuditSearchBox],
	doLoad:function(C){
		var B={},
		A=this.paramNames;
		B[A.start]=C;
		B[A.limit]=this.pageSize;
		B['dir']="asc";
		B['sort']="rowid";
		if(this.fireEvent("beforechange",this,B)!==false){
			this.store.load({params:B});
		}
	}
});

//表格
var JXUnitAuditTab = new Ext.grid.GridPanel({
	title: '绩效单元权限设置管理',
	store: JXUnitAuditTabDs,
	cm: JXUnitAuditTabCm,
	trackMouseOver: true,
	stripeRows: true,
	sm: new Ext.grid.RowSelectionModel({singleSelect:true}),
	loadMask: true,
	tbar:[addButton,'-',editButton,'-',delButton],
	bbar:JXUnitAuditTabPagingToolbar
});

JXUnitAuditTabDs.load({params:{start:0, limit:JXUnitAuditTabPagingToolbar.pageSize,dir:'asc',sort:'rowid'}});
