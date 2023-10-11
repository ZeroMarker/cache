	
	/// 名称:导入导出地址数据
	/// 编写者:基础数据平台组 - 陈莹
	/// 编写日期:2015-01-09

Ext.onReady(function() {
	
	var idTmr
	
	Cleanup=function (){
		if(idTmr) 
		{
	 		window.clearInterval(idTmr);    //取消由setInterval()方法设置的定时器。
		}
	 	CollectGarbage();
	}
	
	var ReadExcel=function (efilepath,sheet_id,row_from,importclassname,importmethod)
		{	
		try{
			var oXL = new ActiveXObject("Excel.application"); 
			var oWB = oXL.Workbooks.open(efilepath);   //xlBook = xlApp.Workbooks.add(ImportFile);
		}		
		catch(e){
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
		//var str=oSheet.name+"sheet导入完成。";
		//Ext.MessageBox.wait('正在导入'+oSheet.name+'数据，请勿刷新或关闭页面，请稍候...','提示');
		/*alert(sheetname+rowcount+"^"+colcount)
		if (rowcount>10) 
		{
			rowcount=10
		}
		*/
		var row=row_from-1,ProgressText='';
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
				var Flag =tkMakeServerCall(importclassname,importmethod,sheetname,tempStr);
				//alert(tempStr)
				if (Flag=="0"){  //保存失败
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
	
	

	
	///从excel导入
  var ExcelImport=function (){
  		var efilepath=Ext.getCmp("ExcelImportPath").getValue();
		if( efilepath.indexOf("fakepath")>0 ) {alert ("请在IE下执行导入！"); return;}
		if( efilepath.indexOf(".xls")<=0 ) {alert ("请选择excel表格文件！"); return;}
		
		var import_sheet=Ext.getCmp("sheetid").getValue();  //要导入第几个表
		var row_from=Ext.getCmp("sheetRow").getValue();  //要从第几行开始导
		if ((import_sheet=="")||(row_from=="")) {alert ("有必填项没填！"); return;}
		if ((import_sheet<1)||(import_sheet>7)) {alert ("只能填1到7这几个整数！"); return;}
		if (row_from<2) {alert ("至少从第二行开始导！"); return;}
		//var sheet_from=1,sheet_to=7,row_from=2;
		var importclassname="web.DHCBL.BDP.CImportaddress",importmethod="ImportExcel";  //导入地址数据
		ReadExcel(efilepath,import_sheet,row_from,importclassname,importmethod);

  }
	
	
	
	var formSearch = new Ext.form.FormPanel({
		title:'导入地址数据',
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
			{width: 400,fieldLabel:'<font color=red>*</font>导入Excel文件',xtype : 'textfield',inputType:'file',id : 'ExcelImportPath'}
			,{
				width: 400,
				fieldLabel:'<font color=red>*</font>导第几个sheet',
				xtype : 'numberfield',
				allowDecimals:false,  //小数
				allowNegative:false,  //负数
				allowBlank : false,
				id : 'sheetid'
			},
			{
				width: 400,
				fieldLabel:'<font color=red>*</font>从第几行开始导',
				xtype : 'numberfield',
				allowDecimals:false,
				allowNegative:false,
				allowBlank : false,
				id : 'sheetRow',
				value:2
			},
			{iconCls : 'icon-import',text:'导入',xtype : 'button',
				listeners : {
					"click" : function() {  
						ExcelImport();   
					}
				}
			}
			]
		},
		{
                	title:"备注说明",
                	width:700,
					html : "<ui><li>1.导入时需选择正确的xls/xlsx格式的文件。</li></ui> <ui><li>2.需在IE下执行操作,并在[internet选项]-[安全]-[受信任的站点]-[站点]中添加开始界面到可信任的站点，然后在[自定义级别]中对[没有标记为安全的ActiveX控件进行初始化和脚本运行]这一项设置为启用。</li></ui> <ui><li>3.导入的为User.CTProvince（省）、User.CTCity（城市）、User.CTCityArea（城市区域）、User.CTLocalityType（街道）、User.CTCommunity（社区）、User.CTAddress（地址）、User.CTZip（邮编）这7个表的数据。Excel文件导入原则：code相同的数据，如果与原数据库完全相同则跳过，有变动则修改，code不同的数据新增，方便更新数据</li></ui> "
                
		}]
	});

	
	// 创建viewport
	var viewport = new Ext.Viewport({
				layout : 'border',
				items : [formSearch]
	});
	
	
	

});
