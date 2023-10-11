var columns = [
	[	
		{ field: "ReportRowId", title: "上报项目分类ROWID", width: 240 ,hidden:true},
		{ field: "ReportCatRowId", title: "上报项目分类ROWID", width: 240 ,hidden:true},
		{ field: "ReportCatDesc", title: "上报项目分类", width: 240},
		{ field: "ReportCode", title: "代码", width: 240},
		{ field: "ReportDesc", title: "名称", width: 240 },
		{ field: "ReportType", title: "检查分类", width: 240},
	]]
	$(function(){
		$("#importExcel").hide()
		$("#ItemTypeBox").combobox({
		valueField:'RRowId',
		textField:'RDesc',
		url:$URL+"?ClassName=web.DHCBPReportCat&QueryName=SelectReportCat&ResultSetType=array"
		});
		$("#ItemType").combobox({
		valueField:'RRowId',
		textField:'RDesc',
		url:$URL+"?ClassName=web.DHCBPReportCat&QueryName=SelectReportCat&ResultSetType=array",
		});	
		var grid = $("#dataBox").datagrid({
			url:$URL,		
			columns:columns,
			queryParams:{
	            ClassName:"web.DHCBPReport",
	            QueryName:"SelectReport"
	        },
			fit:true,
			fitColumns:true,
			singleSelect:true,
			rownumbers:true,//行号
			pagination:true,//分页工具条
			pageSize:20,
			pageList:[20,40,60],
			toolbar:'#dataTools'
		});
	})
	
	$("#btnImp").click(function(){
	 	ImportData();
	});	
	
	/// 下载数据模板
	$("#import_template_btn").click(function(){
	 	DownloadTemplate();
	});	
	
	$("#btnAdd").click(function(){
		var win =$('#win').dialog({
			title:"上报内容追加",
			width: 350,
			height: 350,
			modal: true,
			buttons:[
				{
					text:"保存",
					iconCls:"icon-w-save",
					handler:function(){
						var ReportCatDr =$("#ItemType").combobox('getValue');
						var ReportCode =$("#ReportCode").val();
						var ReportDesc =$("#ReportName").val();
						var ReportType =$("#ExaminationType").combobox('getValue');
						if (ReportCode=="" || ReportDesc=="" )
						{
							$.messager.show({
							timeout:2000,
							title:"提示",
							msg:"请输入上报项目代码和描述",
							showType:'slide'
							});
						}else
						{
						$m({
							ClassName:"web.DHCBPReport",
							MethodName:"InsertReport",
							ReportCatDr:ReportCatDr,
							Code:ReportCode,
							Desc:ReportDesc,
							BPRType:ReportType
							},function (textData){
							if(textData.indexOf("成功")>0)
							{	
								$.messager.show({
								timeout:1000,
								title:"提示",
								msg:"添加成功",
								showType:'slide',
								});
								$HUI.dialog('#win').close();	
							}else{
								alert(textData);	
							}
						});
						$('#dataBox').datagrid('reload');	
					}},
				},
				
				{
					text:"清空",
					iconCls:"icon-w-clean",
					handler:function(){
						$("#ItemType").combobox('setValue',"");
						$("#ReportCode").val("");
						$("#ReportName").val("");
						$("#ExaminationType").combobox('setValue',"");
					}
				},
				]
			})
	})
	$("#btnEdit").click(function(){
		var Row =$('#dataBox').datagrid('getSelected');				
		if (!Row){
		$.messager.show({
			timeout:1000,
			title:"提示",
			msg:"请选中更新的数据",
			showType:'slide'
		});
		}else{
			$("#ItemType").combobox('select',Row.ReportCatRowId);
			$("#ReportCode").val(Row.ReportCode);
			$("#ReportName").val(Row.ReportDesc);
			$("#ExaminationType").combobox('select',Row.ReportType);
			var ReportRowId=Row.ReportRowId	
			var win =$('#win').dialog({
				title:"上报内容更新",
				width: 350,
				height: 350,
				modal: true,
				buttons:[
					{
						text:"保存",
						iconCls:"icon-w-save",
						handler:function(){	
							$("#ItemType").combobox('getValue')			
							var ReportCatDr =$("#ItemType").combobox('getValue');
							var ReportCode =$("#ReportCode").val();
							var ReportDesc =$("#ReportName").val();
							var ReportType =$("#ExaminationType").combobox('getValue');
							if (ReportCode=="" || ReportDesc==""|| ReportCatDr==""||ReportType=="")
							{
								$.messager.show({
								timeout:2000,
								title:"提示",
								msg:"请输入上报项目所有内容",
								showType:'slide'
								});
							}else
							{
								
							$m({
								ClassName:"web.DHCBPReport",
								MethodName:"UpdateReport",
								RowId:ReportRowId,
								ReportCatDr:ReportCatDr,
								Code:ReportCode,
								Desc:ReportDesc,
								BPRType:ReportType
								},function(textData){
								if(textData.indexOf("成功")>0)
								{	
									$.messager.show({
									timeout:500,
									title:"提示",
									msg:"添加成功",
									showType:'slide',
									});
								$HUI.dialog('#win').close();
								$("#ItemType").combobox('setValue',"");
								$("#ReportCode").val("");
								$("#ReportName").val("");
								$("#ExaminationType").combobox('setValue',"");
								$('#dataBox').datagrid('reload');																
								}else{
									alert(textData);	
								}
							});	
						}},
					},
					
					{
						text:"清空",
						iconCls:"icon-w-save",
						handler:function(){
							$("#ItemType").combobox('setValue',"");
							$("#ReportCode").val("");
							$("#ReportName").val("");
							$("#ExaminationType").combobox('setValue',"");
						}
					},
					]
				})
		}
	})
	
	$("#btnDel").click(function(){
		var Row =$('#dataBox').datagrid('getSelected');
		if (!Row)
		{
			$.messager.show({
				timeout:1000,
				title:"提示",
				msg:"请选中删除的数据",
				showType:'slide'
			});
		}else
		{
			var oldOk = $.messager.defaults.ok;
			var oldCancel = $.messager.defaults.cancel;
			$.messager.defaults.ok = "同意";
			$.messager.defaults.cancel = "拒绝";
			$.messager.confirm("删除", "确定删除二级目录以及三级目录相关数据吗?", function (r) {
			if (r) {
				$m({
					ClassName:"web.DHCBPReport",
					MethodName:"DeleteReport",
					RowId:Row.ReportRowId,
					},function (textData){
					if(textData.indexOf("S^")!=-1)
					{	
						$.messager.show({
						timeout:1000,
						title:"提示",
						msg:"已删除",
						showType:'slide'
						});
						$('#dataBox').datagrid('reload');
					}else{
						alert(textData);	
					}
				});
			} else {
				$.messager.popover({ msg: "点击了取消" });
			}})
			$.messager.defaults.ok = oldOk;
			$.messager.defaults.cancel = oldCancel;
			}
	})
	$("#btnFind").click(function(){
		var ReportDr=$("#ItemTypeBox").combobox('getValue');
		var ReportDesc=$("#ReportDesc").val();
		$("#dataBox").datagrid('load',{
			ClassName:"web.DHCBPReport",
			QueryName:"SelectReport",
			ReportItemType:ReportDr,
			Desc:ReportDesc
			});
	})
	/// 导入操作
	function ImportData(){
		$("#importExcel").show();		
		$("#importExcel").dialog({
			iconCls:'icon-w-import',
			resizable:true, 
			height:390,
			modal:true  , 
			buttons:[{
				text:'导入',
				style:'marginTop:10px;',					
				id:'importdata_btn',
				handler:function(){  
					uploadExcel() 
				}
			},{
				text:'取消', 
				style:'marginTop:10px;',
				id:'importdata_btn',
				handler:function(){  
					$("#importExcel").dialog("close");
				}
			}]
		});  
	}
	/// 下载数据模板
	function DownloadTemplate(){
		var rtn = tkMakeServerCall("web.DHCBPReport","ProductTemplate","DHCBPReportTemplate"); 
		location.href = rtn;
	}
	
	
	//上传Excel
	function uploadExcel() { 
			var efilepath=$('#ExcelImportPath').val();  //要导入的模板
			if (efilepath){
				if(efilepath.indexOf("fakepath")>0 ) {
					$.messager.alert('错误提示', '请在IE下执行导入！',"error");   
					return;
				}
				if((efilepath.indexOf(".xls")<=0) &&(efilepath.indexOf(".csv")<=0)) { 
					$.messager.alert('错误提示', '文件类型不正确,请选择.xls文件！',"error");  
					return;
				} 
				else{  
					var kbclassname=""  //类名
					var sheet_id =1;
					var file=efilepath.split("\\");
					var filename=file[file.length-1];  
					try{ 
						var oXL = new ActiveXObject("Excel.application"); 
						var oWB = oXL.Workbooks.open(efilepath);  	
					}		
					catch(e){
						var emsg="请在[internet选项]-[安全]-[受信任的站点]-[站点]中添加开始界面到可信任的站点，然后在[自定义级别]中对[没有标记为安全的ActiveX控件进行初始化和脚本运行]这一项设置为启用!"
						$.messager.alert('提示',emsg,"error"); 
						return;
					}
					
					$('#importload').dialog({ 
						resizable:true, 
						modal:true  
					});  
					$('#importload').dialog('open'); //显示进度条 
				
					var errorRow="";//没有插入的行
					var errorMsg="";//错误信息
					oWB.worksheets(sheet_id).select(); 
					var oSheet = oWB.ActiveSheet; 
					var rowcount=oXL.Worksheets(sheet_id).UsedRange.Cells.Rows.Count ; /// 行数
					var colcount=oXL.Worksheets(sheet_id).UsedRange.Cells.Columns.Count ; ///列数
					var ProgressText='';
					for (row=2;row<=rowcount;row++){ 
						var tempStr = ""; //每行数据（第一列[next]第二列[next]...）
						var i=row
						
						for (var j=1;j<=colcount;j++){
							var cellValue=""
							if(typeof(oSheet.Cells(i,j).value)=="undefined"){
								cellValue="";
							}	
							else{
								cellValue=oSheet.Cells(i,j).value;
								if (typeof(cellValue) == "date"){
									cellValue=(new Date(cellValue)).getFullYear() + '/' + ((new Date(cellValue)).getMonth() + 1) + '/' + (new Date(cellValue)).getDate();
								}
								
							}
							tempStr+=(cellValue+"#"); 	
						}	 
						var kbclassname ="web.DHCBPReport";
						var Flag =tkMakeServerCall(kbclassname,"ImportExcel",tempStr); 
						if (Flag.indexOf("true")>0){
							errorRow=errorRow
						}
						else{
							if(errorRow!=""){
								errorRow=errorRow+","+i
							}else{
								errorRow=i
							}
						}
						tempStr="";  
						progressText = "正在导入"+oSheet.name+"表的第"+row+"条记录,总共"+rowcount+"条记录!";  
						setInterval(function(){  
							$('#pro').progressbar('setValue',row/rowcount*100);  
							$('#pro').attr('text',progressText); 
						}, 1000);  
						if(row==rowcount) //当到达最后一行退出
						{ 
							if(errorRow!=""){
								errorMsg=oSheet.name+"表导入完成，第"+errorRow+"行插入失败!" ;			
							}else{
								errorMsg=oSheet.name+"表导入完成!"
							}
							$('#pro').progressbar('setValue', 100); 
							progressText = "正在导入"+oSheet.name+"表的记录,总共"+rowcount+"条记录!";  
							$('#pro').attr('text', progressText);   
	  
							oWB.Close(); 
							oXL.Quit(); 
							oXL=null;
							oSheet=null; 
							if (errorRow!=""){
								$.messager.alert('错误提示',errorMsg,"error"); 
							}else{
								$.messager.alert('提示',errorMsg,"success"); 
							}
							$('#importload').window('close'); 
						}  
					  $('#importExcel').window('close'); 
					} 
				}
			}
			else{
				$.messager.alert('错误提示', '请选择将要上传的文件!',"error");    
			}
	}