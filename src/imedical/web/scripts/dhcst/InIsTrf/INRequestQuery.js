// /名称: 出入库汇总统计条件录入(财务用)
// /描述:  出入库汇总统计条件录入(财务用)
// /编写者：MYQ
// /编写日期: 2014.06.30
Ext.onReady(function() {
//function loadForm1(){
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	var gGroupId=session['LOGON.GROUPID'];
	var gLocId=session['LOGON.CTLOCID'];
	var gUserId=session['LOGON.USERID'];
	var gUserName=session['LOGON.USERNAME'];
	var FrLoc=new Ext.ux.LocComboBox({
		fieldLabel : '<font color=blue>'+$g('供给科室')+'</font>',
		id : 'FrLoc',
		name : 'FrLoc',
		anchor : '90%',
		emptyText : '科室...',
		groupId:gGroupId
	});
	
	var ToLoc = new Ext.ux.LocComboBox({
		fieldLabel : '<font color=blue>'+$g('申请科室')+'</font>',
		id : 'ToLoc',
		name : 'ToLoc',
		emptyText : '接收科室...',
		anchor : '90%',
		defaultLoc:''
	});
	
	var DateFrom = new Ext.ux.DateField({
		fieldLabel : '<font color=blue>'+$g('开始日期')+'</font>',
		id : 'DateFrom',
		name : 'DateFrom',
		anchor : '90%',
		value :DefaultStDate()
	});
	
	var DateTo = new Ext.ux.DateField({
		fieldLabel : '<font color=blue>'+$g('截止日期')+'</font>',
		id : 'DateTo',
		name : 'DateTo',
		anchor : '90%',
		value : DefaultEdDate()
	});
	
	// 药品类组
	var StkGrpType=new Ext.ux.StkGrpComboBox({ 
		id : 'StkGrpType',
		name : 'StkGrpType',
		anchor : '90%',
		StkType:App_StkTypeCode,     //标识类组类型
		LocId:gLocId,
		UserId:gUserId
	});
	
	var InciDr = new Ext.form.TextField({
		fieldLabel : $g('药品RowId'),
		id : 'InciDr',
		name : 'InciDr',
		anchor : '90%',
		valueNotFoundText : ''
	});

	var InciCode = new Ext.form.TextField({
		fieldLabel : $g('药品编码'),
		id : 'InciCode',
		name : 'InciCode',
		anchor : '90%',
		valueNotFoundText : ''
	});
	var InciDesc = new Ext.form.TextField({
		fieldLabel : $g('药品名称'),
		id : 'InciDesc',
		name : 'InciDesc',
		anchor : '90%',
		listeners : {
			specialkey : function(field, e) {
				if (e.getKey() == Ext.EventObject.ENTER) {
					var stkGrp=Ext.getCmp("StkGrpType").getValue();
					var inputText=field.getValue();
					GetPhaOrderInfo(inputText,stkGrp);
				}
			}
		}
	});
	
	var UnTranser = new Ext.form.Checkbox({
					boxLabel : $g('仅未转移'),
					id : 'UnTranser',
					name : 'UnTranser',
					anchor : '90%',
					checked : false
				});
	var HelpBT = new Ext.Button({
	　　　　id:'HelpBtn',
			text : $g('帮助'),
			width : 70,
			height : 30,
			renderTo: Ext.get("tipdiv"),
			iconCls : 'page_help'
			
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
		var inciDr = record.get("InciDr");
		var inciCode=record.get("InciCode");
		var inciDesc=record.get("InciDesc");
		Ext.getCmp("InciDr").setValue(inciDr);
		Ext.getCmp("InciCode").setValue(inciCode);
		Ext.getCmp("InciDesc").setValue(inciDesc);
	} 

	
	
      // 申请单明细查询
		var InreqDetail = new Ext.form.Radio({
					boxLabel : $g('申请单明细查询'),
					id : 'InreqDetail',
					name : 'ReportType',
					anchor : '80%',
					checked : true
				});	
		
		
	
		// 统计按钮
		var OkBT = new Ext.Toolbar.Button({
					id : "OkBT",
					text : $g('查询'),
					tooltip : $g('点击查询'),
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
				Msg.info("warning", $g("开始日期和截止日期不能空！"));
				return;
			}
			var StartDate=Ext.getCmp("DateFrom").getValue().format(App_StkDateFormat).toString();;
			var EndDate=Ext.getCmp("DateTo").getValue().format(App_StkDateFormat).toString();;
			var FrLocId=Ext.getCmp("FrLoc").getValue();
			var ToLocId=Ext.getCmp("ToLoc").getValue();
			
			var UnTranser=Ext.getCmp("UnTranser").getValue();
			if(UnTranser==true){
				UnTranser=1;
			}
			else{
				UnTranser=0;
			}
			var stktyperowid=Ext.getCmp("StkGrpType").getValue();
			var Others=UnTranser+"^"+stktyperowid
			var incidesc=Ext.getCmp("InciDesc").getValue();
			if ((incidesc==null)||(incidesc==""))
			{
				Ext.getCmp("InciDr").setValue("");
			}
			var IncRowid=Ext.getCmp("InciDr").getValue();				//库存项id
			if (IncRowid == undefined) {
				IncRowid = "";
			}
			
			var FlagInreqDetail=Ext.getCmp("InreqDetail").getValue();   //申请单明细
			
			var reportFrame=document.getElementById("frameReport");
			var p_URL="";
			var RQDTFormat=App_StkRQDateFormat+" "+App_StkRQTimeFormat;
			
			//入库清单列表(财务用)
		    if(FlagInreqDetail==true){
				p_URL = 'dhccpmrunqianreport.csp?reportName=DHCST_QueryInreqItm_Export.raq&StartDate='+
					StartDate +'&EndDate=' +EndDate +'&FrLoc='+ FrLocId+'&ToLoc='+ ToLocId+'&Inci='+ IncRowid+
					'&Others='+ Others+'&UserName='+gUserName+'&HospDesc='+App_LogonHospDesc+'&RQDTFormat='+RQDTFormat;
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
			tbar : [OkBT,'->',HelpBT],
			items : [{
						xtype : 'fieldset',
						title : $g('查询条件'),					
						items : [FrLoc,ToLoc,DateFrom,DateTo,StkGrpType,InciDesc,UnTranser]
					}, {
						xtype : 'fieldset',
						title : $g('报表类型'),
						items : [InreqDetail]
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
						title:$g("请求单转移情况查询"),
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
   new Ext.ToolTip({
        target: 'HelpBtn',
        anchor: 'buttom',
        width: 250,
        anchorOffset: 50,
		hideDelay : 90000,
        html: "<font size=2 color=blue ><b>"+$g("查询库存请求单的转移情况")+"</b></font>"
   });
    Ext.getCmp('HelpBtn').focus('',100); //初始化页面给某个元素设置焦点

	
});