// DHCRisHL7Query.js
// 
function BodyLoadHandler()
{
	var stdate=document.getElementById("StartDate");
	var eddate=document.getElementById("EndDate");
	if (stdate.value=="")
	{
		stdate.value=DateDemo();
		eddate.value=DateDemo();
	}
	
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
    
    var QueryObj=document.getElementById("Query");
	if (QueryObj)
	{
		QueryObj.onclick=Query_click;
	}
	
    var SendMessageObj=document.getElementById("SendMessage");
	if (SendMessageObj)
	{
		SendMessageObj.onclick=SendMessageObjClick;
	}		
   
    var DeleteObj=document.getElementById("Delete");
	if (DeleteObj)
	{
		DeleteObj.onclick=DeleteObjClick;
	}		
   
    
}

function DeleteObjClick()
{
	var Selected=false;
	var eSrc=window.event.srcElement;
	var objtbl=document.getElementById('tDHCRisHL7Query');
	var rows=objtbl.rows.length;
	var lastrowindex=rows - 1;
	
	var rowObj=getRow(eSrc);
	var selectrow=rowObj.rowIndex;
	
	MessageTypeObj=document.getElementById("MessageType");
	if (MessageTypeObj)
	{
		var SelectIndex=MessageTypeObj.selectedIndex;
		MessageType=MessageTypeObj.options[SelectIndex].value;
	}

 
    for (i=1;i<rows;i++)
    {
	    var selectedobj=document.getElementById("TSelectz"+i);
	    
        if ((selectedobj)&&(selectedobj.checked))
        {  
            var Index=document.getElementById("Indexz"+i).innerText;
            
            var DeleteFunction=document.getElementById("DeleteFunction").value;
		    var Info=cspRunServerMethod(DeleteFunction,Index,MessageType);    		
        }
    }
	Query_click();
}

function Query_click()
{
	var stdate=document.getElementById("StartDate").value;
	var eddate=document.getElementById("EndDate").value;
	var PatientId=document.getElementById("PatientID").value;
	var SelectInfo=document.getElementById("SelectInfo").value;
	var MessageType=document.getElementById("MessageType").value;
	
	var Link="websys.default.csp?WEBSYS.TCOMPONENT=DHCRisHL7Query"+"&StartDate="+stdate+"&EndDate="+eddate+"&PatientID="+PatientId+"&SelectInfo="+SelectInfo+"&MessageType="+MessageType;    
    location.href=Link;
    
      

	
}

function SendMessageObjClick()
{

	var Selected=false;
	var eSrc=window.event.srcElement;
	var objtbl=document.getElementById('tDHCRisHL7Query');
	var rows=objtbl.rows.length;
	var lastrowindex=rows - 1;
	
	var rowObj=getRow(eSrc);
	var selectrow=rowObj.rowIndex;
	
	MessageTypeObj=document.getElementById("MessageType");
	if (MessageTypeObj)
	{
		var SelectIndex=MessageTypeObj.selectedIndex;
		MessageType=MessageTypeObj.options[SelectIndex].value;
	}

 
    for (i=1;i<rows;i++)
    {
	    var selectedobj=document.getElementById("TSelectz"+i);
	    
        if ((selectedobj)&&(selectedobj.checked))
        {  
            var Index=document.getElementById("Indexz"+i).innerText;
            
            var ReSendMessageFunction=document.getElementById("ReSendMessage").value;
		    var Info=cspRunServerMethod(ReSendMessageFunction,Index,MessageType);    		
        }
    }
	Query_click();
	
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



function DateDemo(){
   var d, s="";         
   d = new Date();                          
   s += d.getDate() + "/";                 
   s += (d.getMonth() + 1) + "/";           
   s += d.getYear();                       
   return(s);                               
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
	    Query_click();
		
	
	

		
}




function SelectRowHandler()
{
}


document.body.onload = BodyLoadHandler;
