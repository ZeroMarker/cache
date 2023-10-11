//===========================================================================================
// 作者：      bianshuai
// 编写日期:   2020-12-28
// 描述:	   知识库插件页面JS
//===========================================================================================

var ID = "";
/// 页面初始化函数
function initPageDefault(){
	
	/// 初始化页面参数
	InitPageParams();
}

/// 初始化页面参数
function InitPageParams(){
	
	ID = getParam("ID");   /// 病人ID
	if (ID != ""){
		// 初始化加载表单代码和描述
		LoadPluginTemp();
	}
}

/// 初始化加载表单代码和描述
function LoadPluginTemp(){
	
	runClassMethod("web.DHCCKBRevPlugin","GetRevPlugin",{"ID":ID},function(jsonObj){
		if (jsonObj != ""){
			$("#Code").val(jsonObj.Code);   /// 表单代码
			$("#Desc").val(jsonObj.Desc);   /// 表单描述
		}
	},'json',false)
}

/// 保存
function Save(){
	
	var Code = $("#Code").val();  /// 代码
	var Desc = $("#Desc").val();  /// 描述
	if (Code == ""){
		$.messager.alert("提示:","表单代码不能为空！","warning");
		return;
	}
	if (Desc == ""){
		$.messager.alert("提示:","表单名称不能为空！","warning");
		return;
	}
	
	runClassMethod("web.DHCCKBRevPlugin","SaveOrUpdate",{"ID":ID, "Code":Code, "Desc":Desc},function(jsonString){

		if (jsonString < 0){
			if(jsonString=="-1"){
				$.messager.alert("提示:","代码不能重复！","warning");
			}else if(jsonString=="-2"){
				$.messager.alert("提示:","名称不能重复！","warning");
			}else{
				$.messager.alert("提示:","保存失败！","warning");
			}
		}else{
			//$.messager.alert("提示:","保存成功！","success");
			CloseWin();    /// 关闭方法
			window.parent.refresh(jsonString);
		}
	},'',false)
}

/// 关闭方法
function CloseWin(){
	
	commonParentCloseWin();
}

/// JQuery 初始化页面
$(function(){ initPageDefault(); })