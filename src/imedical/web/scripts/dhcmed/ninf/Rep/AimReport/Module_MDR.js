
function InitMDR(obj)
{
	obj.MDR_valSubID = '';
	
	//送检日期
	obj.MDR_txtPathDate = Common_DateFieldToDate("MDR_txtPathDate","送检日期");
	
	//标本类型
	obj.MDR_cboSampleType = Common_ComboToDic("MDR_cboSampleType","标本类型","NINFAimMDRSampleType");
	
	//细菌名称
	obj.MDR_cboPathogeny = Common_ComboToDic("MDR_cboPathogeny","细菌名称","NIFNAimMDRPathogeny");
	
	//隔离方式
	obj.MDR_cboIsolateType = Common_ComboToDic("MDR_cboIsolateType","隔离方式","NINFAimMDRIsolateType");
	
	//加强手卫生
	obj.MDR_cboHandHygiene = Common_ComboToDic("MDR_cboHandHygiene","加强手卫生","NINFAimMDRHandHygiene");
	
	//续发病历
	obj.MDR_cboSecondaryCases = Common_ComboToDic("MDR_cboSecondaryCases","续发病历","NINFAimMDRSecondaryCases");
	
	//感染情况
	obj.MDR_cboNINFStation = Common_ComboToDic("MDR_cboNINFStation","感染情况","NINFStation");
	
	obj.MDR_GridRowViewPort = {
		layout : 'form',
		labelAlign : 'right',
		labelWidth : 70,
		frame : true,
		items : [
			obj.MDR_txtPathDate
			,obj.MDR_cboSampleType
			,obj.MDR_cboPathogeny
			,obj.MDR_cboNINFStation
			,obj.MDR_cboIsolateType
			,obj.MDR_cboHandHygiene
			,obj.MDR_cboSecondaryCases
		]
	}
	
	obj.MDR_GridRowDataCheck = function()
	{
		var errInfo = '';
		
		var StatusCode = arguments[0];
		var objRec = arguments[1];
		if (objRec)
		{
			if (StatusCode == '2') {
				var MDR_txtPathDate = objRec.get('MDR_txtPathDate');
				if (MDR_txtPathDate=='') {
					errInfo = errInfo + '送检日期未填!';
				}
				var MDR_cboSampleType = objRec.get('SampleTypeDesc');
				if (MDR_cboSampleType=='') {
					errInfo = errInfo + '标本类型未填!';
				}
				var MDR_cboPathogeny = objRec.get('PathogenyDesc');
				if (MDR_cboPathogeny=='') {
					errInfo = errInfo + '细菌名称未填!';
				}
				var MDR_cboIsolateType = objRec.get('IsolateTypeDesc');
				if (MDR_cboIsolateType=='') {
					errInfo = errInfo + '隔离方式未填!';
				}
				var MDR_cboHandHygiene = objRec.get('HandHygieneDesc');
				if (MDR_cboHandHygiene=='') {
					errInfo = errInfo + '加强手卫生未填!';
				}
				var MDR_cboSecondaryCases = objRec.get('SecondaryCasesDesc');
				if (MDR_cboSecondaryCases=='') {
					errInfo = errInfo + '续发病历未填!';
				}
				
				var MDR_cboNINFStation = objRec.get('NINFStation');
				if (MDR_cboNINFStation=='') {
					errInfo = errInfo + '感染情况未填!';
				}
			}
		} else {
			if (StatusCode == '1') {
				var MDR_cboPathogeny = Common_GetValue('MDR_cboPathogeny');
				if (MDR_cboPathogeny=='') {
					errInfo = errInfo + '细菌名称未填!';
				}
			}
			if (StatusCode == '2') {
				var MDR_txtPathDate = Common_GetValue('MDR_txtPathDate');
				if (MDR_txtPathDate=='') {
					errInfo = errInfo + '送检日期未填!';
				}
				var MDR_cboSampleType = Common_GetValue('MDR_cboSampleType');
				if (MDR_cboSampleType=='') {
					errInfo = errInfo + '标本类型未填!';
				}
				var MDR_cboPathogeny = Common_GetValue('MDR_cboPathogeny');
				if (MDR_cboPathogeny=='') {
					errInfo = errInfo + '细菌名称未填!';
				}
				var MDR_cboIsolateType = Common_GetValue('MDR_cboIsolateType');
				if (MDR_cboIsolateType=='') {
					errInfo = errInfo + '隔离方式未填!';
				}
				var MDR_cboHandHygiene = Common_GetValue('MDR_cboHandHygiene');
				if (MDR_cboHandHygiene=='') {
					errInfo = errInfo + '加强手卫生未填!';
				}
				var MDR_cboSecondaryCases = Common_GetValue('MDR_cboSecondaryCases');
				if (MDR_cboSecondaryCases=='') {
					errInfo = errInfo + '续发病历未填!';
				}
				
				var MDR_cboNINFStation = Common_GetValue('MDR_cboNINFStation');
				if (MDR_cboNINFStation=='') {
					errInfo = errInfo + '感染情况未填!';
				}
			}
		}
		
		return errInfo;
	}
	
	obj.MDR_GridRowDataUpdateStatus = function()
	{
		var StatusCode = arguments[0];
		var objRec = arguments[1];
		if (objRec) {
			var inputStr = objRec.get('RepID') + "||" + objRec.get('SubID');
		} else {
			var inputStr = obj.CurrReport.ChildMDR.RowID + "||" + obj.MDR_valSubID;
		}
		inputStr = inputStr + CHR_1 + session['LOGON.CTLOCID'];
		inputStr = inputStr + CHR_1 + session['LOGON.USERID'];
		inputStr = inputStr + CHR_1 + StatusCode;
		
		var flg = obj.ClsAimReportMDRSrv.UpdateStatus(inputStr, CHR_1);
		if (parseInt(flg) <= 0) {
			return false;
		} else {
			return true;
		}
		return true;
	}
	
	obj.MDR_GridRowDataSave = function()
	{
		if (obj.CurrReport.ChildMDR.RowID == "")
		{
			var inputStr = "";
			inputStr = inputStr + CHR_1 + obj.CurrReport.ChildMDR.ReportTypeCode;
			inputStr = inputStr + CHR_1 + obj.CurrReport.ChildMDR.EpisodeID;
			inputStr = inputStr + CHR_1 + obj.CurrReport.ChildMDR.TransID;
			inputStr = inputStr + CHR_1 + obj.CurrReport.ChildMDR.TransLoc;
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
				obj.CurrReport.ChildMDR = objAimReport;
			}
		}
		if (obj.CurrReport.ChildMDR.RowID=='') return false;
		
		var StatusCode = arguments[0];
		
		var inputStr = obj.CurrReport.ChildMDR.RowID;
		inputStr = inputStr + CHR_1 + obj.MDR_valSubID;
		inputStr = inputStr + CHR_1 + Common_GetValue('MDR_txtPathDate');
		inputStr = inputStr + CHR_1 + Common_GetValue('MDR_cboSampleType');
		inputStr = inputStr + CHR_1 + Common_GetValue('MDR_cboPathogeny');
		inputStr = inputStr + CHR_1 + Common_GetValue('MDR_cboIsolateType');
		inputStr = inputStr + CHR_1 + Common_GetValue('MDR_cboHandHygiene');
		inputStr = inputStr + CHR_1 + Common_GetValue('MDR_cboSecondaryCases');
		inputStr = inputStr + CHR_1 + session['LOGON.CTLOCID'];
		inputStr = inputStr + CHR_1 + session['LOGON.USERID'];
		inputStr = inputStr + CHR_1 + StatusCode;
		inputStr = inputStr + CHR_1 + Common_GetValue('MDR_cboNINFStation');
		var flg = obj.ClsAimReportMDRSrv.SaveReport(inputStr, CHR_1);
		if (parseInt(flg)<=0) {
			return false;
		} else {
			return true;
		}
		return true;
	}
	
	obj.MDR_GridRowDataSet = function(objRec)
	{
		if (objRec)
		{
			obj.MDR_valSubID = objRec.get('SubID');
			Common_SetValue('MDR_txtPathDate',objRec.get('PathDate'));
			Common_SetValue('MDR_cboSampleType',objRec.get('SampleTypeID'),objRec.get('SampleTypeDesc'));
			Common_SetValue('MDR_cboPathogeny',objRec.get('PathogenyID'),objRec.get('PathogenyDesc'));
			Common_SetValue('MDR_cboIsolateType',objRec.get('IsolateTypeID'),objRec.get('IsolateTypeDesc'));
			Common_SetValue('MDR_cboHandHygiene',objRec.get('HandHygieneID'),objRec.get('HandHygieneDesc'));
			Common_SetValue('MDR_cboSecondaryCases',objRec.get('SecondaryCasesID'),objRec.get('SecondaryCasesDesc'));
			Common_SetValue('MDR_cboNINFStation',objRec.get('NINFStationID'),objRec.get('NINFStationDesc'));
		} else {
			obj.MDR_valSubID = '';
			Common_SetValue('MDR_txtPathDate','');
			Common_SetValue('MDR_cboSampleType','','');
			Common_SetValue('MDR_cboPathogeny','','');
			Common_SetValue('MDR_cboIsolateType','','');
			Common_SetValue('MDR_cboHandHygiene','','');
			Common_SetValue('MDR_cboSecondaryCases','','');
			Common_SetValue('MDR_cboNINFStation','','');
		}
	}
	
	obj.MDR_GridRowEditer = function(objRec)
	{
		var winGridRowEditer = Ext.getCmp('MDR_GridRowEditer');
		if (!winGridRowEditer)
		{
			winGridRowEditer = new Ext.Window({
				id : 'MDR_GridRowEditer',
				height : 280,
				closeAction: 'hide',
				width : 300,
				modal : true,
				title : '多重耐药-编辑',
				layout : 'fit',
				frame : true,
				items: [
					obj.MDR_GridRowViewPort
				],
				bbar : [
					'->',
					new Ext.Toolbar.Button({
						id: "MDR_GridRowEditer_btnUpdate",
						width : 80,
						text : "<img SRC='../scripts/dhcmed/img/update.gif'>保存",
						listeners : {
							'click' : function(){
								var errInfo = obj.MDR_GridRowDataCheck("1");
								if (errInfo) {
									ExtTool.alert("提示",errInfo);
								} else {
									var flg = obj.MDR_GridRowDataSave("1")
									if (flg) {
										winGridRowEditer.hide();
										var objGrid = Ext.getCmp('MDR_gridMDR');
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
						id: "MDR_GridRowEditer_btnCommit",
						width : 80,
						text : "<img SRC='../scripts/dhcmed/img/update.png'>提交",
						listeners : {
							'click' : function(){
								var errInfo = obj.MDR_GridRowDataCheck("2");
								if (errInfo) {
									ExtTool.alert("提示",errInfo);
								} else {
									var flg = obj.MDR_GridRowDataSave("2")
									if (flg) {
										winGridRowEditer.hide();
										var objGrid = Ext.getCmp('MDR_gridMDR');
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
						id: "MDR_GridRowEditer_btnCancel",
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
		obj.MDR_GridRowDataSet(objRec);
	}
	
	//多重耐药
	obj.MDR_GridToMDR = function()
	{
		var tmpGridPanel = new Ext.grid.GridPanel({
			id: arguments[0],
			store : new Ext.data.Store({
				proxy: new Ext.data.HttpProxy({
					url : ExtToolSetting.RunQueryPageURL,
					listeners : {
						'beforeload' :  function(objProxy, param){
							param.ClassName = 'DHCMed.NINFService.Rep.AimReportMDR';
							param.QueryName = 'QryReportByID';
							param.Arg1      = obj.CurrReport.ChildMDR.RowID;
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
						,{name: 'PathDate', mapping: 'PathDate'}
						,{name: 'SampleTypeID', mapping: 'SampleTypeID'}
						,{name: 'SampleTypeDesc', mapping: 'SampleTypeDesc'}
						,{name: 'PathogenyID', mapping: 'PathogenyID'}
						,{name: 'PathogenyDesc', mapping: 'PathogenyDesc'}
						,{name: 'IsolateTypeID', mapping: 'IsolateTypeID'}
						,{name: 'IsolateTypeDesc', mapping: 'IsolateTypeDesc'}
						,{name: 'HandHygieneID', mapping: 'HandHygieneID'}
						,{name: 'HandHygieneDesc', mapping: 'HandHygieneDesc'}
						,{name: 'SecondaryCasesID', mapping: 'SecondaryCasesID'}
						,{name: 'SecondaryCasesDesc', mapping: 'SecondaryCasesDesc'}
						,{name: 'RepLocID', mapping: 'RepLocID'}
						,{name: 'RepLocDesc', mapping: 'RepLocDesc'}
						,{name: 'RepUserID', mapping: 'RepUserID'}
						,{name: 'RepUserDesc', mapping: 'RepUserDesc'}
						,{name: 'RepDate', mapping: 'RepDate'}
						,{name: 'RepTime', mapping: 'RepTime'}
						,{name: 'RepDateTime', mapping: 'RepDateTime'}
						,{name: 'RepStatusID', mapping: 'RepStatusID'}
						,{name: 'RepStatusDesc', mapping: 'RepStatusDesc'}
						,{name: 'NINFStationID', mapping: 'NINFStationID'}
						,{name: 'NINFStationDesc', mapping: 'NINFStationDesc'}
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
				,{header: '送检日期', width: 80, dataIndex: 'PathDate', sortable: false, menuDisabled:true, align:'center' }
				,{header: '标本类型', width: 80, dataIndex: 'SampleTypeDesc', sortable: false, menuDisabled:true, align:'center' }
				,{header: '细菌名称', width: 150, dataIndex: 'PathogenyDesc', sortable: false, menuDisabled:true, align:'center' }
				,{header: '感染情况', width: 150, dataIndex: 'NINFStationDesc', sortable: false, menuDisabled:true, align:'center' }
				,{header: '隔离方式', width: 80, dataIndex: 'IsolateTypeDesc', sortable: false, menuDisabled:true, align:'center' }
				,{header: '加强<br>手卫生', width: 80, dataIndex: 'HandHygieneDesc', sortable: false, menuDisabled:true, align:'center' }
				,{header: '续发病历', width: 80, dataIndex: 'SecondaryCasesDesc', sortable: false, menuDisabled:true, align:'center' }
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
							obj.MDR_GridRowEditer("");
						}
					}
				}),
				new Ext.Toolbar.Button({
					id: arguments[0] + "_btnDelete",
					width : 80,
					text : "<img SRC='../scripts/dhcmed/img/delete.gif'>删除",
					listeners : {
						'click' : function(){
							var objGrid = Ext.getCmp("MDR_gridMDR");
							if (objGrid){
								var objRecArr = objGrid.getSelectionModel().getSelections();
								if (objRecArr.length>0){
									Ext.MessageBox.confirm('删除', '是否删除选中数据记录?', function(btn,text){
										if(btn=="yes"){
											for (var indRec = 0; indRec < objRecArr.length; indRec++){
												var objRec = objRecArr[indRec];
												var flg = obj.MDR_GridRowDataUpdateStatus('0',objRec);
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
							var objGrid = Ext.getCmp("MDR_gridMDR");
							if (objGrid){
								var objRecArr = objGrid.getSelectionModel().getSelections();
								if (objRecArr.length>0){
									for (var indRec = 0; indRec < objRecArr.length; indRec++){
										var objRec = objRecArr[indRec];
										var flg = obj.MDR_GridRowDataCheck('2',objRec);
										if (flg) {
											ExtTool.alert("提示","数据信息不完整,不允许提交!" + flg);
											continue;
										}
										var flg = obj.MDR_GridRowDataUpdateStatus('2',objRec);
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
	
	//多重耐药
	obj.MDR_gridMDR = obj.MDR_GridToMDR("MDR_gridMDR");
	
	obj.MDR_txtRegNo = Common_TextField("MDR_txtRegNo","登记号");
	obj.MDR_txtPatName = Common_TextField("MDR_txtPatName","姓名");
	obj.MDR_txtPatSex = Common_TextField("MDR_txtPatSex","性别");
	obj.MDR_txtPatAge = Common_TextField("MDR_txtPatAge","年龄");
	
	obj.MDR_txtAdmDate = Common_TextField("MDR_txtAdmDate","入院日期");
	obj.MDR_txtAdmLoc = Common_TextField("MDR_txtAdmLoc","当前科室");
	obj.MDR_txtAdmWard = Common_TextField("MDR_txtAdmWard","当前病区");
	obj.MDR_txtAdmBed = Common_TextField("MDR_txtAdmBed","床号");
	
	obj.MDR_txtTransLoc = Common_TextField("MDR_txtTransLoc","转入科室");
	obj.MDR_txtTransInDate = Common_TextField("MDR_txtTransInDate","入科日期");
	obj.MDR_txtTransOutDate = Common_TextField("MDR_txtTransOutDate","出科日期");
	obj.MDR_txtTransFormLoc = Common_TextField("MDR_txtTransFormLoc","入科来源");
	obj.MDR_txtTransToLoc = Common_TextField("MDR_txtTransToLoc","出科去向");
	
	obj.MDR_txtRegNo.setDisabled(true);
	obj.MDR_txtPatName.setDisabled(true);
	obj.MDR_txtPatSex.setDisabled(true);
	obj.MDR_txtPatAge.setDisabled(true);
	
	obj.MDR_txtAdmDate.setDisabled(true);
	obj.MDR_txtAdmLoc.setDisabled(true);
	obj.MDR_txtAdmWard.setDisabled(true);
	obj.MDR_txtAdmBed.setDisabled(true);
	
	obj.MDR_txtTransLoc.setDisabled(true);
	obj.MDR_txtTransInDate.setDisabled(true);
	obj.MDR_txtTransOutDate.setDisabled(true);
	obj.MDR_txtTransFormLoc.setDisabled(true);
	obj.MDR_txtTransToLoc.setDisabled(true);
	
	//基本信息
	obj.MDR_FormToPAT = function()
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
							items : [obj.MDR_txtRegNo]
						},{
							columnWidth:.25,
							layout : 'form',
							labelAlign : 'right',
							labelWidth : 60,
							items : [obj.MDR_txtPatName]
						},{
							columnWidth:.25,
							layout : 'form',
							labelAlign : 'right',
							labelWidth : 60,
							items : [obj.MDR_txtPatSex]
						},{
							columnWidth:.25,
							layout : 'form',
							labelAlign : 'right',
							labelWidth : 60,
							items : [obj.MDR_txtPatAge]
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
							items : [obj.MDR_txtAdmDate]
						},{
							columnWidth:.25,
							layout : 'form',
							labelAlign : 'right',
							labelWidth : 60,
							items : [obj.MDR_txtAdmLoc]
						},{
							columnWidth:.25,
							layout : 'form',
							labelAlign : 'right',
							labelWidth : 60,
							items : [obj.MDR_txtAdmWard]
						},{
							columnWidth:.25,
							layout : 'form',
							labelAlign : 'right',
							labelWidth : 60,
							items : [obj.MDR_txtAdmBed]
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
							items : [obj.MDR_txtTransLoc]
						},{
							columnWidth:.25,
							layout : 'form',
							labelAlign : 'right',
							labelWidth : 60,
							items : [obj.MDR_txtTransInDate]
						},{
							columnWidth:.25,
							layout : 'form',
							labelAlign : 'right',
							labelWidth : 60,
							items : [obj.MDR_txtTransOutDate]
						},{
							columnWidth:.25,
							layout : 'form',
							labelAlign : 'right',
							labelWidth : 60,
							items : [obj.MDR_txtTransToLoc]
						}
					]
				}
			]
		}
		
		return tmpFormPanel;
	}
	
	//基本信息
	obj.MDR_formPAT = obj.MDR_FormToPAT("MDR_formPAT");
	
	//初始化页面
	obj.MDR_FormPatDataSet = function()
	{
		var objPaadm = obj.ClsBasePatientAdm.GetObjById(obj.CurrReport.ChildMDR.EpisodeID);
		if (objPaadm) {
			var PatientID = objPaadm.PatientID;
			var objPatient = obj.ClsBasePatient.GetObjById(PatientID);
			if (objPatient) {
				Common_SetValue('MDR_txtRegNo',objPatient.PapmiNo);
				Common_SetValue('MDR_txtPatName',objPatient.PatientName);
				Common_SetValue('MDR_txtPatSex',objPatient.Sex);
				var Age = objPatient.Age;
				var Month = objPatient.AgeMonth;
				var Day = objPatient.AgeDay;
				if (!Age) Age=0;
				if (!Month) Month=0;
				if (!Day) Day=0;
				if (parseInt(Age) > 0) {
					Common_SetValue('MDR_txtPatAge',parseInt(Age) + '岁');
				} else {
					Common_SetValue('MDR_txtPatAge',parseInt(Month) + '月' + parseInt(Day) + '天');
				}
			}
			Common_SetValue('MDR_txtAdmDate',objPaadm.AdmitDate + ' ' + objPaadm.AdmitTime);
			Common_SetValue('MDR_txtAdmLoc',objPaadm.Department);
			Common_SetValue('MDR_txtAdmWard',objPaadm.Ward);
			Common_SetValue('MDR_txtAdmBed',objPaadm.Bed + "床");
		}
		
		var strTransLoc = obj.ClsCommonClsSrv.GetAdmTrans(obj.CurrReport.ChildMDR.TransID,obj.CurrReport.ChildMDR.TransLoc);
		var arrTransLoc = strTransLoc.split(CHR_1);
		if (arrTransLoc.length>=10)
		{
			Common_SetValue('MDR_txtTransInDate',arrTransLoc[6] + ' ' + arrTransLoc[7]);
			Common_SetValue('MDR_txtTransOutDate',arrTransLoc[8] + ' ' + arrTransLoc[9]);
			Common_SetValue('MDR_txtTransLoc',arrTransLoc[1]);
			Common_SetValue('MDR_txtTransFormLoc',arrTransLoc[3]);
			Common_SetValue('MDR_txtTransToLoc',arrTransLoc[5]);
		}
	}
	
	obj.MDR_ViewPort = {
		layout : 'border',
		title : '多重耐药',
		items : [
			{
				layout : 'fit',
				region : 'north',
				height : 100,
				frame : true,
				items : [obj.MDR_formPAT]
			},{
				layout : 'fit',
				region: 'center',
				frame : true,
				items : [obj.MDR_gridMDR]
			}
		]
	}
	
	obj.MDR_InitView = function(){
		var objGrid = Ext.getCmp("MDR_gridMDR");
		if (objGrid){
			objGrid.getStore().load({});
			objGrid.on('rowdblclick',function(){
				var rowIndex = arguments[1];
				var objRec = this.getStore().getAt(rowIndex);
				obj.MDR_GridRowEditer(objRec);
			},objGrid);
		}
		obj.MDR_FormPatDataSet();
	}
	
	return obj;
}