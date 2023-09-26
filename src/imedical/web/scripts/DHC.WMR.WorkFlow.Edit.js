/* ======================================================================

JScript Source File -- Created with SAPIEN Technologies PrimalScript 4.1

NAME: DHC.WMR.WorkFlow.Edit.js

AUTHOR: ZF , Microsoft
DATE  : 2007-3-18
========================================================================= */
var CHR_1=String.fromCharCode(1);
var CHR_2=String.fromCharCode(2);
var CHR_Up="^";
var CHR_Tilted="/";
function BodyLoadHandler()
{
	var obj=document.getElementById("cmdSave");
	if (obj){obj.onclick=Save_click;}
	var obj=document.getElementById("cmdAddItem");
	if (obj){obj.onclick=AddItem_click;}
	var obj=document.getElementById("cmdDelItem");
	if (obj){obj.onclick=DelItem_click;}
	var obj=document.getElementById("cmdMoveUp");
	if (obj){obj.onclick=UpItem_click;}
	var obj=document.getElementById("cmdMoveDown");
	if (obj){obj.onclick=DownItem_click;}
	iniForm();
}
function iniForm()
{
	var obj=document.getElementById("cboMrTypeDr");
	if (obj){
		obj.size=1;
		obj.multiple=false;
		}
	insertData();
}

function insertData()
{
	var InPut="";
	var obj=document.getElementById("Rowid");
	if (obj){InPut=obj.value;}
	if (InPut==""){return;}
	
	var obj=document.getElementById('ClasstxtGetData');
    if (obj) {var encmeth=obj.value} else {var encmeth=''}
    var str=cspRunServerMethod(encmeth,InPut);
    if (str!=""){
	    Temp=str.split("^")
	    var obj=document.getElementById("cboMrTypeDr");
		if (obj){
			for(var i = 0; i < obj.options.length; i++)
				{
				var Tmp=obj.options.item(i).value;
				if(Tmp==Temp[1]){obj.selectedIndex=i;}
				}
	    	}
	    var obj=document.getElementById("txtDescription");
	    if (obj){obj.value=Temp[2];}
		var obj=document.getElementById("chkIsActive");
	    if (obj){
		    if (Temp[3]=="Y"){obj.checked=true;}
			else{obj.checked=false;}
		    }	
		var obj=document.getElementById("txtDateFrom");
	    if (obj){obj.value=Temp[4];}
		var obj=document.getElementById("txtDateTo");
	    if (obj){obj.value=Temp[5];}
		var obj=document.getElementById("txtResumeText");
	    if (obj){obj.value=Temp[6];}
    	}
}

function Save_click()
{
	var cRowid="",cMrTypeDr="",cDescription="",cIsActive="",cDateFrom="",cDateTo="",cResume=""
	
	var obj=document.getElementById("Rowid");
	if (obj){cRowid=obj.value;}
	else{cRowid=""}
	
	var obj=document.getElementById("cboMrTypeDr");
	if (obj){
		if (obj.selectedIndex>=0){cMrTypeDr=obj.options.item(obj.selectedIndex).value;}
		}
	var obj=document.getElementById("txtDescription");
	if (obj){cDescription=obj.value;}
	var obj=document.getElementById("chkIsActive");
	if (obj){
		if (obj.checked==true){cIsActive="Y";}
		else{cIsActive="N";}
		}
	var obj=document.getElementById("txtDateFrom");
	if (obj){cDateFrom=obj.value;}
	
	var obj=document.getElementById("txtDateTo");
	if (obj){cDateTo=obj.value;}
	
	var obj=document.getElementById("txtResumeText");
	if (obj){cResume=obj.value;}
	
	if (cMrTypeDr==""){alert(t['cboMrTypeDr']);return;}
	if (cDescription==""){alert(t['txtDescription']);return;}
	if (cDateFrom==""){alert(t['txtDateFrom']);return;}
	if (cDateTo==""){alert(t['txtDateTo']);return;}
	if (CompareDate(cDateFrom,cDateTo)){alert(t['CompareDate']);return;}
	
	var ParStr=cRowid+"^"+cMrTypeDr+"^"+cDescription+"^"+cIsActive+"^"+cDateFrom+"^"+cDateTo+"^"+cResume
	
	//Get workflow item string
	var SIndexNo="",SItemDr="",SubStr="",i;
	var objSList=document.getElementById('cboSelected');
	for (i=0;i<objSList.options.length;i++)
		{
		SIndexNo=i+1;
		SItemDr=objSList.options[i].value;
		if ((SItemDr=="")||(SIndexNo=="")){
			alert(t['AddItemToListBoxFalse']+i);
			return;
			}
		if (SubStr==""){
			SubStr=SIndexNo+"^"+SItemDr;
			}
		else{
			SubStr=SubStr+CHR_1+SIndexNo+"^"+SItemDr;
			}
		}
	if (SubStr=="") {alert(t['AddItemToListBoxFalse']);return;}
	
	var obj=document.getElementById('ClasstxtSaveData');
    if (obj) {var encmeth=obj.value} else {var encmeth=''}
    var Flag=cspRunServerMethod(encmeth,ParStr,SubStr);
    if (Flag){
	    alert(t['AddTrue']);
    	}
    else{
	    alert(t['AddFalse']);
	    }
}

