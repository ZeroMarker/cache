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
		header: '����',
		dataIndex: 'code',
		width: 60,
		sortable: true
	},{
		header: "����",
		dataIndex: 'name',
		width: 80,
		sortable: true
	},{
		header: "˳��",
		dataIndex: 'order',
		width: 60,
		sortable: true
	},{
		header: "ƴ��",
		dataIndex: 'py',
		width: 80,
		sortable: true
	},{
		header: "��ע",
		dataIndex: 'remark',
		width: 80,
		sortable: true
	},{
		header: "ĩ�˱�־",
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
	text: '���',
	tooltip: '���',
	iconCls: 'add',
	handler: function(){
        //��ȡ���ڵ�����Բ��жϸ����ڵ��Ƿ���ĩ�˽ڵ�(���ڵ����)
        var node = Ext.getCmp('detailReport').getSelectionModel().getSelectedNode();
		if(node==null){
            Ext.Msg.show({title:'��ʾ',msg:'��ѡ�����ṹ�еķֲ���!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
            return;
        }
        var nodeId = node.id;
        if(nodeId.split("||").length>1){
            Ext.Msg.show({title:'��ʾ',msg:'��ѡ����ǿ��ң���ѡ��ֲ�������ӷֲ���!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
            return;
        }
        var parentId = nodeId;
        if(parentId=="roo") parentId=0;
        if(nodeId=="roo"){
            //�������
            addFun(parentId,deptSetDs,deptSetPagingToolbar);
        }else{
            var isEnd = node.attributes.end;
            if(isEnd=="N"){
                //�������
                addFun(parentId,deptSetDs,deptSetPagingToolbar);
            }else{
                //��ʾ��ĩ�˽ڵ㲻���������
                Ext.Msg.show({title:'��ʾ',msg:'ĩ�˽ڵ㣬��������Ӳ��ŷֲ���!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
            }
        }
	}
});

var editButton  = new Ext.Toolbar.Button({
	text: '�޸�',
	tooltip: '�޸�',
    iconCls: 'add',
	handler: function(){
		editFun(deptSetDs,deptSetGrid,deptSetPagingToolbar);
	}
});

var delButton = new Ext.Toolbar.Button({
	text: 'ɾ��',
	tooltip: 'ɾ��',
	iconCls: 'add',
	handler: function(){
        delFun(deptSetDs,deptSetGrid,deptSetPagingToolbar);
	}
});

var deptManagerButton  = new Ext.Toolbar.Button({
	text: '���Ź���',
	tooltip: '���Ź���',
	iconCls: 'add',
	handler: function(){
		deptManagerFun(deptSetDs,deptSetGrid,deptSetPagingToolbar);
	}
});

var deptSetSearchField = 'name';

var deptSetFilterItem = new Ext.SplitButton({
		text: '������',
		tooltip: '�ؼ����������',
		menu: {items: [
				new Ext.menu.CheckItem({ text: '����',value: 'code',checked: false,group: 'DeptSetsFilter',checkHandler: onDeptSetCheck }),
				new Ext.menu.CheckItem({ text: '����',value: 'name',checked: true,group: 'DeptSetsFilter',checkHandler: onDeptSetCheck })
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
	emptyText:'����...',
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
	displayMsg: '��ǰ��ʾ{0} - {1}������{2}',
	emptyMsg: "û�м�¼",
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