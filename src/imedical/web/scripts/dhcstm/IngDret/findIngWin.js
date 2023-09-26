findIngDret = function(){
	//��ʼ����
	var startDate = new Ext.ux.DateField({
		id:'startDate',
		listWidth:210,
		allowBlank:true,
		fieldLabel:'��ʼ����',
		anchor:'90%',
		value:DefaultStDate()
	});
	//��ֹ����
	var endDate = new Ext.ux.DateField({
		id:'endDate',
		listWidth:210,
		allowBlank:true,
		fieldLabel:'��ֹ����',
		anchor:'90%',
		value:DefaultEdDate()
		//,
		//editable:false
	});

	var completFlag = new Ext.grid.CheckColumn({
		header:'��ɱ�־',
		dataIndex:'completed',
		anchor:'90%',
		sortable:true,
		align: 'center',
		renderer:function(v, p, record){
			p.css += ' x-grid3-check-col-td';
			return '<div class="x-grid3-check-col'+(((v=='Y')||(v==true))?'-on':'')+' x-grid3-cc-'+this.id+'">&#160;</div>';
		}
	});
			
	var auditFlag = new Ext.grid.CheckColumn({
		header:'��˱�־',
		dataIndex:'auditFlag',
		anchor:'90%',
		sortable:true,
		align: 'center',
		renderer:function(v, p, record){
			p.css += ' x-grid3-check-col-td';
			return '<div class="x-grid3-check-col'+(((v=='Y')||(v==true))?'-on':'')+' x-grid3-cc-'+this.id+'">&#160;</div>';
		}
	});

	var Vendor2 = new Ext.ux.VendorComboBox({
		fieldLabel : '��Ӧ��',
		id : 'Vendor2',
		name : 'Vendor2',
		anchor:'90%',
		params : {LocId : 'locField'}
	});

	var chkComplete=new Ext.form.Checkbox({
		fieldLabel:'�������',
		id:'completed',
		name:'completed',
		anchor:'90%'
	});
	
	var OrderProxy= new Ext.data.HttpProxy({url:URL+'?actiontype=selectOrder',method:'GET'});
	var OrderDs = new Ext.data.Store({
		proxy:OrderProxy,
		reader:new Ext.data.JsonReader({
			totalProperty:'results',
			root:'rows'}, [
			'ingrt','vendor','vendorName','loc',
			'locDesc','ingrtNo','retDate','retTime',
			'retUser','retUserName','auditDate','auditTime',
			'auditUser','auditUserName','auditFlag','completed',
			'adjCheque','scg','scgDesc'
		]),
		listeners:{
			load : function(store,records,options){
				if (records.length>0){
					Grid.getSelectionModel().selectFirstRow();
					Grid.getView().focusRow(0);
				}
			}
		},
		remoteSort: false
	});

	var OrderCm = new Ext.grid.ColumnModel([
		new Ext.grid.RowNumberer(),
		{
			header:'ingrt',
			dataIndex:'ingrt',
			hidden:true
		},{
			header: '�˻�����',
			dataIndex: 'ingrtNo',
			width: 120,
			sortable:true,
			align: 'center'
		},{
			header: '��Ӧ��',
			dataIndex: 'vendorName',
			width: 200,
			sortable:true,
			align: 'left'
		},{
			header: "����",
			dataIndex: 'retDate',
			width: 120,
			align: 'center',
			sortable: true
		},{
			header:'��ɱ�־',
			dataIndex:'completed',
			align:'center',
			width:120,
			sortable:true,
			xtype : 'checkcolumn'
		},{
			header: "������",
			dataIndex: 'retUserName',
			width: 120,
			align: 'center',
			sortable: true
		},{
			header:'��˱�־',
			dataIndex:'auditFlag',
			align:'center',
			width:120,
			sortable:true,
			xtype:'checkcolumn'
		}
	]);

	var pagingToolbar = new Ext.PagingToolbar({
		store:OrderDs,
		pageSize:20,
		displayInfo:true,
		displayMsg:'�� {0} ���� {1}�� ��һ�� {2} ��',
		emptyMsg:"û�м�¼"
	});

	var Grid = new Ext.grid.GridPanel({
		region:'center',
		store:OrderDs,
		cm:OrderCm,
		trackMouseOver: true,
		stripeRows: true,
		sm:new Ext.grid.RowSelectionModel({
			singleSelect:true,
			listeners : {
				rowselect : function(sm,rowIndex,record){
					var Ingrt = record.get("ingrt");
					var PageSize = DetailPagingToolbar.pageSize;
					DetailStore.setBaseParam('ret',Ingrt);
					DetailStore.removeAll();
					DetailStore.load({params:{start:0,limit:PageSize,sort:'',dir:'Desc'}});
				}
			}
		}),
		loadMask: true,
		bbar:pagingToolbar,
		listeners : {
			rowdblclick : function(grid,rowIndex,e){
				var ingrt=OrderDs.data.items[rowIndex].data["ingrt"];
				Select(ingrt);
				IngDretDetailGridDs.load({params:{start:0,limit:999,sort:'',dir:'asc',ret:ingrt}});
				findWin.close();
			}
		}
	});
	
	var DetailProxy= new Ext.data.HttpProxy({url:URL+'?actiontype=select',method:'POST'});
	var DetailStore = new Ext.data.Store({
		proxy:DetailProxy,
		reader:new Ext.data.JsonReader({
			totalProperty:'results',
			root:'rows'}, [
			'ingrti','ingri','manf','inclb','uomDesc',
			'qty','rp','rpAmt','sp','spAmt','invNo',
			{name:'invDate',type:'date',dateFormat:DateFormat},
			'invAmt','sxNo','code','desc','spec',
			'batNo','expDate','retReason','stkqty',
			'HVFlag','HVBarCode'
		]),
		remoteSort: false
	});

	var DetailCm = new Ext.grid.ColumnModel([
		new Ext.grid.RowNumberer(),
		{
			header:"�˻��ӱ�rowid",
			dataIndex:'ingrti',
			width:80,
			align:'left',
			sortable:true,
			hidden:true
		},{
			header:"����ӱ�rowid",
			dataIndex:'ingri',
			width:80,
			align:'left',
			sortable:true,
			hidden:true
		},{
			header:"����DR",
			dataIndex:'inclb',
			width:80,
			align:'left',
			sortable:true,
			hidden:true
		},{
			header:"���ʴ���",
			dataIndex:'code',
			width:100,
			align:'left',
			sortable:true
		},{
			header:"��������",
			dataIndex:'desc',
			id:'desc',
			width:200,
			align:'left',
			sortable:true
		},{
			header:"��ֵ��־",
			dataIndex:'HVFlag',
			width:60,
			align:'center',
			sortable:true,
			hidden:true
		},{
			header:"��ֵ����",
			dataIndex:'HVBarCode',
			id:'HVBarCode',
			width:200,
			align:'left',
			sortable:true
		},{
			header:"����",
			dataIndex:'manf',
			width:200,
			align:'left',
			sortable:true
		},{
			header:"���",
			dataIndex:'spec',
			width:100,
			align:'left',
			sortable:true
		},{
			header:"���ο��",
			dataIndex:'stkqty',
			width:100,
			align:'left',
			sortable:true
		},{
			header:"�˻�����",
			dataIndex:'qty',
			width:100,
			id:'qty',
			align:'right',
			sortable:true
		},{
			header:"�˻���λ",
			dataIndex:'uomDesc',
			id:'uomDesc',
			width:100,       
			align:'left',
			sortable:true
		},{
			header:"�˻�ԭ��",
			dataIndex:'retReason',
			width:100,
			id:'retReason',
			align:'left',
			sortable:true
		},{
			header:"�˻�����",
			dataIndex:'rp',
			width:100,
			align:'right',
			sortable:true
		},{
			header:"�˻����۽��",
			dataIndex:'rpAmt',
			width:100,
			align:'right',
			sortable:true
		},{
			header:"�ۼ�",
			dataIndex:'sp',
			width:100,
			align:'right',
			sortable:true
		},{
			header:"�˻��ۼ۽��",
			dataIndex:'spAmt',
			width:100,
			align:'right',
			sortable:true
		},{
			header:"����",
			dataIndex:'batNo',
			width:100,
			align:'left',
			sortable:true
		},{
			header:"Ч��",
			dataIndex:'expDate',
			width:100,
			align:'left',
			sortable:true
		},{
			header:"��Ʊ��",
			dataIndex:'invNo',
			id:'invNo',
			width:100,
			align:'left',
			sortable:true
		},{
			header:"��Ʊ����",
			dataIndex:'invDate',
			id:'invDate',
			width:100,
			align:'left',
			sortable:true
		},{
			header:"�˷�Ʊ���",
			dataIndex:'invAmt',
			id:'invAmt',
			width:100,
			align:'right',
			sortable:true
		},{
			header:"���е���",
			dataIndex:'sxNo',
			id:'sxNo',
			width:100,
			align:'left',
			sortable:true
		}
	]);

	var DetailPagingToolbar = new Ext.PagingToolbar({
		store:DetailStore,
		pageSize:20,
		displayInfo:true,
		displayMsg:'�� {0} ���� {1}�� ��һ�� {2} ��',
		emptyMsg:"û�м�¼"
	});	
	
	var DetailGrid = new Ext.grid.GridPanel({
		id:'DetailGrid',
		store:DetailStore,
		cm:DetailCm,
		trackMouseOver: true,
		stripeRows: true,
		sm:new Ext.grid.RowSelectionModel({singleSelect:true}),
		loadMask: true,
		bbar:DetailPagingToolbar
	});

	handler = function(){
		var startDate = Ext.getCmp('startDate').getValue();
		if((startDate!="")&&(startDate!=null)){startDate = startDate.format(ARG_DATEFORMAT);}
		var endDate = Ext.getCmp('endDate').getValue();
		if((endDate!="")&&(endDate!=null)){endDate = endDate.format(ARG_DATEFORMAT);}
		var vorId = Ext.getCmp('Vendor2').getValue();
		if((startDate=="")||(startDate==null)){
			Msg.info("error","��ѡ����ʼ����!");
			return false;
		}
		if((endDate=="")||(endDate==null)){
			Msg.info("error","��ѡ���ֹ����!");
			return false;
		}
		/*
		if((vorId=="")||(vorId==null)){
			Msg.info("error","��ѡ��Ӧ��!");
			return false;
		} */
		var locField = Ext.getCmp("locField").getValue();
		if((locField=="")||(locField==null)){
			Msg.info("error","��ѡ�����!");
			return false;
		}
		var complete="";
		if (chkComplete.getValue()==true)
		{complete="Y"}
		//else
		//{complete="N"}
		
		//strPar - ������(��ʼ����^��ֹ����^����Id^��Ӧ��Id^^�������)
		var strPar=startDate+"^"+endDate+"^"+locField+"^"+vorId+"^^"+complete
		OrderDs.setBaseParam('sort','ingrt');
		OrderDs.setBaseParam('dir','desc');
		OrderDs.setBaseParam('strPar',strPar);
		OrderDs.load({params:{start:0,limit:pagingToolbar.pageSize}});
	};

	var fB = new Ext.Toolbar.Button({
		text:'��ѯ',
		tooltip:'��ѯ',
		iconCls:'page_find',
		width : 70,
		height : 30,
		handler : handler
	});
	var xB=new Ext.Toolbar.Button({
		text:'�ر�',
		tooltip:'�ر�',
		iconCls:'page_delete',
		width : 70,
		height : 30,
		handler:function(){
			findWin.close();
		}
	});
	
	var conPanel = new Ext.form.FormPanel({
		labelwidth: 60,
		autoScroll: true,
		labelAlign: 'right',
		autoHeight: true, 
		frame: true,
		tbar : [fB, '-',xB ],
		layout: 'fit',
		items:[{
			title : '��ѯ����',
			xtype: 'fieldset',
			autoHeight: true,
			//style: 'padding:5px 0px 0px 0px',
			bodyStyle:'padding:0px;',
			layout: 'column',
			items:[
				{columnWidth:.25,layout:'form',items:[startDate]},
				{columnWidth:.25,layout:'form',items:[endDate]},
				{columnWidth:.25,layout:'form',items:[Vendor2]},
				{columnWidth:.25,layout:'form',items:[chkComplete]}
			]
		}]
	});
	
	var findWin = new Ext.Window({
		title:'�����˻���',
		width:1000,
		height:550,
		layout:'border',
		plain:true,
		modal:true,
		items:[{
				region:'north',
				height: 120,
				items:conPanel
			},{
				title: '�˻���',
				region: 'center',
				layout: 'fit',
				items: Grid
			},{
				region: 'south',
				title: '�˻�����ϸ',
				height: 200,
				layout: 'fit',
				items: DetailGrid
			}]
	});
		
	//��ʾ����
	findWin.show();
};