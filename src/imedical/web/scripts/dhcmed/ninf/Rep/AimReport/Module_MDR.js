
function InitMDR(obj)
{
	obj.MDR_valSubID = '';
	
	//�ͼ�����
	obj.MDR_txtPathDate = Common_DateFieldToDate("MDR_txtPathDate","�ͼ�����");
	
	//�걾����
	obj.MDR_cboSampleType = Common_ComboToDic("MDR_cboSampleType","�걾����","NINFAimMDRSampleType");
	
	//ϸ������
	obj.MDR_cboPathogeny = Common_ComboToDic("MDR_cboPathogeny","ϸ������","NIFNAimMDRPathogeny");
	
	//���뷽ʽ
	obj.MDR_cboIsolateType = Common_ComboToDic("MDR_cboIsolateType","���뷽ʽ","NINFAimMDRIsolateType");
	
	//��ǿ������
	obj.MDR_cboHandHygiene = Common_ComboToDic("MDR_cboHandHygiene","��ǿ������","NINFAimMDRHandHygiene");
	
	//��������
	obj.MDR_cboSecondaryCases = Common_ComboToDic("MDR_cboSecondaryCases","��������","NINFAimMDRSecondaryCases");
	
	//��Ⱦ���
	obj.MDR_cboNINFStation = Common_ComboToDic("MDR_cboNINFStation","��Ⱦ���","NINFStation");
	
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
					errInfo = errInfo + '�ͼ�����δ��!';
				}
				var MDR_cboSampleType = objRec.get('SampleTypeDesc');
				if (MDR_cboSampleType=='') {
					errInfo = errInfo + '�걾����δ��!';
				}
				var MDR_cboPathogeny = objRec.get('PathogenyDesc');
				if (MDR_cboPathogeny=='') {
					errInfo = errInfo + 'ϸ������δ��!';
				}
				var MDR_cboIsolateType = objRec.get('IsolateTypeDesc');
				if (MDR_cboIsolateType=='') {
					errInfo = errInfo + '���뷽ʽδ��!';
				}
				var MDR_cboHandHygiene = objRec.get('HandHygieneDesc');
				if (MDR_cboHandHygiene=='') {
					errInfo = errInfo + '��ǿ������δ��!';
				}
				var MDR_cboSecondaryCases = objRec.get('SecondaryCasesDesc');
				if (MDR_cboSecondaryCases=='') {
					errInfo = errInfo + '��������δ��!';
				}
				
				var MDR_cboNINFStation = objRec.get('NINFStation');
				if (MDR_cboNINFStation=='') {
					errInfo = errInfo + '��Ⱦ���δ��!';
				}
			}
		} else {
			if (StatusCode == '1') {
				var MDR_cboPathogeny = Common_GetValue('MDR_cboPathogeny');
				if (MDR_cboPathogeny=='') {
					errInfo = errInfo + 'ϸ������δ��!';
				}
			}
			if (StatusCode == '2') {
				var MDR_txtPathDate = Common_GetValue('MDR_txtPathDate');
				if (MDR_txtPathDate=='') {
					errInfo = errInfo + '�ͼ�����δ��!';
				}
				var MDR_cboSampleType = Common_GetValue('MDR_cboSampleType');
				if (MDR_cboSampleType=='') {
					errInfo = errInfo + '�걾����δ��!';
				}
				var MDR_cboPathogeny = Common_GetValue('MDR_cboPathogeny');
				if (MDR_cboPathogeny=='') {
					errInfo = errInfo + 'ϸ������δ��!';
				}
				var MDR_cboIsolateType = Common_GetValue('MDR_cboIsolateType');
				if (MDR_cboIsolateType=='') {
					errInfo = errInfo + '���뷽ʽδ��!';
				}
				var MDR_cboHandHygiene = Common_GetValue('MDR_cboHandHygiene');
				if (MDR_cboHandHygiene=='') {
					errInfo = errInfo + '��ǿ������δ��!';
				}
				var MDR_cboSecondaryCases = Common_GetValue('MDR_cboSecondaryCases');
				if (MDR_cboSecondaryCases=='') {
					errInfo = errInfo + '��������δ��!';
				}
				
				var MDR_cboNINFStation = Common_GetValue('MDR_cboNINFStation');
				if (MDR_cboNINFStation=='') {
					errInfo = errInfo + '��Ⱦ���δ��!';
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
				title : '������ҩ-�༭',
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
						text : "<img SRC='../scripts/dhcmed/img/update.gif'>����",
						listeners : {
							'click' : function(){
								var errInfo = obj.MDR_GridRowDataCheck("1");
								if (errInfo) {
									ExtTool.alert("��ʾ",errInfo);
								} else {
									var flg = obj.MDR_GridRowDataSave("1")
									if (flg) {
										winGridRowEditer.hide();
										var objGrid = Ext.getCmp('MDR_gridMDR');
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
						id: "MDR_GridRowEditer_btnCommit",
						width : 80,
						text : "<img SRC='../scripts/dhcmed/img/update.png'>�ύ",
						listeners : {
							'click' : function(){
								var errInfo = obj.MDR_GridRowDataCheck("2");
								if (errInfo) {
									ExtTool.alert("��ʾ",errInfo);
								} else {
									var flg = obj.MDR_GridRowDataSave("2")
									if (flg) {
										winGridRowEditer.hide();
										var objGrid = Ext.getCmp('MDR_gridMDR');
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
						id: "MDR_GridRowEditer_btnCancel",
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
		obj.MDR_GridRowDataSet(objRec);
	}
	
	//������ҩ
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
				{header: '����<br>״̬', width: 50, dataIndex: 'RepStatusDesc', sortable: false, menuDisabled:true, align:'center' }
				,{header: '�ͼ�����', width: 80, dataIndex: 'PathDate', sortable: false, menuDisabled:true, align:'center' }
				,{header: '�걾����', width: 80, dataIndex: 'SampleTypeDesc', sortable: false, menuDisabled:true, align:'center' }
				,{header: 'ϸ������', width: 150, dataIndex: 'PathogenyDesc', sortable: false, menuDisabled:true, align:'center' }
				,{header: '��Ⱦ���', width: 150, dataIndex: 'NINFStationDesc', sortable: false, menuDisabled:true, align:'center' }
				,{header: '���뷽ʽ', width: 80, dataIndex: 'IsolateTypeDesc', sortable: false, menuDisabled:true, align:'center' }
				,{header: '��ǿ<br>������', width: 80, dataIndex: 'HandHygieneDesc', sortable: false, menuDisabled:true, align:'center' }
				,{header: '��������', width: 80, dataIndex: 'SecondaryCasesDesc', sortable: false, menuDisabled:true, align:'center' }
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
							obj.MDR_GridRowEditer("");
						}
					}
				}),
				new Ext.Toolbar.Button({
					id: arguments[0] + "_btnDelete",
					width : 80,
					text : "<img SRC='../scripts/dhcmed/img/delete.gif'>ɾ��",
					listeners : {
						'click' : function(){
							var objGrid = Ext.getCmp("MDR_gridMDR");
							if (objGrid){
								var objRecArr = objGrid.getSelectionModel().getSelections();
								if (objRecArr.length>0){
									Ext.MessageBox.confirm('ɾ��', '�Ƿ�ɾ��ѡ�����ݼ�¼?', function(btn,text){
										if(btn=="yes"){
											for (var indRec = 0; indRec < objRecArr.length; indRec++){
												var objRec = objRecArr[indRec];
												var flg = obj.MDR_GridRowDataUpdateStatus('0',objRec);
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
							var objGrid = Ext.getCmp("MDR_gridMDR");
							if (objGrid){
								var objRecArr = objGrid.getSelectionModel().getSelections();
								if (objRecArr.length>0){
									for (var indRec = 0; indRec < objRecArr.length; indRec++){
										var objRec = objRecArr[indRec];
										var flg = obj.MDR_GridRowDataCheck('2',objRec);
										if (flg) {
											ExtTool.alert("��ʾ","������Ϣ������,�������ύ!" + flg);
											continue;
										}
										var flg = obj.MDR_GridRowDataUpdateStatus('2',objRec);
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
	
	//������ҩ
	obj.MDR_gridMDR = obj.MDR_GridToMDR("MDR_gridMDR");
	
	obj.MDR_txtRegNo = Common_TextField("MDR_txtRegNo","�ǼǺ�");
	obj.MDR_txtPatName = Common_TextField("MDR_txtPatName","����");
	obj.MDR_txtPatSex = Common_TextField("MDR_txtPatSex","�Ա�");
	obj.MDR_txtPatAge = Common_TextField("MDR_txtPatAge","����");
	
	obj.MDR_txtAdmDate = Common_TextField("MDR_txtAdmDate","��Ժ����");
	obj.MDR_txtAdmLoc = Common_TextField("MDR_txtAdmLoc","��ǰ����");
	obj.MDR_txtAdmWard = Common_TextField("MDR_txtAdmWard","��ǰ����");
	obj.MDR_txtAdmBed = Common_TextField("MDR_txtAdmBed","����");
	
	obj.MDR_txtTransLoc = Common_TextField("MDR_txtTransLoc","ת�����");
	obj.MDR_txtTransInDate = Common_TextField("MDR_txtTransInDate","�������");
	obj.MDR_txtTransOutDate = Common_TextField("MDR_txtTransOutDate","��������");
	obj.MDR_txtTransFormLoc = Common_TextField("MDR_txtTransFormLoc","�����Դ");
	obj.MDR_txtTransToLoc = Common_TextField("MDR_txtTransToLoc","����ȥ��");
	
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
	
	//������Ϣ
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
	
	//������Ϣ
	obj.MDR_formPAT = obj.MDR_FormToPAT("MDR_formPAT");
	
	//��ʼ��ҳ��
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
					Common_SetValue('MDR_txtPatAge',parseInt(Age) + '��');
				} else {
					Common_SetValue('MDR_txtPatAge',parseInt(Month) + '��' + parseInt(Day) + '��');
				}
			}
			Common_SetValue('MDR_txtAdmDate',objPaadm.AdmitDate + ' ' + objPaadm.AdmitTime);
			Common_SetValue('MDR_txtAdmLoc',objPaadm.Department);
			Common_SetValue('MDR_txtAdmWard',objPaadm.Ward);
			Common_SetValue('MDR_txtAdmBed',objPaadm.Bed + "��");
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
		title : '������ҩ',
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