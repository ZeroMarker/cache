var personUrl = '../csp/dhc.qm.checkpointmakeexe.csp';
var personProxy;

//�ⲿָ��
var personDs = new Ext.data.Store({
	proxy: personProxy,
	reader: new Ext.data.JsonReader({
		root: 'rows',
		totalProperty: 'results'
	}, [
		'rowid',
		'name',
	    'no',
	    'singleno'
	]),
	remoteSort: true
});

personDs.setDefaultSort('rowid', 'name');
var personCm = new Ext.grid.ColumnModel([
	new Ext.grid.RowNumberer(),
	{
		header: 'ID',
		dataIndex: 'rowid',
		//width: 20,
		align: 'left',
		sortable: true,
		hidden: true
	},{
		header: "��������",
		dataIndex: 'name',
		//width: 100,
		align: 'left',
		sortable: true
	},{
		header: "˳���",
		dataIndex: 'no',
		//width:30,
		align: 'left',
		sortable: true
	},{
		header: "������",
		dataIndex: 'singleno',
		//width:50,
		align: 'left',
		sortable: true
	}
]);

//��Ӱ�ť	
var addButton = new Ext.Toolbar.Button({
		text: '��Ӽ���',
		//tooltip: '���',
		iconCls: 'add',
		handler: function(){addSchemFun(personDs,personGrid);
		}
});
	
//ɾ����ť
var delButton = new Ext.Toolbar.Button({
	text: 'ɾ��',
    //tooltip:'ɾ��',        
    iconCls:'remove',
	handler:function(){

		//var selectedRow = itemGridDs.data.items[rowIndex];
		
		var rowObj = personGrid.getSelectionModel().getSelections();
		var len = rowObj.length;
		if(len < 1){
			Ext.Msg.show({title:'ע��',msg:'��ѡ����Ҫɾ���ļ�¼!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			return false;
		}else{
			Ext.MessageBox.confirm('��ʾ','ȷ��Ҫɾ��ѡ������?',
				function(btn) {
					if(btn == 'yes'){
						Ext.Ajax.request({
							url:'../csp/dhc.qm.checkpointmakeexe.csp?action=checkdel&rowid='+rowObj[0].get("rowid"),
							waitMsg:'ɾ����...',
							failure: function(result, request) {
								Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							},
							success: function(result, request) {
								var jsonData = Ext.util.JSON.decode( result.responseText );
								if (jsonData.success=='true') {
									Ext.Msg.show({title:'��ʾ',msg:'ɾ���ɹ�!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
									personDs.load({params:{start:0,limit:25,sort:"rowid",dir:"asc"}});
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

	var personPagingToolbar = new Ext.PagingToolbar({//��ҳ������
		pageSize:25,
		store:personDs,
		displayInfo:true,
		displayMsg:'��ǰ��ʾ{0} - {1}������{2}',
		emptyMsg:"û������"
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
		//width:'45%',
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
	
//ˢ��ҳ��
//	personGrid.load({params:{start:0,limit:25}});