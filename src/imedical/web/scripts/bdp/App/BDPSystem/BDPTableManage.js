/**
 * @Title: 表结构管理
 * @Description:包含增删改查的功能
 * @Created on 2015-2-11 谷雪萍
 */
 //document.write('<script type="text/javascript" src="../scripts/bdp/Framework/scripts/Ext.ux.grid.js"> </script>');
document.write('<script type="text/javascript" src="../scripts/bdp/Framework/scripts/xlsx/xlsx.extendscript.js"> </script>');
document.write('<script type="text/javascript" src="../scripts/bdp/Framework/scripts/xlsx/xlsx-style/xlsx.full.min.js"> </script>');
document.write('<script type="text/javascript" src="../scripts/bdp/Framework/scripts/xlsx/export.js"> </script>');
 Ext.onReady(function() {
    
	/**--------------调用后台数据用到的类方法的URL-------------------*/
	Ext.BLANK_IMAGE_URL = '../scripts_lib/ext3.2.1/resources/images/default/s.gif';
	var ACTION_URL = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.BDP.BDPTableList&pClassQuery=GetList";
	var SAVE_ACTION_URL_New = "../csp/dhc.bdp.ext.entitydatatrans.csp?pClassName=web.DHCBL.BDP.BDPTableList&pClassMethod=SaveEntity&pEntityName=web.Entity.BDP.BDPTableList";
	var DELETE_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.BDP.BDPTableList&pClassMethod=DeleteData";
	
	var CHILD_ACTION_URL = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.BDP.BDPTableField&pClassQuery=GetList";
	var CHILD_SAVE_ACTION_URL_New = "../csp/dhc.bdp.ext.entitydatatrans.csp?pClassName=web.DHCBL.BDP.BDPTableField&pClassMethod=SaveEntity&pEntityName=web.Entity.BDP.BDPTableField";
	var CHILD_DELETE_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.BDP.BDPTableField&pClassMethod=DeleteData";
	
	Ext.QuickTips.init();												   
	Ext.form.Field.prototype.msgTarget = 'qtip';                         
	var pagesize_main = Ext.BDP.FunLib.PageSize.Main;
	Ext.BDP.FunLib.TableName="BDPTableManage"
	
	/**--------------数据导入导出-------------------*/
	var ErrorMsgInfo="请先确认本机有安装office软件。打开IE,在[internet选项]-[安全]-[受信任的站点]-[站点]中添加开始界面到可信任的站点，然后在[自定义级别]中对[没有标记为安全的ActiveX控件进行初始化和脚本运行]这一项设置为启用，确定后，重启浏览器。 "
	GetBrower=function()
	{	
		///ie10,9,8,7,6                                                   //IE11
        if(((window.ActiveXObject)&&((navigator.userAgent.toLowerCase()).match(/msie ([\d.]+)/)[1]))||(("ActiveXObject" in window)))
        {
        	return "IE"
        }
        else if(((navigator.userAgent.toLowerCase()).match(/firefox\/([\d.]+)/)))
        {
        	return "FIREFOX"
        }
        else if((navigator.userAgent.toLowerCase()).match(/opera.([\d.]+)/))
        {
        	return "OPERA"
        }
        else if((navigator.userAgent.toLowerCase()).match(/version\/([\d.]+).*safari/))
		{
			return "SAFARI"
		}
		else
		{
			return "OTHER"
		}
	}
	
        
	var idTmr  //按照指定的周期（以毫秒计）来调用函数或计算表达式。
	
	Cleanup=function (){
		if(idTmr) 
		{
	 		window.clearInterval(idTmr);    //取消由setInterval()方法设置的定时器。
		}
	 	CollectGarbage();
	}
	/*
	///导出Excel文件2018-11-06 guxueping
	function ExcelExport()
	{
		var BrowerVersion=GetBrower()
		if (BrowerVersion!="IE")
		{
			alert("请在IE下执行！"); return;
		}
		Ext.MessageBox.confirm('提示', '确定要导出查询到的数据吗?', function(btn) {
			if (btn == 'yes') {
			
				try{
			    	var xlApp = new ActiveXObject("Excel.Application");
					var xlBook = xlApp.Workbooks.Add();///默认三个sheet
				}catch(e){
					Ext.Msg.show({
						title : '提示',
						msg : ErrorMsgInfo ,
						minWidth : 200,
						icon : Ext.Msg.INFO,
						buttons : Ext.Msg.OK
					}) 
				    return;
				}

				//Ext.MessageBox.wait('正在导出表结构登记数据，请勿刷新或关闭页面，请稍候...','提示');
			
				///BDP功能大表 1
				xlBook.worksheets(1).select(); 
				var xlsheet = xlBook.ActiveSheet; 
				var rowcount=tkMakeServerCall("web.DHCBL.BDP.BDPTableField","GetItemsCount");
			    
				xlsheet.name="表结构登记";  //sheet名
				//第一行
				xlsheet.cells(1,1)="类名";
				xlsheet.cells(1,2)="表名(代码)";
				xlsheet.cells(1,3)="中文名";
				xlsheet.cells(1,4)="属性(基础数据/配置数据)";
				xlsheet.cells(1,5)="公/私/管控类型(填字母:公有G,私有S,管控C,绝对私有A)";
				xlsheet.cells(1,6)="使用公共私有数据关联表";
				xlsheet.cells(1,7)="产品组";
				xlsheet.cells(1,8)="是否区分版本";
				xlsheet.cells(1,9)="是否数据来源";
				xlsheet.cells(1,10)="Global";
				xlsheet.cells(1,11)="描述在表里的字段名";
				xlsheet.cells(1,12)="代码在表里的字段名";
				xlsheet.cells(1,13)="表字段代码";
				xlsheet.cells(1,14)="表字段描述";
				xlsheet.cells(1,15)="表字段类型";
				xlsheet.cells(1,16)="指向表";
				xlsheet.cells(1,17)="是否可翻译";
				//8.5
				//xlsheet.cells(1,18)="标准数据类型";
				//xlsheet.cells(1,19)="标准数据版本";
				//第二行
				xlsheet.cells(2,1)="TableName";
				xlsheet.cells(2,2)="ClassName";
				xlsheet.cells(2,3)="TableDesc";
				xlsheet.cells(2,4)="Attribute";
				xlsheet.cells(2,5)="DataType";
				xlsheet.cells(2,6)="MappingHospFlag";
				xlsheet.cells(2,7)="Type";
				xlsheet.cells(2,8)="VersionFlag";
				xlsheet.cells(2,9)="Sources";
				xlsheet.cells(2,10)="TableGlobal";
				xlsheet.cells(2,11)="DescPropertyName";
				xlsheet.cells(2,12)="CodePropertyName";
				xlsheet.cells(2,13)="FieldName";
				xlsheet.cells(2,14)="FieldDesc";
				xlsheet.cells(2,15)="FieldType";
				xlsheet.cells(2,16)="FieldTabCode";
				xlsheet.cells(2,17)="FieldTranslation";
				//8.5
				//xlsheet.cells(2,18)="StandardDataType";
				//xlsheet.cells(2,19)="StandardDataVersion";
				//设置标题行（1、2行）字体等样式
				for (var tr=0;tr<2;tr++){
					for (var tc=0;tc<17;tc++){
						xlsheet.cells(tr+1,tc+1).Font.Bold = true;	//设置为粗体
						xlsheet.cells(tr+1,tc+1).WrapText=true;  //设置为自动换行
					}
				}
				
				var row=0,ProgressText='';
				var win2 = new Ext.Window({
					closable:false,
					modal:true,
					width:314,
					items:[
						new Ext.ProgressBar({id:'proBar',text:'导出'+xlsheet.name+'信息',width:300})
					] 
				});
				var proBar=new Ext.getCmp('proBar');
				Ext.TaskMgr.start({  
				  run:function(){
				  	row++;
				  	if(row>rowcount) //当到达最后一行退出
				  	{
						Ext.MessageBox.hide();
						alert('导出完成!')
						xlApp.Visible=true;
						xlBook.Close(savechanges=true);
						xlApp.Quit();  //关闭excel
						idTmr = window.setInterval("Cleanup()",1);  //按照指定的周期（以毫秒计）来调用函数或计算表达式。
						Ext.TaskMgr.stop(this);
						win2.close();

				  	}
				  	else
				  	{
		
						var tempStr = ""; //每行数据（第一列[next]第二列[next]...）
						var DataDetailStr=tkMakeServerCall("web.DHCBL.BDP.BDPTableField","GetItemInfo",row);
						var i=row+2   //行
						var Detail=DataDetailStr.split("#");
						for (var j=1;j<=17;j++){
							xlsheet.cells(i,j)=Detail[j-1];
						}
					    progressText = "正在导出"+xlsheet.name+"表的第"+row+"条记录,总共"+rowcount+"条记录!";  
					    proBar.updateProgress(row/rowcount,progressText);
					  }
						 
				  },  
				  interval:100  
				});
				win2.show();	

			}
		}, this);
		
	}
	*/	
	//调用js-xlsx 导出数据  2022-08-03
	function ExcelExport() {
		
		var xlsName="表结构登记" 
		if (xlsName!="") 
		{  
			var taskcount=tkMakeServerCall("web.DHCBL.BDP.BDPTableField","GetItemsCount");  //获取要导出的总条数  
			if (taskcount==0)  
			{
				Ext.Msg.show({
					title : '提示',
					msg : '没有查询到数据，请重新确认！' ,
					minWidth : 200,
					icon : Ext.Msg.INFO,
					buttons : Ext.Msg.OK
				})
				return;
			}
			if (taskcount>0)
			{
				//ext进度条，导出
				var winproBar = new Ext.Window({
						closable:false,
						modal:true,
						width:314,
						items:[
							new Ext.ProgressBar({id:'proBar',text:'',width:300})
						] 
				});
				var proBar=Ext.getCmp('proBar');
				var TotalArray=[] //定义数组，用于给table赋值
				var titlenameStr="类名&%表名(代码)&%中文名&%属性(基础数据/配置数据)&%公/私/管控类型(填字母:公有G,私有S,管控C,绝对私有A)&%使用公共私有数据关联表&%产品组&%是否区分版本&%是否数据来源&%Global&%描述在表里的字段名&%代码在表里的字段名&%表字段代码&%表字段描述&%表字段类型&%指向表&%是否可翻译"; //&%标准数据类型&%标准数据版本
				var titlenamearr=titlenameStr.split("&%");
				TotalArray.push(titlenamearr);    
				var titlecodeStr="TableName&%ClassName&%TableDesc&%Attribute&%DataType&%MappingHospFlag&%Type&%VersionFlag&%Sources&%TableGlobal&%DescPropertyName&%CodePropertyName&%FieldName&%FieldDesc&%FieldType&%FieldTabCode&%FieldTranslation";  //&%StandardDataType&%StandardDataVersion
				var titlecodearr=titlecodeStr.split("&%");
				TotalArray.push(titlecodearr);   
				var row=0,taskcount=taskcount;
				var ProgressText='';
				Ext.TaskMgr.start({  
				  run:function(){
				  	row++;
				  	if(row>taskcount) //当到达最后一行退出
				  	{
				  		Ext.MessageBox.hide(); 
						Ext.TaskMgr.stop(this);  
						winproBar.close();
						
						var sheet = XLSX2.utils.aoa_to_sheet(TotalArray);
						
						//第一行增加样式
				        for (var key in sheet) {
				        	if ((key=='A2')||(key=='!ref')){break;}
				        	//非必填项模板颜色黑色
							sheet[key]["s"] = {
					            font: {
					                name: '宋体',
					                sz: 14,
					                bold: true,
					                underline: false,
					                color: {
					                    rgb: "000000"  //黑色
					                }
					            },
					            alignment: {  //设置标题水平竖直方向居中，并自动换行展示
					                horizontal: "center",
					                vertical: "center",
					                wrap_text: true
					            }
					        };
						};
						openDownloadDialog(sheet2blob(sheet), xlsName+'.'+'xlsx');
				  	}
				  	else
				  	{
						progressText = "正在导出第"+row+"条记录,总共"+taskcount+"条记录!";   
						proBar.updateProgress(row/taskcount,progressText);
						//将每条数据加到数组里
						var DataDetailStr2=tkMakeServerCall("web.DHCBL.BDP.BDPTableField","GetItemInfo",row)
						var DetailArray=DataDetailStr2.split("#");
					    TotalArray.push(DetailArray)
					  }
				  },  
				  interval:10
				}); 
				winproBar.show();
			}
			
		}  
	}
   ///导入Excel文件 2018-11-06 guxueping
  function ExcelImport(){ 
  		var BrowerVersion=GetBrower()		
		if (BrowerVersion!="IE")
		{
			alert("请在IE下执行！"); return;
		}
		var efilepath=Ext.getCmp("ExcelImportPath").getValue();
		if( efilepath.indexOf("fakepath")>0 ) {alert ("请在IE下执行导入！"); return;}
		if( efilepath.indexOf(".xls")<=0 ) {alert ("请选择excel表格文件！"); return;}
	
		try{
			var oXL = new ActiveXObject("Excel.application"); 
			var oWB = oXL.Workbooks.open(efilepath);   //xlBook = xlApp.Workbooks.add(ImportFile);
		}		
		catch(e){
			Ext.Msg.show({
				title : '提示',
				msg : ErrorMsgInfo ,
				minWidth : 200,
				icon : Ext.Msg.INFO,
				buttons : Ext.Msg.OK
			}) 
	
			//alert(e.message);
			return;
		}
		
		var errorRow="";//没有插入的行
		var errorMsg="";//错误信息
		oWB.worksheets(1).select(); 
		var oSheet = oWB.ActiveSheet; 
		if (oSheet.name!="表结构登记"){
			alert("第一个sheet名不是表结构登记，请确认数据并改名！"); 
			return;;
		}
		var rowcount=oXL.Worksheets(1).UsedRange.Cells.Rows.Count ;  ///行数
		var colcount=oXL.Worksheets(1).UsedRange.Cells.Columns.Count ;  ///列数
		var row=3,ProgressText='';
		var win2 = new Ext.Window({
			closable:false,
			modal:true,
			width:314,
			items:[
				new Ext.ProgressBar({id:'proBar',text:'导入'+oSheet.name+'信息',width:300})
			] 
		});
		var proBar=new Ext.getCmp('proBar');
		Ext.TaskMgr.start({  
		  run:function(){
		  	row++;
		  	if(row>rowcount) //当到达最后一行退出
		  	{
		  		if(errorRow!=""){
					errorMsg=oSheet.name+"表导入完成，第"+errorRow+"行插入失败!" ;			
				}else{
					errorMsg=oSheet.name+"表导入完成!"
				}
				
				Ext.MessageBox.hide();
				alert(errorMsg)
				oWB.Close(savechanges=false);
				CollectGarbage();
					
				oXL.Quit(); 
				oXL=null;
				oSheet=null;	
				idTmr = window.setInterval("Cleanup()",1);  //按照指定的周期（以毫秒计）来调用函数或计算表达式。
				Ext.TaskMgr.stop(this);
				win2.close();
		  	}
		  	else
		  	{
				var i=row				
				var tempStr="";  //每行数据（第一列&第二列&...）
				for (var j=1;j<=colcount;j++){
					var cellValue="";
					if (typeof(oSheet.Cells(i,j).value)=="undefined")
					{
						cellValue="";
					}
					else
					{
						cellValue=oSheet.Cells(i,j).value;
					}
					tempStr+=(cellValue+"#")			
				}
				var Flag =tkMakeServerCall("web.DHCBL.BDP.BDPTableField","ImportExcel",tempStr);
				if (Flag=="0"){  //保存失败
					if(errorRow!=""){
						errorRow=errorRow+","+i
					}else{
						errorRow=i
					}
				}		
				//alert(kbclassname+"^"+tempStr+"^"+Flag);
			    progressText = "正在导入"+oSheet.name+"表的第"+row+"行记录,总共"+rowcount+"行记录!";  
			    proBar.updateProgress(row/rowcount,progressText);
			  }
				 
		  },  
		  interval:100  
		});
		win2.show();
  }
  
	/**导入表单*/
	var importForm = new Ext.form.FormPanel({
		id : 'importForm',
		labelAlign : 'right',
		labelWidth : 120,
		frame :true,
		defaultType : 'textfield',
		items:[{
			fieldLabel : '<font color=red>*</font>导入Excel文件',
			id:'ExcelImportPath',
			xtype : 'textfield',
			inputType:'file',
			width: 400,
			allowBlank : false,
			blankText: '不能为空'
		}]
	})
	/**导入窗口**/
	var importWin=new Ext.Window({
		title : '表结构登记数据导入',
		width : 600,
		height:150,
		layout : 'fit',
		plain : true,//true则主体背景透明
		modal : true,
		frame : true,
		autoScroll : true,
		collapsible : true,
		constrain : true,
		hideCollapseTool : true,
		titleCollapse : true,
		buttonAlign : 'center',
		closable:false,
		closeAction : 'hide',
		items : importForm,
		buttons:[{
			text:"导入",
			iconCls : 'icon-import',
			id:'import_btn',
			handler:function(){
				ExcelImport();
			}
			
		},{
			text : '关闭',
			iconCls : 'icon-close',
			handler : function() {
				Ext.getCmp("ExcelImportPath").reset();
				importWin.hide();
			}
		}]
	})
	
   var exportBtn = new Ext.Toolbar.Button({
		text : '导出',
		tooltip : '导出',
		id:'export_btn',
		hidden:false,
		disabled : Ext.BDP.FunLib.Component.DisableFlag('export_btn'),
		iconCls : 'icon-export',
		handler : function() {
			ExcelExport()
		}
	});	
	
	var importBtn = new Ext.Toolbar.Button({
		text : '导入',
		tooltip : '导入',
		id:'import_btn',
		hidden:false,
		disabled : Ext.BDP.FunLib.Component.DisableFlag('import_btn'),
		iconCls : 'icon-import',
		handler : function() {
			importWin.show();
		}
	});	
	/*********************************在删除按钮下实现删除功能**********************************************/
	var btnDel = new Ext.Toolbar.Button({                                   
			text : '删除',													   
			id:'delete-btn',
			tooltip : '删除',												   
			iconCls : 'icon-delete',										   
			disabled:Ext.BDP.FunLib.Component.DisableFlag('delete-btn'),
			handler : function() {											  
			if (grid.selModel.hasSelection()) {                           
				var gsm = grid.getSelectionModel();				  
				var rows = gsm.getSelections();
				if(rows[0].get('ID')==""||typeof(rows[0].get('ID'))=="undefined"){
					Ext.Msg.show({
									title : '提示',
									msg : '没有要删除的数据!',
									minWidth : 200,
									icon : Ext.Msg.ERROR,
									buttons : Ext.Msg.OK
								});
						return;
				}
				Ext.MessageBox.confirm('提示', '确定要删除所选的数据吗?', function(btn) {
					if (btn == 'yes') {                                 
						Ext.MessageBox.wait('数据删除中,请稍候...', '提示');  
						var gsm = grid.getSelectionModel();				  
						var rows = gsm.getSelections();					  
						Ext.Ajax.request({	                              	
								url : DELETE_ACTION_URL,					 
								method : 'POST',                              
								params : {									 
									'id' : rows[0].get('ID')          
								},
								callback : function(options, success, response) {
										
										Ext.MessageBox.hide();
										if (success) {				              								
											var jsonData = Ext.util.JSON.decode(response.responseText); 
											if (jsonData.success == 'true') {
											Ext.Msg.show({
															title : '提示',
															msg : '数据删除成功!',
															icon : Ext.Msg.INFO,           
															buttons : Ext.Msg.OK,         
															fn : function(btn) {
																var startIndex = grid.getBottomToolbar().cursor;
																var totalnum=grid.getStore().getTotalCount();
																if(totalnum==1){   
																var startIndex=0
															}
															else if((totalnum-1)%pagesize_main==0)  
														   {
																var pagenum=grid.getStore().getCount();
																if (pagenum==1){ startIndex=startIndex-pagesize_main;}   
															}
															grid.getStore().load({
																  params : {
																				start : startIndex,
																				limit : pagesize_main
																			},
																		callback : function(records, options, success) {					
																			// Ext.Msg.alert('info', '加载完毕, success = '+records.length);
																			clearSubWin();
																		}
																	});
															  }
														});
													} else {		 //--------如果返回的是错误的请求
														var errorMsg = '';
														if (jsonData.info) {			 
															errorMsg = '<br />错误信息:'
																	+ jsonData.info
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
																	msg : '异步通讯失败.....',
																	icon : Ext.Msg.ERROR,    
																	buttons : Ext.Msg.OK     
																});
															}
														}
												}, this);
											}
										}, this);
									} else {												   
										Ext.Msg.show({										     //--------没有选择行记录的时候
													title : '提示',
													msg : '请选择需要删除的行!',
													icon : Ext.Msg.WARNING,
													buttons : Ext.Msg.OK
												});
											}
										}
							});
	
	var editor = new Ext.ux.grid.RowEditor({                           //---------打一个可以编辑的表格补丁
			saveText : '更新',                                             
			cancelText : '关闭',
			commitChangesText : '提交!',
			errorSummary: false,
			id:"table-Editor",
			disabled:Ext.BDP.FunLib.Component.DisableFlag('table-Editor')
	});
	/// 添加一些监听
   editor.on({
    canceledit : CancelEdit=function() {
        			var startIndex = grid.getBottomToolbar().cursor;
					grid.getStore().load({                               
								params : {
											start :startIndex,       
 											limit : pagesize_main
										},
								callback : function(records, options, success) {					
									// Ext.Msg.alert('info', '加载完毕, success = '+records.length);
									clearSubWin();
								}
							});				
    			}
	});
	/** ****************************清空基本元素维护 *************************/
	function clearSubWin() {
			Ext.getCmp("TextCode2").reset();
			Ext.getCmp("TextDesc2").reset();
			BDEFgrid.setTitle("");
			BDEFds.removeAll();
			//BDEFtbbutton.setDisabled(true);
			//BDEFtb.setDisabled(true);
			BDEFgrid.getStore().baseParams={};
			BDEFds.load({                                    
				params : {
							start : 0,
							limit : pagesize_main,
							ParRef: ""
						},
				callback : function(records, options, success) {
									BDEFgrid.disable();
								}
				});
			
			
			//document.getElementById('ext-comp-1035').innerHTML="没有记录",
			//document.getElementById('ext-comp-1031').innerHTML="页,共 1 页",
			//document.getElementById('ext-comp-1030').value="1"
	}
	
	/*********************************增加按钮*********************************/
	var btnAddwin = new Ext.Toolbar.Button({
			id:'btnAddwin',
			disabled : Ext.BDP.FunLib.Component.DisableFlag('btnAddwin'),
			text : '添加',
			tooltip : '添加',
			iconCls : 'icon-add',
			handler : function(thiz) {//点击触发的事件
				clearSubWin();
				editor.stopEditing();
				if(ds.getCount()!=0&&ds.getAt(0).get('TableName')==""){
					grid.getSelectionModel().selectRow(0);
					editor.startEditing(0);
				}else{
				var a = new BDET({	 // ------------创建一条新数据
						TableName : '', 										 
						TableDesc : '',
						TableGlobal : '',
						XCode : '',
						Type : '',
						XCode2 : '',
						Sources : '',
						ClassName : '',
						DataType : '',
						VersionFlag : '',
						MappingHospFlag : '',
						//SpecialFlag : '',
						Attribute : '',
						DescPropertyName : '',
						CodePropertyName : '',
						StandardDataType : '',
						StandardDataVersion : '',
						AUDControlRights : ''
				});
				ds.insert(0, a); 											 
				grid.getSelectionModel().selectRow(0);
				editor.startEditing(0);
			}
		},
		scope : this												 
	});
		var BDET = Ext.data.Record.create([				        
								{	name : 'ID',
									mapping : 'ID',
									type : 'string'
								}, {
									name : 'TableName',
									mapping : 'TableName',
									type : 'string'
								}, {
									name : 'ClassName',
									mapping : 'ClassName',
									type : 'string'
								}, {
									name : 'TableGlobal',
									mapping : 'TableGlobal',
									type : 'string'
								}, {
									name : 'TableDesc',
									mapping : 'TableDesc',
									type : 'string'
								}, {
									name: 'XCode',
									mapping:'XCode',
									type:'string'
								}, {
									name: 'XCode2',
									mapping:'XCode2',
									type:'string'
								},{
									name: 'Type',
									mapping:'Type',
									type:'string'
								},{
									name: 'Sources',
									mapping:'Sources',
									type:'string'
								},{
									name: 'DataType',
									mapping:'DataType',
									type:'string'
								},{
									name: 'VersionFlag',
									mapping:'VersionFlag',
									type:'string'
								},{
									name: 'MappingHospFlag',
									mapping:'MappingHospFlag',
									type:'string'
								}/*,{
									name: 'SpecialFlag',
									mapping:'SpecialFlag',
									type:'string'
								}*/,{
									name: 'Attribute',
									mapping:'Attribute',
									type:'string'
								},{
									name: 'DescPropertyName',
									mapping:'DescPropertyName',
									type:'string'
								},{
									name: 'CodePropertyName',
									mapping:'CodePropertyName',
									type:'string'
								},{
									name: 'StandardDataType',
									mapping:'StandardDataType',
									type:'string'
								},{
									name: 'StandardDataVersion',
									mapping:'StandardDataVersion',
									type:'string'
								},{
									name: 'AUDControlRights',
									mapping:'AUDControlRights',
									type:'string'
								}
								
                       ]);
	
	//定义全局变量，用于传到弹窗中
	var Rowthiz="",Rowrecord="",Rowoperation="";
	//公私管控修改-密码弹窗定义	20200616	likefan
	var passwordwin = new Ext.Window({
        width : 600,
		title : '请输入密码',
        height : 230,
        layout : 'fit',
        plain : true, 
        modal : true,
        frame : true,
        collapsible : true,
        constrain : true,
        hideCollapseTool : true,
        titleCollapse : true,
        bodyStyle : 'padding:3px',
        buttonAlign : 'center',
        closeAction : 'hide',
        labelWidth : 50,
        items : [new Ext.form.FormPanel({
                id : 'formpassword',
                labelAlign : 'right',
                width : 600,
                split : true,
                frame : true,
               defaults : {
                anchor: '90%',
                border : false  
               },
                items : [{
							xtype : 'displayfield',
							fieldLabel : "提示",
							value:"由于更改“表结构登记的代码和公/私/管控类型”信息会对业务配置或基础数据的取值带来重大影响，因此信息的变动需特别慎重；如必须变更，需和公司产品部负责人联系，在达成更改必要性的一致意见后，由产品部提供相应的密码后进行更改。",
                            id:'tooltip1',
                            name : 'tooltip1'
                        },{
							xtype : 'textfield',
                            fieldLabel : "<span style='color:red;'>*</span>密码",
                            id:'Password',
                            name : 'Password',
							allowBlank : false,
							blankText: '请输入密码'
                        }]
            })],
        buttons : [{
            text : '确定',
            iconCls : 'icon-save',
            id:'subpass_btn',
            disabled : Ext.BDP.FunLib.Component.DisableFlag('subpass_btn'),
            handler : function() {
				if(Ext.getCmp("formpassword").getForm().isValid()==false){
					 Ext.Msg.alert('提示','<font color = "red">请输入密码');
					 return;
				}
				var Tablecode = grid.getSelectionModel().getSelections()[0].get('ClassName');
				var textPassword=Ext.getCmp("Password").getValue();
				//产生密码所需信息：系统日期，当前登录医院代码，基础数据表代码/配置数据表代码
				var passwordflag = tkMakeServerCall("web.DHCBL.BDP.BDPTableList","CheckPassword",Tablecode,textPassword);
				if (passwordflag==1)
				{
					Ext.Msg.alert('提示','<font color = "red">密码错误！');
					return;
				}
				//alert("密码正确！");
				passwordwin.hide();
				
				//保存
				var user = Rowthiz.getAt(Rowthiz.indexOf(Rowrecord)).data;
				if (typeof(user.ID) == 'undefined') {     
					user.ID = "";
				}
				Rowthiz.commitChanges();                          
				Ext.Ajax.request({                            
					url : SAVE_ACTION_URL_New,
					method : 'POST',
					params : 'ID=' + user.ID     
							+ '&TableName=' + user.TableName
							+ '&TableDesc=' + user.TableDesc
							+ '&XCode=' + user.XCode
							+ '&Type=' + user.Type
							+ '&XCode2=' + user.XCode2
							+ '&Sources=' + user.Sources
							+ '&ClassName=' + user.ClassName
							+ '&TableGlobal=' + user.TableGlobal
							+ '&DataType=' + user.DataType
							+ '&VersionFlag=' + user.VersionFlag
							+ '&MappingHospFlag=' + user.MappingHospFlag
							//+ '&SpecialFlag=' + user.SpecialFlag
							+ '&Attribute=' + user.Attribute
							+ '&DescPropertyName=' + user.DescPropertyName
							+ '&CodePropertyName=' + user.CodePropertyName
							+ '&StandardDataType=' + user.StandardDataType
							+ '&StandardDataVersion=' + user.StandardDataVersion
							+ '&AUDControlRights=' + user.AUDControlRights
							,
					success : function(response, opts) {
						var respText = Ext.util.JSON.decode(response.responseText);
						if(respText.success=='true'){
							Rowthiz.commitChanges();
							var startIndex = grid.getBottomToolbar().cursor;
							grid.getStore().load({params : {												   //----------ds加载时发送的附加参数
													//RowId : respText.id,   
													start : startIndex,
													limit : pagesize_main
												},
												callback : function(records, options, success) {					
													// Ext.Msg.alert('info', '加载完毕, success = '+records.length);
													clearSubWin();
												}
											});               
							
						}else{
							var errorMsg = '';
							if (respText.errorinfo) {
								errorMsg = '<br/>错误信息:' + respText.errorinfo
							}
							Ext.Msg.show({
											title : '提示',
											msg : '保存失败!' + errorMsg,
											minWidth : 200,
											icon : Ext.Msg.ERROR,
											buttons : Ext.Msg.OK
										});
							var r = grid.getSelectionModel().getSelected();
							if(r){
								var index = grid.store.indexOf(r);
								editor.startEditing(index);
							}
						}
					},
					failure : function(response, opts) {
						Ext.Msg.alert('错误', '提交数据错误!错误代码： '
										+ response.status);
						thiz.rejectChanges();     //-------------- 请求失败,回滚本地记录:)
						var startIndex = grid.getBottomToolbar().cursor;
						grid.getStore().load({params : {												   //----------ds加载时发送的附加参数
												start : startIndex,
												limit : pagesize_main
											}
										});
						grid.getView().refresh();
					}
				});
				
				
            }
        }, {
            text : '关闭',
            iconCls : 'icon-close',
            handler : function() {
                passwordwin.hide();
            }
        }],
		listeners:{
			"show":function(){
				Ext.getCmp("Password").focus(true,300);
			},
			"hide" : function() {
					Ext.getCmp("Password").reset();
					CancelEdit();
				},
			"close":function(){
			}
		}
    });
	
     /**------将数据读取出来并转换(成record实例)，为后面的读取和修改做准备-------*/
     var ds = new Ext.data.Store({
				proxy : new Ext.data.HttpProxy({ // ---------通过HttpProxy的方式读取原始数据
					url : ACTION_URL
				}),
				reader : new Ext.data.JsonReader({ // ---------将原始数据转换
					totalProperty : 'total',
					root : 'data',
					successProperty : 'success'
				}, BDET),
				listeners : {
					'cancel':function(){
						
					},
					'update' : function(thiz, record, operation) {
						var user = thiz.getAt(thiz.indexOf(record)).data;
						if (typeof(user.ID) == 'undefined') {     
							user.ID = "";
						}
						if (operation == Ext.data.Record.EDIT) {
							
							//密码校验	20200616	likefan
							var passwordflag = tkMakeServerCall("web.DHCBL.BDP.BDPTableList","SavePasswordFlag",user.ID,user.ClassName,user.DataType,user.MappingHospFlag,user.AUDControlRights);
							//alert("是否密码校验:"+passwordflag);
							if (passwordflag==1){
								Rowthiz=thiz;
								Rowrecord=record;
								Rowoperation=operation;
								passwordwin.setTitle('请输入密码');
								passwordwin.show();
								return;
							}
							
							thiz.commitChanges();                          
							Ext.Ajax.request({                            
								url : SAVE_ACTION_URL_New,
								method : 'POST',
								params : 'ID=' + user.ID     
										+ '&TableName=' + user.TableName
										+ '&TableDesc=' + user.TableDesc
										+ '&XCode=' + user.XCode
										+ '&Type=' + user.Type
										+ '&XCode2=' + user.XCode2
										+ '&Sources=' + user.Sources
										+ '&ClassName=' + user.ClassName
										+ '&TableGlobal=' + user.TableGlobal
										+ '&DataType=' + user.DataType
										+ '&VersionFlag=' + user.VersionFlag
										+ '&MappingHospFlag=' + user.MappingHospFlag
										//+ '&SpecialFlag=' + user.SpecialFlag
										+ '&Attribute=' + user.Attribute
										+ '&DescPropertyName=' + user.DescPropertyName
										+ '&CodePropertyName=' + user.CodePropertyName
										+ '&StandardDataType=' + user.StandardDataType
										+ '&StandardDataVersion=' + user.StandardDataVersion
										+ '&AUDControlRights=' + user.AUDControlRights
										,
								success : function(response, opts) {
									var respText = Ext.util.JSON.decode(response.responseText);
									if(respText.success=='true'){
										thiz.commitChanges();
										var startIndex = grid.getBottomToolbar().cursor;
										grid.getStore().load({params : {												   //----------ds加载时发送的附加参数
																//RowId : respText.id,   
																start : startIndex,
																limit : pagesize_main
															},
															callback : function(records, options, success) {					
																// Ext.Msg.alert('info', '加载完毕, success = '+records.length);
																clearSubWin();
															}
														});               
										
									}else{
										var errorMsg = '';
										if (respText.errorinfo) {
											errorMsg = '<br/>错误信息:' + respText.errorinfo
										}
										Ext.Msg.show({
														title : '提示',
														msg : '保存失败!' + errorMsg,
														minWidth : 200,
														icon : Ext.Msg.ERROR,
														buttons : Ext.Msg.OK
													});
										var r = grid.getSelectionModel().getSelected();
							            if(r){
							                var index = grid.store.indexOf(r);
							                editor.startEditing(index);
							            }
									}
								},
								failure : function(response, opts) {
									Ext.Msg.alert('错误', '提交数据错误!错误代码： '
													+ response.status);
									thiz.rejectChanges();     //-------------- 请求失败,回滚本地记录:)
									var startIndex = grid.getBottomToolbar().cursor;
									grid.getStore().load({params : {												   //----------ds加载时发送的附加参数
															start : startIndex,
															limit : pagesize_main
														}
													});
									grid.getView().refresh();
								}
							});

						}
					}
				}
			});
		/** -------------------加载数据----------------- */
	ds.load({
				params : {												 
					start : 0,
					limit : pagesize_main
				},
				callback : function(records, options, success) {          
					/**参数records表示获得的数据
					 * 	  options表示执行load时传递的参数 	 
					 *    success表示是否加载成功
					 */
				}
			});
			
		/**---------分页工具条-----------*/	
	var paging = new Ext.PagingToolbar({
				pageSize : pagesize_main,
				store : ds,											      
				displayInfo : true,										  
				//displayMsg : '显示第 {0} 条到 {1} 条记录，一共 {2} 条',  
				emptyMsg : "没有记录"
			})
	var sm = new Ext.grid.CheckboxSelectionModel({
				singleSelect : true,
				checkOnly : false,
				width : 20
			});

/**********************************定义设置例外医院按钮**20200430**李可凡****************************/	
	var ExceptionHosp_QUERY_URL = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.BDP.BDPExceptionHosp&pClassQuery=GetList";
	var ExceptionHosp_SAVE_URL = "../csp/dhc.bdp.ext.entitydatatrans.csp?pClassName=web.DHCBL.BDP.BDPExceptionHosp&pClassMethod=SaveEntity&pEntityName=web.Entity.BDP.BDPExceptionHosp";	
	var ExceptionHosp_DELETE_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.BDP.BDPExceptionHosp&pClassMethod=DeleteData";
	var ExceptionHosp_OPEN_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.BDP.BDPExceptionHosp&pClassMethod=OpenData";
	var Hospital_DR_URL = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.BDP.BDPExceptionHosp&pClassQuery=GetDataForCmb1";
	var pagesize = Ext.BDP.FunLib.PageSize.Main;
	var pagesize1=Ext.BDP.FunLib.PageSize.Pop;
	
	Ext.getUrlParam = function(param) { 
		var params = Ext.urlDecode(unescape(location.search.substring(1))); 
		return param ? params[param] : params; 
	};
	var communityid=Ext.getUrlParam('communityid');
	
	//例外医院-密码弹窗定义	20200615	likefan
	var passwordwin2 = new Ext.Window({
        width : 600,
		//title : '请输入密码',
        height : 230,
        layout : 'fit',
        plain : true, 
        modal : true,
        frame : true,
        collapsible : true,
        constrain : true,
        hideCollapseTool : true,
        titleCollapse : true,
        bodyStyle : 'padding:3px',
        buttonAlign : 'center',
        closeAction : 'hide',
        labelWidth : 50,
        items : [new Ext.form.FormPanel({
                id : 'formpassword2',
                labelAlign : 'right',
                width : 600,
                split : true,
                frame : true,
               defaults : {
                anchor: '90%',
                border : false  
               },
                items : [{
							xtype : 'displayfield',
							fieldLabel : "提示",
							value:"由于更改“医院组默认医院”信息会对基础数据以及业务配置的取值带来重大影响，因此医院组默认医院信息的变动需特别慎重；如必须变更，需和公司产品部负责人联系，在达成更改必要性的一致意见后，由产品部提供相应的密码后进行更改。",
                            id:'tooltip2',
                            name : 'tooltip2'
                        },{
							xtype : 'textfield',
                            fieldLabel : "<span style='color:red;'>*</span>密码",
                            id:'Password2',
                            name : 'Password2',
							allowBlank : false,
							blankText: '请输入密码'
                        }]
            })],
        buttons : [{
            text : '确定',
            iconCls : 'icon-save',
            id:'subpass_btn2',
            disabled : Ext.BDP.FunLib.Component.DisableFlag('subpass_btn2'),
            handler : function() {
				if(Ext.getCmp("formpassword2").getForm().isValid()==false){
					 Ext.Msg.alert('提示','<font color = "red">请输入密码');
					 return;
				}
				if(passwordwin2.title=='删除操作：请输入密码'){
					var Tablecode = grid.getSelectionModel().getSelections()[0].get('ClassName');
					var Hospitaldesc = gridExceptionHosp.getSelectionModel().getSelections()[0].get('HospitalDR');
					var textPassword=Ext.getCmp("Password2").getValue();
					//产生密码所需信息：系统日期，当前登录医院代码，基础数据表代码/配置数据表代码，例外医院代码
					var passwordflag = tkMakeServerCall("web.DHCBL.BDP.BDPExceptionHosp","CheckDeletePassword",Tablecode,Hospitaldesc,textPassword);
					if (passwordflag==1)
					{
						Ext.Msg.alert('提示','<font color = "red">密码错误！');
						return;
					}
					//alert("密码正确！");
					passwordwin2.hide();
					
					//删除表结构登记界面的例外医院时，需要查询该表在私有数据关联医院中是否存在与【该例外医院】有对照的数据	2022-11-11
					var ExistFlag = tkMakeServerCall("web.DHCBL.BDP.BDPExceptionHosp","CheckExistTableHosp",Tablecode,Hospitaldesc);
					if (ExistFlag==1)
					{
						var confMsg="“"+Tablecode+"”表在“"+Hospitaldesc+"”医院中存在数据，建议先在维护界面将例外医院的数据删除再删除例外医院，是否现在删除例外医院？点击是将删除例外医院并且删除数据与例外医院的关联关系，并不删除“"+Tablecode+"”表中的数据";
						Ext.MessageBox.confirm('删除提示', confMsg, function(btn) {
							if (btn == 'yes') {
								var gsm = gridExceptionHosp.getSelectionModel();
								var rows = gsm.getSelections();
								Ext.Ajax.request({
									url : ExceptionHosp_DELETE_URL,
									method : 'POST',
									params : {
										'id' : rows[0].get('ID')
									},
									callback : function(options, success, response) {
										Ext.MessageBox.hide();
										if (success) {
											var jsonData = Ext.util.JSON.decode(response.responseText);
											if (jsonData.success == 'true') {
												tkMakeServerCall("web.DHCBL.BDP.BDPExceptionHosp","DeleteTableHospitals",Tablecode,Hospitaldesc);
												Ext.Msg.show({
													title : '提示',
													msg : '数据删除成功！',
													icon : Ext.Msg.INFO,
													buttons : Ext.Msg.OK,
													fn : function(btn){
														Ext.BDP.FunLib.DelForTruePage(gridExceptionHosp,pagesize);	
													}
												});
											} else {
												var errorMsg = '';
												if (jsonData.info) {
													errorMsg = '<br/>错误信息:'+ jsonData.info
												}
												Ext.Msg.show({
															title : '提示',
															msg : '数据删除失败！' + errorMsg,
															minWidth : 200,
															icon : Ext.Msg.ERROR,
															buttons : Ext.Msg.OK
														});
											}
										} else {
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
						}, this);
					}
					else{
						Ext.MessageBox.confirm('提示', '确定要删除所选的数据吗?', function(btn) {
							if (btn == 'yes') {
								var gsm = gridExceptionHosp.getSelectionModel();
								var rows = gsm.getSelections();
								Ext.Ajax.request({
									url : ExceptionHosp_DELETE_URL,
									method : 'POST',
									params : {
										'id' : rows[0].get('ID')
									},
									callback : function(options, success, response) {
										Ext.MessageBox.hide();
										if (success) {
											var jsonData = Ext.util.JSON.decode(response.responseText);
											if (jsonData.success == 'true') {
												Ext.Msg.show({
													title : '提示',
													msg : '数据删除成功！',
													icon : Ext.Msg.INFO,
													buttons : Ext.Msg.OK,
													fn : function(btn){
														Ext.BDP.FunLib.DelForTruePage(gridExceptionHosp,pagesize);	
													}
												});
											} else {
												var errorMsg = '';
												if (jsonData.info) {
													errorMsg = '<br/>错误信息:'+ jsonData.info
												}
												Ext.Msg.show({
															title : '提示',
															msg : '数据删除失败！' + errorMsg,
															minWidth : 200,
															icon : Ext.Msg.ERROR,
															buttons : Ext.Msg.OK
														});
											}
										} else {
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
						}, this);
					}
				}
				if(passwordwin2.title=='保存操作：请输入密码'){
					var Tablecode = grid.getSelectionModel().getSelections()[0].get('ClassName');
					var tempHospital = Ext.getCmp("Hosp-form-save").getForm().findField("HospitalDRF").getValue();
					var textPassword=Ext.getCmp("Password2").getValue();
					//产生密码所需信息：系统日期，当前登录医院代码，基础数据表代码/配置数据表代码，例外医院代码
					var passwordflag = tkMakeServerCall("web.DHCBL.BDP.BDPExceptionHosp","CheckPassword",Tablecode,tempHospital,textPassword);
					if (passwordflag==1)
					{
						Ext.Msg.alert('提示','<font color = "red">密码错误！');
						return;
					}
					//alert("密码正确！");
					passwordwin2.hide();
					
					if (Hospwin.title == "添加") {
						HospWinForm.form.submit({
							url : ExceptionHosp_SAVE_URL,
							clientValidation : true,
							waitTitle : '提示',
							waitMsg : '正在提交数据请稍候...',
							method : 'POST',
							success : function(form, action) {
								if (action.result.success == 'true') {
									Hospwin.hide();
									var myrowid = action.result.id;
									Ext.Msg.show({
												title : '提示',
												msg : '添加成功！',
												icon : Ext.Msg.INFO,
												buttons : Ext.Msg.OK,
												fn : function(btn) {
													gridExceptionHosp.getStore().baseParams = { // 解决gridExceptionHosp不能翻页的问题,和翻页、重置后显示空白的问题 13-9-23
														parref : Ext.getCmp("Hidden_ParRef").getValue()
													};
													gridExceptionHosp.getStore().load({
														params : {
																start : 0,
																limit : pagesize1
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
												msg : '添加失败！' + errorMsg,
												minWidth : 200,
												icon : Ext.Msg.ERROR,
												buttons : Ext.Msg.OK
											});
								}
							},
							failure : function(form, action) {
								Ext.Msg.alert('提示', '添加失败！');
							}
						})
					}
					else {
						Ext.MessageBox.confirm('提示', '确定要修改该条数据吗?', function(btn) {
							if (btn == 'yes') {
								HospWinForm.form.submit({
									url : ExceptionHosp_SAVE_URL,
									clientValidation : true,
									waitMsg : '正在提交数据请稍候...',
									waitTitle : '提示',
									method : 'POST',
									success : function(form, action) {
										if (action.result.success == 'true') {
											Hospwin.hide();
											var myrowid = "rowid="+action.result.id;
											Ext.Msg.show({
												title : '提示',
												msg : '修改成功！',
												icon : Ext.Msg.INFO,
												buttons : Ext.Msg.OK,
												fn : function(btn) {
													gridExceptionHosp.getStore().baseParams = { // 解决gridExceptionHosp不能翻页的问题,和翻页、重置后显示空白的问题 13-9-23
														parref : Ext.getCmp("Hidden_ParRef").getValue()
													};
													Ext.BDP.FunLib.ReturnDataForUpdate("gridExceptionHosp",ExceptionHosp_QUERY_URL,myrowid);
												}
											});
										} else {
											var errorMsg = '';
											if (action.result.errorinfo) {
												errorMsg = '<br/>错误信息:'
														+ action.result.errorinfo
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
										Ext.Msg.alert('提示', '修改失败！');
									}
								})
							}
						}, this);
					}
				}
            }
        }, {
            text : '关闭',
            iconCls : 'icon-close',
            handler : function() {
                passwordwin2.hide();
            }
        }],
		listeners:{
			"show":function(){
				Ext.getCmp("Password2").focus(true,300);
			},
			"hide" : function() {
					Ext.getCmp("Password2").reset();
				},
			"close":function(){
			}
		}
    });
	
	// 删除按钮
	var HospbtnDel = new Ext.Toolbar.Button({
		text : '删除',
		tooltip : '删除',
		iconCls : 'icon-delete',
		id : 'HospbtnDel',
		disabled : Ext.BDP.FunLib.Component.DisableFlag('HospbtnDel'),
		handler : function() {
			if (gridExceptionHosp.selModel.hasSelection()) {
				
				//密码校验	20200615	likefan
				var ExcepHospdesc = gridExceptionHosp.getSelectionModel().getSelections()[0].get('HospitalDR');
				var passwordflag = tkMakeServerCall("web.DHCBL.BDP.BDPExceptionHosp","DeletePasswordFlag",ExcepHospdesc);
				if (passwordflag==1){
					passwordwin2.setTitle('删除操作：请输入密码');
					passwordwin2.show();
					return;
				}
				
				Ext.MessageBox.confirm('提示', '确定要删除所选的数据吗?', function(btn) {
					if (btn == 'yes') {
						var gsm = gridExceptionHosp.getSelectionModel();
						var rows = gsm.getSelections();
						Ext.Ajax.request({
							url : ExceptionHosp_DELETE_URL,
							method : 'POST',
							params : {
								'id' : rows[0].get('ID')
							},
							callback : function(options, success, response) {
								Ext.MessageBox.hide();
								if (success) {
									var jsonData = Ext.util.JSON.decode(response.responseText);
									if (jsonData.success == 'true') {
										Ext.Msg.show({
											title : '提示',
											msg : '数据删除成功！',
											icon : Ext.Msg.INFO,
											buttons : Ext.Msg.OK,
											fn : function(btn){
												Ext.BDP.FunLib.DelForTruePage(gridExceptionHosp,pagesize);	
											}
										});
									} else {
										var errorMsg = '';
										if (jsonData.info) {
											errorMsg = '<br/>错误信息:'+ jsonData.info
										}
										Ext.Msg.show({
													title : '提示',
													msg : '数据删除失败！' + errorMsg,
													minWidth : 200,
													icon : Ext.Msg.ERROR,
													buttons : Ext.Msg.OK
												});
									}
								} else {
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
				}, this);
			} else {
				Ext.Msg.show({
							title : '提示',
							msg : '请选择需要删除的行！',
							icon : Ext.Msg.WARNING,
							buttons : Ext.Msg.OK
						});
			}
		}
	});

	// 增加修改的Form
	var HospWinForm = new Ext.FormPanel({
		id : 'Hosp-form-save',
		URL : ExceptionHosp_SAVE_URL,
		baseCls : 'x-plain',// form透明,不显示框框
		labelAlign : 'right',
		labelWidth : 120,
		split : true,
		frame : true,
		waitMsgTarget : true,
		reader : new Ext.data.JsonReader({
					root : 'list'
				}, [{
							name : 'ExceptionHospParRef',
							mapping : 'ExceptionHospParRef'
						},{
							name : 'ID',
							mapping : 'ID'
						}, {
							name : 'HospitalDR',
							mapping : 'HospitalDR'
						}, {
							name : 'ActiveFlag',
							mapping : 'ActiveFlag'
						}/*, {
							name : 'ActiveFrom',
							mapping : 'ActiveFrom'
						}, {
							name : 'ActiveTo',
							mapping : 'ActiveTo'
						}*/
					]),
		defaults : {
			anchor : '90%',
			bosrder : false
		},
		items : [{
					id : 'ExceptionHospParRef',
					xtype : 'textfield',
					fieldLabel : 'ParRef',
					name : 'ExceptionHospParRef',
					hideLabel : 'True',
					hidden : true
				}, {
					id : 'ID',
					xtype : 'textfield',
					fieldLabel : 'ID',
					name : 'ID',
					hideLabel : 'True',
					hidden : true
				}, {
					xtype:'bdpcombo',
					loadByIdParam : 'rowid',
					emptyText:'请选择',
					fieldLabel : '<font color=red>*</font>例外医院',
					name:'HospitalDR',
					id:'HospitalDRF',
					readOnly : Ext.BDP.FunLib.Component.DisableFlag('HospitalDRF'),
					style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('HospitalDRF')),
					//disabled : Ext.BDP.FunLib.Component.DisableFlag('HospitalDRF'),
					hiddenName : 'HospitalDR',
					forceSelection: true,
					queryParam:"desc",
					listWidth:300,
					//triggerAction : 'all',
					selectOnFocus:false,
					allowBlank:false,
					blankText: '例外医院不能为空',
					mode:'remote',
					pageSize: Ext.BDP.FunLib.PageSize.Combo,
					displayField : 'HOSPDesc',
					valueField : 'HOSPRowId',
					listWidth : 270,//下拉框宽度
					store : new Ext.data.JsonStore({
						//autoLoad : true,
						url : Hospital_DR_URL,
						baseParams:{communityid:communityid},
						root : 'data',
						totalProperty : 'total',
						idProperty : 'HOSPRowId',
						fields : ['HOSPRowId', 'HOSPDesc'],
						remoteSort : true,
						sortInfo : {
							field : 'HOSPRowId',
							direction : 'ASC'
						}
					})
				},/*{
					xtype : 'datefield',
					fieldLabel : '<font color=red>*</font>过滤启用开始日期',
					name :'ActiveFrom',
					id:'ActiveFromF',
					style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('ActiveFromF')),
					readOnly : Ext.BDP.FunLib.Component.DisableFlag('ActiveFromF'),
					//disabled : Ext.BDP.FunLib.Component.DisableFlag('ActiveFromF'),
					format : BDPDateFormat,
					allowBlank:false,
					enableKeyEvents : true,
					listeners : {   'keyup' : function(field, e){	 Ext.BDP.FunLib.Component.GetCurrentDate(field,e);  }},
					blankText: '过滤启用开始日期不能为空'
				}, {
					xtype : 'datefield',
					fieldLabel : '过滤启用结束日期',
					name : 'ActiveTo',
					id:'ActiveToF',
					style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('ActiveToF')),
					readOnly : Ext.BDP.FunLib.Component.DisableFlag('ActiveToF'),
					//disabled : Ext.BDP.FunLib.Component.DisableFlag('ActiveToF'),
					format : BDPDateFormat,
					enableKeyEvents : true,
					listeners : {   'keyup' : function(field, e){	 Ext.BDP.FunLib.Component.GetCurrentDate(field,e);  }}
					//editable:false
				},*/{ 							 
					fieldLabel : '是否启用',
					name :'ActiveFlag',
					id:'ActiveFlagF',
					style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('ActiveFlagF')),
					readOnly : Ext.BDP.FunLib.Component.DisableFlag('ActiveFlagF'),
					//disabled : Ext.BDP.FunLib.Component.DisableFlag('ActiveFlagF'),
					xtype:'checkbox',
					autoHeight:'true',
					inputValue : true?'Y':'N',
					checked : true
				}]
	});

	// 增加修改时弹出窗口
	var Hospwin = new Ext.Window({
		title : '',
		width : 390,
		height : 180,
		layout : 'fit',
		closeAction : 'hide',
		plain : true,// true则主体背景透明
		modal : true,
		frame : true,
		autoScroll : true,
		collapsible : true,
		hideCollapseTool : true,
		titleCollapse : true,
		bodyStyle : 'padding:3px',
		buttonAlign : 'center',
		items : HospWinForm,
		buttons : [{
			text : '保存',
			id : 'Hosp_savebtn',
			iconCls : 'icon-save',
			disabled : Ext.BDP.FunLib.Component.DisableFlag('Hosp_savebtn'),
			handler : function() {
				var tempHospital = Ext.getCmp("Hosp-form-save").getForm().findField("HospitalDRF").getValue();
				if (tempHospital=="") {
					Ext.Msg.show({ title : '提示', msg : '例外医院不能为空！', minWidth : 200, icon : Ext.Msg.ERROR, buttons : Ext.Msg.OK });
					return;
				}
				if(HospWinForm.getForm().isValid()==false){
					 Ext.Msg.alert('提示','<font color = "red">数据验证失败，<br />请检查您的数据格式是否有误！');
					 return;
				}
				
				//密码校验	20200615	likefan
				var tempID = Ext.getCmp("Hosp-form-save").getForm().findField("ID").getValue();
				var tempActiveFlag = Ext.getCmp("ActiveFlagF").getValue();
				var passwordflag = tkMakeServerCall("web.DHCBL.BDP.BDPExceptionHosp","SavePasswordFlag",tempID,tempHospital,tempActiveFlag);
				if (passwordflag==1){
					passwordwin2.setTitle('保存操作：请输入密码');
					passwordwin2.show();
					return;
				}
				
				if (Hospwin.title == "添加") {
					HospWinForm.form.submit({
						url : ExceptionHosp_SAVE_URL,
						clientValidation : true,
						waitTitle : '提示',
						waitMsg : '正在提交数据请稍候...',
						method : 'POST',
						success : function(form, action) {
							if (action.result.success == 'true') {
								Hospwin.hide();
								var myrowid = action.result.id;
								Ext.Msg.show({
											title : '提示',
											msg : '添加成功！',
											icon : Ext.Msg.INFO,
											buttons : Ext.Msg.OK,
											fn : function(btn) {
												gridExceptionHosp.getStore().baseParams = { // 解决gridExceptionHosp不能翻页的问题,和翻页、重置后显示空白的问题 13-9-23
													parref : Ext.getCmp("Hidden_ParRef").getValue()
												};
												gridExceptionHosp.getStore().load({
													params : {
															start : 0,
															limit : pagesize1
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
											msg : '添加失败！' + errorMsg,
											minWidth : 200,
											icon : Ext.Msg.ERROR,
											buttons : Ext.Msg.OK
										});
							}
						},
						failure : function(form, action) {
							Ext.Msg.alert('提示', '添加失败！');
						}
					})
				}
				else {
					Ext.MessageBox.confirm('提示', '确定要修改该条数据吗?', function(btn) {
						if (btn == 'yes') {
							HospWinForm.form.submit({
								url : ExceptionHosp_SAVE_URL,
								clientValidation : true,
								waitMsg : '正在提交数据请稍候...',
								waitTitle : '提示',
								method : 'POST',
								success : function(form, action) {
									if (action.result.success == 'true') {
										Hospwin.hide();
										var myrowid = "rowid="+action.result.id;
										Ext.Msg.show({
											title : '提示',
											msg : '修改成功！',
											icon : Ext.Msg.INFO,
											buttons : Ext.Msg.OK,
											fn : function(btn) {
												gridExceptionHosp.getStore().baseParams = { // 解决gridExceptionHosp不能翻页的问题,和翻页、重置后显示空白的问题 13-9-23
													parref : Ext.getCmp("Hidden_ParRef").getValue()
												};
												Ext.BDP.FunLib.ReturnDataForUpdate("gridExceptionHosp",ExceptionHosp_QUERY_URL,myrowid);
											}
										});
									} else {
										var errorMsg = '';
										if (action.result.errorinfo) {
											errorMsg = '<br/>错误信息:'
													+ action.result.errorinfo
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
									Ext.Msg.alert('提示', '修改失败！');
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
				Hospwin.hide();
			}
		}],
		listeners : {
			"show" : function() {
			},
			"hide" : function() {
				Ext.BDP.FunLib.Component.FromHideClearFlag();
				HospWinForm.getForm().reset();
			},
			"close" : function() {
			}
		}
	});

	// 增加按钮
	var HospbtnAdd = new Ext.Toolbar.Button({
		text : '添加',
		tooltip : '添加',
		iconCls : 'icon-add',
		id : 'HospbtnAdd',
		disabled : Ext.BDP.FunLib.Component.DisableFlag('HospbtnAdd'),
		handler : function() {
			Hospwin.setTitle('添加');
			Hospwin.setIconClass('icon-add');
			Hospwin.show();
			HospWinForm.getForm().reset();
			Ext.getCmp("ExceptionHospParRef").setValue(Ext.getCmp("Hidden_ParRef").getValue())
		},
		scope : this
	});

	// 修改按钮
	var HospbtnEdit = new Ext.Toolbar.Button({
				text : '修改',
				tooltip : '修改',
				iconCls : 'icon-update',
				id : 'HospbtnUpdate',
				disabled : Ext.BDP.FunLib.Component.DisableFlag('HospbtnUpdate'),
				handler : function() {
					if (gridExceptionHosp.selModel.hasSelection()) {
						Hospwin.setTitle('修改');
						Hospwin.setIconClass('icon-update');
						Hospwin.show();
						loadHospFormData(gridExceptionHosp);
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
		// 刷新工作条
	var HospbtnRefresh = new Ext.Button({
				id : 'HospbtnRefresh',
				disabled : Ext.BDP.FunLib.Component.DisableFlag('HospbtnRefresh'),
				tooltip : '重置',
				iconCls : 'icon-refresh',
				text : '重置',
				handler : function() {
					
					gridExceptionHosp.getStore().baseParams={  //解决gridExceptionHosp不能翻页的问题,和翻页、重置后显示空白的问题 13-9-23
								parref : Ext.getCmp("Hidden_ParRef").getValue()
					};
					gridExceptionHosp.getStore().load({
						params : {
								start : 0,
								limit : pagesize1
						}
					});
				}
	});
	var Hospds = new Ext.data.Store({
		proxy : new Ext.data.HttpProxy({
					url : ExceptionHosp_QUERY_URL
				}),
		reader : new Ext.data.JsonReader({
					totalProperty : 'total',
					root : 'data',
					successProperty : 'success'
				}, [{
						name : 'ID',
						mapping : 'ID',
						type : 'string'
					}, {
						name : 'HospitalDR',
						mapping : 'HospitalDR',
						type : 'string'
					}, {
						name : 'ActiveFlag',
						mapping : 'ActiveFlag',
						type : 'string'
					}/*, {
						name : 'ActiveFrom',
						mapping : 'ActiveFrom',
						type : 'string'
					}, {
						name : 'ActiveTo',
						mapping : 'ActiveTo',
						type : 'string'
					}*/])
	});

	// 加载数据
	Hospds.load({
				params : {
					start : 0,
					limit : pagesize1
				},
				callback : function(records, options, success) {
				}
			});

	// 分页工具条
	var Hosppaging = new Ext.PagingToolbar({
				pageSize : pagesize1,
				store : Hospds,
				displayInfo : true,
				displayMsg : '显示第 {0} 条到 {1} 条记录, 一共 {2} 条',
				emptyMsg : "没有记录",
				plugins : [new Ext.BDP.FunLib.PagingToolbarResizer()],
				listeners : {
				          "change":function (t,p)
				         { 
				             pagesize1 = this.pageSize;
				         }
		        }
			});

	var Hospsm = new Ext.grid.CheckboxSelectionModel({
				singleSelect : true,
				checkOnly : false,
				width : 20
			});

	// 增删改工具条
	var Hosptbbutton = new Ext.Toolbar({
				enableOverflow : true,
				items : [HospbtnAdd, '-', HospbtnEdit, '-',
						HospbtnDel, '-',HospbtnRefresh,{
							xtype : 'textfield',
							hidden:true,
							id:'Hidden_ParRef'
						},'-']
			});

	// 创建Grid
	var gridExceptionHosp = new Ext.grid.GridPanel({
				id : 'gridExceptionHosp',
				region : 'center',
				width : 560,
				height : 370,
				closable : true,
				store : Hospds,
				trackMouseOver : true,
				columns : [Hospsm, {
							header : 'ID',
							width : 70,
							sortable : true,
							dataIndex : 'ID',
							hidden : true
						},{
							header : '例外医院',
							width : 120,
							sortable : true,
							dataIndex : 'HospitalDR'
						},{
							header : '是否启用',
							width : 80,
							sortable : true,
							dataIndex : 'ActiveFlag',
							renderer : Ext.BDP.FunLib.Component.ReturnFlagIcon
						}/*,{
							header : '过滤启用开始日期',
							width : 80,
							sortable : true,
							dataIndex : 'ActiveFrom'
						},{
							header : '过滤启用结束日期',
							width : 80,
							sortable : true,
							dataIndex : 'ActiveTo'
						}*/],
				stripeRows : true,
				loadMask : {
					msg : '数据加载中,请稍候...'
				},
				stateful : true,
				viewConfig : {
					forceFit : true
				},
				bbar : Hosppaging,
				tbar : Hosptbbutton,
				stateId : 'gridExceptionHosp'
			});
	//Ext.BDP.FunLib.ShowUserHabit(gridExceptionHosp,"User.BDPExceptionHosp");

	// 载入被选择的数据行的表单数据
	var loadHospFormData = function(gridExceptionHosp) {
		var _record = gridExceptionHosp.getSelectionModel().getSelected();
		if (!_record) {
			// Ext.Msg.alert('修改','请选择要修改的一项！');
		} else {
			HospWinForm.form.load({
						url : ExceptionHosp_OPEN_URL + '&id='+ _record.get('ID'),
						// waitMsg : '正在载入数据...',
						success : function(form, action) {
							// Ext.Msg.alert('编辑','载入成功！');
						},
						failure : function(form, action) {
							Ext.Msg.alert('编辑', '载入失败！');
						}
					});
		}
	};

	gridExceptionHosp.on("rowdblclick", function(grid, rowIndex, e) {
		
				Hospwin.setTitle('修改');
				Hospwin.setIconClass('icon-update');
				Hospwin.show();
				loadHospFormData(gridExceptionHosp);
			});


	var winExceptionHosp = new Ext.Window({
			title:'',
			width:700,
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
			items: gridExceptionHosp,
			listeners:{
				"show":function(){
				},
				"hide":function(){
				},
				"close":function(){
				}
			}
		});

	var btnExceptionHosp = new Ext.Toolbar.Button({				
	    text: '设置例外医院',
	    id:'btnExceptionHosp',
	    disabled : Ext.BDP.FunLib.Component.DisableFlag('btnExceptionHosp'),
        iconCls: 'icon-AdmType',
		tooltip: '设置例外医院',
		handler: CTLocLinkSpNurWinEdit = function() {   
    	var _record = grid.getSelectionModel().getSelected();
			if(_record){
				winExceptionHosp.setTitle('例外医院');
				winExceptionHosp.setIconClass('icon-AdmType');
				winExceptionHosp.show('');
				var gsm = grid.getSelectionModel();//获取选择列
				var rows = gsm.getSelections();//根据选择列获取到所有的行 
				var ID=rows[0].get('ID');
				Ext.getCmp("Hidden_ParRef").reset();
				Ext.getCmp("Hidden_ParRef").setValue(ID); 
				gridExceptionHosp.getStore().baseParams={parref:ID};
				gridExceptionHosp.getStore().load({params:{start:0, limit:Ext.BDP.FunLib.PageSize.Pop}});
				Ext.getCmp("HospitalDRF").getStore().load();
			}
	        else
			{
				Ext.Msg.show({
						title:'提示',
						msg:'请选择一条数据!',
						icon:Ext.Msg.WARNING,
						buttons:Ext.Msg.OK
					});
			}		
        }
	});
	
/**********************************设置例外医院按钮**完******************************/	


/**********************************数据维护权限 按钮****2021-09-05****************************/	
	var OPENRights_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.BDP.BDPTableList&pClassMethod=OpenRightsData";
	//var SAVERights_ACTION_URL = "../csp/dhc.bdp.ext.entitydatatrans.csp?pClassName=web.DHCBL.BDP.BDPTableList&pClassMethod=SaveEntity&pEntityName=web.Entity.CT.DHCTarItem";
	
	///密码弹窗部分
	//定义全局变量，用于传到弹窗中
	var win3Flag=0;
	//数据维护权限修改-密码弹窗定义	2021-09-05	likefan
	var passwordwin3 = new Ext.Window({
        width : 600,
		title : '请输入密码',
        height : 230,
        layout : 'fit',
        plain : true, 
        modal : true,
        frame : true,
        collapsible : true,
        constrain : true,
        hideCollapseTool : true,
        titleCollapse : true,
        bodyStyle : 'padding:3px',
        buttonAlign : 'center',
        closeAction : 'hide',
        labelWidth : 50,
        items : [new Ext.form.FormPanel({
                id : 'formpassword3',
                labelAlign : 'right',
                width : 600,
                split : true,
                frame : true,
               defaults : {
                anchor: '90%',
                border : false  
               },
                items : [{
							xtype : 'displayfield',
							fieldLabel : "提示",
							value:"由于更改“数据维护权限”信息会对业务配置或基础数据的取值带来重大影响，因此信息的变动需特别慎重；如必须变更，需和公司产品部负责人联系，在达成更改必要性的一致意见后，由产品部提供相应的密码后进行更改。",
                            id:'tooltip3',
                            name : 'tooltip3'
                        },{
							xtype : 'textfield',
                            fieldLabel : "<span style='color:red;'>*</span>密码",
                            id:'Password3',
                            name : 'Password3',
							allowBlank : false,
							blankText: '请输入密码'
                        }]
            })],
        buttons : [{
            text : '确定',
            iconCls : 'icon-save',
            id:'subpass3_btn',
            disabled : Ext.BDP.FunLib.Component.DisableFlag('subpass3_btn'),
            handler : function() {
				if(Ext.getCmp("formpassword3").getForm().isValid()==false){
					 Ext.Msg.alert('提示','<font color = "red">请输入密码');
					 return;
				}
				var Tablecode = grid.getSelectionModel().getSelections()[0].get('ClassName');
				var textPassword=Ext.getCmp("Password3").getValue();
				//产生密码所需信息：系统日期，当前登录医院代码，基础数据表代码/配置数据表代码
				var passwordflag = tkMakeServerCall("web.DHCBL.BDP.BDPTableList","CheckPassword",Tablecode,textPassword);
				if (passwordflag==1)
				{
					Ext.Msg.alert('提示','<font color = "red">密码错误！');
					return;
				}
				//alert("密码正确！");
				passwordwin3.hide();
				
				var ID=grid.getSelectionModel().getSelections()[0].get('ID');
				var BanAdd=Ext.getCmp("BanAdd").getValue();
				var BanUpdate=Ext.getCmp("BanUpdate").getValue();
				var BanDelete=Ext.getCmp("BanDelete").getValue();
				//alert(ID+"^"+BanAdd+"^"+BanUpdate+"^"+BanDelete);
				var result=tkMakeServerCall("web.DHCBL.BDP.BDPTableList","UpdateAUDRights",ID,BanAdd,BanUpdate,BanDelete);
				
				if (result == '0') {
					winAUDControlRights.hide();
					Ext.Msg.show({
						title : '提示',
						msg : '修改成功!',
						icon : Ext.Msg.INFO,
						buttons : Ext.Msg.OK,
						fn : function(btn) {
							
						}
					});
				}else{
					Ext.Msg.show({
						title : '提示',
						msg : '修改失败!',
						minWidth : 200,
						icon : Ext.Msg.ERROR,
						buttons : Ext.Msg.OK
					});
				}
            }
        }, {
            text : '关闭',
            iconCls : 'icon-close',
            handler : function() {
                passwordwin3.hide();
            }
        }],
		listeners:{
			"show":function(){
				Ext.getCmp("Password3").focus(true,300);
			},
			"hide" : function() {
					Ext.getCmp("Password3").reset();
				},
			"close":function(){
			}
		}
    });
	
	// 定义winform
	var WinFormRights = new Ext.FormPanel({
				id : 'form-save',
				//title : '权限修改',
				baseCls : 'x-plain',
				URL : '',
				labelAlign : 'right',
				labelWidth : 45,
				split : true,
				frame : true,
				defaults : {
					anchor : '85%',
					bosrder : false
				},
				waitMsgTarget : true,
       			reader: new Ext.data.JsonReader({root:'list'},
                                        [
										 {name: 'BanAdd',mapping:'BanAdd'},
										 {name: 'BanUpdate',mapping:'BanUpdate'},
                                         {name: 'BanDelete',mapping:'BanDelete'}
                                        ]),
				items : [{
							boxLabel : '禁用新增',
							name :'BanAdd',
							id:'BanAdd',
							style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('BanAdd')),
							readOnly : Ext.BDP.FunLib.Component.DisableFlag('BanAdd'),
							xtype:'checkbox',
							//autoHeight:'true',
							inputValue : true?'Y':'N'
						},{
							boxLabel : '禁用修改',
							name :'BanUpdate',
							id:'BanUpdate',
							//height:20,
							style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('BanUpdate')),
							readOnly : Ext.BDP.FunLib.Component.DisableFlag('BanUpdate'),
							xtype:'checkbox',
							//autoHeight:'true',
							inputValue : true?'Y':'N'
						},{
							boxLabel : '禁用删除',
							name :'BanDelete',
							id:'BanDelete',
							style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('BanDelete')),
							readOnly : Ext.BDP.FunLib.Component.DisableFlag('BanDelete'),
							xtype:'checkbox',
							//autoHeight:'true',
							inputValue : true?'Y':'N'
						}]	
	});
	
	
	// 定义窗口
	var winAUDControlRights = new Ext.Window({
		title : '',
		width : 200,
		height:170,
		layout : 'fit',
		plain : true,
		modal : true,
		frame : true,
		autoScroll : true,
		collapsible : true,
		hideCollapseTool : true,
		titleCollapse : true,
		bodyStyle : 'padding:3px',
		buttonAlign : 'center',
		closeAction : 'hide',
		items : [WinFormRights],
		buttons : [{
			text : '保存',
			iconCls : 'icon-save',
			id:'saverights_btn',
			disabled : Ext.BDP.FunLib.Component.DisableFlag('saverights_btn'),
			handler : function() { 
				passwordwin3.setTitle('请输入密码');
				passwordwin3.show();
			}
		}, {
			text : '关闭',
			iconCls : 'icon-close',
			handler : function() {
				winAUDControlRights.hide();
			}
		}],
		listeners : {
			"show" : function() {
				
			},
			"hide" : function() {
				WinFormRights.getForm().reset();
			},
			"close" : function() {
			}
		}
	});
	
	// 定义按钮
	var btnAUDControlRights = new Ext.Toolbar.Button({				
	    text: '数据维护权限',
	    id:'btnAUDControlRights',
	    disabled : Ext.BDP.FunLib.Component.DisableFlag('btnAUDControlRights'),
        iconCls: 'icon-AdmType',
		tooltip: '数据维护权限',
		handler: CTLocLinkSpNurWinEdit = function() {   
    	var _record = grid.getSelectionModel().getSelected();
			if(_record){
				winAUDControlRights.setTitle('数据维护权限');
				winAUDControlRights.setIconClass('icon-AdmType');
				winAUDControlRights.show('');
				
				WinFormRights.form.load({
                url : OPENRights_ACTION_URL + '&id='+ _record.get('ID'),
                //waitMsg : '正在载入数据...',
                success : function(form,action) {
                	//Ext.Msg.alert('编辑','载入成功！');
                },
                failure : function(form,action) {
                	Ext.Msg.alert('编辑','载入失败！');
                }
            });
				
				
			}
	        else
			{
				Ext.Msg.show({
						title:'提示',
						msg:'请选择一条数据!',
						icon:Ext.Msg.WARNING,
						buttons:Ext.Msg.OK
					});
			}		
        }
	});
	
/**********************************数据维护权限按钮**完***2021-09-05***************************/	


	/*******************************增删改工具条*******************************/
	var tbbutton = new Ext.Toolbar({
		items : [btnAddwin, '-', btnDel,'-',btnExceptionHosp,'-',btnAUDControlRights,'->',exportBtn] //, '-',importBtn]			                  
		});
	
	/********************************搜索按钮*********************************/
	var btnSearch = new Ext.Button({
				id : 'btnSearch',
				disabled : Ext.BDP.FunLib.Component.DisableFlag('btnSearch'),
				iconCls : 'icon-search',
				text : '搜索',
				handler : search = function() {                                  
					grid.getStore().baseParams={
						    code : Ext.getCmp("TextCode").getValue(), 	
							desc : Ext.getCmp("TextDesc").getValue(),
							table : Ext.getCmp("TextTable").getValue(),
							attribute : Ext.getCmp("TextAttribute").getValue(),
							datatype : Ext.getCmp("TextDataType").getValue(),
							type : Ext.getCmp("TextType").getValue(),
							standarddatatype : Ext.getCmp("TextStandardDataVersion").getValue()
					};
					grid.getStore().load({									 
						params : {
							start : 0,
							limit : pagesize_main
						},
						callback : function(records, options, success) {					
							// Ext.Msg.alert('info', '加载完毕, success = '+records.length);
							clearSubWin();
						}
					});
				}
			});		
	/******************************刷新按钮****************************************/
	var btnRefresh = new Ext.Button({
				id : 'btnRefresh',
				disabled : Ext.BDP.FunLib.Component.DisableFlag('btnRefresh'),
				iconCls : 'icon-refresh',
				text : '重置',
				handler : function() {
					Ext.getCmp("TextCode").reset();
					Ext.getCmp("TextDesc").reset(); 
					Ext.getCmp("TextTable").reset();
					Ext.getCmp("TextAttribute").reset();
					Ext.getCmp("TextDataType").reset();
					Ext.getCmp("TextType").reset();
					Ext.getCmp("TextStandardDataVersion").reset();
					grid.getStore().baseParams={};
					grid.getStore().load({                               
								params : {
											start : 0,
											limit : pagesize_main
										},
								callback : function(records, options, success) {					
									// Ext.Msg.alert('info', '加载完毕, success = '+records.length);
									clearSubWin();
								}
							}); 
						}
				});		
	/*************************将工具条放在一起************************************/
	var tb = new Ext.Toolbar({
				id : 'tb',
				items : ['类名', {
							xtype : 'textfield',
							id : 'TextCode',
							disabled : Ext.BDP.FunLib.Component.DisableFlag('TextCode'),
							width:90
						},'-','表名(代码)', {
							xtype : 'textfield',
							id : 'TextTable',
							disabled : Ext.BDP.FunLib.Component.DisableFlag('TextTable'),
							width:90
						},'-','中文名', {
							xtype : 'textfield',
							id : 'TextDesc',
							disabled : Ext.BDP.FunLib.Component.DisableFlag('TextDesc'),
							width:90
						},'-','属性',{
							xtype : 'combo',
							id : 'TextAttribute',
							disabled : Ext.BDP.FunLib.Component.DisableFlag('TextAttribute'),
							width : 70,
							mode : 'local',
							triggerAction : 'all',
							forceSelection : true,
							selectOnFocus : false,
							listWidth : 70,
							shadow : false,
							valueField : 'value',
							displayField : 'name',
							// editable:false,
							store : new Ext.data.JsonStore({
										fields : ['name', 'value'],
										data : [{
													value : '基础数据',
													name : '基础数据'
												}, {
													value : '配置数据',
													name : '配置数据'
												}]
									}),
							listeners:{
							   'select': function(field,e){
							        search() 
			                 	},
								scope: this
							}
						},'-','公/私/管控类型',{
							xtype : 'combo',
							id : 'TextDataType',
							disabled : Ext.BDP.FunLib.Component.DisableFlag('TextDataType'),
							width : 70,
							mode : 'local',
							triggerAction : 'all',
							forceSelection : true,
							selectOnFocus : false,
							listWidth : 70,
							shadow : false,
							valueField : 'value',
							displayField : 'name',
							// editable:false,
							store : new Ext.data.JsonStore({
										fields : ['name', 'value'],
										data : [{
													value : 'G',
													name : '公有'
												}, {
													value : 'S',
													name : '私有'
												}, {
													value : 'C',
													name : '管控'
												}, {
													value : 'A',
													name : '绝对私有'
												}]
									}),
							listeners:{
							   'select': function(field,e){
							        search() 
			                 	},
								scope: this
							}
						},'-','标准数据类型',{
							xtype : 'combo',
							id : 'TextStandardDataVersion',
							disabled : Ext.BDP.FunLib.Component.DisableFlag('TextStandardDataVersion'),
							width : 70,
							mode : 'local',
							triggerAction : 'all',
							forceSelection : true,
							selectOnFocus : false,
							listWidth : 70,
							shadow : false,
							valueField : 'value',
							displayField : 'name',
							// editable:false,
							store : new Ext.data.JsonStore({
										fields : ['name', 'value'],
										data : [{
													value : '国标',
													name : '国标'
												}, {
													value : '行标',
													name : '行标'
												}, {
													value : '省标',
													name : '省标'
												}, {
													value : '企标',
													name : '企标'
												}]
									}),
							listeners:{
							   'select': function(field,e){
							        search() 
			                 	},
								scope: this
							}
						},'-','产品组', {
							xtype : 'textfield',
							id : 'TextType',
							disabled : Ext.BDP.FunLib.Component.DisableFlag('TextType'),
							width:90
						},'-',btnSearch, '-',btnRefresh, '->'],
				listeners : {                                        
					render : function() {                             
						tbbutton.render(grid.tbar)                    
					}
				}
			});
			
	/***************************************创建grid******************************************/
	var grid = new Ext.grid.GridPanel({
				id : 'grid',
				region : 'center',
				width : 500,
				split: true,
				height : 500,
				plugins: [editor],                                   
				store : ds,											 
				//collapsible: true, 往上收缩按钮
				trackMouseOver : true,                               
				columns : [sm, {									 
							header : 'ID',
							dataIndex : 'ID',
							width :60,
							hidden : true                           
						}, {
							width :140,
							header : '类名',
							dataIndex : 'TableName',
							editor:{
								id:'TableNameF',
								disabled:Ext.BDP.FunLib.Component.DisableFlag('TableNameF'),
								xtype:'textfield',
								allowBlank:false
							}
						}, {
							width :140,
							header : '表名（代码）',
							dataIndex : 'ClassName',
							editor:{
								id:'ClassNameF',
								disabled:Ext.BDP.FunLib.Component.DisableFlag('ClassNameF'),
								xtype:'textfield',
								allowBlank:false
							}
						
						}, {
							width :140,
							header : '中文名',
							dataIndex : 'TableDesc',
							editor:{
								id:'TableDescF',
								disabled:Ext.BDP.FunLib.Component.DisableFlag('TableDescF'),
								xtype: 'textfield',
								allowBlank : false
							}
						},{
							width :120,
							header : '属性',
							dataIndex : 'Attribute',
							editor : new Ext.form.ComboBox({ 
									id:'AttributeF',
									disabled:Ext.BDP.FunLib.Component.DisableFlag('AttributeF'),
									triggerAction : 'all',
									forceSelection : true,
									displayField : 'display', 
									valueField : 'value', 
									mode : 'local',  
									lazyRender : true,
									allowBlank:false,
								    store: new Ext.data.SimpleStore({
										fields : ['value','display'],
								        data: [['基础数据', '基础数据'], ['配置数据', '配置数据']]
								    })
							})
						},{
							width :100,
							header : '产品组',
							dataIndex : 'Type',
							editor:{
								id:'TypeF',
								disabled:Ext.BDP.FunLib.Component.DisableFlag('TypeF'),
								allowBlank:false,
								xtype: 'textfield'
							}
						},{
							width :120,
							header : '公/私/管控类型',
							dataIndex : 'DataType',
							editor : new Ext.form.ComboBox({ 
									id:'DataTypeF',
									disabled:Ext.BDP.FunLib.Component.DisableFlag('DataTypeF'),
									allowBlank:false,
									triggerAction : 'all',
									forceSelection : true,
									displayField : 'display', 
									valueField : 'value', 
									mode : 'local',  
									lazyRender : true,
								    store: new Ext.data.SimpleStore({
										fields : ['value','display'],
								        data: [['G', '公有'], ['S', '私有'] 
								        , ['C', '管控'], ['A', '绝对私有']
								      ]
								    })
							}),
							renderer : function(v){
								if(v=='G'){return '公有';} 
								else if(v=='S'){return '私有';}
								else if(v=='C'){return '管控';}
								else if(v=='A'){return '绝对私有';}
								else{return v;}
								
							}	
						},{
							width :180,
							header : '使用公共私有数据关联表',
							dataIndex : 'MappingHospFlag',
							renderer : Ext.BDP.FunLib.Component.ReturnFlagIcon,
							editor : new Ext.form.ComboBox({ 
									id:'MappingHospFlagF',
									disabled:Ext.BDP.FunLib.Component.DisableFlag('MappingHospFlagF'),
									allowBlank:false,
									triggerAction : 'all',
									forceSelection : true,
									displayField : 'display', 
									valueField : 'value', 
									mode : 'local',  
									lazyRender : true,
								    store: new Ext.data.SimpleStore({
										fields : ['value','display'],
								        data: [['Y', 'Yes'], ['N', 'No']]
								    })
							})
						},{
							width :120,
							header : '标准数据类型',
							dataIndex : 'StandardDataType',
							editor : new Ext.form.ComboBox({ 
									id:'StandardDataTypeF',
									disabled:Ext.BDP.FunLib.Component.DisableFlag('StandardDataTypeF'),
									triggerAction : 'all',
									forceSelection : true,
									displayField : 'display', 
									valueField : 'value', 
									mode : 'local',  
									lazyRender : true,
								    store: new Ext.data.SimpleStore({
										fields : ['value','display'],
								        data: [['国标', '国标'], 
											['行标', '行标'], 
											['省标', '省标'], 
											['企标', '企标']]
								    })
							})
						}, {
							width :120,
							header : '标准数据版本',
							dataIndex : 'StandardDataVersion',
							editor:{
								id:'StandardDataVersionF',
								disabled:Ext.BDP.FunLib.Component.DisableFlag('StandardDataVersionF'),
								xtype: 'textfield'
							}
						},{
							width :120,
							header : '数据维护权限',
							dataIndex : 'AUDControlRights',
							renderer : Ext.BDP.FunLib.Component.ReturnFlagIcon,
							editor : new Ext.form.ComboBox({ 
									id:'AUDControlRightsF',
									disabled:Ext.BDP.FunLib.Component.DisableFlag('AUDControlRightsF'),
									triggerAction : 'all',
									forceSelection : true,
									displayField : 'display', 
									valueField : 'value', 
									mode : 'local',  
									lazyRender : true,
								    store: new Ext.data.SimpleStore({
										fields : ['value','display'],
								        data: [['Y', 'Yes'], ['N', 'No']]
								    })
							})
						/*},{
							width :100,
							header : '是否特别',
							dataIndex : 'SpecialFlag',
							renderer : Ext.BDP.FunLib.Component.ReturnFlagIcon,
							editor : new Ext.form.ComboBox({ 
									id:'SpecialFlagF',
									disabled:Ext.BDP.FunLib.Component.DisableFlag('SpecialFlagF'),
									triggerAction : 'all',
									forceSelection : true,
									displayField : 'display', 
									valueField : 'value', 
									mode : 'local',  
									lazyRender : true,
								    store: new Ext.data.SimpleStore({
										fields : ['value','display'],
								        data: [['Y', 'Yes'], ['N', 'No']]
								    })
							})*/
						},{
							width :120,
							header : '是否区分版本',
							hidden : true,
							dataIndex : 'VersionFlag',
							renderer : Ext.BDP.FunLib.Component.ReturnFlagIcon,
							editor : new Ext.form.ComboBox({ 
									id:'VersionFlagF',
									disabled:Ext.BDP.FunLib.Component.DisableFlag('VersionFlagF'),
									triggerAction : 'all',
									forceSelection : true,
									displayField : 'display', 
									valueField : 'value', 
									mode : 'local',  
									lazyRender : true,
								    store: new Ext.data.SimpleStore({
										fields : ['value','display'],
								        data: [['Y', 'Yes'], ['N', 'No']]
								    })
							})
						},{
							width :120,
							header : '是否数据来源',
							dataIndex : 'Sources',
							renderer : Ext.BDP.FunLib.Component.ReturnFlagIcon,
							editor : new Ext.form.ComboBox({ 
									id:'SourcesF',
									disabled:Ext.BDP.FunLib.Component.DisableFlag('SourcesF'),
									triggerAction : 'all',
									forceSelection : true,
									displayField : 'display', 
									valueField : 'value', 
									mode : 'local',  
									lazyRender : true,
								    store: new Ext.data.SimpleStore({
										fields : ['value','display'],
								        data: [['Y', 'Yes'], ['N', 'No']]
								    })
							})
						}, {
							width :400,
							header : 'Global',
							dataIndex : 'TableGlobal',
							editor:{
								id:'TableGlobalF',
								disabled:Ext.BDP.FunLib.Component.DisableFlag('TableGlobalF'),
								xtype:'textfield'
							}
						}, {
							width :200,
							header : '描述在表里的字段名',
							dataIndex : 'DescPropertyName',
							editor:{
								id:'DescPropertyNameF',
								disabled:Ext.BDP.FunLib.Component.DisableFlag('DescPropertyNamef'),
								xtype: 'textfield'
							}
						}, {
							width :200,
							header : '代码在表里的字段名',
							dataIndex : 'CodePropertyName',
							editor:{
								id:'CodePropertyNameF',
								disabled:Ext.BDP.FunLib.Component.DisableFlag('CodePropertyNameF'),
								xtype: 'textfield'
							}
						
						}, {
							width :400,
							header : 'XCode',
							dataIndex : 'XCode',
							hidden:true,
							editor:{
								id:'XCodeF',
								disabled:Ext.BDP.FunLib.Component.DisableFlag('XCodeF'),
								xtype: 'textfield'
							}
						}, {
							width :400,
							header : 'XCode2',
							dataIndex : 'XCode2',
							hidden:true,
							editor:{
								id:'XCode2F',
								disabled:Ext.BDP.FunLib.Component.DisableFlag('XCode2F'),
								xtype: 'textfield'
							}
						
						}],
				stripeRows : true,                                
				loadMask : {                                      
					msg : '数据加载中,请稍候...'
				},
				title : '表结构维护',
				// config options for stateful behavior
				stateful : true,                                   
				viewConfig : {									  
					//forceFit : true								   
				},
				bbar : paging,                                    
				tbar : tb,                                        
				stateId : 'grid'
			});
			
	//2020年5月8日 李可凡
	if(Ext.getCmp("btnExceptionHosp").disabled==false){
		grid.on("rowclick", function(grid, rowIndex, e){
		 	var DataType = grid.getSelectionModel().getSelections()[0].get('DataType');
		 	if((DataType=="S")||(DataType=="C")){
		 		Ext.getCmp('btnExceptionHosp').enable();
		 	}else{
		 		Ext.getCmp('btnExceptionHosp').disable();
		 	}
		})
	}		
	//2021-09-06
	if(Ext.getCmp("btnAUDControlRights").disabled==false){
		grid.on("rowclick", function(grid, rowIndex, e){
		 	var AUDControlRights = grid.getSelectionModel().getSelections()[0].get('AUDControlRights');
		 	if(AUDControlRights=="Y"){
		 		Ext.getCmp('btnAUDControlRights').enable();
		 	}else{
		 		Ext.getCmp('btnAUDControlRights').disable();
		 	}
		})
	}			
    /*******************************定义Grid的行单击事件**************************/
		grid.on("rowclick", function(grid, rowIndex, e) {        
				if(ds.getAt(0).get('TableName')==""){
					ds.removeAt(0);
					if(0==rowIndex) return;
				}
				var _record = grid.getSelectionModel().getSelected();
				var FieldTitle=_record.get('TableDesc')+"-表字段维护";
				BDEFgrid.setTitle(FieldTitle);
				
				Ext.getCmp("TextCode2").reset();
				Ext.getCmp("TextDesc2").reset();
				BDEFgrid.getStore().baseParams={};
				BDEFds.load({                                    
					params : {
								start : 0,
								limit : pagesize_main,
								ParRef : _record.get('ID')
							}
					});
				BDEFgrid.expand();
			});
			
	/*****************************以下为子表部分*******************************************************/
	var BDEFbtnDel = new Ext.Toolbar.Button({                               
			text : '删除',													  
			id:'BDEF-deletebtn',
			tooltip : '删除',												 
			iconCls : 'icon-delete',										 
			disabled:true,
			handler : function() {											 
			if (BDEFgrid.selModel.hasSelection()) {                           
				var gsm = BDEFgrid.getSelectionModel();				 
				var rows = gsm.getSelections();
				if(rows[0].get('FieldRowId')==""||typeof(rows[0].get('FieldRowId'))=="undefined"){
					Ext.Msg.show({
									title : '提示',
									msg : '没有要删除的数据!',
									minWidth : 200,
									icon : Ext.Msg.ERROR,
									buttons : Ext.Msg.OK
								});
					return;
				}
				 
				Ext.MessageBox.confirm('提示', '确定要删除所选的数据吗?', function(btn) {
					if (btn == 'yes') {                                   
						Ext.MessageBox.wait('数据删除中,请稍候...', '提示');  
						var gsm = BDEFgrid.getSelectionModel();				  
						var rows = gsm.getSelections();					 
						
						Ext.Ajax.request({	                              	
							url : CHILD_DELETE_ACTION_URL,					  
							method : 'POST',                              
							params : {								 
								'id' : rows[0].get('FieldRowId')          
							},
							callback : function(options, success, response) {
								Ext.MessageBox.hide();
								if (success) {				              							
									var jsonData = Ext.util.JSON		  
											.decode(response.responseText); 
									if (jsonData.success == 'true') {
										Ext.Msg.show({
														title : '提示',
														msg : '数据删除成功!',
														icon : Ext.Msg.INFO,           
														buttons : Ext.Msg.OK,          
														fn : function(btn) {
															var startIndex = BDEFgrid.getBottomToolbar().cursor;
															var totalnum=BDEFgrid.getStore().getTotalCount();
															if(totalnum==1){    
																var startIndex=0
															}
															else if((totalnum-1)%pagesize_main==0) 
															{
																var pagenum=BDEFgrid.getStore().getCount();
																if (pagenum==1){ startIndex=startIndex-pagesize_main;}  
															}
															BDEFgrid.getStore().load({
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
													errorMsg = '<br />错误信息:'
															+ jsonData.info
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
																msg : '异步通讯失败.....',
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
	
	/************************************增加按钮****************************************/
	var BDEFbtnAddwin = new Ext.Toolbar.Button({
				id:'BDEF-Add-Btn',
				text : '添加',
				tooltip : '添加',
				iconCls : 'icon-add',
				disabled:true,
				handler : function(thiz) { 
					BDEFeditor.stopEditing();
					if(BDEFds.getCount()!=0&&BDEFds.getAt(0).get('FieldName')==""){
						BDEFgrid.getSelectionModel().selectRow(0);
						BDEFeditor.startEditing(0);
					}else{
						var record1 = grid.getSelectionModel().getSelected();
						var b = new BDEF({  
							FieldParRef : record1.get('ID'),
							FieldRowId : '',
							FieldName : '',
							FieldDesc : '',
							FieldTabCode:'',
							FieldType:'',
							FieldTranslation:''
						});
						BDEFds.insert(0, b); 
						BDEFgrid.getSelectionModel().selectRow(0);
						BDEFeditor.startEditing(0);
					}
				},
				scope : this									 
			});
				var BDEF = Ext.data.Record.create([											 
								{	name : 'FieldParRef',
									mapping : 'FieldParRef',
									type : 'string'
								},{	name : 'FieldRowId',
									mapping : 'FieldRowId',
									type : 'string'
								}, {
									name : 'FieldName',
									mapping : 'FieldName',
									type : 'string'
								}, {
									name : 'FieldDesc',
									mapping : 'FieldDesc',
									type : 'string'
								} , {
									name : 'FieldTabCode',
									mapping : 'FieldTabCode',
									type : 'string'
								}, {
									name : 'FieldType',
									mapping : 'FieldType',
									type : 'string'
								}, {
									name : 'FieldTranslation',
									mapping : 'FieldTranslation',
									type : 'string'
								}]);
			
     /*************************将数据读取出来并转换(成record实例)，为后面的读取和修改做准备********************/
	var BDEFds = new Ext.data.Store({
				proxy : new Ext.data.HttpProxy({  
					url : CHILD_ACTION_URL
				}),
				reader : new Ext.data.JsonReader({  
					totalProperty : 'total',
					root : 'data',
					successProperty : 'success'
				}, BDEF),
				listeners : {// 对数据集进行监听
					'update' : function(thiz, record, operation) { 
						var user = thiz.getAt(thiz.indexOf(record)).data;
						if (operation == Ext.data.Record.EDIT) {  
							thiz.commitChanges();  
							Ext.Ajax.request({  
								url : CHILD_SAVE_ACTION_URL_New,
								method : 'POST',
								params : 'ParRef=' + user.FieldParRef
										+ '&FieldRowId=' + user.FieldRowId
										+ '&FieldName=' + user.FieldName
										+ '&FieldDesc=' + user.FieldDesc
										+ '&FieldTabCode=' + user.FieldTabCode
										+ '&FieldType=' + user.FieldType
										+ '&FieldTranslation=' + user.FieldTranslation,
								success : function(response, opts) {
									var Child_respText = Ext.util.JSON.decode(response.responseText);
									if(Child_respText.success=='true'){
										var startIndex = BDEFgrid.getBottomToolbar().cursor;
										BDEFgrid.getStore().load({
												params : {
													//RowId : Child_respText.id,
													start :startIndex,   
													limit : pagesize_main
												}
											});
										BDEFgrid.getView().refresh();
									}else{
										var errorMsg = '';
										if (Child_respText.errorinfo) {
											errorMsg = '<br/>错误信息:' + Child_respText.errorinfo
										}
										Ext.Msg.show({
											title : '提示',
											msg : '保存失败!' + errorMsg,
											minWidth : 200,
											icon : Ext.Msg.ERROR,
											buttons : Ext.Msg.OK
										});
										var r = BDEFgrid.getSelectionModel().getSelected();
							            if(r){
							                var index = BDEFgrid.store.indexOf(r);
							                BDEFeditor.startEditing(index);
							            }
									}
								},
								failure : function(response, opts) {
									Ext.Msg.alert('错误', '提交数据错误!错误代码： '
													+ response.status);
									thiz.rejectChanges(); // 请求失败,回滚本地记录:)
									var startIndex = BDEFgrid.getBottomToolbar().cursor;
									BDEFgrid.getStore().load({
												params : {
															start :startIndex,   
															limit : pagesize_main
														}
											});
									BDEFgrid.getView().refresh();
								}
							});
						}
					},
					'load' : function(thiz, record, operation) {
						//BDEFtbbutton.setDisabled(false);
						//BDEFtb.setDisabled(false);
						BDEFgrid.enable();
						Ext.getCmp('FieldTabCodeF').setDisabled(true);
						Ext.getCmp('BDEFbtnSearch').setDisabled(Ext.BDP.FunLib.Component.DisableFlag('BDEFbtnSearch'));
						Ext.getCmp('BDEF-deletebtn').setDisabled(Ext.BDP.FunLib.Component.DisableFlag('BDEF-deletebtn'));
						Ext.getCmp('BDEF-Add-Btn').setDisabled(Ext.BDP.FunLib.Component.DisableFlag('BDEF-Add-Btn'));
						Ext.getCmp('BDEFbtnRefresh').setDisabled(Ext.BDP.FunLib.Component.DisableFlag('BDEFbtnRefresh'));
						Ext.getCmp('TextCode2').setDisabled(Ext.BDP.FunLib.Component.DisableFlag('TextCode2'));
						Ext.getCmp('TextDesc2').setDisabled(Ext.BDP.FunLib.Component.DisableFlag('TextDesc2'));
					}
				}
			});
	 
	/** ***************************加载前设置参数 ********************************/
	BDEFds.on('beforeload',function() {
			if (grid.selModel.hasSelection()) {
				var gsm = grid.getSelectionModel(); 
				var rows = gsm.getSelections(); 
				Ext.apply(BDEFds.lastOptions.params, {
			    		ParRef : rows[0].get('ID')
			   	 });
			}
		},this);		
	/******************************分页工具条**********************************/	
	var BDEFpaging = new Ext.PagingToolbar({
				pageSize : pagesize_main,
				store : BDEFds,											      
				displayInfo : true,										 
				emptyMsg : "没有记录"
			});

	/**-**************************增删改工具条********************************/
	var BDEFtbbutton = new Ext.Toolbar({
		items : [BDEFbtnAddwin, '-', BDEFbtnDel]			   
			// ,'->',{text:'刷新',iconCls:'icon-arrowrefresh'}
		});
		
	var BDEFbtnSearch = new Ext.Button({
				id : 'BDEFbtnSearch',
				disabled : Ext.BDP.FunLib.Component.DisableFlag('BDEFbtnSearch'),
				iconCls : 'icon-search',
				text : '搜索',
				handler : function() {
					var gsm = grid.getSelectionModel();// 获取选择列
					var rows = gsm.getSelections();// 根据选择列获取到所有的行
					
					BDEFgrid.getStore().baseParams={			
							code : Ext.getCmp("TextCode2").getValue(),
							desc : Ext.getCmp("TextDesc2").getValue()
					};
					BDEFgrid.getStore().load({
						params : {
									ParRef : rows[0].get('ID'),
									start : 0,
									limit : pagesize_main
								}
						});
					}
			});
	var BDEFbtnRefresh = new Ext.Button({
				id : 'BDEFbtnRefresh',
				disabled : Ext.BDP.FunLib.Component.DisableFlag('BDEFbtnRefresh'),
				iconCls : 'icon-refresh',
				text : '重置',
				handler : function() {
					var gsm = grid.getSelectionModel();// 获取选择列
					var rows = gsm.getSelections();// 根据选择列获取到所有的行
					Ext.getCmp("TextCode2").reset();
					Ext.getCmp("TextDesc2").reset();
					BDEFgrid.getStore().baseParams={};
					BDEFgrid.getStore().load({
								params : {
											ParRef : rows[0].get('ID'),
											start : 0,
											limit : pagesize_main
										}
									});
							}
			});
		
	/*****************************将工具条放在一起*********************/
	var BDEFtb = new Ext.Toolbar({
				id : 'BDEFtbtb',
				disabled : true,
				items : ['代码', {
							xtype : 'textfield',
							disabled : Ext.BDP.FunLib.Component.DisableFlag('TextCode2'),
							id : 'TextCode2'
						}, '-',
						'描述', {
							xtype : 'textfield',
							id : 'TextDesc2',
							disabled : Ext.BDP.FunLib.Component.DisableFlag('TextDesc2')
						}, '-', BDEFbtnSearch, '-', BDEFbtnRefresh, '->'
				],
				listeners : {                                       
					render : function() {                            
						BDEFtbbutton.render(BDEFgrid.tbar)                   
					}
				}
			});
			
	var BDEFeditor = new Ext.ux.grid.RowEditor({ 
			saveText : '更新',
			cancelText : '取消',
			commitChangesText : '提交!',
			errorSummary: false,
			id:"field-Editor",
			disabled:Ext.BDP.FunLib.Component.DisableFlag('field-Editor')
	});
	
	BDEFeditor.on({
    canceledit : function() {
    				var startIndex = BDEFgrid.getBottomToolbar().cursor; 
					BDEFgrid.getStore().load({                               
								params : {
											start : startIndex,   
											limit : pagesize_main
										}
							})
    				}
		});
	
	
	// 标志位判断数据源
	var XTypeData = [  
	                 ['String','String'], 
	                 ['Date','Date'],
	                 ['Time','Time'],
	                 ['DR','DR'],
	                 ['Float','Float'],
	                 ['Integer','Integer'],
	                 ['GlobalCharacterStream','GlobalCharacterStream']
	                 ];
	var XTypestore = new Ext.data.SimpleStore({
			fields : ['value','display'],
			data : XTypeData
		});
	                 
	/*****************************创建grid**************************/
	var BDEFgrid = new Ext.grid.GridPanel({
				id : 'BDEFgrid',
				region : 'east',
				width : 510,
				split: true,
				height : 300,
				collapsible: true,
				collapsed: true,	//默认折叠右侧面板 20200618 likefan
				plugins: [BDEFeditor],
				store : BDEFds,											 
				trackMouseOver : true,                              
				columns : [sm, {									 
							header : 'Field_RowId',
							dataIndex : 'FieldRowId',
							width : 80,
							hidden : true                           
						}, {
							header : '父表rowid',
							dataIndex : 'FieldParRef',
							hidden : true 
						}, {
							header : '表字段代码',
							dataIndex : 'FieldName',
							editor:{
								id:'FieldNameF',
								disabled:Ext.BDP.FunLib.Component.DisableFlag('FieldNameF'),
								xtype: 'textfield',
								allowBlank : false
							}
						},{
							header : '表字段描述',
							dataIndex : 'FieldDesc',
							editor:{
								id:'FieldDescF',
								disabled:Ext.BDP.FunLib.Component.DisableFlag('FieldDescF'),
								xtype: 'textfield',
								allowBlank : false
							}
						},{
							header : '表字段类型',
							dataIndex : 'FieldType',
							editor : new Ext.form.ComboBox({ 
									id:'FieldTypeF',
									disabled:Ext.BDP.FunLib.Component.DisableFlag('FieldTypeF'),
									emptyText : '请选择...',
									typeAhead : true, 
									triggerAction : 'all',
									store : XTypestore, 
									forceSelection : true,
									displayField : 'display', 
									valueField : 'value', 
									mode : 'local',  
									lazyRender : true,
									listWidth:140,
									listeners:{
										'select':function(){
											if(Ext.getCmp("FieldTypeF").getValue()=="DR"){
												Ext.getCmp('FieldTabCodeF').setDisabled(false);
											}
											else{
												Ext.getCmp('FieldTabCodeF').setDisabled(true);
												Ext.getCmp('FieldTabCodeF').setValue("");
											}
										}
									}
							})
						} ,{
							header : '指向表',
							dataIndex : 'FieldTabCode',
							editor : {  
									id:'FieldTabCodeF',
									disabled:Ext.BDP.FunLib.Component.DisableFlag('FieldTabCodeF'),
									xtype: 'textfield'
							}
						},{
							header : '是否可翻译',
							dataIndex : 'FieldTranslation',
							renderer : Ext.BDP.FunLib.Component.ReturnFlagIcon,
							editor : new Ext.form.ComboBox({ 
									id:'FieldTranslationF',
									disabled:Ext.BDP.FunLib.Component.DisableFlag('FieldTranslationF'),
									emptyText : '请选择...',
									typeAhead : true, 
									triggerAction : 'all',
									store : XTypestore, 
									forceSelection : true,
									displayField : 'display', 
									valueField : 'value', 
									mode : 'local',  
									lazyRender : true,
								    store: new Ext.data.SimpleStore({
										fields : ['value','display'],
								        data: [['Y', 'Yes'], ['N', 'No']]
								    })
									/*listeners:{
										'select':function(){
											if(Ext.getCmp("FieldTypeF").getValue()=="DR"){
												Ext.getCmp('FieldTabCodeF').setDisabled(false);
											}
											else{
												Ext.getCmp('FieldTabCodeF').setDisabled(true);
												Ext.getCmp('FieldTabCodeF').setValue("");
											}
										}
									}*/
							})
						}],
				stripeRows : true,                               
				loadMask : {                                     
					msg : '数据加载中,请稍候...'
				},
				//title : '',
				// config options for stateful behavior
				stateful : true,                                  
				bbar : BDEFpaging,                                   
				tbar : BDEFtb,                                         
				stateId : 'BDEFgrid'
			});		
	BDEFgrid.on('rowclick',function(Grid,index,e){
		if(Ext.getCmp("FieldTypeF").getValue()=="DR"){
			Ext.getCmp('FieldTabCodeF').setDisabled(false);
		}else{
			Ext.getCmp('FieldTabCodeF').setDisabled(true);
		}
		if(BDEFds.getAt(0).get('FieldName')==""){
			BDEFds.removeAt(0);
			if(0==index) return;
		}
	});
	Ext.BDP.FunLib.Component.KeyMap(); 	 		
	/*****************************创建viewport*************************************/
	var viewport = new Ext.Viewport({
			layout : 'border',
			items : [grid,BDEFgrid]
	});
});