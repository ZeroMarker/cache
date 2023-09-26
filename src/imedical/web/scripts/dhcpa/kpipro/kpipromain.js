/**
  *name:tab of database
  *author:wang ying
  *Date:2011-09-05
 */

function trim(str){
  var tmp=str.replace(/(^\s*)|(\s*$)/g, "");
  return tmp;
}
function toUTF8(a){
       var wch,x,uch="",szRet="";
       for (x=0; x<a.length; x++){
       wch=a.charCodeAt(x);
       if (!(wch & 0xFF80)){
       szRet += a.charAt(x);
       }
       else if (!(wch & 0xF000)){
       uch = "%" + (wch>>6 | 0xC0).toString(16) +
       "%" + (wch & 0x3F | 0x80).toString(16);
       szRet += uch;
       }
       else{
       uch = "%" + (wch >> 12 | 0xE0).toString(16) +
       "%" + (((wch >> 6) & 0x3F) | 0x80).toString(16) +
       "%" + (wch & 0x3F | 0x80).toString(16);
       szRet += uch;
       }
       }
       return(szRet);
       }
//配件数据源
var KPIProTabUrl = 'dhc.pa.kpiproexe.csp';
var KPIProTabProxy= new Ext.data.HttpProxy({url:KPIProTabUrl + '?action=list'});
var userCode=session['LOGON.USERCODE'];
var KPIProTabDs = new Ext.data.Store({
	proxy: KPIProTabProxy,
    reader: new Ext.data.JsonReader({
        root: 'rows',
        totalProperty: 'results'
    }, [
		'rowid',
		'KPIDr',
		'KPIName',
		'desc'
	]),
    // turn on remote sorting
    remoteSort: true
});

//设置默认排序字段和排序方向
KPIProTabDs.setDefaultSort('rowid', 'desc');

//数据库数据模型
var KPIProTabCm = new Ext.grid.ColumnModel([
	 new Ext.grid.RowNumberer(),
	 {
		header: "指标名称",
		dataIndex: 'KPIName',
		width: 150,
		sortable: true
	},{
		header: "描述",
		dataIndex: 'desc',
		width: 150,
		sortable: true
	}
]);

//初始化默认排序功能
KPIProTabCm.defaultSortable = true;

//添加按钮
var addButton = new Ext.Toolbar.Button({
	text: '添加',
    tooltip:'添加',        
    iconCls:'add',
	handler:function(){
		addFun(KPIProTabDs,KPIProTabPagingToolbar);
	}
});

//导入按钮
var editButton = new Ext.Toolbar.Button({
	text: '修改',
    tooltip:'修改',        
    iconCls:'add',
	handler:function(){
		editFun(KPIProTabDs,KPIProTab,KPIProTabPagingToolbar);
	}
});

var delButton  = new Ext.Toolbar.Button({
	text:'删除',
	tooltip:'删除',
	iconCls:'add',
	handler: function(){
		var rowObj = KPIProTab.getSelections();
		var len = rowObj.length;
		if(len < 1){
			Ext.Msg.show({title:'注意',msg:'请选择需要删除的基本数据!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			return false;
		}else{
			Ext.MessageBox.confirm('提示','确定要删除选定的行?',
				function(btn) {
					if(btn == 'yes'){
						Ext.Ajax.request({
							url:KPIProTabUrl+'?action=del&rowid='+rowObj[0].get("rowid"),
							waitMsg:'删除中...',
							failure: function(result, request) {
								Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							},
							success: function(result, request) {
								var jsonData = Ext.util.JSON.decode( result.responseText );
								if (jsonData.success=='true') {
									Ext.Msg.show({title:'注意',msg:'删除成功!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
									KPIProTabDs.load({params:{start:KPIProTabPagingToolbar.cursor, limit:KPIProTabPagingToolbar.pageSize,dir:'asc',sort:'rowid'}});
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
var KPIProSearchField ='jxUnitName';

//搜索过滤器
var KPIProFilterItem = new Ext.Toolbar.MenuButton({
	text: '过滤器',
	tooltip: '关键字所属类别',
	menu: {items: [
		new Ext.menu.CheckItem({ 
			text: '指标名称',
			value: 'KPIName',
			checked: true,
			group: 'KPIProFilter',
			checkHandler: onKPIProItemCheck 
		})
	]}
});

//定义搜索响应函数
function onKPIProItemCheck(item, checked){
	if(checked) {
		KPIProSearchField = item.value;
		KPIProFilterItem.setText(item.text + ':');
	}
};

//查找按钮
var KPIProSearchBox = new Ext.form.TwinTriggerField({
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
			KPIProTabDs.proxy = new Ext.data.HttpProxy({url: KPIProTabUrl + '?action=list'});
			KPIProTabDs.load({params:{start:0, limit:KPIProTabPagingToolbar.pageSize}});
		}
	},
	onTrigger2Click: function() {
		if(this.getValue()) {
			KPIProTabDs.proxy = new Ext.data.HttpProxy({
				url: KPIProTabUrl + '?action=list&searchField=' + KPIProSearchField + '&searchValue=' + this.getValue()});
	        	KPIProTabDs.load({params:{start:0, limit:KPIProTabPagingToolbar.pageSize}});
	    	}
	}
});

//分页工具栏
var KPIProTabPagingToolbar = new Ext.PagingToolbar({
    store: KPIProTabDs,
	pageSize:25,
    displayInfo: true,
    displayMsg: '第 {0} 条到 {1}条 ，一共 {2} 条',
    emptyMsg: "没有记录",
	buttons: ['-',KPIProFilterItem,'-',KPIProSearchBox],
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
var KPIProTab = new Ext.grid.GridPanel({
	title: '平均值指标管理',
	store: KPIProTabDs,
	cm: KPIProTabCm,
	trackMouseOver: true,
	stripeRows: true,
	sm: new Ext.grid.RowSelectionModel({singleSelect:true}),
	loadMask: true,
	tbar:[addButton,'-',editButton,'-',delButton],
	bbar:KPIProTabPagingToolbar
});

KPIProTabDs.load({params:{start:0, limit:KPIProTabPagingToolbar.pageSize,dir:'asc',sort:'rowid'}});
