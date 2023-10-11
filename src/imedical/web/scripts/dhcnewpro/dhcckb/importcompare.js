///****************************************
//*	Author: 		Sunhuiyong
//*	Create: 		2020/01/09
//*	Description:	对照导入界面
///****************************************
/// 页面初始化函数
var DicCode="";
var DicDesc="";
var DicRowID="";
var spac  = "^"	 /// 分隔符
var rowFlag = "[row]"	 /// 分隔符
var mDel1 = "^"  //String.fromCharCode(1);  /// 分隔符
var mDel2 = "@@"  //String.fromCharCode(2);
function initPageDefault(){
	InitLinkList();
	InitCombobox();
}
/// 初始化关联表
function InitLinkList(){
	// s title="num^itmCode^itmProName^itmGeneName^itmIngre^itmExcipient^itmForm^itmLibary^errMsg"

	var  columns=[[    
	       	{field:'AllNum',title:'文件错误行数',width:140},    
	     	{field:'msg',title:'错误信息',width:200}
	        
	    ]]
	
	///  定义datagrid
	var option = {		
		toolbar:'#toolbar',
		border:false,
	    rownumbers:true,
	    fitColumns:true,
	    singleSelect:true,
	    pagination:true,
	    pageSize:20,
	    pageList:[20,40,100],
	    fit:true,	
	    //checkbox:true,
	    onDblClickRow: function (rowIndex, rowData) {			
		
        },
	    onLoadSuccess: function (data) { //数据加载完毕事件
     
        }
	};	
	
	var uniturl = $URL+"?ClassName=web.DHCCKBIcdImport&MethodName=GetErrList";
	new ListComponent('linklist', columns, uniturl, option).Init();
}
/// 初始化LookUp
function InitCombobox(){
	// 初始化类型框
	var genType = $("#genType").lookup({
        url:$URL,
        mode:'remote',
        method:"Get",
        idField:'CDRowID',
        textField:'CDDesc',
        columns:[[
        	{field:'CDRowID',title:'CDRowID',hidden:true},
            {field:'CDCode',title:'代码',width:190},
			{field:'CDDesc',title:'描述',width:190}
        ]], 
        pagination:true,
        panelWidth:420,
        isCombo:true,
        minQueryLen:2,
        delay:'200',
        queryOnSameQueryString:false,
        queryParams:{ClassName: 'web.DHCCKBGenItem',QueryName: 'GetTypeList'},
	    onSelect:function(index, rec){
		    DicCode=rec["CDCode"];
		    DicDesc=rec["CDDesc"];
		    DicRowID=rec["CDRowID"]
		    //alert(DicCode+"  "+DicDesc+"  "+DicRowID)
		}
    });
    
    ///新增院区sufan 2020-07-15
    var uniturl = $URL+"?ClassName=web.DHCCKBCommonUtil&MethodName=QueryHospList"  
    $HUI.combobox("#HospId",{
	     url:uniturl,
	     valueField:'value',
						textField:'text',
						panelHeight:"150",
						mode:'remote',
						onSelect:function(ret){
							
						}
	   })
}
/// 导入数据
function formImp(){
	if((DicCode=="")||(DicRowID=="")){$.messager.alert('提示',"请选择导入数据类型！");return; }
	var efilepath = $("input[name=filepath]").val();
    if (efilepath.indexOf("fakepath") > 0) {$.messager.alert('提示',"请在IE下执行导入！"); return; }
    if (efilepath.indexOf(".xls") <= 0) { $.messager.alert('提示',"请选择excel表格文件！"); return; }
    var sheetcount = 1  //模板中表的个数
    var file = efilepath.split("\\");
    var filename = file[file.length - 1]; //限制选中上传文件的格式仅限两种格式的excl文件
    if ((filename.indexOf(".xlsx")<0)&&(filename.indexOf(".xls")<0)) {
	    clearFiles ()
        $.messager.alert('提示', '文件选择的不正确！');
        return;
    }
	try {
	        var oXL = new ActiveXObject("Excel.application"); //通过ActiveX方式读取excl文件
	        var oWB = oXL.Workbooks.open(efilepath);   	
	}catch (e) {
	        $.messager.alert('请在[internet选项]-[安全]-[受信任的站点]-[站点]中添加开始界面到可信任的站点，然后在[自定义级别]中对[没有标记为安全的ActiveX控件进行初始化和脚本运行]这一项设置为启用!');
	        return;
	}
    var errorRow = "";//没有插入的行
    var errorMsg = "";//错误信息
    oWB.worksheets(1).select();//默认选中的表格：sheet1
    var oSheet = oWB.ActiveSheet;
    var rowcount = oXL.Worksheets(1).UsedRange.Cells.Rows.Count;
    var colcount = oXL.Worksheets(1).UsedRange.Cells.Columns.Count;
	var ProgressText='';
	$('#pro').progressbar({
		text:"正在处理中，请稍后...",
	    value: 0
	});
	alert("开始处理！!");
	debugger;
	var ReadLine="";
		for(k =1;k<=colcount;k++){
			var cellValue = "";
			if (typeof (oSheet.Cells(1, k).value) == "undefined") {
				cellValue = ""
			}else{
				cellValue = oSheet.Cells(1, k).value
			}
			ReadLine==""?ReadLine=cellValue:ReadLine=ReadLine+"^"+cellValue;
				
		}
	var impAllData="";
    for (var j = 2; j <= rowcount; j++) {
        var rowData="";
        var row = j;
		for(k =1;k<=colcount;k++){
			var cellValue = "";
			if (typeof (oSheet.Cells(j, k).value) == "undefined") {
				cellValue = ""
			}else{
				cellValue = oSheet.Cells(j, k).value
			}
			rowData==""?rowData=ReadLine.split("^")[k-1]+"^"+cellValue:rowData=rowData+"^"+ReadLine.split("^")[k-1]+"^"+cellValue;
			
		}
		
		Flag=SaveRowData(rowData,row,rowcount)
		
		//impAllData==""?impAllData=rowData:impAllData=impAllData+"@@"+rowData;
		if (Flag=="0"){
			if(errorRow!=""){
					errorRow=errorRow+","+(row-1)
				}else{
					errorRow=(row-1)
				}
			}
			/*else{			//sufan 增加else判断
					$.messager.alert("提示","第"+rowcount+"行数据有误，错误信息为："+Flag);
					return false;
			}
			*/  //else 为1是成功不做错误提示 shy
			rowData=""
			progressText = "正在导入"+oSheet.name+"表的第"+(row-1)+"条记录,总共"+(rowcount-1)+"条记录!";  
		    if(Flag=="0")  //碰到第一条错误信息 退出并存入TMPERR 加载出错误信息
		    {
				  runClassMethod("web.DHCCKBIcdImport","SaveErr",{"errorRow":(row-1)},function(val){
				  })
			} 
			if(row==rowcount) //当到达最后一行退出
			{
			
				if(errorRow!=""){
					errorMsg=oSheet.name+"表导入完成，第"+errorRow+"行插入失败!" ;
					$("#linklist").datagrid('reload'); 			
				}else{
					errorMsg=oSheet.name+"表导入完成!"
				}
				$('#pro').progressbar('setValue', 100); 
				progressText = "正在导入"+oSheet.name+"表的记录,总共"+rowcount+"条记录!";  
				$('#pro').attr('text', progressText); 
				alert(errorMsg)
				oWB.Close(savechanges=false);
				CollectGarbage();
				oXL.Quit(); 
				oXL=null;
				oSheet=null;
    }
 
}
 	clearFiles();
}
	
 //清空文件上传的路径 
