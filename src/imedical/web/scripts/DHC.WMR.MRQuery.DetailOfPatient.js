//DHC.WMR.MRQuery.DetailOfPatient.js

function Init(){
	var MainID=GetParam(window,"MainID");
	var MrNo=GetParam(window,"MrNo");
	var VolID=GetParam(window,"VolID");
	var obj=document.getElementById("MethodGetPatientBaseInfo")
	if(obj){
		var method=obj.value;
		var baseInfo=cspRunServerMethod(method,MainID);	
		var arr=baseInfo.split("^");
		if (arr.length>0){
			var obj=document.getElementById("MrNo");	
			if (obj){
				obj.value=MrNo	
			}
			var obj=document.getElementById("Name");	
			if (obj){
				obj.value=arr[1]	
			}
			var obj=document.getElementById("Sex");	
			if (obj){
				obj.value=arr[3]	
			}
			var obj=document.getElementById("Age");	
			if (obj){
				obj.value=arr[5]	
			}
			
		}
	}
	var obj=document.getElementById("MethodGetPatientAdmInfo");
	if (obj){
		var method=obj.value;
		var admInfo=cspRunServerMethod(method,VolID);	
		var arr=admInfo.split("^");
		var obj=document.getElementById("AdmDate");	
		if (obj){
			obj.value=arr[0];
		}
		var obj=document.getElementById("AdmLoc");	
		if (obj){
			obj.value=arr[1];	
		}
		var obj=document.getElementById("DischDate");	
		if (obj){
			obj.value=arr[2];	
		}
		var obj=document.getElementById("DischLoc");	
		if (obj){
			obj.value=arr[3];	
		}
	}
}
window.onload=Init;