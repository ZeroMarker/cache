
function InitNVNT(obj)
{
	obj.NVNT_valSubID = '';
	
	//�ù�ʱ��
	obj.NVNT_txtIntubateDateTime = Common_DateFieldToDateTime("NVNT_txtIntubateDateTime","�ù�ʱ��");
	
	//�ι�ʱ��
	obj.NVNT_txtExtubateDateTime = Common_DateFieldToDateTime("NVNT_txtExtubateDateTime","�ι�ʱ��");
	
	//��������
	obj.NVNT_txtBornWeight = Common_NumberField("NVNT_txtBornWeight","��������(gm)");
	
	//�Ƿ��Ⱦ
	obj.NVNT_chkIsInf = Common_Checkbox("NVNT_chkIsInf","�Ƿ��Ⱦ");
	obj.NVNT_chkIsInf.on('check',function(checkbox,value){
		var objItem1 = Ext.getCmp("NVNT_txtInfDate");
		if (objItem1) {
			objItem1.setDisabled((!value));
		}
		var objItem1 = Ext.getCmp("NVNT_cboInfPy");
		if (objItem1) {
			objItem1.setDisabled((!value));
		}
		if (!value) {
			Common_SetValue('NVNT_txtInfDate','');
			Common_SetValue('NVNT_cboInfPy','','');
		}
	},obj.NVNT_chkIsInf);
	
	//��Ⱦ����
	obj.NVNT_txtInfDate = Common_DateFieldToDate("NVNT_txtInfDate","��Ⱦ����");
	
	//��ԭ��
	obj.NVNT_cboInfPy = Common_ComboToPathogeny("NVNT_cboInfPy","��ԭ��");
	
	obj.NVNT_GridRowViewPort = {
		layout : 'form',
		labelAlign : 'right',
		labelWidth : 90,
		frame : true,
		items : [
			obj.NVNT_txtBornWeight
			,obj.NVNT_txtIntubateDateTime
			,obj.NVNT_txtExtubateDateTime
			,obj.NVNT_chkIsInf
			,obj.NVNT_txtInfDate
			,obj.NVNT_cboInfPy
		]
	}
	
	obj.NVNT_GridRowDataCheck = function()
	{
		var errInfo = '';
		
		var StatusCode = arguments[0];
		var objRec = arguments[1];
		if (objRec)
		{
			if (StatusCode == '2') {
				var NVNT_txtIntubateDateTime = objRec.get('IntubateDateTime');
				if (NVNT_txtIntubateDateTime=='') {
					errInfo = errInfo + '�ù�ʱ��δ��!';
				}
				var NVNT_txtExtubateDateTime = objRec.get('ExtubateDateTime');
				if (NVNT_txtExtubateDateTime=='') {
					errInfo = errInfo + '�ι�ʱ��δ��!';
				}
			}
		} else {
			if ((StatusCode == '1')||(StatusCode == '2')) {
				var NVNT_txtBornWeight = Common_GetValue('NVNT_txtBornWeight');
				if (NVNT_txtBornWeight=='') {
					errInfo = errInfo + '��������δ��!';
				}
				var NVNT_txtIntubateDateTime = Common_GetValue('NVNT_txtIntubateDateTime');
				if (NVNT_txtIntubateDateTime=='') {
					errInfo = errInfo + '�ù�ʱ��δ��!';
				}
			}
			if (StatusCode == '2') {
				var NVNT_txtExtubateDateTime = Common_GetValue('NVNT_txtExtubateDateTime');
				if (NVNT_txtExtubateDateTime=='') {
					errInfo = errInfo + '�ι�ʱ��δ��!';
				}
			}
		}
		
		return errInfo;
	}
	
	obj.NVNT_GridRowDataUpdateStatus = function()
	{
		var StatusCode = arguments[0];
		var objRec = arguments[1];
		if (objRec) {
			var inputStr = objRec.get('RepID') + "||" + objRec.get('SubID');
		} else {
			var inputStr = obj.CurrReport.ChildNICU.RowID + "||" + obj.NVNT_valSubID;
		}
		inputStr = inputStr + CHR_1 + session['LOGON.CTLOCID'];
		inputStr = inputStr + CHR_1 + session['LOGON.USERID'];
		inputStr = inputStr + CHR_1 + StatusCode;
		
		var flg = obj.ClsAimReportNVNTSrv.UpdateStatus(inputStr, CHR_1);
		if (parseInt(flg) <= 0) {
			return false;
		} else {
			return true;
		}
		return true;
	}
	
	obj.NVNT_GridRowDataSave = function()
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
		inputStr = inputStr + CHR_1 + Common_GetValue('NVNT_txtBornWeight');
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
		inputStr = inputStr + CHR_1 + obj.NVNT_valSubID;
		inputStr = inputStr + CHR_1 + Common_GetValue('NVNT_txtIntubateDateTime');
		inputStr = inputStr + CHR_1 + Common_GetValue('NVNT_txtExtubateDateTime');
		inputStr = inputStr + CHR_1 + Common_GetValue('NVNT_txtInfDate');
		inputStr = inputStr + CHR_1 + Common_GetValue('NVNT_cboInfPy') + CHR_3 + Common_GetText('NVNT_cboInfPy');
		inputStr = inputStr + CHR_1 + session['LOGON.CTLOCID'];
		inputStr = inputStr + CHR_1 + session['LOGON.USERID'];
		inputStr = inputStr + CHR_1 + StatusCode;
		
		var flg = obj.ClsAimReportNVNTSrv.SaveReport(inputStr, CHR_1);
		if (parseInt(flg)<=0) {
			return false;
		} else {
			return true;
		}
		return true;
	}
	
	obj.NVNT_GridRowDataSet = function(objRec)
	{
		if (objRec)
		{
			obj.NVNT_valSubID = objRec.get('SubID');
			Common_SetValue('NVNT_txtBornWeight',obj.CurrReport.ChildNICU.BornWeight);
			Common_SetValue('NVNT_txtIntubateDateTime',objRec.get('IntubateDateTime'));
			Common_SetValue('NVNT_txtExtubateDateTime',objRec.get('ExtubateDateTime'));
			
			//�Ƿ��Ⱦ����Ⱦ���ڡ���ԭ��
			Common_SetValue('NVNT_chkIsInf',(objRec.get('IsInfection')=='��'));
			Common_SetValue('NVNT_txtInfDate',objRec.get('InfDate'));
			var strInfPyValues = objRec.get('InfPyValues');
			var arrInfPyValues = strInfPyValues.split(CHR_1);
			if (arrInfPyValues.length > 0) {
				var strInfPyValue = arrInfPyValues[0];
				var arrInfPyValue = strInfPyValue.split("`");
				if (arrInfPyValue.length >= 2) {
					Common_SetValue('NVNT_cboInfPy',arrInfPyValue[0],arrInfPyValue[1]);
				}
			} else {
				Common_SetValue('NVNT_cboInfPy','','');
			}
			var objItem1 = Ext.getCmp("NVNT_txtInfDate");
			if (objItem1) {
				objItem1.setDisabled((objRec.get('IsInfection')!='��'));
			}
			var objItem1 = Ext.getCmp("NVNT_cboInfPy");
			if (objItem1) {
				objItem1.setDisabled((objRec.get('IsInfection')!='��'));
			}
		} else {
			obj.NVNT_valSubID = '';
			Common_SetValue('NVNT_txtBornWeight',obj.CurrReport.ChildNICU.BornWeight);
			Common_SetValue('NVNT_txtIntubateDateTime','');
			Common_SetValue('NVNT_txtExtubateDateTime','');
			Common_SetValue('NVNT_chkIsInf','');
			Common_SetValue('NVNT_txtInfDate','');
			Common_SetValue('NVNT_cboInfPy','','');
			var objItem1 = Ext.getCmp("NVNT_txtInfDate");
			if (objItem1) {
				objItem1.setDisabled(true);
			}
			var objItem1 = Ext.getCmp("NVNT_cboInfPy");
			if (objItem1) {
				objItem1.setDisabled(true);
			}
		}
	}
	
	obj.NVNT_GridRowEditer = function(objRec)
	{
		var winGridRowEditer = Ext.getCmp('NVNT_GridRowEditer');
		if (!winGridRowEditer)
		{
			winGridRowEditer = new Ext.Window({
				id : 'NVNT_GridRowEditer',
				height : 270,
				closeAction: 'hide',
				width : 300,
				modal : true,
				title : 'NICU-���ܲ�� �༭',
				layout : 'fit',
				frame : true,
				items: [
					obj.NVNT_GridRowViewPort
				],
				bbar : [
					'->',
					new Ext.Toolbar.Button({
						id: "NVNT_GridRowEditer_btnUpdate",
						width : 80,
						text : "<img SRC='../scripts/dhcmed/img/update.gif'>����",
						listeners : {
							'click' : function(){
								var errInfo = obj.NVNT_GridRowDataCheck("1");
								if (errInfo)
								{
									ExtTool.alert("��ʾ",errInfo);
								} else {
									var flg = obj.NVNT_GridRowDataSave("1")
									if (flg)
									{
										winGridRowEditer.hide();
										var objGrid = Ext.getCmp('NVNT_gridNVNT');
										if (objGrid) {
											objGrid.getStore().load();
										}
									} else {
										ExtTool.alert("��ʾ","�������ݴ���!Error=" + flg);
									}
								}
							}
						}
					}),
					new Ext.Toolbar.Button({
						id: "NVNT_GridRowEditer_btnCommit",
						width : 80,
						text : "<img SRC='../scripts/dhcmed/img/update.png'>�ύ",
						listeners : {
							'click' : function(){
								var errInfo = obj.NVNT_GridRowDataCheck("2");
								if (errInfo) {
									ExtTool.alert("��ʾ",errInfo);
								} else {
									var flg = obj.NVNT_GridRowDataSave("2")
									if (flg) {
										winGridRowEditer.hide();
										var objGrid = Ext.getCmp('NVNT_gridNVNT');
										if (objGrid) {
											objGrid.getStore().load();
										}
									} else {
										ExtTool.alert("��ʾ","�ύ���ݴ���!Error=" + flg);
									}
								}
							}
						}
					}),
					new Ext.Toolbar.Button({
						id: "NVNT_GridRowEditer_btnCancel",
						width : 80,
						text : "<img SRC='../scripts/dhcmed/img/cancel.png'>�ر�",
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
		obj.NVNT_GridRowDataSet(objRec);
	}
	
	//NICU-������
	obj.NVNT_GridToNVNT = function()
	{
		var tmpGridPanel = new Ext.grid.GridPanel({
			id: arguments[0],
			store : new Ext.data.Store({
				proxy: new Ext.data.HttpProxy({
					url : ExtToolSetting.RunQueryPageURL,
					listeners : {
						'beforeload' :  function(objProxy, param){
							param.ClassName = 'DHCMed.NINFService.Rep.AimReportNVNT';
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
				{header: '����<br>״̬', width: 50, dataIndex: 'RepStatusDesc', sortable: false, menuDisabled:true, align:'center' }
				,{header: '�ù�ʱ��', width: 100, dataIndex: 'IntubateDateTime', sortable: false, menuDisabled:true, align:'center' }
				,{header: '�ι�ʱ��', width: 100, dataIndex: 'ExtubateDateTime', sortable: false, menuDisabled:true, align:'center' }
				,{header: '�Ƿ�<br>��Ⱦ', width: 50, dataIndex: 'IsInfection', sortable: false, menuDisabled:true, align:'center' }
				,{header: '��Ⱦ����', width: 80, dataIndex: 'InfDate', sortable: false, menuDisabled:true, align:'center' }
				,{header: '��ԭ��', width: 100, dataIndex: 'InfPyDescs', sortable: false, menuDisabled:true, align:'center' }
				,{header: '�ʱ��', width: 100, dataIndex: 'RepDateTime', sortable: false, menuDisabled:true, align:'center' }
				,{header: '�����', width: 100, dataIndex: 'RepLocDesc', sortable: false, menuDisabled:true, align:'center' }
				,{header: '���', width: 60, dataIndex: 'RepUserDesc', sortable: false, menuDisabled:true, align:'center' }
			],
			bbar : [
				new Ext.Toolbar.Button({
					id: arguments[0] + "_btnAdd",
					width : 80,
					text : "<img SRC='../scripts/dhcmed/img/add.png'>����",
					listeners : {
						'click' : function(){
							obj.NVNT_GridRowEditer("");
						}
					}
				}),
				new Ext.Toolbar.Button({
					id: arguments[0] + "_btnDelete",
					width : 80,
					text : "<img SRC='../scripts/dhcmed/img/delete.gif'>ɾ��",
					listeners : {
						'click' : function(){
							var objGrid = Ext.getCmp("NVNT_gridNVNT");
							if (objGrid){
								var objRecArr = objGrid.getSelectionModel().getSelections();
								if (objRecArr.length>0){
									Ext.MessageBox.confirm('ɾ��', '�Ƿ�ɾ��ѡ�����ݼ�¼?', function(btn,text){
										if(btn=="yes"){
											for (var indRec = 0; indRec < objRecArr.length; indRec++){
												var objRec = objRecArr[indRec];
												var flg = obj.NVNT_GridRowDataUpdateStatus('0',objRec);
											}
											objGrid.getStore().load({});
										}
									});
								} else {
									ExtTool.alert("��ʾ","��ѡ�����ݼ�¼,�ٵ��ɾ��!");
								}
							}
						}
					}
				}),
				new Ext.Toolbar.Button({
					id: arguments[0] + "_btnCommit",
					width : 80,
					text : "<img SRC='../scripts/dhcmed/img/update.png'>�ύ",
					listeners : {
						'click' : function(){
							var objGrid = Ext.getCmp("NVNT_gridNVNT");
							if (objGrid){
								var objRecArr = objGrid.getSelectionModel().getSelections();
								if (objRecArr.length>0){
									for (var indRec = 0; indRec < objRecArr.length; indRec++){
										var objRec = objRecArr[indRec];
										var flg = obj.NVNT_GridRowDataCheck('2',objRec);
										if (flg) {
											ExtTool.alert("��ʾ","������Ϣ������,�������ύ!" + flg);
											continue;
										}
										var flg = obj.NVNT_GridRowDataUpdateStatus('2',objRec);
									}
									objGrid.getStore().load({});
								} else {
									ExtTool.alert("��ʾ","��ѡ�����ݼ�¼,�ٵ���ύ!");
								}
							}
						}
					}
				}),
				'->',
				'��'
				/*
				new Ext.Toolbar.Button({
					id: arguments[0] + "_btnUpdate",
					width : 80,
					text : "<img SRC='../scripts/dhcmed/img/update.gif'>��ȡ����"
				})
				*/
			],
			viewConfig : {
				//forceFit : true
			}
		});
		
		return tmpGridPanel;
	}
	
	//NICU-������
	obj.NVNT_gridNVNT = obj.NVNT_GridToNVNT("NVNT_gridNVNT");
	
	obj.NVNT_txtRegNo = Common_TextField("NVNT_txtRegNo","�ǼǺ�");
	obj.NVNT_txtPatName = Common_TextField("NVNT_txtPatName","����");
	obj.NVNT_txtPatSex = Common_TextField("NVNT_txtPatSex","�Ա�");
	obj.NVNT_txtPatAge = Common_TextField("NVNT_txtPatAge","����");
	
	obj.NVNT_txtAdmDate = Common_TextField("NVNT_txtAdmDate","��Ժ����");
	obj.NVNT_txtAdmLoc = Common_TextField("NVNT_txtAdmLoc","��ǰ����");
	obj.NVNT_txtAdmWard = Common_TextField("NVNT_txtAdmWard","��ǰ����");
	obj.NVNT_txtAdmBed = Common_TextField("NVNT_txtAdmBed","����");
	
	obj.NVNT_txtTransLoc = Common_TextField("NVNT_txtTransLoc","ת�����");
	obj.NVNT_txtTransInDate = Common_TextField("NVNT_txtTransInDate","�������");
	obj.NVNT_txtTransOutDate = Common_TextField("NVNT_txtTransOutDate","��������");
	obj.NVNT_txtTransFormLoc = Common_TextField("NVNT_txtTransFormLoc","�����Դ");
	obj.NVNT_txtTransToLoc = Common_TextField("NVNT_txtTransToLoc","����ȥ��");
	
	obj.NVNT_txtRegNo.setDisabled(true);
	obj.NVNT_txtPatName.setDisabled(true);
	obj.NVNT_txtPatSex.setDisabled(true);
	obj.NVNT_txtPatAge.setDisabled(true);
	
	obj.NVNT_txtAdmDate.setDisabled(true);
	obj.NVNT_txtAdmLoc.setDisabled(true);
	obj.NVNT_txtAdmWard.setDisabled(true);
	obj.NVNT_txtAdmBed.setDisabled(true);
	
	obj.NVNT_txtTransLoc.setDisabled(true);
	obj.NVNT_txtTransInDate.setDisabled(true);
	obj.NVNT_txtTransOutDate.setDisabled(true);
	obj.NVNT_txtTransFormLoc.setDisabled(true);
	obj.NVNT_txtTransToLoc.setDisabled(true);
	
	//������Ϣ
	obj.NVNT_FormToPAT = function()
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
							items : [obj.NVNT_txtRegNo]
						},{
							columnWidth:.25,
							layout : 'form',
							labelAlign : 'right',
							labelWidth : 60,
							items : [obj.NVNT_txtPatName]
						},{
							columnWidth:.25,
							layout : 'form',
							labelAlign : 'right',
							labelWidth : 60,
							items : [obj.NVNT_txtPatSex]
						},{
							columnWidth:.25,
							layout : 'form',
							labelAlign : 'right',
							labelWidth : 60,
							items : [obj.NVNT_txtPatAge]
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
							items : [obj.NVNT_txtAdmDate]
						},{
							columnWidth:.25,
							layout : 'form',
							labelAlign : 'right',
							labelWidth : 60,
							items : [obj.NVNT_txtAdmLoc]
						},{
							columnWidth:.25,
							layout : 'form',
							labelAlign : 'right',
							labelWidth : 60,
							items : [obj.NVNT_txtAdmWard]
						},{
							columnWidth:.25,
							layout : 'form',
							labelAlign : 'right',
							labelWidth : 60,
							items : [obj.NVNT_txtAdmBed]
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
							items : [obj.NVNT_txtTransLoc]
						},{
							columnWidth:.25,
							layout : 'form',
							labelAlign : 'right',
							labelWidth : 60,
							items : [obj.NVNT_txtTransInDate]
						},{
							columnWidth:.25,
							layout : 'form',
							labelAlign : 'right',
							labelWidth : 60,
							items : [obj.NVNT_txtTransOutDate]
						},{
							columnWidth:.25,
							layout : 'form',
							labelAlign : 'right',
							labelWidth : 60,
							items : [obj.NVNT_txtTransToLoc]
						}
					]
				}
			]
		}
		
		return tmpFormPanel;
	}
	
	//������Ϣ
	obj.NVNT_formPAT = obj.NVNT_FormToPAT("NVNT_formPAT");
	
	//��ʼ��ҳ��
	obj.NVNT_FormPatDataSet = function()
	{
		var objPaadm = obj.ClsBasePatientAdm.GetObjById(obj.CurrReport.ChildNICU.EpisodeID);
		if (objPaadm) {
			var PatientID = objPaadm.PatientID;
			var objPatient = obj.ClsBasePatient.GetObjById(PatientID);
			if (objPatient) {
				Common_SetValue('NVNT_txtRegNo',objPatient.PapmiNo);
				Common_SetValue('NVNT_txtPatName',objPatient.PatientName);
				Common_SetValue('NVNT_txtPatSex',objPatient.Sex);
				var Age = objPatient.Age;
				var Month = objPatient.AgeMonth;
				var Day = objPatient.AgeDay;
				if (!Age) Age=0;
				if (!Month) Month=0;
				if (!Day) Day=0;
				if (parseInt(Age) > 0) {
					Common_SetValue('NVNT_txtPatAge',parseInt(Age) + '��');
				} else {
					Common_SetValue('NVNT_txtPatAge',parseInt(Month) + '��' + parseInt(Day) + '��');
				}
			}
			Common_SetValue('NVNT_txtAdmDate',objPaadm.AdmitDate + ' ' + objPaadm.AdmitTime);
			Common_SetValue('NVNT_txtAdmLoc',objPaadm.Department);
			Common_SetValue('NVNT_txtAdmWard',objPaadm.Ward);
			Common_SetValue('NVNT_txtAdmBed',objPaadm.Bed + "��");
		}
		
		var strTransLoc = obj.ClsCommonClsSrv.GetAdmTrans(obj.CurrReport.ChildNICU.TransID,obj.CurrReport.ChildNICU.TransLoc);
		var arrTransLoc = strTransLoc.split(CHR_1);
		if (arrTransLoc.length>=10)
		{
			Common_SetValue('NVNT_txtTransInDate',arrTransLoc[6] + ' ' + arrTransLoc[7]);
			Common_SetValue('NVNT_txtTransOutDate',arrTransLoc[8] + ' ' + arrTransLoc[9]);
			Common_SetValue('NVNT_txtTransLoc',arrTransLoc[1]);
			Common_SetValue('NVNT_txtTransFormLoc',arrTransLoc[3]);
			Common_SetValue('NVNT_txtTransToLoc',arrTransLoc[5]);
		}
	}
	
	obj.NVNT_ViewPort = {
		layout : 'border',
		title : 'NICU-���ܲ��',
		items : [
			{
				layout : 'fit',
				region : 'north',
				height : 100,
				frame : true,
				items : [obj.NVNT_formPAT]
			},{
				layout : 'fit',
				region: 'center',
				frame : true,
				items : [obj.NVNT_gridNVNT]
			}
		]
	}
	
	obj.NVNT_InitView = function(){
		var objGrid = Ext.getCmp("NVNT_gridNVNT");
		if (objGrid){
			objGrid.getStore().load({});
			objGrid.on('rowdblclick',function(){
				var rowIndex = arguments[1];
				var objRec = this.getStore().getAt(rowIndex);
				obj.NVNT_GridRowEditer(objRec);
			},objGrid);
		}
		obj.NVNT_FormPatDataSet();
	}
	return obj;
}