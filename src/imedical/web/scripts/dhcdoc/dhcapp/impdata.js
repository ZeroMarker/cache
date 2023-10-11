
//===========================================================================================
// 作者：      bianshuai
// 编写日期:   2017-07-13
// 描述:	   检查申请导入程序
//===========================================================================================

var pid = "1";
/// 页面初始化函数
function initPageDefault(){
	initBlButton();       ///  页面Button绑定事件
}

/// 页面 Button 绑定事件
function initBlButton(){
	$("#ImpTrePath").filebox({
		onChange: function(newVal, oldVal) {
			var file = $(this).filebox("files")[0];
			//readWorkbookFromLocal(file, showWorkbook)
		}, onClickButton: function() {
			$(this).filebox("clear")
		}
	})
	///  检查分类树导入
	//$('#ImpTree').bind("click",ImpTreeTimeOut);
	$('#ImpTree').click(function() {
		var files = $("#ImpTrePath").filebox("files")
		if (files.length == 0) {
			$.messager.alert("提示", "请选择 Excel 文件!", 'info')
			return false
		}
		readWorkbookFromLocal(files[0], ImpTree)
	})
	///  检查分类对应医嘱项和部位导入
	$("#ImpArcPath").filebox({
		onChange: function(newVal, oldVal) {
			var file = $(this).filebox("files")[0];
			//readWorkbookFromLocal(file, showWorkbook)
		}, onClickButton: function() {
			$(this).filebox("clear")
		}
	})
	//$('#ImpArc').bind("click",ImpArcTimeOut);
	$('#ImpArc').click(function() {
		var files = $("#ImpArcPath").filebox("files")
		if (files.length == 0) {
			$.messager.alert("提示", "请选择 Excel 文件!", 'info')
			return false
		}
		readWorkbookFromLocal(files[0], ImpArc)
	})
	///  检查部位导入
	/// $('#ImpPart').bind("click",ImpPartTimeOut);
	$("#ImpPartPath").filebox({
		onChange: function(newVal, oldVal) {
			var file = $(this).filebox("files")[0];
			//readWorkbookFromLocal(file, showWorkbook)
		}, onClickButton: function() {
			$(this).filebox("clear")
		}
	})
	//$('#ImpPart').bind("click",ImportDataPart);   ///add by sufan 2018-12-15
	$('#ImpPart').click(function() {
		var files = $("#ImpPartPath").filebox("files")
		if (files.length == 0) {
			$.messager.alert("提示", "请选择 Excel 文件!", 'info')
			return false
		}
		readWorkbookFromLocal(files[0], ImpPartTree)
	})	
	///  检查分类树模板导出
	$('#ExpTreeTemp').bind("click",ExpTreeTemp);
	
	///  检查分类对应医嘱项和部位模板导出
	$('#ExpArcTemp').bind("click",ExpArcTemp);
	
	///  检查部位模板导出
	$('#ExpPartTemp').bind("click",ExpPartTemp);
	
	/// 检查分类树导出
	$('#ExpTree').bind("click",ExpAPPTree);
	
}

