	
function InitIUC(obj)
{
	//插管时间
	obj.IUC_txtIntubateDateTime = Common_DateFieldToDateTime("IUC_txtIntubateDateTime","插管时间");
	
	//拔管时间
	obj.IUC_txtExtubateDateTime = Common_DateFieldToDateTime("IUC_txtExtubateDateTime","拔管时间");
	
	//尿管类型
	obj.IUC_cboUCUrineBagType = Common_ComboToDic("IUC_cboUCUrineBagType","尿管类型","NINFICUUCUrineBagType");
	
	//置管人员类型
	obj.IUC_cboIntubateUserType = Common_ComboToDic("IUC_cboIntubateUserType","置管人员","NINFICUIntubateUserType");
	
	//置管地点
	obj.IUC_cboIntubatePlace = Common_ComboToDic("IUC_cboIntubatePlace","置管地点","NINFICUIntubatePlace");
	
	//置管人员
	obj.IUC_cboIntubateUser = Common_ComboToSSUser("IUC_cboIntubateUser","置管人员");
	
	//是否感染
	obj.IUC_chkIsInf = Common_Checkbox("IUC_chkIsInf","是否感染");
	obj.IUC_chkIsInf.on('check',function(checkbox,value){
		var objItem1 = Ext.getCmp("IUC_txtInfDate");
		if (objItem1) {
			objItem1.setDisabled((!value));
		}
		var objItem1 = Ext.getCmp("IUC_cboInfPy");
		if (objItem1) {
			objItem1.setDisabled((!value));
		}
		if (!value) {
			Common_SetValue('IUC_txtInfDate','');
			Common_SetValue('IUC_cboInfPy','','');
		}
	},obj.IUC_chkIsInf);
	
	//感染日期
	obj.IUC_txtInfDate = Common_DateFieldToDate("IUC_txtInfDate","感染日期");
	
	//病原体
	obj.IUC_cboInfPy = Common_ComboToPathogeny("IUC_cboInfPy","病原体");
	
	//行编辑
	obj.IUC_GridRowViewPort = {
		layout : 'form',
		labelAlign : 'right',
		labelWidth : 60,
		frame : true,
		items : [
			obj.IUC_cboUCUrineBagType
			,obj.IUC_txtIntubateDateTime
			,obj.IUC_txtExtubateDateTime
			,obj.IUC_cboIntubatePlace
			,obj.IUC_cboIntubateUserType
			,obj.IUC_chkIsInf
			,obj.IUC_txtInfDate
		]
	}
	
	obj.IUC_GridRowDataCheck = function(objRec){
		var errInfo = '';
		
		if (objRec) {
			var IUC_txtIntubateDateTime = objRec.get('IntubateDateTime');
			if (IUC_txtIntubateDateTime=='') {
				errInfo = errInfo + '插管时间未填!';
			}
			var IUC_cboUCUrineBagType = objRec.get('UrineBagTypeDesc');
			if (IUC_cboUCUrineBagType=='') {
				errInfo = errInfo + '尿管类型未填!';
			}
			var IUC_cboIntubatePlace = objRec.get('IntubatePlaceDesc');
			if (IUC_cboIntubatePlace=='') {
				errInfo = errInfo + '置管地点未填!';
			}
			var IUC_cboIntubateUserType = objRec.get('IntubateUserTypeDesc');
			if (IUC_cboIntubateUserType=='') {
				errInfo = errInfo + '置管人员未填!';
			}
			var IUC_cboIntubateUser = objRec.get('IntubateUserDesc');
			if (IUC_cboIntubateUser=='') {
				//errInfo = errInfo + '置管人员未填!';
			}
			var IUC_txtExtubateDateTime = objRec.get('ExtubateDateTime');
			if (IUC_txtExtubateDateTime=='') {
				//errInfo = errInfo + '拔管时间未填!';
			}
			var IUC_txtInfDate = Common_GetValue('InfDate');
		} else {
			var IUC_txtIntubateDateTime = Common_GetValue('IUC_txtIntubateDateTime');
			if (IUC_txtIntubateDateTime=='') {
				errInfo = errInfo + '插管时间未填!';
			}
			var IUC_cboUCUrineBagType = Common_GetValue('IUC_cboUCUrineBagType');
			if (IUC_cboUCUrineBagType=='') {
				errInfo = errInfo + '尿管类型未填!';
			}
			var IUC_cboIntubatePlace = Common_GetValue('IUC_cboIntubatePlace');
			if (IUC_cboIntubatePlace=='') {
				errInfo = errInfo + '置管地点未填!';
			}
			var IUC_cboIntubateUserType = Common_GetValue('IUC_cboIntubateUserType');
			if (IUC_cboIntubateUserType=='') {
				errInfo = errInfo + '置管人员未填!';
			}
			var IUC_cboIntubateUser = Common_GetValue('IUC_cboIntubateUser');
			if (IUC_cboIntubateUser=='') {
				//errInfo = errInfo + '置管人员未填!';
			}
			var IUC_txtExtubateDateTime = Common_GetValue('IUC_txtExtubateDateTime');
			if (IUC_txtExtubateDateTime=='') {
				//errInfo = errInfo + '拔管时间未填!';
			}
			var IUC_txtInfDate = Common_GetValue('IUC_txtInfDate');
		}
		
		var today = new Date();
		var CurrDate = today.getYear() + "-" + (today.getMonth() + 1) + "-" + today.getDate();
		if (IUC_txtIntubateDateTime != '') {
			var IntubateDate = IUC_txtIntubateDateTime.split(" ")[0];
			//var flg = Common_CompareDate(IntubateDate,CurrDate);
			//if (!flg) errInfo = errInfo + '插管日期大于当前日期!<br>'
			
			var objPaadm = obj.CurrPaadm;
			var flg = Common_CompareDate(objPaadm.AdmitDate,IntubateDate);
			if (!flg) errInfo = errInfo + '插管日期小于入院日期!<br>'
			
			if (objPaadm.DisDate) {
				var flg = Common_CompareDate(IntubateDate,objPaadm.DisDate);
				if (!flg) errInfo = errInfo + '插管日期大于出院日期!<br>'
			}
			
			var InfDate = IUC_txtInfDate;
			if (InfDate) {
				var flg = Common_CompareDate(IntubateDate,InfDate);
				if (!flg) errInfo = errInfo + '插管日期大于感染日期!<br>'
			}
			
			if (IUC_txtExtubateDateTime != '') {
				var ExtubateDate = IUC_txtExtubateDateTime.split(" ")[0];
				var flg = Common_CompareDate(IntubateDate,ExtubateDate);
				if (!flg) errInfo = errInfo + '拔管日期大于插管日期!<br>'
				
				var flg = Common_CompareDate(ExtubateDate,CurrDate);
				if (!flg) errInfo = errInfo + '拔管日期大于当前日期!<br>'
				
				var flg = Common_CompareDate(objPaadm.AdmitDate,ExtubateDate);
				if (!flg) errInfo = errInfo + '拔管日期小于入院日期!<br>'
				
				if (objPaadm.DisDate) {
					var flg = Common_CompareDate(ExtubateDate,objPaadm.DisDate);
					if (!flg) errInfo = errInfo + '拔管日期大于出院日期!<br>'
				}
				
				var InfDate = IUC_txtInfDate;
				if (InfDate) {
					var flg = Common_CompareDate(InfDate,ExtubateDate);
					if (!flg) errInfo = errInfo + '感染日期大于拔管日期!<br>'
				}
				if (InfDate) {
					var flg = Common_CompareDate(InfDate,CurrDate);
					if (!flg) errInfo = errInfo + '感染日期大于当前日期!<br>'
				}
			}
		}
		
		return errInfo;
	}
	
	obj.IUC_GridRowDataSave = function(objRec){
		var IntubateDateTime = Common_GetValue('IUC_txtIntubateDateTime');
		var arrDateTime = IntubateDateTime.split(' ');
		if (arrDateTime.length>1){
			var IntubateDate = arrDateTime[0];
			var IntubateTime = arrDateTime[1];
		} else {
			var IntubateDate = '';
			var IntubateTime = '';
		}
		var ExtubateDateTime = Common_GetValue('IUC_txtExtubateDateTime');
		var arrDateTime = ExtubateDateTime.split(' ');
		if (arrDateTime.length>1){
			var ExtubateDate = arrDateTime[0];
			var ExtubateTime = arrDateTime[1];
		} else {
			var ExtubateDate = '';
			var ExtubateTime = '';
		}
		var IntubatePlaceID = Common_GetValue('IUC_cboIntubatePlace');
		var IntubatePlaceDesc = Common_GetText('IUC_cboIntubatePlace');
		var IntubateUserTypeID = Common_GetValue('IUC_cboIntubateUserType');
		var IntubateUserTypeDesc = Common_GetText('IUC_cboIntubateUserType');
		var IntubateUserID = Common_GetValue('IUC_cboIntubateUser');
		var IntubateUserDesc = Common_GetText('IUC_cboIntubateUser');
		var InfDate = Common_GetValue('IUC_txtInfDate');
		var IsInfection = (InfDate != '' ? '是' : '否');
		var InfPyID = Common_GetValue('IUC_cboInfPy');
		var InfPyDesc = Common_GetText('IUC_cboInfPy');
		var InfPyValue = InfPyID + CHR_2 + InfPyDesc;
		var UCUrineBagTypeID = Common_GetValue('IUC_cboUCUrineBagType');
		var UCUrineBagTypeDesc = Common_GetText('IUC_cboUCUrineBagType');
		
		if (objRec) {      //提交数据
			objRec.set('IndRec',objRec.get('IndRec'));
			objRec.set('RepID',objRec.get('RepID'));
			objRec.set('SubID',objRec.get('SubID'));
			objRec.set('IsChecked','1');
			objRec.set('DataSource',objRec.get('DataSource'));
			
			objRec.set('IntubateDate',IntubateDate);
			objRec.set('IntubateTime',IntubateTime);
			objRec.set('IntubateDateTime',IntubateDateTime);
			objRec.set('ExtubateDate',ExtubateDate);
			objRec.set('ExtubateTime',ExtubateTime);
			objRec.set('ExtubateDateTime',ExtubateDateTime);
			objRec.set('IntubatePlaceID',IntubatePlaceID);
			objRec.set('IntubatePlaceDesc',IntubatePlaceDesc);
			objRec.set('IntubateUserTypeID',IntubateUserTypeID);
			objRec.set('IntubateUserTypeDesc',IntubateUserTypeDesc);
			objRec.set('IntubateUserID',IntubateUserID);
			objRec.set('IntubateUserDesc',IntubateUserDesc);
			objRec.set('IsInfection',IsInfection);
			objRec.set('InfDate',InfDate);
			objRec.set('InfPyIDs',InfPyID);
			objRec.set('InfPyDescs',InfPyDesc);
			objRec.set('InfPyValues',InfPyValue);
			objRec.set('UCUrineBagTypeID',UCUrineBagTypeID);
			objRec.set('UCUrineBagTypeDesc',UCUrineBagTypeDesc);
			objRec.commit();
		} else {                 //插入数据
			var objGrid = Ext.getCmp('IUC_gridUC');
			if (objGrid){
				var objStore = objGrid.getStore();
				var RecordType = objStore.recordType;
				var RecordData = new RecordType({
					IndRec : ''
					,RepID : obj.CurrReport.RowID
					,SubID : ''
					,IsChecked : '1'
					,DataSource : ''
					,IntubateDate : IntubateDate
					,IntubateTime : IntubateTime
					,IntubateDateTime : IntubateDateTime
					,ExtubateDate : ExtubateDate
					,ExtubateTime : ExtubateTime
					,ExtubateDateTime : ExtubateDateTime
					,IntubatePlaceID : IntubatePlaceID
					,IntubatePlaceDesc : IntubatePlaceDesc
					,IntubateUserTypeID : IntubateUserTypeID
					,IntubateUserTypeDesc : IntubateUserTypeDesc
					,IntubateUserID : IntubateUserID
					,IntubateUserDesc : IntubateUserDesc
					,IsInfection : IsInfection
					,InfDate : InfDate
					,InfPyIDs : InfPyID
					,InfPyDescs : InfPyDesc
					,InfPyValues : InfPyValue
					,UCUrineBagTypeID : UCUrineBagTypeID
					,UCUrineBagTypeDesc : UCUrineBagTypeDesc
				});
				objStore.insert(objStore.getCount(), RecordData);
				objGrid.getView().focusRow(objGrid.getStore().getCount()-1);
			}
		}
	}
	
	obj.IUC_GridRowDataSet = function(objRec){
		if (objRec){
			Common_SetValue('IUC_txtIntubateDateTime',objRec.get('IntubateDateTime'));
			Common_SetValue('IUC_txtExtubateDateTime',objRec.get('ExtubateDateTime'));
			Common_SetValue('IUC_cboUCUrineBagType',objRec.get('UCUrineBagTypeID'),objRec.get('UCUrineBagTypeDesc'));
			Common_SetValue('IUC_cboIntubatePlace',objRec.get('IntubatePlaceID'),objRec.get('IntubatePlaceDesc'));
			Common_SetValue('IUC_cboIntubateUserType',objRec.get('IntubateUserTypeID'),objRec.get('IntubateUserTypeDesc'));
			Common_SetValue('IUC_cboIntubateUser',objRec.get('IntubateUserID'),objRec.get('IntubateUserDesc'));
			
			//是否感染,感染日期,病原体
			Common_SetValue('IUC_chkIsInf',(objRec.get('IsInfection')=='是'));
			Common_SetValue('IUC_txtInfDate',objRec.get('InfDate'));
			var strInfPyValues = objRec.get('InfPyValues');
			strInfPyValues = strInfPyValues.replace(/<\$C1>/gi,CHR_1);
			strInfPyValues = strInfPyValues.replace(/<\$C2>/gi,CHR_2);
			var arrInfPyValues = strInfPyValues.split(CHR_1);
			if (arrInfPyValues.length > 0) {
				var strInfPyValue = arrInfPyValues[0];
				var arrInfPyValue = strInfPyValue.split(CHR_2);
				if (arrInfPyValue.length >= 2) {
					Common_SetValue('IUC_cboInfPy',arrInfPyValue[0],arrInfPyValue[1]);
				}
			} else {
				Common_SetValue('IUC_cboInfPy','','');
			}
			var objItem1 = Ext.getCmp("IUC_txtInfDate");
			if (objItem1) {
				objItem1.setDisabled((objRec.get('IsInfection')!='是'));
			}
			var objItem1 = Ext.getCmp("IUC_cboInfPy");
			if (objItem1) {
				objItem1.setDisabled((objRec.get('IsInfection')!='是'));
			}
		} else {
			Common_SetValue('IUC_txtIntubateDateTime','');
			Common_SetValue('IUC_txtExtubateDateTime','');
			Common_SetValue('IUC_cboUCUrineBagType','','');
			Common_SetValue('IUC_cboIntubatePlace','','');
			Common_SetValue('IUC_cboIntubateUserType','','');
			Common_SetValue('IUC_cboIntubateUser','','');
			Common_SetValue('IUC_chkIsInf','');
			Common_SetValue('IUC_txtInfDate','');
			Common_SetValue('IUC_cboInfPy','','');
			var objItem1 = Ext.getCmp("IUC_txtInfDate");
			if (objItem1) {
				objItem1.setDisabled(true);
			}
			var objItem1 = Ext.getCmp("IUC_cboInfPy");
			if (objItem1) {
				objItem1.setDisabled(true);
			}
		}
	}

	obj.IUC_GridRowEditer = function(objRec){
		obj.IUC_GridRowEditer_objRec = objRec;
		var winGridRowEditer = Ext.getCmp('IUC_GridRowEditer');
		if (!winGridRowEditer){
			winGridRowEditer = new Ext.Window({
				id : 'IUC_GridRowEditer',
				height : 280,
				closeAction: 'hide',
				width : 300,
				modal : true,
				title : '导尿管-编辑',
				layout : 'fit',
				frame : true,
				items: [
					obj.IUC_GridRowViewPort
				],
				bbar : [
					'->',
					new Ext.Toolbar.Button({
						id: "IUC_GridRowEditer_btnUpdate",
						width : 80,
						text : "<img SRC='../scripts/dhcmed/img/update.gif'>保存",
						listeners : {
							'click' : function(){
								var errInfo = obj.IUC_GridRowDataCheck('');
								if (errInfo){
									ExtTool.alert("提示",errInfo);
									return;
								}
								obj.IUC_GridRowDataSave(obj.IUC_GridRowEditer_objRec);
								winGridRowEditer.hide();
							}
						}
					}),
					new Ext.Toolbar.Button({
						id: "IUC_GridRowEditer_btnCancel",
						width : 80,
						text : "<img SRC='../scripts/dhcmed/img/cancel.png'>关闭",
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
		obj.IUC_GridRowDataSet(objRec);
	}
	
	//主列表
	obj.IUC_GridToUC = function(){
		var tmpGridPanel = new Ext.grid.GridPanel({
			id: arguments[0],
			store : new Ext.data.Store({
				proxy: new Ext.data.HttpProxy({
					url : ExtToolSetting.RunQueryPageURL,
					listeners : {
						'beforeload' :  function(objProxy, param){
							param.ClassName = 'DHCMed.NINFService.Rep.InfReportICU';
							param.QueryName = 'QrySubRec';
							param.Arg1      = obj.CurrReport.RowID;
							param.Arg2      = obj.CurrReport.EpisodeID;
							param.Arg3      = 'UC';
							param.ArgCnt    = 3;
						}
					}
				}),
				reader: new Ext.data.JsonReader(
					{
						root: 'record',
						totalProperty: 'total',
						idProperty: 'IndRec'
					},
					[
						{name: 'IndRec', mapping: 'IndRec'}
						,{name: 'RepID', mapping: 'RepID'}
						,{name: 'SubID', mapping: 'SubID'}
						,{name: 'IsChecked', mapping: 'IsChecked'}
						,{name: 'DataSource', mapping: 'DataSource'}
						,{name: 'IntubateTypeID', mapping: 'IntubateTypeID'}
						,{name: 'IntubateTypeDesc', mapping: 'IntubateTypeDesc'}
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
						,{name: 'IsInfection', mapping: 'IsInfection'}
						,{name: 'InfDate', mapping: 'InfDate'}
						,{name: 'InfPyIDs', mapping: 'InfPyIDs'}
						,{name: 'InfPyDescs', mapping: 'InfPyDescs'}
						,{name: 'InfPyValues', mapping: 'InfPyValues'}
						,{name: 'UCUrineBagTypeID', mapping: 'UCUrineBagTypeID'}
						,{name: 'UCUrineBagTypeDesc', mapping: 'UCUrineBagTypeDesc'}
					]
				)
			})
			,height : 150
			//,overflow:'scroll'
			//,overflow-y:hidden
			//,style:'overflow:auto;overflow-y:hidden'
			//,loadMask : true
			,frame : true
			,anchor : '100%'
			,columns: [
				new Ext.grid.RowNumberer()
				,{header: '选择', width: 30, dataIndex: 'IsChecked', sortable: false, menuDisabled:true, align: 'center'
					,renderer: function(v, m, rd, r, c, s){
						var IsChecked = rd.get("IsChecked");
						if (IsChecked == '1') {
							return "<IMG src='../scripts/dhcmed/img/checked.gif'>";
						} else {
							return "<IMG src='../scripts/dhcmed/img/unchecked.gif'>";
						}
					}
				}
				,{header: '尿管类型', width: 60, dataIndex: 'UCUrineBagTypeDesc', sortable: false, menuDisabled:true, align:'center' }
				,{header: '插管时间', width: 100, dataIndex: 'IntubateDateTime', sortable: false, menuDisabled:true, align:'center' }
				,{header: '拔管时间', width: 100, dataIndex: 'ExtubateDateTime', sortable: false, menuDisabled:true, align:'center' }
				,{header: '置管人员', width: 100, dataIndex: 'IntubateUserTypeDesc', sortable: false, menuDisabled:true, align:'center' }
				,{header: '置管地点', width: 100, dataIndex: 'IntubatePlaceDesc', sortable: false, menuDisabled:true, align:'center' }
				,{header: '是否感染', width: 60, dataIndex: 'IsInfection', sortable: false, menuDisabled:true, align:'center' }
				,{header: '感染日期', width: 80, dataIndex: 'InfDate', sortable: false, menuDisabled:true, align:'center' }
			],
			bbar : [
				new Ext.Toolbar.Button({
					id: arguments[0] + "_btnAdd",
					width : 80,
					text : "<img SRC='../scripts/dhcmed/img/add.png'>增加",
					listeners : {
						'click' : function(){
							obj.IUC_GridRowEditer("");
						}
					}
				}),
				new Ext.Toolbar.Button({
					id: arguments[0] + "_btnDelete",
					width : 80,
					text : "<img SRC='../scripts/dhcmed/img/delete.gif'>删除",
					listeners : {
						'click' : function(){
							var objGrid = Ext.getCmp("IUC_gridUC");
							if (objGrid){
								//var objRecArr = objGrid.getSelectionModel().getSelections();
								
								var objRecArr = objGrid.getStore().getRange(); //Modified By LiYang 2014-07-03 FixBug:1776 公共卫生事件-医院感染报告-ICU感染监测，添加中心静脉置管记录后，直接点击【删除】按钮，提示"请选中数据记录，再点击删除！"
								for (var indRec = 0; indRec < objRecArr.length; indRec++){ //add by zhoubo 2014-12-12  fixBug:1683
									var objRec = objRecArr[indRec];
									var flag=0
									if(objRec.get("IsChecked") == "1"){							
										var flag=1;
									}
								}
								if (objRecArr.length>0&&flag==1){
									Ext.MessageBox.confirm('删除', '是否删除选中数据记录?', function(btn,text){
										if(btn=="yes"){
											for (var indRec = 0; indRec < objRecArr.length; indRec++){
												var objRec = objRecArr[indRec];
												if(objRec.get("IsChecked") == "0") //Add By LiYang 2014-07-03 FixBug: 1683 
													continue;												
												if (objRec.get('SubID')) {
													var RecID = objRec.get('RepID') + '||' + objRec.get('SubID');
													var flg = obj.ClsInfReportICUSrv.DelSubRec(objRec.get('RepID') + '||' + objRec.get('SubID'));
													if (parseInt(flg) > 0) {
														objGrid.getStore().remove(objRec);
													} else {
														ExtTool.alert("错误提示","删除导尿管信息错误!error=" + flg);
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
			],
			viewConfig : {
				forceFit : true
			}
		});
		
		return tmpGridPanel;
	}
	obj.IUC_gridUC = obj.IUC_GridToUC("IUC_gridUC");
	
	//双击行触发事件
	obj.IUC_gridUC.on('rowdblclick',function(){
		var rowIndex = arguments[1];
		var objRec = this.getStore().getAt(rowIndex);
		obj.IUC_GridRowEditer(objRec);
	});
	//单击单元格触发事件
	obj.IUC_gridUC.on('cellclick',function(grid, rowIndex, columnIndex, e){
		var objRec = grid.getStore().getAt(rowIndex);
		var fieldName = grid.getColumnModel().getDataIndex(columnIndex);
		if (fieldName != 'IsChecked') return;
		
		var recValue = objRec.get('IsChecked');
		if (recValue == '1') {
			var newValue = '0';
		} else {
			var newValue = '1';
		}
		objRec.set('IsChecked', newValue);
		grid.getStore().commitChanges();
		grid.getView().refresh();
	});
	
	//界面布局
	obj.IUC_ViewPort = {
		layout : 'fit',
		//frame : true,
		height : 200,
		anchor : '-20',
		tbar : ['<b>泌尿道插管</b>'],
		items : [
			obj.IUC_gridUC
		]
	}
	
	//初始化页面
	obj.IUC_InitView = function(){
		obj.IUC_gridUC.getStore().load({});
	}
	
	//数据存储
	obj.IUC_SaveData = function(){
		var errinfo = '';
		
		var objStore = obj.IUC_gridUC.getStore();
		for (var indRec = 0; indRec < objStore.getCount(); indRec++) {
			var objRec = objStore.getAt(indRec);
			
			if (objRec.get('IsChecked') == '1') {
				//数据完整性校验
				var flg = obj.IUC_GridRowDataCheck(objRec);
				if (flg){
					var row = objStore.indexOfId(objRec.id);  //获取行号
					errinfo = errinfo + '导尿管 第' + (row + 1) + '行 数据错误!<br>'
				}
				
				var objICU = obj.ClsInfReportICUSrv.GetSubObj('');
				if (objICU) {
					if (objRec.get('RepID')&&objRec.get('SubID')) objICU.RowID = objRec.get('RepID') + '||' + objRec.get('SubID');
					objICU.DataSource = objRec.get('DataSource');
					objICU.IntubateType = obj.ClsSSDictionary.GetByTypeCode('NINFICUIntubateType','UC','');
					objICU.IntubateDate = objRec.get('IntubateDate');
					objICU.IntubateTime = objRec.get('IntubateTime');
					objICU.ExtubateDate = objRec.get('ExtubateDate');
					objICU.ExtubateTime = objRec.get('ExtubateTime');
					objICU.IntubatePlace = obj.ClsSSDictionary.GetObjById(objRec.get('IntubatePlaceID'));
					objICU.IntubateUserType = obj.ClsSSDictionary.GetObjById(objRec.get('IntubateUserTypeID'));
					objICU.IntubateUser = objRec.get('IntubateUserID');
					objICU.InfDate = objRec.get('InfDate');
					
					objICU.InfPathogeny = new Array();
					var InfPyValues = objRec.get('InfPyValues');
					InfPyValues = InfPyValues.replace(/<\$C1>/gi,CHR_1);
					InfPyValues = InfPyValues.replace(/<\$C2>/gi,CHR_2);
					var arrPy = InfPyValues.split(CHR_1);
					for (var indPy = 0; indPy < arrPy.length; indPy++) {
						var strPyField = arrPy[indPy];
						if (strPyField == '') continue;
						var arrPyField = strPyField.split(CHR_2);
						
						var objPy = new Object();
						objPy.PathogenyID = arrPyField[0]
						objPy.PathogenyDesc = arrPyField[1]
						if (!arrPyField[1]) continue;
						
						objICU.InfPathogeny.push(objPy);
					}
					
					objICU.UCUrineBagType = obj.ClsSSDictionary.GetObjById(objRec.get('UCUrineBagTypeID'));
					obj.CurrReport.ChildICU.push(objICU);
				}
			} else {
				if (objRec.get('SubID') != '') {
					var RecID = objRec.get('RepID') + '||' + objRec.get('SubID');
					var flg = obj.ClsInfReportICUSrv.DelSubRec(RecID);
					if (parseInt(flg) > 0) {
						//删除成功
					} else {
						ExtTool.alert("错误提示","删除导尿管信息错误!error=" + flg);
					}
				}
			}
		}
		
		return errinfo;
	}
	
	return obj;
}