	
function InitOOPR(obj)
{
	obj.OOPR_CurrOprRec = "";
	obj.OOPR_cboOperation = Common_ComboToORCOperation("OOPR_cboOperation","<span><font color='red'>*</font>��������</span>");
	obj.OOPR_txtStartDateTime = Common_DateFieldToDateTime("OOPR_txtStartDateTime","<span><font color='red'>*</font>��ʼʱ��</span>");
	obj.OOPR_txtEndDateTime = Common_DateFieldToDateTime("OOPR_txtEndDateTime","<span><font color='red'>*</font>����ʱ��</span>");
	obj.OOPR_cboOperDoc = Common_ComboToSSUser("OOPR_cboOperDoc","<span><font color='red'>*</font>����ҽ��</span>");
	obj.OOPR_cboOperationType = Common_ComboToDic("OOPR_cboOperationType","<span><font color='red'>*</font>��������</span>","NINFInfOperationType");
	obj.OOPR_txtPreoperWBC = Common_NumberField("OOPR_txtPreoperWBC","��ǰ����WBC");
	obj.OOPR_cboCuteNumber = Common_ComboToDic("OOPR_cboCuteNumber","�пڸ���","NINFInfCuteNumber");
	obj.OOPR_cboCuteType = Common_ComboToDic("OOPR_cboCuteType","<span><font color='red'>*</font>�пڵȼ�</span>","NINFInfCuteType");
	obj.OOPR_cboEndoscopeFlag = Common_ComboToDic("OOPR_cboEndoscopeFlag","ʹ�ÿ���","NINFInfEndoscopeFlag");
	obj.OOPR_cboImplantFlag = Common_ComboToDic("OOPR_cboImplantFlag","ֲ����","NINFInfImplantFlag");
	obj.OOPR_cboASAScore = Common_ComboToDic("OOPR_cboASAScore","ASA(����)����","NINFInfASAScore");
	obj.OOPR_cboPreoperAntiFlag = Common_ComboToDic("OOPR_cboPreoperAntiFlag","��ǰ�ڷ�������","NINFInfPreoperAntiFlag");
	obj.OOPR_cboCuteHealing = Common_ComboToDic("OOPR_cboCuteHealing","<span><font color='red'>*</font>�������</span>","NINFInfCuteHealing");
	obj.OOPR_cboAnesthesia = Common_ComboToDic("OOPR_cboAnesthesia","<span><font color='red'>*</font>����ʽ</span>","NINFInfAnesthesia");
	
	obj.OOPR_cboCuteInfFlag = Common_ComboToDic("OOPR_cboCuteInfFlag","�пڸ�Ⱦ","NINFInfCuteInfFlag");
	obj.OOPR_cboOperInfType = Common_ComboToDic("OOPR_cboOperInfType","��Ⱦ����","NINFInfOperInfType");
	obj.OOPR_cboInHospInfFlag = Common_ComboToDic("OOPR_cboInHospInfFlag","��������Ժ��","NINFInfInHospInfFlag");
	obj.OOPR_cboCuteInfFlag.on('check',function(cb,val){
		Common_SetDisabled('OOPR_cboOperInfType',(!val));
		Common_SetDisabled('OOPR_cboInHospInfFlag',(!val));
		Common_SetValue('OOPR_cboOperInfType','');
		Common_SetValue('OOPR_cboInHospInfFlag',false);
	});
	
	obj.OOPR_cboBloodLossFlag = Common_ComboToDic("OOPR_cboBloodLossFlag","ʧѪ","NINFInfBloodLossFlag");
	obj.OOPR_txtBloodLoss = Common_NumberField("OOPR_txtBloodLoss","ʧѪ��(MLS)");
	obj.OOPR_cboBloodTransFlag = Common_ComboToDic("OOPR_cboBloodTransFlag","��Ѫ","NINFInfBloodTransFlag");
	obj.OOPR_txtBloodTrans = Common_NumberField("OOPR_txtBloodTrans","��Ѫ��(MLS)");
	obj.OOPR_cbgPostoperComps = Common_CheckboxGroupToDic("OOPR_cbgPostoperComps","���󲢷�֢","NINFInfPostoperComps",6);
	
	//��ս���
	obj.OOPR_DataClear = function(){
		Common_SetValue('OOPR_cboOperation','','');
		Common_SetValue('OOPR_txtStartDateTime','');
		Common_SetValue('OOPR_txtEndDateTime','');
		Common_SetValue('OOPR_cboOperDoc','','');
		Common_SetValue('OOPR_cboOperationType','','');
		Common_SetValue('OOPR_cboAnesthesia','','');
		Common_SetValue('OOPR_cboCuteType','','');
		Common_SetValue('OOPR_cboCuteHealing','','');
		Common_SetValue('OOPR_cboCuteInfFlag','','');
		Common_SetValue('OOPR_cboOperInfType','','');
		Common_SetValue('OOPR_cboInHospInfFlag','','');
		Common_SetValue('OOPR_cboASAScore','','');
		Common_SetValue('OOPR_txtPreoperWBC','');
		Common_SetValue('OOPR_cboCuteNumber','','');
		Common_SetValue('OOPR_cboEndoscopeFlag','','');
		Common_SetValue('OOPR_cboImplantFlag','','');
		Common_SetValue('OOPR_cboPreoperAntiFlag','','');
		Common_SetValue('OOPR_cboBloodLossFlag','','');
		Common_SetValue('OOPR_txtBloodLoss','');
		Common_SetValue('OOPR_cboBloodTransFlag','','');
		Common_SetValue('OOPR_txtBloodTrans','');
		Common_SetValue('OOPR_cbgPostoperComps','');
	}
	
	//��ȡ����
	obj.OOPR_RecExtract_gridOpr = new Ext.grid.GridPanel({
		id: 'OOPR_RecExtract_gridOpr',
		store : new Ext.data.Store({
			proxy: new Ext.data.HttpProxy({
				url : ExtToolSetting.RunQueryPageURL,
				listeners : {
					'beforeload' :  function(objProxy, param){
						param.ClassName = 'DHCMed.NINFService.Rep.InfReportOpr';
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
					,{name: 'OperationID', mapping: 'OperationID'}
					,{name: 'OperationDesc', mapping: 'OperationDesc'}
					,{name: 'OperDocID', mapping: 'OperDocID'}
					,{name: 'OperDocDesc', mapping: 'OperDocDesc'}
					,{name: 'OperStartDate', mapping: 'OperStartDate'}
					,{name: 'OperStartTime', mapping: 'OperStartTime'}
					,{name: 'OperEndDate', mapping: 'OperEndDate'}
					,{name: 'OperEndTime', mapping: 'OperEndTime'}
					,{name: 'OperationTypeID', mapping: 'OperationTypeID'}
					,{name: 'OperationTypeDesc', mapping: 'OperationTypeDesc'}
					,{name: 'AnesthesiaID', mapping: 'AnesthesiaID'}
					,{name: 'AnesthesiaDesc', mapping: 'AnesthesiaDesc'}
					,{name: 'CuteTypeID', mapping: 'CuteTypeID'}
					,{name: 'CuteTypeDesc', mapping: 'CuteTypeDesc'}
					,{name: 'CuteHealingID', mapping: 'CuteHealingID'}
					,{name: 'CuteHealingDesc', mapping: 'CuteHealingDesc'}
					,{name: 'CuteInfFlagID', mapping: 'CuteInfFlagID'}
					,{name: 'CuteInfFlagDesc', mapping: 'CuteInfFlagDesc'}
					,{name: 'OperInfTypeID', mapping: 'OperInfTypeID'}
					,{name: 'OperInfTypeDesc', mapping: 'OperInfTypeDesc'}
					,{name: 'InHospInfFlagID', mapping: 'InHospInfFlagID'}
					,{name: 'InHospInfFlagDesc', mapping: 'InHospInfFlagDesc'}
					,{name: 'ASAScoreID', mapping: 'ASAScoreID'}
					,{name: 'ASAScoreDesc', mapping: 'ASAScoreDesc'}
					,{name: 'DataSource', mapping: 'DataSource'}
					,{name: 'PreoperWBC', mapping: 'PreoperWBC'}
					,{name: 'CuteNumberID', mapping: 'CuteNumberID'}
					,{name: 'CuteNumberDesc', mapping: 'CuteNumberDesc'}
					,{name: 'EndoscopeFlagID', mapping: 'EndoscopeFlagID'}
					,{name: 'EndoscopeFlagDesc', mapping: 'EndoscopeFlagDesc'}
					,{name: 'ImplantFlagID', mapping: 'ImplantFlagID'}
					,{name: 'ImplantFlagDesc', mapping: 'ImplantFlagDesc'}
					,{name: 'PreoperAntiFlagID', mapping: 'PreoperAntiFlagID'}
					,{name: 'PreoperAntiFlagDesc', mapping: 'PreoperAntiFlagDesc'}
					,{name: 'BloodLossFlagID', mapping: 'BloodLossFlagID'}
					,{name: 'BloodLossFlagDesc', mapping: 'BloodLossFlagDesc'}
					,{name: 'BloodLoss', mapping: 'BloodLoss'}
					,{name: 'BloodTransFlagID', mapping: 'BloodTransFlagID'}
					,{name: 'BloodTransFlagDesc', mapping: 'BloodTransFlagDesc'}
					,{name: 'BloodTrans', mapping: 'BloodTrans'}
					,{name: 'PostoperComps', mapping: 'PostoperComps'}
					,{name: 'PostoperCompsDesc', mapping: 'PostoperCompsDesc'}
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
			,{header: '��������', width: 150, dataIndex: 'OperationDesc', sortable: false, menuDisabled:true, align:'center' }
			//,{header: '����<br>����', width: 50, dataIndex: 'OperationTypeDesc', sortable: false, menuDisabled:true, align:'center' }
			,{header: '������ʼʱ��', width : 100, sortable: false, menuDisabled:true, align:'center'
				, renderer: function(v, m, rd, r, c, s){
					if (rd.get("OperStartDate") != '') {
						return rd.get("OperStartDate") + ' ' + rd.get("OperStartTime");
					} else {
						return '';
					}
				}
			}
			,{header: '��������ʱ��', width : 100, sortable: false, menuDisabled:true, align:'center'
				, renderer: function(v, m, rd, r, c, s){
					if (rd.get("OperEndDate") != '') {
						return rd.get("OperEndDate") + ' ' + rd.get("OperEndTime");
					} else {
						return '';
					}
				}
			}
			,{header: '����ҽ��', width: 60, dataIndex: 'OperDocDesc', sortable: false, menuDisabled:true, align:'center' }
			,{header: '������', width: 60, dataIndex: 'AnesthesiaDesc', sortable: false, menuDisabled:true, align:'center' }
			//,{header: '�п�<br>����', width: 50, dataIndex: 'CuteTypeDesc', sortable: false, menuDisabled:true, align:'center' }
			//,{header: '����<br>���', width: 50, dataIndex: 'CuteHealingDesc', sortable: false, menuDisabled:true, align:'center' }
			//,{header: '�п�<br>��Ⱦ', width: 50, dataIndex: 'CuteInfFlagDesc', sortable: false, menuDisabled:true, align:'center' }
			//,{header: '��Ⱦ����', width: 50, dataIndex: 'OperInfTypeDesc', sortable: false, menuDisabled:true, align:'center' }
			//,{header: '����Ժ<br>�ڸ�Ⱦ', width: 60, dataIndex: 'InHospInfFlagDesc', sortable: false, menuDisabled:true, align:'center' }
			,{header: '����<br>��Դ', width: 50, dataIndex: 'DataSource', sortable: false, menuDisabled:true, align:'center' }
		],
		viewConfig : {
			forceFit : true
		}
	});
	obj.OOPR_RecExtract = function() {
		var winGridRowEditer = Ext.getCmp('OOPR_RecExtract');
		if (!winGridRowEditer){
			winGridRowEditer = new Ext.Window({
				id : 'OOPR_RecExtract',
				height : 400,
				closeAction: 'hide',
				width : 600,
				modal : true,
				title : '�������-��ȡ',
				layout : 'fit',
				frame : true,
				items: [
					obj.OOPR_RecExtract_gridOpr
				],
				buttons : [
					'->',
					new Ext.Toolbar.Button({
						id: "OOPR_RecExtract_btnUpdate",
						width : 80,
						iconCls : 'icon-update',
						text : "ȷ��",
						listeners : {
							'click' : function(){
								var objGrid = Ext.getCmp('OOPR_RecExtract_gridOpr');
								if (objGrid) {
									var arrRec = objGrid.getSelectionModel().getSelections();
									if (arrRec.length > 0) {
										var objRec = arrRec[0];
										obj.OOPR_DataClear();
										Common_SetValue('OOPR_cboOperation',objRec.get('OperationID'),objRec.get('OperationDesc'));
										Common_SetValue('OOPR_txtStartDateTime',objRec.get('OperStartDate') + ' ' + objRec.get('OperStartTime'));
										Common_SetValue('OOPR_txtEndDateTime',objRec.get('OperEndDate') + ' ' + objRec.get('OperEndTime'));
										Common_SetValue('OOPR_cboOperDoc',objRec.get('OperDocID'),objRec.get('OperDocDesc'));
										Common_SetValue('OOPR_cboOperationType',objRec.get('OperationTypeID'),objRec.get('OperationTypeDesc'));
										Common_SetValue('OOPR_cboAnesthesia',objRec.get('AnesthesiaID'),objRec.get('AnesthesiaDesc'));
										Common_SetValue('OOPR_cboCuteType',objRec.get('CuteTypeID'),objRec.get('CuteTypeDesc'));
										Common_SetValue('OOPR_cboCuteHealing',objRec.get('CuteHealingID'),objRec.get('CuteHealingDesc'));
										Common_SetValue('OOPR_cboCuteInfFlag',objRec.get('CuteInfFlagID'),objRec.get('CuteInfFlagDesc'));
										Common_SetValue('OOPR_cboOperInfType',objRec.get('OperInfTypeID'),objRec.get('OperInfTypeDesc'));
										Common_SetValue('OOPR_cboInHospInfFlag',objRec.get('InHospInfFlagID'),objRec.get('InHospInfFlagDesc'));
										Common_SetValue('OOPR_cboASAScore',objRec.get('ASAScoreID'),objRec.get('ASAScoreDesc'));
										Common_SetValue('OOPR_txtPreoperWBC',objRec.get('PreoperWBC'));
										Common_SetValue('OOPR_cboCuteNumber',objRec.get('CuteNumberID'),objRec.get('CuteNumberDesc'));
										Common_SetValue('OOPR_cboEndoscopeFlag',objRec.get('EndoscopeFlagID'),objRec.get('EndoscopeFlagDesc'));
										Common_SetValue('OOPR_cboImplantFlag',objRec.get('ImplantFlagID'),objRec.get('ImplantFlagDesc'));
										Common_SetValue('OOPR_cboPreoperAntiFlag',objRec.get('PreoperAntiFlagID'),objRec.get('PreoperAntiFlagDesc'));
										Common_SetValue('OOPR_cboBloodLossFlag',objRec.get('BloodLossFlagID'),objRec.get('BloodLossFlagDesc'));
										Common_SetValue('OOPR_txtBloodLoss',objRec.get('BloodLoss'));
										Common_SetValue('OOPR_cboBloodTransFlag',objRec.get('BloodTransFlagID'),objRec.get('BloodTransFlagDesc'));
										Common_SetValue('OOPR_txtBloodTrans',objRec.get('BloodTrans'));
										Common_SetValue('OOPR_cbgPostoperComps',objRec.get('PostoperComps'));
										winGridRowEditer.hide();
									} else {
										ExtTool.alert("��ʾ","��ѡ��һ��������¼�ٵ�ȷ��!");
									}
								} else {
									winGridRowEditer.hide();
								}
							}
						}
					}),
					new Ext.Toolbar.Button({
						id: "OOPR_RecExtract_btnCancel",
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
						var objRowDataGrid = Ext.getCmp('OOPR_RecExtract_gridOpr');
						if (objRowDataGrid) {
							objRowDataGrid.getStore().load({});
						}
					}
				}
			});
		}
		winGridRowEditer.show();
	}
	obj.OOPR_btnGetRec = new Ext.Button({
		id : 'OOPR_btnGetRec'
		,width : 80
		,text : "��ȡ����"
		,iconCls : 'icon-update'
		,listeners : {
			'click' :  function(){
				obj.OOPR_RecExtract();
			}
		}
	});
	
	//���沼��
	obj.OOPR_ViewPort = {
		id : 'OOPRViewPort',
		layout : 'border',
		//frame : true,
		height : 250,
		anchor : '-20',
		tbar : ['<img SRC="../scripts/dhcmed/img/OPR.png"><b style="font-size:16px;">�����пڼ��</b>'],
		items : [
			{
				region: 'center',
				layout : 'form',
				frame : true,
				items : [
					{
						layout : 'column',
						items : [
							{
								columnWidth:.50,
								layout : 'form',
								labelAlign : 'right',
								labelWidth : 100,
								items : [obj.OOPR_cboOperation]
							},{
								columnWidth:.10,
								layout : 'form',
								items : [obj.OOPR_btnGetRec]
							}
						]
					},{
						layout : 'column',
						items : [
							{
								columnWidth:.25,
								layout : 'form',
								labelAlign : 'right',
								labelWidth : 100,
								items : [obj.OOPR_txtStartDateTime]
							},{
								columnWidth:.25,
								layout : 'form',
								labelAlign : 'right',
								labelWidth : 100,
								items : [obj.OOPR_txtEndDateTime]
							},{
								columnWidth:.25,
								layout : 'form',
								labelAlign : 'right',
								labelWidth : 100,
								items : [obj.OOPR_cboOperDoc]
							},{
								columnWidth:.25,
								layout : 'form',
								labelAlign : 'right',
								labelWidth : 120,
								items : [obj.OOPR_cboOperationType]
							}
						]
					},{
						layout : 'column',
						items : [
							{
								columnWidth:.25,
								layout : 'form',
								labelAlign : 'right',
								labelWidth : 100,
								items : [obj.OOPR_txtPreoperWBC]
							},{
								columnWidth:.25,
								layout : 'form',
								labelAlign : 'right',
								labelWidth : 100,
								items : [obj.OOPR_cboCuteNumber]
							},{
								columnWidth:.25,
								layout : 'form',
								labelAlign : 'right',
								labelWidth : 100,
								items : [obj.OOPR_cboCuteType]
							},{
								columnWidth:.25,
								layout : 'form',
								labelAlign : 'right',
								labelWidth : 120,
								items : [obj.OOPR_cboCuteHealing]
							}
						]
					},{
						layout : 'column',
						items : [
							{
								columnWidth:.25,
								layout : 'form',
								labelAlign : 'right',
								labelWidth : 100,
								items : [obj.OOPR_cboAnesthesia]
							},{
								columnWidth:.25,
								layout : 'form',
								labelAlign : 'right',
								labelWidth : 100,
								items : [obj.OOPR_cboEndoscopeFlag]
							},{
								columnWidth:.25,
								layout : 'form',
								labelAlign : 'right',
								labelWidth : 100,
								items : [obj.OOPR_cboImplantFlag]
							},{
								columnWidth:.25,
								layout : 'form',
								labelAlign : 'right',
								labelWidth : 120,
								items : [obj.OOPR_cboPreoperAntiFlag]
							}
						]
					},{
						layout : 'column',
						items : [
							{
								columnWidth:.25,
								layout : 'form',
								labelAlign : 'right',
								labelWidth : 100,
								items : [obj.OOPR_cboASAScore]
							},{
								columnWidth:.25,
								layout : 'form',
								labelAlign : 'right',
								labelWidth : 100,
								items : [obj.OOPR_cboCuteInfFlag]
							},{
								columnWidth:.25,
								layout : 'form',
								labelAlign : 'right',
								labelWidth : 100,
								items : [obj.OOPR_cboOperInfType]
							},{
								columnWidth:.25,
								layout : 'form',
								labelAlign : 'right',
								labelWidth : 120,
								items : [obj.OOPR_cboInHospInfFlag]
							}
						]
					},{
						layout : 'column',
						items : [
							{
								columnWidth:.25,
								layout : 'form',
								labelAlign : 'right',
								labelWidth : 100,
								items : [obj.OOPR_cboBloodLossFlag]
							},{
								columnWidth:.25,
								layout : 'form',
								labelAlign : 'right',
								labelWidth : 100,
								items : [obj.OOPR_txtBloodLoss]
							},{
								columnWidth:.25,
								layout : 'form',
								labelAlign : 'right',
								labelWidth : 100,
								items : [obj.OOPR_cboBloodTransFlag]
							},{
								columnWidth:.25,
								layout : 'form',
								labelAlign : 'right',
								labelWidth : 120,
								items : [obj.OOPR_txtBloodTrans]
							}
						]
					},{
						layout : 'column',
						items : [
							{
								columnWidth:.70,
								layout : 'form',
								labelAlign : 'right',
								labelWidth : 100,
								items : [obj.OOPR_cbgPostoperComps]
							}
						]
					}
				]
			}
		]
	}
	
	//��ʼ������
	obj.OOPR_InitView = function(){
		obj.OOPR_DataClear();
		if (obj.CurrReport.ChildOpr.length > 0){
			var objOpr = obj.CurrReport.ChildOpr[0];
			obj.OOPR_CurrOprRec = objOpr;
			Common_SetValue('OOPR_cboOperation',objOpr.OperationID,objOpr.OperationDesc);
			Common_SetValue('OOPR_txtStartDateTime',objOpr.OperStartDate + ' ' + objOpr.OperStartTime);
			Common_SetValue('OOPR_txtEndDateTime',objOpr.OperEndDate + ' ' + objOpr.OperEndTime);
			if (objOpr.OperDoc){
				Common_SetValue('OOPR_cboOperDoc',objOpr.OperDoc.Rowid,objOpr.OperDoc.Name);
			}
			if (objOpr.OperationType){
				Common_SetValue('OOPR_cboOperationType',objOpr.OperationType.RowID,objOpr.OperationType.Description);
			}
			if (objOpr.Anesthesia){
				Common_SetValue('OOPR_cboAnesthesia',objOpr.Anesthesia.RowID,objOpr.Anesthesia.Description);
			}
			if (objOpr.CuteType){
				Common_SetValue('OOPR_cboCuteType',objOpr.CuteType.RowID,objOpr.CuteType.Description);
			}
			if (objOpr.CuteHealing){
				Common_SetValue('OOPR_cboCuteHealing',objOpr.CuteHealing.RowID,objOpr.CuteHealing.Description);
			}
			if (objOpr.CuteInfFlag){
				Common_SetValue('OOPR_cboCuteInfFlag',objOpr.CuteInfFlag.RowID,objOpr.CuteInfFlag.Description);
			}
			if (objOpr.OperInfType){
				Common_SetValue('OOPR_cboOperInfType',objOpr.OperInfType.RowID,objOpr.OperInfType.Description);
			}
			if (objOpr.InHospInfFlag){
				Common_SetValue('OOPR_cboInHospInfFlag',objOpr.InHospInfFlag.RowID,objOpr.InHospInfFlag.Description);
			}
			if (objOpr.ASAScore){
				Common_SetValue('OOPR_cboASAScore',objOpr.ASAScore.RowID,objOpr.ASAScore.Description);
			}
			Common_SetValue('OOPR_txtPreoperWBC',objOpr.PreoperWBC);
			if (objOpr.CuteNumber){
				Common_SetValue('OOPR_cboCuteNumber',objOpr.CuteNumber.RowID,objOpr.CuteNumber.Description);
			}
			if (objOpr.EndoscopeFlag){
				Common_SetValue('OOPR_cboEndoscopeFlag',objOpr.EndoscopeFlag.RowID,objOpr.EndoscopeFlag.Description);
			}
			if (objOpr.ImplantFlag){
				Common_SetValue('OOPR_cboImplantFlag',objOpr.ImplantFlag.RowID,objOpr.ImplantFlag.Description);
			}
			if (objOpr.PreoperAntiFlag){
				Common_SetValue('OOPR_cboPreoperAntiFlag',objOpr.PreoperAntiFlag.RowID,objOpr.PreoperAntiFlag.Description);
			}
			if (objOpr.BloodLossFlag){
				Common_SetValue('OOPR_cboBloodLossFlag',objOpr.BloodLossFlag.RowID,objOpr.BloodLossFlag.Description);
			}
			Common_SetValue('OOPR_txtBloodLoss',objOpr.BloodLoss);
			if (objOpr.BloodTransFlag){
				Common_SetValue('OOPR_cboBloodTransFlag',objOpr.BloodTransFlag.RowID,objOpr.BloodTransFlag.Description);
			}
			Common_SetValue('OOPR_txtBloodTrans',objOpr.BloodTrans);
			
			var varPostoperComps = '';
			if (objOpr.PostoperComps) {
				var arrPostoperComps = objOpr.PostoperComps;
				for (var ind = 0; ind < arrPostoperComps.length; ind++) {
					var objDic = arrPostoperComps[ind];
					if (objDic) {
						varPostoperComps = (varPostoperComps == '' ? objDic.RowID : varPostoperComps + ',' + objDic.RowID);
					}
				}
			}
			Common_SetValue('OOPR_cbgPostoperComps',varPostoperComps);
		}
	}
	
	//���ݴ洢
	obj.OOPR_SaveData = function(){
		var errinfo = '';
		
		if (obj.OOPR_CurrOprRec){
			var objOpr = obj.OOPR_CurrOprRec;
		} else {
			var objOpr = obj.ClsInfReportOprSrv.GetSubObj('');
		}
		objOpr.OperationID = Common_GetValue('OOPR_cboOperation');
		objOpr.OperationDesc = Common_GetText('OOPR_cboOperation');
		var StartDateTime = Common_GetValue('OOPR_txtStartDateTime');
		var arrDateTime = StartDateTime.split(' ');
		if (arrDateTime.length>1){
			var StartDate = arrDateTime[0];
			var StartTime = arrDateTime[1];
		} else {
			var StartDate = '';
			var StartTime = '';
		}
		var EndDateTime = Common_GetValue('OOPR_txtEndDateTime');
		var arrDateTime = EndDateTime.split(' ');
		if (arrDateTime.length>1){
			var EndDate = arrDateTime[0];
			var EndTime = arrDateTime[1];
		} else {
			var EndDate = '';
			var EndTime = '';
		}
		objOpr.OperStartDate = StartDate;
		objOpr.OperStartTime = StartTime;
		objOpr.OperEndDate = EndDate;
		objOpr.OperEndTime = EndTime;
		objOpr.OperDoc = obj.ClsBaseSSUser.GetObjById(Common_GetValue('OOPR_cboOperDoc'));
		objOpr.OperationType = obj.ClsSSDictionary.GetObjById(Common_GetValue('OOPR_cboOperationType'));
		objOpr.Anesthesia = obj.ClsSSDictionary.GetObjById(Common_GetValue('OOPR_cboAnesthesia'));
		objOpr.CuteType = obj.ClsSSDictionary.GetObjById(Common_GetValue('OOPR_cboCuteType'));
		objOpr.CuteHealing = obj.ClsSSDictionary.GetObjById(Common_GetValue('OOPR_cboCuteHealing'));
		objOpr.CuteInfFlag = obj.ClsSSDictionary.GetObjById(Common_GetValue('OOPR_cboCuteInfFlag'));
		objOpr.OperInfType = obj.ClsSSDictionary.GetObjById(Common_GetValue('OOPR_cboOperInfType'));
		objOpr.InHospInfFlag = obj.ClsSSDictionary.GetObjById(Common_GetValue('OOPR_cboInHospInfFlag'));
		objOpr.ASAScore = obj.ClsSSDictionary.GetObjById(Common_GetValue('OOPR_cboASAScore'));
		objOpr.PreoperWBC = Common_GetText('OOPR_txtPreoperWBC');
		objOpr.CuteNumber = obj.ClsSSDictionary.GetObjById(Common_GetValue('OOPR_cboCuteNumber'));
		objOpr.EndoscopeFlag = obj.ClsSSDictionary.GetObjById(Common_GetValue('OOPR_cboEndoscopeFlag'));
		objOpr.ImplantFlag = obj.ClsSSDictionary.GetObjById(Common_GetValue('OOPR_cboImplantFlag'));
		objOpr.PreoperAntiFlag = obj.ClsSSDictionary.GetObjById(Common_GetValue('OOPR_cboPreoperAntiFlag'));
		objOpr.BloodLossFlag = obj.ClsSSDictionary.GetObjById(Common_GetValue('OOPR_cboBloodLossFlag'));
		objOpr.BloodLoss = Common_GetText('OOPR_txtBloodLoss');
		objOpr.BloodTransFlag = obj.ClsSSDictionary.GetObjById(Common_GetValue('OOPR_cboBloodTransFlag'));
		objOpr.BloodTrans = Common_GetText('OOPR_txtBloodTrans');
		objOpr.PostoperComps = new Array();
		var itmValue = Common_GetValue('OOPR_cbgPostoperComps');
		var arrValue = itmValue.split(',');
		if (itmValue) {
			for (var ind = 0; ind < arrValue.length; ind++) {
				var objDic = obj.ClsSSDictionary.GetObjById(arrValue[ind]);
				if (objDic) {
					objOpr.PostoperComps.push(objDic);
				}
			}
		}
		
		//���������У��
		if (!objOpr.OperationDesc) {
			errinfo = errinfo + '�������� δ��!<br>'
		}
		if (!objOpr.OperStartDate) {
			errinfo = errinfo + '��ʼʱ�� δ��!<br>'
		}
		if (!objOpr.OperEndDate) {
			errinfo = errinfo + '����ʱ�� δ��!<br>'
		}
		/*if ((objOpr.OperStartDate!="")&&(objOpr.OperEndDate!="")&&(objOpr.OperEndDate<objOpr.OperStartDate)) {
			errinfo = errinfo + '��ʼʱ�䲻�ܴ��ڽ���ʱ��<br>'
		}*/
		
		if ((objOpr.OperStartDate!="")&&(objOpr.OperEndDate!="")&&(Common_DateParse(objOpr.OperEndDate)<Common_DateParse(objOpr.OperStartDate))) {
			errinfo = errinfo + '��ʼʱ�䲻�ܴ��ڽ���ʱ��<br>'
		}
		
		if (!objOpr.OperDoc) {
			errinfo = errinfo + '����ҽ�� δ��!<br>'
		}
		if (!objOpr.OperationType) {
			errinfo = errinfo + '�������� δ��!<br>'
		}
		if (!objOpr.Anesthesia) {
			errinfo = errinfo + '����ʽ δ��!<br>'
		}
		if (!objOpr.CuteType) {
			errinfo = errinfo + '�пڵȼ� δ��!<br>'
		}
		if (!objOpr.CuteHealing) {
			errinfo = errinfo + '������� δ��!<br>'
		}
		if (objOpr.CuteInfFlag) {
			if ((objOpr.CuteInfFlag.Code == 'Y')&&(!objOpr.OperInfType)) {
				errinfo = errinfo + '��Ⱦ���� δ��!<br>'
			}
		}
		obj.CurrReport.ChildOpr.push(objOpr);
		
		return errinfo;
	}
	
	return obj;
}