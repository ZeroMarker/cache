
function InitNBASE(obj)
{
	//��ʾ������Ϣ
	obj.NBASE_txtRegNo = Common_TextField("NBASE_txtRegNo","�ǼǺ�");
	obj.NBASE_txtPatName = Common_TextField("NBASE_txtPatName","����");
	obj.NBASE_txtPatSex = Common_TextField("NBASE_txtPatSex","�Ա�");
	obj.NBASE_txtPatAge = Common_TextField("NBASE_txtPatAge","����");
	obj.NBASE_txtMrNo = Common_TextField("NBASE_txtMrNo","������");
	obj.NBASE_txtAdmLoc = Common_TextField("NBASE_txtAdmLoc","��ǰ����");
	obj.NBASE_txtAdmDate = Common_TextField("NBASE_txtAdmDate","��Ժ����");
	obj.NBASE_txtDisDate = Common_TextField("NBASE_txtDisDate","��Ժ����");
	obj.NBASE_txtAdmDays = Common_TextField("NBASE_txtAdmDays","סԺ����");
	obj.NBASE_txtAdmBed = Common_TextField("NBASE_txtAdmBed","����");
	obj.NBASE_txtRepDate = Common_TextField("NBASE_txtRepDate","�����");
	obj.NBASE_txtRepUser = Common_TextField("NBASE_txtRepUser","���");
	obj.NBASE_txtRepStatus = Common_TextField("NBASE_txtRepStatus","����״̬");
	obj.NBASE_txtRepLoc = Common_TextField("NBASE_txtRepLoc","�����");
	obj.NBASE_txtInICUDate = Common_TextField("NBASE_txtInICUDate","�������");
	obj.NBASE_txtOutICUDate = Common_TextField("NBASE_txtOutICUDate","��������");
	obj.NBASE_txtFromLoc = Common_TextField("NBASE_txtFromLoc","�����Դ");
	obj.NBASE_txtToLoc = Common_TextField("NBASE_txtToLoc","����ȥ��");
	obj.NBASE_cboTransLoc = Common_ComboToTransLoc("NBASE_cboTransLoc","�������",obj.CurrReport.EpisodeID,"W");
	
	Common_SetDisabled("NBASE_txtRegNo",true);
	Common_SetDisabled("NBASE_txtPatName",true);
	Common_SetDisabled("NBASE_txtPatSex",true);
	Common_SetDisabled("NBASE_txtPatAge",true);
	Common_SetDisabled("NBASE_txtMrNo",true);
	Common_SetDisabled("NBASE_txtAdmLoc",true);
	Common_SetDisabled("NBASE_txtAdmDate",true);
	Common_SetDisabled("NBASE_txtDisDate",true);
	Common_SetDisabled("NBASE_txtAdmDays",true);
	Common_SetDisabled("NBASE_txtAdmBed",true);
	Common_SetDisabled("NBASE_txtRepLoc",true);
	Common_SetDisabled("NBASE_txtRepUser",true);
	Common_SetDisabled("NBASE_txtRepDate",true);
	Common_SetDisabled("NBASE_txtRepStatus",true);
	Common_SetDisabled("NBASE_txtInICUDate",true);
	Common_SetDisabled("NBASE_txtOutICUDate",true);
	Common_SetDisabled("NBASE_txtFromLoc",true);
	Common_SetDisabled("NBASE_txtToLoc",true);
	
	//��������
	obj.NBASE_txtBornWeight = Common_NumberField("NBASE_txtBornWeight","��������(g)");
	
	//������Ϣ ���沼��
	obj.NBASE_ViewPort = {
		//title : '������Ϣ',
		layout : 'border',
		//frame : true,
		height : 180,
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
								items : [obj.NBASE_txtRegNo,obj.NBASE_txtAdmLoc,obj.NBASE_cboTransLoc]
							},{
								columnWidth:.23,
								layout : 'form',
								labelAlign : 'right',
								labelWidth : 80,
								items : [obj.NBASE_txtPatName,obj.NBASE_txtAdmDate,obj.NBASE_txtRepLoc]
							},{
								columnWidth:.23,
								layout : 'form',
								labelAlign : 'right',
								labelWidth : 80,
								items : [obj.NBASE_txtMrNo,obj.NBASE_txtDisDate,obj.NBASE_txtRepDate]
							},{
								columnWidth:.15,
								layout : 'form',
								labelAlign : 'right',
								labelWidth : 80,
								items : [obj.NBASE_txtPatSex,obj.NBASE_txtAdmDays,obj.NBASE_txtRepUser]
							},{
								columnWidth:.15,
								layout : 'form',
								labelAlign : 'right',
								labelWidth : 80,
								items : [obj.NBASE_txtPatAge,obj.NBASE_txtAdmBed,obj.NBASE_txtRepStatus]
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
								items : [obj.NBASE_txtInICUDate]
							},{
								columnWidth:.23,
								layout : 'form',
								labelAlign : 'right',
								labelWidth : 80,
								items : [obj.NBASE_txtOutICUDate]
							},{
								columnWidth:.23,
								layout : 'form',
								labelAlign : 'right',
								labelWidth : 80,
								items : [obj.NBASE_txtFromLoc]
							},{
								columnWidth:.23,
								layout : 'form',
								labelAlign : 'right',
								labelWidth : 80,
								items : [obj.NBASE_txtToLoc]
							}
						]
					},{
						layout : 'column',
						items : [
							{
								columnWidth:.50
							},{
								width:240,
								layout : 'form',
								labelAlign : 'right',
								labelWidth : 90,
								items : [
									obj.NBASE_txtBornWeight
								]
							},{
								columnWidth:.50
							}
						]
					}
				]
			}
		]
	}
	
	//������Ϣ �����ʼ��
	obj.NBASE_InitView = function(){
		var objPaadm = obj.CurrPaadm;
		if (objPaadm) {
			//������Ϣ
			Common_SetValue("NBASE_txtAdmDate",objPaadm.AdmitDate);
			//������Ϣ
			var objPatient = obj.CurrPatient;
			if (objPatient) {
				Common_SetValue('NBASE_txtRegNo',objPatient.PapmiNo);
				Common_SetValue('NBASE_txtPatName',objPatient.PatientName);
				Common_SetValue('NBASE_txtPatSex',objPatient.Sex);
				var Age = objPatient.Age;
				var Month = objPatient.AgeMonth;
				var Day = objPatient.AgeDay;
				if (!Age) Age=0;
				if (!Month) Month=0;
				if (!Day) Day=0;
				if (parseInt(Age) > 0) {
					Common_SetValue('NBASE_txtPatAge',parseInt(Age) + '��');
				} else {
					Common_SetValue('NBASE_txtPatAge',parseInt(Month) + '��' + parseInt(Day) + '��');
				}
				//update by zf 2013-05-14
				var MrNo=obj.ClsCommonClsSrv.GetMrNoByAdm(obj.CurrReport.EpisodeID);
				if (MrNo){
					objPaadm.MrNo = MrNo;
					Common_SetValue('NBASE_txtMrNo',MrNo);
				} else {
					Common_SetValue('NBASE_txtMrNo',objPatient.InPatientMrNo);
				}
				Common_SetValue('NBASE_txtAdmLoc',objPaadm.Department);
				Common_SetValue('NBASE_txtAdmDate',objPaadm.AdmitDate + ' ' + objPaadm.AdmitTime);
				Common_SetValue('NBASE_txtDisDate',objPaadm.DisDate + ' ' + objPaadm.DisTime);
				Common_SetValue('NBASE_txtAdmBed',objPaadm.Bed);
				Common_SetValue('NBASE_txtAdmDays',objPaadm.Days);
			}
			//������Ϣ
			Common_SetValue("NBASE_txtRepLoc",obj.CurrReport.ReportLoc ? obj.CurrReport.ReportLoc.Descs : '');
			Common_SetValue("NBASE_txtRepUser",obj.CurrReport.ReportUser ? obj.CurrReport.ReportUser.Name : '');
			Common_SetValue("NBASE_txtRepDate",obj.CurrReport.ReportDate + " " + obj.CurrReport.ReportTime);
			Common_SetValue("NBASE_txtRepStatus",obj.CurrReport.ReportStatus ? obj.CurrReport.ReportStatus.Description : '');
			//����������
			Common_SetValue('NBASE_txtBornWeight',obj.CurrReport.ChildSumm.BornWeight);
		}
		
		//��ʼ���������
		obj.NBASE_cboTransLoc_Init();
		obj.NBASE_cboTransLoc.on('select',obj.NBASE_cboTransLoc_select);
	}
	
	//������Ҵ����¼�
	obj.NBASE_TransRecord = new Object();
	obj.NBASE_TransRecord.TransID = '';
	obj.NBASE_TransRecord.TransLocID = '';
	obj.NBASE_TransRecord.TransLocDesc = '';
	obj.NBASE_TransRecord.FromLocDesc = '';
	obj.NBASE_TransRecord.ToLocDesc = '';
	obj.NBASE_TransRecord.TransInTime = '';
	obj.NBASE_TransRecord.TransOutTime = '';
	obj.NBASE_TransRecord.ObjectID = '';
	obj.NBASE_TransRecord.ReportID = '';
	obj.NBASE_cboTransLoc_select = function(){
		var xTransID = Common_GetValue('NBASE_cboTransLoc');
		var objTransLocStore = obj.NBASE_cboTransLoc.getStore();
		var ind = objTransLocStore.find("TransID",xTransID);
		if (ind > -1) {
			var objRec = objTransLocStore.getAt(ind);
			obj.NBASE_TransRecord.TransID = objRec.get('TransID');
			obj.NBASE_TransRecord.TransLocID = objRec.get('TransLocID');
			obj.NBASE_TransRecord.TransLocDesc = objRec.get('TransLocDesc');
			obj.NBASE_TransRecord.FromLocDesc = objRec.get('PrevLocDesc');
			obj.NBASE_TransRecord.ToLocDesc = objRec.get('NextLocDesc');
			obj.NBASE_TransRecord.TransInTime = objRec.get('TransInTime');
			obj.NBASE_TransRecord.TransOutTime = objRec.get('TransOutTime');
			obj.NBASE_TransRecord.ObjectID = obj.ClsInfReportSrv.GetObjectID(obj.CurrReport.EpisodeID,obj.CurrReport.ReportType.RowID,obj.NBASE_TransRecord.TransID);
			obj.NBASE_TransRecord.ReportID = obj.ClsInfReportSrv.GetReportID(obj.CurrReport.EpisodeID,obj.CurrReport.ReportType.RowID,obj.NBASE_TransRecord.ObjectID);
			
			if (obj.NBASE_TransRecord.ReportID != obj.CurrReport.RowID) {
				Ext.MessageBox.confirm('��ʾ', '���ĵ�����ң����ʼ���������ݣ�ȷ���Ƿ���ģ�', function(btn,text){
					if (btn == 'yes') {
						obj.CurrReport = obj.GetReport(obj.NBASE_TransRecord.ReportID);
						obj.CurrReport.ChildSumm.TransID = obj.NBASE_TransRecord.TransID;
						obj.CurrReport.ChildSumm.TransLoc = obj.ClsBaseCtloc.GetObjById(obj.NBASE_TransRecord.TransLocID);
						obj.CurrReport.ObjectID = obj.NBASE_TransRecord.ObjectID;
						if (obj.CurrReport) obj.InitReport();
					} else {
						var xTransID = obj.CurrReport.ChildSumm.TransID;
						var xTransLocDesc = '';
						var objTransLocStore = obj.NBASE_cboTransLoc.getStore();
						var ind = objTransLocStore.find("TransID",xTransID);
						if (ind > -1) {
							var objRec = objTransLocStore.getAt(ind);
							var xTransID = objRec.get('TransID');
							var xTransLocDesc = objRec.get('TransLocDesc');
						}
						obj.NBASE_cboTransLoc.setValue(xTransID);
						obj.NBASE_cboTransLoc.setRawValue(xTransLocDesc);
					}
				});
			} else {
				if (obj.NBASE_TransRecord.TransID != obj.CurrReport.ChildSumm.TransID) {
					obj.CurrReport.ChildSumm.TransID = obj.NBASE_TransRecord.TransID;
					obj.CurrReport.ChildSumm.TransLoc = obj.ClsBaseCtloc.GetObjById(obj.NBASE_TransRecord.TransLocID);
					obj.CurrReport.ObjectID = obj.NBASE_TransRecord.ObjectID;
					
					Common_SetValue('NBASE_txtFromLoc',obj.NBASE_TransRecord.FromLocDesc);
					Common_SetValue('NBASE_txtToLoc',obj.NBASE_TransRecord.ToLocDesc);
					Common_SetValue('NBASE_txtInICUDate',obj.NBASE_TransRecord.TransInTime);
					Common_SetValue('NBASE_txtOutICUDate',obj.NBASE_TransRecord.TransOutTime);
				}
			}
		}
	}
	
	//������ҳ�ʼ��
	obj.NBASE_cboTransLoc_Init = function(){
		var xTransID = '';
		var xTransLocDesc = '';
		var xFromLocDesc = '';
		var xToLocDesc = '';
		var xTransInTime = '';
		var xTransOutTime = '';
		
		var objTransLocStore = obj.NBASE_cboTransLoc.getStore();
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
		
		obj.NBASE_cboTransLoc.setValue(xTransID);
		obj.NBASE_cboTransLoc.setRawValue(xTransLocDesc);
		
		Common_SetValue('NBASE_txtFromLoc',xFromLocDesc);
		Common_SetValue('NBASE_txtToLoc',xToLocDesc);
		Common_SetValue('NBASE_txtInICUDate',xTransInTime);
		Common_SetValue('NBASE_txtOutICUDate',xTransOutTime);
		
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
	obj.NBASE_SaveData = function(){
		var errinfo = '';
		
		//����������
		obj.CurrReport.ChildSumm.BornWeight = Common_GetValue('NBASE_txtBornWeight');
		
		//����������У��
		if (obj.CurrReport.ObjectID == '') {
			//errinfo = errinfo + 'ObjectID Ϊ��!<br>'
		}
		var objSumm = obj.CurrReport.ChildSumm;
		if (!objSumm.TransLoc) {
			errinfo = errinfo + '�������δ��!<br>'
		}
		if (obj.CurrReport.ChildSumm.BornWeight == '') {
			errinfo = errinfo + '����������δ��!<br>'
		}
		
		return errinfo;
	}
	
	return obj;
}