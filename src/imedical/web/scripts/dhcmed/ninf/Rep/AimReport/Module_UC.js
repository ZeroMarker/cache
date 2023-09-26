
function InitUC(obj)
{
	obj.UC_valSubID = '';

	obj.gridAntibioticsStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.gridAntibioticsStore = new Ext.data.Store({
		proxy: obj.gridAntibioticsStoreProxy,
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
	obj.gridAntibiotics = new Ext.grid.EditorGridPanel({
		id : 'gridAntibiotics'
		,store : obj.gridAntibioticsStore
		,selModel : new Ext.grid.RowSelectionModel({singleSelect : true})
		,clicksToEdit : 1
		,columnLines : true
    ,stripeRows : true
    ,height : 150
		,region : 'center'
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
								
								var selectObj = obj.gridAntibiotics.getSelectionModel().getSelected();
								if (selectObj){
								
								obj.UC_txtIntubateDateTime.setValue(selectObj.get("StartDate")+" "+ selectObj.get("StartTime"));
								obj.UC_txtExtubateDateTime.setValue(selectObj.get("EndDate")+" "+ selectObj.get("EndTime"));
							}
						}
					}
    });
    
  
	obj.gridAntibioticsStoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'DHCMed.NINFService.Rep.AimReport';
		param.QueryName = 'QueryOEInfo';
		param.Arg1 = obj.CurrReport.ChildUC.EpisodeID;
		param.Arg2 = 'UC';
		param.ArgCnt = 2;
	});
	
	
	obj.gridAntibioticsStore.load({});
	//�ù�ʱ��
	obj.UC_txtIntubateDateTime = Common_DateFieldToDateTime("UC_txtIntubateDateTime","�ù�ʱ��");
	
	//�ι�ʱ��
	obj.UC_txtExtubateDateTime = Common_DateFieldToDateTime("UC_txtExtubateDateTime","�ι�ʱ��");
	
	//�������
	obj.UC_cboUrineBagType = Common_ComboToDic("UC_cboUrineBagType","�������","NINFAimUCUrineBagType");
	
	//�ù���Ա����
	obj.UC_cboIntubateUserType = Common_ComboToDic("UC_cboIntubateUserType","�ù���Ա","NINFAimUCIntubateUserType");
	
	//�ù���Ա
	obj.UC_cboIntubateUser = Common_ComboToSSUser("UC_cboIntubateUser","�ù���Ա");
	
	//�Ƿ��Ⱦ
	obj.UC_chkIsInf = Common_Checkbox("UC_chkIsInf","�Ƿ��Ⱦ");
	obj.UC_chkIsInf.on('check',function(checkbox,value){
		var objItem1 = Ext.getCmp("UC_txtInfDate");
		if (objItem1) {
			objItem1.setDisabled((!value));
		}
		var objItem1 = Ext.getCmp("UC_cboInfPy");
		if (objItem1) {
			objItem1.setDisabled((!value));
		}
		if (!value) {
			Common_SetValue('UC_txtInfDate','');
			Common_SetValue('UC_cboInfPy','','');
		}
	},obj.UC_chkIsInf);
	
	//��Ⱦ����
	obj.UC_txtInfDate = Common_DateFieldToDate("UC_txtInfDate","��Ⱦ����");
	
	//��ԭ��
	obj.UC_cboInfPy = Common_ComboToPathogeny("UC_cboInfPy","��ԭ��");
	
	obj.UC_GridRowViewPort = {
		layout : 'form',
		labelAlign : 'right',
		labelWidth : 60,
		frame : true,
		items : [
			obj.gridAntibiotics
			,obj.UC_txtIntubateDateTime
			,obj.UC_txtExtubateDateTime
			,obj.UC_cboUrineBagType
			,obj.UC_cboIntubateUserType
			//,obj.UC_cboIntubateUser
			,obj.UC_chkIsInf
			,obj.UC_txtInfDate
			,obj.UC_cboInfPy
		]
	}
	
	obj.UC_GridRowDataCheck = function()
	{
		var errInfo = '';
		
		var StatusCode = arguments[0];
		var objRec = arguments[1];
		if (objRec)
		{
			if (StatusCode == '2') {
				var UC_txtIntubateDateTime = objRec.get('IntubateDateTime');
				if (UC_txtIntubateDateTime=='') {
					errInfo = errInfo + '�ù�ʱ��δ��!';
				}
				var UC_cboUrineBagType = objRec.get('UrineBagTypeDesc');
				if (UC_cboUrineBagType=='') {
					errInfo = errInfo + '�������δ��!';
				}
				var UC_cboIntubateUserType = objRec.get('IntubateUserTypeDesc');
				if (UC_cboIntubateUserType=='') {
					errInfo = errInfo + '�ù���Աδ��!';
				}
				var UC_cboIntubateUser = objRec.get('IntubateUserDesc');
				if (UC_cboIntubateUser=='') {
					//errInfo = errInfo + '�ù���Աδ��!';
				}
				var UC_txtExtubateDateTime = objRec.get('ExtubateDateTime');
				if (UC_txtExtubateDateTime=='') {
					errInfo = errInfo + '�ι�ʱ��δ��!';
				}
			}
		} else {
			if (StatusCode == '1') {
				var UC_txtIntubateDateTime = Common_GetValue('UC_txtIntubateDateTime');
				if (UC_txtIntubateDateTime=='') {
					errInfo = errInfo + '�ù�ʱ��δ��!';
				}
			}
			if (StatusCode == '2') {
				var UC_txtIntubateDateTime = Common_GetValue('UC_txtIntubateDateTime');
				if (UC_txtIntubateDateTime=='') {
					errInfo = errInfo + '�ù�ʱ��δ��!';
				}
				var UC_cboUrineBagType = Common_GetValue('UC_cboUrineBagType');
				if (UC_cboUrineBagType=='') {
					errInfo = errInfo + '�������δ��!';
				}
				var UC_cboIntubateUserType = Common_GetValue('UC_cboIntubateUserType');
				if (UC_cboIntubateUserType=='') {
					errInfo = errInfo + '�ù���Աδ��!';
				}
				var UC_cboIntubateUser = Common_GetValue('UC_cboIntubateUser');
				if (UC_cboIntubateUser=='') {
					//errInfo = errInfo + '�ù���Աδ��!';
				}
				var UC_txtExtubateDateTime = Common_GetValue('UC_txtExtubateDateTime');
				if (UC_txtExtubateDateTime=='') {
					errInfo = errInfo + '�ι�ʱ��δ��!';
				}
			}
		}
		
		return errInfo;
	}
	
	obj.UC_GridRowDataUpdateStatus = function()
	{
		var StatusCode = arguments[0];
		var objRec = arguments[1];
		if (objRec) {
			var inputStr = objRec.get('RepID') + "||" + objRec.get('SubID');
		} else {
			var inputStr = obj.CurrReport.ChildUC.RowID + "||" + obj.UC_valSubID;
		}
		inputStr = inputStr + CHR_1 + session['LOGON.CTLOCID'];
		inputStr = inputStr + CHR_1 + session['LOGON.USERID'];
		inputStr = inputStr + CHR_1 + StatusCode;
		
		var flg = obj.ClsAimReportUCSrv.UpdateStatus(inputStr, CHR_1);
		if (parseInt(flg) <= 0) {
			return false;
		} else {
			return true;
		}
		return true;
	}
	
	obj.UC_GridRowDataSave = function()
	{
		if (obj.CurrReport.ChildUC.RowID == "")
		{
			var inputStr = "";
			inputStr = inputStr + CHR_1 + obj.CurrReport.ChildUC.ReportTypeCode;
			inputStr = inputStr + CHR_1 + obj.CurrReport.ChildUC.EpisodeID;
			inputStr = inputStr + CHR_1 + obj.CurrReport.ChildUC.TransID;
			inputStr = inputStr + CHR_1 + obj.CurrReport.ChildUC.TransLoc;
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
				obj.CurrReport.ChildUC = objAimReport;
			}
		}
		if (obj.CurrReport.ChildUC.RowID=='') return false;
		
		var StatusCode = arguments[0];
		
		var inputStr = obj.CurrReport.ChildUC.RowID;
		inputStr = inputStr + CHR_1 + obj.UC_valSubID;
		inputStr = inputStr + CHR_1 + Common_GetValue('UC_txtIntubateDateTime');
		inputStr = inputStr + CHR_1 + Common_GetValue('UC_txtExtubateDateTime');
		inputStr = inputStr + CHR_1 + Common_GetValue('UC_cboUrineBagType');
		inputStr = inputStr + CHR_1 + Common_GetValue('UC_cboIntubateUserType');
		inputStr = inputStr + CHR_1 + Common_GetValue('UC_cboIntubateUser');
		inputStr = inputStr + CHR_1 + Common_GetValue('UC_txtInfDate');
		inputStr = inputStr + CHR_1 + Common_GetValue('UC_cboInfPy') + CHR_3 + Common_GetText('UC_cboInfPy');
		inputStr = inputStr + CHR_1 + session['LOGON.CTLOCID'];
		inputStr = inputStr + CHR_1 + session['LOGON.USERID'];
		inputStr = inputStr + CHR_1 + StatusCode;
		
		var flg = obj.ClsAimReportUCSrv.SaveReport(inputStr, CHR_1);
		if (parseInt(flg)<=0) {
			return false;
		} else {
			return true;
		}
		return true;
	}
	
	obj.UC_GridRowDataSet = function(objRec)
	{
		if (objRec)
		{
			obj.UC_valSubID = objRec.get('SubID');
			Common_SetValue('UC_txtIntubateDateTime',objRec.get('IntubateDateTime'));
			Common_SetValue('UC_txtExtubateDateTime',objRec.get('ExtubateDateTime'));
			Common_SetValue('UC_cboUrineBagType',objRec.get('UrineBagTypeID'),objRec.get('UrineBagTypeDesc'));
			Common_SetValue('UC_cboIntubateUserType',objRec.get('IntubateUserTypeID'),objRec.get('IntubateUserTypeDesc'));
			Common_SetValue('UC_cboIntubateUser',objRec.get('IntubateUserID'),objRec.get('IntubateUserDesc'));
			
			//�Ƿ��Ⱦ,��Ⱦ����,��ԭ��
			Common_SetValue('UC_chkIsInf',(objRec.get('IsInfection')=='��'));
			Common_SetValue('UC_txtInfDate',objRec.get('InfDate'));
			var strInfPyValues = objRec.get('InfPyValues');
			var arrInfPyValues = strInfPyValues.split(CHR_1);
			if (arrInfPyValues.length > 0) {
				var strInfPyValue = arrInfPyValues[0];
				var arrInfPyValue = strInfPyValue.split("`");
				if (arrInfPyValue.length >= 2) {
					Common_SetValue('UC_cboInfPy',arrInfPyValue[0],arrInfPyValue[1]);
				}
			} else {
				Common_SetValue('UC_cboInfPy','','');
			}
			var objItem1 = Ext.getCmp("UC_txtInfDate");
			if (objItem1) {
				objItem1.setDisabled((objRec.get('IsInfection')!='��'));
			}
			var objItem1 = Ext.getCmp("UC_cboInfPy");
			if (objItem1) {
				objItem1.setDisabled((objRec.get('IsInfection')!='��'));
			}
		} else {
			obj.UC_valSubID = '';
			Common_SetValue('UC_txtIntubateDateTime','');
			Common_SetValue('UC_txtExtubateDateTime','');
			Common_SetValue('UC_cboUrineBagType','','');
			Common_SetValue('UC_cboIntubateUserType','','');
			Common_SetValue('UC_cboIntubateUser','','');
			Common_SetValue('UC_chkIsInf','');
			Common_SetValue('UC_txtInfDate','');
			Common_SetValue('UC_cboInfPy','','');
			var objItem1 = Ext.getCmp("UC_txtInfDate");
			if (objItem1) {
				objItem1.setDisabled(true);
			}
			var objItem1 = Ext.getCmp("UC_cboInfPy");
			if (objItem1) {
				objItem1.setDisabled(true);
			}
		}
	}
	
	obj.UC_GridRowEditer = function(objRec)
	{
		var winGridRowEditer = Ext.getCmp('UC_GridRowEditer');
		if (!winGridRowEditer)
		{
			winGridRowEditer = new Ext.Window({
				id : 'UC_GridRowEditer',
				height : 450,
				closeAction: 'hide',
				width : 600,
				modal : true,
				title : '�����-�༭',
				layout : 'fit',
				frame : true,
				items: [
					obj.UC_GridRowViewPort
				],
				bbar : [
					'->',
					new Ext.Toolbar.Button({
						id: "UC_GridRowEditer_btnUpdate",
						width : 80,
						text : "<img SRC='../scripts/dhcmed/img/update.gif'>����",
						listeners : {
							'click' : function(){
								var errInfo = obj.UC_GridRowDataCheck("1");
								if (errInfo) {
									ExtTool.alert("��ʾ",errInfo);
								} else {
									var flg = obj.UC_GridRowDataSave("1")
									if (flg) {
										winGridRowEditer.hide();
										var objGrid = Ext.getCmp('UC_gridUC');
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
						id: "UC_GridRowEditer_btnCommit",
						width : 80,
						text : "<img SRC='../scripts/dhcmed/img/update.png'>�ύ",
						listeners : {
							'click' : function(){
								var errInfo = obj.UC_GridRowDataCheck("2");
								if (errInfo) {
									ExtTool.alert("��ʾ",errInfo);
								} else {
									var flg = obj.UC_GridRowDataSave("2")
									if (flg) {
										winGridRowEditer.hide();
										var objGrid = Ext.getCmp('UC_gridUC');
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
						id: "UC_GridRowEditer_btnCancel",
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
		obj.UC_GridRowDataSet(objRec);
	}
	
	//��������
	obj.UC_GridToUC = function()
	{
		var tmpGridPanel = new Ext.grid.GridPanel({
			id: arguments[0],
			store : new Ext.data.Store({
				proxy: new Ext.data.HttpProxy({
					url : ExtToolSetting.RunQueryPageURL,
					listeners : {
						'beforeload' :  function(objProxy, param){
							param.ClassName = 'DHCMed.NINFService.Rep.AimReportUC';
							param.QueryName = 'QryReportByID';
							param.Arg1      = obj.CurrReport.ChildUC.RowID;
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
						,{name: 'UrineBagTypeID', mapping: 'UrineBagTypeID'}
						,{name: 'UrineBagTypeDesc', mapping: 'UrineBagTypeDesc'}
						,{name: 'IntubateUserTypeID', mapping: 'IntubateUserTypeID'}
						,{name: 'IntubateUserTypeDesc', mapping: 'IntubateUserTypeDesc'}
						,{name: 'IntubateUserID', mapping: 'IntubateUserID'}
						,{name: 'IntubateUserDesc', mapping: 'IntubateUserDesc'}
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
				,{header: '�ù�ʱ��', width: 100, dataIndex: 'IntubateDateTime', sortable: false, menuDisabled:true, align:'center' }
				,{header: '�ι�ʱ��', width: 100, dataIndex: 'ExtubateDateTime', sortable: false, menuDisabled:true, align:'center' }
				,{header: '�������', width: 60, dataIndex: 'UrineBagTypeDesc', sortable: false, menuDisabled:true, align:'center' }
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
							obj.UC_GridRowEditer("");
						}
					}
				}),
				new Ext.Toolbar.Button({
					id: arguments[0] + "_btnDelete",
					width : 80,
					text : "<img SRC='../scripts/dhcmed/img/delete.gif'>ɾ��",
					listeners : {
						'click' : function(){
							var objGrid = Ext.getCmp("UC_gridUC");
							if (objGrid){
								var objRecArr = objGrid.getSelectionModel().getSelections();
								if (objRecArr.length>0){
									Ext.MessageBox.confirm('ɾ��', '�Ƿ�ɾ��ѡ�����ݼ�¼?', function(btn,text){
										if(btn=="yes"){
											for (var indRec = 0; indRec < objRecArr.length; indRec++){
												var objRec = objRecArr[indRec];
												var flg = obj.UC_GridRowDataUpdateStatus('0',objRec);
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
							var objGrid = Ext.getCmp("UC_gridUC");
							if (objGrid){
								var objRecArr = objGrid.getSelectionModel().getSelections();
								if (objRecArr.length>0){
									for (var indRec = 0; indRec < objRecArr.length; indRec++){
										var objRec = objRecArr[indRec];
										var flg = obj.UC_GridRowDataCheck('2',objRec);
										if (flg) {
											ExtTool.alert("��ʾ","������Ϣ������,�������ύ!" + flg);
											continue;
										}
										var flg = obj.UC_GridRowDataUpdateStatus('2',objRec);
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
	
	//��������
	obj.UC_gridUC = obj.UC_GridToUC("UC_gridUC");
	
	obj.UC_txtRegNo = Common_TextField("UC_txtRegNo","�ǼǺ�");
	obj.UC_txtPatName = Common_TextField("UC_txtPatName","����");
	obj.UC_txtPatSex = Common_TextField("UC_txtPatSex","�Ա�");
	obj.UC_txtPatAge = Common_TextField("UC_txtPatAge","����");
	
	obj.UC_txtAdmDate = Common_TextField("UC_txtAdmDate","��Ժ����");
	obj.UC_txtAdmLoc = Common_TextField("UC_txtAdmLoc","��ǰ����");
	obj.UC_txtAdmWard = Common_TextField("UC_txtAdmWard","��ǰ����");
	obj.UC_txtAdmBed = Common_TextField("UC_txtAdmBed","����");
	
	obj.UC_txtTransLoc = Common_TextField("UC_txtTransLoc","ת�����");
	obj.UC_txtTransInDate = Common_TextField("UC_txtTransInDate","�������");
	obj.UC_txtTransOutDate = Common_TextField("UC_txtTransOutDate","��������");
	obj.UC_txtTransFormLoc = Common_TextField("UC_txtTransFormLoc","�����Դ");
	obj.UC_txtTransToLoc = Common_TextField("UC_txtTransToLoc","����ȥ��");
	
	obj.UC_txtRegNo.setDisabled(true);
	obj.UC_txtPatName.setDisabled(true);
	obj.UC_txtPatSex.setDisabled(true);
	obj.UC_txtPatAge.setDisabled(true);
	
	obj.UC_txtAdmDate.setDisabled(true);
	obj.UC_txtAdmLoc.setDisabled(true);
	obj.UC_txtAdmWard.setDisabled(true);
	obj.UC_txtAdmBed.setDisabled(true);
	
	obj.UC_txtTransLoc.setDisabled(true);
	obj.UC_txtTransInDate.setDisabled(true);
	obj.UC_txtTransOutDate.setDisabled(true);
	obj.UC_txtTransFormLoc.setDisabled(true);
	obj.UC_txtTransToLoc.setDisabled(true);
	
	//������Ϣ
	obj.UC_FormToPAT = function()
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
							items : [obj.UC_txtRegNo]
						},{
							columnWidth:.25,
							layout : 'form',
							labelAlign : 'right',
							labelWidth : 60,
							items : [obj.UC_txtPatName]
						},{
							columnWidth:.25,
							layout : 'form',
							labelAlign : 'right',
							labelWidth : 60,
							items : [obj.UC_txtPatSex]
						},{
							columnWidth:.25,
							layout : 'form',
							labelAlign : 'right',
							labelWidth : 60,
							items : [obj.UC_txtPatAge]
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
							items : [obj.UC_txtAdmDate]
						},{
							columnWidth:.25,
							layout : 'form',
							labelAlign : 'right',
							labelWidth : 60,
							items : [obj.UC_txtAdmLoc]
						},{
							columnWidth:.25,
							layout : 'form',
							labelAlign : 'right',
							labelWidth : 60,
							items : [obj.UC_txtAdmWard]
						},{
							columnWidth:.25,
							layout : 'form',
							labelAlign : 'right',
							labelWidth : 60,
							items : [obj.UC_txtAdmBed]
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
							items : [obj.UC_txtTransLoc]
						},{
							columnWidth:.25,
							layout : 'form',
							labelAlign : 'right',
							labelWidth : 60,
							items : [obj.UC_txtTransInDate]
						},{
							columnWidth:.25,
							layout : 'form',
							labelAlign : 'right',
							labelWidth : 60,
							items : [obj.UC_txtTransOutDate]
						},{
							columnWidth:.25,
							layout : 'form',
							labelAlign : 'right',
							labelWidth : 60,
							items : [obj.UC_txtTransToLoc]
						}
					]
				}
			]
		}
		
		return tmpFormPanel;
	}
	
	//������Ϣ
	obj.UC_formPAT = obj.UC_FormToPAT("UC_formPAT");
	
	//��ʼ��ҳ��
	obj.UC_FormPatDataSet = function()
	{
		var objPaadm = obj.ClsBasePatientAdm.GetObjById(obj.CurrReport.ChildUC.EpisodeID);
		if (objPaadm) {
			var PatientID = objPaadm.PatientID;
			var objPatient = obj.ClsBasePatient.GetObjById(PatientID);
			if (objPatient) {
				Common_SetValue('UC_txtRegNo',objPatient.PapmiNo);
				Common_SetValue('UC_txtPatName',objPatient.PatientName);
				Common_SetValue('UC_txtPatSex',objPatient.Sex);
				var Age = objPatient.Age;
				var Month = objPatient.AgeMonth;
				var Day = objPatient.AgeDay;
				if (!Age) Age=0;
				if (!Month) Month=0;
				if (!Day) Day=0;
				if (parseInt(Age) > 0) {
					Common_SetValue('UC_txtPatAge',parseInt(Age) + '��');
				} else {
					Common_SetValue('UC_txtPatAge',parseInt(Month) + '��' + parseInt(Day) + '��');
				}
			}
			Common_SetValue('UC_txtAdmDate',objPaadm.AdmitDate + ' ' + objPaadm.AdmitTime);
			Common_SetValue('UC_txtAdmLoc',objPaadm.Department);
			Common_SetValue('UC_txtAdmWard',objPaadm.Ward);
			Common_SetValue('UC_txtAdmBed',objPaadm.Bed + "��");
		}
		
		var strTransLoc = obj.ClsCommonClsSrv.GetAdmTrans(obj.CurrReport.ChildUC.TransID,obj.CurrReport.ChildUC.TransLoc);
		var arrTransLoc = strTransLoc.split(CHR_1);
		if (arrTransLoc.length>=10)
		{
			Common_SetValue('UC_txtTransInDate',arrTransLoc[6] + ' ' + arrTransLoc[7]);
			Common_SetValue('UC_txtTransOutDate',arrTransLoc[8] + ' ' + arrTransLoc[9]);
			Common_SetValue('UC_txtTransLoc',arrTransLoc[1]);
			Common_SetValue('UC_txtTransFormLoc',arrTransLoc[3]);
			Common_SetValue('UC_txtTransToLoc',arrTransLoc[5]);
		}
	}
	
	obj.UC_ViewPort = {
		layout : 'border',
		title : '�����',
		items : [
			{
				layout : 'fit',
				region : 'north',
				height : 100,
				frame : true,
				items : [obj.UC_formPAT]
			},{
				layout : 'fit',
				region: 'center',
				frame : true,
				items : [obj.UC_gridUC]
			}
		]
	}
	
	obj.UC_InitView = function(){
		var objGrid = Ext.getCmp("UC_gridUC");
		if (objGrid){
			objGrid.getStore().load({});
			objGrid.on('rowdblclick',function(){
				var rowIndex = arguments[1];
				var objRec = this.getStore().getAt(rowIndex);
				obj.UC_GridRowEditer(objRec);
			},objGrid);
		}
		obj.UC_FormPatDataSet();
	}
	
	return obj;
}