/// 名称: 资源定义
/// 编写者： 基础数据平台组  孙凤超
/// 编写日期: 2014-12-15
document.write('<script type="text/javascript" src="../scripts/bdp/Framework/scripts/BDPComboBox.js"></script>');
document.write('<script type="text/javascript" src="../scripts/bdp/Framework/scripts/AliasEditorGridPanel.js"> </script>');
Ext.onReady(function() {
	Ext.QuickTips.init();
	Ext.form.Field.prototype.msgTarget = 'qtip'; 
	var ACTION_URL_Resource =  "../csp/dhc.bdp.ext.jsondatatrans.csp?pClassName=web.DHCBL.CT.RBResourceForOwn&pClassMethod=GetList"; 
	//"../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.RBResourceForOwn&pClassQuery=GetList";
	var SAVE_URL_Resource = "../csp/dhc.bdp.ext.entitydatatrans.csp?pClassName=web.DHCBL.CT.RBResourceForOwn&pClassMethod=SaveEntity&pEntityName=web.Entity.CT.RBResourceForOwn"
	var DELETE_Resource_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.RBResourceForOwn&pClassMethod=DeleteData"
	var BindingLoc="../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.CTLoc&pClassQuery=GetDataForCmb1";	/// 科室下拉框数据源
	var BindingCTCareProv="../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.CTCareProv&pClassQuery=GetDataForCmb1";	/// 医护人员下拉框数据源
	var OPEN_Resource_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.RBResourceForOwn&pClassMethod=OpenData";
	 
	var pagesize_Resource = Ext.BDP.FunLib.PageSize.Pop;
	var pagesize_main = Ext.BDP.FunLib.PageSize.Main;

  	//初始化“别名”维护面板
	var AliasGrid = new Ext.BDP.grid.AliasEditorGridPanel({
		TableN : "RB_Resource"
	});
	Ext.BDP.FunLib.TableName="RB_Resource"
    /// 获取查询配置按钮 
    var LookUpConfigureBtn = Ext.BDP.FunLib.GetLookUpBtnFun(Ext.BDP.FunLib.TableName);  /// 表名  
 //////////////////////////////日志查看 ///////////////////////////////////////////////////////////
   var btnlog=Ext.BDP.FunLib.GetLogBtn("User.RBResource");
   var btnhislog=Ext.BDP.FunLib.GetHisLogBtn("User.RBResource");
   ///日志查看按钮是否显示
   var btnlogflag=Ext.BDP.FunLib.ShowBtnOrNotFun();
   if (btnlogflag==1)
   {
      btnlog.hidden=false;
    }
    else
    {
       btnlog.hidden=true;
    }
    /// 数据生命周期按钮 是否显示
   var btnhislogflag= Ext.BDP.FunLib.ShowLifeBtnOrNotFun();
   if (btnhislogflag==1)
   {
      btnhislog.hidden=false;
    }
    else
    {
       btnhislog.hidden=true;
    }  
   btnhislog.on('click', function(btn,e){    
   var RowID="",Desc="",locdesc="";
   if (grid.selModel.hasSelection()) {
       var rows = grid.getSelectionModel().getSelections(); 
       RowID=rows[0].get('RESRowId1');  
       Desc=rows[0].get('CTPCPDesc')+"->"+rows[0].get('CTLOCDesc')
       var result = tkMakeServerCall("web.DHCBL.BDP.BDPDataChangeLog","SaveLogParams",RowID,Desc);        
    }
    else
    {
       var result = tkMakeServerCall("web.DHCBL.BDP.BDPDataChangeLog","KillDatalogGlobal");
    }
  });	

   //多院区医院下拉框
	var hospComp=GenHospComp(Ext.BDP.FunLib.TableName);	
	//医院下拉框选择一条医院记录后执行此函数	
	hospComp.on('select',function (){
		 grid.enable();
		 Ext.getCmp("TextCode").reset();
         Ext.getCmp("TextDesc").reset();
         grid.getStore().baseParams={           
            Code : "",
            desc : "",
			hospid:hospComp.getValue()
		};
		grid.getStore().load({
					params : {
						start : 0,
						limit : pagesize_main
					}
				});
		
	});
	/************************************工具条删除按钮*******************************************/
	var ResourceDel = new Ext.Toolbar.Button({
			text : '删除',
			tooltip : '删除',
			iconCls : 'icon-delete',
			id:'del_btn',
  			disabled : Ext.BDP.FunLib.Component.DisableFlag('del_btn'),
			handler : DelData=function() {
				if(grid.selModel.hasSelection()){
				Ext.MessageBox.confirm('提示','确定要删除所选的数据吗?',function(btn){
				if(btn=='yes'){
					var gsm = grid.getSelectionModel(); 
             	   	var rows = gsm.getSelections(); 
             	   	AliasGrid.DataRefer = rows[0].get('RESRowId1');
					AliasGrid.delallAlias();
					Ext.Ajax.request({
						url:DELETE_Resource_URL,
						method:'POST',
						params:{
					        'id':rows[0].get('RESRowId1')
						},
						callback:function(options, success, response){
						Ext.MessageBox.hide();
						if(success){
							var jsonData = Ext.util.JSON.decode(response.responseText);
							if(jsonData.success == 'true'){
								Ext.Msg.show({
													title:'提示',
													msg:'数据删除成功!',
													icon:Ext.Msg.INFO,
													buttons:Ext.Msg.OK,
													fn:function(btn){
														 Ext.BDP.FunLib.DelForTruePage(grid,pagesize_main);
													}
											});
							}
							else{
								var errorMsg ='';
								if(jsonData.info){
									errorMsg='<br/>错误信息:'+jsonData.info
								}
								Ext.Msg.show({
												title:'提示',
												msg:'数据删除失败!'+errorMsg,
												minWidth:200,
												icon:Ext.Msg.ERROR,
												buttons:Ext.Msg.OK
											});
									}
							}
						else{
							Ext.Msg.show({
											title:'提示',
											msg:'异步通讯失败,请检查网络连接!',
											icon:Ext.Msg.ERROR,
											buttons:Ext.Msg.OK
										});
								}
							}
						},this);
				}
			},this);
		}
		else{
			Ext.Msg.show({
							title:'提示',
							msg:'请选择需要删除的行!',
							icon:Ext.Msg.WARNING,
							buttons:Ext.Msg.OK
						});
					}
       	 }
	});
	
/// Rowid
var RESRowId1=new Ext.BDP.FunLib.Component.TextField({ 
	    fieldLabel: 'RESRowId1',
		hideLabel:'True',
		hidden : true,
		name: 'RESRowId1'
	});
	
	var RESCTLOCDR=new Ext.BDP.FunLib.Component.TextField({ 
	    fieldLabel: 'RESCTLOCDR',
	    id:'RESCTLOCDR',
	    style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('RESCTLOCDR')),
		readOnly : Ext.BDP.FunLib.Component.DisableFlag('RESCTLOCDR'),
		hideLabel:'True',
		hidden : true,
		name: 'RESCTLOCDR'
	});
 
	//	科室类型  combo				
	 var RESCTLOCDR =new Ext.BDP.FunLib.Component.BaseComboBox({    
		fieldLabel: "<span style='color:red;'>*</span>科室",
		allowBlank : false,
		loadByIdParam : 'rowid',
		id:'RESCTLOCDRF',
   		disabled : Ext.BDP.FunLib.Component.DisableFlag('RESCTLOCDRF'),
		hiddenName:'RESCTLOCDR',//不能与id相同 
		queryParam : 'desc',
		mode:'remote',
		pageSize:Ext.BDP.FunLib.PageSize.Combo,
		listWidth:250,
		valueField:'CTLOCRowID',
		displayField:'CTLOCDesc',
        store : new Ext.data.Store({
            autoLoad: true,
            proxy : new Ext.data.HttpProxy({ url : BindingLoc }),
            reader : new Ext.data.JsonReader({
                        totalProperty : 'total',
                        root : 'data',
                        successProperty : 'success'
                    }, [ 'CTLOCRowID', 'CTLOCDesc' ])
        }),
        queryParam : 'desc',
        listWidth:250,
        pageSize:Ext.BDP.FunLib.PageSize.Combo,   
        valueField : 'CTLOCRowID',
        displayField : 'CTLOCDesc',
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

    });   
       //// 医护人员下拉框   数据源
    var RBCareProvStore  = new Ext.data.JsonStore({
            autoLoad: true,
			url:BindingCTCareProv,
			root: 'data',
			totalProperty: 'total',
			idProperty: 'CTPCPRowId1',
			fields:['CTPCPRowId1','CTPCPDesc'],
			remoteSort: true,
			sortInfo: {field: 'CTPCPRowId1', direction: 'ASC'}
		})    
  ///	 医护人员  coombox
    var comboxResource = new Ext.BDP.Component.form.ComboBox({
		fieldLabel: "<span style='color:red;'>*</span>医护人员",							
		id: 'comboxResource',
		loadByIdParam : 'rowid',
		allowBlank:false,
		disabled : Ext.BDP.FunLib.Component.DisableFlag('comboxResource'),
		hiddenName:'RESCTPCPDR', 
		//triggerAction:'all', 
		queryParam:"Desc",
		forceSelection: true,
		selectOcnFocus:false,
		mode:'remote',
		pageSize:Ext.BDP.FunLib.PageSize.Combo,
		listWidth:250,
		valueField:'CTPCPRowId1',
		displayField:'CTPCPDesc',
		store : new Ext.data.Store({
			//autoLoad : true,
			proxy : new Ext.data.HttpProxy({
				url : BindingCTCareProv
			}),
			reader : new Ext.data.JsonReader({
						totalProperty : 'total',
						root : 'data',
						successProperty : 'success'
					}, ['CTPCPRowId1', 'CTPCPDesc'])
		}),
		//store:RBCareProvStore,
		listeners : {
				'beforequery': function(e)
				{
						this.store.baseParams = {
								desc:e.query,
								hospid:hospComp.getValue()
						};
						this.store.load({params : {
									start : 0,
									limit : Ext.BDP.FunLib.PageSize.Combo
						}})
  				
				 } ,  
           		'select' :  function(thisText)
            	 {
		                   if(thisText==""){  
		                       return true;
		                   }
	                        var className =  "web.DHCBL.CT.RBResourceForOwn";   
	                        var classMethod = "Validate";                              
	                        var id="";
	                       
	                        if(winResource.title=='添加'){
	                       	var thisText=Ext.getCmp("form-Resource-save").getForm().findField("comboxResource").getValue();
                            var thisText2=Ext.getCmp("form-Resource-save").getForm().findField("RESCTLOCDRF").getValue();
	                       }
	                       if(winResource.title=='修改'){  
	                        var thisText=Ext.getCmp("form-Resource-save").getForm().findField("comboxResource").getValue();
                            var thisText2= Ext.getCmp("form-Resource-save").getForm().findField("RESCTLOCDRF").getValue();
	                        var _record = grid.getSelectionModel().getSelected();
	                        var id = _record.get('RESRowId1'); 
	                      }
	                        var flag = "";
	                        var flag = tkMakeServerCall(className,classMethod,id,thisText,thisText2);//用tkMakeServerCall函数实现与后台同步调用交互
	                        if(flag == "1"){   
	                        	 Ext.MessageBox.alert("提示","医护人员已分配到该科室下")
	                       }else{
	                      	  return true;
	                        }
	                    } 
	            
			}
	});
		
      //----------CTPCPDateActiveFrom 开始日期
 	 var RESDateActiveFrom = new Ext.BDP.FunLib.Component.DateField({    
        fieldLabel: "<span style='color:red;'>*</span>开始日期",
        id:'date3',
        allowBlank:false,
        style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('date3')),
		readOnly : Ext.BDP.FunLib.Component.DisableFlag('date3'),
        name: 'RESDateActiveFrom',
		format: BDPDateFormat ,
		enableKeyEvents : true,
		listeners : {
       		'keyup' : function(field, e){
				Ext.BDP.FunLib.Component.GetCurrentDate(field, e );							
	        }
		}
    });
      //----------RESDateActiveTo  资源截止日期
    var RESDateActiveTo = new Ext.BDP.FunLib.Component.DateField({    
        fieldLabel: '结束日期',
        name: 'RESDateActiveTo',
        id:'date4',
        style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('date4')),
		readOnly : Ext.BDP.FunLib.Component.DisableFlag('date4'),
		format: BDPDateFormat,
		enableKeyEvents : true,
		listeners : {
       		'keyup' : function(field, e){
				Ext.BDP.FunLib.Component.GetCurrentDate(field, e );							
	        }
		}
    });
    //----------RESScheduleRequired  需要排班
    var RESScheduleRequired = new Ext.BDP.FunLib.Component.Checkbox({         
    	fieldLabel: '需要排班',
    	name: 'RESScheduleRequired',
    	id:'RESScheduleRequired',
    	style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('RESScheduleRequired')),
		readOnly : Ext.BDP.FunLib.Component.DisableFlag('RESScheduleRequired'),
    	dataIndex:'RESScheduleRequired',
    	inputValue : true?'Y':'N'
    });
    //----------CTPCPActiveFlag  需要病历
    var RESMRRequest = new Ext.BDP.FunLib.Component.Checkbox({           
    	fieldLabel: '需要病历',
    	name: 'RESMRRequest',
    	id:'RESMRRequest',
    	style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('RESMRRequest')),
		readOnly : Ext.BDP.FunLib.Component.DisableFlag('RESMRRequest'),
    	dataIndex:'RESMRRequest',
    	inputValue : true?'Y':'N'
    });
    //----------RES_AdmittingRights  管理权 默认为Y
    var RESAdmittingRights = new Ext.BDP.FunLib.Component.Checkbox({          
    	fieldLabel: '管理权',
    	name: 'RESAdmittingRights',
    	id:'RESAdmittingRights',
    	style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('RESAdmittingRights')),
		readOnly : Ext.BDP.FunLib.Component.DisableFlag('RESAdmittingRights'),
    	dataIndex:'RESAdmittingRights',
    	inputValue : true?'Y':'N'
    });
    /// 是否考虑公共假期
   var RESIgnorePubHol = new Ext.BDP.FunLib.Component.Checkbox({          
    	fieldLabel: '不考虑公共假期',
    	name: 'RESIgnorePubHol',
    	id:'RESIgnorePubHol',
    	style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('RESIgnorePubHol')),
		readOnly : Ext.BDP.FunLib.Component.DisableFlag('RESIgnorePubHol'),
    	dataIndex:'RESIgnorePubHol',
    	inputValue : true?'Y':'N'
    });
    var WinFormResource = new Ext.form.FormPanel({
		id : 'form-Resource-save',
		split : true,
		frame : true,
		title:'基本信息',
        labelAlign : 'right',
		reader: new Ext.data.JsonReader({root:'data'},	          
            [{ name: 'RESRowId1', mapping:'RESRowId1',type: 'int'},
            { name: 'RESCTPCPDR', mapping:'RESCTPCPDR',type: 'string'},
		    { name: 'RESCTLOCDR', mapping:'RESCTLOCDR',type: 'string'},
		    { name: 'RESDateActiveFrom', mapping:'RESDateActiveFrom',type:'string'}, 
		    { name: 'RESDateActiveTo', mapping:'RESDateActiveTo',type: 'string'} ,
	        { name: 'RESScheduleRequired',mapping:'RESScheduleRequired', type: 'string' },
	        { name: 'RESMRRequest',mapping:'RESMRRequest', type: 'string' },         
		    { name: 'RESAdmittingRights', mapping:'RESAdmittingRights',type: 'string'},
		    { name:'RESIgnorePubHol',mapping:'RESIgnorePubHol',type:'string'}
			]),
		defaults : {
			width : 140,
			bosrder : false
		},
		defaultType : 'textfield',
		items : [RESRowId1,RESCTLOCDR,comboxResource,RESDateActiveFrom,RESDateActiveTo,RESScheduleRequired,RESMRRequest,RESAdmittingRights,RESIgnorePubHol]
	});
	var tabs = new Ext.TabPanel({
		 activeTab : 0,
		 frame : true,
		 border : false,
		 height : 300,
		 items : [WinFormResource, AliasGrid]
	 });
	Ext.BDP.AddTabpanelFun(tabs,Ext.BDP.FunLib.TableName);
	// 增加修改时弹出窗口
	var winResource = new Ext.Window({
		width : 340,
		height : 420,
		layout : 'fit',
		plain : true,// true则主体背景透明
		modal : true,
		frame : true,
		autoScroll : true,
		collapsible : true,
		hideCollapseTool : true,
		titleCollapse : true,
		bodyStyle : 'padding:3px',
		buttonAlign : 'center',
		closeAction : 'hide',
		labelWidth : 55,
		items : tabs,
		buttons : [{
			text : '保存',
            iconCls : 'icon-save',
			id:'save_btn_Resource',
   			disabled : Ext.BDP.FunLib.Component.DisableFlag('save_btn_Resource'),
			handler : function() {
				var startDate = Ext.getCmp("date3").getValue();
				if (startDate==""){
					Ext.Msg.show({
									title:'提示',
									msg:'开始日期不能为空!',
									minWidth:200,
									icon:Ext.Msg.ERROR,
									buttons:Ext.Msg.OK
								});
					return ;
				}
				if (Ext.getCmp('RESCTLOCDRF').getValue==""){
					Ext.Msg.show({
									title:'提示',
									msg:'科室不能为空!',
									minWidth:200,
									icon:Ext.Msg.ERROR,
									buttons:Ext.Msg.OK
								});
					return ;
				}
				if (Ext.getCmp('comboxResource').getValue==""){
					Ext.Msg.show({
									title:'提示',
									msg:'医护人员不能为空!',
									minWidth:200,
									icon:Ext.Msg.ERROR,
									buttons:Ext.Msg.OK
								});
					return ;
					
				}
			   	var endDate = Ext.getCmp("date4").getValue();
				if (startDate != "" && endDate != "") {
        			if (startDate > endDate) {
        				Ext.Msg.show({
			        					title : '提示',
										msg : '开始日期不能大于结束日期！',
										minWidth : 200,
										icon : Ext.Msg.ERROR,
										buttons : Ext.Msg.OK
									});
			          		return;
			      	}
			   	}
			   	if(winResource.title=="添加")
					{
						WinFormResource.form.submit({
							clientValidation : true, // 进行客户端验证
							waitMsg : '正在提交数据请稍后',
							waitTitle : '提示',
							url : SAVE_URL_Resource,
							method : 'POST',
							success : function(form, action) {
								if (action.result.success == 'true') {
									winResource.hide();
									var myrowid = action.result.id;
									AliasGrid.DataRefer = myrowid;
									AliasGrid.saveAlias();
									Ext.Msg.show({
													title : '提示',
													msg : '添加成功!',
													icon : Ext.Msg.INFO,
													buttons : Ext.Msg.OK,
													fn : function(btn) {
														var startIndex = grid.getBottomToolbar().cursor;
														grid.getStore().load({
																	params : {
																				start : 0,
																				limit : pagesize_main,
																				rowid : myrowid
																			}
																});
															}
												});
								} else {
									var errorMsg = '';
									if (action.result.errorinfo) {
										errorMsg = '<br/>错误信息:'+ action.result.errorinfo
									}
									Ext.Msg.show({
													title : '提示',
													msg : '添加失败!' + errorMsg,
													minWidth : 200,
													icon : Ext.Msg.ERROR,
													buttons : Ext.Msg.OK
												});
									}
							},
							failure : function(form, action) {
								Ext.Msg.alert('提示', '添加失败');
							}
						});
				} else {
					Ext.MessageBox.confirm('提示', '确定要修改该条数据吗?', function(btn) {
					if (btn == 'yes') {
						WinFormResource.form.submit({
							clientValidation : true, // 进行客户端验证
							waitMsg : '正在提交数据请稍后',
							waitTitle : '提示',
							url : SAVE_URL_Resource,
							method : 'POST',
							success : function(form, action) {
								AliasGrid.saveAlias();
								if (action.result.success == 'true') {
									winResource.hide();
									var myrowid = "rowid="+ action.result.id;
									Ext.Msg.show({
												title : '提示',
												msg : '修改成功!',
												icon : Ext.Msg.INFO,
												buttons : Ext.Msg.OK,
												fn : function(btn) {
													Ext.BDP.FunLib.ReturnDataForUpdate("btnEditwinResource",ACTION_URL_Resource,myrowid);
												}
											});
								} else {
									var errorMsg = '';
									if (action.result.errorinfo) {
										errorMsg = '<br/>错误信息:'+ action.result.errorinfo
									}
									Ext.Msg.show({
													title : '提示',
													msg : '修改失败!' + errorMsg,
													minWidth : 200,
													icon : Ext.Msg.ERROR,
													buttons : Ext.Msg.OK
												});
									}
							},
							failure : function(form, action) {
								Ext.Msg.alert('提示', '修改失败');
							}
						})
					}
				}, this);
			}
		  }
		}, {
			text : '关闭',
            iconCls : 'icon-close',
			handler : function() {
				winResource.hide();
			}
		}],
		listeners : {
			"show" : function() {
			},
			"hide" : function() {
				Ext.BDP.FunLib.Component.FromHideClearFlag();
			},
			"close" : function() {
			}
		}
	});
 
	 var ResourceAddwin = new Ext.Toolbar.Button({
		text : '添加',
		tooltip : '添加',
		iconCls : 'icon-add',
		id:'add_btn_Resource',
   		disabled : Ext.BDP.FunLib.Component.DisableFlag('add_btn_Resource'),
		handler : AddData=function() {
					winResource.setTitle('添加');
					winResource.setIconClass('icon-add');
					winResource.show('new1');
					WinFormResource.getForm().reset();
					//激活基本信息面板
		            tabs.setActiveTab(0);
			        //清空别名面板grid
		            AliasGrid.DataRefer = "";
		            AliasGrid.clearGrid();
				} 
	});
	
    var ResourceEditwin = new Ext.Toolbar.Button({
		text : '修改',
		tooltip : '修改',
		iconCls : 'icon-update',
		id:'update_btn_Resource',
   		disabled : Ext.BDP.FunLib.Component.DisableFlag('update_btn_Resource'),
		handler : UpdateData=function() {
		if(grid.selModel.hasSelection()){
			winResource.setTitle('修改');
 			winResource.setIconClass('icon-update');
   			winResource.show();
			var _record = grid.getSelectionModel().getSelected();//records[0]
	
			Ext.getCmp("form-Resource-save").getForm().load({
                url : OPEN_Resource_URL + '&RowId=' + _record.get('RESRowId1'),
                success : function(form,action) {
                },
                failure : function(form,action) {
                	Ext.Msg.alert('编辑', '载入失败');
                }
            });
		}
		else{
			Ext.Msg.show({
							title:'提示',
							msg:'请选择需要修改的行!',
							icon:Ext.Msg.WARNING,
							buttons:Ext.Msg.OK
						});
				}
			 //激活基本信息面板
			  tabs.setActiveTab(0);
			  //加载别名面板
			  AliasGrid.DataRefer = _record.get('RESRowId1');
		      AliasGrid.loadGrid();
		}
	});	
	var fields=	[
			{ 
				name: 'RESRowId1',
				mapping:'RESRowId1',
				type: 'int'
			},{
				name: 'CTLOCDesc',
				mapping:'CTLOCDesc',
				type: 'string'
			},{ 
				name: 'CTPCPDesc',
				mapping:'CTPCPDesc',
				type: 'string'
			},{
				name: 'RESScheduleRequired',
				mapping:'RESScheduleRequired', 
				type: 'string' 
			},{ 
				name: 'RESMRRequest',
				mapping:'RESMRRequest',
				type: 'string' 
			},{ 
				name: 'RESAdmittingRights', 
				mapping:'RESAdmittingRights',
				type: 'string'
			},{ 
				name: 'RESDateActiveFrom',
				mapping:'RESDateActiveFrom',
				type: 'date',
                dateFormat : 'm/d/Y'
			},{
				name: 'RESDateActiveTo',
				mapping:'RESDateActiveTo',
				type: 'date',
                dateFormat : 'm/d/Y'
			},{
				name:'RESIgnorePubHol',
				mapping:'RESIgnorePubHol',
				type:'string'
			},{     
				name:'BDPInternalCode',
				mapping:'BDPInternalCode',
				type:'string'
			},{  
				 name:'BDPInternalDesc',
				 mapping:'BDPInternalDesc',
				 type:'string'
			},{
				 name:'BDPHospNationalCode',
			         mapping:'BDPHospNationalCode',
				 type:'string'
			},{
			         name:'BDPPHospNationalDesc',
				 mapping:'BDPPHospNationalDesc',
				 type:'string'
		  	}]
		
 	var dsResource = new Ext.data.Store({
        proxy: new Ext.data.HttpProxy({url:ACTION_URL_Resource}), 
        reader: new Ext.data.JsonReader({
            	totalProperty: 'total',
            	root: 'data',
            	successProperty :'success'
        	},fields)
    });
    Ext.BDP.AddReaderFieldFun(dsResource,fields,Ext.BDP.FunLib.TableName);
   
	var pagingResource= new Ext.PagingToolbar({
            pageSize: pagesize_main,
            store: dsResource,
            displayInfo: true,
            displayMsg: '显示第 {0} 条到 {1} 条记录，一共 {2} 条',
            emptyMsg: "没有记录",
            plugins : [new Ext.BDP.FunLib.PagingToolbarResizer()],
				listeners : {
				          "change":function (t,p)
				         	{ 
				             	pagesize_main = this.pageSize;
				        	 }
		       	 }
        })		
	 //搜索工具条
	var btnSearch=new Ext.Button({
          id:'btnSearch',
          iconCls:'icon-search',
          text:'搜索',
          disabled : Ext.BDP.FunLib.Component.DisableFlag('btnSearch'),
          handler:function(){
			grid.getStore().baseParams={			
				Code : Ext.getCmp("TextCode").getValue(),
				desc : Ext.getCmp("TextDesc").getValue(),
				hospid:hospComp.getValue()
			};
			grid.getStore().load({
				params : {
							start : 0,
							limit : pagesize_main
						}
					});	
                }
            });
	//刷新工作条
	var btnRefresh=new Ext.Button({
            id:'btnRefresh',
            iconCls:'icon-refresh',
            text:'重置',
            disabled : Ext.BDP.FunLib.Component.DisableFlag('btnRefresh'),
            handler:function(){
				Ext.getCmp("TextCode").reset();
				Ext.getCmp("TextDesc").reset();
				grid.getStore().baseParams={hospid:hospComp.getValue()};
					grid.getStore().load({params:{start:0, limit:pagesize_main}});
       		  }
     });
      var TextCTLOCDR =new Ext.BDP.Component.form.ComboBox({    
		fieldLabel: "<span style='color:red;'>*</span>科室",
		name: 'RESCTLOCDR',
		id:'TextDesc',
   		disabled : Ext.BDP.FunLib.Component.DisableFlag('TextDesc'),
		hiddenName:'RESCTLOCDR',//不能与id相同
		forceSelection: true,
		queryParam:"desc",
		//triggerAction : 'all',
		selectOnFocus:false,
		mode:'remote',
		pageSize:Ext.BDP.FunLib.PageSize.Combo,
		listWidth:250,
		valueField:'CTLOCRowID',
		displayField:'CTLOCDesc',
		store:new Ext.data.JsonStore({
			url:BindingLoc,
			root: 'data',
			totalProperty: 'total',
			//autoLoad: true,
			idProperty: 'CTLOCRowID',
			fields:['CTLOCRowID','CTLOCDesc'],
			remoteSort: true,
			sortInfo: {field: 'CTLOCRowID', direction: 'ASC'}
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
    }); 
    ///	 医护人员  coombox
    var TextResource = new Ext.BDP.Component.form.ComboBox({
		fieldLabel: '医护人员',							
		id: 'TextCode',
		loadByIdParam : 'rowid',
		disabled : Ext.BDP.FunLib.Component.DisableFlag('TextCode'),
		hiddenName:'RESCTPCPDR', 
		//triggerAction:'all', 
		queryParam:"Desc",
		forceSelection: true,
		selectOcnFocus:false,
		mode:'remote',
		pageSize:Ext.BDP.FunLib.PageSize.Combo,
		listWidth:250,
		valueField:'CTPCPRowId1',
		displayField:'CTPCPDesc',
		store:RBCareProvStore,
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
	});
      
	var tb=new Ext.Toolbar({
                    id:'tb',
                    items:['科室',	TextCTLOCDR , '医护人员', TextResource,'-',LookUpConfigureBtn, '-',  btnSearch,'-',btnRefresh,  '->'    ],
					listeners:{
                   	 render:function(){
                   		 tbbutton.render(grid.tbar)  
                    }
                }
			});	
						
    var tbbutton=new Ext.Toolbar({
        id:'tbbutton',
        enableOverflow: true,
        items:[
            ResourceAddwin,'-', ResourceEditwin,'-',ResourceDel,'->',btnlog,'-',btnhislog] 
	}); 
 	var smResource = new Ext.grid.CheckboxSelectionModel({singleSelect: true, checkOnly: false, width: 20});
    var grid = new Ext.grid.GridPanel({
		region: 'center',
		width:700,
		height:400,
		title:'资源定义',
		id:'btnEditwinResource',
	    store: dsResource,
	    trackMouseOver: true,
	    columns: [
	            smResource,
	            { header: 'RESRowId1', width: 120, sortable: true, dataIndex: 'RESRowId1', hidden : true},
	            { header: '科室', width: 120, sortable: true, dataIndex: 'CTLOCDesc' }, 
				{ header: '医护人员', width: 120, sortable: true, dataIndex: 'CTPCPDesc' }, 
				{ header: '开始日期', width: 80, sortable: true, renderer: Ext.util.Format.dateRenderer(BDPDateFormat), dataIndex: 'RESDateActiveFrom' },
	            { header: '结束日期', width: 80, sortable: true, renderer: Ext.util.Format.dateRenderer(BDPDateFormat), dataIndex: 'RESDateActiveTo' },
	            { header: '需要排班', width: 85, sortable: true, dataIndex: 'RESScheduleRequired',renderer:Ext.BDP.FunLib.Component.ReturnFlagIcon },
	            { header: '需要病历', width: 85, sortable: true, dataIndex: 'RESMRRequest',renderer:Ext.BDP.FunLib.Component.ReturnFlagIcon },
	            { header: '管理权', width: 85, sortable: true, dataIndex: 'RESAdmittingRights',renderer:Ext.BDP.FunLib.Component.ReturnFlagIcon},
	            { header:'不考虑公共假期',width:85,sortable:true,dataIndex:'RESIgnorePubHol',renderer:Ext.BDP.FunLib.Component.ReturnFlagIcon}
	          
	        ],
	    stripeRows: true,
	    stateful: true,
	    viewConfig: {
			forceFit: true
		},
		bbar:pagingResource ,
		tbar:tb,
		tools:Ext.BDP.FunLib.Component.HelpMsg,
	    stateId: 'grid'
});
Ext.BDP.AddColumnFun(grid,Ext.BDP.FunLib.TableName);
  grid.on("rowclick",function(grid,rowIndex,e){
	if (grid.selModel.hasSelection())
	{
	  	var _record=grid.getSelectionModel().getSelected();
        var selectrow=_record.get('RESRowId1');
	}
	else
	{
	  var selectrow=""
	}
	Ext.BDP.FunLib.SelectRowId=selectrow
  });
grid.on("rowdblclick",function(grid,rowIndex,e){
		winResource.setTitle('修改');
		winResource.setIconClass('icon-update');
		winResource.show();
		var _record = grid.getSelectionModel().getSelected(); 
		Ext.getCmp("form-Resource-save").getForm().load({
	          url : OPEN_Resource_URL + '&RowId=' + _record.get('RESRowId1') 
		   });
		 tabs.setActiveTab(0);		 
		 AliasGrid.DataRefer = _record.get('RESRowId1');
	     AliasGrid.loadGrid();
	});	
	Ext.BDP.FunLib.ShowUserHabit(grid,"User.RBResource");
	/************************************键盘事件，按A键弹出添加窗口*************************/
 	Ext.BDP.FunLib.Component.KeyMap(AddData,UpdateData,DelData);
 	var viewport = new Ext.Viewport({
		layout : 'border',
		items : [GenHospPanel(hospComp),grid]
	});

	///多院区医院
    var flag= tkMakeServerCall("web.DHCBL.BDP.BDPConfig","GetConfigValue","BDPHospAut")
	if (flag=="Y"){
		grid.disable();
	}
	else
	{
		/** grid加载数据 */
		dsResource.load({
					params : {
						start : 0,
						limit : pagesize_main
					},
					callback : function(records, options, success) {
					}
				});
	
	}
 });
