// /名称: dhcst.drugposioncondition.csp
// /描述: 管制药品日消耗以及处方等级
// /编写者：Yanbl
// /编写日期: 2019-10-18
Ext.onReady(function() {
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	var gGroupId=session['LOGON.GROUPID'];
	var gLocId=session['LOGON.CTLOCID'];
	var gUserId=session['LOGON.USERID'];
	var gUserName=session['LOGON.USERNAME'];
	
	var DateFrom = new Ext.ux.DateField({
		fieldLabel : '<font color=blue>开始日期</font>',
		id : 'DateFrom',
		name : 'DateFrom',
		anchor : '90%',
		value :new Date()
	});
	
	var DateTo = new Ext.ux.DateField({
		fieldLabel : '<font color=blue>截止日期</font>',
		id : 'DateTo',
		name : 'DateTo',
		anchor : '90%',
		value : new Date()
	});
	
	var InciDr = new Ext.form.TextField({
				fieldLabel : '药品RowId',
				id : 'InciDr',
				name : 'InciDr',
				valueNotFoundText : ''
			});

	var InciDesc = new Ext.form.TextField({
				fieldLabel : '药品名称',
				id : 'InciDesc',
				name : 'InciDesc',
				anchor : '90%',
				listeners : {
					specialkey : function(field, e) {
						if (e.getKey() == Ext.EventObject.ENTER) {
							var inputText=field.getValue();
							GetPhaOrderInfo(inputText,"");
						}
					}
				}
			});
	//管制分类
	var PHCDFPhcDoDR = new Ext.ux.ComboBox({
			fieldLabel : '管制分类',
			id : 'PHCDFPhcDoDR',
			name : 'PHCDFPhcDoDR',
			store : PhcPoisonStore,
			valueField : 'RowId',
			displayField : 'Description'
			});
	// 逐日消耗
	var PoisonStat = new Ext.form.Radio({
				boxLabel : '逐日消耗(本科室)',
				id : 'PoisonStat',
				name : 'ReportType',
				anchor : '80%',
				checked : true
			});
	// 处方统计
	var PoisonDetail = new Ext.form.Radio({
				boxLabel : '处方统计(本科室)',
				id : 'PoisonDetail',
				name : 'ReportType',
				anchor : '80%',
				checked : false
			});
			
	// 门诊基本药物占比
	var BasiOutStat = new Ext.form.Radio({
				boxLabel : '门诊基本药物占比',
				id : 'BasiOutStat',
				name : 'ReportType',
				anchor : '80%',
				checked : false
			});
	// 住院基本药物药占比
	var BasiInStat = new Ext.form.Radio({
				boxLabel : '住院基本药物占比',
				id : 'BasiInStat',
				name : 'ReportType',
				anchor : '80%',
				checked : false
			});
    /**
	 * 调用药品窗体并返回结果
	 */
	function GetPhaOrderInfo(item, group) {
					
		if (item != null && item.length > 0) {
			GetPhaOrderWindow(item, group, App_StkTypeCode, "", "N", "0", "",
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
		var inciRowid = record.get("InciDr");
		var inciCode=record.get("InciCode");
		var inciDesc=record.get("InciDesc");
		Ext.getCmp("InciDr").setValue(inciRowid);
		Ext.getCmp("InciDesc").setValue(inciDesc);
	}


		

	var ClearBT = new Ext.Toolbar.Button({
				id : "ClearBT",
				text : '清空',
				tooltip : '点击清空',
				width : 70,
				height : 30,
				iconCls : 'page_clearscreen',
				handler : function() {
					Ext.getCmp('HisListTab').getForm().items.each(function(f){ 
						f.setValue("");
					});
					Ext.getCmp("DateFrom").setValue(new Date());
					Ext.getCmp("DateTo").setValue(new Date());
					Ext.getCmp("PoisonStat").setValue(true);
					document.getElementById("frameReport").src=DHCSTBlankBackGround;
				}
			});
		// 统计按钮
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
			var StartDate=Ext.getCmp("DateFrom").getValue()
			var EndDate=Ext.getCmp("DateTo").getValue()
			if(StartDate==""||EndDate=="")
			{
				Msg.info("warning", "开始日期和截止日期不能空！");
				return;
			}
			var StartDate=Ext.getCmp("DateFrom").getValue().format(App_StkDateFormat).toString();
			var EndDate=Ext.getCmp("DateTo").getValue().format(App_StkDateFormat).toString();
			var LocId=gLocId
			var LocDesc=App_LogonLocDesc
			var incidesc=Ext.getCmp("InciDesc").getValue();
			if ((incidesc==null)||(incidesc==""))
			{
				Ext.getCmp("InciDr").setValue("");
			}
		
			var IncRowid=Ext.getCmp("InciDr").getValue();				//库存项id
			if (IncRowid == undefined) {
				IncRowid = "";
			}	
			var PoisonStat=Ext.getCmp("PoisonStat").getValue();
			var PoisonDetail=Ext.getCmp("PoisonDetail").getValue();
			var BasiOutStat=Ext.getCmp("BasiOutStat").getValue();
			var BasiInStat=Ext.getCmp("BasiInStat").getValue();
			var PHCDFPhcDoDR = Ext.getCmp("PHCDFPhcDoDR").getValue();
			var PoisonDesc=Ext.getCmp("PHCDFPhcDoDR").getRawValue();
			if((PoisonStat==true)&&(PHCDFPhcDoDR=="")){
				Msg.info("warning", "逐日消耗管制分类不能为空！");
				Ext.getCmp("PHCDFPhcDoDR").focus();
				return;
				}
			if((PoisonDetail==true)&&(PHCDFPhcDoDR=="")){
				Msg.info("warning", "处方统计管制分类不能为空！");
				Ext.getCmp("PHCDFPhcDoDR").focus();
				return;
				}
			var RQDTFormat=App_StkRQDateFormat+" "+App_StkRQTimeFormat;
			var reportFrame=document.getElementById("frameReport");
			var p_URL="";
			//业务损益明细列表
			if(PoisonStat==true){
				
				p_URL = 'dhccpmrunqianreport.csp?reportName=DHCST_PoisonStat_Total.raq&StartDate='+
					StartDate +'&EndDate=' +EndDate +'&LocId='+ LocId+'&Poison='+PHCDFPhcDoDR+'&IncRowid='+IncRowid+'&HospDesc='+App_LogonHospDesc+'&UserName='+gUserName+
					'&LocDesc='+LocDesc+'&RQDTFormat='+RQDTFormat+'&PoisonDesc='+PoisonDesc;
			} 			
			else if(PoisonDetail==true){
				
				p_URL = 'dhccpmrunqianreport.csp?reportName=DHCST_PoisonStat_Detail.raq&StartDate='+
					StartDate +'&EndDate=' +EndDate +'&LocId='+ LocId+'&Poison='+PHCDFPhcDoDR+'&IncRowid='+IncRowid+'&HospDesc='+App_LogonHospDesc+'&UserName='+gUserName+
					'&LocDesc='+LocDesc+'&RQDTFormat='+RQDTFormat+'&PoisonDesc='+PoisonDesc;
			}else if(BasiOutStat==true){
				
				p_URL = 'dhccpmrunqianreport.csp?reportName=DHCST_BasiOutStat.raq&StartDate='+
					StartDate +'&EndDate=' +EndDate +'&HospDesc='+App_LogonHospDesc+'&UserName='+gUserName+
					'&LocDesc='+LocDesc+'&RQDTFormat='+RQDTFormat;
			} else if(BasiInStat==true){
				
				p_URL = 'dhccpmrunqianreport.csp?reportName=DHCST_BasiInStat.raq&StartDate='+
					StartDate +'&EndDate=' +EndDate +'&HospDesc='+App_LogonHospDesc+'&UserName='+gUserName+
					'&LocDesc='+LocDesc+'&RQDTFormat='+RQDTFormat;
			}
	       reportFrame.src=p_URL;
	       }
		var HisListTab = new Ext.form.FormPanel({
			id : 'HisListTab',
			labelWidth : 60,
			labelAlign : 'right',
			frame : true,
			autoScroll : true,
			bodyStyle : 'padding:5px;',
			tbar : [OkBT,'-',ClearBT],
			items : [{
						xtype : 'fieldset',
						title : '查询条件',					
						items : [DateFrom,DateTo,PHCDFPhcDoDR,InciDesc]   //StkGrpType,
					}, {
						xtype : 'fieldset',
						title : '报表类型',
						items : [PoisonStat,PoisonDetail,BasiOutStat,BasiInStat]
					}]
		});

	var reportPanel=new Ext.Panel({
		//autoScroll:true,
		layout:'fit',
		html:'<iframe id="frameReport" height="100%" width="100%" style="border:none" src='+DHCSTBlankBackGround+'>'
	})
		// 页面布局
		var mainPanel = new Ext.Viewport({
					layout : 'border',
					items : [{
						region:'west',
						title:"管制药品分类统计",
						width:300,
						split:true,
						collapsible:true,
						minSize:250,
						maxSize:350,
						layout:'fit',
						items:HisListTab
					},{
						region:'center',
						layout:'fit',
						items:reportPanel
					}]
				});
	
});