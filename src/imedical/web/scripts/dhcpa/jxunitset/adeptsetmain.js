function trim(str){
  var tmp=str.replace(/(^\s*)|(\s*$)/g, "");
  return tmp;
}

var locDr;
var owenr;
var parent;
var repdr;
var leaf;
var deptSetUrl = 'dhc.nca.adeptsetexe.csp';
var deptSetProxy=new Ext.data.HttpProxy({url:deptSetUrl});
var deptSetDs = new Ext.data.Store({
	proxy: deptSetProxy,
	reader: new Ext.data.JsonReader({
		root: 'rows',
		totalProperty: 'results'
	}, [
		'rowid',
		'code',
		'name',
		'py',
		'shortcut',
		'remark',
		'end',
		'parent',
		'order',
		'col',
		'flag'
	]),
	remoteSort: true
});

deptSetDs.setDefaultSort('order', 'asc');
var deptSetCm = new Ext.grid.ColumnModel([
	new Ext.grid.RowNumberer(),
	{
		header: '代码',
		dataIndex: 'code',
		width: 60,
		sortable: true
	},{
		header: "名称",
		dataIndex: 'name',
		width: 80,
		sortable: true
	},{
		header: "顺序",
		dataIndex: 'order',
		width: 60,
		sortable: true
	},{
		header: "拼音",
		dataIndex: 'py',
		width: 80,
		sortable: true
	},{
		header: "备注",
		dataIndex: 'remark',
		width: 80,
		sortable: true
	},{
		header: "末端标志",
		dataIndex: 'end',
		width: 60,
		sortable: true,
		renderer : function(v, p, record){
			p.css += ' x-grid3-check-col-td';
			return '<div class="x-grid3-check-col'+(v=='Y'?'-on':'')+' x-grid3-cc-'+this.id+'">&#160;</div>';
		}
	}
]);

var addButton = new Ext.Toolbar.Button({
	text: '添加',
	tooltip: '添加',
	iconCls: 'add',
	handler: function(){
        //获取树节点的属性并判断该树节点是否是末端节点(根节点除外)
        var node = Ext.getCmp('detailReport').getSelectionModel().getSelectedNode();
		if(node==null){
            Ext.Msg.show({title:'提示',msg:'请选择树结构中的分层套!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
            return;
        }
        var nodeId = node.id;
        if(nodeId.split("||").length>1){
            Ext.Msg.show({title:'提示',msg:'你选择的是科室，请选择分层套再添加分层套!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
            return;
        }
        var parentId = nodeId;
        if(parentId=="roo") parentId=0;
        if(nodeId=="roo"){
            //可以添加
            addFun(parentId,deptSetDs,deptSetPagingToolbar);
        }else{
            var isEnd = node.attributes.end;
            if(isEnd=="N"){
                //可以添加
                addFun(parentId,deptSetDs,deptSetPagingToolbar);
            }else{
                //提示：末端节点不可以再添加
                Ext.Msg.show({title:'提示',msg:'末端节点，不可以添加部门分层套!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
            }
        }
	}
});

var editButton  = new Ext.Toolbar.Button({
	text: '修改',
	tooltip: '修改',
    iconCls: 'add',
	handler: function(){
		editFun(deptSetDs,deptSetGrid,deptSetPagingToolbar);
	}
});

var delButton = new Ext.Toolbar.Button({
	text: '删除',
	tooltip: '删除',
	iconCls: 'add',
	handler: function(){
        delFun(deptSetDs,deptSetGrid,deptSetPagingToolbar);
	}
});

var deptManagerButton  = new Ext.Toolbar.Button({
	text: '部门管理',
	tooltip: '部门管理',
	iconCls: 'add',
	handler: function(){
		deptManagerFun(deptSetDs,deptSetGrid,deptSetPagingToolbar);
	}
});

var deptSetSearchField = 'name';

var deptSetFilterItem = new Ext.SplitButton({
		text: '过滤器',
		tooltip: '关键字所属类别',
		menu: {items: [
				new Ext.menu.CheckItem({ text: '代码',value: 'code',checked: false,group: 'DeptSetsFilter',checkHandler: onDeptSetCheck }),
				new Ext.menu.CheckItem({ text: '名称',value: 'name',checked: true,group: 'DeptSetsFilter',checkHandler: onDeptSetCheck })
		]}
});

function onDeptSetCheck(item, checked){
	if(checked) {
		deptSetSearchField = item.value;
		deptSetFilterItem.setText(item.text + ':');
	}
};

var deptSetSearchBox = new Ext.form.TwinTriggerField({
	width: 180,
	trigger1Class: 'x-form-clear-trigger',
	trigger2Class: 'x-form-search-trigger',
	emptyText:'搜索...',
	listeners: {
		specialkey: {fn:function(field, e) {
			var key = e.getKey();
		if(e.ENTER === key) {this.onTrigger2Click();}}}
	},
	grid: this,
	onTrigger1Click: function() {
		if(this.getValue()) {
			this.setValue('');
			deptSetDs.proxy = new Ext.data.HttpProxy({url: deptSetUrl});
			deptSetDs.load({params:{start:0, limit:deptSetPagingToolbar.pageSize,parent:parent,type:type,active:"",action:'gridlist',dir:'asc',sort:'order'}});
		}
	},
	onTrigger2Click: function() {
		if(this.getValue()) {
			deptSetDs.proxy = new Ext.data.HttpProxy({
			url: deptSetUrl + '?&searchField=' + deptSetSearchField + '&searchValue=' + this.getValue()});
			deptSetDs.load({params:{start:0, limit:deptSetPagingToolbar.pageSize,parent:parent,type:type,active:"",action:'gridlist',dir:'asc',sort:'order'}});
		}
	}
});


var deptSetPagingToolbar = new Ext.PagingToolbar({
	pageSize:25,
	store: deptSetDs,
	displayInfo: true,
	displayMsg: '当前显示{0} - {1}，共计{2}',
	emptyMsg: "没有记录",
	buttons: [deptSetFilterItem,'-',deptSetSearchBox],
	doLoad:function(C){
		var B={},
		A=this.paramNames;
		B[A.start]=C;
		B[A.limit]=this.pageSize;
		B['parent']=parent;
		B['type']=type;
		B['active']="";
		B['action']="gridlist";
		B['dir']="asc";
		B['sort']="order";
		if(this.fireEvent("beforechange",this,B)!==false){
			this.store.load({params:B});
		}
	}
});

var deptSetGrid = new Ext.grid.GridPanel({
	region: 'center',
	xtype: 'grid',
	store: deptSetDs,
	cm: deptSetCm,
	trackMouseOver: true,
	stripeRows: true,
	sm: new Ext.grid.RowSelectionModel({singleSelect:true}),
	loadMask: true,
	viewConfig: {forceFit:true},
	tbar: [addButton,'-',editButton,'-',delButton,'-',deptManagerButton],
	bbar: deptSetPagingToolbar
});