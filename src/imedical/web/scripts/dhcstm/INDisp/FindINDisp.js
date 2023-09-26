FindINDisp = function(ds,locField,fn){
	var url = 'dhcstm.indispaction.csp';
	var inds = "";
	//��ʼ����
	var startDate = new Ext.ux.DateField({
		id:'startDate',
		listWidth:210,
		allowBlank:true,
		fieldLabel:'��ʼ����',
		anchor:'95%',
		value:new Date().add(Date.DAY,-7)
	});
	//��ֹ����
	var endDate = new Ext.ux.DateField({
		id:'endDate',
		listWidth:210,
		allowBlank:true,
		fieldLabel:'��ֹ����',
		anchor:'95%',
		value:new Date()
	});
	
	var Loc = new Ext.ux.LocComboBox({
		id:'Loc',
		fieldLabel:'����',
		listWidth:210,
		emptyText:'����...',
		anchor:'95%',
		groupId:GroupId
	});
	
	var finish = new Ext.form.Checkbox({
		id: 'finish',
		fieldLabel:'���',
		anchor:'95%',
		allowBlank:true
	});

	var audit = new Ext.form.Checkbox({
		id: 'audit',
		fieldLabel:'���',
		anchor:'95%',
		allowBlank:true
	});
	
	var InadjProxy= new Ext.data.HttpProxy({url:url+'?actiontype=query',method:'GET'});
	var InDispDs = new Ext.data.Store({
		proxy:InadjProxy,
		reader:new Ext.data.JsonReader({
			totalProperty:'results',
			root:'rows'
		}, [
			{name:'inds'},
			{name:'no'},
			{name:'loc'},
			{name:'locDesc'},
			{name:'date'},
			{name:'time'},
			{name:'user'},
			{name:'userName'},
			{name:'chkDate'},
			{name:'chkTime'},
			{name:'chkUser'},
			{name:'chkUserName'},
			{name:'scg'},
			{name:'scgDesc'},
			{name:'comp'},
			{name:'state'},
			{name:'chkFlag'},
			{name:'stkType'},
			{name:'dispmode'},
			{name:'recUser'},
			{name:'recUserName'},
			{name:'grp'},
			{name:'grpDesc'},
			{name:'remark'},
			'indsToLoc'
		]),
		remoteSort: false,
		listeners:{
			'load':function(){
				if (InDispDs.getCount()>0){InDispGrid.getSelectionModel().selectFirstRow();
					InDispGrid.getView().focusRow(0);
				}
			}
		}
	});
	
	var InDispCm = new Ext.grid.ColumnModel([
		new Ext.grid.RowNumberer(),
		{
			header: '���ŵ�rowid',
			dataIndex: 'inds',
			hidden:true
		},{
			header: '���ŵ���',
			dataIndex: 'no',
			width: 150,
			sortable:true,
			align: 'left'
		},{
			header: '����',
			dataIndex: 'locDesc',
			width: 150,
			sortable:true,
			align: 'left'
		},{
			header:'���տ���',
			width:160,
			align:'left',
			dataIndex:'indsToLoc'
		},{
			header: "��������",
			dataIndex: 'date',
			width: 120,
			align: 'left',
			sortable: true
		},{
			header: "scg",
			dataIndex: 'scg',
			width: 150,
			align: 'center',
			hidden:true
		},{
			header: "����",
			dataIndex: 'scgDesc',
			width: 60,
			align: 'left',
			sortable: true
		},{
			header:'��������',
			dataIndex:'dispmode',
			width:80
		},{
			header:'������',
			dataIndex:'recUserName',
			width:60
		},{
			header:'רҵ��',
			dataIndex:'grpDesc',
			width:120
		},{
			header: "���",
			dataIndex: 'comp',
			width: 40,
			align: 'center',
			sortable: true,
			xtype : 'checkcolumn'
		},{
			header: "���",
			dataIndex: 'chkFlag',
			width: 40,
			align: 'center',
			sortable: true,
			xtype : 'checkcolumn'
		},{
			header:'��ע',
			width:120,
			align:'left',
			dataIndex:'remark'
		}
	]);

	var InDsPagingToolbar = new Ext.PagingToolbar({
		store:InDispDs,
		pageSize:15,
		displayInfo:true
	});
	
	var fB = new Ext.Toolbar.Button({
		text:'��ѯ',
		tooltip:'��ѯ',
		iconCls:'page_find',
		width:70,
		height:30,
		handler:function(){
			var startDate = Ext.getCmp('startDate').getValue();
			if((startDate!="")&&(startDate!=null)){
				startDate = startDate.format(ARG_DATEFORMAT);
			}else{
				Msg.info("error","��ѡ����ʼ����!");
				return false;
			}
			var endDate = Ext.getCmp('endDate').getValue();
			if((endDate!="")&&(endDate!=null)){
				endDate = endDate.format(ARG_DATEFORMAT);
			}else{
				Msg.info("error","��ѡ���ֹ����!");
				return false;
			}
			
			var locId = Ext.getCmp('Loc').getValue();
			if((locId=="")||(locId==null)){
				Msg.info("error","��ѡ�����!");
				return false;
			}
			
			var finish = (Ext.getCmp('finish').getValue()==true?'Y':'N');
			var audit = (Ext.getCmp('audit').getValue()==true?'Y':'N');
			
			var strPar = startDate+"^"+endDate+"^"+locId+"^"+audit+"^"+finish;
			InDispDs.setBaseParam('strParam',strPar);
			InDispDs.removeAll();
			InDispItmDs.removeAll();
			InDispDs.load({params:{start:0,limit:InDsPagingToolbar.pageSize,sort:'NO',dir:'desc'}});	
		}
	});
	
	var cancelFind=new Ext.Toolbar.Button({
		text:'�ر�',
		height:30,
		width:70,
		iconCls:'page_delete',
		handler:function()
		{
			findWin.close();
			//findWin.hide();
		}
	});
	
	var InDispGrid = new Ext.ux.GridPanel({
		id : 'InDispGrid',
		region:'center',
		store:InDispDs,
		cm:InDispCm,
		trackMouseOver: true,
		stripeRows: true,
		sm:new Ext.grid.RowSelectionModel({singleSelect:false}),
		loadMask: true,
		bbar:InDsPagingToolbar
	});
	
	var InDispItmProxy= new Ext.data.HttpProxy({url:url+'?actiontype=queryItem',method:'GET'});
	var InDispItmDs = new Ext.data.Store({
		proxy:InDispItmProxy,
		reader:new Ext.data.JsonReader({
			totalProperty:'results',
			root:'rows'
		}, [
			{name:'indsItm'},
			{name:'inclb'},
			{name:'inci'},
			{name:'code'},
			{name:'desc'},
			{name:'Abbrev'},
			{name:'spec'},
			{name:'manf'},
			{name:'batNo'},
			{name:'expDate'},
			{name:'qty'},
			{name:'uom'},
			{name:'uomDesc'},
			{name:'qtyBUOM'},
			{name:'rp'},
			{name:'rpAmt'},
			{name:'sp'},
			{name:'spAmt'},
			{name:'insti'},
			"IndsiRemarks"
		]),
		remoteSort: false
	});

	var InDispItmCm = new Ext.grid.ColumnModel([
		new Ext.grid.RowNumberer(),
		{
			header: '��ϸrowid',
			dataIndex: 'indsItm',
			hidden:true
		},{
			header: '����rowid',
			dataIndex: 'inclb',
			hidden:true
		},{
			header: '����rowid',
			dataIndex: 'inci',
			hidden:true
		},{
			header: '����',
			dataIndex: 'code',
			width: 72,
			sortable:true,
			align: 'left'
		},{
			header: '����',
			dataIndex: 'desc',
			width: 180,
			sortable:true,
			align: 'left'
		},{
			header:'���',
			dataIndex:'spec',
			align:'left',
			width:80,
			sortable:true
		},{
			header: "����~Ч��",
			dataIndex: 'batNo',
			width: 180,
			align: 'left',
			sortable: true
		},{
			header: "����",
			dataIndex: 'manf',
			width: 80,
			align: 'left',
			sortable: true
		},{
			header: "��������",
			dataIndex: 'qty',
			width: 72,
			align: 'right',
			sortable: true
		},{
			header:'��λ',
			dataIndex:'uomDesc',
			align:'left',
			width:80,
			sortable:true
		},{
			header:'����',
			dataIndex:'rp',
			align:'right',
			width:80,
			sortable:true
		},{
			header:'���۽��',
			dataIndex:'rpAmt',
			align:'right',
			width:80,
			sortable:true
		},{
			header:'��ע',
			dataIndex:'IndsiRemarks',
			align:'left',
			width:200,
			sortable:true
		}
	]);
	
	var InDsItmPagingToolbar = new Ext.PagingToolbar({
		store:InDispItmDs,
		pageSize:15,
		displayInfo:true
	});
	
	var InDispItmGrid = new Ext.ux.GridPanel({
		id : 'InDispItmGrid',
		region:'south',
		height:gGridHeight,
		store:InDispItmDs,
		cm:InDispItmCm,
		trackMouseOver: true,
		stripeRows: true,
		collapsible: true,
		sm:new Ext.grid.RowSelectionModel({singleSelect:false}),
		loadMask: true,
		bbar:InDsItmPagingToolbar
	});

	InDispGrid.getSelectionModel().on('rowselect',function(sm,rowIndex,rec){
		inds = InDispDs.data.items[rowIndex].data["inds"];
		InDispItmDs.setBaseParam('disp',inds);
		InDispItmDs.removeAll();
		InDispItmDs.load({params:{start:0,limit:InDsItmPagingToolbar.pageSize}});
	});
	
	InDispGrid.on('rowdblclick',function(grid,rowIndex,e){
		ds.load({params:{inds:inds}});
		fn(inds);
		findWin.close();
	});
	
	var conPanel = new Ext.ux.FormPanel({
		region:'north',
		labelWidth:60,
		tbar:[fB,'-',cancelFind],
		items:[{
			xtype:'fieldset',
			title:'��ѯ����',
			bodyStyle:'padding:5px 0 0 0;',
			layout:'column',
			items:[
				{columnWidth:.25,layout:'form',items:[startDate,endDate]},
				{columnWidth:.3,layout:'form',items:Loc},
				{columnWidth:.15,layout:'form',items:finish},
				{columnWidth:.15,layout:'form',items:audit}
			]
		}]
	});
	
	if (!findWin)
	{
		var findWin = new Ext.Window({
			title:'���ҿ�����Ա���ŵ�',
			width:gWinWidth,
			height:550, //gWinHeight,
			layout:'border',
			plain:true,
			modal:true,
			bodyStyle:'padding:5px;',
			buttonAlign:'center',
			items:[conPanel,InDispGrid,InDispItmGrid],
			listeners:{
				'render':function(){
					var locRowid=locField.getValue();
					var locDesc=locField.getRawValue();
					Ext.getCmp('Loc').setValue(locRowid);
				}
			}
		});
	}
	
	findWin.show();
	fB.handler();
};
