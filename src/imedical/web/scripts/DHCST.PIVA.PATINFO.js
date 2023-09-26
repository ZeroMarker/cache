/// DHCST.PIVA.PATINFO
function BodyLoadHandler()
{
  	var oeori="";
  	var adm="";
  	var patstr="";
  	var obj=document.getElementById("Oeori");
	if (obj){oeori=obj.value;}
	var obj=document.getElementById("Adm");
	if (obj){adm=obj.value;}
	if (adm!=""){
		var patstr=cspRunGetPatInfo(adm);
		if (patstr=="") return;
	}
	else if (oeori!=""){
		var patstr=cspRunGetPatInfoByOeori(oeori);
		if (patstr=="") return;
	}
	if (patstr!=""){
		var arrpat=patstr.split("^");
		var regno=arrpat[0];
		var paname=arrpat[1];
		var pasex=arrpat[2];
		var paage=arrpat[3];
		var paweight=arrpat[4];
		var MRDiagnos=arrpat[5];
		//MRDiagnos=ReplaceStr(MRDiagnos,"!","\n");
		var PaAllergy=arrpat[6];
		//PaAllergy=ReplaceStr(PaAllergy,"!","\n");
		var objregno=document.getElementById("tRegNo");
		if (objregno) {objregno.value=regno;}
		var objpaname=document.getElementById("tPaName");
		if (objpaname) {objpaname.value=paname;}
		var objpasex=document.getElementById("tPaSex");
		if (objpasex) {objpasex.value=pasex;}
		var objpaage=document.getElementById("tPaAge");
		if (objpaage) {objpaage.value=paage;}
		var objweight=document.getElementById("tPaWeight");
		if (objweight) {objweight.value=paweight;}
		var objmrdi=document.getElementById("tMRDiagnos");		
		if (objmrdi) {objmrdi.value=MRDiagnos;}
		var objpaal=document.getElementById("tPaAllergy");
		if (objpaal) {objpaal.value=PaAllergy;}
	}
	
	var obj=document.getElementById("bClose");
	if (obj) obj.onclick=CloseWin;
}
/// ¹Ø±Õ
function CloseWin()
{
	window.close();
}
function cspRunGetPatInfoByOeori(Oeori)
{
	var obj=document.getElementById("mGetPatInfoByOeori");
	if (obj) {var encmeth=obj.value;}	else {var encmeth='';}
	var result=cspRunServerMethod(encmeth,Oeori);
	return result;
}
function cspRunGetPatInfo(Oeori)
{
	var obj=document.getElementById("mGetPatInfo");
	if (obj) {var encmeth=obj.value;}	else {var encmeth='';}
	var result=cspRunServerMethod(encmeth,Oeori);
	return result;
}
document.body.onload=BodyLoadHandler;