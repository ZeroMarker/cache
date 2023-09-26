
function InitBASE(obj)
{
	//显示基本信息
	obj.BASE_txtRegNo = Common_TextField("BASE_txtRegNo","登记号");
	obj.BASE_txtPatName = Common_TextField("BASE_txtPatName","姓名");
	obj.BASE_txtPatSex = Common_TextField("BASE_txtPatSex","性别");
	obj.BASE_txtPatAge = Common_TextField("BASE_txtPatAge","年龄");
	obj.BASE_txtMrNo = Common_TextField("BASE_txtMrNo","病历号");
	obj.BASE_txtAdmLoc = Common_TextField("BASE_txtAdmLoc","当前科室");
	obj.BASE_txtAdmDate = Common_TextField("BASE_txtAdmDate","入院日期");
	obj.BASE_txtDisDate = Common_TextField("BASE_txtDisDate","出院日期");
	obj.BASE_txtAdmDays = Common_TextField("BASE_txtAdmDays","住院天数");
	obj.BASE_txtAdmBed = Common_TextField("BASE_txtAdmBed","床号");
	obj.BASE_txtRepDate = Common_TextField("BASE_txtRepDate","填报日期");
	obj.BASE_txtRepUser = Common_TextField("BASE_txtRepUser","填报人");
	obj.BASE_txtRepStatus = Common_TextField("BASE_txtRepStatus","报告状态");
	obj.BASE_txtRepLoc = Common_TextField("BASE_txtRepLoc","填报科室");
	obj.BASE_cboTransLoc = Common_ComboToTransLoc("BASE_cboTransLoc","感染科室",obj.CurrReport.EpisodeID,"E");
	
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
	
	//疾病转归
	obj.BASE_cbgDiseasePrognosis = Common_RadioGroupToDic("BASE_cbgDiseasePrognosis","<span style='color:red'><b>疾病转归</b></span>","NINFInfDiseasePrognosis",5);
	//与死亡关系
	obj.BASE_cbgDeathRelation = Common_RadioGroupToDic("BASE_cbgDeathRelation","与死亡关系","NINFInfDeathRelation",3);
	//感染性疾病病程
	obj.BASE_txtDiseaseCourse = Common_TextArea("BASE_txtDiseaseCourse","感染性疾病病程",50);
	Common_SetDisabled("BASE_txtDiseaseCourse",true);
	//诊断依据
	obj.BASE_txtDiagnosisBasis = Common_TextArea("BASE_txtDiagnosisBasis","诊断依据",50);
	Common_SetDisabled("BASE_txtDiagnosisBasis",true);
	//ICU
	obj.BASE_cbgIsICU = Common_RadioGroupToDic("BASE_cbgIsICU","<span style='color:red'><b>入住ICU</b></span>","NINFInfICUBoolean",2);
	//ICU科别
	obj.BASE_cbgICULocation = Common_RadioGroupToDic("BASE_cbgICULocation","ICU科别","NINFInfICULocation",2);
	//感染类型(医院感染/社区感染)
	obj.BASE_cbgInfectionType = Common_RadioGroupToDic("BASE_cbgInfectionType","<span style='color:red'><b>感染类型</b></span>","NINFInfectionType",2);
	
	//疾病诊断 编辑框
	obj.BASE_gridDiag_RowEditer_objRec = '';
	obj.BASE_gridDiag_RowEditer = function(objRec) {
		obj.BASE_gridDiag_RowEditer_objRec = objRec;
		var winGridRowEditer = Ext.getCmp('BASE_gridDiag_RowEditer');
		if (!winGridRowEditer)
		{
			obj.BASE_gridDiag_RowEditer_cboDiagnose = Common_ComboToMRCICDDx("BASE_gridDiag_RowEditer_cboDiagnose","疾病诊断");
			
			winGridRowEditer = new Ext.Window({
				id : 'BASE_gridDiag_RowEditer',
				height : 120,
				closeAction: 'hide',
				width : 400,
				modal : true,
				title : '疾病诊断-编辑',
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
						text : "<img SRC='../scripts/dhcmed/img/update.png'>确定",
						listeners : {
							'click' : function(){
								var DiagnosID = Common_GetValue('BASE_gridDiag_RowEditer_cboDiagnose');
								var DiagnosDesc = Common_GetText('BASE_gridDiag_RowEditer_cboDiagnose');
								if (!DiagnosDesc) {
									ExtTool.alert("提示","疾病诊断为空!");
									return;
								}
								
								var objRec = obj.BASE_gridDiag_RowEditer_objRec;
								var objGrid = Ext.getCmp('BASE_gridDiag');
								if (objGrid) {
									var objStore = objGrid.getStore();
									
									//判断是否存在相同疾病诊断数据
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
										ExtTool.alert("提示","存在相同疾病诊断数据!");
										return;
									}
									
									if (objRec) {      //提交数据
										objRec.set('DiagnosID',DiagnosID);
										objRec.set('DiagnosDesc',DiagnosDesc);
										objRec.commit();
									} else {                 //插入数据
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
	
	//疾病诊断 选择框
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
			,{header: '疾病名称', width: 150, dataIndex: 'DiagnosDesc', sortable: false, menuDisabled:true, align:'center' }
			,{header: '诊断日期', width: 80, dataIndex: 'DiagnosDate', sortable: false, menuDisabled:true, align:'center' }
			,{header: '诊断时间', width: 60, dataIndex: 'DiagnosTime', sortable: false, menuDisabled:true, align:'center' }
			,{header: '数据来源', width: 60, dataIndex: 'DataSource', sortable: false, menuDisabled:true, align:'center' }
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
				title : '疾病诊断-提取',
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
						text : "<img SRC='../scripts/dhcmed/img/update.png'>确定",
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
											
											//检查是否存在相同诊断,或相同数据来源数据
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
						id: "BASE_gridDiag_RowExtract_btnCancel",
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
	
	//疾病诊断 列表
	obj.BASE_gridDiag_btnAdd = new Ext.Button({
		id : 'BASE_gridDiag_btnAdd'
		,iconCls : 'icon-add'
		,width: 80
		,text : '增加'
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
				var objGrid = Ext.getCmp("BASE_gridDiag");
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
	obj.BASE_gridDiag_btnGet = new Ext.Button({
		id : 'BASE_gridDiag_btnGet'
		,iconCls : 'icon-update'
		,width: 80
		,text : "提取数据"
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
				,{header: '疾病名称', width: 150, dataIndex: 'DiagnosDesc', sortable: false, menuDisabled:true, align:'center' }
				,{header: '诊断日期', width: 80, dataIndex: 'DiagnosDate', sortable: false, menuDisabled:true, align:'center' }
				,{header: '诊断时间', width: 60, dataIndex: 'DiagnosTime', sortable: false, menuDisabled:true, align:'center' }
				//,{header: '数据来源', width: 60, dataIndex: 'DataSource', sortable: false, menuDisabled:true, align:'center' }
			],
			viewConfig : {
				forceFit : true
			}
		});
		
		return tmpGridPanel;
	}
	obj.BASE_gridDiag = obj.BASE_gridDiag_iniFun("BASE_gridDiag");
	
	//基本信息 界面布局
	obj.BASE_ViewPort = {
		//title : '基本信息',
		layout : 'fit',
		//frame : true,
		height : 350,
		anchor : '-20',
		tbar : ['<b>病人基本信息</b>'],
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
							/* update by zf 20140430 基本信息中不再显示诊断依据及疾病病程
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
								bbar : [obj.BASE_gridDiag_btnGet,obj.BASE_gridDiag_btnAdd,obj.BASE_gridDiag_btnDel,'->','…']
							},{
								region: 'west',
								layout : 'fit',
								width : 68,
								html: '<table border="0" width="100%" height="30px"><tr><td align="center" >疾病诊断:</td></tr></table>'
							}
						]
					}
				]
			}
		]
	}
	
	//基本信息 界面初始化
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
					Common_SetValue('BASE_txtPatAge',parseInt(Age) + '岁');
				} else {
					Common_SetValue('BASE_txtPatAge',parseInt(Month) + '月' + parseInt(Day) + '天');
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
				isActive = (objSumm.DiseasePrognosis.Description.indexOf('死亡') > -1);
			}
		}
		Common_SetDisabled('BASE_cbgDeathRelation',(!isActive));
		
		//初始化疾病诊断
		var objGrid = Ext.getCmp("BASE_gridDiag");
		if (objGrid){
			objGrid.getStore().load({});
			objGrid.on('rowdblclick',function(){
				var rowIndex = arguments[1];
				var objRec = this.getStore().getAt(rowIndex);
				obj.BASE_gridDiag_RowEditer(objRec);
			},objGrid);
		}
		
		//初始化"疾病转归"change事件
		var objCmp = Ext.getCmp("BASE_cbgDiseasePrognosis");
		if (objCmp) {
			objCmp.on('change',function(cbg,val){
				var isActive = false;
				if (val.length > 0) {
					var cb = val[0];
					var objDic = obj.ClsSSDictionary.GetObjById(cb.inputValue);
					if (objDic) {
						isActive = (objDic.Description.indexOf('死亡') > -1);
					}
				}
				Common_SetDisabled('BASE_cbgDeathRelation',(!isActive));
				Common_SetValue('BASE_cbgDeathRelation','');
			});
		}
		
		//初始化"入住ICU[是/否],ICU科别,手术[是/否]"界面元素值
		//初始化"ICU科别"界面元素状态
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
			Common_SetValue('BASE_cbgIsICU','','是');
		} else {
			Common_SetValue('BASE_cbgIsICU','','否');
		}
		Common_SetValue('BASE_cbgICULocation',(obj.CurrReport.ChildSumm.ICULocation != '' ? obj.CurrReport.ChildSumm.ICULocation.RowID : ''));
		Common_SetDisabled('BASE_cbgICULocation',(!isActive));
		
		//初始化"感染类型"值
		if (obj.CurrReport.ChildSumm.InfectionType){
			var itemValue = obj.CurrReport.ChildSumm.InfectionType.RowID;
			Common_SetValue('BASE_cbgInfectionType',itemValue);
		} else {
			Common_SetValue('BASE_cbgInfectionType','','医院感染');
		}
		
		//初始化"入住ICU[是/否]"change事件
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
		
		//初始化感染科室
		obj.BASE_cboTransLoc_Init();
	}
	
	//感染科室初始化
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
					if (objRec.get("TransID") == yTransID){ // Modified By LiYang 2014-07-04 FixBug:1718 医院感染管理-全院综合性监测-感染报告查询-打开转科病人感染科室非当前科室的感染报告，感染科室显示不正确
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
	
	//基本信息 数据存储
	obj.BASE_SaveData = function(){
		var errinfo = '';
		
		//转科记录、感染科室
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
		
		//获取ObjectID
		if (obj.CurrReport.ObjectID == '') {
			obj.CurrReport.ObjectID = obj.ClsInfReportSrv.GetObjectID(obj.CurrReport.EpisodeID,obj.CurrReport.ReportType.RowID,'');
		}
		
		//疾病转归
		var itmValue = Common_GetValue('BASE_cbgDiseasePrognosis');
		obj.CurrReport.ChildSumm.DiseasePrognosis = obj.ClsSSDictionary.GetObjById(itmValue);
		
		//与死亡关系
		var itmValue = Common_GetValue('BASE_cbgDeathRelation');
		obj.CurrReport.ChildSumm.DeathRelation = obj.ClsSSDictionary.GetObjById(itmValue);
		
		//诊断依据
		var DiagnosisBasis = Common_GetValue('BASE_txtDiagnosisBasis');
		obj.CurrReport.ChildSumm.DiagnosisBasis = DiagnosisBasis;
		
		//感染性疾病病程
		var DiseaseCourse = Common_GetValue('BASE_txtDiseaseCourse');
		obj.CurrReport.ChildSumm.DiseaseCourse = DiseaseCourse;
		
		//入住ICU[是/否]
		var itmValue = Common_GetValue('BASE_cbgIsICU');
		obj.CurrReport.ChildSumm.ICUBoolean = obj.ClsSSDictionary.GetObjById(itmValue);
		//ICU科别
		var itmValue = Common_GetValue('BASE_cbgICULocation');
		obj.CurrReport.ChildSumm.ICULocation = obj.ClsSSDictionary.GetObjById(itmValue);
		
		//感染类型
		var itmValue = Common_GetValue('BASE_cbgInfectionType');
		obj.CurrReport.ChildSumm.InfectionType = obj.ClsSSDictionary.GetObjById(itmValue);
		
		//数据完整性校验
		if (obj.CurrReport.ObjectID == '') {
			//errinfo = errinfo + 'ObjectID 为空!<br>'
		}
		var objSumm = obj.CurrReport.ChildSumm;
		if (!objSumm.TransLoc) {
			errinfo = errinfo + '感染科室未填!<br>'
		}
		if (objSumm.DiseasePrognosis) {
			if ((objSumm.DiseasePrognosis.Description.indexOf('死亡') > -1)&&(!objSumm.DeathRelation)) {
				errinfo = errinfo + '与死亡关系未填!<br>'
			}
		}
		if (!objSumm.DiagnosisBasis) {
			//errinfo = errinfo + '感染性疾病病程未填!<br>'
		}
		if (!objSumm.DiseaseCourse) {
			//errinfo = errinfo + '诊断依据未填!<br>'
		}
		if (!objSumm.ICUBoolean) {
			errinfo = errinfo + '入住ICU[是/否]未填!<br>'
		}
		if (objSumm.ICUBoolean) {
			if ((objSumm.ICUBoolean.Description == '是')&&(!objSumm.ICULocation)) {
				errinfo = errinfo + 'ICU科别未填!<br>'
			}
		}
		if (!objSumm.InfectionType) {
			errinfo = errinfo + '感染类型未填!<br>'
		}
		
		//疾病诊断
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
					
					var row = objStore.indexOfId(objRec.id);  //获取行号
					if (!objDiag.DiagnosDesc) {
						errinfo = errinfo + '基本信息 第' + (row + 1) + '行 疾病诊断未填!<br>'
					}
					
					obj.CurrReport.ChildDiag.push(objDiag);
				}
			}
		}
		if (obj.CurrReport.ChildDiag.length < 1) {
			errinfo = errinfo + '疾病诊断未填!<br>'
		}
		
		return errinfo;
	}
	
	return obj;
}