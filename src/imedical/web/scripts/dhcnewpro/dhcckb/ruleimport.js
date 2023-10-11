/**
*	Author: 		Qunianpeng
*	Create: 		2019/07/04
*	Description:	规则导入
*/
//var mDel1 = String.fromCharCode(1);  /// 分隔符
//var mDel2 = String.fromCharCode(2);  /// 分隔符
var spac  = "[next]"	 /// 分隔符
var rowFlag = "[row]"	 /// 分隔符
var mDel1 = String.fromCharCode(1);  /// 分隔符
var pid="";
var mDel2=String.fromCharCode(2);
/// 页面初始化函数
function initPageDefault(){

	InitButton();			/// 初始化按钮绑定事件
	InitDrugListGrid();		/// 初始化药品列表
	
}


/// 初始化按钮绑定事件
function InitButton(){

	/// 编码，商品名回车	
	//$('#queryCode,#queryDesc').bind('keypress',InputPrese);
	//$('#queryDesc').bind('keypress',InputPrese);
}

/// 初始化药品列表
function InitDrugListGrid(){
	// s title="num^itmCode^itmProName^itmGeneName^itmIngre^itmExcipient^itmForm^itmLibary^errMsg"

	var  columns=[[    
	       	{field:'num',title:'序号',width:80},    
	     	{field:'itmCode',title:'编码',width:140},
	        {field:'itmGeneName',title:'通用名称(含剂型)',width:180},
	        {field:'itmProName',title:'商品名',width:180},
	        {field:'itmIngre',title:'成分',width:180},
	        {field:'itmExcipient',title:'辅料',width:180},
	        {field:'itmForm',title:'剂型',width:120},
	        {field:'itmLibary',title:'关系',width:100},
	       	{field:'errMsg',title:'备注',width:160}
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
	    nowrap:false,
	    pageList:[20,40,100],
		//showHeader:false,		
		rownumbers : false,
		singleSelect : true,
	    fit:true,	
	    checkbox:true,
	    onDblClickRow: function (rowIndex, rowData) {			
		
        },
	    onLoadSuccess: function (data) { //数据加载完毕事件
          
        }
	};	
	
	var uniturl = $URL+"?ClassName=web.DHCCKBExport&MethodName=QueryDrugList&params="+pid;
	new ListComponent('druglist', columns, uniturl, option).Init();
}


/// 导入数据
function UploadData(){
	
  var wb;				//读取完成的数据
	var rABS = false;	//是否将文件读取为二进制字符串
    //var files = $("#articleImageFile")[0].files;
    var files = $("#filepath").filebox("files");
    if (files.length == 0){
		$.messager.alert("提示:","请选择文件后，重试！","warning");
		return;   
	}
	
	//$.messager.progress({ title:'请稍后', msg:'数据正在导入中...' });
	pid=(new Date()).valueOf(); //serverCall("web.DHCCKBMatchSearch","MatchDataPid");  

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
                //persons = []; // 存储获取到的数据
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
		$.messager.progress({ title:'请稍后', msg:'数据正在导入中...' });
		var Ins = function(n){
			if (n >= obj.length){			  
				Save();
				$.messager.progress('close');
			}else{
							
				var TmpArr = [];
				for(var m = n; m < obj.length; m++) {
					
					// json对象转成需要格式的数组
					var mListDataArr = JsonToArr(obj[m],mDel1);
					var num=obj[m].__rowNum__+1;
					mListDataArr.push("num"+mDel1+num)
					mListDataArr = mListDataArr.join(spac)	//{"a":1,"b":2} -> a$c(1)1 [next] b$c(1)2					
					TmpArr.push(mListDataArr+mDel2);
	
					if ((m != 0)&(m%100 == 0)){	// 后台的流拼串还有问题,暂时读2行传一次(带修复后可读100行)
					//if (m%2 == 0){	
						/// 临时存储数据
						InsTmpGlobal(TmpArr.join(rowFlag), Ins, m+1,pid);
						TmpArr.length=0;
						break;
					}				
				}
				var testString=TmpArr.join(rowFlag);
				if (testString != ""){
					/// 临时存储数据
					InsTmpGlobal(testString, Ins, m,pid);
				}
			}
		}
		Ins(0);	//从第一行开始读		
  
   }
  
   fileReader.readAsArrayBuffer(files[0]);
}

//文件流转BinaryString
function fixdata(data) { 
	var o = "",
		l = 0,
		w = 10240;
	for (; l < data.byteLength / w; ++l) o += String.fromCharCode.apply(null, new Uint8Array(data.slice(l * w, l * w + w)));
	o += String.fromCharCode.apply(null, new Uint8Array(data.slice(l * w)));
	return o;
}

/// 临时存储数据
function InsTmpGlobal(mListData, Fn, m,pid){

	var ErrFlag = 0;
	runClassMethod("web.DHCCKBRuleImport","TmpImportData",{"pid":pid, "mListData":mListData},function(val){
		Fn(m);
	})
	
	return ErrFlag;
}

/// 存储数据
function Save(){

	var ErrFlag = 0;

	runClassMethod("web.DHCCKBRuleImport","SaveRule",{"pid":pid,loginInfo:LoginInfo},function(val){
		//var retObj = JSON.parse(val);
		var retObj=val
		if (retObj.code =="success"){
			$.messager.alert("提示:","导入成功."+"共【"+retObj.total+"条】,  成功【"+retObj.successNum+"】条.  "+"失败【"+retObj.errNum+"】条","info");
		}
		else{
			$.messager.alert("提示:","导入失败."+"失败原因："+retObj.msg,"info");
			ErrFlag=1
		}
		$.messager.progress('close');
		$("#druglist").datagrid("load",{"params":pid});
	},"json",false)
	
	return ErrFlag;
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

/// 导出错误数据（后台导出下载）
function ExportDataErrMsg(){
	
	var rtn = $cm({
		dataType:'text',
		ResultSetType:"Excel",
		ExcelName:"错误日志", 		//默认DHCCExcel
		ClassName:"web.DHCCKBExport",
		QueryName:"ExportDataErrMsg",
		pid:pid
	},false);
	//web.Util.Menu SelectGroupMenu
	location.href = rtn;
	
}

/// 导出（后台导出下载测试）
function ExportMatchDataNew(){
	
	var rtn = $cm({
		dataType:'text',
		ResultSetType:"Excel",
		ExcelName:formatDate(0)+"药品匹配数据", //默认DHCCExcel
		ClassName:"web.DHCCKBMatchSearch",
		QueryName:"ExportMatchDataNew",
		pid:pid
	},false);
	//web.Util.Menu SelectGroupMenu
	location.href = rtn;
	
	var rtn = $cm({
		dataType:'text',
		ResultSetType:"Excel",
		ExcelName:formatDate(0)+"药品匹配数据", //默认DHCCExcel
		ClassName:"web.DHCCKBExport",
		QueryName:"ExportTmpData",
		pid:pid
	},false);
	//web.Util.Menu SelectGroupMenu
	location.href = rtn;
}


/// JQuery 初始化页面
$(function(){ initPageDefault(); })
