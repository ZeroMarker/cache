//PMP.NewImp.js
function BodyLoadHandler()
{
	var obj;
	obj=document.getElementById("Save") ;
	if (obj) obj.onclick=Save_Click;
	
}
//
function Save_Click(){
	var obj;
	
	IPML_Code=document.getElementById("IPML_Code").value;
	IPML_Name=document.getElementById("IPML_Name").value;
	IPML_Emergency_DR=document.getElementById("IPML_Emergency_DR").value;
	IPML_Module_DR=document.getElementById("IPML_Module_DR").value;
	IPML_Engineer_DR=document.getElementById("IPML_Engineer_DR").value;
	str1=IPML_Code+"^"+IPML_Name+"^"+IPML_Emergency_DR+"^"+IPML_Module_DR+"^"+IPML_Engineer_DR
	
	IPML_DevelopUser=document.getElementById("IPML_DevelopUser").value;
	IPML_Situation=document.getElementById("IPML_Situation").value;
	IPML_Status_DR=""  //document.getElementById("IPML_Status_DR").value;
	IPML_Auditor1=document.getElementById("IPML_Auditor1").value;
	IPML_Auditor2=document.getElementById("IPML_Auditor2").value;
	str2=IPML_DevelopUser+"^"+IPML_Situation+"^"+IPML_Status_DR+"^"+IPML_Auditor1+"^"+IPML_Auditor2

	IPML_Auditor=document.getElementById("IPML_Auditor").value;
	IPML_CreateDate=document.getElementById("IPML_CreateDate").value;
	IPML_CreateUser_DR="" //document.getElementById("IPML_CreateUser_DR").value;
	IPML_AssignEngineer_DR=document.getElementById("IPML_AssignEngineer_DR").value;
	IPML_TestDate="" //document.getElementById("IPML_TestDate").value;
	str3=IPML_Auditor+"^"+IPML_CreateDate+"^"+IPML_CreateUser_DR+"^"+IPML_AssignEngineer_DR+"^"+IPML_TestDate
	
	IPML_FinishDate="" //document.getElementById("IPML_FinishDate").value;
	IPML_Menu=document.getElementById("IPML_Menu").value;
	IPML_CreateLoc_DR=document.getElementById("IPML_CreateLoc_DR").value;
	IPML_CreateTel=document.getElementById("IPML_CreateTel").value;
	IPML_AdjunctFlag=document.getElementById("IPML_AdjunctFlag").value;
	str4=IPML_FinishDate+"^"+IPML_Menu+"^"+IPML_CreateLoc_DR+"^"+IPML_CreateTel+"^"+IPML_AdjunctFlag
	
	IPML_Solution=document.getElementById("IPML_Solution").value;
	IPML_Type=document.getElementById("IPML_Type").value;
	IPML_PredictTime=document.getElementById("IPML_PredictTime").value;
	IPML_Project_DR=document.getElementById("IPML_Project_DR").value;
	IPML_Degree_DR=document.getElementById("IPML_Degree_DR").value;
	IPML_Mode=document.getElementById("IPML_Mode").value;
	str5=IPML_Solution+"^"+IPML_Type+"^"+IPML_PredictTime+"^"+IPML_Project_DR+"^"+IPML_Degree_DR+"^"+IPML_Mode
	
	IStr=str1+"^"+str2+"^"+str3+"^"+str4+"^"+str5
	
	var HEmergency=document.getElementById("HEmergency").value;

	var SerPath=document.getElementById('SerPath');
	if (SerPath) {var encmeth=SerPath.value;} else {var encmeth=''};
	var error=cspRunServerMethod(encmeth,IStr,HEmergency)
	//alert("error:"+error)
	if (error==""){
		   			alert("±£´æ³É¹¦£¡")
	    		}else{alert(error);}	
	var lnk = "websys.default.csp?WEBSYS.TCOMPONENT=PMP.ImprovementList";
 		window.location.href=lnk;
	
}
function Project_LookUp(value){
	
	var val=value.split("^");
	//var obj=document.getElementById('IPML_Emergency_DR');
	//if (obj){obj.value=val[2]};
	var obj=document.getElementById('HProject');
	if (obj){obj.value=val[2]};
}	
function Emergency_LookUp(value){
	
	var val=value.split("^");
	//var obj=document.getElementById('IPML_Emergency_DR');
	//if (obj){obj.value=val[2]};
	var obj=document.getElementById('HEmergency');
	if (obj){obj.value=val[2]};
}
function Improvement_LookUp(value){
	
	var val=value.split("^");
	//var obj=document.getElementById('IPML_Emergency_DR');
	//if (obj){obj.value=val[2]};
	var obj=document.getElementById('HImprovement');
	if (obj){obj.value=val[2]};
}
document.body.onload=BodyLoadHandler;