///  检查分类对应医嘱项和部位导入
function ImpTreeTimeOut(){
	
    $.messager.progress({ title:'请稍后', msg:'数据正在导入中...' });
	setTimeout(function(){ ImpTree()},1000)
}
function readWorkbookFromLocal(file, callBackFun) {
	var reader = new FileReader()
	if (reader.readAsBinaryString) {
		reader.readAsBinaryString(file)
		reader.onload = function(e) {
			const data = e.target.result
			var workbook = XLSX.read(data, { type: 'binary' })
            callBackFun(workbook)
		}
	} else {
		reader.readAsArrayBuffer(file)
		reader.onload = function(e) {
			const data = e.target.result
			var workbook = XLSX.read(data, { type: 'array' })
			callBackFun(workbook)
		}
	}
}
///  检查分类树导入
function ImpTree(workbook){
	$.messager.progress({
		title: "提示",
		msg: '正在导入数据',
		text: '导入中....'
	})
	var checkBlankLine = "";
	var blackLines = [];
	for (var i=0; i< 100; i++) {
		checkBlankLine += "^"
	}
	var sheetNames = workbook.SheetNames
	var worksheet = workbook.Sheets[sheetNames[0]]
	var csv = XLSX.utils.sheet_to_csv(worksheet)
	
	var excelRows = []
	var excelRow = ""
	var success = 0
	var rows = csv.split("\n")
	rows.pop()
	rows.forEach(function(row, index) {
		var cols = row.split(",")
		if (index == 0) {
		} else {
			excelRow = cols.join("^")
			if (checkBlankLine.indexOf(excelRow) > -1) {
				blackLines.push(index);
			}
			var resVal = InsTmpGlobal(excelRow);
			if (resVal == -2){
				$.messager.alert('提示',"第"+ row +"行内容，医院信息异常");
			}else if (resVal == -3){
				$.messager.alert('提示',"第"+ row +"行内容，代码重复，请核实");
			}else if (resVal < 0){
				$.messager.alert('提示',"第"+ row +"行内容，数据错误，请核实");
			}
			if (resVal != 0){
				success = -1;
				//break;
			}
			excelRows.push(excelRow)
		}
	})
	if (blackLines.length > 0 ) {
		$.messager.alert('提示', "有" + blackLines.length + "空行，请先处理Excel空行！", "info")
		$.messager.progress("close");
		return false;
	}
	if (success == "-1"){
		killTmpGlobal();  /// 清除临时global
		/// 关闭加载框
		$.messager.progress('close'); 
		return;
	}
	InsTreeData(pid);
	$.messager.progress("close");
	
	/*var efilepath = $("input[name=catuploadfile]").val();
    if (efilepath.indexOf("fakepath") > 0){
	   $.messager.alert('提示',"请在IE下执行导入！");
	   $.messager.progress('close'); 
	   return;
	}
    if ((efilepath.indexOf(".xls") == "-1")&(efilepath.indexOf(".xlsx") == "-1")) {
	   $.messager.alert('提示',"请选择excel表格文件！");
	   $.messager.progress('close'); 
	   return;
	}

	try {
		var oXL = new ActiveXObject("Excel.application");
		var oWB = oXL.Workbooks.open(efilepath);
	}catch (e) {
		$.messager.alert('请在[internet选项]-[安全]-[受信任的站点]-[站点]中添加开始界面到可信任的站点，然后在[自定义级别]中对[没有标记为安全的ActiveX控件进行初始化和脚本运行]这一项设置为启用!');
		$.messager.progress('close'); 
		return;
	}

    var errorRow = "";//没有插入的行
    var errorMsg = "";//错误信息
    oWB.worksheets(1).select();
    var oSheet = oWB.ActiveSheet;
    var rowcount = oXL.Worksheets(1).UsedRange.Cells.Rows.Count;
    var colcount = 6; //oXL.Worksheets(1).UsedRange.Cells.Columns.Count;

	var success = 0;
	/// 检查数据
	for(var i=2; i <= rowcount; i++){
		
		//$("#messager-p-msg").text("正在导入第" + (i - 1) + "条数据...")
		/// 医院内容为空,退出继续下一条
		if (typeof (oSheet.Cells(i, 1).value) == "") break;
		var mListArr = [];
		for(var j=1; j <= colcount; j++){
	        var cellValue = ""
            if (typeof (oSheet.Cells(i, j).value) != "undefined") {
                cellValue = oSheet.Cells(i, j).value
            }
            mListArr.push(cellValue);
		}
		
		var resVal = InsTmpGlobal(mListArr.join("^"));
		if (resVal == -2){
			$.messager.alert('提示',"第"+ i +"行内容，医院信息异常");
		}else if (resVal == -3){
			$.messager.alert('提示',"第"+ i +"行内容，代码重复，请核实");
		}else if (resVal < 0){
			$.messager.alert('提示',"第"+ i +"行内容，数据错误，请核实");
		}
		
		if (resVal != 0){
			success = -1;
			break;
		}
	}
	
	if (success == "-1"){
		/// 关闭工作簿
		oWB.Close(savechanges = false);
		oXL.Quit();
		oXL = null;
		oSheet = null;
		killTmpGlobal();  /// 清除临时global
		/// 关闭加载框
		$.messager.progress('close'); 
		return;
	}
	
	/// 导入数据
	InsTreeData(pid);
	
	/// 关闭工作簿
	oWB.Close(savechanges = false);
	oXL.Quit();
	oXL = null;
	oSheet = null;
            
	/// 关闭加载框
	$.messager.progress('close'); */
	
}

