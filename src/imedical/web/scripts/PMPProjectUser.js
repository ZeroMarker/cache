///PMPProjectUser
var pama="";
var theTowPama=""
var objtbl="";
var SelectedRow = 0;
var CurrentSel = 0;
var admdepobj=document.getElementById('ProDR');
if (admdepobj) admdepobj.onkeydown=getadmdep1
var admdepobj=document.getElementById('SSUser');
if (admdepobj) admdepobj.onkeydown=getadmdep2
function getadmdep1()
{if (window.event.keyCode==13) 
	{  window.event.keyCode=117;
	  ProDR_lookuphandler();
		}
}
function getadmdep2()
{if (window.event.keyCode==13) 
	{  window.event.keyCode=117;
	  SSUser_lookuphandler();
		}
}
function BodyLoadHandler()
{
	var obj;
	
	obj=document.getElementById("Add") ;
	if (obj) obj.onclick=newAdd;
}

function newAdd(){
		var lnk = "websys.default.csp?WEBSYS.TCOMPONENT=PMPProjectUserSub"+pama;
 		window.open(lnk,'_blank','toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width=900,height=520,left=100,top=100')
	}

function SelectRowHandler()	{
	var eSrc=window.event.srcElement;
	objtbl=document.getElementById('tPMPProjectUser');
	var rows=objtbl.rows.length;
	var lastrowindex=rows - 1;
	var rowObj=getRow(eSrc);
	var selectrow=rowObj.rowIndex;
	if (!selectrow) return;
	var SelRowObj=document.getElementById('TProjectz'+selectrow);
	var SelRowObj1=document.getElementById('TUserz'+selectrow);
	var SelRowObj2=document.getElementById('TDictionaryz'+selectrow);
	var SelRowObj3=document.getElementById('TDate1z'+selectrow);
    var SelRowObj4=document.getElementById('TTime1z'+selectrow);
    var SelRowObj5=document.getElementById('TDate2z'+selectrow);
    var SelRowObj6=document.getElementById('TTime2z'+selectrow);
	var SelRowObj7=document.getElementById('TPhonez'+selectrow);
	var SelRowObj8=document.getElementById('TRemarkz'+selectrow);
	var SelRowObj9=document.getElementById('TRowidz'+selectrow);
	var SelRowObj10=document.getElementById('TProjectIDz'+selectrow);
	var SelRowObj11=document.getElementById('TUseridz'+selectrow);
	var SelRowObj12=document.getElementById('TDictionaryIdz'+selectrow);
	
	pama="&ProDR="+ SelRowObj.innerText+"&SSUser="+SelRowObj1.innerText+"&dictionary="+SelRowObj2.innerText+"&date1="+SelRowObj3.innerText+"&time1="+SelRowObj4.innerText+"&date2="+SelRowObj5.innerText+"&time2="+SelRowObj6.innerText+"&phone="+SelRowObj7.innerText+"&remark="+SelRowObj8.innerText+"&ProjectId="+SelRowObj9.innerText+"&ProDRHidden="+SelRowObj10.innerText+"&SSUserid="+SelRowObj11.innerText+"&dicid="+SelRowObj12.innerText
	
	theTowPama="&ProjectRowid="+SelRowObj9.innerText+"&ProDR="+ SelRowObj.innerText+"&SSUser="+SelRowObj1.innerText
	
	RetrieveOrdCat(theTowPama);
	var SelRowObj
	var obj	
	if (selectrow==CurrentSel){	
	CurrentSel=0;
	pama="";
	theTowPama="";
	RetrieveOrdCat(theTowPama);
	return;
	}	
	
	CurrentSel=selectrow
	SelectedRow = selectrow;
}

function LookUp_ProDesc(value){
    var info=value.split("^");
    document.getElementById("ProDRHidden").value=info[0];
    document.getElementById('ProDR').value = info[1];
}
function getUserId(value){
	var info=value.split("^");
    document.getElementById("SSUser").value=info[0];
    document.getElementById("SSUserid").value = info[2];
    }
function RetrieveOrdCat(value){
	var lnk="websys.default.csp?WEBSYS.TCOMPONENT=PMPProjectUserAndModuleUser="+value	
	parent.frames['PMPProjectUserAndModuleUser'].location.href=lnk;
	
	}
document.body.onload=BodyLoadHandler;
