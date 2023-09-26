
function InitIBASE(obj)
{
	//��ʾ������Ϣ
	obj.IBASE_txtRegNo = Common_TextField("IBASE_txtRegNo","�ǼǺ�");
	obj.IBASE_txtPatName = Common_TextField("IBASE_txtPatName","����");
	obj.IBASE_txtPatSex = Common_TextField("IBASE_txtPatSex","�Ա�");
	obj.IBASE_txtPatAge = Common_TextField("IBASE_txtPatAge","����");
	obj.IBASE_txtMrNo = Common_TextField("IBASE_txtMrNo","������");
	obj.IBASE_txtAdmLoc = Common_TextField("IBASE_txtAdmLoc","��ǰ����");
	obj.IBASE_txtAdmDate = Common_TextField("IBASE_txtAdmDate","��Ժ����");
	obj.IBASE_txtDisDate = Common_TextField("IBASE_txtDisDate","��Ժ����");
	obj.IBASE_txtAdmDays = Common_TextField("IBASE_txtAdmDays","סԺ����");
	obj.IBASE_txtAdmBed = Common_TextField("IBASE_txtAdmBed","����");
	obj.IBASE_txtRepDate = Common_TextField("IBASE_txtRepDate","�����");
	obj.IBASE_txtRepUser = Common_TextField("IBASE_txtRepUser","���"); 
	obj.IBASE_txtRepStatus = Common_TextField("IBASE_txtRepStatus","����״̬");
	obj.IBASE_txtRepLoc = Common_TextField("IBASE_txtRepLoc","�����");
	obj.IBASE_txtInICUDate = Common_TextField("IBASE_txtInICUDate","�������");
	obj.IBASE_txtOutICUDate = Common_TextField("IBASE_txtOutICUDate","��������");
	obj.IBASE_txtFromLoc = Common_TextField("IBASE_txtFromLoc","�����Դ");
	obj.IBASE_txtToLoc = Common_TextField("IBASE_txtToLoc","����ȥ��");
	obj.IBASE_cboTransLoc = Common_ComboToTransLoc("IBASE_cboTransLoc","�������",obj.CurrReport.EpisodeID,"W");
	//Add By LiYang 2014-04-09 ����ApacheII����
	obj.IBASE_txtApacheII = Common_TextField("IBASE_txtApacheII","ApacheII����");
	
	Common_SetDisabled("IBASE_txtRegNo",true);
	Common_SetDisabled("IBASE_txtPatName",true);
	Common_SetDisabled("IBASE_txtPatSex",true);
	Common_SetDisabled("IBASE_txtPatAge",true);
	Common_SetDisabled("IBASE_txtMrNo",true);
	Common_SetDisabled("IBASE_txtAdmLoc",true);
	Common_SetDisabled("IBASE_txtAdmDate",true);
	Common_SetDisabled("IBASE_txtDisDate",true);
	Common_SetDisabled("IBASE_txtAdmDays",true);
	Common_SetDisabled("IBASE_txtAdmBed",true);
	Common_SetDisabled("IBASE_txtRepLoc",true);
	Common_SetDisabled("IBASE_txtRepUser",true);
	Common_SetDisabled("IBASE_txtRepDate",true);
	Common_SetDisabled("IBASE_txtRepStatus",true);
	Common_SetDisabled("IBASE_txtInICUDate",true);
	Common_SetDisabled("IBASE_txtOutICUDate",true);
	Common_SetDisabled("IBASE_txtFromLoc",true);
	Common_SetDisabled("IBASE_txtToLoc",true);
	//Add By LiYang 2014-04-09 ����ApacheII����
	Common_SetDisabled("IBASE_txtApacheII",false);
	
	//ת��ICUʱ״̬(����/������)
	obj.IBASE_cbgOutICUStatus = Common_CheckboxGroupToDic("IBASE_cbgOutICUStatus","ת��ICUʱ�������","NINFICUOutICUStatus",6);
	//ת��48Сʱ��״̬(����/������)
	obj.IBASE_cbgOutICU48Status = Common_CheckboxGroupToDic("IBASE_cbgOutICU48Status","��ICU48Сʱ�ڴ������","NINFICUOutICU48Status",6);
	//ϵͳ֢״
	obj.IBASE_txtSystemSymptom = Common_TextArea("IBASE_txtSystemSymptom","ϵͳ֢״",50);
	//�ֲ�֢״/����
	obj.IBASE_txtLocalSymptom = Common_TextArea("IBASE_txtLocalSymptom","�ֲ�֢״/����",50);
	
	//������Ϣ ���沼��
	obj.IBASE_ViewPort = {
		//title : '������Ϣ',
		layout : 'border',
		//frame : true,
		height : 320,
		anchor : '-20',
		tbar : ['<b>���˻�����Ϣ</b>'],
		items : [
			{
				region: 'center',
				layout : 'form',
				height : 205,
				frame : true,
				items : [
					{
						layout : 'column',
						items : [
							{
								columnWidth:.23,
								layout : 'form',
								labelAlign : 'right',
								labelWidth : 80,
								items : [obj.IBASE_txtRegNo,obj.IBASE_txtAdmLoc,obj.IBASE_cboTransLoc]
							},{
								columnWidth:.23,
								layout : 'form',
								labelAlign : 'right',
								labelWidth : 80,
								items : [obj.IBASE_txtPatName,obj.IBASE_txtAdmDate,obj.IBASE_txtRepLoc]
							},{
								columnWidth:.23,
								layout : 'form',
								labelAlign : 'right',
								labelWidth : 80,
								items : [obj.IBASE_txtMrNo,obj.IBASE_txtDisDate,obj.IBASE_txtRepDate]
							},{
								columnWidth:.15,
								layout : 'form',
								labelAlign : 'right',
								labelWidth : 80,
								items : [obj.IBASE_txtPatSex,obj.IBASE_txtAdmDays,obj.IBASE_txtRepUser]
							},{
								columnWidth:.15,
								layout : 'form',
								labelAlign : 'right',
								labelWidth : 80,
								items : [obj.IBASE_txtPatAge,obj.IBASE_txtAdmBed,obj.IBASE_txtRepStatus]
							}
						]
					},{
						layout : 'column',
						items : [
							{
								columnWidth:.23,
								layout : 'form',
								labelAlign : 'right',
								labelWidth : 80,
								items : [obj.IBASE_txtInICUDate]
							},{
								columnWidth:.23,
								layout : 'form',
								labelAlign : 'right',
								labelWidth : 80,
								items : [obj.IBASE_txtOutICUDate]
							},{
								columnWidth:.23,
								layout : 'form',
								labelAlign : 'right',
								labelWidth : 80,
								items : [obj.IBASE_txtFromLoc]
							},{
								columnWidth:.15,
								layout : 'form',
								labelAlign : 'right',
								labelWidth : 80,
								items : [obj.IBASE_txtToLoc]
							},{
								columnWidth:.15,
								layout : 'form',
								labelAlign : 'right',
								labelWidth : 80,
								items : [obj.IBASE_txtApacheII]
							}
						]
					},{
						layout : 'form',
						labelAlign : 'right',
						labelWidth : 80,
						items : [obj.IBASE_txtSystemSymptom]
					},{
						layout : 'form',
						labelAlign : 'right',
						labelWidth : 80,
						items : [obj.IBASE_txtLocalSymptom]
					},{
						layout : 'form',
						labelAlign : 'right',
						labelWidth : 150,
						items : [obj.IBASE_cbgOutICUStatus]
					},{
						layout : 'form',
						labelAlign : 'right',
						labelWidth : 150,
						items : [obj.IBASE_cbgOutICU48Status]
					}
				]
			}
		]
	}
	
	//������Ϣ �����ʼ��
	obj.IBASE_InitView = function(){
		var objPaadm = obj.CurrPaadm;
		if (objPaadm) {
			//������Ϣ
			Common_SetValue("IBASE_txtAdmDate",objPaadm.AdmitDate);
			//������Ϣ
			var objPatient = obj.CurrPatient;
			if (objPatient) {
				Common_SetValue('IBASE_txtRegNo',objPatient.PapmiNo);
				Common_SetValue('IBASE_txtPatName',objPatient.PatientName);
				Common_SetValue('IBASE_txtPatSex',objPatient.Sex);
				var Age = objPatient.Age;
				var Month = objPatient.AgeMonth;
				var Day = objPatient.AgeDay;
				if (!Age) Age=0;
				if (!Month) Month=0;
				if (!Day) Day=0;
				if (parseInt(Age) > 0) {
					Common_SetValue('IBASE_txtPatAge',parseInt(Age) + '��');
				} else {
					Common_SetValue('IBASE_txtPatAge',parseInt(Month) + '��' + parseInt(Day) + '��');
				}
				//update by zf 2013-05-14
				var MrNo=obj.ClsCommonClsSrv.GetMrNoByAdm(obj.CurrReport.EpisodeID);
				if (MrNo){
					objPaadm.MrNo = MrNo;
					Common_SetValue('IBASE_txtMrNo',MrNo);
				} else {
					Common_SetValue('IBASE_txtMrNo',objPatient.InPatientMrNo);
				}
				Common_SetValue('IBASE_txtAdmLoc',objPaadm.Department);
				Common_SetValue('IBASE_txtAdmDate',objPaadm.AdmitDate + ' ' + objPaadm.AdmitTime);
				Common_SetValue('IBASE_txtDisDate',objPaadm.DisDate + ' ' + objPaadm.DisTime);
				Common_SetValue('IBASE_txtAdmBed',objPaadm.Bed);
				Common_SetValue('IBASE_txtAdmDays',objPaadm.Days);
			}
			//������Ϣ
			Common_SetValue("IBASE_txtRepLoc",obj.CurrReport.ReportLoc ? obj.CurrReport.ReportLoc.Descs : '');
			Common_SetValue("IBASE_txtRepUser",obj.CurrReport.ReportUser ? obj.CurrReport.ReportUser.Name : '');
			Common_SetValue("IBASE_txtRepDate",obj.CurrReport.ReportDate + " " + obj.CurrReport.ReportTime);
			Common_SetValue("IBASE_txtRepStatus",obj.CurrReport.ReportStatus ? obj.CurrReport.ReportStatus.Description : '');
			
			//ת��ICUʱ״̬(�������)
			var varOutICUStatus = '';
			if (obj.CurrReport.ChildSumm.OutICUStatus) {
				var arrOutICUStatus = obj.CurrReport.ChildSumm.OutICUStatus;
				for (var ind = 0; ind < arrOutICUStatus.length; ind++) {
					var objDic = arrOutICUStatus[ind];
					if (objDic) {
						varOutICUStatus = (varOutICUStatus == '' ? objDic.RowID : varOutICUStatus + ',' + objDic.RowID);
					}
				}
			}
			Common_SetValue('IBASE_cbgOutICUStatus',varOutICUStatus);
			//ת��ICU48Сʱ��״̬(�������)
			var varOutICU48Status = '';
			if (obj.CurrReport.ChildSumm.OutICU48Status) {
				var arrOutICU48Status = obj.CurrReport.ChildSumm.OutICU48Status;
				for (var ind = 0; ind < arrOutICU48Status.length; ind++) {
					var objDic = arrOutICU48Status[ind];
					if (objDic) {
						varOutICU48Status = (varOutICU48Status == '' ? objDic.RowID : varOutICU48Status + ',' + objDic.RowID);
					}
				}
			}
			Common_SetValue('IBASE_cbgOutICU48Status',varOutICU48Status);
			
			//ϵͳ֢״���ֲ�֢״/����
			Common_SetValue('IBASE_txtSystemSymptom',obj.CurrReport.ChildSumm.SystemSymptom);
			Common_SetValue('IBASE_txtLocalSymptom',obj.CurrReport.ChildSumm.LocalSymptom);
			
			//Add By LiYang 2014-04-09 ����ApacheII����
			Common_SetValue("IBASE_txtApacheII",obj.CurrReport.ChildSumm.ApacheIIScore);
		}
		
		//��ʼ���������
		obj.IBASE_cboTransLoc_Init();
		obj.IBASE_cboTransLoc.on('select',obj.IBASE_cboTransLoc_select);
	}
	
	//������Ҵ����¼�
	obj.IBASE_TransRecord = new Object();
	obj.IBASE_TransRecord.TransID = '';
	obj.IBASE_TransRecord.TransLocID = '';
	obj.IBASE_TransRecord.TransLocDesc = '';
	obj.IBASE_TransRecord.FromLocDesc = '';
	obj.IBASE_TransRecord.ToLocDesc = '';
	obj.IBASE_TransRecord.TransInTime = '';
	obj.IBASE_TransRecord.TransOutTime = '';
	obj.IBASE_TransRecord.ObjectID = '';
	obj.IBASE_TransRecord.ReportID = '';
	obj.IBASE_cboTransLoc_select = function(){
		var xTransID = Common_GetValue('IBASE_cboTransLoc');
		var objTransLocStore = obj.IBASE_cboTransLoc.getStore();
		var ind = objTransLocStore.find("TransID",xTransID);
		if (ind > -1) {
			var objRec = objTransLocStore.getAt(ind);
			obj.IBASE_TransRecord.TransID = objRec.get('TransID');
			obj.IBASE_TransRecord.TransLocID = objRec.get('TransLocID');
			obj.IBASE_TransRecord.TransLocDesc = objRec.get('TransLocDesc');
			obj.IBASE_TransRecord.FromLocDesc = objRec.get('PrevLocDesc');
			obj.IBASE_TransRecord.ToLocDesc = objRec.get('NextLocDesc');
			obj.IBASE_TransRecord.TransInTime = objRec.get('TransInTime');
			obj.IBASE_TransRecord.TransOutTime = objRec.get('TransOutTime');
			obj.IBASE_TransRecord.ObjectID = obj.ClsInfReportSrv.GetObjectID(obj.CurrReport.EpisodeID,obj.CurrReport.ReportType.RowID,obj.IBASE_TransRecord.TransID);
			obj.IBASE_TransRecord.ReportID = obj.ClsInfReportSrv.GetReportID(obj.CurrReport.EpisodeID,obj.CurrReport.ReportType.RowID,obj.IBASE_TransRecord.ObjectID);
			
			if (obj.IBASE_TransRecord.ReportID != obj.CurrReport.RowID) {
				Ext.MessageBox.confirm('��ʾ', '���ĵ�����ң����ʼ���������ݣ�ȷ���Ƿ���ģ�', function(btn,text){
					if (btn == 'yes') {
						obj.CurrReport = obj.GetReport(obj.IBASE_TransRecord.ReportID);
						obj.CurrReport.ChildSumm.TransID = obj.IBASE_TransRecord.TransID;
						obj.CurrReport.ChildSumm.TransLoc = obj.ClsBaseCtloc.GetObjById(obj.IBASE_TransRecord.TransLocID);
						obj.CurrReport.ObjectID = obj.IBASE_TransRecord.ObjectID;
						if (obj.CurrReport) obj.InitReport();
					} else {
						var xTransID = obj.CurrReport.ChildSumm.TransID;
						var xTransLocDesc = '';
						var objTransLocStore = obj.IBASE_cboTransLoc.getStore();
						var ind = objTransLocStore.find("TransID",xTransID);
						if (ind > -1) {
							var objRec = objTransLocStore.getAt(ind);
							var xTransID = objRec.get('TransID');
							var xTransLocDesc = objRec.get('TransLocDesc');
						}
						obj.IBASE_cboTransLoc.setValue(xTransID);
						obj.IBASE_cboTransLoc.setRawValue(xTransLocDesc);
					}
				});
			} else {
				if (obj.IBASE_TransRecord.TransID != obj.CurrReport.ChildSumm.TransID) {
					obj.CurrReport.ChildSumm.TransID = obj.IBASE_TransRecord.TransID;
					obj.CurrReport.ChildSumm.TransLoc = obj.ClsBaseCtloc.GetObjById(obj.IBASE_TransRecord.TransLocID);
					obj.CurrReport.ObjectID = obj.IBASE_TransRecord.ObjectID;
					
					Common_SetValue('IBASE_txtFromLoc',obj.IBASE_TransRecord.FromLocDesc);
					Common_SetValue('IBASE_txtToLoc',obj.IBASE_TransRecord.ToLocDesc);
					Common_SetValue('IBASE_txtInICUDate',obj.IBASE_TransRecord.TransInTime);
					Common_SetValue('IBASE_txtOutICUDate',obj.IBASE_TransRecord.TransOutTime);
				}
			}
		}
	}
	
	//������ҳ�ʼ��
	obj.IBASE_cboTransLoc_Init = function(){
		var xTransID = '';
		var xTransLocDesc = '';
		var xFromLocDesc = '';
		var xToLocDesc = '';
		var xTransInTime = '';
		var xTransOutTime = '';
		
		var objTransLocStore = obj.IBASE_cboTransLoc.getStore();
		if (obj.CurrReport.ChildSumm.TransID != '') {
			for (var indRec = 0; indRec < objTransLocStore.getCount(); indRec++) {
				var objRec = objTransLocStore.getAt(indRec);
				if (objRec.get('TransID') == obj.CurrReport.ChildSumm.TransID) {
					var xTransID = objRec.get('TransID');
					var xTransLocID = objRec.get('TransLocID');
					var xTransLocDesc = objRec.get('TransLocDesc');
					var xFromLocDesc = objRec.get('PrevLocDesc');
					var xToLocDesc = objRec.get('NextLocDesc');
					var xTransInTime = objRec.get('TransInTime');
					var xTransOutTime = objRec.get('TransOutTime');
				}
			}
		} else {
			if (TransLoc !='') {
				for (var indRec = 0; indRec < objTransLocStore.getCount(); indRec++) {
					var objRec = objTransLocStore.getAt(indRec);
					if (objRec.get('TransLocID') == TransLoc) {
						var xTransID = objRec.get('TransID');
						var xTransLocID = objRec.get('TransLocID');
						var xTransLocDesc = objRec.get('TransLocDesc');
						var xFromLocDesc = objRec.get('PrevLocDesc');
						var xToLocDesc = objRec.get('NextLocDesc');
						var xTransInTime = objRec.get('TransInTime');
						var xTransOutTime = objRec.get('TransOutTime');
					}
				}
			}
		}
		
		obj.IBASE_cboTransLoc.setValue(xTransID);
		obj.IBASE_cboTransLoc.setRawValue(xTransLocDesc);
		
		Common_SetValue('IBASE_txtFromLoc',xFromLocDesc);
		Common_SetValue('IBASE_txtToLoc',xToLocDesc);
		Common_SetValue('IBASE_txtInICUDate',xTransInTime);
		Common_SetValue('IBASE_txtOutICUDate',xTransOutTime);
		
		var xObjectID = obj.ClsInfReportSrv.GetObjectID(obj.CurrReport.EpisodeID,obj.CurrReport.ReportType.RowID,xTransID);
		var xReportID = obj.ClsInfReportSrv.GetReportID(obj.CurrReport.EpisodeID,obj.CurrReport.ReportType.RowID,xObjectID);
		if (xReportID != obj.CurrReport.RowID) {
			obj.CurrReport = obj.GetReport(xReportID);
			obj.CurrReport.ChildSumm.TransID = xTransID;
			obj.CurrReport.ChildSumm.TransLoc = obj.ClsBaseCtloc.GetObjById(xTransLocID);
			obj.CurrReport.ObjectID = xObjectID;
			if (obj.CurrReport) obj.InitReport();
		} else {
			if (xReportID == '') {
				obj.CurrReport.ChildSumm.TransID = xTransID;
				obj.CurrReport.ChildSumm.TransLoc = obj.ClsBaseCtloc.GetObjById(xTransLocID);
				obj.CurrReport.ObjectID = xObjectID;
			}
		}
	}
	
	//������Ϣ ���ݴ洢
	obj.IBASE_SaveData = function(){
		var errinfo = '';
		
		//ת��ICUʱ״̬(�������)
		obj.CurrReport.ChildSumm.OutICUStatus = new Array();
		var itmValue = Common_GetValue('IBASE_cbgOutICUStatus');
		var arrValue = itmValue.split(',');
		if (itmValue) {
			for (var ind = 0; ind < arrValue.length; ind++) {
				var objDic = obj.ClsSSDictionary.GetObjById(arrValue[ind]);
				if (objDic) {
					obj.CurrReport.ChildSumm.OutICUStatus.push(objDic);
				}
			}
		}
		//ת��ICU48Сʱ��״̬(�������)
		obj.CurrReport.ChildSumm.OutICU48Status = new Array();
		var itmValue = Common_GetValue('IBASE_cbgOutICU48Status');
		var arrValue = itmValue.split(',');
		if (itmValue) {
			for (var ind = 0; ind < arrValue.length; ind++) {
				var objDic = obj.ClsSSDictionary.GetObjById(arrValue[ind]);
				if (objDic) {
					obj.CurrReport.ChildSumm.OutICU48Status.push(objDic);
				}
			}
		}
		//ϵͳ֢״
		obj.CurrReport.ChildSumm.SystemSymptom = Common_GetValue('IBASE_txtSystemSymptom');
		//�ֲ�֢״/����
		obj.CurrReport.ChildSumm.LocalSymptom = Common_GetValue('IBASE_txtLocalSymptom');
		//Add By LiYang 2014-04-09 ����ApacheII����
		obj.CurrReport.ChildSumm.ApacheIIScore = Common_GetValue('IBASE_txtApacheII');
		
		//����������У��
		if (obj.CurrReport.ObjectID == '') {
			//errinfo = errinfo + 'ObjectID Ϊ��!<br>'
		}
		var xTransID = Common_GetValue('IBASE_cboTransLoc')
		if (xTransID=="") {
			errinfo = errinfo + '�������δ��!<br>'
		}
		/*
		var objSumm = obj.CurrReport.ChildSumm;
		
		if (!objSumm.TransLoc) {
			errinfo = errinfo + '�������δ��!<br>'
		}
		*/
		return errinfo;
	}
	
	return obj;
}