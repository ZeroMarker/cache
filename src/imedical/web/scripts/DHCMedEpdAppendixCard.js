var rows
var Active
function BodyLoadHandler() {
	Active=gGetObjValue("Active");
    var obj=document.getElementById("Update");
	if (obj){ 
	    obj.onclick=Update_click;
	    if (Active!="1") gHiddenElement("Update");
	    }
	}
function Update_click() {
	SelectRowHandler();
	var TempSubString="";
	for (i=1;i<rows;i++){
	    TempSubString=TempSubString+GetDataByRow(i)+CHR_1;
	}
	var encmeth=gGetObjValue("txtUpdate");
	var ret="";
	if (encmeth!=""){
		ret=cspRunServerMethod(encmeth,TempSubString);
	}
	if (ret="0"){
		alert(t['UpdateSuccess']);
		window.close();
		//var Parref=gGetObjValue("MepdRowid");
		//var lnk="websys.default.csp?WEBSYS.TCOMPONENT=DHCMedEpdAppendixCard" + "&MepdRowid=" + Parref+ "&Active=" + Active;
		//location.href=lnk;
	}else{
		alert(t['01']+ret);
	}

}
function GetDataByRow(RowIndex)	{
	var eleName
	var Parref=gGetObjValue("MepdRowid");
	eleName='ChildSubz'+RowIndex;
	var ChildSub=gGetObjValue(eleName);
	eleName='DicRowidz'+RowIndex;
	var DicRowid=gGetObjValue(eleName);
	eleName='DataTypez'+RowIndex;
	var DataType=gGetObjValue(eleName);
	var Val=""
	eleName='EpdApp_'+RowIndex;
	switch (DataType) {		
            case  "3":{	
               Val=gGetObjValue(eleName);
		       break;
	            }	
            case  "4":{
	            Val=gGetListData(eleName);
	            //alert(eleName+"   / "+Val);
		       break;
	            }
            case  "5":{
	            Val=gGetListData(eleName);
	            //alert(eleName+"   / "+Val);
		       break;
	            }
            default:{	
               Val=gGetObjValue(eleName);
		       break;
	            }
		}
	var s=Parref+"^^"+ChildSub+"^"+DicRowid+"^"+Val;
	return s;
	}

function SelectRowHandler()	{
	var eSrc=window.event.srcElement;
	var objtbl=document.getElementById('tDHCMedEpdAppendixCard');
	rows=objtbl.rows.length;
	/*
	var lastrowindex=rows - 1;
	
	var rowObj=getRow(eSrc);
	var selectrow=rowObj.rowIndex;
     
    //alert(selectrow+"/"+rows)
    
	if (!selectrow) return;
	if (iSeldRow==selectrow){
		iSeldRow=0
		ssConId="";
		ssInsuId="";
		ssInsuCode="";
		ssInsuDesc="";
		return;
		}
	iSeldRow=selectrow;
	var SelRowObj
	var obj
	
	SelRowObj=document.getElementById('ConIdz'+selectrow);	
	if (SelRowObj){ssConId=SelRowObj.value}
	else{ssConId=""}
	
	SelRowObj=document.getElementById('TInsuIdz'+selectrow);	
	if (SelRowObj){ssInsuId=SelRowObj.value}
	else{ssInsuId=""}
	
	SelRowObj=document.getElementById('InsuCodez'+selectrow);	
	if (SelRowObj){ssInsuCode=SelRowObj.innerText}
	else{ssInsuCode=""}	
	
	SelRowObj=document.getElementById('InsuDescz'+selectrow);		
	if (SelRowObj){ssInsuDesc=SelRowObj.innerText}
	else{ssInsuDesc=""}
	*/
}
function popup(test)
{
	var xx=event.clientX;
	var yy=event.clientY;
	test.value=window.showModalDialog("../scripts/DHC.Med.Clinic.SelectDate.htm","","dialogWidth:350px;dialogHeight:180px;dialogLeft:"+xx+"px;dialogTop:"+yy+"px;status:0;");
}
document.body.onload = BodyLoadHandler;