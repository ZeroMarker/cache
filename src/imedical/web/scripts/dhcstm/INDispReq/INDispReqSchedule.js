// /名称: 科室内请领单执行情况查询
// /描述: 科室内请领单执行情况查询
// /编写者：wangjiabin
// /编写日期: 2013-12-07
Ext.onReady(function() {
	
	var userId = session['LOGON.USERID'];
	var gGroupId=session['LOGON.GROUPID'];
	var gUserId = session['LOGON.USERID'];	
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;	
	
	var url='dhcstm.indispreqaction.csp';
	//订购科室
	var PhaLoc = new Ext.ux.LocComboBox({
		fieldLabel : '科室',
		id : 'PhaLoc',
		name : 'PhaLoc',
		anchor : '90%',
		width:120,
		groupId:gGroupId,
		emptyText : '科室...'
	});
	
	var uGroupListX=new Ext.data.Store({		 
		url:"dhcstm.sublocusergroupaction.csp?actiontype=getGrpListByUser",
		reader:new Ext.data.JsonReader({
			totalProperty:'results',
			root:"rows"	,
			idProperty:'RowId'
		},['RowId','Description'])
	});
	
	var UserGrp = new Ext.ux.ComboBox({
		fieldLabel:'专业组',	
		id:'UserGrp',
		anchor : '90%',
		store:uGroupListX,
		valueField:'RowId',
		displayField:'Description',
		triggerAction:'all',
		params:{subloc:'PhaLoc'},
		valueParams:{user:gUserId}
	});
	// 起始日期
	var StartDate = new Ext.ux.DateField({
				fieldLabel : '起始日期',
				id : 'StartDate',
				name : 'StartDate',
				anchor : '90%',
				width : 120,
				value : new Date().add(Date.DAY, - 30)
			});
	// 截止日期
	var EndDate = new Ext.ux.DateField({
				fieldLabel : '截止日期',
				id : 'EndDate',
				name : 'EndDate',
				anchor : '90%',
				width : 120,
				value : new Date()
			});
	
	var NotDisp = new Ext.form.Checkbox({
		boxLabel : '未发放',
		id : 'NotDisp',
		name : 'NotDisp',
		anchor : '90%',
		width : 120,
		checked : true
	});
	var PartlyDisp = new Ext.form.Checkbox({
		boxLabel : '部分发放',
		id : 'PartlyDisp',
		name : 'PartlyDisp',
		anchor : '90%',
		width : 120,
		checked : true
	});
		
	var AllDisp = new Ext.form.Checkbox({
		boxLabel : '全部发放',
		id : 'AllDisp',
		name : 'AllDisp',
		anchor : '90%',
		width : 120,
		checked : true
	});
		
	// 查询订单按钮
	var SearchBT = new Ext.Toolbar.Button({
				id : "SearchBT",
				text : '查询',
				tooltip : '点击查询请领单',
				width : 70,
				height : 30,
				iconCls : 'page_find',
				handler : function() {
					Query();
				}
	});


	// 清空按钮
	var ClearBT = new Ext.Toolbar.Button({
				id : "ClearBT",
				text : '清空',
				tooltip : '点击清空',
				width : 70,
				height : 30,
				iconCls : 'page_clearscreen',
				handler : function() {
					clearData();
				}
			});
			
	/**
	 * 清空方法
	 */
	function clearData() {
		SetLogInDept(Ext.getCmp("PhaLoc").getStore(),"PhaLoc");
		Ext.getCmp("StartDate").setValue(new Date().add(Date.DAY, - 30));
		Ext.getCmp("EndDate").setValue(new Date());
		Ext.getCmp("UserGrp").setValue("");
		Ext.getCmp("NotDisp").setValue(true);
		Ext.getCmp("PartlyDisp").setValue(true);
		Ext.getCmp("AllDisp").setValue(true);
		
		MasterGrid.store.removeAll();
		MasterStore.baseParams="";
		MasterGrid.getBottomToolbar().updateInfo();
		DetailGrid.store.removeAll();
		DetailStore.baseParams="";
		DetailGrid.getBottomToolbar().updateInfo();
	}

	// 显示订单数据
	function Query() {
		var phaLoc = Ext.getCmp("PhaLoc").getValue();
		if (phaLoc =='' || phaLoc.length <= 0) {
			Msg.info("warning", "请选择科室!");
			return;
		}		
		var startDate = Ext.getCmp("StartDate").getValue();
		var endDate = Ext.getCmp("EndDate").getValue();
		if(startDate!=""){
			startDate = startDate.format(ARG_DATEFORMAT);
		}
		if(endDate!=""){
			endDate = endDate.format(ARG_DATEFORMAT);
		}
		var NotDisp = (Ext.getCmp("NotDisp").getValue()==true?'0':'');
		var PartlyDisp = (Ext.getCmp("PartlyDisp").getValue()==true?'1':'');
		var AllDisp = (Ext.getCmp("AllDisp").getValue()==true?'2':'');
		var dispStatus=NotDisp+','+PartlyDisp+','+AllDisp;
		//开始日期^截止日期^订单号^供应商id^科室id^完成标志^审核标志^订单状态(未入库，部分入库，全部入库)
		var comp="Y";
		var userGrp=Ext.getCmp("UserGrp").getValue();
		var Status="OCR";	//显示被拒绝的请领单
		//var userGrp="";
		var strPar=startDate+'^'+endDate+'^'+phaLoc+'^'+gUserId+'^'+comp+'^'+Status+'^'+userGrp+'^'+dispStatus;
		
		var Page=GridPagingToolbar.pageSize;
		MasterStore.removeAll();
		DetailGrid.store.removeAll();
		MasterStore.setBaseParam('strPar',strPar);
		MasterStore.load({params:{start:0, limit:Page}});
	}
		
	function renderReqStatus(value){
		var PoStatus='';
		if(value==0){
			PoStatus='未发放';			
		}else if(value==1){
			PoStatus='部分发放';
		}else if(value==2){
			PoStatus='全部发放';
		}
		return PoStatus;
	}
	
	var MasterProxy= new Ext.data.HttpProxy({url:url+'?actiontype=DispReqList',method:'GET'});
	var MasterStore = new Ext.data.Store({
		proxy:MasterProxy,
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
			{name:'remark'},
			{name:'dispSchedule'}
		]),
		remoteSort: false,
		listeners:{
			load:function(ds){
				if (MasterStore.getCount()>0){
					MasterGrid.getSelectionModel().selectFirstRow();
					MasterGrid.getView().focusRow(0);
				}
			}
		}
	});
	
	var MasterCm = new Ext.grid.ColumnModel([
		new Ext.grid.RowNumberer(),
		{	
			header: 'rowid',
			dataIndex: 'dsrq',
			width: 100,
			hidden:true,
			align: 'left'
		},{	
			header: '进度',
			dataIndex: 'dispSchedule',
			width: 60,
			align: 'left',
			renderer:function(value){
				var status="";
				if(value==0){
					status="未发放";
				}else if(value==1){
					status="部分发放";
				}else if(value==2){
					status="全部发放";
				}
				return status;
			}
		},{
			header: '请领单号',
			dataIndex: 'no',
			width: 140,
			sortable:true,
			align: 'left'
		},{
			header: "制单人",
			dataIndex: 'userName',
			width: 60,
			align: 'left',
			sortable: true
		},{
			header: "请领单日期",
			dataIndex: 'date',
			width: 80,
			align: 'left',
			sortable: true
		},{
			header: "请领单时间",
			dataIndex: 'time',
			width: 80,
			align: 'left',
			sortable: true
		},{	
			header:'类组',
			width:80,
			dataIndex:'scgDesc'		
		},{
			header:'请领人',
			width:60,
			dataIndex:'reqUserName'
		},{
			header:'专业组',
			dataIndex:'reqGrpDesc'
		},{
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
	MasterCm.defaultSortable = true;
	var GridPagingToolbar = new Ext.PagingToolbar({
		store:MasterStore,
		pageSize:PageSize,
		displayInfo:true,
		displayMsg:'第 {0} 条到 {1}条 ，一共 {2} 条',
		emptyMsg:"没有记录"
	});
	var MasterGrid = new Ext.grid.GridPanel({
		region:'west',
		title: '请领单',
		collapsible: true,
		split: true,
		width: 370,
		cm : MasterCm,
		sm : new Ext.grid.RowSelectionModel({
					singleSelect : true
				}),
		store : MasterStore,
		trackMouseOver : true,
		stripeRows : true,
		loadMask : true,
		bbar:GridPagingToolbar,
		viewConfig:{
			getRowClass : function(record,rowIndex,rowParams,store){ 
				var status=record.get("status");
				switch(status){
					case "R":
						return 'classRed';
						break;
				}
			}
		}
	});

	// 添加表格单击行事件
	MasterGrid.getSelectionModel().on('rowselect', function(sm, rowIndex, r) {
		var dsrq = MasterStore.getAt(rowIndex).get("dsrq");
		var Size = DetailPagingToolbar.pageSize;
		DetailStore.setBaseParam('dsrq',dsrq);
		DetailStore.setBaseParam('sort','');
		DetailStore.setBaseParam('dir','');
		DetailStore.removeAll();
		DetailStore.load({params:{start:0,limit:Size}});
	});
		
	var DetailProxy = new Ext.data.HttpProxy({url:url+'?actiontype=SelDispReqItm',method:'GET'});
	var DetailStore = new Ext.data.Store({
		proxy:DetailProxy,
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
			{name:'remark'},
			{name:'dispedQty'},
			"moveStatus"
		]),
		remoteSort: false
	});


	var DetailCm = new Ext.grid.ColumnModel([
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
			header: "已发放数量",
			dataIndex: 'dispedQty',
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
			header : '状态',
			dataIndex : 'moveStatus',
			width : 60,
			aligh : 'left',
			renderer : function(value){
				var status="";
				if(value=="G"){
					status="未发放";
				}else if(value=="D"){
					status="已发放";
				}else if(value=="X"){
					status="已取消";
				}else if(value=="R"){
					status="已拒绝";
				}
				return status;
			}
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
		region: 'center',
		title: '请领单明细',
		id : 'DetailGrid',
		cm : DetailCm,
		store : DetailStore,
		trackMouseOver : true,
		stripeRows : true,
		loadMask : true,
		sm : new Ext.grid.RowSelectionModel({singleSelect:true}),
		bbar:DetailPagingToolbar
	});
				
	var HisListTab = new Ext.ux.FormPanel({
		title:'请领单进度查询',
		tbar : [SearchBT, '-', ClearBT],
		items : [{
			xtype : 'fieldset',
			title : '查询条件',
			layout : 'column',	
			style : 'padding:5px 0px 0px 5px',
			defaults:{border:false,xtype:'fieldset'},
			items : [{
				columnWidth: 0.33,
				items: [PhaLoc,UserGrp]
			},{	
				columnWidth: 0.3,
				items: [StartDate,EndDate]
			},{
				columnWidth: 0.17,
				items: [NotDisp,PartlyDisp]
			},{
				columnWidth: 0.17,
				items: [AllDisp]
			}]
		}]
	});
	
	var mainPanel = new Ext.ux.Viewport({
		layout:'border',
		items:[HisListTab,MasterGrid,DetailGrid],
		renderTo:'mainPanel'
	});
	
});