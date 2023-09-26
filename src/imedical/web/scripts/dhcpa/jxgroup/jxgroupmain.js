/**
  *name:tab of jxgroup
  *author:limingzhong
  *Date:2010-8-5
 */
//=============定义部分全局变量======================
var deptIDStr=""; //用于存储
var deptNameStr=""; //用于显示
var KPIDrStr=""; //用于存储
var KPINameStr=""; //用于显示
var IDSet=""; //ID字符串
//===================================================
function trim(str){
  var tmp=str.replace(/(^\s*)|(\s*$)/g, "");
  return tmp;
}

var typeDs = new Ext.data.SimpleStore({
	fields: ['key','keyValue'],
	data : [['1','1-指标'],['2','2-绩效单元']]
});
var typeField = new Ext.form.ComboBox({
	id: 'typeField',
	fieldLabel: '分组类别',
	listWidth : 230,
	selectOnFocus: true,
	allowBlank: false,
	store: typeDs,
	anchor: '90%',
	displayField: 'keyValue',
	valueField: 'key',
	triggerAction: 'all',
	emptyText:'选择分组类别...',
	mode: 'local', //本地模式
	editable:false,
	pageSize: 10,
	minChars: 1,
	selectOnFocus: true,
	forceSelection: true
});

typeField.on("select",function(cmb,rec,id){
	JXGroupTabDs.load({params:{start:0, limit:JXGroupTabPagingToolbar.pageSize,type:cmb.getValue()}});
});

var find = new Ext.Toolbar.Button({
	text: '查询',
    tooltip:'查询',        
    iconCls:'add',
	handler:function(){
		var type=Ext.getCmp('typeField').getValue();
		JXGroupTabDs.load({params:{start:0, limit:JXGroupTabPagingToolbar.pageSize,type:type}});
	}
});

//配件数据源
var JXGroupTabUrl = '../csp/dhc.pa.jxgroupexe.csp';
var JXGroupTabProxy= new Ext.data.HttpProxy({url:JXGroupTabUrl + '?action=list'});
var JXGroupTabDs = new Ext.data.Store({
	proxy: JXGroupTabProxy,
    reader: new Ext.data.JsonReader({
        root: 'rows',
        totalProperty: 'results'
    }, [
		'rowid',
		'code',
		'name',
		'IDSet',
		'NameStr',
		'isInput',
		'type',
		'typeName',
		'desc'
	]),
    // turn on remote sorting
    remoteSort: true
});

//设置默认排序字段和排序方向
JXGroupTabDs.setDefaultSort('rowid', 'desc');

//数据库数据模型
var JXGroupTabCm = new Ext.grid.ColumnModel([
	 new Ext.grid.RowNumberer(),
	 {
    	header: '分组代码',
        dataIndex: 'code',
        width: 80,
        sortable: true
    },{
        header: "分组名称",
        dataIndex: 'name',
        width: 80,
        align: 'left',
        sortable: true
    },{
        header: "所含指标或绩效单元",
        dataIndex: 'NameStr',
        width: 600,
        align: 'left',
        sortable: true
    },{
        header: "是否录入",
        dataIndex: 'isInput',
        width: 80,
        align: 'left',
        sortable: true
    },{
        header: "分组类别",
        dataIndex: 'typeName',
        width: 80,
        align: 'left',
        sortable: true
    },{
        header:'描述',
		width:120,
		dataIndex:'desc',
		sortable: true
    }
]);

//初始化默认排序功能
JXGroupTabCm.defaultSortable = true;

//添加按钮
var addJXGroup = new Ext.Toolbar.Button({
	text: '添加分组',
    tooltip:'添加分组',        
    iconCls:'add',
	handler:function(){
		var type=Ext.getCmp('typeField').getValue();
		addFun(type,JXGroupTabDs,JXGroupTabPagingToolbar);
	}
});

//修改按钮
var editJXGroup = new Ext.Toolbar.Button({
	text: '修改分组',
    tooltip:'修改分组',        
    iconCls:'add',
	handler:function(){
		var type=Ext.getCmp('typeField').getValue();
		editFun(type,JXGroupTabDs,JXGroupTab,JXGroupTabPagingToolbar);
	}
});

