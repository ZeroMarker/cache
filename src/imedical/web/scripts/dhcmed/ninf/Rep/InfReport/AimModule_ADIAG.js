
function InitADIAG(obj)
{
	//行编辑
	obj.ADIAG_GridRowEditer_cboDiagnos = Common_ComboToMRCICDDx("ADIAG_GridRowEditer_cboDiagnos","基础疾病");
	obj.ADIAG_GridRowViewPort = {
		layout : 'form',
		labelAlign : 'right',
		labelWidth : 90,
		frame : true,
		items : [
			obj.ADIAG_GridRowEditer_cboDiagnos
		]
	}
	obj.ADIAG_GridRowDataCheck = function(objRec){
		var errInfo = '';
		
		if (objRec) {
			var ADIAG_DiagnosDesc = objRec.get('DiagnosDesc');
			if (ADIAG_DiagnosDesc=='') {
				errInfo = errInfo + '基础疾病未填!';
			}
		} else {
			var ADIAG_DiagnosDesc = Common_GetValue('ADIAG_GridRowEditer_cboDiagnos');
			if (ADIAG_DiagnosDesc=='') {
				errInfo = errInfo + '基础疾病未填!';
			}
		}
		
		return errInfo;
	}
	obj.ADIAG_GridRowDataSave = function(objRec){
		var DiagnosID = Common_GetValue('ADIAG_GridRowEditer_cboDiagnos');
		var DiagnosDesc = Common_GetText('ADIAG_GridRowEditer_cboDiagnos');
		
		if (objRec) {      //提交数据
			objRec.set('DiagnosID',DiagnosID);
			objRec.set('DiagnosDesc',DiagnosDesc);
			objRec.commit();
		} else {                 //插入数据
			var objGrid = Ext.getCmp('ADIAG_gridDiag');
			if (objGrid){
				var objStore = objGrid.getStore();
				var RecordType = objStore.recordType;
				var RecordData = new RecordType({
					RepID : obj.CurrReport.RowID
					,SubID : ''
					,DiagnosID : DiagnosID
					,DiagnosDesc : DiagnosDesc
					,DiagnosDate : ''
					,DiagnosTime : ''
					,DataSource : ''
				});
				objStore.insert(objStore.getCount(), RecordData);
				objGrid.getView().focusRow(objGrid.getStore().getCount()-1);
			}
		}
	}
	obj.ADIAG_GridRowDataSet = function(objRec){
		if (objRec){
			Common_SetValue('ADIAG_GridRowEditer_cboDiagnos',objRec.get('DiagnosID'),objRec.get('DiagnosDesc'));
		} else {
			Common_SetValue('ADIAG_GridRowEditer_cboDiagnos','','');
		}
	}
	obj.ADIAG_GridRowEditer = function(objRec) {
		obj.ADIAG_GridRowEditer_objRec = objRec;
		var winGridRowEditer = Ext.getCmp('ADIAG_GridRowEditer');
		if (!winGridRowEditer){
			winGridRowEditer = new Ext.Window({
				id : 'ADIAG_GridRowEditer',
				height : 120,
				closeAction: 'hide',
				width : 400,
				modal : true,
				title : '基础疾病-编辑',
				layout : 'fit',
				frame : true,
				items: [
					obj.ADIAG_GridRowViewPort
				],
				buttons : [
					'->',
					new Ext.Toolbar.Button({
						id: "ADIAG_GridRowEditer_btnUpdate",
						width : 80,
						text : "确定",
						iconCls : 'icon-update',
						listeners : {
							'click' : function(){
								var errInfo = obj.ADIAG_GridRowDataCheck('');
								if (errInfo){
									ExtTool.alert("提示",errInfo);
									return;
								}
								obj.ADIAG_GridRowDataSave(obj.ADIAG_GridRowEditer_objRec);
								winGridRowEditer.hide();
							}
						}
					}),
					new Ext.Toolbar.Button({
						id: "ADIAG_GridRowEditer_btnCancel",
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
		obj.ADIAG_GridRowDataSet(objRec);
	}
	
	//提取框
	obj.ADIAG_GridExtract_gridDiag = new Ext.grid.GridPanel({
		id: 'ADIAG_GridExtract_gridDiag',
		store : new Ext.data.Store({
			proxy: new Ext.data.HttpProxy({
				url : ExtToolSetting.RunQueryPageURL,
				listeners : {
					'beforeload' :  function(objProxy, param){
						param.ClassName = 'DHCMed.NINFService.Rep.InfReportDiag';
						param.QueryName = 'QrySubRec';
						param.Arg1      = '';
						param.Arg2      = obj.CurrReport.EpisodeID;
						param.Arg3      = 'BASE';
						param.ArgCnt    = 3;
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
					,{name: 'DiagnosID', mapping: 'DiagnosID'}
					,{name: 'DiagnosDesc', mapping: 'DiagnosDesc'}
					,{name: 'DiagnosDate', mapping: 'DiagnosDate'}
					,{name: 'DiagnosTime', mapping: 'DiagnosTime'}
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
			,{header: '疾病名称', width: 150, dataIndex: 'DiagnosDesc', sortable: false, menuDisabled:true, align:'center' }
			,{header: '诊断日期', width: 80, dataIndex: 'DiagnosDate', sortable: false, menuDisabled:true, align:'center' }
			,{header: '诊断时间', width: 60, dataIndex: 'DiagnosTime', sortable: false, menuDisabled:true, align:'center' }
			,{header: '数据来源', width: 60, dataIndex: 'DataSource', sortable: false, menuDisabled:true, align:'center' }
		],
		viewConfig : {
			forceFit : true
		}
	});
	obj.ADIAG_GridExtract = function() {
		var winGridRowEditer = Ext.getCmp('ADIAG_GridExtract');
		if (!winGridRowEditer){
			winGridRowEditer = new Ext.Window({
				id : 'ADIAG_GridExtract',
				height : 300,
				closeAction: 'hide',
				width : 500,
				modal : true,
				title : '基础疾病-提取',
				layout : 'fit',
				frame : true,
				items: [
					obj.ADIAG_GridExtract_gridDiag
				],
				buttons : [
					'->',
					new Ext.Toolbar.Button({
						id: "ADIAG_GridExtract_btnUpdate",
						width : 80,
						text : "确定",
						iconCls : 'icon-update',
						listeners : {
							'click' : function(){
								var objRowDataGrid = Ext.getCmp('ADIAG_GridExtract_gridDiag');
								var objGrid = Ext.getCmp('ADIAG_gridDiag');
								if ((objRowDataGrid)&&(objGrid)) {
									var arrSelections = new Array();
									function insertfun(){
										var objStore = objGrid.getStore();
										var arrRec = objRowDataGrid.getSelectionModel().getSelections();
										var rowbreak = -1;
										for (var indRec = 0; indRec < arrRec.length; indRec++){
											var objRec = arrRec[indRec];
											
											//检查是否存在相同基础疾病,或相同数据来源数据
											var isBoolean = false;
											for (var indStore = 0; indStore < objStore.getCount(); indStore++) {
												var tmpRec = objStore.getAt(indStore);
												if (tmpRec.get('DiagnosDesc') == objRec.get('DiagnosDesc')) {
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
												,DiagnosID : objRec.get('DiagnosID')
												,DiagnosDesc : objRec.get('DiagnosDesc')
												,DiagnosDate : objRec.get('DiagnosDate')
												,DiagnosTime : objRec.get('DiagnosTime')
												,DataSource : objRec.get('DataSource')
											});
											
											objStore.insert(objStore.getCount(), RecordData);
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
						id: "ADIAG_GridExtract_btnCancel",
						width : 80,
						text : "取消",
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
						var objRowDataGrid = Ext.getCmp('ADIAG_GridExtract_gridDiag');
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
	obj.ADIAG_GridDiagInit = function() {
		var tmpGridPanel = new Ext.grid.GridPanel({
			id: arguments[0],
			store : new Ext.data.Store({
				proxy: new Ext.data.HttpProxy({
					url : ExtToolSetting.RunQueryPageURL,
					listeners : {
						'beforeload' :  function(objProxy, param){
							param.ClassName = 'DHCMed.NINFService.Rep.InfReportDiag';
							param.QueryName = 'QrySubRec';
							param.Arg1      = obj.CurrReport.RowID;
							param.Arg2      = obj.CurrReport.EpisodeID;
							param.Arg3      = 'BASE';
							param.ArgCnt    = 3;
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
						,{name: 'DiagnosID', mapping: 'DiagnosID'}
						,{name: 'DiagnosDesc', mapping: 'DiagnosDesc'}
						,{name: 'DiagnosDate', mapping: 'DiagnosDate'}
						,{name: 'DiagnosTime', mapping: 'DiagnosTime'}
						,{name: 'DataSource', mapping: 'DataSource'}
					]
				)
			})
			//,height : 100
			//,overflow:'scroll'
			//,overflow-y:hidden
			//,style:'overflow:auto;overflow-y:hidden'
			//,loadMask : true
			,frame : true
			,anchor : '100%'
			,columns: [
				new Ext.grid.RowNumberer()
				,{header: '疾病名称', width: 200, dataIndex: 'DiagnosDesc', sortable: false, menuDisabled:true, align:'center' }
				,{header: '诊断日期', width: 100, dataIndex: 'DiagnosDate', sortable: false, menuDisabled:true, align:'center' }
				,{header: '诊断时间', width: 100, dataIndex: 'DiagnosTime', sortable: false, menuDisabled:true, align:'center' }
				//,{header: '数据来源', width: 60, dataIndex: 'DataSource', sortable: false, menuDisabled:true, align:'center' }
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
							obj.ADIAG_GridExtract();
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
							obj.ADIAG_GridRowEditer('');
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
						//Add By zhoubo 2014-12-20 FixBug：1772:删除中心静脉置管/呼吸机/泌尿道插管/病原学检验记录,不进行提交操作，报告中的记录被删除
						if(obj.CurrReport)
						{
								//Modified By LiYang 2015-03-27 FixBug:公共卫生事件-医院感染报告-报告没有提交成功，通过【删除】按钮删除已录入的数据时，提示"“提交"状态的报告不能再删除数据”
								//再增加判断一下RowID是否为空，为空说明报告未保存，可以任意修改，否则已经提交就不能操作了
								//if(obj.CurrReport.ReportStatus){
								if((obj.CurrReport.ReportStatus)&&(obj.CurrReport.RowID != "")){
								if((obj.CurrReport.ReportStatus.Code == "2")||(obj.CurrReport.ReportStatus.Code == "3")||(obj.CurrReport.ReportStatus.Code == "0"))
								{
									ExtTool.alert("错误提示", "“" + obj.CurrReport.ReportStatus.Description + "”状态的报告不能再删除项目！");
									return;
								}
							}
						}
							var objGrid = Ext.getCmp("ADIAG_gridDiag");
							if (objGrid){
								var arrRec = objGrid.getSelectionModel().getSelections();
								if (arrRec.length>0){
									Ext.MessageBox.confirm('删除', '是否删除选中数据记录?', function(btn,text){
										if(btn=="yes"){
											for (var indRec = 0; indRec < arrRec.length; indRec++){
												var objRec = arrRec[indRec];
												if (objRec.get('SubID')) {
													var RecID = objRec.get('RepID') + '||' + objRec.get('SubID');
													var flg = obj.ClsInfReportDiagSrv.DelSubRec(objRec.get('RepID') + '||' + objRec.get('SubID'));
													if (parseInt(flg) > 0) {
														objGrid.getStore().remove(objRec);
													} else {
														ExtTool.alert("错误提示","删除基础疾病错误!error=" + flg);
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
	obj.ADIAG_gridDiag = obj.ADIAG_GridDiagInit("ADIAG_gridDiag");
	
	//界面布局
	obj.ADIAG_ViewPort = {
		id : 'ADIAGViewPort',
		layout : 'fit',
		//frame : true,
		height : 200,
		anchor : '-20',
		tbar : ['<img SRC="../scripts/dhcmed/img/DiseaseInfo.png"><b style="font-size:16px;">基础疾病</b>'],
		items : [
			obj.ADIAG_gridDiag
		]
	}
	
	//初始化页面
	obj.ADIAG_InitView = function(){
		var objGrid = Ext.getCmp("ADIAG_gridDiag");
		if (objGrid){
			objGrid.getStore().load({});
			objGrid.on('rowdblclick',function(){
				var rowIndex = arguments[1];
				var objRec = this.getStore().getAt(rowIndex);
				obj.ADIAG_GridRowEditer(objRec);
			},objGrid);
		}
	}
	
	//数据存储
	obj.ADIAG_SaveData = function(){
		var errinfo = '';
		
		var objCmp = Ext.getCmp('ADIAG_gridDiag');
		if (objCmp) {
			var objStore = objCmp.getStore();
			for (var indRec = 0; indRec < objStore.getCount(); indRec++) {
				var objRec = objStore.getAt(indRec);
				
				//数据完整性校验
				var flg = obj.ADIAG_GridRowDataCheck(objRec);
				if (flg){
					var row = objStore.indexOfId(objRec.id);  //获取行号
					errinfo = errinfo + '基础疾病 第' + (row + 1) + '行 数据错误!<br>'
				}
				
				var objDiag = obj.ClsInfReportDiagSrv.GetSubObj('');
				if (objDiag) {
					if (objRec.get('RepID')&&objRec.get('SubID')) objDiag.RowID = objRec.get('RepID') + '||' + objRec.get('SubID');
					objDiag.DataSource = objRec.get('DataSource');
					objDiag.DiagnosID = objRec.get('DiagnosID');
					objDiag.DiagnosDesc = objRec.get('DiagnosDesc');
					objDiag.DiagnosDate = objRec.get('DiagnosDate');
					objDiag.DiagnosTime = objRec.get('DiagnosTime');
					objDiag.DiagnosType = obj.ClsSSDictionary.GetByTypeCode('NINFInfDiagnosType','BASE','');
					obj.CurrReport.ChildDiag.push(objDiag);
				}
			}
		}
		
		return errinfo;
	}
	
	return obj;
}