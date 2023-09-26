findRec = function(Fn){
	//var ctLocId = session['LOGON.CTLOCID'];
	var url = 'dhcstm.inrequestaction.csp';
	
	//起始日期
	var startDate = new Ext.ux.DateField({
		id:'startDate',
		//width:210,
		listWidth:210,
		allowBlank:true,
		fieldLabel:'起始日期',
		anchor:'95%',
		value:new Date()
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
	
	var Loc = new Ext.ux.LocComboBox({
		id:'Loc',
		anchor:'95%',
		fieldLabel:'请求部门',
		emptyText:'请求部门...',
		groupId:gGroupId,
		protype : INREQUEST_LOCTYPE,
		linkloc:CtLocId,
	    listeners:{
		'select':function(cb){
			var requestLoc=cb.getValue();
			var defprovLocs=tkMakeServerCall("web.DHCSTM.DHCTransferLocConf","GetDefLoc",requestLoc,gGroupId)
			var mainArr=defprovLocs.split("^");
	        var defprovLoc=mainArr[0];
	        var defprovLocdesc=mainArr[1];
			addComboData(Ext.getCmp('SupplyLoc').getStore(),defprovLoc,defprovLocdesc);
			Ext.getCmp("SupplyLoc").setValue(defprovLoc);
		 }
	   }
	});

	var SupplyLoc = new Ext.ux.ComboBox({
		id:'SupplyLoc',
		fieldLabel:'供给部门',
		anchor:'95%',
		store:frLocListStore,
		displayField:'Description',
		valueField:'RowId',
		listWidth:210,
		emptyText:'供给部门...',
		params:{LocId:'Loc'}
	});
    //自动加载登陆科室的默认供给部门
    Loc.fireEvent('select',Loc);
	var NoTransfer = new Ext.form.Checkbox({
		id: 'NoTransfer',
		boxLabel:'未转移',
		anchor:'95%',
		hideLabel:true,
		checked:true,
		height : 20
	});

	var PartTransfer = new Ext.form.Checkbox({
		id: 'PartTransfer',
		boxLabel:'部分转移',
		anchor:'95%',
		hideLabel:true,
		checked:true
	});

	var AllTransfer = new Ext.form.Checkbox({
		id: 'AllTransfer',
		boxLabel:'全部转移',
		anchor:'95%',
		hideLabel:true
	});

	var Over = new Ext.form.Checkbox({
		id: 'Over',
		boxLabel:'完成',
		hideLabel:true
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
			
			var toLocId = Ext.getCmp('Loc').getValue();
			if((toLocId=="")||(toLocId==null)){
				Msg.info("error","请选择请求部门!");
				return false;
			}
			var frLocId = Ext.getCmp('SupplyLoc').getValue();
			
			var comp = (Ext.getCmp('Over').getValue()==true?'Y':'N');
			
			var noTrans = (Ext.getCmp('NoTransfer').getValue()==true?1:0);
			var partTrans = (Ext.getCmp('PartTransfer').getValue()==true?1:0);
			var allTrans = (Ext.getCmp('AllTransfer').getValue()==true?1:0);
			
			var tranStatus = noTrans+"%"+partTrans+"%"+allTrans;
			var HV = gHVInRequest?'Y':UseItmTrack?'N':'';
			var strPar = startDate+"^"+endDate+"^"+toLocId+"^"+frLocId+"^"+comp
					+"^"+tranStatus+"^^^"+defaReqType+"^"
					+"^^^^"+HV;
			OrderDs2.removeAll();
			OrderDs.removeAll();
			OrderDs.setBaseParam('sort','');
			OrderDs.setBaseParam('dir','desc');
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
			Ext.getCmp("startDate").setValue(new Date());
			Ext.getCmp("endDate").setValue(new Date());
			Ext.getCmp("SupplyLoc").setValue("");
			Ext.getCmp("NoTransfer").setValue(true);
			Ext.getCmp("PartTransfer").setValue(true);
			Ext.getCmp("AllTransfer").setValue(false);
			Ext.getCmp("Over").setValue(false);
			SetLogInDept(Loc.getStore(),"Loc");
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
			{name:'remark'}
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
			header: '请求编号',
			dataIndex: 'reqNo',
			width: 100,
			sortable:true,
			align: 'left'
		},{
			header: '请求部门',
			dataIndex: 'toLocDesc',
			width: 100,
			sortable:true,
			align: 'left'
		},{
			header: "供给部门",
			dataIndex: 'frLocDesc',
			width: 100,
			align: 'left',
			sortable: true
		},{
			header: "请求人",
			dataIndex: 'userName',
			width: 100,
			align: 'left',
			sortable: true
		},{
			header: "日期",
			dataIndex: 'date',
			width: 100,
			align: 'left',
			sortable: true
		},{
			header: "时间",
			dataIndex: 'time',
			width: 100,
			align: 'left',
			sortable: true
		},{
			header:'完成状态',
			dataIndex:'comp',
			align:'center',
			width:100,
			sortable:true,
			renderer:function(v, p, record){
				p.css += ' x-grid3-check-col-td';
				return '<div class="x-grid3-check-col'+(((v=='Y')||(v==true))?'-on':'')+' x-grid3-cc-'+this.id+'">&#160;</div>';
			}
		},{
			header: "其他状态",
			dataIndex: 'status',
			width: 100,
			align: 'left',
			renderer:function(value){
				var status="";
				if(value==0){
					status="未转移";
				}else if(value==1){
					status="部分转移";
				}else if(value==2){
					status="全部转移";
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
		displayInfo:true
	});
	
	var Grid = new Ext.grid.GridPanel({
		region:'center',
		store:OrderDs,
		cm:OrderCm,
		trackMouseOver: true,
		stripeRows: true,
		sm:new Ext.grid.RowSelectionModel({singleSelect:true}),
		loadMask: true,
		bbar:pagingToolbar3
	});
	
	Grid.getSelectionModel().on('rowselect',function(sm,rowIndex,rec){
		OrderDs2.removeAll();
		var jReq =  OrderDs.data.items[rowIndex].data["req"];
		OrderDs2.setBaseParam('req',jReq);
		OrderDs2.setBaseParam('sort','rowid');
		OrderDs2.setBaseParam('dir','desc');
		OrderDs2.setBaseParam('refuseflag',1);
		OrderDs2.load({params:{start:0,limit:pagingToolbar4.pageSize}});
	});
	Grid.on('rowdblclick',function(grid,rowIndex,e){
		var rec = OrderDs.data.items[rowIndex];
		req = rec.data["req"];
		Fn(req);
		findWin.close();
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
			{name:'transQty'},
			{name:'qtyApproved'},
			{name:'uom'},
			{name:'uomDesc'},
			{name:'spec'},
			{name:'SpecDesc'},
			{name:'manf'},
			{name:'sp'},
			{name:'spAmt'},
			{name:'generic'},
			{name:'drugForm'},
			{name:'remark'},
			{name:'refuseflag'}
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
			header:'具体规格',
			dataIndex:'SpecDesc',
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
			header: "请求数量",
			dataIndex: 'qty',
			width: 80,
			align: 'right',
			sortable: true
		}, {
			header : "已转移数量",
			dataIndex : 'transQty',
			width : 80,
			align : 'right',
			sortable : true	
		}, {
			header : "批准数量",
			dataIndex : 'qtyApproved',
			width : 80,
			align : 'right',
			sortable : true
		},{
			header: "单位",
			dataIndex: 'uomDesc',
			width: 72,
			align: 'left',
			sortable: true
		},{
			header:'售价',
			dataIndex:'sp',
			align:'right',
			width:80,
			sortable:true
		},{
			header: "售价金额",
			dataIndex: 'spAmt',
			width: 80,
			align: 'right',
			sortable: true
		},{
			header:'备注',
			dataIndex:'remark',
			align:'left',
			width:80,
			sortable:true
		},{
			header:'是否拒绝',
			dataIndex:'refuseflag',
			align:'left',
			width:80,
			sortable:true
		}
	]);
	var pagingToolbar4=new Ext.PagingToolbar({
					store:OrderDs2,
					pageSize:20,
					displayInfo:true
			});
	
	var Grid2 = new Ext.grid.GridPanel({
		region:'south',
		store:OrderDs2,
		cm:OrderCm2,
		trackMouseOver: true,
		stripeRows: true,
		sm:new Ext.grid.RowSelectionModel({singleSelect:false}),
		loadMask: true,
		height:gWinHeight*0.3,
		bbar:pagingToolbar4
	});
	
	var conPanel = new Ext.ux.FormPanel({
		tbar:[fB,'-',cB,'-',closeB],
		items:[{
			xtype:'fieldset',
			title:'查询条件',
			bodyStyle:'padding:5px 0 0 5px;',
			labelWidth:60,
			layout:'column',
			defaults : {layout:'form'},
			items:[
				{columnWidth:.25,items:[startDate,endDate]},
				{columnWidth:.3,items:[Loc,SupplyLoc]},
				{columnWidth:.15,items:[NoTransfer,Over]},
				{columnWidth:.15,items:[PartTransfer]},
				{columnWidth:.15,items:[AllTransfer]}
			]
		}]
	});
	
	var findWin = new Ext.Window({
		title:'查找库存请求单',
		width:gWinWidth,
		height:gWinHeight,
		plain:true,
		modal:true,
		layout:'border',
		items:[conPanel,Grid,Grid2]
	});
		
	//显示窗口
	findWin.show();
	
	var LocId = Ext.getCmp('LocField').getValue();
	if(!Ext.isEmpty(LocId)){
		var LocDesc = Ext.getCmp('LocField').getRawValue();
		addComboData(null, LocId, LocDesc, Ext.getCmp('Loc'));
		Ext.getCmp('Loc').setValue(LocId);
	}
	
};