
function InitBASE(obj)
{
	//��ʾ������Ϣ
	obj.BASE_txtRegNo = Common_TextField("BASE_txtRegNo","�ǼǺ�");
	obj.BASE_txtPatName = Common_TextField("BASE_txtPatName","����");
	obj.BASE_txtPatSex = Common_TextField("BASE_txtPatSex","�Ա�");
	obj.BASE_txtPatAge = Common_TextField("BASE_txtPatAge","����");
	obj.BASE_txtMrNo = Common_TextField("BASE_txtMrNo","������");
	obj.BASE_txtAdmLoc = Common_TextField("BASE_txtAdmLoc","��ǰ����");
	obj.BASE_txtAdmDate = Common_TextField("BASE_txtAdmDate","��Ժ����");
	obj.BASE_txtDisDate = Common_TextField("BASE_txtDisDate","��Ժ����");
	obj.BASE_txtAdmDays = Common_TextField("BASE_txtAdmDays","סԺ����");
	obj.BASE_txtAdmBed = Common_TextField("BASE_txtAdmBed","����");
	obj.BASE_txtRepDate = Common_TextField("BASE_txtRepDate","�����");
	obj.BASE_txtRepUser = Common_TextField("BASE_txtRepUser","���");
	obj.BASE_txtRepStatus = Common_TextField("BASE_txtRepStatus","����״̬");
	obj.BASE_txtRepLoc = Common_TextField("BASE_txtRepLoc","�����");
	obj.BASE_cboTransLoc = Common_ComboToTransLoc("BASE_cboTransLoc","��Ⱦ����",obj.CurrReport.EpisodeID,"E");
	
	Common_SetDisabled("BASE_txtRegNo",true);
	Common_SetDisabled("BASE_txtPatName",true);
	Common_SetDisabled("BASE_txtPatSex",true);
	Common_SetDisabled("BASE_txtPatAge",true);
	Common_SetDisabled("BASE_txtMrNo",true);
	Common_SetDisabled("BASE_txtAdmLoc",true);
	Common_SetDisabled("BASE_txtAdmDate",true);
	Common_SetDisabled("BASE_txtDisDate",true);
	Common_SetDisabled("BASE_txtAdmDays",true);
	Common_SetDisabled("BASE_txtAdmBed",true);
	Common_SetDisabled("BASE_txtRepLoc",true);
	Common_SetDisabled("BASE_txtRepDate",true);
	Common_SetDisabled("BASE_txtRepUser",true);
	Common_SetDisabled("BASE_txtRepStatus",true);
	
	//����ת��
	obj.BASE_cbgDiseasePrognosis = Common_RadioGroupToDic("BASE_cbgDiseasePrognosis","<span style='color:red'><b>����ת��</b></span>","NINFInfDiseasePrognosis",5);
	//��������ϵ
	obj.BASE_cbgDeathRelation = Common_RadioGroupToDic("BASE_cbgDeathRelation","��������ϵ","NINFInfDeathRelation",3);
	//��Ⱦ�Լ�������
	obj.BASE_txtDiseaseCourse = Common_TextArea("BASE_txtDiseaseCourse","��Ⱦ�Լ�������",50);
	Common_SetDisabled("BASE_txtDiseaseCourse",true);
	//�������
	obj.BASE_txtDiagnosisBasis = Common_TextArea("BASE_txtDiagnosisBasis","�������",50);
	Common_SetDisabled("BASE_txtDiagnosisBasis",true);
	//ICU
	obj.BASE_cbgIsICU = Common_RadioGroupToDic("BASE_cbgIsICU","<span style='color:red'><b>��סICU</b></span>","NINFInfICUBoolean",2);
	//ICU�Ʊ�
	obj.BASE_cbgICULocation = Common_RadioGroupToDic("BASE_cbgICULocation","ICU�Ʊ�","NINFInfICULocation",2);
	//��Ⱦ����(ҽԺ��Ⱦ/������Ⱦ)
	obj.BASE_cbgInfectionType = Common_RadioGroupToDic("BASE_cbgInfectionType","<span style='color:red'><b>��Ⱦ����</b></span>","NINFInfectionType",2);
	
	//������� �༭��
	obj.BASE_gridDiag_RowEditer_objRec = '';
	obj.BASE_gridDiag_RowEditer = function(objRec) {
		obj.BASE_gridDiag_RowEditer_objRec = objRec;
		var winGridRowEditer = Ext.getCmp('BASE_gridDiag_RowEditer');
		if (!winGridRowEditer)
		{
			obj.BASE_gridDiag_RowEditer_cboDiagnose = Common_ComboToMRCICDDx("BASE_gridDiag_RowEditer_cboDiagnose","�������");
			
			winGridRowEditer = new Ext.Window({
				id : 'BASE_gridDiag_RowEditer',
				height : 120,
				closeAction: 'hide',
				width : 400,
				modal : true,
				title : '�������-�༭',
				layout : 'fit',
				frame : true,
				items: [
					{
						layout : 'form',
						frame : true,
						labelAlign : 'right',
						labelWidth : 60,
						items : [
							obj.BASE_gridDiag_RowEditer_cboDiagnose
						]
					}
				],
				bbar : [
					'->',
					new Ext.Toolbar.Button({
						id: "BASE_gridDiag_RowEditer_btnUpdate",
						width : 80,
						text : "<img SRC='../scripts/dhcmed/img/update.png'>ȷ��",
						listeners : {
							'click' : function(){
								var DiagnosID = Common_GetValue('BASE_gridDiag_RowEditer_cboDiagnose');
								var DiagnosDesc = Common_GetText('BASE_gridDiag_RowEditer_cboDiagnose');
								if (!DiagnosDesc) {
									ExtTool.alert("��ʾ","�������Ϊ��!");
									return;
								}
								
								var objRec = obj.BASE_gridDiag_RowEditer_objRec;
								var objGrid = Ext.getCmp('BASE_gridDiag');
								if (objGrid) {
									var objStore = objGrid.getStore();
									
									//�ж��Ƿ������ͬ�����������
									var IsBoolean = false;
									for (var ind = 0; ind < objStore.getCount(); ind++) {
										var tmpRec = objStore.getAt(ind);
										if (objRec) {
											if (tmpRec.id == objRec.id) continue;
										}
										if (DiagnosDesc == tmpRec.get('DiagnosDesc')) {
											IsBoolean = true;
										}
									}
									if (IsBoolean) {
										ExtTool.alert("��ʾ","������ͬ�����������!");
										return;
									}
									
									if (objRec) {      //�ύ����
										objRec.set('DiagnosID',DiagnosID);
										objRec.set('DiagnosDesc',DiagnosDesc);
										objRec.commit();
									} else {                 //��������
										var RecordType = objStore.recordType;
										var RecordData = new RecordType({
											RepID : ''
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
								
								winGridRowEditer.hide();
							}
						}
					}),
					new Ext.Toolbar.Button({
						id: "BASE_gridDiag_RowEditer_btnCancel",
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
						var objRec = obj.BASE_gridDiag_RowEditer_objRec;
						if (objRec) {
							Common_SetValue('BASE_gridDiag_RowEditer_cboDiagnose',objRec.get('DiagnosID'),objRec.get('DiagnosDesc'));
							Common_SetDisabled("BASE_gridDiag_RowEditer_cboDiagnose",(objRec.get('DataSource') != ''));
						} else {
							Common_SetValue('BASE_gridDiag_RowEditer_cboDiagnose','');
							Common_SetDisabled("BASE_gridDiag_RowEditer_cboDiagnose",false);
						}
					}
				}
			});
		}
		winGridRowEditer.show();
	}
	
	//������� ѡ���
	obj.BASE_gridDiag_RowExtract_gridDiag = new Ext.grid.GridPanel({
		id: 'BASE_gridDiag_RowExtract_gridDiag',
		store : new Ext.data.Store({
			proxy: new Ext.data.HttpProxy({
				url : ExtToolSetting.RunQueryPageURL,
				listeners : {
					'beforeload' :  function(objProxy, param){
						param.ClassName = 'DHCMed.NINFService.Rep.InfReportDiag';
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
					,{name: 'DiagnosID', mapping: 'DiagnosID'}
					,{name: 'DiagnosDesc', mapping: 'DiagnosDesc'}
					,{name: 'DiagnosDate', mapping: 'DiagnosDate'}
					,{name: 'DiagnosTime', mapping: 'DiagnosTime'}
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
			,{header: '��������', width: 150, dataIndex: 'DiagnosDesc', sortable: false, menuDisabled:true, align:'center' }
			,{header: '�������', width: 80, dataIndex: 'DiagnosDate', sortable: false, menuDisabled:true, align:'center' }
			,{header: '���ʱ��', width: 60, dataIndex: 'DiagnosTime', sortable: false, menuDisabled:true, align:'center' }
			,{header: '������Դ', width: 60, dataIndex: 'DataSource', sortable: false, menuDisabled:true, align:'center' }
		],
		viewConfig : {
			forceFit : true
		}
	});
	obj.BASE_gridDiag_RowExtract = function() {
		var winGridRowEditer = Ext.getCmp('BASE_gridDiag_RowExtract');
		if (!winGridRowEditer)
		{
			winGridRowEditer = new Ext.Window({
				id : 'BASE_gridDiag_RowExtract',
				height : 300,
				closeAction: 'hide',
				width : 500,
				modal : true,
				title : '�������-��ȡ',
				layout : 'fit',
				frame : true,
				items: [
					obj.BASE_gridDiag_RowExtract_gridDiag
				],
				bbar : [
					'->',
					new Ext.Toolbar.Button({
						id: "BASE_gridDiag_RowExtract_btnUpdate",
						width : 80,
						text : "<img SRC='../scripts/dhcmed/img/update.png'>ȷ��",
						listeners : {
							'click' : function(){
								var objRowDataGrid = Ext.getCmp('BASE_gridDiag_RowExtract_gridDiag');
								var objGrid = Ext.getCmp('BASE_gridDiag');
								if ((objRowDataGrid)&&(objGrid)) {
									var arrSelections = new Array();
									function insertfun(){
										var objStore = objGrid.getStore();
										var arrRec = objRowDataGrid.getSelectionModel().getSelections();
										var rowbreak = -1;
										for (var indRec = 0; indRec < arrRec.length; indRec++){
											var objRec = arrRec[indRec];
											
											//����Ƿ������ͬ���,����ͬ������Դ����
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
						id: "BASE_gridDiag_RowExtract_btnCancel",
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
						var objRowDataGrid = Ext.getCmp('BASE_gridDiag_RowExtract_gridDiag');
						if (objRowDataGrid) {
							objRowDataGrid.getStore().load({});
						}
					}
				}
			});
		}
		winGridRowEditer.show();
	}
	
	//������� �б�
	obj.BASE_gridDiag_btnAdd = new Ext.Button({
		id : 'BASE_gridDiag_btnAdd'
		,iconCls : 'icon-add'
		,width: 80
		,text : '����'
		,listeners : {
			'click' :  function(){
				obj.BASE_gridDiag_RowEditer('');
			}
		}
	});
	obj.BASE_gridDiag_btnDel = new Ext.Button({
		id : 'BASE_gridDiag_btnDel'
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
				var objGrid = Ext.getCmp("BASE_gridDiag");
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
	obj.BASE_gridDiag_btnGet = new Ext.Button({
		id : 'BASE_gridDiag_btnGet'
		,iconCls : 'icon-update'
		,width: 80
		,text : "��ȡ����"
		,listeners : {
			'click' :  function(){
				obj.BASE_gridDiag_RowExtract();
			}
		}
	});
	obj.BASE_gridDiag_iniFun = function() {
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
							param.Arg3      = '';
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
						,{name: 'DiagnosTypeID', mapping: 'DiagnosTypeID'}
						,{name: 'DiagnosTypeDesc', mapping: 'DiagnosTypeDesc'}
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
				,{header: '��������', width: 150, dataIndex: 'DiagnosDesc', sortable: false, menuDisabled:true, align:'center' }
				,{header: '�������', width: 80, dataIndex: 'DiagnosDate', sortable: false, menuDisabled:true, align:'center' }
				,{header: '���ʱ��', width: 60, dataIndex: 'DiagnosTime', sortable: false, menuDisabled:true, align:'center' }
				//,{header: '������Դ', width: 60, dataIndex: 'DataSource', sortable: false, menuDisabled:true, align:'center' }
			],
			viewConfig : {
				forceFit : true
			}
		});
		
		return tmpGridPanel;
	}
	obj.BASE_gridDiag = obj.BASE_gridDiag_iniFun("BASE_gridDiag");
	
	//������Ϣ ���沼��
	obj.BASE_ViewPort = {
		//title : '������Ϣ',
		layout : 'fit',
		//frame : true,
		height : 350,
		anchor : '-20',
		tbar : ['<b>���˻�����Ϣ</b>'],
		items : [
			{
				layout : 'border',
				frame : true,
				items : [
					{
						region: 'north',
						layout : 'form',
						height : 145,
						//frame : true,
						items : [
							{
								layout : 'column',
								items : [
									{
										columnWidth:.23,
										layout : 'form',
										labelAlign : 'right',
										labelWidth : 60,
										items : [obj.BASE_txtRegNo,obj.BASE_txtAdmLoc,obj.BASE_cboTransLoc]
									},{
										columnWidth:.23,
										layout : 'form',
										labelAlign : 'right',
										labelWidth : 60,
										items : [obj.BASE_txtPatName,obj.BASE_txtAdmDate,obj.BASE_txtRepLoc]
									},{
										columnWidth:.23,
										layout : 'form',
										labelAlign : 'right',
										labelWidth : 60,
										items : [obj.BASE_txtMrNo,obj.BASE_txtDisDate,obj.BASE_txtRepDate]
									},{
										columnWidth:.15,
										layout : 'form',
										labelAlign : 'right',
										labelWidth : 60,
										items : [obj.BASE_txtPatSex,obj.BASE_txtAdmDays,obj.BASE_txtRepUser]
									},{
										columnWidth:.15,
										layout : 'form',
										labelAlign : 'right',
										labelWidth : 60,
										items : [obj.BASE_txtPatAge,obj.BASE_txtAdmBed,obj.BASE_txtRepStatus]
									}
								]
							},{
								layout : 'column',
								items : [
									{
										columnWidth:.60,
										boxMinWidth : 100,
										boxMaxWidth : 400,
										layout : 'form',
										labelAlign : 'right',
										labelWidth : 60,
										items : [obj.BASE_cbgDiseasePrognosis]
									},{
										columnWidth:.40,
										boxMinWidth : 100,
										boxMaxWidth : 260,
										layout : 'form',
										labelAlign : 'right',
										labelWidth : 70,
										items : [obj.BASE_cbgDeathRelation]
									}
								]
							},{
								layout : 'column',
								items : [
									{
										width:160,
										layout : 'form',
										labelAlign : 'right',
										labelWidth : 60,
										items : [obj.BASE_cbgIsICU]
									},{
										width:200,
										layout : 'form',
										labelAlign : 'right',
										labelWidth : 60,
										items : [obj.BASE_cbgICULocation]
									},{
										width:20
									},{
										width:240,
										layout : 'form',
										labelAlign : 'right',
										labelWidth : 60,
										items : [obj.BASE_cbgInfectionType]
									}
								]
							}
							/* update by zf 20140430 ������Ϣ�в�����ʾ������ݼ���������
							,{
								layout : 'column',
								items : [
									{
										columnWidth:.50,
										layout : 'form',
										labelAlign : 'right',
										labelWidth : 60,
										items : [obj.BASE_txtDiagnosisBasis]
									},{
										width : 10
									},{
										columnWidth:.50,
										layout : 'form',
										labelAlign : 'right',
										labelWidth : 60,
										items : [obj.BASE_txtDiseaseCourse]
									}
								]
							}*/
						]
					},{
						region: 'center',
						layout : 'border',
						items : [
							{
								region: 'center',
								layout : 'fit',
								buttonAlign : 'left',
								//frame : true,
								items : [obj.BASE_gridDiag],
								bbar : [obj.BASE_gridDiag_btnGet,obj.BASE_gridDiag_btnAdd,obj.BASE_gridDiag_btnDel,'->','��']
							},{
								region: 'west',
								layout : 'fit',
								width : 68,
								html: '<table border="0" width="100%" height="30px"><tr><td align="center" >�������:</td></tr></table>'
							}
						]
					}
				]
			}
		]
	}
	
	//������Ϣ �����ʼ��
	obj.BASE_InitView = function(){
		var objPaadm = obj.CurrPaadm;
		if (objPaadm) {
			var PatientID = objPaadm.PatientID;
			var objPatient = obj.CurrPatient;
			if (objPatient) {
				Common_SetValue('BASE_txtRegNo',objPatient.PapmiNo);
				Common_SetValue('BASE_txtPatName',objPatient.PatientName);
				Common_SetValue('BASE_txtPatSex',objPatient.Sex);
				var Age = objPatient.Age;
				var Month = objPatient.AgeMonth;
				var Day = objPatient.AgeDay;
				if (!Age) Age=0;
				if (!Month) Month=0;
				if (!Day) Day=0;
				if (parseInt(Age) > 0) {
					Common_SetValue('BASE_txtPatAge',parseInt(Age) + '��');
				} else {
					Common_SetValue('BASE_txtPatAge',parseInt(Month) + '��' + parseInt(Day) + '��');
				}
				//update by zf 2013-05-14
				var MrNo=obj.ClsCommonClsSrv.GetMrNoByAdm(obj.CurrReport.EpisodeID);
				if (MrNo){
					objPaadm.MrNo = MrNo;
					Common_SetValue('BASE_txtMrNo',MrNo);
				} else {
					Common_SetValue('BASE_txtMrNo',objPatient.InPatientMrNo);
				}
			}
			Common_SetValue('BASE_txtAdmLoc',objPaadm.Department);
			Common_SetValue('BASE_txtAdmDate',objPaadm.AdmitDate + ' ' + objPaadm.AdmitTime);
			Common_SetValue('BASE_txtDisDate',objPaadm.DisDate + ' ' + objPaadm.DisTime);
			Common_SetValue('BASE_txtAdmBed',objPaadm.Bed);
			Common_SetValue('BASE_txtAdmDays',objPaadm.Days);
		}
		
		Common_SetValue('BASE_txtRepLoc',(obj.CurrReport.ReportLoc !='' ? obj.CurrReport.ReportLoc.Descs : ''));
		Common_SetValue('BASE_txtRepDate',obj.CurrReport.ReportDate);
		Common_SetValue('BASE_txtRepUser',(obj.CurrReport.ReportUser !='' ? obj.CurrReport.ReportUser.Name : ''));
		Common_SetValue('BASE_txtRepStatus',(obj.CurrReport.ReportStatus !='' ? obj.CurrReport.ReportStatus.Description : ''));
		
		Common_SetValue('BASE_cbgDiseasePrognosis',(obj.CurrReport.ChildSumm.DiseasePrognosis !='' ? obj.CurrReport.ChildSumm.DiseasePrognosis.RowID : ''));
		Common_SetValue('BASE_cbgDeathRelation',(obj.CurrReport.ChildSumm.DeathRelation !='' ? obj.CurrReport.ChildSumm.DeathRelation.RowID : ''));
		Common_SetValue('BASE_txtDiseaseCourse',(obj.CurrReport.ChildSumm.DiseaseCourse !='' ? obj.CurrReport.ChildSumm.DiseaseCourse : ''));
		Common_SetValue('BASE_txtDiagnosisBasis',(obj.CurrReport.ChildSumm.DiagnosisBasis !='' ? obj.CurrReport.ChildSumm.DiagnosisBasis : ''));
		
		var isActive = false;
		var objSumm = obj.CurrReport.ChildSumm;
		if (objSumm) {
			if (objSumm.DiseasePrognosis) {
				isActive = (objSumm.DiseasePrognosis.Description.indexOf('����') > -1);
			}
		}
		Common_SetDisabled('BASE_cbgDeathRelation',(!isActive));
		
		//��ʼ���������
		var objGrid = Ext.getCmp("BASE_gridDiag");
		if (objGrid){
			objGrid.getStore().load({});
			objGrid.on('rowdblclick',function(){
				var rowIndex = arguments[1];
				var objRec = this.getStore().getAt(rowIndex);
				obj.BASE_gridDiag_RowEditer(objRec);
			},objGrid);
		}
		
		//��ʼ��"����ת��"change�¼�
		var objCmp = Ext.getCmp("BASE_cbgDiseasePrognosis");
		if (objCmp) {
			objCmp.on('change',function(cbg,val){
				var isActive = false;
				if (val.length > 0) {
					var cb = val[0];
					var objDic = obj.ClsSSDictionary.GetObjById(cb.inputValue);
					if (objDic) {
						isActive = (objDic.Description.indexOf('����') > -1);
					}
				}
				Common_SetDisabled('BASE_cbgDeathRelation',(!isActive));
				Common_SetValue('BASE_cbgDeathRelation','');
			});
		}
		
		//��ʼ��"��סICU[��/��],ICU�Ʊ�,����[��/��]"����Ԫ��ֵ
		//��ʼ��"ICU�Ʊ�"����Ԫ��״̬
		var isActive = false;
		if (obj.CurrReport.ChildSumm.ICUBoolean != '') {
			isActive = (obj.CurrReport.ChildSumm.ICUBoolean.Code == 'Y');
		} else {
			var num = obj.ClsInfReportOprSrv.IsCheckICU(obj.CurrReport.EpisodeID);
			if (parseInt(num) > 0) {
				isActive = true;
			} else {
				isActive = false;
			}
		}
		if (isActive) {
			Common_SetValue('BASE_cbgIsICU','','��');
		} else {
			Common_SetValue('BASE_cbgIsICU','','��');
		}
		Common_SetValue('BASE_cbgICULocation',(obj.CurrReport.ChildSumm.ICULocation != '' ? obj.CurrReport.ChildSumm.ICULocation.RowID : ''));
		Common_SetDisabled('BASE_cbgICULocation',(!isActive));
		
		//��ʼ��"��Ⱦ����"ֵ
		if (obj.CurrReport.ChildSumm.InfectionType){
			var itemValue = obj.CurrReport.ChildSumm.InfectionType.RowID;
			Common_SetValue('BASE_cbgInfectionType',itemValue);
		} else {
			Common_SetValue('BASE_cbgInfectionType','','ҽԺ��Ⱦ');
		}
		
		//��ʼ��"��סICU[��/��]"change�¼�
		var objCmp = Ext.getCmp("BASE_cbgIsICU");
		if (objCmp) {
			objCmp.on('change',function(cbg,val){
				var isActive = false;
				if (val.length > 0) {
					var cb = val[0];
					var objDic = obj.ClsSSDictionary.GetObjById(cb.inputValue);
					if (objDic) {
						isActive = (objDic.Code == 'Y');
					}
				}
				Common_SetDisabled('BASE_cbgICULocation',(!isActive));
				Common_SetValue('BASE_cbgICULocation','');
			});
		}
		
		//��ʼ����Ⱦ����
		obj.BASE_cboTransLoc_Init();
	}
	
	//��Ⱦ���ҳ�ʼ��
	obj.BASE_cboTransLoc_Init = function(){
		var xTransID = '';
		var xTransLocDesc = '';
		
		var objDictionarySrv = ExtTool.StaticServerObject("DHCMed.NINFService.Srv.CommonSrv");
		var strJson = objDictionarySrv.GetTransLocList(EpisodeID,"E");
		var jsonData = Ext.util.JSON.decode(strJson);
		var tmpStore = new Ext.data.Store({
			data : jsonData,
			reader: new Ext.data.ArrayReader({
				idIndex: 0
			},Ext.data.Record.create([
				{name: 'TransID', mapping: 0}
				,{name: 'TransLocID', mapping: 1}
				,{name: 'TransLocDesc', mapping: 2}
				,{name: 'TransInTime', mapping: 3}
				,{name: 'TransOutTime', mapping: 4}
				,{name: 'PrevLocID', mapping: 5}
				,{name: 'PrevLocDesc', mapping: 6}
				,{name: 'NextLocID', mapping: 7}
				,{name: 'NextLocDesc', mapping: 8}
			]))
		})
		
		if (tmpStore.getCount() > 0){
			var tmpCount = tmpStore.getCount();
			var yTransID = obj.CurrReport.ChildSumm.TransID;
			if (yTransID != ''){
				for (var indLoc = 0; indLoc < tmpCount; indLoc++){
					var objRec = tmpStore.getAt(indLoc);
					//if (objRec.TransID == yTransID){
					if (objRec.get("TransID") == yTransID){ // Modified By LiYang 2014-07-04 FixBug:1718 ҽԺ��Ⱦ����-ȫԺ�ۺ��Լ��-��Ⱦ�����ѯ-��ת�Ʋ��˸�Ⱦ���ҷǵ�ǰ���ҵĸ�Ⱦ���棬��Ⱦ������ʾ����ȷ
						xTransID = objRec.get('TransID');
						xTransLocDesc = objRec.get('TransLocDesc');
					}
				}
			}
			if (xTransID == '') {
				var objRec = tmpStore.getAt(tmpCount-1);
				if (objRec){
					xTransID = objRec.get('TransID');
					xTransLocDesc = objRec.get('TransLocDesc');
				}
			}
		}
		obj.BASE_cboTransLoc.setValue(xTransID);
		obj.BASE_cboTransLoc.setRawValue(xTransLocDesc);
	}
	
	//������Ϣ ���ݴ洢
	obj.BASE_SaveData = function(){
		var errinfo = '';
		
		//ת�Ƽ�¼����Ⱦ����
		var xTransID = '';
		var xTransLocID = '';
		var objTransLoc = Ext.getCmp('BASE_cboTransLoc');
		if (objTransLoc) {
			xTransID = objTransLoc.getValue();
			var objTransLocStore = objTransLoc.getStore();
			var ind = objTransLocStore.find("TransID",xTransID);
			if (ind > -1) {
				var objRec = objTransLocStore.getAt(ind);
				xTransLocID = objRec.get('TransLocID');
			}
		}
		obj.CurrReport.ChildSumm.TransID = xTransID;
		obj.CurrReport.ChildSumm.TransLoc = obj.ClsBaseCtloc.GetObjById(xTransLocID);
		
		//��ȡObjectID
		if (obj.CurrReport.ObjectID == '') {
			obj.CurrReport.ObjectID = obj.ClsInfReportSrv.GetObjectID(obj.CurrReport.EpisodeID,obj.CurrReport.ReportType.RowID,'');
		}
		
		//����ת��
		var itmValue = Common_GetValue('BASE_cbgDiseasePrognosis');
		obj.CurrReport.ChildSumm.DiseasePrognosis = obj.ClsSSDictionary.GetObjById(itmValue);
		
		//��������ϵ
		var itmValue = Common_GetValue('BASE_cbgDeathRelation');
		obj.CurrReport.ChildSumm.DeathRelation = obj.ClsSSDictionary.GetObjById(itmValue);
		
		//�������
		var DiagnosisBasis = Common_GetValue('BASE_txtDiagnosisBasis');
		obj.CurrReport.ChildSumm.DiagnosisBasis = DiagnosisBasis;
		
		//��Ⱦ�Լ�������
		var DiseaseCourse = Common_GetValue('BASE_txtDiseaseCourse');
		obj.CurrReport.ChildSumm.DiseaseCourse = DiseaseCourse;
		
		//��סICU[��/��]
		var itmValue = Common_GetValue('BASE_cbgIsICU');
		obj.CurrReport.ChildSumm.ICUBoolean = obj.ClsSSDictionary.GetObjById(itmValue);
		//ICU�Ʊ�
		var itmValue = Common_GetValue('BASE_cbgICULocation');
		obj.CurrReport.ChildSumm.ICULocation = obj.ClsSSDictionary.GetObjById(itmValue);
		
		//��Ⱦ����
		var itmValue = Common_GetValue('BASE_cbgInfectionType');
		obj.CurrReport.ChildSumm.InfectionType = obj.ClsSSDictionary.GetObjById(itmValue);
		
		//����������У��
		if (obj.CurrReport.ObjectID == '') {
			//errinfo = errinfo + 'ObjectID Ϊ��!<br>'
		}
		var objSumm = obj.CurrReport.ChildSumm;
		if (!objSumm.TransLoc) {
			errinfo = errinfo + '��Ⱦ����δ��!<br>'
		}
		if (objSumm.DiseasePrognosis) {
			if ((objSumm.DiseasePrognosis.Description.indexOf('����') > -1)&&(!objSumm.DeathRelation)) {
				errinfo = errinfo + '��������ϵδ��!<br>'
			}
		}
		if (!objSumm.DiagnosisBasis) {
			//errinfo = errinfo + '��Ⱦ�Լ�������δ��!<br>'
		}
		if (!objSumm.DiseaseCourse) {
			//errinfo = errinfo + '�������δ��!<br>'
		}
		if (!objSumm.ICUBoolean) {
			errinfo = errinfo + '��סICU[��/��]δ��!<br>'
		}
		if (objSumm.ICUBoolean) {
			if ((objSumm.ICUBoolean.Description == '��')&&(!objSumm.ICULocation)) {
				errinfo = errinfo + 'ICU�Ʊ�δ��!<br>'
			}
		}
		if (!objSumm.InfectionType) {
			errinfo = errinfo + '��Ⱦ����δ��!<br>'
		}
		
		//�������
		obj.CurrReport.ChildDiag   = new Array();
		var objCmp = Ext.getCmp('BASE_gridDiag');
		if (objCmp) {
			var objStore = objCmp.getStore();
			for (var indRec = 0; indRec < objStore.getCount(); indRec++) {
				var objRec = objStore.getAt(indRec);
				var objDiag = obj.ClsInfReportDiagSrv.GetSubObj('');
				if (objDiag) {
					objDiag.RowID = objRec.get('RepID') + '||' + objRec.get('SubID');
					objDiag.DataSource = objRec.get('DataSource');
					objDiag.DiagnosID = objRec.get('DiagnosID');
					objDiag.DiagnosDesc = objRec.get('DiagnosDesc');
					objDiag.DiagnosDate = objRec.get('DiagnosDate');
					objDiag.DiagnosTime = objRec.get('DiagnosTime');
					objDiag.DiagnosType = '';
					
					var row = objStore.indexOfId(objRec.id);  //��ȡ�к�
					if (!objDiag.DiagnosDesc) {
						errinfo = errinfo + '������Ϣ ��' + (row + 1) + '�� �������δ��!<br>'
					}
					
					obj.CurrReport.ChildDiag.push(objDiag);
				}
			}
		}
		if (obj.CurrReport.ChildDiag.length < 1) {
			errinfo = errinfo + '�������δ��!<br>'
		}
		
		return errinfo;
	}
	
	return obj;
}