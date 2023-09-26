// /名称: 科室人员物资查询
// /描述: 科室人员物资查询
// /编写者：zhwh
// /编写日期: 2012.08.09
var matStatUrl="dhcstm.sublocmatstataction.csp" 

Ext.onReady(function() {
	var userId = session['LOGON.USERID'];
	var gGroupId=session['LOGON.GROUPID'];
	var gLocId=session['LOGON.CTLOCID'];
	
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;

	//统计科室
	var PhaLoc = new Ext.ux.LocComboBox({
		fieldLabel : '科室',
		id : 'PhaLoc',
		name : 'PhaLoc',
		anchor:'90%',
		groupId:gGroupId,
		stkGrpId : "StkGrpType",
		childCombo:["UserGrp","receiveUser"]
	});
	
	// 起始日期
	var StartDate = new Ext.ux.DateField({
		fieldLabel : '起始日期',
		id : 'StartDate',
		name : 'StartDate',
		anchor : '90%',
		
		width : 120,
		value : new Date()
	});

	// 结束日期
	var EndDate = new Ext.ux.DateField({
		fieldLabel : '结束日期',
		id : 'EndDate',
		name : 'EndDate',
		anchor : '90%',
		
		width : 120,
		value : new Date()
	});	
	
	var StkGrpType=new Ext.ux.StkGrpComboBox({ 
		id : 'StkGrpType',
		name : 'StkGrpType',
		StkType:App_StkTypeCode,     //标识类组类型
		LocId:gLocId,
		UserId:userId,
		anchor:'90%',
		params:{locId:'PhaLoc'},
		childCombo:["DHCStkCatGroup"]
	});
	
	var DHCStkCatGroup = new Ext.ux.ComboBox({
		fieldLabel : '库存分类',
		id : 'DHCStkCatGroup',
		name : 'DHCStkCatGroup',
		anchor : '90%',
		width : 120,
		store : StkCatStore,
		valueField : 'RowId',
		displayField : 'Description',
		params:{StkGrpId:'StkGrpType'}
	});

	var InciDr = new Ext.form.TextField({
		fieldLabel : '物资RowId',
		id : 'InciDr',
		name : 'InciDr',
		anchor : '90%',
		width : 140,
		valueNotFoundText : ''
	});

	var ItmDesc = new Ext.form.TextField({
		fieldLabel : '物资名称',
		id : 'ItmDesc',
		name : 'ItmDesc',
		anchor : '90%',
		width : 160,
		listeners : {
			specialkey : function(field, e) {
				if (e.getKey() == Ext.EventObject.ENTER) {
					var StkGrp= Ext.getCmp("StkGrpType").getValue();
					GetPhaOrderInfo(field.getValue(),StkGrp);
					//GetPhaOrderInfo(field.getValue(),'');
				}
			}
		}
	});

	var ToLoc = new Ext.ux.ComboBox({
		id:'ToLoc',
		fieldLabel:'接收科室',
		emptyText:'接收科室...',
		triggerAction : 'all',
		store : LeadLocStore,
		valueParams : {groupId : gGroupId},
		filterName : '',
		childCombo : ['receiveUser', 'UserGrp']
	});
//	SetLogInDept(ToLoc.getStore(),'ToLoc');
	
	var GrpList = new Ext.ux.ComboBox({
		fieldLabel:'专业组',	
		id:'UserGrp',
		anchor : '90%',
		store:UserGroupStore,
		valueField:'RowId',
		displayField:'Description',
		params : {SubLoc : 'ToLoc'}
	});
	
	var UserList = new Ext.ux.ComboBox({
		fieldLabel:'领用人',	
		id:'receiveUser',
		anchor : '90%',
		store:UStore,
		valueField:'RowId',
		displayField:'Description',
		filterName:'name',
		params : {locId : 'ToLoc'}
	});

	/**
	 * 调用物资窗体并返回结果
	 */
	function GetPhaOrderInfo(item, group) {
					
		if (item != null && item.length > 0) {
			GetPhaOrderWindow(item, group, App_StkTypeCode, "", "", "", "",
					getDrugList);
		}
	}

	/**
	 * 返回方法
	*/
	function getDrugList(record) {
		if (record == null || record == "") {
			return;
		}
		var inciDr = record.get("InciDr");
		var inciCode=record.get("InciCode");
		var inciDesc=record.get("InciDesc");
		
		Ext.getCmp("ItmDesc").setValue(inciDesc);
		Ext.getCmp('InciDr').setValue(inciDr);
	}

	
	// 查询按钮
	var searchBT = new Ext.Toolbar.Button({
		text : '查询',
		tooltip : '点击查询物资发放(退回)情况',
		iconCls : 'page_find',
		height:30,
		width:70,
		handler : function() {
			searchUserMatDisp();
		}
	});

	function searchUserMatDisp() {
		
		var StartDate = Ext.getCmp("StartDate").getValue();
		if(StartDate==null||StartDate.length <= 0) {
			Msg.info("warning", "开始日期不能为空！");
			return;
		}else{
			StartDate=StartDate.format(ARG_DATEFORMAT).toString();
		}
		var EndDate = Ext.getCmp("EndDate").getValue();
		if(EndDate==null||EndDate.length <= 0) {
			Msg.info("warning", "截止日期不能为空！");
			return;
		}else{
			EndDate=EndDate.format(ARG_DATEFORMAT).toString();
		}
		var PhaLoc = Ext.getCmp("PhaLoc").getValue();
		if(PhaLoc==null||PhaLoc.length <= 0) {
			Msg.info("warning", "科室不能为空！");
			return;
		}
		
		var StkGrp= Ext.getCmp("StkGrpType").getValue();
		var StkCat= Ext.getCmp("DHCStkCatGroup").getValue();
		var ItmDesc=Ext.getCmp("ItmDesc").getValue();
		var ItmRowid="";
		if(ItmDesc!="" & ItmDesc.length>0){
			ItmRowid= Ext.getCmp("InciDr").getValue();
		}
		var User =Ext.getCmp('receiveUser').getValue();
		var LUG=Ext.getCmp('UserGrp').getValue();
		var IncludeRet = 1;
		var ToLoc = Ext.getCmp('ToLoc').getValue();
		var strPar=StartDate+"^"+EndDate+"^"+PhaLoc+"^"+LUG+"^"+User+"^"+StkGrp+"^"+ItmRowid+"^"+IncludeRet+"^"+ToLoc;
		
		UserMatStatInfoStore.setBaseParam('strPar',strPar);
		
		var size=StatuTabPagingToolbar2.pageSize;
		UserMatStatInfoStore.removeAll();
		UserMatStatInfoGrid.store.removeAll();
		UserMatStatInfoStore.load({
			params:{start:0,limit:size},
			callback : function(r,options, success){
				if(success==false){
					Msg.info("error", "查询错误，请查看日志!");
				}
			}
		});
	}
	
	// 清空按钮
	var clearBT = new Ext.Toolbar.Button({
		text : '清空',
		tooltip : '点击清空',
		iconCls : 'page_clearscreen',
		height:30,
		width:70,
		handler : function() {
			clearData();
		}
	});

	function clearData() {
		SetLogInDept(PhaLoc.getStore(),'PhaLoc');
	//	SetLogInDept(ToLoc.getStore(),'ToLoc');
		Ext.getCmp("StartDate").setValue(new Date());
		Ext.getCmp("EndDate").setValue(new Date());
		Ext.getCmp("StkGrpType").setValue('');
		StkGrpType.store.load();
		Ext.getCmp("DHCStkCatGroup").setValue('');
		//Ext.getCmp("QueryFlag").setValue('');
		Ext.getCmp("ItmDesc").setValue('');
		Ext.getCmp("UserGrp").setValue('');
		Ext.getCmp("receiveUser").setValue('');
		Ext.getCmp("InciDr").setValue('');
		//MasterInfoGrid.store.removeAll();
		UserMatStatInfoGrid.store.removeAll();
		UserMatStatInfoGrid.store.baseParams="";
		UserMatStatInfoGrid.getBottomToolbar().updateInfo();
	}

	// 3关闭按钮
	var closeBT = new Ext.Toolbar.Button({
		text : '关闭',
		tooltip : '关闭界面',
		iconCls : 'close',
		handler : function() {
			window.close();
		}
	});

	// 访问路径
	var UserMatStatInfoUrl = matStatUrl+'?actiontype=LocUserMatStat&start=0&limit=20';
	// 通过AJAX方式调用后台数据
	var proxy = new Ext.data.HttpProxy({
		url : UserMatStatInfoUrl,
		method : "POST"
	});
	
	// 指定列参数
	//业务日期^批号^单位^售价^进价^结余数量(基本单位)^结余数量(带单位)^增减数量(基本单位)
	//^增减数量(带单位)^增减金额(进价)^增减金额(售价)^处理号^处理人^摘要
	//^期末金额(进价)^期末金额(售价)^供应商^厂商^操作人	
	var fields = ['trType','inciCode','inciDesc','Abbrev','spec','batInfo','manf','qty','uomDesc','receiver','rp','rpAmt','indsNo','dispDate','dispTime','dsrqNo','dsrqDate'];
	// 支持分页显示的读取方式
	var reader = new Ext.data.JsonReader({
		root : 'rows',
		totalProperty : "results",
		id : "TrId",
		fields : fields
	});
	
	var UserMatStatInfoStore = new Ext.data.Store({
		proxy : proxy,
		reader : reader
	});
	var nm = new Ext.grid.RowNumberer();
	var UserMatStatInfoCm = new Ext.grid.ColumnModel([nm, 
	{
		header:'类型',
		dataIndex:'trType',
		width:50,
		renderer:function(v){
			if(v=="C"){
				return "发放";
			}else if(v=="L"){
				return "退回";
			}else{
				return v;
			}
		}
	},{
		header : "领用(退回)日期",
		dataIndex : 'dispDate',
		width : 100,
		align : 'left',
		sortable : true
	},{
		header:'领用人(专业组)',
		dataIndex:'receiver',
		width:100
	},{
		header : "物资代码",
		dataIndex : 'inciCode',
		width : 60,
		align : 'left',	
		hidden:true,
		sortable : true
	},{
		header : "物资名称",
		dataIndex : 'inciDesc',
		width : 160,
		align : 'left',	
		sortable : true
	},{
		header:"简称",
		dataIndex:'Abbrev',
		width:100,
		align:'left',
		sortable:true
	},{
		header : "规格",
		dataIndex : 'spec',
		width : 60,
		align : 'left',	
		sortable : true
	},  {
		header : '批号~效期',
		dataIndex : 'batInfo',
		width : 150,
		align : 'left',
		sortable : true
	},  {
		header : "厂商",
		dataIndex : 'manf',
		width : 160,
		align : 'left',				
		sortable : true
	}, {
		header : "单位",
		dataIndex : 'uomDesc',
		width : 60,
		align : 'left',
		sortable : true
	}, {
		header : "领用(退回)数量",
		dataIndex : 'qty',
		width : 100,
		align : 'right',	
		sortable : true
	},  {
		header : "进价",
		dataIndex : 'rp',
		width : 80,
		align : 'right'
	}, {
		header : "进价金额",
		dataIndex : 'rpAmt',
		width : 120,
		align : 'right',
		sortable : true
	},/* {
		header : "售价",
		dataIndex : 'Sp',
		width : 80,
		align : 'right',
		sortable : true
	},{
		header : "售价金额",
		dataIndex : 'SpAmt',
		width : 120,
		align : 'right',	
		sortable : true
	}, */{
		header : "发放(退回)单号",
		dataIndex : 'indsNo',
		width : 160,
		align : 'left',
		sortable : true
	}, {
		header : "请领日期",
		dataIndex : 'dsrqDate',
		width : 100,
		align : 'left',
		sortable : true
	},{
		header:'请领单号',
		dataIndex:'dsrqNo',
		width:160
	}]);
	UserMatStatInfoCm.defaultSortable = true;
	var StatuTabPagingToolbar2 = new Ext.PagingToolbar({
		store : UserMatStatInfoStore,
		pageSize : 20,
		displayInfo : true
	});
	var UserMatStatInfoGrid = new Ext.ux.GridPanel({
		region: 'center',
		title: '领用明细',
		id : 'UserMatStatInfoGrid',
		title : '',
		height : 170,
		cm : UserMatStatInfoCm,
		sm : new Ext.grid.RowSelectionModel({
					singleSelect : true
				}),
		store : UserMatStatInfoStore,
		trackMouseOver : true,
		stripeRows : true,
		loadMask : true,
		bbar : StatuTabPagingToolbar2,
		viewConfig:{getRowClass : function(record,rowIndex,rowParams,store){
			var Month=record.get("trType");
				switch(Month){
					case "L":
					return 'classLightGoldenYellow';
					break;
				}
			}
		}
	});

	var HisListTab = new Ext.form.FormPanel({
		title:'科室人员物资领用查询',
		region : 'west',
		width : 300,
		labelAlign : 'right',
		frame : true,
		bodyStyle : 'padding:10px 1px 1px 1px;',
		tbar : [searchBT, '-', clearBT],		
		items:[{
				autoHeight : true,
				xtype: 'fieldset',
				title:'必选条件',
				items : [PhaLoc,StartDate,EndDate,StkGrpType,ItmDesc,ToLoc,GrpList,UserList]
			}]
	});

	var mainPanel = new Ext.ux.Viewport({
		layout : 'border',				
		items : [HisListTab, UserMatStatInfoGrid]
	});

});