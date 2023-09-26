
function InitOPR(obj)
{
	obj.OPR_valSubID = '';
	
	obj.gridAimOperationStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.gridAimOperationStore = new Ext.data.Store({
		proxy: obj.gridAimOperationStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'RecordID'
		}, 
		[
			{name: 'RecordID', mapping : 'RecordID'}		 //����ID
			,{name: 'OperDesc', mapping : 'OperDesc'}		 //��������
			,{name: 'OperDate', mapping: 'OperDate'}		 //��������
			,{name: 'OperTimes', mapping: 'OperTimes'}		 //����ʱ��
			,{name: 'CutGradeID', mapping: 'CutGradeID'}	 //�п�����ID
			,{name: 'CutGrade', mapping: 'CutGrade'}		 //�п�����
			,{name: 'AnesthesiaID', mapping: 'AnesthesiaID'} //����ʽID
			,{name: 'Anesthesia', mapping: 'Anesthesia'}	 //����ʽ
			,{name: 'DocID', mapping: 'DocID'}			     //����ID
			,{name: 'DocName', mapping: 'DocName'}			 //����
			,{name: 'Assistant1ID', mapping: 'Assistant1ID'} //һ��ID
			,{name: 'Assistant1', mapping: 'Assistant1'}     //һ��
			,{name: 'OperType1', mapping: 'OperType1'}		 //�Ƿ���
			,{name: 'OperType2', mapping: 'OperType2'}       //�Ƿ�����
			,{name: 'OperType3', mapping: 'OperType3'}       //�Ƿ��ھ�
			,{name: 'ASAScore', mapping: 'ASAScore'}		 //ASA����
		])
	});
	obj.gridAimOperation = new Ext.grid.EditorGridPanel({
		id : 'gridAimOperation'
		,store : obj.gridAimOperationStore
		,selModel : new Ext.grid.RowSelectionModel({singleSelect : true})
		,clicksToEdit : 1
		,columnLines : true
		,stripeRows : true
		,region : 'center'
		,columns: [
			{header: '��������', width: 200, dataIndex: 'OperDesc', sortable: true, align: 'center'}
			,{header: '��������', width: 70, dataIndex: 'OperDate', sortable: false, align: 'center'}
			,{header: 'ʱ��<br>(����)', width: 50, dataIndex: 'OperTimes', sortable: false, align: 'center'}		
			,{header: '�п�<br>����', width: 50, dataIndex: 'CutGrade', sortable: false, align: 'center'}
			,{header: '����ʽ', width: 70, dataIndex: 'Anesthesia', sortable: false, align: 'center'}
			,{header: '����', width: 60, dataIndex: 'DocName', sortable: false, align: 'center'}
			//,{header: 'һ��', width: 60, dataIndex: 'Assistant1', sortable: false, align: 'center'}
			,{header: '����', width: 50, dataIndex: 'OperType1', sortable: false, menuDisabled:true, align: 'center'}
			//,{header: '����', width: 50, dataIndex: 'OperType2', sortable: false, menuDisabled:true, align: 'center'}
			//,{header: '�ھ�', width: 50, dataIndex: 'OperType3', sortable: false, menuDisabled:true, align: 'center'}
			,{header: 'ASA����', width: 60, dataIndex: 'ASAScore', sortable: false, align: 'center'}
		]
		,viewConfig : {
			forceFit : true
		}
		,listeners : {
			'rowdblclick' : function(){
				var selectObj = obj.gridAimOperation.getSelectionModel().getSelected();
				if (selectObj){
					obj.OPR_cboOperation.setValue(selectObj.get("OperDesc"));
					obj.OPR_txtOperDate .setValue(selectObj.get("OperDate"));
					obj.OPR_txtOperTimes.setValue(selectObj.get("OperTimes"));
					Common_SetValue('OPR_cboOperDoctor',selectObj.get('DocID'),selectObj.get('DocName'));	//����
					Common_SetValue('OPR_cboOperCutType',selectObj.get('CutGradeID'),selectObj.get('CutGrade'));	//�п�����
					Common_SetValue('OPR_cboOperNarcosisType',selectObj.get('AnesthesiaID'),selectObj.get('Anesthesia'));	//����ʽ
					obj.OPR_txtOperASAScore.setValue(selectObj.get("ASAScore"));	    //ASA(����)����
					if (selectObj.get('OperType1')=='��'){							    //������/��
						Common_SetValue('OPR_cboOperationType','Y','��');
					}else{
						Common_SetValue('OPR_cboOperationType','N','��');
					}
					if (selectObj.get('OperType2')=='��'){							    //������/��
						Common_SetValue('OPR_cboOperationType1','Y','��');
					}else{
						Common_SetValue('OPR_cboOperationType1','N','��');
					}
					if (selectObj.get('OperType3')=='��'){							    //�ھ���/��
						Common_SetValue('OPR_cboOperationType2','Y','��');
					}else{
						Common_SetValue('OPR_cboOperationType2','N','��');
					}
					document.getElementById("OPR_chkIsInf").checked = true;
				}
			}
		}
    });
    
	obj.gridAimOperationStoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'DHCMed.NINFService.Rep.AimReportOPR';
		param.QueryName = 'QryOperations';
		param.Arg1 = obj.CurrReport.ChildOPR.EpisodeID;
		param.ArgCnt = 1;
	});
	
	obj.gridAimOperationStore.load({});
	
	//��������
	obj.OPR_cboOperation = Common_ComboToORCOperation("OPR_cboOperation","��������");
	
	//��������
	obj.OPR_txtOperDate = Common_DateFieldToDate("OPR_txtOperDate","��������");
	
	//����ʱ��(��)
	obj.OPR_txtOperTimes = Common_NumberField("OPR_txtOperTimes","ʱ��(��)");
	
	//�п�����
	obj.OPR_cboOperCutType = Common_ComboToDic("OPR_cboOperCutType","�п�����","NINFAimOPRCutType");
	
	//ASA����
	obj.OPR_txtOperASAScore = Common_NumberField("OPR_txtOperASAScore","ASA����");
	
	//����ʽ
	obj.OPR_cboOperNarcosisType = Common_ComboToDic("OPR_cboOperNarcosisType","����ʽ","NINFAimOPRNarcosisType");
	
	//�������� ����
	obj.OPR_cboOperationType = Common_ComboToDic("OPR_cboOperationType","����","NINFAimOPROperType");
	
	//�������� ����
	obj.OPR_cboOperationType1 = Common_ComboToDic("OPR_cboOperationType1","����","NINFAimOPROperType1");
	
	//�������� �ھ�
	obj.OPR_cboOperationType2 = Common_ComboToDic("OPR_cboOperationType2","�ھ�","NINFAimOPROperType2");
	
	//����
	obj.OPR_cboOperDoctor = Common_ComboToSSUser("OPR_cboOperDoctor","����");
	
	//һ��
	obj.OPR_cboAssistant1 = Common_ComboToSSUser("OPR_cboAssistant1","һ��");
	
	//�����յ�����ҩ1
	obj.OPR_cboNarcosisAnti1 = Common_ComboToAdmAnti("OPR_cboNarcosisAnti1","�����յ�����ҩ1",obj.CurrReport.ChildOPR.EpisodeID);
	obj.OPR_cboNarcosisAnti1.on('select',function(){
		var objRec = arguments[1];
		if (objRec)
		{
			Common_SetValue('OPR_txtNarcosisAnti1Qty',objRec.get('OEORIDoseQty'));
			Common_SetValue('OPR_txtNarcosisAnti1QtyUom',objRec.get('OEORIUnit'));
		}
	},obj.OPR_cboNarcosisAnti1);
	//����
	obj.OPR_txtNarcosisAnti1Qty = Common_NumberField("OPR_txtNarcosisAnti1Qty","����");
	//��λ
	obj.OPR_txtNarcosisAnti1QtyUom = Common_TextField("OPR_txtNarcosisAnti1QtyUom","��λ");
	obj.OPR_txtNarcosisAnti1QtyUom.setDisabled(true);
	
	//�����յ�����ҩ2
	obj.OPR_cboNarcosisAnti2 = Common_ComboToAdmAnti("OPR_cboNarcosisAnti2","�����յ�����ҩ2",obj.CurrReport.ChildOPR.EpisodeID);
	obj.OPR_cboNarcosisAnti2.on('select',function(){
		var objRec = arguments[1];
		if (objRec) {
			Common_SetValue('OPR_txtNarcosisAnti2Qty',objRec.get('OEORIDoseQty'));
			Common_SetValue('OPR_txtNarcosisAnti2QtyUom',objRec.get('OEORIUnit'));
		}
	},obj.OPR_cboNarcosisAnti2);
	//����
	obj.OPR_txtNarcosisAnti2Qty = Common_NumberField("OPR_txtNarcosisAnti2Qty","����");
	//��λ
	obj.OPR_txtNarcosisAnti2QtyUom = Common_TextField("OPR_txtNarcosisAnti2QtyUom","��λ");
	obj.OPR_txtNarcosisAnti2QtyUom.setDisabled(true);
	
	//����Ԥ������ҩ1
	obj.OPR_cboPostoperAnti1 = Common_ComboToAdmAnti("OPR_cboPostoperAnti1","����Ԥ������ҩ1",obj.CurrReport.ChildOPR.EpisodeID);
	obj.OPR_cboPostoperAnti1.on('select',function(){
		var objRec = arguments[1];
		if (objRec) {
			Common_SetValue('OPR_txtPostoperAnti1Qty',objRec.get('OEORIDoseQty'));
			Common_SetValue('OPR_txtPostoperAnti1QtyUom',objRec.get('OEORIUnit'));
			Common_SetValue('OPR_txtPostoperAnti1Days',objRec.get('OEORIDays'));
		}
	},obj.OPR_cboPostoperAnti1);
	//����
	obj.OPR_txtPostoperAnti1Qty = Common_NumberField("OPR_txtPostoperAnti1Qty","����");
	//��λ
	obj.OPR_txtPostoperAnti1QtyUom = Common_TextField("OPR_txtPostoperAnti1QtyUom","��λ");
	obj.OPR_txtPostoperAnti1QtyUom.setDisabled(true);
	//��ҩ����
	obj.OPR_txtPostoperAnti1Days = Common_NumberField("OPR_txtPostoperAnti1Days","��ҩ����");
	
	//����Ԥ������ҩ2
	obj.OPR_cboPostoperAnti2 = Common_ComboToAdmAnti("OPR_cboPostoperAnti2","����Ԥ������ҩ2",obj.CurrReport.ChildOPR.EpisodeID);
	obj.OPR_cboPostoperAnti2.on('select',function(){
		var objRec = arguments[1];
		if (objRec) {
			Common_SetValue('OPR_txtPostoperAnti2Qty',objRec.get('OEORIDoseQty'));
			Common_SetValue('OPR_txtPostoperAnti2QtyUom',objRec.get('OEORIUnit'));
			Common_SetValue('OPR_txtPostoperAnti2Days',objRec.get('OEORIDays'));
		}
	},obj.OPR_cboPostoperAnti2);
	//����
	obj.OPR_txtPostoperAnti2Qty = Common_NumberField("OPR_txtPostoperAnti2Qty","����");
	//��λ
	obj.OPR_txtPostoperAnti2QtyUom = Common_TextField("OPR_txtPostoperAnti2QtyUom","��λ");
	obj.OPR_txtPostoperAnti2QtyUom.setDisabled(true);
	//��ҩ����
	obj.OPR_txtPostoperAnti2Days = Common_NumberField("OPR_txtPostoperAnti2Days","��ҩ����");
	
	//�Ƿ��Ⱦ
	obj.OPR_chkIsInf = Common_Checkbox("OPR_chkIsInf","�Ƿ��Ⱦ");
	obj.OPR_chkIsInf.on('check',function(checkbox,value){
		var objItem1 = Ext.getCmp("OPR_txtInfDate");
		if (objItem1) {
			objItem1.setDisabled((!value));
		}
		var objItem1 = Ext.getCmp("OPR_cboInfPy");
		if (objItem1) {
			objItem1.setDisabled((!value));
		}
		var objItem1 = Ext.getCmp("OPR_cboOperInfType");
		if (objItem1) {
			objItem1.setDisabled((!value));
		}
		if (!value) {
			Common_SetValue('OPR_txtInfDate','');
			Common_SetValue('OPR_cboInfPy','','');
			Common_SetValue('OPR_cboOperInfType','','');
		}
	},obj.OPR_chkIsInf);
	
	//��Ⱦ����
	obj.OPR_txtInfDate = Common_DateFieldToDate("OPR_txtInfDate","��Ⱦ����");
	
	//��ԭ��
	obj.OPR_cboInfPy = Common_ComboToPathogeny("OPR_cboInfPy","��ԭ��");
	
	//��Ⱦ����
	obj.OPR_cboOperInfType = Common_ComboToDic("OPR_cboOperInfType","��Ⱦ����","NINFAimOPRInfType");
	
	//��ע
	obj.OPR_txtResumeText = Common_TextField("OPR_txtResumeText","��ע");
	
	obj.OPR_GridRowViewPort = {
		layout : 'form',
		frame : true,
		height : 250,
		region : 'south',
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
							obj.OPR_cboOperation
						]
					},{
						columnWidth:.25,
						layout : 'form',
						labelAlign : 'right',
						labelWidth : 60,
						items : [
							obj.OPR_txtOperDate
						]
					},{
						columnWidth:.25,
						layout : 'form',
						labelAlign : 'right',
						labelWidth : 60,
						items : [
							obj.OPR_txtOperTimes
						]
					}
				]
			},{
				layout : 'column',
				items : [
					{
						columnWidth:.25,
						layout : 'form',
						labelAlign : 'right',
						labelWidth : 60,
						items : [
							obj.OPR_cboOperCutType
						]
					},{
						columnWidth:.25,
						layout : 'form',
						labelAlign : 'right',
						labelWidth : 60,
						items : [
							obj.OPR_cboOperNarcosisType
						]
					},{
						columnWidth:.25,
						layout : 'form',
						labelAlign : 'right',
						labelWidth : 60,
						items : [
							obj.OPR_cboOperDoctor
						]
					},{
						columnWidth:.25,
						layout : 'form',
						labelAlign : 'right',
						labelWidth : 60,
						items : [
							obj.OPR_cboAssistant1
						]
					}
				]
			},{
				layout : 'column',
				items : [
					{
						columnWidth:.25,
						layout : 'form',
						labelAlign : 'right',
						labelWidth : 60,
						items : [
							obj.OPR_cboOperationType
						]
					},{
						columnWidth:.25,
						layout : 'form',
						labelAlign : 'right',
						labelWidth : 60,
						items : [
							obj.OPR_cboOperationType1
						]
					},{
						columnWidth:.25,
						layout : 'form',
						labelAlign : 'right',
						labelWidth : 60,
						items : [
							obj.OPR_cboOperationType2
						]
					},{
						columnWidth:.25,
						layout : 'form',
						labelAlign : 'right',
						labelWidth : 60,
						items : [
							obj.OPR_txtOperASAScore
						]
					}
				]
			},{
				layout : 'column',
				items : [
					{
						columnWidth:.25,
						layout : 'form',
						labelAlign : 'right',
						labelWidth : 60,
						items : [
							obj.OPR_chkIsInf
						]
					},{
						columnWidth:.25,
						layout : 'form',
						labelAlign : 'right',
						labelWidth : 60,
						items : [
							obj.OPR_txtInfDate
						]
					},{
						columnWidth:.25,
						layout : 'form',
						labelAlign : 'right',
						labelWidth : 60,
						items : [
							obj.OPR_cboOperInfType
						]
					},{
						columnWidth:.25,
						layout : 'form',
						labelAlign : 'right',
						labelWidth : 60,
						items : [
							obj.OPR_cboInfPy
						]
					}
				]
			},{
				layout : 'column',
				items : [
					{
						columnWidth:.80,
						layout : 'form',
						labelAlign : 'right',
						labelWidth : 60,
						items : [
							obj.OPR_txtResumeText
						]
					}
				]
			},{
				layout : 'column',
				items : [
					{
						columnWidth:.99,
						layout : 'form',
						labelAlign : 'right',
						labelWidth : 100,
						items : [
							obj.OPR_cboNarcosisAnti1
							,obj.OPR_cboNarcosisAnti2
						]
					},{
						width:80,
						layout : 'form',
						labelAlign : 'right',
						labelWidth : 40,
						items : [
							obj.OPR_txtNarcosisAnti1Qty
							,obj.OPR_txtNarcosisAnti2Qty
						]
					},{
						width:80,
						layout : 'form',
						labelAlign : 'right',
						labelWidth : 40,
						items : [
							obj.OPR_txtNarcosisAnti1QtyUom
							,obj.OPR_txtNarcosisAnti2QtyUom
						]
					},{
						width:100,
						layout : 'form',
						labelAlign : 'right',
						labelWidth : 60,
						items : [
						]
					}
				]
			},
			{
				layout : 'column',
				items : [
					{
						columnWidth:.99,
						layout : 'form',
						labelAlign : 'right',
						labelWidth : 100,
						items : [
							obj.OPR_cboPostoperAnti1
							,obj.OPR_cboPostoperAnti2
						]
					},{
						width:80,
						layout : 'form',
						labelAlign : 'right',
						labelWidth : 40,
						items : [
							obj.OPR_txtPostoperAnti1Qty
							,obj.OPR_txtPostoperAnti2Qty
						]
					},{
						width:80,
						layout : 'form',
						labelAlign : 'right',
						labelWidth : 40,
						items : [
							obj.OPR_txtPostoperAnti1QtyUom
							,obj.OPR_txtPostoperAnti2QtyUom
						]
					},{
						width:100,
						layout : 'form',
						labelAlign : 'right',
						labelWidth : 60,
						items : [
							obj.OPR_txtPostoperAnti1Days
							,obj.OPR_txtPostoperAnti2Days
						]
					}
				]
			}
		]
	}
	
	obj.OPR_GridRowDataCheck = function()
	{
		var errInfo = '';
		
		var StatusCode = arguments[0];
		var objRec = arguments[1];
		if (objRec)
		{
			if (StatusCode == '2') {
				var OPR_cboOperation = objRec.get('OperationDesc');
				if (OPR_cboOperation=='') {
					errInfo = errInfo + '��������δ��!';
				}
				var OPR_txtOperDate = objRec.get('OperStartDateTime');
				if (OPR_txtOperDate=='') {
					errInfo = errInfo + '��������δ��!';
				}
				var OPR_txtOperTimes = objRec.get('OperTimes');
				if (OPR_txtOperTimes=='') {
					errInfo = errInfo + '����ʱ��(��)δ��!';
				}
				var OPR_cboOperationType = objRec.get('OperationTypeID');
				if (OPR_cboOperationType=='') {
					errInfo = errInfo + '����[��/��]δ��!';
				}
				var OPR_cboOperationType1 = objRec.get('OperationType1ID');
				if (OPR_cboOperationType1=='') {
					errInfo = errInfo + '����[��/��]δ��!';
				}
				var OPR_cboOperationType2 = objRec.get('OperationType2ID');
				if (OPR_cboOperationType2=='') {
					errInfo = errInfo + '�ھ�[��/��]δ��!';
				}
				var OPR_cboOperCutType = objRec.get('OperCutTypeDesc');
				if (OPR_cboOperCutType=='') {
					errInfo = errInfo + '�п�����δ��!';
				}
				var OPR_cboOperNarcosisType = objRec.get('OperNarcosisTypeDesc');
				if (OPR_cboOperNarcosisType=='') {
					errInfo = errInfo + '����ʽδ��!';
				}
				var OPR_cboOperDoctor = objRec.get('OperDoctorDesc');
				if (OPR_cboOperDoctor=='') {
					errInfo = errInfo + '����δ��!';
				}
				var OPR_txtOperASAScore = objRec.get('OperASAScore');
				if (OPR_txtOperASAScore=='') {
					errInfo = errInfo + 'ASA����δ��!';
				}
			}
		} else {
			if (StatusCode == '1') {
				var OPR_cboOperation = Common_GetValue('OPR_cboOperation');
				if (OPR_cboOperation=='') {
					errInfo = errInfo + '��������δ��!';
				}
			}
			if (StatusCode == '2') {
				var OPR_cboOperation = Common_GetValue('OPR_cboOperation');
				if (OPR_cboOperation=='') {
					errInfo = errInfo + '��������δ��!';
				}
				var OPR_txtOperDate = Common_GetValue('OPR_txtOperDate');
				if (OPR_txtOperDate=='') {
					errInfo = errInfo + '��������δ��!';
				}
				var OPR_txtOperTimes = Common_GetValue('OPR_txtOperTimes');
				if (OPR_txtOperTimes=='') {
					errInfo = errInfo + '����ʱ��(��)δ��!';
				}
				var OPR_cboOperationType = Common_GetValue('OPR_cboOperationType');
				if (OPR_cboOperationType=='') {
					errInfo = errInfo + '����[��/��]δ��!';
				}
				var OPR_cboOperationType1 = Common_GetValue('OPR_cboOperationType1');
				if (OPR_cboOperationType1=='') {
					errInfo = errInfo + '����[��/��]δ��!';
				}
				var OPR_cboOperationType2 = Common_GetValue('OPR_cboOperationType2');
				if (OPR_cboOperationType2=='') {
					errInfo = errInfo + '�ھ�[��/��]δ��!';
				}
				var OPR_cboOperCutType = Common_GetValue('OPR_cboOperCutType');
				if (OPR_cboOperCutType=='') {
					errInfo = errInfo + '�п�����δ��!';
				}
				var OPR_cboOperNarcosisType = Common_GetValue('OPR_cboOperNarcosisType');
				if (OPR_cboOperNarcosisType=='') {
					errInfo = errInfo + '����ʽδ��!';
				}
				var OPR_cboOperDoctor = Common_GetValue('OPR_cboOperDoctor');
				if (OPR_cboOperDoctor=='') {
					errInfo = errInfo + '����δ��!';
				}
				var OPR_txtOperASAScore = Common_GetValue('OPR_txtOperASAScore');
				if (OPR_txtOperASAScore=='') {
					errInfo = errInfo + 'ASA����δ��!';
				}
			}
		}
		
		
		
		return errInfo;
	}
	
	obj.OPR_GridRowDataUpdateStatus = function()
	{
		var StatusCode = arguments[0];
		var objRec = arguments[1];
		if (objRec) {
			var inputStr = objRec.get('RepID') + "||" + objRec.get('SubID');
		} else {
			var inputStr = obj.CurrReport.ChildOPR.RowID + "||" + obj.OPR_valSubID;
		}
		inputStr = inputStr + CHR_1 + session['LOGON.CTLOCID'];
		inputStr = inputStr + CHR_1 + session['LOGON.USERID'];
		inputStr = inputStr + CHR_1 + StatusCode;
		
		var flg = obj.ClsAimReportOPRSrv.UpdateStatus(inputStr, CHR_1);
		if (parseInt(flg) <= 0) {
			return false;
		} else {
			return true;
		}
		return true;
	}
	
	obj.OPR_GridRowDataSave = function()
	{
		if (obj.CurrReport.ChildOPR.RowID == "")
		{
			var inputStr = "";
			inputStr = inputStr + CHR_1 + obj.CurrReport.ChildOPR.ReportTypeCode;
			inputStr = inputStr + CHR_1 + obj.CurrReport.ChildOPR.EpisodeID;
			inputStr = inputStr + CHR_1 + obj.CurrReport.ChildOPR.TransID;
			inputStr = inputStr + CHR_1 + obj.CurrReport.ChildOPR.TransLoc;
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
				obj.CurrReport.ChildOPR = objAimReport;
			}
		}
		if (obj.CurrReport.ChildOPR.RowID=='') return false;
		
		var StatusCode = arguments[0];
		
		var inputStr = obj.CurrReport.ChildOPR.RowID;
		inputStr = inputStr + CHR_1 + obj.OPR_valSubID;
		inputStr = inputStr + CHR_1 + Common_GetValue('OPR_cboOperation');
		inputStr = inputStr + CHR_1 + Common_GetText('OPR_cboOperation');
		inputStr = inputStr + CHR_1 + Common_GetValue('OPR_txtOperDate');
		inputStr = inputStr + CHR_1 + '';
		inputStr = inputStr + CHR_1 + Common_GetValue('OPR_txtOperTimes');
		inputStr = inputStr + CHR_1 + Common_GetValue('OPR_cboOperCutType');
		inputStr = inputStr + CHR_1 + Common_GetValue('OPR_txtOperASAScore');
		inputStr = inputStr + CHR_1 + Common_GetValue('OPR_cboOperNarcosisType');
		inputStr = inputStr + CHR_1 + Common_GetValue('OPR_cboOperationType');
		inputStr = inputStr + CHR_1 + Common_GetValue('OPR_cboOperationType1');
		inputStr = inputStr + CHR_1 + Common_GetValue('OPR_cboOperationType2');
		inputStr = inputStr + CHR_1 + Common_GetValue('OPR_cboOperDoctor');
		inputStr = inputStr + CHR_1 + Common_GetValue('OPR_cboAssistant1');
		inputStr = inputStr + CHR_1 + Common_GetValue('OPR_cboAssistant2');
		
		var NarcosisAnti1 = Common_GetValue('OPR_cboNarcosisAnti1') + '``' + Common_GetValue('OPR_txtNarcosisAnti1Qty') + '`' + Common_GetValue('OPR_txtNarcosisAnti1QtyUom') + '`' + '';
		var NarcosisAnti2 = Common_GetValue('OPR_cboNarcosisAnti2') + '``' + Common_GetValue('OPR_txtNarcosisAnti2Qty') + '`' + Common_GetValue('OPR_txtNarcosisAnti2QtyUom') + '`' + '';
		inputStr = inputStr + CHR_1 + NarcosisAnti1 + ',' + NarcosisAnti2;
		var PostoperAnti1 = Common_GetValue('OPR_cboPostoperAnti1') + '``' + Common_GetValue('OPR_txtPostoperAnti1Qty') + '`' + Common_GetValue('OPR_txtPostoperAnti1QtyUom') + '`' + Common_GetValue('OPR_txtPostoperAnti1Days');
		var PostoperAnti2 = Common_GetValue('OPR_cboPostoperAnti2') + '``' + Common_GetValue('OPR_txtPostoperAnti2Qty') + '`' + Common_GetValue('OPR_txtPostoperAnti2QtyUom') + '`' + Common_GetValue('OPR_txtPostoperAnti2Days');
		inputStr = inputStr + CHR_1 + PostoperAnti1 + ',' + PostoperAnti2;
		
		inputStr = inputStr + CHR_1 + Common_GetValue('OPR_txtInfDate');
		inputStr = inputStr + CHR_1 + Common_GetValue('OPR_cboInfPy');
		inputStr = inputStr + CHR_1 + Common_GetValue('OPR_cboOperInfType');
		inputStr = inputStr + CHR_1 + Common_GetValue('OPR_txtResumeText');
		inputStr = inputStr + CHR_1 + session['LOGON.CTLOCID'];
		inputStr = inputStr + CHR_1 + session['LOGON.USERID'];
		inputStr = inputStr + CHR_1 + StatusCode;
		
		var flg = obj.ClsAimReportOPRSrv.SaveReport(inputStr, CHR_1);
		if (parseInt(flg)<=0) {
			return false;
		} else {
			return true;
		}
		return true;
	}
	
	obj.OPR_GridRowDataSet = function(objRec)
	{
		if (objRec)
		{
			obj.OPR_valSubID = objRec.get('SubID');
			
			//��������,��������,��������,����ʱ��(��),�п�����,����ʽ,����,һ��,ASA����,��ע
			Common_SetValue('OPR_cboOperation',objRec.get('OperationID'),objRec.get('OperationDesc'));
			Common_SetValue('OPR_cboOperationType',objRec.get('OperationTypeID'),objRec.get('OperationTypeDesc'));
			Common_SetValue('OPR_cboOperationType1',objRec.get('OperationType1ID'),objRec.get('OperationType1Desc'));
			Common_SetValue('OPR_cboOperationType2',objRec.get('OperationType2ID'),objRec.get('OperationType2Desc'));
			Common_SetValue('OPR_txtOperDate',objRec.get('OperStartDate'));
			Common_SetValue('OPR_txtOperTimes',objRec.get('OperTimes'));
			Common_SetValue('OPR_cboOperCutType',objRec.get('OperCutTypeID'),objRec.get('OperCutTypeDesc'));
			Common_SetValue('OPR_cboOperNarcosisType',objRec.get('OperNarcosisTypeID'),objRec.get('OperNarcosisTypeDesc'));
			Common_SetValue('OPR_cboOperDoctor',objRec.get('OperDoctorID'),objRec.get('OperDoctorDesc'));
			Common_SetValue('OPR_cboAssistant1',objRec.get('Assistant1ID'),objRec.get('Assistant1Desc'));
			Common_SetValue('OPR_txtOperASAScore',objRec.get('OperASAScore'));
			Common_SetValue('OPR_txtResumeText',objRec.get('ResumeText'));
			
			//�����յ�����ҩ
			var strAntiValues = objRec.get('NarcosisAntiValues');
			var arrAntiValues = strAntiValues.split(CHR_1);
			if (arrAntiValues.length > 0)
			{
				var strAntiValue = arrAntiValues[0];
				var arrAntiValue = strAntiValue.split("`");
				if (arrAntiValue.length >= 5) {
					Common_SetValue('OPR_cboNarcosisAnti1',arrAntiValue[0],arrAntiValue[1]);
					Common_SetValue('OPR_txtNarcosisAnti1Qty',arrAntiValue[2]);
					Common_SetValue('OPR_txtNarcosisAnti1QtyUom',arrAntiValue[3]);
				}
			}
			if (arrAntiValues.length > 1)
			{
				var strAntiValue = arrAntiValues[1];
				var arrAntiValue = strAntiValue.split("`");
				if (arrAntiValue.length>=5) {
					Common_SetValue('OPR_cboNarcosisAnti2',arrAntiValue[0],arrAntiValue[1]);
					Common_SetValue('OPR_txtNarcosisAnti2Qty',arrAntiValue[2]);
					Common_SetValue('OPR_txtNarcosisAnti2QtyUom',arrAntiValue[3]);
				}
			}
			//����Ԥ������ҩ
			var strAntiValues = objRec.get('PostoperAntiValues');
			var arrAntiValues = strAntiValues.split(CHR_1);
			if (arrAntiValues.length > 0)
			{
				var strAntiValue = arrAntiValues[0];
				var arrAntiValue = strAntiValue.split("`");
				if (arrAntiValue.length>=5) {
					Common_SetValue('OPR_cboPostoperAnti1',arrAntiValue[0],arrAntiValue[1]);
					Common_SetValue('OPR_txtPostoperAnti1Qty',arrAntiValue[2]);
					Common_SetValue('OPR_txtPostoperAnti1QtyUom',arrAntiValue[3]);
					Common_SetValue('OPR_txtPostoperAnti1Days',arrAntiValue[4]);
				}
			}
			if (arrAntiValues.length > 1)
			{
				var strAntiValue = arrAntiValues[1];
				var arrAntiValue = strAntiValue.split("`");
				if (arrAntiValue.length>=5) {
					Common_SetValue('OPR_cboPostoperAnti2',arrAntiValue[0],arrAntiValue[1]);
					Common_SetValue('OPR_txtPostoperAnti2Qty',arrAntiValue[2]);
					Common_SetValue('OPR_txtPostoperAnti2QtyUom',arrAntiValue[3]);
					Common_SetValue('OPR_txtPostoperAnti2Days',arrAntiValue[4]);
				}
			}
			
			//�Ƿ��Ⱦ,��Ⱦ����,��ԭ��
			Common_SetValue('OPR_chkIsInf',(objRec.get('IsInfection')=='��'));
			Common_SetValue('OPR_txtInfDate',objRec.get('InfDate'));
			var strInfPyValues = objRec.get('InfPyValues');
			var arrInfPyValues = strInfPyValues.split(CHR_1);
			if (arrInfPyValues.length > 0) {
				var strInfPyValue = arrInfPyValues[0];
				var arrInfPyValue = strInfPyValue.split("`");
				if (arrInfPyValue.length >= 2) {
					Common_SetValue('OPR_cboInfPy',arrInfPyValue[0],arrInfPyValue[1]);
				}
			} else {
				Common_SetValue('OPR_cboInfPy','','');
			}
			Common_SetValue('OPR_cboOperInfType',objRec.get('OperInfTypeID'),objRec.get('OperInfTypeDesc'));
			
			var objItem1 = Ext.getCmp("OPR_txtInfDate");
			if (objItem1) {
				objItem1.setDisabled((objRec.get('IsInfection')!='��'));
			}
			var objItem1 = Ext.getCmp("OPR_cboInfPy");
			if (objItem1) {
				objItem1.setDisabled((objRec.get('IsInfection')!='��'));
			}
			var objItem1 = Ext.getCmp("OPR_cboOperInfType");
			if (objItem1) {
				objItem1.setDisabled((objRec.get('IsInfection')!='��'));
			}
		} else {
			obj.OPR_valSubID = '';
			Common_SetValue('OPR_cboOperation','','');
			Common_SetValue('OPR_cboOperationType','','');
			Common_SetValue('OPR_cboOperationType1','','');
			Common_SetValue('OPR_cboOperationType2','','');
			Common_SetValue('OPR_txtOperDate','');
			Common_SetValue('OPR_txtOperTimes','');
			Common_SetValue('OPR_cboOperCutType','','');
			Common_SetValue('OPR_cboOperNarcosisType','','');
			Common_SetValue('OPR_cboOperDoctor','','');
			Common_SetValue('OPR_cboAssistant1','','');
			Common_SetValue('OPR_txtOperASAScore','');
			Common_SetValue('OPR_txtResumeText','');
			Common_SetValue('OPR_chkIsInf','');
			Common_SetValue('OPR_txtInfDate','');
			Common_SetValue('OPR_cboInfPy','','');
			
			Common_SetValue('OPR_cboNarcosisAnti1','','');
			Common_SetValue('OPR_txtNarcosisAnti1Qty','');
			Common_SetValue('OPR_txtNarcosisAnti1QtyUom','');
			Common_SetValue('OPR_cboNarcosisAnti2','','');
			Common_SetValue('OPR_txtNarcosisAnti2Qty','');
			Common_SetValue('OPR_txtNarcosisAnti2QtyUom','');
			Common_SetValue('OPR_cboPostoperAnti1','','');
			Common_SetValue('OPR_txtPostoperAnti1Qty','');
			Common_SetValue('OPR_txtPostoperAnti1QtyUom','');
			Common_SetValue('OPR_txtPostoperAnti1Days','');
			Common_SetValue('OPR_cboPostoperAnti2','','');
			Common_SetValue('OPR_txtPostoperAnti2Qty','');
			Common_SetValue('OPR_txtPostoperAnti2QtyUom','');
			Common_SetValue('OPR_txtPostoperAnti2Days','');
			
			var objItem1 = Ext.getCmp("OPR_txtInfDate");
			if (objItem1) {
				objItem1.setDisabled(true);
			}
			var objItem1 = Ext.getCmp("OPR_cboInfPy");
			if (objItem1) {
				objItem1.setDisabled(true);
			}
			var objItem1 = Ext.getCmp("OPR_cboOperInfType");
			if (objItem1) {
				objItem1.setDisabled(true);
			}
		}
	}
	
	obj.OPR_GridRowEditer = function(objRec)
	{
		var winGridRowEditer = Ext.getCmp('OPR_GridRowEditer');
		if (!winGridRowEditer)
		{
			winGridRowEditer = new Ext.Window({
				id : 'OPR_GridRowEditer',
				height : 500,
				closeAction: 'hide',
				width : 700,
				modal : true,
				title : '������λ-�༭',
				layout : 'border',
				frame : true,
				items: [
					obj.gridAimOperation
					,obj.OPR_GridRowViewPort
				],
				bbar : [
					'->',
					new Ext.Toolbar.Button({
						id: "OPR_GridRowEditer_btnUpdate",
						width : 80,
						text : "<img SRC='../scripts/dhcmed/img/update.gif'>����",
						listeners : {
							'click' : function(){
								var errInfo = obj.OPR_GridRowDataCheck("1");
								if (errInfo)
								{
									ExtTool.alert("��ʾ",errInfo);
								} else {
									var flg = obj.OPR_GridRowDataSave("1")
									if (flg)
									{
										winGridRowEditer.hide();
										var objGrid = Ext.getCmp('OPR_gridOPR');
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
						id: "OPR_GridRowEditer_btnCommit",
						width : 80,
						text : "<img SRC='../scripts/dhcmed/img/update.png'>�ύ",
						listeners : {
							'click' : function(){
								var errInfo = obj.OPR_GridRowDataCheck("2");
								if (errInfo) {
									ExtTool.alert("��ʾ",errInfo);
								} else {
									var flg = obj.OPR_GridRowDataSave("2")
									if (flg) {
										winGridRowEditer.hide();
										var objGrid = Ext.getCmp('OPR_gridOPR');
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
						id: "OPR_GridRowEditer_btnCancel",
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
		obj.OPR_GridRowDataSet(objRec);
	}
	
	//�������
	obj.OPR_GridToOPR = function()
	{
		var tmpGridPanel = new Ext.grid.GridPanel({
			id: arguments[0],
			store : new Ext.data.Store({
				proxy: new Ext.data.HttpProxy({
					url : ExtToolSetting.RunQueryPageURL,
					listeners : {
						'beforeload' :  function(objProxy, param){
							param.ClassName = 'DHCMed.NINFService.Rep.AimReportOPR';
							param.QueryName = 'QryReportByID';
							param.Arg1      = obj.CurrReport.ChildOPR.RowID;
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
						,{name: 'OperationID', mapping: 'OperationID'}
						,{name: 'OperationDesc', mapping: 'OperationDesc'}
						,{name: 'OperStartDate', mapping: 'OperStartDate'}
						,{name: 'OperStartTime', mapping: 'OperStartTime'}
						,{name: 'OperStartDateTime', mapping: 'OperStartDateTime'}
						,{name: 'OperEndDate', mapping: 'OperEndDate'}
						,{name: 'OperEndTime', mapping: 'OperEndTime'}
						,{name: 'OperEndDateTime', mapping: 'OperEndDateTime'}
						,{name: 'OperTimes', mapping: 'OperTimes'}
						,{name: 'OperCutTypeID', mapping: 'OperCutTypeID'}
						,{name: 'OperCutTypeDesc', mapping: 'OperCutTypeDesc'}
						,{name: 'OperASAScore', mapping: 'OperASAScore'}
						,{name: 'OperNarcosisTypeID', mapping: 'OperNarcosisTypeID'}
						,{name: 'OperNarcosisTypeDesc', mapping: 'OperNarcosisTypeDesc'}
						,{name: 'OperationTypeID', mapping: 'OperationTypeID'}
						,{name: 'OperationTypeDesc', mapping: 'OperationTypeDesc'}
						,{name: 'OperationType1ID', mapping: 'OperationType1ID'}
						,{name: 'OperationType1Desc', mapping: 'OperationType1Desc'}
						,{name: 'OperationType2ID', mapping: 'OperationType2ID'}
						,{name: 'OperationType2Desc', mapping: 'OperationType2Desc'}
						,{name: 'OperDoctorID', mapping: 'OperDoctorID'}
						,{name: 'OperDoctorDesc', mapping: 'OperDoctorDesc'}
						,{name: 'Assistant1ID', mapping: 'Assistant1ID'}
						,{name: 'Assistant1Desc', mapping: 'Assistant1Desc'}
						,{name: 'Assistant2ID', mapping: 'Assistant2ID'}
						,{name: 'Assistant2Desc', mapping: 'Assistant2Desc'}
						,{name: 'NarcosisAntiIDs', mapping: 'NarcosisAntiIDs'}
						,{name: 'NarcosisAntiDescs', mapping: 'NarcosisAntiDescs'}
						,{name: 'NarcosisAntiValues', mapping: 'NarcosisAntiValues'}
						,{name: 'PostoperAntiIDs', mapping: 'PostoperAntiIDs'}
						,{name: 'PostoperAntiDescs', mapping: 'PostoperAntiDescs'}
						,{name: 'PostoperAntiValues', mapping: 'PostoperAntiValues'}
						,{name: 'IsInfection', mapping: 'IsInfection'}
						,{name: 'InfDate', mapping: 'InfDate'}
						,{name: 'InfPyIDs', mapping: 'InfPyIDs'}
						,{name: 'InfPyDescs', mapping: 'InfPyDescs'}
						,{name: 'InfPyValues', mapping: 'InfPyValues'}
						,{name: 'OperInfTypeID', mapping: 'OperInfTypeID'}
						,{name: 'OperInfTypeDesc', mapping: 'OperInfTypeDesc'}
						,{name: 'ResumeText', mapping: 'ResumeText'}
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
				,{header: '��������', width: 120, dataIndex: 'OperationDesc', sortable: false, menuDisabled:true, align:'center' }
				,{header: '����', width: 50, dataIndex: 'OperationTypeDesc', sortable: false, menuDisabled:true, align:'center' }
				,{header: '����', width: 50, dataIndex: 'OperationType1Desc', sortable: false, menuDisabled:true, align:'center' }
				,{header: '�ھ�', width: 50, dataIndex: 'OperationType2Desc', sortable: false, menuDisabled:true, align:'center' }
				,{header: '��������', width: 70, dataIndex: 'OperStartDate', sortable: false, menuDisabled:true, align:'center' }
				,{header: '����<br>ʱ��(��)', width: 60, dataIndex: 'OperTimes', sortable: false, menuDisabled:true, align:'center' }
				,{header: '�п�<br>����', width: 50, dataIndex: 'OperCutTypeDesc', sortable: false, menuDisabled:true, align:'center' }
				,{header: 'ASA<br>����', width: 50, dataIndex: 'OperASAScore', sortable: false, menuDisabled:true, align:'center' }
				,{header: '����ʽ', width: 80, dataIndex: 'OperNarcosisTypeDesc', sortable: false, menuDisabled:true, align:'center' }
				,{header: '����', width: 60, dataIndex: 'OperDoctorDesc', sortable: false, menuDisabled:true, align:'center' }
				,{header: 'һ��', width: 60, dataIndex: 'Assistant1Desc', sortable: false, menuDisabled:true, align:'center' }
				,{header: '�����յ�����ҩ', width: 150, dataIndex: 'NarcosisAntiDescs', sortable: false, menuDisabled:true, align:'center' }
				,{header: '����Ԥ������ҩ', width: 150, dataIndex: 'PostoperAntiDescs', sortable: false, menuDisabled:true, align:'center' }
				,{header: '�Ƿ�<br>��Ⱦ', width: 50, dataIndex: 'IsInfection', sortable: false, menuDisabled:true, align:'center' }
				,{header: '��Ⱦ����', width: 80, dataIndex: 'InfDate', sortable: false, menuDisabled:true, align:'center' }
				,{header: '��Ⱦ����', width: 80, dataIndex: 'OperInfTypeDesc', sortable: false, menuDisabled:true, align:'center' }
				,{header: '��ԭ��', width: 100, dataIndex: 'InfPyDescs', sortable: false, menuDisabled:true, align:'center' }
				,{header: '�ʱ��', width: 100, dataIndex: 'RepDateTime', sortable: false, menuDisabled:true, align:'center' }
				,{header: '�����', width: 100, dataIndex: 'RepLocDesc', sortable: false, menuDisabled:true, align:'center' }
				,{header: '���', width: 60, dataIndex: 'RepUserDesc', sortable: false, menuDisabled:true, align:'center' }
				,{header: '��ע', width: 100, dataIndex: 'ResumeText', sortable: false, menuDisabled:true, align:'center' }
			],
			bbar : [
				new Ext.Toolbar.Button({
					id: arguments[0] + "_btnAdd",
					width : 80,
					text : "<img SRC='../scripts/dhcmed/img/add.png'>����",
					listeners : {
						'click' : function(){
							obj.OPR_GridRowEditer("");
						}
					}
				}),
				new Ext.Toolbar.Button({
					id: arguments[0] + "_btnDelete",
					width : 80,
					text : "<img SRC='../scripts/dhcmed/img/delete.gif'>ɾ��",
					listeners : {
						'click' : function(){
							var objGrid = Ext.getCmp("OPR_gridOPR");
							if (objGrid){
								var objRecArr = objGrid.getSelectionModel().getSelections();
								if (objRecArr.length>0){
									Ext.MessageBox.confirm('ɾ��', '�Ƿ�ɾ�����ݼ�¼?', function(btn,text){
										if(btn=="yes"){
											for (var indRec = 0; indRec < objRecArr.length; indRec++){
												var objRec = objRecArr[indRec];
												var flg = obj.OPR_GridRowDataUpdateStatus('0',objRec);
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
							var objGrid = Ext.getCmp("OPR_gridOPR");
							if (objGrid){
								var objRecArr = objGrid.getSelectionModel().getSelections();
								if (objRecArr.length>0){
									for (var indRec = 0; indRec < objRecArr.length; indRec++){
										var objRec = objRecArr[indRec];
										var flg = obj.OPR_GridRowDataCheck('2',objRec);
										if (flg) {
											ExtTool.alert("��ʾ","������Ϣ������,�������ύ!" + flg);
											continue;
										}
										var flg = obj.OPR_GridRowDataUpdateStatus('2',objRec);
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
	
	//�������
	obj.OPR_gridOPR = obj.OPR_GridToOPR("OPR_gridOPR");
	
	obj.OPR_txtRegNo = Common_TextField("OPR_txtRegNo","�ǼǺ�");
	obj.OPR_txtPatName = Common_TextField("OPR_txtPatName","����");
	obj.OPR_txtPatSex = Common_TextField("OPR_txtPatSex","�Ա�");
	obj.OPR_txtPatAge = Common_TextField("OPR_txtPatAge","����");
	
	obj.OPR_txtAdmDate = Common_TextField("OPR_txtAdmDate","��Ժ����");
	obj.OPR_txtAdmLoc = Common_TextField("OPR_txtAdmLoc","��ǰ����");
	obj.OPR_txtAdmWard = Common_TextField("OPR_txtAdmWard","��ǰ����");
	obj.OPR_txtAdmBed = Common_TextField("OPR_txtAdmBed","����");
	
	obj.OPR_txtTransLoc = Common_TextField("OPR_txtTransLoc","ת�����");
	obj.OPR_txtTransInDate = Common_TextField("OPR_txtTransInDate","�������");
	obj.OPR_txtTransOutDate = Common_TextField("OPR_txtTransOutDate","��������");
	obj.OPR_txtTransFormLoc = Common_TextField("OPR_txtTransFormLoc","�����Դ");
	obj.OPR_txtTransToLoc = Common_TextField("OPR_txtTransToLoc","����ȥ��");
	
	obj.OPR_txtRegNo.setDisabled(true);
	obj.OPR_txtPatName.setDisabled(true);
	obj.OPR_txtPatSex.setDisabled(true);
	obj.OPR_txtPatAge.setDisabled(true);
	
	obj.OPR_txtAdmDate.setDisabled(true);
	obj.OPR_txtAdmLoc.setDisabled(true);
	obj.OPR_txtAdmWard.setDisabled(true);
	obj.OPR_txtAdmBed.setDisabled(true);
	
	obj.OPR_txtTransLoc.setDisabled(true);
	obj.OPR_txtTransInDate.setDisabled(true);
	obj.OPR_txtTransOutDate.setDisabled(true);
	obj.OPR_txtTransFormLoc.setDisabled(true);
	obj.OPR_txtTransToLoc.setDisabled(true);
	
	//������Ϣ
	obj.OPR_FormToPAT = function()
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
							items : [obj.OPR_txtRegNo]
						},{
							columnWidth:.25,
							layout : 'form',
							labelAlign : 'right',
							labelWidth : 60,
							items : [obj.OPR_txtPatName]
						},{
							columnWidth:.25,
							layout : 'form',
							labelAlign : 'right',
							labelWidth : 60,
							items : [obj.OPR_txtPatSex]
						},{
							columnWidth:.25,
							layout : 'form',
							labelAlign : 'right',
							labelWidth : 60,
							items : [obj.OPR_txtPatAge]
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
							items : [obj.OPR_txtAdmDate]
						},{
							columnWidth:.25,
							layout : 'form',
							labelAlign : 'right',
							labelWidth : 60,
							items : [obj.OPR_txtAdmLoc]
						},{
							columnWidth:.25,
							layout : 'form',
							labelAlign : 'right',
							labelWidth : 60,
							items : [obj.OPR_txtAdmWard]
						},{
							columnWidth:.25,
							layout : 'form',
							labelAlign : 'right',
							labelWidth : 60,
							items : [obj.OPR_txtAdmBed]
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
							items : [obj.OPR_txtTransLoc]
						},{
							columnWidth:.25,
							layout : 'form',
							labelAlign : 'right',
							labelWidth : 60,
							items : [obj.OPR_txtTransInDate]
						},{
							columnWidth:.25,
							layout : 'form',
							labelAlign : 'right',
							labelWidth : 60,
							items : [obj.OPR_txtTransOutDate]
						},{
							columnWidth:.25,
							layout : 'form',
							labelAlign : 'right',
							labelWidth : 60,
							items : [obj.OPR_txtTransToLoc]
						}
					]
				}
			]
		}
		
		return tmpFormPanel;
	}
	
	//������Ϣ
	obj.OPR_formPAT = obj.OPR_FormToPAT("OPR_formPAT");
	
	//��ʼ��ҳ��
	obj.OPR_FormPatDataSet = function()
	{
		var objPaadm = obj.ClsBasePatientAdm.GetObjById(obj.CurrReport.ChildOPR.EpisodeID);
		if (objPaadm) {
			var PatientID = objPaadm.PatientID;
			var objPatient = obj.ClsBasePatient.GetObjById(PatientID);
			if (objPatient) {
				Common_SetValue('OPR_txtRegNo',objPatient.PapmiNo);
				Common_SetValue('OPR_txtPatName',objPatient.PatientName);
				Common_SetValue('OPR_txtPatSex',objPatient.Sex);
				var Age = objPatient.Age;
				var Month = objPatient.AgeMonth;
				var Day = objPatient.AgeDay;
				if (!Age) Age=0;
				if (!Month) Month=0;
				if (!Day) Day=0;
				if (parseInt(Age) > 0) {
					Common_SetValue('OPR_txtPatAge',parseInt(Age) + '��');
				} else {
					Common_SetValue('OPR_txtPatAge',parseInt(Month) + '��' + parseInt(Day) + '��');
				}
			}
			Common_SetValue('OPR_txtAdmDate',objPaadm.AdmitDate + ' ' + objPaadm.AdmitTime);
			Common_SetValue('OPR_txtAdmLoc',objPaadm.Department);
			Common_SetValue('OPR_txtAdmWard',objPaadm.Ward);
			Common_SetValue('OPR_txtAdmBed',objPaadm.Bed + "��");
		}
		
		var strTransLoc = obj.ClsCommonClsSrv.GetAdmTrans(obj.CurrReport.ChildOPR.TransID,obj.CurrReport.ChildOPR.TransLoc);
		var arrTransLoc = strTransLoc.split(CHR_1);
		if (arrTransLoc.length>=10)
		{
			Common_SetValue('OPR_txtTransInDate',arrTransLoc[6] + ' ' + arrTransLoc[7]);
			Common_SetValue('OPR_txtTransOutDate',arrTransLoc[8] + ' ' + arrTransLoc[9]);
			Common_SetValue('OPR_txtTransLoc',arrTransLoc[1]);
			Common_SetValue('OPR_txtTransFormLoc',arrTransLoc[3]);
			Common_SetValue('OPR_txtTransToLoc',arrTransLoc[5]);
		}
	}
	
	obj.OPR_ViewPort = {
		layout : 'border',
		title : '������λ',
		items : [
			{
				layout : 'fit',
				region : 'north',
				height : 100,
				frame : true,
				items : [obj.OPR_formPAT]
			},{
				layout : 'fit',
				region: 'center',
				frame : true,
				items : [obj.OPR_gridOPR]
			}
		]
	}
	
	obj.OPR_InitView = function(){
		var objGrid = Ext.getCmp("OPR_gridOPR");
		if (objGrid){
			objGrid.getStore().load({});
			objGrid.on('rowdblclick',function(){
				var rowIndex = arguments[1];
				var objRec = this.getStore().getAt(rowIndex);
				obj.OPR_GridRowEditer(objRec);
			},objGrid);
		}
		obj.OPR_FormPatDataSet();
	}
	
	return obj;
}