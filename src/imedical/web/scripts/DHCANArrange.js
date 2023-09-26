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
function SetElementValue(elementName1,elementName2,dataValue)
{
   var obj=document.getElementById(elementName1);
   var obj1=document.getElementById(elementName2);
   var tem=dataValue.split("!");
   if(obj){
	   if (tem[0]) obj.value=tem[0];
   }
   if(obj1){
	   if (tem[1]) obj1.value=tem[1];
   }
}
function UpdateANArr()
{   
	var roomId=operRoomId;
	//var opId=document.getElementById("opaId").value
	var anaDocIdList=GetListData("anaDocList")
	var sAnaDocIdList=GetListData("sAnaDocList")
	var scrubNurseIdList=GetListData("scrubNurseList")
	var sScrubNurseIdList=GetListData("sScrubNurseList")
	var circulNurseIdList=GetListData("circulNurseList")
	var sCirculNurseIdList=GetListData("sCirculNurseList")
	var UpdateANArr=document.getElementById("UpdateANArr").value
	var anaDocId=document.getElementById("anaDocId").value;
	var obj=document.getElementById("anaSupervisorId");
    if(obj) var anaSupervisorId=obj.value;
    else var anaSupervisorId="";
	var ret=cspRunServerMethod(UpdateANArr,roomId,opaId,anaDocId,anaDocIdList,sAnaDocIdList,anaSupervisorId,anaNurseId,scrubNurseIdList,sScrubNurseIdList,circulNurseIdList,sCirculNurseIdList);
}
//process return value and send to GUI
function getreturn(value)
{
	if (value=="") alert(t['02']);
	 else 
	{
			 var tem=value.split("^")
		 
	         //document.getElementById('troomId').value=tem[0]
	     
	 	     //document.getElementById('PbTotalamount').value=tem[1]
	 	     
	 	     //if(tem[2]=="")
 		     // {alert(t['03'])}
 		      
	 	    document.getElementById('troomId').value=tem[0]
	 	  
	}
}