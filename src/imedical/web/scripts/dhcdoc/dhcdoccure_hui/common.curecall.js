var DHCDocCure_CureCall=(function(){
	var DHCDocCureUseCall=0;
	if(typeof(ServerObj)=="object"){
		DHCDocCureUseCall=ServerObj.DHCDocCureUseCall;
	}else{
		DHCDocCureUseCall=$.cm({
			ClassName:"DHCDoc.DHCDocCure.Config",
			MethodName:"GetCureConfigPara",
			CPCode:"CureUseCall",
			CPHospID:session['LOGON.HOSPID'],
			dataType:"text"
		},false)
	}
	if(DHCDocCureUseCall==0){
		return {
			"CureCallHandle":function(){
				$.messager.alert("提示", "叫号功能未启用", 'warning')
			 	return false;
			 },
			"SkipCallHandle":function(){
				$.messager.alert("提示", "叫号功能未启用", 'warning')
			 	return false;
			 }
		}
	}
	
	//V1 原来的对治疗申请、治疗预约记录的呼叫
	//V2 新版治疗处理的对治疗患者队列记录的呼叫
	function CureCallHandle(DataGrid,callback){
		//以下程序仅支持东华叫号接口
		var rows = DataGrid.datagrid("getSelections");		
		if (rows.length>=1)
		{
			var success=false;
			var PreDCAIDArr=[];
			for(var i=0;i<rows.length;i++){
				var CallRowId="",SourceType="";
				var ServiceGroupDesc="",StartTime="";
				var treatID="";
				var selected=rows[i]; 
				var PatName=selected.PatName;				
				
				var callinfo="请"+PatName+"进入治疗室";
				var zhContent="";
				if(DataGrid.selector=="#tabCureWorkList"){
					//V1 原来的治疗处理对治疗预约记录的呼叫
					var DCAARowId=selected.Rowid;
					ServiceGroupDesc=selected.ServiceGroupDesc;
			    	StartTime=selected.StartTime;
			    	treatID=selected.ServiceGroupID;
			    	zhContent=DCAARowId+";"+PatName+";"+ServiceGroupDesc+";"+StartTime;
			    	SourceType="AP";
			    	CallRowId=DCAARowId;
				}else if(DataGrid.selector=="#CureQueListTab"){
					//新版治疗处理的对治疗患者队列记录的呼叫
					var QueRowId=selected.Rowid; 
					SourceType="CQ";
			    	CallRowId=QueRowId;
				}else{
					//治疗执行对患者治疗申请的呼叫
					var DCARowId=selected.DCARowId;
					OrdBilled=selected.OrdBilled;
					ApplyStatusCode=selected.ApplyStatusCode;
					treatID=selected.ServiceGroupID;
					if(OrdBilled==$g("否")){
						$.messager.alert("提示", PatName+" "+$g("治疗申请医嘱未缴费."), 'warning')
				        continue;
					}else if(ApplyStatusCode=="C"){
						$.messager.alert("提示", PatName+" "+$g("治疗申请已撤销."), 'warning')
				        continue;
					}
					SourceType="A";
			    	CallRowId=DCARowId;
				}
				/*
				深圳市中医院  治疗室 叫号接口
			   	web.DHCVISVoiceCall.InsertVoiceQueue(callinfo,user,computerIP,"A","LR","N",callinfo,callinfo,"",treatID)
			   	callinfo          请 张三 进入治疗室
			   	user              userID
			   	computerIP        计算机IP
			   	treatID           治疗类型ID   
				*/
				var computerIP=GetComputerIp()
				var loguser=session['LOGON.USERID'];
				var logloc=session['LOGON.CTLOCID'];
				var ret="0"; 
				var JsonObj={
					voiceContent:callinfo,
					userId:loguser,
					clientIP:computerIP,
					type:"A",
					sound:"LR",
					repeat:"N",
					ZHScreenStr:zhContent,
					CKScreenStr:logloc,
					WaitList:"",
					Note:treatID
				}
				var JsonStr=JSON.stringify(JsonObj);
				var ret=$.cm({
					ClassName:"DHCDoc.DHCDocCure.CureCall",
					MethodName:"CureCall",
					VoiceQueueJson:JsonStr,
					CallRowId:CallRowId,
					Type:"Call",
					SourceType:SourceType,
					UserId:loguser,
					dataType:"text"
				},false)
				if(ret=="0"){
					success=true;
					PreDCAIDArr.push(CallRowId);
					$.messager.popover({msg: PatName+$g("呼叫成功"),type:'success',timeout: 3000});
				}else{
					var errmsg=PatName+$g("呼叫失败");
					errmsg=GetErrMsg(ret,errmsg);
					
					$.messager.alert("错误", errmsg, 'error');
				    return false;
				}
			}

			if(success){
				callback("Y",PreDCAIDArr);
			}
		}else{
			$.messager.alert("错误", "请选择一位患者的治疗申请单再呼叫.", 'error')
			 return false;
		}
	}
	
	function GetErrMsg(ret,errmsg){
		if(ret=="-400"){
			errmsg=errmsg+","+$g("未呼叫的患者无需过号");	
		}else if(ret=="-401"){
			errmsg=errmsg+","+$g("已过号的患者无需再次过号");	
		}else if(ret=="-402"){
			errmsg=errmsg+","+$g("已被其他治疗师叫号");	
		}else if(ret=="-302"){
			errmsg=errmsg+","+$g("排班信息错误");	
		}else if(ret=="-305"){
			errmsg=errmsg+","+$g("更新治疗预约表信息错误");	
		}else if(ret=="-306"){
			errmsg=errmsg+","+$g("更新治疗排班表信息错误");	
		}else{
			errmsg=errmsg+","+$g("错误代码")+":"+ret;	
		}
		return errmsg;	
	}
	function SkipCallHandle(DataGrid,callback){
		var rows = DataGrid.datagrid("getSelections");
		var loguser=session['LOGON.USERID'];
		if (rows.length>=1){
			var fresh=false;
			for(var i=0;i<rows.length;i++){
				var CallRowId="",SourceType="";
				var treatID="";
				var ServiceGroupDesc="",StartTime="";
				var selected=rows[i]; 
				var PatName=selected.PatName;				
				if(DataGrid.selector=="#tabCureWorkList"){
					var DCAARowId=selected.Rowid;
					treatID=selected.ServiceGroupID;
					ServiceGroupDesc=selected.ServiceGroupDesc;
			    	StartTime=selected.StartTime;
			    	zhContent=DCAARowId+";"+PatName+";"+ServiceGroupDesc+";"+StartTime;
			    	SourceType="AP";
			    	CallRowId=DCAARowId;
				}else if(DataGrid.selector=="#CureQueListTab"){
					//新版治疗处理的对治疗患者队列记录的呼叫
					var QueRowId=selected.Rowid; 
					SourceType="CQ";
			    	CallRowId=QueRowId;
				}else{
					var DCARowId=selected.DCARowId;
					treatID=selected.ServiceGroupID;
					SourceType="A";
			    	CallRowId=DCARowId;
				}
				var callret=tkMakeServerCall("DHCDoc.DHCDocCure.CureCall","DHCDocCureReport",CallRowId,"Pass",SourceType,loguser)
				if(callret!=0){
					var errmsg=PatName+$g("更新呼叫状态失败")
					errmsg=GetErrMsg(callret,errmsg);
					$.messager.alert("错误",errmsg , 'error')
			        return false;
				}else{
					fresh=true;
					$.messager.popover({msg: PatName+$g("过号成功"),type:'success',timeout: 3000});
				}
			}
			if(fresh){
				callback();
			}
		}else{
			$.messager.alert("错误", "请选择一位患者的治疗申请单.", 'error')
			 return false;
		}
	}
	
	function GetComputerIp() 
	{
	   var ipAddr=ClientIPAddress;
	   /*
	   var locator = new ActiveXObject ("WbemScripting.SWbemLocator");  
	   var service = locator.ConnectServer("."); //连接本机服务器
	   var properties = service.ExecQuery("SELECT * FROM Win32_NetworkAdapterConfiguration");  //查询使用SQL标准 
	   var e = new Enumerator (properties);
	   var p = e.item ();

	   for (;!e.atEnd();e.moveNext ())  
	   {
	  	var p = e.item ();  
	 	//document.write("IP:" + p.IPAddress(0) + " ");//IP地址为数组类型,子网俺码及默认网关亦同
		ipAddr=p.IPAddress(0); 
		if(ipAddr) break;
		}
		*/
		return ipAddr;
		
	}
	
	return {
		"CureCallHandle":CureCallHandle,
		"SkipCallHandle":SkipCallHandle
	}
})()