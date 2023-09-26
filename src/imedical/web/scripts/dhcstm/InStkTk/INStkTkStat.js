// /名称: 盘点损益汇总
// /描述: 盘点损益汇总
// /编写者：zhangdongmei
// /编写日期: 2013.02.04

Ext.onReady(function(){
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	
	var url=DictUrl+'instktkaction.csp';
	var gGroupId=session["LOGON.GROUPID"];
	
	var PhaLoc = new Ext.ux.LocComboBox({
		fieldLabel : '科室',
		id : 'PhaLoc',
		name : 'PhaLoc',
		anchor : '90%',
		width : 160,
		emptyText : '科室...',
		groupId:gGroupId
	});
	
	// 起始日期
	var StartDate = new Ext.ux.DateField({
				fieldLabel : '起始日期',
				id : 'StartDate',
				name : 'StartDate',
				anchor : '90%',
				
				width : 80,
				value : new Date().add(Date.DAY, - 30)
			});

	// 结束日期
	var EndDate = new Ext.ux.DateField({
				fieldLabel : '结束日期',
				id : 'EndDate',
				name : 'EndDate',
				anchor : '90%',
				width : 80,
				value : new Date()
			});
	
	//损益标志
	var VarianceFlag=new Ext.form.RadioGroup({
		id:'VarianceFlag',
		columns:3,
		itemCls: 'x-check-group-alt',
		items:[
			{boxLabel:'仅盘盈',name:'loss',id:'onlySurplus',inputValue:1},
			{boxLabel:'仅盘亏',name:'loss',id:'onlyLoss',inputValue:2},
			{boxLabel:'仅无损益',name:'loss',id:'onlyBalance',inputValue:3},
			{boxLabel:'仅有损益',name:'loss',id:'onlyNotBalance',inputValue:4},
			{boxLabel:'全部',name:'loss',inputValue:0,id:'all',checked:true}
		]
	});
	
	// 查询按钮
	var QueryBT = new Ext.Toolbar.Button({
				text : '查询',
				tooltip : '点击查询',
				iconCls : 'page_find',
				width : 70,
				height : 30,
				handler : function() {
					Query();
				}
	});
	
	//查询盘点单
	function Query(){
		var StartDate = Ext.getCmp("StartDate").getValue().format(ARG_DATEFORMAT).toString();;
		var EndDate = Ext.getCmp("EndDate").getValue().format(ARG_DATEFORMAT).toString();
		var PhaLoc = Ext.getCmp("PhaLoc").getValue();	
		if(PhaLoc==""){
			Msg.info("warning", "请选择盘点科室!");
			return;
		}
		if(StartDate==""||EndDate==""){
			Msg.info("warning", "请选择开始日期和截止日期!");
			return;
		}
		var CompFlag='Y';
		var TkComplete='Y';  //实盘完成标志
		var AdjComplete='';	//调整完成标志
		var Page=GridPagingToolbar.pageSize;
		var StrParams=PhaLoc+'^'+StartDate+'^'+EndDate+'^'+CompFlag+'^'+TkComplete+'^'+AdjComplete;
		MasterInfoStore.setBaseParam('Params',StrParams);
		MasterInfoStore.load({params:{start:0, limit:Page,sort:'instNo',dir:'asc'}});
	}

	//显示报表
	function ShowReport(){
		var panel=tabPanel.getActiveTab()
		var record=MasterInfoGrid.getSelectionModel().getSelected();
		if(record){
			var inst=record.get("inst");
			if(inst==null || inst==""){
				Msg.info("warning","请选择某一盘点单进行汇总！");
				return;
			}
			var varianceFlag=Ext.getCmp("VarianceFlag").getValue().getGroupValue();				//损益类型
			var sort="desc^ASC";
			if(panel.id=="Reportinstktkstatdetail"){
				p_URL = PmRunQianUrl+'?reportName=DHCSTM_instktkstat-detail.raq&qPar='+
				sort +'&Inst=' +inst +'&Others='+varianceFlag;
				var reportFrame=document.getElementById("frameReportinstktkstatdetail");
				reportFrame.src=p_URL;
			}else if(panel.id=="Reportinstktkstatinc"){
				p_URL = PmRunQianUrl+'?reportName=DHCSTM_instktkstat-inc.raq&qPar='+
				sort +'&Inst=' +inst +'&Others='+varianceFlag;
				var reportFrame=document.getElementById("frameReportinstktkstatinc");
				reportFrame.src=p_URL;
			}else if(panel.id=="Reportinstktkstatbarcode"){
				p_URL = PmRunQianUrl+'?reportName=DHCSTM_instktkstat_barcode.raq&qPar='+
				sort +'&Inst=' +inst +'&Others='+varianceFlag;
				var reportFrame=document.getElementById("frameReportinstktkstatbarcode");
				reportFrame.src=p_URL;
			}else if(panel.id=="ReportinstktkstatIncsc"){
				p_URL = PmRunQianUrl+'?reportName=DHCSTM_instktkstat_Incsc.raq&qPar='+sort +'&Inst=' +inst +'&Others='+varianceFlag;
				var reportFrame=document.getElementById("frameReportinstktkstatIncsc");
				reportFrame.src=p_URL;
			}
		}
	}
	
	var MasterInfoStore=new Ext.data.JsonStore({
		url:url+"?actiontype=Query",
		autoDestroy: true,
		root : 'rows',
		totalProperty : "results",
		idProperty:"inst",
		fields:["inst","instNo", "date", "time","userName","status","locDesc", "comp", "stktkComp",
			"adjComp","adj","manFlag","freezeUom","includeNotUse","onlyNotUse","scgDesc","scDesc","frSb","toSb","HighValueFlag"],
		baseParam:{Params:''}
	});
	
	function renderCompFlag(value){
		if(value=='Y'){
			return '完成';
		}else{
			return '未完成'
		}	
	}
	function renderManaFlag(value){
		if(value=='Y'){
			return '重点关注';
		}else{
			return '非重点关注'
		}	
	}
	
	var nm = new Ext.grid.RowNumberer();
	var MasterInfoCm = new Ext.grid.ColumnModel([nm, {
				header : "RowId",
				dataIndex : 'inst',
				width : 100,
				align : 'left',
				sortable : true,
				hidden : true,
				hideable : false
			}, {
				header : "盘点单号",
				dataIndex : 'instNo',
				width : 120,
				align : 'left',
				sortable : true
			}, {
				header : "盘点日期",
				dataIndex : 'date',
				width : 100,
				align : 'left',
				sortable : true
			}, {
				header : '盘点时间',
				dataIndex : 'time',
				width : 100,
				align : 'left',
				sortable : true
			}, {
				header : '盘点人',
				dataIndex : 'userName',
				width : 70,
				align : 'left',
				sortable : true
			}, {
				header : '调整完成标志',
				dataIndex : 'adjComp',
				width : 100,
				align : 'center',
				renderer:renderCompFlag,
				sortable : true
			}, {
				header : '重点关注标志',
				dataIndex : 'manFlag',
				width : 100,
				align : 'left',
				renderer:renderManaFlag,
				sortable : true
			}, {
				header : "类组",
				dataIndex : 'scgDesc',
				width : 100,
				align : 'left',
				sortable : true
			}, {
				header : "库存分类",
				dataIndex : 'scDesc',
				width : 100,
				align : 'left',
				sortable : true
			}, {
				header : "开始货位",
				dataIndex : 'frSb',
				width : 100,
				align : 'left',
				sortable : true
			}, {
				header : "截止货位",
				dataIndex : 'toSb',
				width : 100,
				align : 'left',
				sortable : true
			}, {
				header : "盘点模式",
				dataIndex : 'HighValueFlag',
				width : 100,
				align : 'left',
				sortable : true
			}]);
	MasterInfoCm.defaultSortable = true;
	var GridPagingToolbar = new Ext.PagingToolbar({
		store : MasterInfoStore,
		pageSize : PageSize,
		displayInfo : true
	});
	var MasterInfoGrid = new Ext.grid.GridPanel({
		id : 'MasterInfoGrid',
		region:'center',
		layout:'fit',
		title : '盘点单信息',
		cm : MasterInfoCm,
		sm : new Ext.grid.RowSelectionModel({
					singleSelect : true
				}),
		store : MasterInfoStore,
		trackMouseOver : true,
		stripeRows : true,
		loadMask : true,
		bbar:[GridPagingToolbar],
		listeners:{
			'rowclick' : function(grid,rowindex,e){
				ShowReport();
			}
		}
	});

	var myForm=new Ext.ux.FormPanel({
		title:'盘点损益汇总',
		region:'north',
		tbar:[QueryBT],
		layout:'column',
		items:[{
			columnWidth:1,
			xtype : 'fieldset',
			title : '查询条件',
			layout : 'column',	
			style : 'padding:5px 0px 0px 5px',
			defaults : {border:false,xtype:'fieldset'},
			items:[{
				columnWidth:1,
				items:[PhaLoc,StartDate,EndDate]
			}]
		},{
			columnWidth:1,
			xtype : 'fieldset',
			title : '损益汇总条件',
			items:[VarianceFlag]
		}]
	})
	
	var tabPanel=new Ext.TabPanel({
		region:'center',
		activeTab:0,
		items:[{
			title:'损益明细',
			id:'Reportinstktkstatdetail',
			html:'<iframe id="frameReportinstktkstatdetail" height="100%" width="100%" src="../scripts/dhcstm/ExtUX/images/logon_bg.jpg"/>'
		},{
			title:'名称汇总',
			id:'Reportinstktkstatinc',
			html:'<iframe id="frameReportinstktkstatinc" height="100%" width="100%" src="../scripts/dhcstm/ExtUX/images/logon_bg.jpg"/>'
		},{
			title:'高值汇总',
			id:'Reportinstktkstatbarcode',
			html:'<iframe id="frameReportinstktkstatbarcode" height="100%" width="100%" src="../scripts/dhcstm/ExtUX/images/logon_bg.jpg"/>'
		},{
			title:'库存分类汇总',
			id:'ReportinstktkstatIncsc',
			html:'<iframe id="frameReportinstktkstatIncsc" height="100%" width="100%" src="../scripts/dhcstm/ExtUX/images/logon_bg.jpg"/>'
		}],
		listeners:{
			'tabchange':function(){
				ShowReport();
			}
		}
	})

	var panel=new Ext.Panel({
		region:"west",
		width:300,
		layout:'border',
		items : [myForm,MasterInfoGrid]
	});
	var myView=new Ext.ux.Viewport({
		layout:'border',
		items:[panel,tabPanel]
	});
});