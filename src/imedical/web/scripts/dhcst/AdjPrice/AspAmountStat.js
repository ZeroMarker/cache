// /名称:调价损益汇总
// /描述:调价损益汇总
// /编写者：zhangdongmei
// /编写日期: 2013.01.10

Ext.onReady(function(){
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	if(gParamCommon.length<1){
		GetParamCommon();  //初始化公共参数配置
	}
	var gGroupId=session['LOGON.GROUPID'];
	var gUserName=session['LOGON.USERNAME'];
	var InciDr = new Ext.form.TextField({
				fieldLabel : '药品RowId',
				id : 'InciDr',
				name : 'InciDr',
				anchor : '90%',
				width : 120,
				valueNotFoundText : '',
				value:''
			});

	var ItmDesc = new Ext.form.TextField({
				fieldLabel : '药品名称',
				id : 'ItmDesc',
				name : 'ItmDesc',
				anchor : '90%',
				width : 120,
				listeners : {
					specialkey : function(field, e) {
						if (e.getKey() == Ext.EventObject.ENTER) {
							var item=field.getValue();
							if (item != null && item.length > 0) {
			GetPhaOrderWindow(item, "", App_StkTypeCode, "", "N", "0", "",
					getDrugList);
							}
						}
					}
				}
			});

	/**
	 * 返回方法
	*/
	function getDrugList(record) {
		if (record == null || record == "") {
			return;
		}
		var inciRowid = record.get("InciDr");
		//var inciCode=record.get("InciCode");
		var inciDesc=record.get("InciDesc");
		Ext.getCmp("InciDr").setValue(inciRowid);
		//Ext.getCmp("InciCode").setValue(inciCode);
		Ext.getCmp("ItmDesc").setValue(inciDesc);
	}
	// 调价单号
	var AdjSpNo = new Ext.form.TextField({
				fieldLabel : '调价单号',
				id : 'AdjSpNo',
				name : 'AdjSpNo',
				anchor : '90%',
				width : 120
			});

	// 起始日期
	var StartDate = new Ext.ux.DateField({
			fieldLabel : '<font color=blue>起始日期</font>',
			id : 'StartDate',
			name : 'StartDate',
			anchor : '90%',
			width : 120,
			value : new Date().add(Date.DAY,-1)
		});

	// 结束日期
	var EndDate= new Ext.ux.DateField({
			fieldLabel : '<font color=blue>结束日期</font>',
			id : 'EndDate',
			name : 'EndDate',
			anchor : '90%',
			width : 120,
			value : new Date()
		});
		
	var StartTime=new Ext.form.TextField({
		fieldLabel : '开始时间',
		id : 'StartTime',
		name : 'StartTime',
		anchor : '90%',
		regex : /^(0\d{1}|1\d{1}|2[0-3]):[0-5]\d{1}:([0-5]\d{1})$/,
		regexText:'时间格式错误，正确格式hh:mm:ss',
		width : 120
	});	

	var EndTime=new Ext.form.TextField({
		fieldLabel : '截止时间',
		id : 'EndTime',
		name : 'EndTime',
		anchor : '90%',
		regex : /^(0\d{1}|1\d{1}|2[0-3]):[0-5]\d{1}:([0-5]\d{1})$/,
		regexText:'时间格式错误，正确格式hh:mm:ss',
		width : 120
	});
	
	// 科室
	var Loc=new Ext.ux.LocComboBox({
		fieldLabel : '科室',
		id : 'Loc',
		name : 'Loc',
		anchor : '90%',
		width : 120,
		emptyText : '科室...',
		groupId:gGroupId
	});
	
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
		anchor : '90%',
		width : 120
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
		var InciDesc=Ext.getCmp("ItmDesc").getValue();
		if(InciDesc==null || InciDesc==""){
			Ext.getCmp("InciDr").setValue("");
		}
		var StartDate=Ext.getCmp("StartDate").getValue()
		var EndDate=Ext.getCmp("EndDate").getValue()
		if(StartDate==""||EndDate=="")
		{
			Msg.info("warning", "开始日期和截止日期不能空！");
			return;
		}
		
		var StartDate=Ext.getCmp("StartDate").getValue().format(App_StkDateFormat).toString();;
		var EndDate=Ext.getCmp("EndDate").getValue().format(App_StkDateFormat).toString();;
		var startTime=Ext.getCmp("StartTime").getRawValue();
	    var endTime=Ext.getCmp("EndTime").getRawValue();
	    if(StartDate==EndDate && startTime>endTime){
				Msg.info("warning", "开始时间大于截止时间！");
				return;
		}
		var LocId=Ext.getCmp("Loc").getValue();
		var InciId=Ext.getCmp("InciDr").getValue();
		var AspNo=Ext.getCmp("AdjSpNo").getValue();				//调价单号
		var AspReasonId=Ext.getCmp("AspReason").getValue();		//调价原因id
		var OptType=Ext.getCmp("OptType").getValue().getGroupValue();				//差额类型
		var VenId=Ext.getCmp("Vendor").getValue();
		var StatFlag=Ext.getCmp("StatType").getValue().getGroupValue();
		var RQDTFormat=App_StkRQDateFormat+" "+App_StkRQTimeFormat;
		var p_URL = '';
		//单品汇总
		if(StatFlag==1){
			var Others=LocId+"^"+AspNo+"^"+AspReasonId+"^"+OptType+"^"+InciId+"^"+""+"^"+VenId+"^"+"1";
			if (gParamCommon[7]==3){ //批次价
				p_URL='dhccpmrunqianreport.csp?reportName=aspamountstat-inc-batch.raq&StartDate='+
					StartDate +'&EndDate=' +EndDate +'&Others='+Others+'&StartTime='+startTime+'&EndTime='+endTime+'&UserName='+gUserName+'&HospDesc='+App_LogonHospDesc+'&RQDTFormat='+RQDTFormat;
			}else{
				p_URL='dhccpmrunqianreport.csp?reportName=aspamountstat-inc.raq&StartDate='+
				StartDate +'&EndDate=' +EndDate +'&Others='+Others+'&StartTime='+startTime+'&EndTime='+endTime+'&UserName='+gUserName+'&HospDesc='+App_LogonHospDesc+'&RQDTFormat='+RQDTFormat;
			}
			var NewWin=(window.open(p_URL,"调价损益单品汇总","top=100,left=20,width="+document.body.clientWidth*0.8+",height="+(document.body.clientHeight-50)+",scrollbars=1,resizable=yes"));
		} 
		//单品科室汇总
		else if(StatFlag==2){
			var Others=LocId+"^"+AspNo+"^"+AspReasonId+"^"+OptType+"^"+InciId+"^"+""+"^"+VenId+"^"+"2";;
			if (gParamCommon[7]==3){ //批次价
				p_URL = 'dhccpmrunqianreport.csp?reportName=aspamountstat-incloc-batch.raq&StartDate='+
				StartDate +'&EndDate=' +EndDate +'&Others='+Others+'&StartTime='+startTime+'&EndTime='+endTime+'&UserName='+gUserName+'&HospDesc='+App_LogonHospDesc+'&RQDTFormat='+RQDTFormat;
			}else{
				p_URL = 'dhccpmrunqianreport.csp?reportName=aspamountstat-incloc.raq&StartDate='+
				StartDate +'&EndDate=' +EndDate +'&Others='+Others+'&StartTime='+startTime+'&EndTime='+endTime+'&UserName='+gUserName+'&HospDesc='+App_LogonHospDesc+'&RQDTFormat='+RQDTFormat;
			}
			var NewWin=open(p_URL,"调价损益单品科室汇总","top=100,left=20,width="+document.body.clientWidth*0.8+",height="+(document.body.clientHeight-50)+",scrollbars=1");
		}
		//供应商汇总
		else if(StatFlag==3){
			if (gParamCommon[7]==3){ //批次价
				var Others=LocId+"^"+AspNo+"^"+AspReasonId+"^"+OptType+"^"+InciId+"^"+"^"+VenId;
				p_URL = 'dhccpmrunqianreport.csp?reportName=aspamountstat-vendor-batch.raq&StartDate='+
					StartDate +'&EndDate=' +EndDate +'&Others='+Others+'&StartTime='+startTime+'&EndTime='+endTime+'&UserName='+gUserName+'&HospDesc='+App_LogonHospDesc+'&RQDTFormat='+RQDTFormat;

			}else{
				var Others=LocId+"^"+AspNo+"^"+AspReasonId+"^"+OptType+"^"+InciId+"^"+VenId;
				p_URL = 'dhccpmrunqianreport.csp?reportName=aspamountstat-vendor.raq&StartDate='+
					StartDate +'&EndDate=' +EndDate +'&Others='+Others+'&StartTime='+startTime+'&EndTime='+endTime+'&UserName='+gUserName+'&HospDesc='+App_LogonHospDesc+'&RQDTFormat='+RQDTFormat;
			}
			var NewWin=open(p_URL,"调价损益供应商汇总","top=100,left=20,width="+document.body.clientWidth*0.8+",height="+(document.body.clientHeight-50)+",scrollbars=1");
		}
	}
		
	var FormPanel=new Ext.FormPanel({
		title:'调价损益汇总',
		frame:true,
		tbar:[OkBT],
		items:[{
			layout:'column',
			xtype:'fieldset',
			title:'查询条件',
			style:'padding:10px 10px 10px 10px',
			defaults:{border:false},
			items:[{
				columnWidth:0.3,
				xtype:'fieldset',
				defaults:{width:120},
				items:[StartDate,StartTime,EndDate,EndTime]
			},{
				columnWidth:0.3,
				xtype:'fieldset',
				defaults:{width:120},
				items:[Loc,AdjSpNo,ItmDesc,Vendor]
			},{
				columnWidth:0.4,
				xtype:'fieldset',
				items:[OptType]
			}]
		}]
	});
	
	var view=new Ext.Viewport({
		layout:'border',
		items:[{
			region:'north',
			height:250,
			layout:'fit',
			items:FormPanel
		},{
			region:'center',
			frame:true,
			items:[{
				title:'报表类型',		
				style:'padding:10px',
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
