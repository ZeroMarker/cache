document.body.onload = BodyLoadHandler;
window.returnValue=null;
function BodyLoadHandler()
{
var obj=document.getElementById("Button1");
if  (obj) {var Button1=obj.value;}
var obj=document.getElementById("Button2");
if  (obj) {var Button2=obj.value;}
var obj=document.getElementById("Button3");
if  (obj) {var Button3=obj.value;}

var TButton1=document.getElementById("TButton1");
if  (TButton1) {TButton1.onclick=TButton11;TButton1.style.display='';}
var TButton2=document.getElementById("TButton2");
if  (TButton2) {TButton2.onclick=TButton22;TButton2.style.display='';}
var TButton3=document.getElementById("TButton3");
if  (TButton3) {TButton3.onclick=TButton33;TButton3.style.display='';TButton3.focus();}
	
var TButton1=document.getElementById("TButton1");
if  (TButton1) {if (Button1!=""){ 
	//TButton1.innerText=Button1;
	TButton1.innerHTML="<img SRC='../images/uiimages/print.png' BORDER='0'>"+Button1;
} else {TButton1.style.display='none';};}
var TButton2=document.getElementById("TButton2");
if  (TButton2) {if (Button2!=""){
	TButton2.innerHTML="<img SRC='../images/uiimages/print.png' BORDER='0'>"+Button2;
} else {TButton2.style.display='none';};}
var TButton3=document.getElementById("TButton3");
if  (TButton3) {if (Button3!=""){
	//TButton3.innerText=Button3;
	TButton3.innerHTML="<img SRC='../images/uiimages/print.png' BORDER='0'>"+Button3;
} else {TButton3.style.display='none';};}

InitAdmReasonList();
var obj=document.getElementById("UpateTrans");
if (obj) obj.onclick=UpateTransClickHandler;
}
function InitAdmReasonList() {
	var myobj=document.getElementById("AdmReasonList");
	if (myobj) {
		myobj.size = 1;
		myobj.multiple = false;
		var PrescriptTypeStrObj=document.getElementById("PrescriptTypeStr");
		var PrescriptTypeStr=PrescriptTypeStrObj.value;
		if (PrescriptTypeStr!="") {
			AddItemToListByStr("AdmReasonList",PrescriptTypeStr);
		}else{
			myobj.style.display='none';
			var obj=document.getElementById("cAdmReasonList");
			if (obj) obj.style.display='none';
			var obj=document.getElementById("UpateTrans");
			if (obj) obj.style.display='none';
		}
	}
}
function UpateTransClickHandler() {
	var obj=document.getElementById("AdmReasonList");
	if (obj.value=="") {
		alert("相关费别不能为空,请选择[相关费别].");
		return;
	}
	window.returnValue="4^"+obj.value;
 	window.close();
}
function AddItemToListByStr(ListName,str) {
	var obj=document.getElementById(ListName);
	if (obj){
		var ary=str.split('!');
		if (ary.length>0) {
			for (var i=0;i<ary.length;i++) {
				var arytxt=ary[i].split('^');
				obj.options[obj.length] = new Option(arytxt[1],arytxt[0]); 
			}
		}
		obj.selectedIndex=-1;
	}
}
function TButton11()
{
	window.returnValue=1;
 	window.close();
}
function TButton22()
{
	window.returnValue=2;
  window.close();
}
function TButton33()
{
 window.returnValue=3;
 window.close();
}
