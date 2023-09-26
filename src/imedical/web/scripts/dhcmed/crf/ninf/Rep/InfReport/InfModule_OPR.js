	
function InitOPR(obj)
{
	//手术
	obj.OPR_cbgIsOperation = Common_RadioGroupToDic("OPR_cbgIsOperation","手术","NINFInfOprBoolean",2);
	
	//手术相关 编辑框
	obj.OPR_gridOpr_RowEditer_objRec = '';
	obj.OPR_gridOpr_RowEditer = function(objRec) {
		obj.OPR_gridOpr_RowEditer_objRec = objRec;
		var winGridRowEditer = Ext.getCmp('OPR_gridOpr_RowEditer');
		if (!winGridRowEditer)
		{
			obj.OPR_gridOpr_RowEditer_cboOperation = Common_ComboToORCOperation("OPR_gridOpr_RowEditer_cboOperation","<span style='color:red'><b>手术名称</b></span>");
			obj.OPR_gridOpr_RowEditer_txtStartDateTime = Common_DateFieldToDateTime("OPR_gridOpr_RowEditer_txtStartDateTime","<span style='color:red'><b>开始时间</b></span>");
			obj.OPR_gridOpr_RowEditer_txtEndDateTime = Common_DateFieldToDateTime("OPR_gridOpr_RowEditer_txtEndDateTime","<span style='color:red'><b>结束时间</b></span>");
			obj.OPR_gridOpr_RowEditer_cboOperDoc = Common_ComboToSSUser("OPR_gridOpr_RowEditer_cboOperDoc","<span style='color:red'><b>手术医生</b></span>");
			obj.OPR_gridOpr_RowEditer_cboOperationType = Common_ComboToDic("OPR_gridOpr_RowEditer_cboOperationType","<span style='color:red'><b>手术类型</b></span>","NINFInfOperationType");
			obj.OPR_gridOpr_RowEditer_cboAnesthesia = Common_ComboToDic("OPR_gridOpr_RowEditer_cboAnesthesia","<span style='color:red'><b>麻醉方式</b></span>","NINFInfAnesthesia");
			obj.OPR_gridOpr_RowEditer_cboCuteType = Common_ComboToDic("OPR_gridOpr_RowEditer_cboCuteType","<span style='color:red'><b>切口类型</b></span>","NINFInfCuteType");
			obj.OPR_gridOpr_RowEditer_cboCuteHealing = Common_ComboToDic("OPR_gridOpr_RowEditer_cboCuteHealing","<span style='color:red'><b>愈合情况</b></span>","NINFInfCuteHealing");
			obj.OPR_gridOpr_RowEditer_chkIsCuteInf = Common_Checkbox("OPR_gridOpr_RowEditer_chkIsCuteInf","切口感染");
			obj.OPR_gridOpr_RowEditer_chkIsCuteInf.on('check',function(cb,val){
				Common_SetDisabled('OPR_gridOpr_RowEditer_cboOperInfType',(!val));
				Common_SetDisabled('OPR_gridOpr_RowEditer_chkIsInHospInf',(!val));
				Common_SetValue('OPR_gridOpr_RowEditer_cboOperInfType','','');
				Common_SetValue('OPR_gridOpr_RowEditer_chkIsInHospInf',false);
			});
			obj.OPR_gridOpr_RowEditer_cboOperInfType = Common_ComboToDic("OPR_gridOpr_RowEditer_cboOperInfType","感染类型","NINFInfOperInfType");
			obj.OPR_gridOpr_RowEditer_chkIsInHospInf = Common_Checkbox("OPR_gridOpr_RowEditer_chkIsInHospInf","引起院感");
			
			winGridRowEditer = new Ext.Window({
				id : 'OPR_gridOpr_RowEditer',
				height : 270,
				closeAction: 'hide',
				width : 450,
				modal : true,
				title : '手术相关-编辑',
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
						text : "<img SRC='../scripts/dhcmed/img/update.png'>确定",
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
									errInfo = errInfo + '手术名称为空!<br>';
								}
								if (StartDateTime == '') {
									errInfo = errInfo + '开始时间为空!<br>';
								}
								if (EndDateTime == '') {
									errInfo = errInfo + '结束时间为空!<br>';
								}
								
								//add by lyh 2013-11-07 手术时间逻辑控制
								var StartDate=StartDateTime.split(" ")[0];
								var EndDate=EndDateTime.split(" ")[0];
								
								var flg = Common_CompareDate(StartDate,EndDate);
								if (!flg) errInfo = errInfo + '手术开始时间大于手术结束时间!<br>'
								
								if(StartDateTime==EndDateTime) errInfo = errInfo + '手术开始时间和手术结束时间不能完全相同!<br>'
								
								//add by LiYang 2014-06-25 手术日期校验
								var dt1 = new Number(Date.parseDate(StartDateTime, "Y-m-d H:i")); // returns null
								var dt2 = new Number(Date.parseDate(EndDateTime, "Y-m-d H:i")); // returns null
								var ms = dt2 - dt1;
								var days = ms / 1000 / 60 / 60 /24;
								if (days > 2) errInfo = errInfo + '“手术结束时间”与“开始时间”之差应小于等于48小时!<br>'
								
								var disDateTime = Common_GetValue('BASE_txtDisDate');
								var dt3 = new Number(Date.parseDate(disDateTime, "Y-m-d H:i:s"));
								if((dt3 != 0)&&(dt1 > dt3))
									errInfo = errInfo + '“手术开始时间”之差应小于出院时间!<br>';
								if((dt3 != 0)&&(dt2 > dt3))
									errInfo = errInfo + '“手术结束时间”之差应小于出院时间!<br>';	
								
								var AdmDate = Common_GetValue('BASE_txtAdmDate');
								var dt3 = new Number(Date.parseDate(AdmDate, "Y-m-d H:i:s"));
								if((dt3 != 0)&&(dt1 < dt3))
									errInfo = errInfo + '“手术开始时间”应大于住院时间!<br>';
								if((dt3 != 0)&&(dt2 < dt3))
									errInfo = errInfo + '“手术结束时间”应大于住院时间!<br>';									
								
								
								if ((OperDocID == '')&&(OperDocDesc != '')) {
									errInfo = errInfo + '手术医生格式错误!';
								} else if (OperDocID == '') {
									errInfo = errInfo + '手术医生为空!<br>';
								}
								if ((OperationTypeID == '')||(OperationTypeDesc == '')) {
									errInfo = errInfo + '手术类型为空!<br>';
								}
								if ((AnesthesiaID == '')&&(AnesthesiaDesc != '')) {
									errInfo = errInfo + '麻醉方式格式错误!';
								} else if (AnesthesiaID == '') {
									errInfo = errInfo + '麻醉方式为空!<br>';
								}
								if ((CuteTypeID == '')||(CuteTypeDesc == '')) {
									errInfo = errInfo + '切口类型为空!<br>';
								}
								if ((CuteHealingID == '')||(CuteHealingDesc == '')) {
									errInfo = errInfo + '愈合情况为空!<br>';
								}
								if (CuteInfFlag=="Y") {
									var objDic = obj.ClsSSDictionary.GetObjById(CuteInfFlagID);
									if (objDic) {
										if ((objDic.Code == 'Y')&&(OperInfTypeID == '')||(OperInfTypeDesc == '')) {
											errInfo = errInfo + '感染类型为空!<br>'
										}
									}
								}
								if (errInfo != '') {
									ExtTool.alert("提示",errInfo);
									return;
								}
								
								var objRec = obj.OPR_gridOpr_RowEditer_objRec;
								var objGrid = Ext.getCmp('OPR_gridOpr');
								if (objGrid) {
									var objStore = objGrid.getStore();
									
									//判断是否存在相同手术名称,相同开始日期数据(相同一天不允许有相同名手术)
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
										ExtTool.alert("提示","存在相同手术名称,相同手术日期数据!");
										return;
									}
									
									if (objRec) {      //提交数据
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
									} else {                 //插入数据
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
	
	
	//手术相关 选择框
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
			,{header: '手术名称', width: 150, dataIndex: 'OperationDesc', sortable: false, menuDisabled:true, align:'center' }
			//,{header: '手术<br>类型', width: 50, dataIndex: 'OperationTypeDesc', sortable: false, menuDisabled:true, align:'center' }
			,{header: '手术开始时间', width : 100, sortable: false, menuDisabled:true, align:'center'
				, renderer: function(v, m, rd, r, c, s){
					if (rd.get("OperStartDate") != '') {
						return rd.get("OperStartDate") + ' ' + rd.get("OperStartTime");
					} else {
						return '';
					}
				}
			}
			,{header: '手术结束时间', width : 100, sortable: false, menuDisabled:true, align:'center'
				, renderer: function(v, m, rd, r, c, s){
					if (rd.get("OperEndDate") != '') {
						return rd.get("OperEndDate") + ' ' + rd.get("OperEndTime");
					} else {
						return '';
					}
				}
			}
			,{header: '手术医生', width: 60, dataIndex: 'OperDocDesc', sortable: false, menuDisabled:true, align:'center' }
			,{header: '麻醉方法', width: 60, dataIndex: 'AnesthesiaDesc', sortable: false, menuDisabled:true, align:'center' }
			//,{header: '切口<br>类型', width: 50, dataIndex: 'CuteTypeDesc', sortable: false, menuDisabled:true, align:'center' }
			//,{header: '愈合<br>情况', width: 50, dataIndex: 'CuteHealingDesc', sortable: false, menuDisabled:true, align:'center' }
			//,{header: '切口<br>感染', width: 50, dataIndex: 'CuteInfFlagDesc', sortable: false, menuDisabled:true, align:'center' }
			//,{header: '感染类型', width: 50, dataIndex: 'OperInfTypeDesc', sortable: false, menuDisabled:true, align:'center' }
			//,{header: '引起院<br>内感染', width: 60, dataIndex: 'InHospInfFlagDesc', sortable: false, menuDisabled:true, align:'center' }
			,{header: '数据<br>来源', width: 50, dataIndex: 'DataSource', sortable: false, menuDisabled:true, align:'center' }
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
				title : '手术相关-提取',
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
						text : "<img SRC='../scripts/dhcmed/img/update.png'>确定",
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
											
											//检查是否存在相同一天多个相同名手术,或相同数据来源数据
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
											obj.OPR_gridOpr_RowEditer(RecordData);//点击确定提取数据后直接弹出手术情况编辑界面 add by yanjf,20140512
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
						id: "OPR_gridOpr_RowExtract_btnCancel",
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
	
	
	//手术相关 列表
	obj.OPR_gridOpr_btnAdd = new Ext.Button({
		id : 'OPR_gridOpr_btnAdd'
		,iconCls : 'icon-add'
		,width: 80
		,text : '增加'
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
				
				var objGrid = Ext.getCmp("OPR_gridOpr");
				if (objGrid){
					var arrRec = objGrid.getSelectionModel().getSelections();
					if (arrRec.length>0){
						Ext.MessageBox.confirm('删除', '是否删除选中数据记录?', function(btn,text){
							if(btn=="yes"){
								for (var indRec = 0; indRec < arrRec.length; indRec++){
									var objRec = arrRec[indRec];
									if (objRec.get('SubID')) {
										var RecID = objRec.get('RepID') + '||' + objRec.get('SubID');
										var flg = obj.ClsInfReportOprSrv.DelSubRec(objRec.get('RepID') + '||' + objRec.get('SubID'));
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
	obj.OPR_gridOpr_btnGet = new Ext.Button({
		id : 'OPR_gridOpr_btnGet'
		,iconCls : 'icon-update'
		,width: 80
		,text : "提取数据"
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
				,{header: '手术名称', width: 120, dataIndex: 'OperationDesc', sortable: false, menuDisabled:true, align:'center' }
				,{header: '手术<br>类型', width: 50, dataIndex: 'OperationTypeDesc', sortable: false, menuDisabled:true, align:'center' }
				,{header: '手术开始时间', width : 100, sortable: false, menuDisabled:true, align:'center'
					, renderer: function(v, m, rd, r, c, s){
						if (rd.get("OperStartDate") != '') {
							return rd.get("OperStartDate") + ' ' + rd.get("OperStartTime");
						} else {
							return '';
						}
					}
				}
				,{header: '手术结束时间', width : 100, sortable: false, menuDisabled:true, align:'center'
					, renderer: function(v, m, rd, r, c, s){
						if (rd.get("OperEndDate") != '') {
							return rd.get("OperEndDate") + ' ' + rd.get("OperEndTime");
						} else {
							return '';
						}
					}
				}
				,{header: '手术医生', width: 60, dataIndex: 'OperDocDesc', sortable: false, menuDisabled:true, align:'center' }
				,{header: '麻醉方法', width: 60, dataIndex: 'AnesthesiaDesc', sortable: false, menuDisabled:true, align:'center' }
				,{header: '切口<br>类型', width: 50, dataIndex: 'CuteTypeDesc', sortable: false, menuDisabled:true, align:'center' }
				,{header: '愈合<br>情况', width: 50, dataIndex: 'CuteHealingDesc', sortable: false, menuDisabled:true, align:'center' }
				,{header: '切口<br>感染', width: 50, dataIndex: 'CuteInfFlagDesc', sortable: false, menuDisabled:true, align:'center' }
				,{header: '感染类型', width: 80, dataIndex: 'OperInfTypeDesc', sortable: false, menuDisabled:true, align:'center' }
				,{header: '引起院<br>内感染', width: 60, dataIndex: 'InHospInfFlagDesc', sortable: false, menuDisabled:true, align:'center' }
				//,{header: '数据<br>来源', width: 50, dataIndex: 'DataSource', sortable: false, menuDisabled:true, align:'center' }
			],
			viewConfig : {
				forceFit : true
			}
		});
		
		return tmpGridPanel;
	}
	obj.OPR_gridOpr = obj.OPR_gridOpr_iniFun("OPR_gridOpr");
	
	//手术相关 界面布局
	obj.OPR_ViewPort = {
		//title : '手术相关',
		layout : 'fit',
		//frame : true,
		height : 300,
		anchor : '-20',
		tbar : ['<b>手术部位</b>'],
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
						bbar : [obj.OPR_gridOpr_btnGet,obj.OPR_gridOpr_btnAdd,obj.OPR_gridOpr_btnDel,'->','…']
					}
				]
			}
		]
	}
	
	//手术相关 界面初始化
	obj.OPR_InitView = function(){
		//初始化"手术[是/否]"界面元素值
		//初始化"手术信息操作按钮"界面元素状态
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
			Common_SetValue('OPR_cbgIsOperation','','是');
		} else {
			Common_SetValue('OPR_cbgIsOperation','','否');
		}
		Common_SetDisabled('OPR_gridOpr_btnAdd',(!isActive));
		Common_SetDisabled('OPR_gridOpr_btnDel',(!isActive));
		Common_SetDisabled('OPR_gridOpr_btnGet',(!isActive));
		
		//初始化"手术信息列表"load及rowdblclick事件
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
		
		//初始化"手术[是/否]"change事件
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
	
	//手术相关 数据存储
	obj.OPR_SaveData = function(){
		var errinfo = '';
		
		//手术[是/否]
		var itmValue = Common_GetValue('OPR_cbgIsOperation');
		obj.CurrReport.ChildSumm.OprBoolean = obj.ClsSSDictionary.GetObjById(itmValue);
		
		//数据完成性校验
		var objSumm = obj.CurrReport.ChildSumm;
		if (!objSumm.OprBoolean) {
			errinfo = errinfo + '手术[是/否]未填!<br>'
		}
		
		//手术信息
		obj.CurrReport.ChildOpr   = new Array();
		var objCmp = Ext.getCmp('OPR_gridOpr');
		if (objCmp) {
			var objStore = objCmp.getStore();
			
			//Add By LiYang 2014-11-02 FixBug:3834 医院感染管理-全院综合性监测-感染报告查询-手术勾选【是】，未增加手术，提交成功
			debugger;
			if((Common_GetText('OPR_cbgIsOperation') == '是') && (objStore.getCount() == 0))
				errinfo = errinfo + '勾选了【有手术】但是没有填写手术信息&nbsp;'
				
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
					
					//数据完成性校验
					var rowerrinfo = '';
					if (!objOpr.OperationDesc) {
						rowerrinfo = rowerrinfo + '手术名称&nbsp;'
					}
					if (!objOpr.OperStartDate) {
						rowerrinfo = rowerrinfo + '开始时间&nbsp;'
					}
					if (!objOpr.OperEndDate) {
						rowerrinfo = rowerrinfo + '结束时间&nbsp;'
					}
					if (!objOpr.OperDoc) {
						rowerrinfo = rowerrinfo + '手术医生&nbsp;'
					}
					if (!objOpr.OperationType) {
						rowerrinfo = rowerrinfo + '手术类型&nbsp;'
					}
					if (!objOpr.Anesthesia) {
						rowerrinfo = rowerrinfo + '麻醉方式&nbsp;'
					}
					if (!objOpr.CuteType) {
						rowerrinfo = rowerrinfo + '切口类型&nbsp;'
					}
					if (!objOpr.CuteHealing) {
						rowerrinfo = rowerrinfo + '愈合情况&nbsp;'
					}
					if (objOpr.CuteInfFlag) {
						if ((objOpr.CuteInfFlag.Code == 'Y')&&(!objOpr.OperInfType)) {
							rowerrinfo = rowerrinfo + '感染类型&nbsp;'
						}
					}
					if (rowerrinfo) {
						var row = objStore.indexOfId(objRec.id);  //获取行号
						errinfo = errinfo + '手术信息 第' + (row + 1) + '行 ' + rowerrinfo + '未填!<br>';
					}
					
					obj.CurrReport.ChildOpr.push(objOpr);
				}
			}
		}
		//数据完成性校验
		var objSumm = obj.CurrReport.ChildSumm;
		if (objSumm.OprBoolean) {
			if (objSumm.OprBoolean.Code == 'Y') {
				if (obj.CurrReport.ChildOpr.length < 1) {
					//errinfo = errinfo + '手术信息未填!<br>'  //update by zf 20121021 做手术,但是与此次感染无关,可以不填
				}
			}
		}
		
		return errinfo;
	}
	
	return obj;
}