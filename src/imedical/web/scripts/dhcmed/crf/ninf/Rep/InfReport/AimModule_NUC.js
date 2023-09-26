	
function InitNUC(obj)
{
	//置管时间
	obj.NUC_txtIntubateDateTime = Common_DateFieldToDateTime("NUC_txtIntubateDateTime","置管时间");
	
	//拔管时间
	obj.NUC_txtExtubateDateTime = Common_DateFieldToDateTime("NUC_txtExtubateDateTime","拔管时间");
	
	//是否感染
	obj.NUC_chkIsInf = Common_Checkbox("NUC_chkIsInf","是否感染");
	obj.NUC_chkIsInf.on('check',function(checkbox,value){
		var objItem1 = Ext.getCmp("NUC_txtInfDate");
		if (objItem1) {
			objItem1.setDisabled((!value));
		}
		var objItem1 = Ext.getCmp("NUC_cboInfPy");
		if (objItem1) {
			objItem1.setDisabled((!value));
		}
		if (!value) {
			Common_SetValue('NUC_txtInfDate','');
			Common_SetValue('NUC_cboInfPy','','');
		}
	},obj.NUC_chkIsInf);
	
	//感染日期
	obj.NUC_txtInfDate = Common_DateFieldToDate("NUC_txtInfDate","感染日期");
	
	//病原体
	obj.NUC_cboInfPy = Common_ComboToPathogeny("NUC_cboInfPy","病原体");
	
	//行编辑
	obj.NUC_GridRowViewPort = {
		layout : 'form',
		labelAlign : 'right',
		labelWidth : 60,
		frame : true,
		items : [
			obj.NUC_txtIntubateDateTime
			,obj.NUC_txtExtubateDateTime
			,obj.NUC_chkIsInf
			,obj.NUC_txtInfDate
			,obj.NUC_cboInfPy
		]
	}
	
	obj.NUC_GridRowDataCheck = function(objRec){
		var errInfo = '';
		if (objRec) {
			var NUC_txtIntubateDateTime = objRec.get('IntubateDateTime');
			if (NUC_txtIntubateDateTime=='') {
				errInfo = errInfo + '置管时间未填!';
			}
			var NUC_txtExtubateDateTime = objRec.get('ExtubateDateTime');
			if (NUC_txtExtubateDateTime=='') {
				//errInfo = errInfo + '拔管时间未填!';
			}
			var NUC_txtInfDate = Common_GetValue('InfDate');
		} else {
			var NUC_txtIntubateDateTime = Common_GetValue('NUC_txtIntubateDateTime');
			if (NUC_txtIntubateDateTime=='') {
				errInfo = errInfo + '置管时间未填!';
			}
			var NUC_txtExtubateDateTime = Common_GetValue('NUC_txtExtubateDateTime');
			if (NUC_txtExtubateDateTime=='') {
				//errInfo = errInfo + '拔管时间未填!';
			}
			var NUC_txtInfDate = Common_GetValue('NUC_txtInfDate');
		}
		
		var today = new Date();
		var CurrDate = today.getYear() + "-" + (today.getMonth() + 1) + "-" + today.getDate();
		if (NUC_txtIntubateDateTime != '') {
			var IntubateDate = NUC_txtIntubateDateTime.split(" ")[0];
			//var flg = Common_CompareDate(IntubateDate,CurrDate);
			//if (!flg) errInfo = errInfo + '置管日期大于当前日期!<br>'
			
			var objPaadm = obj.CurrPaadm;
			var flg = Common_CompareDate(objPaadm.AdmitDate,IntubateDate);
			if (!flg) errInfo = errInfo + '置管日期小于入院日期!<br>'
			
			if (objPaadm.DisDate) {
				var flg = Common_CompareDate(IntubateDate,objPaadm.DisDate);
				if (!flg) errInfo = errInfo + '置管日期大于出院日期!<br>'
			}
			
			var InfDate = NUC_txtInfDate;
			if (InfDate) {
				var flg = Common_CompareDate(IntubateDate,InfDate);
				if (!flg) errInfo = errInfo + '置管日期大于感染日期!<br>'
			}
			
			if (NUC_txtExtubateDateTime != '') {
				var ExtubateDate = NUC_txtExtubateDateTime.split(" ")[0];
				var flg = Common_CompareDate(IntubateDate,ExtubateDate);
				if (!flg) errInfo = errInfo + '拔管日期大于置管日期!<br>'
				
				var flg = Common_CompareDate(ExtubateDate,CurrDate);
				if (!flg) errInfo = errInfo + '拔管日期大于当前日期!<br>'
				
				var flg = Common_CompareDate(objPaadm.AdmitDate,ExtubateDate);
				if (!flg) errInfo = errInfo + '拔管日期小于入院日期!<br>'
				
				if (objPaadm.DisDate) {
					var flg = Common_CompareDate(ExtubateDate,objPaadm.DisDate);
					if (!flg) errInfo = errInfo + '拔管日期大于出院日期!<br>'
				}
				
				var InfDate = NUC_txtInfDate;
				if (InfDate) {
					var flg = Common_CompareDate(InfDate,ExtubateDate);
					if (!flg) errInfo = errInfo + '感染日期大于拔管日期!<br>'
				}
			}
		}
		
		return errInfo;
	}
	
	obj.NUC_GridRowDataSave = function(objRec){
		var IntubateDateTime = Common_GetValue('NUC_txtIntubateDateTime');
		var arrDateTime = IntubateDateTime.split(' ');
		if (arrDateTime.length>1){
			var IntubateDate = arrDateTime[0];
			var IntubateTime = arrDateTime[1];
		} else {
			var IntubateDate = '';
			var IntubateTime = '';
		}
		var ExtubateDateTime = Common_GetValue('NUC_txtExtubateDateTime');
		var arrDateTime = ExtubateDateTime.split(' ');
		if (arrDateTime.length>1){
			var ExtubateDate = arrDateTime[0];
			var ExtubateTime = arrDateTime[1];
		} else {
			var ExtubateDate = '';
			var ExtubateTime = '';
		}
		var InfDate = Common_GetValue('NUC_txtInfDate');
		var IsInfection = (InfDate != '' ? '是' : '否');
		var InfPyID = Common_GetValue('NUC_cboInfPy');
		var InfPyDesc = Common_GetText('NUC_cboInfPy');
		var InfPyValue = InfPyID + CHR_2 + InfPyDesc;
		
		if (objRec) {      //提交数据
			objRec.set('IntubateDate',IntubateDate);
			objRec.set('IntubateTime',IntubateTime);
			objRec.set('IntubateDateTime',IntubateDateTime);
			objRec.set('ExtubateDate',ExtubateDate);
			objRec.set('ExtubateTime',ExtubateTime);
			objRec.set('ExtubateDateTime',ExtubateDateTime);
			objRec.set('IsInfection',IsInfection);
			objRec.set('InfDate',InfDate);
			objRec.set('InfPyIDs',InfPyID);
			objRec.set('InfPyDescs',InfPyDesc);
			objRec.set('InfPyValues',InfPyValue);
			objRec.commit();
		} else {                 //插入数据
			var objGrid = Ext.getCmp('NUC_gridNUC');
			if (objGrid){
				var objStore = objGrid.getStore();
				var RecordType = objStore.recordType;
				var RecordData = new RecordType({
					RepID : obj.CurrReport.RowID
					,SubID : ''
					,IntubateDate : IntubateDate
					,IntubateTime : IntubateTime
					,IntubateDateTime : IntubateDateTime
					,ExtubateDate : ExtubateDate
					,ExtubateTime : ExtubateTime
					,ExtubateDateTime : ExtubateDateTime
					,IsInfection : IsInfection
					,InfDate : InfDate
					,InfPyIDs : InfPyID
					,InfPyDescs : InfPyDesc
					,InfPyValues : InfPyValue
				});
				objStore.insert(objStore.getCount(), RecordData);
				objGrid.getView().focusRow(objGrid.getStore().getCount()-1);
			}
		}
	}
	
	obj.NUC_GridRowDataSet = function(objRec) {
		if (objRec){
			Common_SetValue('NUC_txtIntubateDateTime',objRec.get('IntubateDateTime'));
			Common_SetValue('NUC_txtExtubateDateTime',objRec.get('ExtubateDateTime'));
			
			//是否感染,感染日期,病原体
			Common_SetValue('NUC_chkIsInf',(objRec.get('IsInfection')=='是'));
			Common_SetValue('NUC_txtInfDate',objRec.get('InfDate'));
			var strInfPyValues = objRec.get('InfPyValues');
			strInfPyValues = strInfPyValues.replace(/<\$C1>/gi,CHR_1);
			strInfPyValues = strInfPyValues.replace(/<\$C2>/gi,CHR_2);
			var arrInfPyValues = strInfPyValues.split(CHR_1);
			if (arrInfPyValues.length > 0) {
				var strInfPyValue = arrInfPyValues[0];
				var arrInfPyValue = strInfPyValue.split(CHR_2);
				if (arrInfPyValue.length >= 2) {
					Common_SetValue('NUC_cboInfPy',arrInfPyValue[0],arrInfPyValue[1]);
				}
			} else {
				Common_SetValue('NUC_cboInfPy','','');
			}
			var objItem1 = Ext.getCmp("NUC_txtInfDate");
			if (objItem1) {
				objItem1.setDisabled((objRec.get('IsInfection')!='是'));
			}
			var objItem1 = Ext.getCmp("NUC_cboInfPy");
			if (objItem1) {
				objItem1.setDisabled((objRec.get('IsInfection')!='是'));
			}
		} else {
			Common_SetValue('NUC_txtIntubateDateTime','');
			Common_SetValue('NUC_txtExtubateDateTime','');
			Common_SetValue('NUC_chkIsInf','');
			Common_SetValue('NUC_txtInfDate','');
			Common_SetValue('NUC_cboInfPy','','');
			var objItem1 = Ext.getCmp("NUC_txtInfDate");
			if (objItem1) {
				objItem1.setDisabled(true);
			}
			var objItem1 = Ext.getCmp("NUC_cboInfPy");
			if (objItem1) {
				objItem1.setDisabled(true);
			}
		}
	}
	
	obj.NUC_GridRowEditer = function(objRec){
		obj.NUC_GridRowEditer_objRec = objRec;
		var winGridRowEditer = Ext.getCmp('NUC_GridRowEditer');
		if (!winGridRowEditer){
			winGridRowEditer = new Ext.Window({
				id : 'NUC_GridRowEditer',
				height : 240,
				closeAction: 'hide',
				width : 300,
				modal : true,
				title : 'NICU-脐静脉 编辑',
				layout : 'fit',
				frame : true,
				items: [
					obj.NUC_GridRowViewPort
				],
				bbar : [
					'->',
					new Ext.Toolbar.Button({
						id: "NUC_GridRowEditer_btnUpdate",
						width : 80,
						text : "<img SRC='../scripts/dhcmed/img/update.gif'>保存",
						listeners : {
							'click' : function(){
								var errInfo = obj.NUC_GridRowDataCheck('');
								if (errInfo){
									ExtTool.alert("提示",errInfo);
									return;
								}
								obj.NUC_GridRowDataSave(obj.NUC_GridRowEditer_objRec);
								winGridRowEditer.hide();
							}
						}
					}),
					new Ext.Toolbar.Button({
						id: "NUC_GridRowEditer_btnCancel",
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
		obj.NUC_GridRowDataSet(objRec);
	}
	
	//主列表
	obj.NUC_GridToNUC = function() {
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
							param.Arg3      = 'NUC';
							param.ArgCnt    = 3;
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
						,{name: 'IntubateTypeID', mapping: 'IntubateTypeID'}
						,{name: 'IntubateTypeDesc', mapping: 'IntubateTypeDesc'}
						,{name: 'IntubateDate', mapping: 'IntubateDate'}
						,{name: 'IntubateTime', mapping: 'IntubateTime'}
						,{name: 'IntubateDateTime', mapping: 'IntubateDateTime'}
						,{name: 'ExtubateDate', mapping: 'ExtubateDate'}
						,{name: 'ExtubateTime', mapping: 'ExtubateTime'}
						,{name: 'ExtubateDateTime', mapping: 'ExtubateDateTime'}
						,{name: 'IsInfection', mapping: 'IsInfection'}
						,{name: 'InfDate', mapping: 'InfDate'}
						,{name: 'InfPyIDs', mapping: 'InfPyIDs'}
						,{name: 'InfPyDescs', mapping: 'InfPyDescs'}
						,{name: 'InfPyValues', mapping: 'InfPyValues'}
					]
				)
			})
			,height : 120
			//,overflow:'scroll'
			//,overflow-y:hidden
			//,style:'overflow:auto;overflow-y:hidden'
			//,loadMask : true
			,frame : true
			,anchor : '100%'
			,columns: [
				new Ext.grid.RowNumberer()
				,{header: '置管时间', width: 150, dataIndex: 'IntubateDateTime', sortable: false, menuDisabled:true, align:'center' }
				,{header: '拔管时间', width: 150, dataIndex: 'ExtubateDateTime', sortable: false, menuDisabled:true, align:'center' }
				,{header: '是否感染', width: 100, dataIndex: 'IsInfection', sortable: false, menuDisabled:true, align:'center' }
				,{header: '感染日期', width: 100, dataIndex: 'InfDate', sortable: false, menuDisabled:true, align:'center' }
				,{header: '病原体', width: 240, dataIndex: 'InfPyDescs', sortable: false, menuDisabled:true, align:'center' }
			],
			bbar : [
				new Ext.Toolbar.Button({
					id: arguments[0] + "_btnAdd",
					width : 80,
					text : "<img SRC='../scripts/dhcmed/img/add.png'>增加",
					listeners : {
						'click' : function(){
							obj.NUC_GridRowEditer("");
						}
					}
				}),
				new Ext.Toolbar.Button({
					id: arguments[0] + "_btnDelete",
					width : 80,
					text : "<img SRC='../scripts/dhcmed/img/delete.gif'>删除",
					listeners : {
						'click' : function(){
							var objGrid = Ext.getCmp("NUC_gridNUC");
							if (objGrid){
								//var objRecArr = objGrid.getSelectionModel().getSelections();
								var objRecArr = objGrid.getStore().getRange(); //Modified By LiYang 2014-07-03 FixBug:1776 公共卫生事件-医院感染报告-ICU感染监测，添加中心静脉置管记录后，直接点击【删除】按钮，提示"请选中数据记录，再点击删除！"
								if (objRecArr.length>0){
									Ext.MessageBox.confirm('删除', '是否删除选中数据记录?', function(btn,text){
										if(btn=="yes"){
											for (var indRec = 0; indRec < objRecArr.length; indRec++){
												var objRec = objRecArr[indRec];
												if (objRec.get('SubID')) {
													var RecID = objRec.get('RepID') + '||' + objRec.get('SubID');
													var flg = obj.ClsInfReportICUSrv.DelSubRec(objRec.get('RepID') + '||' + objRec.get('SubID'));
													if (parseInt(flg) > 0) {
														objGrid.getStore().remove(objRec);
													} else {
														ExtTool.alert("错误提示","删除气管插管信息错误!error=" + flg);
													}
												} else {
													objGrid.getStore().remove(objRec);
												}
											}
											objGrid.getStore().load({});
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
	obj.NUC_gridNUC = obj.NUC_GridToNUC("NUC_gridNUC");
	
	//界面布局
	obj.NUC_ViewPort = {
		layout : 'fit',
		//frame : true,
		height : 200,
		anchor : '-20',
		tbar : ['<b>NICU-脐静脉</b>'],
		items : [
			obj.NUC_gridNUC
		]
	}
	
	//初始化页面
	obj.NUC_InitView = function(){
		var objGrid = Ext.getCmp("NUC_gridNUC");
		if (objGrid){
			objGrid.getStore().load({});
			objGrid.on('rowdblclick',function(){
				var rowIndex = arguments[1];
				var objRec = this.getStore().getAt(rowIndex);
				obj.NUC_GridRowEditer(objRec);
			},objGrid);
		}
	}
	
	//数据存储
	obj.NUC_SaveData = function(){
		var errinfo = '';
		
		var objCmp = Ext.getCmp('NUC_gridNUC');
		if (objCmp) {
			var objStore = objCmp.getStore();
			for (var indRec = 0; indRec < objStore.getCount(); indRec++) {
				var objRec = objStore.getAt(indRec);
				
				//数据完整性校验
				var flg = obj.NUC_GridRowDataCheck(objRec);
				if (flg){
					var row = objStore.indexOfId(objRec.id);  //获取行号
					errinfo = errinfo + '呼吸机 第' + (row + 1) + '行 数据错误!<br>'
				}
				
				var objICU = obj.ClsInfReportICUSrv.GetSubObj('');
				if (objICU) {
					if (objRec.get('RepID')&&objRec.get('SubID')) objICU.RowID = objRec.get('RepID') + '||' + objRec.get('SubID');
					objICU.IntubateType = obj.ClsSSDictionary.GetByTypeCode('NINFICUIntubateType','NUC','');
					objICU.IntubateDate = objRec.get('IntubateDate');
					objICU.IntubateTime = objRec.get('IntubateTime');
					objICU.ExtubateDate = objRec.get('ExtubateDate');
					objICU.ExtubateTime = objRec.get('ExtubateTime');
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
					
					obj.CurrReport.ChildICU.push(objICU);
				}
			}
		}
		
		return errinfo;
	}
	
	return obj;
}