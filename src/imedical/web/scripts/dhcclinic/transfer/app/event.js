function InitWinScreenEvent(obj)
{
	var _UDHCANOPArrange=ExtTool.StaticServerObject('web.UDHCANOPArrange');
	var _DHCANOPArrange=ExtTool.StaticServerObject('web.DHCANOPArrange');
	var _DHCANOPTransfer=ExtTool.StaticServerObject('web.DHCANOPTransfer');
	var userId=session['LOGON.USERID'];	
	obj.LoadEvent = function(args)
	{	 
		if (opaId!="")
	    { 
		 var flagStr=_DHCANOPTransfer.ifAppFlag(opaId)
		 var flagList=flagStr.split("^");
		 
		 var receiveAppFlag=flagList[0],sendAppFlag=flagList[1];
		 //if((receiveAppFlag==1)&&(sendAppFlag==0)){alert("接该病人申请已提交！")};
		 //if((receiveAppFlag==1)&&(sendAppFlag==1)){alert("该病人的接送申请均已提交！")} 
	     var retStr0=_DHCANOPArrange.GetAnSingle(opaId,"",userId)
		 var appList=retStr0.split("@");
		 LoadData(appList)
		 var appStr=_DHCANOPTransfer.getAppStr(opaId);
		 var appStrList=appStr.split("^");
		 //alert(appStrList);
		 if(appStrList[0]!=""){
			 obj.receiveAppDate.setValue(appStrList[0]);
		 }
		 obj.receiveAppTime.setValue(appStrList[1]);
		 if(appStrList[2]!=""){
	     	obj.sendAppDate.setValue(appStrList[2]);
		 }
	     obj.sendAppTime.setValue(appStrList[3]);
	   }
	};
	
	function LoadData(appList)
	 {
	   ////手术时间
	   var opDateTime=appList[4]
	   var opDateTimeList=opDateTime.split("^")
	   
	   ////病人基本信息
	   var patBaseInfo=appList[0]
	   var baseInfoList=patBaseInfo.split("^")
	   EpisodeID=baseInfoList[0]
       obj.txtPatname.setValue(baseInfoList[1]); //姓名
	   obj.txtPatRegNo.setValue(baseInfoList[2]); //登记号
	   obj.txtPatSex.setValue(baseInfoList[3]); //性别
	   obj.txtPatAge.setValue(baseInfoList[4]); //年龄
	   obj.txtPatLoc.setValue(baseInfoList[5]); //病人所在科室
	   obj.txtPatWard.setValue(baseInfoList[6]); //病区
	   obj.txtPatBedNo.setValue(baseInfoList[7]); //床号
	   obj.txtAdmReason.setValue(baseInfoList[8]) //费别
       var opTheatreInfo=appList[3]	
      // alert(appList[3])   
	   var opTheatreInfoList=opTheatreInfo.split("^")
	   var opRoom=opTheatreInfoList[0]   //手术间
	   obj.comOperRoom.setValue(opRoom.split('!')[1]);
	   var ordNo=opTheatreInfoList[1]
	   obj.comOrdNo.setValue(ordNo)    //台次
       var GROUPID=session["LOGON.GROUPID"];
		if ((GROUPID=="833")||(GROUPID=="834"))	//麻醉pacu（3）/（4）
		{
			Ext.getCmp('btnOpSave').setVisible(false);
			obj.receiveAppDate.disable()
			obj.receiveAppTime.disable()
			}
	   var opStDate=opDateTimeList[0]
	   obj.receiveAppDate.setValue(opStDate) //申请接病人日期
	   obj.sendAppDate.setValue(opStDate) //申请送病人日期
	   
	 }
	 
	 obj.btnOpSave_click=function()
	 {
		 var receiveAppDate=obj.receiveAppDate.getRawValue();
		 var receiveAppTime=obj.receiveAppTime.getRawValue();
		 var receiveAppUser=session['LOGON.USERID'];
		 
		 var receiveStr=receiveAppDate+"^"+receiveAppTime+"^"+receiveAppUser

		 if(opaId!="")
		 {
			var ret=_DHCANOPTransfer.insertReceiveApp(opaId,receiveStr,userId)
			if (ret!=0)
			{
				 window.returnValue=0
				 alert(ret);
				 return;
			}
			else
			{
				 window.returnValue=1
			     var closeWindow = confirm("接病人申请成功，是否继续？")
			     if(!closeWindow)
			     {
			        window.close()
			     }
			}
		 
		 }
		
	 }
	 obj.btnSave_click=function()
	 {
		 var sendAppDate=obj.sendAppDate.getRawValue();
		 var sendAppTime=obj.sendAppTime.getRawValue();
		 var sendAppUser=session['LOGON.USERID'];
		 var sendStr=sendAppDate+"^"+sendAppTime+"^"+sendAppUser
		 if(opaId!="")
		 {
			 var ret=_DHCANOPTransfer.insertSendApp(opaId,sendStr,userId)
		 }
		 if (ret!=0)
		 {
			window.returnValue=0
			alert(ret);
		    return;
		 }
		 else
	     {
			 window.returnValue=1
			 var closeWindow = confirm("送病人申请成功，是否继续？")
			 if(!closeWindow)
			 {
			     window.close()
			 }
		 }
		 
		
	 }
	 
	 obj.btnClose_click=function()
	 {
		 Ext.MessageBox.confirm('提示','确定要关闭?', 
			    	    function(btn) {
				    	     if(btn == 'yes')
					         {	 
							     window.close();
							 }
							});
	 }
	 obj.btnOpClose_click=function()
	 {
		 Ext.MessageBox.confirm('提示','确定要关闭?', 
			    	    function(btn) {
				    	     if(btn == 'yes')
					         {	 
							     window.close();
							 }
							});
	 }
		
}﻿