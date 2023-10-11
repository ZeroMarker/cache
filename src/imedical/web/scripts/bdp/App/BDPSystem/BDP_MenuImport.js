	
	/// 名称:导入导出菜单
	/// 编写者:基础数据平台组 - 陈莹
	/// 编写日期:2015-12-04

Ext.onReady(function() {
	var importclassname="web.DHCBL.BDP.BDPMenuImport"
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
	var BrowerVersion=GetBrower()
	/// 获取文件路径 2017-07-11
	/// 使用方法：var filepath=getPath(document.getElementById("fileupload"));
	function getPath(obj) {
            if (obj) {
                if (window.navigator.userAgent.indexOf("MSIE") >= 1) {
                    obj.select(); return document.selection.createRange().text;
                }
                else if (window.navigator.userAgent.indexOf("Firefox") >= 1) {
                    if (obj.files) {
                        return obj.files.item(0).getAsDataURL();
                    }
                    return obj.value;
                }
                return obj.value;
            }
        }
        
	var ReadExcel=function (efilepath,sheet_from,sheet_to,row_from)
		{	
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
			var errorMsg="";//错误信息
			
		
			for(var sheet_id=sheet_from;sheet_id<=1;sheet_id++) {
				var errorRow="";//没有插入的行
				var updateRow="";
				var skipRow="";
				
				var errorMsg="";
		
				oWB.worksheets(sheet_id).select(); 
				var oSheet = oWB.ActiveSheet; 
		
				///alert(oSheet.Cells(1,2).value)    //左右合并的单元格 第一列有值，第二列为  undefined
				var rowcount=oXL.Worksheets(sheet_id).UsedRange.Cells.Rows.Count ;  ///行数
				var colcount=oXL.Worksheets(sheet_id).UsedRange.Cells.Columns.Count ;  ///列数
				//alert(rowcount)
				var sheetname=oSheet.name;  //获取sheet的表名
				//var tablename=oSheet.Cells(1,1).value;
				//alert(tablename+oSheet.Cells(1,1))
				var str=oSheet.name+"sheet导入完成。";
				Ext.MessageBox.wait('正在导入'+oSheet.name+'数据，请勿刷新或关闭页面，请稍候...','提示');
				
				 //从第4行开始读取
				for(var i=row_from;i<=rowcount;i++){
	
					var tempStr="";  //每行数据（第一列&第二列&...）
					for (var j=1;j<=colcount;j++){
						var cellvalue="";
						if (typeof(oSheet.Cells(i,j).value)=="undefined")
						{
							var cellvalue="";
						}
						else
						{
							var cellvalue=oSheet.Cells(i,j).value;
						}
						if (tempStr=="")
						{
							tempStr=cellvalue;
							if (tempStr=="")
							{
								tempStr="#";
							}
						}
						else
						{
							tempStr=tempStr+("#"+cellvalue);
						}
						
						
					}
					var Flag =tkMakeServerCall("web.DHCBL.BDP.BDPMenuImport","ImportExcel",sheetname,tempStr);
					if (Flag=="0"){  //保存失败
						if(errorRow!=""){
							errorRow=errorRow+","+i
						}else{
							errorRow=i
						}
					}
					
			
				} 
				
				if(errorRow!=""){
					str=str+"第"+errorRow+"行插入失败。";
				}
				
				Ext.MessageBox.hide();
				alert(str);
			}
			
			Ext.MessageBox.hide();
			oWB.Close(savechanges=false);
			oXL.Quit(); 
			CollectGarbage();
			
			oXL=null;
			oSheet=null;	
		
		
	}
	///从excel导入
  function ExcelImport(){ 
		var efilepath=Ext.getCmp("ExcelImportPath").getValue();
		if (BrowerVersion!="IE")
		{
			alert("请在IE下执行！"); return;
		}
		if( efilepath.indexOf("fakepath")>0 ) {alert ("请在IE下执行导入！"); return;}
		if( efilepath.indexOf(".xls")<=0 ) {alert ("请选择excel表格文件！"); return;}
	
		var killstr=tkMakeServerCall("web.DHCBL.BDP.BDPMenuImport","killPar"); 
		//alert(1)
		var sheet_from=1,sheet_to=1,row_from=4;
		ReadExcel(efilepath,sheet_from,sheet_to,row_from);
		//alert(2)
		///把父菜单dr没有导成功的菜单重新获取父菜单dr并保存
		var Restr=tkMakeServerCall("web.DHCBL.BDP.BDPMenuImport","ReImportParentMenuDr"); 
		//alert(3)
		
  }
	
	var xlApp,xlBook,xlsheet;
	var itemscount=0,menucount=0,intervalcount=30;
	var k,curnum,progressBar,progressMenuBar,bartext,curpercentage;

	////异步执行导出功能元素
	CircleExportItemDataToExcel=function(k) {
		
		curnum = k/itemscount;
		curpercentage=curnum*100;
		curpercentage=parseInt(curpercentage);   ///百分比取整
		bartext=curpercentage+"%";  
		//bartext=parseInt(bartext);
        progressBar.updateProgress(curnum,bartext);
        if (itemscount!=0) intervalcount=Math.min(30,itemscount);
		for (var i=k;((i<=itemscount)&&(i<(k+intervalcount)));i++){		
			var DataDetailStr=tkMakeServerCall("web.DHCBL.BDP.BDPMenuImport","GetExtItemInfo",i);
			var Detail=DataDetailStr.split("#");		
			for (var j=1;j<=28;j++){
				xlsheet.cells(3+i,j)=Detail[j-1];
			}
			
		}
		
		
		k=i;
		if(k<=itemscount)
		{
			setTimeout(function () {CircleExportItemDataToExcel(k);},0);
		}
		else
		{
			progressBar.hide();	
			
			xlApp.Visible=true;
			xlBook.Close(savechanges=true);
			Ext.Msg.show({
				title : '提示',
				msg : '导出完成!',
				icon : Ext.Msg.INFO,
				buttons : Ext.Msg.OK,
				fn : function(btn) {
					
					CollectGarbage();
					xlApp=null;
					xlsheet=null;	
			
				}
			});
			
			
			
		}
			
 	}
 	
 	
 	
	
///导出Excel文件2015-12-5  功能元素
function ExportItemsToExcel()
{
	if (BrowerVersion!="IE")
	{
		alert("请在IE下执行！"); return;
	}
	Ext.MessageBox.confirm('提示', '确定要导出功能大表和功能元素数据吗?', function(btn) {
	if (btn == 'yes') {
	
		try{
	    	xlApp = new ActiveXObject("Excel.Application");
			xlBook = xlApp.Workbooks.Add();///默认三个sheet
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
		
		
		progressBar=Ext.Msg.show({
	         title:"提示",
	         msg:"正在导出功能大表和功能元素数据，请勿刷新或关闭页面，请稍候...",
	         progress:true,
	         width:300,
	         closable:false
	     });
	     
	     //ExportMenuToExcel()
		///Ext.MessageBox.wait('正在导出BDP功能大表和功能元素数据，请勿刷新或关闭页面，请稍候...','提示');
	
		///BDP功能大表 1
		xlBook.worksheets(1).select(); 
		xlsheet = xlBook.ActiveSheet; 
		itemscount=tkMakeServerCall("web.DHCBL.BDP.BDPMenuImport","GetItemsCount");
		
		xlsheet.name="BDP功能大表";  //sheet的表名
		xlsheet.cells(1,1)="User.BDPExecutables";
		xlsheet.cells(1,10)="User.BDPExtExecItem";
		xlsheet.cells(2,1)="代码";
		xlsheet.cells(2,2)="名称";
		xlsheet.cells(2,3)="Js路径及文件名";
		xlsheet.cells(2,4)="基础数据授权JS路径";
		xlsheet.cells(2,5)="功能描述";
		xlsheet.cells(2,6)="激活标志";
		xlsheet.cells(2,7)="包名";
		xlsheet.cells(2,8)="实体类名";
		xlsheet.cells(2,9)="显示字段";
		xlsheet.cells(2,10)="代码";
		xlsheet.cells(2,11)="名称";
		xlsheet.cells(2,12)="是否只读";
		xlsheet.cells(2,13)="是否可为空";
		xlsheet.cells(2,14)="是否隐藏";
		xlsheet.cells(2,15)="是否可编辑";
		xlsheet.cells(2,16)="提示信息";
		xlsheet.cells(2,17)="提示信息类型";
		xlsheet.cells(2,18)="类型";
		xlsheet.cells(2,19)="是否自动显示";
		xlsheet.cells(2,20)="图标";
		xlsheet.cells(2,21)="函数";
		xlsheet.cells(2,22)="XType";
		xlsheet.cells(2,23)="校验";
		xlsheet.cells(2,24)="HiddenName";
		xlsheet.cells(2,25)="Regex";
		xlsheet.cells(2,26)="RegexText";
		xlsheet.cells(2,27)="ValueGet";
		xlsheet.cells(2,28)="ValueSet";
		
		xlsheet.cells(3,1)="Code";
		xlsheet.cells(3,2)="Caption";
		xlsheet.cells(3,3)="JavaScriptFile";
		xlsheet.cells(3,4)="BDAJavaScriptFile";
		xlsheet.cells(3,5)="Description";
		xlsheet.cells(3,6)="ActiveFlag";
		xlsheet.cells(3,7)="PackageName";
		xlsheet.cells(3,8)="ClassName";
		xlsheet.cells(3,9)="PropertyName";
		xlsheet.cells(3,10)="Code";
		xlsheet.cells(3,11)="Name";
		xlsheet.cells(3,12)="ReadOnly";
		xlsheet.cells(3,13)="AllowBlank";
		xlsheet.cells(3,14)="Hidden";
		xlsheet.cells(3,15)="Editable";
		xlsheet.cells(3,16)="ToolTip";
		xlsheet.cells(3,17)="ToolTipType";
		xlsheet.cells(3,18)="Type";
		xlsheet.cells(3,19)="AutoShow";
		xlsheet.cells(3,20)="IconCls";
		xlsheet.cells(3,21)="Handler";
		xlsheet.cells(3,22)="XType";
		xlsheet.cells(3,23)="Validator";
		xlsheet.cells(3,24)="HiddenName";
		xlsheet.cells(3,25)="Regex";
		xlsheet.cells(3,26)="RegexText";
		xlsheet.cells(3,27)="ValueGet";
		xlsheet.cells(3,28)="ValueSet";
	
		
		
	     
	    if (itemscount>0)
        {
         	k=1;
         	CircleExportItemDataToExcel(k)
         	
        }
		
	}
	}, this);

	
	
}	
 	



 	
	////异步执行导出菜单
	CircleExportMenuDataToExcel=function(k) {
		curnum = k/menucount;
		curpercentage=curnum*100;
		curpercentage=parseInt(curpercentage)   ///百分比取整
		bartext=curpercentage+"%";  
		//bartext=parseInt(bartext);
        progressMenuBar.updateProgress(curnum,bartext);
        if (menucount!=0) intervalcount=Math.min(30,menucount);
		for (var i=k;((i<=menucount)&&(i<(k+intervalcount)));i++){		
			var DataDetailStr=tkMakeServerCall("web.DHCBL.BDP.BDPMenuImport","GetMenuInfo",i);
			var Detail=DataDetailStr.split("#");		
			for (var j=1;j<=28;j++){
				xlsheet.cells(3+i,j)=Detail[j-1];
			}
			
		}

		k=i;
		if(k<=menucount)
		{
			setTimeout(function () {CircleExportMenuDataToExcel(k);},0);
		}
		else
		{
			progressMenuBar.hide();	
			
			xlApp.Visible=true;
			xlBook.Close(savechanges=true);
			Ext.Msg.show({
				title : '提示',
				msg : '导出完成!',
				icon : Ext.Msg.INFO,
				buttons : Ext.Msg.OK,
				fn : function(btn) {
					
					CollectGarbage();
					xlApp=null;
					xlsheet=null;	
			
				}
			});
			
	        
		}
			
 	}
 	
 
 	

function ExportMenuToExcel()
{
	if (BrowerVersion!="IE")
	{
		alert("请在IE下执行！"); return;
	}
	Ext.MessageBox.confirm('提示', '确定要导出菜单数据吗?', function(btn) {
	if (btn == 'yes') {
		try{
	    	xlApp = new ActiveXObject("Excel.Application");
			xlBook = xlApp.Workbooks.Add();///默认三个sheet
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
		
		
		progressBar=Ext.Msg.show({
	         title:"提示",
	         msg:"正在导出菜单数据，请勿刷新或关闭页面，请稍候...",
	         progress:true,
	         width:300,
	         closable:false
	     });
	     
		xlBook.worksheets(1).select(); 
		xlsheet = xlBook.ActiveSheet; 
		menucount=tkMakeServerCall("web.DHCBL.BDP.BDPMenuImport","GetMenuCount");
		
		progressMenuBar=Ext.Msg.show({
	         title:"提示",
	         msg:"正在导出菜单数据，请勿刷新或关闭页面，请稍候...",
	         progress:true,
	         width:300,
	         closable:false
	     });
	     
	
		xlsheet.name="菜单";  //sheet的表名
		xlsheet.cells(1,1)="User.BDPMenu";
		//1b
		
		//var titlestr="代码^名称^功能^URL解析地址^菜单图标^类方法^显示顺序^菜单快捷键^弹出窗口或者增加Tab的方式^父菜单^最后的更新日期^最后的更新时间^最后的更新用户^值表达式^菜单激活状态标志^组件名称^产品线"
		xlsheet.cells(2,1)="代码";
		xlsheet.cells(2,2)="名称";
		xlsheet.cells(2,3)="功能(功能大表里的code)"; //dr-> 功能大表 User.BDPExecutables
		xlsheet.cells(2,4)="URL解析地址";
		xlsheet.cells(2,5)="菜单图标";
		xlsheet.cells(2,6)="类方法";
		xlsheet.cells(2,7)="显示顺序";
		xlsheet.cells(2,8)="菜单快捷键";
		xlsheet.cells(2,9)="弹出窗口或者增加Tab的方式";																	
		xlsheet.cells(2,10)="父菜单代码";//dr User.BDPMenu
		xlsheet.cells(2,11)="父菜单描述";
		xlsheet.cells(2,12)="菜单激活状态标志";
		xlsheet.cells(2,13)="组件名称";
		xlsheet.cells(2,14)="产品线"; //dr User.DHCProductLine
		xlsheet.cells(2,15)="值表达式";//dr User.BDPMenu
		xlsheet.cells(2,16)="是否属于医用知识库";
		
		//1b
		xlsheet.cells(3,1)="Code";
		xlsheet.cells(3,2)="Caption";
		xlsheet.cells(3,3)="LinkFuntionDR";
		xlsheet.cells(3,4)="LinkUrl";
		xlsheet.cells(3,5)="Image";
		xlsheet.cells(3,6)="Method";
		xlsheet.cells(3,7)="Sequence";
		xlsheet.cells(3,8)="ShortcutKey";
		xlsheet.cells(3,9)="ShowInNewWindow";
		xlsheet.cells(3,10)="ParentMenuDr";
		
		xlsheet.cells(3,11)="ParentMenuDrCaption";
		xlsheet.cells(3,12)="ActiveFlag";
		xlsheet.cells(3,13)="CompName";
		xlsheet.cells(3,14)="ProductLineDr";
		xlsheet.cells(3,15)="ValueExpression";
		xlsheet.cells(3,16)="IsMKBMenu";
		
		
		if (menucount>0)
		{
			k=1;
			CircleExportMenuDataToExcel(k);
		}
		

	}
	}, this);
}
	
	
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
			Ext.Msg.show({
				title : '提示',
				msg : ErrorMsgInfo ,
				minWidth : 200,
				icon : Ext.Msg.INFO,
				buttons : Ext.Msg.OK
			}) 
			//alert(e);
			return;
		}
	}
	
	
	
	//从gof文件导入
	function GofImport(){
		if (BrowerVersion!="IE")
		{
			alert("请在IE下执行！"); return;
		}
		var filepath=getPath(document.getElementById("GofImportPath"));  //2017-07-11 ie8下部分浏览器版本获取的路径为C:\fakepath\
			
		if( filepath.indexOf("fakepath")>0 ) {alert ("请在IE下执行导入！"); return;}
		if( filepath.indexOf(".gof")<=0 ) {alert ("请选择gof文件！"); return;}
		if(/.*[\u4e00-\u9fa5]+.*$/.test(filepath)) {alert ("路径不能包含中文！"); return;}
		var im="";
		var im=tkMakeServerCall("web.DHCBL.BDP.BDPMenuImport","ImportGof",filepath);
		alert("导入成功!")
		//gotoBrowse('1','Wizard=Save&Wild=*.*')  //gotoBrowse(1,"Wizard=Save&Wild=*.xml");

	}
	
	//导出到gof文件
	function GofExport(){
		if (BrowerVersion!="IE")
		{
			alert("请在IE下执行！"); return;
		}
		var packagename=getPath(document.getElementById("GofExportPath"));  //2017-07-11 ie8下部分浏览器版本获取的路径为C:\fakepath\
		var filename = document.getElementById("GofExportName").value;
		
		var path=packagename+filename;
		alert(path)
		var lg=filename.length;
		var typeb = filename.substring(lg-4,lg);
		if ( typeb!=".gof" ) {alert ("文件名需以.gof结尾！"); return;}
		if(/.*[\u4e00-\u9fa5]+.*$/.test(path)) {alert ("路径不能包含中文！"); return;}
		var ex="";
		var ex=tkMakeServerCall("web.DHCBL.BDP.BDPMenuImport","ExportGof",path);
		alert("导出成功!")
	}
	
	var formSearch = new Ext.form.FormPanel({
		title:'基础数据平台菜单导入导出',
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
			title:'从Excel文件导入',
			labelWidth:120,		
			labelAlign:'right',
			autoHeight: true,
			width:700,
			defaultType:'textfield',
			items:[	 
			{width: 400,fieldLabel:'导入Excel文件',xtype : 'textfield',inputType:'file',id : 'ExcelImportPath'},
			{iconCls : 'icon-import',text:'导入',xtype : 'button',
				listeners : {
					"click" : function() {  
						ExcelImport();   
					}
				}
			}
			]
		},{
			
			
			xtype: 'fieldset',
			title:'导出Excel文件',
			labelWidth:120,	
			labelAlign:'right',
			autoHeight: true,
			width:700,
			defaultType:'textfield',
			items:[{
						xtype:'fieldset',
						border:false,
						items:[
							{iconCls : 'icon-export',text:'导出菜单',xtype : 'button',
												listeners : {
													"click" : function() { 
														ExportMenuToExcel();  
														
													}
												}
											},{iconCls : 'icon-export',text:'导出功能大表和功能元素',xtype : 'button',
												listeners : {
													"click" : function() { 
														ExportItemsToExcel();  
														
													}
												}
											}
											
							
						]}
			]
		},{
			xtype: 'fieldset',
			title:'从gof文件导入',
			labelWidth:120,		
			labelAlign:'right',
			autoHeight: true,
			width:700,
			defaultType:'textfield',
			items:[
						 
			{width: 400,fieldLabel:'导入Global文件',xtype : 'textfield',inputType:'file',id : 'GofImportPath'},
			{iconCls : 'icon-import',text:'导入',xtype : 'button',
				listeners : {
					"click" : function() {  
						GofImport();   
					}
				}
			}
			]
		},{
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
			{width:400,fieldLabel:'文件名',xtype : 'textfield',value:"TMPMENU.gof",id : 'GofExportName'},
			{iconCls : 'icon-export',text:'导出',xtype : 'button',
				listeners : {
					"click" : function() {  
						GofExport();   
					}
				}
			}
			]
		},
		{
                	title:"备注说明",
                	width:700,
					html : "<ui><li>1.需在IE下执行操作，"+ErrorMsgInfo
					+"</li></ui> <ui><li>2..导入时需选择正确的xls/xlsx/gof格式的文件。导入和导出gof时请远程到服务器执行操作，且路径不能有中文。导出global时，文件类型需以.gof结尾，导出gof时路径为导出到服务器的路径。</li></ui> <ui><li>3.导入导出时提示'A JavaScript exception was caught during execution of HyperEvent: SyntaxError:缺少; '时，请选择'取消'。此弹出框为系统方法自行弹出，没有影响导入导出功能。</li></ui> <ui><li>4.导出导入的为User.BDPExecutables（BDP功能大表）、User.BDPExtExecItem（BDP功能元素）、User.BDPMenu（菜单维护）这3个表的数据。用gof文件导入及用Excel文件导入原则是：code相同的数据，如果与原数据库完全相同则跳过，有变动则修改，code不同的数据新增，方便更新数据</li></ui> "
                
		}]
	});

	
	// 创建viewport
	var viewport = new Ext.Viewport({
				layout : 'border',
				items : [formSearch]
	});
	
	
	

});
