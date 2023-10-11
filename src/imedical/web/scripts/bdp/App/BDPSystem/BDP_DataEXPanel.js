/**
 * @Title: 基础数据平台-BDP数据导入
 * @Author: 谷雪萍 DHC-BDP
 * @Description: 数据导出界面
 * @Created on 2016-3-16
 */	
/* 引用导入导出js */
//document.write('<script type="text/javascript" src="../scripts/bdp/Framework/scripts/xlsx/shim.min.js"> </script>');
//document.write('<script type="text/javascript" src="../scripts/bdp/Framework/scripts/xlsx/xlsx.full.min.js"> </script>');
//document.write('<script type="text/javascript" src="../scripts/bdp/Framework/scripts/xlsx/Blob.js"> </script>');
//document.write('<script type="text/javascript" src="../scripts/bdp/Framework/scripts/xlsx/FileSaver.js"> </script>');
document.write('<script type="text/javascript" src="../scripts/bdp/Framework/scripts/xlsx/xlsx.extendscript.js"> </script>');
document.write('<script type="text/javascript" src="../scripts/bdp/Framework/scripts/xlsx/xlsx-style/xlsx.full.min.js"> </script>');
document.write('<script type="text/javascript" src="../scripts/bdp/Framework/scripts/xlsx/export.js"> </script>');
Ext.onReady(function() {
	
	var table=Ext.BDP.FunLib.getParam('AutCode')    //获取传过来的菜单代码
	//调用js-xlsx 导出数据  2022-06-27
	function ExportExcelData() {
		var excelinfostr=tkMakeServerCall("web.DHCBL.BDP.BDPDataExport","GetTempletFieldDescV2",table);
		if (excelinfostr=="") {alert("请先设置导入导出配置表"); return;}
		var excelinfo=excelinfostr.split("&%");
		var sheetname=excelinfo[0];
		if (sheetname=="") {alert("请先设置导入导出配置表"); return;}
		var xlsName=sheetname;
		if (xlsName!="") 
		{
			var taskcount=tkMakeServerCall("web.DHCBL.BDP.BDPDataExport","GetDataCountV2",table);  //获取要导出的总条数  
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
				var TotalArray=[] //定义数组，用于给table赋值
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
				var fieldinfostr=excelinfo[1];
				var fieldInfoArray=fieldinfostr.split("&#");
				var titlenamearr=[],titlecodearr=[];
				for (var i=0;i<(fieldInfoArray.length);i++){
						
					var fieldInfo=fieldInfoArray[i]
					var fieldArr=fieldInfo.split("^");
					
					titlenamearr.push(fieldArr[0]);
					titlecodearr.push(fieldArr[1]);
				}
				TotalArray.push(titlenamearr);
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
						///2020-04-09数据导出完以后，清掉临时global
						var tempflag=tkMakeServerCall("web.DHCBL.BDP.BDPDataExport","KillTMPEXCELEXPORTGlobal",table);
						var sheet = XLSX2.utils.aoa_to_sheet(TotalArray);
				        var mycolcount=0;
				        for (var key in sheet) {
				        	if ((key=='A3')||(key=='!ref')){break;}
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
						    var fieldi=mycolcount%(fieldInfoArray.length)  //取余
					        var fieldInfo=fieldInfoArray[fieldi]
					        if((fieldInfo==undefined)||(fieldInfo=="undefined")){  continue;}
							var fieldArr=fieldInfo.split("^");
							mycolcount=mycolcount+1;
							if (fieldArr[2]==1) //必填项
							{
								//必填项模板颜色红色
						        sheet[key]["s"] = {
						            font: {
						                name: '宋体',
						                sz: 14,
						                bold: true,
						                underline: false,
						                color: {
						                    rgb: "FF0000"  //红色
						                }
						            },
						            alignment: {  //设置标题水平竖直方向居中，并自动换行展示
						                horizontal: "center",
						                vertical: "center",
						                wrap_text: true
						            }
						        };
							}
						};
						var cosWidth=[];
						for (var i=0;i<(fieldInfoArray.length);i++){
							cosWidth.push({wpx:150})
						}
						sheet["!cols"]=cosWidth; //控制单元格的宽度
				        openDownloadDialog(sheet2blob(sheet), xlsName+'.'+'xlsx');
						
						
				  	}
				  	else
				  	{
						progressText = "正在导出第"+row+"条记录,总共"+taskcount+"条记录!";   
						proBar.updateProgress(row/taskcount,progressText);
						//将每条数据加到数组里
						var DataDetailStr2=tkMakeServerCall("web.DHCBL.BDP.BDPDataExport","GetFieldValueV2",table,row);
						var DetailArray=DataDetailStr2.split("&%");
					    TotalArray.push(DetailArray)
					  }
				  },  
				  interval:10
				}); 
				winproBar.show();
			}
			
		}  
		else
		{
				Ext.Msg.show({
					title : '提示',
					msg : '没有获取到表格配置，请重新确认！' ,
					minWidth : 200,
					icon : Ext.Msg.INFO,
					buttons : Ext.Msg.OK
				})
				return;
		}
	}
	
	/*
  //var ErrorMsgInfo="请尝试以下解决方法：(1)打开IE,在[internet选项]-[安全]-[受信任的站点]-[站点]中添加开始界面到可信任的站点，然后在[自定义级别]中对[没有标记为安全的ActiveX控件进行初始化和脚本运行]这一项设置为启用，确定后，重启浏览器。(2)运行:regsvr32 scrrun.dll。(3)运行regedit，找到：HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Internet Explorer\ActiveX Compatibility\{00000566-0000-0010-8000-00AA006D2EA4},在右窗格中，双击“Compatibility Flags”。在“编辑 DWORD 值”对话框中，确保选中“十六进制”选项，在“数值数据”框中键入 0，然后单击“确定”。 "
	var ErrorMsgInfo="请先确认本机有安装office软件。打开IE,在[internet选项]-[安全]-[受信任的站点]-[站点]中添加开始界面到可信任的站点，然后在[自定义级别]中对[没有标记为安全的ActiveX控件进行初始化和脚本运行]这一项设置为启用，确定后，重启浏览器。 "

	///2019-02-13
	function isIE()
	{
		//navigator.userAgent.indexOf("compatible") > -1 && navigator.userAgent.indexOf("MSIE") > -1  //ie6,7,8,9,10
		//navigator.userAgent.indexOf('Trident') > -1 &&  navigator.userAgent.indexOf("rv:11.0") > -1;  //ie11  //"ActiveXObject" in window
		//alert(window.navigator.userAgent)
		if((!!window.ActiveXObject)||(navigator.userAgent.indexOf('Trident')>-1&&navigator.userAgent.indexOf("rv:11.0")>-1))
		{	return true;}
		else
		{  
			return false;
		}
	}

	var idTmr="";
	function Cleanup(){   
	 	window.clearInterval(idTmr);   
	 	CollectGarbage();
	}
	///导出Excel文件2021-12-07 第二版，导入配置和导出配置合并。
	ExportExcelData=function() {
				var count=tkMakeServerCall("web.DHCBL.BDP.BDPDataExport","GetDataCountV2",table);
				if (count>0)
		        {
					// f1的任务代码
				 	try{
				   	 	var xlApp = new ActiveXObject("Excel.Application");
						var xlBook = xlApp.Workbooks.Add();///默认三个sheet
					}catch(e){
						var emsg="不能生成表格文件。"+ErrorMsgInfo;
						Ext.Msg.show({
							title : '提示',
							msg : emsg ,
							minWidth : 200,
							icon : Ext.Msg.INFO,
							buttons : Ext.Msg.OK
						}) 
					    return;
					}     
						     
				 	xlBook.worksheets(1).select(); 
					var xlsheet = xlBook.ActiveSheet; 

					var excelinfostr=tkMakeServerCall("web.DHCBL.BDP.BDPDataExport","GetTempletFieldDescV2",table);
					if (excelinfostr=="") {alert("请先设置导入导出配置表"); return;}
					var excelinfo=excelinfostr.split("&%");
					var sheetname=excelinfo[0];
					if (sheetname=="") {alert("请先设置导入导出配置表"); return;}
					xlsheet.name=sheetname;
					
					var fieldinfostr=excelinfo[1];
					
					var fieldInfoArray=fieldinfostr.split("&#");
					for (var i=0;i<(fieldInfoArray.length);i++){
						
						var fieldInfo=fieldInfoArray[i]
						var fieldArr=fieldInfo.split("^");
						
						xlsheet.cells(1,i+1)=fieldArr[0];
						xlsheet.cells(2,i+1)=fieldArr[1];
						///xlsheet.Columns("A:A").NumberFormatLocal = "@"
						xlsheet.Columns(i+1).NumberFormatLocal = "@";   ///设置某列单元格格式为文本格式  20170830
						//xlsheet.Cells(row_from-2,i+1).NumberFormatLocal = "@";   ///设置某行某列单元格格式为文本格式
						///设置单元格样式 2017-2-7 chenying
						xlsheet.cells(1,i+1).Font.Bold = true; //设置为粗体
						xlsheet.cells(2,i+1).Font.Bold = true; //设置为粗体
						xlsheet.cells(1,i+1).WrapText=true;  //设置为自动换行*
						xlsheet.cells(2,i+1).WrapText=true;  //设置为自动换行*
						//设置单元格底色*(1-黑色，2-白色，3-红色，4-绿色，5-蓝色，6-黄色，7-粉红色，8-天蓝色，9-酱土色.)
						//xlsheet.cells(1,i+1).Interior.ColorIndex = 5;  ///蓝色底色
						//xlsheet.cells(2,i+1).Interior.ColorIndex = 5;
						if (fieldArr[2]==1)
						{
							//设置设置字体颜色
							xlsheet.cells(1,i+1).Font.ColorIndex = 3;  ///红色
							xlsheet.cells(2,i+1).Font.ColorIndex = 3;
						}
						else
						{
							xlsheet.cells(1,i+1).Font.ColorIndex = 1; 
							xlsheet.cells(2,i+1).Font.ColorIndex = 1;
							
						}
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
							//alert(errorMsg)
							//idTmr = window.setInterval("Cleanup();",1);
							Ext.TaskMgr.stop(this);
							winproBar.close();
							///2020-04-09数据导出完以后，清掉临时global
							var tempflag=tkMakeServerCall("web.DHCBL.BDP.BDPDataExport","KillTMPEXCELEXPORTGlobal",table);
							xlApp.Visible=true;	
							xlBook.Close(savechanges=true);
							CollectGarbage();
							xlApp=null;
							xlsheet=null;		
			
							
					  	}
					  	else
					  	{
							var DataDetailStr2=tkMakeServerCall("web.DHCBL.BDP.BDPDataExport","GetFieldValueV2",table,row);
							var Detail2=DataDetailStr2.split("&%");		
							for (var j=1;j<=Detail2.length;j++){
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
	
	 */
	/*
	///导出Excel文件2015-12-5   chz chenying 2016-12-21修改,添加进度条
	ExportExcelData=function() {
		
				// f1的任务代码
			 	try{
			   	 	var xlApp = new ActiveXObject("Excel.Application");
					var xlBook = xlApp.Workbooks.Add();///默认三个sheet
				}catch(e){
					var emsg="不能生成表格文件。"+ErrorMsgInfo;
					Ext.Msg.show({
						title : '提示',
						msg : emsg ,
						minWidth : 200,
						icon : Ext.Msg.INFO,
						buttons : Ext.Msg.OK
					}) 
				    return;
				}     
					     
			 	xlBook.worksheets(1).select(); 
				var xlsheet = xlBook.ActiveSheet; 

				var sheetname=tkMakeServerCall("web.DHCBL.BDP.BDPDataExport","GetTableDesc",table);
				
				if (sheetname!="") 
				{
					xlsheet.name=sheetname;
				
				
					var count=tkMakeServerCall("web.DHCBL.BDP.BDPDataExport","GetDataCount",table);
					var titlenameStr=tkMakeServerCall("web.DHCBL.BDP.BDPDataExport","GetFieldName",table);
					//alert(sheetname+"^"+count+"^"+titleStr)
					var titlenamearr=titlenameStr.split("&%");
					for (var m = 0; m < titlenamearr.length; m++) {    				
						//第一行	
			    		xlsheet.cells(2,m+1)=titlenamearr[m];
			    		xlsheet.cells(2,m+1).Font.Bold = true;  //设置为粗体 
			    		xlsheet.cells(2,m+1).WrapText=true;  //设置为自动换行*
					}	 
		     
				 	var titledescStr=tkMakeServerCall("web.DHCBL.BDP.BDPDataExport","GetFieldDesc",table);
					//alert(sheetname+"^"+count+"^"+titleStr)
					var titledescarr=titledescStr.split("&%");
					for (var m = 0; m < titledescarr.length; m++) {    				
						//第一行	
			    		xlsheet.cells(1,m+1)=titledescarr[m];
			    		xlsheet.cells(1,m+1).Font.Bold = true;  //设置为粗体
						xlsheet.cells(1,m+1).WrapText=true;  //设置为自动换行*
						
					}	 
					
					
			        if (count>0)
			        {
			        	
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
								//alert(errorMsg)
								//idTmr = window.setInterval("Cleanup();",1);
								Ext.TaskMgr.stop(this);
								winproBar.close();
								///2020-04-09数据导出完以后，清掉临时global
								var tempflag=tkMakeServerCall("web.DHCBL.BDP.BDPDataExport","KillTMPEXCELEXPORTGlobal",table);
								xlApp.Visible=true;	
								xlBook.Close(savechanges=true);
								CollectGarbage();
								xlApp=null;
								xlsheet=null;		
				
								
						  	}
						  	else
						  	{
								var DataDetailStr2=tkMakeServerCall("web.DHCBL.BDP.BDPDataExport","GetFieldValue",table,row);
								var Detail2=DataDetailStr2.split("&%");		
								for (var j=1;j<=Detail2.length;j++){
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
				else
				{
					
					Ext.Msg.show({
							title : '提示',
							msg : '没有找到导出配置，请确认！' ,
							minWidth : 200,
							icon : Ext.Msg.INFO,
							buttons : Ext.Msg.OK
						}) 
					    return;
				}
				
		}
	
	*/
	
	
	
	
	///导出gof文件时，选择导出路径
	function browseFolder() {
    	try {
        	var Message = "\u8bf7\u9009\u62e9\u6587\u4ef6\u5939"; //选择框提示信息
        	var Shell = new ActiveXObject("Shell.Application");
        	var Folder = Shell.BrowseForFolder(0, Message, 64, 17); //起始目录为：我的电脑
       		//var Folder = Shell.BrowseForFolder(0, Message, 0); //起始目录为：桌面
       		if (Folder != null) {
            	Folder = Folder.items(); // 返回 FolderItems 对象
            	Folder = Folder.item(); // 返回 Folderitem 对象
            	Folder = Folder.Path; // 返回路径
            	if (Folder.charAt(Folder.length - 1) != "\\") {
                	Folder = Folder + "\\";
            	}
            	document.getElementById("GofExportPath").value = Folder;  ///给gof导出路径复制
            	return Folder;
        	}
    	}
    	catch(e){
			alert(e.message);
			return;
		}
	}
	
	//导出gof文件
	function GofExportData(){	
		var EILType="BDPData", EILEIType="E", EILFileType="G";   //EILEIType="E" 导出； EILFileType="G" GOF
		
		var packagename = document.getElementById("GofExportPath").value;
		var filename = document.getElementById("GofExportName").value;
		var path=packagename+filename;
		var lg=filename.length;
		var typeb = filename.substring(lg-4,lg);
		if ( typeb!=".gof" ) {alert ("文件名需以.gof结尾！"); return;}
		if(/.*[\u4e00-\u9fa5]+.*$/.test(path)) {alert ("路径不能包含中文！"); return;}
		
		var pthext=tkMakeServerCall("%Library.File","Exists",packagename);
		if (pthext!=1)
		{
			alert ("没有该路径，请重新选择导出文件路径！"); 
			return;
		}

		///判断是否有人再执行该类型数据的导入导出操作
		var lockflag=tkMakeServerCall("web.DHCBL.BDP.BDPDataExport","GetGofFlag",EILType);
		if (lockflag==1)
		{
			alert ("有其他用户再执行导入导出操作，请稍后重试！"); 
			return;
		}
		
		var exr=tkMakeServerCall("web.DHCBL.BDP.BDPDataExport","ExportGof",path,EILType,table);
		
	}
	
	var formSearch = new Ext.form.FormPanel({
		title:'BDP数据导出',
		frame:true,
		border:false,
		region: 'center',
		autoScroll:true,
		width:600,
		height:200,
		split: true,
		buttonAlign:'center',
		items:[{
			xtype: 'fieldset',
			title:'导出Excel文件',
			labelWidth:120,	
			labelAlign:'right',
			autoHeight: true,
			width:700,
			defaultType:'textfield',
			items:[
			{iconCls : 'icon-export',text:'导出',xtype : 'button',
				listeners : {
					"click" : function() {
						ExportExcelData();  //支持医为浏览器下导出
						
						
					}
				}
			}
			]
		}/*,{
			xtype: 'fieldset',
			title:'导出gof文件',
			labelWidth:120,	
			labelAlign:'right',
			autoHeight: true,
			width:700,
			defaultType:'textfield',
			items:[
			{width:400,fieldLabel:'导出文件路径',xtype : 'textfield',value:"D:\\",id : 'GofExportPath',readOnly:true,
				listeners : {
					"focus" : function() {
						browseFolder();
					}
				}
			},
			{width:400,fieldLabel:'文件名',xtype : 'textfield',value:"TMPGOFDATA.gof",id : 'GofExportName'},
			{iconCls : 'icon-export',text:'导出',xtype : 'button',
				listeners : {
					"click" : function() {
						if (!isIE())  //2019-02-13
						{	
							alert("请在IE下执行！"); return;	
						}
						ExportExcelData();
					 	
						
					}
				}
			}
			]
		},
		{
                	title:"备注说明",
                	width:700,
					html : //"<ui><li>1.需在IE下执行操作，"+ErrorMsgInfo+"</li></ui>"+
							//"<ui><li>2.导出gof时请远程到服务器执行操作，且路径不能有中文。导出global时，文件类型需以.gof结尾，导出gof时路径为导出到服务器的路径。提示'A JavaScript exception was caught during execution of HyperEvent: SyntaxError:缺少; '时，请选择'取消'。此弹出框为系统方法自行弹出，没有影响导入导出功能。</li></ui> " +
							"<ui><li>1.导出某界面数据时，需先去导出配置表管理进行配置，如果没有导出配置则没法执行导出。</li></ui> "
                
		}*/]
	});

	
	// 创建viewport
	var viewport = new Ext.Viewport({
				layout : 'border',
				items : [formSearch]
	});
	
	
	

});
