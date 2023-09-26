FindINAdj = function(ds,adjNumField,mainRowId,locField,dateField,addB,finshCK,auditCK,fn){
	var url = 'dhcstm.inadjaction.csp';
	var adj = "";
	//��ʼ����
	var startDate = new Ext.ux.DateField({
		id:'startDate',
		listWidth:210,
		allowBlank:true,
		fieldLabel:'��ʼ����',
		anchor:'95%',
		value:new Date()
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
		groupId:gGroupId
	});
	
	var finsh = new Ext.form.Checkbox({
		id: 'finsh',
		hideLabel : true,
		boxLabel:'���',
		anchor:'95%',
		allowBlank:true
	});

	var audit = new Ext.form.Checkbox({
		id: 'audit',
		hideLabel : true,
		boxLabel:'���',
		anchor:'95%',
		allowBlank:true
	});
	
	var InadjProxy= new Ext.data.HttpProxy({url:url+'?actiontype=query',method:'GET'});
	var InadjDs = new Ext.data.Store({
		proxy:InadjProxy,
		reader:new Ext.data.JsonReader({
			totalProperty:'results',
			root:'rows'
		}, [
			{name:'adj'},
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
			{name:'stkType'}
		]),
		remoteSort: false
	});

	
	var InadjCm = new Ext.grid.ColumnModel([
		new Ext.grid.RowNumberer(),
		{
			header: '������rowid',
			dataIndex: 'adj',
			hidden:true
		},{
			header: '��������',
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
			header: "��������",
			dataIndex: 'date',
			width: 150,
			align: 'left',
			sortable: true
		},{
			header: "scg",
			dataIndex: 'scg',
			width: 150,
			align: 'center',
			hidden:true
		},
		{
			header: "����",
			dataIndex: 'scgDesc',
			width: 60,
			align: 'left',
			sortable: true
		},
		{
			header: "���",
			dataIndex: 'comp',
			width: 100,
			align: 'center',
			sortable: true,
			renderer:function(v, p, record){
				p.css += ' x-grid3-check-col-td';
				return '<div class="x-grid3-check-col'+(((v=='Y')||(v==true))?'-on':'')+' x-grid3-cc-'+this.id+'">&#160;</div>';
			}
		},{
			header: "���",
			dataIndex: 'chkFlag',
			width: 100,
			align: 'center',
			sortable: true,
			renderer:function(v, p, record){
				p.css += ' x-grid3-check-col-td';
				return '<div class="x-grid3-check-col'+(((v=='Y')||(v==true))?'-on':'')+' x-grid3-cc-'+this.id+'">&#160;</div>';
			}
		}
	]);

	var InadjPagingToolbar = new Ext.PagingToolbar({
		store:InadjDs,
		pageSize:15,
		id:'adjGrid',
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
			
			var finsh = (Ext.getCmp('finsh').getValue()==true?'Y':'N');
			var audit = (Ext.getCmp('audit').getValue()==true?'Y':'N');
			
			var strPar = startDate+"^"+endDate+"^"+locId+"^"+audit+"^"+finsh;
			InadjDs.setBaseParam('strParam',strPar);
			InadjDs.removeAll();
			InadjItmDs.removeAll();
			InadjDs.load({
				params:{start:0,limit:InadjPagingToolbar.pageSize,sort:'NO',dir:'desc'},
				callback:function(r,options,success){
					if (InadjDs.getCount()>0){
						InadjGrid.getSelectionModel().selectFirstRow();
						InadjGrid.getView().focusRow(0);
					}
				}
			})
	
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
		}
	})
	
	var InadjGrid = new Ext.grid.GridPanel({
		region:'center',
		store:InadjDs,
		cm:InadjCm,
		trackMouseOver: true,
		stripeRows: true,
		sm:new Ext.grid.RowSelectionModel({singleSelect:false}),
		loadMask: true,
		height:225,
		bbar:InadjPagingToolbar
	});
	
	var InadjItmProxy= new Ext.data.HttpProxy({url:url+'?actiontype=queryItem',method:'GET'});
	var InadjItmDs = new Ext.data.Store({
		proxy:InadjItmProxy,
		reader:new Ext.data.JsonReader({
			totalProperty:'results',
			root:'rows'
		}, [
			{name:'adjitm'},
			{name:'inclb'},
			{name:'inci'},
			{name:'code'},
			{name:'desc'},
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
			{name:'insti'}
		]),
		remoteSort: false
	});


	var InadjItmCm = new Ext.grid.ColumnModel([
		new Ext.grid.RowNumberer(),
		{
			header: '��ϸrowid',
			dataIndex: 'adjitm',
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
			width: 140,
			sortable:true,
			align: 'left'
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
			header:'���',
			dataIndex:'spec',
			align:'left',
			width:80,
			sortable:true
		}
	]);
	
	var InadjItmPagingToolbar = new Ext.PagingToolbar({
		store:InadjItmDs,
		pageSize:15,
		id:'adjItmGrid',
		displayInfo:true
	});
	
	var InadjItmGrid = new Ext.grid.GridPanel({
		region:'south',
		height:gGridHeight,
		store:InadjItmDs,
		cm:InadjItmCm,
		trackMouseOver: true,
		stripeRows: true,
		sm:new Ext.grid.RowSelectionModel({singleSelect:false}),
		loadMask: true,
		bbar:InadjItmPagingToolbar
	});

	InadjGrid.getSelectionModel().on('rowselect',function(sm,rowIndex,rec){
		adj = InadjDs.data.items[rowIndex].data["adj"];
 		mainRowId = adj;
 		InadjItmDs.setBaseParam('adj',adj);
 		InadjItmDs.removeAll();
		InadjItmDs.load({params:{start:0,limit:InadjItmPagingToolbar.pageSize}});
	});		
	
	InadjGrid.on('rowdblclick',function(grid,rowIndex,e){
		ds.load({params:{adj:adj}});
		SetMain(adj);
		fn(adj)		
		/*
		adjNumField.setValue(InadjDs.data.items[rowIndex].data["no"]);
		groupField.setValue(InadjDs.data.items[rowIndex].data["scg"]);
		
		
		locField.setValue(InadjDs.data.items[rowIndex].data["loc"]);
		locField.setRawValue(InadjDs.data.items[rowIndex].data["locDesc"]);
		dateField.setValue(InadjDs.data.items[rowIndex].data["date"]);
		//alert(InadjDs.data.items[rowIndex].data["comp"]);
		
		//��ɱ�־
		if(InadjDs.data.items[rowIndex].data["comp"]=="Y"){
			finshCK.setValue(true);
			//addB.disable();
		}else{
			finshCK.setValue(false);
		}
		//��˱�־
		if(InadjDs.data.items[rowIndex].data["chkFlag"]=="Y"){
			auditCK.setValue(true);
			//addB.disable();
		}else{
			auditCK.setValue(false);
		}
		//����
		//Ext.getCmp('').setValue(InadjDs.data.items[rowIndex].data["scg"])
		
		*/
		
		findWin.close();
	});
	
	var conPanel = new Ext.ux.FormPanel({
		tbar:[fB,'-',cancelFind],
		labelWidth : 60,
		items:[{
			xtype:'fieldset',
			title:'��ѯ����',
			items:[{
				layout:'column',
				items:[
					{columnWidth:.3,layout:'form',items:Loc},
					{columnWidth:.2,layout:'form',items:startDate},
					{columnWidth:.2,layout:'form',items:endDate},
					{columnWidth:.15,layout:'form',items:finsh},
					{columnWidth:.15,layout:'form',items:audit}
				]
			}]
		}]
	});
	
	var findWin = new Ext.ux.Window({
		title:'���ҿ�������',
		layout:'border',
		items:[conPanel,InadjGrid,InadjItmGrid],
		listeners:{
			'render':function(){
				var locRowid=locField.getValue();
				var locDesc=locField.getRawValue();
				Ext.getCmp('Loc').setValue(locRowid);
			}
		}
	});
		
	//��ʾ����
	findWin.show();
};

function SetMain(adj){
	mainRowId=adj;
}
