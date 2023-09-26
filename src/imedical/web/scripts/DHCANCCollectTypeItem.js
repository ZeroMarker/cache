var SelectedRow = 0,preRowInd=0,MDIRowid="",ANCCTIParrefid="",ANCCTIComOrdDrID="",RowId;
var ancvcCodeold=0;
function BodyLoadHandler(){
	var obj=document.getElementById('MDIRowid')
	MDIRowid=obj.value;
	var obj=document.getElementById('ADD')
	if(obj) obj.onclick=ADD_click;
	var obj=document.getElementById('UPDATE')
	if(obj) obj.onclick=UPDATE_click;
	var obj=document.getElementById('DELETE')
	if(obj) obj.onclick=DELETE_click;
	var obj=document.getElementById('DelAppFlag')
	if(obj) obj.onclick=DelAppFlag_click;

}
function SelectRowHandler(){
	var eSrc=window.event.srcElement;
	var objtbl=document.getElementById('tDHCANCCollectTypeItem');
	var rows=objtbl.rows.length;
	var lastrowindex=rows - 1;
	var rowObj=getRow(eSrc);
	var selectrow=rowObj.rowIndex;
	if (!selectrow) return;
	var obj=document.getElementById('Code');
	var obj1=document.getElementById('ANCCTActive');
    var obj2=document.getElementById('ANCCTIChannelNo');
	var obj3=document.getElementById('ANCCTIComOrdDr');
	var obj5=document.getElementById('rowid');
		
	var SelRowObj=document.getElementById('tCodez'+selectrow);
	var SelRowObj1=document.getElementById('tANCCTActivez'+selectrow);
	var SelRowObj2=document.getElementById('tANCCTIChannelNoz'+selectrow);
	var SelRowObj3=document.getElementById('tANCCTIComOrdDrz'+selectrow);	
	var SelRowObj4=document.getElementById('tANCCTIComOrdDrDescz'+selectrow);
	var SelRowObj5=document.getElementById('rowidz'+selectrow);
    if (preRowInd==selectrow){
	   obj.value=""; 
       obj1.value="";
       obj2.value="";
       obj3.value="";
       obj5.value="";
    }
   else{
	   	obj.value=SelRowObj.innerText;
		obj1.value=(SelRowObj1.innerText=="Y")?"是":"否";
		obj2.value=SelRowObj2.innerText;
		//obj3.value=SelRowObj3.innerText;
		ANCCTIComOrdDrID=SelRowObj3.innerText;
		obj3.value=SelRowObj4.innerText;
		obj5.value=SelRowObj5.innerText;
		RowId=SelRowObj5.innerText
		preRowInd=selectrow;
   }
    ancvcCodeold=SelRowObj1.innerText;
	SelectedRow=selectrow;
	return;
	}
function ADD_click(){
	var Code,ANCCTIChannelNo,ANCCTActive,ANCCTIParref,ANCCTIComOrdDr;
	var obj=document.getElementById('Code')
	if(obj) Code=obj.value;
	if(Code==""){
		alert("代码不能为空!");
		return;
		}
	var obj1=document.getElementById('ANCCTIChannelNo')
	if(obj1)  ANCCTIChannelNo=obj1.value;
	if(ANCCTIChannelNo==""){
		alert("通道号不能为空！");
		return;
		}
    var obj2=document.getElementById('ANCCTActive');
    if(obj2)
    { 
  		 ANCCTActive=(obj2.value=="是")?"Y":"N";
    }
	ANCCTIParref =document.getElementById('MDIRowid').value;
	var obj4=document.getElementById('ANCCTIComOrdDr'); 
	if(obj4)
	{
		ANCCTIComOrdDr =ANCCTIComOrdDrID;	  
	}	    
	var obj=document.getElementById('inserDHCANCCollectTypeitem')
	if(obj) {
		var encmeth=obj.value;
	    var resStr=cspRunServerMethod(encmeth,Code,ANCCTIChannelNo,ANCCTActive,ANCCTIParref,ANCCTIComOrdDr)
	    if (resStr!='0'){
		    if (resStr=='-119'){alert("代码重复,添加失败!");return;}
			alert(t['alert:baulk']);
			return;
			}	
		else  {
			alert(t['alert:success']);
		location.href="websys.default.csp?WEBSYS.TCOMPONENT=DHCANCCollectTypeItem&MDIRowid="+ANCCTIParref;
		}
	}
}
function UPDATE_click(){
    var Code,ANCCTIChannelNo,ANCCTActive,ANCCTIParref,ANCCTIComOrdDr;
	var obj=document.getElementById('Code')
	if(obj) Code=obj.value;
	if(Code==""){
		alert("未选中一行或者代码为空");
		return;
		}
	var obj1=document.getElementById('ANCCTIChannelNo')
	if(obj1)  ANCCTIChannelNo=obj1.value;
	if(ANCCTIChannelNo==""){
		alert(t['alert:ancvcdescFill']) 
		return;
		}
    var obj2=document.getElementById('ANCCTActive');
    if(obj2)
    { 
  		 ANCCTActive=(obj2.value=="是")?"Y":"N";
    }
	ANCCTIParref =document.getElementById('MDIRowid').value;
	var obj4=document.getElementById('ANCCTIComOrdDr'); 
	if(obj4)
	{
		ANCCTIComOrdDr =ANCCTIComOrdDrID;	  
	}	    
	var obj=document.getElementById('UPDATEDHCANCCollectTypeitem')
	if(obj) {
		var encmeth=obj.value;
	    var resStr=cspRunServerMethod(encmeth,RowId,Code,ANCCTIChannelNo,ANCCTActive,ANCCTIParref,ANCCTIComOrdDr)
	    if (resStr!='0'){
			alert(t['alert:baulk']);
			return;
			}	
		else  {
		//	alert("操作成功！");
		//location.href="websys.default.csp?WEBSYS.TCOMPONENT=DHCANCCollectTypeItem&MDIRowid="+ANCCTIParref;
		}
	}
}
function DELETE_click(){
	if (preRowInd<1) return;
	var Rowid,IcuApply;
	var obj=document.getElementById('Rowid')
	if(obj) Rowid=obj.value;
	if(Rowid==""){
		alert(t['alert:Please Select One']) 
		return;
		}
	var obj=document.getElementById('DeleteDHCANCCollectTypeitem')
	if(obj) var encmeth=obj.value;
	var resStr=cspRunServerMethod(encmeth,Rowid)
	if (resStr!='0')
		{alert("操作失败！");
		return;}	
	else {alert("操作成功!")
	  location.href="websys.default.csp?WEBSYS.TCOMPONENT=DHCANCCollectTypeItem&MDIRowid="+MDIRowid;
	}
}

function GetDHCANCCollectType(str)
{
	var anmth=str.split("^");
	var obj=document.getElementById('ANCCTIParref')
	ANCCTIParrefid=anmth[1]
	obj.value=anmth[2];
}

function getitemANCCTActive(str)
{
	
	var anmth=str.split("^");
	var obj=document.getElementById('ANCCTActive')
	obj.value=anmth[1];
}

function LookUpMoniDataItem(str){
	var temp
 	temp=str.split("^")
 	ANCCTIComOrdDrID=temp[1]
 	document.getElementById('MDIRowid').value=MDIRowid

	}		
document.body.onload = BodyLoadHandler;