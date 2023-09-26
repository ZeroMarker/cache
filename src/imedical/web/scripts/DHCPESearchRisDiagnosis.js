function bodyOnloadHandly(){
	//登记号
	var objRegNo=document.getElementById("RegNo");
	if(objRegNo){
		objRegNo.onkeydown=Obj_KeyDown;
	}
	//姓名
	var objName=document.getElementById("Name");
	if(objName){
		objName.onkeydown=Obj_KeyDown;
	}
	//开始日期
	var objStartDate=document.getElementById("StartDate");
	if(objStartDate){
		objStartDate.onkeydown=Obj_KeyDown;
	}
	//结束日期
	var objEndDate=document.getElementById("EndDate");
	if(objEndDate){
		objEndDate.onkeydown=Obj_KeyDown;
	}
}
function Obj_KeyDown(e){
	
	var Key=websys_getKey(e);
	if ((13==Key)) {
		BFind_Click();
	}
	
}
function BFind_Click(){

	var RegNo="",Name="",StartDate="",EndDate=""
   	var obj
    obj=document.getElementById("RegNo");
    if (obj) { 
    	RegNo=obj.value;
    	if (RegNo.length<8&&RegNo.length>0) {RegNo=RegNoMask(RegNo);}
    }

	
	obj=document.getElementById("Name");
    if (obj) { Name=obj.value};
    
    
    obj=document.getElementById("StartDate");
    if (obj) { StartDate=obj.value};
	
	obj=document.getElementById("EndDate");
    if (obj) { EndDate=obj.value};
   
     
  var lnk="websys.default.csp?WEBSYS.TCOMPONENT="+"DHCPESearchRisDiagnosis"
			+"&RegNo="+RegNo
			+"&Name="+Name
			+"&StartDate="+StartDate
			+"&EndDate="+EndDate;         
    location.href=lnk; 

}

document.body.onload=bodyOnloadHandly