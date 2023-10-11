    ///--不维护了
  	/// 名称:库存-7 库存分类维护
	/// 描述:包含增删改查功能
	/// 编写者:基础平台组 - 陈莹 
	/// 编写日期:2012-8-30
	/// 最后修改日期:2013-5-13
Ext.onReady(function() {

	Ext.BLANK_IMAGE_URL = '../scripts_lib/ext3.2.1/resources/images/default/s.gif';
	var ACTION_URL = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.INCStkCat&pClassQuery=GetList";
	var OPEN_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.INCStkCat&pClassMethod=OpenData";
	var SAVE_ACTION_URL_New = "../csp/dhc.bdp.ext.entitydatatrans.csp?pClassName=web.DHCBL.CT.INCStkCat&pClassMethod=SaveEntity&pEntityName=web.Entity.CT.INCStkCat";
	var DELETE_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.INCStkCat&pClassMethod=DeleteData";
	
	var pagesize = Ext.BDP.FunLib.PageSize.Main;

	Ext.QuickTips.init();												  //--------启用悬浮提示
	Ext.form.Field.prototype.msgTarget = 'under';                         //--------设置消息提示方式为在右边显示
	
	/**----初始化Ext状态管理器，在Cookie中记录用户的操作状态*/
	//Ext.state.Manager.setProvider(new Ext.state.CookieProvider());   
	/**---------在删除按钮下实现删除功能--------------*/
	var btnDel = new Ext.Toolbar.Button({                                 //-------创建一个删除按钮 
		text : '删除',													  //-------按钮的内容
		tooltip : '删除',												  //-------工具提示或说明
		iconCls : 'icon-delete',										  //-------给一个空间用来显示图标
		id:'del_btn',
   		disabled : Ext.BDP.FunLib.Component.DisableFlag('del_btn'),
		handler : function delData() {											  //指定事件处理的函数,点击删除按钮后执行后面的函数
			if (grid.selModel.hasSelection()) {                           //-------如果选中某一行则继续执行删除操作
				
				/**Ext.MessageBox.confirm------------------------------------------用来弹出一个提示框() 
				  *调用格式： confirm(String title,String msg,[function fn],[Object scope]) 
				  */
				Ext.MessageBox.confirm('提示', '确定要删除所选的数据吗?', function(btn) {
					if (btn == 'yes') {                                   //-------点击确定按钮后继续执行删除操作
						//Ext.MessageBox.wait('数据删除中,请稍候...', '提示'); //-------wait框
						var gsm = grid.getSelectionModel();				  // ------获取选择列
						var rows = gsm.getSelections();					  //-------根据选择列获取到所有的行
						
						//开始处理请求
						Ext.Ajax.request({	                              	
							url : DELETE_ACTION_URL,					  //-------发出请求的路径
							method : 'POST',                              //-------需要传递参数 用POST
							params : {									  //-------请求带的参数
								'id' : rows[0].get('INCSCRowId')          //-------通过RowId来删除数据
							},
							
							/**callback : Function （可选项）(Optional) 
                                       *该方法被调用时附上返回的http response对象
                                       *该函数中传入了如下参数：
                                       *options : Object  //-----------------------请求所调用的参数
                                       *success : Boolean //-----------------------请求成功则为true
                                       *response : Object //-----------------------包含了返回数据的xhr(XML Http Request)对象
                                       **/
							callback : function(options, success, response) {
								Ext.MessageBox.hide();
								if (success) {				              //-------请求成功									
									var jsonData = Ext.util.JSON.decode(response.responseText);//------获取返回的信息
									if (jsonData.success == 'true') {
										Ext.Msg.show({
											title : '提示',
											msg : '数据删除成功！',
											icon : Ext.Msg.INFO,          //-------显示图标样式(信息图标)
											buttons : Ext.Msg.OK,         //-------只显示一个确定按钮
											fn : function(btn){
												var startIndex = grid.getBottomToolbar().cursor;
												var totalnum=grid.getStore().getTotalCount();
												if(totalnum==1){   //修改添加后只有一条，返回第一页
													var startIndex=0
												}
												else if((totalnum-1)%pagesize==0)//最后一页只有一条
												{
														
														var pagenum=grid.getStore().getCount();
														if (pagenum==1){ startIndex=startIndex-pagesize;}  //最后一页的时候
														//不是最后一页则还停留在这一页
												}
												grid.getStore().load({
															params : {
																start : startIndex,
																limit : pagesize  
																}	
														});		
	
											}
										});
									} else {						     //--------如果返回的是错误的请求
										var errorMsg = '';
										if (jsonData.info) {			//---------获取传递来的错误信息
											errorMsg = '<br/>错误信息:'+ jsonData.info
										}
										Ext.Msg.show({
													title : '提示',
													msg : '数据删除失败！' + errorMsg,
													minWidth : 200,
													icon : Ext.Msg.ERROR,//--------显示图标样式(错误图标)
													buttons : Ext.Msg.OK//---------只有一个确定按钮
												});
									}
								} else {							    //---------删除失败提示错误信息
									Ext.Msg.show({
												title : '提示',
												msg : '异步通讯失败,请检查网络连接！',
												icon : Ext.Msg.ERROR,    //--------显示图标样式(错误图标)
												buttons : Ext.Msg.OK     //--------只有一个确定按钮
											});
								}
							}
						}, this);
					}
				}, this);
			} else {												   
				Ext.Msg.show({										     //--------没有选择行记录的时候
							title : '提示',
							msg : '请选择需要删除的行！',
							icon : Ext.Msg.WARNING,
							buttons : Ext.Msg.OK
						});
			}
		}
	});
	
	/**---------创建一个供增加和修改使用的form-----------*/
	var WinForm = new Ext.form.FormPanel({
				id : 'form-save',	                                     //--------FORM标签的id									
				//collapsible : true,
				//title : '数据信息',
				//region: 'west',
				//bodyStyle : 'padding:5px 5px 0',
				baseCls : 'x-plain',//form透明,不显示框框
				labelAlign : 'right',
				labelWidth : 75,
				split : true,
				frame : true, //--------Panel具有全部阴影，若为false则只有边框有阴影			
				waitMsgTarget : true,
				defaults : {
					anchor : '85%',
					bosrder : false
				},
				reader: new Ext.data.JsonReader({root:'list'},
                                        [{name: 'INCSCRowId',mapping:'INCSCRowId',type:'string'},
                                         {name: 'INCSCCode',mapping:'INCSCCode',type:'string'},
                                         {name: 'INCSCDesc',mapping:'INCSCDesc',type:'string'}
                                        ]),
				defaultType : 'textfield',								 //--------统一设定items类型为textfield
				items : [{
							id:'INCSCRowId',
							fieldLabel : 'INCSCRowId',
							hideLabel : 'True',
							hidden : true,                               //--------RowId属性隐藏
							name : 'INCSCRowId'
						}, {
							id:'INCSCCodeF',
							maxLength:15,
							fieldLabel : '<font color=red>*</font>代码',
  							//disabled : Ext.BDP.FunLib.Component.DisableFlag('INCSCCodeF'),
  							readOnly : Ext.BDP.FunLib.Component.DisableFlag('INCSCCodeF'),
							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('INCSCCodeF')),
							name : 'INCSCCode',
							allowBlank: false,
							enableKeyEvents:true, 
 							validationEvent : 'blur',  
                            validator : function(thisText){
                            	//Ext.Msg.alert(thisText);
	                            if(thisText==""){
	                            	return true;
	                            }
	                            var className =  "web.DHCBL.CT.INCStkCat";
	                            var classMethod = "FormValidate";                     
	                            var id="";
	                            if(win.title=='修改'){
	                            	var _record = grid.getSelectionModel().getSelected();
	                            	var id = _record.get('INCSCRowId');
	                            }
	                            var flag = "";
	                            var flag = tkMakeServerCall(className,classMethod,id,thisText,"");
	                            //Ext.Msg.alert(flag);
	                            if(flag == "1"){
	                             	return false;
	                             }else{
	                             	return true;
	                             }
                            },
                            invalidText : '该代码已经存在',
						    listeners : {'change' : Ext.BDP.FunLib.Component.ReturnValidResult}
					}, {
							id:'INCSCDescF',
							maxLength:220,
							//disabled : Ext.BDP.FunLib.Component.DisableFlag('INCSCDescF'),
							readOnly : Ext.BDP.FunLib.Component.DisableFlag('INCSCDescF'),
							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('INCSCDescF')),
							fieldLabel : '<font color=red>*</font>描述',
							name : 'INCSCDesc',
							allowBlank: false,
							enableKeyEvents:true, 
						    validationEvent : 'blur',  
						    validator : function(thisText){
                            	//Ext.Msg.alert(thisText);
	                            if(thisText==""){
	                            	return true;
	                            }
	                            var className =  "web.DHCBL.CT.INCStkCat";
	                            var classMethod = "FormValidate";
	                            var id="";
	                            if(win.title=='修改'){
	                            	var _record = grid.getSelectionModel().getSelected();
	                            	var id = _record.get('INCSCRowId');
	                            }
	                            var flag = "";
	                            var flag = tkMakeServerCall(className,classMethod,id,"",thisText);
	                            //Ext.Msg.alert(flag);
	                            if(flag == "1"){
	                             	return false;
	                             }else{
	                             	return true;
	                             }
                            },
                            invalidText : '该描述已经存在',
						    listeners : {'change' : Ext.BDP.FunLib.Component.ReturnValidResult}
						}]
			});
			
			/*function showUnique(obj){                                       //----------自定义函数显示唯一性标识
				var _parentNode = obj.el.dom.parentNode; 
                var valid =  Ext.get(_parentNode).createChild({
                     tag : 'span',
                    html : "<span style='color:red;'>*</span>"
                 		});
			}*/
			
	/**---------增加、修改操作弹出的窗口-----------*/
	var win = new Ext.Window({
		title : '',
		width : 280,
		height : 150,
		layout : 'fit',													//----------布局会充满整个窗口，组件自动根据窗口调整大小
		plain : true,                                                   //----------true则主体背景透明
		modal : true,
		frame : true,													//----------win具有全部阴影，若为false则只有边框有阴影
		autoScroll : true,
		collapsible : true,
		hideCollapseTool : true,
		titleCollapse : true,
		bodyStyle : 'padding:3px',
		buttonAlign : 'center',
		closeAction : 'hide',										   //-----------关闭窗口后执行隐藏命令
		items : WinForm,											   //-----------将增加和修改的表单加入到win窗口中
		buttons : [{
			text : '保存',
			id:'save_btn',
   			disabled : Ext.BDP.FunLib.Component.DisableFlag('save_btn'),
			handler : function() {									   //-----------保存按钮下调用的函数
				
				/**-------添加部分操作----------*/	 
				if (win.title == "添加") {                                         //？？？可以换个判断方式
					WinForm.form.submit({
						clientValidation : true,                       //-----------进行客户端验证
						waitMsg : '正在提交数据请稍后',
						waitTitle : '提示',
						url : SAVE_ACTION_URL_New,						//----------发出请求的路径（保存数据）
						method : 'POST',
						
						/**下面有两种不同类型的success对象其表示的意义有所不同
						 * ①是submit的一个配置选项 表示服务器成功响应。不管你响应给客户端的内容是什么，
						 * ---------------------------------------只要响应成功就会执行这个success，跟你返回的内容无关
						 * ②是根据返回json中success属性判断的，如果success为true，则success否则 failure
						 */
						success : function(form, action) {              
							if (action.result.success == 'true') {    //如果json中success属性返回的为true
								win.hide();
								var myrowid = action.result.id;		  
								// var myrowid = jsonData.id;
								Ext.Msg.show({						  //------------做一个文本提示框
											title : '提示',
											msg : '添加成功！',
											icon : Ext.Msg.INFO,	  //------------图标显示（信息图标样式）
											buttons : Ext.Msg.OK,     //------------只有一个确定按钮的样式
											fn : function(btn) {      //------------回调函数参数为button的Id
												var startIndex = grid.getBottomToolbar().cursor;//获取当前页开始的记录数
												grid.getStore().load({ //-----------重新载入数据         
															params : { //-----------参数
																start : 0,
																limit : pagesize,
																rowid : myrowid   //新添加的数据rowid
															}
														});
											}
										});
							} 
							else {									//--------------如果jason中success属性返回的不是true
								var errorMsg = '';
								if (action.result.errorinfo) {      //--------------保存返回的错误信息
									errorMsg = '<br/>错误信息:'+ action.result.errorinfo
								}
								Ext.Msg.show({						//--------------显示错误信息文本框
											title : '提示',
											msg : '添加失败！' + errorMsg,
											minWidth : 200,
											icon : Ext.Msg.ERROR,   //--------------图标（错误提示图标）
											buttons : Ext.Msg.OK    //--------------只有一个确定按钮
										});
							}
						},
						//--------------服务器端响应失败（ps:跟据response的状态码确定，如404,500时为failure）
						failure : function(form, action) {			//--------------服务器端响应失败
							 if(action.failureType == 'client'){
                                  //客户端数据验证失败的情况下
                                      Ext.Msg.alert('提示','数据验证失败，<br/>请检查您的数据格式是否有误！');
								}
								else Ext.Msg.alert('提示', '添加失败！');
						}
					})
				} 
				/**---------修改部分操作(操作过程与增加类似，重复代码不再注释)-------*/
				else {
					Ext.MessageBox.confirm('提示', '确定要修改该条数据吗?', function(btn) {
						if (btn == 'yes') {
							WinForm.form.submit({                   //---------------确定修改后，将表单的数据提交
								clientValidation : true,            //---------------进行客户端验证
								waitMsg : '正在提交数据请稍后',
								waitTitle : '提示',
								url : SAVE_ACTION_URL_New,
								method : 'POST',
								success : function(form, action) {
									// alert(action);
									if (action.result.success == 'true') {
										win.hide();
										var myrowid = "rowid="+action.result.id;
										// var myrowid = jsonData.id;
										Ext.Msg.show({
											title : '提示',
											msg : '修改成功！',
											icon : Ext.Msg.INFO,
											buttons : Ext.Msg.OK,
											fn : function(btn) {
												var startIndex = grid.getBottomToolbar().cursor;
												Ext.BDP.FunLib.ReturnDataForUpdate("grid",ACTION_URL,myrowid)
												/*grid.getStore().load({
															params : {
																start : 0,
																limit : pagesize,
																rowid : myrowid
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
													msg : '修改失败！' + errorMsg,
													minWidth : 200,
													icon : Ext.Msg.ERROR,
													buttons : Ext.Msg.OK
												});
									}
								},
								failure : function(form, action) {
									if(action.failureType == 'client'){
                                     //客户端数据验证失败的情况下
                                      Ext.Msg.alert('提示','数据验证失败，<br/>请检查您的数据格式是否有误！');
								}
								else Ext.Msg.alert('提示', '修改失败！');
								}
							})
						}
					}, this);
				}
			}
		}, {
			text : '取消',
			handler : function() {
			    win.hide();
			}
		}],
		listeners : {
			"show" : function() {
				Ext.getCmp("form-save").getForm().findField("INCSCCode").focus(true,300);
				//grid.setDisabled(true);
			},
			"hide" : function() {
				Ext.BDP.FunLib.Component.FromHideClearFlag;
				WinForm.getForm().reset();
			},
			"close" : function() {
			}
		}
	});
	/**---------增加按钮-----------*/
	var btnAddwin = new Ext.Toolbar.Button({
				text : '添加',
				tooltip : '添加',
				iconCls : 'icon-add',
				id:'add_btn',
   				disabled : Ext.BDP.FunLib.Component.DisableFlag('add_btn'),
				handler : function addData() {                              //------------在函数中调用添加窗口
					win.setTitle('添加');
					win.setIconClass('icon-add');
					win.show();
					WinForm.getForm().reset();					    //------------添加首先要将表单重置清空一下
				},
				scope : this										//------------作用域
			});
	/**---------修改按钮-----------*/
	var btnEditwin = new Ext.Toolbar.Button({
				text : '修改',
				tooltip : '修改',
				iconCls : 'icon-update',
				id:'update_btn',
   				disabled : Ext.BDP.FunLib.Component.DisableFlag('update_btn'),
				handler : function updateData() {						        //-----------显示修改的窗口和form	
					loadFormData(grid);
				}
			});
			
     /**------将数据读取出来并转换(成record实例)，为后面的读取和修改做准备-------*/
	var ds = new Ext.data.Store({											
				proxy : new Ext.data.HttpProxy({                            //---------通过HttpProxy的方式读取原始数据
							url : ACTION_URL								//---------调用的动作
						}),
				reader : new Ext.data.JsonReader({						    //---------将原始数据转换
							totalProperty : 'total',
							root : 'data',
							successProperty : 'success'
						}, [{												//---------列的映射
									name : 'INCSCRowId',
									mapping : 'INCSCRowId',
									type : 'string'
								}, {
									name : 'INCSCCode',
									mapping : 'INCSCCode',
									type : 'string'
								}, {
									name : 'INCSCDesc',
									mapping : 'INCSCDesc',
									type : 'string'
								}
						])
				//remoteSort : true										  //----------排序
			});
		/**-------------------加载数据-----------------*/
	ds.load({
				params : {												  //----------ds加载时发送的附加参数
					start : 0,
					limit : pagesize
				},
				callback : function(records, options, success) {          //----------加载完成后执行的回调函数
					/**参数records表示获得的数据
					 * 	  options表示执行load时传递的参数 	 
					 *    success表示是否加载成功
					 */
					 //alert(options);
					 //Ext.Msg.alert('info', '加载完毕, success = '+
					 //records.length);
				}
			});
			
		/**---------分页工具条-----------*/	
	var paging = new Ext.PagingToolbar({
				pageSize : pagesize,
				store : ds,	
				plugins : [new Ext.BDP.FunLib.PagingToolbarResizer()],
                listeners : {
         		 "change":function (t,p)
         		{ 
             		pagesize=this.pageSize;
         		}
          		},										     //-----------刚ds发生load事件时会触发paging
				displayInfo : true,										 //-----------是否显示右下方的提示信息false为不显示
				//displayMsg : '显示第 {0} 条到 {1} 条记录，一共 {2} 条',    //-----------提示信息，这里规定了一种显示格式，默认也可以
				emptyMsg : "没有记录"
			})
	var sm = new Ext.grid.CheckboxSelectionModel({
				singleSelect : true,
				checkOnly : false,
				width : 20
			});

	/**---------增删改工具条-----------*/
	var tbbutton = new Ext.Toolbar({
		//enableOverflow : true,										
		items : [btnAddwin, '-', btnEditwin, '-', btnDel]			    //------------通过'-'连接每个按钮也可以用'separator'代替
			// ,'->',{text:'刷新',iconCls:'icon-arrowrefresh'}
		})
		
		
	/**---------搜索按钮-----------*/
	var btnSearch = new Ext.Button({
				id : 'btnSearch',
   				disabled : Ext.BDP.FunLib.Component.DisableFlag('btnSearch'),
				iconCls : 'icon-search',
				text : '搜索',
				handler : function() {                                  //-----------执行回调函数
				grid.getStore().baseParams={							//-----------模糊查询		
						code : Ext.getCmp("TextCode").getValue()
								,
						desc : Ext.getCmp("TextDesc").getValue()
								
				};
				grid.getStore().load({									//-----------加载查询出来的数据
					params : {
						start : 0,
						limit : pagesize
					}
				});
				}

			});
			
	/**---------刷新按钮-----------*/
	var btnRefresh = new Ext.Button({
				id : 'btnRefresh',
				disabled : Ext.BDP.FunLib.Component.DisableFlag('btnRefresh'),
				iconCls : 'icon-refresh',
				text : '重置',
				handler : function() {
					Ext.getCmp("TextCode").reset();						//-----------将输入框清空
					Ext.getCmp("TextDesc").reset();                     //-----------将输入框清空
					grid.getStore().baseParams={};
					grid.getStore().load({                              //-----------加载数据
								params : {
									start : 0,
									limit : pagesize
								}
							});
				}

			});
			
	/**---------将工具条放在一起-----------*/
	var tb = new Ext.Toolbar({
				id : 'tb',
				items : ['代码：', {
							xtype : 'textfield',
							id : 'TextCode',
							disabled : Ext.BDP.FunLib.Component.DisableFlag('TextCode')
						},
						 '-',
						'描述：', {
							xtype : 'textfield',
							id : 'TextDesc',
							disabled : Ext.BDP.FunLib.Component.DisableFlag('TextDesc')
						},
						'-', btnSearch, '-', btnRefresh, '->'
				],
				listeners : {                                        //--------------作一个监听配置(config)
					render : function() {                            //--------------当组件被渲染后将触发此函数
						tbbutton.render(grid.tbar)                   // 渲染tbbutton按钮，tbar.render(panel.bbar)这个效果在底部
					}
				}
			});
	/**---------创建grid-----------*/
	var grid = new Ext.grid.GridPanel({
				id : 'grid',
				region : 'center',
				width : 900,
				tools:Ext.BDP.FunLib.Component.HelpMsg,
				height : 500,
				closable : true,
				store : ds,											//----------------表格的数据集
				trackMouseOver : true,                              //----------------鼠标移动到某一行将显示高亮
				columns : [sm, {									//----------------定义列
							header : 'INCSC_RowId',
							width : 100,
							sortable : true,
							dataIndex : 'INCSCRowId',
							hidden : true                          //-----------------隐藏掉rowid
						}, {
							header : '代码',
							width : 100,
							sortable : true,
							dataIndex : 'INCSCCode'
						}, {
							header : '描述',
							width : 100,
							sortable : true,
							dataIndex : 'INCSCDesc'
						}],
				stripeRows : true,                                //------------------显示斑马线
				loadMask : {                                      //------------------用于在加载数据时做出类似于遮罩的效果
					msg : '数据加载中,请稍候...'
				},
				title : '库存分类',
				// config options for stateful behavior
				stateful : true,                                  //-----------------
				viewConfig : {									  //-----------------视图配置
					forceFit : true								  //-----------------固定大小
				},
				//autoExpandColum:'INCSCForeignDesc',
				bbar : paging,                                    //-----------------底部状态栏
				tbar : tb,                                        //-----------------顶部状态栏
				stateId : 'grid'
			});
	/**---------双击事件-----------*/
	grid.on("rowdblclick", function(grid) {
        loadFormData(grid);
    });
	
     /**--------载入被选择的数据行的表单数据(后台调用OpenData方法)---------------*/
    var loadFormData = function(grid) {
        var _record = grid.getSelectionModel().getSelected();
        if (!_record) {
            Ext.Msg.alert('提示', '请选择要修改的行！');
        } else {
        	win.setTitle('修改');
        	win.setIconClass('icon-update');
            win.show();
            WinForm.form.load( {
                url : OPEN_ACTION_URL + '&INCSCRowId='+ _record.get('INCSCRowId'),
                waitMsg : '正在载入数据...',
                success : function(form,action) {
                },
                failure : function(form,action) {
                    //Ext.example.msg('编辑', '载入失败');
                	Ext.Msg.alert('编辑', '载入失败！');
                }
            });
        }
    };

	/**---------创建viewport-----------*/
	var viewport = new Ext.Viewport({
				layout : 'border',
				items : [grid]
			});
	if(window.ActiveXObject)//判断浏览器是否属于IE,屏蔽其它浏览器，否则可能会报错
    {
    	Ext.BDP.FunLib.Component.KeyMap(addData,updateData,delData);
    }
});
