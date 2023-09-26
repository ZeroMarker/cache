///config.curebaseset.js
///对应旧版doccure.curebaseset.hui.csp
///该界面已改为doccure.config.baseset.hui.csp：config.baseset.js
var arrayObj = new Array(
	  new Array("Check_DHCDocCureNeedTriage","DHCDocCureNeedTriage"),
	  new Array("Check_DHCDocCureWorkQrySelf","DHCDocCureWorkQrySelf")
);
var arrayObj1 = new Array(
	  new Array("Text_DHCDocCureFTPIPAddress","DHCDocCureFTPIPAddress"),
	  new Array("Text_DHCDocCureFTPPort","DHCDocCureFTPPort"),
	  new Array("Text_DHCDocCureFTPUserCode","DHCDocCureFTPUserCode"),
	  new Array("Text_DHCDocCureFTPPassWord","DHCDocCureFTPPassWord"),
	  new Array("Text_DHCDocCureFTPPassWordC","DHCDocCureFTPPassWordC"),
	  new Array("Text_DHCDocCureFTPUploadPath","DHCDocCureFTPUploadPath")
);

$(document).ready(function(){
	Init();
	InitEvent();
	PageHandle();
	ConfigDataLoad();
})

function Init(){
	LoadLocData();
	LoadCatData();	
}

function InitEvent(){
	$('#Confirm').click(function() {
		SaveConfigData();
	})
}

function PageHandle(){
	if(ServerObj.DocCureUseBase==1){
		$HUI.checkbox("#Check_DHCDocCureNeedTriage",{
			checked:false,
			disabled:true	
		});
		$HUI.checkbox("#Check_DHCDocCureWorkQrySelf",{
			checked:false,
			disabled:true		
		})	
		for( var i=0;i<arrayObj1.length;i++) {
		   	var param1=arrayObj1[i][0];
		   	var param2=arrayObj1[i][1];
		   	$("#"+param1).prop({
				disabled:true,   	
			})
		}
		//基础版本保证分诊不启用，防止无意勾选造成困扰
		var NeedTriageStr="";
		var DHCDocCureNeedTriage="";
		if ($("#Check_DHCDocCureNeedTriage").is(":checked")) {
			DHCDocCureNeedTriage=1	 
		}
		NeedTriageStr="DHCDocCureNeedTriage"+String.fromCharCode(1)+DHCDocCureNeedTriage;
		var DHCDocCureWorkQrySelfStr="";
		var DHCDocCureWorkQrySelf="";
		if ($("#Check_DHCDocCureWorkQrySelf").is(":checked")) {
			DHCDocCureWorkQrySelf=1	 
		}
		DHCDocCureWorkQrySelfStr="DHCDocCureWorkQrySelf"+String.fromCharCode(1)+DHCDocCureWorkQrySelf;
		var DataStr=NeedTriageStr+String.fromCharCode(2)+DHCDocCureWorkQrySelfStr;
		$.m({
			ClassName:"web.DHCDocConfig",
			MethodName:"SaveConfig",
			Coninfo:DataStr
		},function(value){
			//if(value=="0"){
			//	$.messager.show({title:"提示",msg:"保存成功"});					
			//}else{
			//	$.messager.show({title:"提示",msg:"保存失败"});		
			//}
		});
	}	
}

function ConfigDataLoad(){
	for( var i=0;i<arrayObj.length;i++) {
		var param1=arrayObj[i][0];
		var param2=arrayObj[i][1];
		LoadCheckData(param1,param2);	    
	}	
	for( var i=0;i<arrayObj1.length;i++) {
		var param1=arrayObj1[i][0];
		var param2=arrayObj1[i][1];
		LoadTextData(param1,param2);	    
	}
}
function LoadTextData(param1,param2){
	$.cm({
		ClassName:"DHCDoc.DHCDocCure.Config",
		MethodName:"getDefaultData",
		value:param2
	},function(objScope){
		$("#"+param1+"").val(objScope.result);
	})	
}

function LoadCheckData(param1,param2){
	$.cm({
		ClassName:"DHCDoc.DHCDocCure.Config",
		MethodName:"getDefaultData",
		value:param2
	},function(objScope){
		$("#"+param1+"").val(objScope.result);
		if (objScope.result==1){
			//$("#"+param1+"").attr('checked', true);
			$HUI.checkbox("#"+param1+"",{
				checked:true	
			})
		}else{
			//$("#"+param1+"").attr('checked', false);
			$HUI.checkbox("#"+param1+"",{
				checked:false	
			})	
		}
	})
}

