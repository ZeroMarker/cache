var arrayObj1 = new Array(
   new Array("List_OPStopPaidItemCat","OPStopPaidItemCat"),
   new Array("List_StopInDependExecItemCat","StopInDependExecItemCat")
);
var arrayObj2 = new Array(
   new Array("Check_IPStopPaidOrder","IPStopPaidOrder"),
   new Array("Check_IPStopExecOrder","IPStopExecOrder"),
   new Array("Check_AutoCreateDispApply","AutoCreateDispApply")
);
$(function(){
	InitHospList();
	$("#BSave").click(SaveStopConfig);
})
function InitHospList()
{
	var hospComp = GenHospComp("Doc_BaseConfig_StopConfig");
	hospComp.jdata.options.onSelect = function(e,t){
		Init();
	}
	hospComp.jdata.options.onLoadSuccess= function(data){
		Init();
	}
}
function Init(){
	//listbox 数据加载
	for( var i=0;i<arrayObj1.length;i++) {
	   var param1=arrayObj1[i][0];
	   var param2=arrayObj1[i][1];
	   LoadSubStopConfig(param1,param2);
    }
	//需要控制执行的医嘱优先级
	LoadStopExecOrderPrior("List_StopExecOrderPrior","StopExecOrderPrior");
	//checkbox数据加载
	for( var i=0;i<arrayObj2.length;i++) {
	   var param1=arrayObj2[i][0];
	   var param2=arrayObj2[i][1];
	   InitCheckItems(param1,param2);
    }
}
function LoadSubStopConfig(param1,param2)
{
	$("#"+param1+"").find("option").remove();
	var objScope=$.cm({ 
		ClassName:"DHCDoc.DHCDocConfig.SubCatContral", 
		QueryName:"FindCatList",
		value:param2,
		HospId:$HUI.combogrid('#_HospList').getValue(),
		rows:9999
   },false);
   var vlist = ""; 
   var selectlist="";
   jQuery.each(objScope.rows, function(i, n) { 
			selectlist=selectlist+"^"+n.selected
			vlist += "<option value=" + n.ARCICRowId + ">" + n.ARCICDesc + "</option>"; 
   });
   $("#"+param1+"").append(vlist); 
   for (var j=1;j<=selectlist.split("^").length;j++){
			if(selectlist.split("^")[j]=="true"){
				$("#"+param1+"").get(0).options[j-1].selected = true;
			}
	}
							
}
function InitCheckItems(param1,param2)
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
function LoadStopExecOrderPrior(param1,param2)
{
	$("#"+param1+"").find("option").remove()
	var objScope=$.cm({ 
		ClassName:"DHCDoc.DHCDocConfig.RollOrder", 
		QueryName:"FindPrior",
		value:param2,
		HospId:$HUI.combogrid('#_HospList').getValue(),
		rows:9999
   },false);
   var vlist = ""; 
   var selectlist="";
   jQuery.each(objScope.rows, function(i, n) { 
		selectlist=selectlist+"^"+n.selected
		vlist += "<option value=" + n.OECPRRowId + ">" + n.OECPRDesc + "</option>"; 
   });
   $("#"+param1+"").append(vlist); 
   for (var j=1;j<=selectlist.split("^").length;j++){
		if(selectlist.split("^")[j]=="true"){
			$("#"+param1+"").get(0).options[j-1].selected = true;
		}
	}
							
}
function SaveStopConfig()
{
	var DataList=""
	for( var i=0;i<arrayObj2.length;i++) {
		var param1=arrayObj2[i][0];
	    var param2=arrayObj2[i][1];
		var checkItemVal=0;
		if ($("#"+param1).is(":checked")) {
		   checkItemVal=1
	    }
		if(DataList=="") DataList=param2+String.fromCharCode(1)+checkItemVal
		else  DataList=DataList+String.fromCharCode(2)+param2+String.fromCharCode(1)+checkItemVal
	}
	
	var size = $("#List_StopExecOrderPrior"  + " option").size();
    if(size>0){
		var PriorStr=""
		$.each($("#List_StopExecOrderPrior"+" option:selected"), function(i,own){
		  var svalue = $(own).val();
		  if (PriorStr=="") PriorStr=svalue;
		  else PriorStr=PriorStr+"^"+svalue;
		})
		DataList=DataList+String.fromCharCode(2)+"StopExecOrderPrior"+String.fromCharCode(1)+PriorStr
    }
	for( var i=0;i<arrayObj1.length;i++) {
	   var CatIDStr=""
	   var param1=arrayObj1[i][0];
	   var param2=arrayObj1[i][1];
	   var size = $("#" + param1 + " option").size();
	   if(size>0){
			$.each($("#"+param1+" option:selected"), function(i,own){
              var svalue = $(own).val();
			  if (CatIDStr=="") CatIDStr=svalue
			  else CatIDStr=CatIDStr+"^"+svalue
			})
			DataList=DataList+String.fromCharCode(2)+param2+String.fromCharCode(1)+CatIDStr
	   }	   
   }
   var value=$.m({ 
		ClassName:"web.DHCDocConfig", 
		MethodName:"SaveConfig",
		Coninfo:DataList,
		HospId:$HUI.combogrid('#_HospList').getValue()
   },false);
	if(value=="0"){
		$.messager.popover({msg: '保存成功!',type:'success'});				
	}
}