function clearFiles(){
      $('#filepath').filebox('clear');
     
} 

//优化行导入（多次交互）
function SaveRowData(rowData,row,rowcount){
		var value = $('#pro').progressbar('getValue');
			if (value < 100){
	   		 	value = ((row)/(rowcount-1))*100;
	   		 	value =parseInt(value)
	   		 	$('#pro').progressbar('setValue', value);
			}
			
	
	var ErrFlag = serverCall("web.DHCCKBImportCompare","SavedrugRowData",{"rowData":rowData,"hospDesc":LgHospDesc,"dicCode":DicCode,"dicRowID":DicRowID,"LgUserID":LgUserID,"LgHospID":LgHospID,"ClientIPAddress":ClientIPAdd})
	return 1;
}

/// 存储数据-（数据量少一次访问后台）
function Save(impAllData,rowcount){
   
	var ErrFlag = 0;

	runClassMethod("web.DHCCKBIcdImport","SaveIcd",{"impAllData":impAllData,"rowcount":rowcount},function(val){
		//var retObj = JSON.parse(val);
		//$.messager.progress('close');
		
		var retObj=val
		if (retObj.code =="success"){
			$.messager.progress('close')//数据导入完成关闭加载框
			$.messager.alert("提示:","导入成功."+"共【"+retObj.total+"条】,  成功【"+retObj.successNum+"】条.  "+"失败【"+retObj.errNum+"】条","info");
		}
		else{
			$.messager.progress('close')//数据导入完成关闭加载框
			$.messager.alert("提示:","导入失败."+"失败原因："+retObj.msg,"info");
			ErrFlag=1
		}
		$("#linklist").datagrid("reload");
	},"json")
	
	return ErrFlag;
}

