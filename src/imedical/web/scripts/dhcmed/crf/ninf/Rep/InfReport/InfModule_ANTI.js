
function InitANTI(obj)
{
	//ʹ�ÿ���ҩ��
	obj.ANTI_cbgIsAntibiotics = Common_RadioGroupToDic("ANTI_cbgIsAntibiotics","ʹ�ÿ���ҩ��","NINFInfAntiBoolean",2);
	//������Ӧ
	obj.ANTI_cbgAdverseReaction = Common_RadioGroupToDic("ANTI_cbgAdverseReaction","������Ӧ","NINFInfAdverseReaction",2);
	//���ظ�Ⱦ
	obj.ANTI_cbgSuperinfection = Common_RadioGroupToDic("ANTI_cbgSuperinfection","���ظ�Ⱦ","NINFInfSuperinfection",2);
	
	//������ҩ �༭��
	obj.ANTI_gridAnti_RowEditer_objRec = '';
	obj.ANTI_gridAnti_RowEditer = function(objRec) {
		obj.ANTI_gridAnti_RowEditer_objRec = objRec;
		var winGridRowEditer = Ext.getCmp('ANTI_gridAnti_RowEditer');
		if (!winGridRowEditer)
		{
			obj.ANTI_gridAnti_RowEditer_cboArcim = Common_ComboToArcim("ANTI_gridAnti_RowEditer_cboArcim","<span style='color:red'><b>ҩƷҽ��</b></span>","R","ANTI_gridAnti_RowEditer_cboDoseUnit");
			obj.ANTI_gridAnti_RowEditer_txtDoseQty = Common_NumberField("ANTI_gridAnti_RowEditer_txtDoseQty","<span style='color:red'><b>����</b></span>",0,1,10);
			obj.ANTI_gridAnti_RowEditer_cboDoseUnit = Common_ComboToDoseUnit("ANTI_gridAnti_RowEditer_cboDoseUnit","<span style='color:red'><b>������λ</b></span>","ANTI_gridAnti_RowEditer_cboArcim");
			obj.ANTI_gridAnti_RowEditer_cboPhcFreq = Common_ComboToFreq("ANTI_gridAnti_RowEditer_cboPhcFreq","<span style='color:red'><b>Ƶ��</b></span>");
			obj.ANTI_gridAnti_RowEditer_txtStartDateTime = Common_DateFieldToDateTime("ANTI_gridAnti_RowEditer_txtStartDateTime","<span style='color:red'><b>��ʼʱ��</b></span>");
			obj.ANTI_gridAnti_RowEditer_txtEndDateTime = Common_DateFieldToDateTime("ANTI_gridAnti_RowEditer_txtEndDateTime","<span style='color:red'><b>����ʱ��</b></span>");
			obj.ANTI_gridAnti_RowEditer_cboMedUsePurpose = Common_ComboToDic("ANTI_gridAnti_RowEditer_cboMedUsePurpose","<span style='color:red'><b>��;</b></span>","NINFInfMedUsePurpose");
			obj.ANTI_gridAnti_RowEditer_cboAdminRoute = Common_ComboToDic("ANTI_gridAnti_RowEditer_cboAdminRoute","<span style='color:red'><b>��ҩ;��</b></span>","NINFInfAdminRoute");
			obj.ANTI_gridAnti_RowEditer_cboMedPurpose = Common_ComboToDic("ANTI_gridAnti_RowEditer_cboMedPurpose","<span style='color:red'><b>Ŀ��</b></span>","NINFInfMedPurpose");
			obj.ANTI_gridAnti_RowEditer_cboTreatmentMode = Common_ComboToDic("ANTI_gridAnti_RowEditer_cboTreatmentMode","<span style='color:red'><b>������ҩ��ʽ</b></span>","NINFInfTreatmentMode");
			obj.ANTI_gridAnti_RowEditer_cboPreMedIndicat = Common_ComboToDic("ANTI_gridAnti_RowEditer_cboPreMedIndicat","<span style='color:red'><b>Ԥ����ҩָ��</b></span>","NINFInfPreMedIndicat");
			obj.ANTI_gridAnti_RowEditer_cboPreMedEffect = Common_ComboToDic("ANTI_gridAnti_RowEditer_cboPreMedEffect","<span style='color:red'><b>Ԥ����ҩЧ��</b></span>","NINFInfPreMedEffect");
			obj.ANTI_gridAnti_RowEditer_cboCombinedMed = Common_ComboToDic("ANTI_gridAnti_RowEditer_cboCombinedMed","<span style='color:red'><b>������ҩ</b></span>","NINFInfCombinedMed");
			obj.ANTI_gridAnti_RowEditer_txtPreMedTime = Common_TextFieldToFormat("ANTI_gridAnti_RowEditer_txtPreMedTime","<span style='color:red'><b>��ǰ��ҩʱ��</b></span>","Сʱ:����");
			obj.ANTI_gridAnti_RowEditer_txtPostMedDays = Common_TextFieldToFormat("ANTI_gridAnti_RowEditer_txtPostMedDays","<span style='color:red'><b>������ҩ����</b></span>","��");
			
			winGridRowEditer = new Ext.Window({
				id : 'ANTI_gridAnti_RowEditer',
				height : 320,
				closeAction: 'hide',
				width : 450,
				modal : true,
				title : '������ҩ-�༭',
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
						text : "<img SRC='../scripts/dhcmed/img/update.png'>ȷ��",
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
									errInfo = errInfo + 'ҩƷҽ��Ϊ��!<br>';
								}
								if (DoseQty == '') {
									//errInfo = errInfo + '����Ϊ��!<br>';
								}
								if ((DoseUnitID == '')||((DoseUnitDesc == ''))) {
									//errInfo = errInfo + '������λΪ��!<br>';
								}
								if ((PhcFreqID == '')||((PhcFreqDesc == ''))) {
									errInfo = errInfo + 'Ƶ��Ϊ��!<br>';
								}
								if (StartDateTime == '') {
									errInfo = errInfo + '��ʼʱ��Ϊ��!<br>';
								}
								if (EndDateTime == '') {
									//errInfo = errInfo + '����ʱ��Ϊ��!<br>';
								}
								if ((MedUsePurposeID == '')||((MedUsePurposeDesc == ''))) {
									//errInfo = errInfo + '��;Ϊ��!<br>';
								}
								if ((AdminRouteID == '')||(AdminRouteDesc == '')) {
									errInfo = errInfo + '��ҩ;��Ϊ��!<br>';
								}
								if ((MedPurposeID == '')||(MedPurposeDesc == '')) {
									errInfo = errInfo + 'Ŀ��Ϊ��!<br>';
								}
								if ((CombinedMedID == '')||(CombinedMedDesc == '')) {
									errInfo = errInfo + '������ҩΪ��!<br>';
								}
								if (errInfo != '') {
									ExtTool.alert("��ʾ",errInfo);
									return;
								}
								
								var objRec = obj.ANTI_gridAnti_RowEditer_objRec;
								var objGrid = Ext.getCmp('ANTI_gridAnti');
								if (objGrid) {
									var objStore = objGrid.getStore();
									
									if (objRec) {      //�ύ����
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
									} else {                 //��������
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
						text : "<img SRC='../scripts/dhcmed/img/cancel.png'>ȡ��",
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
							if(objRec.get('AdminRouteDesc').substr(0,1)=='*'){//��ҩ;�����Ǻ�ʱ�ÿ�
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
	
	
	//������ҩ ѡ���
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
			//,{header: '��;', width: 60, dataIndex: 'MedUsePurposeDesc', sortable: false, menuDisabled:true, align:'center' }
			,{header: 'ҩƷҽ��', width: 200, dataIndex: 'ArcimDesc', sortable: false, menuDisabled:true, align:'center' }
			,{header: '��ҩ<br>;��', width: 60, dataIndex: 'AdminRouteDesc', sortable: false, menuDisabled:true, align:'center' }
			,{header: '����', width : 60, sortable: false, menuDisabled:true, align:'center'
				, renderer: function(v, m, rd, r, c, s){
					if (rd.get("DoseQty") != '') {
						return rd.get("DoseQty") + ' ' + rd.get("DoseUnitDesc");
					} else {
						return '';
					}
				}
			}
			,{header: 'Ƶ��', width: 80, dataIndex: 'PhcFreqDesc', sortable: false, menuDisabled:true, align:'center' }
			,{header: '��ʼʱ��', width : 100, sortable: false, menuDisabled:true, align:'center'
				, renderer: function(v, m, rd, r, c, s){
					if (rd.get("StartDate") != '') {
						return rd.get("StartDate") + ' ' + rd.get("StartTime");
					} else {
						return '';
					}
				}
			}
			,{header: '��ֹʱ��', width : 100, sortable: false, menuDisabled:true, align:'center'
				, renderer: function(v, m, rd, r, c, s){
					if (rd.get("EndDate") != '') {
						return rd.get("EndDate") + ' ' + rd.get("EndTime");
					} else {
						return '';
					}
				}
			}
			//,{header: 'Ŀ��', width: 60, dataIndex: 'MedPurposeDesc', sortable: false, menuDisabled:true, align:'center' }
			//,{header: '����<br>��ҩ<br>��ʽ', width: 60, dataIndex: 'TreatmentModeDesc', sortable: false, menuDisabled:true, align:'center' }
			//,{header: 'Ԥ��<br>��ҩ<br>ָ��', width: 60, dataIndex: 'PreMedIndicatDesc', sortable: false, menuDisabled:true, align:'center' }
			//,{header: 'Ԥ��<br>��ҩ<br>Ч��', width: 60, dataIndex: 'PreMedEffectDesc', sortable: false, menuDisabled:true, align:'center' }
			//,{header: '����<br>��ҩ', width: 60, dataIndex: 'CombinedMedDesc', sortable: false, menuDisabled:true, align:'center' }
			//,{header: '��ǰ<br>��ҩ<br>ʱ��', width: 60, dataIndex: 'PostMedDays', sortable: false, menuDisabled:true, align:'center' }
			//,{header: '����<br>��ҩ<br>����', width: 50, dataIndex: 'PostMedDays', sortable: false, menuDisabled:true, align:'center' }
			,{header: '����<br>��Դ', width: 50, dataIndex: 'DataSource', sortable: false, menuDisabled:true, align:'center' }
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
				title : '������ҩ-��ȡ',
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
						text : "<img SRC='../scripts/dhcmed/img/update.png'>ȷ��",
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
											
											//����Ƿ������ͬһ������ͬ������,����ͬ������Դ����
											var isBoolean = false;
											for (var indStore = 0; indStore < objStore.getCount(); indStore++) {
												var tmpRec = objStore.getAt(indStore);
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
											obj.ANTI_gridAnti_RowEditer(RecordData);	//���ȷ����ȡ���ݺ�ֱ�ӵ���������ҩ�༭���� add by yanjf,20140512
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
								obj.ANTI_gridAnti_RowEditer(objRec);
							}
						}
					}),
					new Ext.Toolbar.Button({
						id: "ANTI_gridAnti_RowExtract_btnCancel",
						width : 80,
						text : "<img SRC='../scripts/dhcmed/img/cancel.png'>ȡ��",
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
	
	
	//������ҩ �б�
	obj.ANTI_gridAnti_btnAdd = new Ext.Button({
		id : 'ANTI_gridAnti_btnAdd'
		,iconCls : 'icon-add'
		,width: 80
		,text : '����'
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
		,text : 'ɾ��'
		,listeners : {
			'click' :  function(){
				//Add By LiYang 2014-07-08 FixBug��1667 ҽԺ��Ⱦ����-��Ⱦ�������-��Ⱦ�����ѯ-������ĸ�Ⱦ��Ϣɾ���������ύ����ˣ����´򿪱���ʱ��Ⱦ��ϱ�ɾ��
				if(obj.CurrReport)
				{
					if(obj.CurrReport.ReportStatus){
						if((obj.CurrReport.ReportStatus.Code == "2")||
							(obj.CurrReport.ReportStatus.Code == "3")||
							(obj.CurrReport.ReportStatus.Code == "0"))
						{
							ExtTool.alert("������ʾ", "��" + obj.CurrReport.ReportStatus.Description + "��״̬�ı��治����ɾ����Ŀ��");
							return;
						}
					}
				}
				
				var objGrid = Ext.getCmp("ANTI_gridAnti");
				if (objGrid){
					var arrRec = objGrid.getSelectionModel().getSelections();
					if (arrRec.length>0){
						Ext.MessageBox.confirm('ɾ��', '�Ƿ�ɾ��ѡ�����ݼ�¼?', function(btn,text){
							if(btn=="yes"){
								for (var indRec = 0; indRec < arrRec.length; indRec++){
									var objRec = arrRec[indRec];
									if (objRec.get('SubID')) {
										var RecID = objRec.get('RepID') + '||' + objRec.get('SubID');
										var flg = obj.ClsInfReportAntiSrv.DelSubRec(objRec.get('RepID') + '||' + objRec.get('SubID'));
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
	obj.ANTI_gridAnti_btnGet = new Ext.Button({
		id : 'ANTI_gridAnti_btnGet'
		,iconCls : 'icon-update'
		,width: 80
		,text : "��ȡ����"
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
				,{header: 'ҩƷҽ��', width: 200, dataIndex: 'ArcimDesc', sortable: false, menuDisabled:true, align:'center' }
				,{header: '��;', width: 60, dataIndex: 'MedUsePurposeDesc', sortable: false, menuDisabled:true, align:'center' }
				,{header: '��ҩ<br>;��', width: 60, dataIndex: 'AdminRouteDesc', sortable: false, menuDisabled:true, align:'center' }
				,{header: '����', width : 50, sortable: false, menuDisabled:true, align:'center'
					, renderer: function(v, m, rd, r, c, s){
						if (rd.get("DoseQty") != '') {
							return rd.get("DoseQty") + ' ' + rd.get("DoseUnitDesc");
						} else {
							return '';
						}
					}
				}
				,{header: 'Ƶ��', width: 80, dataIndex: 'PhcFreqDesc', sortable: false, menuDisabled:true, align:'center' }
				,{header: '��ʼʱ��', width : 100, sortable: false, menuDisabled:true, align:'center'
					, renderer: function(v, m, rd, r, c, s){
						if (rd.get("StartDate") != '') {
							return rd.get("StartDate") + ' ' + rd.get("StartTime");
						} else {
							return '';
						}
					}
				}
				,{header: '��ֹʱ��', width : 100, sortable: false, menuDisabled:true, align:'center'
					, renderer: function(v, m, rd, r, c, s){
						if (rd.get("EndDate") != '') {
							return rd.get("EndDate") + ' ' + rd.get("EndTime");
						} else {
							return '';
						}
					}
				}
				,{header: 'Ŀ��', width: 60, dataIndex: 'MedPurposeDesc', sortable: false, menuDisabled:true, align:'center' }
				,{header: '����<br>��ҩ<br>��ʽ', width: 60, dataIndex: 'TreatmentModeDesc', sortable: false, menuDisabled:true, align:'center' }
				,{header: 'Ԥ��<br>��ҩ<br>ָ��', width: 60, dataIndex: 'PreMedIndicatDesc', sortable: false, menuDisabled:true, align:'center' }
				,{header: 'Ԥ��<br>��ҩ<br>Ч��', width: 60, dataIndex: 'PreMedEffectDesc', sortable: false, menuDisabled:true, align:'center' }
				,{header: '����<br>��ҩ', width: 60, dataIndex: 'CombinedMedDesc', sortable: false, menuDisabled:true, align:'center' }
				,{header: '��ǰ<br>��ҩ<br>ʱ��', width: 60, dataIndex: 'PreMedTime', sortable: false, menuDisabled:true, align:'center' }
				,{header: '����<br>��ҩ<br>����', width: 50, dataIndex: 'PostMedDays', sortable: false, menuDisabled:true, align:'center' }
				//,{header: '����<br>��Դ', width: 50, dataIndex: 'DataSource', sortable: false, menuDisabled:true, align:'center' }
			],
			viewConfig : {
				forceFit : true
			}
		});
		
		return tmpGridPanel;
	}
	obj.ANTI_gridAnti = obj.ANTI_gridAnti_iniFun("ANTI_gridAnti");
	
	//������ҩ ���沼��
	obj.ANTI_ViewPort = {
		//title : '������ҩ',
		layout : 'fit',
		//frame : true,
		height : 300,
		anchor : '-20',
		tbar : ['<font size=2><b>������ҩ</b><span style="color:red">(��ѡ�����ڴ˴θ�Ⱦ�Ŀ�����ҩ...)</span></font>'],
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
						bbar : [obj.ANTI_gridAnti_btnGet,obj.ANTI_gridAnti_btnAdd,obj.ANTI_gridAnti_btnDel,'->','��']
					}
				]
			}
		]
	}
	
	//������ҩ �����ʼ��
	obj.ANTI_InitView = function(){
		//��ʼ��"ʹ�ÿ���ҩ��,������Ӧ,���ظ�Ⱦ"����Ԫ��ֵ
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
			Common_SetValue('ANTI_cbgIsAntibiotics','','��');
		} else {
			Common_SetValue('ANTI_cbgIsAntibiotics','','��');
		}
		if (obj.CurrReport.ChildSumm.Superinfection != '') {	//���ظ�Ⱦ��������ӦĬ��Ϊ��
			Common_SetValue('ANTI_cbgSuperinfection','','��');
		}else {
			Common_SetValue('ANTI_cbgSuperinfection','','��');
		}
		Common_SetValue('ANTI_cbgAdverseReaction',(obj.CurrReport.ChildSumm.AdverseReaction != '' ? obj.CurrReport.ChildSumm.AdverseReaction.RowID : ''),'��');
		//Common_SetValue('ANTI_cbgSuperinfection',(obj.CurrReport.ChildSumm.Superinfection != '' ? obj.CurrReport.ChildSumm.Superinfection.RowID : ''));
		Common_SetDisabled('ANTI_cbgAdverseReaction',(!isActive));
		Common_SetDisabled('ANTI_cbgSuperinfection',(!isActive));
		
		//update by zf 20130618
		//�������Ӱ�ť,����ֱ����ҽ��
		//Common_SetDisabled('ANTI_gridAnti_btnAdd',(!isActive));
		Common_SetDisabled('ANTI_gridAnti_btnAdd',true);
		Common_SetDisabled('ANTI_gridAnti_btnDel',(!isActive));
		Common_SetDisabled('ANTI_gridAnti_btnGet',(!isActive));
		
		//��ʼ��"������ҩ�б�"load��rowdblclick�¼�
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
		
		//��ʼ��"�Ƿ�ʹ�ÿ���ҩ��"change�¼�
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
				//�������Ӱ�ť,����ֱ����ҽ��
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
	
	//������ҩ ���ݴ洢
	obj.ANTI_SaveData = function(){
		var errinfo = '';
		
		//ʹ�ÿ���ҩ��
		var itmValue = Common_GetValue('ANTI_cbgIsAntibiotics');
		obj.CurrReport.ChildSumm.AntiBoolean = obj.ClsSSDictionary.GetObjById(itmValue);
		//������Ӧ
		var itmValue = Common_GetValue('ANTI_cbgAdverseReaction');
		obj.CurrReport.ChildSumm.AdverseReaction = obj.ClsSSDictionary.GetObjById(itmValue);
		//���ظ�Ⱦ
		var itmValue = Common_GetValue('ANTI_cbgSuperinfection');
		obj.CurrReport.ChildSumm.Superinfection = obj.ClsSSDictionary.GetObjById(itmValue);
		
		//���������У��
		var objSumm = obj.CurrReport.ChildSumm;
		if (!objSumm.AntiBoolean) {
			errinfo = errinfo + 'ʹ�ÿ���ҩ��[��/��]δ��!<br>'
		} else {
			if (objSumm.AntiBoolean.Code == 'Y') {
				if (!objSumm.AdverseReaction) {
					errinfo = errinfo + '������Ӧ[��/��]δ��!<br>'
				}
				if (!objSumm.Superinfection) {
					errinfo = errinfo + '���ظ�Ⱦ[��/��]δ��!<br>'
				}
			}
		}
		
		//������Ϣ
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
					
					//���������У��
					var rowerrinfo = '';
					if (!objAnti.ArcimDesc) {
						rowerrinfo = rowerrinfo + 'ҩƷ����&nbsp;'
					}
					if (!objAnti.StartDate) {
						rowerrinfo = rowerrinfo + '��ʼʱ��&nbsp;'
					}
					if (!objAnti.EndDate) {
						//rowerrinfo = rowerrinfo + '����ʱ��&nbsp;'
					}
					if (!objAnti.DoseQty) {
						//rowerrinfo = rowerrinfo + '����&nbsp;'
					}
					if (!objAnti.DoseUnit.Descs) {
						//rowerrinfo = rowerrinfo + '������λ&nbsp;'
					}
					if (!objAnti.PhcFreq.Descs) {
						rowerrinfo = rowerrinfo + 'Ƶ��&nbsp;'
					}
					if (!objAnti.MedUsePurpose) {
						//rowerrinfo = rowerrinfo + '��;&nbsp;'
					} else {
						if (objAnti.MedUsePurpose.Description.indexOf('��ǰ') > -1) {
							if (!objAnti.PreMedTime) {
								rowerrinfo = rowerrinfo + '��ǰ��ҩʱ��&nbsp;'
							}
						}
						if (objAnti.MedUsePurpose.Description.indexOf('����') > -1) {
							if (!objAnti.PostMedDays) {
								rowerrinfo = rowerrinfo + '������ҩ����&nbsp;'
							}
						}
					}
					if (!objAnti.AdminRoute) {
						rowerrinfo = rowerrinfo + '��ҩ;��&nbsp;'
					}
					if (!objAnti.MedPurpose) {
						rowerrinfo = rowerrinfo + 'Ŀ��&nbsp;'
					}
					if (!objAnti.CombinedMed) {
						rowerrinfo = rowerrinfo + '������ҩ&nbsp;'
					}
					if (objAnti.MedPurpose) {
						if (objAnti.MedPurpose.Description.indexOf('����') > -1) {
							if (!objAnti.TreatmentMode) {
								rowerrinfo = rowerrinfo + '������ҩ��ʽ&nbsp;'
							}
						}
						if (objAnti.MedPurpose.Description.indexOf('Ԥ��') > -1) {
							if (!objAnti.PreMedIndicat) {
								rowerrinfo = rowerrinfo + 'Ԥ����ҩָ��&nbsp;'
							}
							if (!objAnti.PreMedEffect) {
								rowerrinfo = rowerrinfo + 'Ԥ����ҩЧ��&nbsp;'
							}
						}
					}
					if (rowerrinfo) {
						var row = objStore.indexOfId(objRec.id);  //��ȡ�к�
						errinfo = errinfo + '������ҩ ��' + (row + 1) + '�� ' + rowerrinfo + 'δ��!<br>';
					}
					
					obj.CurrReport.ChildAnti.push(objAnti);
				}
			}
		}
		//���������У��
		var objSumm = obj.CurrReport.ChildSumm;
		if (objSumm.AntiBoolean) {
			if (objSumm.AntiBoolean.Code == 'Y') {
				if (obj.CurrReport.ChildAnti.length < 1) {
					//errinfo = errinfo + '������ҩ��Ϣδ��!<br>'  //update by zf 20121021 ʹ�ÿ�����,������˴θ�Ⱦ�޹�,���Բ���
				}
			}
		}
		
		return errinfo;
	}
	
	return obj;
}