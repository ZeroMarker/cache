var locDr;
var owenr;
var repdr;
var leaf;
var deptLevelSetsUrl = 'dhc.ca.deptlevelsetsexe.csp';
var deptLevelSetsProxy=new Ext.data.HttpProxy({url: deptLevelSetsUrl + '?action=listsub'});
//���ŷֲ�����Դ
var deptLevelSetsDs = new Ext.data.Store({
	proxy: deptLevelSetsProxy,
	reader: new Ext.data.JsonReader({
		root: 'rows',
		totalProperty: 'results'
	}, [
	'id',
	'code',
	'name',
	'desc',
	'remark',
	'leaf',
	'end',
	'active',
	'parent',
	'uiProvider',
	'order',
	'repFlag',
	'recCost',
	'hospDr',
	'hospName',
	'locDr'
	]),
	// turn on remote sorting
	remoteSort: true
});

deptLevelSetsDs.setDefaultSort('id', 'Desc');
var deptLevelSetsCm = new Ext.grid.ColumnModel([
new Ext.grid.RowNumberer(),
{
	header: '�ֲ����',
	dataIndex: 'code',
	width: 30,
	sortable: true
},
{
	header: "�ֲ�����",
	dataIndex: 'name',
	width: 60,
	sortable: true
},
{
	header: "˳��",
	dataIndex: 'order',
	width: 20,
	sortable: true
},
{
	header: "��ע",
	dataIndex: 'remark',
	width: 60,
	sortable: true
},
{
	header: "ĩ�˱�־",
	dataIndex: 'end',
	width: 30,
	sortable: true,
	renderer : function(v, p, record){
		p.css += ' x-grid3-check-col-td';
		return '<div class="x-grid3-check-col'+(v=='Y'?'-on':'')+' x-grid3-cc-'+this.id+'">&#160;</div>';
	}
},
{
	header: "��Ч��־",
	dataIndex: 'active',
	width: 40,
	sortable: true,
	renderer : function(v, p, record){
		p.css += ' x-grid3-check-col-td';
		return '<div class="x-grid3-check-col'+(v=='Y'?'-on':'')+' x-grid3-cc-'+this.id+'">&#160;</div>';
	}
},
{
	header: "���������־",
	dataIndex: 'repFlag',
	width: 80,
	sortable: true,
	renderer : function(v, p, record){
		p.css += ' x-grid3-check-col-td';
		return '<div class="x-grid3-check-col'+(v=='Y'?'-on':'')+' x-grid3-cc-'+this.id+'">&#160;</div>';
	}
}
]);
var addButton = new Ext.Toolbar.Button({
	text: '��ӷֲ�',
	tooltip: '���һ��������',
	iconCls: 'add',
	handler: function(){
		Ext.Ajax.request({
			url: encodeURI(deptLevelSetsUrl + '?action=check&id='+repdr),
			waitMsg:'������...',
			failure: function(result, request) {
				Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
			},
			success: function(result, request) {
				var jsonData = Ext.util.JSON.decode( result.responseText );
				if (jsonData.success=='true'||repdr=="roo") {
					AddFun(deptLevelSetsDs,deptLevelSetsGrid,deptLevelSetsPagingToolbar);
				}
				else
					{
						var message="�˽ڵ�Ϊĩ�˽ڵ�,���ܽ��д˲���!";
						Ext.Msg.show({title:'����',msg:message,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
					}
				},
			scope: this
		}); 
		
	}
});

var editButton  = new Ext.Toolbar.Button({
	text: '�޸ķֲ�',
	tooltip: '�޸�ѡ��������',
	iconCls: 'remove',
	handler: function(){
		var tmpRow=deptLevelSetsGrid.getSelections();
		var tmpLength = tmpRow.length;
		if(tmpLength < 1)
		{
			Ext.Msg.show({title:'ע��',msg:'��ѡ����Ҫ�޸ĵ�����!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			return;
		}
		var recCost=tmpRow[0].get("recCost");
		if(recCost==""){
			EditFun(deptLevelSetsDs,deptLevelSetsGrid,deptLevelSetsPagingToolbar);
		}else{
			editLocFun(deptLevelSetsDs,deptLevelSetsGrid,deptLevelSetsPagingToolbar);
		}
		
	}
});

var addLocButton  = new Ext.Toolbar.Button({
	text: '���Ӳ���',
	tooltip: '���Ӳ���',
	iconCls: 'add',
	handler: function(){locLastFun(deptLevelSetsDs,deptLevelSetsGrid,deptLevelSetsPagingToolbar);}
});

var delLocButton  = new Ext.Toolbar.Button({
	text:'ɾ������',
	tooltip:'ɾ��ѡ���Ĳ���',
	iconCls:'remove',
	//disabled:'true',
	handler: function(){
		var rowObj = deptLevelSetsGrid.getSelections();
		var len = rowObj.length;
		var myId = "";
		if(len < 1)
		{
			Ext.Msg.show({title:'ע��',msg:'��ѡ����Ҫɾ��������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			return;
		}
		var end = rowObj[0].get("end");
		if(end != "")
		{
			Ext.Msg.show({title:'ע��',msg:'��ѡ������ݲ��ǲ���!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			return;
		}
		else
		{	
			Ext.MessageBox.confirm('��ʾ', 
			'ȷ��Ҫɾ��ѡ������?', 
			function(btn) {
				if(btn == 'yes')
				{	
				myId = rowObj[0].get("id");
					Ext.Ajax.request({
					url:encodeURI('dhc.ca.deptlevelsetsexe.csp?action=delloc&id='+myId),
					waitMsg:'ɾ����...',
					failure: function(result, request) {
						Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
					},
					success: function(result, request) {
						var jsonData = Ext.util.JSON.decode( result.responseText );
						if (jsonData.success=='true') {
							Ext.Msg.show({title:'ע��',msg:'ɾ���ɹ�!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
							Ext.getCmp('detailReport').getNodeById(repdr).reload();
							deptLevelSetsDs.load({params:{start:0, limit:deptLevelSetsPagingToolbar.pageSize}});
						}
						else
							{
								var message="";
								Ext.Msg.show({title:'����',msg:message,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							}
						},
						scope: this
					});   	
				}
			})
		}
	}
});

var deptLevelSetsSearchField = 'Name';

var deptLevelSetsFilterItem = new Ext.Toolbar.MenuButton({
	text: '������',
	tooltip: '�ؼ����������',
	menu: {items: [
		new Ext.menu.CheckItem({ text: '����',value: 'Name',checked: true,group: 'deptLevelSetsFilter',checkHandler: onBusItemItemCheck })
		
	]}
});
function onBusItemItemCheck(item, checked)
{
	if(checked) {
		deptLevelSetsSearchField = item.value;
		deptLevelSetsFilterItem.setText(item.text + ':');
	}
};

var deptLevelSetsSearchBox = new Ext.form.TwinTriggerField({//���Ұ�ť
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
			deptLevelSetsDs.proxy = new Ext.data.HttpProxy({url: encodeURI(deptLevelSetsUrl + '?action=listsub&repdr=' + repdr)});
			deptLevelSetsDs.load({params:{start:0, limit:deptLevelSetsPagingToolbar.pageSize,repdr:repdr}});
		}
	},
	onTrigger2Click: function() {
		if(this.getValue()) {
			deptLevelSetsDs.proxy = new Ext.data.HttpProxy({
			url: encodeURI(deptLevelSetsUrl + '?action=listsub&repdr=' + repdr+'&searchfield=' + deptLevelSetsSearchField + '&searchvalue=' + this.getValue())});
			deptLevelSetsDs.load({params:{start:0, limit:deptLevelSetsPagingToolbar.pageSize,repdr:repdr}});
		}
	}
});
var deptLevelSetsPagingToolbar = new Ext.PagingToolbar({//��ҳ������
	pageSize: 25,
	store: deptLevelSetsDs,
	displayInfo: true,
	displayMsg: '��ǰ��ʾ{0} - {1}������{2}',
	emptyMsg: "û������",
	//buttons: [deptLevelSetsFilterItem,'-',deptLevelSetsSearchBox],
	doLoad:function(C){
		var B={},
		A=this.paramNames;
		B[A.start]=C;
		B[A.limit]=this.pageSize;
		B['id']=repdr;
		if(this.fireEvent("beforechange",this,B)!==false){
			this.store.load({params:B});
		}
	}


});
var deptLevelSetsGrid = new Ext.grid.GridPanel({//���
	//title: '���ŷֲ�',
	//width:500,
	region: 'center',
	xtype: 'grid',
	store: deptLevelSetsDs,
	cm: deptLevelSetsCm,
	trackMouseOver: true,
	stripeRows: true,
	sm: new Ext.grid.RowSelectionModel({singleSelect:true}),
	loadMask: true,
	viewConfig: {forceFit:true},
	tbar: [addButton,'-',editButton,'-'],
	bbar: deptLevelSetsPagingToolbar
});