function BodyLoadHandler()
{
    var obj=document.getElementById("btUpdate");
    if (obj) {obj.onclick=UpdateClick;}
}
function UpdateClick()
{
	var obj=document.getElementById("suspRowId")
	if(obj) var suspRowId=obj.value;
	else var suspRowId=""
	var obj=document.getElementById("opaId")
	if(obj) var opaId=obj.value;
	else var opaId=""
	var userId=session['LOGON.USERID'];
	var obj=document.getElementById("UpdateReasSusp")
	if(obj) 
	{
		var UpdateReasSusp=obj.value;
		if((suspRowId!="")&(UpdateReasSusp!=""))
		{
			var retStr=cspRunServerMethod(UpdateReasSusp,opaId,suspRowId,userId);
			if(retStr!="") 
			{
				alert(retStr);
				return(retStr);
			}
			else
			{
				alert("撤销成功");  
				self.close();
			}
		}
		else if(suspRowId=="")
		{
			 alert("请选择取消原因!");
			 return
		}
	}
}
function GetReturnReason(str)
{
	var tem=str.split("^");
	var obj=document.getElementById("suspDesc")
	if(obj) obj.value=tem[1];
	var obj=document.getElementById("suspRowId")
	if(obj) obj.value=tem[0];
}
document.body.onload = BodyLoadHandler;
