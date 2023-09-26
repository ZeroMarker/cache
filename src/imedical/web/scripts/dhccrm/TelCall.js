
	function Login(extnumber,groupid,agentid,agentname){
		AgentLogin(extnumber, groupid, agentid, agentname, "1");
		DoSetIdle();
	}
	
	function AgentLogin(ExtNumber, GroupID, AgentID, AgentName, AgentData)
	{
		Agent.IsWriteLocalLog = true;
		Agent.IsOpenADR = false;
		if (Agent.Open("201.123.133.77", "8083", "2000", "20000") == true)
		{
			if (Agent.AssignChannel("127.0.0.1", ExtNumber, true, true, 2, ExtNumber) == true) 
			{
				Agent.SetQuitInterval(10000, 10000);
				//座席没有登录
				switch (Agent.Status) 
				{
					//座席没有登录
					case 1:
						if (Agent.LoginEx(GroupID, AgentID, AgentName, AgentData, 1, 0, 255) == false)
							alert("座席登录失败.错误码:" + Agent.ErrorCode + ",描述:" + Agent.GetLastErrInfo());
						else
						{
							alert("登录成功!当前登录信息,座席组:" + GroupID + ",分机:" + ExtNumber + ",座席ID:" + AgentID + 
							                ",座席名称:" + AgentName);
						}
						break;
				}
			}	
			else
				alert("分配信道失败,错误码:" + Agent.ErrorCode + ",错误:" + Agent.GetLastErrInfo());
		}
		else 
			alert("打开本地信道失败,错误码:" + Agent.ErrorCode + ",错误:" + Agent.GetLastErrInfo());
	}
	
	function DoSetIdle(){
		if (Agent.SetIdle() == false)
		{alert("示闲操作失败,错误码:" + Agent.ErrorCode +",描述:" + Agent.GetLastErrInfo())}
		else
		{alert("操作员就绪成功!")}
	}
	
	function DoLogout(){ 
		if (Agent.Logout() == true) {
        window.setTimeout("Agent.DeAssignChannel()", 500);
        window.status = "";
        alert("登出成功!");
        }
	}
	
	function DoMakeCall(telnumber){
	if (Agent.MakeCall("00"+telnumber, "", "") == false)
			alert("MakeCall失败,错误码:" + Agent.ErrorCode +
			                              ",描述:" + Agent.GetLastErrInfo());
	else
		{//alert("MakeCall成功,NewCallRefID = " + Agent.NewCallRefID);
			alert("MakeCall成功!")
		}
	}
	
	function DoHangupCall()
	{
		if(Agent.HangupCall("0") == false) 
		alert("HangupCall失败,错误码:" + Agent.ErrorCode +
		                              ",描述:" + Agent.GetLastErrInfo());
		else
		alert("成功挂断!")                              
	}
		