/// 临时存储其他项目
function InsTmpGlobal(mListData){

	var ErrFlag = 0;
	runClassMethod("web.DHCEMImpTools","InsTmpGlobal",{"pid":pid, "mListData":mListData},function(val){
		ErrFlag = val;
	},'',false)

	return ErrFlag;
}

/// 临时存储其他项目
function InsTreeData(pid){

	runClassMethod("web.DHCEMImpTools","InsTreeData",{"pid":pid},function(val){
		if (val != 0){
			$.messager.alert('提示',val);
		}else{
			$.messager.alert('提示','导入成功！');
		}
	},'',false)

}

///  检查分类对应医嘱项和部位导入
function ImpArcTimeOut(){
	
    $.messager.progress({ title:'请稍后', msg:'数据正在导入中...' });
	setTimeout(function(){ ImpArc() },1000)
}
///  检查分类对应医嘱项和部位导入
function ImpArc(workbook){
	$.messager.progress({
		title: "提示",
		msg: '正在导入数据',
		text: '导入中....'
	})
	var checkBlankLine = "";
	var blackLines = [];
	for (var i=0; i< 100; i++) {
		checkBlankLine += "^"
	}
	var sheetNames = workbook.SheetNames
	var worksheet = workbook.Sheets[sheetNames[0]]
	var csv = XLSX.utils.sheet_to_csv(worksheet)
	
	var excelRows = []
	var excelRow = ""
	var rows = csv.split("\n")
	var success=0
	rows.pop()
	rows.forEach(function(row, index) {
		var cols = row.split(",")
		if (index == 0) {
		} else {
			excelRow = cols.join("^")
			if (checkBlankLine.indexOf(excelRow) > -1) {
				blackLines.push(index);
			}
			var resVal = InsTmpArcGlobal(excelRow);
			if (resVal == "-1"){
				$.messager.alert('提示',"第"+ row +"行内容，分类名称不存在");
			}else if ((resVal == "-2")||(resVal == "-3")){
				$.messager.alert('提示',"第"+ row +"行内容，检查项目不存在");
			}else if (resVal == "-4"){
				$.messager.alert('提示',"第"+ row +"行内容，检查项目不能对照一级部位");
			}else if (resVal == "-5"){
				$.messager.alert('提示',"第"+ row +"行内容，医院不能维护");
			}else if (resVal == "-6"){
				$.messager.alert('提示',"第"+ row +"行内容，检查项目不能和医院对应");
			}
			
			if (resVal != 0){
				success = -1;
				//break;
			}
			excelRows.push(excelRow)
		}
	})
	if (blackLines.length > 0 ) {
		$.messager.alert('提示', "有" + blackLines.length + "空行，请先处理Excel空行！", "info")
		$.messager.progress("close");
		return false;
	}
	if (success == "-1"){
		killTmpGlobal();  /// 清除临时global
		/// 关闭加载框
		$.messager.progress('close'); 
		return;
	}
	InsTreeArcData(pid);
	$.messager.progress("close");
	
	/*
	var efilepath = $("input[name=arcuploadfile]").val();
    if (efilepath.indexOf("fakepath") > 0){
	   $.messager.alert('提示',"请在IE下执行导入！");
	   $.messager.progress('close'); 
	   return;
	}
	
    if ((efilepath.indexOf(".xls") == "-1")&(efilepath.indexOf(".xlsx") == "-1")) {
	   $.messager.alert('提示',"请选择excel表格文件！");
	   $.messager.progress('close'); 
	   return;
	}

	try {
		var oXL = new ActiveXObject("Excel.application");
		var oWB = oXL.Workbooks.open(efilepath);
	}catch (e) {
		$.messager.alert('请在[internet选项]-[安全]-[受信任的站点]-[站点]中添加开始界面到可信任的站点，然后在[自定义级别]中对[没有标记为安全的ActiveX控件进行初始化和脚本运行]这一项设置为启用!');
		$.messager.progress('close'); 
		return;
	}

    var errorRow = "";//没有插入的行
    var errorMsg = "";//错误信息
    oWB.worksheets(1).select();
    var oSheet = oWB.ActiveSheet;
    var rowcount = oXL.Worksheets(1).UsedRange.Cells.Rows.Count;
    var colcount = 5;  //oXL.Worksheets(1).UsedRange.Cells.Columns.Count;
	
	var success = 0;
	/// 检查数据
	for(var i=2; i <= rowcount; i++){
		
		/// 项目内容为空,退出继续下一条
		if (typeof (oSheet.Cells(i, 1).value) == "") break;
		var mListArr = [];
		for(var j=1; j <= colcount; j++){
	        var cellValue = ""
            if (typeof (oSheet.Cells(i, j).value) != "undefined") {
                cellValue = oSheet.Cells(i, j).value
            }
            mListArr.push(cellValue);
		}

		var resVal = InsTmpArcGlobal(mListArr.join("^"));
		if (resVal == "-1"){
			$.messager.alert('提示',"第"+ (i-1) +"行内容，分类名称不存在");
		}else if ((resVal == "-2")||(resVal == "-3")){
			$.messager.alert('提示',"第"+ (i-1) +"行内容，检查项目不存在");
		}else if (resVal == "-4"){
			$.messager.alert('提示',"第"+ (i-1) +"行内容，检查项目不能对照一级部位");
		}else if (resVal == "-5"){
			$.messager.alert('提示',"第"+ (i-1) +"行内容，医院不能维护");
		}else if (resVal == "-6"){
			$.messager.alert('提示',"第"+ (i-1) +"行内容，检查项目不能和医院对应");
		}
		
		if (resVal != 0){
			success = -1;
			break;
		}
	}

	if (success == "-1"){
		/// 关闭工作簿
		oWB.Close(savechanges = false);
		oXL.Quit();
		oXL = null;
		oSheet = null;
		killTmpGlobal();  /// 清除临时global
		/// 关闭加载框
		$.messager.progress('close'); 
		return;
	}
	
	/// 导入数据
	InsTreeArcData(pid);
	
	/// 关闭工作簿
	oWB.Close(savechanges = false);
	oXL.Quit();
	oXL = null;
	oSheet = null;
            
	/// 关闭加载框
	$.messager.progress('close'); 
	*/
}

