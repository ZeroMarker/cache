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
				$.messager.alert("��ʾ", "�кŹ���δ����", 'warning')
			 	return false;
			 },
			"SkipCallHandle":function(){
				$.messager.alert("��ʾ", "�кŹ���δ����", 'warning')
			 	return false;
			 }
		}
	}
	
	//V1 ԭ���Ķ��������롢����ԤԼ��¼�ĺ���
	//V2 �°����ƴ���Ķ����ƻ��߶��м�¼�ĺ���
	function CureCallHandle(DataGrid,callback){
		//���³����֧�ֶ����кŽӿ�
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
				
				var callinfo="��"+PatName+"����������";
				var zhContent="";
				if(DataGrid.selector=="#tabCureWorkList"){
					//V1 ԭ�������ƴ��������ԤԼ��¼�ĺ���
					var DCAARowId=selected.Rowid;
					ServiceGroupDesc=selected.ServiceGroupDesc;
			    	StartTime=selected.StartTime;
			    	treatID=selected.ServiceGroupID;
			    	zhContent=DCAARowId+";"+PatName+";"+ServiceGroupDesc+";"+StartTime;
			    	SourceType="AP";
			    	CallRowId=DCAARowId;
				}else if(DataGrid.selector=="#CureQueListTab"){
					//�°����ƴ���Ķ����ƻ��߶��м�¼�ĺ���
					var QueRowId=selected.Rowid; 
					SourceType="CQ";
			    	CallRowId=QueRowId;
				}else{
					//����ִ�жԻ�����������ĺ���
					var DCARowId=selected.DCARowId;
					OrdBilled=selected.OrdBilled;
					ApplyStatusCode=selected.ApplyStatusCode;
					treatID=selected.ServiceGroupID;
					if(OrdBilled==$g("��")){
						$.messager.alert("��ʾ", PatName+" "+$g("��������ҽ��δ�ɷ�."), 'warning')
				        continue;
					}else if(ApplyStatusCode=="C"){
						$.messager.alert("��ʾ", PatName+" "+$g("���������ѳ���."), 'warning')
				        continue;
					}
					SourceType="A";
			    	CallRowId=DCARowId;
				}
				/*
				��������ҽԺ  ������ �кŽӿ�
			   	web.DHCVISVoiceCall.InsertVoiceQueue(callinfo,user,computerIP,"A","LR","N",callinfo,callinfo,"",treatID)
			   	callinfo          �� ���� ����������
			   	user              userID
			   	computerIP        �����IP
			   	treatID           ��������ID   
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
					$.messager.popover({msg: PatName+$g("���гɹ�"),type:'success',timeout: 3000});
				}else{
					var errmsg=PatName+$g("����ʧ��");
					errmsg=GetErrMsg(ret,errmsg);
					
					$.messager.alert("����", errmsg, 'error');
				    return false;
				}
			}

			if(success){
				callback("Y",PreDCAIDArr);
			}
		}else{
			$.messager.alert("����", "��ѡ��һλ���ߵ��������뵥�ٺ���.", 'error')
			 return false;
		}
	}
	
	function GetErrMsg(ret,errmsg){
		if(ret=="-400"){
			errmsg=errmsg+","+$g("δ���еĻ����������");	
		}else if(ret=="-401"){
			errmsg=errmsg+","+$g("�ѹ��ŵĻ��������ٴι���");	
		}else if(ret=="-402"){
			errmsg=errmsg+","+$g("�ѱ���������ʦ�к�");	
		}else if(ret=="-302"){
			errmsg=errmsg+","+$g("�Ű���Ϣ����");	
		}else if(ret=="-305"){
			errmsg=errmsg+","+$g("��������ԤԼ����Ϣ����");	
		}else if(ret=="-306"){
			errmsg=errmsg+","+$g("���������Ű����Ϣ����");	
		}else{
			errmsg=errmsg+","+$g("�������")+":"+ret;	
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
					//�°����ƴ���Ķ����ƻ��߶��м�¼�ĺ���
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
					var errmsg=PatName+$g("���º���״̬ʧ��")
					errmsg=GetErrMsg(callret,errmsg);
					$.messager.alert("����",errmsg , 'error')
			        return false;
				}else{
					fresh=true;
					$.messager.popover({msg: PatName+$g("���ųɹ�"),type:'success',timeout: 3000});
				}
			}
			if(fresh){
				callback();
			}
		}else{
			$.messager.alert("����", "��ѡ��һλ���ߵ��������뵥.", 'error')
			 return false;
		}
	}
	
	function GetComputerIp() 
	{
	   var ipAddr=ClientIPAddress;
	   /*
	   var locator = new ActiveXObject ("WbemScripting.SWbemLocator");  
	   var service = locator.ConnectServer("."); //���ӱ���������
	   var properties = service.ExecQuery("SELECT * FROM Win32_NetworkAdapterConfiguration");  //��ѯʹ��SQL��׼ 
	   var e = new Enumerator (properties);
	   var p = e.item ();

	   for (;!e.atEnd();e.moveNext ())  
	   {
	  	var p = e.item ();  
	 	//document.write("IP:" + p.IPAddress(0) + " ");//IP��ַΪ��������,�������뼰Ĭ��������ͬ
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