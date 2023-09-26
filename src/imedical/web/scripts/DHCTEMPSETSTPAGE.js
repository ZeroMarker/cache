var SetStartPage=document.getElementById("SetStartPage").value;
var GetStartPage=document.getElementById("GetStartPage").value;
var OrdTyp=document.getElementById("OrdTyp").value;
var Adm=document.getElementById("Adm").value;
var Dep=document.getElementById("Dep").value;

var DepNo=document.getElementById("DepNo").value;
var StPage=document.getElementById("StPage");
function BodyLoadHandler()
{
	var obj=document.getElementById("SureBtn");
	if (obj) {obj.onclick=Save_click;}
	var ret=cspRunServerMethod(GetStartPage,OrdTyp, Adm, Dep,DepNo);
	StPage.value=ret;
	 //obj.options[i]=new Option(myarray[1],myarray[0]);
	
   //
}
function Save_click()
{
       //  alert(SetStartPage+"--"+OrdTyp+"----"+Adm+"---"+Dep+"---"+StPage.value);
		var ret=cspRunServerMethod(SetStartPage,OrdTyp, Adm, Dep, StPage.value,DepNo);
        window.close();
}
document.body.onload = BodyLoadHandler;