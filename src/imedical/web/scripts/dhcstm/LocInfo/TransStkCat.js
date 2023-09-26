/**
 * ���� ����+������ �������ʵĹ�Ӧ�ֿ�
 * @param {} loc
 * @param {} locDesc
 */
function setTransStkCatferFrLoc(loc,locDesc){
	var url="dhcstm.orgutil.csp?actiontype=TransStkCat&LocId="+loc;
	var StakCatStore=new Ext.data.Store({
		url:url,
		autoLoad:true,
		baseParams:{LocId:loc},
		reader:new Ext.data.JsonReader({
			root:'rows',
			totalProperty:'results',
			id:'RowId'
		},['RowId','frLocRowId','frLocDescription','StkCat','StkCatDesc'])
	});

	var cm=new Ext.grid.ColumnModel([
		{
			header:'RowId',
			dataIndex:'RowId',
			align:'left',
			width:100,
			hidden:true
		}, {
			header:'frLocRowId',
			dataIndex:'frLocRowId',
			align:'left',
			width:100,
			hidden:true
		}, {
			header:'��������',
			dataIndex:'frLocDescription',
			align:'left',
			width:200,
			tooltip:'˫����ȥ��'
		}, {
			header:'����Id',
			dataIndex:'StkCat',
			align:'left',
			width:100,
			hidden:true
		}, {
			header:'��������',
			dataIndex:'StkCatDesc',
			align:'left',
			width:100,
			tooltip:'˫����ȥ��'
		}
	]);

	var closeWin=new Ext.Button({
		text:'�ر�',
		id:'close',
		iconCls : 'page_delete',
		width : 70,
		height : 30,
		handler:function(){
			ProvLocWin.close();
		}
	});

	var frLocGrid = new Ext.grid.GridPanel({
		id:'frLoc',
		title:'��ѡ...',
//		region:'west',
		region : 'center',
		width:300,
		store:StakCatStore,
		draggable:true,
		cm:cm,
		sm:new Ext.grid.RowSelectionModel(),
		loadMask:true,
		listeners:{
			'rowdblclick':function(grid,ind){
				var rec=grid.getSelectionModel().getSelected();
				var rowid=rec.get('RowId');
				if (rowid=='') return;
				Delete();
			}
		}
	});

	var AddSome = {
		xtype : 'uxbutton',
		iconCls : 'tag_add',
		width : 45,
		handler : AddStkCat
	}
	var ButtonSpace = {
		xtype : 'spacer',
		height : 20
	}
	var DelSome = {
		xtype : 'uxbutton',
		iconCls : 'tag_delete',
		width : 45,
		handler : Delete
	}
	var ButtonPanel = {
		xtype : 'panel',
		region : 'east',
		width : 60,
		layout : 'vbox',
		layoutConfig : {
			align : 'center',
			pack : 'center'
		},
		items : [AddSome, ButtonSpace, DelSome]
	};
	var ProvLocPanel = new Ext.Panel({
		title : '����Ȩ...',
		region : 'west',
		width : 400,
		layout : 'border',
		items : [frLocGrid, ButtonPanel]
	});

	var LocFilter = new Ext.form.TextField({
		id:'LocFilter',
		fieldLabel:'����',
		allowBlank:true,
		emptyText:'����...',
		anchor:'90%',
		selectOnFocus:true
	});
	
	var FilterButton = new Ext.Toolbar.Button({
		text : '����',
		tooltip : '����',
		iconCls : 'page_gear',
		width : 70,
		height : 30,
		handler:function(){
			var FilterDesc = Ext.getCmp("LocFilter").getValue();
			ProvLocGrid.getStore().setBaseParam('FilterDesc',FilterDesc);
			ProvLocGrid.getStore().load({params:{start:0,limit:PagingToolbar2.pageSize}});
		}
	});
	
	var cm2=new Ext.grid.ColumnModel([{
			header:'RowId',
			hidden:true,
			dataIndex:'RowId'
		},{
			header:'��������',
			dataIndex:'Description',
			width:260,
			tooltip:'˫����ѡ��'
		}
	]);
	
	var url2="dhcstm.orgutil.csp?actiontype=CtLoc&LocId="+loc;
	var store2 = new Ext.data.Store({
		url:url2,
		reader:new Ext.data.JsonReader({
			root:'rows',
			totalProperty:'results'
		},['RowId',"Description"])
	});
	
	var PagingToolbar2 = new Ext.PagingToolbar({
		store:store2,
		pageSize:30,
		displayInfo:true
	});
	
	var ProvLocGrid = new Ext.grid.GridPanel({
		title:'��ѡ...',
		autoHeigth:true,
		store:store2,
		region:'center',
		sm:new Ext.grid.RowSelectionModel({singleSelect:true}),
		cm:cm2,
		bbar:PagingToolbar2,
		tbar:[LocFilter,FilterButton]
	});
	
	var cm3=new Ext.grid.ColumnModel([{
			header:'RowId',
			hidden:true,
			dataIndex:'RowId'
		},{
			header:'��������',
			id:'StkCat', 
			dataIndex:'Description',
			width:260,
			tooltip:'˫����ѡ��'
		}
	]);
	var ur3="dhcstm.orgutil.csp?actiontype=TransStkCatDesc&LocId="+loc;
	var store3 = new Ext.data.Store({
		url:ur3,
		reader:new Ext.data.JsonReader({
			root:'rows',
			totalProperty:'results'
		},['RowId',"Description"])
	});
	var NoProvStkCatGrid = new Ext.grid.GridPanel({
		title:'������(��ѡ)...',
		store:store3,
		region:'east',
		width:260,
		sm:new Ext.grid.RowSelectionModel({singleSelect:false}),
		cm:cm3,
		listeners:{
			'rowdblclick':function(grid,ind){
                         AddStkCat();
			}
		}
	});

	function AddStkCat(){
		var ProvLocSel = ProvLocGrid.getSelectionModel().getSelected();
		if(Ext.isEmpty(ProvLocSel)){
			return false;
		}
		var ProvLoc = ProvLocSel.get('RowId');
		var IncscSels = NoProvStkCatGrid.getSelectionModel().getSelections();
		if(Ext.isEmpty(IncscSels)){
			return false;
		}
		var IncscStr = '';
		for(var i = 0, len = IncscSels.length; i < len; i++){
			var Incsc = IncscSels[i].get('RowId');
			var rowIndex = frLocGrid.getStore().findExact('StkCat', Incsc, 0);
			if(rowIndex != -1){
				var IncscDesc = frLocGrid.getStore().getAt(rowIndex).get('StkCatDesc');
				Msg.info('warning', '������: ' + IncscDesc + ' �Ѿ�ά����������!');
				return false;
			}
			if(IncscStr == ''){
				IncscStr = Incsc;
			}else{
				IncscStr = IncscStr + '^' + Incsc;
			}
		}
		Ext.Ajax.request({
			url:'dhcstm.locinfoaction.csp?actiontype=addStkCat',
			params : {LocId : loc, ProvLoc : ProvLoc, IncscStr : IncscStr},
			success : function(result, request) {
				var jsonData = Ext.util.JSON.decode(result.responseText);
				if (jsonData.success == 'true') {
					Msg.info("success", "���ӳɹ�!");
					refresh();
				} else {
					Msg.info("error", "���Һͷ����Ѵ���:"+jsonData.info);
				}
			},
			scope : this
		});
	}

	function Delete(){
		var ProvStkcatSels = frLocGrid.getSelectionModel().getSelections();
		if(Ext.isEmpty(ProvStkcatSels)){
			return false;
		}
		var RowIdStr = '';
		for(var i = 0, len = ProvStkcatSels.length; i < len; i++){
			var RowId = ProvStkcatSels[i].get('RowId');
			if(RowIdStr == ''){
				RowIdStr = RowId;
			}else{
				RowIdStr = RowIdStr + '^' + RowId;
			}
		}
		Ext.Ajax.request({
			url:'dhcstm.locinfoaction.csp?actiontype=deleteStkCat&rowid='+RowIdStr,
			success:function(){
				refresh();
				Msg.info('success','ɾ���ɹ�!');
			},
			failure:function(){
				Msg.info('error','ɾ��ʧ��!');
			}	
		})
	}

	function refresh()
	{
		frLocGrid.getStore().reload();
		NoProvStkCatGrid.getStore().reload();
	}
	
	var ProvLocWin=new Ext.Window({
		title:'ά����Ӧ�ֿ�'+"("+locDesc+")",
		//width:680,
		//height:500,
		width : gWinWidth,
		height : gWinHeight,
		layout:'border',
		modal:true,
		resizable:false,
		items:[ProvLocPanel,ProvLocGrid,NoProvStkCatGrid],
		tbar:[closeWin],
		listeners : {
			show : function(win){
				frLocGrid.getStore().load();
				ProvLocGrid.getStore().load({params:{start:0,limit:PagingToolbar2.pageSize}});
				NoProvStkCatGrid.getStore().load();
			}
		}
	})
	
	ProvLocWin.show();
}
