$(function(){
	InitHospList();
	$('#BSave').click(SaveHDosingConfig);
})
function InitHospList()
{
	var hospComp = GenHospComp("Doc_BaseConfig_Dosing");
	hospComp.jdata.options.onSelect = function(e,t){
		Init();
	}
	hospComp.jdata.options.onLoadSuccess= function(data){
		Init();
	}
}
function Init(){
	//配液中心接收科室
	LoadDosingRecLoc("List_Dosing","IPDosingRecLoc");
	InitDTPickerDosing("DTPicker_Dosing","IPDosingTime");
	LoadCheckData("Check_IPDosingNextDay","IPDosingNextDay");
	LoadCheckData("Check_IPDosingTodayRecLoc","IPDosingTodayRecLoc");
	LoadCheckData("Check_NotAllowStopWhenPIVASDispensing","NotAllowStopWhenPIVASDispensing");
}
function SaveHDosingConfig()
{
	var LocStr="";
	var size = $("#List_Dosing"+ " option").size();
	if(size>0){
		   $.each($("#List_Dosing"+" option:selected"), function(i,own){
              var svalue = $(own).val();
			  if (LocStr=="") LocStr=svalue;
			  else LocStr=LocStr+"^"+svalue;
			})
	};
	var DataList="IPDosingRecLoc"+String.fromCharCode(1)+LocStr;
	var IPDosingTime=$('#DTPicker_Dosing').timespinner('getValue');
	var time= /^([0-1]?[0-9]|2[0-3]):([0-5][0-9]):([0-5][0-9])$/;
	if (time.test(IPDosingTime) != true) {
	    $.messager.alert("提示", "配液医嘱录入开始时间点格式不正确!");
		return false;
	}
	DataList=DataList+String.fromCharCode(2)+"IPDosingTime"+String.fromCharCode(1)+IPDosingTime;
	var IPDosingNextDay=$("#Check_IPDosingNextDay").checkbox('getValue')?1:0
	DataList=DataList+String.fromCharCode(2)+"IPDosingNextDay"+String.fromCharCode(1)+IPDosingNextDay;
	var IPDosingTodayRecLoc=$("#Check_IPDosingTodayRecLoc").checkbox('getValue')?1:0
	DataList=DataList+String.fromCharCode(2)+"IPDosingTodayRecLoc"+String.fromCharCode(1)+IPDosingTodayRecLoc;
	
	var NotAllowStopWhenPIVASDispensing=$("#Check_NotAllowStopWhenPIVASDispensing").checkbox('getValue')?1:0
	DataList=DataList+String.fromCharCode(2)+"NotAllowStopWhenPIVASDispensing"+String.fromCharCode(1)+NotAllowStopWhenPIVASDispensing;
	var value=$.m({ 
		ClassName:"web.DHCDocConfig", 
		MethodName:"SaveConfig",
		Coninfo:DataList,
		HospId:$HUI.combogrid('#_HospList').getValue()
	},false);
	if(value=="0"){
		$.messager.show({title:"提示",msg:"保存成功"});					
	}
	
}
function LoadCheckData(param1,param2)
{
	var value=$.m({ 
		ClassName:"web.DHCDocConfig", 
		MethodName:"GetConfigNode",
		Node:param2,
		HospId:$HUI.combogrid('#_HospList').getValue()
	},false);
	if (value==1){
		$("#"+param1+"").checkbox('check');
	}else{
		$("#"+param1+"").checkbox('uncheck');
	}
}
function InitDTPickerDosing(param1,param2)
{
    var objScope=$.m({ 
		ClassName:"DHCDoc.DHCDocConfig.DocConfig", 
		MethodName:"getDefaultData",
		value:param2,
		HospId:$HUI.combogrid('#_HospList').getValue()
	},false);
	objScope=eval("(" + objScope + ")");
	if (objScope.result==""){
		objScope.result="00:00:00";
	}
	$("#"+param1+"").timespinner('setValue',objScope.result);
}
function LoadDosingRecLoc(param1,param2)
{
	$("#"+param1+"").find("option").remove()
	var objScope=$.cm({ 
		ClassName:"DHCDoc.DHCDocConfig.DocConfig", 
		QueryName:"FindDep",
		value:param2,
		desc:"",
		HospId:$HUI.combogrid('#_HospList').getValue(),
		rows:99999
	},false);
	var vlist = ""; 
    var selectlist="";
    jQuery.each(objScope.rows, function(i, n) { 
		    selectlist=selectlist+"^"+n.selected
            vlist += "<option value=" + n.CTLOCRowID + ">" + n.CTLOCDesc + "</option>"; 
    });
    $("#"+param1+"").append(vlist); 
    for (var j=1;j<=selectlist.split("^").length;j++){
			if(selectlist.split("^")[j]=="true"){
				$("#"+param1+"").get(0).options[j-1].selected = true;
			}
	}
}