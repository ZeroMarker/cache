// /名称:调价损益汇总
// /描述:调价损益汇总
// /编写者：zhangdongmei
// /编写日期: 2013.01.10

Ext.onReady(function(){
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	var gInciDr="";
	gGroupId=session['LOGON.GROUPID'];
	var gLocId=session['LOGON.CTLOCID'];

	var ItmDesc = new Ext.form.TextField({
		fieldLabel : '物资名称',
		id : 'ItmDesc',
		name : 'ItmDesc',
		anchor : '95%',
		listeners : {
			specialkey : function(field, e) {
				if (e.getKey() == Ext.EventObject.ENTER) {
					var item=field.getValue();
					if (item != null && item.length > 0) {
						GetPhaOrderWindow(item, "", App_StkTypeCode, "", "N", "0", "",getDrugList);
					}
				}
			}
		}
	});
			
	function getDrugList(record) {
		if (record == null || record == "") {
			return;
		}
		gInciDr = record.get("InciDr");
		var inciCode=record.get("InciCode");
		var inciDesc=record.get("InciDesc");
		
		Ext.getCmp("ItmDesc").setValue(inciDesc);		
	}
	// 调价单号
	var AdjSpNo = new Ext.form.TextField({
		fieldLabel : '调价单号',
		id : 'AdjSpNo',
		name : 'AdjSpNo',
		anchor : '90%',
		width : 100
	});

	// 起始日期
	var StartDate = new Ext.ux.DateField({
		fieldLabel : '起始日期',
		id : 'StartDate',
		name : 'StartDate',
		anchor : '90%',
		width : 120,
		value : new Date().add(Date.DAY,-1)
	});

	// 结束日期
	var EndDate= new Ext.ux.DateField({
		fieldLabel : '结束日期',
		id : 'EndDate',
		name : 'EndDate',
		anchor : '90%',
		width : 120,
		value : new Date()
	});

	// 科室
	var Loc=new Ext.ux.LocComboBox({
		fieldLabel : '科室',
		id : 'Loc',
		name : 'Loc',
		anchor : '95%',
		width : 120,
		emptyText : '科室...',
		groupId:gGroupId,
		defaultLoc:{}
	});
	SetLogInDept(Ext.getCmp("Loc").getStore(),"Loc");
	
	ReasonForAdjSpStore.load();
	var AspReason=new Ext.form.ComboBox({
		id:'AspReason',
		fieldLabel:'调价原因',
		name:'AspReason',
		width:100,
		emptyText:'调价原因',
		store:ReasonForAdjSpStore,
		valueField : 'RowId',
		displayField : 'Description'
	});
	
	var OptType=new Ext.form.RadioGroup({
		id:'OptType',
		columns:1,
		itemCls: 'x-check-group-alt',
		items:[
			{boxLabel:'全部',name:'type',inputValue:0,checked:true},
			{boxLabel:'差额为正',name:'type',inputValue:1},
			{boxLabel:'差额为负',name:'type',inputValue:-1}
		]
	});
	
	var Vendor=new Ext.ux.VendorComboBox({
		id : 'Vendor',
		name : 'Vendor',
		anchor : '95%',
		params : {LocId : 'Loc'},
		width : 200
	});
	
	// 确定按钮
	var OkBT = new Ext.Toolbar.Button({
		id : "OkBT",
		text : '统计',
		tooltip : '点击统计',
		width : 70,
		iconCls : 'page_find',
		height : 30,
		handler : function() {
			ShowReport();
		}
	}); 

	function ShowReport()
	{
		var StartDate=Ext.getCmp("StartDate").getValue().format(ARG_DATEFORMAT).toString();;
		var EndDate=Ext.getCmp("EndDate").getValue().format(ARG_DATEFORMAT).toString();;
		var LocId=Ext.getCmp("Loc").getValue();
		var InciDesc=Ext.getCmp("ItmDesc").getValue();
		if (InciDesc == null || InciDesc == "") {
			gInciDr = "";
		}
		if(gInciDr!=""&gInciDr!=null){
			InciDesc="";
		}
		var InciId=gInciDr;
		var AspNo=Ext.getCmp("AdjSpNo").getValue();				//调价单号
		var AspReasonId=Ext.getCmp("AspReason").getValue();		//调价原因id
		var OptType=Ext.getCmp("OptType").getValue().getGroupValue();				//差额类型
		var VenId=Ext.getCmp("Vendor").getValue();
		var StatFlag=Ext.getCmp("StatType").getValue().getGroupValue();
		
		var winWidth = document.body.clientWidth, winHeight = document.body.clientHeight;
		var winStyle = "top=20,left=20,width="+winWidth+",height="+winHeight+",scrollbars=1";
		//单品汇总
		if(StatFlag==1){
			var Others=LocId+"^"+AspNo+"^"+AspReasonId+"^"+OptType+"^"+InciId+"^^"+InciDesc;
			var p_URL = PmRunQianUrl+'?reportName=DHCSTM_aspamountstat-inc.raq&StartDate='+
				StartDate +'&EndDate=' +EndDate +'&Others='+Others;
			var NewWin=(window.open(p_URL,"调价损益单品汇总",winStyle));
		}
		//单品科室汇总
		else if(StatFlag==2){
			var Others=LocId+"^"+AspNo+"^"+AspReasonId+"^"+OptType+"^"+InciId+"^^"+InciDesc;
			var p_URL = PmRunQianUrl+'?reportName=DHCSTM_aspamountstat-incloc.raq&StartDate='+
				StartDate +'&EndDate=' +EndDate +'&Others='+Others;
			var NewWin=open(p_URL,"调价损益单品科室汇总",winStyle);
		}
		//供应商汇总
		else if(StatFlag==3){
			var Others=LocId+"^"+AspNo+"^"+AspReasonId+"^"+OptType+"^"+InciId+"^"+VenId+"^"+InciDesc;
			var p_URL = PmRunQianUrl+'?reportName=DHCSTM_aspamountstat-vendor.raq&StartDate='+
				StartDate +'&EndDate=' +EndDate +'&Others='+Others;
			var NewWin=open(p_URL,"调价损益供应商汇总",winStyle);
		}
	}
		
	var FormPanel=new Ext.ux.FormPanel({
		title:'调价损益汇总',
		region:'north',
		height:200,
		tbar:[OkBT],
		items:[{
			layout:'column',
			xtype:'fieldset',
			title:'查询条件',
			labelAlign:'right',
			style:'padding:10px 0px 0px 10px',
			defaults:{border:false},
			items:[{
				columnWidth:0.3,
				xtype:'fieldset',
				defaults:{width:120},
				items:[StartDate,EndDate,AdjSpNo]
			},{
				columnWidth:0.4,
				xtype:'fieldset',
				defaults:{width:180},
				items:[Loc,ItmDesc,Vendor]
			},{
				columnWidth:0.3,
				xtype:'fieldset',
				items:[OptType]
			}]
		}]
	});
	
	var view=new Ext.ux.Viewport({
		layout:'border',
		items:[FormPanel,
			{
			region:'center',
			frame:true,
			items:[{
				title:'报表类型',		
				style:'padding:0px 0px 0px 10px',
				xtype:'fieldset',
				items:[{
				xtype:'radiogroup',
				id:'StatType',
				items:[{boxLabel:'单品汇总',name:'OptStat',inputValue:1,checked:true},
					{boxLabel:'单品科室汇总',name:'OptStat',inputValue:2},
					{boxLabel:'供应商汇总',name:'OptStat',inputValue:3}]
				}]
			}]
		}]
	});
});