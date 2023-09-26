
function InitIDIAG(obj)
{
	//�б༭
	obj.IDIAG_GridRowEditer_cboDiagnos = Common_ComboToMRCICDDx("IDIAG_GridRowEditer_cboDiagnos","ת��ICU���");
	obj.IDIAG_GridRowViewPort = {
		layout : 'form',
		labelAlign : 'right',
		labelWidth : 90,
		frame : true,
		items : [
			obj.IDIAG_GridRowEditer_cboDiagnos
		]
	}
	obj.IDIAG_GridRowDataCheck = function(objRec){
		var errInfo = '';
		
		if (objRec) {
			var IDIAG_DiagnosDesc = objRec.get('DiagnosDesc');
			if (IDIAG_DiagnosDesc=='') {
				errInfo = errInfo + 'ת��ICU���δ��!';
			}
		} else {
			var IDIAG_DiagnosDesc = Common_GetValue('IDIAG_GridRowEditer_cboDiagnos');
			if (IDIAG_DiagnosDesc=='') {
				errInfo = errInfo + 'ת��ICU���δ��!';
			}
		}
		
		return errInfo;
	}
	obj.IDIAG_GridRowDataSave = function(objRec){
		var DiagnosID = Common_GetValue('IDIAG_GridRowEditer_cboDiagnos');
		var DiagnosDesc = Common_GetText('IDIAG_GridRowEditer_cboDiagnos');
		
		if (objRec) {      //�ύ����
			objRec.set('DiagnosID',DiagnosID);
			objRec.set('DiagnosDesc',DiagnosDesc);
			objRec.commit();
		} else {                 //��������
			var objGrid = Ext.getCmp('IDIAG_gridDiag');
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
	obj.IDIAG_GridRowDataSet = function(objRec){
		if (objRec){
			Common_SetValue('IDIAG_GridRowEditer_cboDiagnos',objRec.get('DiagnosID'),objRec.get('DiagnosDesc'));
		} else {
			Common_SetValue('IDIAG_GridRowEditer_cboDiagnos','','');
		}
	}
	obj.IDIAG_GridRowEditer = function(objRec) {
		obj.IDIAG_GridRowEditer_objRec = objRec;
		var winGridRowEditer = Ext.getCmp('IDIAG_GridRowEditer');
		if (!winGridRowEditer){
			winGridRowEditer = new Ext.Window({
				id : 'IDIAG_GridRowEditer',
				height : 120,
				closeAction: 'hide',
				width : 400,
				modal : true,
				title : 'ת��ICU���-�༭',
				layout : 'fit',
				frame : true,
				items: [
					obj.IDIAG_GridRowViewPort
				],
				bbar : [
					'->',
					new Ext.Toolbar.Button({
						id: "IDIAG_GridRowEditer_btnUpdate",
						width : 80,
						text : "<img SRC='../scripts/dhcmed/img/update.png'>����",
						listeners : {
							'click' : function(){
								var errInfo = obj.IDIAG_GridRowDataCheck('');
								if (errInfo){
									ExtTool.alert("��ʾ",errInfo);
									return;
								}
								obj.IDIAG_GridRowDataSave(obj.IDIAG_GridRowEditer_objRec);
								winGridRowEditer.hide();
							}
						}
					}),
					new Ext.Toolbar.Button({
						id: "IDIAG_GridRowEditer_btnCancel",
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
		obj.IDIAG_GridRowDataSet(objRec);
	}
	
	//��ȡ��
	obj.IDIAG_GridExtract_gridDiag = new Ext.grid.GridPanel({
		id: 'IDIAG_GridExtract_gridDiag',
		store : new Ext.data.Store({
			proxy: new Ext.data.HttpProxy({
				url : ExtToolSetting.RunQueryPageURL,
				listeners : {
					'beforeload' :  function(objProxy, param){
						param.ClassName = 'DHCMed.NINFService.Rep.InfReportDiag';
						param.QueryName = 'QrySubRec';
						param.Arg1      = '';
						param.Arg2      = obj.CurrReport.EpisodeID;
						param.Arg3      = 'ICU';
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
			,{header: '��������', width: 150, dataIndex: 'DiagnosDesc', sortable: false, menuDisabled:true, align:'center' }
			,{header: '�������', width: 80, dataIndex: 'DiagnosDate', sortable: false, menuDisabled:true, align:'center' }
			,{header: '���ʱ��', width: 60, dataIndex: 'DiagnosTime', sortable: false, menuDisabled:true, align:'center' }
			,{header: '������Դ', width: 60, dataIndex: 'DataSource', sortable: false, menuDisabled:true, align:'center' }
		],
		viewConfig : {
			forceFit : true
		}
	});
	obj.IDIAG_GridExtract = function() {
		var winGridRowEditer = Ext.getCmp('IDIAG_GridExtract');
		if (!winGridRowEditer){
			winGridRowEditer = new Ext.Window({
				id : 'IDIAG_GridExtract',
				height : 300,
				closeAction: 'hide',
				width : 500,
				modal : true,
				title : 'ת��ICU���-��ȡ',
				layout : 'fit',
				frame : true,
				items: [
					obj.IDIAG_GridExtract_gridDiag
				],
				bbar : [
					'->',
					new Ext.Toolbar.Button({
						id: "IDIAG_GridExtract_btnUpdate",
						width : 80,
						text : "<img SRC='../scripts/dhcmed/img/update.png'>ȷ��",
						listeners : {
							'click' : function(){
								var objRowDataGrid = Ext.getCmp('IDIAG_GridExtract_gridDiag');
								var objGrid = Ext.getCmp('IDIAG_gridDiag');
								if ((objRowDataGrid)&&(objGrid)) {
									var arrSelections = new Array();
									function insertfun(){
										var objStore = objGrid.getStore();
										var arrRec = objRowDataGrid.getSelectionModel().getSelections();
										var rowbreak = -1;
										for (var indRec = 0; indRec < arrRec.length; indRec++){
											var objRec = arrRec[indRec];
											
											//����Ƿ������ͬת��ICU���,����ͬ������Դ����
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
						id: "IDIAG_GridExtract_btnCancel",
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
						var objRowDataGrid = Ext.getCmp('IDIAG_GridExtract_gridDiag');
						if (objRowDataGrid) {
							objRowDataGrid.getStore().load({});
						}
					}
				}
			});
		}
		winGridRowEditer.show();
	}
	
	//���б�
	obj.IDIAG_GridDiagInit = function() {
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
							param.Arg3      = 'ICU';
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
				,{header: '��������', width: 200, dataIndex: 'DiagnosDesc', sortable: false, menuDisabled:true, align:'center' }
				,{header: '�������', width: 100, dataIndex: 'DiagnosDate', sortable: false, menuDisabled:true, align:'center' }
				,{header: '���ʱ��', width: 100, dataIndex: 'DiagnosTime', sortable: false, menuDisabled:true, align:'center' }
				//,{header: '������Դ', width: 60, dataIndex: 'DataSource', sortable: false, menuDisabled:true, align:'center' }
			]
			,bbar : [
				new Ext.Toolbar.Button({
					id: arguments[0] + "_btnGet",
					width : 80,
					text : "<img SRC='../scripts/dhcmed/img/update.gif'>��ȡ����",
					listeners : {
						'click' : function(){
							obj.IDIAG_GridExtract();
						}
					}
				}),
				new Ext.Toolbar.Button({
					id: arguments[0] + "_btnAdd",
					width : 80,
					text : "<img SRC='../scripts/dhcmed/img/add.png'>����",
					listeners : {
						'click' : function(){
							obj.IDIAG_GridRowEditer('');
						}
					}
				}),
				new Ext.Toolbar.Button({
					id: arguments[0] + "_btnDelete",
					width : 80,
					text : "<img SRC='../scripts/dhcmed/img/delete.gif'>ɾ��",
					listeners : {
						'click' :  function(){
							var objGrid = Ext.getCmp("IDIAG_gridDiag");
							if (objGrid){
								var arrRec = objGrid.getSelectionModel().getSelections();
								if (arrRec.length>0){
									Ext.MessageBox.confirm('ɾ��', '�Ƿ�ɾ��ѡ�����ݼ�¼?', function(btn,text){
										if(btn=="yes"){
											for (var indRec = 0; indRec < arrRec.length; indRec++){
												var objRec = arrRec[indRec];
												if (objRec.get('SubID')) {
													var RecID = objRec.get('RepID') + '||' + objRec.get('SubID');
													var flg = obj.ClsInfReportDiagSrv.DelSubRec(objRec.get('RepID') + '||' + objRec.get('SubID'));
													if (parseInt(flg) > 0) {
														objGrid.getStore().remove(objRec);
													} else {
														ExtTool.alert("������ʾ","ɾ��ת��ICU��ϴ���!error=" + flg);
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
				})
				,'->'
				,'��'
			]
			,viewConfig : {
				forceFit : true
			}
		});
		
		return tmpGridPanel;
	}
	obj.IDIAG_gridDiag = obj.IDIAG_GridDiagInit("IDIAG_gridDiag");
	
	//���沼��
	obj.IDIAG_ViewPort = {
		layout : 'fit',
		//frame : true,
		height : 200,
		anchor : '-20',
		tbar : ['<b>ת��ICU���</b>'],
		items : [
			obj.IDIAG_gridDiag
		]
	}
	
	//��ʼ��ҳ��
	obj.IDIAG_InitView = function(){
		var objGrid = Ext.getCmp("IDIAG_gridDiag");
		if (objGrid){
			objGrid.getStore().load({});
			objGrid.on('rowdblclick',function(){
				var rowIndex = arguments[1];
				var objRec = this.getStore().getAt(rowIndex);
				obj.IDIAG_GridRowEditer(objRec);
			},objGrid);
		}
	}
	
	//���ݴ洢
	obj.IDIAG_SaveData = function(){
		var errinfo = '';
		
		var objCmp = Ext.getCmp('IDIAG_gridDiag');
		if (objCmp) {
			var objStore = objCmp.getStore();
			for (var indRec = 0; indRec < objStore.getCount(); indRec++) {
				var objRec = objStore.getAt(indRec);
				
				//����������У��
				var flg = obj.IDIAG_GridRowDataCheck(objRec);
				if (flg){
					var row = objStore.indexOfId(objRec.id);  //��ȡ�к�
					errinfo = errinfo + 'ת��ICU��� ��' + (row + 1) + '�� ���ݴ���!<br>'
				}
				
				var objDiag = obj.ClsInfReportDiagSrv.GetSubObj('');
				if (objDiag) {
					if (objRec.get('RepID')&&objRec.get('SubID')) objDiag.RowID = objRec.get('RepID') + '||' + objRec.get('SubID');
					objDiag.DataSource = objRec.get('DataSource');
					objDiag.DiagnosID = objRec.get('DiagnosID');
					objDiag.DiagnosDesc = objRec.get('DiagnosDesc');
					objDiag.DiagnosDate = objRec.get('DiagnosDate');
					objDiag.DiagnosTime = objRec.get('DiagnosTime');
					objDiag.DiagnosType = obj.ClsSSDictionary.GetByTypeCode('NINFInfDiagnosType','ICU','');
					obj.CurrReport.ChildDiag.push(objDiag);
				}
			}
		}
		
		return errinfo;
	}
	
	return obj;
}