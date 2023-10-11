/// 名称: 科室病区-关联医护人员	
/// 描述: 科室病区维护的子JS，关联医护人员部分
/// 编写者： 基础数据平台组 、蔡昊哲
/// 编写日期: 2013-07-03
	
	
	/**----------------------------------指定医护人员部分--------------------------------------**/	

	var ACTION_URL_Resource = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.RBResource&pClassQuery=GetList";
	var ACTION_URL_RelevanceDp = "../csp/dhc.bdp.ext.entitydatatrans.csp?pClassName=web.DHCBL.CT.RBResource&pClassMethod=RelevanceDp&pEntityName=web.Entity.CT.RBResource";	
	var SAVE_URL_Resource = "../csp/dhc.bdp.ext.entitydatatrans.csp?pClassName=web.DHCBL.CT.RBResource&pClassMethod=SaveEntity&pEntityName=web.Entity.CT.RBResource"
	var DELETE_Resource_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.RBResource&pClassMethod=DeleteData"
	var BindingLoc="../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.CTLoc&pClassQuery=GetDataForCmb1";
	var BindingCTCareProv="../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.CTCareProv&pClassQuery=GetDataForCmb2";
	var OPEN_Resource_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.RBResource&pClassMethod=OpenData";
	 
	var pagesize_Resource = Ext.BDP.FunLib.PageSize.Pop;
 	var dsResource = new Ext.data.Store({
        proxy: new Ext.data.HttpProxy({url:ACTION_URL_Resource}),//调用的动作  pClassName=web.DHCBL.CT.RBResource&pClassQuery=GetList
        reader: new Ext.data.JsonReader({
            	totalProperty: 'total',
            	root: 'data',
            	successProperty :'success'
        	},
	  	[{ name: 'RESRowId1', mapping:'RESRowId1',type: 'string'},
        { name: 'CTLOCDesc', mapping:'CTLOCDesc',type: 'string'},
	    { name: 'CTPCPDesc', mapping:'CTPCPDesc',type: 'string'},
        { name: 'RESCode',mapping:'RESCode', type: 'string' },         
        { name: 'RESDesc', mapping:'RESDesc',type: 'string'},
        { name: 'RESScheduleRequired',mapping:'RESScheduleRequired', type: 'string' },
        { name: 'RESMRRequest',mapping:'RESMRRequest', type: 'string' },         
	    { name: 'RESAdmittingRights', mapping:'RESAdmittingRights',type: 'string'},
        { name: 'RESDateActiveTo',mapping:'RESDateActiveTo',type: 'date',dateFormat: 'm/d/Y' },  
	    { name: 'RESDateActiveFrom', mapping:'RESDateActiveFrom',type: 'date', dateFormat: 'm/d/Y'}//列的映射
		]),
		remoteSort: true
    });	
    
	var pagingResource= new Ext.PagingToolbar({
            pageSize: pagesize_Resource,
            store: dsResource,
            displayInfo: true,
            displayMsg: '显示第 {0} 条到 {1} 条记录，一共 {2} 条',
            emptyMsg: "没有记录",
            plugins : [new Ext.BDP.FunLib.PagingToolbarResizer()],
				listeners : {
				          "change":function (t,p)
				         { 
				             pagesize_Resource = this.pageSize;
				         }
		        }
            
        })		
    
        
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
        
    var comboxResource = new Ext.BDP.Component.form.ComboBox({
		fieldLabel: '关联医护人员',							
		id: 'comboxResource',
		loadByIdParam : 'rowid',
		disabled : Ext.BDP.FunLib.Component.DisableFlag('comboxResource'),
		hiddenName:'RESCTPCPDR',//不能与id相同
		//triggerAction:'all',//query
		queryParam:"Desc",
		forceSelection: true,
		selectOcnFocus:false,
		//typeAhead:true,
		mode:'remote',
		pageSize:Ext.BDP.FunLib.PageSize.Combo,
		//minChars: 0,
		listWidth:250,
		valueField:'CTPCPRowId1',
		displayField:'CTPCPDesc',
		store:RBCareProvStore
	});
		
    var btnResource = new Ext.Button({
        id:'btnResource',
        disabled : Ext.BDP.FunLib.Component.DisableFlag('btnResource'),
        iconCls:'icon-accept',
        text:'关联医护人员',
        handler:function(){
        	 if(Ext.getCmp("comboxResource").getValue()=="")
        	 {
        	 	Ext.Msg.show({
					title:'提示',
					msg:'请选择医护人员!',
					minWidth:200,
					icon:Ext.Msg.ERROR,
					buttons:Ext.Msg.OK
				});
        	 }
        	 else{
        	 		//Ext.MessageBox.wait('正在关联中,请稍候...','提示');
					Ext.Ajax.request({
						url:ACTION_URL_RelevanceDp,
						method:'POST',
						params:{
							//'Code':Ext.getCmp("hidden_RESCode").getValue(),
							'RESCTPCPDR':Ext.getCmp("comboxResource").getValue(),
							//'RESDesc':Ext.getCmp("hidden_RESDesc").getValue(),
							'RESCTLOCDR':Ext.getCmp("hidden_CTLOCRowID").getValue()
						},
						callback:function(options, success, response){
							//Ext.MessageBox.hide();
							if(success){
								var jsonData = Ext.util.JSON.decode(response.responseText);
								if(jsonData.success == 'true'){
									Ext.Msg.show({
										title:'提示',
										msg:'医护人员关联成功!',
										icon:Ext.Msg.INFO,
										buttons:Ext.Msg.OK,
										fn:function(btn){
											gridResource.getStore().load({params:{start:0, limit:Ext.BDP.FunLib.PageSize.Pop,LOCDR:Ext.getCmp("hidden_CTLOCRowID").getValue()}});
										}
									});
									
								}
								else{
									var errorMsg ='';
									if(jsonData.errorinfo){
										errorMsg='<br/>错误信息:'+jsonData.errorinfo
									}
									Ext.Msg.show({
										title:'提示',
										msg:errorMsg,
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
        }
    });
    
     var ResourceAddwin = new Ext.Toolbar.Button({
		text : '添加',
		tooltip : '添加',
		iconCls : 'icon-add',
		id:'add_btn_Resource',
   		disabled : Ext.BDP.FunLib.Component.DisableFlag('add_btn_Resource'),
		handler : function() {
			winResource.setTitle('添加');
 			winResource.setIconClass('icon-add');
   			winResource.show();
   			WinFormResource.getForm().reset();
   			Ext.getCmp("RESCTLOCDR").setValue(Ext.getCmp("hidden_CTLOCRowID").getValue());;
   			
		}
	});
	
    var ResourceEditwin = new Ext.Toolbar.Button({
		text : '修改',
		tooltip : '修改',
		iconCls : 'icon-update',
		id:'update_btn_Resource',
   		disabled : Ext.BDP.FunLib.Component.DisableFlag('update_btn_Resource'),
		handler : function() {
		if(gridResource.selModel.hasSelection()){
			winResource.setTitle('修改');
 			winResource.setIconClass('icon-update');
   			winResource.show();
			var _record = gridResource.getSelectionModel().getSelected();//records[0]
	
			Ext.getCmp("form-Resource-save").getForm().load({
                url : OPEN_Resource_URL + '&RowId=' + _record.get('RESRowId1'),
                waitMsg : '正在载入数据...',
                success : function(form,action) {
                },
                failure : function(form,action) {
                    //Ext.example.msg('编辑', '载入失败');
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
		}
	});
	
	var ResourceDel = new Ext.Toolbar.Button({
		text : '删除',
		tooltip : '删除',
		iconCls : 'icon-delete',
		id:'del_btn_Resource',
  		disabled : Ext.BDP.FunLib.Component.DisableFlag('del_btn_Resource'),
		handler : function() {
			if(gridResource.selModel.hasSelection()){
			Ext.MessageBox.confirm('提示','确定要删除所选的数据吗?',function(btn){
			if(btn=='yes'){
				Ext.MessageBox.wait('数据删除中,请稍候...','提示');
				var gsm = gridResource.getSelectionModel();//获取选择列
                var rows = gsm.getSelections();//根据选择列获取到所有的行
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
										Ext.BDP.FunLib.DelForTruePage(gridResource,Ext.BDP.FunLib.PageSize.Pop);
										
										/*var startIndex = gridResource.getBottomToolbar().cursor;
										gridResource.getStore().load({params:{start:startIndex, limit:pagesize}});*/
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
		
    var tbResource=new Ext.Toolbar({
        id:'tbResource',
        items:[
            //'请选择要关联的医护人员：',
            //comboxResource,
            //'-',
            //btnResource,
            ResourceAddwin,
            '-',
            ResourceEditwin,
            '-',
            ResourceDel,
			{
				xtype: 'textfield',
				id: 'hidden_RESCTPCPDR',
				disabled : Ext.BDP.FunLib.Component.DisableFlag('hidden_RESCTPCPDR'),
				hidden : true
			},
			{
				xtype: 'textfield',
				id: 'hidden_CTLOCRowID',
				disabled : Ext.BDP.FunLib.Component.DisableFlag('hidden_CTLOCRowID'),
				hidden : true
			},
			{
				xtype: 'textfield',
				id: 'hidden_RESHOSPDR',
				disabled : Ext.BDP.FunLib.Component.DisableFlag('hidden_RESHOSPDR'),
				hidden : true
			},
            '->'
            //btnHelp
        ],
		listeners:{
        render:function(){
        // tbbutton.render(gridResource.tbar)  //tbar.render(panel.bbar)这个效果在底部
        }
    }
	});
	
	
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
   		//disabled : Ext.BDP.FunLib.Component.DisableFlag('RESCTLOCDR'),
		hideLabel:'True',
		hidden : true,
		name: 'RESCTLOCDR'
	});
	
	var RESCTPCPDR = new Ext.BDP.Component.form.ComboBox({            //----------RESCTPCPDR   医护人员  combo		
		fieldLabel: "<span style='color:red;'>*</span>医护人员",
		blankText: '不能为空',
		allowBlank : false,
		name: 'RESCTPCPDR',
		loadByIdParam : 'rowid',
		//id:'RESCTLOCDR',
		style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('RESCTPCPDR')),
		readOnly : Ext.BDP.FunLib.Component.DisableFlag('RESCTPCPDR'),
   		//disabled : Ext.BDP.FunLib.Component.DisableFlag('RESCTPCPDR'),
		hiddenName:'RESCTPCPDR',//不能与id相同
		//triggerAction:'all',//query
		queryParam:"Desc",
		forceSelection: true,
		selectOcnFocus:false,
		//typeAhead:true,
		mode:'remote',
		pageSize:Ext.BDP.FunLib.PageSize.Combo,
		//minChars: 0,
		listWidth:250,
		valueField:'CTPCPRowId1',
		displayField:'CTPCPDesc',
		store: RBCareProvStore,
		listeners:{
			   'beforequery': function(e){
					this.store.baseParams = {
						Desc:e.query,
						hospid:Ext.getCmp("hidden_RESHOSPDR").getValue()
					};
					this.store.load({params : {
								start : 0,
								limit : Ext.BDP.FunLib.PageSize.Combo
					}})
			
				}
		}
    }); 
				
	/*var RESCTLOCDR = new Ext.form.ComboBox({            //----------CTCPTDesc   科室类型  combo		
		fieldLabel: "<span style='color:red;'>*</span>科室",
		blankText: '不能为空',
		allowBlank : false,
		name: 'RESCTLOCDR',
		//id:'RESCTLOCDR',
   		disabled : Ext.BDP.FunLib.Component.DisableFlag('RESCTLOCDR'),
		hiddenName:'RESCTLOCDR',//不能与id相同
		forceSelection: true,
		queryParam:"desc",
		triggerAction : 'all',
		selectOnFocus:false,
		//typeAhead:true,
		mode:'remote',
		pageSize:10,
		//minChars: 0,
		listWidth:250,
		valueField:'CTLOCRowID',
		displayField:'CTLOCDesc',
		store:new Ext.data.JsonStore({
			url:BindingLoc,
			root: 'data',
			totalProperty: 'total',
			autoLoad: true,
			idProperty: 'CTLOCRowID',
			fields:['CTLOCRowID','CTLOCDesc'],
			remoteSort: true,
			sortInfo: {field: 'CTLOCRowID', direction: 'ASC'}
		})
		
    });    */

    var RESScheduleRequired = new Ext.BDP.FunLib.Component.Checkbox({           //----------RESScheduleRequired  需要排班
    	fieldLabel: '需要排班',
    	name: 'RESScheduleRequired',
    	id:'RESScheduleRequired',
    	style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('RESScheduleRequired')),
		readOnly : Ext.BDP.FunLib.Component.DisableFlag('RESScheduleRequired'),
   		//disabled : Ext.BDP.FunLib.Component.DisableFlag('RESScheduleRequired'),
    	dataIndex:'RESScheduleRequired',
    	checked:true,
    	inputValue : true?'Y':'N'
    });
    var RESMRRequest = new Ext.BDP.FunLib.Component.Checkbox({           //----------CTPCPActiveFlag  需要病历
    	fieldLabel: '需要病历',
    	name: 'RESMRRequest',
    	id:'RESMRRequest',
    	style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('RESMRRequest')),
		readOnly : Ext.BDP.FunLib.Component.DisableFlag('RESMRRequest'),
   		//disabled : Ext.BDP.FunLib.Component.DisableFlag('RESMRRequest'),
    	dataIndex:'RESMRRequest',
    	checked:true,
    	inputValue : true?'Y':'N'
    });
    var RESAdmittingRights = new Ext.BDP.FunLib.Component.Checkbox({           //----------RES_AdmittingRights  管理权 默认为Y
    	fieldLabel: '管理权',
    	name: 'RESAdmittingRights',
    	id:'RESAdmittingRights',
    	style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('RESAdmittingRights')),
		readOnly : Ext.BDP.FunLib.Component.DisableFlag('RESAdmittingRights'),
   		//disabled : Ext.BDP.FunLib.Component.DisableFlag('RESAdmittingRights'),
    	dataIndex:'RESAdmittingRights',
    	checked:true,
    	inputValue : true?'Y':'N'
    });
    var RESDateActiveFrom = new Ext.BDP.FunLib.Component.DateField({      //----------CTPCPDateActiveFrom  开始日期
        fieldLabel: '开始日期',
        id:'date3',
        style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('date3')),
		readOnly : Ext.BDP.FunLib.Component.DisableFlag('date3'),
   		//disabled : Ext.BDP.FunLib.Component.DisableFlag('date3'),
        name: 'RESDateActiveFrom',
		format: BDPDateFormat ,
		enableKeyEvents : true,
		listeners : {
       		'keyup' : function(field, e){
			Ext.BDP.FunLib.Component.GetCurrentDate(field, e );							
	        }
		}
    });
    var RESDateActiveTo = new Ext.BDP.FunLib.Component.DateField({      //----------RESDateActiveTo  结束日期
        fieldLabel: '结束日期',
        name: 'RESDateActiveTo',
        id:'date4',
        style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('date4')),
		readOnly : Ext.BDP.FunLib.Component.DisableFlag('date4'),
        //disabled : Ext.BDP.FunLib.Component.DisableFlag('date4'),
		format: BDPDateFormat,
		enableKeyEvents : true,
		listeners : {
       		'keyup' : function(field, e){
			Ext.BDP.FunLib.Component.GetCurrentDate(field, e );							
	        }
		}
    });
    var WinFormResource = new Ext.form.FormPanel({
				id : 'form-Resource-save',
				split : true,
				frame : true,
				reader: new Ext.data.JsonReader({root:'data'},	          
		            [{ name: 'RESRowId1', mapping:'RESRowId1',type: 'string'},
		            { name: 'RESCTPCPDR', mapping:'RESCTPCPDR',type: 'string'},
				    { name: 'RESCTLOCDR', mapping:'RESCTLOCDR',type: 'string'},
			        { name: 'RESScheduleRequired',mapping:'RESScheduleRequired', type: 'string' },
			        { name: 'RESMRRequest',mapping:'RESMRRequest', type: 'string' },         
				    { name: 'RESAdmittingRights', mapping:'RESAdmittingRights',type: 'string'},
				    { name: 'RESDateActiveFrom', mapping:'RESDateActiveFrom',type: 'string'},//列的映射
				     { name: 'RESDateActiveTo', mapping:'RESDateActiveTo',type: 'string'}//列的映射
					]),
				defaults : {
					width : 140,
					bosrder : false
				},
				labelAlign : 'right',
				defaultType : 'textfield',
				items : [RESRowId1,RESCTPCPDR,RESCTLOCDR,RESScheduleRequired,RESMRRequest,RESAdmittingRights,RESDateActiveFrom,RESDateActiveTo]
			});
	// 增加修改时弹出窗口
	var winResource = new Ext.Window({
		title : '',
		width : 350,
		height : 350,
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
		items : WinFormResource,
		buttons : [{
			text : '保存',
			id:'save_btn_Resource',
			iconCls : 'icon-save',
   			disabled : Ext.BDP.FunLib.Component.DisableFlag('save_btn_Resource'),
			handler : function() {
				if(WinFormResource.getForm().isValid()==false){
					 Ext.Msg.alert('提示','<font color = "red">数据验证失败，<br/>请检查您的数据格式是否有误！');
					 return;
				}
				var startDate = Ext.getCmp("date3").getValue();
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
								// alert(action);
								if (action.result.success == 'true') {
									winResource.hide();
									var myrowid = action.result.id;
									Ext.Msg.show({
										title : '提示',
										msg : '添加成功!',
										icon : Ext.Msg.INFO,
										buttons : Ext.Msg.OK,
										fn : function(btn) {
											// salert(action.result);
											var startIndex = gridResource.getBottomToolbar().cursor;
											gridResource.getStore().load({
														params : {
															start : startIndex,
															limit : Ext.BDP.FunLib.PageSize.Pop
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
								// alert(action);
								if (action.result.success == 'true') {
									winResource.hide();
									var myrowid = "rowid="+ action.result.id;
									Ext.Msg.show({
										title : '提示',
										msg : '修改成功!',
										icon : Ext.Msg.INFO,
										buttons : Ext.Msg.OK,
										fn : function(btn) {
											// salert(action.result);
											Ext.BDP.FunLib.ReturnDataForUpdate("btnEditwinResource",ACTION_URL_Resource,myrowid);
											/*var startIndex = gridResource.getBottomToolbar().cursor;
											gridResource.getStore().load({
														params : {
															start : startIndex,
															limit : Ext.BDP.FunLib.PageSize.pop
														}
													});*/
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
				// WinForm.getForm().reset();
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
			},
			"close" : function() {
			}
		}
	});
    // 关联科室增加按钮
	var btnAddwinResource = new Ext.Toolbar.Button({
				text : '添加',
				tooltip : '添加',
				iconCls : 'icon-add',
				id:'btnAddwinResource',
   				disabled : Ext.BDP.FunLib.Component.DisableFlag('btnAddwinResource'),
				handler : function() {
					winResource.setTitle('添加');
					winResource.setIconClass('icon-add');
					winResource.show('new1');
					WinFormResource.getForm().reset();
				},
				scope : this
			});
	// 关联科室修改按钮
			
	var smResource = new Ext.grid.CheckboxSelectionModel({singleSelect: true, checkOnly: false, width: 20});
    var gridResource = new Ext.grid.GridPanel({
	region: 'center',
	width:700,
	height:400,
	id:'btnEditwinResource',
   	disabled : Ext.BDP.FunLib.Component.DisableFlag('btnEditwinResource'),
	closable:true,
    store: dsResource,
    trackMouseOver: true,
    columns: [
            smResource,
            { header: 'RESRowId1', width: 80, sortable: true, dataIndex: 'RESRowId1', hidden : true},
            { header: '科室', width: 160, sortable: true, dataIndex: 'CTLOCDesc' },
			{ header: '医护人员', width: 110, sortable: true, dataIndex: 'CTPCPDesc' },   
            { header: '代码', width: 80, sortable: true, dataIndex: 'RESCode' },
			{ header: '描述', width: 110, sortable: true, dataIndex: 'RESDesc' },
            { header: '需要排班', width: 100, sortable: true, dataIndex: 'RESScheduleRequired',renderer:Ext.BDP.FunLib.Component.ReturnFlagIcon },
            { header: '需要病历', width: 100, sortable: true, dataIndex: 'RESMRRequest',renderer:Ext.BDP.FunLib.Component.ReturnFlagIcon },
            //{ header: '不考虑公共假日', width: 85, sortable: true, dataIndex: 'RESIgnorePubHol',renderer:Ext.BDP.FunLib.Component.ReturnFlagIcon },
            { header: '管理权', width: 85, sortable: true, dataIndex: 'RESAdmittingRights',renderer:Ext.BDP.FunLib.Component.ReturnFlagIcon},
            { header: '开始日期', width: 140, sortable: true, renderer: Ext.util.Format.dateRenderer(BDPDateFormat), dataIndex: 'RESDateActiveFrom' },
            { header: '结束日期', width: 140, sortable: true, renderer: Ext.util.Format.dateRenderer(BDPDateFormat), dataIndex: 'RESDateActiveTo' }
        ],
    stripeRows: true,
    loadMask: { msg: '数据加载中,请稍候...' },
    stateful: true,
    viewConfig: {
			forceFit: true
	},
	bbar:pagingResource ,
	tbar:tbResource,
    stateId: 'gridResource'
    
});

Ext.BDP.FunLib.ShowUserHabit(gridResource,"User.RBResourcesLoc");

gridResource.on("rowdblclick",function(grid,rowIndex,e){
	
			winResource.setTitle('修改');
		    winResource.setIconClass('icon-update');
		    winResource.show();
			var _record = gridResource.getSelectionModel().getSelected();//records[0]
			
			Ext.getCmp("form-Resource-save").getForm().load({
		                url : OPEN_Resource_URL + '&RowId=' + _record.get('RESRowId1'),
		                waitMsg : '正在载入数据...',
		                success : function(form,action) {
		                },
		                failure : function(form,action) {
		                    //Ext.example.msg('编辑', '载入失败');
		                	Ext.Msg.alert('编辑', '载入失败');
		                }
		            });
	});	

function getResourcePanel(){
	var winRelevanceCareProv = new Ext.Window({
			title:'',
			width:800,
            height:500,
			layout:'fit',
			plain:true,//true则主体背景透明
			modal:true,
			frame:true,
			//autoScroll: true,
			collapsible:true,
			hideCollapseTool:true,
			titleCollapse: true,
			bodyStyle:'padding:3px',
			buttonAlign:'center',
			closeAction:'hide',
            labelWidth:55,
			items: gridResource,
			listeners:{
				"show":function(){
				},
				"hide":function(){
				},
				"close":function(){
				}
			}
		});
	//gridResource.getStore().load({params:{start:0, limit:12,RESCode:ctcode}})	
  	return winRelevanceCareProv;
}
	
	
		
	/**--------------------↑关联医护人员部分---------------------------**/	