//Component->Create-Retrieve-Update-Delete
// CompObj.model中的id字段定义名要为RowId
var t = {
	"CodeExist":"代码已存在!",
	"NotExistRecord":"不存在该记录!",
	"OperateSucc":"操作成功!",
	"SelectRowAndDelete":"请先选择行记录,再删除!",
	"Warning":"警告!",
	"ErrorCode":"错误代码!",
	"CodeRequire":"代码不能为空!",
	"DescRequire":"描述不能为空!",
	
	"Fail":"失败!",
	"OperateFail":"操作失败!",
	"DeleteFail":"删除失败!",
	"SaveFail":"保存失败!",
	"DeleteConfirm":"确定要删除此记录么？"
};
var CompObj = {
	cls:"",
	compName:"",
	model:["RowId","Code", "Desc"],
	modelUi:["","",""],
	modelObj:{},
	tabelPre:"",
	del: "Del"
};
var delClick = function(){
	if (CompObj.modelObj["RowId"].val()==""){
		$.messager.alert(t["Warning"],t["SelectRowAndDelete"],"warning"); return false;
	}
	$.messager.confirm(t["Warning"],t["DeleteConfirm"],function(r){  //删除操作加个确认操作
		if (r){
			$.ajaxRunServerMethod(getModelJson("Del"),
				function(data,textStatus){
					if ("undefined" == typeof data.err){
						if (data>0){
							//$.messager.alert('成功','删除接收类型成功!');
							$("#Clear").click();
							$("#Find").click();
						}else{
							$.messager.alert(t["Fail"],t["DeleteFail"]+'&nbsp;&nbsp;'+t["ErrorCode"]+':'+t[data]||data,"error");
						}
					}else{
						$.messager.alert(t["Fail"],t["DeleteFail"]+'&nbsp;&nbsp;'+data.err);  
					}
				}
			);
		}
	})

}
var saveClick = function(){
	if (CompObj.modelObj["Code"] && CompObj.modelObj["Code"].val()==""){
		$.messager.alert(t['Warning'],t['CodeRequire']);return false;
	}
	if (CompObj.modelObj["Desc"] && CompObj.modelObj["Desc"].val()==""){
		$.messager.alert(t['Warning'],t['DescRequire']); return false;
	}
	$.ajaxRunServerMethod(getModelJson("Save"),
		function(data,textStatus){
			if ("undefined" == typeof data.err){
				if (data>0){
					//$.messager.alert('成功','保存接收类型成功!');
					$("#Clear").click();
					$("#Find").click();
				}else{
					$.messager.alert(t['Fail'],t['SaveFail']+"&nbsp;&nbsp;"+(t[data]||data));  
				}
			}else{
				$.messager.alert(t['Fail'],t['SaveFail']+"&nbsp;&nbsp;"+data.err);  
			}
		}
	);
}
var clearClick = function(){
	for (var i=0; i<CompObj.model.length;i++){
		filed = CompObj.model[i];
		CompObj.modelObj[filed].val("");
		if(!!CompObj.modelUi[i]){
			if (CompObj.modelUi[i].type=="combobox"){
				CompObj.modelObj[filed].combobox("setValue","");
			}
			if (CompObj.modelUi[i].type=="combogrid"){
				CompObj.modelObj[filed].combogrid("setValue","");
			}
		}
	}
	CompObj["del"].unbind("click",delClick).linkbutton('disable');
}

var getModelJson = function(MethodName){
	var tmpObj,filed;
	if (MethodName=="Save"){
		tmpObj = {ClassName:CompObj.cls,MethodName:MethodName};
		filed = "";
		for (var i=0; i<CompObj.model.length;i++){
			filed = CompObj.model[i];
			tmpObj[filed] = CompObj.modelObj[filed].val();
			if(!!CompObj.modelUi[i]){
				if (CompObj.modelUi[i].type=="combobox"){
					tmpObj[filed]= CompObj.modelObj[filed].combobox("getValue");
				}
				if (CompObj.modelUi[i].type=="combogrid"){
					tmpObj[filed]= CompObj.modelObj[filed].combogrid("getValue");
				}
			}
		}
	}else if (MethodName=="Del"){
		tmpObj = {ClassName:CompObj.cls,MethodName:MethodName,RowId:CompObj.modelObj["RowId"].val()};		
	}
	return tmpObj ;
}
var initEvent = function(){
	var filed = "";
	for (var i=0; i<CompObj.model.length;i++){
		filed = CompObj.model[i];
		CompObj.modelObj[filed] = $("#"+filed);
		if(!!CompObj.modelUi[i]){
			if (CompObj.modelUi[i].type=="combobox"){
				if (CompObj.modelUi[i].data){
					CompObj.modelObj[filed].combobox({ data: CompObj.modelUi[i].data, valueField:'Code', textField:"Desc"});
				}
			}
			if (CompObj.modelUi[i].type=="combogrid"){
				if(CompObj.modelUi[i].idField){
					CompObj.modelObj[filed].combogrid("options").idField = CompObj.modelUi[i].idField;
					CompObj.modelObj[filed].combogrid("options").textField = CompObj.modelUi[i].textField;
				}
			}
		}
	}
	CompObj["del"] = $("#"+CompObj["del"]);
	CompObj["del"].linkbutton('disable').linkbutton({iconCls: 'icon-remove'});
	$("#Save").click(saveClick); //.linkbutton({iconCls: 'icon-add'});
	$("#Clear").click(clearClick);
	$("#t"+CompObj.compName).datagrid("options").onClickRow = function(index,rowData){
		if (index>-1){
			for (var i=0; i<CompObj.model.length;i++){
				filed = CompObj.model[i];
				CompObj.modelObj[filed].val(rowData[CompObj.tabelPre+""+filed]);
				if(!!CompObj.modelUi[i]){
					if (CompObj.modelUi[i].type=="combobox"){
						CompObj.modelObj[filed].combobox("setValue",rowData[CompObj.tabelPre+""+filed]);
					}
					if (CompObj.modelUi[i].type=="combogrid"){
						CompObj.modelObj[filed].combogrid("setValue",rowData[CompObj.tabelPre+""+filed]);
					}
				}
			}
			//先unbind事件 否则多事件
			CompObj["del"].unbind('click',delClick).bind("click",delClick).linkbutton('enable');
		}
	}
	//on before load --> getValue--combobox
	$("#t"+CompObj.compName).datagrid("options").onBeforeLoad = function(param){
		if (event){
			//翻页-return true 
			if (event.srcElement.outerHTML && event.srcElement.outerHTML.indexOf("pagination")>-1) return true;
		}
		var exParam={},filed;
		for (var i=0; i<CompObj.model.length;i++){
			filed = CompObj.model[i];
			if(!!CompObj.modelUi[i]){
				if (CompObj.modelUi[i].type=="combobox"){
					exParam[filed] = CompObj.modelObj[filed].combobox("getValue");
				}
			}
		}
		param = $.extend(param,exParam);
		return true;
	}
}
