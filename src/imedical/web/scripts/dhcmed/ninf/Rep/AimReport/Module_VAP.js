
function InitVAP(obj)
{
	obj.VAP_valSubID = '';
	
	obj.gridAntibioticsVAPStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.gridAntibioticsVAPStore = new Ext.data.Store({
		proxy: obj.gridAntibioticsVAPStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'ind'
		}, 
		[
		//ArcimID,ArcimName,StartDate,StartTime,EndDate,EndTime
		   {name: 'ind', mapping : 'ind'}
			,{name: 'ArcimID', mapping : 'ArcimID'}
			,{name: 'ArcimName', mapping : 'ArcimName'}
			,{name: 'StartDate', mapping: 'StartDate'}
			,{name: 'StartTime', mapping: 'StartTime'}
			,{name: 'EndDate', mapping: 'EndDate'}
			,{name: 'EndTime', mapping: 'EndTime'}
		])
	});
	obj.gridAntibioticsVAP = new Ext.grid.EditorGridPanel({
		id : 'gridAntibioticsVAP'
		,store : obj.gridAntibioticsVAPStore
		,selModel : new Ext.grid.RowSelectionModel({singleSelect : true})
		,clicksToEdit : 1
		,columnLines : true
		,stripeRows : true
		,height : 150
		,region : 'north'
		,columns: [
			{header: 'ҽ������', width: 250, dataIndex: 'ArcimName', sortable: true, align: 'center'}
			,{header: '��ʼ����', width: 80, dataIndex: 'StartDate', sortable: false, align: 'center'}
			,{header: '��ʼʱ��', width: 60, dataIndex: 'StartTime', sortable: false, align: 'center'}
			,{header: '��������', width: 80, dataIndex: 'EndDate', sortable: false, menuDisabled:true, align: 'center'}
			,{header: '����ʱ��', width: 60, dataIndex: 'EndTime', sortable: false, align: 'center'}
		]
		,viewConfig : {
			forceFit : true
		}
		,listeners : {
							'rowdblclick' : function(){
								
								var selectObj = obj.gridAntibioticsVAP.getSelectionModel().getSelected();
								if (selectObj){
								
								obj.VAP_txtIntubateDateTime.setValue(selectObj.get("StartDate")+" "+ selectObj.get("StartTime"));
								obj.VAP_txtExtubateDateTime.setValue(selectObj.get("EndDate")+" "+ selectObj.get("EndTime"));
							}
						}
					}
    });
    
  
	obj.gridAntibioticsVAPStoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'DHCMed.NINFService.Rep.AimReport';
		param.QueryName = 'QueryOEInfo';
		param.Arg1 = obj.CurrReport.ChildVAP.EpisodeID;
		param.Arg2 = 'VAP';		//ҽ������
		param.ArgCnt = 2;
	});
	
	obj.gridAntibioticsVAPStore.load({});
	
	//�ϻ�ʱ��
	obj.VAP_txtIntubateDateTime = Common_DateFieldToDateTime("VAP_txtIntubateDateTime","�ϻ�ʱ��");
	
	//�ѻ�ʱ��
	obj.VAP_txtExtubateDateTime = Common_DateFieldToDateTime("VAP_txtExtubateDateTime","�ѻ�ʱ��");
	
	//�ùܵص�
	obj.VAP_cboIntubatePlace = Common_ComboToDic("VAP_cboIntubatePlace","�ùܵص�","NINFAimVAPIntubatePlace");
	
	//�ù�����
	obj.VAP_cboIntubateType = Common_ComboToDic("VAP_cboIntubateType","�ù�����","NINFAimVAPIntubateType");
	
	//�ù���Ա����
	obj.VAP_cboIntubateUserType = Common_ComboToDic("VAP_cboIntubateUserType","�ù���Ա","NINFAimVAPIntubateUserType");
	
	//�ù���Ա
	obj.VAP_cboIntubateUser = Common_ComboToSSUser("VAP_cboIntubateUser","�ù���Ա");
	
	//�Ƿ��Ⱦ
	obj.VAP_chkIsInf = Common_Checkbox("VAP_chkIsInf","�Ƿ��Ⱦ");
	obj.VAP_chkIsInf.on('check',function(checkbox,value){
		var objItem1 = Ext.getCmp("VAP_txtInfDate");
		if (objItem1) {
			objItem1.setDisabled((!value));
		}
		var objItem1 = Ext.getCmp("VAP_cboInfPy");
		if (objItem1) {
			objItem1.setDisabled((!value));
		}
		if (!value) {
			Common_SetValue('VAP_txtInfDate','');
			Common_SetValue('VAP_cboInfPy','','');
		}
	},obj.VAP_chkIsInf);
	
	//��Ⱦ����
	obj.VAP_txtInfDate = Common_DateFieldToDate("VAP_txtInfDate","��Ⱦ����");
	
	//��ԭ��
	obj.VAP_cboInfPy = Common_ComboToPathogeny("VAP_cboInfPy","��ԭ��");
	
	obj.VAP_GridRowViewPort = {
		layout : 'fit',
		labelAlign : 'right',
		labelWidth : 60,
		frame : true,
		region : 'center',
		items : [
		{
				layout : 'column',
				items : [
					{
						columnWidth:.50,
						layout : 'form',
						labelAlign : 'right',
						labelWidth : 60,
						items : [
							obj.VAP_txtIntubateDateTime
							,obj.VAP_cboIntubatePlace
							,obj.VAP_cboIntubateType
							,obj.VAP_cboIntubateUserType
							//,obj.VAP_cboIntubateUser
						]
					},{
						columnWidth:.50,
						layout : 'form',
						labelAlign : 'right',
						labelWidth : 60,
						items : [
							obj.VAP_txtExtubateDateTime
							//,obj.VAP_cboIntubateUser
							,obj.VAP_chkIsInf
							,obj.VAP_txtInfDate
							,obj.VAP_cboInfPy
						]
					}

				]
			}
			
		]
	}
	
	obj.VAP_GridRowDataCheck = function()
	{
		var errInfo = '';
		
		var StatusCode = arguments[0];
		var objRec = arguments[1];
		if (objRec)
		{
			if (StatusCode == '2') {
				var VAP_txtIntubateDateTime = objRec.get('IntubateDateTime');
				if (VAP_txtIntubateDateTime=='') {
					errInfo = errInfo + '�ϻ�ʱ��δ��!';
				}
				var VAP_cboIntubatePlace = objRec.get('IntubatePlaceDesc');
				if (VAP_cboIntubatePlace=='') {
					errInfo = errInfo + '�ùܵص�δ��!';
				}
				var VAP_cboIntubateType = objRec.get('IntubateTypeDesc');
				if (VAP_cboIntubateType=='') {
					errInfo = errInfo + '�ù�����δ��!';
				}
				var VAP_cboIntubateUserType = objRec.get('IntubateUserTypeDesc');
				if (VAP_cboIntubateUserType=='') {
					errInfo = errInfo + '�ù���Աδ��!';
				}
				var VAP_cboIntubateUser = objRec.get('IntubateUserDesc');
				if (VAP_cboIntubateUser=='') {
					//errInfo = errInfo + '�ù���Աδ��!';
				}
				var VAP_txtExtubateDateTime = objRec.get('ExtubateDateTime');
				if (VAP_txtExtubateDateTime=='') {
					errInfo = errInfo + '�ѻ�ʱ��δ��!';
				}
			}
		} else {
			if (StatusCode == '1') {
				var VAP_txtIntubateDateTime = Common_GetValue('VAP_txtIntubateDateTime');
				if (VAP_txtIntubateDateTime=='') {
					errInfo = errInfo + '�ϻ�ʱ��δ��!';
				}
			}
			if (StatusCode == '2') {
				var VAP_txtIntubateDateTime = Common_GetValue('VAP_txtIntubateDateTime');
				if (VAP_txtIntubateDateTime=='') {
					errInfo = errInfo + '�ϻ�ʱ��δ��!';
				}
				var VAP_cboIntubatePlace = Common_GetValue('VAP_cboIntubatePlace');
				if (VAP_cboIntubatePlace=='') {
					errInfo = errInfo + '�ùܵص�δ��!';
				}
				var VAP_cboIntubateType = Common_GetValue('VAP_cboIntubateType');
				if (VAP_cboIntubateType=='') {
					errInfo = errInfo + '�ù�����δ��!';
				}
				var VAP_cboIntubateUserType = Common_GetValue('VAP_cboIntubateUserType');
				if (VAP_cboIntubateUserType=='') {
					errInfo = errInfo + '�ù���Աδ��!';
				}
				var VAP_cboIntubateUser = Common_GetValue('VAP_cboIntubateUser');
				if (VAP_cboIntubateUser=='') {
					//errInfo = errInfo + '�ù���Աδ��!';
				}
				var VAP_txtExtubateDateTime = Common_GetValue('VAP_txtExtubateDateTime');
				if (VAP_txtExtubateDateTime=='') {
					errInfo = errInfo + '�ѻ�ʱ��δ��!';
				}
			}
		}
		
		return errInfo;
	}
	
	obj.VAP_GridRowDataUpdateStatus = function()
	{
		var StatusCode = arguments[0];
		var objRec = arguments[1];
		if (objRec) {
			var inputStr = objRec.get('RepID') + "||" + objRec.get('SubID');
		} else {
			var inputStr = obj.CurrReport.ChildVAP.RowID + "||" + obj.VAP_valSubID;
		}
		inputStr = inputStr + CHR_1 + session['LOGON.CTLOCID'];
		inputStr = inputStr + CHR_1 + session['LOGON.USERID'];
		inputStr = inputStr + CHR_1 + StatusCode;
		
		var flg = obj.ClsAimReportVAPSrv.UpdateStatus(inputStr, CHR_1);
		if (parseInt(flg) <= 0) {
			return false;
		} else {
			return true;
		}
		return true;
	}
	
	obj.VAP_GridRowDataSave = function()
	{
		if (obj.CurrReport.ChildVAP.RowID == "")
		{
			var inputStr = "";
			inputStr = inputStr + CHR_1 + obj.CurrReport.ChildVAP.ReportTypeCode;
			inputStr = inputStr + CHR_1 + obj.CurrReport.ChildVAP.EpisodeID;
			inputStr = inputStr + CHR_1 + obj.CurrReport.ChildVAP.TransID;
			inputStr = inputStr + CHR_1 + obj.CurrReport.ChildVAP.TransLoc;
			inputStr = inputStr + CHR_1 + "";
			inputStr = inputStr + CHR_1 + "";
			inputStr = inputStr + CHR_1 + "";
			inputStr = inputStr + CHR_1 + "";
			inputStr = inputStr + CHR_1 + "";
			inputStr = inputStr + CHR_1 + session['LOGON.CTLOCID'];
			inputStr = inputStr + CHR_1 + session['LOGON.USERID'];
			inputStr = inputStr + CHR_1 + '';
			
			var flg = obj.ClsAimReportSrv.SaveReport(inputStr, CHR_1);
			if (parseInt(flg)<=0) {
				return false;
			} else {
				var objAimReport = obj.ClsAimReport.GetObjById(flg);
				objAimReport.ReportTypeCode = '';
				var objDictionary = obj.ClsSSDictionary.GetObjById(objAimReport.ReportType);
				if (objDictionary) {
					objAimReport.ReportTypeCode = objDictionary.Code;
				}
				obj.CurrReport.ChildVAP = objAimReport;
			}
		}
		if (obj.CurrReport.ChildVAP.RowID=='') return false;
		
		var StatusCode = arguments[0];
		
		var inputStr = obj.CurrReport.ChildVAP.RowID;
		inputStr = inputStr + CHR_1 + obj.VAP_valSubID;
		inputStr = inputStr + CHR_1 + Common_GetValue('VAP_txtIntubateDateTime');
		inputStr = inputStr + CHR_1 + Common_GetValue('VAP_txtExtubateDateTime');
		inputStr = inputStr + CHR_1 + Common_GetValue('VAP_cboIntubatePlace');
		inputStr = inputStr + CHR_1 + Common_GetValue('VAP_cboIntubateUserType');
		inputStr = inputStr + CHR_1 + Common_GetValue('VAP_cboIntubateUser');
		inputStr = inputStr + CHR_1 + Common_GetValue('VAP_cboIntubateType');
		inputStr = inputStr + CHR_1 + Common_GetValue('VAP_txtInfDate');
		inputStr = inputStr + CHR_1 + Common_GetValue('VAP_cboInfPy') + CHR_3 + Common_GetText('VAP_cboInfPy');
		inputStr = inputStr + CHR_1 + session['LOGON.CTLOCID'];
		inputStr = inputStr + CHR_1 + session['LOGON.USERID'];
		inputStr = inputStr + CHR_1 + StatusCode;
		
		var flg = obj.ClsAimReportVAPSrv.SaveReport(inputStr, CHR_1);
		if (parseInt(flg)<=0) {
			return false;
		} else {
			return true;
		}
		return true;
	}
	
	obj.VAP_GridRowDataSet = function(objRec)
	{
		if (objRec)
		{
			obj.VAP_valSubID = objRec.get('SubID');
			Common_SetValue('VAP_txtIntubateDateTime',objRec.get('IntubateDateTime'));
			Common_SetValue('VAP_txtExtubateDateTime',objRec.get('ExtubateDateTime'));
			Common_SetValue('VAP_cboIntubatePlace',objRec.get('IntubatePlaceID'),objRec.get('IntubatePlaceDesc'));
			Common_SetValue('VAP_cboIntubateUserType',objRec.get('IntubateUserTypeID'),objRec.get('IntubateUserTypeDesc'));
			Common_SetValue('VAP_cboIntubateUser',objRec.get('IntubateUserID'),objRec.get('IntubateUserDesc'));
			Common_SetValue('VAP_cboIntubateType',objRec.get('IntubateTypeID'),objRec.get('IntubateTypeDesc'));
			
			//�Ƿ��Ⱦ,��Ⱦ����,��ԭ��
			Common_SetValue('VAP_chkIsInf',(objRec.get('IsInfection')=='��'));
			Common_SetValue('VAP_txtInfDate',objRec.get('InfDate'));
			var strInfPyValues = objRec.get('InfPyValues');
			var arrInfPyValues = strInfPyValues.split(CHR_1);
			if (arrInfPyValues.length > 0) {
				var strInfPyValue = arrInfPyValues[0];
				var arrInfPyValue = strInfPyValue.split("`");
				if (arrInfPyValue.length >= 2) {
					Common_SetValue('VAP_cboInfPy',arrInfPyValue[0],arrInfPyValue[1]);
				}
			} else {
				Common_SetValue('VAP_cboInfPy','','');
			}
			var objItem1 = Ext.getCmp("VAP_txtInfDate");
			if (objItem1) {
				objItem1.setDisabled((objRec.get('IsInfection')!='��'));
			}
			var objItem1 = Ext.getCmp("VAP_cboInfPy");
			if (objItem1) {
				objItem1.setDisabled((objRec.get('IsInfection')!='��'));
			}
		} else {
			obj.VAP_valSubID = '';
			Common_SetValue('VAP_txtIntubateDateTime','');
			Common_SetValue('VAP_txtExtubateDateTime','');
			Common_SetValue('VAP_cboIntubatePlace','','');
			Common_SetValue('VAP_cboIntubateUserType','','');
			Common_SetValue('VAP_cboIntubateUser','','');
			Common_SetValue('VAP_cboIntubateType','','');
			Common_SetValue('VAP_chkIsInf','');
			Common_SetValue('VAP_txtInfDate','');
			Common_SetValue('VAP_cboInfPy','','');
			var objItem1 = Ext.getCmp("VAP_txtInfDate");
			if (objItem1) {
				objItem1.setDisabled(true);
			}
			var objItem1 = Ext.getCmp("VAP_cboInfPy");
			if (objItem1) {
				objItem1.setDisabled(true);
			}
		}
	}
	
	obj.VAP_GridRowEditer = function(objRec)
	{
		var winGridRowEditer = Ext.getCmp('VAP_GridRowEditer');
		if (!winGridRowEditer)
		{
			winGridRowEditer = new Ext.Window({
				id : 'VAP_GridRowEditer',
				height : 400,
				closeAction: 'hide',
				width : 600,
				modal : true,
				title : '������-�༭',
				layout : 'border',
				frame : true,
				items: [
					obj.gridAntibioticsVAP
					,obj.VAP_GridRowViewPort
				],
				bbar : [
					'->',
					new Ext.Toolbar.Button({
						id: "VAP_GridRowEditer_btnUpdate",
						width : 80,
						text : "<img SRC='../scripts/dhcmed/img/update.gif'>����",
						listeners : {
							'click' : function(){
								var errInfo = obj.VAP_GridRowDataCheck("1");
								if (errInfo)
								{
									ExtTool.alert("��ʾ",errInfo);
								} else {	
									var flg = obj.VAP_GridRowDataSave("1")
									if (flg)
									{
										winGridRowEditer.hide();
										var objGrid = Ext.getCmp('VAP_gridVAP');
										if (objGrid) {
											objGrid.getStore().load();
										}
									} else {
										ExtTool.alert("��ʾ","�������ݴ���!Error=" + flg);
									}
								}
							}
						}
					}),
					new Ext.Toolbar.Button({
						id: "VAP_GridRowEditer_btnCommit",
						width : 80,
						text : "<img SRC='../scripts/dhcmed/img/update.png'>�ύ",
						listeners : {
							'click' : function(){
								var errInfo = obj.VAP_GridRowDataCheck("2");
								if (errInfo) {
									ExtTool.alert("��ʾ",errInfo);
								} else {
									var flg = obj.VAP_GridRowDataSave("2")
									if (flg) {
										winGridRowEditer.hide();
										var objGrid = Ext.getCmp('VAP_gridVAP');
										if (objGrid) {
											objGrid.getStore().load();
										}
									} else {
										ExtTool.alert("��ʾ","�ύ���ݴ���!Error=" + flg);
									}
								}
							}
						}
					}),
					new Ext.Toolbar.Button({
						id: "VAP_GridRowEditer_btnCancel",
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
		obj.VAP_GridRowDataSet(objRec);
	}
	
	//���������
	obj.VAP_GridToVAP = function()
	{
		var tmpGridPanel = new Ext.grid.GridPanel({
			id: arguments[0],
			store : new Ext.data.Store({
				proxy: new Ext.data.HttpProxy({
					url : ExtToolSetting.RunQueryPageURL,
					listeners : {
						'beforeload' :  function(objProxy, param){
							param.ClassName = 'DHCMed.NINFService.Rep.AimReportVAP';
							param.QueryName = 'QryReportByID';
							param.Arg1      = obj.CurrReport.ChildVAP.RowID;
							param.ArgCnt    = 1;
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
						,{name: 'IntubateTypeID', mapping: 'IntubateTypeID'}
						,{name: 'IntubateTypeDesc', mapping: 'IntubateTypeDesc'}
						,{name: 'IsInfection', mapping: 'IsInfection'}
						,{name: 'InfDate', mapping: 'InfDate'}
						,{name: 'InfPyIDs', mapping: 'InfPyIDs'}
						,{name: 'InfPyDescs', mapping: 'InfPyDescs'}
						,{name: 'InfPyValues', mapping: 'InfPyValues'}
						,{name: 'RepLocID', mapping: 'RepLocID'}
						,{name: 'RepLocDesc', mapping: 'RepLocDesc'}
						,{name: 'RepUserID', mapping: 'RepUserID'}
						,{name: 'RepUserDesc', mapping: 'RepUserDesc'}
						,{name: 'RepDate', mapping: 'RepDate'}
						,{name: 'RepTime', mapping: 'RepTime'}
						,{name: 'RepDateTime', mapping: 'RepDateTime'}
						,{name: 'RepStatusID', mapping: 'RepStatusID'}
						,{name: 'RepStatusDesc', mapping: 'RepStatusDesc'}
					]
				)
			})
			,height : 120
			//,overflow:'scroll'
			//,overflow-y:hidden
			//,style:'overflow:auto;overflow-y:hidden'
			//,loadMask : true
			//,frame : true
			,anchor : '100%'
			,columns: [
				{header: '����<br>״̬', width: 50, dataIndex: 'RepStatusDesc', sortable: false, menuDisabled:true, align:'center' }
				,{header: '�ϻ�ʱ��', width: 100, dataIndex: 'IntubateDateTime', sortable: false, menuDisabled:true, align:'center' }
				,{header: '�ѻ�ʱ��', width: 100, dataIndex: 'ExtubateDateTime', sortable: false, menuDisabled:true, align:'center' }
				,{header: '�ùܵص�', width: 60, dataIndex: 'IntubatePlaceDesc', sortable: false, menuDisabled:true, align:'center' }
				,{header: '�ù�����', width: 60, dataIndex: 'IntubateTypeDesc', sortable: false, menuDisabled:true, align:'center' }
				,{header: '�ù���Ա', width: 80, dataIndex: 'IntubateUserTypeDesc', sortable: false, menuDisabled:true, align:'center' }
				,{header: '�Ƿ�<br>��Ⱦ', width: 50, dataIndex: 'IsInfection', sortable: false, menuDisabled:true, align:'center' }
				,{header: '��Ⱦ����', width: 80, dataIndex: 'InfDate', sortable: false, menuDisabled:true, align:'center' }
				,{header: '��ԭ��', width: 100, dataIndex: 'InfPyDescs', sortable: false, menuDisabled:true, align:'center' }
				,{header: '�ʱ��', width: 100, dataIndex: 'RepDateTime', sortable: false, menuDisabled:true, align:'center' }
				,{header: '�����', width: 100, dataIndex: 'RepLocDesc', sortable: false, menuDisabled:true, align:'center' }
				,{header: '���', width: 60, dataIndex: 'RepUserDesc', sortable: false, menuDisabled:true, align:'center' }
			],
			bbar : [
				new Ext.Toolbar.Button({
					id: arguments[0] + "_btnAdd",
					width : 80,
					text : "<img SRC='../scripts/dhcmed/img/add.png'>����",
					listeners : {
						'click' : function(){
							obj.VAP_GridRowEditer("");
						}
					}
				}),
				new Ext.Toolbar.Button({
					id: arguments[0] + "_btnDelete",
					width : 80,
					text : "<img SRC='../scripts/dhcmed/img/delete.gif'>ɾ��",
					listeners : {
						'click' : function(){
							var objGrid = Ext.getCmp("VAP_gridVAP");
							if (objGrid){
								var objRecArr = objGrid.getSelectionModel().getSelections();
								if (objRecArr.length>0){
									Ext.MessageBox.confirm('ɾ��', '�Ƿ�ɾ��ѡ�����ݼ�¼?', function(btn,text){
										if(btn=="yes"){
											for (var indRec = 0; indRec < objRecArr.length; indRec++){
												var objRec = objRecArr[indRec];
												var flg = obj.VAP_GridRowDataUpdateStatus('0',objRec);
											}
											objGrid.getStore().load({});
										}
									});
								} else {
									ExtTool.alert("��ʾ","��ѡ�����ݼ�¼,�ٵ��ɾ��!");
								}
							}
						}
					}
				}),
				new Ext.Toolbar.Button({
					id: arguments[0] + "_btnCommit",
					width : 80,
					text : "<img SRC='../scripts/dhcmed/img/update.png'>�ύ",
					listeners : {
						'click' : function(){
							var objGrid = Ext.getCmp("VAP_gridVAP");
							if (objGrid){
								var objRecArr = objGrid.getSelectionModel().getSelections();
								if (objRecArr.length>0){
									for (var indRec = 0; indRec < objRecArr.length; indRec++){
										var objRec = objRecArr[indRec];
										var flg = obj.VAP_GridRowDataCheck('2',objRec);
										if (flg) {
											ExtTool.alert("��ʾ","������Ϣ������,�������ύ!" + flg);
											continue;
										}
										var flg = obj.VAP_GridRowDataUpdateStatus('2',objRec);
									}
									objGrid.getStore().load({});
								} else {
									ExtTool.alert("��ʾ","��ѡ�����ݼ�¼,�ٵ���ύ!");
								}
							}
						}
					}
				}),
				'->',
				'��'
				/*
				new Ext.Toolbar.Button({
					id: arguments[0] + "_btnUpdate",
					width : 80,
					text : "<img SRC='../scripts/dhcmed/img/update.gif'>��ȡ����"
				})
				*/
			],
			viewConfig : {
				//forceFit : true
			}
		});
		
		return tmpGridPanel;
	}
	
	//���������
	obj.VAP_gridVAP = obj.VAP_GridToVAP("VAP_gridVAP");
	
	obj.VAP_txtRegNo = Common_TextField("VAP_txtRegNo","�ǼǺ�");
	obj.VAP_txtPatName = Common_TextField("VAP_txtPatName","����");
	obj.VAP_txtPatSex = Common_TextField("VAP_txtPatSex","�Ա�");
	obj.VAP_txtPatAge = Common_TextField("VAP_txtPatAge","����");
	
	obj.VAP_txtAdmDate = Common_TextField("VAP_txtAdmDate","��Ժ����");
	obj.VAP_txtAdmLoc = Common_TextField("VAP_txtAdmLoc","��ǰ����");
	obj.VAP_txtAdmWard = Common_TextField("VAP_txtAdmWard","��ǰ����");
	obj.VAP_txtAdmBed = Common_TextField("VAP_txtAdmBed","����");
	
	obj.VAP_txtTransLoc = Common_TextField("VAP_txtTransLoc","ת�����");
	obj.VAP_txtTransInDate = Common_TextField("VAP_txtTransInDate","�������");
	obj.VAP_txtTransOutDate = Common_TextField("VAP_txtTransOutDate","��������");
	obj.VAP_txtTransFormLoc = Common_TextField("VAP_txtTransFormLoc","�����Դ");
	obj.VAP_txtTransToLoc = Common_TextField("VAP_txtTransToLoc","����ȥ��");
	
	obj.VAP_txtRegNo.setDisabled(true);
	obj.VAP_txtPatName.setDisabled(true);
	obj.VAP_txtPatSex.setDisabled(true);
	obj.VAP_txtPatAge.setDisabled(true);
	
	obj.VAP_txtAdmDate.setDisabled(true);
	obj.VAP_txtAdmLoc.setDisabled(true);
	obj.VAP_txtAdmWard.setDisabled(true);
	obj.VAP_txtAdmBed.setDisabled(true);
	
	obj.VAP_txtTransLoc.setDisabled(true);
	obj.VAP_txtTransInDate.setDisabled(true);
	obj.VAP_txtTransOutDate.setDisabled(true);
	obj.VAP_txtTransFormLoc.setDisabled(true);
	obj.VAP_txtTransToLoc.setDisabled(true);
	
	//������Ϣ
	obj.VAP_FormToPAT = function()
	{
		var tmpFormPanel = {
			layout : 'form',
			autoScroll : true,
			bodyStyle : 'overflow-x:hidden;',
			items : [
				{
					layout : 'column',
					items : [
						{
							columnWidth:.25,
							layout : 'form',
							labelAlign : 'right',
							labelWidth : 60,
							items : [obj.VAP_txtRegNo]
						},{
							columnWidth:.25,
							layout : 'form',
							labelAlign : 'right',
							labelWidth : 60,
							items : [obj.VAP_txtPatName]
						},{
							columnWidth:.25,
							layout : 'form',
							labelAlign : 'right',
							labelWidth : 60,
							items : [obj.VAP_txtPatSex]
						},{
							columnWidth:.25,
							layout : 'form',
							labelAlign : 'right',
							labelWidth : 60,
							items : [obj.VAP_txtPatAge]
						}
					]
				},
				{
					layout : 'column',
					items : [
						{
							columnWidth:.25,
							layout : 'form',
							labelAlign : 'right',
							labelWidth : 60,
							items : [obj.VAP_txtAdmDate]
						},{
							columnWidth:.25,
							layout : 'form',
							labelAlign : 'right',
							labelWidth : 60,
							items : [obj.VAP_txtAdmLoc]
						},{
							columnWidth:.25,
							layout : 'form',
							labelAlign : 'right',
							labelWidth : 60,
							items : [obj.VAP_txtAdmWard]
						},{
							columnWidth:.25,
							layout : 'form',
							labelAlign : 'right',
							labelWidth : 60,
							items : [obj.VAP_txtAdmBed]
						}
					]
				},
				{
					layout : 'column',
					items : [
						{
							columnWidth:.25,
							layout : 'form',
							labelAlign : 'right',
							labelWidth : 60,
							items : [obj.VAP_txtTransLoc]
						},{
							columnWidth:.25,
							layout : 'form',
							labelAlign : 'right',
							labelWidth : 60,
							items : [obj.VAP_txtTransInDate]
						},{
							columnWidth:.25,
							layout : 'form',
							labelAlign : 'right',
							labelWidth : 60,
							items : [obj.VAP_txtTransOutDate]
						},{
							columnWidth:.25,
							layout : 'form',
							labelAlign : 'right',
							labelWidth : 60,
							items : [obj.VAP_txtTransToLoc]
						}
					]
				}
			]
		}
		
		return tmpFormPanel;
	}
	
	//������Ϣ
	obj.VAP_formPAT = obj.VAP_FormToPAT("VAP_formPAT");
	
	//��ʼ��ҳ��
	obj.VAP_FormPatDataSet = function()
	{
		var objPaadm = obj.ClsBasePatientAdm.GetObjById(obj.CurrReport.ChildVAP.EpisodeID);
		if (objPaadm) {
			var PatientID = objPaadm.PatientID;
			var objPatient = obj.ClsBasePatient.GetObjById(PatientID);
			if (objPatient) {
				Common_SetValue('VAP_txtRegNo',objPatient.PapmiNo);
				Common_SetValue('VAP_txtPatName',objPatient.PatientName);
				Common_SetValue('VAP_txtPatSex',objPatient.Sex);
				var Age = objPatient.Age;
				var Month = objPatient.AgeMonth;
				var Day = objPatient.AgeDay;
				if (!Age) Age=0;
				if (!Month) Month=0;
				if (!Day) Day=0;
				if (parseInt(Age) > 0) {
					Common_SetValue('VAP_txtPatAge',parseInt(Age) + '��');
				} else {
					Common_SetValue('VAP_txtPatAge',parseInt(Month) + '��' + parseInt(Day) + '��');
				}
			}
			Common_SetValue('VAP_txtAdmDate',objPaadm.AdmitDate + ' ' + objPaadm.AdmitTime);
			Common_SetValue('VAP_txtAdmLoc',objPaadm.Department);
			Common_SetValue('VAP_txtAdmWard',objPaadm.Ward);
			Common_SetValue('VAP_txtAdmBed',objPaadm.Bed + "��");
		}
		
		var strTransLoc = obj.ClsCommonClsSrv.GetAdmTrans(obj.CurrReport.ChildVAP.TransID,obj.CurrReport.ChildVAP.TransLoc);
		var arrTransLoc = strTransLoc.split(CHR_1);
		if (arrTransLoc.length>=10)
		{
			Common_SetValue('VAP_txtTransInDate',arrTransLoc[6] + ' ' + arrTransLoc[7]);
			Common_SetValue('VAP_txtTransOutDate',arrTransLoc[8] + ' ' + arrTransLoc[9]);
			Common_SetValue('VAP_txtTransLoc',arrTransLoc[1]);
			Common_SetValue('VAP_txtTransFormLoc',arrTransLoc[3]);
			Common_SetValue('VAP_txtTransToLoc',arrTransLoc[5]);
		}
	}
	
	obj.VAP_ViewPort = {
		layout : 'border',
		title : '������',
		items : [
			{
				layout : 'fit',
				region : 'north',
				height : 100,
				frame : true,
				items : [obj.VAP_formPAT]
			},{
				layout : 'fit',
				region: 'center',
				frame : true,
				items : [obj.VAP_gridVAP]
			}
		]
	}
	
	obj.VAP_InitView = function(){
		var objGrid = Ext.getCmp("VAP_gridVAP");
		if (objGrid){
			objGrid.getStore().load({});
			objGrid.on('rowdblclick',function(){
				var rowIndex = arguments[1];
				var objRec = this.getStore().getAt(rowIndex);
				obj.VAP_GridRowEditer(objRec);
			},objGrid);
		}
		obj.VAP_FormPatDataSet();
	}
	
	return obj;
}