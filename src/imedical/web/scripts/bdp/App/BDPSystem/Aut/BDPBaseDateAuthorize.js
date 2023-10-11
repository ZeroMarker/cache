// 通用授权页面
// 2014-8-19 by caihaozhe
document.write('<script type="text/javascript" src="../scripts/bdp/Framework/scripts/DataAutPanelPublic.js"> </script>');
document.write('<script type="text/javascript" src="../scripts/bdp/Framework/scripts/BDPComboBox.js"> </script>');
//document.write('<script type="text/javascript" src="../scripts/bdp/Framework/scripts/websys.comm.ext.js"> </script>');

Ext.onReady(function() {
	
	var ObjectReference=Ext.BDP.FunLib.getParam('ObjectReference')  //选中的类别ID，全局变量
	var ObjectType=Ext.BDP.FunLib.getParam('ObjectType')			//选中的类别类型，全局变量
	var AutCode=Ext.BDP.FunLib.getParam('AutCode')    //获取授权页代码
	
	var BindingLoc = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.CTLoc&pClassQuery=GetDataForCmb1";
	var BindingGroup = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.SSGroup&pClassQuery=GetDataForCmb1";
	var BindingSpec = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.CTSpec&pClassQuery=GetList";
	
	var BindingCarPrvTp = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.CTCarPrvTp&pClassQuery=GetDataForCmb1";
	var BindingHosp="../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.CTHospital&pClassQuery=GetDataForCmb1";
	
	var DEPDR_QUERY_ACTION_URL = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.RBCDepartmentGroup&pClassQuery=GetDataForCmb1"; 
    
	var OCGRP_QUERY_ACTION_URL = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.OECOrderCategoryGroup&pClassQuery=GetDataForCmb1";
	var ORDCAT_QUERY_ACTION_URL = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.OECOrderCategory&pClassQuery=GetDataForCmb1";
    
	var CT_Region_DR_QUERY_ACTION_URL = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.CTRegion&pClassQuery=GetDataForCmb1";
    var CT_Province_DR_QUERY_ACTION_URL = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.CTProvince&pClassQuery=GetDataForCmb1";
	var CITAREA_City_DR_QUERY_ACTION_URL = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.CTCity&pClassQuery=GetDataForCmb1";
	
    Ext.QuickTips.init();
	var Tree_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.BDP.Authorize&pClassMethod=GetTreeJson";
	
	//多院区医院下拉框
	var objectName=AutCode
	if ((objectName=="SS_User")||(objectName=="CT_CareProv")) objectName="CT_Loc"  //用户和医护人员 ，显示所有院区
	//var hospComp=GenHospComp(objectName);	
	var objstore=new Ext.data.Store({
				proxy : new Ext.data.HttpProxy({ url : "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.BDP.BDPMappingHOSP&pClassQuery=GetHospDataForCombo"+"&tablename="+objectName+"&SessionStr="+""}),
				reader : new Ext.data.JsonReader({
							totalProperty : 'total',
							root : 'data',
							successProperty : 'success'
						}, [ 'HOSPRowId', 'HOSPDesc' ])
		})
		
		var hospComp = new Ext.form.ComboBox({
			id:'_HospList',
			labelSeparator:"",
			DataType:tkMakeServerCall("web.DHCBL.BDP.BDPTableList","GetDataType",objectName),  //公有G，私有S，绝对私有A，管控C
			width:150,
			fieldLabel : $g('医院'),
			store : objstore,
			editable:false,
			queryParam : 'desc',
			triggerAction : 'all',
			forceSelection : true,
			selectOnFocus : false,
			listWidth :250,
			valueField : 'HOSPRowId',
			displayField : 'HOSPDesc'
		});
		/*objstore.load({
		       callback: function () {
			       var thisHospId=tkMakeServerCall("web.DHCBL.BDP.BDPMappingHOSP","GetDefHospIdByTableName",objectName,session['LOGON.HOSPID'])
			       hospComp.setValue(thisHospId);   //初始赋值为当前登录科室的院区
			       Ext.getCmp('_HospList').fireEvent('select',Ext.getCmp('_HospList'),Ext.getCmp('_HospList').getStore().getById(thisHospId))  //触发select事件
		        },
		        scope: objstore,
		        add: false
		});*/
	//alert(AutCode);
 	if(AutCode=="CT_CarPrvTp"){
 		//医护人员类型筛选条件
		var tb = new Ext.Toolbar({
				id : 'tb',
				items : [ '类型', {
							fieldLabel : '类型',
							xtype : 'combo',
							id : 'TextInternalType',
							disabled : Ext.BDP.FunLib.Component.DisableFlag('TextInternalType'),
							width : 140,
							mode : 'local',
							// hiddenName:'hxxx',//不能与id相同
							triggerAction : 'all',// query
							forceSelection : true,
							selectOnFocus : false,
							//typeAhead : true,
							//minChars : 1,
							listWidth : 140,
							valueField : 'value',
							displayField : 'name',
							store : new Ext.data.JsonStore({
								fields : ['name', 'value'],
								data : [{
											name : 'NURSE(护士)',
											value : 'NURSE'
										}, {
											name : 'DOCTOR(医生)',
											value : 'DOCTOR'
										}, {
											name : 'Technician(技师)',
											value : 'Technician'
										}, {
											name : 'Pharmacist(药师)',
											value : 'Pharmacist'
										}, {
											name : 'Other(其他)',
											value : 'Other'
										}]
							})
						}
				]
			});
 	}
 	else if(AutCode=="SS_User"){
 		//用户筛选条件
		var tb = new Ext.Toolbar({
				id : 'tb',
				items : [ '医院', hospComp,'-',
						'登录科室', {
							id : 'DefDeptDR',
							xtype : 'combo',
							width:90,
							// hiddenName:'sss',//不能与id相同
							triggerAction : 'all',// query
							queryParam : "desc",
							forceSelection : true,
							selectOnFocus : false,
							mode : 'remote',
							pageSize : Ext.BDP.FunLib.PageSize.Combo,
							//allQuery : '',
							//minChars : 1,
							listWidth : 250,
							valueField : 'CTLOCRowID',
							displayField : 'CTLOCDesc',
							store : new Ext.data.JsonStore({
										url : BindingLoc,
										root : 'data',
										totalProperty : 'total',
										idProperty : 'CTLOCRowID',
										fields : ['CTLOCRowID', 'CTLOCDesc'],
										remoteSort : true,
										sortInfo : {
											field : 'CTLOCRowID',
											direction : 'ASC'
										}
									}),
                        	listeners:{	
                               'beforequery': function(e){
                                    this.store.baseParams = {
                                            desc:e.query,
                                            hospid:hospComp.getValue()
                                    };
                                    this.store.load({params : {
                                                start : 0,
                                                limit : Ext.BDP.FunLib.PageSize.Combo
                                    }})
                                
                                }
                        	}
						},'-', '所在安全组',{
							id : 'SSGRP',
							xtype : 'combo',
							width:90,
							// hiddenName:'sss',//不能与id相同
							triggerAction : 'all',// query
							queryParam : "desc",
							forceSelection : true,
							selectOnFocus : false,
							mode : 'remote',
							pageSize : Ext.BDP.FunLib.PageSize.Combo,
							//allQuery : '',
							//minChars : 1,
							listWidth : 250,
							valueField : 'SSGRPRowId',
							displayField : 'SSGRPDesc',
							store : new Ext.data.JsonStore({
										url : BindingGroup,
										root : 'data',
										totalProperty : 'total',
										idProperty : 'SSGRPRowId',
										fields : ['SSGRPRowId', 'SSGRPDesc'],
										remoteSort : true,
										sortInfo : {
											field : 'SSGRPRowId',
											direction : 'ASC'
										}
									}),
                        	listeners:{	
                               'beforequery': function(e){
                                    this.store.baseParams = {
                                            desc:e.query,
                                            hospid:hospComp.getValue()
                                    };
                                    this.store.load({params : {
                                                start : 0,
                                                limit : Ext.BDP.FunLib.PageSize.Combo
                                    }})
                                
                                }
                        	}
									
						}, '-', '医护人员类型', {
						    	width:90,
						    	xtype : 'combo',
						    	loadByIdParam : 'rowid',
								//fieldLabel: '医护人员类型',
								id:'careprovtype',
								triggerAction:'all',//query
								forceSelection: true,
								selectOnFocus:false,
								mode:'remote',
								pageSize:Ext.BDP.FunLib.PageSize.Combo,
								//minChars: 1,
								listWidth:250,
								valueField:'CTCPTRowId',
								displayField:'CTCPTDesc',
								store:new Ext.data.JsonStore({
									url:BindingCarPrvTp,
									root: 'data',
									totalProperty: 'total',
									idProperty: 'CTCPTRowId',
									fields:['CTCPTRowId','CTCPTDesc'],
									remoteSort: true,
									sortInfo: {field: 'CTCPTRowId', direction: 'ASC'}	
								})
							}
				]
			});
 	}
 	else if(AutCode=="CT_CareProv"){
 		//医护人员筛选条件
	 	var tb= new Ext.Toolbar({
	        id:'tb',
	        items:[ '医院', hospComp,'-',
	        	'医护人员类型',{
	            			xtype : 'combo',
					    	width:100,
					    	loadByIdParam : 'rowid',
							fieldLabel: '医护人员类型',
							id:'CarePrvTp',
							triggerAction:'all',//query
							forceSelection: true,
							selectOnFocus:false,
							//typeAhead:true,
							mode:'remote',
							pageSize:Ext.BDP.FunLib.PageSize.Combo,
							//minChars: 0,
							listWidth:250,
							valueField:'CTCPTRowId',
							displayField:'CTCPTDesc',
							store:new Ext.data.JsonStore({
								url:BindingCarPrvTp,
								root: 'data',
								totalProperty: 'total',
								idProperty: 'CTCPTRowId',
								fields:['CTCPTRowId','CTCPTDesc'],
								remoteSort: true,
								sortInfo: {field: 'CTCPTRowId', direction: 'ASC'}	
							})
						},'-','激活状态',{
							fieldLabel: '激活状态',
							xtype:'combo',
							id:'ActiveFlag',
							width:100,
							mode:'local',
							hiddenName:'hxxx',//不能与id相同
							triggerAction:'all',//query
							forceSelection: true,
							selectOnFocus:false,
							//typeAhead:true,
							//minChars: 1,
							listWidth:100,
							valueField:'value',
							displayField:'name',
							store: new Ext.data.JsonStore({
						        fields : ['name', 'value'],
						        data   : [
						            {name : '已激活',   value: 'Y'},
						            {name : '未激活',  value: 'N'}
						        ]
						    })
					
						}
	        ]
		});
 	}
 	else if(AutCode=="CT_Loc"){
 		//科室/病区 筛选条件
		var tb = new Ext.Toolbar({
				id : 'tb',
				items : [  '医院', hospComp,'-',
				'科室类型',{
						xtype : 'combo',
						fieldLabel : '科室类型',
						id:'LOCType',
						store : new Ext.data.SimpleStore({
						fields : ['value', 'text'],
						data : [
								 ['W', 'Ward'],
								 ['E', 'Execute'],
								 ['DI', 'Drug Injection'],
								 ['D', 'Dispensing'],
								 ['C', 'Cashier'],
								 ['O', 'Other'],
								 ['OP', 'Operating Theatre'],
								 ['EM', 'Emergency'],
								 ['DS', 'Day Surgery'],
								 ['MR', 'Medical Records'],
								 ['OR', 'OutPatient Consulting Room'],
								 ['CL', 'Clinic'],
								 ['ADM', 'Admission Point']
								]
						}),
						mode : 'local',
						triggerAction : 'all',
						forceSelection : true,
						selectOnFocus : false,
						//typeAhead : true,
						//minChars : 1,
						listWidth : 200,
						valueField : 'value',
						displayField : 'text',
						hiddenName : 'CTLOCType'	
					},'-','部门组',{
						xtype:'combo',
						loadByIdParam : 'rowid',
						fieldLabel : '部门组',
						id:'DepDR',
						emptyText:'请先选择左侧医院',
						store : new Ext.data.Store({
							autoLoad: true,
							proxy : new Ext.data.HttpProxy({ url : DEPDR_QUERY_ACTION_URL }),
							reader : new Ext.data.JsonReader({
								totalProperty : 'total',
								root : 'data',
								successProperty : 'success'
							}, [ 'DEPRowId', 'DEPDesc' ])
						}),
						queryParam : 'desc',
						triggerAction : 'all',
						forceSelection : true,
						selectOnFocus : false,
						//typeAhead : true,
						//minChars : 1,
						listWidth : 250,
						valueField : 'DEPRowId',
						displayField : 'DEPDesc',
						hiddenName : 'CTLOCDepDR',
						pageSize : Ext.BDP.FunLib.PageSize.Combo,
                        	listeners:{	
                               'beforequery': function(e){
                                    this.store.baseParams = {
                                            desc:e.query,
                                            hospid:hospComp.getValue()
                                    };
                                    this.store.load({params : {
                                                start : 0,
                                                limit : Ext.BDP.FunLib.PageSize.Combo
                                    }})
                                
                                }
                        	}
					}
				]
			});
 	}
 	else if(AutCode=="CT_PayMode"){
 		//支付方式筛选条件
		var tb = new Ext.Toolbar({
				id : 'tb',
				items : ['支付类型',{ 
							name :'CTPMGrpCode',
							id:'TextGrpCode',
							xtype:'combo',
							store:new Ext.data.SimpleStore({   
								fields:['CTPMGrpCode','value'],
								data:[
								      ['CH','Cash'],
								      ['CC','Card'],
								      ['CQ','Cheque'],
								      ['DP','DirectPayment']
								    ]
							}),
							displayField:'value',
							valueField:'CTPMGrpCode',
							mode:'local',
							triggerAction:'all' ,
							forceSelection : true,
							selectOnFocus : false,
							blankText:'请选择'
						}
				]
			});
 	}
 	else if(AutCode=="OEC_OrderCategory"){
 		//医嘱大类筛选条件
		var tb = new Ext.Toolbar({
				id : 'tb',
				items : ['医院', hospComp,'-',
				'医嘱类组', {
							xtype : 'combo',
							pageSize : Ext.BDP.FunLib.PageSize.Combo,
							loadByIdParam : 'rowid',
							listWidth:250,
							id : 'OCGRPRowId',
							store : new Ext.data.Store({
								autoLoad : true,
								proxy : new Ext.data.HttpProxy({ url : OCGRP_QUERY_ACTION_URL }),
								reader : new Ext.data.JsonReader({
											totalProperty : 'total',
											root : 'data',
											successProperty : 'success'
										}, [ 'OCGRPRowId', 'OCGRPDesc' ])
							}),
							mode : 'remote',
							queryParam : 'desc',
							triggerAction : 'all',
							forceSelection : true,
							selectOnFocus : false,
							//typeAhead : true,
							//minChars : 1,
							valueField : 'OCGRPRowId',
							displayField : 'OCGRPDesc',
                        	listeners:{	
                               'beforequery': function(e){
                                    this.store.baseParams = {
                                            desc:e.query,
                                            hospid:hospComp.getValue()
                                    };
                                    this.store.load({params : {
                                                start : 0,
                                                limit : Ext.BDP.FunLib.PageSize.Combo
                                    }})
                                
                                }
                        	}
						}
				]
			});
 	}
 	else if(AutCode=="ARC_ItemCat"){
 		//医嘱子分类 筛选条件
		var tb = new Ext.Toolbar({
				id : 'tb',
				items : [ '医院', hospComp,'-',
				'医嘱类型', {
							xtype : 'combo',
							id : 'OrderType',
							mode : 'local',
							store : new Ext.data.SimpleStore({
								fields : ['value', 'text'],
								data : [
											['R', 'Drug'],
											['D', 'Diet'],
											['I', 'IV'],
											['C', 'Consultation'],
											['N', 'Normal'],
											['T', 'Dental'],
											['L', 'LabTrak'],
											['X', 'RehabMedicine'],
											['P', 'Price'],
											['B', 'BloodBank'],
											['S', 'Diet Supplement'],
											['H', 'Hardware'],
											['E', 'Diet Enteral Feed'],
											['A', 'Day Book'],
											['F', 'DFT'],
											['DTF', 'Diet Thickened Fluid'],
											['BM', 'Bulk Meal'],
											['PROS', 'Prosthetics']
										]
							}),
							triggerAction : 'all',
							forceSelection : true,
							selectOnFocus : false,
							//typeAhead : true,
							//minChars : 1,
							valueField : 'value',
							displayField : 'text'
						}, '-',
						'医嘱大类', {
							xtype : 'combo',
							id : 'ordcatText',
							loadByIdParam : 'rowid',
							store : new Ext.data.Store({
								autoLoad : true, // 不加会只显示id
								proxy : new Ext.data.HttpProxy({ url : ORDCAT_QUERY_ACTION_URL }),
								reader : new Ext.data.JsonReader({
											totalProperty : 'total',
											root : 'data',
											successProperty : 'success'
										}, [ 'ORCATRowId', 'ORCATDesc' ])
							}),
							mode : 'remote',
							emptyText:'请先选择左侧医院',
							pageSize : Ext.BDP.FunLib.PageSize.Combo,
							listWidth : 250,
							queryParam : 'desc',
							triggerAction : 'all',
							forceSelection : true,
							selectOnFocus : false,
							//typeAhead : true,
							//minChars : 1,
							valueField : 'ORCATRowId',
							displayField : 'ORCATDesc',
                        	listeners:{	
                               'beforequery': function(e){
                                    this.store.baseParams = {
                                            desc:e.query,
                                            hospid:hospComp.getValue()
                                    };
                                    this.store.load({params : {
                                                start : 0,
                                                limit : Ext.BDP.FunLib.PageSize.Combo
                                    }})
                                
                                }
                        	}
						}
				]
			});
 	}			 	
 	else if(AutCode=="PAC_OutcomeOfPregnancy"){
 		//妊娠结果筛选条件
		var tb = new Ext.Toolbar({
				id : 'tb',
				items : ['分娩结果类型', {
							xtype : 'combo',
							id : 'OutcomeType',
							disabled : Ext.BDP.FunLib.Component.DisableFlag('OutcomeType'),
							store : new Ext.data.SimpleStore({
								fields : ['value', 'text'],
								data : [
											['LC', 'Living Children'],
											['MB', 'Multiple Birth'],
											['PB', 'Preterm Birth'],
											['TP', 'Termination of Pregnancy'],
											['TAM', 'Therapeutic Abortion/Miscarriage']
										]
							}),
							mode : 'local',
							triggerAction : 'all',
							forceSelection : true,
							selectOnFocus : false,
							//minChars : 1,
							valueField : 'value',
							displayField : 'text'
						}
				]
			});
 	}
 	else if(AutCode=="PAC_EpisodeSubType"){
 		//就诊子类型筛选条件
		var tb = new Ext.Toolbar({
				id : 'tb',
				items : ['就诊类型', {
							id : 'AdmType',
							xtype : 'combo',
							width : 140,
							mode : 'local',
							store : new Ext.data.SimpleStore({
								fields : ['value', 'text'],
								data : [
											['O', '门诊'],
											['I', '住院'],
											['E', '急诊'],
											['H', '体检']
										]
							}),
							triggerAction : 'all',
							forceSelection : true,
							selectOnFocus : false,
							//minChars : 1,
							listWidth : 140,
							valueField : 'value',
							displayField : 'text'
						}
				]
			});
 	}
 	else if(AutCode=="PAC_AdmSource"){
 		//许可来源筛选条件
		var tb = new Ext.Toolbar({
				id : 'tb',
				items : ['就诊类型',{
							id : 'EpisodeType',
							xtype : 'combo',
							width : 140,
							mode : 'local',
							store : new Ext.data.SimpleStore({
								fields : ['value', 'text'],
								data : [
											['O', '门诊'],
											['I', '住院'],
											['E', '急诊'],
											['H', '体检']
										]
							}),
							triggerAction : 'all',
							forceSelection : true,
							selectOnFocus : false,
							//minChars : 1,
							listWidth : 140,
							valueField : 'value',
							displayField : 'text'
						}
				]
			});
 	}
 	else if(AutCode=="CT_Country"){
 		//国家筛选条件
		var tb = new Ext.Toolbar({
				id : 'tb',
				items : ['激活标志',
						 {
							fieldLabel : '<font color=red></font>激活标志',
							xtype : 'combo',
							id : 'active',
							width : 140,
							mode : 'local',
							triggerAction : 'all',
							listWidth : 140,
							shadow:false,
							valueField : 'value',
							displayField : 'name',
							store : new Ext.data.JsonStore({
										fields : ['name', 'value'],
										data : [{value : 'Y',name : 'Yes'}, 
												{value : 'N',name : 'No'}			
										]
							})	
						}
				]
			});
 	}
 	else if(AutCode=="CT_Province"){
 		//省筛选条件
		var tb = new Ext.Toolbar({
				id : 'tb',
				items : ['区域',{
							xtype : 'combo',
							pageSize : Ext.BDP.FunLib.PageSize.Combo,
							loadByIdParam : 'rowid',
							listWidth:250,
							fieldLabel : '区域',
							id :'regiondr',
							store : new Ext.data.Store({
										autoLoad: true,
										proxy : new Ext.data.HttpProxy({ url : CT_Region_DR_QUERY_ACTION_URL }),
										reader : new Ext.data.JsonReader({
										totalProperty : 'total',
										root : 'data',
										successProperty : 'success'
									}, [{ name:'CTRGRowId',mapping:'CTRGRowId'},
										{name:'CTRGDesc',mapping:'CTRGDesc'} ])
								}),
							mode : 'local',
							shadow:false,
							queryParam : 'desc',
							forceSelection : true,
							minChars : 1,
							triggerAction : 'all',
							displayField : 'CTRGDesc',
							valueField : 'CTRGRowId',
							selectOnFocus : false
							
						}
				]
			});
 	}
 	else if(AutCode=="CT_City"){
 		//城市筛选条件
		var tb = new Ext.Toolbar({
				id : 'tb',
				items : ['省份',{
							xtype : 'combo',
							pageSize : Ext.BDP.FunLib.PageSize.Combo,
							loadByIdParam : 'rowid',
							listWidth:250,
							//emptyText:'请选择',
							shadow:false,
							fieldLabel : '省',
							id :'provincedr',
							store : new Ext.data.Store({
										autoLoad: true,
										proxy : new Ext.data.HttpProxy({ url : CT_Province_DR_QUERY_ACTION_URL }),
										reader : new Ext.data.JsonReader({
										totalProperty : 'total',
										root : 'data',
										successProperty : 'success'
									}, [{ name:'PROVRowId',mapping:'PROVRowId'},
										{name:'PROVDesc',mapping:'PROVDesc'} ])
								}),
							mode : 'local',
							queryParam : 'desc',
							forceSelection : true,
							selectOnFocus : false,
							triggerAction : 'all',
							minChars : 1,
							displayField : 'PROVDesc',
							valueField : 'PROVRowId'
						}
				]
			});
 	}
 	else if(AutCode=="CT_CityArea"){
 		//城市区域筛选条件
		var tb = new Ext.Toolbar({
				id : 'tb',
				items : ['市',{
							xtype : 'combo',
							pageSize : Ext.BDP.FunLib.PageSize.Combo,
							loadByIdParam : 'rowid',
							listWidth:250,
							shadow:false,
							fieldLabel : '市',
							id :'citydr',
							store : new Ext.data.Store({
										autoLoad: true,
										proxy : new Ext.data.HttpProxy({ url : CITAREA_City_DR_QUERY_ACTION_URL }),
										reader : new Ext.data.JsonReader({
										totalProperty : 'total',
										root : 'data',
										successProperty : 'success'
									}, [{ name:'CTCITRowId',mapping:'CTCITRowId'},
										{name:'CTCITDesc',mapping:'CTCITDesc'} ])
								}),
							mode : 'local',
							queryParam : 'desc',
							forceSelection : true,
							selectOnFocus : false,
							triggerAction : 'all',
							minChars : 1,
							displayField : 'CTCITDesc',
							valueField : 'CTCITRowId'
						}
				]
			});
 	}
 	else if(AutCode=="MRC_AllType"){
 		//过敏源分类筛选条件
		var tb = new Ext.Toolbar({
				id : 'tb',
				items : ['过敏源标签',{
							 xtype:'combo',
				             id:'TagDescription',
				             store:new Ext.data.SimpleStore({
				             fields:['MRCATTagDescription','value'],
				             data:[
				                    ['G','Generic'],
				                    ['P','Pharmacy Item'],
				                    ['I','Ingredient']
				                  ]
				            }),
				            displayField:'value',
				            valueField:'MRCATTagDescription',
				            mode:'local',
				            blankText:'请选择' 
					  }
				]
			});
 	}
 	else if(AutCode=="ORC_Operation"){
 		//手术/过程筛选条件
		var tb = new Ext.Toolbar({
				id : 'tb',
				items : ['ICD10', {xtype : 'textfield',id : 'TextICD10'},'-',
						'ICD9', {xtype : 'textfield',id : 'TextICD9'}
				]
			});
 	}
 	else if(AutCode=="MRC_ICDDx"){
 		//诊断筛选条件
		var tb = new Ext.Toolbar({
				id : 'tb',
				items : ['ICD10', {xtype : 'textfield',id : 'TextICD10'}
				]
			});
 	}
 	else if(AutCode=="PHC_Instruc"){
 		//药品用法筛选条件
		var tb = new Ext.Toolbar({
				id : 'tb',
				items : ['国外名称', {
							xtype : 'textfield',
							id : 'ForeignDesc'
						}
				]
			});
 	}
 	else if(AutCode=="PHC_Freq"){
 		//频次筛选条件
		var tb = new Ext.Toolbar({
				id : 'tb',
				items : ['中文描述', {
							xtype : 'textfield',
							id : 'TextDesc2'
						},'-',
						'系数', {
							xtype : 'textfield',
							id : 'TextFactor'
						}
				]
			});	
 	}
 	else
 	{
 		//对于非公有数据，增加医院传参
		var DataType=tkMakeServerCall("web.DHCBL.BDP.BDPTableList","GetDataType",AutCode);
		if ((DataType!='G')&&(AutCode!="CT_Hospital"))
		{
			var tb = new Ext.Toolbar({
				id : 'tb',
				items : [ '医院', hospComp,'-' ]
			});
		}
 	}	
			
	var myTree = new Ext.BDP.Component.DataAutPanel({
        region:"center",
		dataUrl:Tree_ACTION_URL,
        ObjectType : ObjectType, 
		ObjectReference : ObjectReference, 
		AutCode : AutCode,
        pageSize:Ext.BDP.FunLib.PageSize.Aut, //分页大小,默认为0,为0时不分页
        disToolbar : true, //是否显示搜索工具条
        isCascade : true,   //级联
        AutClass : "web.DHCBL.BDP.Authorize", //获取授权数据类名称
        getAutMethod : "GetAutJson",					//获取授权数据方法
        saveAutMethod : 'SaveBDAuthorizeData', //保存授权数据方法
        listeners : {
			 'render' : function(){
			 	if (Ext.getCmp('tb'))
			 	{
			 		tb.render(this.tbar); //add one tbar
			 	}
			 }
		}
        ///////////////////////////////////////////////////////////////
    });
	
	//myTree.loadAuthorizeTree(ObjectType,ObjectReference);
    
    var viewport = new Ext.Viewport({
        	layout:'border',
        	items:[myTree]
    	}); 
});