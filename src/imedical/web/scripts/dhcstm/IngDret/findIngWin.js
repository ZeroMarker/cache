findIngDret = function(){
	//起始日期
	var startDate = new Ext.ux.DateField({
		id:'startDate',
		listWidth:210,
		allowBlank:true,
		fieldLabel:'起始日期',
		anchor:'90%',
		value:DefaultStDate()
	});
	//截止日期
	var endDate = new Ext.ux.DateField({
		id:'endDate',
		listWidth:210,
		allowBlank:true,
		fieldLabel:'截止日期',
		anchor:'90%',
		value:DefaultEdDate()
		//,
		//editable:false
	});

	var completFlag = new Ext.grid.CheckColumn({
		header:'完成标志',
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
		header:'审核标志',
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
		fieldLabel : '供应商',
		id : 'Vendor2',
		name : 'Vendor2',
		anchor:'90%',
		params : {LocId : 'locField'}
	});

	var chkComplete=new Ext.form.Checkbox({
		fieldLabel:'仅已完成',
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
			header: '退货单号',
			dataIndex: 'ingrtNo',
			width: 120,
			sortable:true,
			align: 'center'
		},{
			header: '供应商',
			dataIndex: 'vendorName',
			width: 200,
			sortable:true,
			align: 'left'
		},{
			header: "日期",
			dataIndex: 'retDate',
			width: 120,
			align: 'center',
			sortable: true
		},{
			header:'完成标志',
			dataIndex:'completed',
			align:'center',
			width:120,
			sortable:true,
			xtype : 'checkcolumn'
		},{
			header: "操作人",
			dataIndex: 'retUserName',
			width: 120,
			align: 'center',
			sortable: true
		},{
			header:'审核标志',
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
		displayMsg:'第 {0} 条到 {1}条 ，一共 {2} 条',
		emptyMsg:"没有记录"
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
			header:"退货子表rowid",
			dataIndex:'ingrti',
			width:80,
			align:'left',
			sortable:true,
			hidden:true
		},{
			header:"入库子表rowid",
			dataIndex:'ingri',
			width:80,
			align:'left',
			sortable:true,
			hidden:true
		},{
			header:"批次DR",
			dataIndex:'inclb',
			width:80,
			align:'left',
			sortable:true,
			hidden:true
		},{
			header:"物资代码",
			dataIndex:'code',
			width:100,
			align:'left',
			sortable:true
		},{
			header:"物资名称",
			dataIndex:'desc',
			id:'desc',
			width:200,
			align:'left',
			sortable:true
		},{
			header:"高值标志",
			dataIndex:'HVFlag',
			width:60,
			align:'center',
			sortable:true,
			hidden:true
		},{
			header:"高值条码",
			dataIndex:'HVBarCode',
			id:'HVBarCode',
			width:200,
			align:'left',
			sortable:true
		},{
			header:"厂商",
			dataIndex:'manf',
			width:200,
			align:'left',
			sortable:true
		},{
			header:"规格",
			dataIndex:'spec',
			width:100,
			align:'left',
			sortable:true
		},{
			header:"批次库存",
			dataIndex:'stkqty',
			width:100,
			align:'left',
			sortable:true
		},{
			header:"退货数量",
			dataIndex:'qty',
			width:100,
			id:'qty',
			align:'right',
			sortable:true
		},{
			header:"退货单位",
			dataIndex:'uomDesc',
			id:'uomDesc',
			width:100,       
			align:'left',
			sortable:true
		},{
			header:"退货原因",
			dataIndex:'retReason',
			width:100,
			id:'retReason',
			align:'left',
			sortable:true
		},{
			header:"退货进价",
			dataIndex:'rp',
			width:100,
			align:'right',
			sortable:true
		},{
			header:"退货进价金额",
			dataIndex:'rpAmt',
			width:100,
			align:'right',
			sortable:true
		},{
			header:"售价",
			dataIndex:'sp',
			width:100,
			align:'right',
			sortable:true
		},{
			header:"退货售价金额",
			dataIndex:'spAmt',
			width:100,
			align:'right',
			sortable:true
		},{
			header:"批号",
			dataIndex:'batNo',
			width:100,
			align:'left',
			sortable:true
		},{
			header:"效期",
			dataIndex:'expDate',
			width:100,
			align:'left',
			sortable:true
		},{
			header:"发票号",
			dataIndex:'invNo',
			id:'invNo',
			width:100,
			align:'left',
			sortable:true
		},{
			header:"发票日期",
			dataIndex:'invDate',
			id:'invDate',
			width:100,
			align:'left',
			sortable:true
		},{
			header:"退发票金额",
			dataIndex:'invAmt',
			id:'invAmt',
			width:100,
			align:'right',
			sortable:true
		},{
			header:"随行单号",
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
		displayMsg:'第 {0} 条到 {1}条 ，一共 {2} 条',
		emptyMsg:"没有记录"
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
			Msg.info("error","请选择起始日期!");
			return false;
		}
		if((endDate=="")||(endDate==null)){
			Msg.info("error","请选择截止日期!");
			return false;
		}
		/*
		if((vorId=="")||(vorId==null)){
			Msg.info("error","请选择供应商!");
			return false;
		} */
		var locField = Ext.getCmp("locField").getValue();
		if((locField=="")||(locField==null)){
			Msg.info("error","请选择科室!");
			return false;
		}
		var complete="";
		if (chkComplete.getValue()==true)
		{complete="Y"}
		//else
		//{complete="N"}
		
		//strPar - 参数串(起始日期^截止日期^科室Id^供应商Id^^仅已完成)
		var strPar=startDate+"^"+endDate+"^"+locField+"^"+vorId+"^^"+complete
		OrderDs.setBaseParam('sort','ingrt');
		OrderDs.setBaseParam('dir','desc');
		OrderDs.setBaseParam('strPar',strPar);
		OrderDs.load({params:{start:0,limit:pagingToolbar.pageSize}});
	};

	var fB = new Ext.Toolbar.Button({
		text:'查询',
		tooltip:'查询',
		iconCls:'page_find',
		width : 70,
		height : 30,
		handler : handler
	});
	var xB=new Ext.Toolbar.Button({
		text:'关闭',
		tooltip:'关闭',
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
			title : '查询条件',
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
		title:'查找退货单',
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
				title: '退货单',
				region: 'center',
				layout: 'fit',
				items: Grid
			},{
				region: 'south',
				title: '退货单明细',
				height: 200,
				layout: 'fit',
				items: DetailGrid
			}]
	});
		
	//显示窗口
	findWin.show();
};