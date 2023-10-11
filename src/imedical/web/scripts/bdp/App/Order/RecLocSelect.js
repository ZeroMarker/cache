/// 名称: 查询接收科室
/// 描述: 医嘱大类、医嘱子分类、医嘱项关联的接收科室都显示出来
/// 编写者: 基础数据平台组-谷雪萍 、陈莹
/// 编写日期: 2016-6-13
document.write('<script type="text/javascript" src="../scripts/bdp/Framework/scripts/BDPComboBox.js"> </script>');

Ext.onReady(function() {
	//var BDPDateFormat="Y-m-d"
	//Ext.state.Manager.setProvider(new Ext.state.CookieProvider());
	Ext.QuickTips.init();
	Ext.form.Field.prototype.msgTarget = 'qtip';
	var pagesize_main = Ext.BDP.FunLib.PageSize.Main;
	var GetObjectReference_URL = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.RecLocSelect&pClassQuery=GetPre"; 
	var CTLOC_Group_QUERY_ACTION_URL = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.CTLoc&pClassQuery=GetDataForCmbGroup";  //返回本组的科室
	var CTLOC_QUERY_ACTION_URL = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.CTLoc&pClassQuery=GetDataForCmb1";
	var CHILD_QUERY_ACTION_URL = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.RecLocSelect&pClassQuery=GetList";
	

	/////////////////////////////日志查看 ////////////////////////////////////////
	
   var logmenu=tkMakeServerCall("web.DHCBL.CT.RecLocSelect","GetLinkTable","RecLocSelect");
   var btnlog=Ext.BDP.FunLib.GetLogBtn(logmenu);
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


	var Arr=new Array()
	Arr.title=""

	//多院区医院下拉框
	var hospComp=GenHospComp('ARC_ItmMast');	
	//医院下拉框选择一条医院记录后执行此函数	
	hospComp.on('select',function (){
		 grid.enable();
		 Ext.getCmp('TextCode2').reset();
		 Ext.getCmp('TextDesc2').reset();
		 Ext.getCmp('TextObjectReference').reset();
		 grid.getStore().baseParams={
			objecttype : Ext.getCmp("TextObjectType").getValue(),
			//RecLoc : Ext.getCmp('TextDesc2').getValue(),
			//OrdLoc : Ext.getCmp('TextCode2').getValue(),
			//ParRef : Ext.getCmp('TextObjectReference').getValue(),
			hospid:hospComp.getValue()
	 	};
		grid.getStore().load({
					params : {
						start : 0,
						limit : pagesize_main
					}
				});
		
	});
/************************************导入数据按钮****************************************/

Ext.BDP.FunLib.ImportBtn = new Ext.Toolbar.Button({
			text : '导入',
			tooltip : '导入',
			iconCls : 'icon-import',
			id : 'btnImport',
			//hidden:true,
			//disabled : Ext.BDP.FunLib.Component.DisableFlag('btnImport'),
	      	handler: importData=function () {			        ;
				 	//alert(selectNode)
	                	var link="dhc.bdp.ext.default.csp?extfilename=App/Order/ctordreclocimport";
	                	if ('undefined'!==typeof websys_getMWToken){
							link += "&MWToken="+websys_getMWToken()
						}
	                	//ctarcitemcatimp"; 
	                	//ctaddimport
	                	/** 导入数据窗口 */
						var windowImport = new Ext.Window({
										iconCls : 'icon-DP',
										id:'windowImport',
										width : 800,
										height : 480,
										layout : 'fit',
										plain : true,// true则主体背景透明
										modal : true,
										frame : true,
										collapsible : true,
										//constrain : true,
										hideCollapseTool : true,
										titleCollapse : true,
										constrain : true,
										closeAction : 'close',
										html : '',
										listeners : {
											"show" : function(){
												if(window.ActiveXObject)//判断浏览器是否属于IE,屏蔽其它浏览器,否则可能会报错
											    {
											    	keymap_main.disable();
											    }
											},
											"hide" : function(){
												//Ext.getCmp('ExcelImportPath').reset();
											},
											"close" : function(){
												if(window.ActiveXObject)//判断浏览器是否属于IE,屏蔽其它浏览器,否则可能会报错
											    {
													keymap_main.enable();
											    }
											}
										}
									});
						windowImport.html='<iframe id="ifrmalias" src=" '+link+' " width="100%" height="100%"></iframe>';
						windowImport.setTitle("导入数据");
						windowImport.show();
						window.winimp=windowImport;
				}
	      
    });

////×××××××××××××××××××××导入功能结束××××××××××××××××××*****************************//


/************************************导出数据按钮****************************************/
Ext.BDP.FunLib.ExportBtn = new Ext.Toolbar.Button({
		text : '导出',
		tooltip : '导出',
		id:'export_btn',
		disabled : Ext.BDP.FunLib.Component.DisableFlag('export_btn'),
		iconCls : 'icon-export',
		handler : function ExportExcelData() {
			Ext.MessageBox.confirm('提示', '确定要导出数据吗?', function(btn) {
				if (btn == 'yes') {
				
					try{
				    	xlApp = new ActiveXObject("Excel.Application");
						xlBook = xlApp.Workbooks.Add();///默认三个sheet
					}catch(e){
						var emsg="请在IE下操作，并在[internet选项]-[安全]-[受信任的站点]-[站点]中添加开始界面到可信任的站点，然后在[自定义级别]中对[没有标记为安全的ActiveX控件进行初始化和脚本运行]这一项设置为启用!"
							Ext.Msg.show({
								title : '提示',
								msg : emsg ,
								minWidth : 200,
								icon : Ext.Msg.INFO,
								buttons : Ext.Msg.OK
							}) 
						
					     //alert(e.message);
					     return;
					}
					//Ext.MessageBox.wait('正在导出数据，请勿刷新或关闭页面，请稍候...','提示');
					
					///菜单
					xlBook.worksheets(1).select(); 
					var xlsheet = xlBook.ActiveSheet; 
					var table=Ext.getCmp('TextObjectType').getValue();
					
					var sheetname=tkMakeServerCall("web.DHCBL.CT.RecLocSelect","GetName",table);
					xlsheet.name=sheetname;
					
					var count=tkMakeServerCall("web.DHCBL.CT.RecLocSelect","GetCount",table);
					if (count>0)
		       		{
		       			var titleStr=tkMakeServerCall("web.DHCBL.CT.RecLocSelect","GetTitle",table);
						//alert(titleStr)
						var titlestr=titleStr.split("^");
						var title=titlestr[0].split("&%")
						var titlecode=titlestr[1].split("&%")
						for (var i = 0; i < title.length; i++) {    				
							//1b	
				    		xlsheet.cells(1,i+1)=title[i];
				    		xlsheet.cells(2,i+1)=titlecode[i];		//第二行代码
		
						}

						var row=0,taskcount=count;
						var ProgressText='';
						var winproBar = new Ext.Window({
								closable:false,
								modal:true,
								width:314,
								items:[
									new Ext.ProgressBar({id:'proBar',text:'',width:300})
								] 
						});
						var proBar=new Ext.getCmp('proBar');
						Ext.TaskMgr.start({  
						  run:function(){
						  	row++;
						  	if(row>taskcount) //当到达最后一行退出
						  	{
						  		Ext.MessageBox.hide();
								Ext.TaskMgr.stop(this);
								winproBar.close();
								xlApp.Visible=true;	
								xlBook.Close(savechanges=true);
								CollectGarbage();
								xlApp=null;
								xlsheet=null;	
						  	}
						  	else
						  	{
						  		var DataDetailStr2=tkMakeServerCall("web.DHCBL.CT.RecLocSelect","GetInfo",table,row);
								var Detail2=DataDetailStr2.split("&%");		
								for (var j=1;j<=Detail2.length;j++){
									//xlsheet.cells(1+row,j)=Detail2[j-1];
									//xlsheet.cells(1+i,j)=Detail2[j-1];
									xlsheet.cells(2+row,j)="'"+Detail2[j-1];
								}
						  		
								progressText = "正在导出第"+row+"条记录,总共"+taskcount+"条记录!";  
							    proBar.updateProgress(row/taskcount,progressText);
							  }
								 
						  },  
						  interval:20  
						});
						winproBar.show();
		       		}
		       		else
		       		{
		       			Ext.Msg.show({
							title : '提示',
							msg : '没有数据！' ,
							minWidth : 200,
							icon : Ext.Msg.INFO,
							buttons : Ext.Msg.OK
						}) 
					    return;
		       		}					
				}
			}, this);
		}
	});

////×××××××××××××××××××××导出功能结束××××××××××××××××××*****************************//


	
	/** 接收科室store */
	var ds = new Ext.data.Store({
				proxy : new Ext.data.HttpProxy({ url : CHILD_QUERY_ACTION_URL }),// 调用的动作
				reader : new Ext.data.JsonReader({
							totalProperty : 'total',
							root : 'data',
							successProperty : 'success'
						}, [{
									name : 'RLRowId',
									mapping : 'RLRowId',
									type : 'string'
								}, {
									name : 'ParRefType',
									mapping : 'ParRefType',
									type : 'string'
								},{						//update2020-4-10 增加关联表代码列
									name : 'ARCICCode',
									mapping : 'ARCICCode',
									type : 'string'
								},{
									name : 'ARCICDesc',
									mapping : 'ARCICDesc',
									type : 'string'
								}, {
									name : 'RLRecLocDesc',
									mapping : 'RLRecLocDesc',
									type : 'string'
								}, {
									name : 'RLOrdLocDesc',
									mapping : 'RLOrdLocDesc',
									type : 'string'
								}, {
									name : 'RLFunction',
									mapping : 'RLFunction',
									type : 'string'
								}, {
									name : 'RLDefaultFlag',
									mapping : 'RLDefaultFlag',
									type : 'string'
								}, {
									name : 'RLTimeFrom',
									mapping : 'RLTimeFrom',
									type : 'string'
								}, {
									name : 'RLTimeTo',
									mapping : 'RLTimeTo',
									type : 'string'
								}, {
									name : 'RLCTHospitalDesc',
									mapping : 'RLCTHospitalDesc',
									type : 'string'
								}, {
									name : 'RLDateFrom',
									mapping : 'RLDateFrom',
									type : 'string'
								}, {
									name : 'RLDateTo',
									mapping : 'RLDateTo',
									type : 'string'
								}, {
									name : 'RLOrderPriorityDesc',
									mapping : 'RLOrderPriorityDesc',
									type : 'string'
								}, {
									name : 'RLClinicType',
									mapping : 'RLClinicType',
									type : 'string'
									
									
									
								}, {
									name : 'RLParRef',
									mapping : 'RLParRef',
									type : 'string'
									
									
									
								}// 列的映射
						])
			});
	 
		// 分页工具条
	var paging =new Ext.PagingToolbar({
						pageSize : pagesize_main,
						store : ds,
						displayInfo : true,
						displayMsg : '显示第 {0} 条到 {1} 条记录,一共 {2} 条',
						emptyMsg : '没有记录',
						plugins : [new Ext.BDP.FunLib.PagingToolbarResizer()],
						listeners : {
							"change":function (t,p) {
								pagesize_main=this.pageSize;
							}
						}
					})
	
	
	var CopyRecLoc_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.RecLocSelect&pClassMethod=CopyRecLoc";
	var TypeValueDR_QUERY_ACTION_URL = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.RecLocSelect&pClassQuery=GetDataForCmb1";
	
	var TypeDRds=new Ext.data.Store({
											autoLoad: true,
											proxy : new Ext.data.HttpProxy({ url : TypeValueDR_QUERY_ACTION_URL }),
											reader : new Ext.data.JsonReader({
											totalProperty : 'total',
											root : 'data',
											successProperty : 'success'
										}, [{ name:'RowId',mapping:'RowId'},
											{name:'Desc',mapping:'Desc'} ])
									})
	// 增加修改的Form
	var CopyWinForm = new Ext.FormPanel({
				id : 'Copy-form-save',
				autoScroll:true,
				//baseCls : 'x-plain',//form透明,不显示框框
				labelAlign : 'right',
				labelWidth : 90,
				split : true,
				frame : true,	
				waitMsgTarget : true,
       			reader: new Ext.data.JsonReader({root:'list'},
                                        [{name: 'TypeDR',mapping:'TypeDR'}
                                       ]),
				defaults : {
					anchor : '85%',
					bosrder : false
				},
				//defaultType : 'textfield',
				items : [{
								fieldLabel : '<font color=red>*</font>复制到',
								xtype : 'bdpcombo',
								pageSize : Ext.BDP.FunLib.PageSize.Combo,
								loadByIdParam : 'rowid',
								listWidth:250,
								hiddenName : 'TypeDR',
								allowBlank : false,
								readOnly : Ext.BDP.FunLib.Component.DisableFlag('TypeDR'),
								style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('TypeDR')),
								id :'TypeDR1',
								store : TypeDRds,
								mode  : 'remote',
								shadow:false,
								queryParam : 'desc',
								forceSelection : true,
								selectOnFocus : false,
								displayField : 'Desc',
								valueField : 'RowId',
								listeners:{
									   'beforequery': function(e){
											this.store.baseParams = {
													desc:e.query,
													hospid:hospComp.getValue(),
													objecttype : Ext.getCmp('TextObjectType').getValue()
											};
											this.store.load({params : {
														start : 0,
														limit : Ext.BDP.FunLib.PageSize.Combo
											}})
					  				
									 	}
								 }

						}]
	});
		
	// 增加修改时弹出窗口
	var win_batchCopy = new Ext.Window({
		title : '复制接收科室',
		width : 400,
		height: 200,
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
		items : CopyWinForm, 
		buttons : [{
			text : '保存',
			iconCls : 'icon-save',
			id:'Copy_save_btn',
			disabled : Ext.BDP.FunLib.Component.DisableFlag('Copy_save_btn'),
			handler : function() {
						
						if(CopyWinForm.getForm().isValid()==false)
						{
							 Ext.Msg.alert('提示','<font color = "red">请选择要将接收科室复制给哪一项！');
							 return;
						}
						
						
						var gsm = grid.getSelectionModel();//获取选择列
			            var rows = gsm.getSelections();//根据选择列获取到所有的行
					
						
			            var flag=0;
			            var idstr="";
			            var desc=rows[0].get('ARCICDesc');
						for(var i=0;i<rows.length;i++){
							if (idstr!="")
							{
								idstr=idstr+"&%"+rows[i].get('RLRowId');
							}
							else
							{
								idstr=rows[i].get('RLRowId');
							}
							if (rows[i].get('ARCICDesc')!=desc)
							{
								flag=1;
							}
						}
						/*if (flag==1)
						{
							Ext.Msg.show({
									title : '提示',
									msg : '请选择同一条数据的接收科室数据！',
									icon : Ext.Msg.WARNING,
									buttons : Ext.Msg.OK
								});
								return;
						}*/
						
						
						var parref=rows[0].get('RLParRef');
						if ((Ext.getCmp("TypeDR1").getRawValue()==desc)&&(Ext.getCmp("TypeDR1").getValue()==parref))
						{
							Ext.Msg.show({
									title : '提示',
									msg : '不能复制给自己！',
									icon : Ext.Msg.WARNING,
									buttons : Ext.Msg.OK
								});
								return;
						}
						
						
							Ext.Ajax.request({
								url : CopyRecLoc_ACTION_URL,
								method : 'POST',
								params : {
									'idstr' : idstr,
									'parref':Ext.getCmp("TypeDR1").getValue(),   ///复制给
									'type':Ext.getCmp('TextObjectType').getValue()
								},
								callback : function(options, success, response) {
									Ext.MessageBox.hide();
									if (success) {
										win_batchCopy.hide()
										var jsonData = Ext.util.JSON.decode(response.responseText);
										
										if (jsonData.success == 'true')
										{
											Ext.Msg.show({
												title : '提示',
												msg : '接收科室复制成功！',
												icon : Ext.Msg.INFO,
												buttons : Ext.Msg.OK,
												fn : function(btn){
													grid.getStore().baseParams={
														objecttype : Ext.getCmp("TextObjectType").getValue(),
														RecLoc : Ext.getCmp('TextDesc2').getValue(),
														OrdLoc : Ext.getCmp('TextCode2').getValue(),
														ParRef : Ext.getCmp('TextObjectReference').getValue(),
														hospid:hospComp.getValue()
													};
													grid.getStore().load({params : {start : 0, limit : pagesize_main}});
													
												}
											});
										}
										else {
												var errorMsg = '';
												if (jsonData.info) {
												errorMsg = '<br/>错误信息:'+ jsonData.info
											}
											Ext.Msg.show({
														title : '提示',
														msg :  errorMsg,
														minWidth : 200,
														icon : Ext.Msg.ERROR,
														buttons : Ext.Msg.OK,
														fn : function(btn){
															grid.getStore().baseParams={
																objecttype : Ext.getCmp("TextObjectType").getValue(),
																RecLoc : Ext.getCmp('TextDesc2').getValue(),
																OrdLoc : Ext.getCmp('TextCode2').getValue(),
																ParRef : Ext.getCmp('TextObjectReference').getValue(),
																hospid:hospComp.getValue()
															};
															grid.getStore().load({params : {start : 0, limit : pagesize_main}});
															
														
														}
															
													});
										}
									} 
									else {
										Ext.Msg.show({
													title : '提示',
													msg : '异步通讯失败,请检查网络连接！',
													icon : Ext.Msg.ERROR,
													buttons : Ext.Msg.OK
												});
									}
								}
						}, this);
						
						
						
						
					
					
					
				}
			
		}, {
			text : '关闭',
			iconCls : 'icon-close',
			handler : function() {
				win_batchCopy.hide();
			}
		}],
		listeners : {
			"show" : function() {
				
			},
			"hide" : function() {
				Ext.getCmp("Copy-form-save").getForm().reset()
			},
			"close" : function() {
			}
		}
	});
	
///主要用于新增了一个关联表数据，比如新增医嘱分类 西药片剂，将 西药口服剂 的所有接收科室赋值给  西药片剂
var btn_batchCopy = new Ext.Button({
    	id:'btn_batchCopy',
    	disabled : Ext.BDP.FunLib.Component.DisableFlag('btn_batchCopy'),
        iconCls:'icon-copy',
        text:'复制科室',
        tooltip:'按ctrl或shift键可多选列表里的数据,主要用于新增了一个关联表数据，比如新增医嘱分类 西药片剂，可以查询西药口服剂的接收科室，选中将 西药口服剂 的所有接收科室赋值给  西药片剂',
        handler:function(){
        	var gsm = grid.getSelectionModel();//获取选择列
            var rows = gsm.getSelections();//根据选择列获取到所有的行
            if(rows.length==0){
            	Ext.Msg.show({
					title:'提示',
					msg:'请选择一行或多行后复制!',
					icon:Ext.Msg.WARNING,
					buttons:Ext.Msg.OK
				});
            }else{
			 		
				win_batchCopy.setIconClass('icon-copy');
            	win_batchCopy.show();
            }
        }
    })		
    
    
    
    
    
    
	var CopyRecLocI_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.RecLocSelect&pClassMethod=CopyRecLocI";
	
	// 增加修改的Form
	var CopyWinFormI = new Ext.FormPanel({
				id : 'Copy-form-saveI',
				autoScroll:true,
				//baseCls : 'x-plain',//form透明,不显示框框
				labelAlign : 'right',
				labelWidth : 90,
				split : true,
				frame : true,	
				waitMsgTarget : true,
       			reader: new Ext.data.JsonReader({root:'list'},
                                        [{name: 'RLOrdLocDR',mapping:'RLOrdLocDR'},
                                        {name: 'RLRecLocDR',mapping:'RLRecLocDR'}
                                       ]),
				defaults : {
					anchor : '85%',
					bosrder : false
				},
				//defaultType : 'textfield',
				items : [{
							xtype : 'bdpcombo',
							pageSize : Ext.BDP.FunLib.PageSize.Combo,
							loadByIdParam : 'rowid',
							listWidth:250,
							fieldLabel : '病人科室',
							name : 'RLOrdLocDR',
							id:'RLOrdLocDRF',
   							readOnly : Ext.BDP.FunLib.Component.DisableFlag('RLOrdLocDRF'),
   							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('RLOrdLocDRF')),
							hiddenName : 'RLOrdLocDR',
							mode : 'remote',
							store : new Ext.data.Store({
								//autoLoad : true,
								proxy : new Ext.data.HttpProxy({ url : CTLOC_Group_QUERY_ACTION_URL }),
								reader : new Ext.data.JsonReader({
											totalProperty : 'total',
											root : 'data',
											successProperty : 'success'
										}, [ 'CTLOCRowID', 'CTLOCDesc' ])
							}),
							queryParam : 'desc',
							forceSelection : true,
							selectOnFocus : false,
							valueField : 'CTLOCRowID',
							displayField : 'CTLOCDesc',
							listeners:{
								   'beforequery': function(e){
										this.store.baseParams = {
												desc:e.query,
												tablename:'ARC_ItmMast',
												hospid:hospComp.getValue()
										};
										this.store.load({params : {
													start : 0,
													limit : Ext.BDP.FunLib.PageSize.Combo
										}})
									
								 	}
							}
						}, {
							xtype : 'bdpcombo',
							pageSize : Ext.BDP.FunLib.PageSize.Combo,
							loadByIdParam : 'rowid',
							listWidth:250,
							fieldLabel : '<font color=red>*</font>接收科室',
							name : 'RLRecLocDR',
							hiddenName : 'RLRecLocDR',
							id:'RLRecLocDRF',
   							readOnly : Ext.BDP.FunLib.Component.DisableFlag('RLRecLocDRF'),
   							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('RLRecLocDRF')),
							mode : 'remote',
							store : new Ext.data.Store({
								//autoLoad : true,
								proxy : new Ext.data.HttpProxy({ url : CTLOC_QUERY_ACTION_URL }),
								reader : new Ext.data.JsonReader({
											totalProperty : 'total',
											root : 'data',
											successProperty : 'success'
										}, [ 'CTLOCRowID', 'CTLOCDesc' ])
							}),
							queryParam : "desc",
							forceSelection : true,
							selectOnFocus : false,
							valueField : 'CTLOCRowID',
							displayField : 'CTLOCDesc',
							allowBlank : false							
						}]

	});
		
	// 增加修改时弹出窗口
	var win_batchCopyI = new Ext.Window({
		title : '复制接收科室给自己',
		width : 400,
		height: 220,
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
		items : CopyWinFormI, 
		buttons : [{
			text : '保存',
			iconCls : 'icon-save',
			id:'CopyI_save_btn',
			disabled : Ext.BDP.FunLib.Component.DisableFlag('CopyI_save_btn'),
			handler : function() {
						
						if(CopyWinFormI.getForm().isValid()==false)
						{
							 Ext.Msg.alert('提示','<font color = "red">请选择科室数据！');
							 return;
						}
						
						
						var gsm = grid.getSelectionModel();//获取选择列
			            var rows = gsm.getSelections();//根据选择列获取到所有的行 
			           
			            var idstr="";
			            var parref=rows[0].get('RLParRef');
						for(var i=0;i<rows.length;i++){
							if (idstr!="")
							{
								idstr=idstr+"&%"+parref+"&*"+rows[i].get('RLRowId');
							}
							else
							{
								idstr=parref+"&*"+rows[i].get('RLRowId');
							}
							
						}
						
						//  RLOrdLocDRF  RLRecLocDRF
						/*if ((Ext.getCmp("TypeDR1I").getRawValue()==desc)&&(Ext.getCmp("TypeDR1I").getValue()==parref))
						{
							Ext.Msg.show({
									title : '提示',
									msg : '不能复制给自己！',
									icon : Ext.Msg.WARNING,
									buttons : Ext.Msg.OK
								});
								return;
						}
						*/
						
							Ext.Ajax.request({
								url : CopyRecLocI_ACTION_URL,
								method : 'POST',
								params : {
									'idstr' : idstr,
									'OrdLoc':Ext.getCmp('RLOrdLocDRF').getValue(),
									'RecLoc':Ext.getCmp('RLRecLocDRF').getValue(),
									'type':Ext.getCmp('TextObjectType').getValue()
								},
								callback : function(options, success, response) {
									Ext.MessageBox.hide();
									if (success) {
										win_batchCopyI.hide()
										var jsonData = Ext.util.JSON.decode(response.responseText);
										
										if (jsonData.success == 'true')
										{
											Ext.Msg.show({
												title : '提示',
												msg : '接收科室复制成功！',
												icon : Ext.Msg.INFO,
												buttons : Ext.Msg.OK,
												fn : function(btn){
													grid.getStore().baseParams={
														objecttype : Ext.getCmp("TextObjectType").getValue(),
														RecLoc : Ext.getCmp('TextDesc2').getValue(),
														OrdLoc : Ext.getCmp('TextCode2').getValue(),
														ParRef : Ext.getCmp('TextObjectReference').getValue(),
														hospid:hospComp.getValue()
													};
													grid.getStore().load({params : {start : 0, limit : pagesize_main}});
													
												
												}
											});
										}
										else {
												var errorMsg = '';
												if (jsonData.info) {
												errorMsg = '<br/>错误信息:'+ jsonData.info
											}
											Ext.Msg.show({
														title : '提示',
														msg :  errorMsg,
														minWidth : 200,
														icon : Ext.Msg.ERROR,
														buttons : Ext.Msg.OK,
														fn : function(btn){
															grid.getStore().baseParams={
																objecttype : Ext.getCmp("TextObjectType").getValue(),
																RecLoc : Ext.getCmp('TextDesc2').getValue(),
																OrdLoc : Ext.getCmp('TextCode2').getValue(),
																ParRef : Ext.getCmp('TextObjectReference').getValue(),
																hospid:hospComp.getValue()
															};
															grid.getStore().load({params : {start : 0, limit : pagesize_main}});
															
														
														}
															});
										}
									} 
									else {
										Ext.Msg.show({
													title : '提示',
													msg : '异步通讯失败,请检查网络连接！',
													icon : Ext.Msg.ERROR,
													buttons : Ext.Msg.OK
												});
									}
								}
						}, this);
						
						
						
						
					
					
					
				}
			
		}, {
			text : '关闭',
			iconCls : 'icon-close',
			handler : function() {
				win_batchCopyI.hide();
			}
		}],
		listeners : {
			"show" : function() {
				
			},
			"hide" : function() {
				Ext.getCmp("Copy-form-saveI").getForm().reset()
			},
			"close" : function() {
			}
		}
	});
	
	///主要用于 ，新增了一个科室，比如药房2，将医嘱项数据 原来有YF-药房1的 都复制加上YF-药房2
	var btn_batchCopyI = new Ext.Button({
    	id:'btn_batchCopyI',
    	disabled : Ext.BDP.FunLib.Component.DisableFlag('btn_batchCopyI'),
        iconCls:'icon-copy',
        text:'复制科室给自己',
        tooltip:'按ctrl或shift键可多选列表里的数据，主要用于新增了一个科室时，比如药房2，将医嘱项数据 原来有YF-药房1的 都复制加上YF-药房2',
        handler:function(){
        	var gsm = grid.getSelectionModel();//获取选择列
            var rows = gsm.getSelections();//根据选择列获取到所有的行
            if(rows.length==0){
            	Ext.Msg.show({
					title:'提示',
					msg:'请选择一行或多行后复制!',
					icon:Ext.Msg.WARNING,
					buttons:Ext.Msg.OK
				});
            }else{
            
			 	var Type=Ext.getCmp('TextObjectType').getValue();
				
			 	win_batchCopyI.setIconClass('icon-copy');
			 	
            	win_batchCopyI.show();
            }
        }
    })	
	
	/********************复制接收科室到病人科室**2021-02-08**likefan*********************/
	//复制所选数据给某个病人科室
	
	var CopyToOrdLoc_Save_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.RecLocSelect&pClassMethod=CopyDataToOrdLoc";
	
	// win_CopyToOrdLoc的Form
	var CopyToOrdLocForm = new Ext.FormPanel({
				id : 'CopyToOrdLoc-form-save',
				autoScroll:true,
				//baseCls : 'x-plain',//form透明,不显示框框
				labelAlign : 'right',
				labelWidth : 90,
				split : true,
				frame : true,	
				waitMsgTarget : true,
       			reader: new Ext.data.JsonReader({root:'list'},
                                        [{name: 'CopyToOrdLocDR',mapping:'CopyToOrdLocDR'}
                                       ]),
				defaults : {
					anchor : '85%',
					bosrder : false
				},
				//defaultType : 'textfield',
				items : [{
							xtype : 'bdpcombo',
							pageSize : Ext.BDP.FunLib.PageSize.Combo,
							loadByIdParam : 'rowid',
							listWidth:250,
							fieldLabel : '<font color=red>*</font>病人科室',
							name : 'CopyToOrdLocDR',
							id:'CopyToOrdLocDRF',
   							readOnly : Ext.BDP.FunLib.Component.DisableFlag('CopyToOrdLocDRF'),
   							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('CopyToOrdLocDRF')),
							hiddenName : 'CopyToOrdLocDR',
							mode : 'remote',
							store : new Ext.data.Store({
								//autoLoad : true,
								proxy : new Ext.data.HttpProxy({ url : CTLOC_Group_QUERY_ACTION_URL }),
								reader : new Ext.data.JsonReader({
											totalProperty : 'total',
											root : 'data',
											successProperty : 'success'
										}, [ 'CTLOCRowID', 'CTLOCDesc' ])
							}),
							queryParam : 'desc',
							forceSelection : true,
							selectOnFocus : false,
							valueField : 'CTLOCRowID',
							displayField : 'CTLOCDesc',
							allowBlank : false,
							listeners:{
								   'beforequery': function(e){
										this.store.baseParams = {
												desc:e.query,
												tablename:'ARC_ItmMast',
												hospid:hospComp.getValue()
										};
										this.store.load({params : {
													start : 0,
													limit : Ext.BDP.FunLib.PageSize.Combo
										}})
								 	}
							}
						}]
	});
	
	// 点击 复制到病人科室 按钮时的弹出窗口
	var win_CopyToOrdLoc = new Ext.Window({
		title : '复制到病人科室',
		width : 400,
		height: 200,
		layout : 'fit',
		closeAction : 'hide',
		plain : true, 
		modal : true,
		frame : true,
		//autoScroll : true,
		collapsible : true,
		hideCollapseTool : true,
		titleCollapse : true,
		bodyStyle : 'padding:3px',
		buttonAlign : 'center',
		items : CopyToOrdLocForm, 
		buttons : [{
			text : '保存',
			iconCls : 'icon-save',
			id:'CopyToOrdLoc_save_btn',
			disabled : Ext.BDP.FunLib.Component.DisableFlag('CopyToOrdLoc_save_btn'),
			handler : function() {
				
				if(CopyToOrdLocForm.getForm().isValid()==false)
				{
					Ext.Msg.alert('提示','<font color = "red">请选择科室数据！');
					return;
				}
				
				var gsm = grid.getSelectionModel();//获取选择列
				var rows = gsm.getSelections();//根据选择列获取到所有的行 
			   
				var idstr="";
				for(var i=0;i<rows.length;i++){
					if (idstr!="")
					{
						idstr=idstr+"&%";
					}
					idstr=idstr+rows[i].get('RLRowId');
				}
				//alert(idstr);
				
				Ext.Ajax.request({
					url : CopyToOrdLoc_Save_URL,
					method : 'POST',
					params : {
						'idstr' : idstr,
						'OrdLoc':Ext.getCmp('CopyToOrdLocDRF').getValue(),
						'type':Ext.getCmp('TextObjectType').getValue()
					},
					callback : function(options, success, response) {
						Ext.MessageBox.hide();
						if (success) {
							win_CopyToOrdLoc.hide()
							var jsonData = Ext.util.JSON.decode(response.responseText);
							
							if (jsonData.success == 'true')
							{
								Ext.Msg.show({
									title : '提示',
									msg : '复制成功！',
									icon : Ext.Msg.INFO,
									buttons : Ext.Msg.OK,
									fn : function(btn){
										grid.getStore().baseParams={
											objecttype : Ext.getCmp("TextObjectType").getValue(),
											RecLoc : Ext.getCmp('TextDesc2').getValue(),
											OrdLoc : Ext.getCmp('TextCode2').getValue(),
											ParRef : Ext.getCmp('TextObjectReference').getValue(),
											hospid:hospComp.getValue()
										};
										grid.getStore().load({params : {start : 0, limit : pagesize_main}});
										
									
									}
								});
							}
							else {
								var errorMsg = '';
								if (jsonData.info) {
									errorMsg = jsonData.info
								}
								Ext.Msg.show({
											title : '提示',
											msg :  errorMsg,
											minWidth : 200,
											icon : Ext.Msg.Info,
											buttons : Ext.Msg.OK,
											fn : function(btn){
												grid.getStore().baseParams={
													objecttype : Ext.getCmp("TextObjectType").getValue(),
													RecLoc : Ext.getCmp('TextDesc2').getValue(),
													OrdLoc : Ext.getCmp('TextCode2').getValue(),
													ParRef : Ext.getCmp('TextObjectReference').getValue(),
													hospid:hospComp.getValue()
												};
												grid.getStore().load({params : {start : 0, limit : pagesize_main}});
											}
								});
							}
						} 
						else {
							Ext.Msg.show({
										title : '提示',
										msg : '异步通讯失败,请检查网络连接！',
										icon : Ext.Msg.ERROR,
										buttons : Ext.Msg.OK
									});
						}
					}
				}, this);
			}
		}, {
			text : '关闭',
			iconCls : 'icon-close',
			handler : function() {
				win_CopyToOrdLoc.hide();
			}
		}],
		listeners : {
			"show" : function() {
			},
			"hide" : function() {
				Ext.getCmp("CopyToOrdLoc-form-save").getForm().reset()
			},
			"close" : function() {
			}
		}
	});
	
	var btn_CopyToOrdLoc = new Ext.Button({
    	id:'btn_CopyToOrdLoc',
    	disabled : Ext.BDP.FunLib.Component.DisableFlag('btn_CopyToOrdLoc'),
        iconCls:'icon-copy',
        text:'复制到病人科室',
        tooltip:'复制所选数据给某个病人科室。主要用于新增一个病人科室，如新增肝病门诊2，把已有肝病门诊的接收科室等数据复制给肝病门诊2。',
        handler:function(){
        	var gsm = grid.getSelectionModel();//获取选择列
            var rows = gsm.getSelections();//根据选择列获取到所有的行
            if(rows.length==0){
            	Ext.Msg.show({
					title:'提示',
					msg:'请选择一行或多行后复制!',
					icon:Ext.Msg.WARNING,
					buttons:Ext.Msg.OK
				});
            }else{
			 	win_CopyToOrdLoc.setIconClass('icon-copy');
            	win_CopyToOrdLoc.show();
            }
        }
    })
	
	/****************************复制接收科室到病人科室**完******************************/
	
	/********************复制病人科室到接收科室**2021-02-23**likefan*********************/
	//复制所选数据给某个接收科室
	
	var CopyToRecLoc_Save_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.RecLocSelect&pClassMethod=CopyDataToRecLoc";
	
	// win_CopyToRecLoc的Form
	var CopyToRecLocForm = new Ext.FormPanel({
				id : 'CopyToRecLoc-form-save',
				autoScroll:true,
				//baseCls : 'x-plain',//form透明,不显示框框
				labelAlign : 'right',
				labelWidth : 90,
				split : true,
				frame : true,	
				waitMsgTarget : true,
       			reader: new Ext.data.JsonReader({root:'list'},
                                        [{name: 'CopyToRecLocDR',mapping:'CopyToRecLocDR'}
                                       ]),
				defaults : {
					anchor : '85%',
					bosrder : false
				},
				//defaultType : 'textfield',
				items : [{
							xtype : 'bdpcombo',
							pageSize : Ext.BDP.FunLib.PageSize.Combo,
							loadByIdParam : 'rowid',
							listWidth:250,
							fieldLabel : '<font color=red>*</font>接收科室',
							name : 'CopyToRecLocDR',
							id:'CopyToRecLocDRF',
   							readOnly : Ext.BDP.FunLib.Component.DisableFlag('CopyToRecLocDRF'),
   							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('CopyToRecLocDRF')),
							hiddenName : 'CopyToRecLocDR',
							mode : 'remote',
							store : new Ext.data.Store({
								//autoLoad : true,
								proxy : new Ext.data.HttpProxy({ url : CTLOC_Group_QUERY_ACTION_URL }),
								reader : new Ext.data.JsonReader({
											totalProperty : 'total',
											root : 'data',
											successProperty : 'success'
										}, [ 'CTLOCRowID', 'CTLOCDesc' ])
							}),
							queryParam : 'desc',
							forceSelection : true,
							selectOnFocus : false,
							valueField : 'CTLOCRowID',
							displayField : 'CTLOCDesc',
							allowBlank : false,
							listeners:{
								   'beforequery': function(e){
										this.store.baseParams = {
												desc:e.query,
												tablename:'ARC_ItmMast',
												hospid:hospComp.getValue()
										};
										this.store.load({params : {
													start : 0,
													limit : Ext.BDP.FunLib.PageSize.Combo
										}})
								 	}
							}
						}]
	});
	
	// 点击 复制到病人科室 按钮时的弹出窗口
	var win_CopyToRecLoc = new Ext.Window({
		title : '复制到接收科室',
		width : 400,
		height: 200,
		layout : 'fit',
		closeAction : 'hide',
		plain : true, 
		modal : true,
		frame : true,
		//autoScroll : true,
		collapsible : true,
		hideCollapseTool : true,
		titleCollapse : true,
		bodyStyle : 'padding:3px',
		buttonAlign : 'center',
		items : CopyToRecLocForm, 
		buttons : [{
			text : '保存',
			iconCls : 'icon-save',
			id:'CopyToRecLoc_save_btn',
			disabled : Ext.BDP.FunLib.Component.DisableFlag('CopyToRecLoc_save_btn'),
			handler : function() {
				
				if(CopyToRecLocForm.getForm().isValid()==false)
				{
					Ext.Msg.alert('提示','<font color = "red">请选择科室数据！');
					return;
				}
				
				var gsm = grid.getSelectionModel();//获取选择列
				var rows = gsm.getSelections();//根据选择列获取到所有的行 
			   
				var idstr="";
				for(var i=0;i<rows.length;i++){
					if (idstr!="")
					{
						idstr=idstr+"&%";
					}
					idstr=idstr+rows[i].get('RLRowId');
				}
				//alert(idstr);
				
				Ext.Ajax.request({
					url : CopyToRecLoc_Save_URL,
					method : 'POST',
					params : {
						'idstr' : idstr,
						'RecLoc':Ext.getCmp('CopyToRecLocDRF').getValue(),
						'type':Ext.getCmp('TextObjectType').getValue()
					},
					callback : function(options, success, response) {
						Ext.MessageBox.hide();
						if (success) {
							win_CopyToRecLoc.hide()
							var jsonData = Ext.util.JSON.decode(response.responseText);
							
							if (jsonData.success == 'true')
							{
								Ext.Msg.show({
									title : '提示',
									msg : '复制成功！',
									icon : Ext.Msg.INFO,
									buttons : Ext.Msg.OK,
									fn : function(btn){
										grid.getStore().baseParams={
											objecttype : Ext.getCmp("TextObjectType").getValue(),
											RecLoc : Ext.getCmp('TextDesc2').getValue(),
											OrdLoc : Ext.getCmp('TextCode2').getValue(),
											ParRef : Ext.getCmp('TextObjectReference').getValue(),
											hospid:hospComp.getValue()
										};
										grid.getStore().load({params : {start : 0, limit : pagesize_main}});
										
									
									}
								});
							}
							else {
								var errorMsg = '';
								if (jsonData.info) {
									errorMsg = jsonData.info
								}
								Ext.Msg.show({
											title : '提示',
											msg :  errorMsg,
											minWidth : 200,
											icon : Ext.Msg.Info,
											buttons : Ext.Msg.OK,
											fn : function(btn){
												grid.getStore().baseParams={
													objecttype : Ext.getCmp("TextObjectType").getValue(),
													RecLoc : Ext.getCmp('TextDesc2').getValue(),
													OrdLoc : Ext.getCmp('TextCode2').getValue(),
													ParRef : Ext.getCmp('TextObjectReference').getValue(),
													hospid:hospComp.getValue()
												};
												grid.getStore().load({params : {start : 0, limit : pagesize_main}});
											}
								});
							}
						} 
						else {
							Ext.Msg.show({
										title : '提示',
										msg : '异步通讯失败,请检查网络连接！',
										icon : Ext.Msg.ERROR,
										buttons : Ext.Msg.OK
									});
						}
					}
				}, this);
			}
		}, {
			text : '关闭',
			iconCls : 'icon-close',
			handler : function() {
				win_CopyToRecLoc.hide();
			}
		}],
		listeners : {
			"show" : function() {
			},
			"hide" : function() {
				Ext.getCmp("CopyToRecLoc-form-save").getForm().reset()
			},
			"close" : function() {
			}
		}
	});
	
	var btn_CopyToRecLoc = new Ext.Button({
    	id:'btn_CopyToRecLoc',
    	disabled : Ext.BDP.FunLib.Component.DisableFlag('btn_CopyToRecLoc'),
        iconCls:'icon-copy',
        text:'复制到接收科室',
        tooltip:'复制所选数据给某个接收科室。主要用于新增一个接收科室，如新增门诊药房2，把已有门诊药房的病人科室等数据复制给门诊药房2。',
        handler:function(){
        	var gsm = grid.getSelectionModel();//获取选择列
            var rows = gsm.getSelections();//根据选择列获取到所有的行
            if(rows.length==0){
            	Ext.Msg.show({
					title:'提示',
					msg:'请选择一行或多行后复制!',
					icon:Ext.Msg.WARNING,
					buttons:Ext.Msg.OK
				});
            }else{
			 	win_CopyToRecLoc.setIconClass('icon-copy');
            	win_CopyToRecLoc.show();
            }
        }
    })
	
	/****************************复制接收科室到病人科室**完******************************/
	
	// 第二行工具条
	var tbbutton = new Ext.Toolbar({
		enableOverflow : true,
		items : [btn_batchCopy,'-',btn_CopyToOrdLoc,'-',btn_CopyToRecLoc,'->',btnlog,'-',Ext.BDP.FunLib.ImportBtn,'-',Ext.BDP.FunLib.ExportBtn]
		});
	
	// 将工具条放到一起
	var tb =new Ext.Toolbar({
						  items : [ '医院',hospComp,'-','关联表',{
							xtype : "combo",
							shadow:false,
							width:90,
							//fieldLabel : '关联表',
							id :'TextObjectType',
							disabled : Ext.BDP.FunLib.Component.DisableFlag('TextObjectType'),
							store : new Ext.data.JsonStore({
										fields : ['name', 'value'],
										data : [{
													name : '医嘱项',
													value : 'AM'
												}, {
													name : '医嘱大类',
													value : 'OC'
												},{
													name : '医嘱子分类',
													value : 'AC'
												}]
									}),
							mode : 'local',
							queryParam : 'desc',
							forceSelection : true,
							selectOnFocus : false,
							triggerAction : 'all',
							value:'AM',
							//hideTrigger: false,
							displayField : 'name',
							valueField : 'value',
							listeners:{
								'select':function(combo,record,index){
									Ext.getCmp('TextObjectReference').setValue('');
									grid.getStore().baseParams={
										objecttype : Ext.getCmp("TextObjectType").getValue(),
										RecLoc : Ext.getCmp('TextDesc2').getValue(),
										OrdLoc : Ext.getCmp('TextCode2').getValue(),
										ParRef : Ext.getCmp('TextObjectReference').getValue(),
										hospid:hospComp.getValue()
								 	};
									grid.getStore().load({params : {start : 0, limit : pagesize_main}});
								}
							}
						},'关联表数据',{
							xtype : "bdpcombo",
							width:100,
							listWidth : 260,
							pageSize : Ext.BDP.FunLib.PageSize.Combo,
							//fieldLabel : 'ObjectReference',
							id :'TextObjectReference',
							disabled : Ext.BDP.FunLib.Component.DisableFlag('TextObjectReference'),
							store : Referenceds=new Ext.data.Store({
										autoLoad: true,
										proxy : new Ext.data.HttpProxy({ url : GetObjectReference_URL }),
										reader : new Ext.data.JsonReader({
										totalProperty : 'total',
										root : 'data',
										successProperty : 'success'
									}, [{ name:'RowId',mapping:'RowId'},
										{name:'Desc',mapping:'Desc'} ])
								}),
							mode : 'local',
							queryParam : 'desc',
							forceSelection : true,
							selectOnFocus : false,
							//triggerAction : 'all',
							//hideTrigger: false,
							displayField : 'Desc',
							valueField : 'RowId',
							listeners:{
								   'beforequery': function(e){
										this.store.baseParams = {
											  desc:e.query,
												hospid:hospComp.getValue(),
												objecttype:Ext.getCmp('TextObjectType').getValue()

										};
										this.store.load({params : {
													start : 0,
													limit : Ext.BDP.FunLib.PageSize.Combo
										}})
				  				
								 	}
							 }
						},'-',
						'病人科室',{
						  				xtype : 'bdpcombo',
						  				id : 'TextCode2',
						  				width:120,
						  				disabled : Ext.BDP.FunLib.Component.DisableFlag('TextCode2'),
						  				mode : 'remote',
						  				pageSize : Ext.BDP.FunLib.PageSize.Combo,
										listWidth : 250,
										store : new Ext.data.Store({
											//autoLoad : true,
											proxy : new Ext.data.HttpProxy({ url : CTLOC_Group_QUERY_ACTION_URL }),
											reader : new Ext.data.JsonReader({
														totalProperty : 'total',
														root : 'data',
														successProperty : 'success'
													}, [ 'CTLOCRowID', 'CTLOCDesc' ])
										}),
										queryParam : 'desc',
										//triggerAction : 'all',
										forceSelection : true,
										selectOnFocus : false,
										//typeAhead : true,
										//minChars : 1,
										valueField : 'CTLOCRowID',
										displayField : 'CTLOCDesc',
										listeners:{
											   'beforequery': function(e){
													this.store.baseParams = {
															desc:e.query,
															tablename:'ARC_ItmMast',
															hospid:hospComp.getValue()
													};
													this.store.load({params : {
																start : 0,
																limit : Ext.BDP.FunLib.PageSize.Combo
													}})
												
											 	}
										}
						  			}, '-',
									'接收科室',{
										xtype : 'bdpcombo',	
										id : 'TextDesc2',
										width:120,
										disabled : Ext.BDP.FunLib.Component.DisableFlag('TextDesc2'),
										mode : 'local',
										pageSize : Ext.BDP.FunLib.PageSize.Combo,
										listWidth : 250,
										store : new Ext.data.Store({
											//autoLoad : true,
											proxy : new Ext.data.HttpProxy({ url : CTLOC_QUERY_ACTION_URL }),
											reader : new Ext.data.JsonReader({
														totalProperty : 'total',
														root : 'data',
														successProperty : 'success'
													}, [ 'CTLOCRowID', 'CTLOCDesc' ])
										}),
										queryParam : 'desc',
										//triggerAction : 'all',
										forceSelection : true,
										selectOnFocus : false,
										//typeAhead : true,
										//minChars : 1,
										valueField : 'CTLOCRowID',
										displayField : 'CTLOCDesc'
										}, '-',
									new Ext.Button({iconCls : 'icon-search',
													text : '搜索',
													id:'sub_btnResearch',
   													disabled : Ext.BDP.FunLib.Component.DisableFlag('sub_btnResearch'),
													handler : function() {
																grid.getStore().baseParams={
																	objecttype : Ext.getCmp("TextObjectType").getValue(),
																	RecLoc : Ext.getCmp('TextDesc2').getValue(),
																	OrdLoc : Ext.getCmp('TextCode2').getValue(),
																	ParRef : Ext.getCmp('TextObjectReference').getValue(),
																	hospid:hospComp.getValue()
															 	};
																grid.getStore().load({params : {start : 0, limit : pagesize_main}});
															}
													}), '-',
									new Ext.Button({ iconCls : 'icon-refresh',
														text : '重置',
														id:'sub_btnRefresh',
   														disabled : Ext.BDP.FunLib.Component.DisableFlag('sub_btnRefresh'),
														handler : function() {
															Ext.getCmp('TextCode2').reset();
															Ext.getCmp('TextDesc2').reset();
															Ext.getCmp('TextObjectReference').reset();
															grid.getStore().baseParams={
																objecttype : Ext.getCmp("TextObjectType").getValue(),
																hospid:hospComp.getValue()
															};
															grid.getStore().load({ params : { start : 0, limit : pagesize_main } });
														}
													})
									],
								listeners : {
									render : function() {
										tbbutton.render(grid.tbar) // tbar.render(panel.bbar)这个效果在底部
									}
								}
									
						})
	var sm = new Ext.grid.CheckboxSelectionModel({  
		    singleSelect : false,
			//checkOnly : false,
			width : 20,  
		    listeners:{  
		        selectionchange:function(s){ 
		        	 var selectedCount = s.getCount();
		        	 if (selectedCount==0) { 
		        	 	///重新加载后 不会去掉全选的勾  2017-05-08
		             	grid.getEl().select('div.x-grid3-hd-checker').removeClass('x-grid3-hd-checker-on');
		             	
		             }
		        }  
		    }     
		});					
	/** 接收科室child_grid */
	var grid = new Ext.grid.GridPanel({
				id : 'grid',
				region : 'center',
				closable : true,
				store :ds,
				trackMouseOver : true,
				sm : sm, 
				columns : [sm,
						{
							header : 'RLRowId',
							sortable : true,
							dataIndex : 'RLRowId',
							hidden : true
						}, {
							header : 'RLParRef',
							sortable : true,
							dataIndex : 'RLParRef',
							hidden : true	
						}, {
							header : '关联表',
							sortable : true,
							dataIndex : 'ParRefType'
						}, {
							header : '关联表代码',		//update2020-04-10 增加关联表代码一列
							sortable : true,
							dataIndex : 'ARCICCode',
							renderer : Ext.BDP.FunLib.Component.GirdTipShow,
							width : 130
						}, {
							header : '关联表数据',
							sortable : true,
							dataIndex : 'ARCICDesc',
							renderer : Ext.BDP.FunLib.Component.GirdTipShow,
							width : 160
						},{
							header : '病人科室',
							sortable : true,
							dataIndex : 'RLOrdLocDesc',
							renderer : Ext.BDP.FunLib.Component.GirdTipShow,
							width : 160
						}, {
							header : '接收科室',
							sortable : true,
							dataIndex : 'RLRecLocDesc',
							renderer : Ext.BDP.FunLib.Component.GirdTipShow,
							width : 160
						}, {
							header : '功能',
							sortable : true,
							dataIndex : 'RLFunction'
						}, {
							header : '默认',
							sortable : true,
							dataIndex : 'RLDefaultFlag',
							renderer : Ext.BDP.FunLib.Component.ReturnFlagIcon
						}, {
							header : '医院',
							sortable : true,
							dataIndex : 'RLCTHospitalDesc',
							renderer : Ext.BDP.FunLib.Component.GirdTipShow
						}, {
							header : '开始日期',
							sortable : true,
							dataIndex : 'RLDateFrom',
							renderer : Ext.util.Format.dateRenderer(BDPDateFormat)
						}, {
							header : '结束日期',
							sortable : true,
							dataIndex : 'RLDateTo',
							renderer : Ext.util.Format.dateRenderer(BDPDateFormat)
						}, {
							header : '开始时间',
							sortable : true,
							dataIndex : 'RLTimeFrom'
						}, {
							header : '结束时间',
							sortable : true,
							dataIndex : 'RLTimeTo'
						}, {
							header : '医嘱优先级',
							sortable : true,
							dataIndex : 'RLOrderPriorityDesc'
					
							
							
						}, {
							header : '就诊类型',
							sortable : true,
							dataIndex : 'RLClinicType'
					
							
							
						}],
				title : '查询接收科室',
				//iconCls : 'icon-DP',
				//tools:Ext.BDP.FunLib.Component.HelpMsg,
				stripeRows : true,
				//stateful : true,
				viewConfig : {
					forceFit : true
				},
				columnLines : true, //在列分隔处显示分隔符
				
				bbar : paging,
				tbar : tb
			});	

	/** 布局 */
	var viewport = new Ext.Viewport({
				layout : 'border',
				items : [grid],
				listeners: {
		            'afterlayout': function(n) {
		               		
							/** grid加载数据 */
							ds.load({
								params : {
									start : 0,
									limit : pagesize_main,
									hospid:hospComp.getValue(),
									objecttype:"AM"
								},
								callback : function(records, options, success) {
									
								}
							});
								
						
						
		            }
		        }
			});

	
    
});
