var SelectedRow = 0;
//var MDIDescold=0;
var preRowInd=0;
function BodyLoadHandler(){
	var obj=document.getElementById('ADD')
	if(obj) obj.onclick=ADD_click;
	var obj=document.getElementById('UPDATE')
	if(obj) obj.onclick=UPDATE_click;
	var obj=document.getElementById('DELETE')
	if(obj) obj.onclick=DELETE_click;
	var obj=document.getElementById("IneffectLocO");
    if (obj) {obj.ondblclick=IneffectLocO_Dublclick}
    var obj=document.getElementById('btnSearch')
	if(obj) obj.onclick=btnSearch_click;
}
function SelectRowHandler(){
	var eSrc=window.event.srcElement;
	var objtbl=document.getElementById('tDHCOEInstrAttachOrd');
	var rows=objtbl.rows.length;
	var lastrowindex=rows - 1;
	var rowObj=getRow(eSrc);
	var selectrow=rowObj.rowIndex;
	if (!selectrow) return;
	var InattId=document.getElementById('InattId');
	var arcimdesc=document.getElementById('arcimdesc');
    var phcindesc=document.getElementById('phcindesc');
	var phcfrdesc=document.getElementById('phcfrdesc');
	var type=document.getElementById('type');
	var ordqty=document.getElementById('ordqty');
	var phcinId=document.getElementById('phcinId');
	var phcfrId=document.getElementById('phcfrId');
	var arcimId=document.getElementById('arcimId');
	var NDefault=document.getElementById('NINATTDefault');
	//lhw20100330
	var NDefaultId=document.getElementById('NDefaultId');
	var obj1=document.getElementById("IneffectLocO");
	var ExecLoc=document.getElementById('ExecLoc');
	var ExecLocId=document.getElementById('ExecLocId');	
		
	var SelRowInattId=document.getElementById('tInattIdz'+selectrow);
	var SelRowArcimdesc=document.getElementById('tArcimdescz'+selectrow);
	var SelRowPhcindesc=document.getElementById('tPhcindescz'+selectrow);
	var SelRowPhcfrdesc=document.getElementById('tPhcfrdescz'+selectrow);
	var SelRowType=document.getElementById('tTypez'+selectrow);
	var SelRowOrdqty=document.getElementById('tOrdqtyz'+selectrow);
    var SelRowPhcinId=document.getElementById('tPhcinIdz'+selectrow);
	var SelRowPhcfrId=document.getElementById('tPhcfrIdz'+selectrow);
	var SelRowArcimId=document.getElementById('tArcimIdz'+selectrow);
	//lhw20100330

	var SelRowDefault=document.getElementById('INATTDefaultz'+selectrow);
    var SelRowDefaultId=document.getElementById('DefaultIdz'+selectrow);
 	var SelRowExecLoc=document.getElementById('tExecLocz'+selectrow);
    var SelRowtExecLocId=document.getElementById('tExecLocIdz'+selectrow);
    DHCC_ClearAllList(obj1);
	if (preRowInd==selectrow){
	    InattId.value="";
		arcimdesc.value="";
		phcindesc.value="";
		phcfrdesc.value="";
		type.value="";
		ordqty.value="";
		phcinId.value="";
		phcfrId.value="";
		arcimId.value="";
		NDefault.value="";
	    NDefaultId.value="";
	    ExecLoc.value="";
	    ExecLocId.value="";
   		preRowInd=0;
    }
   	else{ 
	    InattId.value=SelRowInattId.innerText;
		arcimdesc.value=SelRowArcimdesc.innerText;
		phcindesc.value=SelRowPhcindesc.innerText;
		phcfrdesc.value=SelRowPhcfrdesc.innerText;
		type.value=SelRowType.innerText;
		ordqty.value=SelRowOrdqty.innerText;
		phcinId.value=SelRowPhcinId.innerText;
		phcfrId.value=SelRowPhcfrId.innerText;
		arcimId.value=SelRowArcimId.innerText;
		NDefault.value=SelRowDefault.innerText;
	    NDefaultId.value=SelRowDefaultId.innerText;
		var encmeth=document.getElementById("GetlocDet").value;
	    Flag=cspRunServerMethod(encmeth,SelRowInattId.innerText);
	    ExecLoc.value=SelRowExecLoc.innerText;
	    ExecLocId.value=SelRowtExecLocId.innerText;
		SelectedRow=selectrow;
		preRowInd=selectrow;	
		return;
   	}
}
function ADD_click(){
	var arcimdesc,phcindesc,arcimId,phcfrdesc,ordqty,type,phcinId,phcfrId,Rerencmeth,ExecLocId="";
	var obj=document.getElementById('arcimdesc')
	if(obj)  arcimdesc=obj.value;
	if(arcimdesc==""){
		alert(t['alert:ARCIMDescFill']) 
		return;
		}
    var obj=document.getElementById('phcindesc')
	if(obj) phcindesc=obj.value;
	if(phcindesc==""){
		alert(t['alert:PHCInstrucDescFill']) 
		return;
		}
	
    var obj2=document.getElementById('phcfrdesc');
    if(obj2) phcfrdesc=obj2.value;
	var obj3=document.getElementById('ordqty');
	if(obj3) ordqty=obj3.value;
	var tmpOrdQty=+ordqty;
	if (tmpOrdQty!=ordqty) {
		alert(t["alert:input ordqty Nurmber"]);
		return;
	}
    var obj4=document.getElementById('type');
    if(obj4) type=obj4.value; 
    var obj5=document.getElementById('phcinId');
    if(obj5) phcinId=obj5.value; 
    var obj6=document.getElementById('phcfrId');
    if(obj6) phcfrId=obj6.value;
    var objPhcfrdesc=document.getElementById('phcfrdesc');
    if (objPhcfrdesc.value=="") phcfrId=""
    var obj7=document.getElementById('arcimId');//NINATTDefaultId
    if(obj7) arcimId=obj7.value;
    
    var obj8=document.getElementById('NDefaultId');
    if(obj8)var NINATTDefaultId=obj8.value;
    var obj=document.getElementById('RepOEARCIM')
	if(obj) Rerencmeth=obj.value;
    ARCIMDescflag=cspRunServerMethod(Rerencmeth,arcimdesc,arcimId)
    if(ARCIMDescflag=="Y"){
		//alert(t['alert:OEARCIMrepeat'])
		//return;
		}
	var IneffectLocO=getListData("IneffectLocO");
	var obj9=document.getElementById('ExecLocId');
    if(obj9) ExecLocId=obj9.value;
  	var obj10=document.getElementById('ExecLoc');
    if ((obj10)&&((obj10.value=="")||(obj10.value==" "))) ExecLocId=""; 
	var obj=document.getElementById('InsertOEInstr')
	if(obj) {
		var encmeth=obj.value;
	    var resStr=cspRunServerMethod(encmeth,phcinId,phcfrId,arcimId,ordqty,type,NINATTDefaultId,IneffectLocO,ExecLocId)
	    if (resStr!='0'){
			alert(resStr);
			return;
			}	
		else  {alert(t['alert:success']);
		//location.href="websys.default.csp?WEBSYS.TCOMPONENT=DHCOEInstrAttachOrd";
	   	btnSearch_click();
	   }
		}
	
}
function UPDATE_click(){
	var InattId,arcimdesc,phcindesc,arcimId,phcfrdesc,ordqty,type,phcinId,phcfrId,Rerencmeth,ExecLocId;
	var obj=document.getElementById('InattId')
	if(obj) InattId=obj.value;
	if(InattId==""){
		alert(t['alert:Please Select One']) 
		return;
		}
	var obj=document.getElementById('arcimdesc')
	if(obj)  arcimdesc=obj.value;
	if(arcimdesc==""){
		alert(t['alert:ARCIMDescFill']) 
		return;
		}
    var obj=document.getElementById('phcindesc')
	if(obj) phcindesc=obj.value;
	if(phcindesc==""){
		alert(t['alert:PHCInstrucDescFill']) 
		return;
		}
	//var obj=document.getElementById('RepOEARCIM')
	//if(obj) Rerencmeth=obj.value;
    //ARCIMDescflag=cspRunServerMethod(Rerencmeth,arcimdesc)
    //if(ARCIMDescflag=="Y"){
	//	alert(t['alert:OEARCIMrepeat'])
	//	}
	
    var obj2=document.getElementById('phcindesc');
    if(obj2) phcindesc=obj2.value;
	var obj3=document.getElementById('ordqty');
    if(obj3) ordqty=obj3.value;
    if(ordqty==""){
		alert(t['ordqty']+'不能为空'); 
		return;
	}
    var tmpOrdQty=+ordqty;
	if (tmpOrdQty!=ordqty) alert(t["alert:input ordqty Nurmber"])
    var obj4=document.getElementById('type');
    if(obj4) type=obj4.value; 
    if(type==""){
		alert(t['type']+'不能为空'); 
		return;
		}
    var obj5=document.getElementById('phcinId');
    if(obj5) phcinId=obj5.value; 
    var obj6=document.getElementById('phcfrId');
    if(obj6) phcfrId=obj6.value;
    if(phcfrId==" ") phcfrId="";
    var objPhcfrdesc=document.getElementById('phcfrdesc');
    if (objPhcfrdesc.value=="") phcfrId=""
    var obj7=document.getElementById('arcimId');
    if(obj7) arcimId=obj7.value;
    var obj=document.getElementById('NDefaultId');
    if(obj) var NDefaultId=obj.value;
	var IneffectLocO=getListData("IneffectLocO");
	var obj9=document.getElementById('ExecLocId');
    if(obj9) ExecLocId=obj9.value;
  	var obj10=document.getElementById('ExecLoc');
    if ((obj10)&&((obj10.value=="")||(obj10.value==" "))) ExecLocId="";  
  	var obj=document.getElementById('UpdateOEInstr')
	if(obj) {
		var encmeth=obj.value;
		//alert(InattId+"@"+phcinId+"@"+phcfrId+"@"+arcimId+"@"+ordqty+"@"+type+"@"+NDefaultId+"@"+IneffectLocO+"@"+ExecLocId)
	    var resStr=cspRunServerMethod(encmeth,InattId,phcinId,phcfrId,arcimId,ordqty,type,NDefaultId,IneffectLocO,ExecLocId)
	    if (resStr!='0'){
		    alert(resStr)
			alert(t['alert:error']);
			return;
			}	
		else  {alert(t['alert:success']);
		//location.href="websys.default.csp?WEBSYS.TCOMPONENT=DHCOEInstrAttachOrd";
	    btnSearch_click();
	   }
		}
	
}
function DELETE_click(){
	var InattId
	var obj=document.getElementById('InattId')
	if(obj) InattId=obj.value;
	if(InattId==""){
		alert(t['alert:Please Select One']) 
		return;
		}
	var obj=document.getElementById('DeleteOEInst')
	if(obj) var encmeth=obj.value;
	var resStr=cspRunServerMethod(encmeth,InattId)
	if (resStr!='0')
		{alert(t['alert:error']);
		return;
		}	
	else 
	   {alert(t['alert:success']);
	   //location.href="websys.default.csp?WEBSYS.TCOMPONENT=DHCOEInstrAttachOrd";
       btnSearch_click();
       }
}
function LookUpMasterItem(value){
var temp
 temp=value.split("^")
 arcimId=temp[1]
 document.getElementById('arcimId').value=arcimId
}
function LookUpInstruc(value){
var temp
 temp=value.split("^")
 phcinId=temp[1]
 document.getElementById('phcinId').value=phcinId
}
function LookUpFreq(value){
var temp
 temp=value.split("^")
 phcfrId=temp[1]
 document.getElementById('phcfrId').value=phcfrId
}
//lhw20100330
function LookUpDefault(value){
var temp
 temp=value.split("^")
 NINATTDefaultId=temp[1]
 document.getElementById('NDefaultId').value=NINATTDefaultId
}
/////////////////////////////////////
function getIneffectLoc(str)
{
	var strValue=str.split("^");
	var obj=document.getElementById("IneffectLoc");
	if(obj){
		addListRow("IneffectLocO",strValue);
		obj.value=""
	}
}
function addListRow(elementName,dataValue)
{
	var itemValue=dataValue;  //dataValue.split("^");
    var objSelected = new Option(itemValue[0], itemValue[1]);
	var listObj=document.getElementById(elementName);
	listObj.options[listObj.options.length]=objSelected;
}
function IneffectLocO_Dublclick()
{
	list_Dublclick("IneffectLocO");
}
function list_Dublclick(elementName)
{
  var listObj=document.getElementById(elementName);
  var objSelected=listObj.selectedIndex;
  listObj.remove(objSelected) ;
}

