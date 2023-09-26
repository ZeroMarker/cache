var objRepControl = null;

var appName = 'DHCMedInfection';
//Ext.BLANK_IMAGE_URL = '../scripts/css/ExtCss/images/default/s.gif'; //Add By LiYang 2009-11-21

function InfectionRepControl()
{
	var obj = new Object();
	
	//update by zf 20090923
	var IsDisabledRepPlace=true;
	var IsCasuseInf=false;
	var IsWoundInfection=false;
	var IsEndDate=false;
	var IsInfDays=false;
	var IsOprStartDate=false;
	var IsOprEndDate=false;
	var IsOprStartTime=false;
	var IsOprEndTime=false;
	if (HospCode=="ChengDu_HX")
	{
		IsDisabledRepPlace=false;
	}
	if (HospCode=="NingXia_NX")
	{
		IsCasuseInf=true;
		IsWoundInfection=true;
		IsEndDate=true;
		IsInfDays=true;
		IsOprStartDate=true;
		IsOprEndDate=true;
		IsOprStartTime=true;
		IsOprEndTime=true;
	}
	
	//********************************Patient BaseInfo Section Start********************************
	obj.txtNo = new Ext.form.TextField({fieldLabel:txtNo,readOnly:true,width:250});    //,width:300 modify by wuqk 2008-04-15
	obj.txtRegNo = new Ext.form.TextField({fieldLabel:txtRegNo,readOnly:true,width:250});
	obj.txtMrNo = new Ext.form.TextField({fieldLabel:txtMrNo,readOnly:true,width:250});
	obj.txtName = new Ext.form.TextField({fieldLabel:txtName,readOnly:true,width:250});
	obj.txtSex = new Ext.form.TextField({fieldLabel:txtSex,readOnly:true,width:250});
	obj.txtAge = new Ext.form.TextField({fieldLabel:txtAge,readOnly:true,width:250});
	obj.txtAdmitDate = new Ext.form.TextField({fieldLabel:txtAdmitDate,readOnly:true,width:250});
	obj.txtDisDate = new Ext.form.TextField({fieldLabel:txtDisDate,readOnly:true,width:250});
	obj.txtBed = new Ext.form.TextField({fieldLabel:txtBed,readOnly:true,width:250});
	obj.cboLapseTo = new Ext.form.ComboBox({fieldLabel:cboLapseTo,editable:false,mode: 'local', triggerAction: 'all',store:CreateDicDataStore("InfectionDiagnosePrognosis"),displayField:"Description",valueField:"Code",width:250});
	obj.cboRelation = new Ext.form.ComboBox({fieldLabel:cboRelation,editable:false,mode: 'local', triggerAction: 'all',store:CreateDicDataStore("InfDieRelation"),displayField:"Description",valueField:"Code",width:250});
	obj.cboICU = new Ext.form.ComboBox({fieldLabel:cboICU,editable:false,mode: 'local', triggerAction: 'all',store:CreateDicDataStore("InfectionICUType"),displayField:"Description",valueField:"Code",width:250});
	obj.cboRepPlace = new Ext.form.ComboBox({fieldLabel:strRepPlace,editable:false,mode: 'local', triggerAction: 'all',store:CreateDicDataStore("InfectionRepPlace"),displayField:"Description",valueField:"Code",disabled:IsDisabledRepPlace,width:250}); //Add ByLiYang 2009-04-07
	var objAdmitDiagnoseColumn = new Ext.grid.CheckColumn({header: Checked, dataIndex: 'checked', width: 55});
	obj.gridAdmitDiagnose = new Ext.grid.GridPanel({
        	store: new Ext.data.SimpleStore({
				fields: [
				   {name: 'RowID'},
				   {name: 'ICDCode'},
				   {name: 'ICDDescription'},
				   {name: 'DiagnoseType'},
				   {name: 'DoctorCode'},
				   {name: 'Doctor'},
				   {name: 'DiagnoseDate'},
				   {name: 'DiagnoseTime'},
				   {name: 'objAdmitDiagnose'},
				   {name: 'objRepDiagnose'},
				   {name: 'checked'},
				   {name: 'pChange'}
				]
			}),
	        columns: [
				new Ext.grid.RowNumberer(),
				{id:'RowID', header: ICD, width: 75, sortable: false, dataIndex: 'ICDCode'},
				{header: AdmitDiagnose, width: 150, sortable: false, dataIndex: 'ICDDescription'},
				{header: DiagnoseType, width: 75, sortable: false,  dataIndex: 'DiagnoseType'},
				{header: DoctorCode, width: 75, sortable: false,  dataIndex: 'DoctorCode'},
				{header: DoctorName, width: 75, sortable: false,  dataIndex: 'Doctor'},
				{header: DiagnoseDate, width: 75, sortable: false,  dataIndex: 'DiagnoseDate'},
				{header: DiagnoseTime, width: 75, sortable: false,  dataIndex: 'DiagnoseTime'},
				objAdmitDiagnoseColumn
	        ],
			stripeRows: true,
			plugins:objAdmitDiagnoseColumn,
			title:AdmitDiagnose,
			height:110,
			width:780
	}); 
	var objDangerFactorcheckColumn = new Ext.grid.CheckColumn({header: Checked, dataIndex: 'checked', width: 55});
	obj.gridDangerFactor = new Ext.grid.GridPanel({
		store:CreateDicDataStore("InfectionDangerousFactor"),
		columns: [
			new Ext.grid.RowNumberer(),
			{id:'RowID', header: Code, width: 75, sortable: false, dataIndex: 'Code'},
			{header: Desc, width: 250, sortable: false, dataIndex: 'Description'},
			objDangerFactorcheckColumn
		],
		plugins:objDangerFactorcheckColumn,
		stripeRows: true,
		title:DangerousFactor,
		height:150,
		width:780
	});

	var objBasePane =({
		title:BaseInfo,
		xtype:'fieldset',
		frame:true,
		//autoHeight:true,
		width:780,
		//defaults: {width: 800},
		//defaultType: 'textfield',
		layout:"form",
		renderTo:"BasePanel",
		items:[
			//update by zf 2008-08-20
			{
				layout:'column',
				items:[
					{
						columnWidth:.5,
						layout: 'form',
						items:[obj.txtNo,obj.txtName,obj.txtAge,obj.txtDisDate,obj.cboLapseTo,obj.cboICU,obj.cboRepPlace] //Modified BY LiYang 2009-04-07
					},
					{
						columnWidth:.5,
						layout: 'form',
						items:[obj.txtRegNo,obj.txtMrNo,obj.txtSex,obj.txtAdmitDate,obj.txtBed,obj.cboRelation]
					}
				]
			},
			obj.gridAdmitDiagnose,
			obj.gridDangerFactor
		]
   	});
	//********************************Patient BaseInfo Section End********************************
    
	//********************************Operation Infomation Section Start**************************
	obj.chkEmergencyOperation = new Ext.form.Checkbox({fieldLabel:EmergencyOperation});
	obj.dtOpeStartDate = new Ext.form.DateField({fieldLabel:OpeStartDate,width:150,format:'Y-m-d' });
	obj.txtOpeStartTime = new Ext.form.TimeField({fieldLabel:OpeStartTime, increment:10,hideLabel:true,width:100,editable:false,format:'H:i:s' });
	obj.dtOpeEndDate = new Ext.form.DateField({fieldLabel:OpeEndDate,width:150,format:'Y-m-d' });
	obj.txtOpeEndTime = new Ext.form.TimeField({fieldLabel:OpeEndTime, increment:10,hideLabel:true,width:100,editable:false,format:'H:i:s' });
	obj.txtOpeDoctor = new Ext.form.TextField({fieldLabel:Operator, readOnly:true,width:150});
	obj.cboNarcosisType = new Ext.form.ComboBox({fieldLabel:NarcosisType,editable:false,mode: 'local', triggerAction: 'all',store:CreateDicDataStore("InfectionNarcosisType"),displayField:"Description",valueField:"Code",width:150});
	obj.cboCutType = new Ext.form.ComboBox({fieldLabel:CutType,editable:false,mode: 'local', triggerAction: 'all',store:CreateDicDataStore("InfectionOpeCutType"),displayField:"Description",valueField:"Code",width:150});
	obj.cboOpeCutType = new Ext.form.ComboBox({fieldLabel:OpeCutType,editable:false,mode: 'local', triggerAction: 'all',store:CreateDicDataStore("InfectionOperationCutType"),displayField:"Description",valueField:"Code",width:150});
	obj.chkCasuseInf = new Ext.form.Checkbox({fieldLabel:CauseInfection,disabled:IsCasuseInf});
	obj.chkWoundInfection = new Ext.form.Checkbox({fieldLabel:WoundInfection,disabled:IsWoundInfection});
	//obj.txtICD = new Ext.form.TextField({fieldLabel:"ICD",width:150});
	obj.SelDoctor = null;
	obj.SelDoctorHandler = function(objDoctor)
	{
		if(objDoctor == null)
			return;
		obj.SelDoctor = objDoctor.data.DicObj;
		obj.txtOpeDoctor.setValue(objDoctor.data.DoctorName);
	};
	obj.btnQueryDoctor = new Ext.Button({
		text:QueryDoctor,
		handler:function()
		{
			var objFrm = frmSelectDoctor(obj, obj.SelDoctorHandler);
			objFrm.Win.show();
		}
		
	});

	var objOpecheckColumn = new Ext.grid.CheckColumn({
		header: Checked,
		dataIndex: 'checked',
		width: 55,
		onMouseDown : function(e, t){
		        if(t.className && t.className.indexOf('x-grid3-cc-'+this.id) != -1){
		        	e.stopEvent();
		        	var index = this.grid.getView().findRowIndex(t);
		        	var record = this.grid.store.getAt(index);
		        	if(this.id!="ext-gen11" && this.id!="ext-gen13" && this.id!="ext-gen14")
		            		record.set(this.dataIndex, false);
		        	this.grid.store.commitChanges();
		        }
		}
	});
	obj.gridOperation = new Ext.grid.GridPanel({
		store: new Ext.data.SimpleStore({
			fields: [
				{name: 'RowID'},
				{name: 'OperationName'},
				{name: 'EmergencyOperation'},
				{name: 'OrderDate'},
				{name: 'OrderStatus'},
				{name: 'StartDate'},
				{name: 'StartTime'},
				{name: 'EndDate'},
				{name: 'EndTime'},
				{name: 'Operator'},
				{name: 'NarcosisType'},
				{name: 'CutType'},
				{name: 'CloseType'},
				{name: 'CloseTypeObj'},
				{name: 'CutInfected'},
				{name: 'OpeCutType'},
				{name: 'CauseInfection'},
				{name: 'objOpeInfo'},
				{name: 'objRepOpe'},
				{name: 'OperatorObj'},
				{name: 'NarcosisTypeObj'},
				{name: 'CutTypeObj'},
				{name: 'OpeCutTypeObj'},
				{name: 'OpStartTime'},
				{name: 'OpEndTime'},
				{name: 'OpeCutTypeObj'},
				{name: 'checked'},
				{name: 'pChange'},
				{name: 'OpICD'},
				{name: 'OperatorObj'}
			
			]
		}),
		columns: [
			new Ext.grid.RowNumberer(),
			{id:'RowID', header: OperationName, width: 200, sortable: false, dataIndex: 'OperationName'},
			objOpecheckColumn,
			{header: EmergencyOperation, width: 75, sortable: false, dataIndex: 'EmergencyOperation'},
			{header: OpeStartDate, width: 75, sortable: false,  dataIndex: 'OrderDate'},
			{header: OrderStatus, width: 75, sortable: false,  dataIndex: 'OrderStatus'},
			{header: OpeStartDate, width: 75, sortable: false,  dataIndex: 'StartDate'},  //20090826
			{header: OpeEndDate, width: 75, sortable: false,  dataIndex: 'EndDate'},
			{header: Operator, width: 75, sortable: false,  dataIndex: 'Operator'},
			{header: NarcosisType, width: 75, sortable: false,  dataIndex: 'NarcosisType'},
			{header: CutType, width: 75, sortable: false,  dataIndex: 'CutType'},
			{header: CloseType, width: 75, sortable: false,  dataIndex: 'CloseType'},
			{header: CutInfected, width: 75, sortable: false,  dataIndex: 'CutInfected'},
			{header: OperationCutType, width: 75, sortable: false,  dataIndex: 'OpeCutType'},
			{header: CauseInfection, width: 75, sortable: false,  dataIndex: 'CauseInfection'},
			{header: 'ICD', width: 75, sortable: false,  dataIndex: 'OpICD'}
		],
		stripeRows: true,
		selModel: new Ext.grid.CheckboxSelectionModel({header:"AA",width:50}),
		plugins:objOpecheckColumn,
		height:180,
		width:780
	}); 
    	var objOperationPane =({
		title:BaseInfo,
		xtype:'fieldset',
		frame:true,
		autoHeight:true,
		width:780,
		//defaults: {width: 800},
		//defaultType: 'textfield',frame:
		//layout:"form",
		//height:450,
		renderTo:"OperationPanel",
		buttonAlign:'right',
		items:[
			obj.gridOperation,
			{
				xtype:'fieldset',
				frame:true,
				//height:200,
				layout:'column',
				items:[
					{
						//title:GeneralInfo,
						columnWidth:.595,
						//height:158,
						//xtype:'fieldset',
						//frame:true,
						//layout: 'form', 
						items: [
							/*
							{
								layout:"column",
								items:[
									{
										layout:"form",
										columnWidth:.4,
										items:[obj.chkEmergencyOperation]
									},
									{
										layout:"form",
										columnWidth:.4,
										items:[obj.chkCasuseInf]
									}
								]
							},
							{
								layout:"column",
								items:[
									{
										layout:"form",
										columnWidth:.6,
										items:[obj.dtOpeStartDate,obj.dtOpeEndDate,obj.txtOpeDoctor]
									},
									{
										layout:"form",
										columnWidth:.3,
										items:[obj.txtOpeStartTime,obj.txtOpeEndTime,obj.btnQueryDoctor]
									}
								]
							},
							obj.txtICD
							*/
							{
								title:GeneralInfo,
								height:195,
								xtype:'fieldset',
								frame:true,
								items:[
									{
										layout:"column",
										items:[
											{
												layout:"form",
												columnWidth:.4,
												items:[obj.chkEmergencyOperation]
											},
											{
												layout:"form",
												columnWidth:.4,
												items:[obj.chkCasuseInf]
											}
										]
									},
									{
										layout:"column",
										items:[
											{
												layout:"form",
												columnWidth:.63,
												items:[obj.dtOpeStartDate,obj.dtOpeEndDate,obj.txtOpeDoctor]
											},
											{
												layout:"form",
												columnWidth:.3,
												items:[obj.txtOpeStartTime,obj.txtOpeEndTime,obj.btnQueryDoctor]
											}
										]
									}//,
									//obj.txtICD
								]
							}
						]
					},
					{
						columnWidth:.01
					},
					{
						columnWidth:.395,
						//layout: 'form',
						items: [
							{
								xtype:'fieldset',
								frame:true,
								title:NarcosisMethod,
								items:[obj.cboNarcosisType]
							},									                	
							{
								xtype:'fieldset',
								//height:100,
								frame:true,
								title:CutInfo,
								items:[obj.cboCutType,obj.chkWoundInfection,obj.cboOpeCutType]
							}
						]
					}
				]
			}
		],
		buttons:[
			{
				text:Save,
				handler:function(){OpeSaveOnClick.call(obj);}
			}
			
		]
   	});
   	//********************************Operation Infomation Section End****************************
   	
   	//********************************Infection Infomation Section Start**************************
	obj.cboInfPosition = new Ext.form.ComboBox({fieldLabel:InfectionPosition,editable:false,mode: 'local', triggerAction: 'all',store:CreateInfectionPositionStore(),displayField:"Description",valueField:"RowID",width:163});   //update by zf 20090410  Code-->RowID
	obj.dtInfDate = new Ext.form.DateField({fieldLabel:InfectionDate,width:163,format:'Y-m-d'});
	obj.txtInfDiagnose = new Ext.form.TextField({fieldLabel:InfectionDiagnose, readOnly:true,width:163});
	obj.dtEndDate = new Ext.form.DateField({fieldLabel:InfectionEndDate,width:163,format:'Y-m-d',disabled:IsEndDate});
	obj.txtInfDays = new Ext.form.NumberField({fieldLabel:InfectionDays,width:163,disabled:IsInfDays});
	
	//Add By LiYang 2009-09-03
	obj.txtOprStartDate = new Ext.form.DateField({fieldLabel:strOprStart,width:163,format:'Y-m-d',disabled:IsOprStartDate});
	obj.txtOprEndDate = new Ext.form.DateField({fieldLabel:strOprEnd,width:163,format:'Y-m-d',disabled:IsOprEndDate});
	obj.txtOprStartTime = new Ext.form.TimeField({fieldLabel:"", increment:10,hideLabel:true,width:100,editable:false,format:'H:i:s',hideLabel:true,disabled:IsOprStartTime});
	obj.txtOprEndTime = new Ext.form.TimeField({fieldLabel:"", increment:10,hideLabel:true,width:100,editable:false,format:'H:i:s',hideLabel:true,disabled:IsOprEndTime});
	
	obj.objSelInfDis = null;
	obj.SelInfDisHandler = function(objSel)
	{
		if(objSel == null)
			return;
		obj.objSelInfDis = objSel.data.DiseaseObj;
		obj.txtInfDiagnose.setValue(objSel.data.DiseaseName);
	}
	obj.btnQueryInfectionDiagnose = new Ext.Button(
		{
			text:QueryDisease,
			handler:function()
			{
				var InfPosRowid=obj.cboInfPosition.getValue();
				var objSelectDisease = new SelectInfectionDisease(obj, obj.SelInfDisHandler,InfPosRowid);
				objSelectDisease.Win.show();
			}
		}
	);
	
	obj.gridInfetion = new Ext.grid.GridPanel({
		store: new Ext.data.SimpleStore({
			fields: [
				{name: 'RowID'},
				{name: 'Position'},
				{name: 'InfDate', type:'date', dateFormat:'Y-m-d'},
				{name: 'EndDate', type:'date', dateFormat:'Y-m-d'},
				{name: 'Days'},
				{name: 'Diagnose'},
				{name: 'Ope'},
				{name: 'objPosition'},
				{name: 'objDiagnose'},
				{name: 'OpeObj'},
				{name: 'objInfection'},
				{name: 'pChange'},
				//Add By LiYang 2009-09-08
				{name: 'InfStDate'}, 
				{name: 'InfStTime'},
				{name: 'InfEdDate'},
				{name: 'InfEdTime'}
			]
		}),
		columns: [
		new Ext.grid.RowNumberer(),
			{id:'RowID', header: InfectionPosition, width: 180, sortable: false, dataIndex: 'Position'},
			{header: InfectionDate, width: 120, sortable: false, dataIndex: 'InfDate'},
			{header: InfectionEndDate, width: 120, sortable: false, dataIndex: 'EndDate'},
			{header: InfectionDays, width: 80, sortable: false, dataIndex: 'Days'},
			{header: InfectionDiagnose, width: 180, sortable: false, dataIndex: 'Diagnose'},
			{header: InfectionOperation, width: 180, sortable: false, dataIndex: 'Ope'},
			//Add By LiYang 2009-09-08
			{header: strOprStartDate, width: 120, sortable: false, dataIndex: 'InfStDate'},
			{header: strOprStartTime, width: 120, sortable: false, dataIndex: 'InfStTime'},
			{header: strOprEndDate, width: 120, sortable: false, dataIndex: 'InfEdDate'},
			{header: strOprEndTime, width: 120, sortable: false, dataIndex: 'InfEdTime'}			
			
		],
		stripeRows: true,
		selModel: new Ext.grid.CheckboxSelectionModel({header:"AA",width:50}),
		height:200,
		width:770
	});
	var objInfetionOpeColumn = new Ext.grid.CheckColumn({header: Checked, dataIndex: 'checked', width: 55});
	obj.gridInfetionOpe = new Ext.grid.GridPanel({
		store: CreateDicDataStore("InfectionDestructiveOperation"),
		columns: [
			new Ext.grid.RowNumberer(),
			{id:'RowID', header: Code, width: 50, sortable: false, dataIndex: 'Code'},
			{header: Desc, width: 130, sortable: false, dataIndex: 'Description'},
			objInfetionOpeColumn
		],
		plugins:objInfetionOpeColumn,
		stripeRows: true,
		selModel: new Ext.grid.CheckboxSelectionModel({header:"AA",width:50}),
		//title:InfectionOperation,
		height:180,
		width:280
	});
	    
	var objInfectionPane =({
			title:InfectionInfo,
			xtype:'fieldset',
			frame:true,
			//autoHeight:true,
			width:780,
			//defaults: {width: 800},
			//defaultType: 'textfield',
			//height:450,
			//layout:"form",
			renderTo:"InfectionPanel",
			buttonAlign:'right',
			items:[
				obj.gridInfetion,
				{
					layout:'column',
					items:[
						{
							columnWidth:.58,
							items: [
								{
									title:InfectionInfo,
									xtype:'fieldset',
									frame:true,
									//height:200,
									items: [
										obj.cboInfPosition,
										obj.dtInfDate,
										{											
											layout:'column',
											//width:1600,
											items:[
												{
													layout:'form',
													columnWidth:.65,
													items:[
														obj.txtInfDiagnose
													]
												},
												{
													layout:'form',
													columnWidth:.3,
													items:[
														obj.btnQueryInfectionDiagnose
													]													
												}
											]
										}
										,
										obj.dtEndDate,
										obj.txtInfDays,
										//Add By LiYang 2009-09-03
										{											
											layout:'column',
											//width:1600,
											items:[
												{
													layout:'form',
													columnWidth:.65,
													items:[
														obj.txtOprStartDate,
														obj.txtOprEndDate
													]
												},
												{
													layout:'form',
													columnWidth:.3,
													//width:600,
													items:[
														obj.txtOprStartTime,
														obj.txtOprEndTime
													]													
												}
											]
										}																	
									]
								}
							]
						},
						{
							columnWidth:.01
						},
						{
							columnWidth:.4,
							items: [
								{
									title:InfectionOperation,
									xtype:'fieldset',
									frame:true,
									height:220,
									items: [obj.gridInfetionOpe]
								}
							]
						}
					]	
				},
				obj.gridAdmitDiagnose,
				obj.gridDangerFactor
			],
			buttons:[
				{
					text:Del,
					handler:function()
					{
						var objData = GetGridSelectedData(obj.gridInfetion);
						if(objData == null)
						return;
						obj.gridInfetion.getStore().remove(objData);
					}
				},
				{
					text:Save,
					handler:function(){SaveInfInfoOnClick.call(obj);}
				}
			]
                       
   	});
	//********************************Infection Infomation Section End****************************
	 		
	//********************************Lab Check Infomation Section Start**************************
	obj.cboSimple = new Ext.form.ComboBox({fieldLabel:Simple,width:150,editable:false,mode: 'local', triggerAction: 'all',store:CreateDicDataStore("InfectionLabSampleType"),displayField:"Description",valueField:"Code"});
	obj.cboLabInfPos = new Ext.form.ComboBox({fieldLabel:LabInfPos,width:150,editable:false,mode: 'local', triggerAction: 'all',store:CreateInfectionPositionStore(),displayField:"Description",valueField:"RowID"});    //update by zf 2009-0410 Code-->RowID
	obj.dtLabDate = new Ext.form.DateField({fieldLabel:LabDate,width:150,format:'Y-m-d' });
	obj.cboCheckMethod = new Ext.form.ComboBox({fieldLabel:CheckMethod ,width:150,editable:false,mode: 'local', triggerAction: 'all',store:CreateDicDataStore("InfectionPathogenyCheckMethod"),displayField:"Description",valueField:"Code"});
	//obj.chkSensitiveCheck = new Ext.form.Checkbox({fieldLabel:SensitiveCheck});
	//2009-10-10 cjb
	//InfectionLabSensitive  :  
	
	obj.cboSensitive=new Ext.form.ComboBox({fieldLabel:SensitiveCheck,width:150,editable:false,mode: 'local', triggerAction: 'all',store:CreateDicDataStore("InfectionLabSensitive"),displayField:"Description",valueField:"Code"});
	obj.cboSensitive.on(
		"select",
		function(){
			var objDic=GetDicComboValue(obj.cboSensitive);
			var Code=objDic.Code;
			//if(Code=="1"){
			if(Code=="Y"){
				obj.btnSen.enable();
			}
			else{
				obj.btnSen.disable();
			}
		},
		obj
	);
	//cjb 20091012
	obj.btnSen=new Ext.Button({
		text:strSenAdd,
		disabled:true,
		handler:function(){
			//Modified By LiYang 2009-11-21 display test result
			var objData = GetGridSelectedData(obj.gridLab);
			var objLabItem = objData.get("objLabItem");
			var objFrm = new SelectGermSen(obj.LabGermArry, objLabItem.LabTestSetRow);
			objFrm.Win.show();
			//var objFrm = new SelectGermSen(obj.LabGermArry);
			//objFrm.Win.show();
		}
	});
			
	var objLabcheckColumn = new Ext.grid.CheckColumn({
		header: Checked,
		dataIndex: 'checked',
		width: 55,
		onMouseDown : function(e, t){
		        if(t.className && t.className.indexOf('x-grid3-cc-'+this.id) != -1){
		        	e.stopEvent();
		        	var index = this.grid.getView().findRowIndex(t);
		        	var record = this.grid.store.getAt(index);
		        	if(this.id!="ext-gen11" && this.id!="ext-gen13" && this.id!="ext-gen14")
		            		record.set(this.dataIndex, false);
		        	this.grid.store.commitChanges();
		        }
		}
	});
	obj.LabGermArry = null;
	obj.gridLab = new Ext.grid.GridPanel({
	        store: new Ext.data.SimpleStore({
			fields: [
				 {name: 'RowID'},
				 {name: 'LabCheckName'},
				 {name: 'OrderDate'},
				 {name: 'OrderStatus'},
				 {name: 'InfectionPosition'},
				 {name: 'CheckDate'},
				 {name: 'CheckMethod'},
				 {name: 'SensitiveCheck'},
				 {name: 'SensitiveObj'},
				 {name: 'CheckMethodObj'},
				 {name: 'objLabItem'},
				 {name: 'objInfLab'},
				 {name: 'Simple'},
				 {name: 'SimpleObj'},
				 {name: 'InfectionPositionObj'},	
				 {name: 'ArryGerm'},
				 {name: 'checked'},
				 {name: 'pChange'}
			]
		}),
		columns: [
			new Ext.grid.RowNumberer(),
			{id:'RowID', header: LabCheckName, width: 200, sortable: false, dataIndex: 'LabCheckName'},
			objLabcheckColumn,
			{header: OrderDate, width: 100, sortable: false, dataIndex: 'OrderDate'},
			{header: OrderStatus, width: 100, sortable: false, dataIndex: 'OrderStatus'},
			{header: InfectionPosition, width: 100, sortable: false, dataIndex: 'InfectionPosition'},
			{header: LabDate, width: 100, sortable: false, dataIndex: 'CheckDate'},
			{header: CheckMethod, width: 100, sortable: false, dataIndex: 'CheckMethod'},
			{header: SensitiveCheck, width: 100, sortable: false, dataIndex: 'SensitiveCheck'}
		],
		stripeRows: true,
		plugins:objLabcheckColumn,
		selModel: new Ext.grid.CheckboxSelectionModel({header:"AA",width:50}),
		height:300,
		width:770
	});
	    
	var objLabPane = ({
		title:LabInfo,
		xtype:'fieldset',
		frame:true,
		//autoHeight:true,
		width:780,
		//defaults: {width: 800},
		//defaultType: 'textfield',
		height:450,
		layout:"form",
		renderTo:"LabPanel",
		buttonAlign:'right',
		items:[
			obj.gridLab,
			{
				title:LabInfo,
				xtype:'fieldset',
				frame:true,
				height:120,
				layout:'column',
				items:[
					{
						columnWidth:.4,
						layout: 'form',
						items: [obj.cboSimple,obj.cboLabInfPos,obj.cboSensitive]
					},
					{
						columnWidth:.4,
						layout: 'form',
						items: [obj.dtLabDate,obj.cboCheckMethod]
					}
				]
			}
		],
		buttons:[
			obj.btnSen,
			{
				text:Save,
				handler:function(){
					if(!ValidateLabInfo())
						return;	
					var objData = GetGridSelectedData(obj.gridLab);
					var objStore = obj.gridLab.getStore();
					LabSaveOnClick(objData);	
					objStore.commitChanges();
					obj.gridLab.getView().refresh();             					
				}
			}
		]
                       
	});
	//********************************Lab Check Infomation Section End****************************
  
  
	//********************************AntiBio Drug Infomation Section Start***********************
	obj.chkUntowardReaction = new Ext.form.Checkbox({fieldLabel:UntowardReaction,width:130});
	obj.chkDoubleInfection = new Ext.form.Checkbox({fieldLabel:DoubleInfection,width:130});
	
	obj.cboDrugsRoute = new Ext.form.ComboBox({fieldLabel:DrugsRoute,width:130,editable:false,mode: 'local', triggerAction: 'all',store:CreateDicDataStore("InfectionAdministerDrugsRoute"),displayField:"Description",valueField:"Code"});
	obj.cboAdministerDrugs = new Ext.form.ComboBox({fieldLabel:AdministerDrugs,width:130,editable:false,mode: 'local', triggerAction: 'all',store:CreateDicDataStore("InfectionAdministerDrugs"),displayField:"Description",valueField:"Code"});
	obj.cboInfectionAdministerDrugsGoal = new Ext.form.ComboBox({fieldLabel:InfectionAdministerDrugsGoal,width:130,editable:false,mode: 'local', triggerAction: 'all',store:CreateDicDataStore("InfectionAdministerDrugsGoal"),displayField:"Description",valueField:"Code"});
	obj.cboCureAdministerDrugsType = new Ext.form.ComboBox({fieldLabel:CureAdministerDrugsType,width:130,editable:false,mode: 'local', triggerAction: 'all',store:CreateDicDataStore("InfectionCureAdministerDrugsType"),displayField:"Description",valueField:"Code"});
	//20090916 cjb
	obj.cboInfectionAdministerDrugsGoal.on(
		"select",
		function(){
			var objDicAdmin=GetDicComboValue(obj.cboInfectionAdministerDrugsGoal);
			var Descr=objDicAdmin.Desc;
			var ind=Descr.indexOf(yf);
			if(ind<0){
				obj.cboDefendAdministerDrugsType.disable();
				obj.chkIndication.disable();
				obj.cboEffect.disable();
				}
			else{
				obj.cboDefendAdministerDrugsType.enable();
				obj.chkIndication.enable();
				obj.cboEffect.enable();
				}
			},
		obj
	);
	obj.cboDefendAdministerDrugsType = new Ext.form.ComboBox({fieldLabel:DefendAdministerDrugsType,width:130,editable:false,mode: 'local', triggerAction: 'all',store:CreateDicDataStore("InfectionDefendAdministerDrugsType"),displayField:"Description",valueField:"Code"});
	obj.chkIndication = new Ext.form.Checkbox({fieldLabel:Indication,width:130});
	obj.cboEffect = new Ext.form.ComboBox({fieldLabel:Effect,width:130,editable:false,mode: 'local', triggerAction: 'all',store:CreateDicDataStore("InfDefendDrugEffect"),displayField:"Description",valueField:"Code"});
	obj.cboUnionDrug = new Ext.form.ComboBox({fieldLabel:UnionDrug,width:130,editable:false,mode: 'local', triggerAction: 'all',store:CreateDicDataStore("InfUnionDrug"),displayField:"Description",valueField:"Code"});
	obj.chkAroundOpeDrug = new Ext.form.Checkbox({fieldLabel:AroundOpeDrug,width:130});
	obj.chkAroundOpeDrug.on(
		"check",
		function(){
			var chkVal=obj.chkAroundOpeDrug.getValue();
			if(chkVal){
				obj.txtDay.enable();
				obj.txtHour.enable();
				obj.txtMinute.enable();
				obj.txtAfter.enable();
				obj.cboCurativeEffect.enable();
				}
			else{
				obj.txtDay.disable();
				obj.txtHour.disable();
				obj.txtMinute.disable();
				obj.txtAfter.disable();
				obj.cboCurativeEffect.disable();
				}
			},
		obj
	);
	obj.cboRationality = new Ext.form.ComboBox({fieldLabel:Rationality,width:130,editable:false,mode: 'local', triggerAction: 'all',store:CreateDicDataStore("InfRationality"),displayField:"Description",valueField:"Code"});
	obj.txtDay = new Ext.form.TextField({fieldLabel:Day,width:130}); 
	obj.txtHour = new Ext.form.TextField({fieldLabel:Hour,width:130}); 
	obj.txtMinute = new Ext.form.TextField({fieldLabel:Minute,width:130}); 
	obj.txtAfter = new Ext.form.TextField({fieldLabel:After,width:130}); 
	obj.cboIrrationality = new Ext.form.ComboBox({fieldLabel:Irrationality,width:130,editable:false,mode: 'local', triggerAction: 'all',store:CreateDicDataStore("InfIrrationality"),displayField:"Description",valueField:"Code"});
	obj.cboCurativeEffect = new Ext.form.ComboBox({fieldLabel:CurativeEffect,width:130,editable:false,mode: 'local', triggerAction: 'all',store:CreateDicDataStore("InfCurativeEffect"),displayField:"Description",valueField:"Code"});
	var objDrugcheckColumn = new Ext.grid.CheckColumn({
		header: Checked,
		dataIndex: 'checked',
		width: 55,
		onMouseDown : function(e, t){
		        if(t.className && t.className.indexOf('x-grid3-cc-'+this.id) != -1){
		        	e.stopEvent();
		        	var index = this.grid.getView().findRowIndex(t);
		        	var record = this.grid.store.getAt(index);
		        	if(this.id!="ext-gen11" && this.id!="ext-gen13" && this.id!="ext-gen14")
		            		record.set(this.dataIndex, false);
		        	this.grid.store.commitChanges();
		        }
		}
	});
	obj.gridDrug = new Ext.grid.GridPanel({
		store: new Ext.data.SimpleStore({
			fields: [
				 {name: 'RowID'},
				 {name: 'DrugName'},
				 {name: 'DrugsRoute'},
				 {name: 'FromDate'},
				 {name: 'ToDate'},
				 {name: 'UseDayCnt'},
				 {name: 'AdministerDrugs'},
				 {name: 'InfectionAdministerDrugsGoal'},
				 {name: 'CureAdministerDrugsType'},
				 {name: 'DefendAdministerDrugsType'},
				 {name: 'Indication'},
				 {name: 'Effect'},
				 {name: 'UnionDrug'},
				 {name: 'AroundOpeDrug'},
				 {name: 'BeforeOpeDate'},
				 {name: 'AfterOpeDate'},
				 {name: 'Rationality'},
				 {name: 'Irrationality'},
				 {name: 'CurativeEffect'},
				 {name: 'ArcimObj'},
				 {name: 'RepObj'},
				 {name:"DrugsRouteObj"},
				 {name:"AdministerDrugsObj"},
				 {name:"InfectionAdministerDrugsGoalObj"},
				 {name:"CureAdministerDrugsTypeObj"},
				 {name:"DefendAdministerDrugsTypeObj"},
				 {name:"IndicationObj"},
				 {name:"EffectObj"},
				 {name:"UnionDrugObj"},
				 {name:"AroundOpeDrugObj"},
				 {name:"BeforeOpeDateObj"},
				 {name:"AfterOpeDateObj"},
				 {name:"RationalityObj"},
				 {name:"IrrationalityObj"},
				 {name:"CurativeEffectObj"},
				 {name: 'Day'},
				 {name: 'Minute'},
				 {name: 'Hour'},
				 {name: 'checked'},
				 {name: 'pChange'}
			]
		}),
	        columns: [
			new Ext.grid.RowNumberer(),
			{id:'RowID', header: DrugName, width: 200, sortable: false, dataIndex: 'DrugName'},
			objDrugcheckColumn,
			{header: DrugsRoute, width: 80, sortable: false, dataIndex: 'DrugsRoute'},
			{header: FromDate, width: 80, sortable: false, dataIndex: 'FromDate'},
			{header: ToDate, width: 80, sortable: false, dataIndex: 'ToDate'},
			{header: UseDayCnt, width: 80, sortable: false, dataIndex: 'UseDayCnt'},
			{header: AdministerDrugs, width: 80, sortable: false, dataIndex: 'AdministerDrugs'},
			{header: InfectionAdministerDrugsGoal, width: 80, sortable: false, dataIndex: 'InfectionAdministerDrugsGoal'},
			{header: CureAdministerDrugsType, width: 80, sortable: false, dataIndex: 'CureAdministerDrugsType'},
			{header: DefendAdministerDrugsType, width: 80, sortable: false, dataIndex: 'DefendAdministerDrugsType'},
			{header: Indication, width: 80, sortable: false, dataIndex: 'Indication'},
			{header: Effect, width: 80, sortable: false, dataIndex: 'Effect'},
			{header: UnionDrug, width: 80, sortable: false, dataIndex: 'UnionDrug'},
			{header: AroundOpeDrug, width: 80, sortable: false, dataIndex: 'AroundOpeDrug'},
			{header: BeforeOpeDate, width: 80, sortable: false, dataIndex: 'BeforeOpeDate'},
			{header: AfterOpeDate, width: 80, sortable: false, dataIndex: 'AfterOpeDate'},
			{header: Rationality, width: 80, sortable: false, dataIndex: 'Rationality'},
			{header: Irrationality, width: 80, sortable: false, dataIndex: 'Irrationality'},
			{header: CurativeEffect, width: 80, sortable: false, dataIndex: 'CurativeEffect'}
	        ],
		stripeRows: true,
		plugins:objDrugcheckColumn,
		selModel: new Ext.grid.CheckboxSelectionModel({header:"AA",width:50}),
		height:200,
		width:780
	}); 
	    
	var objDrugPane = (
		{
			title:AntiBioDrugInfo,
			xtype:'fieldset',
			frame:true,
			//autoHeight:true,
			width:780,
			//defaults: {width: 800},
			//defaultType: 'textfield',
			height:450,
			layout:"form",
			renderTo:"DrugPanel",
			buttonAlign:'right',
			items:[
				{
					layout:'column',
					items:[
						{
							columnWidth:.4,
							layout: 'form',										
							items:[obj.chkUntowardReaction]
						},
						{
							columnWidth:.4,
							layout: 'form',										
							items:[obj.chkDoubleInfection]
						}
					]
				},
				obj.gridDrug,
                        	{
	                        	title:AntiBioDrugInfo,
					xtype:'fieldset',
					frame:true,
					height:130,
					layout:'form',
					items:[
						{
							layout:'column',
							items:[
								{
									columnWidth:.33,
									layout: 'form',
									items: [obj.cboDrugsRoute,obj.cboInfectionAdministerDrugsGoal,obj.cboCureAdministerDrugsType,obj.cboDefendAdministerDrugsType,obj.chkIndication,obj.cboEffect]
								},
								{
									columnWidth:.33,
									layout: 'form',
									items: 
									[obj.cboAdministerDrugs,obj.chkAroundOpeDrug,obj.txtDay,obj.txtHour,obj.txtMinute,obj.txtAfter]
								},
								{
									columnWidth:.33,
									layout: 'form',
									items: [obj.cboUnionDrug,obj.cboRationality,obj.cboIrrationality,obj.cboCurativeEffect]
								}
							]
						}
					]
				}
			],
			buttons:[
				{
					text:Save,
					handler:function()
					{
						var objData = GetGridSelectedData(obj.gridDrug);
						var objStore = obj.gridDrug.getStore();
						DrugSaveOnClick(objData);	
						objStore.commitChanges();
						obj.gridDrug.getView().refresh();
					}
				}
			]
                       
   		});
  //********************************AntiBio Drug Infomation Section End***********************************

  //********************************Init Event Start******************************************************
    obj.gridOperation.on('click',
  	function()
  	{
  		  var objData = GetGridSelectedData(this);
        if(objData != null)
        	DisplayOpeInfo(objData);	
  	}
  ) 
  
  
  obj.gridDrug.on('click',
  	function()
  	{
  		  var objData = GetGridSelectedData(this);
        if(objData != null)
        	DisplayDrugInfo(objData);	
  	}
  )
  
  obj.gridLab.on('click',
  	function()
  	{
  		var objData = GetGridSelectedData(this);
	        if(objData != null)
	        	DisplayLabInfo(objData);
  	}
  )
  //********************************Init Event End******************************************************
  
  //********************************Generate GUI Start**************************************************
        
	obj.tabFrm = new Ext.TabPanel({
		//width:800,
		//height:300,
		//autoHeight:true,
		activeTab: 0,
		frame:true
	});
	obj.tblBaseInfo = obj.tabFrm.add(new Ext.FormPanel(objBasePane));
	obj.tblOperationInfo = obj.tabFrm.add(new Ext.FormPanel(objOperationPane));
	obj.tblInfectionInfo = obj.tabFrm.add(new Ext.FormPanel(objInfectionPane ));
	obj.tblLabInfo = obj.tabFrm.add(new Ext.FormPanel(objLabPane ));
	obj.tblDrugInfo = obj.tabFrm.add(new Ext.FormPanel(objDrugPane));
	obj.tblBaseInfo.setTitle(BaseInfo);
	obj.tblOperationInfo.setTitle(OperationInfo);
	obj.tblInfectionInfo.setTitle(InfectionInfo);
	obj.tblLabInfo.setTitle(LabInfo);
	obj.tblDrugInfo.setTitle(AntiBioDrugInfo);
    
	obj.btnSave = new Ext.Button({
        	    text:SaveAA,    //update by zf 2008-12-09 Save-->SaveAA
        	    minWidth:80,
        	    disabled:!(HasPower('MethodUserFunction', session['LOGON.GROUPID'], appName, 'ReportInfection') || HasPower('MethodUserFunction', session['LOGON.GROUPID'], appName, 'Super')),
        	    handler:function()
        	    {
					SaveReport();
				}  
	});

	obj.EditInfWin = new Ext.Window({
	    title: WindowTitle,
	    layout: 'fit',
	    bodyStyle: 'padding:5px;',
	    maximizable: false,
	    closable: false,
	    collapsible:false,
	    shadow: true,
	    modal: true,
	    width: 820,
	    height: 600,
	    closeAction: 'hide',
	    plain: true,
	    //autoHeight: true,
	    //renderTo:"MainPanel",
	    //modal:true,
	    xtype:'window',
	    items: [obj.tabFrm],
	    buttons: [
		        {
		            text: "ICD",
		            disabled: !(HasPower('MethodUserFunction', session['LOGON.GROUPID'], appName, 'AuditReport') || HasPower('MethodUserFunction', session['LOGON.GROUPID'], appName, 'Super')),
		            handler: function() {
		            		var arryDis = new Array();
		            		var arryOpe = new Array();
		            		var objRep = null;
		            		var objRepDia = null;
		            		var objRepOpe = null;
		            		var objStore = null;
		            		objStore = obj.gridAdmitDiagnose.getStore();
		            		for(var i = 0; i < objStore.getCount(); i ++)
		            		{
		            			objDia = objStore.getAt(i);
		            			objRep = objDia.get("objRepDiagnose");
		            			if(objRep != null)
		            			{
		            				if(objRep.RepDia != null)
		            				{
		            					arryDis.push(objRep.RepDia);
		            				}
		            			}	
		            		}
		            		objStore = obj.gridOperation.getStore();
		            		for(var i = 0; i < objStore.getCount(); i ++)
		            		{
		            			objDia = objStore.getAt(i);
		            			objRep = objDia.get("objRepOpe");
		            			if(objRep != null)
		            			{
		            					arryOpe.push(objRep);
		            			}	
		            		}		            		
		            		
		                var objInputICD = new InfectionInputICD(null,arryDis,arryOpe);
		                objInputICD.Win.show();
		            }
		        },
	        	{
	        	    text: Audit,
	        	    disabled: !(HasPower('MethodUserFunction', session['LOGON.GROUPID'], appName, 'AuditReport') || HasPower('MethodUserFunction', session['LOGON.GROUPID'], appName, 'Super')),
	        	    handler: function() {
	        	        Ext.Msg.show({
	        	            title: Audit,
	        	            msg: ConfirmAudit,
	        	            buttons: Ext.Msg.YESNO,
	        	            fn: function(btn) {
	        	                if (btn == 'yes') {
	        	                    CheckReport(2, "");
	        	                }
	        	            }
						   ,
	        	            icon: Ext.MessageBox.QUESTION
	        	        });
	        	    }
	        	},
	        	{
	        	    text: SendBack,
	        	    disabled: !(HasPower('MethodUserFunction', session['LOGON.GROUPID'], appName, 'AuditReport') || HasPower('MethodUserFunction', session['LOGON.GROUPID'], appName, 'Super')),
	        	    handler: function() {
	        	        Ext.Msg.prompt(
						SendBack,
						PleaseInputSendBackReason,
						function(btn, text) {
						    if (btn == 'ok') {
						        if (text != "") {
						            CheckReport(9, text);
						        } else {
						            Ext.Msg.alert(Notice, PleaseInputSendBackReason);
						        }
						    }
						},
				    		null,
				    		true
					);
	        	    }
	        	},
	        	{
	        	    text: strDel,
	        	    disabled: !(HasPower('MethodUserFunction', session['LOGON.GROUPID'], appName, 'ReportInfection') || HasPower('MethodUserFunction', session['LOGON.GROUPID'], appName, 'Super')),
	        	    handler: function() {
	        	        Ext.Msg.prompt(
						strDel,
						PleaseInputDelReason,
						function(btn, text) {
						    if (btn == 'ok') {
						        if (text != "") {
						            DeleteReport(text);
						        } else {
						            Ext.Msg.alert(Notice, PleaseInputDelReason);
						        }
						    }
						},
						null,
						true
					);
	        	    }
	        	},
			obj.btnSave,
	        	{
	        	    text: Cancel,
	        	    handler: function() {
	        	        obj.EditInfWin.hide();
	        	        window.close();
	        	    }
	        	}
		]
	});
  //********************************Generate GUI End**************************************************
      return obj;
}

Ext.grid.CheckColumn = function(config){
    Ext.apply(this, config);
    if(!this.id){
        this.id = Ext.id();
    }
    this.renderer = this.renderer.createDelegate(this);
};

Ext.grid.CheckColumn.prototype ={
    init : function(grid){
        this.grid = grid;
        this.grid.on('render', function(){
            var view = this.grid.getView();
            view.mainBody.on('mousedown', this.onMouseDown, this);
        }, this);
    },

    onMouseDown : function(e, t){
        if(t.className && t.className.indexOf('x-grid3-cc-'+this.id) != -1){
            e.stopEvent();
            var index = this.grid.getView().findRowIndex(t);
            var record = this.grid.store.getAt(index);
            record.set(this.dataIndex, !record.data[this.dataIndex]);
            this.grid.store.commitChanges();
        }
    },

    renderer : function(v, p, record){
        p.css += ' x-grid3-check-col-td'; 
        return '<div class="x-grid3-check-col'+(v?'-on':'')+' x-grid3-cc-'+this.id+'">&#160;</div>';
    }
};