/*
function Quit_click()
{
	opener.Query_click();
	close();
}
*/

function AddItem_click()
{
	var objSList=document.getElementById("cboAvailable");
	var objDList=document.getElementById("cboSelected");
	MoveIn(objSList,objDList);
}

function DelItem_click()
{
	var objSList=document.getElementById("cboSelected");
	MoveOut(objSList);
}

function UpItem_click()
{
	var objSList=document.getElementById("cboSelected");
	MoveUp(objSList);
}

function DownItem_click()
{
	var objSList=document.getElementById("cboSelected");
	MoveDown(objSList);
}

document.body.onload = BodyLoadHandler;

function MoveIn(SList,DList)
{
    if (SList.selectedIndex==-1){return;}
	var i;
	var objSelected ;
	for (i=0;i<SList.options.length;i++){
		if (SList.options[i].selected){
		  	if (IfExist(SList[i].value,DList)==false){
		    	var objSelected = new Option(SList[i].text, SList[i].value);
	        	DList.options[DList.options.length]=objSelected;
	        	i=i-1;
		 		}
       		}
		}
	return;
}

function MoveOut(SList)
{
    if (SList.selectedIndex==-1){return;}
	var i;
	for (i=0;i<SList.options.length;i++)
		{
		if (SList.options[i].selected)
			{
	        SList.options[i]=null;
	        i=i-1;
       		}
		}
	return;
}

function IfExist(Val,List)
{
	for (var i=0;i<List.options.length;i++){
		if (List.options[i].value==Val){return true;}
		}
	return false;
}

function MoveUp(SList)
{
	if (SList.selectedIndex==-1){return;}
	if (SList.selectedIndex==0){return;}
	var i=SList.selectedIndex,j=SList.selectedIndex-1;
	var objS = new Option(SList[i].text, SList[i].value);
	var objD = new Option(SList[j].text, SList[j].value);
	SList.options[j]=objS;
	SList.options[i]=objD;
	SList.options[j].selected=true;
}

function MoveDown(SList)
{
	if (SList.selectedIndex==-1){return;}
	if (SList.selectedIndex==SList.options.length-1){return;}
	var i=SList.selectedIndex,j=SList.selectedIndex+1;
	var objS = new Option(SList[i].text, SList[i].value);
	var objD = new Option(SList[j].text, SList[j].value);
	SList.options[j]=objS;
	SList.options[i]=objD;
	SList.options[j].selected=true;
}

function CompareDate(d1,d2)
{
	var Tmp1=d1.split("/");
	var Tmp2=d2.split("/");
	d1=Tmp1[2]+"/"+Tmp1[1]+"/"+Tmp1[0]
	d2=Tmp2[2]+"/"+Tmp2[1]+"/"+Tmp2[0]
 	return ((new Date(d1)) > (new Date(d2)));
}