/// 临时存储导入数据
function InsTmpArcGlobal(mListData){

	var ErrFlag = 0;
	var HospID = session['LOGON.HOSPID']
	runClassMethod("web.DHCEMImpTools","InsTmpArcGlobal",{"pid":pid, "mListData":mListData,"HospID":HospID},function(val){
		ErrFlag = val;
	},'',false)

	return ErrFlag;
}

/// 临时存储其他项目
function InsTreeArcData(pid){

	runClassMethod("web.DHCEMImpTools","InsTreeArcData",{"pid":pid},function(val){
		if (val != 0){
			$.messager.alert('提示',val);
		}else{
			$.messager.alert('提示','导入成功！');
		}
	},'',false)

}

//清空文件上传的路径 
function clearFiles(FilePath){
	var file = $("#"+ FilePath);
	file.after(file.clone().val(""));      
	file.remove();
}

/// 导出检查分类树模板
function ExpTreeTemp(){
	$cm({
		ResultSetType: "ExcelPlugin",  		// 表示通过DLL生成Excel，可支持IE与Chrome系。Chrome系浏览器请安装中间件
		// ResultSetTypeDo:"Print",    		// 默认Export，可以设置为：PRINT , PREVIEW
		localDir: "Self",	      			// D:\\tmp\\表示固定文件路径, "Self"表示用户导出时选择保存路径，默认保存到桌面
		ExcelName: "检查分类树模板",
		PageName: "web.DHCEMImpTools:FindAPPTreeTemp",	
		ClassName: "web.DHCEMImpTools",
		QueryName: "FindAPPTreeTemp",
	    rows:10
	},function(data){
		$.messager.popover({
			msg: '模板下载成功，请留意任务栏！',
			type: 'success',
			timeout: 2000,
			showType: 'slide'
		})
	})
	/*
	//1、保存路径
	var filePath=browseFolder();
	if (typeof filePath=="undefined"){
		$.messager.alert("提示:","请选择路径后,重试！","error");
		return;
	}
	
	//2、获取XLS打印路径
	var path=tkMakeServerCall("web.DHCDocConfig","GetPath");
	var Template = path+"DHCAPP_TreeTemp.xlsx";
	var xlApp = new ActiveXObject("Excel.Application");
	var xlBook = xlApp.Workbooks.Add(Template);
	var objSheet = xlBook.ActiveSheet;

	//3、页面直接打开
	//xlApp.Visible = true;
	//xlApp=null;
	//objSheet=null;
	
	xlBook.SaveAs(filePath+"DHCAPP_TreeTemp.xlsx");
	xlApp=null;
	xlBook.Close(savechanges=false);
	objSheet=null;*/
	
}

