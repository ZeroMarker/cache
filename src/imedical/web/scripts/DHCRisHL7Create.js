function BodyLoadHandler()
{
	MessageTypeObj=document.getElementById("MessageType");
    if (MessageTypeObj)
    {
	    MessageTypeObj.onchange=OnchangeMessageType;

    	combo("MessageType");
    	var GetMessageTypeListFunction=document.getElementById("MessageTypeList").value;
		var Info=cspRunServerMethod(GetMessageTypeListFunction);
		
    	AddItem("MessageType",Info);

    
       	var SelectInfoObj=document.getElementById("SelectInfo");
       	var SelectInfo;
       	
		if (SelectInfoObj)
		{
			SelectInfo=SelectInfoObj.value;
		}
	    if (SelectInfo!="")
		{
			var item=SelectInfo.split("^");
			MessageTypeObj.selectedIndex=item[1];
			MessageTypeObj.options[MessageTypeObj.selectedIndex].innerText=item[0];
		}
    }
    
    var SendOrdObj=document.getElementById("SendOrd");
	if (SendOrdObj)
	{
		SendOrdObj.onclick=SendOrd_click;
	}
	
    var SendPatModiObj=document.getElementById("PatientNameModi");
	if (SendPatModiObj)
	{
		SendPatModiObj.onclick=SendPatModiObj_click;
	}	
    
       var CancelExecuteObj=document.getElementById("CancelExecute");
	if (CancelExecuteObj)
	{
		CancelExecuteObj.onclick=CancelExecuteObj_click;
	}	
   
    
}
function SendOrd_click()
{
	
	var OrdRowid=document.getElementById("ROWID").value;
	
	MessageTypeObj=document.getElementById("MessageType");
	if (MessageTypeObj)
	{
		var SelectIndex=MessageTypeObj.selectedIndex;
		MessageType=MessageTypeObj.options[SelectIndex].value;
	}
    alert(MessageType);
    var SendOrdFunction=document.getElementById("SendOrdFunction").value;
	var Info=cspRunServerMethod(SendOrdFunction,OrdRowid,MessageType);    		
 
}

function SendPatModiObj_click()
{
	MessageTypeObj=document.getElementById("MessageType");
	if (MessageTypeObj)
	{
		var SelectIndex=MessageTypeObj.selectedIndex;
		MessageType=MessageTypeObj.options[SelectIndex].value;
	}
    alert(MessageType);
    var SendPatientModiInfoFunction=document.getElementById("SendPatientModiInfo").value;
	var Info=cspRunServerMethod(SendPatientModiInfoFunction,MessageType);    		
 
}

function CancelExecuteObj_click()
{
       var OrdRowid=document.getElementById("ROWID").value;
       var CancelExecuteFunction=document.getElementById("CancelExecuteFunction").value;
       var Info=cspRunServerMethod(CancelExecuteFunction,OrdRowid);    	

}


function OnchangeMessageType()
{

		MessageTypeObj=document.getElementById("MessageType");
		
		var selectIndex=MessageTypeObj.selectedIndex;
		
		var MessageType=MessageTypeObj.options[MessageTypeObj.selectedIndex].innerText;
		
		var SelectInfoObj=document.getElementById("SelectInfo");
		if (SelectInfoObj)
		{
			SelectInfoObj.value=MessageType+"^"+selectIndex
		}
}

function AddItem(ObjName, Info)
{
	var Obj=document.getElementById(ObjName);
    if (Obj.options.length>0)
 	{
		for (var i=Obj.options.length-1; i>=0; i--) Obj.options[i] = null;
	}
	
    var ItemInfo=Info.split("^");
 	for (var i=0;i<ItemInfo.length;i++)
 	{
	 	perInfo=ItemInfo[i].split(String.fromCharCode(1))
	 	var sel=new Option(perInfo[1],perInfo[0]);
		Obj.options[Obj.options.length]=sel;
		
	} 
}

function combo(cmstr)
{
	var obj=document.getElementById(cmstr);
	obj.size=1; 
	obj.multiple=false;
}


document.body.onload = BodyLoadHandler;