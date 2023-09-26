	
function InitNUC(obj)
{
	//�ù�ʱ��
	obj.NUC_txtIntubateDateTime = Common_DateFieldToDateTime("NUC_txtIntubateDateTime","�ù�ʱ��");
	
	//�ι�ʱ��
	obj.NUC_txtExtubateDateTime = Common_DateFieldToDateTime("NUC_txtExtubateDateTime","�ι�ʱ��");
	
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
	
	//�б༭
	obj.NUC_GridRowViewPort = {
		layout : 'form',
		labelAlign : 'right',
		labelWidth : 60,
		frame : true,
		items : [
			obj.NUC_txtIntubateDateTime
			,obj.NUC_txtExtubateDateTime
			,obj.NUC_chkIsInf
			,obj.NUC_txtInfDate
			,obj.NUC_cboInfPy
		]
	}
	
	obj.NUC_GridRowDataCheck = function(objRec){
		var errInfo = '';
		if (objRec) {
			var NUC_txtIntubateDateTime = objRec.get('IntubateDateTime');
			if (NUC_txtIntubateDateTime=='') {
				errInfo = errInfo + '�ù�ʱ��δ��!';
			}
			var NUC_txtExtubateDateTime = objRec.get('ExtubateDateTime');
			if (NUC_txtExtubateDateTime=='') {
				//errInfo = errInfo + '�ι�ʱ��δ��!';
			}
			var NUC_txtInfDate = Common_GetValue('InfDate');
		} else {
			var NUC_txtIntubateDateTime = Common_GetValue('NUC_txtIntubateDateTime');
			if (NUC_txtIntubateDateTime=='') {
				errInfo = errInfo + '�ù�ʱ��δ��!';
			}
			var NUC_txtExtubateDateTime = Common_GetValue('NUC_txtExtubateDateTime');
			if (NUC_txtExtubateDateTime=='') {
				//errInfo = errInfo + '�ι�ʱ��δ��!';
			}
			var NUC_txtInfDate = Common_GetValue('NUC_txtInfDate');
		}
		
		var AdmDate = Common_GetValue('NBASE_txtAdmDate');
		var DisDate = Common_GetValue('NBASE_txtDisDate');
		/*var dt1 = new Number(Date.parseDate(AdmDate, "Y-m-d H:i:s"));
		var dt2 = new Number(Date.parseDate(DisDate, "Y-m-d H:i:s"));
		var today = new Date();
		//getYear()��ȡ��ǰ���(2λ),getFullYear()��ȡ���������(4λ,1970-????)
		var CurrDate = today.getFullYear() + "-" + (today.getMonth() + 1) + "-" + today.getDate();
	
		if (NUC_txtIntubateDateTime != '') {
			var IntubateDate = NUC_txtIntubateDateTime.split(" ")[0];
			
			var dt3 = new Number(Date.parseDate(NUC_txtIntubateDateTime, "Y-m-d H:i"));
			if (dt3<dt1) errInfo = errInfo + '�ù�����С����Ժ����!<br>'
			if (dt3>dt2) errInfo = errInfo + '�ù����ڴ��ڳ�Ժ����!<br>'
			
			var InfDate = NUC_txtInfDate;
			if (InfDate) {
				var flg = Common_CompareDate(IntubateDate,InfDate);
				if (!flg) errInfo = errInfo + '�ù����ڴ��ڸ�Ⱦ����!<br>'
			}
			
			if (NUC_txtExtubateDateTime != '') {
				var ExtubateDate = NUC_txtExtubateDateTime.split(" ")[0];
				
				var flg = Common_CompareDate(ExtubateDate,CurrDate);
				if (!flg) errInfo = errInfo + '�ι����ڴ��ڵ�ǰ����!<br>'
				
				var dt4 = new Number(Date.parseDate(NUC_txtExtubateDateTime, "Y-m-d H:i"));
				if (dt4<dt1) errInfo = errInfo + '�ι�����С����Ժ����!<br>'
				if (dt4<dt3) errInfo = errInfo + '�ι�����С���ù�����!<br>'
				if (dt4>dt2) errInfo = errInfo + '�ι����ڴ��ڳ�Ժ����!<br>'
				
				var InfDate = NUC_txtInfDate;
				if (InfDate) {
					var flg = Common_CompareDate(InfDate,ExtubateDate);
					if (!flg) errInfo = errInfo + '��Ⱦ���ڴ��ڰι�����!<br>'
				}
			}
		}*/
		var dt1 = Common_DateParse(AdmDate); //ת��Ϊ����
		var dt2 = Common_DateParse(DisDate);
		if (NUC_txtIntubateDateTime != '') {
			var IntubateDate = Common_DateParse(NUC_txtIntubateDateTime.split(" ")[0]);
			//var IntubateTime = IPICC_txtIntubateDateTime.split(" ")[1];
			
			var dt3 = Common_DateParse(NUC_txtIntubateDateTime);
			if (dt3<dt1) errInfo = errInfo + '�������С����Ժ����!<br>'
			if ((DisDate!="")&&(dt3>dt2)) errInfo = errInfo + '������ڴ��ڳ�Ժ����!<br>'		
						
			if (NUC_txtInfDate!="") {
				var InfDate = Common_DateParse(NUC_txtInfDate);
				if (IntubateDate>InfDate) errInfo = errInfo + '������ڴ��ڸ�Ⱦ����!<br>'
			}
			
			if (NUC_txtExtubateDateTime != '') {
				var ExtubateDate = Common_DateParse(NUC_txtExtubateDateTime.split(" ")[0]);
				//var ExtubateTime = IUC_txtExtubateDateTime.split(" ")[1];
				var dt4 = Common_DateParse(NUC_txtExtubateDateTime);
				if (dt4<dt1) errInfo = errInfo + '�ι�����С����Ժ����!<br>'
				if (dt4<dt3) errInfo = errInfo + '�ι�����С�ڲ������!<br>'
				if ((DisDate!="")&&(dt4>dt2)) errInfo = errInfo + '�ι����ڴ��ڳ�Ժ����!<br>'
				
				if (Common_ComputeDays("NUC_txtExtubateDateTime")<0) errInfo = errInfo + '�ι����ڴ��ڵ�ǰ����!<br>'
				
				if (NUC_txtInfDate!="") {
					var InfDate = Common_DateParse(NUC_txtInfDate);
					if (InfDate>ExtubateDate) errInfo = errInfo + '��Ⱦ���ڴ��ڰι�����!<br>'
					if (Common_ComputeDays("NUC_txtInfDate")<0) errInfo = errInfo + '��Ⱦ���ڴ��ڵ�ǰ����!<br>'
				}							
			}
		}
		
		return errInfo;
	}
	
	obj.NUC_GridRowDataSave = function(objRec){
		var IntubateDateTime = Common_GetValue('NUC_txtIntubateDateTime');
		var arrDateTime = IntubateDateTime.split(' ');
		if (arrDateTime.length>1){
			var IntubateDate = arrDateTime[0];
			var IntubateTime = arrDateTime[1];
		} else {
			var IntubateDate = '';
			var IntubateTime = '';
		}
		var ExtubateDateTime = Common_GetValue('NUC_txtExtubateDateTime');
		var arrDateTime = ExtubateDateTime.split(' ');
		if (arrDateTime.length>1){
			var ExtubateDate = arrDateTime[0];
			var ExtubateTime = arrDateTime[1];
		} else {
			var ExtubateDate = '';
			var ExtubateTime = '';
		}
		var InfDate = Common_GetValue('NUC_txtInfDate');
		var IsInfection = (InfDate != '' ? '��' : '��');
		var InfPyID = Common_GetValue('NUC_cboInfPy');
		var InfPyDesc = Common_GetText('NUC_cboInfPy');
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
			var objGrid = Ext.getCmp('NUC_gridNUC');
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
	
	obj.NUC_GridRowDataSet = function(objRec) {
		if (objRec){
			Common_SetValue('NUC_txtIntubateDateTime',objRec.get('IntubateDateTime'));
			Common_SetValue('NUC_txtExtubateDateTime',objRec.get('ExtubateDateTime'));
			
			//�Ƿ��Ⱦ,��Ⱦ����,��ԭ��
			Common_SetValue('NUC_chkIsInf',(objRec.get('IsInfection')=='��'));
			Common_SetValue('NUC_txtInfDate',objRec.get('InfDate'));
			var strInfPyValues = objRec.get('InfPyValues');
			strInfPyValues = strInfPyValues.replace(/<\$C1>/gi,CHR_1);
			strInfPyValues = strInfPyValues.replace(/<\$C2>/gi,CHR_2);
			var arrInfPyValues = strInfPyValues.split(CHR_1);
			if (arrInfPyValues.length > 0) {
				var strInfPyValue = arrInfPyValues[0];
				var arrInfPyValue = strInfPyValue.split(CHR_2);
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
	
	obj.NUC_GridRowEditer = function(objRec){
		obj.NUC_GridRowEditer_objRec = objRec;
		var winGridRowEditer = Ext.getCmp('NUC_GridRowEditer');
		if (!winGridRowEditer){
			winGridRowEditer = new Ext.Window({
				id : 'NUC_GridRowEditer',
				height : 240,
				closeAction: 'hide',
				width : 300,
				modal : true,
				title : 'NICU-�꾲�� �༭',
				layout : 'fit',
				frame : true,
				items: [
					obj.NUC_GridRowViewPort
				],
				buttons : [
					'->',
					new Ext.Toolbar.Button({
						id: "NUC_GridRowEditer_btnUpdate",
						width : 80,
						text : "ȷ��",
						iconCls : 'icon-update',
						listeners : {
							'click' : function(){
								var errInfo = obj.NUC_GridRowDataCheck('');
								if (errInfo){
									ExtTool.alert("��ʾ",errInfo);
									return;
								}
								obj.NUC_GridRowDataSave(obj.NUC_GridRowEditer_objRec);
								winGridRowEditer.hide();
							}
						}
					}),
					new Ext.Toolbar.Button({
						id: "NUC_GridRowEditer_btnCancel",
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
		obj.NUC_GridRowDataSet(objRec);
	}
	
	//���б�
	obj.NUC_GridToNUC = function() {
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
							param.Arg3      = 'NUC';
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
							obj.NUC_GridRowEditer("");
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
							var objGrid = Ext.getCmp("NUC_gridNUC");
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
											//objGrid.getStore().load({}); //modify by mxp 20160930 Fixbug:269747 δ�ύ״̬�²����Ƿ�ѡ�м�¼ �����ɾ����������м�¼
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
	obj.NUC_gridNUC = obj.NUC_GridToNUC("NUC_gridNUC");
	
	//���沼��
	obj.NUC_ViewPort = {
		id : 'NUCViewPort',
		layout : 'fit',
		//frame : true,
		height : 200,
		anchor : '-20',
		tbar : ['<img SRC="../scripts/dhcmed/img/UC.png"><b style="font-size:16px;">NICU-�꾲��</b>'],
		items : [
			obj.NUC_gridNUC
		]
	}
	
	//��ʼ��ҳ��
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
	}
	
	//���ݴ洢
	obj.NUC_SaveData = function(){
		var errinfo = '';
		
		var objCmp = Ext.getCmp('NUC_gridNUC');
		if (objCmp) {
			var objStore = objCmp.getStore();
			for (var indRec = 0; indRec < objStore.getCount(); indRec++) {
				var objRec = objStore.getAt(indRec);
				
				//����������У��
				var flg = obj.NUC_GridRowDataCheck(objRec);
				if (flg){
					var row = objStore.indexOfId(objRec.id);  //��ȡ�к�
					errinfo = errinfo + '������ ��' + (row + 1) + '�� ���ݴ���!<br>'
				}
				
				var objICU = obj.ClsInfReportICUSrv.GetSubObj('');
				if (objICU) {
					if (objRec.get('RepID')&&objRec.get('SubID')) objICU.RowID = objRec.get('RepID') + '||' + objRec.get('SubID');
					objICU.IntubateType = obj.ClsSSDictionary.GetByTypeCode('NINFICUIntubateType','NUC','');
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