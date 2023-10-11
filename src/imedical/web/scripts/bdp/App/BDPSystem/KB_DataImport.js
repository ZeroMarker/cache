	
	/// 名称:知识库模板数据导入
	/// 编写者:基础数据平台组 - 谷雪萍
	/// 编写日期:2015-12-8

Ext.onReady(function() {
	var idTmr
	
	Cleanup=function (){
		if(idTmr) 
		{
	 		window.clearInterval(idTmr);    //取消由setInterval()方法设置的定时器。
		}
	 	CollectGarbage();
	}
	///从excel导入
  function ImportKBData(){ 
		var efilepath=Ext.getCmp("ExcelImportPath").getValue();  //要导入的模板
		var sheet_id=Ext.getCmp("sheetid").getValue();  //要导入第几个表
		if( efilepath.indexOf("fakepath")>0 ) {alert ("请在IE下执行导入！"); return;}
		if( efilepath.indexOf(".xls")<=0 ) {alert ("请选择excel表格文件！"); return;}
		if(sheet_id=="") {alert ("请填写要导入模板里的第几个sheet！"); return;}
		var kbclassname=""  //类名
		var sheetcount=2  //模板中表的个数
		var file=efilepath.split("\\");
		var filename=file[file.length-1];  
		if(filename.indexOf("DRUGData")>=0){
		    kbclassname="web.DHCBL.BDP.ImportKBData"
		    sheetcount=42
		 }
		 if(filename.indexOf("LABData")>=0){
		    kbclassname="web.DHCBL.BDP.ImportLABData"
		    sheetcount=16
		 }
		 if(filename.indexOf("CheckData")>=0){
		     kbclassname="web.DHCBL.BDP.ImportCheckData"
		     sheetcount=15
		 }
		 if(filename.indexOf("ELECTData")>=0){
		      kbclassname="web.DHCBL.BDP.ImportELECTData"
		      sheetcount=16
		 }
		 
		 if ((sheet_id<2)||(sheet_id>sheetcount))
		 {
		 	alert ("模板里没有该sheet！"); return;
		 }
		try{ 
			var oXL = new ActiveXObject("Excel.application"); 
			var oWB = oXL.Workbooks.open(efilepath);   //xlBook = xlApp.Workbooks.add(ImportFile);		
		}		
		catch(e){
			var emsg="请在[internet选项]-[安全]-[受信任的站点]-[站点]中添加开始界面到可信任的站点，然后在[自定义级别]中对[没有标记为安全的ActiveX控件进行初始化和脚本运行]这一项设置为启用!"
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
		
		 	if (kbclassname!="")
		 	{	 	  
			  //for(var sheet_id=2;sheet_id<=sheetcount;sheet_id++) {
			 //if((sheet_id!=9)&(sheet_id!=13)){
				var errorRow="";//没有插入的行
				var errorMsg="";//错误信息
				oWB.worksheets(sheet_id).select(); 
				var oSheet = oWB.ActiveSheet; 
				var rowcount=oXL.Worksheets(sheet_id).UsedRange.Cells.Rows.Count ;
				var colcount=oXL.Worksheets(sheet_id).UsedRange.Cells.Columns.Count ;
				
				/*Ext.MessageBox.wait('正在导入'+oSheet.name+'的数据，请勿刷新或关闭界面，请稍后...','提示');
				//alert(rowcount+"^"+colcount);
				for(var i=2;i<=rowcount;i++){
					var tempStr = ""; //每行数据（第一列[next]第二列[next]...）
					var row=i
					for (var j=1;j<=colcount;j++){
						var cellValue=""
						if(typeof(oSheet.Cells(i,j).value)=="undefined"){
							cellValue=""
						}else{
							cellValue=oSheet.Cells(i,j).value
						}
						tempStr+=(cellValue+"[next]")
					}
					var Flag =tkMakeServerCall(kbclassname,"SaveData",tempStr,sheet_id,row);
					//alert(kbclassname+"^"+tempStr+"^"+Flag);
					if (Flag=="true"){
						errorRow=errorRow
						
					}else{
						if(errorRow!=""){
							errorRow=errorRow+","+i
						}else{
							errorRow=i
						}
					}
					tempStr=""
				} 
				if(errorRow!=""){
					errorMsg=oSheet.name+"表导入完成，第"+errorRow+"行插入失败!" ;			
				}else{
					errorMsg=oSheet.name+"表导入完成!"
				}
				Ext.MessageBox.hide();
				//alert(errorMsg)
				//提示信息
				Ext.Msg.show({
						title : '提示',
						msg : errorMsg ,
						minWidth : 200,
						icon : Ext.Msg.INFO,
						buttons : Ext.Msg.OK
				})*/
					
				var row=1,ProgressText='';
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
		
						var tempStr = ""; //每行数据（第一列[next]第二列[next]...）
						var i=row
						for (var j=1;j<=colcount;j++){
							var cellValue=""
							if(typeof(oSheet.Cells(i,j).value)=="undefined"){
								cellValue=""
							}else{
								cellValue=oSheet.Cells(i,j).value
							}
							tempStr+=(cellValue+"[next]")
						}
						var Flag =tkMakeServerCall(kbclassname,"SaveData",tempStr,sheet_id,row);
						//alert(kbclassname+"^"+tempStr+"^"+Flag);
						if (Flag=="true"){
							errorRow=errorRow
							
						}else{
							if(errorRow!=""){
								errorRow=errorRow+","+i
							}else{
								errorRow=i
							}
						}
						tempStr=""
					    progressText = "正在导入"+oSheet.name+"表的第"+row+"条记录,总共"+rowcount+"条记录!";  
					    proBar.updateProgress(row/rowcount,progressText);
					  }
						 
				  },  
				  interval:100  
				});
				win2.show();

		  	}
		  	else
		  	{
			   //提示信息
				Ext.Msg.show({
						title : '提示',
						msg : '该知识库模板名不能识别！<br>知识库模板名要包含：DRUGData、LABData、CheckData或ELECTData！<br>注意：请勿随意修改模板！否则会影响数据导入！' ,
						minWidth : 200,
						icon : Ext.Msg.ERROR,
						buttons : Ext.Msg.OK
				})
		  	
		  	}
		  	/*oWB.Close(savechanges=false);
			CollectGarbage();
				
			oXL.Quit(); 
			oXL=null;
			oSheet=null;*/	
		


  }

	function IsExistsFile(filepath)
        {
            var xmlhttp=new ActiveXObject("Microsoft.XMLHTTP");
            xmlhttp.open("GET",filepath,false);
            xmlhttp.send();
            if(xmlhttp.readyState==4){   
                if(xmlhttp.status==200) return true; //url存在   
                else if(xmlhttp.status==404) return false; //url不存在   
                else return false;//其他状态   
            } 
        }
	//下载知识库模板
	function LoadKBData(id){
		var filepath = document.getElementById(id).value;
		var isExists=IsExistsFile(filepath)
		if(isExists){
			location.href=filepath;
		}else{
			Ext.Msg.show({
				title : '提示',
				msg : "该文件不存在" ,
				minWidth : 200,
				icon : Ext.Msg.INFO,
				buttons : Ext.Msg.OK
			}) 
		}
	

	}
	function ExportKBData() {
			Ext.MessageBox.confirm('提示', '确定要导出数据吗?', function(btn) {
				if (btn == 'yes') {
					var ekbclassname="";
					var tablename=Ext.getCmp("exportsheetnameF").getValue();  //要导出哪个知识库
					var table=Ext.getCmp("exportsheet").getValue();  //要导出第几个表
					if (table=="")
					{
					 	alert ("请填写要导出模板里的第几个sheet！"); return;
					}
					
					
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
					
					
				  if(tablename.indexOf("LABData")>=0)
					 {
						    ekbclassname="web.DHCBL.BDP.ExportLABData"
						   if ((table<2)||(table>16))
						 	{
							 	alert ("目前只能导出检验知识库模板中第2个到第16个sheet的数据！"); return;
							}
					 }
					else if(tablename.indexOf("CheckData")>=0)
					{
						     ekbclassname="web.DHCBL.BDP.ExportCheckData"
						    if ((table<2)||(table>15))
							{
							 	alert ("目前只能导出放射、超声、内镜知识库模板中第2个到第15个sheet的数据！"); return;
							}
					 }
					 else if(tablename.indexOf("ELECTData")>=0)
					 {
					      ekbclassname="web.DHCBL.BDP.ExportELECTData"
					      if ((table<2)||(table>16))
						  {
						 	alert ("目前只能导出心电知识库模板中第2个到第16个sheet的数据！"); return;
						  }
					 }
					 else
					 {
						 ekbclassname="web.DHCBL.BDP.ExportKBData"
						    if ((table<2)||(table>42))
							{
							 	alert ("目前只能导出药品知识库模板中第2个到第42个sheet的数据！"); return;
							}
					 }
					 

					///菜单
					var sheetname=tkMakeServerCall(ekbclassname,"GetName",table);
					Ext.MessageBox.wait('正在导出'+sheetname+'数据，请勿刷新或关闭页面，请稍候...','提示');
					xlBook.worksheets(1).select(); 
					var xlsheet = xlBook.ActiveSheet; 
					xlsheet.name = sheetname;
					var count=tkMakeServerCall(ekbclassname,"GetCount",table);
					var titleStr=tkMakeServerCall(ekbclassname,"GetTitle",table);
					//alert(titleStr)
					var title=titleStr.split("&%");
					for (var i = 0; i < title.length; i++) {    				
						//1b	
			    		xlsheet.cells(1,i+1)=title[i];
	
					}
					for (var i=1;i<=count;i++){
						var DataDetailStr2=tkMakeServerCall(ekbclassname,"GetInfo",table,i);
						var Detail2=DataDetailStr2.split("&%");		
						for (var j=1;j<=title.length;j++){
							xlsheet.cells(1+i,j)=Detail2[j-1];
							xlsheet.cells(1+i,j)=Detail2[j-1];
						}	
					}
				
					Ext.MessageBox.hide();
				
					xlApp.Visible=true;	
					xlBook.Close(savechanges=true);
					//xlApp.Quit();
					CollectGarbage();
					xlApp=null;
					xlsheet=null;
							
			
				
				
				}
			}, this);
		}

	var formSearch = new Ext.form.FormPanel({
		title:'临床知识库数据导入',
		frame:true,
		border:false,
		region: 'center',
		autoScroll:true,
		width:600,
		height:200,
		split: true,
		buttonAlign:'center',
		items:[
		{
			xtype: 'fieldset',
			title:'下载知识库模板',
			labelWidth:120,	
			labelAlign:'right',
			width:700,
            autoHeight: true, 
            layout:'form',  
            border:true,  
            //anchor:'100%',
			items:[
			{ // 行1
          		layout : "column",
          		items : [
          		   {
		             columnWidth : .2,
		             layout : "form",
		             items : [
		             	{
			                width:400,
							fieldLabel:'药品知识库模板',
							xtype : 'textfield',
							hidden:true,
							value:"../scripts/bdp/APPHelp/Doc/DRUGData.xls",
							id : 'LoadDrugPath',
							readOnly:true
				  	 	}]
		           }, 
		           {
		             columnWidth : .8,
		             layout : "form",
		             items : [
		             	{
			        		iconCls : 'icon-import',
			        		text:'下载',
			        		xtype : 'button',
							listeners : {
								"click" : function() {  
									LoadKBData("LoadDrugPath");
								  }
							}
					  	}]
		            }]
		     },
			 { // 行2
          		layout : "column",
          		items : [
          		   {
		             columnWidth : .2,
		             layout : "form",
		             items : [
						{	
							width:400,
							fieldLabel:'检验知识库模板',
							xtype : 'textfield',
							hidden:true,
							value:"../scripts/bdp/APPHelp/Doc/LABData.xls",
							id : 'LoadLabPath',
							readOnly:true
						}]
		           }, 
		           {
		             columnWidth : .8,
		             layout : "form",
		             items : [
						{
			        		iconCls : 'icon-import',
			        		text:'下载',
			        		xtype : 'button',
							listeners : {
								"click" : function() {  
									LoadKBData("LoadLabPath");
								  }
							}
						}]
		            }]
		     },
		     { // 行3
          		layout : "column",
          		items : [
          		   {
		             columnWidth : .2,
		             layout : "form",
		             items : [
						{	
							width:400,
							fieldLabel:'检查知识库模板',
							xtype : 'textfield',
							hidden:true,
							value:"../scripts/bdp/APPHelp/Doc/CheckData.xls",
							id : 'LoadCheckPath',
							readOnly:true
						}]
		           }, 
		           {
		             columnWidth : .8,
		             layout : "form",
		             items : [
		             	{
			        		iconCls : 'icon-import',
			        		text:'下载',
			        		xtype : 'button',
							listeners : {
								"click" : function() {  
									LoadKBData("LoadCheckPath");
								  }
							}
						}]
		            }]
		     },
		     { // 行4
          		layout : "column",
          		items : [
          		   {
		             columnWidth : .2,
		             layout : "form",
		             items : [
		             	{	
							width:400,
							fieldLabel:'心电知识库模板',
							xtype : 'textfield',
							hidden:true,
							value:"../scripts/bdp/APPHelp/Doc/ELECTData.xls",
							id : 'LoadElectPath',
							readOnly:true
						}]
		           }, 
		           {
		             columnWidth : .8,
		             layout : "form",
		             items : [
		             	{
			        		iconCls : 'icon-import',
			        		text:'下载',
			        		xtype : 'button',
							listeners : {
								"click" : function() {  
									LoadKBData("LoadElectPath");
								  }
							}
						}]
		            }]
		     }
			]
		},
		{
			xtype: 'fieldset',
			title:'导入知识库模板数据',
			labelWidth:120,		
			labelAlign:'right',
			autoHeight: true,
			width:700,
			defaultType:'textfield',
			items:[	 
			{
				width: 400,
				fieldLabel:'<font color=red>*</font>导入Excel文件',
				xtype : 'textfield',
				inputType:'file',
				id : 'ExcelImportPath'
			},{
				width: 400,
				fieldLabel:'<font color=red>*</font>第几个sheet',
				xtype : 'numberfield',
				id : 'sheetid'
			},
			{
				iconCls : 'icon-import',
				text:'导入',
				xtype : 'button',
				listeners : {
					"click" : function() {
						ImportKBData();
					 }
				}
			}
			]
		},
		{
			xtype: 'fieldset',
			title:'导出知识库模板数据',
			labelWidth:120,		
			labelAlign:'right',
			autoHeight: true,
			width:700,
			defaultType:'textfield',
			items:[{
				width: 400,
				fieldLabel:'<font color=red>*</font>导出知识库模板名称',
				xtype : 'combo',
				id : 'exportsheetnameF',
				name : 'exportsheetname',
				hiddenName : 'exportsheetname',
				value:"药品知识库模板",
				mode : 'local',
				triggerAction : 'all',
				valueField : 'value',
				displayField : 'name',
				editable: false	,
				store:new Ext.data.SimpleStore({
								fields:['value','name'],
								data:[
									      ['DRUGData','药品知识库模板'],
									      ['LABData','检验知识库模板'],
									      ['CheckData','放射、超声、内镜知识库模板'],
									      ['ELECTData','心电知识库模板']
								     ]
							})
			},{
				width: 400,
				fieldLabel:'<font color=red>*</font>第几个sheet',
				xtype : 'numberfield',
				id : 'exportsheet'
			},
			{
				iconCls : 'icon-import',
				text:'导出',
				xtype : 'button',
				listeners : {
					"click" : function() {
						ExportKBData();
					 }
				}
			}
			]
		},
		{
            title:"备注说明",
            width:700,
			html : "<ui><br></ui> <ui><li>1.需在IE下执行操作。</li></ui> <ui><li>2.下载知识库模板时，选择【另存为】的话，文件名要包含：DRUGData/LABData/CheckData/ELECTData，并且要保存为xls/xlsx格式。</li></ui> <ui><li>3.下载下来的模板请勿随意修改，否则会影响数据导入！</li></ui> <ui><li>4.excel录入时要严格遵循示例格式。</li></ui> <ui><li>5.与HIS对照的表要保证HIS代码和描述在HIS表中存在并录入正确。</li></ui> <ui><li>6.录入业务字典时（模板中蓝色页签部分）要保证对应的基础字典存在，否则无法导入。</li></ui><ui><li>7.导入顺序：心电知识库要在检验知识库之后。</li></ui><ui><li>8.若下载时提示文件不存在，说明服务器上没有该模板，请联系开发人员。</li></ui><ui><li>9.若导入模板过程中报错或插入失败，请仔细检查录入数据是否正确。修改后的数据可在相应界面手动录入，也可重新导一遍。</li></ui>   "
                
		}]
	});

	
	// 创建viewport
	var viewport = new Ext.Viewport({
				layout : 'border',
				items : [formSearch]
	});
	
	
	

});
