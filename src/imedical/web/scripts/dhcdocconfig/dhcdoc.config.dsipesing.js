$(function(){ 
	InitHospList();
   $("#BSave").click(SaveDsipesing);
});
function InitHospList()
{
	var hospComp = GenHospComp();
	hospComp.jdata.options.onSelect = function(e,t){
		LoadRecLoc("List_Dosing","IPDispensingRecLoc");
	}
	hospComp.jdata.options.onLoadSuccess= function(data){
		LoadRecLoc("List_Dosing","IPDispensingRecLoc");
	}
}
function SaveDsipesing()
{
	var RecLocStr="";
	var size = $("#List_Dosing"+ " option").size();
	    if(size>0){
			$.each($("#List_Dosing"+" option:selected"), function(i,own){
              var svalue = $(own).val();
			  if (RecLocStr=="") RecLocStr=svalue;
			  else RecLocStr=RecLocStr+"^"+svalue;
			})
	}
	var value=$.m({ 
		ClassName:"web.DHCDocConfig", 
		MethodName:"SaveConfig2",
		Node:"IPDispensingRecLoc",
		NodeValue:RecLocStr,
		HospId:$HUI.combogrid('#_HospList').getValue()
	},false);
	if(value=="0"){
        $.messager.show({title:"提示",msg:"保存成功"});								
	}else{
		$.messager.alert("提示", "保存失败!", "error")	
        return false;	
	}
};
function LoadRecLoc(param1,param2)
{
	$("#"+param1+"").find("option").remove();
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
							
};