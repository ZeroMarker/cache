
function InitLAB(obj)
{
	//��ԭѧ����
	obj.LAB_cbgIsPyLab = Common_RadioGroupToDic("LAB_cbgIsPyLab","��ԭѧ����","NINFInfLabBoolean",2);
	
	//��ԭѧ���� �༭��
	obj.LAB_gridLab_RowEditer_objRec = '';
	obj.LAB_gridLab_RowEditer = function(objRec) {
		obj.LAB_gridLab_RowEditer_objRec = objRec;
		var winGridRowEditer = Ext.getCmp('LAB_gridLab_RowEditer');
		if (!winGridRowEditer)
		{
			obj.LAB_gridLab_RowEditer_cboArcim = Common_ComboToArcim("LAB_gridLab_RowEditer_cboArcim","<span><b><font color='red'>*</font>����ҽ��</b></span>","L");
			obj.LAB_gridLab_RowEditer_cboSpecimen = Common_ComboToDic("LAB_gridLab_RowEditer_cboSpecimen","<span><b><font color='red'>*</font>�걾</b></span>","NINFInfSpecimen");
			obj.LAB_gridLab_RowEditer_cboInfectionPos = Common_ComboToInfPos("LAB_gridLab_RowEditer_cboInfectionPos","<span><b><font color='red'>*</font>��Ⱦ��λ</b></span>");
			obj.LAB_gridLab_RowEditer_txtSubmissionDate = Common_DateFieldToDate("LAB_gridLab_RowEditer_txtSubmissionDate","<span><b><font color='red'>*</font>�ͼ�����</b></span>");
			obj.LAB_gridLab_RowEditer_cboAssayMethod = Common_ComboToDic("LAB_gridLab_RowEditer_cboAssayMethod","<span><b><font color='red'>*</font>���鷽��</b></span>","NINFInfAssayMethod");
			obj.LAB_gridLab_RowEditer_cboPathogenTest = Common_ComboToDic("LAB_gridLab_RowEditer_cboPathogenTest","<span><b><font color='red'>*</font>������</b></span>","NINFInfPathogenTest");
			obj.LAB_gridLab_RowEditer_gridPyAnti = new Ext.grid.GridPanel({
				id: 'LAB_gridLab_RowEditer_gridPyAnti',
				store : new Ext.data.Store({
					reader: new Ext.data.JsonReader(
						{
							root: 'record',
							totalProperty: 'total'
						},
						[
							{name: 'PathogenyID', mapping: 'PathogenyID'}
							,{name: 'PathogenyDesc', mapping: 'PathogenyDesc'}
							,{name: 'AntibioticsID', mapping: 'AntibioticsID'}
							,{name: 'AntibioticsDesc', mapping: 'AntibioticsDesc'}
							,{name: 'SenTestRstID', mapping: 'SenTestRstID'}
							,{name: 'SenTestRstDesc', mapping: 'SenTestRstDesc'}
						]
					)
				})
				,anchor : '100%'
				,columns: [
					new Ext.grid.RowNumberer()
					,{header: '��ԭ��', width: 150, dataIndex: 'PathogenyDesc', sortable: false, menuDisabled:true, align:'center' }
					,{header: '����ҩ��', width: 150, dataIndex: 'AntibioticsDesc', sortable: false, menuDisabled:true, align:'center' }
					,{header: 'ҩ�����', width: 60, dataIndex: 'SenTestRstDesc', sortable: false, menuDisabled:true, align:'center' }
				],
				viewConfig : {
					forceFit : true
				}
			});
			obj.LAB_gridLab_RowEditer_gridPyAnti_cboPathogeny = Common_ComboToPathogeny("LAB_gridLab_RowEditer_gridPyAnti_cboPathogeny","��ԭ��");
			obj.LAB_gridLab_RowEditer_gridPyAnti_cboAntibiotics = Common_ComboToAntibiotics("LAB_gridLab_RowEditer_gridPyAnti_cboAntibiotics","������");
			obj.LAB_gridLab_RowEditer_gridPyAnti_cboSenTestRst = Common_ComboToDic("LAB_gridLab_RowEditer_gridPyAnti_cboSenTestRst","ҩ�����","NINFInfSenTestRst");
			obj.LAB_gridLab_RowEditer_gridPyAnti_btnAdd = new Ext.Button({
				id : 'LAB_gridLab_RowEditer_gridPyAnti_btnAdd'
				,iconCls : 'icon-add'
				,width: 80
				,text : '����'
				,listeners : {
					'click' :  function(){
						var PathogenyID = Common_GetValue('LAB_gridLab_RowEditer_gridPyAnti_cboPathogeny');
						var PathogenyDesc = Common_GetText('LAB_gridLab_RowEditer_gridPyAnti_cboPathogeny');
						var AntibioticsID = Common_GetValue('LAB_gridLab_RowEditer_gridPyAnti_cboAntibiotics');
						var AntibioticsDesc = Common_GetText('LAB_gridLab_RowEditer_gridPyAnti_cboAntibiotics');
						if (AntibioticsDesc != '') {
							var SenTestRstID = Common_GetValue('LAB_gridLab_RowEditer_gridPyAnti_cboSenTestRst');
							var SenTestRstDesc = Common_GetText('LAB_gridLab_RowEditer_gridPyAnti_cboSenTestRst');
						} else {
							var SenTestRstID = '';
							var SenTestRstDesc = '';
						}
						
						var errInfo = '';
						if (PathogenyDesc == '') {
							errInfo = errInfo + '��ԭ��Ϊ��!<br>';
						}
						if ((AntibioticsDesc != '')&&((SenTestRstID == '')||(SenTestRstDesc == ''))) {
							errInfo = errInfo + 'ҩ�����Ϊ��!<br>';
						}
						if (errInfo != '') {
							ExtTool.alert("��ʾ",errInfo);
							return;
						}
						
						Common_SetValue('LAB_gridLab_RowEditer_gridPyAnti_cboAntibiotics','','');
						Common_SetValue('LAB_gridLab_RowEditer_gridPyAnti_cboSenTestRst','','');
						
						var objGrid = Ext.getCmp('LAB_gridLab_RowEditer_gridPyAnti');
						if (objGrid) {
							var objStore = objGrid.getStore();
							
							//�ж��Ƿ������ͬҽ������,��ͬ�ͼ���������
							var IsBoolean = false;
							for (var ind = 0; ind < objStore.getCount(); ind++) {
								var tmpRec = objStore.getAt(ind);
								if ((PathogenyDesc == tmpRec.get('PathogenyDesc'))&&(AntibioticsDesc == '')) {
									IsBoolean = true;
								} else {
									if ((PathogenyDesc == tmpRec.get('PathogenyDesc'))&&(AntibioticsDesc == tmpRec.get('AntibioticsDesc'))) {
										IsBoolean = true;
									}
								}
							}
							if (IsBoolean) {
								ExtTool.alert("��ʾ","�����ظ�����!");
								return;
							}
							
							//��������
							var RecordType = objStore.recordType;
							var RecordData = new RecordType({
								PathogenyID : PathogenyID
								,PathogenyDesc : PathogenyDesc
								,AntibioticsID : AntibioticsID
								,AntibioticsDesc : AntibioticsDesc
								,SenTestRstID : SenTestRstID
								,SenTestRstDesc : SenTestRstDesc
							});
							objStore.insert(objStore.getCount(), RecordData);
							objGrid.getView().focusRow(objGrid.getStore().getCount()-1);
						}
					}
				}
			});
			obj.LAB_gridLab_RowEditer_gridPyAnti_btnDel = new Ext.Button({
				id : 'LAB_gridLab_RowEditer_gridPyAnti_btnDel'
				,iconCls : 'icon-delete'
				,width: 80
				,text : 'ɾ��'
				,listeners : {
					'click' :  function(){
						var objGrid = Ext.getCmp("LAB_gridLab_RowEditer_gridPyAnti");
						if (objGrid){
							var arrRec = objGrid.getSelectionModel().getSelections();
							if (arrRec.length>0){
								Ext.MessageBox.confirm('ɾ��', '�Ƿ�ɾ��ѡ�����ݼ�¼?', function(btn,text){
									if(btn=="yes"){
										for (var indRec = 0; indRec < arrRec.length; indRec++){
											var objRec = arrRec[indRec];
											objGrid.getStore().remove(objRec);
										}
									}
								});
							} else {
								ExtTool.alert("��ʾ","��ѡ�����ݼ�¼,�ٵ��ɾ��!");
							}
						}
					}
				}
			});
			
			winGridRowEditer = new Ext.Window({
				id : 'LAB_gridLab_RowEditer',
				height : 450,
				closeAction: 'hide',
				width : 600,
				modal : true,
				title : '��ԭѧ����-�༭',
				layout : 'border',
				frame : true,
				items: [
					{
						region: 'north',
						height : 90,
						layout : 'form',
						frame : true,
						items : [
							{
								layout : 'column',
								items : [
									{
										columnWidth :.50,
										layout : 'form',
										labelAlign : 'right',
										labelWidth : 70,
										items : [
											obj.LAB_gridLab_RowEditer_cboArcim
											,obj.LAB_gridLab_RowEditer_cboSpecimen
											//,obj.LAB_gridLab_RowEditer_cboInfectionPos
											,obj.LAB_gridLab_RowEditer_txtSubmissionDate
										]
									},{
										columnWidth :.50,
										layout : 'form',
										labelAlign : 'right',
										labelWidth : 70,
										items : [
											obj.LAB_gridLab_RowEditer_cboAssayMethod
											,obj.LAB_gridLab_RowEditer_cboPathogenTest
										]
									}
								]
							}
						]
					},{
						region: 'center',
						layout : 'border',
						frame : true,
						items : [
							{
								region: 'south',
								height: 35,
								layout : 'form',
								frame : true,
								items : [
									{
										layout : 'column',
										items : [
											{
												columnWidth :.50,
												layout : 'form',
												labelAlign : 'right',
												labelWidth : 50,
												items : [
													obj.LAB_gridLab_RowEditer_gridPyAnti_cboPathogeny
												]
											},{
												columnWidth :.50,
												layout : 'form',
												labelAlign : 'right',
												labelWidth : 50,
												items : [
													obj.LAB_gridLab_RowEditer_gridPyAnti_cboAntibiotics
												]
											},{
												width :150,
												layout : 'form',
												labelAlign : 'right',
												labelWidth : 60,
												items : [
													obj.LAB_gridLab_RowEditer_gridPyAnti_cboSenTestRst
												]
											}
										]
									}
								]
							},{
								region: 'center',
								layout : 'fit',
								//frame : true,
								items : [
									obj.LAB_gridLab_RowEditer_gridPyAnti
								]
							}
						],
						buttons : [obj.LAB_gridLab_RowEditer_gridPyAnti_btnAdd,obj.LAB_gridLab_RowEditer_gridPyAnti_btnDel,'->','��']
					}
				],
				buttons : [
					'->',
					new Ext.Toolbar.Button({
						id: "LAB_gridLab_RowEditer_btnUpdate",
						width : 80,
						text : "ȷ��",
						iconCls : 'icon-update',
						listeners : {
							'click' : function(){
								var ArcimID = Common_GetValue('LAB_gridLab_RowEditer_cboArcim');
								var ArcimDesc = Common_GetText('LAB_gridLab_RowEditer_cboArcim');
								var SpecimenID = Common_GetValue('LAB_gridLab_RowEditer_cboSpecimen');
								var SpecimenDesc = Common_GetText('LAB_gridLab_RowEditer_cboSpecimen');
								var InfectionPosID = Common_GetValue('LAB_gridLab_RowEditer_cboInfectionPos');
								var InfectionPosDesc = Common_GetText('LAB_gridLab_RowEditer_cboInfectionPos');
								var SubmissionDate = Common_GetValue('LAB_gridLab_RowEditer_txtSubmissionDate');
								var AssayMethodID = Common_GetValue('LAB_gridLab_RowEditer_cboAssayMethod');
								var AssayMethodDesc = Common_GetText('LAB_gridLab_RowEditer_cboAssayMethod');
								var PathogenTestID = Common_GetValue('LAB_gridLab_RowEditer_cboPathogenTest');
								var PathogenTestDesc = Common_GetText('LAB_gridLab_RowEditer_cboPathogenTest');
								var TestResultValues = '';
								var TestResultDescs = '';
								var objGrid = Ext.getCmp('LAB_gridLab_RowEditer_gridPyAnti');
								if (objGrid) {
									var objStore = objGrid.getStore();
									var arrPathogeny = new Array();
									for (var indRec = 0; indRec < objStore.getCount(); indRec++) {
										var objRec = objStore.getAt(indRec);
										
										//��ԭ��
										var PathogenyID = objRec.get('PathogenyID');
										var PathogenyDesc = objRec.get('PathogenyDesc');
										if (PathogenyDesc == '') continue;
										var indArrPy = -1;
										for (var indPy = 0; indPy < arrPathogeny.length; indPy++) {
											if (PathogenyDesc == arrPathogeny[indPy].PathogenyDesc) {
												indArrPy = indPy;
												break;
											}
										}
										var objPathogeny = new Object();
										if (indArrPy < 0) {
											objPathogeny.PathogenyID = PathogenyID;
											objPathogeny.PathogenyDesc = PathogenyDesc;
											objPathogeny.Antibiotics = new Array();
											arrPathogeny.push(objPathogeny);
											indArrPy = arrPathogeny.length-1;
										} else {
											objPathogeny = arrPathogeny[indArrPy];
										}
										
										//������
										var AntibioticsID = objRec.get('AntibioticsID');
										var AntibioticsDesc = objRec.get('AntibioticsDesc');
										var SenTestRstID = objRec.get('SenTestRstID');
										var SenTestRstDesc = objRec.get('SenTestRstDesc');
										if (AntibioticsDesc == '') continue;
										var indArrAnti = -1;
										for (var indAnti = 0; indAnti < objPathogeny.Antibiotics.length; indAnti++) {
											if (AntibioticsDesc == objPathogeny.Antibiotics[indAnti].AntibioticsDesc) {
												indArrAnti = indAnti;
												break;
											}
										}
										if (indArrAnti < 0) {
											var objAntiSenTest = new Object();
											objAntiSenTest.AntibioticsID = AntibioticsID;
											objAntiSenTest.AntibioticsDesc = AntibioticsDesc;
											objAntiSenTest.SenTestRstID = SenTestRstID;
											objAntiSenTest.SenTestRstDesc = SenTestRstDesc;
											objPathogeny.Antibiotics.push(objAntiSenTest);
										}
									}
									
									for (var indPy = 0; indPy < arrPathogeny.length; indPy++) {
										var objPy = arrPathogeny[indPy];
										var AntiValues = '';
										for (var indAnti = 0; indAnti < objPy.Antibiotics.length; indAnti++) {
											var objAnti = objPy.Antibiotics[indAnti];
											var AntiValue = objAnti.AntibioticsID;
											AntiValue = AntiValue + CHR_4 + objAnti.AntibioticsDesc;
											AntiValue = AntiValue + CHR_4 + objAnti.SenTestRstID;
											AntiValue = AntiValue + CHR_4 + objAnti.SenTestRstDesc;
											AntiValues = (AntiValues == '' ? AntiValue : AntiValues + CHR_3 + AntiValue);
										}
										var PyValue = objPy.PathogenyID + CHR_2 + objPy.PathogenyDesc + CHR_2 + AntiValues;
										TestResultValues = (TestResultValues == '' ? PyValue : TestResultValues + CHR_1 + PyValue);
										TestResultDescs = (TestResultDescs == '' ? objPy.PathogenyDesc : TestResultDescs + ',' + objPy.PathogenyDesc);
									}
								}
								
								var errInfo = '';
								if (ArcimDesc == '') {
									errInfo = errInfo + '����ҽ��Ϊ��!<br><br>';
								}
								if ((SpecimenID == '')||((SpecimenDesc == ''))) {
									errInfo = errInfo + '�걾Ϊ��!<br><br>';
								}
								if ((InfectionPosID == '')||((InfectionPosDesc == ''))) {
									//errInfo = errInfo + '��Ⱦ��λΪ��!<br><br>';
								}
								if (SubmissionDate == '') {
									errInfo = errInfo + '�ͼ�����Ϊ��!<br>';
								}
								if ((AssayMethodID == '')||((AssayMethodDesc == ''))) {
									errInfo = errInfo + '���鷽��Ϊ��!<br>';
								}
								if ((PathogenTestID == '')||((PathogenTestDesc == ''))) {
									errInfo = errInfo + '��ԭѧ������Ϊ��!<br>';
								}
								if (errInfo != '') {
									ExtTool.alert("��ʾ",errInfo);
									return;
								}
								
								var objRec = obj.LAB_gridLab_RowEditer_objRec;
								var objGrid = Ext.getCmp('LAB_gridLab');
								if (objGrid) {
									var objStore = objGrid.getStore();
									
									//�ж��Ƿ������ͬҽ������,��ͬ�ͼ���������
									var IsBoolean = false;
									for (var ind = 0; ind < objStore.getCount(); ind++) {
										var tmpRec = objStore.getAt(ind);
										if (objRec) {
											if (tmpRec.id == objRec.id) continue;
										}
										if ((ArcimDesc == tmpRec.get('ArcimDesc'))&&(SubmissionDate == tmpRec.get('SubmissionDate'))) {
											IsBoolean = true;
										}
									}
									if (IsBoolean) {
										ExtTool.alert("��ʾ","������ͬҽ������,��ͬ�ͼ���������!");
										return;
									}
									
									if (objRec) {      //�ύ����
										objRec.set('ArcimID',ArcimID);
										objRec.set('ArcimDesc',ArcimDesc);
										objRec.set('SpecimenID',SpecimenID);
										objRec.set('SpecimenDesc',SpecimenDesc);
										objRec.set('InfectionPosID',InfectionPosID);
										objRec.set('InfectionPosDesc',InfectionPosDesc);
										objRec.set('SubmissionDate',SubmissionDate);
										objRec.set('AssayMethodID',AssayMethodID);
										objRec.set('AssayMethodDesc',AssayMethodDesc);
										objRec.set('PathogenTestID',PathogenTestID);
										objRec.set('PathogenTestDesc',PathogenTestDesc);
										objRec.set('TestResultValues',TestResultValues);
										objRec.set('TestResultDescs',TestResultDescs);
										objRec.commit();
									} else {                 //��������
										var RecordType = objStore.recordType;
										var RecordData = new RecordType({
											RepID : ''
											,SubID : ''
											,ArcimID : ArcimID
											,ArcimDesc : ArcimDesc
											,SpecimenID : SpecimenID
											,SpecimenDesc : SpecimenDesc
											,InfectionPosID : InfectionPosID
											,InfectionPosDesc : InfectionPosDesc
											,SubmissionDate : SubmissionDate
											,AssayMethodID : AssayMethodID
											,AssayMethodDesc : AssayMethodDesc
											,PathogenTestID : PathogenTestID
											,PathogenTestDesc : PathogenTestDesc
											,TestResultValues : TestResultValues
											,TestResultDescs : TestResultDescs
											,DataSource : ''
										});
										objStore.insert(objStore.getCount(), RecordData);
										objGrid.getView().focusRow(objGrid.getStore().getCount()-1);
									}
								}
								
								winGridRowEditer.hide();
							}
						}
					}),
					new Ext.Toolbar.Button({
						id: "LAB_gridLab_RowEditer_btnCancel",
						width : 80,
						text : "ȡ��",
						iconCls : 'icon-undo',
						listeners : {
							'click' : function(){
								winGridRowEditer.hide();
							}
						}
					})
				],
				listeners :{
					'beforeshow' : function(){
						var objRec = obj.LAB_gridLab_RowEditer_objRec;
						if (objRec) {
							Common_SetValue('LAB_gridLab_RowEditer_cboArcim',objRec.get('ArcimID'),objRec.get('ArcimDesc'));
							Common_SetDisabled("LAB_gridLab_RowEditer_cboArcim",(objRec.get('DataSource') != ''));
							if(objRec.get('SpecimenDesc').substr(0,1)=='*'){//�걾���Ǻ�ʱ�ÿ�
								Common_SetValue('LAB_gridLab_RowEditer_cboSpecimen',objRec.get('SpecimenID'));
							}else{
								Common_SetValue('LAB_gridLab_RowEditer_cboSpecimen',objRec.get('SpecimenID'),objRec.get('SpecimenDesc'));
							}
							Common_SetValue('LAB_gridLab_RowEditer_cboInfectionPos',objRec.get('InfectionPosID'),objRec.get('InfectionPosDesc'));
							Common_SetValue('LAB_gridLab_RowEditer_txtSubmissionDate',objRec.get('SubmissionDate'));
							Common_SetValue('LAB_gridLab_RowEditer_cboAssayMethod',objRec.get('AssayMethodID'),objRec.get('AssayMethodDesc'));
							Common_SetValue('LAB_gridLab_RowEditer_cboPathogenTest',objRec.get('PathogenTestID'),objRec.get('PathogenTestDesc'));
							
							var objGrid = Ext.getCmp('LAB_gridLab_RowEditer_gridPyAnti');
							if (objGrid) {
								objGrid.getStore().removeAll();
								
								var objStore = objGrid.getStore();
								var TestResultValues = objRec.get('TestResultValues');
								TestResultValues = TestResultValues.replace(/<\$C2>/gi,CHR_2);
								TestResultValues = TestResultValues.replace(/<\$C3>/gi,CHR_3);
								TestResultValues = TestResultValues.replace(/<\$C4>/gi,CHR_4);
								var arrPy = TestResultValues.split(CHR_1);
								for (var indPy = 0; indPy < arrPy.length; indPy++) {
									var strPyField = arrPy[indPy];
									if (strPyField == '') continue;
									var arrPyField = strPyField.split(CHR_2);
									if (arrPyField[2] == '') {
										var RecordType = objStore.recordType;
										var RecordData = new RecordType({
											PathogenyID : arrPyField[0]
											,PathogenyDesc : arrPyField[1]
											,AntibioticsID : ''
											,AntibioticsDesc : ''
											,SenTestRstID : ''
											,SenTestRstDesc : ''
										});
										objStore.insert(objStore.getCount(), RecordData);
									} else {
										var arrAnti = arrPyField[2].split(CHR_3);
										for (var indAnti = 0; indAnti < arrAnti.length; indAnti++) {
											var strAntiField = arrAnti[indAnti];
											var arrAntiField = strAntiField.split(CHR_4);
											var RecordType = objStore.recordType;
											var RecordData = new RecordType({
												PathogenyID : arrPyField[0]
												,PathogenyDesc : arrPyField[1]
												,AntibioticsID : arrAntiField[0]
												,AntibioticsDesc : arrAntiField[1]
												,SenTestRstID : arrAntiField[2]
												,SenTestRstDesc : arrAntiField[3]
											});
											objStore.insert(objStore.getCount(), RecordData);
										}
									}
								}
							}
						} else {
							Common_SetValue('LAB_gridLab_RowEditer_cboArcim','','');
							Common_SetValue('LAB_gridLab_RowEditer_cboSpecimen','','');
							Common_SetValue('LAB_gridLab_RowEditer_cboInfectionPos','','');
							Common_SetValue('LAB_gridLab_RowEditer_txtSubmissionDate','');
							Common_SetValue('LAB_gridLab_RowEditer_cboAssayMethod','','');
							Common_SetValue('LAB_gridLab_RowEditer_cboPathogenTest','','');
							var objGrid = Ext.getCmp('LAB_gridLab_RowEditer_gridPyAnti');
							if (objGrid) {
								objGrid.getStore().removeAll();
							}
						}
						
						Common_SetValue('LAB_gridLab_RowEditer_gridPyAnti_cboPathogeny','','');
						Common_SetValue('LAB_gridLab_RowEditer_gridPyAnti_cboAntibiotics','','');
						Common_SetValue('LAB_gridLab_RowEditer_gridPyAnti_cboSenTestRst','','');
					}
				}
			});
		}
		winGridRowEditer.show();
	}
	
	
	//��ԭѧ���� ѡ���
	obj.LAB_gridLab_RowExtract_gridLab = new Ext.grid.GridPanel({
		id: 'LAB_gridLab_RowExtract_gridLab',
		store : new Ext.data.Store({
			proxy: new Ext.data.HttpProxy({
				url : ExtToolSetting.RunQueryPageURL,
				listeners : {
					'beforeload' :  function(objProxy, param){
						param.ClassName = 'DHCMed.NINFService.Rep.InfReportLab';
						param.QueryName = 'QrySubRec';
						param.Arg1      = '';
						param.Arg2      = obj.CurrReport.EpisodeID;
						param.ArgCnt    = 2;
					}
				}
			}),
			reader: new Ext.data.JsonReader(
				{
					root: 'record',
					totalProperty: 'total'
				},
				[
					{name: 'RepID', mapping: 'RepID'}
					,{name: 'SubID', mapping: 'SubID'}
					,{name: 'ArcimID', mapping: 'ArcimID'}
					,{name: 'ArcimDesc', mapping: 'ArcimDesc'}
					,{name: 'SpecimenID', mapping: 'SpecimenID'}
					,{name: 'SpecimenDesc', mapping: 'SpecimenDesc'}
					,{name: 'InfectionPosID', mapping: 'InfectionPosID'}
					,{name: 'InfectionPosDesc', mapping: 'InfectionPosDesc'}
					,{name: 'SubmissionDate', mapping: 'SubmissionDate'}
					,{name: 'AssayMethodID', mapping: 'AssayMethodID'}
					,{name: 'AssayMethodDesc', mapping: 'AssayMethodDesc'}
					,{name: 'PathogenTestID', mapping: 'PathogenTestID'}
					,{name: 'PathogenTestDesc', mapping: 'PathogenTestDesc'}
					,{name: 'TestResultValues', mapping: 'TestResultValues'}
					,{name: 'TestResultDescs', mapping: 'TestResultDescs'}
					,{name: 'DataSource', mapping: 'DataSource'}
				]
			)
		})
		,height : 180
		,columnLines : true
		,style:'overflow:auto;overflow-y:hidden'
		,loadMask : true
		,anchor : '100%'
		,columns: [
			new Ext.grid.RowNumberer()
			,{header: '����ҽ��', width: 150, dataIndex: 'ArcimDesc', sortable: false, menuDisabled:true, align:'center' }
			,{header: '�걾', width: 90, dataIndex: 'SpecimenDesc', sortable: false, menuDisabled:true, align:'center' }
			//,{header: '��Ⱦ��λ', width: 100, dataIndex: 'InfectionPosDesc', sortable: false, menuDisabled:true, align:'center' }
			,{header: '�ͼ�����', width: 90, dataIndex: 'SubmissionDate', sortable: false, menuDisabled:true, align:'center' }
			,{header: '���鷽��', width: 80, dataIndex: 'AssayMethodDesc', sortable: false, menuDisabled:true, align:'center' }
			,{header: '��ԭѧ<br>������', width: 60, dataIndex: 'PathogenTestDesc', sortable: false, menuDisabled:true, align:'center' }
			,{header: '��ԭ��', width: 200, dataIndex: 'TestResultDescs', sortable: false, menuDisabled:true, align:'center' }
			,{header: '����<br>��Դ', width: 50, dataIndex: 'DataSource', sortable: false, menuDisabled:true, align:'center' }
		],
		viewConfig : {
			forceFit : true
		}
	});
	obj.LAB_gridLab_RowExtract = function() {
		var winGridRowEditer = Ext.getCmp('LAB_gridLab_RowExtract');
		if (!winGridRowEditer)
		{
			winGridRowEditer = new Ext.Window({
				id : 'LAB_gridLab_RowExtract',
				height : 400,
				closeAction: 'hide',
				width : 600,
				modal : true,
				title : '��ԭѧ����-��ȡ',
				layout : 'fit',
				frame : true,
				items: [
					obj.LAB_gridLab_RowExtract_gridLab
				],
				buttons : [
					'->',
					new Ext.Toolbar.Button({
						id: "LAB_gridLab_RowExtract_btnUpdate",
						width : 80,
						text : "ȷ��",
						iconCls : 'icon-update',
						listeners : {
							'click' : function(){
								var objRowDataGrid = Ext.getCmp('LAB_gridLab_RowExtract_gridLab');
								var objGrid = Ext.getCmp('LAB_gridLab');
								if ((objRowDataGrid)&&(objGrid)) {
									function insertfun(){	//����ȡ�����ݲ��뵽����������
										var objStore = objGrid.getStore();
										var arrRec = objRowDataGrid.getSelectionModel().getSelections();
										var rowbreak = -1;
										for (var indRec = 0; indRec < arrRec.length; indRec++){
											var objRec = arrRec[indRec];

											//����Ƿ������ͬһ������ͬ������,����ͬ������Դ����
											var isBoolean = false;
											for (var indStore = 0; indStore < objStore.getCount(); indStore++) {
												var tmpRec = objStore.getAt(indStore);
												if ((tmpRec.get('ArcimDesc') == objRec.get('ArcimDesc'))
												&&((tmpRec.get('SubmissionDate') == objRec.get('SubmissionDate')))) {
													isBoolean = true;
												}
												if (tmpRec.get('DataSource') == objRec.get('DataSource')) {
													isBoolean = true;
												}
											}
											
											var row = objRowDataGrid.getStore().indexOfId(objRec.id);  //��ȡѡ�е��к�
											if (typeof arrSelections[row] == 'undefined') arrSelections[row] = -1;
											
											if ((isBoolean)&&(arrSelections[row]<0)) {
												rowbreak = row;
												break;       //������
											} else if (arrSelections[row] > 0) {
												continue;    //�Ѵ���
											} else {
												arrSelections[row] = 1;
											}
											
											var RecordType = objStore.recordType;
											var RecordData = new RecordType({
												RepID : objRec.get('RepID')
												,SubID : objRec.get('SubID')
												,ArcimID : objRec.get('ArcimID')
												,ArcimDesc : objRec.get('ArcimDesc')
												,SpecimenID : objRec.get('SpecimenID')
												,SpecimenDesc : objRec.get('SpecimenDesc')
												,InfectionPosID : objRec.get('InfectionPosID')
												,InfectionPosDesc : objRec.get('InfectionPosDesc')
												,SubmissionDate : objRec.get('SubmissionDate')
												,AssayMethodID : objRec.get('AssayMethodID')
												,AssayMethodDesc : objRec.get('AssayMethodDesc')
												,PathogenTestID : objRec.get('PathogenTestID')
												,PathogenTestDesc : objRec.get('PathogenTestDesc')
												,TestResultValues : objRec.get('TestResultValues')
												,TestResultDescs : objRec.get('TestResultDescs')
												,DataSource : objRec.get('DataSource')
											});
											
											objStore.insert(objStore.getCount(), RecordData);
											obj.LAB_gridLab_RowEditer(RecordData);	//���ȷ����ȡ���ݺ�ֱ�ӵ�����ԭѧ����༭���� add by yanjf,20140512
										}
										if (rowbreak > -1) {
											checkfun(rowbreak);
										} else {
											objGrid.getView().focusRow(objGrid.getStore().getCount()-1);
											winGridRowEditer.hide();
										}
									}
									
									function checkfun(row){
										Ext.MessageBox.confirm('��ʾ', '�����ظ�����,�Ƿ����?Row=' + (row + 1), function(btn,text){
											if (btn == "yes") {
												arrSelections[row] = 0;    //������
												insertfun();
											} else {
												arrSelections[row] = 1;    //�Ѵ���
												insertfun();
											}
										});
									}
									
									var arrSelections = new Array();
									insertfun();
								} else {
									winGridRowEditer.hide();
								}
							}
						}
					}),
					new Ext.Toolbar.Button({
						id: "LAB_gridLab_RowExtract_btnCancel",
						width : 80,
						text : "ȡ��",
						iconCls : 'icon-undo',
						listeners : {
							'click' : function(){
								winGridRowEditer.hide();
							}
						}
					})
				],
				listeners :{
					'beforeshow' : function(){
						var objRowDataGrid = Ext.getCmp('LAB_gridLab_RowExtract_gridLab');
						if (objRowDataGrid) {
							objRowDataGrid.getStore().load({});
						}
					}
				}
			});
		}
		winGridRowEditer.show();
	}
	
	
	//��ԭѧ���� �б�
	obj.LAB_gridLab_btnAdd = new Ext.Button({
		id : 'LAB_gridLab_btnAdd'
		,iconCls : 'icon-add'
		,width: 80
		,text : '����'
		,listeners : {
			'click' :  function(){
				obj.LAB_gridLab_RowEditer('');
			}
		}
	});
	obj.LAB_gridLab_btnDel = new Ext.Button({
		id : 'LAB_gridLab_btnDel'
		,iconCls : 'icon-delete'
		,width: 80
		,text : 'ɾ��'
		,listeners : {
			'click' :  function(){
				//Add By LiYang 2014-07-08 FixBug��1667 ҽԺ��Ⱦ����-��Ⱦ�������-��Ⱦ�����ѯ-������ĸ�Ⱦ��Ϣɾ���������ύ����ˣ����´򿪱���ʱ��Ⱦ��ϱ�ɾ��
				if(obj.CurrReport)
				{ //û�����{ ��ԭѧ���鲻��ʾ
					//Modified By LiYang 2015-03-27 FixBug:���������¼�-ҽԺ��Ⱦ����-����û���ύ�ɹ���ͨ����ɾ������ťɾ����¼�������ʱ����ʾ"���ύ"״̬�ı��治����ɾ�����ݡ�
					//�������ж�һ��RowID�Ƿ�Ϊ�գ�Ϊ��˵������δ���棬���������޸ģ������Ѿ��ύ�Ͳ��ܲ�����
					//if(obj.CurrReport.ReportStatus){
					if((obj.CurrReport.ReportStatus)&&(obj.CurrReport.RowID != "")){
						if((obj.CurrReport.ReportStatus.Code == "2")||
							(obj.CurrReport.ReportStatus.Code == "3")||
							(obj.CurrReport.ReportStatus.Code == "0"))
						{
							ExtTool.alert("������ʾ", "��" + obj.CurrReport.ReportStatus.Description + "��״̬�ı��治����ɾ����Ŀ��");
							return;
						}
					}
				}			
				var objGrid = Ext.getCmp("LAB_gridLab");
				if (objGrid){
					var arrRec = objGrid.getSelectionModel().getSelections();
					if (arrRec.length>0){
						Ext.MessageBox.confirm('ɾ��', '�Ƿ�ɾ��ѡ�����ݼ�¼?', function(btn,text){
							if(btn=="yes"){
								for (var indRec = 0; indRec < arrRec.length; indRec++){
									var objRec = arrRec[indRec];
									if (objRec.get('SubID')) {
										var RecID = objRec.get('RepID') + '||' + objRec.get('SubID');
										var flg = obj.ClsInfReportLabSrv.DelSubRec(objRec.get('RepID') + '||' + objRec.get('SubID'));
										if (parseInt(flg) > 0) {
											objGrid.getStore().remove(objRec);
										} else {
											ExtTool.alert("������ʾ","ɾ����ϴ���!error=" + flg);
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
	});
	obj.LAB_gridLab_btnGet = new Ext.Button({
		id : 'LAB_gridLab_btnGet'
		,iconCls : 'icon-update'
		,width: 80
		,text : "��ȡ����"
		,listeners : {
			'click' :  function(){
				obj.LAB_gridLab_RowExtract();
			}
		}
	});
	obj.LAB_gridLab_iniFun = function() {
		var tmpGridPanel = new Ext.grid.GridPanel({
			id: arguments[0],
			store : new Ext.data.Store({
				proxy: new Ext.data.HttpProxy({
					url : ExtToolSetting.RunQueryPageURL,
					listeners : {
						'beforeload' :  function(objProxy, param){
							param.ClassName = 'DHCMed.NINFService.Rep.InfReportLab';
							param.QueryName = 'QrySubRec';
							param.Arg1      = obj.CurrReport.RowID;
							param.Arg2      = '';   //obj.CurrReport.EpisodeID;  �½�����Ĭ�ϲ���������
							param.ArgCnt    = 2;
						}
					}
				}),
				reader: new Ext.data.JsonReader(
					{
						root: 'record',
						totalProperty: 'total'
					},
					[
						{name: 'RepID', mapping: 'RepID'}
						,{name: 'SubID', mapping: 'SubID'}
						,{name: 'ArcimID', mapping: 'ArcimID'}
						,{name: 'ArcimDesc', mapping: 'ArcimDesc'}
						,{name: 'SpecimenID', mapping: 'SpecimenID'}
						,{name: 'SpecimenDesc', mapping: 'SpecimenDesc'}
						,{name: 'InfectionPosID', mapping: 'InfectionPosID'}
						,{name: 'InfectionPosDesc', mapping: 'InfectionPosDesc'}
						,{name: 'SubmissionDate', mapping: 'SubmissionDate'}
						,{name: 'AssayMethodID', mapping: 'AssayMethodID'}
						,{name: 'AssayMethodDesc', mapping: 'AssayMethodDesc'}
						,{name: 'PathogenTestID', mapping: 'PathogenTestID'}
						,{name: 'PathogenTestDesc', mapping: 'PathogenTestDesc'}
						,{name: 'TestResultValues', mapping: 'TestResultValues'}
						,{name: 'TestResultDescs', mapping: 'TestResultDescs'}
						,{name: 'DataSource', mapping: 'DataSource'}
					]
				)
			})
			,height : 180
			,columnLines : true
			,style:'overflow:auto;overflow-y:hidden'
			,loadMask : true
			,selModel : new Ext.grid.RowSelectionModel({
				singleSelect : true
			})
			,anchor : '100%'
			,columns: [
				new Ext.grid.RowNumberer()
				,{header: '����ҽ��', width: 200, dataIndex: 'ArcimDesc', sortable: false, menuDisabled:true, align:'center' }
				,{header: '�걾', width: 80, dataIndex: 'SpecimenDesc', sortable: false, menuDisabled:true, align:'center' }
				//,{header: '��Ⱦ��λ', width: 100, dataIndex: 'InfectionPosDesc', sortable: false, menuDisabled:true, align:'center' }
				,{header: '�ͼ�����', width: 80, dataIndex: 'SubmissionDate', sortable: false, menuDisabled:true, align:'center' }
				,{header: '���鷽��', width: 80, dataIndex: 'AssayMethodDesc', sortable: false, menuDisabled:true, align:'center' }
				,{header: '��ԭѧ<br>������', width: 60, dataIndex: 'PathogenTestDesc', sortable: false, menuDisabled:true, align:'center' }
				,{header: '��ԭ��', width: 200, dataIndex: 'TestResultDescs', sortable: false, menuDisabled:true, align:'center' }
			],
			viewConfig : {
				forceFit : true
			}
		});
		
		return tmpGridPanel;
	}
	obj.LAB_gridLab = obj.LAB_gridLab_iniFun("LAB_gridLab");
	
	//��ԭѧ���� ���沼��
	obj.LAB_ViewPort = {
		id : 'LABViewPort',
		//title : '��ԭѧ����',
		layout : 'fit',
		//frame : true,
		height : 300,
		anchor : '-20',
		tbar : ['<img SRC="../scripts/dhcmed/img/epidemic.gif"><b style="font-size:16px;">��ԭѧ����</b><span style="color:red">(��ѡ����˴θ�Ⱦ��صĲ�ԭ���ͼ���...)</span></font>'],
		items : [
			{
				layout : 'border',
				frame : true,
				items : [
					{
						region: 'north',
						layout : 'form',
						height : 30,
						//frame : true,
						items : [
							{
								layout : 'column',
								items : [
									{
										width:20
									},{
										width:200,
										layout : 'form',
										labelAlign : 'right',
										labelWidth : 80,
										items : [obj.LAB_cbgIsPyLab]
									}
								]
							}
						]
					},{
						region: 'center',
						layout : 'border',
						buttonAlign : 'left',
						items : [
							{
								region: 'center',
								layout : 'fit',
								buttonAlign : 'left',
								items : [obj.LAB_gridLab]
							}
						],
						buttons : [obj.LAB_gridLab_btnGet,obj.LAB_gridLab_btnAdd,obj.LAB_gridLab_btnDel,'->','��']
					}
				]
			}
		]
	}
	
	//��ԭѧ���� �����ʼ��
	obj.LAB_InitView = function(){
		//��ʼ��"��ԭѧ����[��/��]"����Ԫ��ֵ
		var isActive = false;
		if (obj.CurrReport.ChildSumm.LabBoolean != '') {
			isActive = (obj.CurrReport.ChildSumm.LabBoolean.Code == 'Y');
		} else {
			var num = obj.ClsInfReportLabSrv.IsCheckLab(obj.CurrReport.EpisodeID);
			if (parseInt(num) > 0) {
				isActive = true;
			} else {
				isActive = false;
			}
		}
		if (isActive) {
			Common_SetValue('LAB_cbgIsPyLab','','��');
		} else {
			Common_SetValue('LAB_cbgIsPyLab','','��');
		}
		//update by zf 20130531
		//�������Ӱ�ť,����ȡ����ҩ�����
		//Common_SetDisabled('LAB_gridLab_btnAdd',(!isActive));
		Common_SetDisabled('LAB_gridLab_btnAdd',true);
		Common_SetDisabled('LAB_gridLab_btnDel',(!isActive));
		Common_SetDisabled('LAB_gridLab_btnGet',(!isActive));
		
		//��ʼ��"��ԭѧ�����б�"load��rowdblclick�¼�
		var objGrid = Ext.getCmp("LAB_gridLab");
		if (objGrid){
			objGrid.getStore().load({});
			objGrid.on('rowdblclick',function(){
				var isBoolean = Common_GetValue('LAB_cbgIsPyLab');
				if (!isBoolean) return;
				var rowIndex = arguments[1];
				var objRec = this.getStore().getAt(rowIndex);
				obj.LAB_gridLab_RowEditer(objRec);
			},objGrid);
		}
		
		//��ʼ��"��ԭѧ����"change�¼�
		var objCmp = Ext.getCmp("LAB_cbgIsPyLab");
		if (objCmp) {
			objCmp.doLayout();
			objCmp.on('change',function(cbg,val){
				var isActive = false;
				if (val.length > 0) {
					var cb = val[0];
					var objDic = obj.ClsSSDictionary.GetObjById(cb.inputValue);
					if (objDic) {
						isActive = (objDic.Code == 'Y');
					}
				}
				//update by zf 20130531
				//�������Ӱ�ť,����ȡ����ҩ�����
				//Common_SetDisabled('LAB_gridLab_btnAdd',(!isActive));
				Common_SetDisabled('LAB_gridLab_btnAdd',true);
				Common_SetDisabled('LAB_gridLab_btnDel',(!isActive));
				Common_SetDisabled('LAB_gridLab_btnGet',(!isActive));
				
				var objGrid = Ext.getCmp("LAB_gridLab");
				if (objGrid){
					if (isActive) {
						objGrid.getStore().load({});
					} else {
						objGrid.getStore().removeAll();
					}
				}
			});
		}
	}
	
	//��ԭѧ���� ���ݴ洢
	obj.LAB_SaveData = function(){
		var errinfo = '';
		
		//��ԭѧ����[��/��]
		var itmValue = Common_GetValue('LAB_cbgIsPyLab');
		obj.CurrReport.ChildSumm.LabBoolean = obj.ClsSSDictionary.GetObjById(itmValue);
		
		//���������У��
		var objSumm = obj.CurrReport.ChildSumm;
		if (!objSumm.LabBoolean) {
			errinfo = errinfo + '��ԭѧ����[��/��]δ��!<br>'
		}
		
		//��ԭѧ����
		obj.CurrReport.ChildLab   = new Array();
		var objCmp = Ext.getCmp('LAB_gridLab');
		if (objCmp) {
			var objStore = objCmp.getStore();
			for (var indRec = 0; indRec < objStore.getCount(); indRec++) {
				var objRec = objStore.getAt(indRec);
				var objLab = obj.ClsInfReportLabSrv.GetSubObj('');
				if (objLab) {
					objLab.RowID = objRec.get('RepID') + '||' + objRec.get('SubID');
					objLab.DataSource = objRec.get('DataSource');
					objLab.ArcimID = objRec.get('ArcimID');
					objLab.ArcimDesc = objRec.get('ArcimDesc');
					objLab.Specimen = obj.ClsSSDictionary.GetObjById(objRec.get('SpecimenID'));
					objLab.InfectionPos = obj.ClsInfPosition.GetObjById(objRec.get('InfectionPosID'));
					objLab.SubmissionDate = objRec.get('SubmissionDate');
					objLab.AssayMethod = obj.ClsSSDictionary.GetObjById(objRec.get('AssayMethodID'));
					objLab.PathogenTest = obj.ClsSSDictionary.GetObjById(objRec.get('PathogenTestID'));
					//����ԭ��,������,ҩ���������
					var pyerrinfo = '';
					var antierrinfo = '';
					objLab.TestResults = new Array();
					var TestResultValues = objRec.get('TestResultValues');
					TestResultValues = TestResultValues.replace(/<\$C2>/gi,CHR_2);
					TestResultValues = TestResultValues.replace(/<\$C3>/gi,CHR_3);
					TestResultValues = TestResultValues.replace(/<\$C4>/gi,CHR_4);
					var arrPy = TestResultValues.split(CHR_1);
					for (var indPy = 0; indPy < arrPy.length; indPy++) {
						var strPyField = arrPy[indPy];
						if (strPyField == '') continue;
						var arrPyField = strPyField.split(CHR_2);
						
						var objPy = new Object();
						objPy.PathogenyID = arrPyField[0]
						objPy.PathogenyDesc = arrPyField[1]
						objPy.DrugSenTest = new Array();
						
						var arrAnti = arrPyField[2].split(CHR_3);
						for (var indAnti = 0; indAnti < arrAnti.length; indAnti++) {
							var strAntiField = arrAnti[indAnti];
							if (strAntiField == '') continue;
							var arrAntiField = strAntiField.split(CHR_4);
							var objAnti = new Object();
							objAnti.AntibioticsID = arrAntiField[0]
							objAnti.AntibioticsDesc = arrAntiField[1]
							objAnti.SenTestRst = obj.ClsSSDictionary.GetObjById(arrAntiField[2]);
							
							//���������У��
							var row = objStore.indexOfId(objRec.id);  //��ȡ�к�
							if ((!objAnti.AntibioticsDesc)||(!objAnti.SenTestRst)) {
								antierrinfo = 'ҩ�����&nbsp;'
							}
							
							objPy.DrugSenTest.push(objAnti);
						}
						
						//���������У��
						var row = objStore.indexOfId(objRec.id);  //��ȡ�к�
						if (!objPy.PathogenyDesc) {
							pyerrinfo = pyerrinfo + '��ԭ��&nbsp;'
						}
						
						objLab.TestResults.push(objPy);
					}
					
					//���������У��
					var rowerrinfo = '';
					if (!objLab.ArcimDesc) {
						rowerrinfo = rowerrinfo + '����ҽ��&nbsp;'
					}
					if (!objLab.Specimen) {
						rowerrinfo = rowerrinfo + '�걾&nbsp;'
					}
					if (!objLab.InfectionPos) {
						//rowerrinfo = rowerrinfo + '��Ⱦ��λ&nbsp;'
					}
					if (!objLab.SubmissionDate) {
						rowerrinfo = rowerrinfo + '�ͼ�����&nbsp;'
					}
					if (!objLab.AssayMethod) {
						rowerrinfo = rowerrinfo + '���鷽��&nbsp;'
					}
					if (!objLab.PathogenTest) {
						rowerrinfo = rowerrinfo + '��ԭѧ������&nbsp;'
					}
					if (rowerrinfo) {
						var row = objStore.indexOfId(objRec.id);  //��ȡ�к�
						errinfo = errinfo + '��ԭѧ���� ��' + (row + 1) + '�� ' + rowerrinfo + pyerrinfo + antierrinfo +'δ��!<br>';
					}
					
					obj.CurrReport.ChildLab.push(objLab);
				}
			}
		}
		//���������У��
		var objSumm = obj.CurrReport.ChildSumm;
		if (objSumm.LabBoolean) {
			if (objSumm.LabBoolean.Code == 'Y') {
				if (obj.CurrReport.ChildLab.length < 1) {
					errinfo = errinfo + '��ԭѧ������Ϣδ��!<br>'  //update by zf 20121021 ������,������˴θ�Ⱦ�޹�,���Բ���
				}
			}
		}
		
		return errinfo;
	}
	
	return obj;
}