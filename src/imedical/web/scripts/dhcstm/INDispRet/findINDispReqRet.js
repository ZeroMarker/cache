FindINDispRet = function(loc,fn){
	var url = 'dhcstm.indispretaction.csp';
	var dsr = "";
	//起始日期
	var startDate = new Ext.ux.DateField({
		id:'startDate',
		listWidth:210,
		allowBlank:true,
		fieldLabel:'起始日期',
		anchor:'95%',
		value:new Date().add(Date.DAY,-30)
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
	
	var dsrProxy= new Ext.data.HttpProxy({url:url+'?actiontype=query',method:'GET'});
	var InDispRetDs = new Ext.data.Store({
		proxy:dsrProxy,
		reader:new Ext.data.JsonReader({
			totalProperty:'results',
			root:'rows'
		}, [
			{name:'dsr'},
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
			'RetLocId','RetLoc'
		]),
		remoteSort: false,
		listeners : {
			load : function(store,records,options){
				if (records.length>0){
					InDispRetGrid.getSelectionModel().selectFirstRow();
					InDispRetGrid.getView().focusRow(0);
				}
			}
		}
	});
	
	var InDispCm = new Ext.grid.ColumnModel([
		new Ext.grid.RowNumberer(),
		{
			header: '退回单rowid',
			dataIndex: 'dsr',
			hidden:true
		},{
			header: '退回单号',
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
			dataIndex:'RetLoc',
			width:150
		},{
			header: "退回日期",
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
			header:'制单人',
			dataIndex:'userName',
			width:60
		},{
			header: "完成",
			dataIndex: 'comp',
			width: 40,
			align: 'center',
			sortable: true,
			renderer:function(v, p, record){
				p.css += ' x-grid3-check-col-td';
				return '<div class="x-grid3-check-col'+(((v=='Y')||(v==true))?'-on':'')+' x-grid3-cc-'+this.id+'">&#160;</div>';
			}
		},{
			header: "审核",
			dataIndex: 'chkFlag',
			width: 40,
			align: 'center',
			sortable: true,
			renderer:function(v, p, record){
				p.css += ' x-grid3-check-col-td';
				return '<div class="x-grid3-check-col'+(((v=='Y')||(v==true))?'-on':'')+' x-grid3-cc-'+this.id+'">&#160;</div>';
			}
		}
	]);

	var DsrPagingToolbar = new Ext.PagingToolbar({
		store:InDispRetDs,
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
			InDispRetDs.setBaseParam('strParam',strPar);
			InDispRetDs.removeAll();
			InDispRetItmDs.removeAll();
			InDispRetDs.load({
				params:{start:0,limit:DsrPagingToolbar.pageSize,sort:'NO',dir:'desc'}
			});
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
		}
	})
	
	var InDispRetGrid = new Ext.ux.GridPanel({
		id : 'InDispRetGrid',
		region:'center',
		store:InDispRetDs,
		cm:InDispCm,
		trackMouseOver: true,
		stripeRows: true,
		sm:new Ext.grid.RowSelectionModel({singleSelect:false}),
		loadMask: true,
		bbar:DsrPagingToolbar
	});
	
	var InDispRetItmProxy= new Ext.data.HttpProxy({url:url+'?actiontype=queryItem',method:'GET'});
	var InDispRetItmDs = new Ext.data.Store({
		proxy:InDispRetItmProxy,
		reader:new Ext.data.JsonReader({
			totalProperty:'results',
			root:'rows'
		}, [
			{name:'dsrItm'},
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
			{name:'rp'},
			{name:'rpAmt'},
			{name:'sp'},
			{name:'spAmt'},
			"Brand","Model"
		]),
		remoteSort: false
	});


	var InDispRetItmCm = new Ext.grid.ColumnModel([
		new Ext.grid.RowNumberer(),
		{
			header: '明细rowid',
			dataIndex: 'dsrItm',
			hidden:true
		},{
			header: '批次rowid',
			dataIndex: 'inclb',
			hidden:true
		},{
			header: '物资rowid',
			dataIndex: 'inci',
			hidden:true
		},
		/*
	    {
	        header:"领用人",
	        dataIndex:'receiveUser',
	        width:100,
	        align:'left',
	        sortable:true,
	 	    renderer:Ext.util.Format.comboRenderer2(UCG,"UserId","Name")
	 	    //,
			//editor:new Ext.grid.GridEditor(UCG)       
	    },				
				
		*/			
		{
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
			header:'简称',
			dataIndex:'Abbrev',
			align:'left',
			width:80,
			sortable:true
		},{
			header:'品牌',
			dataIndex:'Brand',
			align:'left',
			width:80,
			sortable:true
		},{
			header:'型号',
			dataIndex:'Model',
			align:'left',
			width:80,
			sortable:true
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
			header: "退回数量",
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
		}/*,{
			header:'单价',
			dataIndex:'rp',
			align:'right',
			width:80,
			sortable:true
		}*/,{
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
		}
	]);
	
	var dsrItmPagingToolbar = new Ext.PagingToolbar({
		store:InDispRetItmDs,
		pageSize:15,
		displayInfo:true,
		displayMsg:'第 {0} 条到 {1}条 ，一共 {2} 条',
		emptyMsg:"没有记录"
	});
	
	var InDispRetItmGrid = new Ext.ux.GridPanel({
		id : 'InDispRetItmGrid',
		region:'south',
		store:InDispRetItmDs,
		cm:InDispRetItmCm,
		trackMouseOver: true,
		stripeRows: true,
		sm:new Ext.grid.RowSelectionModel({singleSelect:false}),
		loadMask: true,
		height:225,
		bbar:dsrItmPagingToolbar
	});

	InDispRetGrid.getSelectionModel().on('rowselect',function(sm,rowIndex,rec){
		dsr = InDispRetDs.data.items[rowIndex].data["dsr"];
 		mainRowId = dsr;
 		InDispRetItmDs.setBaseParam('dsr',dsr);
 		InDispRetItmDs.removeAll();
		InDispRetItmDs.load({params:{start:0,limit:dsrItmPagingToolbar.pageSize}});
	});		
	
	InDispRetGrid.on('rowdblclick',function(grid,rowIndex,e){
		//var ds=grid.getStore();
		//ds.load({params:{dsr:dsr}});
		//SetMain(dsr);
		fn(dsr)		
		/*
		adjNumField.setValue(InDispRetDs.data.items[rowIndex].data["no"]);
		groupField.setValue(InDispRetDs.data.items[rowIndex].data["scg"]);
		
		
		locField.setValue(InDispRetDs.data.items[rowIndex].data["loc"]);
		locField.setRawValue(InDispRetDs.data.items[rowIndex].data["locDesc"]);
		dateField.setValue(InDispRetDs.data.items[rowIndex].data["date"]);
		//alert(InDispRetDs.data.items[rowIndex].data["comp"]);
		
		//完成标志
		if(InDispRetDs.data.items[rowIndex].data["comp"]=="Y"){
			finshCK.setValue(true);
			//addB.disable();
		}else{
			finshCK.setValue(false);
		}
		//审核标志
		if(InDispRetDs.data.items[rowIndex].data["chkFlag"]=="Y"){
			auditCK.setValue(true);
			//addB.disable();
		}else{
			auditCK.setValue(false);
		}
		//类组
		//Ext.getCmp('').setValue(InDispRetDs.data.items[rowIndex].data["scg"])
		
		*/
		
		findWin.close();
	});
	
	var conPanel = new Ext.form.FormPanel({
		region:'north',
		labelWidth:60,
		autoScroll:true,
		labelAlign:'right',
		autoHeight: true, 
		frame:true,
		tbar:[fB,'-',cancelFind],
		layout:'column',
		layout:'fit',
		items:[{
			xtype:'fieldset',
			title:'查询条件',
			autoHeight:true,
			bodyStyle:'padding:0px;',
			items:[{
				layout:'column',
				items:[
					{columnWidth:.2,layout:'form',items:startDate},
					{columnWidth:.2,layout:'form',items:endDate},
					{columnWidth:.3,layout:'form',items:Loc},
					{columnWidth:.15,layout:'form',items:finish},
					{columnWidth:.15,layout:'form',items:audit}
				]
			}]
		}]
	});
	
	var findWin = new Ext.Window({
		title:'科室人员退回单',
		width:gWinWidth,
		height:gWinHeight,
		minWidth:1000, 
		minHeight:600,
		layout:'border',
		plain:true,
		modal:true,
		bodyStyle:'padding:5px;',
		buttonAlign:'center',
		items:[conPanel,InDispRetGrid,InDispRetItmGrid]
	});
		
	//显示窗口
	findWin.show();
	fB.handler();
};
