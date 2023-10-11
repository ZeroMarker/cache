/// 名称: 通用名字典
/// 描述: 包含增删改查、维护成分功能
/// 编写者: 基础数据平台组-高姗姗
/// 编写日期: 2014-10-30
document.write('<script type="text/javascript" src="../scripts/bdp/Framework/scripts/TreeCombox.js"> </script>');
Ext.onReady(function() {

	Ext.QuickTips.init();
	Ext.form.Field.prototype.msgTarget = 'qtip';
	Ext.BLANK_IMAGE_URL = '../scripts_lib/ext3.2.1/resources/images/default/s.gif';
	
	var QUERY_ACTION_URL = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.KB.DHCPHExtGeneric&pClassQuery=GetList";
	var SAVE_ACTION_URL = "../csp/dhc.bdp.ext.entitydatatrans.csp?pClassName=web.DHCBL.KB.DHCPHExtGeneric&pClassMethod=SaveData&pEntityName=web.Entity.KB.DHCPHExtGeneric";
	var OPEN_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.KB.DHCPHExtGeneric&pClassMethod=OpenData";
	var DELETE_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.KB.DHCPHExtGeneric&pClassMethod=DeleteData";
	var BindingLib="../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.KB.DHCPHLibaryLabel&pClassQuery=GetDataForCmb1";
	var TREE_COMBO_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.KB.DHCPHLibCat&pClassMethod=GetTreeProComboJson";
	var pagesize_main = Ext.BDP.FunLib.PageSize.Main;
	
	///导出Excel文件2016-8-17
function ExcelExport()
{
	Ext.MessageBox.confirm('提示', '确定要导出通用名字典数据吗?', function(btn) {
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
		Ext.MessageBox.wait('正在导出通用名字典数据，请勿刷新或关闭页面，请稍候...','提示');
	
		///BDP功能大表 1
		xlBook.worksheets(1).select(); 
		var xlsheet = xlBook.ActiveSheet; 
		var itemscount=tkMakeServerCall("web.DHCBL.KB.DHCPHExtGeneric","GetItemsCount");
	
		xlsheet.name="通用名字典";  //sheet的表名
		
		xlsheet.cells(1,1)="通用名表_User.DHCPHExtGeneric";
		
		xlsheet.cells(2,1)="代码";
		xlsheet.cells(2,2)="描述";
		
		xlsheet.cells(3,1)="PHEGCode";
		xlsheet.cells(3,2)="PHEGDesc";

		//obj.value.split("/")[2]
		for (var i=1;i<=itemscount;i++){
			var DataDetailStr=tkMakeServerCall("web.DHCBL.KB.DHCPHExtGeneric","GetItemInfo",i);
			var Detail=DataDetailStr.split("#");
			for (var j=1;j<=2;j++){
				xlsheet.cells(3+i,j)=Detail[j-1];
			}
		}
		Ext.MessageBox.hide();
	
		xlApp.Visible=true;
		//xlApp.Save();
		//xlsheet.SaveAs(path);   //xlsheet.SaveAs(path);  
		//xlsheet.PrintPreview();
		//xlsheet2.SaveAs(path);      

		Ext.Msg.show({
			title : '提示',
			msg : '导出完成!',
			icon : Ext.Msg.INFO,
			buttons : Ext.Msg.OK,
			fn : function(btn) {
				xlBook.Close(savechanges=true);
				xlApp.Quit();
				CollectGarbage();
				xlApp=null;
				xlsheet=null;
				xlsheet2=null;
			}
		});
	
	//var ExTimeOBJ=new Date();
	//var ExTime=ExTimeOBJ.toLocaleString();
	//var ExTime=ExTime.replace(/\s/ig,'');
	
	//var month=ExTimeOBJ.getMonth()+1;       //获取当前月份(0-11,0代表1月)
	//var date=ExTimeOBJ.getDate();        //获取当前日(1-31)
	//var hour=ExTimeOBJ.getHours();       //获取当前小时数(0-23)
	//var minute=ExTimeOBJ.getMinutes();     //获取当前分钟数(0-59)
	//var sec=ExTimeOBJ.getSeconds();     //获取当前秒数(0-59)
	//var ExTime=month+"月"+date+"日"+hour+"时"+minute+"分"+sec+"秒"

}
}, this);
	
}

   var exportBtn = new Ext.Toolbar.Button({
		text : '导出',
		tooltip : '导出',
		id:'export_btn',
		//hidden:true,
		disabled : Ext.BDP.FunLib.Component.DisableFlag('export_btn'),
		iconCls : 'icon-export',
		handler : function() {
			ExcelExport()
		}
	});		
	/************************通用名别名维护*************************************/
	var btnAlias = new Ext.Toolbar.Button({
			text : '别名维护',
			tooltip : '别名维护',
			iconCls : 'icon-DP',
			id : 'btnAlias',
			disabled : Ext.BDP.FunLib.Component.DisableFlag('btnAlias'),
	      	handler: function ConAlias() {			        
				var records =  grid.selModel.getSelections();
				var recordsLen= records.length;
				if(recordsLen == 0){
					Ext.Msg.show({
						title:'提示',
						minWidth:200,
						msg:'请选择一行进行维护!',
						icon:Ext.Msg.WARNING,
						buttons:Ext.Msg.OK
					});	
				  }
				 else{
				        var gsm = grid.getSelectionModel();// 获取选择列
					    var rows = gsm.getSelections();// 根据选择列获取到所有的行
					    var itemdesc=rows[0].get('PHEGDesc');
					    var itemRowId=rows[0].get('PHEGRowId')
	                	var link="dhc.bdp.ext.default.csp?extfilename=App/KB/Dic/DHC_PHExtGenericAlias&selectrow="+itemRowId; 
	                	/** 特殊人群与检验指标关联窗口 */
						var windowAlias = new Ext.Window({
										iconCls : 'icon-DP',
										width : 900,
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
										html : ''
									});
						windowAlias.html='<iframe id="ifrmalias" src=" '+link+' " width="100%" height="100%"></iframe>';
						windowAlias.setTitle(itemdesc);
						windowAlias.show();
				}
	      }	
    });
	/************************通用名药品属性维护*************************************/
	var btnPro = new Ext.Toolbar.Button({
			text : '药品属性',
			tooltip : '药品属性',
			iconCls : 'icon-DP',
			id : 'btnPro',
			disabled : Ext.BDP.FunLib.Component.DisableFlag('btnPro'),
	      	handler: function ConPro() {			        
				var records =  grid.selModel.getSelections();
				var recordsLen= records.length;
				if(recordsLen == 0){
					Ext.Msg.show({
						title:'提示',
						minWidth:200,
						msg:'请选择一行进行维护!',
						icon:Ext.Msg.WARNING,
						buttons:Ext.Msg.OK
					});	
				  }
				 else{
				        var gsm = grid.getSelectionModel();// 获取选择列
					    var rows = gsm.getSelections();// 根据选择列获取到所有的行
					    var itemdesc=rows[0].get('PHEGDesc');
					    var itemRowId=rows[0].get('PHEGRowId')
	                	var link="dhc.bdp.ext.default.csp?extfilename=App/KB/Dic/DHC_PHExtGenericPro&selectrow="+itemRowId; 
	                	/** 特殊人群与检验指标关联窗口 */
						var windowPro = new Ext.Window({
										iconCls : 'icon-DP',
										width : 900,
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
										html : ''
									});
						windowPro.html='<iframe id="ifrmalias" src=" '+link+' " width="100%" height="100%"></iframe>';
						windowPro.setTitle(itemdesc);
						windowPro.show();
				}
	      }	
    });
	/************************通用名检验属性维护*************************************/
	var btnLPro = new Ext.Toolbar.Button({
			text : '检验属性',
			tooltip : '检验属性',
			iconCls : 'icon-DP',
			id : 'btnLPro',
			disabled : Ext.BDP.FunLib.Component.DisableFlag('btnLPro'),
	      	handler: function ConLPro() {			        
				var records =  grid.selModel.getSelections();
				var recordsLen= records.length;
				if(recordsLen == 0){
					Ext.Msg.show({
						title:'提示',
						minWidth:200,
						msg:'请选择一行进行维护!',
						icon:Ext.Msg.WARNING,
						buttons:Ext.Msg.OK
					});	
				  }
				 else{
				        var gsm = grid.getSelectionModel();// 获取选择列
					    var rows = gsm.getSelections();// 根据选择列获取到所有的行
					    var itemdesc=rows[0].get('PHEGDesc');
					    var itemRowId=rows[0].get('PHEGRowId')
	                	var link="dhc.bdp.ext.default.csp?extfilename=App/KB/Dic/DHC_PHExtGenericLPro&selectrow="+itemRowId; 
	                	/** 特殊人群与检验指标关联窗口 */
						var windowLPro = new Ext.Window({
										iconCls : 'icon-DP',
										width : 900,
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
										html : ''
									});
						windowLPro.html='<iframe id="ifrmalias" src=" '+link+' " width="100%" height="100%"></iframe>';
						windowLPro.setTitle(itemdesc);
						windowLPro.show();
				}
	      }	
    });
	/************************通用名关联剂型维护*************************************/
	var btnLink = new Ext.Toolbar.Button({
			text : '关联剂型',
			tooltip : '关联剂型',
			iconCls : 'icon-DP',
			id : 'btnLink',
			disabled : Ext.BDP.FunLib.Component.DisableFlag('btnLink'),
	      	handler: function ConLink() {			        
				var records =  grid.selModel.getSelections();
				var recordsLen= records.length;
				if(recordsLen == 0){
					Ext.Msg.show({
						title:'提示',
						minWidth:200,
						msg:'请选择一行进行维护!',
						icon:Ext.Msg.WARNING,
						buttons:Ext.Msg.OK
					});	
				  }
				 else{
				        var gsm = grid.getSelectionModel();// 获取选择列
					    var rows = gsm.getSelections();// 根据选择列获取到所有的行
					    var itemdesc=rows[0].get('PHEGDesc');
					    var itemRowId=rows[0].get('PHEGRowId')
	                	var link="dhc.bdp.ext.default.csp?extfilename=App/KB/Dic/DHC_PHExtGenericLink&selectrow="+itemRowId; 
	                	/** 特殊人群与检验指标关联窗口 */
						var windowLink= new Ext.Window({
										iconCls : 'icon-DP',
										width : 900,
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
										html : ''
									});
						windowLink.html='<iframe id="ifrmalias" src=" '+link+' " width="100%" height="100%"></iframe>';
						windowLink.setTitle(itemdesc);
						windowLink.show();
				}
	      }	
    });
	/************************通用名成分明细维护*************************************/
	var btnIngr= new Ext.Toolbar.Button({
			text : '成分明细',
			tooltip : '成分明细',
			iconCls : 'icon-DP',
			id : 'btnIngr',
			disabled : Ext.BDP.FunLib.Component.DisableFlag('btnIngr'),
	      	handler: function ConIngr() {			        
				var records =  grid.selModel.getSelections();
				var recordsLen= records.length;
				if(recordsLen == 0){
					Ext.Msg.show({
						title:'提示',
						minWidth:200,
						msg:'请选择一行进行维护!',
						icon:Ext.Msg.WARNING,
						buttons:Ext.Msg.OK
					});	
				  }
				 else{
				        var gsm = grid.getSelectionModel();// 获取选择列
					    var rows = gsm.getSelections();// 根据选择列获取到所有的行
					    var itemdesc=rows[0].get('PHEGDesc');
					    var itemRowId=rows[0].get('PHEGRowId')
	                	var link="dhc.bdp.ext.default.csp?extfilename=App/KB/Dic/DHC_PHExtGenericIngr&selectrow="+itemRowId; 
	                	/** 特殊人群与检验指标关联窗口 */
						var windowIngr= new Ext.Window({
										iconCls : 'icon-DP',
										width : 900,
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
										html : ''
									});
						windowIngr.html='<iframe id="ifrmalias" src=" '+link+' " width="100%" height="100%"></iframe>';
						windowIngr.setTitle(itemdesc);
						windowIngr.show();
				}
	      }	
    });
    /************************通用名关联标本维护*************************************/
	var btnLis= new Ext.Toolbar.Button({
			text : '关联标本',
			tooltip : '关联标本',
			iconCls : 'icon-DP',
			id : 'btnLis',
			disabled : Ext.BDP.FunLib.Component.DisableFlag('btnLis'),
	      	handler: function ConLis() {			        
				var records =  grid.selModel.getSelections();
				var recordsLen= records.length;
				if(recordsLen == 0){
					Ext.Msg.show({
						title:'提示',
						minWidth:200,
						msg:'请选择一行进行维护!',
						icon:Ext.Msg.WARNING,
						buttons:Ext.Msg.OK
					});	
				  }
				 else{
				        var gsm = grid.getSelectionModel();// 获取选择列
					    var rows = gsm.getSelections();// 根据选择列获取到所有的行
					    var itemdesc=rows[0].get('PHEGDesc');
					    var itemRowId=rows[0].get('PHEGRowId')
	                	var link="dhc.bdp.ext.default.csp?extfilename=App/KB/Dic/DHC_PHExtGenericLis&selectrow="+itemRowId; 
	                	/** 特殊人群与检验指标关联窗口 */
						var windowLis= new Ext.Window({
										iconCls : 'icon-DP',
										width : 900,
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
										html : ''
									});
						windowLis.html='<iframe id="ifrmalias" src=" '+link+' " width="100%" height="100%"></iframe>';
						windowLis.setTitle(itemdesc);
						windowLis.show();
				}
	      }	
    });
    /************************通用名关联部位维护*************************************/
	var btnPart= new Ext.Toolbar.Button({
			text : '关联部位',
			tooltip : '关联部位',
			iconCls : 'icon-DP',
			id : 'btnPart',
			disabled : Ext.BDP.FunLib.Component.DisableFlag('btnPart'),
	      	handler: function ConPart() {			        
				var records =  grid.selModel.getSelections();
				var recordsLen= records.length;
				if(recordsLen == 0){
					Ext.Msg.show({
						title:'提示',
						minWidth:200,
						msg:'请选择一行进行维护!',
						icon:Ext.Msg.WARNING,
						buttons:Ext.Msg.OK
					});	
				  }
				 else{
				        var gsm = grid.getSelectionModel();// 获取选择列
					    var rows = gsm.getSelections();// 根据选择列获取到所有的行
					    var itemdesc=rows[0].get('PHEGDesc');
					    var itemRowId=rows[0].get('PHEGRowId');
					    var lib=rows[0].get('PHLICode');
	                	var link="dhc.bdp.ext.default.csp?extfilename=App/KB/Dic/DHC_PHExtGenericPart&selectrow="+itemRowId+"&lib="+lib; 
	                	/** 特殊人群与检验指标关联窗口 */
						var windowPart= new Ext.Window({
										iconCls : 'icon-DP',
										width : 900,
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
										html : ''
									});
						windowPart.html='<iframe id="ifrmalias" src=" '+link+' " width="100%" height="100%"></iframe>';
						windowPart.setTitle(itemdesc);
						windowPart.show();
				}
	      }	
    });
    /************************通用名标本采集注意事项维护*************************************/
	var btnCare= new Ext.Toolbar.Button({
			text : '标本采集注意事项',
			tooltip : '标本采集注意事项',
			iconCls : 'icon-DP',
			id : 'btnCare',
			disabled : Ext.BDP.FunLib.Component.DisableFlag('btnCare'),
	      	handler: function ConCare() {			        
				var records =  grid.selModel.getSelections();
				var recordsLen= records.length;
				if(recordsLen == 0){
					Ext.Msg.show({
						title:'提示',
						minWidth:200,
						msg:'请选择一行进行维护!',
						icon:Ext.Msg.WARNING,
						buttons:Ext.Msg.OK
					});	
				  }
				 else{
				        var gsm = grid.getSelectionModel();// 获取选择列
					    var rows = gsm.getSelections();// 根据选择列获取到所有的行
					    var itemdesc=rows[0].get('PHEGDesc');
					    var itemRowId=rows[0].get('PHEGRowId');
	                	var link="dhc.bdp.ext.default.csp?extfilename=App/KB/Dic/DHC_PHExtGenericCare&selectrow="+itemRowId; 
	                	/** 特殊人群与检验指标关联窗口 */
						var windowCare= new Ext.Window({
										iconCls : 'icon-DP',
										width : 900,
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
										html : ''
									});
						windowCare.html='<iframe id="ifrmalias" src=" '+link+' " width="100%" height="100%"></iframe>';
						windowCare.setTitle(itemdesc);
						windowCare.show();
				}
	      }	
    });
	
	/** 删除按钮 */
	var btnDel = new Ext.Toolbar.Button({
		text : '删除',
		tooltip : '请选择一行后删除(Shift+D)',
		iconCls : 'icon-delete',
		id:'del_btn',
   		disabled : Ext.BDP.FunLib.Component.DisableFlag('del_btn'),
		handler : DelData=function () {
			if (grid.selModel.hasSelection()) {
				Ext.MessageBox.confirm('提示', '确定要删除所选的数据吗?', function(btn) {
					if (btn == 'yes') {
					//	Ext.MessageBox.wait('数据删除中,请稍候...', '提示');
						var gsm = grid.getSelectionModel();// 获取选择列
						var rows = gsm.getSelections();// 根据选择列获取到所有的行
						
						Ext.Ajax.request({
							url : DELETE_ACTION_URL,
							method : 'POST',
							params : {
								'id' : rows[0].get('PHEGRowId')
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
															Ext.getCmp('btnPro').enable();
															Ext.getCmp('btnLPro').enable();
													 		Ext.getCmp('btnLink').enable();
													 		Ext.getCmp('btnIngr').enable();
													 		Ext.getCmp('btnLis').enable();
													 		Ext.getCmp('btnPart').enable();
													 		Ext.getCmp('btnCare').enable();
															
															var startIndex = grid.getBottomToolbar().cursor;
															var totalnum=grid.getStore().getTotalCount();
															if(totalnum==1){   //修改添加后只有一条，返回第一页
																var startIndex=0
															}
															else if((totalnum-1)%pagesize_main==0)//最后一页只有一条
															{
																var pagenum=grid.getStore().getCount();
																if (pagenum==1){ startIndex=startIndex-pagesize_main;}  //最后一页的时候,不是最后一页则还停留在这一页
															}
															grid.getStore().load({
																params : {
																			start : startIndex,
																			limit : pagesize_main
																		}
																	});
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
	/** 创建Form表单 */
	var WinForm = new Ext.form.FormPanel({
				id : 'form-save',
				labelAlign : 'right',
				labelWidth : 90,
				title : '基本信息',
				frame : true,
        		reader: new Ext.data.JsonReader({root:'data'},
                        [{name: 'PHEGRowId',mapping:'PHEGRowId',type:'string'},
                         {name: 'PHEGCode',mapping:'PHEGCode',type:'string'},
                         {name: 'PHEGDesc',mapping:'PHEGDesc',type:'string'},
                         {name: 'PHEGActiveFlag',mapping:'PHEGActiveFlag',type:'string'},
                         {name: 'PHEGLibDr',mapping:'PHEGLibDr',type:'string'},
                         {name: 'PHEGSysFlag',mapping:'PHEGSysFlag',type:'string'}
                   ]),
				defaults : {
					anchor : '92%',
					border : false
				},
				defaultType : 'textfield',
				items : [{
							fieldLabel : 'PHEGRowId',
							hideLabel : 'True',
							hidden : true,
							name : 'PHEGRowId'
						}, {
							fieldLabel : '<font color=red>*</font>代码',
							name : 'PHEGCode',
							id:'PHEGCodeF',
   							readOnly : Ext.BDP.FunLib.Component.DisableFlag('PHEGCodeF'),
   							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('PHEGCodeF')),
							allowBlank : false,
							blankText : '代码不能为空',
							validationEvent : 'blur',  
                            validator : function(thisText){
	                            if(thisText==""){  //当文本框里的内容为空的时候不用此验证
	                            	return true;
	                            }
	                            var className =  "web.DHCBL.KB.DHCPHExtGeneric";  //后台类名称
	                            var classMethod = "FormValidate"; //数据重复验证后台函数名	                            
	                            var id="";
	                            if(win.title=='修改'){ // 如果窗口标题为"修改",则获取rowid
	                            	var _record = grid.getSelectionModel().getSelected();
	                            	var id = _record.get('PHEGRowId'); //此条数据的rowid
	                            }
	                            var flag = "";
	                            var flag = tkMakeServerCall(className,classMethod,id,thisText,"");//用tkMakeServerCall函数实现与后台同步调用交互
	                            if(flag == "1"){  //当后台返回数据位"1"时转换为相应的bool值
	                             	return false;
	                             }else{
	                             	return true;
	                             }
                            },
                            invalidText : '该代码已经存在',
						    listeners : {
            			        'change' : Ext.BDP.FunLib.Component.ReturnValidResult
						    }
						}, {
							fieldLabel : '<font color=red>*</font>描述',
							name : 'PHEGDesc',
							id:'PHEGDescF',
   							readOnly : Ext.BDP.FunLib.Component.DisableFlag('PHEGDescF'),
   							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('PHEGDescF')),
							allowBlank : false,
							blankText : '描述不能为空',
							validationEvent : 'blur',
                            validator : function(thisText){
	                            if(thisText==""){ //当文本框里的内容为空的时候不用此验证
	                            	return true;
	                            }
	                            var className =  "web.DHCBL.KB.DHCPHExtGeneric"; //后台类名称
	                            var classMethod = "FormValidate"; //数据重复验证后台函数名
	                            var id="";
	                            if(win.title=='修改'){ // 如果窗口标题为"修改",则获取rowid
	                            	var _record = grid.getSelectionModel().getSelected();
	                            	var id = _record.get('PHEGRowId'); //此条数据的rowid
	                            }
	                            var flag = "";
	                            var flag = tkMakeServerCall(className,classMethod,id,"",thisText);//用tkMakeServerCall函数实现与后台同步调用交互
	                            if(flag == "1"){  //当后台返回数据位"1"时转换为相应的bool值
	                             	return false;
	                             }else{
	                             	return true;
	                             }
                            },
                            invalidText : '该描述已经存在',
						    listeners : {
            			        'change' : Ext.BDP.FunLib.Component.ReturnValidResult
						    }
						}, {
							xtype : 'combo',
							fieldLabel : '<font color=red>*</font>知识库标识',
							name : 'PHEGLibDr',
							id:'PHEGLibDrF',
							hiddenName:'PHEGLibDr',
   							readOnly : Ext.BDP.FunLib.Component.DisableFlag('PHEGLibDrF'),
   							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('PHEGLibDrF')),
							triggerAction : 'all',// query
							forceSelection : true,
							selectOnFocus : false,
							typeAhead : true,
							queryParam : "desc",
							mode : 'remote',
							pageSize : Ext.BDP.FunLib.PageSize.Combo,
							minChars : 0,
							listWidth : 250,
							blankText : '知识库标识不能为空',
							allowBlank : false,
							valueField : 'PHLIRowId',
							displayField : 'PHLIDesc',
							store : new Ext.data.JsonStore({
								autoLoad : true,
								url : BindingLib,
								root : 'data',
								totalProperty : 'total',
								idProperty : 'PHLIRowId',
								fields : ['PHLIRowId', 'PHLIDesc'],
								remoteSort : true,
								sortInfo : {
									field : 'PHLIRowId',
									direction : 'ASC'
								}
							}),
							validationEvent : 'blur',
                            validator : function(thisText){
	                           if(win.title=='修改'){  
		                            var className =  "web.DHCBL.KB.DHCPHExtGeneric"; //后台类名称
		                            var classMethod = "ValidateLib"; //知识库标识引用验证后台函数名
		                            var _record = grid.getSelectionModel().getSelected();
		                            var id = _record.get('PHEGRowId'); //此条数据的rowid
		                           
		                            var flag = "";
		                            var flag = tkMakeServerCall(className,classMethod,id);//用tkMakeServerCall函数实现与后台同步调用交互
		                            if((flag == "1")&&(Ext.getCmp("PHEGLibDrF").getValue()!=grid.getSelectionModel().getSelections()[0].get("PHEGLibDr"))){  //当后台返回数据位"1"时转换为相应的bool值
										return false;		                             	
		                             }else{
		                             	return true;
		                             }
	                            }
                            },
                            invalidText : '该记录被引用,不可修改知识库标识',
						    listeners : {
            			        'change' : Ext.BDP.FunLib.Component.ReturnValidResult
						    }
						}, {
							xtype : 'checkbox',
							fieldLabel : '是否可用',
							name : 'PHEGActiveFlag',
							id:'PHEGActiveFlagF',
   							readOnly : Ext.BDP.FunLib.Component.DisableFlag('PHEGActiveFlagF'),
   							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('PHEGActiveFlagF')),
							checked:true,
							inputValue : true ? 'Y' : 'N'
							
						}, {
							xtype : 'checkbox',
							fieldLabel : '是否系统标识',
							name : 'PHEGSysFlag',
							id:'PHEGSysFlagF',
   							readOnly : Ext.BDP.FunLib.Component.DisableFlag('PHEGSysFlagF'),
   							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('PHEGSysFlagF')),
							checked:true,
							inputValue : true ? 'Y' : 'N'
						}]
			});
	
	/** 增加修改时弹出窗口 */
	var win = new Ext.Window({
		width : 330,
		height : 320,
		layout : 'fit',
		plain : true,// true则主体背景透明
		modal : true,
		frame : true,
		autoScroll : true,
		collapsible : true,
		constrain : true,
		hideCollapseTool : true,
		titleCollapse : true,
		bodyStyle : 'padding:3px',
		buttonAlign : 'center',
		closeAction : 'hide',
		items : WinForm,
		buttons : [{
			text : '保存',
			id:'save_btn',
			iconCls : 'icon-save',
   			disabled : Ext.BDP.FunLib.Component.DisableFlag('save_btn'),
			handler : function() {
				var tempCode = Ext.getCmp("PHEGCodeF").getValue();
				var tempDesc = Ext.getCmp("PHEGDescF").getValue();
				var tempLib = Ext.getCmp("PHEGLibDrF").getValue();
				if (tempCode=="") {
    				Ext.Msg.show({ title : '提示', msg : '代码不能为空!', minWidth : 200, icon : Ext.Msg.ERROR, buttons : Ext.Msg.OK });
          			return;
    			}
    			if (tempDesc=="") {
    				Ext.Msg.show({ title : '提示', msg : '描述不能为空!', minWidth : 200, icon : Ext.Msg.ERROR, buttons : Ext.Msg.OK });
          			return;
    			}
    			if (tempLib=="") {
    				Ext.Msg.show({ title : '提示', msg : '知识库标识不能为空!', minWidth : 200, icon : Ext.Msg.ERROR, buttons : Ext.Msg.OK });
          			return;
    			}
    			if(WinForm.form.isValid()==false){return;}
				if (win.title == "添加") {
					WinForm.form.submit({
						clientValidation : true, // 进行客户端验证
						waitTitle : '提示',
						url : SAVE_ACTION_URL,
						method : 'POST',
						success : function(form, action) {
							if (action.result.success == 'true') {
								win.hide();
								var myrowid = action.result.id;
								// var myrowid = jsonData.id;
								Ext.Msg.show({
											title : '提示',
											msg : '添加成功!',
											icon : Ext.Msg.INFO,
											buttons : Ext.Msg.OK,
											fn : function(btn) {
												Ext.getCmp('btnPro').enable();
												Ext.getCmp('btnLPro').enable();
										 		Ext.getCmp('btnLink').enable();
										 		Ext.getCmp('btnIngr').enable();
										 		Ext.getCmp('btnLis').enable();
										 		Ext.getCmp('btnPart').enable();
										 		Ext.getCmp('btnCare').enable();
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
					})
				} else {
					Ext.MessageBox.confirm('提示', '确定要修改该条数据吗?', function(btn) {
						if (btn == 'yes') {
							WinForm.form.submit({
								clientValidation : true, // 进行客户端验证
								waitTitle : '提示',
								url : SAVE_ACTION_URL,
								method : 'POST',
								success : function(form, action) {
									if (action.result.success == 'true') {
										win.hide();
										//var myrowid = "rowid=" + action.result.id;
										var myrowid = action.result.id;
										Ext.Msg.show({
														title : '提示',
														msg : '修改成功!',
														icon : Ext.Msg.INFO,
														buttons : Ext.Msg.OK,
														fn : function(btn) {
															
															Ext.getCmp('btnPro').enable();
															Ext.getCmp('btnLPro').enable();
													 		Ext.getCmp('btnLink').enable();
													 		Ext.getCmp('btnIngr').enable();
													 		Ext.getCmp('btnLis').enable();
													 		Ext.getCmp('btnPart').enable();
													 		Ext.getCmp('btnCare').enable();
															//Ext.BDP.FunLib.ReturnDataForUpdate("grid", QUERY_ACTION_URL, myrowid)
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
		},{
			text:'继续添加',
			id:'add_btn',
			iconCls : 'icon-save',
			handler:function(){
				var tempCode = Ext.getCmp("PHEGCodeF").getValue();
				var tempDesc = Ext.getCmp("PHEGDescF").getValue();
				var tempLib = Ext.getCmp("PHEGLibDrF").getValue();
				if (tempCode=="") {
    				Ext.Msg.show({ title : '提示', msg : '代码不能为空!', minWidth : 200, icon : Ext.Msg.ERROR, buttons : Ext.Msg.OK });
          			return;
    			}
    			if (tempDesc=="") {
    				Ext.Msg.show({ title : '提示', msg : '描述不能为空!', minWidth : 200, icon : Ext.Msg.ERROR, buttons : Ext.Msg.OK });
          			return;
    			}
    			if (tempLib=="") {
    				Ext.Msg.show({ title : '提示', msg : '知识库标识不能为空!', minWidth : 200, icon : Ext.Msg.ERROR, buttons : Ext.Msg.OK });
          			return;
    			}
    			if(WinForm.form.isValid()==false){return;}
				if (win.title == "添加") {
					WinForm.form.submit({
						clientValidation : true, // 进行客户端验证
						waitTitle : '提示',
						url : SAVE_ACTION_URL,
						method : 'POST',
						success : function(form, action) {
							if (action.result.success == 'true') {
								Ext.getCmp('btnPro').enable();
								Ext.getCmp('btnLPro').enable();
						 		Ext.getCmp('btnLink').enable();
						 		Ext.getCmp('btnIngr').enable();
						 		Ext.getCmp('btnLis').enable();
						 		Ext.getCmp('btnPart').enable();
						 		Ext.getCmp('btnCare').enable();
								Ext.getCmp("form-save").getForm().reset();

								Ext.BDP.FunLib.Component.FromHideClearFlag;
								var myrowid = action.result.id;
								Ext.getCmp("form-save").getForm().reset();
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
					})
				} else {
					WinForm.form.submit({
						clientValidation : true, // 进行客户端验证
						waitTitle : '提示',
						url : SAVE_ACTION_URL,
						method : 'POST',
						params:{
							'PHEGRowId':""
						},
						success : function(form, action) {
							if (action.result.success == 'true') {
								Ext.getCmp('btnPro').enable();
								Ext.getCmp('btnLPro').enable();
						 		Ext.getCmp('btnLink').enable();
						 		Ext.getCmp('btnIngr').enable();
						 		Ext.getCmp('btnLis').enable();
						 		Ext.getCmp('btnPart').enable();
						 		Ext.getCmp('btnCare').enable();
								Ext.getCmp("form-save").getForm().reset();
								
								var totalnum=grid.getStore().getTotalCount();
								grid.getStore().load({
									params : {
												start : totalnum,
												limit : pagesize_main
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
			}
		}, {
			text : '关闭',
			iconCls : 'icon-close',
			handler : function() {
				win.hide();
			}
		}],
		listeners : {
			"show" : function() {
				Ext.getCmp("form-save").getForm().findField("PHEGCode").focus(true,800);
				if(win.title == "修改"){
					win.buttons[1].hide();
				}else{
					win.buttons[1].show();
				}
			},
			"hide" : Ext.BDP.FunLib.Component.FromHideClearFlag,
			"close" : function() {}
		}
	});
	/** 添加按钮 */
	var btnAddwin = new Ext.Toolbar.Button({
				text : '添加',
				tooltip : '添加一条数据(Shift+A)',
				iconCls : 'icon-add',
				id:'add_btn',
   				disabled : Ext.BDP.FunLib.Component.DisableFlag('add_btn'),
				handler : AddData=function () {
					win.setTitle('添加');
					win.setIconClass('icon-add');
					win.show('new1');
					//WinForm.getForm().reset();
					Ext.getCmp("form-save").getForm().reset();
				},
				scope : this
			});
	/** 修改按钮 */
	var btnEditwin = new Ext.Toolbar.Button({
				text : '修改',
				tooltip : '请选择一行后修改(Shift+U)',
				iconCls : 'icon-update',
				id:'update_btn',
  		 		disabled : Ext.BDP.FunLib.Component.DisableFlag('update_btn'),
				handler : UpdateData=function () {
					var _record = grid.getSelectionModel().getSelected();
					if (!_record) {
			            Ext.Msg.show({
							title : '提示',
							msg : '请选择需要修改的行!',
							icon : Ext.Msg.WARNING,
							buttons : Ext.Msg.OK
						});
			        } else {
			            win.setTitle('修改');
						win.setIconClass('icon-update');
						win.show('');
						Ext.getCmp("form-save").getForm().reset();
			            Ext.getCmp("form-save").getForm().load({
			                url : OPEN_ACTION_URL + '&id=' + _record.get('PHEGRowId'),
			                success : function(form,action) {
			                },
			                failure : function(form,action) {
			                	Ext.Msg.alert('编辑', '载入失败');
			                }
			            });
			        }
				}
			});
	/** grid数据存储 */
	var ds = new Ext.data.Store({
				proxy : new Ext.data.HttpProxy({ url : QUERY_ACTION_URL }),// 调用的动作
				reader : new Ext.data.JsonReader({
							totalProperty : 'total',
							root : 'data',
							successProperty : 'success'
						}, [{
									name : 'PHEGRowId',
									mapping : 'PHEGRowId',
									type : 'string'
								}, {
									name : 'PHEGCode',
									mapping : 'PHEGCode',
									type : 'string'
								}, {
									name : 'PHEGDesc',
									mapping : 'PHEGDesc',
									type : 'string'
								}, {
									name : 'PHLICode',
									mapping : 'PHLICode',
									type : 'string'
								}, {
									name : 'PHLIDesc',
									mapping : 'PHLIDesc',
									type : 'string'
								}, {
									name : 'PHEGLibDr',
									mapping : 'PHEGLibDr',
									type : 'string'
								}, {
									name : 'PHICStr',
									mapping : 'PHICStr',
									type : 'string'
								}, {
									name : 'PHEINGStr',
									mapping : 'PHEINGStr',
									type : 'string'
								}, {
									name : 'PHEGActiveFlag',
									mapping : 'PHEGActiveFlag',
									type : 'string'
								}, {
									name : 'PHEGSysFlag',
									mapping : 'PHEGSysFlag',
									type : 'string'
								}, {
									name : 'PHEGDataPool',
									mapping : 'PHEGDataPool',
									type : 'string'
								}
						])
			});
	/** grid数据加载遮罩 */
	var loadMarsk = new Ext.LoadMask(document.body,{
						disabled : false,
						store : ds
					});
	/** grid加载数据 */
	ds.load({
		params : {
					start : 0,
					limit : pagesize_main
				},
				callback : function(records, options, success) {
				}
			});
	/** grid分页工具条 */
	var paging = new Ext.PagingToolbar({
				pageSize : pagesize_main,
				store : ds,
				displayInfo : true,
				displayMsg : '显示第 {0} 条到 {1} 条记录,一共 {2} 条',
				emptyMsg : "没有记录",
				plugins : [new Ext.BDP.FunLib.PagingToolbarResizer()],
				listeners : {
					"change":function (t,p) {
						pagesize_main=this.pageSize;
					}
				}
			});
	/** 增删改工具条 */
	var tbbutton = new Ext.Toolbar({
			enableOverflow : true,
			items : [btnAddwin, '-', btnEditwin, '-', btnDel,'-',btnAlias,'-',btnPro,'-',btnLPro,'-',btnLink,'-',btnLis,'-',btnPart,'-',btnIngr,'-',btnCare]
		});
	/** 搜索按钮 */
	var btnSearch = new Ext.Button({
				id : 'btnSearch',
				disabled : Ext.BDP.FunLib.Component.DisableFlag('btnSearch'),
				iconCls : 'icon-search',
				text : '搜索',
				handler : function() {
					Ext.getCmp('btnPro').enable();
					Ext.getCmp('btnLPro').enable();
			 		Ext.getCmp('btnLink').enable();
			 		Ext.getCmp('btnIngr').enable();
			 		Ext.getCmp('btnLis').enable();
			 		Ext.getCmp('btnPart').enable();
			 		Ext.getCmp('btnCare').enable();
					grid.getStore().baseParams={			
							code : Ext.getCmp("PHEGCode").getValue(),
							desc : Ext.getCmp("PHEGDesc").getValue(),
							lib : Ext.getCmp("PHEGLibDr").getValue(),
							cat : Ext.getCmp("treeCombox").getValue()
					};
					grid.getStore().load({
						params : {
									start : 0,
									limit : pagesize_main
								}
						});
				}
			});
	/** 重置按钮 */
	var btnRefresh = new Ext.Button({
				id : 'btnRefresh',
				iconCls : 'icon-refresh',
				text : '重置',
				disabled : Ext.BDP.FunLib.Component.DisableFlag('btnRefresh'),
				handler : function Refresh() {
					Ext.getCmp('btnPro').enable();
					Ext.getCmp('btnLPro').enable();
			 		Ext.getCmp('btnLink').enable();
			 		Ext.getCmp('btnIngr').enable();
			 		Ext.getCmp('btnLis').enable();
			 		Ext.getCmp('btnPart').enable();
			 		Ext.getCmp('btnCare').enable();
					
					Ext.getCmp("PHEGCode").reset();
					Ext.getCmp("PHEGDesc").reset();
					Ext.getCmp("PHEGLibDr").reset();
					Ext.getCmp("treeCombox").reset();
					grid.getStore().baseParams={};
					grid.getStore().load({
						params : {
									start : 0,
									limit : pagesize_main
								}
						});
				}
			});

	var comboTreeLoader = new Ext.tree.TreeLoader({
		nodeParameter: "ParentID",
		dataUrl: TREE_COMBO_URL
	});
	comboTreeLoader.on("beforeload", function(treeLoader, node) {  
		comboTreeLoader.baseParams.lib = "DRUG";
    }, this);
	var treeCombox = new Ext.ux.TreeCombo({  
			 id : 'treeCombox',
             width : 180,  
             disabled : Ext.BDP.FunLib.Component.DisableFlag('treeCombox'),
             hiddenName : 'treeCombox',  
             root : new Ext.tree.AsyncTreeNode({  
             			id:"CatTreeRoot",
						expanded:true  //根节点自动展开  
                     }),  
             loader: comboTreeLoader,
             autoScroll: true,
			 containerScroll: true,
			 rootVisible:false
         });  
	
	/** 搜索工具条 */
	var tb = new Ext.Toolbar({
				id : 'tb',
				items : ['代码', {
							xtype : 'textfield',
							id : 'PHEGCode',
							disabled : Ext.BDP.FunLib.Component.DisableFlag('PHEGCode')
						}, '-',
						'描述', {
							xtype : 'textfield',
							id : 'PHEGDesc',
							emptyText : '描述/别名',
							disabled : Ext.BDP.FunLib.Component.DisableFlag('PHEGDesc')
						}, '-',
						'知识库标识', {
							xtype : 'combo',
							id : 'PHEGLibDr',
							disabled : Ext.BDP.FunLib.Component.DisableFlag('PHEGLibDr'),
							triggerAction : 'all',// query
							queryParam : "desc",
							forceSelection : true,
							selectOnFocus : false,
							typeAhead : true,
							mode : 'remote',
							pageSize : Ext.BDP.FunLib.PageSize.Combo,
							allQuery : '',
							minChars : 1,
							listWidth : 250,
							valueField : 'PHLIRowId',
							displayField : 'PHLIDesc',
							store : new Ext.data.JsonStore({
								url : BindingLib,
								root : 'data',
								totalProperty : 'total',
								idProperty : 'PHLIRowId',
								fields : ['PHLIRowId', 'PHLIDesc'],
								remoteSort : true,
								sortInfo : {
									field : 'PHLIRowId',
									direction : 'ASC'
								}
							})
						},/* '-',
						'分类/类型', treeCombox,*/
						'-', btnSearch, '-', btnRefresh, '->'/*,exportBtn*/
				],
				listeners : {
					render : function() {
						tbbutton.render(grid.tbar) // tbar.render(panel.bbar)这个效果在底部
					}
				}
			});
	
	/** 创建grid */
	var grid = new Ext.grid.GridPanel({
				id : 'grid',
				region : 'center',
				closable : true,
				store : ds,
				trackMouseOver : true,
				columns : [new Ext.grid.CheckboxSelectionModel(), // 单选列
						{
							header : 'PHEGRowId',
							sortable : true,
							dataIndex : 'PHEGRowId',
							hidden : true
						}, {
							header : '代码',
							sortable : true,
							dataIndex : 'PHEGCode'
						}, {
							header : '描述',
							sortable : true,
							dataIndex : 'PHEGDesc'
						}, {
							header : '知识库标识代码',
							sortable : true,
							dataIndex : 'PHLICode',
							hidden:true
						}, {
							header : '知识库标识',
							sortable : true,
							dataIndex : 'PHLIDesc'
						}, {
							header : '知识库标识ID',
							sortable : true,
							dataIndex : 'PHEGLibDr',
							hidden:true
						}, {
							header : '药品分类',
							sortable : true,
							dataIndex : 'PHICStr'
						}, {
							header : '成分分类',
							sortable : true,
							dataIndex : 'PHEINGStr'
						}, {
							header : '是否可用',
							sortable : true,
							dataIndex : 'PHEGActiveFlag',
							renderer : Ext.BDP.FunLib.Component.ReturnFlagIcon
						},  {
							header : '是否系统标识',
							sortable : true,
							dataIndex : 'PHEGSysFlag',
							renderer : Ext.BDP.FunLib.Component.ReturnFlagIcon
						},  {
							header : '数据池标识',
							sortable : true,
							dataIndex : 'PHEGDataPool',
							renderer : Ext.BDP.FunLib.Component.ReturnFlagIcon
						}],
				stripeRows : true,
				title : '通用名字典',
				viewConfig : {
					forceFit : true
				},
				columnLines : true, //在列分隔处显示分隔符
				sm : new Ext.grid.RowSelectionModel({singleSelect:true}), // 按"Ctrl+鼠标左键"也只能单选
				bbar : paging,
				tbar : tb,
				tools:Ext.BDP.FunLib.Component.HelpMsg,
				stateId : 'grid'
			});
	grid.on("rowclick", function(grid, rowIndex, e){
	 	var code = grid.getSelectionModel().getSelections()[0].get('PHLICode');
	 	if(code!="DRUG"){
	 		Ext.getCmp('btnPro').disable();
	 		Ext.getCmp('btnLink').disable();
	 		Ext.getCmp('btnIngr').disable();
	 	}else{
	 		Ext.getCmp('btnPro').enable();
	 		Ext.getCmp('btnLink').enable();
	 		Ext.getCmp('btnIngr').enable();
	 	}
	 	if(code!="LAB"){
	 		Ext.getCmp('btnLPro').disable();
	 		Ext.getCmp('btnLis').disable();
	 	}else{
	 		Ext.getCmp('btnLPro').enable();
	 		Ext.getCmp('btnLis').enable();
	 	}
	 	if(code!="SPEC"){
	 		Ext.getCmp('btnCare').disable();
	 	}else{
	 		Ext.getCmp('btnCare').enable();
	 	}
	 	if((code!="ELECT")&&(code!="ULTR")&&(code!="RADI")&&(code!="ENDO")&&(code!="CHECK")&&(code!="OPERATION")&&(code!="TREAT")){
	 		Ext.getCmp('btnPart').disable();
	 	}else{
	 		Ext.getCmp('btnPart').enable();
	 	}
	 });
	/** grid双击事件 */
	grid.on("rowdblclick", function(grid, rowIndex, e) {
				var _record = grid.getSelectionModel().getSelected();
				if (!_record) {
		            Ext.Msg.show({
						title : '提示',
						msg : '请选择需要修改的行!',
						icon : Ext.Msg.WARNING,
						buttons : Ext.Msg.OK
					});
		       	 } else {
		            win.setTitle('修改');
					win.setIconClass('icon-update');
					win.show('');
					Ext.getCmp("form-save").getForm().reset();
		            Ext.getCmp("form-save").getForm().load({
		                url : OPEN_ACTION_URL + '&id=' + _record.get('PHEGRowId'),
		                success : function(form,action) {
		                },
		                failure : function(form,action) {
		                	Ext.Msg.alert('编辑', '载入失败');
		                }
		            });
		        }
			});
	 /**---------------------右键菜单-------------------**/
	   if(window.ActiveXObject)//判断浏览器是否属于IE,屏蔽其它浏览器
  	  {
            grid.addListener('rowcontextmenu', rightClickFn);//右键菜单代码关键部分
			var rightClick = new Ext.menu.Menu({
    		id:'rightClickCont', //在HTML文件中必须有个rightClickCont的DIV元素
    		disabled : Ext.BDP.FunLib.Component.DisableFlag('rightClickCont'),
    		items: [
    		{
	            iconCls :'icon-add',
	            handler: AddData,
	            id:'menuAdd',
	            disabled : Ext.BDP.FunLib.Component.DisableFlag('menuAdd'),
	            text: '添加'
	        },{
	            iconCls :'icon-Update',
	            handler: UpdateData,
	             id:'menuUpdate',
	            disabled : Ext.BDP.FunLib.Component.DisableFlag('menuUpdate'),
	            text: '修改'
	        },{
	            iconCls :'icon-delete',
	            handler: DelData,
	             id:'menuDel',
	            disabled : Ext.BDP.FunLib.Component.DisableFlag('menuDel'),
	            text: '删除'
	        },{
	            iconCls :'icon-DP',
	            handler: ConAlias,
	             id:'menuAlias',
	            disabled : Ext.BDP.FunLib.Component.DisableFlag('menuAlias'),
	            text: '别名维护'
	        },{
	            iconCls :'icon-DP',
	            handler: ConPro,
	             id:'menuPro',
	            disabled : Ext.BDP.FunLib.Component.DisableFlag('menuPro'),
	            text: '药品属性'
	        },{
	            iconCls :'icon-DP',
	            handler: ConLPro,
	             id:'menuLPro',
	            disabled : Ext.BDP.FunLib.Component.DisableFlag('menuLPro'),
	            text: '检验属性'
	        },{
	            iconCls :'icon-DP',
	            handler: ConLink,
	             id:'menuLink',
	            disabled : Ext.BDP.FunLib.Component.DisableFlag('menuLink'),
	            text: '关联剂型'
	        },{
	            iconCls :'icon-DP',
	            handler: ConLis,
	             id:'menuLis',
	            disabled : Ext.BDP.FunLib.Component.DisableFlag('menuLis'),
	            text: '关联标本'
	        },{
	            iconCls :'icon-DP',
	            handler: ConPart,
	             id:'menuPart',
	            disabled : Ext.BDP.FunLib.Component.DisableFlag('menuPart'),
	            text: '关联部位'
	        },{
	            iconCls :'icon-DP',
	            handler: ConIngr,
	             id:'menuIngr',
	            disabled : Ext.BDP.FunLib.Component.DisableFlag('menuIngr'),
	            text: '成分明细'
	        },{
	            iconCls :'icon-DP',
	            handler: ConCare,
	             id:'menuCare',
	            disabled : Ext.BDP.FunLib.Component.DisableFlag('menuCare'),
	            text: '标本采集注意事项'
	        },{
	            iconCls :'icon-refresh',
	            handler: Refresh,
	             id:'menuRefresh',
	            disabled : Ext.BDP.FunLib.Component.DisableFlag('menuRefresh'),
	            text: '刷新'
	        }]     	
		}); 
		 	function rightClickFn(grid,rowindex,e){
		    	 e.preventDefault();
		    	 var currRecord = false; 
		   		 var currRowindex = false; 
		   		 var currGrid = false; 
		         if (rowindex < 0) { 
		         return; 
		   } 
		
		     grid.getSelectionModel().selectRow(rowindex); 
		     currRowIndex = rowindex; 
		     currRecord = grid.getStore().getAt(rowindex); 
		     currGrid = grid; 
		    var code = grid.getSelectionModel().getSelections()[0].get('PHLICode');
		 	if(code!="DRUG"){
		 		Ext.getCmp('menuPro').disable();
		 		Ext.getCmp('menuLink').disable();
		 		Ext.getCmp('menuIngr').disable();
		 	}else{
		 		Ext.getCmp('menuPro').enable();
		 		Ext.getCmp('menuLink').enable();
		 		Ext.getCmp('menuIngr').enable();
		 	}
		 	if(code!="LAB"){
		 		Ext.getCmp('menuLPro').disable();
		 		Ext.getCmp('menuLis').disable();
		 	}else{
		 		Ext.getCmp('menuLPro').enable();
		 		Ext.getCmp('menuLis').enable();
		 	}
		 	if(code!="SPEC"){
		 		Ext.getCmp('menuCare').disable();
		 	}else{
		 		Ext.getCmp('menuCare').enable();
		 	}
		 	if((code!="ELECT")&&(code!="ULTR")&&(code!="RADI")&&(code!="ENDO")&&(code!="CHECK")&&(code!="OPERATION")){
		 		Ext.getCmp('menuPart').disable();
		 	}else{
		 		Ext.getCmp('menuPart').enable();
		 	}
		     rightClick.showAt(e.getXY()); 
		  }
		}	
	/**---------------------右键菜单-------------------**/
	/** 布局 */
	var viewport = new Ext.Viewport({
				layout : 'border',
				items : [grid]
			});
	/** 调用keymap */
    Ext.BDP.FunLib.Component.KeyMap(AddData,UpdateData,DelData);
});
