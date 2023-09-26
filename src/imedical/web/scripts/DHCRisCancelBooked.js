//DHCRisCancelBooked

function BodyLoadHandler()
{
	//get booked Info
	var paadmdr=document.getElementById("EpisodeID").value;
	var GetPatInfoFun=document.getElementById("GetPatientInfo").value;
	var PatInfo=cspRunServerMethod(GetPatInfoFun,paadmdr)
	if (PatInfo!="")
	{
		var infoitem=PatInfo.split("^");
		//patname_"^"_Sex_"^"_NO_"^"_$g(DOB)
		var name=document.getElementById("Name");
		name.value=infoitem[0];
		
		var Sex=document.getElementById("Sex");
		Sex.value=infoitem[1];
		
		document.getElementById("PatientID").value=infoitem[2];
		
		var DOB=document.getElementById("DOB");
		DOB.value=infoitem[3];
	}
	
	
	var OEOrdItemID=document.getElementById("OEOrdItemID").value;
	//var GetItemFun=document.getElementById("GetItemName").value;
	//var ItemNameInfo=cspRunServerMethod(GetItemFun,OEOrdItemID);
	//alert(OEOrdItemID);
	var orderItemDesc=tkMakeServerCall("web.DHCRisCommFunctionEx","getOrderItemDesc",OEOrdItemID);
	//alert(orderItemDesc);
	if (orderItemDesc!="")
	{
		var ItemName=document.getElementById("ItemName");
		ItemName.value=orderItemDesc;
	}
	
	
	//var GetBookedInfo=document.getElementById("GetBookInfo").value;
	//var bookedInfo=cspRunServerMethod(GetBookedInfo,OEOrdItemID);
	//var bookedInfo=cspRunServerMethod(GetBookedInfo,OEOrdItemID);
	var bookedInfo=tkMakeServerCall("web.DHCRisResourceApptSchudle","getBookDetailInfoFromlist",OEOrdItemID);
	if  (bookedInfo!="")
	{
		//approwid_"^"_resrowid_"^"_CareDesc_"^"_AppointDate_"^"_AppointstTime_"^"_AppointedTime
		var item=bookedInfo.split("^");
		var ResourceName=document.getElementById("ResourceName");
		ResourceName.value=item[1];
		
		var BookedDate=document.getElementById("BookedDate");
		BookedDate.value=item[2];
		
		var StTime=document.getElementById("StTime");
		StTime.value=item[3];
	}
	
	
	var obj=document.getElementById("CancelBooked");
	if (obj)
	{
		obj.onclick=CancelBookingclick1;
	}
	
	var ExitObj=document.getElementById("Exit");
	if (ExitObj)
	{
		ExitObj.onclick=closeWindow;
	}	
	
}

function CancelBookingclick1()
{
	var OEOrdItemID=document.getElementById("OEOrdItemID").value;
	//var GetCancelFunction=document.getElementById("GetCancelFunction").value;
	//alert("aa");
	//var ret=cspRunServerMethod(GetCancelFunction,OEOrdItemID);
	//var CancelBookInfo=OEOrdItemID+"^"+"2"+"^1^^"+"3"+"^"+""+"^^"+session['LOGON.USERID']+"^^^"+""+"^"+"";
	//alert(CancelBookInfo);
	var ret=tkMakeServerCall("web.DHCRisResourceApptSchudle","CancelBook",OEOrdItemID,session['LOGON.USERID']);
	//session['LOGON.USERID']
	var ret1=ret.split("^")[0];
	/*
	var ret2=ret.split("^")[1]  //消息平台调用返回值
	
	if(ret2!="0")
	{
	    var ErrorInfo="调用平台消息失败="+ret2
		alert(ErrorInfo);
    }
    */
	if (ret1=="0")
	{
		alert(t['CancelSuccess']);
		opener.document.getElementById("btnFind").click();
		closeWindow();
		
	}
	else
	{
		alert(t['CanelFailure']+"SQLCODE="+ret);
	}
	
	var ExitObj=document.getElementById("Exit");
	if (ExitObj)
	{
		ExitObj.click();
	}	
}
function closeWindow() 
{ 
     window.opener=null; 
     window.open('', '_self', ''); 
     window.close(); 
} 
document.body.onload = BodyLoadHandler;


