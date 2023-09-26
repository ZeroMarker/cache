
function InitMonitorViewport(){
	var obj = new Object();
	obj.dfDateFrom = new Ext.form.DateField({
		id : 'dfDateFrom'
		,format : 'Y-m-d'
		,width : 100
		,fieldLabel : '出院日期'
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
		,fieldLabel : '至'
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
		,listEmptyText : '按病种统计'
		,width : 50
		,store : obj.cboAnalysisTypeStore
		,minChars : 1
		,displayField : 'DicDesc'
		,fieldLabel : '统计方式'
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
		,fieldLabel : '科室'
		,displayField : 'CTLocDesc'
		,triggerAction : 'all'
		,width : 50
		,anchor : '99%'
	});
	obj.btnQuery = new Ext.Button({
		id : 'btnQuery'
		,anchor : '95%'
		,text : '查询'
	});
	obj.btnExport = new Ext.Button({
		id : 'btnExport'
		,anchor : '95%'
	    ,text: '导出EXCEL'
	});
	//Add By Niucaicai 2011-08-18 自动任务批量处理数据按钮
	obj.pConditionChild6 = new Ext.Panel({
		id : 'pConditionChild6'
		,columnWidth : .30
		,layout : 'form'
		,items:[obj.cboLoc]
	});
	obj.btnBuild = new Ext.Button({
		id : 'btnBuild'
		,anchor : '95%'
	    ,text: '初始化数据'
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
	    ,text: '导出EXCEL'
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
	//Add By Niucaicai 2011-08-18 自动任务批量处理数据按钮
	obj.pConditionChild6 = new Ext.Panel({
		id : 'pConditionChild6'
		,columnWidth : .05
	});*/
	obj.btnBuild = new Ext.Button({
		id : 'btnBuild'
		,anchor : '95%'
	    ,text: '初始化数据'
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
		,title : '查询前请选择开始日期、结束日期，点‘初始化数据’按钮，初始化数据完毕之后再查询'
		,items:[
			obj.ConditionSubPanel
		]
	});
	obj.ResultGridPanelStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
			url : ExtToolSetting.RunQueryPageURL
			,timeout : 180000                    //add by wuqk 2012-09-23 超时时间增加到3分钟
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
			//中医相关的临床路径统计指标
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
			,{header: '病种类型', width: 100, dataIndex: 'CPWDicTypeDesc', sortable: false, menuDisabled : true, align: 'center'}
			,{header: '病种名称', width: 200, dataIndex: 'CPWDicDesc', sortable: false, align: 'center'
				, renderer: function(v, m, rd, r, c, s){
					var CPWDID = rd.get("CPWDID");
					var DateFrom = obj.QryArgDateFrom;
					var DateTo = obj.QryArgDateTo;
					var AnalysisType = obj.QryArgAnalysisType;
					var Loc = obj.QryArgLoc;
					var dtlCPWDicDesc = rd.get("CPWDicDesc");	//	Modified by zhaoyu 2012-11-23 临床路径明细标题传参
					var dtlAnalysis = obj.cboAnalysisType.getRawValue();	//	Modified by zhaoyu 2012-11-23 临床路径明细标题传参
					var strRet = "";
					//strRet += "<A id='lnkAnalysisDtl' HREF='#' onClick='AnalysisDtlHeader(\"" + CPWDID + "\",\"" + DateFrom + "\",\"" + DateTo + "\",\"" + AnalysisType + "\",\"" + Loc + "\")' ><div align='left'>"+v+"</div></A>";
					//Modified by zhaoyu 2012-11-23 临床路径明细标题传参
					strRet += "<A id='lnkAnalysisDtl' HREF='#' onClick='AnalysisDtlHeader(\"" + CPWDID + "\",\"" + DateFrom + "\",\"" + DateTo + "\",\"" + AnalysisType + "\",\"" + Loc + "\",\"" + dtlAnalysis + "\",\"" + dtlCPWDicDesc + "\")' ><div align='left'>"+v+"</div></A>";
					return strRet;
				}
			}
			,{header: '病种住院<br>总人数', width: 70, dataIndex: 'InHospCount', sortable: false, menuDisabled : true, align: 'center'}
			,{header: '入径患者<br>总人数', width: 70, dataIndex: 'InCPWCount', sortable: false, menuDisabled : true, align: 'center'}
			,{header: '入径率<br>(%)', width: 70, dataIndex: 'InCPWRatio', sortable: false, menuDisabled : true, align: 'center'}
			,{header: '出径患者<br>总人数', width: 70, dataIndex: 'OutCPWCount', sortable: false, menuDisabled : true, align: 'center'}
			,{header: '出径率<br>(%)', width: 70, dataIndex: 'OutCPWRatio', sortable: false, menuDisabled : true, align: 'center'}
			,{header: '完成路径<br>总人数', width: 70, dataIndex: 'CloseCPWCount', sortable: false, menuDisabled : true, align: 'center'}
			,{header: '完成率<br>(%)', width: 70, dataIndex: 'CloseCPWRatio', sortable: false, menuDisabled : true, align: 'center'}
			,{header: '出现变异<br>总人数', width: 70, dataIndex: 'VarCPWCount', sortable: false, menuDisabled : true, align: 'center'}
			,{header: '变异率<br>(%)', width: 70, dataIndex: 'VarCPWRatio', sortable: false, menuDisabled : true, align: 'center'}
			,{header: '平均住院日<br>(天)', width: 70, dataIndex: 'InHospDays', sortable: false, menuDisabled : true, align: 'center'}
			,{header: '术前平均<br>住院日(天)', width: 70, dataIndex: 'OperInHospDays', sortable: false, menuDisabled : true, align: 'center'}
			,{header: '治愈人数', width: 70, dataIndex: 'CureCount', sortable: false, menuDisabled : true, align: 'center'}
			,{header: '治愈率<br>(%)', width: 70, dataIndex: 'CureRatio', sortable: false, menuDisabled : true, align: 'center'}
			,{header: '好转人数', width: 70, dataIndex: 'ImproveCount', sortable: false, menuDisabled : true, align: 'center'}
			,{header: '好转率<br>(%)', width: 70, dataIndex: 'ImproveRatio', sortable: false, menuDisabled : true, align: 'center'}
			,{header: '死亡人数', width: 70, dataIndex: 'DeathCount', sortable: false, menuDisabled : true, align: 'center'}
			,{header: '死亡率<br>(%)', width: 70, dataIndex: 'DeathRatio', sortable: false, menuDisabled : true, align: 'center'}
			,{header: '医院感染<br>发生率(%)', width: 70, dataIndex: 'InfPatRatio', sortable: false, menuDisabled : true, align: 'center'}
			,{header: '手术部位感染<br>发生率(%)', width: 100, dataIndex: 'OperInfRatio', sortable: false, menuDisabled : true, align: 'center'}
			,{header: '非计划重返<br>手术室患者比例(%)', width: 110, dataIndex: 'TimesOperRatio', sortable: false, menuDisabled : true, align: 'center'}
			,{header: '次均费用', width: 70, dataIndex: 'InHospCost', sortable: false, menuDisabled : true, align: 'center'}
			,{header: '日均费用', width: 70, dataIndex: 'DayCost', sortable: false, menuDisabled : true, align: 'center'}
			,{header: '次均药费', width: 70, dataIndex: 'DrugCost', sortable: false, menuDisabled : true, align: 'center'}
			,{header: '药费<br>比例(%)', width: 70, dataIndex: 'DrugCostRatio', sortable: false, menuDisabled : true, align: 'center'}
			,{header: '次均检验费', width: 80, dataIndex: 'LabCost', sortable: false, menuDisabled : true, align: 'center'}
			,{header: '检验费<br>比例(%)', width: 70, dataIndex: 'LabCostRatio', sortable: false, menuDisabled : true, align: 'center'}
			,{header: '次均检查费', width: 80, dataIndex: 'CheckCost', sortable: false, menuDisabled : true, align: 'center'}
			,{header: '检查费<br>比例(%)', width: 70, dataIndex: 'CheckCostRatio', sortable: false, menuDisabled : true, align: 'center'}
			,{header: '次均耗材费', width: 80, dataIndex: 'MaterialCost', sortable: false, menuDisabled : true, align: 'center'}
			,{header: '耗材费<br>比例(%)', width: 70, dataIndex: 'MaterialCostRatio', sortable: false, menuDisabled : true, align: 'center'}
			
			//中医相关的临床路径统计指标
			//,{header: '中成药费', width: 70, dataIndex: 'ProprMedCost', sortable: false, menuDisabled : true, align: 'center'}
			//,{header: '中草药费', width: 70, dataIndex: 'HerbalMedCost', sortable: false, menuDisabled : true, align: 'center'}
			//,{header: '西药费', width: 70, dataIndex: 'WesternMedCost', sortable: false, menuDisabled : true, align: 'center'}
			//,{header: '治疗费', width: 70, dataIndex: 'TherapyCost', sortable: false, menuDisabled : true, align: 'center'}
			//,{header: '中医治疗费', width: 70, dataIndex: 'ChTherapyCost', sortable: false, menuDisabled : true, align: 'center'}
			//,{header: '中医特色<br>疗法费', width: 70, dataIndex: 'CharaTherapyCost', sortable: false, menuDisabled : true, align: 'center'}
			//,{header: '中药饮片<br>使用人数', width: 70, dataIndex: 'PiecesMedCount', sortable: false, menuDisabled : true, align: 'center'}
			//,{header: '中药饮片<br>使用率(%)', width: 70, dataIndex: 'PiecesMedRadio', sortable: false, menuDisabled : true, align: 'center'}
			//,{header: '中成药<br>使用人数', width: 70, dataIndex: 'ProprMedCount', sortable: false, menuDisabled : true, align: 'center'}
			//,{header: '中成药<br>使用率(%)', width: 70, dataIndex: 'ProprMedRadio', sortable: false, menuDisabled : true, align: 'center'}
			//,{header: '特色疗法<br>使用人数', width: 70, dataIndex: 'CharaTherapyCount', sortable: false, menuDisabled : true, align: 'center'}
			//,{header: '特色疗法<br>使用率(%)', width: 70, dataIndex: 'CharaTherapyRadio', sortable: false, menuDisabled : true, align: 'center'}
			//,{header: '中医药治疗<br>使用人数', width: 80, dataIndex: 'ChTherapyCount', sortable: false, menuDisabled : true, align: 'center'}
			//,{header: '中医药治疗<br>使用率(%)', width: 80, dataIndex: 'ChTherapyRadio', sortable: false, menuDisabled : true, align: 'center'}
			
			,{header: '预防性抗菌<br>药物使用率(%)', width: 100, dataIndex: 'PreDrugRatio', sortable: false, menuDisabled : true, align: 'center'}
			,{header: '使用抗菌<br>药物患者比例(%)', width: 100, dataIndex: 'Pharmacy3Ratio', sortable: false, menuDisabled : true, align: 'center'}
			,{header: '抗菌药物使用<br>平均天数(天)', width: 100, dataIndex: 'PharmacyDays', sortable: false, menuDisabled : true, align: 'center'}
			,{header: '抗菌药物<br>平均费用', width: 70, dataIndex: 'PharmacyCost', sortable: false, menuDisabled : true, align: 'center'}
			,{header: '抗菌药物<br>费用比例(%)', width: 80, dataIndex: 'PharmacyCostRatio', sortable: false, menuDisabled : true, align: 'center'}
			,{header: '14日再住<br>院率(%)', width: 70, dataIndex: 'NextDays14Ratio', sortable: false, menuDisabled : true, align: 'center'}
			,{header: '31日再住<br>院率(%)', width: 70, dataIndex: 'NextDays31Ratio', sortable: false, menuDisabled : true, align: 'center'}
			,{header: '常见并发症<br>发生率(%)', width: 80, dataIndex: 'ComplicationRatio', sortable: false, menuDisabled : true, align: 'center'}
			
			/* update by zf 2012-08-01
			//北京中医院评估结果
			,{header: '疗效评估', width: 80, sortable: false, align: 'center'
				, renderer: function(v, m, rd, r, c, s){
					var CPWDID = rd.get("CPWDID");
					var DateFrom = obj.QryArgDateFrom;
					var DateTo = obj.QryArgDateTo;
					var AnalysisType = obj.QryArgAnalysisType;
					var Loc = obj.QryArgLoc;
					var strRet = "";
					strRet += "<A id='lnkResultStat' HREF='#' onClick='ResultStatHeader(\"" + CPWDID + "\",\"" + DateFrom + "\",\"" + DateTo + "\",\"" + AnalysisType + "\",\"" + Loc + "\")' ><div align='left'>评估分析</div></A>";
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
			param.Arg3 = parseInt(obj.cboAnalysisType.getValue());	//	Modified by zhaoyu 2012-11-23 临床路径月报表统计方式（完成、不入径）查不出数据
			param.Arg4 = obj.cboLoc.getValue();	//	Modified by zhaoyu 2012-11-15 查询统计-临床路径月报表-选择【科室】后，统计不出来数据 缺陷编号210
			
			obj.QryArgDateFrom = param.Arg1;
			obj.QryArgDateTo = param.Arg2;
			obj.QryArgAnalysisType = param.Arg3;
			obj.QryArgLoc = param.Arg4;
			
			param.ArgCnt = 4;
	});
	InitMonitorViewportEvent(obj);
	//事件处理代码
	obj.LoadEvent(arguments);
	return obj;
	
	
	function rowDblClick(evt,CPWDID,titles)
	{
		var objWin = new Object();

		objWin.chkInPathWay = new Ext.form.Checkbox({
			id : 'chkInPathWay'
			,boxLabel : '入径患者'
			,listeners : {
      		'check': function(){
      			objWin.PaGridPanelStore.load({});
      		}
      }
			
		});
		objWin.btnExport = new Ext.Button({
				id : 'btnExport'
				,text : '导出'
				,listeners : {
      		'click': function(){
      			var fleName=titles;
      			if (objWin.chkInPathWay.getValue()){
      				fleName+="已";
      			}
      			else{
      				fleName+="未";
      			}
      			fleName+="入径患者列表";
      			fleName=fleName+"("+obj.dfDateFrom.getRawValue()+"至"+obj.dfDateTo.getRawValue()+")";
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
				{header: '登记号', width: 70, dataIndex: 'PapmiNo', sortable: true}
				,{header: '姓名', width: 60, dataIndex: 'PatName', sortable: true}
				,{header: '性别', width: 40, dataIndex: 'Sex', sortable: true}
				,{header: '年龄', width: 40, dataIndex: 'Age', sortable: true}
				,{header: '科室', width: 120, dataIndex: 'AdmLoc', sortable: true}
				,{header: '医生', width: 60, dataIndex: 'AdmDoc', sortable: true}
				,{header: '状态', width: 60, dataIndex: 'StatusDesc', sortable: true}
				,{header: '入院日期', width: 80, dataIndex: 'AdmitDate', sortable: true}
				,{header: '入院时间', width: 60, dataIndex: 'AdmitTime', sortable: true}
				,{header: '出院日期', width: 80, dataIndex: 'DisDate', sortable: true}
				,{header: '出院时间', width: 60, dataIndex: 'DisTime', sortable: true}
				,{header: '住院天数', width: 60, dataIndex: 'AdmDays', sortable: true}
				,{header: '实际费用', width: 60, dataIndex: 'CountCost', sortable: true}
				,{header: '药费比', width: 60, dataIndex: 'DrugRatio', sortable: true}
				,{header: '变异原因', width: 150, dataIndex: 'VarReason', sortable: false}
				,{header: '出径原因', width: 150, dataIndex: 'OutReasonDesc', sortable: false}
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
