
var EpisodeID=dhccl.getUrlParam("EpisodeID"),
    opaId=dhccl.getUrlParam("opaId");

$(function(){
	InitForm();
	if(EpisodeID!="")
	{
		loadDatas();
		var flagStr=$.m({
       	 		ClassName:"web.DHCANOPTransfer",
        		MethodName:"ifAppFlag",
        		opaId:opaId
    		},false);
		var flagList=flagStr.split("^");
		 
		 var receiveAppFlag=flagList[0],sendAppFlag=flagList[1];
		 if((receiveAppFlag==1)&&(sendAppFlag==0)){alert("接该病人申请已提交！")};
		 
		 var appStr=$.m({
       	 		ClassName:"web.DHCANOPTransfer",
        		MethodName:"getAppStr",
        		opaId:opaId
    		},false);
		 var appStrList=appStr.split("^");
		 if(appStrList[0]!=""){
			  $("#receiveAppDate").datebox('setValue',appStrList[0]);
		 }
		 $("#receiveAppTime").timespinner('setValue',appStrList[1]);
		 if(appStrList[2]!=""){
	     	$("#sendAppDate").datebox('setValue',appStrList[2]);
		 }
	     $("#sendAppTime").timespinner('setValue',appStrList[3]);

		 
	}
});
function loadDatas()
{
	var patInfo=getPatInfo();
	//alert(patInfo)
    var appList=patInfo.split("@");
    loadOperData(appList);
}
//获取病人基本信息
function getPatInfo(){
    var datas=$.m({
        ClassName:"web.DHCANOPTransfer",
        MethodName:"GetPatBaseInfo",
        opaId:opaId,
        EpisodeID:EpisodeID,
        userId:session['LOGON.USERID'],
        type:"In"
    },false);
    return datas;
}

//加载病人基本信息
function loadOperData(appList)
{
	//-----------病人基本信息
	var patBaseInfo=appList[0];
	var baseInfoList=patBaseInfo.split("^");
    $("#PatName").prop("innerText",baseInfoList[1]);
    $("#RegNo").prop("innerText",baseInfoList[2]);
    var PatGender=baseInfoList[3]
    $("#PatGender").prop("innerText",baseInfoList[3]);
    $("#PatAge").prop("innerText",baseInfoList[4]);
    
    $("#PatLoc").prop("innerText",baseInfoList[5]);
    $("#AdmReason").prop("innerText",baseInfoList[8]);
    $("#PatSecret").prop("innerText",baseInfoList[9]+" "+baseInfoList[10]);
    $("#patSeximg").prop("innerText","");
    if(PatGender=="男"){
			var imghtml="<img src='../images/man.png' alt='' style='margin-top:-5px;'/>"
			$("#patSeximg").append(imghtml)
		}else if(PatGender=="女"){
			var imghtml="<img src='../images/woman.png' alt='' style='margin-top:-5px;'/>";
			$("#patSeximg").append(imghtml)
		}
   	var operInfo=appList[1];
	var operInfoList=operInfo.split("^");
    var oproom=operInfoList[3];
    $("#OpRoom").prop("innerText",oproom);
  var opseq=operInfoList[4];
    $("#OpSeq").prop("innerText",opseq);
    
   
	
}

function getIdStr(str)
{
    var idStr=[];
    var strList=str.split(",");
    if(strList.length>0)
    {
        for(var i=0;i<strList.length;i++)
        {
            var id=strList[i].split("!")[0];
            idStr.push(id);
        }
    }
    return idStr;
}

	function InitForm() {
	
    $("#btnReceiveSave").linkbutton({
        onClick: btnReceiveSave
    });
    $("#btnSendSave").linkbutton({
        onClick: btnSendSave
    });
    
	}
//保存麻醉术前评估信息
function btnReceiveSave()
{
	var str=""
	 var receiveAppDate=$("#receiveAppDate").datebox('getValue');
     var receiveAppTime=$("#receiveAppTime").timespinner('getValue');
	var receiveAppUser=session['LOGON.USERID'];
	var receiveStr=receiveAppDate+"^"+receiveAppTime+"^"+receiveAppUser
	if(opaId!="")
		 {
				var ret=$.m({
        ClassName:"web.DHCANOPTransfer",
        MethodName:"insertReceiveApp",
        opaId:opaId,
        str1:receiveStr,
        userId:session['LOGON.USERID']
    },false);
			if (ret!=0)
			{
				alert(ret)
				return;
			}

		    else
		    {
			     var closeWindow = confirm("接患者申请成功,是否继续？")
					     if(!closeWindow)
					     {
					        window.close()
					     }
		    }
		 }

}
function btnSendSave()
{
		var str=""
	 var sendAppDate=$("#sendAppDate").datebox('getValue');
     var sendAppTime=$("#sendAppTime").timespinner('getValue');
	var sendAppUser=session['LOGON.USERID'];
	var sendStr=sendAppDate+"^"+sendAppTime+"^"+sendAppUser
	if(opaId!="")
		 {
				var ret=$.m({
        ClassName:"web.DHCANOPTransfer",
        MethodName:"insertSendApp",
        opaId:opaId,
        str1:sendStr,
        userId:session['LOGON.USERID']
    },false);
			if (ret!=0)
			{
				alert(ret)
				return;
			}


		    else
		    {
			    var closeWindow = confirm("送患者申请成功，是否继续？")
					 if(!closeWindow)
					 {
					     window.close()
					 }
		    }
		 }

}

//关闭窗口
function closeWindow(){
    window.close();
}
