function InitViewScreenEvent(obj)
{
	var _DHCANOPCancelOper=ExtTool.StaticServerObject('web.DHCANOPCancelOper');
	var UserId=session['LOGON.USERID'];
	obj.LoadEvent=function(args)
	{
		  obj.CancelReason.setValue(""); 
		
	}
	 //修改
	 obj.btnUpdate_click=function()
	 {
	  var reasonId=obj.CancelReason.getValue()
	  if(reasonId=="")
	  {
	   alert("请选择撤销原因")
	   return;
	  }
	  var ifInsertLog=""
	 ifInsertLog=_DHCANOPCancelOper.IfInsertLog()
	 if(ifInsertLog=="Y")
		{
			var clclogId="",logRecordId="",preValue="",preAddNote="",postValue="",postAddNote=""
			clclogId="CancelOper";
			preAddNote="Pre手术状态";
			userId=session['LOGON.USERID'];
			logRecordId=opaId;
			postValue="C";
			postAddNote="撤销成功";
			var wshNetwork = new ActiveXObject("WScript.Network");  
	 		var userd=wshNetwork.UserDomain;  
	 		var userc=wshNetwork.ComputerName;  
	 		var useru=wshNetwork.UserName;  
			var ipconfig=userd+":"+userc+":"+useru;
			var retCllog=_DHCANOPCancelOper.InsertCLLog(clclogId,logRecordId,preValue,preAddNote,postValue,postAddNote,userId,ipconfig)
			//alert(retCllog) 
			 } 
	var ret=_DHCANOPCancelOper.UpdateCancelReason(opaId,reasonId,UserId)
	  if(ret==0)
	  {
		
  
		  alert("更新成功");
		  window.close()
		  }
	 }
	 
	 obj.btnClose_click=function()
	 {
	   window.close()
	 }
	 
}