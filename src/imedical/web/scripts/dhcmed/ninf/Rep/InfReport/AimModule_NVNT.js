	
function InitNVNT(obj)
{
	//置管时间
	obj.NVNT_txtIntubateDateTime = Common_DateFieldToDateTime("NVNT_txtIntubateDateTime","置管时间");
	
	//拔管时间
	obj.NVNT_txtExtubateDateTime = Common_DateFieldToDateTime("NVNT_txtExtubateDateTime","拔管时间");
	
	//是否感染
	obj.NVNT_chkIsInf = Common_Checkbox("NVNT_chkIsInf","是否感染");
	obj.NVNT_chkIsInf.on('check',function(checkbox,value){
		var objItem1 = Ext.getCmp("NVNT_txtInfDate");
		if (objItem1) {
			objItem1.setDisabled((!value));
		}
		var objItem1 = Ext.getCmp("NVNT_cboInfPy");
		if (objItem1) {
			objItem1.setDisabled((!value));
		}
		if (!value) {
			Common_SetValue('NVNT_txtInfDate','');
			Common_SetValue('NVNT_cboInfPy','','');
		}
	},obj.NVNT_chkIsInf);
	
	//感染日期
	obj.NVNT_txtInfDate = Common_DateFieldToDate("NVNT_txtInfDate","感染日期");
	
	//病原体
	obj.NVNT_cboInfPy = Common_ComboToPathogeny("NVNT_cboInfPy","病原体");
	
	//行编辑
	obj.NVNT_GridRowViewPort = {
		layout : 'form',
		labelAlign : 'right',
		labelWidth : 60,
		frame : true,
		items : [
			obj.NVNT_txtIntubateDateTime
			,obj.NVNT_txtExtubateDateTime
			,obj.NVNT_chkIsInf
			,obj.NVNT_txtInfDate
			,obj.NVNT_cboInfPy
		]
	}
	
	obj.NVNT_GridRowDataCheck = function(objRec){
		var errInfo = '';
		if (objRec) {
			var NVNT_txtIntubateDateTime = objRec.get('IntubateDateTime');
			if (NVNT_txtIntubateDateTime=='') {
				errInfo = errInfo + '置管时间未填!';
			}
			var NVNT_txtExtubateDateTime = objRec.get('ExtubateDateTime');
			if (NVNT_txtExtubateDateTime=='') {
				//errInfo = errInfo + '拔管时间未填!';
			}
			var NVNT_txtInfDate = Common_GetValue('InfDate');
		} else {
			var NVNT_txtIntubateDateTime = Common_GetValue('NVNT_txtIntubateDateTime');
			if (NVNT_txtIntubateDateTime=='') {
				errInfo = errInfo + '置管时间未填!';
			}
			var NVNT_txtExtubateDateTime = Common_GetValue('NVNT_txtExtubateDateTime');
			if (NVNT_txtExtubateDateTime=='') {
				//errInfo = errInfo + '拔管时间未填!';
			}
			var NVNT_txtInfDate = Common_GetValue('NVNT_txtInfDate');
		}
		
		var AdmDate = Common_GetValue('NBASE_txtAdmDate');
		var DisDate = Common_GetValue('NBASE_txtDisDate');
		/*var dt1 = new Number(Date.parseDate(AdmDate, "Y-m-d H:i:s"));
		var dt2 = new Number(Date.parseDate(DisDate, "Y-m-d H:i:s"));
		var today = new Date();
		//getYear()获取当前年份(2位),getFullYear()获取完整的年份(4位,1970-????)
		var CurrDate = today.getFullYear() + "-" + (today.getMonth() + 1) + "-" + today.getDate();
		if (NVNT_txtIntubateDateTime != '') {
			var IntubateDate = NVNT_txtIntubateDateTime.split(" ")[0];
			
			var dt3 = new Number(Date.parseDate(NVNT_txtIntubateDateTime, "Y-m-d H:i"));
			if (dt3<dt1) errInfo = errInfo + '置管日期小于入院日期!<br>'
			if (dt3>dt2) errInfo = errInfo + '置管日期大于出院日期!<br>'
		
			var InfDate = NVNT_txtInfDate;
			if (InfDate) {
				var flg = Common_CompareDate(IntubateDate,InfDate);
				if (!flg) errInfo = errInfo + '置管日期大于感染日期!<br>'
			}
			
			if (NVNT_txtExtubateDateTime != '') {
				var ExtubateDate = NVNT_txtExtubateDateTime.split(" ")[0];
				
				var dt4 = new Number(Date.parseDate(NVNT_txtExtubateDateTime, "Y-m-d H:i"));
				if (dt4<dt1) errInfo = errInfo + '拔管日期小于入院日期!<br>'
				if (dt4<dt3) errInfo = errInfo + '拔管日期小于置管日期!<br>'
				if (dt4>dt2) errInfo = errInfo + '拔管日期大于出院日期!<br>'
				
				var flg = Common_CompareDate(ExtubateDate,CurrDate);
				if (!flg) errInfo = errInfo + '拔管日期大于当前日期!<br>'
				
				var InfDate = NVNT_txtInfDate;
				if (InfDate) {
					var flg = Common_CompareDate(InfDate,ExtubateDate);
					if (!flg) errInfo = errInfo + '感染日期大于拔管日期!<br>'
				}
			}
		}*/
		
		var dt1 = Common_DateParse(AdmDate); //转换为数字
		var dt2 = Common_DateParse(DisDate);
		if (NVNT_txtIntubateDateTime != '') {
			var IntubateDate = Common_DateParse(NVNT_txtIntubateDateTime.split(" ")[0]);
			
			var dt3 = Common_DateParse(NVNT_txtIntubateDateTime);
			if (dt3<dt1) errInfo = errInfo + '置管日期小于入院日期!<br>'
			if ((DisDate!="")&&(dt3>dt2)) errInfo = errInfo + '置管日期大于出院日期!<br>'
					
			if (NVNT_txtInfDate!="") {
				var InfDate = Common_DateParse(NVNT_txtInfDate);
				if (IntubateDate>InfDate) errInfo = errInfo + '置管日期大于感染日期!<br>'
			}
			
			if (NVNT_txtExtubateDateTime != '') {
				var ExtubateDate = Common_DateParse(NVNT_txtExtubateDateTime.split(" ")[0]);
				
				var dt4 = Common_DateParse(NVNT_txtExtubateDateTime);
				if (dt4<dt1) errInfo = errInfo + '拔管日期小于入院日期!<br>'
				if (dt4<dt3) errInfo = errInfo + '拔管日期小于置管日期!<br>'
				if ((DisDate!="")&&(dt4>dt2)) errInfo = errInfo + '拔管日期大于出院日期!<br>'
				
				if (Common_ComputeDays("NVNT_txtExtubateDateTime")<0) errInfo = errInfo + '拔管日期大于当前日期!<br>'
				
				if (NVNT_txtInfDate!="") {
					var InfDate = Common_DateParse(NVNT_txtInfDate);
					if (InfDate>ExtubateDate) errInfo = errInfo + '感染日期大于拔管日期!<br>'
				}
			}
		}
		
		return errInfo;
	}
	
	obj.NVNT_GridRowDataSave = function(objRec){
		var IntubateDateTime = Common_GetValue('NVNT_txtIntubateDateTime');
		var arrDateTime = IntubateDateTime.split(' ');
		if (arrDateTime.length>1){
			var IntubateDate = arrDateTime[0];
			var IntubateTime = arrDateTime[1];
		} else {
			var IntubateDate = '';
			var IntubateTime = '';
		}
		var ExtubateDateTime = Common_GetValue('NVNT_txtExtubateDateTime');
		var arrDateTime = ExtubateDateTime.split(' ');
		if (arrDateTime.length>1){
			var ExtubateDate = arrDateTime[0];
			var ExtubateTime = arrDateTime[1];
		} else {
			var ExtubateDate = '';
			var ExtubateTime = '';
		}
		var InfDate = Common_GetValue('NVNT_txtInfDate');
		var IsInfection = (InfDate != '' ? '是' : '否');
		var InfPyID = Common_GetValue('NVNT_cboInfPy');
		var InfPyDesc = Common_GetText('NVNT_cboInfPy');
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
			var objGrid = Ext.getCmp('NVNT_gridNVNT');
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
	
	obj.NVNT_GridRowDataSet = function(objRec){
		if (objRec){
			Common_SetValue('NVNT_txtIntubateDateTime',objRec.get('IntubateDateTime'));
			Common_SetValue('NVNT_txtExtubateDateTime',objRec.get('ExtubateDateTime'));
			
			//是否感染、感染日期、病原体
			Common_SetValue('NVNT_chkIsInf',(objRec.get('IsInfection')=='是'));
			Common_SetValue('NVNT_txtInfDate',objRec.get('InfDate'));
			var strInfPyValues = objRec.get('InfPyValues');
			strInfPyValues = strInfPyValues.replace(/<\$C1>/gi,CHR_1);
			strInfPyValues = strInfPyValues.replace(/<\$C2>/gi,CHR_2);
			var arrInfPyValues = strInfPyValues.split(CHR_1);
			if (arrInfPyValues.length > 0) {
				var strInfPyValue = arrInfPyValues[0];
				var arrInfPyValue = strInfPyValue.split(CHR_2);
				if (arrInfPyValue.length >= 2) {
					Common_SetValue('NVNT_cboInfPy',arrInfPyValue[0],arrInfPyValue[1]);
				}
			} else {
				Common_SetValue('NVNT_cboInfPy','','');
			}
			var objItem1 = Ext.getCmp("NVNT_txtInfDate");
			if (objItem1) {
				objItem1.setDisabled((objRec.get('IsInfection')!='是'));
			}
			var objItem1 = Ext.getCmp("NVNT_cboInfPy");
			if (objItem1) {
				objItem1.setDisabled((objRec.get('IsInfection')!='是'));
			}
		} else {
			Common_SetValue('NVNT_txtIntubateDateTime','');
			Common_SetValue('NVNT_txtExtubateDateTime','');
			Common_SetValue('NVNT_chkIsInf','');
			Common_SetValue('NVNT_txtInfDate','');
			Common_SetValue('NVNT_cboInfPy','','');
			var objItem1 = Ext.getCmp("NVNT_txtInfDate");
			if (objItem1) {
				objItem1.setDisabled(true);
			}
			var objItem1 = Ext.getCmp("NVNT_cboInfPy");
			if (objItem1) {
				objItem1.setDisabled(true);
			}
		}
	}
	
	obj.NVNT_GridRowEditer = function(objRec){
		obj.NVNT_GridRowEditer_objRec = objRec;
		var winGridRowEditer = Ext.getCmp('NVNT_GridRowEditer');
		if (!winGridRowEditer){
			winGridRowEditer = new Ext.Window({
				id : 'NVNT_GridRowEditer',
				height : 240,
				closeAction: 'hide',
				width : 300,
				modal : true,
				title : '气管插管 编辑',
				layout : 'fit',
				frame : true,
				items: [
					obj.NVNT_GridRowViewPort
				],
				buttons : [
					'->',
					new Ext.Toolbar.Button({
						id: "NVNT_GridRowEditer_btnUpdate",
						width : 80,
						text : "确定",
						iconCls : 'icon-update',
						listeners : {
							'click' : function(){
								var errInfo = obj.NVNT_GridRowDataCheck('');
								if (errInfo){
									ExtTool.alert("提示",errInfo);
									return;
								}
								obj.NVNT_GridRowDataSave(obj.NVNT_GridRowEditer_objRec);
								winGridRowEditer.hide();
							}
						}
					}),
					new Ext.Toolbar.Button({
						id: "NVNT_GridRowEditer_btnCancel",
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
		obj.NVNT_GridRowDataSet(objRec);
	}
	
	//主列表
	obj.NVNT_GridToNVNT = function(){
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
							param.Arg3      = 'NVNT';
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
			buttonAlign : 'left',
			buttons : [
				new Ext.Toolbar.Button({
					id: arguments[0] + "_btnAdd",
					width : 80,
					text : "增加",
					iconCls : 'icon-add',
					listeners : {
						'click' : function(){
							obj.NVNT_GridRowEditer("");
						}
					}
				}),
				new Ext.Toolbar.Button({
					id: arguments[0] + "_btnDelete",
					width : 80,
					text : "删除",
					iconCls : 'icon-delete',
					listeners : {
						'click' : function(){
							var objGrid = Ext.getCmp("NVNT_gridNVNT");
							if (objGrid){
								var objRecArr = objGrid.getSelectionModel().getSelections(); //modify by mxp 20160930 Fixbug:269750 不管选中哪条记录 都删除所有
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
											//objGrid.getStore().load({});  //modify by mxp 20160930 Fixbug:269747 未提交状态下不管是否选中记录 点击“删除”清空所有记录
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
	obj.NVNT_gridNVNT = obj.NVNT_GridToNVNT("NVNT_gridNVNT");
	
	//界面布局
	obj.NVNT_ViewPort = {
		id : 'NVNTViewPort',
		layout : 'fit',
		//frame : true,
		height : 200,
		anchor : '-20',
		tbar : ['<img SRC="../scripts/dhcmed/img/vnt.png"><b style="font-size:16px;">NICU-气管插管</b>'],
		items : [
			obj.NVNT_gridNVNT
		]
	}
	
	//初始化页面
	obj.NVNT_InitView = function(){
		var objGrid = Ext.getCmp("NVNT_gridNVNT");
		if (objGrid){
			objGrid.getStore().load({});
			objGrid.on('rowdblclick',function(){
				var rowIndex = arguments[1];
				var objRec = this.getStore().getAt(rowIndex);
				obj.NVNT_GridRowEditer(objRec);
			},objGrid);
		}
	}
	
	//数据存储
	obj.NVNT_SaveData = function(){
		var errinfo = '';
		
		var objCmp = Ext.getCmp('NVNT_gridNVNT');
		if (objCmp) {
			var objStore = objCmp.getStore();
			for (var indRec = 0; indRec < objStore.getCount(); indRec++) {
				var objRec = objStore.getAt(indRec);
				
				//数据完整性校验
				var flg = obj.NVNT_GridRowDataCheck(objRec);
				if (flg){
					var row = objStore.indexOfId(objRec.id);  //获取行号
					errinfo = errinfo + '呼吸机 第' + (row + 1) + '行 数据错误!<br>'
				}
				
				var objICU = obj.ClsInfReportICUSrv.GetSubObj('');
				if (objICU) {
					if (objRec.get('RepID')&&objRec.get('SubID')) objICU.RowID = objRec.get('RepID') + '||' + objRec.get('SubID');
					objICU.IntubateType = obj.ClsSSDictionary.GetByTypeCode('NINFICUIntubateType','NVNT','');
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