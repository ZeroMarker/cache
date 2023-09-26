var CHR_1=String.fromCharCode(1);
var CHR_2=String.fromCharCode(2);
var CHR_3=String.fromCharCode(3);
var CHR_Up="^";
var CHR_Tilted="/";

function initForm()
{
	var obj=document.getElementById("cmdQuery");
	if (obj){obj.onclick=Query_onclick;}
	var obj=document.getElementById("RegNo");
	if (obj){obj.onclick=Query_onkeydown;}
}

function Query_onclick()
{
	var cDateFrom="",cDateTo="",cRegNo="",cIsAdmit="";
	var obj=document.getElementById("DateFrom");
	if (obj){cDateFrom=obj.value;}
	var obj=document.getElementById("DateTo");
	if (obj){cDateTo=obj.value;}
	var obj=document.getElementById("RegNo");
	if (obj){cRegNo=Trim(obj.value);}
	/*
	var obj=document.getElementById("chkIsAdmit");
	if (obj){
		if (obj.checked==true){
			cIsAdmit="Y";
		}else{
			cIsAdmit="N";
		}
	}
	*/
	cIsAdmit="";
	
	//if ((cDateFrom=="")||(cDateTo=="")||(cIsAdmit=="")) return;

	var lnk="websys.default.csp?WEBSYS.TCOMPONENT=DHC.WMR.AdmitIP.List" + "&DateFrom=" +cDateFrom+"&DateTo="+cDateTo+"&RegNo="+cRegNo+"&IsAdmit="+cIsAdmit;
    parent.frames[1].location.href=lnk;
}


function Query_onkeydown()
{
	if (window.event.keyCode!==13){return;}
	Query_onclick();
}

initForm();

function LTrim(str){ 
	var i;
	for(i=0;i < str.length; i ++)
	{
		 if(str.charAt(i)!=" "&&str.charAt(i)!=" ") 
			break;
	}
	str = str.substring(i,str.length);
	return str;
}

function RTrim(str){
	var i;
	for(i = str.length - 1; i>=0; i--)
	{
		if(str.charAt(i)!=" "&&str.charAt(i)!=" ") 
			break;
	}
	str = str.substring(0,i+1);
	return str;
}

function Trim(str){
	return LTrim(RTrim(str));
} 