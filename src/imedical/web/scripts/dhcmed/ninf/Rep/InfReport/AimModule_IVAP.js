	
function InitIVAP(obj)
{
	//�ϻ�ʱ��
	obj.IVAP_txtIntubateDateTime = Common_DateFieldToDateTime("IVAP_txtIntubateDateTime","�ϻ�ʱ��");
	
	//�ѻ�ʱ��
	obj.IVAP_txtExtubateDateTime = Common_DateFieldToDateTime("IVAP_txtExtubateDateTime","�ѻ�ʱ��");
	
	//�ùܵص�
	obj.IVAP_cboIntubatePlace = Common_ComboToDic("IVAP_cboIntubatePlace","�ùܵص�","NINFICUIntubatePlace");
	
	//��������
	obj.IVAP_cboVAPIntubateType = Common_ComboToDic("IVAP_cboVAPIntubateType","��������","NINFICUVAPIntubateType");
	
	//�ù���Ա����
	obj.IVAP_cboIntubateUserType = Common_ComboToDic("IVAP_cboIntubateUserType","�ù���Ա","NINFICUIntubateUserType");
	
	//�ù���Ա
	obj.IVAP_cboIntubateUser = Common_ComboToSSUser("IVAP_cboIntubateUser","�ù���Ա");
	
	//�Ƿ��Ⱦ
	obj.IVAP_chkIsInf = Common_Checkbox("IVAP_chkIsInf","�Ƿ��Ⱦ");
	obj.IVAP_chkIsInf.on('check',function(checkbox,value){
		var objItem1 = Ext.getCmp("IVAP_txtInfDate");
		if (objItem1) {
			objItem1.setDisabled((!value));
		}
		var objItem1 = Ext.getCmp("IVAP_cboInfPy");
		if (objItem1) {
			objItem1.setDisabled((!value));
		}
		if (!value) {
			Common_SetValue('IVAP_txtInfDate','');
			Common_SetValue('IVAP_cboInfPy','','');
		}
	},obj.IVAP_chkIsInf);
	
	//��Ⱦ����
	obj.IVAP_txtInfDate = Common_DateFieldToDate("IVAP_txtInfDate","��Ⱦ����");
	
	//��ԭ��
	obj.IVAP_cboInfPy = Common_ComboToPathogeny("IVAP_cboInfPy","��ԭ��");

	//�б༭
	obj.IVAP_GridRowViewPort = {
		layout : 'form',
		labelAlign : 'right',
		labelWidth : 60,
		frame : true,
		items : [
			obj.IVAP_cboVAPIntubateType
			,obj.IVAP_txtIntubateDateTime
			,obj.IVAP_txtExtubateDateTime
			,obj.IVAP_cboIntubateUserType
			,obj.IVAP_cboIntubatePlace
			,obj.IVAP_chkIsInf
			,obj.IVAP_txtInfDate
		]
	}
	
	obj.IVAP_GridRowDataCheck = function(objRec){
		var errInfo = '';
		
		if (objRec) {
			var IVAP_txtIntubateDateTime = objRec.get('IntubateDateTime');
			if (IVAP_txtIntubateDateTime=='') {
				errInfo = errInfo + '�ϻ�ʱ��δ��!';
			}
			var IVAP_cboIntubatePlace = objRec.get('IntubatePlaceDesc');
			if (IVAP_cboIntubatePlace=='') {
				errInfo = errInfo + '�ùܵص�δ��!';
			}
			var IVAP_cboVAPIntubateType = objRec.get('VAPIntubateTypeDesc');
			if (IVAP_cboVAPIntubateType=='') {
				errInfo = errInfo + '��������δ��!';
			}
			var IVAP_cboIntubateUserType = objRec.get('IntubateUserTypeDesc');
			if (IVAP_cboIntubateUserType=='') {
				errInfo = errInfo + '�ù���Աδ��!';
			}
			var IVAP_cboIntubateUser = objRec.get('IntubateUserDesc');
			if (IVAP_cboIntubateUser=='') {
				//errInfo = errInfo + '�ù���Աδ��!';
			}
			var IVAP_txtExtubateDateTime = objRec.get('ExtubateDateTime');
			if (IVAP_txtExtubateDateTime=='') {
				//errInfo = errInfo + '�ѻ�ʱ��δ��!';
			}
			var IVAP_txtInfDate = Common_GetValue('InfDate');
		} else {
			var IVAP_txtIntubateDateTime = Common_GetValue('IVAP_txtIntubateDateTime');
			if (IVAP_txtIntubateDateTime=='') {
				errInfo = errInfo + '�ϻ�ʱ��δ��!';
			}
			var IVAP_cboIntubatePlace = Common_GetValue('IVAP_cboIntubatePlace');
			if (IVAP_cboIntubatePlace=='') {
				errInfo = errInfo + '�ùܵص�δ��!';
			}
			var IVAP_cboVAPIntubateType = Common_GetValue('IVAP_cboVAPIntubateType');
			if (IVAP_cboVAPIntubateType=='') {
				errInfo = errInfo + '��������δ��!';
			}
			var IVAP_cboIntubateUserType = Common_GetValue('IVAP_cboIntubateUserType');
			if (IVAP_cboIntubateUserType=='') {
				errInfo = errInfo + '�ù���Աδ��!';
			}
			var IVAP_cboIntubateUser = Common_GetValue('IVAP_cboIntubateUser');
			if (IVAP_cboIntubateUser=='') {
				//errInfo = errInfo + '�ù���Աδ��!';
			}
			var IVAP_txtExtubateDateTime = Common_GetValue('IVAP_txtExtubateDateTime');
			if (IVAP_txtExtubateDateTime=='') {
				//errInfo = errInfo + '�ѻ�ʱ��δ��!';
			}
			var IVAP_txtInfDate = Common_GetValue('IVAP_txtInfDate');
		}
		/*
		var today = new Date();
		//getYear()��ȡ��ǰ���(2λ),getFullYear()��ȡ���������(4λ,1970-????)
		var CurrDate = today.getFullYear() + "-" + (today.getMonth() + 1) + "-" + today.getDate();
		if (IVAP_txtIntubateDateTime != '') {
			var IntubateDate = IVAP_txtIntubateDateTime.split(" ")[0];
			var IntubateTime = IVAP_txtIntubateDateTime.split(" ")[1];
			//var flg = Common_CompareDate(IntubateDate,CurrDate);
			//if (!flg) errInfo = errInfo + '�ϻ����ڴ��ڵ�ǰ����!<br>'
			
			var objPaadm = obj.CurrPaadm;
			var flg = Common_CompareDate(objPaadm.AdmitDate,IntubateDate);
			if (!flg) errInfo = errInfo + '�ϻ�����С����Ժ����!<br>'
			if ((objPaadm.AdmitDate==IntubateDate)&&(objPaadm.AdmitTime>IntubateTime))
				errInfo = errInfo + '�ϻ�ʱ��С����Ժʱ��!<br>'
				
			if (objPaadm.DisDate) {
				var flg = Common_CompareDate(IntubateDate,objPaadm.DisDate);
				if (!flg) errInfo = errInfo + '�ϻ����ڴ��ڳ�Ժ����!<br>'
				if ((objPaadm.DisDate==IntubateDate)&&(objPaadm.DisTime<IntubateTime))
					errInfo = errInfo + '�ϻ�ʱ����ڳ�Ժʱ��!<br>'
			}
			
			var InfDate = IVAP_txtInfDate;
			if (InfDate) {
				var flg = Common_CompareDate(IntubateDate,InfDate);
				if (!flg) errInfo = errInfo + '�ϻ����ڴ��ڸ�Ⱦ����!<br>'
			}
			
			if (IVAP_txtExtubateDateTime != '') {
				var ExtubateDate = IVAP_txtExtubateDateTime.split(" ")[0];
				var ExtubateTime = IVAP_txtExtubateDateTime.split(" ")[1];
				var flg = Common_CompareDate(IntubateDate,ExtubateDate);
				if (!flg) errInfo = errInfo + '�ѻ����ڴ����ϻ�����!<br>'
				
				var flg = Common_CompareDate(ExtubateDate,CurrDate);
				if (!flg) errInfo = errInfo + '�ѻ����ڴ��ڵ�ǰ����!<br>'
				
				var flg = Common_CompareDate(objPaadm.AdmitDate,ExtubateDate);
				if (!flg) errInfo = errInfo + '�ѻ�����С����Ժ����!<br>'
				if ((objPaadm.AdmitDate==ExtubateDate)&&(objPaadm.AdmitTime>ExtubateTime))
					errInfo = errInfo + '�ѻ�ʱ��С����Ժʱ��!<br>'
					
				if (objPaadm.DisDate) {
					var flg = Common_CompareDate(ExtubateDate,objPaadm.DisDate);
					if (!flg) errInfo = errInfo + '�ѻ����ڴ��ڳ�Ժ����!<br>'
					if ((objPaadm.DisDate==ExtubateDate)&&(objPaadm.DisTime<ExtubateTime))
						errInfo = errInfo + '�ѻ�ʱ����ڳ�Ժʱ��!<br>'
				}
			}
			//update by likai for bug:2142 �ι�ʱ��Ϊ�գ���Ⱦ���ڿ��Դ��ڵ�ǰ����
			var InfDate = IVAP_txtInfDate;
			if ((InfDate)&&(IVAP_txtExtubateDateTime != '')) {
				var flg = Common_CompareDate(InfDate,ExtubateDate);
				if (!flg) errInfo = errInfo + '��Ⱦ���ڴ����ѻ�����!<br>'
				}
			if (InfDate) {
				var flg = Common_CompareDate(InfDate,CurrDate);
				if (!flg) errInfo = errInfo + '��Ⱦ���ڴ��ڵ�ǰ����!<br>'
				}
		}*/
		var objPaadm = obj.CurrPaadm;
		var dt1 = Common_DateParse(objPaadm.AdmitDate); //ת��Ϊ����
		var dt2 = Common_DateParse(objPaadm.DisDate);
		if (IVAP_txtIntubateDateTime != '') {
			var IntubateDate = Common_DateParse(IVAP_txtIntubateDateTime.split(" ")[0]);
			//var IntubateTime = IVAP_txtIntubateDateTime.split(" ")[1];
			
			var dt3 = Common_DateParse(IVAP_txtIntubateDateTime);
			if (dt3<dt1) errInfo = errInfo + '�ϻ�����С����Ժ����!<br>'
			if ((objPaadm.DisDate!="")&&(dt3>dt2)) errInfo = errInfo + '�ϻ����ڴ��ڳ�Ժ����!<br>'		
									
			if (IVAP_txtInfDate) {
				var InfDate = Common_DateParse(IVAP_txtInfDate);
				if (IntubateDate>InfDate) errInfo = errInfo + '�ϻ����ڴ��ڸ�Ⱦ����!<br>'
			}
			
			if (IVAP_txtExtubateDateTime != '') {
				var ExtubateDate = Common_DateParse(IVAP_txtExtubateDateTime.split(" ")[0]);
				//var ExtubateTime = IVAP_txtExtubateDateTime.split(" ")[1];
				var dt4 = Common_DateParse(IVAP_txtExtubateDateTime);
				if (dt4<dt1) errInfo = errInfo + '�ѻ�����С����Ժ����!<br>'
				if (dt4<dt3) errInfo = errInfo + '�ѻ�����С���ϻ�����!<br>'
				if ((objPaadm.DisDate!="")&&(dt4>dt2)) errInfo = errInfo + '�ѻ����ڴ��ڳ�Ժ����!<br>'
				
				if (Common_ComputeDays("IVAP_txtExtubateDateTime")<0) errInfo = errInfo + '�ѻ����ڴ��ڵ�ǰ����!<br>'
								
				if (IVAP_txtInfDate) {
					var InfDate = Common_DateParse(IVAP_txtInfDate);
					if (InfDate>ExtubateDate) errInfo = errInfo + '��Ⱦ���ڴ����ѻ�����!<br>'
					if (Common_ComputeDays("IVAP_txtInfDate")<0) errInfo = errInfo + '��Ⱦ���ڴ��ڵ�ǰ����!<br>'
				}							
			}
		}
		
		return errInfo;
	}
	
	obj.IVAP_GridRowDataSave = function(objRec){
		var IntubateDateTime = Common_GetValue('IVAP_txtIntubateDateTime');
		var arrDateTime = IntubateDateTime.split(' ');
		if (arrDateTime.length>1){
			var IntubateDate = arrDateTime[0];
			var IntubateTime = arrDateTime[1];
		} else {
			var IntubateDate = '';
			var IntubateTime = '';
		}
		var ExtubateDateTime = Common_GetValue('IVAP_txtExtubateDateTime');
		var arrDateTime = ExtubateDateTime.split(' ');
		if (arrDateTime.length>1){
			var ExtubateDate = arrDateTime[0];
			var ExtubateTime = arrDateTime[1];
		} else {
			var ExtubateDate = '';
			var ExtubateTime = '';
		}
		var IntubatePlaceID = Common_GetValue('IVAP_cboIntubatePlace');
		var IntubatePlaceDesc = Common_GetText('IVAP_cboIntubatePlace');
		var IntubateUserTypeID = Common_GetValue('IVAP_cboIntubateUserType');
		var IntubateUserTypeDesc = Common_GetText('IVAP_cboIntubateUserType');
		var IntubateUserID = Common_GetValue('IVAP_cboIntubateUser');
		var IntubateUserDesc = Common_GetText('IVAP_cboIntubateUser');
		var InfDate = Common_GetValue('IVAP_txtInfDate');
		var IsInfection = (InfDate != '' ? '��' : '��');
		var InfPyID = Common_GetValue('IVAP_cboInfPy');
		var InfPyDesc = Common_GetText('IVAP_cboInfPy');
		var InfPyValue = InfPyID + CHR_2 + InfPyDesc;
		var VAPIntubateTypeID = Common_GetValue('IVAP_cboVAPIntubateType');
		var VAPIntubateTypeDesc = Common_GetText('IVAP_cboVAPIntubateType');
		
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
			objRec.set('VAPIntubateTypeID',VAPIntubateTypeID);
			objRec.set('VAPIntubateTypeDesc',VAPIntubateTypeDesc);
			objRec.commit();
		} else {                 //��������
			var objGrid = Ext.getCmp('IVAP_gridVAP');
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
					,VAPIntubateTypeID : VAPIntubateTypeID
					,VAPIntubateTypeDesc : VAPIntubateTypeDesc
				});
				objStore.insert(objStore.getCount(), RecordData);
				objGrid.getView().focusRow(objGrid.getStore().getCount()-1);
			}
		}
	}
	
	obj.IVAP_GridRowDataSet = function(objRec){
		if (objRec){
			Common_SetValue('IVAP_txtIntubateDateTime',objRec.get('IntubateDateTime'));
			Common_SetValue('IVAP_txtExtubateDateTime',objRec.get('ExtubateDateTime'));
			Common_SetValue('IVAP_cboIntubatePlace',objRec.get('IntubatePlaceID'),objRec.get('IntubatePlaceDesc'));
			Common_SetValue('IVAP_cboIntubateUserType',objRec.get('IntubateUserTypeID'),objRec.get('IntubateUserTypeDesc'));
			Common_SetValue('IVAP_cboIntubateUser',objRec.get('IntubateUserID'),objRec.get('IntubateUserDesc'));
			Common_SetValue('IVAP_cboVAPIntubateType',objRec.get('VAPIntubateTypeID'),objRec.get('VAPIntubateTypeDesc'));
			
			//�Ƿ��Ⱦ,��Ⱦ����,��ԭ��
			Common_SetValue('IVAP_chkIsInf',(objRec.get('IsInfection')=='��'));
			Common_SetValue('IVAP_txtInfDate',objRec.get('InfDate'));
			var strInfPyValues = objRec.get('InfPyValues');
			strInfPyValues = strInfPyValues.replace(/<\$C1>/gi,CHR_1);
			strInfPyValues = strInfPyValues.replace(/<\$C2>/gi,CHR_2);
			var arrInfPyValues = strInfPyValues.split(CHR_1);
			if (arrInfPyValues.length > 0) {
				var strInfPyValue = arrInfPyValues[0];
				var arrInfPyValue = strInfPyValue.split(CHR_2);
				if (arrInfPyValue.length >= 2) {
					Common_SetValue('IVAP_cboInfPy',arrInfPyValue[0],arrInfPyValue[1]);
				}
			} else {
				Common_SetValue('IVAP_cboInfPy','','');
			}
			var objItem1 = Ext.getCmp("IVAP_txtInfDate");
			if (objItem1) {
				objItem1.setDisabled((objRec.get('IsInfection')!='��'));
			}
			var objItem1 = Ext.getCmp("IVAP_cboInfPy");
			if (objItem1) {
				objItem1.setDisabled((objRec.get('IsInfection')!='��'));
			}
		} else {
			Common_SetValue('IVAP_txtIntubateDateTime','');
			Common_SetValue('IVAP_txtExtubateDateTime','');
			Common_SetValue('IVAP_cboIntubatePlace','','');
			Common_SetValue('IVAP_cboIntubateUserType','','');
			Common_SetValue('IVAP_cboIntubateUser','','');
			Common_SetValue('IVAP_cboVAPIntubateType','','');
			Common_SetValue('IVAP_chkIsInf','');
			Common_SetValue('IVAP_txtInfDate','');
			Common_SetValue('IVAP_cboInfPy','','');
			var objItem1 = Ext.getCmp("IVAP_txtInfDate");
			if (objItem1) {
				objItem1.setDisabled(true);
			}
			var objItem1 = Ext.getCmp("IVAP_cboInfPy");
			if (objItem1) {
				objItem1.setDisabled(true);
			}
		}
	}
	
	obj.IVAP_GridRowEditer = function(objRec){
		obj.IVAP_GridRowEditer_objRec = objRec;
		var winGridRowEditer = Ext.getCmp('IVAP_GridRowEditer');
		if (!winGridRowEditer){
			winGridRowEditer = new Ext.Window({
				id : 'IVAP_GridRowEditer',
				height : 280,
				closeAction: 'hide',
				width : 300,
				modal : true,
				title : '������-�༭',
				layout : 'fit',
				frame : true,
				items: [
					obj.IVAP_GridRowViewPort
				],
				buttons : [
					'->',
					new Ext.Toolbar.Button({
						id: "IVAP_GridRowEditer_btnUpdate",
						width : 80,
						text : "ȷ��",
						iconCls : 'icon-update',
						listeners : {
							'click' : function(){
								var errInfo = obj.IVAP_GridRowDataCheck('');
								if (errInfo){
									ExtTool.alert("��ʾ",errInfo);
									return;
								}
								obj.IVAP_GridRowDataSave(obj.IVAP_GridRowEditer_objRec);
								winGridRowEditer.hide();
							}
						}
					}),
					new Ext.Toolbar.Button({
						id: "IVAP_GridRowEditer_btnCancel",
						width : 80,
						text : "ȡ��",
						iconCls : 'icon-undo',
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
		obj.IVAP_GridRowDataSet(objRec);
	}
	
	//���б�
	obj.IVAP_GridToVAP = function(){
		var tmpGridPanel = new Ext.grid.GridPanel({
			id: arguments[0],
			store : new Ext.data.Store({
				proxy: new Ext.data.HttpProxy({
					url : ExtToolSetting.RunQueryPageURL,
					listeners : {
						'beforeload' :  function(objProxy, param){
							param.ClassName = 'DHCMed.NINFService.Rep.InfReportICU';
							param.QueryName = 'QrySubRec';
							param.Arg1      = obj.CurrReport.RowID;
							param.Arg2      = obj.CurrReport.EpisodeID;
							param.Arg3      = 'VAP';
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
						,{name: 'VAPIntubateTypeID', mapping: 'VAPIntubateTypeID'}
						,{name: 'VAPIntubateTypeDesc', mapping: 'VAPIntubateTypeDesc'}
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
				,{header: '��������', width: 60, dataIndex: 'VAPIntubateTypeDesc', sortable: false, menuDisabled:true, align:'center' }
				,{header: '�ϻ�ʱ��', width: 100, dataIndex: 'IntubateDateTime', sortable: false, menuDisabled:true, align:'center' }
				,{header: '�ѻ�ʱ��', width: 100, dataIndex: 'ExtubateDateTime', sortable: false, menuDisabled:true, align:'center' }
				,{header: '�ù���Ա', width: 100, dataIndex: 'IntubateUserTypeDesc', sortable: false, menuDisabled:true, align:'center' }
				,{header: '�ùܵص�', width: 100, dataIndex: 'IntubatePlaceDesc', sortable: false, menuDisabled:true, align:'center' }
				,{header: '�Ƿ��Ⱦ', width: 60, dataIndex: 'IsInfection', sortable: false, menuDisabled:true, align:'center' }
				,{header: '��Ⱦ����', width: 80, dataIndex: 'InfDate', sortable: false, menuDisabled:true, align:'center' }
			],
			buttonAlign : 'left',
			buttons : [
				new Ext.Toolbar.Button({
					id: arguments[0] + "_btnAdd",
					width : 80,
					text : "����",
					iconCls : 'icon-add',
					listeners : {
						'click' : function(){
							obj.IVAP_GridRowEditer("");
						}
					}
				}),
				new Ext.Toolbar.Button({
					id: arguments[0] + "_btnDelete",
					width : 80,
					text : "ɾ��",
					iconCls : 'icon-delete',
					listeners : {
						'click' : function(){
						//Add By zhoubo 2014-12-20 FixBug��1772:ɾ�����ľ����ù�/������/��������/��ԭѧ�����¼,�������ύ�����������еļ�¼��ɾ��
						if(obj.CurrReport)
						{
								//Modified By LiYang 2015-03-27 FixBug:���������¼�-ҽԺ��Ⱦ����-����û���ύ�ɹ���ͨ����ɾ������ťɾ����¼�������ʱ����ʾ"���ύ"״̬�ı��治����ɾ�����ݡ�
								//�������ж�һ��RowID�Ƿ�Ϊ�գ�Ϊ��˵������δ���棬���������޸ģ������Ѿ��ύ�Ͳ��ܲ�����
								//if(obj.CurrReport.ReportStatus){
								if((obj.CurrReport.ReportStatus)&&(obj.CurrReport.RowID != "")){
								if((obj.CurrReport.ReportStatus.Code == "2")||(obj.CurrReport.ReportStatus.Code == "3")||(obj.CurrReport.ReportStatus.Code == "0"))
								{
									ExtTool.alert("������ʾ", "��" + obj.CurrReport.ReportStatus.Description + "��״̬�ı��治����ɾ����Ŀ��");
									return;
								}
							}
						}
							var objGrid = Ext.getCmp("IVAP_gridVAP");
							if (objGrid){
								//var objRecArr = objGrid.getSelectionModel().getSelections();
								var objRecArr = objGrid.getStore().getRange(); //Modified By LiYang 2014-07-03 FixBug:1776 ���������¼�-ҽԺ��Ⱦ����-ICU��Ⱦ��⣬������ľ����ùܼ�¼��ֱ�ӵ����ɾ������ť����ʾ"��ѡ�����ݼ�¼���ٵ��ɾ����"
								for (var indRec = 0; indRec < objRecArr.length; indRec++){ //add by zhoubo 2014-12-12  fixBug:1683
									var objRec = objRecArr[indRec];
									var flag=0
									if(objRec.get("IsChecked") == "1"){							
										var flag=1;
									}
								}
								if (objRecArr.length>0&&flag==1){
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
														ExtTool.alert("������ʾ","ɾ����������Ϣ����!error=" + flg);
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
	obj.IVAP_gridVAP = obj.IVAP_GridToVAP("IVAP_gridVAP");
	
	//˫���д����¼�
	obj.IVAP_gridVAP.on('rowdblclick',function(){
		var rowIndex = arguments[1];
		var objRec = this.getStore().getAt(rowIndex);
		obj.IVAP_GridRowEditer(objRec);
	});
	//������Ԫ�񴥷��¼�
	obj.IVAP_gridVAP.on('cellclick',function(grid, rowIndex, columnIndex, e){
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
	obj.IVAP_ViewPort = {
		id : 'IVAPViewPort',
		layout : 'fit',
		//frame : true,
		height : 200,
		anchor : '-20',
		tbar : ['<img SRC="../scripts/dhcmed/img/UC.png"><b style="font-size:16px;">������</b>'],
		items : [
			obj.IVAP_gridVAP
		]
	}
	
	//��ʼ��ҳ��
	obj.IVAP_InitView = function(){
		obj.IVAP_gridVAP.getStore().load({});
	}
	
	//���ݴ洢
	obj.IVAP_SaveData = function(){
		var errinfo = '';
		
		var objStore = obj.IVAP_gridVAP.getStore();
		for (var indRec = 0; indRec < objStore.getCount(); indRec++) {
			var objRec = objStore.getAt(indRec);
			
			if (objRec.get('IsChecked') == '1') {
				//����������У��
				var flg = obj.IVAP_GridRowDataCheck(objRec);
				if (flg){
					var row = objStore.indexOfId(objRec.id);  //��ȡ�к�
					errinfo = errinfo + '������ ��' + (row + 1) + '�� ���ݴ���!<br>'
				}
				
				var objICU = obj.ClsInfReportICUSrv.GetSubObj('');
				if (objICU) {
					if (objRec.get('RepID')&&objRec.get('SubID')) objICU.RowID = objRec.get('RepID') + '||' + objRec.get('SubID');
					objICU.DataSource = objRec.get('DataSource');
					objICU.IntubateType = obj.ClsSSDictionary.GetByTypeCode('NINFICUIntubateType','VAP','');
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
					
					objICU.VAPIntubateType = obj.ClsSSDictionary.GetObjById(objRec.get('VAPIntubateTypeID'));
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