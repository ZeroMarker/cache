//By    ljw20081230
//document.write("<object ID='ClsAlert' CLASSID='CLSID:B080649D-D704-49F0-BBC1-B5B7A9A351E2' CODEBASE='../addins/client/OrdAlert.CAB#version=1,0,0,0'>");
//document.write("</object>");
var OrdAlert;//alert new order object
//var Ico;
//OrdAlert= new ActiveXObject("Ico.clsnot");//TestAx.CLSMAIN

var EpisodeID=document.getElementById("EpisodeID").value;
var SelectedRow = 0;
var preRowInd=0;
var UserId=session['LOGON.USERID'];
var CTLoc=session['LOGON.CTLOCID'];
var comb_ViewComOrd;
function BodyLoadHandler(){
	var obj=document.getElementById('AutoInsert')
	if(obj) var encmeth=obj.value;
	var repflag=cspRunServerMethod(encmeth,EpisodeID,"",UserId)
	//alert(repflag)
	var loc=repflag.split("^");
    if (loc[0]!='0')
		{
			alert(t['fall']);
		return;}	
	try {
		var obj=document.getElementById("NCPRowid")
		obj.value=loc[1]
		} catch(e) {};
	
	var obj=document.getElementById('BADD')
	if(obj) obj.onclick=BADD_click;
	var obj=document.getElementById('BUpdate')
	if(obj) obj.onclick=BUpdate_click;
	var obj=document.getElementById('BCopy')
	if(obj) obj.onclick=BCopy_click;
	/*comb_ViewComOrd = dhtmlXComboFromSelect("FindViewCatComOrd");
	comb_ViewComOrd.enableFilteringMode(true);
	comb_ViewComOrd.attachEvent("onChange",function(event){ 
  	var retval=comb_ViewComOrd.getSelectedValue();
  	if(retval==""){var retval="$$$"}
  	var item=retval.split("$");
  	$("FindViewCatId").value=item[0];
  	$("FindViewCat").value=item[1];
  	$("FindComOrdId").value=item[2];
  	$("FindComOrd").value=item[3];

  });
  comb_ViewComOrd.setComboValue($("FindViewCatComOrd").value);*/
}
function SelectRowHandler(){
	var eSrc=window.event.srcElement;
	var objtbl=document.getElementById('tDHCNurCareSet');
	var rows=objtbl.rows.length;
	var lastrowindex=rows - 1;
	var rowObj=getRow(eSrc);
	var selectrow=rowObj.rowIndex;
	if (!selectrow) return;
	var obj=document.getElementById('Rowid');
	var obj1=document.getElementById('FindStatusId');
	var obj2=document.getElementById('FindStatus');
	var obj3=document.getElementById('FindViewCatId');
	var obj4=document.getElementById('FindViewCat');
	var obj5=document.getElementById('FindComOrdId');
	var obj6=document.getElementById('FindComOrd');
	var obj7=document.getElementById('NCPRowid');
	var obj8=document.getElementById('StartDate');
	var obj9=document.getElementById('StartTime');
	var obj10=document.getElementById('EndDate');
	var obj11=document.getElementById('EndTime');
	
	var SelRowObj=document.getElementById('Rowidz'+selectrow);
	var SelRowObj1=document.getElementById('NCPIStatusz'+selectrow);
	var SelRowObj2=document.getElementById('NCPIStatusValz'+selectrow);
	var SelRowObj3=document.getElementById('NCPIViewCatDrz'+selectrow);
	var SelRowObj4=document.getElementById('NCPIViewCatz'+selectrow);
	var SelRowObj5=document.getElementById('NCPICommOrdDrz'+selectrow);
	var SelRowObj6=document.getElementById('NCPICommOrdz'+selectrow);
	var SelRowObj7=document.getElementById('NCPRowidz'+selectrow);
	var SelRowObj8=document.getElementById('NCPIStartDatez'+selectrow);
	var SelRowObj9=document.getElementById('NCPIStartTimez'+selectrow);
	var SelRowObj10=document.getElementById('NCPIEndDatez'+selectrow);
	var SelRowObj11=document.getElementById('NCPIEndTimez'+selectrow);
	
	obj.value="";
	obj1.value="";
	obj2.value="";
	obj3.value="";
	obj4.value="";
	obj5.value="";
	obj6.value="";
	obj7.value="";
	obj8.value="";
	obj9.value="";
	obj10.value="";
	obj11.value="";
	if (preRowInd==selectrow){

   		preRowInd=0;
    }
   else{ obj.value=SelRowObj.innerText;
	 obj1.value=SelRowObj1.innerText;
	obj2.value=SelRowObj2.innerText;
	obj3.value=SelRowObj3.innerText;
	obj4.value=SelRowObj4.innerText;
	obj5.value=SelRowObj5.innerText;
	obj6.value=SelRowObj6.innerText;
	obj7.value=SelRowObj7.innerText;
	obj8.value=SelRowObj8.innerText;
	obj9.value=SelRowObj9.innerText;
	obj10.value=SelRowObj10.innerText;
	obj11.value=SelRowObj11.innerText;
	
	preRowInd=selectrow;
   }
	return;
	}
