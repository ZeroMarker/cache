/// 页面初始化函数
function initPageDefault(){
}

/// 读取文件
function read(){
	
	var files=$("input[name=file9]").val();                           
	runClassMethod("web.DHCCKBRuleUpdCompare","ImportGlobal",{"Global":"TMPExportDrugRule",FilePath:files,"loginInfo":LoginInfo},function(jsonString){
		if (jsonString[0].sqlCode == 0){
			$.messager.alert("提示:","导入成功！","info");
			$("input[name=file9]").val("");
		    $("#ALL label").text(jsonString[0].ALL);
			$("#DIFF label").text(jsonString[0].DIFF);
			$("#ADD label").text(jsonString[0].ADD);
		}else{
			$.messager.alert("提示:","导入失败！","");
		}
	
	},'json',false)
}



/// JQuery 初始化页面
$(function(){ initPageDefault(); })