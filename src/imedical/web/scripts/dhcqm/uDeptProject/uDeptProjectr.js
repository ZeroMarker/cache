var personUrl = '../csp/dhc.qm.uDeptProjectexe.csp';
var personProxy;

//�ⲿָ��
var personDs = new Ext.data.Store({
	proxy: personProxy,
	reader: new Ext.data.JsonReader({
		root: 'rows',
		totalProperty: 'results'
	}, [
		'RowId',
		'Code',
		'name',
		'deptCode'
	]),
	remoteSort: true
});

personDs.setDefaultSort('deptCode', 'name');
var personCm = new Ext.grid.ColumnModel([
	new Ext.grid.RowNumberer(),
	{
		header: '����ID',
		dataIndex: 'RowId',
		width: 80,
		align: 'left',
		sortable: true,
		hidden:true
	},{
		header: "���Ҵ���",
		dataIndex: 'deptCode',
		width: 100,
		align: 'left',
		sortable: true
	},{
		header: "��������",
		dataIndex: 'name',
		width: 120,
		align: 'left',
		sortable: true
	}
]);


//��Ӱ�ť



	
var addButton = new Ext.Toolbar.Button({
		text: '��ӿ���',
		tooltip: '���',
		iconCls: 'add',
		handler: function(){addSchemFun(personDs,personGrid,personPagingToolbar, RowId );
		}
});


//ɾ����ť
var delButton = new Ext.Toolbar.Button({
	text: 'ɾ��',
    tooltip:'ɾ��',        
    iconCls:'remove',
	handler:function(){
		var rowObj = personGrid.getSelections();
		var len = rowObj.length;
		var jxUnitDr=0;
		if(len < 1){
			Ext.Msg.show({title:'ע��',msg:'��ѡ�������Ŀ��¼!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			return false;
		}else{
			jxUnitDr=rowObj[0].get("RowId");
		}
		
		var rowObj = personGrid.getSelections();
		var len = rowObj.length;
		if(len < 1){
			Ext.Msg.show({title:'ע��',msg:'��ѡ����Ҫɾ���Ŀ��Ҽ�¼!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			return false;
		}else{
			Ext.MessageBox.confirm('��ʾ','ȷ��Ҫɾ��ѡ������?',
				function(btn) {
					if(btn == 'yes'){
						Ext.Ajax.request({
							url:'../csp/dhc.qm.uDeptProjectexe.csp?action=del&RowId='+rowObj[0].get("RowId"),
							waitMsg:'ɾ����...',
							failure: function(result, request) {
								Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							},
							success: function(result, request) {
								var jsonData = Ext.util.JSON.decode( result.responseText );
								if (jsonData.success=='true') {
									Ext.Msg.show({title:'��ʾ',msg:'ɾ���ɹ�!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
									personDs.load({params:{start:personPagingToolbar.cursor,limit:personPagingToolbar.pageSize,jxUnitDr:jxUnitDr,sort:"RowId",dir:"asc"}});
								}else{
									Ext.Msg.show({title:'��ʾ',msg:'ɾ��ʧ��!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
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

var CalUnitSearchField = 'name';

var CalUnitFilterItem = new Ext.SplitButton({
		text: '������',
		tooltip: '�ؼ����������',
		menu: {items: [
				new Ext.menu.CheckItem({ text: '����',value: 'Code',checked: false,group: 'CalUnitFilter',checkHandler: onCalUnitItemCheck }),
				new Ext.menu.CheckItem({ text: '����',value: 'name',checked: false,group: 'CalUnitFilter',checkHandler: onCalUnitItemCheck }),
		]}
});

function onCalUnitItemCheck(item, checked)
{
		if(checked) {
				CalUnitSearchField = item.value;
				CalUnitFilterItem.setText(item.text + ':');
		}
};


var personSearchBox = new Ext.form.TwinTriggerField({//���Ұ�ť
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
				personDs.proxy = new Ext.data.HttpProxy({url:personUrl+'?action=list2&Code='+itemGrid.getSelections()[0].get("Rowid")});
				personDs.load({params:{start:0, limit:personPagingToolbar.pageSize}});
			}
		},
		onTrigger2Click: function() {
			if(this.getValue()) {
				personDs.proxy = new Ext.data.HttpProxy({
				url: personUrl+'?action=list2&Code='+itemGrid.getSelections()[0].get("Rowid")+'&searchField=' + CalUnitSearchField + '&searchValue=' + encodeURIComponent(this.getValue())});
				personDs.load({params:{start:0,limit:personPagingToolbar.pageSize}});
			}
		}
	});
	var personPagingToolbar = new Ext.PagingToolbar({//��ҳ������
		pageSize:25,
		store:personDs,
		displayInfo:true,
		displayMsg:'��ǰ��ʾ{0} - {1}������{2}',
		emptyMsg:"û������",
		buttons:['-',CalUnitFilterItem,'-',personSearchBox],
		doLoad:function(C){
			var B={},
			A=this.paramNames;
			B[A.start]=C;
			B[A.limit]=this.pageSize;
			B['jxUnitDr']=itemGrid.getSelections()[0].get("RowId");
			B['dir']="asc";
			B['sort']="RowId";
			if(this.fireEvent("beforechange",this,B)!==false){
				this.store.load({params:B});
			}
		}
	});
	/*var personPagingToolbar = new Ext.PagingToolbar({
		pageSize: 15,
		store: personDs,
		atLoad : true,
		displayInfo: true,
		displayMsg: '��ǰ��ʾ{0} - {1}������{2}',
		emptyMsg: "û������"//,

});*/
	var personGrid = new Ext.grid.GridPanel({//���
		
		region: 'center',
		xtype: 'grid',
		store: personDs,
		cm: personCm,
		trackMouseOver: true,
		stripeRows: true,
		sm: new Ext.grid.RowSelectionModel({singleSelect:true}),
		loadMask: true,
		viewConfig: {forceFit:true},
		tbar: [addButton,'-',delButton],
		bbar: personPagingToolbar
	});