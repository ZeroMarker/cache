//Component->Create-Retrieve-Update-Delete
// CompObj.model�е�id�ֶζ�����ҪΪRowId
var t = {
	"CodeExist":"�����Ѵ���!",
	"NotExistRecord":"�����ڸü�¼!",
	"OperateSucc":"�����ɹ�!",
	"SelectRowAndDelete":"����ѡ���м�¼,��ɾ��!",
	"Warning":"����!",
	"ErrorCode":"�������!",
	"CodeRequire":"���벻��Ϊ��!",
	"DescRequire":"��������Ϊ��!",
	
	"Fail":"ʧ��!",
	"OperateFail":"����ʧ��!",
	"DeleteFail":"ɾ��ʧ��!",
	"SaveFail":"����ʧ��!",
	"DeleteConfirm":"ȷ��Ҫɾ���˼�¼ô��"
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
	$.messager.confirm(t["Warning"],t["DeleteConfirm"],function(r){  //ɾ�������Ӹ�ȷ�ϲ���
		if (r){
			$.ajaxRunServerMethod(getModelJson("Del"),
				function(data,textStatus){
					if ("undefined" == typeof data.err){
						if (data>0){
							//$.messager.alert('�ɹ�','ɾ���������ͳɹ�!');
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
					//$.messager.alert('�ɹ�','����������ͳɹ�!');
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
			//��unbind�¼� ������¼�
			CompObj["del"].unbind('click',delClick).bind("click",delClick).linkbutton('enable');
		}
	}
	//on before load --> getValue--combobox
	$("#t"+CompObj.compName).datagrid("options").onBeforeLoad = function(param){
		if (event){
			//��ҳ-return true 
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
