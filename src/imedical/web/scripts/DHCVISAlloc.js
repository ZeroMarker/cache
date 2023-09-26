var Obj1=document.getElementById("SwitchServerState");
if (Obj1) Obj1.style.display="none";
var Obj2=document.getElementById("ChangeBroad");
if (Obj2) Obj2.style.display="none";
var Obj3=document.getElementById("BroadContent");
if (Obj3) Obj3.style.display="none";
var Obj4=document.getElementById("cBroadContent");
if (Obj4) Obj4.style.display="none";
var Obj5=document.getElementById("B_Call");
if (Obj5) Obj5.style.display="none";

var ZoneValue=""
var List=document.getElementById("T_Zone")
if((List)&&(List.options[0]!=null))
{
	var ZoneObj=document.getElementById('Zone');
	if(ZoneObj)
	{
		ZoneValue=ZoneObj.value;
	}
	else
	{
		//var selectindex=List.selectedIndex;
		var selectindex=List.options.selectedIndex;
		if(selectindex<=0)
	   		ZoneValue =List.options[0].value;
		else
	    	ZoneValue=List.options[selectindex].value;
	}
}
if(ZoneValue!="") var ActiveFlag=tkMakeServerCall("web.DHCVISAlloc","GetActiveFlag","",ZoneValue);
else var ActiveFlag=tkMakeServerCall("web.DHCVISAlloc","GetActiveFlag");
if (ActiveFlag==0){
	if (Obj1)
	{
		Obj1.style.display="block";
		if(ZoneValue!="") var ServerState=tkMakeServerCall("web.DHCVISAlloc","GetServerState","",ZoneValue);
		else var ServerState=tkMakeServerCall("web.DHCVISAlloc","GetServerState");
		//var ServerState=tkMakeServerCall("web.DHCVISAlloc","GetServerState");
		if(ServerState==0) Obj1.innerHTML ="关闭叫号服务"
		else Obj1.innerHTML ="开启叫号服务"
		Obj1.onclick=SwitchServerState;
		GetBroadContent();
	}
	if (Obj2)
	{
		Obj2.style.display="block";
		Obj2.onclick=ChangeBroad;
	}
	if (Obj3)
	{
		Obj3.style.display="block";
	}
	if (Obj4)
	{
		Obj4.style.display="block";
	}
	if (Obj5)
	{
		Obj5.style.display="block";
		//LoadTipDiv();
	}
}
function SwitchServerState()
{
	var ServerState="Y"
	var Obj1=document.getElementById("SwitchServerState");
	if(Obj1.innerHTML =="关闭叫号服务") ServerState="N"
	if(ZoneValue!="") var RetStr=tkMakeServerCall("web.DHCVISAlloc","UpdateServerState","",ServerState,ZoneValue);
	else var RetStr=tkMakeServerCall("web.DHCVISAlloc","UpdateServerState","",ServerState);
	//var RetStr=tkMakeServerCall("web.DHCVISAlloc","UpdateServerState","",ServerState); 
	if(ServerState=="Y") Obj1.innerHTML ="关闭叫号服务"
	else Obj1.innerHTML ="开启叫号服务"
}
function ChangeBroad()
{
	var BroadContent=""
	var Obj1=document.getElementById("BroadContent");
	BroadContent=Obj1.value
	if(ZoneValue!="") var RetStr=tkMakeServerCall("web.DHCVISAlloc","ChangeBroadContent","",BroadContent,ZoneValue);
	else var RetStr=tkMakeServerCall("web.DHCVISAlloc","ChangeBroadContent","",BroadContent);
	//var RetStr=tkMakeServerCall("web.DHCVISAlloc","ChangeBroadContent","",BroadContent);
	GetBroadContent();
	alert(RetStr)
}
function GetBroadContent()
{
	var BroadContent=""
	var Obj1=document.getElementById("BroadContent");
	if(ZoneValue!="") var RetStr=tkMakeServerCall("web.DHCVISAlloc","GetBroadContent","",ZoneValue);
	else var RetStr=tkMakeServerCall("web.DHCVISAlloc","GetBroadContent");
	//var RetStr=tkMakeServerCall("web.DHCVISAlloc","GetBroadContent");
	Obj1.value=RetStr 
}
function CallClick() {
	if (CurrentRow==0)
	{
		var List=document.getElementById("T_Zone")
		if((List)&&(List.options[0]!=null))
		{
			var ZoneObj=document.getElementById('Zone');
			if(ZoneObj)
			{
				ZoneValue=ZoneObj.value;
			}
			else
			{
				//var selectindex=List.selectedIndex;
				var selectindex=List.options.selectedIndex;
				if(selectindex<=0)
			   		ZoneValue =List.options[0].value;
				else
			    	ZoneValue=List.options[selectindex].value;
			}
	     	if(ZoneValue!="") var RetStr=tkMakeServerCall("web.DHCVISQueueManage","ReplacedCallByZone",ZoneValue);
		}

		//alert("请选择要呼叫的病人!")
	}
	else
	{
		var QueueRoomId=""
		var SelectRow=CurrentRow;
		var QueueID=document.getElementById("IDz"+SelectRow).value;
		var QueueRoom=document.getElementById("Tbl_Quez"+SelectRow).innerText;;
		if (QueueRoom==""){
			var tmp=document.getElementById('L_Room');
			if (tmp.selectedIndex!=-1) {
				var selItem=tmp.options[tmp.selectedIndex];
				if (selItem)
				{
					QueueRoomId=selItem.value
				}
				else
				{
					alert("请选择诊室!")
					return ;
				}
			}
			else
			{
				alert("请选择诊室!")
				return ;
			}
		}
		var RetStr=tkMakeServerCall("web.DHCVISQueueManage","ReplacedCall",QueueID,QueueRoomId);
	}
}
function Find_click()
{
	return;
}
function ShowBeforeWaitNo(QueueID)
{
	var TipContent=tkMakeServerCall("web.DHCVISAlloc","GetBeforeWaitNo",QueueID);
	ShowTip(TipContent);
}
function LoadTipDiv()
{
	try
	{
		var objdiv = document.createElement("DIV");
		objdiv.id = "LayerTip";
		objdiv.style.visibility ='visible';
		objdiv.style.display = 'none';
		objdiv.style.width = 200;
		objdiv.style.height = 50;
		document.body.appendChild(objdiv);	
	}
	catch(e)
	{
	}
}	
function ShowTip(TipContent){   
  var Layer = document.getElementById('LayerTip');
  if(Layer)
  {
	  Layer.innerText=TipContent;   
	  Layer.style.display="block";
	  Layer.style.color="red";
	  Layer.style.fontSize=15;
	  Layer.style.fontBlod=true;
	  Layer.style.left=event.clientX+15;  
	  Layer.style.top=parseInt(event.y)+5+document.body.scrollTop;   
	  Layer.style.position="absolute"; 
  }
  else
  {
	  LoadTipDiv();
	  ShowTip(TipContent);
  }
}
function CloseTip(){   
  var Layer = document.getElementById('LayerTip');
  if(Layer) Layer.style.display="none";   
}