///����:����ά��ͳ�Ʊ���
///����:����ά��ͳ�Ʊ���
///��д��:wangjiabin
///��д����:2014-05-05
Ext.onReady(function() {
	
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	var gGroupId=session['LOGON.GROUPID'];
	var gLocId=session['LOGON.CTLOCID'];
	var gUserId=session['LOGON.USERID'];
	
	var PhaLoc = new Ext.ux.LocComboBox({
		fieldLabel : '����',
		id : 'PhaLoc',
		name : 'PhaLoc',
		anchor : '90%',
		emptyText : '����...',
		groupId : gGroupId
	});
	
	var YearNum = new Ext.form.TextField({
		fieldLabel : '���',
		id : 'YearNum',
		anchor : '90%',
		allowBlank : false,
		value : new Date().getFullYear(),
		regex : /^2\d{3}$/,
		regexText : '��������ȷ����ݸ�ʽ!'
	});
	
	//�������
	var ScgStat = new Ext.form.Radio({
		boxLabel : '�������(���ת��)',
		id : 'ScgStat',
		name : 'ReportType',
		anchor : '80%',
		checked : true
	});
	//�������
	var StkCatStat = new Ext.form.Radio({
		boxLabel : '������(���ת��)',
		id : 'StkCatStat',
		name : 'ReportType',
		anchor : '80%',
		checked : false
	});
	//���������˻�
	var InciRecRetStat = new Ext.form.Radio({
		boxLabel : '����˻���ϸ',
		id : 'InciRecRetStat',
		name : 'ReportType',
		anchor : '80%',
		checked : false
	});
	//�������(������)
	var OutLocStat = new Ext.form.Radio({
		boxLabel : '�������(������)',
		id : 'OutLocStat',
		name : 'ReportType',
		anchor : '80%',
		checked : false
	});
	
	var ClearBT = new Ext.Toolbar.Button({
		id : "ClearBT",
		text : '���',
		tooltip : '������',
		width : 70,
		height : 30,
		iconCls : 'page_clearscreen',
		handler : function() {
			SetLogInDept(PhaLoc.getStore(),'PhaLoc');
			document.getElementById("frameReport").src="../scripts/dhcstm/ExtUX/images/logon_bg.jpg";
		}
	});
	
	// ȷ����ť
	var OkBT = new Ext.Toolbar.Button({
		id : "OkBT",
		text : 'ͳ��',
		tooltip : '���ͳ��',
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
			Msg.info("warning","���Ҳ���Ϊ��!");
			return;
		}
		var YearNum = Ext.getCmp("YearNum").getValue();
		if(YearNum == ""){
			Msg.info("warning","��ѡ�����!");
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
				title : '��ѯ����',
				items : [PhaLoc,YearNum]
			},{
				xtype : 'fieldset',
				title : '��������',
				items : [ScgStat,StkCatStat,InciRecRetStat,OutLocStat]
			}]
	});

	var reportPanel=new Ext.Panel({
		autoScroll:true,
		layout:'fit',
		html:'<iframe id="frameReport" height="100%" width="100%" src="../scripts/dhcstm/ExtUX/images/logon_bg.jpg"/>'
	});
	
	// ҳ�沼��
	var mainPanel = new Ext.ux.Viewport({
		layout : 'border',
		items : [{
			region:'west',
			title:"���ͳ��",
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