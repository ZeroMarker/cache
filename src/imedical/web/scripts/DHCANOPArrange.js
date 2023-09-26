var obj=""
var value=""	
var SelectedRow = 0,preRowInd=0;
var ancvcCodeold=0;
function BodyLoadHandler()
{
	var opdate=document.getElementById("opdate");
    var today=document.getElementById("getToday").value;
    if (opdate.value=="") {opdate.value=today;}
	//var obj=document.getElementById('btSch')
	//if(obj) obj.onclick=btSch_click;
}
 function SelectRowHandler()
 {
    var eSrc=window.event.srcElement;
	var objtbl=document.getElementById('tDHCANOPArrange');
	var rows=objtbl.rows.length;
	var lastrowindex=rows - 1;
	var rowObj=getRow(eSrc);
	var selectrow=rowObj.rowIndex;

	if (!selectrow) return;
	var obj=document.getElementById('room');
	var obj1=document.getElementById('roomDesc');
    var obj2=document.getElementById('roomId');
	var obj3=document.getElementById('roomFloor');
	var obj4=document.getElementById('opdate');
	var SelRowObj=document.getElementById('troomCodez'+selectrow);
	var SelRowObj1=document.getElementById('troomDescz'+selectrow);
	var SelRowObj2=document.getElementById('troomIdz'+selectrow);
	var SelRowObj3=document.getElementById('troomFloorz'+selectrow);
	var SelRowObj4=document.getElementById('topdatez'+selectrow);
	var stdate=SelRowObj4.innerText;
	var enddate=SelRowObj4.innerText;
	var stat="";
	var oproom=SelRowObj2.innerText;
	var Dept="";
	var typ="";
	var userLocId=session['LOGON.CTLOCID'];
	//var userLocId=42;
	var IsAppT="";
	var MedCareNo="";
	var oprFloorId="";
	var patWardId="";
	var UnPaidOp="";
    /*if (preRowInd==selectrow){
	   obj.value=""; 
       obj1.value="";
       obj2.value="";
       obj3.value="";
       obj4.value="";
   	   preRowInd=0;
    }
    else{*/
	    obj.value=SelRowObj.innerText;
	    obj1.value=SelRowObj1.innerText;
		obj2.value=SelRowObj2.innerText;
		obj3.value=SelRowObj3.innerText;
		obj4.value=SelRowObj4.innerText;
		preRowInd=selectrow;
  // }
    ancvcCodeold=SelRowObj1.innerText;
	SelectedRow=selectrow;

	///var lnk= "websys.default.csp?WEBSYS.TCOMPONENT=DHCANOPArrangeDetail&room="+SelRowObj.innerText+"&OPRoomDate="+SelRowObj4.innerText+"&stat="+stat+"&Dept="+Dept+"&typ="+typ+"&userLocId="+userLocId+"&IsAppT="+IsAppT+"&MedCareNo="+MedCareNo+"&oprFloorId="+oprFloorId+"&patWardId="+patWardId+"&UnPaidOp="+UnPaidOp
	//alert("room="+obj.value);
	//alert("roomDesc="+obj1.value);
	//alert("roomId="+obj2.value);
	//alert("roomFloor="+obj3.value);
	//alert("opdate="+obj4.value);
    var lnk= "websys.default.csp?WEBSYS.TCOMPONENT=DHCANOPArrangeDetail&stdate="+stdate+"&enddate="+enddate+"&stat="+stat+"&oproom="+oproom+"&Dept="+Dept+"&typ="+typ+"&userLocId="+userLocId+"&IsAppT="+IsAppT+"&MedCareNo="+MedCareNo+"&oprFloorId="+oprFloorId+"&patWardId="+patWardId+"&UnPaidOp="+UnPaidOp;
    parent.frames[1].location.href=lnk; 
 }
 function DHCWeb_GetRowIdx(wobj)
{
	try{
		var eSrc=wobj.event.srcElement;
		if (eSrc.tagName=="IMG") eSrc=wobj.event.srcElement.parentElement;
		var rowObj=getRow(eSrc);
		var selectrow=rowObj.rowIndex;
		return 	selectrow
	}catch (e)
	{
		alert(e.toString());
		return -1;
	}
}

function btSch_click(){



}





document.body.onload = BodyLoadHandler;







