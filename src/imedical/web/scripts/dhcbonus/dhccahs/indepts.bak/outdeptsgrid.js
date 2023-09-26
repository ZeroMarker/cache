var outDeptsUrl = 'dhc.ca.indeptsexe.csp';
var outDeptsProxy;

//�ӿڲ�������Դ
var outDeptsDs = new Ext.data.Store({
	proxy: outDeptsProxy,
	reader: new Ext.data.JsonReader({
		root: 'rows',
		totalProperty: 'results'
	}, [
	'parRef',
	'rowid',
	'order',
	'code',
	'name',
	'patType',
	'remark'
	]),
	// turn on remote sorting
	remoteSort: true
});

outDeptsDs.setDefaultSort('RowId', 'Desc');
var outDeptsCm = new Ext.grid.ColumnModel([
new Ext.grid.RowNumberer(),
{
	header: '�ڲ�����id',
	dataIndex: 'parRef',
	width: 25,
	hidden: true
},
{
	header: '���',
	dataIndex: 'order',
	width: 25,
	sortable: true
},
{
	header: '����',
	dataIndex: 'code',
	width: 40,
	sortable: true
},
{
	header: "����",
	dataIndex: 'name',
	width: 120,
	align: 'left',
	sortable: true
},
{
	header: "��������",
	dataIndex: 'patType',
	width: 60,
	align: 'left',
	sortable: true
},
{
	header: "��ע",
	dataIndex: 'remark',
	width: 150,
	align: 'left',
	sortable: true
}
]);
var addButton = new Ext.Toolbar.Button({
	text: '��ӽӿڲ���',
	tooltip: '���һ���ӿڲ���',
	iconCls: 'add',
	handler: function(){addFun(outDeptsDs,outDeptsGrid,outDeptsPagingToolbar,inDeptsRowId);}
});



