/// DHCST.PIVA.UPDBAT
function BodyLoadHandler()
{
	InitFrom();
	var obj = document.getElementById("UpdBat");
	//if (obj) obj.disabled=true;
	var obj=document.getElementById("cmdOk");
	if (obj) obj.onclick=UpdBat;
	var obj=document.getElementById("cmdCancel");
	if (obj) obj.onclick=Cancel;
	
}

function InitFrom()
{
	var obj = document.getElementById("UpdBat");
	if (obj){PInitBatNo(obj);}
	
}

/// 关闭
function Cancel()
{
	window.close();
}
/// 更改批次
function UpdBat()
{
	var moeori="";
	var grpno="";
	var batno="";
	var obj;
	obj=document.getElementById("Moeori");
	if (obj) moeori=obj.value;
	if (moeori=="") {
		alert(t['EMPTY_MOEORI']);
		return;
	}
	obj=document.getElementById("GrpNo");
	if (obj) grpno=obj.value;
	if (grpno=="") {
		alert(t['EMPTY_GRP']);
		return;
	}
	obj=document.getElementById("UpdBat");
	if (obj) batno=obj.value;
	if (batno=="") {
		alert(t['EMPTY_BAT']);
		return;
	}
	var plocobj=document.getElementById("LocID");
	var ploc="";
	if (plocobj) {ploc=plocobj.value;}
	obj=document.getElementById("mUpdBat");
	if (obj) {var encmeth=obj.value;}  else {var encmeth='';}
	var ret=cspRunServerMethod(encmeth,moeori,grpno,batno,ploc);
	if (ret!=0) {alert(t['ERR_INS']);} else {alert(t['OK_INS']);}
	//opener.location.reload();
	window.close();
}



///初始化配液分类
function PInitBatNo(listobj)
{
	var locdr=""
	var obj=document.getElementById("LocID");
	if (obj){var locdr=obj.value;}
	var obj=document.getElementById("mGetBatno");
	if (obj) {var encmeth=obj.value;}	else {var encmeth='';}
	var result=cspRunServerMethod(encmeth,locdr);
	if (result!="")
	{
		var tmparr=result.split("!!")
		var cnt=tmparr.length
		for (i=0;i<=cnt-1;i++)
		{ 
			var typestr=tmparr[i].split("^")
			var batno=typestr[0];
			var batnoindex=typestr[0];
			///初始化配液批次
			if (listobj)
			{
				listobj.size=1; 
			 	listobj.multiple=false;

			 	listobj.options[i+1]=new Option(batno,batnoindex);
		    }
			
		}
		
	}
	

}


document.body.onload=BodyLoadHandler;