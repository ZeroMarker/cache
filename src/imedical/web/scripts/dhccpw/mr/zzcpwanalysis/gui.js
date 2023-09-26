
function InitMonitorViewport(){
	var obj = new Object();
	obj.dfDateFrom = new Ext.form.DateField({
		id : 'dfDateFrom'
		,format : 'Y-m-d'
		,width : 100
		,fieldLabel : '��Ժ����'
		,anchor : '99%'
		,altFormats : 'Y-m-d|d/m/Y'
		,value : new Date()
	});
	obj.pConditionChild1 = new Ext.Panel({
		id : 'pConditionChild1'
		,buttonAlign : 'center'
		,columnWidth : .20
		,layout : 'form'
		,items:[
			obj.dfDateFrom
		]
	});
	obj.dfDateTo = new Ext.form.DateField({
		id : 'dfDateTo'
		,width : 100
		,fieldLabel : '��'
		,altFormats : 'Y-m-d|d/m/Y'
		,format : 'Y-m-d'
		,anchor : '99%'
		,value : new Date()
	});
	obj.pConditionChild2 = new Ext.Panel({
		id : 'pConditionChild2'
		,buttonAlign : 'center'
		,columnWidth : .20
		,layout : 'form'
		,items:[
			obj.dfDateTo
		]
	});
	obj.cboAnalysisTypeStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
			url : ExtToolSetting.RunQueryPageURL
	}));
	obj.cboAnalysisTypeStore = new Ext.data.Store({
		proxy: obj.cboAnalysisTypeStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'DicCode'
		}, 
		[
			{name: 'checked', mapping : 'checked'}
			,{name: 'DicCode', mapping: 'DicCode'}
			,{name: 'DicDesc', mapping: 'DicDesc'}
		])
	});
	obj.cboAnalysisType = new Ext.form.ComboBox({
		id : 'cboAnalysisType'
		,listEmptyText : '������ͳ��'
		,width : 50
		,store : obj.cboAnalysisTypeStore
		,minChars : 1
		,displayField : 'DicDesc'
		,fieldLabel : 'ͳ�Ʒ�ʽ'
		,editable : false
		,triggerAction : 'all'
		,anchor : '99%'
		,valueField : 'DicCode'
	});
	obj.pConditionChild3 = new Ext.Panel({
		id : 'pConditionChild3'
		,buttonAlign : 'center'
		,columnWidth : .20
		,layout : 'form'
		,items:[
			obj.cboAnalysisType
		]
	});
	
	obj.cboLocStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
			url : ExtToolSetting.RunQueryPageURL
		}));
	obj.cboLocStore = new Ext.data.Store({
		proxy: obj.cboLocStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'LocId'
		}, 
		[
			{name: 'checked', mapping : 'checked'}
			,{name: 'CTLocID', mapping: 'CTLocID'}
			,{name: 'CTLocDesc', mapping: 'CTLocDesc'}
		])
	});
	obj.cboLoc = new Ext.form.ComboBox({
		id : 'cboLoc'
		,minChars : 1
		,store : obj.cboLocStore
		,valueField : 'CTLocID'
		,fieldLabel : '����'
		,displayField : 'CTLocDesc'
		,triggerAction : 'all'
		,width : 50
		,anchor : '99%'
	});
	obj.btnQuery = new Ext.Button({
		id : 'btnQuery'
		,anchor : '95%'
		,text : '��ѯ'
	});
	obj.btnExport = new Ext.Button({
		id : 'btnExport'
		,anchor : '95%'
	    ,text: '����EXCEL'
	});
	//Add By Niucaicai 2011-08-18 �Զ����������������ݰ�ť
	obj.pConditionChild6 = new Ext.Panel({
		id : 'pConditionChild6'
		,columnWidth : .30
		,layout : 'form'
		,items:[obj.cboLoc]
	});
	obj.btnBuild = new Ext.Button({
		id : 'btnBuild'
		,anchor : '95%'
	    ,text: '��ʼ������'
	});
	/*
	
	obj.pConditionChild4 = new Ext.Panel({
		id : 'pConditionChild4'
		,buttonAlign : 'center'
		,columnWidth : .10
		,layout : 'form'
		,items:[
			obj.btnQuery
		]
	});
	obj.btnExport = new Ext.Button({
		id : 'btnExport'
		,anchor : '95%'
	    ,text: '����EXCEL'
	});
	obj.pConditionChild5 = new Ext.Panel({
		id : 'pConditionChild5'
		,buttonAlign : 'center'
		,columnWidth : .10
		,layout : 'form'
		,items:[
			obj.btnExport
		]
	});
	//Add By Niucaicai 2011-08-18 �Զ����������������ݰ�ť
	obj.pConditionChild6 = new Ext.Panel({
		id : 'pConditionChild6'
		,columnWidth : .05
	});*/
	obj.btnBuild = new Ext.Button({
		id : 'btnBuild'
		,anchor : '95%'
	    ,text: '��ʼ������'
	});
	obj.pConditionChild7 = new Ext.Panel({
		id : 'pConditionChild7'
		,buttonAlign : 'center'
		,columnWidth : .10
		,layout : 'form'
		,items:[
			obj.btnBuild
		]
	});
	obj.ConditionSubPanel = new Ext.form.FormPanel({
		id : 'ConditionSubPanel'
		,buttonAlign : 'center'
		,labelAlign : 'right'
		,labelWidth : 60
		,bodyBorder : 'padding:0 0 0 0'
		,layout : 'column'
		,frame : true
		,items:[
			obj.pConditionChild1
			,obj.pConditionChild2
			,obj.pConditionChild3
			,obj.pConditionChild6
			//,obj.pConditionChild4
			//,obj.pConditionChild5
			//,obj.pConditionChild7
		]
		,buttons:[
			obj.btnQuery
			,obj.btnExport
			,obj.btnBuild
		]
	});
	obj.ConditionPanel = new Ext.Panel({
		id : 'ConditionPanel'
		,height : 100
		,buttonAlign : 'center'
		,region : 'north'
		,layout : 'fit'
		,title : '��ѯǰ��ѡ��ʼ���ڡ��������ڣ��㡮��ʼ�����ݡ���ť����ʼ���������֮���ٲ�ѯ'
		,items:[
			obj.ConditionSubPanel
		]
	});
	obj.ResultGridPanelStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
			url : ExtToolSetting.RunQueryPageURL
			,timeout : 180000                    //add by wuqk 2012-09-23 ��ʱʱ�����ӵ�3����
	}));
	obj.ResultGridPanelStore = new Ext.data.Store({
		proxy: obj.ResultGridPanelStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'LocDesc'
		}, 
		[
			{name: 'checked', mapping : 'checked'}
			,{name: 'CPWDicTypeID', mapping: 'CPWDicTypeID'}
			,{name: 'CPWDicTypeDesc', mapping: 'CPWDicTypeDesc'}
			,{name: 'CPWDID', mapping: 'CPWDID'}
			,{name: 'CPWDicDesc', mapping: 'CPWDicDesc'}
			,{name: 'InHospCount', mapping: 'InHospCount'}
			,{name: 'InCPWCount', mapping: 'InCPWCount'}
			,{name: 'InCPWRatio', mapping: 'InCPWRatio'}
			,{name: 'OutCPWCount', mapping: 'OutCPWCount'}
			,{name: 'OutCPWRatio', mapping: 'OutCPWRatio'}
			,{name: 'CloseCPWCount', mapping: 'CloseCPWCount'}
			,{name: 'CloseCPWRatio', mapping: 'CloseCPWRatio'}
			,{name: 'VarCPWCount', mapping: 'VarCPWCount'}
			,{name: 'VarCPWRatio', mapping: 'VarCPWRatio'}
			,{name: 'InHospDays', mapping: 'InHospDays'}
			,{name: 'OperInHospDays', mapping: 'OperInHospDays'}
			,{name: 'CureRatio', mapping: 'CureRatio'}
			,{name: 'ImproveRatio', mapping: 'ImproveRatio'}
			,{name: 'DeathRatio', mapping: 'DeathRatio'}
			,{name: 'CureCount', mapping: 'CureCount'}
			,{name: 'ImproveCount', mapping: 'ImproveCount'}
			,{name: 'DeathCount', mapping: 'DeathCount'}
			,{name: 'InfPatRatio', mapping: 'InfPatRatio'}
			,{name: 'OperInfRatio', mapping: 'OperInfRatio'}
			,{name: 'InHospCost', mapping: 'InHospCost'}
			,{name: 'DayCost', mapping: 'DayCost'}
			,{name: 'DrugCost', mapping: 'DrugCost'}
			,{name: 'DrugCostRatio', mapping: 'DrugCostRatio'}
			,{name: 'LabCost', mapping: 'LabCost'}
			,{name: 'LabCostRatio', mapping: 'LabCostRatio'}
			,{name: 'CheckCost', mapping: 'CheckCost'}
			,{name: 'CheckCostRatio', mapping: 'CheckCostRatio'}
			,{name: 'MaterialCost', mapping: 'MaterialCost'}
			,{name: 'MaterialCostRatio', mapping: 'MaterialCostRatio'}
			
			//****************************************************
			//��ҽ��ص��ٴ�·��ͳ��ָ��
			,{name: 'ProprMedCost', mapping: 'ProprMedCost'}
			,{name: 'HerbalMedCost', mapping: 'HerbalMedCost'}
			,{name: 'WesternMedCost', mapping: 'WesternMedCost'}
			,{name: 'TherapyCost', mapping: 'TherapyCost'}
			,{name: 'ChTherapyCost', mapping: 'ChTherapyCost'}
			,{name: 'CharaTherapyCost', mapping: 'CharaTherapyCost'}
			,{name: 'PiecesMedCount', mapping: 'PiecesMedCount'}
			,{name: 'PiecesMedRadio', mapping: 'PiecesMedRadio'}
			,{name: 'ProprMedCount', mapping: 'ProprMedCount'}
			,{name: 'ProprMedRadio', mapping: 'ProprMedRadio'}
			,{name: 'CharaTherapyCount', mapping: 'CharaTherapyCount'}
			,{name: 'CharaTherapyRadio', mapping: 'CharaTherapyRadio'}
			,{name: 'ChTherapyCount', mapping: 'ChTherapyCount'}
			,{name: 'ChTherapyRadio', mapping: 'ChTherapyRadio'}
			//****************************************************
			
			,{name: 'Pharmacy3Ratio', mapping: 'Pharmacy3Ratio'}
			,{name: 'PharmacyDays', mapping: 'PharmacyDays'}
			,{name: 'PharmacyCost', mapping: 'PharmacyCost'}
			,{name: 'PharmacyCostRatio', mapping: 'PharmacyCostRatio'}
			,{name: 'TimesOperRatio', mapping: 'TimesOperRatio'}
			,{name: 'PreDrugRatio', mapping: 'PreDrugRatio'}
			,{name: 'ComplicationRatio', mapping: 'ComplicationRatio'}
			,{name: 'NextDays14Ratio', mapping: 'NextDays14Ratio'}
			,{name: 'NextDays31Ratio', mapping: 'NextDays31Ratio'}
		])
		,sortInfo : {field : 'CPWDicTypeID', direction : 'ASC'}
	});
	obj.ResultGridPanelCheckCol = new Ext.grid.CheckColumn({header:'', dataIndex: 'checked', width: 50 });
	obj.ResultGridPanel = new Ext.grid.GridPanel({
		id : 'ResultGridPanel'
		,loadMask : true
		,store : obj.ResultGridPanelStore
		,region : 'center'
		,columnLines : true
		,frame : true
		,buttonAlign : 'center'
		,columns: [
			new Ext.grid.RowNumberer()
			,{header: '��������', width: 100, dataIndex: 'CPWDicTypeDesc', sortable: false, menuDisabled : true, align: 'center'}
			,{header: '��������', width: 200, dataIndex: 'CPWDicDesc', sortable: false, align: 'center'
				, renderer: function(v, m, rd, r, c, s){
					var CPWDID = rd.get("CPWDID");
					var DateFrom = obj.QryArgDateFrom;
					var DateTo = obj.QryArgDateTo;
					var AnalysisType = obj.QryArgAnalysisType;
					var Loc = obj.QryArgLoc;
					var dtlCPWDicDesc = rd.get("CPWDicDesc");	//	Modified by zhaoyu 2012-11-23 �ٴ�·����ϸ���⴫��
					var dtlAnalysis = obj.cboAnalysisType.getRawValue();	//	Modified by zhaoyu 2012-11-23 �ٴ�·����ϸ���⴫��
					var strRet = "";
					//strRet += "<A id='lnkAnalysisDtl' HREF='#' onClick='AnalysisDtlHeader(\"" + CPWDID + "\",\"" + DateFrom + "\",\"" + DateTo + "\",\"" + AnalysisType + "\",\"" + Loc + "\")' ><div align='left'>"+v+"</div></A>";
					//Modified by zhaoyu 2012-11-23 �ٴ�·����ϸ���⴫��
					strRet += "<A id='lnkAnalysisDtl' HREF='#' onClick='AnalysisDtlHeader(\"" + CPWDID + "\",\"" + DateFrom + "\",\"" + DateTo + "\",\"" + AnalysisType + "\",\"" + Loc + "\",\"" + dtlAnalysis + "\",\"" + dtlCPWDicDesc + "\")' ><div align='left'>"+v+"</div></A>";
					return strRet;
				}
			}
			,{header: '����סԺ<br>������', width: 70, dataIndex: 'InHospCount', sortable: false, menuDisabled : true, align: 'center'}
			,{header: '�뾶����<br>������', width: 70, dataIndex: 'InCPWCount', sortable: false, menuDisabled : true, align: 'center'}
			,{header: '�뾶��<br>(%)', width: 70, dataIndex: 'InCPWRatio', sortable: false, menuDisabled : true, align: 'center'}
			,{header: '��������<br>������', width: 70, dataIndex: 'OutCPWCount', sortable: false, menuDisabled : true, align: 'center'}
			,{header: '������<br>(%)', width: 70, dataIndex: 'OutCPWRatio', sortable: false, menuDisabled : true, align: 'center'}
			,{header: '���·��<br>������', width: 70, dataIndex: 'CloseCPWCount', sortable: false, menuDisabled : true, align: 'center'}
			,{header: '�����<br>(%)', width: 70, dataIndex: 'CloseCPWRatio', sortable: false, menuDisabled : true, align: 'center'}
			,{header: '���ֱ���<br>������', width: 70, dataIndex: 'VarCPWCount', sortable: false, menuDisabled : true, align: 'center'}
			,{header: '������<br>(%)', width: 70, dataIndex: 'VarCPWRatio', sortable: false, menuDisabled : true, align: 'center'}
			,{header: 'ƽ��סԺ��<br>(��)', width: 70, dataIndex: 'InHospDays', sortable: false, menuDisabled : true, align: 'center'}
			,{header: '��ǰƽ��<br>סԺ��(��)', width: 70, dataIndex: 'OperInHospDays', sortable: false, menuDisabled : true, align: 'center'}
			,{header: '��������', width: 70, dataIndex: 'CureCount', sortable: false, menuDisabled : true, align: 'center'}
			,{header: '������<br>(%)', width: 70, dataIndex: 'CureRatio', sortable: false, menuDisabled : true, align: 'center'}
			,{header: '��ת����', width: 70, dataIndex: 'ImproveCount', sortable: false, menuDisabled : true, align: 'center'}
			,{header: '��ת��<br>(%)', width: 70, dataIndex: 'ImproveRatio', sortable: false, menuDisabled : true, align: 'center'}
			,{header: '��������', width: 70, dataIndex: 'DeathCount', sortable: false, menuDisabled : true, align: 'center'}
			,{header: '������<br>(%)', width: 70, dataIndex: 'DeathRatio', sortable: false, menuDisabled : true, align: 'center'}
			,{header: 'ҽԺ��Ⱦ<br>������(%)', width: 70, dataIndex: 'InfPatRatio', sortable: false, menuDisabled : true, align: 'center'}
			,{header: '������λ��Ⱦ<br>������(%)', width: 100, dataIndex: 'OperInfRatio', sortable: false, menuDisabled : true, align: 'center'}
			,{header: '�Ǽƻ��ط�<br>�����һ��߱���(%)', width: 110, dataIndex: 'TimesOperRatio', sortable: false, menuDisabled : true, align: 'center'}
			,{header: '�ξ�����', width: 70, dataIndex: 'InHospCost', sortable: false, menuDisabled : true, align: 'center'}
			,{header: '�վ�����', width: 70, dataIndex: 'DayCost', sortable: false, menuDisabled : true, align: 'center'}
			,{header: '�ξ�ҩ��', width: 70, dataIndex: 'DrugCost', sortable: false, menuDisabled : true, align: 'center'}
			,{header: 'ҩ��<br>����(%)', width: 70, dataIndex: 'DrugCostRatio', sortable: false, menuDisabled : true, align: 'center'}
			,{header: '�ξ������', width: 80, dataIndex: 'LabCost', sortable: false, menuDisabled : true, align: 'center'}
			,{header: '�����<br>����(%)', width: 70, dataIndex: 'LabCostRatio', sortable: false, menuDisabled : true, align: 'center'}
			,{header: '�ξ�����', width: 80, dataIndex: 'CheckCost', sortable: false, menuDisabled : true, align: 'center'}
			,{header: '����<br>����(%)', width: 70, dataIndex: 'CheckCostRatio', sortable: false, menuDisabled : true, align: 'center'}
			,{header: '�ξ��Ĳķ�', width: 80, dataIndex: 'MaterialCost', sortable: false, menuDisabled : true, align: 'center'}
			,{header: '�Ĳķ�<br>����(%)', width: 70, dataIndex: 'MaterialCostRatio', sortable: false, menuDisabled : true, align: 'center'}
			
			//��ҽ��ص��ٴ�·��ͳ��ָ��
			//,{header: '�г�ҩ��', width: 70, dataIndex: 'ProprMedCost', sortable: false, menuDisabled : true, align: 'center'}
			//,{header: '�в�ҩ��', width: 70, dataIndex: 'HerbalMedCost', sortable: false, menuDisabled : true, align: 'center'}
			//,{header: '��ҩ��', width: 70, dataIndex: 'WesternMedCost', sortable: false, menuDisabled : true, align: 'center'}
			//,{header: '���Ʒ�', width: 70, dataIndex: 'TherapyCost', sortable: false, menuDisabled : true, align: 'center'}
			//,{header: '��ҽ���Ʒ�', width: 70, dataIndex: 'ChTherapyCost', sortable: false, menuDisabled : true, align: 'center'}
			//,{header: '��ҽ��ɫ<br>�Ʒ���', width: 70, dataIndex: 'CharaTherapyCost', sortable: false, menuDisabled : true, align: 'center'}
			//,{header: '��ҩ��Ƭ<br>ʹ������', width: 70, dataIndex: 'PiecesMedCount', sortable: false, menuDisabled : true, align: 'center'}
			//,{header: '��ҩ��Ƭ<br>ʹ����(%)', width: 70, dataIndex: 'PiecesMedRadio', sortable: false, menuDisabled : true, align: 'center'}
			//,{header: '�г�ҩ<br>ʹ������', width: 70, dataIndex: 'ProprMedCount', sortable: false, menuDisabled : true, align: 'center'}
			//,{header: '�г�ҩ<br>ʹ����(%)', width: 70, dataIndex: 'ProprMedRadio', sortable: false, menuDisabled : true, align: 'center'}
			//,{header: '��ɫ�Ʒ�<br>ʹ������', width: 70, dataIndex: 'CharaTherapyCount', sortable: false, menuDisabled : true, align: 'center'}
			//,{header: '��ɫ�Ʒ�<br>ʹ����(%)', width: 70, dataIndex: 'CharaTherapyRadio', sortable: false, menuDisabled : true, align: 'center'}
			//,{header: '��ҽҩ����<br>ʹ������', width: 80, dataIndex: 'ChTherapyCount', sortable: false, menuDisabled : true, align: 'center'}
			//,{header: '��ҽҩ����<br>ʹ����(%)', width: 80, dataIndex: 'ChTherapyRadio', sortable: false, menuDisabled : true, align: 'center'}
			
			,{header: 'Ԥ���Կ���<br>ҩ��ʹ����(%)', width: 100, dataIndex: 'PreDrugRatio', sortable: false, menuDisabled : true, align: 'center'}
			,{header: 'ʹ�ÿ���<br>ҩ�ﻼ�߱���(%)', width: 100, dataIndex: 'Pharmacy3Ratio', sortable: false, menuDisabled : true, align: 'center'}
			,{header: '����ҩ��ʹ��<br>ƽ������(��)', width: 100, dataIndex: 'PharmacyDays', sortable: false, menuDisabled : true, align: 'center'}
			,{header: '����ҩ��<br>ƽ������', width: 70, dataIndex: 'PharmacyCost', sortable: false, menuDisabled : true, align: 'center'}
			,{header: '����ҩ��<br>���ñ���(%)', width: 80, dataIndex: 'PharmacyCostRatio', sortable: false, menuDisabled : true, align: 'center'}
			,{header: '14����ס<br>Ժ��(%)', width: 70, dataIndex: 'NextDays14Ratio', sortable: false, menuDisabled : true, align: 'center'}
			,{header: '31����ס<br>Ժ��(%)', width: 70, dataIndex: 'NextDays31Ratio', sortable: false, menuDisabled : true, align: 'center'}
			,{header: '��������֢<br>������(%)', width: 80, dataIndex: 'ComplicationRatio', sortable: false, menuDisabled : true, align: 'center'}
			
			/* update by zf 2012-08-01
			//������ҽԺ�������
			,{header: '��Ч����', width: 80, sortable: false, align: 'center'
				, renderer: function(v, m, rd, r, c, s){
					var CPWDID = rd.get("CPWDID");
					var DateFrom = obj.QryArgDateFrom;
					var DateTo = obj.QryArgDateTo;
					var AnalysisType = obj.QryArgAnalysisType;
					var Loc = obj.QryArgLoc;
					var strRet = "";
					strRet += "<A id='lnkResultStat' HREF='#' onClick='ResultStatHeader(\"" + CPWDID + "\",\"" + DateFrom + "\",\"" + DateTo + "\",\"" + AnalysisType + "\",\"" + Loc + "\")' ><div align='left'>��������</div></A>";
					return strRet;
				}
			}*/
		]
		,viewConfig : {
			//forceFit : true
			enableRpwBody : true
			,showPreview : true
			,layout : function() {
				if (!this.mainBody) {
					return;
				}
				var g = this.grid;
				var c = g.getGridEl();
				var csize = c.getSize(true);
				var vw = csize.width;
				if (!g.hideHeaders && (vw < 20 || csize.height < 20)) {
					return;
				}
				if (g.autoHeight) {
					if (this.innerHd) {
						this.innerHd.style.width = (vw) + 'px';
					 }
				} else {
					this.el.setSize(csize.width, csize.height);
					var hdHeight = this.mainHd.getHeight();
					var vh = csize.height - (hdHeight);
					this.scroller.setSize(vw, vh);
					if (this.innerHd) {
						this.innerHd.style.width = (vw) + 'px';
					 }
				}
				if (this.forceFit) {
					if (this.lastViewWidth != vw) {
						this.fitColumns(false, false);
						this.lastViewWidth = vw;
					 }
				} else {
					this.autoExpand();
					this.syncHeaderScroll();
				}
				this.onLayout(vw, vh);
			}
		}
		/* update by zf 20111214
		,listeners : {
      		'rowdblclick': function(){
						var rc = obj.ResultGridPanel.getSelectionModel().getSelected();
						var CPWDID=rc.get("CPWDID");
						var titles=rc.get("CPWDicDesc");
      			rowDblClick(event,CPWDID,titles);
      		}
      	}
      	*/
	});
	obj.MonitorViewport = new Ext.Viewport({
		id : 'MonitorViewport'
		,region : document.body
		,layout : 'border'
		,items:[
			obj.ConditionPanel
			,obj.ResultGridPanel
		]
	});
	obj.cboAnalysisTypeStoreProxy.on('beforeload', function(objProxy, param){
			param.ClassName = 'web.DHCCPW.MRC.BaseConfig';
			param.QueryName = 'QryBaseDic';
			param.Arg1='CPWAnalysisType';
			param.ArgCnt = 1;
	});
	obj.cboAnalysisTypeStore.load({});
	
	obj.cboLocStoreProxy.on('beforeload', function(objProxy, param){
			var LocDesc=Ext.getCmp('cboLoc').getRawValue();
			param.ClassName = 'web.DHCCPW.MR.SysBaseSrv';
			param.QueryName = 'QryCTLoc';
			param.Arg1 = LocDesc;
			param.Arg2 = 'E';
			param.Arg3 = '';
			param.ArgCnt = 3;
	});
	obj.cboLocStore.load();
	
	obj.ResultGridPanelStoreProxy.on('beforeload', function(objProxy, param){
			param.ClassName = 'web.DHCCPW.MR.ClinPathWayAnalysisSrv';
			param.QueryName = 'QryCPWDischStatByCPWD';
			param.Arg1 = obj.dfDateFrom.getRawValue();
			param.Arg2 = obj.dfDateTo.getRawValue();
			//param.Arg3 = obj.cboAnalysisType.getValue();
			//param.Arg4 = obj.cboLoc.getValue();
			param.Arg3 = parseInt(obj.cboAnalysisType.getValue());	//	Modified by zhaoyu 2012-11-23 �ٴ�·���±���ͳ�Ʒ�ʽ����ɡ����뾶���鲻������
			param.Arg4 = obj.cboLoc.getValue();	//	Modified by zhaoyu 2012-11-15 ��ѯͳ��-�ٴ�·���±���-ѡ�񡾿��ҡ���ͳ�Ʋ��������� ȱ�ݱ��210
			
			obj.QryArgDateFrom = param.Arg1;
			obj.QryArgDateTo = param.Arg2;
			obj.QryArgAnalysisType = param.Arg3;
			obj.QryArgLoc = param.Arg4;
			
			param.ArgCnt = 4;
	});
	InitMonitorViewportEvent(obj);
	//�¼��������
	obj.LoadEvent(arguments);
	return obj;
	
	
	function rowDblClick(evt,CPWDID,titles)
	{
		var objWin = new Object();

		objWin.chkInPathWay = new Ext.form.Checkbox({
			id : 'chkInPathWay'
			,boxLabel : '�뾶����'
			,listeners : {
      		'check': function(){
      			objWin.PaGridPanelStore.load({});
      		}
      }
			
		});
		objWin.btnExport = new Ext.Button({
				id : 'btnExport'
				,text : '����'
				,listeners : {
      		'click': function(){
      			var fleName=titles;
      			if (objWin.chkInPathWay.getValue()){
      				fleName+="��";
      			}
      			else{
      				fleName+="δ";
      			}
      			fleName+="�뾶�����б�";
      			fleName=fleName+"("+obj.dfDateFrom.getRawValue()+"��"+obj.dfDateTo.getRawValue()+")";
      			ExprotGrid(objWin.PaGridPanel,fleName);
      		}
      	}
			});
		
		objWin.PaGridPanelStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
			url : ExtToolSetting.RunQueryPageURL
		}));

		objWin.PaGridPanelStore = new Ext.data.Store({
		proxy: objWin.PaGridPanelStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'Rowid'
		}, 
		[
			{name: 'checked', mapping : 'checked'}
			,{name: 'Rowid', mapping: 'Rowid'}
			,{name: 'PapmiNo', mapping: 'PapmiNo'}
			,{name: 'PatName', mapping: 'PatName'}
			,{name: 'Sex', mapping: 'Sex'}
			,{name: 'Age', mapping: 'Age'}
			,{name: 'AdmitDate', mapping: 'AdmitDate'}
			,{name: 'AdmitTime', mapping: 'AdmitTime'}
			,{name: 'DisDate', mapping: 'DisDate'}
			,{name: 'DisTime', mapping: 'DisTime'}
			,{name: 'AdmLoc', mapping: 'AdmLoc'}
			,{name: 'AdmDoc', mapping: 'AdmDoc'}
			,{name: 'AdmDays', mapping: 'AdmDays'}
			,{name: 'CountCost', mapping: 'CountCost'}
			,{name: 'VarReason', mapping: 'VarReason'}
			,{name: 'StatusDesc', mapping: 'StatusDesc'}
			,{name: 'DrugRatio', mapping: 'DrugRatio'}
			,{name: 'OutReasonDesc', mapping: 'OutReasonDesc'}
		])
		});
		//obj.PaGridPanelCheckCol = new Ext.grid.CheckColumn({header:'', dataIndex: 'checked', width: 50 });
		objWin.PaGridPanel = new Ext.grid.GridPanel({
			id : 'PaGridPanel'
			,loadMask : true
			,store : objWin.PaGridPanelStore
			,region : 'center'
			//,frame : true
			,buttonAlign : 'center'
			,columns: [
				//new Ext.grid.RowNumberer()
				{header: '�ǼǺ�', width: 70, dataIndex: 'PapmiNo', sortable: true}
				,{header: '����', width: 60, dataIndex: 'PatName', sortable: true}
				,{header: '�Ա�', width: 40, dataIndex: 'Sex', sortable: true}
				,{header: '����', width: 40, dataIndex: 'Age', sortable: true}
				,{header: '����', width: 120, dataIndex: 'AdmLoc', sortable: true}
				,{header: 'ҽ��', width: 60, dataIndex: 'AdmDoc', sortable: true}
				,{header: '״̬', width: 60, dataIndex: 'StatusDesc', sortable: true}
				,{header: '��Ժ����', width: 80, dataIndex: 'AdmitDate', sortable: true}
				,{header: '��Ժʱ��', width: 60, dataIndex: 'AdmitTime', sortable: true}
				,{header: '��Ժ����', width: 80, dataIndex: 'DisDate', sortable: true}
				,{header: '��Ժʱ��', width: 60, dataIndex: 'DisTime', sortable: true}
				,{header: 'סԺ����', width: 60, dataIndex: 'AdmDays', sortable: true}
				,{header: 'ʵ�ʷ���', width: 60, dataIndex: 'CountCost', sortable: true}
				,{header: 'ҩ�ѱ�', width: 60, dataIndex: 'DrugRatio', sortable: true}
				,{header: '����ԭ��', width: 150, dataIndex: 'VarReason', sortable: false}
				,{header: '����ԭ��', width: 150, dataIndex: 'OutReasonDesc', sortable: false}
			]
			,tbar:[objWin.chkInPathWay,'-',objWin.btnExport]
		});
		objWin.PaGridPanelStoreProxy.on('beforeload', function(objProxy, param){
			param.ClassName = 'web.DHCCPW.MR.ClinPathWayAnalysisSrv';
			param.QueryName = 'QueryDetails';
			param.Arg1 = obj.dfDateFrom.getRawValue();
			param.Arg2 = obj.dfDateTo.getRawValue();
			param.Arg3 = CPWDID;
			param.Arg4 = obj.cboLoc.getValue();
			param.Arg5 = objWin.chkInPathWay.getValue();
			param.ArgCnt = 5;
		});
		objWin.PaGridPanelStore.load({});

		PaWindow = new Ext.Window({
			id : 'PaWindow',
			width : (screen.width-280), //870,
			height : 400,
			x : 20,
			y : evt.clientY+10,
			resizable : false,
			closable : true,
			autoScroll:true,
			animCollapse : true,
			//html:template,
			renderTo : document.body,
			layout : 'border',
			modal : true,
			title : titles,
			items : [
				objWin.PaGridPanel
			]
		});

		PaWindow.show();
	}
}
