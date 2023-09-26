var arrayObj=new Array(
   new Array("List_WYInstr","WYInstr"),
   new Array("List_NotFollowInstr","NotFollowInstr"),
   new Array("List_SkinTestInstr","SkinTestInstr"),
   new Array("List_IPDosingInstr","IPDosingInstr"),
   new Array("List_OPInfusionInstr","OPInfusionInstr"),
   new Array("List_DrippingSpeedInstr","DrippingSpeedInstr")
);
$(function(){
	InitHospList();
    $('#Confirm').click(SaveInstrConfig)
});
function InitHospList()
{
	var hospComp = GenHospComp("Doc_BaseConfig_InstrConfig");
	hospComp.jdata.options.onSelect = function(e,t){
		Init();
	}
	hospComp.jdata.options.onLoadSuccess= function(data){
		Init();
	}
}
function Init(){
	for( var i=0;i<arrayObj.length;i++) {
		   var param1=arrayObj[i][0];
		   var param2=arrayObj[i][1];
	       LoadInstrData(param1,param2);	    
   }
}
function LoadInstrData(param1,param2)
{
	$("#"+param1+"").find("option").remove();
	var objScope=$.cm({ 
		ClassName:"DHCDoc.DHCDocConfig.InstrConfig", 
		QueryName:"FindTypeInstr",
		value:param2,
		HospId:$HUI.combogrid('#_HospList').getValue(),
		rows:99999
	},false);
   var vlist = ""; 
   var selectlist="";
   jQuery.each(objScope.rows, function(i, n) { 
	    selectlist=selectlist+"^"+n.selected
        vlist += "<option value=" + n.InstrRowID + ">" + n.InstrDesc + "</option>"; 
   });
   $("#"+param1+"").append(vlist); 
   for (var j=1;j<=selectlist.split("^").length;j++){
		if(selectlist.split("^")[j]=="true"){
			$("#"+param1+"").get(0).options[j-1].selected = true;
		}
	}
							
};
function SaveInstrConfig()
{
	var DataList=""
   for( var i=0;i<arrayObj.length;i++) {
	   var InstrStr=""
	   var param1=arrayObj[i][0];
	   var param2=arrayObj[i][1];
	   var size = $("#" + param1 + " option").size();
	   if(size>0){
			$.each($("#"+param1+" option:selected"), function(i,own){
              var svalue = $(own).val();
			  if (InstrStr=="") InstrStr=svalue
			  else InstrStr=InstrStr+"^"+svalue
			})
			DataList=DataList+String.fromCharCode(2)+param2+String.fromCharCode(1)+InstrStr
	   }	   
   }
   var value=$.cm({ 
		ClassName:"web.DHCDocConfig", 
		MethodName:"SaveConfig",
		Coninfo:DataList,
		HospId:$HUI.combogrid('#_HospList').getValue(),
	},false);
	if(value=="0"){
		$.messager.show({title:"提示",msg:"保存成功"});					
	}
}
