
function InitNBINF(obj)
{
	//����������
	obj.NBINF_cboBornWeightCat = Common_ComboToDic("NBINF_cboBornWeightCat","<span style='color:red'><b>����</b></span>","NINFInfNICUBornWeight","","100%");
	//��Ⱦ����
	obj.NBINF_txtInfDate = Common_DateFieldToDate("NBINF_txtInfDate","<span style='color:red'><b>��Ⱦ����</b></span>","100%");
	//��Ⱦ���
	obj.NBINF_cbgInfDiagnos = Common_CheckboxGroupToDic("NBINF_cbgInfDiagnos","<span style='color:red'><b>��Ⱦ���</b></span>","NINFInfNICUInfDiag",3);
	//�׸�����
	obj.NBINF_cbgInfFactors = Common_CheckboxGroupToDic("NBINF_cbgInfFactors","<span style='color:red'><b>�׸�����</b></span>","NINFInfNICUInfFactors",3);
	
	//��Ⱦ��� ���沼��
	obj.NBINF_ViewPort = {
		//title : '��Ⱦ���',
		layout : 'fit',
		//frame : true,
		height : 320,
		anchor : '-20',
		tbar : ['<b>��������Ⱦ��Ϣ</b>'],
		items : [
			{
				layout : 'form',
				frame : true,
				labelWidth : 60,
				items : [
					{
						layout : 'column',
						items : [
							{
								width:200
								,layout : 'form'
								,labelAlign : 'right'
								,labelWidth : 60
								,items: [obj.NBINF_cboBornWeightCat]
							},{
								width:210
								,layout : 'form'
								,labelAlign : 'right'
								,labelWidth : 70
								,items: [obj.NBINF_txtInfDate]
							}
						]
					}
					,obj.NBINF_cbgInfDiagnos
					,obj.NBINF_cbgInfFactors
				]
			}
		]
	}
	
	//��Ⱦ��� �����ʼ��
	obj.NBINF_InitView = function(){
		if(obj.CurrReport.RowID != "") {
			//��ʼ��"����"ֵ
			var objBornWeightCat = obj.CurrReport.ChildSumm.BornWeightCat;
			if (objBornWeightCat){
				var itemValue = objBornWeightCat.RowID;
				var itemDesc = objBornWeightCat.Description;
			}
			Common_SetValue('NBINF_cboBornWeightCat',itemValue,itemDesc);
			
			//��ʼ��"��Ⱦ����"��"��Ⱦ���"ֵ
			var InfDate = '',InfDiagCat = '';
			if (obj.CurrReport.ChildInfPos) {
				var arrInfPos = obj.CurrReport.ChildInfPos;
				for (var ind = 0; ind < arrInfPos.length; ind++) {
					var objInfPos = arrInfPos[ind];
					if (objInfPos) {
						InfDate = objInfPos.InfDate;
						if (objInfPos.InfDiagCat) {
							var objDic = objInfPos.InfDiagCat;
							InfDiagCat = (InfDiagCat == '' ? objDic.RowID : InfDiagCat + ',' + objDic.RowID);
						}
					}
				}
			}
			Common_SetValue('NBINF_txtInfDate',InfDate);
			Common_SetValue('NBINF_cbgInfDiagnos',InfDiagCat);
			
			//��ʼ��"�׸�����"ֵ
			var InfFactors = '';
			if (obj.CurrReport.ChildSumm.InfFactors) {
				var arrInfFactors = obj.CurrReport.ChildSumm.InfFactors;
				for (var ind = 0; ind < arrInfFactors.length; ind++) {
					var objDic = arrInfFactors[ind];
					if (objDic) {
						InfFactors = (InfFactors == '' ? objDic.RowID : InfFactors + ',' + objDic.RowID);
					}
				}
			}
			Common_SetValue('NBINF_cbgInfFactors',InfFactors);
		}
	}
	
	//��Ⱦ��� ���ݴ洢
	obj.NBINF_SaveData = function(){
		var errinfo = '';
		
		//����������
		var BornWeightCat = Common_GetValue('NBINF_cboBornWeightCat');
		obj.CurrReport.ChildSumm.BornWeightCat = obj.ClsSSDictionary.GetObjById(BornWeightCat);
		
		//��Ⱦ��Ϣ
		if (obj.CurrReport.RowID != ''){
			var ReportID = obj.CurrReport.RowID;
			var flg = obj.ClsInfReportInfPosSrv.DelInfPos(ReportID);
		}
		obj.CurrReport.ChildInfPos   = new Array();
		var InfDate = Common_GetText('NBINF_txtInfDate');
		var today = new Date();
		var CurrDate = today.getYear() + "-" + (today.getMonth() + 1) + "-" + today.getDate();
		if (InfDate!=='') {
			var flg = Common_CompareDate(InfDate,CurrDate);
			if (!flg) errinfo = errinfo + '��Ⱦ���ڲ��ܴ��ڵ�ǰ����!<br>'
		}
		var itmValue = Common_GetValue('NBINF_cbgInfDiagnos');
		var arrValue = itmValue.split(',');
		if (itmValue) {
			for (var ind = 0; ind < arrValue.length; ind++) {
				var InfDiagnos = arrValue[ind];
				if (!InfDiagnos) continue;
				var objInfPos = obj.ClsInfReportInfPosSrv.GetSubObj('');
				if (objInfPos) {
					objInfPos.RowID = '';
					objInfPos.DataSource = '';
					objInfPos.InfPos = '';
					objInfPos.InfDate = InfDate; 
					objInfPos.InfEndDate = '';
					objInfPos.InfEndResult = '';
					objInfPos.InfDiag = '';
					objInfPos.InfDiagCat = obj.ClsSSDictionary.GetObjById(InfDiagnos);
					objInfPos.DiagnosisBasis = '';
					objInfPos.DiseaseCourse = '';
					objInfPos.InfPosOpr = new Array();
				}
				obj.CurrReport.ChildInfPos.push(objInfPos);
			}
		}
		
		//�׸�����
		obj.CurrReport.ChildSumm.InfFactors = new Array();
		var itmValue = Common_GetValue('NBINF_cbgInfFactors');
		var arrValue = itmValue.split(',');
		if (itmValue) {
			for (var ind = 0; ind < arrValue.length; ind++) {
				var objDic = obj.ClsSSDictionary.GetObjById(arrValue[ind]);
				if (objDic) {
					obj.CurrReport.ChildSumm.InfFactors.push(objDic);
				}
			}
		}
		
		//����������У��
		if (!obj.CurrReport.ChildSumm.BornWeightCat) {
			errinfo = errinfo + '����������δ��!<br>'
		}
		if (InfDate == '') {
			errinfo = errinfo + '��Ⱦ����δ��!<br>'
		}
		if (obj.CurrReport.ChildInfPos.length < 1) {
			errinfo = errinfo + '��Ⱦ���δ��!<br>'
		}
		if (obj.CurrReport.ChildSumm.InfFactors.length < 1) {
			errinfo = errinfo + '�׸�����δ��!<br>'
		}
		
		return errinfo;
	}
	
	return obj;
}