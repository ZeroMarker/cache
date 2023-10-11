/**
 * @Title:   基础数据平台-基础数据
 * @Author:   孙凤超 DHC-BDP
 * @Description:  国家标准数据元值域
 */	
document.write('<script type="text/javascript" src="../scripts/bdp/Framework/scripts/BDPComboBox.js"></script>');
document.write('<script type="text/javascript" src="../scripts/bdp/Framework/scripts/AliasEditorGridPanel.js"> </script>');  
Ext.onReady(function() {
	Ext.QuickTips.init();
	Ext.form.Field.prototype.msgTarget = 'side';
	var limit = Ext.BDP.FunLib.PageSize.Main;
    var comboPage=Ext.BDP.FunLib.PageSize.Combo;
	Ext.BLANK_IMAGE_URL = '../scripts_lib/ext3.2.1/resources/images/default/s.gif';
 	var QUERY_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.BDPNationalDataDomain&pClassMethod=GetList";
	var OPEN_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.BDPNationalDataDomain&pClassMethod=OpenData";
	var SAVE_ACTION_URL = "../csp/dhc.bdp.ext.entitydatatrans.csp?pClassName=web.DHCBL.CT.BDPNationalDataDomain&pClassMethod=SaveEntity&pEntityName=web.Entity.CT.BDPNationalDataDomain";
	var DELETE_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.BDPNationalDataDomain&pClassMethod=DeleteData";
	var ALG_Type_DR_QUERY_ACTION_URL = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.BDPNationalDataType&pClassQuery=GetDataForCmb1";
	Ext.BDP.FunLib.TableName="BDP_NationalDataDomain"
	/*****************************删除功能***************************************************/
	var btnDel = new Ext.Toolbar.Button({
		  text : '删除',
	  	  tooltip : '删除',
		  iconCls : 'icon-delete',
		  id : 'del_btn',
		  disabled : Ext.BDP.FunLib.Component.DisableFlag('del_btn'),
	  	  handler : DelData=function() {   
			if (grid.selModel.hasSelection()) {
                var gsm = grid.getSelectionModel();
                var rows = gsm.getSelections();
				Ext.MessageBox.confirm('提示', '确定要删除所选的数据吗?', function(btn) {
					if (btn == 'yes') {
						Ext.Ajax.request({
							url : DELETE_ACTION_URL,
							method : 'POST',
							params : {
								'id' : rows[0].get('BDPDomainRowId')
							},
							callback : function(options, success, response) {
								if (success) {
									var jsonData = Ext.util.JSON.decode(response.responseText);
									if (jsonData.success == 'true') {
										Ext.Msg.show({
											    title : '提示',
										    	msg : '数据删除成功!',
											    icon : Ext.Msg.INFO,
											    buttons : Ext.Msg.OK,
											    fn : function(btn) {
												   Ext.BDP.FunLib.DelForTruePage(grid,limit);
												 }
										   });
									} else {
										var errorMsg = '';
										if (jsonData.info) {
											errorMsg = '<br/>错误信息:' + jsonData.info
										}
										Ext.Msg.show({
													   title : '提示',
													   msg : '数据删除失败!' + errorMsg,
													   minWidth : 200,
													   icon : Ext.Msg.ERROR,
													   buttons : Ext.Msg.OK
												    });
									    }
								} else {
									Ext.Msg.show({
												   title : '提示',
												   msg : '异步通讯失败,请检查网络连接!',
												   icon : Ext.Msg.ERROR,
												   buttons : Ext.Msg.OK
											   });
								         }
						    	  }
						   }, this);
					   }
				  }, this);
			} else {
				Ext.Msg.show({
							    title : '提示',
						     	msg : '请选择需要删除的行!',
							    icon : Ext.Msg.WARNING,
							    buttons : Ext.Msg.OK
						   });
			     }
		     }
	 });


/************************导入数据*************************************/ 
	 var btnImport = new Ext.Toolbar.Button({
			text : '导入数据',
			tooltip : '导入数据',
			iconCls : 'icon-import',
			id : 'btnImport',
			disabled : Ext.BDP.FunLib.Component.DisableFlag('btnImport'),
	      	     	handler: importData=function () { 
						var windowImport = new Ext.Window({
										iconCls : 'icon-DP',
										width : 1000,
										height : 560,
										layout : 'fit',
										plain : true,// true则主体背景透明
										modal : true,
										frame : true,
										autoScroll : false,
										collapsible : true,
										hideCollapseTool : true,
										titleCollapse : true,
										constrain : true,
										closeAction : 'close',
										html : '',
										listeners : {
											"show" : function(){
												
											},
											"hide" : function(){
												
											},
											"close" : function(){
											}
										}
									}); 
						var url="dhc.bdp.ext.default.csp?extfilename=App/BDPSystem/BDP_DataDomainImport.js";  			
						if ('undefined'!==typeof websys_getMWToken)
						{
							url += "&MWToken="+websys_getMWToken() //增加token
						}  	 			
						windowImport.html='<iframe id="iframeImport" src=" '+url+' " width="100%" height="100%"></iframe>';
						windowImport.setTitle("导入数据");
						windowImport.show();
				} 
    }); 
	/***************************** 增加修改的Form*****************************************/
	  var ComboStore=new Ext.data.Store({
        	autoLoad: true,
         	proxy : new Ext.data.HttpProxy({ url : ALG_Type_DR_QUERY_ACTION_URL }),
         	reader : new Ext.data.JsonReader({
          	totalProperty : 'total',
          	root : 'data',
          	successProperty : 'success'
         }, [ 'BDPStandardRowId', 'BDPStandardDomainDesc' ])
    });
      var DataDomainDescDr=new Ext.BDP.Component.form.ComboBox({
        xtype:'bdpcombo',
        loadByIdParam:'rowid',
        fieldLabel : '<font color=red>*</font>值域名称',
        name : 'BDPDomainDescDR',
        id:'BDPDomainDescDRF',
        readOnly : Ext.BDP.FunLib.Component.DisableFlag('BDPDomainDescDRF'),
        style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('BDPDomainDescDRF')),
        allowBlank:false,
        store :ComboStore ,
	    queryParam : 'desc',
	    triggerAction : 'all',
	    forceSelection : true,
	    selectOnFocus : false,
	    minChars : 0,
	    listWidth : 250,
	    valueField : 'BDPStandardRowId',
	    displayField : 'BDPStandardDomainDesc',
	    hiddenName : 'BDPDomainDescDR',
	    pageSize :Ext.BDP.FunLib.PageSize.Combo,
	    listeners:{
		    'select': function(field,e){
		    	var returnArr=new Array();
			   	var id=Ext.getCmp('BDPDomainDescDRF').getValue();  
			    var returnStr = tkMakeServerCall("web.DHCBL.CT.BDPNationalDataType","GetDomainByType",id);  
			    returnArr=returnStr.split("^");
			    Ext.getCmp('BDPDomainCodeF').setValue(returnArr[0]);
			    Ext.getCmp('BDPDomainTypeF').setValue(returnArr[1]);  
            }
         }		
    });
    
	var WinForm = new Ext.FormPanel({
				id : 'form-save',
				URL : SAVE_ACTION_URL,
				labelAlign : 'right',
				labelWidth : 85,
				split : true,
				frame : true,  		
       			reader: new Ext.data.JsonReader({root:'list'},
                                        [
                                         {name:'BDPDomainRowId',mapping:'BDPDomainRowId',type:'string'},
                                       	 {name: 'BDPDomainCode',mapping:'BDPDomainCode',type:'string'},
                                         {name: 'BDPDomainDescDR',mapping:'BDPDomainDescDR',type:'string'},
                                         {name: 'BDPDomainValue',mapping:'BDPDomainValue',type:'string'},
                                         {name: 'BDPDomainExpression',mapping:'BDPDomainExpression',type:'string'},
                                         {name: 'BDPDomainVersion',mapping:'BDPDomainVersion',type:'string'},	
                                         {name:'BDPDomainType',mapping:'BDPDomainType',type:'string'},
                                         {name: 'BDPDomainStatement',mapping:'BDPDomainStatement',type:'string'},
                                         {name:'BDPDomainOther',mapping:'BDPDomainOther',type:'string'}
                                        ]),
				defaults : {
					anchor : '85%',
					border : false
				},
				items : [{
							id:'BDPDomainRowId',
							xtype:'textfield',
							fieldLabel : 'BDPDomainRowId',
							name : 'BDPDomainRowId',
							hideLabel : 'True',
							hidden : true
						}, DataDomainDescDr,{
							fieldLabel : '值域代码',
						 	xtype:'textfield',
                            labelSeparator : "",
						 	name:'BDPDomainCode', 
							id:'BDPDomainCodeF',
							readOnly:true, // Ext.BDP.FunLib.Component.DisableFlag('BDPDomainCodeF'),
							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('BDPDomainCodeF'))
						},{
							xtype : "textfield",
                            labelSeparator : "",
							fieldLabel : '类型',
							name:'BDPDomainType',
                            id:'BDPDomainTypeF',
						 	readOnly : true, // Ext.BDP.FunLib.Component.DisableFlag('BDPDomainTypeF'),
							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('BDPDomainTypeF'))
						},  {
							fieldLabel : '值',
							xtype:'textfield',
                            labelSeparator : "",
							id:'BDPDomainValueF',
							readOnly : Ext.BDP.FunLib.Component.DisableFlag('BDPDomainValueF'),
							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('BDPDomainValueF')),
							name : 'BDPDomainValue'
						},{
							fieldLabel : '值含义',
							xtype:'textfield',
                            labelSeparator : "",
							id:'BDPDomainExpressionF',
							readOnly : Ext.BDP.FunLib.Component.DisableFlag('BDPDomainExpressionF'),
							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('BDPDomainExpressionF')),
							name : 'BDPDomainExpression'
						},{
							fieldLabel : '国标版本',
							xtype:'textfield',
                            labelSeparator : "",
							id:'BDPDomainVersionF',
							readOnly : Ext.BDP.FunLib.Component.DisableFlag('BDPDomainVersionF'),
							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('BDPDomainVersionF')),
							name : 'BDPDomainVersion'
						}, {
							fieldLabel : '说明',
							xtype:'textarea',
                            labelSeparator : "",
							id:'BDPDomainStatementF',
							readOnly : Ext.BDP.FunLib.Component.DisableFlag('BDPDomainStatementF'),
							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('BDPDomainStatementF')),
							name : 'BDPDomainStatement',
							height:80,
							width:120
						}, {
							fieldLabel : '其他',
							xtype:'textfield',
                            labelSeparator : "",
							id:'BDPDomainOtherF',
							readOnly : Ext.BDP.FunLib.Component.DisableFlag('BDPDomainOtherF'),
							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('BDPDomainOtherF')),
							name : 'BDPDomainOther'
						} ]	
	});
		
    /*********************************重置form的数据清空**************************************/
      var ClearForm = function()
      {
           Ext.getCmp("form-save").getForm().reset();   
      }
 
 /*********************************关闭弹出窗口时的函数方法*********************************/
         var closepages= function (){
             win.hide();
             ClearForm();
       }  
 
	/**************************************增加修改时弹出窗口*********************************/
	var win = new Ext.Window({
		width : 430,
		height: 470,
		layout : 'fit',
		closeAction : 'hide',
		plain : true,
		modal : true,
		frame : true,
		autoScroll : true,
		collapsible : true,
		hideCollapseTool : true,
		titleCollapse : true,
		bodyStyle : 'padding:3px',
		buttonAlign : 'center',
		items : WinForm,
		buttons : [{
			text : '保存',
            iconCls : 'icon-save',
			id:'save_btn',
			disabled : Ext.BDP.FunLib.Component.DisableFlag('save_btn'),
			handler : function() {
            var tempCode = Ext.getCmp("BDPDomainDescDRF").getValue();  
            if (tempCode=="") {
			    Ext.Msg.show({ 
						        title : '提示', 
						        msg : '值域名称不能为空!',
						        minWidth : 200,
						        animEl: 'form-save',
						        icon : Ext.Msg.ERROR,
						        buttons : Ext.Msg.OK  
			              });
			      return;
			   }
				if (win.title == "添加") {
					WinForm.form.submit({
						url : SAVE_ACTION_URL,
						clientValidation : true,
						method : 'POST',
						success : function(form, action) {
							if (action.result.success == 'true') {
							    var myrowid = action.result.id;
				                 win.hide();
								 Ext.Msg.show({
											  	title : '提示',
												msg : '添加成功!',
												icon : Ext.Msg.INFO,
												buttons : Ext.Msg.OK,
												fn : function(btn) {
													grid.getStore().load({
															params : {
																		start : 0,
																		limit : 1,
																		rowid : myrowid
																  	 }
															 });
													 }
												 });
							} else {
								var errorMsg = '';
								if (action.result.errorinfo) {
									errorMsg = '<br/>错误信息:' + action.result.errorinfo
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
							Ext.Msg.alert('提示', '异步通讯失败,请检查网络连接!');
						 }
					 });
				 } 
		 else {
			Ext.MessageBox.confirm('提示', '确定要修改该条数据吗?', function(btn) {
				if (btn == 'yes') {
					WinForm.form.submit({
							clientValidation : true, // 进行客户端验证
						    url : SAVE_ACTION_URL,
							method : 'POST',
						  	 success : function(form, action) {
								if (action.result.success == 'true') {
							   	   var myrowid = 'rowid='+action.result.id;
                                   win.hide();
			                       Ext.Msg.show({
			                                        title : '<font color=blue>提示</font>',
			                                        msg : '<font color=green> 修改成功!</font>',
			                                        animEl: 'form-save',
			                                        icon : Ext.Msg.INFO,
			                                        buttons : Ext.Msg.OK,
			                                        fn : function(btn) {
			                                            Ext.BDP.FunLib.ReturnDataForUpdate('grid',QUERY_ACTION_URL,myrowid);
			                                        }
			                                   }); 
									} else {
										var errorMsg = '';
										if (action.result.errorinfo) {
											errorMsg = '<br/>错误信息:' + action.result.errorinfo
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
									Ext.Msg.alert('提示', '异步通讯失败,请检查网络连接!');
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
				  win.hide();     
                  ClearForm(); 
			}
		}],
		listeners : {
			"show" : function() {
				Ext.getCmp("form-save").getForm().findField("BDPDomainCode").focus(true,300);
			},
			"hide" : function(){
                 Ext.BDP.FunLib.Component.FromHideClearFlag();
                 closepages();
               },
			"close" : function() {
			}
		}
	});
	
	/***********************************增加按钮**************************************************/
	var btnAddwin = new Ext.Toolbar.Button({
				text : '添加',
				tooltip : '添加',
				iconCls : 'icon-add',
				id:'add_btn',
				disabled : Ext.BDP.FunLib.Component.DisableFlag('add_btn'),
				handler : AddData=function() {
					win.setTitle('添加');
					win.setIconClass('icon-add');
					win.show();
					WinForm.getForm().reset();
				},
				scope: this
	  });
	
	/**************************************修改按钮********************************************/
	var btnEditwin = new Ext.Toolbar.Button({
				text : '修改',
				tooltip : '修改',
				iconCls : 'icon-update',
				id:'update_btn',
				disabled : Ext.BDP.FunLib.Component.DisableFlag('update_btn'),
				handler : UpdateData=function() {
					if (grid.selModel.hasSelection()) {
						loadFormData(grid);
					} else {
							Ext.Msg.show({
											title : '提示',
											msg : '请选择需要修改的行！',
											icon : Ext.Msg.WARNING,
						    				buttons : Ext.Msg.OK
										});
							}
				 }
	    });
	 
	var ds = new Ext.data.Store({
				proxy : new Ext.data.HttpProxy({url : QUERY_ACTION_URL}),
				reader : new Ext.data.JsonReader({
							totalProperty : 'total',
							root : 'data',
							successProperty : 'success'
						},[{
								name:'BDPDomainRowId',
								mapping:'BDPDomainRowId',
								type:'int'
							},{
								name : 'BDPDomainVersion',
								mapping : 'BDPDomainVersion',
								type : 'string'
							}, {
								name : 'BDPDomainCode',
								mapping : 'BDPDomainCode',
								type : 'string'
							}, {
								name : 'BDPDomainDescDR',
								mapping : 'BDPDomainDescDR',
								type : 'string'
							}, {
								name : 'BDPDomainValue',
								mapping : 'BDPDomainValue',
								type : 'string'
							}, {
								name : 'BDPDomainExpression',
								mapping : 'BDPDomainExpression',
								type : 'string'
							}, {
								name : 'BDPDomainType',
								mapping : 'BDPDomainType',
								type : 'string'
							}, {
								name : 'BDPDomainStatement',
								mapping : 'BDPDomainStatement',
								type : 'string'
							},{
								name : 'BDPDomainVersion',
								mapping : 'BDPDomainVersion',
								type : 'string' 
							 
							}, {
								name : 'BDPDomainOther',
								mapping : 'BDPDomainOther',
								type : 'string' 
							} 
						]) 
	     });
 	// 加载数据
	  ds.load({
				 params : { start : 0, limit : limit }
	        });
	
	/** **************************grid分页工具条**************************************/
	var paging = new Ext.PagingToolbar({
            pageSize: limit,
            store: ds,
            displayInfo: true,
            displayMsg : '显示第 {0} 条到 {1} 条记录,一共 {2} 条',
            emptyMsg : "没有记录",
            plugins : [new Ext.BDP.FunLib.PagingToolbarResizer()],
             listeners : {
					        "change":function (t,p)
					       { 
					           limit=this.pageSize;
					       }
			           }
        });
	var sm = new Ext.grid.CheckboxSelectionModel({
			singleSelect : true,
			checkOnly : false,
			width : 20
	 });

	/*************************************增删改工具条******************************************/
	var tbbutton = new Ext.Toolbar({
		enableOverflow : true,
		items : [btnAddwin, '-', btnEditwin, '-', btnDel , '-',btnImport]
	});
	
	/****************************************搜索工具条*************************************/
	var btnSearch = new Ext.Button({
				id : 'btnSearch',
				disabled : Ext.BDP.FunLib.Component.DisableFlag('btnSearch'),
				tooltip : '搜索',
				iconCls : 'icon-search',
				text : '搜索',
				handler : function() {
				grid.getStore().baseParams={
						code :  Ext.getCmp("TextCode").getValue(),
						desc :  Ext.getCmp("TextBDPDomainDescDRF").getValue(),
						value:	Ext.getCmp('TextExpreesion').getValue() 
				};
	grid.getStore().load({
				params : {
							start : 0,
							limit : limit
						}
			});
	  }
	});
	
	// 刷新工作条
	var btnRefresh = new Ext.Button({
				id : 'btnRefresh',
				disabled : Ext.BDP.FunLib.Component.DisableFlag('btnRefresh'),
				tooltip : '重置',
				iconCls : 'icon-refresh',
				text : '重置',
				handler : function() {
							Ext.BDP.FunLib.SelectRowId="";
					        Ext.getCmp("TextCode").reset();
							Ext.getCmp("TextBDPDomainDescDRF").reset();
							Ext.getCmp('TextExpreesion').reset();
							grid.getStore().baseParams={};
							grid.getStore().load({
								params : {
									       start : 0,
									       limit : limit
										}
								});
						  }
			    });
	
	// 将工具条放到一起
	var TextDataDomainDescDr=new Ext.BDP.Component.form.ComboBox({
        xtype:'bdpcombo',
        loadByIdParam:'rowid',
        fieldLabel : '值域名称',
        name : 'BDPDomainDescDR',
        id:'TextBDPDomainDescDRF',
        readOnly : Ext.BDP.FunLib.Component.DisableFlag('TextBDPDomainDescDRF'),
        style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('TextBDPDomainDescDRF')),
        store :ComboStore ,
	    queryParam : 'desc',
	    triggerAction : 'all',
	    forceSelection : true,
	    selectOnFocus : false,
	    minChars : 0,
	    listWidth : 250,
	    valueField : 'BDPStandardRowId',
	    displayField : 'BDPStandardDomainDesc',
	   // hiddenName : 'BDPDomainDescDR',
	    pageSize :Ext.BDP.FunLib.PageSize.Combo,
	    listeners:{
		    'select': function(field,e){
		      	grid.getStore().baseParams={
						code :  Ext.getCmp("TextCode").getValue(),
						desc :  Ext.getCmp("TextBDPDomainDescDRF").getValue(),
						value:	Ext.getCmp('TextExpreesion').getValue() 
				};
			grid.getStore().load({
						params : {
									start : 0,
									limit : limit
								}
					});
            }
         }		
    });
	var tb = new Ext.Toolbar({
				id : 'tb',
				items : ['值域代码', {xtype : 'textfield',id : 'TextCode',
				disabled : Ext.BDP.FunLib.Component.DisableFlag('TextCode')
				},'-','值域名称',  TextDataDomainDescDr
				,'-','值含义', {xtype : 'textfield',id : 'TextExpreesion',disabled : Ext.BDP.FunLib.Component.DisableFlag('TextExpreesion')
				} ,'-',btnSearch,'-', btnRefresh,'->'
			  ],
			listeners : {
				render : function() {
					tbbutton.render(grid.tbar)
				}
			}
	});

	// 创建Grid
	var grid = new Ext.grid.GridPanel({
				title : '国家标准数据元值域',
				id : 'grid',
				region : 'center',
				width : 900,
				height : 500,
				tools:Ext.BDP.FunLib.Component.HelpMsg,
				closable : true,
				store : ds,
				trackMouseOver : true,
				sm:new Ext.grid.RowSelectionModel({singleSelect:true}),
				columns :[new Ext.grid.CheckboxSelectionModel(), 
					{
							header : 'BDPDomainRowId',
							width : 70,
							sortable : true,
							dataIndex : 'BDPDomainRowId',
							hidden:true
					}, {
							header : '值域代码',
							width : 80,
							sortable : true,
							dataIndex : 'BDPDomainCode'
						}, {
							header : '值域名称',
							width : 100,
							sortable : true,
							dataIndex : 'BDPDomainDescDR'
						}, {
							header : '值',
							width : 100,
							sortable : true,
							dataIndex : 'BDPDomainValue'
						}, {
							header : '值含义',
							width : 80,
							sortable : true,
							dataIndex : 'BDPDomainExpression'
						}, {
							header : '类型',
							width : 80,
							sortable : true,
							dataIndex : 'BDPDomainType'
						},{
							header : '国标版本',
							width : 70,
							sortable : true,
							dataIndex : 'BDPDomainVersion'
						},{
							header : '说明',
							width : 80,
							sortable : true,
							dataIndex : 'BDPDomainStatement'
						},{
							header : '其他',
							width : 80,
							sortable : true,
							dataIndex : 'BDPDomainOther'
						} ],
				stripeRows : true,
				stateful : true,
				viewConfig : {
					forceFit : true
				},
				bbar : paging,
				tbar : tb,
				stateId : 'grid'	
	});
 
   /********************************载入被选择的数据行的表单数据*******************************************/
    var loadFormData = function(grid) {
        var _record = grid.getSelectionModel().getSelected();
        if (!_record) {
            Ext.Msg.alert('修改操作', '请选择要修改的一项!');
        } else {
        	win.setTitle('修改');
			win.setIconClass('icon-update');
			win.show();
            WinForm.form.load( {
                url : OPEN_ACTION_URL + '&id='+ _record.get('BDPDomainRowId') 
            });
        }
    };
    grid.on("rowdblclick", function(grid, rowIndex, e) {
        loadFormData(grid);
    });	
    
	//Ext.BDP.FunLib.ShowUserHabit(grid,Ext.BDP.FunLib.SortTableName);
	 /*********************************IE下的快捷键操作*******************************************/
    Ext.BDP.FunLib.Component.KeyMap(AddData,UpdateData,DelData);
	var viewport = new Ext.Viewport({
		 layout : 'border',
	 	 items : [grid]
	});
});