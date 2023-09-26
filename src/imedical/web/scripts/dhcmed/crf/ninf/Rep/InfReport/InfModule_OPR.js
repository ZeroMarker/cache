	
function InitOPR(obj)
{
	//����
	obj.OPR_cbgIsOperation = Common_RadioGroupToDic("OPR_cbgIsOperation","����","NINFInfOprBoolean",2);
	
	//������� �༭��
	obj.OPR_gridOpr_RowEditer_objRec = '';
	obj.OPR_gridOpr_RowEditer = function(objRec) {
		obj.OPR_gridOpr_RowEditer_objRec = objRec;
		var winGridRowEditer = Ext.getCmp('OPR_gridOpr_RowEditer');
		if (!winGridRowEditer)
		{
			obj.OPR_gridOpr_RowEditer_cboOperation = Common_ComboToORCOperation("OPR_gridOpr_RowEditer_cboOperation","<span style='color:red'><b>��������</b></span>");
			obj.OPR_gridOpr_RowEditer_txtStartDateTime = Common_DateFieldToDateTime("OPR_gridOpr_RowEditer_txtStartDateTime","<span style='color:red'><b>��ʼʱ��</b></span>");
			obj.OPR_gridOpr_RowEditer_txtEndDateTime = Common_DateFieldToDateTime("OPR_gridOpr_RowEditer_txtEndDateTime","<span style='color:red'><b>����ʱ��</b></span>");
			obj.OPR_gridOpr_RowEditer_cboOperDoc = Common_ComboToSSUser("OPR_gridOpr_RowEditer_cboOperDoc","<span style='color:red'><b>����ҽ��</b></span>");
			obj.OPR_gridOpr_RowEditer_cboOperationType = Common_ComboToDic("OPR_gridOpr_RowEditer_cboOperationType","<span style='color:red'><b>��������</b></span>","NINFInfOperationType");
			obj.OPR_gridOpr_RowEditer_cboAnesthesia = Common_ComboToDic("OPR_gridOpr_RowEditer_cboAnesthesia","<span style='color:red'><b>����ʽ</b></span>","NINFInfAnesthesia");
			obj.OPR_gridOpr_RowEditer_cboCuteType = Common_ComboToDic("OPR_gridOpr_RowEditer_cboCuteType","<span style='color:red'><b>�п�����</b></span>","NINFInfCuteType");
			obj.OPR_gridOpr_RowEditer_cboCuteHealing = Common_ComboToDic("OPR_gridOpr_RowEditer_cboCuteHealing","<span style='color:red'><b>�������</b></span>","NINFInfCuteHealing");
			obj.OPR_gridOpr_RowEditer_chkIsCuteInf = Common_Checkbox("OPR_gridOpr_RowEditer_chkIsCuteInf","�пڸ�Ⱦ");
			obj.OPR_gridOpr_RowEditer_chkIsCuteInf.on('check',function(cb,val){
				Common_SetDisabled('OPR_gridOpr_RowEditer_cboOperInfType',(!val));
				Common_SetDisabled('OPR_gridOpr_RowEditer_chkIsInHospInf',(!val));
				Common_SetValue('OPR_gridOpr_RowEditer_cboOperInfType','','');
				Common_SetValue('OPR_gridOpr_RowEditer_chkIsInHospInf',false);
			});
			obj.OPR_gridOpr_RowEditer_cboOperInfType = Common_ComboToDic("OPR_gridOpr_RowEditer_cboOperInfType","��Ⱦ����","NINFInfOperInfType");
			obj.OPR_gridOpr_RowEditer_chkIsInHospInf = Common_Checkbox("OPR_gridOpr_RowEditer_chkIsInHospInf","����Ժ��");
			
			winGridRowEditer = new Ext.Window({
				id : 'OPR_gridOpr_RowEditer',
				height : 270,
				closeAction: 'hide',
				width : 450,
				modal : true,
				title : '�������-�༭',
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
											obj.OPR_gridOpr_RowEditer_cboOperation
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
											obj.OPR_gridOpr_RowEditer_cboOperationType
											,obj.OPR_gridOpr_RowEditer_txtStartDateTime
											,obj.OPR_gridOpr_RowEditer_txtEndDateTime
											,obj.OPR_gridOpr_RowEditer_cboOperDoc
											,obj.OPR_gridOpr_RowEditer_cboAnesthesia
										]
									},{
										columnWidth :.50,
										layout : 'form',
										labelAlign : 'right',
										labelWidth : 60,
										items : [
											obj.OPR_gridOpr_RowEditer_cboCuteType
											,obj.OPR_gridOpr_RowEditer_cboCuteHealing
											,obj.OPR_gridOpr_RowEditer_chkIsCuteInf
											,obj.OPR_gridOpr_RowEditer_cboOperInfType
											,obj.OPR_gridOpr_RowEditer_chkIsInHospInf
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
						id: "OPR_gridOpr_RowEditer_btnUpdate",
						width : 80,
						text : "<img SRC='../scripts/dhcmed/img/update.png'>ȷ��",
						listeners : {
							'click' : function(){
								var OperationID = Common_GetValue('OPR_gridOpr_RowEditer_cboOperation');
								var OperationDesc = Common_GetText('OPR_gridOpr_RowEditer_cboOperation');
								var StartDateTime = Common_GetValue('OPR_gridOpr_RowEditer_txtStartDateTime');
								var arrVal = StartDateTime.split(' ');
								var OperStartDate = (arrVal.length > 0 ? arrVal[0] : '');
								var OperStartTime = (arrVal.length > 1 ? arrVal[1] : '');
								var EndDateTime = Common_GetValue('OPR_gridOpr_RowEditer_txtEndDateTime');
								var arrVal = EndDateTime.split(' ');
								var OperEndDate = (arrVal.length > 0 ? arrVal[0] : '');
								var OperEndTime = (arrVal.length > 1 ? arrVal[1] : '');
								var OperDocID = Common_GetValue('OPR_gridOpr_RowEditer_cboOperDoc');
								var OperDocDesc = Common_GetText('OPR_gridOpr_RowEditer_cboOperDoc');
								var OperationTypeID = Common_GetValue('OPR_gridOpr_RowEditer_cboOperationType');
								var OperationTypeDesc = Common_GetText('OPR_gridOpr_RowEditer_cboOperationType');
								var AnesthesiaID = Common_GetValue('OPR_gridOpr_RowEditer_cboAnesthesia');
								var AnesthesiaDesc = Common_GetText('OPR_gridOpr_RowEditer_cboAnesthesia');
								var CuteTypeID = Common_GetValue('OPR_gridOpr_RowEditer_cboCuteType');
								var CuteTypeDesc = Common_GetText('OPR_gridOpr_RowEditer_cboCuteType');
								var CuteHealingID = Common_GetValue('OPR_gridOpr_RowEditer_cboCuteHealing');
								var CuteHealingDesc = Common_GetText('OPR_gridOpr_RowEditer_cboCuteHealing');
								var CuteInfFlag = Common_GetValue('OPR_gridOpr_RowEditer_chkIsCuteInf');
								CuteInfFlag = (CuteInfFlag ? 'Y' : 'N');
								var objDic = obj.ClsSSDictionary.GetByTypeCode("NINFInfCuteInfFlag",CuteInfFlag,"");
								if (objDic) {
									var CuteInfFlagID = objDic.RowID;
									var CuteInfFlagDesc = objDic.Description;
								} else {
									var CuteInfFlagID = '';
									var CuteInfFlagDesc = '';
								}
								if (CuteInfFlag != 'Y') {
									var OperInfTypeID = '';
									var OperInfTypeDesc = '';
									var InHospInfFlagID = '';
									var InHospInfFlagDesc = '';
								} else {
									var OperInfTypeID = Common_GetValue('OPR_gridOpr_RowEditer_cboOperInfType');
									var OperInfTypeDesc = Common_GetText('OPR_gridOpr_RowEditer_cboOperInfType');
									var InHospInfFlag = Common_GetValue('OPR_gridOpr_RowEditer_chkIsInHospInf');
									InHospInfFlag = (InHospInfFlag ? 'Y' : 'N');
									var objDic = obj.ClsSSDictionary.GetByTypeCode("NINFInfInHospInfFlag",InHospInfFlag,"");
									if (objDic) {
										var InHospInfFlagID = objDic.RowID;
										var InHospInfFlagDesc = objDic.Description;
									} else {
										var InHospInfFlagID = '';
										var InHospInfFlagDesc = '';
									}
								}
								
								var errInfo = '';
								if (OperationDesc == '') {
									errInfo = errInfo + '��������Ϊ��!<br>';
								}
								if (StartDateTime == '') {
									errInfo = errInfo + '��ʼʱ��Ϊ��!<br>';
								}
								if (EndDateTime == '') {
									errInfo = errInfo + '����ʱ��Ϊ��!<br>';
								}
								
								//add by lyh 2013-11-07 ����ʱ���߼�����
								var StartDate=StartDateTime.split(" ")[0];
								var EndDate=EndDateTime.split(" ")[0];
								
								var flg = Common_CompareDate(StartDate,EndDate);
								if (!flg) errInfo = errInfo + '������ʼʱ�������������ʱ��!<br>'
								
								if(StartDateTime==EndDateTime) errInfo = errInfo + '������ʼʱ�����������ʱ�䲻����ȫ��ͬ!<br>'
								
								//add by LiYang 2014-06-25 ��������У��
								var dt1 = new Number(Date.parseDate(StartDateTime, "Y-m-d H:i")); // returns null
								var dt2 = new Number(Date.parseDate(EndDateTime, "Y-m-d H:i")); // returns null
								var ms = dt2 - dt1;
								var days = ms / 1000 / 60 / 60 /24;
								if (days > 2) errInfo = errInfo + '����������ʱ�䡱�롰��ʼʱ�䡱֮��ӦС�ڵ���48Сʱ!<br>'
								
								var disDateTime = Common_GetValue('BASE_txtDisDate');
								var dt3 = new Number(Date.parseDate(disDateTime, "Y-m-d H:i:s"));
								if((dt3 != 0)&&(dt1 > dt3))
									errInfo = errInfo + '��������ʼʱ�䡱֮��ӦС�ڳ�Ժʱ��!<br>';
								if((dt3 != 0)&&(dt2 > dt3))
									errInfo = errInfo + '����������ʱ�䡱֮��ӦС�ڳ�Ժʱ��!<br>';	
								
								var AdmDate = Common_GetValue('BASE_txtAdmDate');
								var dt3 = new Number(Date.parseDate(AdmDate, "Y-m-d H:i:s"));
								if((dt3 != 0)&&(dt1 < dt3))
									errInfo = errInfo + '��������ʼʱ�䡱Ӧ����סԺʱ��!<br>';
								if((dt3 != 0)&&(dt2 < dt3))
									errInfo = errInfo + '����������ʱ�䡱Ӧ����סԺʱ��!<br>';									
								
								
								if ((OperDocID == '')&&(OperDocDesc != '')) {
									errInfo = errInfo + '����ҽ����ʽ����!';
								} else if (OperDocID == '') {
									errInfo = errInfo + '����ҽ��Ϊ��!<br>';
								}
								if ((OperationTypeID == '')||(OperationTypeDesc == '')) {
									errInfo = errInfo + '��������Ϊ��!<br>';
								}
								if ((AnesthesiaID == '')&&(AnesthesiaDesc != '')) {
									errInfo = errInfo + '����ʽ��ʽ����!';
								} else if (AnesthesiaID == '') {
									errInfo = errInfo + '����ʽΪ��!<br>';
								}
								if ((CuteTypeID == '')||(CuteTypeDesc == '')) {
									errInfo = errInfo + '�п�����Ϊ��!<br>';
								}
								if ((CuteHealingID == '')||(CuteHealingDesc == '')) {
									errInfo = errInfo + '�������Ϊ��!<br>';
								}
								if (CuteInfFlag=="Y") {
									var objDic = obj.ClsSSDictionary.GetObjById(CuteInfFlagID);
									if (objDic) {
										if ((objDic.Code == 'Y')&&(OperInfTypeID == '')||(OperInfTypeDesc == '')) {
											errInfo = errInfo + '��Ⱦ����Ϊ��!<br>'
										}
									}
								}
								if (errInfo != '') {
									ExtTool.alert("��ʾ",errInfo);
									return;
								}
								
								var objRec = obj.OPR_gridOpr_RowEditer_objRec;
								var objGrid = Ext.getCmp('OPR_gridOpr');
								if (objGrid) {
									var objStore = objGrid.getStore();
									
									//�ж��Ƿ������ͬ��������,��ͬ��ʼ��������(��ͬһ�첻��������ͬ������)
									var IsBoolean = false;
									for (var ind = 0; ind < objStore.getCount(); ind++) {
										var tmpRec = objStore.getAt(ind);
										if (objRec) {
											if (tmpRec.id == objRec.id) continue;
										}
										if ((OperationDesc == tmpRec.get('OperationDesc'))&&(OperStartDate == tmpRec.get('OperStartDate'))) {
											IsBoolean = true;
										}
									}
									if (IsBoolean) {
										ExtTool.alert("��ʾ","������ͬ��������,��ͬ������������!");
										return;
									}
									
									if (objRec) {      //�ύ����
										objRec.set('OperationID',OperationID);
										objRec.set('OperationDesc',OperationDesc);
										objRec.set('OperDocID',OperDocID);
										objRec.set('OperDocDesc',OperDocDesc);
										objRec.set('OperStartDate',OperStartDate);
										objRec.set('OperStartTime',OperStartTime);
										objRec.set('OperEndDate',OperEndDate);
										objRec.set('OperEndTime',OperEndTime);
										objRec.set('OperationTypeID',OperationTypeID);
										objRec.set('OperationTypeDesc',OperationTypeDesc);
										objRec.set('AnesthesiaID',AnesthesiaID);
										objRec.set('AnesthesiaDesc',AnesthesiaDesc);
										objRec.set('CuteTypeID',CuteTypeID);
										objRec.set('CuteTypeDesc',CuteTypeDesc);
										objRec.set('CuteHealingID',CuteHealingID);
										objRec.set('CuteHealingDesc',CuteHealingDesc);
										objRec.set('CuteInfFlagID',CuteInfFlagID);
										objRec.set('CuteInfFlagDesc',CuteInfFlagDesc);
										objRec.set('OperInfTypeID',OperInfTypeID);
										objRec.set('OperInfTypeDesc',OperInfTypeDesc);
										objRec.set('InHospInfFlagID',InHospInfFlagID);
										objRec.set('InHospInfFlagDesc',InHospInfFlagDesc);
										objRec.commit();
									} else {                 //��������
										var RecordType = objStore.recordType;
										var RecordData = new RecordType({
											RepID : ''
											,SubID : ''
											,OperationID : OperationID
											,OperationDesc : OperationDesc
											,OperDocID : OperDocID
											,OperDocDesc : OperDocDesc
											,OperStartDate : OperStartDate
											,OperStartTime : OperStartTime
											,OperEndDate : OperEndDate
											,OperEndTime : OperEndTime
											,OperationTypeID : OperationTypeID
											,OperationTypeDesc : OperationTypeDesc
											,AnesthesiaID : AnesthesiaID
											,AnesthesiaDesc : AnesthesiaDesc
											,CuteTypeID : CuteTypeID
											,CuteTypeDesc : CuteTypeDesc
											,CuteHealingID : CuteHealingID
											,CuteHealingDesc : CuteHealingDesc
											,CuteInfFlagID : CuteInfFlagID
											,CuteInfFlagDesc : CuteInfFlagDesc
											,OperInfTypeID : OperInfTypeID
											,OperInfTypeDesc : OperInfTypeDesc
											,InHospInfFlagID : InHospInfFlagID
											,InHospInfFlagDesc : InHospInfFlagDesc
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
						id: "OPR_gridOpr_RowEditer_btnCancel",
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
						var objRec = obj.OPR_gridOpr_RowEditer_objRec;
						if (objRec) {
							Common_SetValue('OPR_gridOpr_RowEditer_cboOperation',objRec.get('OperationID'),objRec.get('OperationDesc'));
							Common_SetDisabled("OPR_gridOpr_RowEditer_cboOperation",(objRec.get('DataSource') != ''));
							if (objRec.get('OperStartDate') != '') {
								Common_SetValue('OPR_gridOpr_RowEditer_txtStartDateTime',objRec.get('OperStartDate') + ' ' + objRec.get('OperStartTime'));
							} else {
								Common_SetValue('OPR_gridOpr_RowEditer_txtStartDateTime','');
							}
							if (objRec.get('OperEndDate') != '') {
								Common_SetValue('OPR_gridOpr_RowEditer_txtEndDateTime',objRec.get('OperEndDate') + ' ' + objRec.get('OperEndTime'));
							} else {
								Common_SetValue('OPR_gridOpr_RowEditer_txtEndDateTime','');
							}
							Common_SetValue('OPR_gridOpr_RowEditer_cboOperDoc',objRec.get('OperDocID'),objRec.get('OperDocDesc'));
							Common_SetValue('OPR_gridOpr_RowEditer_cboOperationType',objRec.get('OperationTypeID'),objRec.get('OperationTypeDesc'));
							Common_SetValue('OPR_gridOpr_RowEditer_cboAnesthesia',objRec.get('AnesthesiaID'),objRec.get('AnesthesiaDesc'));
							Common_SetValue('OPR_gridOpr_RowEditer_cboCuteType',objRec.get('CuteTypeID'),objRec.get('CuteTypeDesc'));
							Common_SetValue('OPR_gridOpr_RowEditer_cboCuteHealing',objRec.get('CuteHealingID'),objRec.get('CuteHealingDesc'));
							var objDic = obj.ClsSSDictionary.GetObjById(objRec.get('CuteInfFlagID'));
							if (objDic) {
								Common_SetValue('OPR_gridOpr_RowEditer_chkIsCuteInf',(objDic.Code == 'Y'));
								Common_SetDisabled("OPR_gridOpr_RowEditer_cboOperInfType",(objDic.Code != 'Y'));
								Common_SetDisabled("OPR_gridOpr_RowEditer_chkIsInHospInf",(objDic.Code != 'Y'));
							} else {
								Common_SetValue('OPR_gridOpr_RowEditer_chkIsCuteInf',false);
								Common_SetDisabled("OPR_gridOpr_RowEditer_cboOperInfType",true);
								Common_SetDisabled("OPR_gridOpr_RowEditer_chkIsInHospInf",true);
							}
							Common_SetValue('OPR_gridOpr_RowEditer_cboOperInfType',objRec.get('OperInfTypeID'),objRec.get('OperInfTypeDesc'));
							var objDic = obj.ClsSSDictionary.GetObjById(objRec.get('InHospInfFlagID'));
							if (objDic) {
								Common_SetValue('OPR_gridOpr_RowEditer_chkIsInHospInf',(objDic.Code == 'Y'));
							} else {
								Common_SetValue('OPR_gridOpr_RowEditer_chkIsInHospInf',false);
							}
						} else {
							Common_SetValue('OPR_gridOpr_RowEditer_cboOperation','','');
							Common_SetDisabled("OPR_gridOpr_RowEditer_cboOperation",false);
							Common_SetValue('OPR_gridOpr_RowEditer_txtStartDateTime','');
							Common_SetValue('OPR_gridOpr_RowEditer_txtEndDateTime','');
							Common_SetValue('OPR_gridOpr_RowEditer_cboOperDoc','','');
							Common_SetValue('OPR_gridOpr_RowEditer_cboOperationType','','');
							Common_SetValue('OPR_gridOpr_RowEditer_cboAnesthesia','','');
							Common_SetValue('OPR_gridOpr_RowEditer_cboCuteType','','');
							Common_SetValue('OPR_gridOpr_RowEditer_cboCuteHealing','','');
							Common_SetValue('OPR_gridOpr_RowEditer_chkIsCuteInf',false);
							Common_SetDisabled("OPR_gridOpr_RowEditer_cboOperInfType",true);
							Common_SetDisabled("OPR_gridOpr_RowEditer_chkIsInHospInf",true);
							Common_SetValue('OPR_gridOpr_RowEditer_cboOperInfType','','');
							Common_SetValue('OPR_gridOpr_RowEditer_chkIsInHospInf',false);
						}
					}
				}
			});
		}
		winGridRowEditer.show();
	}
	
	
	//������� ѡ���
	obj.OPR_gridOpr_RowExtract_gridOpr = new Ext.grid.GridPanel({
		id: 'OPR_gridOpr_RowExtract_gridOpr',
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
	obj.OPR_gridOpr_RowExtract = function() {
		var winGridRowEditer = Ext.getCmp('OPR_gridOpr_RowExtract');
		if (!winGridRowEditer)
		{
			winGridRowEditer = new Ext.Window({
				id : 'OPR_gridOpr_RowExtract',
				height : 400,
				closeAction: 'hide',
				width : 600,
				modal : true,
				title : '�������-��ȡ',
				layout : 'fit',
				frame : true,
				items: [
					obj.OPR_gridOpr_RowExtract_gridOpr
				],
				bbar : [
					'->',
					new Ext.Toolbar.Button({
						id: "OPR_gridOpr_RowExtract_btnUpdate",
						width : 80,
						text : "<img SRC='../scripts/dhcmed/img/update.png'>ȷ��",
						listeners : {
							'click' : function(){
								var objRowDataGrid = Ext.getCmp('OPR_gridOpr_RowExtract_gridOpr');
								var objGrid = Ext.getCmp('OPR_gridOpr');
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
												if ((tmpRec.get('OperationDesc') == objRec.get('OperationDesc'))
												&&((tmpRec.get('OperStartDate') == objRec.get('OperStartDate')))) {
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
												,OperationID : objRec.get('OperationID')
												,OperationDesc : objRec.get('OperationDesc')
												,OperDocID : objRec.get('OperDocID')
												,OperDocDesc : objRec.get('OperDocDesc')
												,OperStartDate : objRec.get('OperStartDate')
												,OperStartTime : objRec.get('OperStartTime')
												,OperEndDate : objRec.get('OperEndDate')
												,OperEndTime : objRec.get('OperEndTime')
												,OperationTypeID : objRec.get('OperationTypeID')
												,OperationTypeDesc : objRec.get('OperationTypeDesc')
												,AnesthesiaID : objRec.get('AnesthesiaID')
												,AnesthesiaDesc : objRec.get('AnesthesiaDesc')
												,CuteTypeID : objRec.get('CuteTypeID')
												,CuteTypeDesc : objRec.get('CuteTypeDesc')
												,CuteHealingID : objRec.get('CuteHealingID')
												,CuteHealingDesc : objRec.get('CuteHealingDesc')
												,CuteInfFlagID : objRec.get('CuteInfFlagID')
												,CuteInfFlagDesc : objRec.get('CuteInfFlagDesc')
												,OperInfTypeID : objRec.get('OperInfTypeID')
												,OperInfTypeDesc : objRec.get('OperInfTypeDesc')
												,InHospInfFlagID : objRec.get('InHospInfFlagID')
												,InHospInfFlagDesc : objRec.get('InHospInfFlagDesc')
												,DataSource : objRec.get('DataSource')
											});
											
											objStore.insert(objStore.getCount(), RecordData);
											obj.OPR_gridOpr_RowEditer(RecordData);//���ȷ����ȡ���ݺ�ֱ�ӵ�����������༭���� add by yanjf,20140512
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
						id: "OPR_gridOpr_RowExtract_btnCancel",
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
						var objRowDataGrid = Ext.getCmp('OPR_gridOpr_RowExtract_gridOpr');
						if (objRowDataGrid) {
							objRowDataGrid.getStore().load({});
						}
					}
				}
			});
		}
		var objRowDataGrid = Ext.getCmp('OPR_gridOpr_RowExtract_gridOpr');
		winGridRowEditer.show();
	}
	
	
	//������� �б�
	obj.OPR_gridOpr_btnAdd = new Ext.Button({
		id : 'OPR_gridOpr_btnAdd'
		,iconCls : 'icon-add'
		,width: 80
		,text : '����'
		,listeners : {
			'click' :  function(){
				obj.OPR_gridOpr_RowEditer('');
			}
		}
	});
	obj.OPR_gridOpr_btnDel = new Ext.Button({
		id : 'OPR_gridOpr_btnDel'
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
				
				var objGrid = Ext.getCmp("OPR_gridOpr");
				if (objGrid){
					var arrRec = objGrid.getSelectionModel().getSelections();
					if (arrRec.length>0){
						Ext.MessageBox.confirm('ɾ��', '�Ƿ�ɾ��ѡ�����ݼ�¼?', function(btn,text){
							if(btn=="yes"){
								for (var indRec = 0; indRec < arrRec.length; indRec++){
									var objRec = arrRec[indRec];
									if (objRec.get('SubID')) {
										var RecID = objRec.get('RepID') + '||' + objRec.get('SubID');
										var flg = obj.ClsInfReportOprSrv.DelSubRec(objRec.get('RepID') + '||' + objRec.get('SubID'));
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
	obj.OPR_gridOpr_btnGet = new Ext.Button({
		id : 'OPR_gridOpr_btnGet'
		,iconCls : 'icon-update'
		,width: 80
		,text : "��ȡ����"
		,listeners : {
			'click' :  function(){
				obj.OPR_gridOpr_RowExtract();
			}
		}
	});
	obj.OPR_gridOpr_iniFun = function() {
		var tmpGridPanel = new Ext.grid.GridPanel({
			id: arguments[0],
			store : new Ext.data.Store({
				proxy: new Ext.data.HttpProxy({
					url : ExtToolSetting.RunQueryPageURL,
					listeners : {
						'beforeload' :  function(objProxy, param){
							param.ClassName = 'DHCMed.NINFService.Rep.InfReportOpr';
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
				,{header: '��������', width: 120, dataIndex: 'OperationDesc', sortable: false, menuDisabled:true, align:'center' }
				,{header: '����<br>����', width: 50, dataIndex: 'OperationTypeDesc', sortable: false, menuDisabled:true, align:'center' }
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
				,{header: '�п�<br>����', width: 50, dataIndex: 'CuteTypeDesc', sortable: false, menuDisabled:true, align:'center' }
				,{header: '����<br>���', width: 50, dataIndex: 'CuteHealingDesc', sortable: false, menuDisabled:true, align:'center' }
				,{header: '�п�<br>��Ⱦ', width: 50, dataIndex: 'CuteInfFlagDesc', sortable: false, menuDisabled:true, align:'center' }
				,{header: '��Ⱦ����', width: 80, dataIndex: 'OperInfTypeDesc', sortable: false, menuDisabled:true, align:'center' }
				,{header: '����Ժ<br>�ڸ�Ⱦ', width: 60, dataIndex: 'InHospInfFlagDesc', sortable: false, menuDisabled:true, align:'center' }
				//,{header: '����<br>��Դ', width: 50, dataIndex: 'DataSource', sortable: false, menuDisabled:true, align:'center' }
			],
			viewConfig : {
				forceFit : true
			}
		});
		
		return tmpGridPanel;
	}
	obj.OPR_gridOpr = obj.OPR_gridOpr_iniFun("OPR_gridOpr");
	
	//������� ���沼��
	obj.OPR_ViewPort = {
		//title : '�������',
		layout : 'fit',
		//frame : true,
		height : 300,
		anchor : '-20',
		tbar : ['<b>������λ</b>'],
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
										columnWidth:.25,
										boxMinWidth : 100,
										boxMaxWidth : 150,
										layout : 'form',
										labelAlign : 'right',
										labelWidth : 60,
										items : [obj.OPR_cbgIsOperation]
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
								items : [obj.OPR_gridOpr]
							}
						],
						bbar : [obj.OPR_gridOpr_btnGet,obj.OPR_gridOpr_btnAdd,obj.OPR_gridOpr_btnDel,'->','��']
					}
				]
			}
		]
	}
	
	//������� �����ʼ��
	obj.OPR_InitView = function(){
		//��ʼ��"����[��/��]"����Ԫ��ֵ
		//��ʼ��"������Ϣ������ť"����Ԫ��״̬
		var isActive = false;
		if (obj.CurrReport.ChildSumm.OprBoolean != '') {
			isActive = (obj.CurrReport.ChildSumm.OprBoolean.Code == 'Y');
		} else {
			var num = obj.ClsInfReportOprSrv.IsCheckOpr(obj.CurrReport.EpisodeID);
			if (parseInt(num) > 0) {
				isActive = true;
			} else {
				isActive = false;
			}
		}
		if (isActive) {
			Common_SetValue('OPR_cbgIsOperation','','��');
		} else {
			Common_SetValue('OPR_cbgIsOperation','','��');
		}
		Common_SetDisabled('OPR_gridOpr_btnAdd',(!isActive));
		Common_SetDisabled('OPR_gridOpr_btnDel',(!isActive));
		Common_SetDisabled('OPR_gridOpr_btnGet',(!isActive));
		
		//��ʼ��"������Ϣ�б�"load��rowdblclick�¼�
		var objGrid = Ext.getCmp("OPR_gridOpr");
		if (objGrid){
			objGrid.getStore().load({});
			objGrid.on('rowdblclick',function(){
				var isBoolean = Common_GetValue('OPR_cbgIsOperation');
				if (!isBoolean) return;
				var rowIndex = arguments[1];
				var objRec = this.getStore().getAt(rowIndex);
				obj.OPR_gridOpr_RowEditer(objRec);
			},objGrid);
		}
		
		//��ʼ��"����[��/��]"change�¼�
		var objCmp = Ext.getCmp("OPR_cbgIsOperation");
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
				Common_SetDisabled('OPR_gridOpr_btnAdd',(!isActive));
				Common_SetDisabled('OPR_gridOpr_btnDel',(!isActive));
				Common_SetDisabled('OPR_gridOpr_btnGet',(!isActive));
				
				var objGrid = Ext.getCmp("OPR_gridOpr");
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
	
	//������� ���ݴ洢
	obj.OPR_SaveData = function(){
		var errinfo = '';
		
		//����[��/��]
		var itmValue = Common_GetValue('OPR_cbgIsOperation');
		obj.CurrReport.ChildSumm.OprBoolean = obj.ClsSSDictionary.GetObjById(itmValue);
		
		//���������У��
		var objSumm = obj.CurrReport.ChildSumm;
		if (!objSumm.OprBoolean) {
			errinfo = errinfo + '����[��/��]δ��!<br>'
		}
		
		//������Ϣ
		obj.CurrReport.ChildOpr   = new Array();
		var objCmp = Ext.getCmp('OPR_gridOpr');
		if (objCmp) {
			var objStore = objCmp.getStore();
			
			//Add By LiYang 2014-11-02 FixBug:3834 ҽԺ��Ⱦ����-ȫԺ�ۺ��Լ��-��Ⱦ�����ѯ-������ѡ���ǡ���δ�����������ύ�ɹ�
			debugger;
			if((Common_GetText('OPR_cbgIsOperation') == '��') && (objStore.getCount() == 0))
				errinfo = errinfo + '��ѡ�ˡ�������������û����д������Ϣ&nbsp;'
				
			for (var indRec = 0; indRec < objStore.getCount(); indRec++) {
				var objRec = objStore.getAt(indRec);
				var objOpr = obj.ClsInfReportOprSrv.GetSubObj('');
				if (objOpr) {
					objOpr.RowID = objRec.get('RepID') + '||' + objRec.get('SubID');
					objOpr.DataSource = objRec.get('DataSource');
					objOpr.OperationID = objRec.get('OperationID');
					objOpr.OperationDesc = objRec.get('OperationDesc');
					objOpr.OperStartDate = objRec.get('OperStartDate');
					objOpr.OperStartTime = objRec.get('OperStartTime');
					objOpr.OperEndDate = objRec.get('OperEndDate');
					objOpr.OperEndTime = objRec.get('OperEndTime');
					objOpr.OperDoc = obj.ClsBaseSSUser.GetObjById(objRec.get('OperDocID'));
					objOpr.OperationType = obj.ClsSSDictionary.GetObjById(objRec.get('OperationTypeID'));
					objOpr.Anesthesia = obj.ClsSSDictionary.GetObjById(objRec.get('AnesthesiaID'));
					objOpr.CuteType = obj.ClsSSDictionary.GetObjById(objRec.get('CuteTypeID'));
					objOpr.CuteHealing = obj.ClsSSDictionary.GetObjById(objRec.get('CuteHealingID'));
					objOpr.CuteInfFlag = obj.ClsSSDictionary.GetObjById(objRec.get('CuteInfFlagID'));
					objOpr.OperInfType = obj.ClsSSDictionary.GetObjById(objRec.get('OperInfTypeID'));
					objOpr.InHospInfFlag = obj.ClsSSDictionary.GetObjById(objRec.get('InHospInfFlagID'));
					
					//���������У��
					var rowerrinfo = '';
					if (!objOpr.OperationDesc) {
						rowerrinfo = rowerrinfo + '��������&nbsp;'
					}
					if (!objOpr.OperStartDate) {
						rowerrinfo = rowerrinfo + '��ʼʱ��&nbsp;'
					}
					if (!objOpr.OperEndDate) {
						rowerrinfo = rowerrinfo + '����ʱ��&nbsp;'
					}
					if (!objOpr.OperDoc) {
						rowerrinfo = rowerrinfo + '����ҽ��&nbsp;'
					}
					if (!objOpr.OperationType) {
						rowerrinfo = rowerrinfo + '��������&nbsp;'
					}
					if (!objOpr.Anesthesia) {
						rowerrinfo = rowerrinfo + '����ʽ&nbsp;'
					}
					if (!objOpr.CuteType) {
						rowerrinfo = rowerrinfo + '�п�����&nbsp;'
					}
					if (!objOpr.CuteHealing) {
						rowerrinfo = rowerrinfo + '�������&nbsp;'
					}
					if (objOpr.CuteInfFlag) {
						if ((objOpr.CuteInfFlag.Code == 'Y')&&(!objOpr.OperInfType)) {
							rowerrinfo = rowerrinfo + '��Ⱦ����&nbsp;'
						}
					}
					if (rowerrinfo) {
						var row = objStore.indexOfId(objRec.id);  //��ȡ�к�
						errinfo = errinfo + '������Ϣ ��' + (row + 1) + '�� ' + rowerrinfo + 'δ��!<br>';
					}
					
					obj.CurrReport.ChildOpr.push(objOpr);
				}
			}
		}
		//���������У��
		var objSumm = obj.CurrReport.ChildSumm;
		if (objSumm.OprBoolean) {
			if (objSumm.OprBoolean.Code == 'Y') {
				if (obj.CurrReport.ChildOpr.length < 1) {
					//errinfo = errinfo + '������Ϣδ��!<br>'  //update by zf 20121021 ������,������˴θ�Ⱦ�޹�,���Բ���
				}
			}
		}
		
		return errinfo;
	}
	
	return obj;
}