//删除按钮
var delJXGroup = new Ext.Toolbar.Button({
	text: '删除分组',
    tooltip:'删除分组',        
    iconCls:'add',
	handler:function(){
		var type=Ext.getCmp('typeField').getValue();
		//定义并初始化行对象
		var rowObj=JXGroupTab.getSelections();
		//定义并初始化行对象长度变量
		var len = rowObj.length;
		//判断是否选择了要修改的数据
		if(len < 1){
			Ext.Msg.show({title:'注意',msg:'请选择需要删除的数据!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			return false;
		}else{
			var rowid = rowObj[0].get("rowid");
		}
		function handler(id){
			if(id=="yes"){
				Ext.Ajax.request({
					url:'../csp/dhc.pa.jxgroupexe.csp?action=del&rowid='+rowid,
					waitMsg:'删除中...',
					failure: function(result, request){
						Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
					},
					success: function(result, request){
						var jsonData = Ext.util.JSON.decode( result.responseText );
						if (jsonData.success=='true'){
							Ext.Msg.show({title:'提示',msg:'删除成功!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
							JXGroupTabDs.load({params:{start:0,limit:JXGroupTabPagingToolbar.pageSize,type:type}});
						}else{
							Ext.Msg.show({title:'错误',msg:'删除失败!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
						}
					},
					scope: this
				});
			}
		}
		Ext.MessageBox.confirm('提示','确实要删除该条记录吗?',handler);
	}
});

//初始化搜索字段
var JXGroupSearchField ='name';

//搜索过滤器
var JXGroupFilterItem = new Ext.Toolbar.MenuButton({
	text: '过滤器',
	tooltip: '关键字所属类别',
	menu: {items: [
		new Ext.menu.CheckItem({ 
			text: '代码',
			value: 'code',
			checked: false ,
			group: 'JXGroupFilter',
			checkHandler: onJXGroupItemCheck 
		}),
		new Ext.menu.CheckItem({ 
			text: '名称',
			value: 'name',
			checked: false,
			group: 'JXGroupFilter',
			checkHandler: onJXGroupItemCheck 
		}),
		new Ext.menu.CheckItem({ 
			text: '分组类别',
			value: 'typeName',
			checked: false,
			group: 'JXGroupFilter',
			checkHandler: onJXGroupItemCheck 
		})
	]}
});

//定义搜索响应函数
function onJXGroupItemCheck(item, checked){
	if(checked) {
		JXGroupSearchField = item.value;
		JXGroupFilterItem.setText(item.text + ':');
	}
};

//查找按钮
var JXGroupSearchBox = new Ext.form.TwinTriggerField({
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
			var type=Ext.getCmp('typeField').getValue();			
			JXGroupTabDs.proxy = new Ext.data.HttpProxy({url: JXGroupTabUrl + '?action=list'});
			JXGroupTabDs.load({params:{start:0, limit:JXGroupTabPagingToolbar.pageSize,type:type}});
		}
	},
	onTrigger2Click: function() {
		if(this.getValue()) {
			var type=Ext.getCmp('typeField').getValue();
			JXGroupTabDs.proxy = new Ext.data.HttpProxy({
				url: JXGroupTabUrl + '?action=list&searchField=' + JXGroupSearchField + '&searchValue=' + this.getValue()});
	        	JXGroupTabDs.load({params:{start:0, limit:JXGroupTabPagingToolbar.pageSize,type:type}});
	    	}
	}
});

//分页工具栏
var JXGroupTabPagingToolbar = new Ext.PagingToolbar({
    store: JXGroupTabDs,
	pageSize:25,
    displayInfo: true,
    displayMsg: '第 {0} 条到 {1}条 ，一共 {2} 条',
    emptyMsg: "没有记录",
	buttons: ['-',JXGroupFilterItem,'-',JXGroupSearchBox]
});

//表格
var JXGroupTab = new Ext.grid.GridPanel({
	title: '显示分组维护',
	store: JXGroupTabDs,
	cm: JXGroupTabCm,
	trackMouseOver: true,
	stripeRows: true,
	sm: new Ext.grid.RowSelectionModel({singleSelect:true}),
	loadMask: true,
	tbar:['分组类别:',typeField,'-',find,'-',addJXGroup,'-',editJXGroup,'-',delJXGroup],
	bbar:JXGroupTabPagingToolbar
});