/// 导出检查分类对应医嘱项和部位模板
function ExpArcTemp(){
	$cm({
		ResultSetType: "ExcelPlugin",  		// 表示通过DLL生成Excel，可支持IE与Chrome系。Chrome系浏览器请安装中间件
		// ResultSetTypeDo:"Print",    		// 默认Export，可以设置为：PRINT , PREVIEW
		localDir: "Self",	      			// D:\\tmp\\表示固定文件路径, "Self"表示用户导出时选择保存路径，默认保存到桌面
		ExcelName: "检查医嘱项和部位模板",
		PageName: "web.DHCEMImpTools:FindArcTemp",	
		ClassName: "web.DHCEMImpTools",
		QueryName: "FindArcTemp",
	    rows:10
	},function(data){
		$.messager.popover({
			msg: '模板下载成功，请留意任务栏！',
			type: 'success',
			timeout: 2000,
			showType: 'slide'
		})
	})
	/*
	//1、保存路径
	var filePath=browseFolder();
	if (typeof filePath=="undefined"){
		$.messager.alert("提示:","请选择路径后,重试！","error");
		return;
	}
	
	//2、获取XLS打印路径
	var path=tkMakeServerCall("web.DHCDocConfig","GetPath");
	var Template = path+"DHCAPP_ArcTemp.xlsx";
	var xlApp = new ActiveXObject("Excel.Application");
	var xlBook = xlApp.Workbooks.Add(Template);
	var objSheet = xlBook.ActiveSheet;
	
	//3、页面直接打开
	//xlApp.Visible = true;
	//xlApp=null;
	//objSheet=null;
	
	xlBook.SaveAs(filePath+"DHCAPP_ArcTemp.xlsx");
	xlApp=null;
	xlBook.Close(savechanges=false);
	objSheet=null;*/
}

///  检查分类对应医嘱项和部位导入 
function ImpPartTimeOut(){
	
    $.messager.progress({ title:'请稍后', msg:'数据正在导入中...' });
	setTimeout(function(){ ImpPart() },1000)
}

