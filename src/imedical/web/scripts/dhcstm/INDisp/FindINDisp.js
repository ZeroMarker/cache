FindINDisp = function(ds,locField,fn){
	var url = 'dhcstm.indispaction.csp';
	var inds = "";
	//起始日期
	var startDate = new Ext.ux.DateField({
		id:'startDate',
		listWidth:210,
		allowBlank:true,
		fieldLabel:'起始日期',
		anchor:'95%',
		value:new Date().add(Date.DAY,-7)
	});
	//截止日期
	var endDate = new Ext.ux.DateField({
		id:'endDate',
		listWidth:210,
		allowBlank:true,
		fieldLabel:'截止日期',
		anchor:'95%',
		value:new Date()
	});
	
	var Loc = new Ext.ux.LocComboBox({
		id:'Loc',
		fieldLabel:'科室',
		listWidth:210,
		emptyText:'科室...',
		anchor:'95%',
		groupId:GroupId
	});
	
	var finish = new Ext.form.Checkbox({
		id: 'finish',
		fieldLabel:'完成',
		anchor:'95%',
		allowBlank:true
	});

	var audit = new Ext.form.Checkbox({
		id: 'audit',
		fieldLabel:'审核',
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
			header: '发放单rowid',
			dataIndex: 'inds',
			hidden:true
		},{
			header: '发放单号',
			dataIndex: 'no',
			width: 150,
			sortable:true,
			align: 'left'
		},{
			header: '科室',
			dataIndex: 'locDesc',
			width: 150,
			sortable:true,
			align: 'left'
		},{
			header:'接收科室',
			width:160,
			align:'left',
			dataIndex:'indsToLoc'
		},{
			header: "发放日期",
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
			header: "类组",
			dataIndex: 'scgDesc',
			width: 60,
			align: 'left',
			sortable: true
		},{
			header:'发放类型',
			dataIndex:'dispmode',
			width:80
		},{
			header:'领用人',
			dataIndex:'recUserName',
			width:60
		},{
			header:'专业组',
			dataIndex:'grpDesc',
			width:120
		},{
			header: "完成",
			dataIndex: 'comp',
			width: 40,
			align: 'center',
			sortable: true,
			xtype : 'checkcolumn'
		},{
			header: "审核",
			dataIndex: 'chkFlag',
			width: 40,
			align: 'center',
			sortable: true,
			xtype : 'checkcolumn'
		},{
			header:'备注',
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
		text:'查询',
		tooltip:'查询',
		iconCls:'page_find',
		width:70,
		height:30,
		handler:function(){
			var startDate = Ext.getCmp('startDate').getValue();
			if((startDate!="")&&(startDate!=null)){
				startDate = startDate.format(ARG_DATEFORMAT);
			}else{
				Msg.info("error","请选择起始日期!");
				return false;
			}
			var endDate = Ext.getCmp('endDate').getValue();
			if((endDate!="")&&(endDate!=null)){
				endDate = endDate.format(ARG_DATEFORMAT);
			}else{
				Msg.info("error","请选择截止日期!");
				return false;
			}
			
			var locId = Ext.getCmp('Loc').getValue();
			if((locId=="")||(locId==null)){
				Msg.info("error","请选择科室!");
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
		text:'关闭',
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
			header: '明细rowid',
			dataIndex: 'indsItm',
			hidden:true
		},{
			header: '批次rowid',
			dataIndex: 'inclb',
			hidden:true
		},{
			header: '物资rowid',
			dataIndex: 'inci',
			hidden:true
		},{
			header: '代码',
			dataIndex: 'code',
			width: 72,
			sortable:true,
			align: 'left'
		},{
			header: '名称',
			dataIndex: 'desc',
			width: 180,
			sortable:true,
			align: 'left'
		},{
			header:'规格',
			dataIndex:'spec',
			align:'left',
			width:80,
			sortable:true
		},{
			header: "批次~效期",
			dataIndex: 'batNo',
			width: 180,
			align: 'left',
			sortable: true
		},{
			header: "厂商",
			dataIndex: 'manf',
			width: 80,
			align: 'left',
			sortable: true
		},{
			header: "发放数量",
			dataIndex: 'qty',
			width: 72,
			align: 'right',
			sortable: true
		},{
			header:'单位',
			dataIndex:'uomDesc',
			align:'left',
			width:80,
			sortable:true
		},{
			header:'进价',
			dataIndex:'rp',
			align:'right',
			width:80,
			sortable:true
		},{
			header:'进价金额',
			dataIndex:'rpAmt',
			align:'right',
			width:80,
			sortable:true
		},{
			header:'备注',
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
			title:'查询条件',
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
			title:'查找科室人员发放单',
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
