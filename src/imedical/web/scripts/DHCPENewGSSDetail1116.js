
document.body.onload = BodyLoadHandler;
function BodyLoadHandler()
{
	var objArr=document.getElementsByTagName("textarea");
	var objLength=objArr.length;
	for (var i=0;i<objLength;i++)
	{
		if (objArr[i].id=="GSSDetail") continue;
		setTareaAutoHeight(objArr[i]);
	}
	websys_setfocus('OK');
}
function setTareaAutoHeight(e) {
    //e.style.height = e.scrollHeight + "px";
	if (e.scrollHeight<32){
		e.style.height=32+"px";
	}else{
		e.style.height = e.scrollHeight + "px";
	}
}
function SaveGSSDetail()
{
	var obj,encmeth,GSID,GSSDetail;
	var obj=document.getElementById("UpdateGSSDetail");
	if (obj) var encmeth=obj.value;
	obj=document.getElementById("GSID");
	if (obj) GSID=obj.value;
	obj=document.getElementById("GSSDetail");
	if (obj) GSSDetail=obj.value;
	var ret=cspRunServerMethod(encmeth,GSID,GSSDetail);
	window.returnValue=1;
	window.close();
}
function Close()
{
	window.returnValue=0;
	window.close();
}
