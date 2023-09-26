	
function InitNVNT(obj)
{
	//�ù�ʱ��
	obj.NVNT_txtIntubateDateTime = Common_DateFieldToDateTime("NVNT_txtIntubateDateTime","�ù�ʱ��");
	
	//�ι�ʱ��
	obj.NVNT_txtExtubateDateTime = Common_DateFieldToDateTime("NVNT_txtExtubateDateTime","�ι�ʱ��");
	
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
	
	//�б༭
	obj.NVNT_GridRowViewPort = {
		layout : 'form',
		labelAlign : 'right',
		labelWidth : 60,
		frame : true,
		items : [
			obj.NVNT_txtIntubateDateTime
			,obj.NVNT_txtExtubateDateTime
			,obj.NVNT_chkIsInf
			,obj.NVNT_txtInfDate
			,obj.NVNT_cboInfPy
		]
	}
	
	obj.NVNT_GridRowDataCheck = function(objRec){
		var errInfo = '';
		if (objRec) {
			var NVNT_txtIntubateDateTime = objRec.get('IntubateDateTime');
			if (NVNT_txtIntubateDateTime=='') {
				errInfo = errInfo + '�ù�ʱ��δ��!';
			}
			var NVNT_txtExtubateDateTime = objRec.get('ExtubateDateTime');
			if (NVNT_txtExtubateDateTime=='') {
				//errInfo = errInfo + '�ι�ʱ��δ��!';
			}
			var NVNT_txtInfDate = Common_GetValue('InfDate');
		} else {
			var NVNT_txtIntubateDateTime = Common_GetValue('NVNT_txtIntubateDateTime');
			if (NVNT_txtIntubateDateTime=='') {
				errInfo = errInfo + '�ù�ʱ��δ��!';
			}
			var NVNT_txtExtubateDateTime = Common_GetValue('NVNT_txtExtubateDateTime');
			if (NVNT_txtExtubateDateTime=='') {
				//errInfo = errInfo + '�ι�ʱ��δ��!';
			}
			var NVNT_txtInfDate = Common_GetValue('NVNT_txtInfDate');
		}
		
		var AdmDate = Common_GetValue('NBASE_txtAdmDate');
		var DisDate = Common_GetValue('NBASE_txtDisDate');
		/*var dt1 = new Number(Date.parseDate(AdmDate, "Y-m-d H:i:s"));
		var dt2 = new Number(Date.parseDate(DisDate, "Y-m-d H:i:s"));
		var today = new Date();
		//getYear()��ȡ��ǰ���(2λ),getFullYear()��ȡ���������(4λ,1970-????)
		var CurrDate = today.getFullYear() + "-" + (today.getMonth() + 1) + "-" + today.getDate();
		if (NVNT_txtIntubateDateTime != '') {
			var IntubateDate = NVNT_txtIntubateDateTime.split(" ")[0];
			
			var dt3 = new Number(Date.parseDate(NVNT_txtIntubateDateTime, "Y-m-d H:i"));
			if (dt3<dt1) errInfo = errInfo + '�ù�����С����Ժ����!<br>'
			if (dt3>dt2) errInfo = errInfo + '�ù����ڴ��ڳ�Ժ����!<br>'
		
			var InfDate = NVNT_txtInfDate;
			if (InfDate) {
				var flg = Common_CompareDate(IntubateDate,InfDate);
				if (!flg) errInfo = errInfo + '�ù����ڴ��ڸ�Ⱦ����!<br>'
			}
			
			if (NVNT_txtExtubateDateTime != '') {
				var ExtubateDate = NVNT_txtExtubateDateTime.split(" ")[0];
				
				var dt4 = new Number(Date.parseDate(NVNT_txtExtubateDateTime, "Y-m-d H:i"));
				if (dt4<dt1) errInfo = errInfo + '�ι�����С����Ժ����!<br>'
				if (dt4<dt3) errInfo = errInfo + '�ι�����С���ù�����!<br>'
				if (dt4>dt2) errInfo = errInfo + '�ι����ڴ��ڳ�Ժ����!<br>'
				
				var flg = Common_CompareDate(ExtubateDate,CurrDate);
				if (!flg) errInfo = errInfo + '�ι����ڴ��ڵ�ǰ����!<br>'
				
				var InfDate = NVNT_txtInfDate;
				if (InfDate) {
					var flg = Common_CompareDate(InfDate,ExtubateDate);
					if (!flg) errInfo = errInfo + '��Ⱦ���ڴ��ڰι�����!<br>'
				}
			}
		}*/
		
		var dt1 = Common_DateParse(AdmDate); //ת��Ϊ����
		var dt2 = Common_DateParse(DisDate);
		if (NVNT_txtIntubateDateTime != '') {
			var IntubateDate = Common_DateParse(NVNT_txtIntubateDateTime.split(" ")[0]);
			
			var dt3 = Common_DateParse(NVNT_txtIntubateDateTime);
			if (dt3<dt1) errInfo = errInfo + '�ù�����С����Ժ����!<br>'
			if ((DisDate!="")&&(dt3>dt2)) errInfo = errInfo + '�ù����ڴ��ڳ�Ժ����!<br>'
					
			if (NVNT_txtInfDate!="") {
				var InfDate = Common_DateParse(NVNT_txtInfDate);
				if (IntubateDate>InfDate) errInfo = errInfo + '�ù����ڴ��ڸ�Ⱦ����!<br>'
			}
			
			if (NVNT_txtExtubateDateTime != '') {
				var ExtubateDate = Common_DateParse(NVNT_txtExtubateDateTime.split(" ")[0]);
				
				var dt4 = Common_DateParse(NVNT_txtExtubateDateTime);
				if (dt4<dt1) errInfo = errInfo + '�ι�����С����Ժ����!<br>'
				if (dt4<dt3) errInfo = errInfo + '�ι�����С���ù�����!<br>'
				if ((DisDate!="")&&(dt4>dt2)) errInfo = errInfo + '�ι����ڴ��ڳ�Ժ����!<br>'
				
				if (Common_ComputeDays("NVNT_txtExtubateDateTime")<0) errInfo = errInfo + '�ι����ڴ��ڵ�ǰ����!<br>'
				
				if (NVNT_txtInfDate!="") {
					var InfDate = Common_DateParse(NVNT_txtInfDate);
					if (InfDate>ExtubateDate) errInfo = errInfo + '��Ⱦ���ڴ��ڰι�����!<br>'
				}
			}
		}
		
		return errInfo;
	}
	
	obj.NVNT_GridRowDataSave = function(objRec){
		var IntubateDateTime = Common_GetValue('NVNT_txtIntubateDateTime');
		var arrDateTime = IntubateDateTime.split(' ');
		if (arrDateTime.length>1){
			var IntubateDate = arrDateTime[0];
			var IntubateTime = arrDateTime[1];
		} else {
			var IntubateDate = '';
			var IntubateTime = '';
		}
		var ExtubateDateTime = Common_GetValue('NVNT_txtExtubateDateTime');
		var arrDateTime = ExtubateDateTime.split(' ');
		if (arrDateTime.length>1){
			var ExtubateDate = arrDateTime[0];
			var ExtubateTime = arrDateTime[1];
		} else {
			var ExtubateDate = '';
			var ExtubateTime = '';
		}
		var InfDate = Common_GetValue('NVNT_txtInfDate');
		var IsInfection = (InfDate != '' ? '��' : '��');
		var InfPyID = Common_GetValue('NVNT_cboInfPy');
		var InfPyDesc = Common_GetText('NVNT_cboInfPy');
		var InfPyValue = InfPyID + CHR_2 + InfPyDesc;
		
		if (objRec) {      //�ύ����
			objRec.set('IntubateDate',IntubateDate);
			objRec.set('IntubateTime',IntubateTime);
			objRec.set('IntubateDateTime',IntubateDateTime);
			objRec.set('ExtubateDate',ExtubateDate);
			objRec.set('ExtubateTime',ExtubateTime);
			objRec.set('ExtubateDateTime',ExtubateDateTime);
			objRec.set('IsInfection',IsInfection);
			objRec.set('InfDate',InfDate);
			objRec.set('InfPyIDs',InfPyID);
			objRec.set('InfPyDescs',InfPyDesc);
			objRec.set('InfPyValues',InfPyValue);
			objRec.commit();
		} else {                 //��������
			var objGrid = Ext.getCmp('NVNT_gridNVNT');
			if (objGrid){
				var objStore = objGrid.getStore();
				var RecordType = objStore.recordType;
				var RecordData = new RecordType({
					RepID : obj.CurrReport.RowID
					,SubID : ''
					,IntubateDate : IntubateDate
					,IntubateTime : IntubateTime
					,IntubateDateTime : IntubateDateTime
					,ExtubateDate : ExtubateDate
					,ExtubateTime : ExtubateTime
					,ExtubateDateTime : ExtubateDateTime
					,IsInfection : IsInfection
					,InfDate : InfDate
					,InfPyIDs : InfPyID
					,InfPyDescs : InfPyDesc
					,InfPyValues : InfPyValue
				});
				objStore.insert(objStore.getCount(), RecordData);
				objGrid.getView().focusRow(objGrid.getStore().getCount()-1);
			}
		}
	}
	
	obj.NVNT_GridRowDataSet = function(objRec){
		if (objRec){
			Common_SetValue('NVNT_txtIntubateDateTime',objRec.get('IntubateDateTime'));
			Common_SetValue('NVNT_txtExtubateDateTime',objRec.get('ExtubateDateTime'));
			
			//�Ƿ��Ⱦ����Ⱦ���ڡ���ԭ��
			Common_SetValue('NVNT_chkIsInf',(objRec.get('IsInfection')=='��'));
			Common_SetValue('NVNT_txtInfDate',objRec.get('InfDate'));
			var strInfPyValues = objRec.get('InfPyValues');
			strInfPyValues = strInfPyValues.replace(/<\$C1>/gi,CHR_1);
			strInfPyValues = strInfPyValues.replace(/<\$C2>/gi,CHR_2);
			var arrInfPyValues = strInfPyValues.split(CHR_1);
			if (arrInfPyValues.length > 0) {
				var strInfPyValue = arrInfPyValues[0];
				var arrInfPyValue = strInfPyValue.split(CHR_2);
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
	
	obj.NVNT_GridRowEditer = function(objRec){
		obj.NVNT_GridRowEditer_objRec = objRec;
		var winGridRowEditer = Ext.getCmp('NVNT_GridRowEditer');
		if (!winGridRowEditer){
			winGridRowEditer = new Ext.Window({
				id : 'NVNT_GridRowEditer',
				height : 240,
				closeAction: 'hide',
				width : 300,
				modal : true,
				title : '���ܲ�� �༭',
				layout : 'fit',
				frame : true,
				items: [
					obj.NVNT_GridRowViewPort
				],
				buttons : [
					'->',
					new Ext.Toolbar.Button({
						id: "NVNT_GridRowEditer_btnUpdate",
						width : 80,
						text : "ȷ��",
						iconCls : 'icon-update',
						listeners : {
							'click' : function(){
								var errInfo = obj.NVNT_GridRowDataCheck('');
								if (errInfo){
									ExtTool.alert("��ʾ",errInfo);
									return;
								}
								obj.NVNT_GridRowDataSave(obj.NVNT_GridRowEditer_objRec);
								winGridRowEditer.hide();
							}
						}
					}),
					new Ext.Toolbar.Button({
						id: "NVNT_GridRowEditer_btnCancel",
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
		obj.NVNT_GridRowDataSet(objRec);
	}
	
	//���б�
	obj.NVNT_GridToNVNT = function(){
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
							param.Arg3      = 'NVNT';
							param.ArgCnt    = 3;
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
						,{name: 'IntubateTypeID', mapping: 'IntubateTypeID'}
						,{name: 'IntubateTypeDesc', mapping: 'IntubateTypeDesc'}
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
					]
				)
			})
			,height : 120
			//,overflow:'scroll'
			//,overflow-y:hidden
			//,style:'overflow:auto;overflow-y:hidden'
			//,loadMask : true
			,frame : true
			,anchor : '100%'
			,columns: [
				new Ext.grid.RowNumberer()
				,{header: '�ù�ʱ��', width: 150, dataIndex: 'IntubateDateTime', sortable: false, menuDisabled:true, align:'center' }
				,{header: '�ι�ʱ��', width: 150, dataIndex: 'ExtubateDateTime', sortable: false, menuDisabled:true, align:'center' }
				,{header: '�Ƿ��Ⱦ', width: 100, dataIndex: 'IsInfection', sortable: false, menuDisabled:true, align:'center' }
				,{header: '��Ⱦ����', width: 100, dataIndex: 'InfDate', sortable: false, menuDisabled:true, align:'center' }
				,{header: '��ԭ��', width: 240, dataIndex: 'InfPyDescs', sortable: false, menuDisabled:true, align:'center' }
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
							obj.NVNT_GridRowEditer("");
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
							var objGrid = Ext.getCmp("NVNT_gridNVNT");
							if (objGrid){
								var objRecArr = objGrid.getSelectionModel().getSelections(); //modify by mxp 20160930 Fixbug:269750 ����ѡ��������¼ ��ɾ������
								if (objRecArr.length>0){
									Ext.MessageBox.confirm('ɾ��', '�Ƿ�ɾ��ѡ�����ݼ�¼?', function(btn,text){
										if(btn=="yes"){
											for (var indRec = 0; indRec < objRecArr.length; indRec++){
												var objRec = objRecArr[indRec];
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
											//objGrid.getStore().load({});  //modify by mxp 20160930 Fixbug:269747 δ�ύ״̬�²����Ƿ�ѡ�м�¼ �����ɾ����������м�¼
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
	obj.NVNT_gridNVNT = obj.NVNT_GridToNVNT("NVNT_gridNVNT");
	
	//���沼��
	obj.NVNT_ViewPort = {
		id : 'NVNTViewPort',
		layout : 'fit',
		//frame : true,
		height : 200,
		anchor : '-20',
		tbar : ['<img SRC="../scripts/dhcmed/img/vnt.png"><b style="font-size:16px;">NICU-���ܲ��</b>'],
		items : [
			obj.NVNT_gridNVNT
		]
	}
	
	//��ʼ��ҳ��
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
	}
	
	//���ݴ洢
	obj.NVNT_SaveData = function(){
		var errinfo = '';
		
		var objCmp = Ext.getCmp('NVNT_gridNVNT');
		if (objCmp) {
			var objStore = objCmp.getStore();
			for (var indRec = 0; indRec < objStore.getCount(); indRec++) {
				var objRec = objStore.getAt(indRec);
				
				//����������У��
				var flg = obj.NVNT_GridRowDataCheck(objRec);
				if (flg){
					var row = objStore.indexOfId(objRec.id);  //��ȡ�к�
					errinfo = errinfo + '������ ��' + (row + 1) + '�� ���ݴ���!<br>'
				}
				
				var objICU = obj.ClsInfReportICUSrv.GetSubObj('');
				if (objICU) {
					if (objRec.get('RepID')&&objRec.get('SubID')) objICU.RowID = objRec.get('RepID') + '||' + objRec.get('SubID');
					objICU.IntubateType = obj.ClsSSDictionary.GetByTypeCode('NINFICUIntubateType','NVNT','');
					objICU.IntubateDate = objRec.get('IntubateDate');
					objICU.IntubateTime = objRec.get('IntubateTime');
					objICU.ExtubateDate = objRec.get('ExtubateDate');
					objICU.ExtubateTime = objRec.get('ExtubateTime');
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
					
					obj.CurrReport.ChildICU.push(objICU);
				}
			}
		}
		
		return errinfo;
	}
	
	return obj;
}