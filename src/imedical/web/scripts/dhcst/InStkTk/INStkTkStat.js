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
		fieldLabel : '<font color=blue>'+$g('科室')+'</font>',
		id : 'PhaLoc',
		name : 'PhaLoc',
		anchor : '90%',
		width : 160,
		emptyText : '科室...',
		groupId:gGroupId
	});
	
	// 起始日期
	var StartDate = new Ext.ux.DateField({
				fieldLabel : '<font color=blue>'+$g('起始日期')+'</font>',
				id : 'StartDate',
				name : 'StartDate',
				anchor : '90%',
				width : 80,
				value : new Date().add(Date.DAY, - 30)
			});

	// 结束日期
	var EndDate = new Ext.ux.DateField({
				fieldLabel : '<font color=blue>'+$g('结束日期')+'</font>',
				id : 'EndDate',
				name : 'EndDate',
				anchor : '90%',
				width : 80,
				value : new Date()
			});
	var StartTime=new Ext.form.TextField({
		fieldLabel : $g('开始时间'),
		id : 'StartTime',
		name : 'StartTime',
		anchor : '90%',
		regex : /^(0\d{1}|1\d{1}|2[0-3]):[0-5]\d{1}:([0-5]\d{1})$/,
		regexText:$g('时间格式错误，正确格式hh:mm:ss'),
		width : 120
	});	

	var EndTime=new Ext.form.TextField({
		fieldLabel : $g('截止时间'),
		id : 'EndTime',
		name : 'EndTime',
		anchor : '90%',
		regex : /^(0\d{1}|1\d{1}|2[0-3]):[0-5]\d{1}:([0-5]\d{1})$/,
		regexText:$g('时间格式错误，正确格式hh:mm:ss'),
		width : 120
	});
	//损益标志
	var VarianceFlag=new Ext.form.RadioGroup({
		id:'VarianceFlag',
		columns:4,
		itemCls: 'x-check-group-alt',
		items:[
			{boxLabel:$g('仅盘盈'),name:'loss',id:'onlySurplus',inputValue:1,width:'100px'},
			{boxLabel:$g('仅盘亏'),name:'loss',id:'onlyLoss',inputValue:2},
			{boxLabel:$g('仅无损益'),name:'loss',id:'onlyBalance',inputValue:3},
			{boxLabel:$g('仅有损益'),name:'loss',id:'onlyNotBalance',inputValue:4},
			{boxLabel:$g('全部'),name:'loss',inputValue:0,id:'all',checked:true}
		]
	});
	
	// 查询按钮
	var QueryBT = new Ext.Toolbar.Button({
				text :$g( '查询'),
				tooltip :$g( '点击查询'),
				iconCls : 'page_find',
				width : 70,
				height : 30,
				handler : function() {
					Query();
				}
	});
	
	//查询盘点单
	function Query(){
		var StartDate=Ext.getCmp("StartDate").getValue()
		var EndDate=Ext.getCmp("EndDate").getValue()
		if(StartDate==""||EndDate=="")
		{
			Msg.info("warning", $g("开始日期和截止日期不能空！"));
			return;
		}
		
		var StartDate = Ext.getCmp("StartDate").getValue().format(App_StkDateFormat).toString();;
		var EndDate = Ext.getCmp("EndDate").getValue().format(App_StkDateFormat).toString();
		var startTime=Ext.getCmp("StartTime").getRawValue();
	    var endTime=Ext.getCmp("EndTime").getRawValue();
	    if(StartDate==EndDate && startTime>endTime){
				Msg.info("warning", $g("开始时间大于截止时间！"));
				return;
		}
		var PhaLoc = Ext.getCmp("PhaLoc").getValue();	
		if(PhaLoc==""){
			Msg.info("warning", $g("请选择盘点科室!"));
			return;
		}
		if(StartDate==""||EndDate==""){
			Msg.info("warning", $g("请选择开始日期和截止日期!"));
			return;
		}
		var CompFlag='Y';
		var TkComplete='Y';  //实盘完成标志
		var AdjComplete='';	//调整完成标志
		var Page=GridPagingToolbar.pageSize;
		var StrParams=PhaLoc+'^'+StartDate+'^'+EndDate+'^'+CompFlag+'^'+TkComplete+'^'+AdjComplete+"^"+startTime+"^"+endTime;
		MasterInfoStore.setBaseParam('Params',StrParams);
		MasterInfoStore.load({params:{start:0, limit:Page,sort:'instNo',dir:'asc'}});
	}
	
			//损益汇总
	var CollectBT = new Ext.Toolbar.Button({
		text : $g('损益汇总'),
		tooltip : $g('点击损益汇总'),
		iconCls : 'page_gear',
		width : 70,	
		height:30,
		handler : function() {
			ShowReport();
		}
	});
	
	function ShowReport()
	{
		var record=MasterInfoGrid.getSelectionModel().getSelected();
		if(record==null){
			Msg.info("warning",$g("请选择某一盘点单进行汇总！"));
			return;
		}
		var inst=record.get("inst");
		if(inst==null || inst==""){
			Msg.info("warning",$g("请选择某一盘点单进行汇总！"));
			return;
		}
		var varianceFlag=Ext.getCmp("VarianceFlag").getValue().getGroupValue();				//损益类型
		
		var StatFlag=Ext.getCmp("OptReport").getValue().getGroupValue();
		var sort="desc^ASC";
		var startTime=Ext.getCmp("StartTime").getRawValue();
	    var endTime=Ext.getCmp("EndTime").getRawValue();
		//明细
		if(StatFlag==1){
			var p_URL = 'dhccpmrunqianreport.csp?reportName=instktkstat-detail.raq&qPar='+
				sort +'&Inst=' +inst +'&Others='+varianceFlag+'&StartTime='+startTime+'&EndTime='+endTime;
			var NewWin=(window.open(p_URL,$g("盘点损益明细"),"top=100,left=20,width="+document.body.clientWidth*0.8+",height="+(document.body.clientHeight-50)+",scrollbars=1,resizable=yes"));
		} 
		//名称汇总
		else if(StatFlag==2){		
			var p_URL = 'dhccpmrunqianreport.csp?reportName=instktkstat-inc.raq&qPar='+
				sort +'&Inst=' +inst +'&Others='+varianceFlag+'&StartTime='+startTime+'&EndTime='+endTime;
			var NewWin=(window.open(p_URL,$g("盘点损益汇总"),"top=100,left=20,width="+document.body.clientWidth*0.8+",height="+(document.body.clientHeight-50)+",scrollbars=1,resizable=yes"));
		}
	}
	
	var MasterInfoStore=new Ext.data.JsonStore({
		url:url+"?actiontype=Query",
		autoDestroy: true,
		root : 'rows',
		totalProperty : "results",
		idProperty:"inst",
		fields:["inst","instNo", "date", "time","userName","status","locDesc", "comp", "stktkComp",
			"adjComp","adj","manFlag","freezeUom","includeNotUse","onlyNotUse","scgDesc","scDesc","frSb","toSb"],
		baseParam:{Params:''}
	});
	
	function renderCompFlag(value){
		if(value=='Y'){
			return $g('完成');
		}else{
			return $g('未完成')
		}	
	}
	function renderManaFlag(value){
		if(value=='Y'){
			return $g('管理药');
		}else{
			return $g('非管理药')
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
				header : $g("盘点单号"),
				dataIndex : 'instNo',
				width : 200,
				align : 'left',
				sortable : true
			}, {
				header : $g("盘点日期"),
				dataIndex : 'date',
				width : 100,
				align : 'left',
				sortable : true
			}, {
				header : $g('盘点时间'),
				dataIndex : 'time',
				width : 100,
				align : 'left',
				sortable : true
			}, {
				header : $g('盘点人'),
				dataIndex : 'userName',
				width : 70,
				align : 'left',
				sortable : true
			}, {
				header : $g('调整完成标志'),
				dataIndex : 'adjComp',
				width : 100,
				align : 'center',
				renderer:renderCompFlag,
				sortable : true
			}, {
				header : $g('管理药标志'),
				dataIndex : 'manFlag',
				width : 100,
				align : 'left',
				renderer:renderManaFlag,
				sortable : true
			}, {
				header : $g("类组"),
				dataIndex : 'scgDesc',
				width : 100,
				align : 'left',
				sortable : true
			}, {
				header : $g("库存分类"),
				dataIndex : 'scDesc',
				width : 100,
				align : 'left',
				sortable : true
			}, {
				header : $g("开始货位"),
				dataIndex : 'frSb',
				width : 100,
				align : 'left',
				sortable : true
			}, {
				header : $g("截止货位"),
				dataIndex : 'toSb',
				width : 100,
				align : 'left',
				sortable : true
			}]);
	MasterInfoCm.defaultSortable = true;
	var GridPagingToolbar = new Ext.PagingToolbar({
		store : MasterInfoStore,
		pageSize : PageSize,
		displayInfo : true,
		displayMsg : $g('当前记录 {0} -- {1} 条 共 {2} 条记录'),
		emptyMsg : "No results to display",
		prevText : $g("上一页"),
		nextText : $g("下一页"),
		refreshText : $g("刷新"),
		lastText : $g("最后页"),
		firstText : $g("第一页"),
		beforePageText : $g("当前页"),
		afterPageText : $g("共{0}页"),
		emptyMsg : $g("没有数据")
	});
	var MasterInfoGrid = new Ext.grid.GridPanel({
		id : 'MasterInfoGrid',
		title : '',
		height : 170,
		cm : MasterInfoCm,
		sm : new Ext.grid.RowSelectionModel({
					singleSelect : true
				}),
		store : MasterInfoStore,
		trackMouseOver : true,
		stripeRows : true,
		loadMask : true,
		bbar:[GridPagingToolbar]
	});
	
	var myForm=new Ext.FormPanel({
		title:$g('盘点损益汇总'),
		frame:true,
		labelWidth:60,
		labelAlign : 'right',
		tbar:[QueryBT,'-',CollectBT],
		layout:'column',
		items:[{
			columnWidth:0.6,
			xtype:'fieldset',
			title:$g('查询条件'),
			//bodyStyle:'padding:7px',
			layout:'column',
			defaults:{border:false},
			items:[{
				xtype:'fieldset',
				columnWidth:0.4,
				items:[PhaLoc]
			},{
				xtype:'fieldset',
				columnWidth:0.3,
				defaults:{width:140},
				items:[StartDate,StartTime]
			},{
				xtype:'fieldset',
				columnWidth:0.3,
				defaults:{width:140},
				items:[EndDate,EndTime]
			}]
		},{
			xtype:'fieldset',
			title:$g('损益报表条件'),
			columnWidth:0.35,
			bodyStyle:'padding:7px',
			layout:'column',
			defaults:{border:false},
			items:[VarianceFlag]			
		}]
	})
	
	var myView=new Ext.Viewport({
		layout:'border',
		items:[{
			region:'north',
			height:175,
			layout:'fit',
			items:[myForm]
		},{
			region:'center',
			layout:'fit',
			items:MasterInfoGrid
		},{
			region:'south',
			height:100,
			frame:true,
			
			items:[{
				title:$g('报表类型'),		
				style:'padding:0px 0px 0px 10px',
				xtype:'fieldset',
				items:[{
					xtype:'radiogroup',
					column:2,
					id:'OptReport',
					items:[
						{boxLabel:$g('损益明细'),name:'OptStat',inputValue:1,checked:true},
						{boxLabel:$g('名称汇总'),name:'OptStat',inputValue:2}
					]
				}]
				
			}]
		}]
	});
});