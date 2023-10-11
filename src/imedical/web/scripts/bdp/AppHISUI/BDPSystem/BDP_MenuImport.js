/// Function:BDP菜单导入导出HISUI版
///	Creator: gaoshanshan
$(function () {
	var rowcount="" //总行数
	var colcount="" //总列数
	//读取Excel表格
    parseExcelFile=function ()
	{     
		var files=$('#fileCheck').filebox('files')
		if (!files.length) {
			$.messager.alert('提示','请先选择文件!','error');
			return;
		}
		var file = files[0];
		var filename=file.name  //文件名
		if (filename=="")
		{
			$.messager.alert('提示','请先选择文件!','error');
			return;
		}
		var errorRow="";//没有插入的行
        var str=filename+"导入完成。";
		var killstr=tkMakeServerCall("web.DHCBL.BDP.BDPMenuImport","killPar"); 
		var reader = new FileReader();
		reader.onload = function(event) {
			var arrayBuffer = reader.result;
			var options = { type: 'array', cellDates: true , cellText: false};
			var workbook = XLSX2.read(arrayBuffer, options);

			var sheetName = workbook.SheetNames[0];  //只读取第一个sheet
			var sheet = workbook.Sheets[sheetName]
			
			str=sheetName+"sheet导入完成。";
			
			var Columndatas= XLSX2.utils.sheet_to_json(sheet,{range:1}) 
			var ColumnsCode=[],ColumnsDesc=[];
			// 第一行列名（模板中文描述）
			for(var col in Columndatas[0]){
			    ColumnsDesc.push(col)
			}
		    for (var i = 0; i < ColumnsDesc.length; i++)
			{
				ColumnsCode.push(Columndatas[0][ColumnsDesc[i]])
			}
			
			var datas= XLSX2.utils.sheet_to_json(sheet,{range:2})  //跳过标题解析，从内容开始  
			rowcount = datas.length //总行数
			colcount = ColumnsCode.length//总列数
			
			$('#prowin').show();
            var prowin = $HUI.dialog("#prowin", {
                iconCls: 'icon-w-import',
                resizable: false,
                title: '',
                modal: true
            });
            $('#pro').progressbar({
                text: "正在处理中，请稍后...",
                value: 0
            });
			var row=0,ProgressText='',taskcount=rowcount;
			var myVar = setInterval(function () {
			  	row++;
			  	if(row>taskcount) //当到达最后一行退出
			  	{
			  		$('#prowin').dialog('close')
                    clearInterval(myVar)
			  	}
			  	else
			  	{
			  		progressText = "正在导入第" + row + "条记录,总共" + taskcount + "条记录!";
		            $('#pro').progressbar({
		                text: progressText,
		                value: 100 * row / taskcount
		            });
		            
				  	var ColumnsValue=[]
				    for (var j = 0; j < ColumnsCode.length; j++)
					{
						ColumnsValue.push(datas[row-1][ColumnsCode[j]])
					}
				    var tempStr=ColumnsValue.join("#")
			  		var Flag =tkMakeServerCall("web.DHCBL.BDP.BDPMenuImport","ImportExcel",sheetName,tempStr);
			  		if (Flag=="0"){  //保存失败
						if(errorRow!=""){
							errorRow=errorRow+","+(parseInt(row)+3) //排除3行标题行
						}else{
							errorRow=parseInt(row)+3
						}
						console.log(errorRow)
					}
			  		
			  	}
			},20)
			
			setTimeout(function(){
				if(errorRow!=""){
					str=str+"第"+errorRow+"行插入失败。";
				}
				$.messager.alert('提示',str,"info");
				///把父菜单dr没有导成功的菜单重新获取父菜单dr并保存
				var Restr=tkMakeServerCall("web.DHCBL.BDP.BDPMenuImport","ReImportParentMenuDr"); 
			},20*parseInt(rowcount))
		};
		reader.readAsArrayBuffer(file);
	}
	//导出菜单
	$('#btnExportMenu').click(function(e){
    	ExportMenuToExcel()			
    });
	
	//导出菜单到Excel
    function ExportMenuToExcel() 
    {
    	var xlsName="菜单"
    	var taskcount=tkMakeServerCall("web.DHCBL.BDP.BDPMenuImport","GetMenuCount");
		var TotalArray=[] //定义数组，用于给table赋值
		///第一行为表名，第二行为描述，第三行为字段名，数据从第四行开始
		//模板数组，第一行，第二行，第三行
		var TableArr=[],NameArr=[],CodeArr=[];
		TableArr.push("User.BDPMenu")
		var NameStr="代码^名称^功能(功能大表里的code)^URL解析地址^菜单图标^类方法^显示顺序^菜单快捷键^弹出窗口或者增加Tab的方式^父菜单代码^父菜单描述^菜单激活状态标志^组件名称^产品线^值表达式^是否属于医用知识库"
		for (var i=0;i<NameStr.split("^").length;i++){
			var Name=NameStr.split("^")[i]
			NameArr.push(Name)
		}
		
		var CodeStr="Code^Caption^LinkFuntionDR^LinkUrl^Image^Method^Sequence^ShortcutKey^ShowInNewWindow^ParentMenuDr^ParentMenuDrCaption^ActiveFlag^CompName^ProductLineDr^ValueExpression^IsMKBMenu"
		for (var j=0;j<CodeStr.split("^").length;j++){
			var Code=CodeStr.split("^")[j]
			CodeArr.push(Code)
		}
		
		TotalArray.push(TableArr);
		TotalArray.push(NameArr);
		TotalArray.push(CodeArr);
		
		$('#prowin').show();
        var prowin = $HUI.dialog("#prowin", {
            iconCls: 'icon-w-import',
            resizable: false,
            title: '',
            modal: true
        });
        $('#pro').progressbar({
            text: "正在导出中，请稍后...",
            value: 0
        });
		var row=0,ProgressText='';
		var myVar = setInterval(function () {
		  	row++;
			if(row>taskcount) //当到达最后一行退出
		  	{
		  		$('#prowin').dialog('close')
            	clearInterval(myVar)
				var sheet = XLSX2.utils.aoa_to_sheet(TotalArray);
		        openDownloadDialog(sheet2blob(sheet,xlsName), xlsName+'.'+'xlsx');
				
		  	}
		  	else
		  	{
				progressText = "正在导出第" + row + "条记录,总共" + taskcount + "条记录!";
	            $('#pro').progressbar({
	                text: progressText,
	                value: 100 * row / taskcount
	            });
				//将每条数据加到数组里
				var DetailStr=tkMakeServerCall("web.DHCBL.BDP.BDPMenuImport","GetMenuInfo",row);
				var DetailArray=DetailStr.split("#");
			    TotalArray.push(DetailArray)
			  }
		 },20)
	}
			
	//导出功能大表和功能元素
	$('#btnExportItems').click(function(e){
    	ExportItemsToExcel()			
    });	
		
    
    //导出功能大表和功能元素到Excel
    function ExportItemsToExcel() 
    {
    	var xlsName="BDP功能大表"
    	var taskcount=tkMakeServerCall("web.DHCBL.BDP.BDPMenuImport","GetItemsCount");
		var TotalArray=[] //定义数组，用于给table赋值
		///第一行为表名，第二行为描述，第三行为字段名，数据从第四行开始
		//模板数组，第一行，第二行，第三行
		var TableArr=[],NameArr=[],CodeArr=[];
		var TableStr="User.BDPExecutables^^^^^^^^^User.BDPExecutables^^^^^^^^^^^^^^^^^^"
		for (var k=0;k<TableStr.split("^").length;k++){
			var Table=TableStr.split("^")[k]
			TableArr.push(Table)
		}
		var NameStr="代码^名称^Js路径及文件名^基础数据授权JS路径^功能描述^激活标志^包名^实体类名^显示字段^代码^名称^是否只读^是否可为空^是否隐藏^是否可编辑^提示信息^提示信息类型^类型^是否自动显示^图标^函数^XType^校验^HiddenName^Regex^RegexText^ValueGet^ValueSet"
		for (var i=0;i<NameStr.split("^").length;i++){
			var Name=NameStr.split("^")[i]
			NameArr.push(Name)
		}
		var CodeStr="Code^Caption^JavaScriptFile^BDAJavaScriptFile^Description^ActiveFlag^PackageName^ClassName^PropertyName^ItemCode^ItemName^ReadOnly^AllowBlank^Hidden^Editable^ToolTip^ToolTipType^Type^AutoShow^IconCls^Handler^XType^Validator^HiddenName^Regex^RegexText^ValueGet^ValueSet"
		for (var j=0;j<CodeStr.split("^").length;j++){
			var Code=CodeStr.split("^")[j]
			CodeArr.push(Code)
		}
		
		TotalArray.push(TableArr);
		TotalArray.push(NameArr);
		TotalArray.push(CodeArr);
		
		$('#prowin').show();
        var prowin = $HUI.dialog("#prowin", {
            iconCls: 'icon-w-import',
            resizable: false,
            title: '',
            modal: true
        });
        $('#pro').progressbar({
            text: "正在导出中，请稍后...",
            value: 0
        });
		var row=0,ProgressText='';
		var myVar = setInterval(function () {
		  	row++;
			if(row>taskcount) //当到达最后一行退出
		  	{
		  		$('#prowin').dialog('close')
            	clearInterval(myVar)
				var sheet = XLSX2.utils.aoa_to_sheet(TotalArray);
		        openDownloadDialog(sheet2blob(sheet,xlsName), xlsName+'.'+'xlsx');
				
		  	}
		  	else
		  	{
				progressText = "正在导出第" + row + "条记录,总共" + taskcount + "条记录!";
	            $('#pro').progressbar({
	                text: progressText,
	                value: 100 * row / taskcount
	            });
				//将每条数据加到数组里
				var DetailStr=tkMakeServerCall("web.DHCBL.BDP.BDPMenuImport","GetExtItemInfo",row);
				var DetailArray=DetailStr.split("#");
			    TotalArray.push(DetailArray)
			  }
		 },20)
    }
	
})
