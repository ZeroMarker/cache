
function InitAANTI(obj)
{
	//行编辑
	obj.AANTI_GridRowEditer_cboArcim = Common_ComboToArcim("AANTI_GridRowEditer_cboArcim","药品名称","R","AANTI_GridRowEditer_cboDoseUnit");
	obj.AANTI_GridRowEditer_txtDoseQty = Common_NumberField("AANTI_GridRowEditer_txtDoseQty","剂量",0,1,10);
	obj.AANTI_GridRowEditer_cboDoseUnit = Common_ComboToDoseUnit("AANTI_GridRowEditer_cboDoseUnit","剂量单位","AANTI_GridRowEditer_cboArcim");
	obj.AANTI_GridRowEditer_cboPhcFreq = Common_ComboToFreq("AANTI_GridRowEditer_cboPhcFreq","频次");
	obj.AANTI_GridRowEditer_txtStartDateTime = Common_DateFieldToDateTime("AANTI_GridRowEditer_txtStartDateTime","开始时间");
	obj.AANTI_GridRowEditer_txtEndDateTime = Common_DateFieldToDateTime("AANTI_GridRowEditer_txtEndDateTime","结束时间");
	obj.AANTI_GridRowEditer_cboMedUsePurpose = Common_ComboToDic("AANTI_GridRowEditer_cboMedUsePurpose","用途","NINFInfMedUsePurpose");
	obj.AANTI_GridRowEditer_cboAdminRoute = Common_ComboToDic("AANTI_GridRowEditer_cboAdminRoute","给药途径","NINFInfAdminRoute");
	obj.AANTI_GridRowEditer_cboMedPurpose = Common_ComboToDic("AANTI_GridRowEditer_cboMedPurpose","目的","NINFInfMedPurpose");
	obj.AANTI_GridRowEditer_cboTreatmentMode = Common_ComboToDic("AANTI_GridRowEditer_cboTreatmentMode","治疗用药方式","NINFInfTreatmentMode");
	obj.AANTI_GridRowEditer_cboPreMedIndicat = Common_ComboToDic("AANTI_GridRowEditer_cboPreMedIndicat","预防用药指征","NINFInfPreMedIndicat");
	obj.AANTI_GridRowEditer_cboPreMedEffect = Common_ComboToDic("AANTI_GridRowEditer_cboPreMedEffect","预防用药效果","NINFInfPreMedEffect");
	obj.AANTI_GridRowEditer_cboCombinedMed = Common_ComboToDic("AANTI_GridRowEditer_cboCombinedMed","联合用药","NINFInfCombinedMed");
	obj.AANTI_GridRowEditer_txtPreMedTime = Common_TextFieldToFormat("AANTI_GridRowEditer_txtPreMedTime","术前用药时间","小时:分钟");
	obj.AANTI_GridRowEditer_txtPostMedDays = Common_TextFieldToFormat("AANTI_GridRowEditer_txtPostMedDays","术后用药天数","天");
	obj.AANTI_GridRowViewPort = {
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
							obj.AANTI_GridRowEditer_cboArcim
						]
					}
				]
			},{
				layout : 'column',
				//frame : true,
				items : [
					{
						columnWidth :.48,
						layout : 'form',
						labelAlign : 'right',
						labelWidth : 60,
						items : [
							obj.AANTI_GridRowEditer_cboMedUsePurpose
							,obj.AANTI_GridRowEditer_cboAdminRoute
							,obj.AANTI_GridRowEditer_txtDoseQty
							,obj.AANTI_GridRowEditer_cboDoseUnit
							,obj.AANTI_GridRowEditer_cboPhcFreq
							,obj.AANTI_GridRowEditer_txtStartDateTime
							,obj.AANTI_GridRowEditer_txtEndDateTime
						]
					},{
						columnWidth :.52,
						layout : 'form',
						labelAlign : 'right',
						labelWidth : 85,
						items : [
							obj.AANTI_GridRowEditer_cboCombinedMed
							,obj.AANTI_GridRowEditer_cboMedPurpose
							,obj.AANTI_GridRowEditer_cboTreatmentMode
							,obj.AANTI_GridRowEditer_cboPreMedIndicat
							,obj.AANTI_GridRowEditer_cboPreMedEffect
							,obj.AANTI_GridRowEditer_txtPreMedTime
							,obj.AANTI_GridRowEditer_txtPostMedDays
						]
					}
				]
			}
		]
	}
	obj.AANTI_GridRowDataCheck = function(objRec){
		var errInfo = '';
		
		if (objRec) {
			var val = objRec.get('ArcimDesc');
			if (val=='') {
				errInfo = errInfo + '药品名称未填!<br>';
			}
			var val = objRec.get('DoseQty');
			if (val=='') {
				errInfo = errInfo + '剂量未填!<br>';
			}
			var val = objRec.get('DoseUnitID');
			if (val=='') {
				errInfo = errInfo + '剂量单位未填!<br>';
			}
			var val = objRec.get('PhcFreqID');
			if (val=='') {
				errInfo = errInfo + '频次未填!<br>';
			}
			var val = objRec.get('StartDate');
			if (val=='') {
				errInfo = errInfo + '开始时间未填!<br>';
			}
			var val = objRec.get('EndDate');
			if (val=='') {
				errInfo = errInfo + '结束时间未填!<br>';
			}
			var val = objRec.get('MedUsePurposeID');
			if (val=='') {
				errInfo = errInfo + '用途未填!<br>';
			}
			var val = objRec.get('AdminRouteID');
			if (val=='') {
				errInfo = errInfo + '给药途径未填!<br>';
			}
			var val = objRec.get('TreatmentModeDesc');
			if (val=='') {
				errInfo = errInfo + '治疗用药方式未填!<br>';
			}
			var val = objRec.get('MedPurposeID');
			if (val=='') {
				errInfo = errInfo + '目的未填!<br>';
			}
			var val = objRec.get('CombinedMedID');
			if (val=='') {
				errInfo = errInfo + '联合用药未填!<br>';
			}
			var val = objRec.get('PostMedDays');
			if (val=='') {
				errInfo = errInfo + '术后用药天数未填!<br>';
			}
			var val = objRec.get('PreMedTime');
			if (val=='') {
				errInfo = errInfo + '术前用药时间未填!<br>';
			}
			var val = objRec.get('PreMedIndicatDesc');
			if (val=='') {
				errInfo = errInfo + '预防用药指征未填!<br>';
			}
			var val = objRec.get('PreMedEffectDesc');
			if (val=='') {
				errInfo = errInfo + '预防用药效果未填!<br>';
			}	
		} else {
			var val = Common_GetText('AANTI_GridRowEditer_cboArcim');
			if (val=='') {
				errInfo = errInfo + '药品名称未填!<br>';
			}
			var val = Common_GetValue('AANTI_GridRowEditer_txtDoseQty');
			if (val=='') {
				errInfo = errInfo + '剂量未填!<br>';
			}
			var val = Common_GetValue('AANTI_GridRowEditer_cboDoseUnit');
			if (val=='') {
				errInfo = errInfo + '剂量单位未填!<br>';
			}
			var val = Common_GetValue('AANTI_GridRowEditer_cboPhcFreq');
			if (val=='') {
				errInfo = errInfo + '频次未填!<br>';
			}
			var val = Common_GetValue('AANTI_GridRowEditer_txtStartDateTime');
			if (val=='') {
				errInfo = errInfo + '开始时间未填!<br>';
			}
			var val = Common_GetValue('AANTI_GridRowEditer_txtEndDateTime');
			if (val=='') {
				errInfo = errInfo + '结束时间未填!<br>';
			}
			var val = Common_GetValue('AANTI_GridRowEditer_cboMedUsePurpose');
			if (val=='') {
				errInfo = errInfo + '用途未填!<br>';
			}
			var val = Common_GetValue('AANTI_GridRowEditer_cboAdminRoute');
			if (val=='') {
				errInfo = errInfo + '给药途径未填!<br>';
			}
			var val = Common_GetValue('AANTI_GridRowEditer_cboTreatmentMode');
			if (val=='') {
				errInfo = errInfo + '治疗用药方式未填!<br>';
			}
			var val = Common_GetValue('AANTI_GridRowEditer_cboMedPurpose');
			if (val=='') {
				errInfo = errInfo + '目的未填!<br>';
			}
			var val = Common_GetValue('AANTI_GridRowEditer_txtPreMedTime');
			if (val=='') {
				errInfo = errInfo + '术前用药时间未填!<br>';
			}
			var val = Common_GetValue('AANTI_GridRowEditer_txtPostMedDays');
			if (val=='') {
				errInfo = errInfo + '术后用药天数未填!<br>';
			}
			var val = Common_GetValue('AANTI_GridRowEditer_cboCombinedMed');
			if (val=='') {
				errInfo = errInfo + '联合用药未填!<br>';
			}
			var val = Common_GetValue('AANTI_GridRowEditer_cboPreMedIndicat');
			if (val=='') {
				errInfo = errInfo + '预防用药指征未填!<br>';
			}
			var val = Common_GetValue('AANTI_GridRowEditer_cboPreMedEffect');
			if (val=='') {
				errInfo = errInfo + '预防用药效果未填!<br>';
			}
		}
		
		return errInfo;
	}
	obj.AANTI_GridRowDataSave = function(objRec){
		var ArcimID = Common_GetValue('AANTI_GridRowEditer_cboArcim');
		var ArcimDesc = Common_GetText('AANTI_GridRowEditer_cboArcim');
		var DoseQty = Common_GetValue('AANTI_GridRowEditer_txtDoseQty');
		var DoseUnitID = Common_GetValue('AANTI_GridRowEditer_cboDoseUnit');
		var DoseUnitDesc = Common_GetText('AANTI_GridRowEditer_cboDoseUnit');
		var PhcFreqID = Common_GetValue('AANTI_GridRowEditer_cboPhcFreq');
		var PhcFreqDesc = Common_GetText('AANTI_GridRowEditer_cboPhcFreq');
		var StartDateTime = Common_GetValue('AANTI_GridRowEditer_txtStartDateTime');
		var arrVal = StartDateTime.split(' ');
		var StartDate = (arrVal.length > 0 ? arrVal[0] : '');
		var StartTime = (arrVal.length > 1 ? arrVal[1] : '');
		var EndDateTime = Common_GetValue('AANTI_GridRowEditer_txtEndDateTime');
		var arrVal = EndDateTime.split(' ');
		var EndDate = (arrVal.length > 0 ? arrVal[0] : '');
		var EndTime = (arrVal.length > 1 ? arrVal[1] : '');
		var MedUsePurposeID = Common_GetValue('AANTI_GridRowEditer_cboMedUsePurpose');
		var MedUsePurposeDesc = Common_GetText('AANTI_GridRowEditer_cboMedUsePurpose');
		var AdminRouteID = Common_GetValue('AANTI_GridRowEditer_cboAdminRoute');
		var AdminRouteDesc = Common_GetText('AANTI_GridRowEditer_cboAdminRoute');
		var MedPurposeID = Common_GetValue('AANTI_GridRowEditer_cboMedPurpose');
		var MedPurposeDesc = Common_GetText('AANTI_GridRowEditer_cboMedPurpose');
		var TreatmentModeID = Common_GetValue('AANTI_GridRowEditer_cboTreatmentMode');
		var TreatmentModeDesc = Common_GetText('AANTI_GridRowEditer_cboTreatmentMode');
		var PreMedIndicatID = Common_GetValue('AANTI_GridRowEditer_cboPreMedIndicat');
		var PreMedIndicatDesc = Common_GetText('AANTI_GridRowEditer_cboPreMedIndicat');
		var PreMedEffectID = Common_GetValue('AANTI_GridRowEditer_cboPreMedEffect');
		var PreMedEffectDesc = Common_GetText('AANTI_GridRowEditer_cboPreMedEffect');
		var CombinedMedID = Common_GetValue('AANTI_GridRowEditer_cboCombinedMed');
		var CombinedMedDesc = Common_GetText('AANTI_GridRowEditer_cboCombinedMed');
		var PreMedTime = Common_GetValue('AANTI_GridRowEditer_txtPreMedTime');
		var PostMedDays = Common_GetValue('AANTI_GridRowEditer_txtPostMedDays');
		
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
			var objGrid = Ext.getCmp('AANTI_gridAnti');
			if (objGrid){
				var objStore = objGrid.getStore();
				var RecordType = objStore.recordType;
				var RecordData = new RecordType({
					RepID : obj.CurrReport.RowID
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
	}
	obj.AANTI_GridRowDataSet = function(objRec){
		if (objRec) {
			Common_SetValue('AANTI_GridRowEditer_cboArcim',objRec.get('ArcimID'),objRec.get('ArcimDesc'));
			Common_SetDisabled("AANTI_GridRowEditer_cboArcim",(objRec.get('DataSource') != ''));
			Common_SetValue('AANTI_GridRowEditer_txtDoseQty',objRec.get('DoseQty'));
			Common_SetValue('AANTI_GridRowEditer_cboDoseUnit',objRec.get('DoseUnitID'),objRec.get('DoseUnitDesc'));
			Common_SetValue('AANTI_GridRowEditer_cboPhcFreq',objRec.get('PhcFreqID'),objRec.get('PhcFreqDesc'));
			if (objRec.get('StartDate') != '') {
				Common_SetValue('AANTI_GridRowEditer_txtStartDateTime',objRec.get('StartDate') + ' ' + objRec.get('StartTime'));
			} else {
				Common_SetValue('AANTI_GridRowEditer_txtStartDateTime','');
			}
			if (objRec.get('EndDate') != '') {
				Common_SetValue('AANTI_GridRowEditer_txtEndDateTime',objRec.get('EndDate') + ' ' + objRec.get('EndTime'));
			} else {
				Common_SetValue('AANTI_GridRowEditer_txtEndDateTime','');
			}
			Common_SetValue('AANTI_GridRowEditer_cboMedUsePurpose',objRec.get('MedUsePurposeID'),objRec.get('MedUsePurposeDesc'));
			if(objRec.get('AdminRouteDesc').substr(0,1)=='*'){
				Common_SetValue('AANTI_GridRowEditer_cboAdminRoute',objRec.get('AdminRouteID'));
			}else{
				Common_SetValue('AANTI_GridRowEditer_cboAdminRoute',objRec.get('AdminRouteID'),objRec.get('AdminRouteDesc'));
			}
			Common_SetValue('AANTI_GridRowEditer_cboMedPurpose',objRec.get('MedPurposeID'),objRec.get('MedPurposeDesc'));
			Common_SetValue('AANTI_GridRowEditer_cboTreatmentMode',objRec.get('TreatmentModeID'),objRec.get('TreatmentModeDesc'));
			Common_SetValue('AANTI_GridRowEditer_cboPreMedIndicat',objRec.get('PreMedIndicatID'),objRec.get('PreMedIndicatDesc'));
			Common_SetValue('AANTI_GridRowEditer_cboPreMedEffect',objRec.get('PreMedEffectID'),objRec.get('PreMedEffectDesc'));
			Common_SetValue('AANTI_GridRowEditer_cboCombinedMed',objRec.get('CombinedMedID'),objRec.get('CombinedMedDesc'));
			Common_SetValue('AANTI_GridRowEditer_txtPreMedTime',objRec.get('PreMedTime'));
			Common_SetValue('AANTI_GridRowEditer_txtPostMedDays',objRec.get('PostMedDays'));
		} else {
			Common_SetValue('AANTI_GridRowEditer_cboArcim','','');
			Common_SetDisabled("AANTI_GridRowEditer_cboArcim",false);
			Common_SetValue('AANTI_GridRowEditer_txtDoseQty','');
			Common_SetValue('AANTI_GridRowEditer_cboDoseUnit','','');
			Common_SetValue('AANTI_GridRowEditer_cboPhcFreq','','');
			Common_SetValue('AANTI_GridRowEditer_txtStartDateTime','');
			Common_SetValue('AANTI_GridRowEditer_txtEndDateTime','');
			Common_SetValue('AANTI_GridRowEditer_cboMedUsePurpose','','');
			Common_SetValue('AANTI_GridRowEditer_cboAdminRoute','','');
			Common_SetValue('AANTI_GridRowEditer_cboMedPurpose','','');
			Common_SetValue('AANTI_GridRowEditer_cboTreatmentMode','','');
			Common_SetValue('AANTI_GridRowEditer_cboPreMedIndicat','','');
			Common_SetValue('AANTI_GridRowEditer_cboPreMedEffect','','');
			Common_SetValue('AANTI_GridRowEditer_cboCombinedMed','','');
			Common_SetValue('AANTI_GridRowEditer_txtPreMedTime','');
			Common_SetValue('AANTI_GridRowEditer_txtPostMedDays','');
		}
	}
	obj.AANTI_GridRowEditer = function(objRec) {
		obj.AANTI_GridRowEditer_objRec = objRec;
		var winGridRowEditer = Ext.getCmp('AANTI_GridRowEditer');
		if (!winGridRowEditer){
			winGridRowEditer = new Ext.Window({
				id : 'AANTI_GridRowEditer',
				height : 320,
				closeAction: 'hide',
				width : 450,
				modal : true,
				title : '抗菌用药-编辑',
				layout : 'fit',
				frame : true,
				items: [
					obj.AANTI_GridRowViewPort
				],
				buttons : [
					'->',
					new Ext.Toolbar.Button({
						id: "AANTI_GridRowEditer_btnUpdate",
						width : 80,
						text : "确定",
						iconCls : 'icon-update',
						listeners : {
							'click' : function(){
								var errInfo = obj.AANTI_GridRowDataCheck('');
								if (errInfo){
									ExtTool.alert("提示",errInfo);
									return;
								}
								obj.AANTI_GridRowDataSave(obj.AANTI_GridRowEditer_objRec);
								winGridRowEditer.hide();
							}
						}
					}),
					new Ext.Toolbar.Button({
						id: "AANTI_GridRowEditer_btnCancel",
						width : 80,
						text : "取消",
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
		obj.AANTI_GridRowDataSet(objRec);
	}
	
	//提取框
	obj.AANTI_GridExtract_gridAnti = new Ext.grid.GridPanel({
		id: 'AANTI_GridExtract_gridAnti',
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
		//,overflow:'scroll'
		//,overflow-y:hidden
		//,style:'overflow:auto;overflow-y:hidden'
		//,loadMask : true
		//,frame : true
		,anchor : '100%'
		,columns: [
			new Ext.grid.RowNumberer()
			//,{header: '用途', width: 60, dataIndex: 'MedUsePurposeDesc', sortable: false, menuDisabled:true, align:'center' }
			,{header: '药品名称', width: 200, dataIndex: 'ArcimDesc', sortable: false, menuDisabled:true, align:'center' }
			,{header: '给药途径', width: 60, dataIndex: 'AdminRouteDesc', sortable: false, menuDisabled:true, align:'center' }
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
	obj.AANTI_GridExtract = function() {
		var winGridRowEditer = Ext.getCmp('AANTI_GridExtract');
		if (!winGridRowEditer){
			winGridRowEditer = new Ext.Window({
				id : 'AANTI_GridExtract',
				height : 400,
				closeAction: 'hide',
				width : 600,
				modal : true,
				title : '抗菌用药-提取',
				layout : 'fit',
				frame : true,
				items: [
					obj.AANTI_GridExtract_gridAnti
				],
				buttons : [
					'->',
					new Ext.Toolbar.Button({
						id: "AANTI_GridExtract_btnUpdate",
						width : 80,
						text : "确定",
						iconCls : 'icon-update',
						listeners : {
							'click' : function(){
								var objRowDataGrid = Ext.getCmp('AANTI_GridExtract_gridAnti');
								var objGrid = Ext.getCmp('AANTI_gridAnti');
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
											obj.AANTI_GridRowEditer(RecordData);//点击确定提取数据后直接弹出抗菌用药编辑界面 add by yanjf,20140512
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
						id: "AANTI_GridExtract_btnCancel",
						width : 80,
						iconCls : 'icon-undo',
						text : "取消",
						listeners : {
							'click' : function(){
								winGridRowEditer.hide();
							}
						}
					})
				],
				listeners :{
					'beforeshow' : function(){
						var objRowDataGrid = Ext.getCmp('AANTI_GridExtract_gridAnti');
						if (objRowDataGrid) {
							objRowDataGrid.getStore().load({});
						}
					}
				}
			});
		}
		winGridRowEditer.show();
	}
	
	//主列表
	obj.AANTI_gridAnti_iniFun = function() {
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
			//,overflow:'scroll'
			//,overflow-y:hidden
			//,style:'overflow:auto;overflow-y:hidden'
			//,loadMask : true
			,frame : true
			,anchor : '100%'
			,columns: [
				new Ext.grid.RowNumberer()
				,{header: '药品名称', width: 200, dataIndex: 'ArcimDesc', sortable: false, menuDisabled:true, align:'center' }
				,{header: '用途', width: 60, dataIndex: 'MedUsePurposeDesc', sortable: false, menuDisabled:true, align:'center' }
				,{header: '给药途径', width: 60, dataIndex: 'AdminRouteDesc', sortable: false, menuDisabled:true, align:'center' }
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
			]
			,buttonAlign : 'left'
			,buttons : [
				new Ext.Toolbar.Button({
					id: arguments[0] + "_btnGet",
					width : 80,
					text : "提取数据",
					iconCls : 'icon-update',
					listeners : {
						'click' : function(){
							obj.AANTI_GridExtract();
						}
					}
				}),
				new Ext.Toolbar.Button({
					id: arguments[0] + "_btnAdd",
					width : 80,
					text : "增加",
					iconCls : 'icon-add',
					listeners : {
						'click' : function(){
							obj.AANTI_GridRowEditer('');
						}
					}
				}),
				new Ext.Toolbar.Button({
					id: arguments[0] + "_btnDelete",
					width : 80,
					text : "删除",
					iconCls : 'icon-delete',
					listeners : {
						'click' :  function(){
							var objGrid = Ext.getCmp("AANTI_gridAnti");
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
				})
				,'->'
				,'…'
			]
			,viewConfig : {
				forceFit : true
			}
		});
		
		return tmpGridPanel;
	}
	obj.AANTI_gridAnti = obj.AANTI_gridAnti_iniFun("AANTI_gridAnti");
	
	//界面布局
	obj.AANTI_ViewPort = {
		id : 'AANTIViewPort',
		//title : '抗菌用药',
		layout : 'fit',
		//frame : true,
		height : 300,
		anchor : '-20',
		tbar : ['<img SRC="../scripts/dhcmed/img/Anti.png"><b style="font-size:16px;">抗菌用药</b>'],
		items : [
			obj.AANTI_gridAnti
		]
	}
	
	//初始化界面
	obj.AANTI_InitView = function(){
		var objGrid = Ext.getCmp("AANTI_gridAnti");
		if (objGrid){
			objGrid.getStore().load({});
			objGrid.on('rowdblclick',function(){
				var rowIndex = arguments[1];
				var objRec = this.getStore().getAt(rowIndex);
				obj.AANTI_GridRowEditer(objRec);
			},objGrid);
		}
	}
	
	//数据存储
	obj.AANTI_SaveData = function(){
		var errinfo = '';
		
		var objCmp = Ext.getCmp('AANTI_gridAnti');
		if (objCmp) {
			var objStore = objCmp.getStore();
			for (var indRec = 0; indRec < objStore.getCount(); indRec++) {
				var objRec = objStore.getAt(indRec);
				
				//数据完整性校验
				var flg = obj.AANTI_GridRowDataCheck(objRec);
				if (flg){
					var row = objStore.indexOfId(objRec.id);  //获取行号
					errinfo = errinfo + '抗菌药物 第' + (row + 1) + '行 数据错误!<br>'
				}
				
				var objAnti = obj.ClsInfReportAntiSrv.GetSubObj('');
				if (objAnti) {
					if (objRec.get('RepID')&&objRec.get('SubID')) objAnti.RowID = objRec.get('RepID') + '||' + objRec.get('SubID');
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
					
					obj.CurrReport.ChildAnti.push(objAnti);
				}
			}
		}
		
		return errinfo;
	}
	
	return obj;
}