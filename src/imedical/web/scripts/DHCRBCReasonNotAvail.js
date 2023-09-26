
document.body.onload = BodyLoadHandler;
function BodyLoadHandler() {

document.getElementById('BtnAdd').onclick = BtnAdd_Click;

document.getElementById('BtnUpdate').onclick = BtnUpdate_Click;

//去掉原因类型
 /*var EpisodeTypeStr="F"+String.fromCharCode(1)+"F"+"^"+"S"+String.fromCharCode(1)+"S";
 ComboEpisodeType=dhtmlXComboFromStr("RNAVType",EpisodeTypeStr);
 ComboEpisodeType.enableFilteringMode(true);
 ComboEpisodeType.selectHandle=ComboEpisodeTypeselectHandle;*/




/*
DHCWebD_ClearAllListA("RNAVType");
var encmeth=DHCWebD_GetObjValue("ReadType");
if (encmeth!="")
{
   var rtn=cspRunServerMethod(encmeth,"DHCWeb_AddToListA","RNAVType");	
}

$("RNAVDateFrom").onblur=function()
{
	
	this.value=this.value.toDate();
}

$("RNAVDateTo").onblur=function()
{
	
	this.value=this.value.toDate();
}
*/

//quickK.f8=BtnSearch_click;
//quickK.addMethod();

document.onkeydown=enternextfocus;



}

function BtnAdd_Click() {
  
   var rtn=CheckNull();
    if (!rtn){
	    return false;
    }     

//构造服务端解析对象
//var ParseInfo="TransContent^RNAVCode^RNAVDateFrom^RNAVDateTo^RNAVDesc^RNAVType";
var ParseInfo="TransContent^RNAVCode^RNAVDateFrom^RNAVDateTo^RNAVDesc";
var RBCReasonNotAvail=DHCDOM_GetEntityClassInfoToXML(ParseInfo);


//调用服务端方法
var BtnAddclass=document.getElementById('BtnAddClass');
if (BtnAddclass) {var encmeth=BtnAddclass.value} else {var encmeth=''}; 
var returnvalue=cspRunServerMethod(encmeth,RBCReasonNotAvail);
  if(returnvalue=='-100')
  {
	alert(t['5']);
  }
  else if (returnvalue=='10')
  {
	alert(t['10']);
  }
  else
  {
	alert(t['4']);
  }
  	 ClearFormInfo();
	BtnAdd_click();
}

function BtnUpdate_Click() {
   
   var ID=document.getElementById('ID').value; 
   if(ID==""){
	   {alert("未选择行");return; }
   }
    var Code=document.getElementById('RNAVCode').value;  
   	var GetTid=document.getElementById('GetTid');
   	if (GetTid) {var encmeth=GetTid.value} else {var encmeth=''}; 
	if (Code!=""){
		var returnvalue=cspRunServerMethod(encmeth,Code,ID);
		if (returnvalue!="0"){alert("Code重复!");return false;}
	}
   /*if (ID=="")
   {
   	var Code=document.getElementById('RNAVCode').value;  
   	var GetTid=document.getElementById('GetTid');
   	if (GetTid) {var encmeth=GetTid.value} else {var encmeth=''}; 
	if (Code!=""){
		var returnvalue=cspRunServerMethod(encmeth,Code);
		if (returnvalue!="0"){alert("Code无效!");return false;}
		document.getElementById('ID').value=returnvalue;
	}
   }
   if (document.getElementById('ID').value=="") {alert("未选择行");return; }*/
   var rtn=CheckNull();
    if (!rtn){
	    return false;
    }
 
//构造服务端解析对象
//var ParseInfo="TransContent^ID^RNAVCode^RNAVDateFrom^RNAVDateTo^RNAVDesc^RNAVType";
var ParseInfo="TransContent^ID^RNAVCode^RNAVDateFrom^RNAVDateTo^RNAVDesc";
var RBCReasonNotAvail=DHCDOM_GetEntityClassInfoToXML(ParseInfo);


//调用服务端方法
var BtnUpdateclass=document.getElementById('BtnUpdateClass');
if (BtnUpdateclass) {var encmeth=BtnUpdateclass.value} else {var encmeth=''};
var returnvalue=cspRunServerMethod(encmeth,RBCReasonNotAvail);

  if(returnvalue!='-100')
  {
	alert(t['6']);
  }
  else
  {
	alert(t['7']);
  }

  ClearFormInfo();
  BtnUpdate_click();

 }
 function ClearFormInfo() {
 	DHCC_SetElementData("ID","");
 }

var SelectedRow = 0;
function SelectRowHandler()
{	
	var eSrc=window.event.srcElement;
	var objtbl=document.getElementById('tDHCRBCReasonNotAvail');
	if(!objtbl)
	{
	   objtbl=document.getElementById('tDHCRBCReasonNotAvail0');
	}
	var rows=objtbl.rows.length;	
	var lastrowindex=rows - 1;	
	var rowObj=getRow(eSrc);	
	var selectrow=rowObj.rowIndex;
	
	if (!selectrow) return;
	
    var ID=document.getElementById('ID');

    var RNAVCode=document.getElementById('RNAVCode');

    var RNAVDateFrom=document.getElementById('RNAVDateFrom');

    var RNAVDateTo=document.getElementById('RNAVDateTo');

    var RNAVDesc=document.getElementById('RNAVDesc');

    //var RNAVType=document.getElementById('RNAVType');

	
	
    var Sel_TID=document.getElementById('TIDz'+selectrow);

    var Sel_TRNAVCode=document.getElementById('TRNAVCodez'+selectrow);

    var Sel_TRNAVDateFrom=document.getElementById('TRNAVDateFromz'+selectrow);

    var Sel_TRNAVDateTo=document.getElementById('TRNAVDateToz'+selectrow);

    var Sel_TRNAVDesc=document.getElementById('TRNAVDescz'+selectrow);

    //var Sel_TRNAVType=document.getElementById('TRNAVTypez'+selectrow);


    if (rowObj.className != 'clsRowSelected')
    {
		
        ID.value = '';

        RNAVCode.value = '';

        RNAVDateFrom.value = '';

        RNAVDateTo.value = '';

        RNAVDesc.value = '';

        //RNAVType.value = '';

    }
    else
    {
		
        ID.value = Sel_TID.value;

        RNAVCode.value = Sel_TRNAVCode.innerText;

        RNAVDateFrom.value = Sel_TRNAVDateFrom.innerText;

        RNAVDateTo.value = Sel_TRNAVDateTo.innerText;
        if (RNAVDateTo.value==" ")RNAVDateTo.value="";

        RNAVDesc.value = Sel_TRNAVDesc.innerText;
        /*if (Sel_TRNAVType.innerText=='F' ||Sel_TRNAVType.innerText=='S')
        {
        	RNAVType.value =Sel_TRNAVType.innerText;
        }
        else
        {
               RNAVType.value ='' ;
        } */		
     }
     SelectedRow = selectrow;

}

//验证必填字段
function CheckNull(){
	

if (document.getElementById('RNAVCode').value=="")
{
	alert(t['2']);
	return false;
}	

if (document.getElementById('RNAVDesc').value=="")
{
	alert(t['3']);
	return false;
}

if (document.getElementById('RNAVDateFrom').value=="")
{
	alert(t['11']);
	return false;
}

	return true;
}
function enternextfocus()
{
	var eSrc=window.event.srcElement;	
	var key=websys_getKey(e);
	if (key==13) {
		websys_nexttab(eSrc.tabIndex);
	}
}

function ComboEpisodeTypeselectHandle(e){
	DHCC_Nextfoucs();
}
