findReq = function(Fn){
	var url = 'dhcstm.inrequestaction.csp';
	var jReq = "";

	var startDate = new Ext.ux.DateField({
		id:'startDate',
		listWidth:210,
		allowBlank:true,
		fieldLabel:'��ʼ����',
		anchor:'95%',
		value:new Date()
	});

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
		anchor:'95%',
		fieldLabel:'���첿��',
		emptyText:'���첿��...',
		groupId:gGroupId,
		protype : INREQUEST_LOCTYPE,
		linkloc:CtLocId
	});

	var NoTransfer = new Ext.form.Checkbox({
		id: 'NoTransfer',
		fieldLabel:'δת��',
		anchor:'95%',
		allowBlank:true,
		checked:true
	});

	var PartTransfer = new Ext.form.Checkbox({
		id: 'PartTransfer',
		fieldLabel:'����ת��',
		anchor:'95%',
		allowBlank:true,
		checked:true
	});

	var AllTransfer = new Ext.form.Checkbox({
		id: 'AllTransfer',
		fieldLabel:'ȫ��ת��',
		anchor:'95%',
		allowBlank:true
	});

	var Over = new Ext.form.Checkbox({
		id: 'Over',
		fieldLabel:'���',
		allowBlank:true
	});
	
	var fB = new Ext.Toolbar.Button({
		text:'��ѯ',
		tooltip:'��ѯ',
		iconCls:'page_find',
		width : 70,
		height : 30,
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
			
			var toLocId = Ext.getCmp('Loc').getValue();
			if((toLocId=="")||(toLocId==null)){
				Msg.info("error","��ѡ�����첿��!");
				return false;
			}
			var frLocId = toLocId;
			var comp = (Ext.getCmp('Over').getValue()==true?'Y':'N');
			var noTrans = (Ext.getCmp('NoTransfer').getValue()==true?1:0);
			var partTrans = (Ext.getCmp('PartTransfer').getValue()==true?1:0);
			var allTrans = (Ext.getCmp('AllTransfer').getValue()==true?1:0);			
			var tranStatus = noTrans+"%"+partTrans+"%"+allTrans;
			var reclocAudited="";
			var provlocAudited="";
			var reqType='C';  //����ƻ���־
			var strPar = startDate+"^"+endDate+"^"+toLocId+"^"+frLocId+"^"+comp
					+"^"+tranStatus+"^"+reclocAudited+"^"+provlocAudited+"^"+reqType;
			OrderDs2.removeAll();
			OrderDs.removeAll();
			OrderDs.setBaseParam('sort','');
			OrderDs.setBaseParam('dir','desc');
			OrderDs.setBaseParam('strPar',strPar);
			OrderDs.load({params:{start:0,limit:pagingToolbar3.pageSize}});
		}
	});
	
	var cB = new Ext.Toolbar.Button({
		text:'���',
		tooltip:'���',
		iconCls:'page_clearscreen',
		width : 70,
		height : 30,
		handler:function(){
			OrderDs.removeAll();
			OrderDs2.removeAll();
		}
	});
	
	var closeB = new Ext.Toolbar.Button({
		iconCls:'page_delete',
		height:30,
		width:70,
		text:'�ر�',
		tooltip:'�ر�',
		handler:function(){
			findWin.close();
		}
	});
	
	var OrderProxy= new Ext.data.HttpProxy({url:url+'?actiontype=query',method:'GET'});
	var OrderDs = new Ext.data.Store({
		proxy:OrderProxy,
		reader:new Ext.data.JsonReader({
			totalProperty:'results',
			root:'rows'
		}, [
			{name:'req'},
			{name:'reqNo'},
			{name:'toLoc'},
			{name:'toLocDesc'},
			{name:'frLoc'},
			{name:'frLocDesc'},
			{name:'reqUser'},
			{name:'userName'},
			{name:'date'},
			{name:'time'},
			{name:'status'},
			{name:'comp'},
			{name:'remark'},
			{name:'autoSum'}
		]),
		remoteSort: false,
		listeners : {
			load : function(store,records,options){
				if (records.length>0){
					Grid.getSelectionModel().selectFirstRow();
					Grid.getView().focusRow(0);
				}
			}
		}
	});


	var OrderCm = new Ext.grid.ColumnModel([
		new Ext.grid.RowNumberer(),
		{	
			header: 'rowid',
			dataIndex: 'req',
			width: 100,
			hidden:true,
			align: 'left'
		},{
			header: '����',
			dataIndex: 'reqNo',
			width: 100,
			sortable:true,
			align: 'left'
		},{
			header: '���첿��',
			dataIndex: 'toLocDesc',
			width: 100,
			sortable:true,
			align: 'left'
		},{
			header: "��������",
			dataIndex: 'frLocDesc',
			width: 100,
			align: 'left',
			sortable: true,
			hidden:true
		},{
			header: "������",
			dataIndex: 'userName',
			width: 100,
			align: 'left',
			sortable: true
		},{
			header: "����",
			dataIndex: 'date',
			width: 100,
			align: 'left',
			sortable: true
		},{
			header: "ʱ��",
			dataIndex: 'time',
			width: 100,
			align: 'left',
			sortable: true
		},{
			header:'���״̬',
			dataIndex:'comp',
			align:'center',
			width:100,
			sortable:true,
			renderer:function(v, p, record){
				p.css += ' x-grid3-check-col-td';
				return '<div class="x-grid3-check-col'+(((v=='Y')||(v==true))?'-on':'')+' x-grid3-cc-'+this.id+'">&#160;</div>';
			}
		},{
			header: "����״̬",
			dataIndex: 'status',
			width: 100,
			align: 'left',
			renderer:function(value){
				var status="";
				if(value==0){
					status="δת��";
				}else if(value==1){
					status="����ת��";
				}else if(value==2){
					status="ȫ��ת��";
				}
				return status;
			},
			sortable: true
		},{		 
			header:'��ע',
			dataIndex:'remark',
			width:130,
			align:'left'
		},{
			header:'�ѻ���',
			dataIndex:'autoSum',
			align:'center',
			width:100,
			sortable:true,
			renderer:function(v, p, record){
				p.css += ' x-grid3-check-col-td';
				return '<div class="x-grid3-check-col'+(((v=='Y')||(v==true))?'-on':'')+' x-grid3-cc-'+this.id+'">&#160;</div>';
			}
		}
	]);
	
	var pagingToolbar3 = new Ext.PagingToolbar({
		store:OrderDs,
		pageSize:20,
		displayInfo:true,
		displayMsg:'�� {0} ���� {1}�� ��һ�� {2} ��'
	});
	
	var Grid = new Ext.grid.GridPanel({
		region:'center',
		store:OrderDs,
		cm:OrderCm,
		trackMouseOver: true,
		stripeRows: true,
		sm:new Ext.grid.RowSelectionModel({singleSelect:true}),
		loadMask: true,
		height:225,
		bbar:pagingToolbar3
	});
	
	var OrderProxy2= new Ext.data.HttpProxy({url:url+'?actiontype=queryDetail',method:'GET'});
	var OrderDs2 = new Ext.data.Store({
		proxy:OrderProxy2,
		reader:new Ext.data.JsonReader({
			totalProperty:'results',
			root:'rows'
		}, [
			{name:'rowid'},
			{name:'inci'},
			{name:'code'},
			{name:'desc'},
			{name:'qty'},
			{name:'uom'},
			{name:'uomDesc'},
			{name:'spec'},
			{name:'manf'},
			{name:'sp'},
			{name:'spAmt'},
			{name:'generic'},
			{name:'drugForm'},
			{name:'remark'},
			{name:'refuseflag'},
			{name:'provloc'}
			
		]),
		remoteSort: false
	});


	var OrderCm2 = new Ext.grid.ColumnModel([
		new Ext.grid.RowNumberer(),
		{
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
			header: "����",
			dataIndex: 'manf',
			width: 80,
			align: 'left',
			sortable: true
		},{
			header: "����",
			dataIndex: 'qty',
			width: 80,
			align: 'right',
			sortable: true
		},{
			header: "��λ",
			dataIndex: 'uomDesc',
			width: 72,
			align: 'left',
			sortable: true
		},{
			header:'�ۼ�',
			dataIndex:'sp',
			align:'right',
			width:80,
			sortable:true
		},{
			header: "�ۼ۽��",
			dataIndex: 'spAmt',
			width: 80,
			align: 'right',
			sortable: true
		},{
			header:'��ע',
			dataIndex:'remark',
			align:'left',
			width:80,
			sortable:true
		},{
			header:'���',
			dataIndex:'spec',
			align:'left',
			width:80,
			sortable:true
		},{
			header:'�Ƿ�ܾ�',
			dataIndex:'refuseflag',
			align:'left',
			width:80,
			sortable:true
		},{		 
			header:'��Ӧ�ֿ�',
			dataIndex:'provloc',
			width:130,
			align:'left'
		}
	]);
	var pagingToolbar4=new Ext.PagingToolbar({
					store:OrderDs2,
					pageSize:20,
					displayInfo:true,
					displayMsg:'�� {0} ���� {1}�� ��һ�� {2} ��',
					emptyMsg:"û�м�¼"
			});
	
	var Grid2 = new Ext.ux.GridPanel({
		id:'Grid2',
		region:'south',
		store:OrderDs2,
		cm:OrderCm2,
		trackMouseOver: true,
		stripeRows: true,
		sm:new Ext.grid.RowSelectionModel({singleSelect:false}),
		loadMask: true,
		height:225,
		bbar:pagingToolbar4
	});

		Grid.getSelectionModel().on('rowselect',function(sm,rowIndex,rec){
		OrderDs2.removeAll();
		jReq =  OrderDs.data.items[rowIndex].data["req"];
		jReq = jReq;
		OrderDs2.setBaseParam('req',jReq);
		OrderDs2.setBaseParam('sort','rowid');
		OrderDs2.setBaseParam('dir','desc');
		OrderDs2.load({params:{start:0,limit:pagingToolbar4.pageSize}});
	});
	Grid.on('rowdblclick',function(grid,rowIndex,e){
		var rec = OrderDs.data.items[rowIndex];
		req = rec.data["req"];
		Fn(req);
		findWin.close();
	});
	
	var conPanel = new Ext.form.FormPanel({
		region:'north',
		labelwidth:0,
		labelAlign:'right',
		height:140,
		frame:true,
		tbar:[fB,'-',cB,'-',closeB],
		layout:'fit',
		bodyStyle:'padding:5px 0 0 0',
		items:[{
			xtype:'fieldset',
			title:'��ѯ����',
			frame:true,
			autoHeight:true,
			bodyStyle:'padding:0px;',
			labelWidth:60,
			items:[{
				layout:'column',
				items:[
					{columnWidth:.3,layout:'form',items:[startDate,endDate]}
					,
					{columnWidth:.3,layout:'form',items:[/*SupplyLoc,*/ Loc]}
					,
					{columnWidth:.4,layout:'form',items:[{
						defaults:{autoHeight:true},
						layout:'column',
						items:[
							{columnWidth:0.33,layout:'form',items:NoTransfer},
							{columnWidth:0.33,layout:'form',items:PartTransfer},
							{columnWidth:0.33,layout:'form',items:AllTransfer}
						]},
						Over
					]}			
				]
			}]
		}]
	});
	
	var findWin = new Ext.Window({
		title:'��������ƻ���',
		width:1000,	
		height:620,
		minWidth:1000, 
		minHeight:620,
		layout:'border',
		plain:true,
		modal:true,
		bodyStyle:'padding:5px;',
		buttonAlign:'center',
		items:[conPanel,Grid,Grid2]
	});
		
	//��ʾ����
	findWin.show();
};