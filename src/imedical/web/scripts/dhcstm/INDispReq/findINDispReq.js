findDispReq = function(subLoc,Fn){

	
	var url = 'dhcstm.indispreqaction.csp';
	var jReq = "";
	//起始日期
	var startDate = new Ext.ux.DateField({
		id:'startDate',
		//width:210,
		listWidth:210,
		allowBlank:true,
		fieldLabel:'起始日期',
		anchor:'95%',
		value:new Date().add(Date.DAY,-7)
	});
	//截止日期
	var endDate = new Ext.ux.DateField({
		id:'endDate',
		//width:210,
		listWidth:210,
		allowBlank:true,
		fieldLabel:'截止日期',
		anchor:'95%',
		value:new Date()
	});
	var UserId=session['LOGON.USERID'] ;
	var uGroupListX=new Ext.data.Store({		 
		url:"dhcstm.sublocusergroupaction.csp?actiontype=getGrpListByUser",
		reader:new Ext.data.JsonReader({
			totalProperty:'results',
			root:"rows"	,
			idProperty:'RowId'
		},['RowId','Description'])
	});
	
	var GrpListX=new Ext.form.ComboBox({
		fieldLabel:'专业组',	
		id:'UserGrpX',
		anchor : '90%',
		//disabled:true,
		store:uGroupListX,
		valueField:'RowId',
		displayField:'Description',
		triggerAction:'all',
		listeners:{
			beforequery:function(e){
				this.store.setBaseParam('user',UserId);
				this.store.setBaseParam('subloc',subLoc);
			}
		}
	});	
	//GrpListX.getStore().load();

	
	var reqStatusCombox=new Ext.form.ComboBox({
		fieldLabel:'状态',
		id:'reqStatusCombox',
		anchor:'90%',
		mode:'local',
		//disabled:true,
	 	store:new Ext.data.ArrayStore({
	 		id:0,
	 		fields: ['code','description'],
	      	data:[['C','已处理'],['O','待处理'],['X','已作废'],['R','已拒绝']]
	 	}),
	 	valueField:'code',
	 	displayField:'description',
		triggerAction: 'all'
	});

	/*
	var NoTransfer = new Ext.form.Checkbox({
		id: 'NoTransfer',
		fieldLabel:'未转移',
		anchor:'95%',
		allowBlank:true,
		checked:true
	});

	var PartTransfer = new Ext.form.Checkbox({
		id: 'PartTransfer',
		fieldLabel:'部分转移',
		anchor:'95%',
		allowBlank:true,
		checked:true
	});

	var AllTransfer = new Ext.form.Checkbox({
		id: 'AllTransfer',
		fieldLabel:'全部转移',
		anchor:'95%',
		allowBlank:true
	});
	
	*/	
	var Over = new Ext.form.Checkbox({
		id: 'Over',
		fieldLabel:'完成',
		allowBlank:true,
		listeners:
		{
			'check':function(chk){		
//				Ext.getCmp('reqStatusCombox').setDisabled(!chk.getValue());
//				Ext.getCmp('reqStatusCombox').setValue('');
			}
		}
	});

	
	var fB = new Ext.Toolbar.Button({
		text:'查询',
		tooltip:'查询',
		iconCls:'page_find',
		width : 70,
		height : 30,
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
			var frLocId=subLoc;
			
			var compFlag=(Ext.getCmp('Over').getValue()==true?'Y':'N')
			////起始日期^截止日期^科室rowid^用户rowid^完成标志
			var reqStatus=Ext.getCmp('reqStatusCombox').getValue();
			var UserGrp=Ext.getCmp('UserGrpX').getValue();
			var strPar = startDate+"^"+endDate+"^"+(frLocId==null?'':frLocId)+"^"+session['LOGON.USERID']
						+"^"+compFlag+"^"+reqStatus+"^"+UserGrp;
						
			OrderDs2.removeAll();
			OrderDs.removeAll();

			OrderDs.setBaseParam('sort','');
			OrderDs.setBaseParam('dir','');
			OrderDs.setBaseParam('strPar',strPar);
			OrderDs.load({params:{start:0,limit:pagingToolbar3.pageSize}});
		}
	});
	
	var cB = new Ext.Toolbar.Button({
		text:'清空',
		tooltip:'清空',
		iconCls:'page_clearscreen',
		width : 70,
		height : 30,
		handler:function(){
			Ext.getCmp("startDate").setValue(new Date().add(Date.DAY,-7));
			Ext.getCmp("endDate").setValue(new Date());
			Ext.getCmp("UserGrpX").setValue("");
			Ext.getCmp("reqStatusCombox").setValue("");
			Ext.getCmp("Over").setValue(false);
			OrderDs.removeAll();
			OrderDs2.removeAll();
		}
	});
	
	var closeB = new Ext.Toolbar.Button({
		iconCls:'page_delete',
		height:30,
		width:70,
		text:'关闭',
		tooltip:'关闭',
		handler:function(){
			findWin.close();
		}
	});
	
	var OrderProxy= new Ext.data.HttpProxy({url:url+'?actiontype=DispReqList',method:'GET'});
	var OrderDs = new Ext.data.Store({
		proxy:OrderProxy,
		reader:new Ext.data.JsonReader({
			totalProperty:'results',
			root:'rows'
		}, [
			{name:'dsrq'},
			{name:'no'},
			{name:'loc'},
			{name:'locDesc'},
			{name:'user'},
			{name:'userName'},
			{name:'reqUserName'},
			{name:'reqGrpDesc'},
			{name:'date'},
			{name:'time'},
			{name:'scg'},
			{name:'scgDesc'},
			{name:'status'},
			{name:'comp'},
			{name:'remark'}
		]),
		remoteSort: false,
		listeners:{
			load:function(ds){
				if (OrderDs.getCount()>0){
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
			dataIndex: 'dsrq',
			width: 100,
			hidden:true,
			align: 'left'
		},{
			header: '请领单号',
			dataIndex: 'no',
			width: 140,
			sortable:true,
			align: 'left'
		},{
			header: "请领人",
			dataIndex: 'userName',
			width: 80,
			align: 'left',
			sortable: true
		},{
			header: "请领单日期",
			dataIndex: 'date',
			width: 100,
			align: 'left',
			sortable: true
		},{
			header: "请领单时间",
			dataIndex: 'time',
			width: 100,
			align: 'left',
			sortable: true
		},{	
			header:'类组',
			width:100,
			dataIndex:'scgDesc'		
		},	
			{header:'请领人',dataIndex:'reqUserName'},
			{header:'专业组',dataIndex:'reqGrpDesc'},	
		{
			header:'完成',
			dataIndex:'comp',
			align:'center',
			width:60,
			sortable:true,
			renderer:function(v, p, record){
				p.css += ' x-grid3-check-col-td';
				return '<div class="x-grid3-check-col'+(((v=='Y')||(v==true))?'-on':'')+' x-grid3-cc-'+this.id+'">&#160;</div>';
			}
		},{
			header: "状态",
			dataIndex: 'status',
			width: 100,
			align: 'left',
			renderer:function(value){
				var status="";
				if(value=="C"){
					status="已处理";
				}else if(value=="O"){
					status="待处理";
				}else if(value=="X"){
					status="已作废";
				}else if(value=="R"){
					status="已拒绝";
				}
				return status;
			},
			sortable: true
		},{		 
			header:'备注',
			dataIndex:'remark',
			width:130,
			align:'left'
		}
	]);

	var pagingToolbar3 = new Ext.PagingToolbar({
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
		sm:new Ext.grid.RowSelectionModel({singleSelect:true}),
		loadMask: true,
		height:225,
		bbar:pagingToolbar3
	});
	
	var OrderProxy2= new Ext.data.HttpProxy({url:url+'?actiontype=SelDispReqItm',method:'GET'});
	var OrderDs2 = new Ext.data.Store({
		proxy:OrderProxy2,
		reader:new Ext.data.JsonReader({
			totalProperty:'results',
			root:'rows'
		}, [
			{name:'rowid',mapping:'dsrqi'},
			{name:'inci'},
			{name:'code',mapping:'inciCode'},
			{name:'desc',mapping:'inciDesc'},
			{name:'qty'},
			{name:'uom'},
			{name:'uomDesc'},
			{name:'spec'},
			{name:'manf'},
			{name:'remark'}
		]),
		remoteSort: false
	});


	var OrderCm2 = new Ext.grid.ColumnModel([
		new Ext.grid.RowNumberer(),
		{
			header: '代码',
			dataIndex: 'code',
			width: 72,
			sortable:true,
			align: 'left'
		},{
			header: '名称',
			dataIndex: 'desc',
			width: 140,
			sortable:true,
			align: 'left'
		},{
			header:'规格',
			dataIndex:'spec',
			align:'left',
			width:80,
			sortable:true
		},{
			header: "厂商",
			dataIndex: 'manf',
			width: 80,
			align: 'left',
			sortable: true
		},{
			header: "数量",
			dataIndex: 'qty',
			width: 80,
			align: 'right',
			sortable: true
		},{
			header: "单位",
			dataIndex: 'uomDesc',
			width: 72,
			align: 'left',
			sortable: true
		},{
			header:'备注',
			dataIndex:'remark',
			align:'left',
			width:80,
			sortable:true
		}
	]);
	var pagingToolbar4=new Ext.PagingToolbar({
		store:OrderDs2,
		pageSize:20,
		displayInfo:true,
		displayMsg:'第 {0} 条到 {1}条 ，一共 {2} 条',
		emptyMsg:"没有记录"
	});

	var Grid2 = new Ext.grid.GridPanel({
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
		jReq =  OrderDs.data.items[rowIndex].data["dsrq"];
		jReq = jReq;
		OrderDs2.setBaseParam('dsrq',jReq);
		OrderDs2.setBaseParam('sort','RowId');
		OrderDs2.setBaseParam('dir','desc');
		OrderDs2.load({params:{start:0,limit:pagingToolbar4.pageSize}});
	});
	Grid.on('rowdblclick',function(grid,rowIndex,e){
		var rec = OrderDs.data.items[rowIndex];
		req = rec.data["dsrq"];
		Fn(req);
		findWin.close();

	});
	
	var conPanel = new Ext.form.FormPanel({
		region:'north',
		labelwidth:0,
		autoScroll:true,
		labelAlign:'right',
		autoHeight: true, 
		frame:true,
		tbar:[fB,'-',cB,'-',closeB],
		layout:'fit',
		bodyStyle:'padding:5px 0 0 0',
		items:[{
			xtype:'fieldset',
			title:'查询条件',
			//width:960,
			//height:73,
			frame:true,
			autoHeight:true,
			bodyStyle:'padding:0px;',
			labelWidth:60,
			items:[{
				layout:'column',
				items:[
					{columnWidth:.3,layout:'form',items:[startDate,endDate]},
					{columnWidth:.3,layout:'form',items:[GrpListX,reqStatusCombox]},
					{columnWidth:.2,layout:'form',items:[Over
					/*{
						
						defaults:{autoHeight:true},
						layout:'column',
						items:[
							{columnWidth:0.33,layout:'form',items:NoTransfer},
							//{columnWidth:0.33,layout:'form',items:PartTransfer},
							{columnWidth:0.33,layout:'form',items:reqStatusCombox}
						]}
						*/
					]}			
				]
			}]
		}]
	});
	
	var findWin = new Ext.Window({
		title:'查找请领单',
		width:1000,	
		height:620,
		minWidth:1000, 
		minHeight:620,
		layout:'border',
		plain:true,
		modal:true,
		bodyStyle:'padding:5px;',
		buttonAlign:'center',
		items:[conPanel,Grid,Grid2],
		listeners:{
			//'beforeshow':function(){handleLoc2(Request_Direction) ;}
			'afterrender':function(){		
				if (fB) {fB.handler();}
			}
		
		}
	});
		
	//显示窗口
	findWin.show();
	 
};