function BADD_click(){
	var obj=document.getElementById('NCPRowid')
	if(obj) var Rowid=obj.value;
	if(Rowid==""){
		alert(t['01']) 
		return;
		}
	var obj=document.getElementById('FindStatusId')
	if(obj) var StatusId=obj.value;
	if(StatusId==""){
		alert(t['02']) 
		return;
		}
	var obj=document.getElementById('StartDate')
	if(obj) var StartDate=obj.value;
	if(StartDate==""){
		alert(t['03']) 
		return;
		}
	var obj=document.getElementById('StartTime')
	if(obj) var StartTime=obj.value;
	if(StartTime==""){
		alert(t['04']) 
		return;
		}
	var obj=document.getElementById('FindViewCatId')
	if(obj) var ViewCatId=obj.value;
	if(ViewCatId==" "){
		var ViewCatId="";
		}
	var obj=document.getElementById('FindComOrdId')
	if(obj) var ComOrdId=obj.value;
	if(ComOrdId==" "){
		var ComOrdId="";
		}
	var obj=document.getElementById('EndDate')
	if(obj) var EndDate=obj.value;
	if(EndDate==" "){
		var EndDate="";
		}
	var obj=document.getElementById('EndTime')
	if(obj) var EndTime=obj.value;
	if(EndTime==" "){
		var EndTime="";
		}
	var obj=document.getElementById('InsertNurCarePlanDetail')
	if(obj) var encmeth=obj.value;
	//alert(Rowid+"/"+StatusId+"/"+ViewCatId+"/"+ComOrdId+"/"+StartDate+"/"+StartTime+"/"+EndDate+"/"+EndTime+"/"+UserId)
    if (cspRunServerMethod(encmeth,Rowid,StatusId,ViewCatId,ComOrdId,StartDate,StartTime,EndDate,EndTime,UserId)!='0')
		{
			alert(t['baulk']);
		return;}	
	try {
        alert(t['succeed']);
	    window.location.reload();
		} catch(e) {};
	}
function BUpdate_click(){
	if(preRowInd<1)return;
	var obj=document.getElementById('Rowid')
	if(obj) var Rowid=obj.value;
	if(Rowid==""){
		alert(t['01']) 
		return;
		}
	var obj=document.getElementById('FindStatusId')
	if(obj) var StatusId=obj.value;
	if(StatusId==""){
		alert(t['02']) 
		return;
		}
	var obj=document.getElementById('StartDate')
	if(obj) var StartDate=obj.value;
	if(StartDate==""){
		alert(t['03']) 
		return;
		}
	var obj=document.getElementById('StartTime')
	if(obj) var StartTime=obj.value;
	if(StartTime==""){
		alert(t['04']) 
		return;
		}
	var obj=document.getElementById('FindViewCatId')
	if(obj) var ViewCatId=obj.value;
	if(ViewCatId==" "){
		var ViewCatId="";
		}
	var obj=document.getElementById('FindComOrdId')
	if(obj) var ComOrdId=obj.value;
	if(ComOrdId==" "){
		var ComOrdId="";
		}
	var obj=document.getElementById('EndDate')
	if(obj) var EndDate=obj.value;
	if(EndDate==" "){
		var EndDate="";
		}
	var obj=document.getElementById('EndTime')
	if(obj) var EndTime=obj.value;
	if(EndTime==" "){
		var EndTime="";
		}
	var obj=document.getElementById('UpdateNurCarePlanDetail')
	if(obj) var encmeth=obj.value;
	//alert(Rowid+"/"+StatusId+"/"+ViewCatId+"/"+ComOrdId+"/"+StartDate+"/"+StartTime+"/"+EndDate+"/"+EndTime+"/"+UserId)
    if (cspRunServerMethod(encmeth,Rowid,StatusId,ViewCatId,ComOrdId,StartDate,StartTime,EndDate,EndTime,UserId)!='0')
		{
			alert(t['baulk']);
		return;}	
	try {
        alert(t['succeed']);
	    window.location.reload();
		} catch(e) {};
	}
function BCopy_click(){
	if(preRowInd<1)return;
	var obj=document.getElementById('Rowid')
	if(obj) var Rowid=obj.value;
	if(Rowid==""){
		alert(t['04']) 
		return;
		}
	var obj=document.getElementById('CopyNurCarePlanDetail')
	if(obj) var encmeth=obj.value;
	//alert(Rowid+'@'+CTLoc)
	if (cspRunServerMethod(encmeth,Rowid,CTLoc)!='0')
		{alert(t['baulk']);
		return;}	
	try {alert(t['succeed']);
	    window.location.reload();
		} catch(e) {};
	}
	
function getStatus(str)
{
	var loc=str.split("^");
	var obj=document.getElementById("FindStatus")
	obj.value=loc[1];
	var obj=document.getElementById("FindStatusId")
	obj.value=loc[0];
}

function getViewCat(str)
{
	var ViewCat=str.split("^");
	var obj=document.getElementById("FindViewCat")
	obj.value=ViewCat[0];
	var obj=document.getElementById("FindViewCatId")
	obj.value=ViewCat[1];
}
function getComOrd(str)
{
	var ComOrd=str.split("^");
	var obj=document.getElementById("FindComOrd")
	obj.value=ComOrd[0];
	var obj=document.getElementById("FindComOrdId")
	obj.value=ComOrd[1];
}
function getRowid(str)
{
	var Rowid=str.split("^");
	var obj=document.getElementById("FindRowid")
	obj.value=Rowid[1];
	var obj=document.getElementById("Rowid")
	obj.value=Rowid[0];
}
function setWard(val)
{
 var item=val.split("^");
 $("FindViewCat").value=item[2];
 $("wardid").value=item[0];
}
function getFindViewCatComOrd(val)
{
 var item=val.split("^");
 $("FindViewCatComOrd").value=item[1];
 var iteme=item[0].split("$");
  	$("FindViewCatId").value=iteme[0];
  	$("FindViewCat").value=iteme[1];
  	$("FindComOrdId").value=iteme[2];
  	$("FindComOrd").value=iteme[3];
}
function getloc(str)
{
	var loc=str.split("^");
	var obj=document.getElementById("CTLocID")
	obj.value=loc[1];
}
document.body.onload=BodyLoadHandler;
