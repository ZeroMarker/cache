var AdmTypeArr=[];
var CareTypeArr=[];
var CliTypeArr=[];
function removeItem (arr,val){
	for (var i=0;i<arr.length;i++){
		if (arr[i]==val){
			arr.splice(i,1);
			return ;
		}
	}
}
function admTypeonClick(e){
	var el = websys_getSrcElement(e);
	var type = el.id.slice(0,2)
	if (el.checked){ 
		AdmTypeArr.push(type);
	}else{
		removeItem(AdmTypeArr,type);
	}
	
	document.getElementById('AdmType').value = AdmTypeArr.join(",");
}
function careTypeonClick(e){
	var el = websys_getSrcElement(e);
	var type = el.id.slice(0,3)
	if (el.checked){ 
		CareTypeArr.push(type);
	}else{
		removeItem(CareTypeArr,type);
	}
	document.getElementById('CareType').value = CareTypeArr.join(",");
	
}

function cliTypeonClick(e){
	var el = websys_getSrcElement(e);
	var type = el.id.slice(0,1)
	if (el.checked){ 
		CliTypeArr.push(type);
	}else{
		removeItem(CliTypeArr,type);
	}
	document.getElementById('CliType').value = CliTypeArr.join(",");
	
}
function parseType(){
	var AdmTypeStr = document.getElementById('AdmType').value;
	AdmTypeArr = AdmTypeStr.split(",");
	for(var i=0;i<AdmTypeArr.length;i++){
		if (AdmTypeArr[i]!=""){
			var obj = document.getElementById(AdmTypeArr[i]+'AdmType')
			if(obj) {obj.checked = true;}
			else {obj.checked = false;}
		}
	}
	var objip = document.getElementById('IPAdmType');
	if (objip){
		objip.onclick=admTypeonClick;
	}
	var obj = document.getElementById('OPAdmType');
	if (obj){
		obj.onclick=admTypeonClick;
	}
	var obj = document.getElementById('EPAdmType');
	if (obj){
		obj.onclick=admTypeonClick;
	}
	//-----------------
	CareTypeArr = document.getElementById('CareType').value.split(",")
	for(var i=0;i<CareTypeArr.length;i++){
		if (CareTypeArr[i]!=""){
			var obj = document.getElementById(CareTypeArr[i]+'CareType')
			if(obj) {obj.checked = true;}
			else {obj.checked = false;}
		}
	}
	var obj = document.getElementById('DocCareType');
	if (obj){
		obj.onclick=careTypeonClick;
	}
	var obj = document.getElementById('NurCareType');
	if (obj){
		obj.onclick=careTypeonClick;
	}
	var obj = document.getElementById('TecCareType');
	if (obj){
		obj.onclick=careTypeonClick;
	}
	//=------
	CliTypeArr = document.getElementById('CliType').value.split(",")
	for(var i=0;i<CliTypeArr.length;i++){
		if (CliTypeArr[i]!=""){
			var obj = document.getElementById(CliTypeArr[i]+'CliType')
			if(obj) {obj.checked = true;}
			else {obj.checked = false;}
		}
	}
	var obj = document.getElementById('YCliType');
	if (obj){
		obj.onclick=cliTypeonClick;
	}
	var obj = document.getElementById('NCliType');
	if (obj){
		obj.onclick=cliTypeonClick;
	}
}
function BodyLoadHandler() {
	var obj=document.getElementById('delete1');
	if (obj) obj.onclick=deleteHandler;
	parseType();
} 
function deleteHandler() {
	if (!confirm("Deleting this icon here will also delete it from all icon profiles.  Do you wish to continue")) return false;
	return delete1_click();
}
document.body.onload=BodyLoadHandler;
