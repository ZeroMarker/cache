var CMPrescTypeEditRow; 
var CMPrescTypeLinkFeeEditRow;
var CNMeditemInstrDataGrid,InstrDataGridEditRow;
var CNMedPackModeDataGrid,PackModeDataGridEditRow;
var CHNPHFrequenceDataGrid,CHNPHFrequenceDataGridEditRow;
var CNMedCookModeDataGrid,CNMedCookModeDataGridEditRow,SelCNMedCookMode=undefined;
var CNMedAddLongOrderGrid,CNMedAddLongOrderEditRow;
var CNMedCookArcModeDataGrid,CookArcModeDataGridEditRow;


//check类型
var arrayObj1 = new Array(
      new Array("Check_UserEMVirtualtLong","UserEMVirtualtLong"),
	  new Array("Check_EMVirtualtLongDrugCreatNextDayOrder","EMVirtualtLongDrugCreatNextDayOrder")
);
//接收科室设置
var arrayObj2 = new Array(
      new Array("List_CNMedCookDep","CNMedCookDep"),
	  new Array("List_EPCNMedCookDep","EPCNMedCookDep")
);
$(function(){
	InitHospList();
	$("#SaveDetails").click(SaveDetailsClickHandle);
	$("#SavePublic").click(SavePublicClickHandle);
});
function InitHospList()
{
	var hospComp = GenHospComp();
	hospComp.jdata.options.onSelect = function(e,t){
		Init();
	}
	hospComp.jdata.options.onLoadSuccess= function(data){
		Init();
	}
}
function Init(){
	//初始化处方类型列表
	InittabCMPrescType();
	//debugger
	//初始化右侧界面
	InitPrescTypeDetail("");
	//初始化公共配置区域
	InitPublicTerritory();

	//所有的checkbox radio元素初始化 
	for( var i=0;i<arrayObj1.length;i++) {
		   var param1=arrayObj7[i][0];
		   var param2=arrayObj7[i][1];
	       LoadCheckData(param1,param2);	    
	}
	
	for( var i=0;i<arrayObj2.length;i++) {
		   var param1=arrayObj6[i][0];
		   var param2=arrayObj6[i][1];
	       LoadDefaultLocData(param1,"");	    
	}
}
function LoadCheckData(param1,param2)
{
	var objScope=$.cm({
		ClassName:"DHCDoc.DHCDocConfig.DocConfig",
		MethodName:"getDefaultData",
	   	value:param2,
	   	HospId:$HUI.combogrid('#_HospList').getValue()
	},false);
	if ((objScope.result==1)){
		$("#"+param1+"").checkbox('check');
	}else{
		$("#"+param1+"").checkbox('uncheck');
	}
}
function LoadDefaultLocData(param1,param2)
{
	$("#"+param1+"").find("option").remove();
	var objScope=$.cm({
		ClassName:"DHCDoc.DHCDocConfig.DocConfig",
		QueryName:"FindDep",
	   	value:param2,
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