
function InitLAB(obj)
{
	//病原学检验
	obj.LAB_cbgIsPyLab = Common_RadioGroupToDic("LAB_cbgIsPyLab","病原学检验","NINFInfLabBoolean",2);
	
	//病原学检验 编辑框
	obj.LAB_gridLab_RowEditer_objRec = '';
	obj.LAB_gridLab_RowEditer = function(objRec) {
		obj.LAB_gridLab_RowEditer_objRec = objRec;
		var winGridRowEditer = Ext.getCmp('LAB_gridLab_RowEditer');
		if (!winGridRowEditer)
		{
			obj.LAB_gridLab_RowEditer_cboArcim = Common_ComboToArcim("LAB_gridLab_RowEditer_cboArcim","<span><b><font color='red'>*</font>检验医嘱</b></span>","L");
			obj.LAB_gridLab_RowEditer_cboSpecimen = Common_ComboToDic("LAB_gridLab_RowEditer_cboSpecimen","<span><b><font color='red'>*</font>标本</b></span>","NINFInfSpecimen");
			obj.LAB_gridLab_RowEditer_cboInfectionPos = Common_ComboToInfPos("LAB_gridLab_RowEditer_cboInfectionPos","<span><b><font color='red'>*</font>感染部位</b></span>");
			obj.LAB_gridLab_RowEditer_txtSubmissionDate = Common_DateFieldToDate("LAB_gridLab_RowEditer_txtSubmissionDate","<span><b><font color='red'>*</font>送检日期</b></span>");
			obj.LAB_gridLab_RowEditer_cboAssayMethod = Common_ComboToDic("LAB_gridLab_RowEditer_cboAssayMethod","<span><b><font color='red'>*</font>检验方法</b></span>","NINFInfAssayMethod");
			obj.LAB_gridLab_RowEditer_cboPathogenTest = Common_ComboToDic("LAB_gridLab_RowEditer_cboPathogenTest","<span><b><font color='red'>*</font>检验结果</b></span>","NINFInfPathogenTest");
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
					,{header: '病原体', width: 150, dataIndex: 'PathogenyDesc', sortable: false, menuDisabled:true, align:'center' }
					,{header: '抗菌药物', width: 150, dataIndex: 'AntibioticsDesc', sortable: false, menuDisabled:true, align:'center' }
					,{header: '药敏结果', width: 60, dataIndex: 'SenTestRstDesc', sortable: false, menuDisabled:true, align:'center' }
				],
				viewConfig : {
					forceFit : true
				}
			});
			obj.LAB_gridLab_RowEditer_gridPyAnti_cboPathogeny = Common_ComboToPathogeny("LAB_gridLab_RowEditer_gridPyAnti_cboPathogeny","病原体");
			obj.LAB_gridLab_RowEditer_gridPyAnti_cboAntibiotics = Common_ComboToAntibiotics("LAB_gridLab_RowEditer_gridPyAnti_cboAntibiotics","抗生素");
			obj.LAB_gridLab_RowEditer_gridPyAnti_cboSenTestRst = Common_ComboToDic("LAB_gridLab_RowEditer_gridPyAnti_cboSenTestRst","药敏结果","NINFInfSenTestRst");
			obj.LAB_gridLab_RowEditer_gridPyAnti_btnAdd = new Ext.Button({
				id : 'LAB_gridLab_RowEditer_gridPyAnti_btnAdd'
				,iconCls : 'icon-add'
				,width: 80
				,text : '增加'
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
							errInfo = errInfo + '病原体为空!<br>';
						}
						if ((AntibioticsDesc != '')&&((SenTestRstID == '')||(SenTestRstDesc == ''))) {
							errInfo = errInfo + '药敏结果为空!<br>';
						}
						if (errInfo != '') {
							ExtTool.alert("提示",errInfo);
							return;
						}
						
						Common_SetValue('LAB_gridLab_RowEditer_gridPyAnti_cboAntibiotics','','');
						Common_SetValue('LAB_gridLab_RowEditer_gridPyAnti_cboSenTestRst','','');
						
						var objGrid = Ext.getCmp('LAB_gridLab_RowEditer_gridPyAnti');
						if (objGrid) {
							var objStore = objGrid.getStore();
							
							//判断是否存在相同医嘱名称,相同送检日期数据
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
								ExtTool.alert("提示","存在重复数据!");
								return;
							}
							
							//插入数据
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
				,text : '删除'
				,listeners : {
					'click' :  function(){
						var objGrid = Ext.getCmp("LAB_gridLab_RowEditer_gridPyAnti");
						if (objGrid){
							var arrRec = objGrid.getSelectionModel().getSelections();
							if (arrRec.length>0){
								Ext.MessageBox.confirm('删除', '是否删除选中数据记录?', function(btn,text){
									if(btn=="yes"){
										for (var indRec = 0; indRec < arrRec.length; indRec++){
											var objRec = arrRec[indRec];
											objGrid.getStore().remove(objRec);
										}
									}
								});
							} else {
								ExtTool.alert("提示","请选中数据记录,再点击删除!");
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
				title : '病原学检验-编辑',
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
						buttons : [obj.LAB_gridLab_RowEditer_gridPyAnti_btnAdd,obj.LAB_gridLab_RowEditer_gridPyAnti_btnDel,'->','…']
					}
				],
				buttons : [
					'->',
					new Ext.Toolbar.Button({
						id: "LAB_gridLab_RowEditer_btnUpdate",
						width : 80,
						text : "确定",
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
										
										//病原体
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
										
										//抗生素
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
									errInfo = errInfo + '检验医嘱为空!<br><br>';
								}
								if ((SpecimenID == '')||((SpecimenDesc == ''))) {
									errInfo = errInfo + '标本为空!<br><br>';
								}
								if ((InfectionPosID == '')||((InfectionPosDesc == ''))) {
									//errInfo = errInfo + '感染部位为空!<br><br>';
								}
								if (SubmissionDate == '') {
									errInfo = errInfo + '送检日期为空!<br>';
								}
								if ((AssayMethodID == '')||((AssayMethodDesc == ''))) {
									errInfo = errInfo + '检验方法为空!<br>';
								}
								if ((PathogenTestID == '')||((PathogenTestDesc == ''))) {
									errInfo = errInfo + '病原学检验结果为空!<br>';
								}
								if (errInfo != '') {
									ExtTool.alert("提示",errInfo);
									return;
								}
								
								var objRec = obj.LAB_gridLab_RowEditer_objRec;
								var objGrid = Ext.getCmp('LAB_gridLab');
								if (objGrid) {
									var objStore = objGrid.getStore();
									
									//判断是否存在相同医嘱名称,相同送检日期数据
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
										ExtTool.alert("提示","存在相同医嘱名称,相同送检日期数据!");
										return;
									}
									
									if (objRec) {      //提交数据
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
									} else {                 //插入数据
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
						text : "取消",
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
							if(objRec.get('SpecimenDesc').substr(0,1)=='*'){//标本带星号时置空
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
	
	
	//病原学检验 选择框
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
			,{header: '检验医嘱', width: 150, dataIndex: 'ArcimDesc', sortable: false, menuDisabled:true, align:'center' }
			,{header: '标本', width: 90, dataIndex: 'SpecimenDesc', sortable: false, menuDisabled:true, align:'center' }
			//,{header: '感染部位', width: 100, dataIndex: 'InfectionPosDesc', sortable: false, menuDisabled:true, align:'center' }
			,{header: '送检日期', width: 90, dataIndex: 'SubmissionDate', sortable: false, menuDisabled:true, align:'center' }
			,{header: '检验方法', width: 80, dataIndex: 'AssayMethodDesc', sortable: false, menuDisabled:true, align:'center' }
			,{header: '病原学<br>检验结果', width: 60, dataIndex: 'PathogenTestDesc', sortable: false, menuDisabled:true, align:'center' }
			,{header: '病原体', width: 200, dataIndex: 'TestResultDescs', sortable: false, menuDisabled:true, align:'center' }
			,{header: '数据<br>来源', width: 50, dataIndex: 'DataSource', sortable: false, menuDisabled:true, align:'center' }
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
				title : '病原学检验-提取',
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
						text : "确定",
						iconCls : 'icon-update',
						listeners : {
							'click' : function(){
								var objRowDataGrid = Ext.getCmp('LAB_gridLab_RowExtract_gridLab');
								var objGrid = Ext.getCmp('LAB_gridLab');
								if ((objRowDataGrid)&&(objGrid)) {
									function insertfun(){	//将提取的数据插入到检验主界面
										var objStore = objGrid.getStore();
										var arrRec = objRowDataGrid.getSelectionModel().getSelections();
										var rowbreak = -1;
										for (var indRec = 0; indRec < arrRec.length; indRec++){
											var objRec = arrRec[indRec];

											//检查是否存在相同一天多个相同名手术,或相同数据来源数据
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
											
											var row = objRowDataGrid.getStore().indexOfId(objRec.id);  //获取选中的行号
											if (typeof arrSelections[row] == 'undefined') arrSelections[row] = -1;
											
											if ((isBoolean)&&(arrSelections[row]<0)) {
												rowbreak = row;
												break;       //待处理
											} else if (arrSelections[row] > 0) {
												continue;    //已处理
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
											obj.LAB_gridLab_RowEditer(RecordData);	//点击确定提取数据后直接弹出病原学检验编辑界面 add by yanjf,20140512
										}
										if (rowbreak > -1) {
											checkfun(rowbreak);
										} else {
											objGrid.getView().focusRow(objGrid.getStore().getCount()-1);
											winGridRowEditer.hide();
										}
									}
									
									function checkfun(row){
										Ext.MessageBox.confirm('提示', '存在重复数据,是否添加?Row=' + (row + 1), function(btn,text){
											if (btn == "yes") {
												arrSelections[row] = 0;    //待处理
												insertfun();
											} else {
												arrSelections[row] = 1;    //已处理
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
						text : "取消",
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
	
	
	//病原学检验 列表
	obj.LAB_gridLab_btnAdd = new Ext.Button({
		id : 'LAB_gridLab_btnAdd'
		,iconCls : 'icon-add'
		,width: 80
		,text : '增加'
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
		,text : '删除'
		,listeners : {
			'click' :  function(){
				//Add By LiYang 2014-07-08 FixBug：1667 医院感染管理-感染报告管理-感染报告查询-将报告的感染信息删除，不做提交或审核，重新打开报告时感染诊断被删除
				if(obj.CurrReport)
				{ //没有这个{ 病原学检验不显示
					//Modified By LiYang 2015-03-27 FixBug:公共卫生事件-医院感染报告-报告没有提交成功，通过【删除】按钮删除已录入的数据时，提示"“提交"状态的报告不能再删除数据”
					//再增加判断一下RowID是否为空，为空说明报告未保存，可以任意修改，否则已经提交就不能操作了
					//if(obj.CurrReport.ReportStatus){
					if((obj.CurrReport.ReportStatus)&&(obj.CurrReport.RowID != "")){
						if((obj.CurrReport.ReportStatus.Code == "2")||
							(obj.CurrReport.ReportStatus.Code == "3")||
							(obj.CurrReport.ReportStatus.Code == "0"))
						{
							ExtTool.alert("错误提示", "“" + obj.CurrReport.ReportStatus.Description + "”状态的报告不能再删除项目！");
							return;
						}
					}
				}			
				var objGrid = Ext.getCmp("LAB_gridLab");
				if (objGrid){
					var arrRec = objGrid.getSelectionModel().getSelections();
					if (arrRec.length>0){
						Ext.MessageBox.confirm('删除', '是否删除选中数据记录?', function(btn,text){
							if(btn=="yes"){
								for (var indRec = 0; indRec < arrRec.length; indRec++){
									var objRec = arrRec[indRec];
									if (objRec.get('SubID')) {
										var RecID = objRec.get('RepID') + '||' + objRec.get('SubID');
										var flg = obj.ClsInfReportLabSrv.DelSubRec(objRec.get('RepID') + '||' + objRec.get('SubID'));
										if (parseInt(flg) > 0) {
											objGrid.getStore().remove(objRec);
										} else {
											ExtTool.alert("错误提示","删除诊断错误!error=" + flg);
										}
									} else {
										objGrid.getStore().remove(objRec);
									}
								}
							}
						});
					} else {
						ExtTool.alert("提示","请选中数据记录,再点击删除!");
					}
				}
			}
		}
	});
	obj.LAB_gridLab_btnGet = new Ext.Button({
		id : 'LAB_gridLab_btnGet'
		,iconCls : 'icon-update'
		,width: 80
		,text : "提取数据"
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
							param.Arg2      = '';   //obj.CurrReport.EpisodeID;  新建报告默认不加载数据
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
				,{header: '检验医嘱', width: 200, dataIndex: 'ArcimDesc', sortable: false, menuDisabled:true, align:'center' }
				,{header: '标本', width: 80, dataIndex: 'SpecimenDesc', sortable: false, menuDisabled:true, align:'center' }
				//,{header: '感染部位', width: 100, dataIndex: 'InfectionPosDesc', sortable: false, menuDisabled:true, align:'center' }
				,{header: '送检日期', width: 80, dataIndex: 'SubmissionDate', sortable: false, menuDisabled:true, align:'center' }
				,{header: '检验方法', width: 80, dataIndex: 'AssayMethodDesc', sortable: false, menuDisabled:true, align:'center' }
				,{header: '病原学<br>检验结果', width: 60, dataIndex: 'PathogenTestDesc', sortable: false, menuDisabled:true, align:'center' }
				,{header: '病原体', width: 200, dataIndex: 'TestResultDescs', sortable: false, menuDisabled:true, align:'center' }
			],
			viewConfig : {
				forceFit : true
			}
		});
		
		return tmpGridPanel;
	}
	obj.LAB_gridLab = obj.LAB_gridLab_iniFun("LAB_gridLab");
	
	//病原学检验 界面布局
	obj.LAB_ViewPort = {
		id : 'LABViewPort',
		//title : '病原学检验',
		layout : 'fit',
		//frame : true,
		height : 300,
		anchor : '-20',
		tbar : ['<img SRC="../scripts/dhcmed/img/epidemic.gif"><b style="font-size:16px;">病原学检验</b><span style="color:red">(请选择与此次感染相关的病原菌送检结果...)</span></font>'],
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
						buttons : [obj.LAB_gridLab_btnGet,obj.LAB_gridLab_btnAdd,obj.LAB_gridLab_btnDel,'->','…']
					}
				]
			}
		]
	}
	
	//病原学检验 界面初始化
	obj.LAB_InitView = function(){
		//初始化"病原学检验[是/否]"界面元素值
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
			Common_SetValue('LAB_cbgIsPyLab','','是');
		} else {
			Common_SetValue('LAB_cbgIsPyLab','','否');
		}
		//update by zf 20130531
		//屏蔽增加按钮,避免取不到药敏结果
		//Common_SetDisabled('LAB_gridLab_btnAdd',(!isActive));
		Common_SetDisabled('LAB_gridLab_btnAdd',true);
		Common_SetDisabled('LAB_gridLab_btnDel',(!isActive));
		Common_SetDisabled('LAB_gridLab_btnGet',(!isActive));
		
		//初始化"病原学检验列表"load及rowdblclick事件
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
		
		//初始化"病原学检验"change事件
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
				//屏蔽增加按钮,避免取不到药敏结果
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
	
	//病原学检验 数据存储
	obj.LAB_SaveData = function(){
		var errinfo = '';
		
		//病原学检验[是/否]
		var itmValue = Common_GetValue('LAB_cbgIsPyLab');
		obj.CurrReport.ChildSumm.LabBoolean = obj.ClsSSDictionary.GetObjById(itmValue);
		
		//数据完成性校验
		var objSumm = obj.CurrReport.ChildSumm;
		if (!objSumm.LabBoolean) {
			errinfo = errinfo + '病原学检验[是/否]未填!<br>'
		}
		
		//病原学检验
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
					//处理病原体,抗生素,药敏结果数据
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
							
							//数据完成性校验
							var row = objStore.indexOfId(objRec.id);  //获取行号
							if ((!objAnti.AntibioticsDesc)||(!objAnti.SenTestRst)) {
								antierrinfo = '药敏结果&nbsp;'
							}
							
							objPy.DrugSenTest.push(objAnti);
						}
						
						//数据完成性校验
						var row = objStore.indexOfId(objRec.id);  //获取行号
						if (!objPy.PathogenyDesc) {
							pyerrinfo = pyerrinfo + '病原体&nbsp;'
						}
						
						objLab.TestResults.push(objPy);
					}
					
					//数据完成性校验
					var rowerrinfo = '';
					if (!objLab.ArcimDesc) {
						rowerrinfo = rowerrinfo + '检验医嘱&nbsp;'
					}
					if (!objLab.Specimen) {
						rowerrinfo = rowerrinfo + '标本&nbsp;'
					}
					if (!objLab.InfectionPos) {
						//rowerrinfo = rowerrinfo + '感染部位&nbsp;'
					}
					if (!objLab.SubmissionDate) {
						rowerrinfo = rowerrinfo + '送检日期&nbsp;'
					}
					if (!objLab.AssayMethod) {
						rowerrinfo = rowerrinfo + '检验方法&nbsp;'
					}
					if (!objLab.PathogenTest) {
						rowerrinfo = rowerrinfo + '病原学检验结果&nbsp;'
					}
					if (rowerrinfo) {
						var row = objStore.indexOfId(objRec.id);  //获取行号
						errinfo = errinfo + '病原学检验 第' + (row + 1) + '行 ' + rowerrinfo + pyerrinfo + antierrinfo +'未填!<br>';
					}
					
					obj.CurrReport.ChildLab.push(objLab);
				}
			}
		}
		//数据完成性校验
		var objSumm = obj.CurrReport.ChildSumm;
		if (objSumm.LabBoolean) {
			if (objSumm.LabBoolean.Code == 'Y') {
				if (obj.CurrReport.ChildLab.length < 1) {
					errinfo = errinfo + '病原学检验信息未填!<br>'  //update by zf 20121021 做化验,但是与此次感染无关,可以不填
				}
			}
		}
		
		return errinfo;
	}
	
	return obj;
}