///  检查分类对应医嘱项和部位导入
function ImpPart(){
	
	var efilepath = $("input[name=partuploadfile]").val();
    //alert(efilepath)
    if (efilepath.indexOf("fakepath") > 0) 
	{
		alert("请在IE下执行导入！"); 
		$.messager.progress('close');    ///sufan add 2017-12-10
		return; 
	}
    if (efilepath.indexOf(".xls") <= 0) 
	{ 
		alert("请选择excel表格文件！"); 
		$.messager.progress('close');    ///sufan add 2017-12-10
		return; 
	}
    //var kbclassname = ""  //类名
    var sheetcount = 1  //模板中表的个数
	/*
    var file = efilepath.split("\\");
    var filename = file[file.length - 1];
    if ((filename != "DHCAPP_PartTemp.xlsx")&&(filename != "DHCAPP_PartTemp.xls")) {
	    clearFiles ("ImpPartPath")
        $.messager.alert('提示', '文件选择的不正确！');
		$.messager.progress('close');    ///sufan add 2017-12-10
        return;
    }
	*/

  try {
        var oXL = new ActiveXObject("Excel.application");
        var oWB = oXL.Workbooks.open(efilepath);   //xlBook = xlApp.Workbooks.add(ImportFile);		
  }catch (e) {
        $.messager.alert('请在[internet选项]-[安全]-[受信任的站点]-[站点]中添加开始界面到可信任的站点，然后在[自定义级别]中对[没有标记为安全的ActiveX控件进行初始化和脚本运行]这一项设置为启用!');
		$.messager.progress('close');    ///sufan add 2017-12-10
        return;
  }

    var sheet_id = 1
    var errorRow = "";//没有插入的行
    var errorMsg = "";//错误信息
    oWB.worksheets(sheet_id).select();
    var oSheet = oWB.ActiveSheet;
    var rowcount = oXL.Worksheets(sheet_id).UsedRange.Cells.Rows.Count;
    var colcount = 5;  /// oXL.Worksheets(sheet_id).UsedRange.Cells.Columns.Count;
    
    $.messager.progress({   //数据导入提示
		title:'请稍后', 
		msg:'数据正在导入中...' 
	}); 
    
    var inserToDB = function (i) { 
        if (i == rowcount+1) {
            //if (errorRow != "") {
               // errorMsg = oSheet.name + "表导入完成，第" + errorRow + "行插入失败!";
            //} else {
	            clearFiles ("ImpPartPath")
                errorMsg = oSheet.name + "表导入完成!"
                $.messager.progress('close')//数据导入完成关闭加载框
           // }
            //alert(errorMsg)

            oWB.Close(savechanges = false);
            //CollectGarbage();
            oXL.Quit();
            oXL = null;
            oSheet = null;
        }else {
			var tempStr = ""; //每行数据（第一列[next]第二列[next]...）
			var row=i
            for (var j = 1; j <= colcount; j++) {
                var cellValue = ""
                if (typeof (oSheet.Cells(i, j).value) == "undefined") {
                    cellValue = ""
                } else {
                    cellValue = oSheet.Cells(i, j).value
                }

                tempStr += (cellValue + "[next]")
               
            }
              runClassMethod(
                    "web.DHCEMImpTools",
                    "SaveData",
                    { "dataStr": tempStr, "sheetid": sheet_id, "row": row, "HospID": LgHospID},
                    function (Flag) {
                             //alert(Flag)
                        if (Flag == true) {  
                            errorRow = errorRow             

                        } else {
                            if (errorRow != "") {
                                errorRow = errorRow + "," + i
                            } else {
                                errorRow = i
                            }
                            
                        }
                           i=i+1;
                           inserToDB(i);    
         
                });

        }
       
    } 
    inserToDB(1);
  
}

/// 导出检查分类对应医嘱项和部位模板
function ExpPartTemp(){
	$cm({
		ResultSetType: "ExcelPlugin",  		// 表示通过DLL生成Excel，可支持IE与Chrome系。Chrome系浏览器请安装中间件
		// ResultSetTypeDo:"Print",    		// 默认Export，可以设置为：PRINT , PREVIEW
		localDir: "Self",	      			// D:\\tmp\\表示固定文件路径, "Self"表示用户导出时选择保存路径，默认保存到桌面
		ExcelName: "检查部位模板",
		PageName: "web.DHCEMImpTools:FindPartTemp",	
		ClassName: "web.DHCEMImpTools",
		QueryName: "FindPartTemp",
	    rows:9999
	},function(data){
		$.messager.popover({
			msg: '模板下载成功，请留意任务栏！',
			type: 'success',
			timeout: 2000,
			showType: 'slide'
		})
	})
	/*
	//1、保存路径
	var filePath=browseFolder();
	if (typeof filePath=="undefined"){
		$.messager.alert("提示:","请选择路径后,重试！","error");
		return;
	}
	
	//2、获取XLS打印路径
	var path=tkMakeServerCall("web.DHCDocConfig","GetPath");
	var Template = path+"DHCAPP_PartTemp.xlsx";
	var xlApp = new ActiveXObject("Excel.Application");
	var xlBook = xlApp.Workbooks.Add(Template);
	var objSheet = xlBook.ActiveSheet;
	
	//3、页面直接打开
	//xlApp.Visible = true;
	//xlApp=null;
	//objSheet=null;
	
	xlBook.SaveAs(filePath+"DHCAPP_PartTemp.xlsx");
	xlApp=null;
	xlBook.Close(savechanges=false);
	objSheet=null;
	*/
}

