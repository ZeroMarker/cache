var SelectedRow,preRowInd=0;
var MDIDescold=0;
function BodyLoadHandler(){
	var obj=document.getElementById('ADD')
	if(obj) obj.onclick=ADD_click;
	var obj=document.getElementById('UPDATE')
	if(obj) obj.onclick=UPDATE_click;
	var obj=document.getElementById('DELETE')
	if(obj) obj.onclick=DELETE_click;
}
function SelectRowHandler(){
	var eSrc=window.event.srcElement;
	var objtbl=document.getElementById('tDHCICUBedEquipDetail');
	var rows=objtbl.rows.length;
	var lastrowindex=rows - 1;
	var rowObj=getRow(eSrc);
	var selectrow=rowObj.rowIndex;
	if (!selectrow) return;
	var obj=document.getElementById('Rowid');
	var obj1=document.getElementById('MDIDesc');
    var obj2=document.getElementById('ANREDActive');
	var obj3=document.getElementById('ChannelNo');
	var obj4=document.getElementById('MDIRowid');
	var obj5=document.getElementById('EquipRowid');
	var obj6=document.getElementById('BedEquipDesc');
	var obj7=document.getElementById('BedEquipRowid');
	var SelRowObj=document.getElementById('TRowidz'+selectrow);
	var SelRowObj1=document.getElementById('TMDIDescz'+selectrow);
	var SelRowObj2=document.getElementById('TANREDActivez'+selectrow);
	var SelRowObj3=document.getElementById('TChannelNoz'+selectrow);
	var SelRowObj4=document.getElementById('TMDIRowidz'+selectrow);
	var SelRowObj5=document.getElementById('TEquipRowidz'+selectrow);
    var SelRowObj6=document.getElementById('TBedEquipDescz'+selectrow);
	var SelRowObj7=document.getElementById('TBedEquipRowidz'+selectrow);
    if (preRowInd==selectrow){
    obj.value="";
    obj1.value="";
    obj2.value="";
    obj3.value="";
    obj4.value="";
    obj5.value="";
    obj6.value="";
    obj7.value="";
    preRowInd=0;
    }
    else {
	obj.value=SelRowObj.innerText;
	obj1.value=SelRowObj1.innerText;
	obj2.value=SelRowObj2.innerText;
	obj3.value=SelRowObj3.innerText;
	obj4.value=SelRowObj4.innerText;
	obj5.value=SelRowObj5.innerText;
	obj6.value=SelRowObj6.innerText;
	obj7.value=SelRowObj7.innerText;
	MDIDescold=SelRowObj1.innerText;
	preRowInd=selectrow;
	return;
	}
	//该程序增加更改删除等采用新方法
}
function ADD_click(){
	var MDIDesc,ANREDActive,ChannelNo,Rerencmeth,BedEquipRowid,RepMoniDataItemDesc
	var obj=document.getElementById('MDIDesc')
	if(obj) MDIDesc=obj.value;
	if(MDIDesc==""){
		alert(t['alert:MDIDescFill']) 
		return;
		}
	var obj=document.getElementById('ANREDActive')
	if(obj)  ANREDActive=obj.value;
	if(ANREDActive==""){
		alert(t['alert:ANREDActiveFill']) 
		return;
		}
	var obj=document.getElementById('ChannelNo')
	if(obj)  ChannelNo=obj.value;
	if(ChannelNo==""){
		alert(t['alert:ChannelNoFill']) 
		return;
		}
	var obj=document.getElementById('BedEquipRowid')
	if(obj)  BedEquipRowid=obj.value;
	var obj=document.getElementById('RepMoniDataItemDesc')
	if(obj) Rerencmeth=obj.value;
    var reflag=cspRunServerMethod(Rerencmeth,BedEquipRowid,MDIDesc)
    if(reflag=="Y"){
		alert(t['alert:MoniDataItemDescrepeat'])
		 return;
		}
    var obj2=document.getElementById('BedEquipRowid');
    if(obj2) RepMoniDataItemDesc=obj2.value;
	var obj3=document.getElementById('MDIRowid');
    if(obj3) MDIRowid=obj3.value; 
	var obj=document.getElementById('InsertMoniDataItem')
	if(obj) {
		var encmeth=obj.value;
	    var resStr=cspRunServerMethod(encmeth,BedEquipRowid,MDIRowid,ANREDActive,ChannelNo);
	    if (resStr!='0'){
			alert(t['alert:error']);
			return;
			}	
		else  {alert(t['alert:success']);
		location.href="websys.default.csp?WEBSYS.TCOMPONENT=DHCICUBedEquipDetail&BedEquipRowid="+RepMoniDataItemDesc;
	   }
		}
	
}
function UPDATE_click(){
	if (preRowInd<1) return;
	var MDIDesc,ANREDActive,ChannelNo,BedEquipRowid,Rerencmeth,MDIRowid,RepMoniDataItemDesc
	var obj=document.getElementById('Rowid')
	if(obj) Rowid=obj.value;
	if(Rowid==""){
		alert(t['alert:Please Select One']) 
		return;
		}
	var obj=document.getElementById('MDIDesc')
	if(obj) MDIDesc=obj.value;
	if(MDIDesc==""){
		alert(t['alert:MDIDescFill']) 
		return;
		}
	var obj=document.getElementById('ANREDActive')
	if(obj) ANREDActive=obj.value;
	if(ANREDActive==""){
		alert(t['alert:ANREDActiveFill']) 
		return;
		}
	var obj=document.getElementById('ChannelNo')
	if(obj)  ChannelNo=obj.value;
	if(ChannelNo==""){
		alert(t['alert:ChannelNoFill']) 
		return;
		}
	if(MDIDescold!=MDIDesc){
	var obj=document.getElementById('BedEquipRowid')
	if(obj)  BedEquipRowid=obj.value;
	var obj=document.getElementById('RepMoniDataItemDesc')
	if(obj) Rerencmeth=obj.value;
    var repflag=cspRunServerMethod(Rerencmeth,BedEquipRowid,MDIDesc)
    if(repflag=="Y"){
		alert(t['alert:MoniDataItemDescrepeat'])
		 return;
		}
	 }
	
    var obj2=document.getElementById('BedEquipRowid');
    if(obj2) BedEquipRowid=obj2.value;
	var obj3=document.getElementById('MDIRowid');
    if(obj3) MDIRowid=obj3.value; 
	var obj=document.getElementById('UpdateMoniDataItem')
	if(obj) 
	{
	  var encmeth=obj.value;
	  var resStr=cspRunServerMethod(encmeth,Rowid,BedEquipRowid,MDIRowid,ANREDActive,ChannelNo);
	  if (resStr!='0')
	  {
	   alert(t['alert:error']);
	   return;
	  }	
	  else  
	  { alert(t['alert:success'])
		location.href="websys.default.csp?WEBSYS.TCOMPONENT=DHCICUBedEquipDetail&BedEquipRowid="+BedEquipRowid
	  }
	}
		
}
function DELETE_click(){
	if (preRowInd<1) return;
	var Rowid,RepMoniDataItemDesc
	var obj=document.getElementById('Rowid')
	if(obj) Rowid=obj.value;
	if(Rowid==""){
		alert(t['alert:Please Select One']) 
		return;
		}
	var obj2=document.getElementById('BedEquipRowid');
    if(obj2) BedEquipRowid=obj2.value;
	var obj=document.getElementById('DeleteMoniDataItem')
	if(obj) var encmeth=obj.value;
	var resStr=cspRunServerMethod(encmeth,Rowid)
	if (resStr!='0')
		{alert(t['alert:error']);
		return;
		}	
	else 
	   {alert(t['alert:success']);
	   location.href="websys.default.csp?WEBSYS.TCOMPONENT=DHCICUBedEquipDetail&BedEquipRowid="+BedEquipRowid
       }
}
function LookUpMoniDataItem(value){
	var temp
 	temp=value.split("^")
 	MDIRowid=temp[1]
 	document.getElementById('MDIRowid').value=MDIRowid
	}
document.body.onload = BodyLoadHandler;