function LoadLocData(){
	$.m({
		ClassName:"DHCDoc.DHCDocCure.Config",
		MethodName:"FindLocListBroker",
	},function(objScope){
		var vlist = ""; 
		var selectlist="";
		var objScopeArr=objScope.split(String.fromCharCode(1))
		for(var i=0;i<objScopeArr.length;i++){
			var oneLoc=	objScopeArr[i];
			var oneLocArr=oneLoc.split(String.fromCharCode(2))
			var LocRowID=oneLocArr[0];
			var LocDesc=oneLocArr[1];
			var selected=oneLocArr[2];
			vlist += "<option value=" + LocRowID + ">" + LocDesc + "</option>"; 
			selectlist=selectlist+"^"+selected
		}
		$("#List_DHCDocCureLoc").append(vlist); 
		for (var j=1;j<=selectlist.split("^").length;j++){
			if(selectlist.split("^")[j]==1){
				$("#List_DHCDocCureLoc").get(0).options[j-1].selected = true;
			}
		}
	});
    
}
function LoadCatData(){
	$.m({
		ClassName:"DHCDoc.DHCDocCure.Config",
		MethodName:"FindCatListBroker",
	},function(objScope){
		var vlist = ""; 
		var selectlist="";
		var objScopeArr=objScope.split(String.fromCharCode(1))
		for(var i=0;i<objScopeArr.length;i++){
			var oneLoc=	objScopeArr[i];
			var oneLocArr=oneLoc.split(String.fromCharCode(2))
			var ARCICRowId=oneLocArr[0];
			var ARCICDesc=oneLocArr[1];
			var selected=oneLocArr[2];
			vlist += "<option value=" + ARCICRowId + ">" + ARCICDesc + "</option>"; 
			selectlist=selectlist+"^"+selected
		}
		$("#List_DHCDocCureItemCat").append(vlist); 
		for (var j=1;j<=selectlist.split("^").length;j++){
			if(selectlist.split("^")[j]==1){
				$("#List_DHCDocCureItemCat").get(0).options[j-1].selected = true;
			}
		}
	});
    
}
function SaveConfigData()
{
	var LocDataStr=""
	var size = $("#List_DHCDocCureLoc option").size();
	if(size>0){
		$.each($("#List_DHCDocCureLoc  option:selected"), function(i,own){
			var svalue = $(own).val();
			if (LocDataStr=="") LocDataStr=svalue
			else LocDataStr=LocDataStr+"^"+svalue
		})
		LocDataStr="DHCDocCureLocStr"+String.fromCharCode(1)+LocDataStr
	}
	var SubCatDataStr=""
	var size = $("#List_DHCDocCureItemCat option").size();
	if(size>0){
		$.each($("#List_DHCDocCureItemCat  option:selected"), function(i,own){
			var svalue = $(own).val();
			if (SubCatDataStr=="") SubCatDataStr=svalue
			else SubCatDataStr=SubCatDataStr+"^"+svalue
		})
		SubCatDataStr="DHCDocCureItemCat"+String.fromCharCode(1)+SubCatDataStr
	}
	var NeedTriageStr="";
	var DHCDocCureNeedTriage="";
	if ($("#Check_DHCDocCureNeedTriage").is(":checked")) {
		DHCDocCureNeedTriage=1	 
	}
	NeedTriageStr="DHCDocCureNeedTriage"+String.fromCharCode(1)+DHCDocCureNeedTriage;
	var DHCDocCureWorkQrySelfStr="";
	var DHCDocCureWorkQrySelf="";
	if ($("#Check_DHCDocCureWorkQrySelf").is(":checked")) {
		DHCDocCureWorkQrySelf=1	 
	}
	var FTPConfigStr="";
	var FTPPassWord="";
	var FTPPassWordC="";
	for( var i=0;i<arrayObj1.length;i++) {
	   	var param1=arrayObj1[i][0];
	   	var param2=arrayObj1[i][1];
	   	var paramval=$("#"+param1).val();
	   	if(param2=="DHCDocCureFTPPassWord"){
		   	FTPPassWord=paramval;
	   	}
	   	else if(param2=="DHCDocCureFTPPassWordC"){
		   	FTPPassWordC=paramval;
		   	//continue;
	   	}else{
			 var paramval=$.trim(paramval);  	
		}
	   	if(FTPConfigStr==""){
		   	FTPConfigStr=param2+String.fromCharCode(1)+paramval;
		}else{
		   	FTPConfigStr=FTPConfigStr+String.fromCharCode(2)+param2+String.fromCharCode(1)+paramval;
		}
	}
	if(FTPPassWord!=FTPPassWordC){
		$.messager.alert('提示',"FTP用户密码与确认密码不一致,请重试.");
		return false;	
	}
	DHCDocCureWorkQrySelfStr="DHCDocCureWorkQrySelf"+String.fromCharCode(1)+DHCDocCureWorkQrySelf;
	var DataStr=LocDataStr+String.fromCharCode(2)+SubCatDataStr+String.fromCharCode(2)+NeedTriageStr;
	var DataStr=DataStr+String.fromCharCode(2)+DHCDocCureWorkQrySelfStr;
	var DataStr=DataStr+String.fromCharCode(2)+FTPConfigStr;
	$.m({
		ClassName:"web.DHCDocConfig",
		MethodName:"SaveConfig",
		Coninfo:DataStr
	},function(value){
		if(value=="0"){
			$.messager.show({title:"提示",msg:"保存成功"});					
		}else{
			$.messager.show({title:"提示",msg:"保存失败"});		
		}
	});
}
