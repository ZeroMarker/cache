
function InitNOTH(obj)
{
	//��������
	obj.NOTH_txtBornWeight = Common_NumberField("NOTH_txtBornWeight","��������(gm)");
	
	//���水ť
	obj.NOTH_btnUpdate = new Ext.Button({
		id : 'NOTH_btnUpdate'
		,iconCls : 'icon-update'
		,width : 60
		,text : '����'
		,listeners : {
			'click' :  function(){
				obj.NOTH_btnUpdate_click();
			}
		}
	});
	
	obj.NOTH_btnUpdate_click = function(){
		var inputStr = obj.CurrReport.ChildNICU.RowID;
		inputStr = inputStr + CHR_1 + obj.CurrReport.ChildNICU.ReportTypeCode;
		inputStr = inputStr + CHR_1 + obj.CurrReport.ChildNICU.EpisodeID;
		inputStr = inputStr + CHR_1 + obj.CurrReport.ChildNICU.TransID;
		inputStr = inputStr + CHR_1 + obj.CurrReport.ChildNICU.TransLoc;
		inputStr = inputStr + CHR_1 + "";
		inputStr = inputStr + CHR_1 + "";
		inputStr = inputStr + CHR_1 + "";
		inputStr = inputStr + CHR_1 + "";
		inputStr = inputStr + CHR_1 + Common_GetValue('NOTH_txtBornWeight');
		inputStr = inputStr + CHR_1 + session['LOGON.CTLOCID'];
		inputStr = inputStr + CHR_1 + session['LOGON.USERID'];
		inputStr = inputStr + CHR_1 + '';
		var flg = obj.ClsAimReportSrv.SaveReport(inputStr, CHR_1);
		if (parseInt(flg)<=0) {
			ExtTool.alert("��ʾ","�������ݴ���!Error=" + flg);
		} else {
			var objAimReport = obj.ClsAimReport.GetObjById(flg);
			objAimReport.ReportTypeCode = '';
			var objDictionary = obj.ClsSSDictionary.GetObjById(objAimReport.ReportType);
			if (objDictionary) {
				objAimReport.ReportTypeCode = objDictionary.Code;
			}
			obj.CurrReport.ChildNICU = objAimReport;
			ExtTool.alert("��ʾ","����ɹ�!");
		}
	}
	
	obj.NOTH_formNOTH = new Ext.Panel({
		id : 'NOTH_formNOTH',
		layout : 'fit',
		items : [
			{
				layout : 'column',
				items : [
					{
						columnWidth:.50
					},{
						width:240,
						layout : 'form',
						labelAlign : 'right',
						labelWidth : 100,
						items : [
							obj.NOTH_txtBornWeight
						]
					},{
						width:80,
						layout : 'form',
						items : [
							obj.NOTH_btnUpdate
						]
					},{
						columnWidth:.50
					}
				]
			}
		]
	});
	
	obj.NOTH_FormDataSet = function()
	{
		Common_SetValue('NOTH_txtBornWeight',obj.CurrReport.ChildNICU.BornWeight);
	}
	
	obj.NOTH_txtRegNo = Common_TextField("NOTH_txtRegNo","�ǼǺ�");
	obj.NOTH_txtPatName = Common_TextField("NOTH_txtPatName","����");
	obj.NOTH_txtPatSex = Common_TextField("NOTH_txtPatSex","�Ա�");
	obj.NOTH_txtPatAge = Common_TextField("NOTH_txtPatAge","����");
	
	obj.NOTH_txtAdmDate = Common_TextField("NOTH_txtAdmDate","��Ժ����");
	obj.NOTH_txtAdmLoc = Common_TextField("NOTH_txtAdmLoc","��ǰ����");
	obj.NOTH_txtAdmWard = Common_TextField("NOTH_txtAdmWard","��ǰ����");
	obj.NOTH_txtAdmBed = Common_TextField("NOTH_txtAdmBed","����");
	
	obj.NOTH_txtTransLoc = Common_TextField("NOTH_txtTransLoc","ת�����");
	obj.NOTH_txtTransInDate = Common_TextField("NOTH_txtTransInDate","�������");
	obj.NOTH_txtTransOutDate = Common_TextField("NOTH_txtTransOutDate","��������");
	obj.NOTH_txtTransFormLoc = Common_TextField("NOTH_txtTransFormLoc","�����Դ");
	obj.NOTH_txtTransToLoc = Common_TextField("NOTH_txtTransToLoc","����ȥ��");
	
	obj.NOTH_txtRegNo.setDisabled(true);
	obj.NOTH_txtPatName.setDisabled(true);
	obj.NOTH_txtPatSex.setDisabled(true);
	obj.NOTH_txtPatAge.setDisabled(true);
	
	obj.NOTH_txtAdmDate.setDisabled(true);
	obj.NOTH_txtAdmLoc.setDisabled(true);
	obj.NOTH_txtAdmWard.setDisabled(true);
	obj.NOTH_txtAdmBed.setDisabled(true);
	
	obj.NOTH_txtTransLoc.setDisabled(true);
	obj.NOTH_txtTransInDate.setDisabled(true);
	obj.NOTH_txtTransOutDate.setDisabled(true);
	obj.NOTH_txtTransFormLoc.setDisabled(true);
	obj.NOTH_txtTransToLoc.setDisabled(true);
	
	//������Ϣ
	obj.NOTH_FormToPAT = function()
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
							items : [obj.NOTH_txtRegNo]
						},{
							columnWidth:.25,
							layout : 'form',
							labelAlign : 'right',
							labelWidth : 60,
							items : [obj.NOTH_txtPatName]
						},{
							columnWidth:.25,
							layout : 'form',
							labelAlign : 'right',
							labelWidth : 60,
							items : [obj.NOTH_txtPatSex]
						},{
							columnWidth:.25,
							layout : 'form',
							labelAlign : 'right',
							labelWidth : 60,
							items : [obj.NOTH_txtPatAge]
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
							items : [obj.NOTH_txtAdmDate]
						},{
							columnWidth:.25,
							layout : 'form',
							labelAlign : 'right',
							labelWidth : 60,
							items : [obj.NOTH_txtAdmLoc]
						},{
							columnWidth:.25,
							layout : 'form',
							labelAlign : 'right',
							labelWidth : 60,
							items : [obj.NOTH_txtAdmWard]
						},{
							columnWidth:.25,
							layout : 'form',
							labelAlign : 'right',
							labelWidth : 60,
							items : [obj.NOTH_txtAdmBed]
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
							items : [obj.NOTH_txtTransLoc]
						},{
							columnWidth:.25,
							layout : 'form',
							labelAlign : 'right',
							labelWidth : 60,
							items : [obj.NOTH_txtTransInDate]
						},{
							columnWidth:.25,
							layout : 'form',
							labelAlign : 'right',
							labelWidth : 60,
							items : [obj.NOTH_txtTransOutDate]
						},{
							columnWidth:.25,
							layout : 'form',
							labelAlign : 'right',
							labelWidth : 60,
							items : [obj.NOTH_txtTransToLoc]
						}
					]
				}
			]
		}
		
		return tmpFormPanel;
	}
	
	//������Ϣ
	obj.NOTH_formPAT = obj.NOTH_FormToPAT("NOTH_formPAT");
	
	//��ʼ��ҳ��
	obj.NOTH_FormPatDataSet = function()
	{
		var objPaadm = obj.ClsBasePatientAdm.GetObjById(obj.CurrReport.ChildNICU.EpisodeID);
		if (objPaadm) {
			var PatientID = objPaadm.PatientID;
			var objPatient = obj.ClsBasePatient.GetObjById(PatientID);
			if (objPatient) {
				Common_SetValue('NOTH_txtRegNo',objPatient.PapmiNo);
				Common_SetValue('NOTH_txtPatName',objPatient.PatientName);
				Common_SetValue('NOTH_txtPatSex',objPatient.Sex);
				var Age = objPatient.Age;
				var Month = objPatient.AgeMonth;
				var Day = objPatient.AgeDay;
				if (!Age) Age=0;
				if (!Month) Month=0;
				if (!Day) Day=0;
				if (parseInt(Age) > 0) {
					Common_SetValue('NOTH_txtPatAge',parseInt(Age) + '��');
				} else {
					Common_SetValue('NOTH_txtPatAge',parseInt(Month) + '��' + parseInt(Day) + '��');
				}
			}
			Common_SetValue('NOTH_txtAdmDate',objPaadm.AdmitDate + ' ' + objPaadm.AdmitTime);
			Common_SetValue('NOTH_txtAdmLoc',objPaadm.Department);
			Common_SetValue('NOTH_txtAdmWard',objPaadm.Ward);
			Common_SetValue('NOTH_txtAdmBed',objPaadm.Bed + "��");
		}
		
		var strTransLoc = obj.ClsCommonClsSrv.GetAdmTrans(obj.CurrReport.ChildNICU.TransID,obj.CurrReport.ChildNICU.TransLoc);
		var arrTransLoc = strTransLoc.split(CHR_1);
		if (arrTransLoc.length>=10)
		{
			Common_SetValue('NOTH_txtTransInDate',arrTransLoc[6] + ' ' + arrTransLoc[7]);
			Common_SetValue('NOTH_txtTransOutDate',arrTransLoc[8] + ' ' + arrTransLoc[9]);
			Common_SetValue('NOTH_txtTransLoc',arrTransLoc[1]);
			Common_SetValue('NOTH_txtTransFormLoc',arrTransLoc[3]);
			Common_SetValue('NOTH_txtTransToLoc',arrTransLoc[5]);
		}
	}
	
	obj.NOTH_ViewPort = {
		layout : 'border',
		title : 'NICU-����',
		items : [
			{
				layout : 'fit',
				region : 'north',
				height : 100,
				frame : true,
				items : [obj.NOTH_formPAT]
			},{
				layout : 'fit',
				region: 'center',
				frame : true,
				items : [obj.NOTH_formNOTH]
			}
		]
	}
	
	obj.NOTH_InitView = function(){
		obj.NOTH_FormDataSet();
		obj.NOTH_FormPatDataSet();
	}
		
	return obj;
}