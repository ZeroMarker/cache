findReqSplit = function(Fn){
	//var ctLocId = session['LOGON.CTLOCID'];
	//var Arr = window.status.split(":");
	//var length = Arr.length;
	var url = 'dhcstm.inrequestaction.csp';
	var jReq = "";
	//��ʼ����
	var startDateSplit = new Ext.ux.DateField({
		id:'startDateSplit',
		//width:210,
		listWidth:210,
		allowBlank:true,
		fieldLabel:'��ʼ����',
		anchor:'95%',
		value:new Date()
	});
	//��ֹ����
	var endDateSplit = new Ext.ux.DateField({
		id:'endDateSplit',
		//width:210,
		listWidth:210,
		allowBlank:true,
		fieldLabel:'��ֹ����',
		anchor:'95%',
		value:new Date()
	});
	
	var LocSplit = new Ext.ux.LocComboBox({
		id:'LocSplit',
		anchor:'95%',
		fieldLabel:'���첿��',
		emptyText:'���첿��...',
		groupId:gGroupId
	});
	/*
	GetGroupDeptStore.load();
	GetGroupDeptStore.on('load',function(ds,records,o){
		Ext.getCmp('Loc').setRawValue(Arr[length-1]);
		Ext.getCmp('Loc').setValue(ctLocId);
	});	
	*/
	/*
	var SupplyLoc = new Ext.ux.LocComboBox({
		id:'SupplyLoc',
		fieldLabel:'��������',
		anchor:'95%',
		emptyText:'��������...',
		defaultLoc:{}
	});
	*/

//	var SupplyLoc = new Ext.ux.ComboBox({
//		id:'SupplyLoc',
//		fieldLabel:'��������',
//		anchor:'95%',
//		store:frLocListStore,
//		displayField:'Description',
//		valueField:'RowId',
//		listWidth:210,
//		emptyText:'��������...',
//		params:{LocId:'Loc'}
//	});

	var NoTransferSplit = new Ext.form.Checkbox({
		id: 'NoTransferSplit',
		fieldLabel:'δת��',
		anchor:'95%',
		allowBlank:true,
		checked:true
	});

	var PartTransferSplit = new Ext.form.Checkbox({
		id: 'PartTransferSplit',
		fieldLabel:'����ת��',
		anchor:'95%',
		allowBlank:true,
		checked:true
	});

	var AllTransferSplit = new Ext.form.Checkbox({
		id: 'AllTransferSplit',
		fieldLabel:'ȫ��ת��',
		anchor:'95%',
		allowBlank:true
	});

	var OverSplit = new Ext.form.Checkbox({
		id: 'OverSplit',
		fieldLabel:'���',
		allowBlank:true
	});
	
	var fBSplit = new Ext.Toolbar.Button({
		text:'��ѯ',
		tooltip:'��ѯ',
		iconCls:'page_find',
		width : 70,
		height : 30,
		handler:function(){
			var startDate = Ext.getCmp('startDateSplit').getValue();
			if((startDate!="")&&(startDate!=null)){
				startDate = startDate.format(ARG_DATEFORMAT);
			}else{
				Msg.info("error","��ѡ����ʼ����!");
				return false;
			}
			var endDate = Ext.getCmp('endDateSplit').getValue();
			if((endDate!="")&&(endDate!=null)){
				endDate = endDate.format(ARG_DATEFORMAT);
			}else{
				Msg.info("error","��ѡ���ֹ����!");
				return false;
			}
			
			var toLocId = Ext.getCmp('LocSplit').getValue();
			if((toLocId=="")||(toLocId==null)){
				Msg.info("error","��ѡ�����첿��!");
				return false;
			}
//			var frLocId = Ext.getCmp('SupplyLoc').getValue();
			var frLocId = toLocId;
			var comp = (Ext.getCmp('OverSplit').getValue()==true?'Y':'N');
			
			var noTrans = (Ext.getCmp('NoTransferSplit').getValue()==true?1:0);
			var partTrans = (Ext.getCmp('PartTransferSplit').getValue()==true?1:0);
			var allTrans = (Ext.getCmp('AllTransferSplit').getValue()==true?1:0);
			
			var tranStatus = noTrans+"%"+partTrans+"%"+allTrans;
			
			var reclocAudited="";
			var provlocAudited="";
			var reqType='C';  //����ƻ���־
			
			var strPar = startDate+"^"+endDate+"^"+toLocId+"^"+frLocId+"^"+comp
					+"^"+tranStatus+"^"+reclocAudited+"^"+provlocAudited+"^"+reqType;
//			alert(strPar)
			OrderDs2Split.removeAll();
			OrderDsSplit.removeAll();
			OrderDsSplit.setBaseParam('sort','');
			OrderDsSplit.setBaseParam('dir','desc');
			OrderDsSplit.setBaseParam('strPar',strPar);
			OrderDsSplit.load({params:{start:0,limit:pagingToolbar3Split.pageSize}});
		}
	});
	
	var cBSplit = new Ext.Toolbar.Button({
		text:'���',
		tooltip:'���',
		iconCls:'page_clearscreen',
		width : 70,
		height : 30,
		handler:function(){
			OrderDsSplit.removeAll();
			RelateDsSplit.removeAll();
			OrderDs2Split.removeAll();
		}
	});
	
	var closeBSplit = new Ext.Toolbar.Button({
		iconCls:'page_delete',
		height:30,
		width:70,
		text:'�ر�',
		tooltip:'�ر�',
		handler:function(){
			findWinSplit.close();
		}
	});
	
	var OrderProxySplit= new Ext.data.HttpProxy({url:url+'?actiontype=query',method:'GET'});
	var OrderDsSplit = new Ext.data.Store({
		proxy:OrderProxySplit,
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
			{name:'remark'}
		]),
		remoteSort: false,
		listeners : {
			load : function(store,records,options){
				if (records.length>0){
					GridSplit.getSelectionModel().selectFirstRow();
					GridSplit.getView().focusRow(0);
				}
			}
		}
	});


	var OrderCmSplit = new Ext.grid.ColumnModel([
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
		}
	]);
	
	var pagingToolbar3Split = new Ext.PagingToolbar({
		store:OrderDsSplit,
		pageSize:20,
		displayInfo:true,
		displayMsg:'�� {0} ���� {1}�� ��һ�� {2} ��'
	});
	
	var GridSplit = new Ext.grid.GridPanel({
		title:'���쵥',
		region:'center',
		store:OrderDsSplit,
		cm:OrderCmSplit,
		trackMouseOver: true,
		stripeRows: true,
		sm:new Ext.grid.RowSelectionModel({singleSelect:true}),
		loadMask: true,
		height:225,
		bbar:pagingToolbar3Split
	});
	var RelateDsSplit = new Ext.data.JsonStore({
		url:url+'?actiontype=QueryRelate',
		totalProperty:'results',
		root:'rows',
		fields:[
			{name:'req'},
			{name:'reqNo'},
			{name:'toLoc'},
			{name:'toLocDesc'},
			{name:'frLoc'},
			{name:'frLocDesc'},
			{name:'date'},
			{name:'time'},
			{name:'remark'},
			{name:'comp'}
		],
		listeners : {
			load : function(store,records,options){
				if (records.length>0){
					RelateGridSplit.getSelectionModel().selectFirstRow();
					RelateGridSplit.getView().focusRow(0);
				}
			}
		}
		
	}
	
	);


	var RelateCmSplit = new Ext.grid.ColumnModel([
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
			width: 150,
			sortable:true,
			align: 'left'
		},{
			header: "��������",
			dataIndex: 'frLocDesc',
			width: 120,
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
			header:'��ע',
			dataIndex:'remark',
			width:130,
			align:'left'
		}
	]);
	
	var pagingToolbar5Split = new Ext.PagingToolbar({
		store:RelateDsSplit,
		pageSize:PageSize,
		displayInfo:true,
		displayMsg:'�� {0} ���� {1}�� ��һ�� {2} ��'
	});
	
	var RelateGridSplit = new Ext.grid.GridPanel({
		title:'��ֺ���깺�ƻ�',
		region:'east',
		store:RelateDsSplit,
		cm:RelateCmSplit,
		trackMouseOver: true,
		stripeRows: true,
		sm:new Ext.grid.RowSelectionModel({singleSelect:true}),
		loadMask: true,
		width:500,
		bbar:pagingToolbar5Split
	});
	function cancelSplit(reqi)
	{		
		Ext.Ajax.request({
			url:url+'?actiontype=Cancel',
			params:{reqi:reqi,userId:session['LOGON.USERID']},
			success:function(result)
			{
				var jsonData = Ext.util.JSON.decode(result.responseText.replace(/\r/g,"").replace(/\n/g,"")); 
				if (jsonData.success=='true')
				{
					Msg.info('success','�����ɹ�.'); 
					OrderDs2Split.reload()
				}
				else
				{
					var msg=jsonData.info
					if(msg==1){Msg.info('error','�����Ѵ���,���ܳ���!');} 
					if(msg==2){Msg.info('error','�����Ѵ���,���ܳ���!');} 
					if(msg==-1){Msg.info('error','�����ѳ���,�����ظ�����!');} 
			    }
			}
			
		});
	}
	var OrderProxy2Split= new Ext.data.HttpProxy({url:url+'?actiontype=queryDetail',method:'GET'});
	var OrderDs2Split = new Ext.data.Store({
		proxy:OrderProxy2Split,
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
			{name:'provloc'},
			{name:'INRQICanceled'},
			{name:'INRQIType'}
			
		]),
		remoteSort: false
	});


	var OrderCm2Split = new Ext.grid.ColumnModel([
		new Ext.grid.RowNumberer(),
		{
			header: '',
			dataIndex: 'rowid',
			width: 72,
			sortable:true,
			hidden:true,
			align: 'left'
		},{
			header: '����',
			dataIndex: 'code',
			width: 72,
			sortable:true,
			align: 'left'
		},{
			header: '��ť',
			dataIndex:'button',
			id:'button',
			width: 70,
			align: 'center',
			renderer: function (value, cellmeta) { return "<input type='button' value='����'>";}
		},{
			header:'�Ƿ���',
			dataIndex:'INRQICanceled',
			align:'left',
			width:80,
			sortable:true
		},{
			header:'����',
			dataIndex:'INRQIType',
			align:'left',
			width:80,
			sortable:true
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
		},/*{
			header:'ͨ����',
			dataIndex:'generic',
			align:'left',
			width:80,
			sortable:true
		},{
			header:'����',
			dataIndex:'drugForm',
			align:'left',
			width:80,
			sortable:true
		},*/{
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
	var pagingToolbar4Split=new Ext.PagingToolbar({
					store:OrderDs2Split,
					pageSize:20,
					displayInfo:true,
					displayMsg:'�� {0} ���� {1}�� ��һ�� {2} ��',
					emptyMsg:"û�м�¼"
			});
	
	var Grid2Split = new Ext.grid.GridPanel({
		id:'Grid2Split',
		region:'south',
		store:OrderDs2Split,
		cm:OrderCm2Split,
		trackMouseOver: true,
		stripeRows: true,
		sm:new Ext.grid.RowSelectionModel({singleSelect:false}),
		loadMask: true,
		height:225,
		bbar:pagingToolbar4Split,
		listeners:{
		'cellclick':function(grid,rowIndex,columnIndex,e){
			var cIndex=OrderCm2Split.getIndexById('button')
			var reqi=OrderDs2Split.getAt(rowIndex).get('rowid');
			if(cIndex==columnIndex)
			{
				cancelSplit(reqi)
			}
					}
		}
	});

		GridSplit.getSelectionModel().on('rowselect',function(sm,rowIndex,rec){
		//OrderDs2.removeAll();
		jReq =  OrderDsSplit.data.items[rowIndex].data["req"];
		jReq = jReq;
		//OrderDs2.setBaseParam('req',jReq);
		//OrderDs2.setBaseParam('sort','rowid');
		//OrderDs2.setBaseParam('dir','desc');
		//OrderDs2.load({params:{start:0,limit:pagingToolbar4.pageSize}});
		RelateDsSplit.setBaseParam('req',jReq);
		RelateDsSplit.load({params:{start:0,limit:pagingToolbar5Split.pageSize}});
	});
	RelateGridSplit.getSelectionModel().on('rowselect',function(sm,rowIndex,rec){
		OrderDs2Split.removeAll();
		var Req =  RelateDsSplit.data.items[rowIndex].data["req"];
		OrderDs2Split.setBaseParam('req',Req);
		OrderDs2Split.setBaseParam('sort','rowid');
		OrderDs2Split.setBaseParam('dir','desc');
		OrderDs2Split.load({params:{start:0,limit:pagingToolbar4Split.pageSize}});
	});
	GridSplit.on('rowdblclick',function(grid,rowIndex,e){
		var rec = OrderDsSplit.data.items[rowIndex];
		req = rec.data["req"];
		Fn(req);
		findWinSplit.close();
//		if((rec.data["comp"]=='N')||(rec.data["comp"]==null)||(rec.data["comp"]=="")){
//			complete.enable();
//			add.enable();
//		}
	});
	
	var conPanelSplit = new Ext.form.FormPanel({
		region:'north',
		labelwidth:0,
		labelAlign:'right',
		height:140,
		autoHeight: true, 
		frame:true,
		tbar:[fBSplit,'-',cBSplit,'-',closeBSplit],
		layout:'fit',
		bodyStyle:'padding:5px 0 0 0',
		items:[{
			xtype:'fieldset',
			title:'��ѯ����',
			//width:960,
			//height:73,
			frame:true,
			autoHeight:true,
			bodyStyle:'padding:0px;',
			labelWidth:60,
			items:[{
				layout:'column',
				items:[
					{columnWidth:.3,layout:'form',items:[startDateSplit,endDateSplit]}
					,
					{columnWidth:.3,layout:'form',items:[/*SupplyLoc,*/ LocSplit]}
					,
					{columnWidth:.4,layout:'form',items:[{
						defaults:{autoHeight:true},
						layout:'column',
						items:[
//							{columnWidth:0.33,layout:'form',items:NoTransfer},
//							{columnWidth:0.33,layout:'form',items:PartTransfer},
//							{columnWidth:0.33,layout:'form',items:AllTransfer}
						]},
						OverSplit
					]}			
				]
			}]
		}]
	});
	
	var findWinSplit = new Ext.Window({
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
		items:[conPanelSplit,GridSplit,Grid2Split,RelateGridSplit]
	});
		
	//��ʾ����
	findWinSplit.show();
};