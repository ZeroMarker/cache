
function InitPICC(obj)
{
	obj.PICC_valSubID = '';

	obj.gridAntibioticsPICCStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.gridAntibioticsPICCStore = new Ext.data.Store({
		proxy: obj.gridAntibioticsPICCStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'ind'
		}, 
		[
		//ArcimID,ArcimName,StartDate,StartTime,EndDate,EndTime
		   {name: 'ind', mapping : 'ind'}
			,{name: 'ArcimID', mapping : 'ArcimID'}
			,{name: 'ArcimName', mapping : 'ArcimName'}
			,{name: 'StartDate', mapping: 'StartDate'}
			,{name: 'StartTime', mapping: 'StartTime'}
			,{name: 'EndDate', mapping: 'EndDate'}
			,{name: 'EndTime', mapping: 'EndTime'}
		])
	});
	obj.gridAntibioticsPICC = new Ext.grid.EditorGridPanel({
		id : 'gridAntibioticsPICC'
		,store : obj.gridAntibioticsPICCStore
		,selModel : new Ext.grid.RowSelectionModel({singleSelect : true})
		,clicksToEdit : 1
		,columnLines : true
   	,stripeRows : true
    ,height : 150
		,region : 'north'
		,columns: [
			{header: '医嘱名称', width: 250, dataIndex: 'ArcimName', sortable: true, align: 'center'}
			,{header: '开始日期', width: 80, dataIndex: 'StartDate', sortable: false, align: 'center'}
			,{header: '开始时间', width: 60, dataIndex: 'StartTime', sortable: false, align: 'center'}
			,{header: '结束日期', width: 80, dataIndex: 'EndDate', sortable: false, menuDisabled:true, align: 'center'}
			,{header: '结束时间', width: 60, dataIndex: 'EndTime', sortable: false, align: 'center'}
		]
		,viewConfig : {
			forceFit : true
		}
		,listeners : {
							'rowdblclick' : function(){
								
								var selectObj = obj.gridAntibioticsPICC.getSelectionModel().getSelected();
								if (selectObj){
								
								obj.PICC_txtIntubateDateTime.setValue(selectObj.get("StartDate")+" "+ selectObj.get("StartTime"));
								obj.PICC_txtExtubateDateTime.setValue(selectObj.get("EndDate")+" "+ selectObj.get("EndTime"));
							}
						}
					}
    });
    
  
	obj.gridAntibioticsPICCStoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'DHCMed.NINFService.Rep.AimReport';
		param.QueryName = 'QueryOEInfo';
		param.Arg1 = obj.CurrReport.ChildPICC.EpisodeID;
		param.Arg2 = 'PICC';
		param.ArgCnt = 2;
	});
	
	obj.gridAntibioticsPICCStore.load({});
	
	//置管时间
	obj.PICC_txtIntubateDateTime = Common_DateFieldToDateTime("PICC_txtIntubateDateTime","置管时间");
	
	//拔管时间
	obj.PICC_txtExtubateDateTime = Common_DateFieldToDateTime("PICC_txtExtubateDateTime","拔管时间");
	
	//置管方位
	obj.PICC_cboIntubatePos = Common_ComboToDic("PICC_cboIntubatePos","置管方位","NINFAimPICCIntubatePos");
	
	//置管内径
	obj.PICC_cboIntubateSize = Common_ComboToDic("PICC_cboIntubateSize","置管内径","NINFAimPICCIntubateSize");
	
	//置管类型
	obj.PICC_cboIntubateType = Common_ComboToDic("PICC_cboIntubateType","置管类型","NINFAimPICCIntubateType");
	
	//置管腔数
	obj.PICC_cboIntubateNum = Common_ComboToDic("PICC_cboIntubateNum","置管腔数","NINFAimPICCIntubateNum");
	
	//置管部位
	obj.PICC_cboIntubateRegion = Common_ComboToDic("PICC_cboIntubateRegion","置管部位","NINFAimPICCIntubateRegion");
	
	//置管地点
	obj.PICC_cboIntubatePlace = Common_ComboToDic("PICC_cboIntubatePlace","置管地点","NINFAimPICCIntubatePlace");
	
	//拔管原因
	obj.PICC_cboExtubateReason = Common_ComboToDic("PICC_cboExtubateReason","拔管原因","NINFAimPICCExtubateReason");
	
	//置管人员类型
	obj.PICC_cboIntubateUserType = Common_ComboToDic("PICC_cboIntubateUserType","置管人员","NINFAimPICCIntubateUserType");
	
	//置管人员
	obj.PICC_cboIntubateUser = Common_ComboToSSUser("PICC_cboIntubateUser","置管人员");
	
	//是否感染
	obj.PICC_chkIsInf = Common_Checkbox("PICC_chkIsInf","是否感染");
	obj.PICC_chkIsInf.on('check',function(checkbox,value){
		var objItem1 = Ext.getCmp("PICC_txtInfDate");
		if (objItem1) {
			objItem1.setDisabled((!value));
		}
		var objItem1 = Ext.getCmp("PICC_cboInfPy");
		if (objItem1) {
			objItem1.setDisabled((!value));
		}
		if (!value) {
			Common_SetValue('PICC_txtInfDate','');
			Common_SetValue('PICC_cboInfPy','','');
		}
	},obj.PICC_chkIsInf);
	
	//感染日期
	obj.PICC_txtInfDate = Common_DateFieldToDate("PICC_txtInfDate","感染日期");
	
	//病原体
	obj.PICC_cboInfPy = Common_ComboToPathogeny("PICC_cboInfPy","病原体");
	
	obj.PICC_GridRowViewPort = {
		layout : 'fit',
		frame : true,
		region : 'center',
		items : [
			{
				layout : 'column',
				items : [
					{
						columnWidth:.50,
						layout : 'form',
						labelAlign : 'right',
						labelWidth : 60,
						items : [
						  
							obj.PICC_txtIntubateDateTime
							,obj.PICC_txtExtubateDateTime
							,obj.PICC_cboIntubatePos
							,obj.PICC_cboIntubateSize
							,obj.PICC_cboIntubateType
							,obj.PICC_cboIntubateNum
							,obj.PICC_cboIntubateRegion
						]
					},{
						columnWidth:.50,
						layout : 'form',
						labelAlign : 'right',
						labelWidth : 60,
						items : [
							obj.PICC_cboIntubatePlace
							,obj.PICC_cboIntubateUserType
							//,obj.PICC_cboIntubateUser
							,obj.PICC_cboExtubateReason
							,obj.PICC_chkIsInf
							,obj.PICC_txtInfDate
							,obj.PICC_cboInfPy
						]
					}
				]
			}
		]
	}
	
	obj.PICC_GridRowDataCheck = function()
	{
		var errInfo = '';
		
		var StatusCode = arguments[0];
		var objRec = arguments[1];
		if (objRec)
		{
			if (StatusCode == '2') {
				var PICC_txtIntubateDateTime = objRec.get('IntubateDateTime');
				if (PICC_txtIntubateDateTime=='') {
					errInfo = errInfo + '置管时间未填!';
				}
				var PICC_cboIntubatePos = objRec.get('IntubatePosDesc');
				if (PICC_cboIntubatePos=='') {
					errInfo = errInfo + '置管方位未填!';
				}
				var PICC_cboIntubateSize = objRec.get('IntubateSizeDesc');
				if (PICC_cboIntubateSize=='') {
					errInfo = errInfo + '置管内径未填!';
				}
				var PICC_cboIntubateType = objRec.get('IntubateTypeDesc');
				if (PICC_cboIntubateType=='') {
					errInfo = errInfo + '置管类型未填!';
				}
				var PICC_cboIntubateNum = objRec.get('IntubateNumDesc');
				if (PICC_cboIntubateNum=='') {
					errInfo = errInfo + '置管腔数未填!';
				}
				var PICC_cboIntubateRegion = objRec.get('IntubateRegionDesc');
				if (PICC_cboIntubateRegion=='') {
					errInfo = errInfo + '置管部位未填!';
				}
				var PICC_cboIntubatePlace = objRec.get('IntubatePlaceDesc');
				if (PICC_cboIntubatePlace=='') {
					errInfo = errInfo + '置管地点未填!';
				}
				var PICC_cboIntubateUserType = objRec.get('IntubateUserTypeDesc');
				if (PICC_cboIntubateUserType=='') {
					errInfo = errInfo + '置管人员未填!';
				}
				var PICC_cboIntubateUser = objRec.get('IntubateUserDesc');
				if (PICC_cboIntubateUser=='') {
					//errInfo = errInfo + '置管人员未填!';
				}
				var PICC_txtIntubateDateTime = objRec.get('ExtubateDateTime');
				if (PICC_txtIntubateDateTime=='') {
					errInfo = errInfo + '拔管时间未填!';
				}
				var PICC_cboExtubateReason = objRec.get('ExtubateReasonDesc');
				if (PICC_cboExtubateReason=='') {
					errInfo = errInfo + '拔管原因未填!';
				}
			}
		} else {
			if (StatusCode == '1') {
				var PICC_txtIntubateDateTime = Common_GetValue('PICC_txtIntubateDateTime');
				if (PICC_txtIntubateDateTime=='') {
					errInfo = errInfo + '置管时间未填!';
				}
			}
			if (StatusCode == '2') {
				var PICC_txtIntubateDateTime = Common_GetValue('PICC_txtIntubateDateTime');
				if (PICC_txtIntubateDateTime=='') {
					errInfo = errInfo + '置管时间未填!';
				}
				var PICC_cboIntubatePos = Common_GetValue('PICC_cboIntubatePos');
				if (PICC_cboIntubatePos=='') {
					errInfo = errInfo + '置管方位未填!';
				}
				var PICC_cboIntubateSize = Common_GetValue('PICC_cboIntubateSize');
				if (PICC_cboIntubateSize=='') {
					errInfo = errInfo + '置管内径未填!';
				}
				var PICC_cboIntubateType = Common_GetValue('PICC_cboIntubateType');
				if (PICC_cboIntubateType=='') {
					errInfo = errInfo + '置管类型未填!';
				}
				var PICC_cboIntubateNum = Common_GetValue('PICC_cboIntubateNum');
				if (PICC_cboIntubateNum=='') {
					errInfo = errInfo + '置管腔数未填!';
				}
				var PICC_cboIntubateRegion = Common_GetValue('PICC_cboIntubateRegion');
				if (PICC_cboIntubateRegion=='') {
					errInfo = errInfo + '置管部位未填!';
				}
				var PICC_cboIntubatePlace = Common_GetValue('PICC_cboIntubatePlace');
				if (PICC_cboIntubatePlace=='') {
					errInfo = errInfo + '置管地点未填!';
				}
				var PICC_cboIntubateUserType = Common_GetValue('PICC_cboIntubateUserType');
				if (PICC_cboIntubateUserType=='') {
					errInfo = errInfo + '置管人员未填!';
				}
				var PICC_cboIntubateUser = Common_GetValue('PICC_cboIntubateUser');
				if (PICC_cboIntubateUser=='') {
					//errInfo = errInfo + '置管人员未填!';
				}
				var PICC_txtIntubateDateTime = Common_GetValue('PICC_txtIntubateDateTime');
				if (PICC_txtIntubateDateTime=='') {
					errInfo = errInfo + '拔管时间未填!';
				}
				var PICC_cboExtubateReason = Common_GetValue('PICC_cboExtubateReason');
				if (PICC_cboExtubateReason=='') {
					errInfo = errInfo + '拔管原因未填!';
				}
			}
		}
		
		return errInfo;
	}
	
	obj.PICC_GridRowDataUpdateStatus = function()
	{
		var StatusCode = arguments[0];
		var objRec = arguments[1];
		if (objRec) {
			var inputStr = objRec.get('RepID') + "||" + objRec.get('SubID');
		} else {
			var inputStr = obj.CurrReport.ChildPICC.RowID + "||" + obj.PICC_valSubID;
		}
		inputStr = inputStr + CHR_1 + session['LOGON.CTLOCID'];
		inputStr = inputStr + CHR_1 + session['LOGON.USERID'];
		inputStr = inputStr + CHR_1 + StatusCode;
		
		var flg = obj.ClsAimReportPICCSrv.UpdateStatus(inputStr, CHR_1);
		if (parseInt(flg) <= 0) {
			return false;
		} else {
			return true;
		}
		return true;
	}
	
	obj.PICC_GridRowDataSave = function()
	{
		if (obj.CurrReport.ChildPICC.RowID == "")
		{
			var inputStr = "";
			inputStr = inputStr + CHR_1 + obj.CurrReport.ChildPICC.ReportTypeCode;
			inputStr = inputStr + CHR_1 + obj.CurrReport.ChildPICC.EpisodeID;
			inputStr = inputStr + CHR_1 + obj.CurrReport.ChildPICC.TransID;
			inputStr = inputStr + CHR_1 + obj.CurrReport.ChildPICC.TransLoc;
			inputStr = inputStr + CHR_1 + "";
			inputStr = inputStr + CHR_1 + "";
			inputStr = inputStr + CHR_1 + "";
			inputStr = inputStr + CHR_1 + "";
			inputStr = inputStr + CHR_1 + "";
			inputStr = inputStr + CHR_1 + session['LOGON.CTLOCID'];
			inputStr = inputStr + CHR_1 + session['LOGON.USERID'];
			inputStr = inputStr + CHR_1 + '';
			
			var flg = obj.ClsAimReportSrv.SaveReport(inputStr, CHR_1);
			if (parseInt(flg)<=0) {
				return false;
			} else {
				var objAimReport = obj.ClsAimReport.GetObjById(flg);
				objAimReport.ReportTypeCode = '';
				var objDictionary = obj.ClsSSDictionary.GetObjById(objAimReport.ReportType);
				if (objDictionary) {
					objAimReport.ReportTypeCode = objDictionary.Code;
				}
				obj.CurrReport.ChildPICC = objAimReport;
			}
		}
		if (obj.CurrReport.ChildPICC.RowID=='') return false;
		
		var StatusCode = arguments[0];
		
		var inputStr = obj.CurrReport.ChildPICC.RowID;
		inputStr = inputStr + CHR_1 + obj.PICC_valSubID;
		inputStr = inputStr + CHR_1 + Common_GetValue('PICC_txtIntubateDateTime');
		inputStr = inputStr + CHR_1 + Common_GetValue('PICC_txtExtubateDateTime');
		inputStr = inputStr + CHR_1 + Common_GetValue('PICC_cboIntubatePos');
		inputStr = inputStr + CHR_1 + Common_GetValue('PICC_cboIntubateSize');
		inputStr = inputStr + CHR_1 + Common_GetValue('PICC_cboIntubateType');
		inputStr = inputStr + CHR_1 + Common_GetValue('PICC_cboIntubateNum');
		inputStr = inputStr + CHR_1 + Common_GetValue('PICC_cboIntubateRegion');
		inputStr = inputStr + CHR_1 + Common_GetValue('PICC_cboIntubatePlace');
		inputStr = inputStr + CHR_1 + Common_GetValue('PICC_cboExtubateReason');
		inputStr = inputStr + CHR_1 + Common_GetValue('PICC_cboIntubateUserType');
		inputStr = inputStr + CHR_1 + Common_GetValue('PICC_cboIntubateUser');
		inputStr = inputStr + CHR_1 + Common_GetValue('PICC_txtInfDate');
		inputStr = inputStr + CHR_1 + Common_GetValue('PICC_cboInfPy') + CHR_3 + Common_GetText('PICC_cboInfPy');
		inputStr = inputStr + CHR_1 + session['LOGON.CTLOCID'];
		inputStr = inputStr + CHR_1 + session['LOGON.USERID'];
		inputStr = inputStr + CHR_1 + StatusCode;
		
		var flg = obj.ClsAimReportPICCSrv.SaveReport(inputStr, CHR_1);
		if (parseInt(flg)<=0) {
			return false;
		} else {
			return true;
		}
		return true;
	}
	
	obj.PICC_GridRowDataSet = function(objRec)
	{
		if (objRec)
		{
			obj.PICC_valSubID = objRec.get('SubID');
			Common_SetValue('PICC_txtIntubateDateTime',objRec.get('IntubateDateTime'));
			Common_SetValue('PICC_txtExtubateDateTime',objRec.get('ExtubateDateTime'));
			Common_SetValue('PICC_cboIntubatePos',objRec.get('IntubatePosID'),objRec.get('IntubatePosDesc'));
			Common_SetValue('PICC_cboIntubateSize',objRec.get('IntubateSizeID'),objRec.get('IntubateSizeDesc'));
			Common_SetValue('PICC_cboIntubateType',objRec.get('IntubateTypeID'),objRec.get('IntubateTypeDesc'));
			Common_SetValue('PICC_cboIntubateNum',objRec.get('IntubateNumID'),objRec.get('IntubateNumDesc'));
			Common_SetValue('PICC_cboIntubateRegion',objRec.get('IntubateRegionID'),objRec.get('IntubateRegionDesc'));
			Common_SetValue('PICC_cboIntubatePlace',objRec.get('IntubatePlaceID'),objRec.get('IntubatePlaceDesc'));
			Common_SetValue('PICC_cboExtubateReason',objRec.get('ExtubateReasonID'),objRec.get('ExtubateReasonDesc'));
			Common_SetValue('PICC_cboIntubateUserType',objRec.get('IntubateUserTypeID'),objRec.get('IntubateUserTypeDesc'));
			Common_SetValue('PICC_cboIntubateUser',objRec.get('IntubateUserID'),objRec.get('IntubateUserDesc'));
			
			//是否感染、感染日期、病原体
			Common_SetValue('PICC_chkIsInf',(objRec.get('IsInfection')=='是'));
			Common_SetValue('PICC_txtInfDate',objRec.get('InfDate'));
			var strInfPyValues = objRec.get('InfPyValues');
			var arrInfPyValues = strInfPyValues.split(CHR_1);
			if (arrInfPyValues.length > 0) {
				var strInfPyValue = arrInfPyValues[0];
				var arrInfPyValue = strInfPyValue.split("`");
				if (arrInfPyValue.length >= 2) {
					Common_SetValue('PICC_cboInfPy',arrInfPyValue[0],arrInfPyValue[1]);
				}
			} else {
				Common_SetValue('PICC_cboInfPy','','');
			}
			var objItem1 = Ext.getCmp("PICC_txtInfDate");
			if (objItem1) {
				objItem1.setDisabled((objRec.get('IsInfection')!='是'));
			}
			var objItem1 = Ext.getCmp("PICC_cboInfPy");
			if (objItem1) {
				objItem1.setDisabled((objRec.get('IsInfection')!='是'));
			}
		} else {
			obj.PICC_valSubID = '';
			Common_SetValue('PICC_txtIntubateDateTime','');
			Common_SetValue('PICC_txtExtubateDateTime','');
			Common_SetValue('PICC_cboIntubatePos','','');
			Common_SetValue('PICC_cboIntubateSize','','');
			Common_SetValue('PICC_cboIntubateType','','');
			Common_SetValue('PICC_cboIntubateNum','','');
			Common_SetValue('PICC_cboIntubateRegion','','');
			Common_SetValue('PICC_cboIntubatePlace','','');
			Common_SetValue('PICC_cboExtubateReason','','');
			Common_SetValue('PICC_cboIntubateUserType','','');
			Common_SetValue('PICC_cboIntubateUser','','');
			Common_SetValue('PICC_chkIsInf','');
			Common_SetValue('PICC_txtInfDate','');
			Common_SetValue('PICC_cboInfPy','','');
			var objItem1 = Ext.getCmp("PICC_txtInfDate");
			if (objItem1) {
				objItem1.setDisabled(true);
			}
			var objItem1 = Ext.getCmp("PICC_cboInfPy");
			if (objItem1) {
				objItem1.setDisabled(true);
			}
		}
	}
	
	obj.PICC_GridRowEditer = function(objRec)
	{
		var winGridRowEditer = Ext.getCmp('PICC_GridRowEditer');
		if (!winGridRowEditer)
		{
			winGridRowEditer = new Ext.Window({
				id : 'PICC_GridRowEditer',
				height : 450,
				closeAction: 'hide',
				width : 600,
				modal : true,
				title : '中央导管-编辑',
				layout : 'border',
				frame : true,
				items: [
				  obj.gridAntibioticsPICC
					,obj.PICC_GridRowViewPort
				],
				bbar : [
					'->',
					new Ext.Toolbar.Button({
						id: "PICC_GridRowEditer_btnUpdate",
						width : 80,
						text : "<img SRC='../scripts/dhcmed/img/update.gif'>保存",
						listeners : {
							'click' : function(){
								var errInfo = obj.PICC_GridRowDataCheck("1");
								if (errInfo)
								{
									ExtTool.alert("提示",errInfo);
								} else {
									var flg = obj.PICC_GridRowDataSave("1")
									if (flg)
									{
										winGridRowEditer.hide();
										var objGrid = Ext.getCmp('PICC_gridPICC');
										if (objGrid) {
											objGrid.getStore().load();
										}
									} else {
										ExtTool.alert("提示","保存数据错误!Error=" + flg);
									}
								}
							}
						}
					}),
					new Ext.Toolbar.Button({
						id: "PICC_GridRowEditer_btnCommit",
						width : 80,
						text : "<img SRC='../scripts/dhcmed/img/update.png'>提交",
						listeners : {
							'click' : function(){
								var errInfo = obj.PICC_GridRowDataCheck("2");
								if (errInfo) {
									ExtTool.alert("提示",errInfo);
								} else {
									var flg = obj.PICC_GridRowDataSave("2")
									if (flg) {
										winGridRowEditer.hide();
										var objGrid = Ext.getCmp('PICC_gridPICC');
										if (objGrid) {
											objGrid.getStore().load();
										}
									} else {
										ExtTool.alert("提示","提交数据错误!Error=" + flg);
									}
								}
							}
						}
					}),
					new Ext.Toolbar.Button({
						id: "PICC_GridRowEditer_btnCancel",
						width : 80,
						text : "<img SRC='../scripts/dhcmed/img/cancel.png'>关闭",
						listeners : {
							'click' : function(){
								winGridRowEditer.hide();
							}
						}
					})
				]
			});
		}
		winGridRowEditer.show();
		obj.PICC_GridRowDataSet(objRec);
	}
	
	//中央导管
	obj.PICC_GridToPICC = function()
	{
		var tmpGridPanel = new Ext.grid.GridPanel({
			id: arguments[0],
			store : new Ext.data.Store({
				proxy: new Ext.data.HttpProxy({
					url : ExtToolSetting.RunQueryPageURL,
					listeners : {
						'beforeload' :  function(objProxy, param){
							param.ClassName = 'DHCMed.NINFService.Rep.AimReportPICC';
							param.QueryName = 'QryReportByID';
							param.Arg1      = obj.CurrReport.ChildPICC.RowID;
							param.ArgCnt    = 1;
						}
					}
				}),
				reader: new Ext.data.JsonReader(
					{
						root: 'record',
						totalProperty: 'total',
						idProperty: 'SubID'
					},
					[
						{name: 'RepID', mapping: 'RepID'}
						,{name: 'SubID', mapping: 'SubID'}
						,{name: 'IntubateDate', mapping: 'IntubateDate'}
						,{name: 'IntubateTime', mapping: 'IntubateTime'}
						,{name: 'IntubateDateTime', mapping: 'IntubateDateTime'}
						,{name: 'ExtubateDate', mapping: 'ExtubateDate'}
						,{name: 'ExtubateTime', mapping: 'ExtubateTime'}
						,{name: 'ExtubateDateTime', mapping: 'ExtubateDateTime'}
						,{name: 'IntubatePosID', mapping: 'IntubatePosID'}
						,{name: 'IntubatePosDesc', mapping: 'IntubatePosDesc'}
						,{name: 'IntubateSizeID', mapping: 'IntubateSizeID'}
						,{name: 'IntubateSizeDesc', mapping: 'IntubateSizeDesc'}
						,{name: 'IntubateTypeID', mapping: 'IntubateTypeID'}
						,{name: 'IntubateTypeDesc', mapping: 'IntubateTypeDesc'}
						,{name: 'IntubateNumID', mapping: 'IntubateNumID'}
						,{name: 'IntubateNumDesc', mapping: 'IntubateNumDesc'}
						,{name: 'IntubateRegionID', mapping: 'IntubateRegionID'}
						,{name: 'IntubateRegionDesc', mapping: 'IntubateRegionDesc'}
						,{name: 'IntubatePlaceID', mapping: 'IntubatePlaceID'}
						,{name: 'IntubatePlaceDesc', mapping: 'IntubatePlaceDesc'}
						,{name: 'ExtubateReasonID', mapping: 'ExtubateReasonID'}
						,{name: 'ExtubateReasonDesc', mapping: 'ExtubateReasonDesc'}
						,{name: 'IntubateUserTypeID', mapping: 'IntubateUserTypeID'}
						,{name: 'IntubateUserTypeDesc', mapping: 'IntubateUserTypeDesc'}
						,{name: 'IntubateUserID', mapping: 'IntubateUserID'}
						,{name: 'IntubateUserDesc', mapping: 'IntubateUserDesc'}
						,{name: 'IsInfection', mapping: 'IsInfection'}
						,{name: 'InfDate', mapping: 'InfDate'}
						,{name: 'InfPyIDs', mapping: 'InfPyIDs'}
						,{name: 'InfPyDescs', mapping: 'InfPyDescs'}
						,{name: 'InfPyValues', mapping: 'InfPyValues'}
						,{name: 'RepLocID', mapping: 'RepLocID'}
						,{name: 'RepLocDesc', mapping: 'RepLocDesc'}
						,{name: 'RepUserID', mapping: 'RepUserID'}
						,{name: 'RepUserDesc', mapping: 'RepUserDesc'}
						,{name: 'RepDate', mapping: 'RepDate'}
						,{name: 'RepTime', mapping: 'RepTime'}
						,{name: 'RepDateTime', mapping: 'RepDateTime'}
						,{name: 'RepStatusID', mapping: 'RepStatusID'}
						,{name: 'RepStatusDesc', mapping: 'RepStatusDesc'}
					]
				)
			})
			,height : 120
			//,overflow:'scroll'
			//,overflow-y:hidden
			//,style:'overflow:auto;overflow-y:hidden'
			//,loadMask : true
			//,frame : true
			,anchor : '100%'
			,columns: [
				{header: '报告<br>状态', width: 50, dataIndex: 'RepStatusDesc', sortable: false, menuDisabled:true, align:'center' }
				,{header: '置管时间', width: 100, dataIndex: 'IntubateDateTime', sortable: false, menuDisabled:true, align:'center' }
				,{header: '拔管时间', width: 100, dataIndex: 'ExtubateDateTime', sortable: false, menuDisabled:true, align:'center' }
				,{header: '置管<br>方位', width: 40, dataIndex: 'IntubatePosDesc', sortable: false, menuDisabled:true, align:'center' }
				,{header: '置管<br>内径', width: 40, dataIndex: 'IntubateSizeDesc', sortable: false, menuDisabled:true, align:'center' }
				,{header: '置管类型', width: 60, dataIndex: 'IntubateTypeDesc', sortable: false, menuDisabled:true, align:'center' }
				,{header: '置管<br>腔数', width: 40, dataIndex: 'IntubateNumDesc', sortable: false, menuDisabled:true, align:'center' }
				,{header: '置管<br>部位', width: 40, dataIndex: 'IntubateRegionDesc', sortable: false, menuDisabled:true, align:'center' }
				,{header: '置管地点', width: 60, dataIndex: 'IntubatePlaceDesc', sortable: false, menuDisabled:true, align:'center' }
				,{header: '置管人员', width: 80, dataIndex: 'IntubateUserTypeDesc', sortable: false, menuDisabled:true, align:'center' }
				,{header: '拔管原因', width: 60, dataIndex: 'ExtubateReasonDesc', sortable: false, menuDisabled:true, align:'center' }
				,{header: '是否<br>感染', width: 50, dataIndex: 'IsInfection', sortable: false, menuDisabled:true, align:'center' }
				,{header: '感染日期', width: 80, dataIndex: 'InfDate', sortable: false, menuDisabled:true, align:'center' }
				,{header: '病原体', width: 100, dataIndex: 'InfPyDescs', sortable: false, menuDisabled:true, align:'center' }
				,{header: '填报时间', width: 100, dataIndex: 'RepDateTime', sortable: false, menuDisabled:true, align:'center' }
				,{header: '填报科室', width: 100, dataIndex: 'RepLocDesc', sortable: false, menuDisabled:true, align:'center' }
				,{header: '填报人', width: 60, dataIndex: 'RepUserDesc', sortable: false, menuDisabled:true, align:'center' }
			],
			bbar : [
				new Ext.Toolbar.Button({
					id: arguments[0] + "_btnAdd",
					width : 80,
					text : "<img SRC='../scripts/dhcmed/img/add.png'>增加",
					listeners : {
						'click' : function(){
							obj.PICC_GridRowEditer("");
						}
					}
				}),
				new Ext.Toolbar.Button({
					id: arguments[0] + "_btnDelete",
					width : 80,
					text : "<img SRC='../scripts/dhcmed/img/delete.gif'>删除",
					listeners : {
						'click' : function(){
							var objGrid = Ext.getCmp("PICC_gridPICC");
							if (objGrid){
								var objRecArr = objGrid.getSelectionModel().getSelections();
								if (objRecArr.length>0){
									Ext.MessageBox.confirm('删除', '是否删除选中数据记录?', function(btn,text){
										if(btn=="yes"){
											for (var indRec = 0; indRec < objRecArr.length; indRec++){
												var objRec = objRecArr[indRec];
												var flg = obj.PICC_GridRowDataUpdateStatus('0',objRec);
											}
											objGrid.getStore().load({});
										}
									});
								} else {
									ExtTool.alert("提示","请选中数据记录,再点击删除!");
								}
							}
						}
					}
				}),
				new Ext.Toolbar.Button({
					id: arguments[0] + "_btnCommit",
					width : 80,
					text : "<img SRC='../scripts/dhcmed/img/update.png'>提交",
					listeners : {
						'click' : function(){
							var objGrid = Ext.getCmp("PICC_gridPICC");
							if (objGrid){
								var objRecArr = objGrid.getSelectionModel().getSelections();
								if (objRecArr.length>0){
									for (var indRec = 0; indRec < objRecArr.length; indRec++){
										var objRec = objRecArr[indRec];
										var flg = obj.PICC_GridRowDataCheck('2',objRec);
										if (flg) {
											ExtTool.alert("提示","数据信息不完整,不允许提交!" + flg);
											continue;
										}
										var flg = obj.PICC_GridRowDataUpdateStatus('2',objRec);
									}
									objGrid.getStore().load({});
								} else {
									ExtTool.alert("提示","请选中数据记录,再点击提交!");
								}
							}
						}
					}
				}),
				'->',
				'…'
				/*
				new Ext.Toolbar.Button({
					id: arguments[0] + "_btnUpdate",
					width : 80,
					text : "<img SRC='../scripts/dhcmed/img/update.gif'>提取数据"
				})
				*/
			],
			viewConfig : {
				//forceFit : true
			}
		});
		
		return tmpGridPanel;
	}
	
	//中央导管
	obj.PICC_gridPICC = obj.PICC_GridToPICC("PICC_gridPICC");
	
	obj.PICC_txtRegNo = Common_TextField("PICC_txtRegNo","登记号");
	obj.PICC_txtPatName = Common_TextField("PICC_txtPatName","姓名");
	obj.PICC_txtPatSex = Common_TextField("PICC_txtPatSex","性别");
	obj.PICC_txtPatAge = Common_TextField("PICC_txtPatAge","年龄");
	
	obj.PICC_txtAdmDate = Common_TextField("PICC_txtAdmDate","入院日期");
	obj.PICC_txtAdmLoc = Common_TextField("PICC_txtAdmLoc","当前科室");
	obj.PICC_txtAdmWard = Common_TextField("PICC_txtAdmWard","当前病区");
	obj.PICC_txtAdmBed = Common_TextField("PICC_txtAdmBed","床号");
	
	obj.PICC_txtTransLoc = Common_TextField("PICC_txtTransLoc","转入科室");
	obj.PICC_txtTransInDate = Common_TextField("PICC_txtTransInDate","入科日期");
	obj.PICC_txtTransOutDate = Common_TextField("PICC_txtTransOutDate","出科日期");
	obj.PICC_txtTransFormLoc = Common_TextField("PICC_txtTransFormLoc","入科来源");
	obj.PICC_txtTransToLoc = Common_TextField("PICC_txtTransToLoc","出科去向");
	
	obj.PICC_txtRegNo.setDisabled(true);
	obj.PICC_txtPatName.setDisabled(true);
	obj.PICC_txtPatSex.setDisabled(true);
	obj.PICC_txtPatAge.setDisabled(true);
	
	obj.PICC_txtAdmDate.setDisabled(true);
	obj.PICC_txtAdmLoc.setDisabled(true);
	obj.PICC_txtAdmWard.setDisabled(true);
	obj.PICC_txtAdmBed.setDisabled(true);
	
	obj.PICC_txtTransLoc.setDisabled(true);
	obj.PICC_txtTransInDate.setDisabled(true);
	obj.PICC_txtTransOutDate.setDisabled(true);
	obj.PICC_txtTransFormLoc.setDisabled(true);
	obj.PICC_txtTransToLoc.setDisabled(true);
	
	//基本信息
	obj.PICC_FormToPAT = function()
	{
		var tmpFormPanel = {
			layout : 'form',
			autoScroll : true,
			bodyStyle : 'overflow-x:hidden;',
			items : [
				{
					layout : 'column',
					items : [
						{
							columnWidth:.25,
							layout : 'form',
							labelAlign : 'right',
							labelWidth : 60,
							items : [obj.PICC_txtRegNo]
						},{
							columnWidth:.25,
							layout : 'form',
							labelAlign : 'right',
							labelWidth : 60,
							items : [obj.PICC_txtPatName]
						},{
							columnWidth:.25,
							layout : 'form',
							labelAlign : 'right',
							labelWidth : 60,
							items : [obj.PICC_txtPatSex]
						},{
							columnWidth:.25,
							layout : 'form',
							labelAlign : 'right',
							labelWidth : 60,
							items : [obj.PICC_txtPatAge]
						}
					]
				},
				{
					layout : 'column',
					items : [
						{
							columnWidth:.25,
							layout : 'form',
							labelAlign : 'right',
							labelWidth : 60,
							items : [obj.PICC_txtAdmDate]
						},{
							columnWidth:.25,
							layout : 'form',
							labelAlign : 'right',
							labelWidth : 60,
							items : [obj.PICC_txtAdmLoc]
						},{
							columnWidth:.25,
							layout : 'form',
							labelAlign : 'right',
							labelWidth : 60,
							items : [obj.PICC_txtAdmWard]
						},{
							columnWidth:.25,
							layout : 'form',
							labelAlign : 'right',
							labelWidth : 60,
							items : [obj.PICC_txtAdmBed]
						}
					]
				},
				{
					layout : 'column',
					items : [
						{
							columnWidth:.25,
							layout : 'form',
							labelAlign : 'right',
							labelWidth : 60,
							items : [obj.PICC_txtTransLoc]
						},{
							columnWidth:.25,
							layout : 'form',
							labelAlign : 'right',
							labelWidth : 60,
							items : [obj.PICC_txtTransInDate]
						},{
							columnWidth:.25,
							layout : 'form',
							labelAlign : 'right',
							labelWidth : 60,
							items : [obj.PICC_txtTransOutDate]
						},{
							columnWidth:.25,
							layout : 'form',
							labelAlign : 'right',
							labelWidth : 60,
							items : [obj.PICC_txtTransToLoc]
						}
					]
				}
			]
		}
		
		return tmpFormPanel;
	}
	
	//基本信息
	obj.PICC_formPAT = obj.PICC_FormToPAT("PICC_formPAT");
	
	//初始化页面
	obj.PICC_FormPatDataSet = function()
	{
		var objPaadm = obj.ClsBasePatientAdm.GetObjById(obj.CurrReport.ChildPICC.EpisodeID);
		if (objPaadm) {
			var PatientID = objPaadm.PatientID;
			var objPatient = obj.ClsBasePatient.GetObjById(PatientID);
			if (objPatient) {
				Common_SetValue('PICC_txtRegNo',objPatient.PapmiNo);
				Common_SetValue('PICC_txtPatName',objPatient.PatientName);
				Common_SetValue('PICC_txtPatSex',objPatient.Sex);
				var Age = objPatient.Age;
				var Month = objPatient.AgeMonth;
				var Day = objPatient.AgeDay;
				if (!Age) Age=0;
				if (!Month) Month=0;
				if (!Day) Day=0;
				if (parseInt(Age) > 0) {
					Common_SetValue('PICC_txtPatAge',parseInt(Age) + '岁');
				} else {
					Common_SetValue('PICC_txtPatAge',parseInt(Month) + '月' + parseInt(Day) + '天');
				}
			}
			Common_SetValue('PICC_txtAdmDate',objPaadm.AdmitDate + ' ' + objPaadm.AdmitTime);
			Common_SetValue('PICC_txtAdmLoc',objPaadm.Department);
			Common_SetValue('PICC_txtAdmWard',objPaadm.Ward);
			Common_SetValue('PICC_txtAdmBed',objPaadm.Bed + "床");
		}
		
		var strTransLoc = obj.ClsCommonClsSrv.GetAdmTrans(obj.CurrReport.ChildPICC.TransID,obj.CurrReport.ChildPICC.TransLoc);
		var arrTransLoc = strTransLoc.split(CHR_1);
		if (arrTransLoc.length>=10)
		{
			Common_SetValue('PICC_txtTransInDate',arrTransLoc[6] + ' ' + arrTransLoc[7]);
			Common_SetValue('PICC_txtTransOutDate',arrTransLoc[8] + ' ' + arrTransLoc[9]);
			Common_SetValue('PICC_txtTransLoc',arrTransLoc[1]);
			Common_SetValue('PICC_txtTransFormLoc',arrTransLoc[3]);
			Common_SetValue('PICC_txtTransToLoc',arrTransLoc[5]);
		}
	}
	
	obj.PICC_ViewPort = {
		layout : 'border',
		title : '中央导管',
		items : [
			{
				layout : 'fit',
				region : 'north',
				height : 100,
				frame : true,
				items : [obj.PICC_formPAT]
			},{
				layout : 'fit',
				region: 'center',
				frame : true,
				items : [obj.PICC_gridPICC]
			}
		]
	}
	
	obj.PICC_InitView = function(){
		var objGrid = Ext.getCmp("PICC_gridPICC");
		if (objGrid){
			objGrid.getStore().load({});
			objGrid.on('rowdblclick',function(){
				var rowIndex = arguments[1];
				var objRec = this.getStore().getAt(rowIndex);
				obj.PICC_GridRowEditer(objRec);
			},objGrid);
		}
		obj.PICC_FormPatDataSet();
	}
	
	return obj;
}