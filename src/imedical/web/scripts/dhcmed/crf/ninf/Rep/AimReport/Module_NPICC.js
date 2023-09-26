
function InitNPICC(obj)
{
	obj.NPICC_valSubID = '';
	
	//置管时间
	obj.NPICC_txtIntubateDateTime = Common_DateFieldToDateTime("NPICC_txtIntubateDateTime","置管时间");
	
	//拔管时间
	obj.NPICC_txtExtubateDateTime = Common_DateFieldToDateTime("NPICC_txtExtubateDateTime","拔管时间");
	
	//出生体重
	obj.NPICC_txtBornWeight = Common_NumberField("NPICC_txtBornWeight","出生体重(gm)");
	
	//是否感染
	obj.NPICC_chkIsInf = Common_Checkbox("NPICC_chkIsInf","是否感染");
	obj.NPICC_chkIsInf.on('check',function(checkbox,value){
		var objItem1 = Ext.getCmp("NPICC_txtInfDate");
		if (objItem1) {
			objItem1.setDisabled((!value));
		}
		var objItem1 = Ext.getCmp("NPICC_cboInfPy");
		if (objItem1) {
			objItem1.setDisabled((!value));
		}
		if (!value) {
			Common_SetValue('NPICC_txtInfDate','');
			Common_SetValue('NPICC_cboInfPy','','');
		}
	},obj.NPICC_chkIsInf);
	
	//感染日期
	obj.NPICC_txtInfDate = Common_DateFieldToDate("NPICC_txtInfDate","感染日期");
	
	//病原体
	obj.NPICC_cboInfPy = Common_ComboToPathogeny("NPICC_cboInfPy","病原体");
	
	obj.NPICC_GridRowViewPort = {
		layout : 'form',
		labelAlign : 'right',
		labelWidth : 90,
		frame : true,
		items : [
			obj.NPICC_txtBornWeight
			,obj.NPICC_txtIntubateDateTime
			,obj.NPICC_txtExtubateDateTime
			,obj.NPICC_chkIsInf
			,obj.NPICC_txtInfDate
			,obj.NPICC_cboInfPy
		]
	}
	
	obj.NPICC_GridRowDataCheck = function()
	{
		var errInfo = '';
		
		var StatusCode = arguments[0];
		var objRec = arguments[1];
		if (objRec)
		{
			if (StatusCode == '2') {
				var NPICC_txtIntubateDateTime = objRec.get('IntubateDateTime');
				if (NPICC_txtIntubateDateTime=='') {
					errInfo = errInfo + '置管时间未填!';
				}
				var NPICC_txtIntubateDateTime = objRec.get('ExtubateDateTime');
				if (NPICC_txtIntubateDateTime=='') {
					errInfo = errInfo + '拔管时间未填!';
				}
			}
		} else {
			if ((StatusCode == '1')||(StatusCode == '2')) {
				var NPICC_txtBornWeight = Common_GetValue('NPICC_txtBornWeight');
				if (NPICC_txtBornWeight=='') {
					errInfo = errInfo + '出生体重未填!';
				}
				var NPICC_txtIntubateDateTime = Common_GetValue('NPICC_txtIntubateDateTime');
				if (NPICC_txtIntubateDateTime=='') {
					errInfo = errInfo + '置管时间未填!';
				}
			}
			if (StatusCode == '2') {
				var NPICC_txtIntubateDateTime = Common_GetValue('NPICC_txtExtubateDateTime');
				if (NPICC_txtIntubateDateTime=='') {
					errInfo = errInfo + '拔管时间未填!';
				}
			}
		}
		
		return errInfo;
	}
	
	obj.NPICC_GridRowDataUpdateStatus = function()
	{
		var StatusCode = arguments[0];
		var objRec = arguments[1];
		if (objRec) {
			var inputStr = objRec.get('RepID') + "||" + objRec.get('SubID');
		} else {
			var inputStr = obj.CurrReport.ChildNICU.RowID + "||" + obj.NPICC_valSubID;
		}
		inputStr = inputStr + CHR_1 + session['LOGON.CTLOCID'];
		inputStr = inputStr + CHR_1 + session['LOGON.USERID'];
		inputStr = inputStr + CHR_1 + StatusCode;
		
		var flg = obj.ClsAimReportNPICCSrv.UpdateStatus(inputStr, CHR_1);
		if (parseInt(flg) <= 0) {
			return false;
		} else {
			return true;
		}
		return true;
	}
	
	obj.NPICC_GridRowDataSave = function()
	{
		var inputStr = obj.CurrReport.ChildNICU.RowID;
		inputStr = inputStr + CHR_1 + obj.CurrReport.ChildNICU.ReportTypeCode;
		inputStr = inputStr + CHR_1 + obj.CurrReport.ChildNICU.EpisodeID;
		inputStr = inputStr + CHR_1 + obj.CurrReport.ChildNICU.TransID;
		inputStr = inputStr + CHR_1 + obj.CurrReport.ChildNICU.TransLoc;
		inputStr = inputStr + CHR_1 + "";
		inputStr = inputStr + CHR_1 + "";
		inputStr = inputStr + CHR_1 + "";
		inputStr = inputStr + CHR_1 + "";
		inputStr = inputStr + CHR_1 + Common_GetValue('NPICC_txtBornWeight');
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
			obj.CurrReport.ChildNICU = objAimReport;
			if (typeof obj.NOTH_FormDataSet == 'function')
			{
				obj.NOTH_FormDataSet();
			}
		}
		if (obj.CurrReport.ChildNICU.RowID=='') return false;
		
		var StatusCode = arguments[0];
		
		var inputStr = obj.CurrReport.ChildNICU.RowID;
		inputStr = inputStr + CHR_1 + obj.NPICC_valSubID;
		inputStr = inputStr + CHR_1 + Common_GetValue('NPICC_txtIntubateDateTime');
		inputStr = inputStr + CHR_1 + Common_GetValue('NPICC_txtExtubateDateTime');
		inputStr = inputStr + CHR_1 + Common_GetValue('NPICC_txtInfDate');
		inputStr = inputStr + CHR_1 + Common_GetValue('NPICC_cboInfPy') + CHR_3 + Common_GetText('NPICC_cboInfPy');
		inputStr = inputStr + CHR_1 + session['LOGON.CTLOCID'];
		inputStr = inputStr + CHR_1 + session['LOGON.USERID'];
		inputStr = inputStr + CHR_1 + StatusCode;
		
		var flg = obj.ClsAimReportNPICCSrv.SaveReport(inputStr, CHR_1);
		if (parseInt(flg)<=0) {
			return false;
		} else {
			return true;
		}
		return true;
	}
	
	obj.NPICC_GridRowDataSet = function(objRec)
	{
		if (objRec)
		{
			obj.NPICC_valSubID = objRec.get('SubID');
			Common_SetValue('NPICC_txtBornWeight',obj.CurrReport.ChildNICU.BornWeight);
			Common_SetValue('NPICC_txtIntubateDateTime',objRec.get('IntubateDateTime'));
			Common_SetValue('NPICC_txtExtubateDateTime',objRec.get('ExtubateDateTime'));
			
			//是否感染,感染日期,病原体
			Common_SetValue('NPICC_chkIsInf',(objRec.get('IsInfection')=='是'));
			Common_SetValue('NPICC_txtInfDate',objRec.get('InfDate'));
			var strInfPyValues = objRec.get('InfPyValues');
			var arrInfPyValues = strInfPyValues.split(CHR_1);
			if (arrInfPyValues.length > 0) {
				var strInfPyValue = arrInfPyValues[0];
				var arrInfPyValue = strInfPyValue.split("`");
				if (arrInfPyValue.length >= 2) {
					Common_SetValue('NPICC_cboInfPy',arrInfPyValue[0],arrInfPyValue[1]);
				}
			} else {
				Common_SetValue('NPICC_cboInfPy','','');
			}
			
			var objItem1 = Ext.getCmp("NPICC_txtInfDate");
			if (objItem1) {
				objItem1.setDisabled((objRec.get('IsInfection')!='是'));
			}
			var objItem1 = Ext.getCmp("NPICC_cboInfPy");
			if (objItem1) {
				objItem1.setDisabled((objRec.get('IsInfection')!='是'));
			}
		} else {
			obj.NPICC_valSubID = '';
			Common_SetValue('NPICC_txtBornWeight',obj.CurrReport.ChildNICU.BornWeight);
			Common_SetValue('NPICC_txtIntubateDateTime','');
			Common_SetValue('NPICC_txtExtubateDateTime','');
			Common_SetValue('NPICC_chkIsInf','');
			Common_SetValue('NPICC_txtInfDate','');
			Common_SetValue('NPICC_cboInfPy','','');
			var objItem1 = Ext.getCmp("NPICC_txtInfDate");
			if (objItem1) {
				objItem1.setDisabled(true);
			}
			var objItem1 = Ext.getCmp("NPICC_cboInfPy");
			if (objItem1) {
				objItem1.setDisabled(true);
			}
		}
	}
	
	obj.NPICC_GridRowEditer = function(objRec)
	{
		var winGridRowEditer = Ext.getCmp('NPICC_GridRowEditer');
		if (!winGridRowEditer)
		{
			winGridRowEditer = new Ext.Window({
				id : 'NPICC_GridRowEditer',
				height : 270,
				closeAction: 'hide',
				width : 300,
				modal : true,
				title : 'NICU-PICC 编辑',
				layout : 'fit',
				frame : true,
				items: [
					obj.NPICC_GridRowViewPort
				],
				bbar : [
					'->',
					new Ext.Toolbar.Button({
						id: "NPICC_GridRowEditer_btnUpdate",
						width : 80,
						text : "<img SRC='../scripts/dhcmed/img/update.gif'>保存",
						listeners : {
							'click' : function(){
								var errInfo = obj.NPICC_GridRowDataCheck("1");
								if (errInfo)
								{
									ExtTool.alert("提示",errInfo);
								} else {
									var flg = obj.NPICC_GridRowDataSave("1")
									if (flg)
									{
										winGridRowEditer.hide();
										var objGrid = Ext.getCmp('NPICC_gridNPICC');
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
						id: "NPICC_GridRowEditer_btnCommit",
						width : 80,
						text : "<img SRC='../scripts/dhcmed/img/update.png'>提交",
						listeners : {
							'click' : function(){
								var errInfo = obj.NPICC_GridRowDataCheck("2");
								if (errInfo) {
									ExtTool.alert("提示",errInfo);
								} else {
									var flg = obj.NPICC_GridRowDataSave("2")
									if (flg) {
										winGridRowEditer.hide();
										var objGrid = Ext.getCmp('NPICC_gridNPICC');
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
						id: "NPICC_GridRowEditer_btnCancel",
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
		obj.NPICC_GridRowDataSet(objRec);
	}
	
	//NICU-PICC
	obj.NPICC_GridToNPICC = function()
	{
		var tmpGridPanel = new Ext.grid.GridPanel({
			id: arguments[0],
			store : new Ext.data.Store({
				proxy: new Ext.data.HttpProxy({
					url : ExtToolSetting.RunQueryPageURL,
					listeners : {
						'beforeload' :  function(objProxy, param){
							param.ClassName = 'DHCMed.NINFService.Rep.AimReportNPICC';
							param.QueryName = 'QryReportByID';
							param.Arg1      = obj.CurrReport.ChildNICU.RowID;
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
							obj.NPICC_GridRowEditer("");
						}
					}
				}),
				new Ext.Toolbar.Button({
					id: arguments[0] + "_btnDelete",
					width : 80,
					text : "<img SRC='../scripts/dhcmed/img/delete.gif'>删除",
					listeners : {
						'click' : function(){
							var objGrid = Ext.getCmp("NPICC_gridNPICC");
							if (objGrid){
								var objRecArr = objGrid.getSelectionModel().getSelections();
								if (objRecArr.length>0){
									Ext.MessageBox.confirm('删除', '是否删除选中数据记录?', function(btn,text){
										if(btn=="yes"){
											for (var indRec = 0; indRec < objRecArr.length; indRec++){
												var objRec = objRecArr[indRec];
												var flg = obj.NPICC_GridRowDataUpdateStatus('0',objRec);
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
							var objGrid = Ext.getCmp("NPICC_gridNPICC");
							if (objGrid){
								var objRecArr = objGrid.getSelectionModel().getSelections();
								if (objRecArr.length>0){
									for (var indRec = 0; indRec < objRecArr.length; indRec++){
										var objRec = objRecArr[indRec];
										var flg = obj.NPICC_GridRowDataCheck('2',objRec);
										if (flg) {
											ExtTool.alert("提示","数据信息不完整,不允许提交!" + flg);
											continue;
										}
										var flg = obj.NPICC_GridRowDataUpdateStatus('2',objRec);
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
	
	//NICU-PICC
	obj.NPICC_gridNPICC = obj.NPICC_GridToNPICC("NPICC_gridNPICC");
	
	obj.NPICC_txtRegNo = Common_TextField("NPICC_txtRegNo","登记号");
	obj.NPICC_txtPatName = Common_TextField("NPICC_txtPatName","姓名");
	obj.NPICC_txtPatSex = Common_TextField("NPICC_txtPatSex","性别");
	obj.NPICC_txtPatAge = Common_TextField("NPICC_txtPatAge","年龄");
	
	obj.NPICC_txtAdmDate = Common_TextField("NPICC_txtAdmDate","入院日期");
	obj.NPICC_txtAdmLoc = Common_TextField("NPICC_txtAdmLoc","当前科室");
	obj.NPICC_txtAdmWard = Common_TextField("NPICC_txtAdmWard","当前病区");
	obj.NPICC_txtAdmBed = Common_TextField("NPICC_txtAdmBed","床号");
	
	obj.NPICC_txtTransLoc = Common_TextField("NPICC_txtTransLoc","转入科室");
	obj.NPICC_txtTransInDate = Common_TextField("NPICC_txtTransInDate","入科日期");
	obj.NPICC_txtTransOutDate = Common_TextField("NPICC_txtTransOutDate","出科日期");
	obj.NPICC_txtTransFormLoc = Common_TextField("NPICC_txtTransFormLoc","入科来源");
	obj.NPICC_txtTransToLoc = Common_TextField("NPICC_txtTransToLoc","出科去向");
	
	obj.NPICC_txtRegNo.setDisabled(true);
	obj.NPICC_txtPatName.setDisabled(true);
	obj.NPICC_txtPatSex.setDisabled(true);
	obj.NPICC_txtPatAge.setDisabled(true);
	
	obj.NPICC_txtAdmDate.setDisabled(true);
	obj.NPICC_txtAdmLoc.setDisabled(true);
	obj.NPICC_txtAdmWard.setDisabled(true);
	obj.NPICC_txtAdmBed.setDisabled(true);
	
	obj.NPICC_txtTransLoc.setDisabled(true);
	obj.NPICC_txtTransInDate.setDisabled(true);
	obj.NPICC_txtTransOutDate.setDisabled(true);
	obj.NPICC_txtTransFormLoc.setDisabled(true);
	obj.NPICC_txtTransToLoc.setDisabled(true);
	
	obj.NPICC_txtTransToLoc.setDisabled(true);
	
	//基本信息
	obj.NPICC_FormToPAT = function()
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
							items : [obj.NPICC_txtRegNo]
						},{
							columnWidth:.25,
							layout : 'form',
							labelAlign : 'right',
							labelWidth : 60,
							items : [obj.NPICC_txtPatName]
						},{
							columnWidth:.25,
							layout : 'form',
							labelAlign : 'right',
							labelWidth : 60,
							items : [obj.NPICC_txtPatSex]
						},{
							columnWidth:.25,
							layout : 'form',
							labelAlign : 'right',
							labelWidth : 60,
							items : [obj.NPICC_txtPatAge]
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
							items : [obj.NPICC_txtAdmDate]
						},{
							columnWidth:.25,
							layout : 'form',
							labelAlign : 'right',
							labelWidth : 60,
							items : [obj.NPICC_txtAdmLoc]
						},{
							columnWidth:.25,
							layout : 'form',
							labelAlign : 'right',
							labelWidth : 60,
							items : [obj.NPICC_txtAdmWard]
						},{
							columnWidth:.25,
							layout : 'form',
							labelAlign : 'right',
							labelWidth : 60,
							items : [obj.NPICC_txtAdmBed]
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
							items : [obj.NPICC_txtTransLoc]
						},{
							columnWidth:.25,
							layout : 'form',
							labelAlign : 'right',
							labelWidth : 60,
							items : [obj.NPICC_txtTransInDate]
						},{
							columnWidth:.25,
							layout : 'form',
							labelAlign : 'right',
							labelWidth : 60,
							items : [obj.NPICC_txtTransOutDate]
						},{
							columnWidth:.25,
							layout : 'form',
							labelAlign : 'right',
							labelWidth : 60,
							items : [obj.NPICC_txtTransToLoc]
						}
					]
				}
			]
		}
		
		return tmpFormPanel;
	}
	
	//基本信息
	obj.NPICC_formPAT = obj.NPICC_FormToPAT("NPICC_formPAT");
	
	//初始化页面
	obj.NPICC_FormPatDataSet = function()
	{
		var objPaadm = obj.ClsBasePatientAdm.GetObjById(obj.CurrReport.ChildNICU.EpisodeID);
		if (objPaadm) {
			var PatientID = objPaadm.PatientID;
			var objPatient = obj.ClsBasePatient.GetObjById(PatientID);
			if (objPatient) {
				Common_SetValue('NPICC_txtRegNo',objPatient.PapmiNo);
				Common_SetValue('NPICC_txtPatName',objPatient.PatientName);
				Common_SetValue('NPICC_txtPatSex',objPatient.Sex);
				var Age = objPatient.Age;
				var Month = objPatient.AgeMonth;
				var Day = objPatient.AgeDay;
				if (!Age) Age=0;
				if (!Month) Month=0;
				if (!Day) Day=0;
				if (parseInt(Age) > 0) {
					Common_SetValue('NPICC_txtPatAge',parseInt(Age) + '岁');
				} else {
					Common_SetValue('NPICC_txtPatAge',parseInt(Month) + '月' + parseInt(Day) + '天');
				}
			}
			Common_SetValue('NPICC_txtAdmDate',objPaadm.AdmitDate + ' ' + objPaadm.AdmitTime);
			Common_SetValue('NPICC_txtAdmLoc',objPaadm.Department);
			Common_SetValue('NPICC_txtAdmWard',objPaadm.Ward);
			Common_SetValue('NPICC_txtAdmBed',objPaadm.Bed + "床");
		}
		
		var strTransLoc = obj.ClsCommonClsSrv.GetAdmTrans(obj.CurrReport.ChildNICU.TransID,obj.CurrReport.ChildNICU.TransLoc);
		var arrTransLoc = strTransLoc.split(CHR_1);
		if (arrTransLoc.length>=10)
		{
			Common_SetValue('NPICC_txtTransInDate',arrTransLoc[6] + ' ' + arrTransLoc[7]);
			Common_SetValue('NPICC_txtTransOutDate',arrTransLoc[8] + ' ' + arrTransLoc[9]);
			Common_SetValue('NPICC_txtTransLoc',arrTransLoc[1]);
			Common_SetValue('NPICC_txtTransFormLoc',arrTransLoc[3]);
			Common_SetValue('NPICC_txtTransToLoc',arrTransLoc[5]);
		}
	}
	
	obj.NPICC_ViewPort = {
		layout : 'border',
		title : 'NICU-PICC',
		items : [
			{
				layout : 'fit',
				region : 'north',
				height : 100,
				frame : true,
				items : [obj.NPICC_formPAT]
			},{
				layout : 'fit',
				region: 'center',
				frame : true,
				items : [obj.NPICC_gridNPICC]
			}
		]
	}
	
	obj.NPICC_InitView = function(){
		var objGrid = Ext.getCmp("NPICC_gridNPICC");
		if (objGrid){
			objGrid.getStore().load({});
			objGrid.on('rowdblclick',function(){
				var rowIndex = arguments[1];
				var objRec = this.getStore().getAt(rowIndex);
				obj.NPICC_GridRowEditer(objRec);
			},objGrid);
		}
		obj.NPICC_FormPatDataSet();
	}
	
	return obj;
}