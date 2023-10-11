	
	/// 名称:导入导出医疗机构数据
	/// 编写者:基础数据平台组 - 高姗姗
	/// 编写日期:2016-11-3

Ext.onReady(function() {
	
	var ReadExcel=function (efilepath,sheet_from,sheet_to,row_from,importclassname,importmethod)
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
			var errorMsg="";//错误信息
			
		
			for(var sheet_id=sheet_from;sheet_id<=sheet_to;sheet_id++) {
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
				/*alert(sheetname+rowcount+"^"+colcount)
				if (rowcount>10) 
				{
					rowcount=10
				}
				*/
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
					var Flag =tkMakeServerCall(importclassname,importmethod,sheetname,tempStr);
					//alert(Flag)
					if (Flag=="0"){  //保存失败
						if(errorRow!=""){
							errorRow=errorRow+","+i
						}else{
							errorRow=i
						}
					}
					/*if (Flag=="1"){  //修改或新增成功
						if(updateRow!=""){
							updateRow=updateRow+","+i
						}else{
							updateRow=i
						}
					}*/
					
					
					/*if (Flag=="2"){  //导入数据与原数据相同 跳过导入
						if(skipRow!=""){
							skipRow=skipRow+","+i
						}else{
							skipRow=i
						}
					}*/
			
				} 
				/*if(updateRow!=""){
					str=str+"第"+updateRow+"行更新数据库成功。";
				}*/
				if(errorRow!=""){
					str=str+"第"+errorRow+"行插入失败。";
				}
				/*if(skipRow!=""){
					str=str+"第"+skipRow+"行与原数据库中数据相同，跳过导入步骤。";
				}*/
				
				Ext.MessageBox.hide();
				alert(str);
			}
			oWB.Close(savechanges=false);
			oXL.Quit(); 
			CollectGarbage();
			
			oXL=null;
			oSheet=null;	
		
		
	}
	
	
	
	
	///从excel导入
  var ExcelImport=function (){
  		var efilepath=Ext.getCmp("ExcelImportPath").getValue();
		if( efilepath.indexOf("fakepath")>0 ) {alert ("请在IE下执行导入！"); return;}
		if( efilepath.indexOf(".xls")<=0 ) {alert ("请选择excel表格文件！"); return;}
		
		var sheet_from=1,sheet_to=1,row_from=2;
		var importclassname="web.DHCBL.CT.CHSSDictHospital",importmethod="ImportExcel";  //导入医疗机构数据
		//var importclassname="web.DHCBL.BDP.CImportDisKB",importmethod="ImportExcel";  //导入诊断知识库
		ReadExcel(efilepath,sheet_from,sheet_to,row_from,importclassname,importmethod);
		
		
  }
	
	
	
	var formSearch = new Ext.form.FormPanel({
		title:'导入数据',
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
		},
		{
                	title:"备注说明",
                	width:700,
					html : "<ui><li>1.导入时需选择正确的xls/xlsx格式的文件。</li></ui> <ui><li>2.需在IE下执行操作,并在[internet选项]-[安全]-[受信任的站点]-[站点]中添加开始界面到可信任的站点，然后在[自定义级别]中对[没有标记为安全的ActiveX控件进行初始化和脚本运行]这一项设置为启用。</li></ui> <ui><li>3.导入的为User.CTHospital（医院）CHSS.DictHospital（医疗机构）表的数据。Excel文件导入原则：code相同的数据，如果与原数据库完全相同则跳过，code不同的数据新增，方便更新数据</li></ui> "
                
		}]
	});

	
	// 创建viewport
	var viewport = new Ext.Viewport({
				layout : 'border',
				items : [formSearch]
	});
	
	
	

});