var editButton  = new Ext.Toolbar.Button({
	text: '�޸Ľӿڲ���',
	tooltip: '�޸�ѡ���Ľӿڲ���',
	iconCls: 'remove',
	handler: function(){editFun(outDeptsDs,outDeptsGrid,outDeptsPagingToolbar,inDeptsRowId);}
});
var listButton  = new Ext.Toolbar.Button({
	text: '�鿴���нӿڲ���',
	tooltip: '�鿴���нӿڲ���',
	iconCls: 'remove',
	handler: function(){
		addButton.setDisabled(true);
		editButton.setDisabled(true);
		delButton.setDisabled(true);
		outDeptsDs.proxy = new Ext.data.HttpProxy({url: outDeptsUrl + '?action=listOutDeptTwo&inDeptSetsId='+inDeptSetsId+'&sort=rowid&dir=DESC'});
		outDeptsDs.load({params:{start:0, limit:outDeptsPagingToolbar.pageSize}});
	}
});
var delButton  = new Ext.Toolbar.Button({
	text:'ɾ���ӿڲ���',
	tooltip:'ɾ��ѡ���Ľӿڲ���',
	iconCls:'remove',
	//disabled:'true',
	handler: function(){
		var rowObj = outDeptsGrid.getSelections();
		var len = rowObj.length;
		var myId = "";
		if(len < 1)
		{
			Ext.Msg.show({title:'ע��',msg:'��ѡ����Ҫɾ��������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			return;
		}
		else
			{	
		Ext.MessageBox.confirm('��ʾ', 
    	    'ȷ��Ҫɾ��ѡ������?', 
    	    function(btn) {
	    	     if(btn == 'yes')
		         {	
				     myId = rowObj[0].get("rowid");
				Ext.Ajax.request({
					url: busdingUrl + '?action=delOutDept&id='+myId,
					waitMsg:'ɾ����...',
					failure: function(result, request) {
						Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
					},
					success: function(result, request) {
						var jsonData = Ext.util.JSON.decode( result.responseText );
						if (jsonData.success=='true') {
							Ext.Msg.show({title:'ע��',msg:'ɾ���ɹ�!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
							outDeptsDs.proxy = new Ext.data.HttpProxy({url: outDeptsUrl + '?action=listOutDept&inDeptId='+inDeptsRowId+'&sort=rowid&dir=DESC'});
							outDeptsDs.load({params:{start:0, limit:outDeptsPagingToolbar.pageSize}});
							window.close();
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
		    } 
		)
				//--------------------------------------------------------------------------------------
				
				}
			}
		});
var deptChangeButton=new Ext.Toolbar.Button({
	text:'�ƶ��ӿ�',
	tooltip:'�ƶ��ӿ�',
	iconCls:'remove',
	handler: function(){
	 var rowObj = outDeptsGrid.getSelections();
		var len = rowObj.length;
		if(len < 1)
		{
			Ext.Msg.show({title:'ע��',msg:'��ѡ����Ҫת��������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			return;
		}else{
			var parRef= rowObj[0].get("parRef");
			var rowId = rowObj[0].get("rowid");
			var code = rowObj[0].get("code");
			var name = rowObj[0].get("name");
			var patType = rowObj[0].get("patType");
			var remark = rowObj[0].get("remark");
		  outdeptschange(parRef,rowId,code,name,patType,remark); 
		}
	}
});
var outDeptsSearchField = 'name';

var outDeptsFilterItem = new Ext.Toolbar.MenuButton({
	text: '������',
	tooltip: '�ؼ����������',
	menu: {items: [
		new Ext.menu.CheckItem({ text: '���',value: 'order',checked: false,group: 'outDeptsFilter',checkHandler: onBusItemItemCheck }),
		new Ext.menu.CheckItem({ text: '����',value: 'code',checked: false,group: 'outDeptsFilter',checkHandler: onBusItemItemCheck }),
		new Ext.menu.CheckItem({ text: '����',value: 'name',checked: true,group: 'outDeptsFilter',checkHandler: onBusItemItemCheck }),
		new Ext.menu.CheckItem({ text: '��������',value: 'patType',checked: false,group: 'outDeptsFilter',checkHandler: onBusItemItemCheck }),
		new Ext.menu.CheckItem({ text: '��ע',value: 'remark',checked: false,group: 'outDeptsFilter',checkHandler: onBusItemItemCheck })
	]}
});
function onBusItemItemCheck(item, checked)
{
	if(checked) {
		outDeptsSearchField = item.value;
		outDeptsFilterItem.setText(item.text + ':');
	}
};

var outDeptsSearchBox = new Ext.form.TwinTriggerField({//���Ұ�ť
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
				outDeptsDs.proxy = new Ext.data.HttpProxy({url: outDeptsUrl + '?action=listOutDept&inDeptId=' + inDeptsRowId});
				outDeptsDs.load({params:{start:0, limit:outDeptsPagingToolbar.pageSize}});
			}
		},
		onTrigger2Click: function() {
			if(this.getValue()) {
				outDeptsDs.proxy = new Ext.data.HttpProxy({
				url: outDeptsUrl + '?action=listOutDept&inDeptId='+inDeptsRowId+'&searchField=' + outDeptsSearchField + '&searchValue=' + this.getValue()});
				outDeptsDs.load({params:{start:0, limit:outDeptsPagingToolbar.pageSize}});
			}
		}
	});
	var outDeptsPagingToolbar = new Ext.PagingToolbar({//��ҳ������
		pageSize: 25,
		store: outDeptsDs,
		displayInfo: true,
		displayMsg: '��ǰ��ʾ{0} - {1}������{2}',
		emptyMsg: "û������",
		buttons: [outDeptsFilterItem,'-',outDeptsSearchBox],
		doLoad:function(C){
			var B={},
			A=this.paramNames;
			B[A.start]=C;
			B[A.limit]=this.pageSize;
			B['inDeptId']=inDeptsRowId;
			if(this.fireEvent("beforechange",this,B)!==false){
				this.store.load({params:B});
			}
		}
	});
	var outDeptsGrid = new Ext.grid.GridPanel({//���
		title: '�ӿڲ���',
		region: 'center',
		xtype: 'grid',
		store: outDeptsDs,
		cm: outDeptsCm,
		trackMouseOver: true,
		stripeRows: true,
		sm: new Ext.grid.RowSelectionModel({singleSelect:true}),
		loadMask: true,
		viewConfig: {forceFit:true},
		tbar: [addButton,'-',editButton,'-',delButton,'-',listButton,'-',deptChangeButton],
		bbar: outDeptsPagingToolbar
	});