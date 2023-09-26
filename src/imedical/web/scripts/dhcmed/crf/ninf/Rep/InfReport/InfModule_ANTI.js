
function InitANTI(obj)
{
	//使用抗菌药物
	obj.ANTI_cbgIsAntibiotics = Common_RadioGroupToDic("ANTI_cbgIsAntibiotics","使用抗菌药物","NINFInfAntiBoolean",2);
	//不良反应
	obj.ANTI_cbgAdverseReaction = Common_RadioGroupToDic("ANTI_cbgAdverseReaction","不良反应","NINFInfAdverseReaction",2);
	//二重感染
	obj.ANTI_cbgSuperinfection = Common_RadioGroupToDic("ANTI_cbgSuperinfection","二重感染","NINFInfSuperinfection",2);
	
	//抗菌用药 编辑框
	obj.ANTI_gridAnti_RowEditer_objRec = '';
	obj.ANTI_gridAnti_RowEditer = function(objRec) {
		obj.ANTI_gridAnti_RowEditer_objRec = objRec;
		var winGridRowEditer = Ext.getCmp('ANTI_gridAnti_RowEditer');
		if (!winGridRowEditer)
		{
			obj.ANTI_gridAnti_RowEditer_cboArcim = Common_ComboToArcim("ANTI_gridAnti_RowEditer_cboArcim","<span style='color:red'><b>药品医嘱</b></span>","R","ANTI_gridAnti_RowEditer_cboDoseUnit");
			obj.ANTI_gridAnti_RowEditer_txtDoseQty = Common_NumberField("ANTI_gridAnti_RowEditer_txtDoseQty","<span style='color:red'><b>剂量</b></span>",0,1,10);
			obj.ANTI_gridAnti_RowEditer_cboDoseUnit = Common_ComboToDoseUnit("ANTI_gridAnti_RowEditer_cboDoseUnit","<span style='color:red'><b>剂量单位</b></span>","ANTI_gridAnti_RowEditer_cboArcim");
			obj.ANTI_gridAnti_RowEditer_cboPhcFreq = Common_ComboToFreq("ANTI_gridAnti_RowEditer_cboPhcFreq","<span style='color:red'><b>频次</b></span>");
			obj.ANTI_gridAnti_RowEditer_txtStartDateTime = Common_DateFieldToDateTime("ANTI_gridAnti_RowEditer_txtStartDateTime","<span style='color:red'><b>开始时间</b></span>");
			obj.ANTI_gridAnti_RowEditer_txtEndDateTime = Common_DateFieldToDateTime("ANTI_gridAnti_RowEditer_txtEndDateTime","<span style='color:red'><b>结束时间</b></span>");
			obj.ANTI_gridAnti_RowEditer_cboMedUsePurpose = Common_ComboToDic("ANTI_gridAnti_RowEditer_cboMedUsePurpose","<span style='color:red'><b>用途</b></span>","NINFInfMedUsePurpose");
			obj.ANTI_gridAnti_RowEditer_cboAdminRoute = Common_ComboToDic("ANTI_gridAnti_RowEditer_cboAdminRoute","<span style='color:red'><b>给药途径</b></span>","NINFInfAdminRoute");
			obj.ANTI_gridAnti_RowEditer_cboMedPurpose = Common_ComboToDic("ANTI_gridAnti_RowEditer_cboMedPurpose","<span style='color:red'><b>目的</b></span>","NINFInfMedPurpose");
			obj.ANTI_gridAnti_RowEditer_cboTreatmentMode = Common_ComboToDic("ANTI_gridAnti_RowEditer_cboTreatmentMode","<span style='color:red'><b>治疗用药方式</b></span>","NINFInfTreatmentMode");
			obj.ANTI_gridAnti_RowEditer_cboPreMedIndicat = Common_ComboToDic("ANTI_gridAnti_RowEditer_cboPreMedIndicat","<span style='color:red'><b>预防用药指征</b></span>","NINFInfPreMedIndicat");
			obj.ANTI_gridAnti_RowEditer_cboPreMedEffect = Common_ComboToDic("ANTI_gridAnti_RowEditer_cboPreMedEffect","<span style='color:red'><b>预防用药效果</b></span>","NINFInfPreMedEffect");
			obj.ANTI_gridAnti_RowEditer_cboCombinedMed = Common_ComboToDic("ANTI_gridAnti_RowEditer_cboCombinedMed","<span style='color:red'><b>联合用药</b></span>","NINFInfCombinedMed");
			obj.ANTI_gridAnti_RowEditer_txtPreMedTime = Common_TextFieldToFormat("ANTI_gridAnti_RowEditer_txtPreMedTime","<span style='color:red'><b>术前用药时间</b></span>","小时:分钟");
			obj.ANTI_gridAnti_RowEditer_txtPostMedDays = Common_TextFieldToFormat("ANTI_gridAnti_RowEditer_txtPostMedDays","<span style='color:red'><b>术后用药天数</b></span>","天");
			
			winGridRowEditer = new Ext.Window({
				id : 'ANTI_gridAnti_RowEditer',
				height : 320,
				closeAction: 'hide',
				width : 450,
				modal : true,
				title : '抗菌用药-编辑',
				layout : 'fit',
				frame : true,
				items: [
					{
						layout : 'form',
						frame : true,
						items : [
							{
								layout : 'column',
								//frame : true,
								items : [
									{
										columnWidth :1,
										layout : 'form',
										labelAlign : 'right',
										labelWidth : 60,
										items : [
											obj.ANTI_gridAnti_RowEditer_cboArcim
										]
									}
								]
							},{
								layout : 'column',
								//frame : true,
								items : [
									{
										columnWidth :.50,
										layout : 'form',
										labelAlign : 'right',
										labelWidth : 60,
										items : [
											obj.ANTI_gridAnti_RowEditer_cboMedUsePurpose
											,obj.ANTI_gridAnti_RowEditer_cboAdminRoute
											,obj.ANTI_gridAnti_RowEditer_txtDoseQty
											,obj.ANTI_gridAnti_RowEditer_cboDoseUnit
											,obj.ANTI_gridAnti_RowEditer_cboPhcFreq
											,obj.ANTI_gridAnti_RowEditer_txtStartDateTime
											,obj.ANTI_gridAnti_RowEditer_txtEndDateTime
										]
									},{
										columnWidth :.50,
										layout : 'form',
										labelAlign : 'right',
										labelWidth : 85,
										items : [
											obj.ANTI_gridAnti_RowEditer_cboCombinedMed
											,obj.ANTI_gridAnti_RowEditer_cboMedPurpose
											,obj.ANTI_gridAnti_RowEditer_cboTreatmentMode
											,obj.ANTI_gridAnti_RowEditer_cboPreMedIndicat
											,obj.ANTI_gridAnti_RowEditer_cboPreMedEffect
											,obj.ANTI_gridAnti_RowEditer_txtPreMedTime
											,obj.ANTI_gridAnti_RowEditer_txtPostMedDays
										]
									}
								]
							}
						]
					}
				],
				bbar : [
					'->',
					new Ext.Toolbar.Button({
						id: "ANTI_gridAnti_RowEditer_btnUpdate",
						width : 80,
						text : "<img SRC='../scripts/dhcmed/img/update.png'>确定",
						listeners : {
							'click' : function(){
								var ArcimID = Common_GetValue('ANTI_gridAnti_RowEditer_cboArcim');
								var ArcimDesc = Common_GetText('ANTI_gridAnti_RowEditer_cboArcim');
								var DoseQty = Common_GetValue('ANTI_gridAnti_RowEditer_txtDoseQty');
								var DoseUnitID = Common_GetValue('ANTI_gridAnti_RowEditer_cboDoseUnit');
								var DoseUnitDesc = Common_GetText('ANTI_gridAnti_RowEditer_cboDoseUnit');
								var PhcFreqID = Common_GetValue('ANTI_gridAnti_RowEditer_cboPhcFreq');
								var PhcFreqDesc = Common_GetText('ANTI_gridAnti_RowEditer_cboPhcFreq');
								var StartDateTime = Common_GetValue('ANTI_gridAnti_RowEditer_txtStartDateTime');
								var arrVal = StartDateTime.split(' ');
								var StartDate = (arrVal.length > 0 ? arrVal[0] : '');
								var StartTime = (arrVal.length > 1 ? arrVal[1] : '');
								var EndDateTime = Common_GetValue('ANTI_gridAnti_RowEditer_txtEndDateTime');
								var arrVal = EndDateTime.split(' ');
								var EndDate = (arrVal.length > 0 ? arrVal[0] : '');
								var EndTime = (arrVal.length > 1 ? arrVal[1] : '');
								var MedUsePurposeID = Common_GetValue('ANTI_gridAnti_RowEditer_cboMedUsePurpose');
								var MedUsePurposeDesc = Common_GetText('ANTI_gridAnti_RowEditer_cboMedUsePurpose');
								var AdminRouteID = Common_GetValue('ANTI_gridAnti_RowEditer_cboAdminRoute');
								var AdminRouteDesc = Common_GetText('ANTI_gridAnti_RowEditer_cboAdminRoute');
								var MedPurposeID = Common_GetValue('ANTI_gridAnti_RowEditer_cboMedPurpose');
								var MedPurposeDesc = Common_GetText('ANTI_gridAnti_RowEditer_cboMedPurpose');
								var TreatmentModeID = Common_GetValue('ANTI_gridAnti_RowEditer_cboTreatmentMode');
								var TreatmentModeDesc = Common_GetText('ANTI_gridAnti_RowEditer_cboTreatmentMode');
								var PreMedIndicatID = Common_GetValue('ANTI_gridAnti_RowEditer_cboPreMedIndicat');
								var PreMedIndicatDesc = Common_GetText('ANTI_gridAnti_RowEditer_cboPreMedIndicat');
								var PreMedEffectID = Common_GetValue('ANTI_gridAnti_RowEditer_cboPreMedEffect');
								var PreMedEffectDesc = Common_GetText('ANTI_gridAnti_RowEditer_cboPreMedEffect');
								var CombinedMedID = Common_GetValue('ANTI_gridAnti_RowEditer_cboCombinedMed');
								var CombinedMedDesc = Common_GetText('ANTI_gridAnti_RowEditer_cboCombinedMed');
								var PreMedTime = Common_GetValue('ANTI_gridAnti_RowEditer_txtPreMedTime');
								var PostMedDays = Common_GetValue('ANTI_gridAnti_RowEditer_txtPostMedDays');
								
								var errInfo = '';
								if (ArcimDesc == '') {
									errInfo = errInfo + '药品医嘱为空!<br>';
								}
								if (DoseQty == '') {
									//errInfo = errInfo + '剂量为空!<br>';
								}
								if ((DoseUnitID == '')||((DoseUnitDesc == ''))) {
									//errInfo = errInfo + '剂量单位为空!<br>';
								}
								if ((PhcFreqID == '')||((PhcFreqDesc == ''))) {
									errInfo = errInfo + '频次为空!<br>';
								}
								if (StartDateTime == '') {
									errInfo = errInfo + '开始时间为空!<br>';
								}
								if (EndDateTime == '') {
									//errInfo = errInfo + '结束时间为空!<br>';
								}
								if ((MedUsePurposeID == '')||((MedUsePurposeDesc == ''))) {
									//errInfo = errInfo + '用途为空!<br>';
								}
								if ((AdminRouteID == '')||(AdminRouteDesc == '')) {
									errInfo = errInfo + '给药途径为空!<br>';
								}
								if ((MedPurposeID == '')||(MedPurposeDesc == '')) {
									errInfo = errInfo + '目的为空!<br>';
								}
								if ((CombinedMedID == '')||(CombinedMedDesc == '')) {
									errInfo = errInfo + '联合用药为空!<br>';
								}
								if (errInfo != '') {
									ExtTool.alert("提示",errInfo);
									return;
								}
								
								var objRec = obj.ANTI_gridAnti_RowEditer_objRec;
								var objGrid = Ext.getCmp('ANTI_gridAnti');
								if (objGrid) {
									var objStore = objGrid.getStore();
									
									if (objRec) {      //提交数据
										objRec.set('ArcimID',ArcimID);
										objRec.set('ArcimDesc',ArcimDesc);
										objRec.set('StartDate',StartDate);
										objRec.set('StartTime',StartTime);
										objRec.set('EndDate',EndDate);
										objRec.set('EndTime',EndTime);
										objRec.set('DoseQty',DoseQty);
										objRec.set('DoseUnitID',DoseUnitID);
										objRec.set('DoseUnitDesc',DoseUnitDesc);
										objRec.set('PhcFreqID',PhcFreqID);
										objRec.set('PhcFreqDesc',PhcFreqDesc);
										objRec.set('MedUsePurposeID',MedUsePurposeID);
										objRec.set('MedUsePurposeDesc',MedUsePurposeDesc);
										objRec.set('AdminRouteID',AdminRouteID);
										objRec.set('AdminRouteDesc',AdminRouteDesc);
										objRec.set('MedPurposeID',MedPurposeID);
										objRec.set('MedPurposeDesc',MedPurposeDesc);
										objRec.set('TreatmentModeID',TreatmentModeID);
										objRec.set('TreatmentModeDesc',TreatmentModeDesc);
										objRec.set('PreMedIndicatID',PreMedIndicatID);
										objRec.set('PreMedIndicatDesc',PreMedIndicatDesc);
										objRec.set('PreMedEffectID',PreMedEffectID);
										objRec.set('PreMedEffectDesc',PreMedEffectDesc);
										objRec.set('CombinedMedID',CombinedMedID);
										objRec.set('CombinedMedDesc',CombinedMedDesc);
										objRec.set('PreMedTime',PreMedTime);
										objRec.set('PostMedDays',PostMedDays);
										objRec.commit();
									} else {                 //插入数据
										var RecordType = objStore.recordType;
										var RecordData = new RecordType({
											RepID : ''
											,SubID : ''
											,ArcimID : ArcimID
											,ArcimDesc : ArcimDesc
											,StartDate : StartDate
											,StartTime : StartTime
											,EndDate : EndDate
											,EndTime : EndTime
											,DoseQty : DoseQty
											,DoseUnitID : DoseUnitID
											,DoseUnitDesc : DoseUnitDesc
											,PhcFreqID : PhcFreqID
											,PhcFreqDesc : PhcFreqDesc
											,MedUsePurposeID : MedUsePurposeID
											,MedUsePurposeDesc : MedUsePurposeDesc
											,AdminRouteID : AdminRouteID
											,AdminRouteDesc : AdminRouteDesc
											,MedPurposeID : MedPurposeID
											,MedPurposeDesc : MedPurposeDesc
											,TreatmentModeID : TreatmentModeID
											,TreatmentModeDesc : TreatmentModeDesc
											,PreMedIndicatID : PreMedIndicatID
											,PreMedIndicatDesc : PreMedIndicatDesc
											,PreMedEffectID : PreMedEffectID
											,PreMedEffectDesc : PreMedEffectDesc
											,CombinedMedID : CombinedMedID
											,CombinedMedDesc : CombinedMedDesc
											,PreMedTime : PreMedTime
											,PostMedDays : PostMedDays
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
						id: "ANTI_gridAnti_RowEditer_btnCancel",
						width : 80,
						text : "<img SRC='../scripts/dhcmed/img/cancel.png'>取消",
						listeners : {
							'click' : function(){
								winGridRowEditer.hide();
							}
						}
					})
				],
				listeners :{
					'beforeshow' : function(){
						var objRec = obj.ANTI_gridAnti_RowEditer_objRec;
						if (objRec) {
							Common_SetValue('ANTI_gridAnti_RowEditer_cboArcim',objRec.get('ArcimID'),objRec.get('ArcimDesc'));
							Common_SetDisabled("ANTI_gridAnti_RowEditer_cboArcim",(objRec.get('DataSource') != ''));
							Common_SetValue('ANTI_gridAnti_RowEditer_txtDoseQty',objRec.get('DoseQty'));
							Common_SetValue('ANTI_gridAnti_RowEditer_cboDoseUnit',objRec.get('DoseUnitID'),objRec.get('DoseUnitDesc'));
							Common_SetValue('ANTI_gridAnti_RowEditer_cboPhcFreq',objRec.get('PhcFreqID'),objRec.get('PhcFreqDesc'));
							if (objRec.get('StartDate') != '') {
								Common_SetValue('ANTI_gridAnti_RowEditer_txtStartDateTime',objRec.get('StartDate') + ' ' + objRec.get('StartTime'));
							} else {
								Common_SetValue('ANTI_gridAnti_RowEditer_txtStartDateTime','');
							}
							if (objRec.get('EndDate') != '') {
								Common_SetValue('ANTI_gridAnti_RowEditer_txtEndDateTime',objRec.get('EndDate') + ' ' + objRec.get('EndTime'));
							} else {
								Common_SetValue('ANTI_gridAnti_RowEditer_txtEndDateTime','');
							}
							Common_SetValue('ANTI_gridAnti_RowEditer_cboMedUsePurpose',objRec.get('MedUsePurposeID'),objRec.get('MedUsePurposeDesc'));
							if(objRec.get('AdminRouteDesc').substr(0,1)=='*'){//给药途径带星号时置空
								Common_SetValue('ANTI_gridAnti_RowEditer_cboAdminRoute',objRec.get('AdminRouteID'));	
							}else{
								Common_SetValue('ANTI_gridAnti_RowEditer_cboAdminRoute',objRec.get('AdminRouteID'),objRec.get('AdminRouteDesc'));
							}
							Common_SetValue('ANTI_gridAnti_RowEditer_cboMedPurpose',objRec.get('MedPurposeID'),objRec.get('MedPurposeDesc'));
							Common_SetValue('ANTI_gridAnti_RowEditer_cboTreatmentMode',objRec.get('TreatmentModeID'),objRec.get('TreatmentModeDesc'));
							Common_SetValue('ANTI_gridAnti_RowEditer_cboPreMedIndicat',objRec.get('PreMedIndicatID'),objRec.get('PreMedIndicatDesc'));
							Common_SetValue('ANTI_gridAnti_RowEditer_cboPreMedEffect',objRec.get('PreMedEffectID'),objRec.get('PreMedEffectDesc'));
							Common_SetValue('ANTI_gridAnti_RowEditer_cboCombinedMed',objRec.get('CombinedMedID'),objRec.get('CombinedMedDesc'));
							Common_SetValue('ANTI_gridAnti_RowEditer_txtPreMedTime',objRec.get('PreMedTime'));
							Common_SetValue('ANTI_gridAnti_RowEditer_txtPostMedDays',objRec.get('PostMedDays'));
						} else {
							Common_SetValue('ANTI_gridAnti_RowEditer_cboArcim','','');
							Common_SetDisabled("ANTI_gridAnti_RowEditer_cboArcim",false);
							Common_SetValue('ANTI_gridAnti_RowEditer_txtDoseQty','');
							Common_SetValue('ANTI_gridAnti_RowEditer_cboDoseUnit','','');
							Common_SetValue('ANTI_gridAnti_RowEditer_cboPhcFreq','','');
							Common_SetValue('ANTI_gridAnti_RowEditer_txtStartDateTime','');
							Common_SetValue('ANTI_gridAnti_RowEditer_txtEndDateTime','');
							Common_SetValue('ANTI_gridAnti_RowEditer_cboMedUsePurpose','','');
							Common_SetValue('ANTI_gridAnti_RowEditer_cboAdminRoute','','');
							Common_SetValue('ANTI_gridAnti_RowEditer_cboMedPurpose','','');
							Common_SetValue('ANTI_gridAnti_RowEditer_cboTreatmentMode','','');
							Common_SetValue('ANTI_gridAnti_RowEditer_cboPreMedIndicat','','');
							Common_SetValue('ANTI_gridAnti_RowEditer_cboPreMedEffect','','');
							Common_SetValue('ANTI_gridAnti_RowEditer_cboCombinedMed','','');
							Common_SetValue('ANTI_gridAnti_RowEditer_txtPreMedTime','');
							Common_SetValue('ANTI_gridAnti_RowEditer_txtPostMedDays','');
						}
					}
				}
			});
		}
		winGridRowEditer.show();
	}
	
	
	//抗菌用药 选择框
	obj.ANTI_gridAnti_RowExtract_gridAnti = new Ext.grid.GridPanel({
		id: 'ANTI_gridAnti_RowExtract_gridAnti',
		store : new Ext.data.Store({
			proxy: new Ext.data.HttpProxy({
				url : ExtToolSetting.RunQueryPageURL,
				listeners : {
					'beforeload' :  function(objProxy, param){
						param.ClassName = 'DHCMed.NINFService.Rep.InfReportAnti';
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
					,{name: 'StartDate', mapping: 'StartDate'}
					,{name: 'StartTime', mapping: 'StartTime'}
					,{name: 'EndDate', mapping: 'EndDate'}
					,{name: 'EndTime', mapping: 'EndTime'}
					,{name: 'DoseQty', mapping: 'DoseQty'}
					,{name: 'DoseUnitID', mapping: 'DoseUnitID'}
					,{name: 'DoseUnitDesc', mapping: 'DoseUnitDesc'}
					,{name: 'PhcFreqID', mapping: 'PhcFreqID'}
					,{name: 'PhcFreqDesc', mapping: 'PhcFreqDesc'}
					,{name: 'MedUsePurposeID', mapping: 'MedUsePurposeID'}
					,{name: 'MedUsePurposeDesc', mapping: 'MedUsePurposeDesc'}
					,{name: 'AdminRouteID', mapping: 'AdminRouteID'}
					,{name: 'AdminRouteDesc', mapping: 'AdminRouteDesc'}
					,{name: 'MedPurposeID', mapping: 'MedPurposeID'}
					,{name: 'MedPurposeDesc', mapping: 'MedPurposeDesc'}
					,{name: 'TreatmentModeID', mapping: 'TreatmentModeID'}
					,{name: 'TreatmentModeDesc', mapping: 'TreatmentModeDesc'}
					,{name: 'PreMedIndicatID', mapping: 'PreMedIndicatID'}
					,{name: 'PreMedIndicatDesc', mapping: 'PreMedIndicatDesc'}
					,{name: 'PreMedEffectID', mapping: 'PreMedEffectID'}
					,{name: 'PreMedEffectDesc', mapping: 'PreMedEffectDesc'}
					,{name: 'CombinedMedID', mapping: 'CombinedMedID'}
					,{name: 'CombinedMedDesc', mapping: 'CombinedMedDesc'}
					,{name: 'PreMedTime', mapping: 'PreMedTime'}
					,{name: 'PostMedDays', mapping: 'PostMedDays'}
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
			//,{header: '用途', width: 60, dataIndex: 'MedUsePurposeDesc', sortable: false, menuDisabled:true, align:'center' }
			,{header: '药品医嘱', width: 200, dataIndex: 'ArcimDesc', sortable: false, menuDisabled:true, align:'center' }
			,{header: '给药<br>途径', width: 60, dataIndex: 'AdminRouteDesc', sortable: false, menuDisabled:true, align:'center' }
			,{header: '剂量', width : 60, sortable: false, menuDisabled:true, align:'center'
				, renderer: function(v, m, rd, r, c, s){
					if (rd.get("DoseQty") != '') {
						return rd.get("DoseQty") + ' ' + rd.get("DoseUnitDesc");
					} else {
						return '';
					}
				}
			}
			,{header: '频次', width: 80, dataIndex: 'PhcFreqDesc', sortable: false, menuDisabled:true, align:'center' }
			,{header: '起始时间', width : 100, sortable: false, menuDisabled:true, align:'center'
				, renderer: function(v, m, rd, r, c, s){
					if (rd.get("StartDate") != '') {
						return rd.get("StartDate") + ' ' + rd.get("StartTime");
					} else {
						return '';
					}
				}
			}
			,{header: '截止时间', width : 100, sortable: false, menuDisabled:true, align:'center'
				, renderer: function(v, m, rd, r, c, s){
					if (rd.get("EndDate") != '') {
						return rd.get("EndDate") + ' ' + rd.get("EndTime");
					} else {
						return '';
					}
				}
			}
			//,{header: '目的', width: 60, dataIndex: 'MedPurposeDesc', sortable: false, menuDisabled:true, align:'center' }
			//,{header: '治疗<br>用药<br>方式', width: 60, dataIndex: 'TreatmentModeDesc', sortable: false, menuDisabled:true, align:'center' }
			//,{header: '预防<br>用药<br>指征', width: 60, dataIndex: 'PreMedIndicatDesc', sortable: false, menuDisabled:true, align:'center' }
			//,{header: '预防<br>用药<br>效果', width: 60, dataIndex: 'PreMedEffectDesc', sortable: false, menuDisabled:true, align:'center' }
			//,{header: '联合<br>用药', width: 60, dataIndex: 'CombinedMedDesc', sortable: false, menuDisabled:true, align:'center' }
			//,{header: '术前<br>用药<br>时间', width: 60, dataIndex: 'PostMedDays', sortable: false, menuDisabled:true, align:'center' }
			//,{header: '术后<br>用药<br>天数', width: 50, dataIndex: 'PostMedDays', sortable: false, menuDisabled:true, align:'center' }
			,{header: '数据<br>来源', width: 50, dataIndex: 'DataSource', sortable: false, menuDisabled:true, align:'center' }
		],
		viewConfig : {
			forceFit : true
		}
	});
	obj.ANTI_gridAnti_RowExtract = function() {
		var winGridRowEditer = Ext.getCmp('ANTI_gridAnti_RowExtract');
		if (!winGridRowEditer)
		{
			winGridRowEditer = new Ext.Window({
				id : 'ANTI_gridAnti_RowExtract',
				height : 400,
				closeAction: 'hide',
				width : 600,
				modal : true,
				title : '抗菌用药-提取',
				layout : 'fit',
				frame : true,
				items: [
					obj.ANTI_gridAnti_RowExtract_gridAnti
				],
				bbar : [
					'->',
					new Ext.Toolbar.Button({
						id: "ANTI_gridAnti_RowExtract_btnUpdate",
						width : 80,
						text : "<img SRC='../scripts/dhcmed/img/update.png'>确定",
						listeners : {
							'click' : function(){
								var objRowDataGrid = Ext.getCmp('ANTI_gridAnti_RowExtract_gridAnti');
								var objGrid = Ext.getCmp('ANTI_gridAnti');
								if ((objRowDataGrid)&&(objGrid)) {
									function insertfun(){
										var objStore = objGrid.getStore();
										var arrRec = objRowDataGrid.getSelectionModel().getSelections();
										var rowbreak = -1;
										for (var indRec = 0; indRec < arrRec.length; indRec++){
											var objRec = arrRec[indRec];
											
											//检查是否存在相同一天多个相同名手术,或相同数据来源数据
											var isBoolean = false;
											for (var indStore = 0; indStore < objStore.getCount(); indStore++) {
												var tmpRec = objStore.getAt(indStore);
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
												,StartDate : objRec.get('StartDate')
												,StartTime : objRec.get('StartTime')
												,EndDate : objRec.get('EndDate')
												,EndTime : objRec.get('EndTime')
												,DoseQty : objRec.get('DoseQty')
												,DoseUnitID : objRec.get('DoseUnitID')
												,DoseUnitDesc : objRec.get('DoseUnitDesc')
												,PhcFreqID : objRec.get('PhcFreqID')
												,PhcFreqDesc : objRec.get('PhcFreqDesc')
												,MedUsePurposeID : objRec.get('MedUsePurposeID')
												,MedUsePurposeDesc : objRec.get('MedUsePurposeDesc')
												,AdminRouteID : objRec.get('AdminRouteID')
												,AdminRouteDesc : objRec.get('AdminRouteDesc')
												,MedPurposeID : objRec.get('MedPurposeID')
												,MedPurposeDesc : objRec.get('MedPurposeDesc')
												,TreatmentModeID : objRec.get('TreatmentModeID')
												,TreatmentModeDesc : objRec.get('TreatmentModeDesc')
												,PreMedIndicatID : objRec.get('PreMedIndicatID')
												,PreMedIndicatDesc : objRec.get('PreMedIndicatDesc')
												,PreMedEffectID : objRec.get('PreMedEffectID')
												,PreMedEffectDesc : objRec.get('PreMedEffectDesc')
												,CombinedMedID : objRec.get('CombinedMedID')
												,CombinedMedDesc : objRec.get('CombinedMedDesc')
												,PreMedTime : objRec.get('PreMedTime')
												,PostMedDays : objRec.get('PostMedDays')
												,DataSource : objRec.get('DataSource')
											});
											
											objStore.insert(objStore.getCount(), RecordData);
											obj.ANTI_gridAnti_RowEditer(RecordData);	//点击确定提取数据后直接弹出抗菌用药编辑界面 add by yanjf,20140512
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
								obj.ANTI_gridAnti_RowEditer(objRec);
							}
						}
					}),
					new Ext.Toolbar.Button({
						id: "ANTI_gridAnti_RowExtract_btnCancel",
						width : 80,
						text : "<img SRC='../scripts/dhcmed/img/cancel.png'>取消",
						listeners : {
							'click' : function(){
								winGridRowEditer.hide();
							}
						}
					})
				],
				listeners :{
					'beforeshow' : function(){
						var objRowDataGrid = Ext.getCmp('ANTI_gridAnti_RowExtract_gridAnti');
						if (objRowDataGrid) {
							objRowDataGrid.getStore().load({});
						}
					}
				}
			});
		}
		winGridRowEditer.show();
	}
	
	
	//抗菌用药 列表
	obj.ANTI_gridAnti_btnAdd = new Ext.Button({
		id : 'ANTI_gridAnti_btnAdd'
		,iconCls : 'icon-add'
		,width: 80
		,text : '增加'
		,listeners : {
			'click' :  function(){
				obj.ANTI_gridAnti_RowEditer('');
			}
		}
	});
	obj.ANTI_gridAnti_btnDel = new Ext.Button({
		id : 'ANTI_gridAnti_btnDel'
		,iconCls : 'icon-delete'
		,width: 80
		,text : '删除'
		,listeners : {
			'click' :  function(){
				//Add By LiYang 2014-07-08 FixBug：1667 医院感染管理-感染报告管理-感染报告查询-将报告的感染信息删除，不做提交或审核，重新打开报告时感染诊断被删除
				if(obj.CurrReport)
				{
					if(obj.CurrReport.ReportStatus){
						if((obj.CurrReport.ReportStatus.Code == "2")||
							(obj.CurrReport.ReportStatus.Code == "3")||
							(obj.CurrReport.ReportStatus.Code == "0"))
						{
							ExtTool.alert("错误提示", "“" + obj.CurrReport.ReportStatus.Description + "”状态的报告不能再删除项目！");
							return;
						}
					}
				}
				
				var objGrid = Ext.getCmp("ANTI_gridAnti");
				if (objGrid){
					var arrRec = objGrid.getSelectionModel().getSelections();
					if (arrRec.length>0){
						Ext.MessageBox.confirm('删除', '是否删除选中数据记录?', function(btn,text){
							if(btn=="yes"){
								for (var indRec = 0; indRec < arrRec.length; indRec++){
									var objRec = arrRec[indRec];
									if (objRec.get('SubID')) {
										var RecID = objRec.get('RepID') + '||' + objRec.get('SubID');
										var flg = obj.ClsInfReportAntiSrv.DelSubRec(objRec.get('RepID') + '||' + objRec.get('SubID'));
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
	obj.ANTI_gridAnti_btnGet = new Ext.Button({
		id : 'ANTI_gridAnti_btnGet'
		,iconCls : 'icon-update'
		,width: 80
		,text : "提取数据"
		,listeners : {
			'click' :  function(){
				obj.ANTI_gridAnti_RowExtract();
			}
		}
	});
	obj.ANTI_gridAnti_iniFun = function() {
		var tmpGridPanel = new Ext.grid.GridPanel({
			id: arguments[0],
			store : new Ext.data.Store({
				proxy: new Ext.data.HttpProxy({
					url : ExtToolSetting.RunQueryPageURL,
					listeners : {
						'beforeload' :  function(objProxy, param){
							param.ClassName = 'DHCMed.NINFService.Rep.InfReportAnti';
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
						,{name: 'StartDate', mapping: 'StartDate'}
						,{name: 'StartTime', mapping: 'StartTime'}
						,{name: 'EndDate', mapping: 'EndDate'}
						,{name: 'EndTime', mapping: 'EndTime'}
						,{name: 'DoseQty', mapping: 'DoseQty'}
						,{name: 'DoseUnitID', mapping: 'DoseUnitID'}
						,{name: 'DoseUnitDesc', mapping: 'DoseUnitDesc'}
						,{name: 'PhcFreqID', mapping: 'PhcFreqID'}
						,{name: 'PhcFreqDesc', mapping: 'PhcFreqDesc'}
						,{name: 'MedUsePurposeID', mapping: 'MedUsePurposeID'}
						,{name: 'MedUsePurposeDesc', mapping: 'MedUsePurposeDesc'}
						,{name: 'AdminRouteID', mapping: 'AdminRouteID'}
						,{name: 'AdminRouteDesc', mapping: 'AdminRouteDesc'}
						,{name: 'MedPurposeID', mapping: 'MedPurposeID'}
						,{name: 'MedPurposeDesc', mapping: 'MedPurposeDesc'}
						,{name: 'TreatmentModeID', mapping: 'TreatmentModeID'}
						,{name: 'TreatmentModeDesc', mapping: 'TreatmentModeDesc'}
						,{name: 'PreMedIndicatID', mapping: 'PreMedIndicatID'}
						,{name: 'PreMedIndicatDesc', mapping: 'PreMedIndicatDesc'}
						,{name: 'PreMedEffectID', mapping: 'PreMedEffectID'}
						,{name: 'PreMedEffectDesc', mapping: 'PreMedEffectDesc'}
						,{name: 'CombinedMedID', mapping: 'CombinedMedID'}
						,{name: 'CombinedMedDesc', mapping: 'CombinedMedDesc'}
						,{name: 'PreMedTime', mapping: 'PreMedTime'}
						,{name: 'PostMedDays', mapping: 'PostMedDays'}
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
				,{header: '药品医嘱', width: 200, dataIndex: 'ArcimDesc', sortable: false, menuDisabled:true, align:'center' }
				,{header: '用途', width: 60, dataIndex: 'MedUsePurposeDesc', sortable: false, menuDisabled:true, align:'center' }
				,{header: '给药<br>途径', width: 60, dataIndex: 'AdminRouteDesc', sortable: false, menuDisabled:true, align:'center' }
				,{header: '剂量', width : 50, sortable: false, menuDisabled:true, align:'center'
					, renderer: function(v, m, rd, r, c, s){
						if (rd.get("DoseQty") != '') {
							return rd.get("DoseQty") + ' ' + rd.get("DoseUnitDesc");
						} else {
							return '';
						}
					}
				}
				,{header: '频次', width: 80, dataIndex: 'PhcFreqDesc', sortable: false, menuDisabled:true, align:'center' }
				,{header: '起始时间', width : 100, sortable: false, menuDisabled:true, align:'center'
					, renderer: function(v, m, rd, r, c, s){
						if (rd.get("StartDate") != '') {
							return rd.get("StartDate") + ' ' + rd.get("StartTime");
						} else {
							return '';
						}
					}
				}
				,{header: '截止时间', width : 100, sortable: false, menuDisabled:true, align:'center'
					, renderer: function(v, m, rd, r, c, s){
						if (rd.get("EndDate") != '') {
							return rd.get("EndDate") + ' ' + rd.get("EndTime");
						} else {
							return '';
						}
					}
				}
				,{header: '目的', width: 60, dataIndex: 'MedPurposeDesc', sortable: false, menuDisabled:true, align:'center' }
				,{header: '治疗<br>用药<br>方式', width: 60, dataIndex: 'TreatmentModeDesc', sortable: false, menuDisabled:true, align:'center' }
				,{header: '预防<br>用药<br>指征', width: 60, dataIndex: 'PreMedIndicatDesc', sortable: false, menuDisabled:true, align:'center' }
				,{header: '预防<br>用药<br>效果', width: 60, dataIndex: 'PreMedEffectDesc', sortable: false, menuDisabled:true, align:'center' }
				,{header: '联合<br>用药', width: 60, dataIndex: 'CombinedMedDesc', sortable: false, menuDisabled:true, align:'center' }
				,{header: '术前<br>用药<br>时间', width: 60, dataIndex: 'PreMedTime', sortable: false, menuDisabled:true, align:'center' }
				,{header: '术后<br>用药<br>天数', width: 50, dataIndex: 'PostMedDays', sortable: false, menuDisabled:true, align:'center' }
				//,{header: '数据<br>来源', width: 50, dataIndex: 'DataSource', sortable: false, menuDisabled:true, align:'center' }
			],
			viewConfig : {
				forceFit : true
			}
		});
		
		return tmpGridPanel;
	}
	obj.ANTI_gridAnti = obj.ANTI_gridAnti_iniFun("ANTI_gridAnti");
	
	//抗菌用药 界面布局
	obj.ANTI_ViewPort = {
		//title : '抗菌用药',
		layout : 'fit',
		//frame : true,
		height : 300,
		anchor : '-20',
		tbar : ['<font size=2><b>抗菌用药</b><span style="color:red">(请选择用于此次感染的抗菌用药...)</span></font>'],
		items : [
			{
				layout : 'border',
				frame : true,
				items : [
					{
						region: 'north',
						layout : 'form',
						height : 30,
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
										items : [obj.ANTI_cbgIsAntibiotics]
									},{
										width:180,
										layout : 'form',
										labelAlign : 'right',
										labelWidth : 60,
										items : [obj.ANTI_cbgAdverseReaction]
									},{
										width:180,
										layout : 'form',
										labelAlign : 'right',
										labelWidth : 60,
										items : [obj.ANTI_cbgSuperinfection]
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
								items : [obj.ANTI_gridAnti]
							}
						],
						bbar : [obj.ANTI_gridAnti_btnGet,obj.ANTI_gridAnti_btnAdd,obj.ANTI_gridAnti_btnDel,'->','…']
					}
				]
			}
		]
	}
	
	//抗菌用药 界面初始化
	obj.ANTI_InitView = function(){
		//初始化"使用抗菌药物,不良反应,二重感染"界面元素值
		var isActive = false;
		if (obj.CurrReport.ChildSumm.AntiBoolean != '') {
			isActive = (obj.CurrReport.ChildSumm.AntiBoolean.Code == 'Y');
		} else {
			var num = obj.ClsInfReportAntiSrv.IsCheckAnti(obj.CurrReport.EpisodeID);
			if (parseInt(num) > 0) {
				isActive = true;
			} else {
				isActive = false;
			}
		}
		if (isActive) {
			Common_SetValue('ANTI_cbgIsAntibiotics','','是');
		} else {
			Common_SetValue('ANTI_cbgIsAntibiotics','','否');
		}
		if (obj.CurrReport.ChildSumm.Superinfection != '') {	//二重感染、不良反应默认为无
			Common_SetValue('ANTI_cbgSuperinfection','','有');
		}else {
			Common_SetValue('ANTI_cbgSuperinfection','','无');
		}
		Common_SetValue('ANTI_cbgAdverseReaction',(obj.CurrReport.ChildSumm.AdverseReaction != '' ? obj.CurrReport.ChildSumm.AdverseReaction.RowID : ''),'无');
		//Common_SetValue('ANTI_cbgSuperinfection',(obj.CurrReport.ChildSumm.Superinfection != '' ? obj.CurrReport.ChildSumm.Superinfection.RowID : ''));
		Common_SetDisabled('ANTI_cbgAdverseReaction',(!isActive));
		Common_SetDisabled('ANTI_cbgSuperinfection',(!isActive));
		
		//update by zf 20130618
		//屏蔽增加按钮,避免直接敲医嘱
		//Common_SetDisabled('ANTI_gridAnti_btnAdd',(!isActive));
		Common_SetDisabled('ANTI_gridAnti_btnAdd',true);
		Common_SetDisabled('ANTI_gridAnti_btnDel',(!isActive));
		Common_SetDisabled('ANTI_gridAnti_btnGet',(!isActive));
		
		//初始化"抗菌用药列表"load及rowdblclick事件
		var objGrid = Ext.getCmp("ANTI_gridAnti");
		if (objGrid){
			objGrid.getStore().load({});
			objGrid.on('rowdblclick',function(){
				var isBoolean = Common_GetValue('ANTI_cbgIsAntibiotics');
				if (!isBoolean) return;
				var rowIndex = arguments[1];
				var objRec = this.getStore().getAt(rowIndex);
				obj.ANTI_gridAnti_RowEditer(objRec);
			},objGrid);
		}
		
		//初始化"是否使用抗菌药物"change事件
		var objCmp = Ext.getCmp("ANTI_cbgIsAntibiotics");
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
				Common_SetDisabled('ANTI_cbgAdverseReaction',(!isActive));
				Common_SetDisabled('ANTI_cbgSuperinfection',(!isActive));
				//update by zf 20130618
				//屏蔽增加按钮,避免直接敲医嘱
				//Common_SetDisabled('ANTI_gridAnti_btnAdd',(!isActive));
				Common_SetDisabled('ANTI_gridAnti_btnAdd',true);
				Common_SetDisabled('ANTI_gridAnti_btnDel',(!isActive));
				Common_SetDisabled('ANTI_gridAnti_btnGet',(!isActive));
				Common_SetValue('ANTI_cbgAdverseReaction','');
				Common_SetValue('ANTI_cbgSuperinfection','');
				
				var objGrid = Ext.getCmp("ANTI_gridAnti");
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
	
	//抗菌用药 数据存储
	obj.ANTI_SaveData = function(){
		var errinfo = '';
		
		//使用抗菌药物
		var itmValue = Common_GetValue('ANTI_cbgIsAntibiotics');
		obj.CurrReport.ChildSumm.AntiBoolean = obj.ClsSSDictionary.GetObjById(itmValue);
		//不良反应
		var itmValue = Common_GetValue('ANTI_cbgAdverseReaction');
		obj.CurrReport.ChildSumm.AdverseReaction = obj.ClsSSDictionary.GetObjById(itmValue);
		//二重感染
		var itmValue = Common_GetValue('ANTI_cbgSuperinfection');
		obj.CurrReport.ChildSumm.Superinfection = obj.ClsSSDictionary.GetObjById(itmValue);
		
		//数据完成性校验
		var objSumm = obj.CurrReport.ChildSumm;
		if (!objSumm.AntiBoolean) {
			errinfo = errinfo + '使用抗菌药物[是/否]未填!<br>'
		} else {
			if (objSumm.AntiBoolean.Code == 'Y') {
				if (!objSumm.AdverseReaction) {
					errinfo = errinfo + '不良反应[有/无]未填!<br>'
				}
				if (!objSumm.Superinfection) {
					errinfo = errinfo + '二重感染[有/无]未填!<br>'
				}
			}
		}
		
		//手术信息
		obj.CurrReport.ChildAnti   = new Array();
		var objCmp = Ext.getCmp('ANTI_gridAnti');
		if (objCmp) {
			var objStore = objCmp.getStore();
			for (var indRec = 0; indRec < objStore.getCount(); indRec++) {
				var objRec = objStore.getAt(indRec);
				var objAnti = obj.ClsInfReportAntiSrv.GetSubObj('');
				if (objAnti) {
					objAnti.RowID = objRec.get('RepID') + '||' + objRec.get('SubID');
					objAnti.DataSource = objRec.get('DataSource');
					objAnti.ArcimID = objRec.get('ArcimID');
					objAnti.ArcimDesc = objRec.get('ArcimDesc');
					objAnti.StartDate = objRec.get('StartDate');
					objAnti.StartTime = objRec.get('StartTime');
					objAnti.EndDate = objRec.get('EndDate');
					objAnti.EndTime = objRec.get('EndTime');
					objAnti.DoseQty = objRec.get('DoseQty');
					objAnti.DoseUnit = new Object();
					objAnti.DoseUnit.RowID = objRec.get('DoseUnitID');
					objAnti.DoseUnit.Descs = objRec.get('DoseUnitDesc');
					objAnti.PhcFreq = new Object();
					objAnti.PhcFreq.RowID = objRec.get('PhcFreqID');
					objAnti.PhcFreq.Descs = objRec.get('PhcFreqDesc');
					objAnti.MedUsePurpose = obj.ClsSSDictionary.GetObjById(objRec.get('MedUsePurposeID'));
					objAnti.AdminRoute = obj.ClsSSDictionary.GetObjById(objRec.get('AdminRouteID'));
					objAnti.MedPurpose = obj.ClsSSDictionary.GetObjById(objRec.get('MedPurposeID'));
					objAnti.TreatmentMode = obj.ClsSSDictionary.GetObjById(objRec.get('TreatmentModeID'));
					objAnti.PreMedIndicat = obj.ClsSSDictionary.GetObjById(objRec.get('PreMedIndicatID'));
					objAnti.PreMedEffect = obj.ClsSSDictionary.GetObjById(objRec.get('PreMedEffectID'));
					objAnti.CombinedMed = obj.ClsSSDictionary.GetObjById(objRec.get('CombinedMedID'));
					objAnti.PreMedTime = objRec.get('PreMedTime');
					objAnti.PostMedDays = objRec.get('PostMedDays');
					
					//数据完成性校验
					var rowerrinfo = '';
					if (!objAnti.ArcimDesc) {
						rowerrinfo = rowerrinfo + '药品名称&nbsp;'
					}
					if (!objAnti.StartDate) {
						rowerrinfo = rowerrinfo + '开始时间&nbsp;'
					}
					if (!objAnti.EndDate) {
						//rowerrinfo = rowerrinfo + '结束时间&nbsp;'
					}
					if (!objAnti.DoseQty) {
						//rowerrinfo = rowerrinfo + '剂量&nbsp;'
					}
					if (!objAnti.DoseUnit.Descs) {
						//rowerrinfo = rowerrinfo + '剂量单位&nbsp;'
					}
					if (!objAnti.PhcFreq.Descs) {
						rowerrinfo = rowerrinfo + '频次&nbsp;'
					}
					if (!objAnti.MedUsePurpose) {
						//rowerrinfo = rowerrinfo + '用途&nbsp;'
					} else {
						if (objAnti.MedUsePurpose.Description.indexOf('术前') > -1) {
							if (!objAnti.PreMedTime) {
								rowerrinfo = rowerrinfo + '术前用药时间&nbsp;'
							}
						}
						if (objAnti.MedUsePurpose.Description.indexOf('术后') > -1) {
							if (!objAnti.PostMedDays) {
								rowerrinfo = rowerrinfo + '术后用药天数&nbsp;'
							}
						}
					}
					if (!objAnti.AdminRoute) {
						rowerrinfo = rowerrinfo + '给药途径&nbsp;'
					}
					if (!objAnti.MedPurpose) {
						rowerrinfo = rowerrinfo + '目的&nbsp;'
					}
					if (!objAnti.CombinedMed) {
						rowerrinfo = rowerrinfo + '联合用药&nbsp;'
					}
					if (objAnti.MedPurpose) {
						if (objAnti.MedPurpose.Description.indexOf('治疗') > -1) {
							if (!objAnti.TreatmentMode) {
								rowerrinfo = rowerrinfo + '治疗用药方式&nbsp;'
							}
						}
						if (objAnti.MedPurpose.Description.indexOf('预防') > -1) {
							if (!objAnti.PreMedIndicat) {
								rowerrinfo = rowerrinfo + '预防用药指征&nbsp;'
							}
							if (!objAnti.PreMedEffect) {
								rowerrinfo = rowerrinfo + '预防用药效果&nbsp;'
							}
						}
					}
					if (rowerrinfo) {
						var row = objStore.indexOfId(objRec.id);  //获取行号
						errinfo = errinfo + '抗菌用药 第' + (row + 1) + '行 ' + rowerrinfo + '未填!<br>';
					}
					
					obj.CurrReport.ChildAnti.push(objAnti);
				}
			}
		}
		//数据完成性校验
		var objSumm = obj.CurrReport.ChildSumm;
		if (objSumm.AntiBoolean) {
			if (objSumm.AntiBoolean.Code == 'Y') {
				if (obj.CurrReport.ChildAnti.length < 1) {
					//errinfo = errinfo + '抗菌用药信息未填!<br>'  //update by zf 20121021 使用抗生素,但是与此次感染无关,可以不填
				}
			}
		}
		
		return errinfo;
	}
	
	return obj;
}