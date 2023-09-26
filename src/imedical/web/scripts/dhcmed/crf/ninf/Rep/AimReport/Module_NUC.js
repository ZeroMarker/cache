
function InitNUC(obj)
{
	obj.NUC_valSubID = '';
	
	//�ù�ʱ��
	obj.NUC_txtIntubateDateTime = Common_DateFieldToDateTime("NUC_txtIntubateDateTime","�ù�ʱ��");
	
	//�ι�ʱ��
	obj.NUC_txtExtubateDateTime = Common_DateFieldToDateTime("NUC_txtExtubateDateTime","�ι�ʱ��");
	
	//��������
	obj.NUC_txtBornWeight = Common_NumberField("NUC_txtBornWeight","��������(gm)");
	
	//�Ƿ��Ⱦ
	obj.NUC_chkIsInf = Common_Checkbox("NUC_chkIsInf","�Ƿ��Ⱦ");
	obj.NUC_chkIsInf.on('check',function(checkbox,value){
		var objItem1 = Ext.getCmp("NUC_txtInfDate");
		if (objItem1) {
			objItem1.setDisabled((!value));
		}
		var objItem1 = Ext.getCmp("NUC_cboInfPy");
		if (objItem1) {
			objItem1.setDisabled((!value));
		}
		if (!value) {
			Common_SetValue('NUC_txtInfDate','');
			Common_SetValue('NUC_cboInfPy','','');
		}
	},obj.NUC_chkIsInf);
	
	//��Ⱦ����
	obj.NUC_txtInfDate = Common_DateFieldToDate("NUC_txtInfDate","��Ⱦ����");
	
	//��ԭ��
	obj.NUC_cboInfPy = Common_ComboToPathogeny("NUC_cboInfPy","��ԭ��");
	
	obj.NUC_GridRowViewPort = {
		layout : 'form',
		labelAlign : 'right',
		labelWidth : 90,
		frame : true,
		items : [
			obj.NUC_txtBornWeight
			,obj.NUC_txtIntubateDateTime
			,obj.NUC_txtExtubateDateTime
			,obj.NUC_chkIsInf
			,obj.NUC_txtInfDate
			,obj.NUC_cboInfPy
		]
	}
	
	obj.NUC_GridRowDataCheck = function() {
		var errInfo = '';
		
		var StatusCode = arguments[0];
		var objRec = arguments[1];
		if (objRec)
		{
			if (StatusCode == '2') {
				var NUC_txtIntubateDateTime = objRec.get('IntubateDateTime');
				if (NUC_txtIntubateDateTime=='') {
					errInfo = errInfo + '�ù�ʱ��δ��!';
				}
				var NUC_txtExtubateDateTime = objRec.get('ExtubateDateTime');
				if (NUC_txtExtubateDateTime=='') {
					errInfo = errInfo + '�ι�ʱ��δ��!';
				}
			}
		} else {
			if ((StatusCode == '1')||(StatusCode == '2')) {
				var NUC_txtBornWeight = Common_GetValue('NUC_txtBornWeight');
				if (NUC_txtBornWeight=='') {
					errInfo = errInfo + '��������δ��!';
				}
				var NUC_txtIntubateDateTime = Common_GetValue('NUC_txtIntubateDateTime');
				if (NUC_txtIntubateDateTime=='') {
					errInfo = errInfo + '�ù�ʱ��δ��!';
				}
			}
			if (StatusCode == '2') {
				var NUC_txtExtubateDateTime = Common_GetValue('NUC_txtExtubateDateTime');
				if (NUC_txtExtubateDateTime=='') {
					errInfo = errInfo + '�ι�ʱ��δ��!';
				}
			}
		}
		
		return errInfo;
	}
	
	obj.NUC_GridRowDataUpdateStatus = function() {
		var StatusCode = arguments[0];
		var objRec = arguments[1];
		if (objRec) {
			var inputStr = objRec.get('RepID') + "||" + objRec.get('SubID');
		} else {
			var inputStr = obj.CurrReport.ChildNICU.RowID + "||" + obj.NUC_valSubID;
		}
		inputStr = inputStr + CHR_1 + session['LOGON.CTLOCID'];
		inputStr = inputStr + CHR_1 + session['LOGON.USERID'];
		inputStr = inputStr + CHR_1 + StatusCode;
		
		var flg = obj.ClsAimReportNUCSrv.UpdateStatus(inputStr, CHR_1);
		if (parseInt(flg) <= 0) {
			return false;
		} else {
			return true;
		}
		return true;
	}
	
	obj.NUC_GridRowDataSave = function() {
		var inputStr = obj.CurrReport.ChildNICU.RowID;
		inputStr = inputStr + CHR_1 + obj.CurrReport.ChildNICU.ReportTypeCode;
		inputStr = inputStr + CHR_1 + obj.CurrReport.ChildNICU.EpisodeID;
		inputStr = inputStr + CHR_1 + obj.CurrReport.ChildNICU.TransID;
		inputStr = inputStr + CHR_1 + obj.CurrReport.ChildNICU.TransLoc;
		inputStr = inputStr + CHR_1 + "";
		inputStr = inputStr + CHR_1 + "";
		inputStr = inputStr + CHR_1 + "";
		inputStr = inputStr + CHR_1 + "";
		inputStr = inputStr + CHR_1 + Common_GetValue('NUC_txtBornWeight');
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
		inputStr = inputStr + CHR_1 + obj.NUC_valSubID;
		inputStr = inputStr + CHR_1 + Common_GetValue('NUC_txtIntubateDateTime');
		inputStr = inputStr + CHR_1 + Common_GetValue('NUC_txtExtubateDateTime');
		inputStr = inputStr + CHR_1 + Common_GetValue('NUC_txtInfDate');
		inputStr = inputStr + CHR_1 + Common_GetValue('NUC_cboInfPy') + CHR_3 + Common_GetText('NUC_cboInfPy');
		inputStr = inputStr + CHR_1 + session['LOGON.CTLOCID'];
		inputStr = inputStr + CHR_1 + session['LOGON.USERID'];
		inputStr = inputStr + CHR_1 + StatusCode;
		
		var flg = obj.ClsAimReportNUCSrv.SaveReport(inputStr, CHR_1);
		if (parseInt(flg)<=0) {
			return false;
		} else {
			return true;
		}
		return true;
	}
	
	obj.NUC_GridRowDataSet = function(objRec) {
		if (objRec)
		{
			obj.NUC_valSubID = objRec.get('SubID');
			Common_SetValue('NUC_txtBornWeight',obj.CurrReport.ChildNICU.BornWeight);
			Common_SetValue('NUC_txtIntubateDateTime',objRec.get('IntubateDateTime'));
			Common_SetValue('NUC_txtExtubateDateTime',objRec.get('ExtubateDateTime'));
			
			//�Ƿ��Ⱦ,��Ⱦ����,��ԭ��
			Common_SetValue('NUC_chkIsInf',(objRec.get('IsInfection')=='��'));
			Common_SetValue('NUC_txtInfDate',objRec.get('InfDate'));
			var strInfPyValues = objRec.get('InfPyValues');
			var arrInfPyValues = strInfPyValues.split(CHR_1);
			if (arrInfPyValues.length > 0) {
				var strInfPyValue = arrInfPyValues[0];
				var arrInfPyValue = strInfPyValue.split("`");
				if (arrInfPyValue.length >= 2) {
					Common_SetValue('NUC_cboInfPy',arrInfPyValue[0],arrInfPyValue[1]);
				}
			} else {
				Common_SetValue('NUC_cboInfPy','','');
			}
			var objItem1 = Ext.getCmp("NUC_txtInfDate");
			if (objItem1) {
				objItem1.setDisabled((objRec.get('IsInfection')!='��'));
			}
			var objItem1 = Ext.getCmp("NUC_cboInfPy");
			if (objItem1) {
				objItem1.setDisabled((objRec.get('IsInfection')!='��'));
			}
		} else {
			obj.NUC_valSubID = '';
			Common_SetValue('NUC_txtBornWeight',obj.CurrReport.ChildNICU.BornWeight);
			Common_SetValue('NUC_txtIntubateDateTime','');
			Common_SetValue('NUC_txtExtubateDateTime','');
			Common_SetValue('NUC_chkIsInf','');
			Common_SetValue('NUC_txtInfDate','');
			Common_SetValue('NUC_cboInfPy','','');
			var objItem1 = Ext.getCmp("NUC_txtInfDate");
			if (objItem1) {
				objItem1.setDisabled(true);
			}
			var objItem1 = Ext.getCmp("NUC_cboInfPy");
			if (objItem1) {
				objItem1.setDisabled(true);
			}
		}
	}
	
	obj.NUC_GridRowEditer = function(objRec) {
		var winGridRowEditer = Ext.getCmp('NUC_GridRowEditer');
		if (!winGridRowEditer)
		{
			winGridRowEditer = new Ext.Window({
				id : 'NUC_GridRowEditer',
				height : 270,
				closeAction: 'hide',
				width : 300,
				modal : true,
				title : 'NICU-�꾲�� �༭',
				layout : 'fit',
				frame : true,
				items: [
					obj.NUC_GridRowViewPort
				],
				bbar : [
					'->',
					new Ext.Toolbar.Button({
						id: "NUC_GridRowEditer_btnUpdate",
						width : 80,
						text : "<img SRC='../scripts/dhcmed/img/update.gif'>����",
						listeners : {
							'click' : function(){
								var errInfo = obj.NUC_GridRowDataCheck("1");
								if (errInfo) {
									ExtTool.alert("��ʾ",errInfo);
								} else {
									var flg = obj.NUC_GridRowDataSave("1")
									if (flg) {
										winGridRowEditer.hide();
										var objGrid = Ext.getCmp('NUC_gridNUC');
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
						id: "NUC_GridRowEditer_btnCommit",
						width : 80,
						text : "<img SRC='../scripts/dhcmed/img/update.png'>�ύ",
						listeners : {
							'click' : function(){
								var errInfo = obj.NUC_GridRowDataCheck("2");
								if (errInfo) {
									ExtTool.alert("��ʾ",errInfo);
								} else {
									var flg = obj.NUC_GridRowDataSave("2")
									if (flg) {
										winGridRowEditer.hide();
										var objGrid = Ext.getCmp('NUC_gridNUC');
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
						id: "NUC_GridRowEditer_btnCancel",
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
		obj.NUC_GridRowDataSet(objRec);
	}
	
	//NICU-�꾲��
	obj.NUC_GridToNUC = function() {
		var tmpGridPanel = new Ext.grid.GridPanel({
			id: arguments[0],
			store : new Ext.data.Store({
				proxy: new Ext.data.HttpProxy({
					url : ExtToolSetting.RunQueryPageURL,
					listeners : {
						'beforeload' :  function(objProxy, param){
							param.ClassName = 'DHCMed.NINFService.Rep.AimReportNUC';
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
							obj.NUC_GridRowEditer("");
						}
					}
				}),
				new Ext.Toolbar.Button({
					id: arguments[0] + "_btnDelete",
					width : 80,
					text : "<img SRC='../scripts/dhcmed/img/delete.gif'>ɾ��",
					listeners : {
						'click' : function(){
							var objGrid = Ext.getCmp("NUC_gridNUC");
							if (objGrid){
								var objRecArr = objGrid.getSelectionModel().getSelections();
								if (objRecArr.length>0){
									Ext.MessageBox.confirm('ɾ��', '�Ƿ�ɾ��ѡ�����ݼ�¼?', function(btn,text){
										if(btn=="yes"){
											for (var indRec = 0; indRec < objRecArr.length; indRec++){
												var objRec = objRecArr[indRec];
												var flg = obj.NUC_GridRowDataUpdateStatus('0',objRec);
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
							var objGrid = Ext.getCmp("NUC_gridNUC");
							if (objGrid){
								var objRecArr = objGrid.getSelectionModel().getSelections();
								if (objRecArr.length>0){
									for (var indRec = 0; indRec < objRecArr.length; indRec++){
										var objRec = objRecArr[indRec];
										var flg = obj.NUC_GridRowDataCheck('2',objRec);
										if (flg) {
											ExtTool.alert("��ʾ","������Ϣ������,�������ύ!" + flg);
											continue;
										}
										var flg = obj.NUC_GridRowDataUpdateStatus('2',objRec);
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
	
	//NICU-�꾲��
	obj.NUC_gridNUC = obj.NUC_GridToNUC("NUC_gridNUC");
	
	obj.NUC_txtRegNo = Common_TextField("NUC_txtRegNo","�ǼǺ�");
	obj.NUC_txtPatName = Common_TextField("NUC_txtPatName","����");
	obj.NUC_txtPatSex = Common_TextField("NUC_txtPatSex","�Ա�");
	obj.NUC_txtPatAge = Common_TextField("NUC_txtPatAge","����");
	
	obj.NUC_txtAdmDate = Common_TextField("NUC_txtAdmDate","��Ժ����");
	obj.NUC_txtAdmLoc = Common_TextField("NUC_txtAdmLoc","��ǰ����");
	obj.NUC_txtAdmWard = Common_TextField("NUC_txtAdmWard","��ǰ����");
	obj.NUC_txtAdmBed = Common_TextField("NUC_txtAdmBed","����");
	
	obj.NUC_txtTransLoc = Common_TextField("NUC_txtTransLoc","ת�����");
	obj.NUC_txtTransInDate = Common_TextField("NUC_txtTransInDate","�������");
	obj.NUC_txtTransOutDate = Common_TextField("NUC_txtTransOutDate","��������");
	obj.NUC_txtTransFormLoc = Common_TextField("NUC_txtTransFormLoc","�����Դ");
	obj.NUC_txtTransToLoc = Common_TextField("NUC_txtTransToLoc","����ȥ��");
	
	obj.NUC_txtRegNo.setDisabled(true);
	obj.NUC_txtPatName.setDisabled(true);
	obj.NUC_txtPatSex.setDisabled(true);
	obj.NUC_txtPatAge.setDisabled(true);
	
	obj.NUC_txtAdmDate.setDisabled(true);
	obj.NUC_txtAdmLoc.setDisabled(true);
	obj.NUC_txtAdmWard.setDisabled(true);
	obj.NUC_txtAdmBed.setDisabled(true);
	
	obj.NUC_txtTransLoc.setDisabled(true);
	obj.NUC_txtTransInDate.setDisabled(true);
	obj.NUC_txtTransOutDate.setDisabled(true);
	obj.NUC_txtTransFormLoc.setDisabled(true);
	obj.NUC_txtTransToLoc.setDisabled(true);
	
	//������Ϣ
	obj.NUC_FormToPAT = function() {
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
							items : [obj.NUC_txtRegNo]
						},{
							columnWidth:.25,
							layout : 'form',
							labelAlign : 'right',
							labelWidth : 60,
							items : [obj.NUC_txtPatName]
						},{
							columnWidth:.25,
							layout : 'form',
							labelAlign : 'right',
							labelWidth : 60,
							items : [obj.NUC_txtPatSex]
						},{
							columnWidth:.25,
							layout : 'form',
							labelAlign : 'right',
							labelWidth : 60,
							items : [obj.NUC_txtPatAge]
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
							items : [obj.NUC_txtAdmDate]
						},{
							columnWidth:.25,
							layout : 'form',
							labelAlign : 'right',
							labelWidth : 60,
							items : [obj.NUC_txtAdmLoc]
						},{
							columnWidth:.25,
							layout : 'form',
							labelAlign : 'right',
							labelWidth : 60,
							items : [obj.NUC_txtAdmWard]
						},{
							columnWidth:.25,
							layout : 'form',
							labelAlign : 'right',
							labelWidth : 60,
							items : [obj.NUC_txtAdmBed]
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
							items : [obj.NUC_txtTransLoc]
						},{
							columnWidth:.25,
							layout : 'form',
							labelAlign : 'right',
							labelWidth : 60,
							items : [obj.NUC_txtTransInDate]
						},{
							columnWidth:.25,
							layout : 'form',
							labelAlign : 'right',
							labelWidth : 60,
							items : [obj.NUC_txtTransOutDate]
						},{
							columnWidth:.25,
							layout : 'form',
							labelAlign : 'right',
							labelWidth : 60,
							items : [obj.NUC_txtTransToLoc]
						}
					]
				}
			]
		}
		
		return tmpFormPanel;
	}
	
	//������Ϣ
	obj.NUC_formPAT = obj.NUC_FormToPAT("NUC_formPAT");
	
	//��ʼ��ҳ��
	obj.NUC_FormPatDataSet = function() {
		var objPaadm = obj.ClsBasePatientAdm.GetObjById(obj.CurrReport.ChildNICU.EpisodeID);
		if (objPaadm) {
			var PatientID = objPaadm.PatientID;
			var objPatient = obj.ClsBasePatient.GetObjById(PatientID);
			if (objPatient) {
				Common_SetValue('NUC_txtRegNo',objPatient.PapmiNo);
				Common_SetValue('NUC_txtPatName',objPatient.PatientName);
				Common_SetValue('NUC_txtPatSex',objPatient.Sex);
				var Age = objPatient.Age;
				var Month = objPatient.AgeMonth;
				var Day = objPatient.AgeDay;
				if (!Age) Age=0;
				if (!Month) Month=0;
				if (!Day) Day=0;
				if (parseInt(Age) > 0) {
					Common_SetValue('NUC_txtPatAge',parseInt(Age) + '��');
				} else {
					Common_SetValue('NUC_txtPatAge',parseInt(Month) + '��' + parseInt(Day) + '��');
				}
			}
			Common_SetValue('NUC_txtAdmDate',objPaadm.AdmitDate + ' ' + objPaadm.AdmitTime);
			Common_SetValue('NUC_txtAdmLoc',objPaadm.Department);
			Common_SetValue('NUC_txtAdmWard',objPaadm.Ward);
			Common_SetValue('NUC_txtAdmBed',objPaadm.Bed + "��");
		}
		
		var strTransLoc = obj.ClsCommonClsSrv.GetAdmTrans(obj.CurrReport.ChildNICU.TransID,obj.CurrReport.ChildNICU.TransLoc);
		var arrTransLoc = strTransLoc.split(CHR_1);
		if (arrTransLoc.length>=10)
		{
			Common_SetValue('NUC_txtTransInDate',arrTransLoc[6] + ' ' + arrTransLoc[7]);
			Common_SetValue('NUC_txtTransOutDate',arrTransLoc[8] + ' ' + arrTransLoc[9]);
			Common_SetValue('NUC_txtTransLoc',arrTransLoc[1]);
			Common_SetValue('NUC_txtTransFormLoc',arrTransLoc[3]);
			Common_SetValue('NUC_txtTransToLoc',arrTransLoc[5]);
		}
	}
	
	obj.NUC_ViewPort = {
		layout : 'border',
		title : 'NICU-�꾲��',
		items : [
			{
				layout : 'fit',
				region : 'north',
				height : 100,
				frame : true,
				items : [obj.NUC_formPAT]
			},{
				layout : 'fit',
				region: 'center',
				frame : true,
				items : [obj.NUC_gridNUC]
			}
		]
	}
	
	obj.NUC_InitView = function(){
		var objGrid = Ext.getCmp("NUC_gridNUC");
		if (objGrid){
			objGrid.getStore().load({});
			objGrid.on('rowdblclick',function(){
				var rowIndex = arguments[1];
				var objRec = this.getStore().getAt(rowIndex);
				obj.NUC_GridRowEditer(objRec);
			},objGrid);
		}
		obj.NUC_FormPatDataSet();
	}
	return obj;
}