/// 弹出路径选择框
function browseFolder(){
	  
  try {  
	  var Message = "请选择路径"; //选择框提示信息  
	  var Shell = new ActiveXObject("Shell.Application");  
	  var Folder = Shell.BrowseForFolder(0, Message, 0X0040, 0X11);//起始目录为：我的电脑  
	  if (Folder != null) 
	  {  
		  Folder = Folder.items(); // 返回 FolderItems 对象  
		  Folder = Folder.item();  // 返回 Folderitem 对象  
		  Folder = Folder.Path;    // 返回路径  
		  if (Folder.charAt(Folder.length - 1) != "\\"){  
			  Folder = Folder + "\\";  
		  }    
		  return Folder;  
	  }  
  }catch(e){  
	  alert(e.message);  
  }  
}


// 导入部位中的数据  add by sufan 2018-12-15
function ImportDataPart() {
   $.messager.progress({ title:'请稍后', msg:'数据正在导入中...' });
   setTimeout(function(){ ImpPartTree()},1000)
  
}
function ImpPartTree(workbook)
{
	$.messager.progress({
		title: "提示",
		msg: '正在导入数据',
		text: '导入中....'
	})
	var checkBlankLine = "";
	var blackLines = [];
	for (var i=0; i< 100; i++) {
		checkBlankLine += "^"
	}
	var sheetNames = workbook.SheetNames
	var worksheet = workbook.Sheets[sheetNames[0]]
	var csv = XLSX.utils.sheet_to_csv(worksheet)
	
	var excelRows = []
	var excelRow = ""
	var rows = csv.split("\n")
	var success=0
	rows.pop()
	rows.forEach(function(row, index) {
		var cols = row.split(",")
		if (index == 0) {
		} else {
			excelRow = cols.join("^")
			if (checkBlankLine.indexOf(excelRow) > -1) {
				blackLines.push(index);
			}
			var resVal = InsPartTmpGlobal(excelRow);
			if (resVal == "-1"){
				$.messager.alert('提示',"第"+ i +"行内容，代码重复，请核实");
			}else if (resVal == "-2"){
				$.messager.alert('提示',"第"+ i +"行内容，代码重复，请核实");
			}else if (resVal == "-5"){
				$.messager.alert('提示',"第"+ i +"行内容，代码为空，请核实");
			}
			
			if (resVal != 0){
				success = -1;
				//break;
			}
			excelRows.push(excelRow)
		}
	})
	if (blackLines.length > 0 ) {
		$.messager.alert('提示', "有" + blackLines.length + "空行，请先处理Excel空行！", "info")
		$.messager.progress("close");
		return false;
	}
	if (success == "-1"){
		killTmpGlobal();  /// 清除临时global
		/// 关闭加载框
		$.messager.progress('close'); 
		return;
	}
	InsPartData(pid)
	$.messager.progress("close");
	
	
	//var efilepath = $("#filepath").val();
	/*
	var efilepath = $("input[name=partuploadfile]").val();
    if (efilepath.indexOf("fakepath") > 0){
	   $.messager.alert('提示',"请在IE下执行导入！");
	   $.messager.progress('close'); 
	   return;
	}

    if ((efilepath.indexOf(".xls") == "-1")&(efilepath.indexOf(".xlsx") == "-1")) {
	   $.messager.alert('提示',"请选择excel表格文件！");
	   $.messager.progress('close'); 
	   return;
	}

	try {
		var oXL = new ActiveXObject("Excel.application");
		var oWB = oXL.Workbooks.open(efilepath);
	}catch (e) {
		$.messager.alert('请在[internet选项]-[安全]-[受信任的站点]-[站点]中添加开始界面到可信任的站点，然后在[自定义级别]中对[没有标记为安全的ActiveX控件进行初始化和脚本运行]这一项设置为启用!');
		$.messager.progress('close'); 
		return;
	}

    var errorRow = "";//没有插入的行
    var errorMsg = "";//错误信息
    oWB.worksheets(1).select();
    var oSheet = oWB.ActiveSheet;
    var rowcount = oXL.Worksheets(1).UsedRange.Cells.Rows.Count;
    var colcount = oXL.Worksheets(1).UsedRange.Cells.Columns.Count;

	var success = 0;
	/// 检查数据
	for(var i=2; i <= rowcount; i++){
		var mListArr = [];
		for(var j=1; j <= colcount; j++){
	        var cellValue = ""
            if (typeof (oSheet.Cells(i, j).value) != "undefined") {
                cellValue = oSheet.Cells(i, j).value
            }
            if(cellValue=="") break;
            mListArr.push(cellValue);
		}
		
		var resVal = InsPartTmpGlobal(mListArr.join("^"));
		if (resVal == "-1"){
			$.messager.alert('提示',"第"+ i +"行内容，代码重复，请核实");
		}else if (resVal == "-2"){
			$.messager.alert('提示',"第"+ i +"行内容，代码重复，请核实");
		}else if (resVal == "-5"){
			$.messager.alert('提示',"第"+ i +"行内容，代码为空，请核实");
		}
		
		if (resVal != 0){
			success = -1;
			break;
		}
	}
	
	if (success == "-1"){
		/// 关闭工作簿
		oWB.Close(savechanges = false);
		oXL.Quit();
		oXL = null;
		oSheet = null;
		killTmpGlobal();  /// 清除临时global
		/// 关闭加载框
		$.messager.progress('close'); 
		return;
	}
	
	/// 导入数据
	InsPartData(pid)
	/// 关闭工作簿
	oWB.Close(savechanges = false);
	oXL.Quit();
	oXL = null;
	oSheet = null;
            
	/// 关闭加载框
	$.messager.progress('close'); */
}
/// 部位数据存储
function InsPartTmpGlobal(mListData){
	//alert(mListData)
	var ErrFlag = 0;
	runClassMethod("web.DHCEMImpTools","InsPartTmpGlobal",{"pid":pid, "mListData":mListData},function(val){
	//alert(val+"sufan")
		ErrFlag = val;
	},'text',false)

	return ErrFlag;
}
/// 导入
function InsPartData(pid){
	
	runClassMethod("web.DHCEMImpTools","InsPartData",{"pid":pid},function(val){
		//alert(val+"daoru")
		if (val != 0){
			$.messager.alert('提示',val);
		}else{
			$.messager.alert('提示','导入成功！');
		}
	},'text',false)

}
/// 删除临时global
function killTmpGlobal(){

	runClassMethod("web.DHCEMImpTools","killTmpGlobal",{"pid":pid},function(jsonString){
	},'',false)
}

/// 页面关闭之前调用
function onbeforeunload_handler() {
    killTmpGlobal();  /// 清除临时global
}
function ExpAPPTree(){
	$cm({
		ResultSetType: "ExcelPlugin",  		// 表示通过DLL生成Excel，可支持IE与Chrome系。Chrome系浏览器请安装中间件
		// ResultSetTypeDo:"Print",    		// 默认Export，可以设置为：PRINT , PREVIEW
		localDir: "Self",	      			// D:\\tmp\\表示固定文件路径, "Self"表示用户导出时选择保存路径，默认保存到桌面
		ExcelName: "检查树导出",
		PageName: "web.DHCEMImpTools:FindAPPTree",	
		ClassName: "web.DHCEMImpTools",
		QueryName: "FindAPPTree",
		HospID:session['LOGON.HOSPID'],
	    rows:9999
	},function(data){
		$.messager.popover({
			msg: '模板下载成功，请留意任务栏！',
			type: 'success',
			timeout: 2000,
			showType: 'slide'
		})
	})
}
/// JQuery 初始化页面
$(function(){ initPageDefault(); })
