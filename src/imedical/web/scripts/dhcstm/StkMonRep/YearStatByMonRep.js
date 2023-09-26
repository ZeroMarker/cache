///名称:科室维修统计报表
///描述:科室维修统计报表
///编写者:wangjiabin
///编写日期:2014-05-05
Ext.onReady(function() {
	
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	var gGroupId=session['LOGON.GROUPID'];
	var gLocId=session['LOGON.CTLOCID'];
	var gUserId=session['LOGON.USERID'];
	
	var PhaLoc = new Ext.ux.LocComboBox({
		fieldLabel : '科室',
		id : 'PhaLoc',
		name : 'PhaLoc',
		anchor : '90%',
		emptyText : '科室...',
		groupId : gGroupId
	});
	
	var YearNum = new Ext.form.TextField({
		fieldLabel : '年份',
		id : 'YearNum',
		anchor : '90%',
		allowBlank : false,
		value : new Date().getFullYear(),
		regex : /^2\d{3}$/,
		regexText : '请输入正确的年份格式!'
	});
	
	//类组汇总
	var ScgStat = new Ext.form.Radio({
		boxLabel : '类组汇总(库存转移)',
		id : 'ScgStat',
		name : 'ReportType',
		anchor : '80%',
		checked : true
	});
	//类组汇总
	var StkCatStat = new Ext.form.Radio({
		boxLabel : '库存分类(库存转移)',
		id : 'StkCatStat',
		name : 'ReportType',
		anchor : '80%',
		checked : false
	});
	//库存项入库退货
	var InciRecRetStat = new Ext.form.Radio({
		boxLabel : '入库退货明细',
		id : 'InciRecRetStat',
		name : 'ReportType',
		anchor : '80%',
		checked : false
	});
	//出库汇总(按科室)
	var OutLocStat = new Ext.form.Radio({
		boxLabel : '出库汇总(按科室)',
		id : 'OutLocStat',
		name : 'ReportType',
		anchor : '80%',
		checked : false
	});
	
	var ClearBT = new Ext.Toolbar.Button({
		id : "ClearBT",
		text : '清空',
		tooltip : '点击清空',
		width : 70,
		height : 30,
		iconCls : 'page_clearscreen',
		handler : function() {
			SetLogInDept(PhaLoc.getStore(),'PhaLoc');
			document.getElementById("frameReport").src="../scripts/dhcstm/ExtUX/images/logon_bg.jpg";
		}
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
	
	function ShowReport(){
		var PhaLoc = Ext.getCmp("PhaLoc").getValue();
		if(PhaLoc == ""){
			Msg.info("warning","科室不可为空!");
			return;
		}
		var YearNum = Ext.getCmp("YearNum").getValue();
		if(YearNum == ""){
			Msg.info("warning","请选择年份!");
			return;
		}
		var reportFrame = document.getElementById("frameReport");
		var ScgStatFlag = Ext.getCmp("ScgStat").getValue();
		var StkCatStatFlag = Ext.getCmp("StkCatStat").getValue();
		var InciRecRetStatFlag = Ext.getCmp("InciRecRetStat").getValue();
		var OutLocStatFlag = Ext.getCmp("OutLocStat").getValue();
		if(ScgStatFlag){
			var p_URL = PmRunQianUrl+'?reportName=DHCSTM_YearStatByMonRep_Scg.raq'
				+'&PhaLoc='+PhaLoc+'&Year='+YearNum;
		}else if(StkCatStatFlag){
			var p_URL = PmRunQianUrl+'?reportName=DHCSTM_YearStatByMonRep_StkCat.raq'
				+'&PhaLoc='+PhaLoc+'&Year='+YearNum;
		}else if(InciRecRetStatFlag){
			var p_URL = PmRunQianUrl+'?reportName=DHCSTM_YearStatByMonRep_Inci.raq'
				+'&PhaLoc='+PhaLoc+'&Year='+YearNum;
		}else if(OutLocStatFlag){
			var p_URL = PmRunQianUrl+'?reportName=DHCSTM_YearStatTKByMonRep_Loc.raq'
				+'&PhaLoc='+PhaLoc+'&Year='+YearNum;
		}else{
			var p_URL = PmRunQianUrl+'?reportName=DHCSTM_YearStatByMonRep_Scg.raq'
				+'&PhaLoc='+PhaLoc+'&Year='+YearNum;
		}
		reportFrame.src=p_URL;
	}
		
	var HisListTab = new Ext.form.FormPanel({
		id : 'HisListTab',
		labelWidth : 60,
		labelAlign : 'right',
		frame : true,
		autoScroll : true,
		bodyStyle : 'padding:5,0,5,0',
		tbar : [OkBT,'-',ClearBT],
		items : [{
				xtype : 'fieldset',
				title : '查询条件',
				items : [PhaLoc,YearNum]
			},{
				xtype : 'fieldset',
				title : '报表类型',
				items : [ScgStat,StkCatStat,InciRecRetStat,OutLocStat]
			}]
	});

	var reportPanel=new Ext.Panel({
		autoScroll:true,
		layout:'fit',
		html:'<iframe id="frameReport" height="100%" width="100%" src="../scripts/dhcstm/ExtUX/images/logon_bg.jpg"/>'
	});
	
	// 页面布局
	var mainPanel = new Ext.ux.Viewport({
		layout : 'border',
		items : [{
			region:'west',
			title:"年度统计",
			width:300,
			split:true,
			collapsible:true,
			minSize:260,
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