function DHCC_ClearAllList(obj) {
	if (obj) {
		if (obj.options.length>0) {
			for (var i=obj.options.length-1; i>=0; i--) obj.options[i] = null;
		}
	}
}
function getListData(elementName)
{
	var retString
	retString=""
	var listObj=document.getElementById(elementName);
	if(listObj){
	for (var i=0;i<listObj.options.length;i++)
   	{
	   if (listObj.options[i].value!="")
	   {
		   if(retString==""){
			   retString=listObj.options[i].value
		   }else{
			   retString=retString+"^"+listObj.options[i].value
		   }
	   }
	}
	}
	return retString
}
function InitList(elementName,dataValue)
{
	var listData=dataValue.split("^");
	var listObj=document.getElementById(elementName);
	if(listObj){
		var listLen=listObj.options.length
		for(var i=0;i<listLen;i++)
		{
			listObj.remove(0)
		}
		for (var i=0;i<listData.length;i++)
	   	{
		   if (listData[i]!="")
		   {
			    var listRowItem=listData[i].split("!");
				var sel=new Option(listRowItem[0],listRowItem[1]);
				listObj.options[listObj.options.length]=sel;
		   }
		}
	}
}
function GetExecLocId(value){
	var temp;
	temp=value.split("^");
	var ExecLocId=document.getElementById('ExecLocId');
	if (ExecLocId) ExecLocId.value=temp[1];
	var objExecLoc=document.getElementById('ExecLoc');
	if (objExecLoc) objExecLoc.value=temp[0];
}
function btnSearch_click() {
	var ExecLocId="";
	var objExecLocId=document.getElementById('ExecLocId');
    if(objExecLocId) ExecLocId=objExecLocId.value;
  	var objExecLoc=document.getElementById('ExecLoc');
    if ((objExecLoc)&&((objExecLoc.value=="")||(objExecLoc.value==" "))){
	     ExecLocId="";
    }
	window.location.href="websys.default.csp?WEBSYS.TCOMPONENT=DHCOEInstrAttachOrd"+"&ExecLocId="+ExecLocId+"&ExecLoc="+objExecLoc.value;
}
document.body.onload = BodyLoadHandler;