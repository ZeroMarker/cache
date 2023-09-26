	
function InitIPICC(obj)
{
	//�ù�ʱ��
	obj.IPICC_txtIntubateDateTime = Common_DateFieldToDateTime("IPICC_txtIntubateDateTime","�ù�ʱ��");
	
	//�ι�ʱ��
	obj.IPICC_txtExtubateDateTime = Common_DateFieldToDateTime("IPICC_txtExtubateDateTime","�ι�ʱ��");
	
	//�ùܵص�
	obj.IPICC_cboIntubatePlace = Common_ComboToDic("IPICC_cboIntubatePlace","�ùܵص�","NINFICUIntubatePlace");
	
	//�ù���Ա����
	obj.IPICC_cboIntubateUserType = Common_ComboToDic("IPICC_cboIntubateUserType","�ù���Ա","NINFICUIntubateUserType");
	
	//�ù���Ա
	obj.IPICC_cboIntubateUser = Common_ComboToSSUser("IPICC_cboIntubateUser","�ù���Ա");
	
	//�Ƿ��Ⱦ
	obj.IPICC_chkIsInf = Common_Checkbox("IPICC_chkIsInf","�Ƿ��Ⱦ");
	obj.IPICC_chkIsInf.on('check',function(checkbox,value){
		var objItem1 = Ext.getCmp("IPICC_txtInfDate");
		if (objItem1) {
			objItem1.setDisabled((!value));
		}
		var objItem1 = Ext.getCmp("IPICC_cboInfPy");
		if (objItem1) {
			objItem1.setDisabled((!value));
		}
		
		//Add By LiYang 2014-04-02
		var objItem1 = Ext.getCmp("IPICC_cboINFSymptom");
		if (objItem1) {
			objItem1.setDisabled((!value));
		}		
		
		if (!value) {
			Common_SetValue('IPICC_txtInfDate','');
			Common_SetValue('IPICC_cboInfPy','','');
			Common_SetValue('IPICC_cboINFSymptom','','');//Add By LiYang 2014-04-02
		}
	},obj.IPICC_chkIsInf);
	
	//��Ⱦ����
	obj.IPICC_txtInfDate = Common_DateFieldToDate("IPICC_txtInfDate","��Ⱦ����");
	
	//��ԭ��
	obj.IPICC_cboInfPy = Common_ComboToPathogeny("IPICC_cboInfPy","��ԭ��");
	
	//�ùܷ�λ
	obj.IPICC_cboPICCIntubatePos = Common_ComboToDic("IPICC_cboPICCIntubatePos","�ùܷ�λ","NINFICUPICCIntubatePos");
	
	//�����ھ�
	obj.IPICC_cboPICCIntubateSize = Common_ComboToDic("IPICC_cboPICCIntubateSize","�����ھ�","NINFICUPICCIntubateSize");
	
	//��������
	obj.IPICC_cboPICCIntubateType = Common_ComboToDic("IPICC_cboPICCIntubateType","��������","NINFICUPICCIntubateType");
	
	//����ǻ��
	obj.IPICC_cboPICCIntubateNum = Common_ComboToDic("IPICC_cboPICCIntubateNum","����ǻ��","NINFICUPICCIntubateNum");
	
	//�ùܲ�λ
	obj.IPICC_cboPICCIntubateRegion = Common_ComboToDic("IPICC_cboPICCIntubateRegion","�ùܲ�λ","NINFICUPICCIntubateRegion");
	
	//�ι�ԭ��
	obj.IPICC_cboPICCExtubateReason = Common_ComboToDic("IPICC_cboPICCExtubateReason","�ι�ԭ��","NINFICUPICCExtubateReason");
	
	//Add By LiYang 2014-04-11 ��ܸ�Ⱦ֢״
	obj.IPICC_cboINFSymptom = Common_ComboToDic("IPICC_cboINFSymptom","��Ⱦ֢״","NINFICUIntubateINFSymptom");
	
	
	
	//�б༭
	obj.IPICC_GridRowViewPort = {
		layout : 'fit',
		frame : true,
		items : [
			{
				layout : 'column',
				items : [
					{
						columnWidth:1,
						layout : 'form',
						labelAlign : 'right',
						labelWidth : 60,
						items : [
							obj.IPICC_cboPICCIntubateType
							,obj.IPICC_cboPICCIntubateNum
							,obj.IPICC_cboPICCIntubateRegion
							,obj.IPICC_txtIntubateDateTime
							,obj.IPICC_txtExtubateDateTime
							,obj.IPICC_cboIntubateUserType
							,obj.IPICC_cboIntubatePlace
							,obj.IPICC_chkIsInf
							,obj.IPICC_txtInfDate
							,obj.IPICC_cboINFSymptom //Add By LiYang 2014-04-11
						]
					}
				]
			}
		]
	}
	
	obj.IPICC_GridRowDataCheck = function(objRec){
		var errInfo = '';
		
		if (objRec) {
			var IPICC_txtIntubateDateTime = objRec.get('IntubateDateTime');
			if (IPICC_txtIntubateDateTime=='') {
				errInfo = errInfo + '�ù�ʱ��δ��!';
			}
			var IPICC_cboPICCIntubatePos = objRec.get('PICCIntubatePosDesc');
			if (IPICC_cboPICCIntubatePos=='') {
				//errInfo = errInfo + '�ùܷ�λδ��!';
			}
			var IPICC_cboPICCIntubateSize = objRec.get('PICCIntubateSizeDesc');
			if (IPICC_cboPICCIntubateSize=='') {
				//errInfo = errInfo + '�����ھ�δ��!';
			}
			var IPICC_cboPICCIntubateType = objRec.get('PICCIntubateTypeDesc');
			if (IPICC_cboPICCIntubateType=='') {
				errInfo = errInfo + '��������δ��!';
			}
			var IPICC_cboPICCIntubateNum = objRec.get('PICCIntubateNumDesc');
			if (IPICC_cboPICCIntubateNum=='') {
				errInfo = errInfo + '����ǻ��δ��!';
			}
			var IPICC_cboPICCIntubateRegion = objRec.get('PICCIntubateRegionDesc');
			if (IPICC_cboPICCIntubateRegion=='') {
				errInfo = errInfo + '�ùܲ�λδ��!';
			}
			var IPICC_cboIntubatePlace = objRec.get('IntubatePlaceDesc');
			if (IPICC_cboIntubatePlace=='') {
				errInfo = errInfo + '�ùܵص�δ��!';
			}
			var IPICC_cboIntubateUserType = objRec.get('IntubateUserTypeDesc');
			if (IPICC_cboIntubateUserType=='') {
				errInfo = errInfo + '�ù���Աδ��!';
			}
			var IPICC_cboIntubateUser = objRec.get('IntubateUserDesc');
			if (IPICC_cboIntubateUser=='') {
				//errInfo = errInfo + '�ù���Աδ��!';
			}
			var IPICC_txtExtubateDateTime = objRec.get('ExtubateDateTime');
			if (IPICC_txtExtubateDateTime=='') {
				//errInfo = errInfo + '�ι�ʱ��δ��!';
			}
			var IPICC_cboPICCExtubateReason = objRec.get('PICCExtubateReasonDesc');
			if (IPICC_cboPICCExtubateReason=='') {
				//errInfo = errInfo + '�ι�ԭ��δ��!';
			}
			var IPICC_txtInfDate = objRec.get('InfDate');
			
			//Add By LiYang 2014-04-11 ����[��ܸ�Ⱦ֢״δ��]
			/*var IPICC_cboINFSymptom = Common_GetValue('IPICC_cboINFSymptom');
			if (IPICC_cboINFSymptom=='') {
				errInfo = errInfo + '��ܸ�Ⱦ֢״δ��!';
			}
			*/
			var IPICC_chkIsInf = objRec.get('IsInfection');
			//Add By LiYang 2014-07-21  FixBug:�������δ���ʾ
			if((IPICC_txtInfDate == '') && (IPICC_chkIsInf == true))
			{
				errInfo = errInfo + '��ܸ�Ⱦ����δ��!';
			}
			
			//Add By LiYang 2014-04-11 ����[��ܸ�Ⱦ֢״δ��]
			var IPICC_cboINFSymptom = objRec.get('INFSymptomID');
			if ((IPICC_cboINFSymptom=='') && (IPICC_chkIsInf == true)) {
				errInfo = errInfo + '��ܸ�Ⱦ֢״δ��!';
			}				
			
		} else {
			var IPICC_txtIntubateDateTime = Common_GetValue('IPICC_txtIntubateDateTime');
			if (IPICC_txtIntubateDateTime=='') {
				errInfo = errInfo + '�ù�ʱ��δ��!';
			}
			var IPICC_cboPICCIntubatePos = Common_GetValue('IPICC_cboPICCIntubatePos');
			if (IPICC_cboPICCIntubatePos=='') {
				//errInfo = errInfo + '�ùܷ�λδ��!';
			}
			var IPICC_cboPICCIntubateSize = Common_GetValue('IPICC_cboPICCIntubateSize');
			if (IPICC_cboPICCIntubateSize=='') {
				//errInfo = errInfo + '�����ھ�δ��!';
			}
			var IPICC_cboPICCIntubateType = Common_GetValue('IPICC_cboPICCIntubateType');
			if (IPICC_cboPICCIntubateType=='') {
				errInfo = errInfo + '��������δ��!';
			}
			var IPICC_cboPICCIntubateNum = Common_GetValue('IPICC_cboPICCIntubateNum');
			if (IPICC_cboPICCIntubateNum=='') {
				errInfo = errInfo + '����ǻ��δ��!';
			}
			var IPICC_cboPICCIntubateRegion = Common_GetValue('IPICC_cboPICCIntubateRegion');
			if (IPICC_cboPICCIntubateRegion=='') {
				errInfo = errInfo + '�ùܲ�λδ��!';
			}
			var IPICC_cboIntubatePlace = Common_GetValue('IPICC_cboIntubatePlace');
			if (IPICC_cboIntubatePlace=='') {
				errInfo = errInfo + '�ùܵص�δ��!';
			}
			var IPICC_cboIntubateUserType = Common_GetValue('IPICC_cboIntubateUserType');
			if (IPICC_cboIntubateUserType=='') {
				errInfo = errInfo + '�ù���Աδ��!';
			}
			var IPICC_cboIntubateUser = Common_GetValue('IPICC_cboIntubateUser');
			if (IPICC_cboIntubateUser=='') {
				//errInfo = errInfo + '�ù���Աδ��!';
			}
			var IPICC_txtExtubateDateTime = Common_GetValue('IPICC_txtExtubateDateTime');
			if (IPICC_txtExtubateDateTime=='') {
				//errInfo = errInfo + '�ι�ʱ��δ��!';
			}
			var IPICC_cboPICCExtubateReason = Common_GetValue('IPICC_cboPICCExtubateReason');
			if (IPICC_cboPICCExtubateReason=='') {
				//errInfo = errInfo + '�ι�ԭ��δ��!';
			}
			
			var IPICC_chkIsInf = Common_GetValue('IPICC_chkIsInf');
			if(IPICC_chkIsInf){
				var IPICC_txtInfDate = Common_GetValue('IPICC_txtInfDate');
				//Add By LiYang 2014-07-21  FixBug:�������δ���ʾ
				if(IPICC_txtInfDate == '')
				{
					errInfo = errInfo + '��ܸ�Ⱦ����δ��!';
				}
				
				//Add By LiYang 2014-04-11 ����[��ܸ�Ⱦ֢״δ��]
				var IPICC_cboINFSymptom = Common_GetValue('IPICC_cboINFSymptom');
				if (IPICC_cboINFSymptom=='') {
					errInfo = errInfo + '��ܸ�Ⱦ֢״δ��!';
				}			
			}
		}
		
		var today = new Date();
		var CurrDate = today.getYear() + "-" + (today.getMonth() + 1) + "-" + today.getDate();
		var IPICC_txtExtubateDateTime = Common_GetValue('IPICC_txtExtubateDateTime');
		if (IPICC_txtIntubateDateTime != '') {
			var IntubateDate = IPICC_txtIntubateDateTime.split(" ")[0];
			//var flg = Common_CompareDate(IntubateDate,CurrDate);
			//if (!flg) errInfo = errInfo + '�ù����ڴ��ڵ�ǰ����!<br>'
			
			var objPaadm = obj.CurrPaadm;
			var flg = Common_CompareDate(objPaadm.AdmitDate,IntubateDate);
			if (!flg) errInfo = errInfo + '�ù�����С����Ժ����!<br>'
			
			if (objPaadm.DisDate) {
				var flg = Common_CompareDate(IntubateDate,objPaadm.DisDate);
				if (!flg) errInfo = errInfo + '�ù����ڴ��ڳ�Ժ����!<br>'
			}
			
			var InfDate = IPICC_txtInfDate;
			if (InfDate) {
				var flg = Common_CompareDate(IntubateDate,InfDate);
				if (!flg) errInfo = errInfo + '�ù����ڴ��ڸ�Ⱦ����!<br>'
			}
			
			if (IPICC_txtExtubateDateTime != '') {
				var ExtubateDate = IPICC_txtExtubateDateTime.split(" ")[0];
				var flg = Common_CompareDate(IntubateDate,ExtubateDate);
				if (!flg) errInfo = errInfo + '�ι����ڴ����ù�����!<br>'
				
				var flg = Common_CompareDate(ExtubateDate,CurrDate);
				if (!flg) errInfo = errInfo + '�ι����ڴ��ڵ�ǰ����!<br>'
				
				var flg = Common_CompareDate(objPaadm.AdmitDate,ExtubateDate);
				if (!flg) errInfo = errInfo + '�ι�����С����Ժ����!<br>'
				
				if (objPaadm.DisDate) {
					var flg = Common_CompareDate(ExtubateDate,objPaadm.DisDate);
					if (!flg) errInfo = errInfo + '�ι����ڴ��ڳ�Ժ����!<br>'
				}
				
				var InfDate = IPICC_txtInfDate;
				if (InfDate) {
					var flg = Common_CompareDate(InfDate,ExtubateDate);
					if (!flg) errInfo = errInfo + '��Ⱦ���ڴ��ڰι�����!<br>'
				}
			}
		}
		
		return errInfo;
	}
	
	obj.IPICC_GridRowDataSave = function(objRec){
		var IntubateDateTime = Common_GetValue('IPICC_txtIntubateDateTime');
		var arrDateTime = IntubateDateTime.split(' ');
		if (arrDateTime.length>1){
			var IntubateDate = arrDateTime[0];
			var IntubateTime = arrDateTime[1];
		} else {
			var IntubateDate = '';
			var IntubateTime = '';
		}
		var ExtubateDateTime = Common_GetValue('IPICC_txtExtubateDateTime');
		var arrDateTime = ExtubateDateTime.split(' ');
		if (arrDateTime.length>1){
			var ExtubateDate = arrDateTime[0];
			var ExtubateTime = arrDateTime[1];
		} else {
			var ExtubateDate = '';
			var ExtubateTime = '';
		}
		var IntubatePlaceID = Common_GetValue('IPICC_cboIntubatePlace');
		var IntubatePlaceDesc = Common_GetText('IPICC_cboIntubatePlace');
		var IntubateUserTypeID = Common_GetValue('IPICC_cboIntubateUserType');
		var IntubateUserTypeDesc = Common_GetText('IPICC_cboIntubateUserType');
		var IntubateUserID = Common_GetValue('IPICC_cboIntubateUser');
		var IntubateUserDesc = Common_GetText('IPICC_cboIntubateUser');
		var InfDate = Common_GetValue('IPICC_txtInfDate');
		var IsInfection = (InfDate != '' ? '��' : '��');
		var InfPyID = Common_GetValue('IPICC_cboInfPy');
		var InfPyDesc = Common_GetText('IPICC_cboInfPy');
		var InfPyValue = InfPyID + CHR_2 + InfPyDesc;
		var PICCIntubatePosID = Common_GetValue('IPICC_cboPICCIntubatePos');
		var PICCIntubatePosDesc = Common_GetText('IPICC_cboPICCIntubatePos');
		var PICCIntubateSizeID = Common_GetValue('IPICC_cboPICCIntubateSize');
		var PICCIntubateSizeDesc = Common_GetText('IPICC_cboPICCIntubateSize');
		var PICCIntubateTypeID = Common_GetValue('IPICC_cboPICCIntubateType');
		var PICCIntubateTypeDesc = Common_GetText('IPICC_cboPICCIntubateType');
		var PICCIntubateNumID = Common_GetValue('IPICC_cboPICCIntubateNum');
		var PICCIntubateNumDesc = Common_GetText('IPICC_cboPICCIntubateNum');
		var PICCIntubateRegionID = Common_GetValue('IPICC_cboPICCIntubateRegion');
		var PICCIntubateRegionDesc = Common_GetText('IPICC_cboPICCIntubateRegion');
		var PICCExtubateReasonID = Common_GetValue('IPICC_cboPICCExtubateReason');
		var PICCExtubateReasonDesc = Common_GetText('IPICC_cboPICCExtubateReason');
		var IPICC_cboINFSymptomID = Common_GetValue('IPICC_cboINFSymptom');
		var IPICC_cboINFSymptomDesc = Common_GetText('IPICC_cboINFSymptom');
		
		if (objRec) {      //�ύ����
			objRec.set('IndRec',objRec.get('IndRec'));
			objRec.set('RepID',objRec.get('RepID'));
			objRec.set('SubID',objRec.get('SubID'));
			objRec.set('IsChecked','1');
			objRec.set('DataSource',objRec.get('DataSource'));
			
			objRec.set('IntubateDate',IntubateDate);
			objRec.set('IntubateTime',IntubateTime);
			objRec.set('IntubateDateTime',IntubateDateTime);
			objRec.set('ExtubateDate',ExtubateDate);
			objRec.set('ExtubateTime',ExtubateTime);
			objRec.set('ExtubateDateTime',ExtubateDateTime);
			objRec.set('IntubatePlaceID',IntubatePlaceID);
			objRec.set('IntubatePlaceDesc',IntubatePlaceDesc);
			objRec.set('IntubateUserTypeID',IntubateUserTypeID);
			objRec.set('IntubateUserTypeDesc',IntubateUserTypeDesc);
			objRec.set('IntubateUserID',IntubateUserID);
			objRec.set('IntubateUserDesc',IntubateUserDesc);
			objRec.set('IsInfection',IsInfection);
			objRec.set('InfDate',InfDate);
			objRec.set('InfPyIDs',InfPyID);
			objRec.set('InfPyDescs',InfPyDesc);
			objRec.set('InfPyValues',InfPyValue);
			objRec.set('PICCIntubatePosID',PICCIntubatePosID);
			objRec.set('PICCIntubatePosDesc',PICCIntubatePosDesc);
			objRec.set('PICCIntubateSizeID',PICCIntubateSizeID);
			objRec.set('PICCIntubateSizeDesc',PICCIntubateSizeDesc);
			objRec.set('PICCIntubateTypeID',PICCIntubateTypeID);
			objRec.set('PICCIntubateTypeDesc',PICCIntubateTypeDesc);
			objRec.set('PICCIntubateNumID',PICCIntubateNumID);
			objRec.set('PICCIntubateNumDesc',PICCIntubateNumDesc);
			objRec.set('PICCIntubateRegionID',PICCIntubateRegionID);
			objRec.set('PICCIntubateRegionDesc',PICCIntubateRegionDesc);
			objRec.set('PICCExtubateReasonID',PICCExtubateReasonID);
			objRec.set('PICCExtubateReasonDesc',PICCExtubateReasonDesc);
			//Add BY LiYang 2014-04-11 ���Ӹ�Ⱦ֢״�ֶ�
			objRec.set('INFSymptomID',IPICC_cboINFSymptomID);
			objRec.set('INFSymptomDesc',IPICC_cboINFSymptomDesc);			
			objRec.commit();
		} else {                 //��������
			var objGrid = Ext.getCmp('IPICC_gridPICC');
			if (objGrid){
				var objStore = objGrid.getStore();
				var RecordType = objStore.recordType;
				var RecordData = new RecordType({
					IndRec : ''
					,RepID : obj.CurrReport.RowID
					,SubID : ''
					,IsChecked : '1'
					,DataSource : ''
					,IntubateDate : IntubateDate
					,IntubateTime : IntubateTime
					,IntubateDateTime : IntubateDateTime
					,ExtubateDate : ExtubateDate
					,ExtubateTime : ExtubateTime
					,ExtubateDateTime : ExtubateDateTime
					,IntubatePlaceID : IntubatePlaceID
					,IntubatePlaceDesc : IntubatePlaceDesc
					,IntubateUserTypeID : IntubateUserTypeID
					,IntubateUserTypeDesc : IntubateUserTypeDesc
					,IntubateUserID : IntubateUserID
					,IntubateUserDesc : IntubateUserDesc
					,IsInfection : IsInfection
					,InfDate : InfDate
					,InfPyIDs : InfPyID
					,InfPyDescs : InfPyDesc
					,InfPyValues : InfPyValue
					,PICCIntubatePosID : PICCIntubatePosID
					,PICCIntubatePosDesc : PICCIntubatePosDesc
					,PICCIntubateSizeID : PICCIntubateSizeID
					,PICCIntubateSizeDesc : PICCIntubateSizeDesc
					,PICCIntubateTypeID : PICCIntubateTypeID
					,PICCIntubateTypeDesc : PICCIntubateTypeDesc
					,PICCIntubateNumID : PICCIntubateNumID
					,PICCIntubateNumDesc : PICCIntubateNumDesc
					,PICCIntubateRegionID : PICCIntubateRegionID
					,PICCIntubateRegionDesc : PICCIntubateRegionDesc
					,PICCExtubateReasonID : PICCExtubateReasonID
					,PICCExtubateReasonDesc : PICCExtubateReasonDesc
					//Add BY LiYang 2014-04-11 ���Ӹ�Ⱦ֢״�ֶ�
					,INFSymptomID : IPICC_cboINFSymptomID
					,INFSymptomDesc : IPICC_cboINFSymptomDesc
				});
				objStore.insert(objStore.getCount(), RecordData);
				objGrid.getView().focusRow(objGrid.getStore().getCount()-1);
			}
		}
	}
	
	obj.IPICC_GridRowDataSet = function(objRec){
		if (objRec){
			Common_SetValue('IPICC_txtIntubateDateTime',objRec.get('IntubateDateTime'));
			Common_SetValue('IPICC_txtExtubateDateTime',objRec.get('ExtubateDateTime'));
			Common_SetValue('IPICC_cboIntubatePlace',objRec.get('IntubatePlaceID'),objRec.get('IntubatePlaceDesc'));
			Common_SetValue('IPICC_cboIntubateUserType',objRec.get('IntubateUserTypeID'),objRec.get('IntubateUserTypeDesc'));
			Common_SetValue('IPICC_cboIntubateUser',objRec.get('IntubateUserID'),objRec.get('IntubateUserDesc'));
			//�Ƿ��Ⱦ,��Ⱦ����,��ԭ��
			Common_SetValue('IPICC_chkIsInf',(objRec.get('IsInfection')=='��'));
			Common_SetValue('IPICC_txtInfDate',objRec.get('InfDate'));
			var strInfPyValues = objRec.get('InfPyValues');
			strInfPyValues = strInfPyValues.replace(/<\$C1>/gi,CHR_1);
			strInfPyValues = strInfPyValues.replace(/<\$C2>/gi,CHR_2);
			var arrInfPyValues = strInfPyValues.split(CHR_1);
			if (arrInfPyValues.length > 0) {
				var strInfPyValue = arrInfPyValues[0];
				var arrInfPyValue = strInfPyValue.split(CHR_2);
				if (arrInfPyValue.length >= 2) {
					Common_SetValue('IPICC_cboInfPy',arrInfPyValue[0],arrInfPyValue[1]);
				}
			} else {
				Common_SetValue('IPICC_cboInfPy','','');
			}
			var objItem1 = Ext.getCmp("IPICC_txtInfDate");
			if (objItem1) {
				objItem1.setDisabled((objRec.get('IsInfection')!='��'));
			}
			var objItem1 = Ext.getCmp("IPICC_cboInfPy");
			if (objItem1) {
				objItem1.setDisabled((objRec.get('IsInfection')!='��'));
			}
			//Add By LiYang 2014-07-21 FixBug:��ʼ��ʱ���Ϊ��δ��Ⱦ�������Կ���ѡ��
			Ext.getCmp("IPICC_cboINFSymptom").setDisabled((objRec.get('IsInfection')!='��'));
			Common_SetValue('IPICC_cboPICCIntubatePos',objRec.get('PICCIntubatePosID'),objRec.get('PICCIntubatePosDesc'));
			Common_SetValue('IPICC_cboPICCIntubateSize',objRec.get('PICCIntubateSizeID'),objRec.get('PICCIntubateSizeDesc'));
			Common_SetValue('IPICC_cboPICCIntubateType',objRec.get('PICCIntubateTypeID'),objRec.get('PICCIntubateTypeDesc'));
			Common_SetValue('IPICC_cboPICCIntubateNum',objRec.get('PICCIntubateNumID'),objRec.get('PICCIntubateNumDesc'));
			Common_SetValue('IPICC_cboPICCIntubateRegion',objRec.get('PICCIntubateRegionID'),objRec.get('PICCIntubateRegionDesc'));
			Common_SetValue('IPICC_cboPICCExtubateReason',objRec.get('PICCExtubateReasonID'),objRec.get('PICCExtubateReasonDesc'));
			Common_SetValue('IPICC_cboINFSymptom',objRec.get('INFSymptomID'),objRec.get('INFSymptomDesc')); //Add BY LiYang 2014-04-11 ���Ӹ�Ⱦ֢״�ֶ�
		} else {
			Common_SetValue('IPICC_txtIntubateDateTime','');
			Common_SetValue('IPICC_txtExtubateDateTime','');
			Common_SetValue('IPICC_cboIntubatePlace','','');
			Common_SetValue('IPICC_cboPICCExtubateReason','','');
			Common_SetValue('IPICC_cboIntubateUserType','','');
			Common_SetValue('IPICC_cboIntubateUser','','');
			Common_SetValue('IPICC_chkIsInf','');
			Common_SetValue('IPICC_txtInfDate','');
			Common_SetValue('IPICC_cboInfPy','','');
			Common_SetValue('IPICC_cboINFSymptom','',''); //Add BY LiYang 2014-04-11 ���Ӹ�Ⱦ֢״�ֶ�
			
			var objItem1 = Ext.getCmp("IPICC_txtInfDate");
			if (objItem1) {
				objItem1.setDisabled(true);
			}
			var objItem1 = Ext.getCmp("IPICC_cboInfPy");
			if (objItem1) {
				objItem1.setDisabled(true);
			}
			//Add By LiYang 2014-07-21 FixBug:��ʼ��ʱ���Ϊ��δ��Ⱦ�������Կ���ѡ��
			Ext.getCmp("IPICC_cboINFSymptom").setDisabled(true);
			Common_SetValue('IPICC_cboPICCIntubatePos','','');
			Common_SetValue('IPICC_cboPICCIntubateSize','','');
			Common_SetValue('IPICC_cboPICCIntubateType','','');
			Common_SetValue('IPICC_cboPICCIntubateNum','','');
			Common_SetValue('IPICC_cboPICCIntubateRegion','','');
		}
	}

	obj.IPICC_GridRowEditer = function(objRec){
		obj.IPICC_GridRowEditer_objRec = objRec;
		var winGridRowEditer = Ext.getCmp('IPICC_GridRowEditer');
		if (!winGridRowEditer){
			winGridRowEditer = new Ext.Window({
				id : 'IPICC_GridRowEditer',
				height : 360,
				closeAction: 'hide',
				width : 300,
				modal : true,
				title : '���ľ����ù�-�༭',
				layout : 'fit',
				frame : true,
				items: [
					obj.IPICC_GridRowViewPort
				],
				bbar : [
					'->',
					new Ext.Toolbar.Button({
						id: "IPICC_GridRowEditer_btnUpdate",
						width : 80,
						text : "<img SRC='../scripts/dhcmed/img/update.gif'>����",
						listeners : {
							'click' : function(){
								var errInfo = obj.IPICC_GridRowDataCheck('');
								if (errInfo){
									ExtTool.alert("��ʾ",errInfo);
									return;
								}
								obj.IPICC_GridRowDataSave(obj.IPICC_GridRowEditer_objRec);
								winGridRowEditer.hide();
							}
						}
					}),
					new Ext.Toolbar.Button({
						id: "IPICC_GridRowEditer_btnCancel",
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
		obj.IPICC_GridRowDataSet(objRec);
	}
	
	//���б�
	obj.IPICC_GridToPICC = function(){
		var tmpGridPanel = new Ext.grid.GridPanel({
			id: arguments[0],
			store : new Ext.data.Store({
				proxy: new Ext.data.HttpProxy({
					url : ExtToolSetting.RunQueryPageURL,
					listeners : {
						'beforeload' :  function(objProxy, param){
							param.ClassName = 'DHCMed.NINFService.Rep.InfReportICU';
							param.QueryName = 'QrySubRec';
							param.Arg1      = ReportID; //obj.CurrReport.RowID;
							param.Arg2      = obj.CurrReport.EpisodeID;
							param.Arg3      = 'PICC';
							param.ArgCnt    = 3;
						}
					}
				}),
				reader: new Ext.data.JsonReader(
					{
						root: 'record',
						totalProperty: 'total',
						idProperty: 'IndRec'
					},
					[
						{name: 'IndRec', mapping: 'IndRec'}
						,{name: 'RepID', mapping: 'RepID'}
						,{name: 'SubID', mapping: 'SubID'}
						,{name: 'IsChecked', mapping: 'IsChecked'}
						,{name: 'DataSource', mapping: 'DataSource'}
						,{name: 'IntubateTypeID', mapping: 'IntubateTypeID'}
						,{name: 'IntubateTypeDesc', mapping: 'IntubateTypeDesc'}
						,{name: 'IntubateDate', mapping: 'IntubateDate'}
						,{name: 'IntubateTime', mapping: 'IntubateTime'}
						,{name: 'IntubateDateTime', mapping: 'IntubateDateTime'}
						,{name: 'ExtubateDate', mapping: 'ExtubateDate'}
						,{name: 'ExtubateTime', mapping: 'ExtubateTime'}
						,{name: 'ExtubateDateTime', mapping: 'ExtubateDateTime'}
						,{name: 'IntubatePlaceID', mapping: 'IntubatePlaceID'}
						,{name: 'IntubatePlaceDesc', mapping: 'IntubatePlaceDesc'}
						,{name: 'IntubateUserTypeID', mapping: 'IntubateUserTypeID'}
						,{name: 'IntubateUserTypeDesc', mapping: 'IntubateUserTypeDesc'}
						,{name: 'IntubateUserID', mapping: 'IntubateUserID'}
						,{name: 'IntubateUserDesc', mapping: 'IntubateUserDesc'}
						,{name: 'IsInfection', mapping: 'IsInfection'}
						,{name: 'InfDate', mapping: 'InfDate'}
						,{name: 'InfPyIDs', mapping: 'InfPyIDs'}
						,{name: 'InfPyDescs', mapping: 'InfPyDescs'}
						,{name: 'InfPyValues', mapping: 'InfPyValues'}
						,{name: 'PICCIntubatePosID', mapping: 'PICCIntubatePosID'}
						,{name: 'PICCIntubatePosDesc', mapping: 'PICCIntubatePosDesc'}
						,{name: 'PICCIntubateSizeID', mapping: 'PICCIntubateSizeID'}
						,{name: 'PICCIntubateSizeDesc', mapping: 'PICCIntubateSizeDesc'}
						,{name: 'PICCIntubateTypeID', mapping: 'PICCIntubateTypeID'}
						,{name: 'PICCIntubateTypeDesc', mapping: 'PICCIntubateTypeDesc'}
						,{name: 'PICCIntubateNumID', mapping: 'PICCIntubateNumID'}
						,{name: 'PICCIntubateNumDesc', mapping: 'PICCIntubateNumDesc'}
						,{name: 'PICCIntubateRegionID', mapping: 'PICCIntubateRegionID'}
						,{name: 'PICCIntubateRegionDesc', mapping: 'PICCIntubateRegionDesc'}
						,{name: 'PICCExtubateReasonID', mapping: 'PICCExtubateReasonID'}
						,{name: 'PICCExtubateReasonDesc', mapping: 'PICCExtubateReasonDesc'}
						//Add By LiYang 2014-04-11
						,{name: 'INFSymptomID', mapping: 'INFSymptomID'}
						,{name: 'INFSymptomDesc', mapping: 'INFSymptomDesc'}						
						
					]
				)
			})
			,height : 150
			//,overflow:'scroll'
			//,overflow-y:hidden
			//,style:'overflow:auto;overflow-y:hidden'
			//,loadMask : true
			,frame : true
			,anchor : '100%'
			,columns: [
				new Ext.grid.RowNumberer()
				,{header: 'ѡ��', width: 30, dataIndex: 'IsChecked', sortable: false, menuDisabled:true, align: 'center'
					,renderer: function(v, m, rd, r, c, s){
						var IsChecked = rd.get("IsChecked");
						if (IsChecked == '1') {
							return "<IMG src='../scripts/dhcmed/img/checked.gif'>";
						} else {
							return "<IMG src='../scripts/dhcmed/img/unchecked.gif'>";
						}
					}
				}
				,{header: '��������', width: 60, dataIndex: 'PICCIntubateTypeDesc', sortable: false, menuDisabled:true, align:'center' }
				,{header: '����ǻ��', width: 60, dataIndex: 'PICCIntubateNumDesc', sortable: false, menuDisabled:true, align:'center' }
				,{header: '�ùܲ�λ', width: 60, dataIndex: 'PICCIntubateRegionDesc', sortable: false, menuDisabled:true, align:'center' }
				,{header: '�ù�ʱ��', width: 100, dataIndex: 'IntubateDateTime', sortable: false, menuDisabled:true, align:'center' }
				,{header: '�ι�ʱ��', width: 100, dataIndex: 'ExtubateDateTime', sortable: false, menuDisabled:true, align:'center' }
				,{header: '�ù���Ա', width: 100, dataIndex: 'IntubateUserTypeDesc', sortable: false, menuDisabled:true, align:'center' }
				,{header: '�ùܵص�', width: 100, dataIndex: 'IntubatePlaceDesc', sortable: false, menuDisabled:true, align:'center' }
				,{header: '�Ƿ��Ⱦ', width: 60, dataIndex: 'IsInfection', sortable: false, menuDisabled:true, align:'center' }
				,{header: '��Ⱦ����', width: 80, dataIndex: 'InfDate', sortable: false, menuDisabled:true, align:'center' }
				,{header: '��Ⱦ֢״', width: 80, dataIndex: 'INFSymptomDesc', sortable: false, menuDisabled:true, align:'center' }
			],
			bbar : [
				new Ext.Toolbar.Button({
					id: arguments[0] + "_btnAdd",
					width : 80,
					text : "<img SRC='../scripts/dhcmed/img/add.png'>����",
					listeners : {
						'click' : function(){
							obj.IPICC_GridRowEditer("");
						}
					}
				}),
				new Ext.Toolbar.Button({
					id: arguments[0] + "_btnDelete",
					width : 80,
					text : "<img SRC='../scripts/dhcmed/img/delete.gif'>ɾ��",
					listeners : {
						'click' : function(){
							var objGrid = Ext.getCmp("IPICC_gridPICC");
							if (objGrid){
								var objRecArr = objGrid.getStore().getRange(); //Modified By LiYang 2014-07-03 FixBug:1776 ���������¼�-ҽԺ��Ⱦ����-ICU��Ⱦ��⣬������ľ����ùܼ�¼��ֱ�ӵ����ɾ������ť����ʾ"��ѡ�����ݼ�¼���ٵ��ɾ����"
								var tmpIndex = objGrid.getStore().findExact("IsChecked", "1"); //Modified By LiYang 2014-07-21 FixBug:���û�û�й�ѡ��Ŀ��Ҳ��ʾ�Ƿ�ɾ����ѡ�
								//var objRecArr = objGrid.getSelectionModel().getSelections();
								if (tmpIndex > -1){
									Ext.MessageBox.confirm('ɾ��', '�Ƿ�ɾ��ѡ�����ݼ�¼?', function(btn,text){
										if(btn=="yes"){
											for (var indRec = 0; indRec < objRecArr.length; indRec++){
												var objRec = objRecArr[indRec];
												if(objRec.get("IsChecked") == "0") //Add By LiYang 2014-07-03 FixBug: 1683 
													continue;												
												if (objRec.get('SubID')) {
													var RecID = objRec.get('RepID') + '||' + objRec.get('SubID');
													var flg = obj.ClsInfReportICUSrv.DelSubRec(objRec.get('RepID') + '||' + objRec.get('SubID'));
													if (parseInt(flg) > 0) {
														objGrid.getStore().remove(objRec);
													} else {
														ExtTool.alert("������ʾ","ɾ�����ܲ����Ϣ����!error=" + flg);
													}
												} else {
													objGrid.getStore().remove(objRec);
												}
											}
										}
									});
								} else {
									ExtTool.alert("��ʾ","��ѡ�����ݼ�¼,�ٵ��ɾ��!");
								}
							}
						}
					}
				})
			],
			viewConfig : {
				forceFit : true
			}
		});
		
		return tmpGridPanel;
	}
	obj.IPICC_gridPICC = obj.IPICC_GridToPICC("IPICC_gridPICC");
	
	//˫���д����¼�
	obj.IPICC_gridPICC.on('rowdblclick',function(){
		var rowIndex = arguments[1];
		var objRec = this.getStore().getAt(rowIndex);
		obj.IPICC_GridRowEditer(objRec);
	});
	//������Ԫ�񴥷��¼�
	obj.IPICC_gridPICC.on('cellclick',function(grid, rowIndex, columnIndex, e){
		var objRec = grid.getStore().getAt(rowIndex);
		var fieldName = grid.getColumnModel().getDataIndex(columnIndex);
		if (fieldName != 'IsChecked') return;
		
		var recValue = objRec.get('IsChecked');
		if (recValue == '1') {
			var newValue = '0';
		} else {
			var newValue = '1';
		}
		objRec.set('IsChecked', newValue);
		grid.getStore().commitChanges();
		grid.getView().refresh();
	});
	
	//���沼��
	obj.IPICC_ViewPort = {
		layout : 'fit',
		//frame : true,
		height : 200,
		anchor : '-20',
		tbar : ['<b>���ľ����ù�</b>'],
		items : [
			obj.IPICC_gridPICC
		]
	}
	
	//��ʼ��ҳ��
	obj.IPICC_InitView = function(){
		obj.IPICC_gridPICC.getStore().load({});
	}
	
	//���ݴ洢
	obj.IPICC_SaveData = function(){
		var errinfo = '';
		
		var objStore = obj.IPICC_gridPICC.getStore();
		for (var indRec = 0; indRec < objStore.getCount(); indRec++) {
			var objRec = objStore.getAt(indRec);
			
			if (objRec.get('IsChecked') == '1') {
				//����������У��
				var flg = obj.IPICC_GridRowDataCheck(objRec);
				if (flg){
					var row = objStore.indexOfId(objRec.id);  //��ȡ�к�
					errinfo = errinfo + '���ľ����ù� ��' + (row + 1) + '�� ���ݴ���!<br>'
				}
				
				var objICU = obj.ClsInfReportICUSrv.GetSubObj('');
				if (objICU) {
					if (objRec.get('RepID')&&objRec.get('SubID')) objICU.RowID = objRec.get('RepID') + '||' + objRec.get('SubID');
					objICU.DataSource = objRec.get('DataSource');
					objICU.IntubateType = obj.ClsSSDictionary.GetByTypeCode('NINFICUIntubateType','PICC','');
					objICU.IntubateDate = objRec.get('IntubateDate');
					objICU.IntubateTime = objRec.get('IntubateTime');
					objICU.ExtubateDate = objRec.get('ExtubateDate');
					objICU.ExtubateTime = objRec.get('ExtubateTime');
					objICU.IntubatePlace = obj.ClsSSDictionary.GetObjById(objRec.get('IntubatePlaceID'));
					objICU.IntubateUserType = obj.ClsSSDictionary.GetObjById(objRec.get('IntubateUserTypeID'));
					objICU.IntubateUser = objRec.get('IntubateUserID');
					objICU.InfDate = objRec.get('InfDate');
					
					objICU.InfPathogeny = new Array();
					var InfPyValues = objRec.get('InfPyValues');
					InfPyValues = InfPyValues.replace(/<\$C1>/gi,CHR_1);
					InfPyValues = InfPyValues.replace(/<\$C2>/gi,CHR_2);
					var arrPy = InfPyValues.split(CHR_1);
					for (var indPy = 0; indPy < arrPy.length; indPy++) {
						var strPyField = arrPy[indPy];
						if (strPyField == '') continue;
						var arrPyField = strPyField.split(CHR_2);
						
						var objPy = new Object();
						objPy.PathogenyID = arrPyField[0]
						objPy.PathogenyDesc = arrPyField[1]
						if (!arrPyField[1]) continue;
						
						objICU.InfPathogeny.push(objPy);
					}
					
					objICU.PICCIntubatePos = obj.ClsSSDictionary.GetObjById(objRec.get('PICCIntubatePosID'));
					objICU.PICCIntubateSize = obj.ClsSSDictionary.GetObjById(objRec.get('PICCIntubateSizeID'));
					objICU.PICCIntubateType = obj.ClsSSDictionary.GetObjById(objRec.get('PICCIntubateTypeID'));
					objICU.PICCIntubateNum = obj.ClsSSDictionary.GetObjById(objRec.get('PICCIntubateNumID'));
					objICU.PICCIntubateRegion = obj.ClsSSDictionary.GetObjById(objRec.get('PICCIntubateRegionID'));
					objICU.PICCExtubateReason = obj.ClsSSDictionary.GetObjById(objRec.get('PICCExtubateReasonID'));
					objICU.INFSymptom = obj.ClsSSDictionary.GetObjById(objRec.get('INFSymptomID')); //Add BY LiYang 2014-04-11 ���Ӹ�Ⱦ֢״�ֶ�
					obj.CurrReport.ChildICU.push(objICU);
				}
			} else {
				if (objRec.get('SubID') != '') {
					var RecID = objRec.get('RepID') + '||' + objRec.get('SubID');
					var flg = obj.ClsInfReportICUSrv.DelSubRec(RecID);
					if (parseInt(flg) > 0) {
						//ɾ���ɹ�
					} else {
						ExtTool.alert("������ʾ","ɾ����������Ϣ����!error=" + flg);
					}
				}
			}
		}
		
		return errinfo;
	}
	
	return obj;
}