///导出对照信息  sufan 2020-07-22
function formexport()
{
	if(DicCode == ""){
		$.messager.alert('提示',"请先选择要导出的类型！");
		return;
	}
	
	var excelName = "对照数据"+DicCode;
	var hosp = $HUI.combobox("#HospId").getValue();
	if(hosp == ""){
		$.messager.alert("提示","请选择院区！");
		return false;
	}
	var params = hosp+"^"+DicCode;
	var rtn = $cm({
		dataType:'text',
		ResultSetType:"Excel",
		ExcelName:excelName, //默认DHCCExcel
		ClassName:"web.DHCCKBIcdImport",
		QueryName:"QueryContraData",
		params:params
	},false);
	//web.Util.Menu SelectGroupMenu
	location.href = rtn;
}
//新添加导入 兼容谷歌
function formImpnew()
{
	debugger;
	var wb;				//读取完成的数据
	var rABS = false;	//是否将文件读取为二进制字符串
    var files = $("#filepath").filebox("files");
    if (files.length == 0){
		$.messager.alert("提示:","请选择文件后，重试！","warning");
		return;   
	} 
	var binary = "";
    var fileReader = new FileReader();
    fileReader.onload = function(ev) {
        try {
            //var data = ev.target.result;
			var bytes = new Uint8Array(ev.target.result);
			var length = bytes.byteLength;
			for(var i = 0; i < length; i++) {
				binary += String.fromCharCode(bytes[i]);
			}
			if(rABS) {
				wb = XLSX.read(btoa(fixdata(binary)), {//手动转化
					type: 'base64'
				});
			} else {
				wb = XLSX.read(binary, {
					type: 'binary'
				});
			}
    
        } catch (e) {
			$.messager.alert("提示:","文件类型不正确！","warning");
			$.messager.progress('close');
			return;
        }

		var obj = XLSX.utils.sheet_to_json(wb.Sheets[wb.SheetNames[0]]);
		if(!obj||obj==""){
			$.messager.alert("提示:","读取文件内容为空！","warning");
			$.messager.progress('close'); 
			return;
		}
		$('#pro').progressbar({
		text:"正在处理中，请稍后...",
	    value: 0
		});
		//$.messager.progress({ title:'请稍后', msg:'数据正在导入中...' });
		var Ins = function(n){
			if (n >= obj.length){			  
				//Save();
				//$.messager.progress('close');
			}else{
							
				var TmpArr = [];
				for(var m = n; m < obj.length; m++) {	
	
					// json对象转成需要格式的数组
					var mListDataArr = JsonToArr(obj[m],mDel1);
					var num=obj[m].__rowNum__+1;
					mListDataArr.push("num"+mDel1+num)
					mListDataArr = mListDataArr.join(spac)	//{"a":1,"b":2} -> a$c(1)1 [next] b$c(1)2					
					TmpArr.push(mListDataArr+mDel2);
					debugger;
					//调用程序导入
					var ResultFlag = SaveRowData(mListDataArr,m,obj.length);
					
					if(ResultFlag!="1")
					{
						$("#linklist").datagrid('reload');
						break;	
					}
					if((m+1)==obj.length)
					{
						$.messager.alert("提示","导入成功!"+"本次导入"+m+1+"条数据!");
						$("#linklist").datagrid('reload');
						break;	
					}
								
				}
		
			}
		}
		Ins(0);	//从第一行开始读		
  
   }
   fileReader.readAsArrayBuffer(files[0]);	
		
}
function JsonToArr(obj,spec){

	// 根据typeof判断对象也不太准确
	/*
	表达式	                      返回值
	typeof undefined	       'undefined'
	typeof null	               'object'
	typeof true	               'boolean'
	typeof 123	               'number'
	typeof "abc"	           'string'
	typeof function() {}	   'function'
	typeof {}	               'object'
	typeof []	               'object'
	*/
	
	var val=(Object.prototype.toString.call(obj) === '[Object Object]')?0:1;
	val=(JSON.stringify(obj) == "{}")?1:0;
	
	if (val){
		return "";
	}
	var strArr = [];
	for (k in obj){
		var tmpStr = k + spec + obj[k];		// {"test":"1"}-> test$c(1)1
		strArr.push(tmpStr);
	}
	
	return strArr;
	
}

/// JQuery 初始化页面
$(function(){ initPageDefault(); })
