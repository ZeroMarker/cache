$(function(){  
   LoadLocData();
   LoadCatData();
    $('#Confirm').click(function() {
		SaveConfigData();
	})
})
function LoadLocData(){
	var queryParams = new Object();
	queryParams.ClassName ='DHCDoc.DHCDocCure.Config';
	queryParams.QueryName ='FindLocList';
	queryParams.ArgCnt =0;
	$.dhc.util.runServerQuery(queryParams,"false",function(objScope){
		                       var vlist = ""; 
							   var selectlist="";
							   jQuery.each(objScope.rows, function(i, n) { 
									    selectlist=selectlist+"^"+n.selected
                                        vlist += "<option value=" + n.LocRowId + ">" + n.LocDesc + "</option>"; 
                               });
		                       $("#List_DHCDocCureLoc").append(vlist); 
							   for (var j=1;j<=selectlist.split("^").length;j++){
										if(selectlist.split("^")[j]==1){
											$("#List_DHCDocCureLoc").get(0).options[j-1].selected = true;
										}
								}
							
	});
    
}
function LoadCatData(){
	var queryParams = new Object();
	queryParams.ClassName ='DHCDoc.DHCDocCure.Config';
	queryParams.QueryName ='FindCatList';
	queryParams.ArgCnt =0;
	$.dhc.util.runServerQuery(queryParams,"false",function(objScope){
		                       var vlist = ""; 
							   var selectlist="";
							   jQuery.each(objScope.rows, function(i, n) { 
									    selectlist=selectlist+"^"+n.selected
                                        vlist += "<option value=" + n.ARCICRowId + ">" + n.ARCICDesc + "</option>"; 
                               });
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
	   var DataStr=LocDataStr+String.fromCharCode(2)+SubCatDataStr;
   $.dhc.util.runServerMethod("web.DHCDocConfig","SaveConfig","false",function testget(value){
						if(value=="0"){
							$.messager.show({title:"提示",msg:"保存成功"});					
						}
	},"","",DataStr);
}
