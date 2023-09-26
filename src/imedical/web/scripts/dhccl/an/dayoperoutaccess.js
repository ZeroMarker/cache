
var EpisodeID=dhccl.getUrlParam("EpisodeID"),
    opaId=dhccl.getUrlParam("opaId");
	//alert(EpisodeID+"/"+opaId)

$(function(){
	InitForm();
	if(EpisodeID!="")
	{
		loadDatas();
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
        ClassName:"web.DHCANOPArrangeDayOper",
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
	//---------------    
   	var operInfo=appList[1];
	var operInfoList=operInfo.split("^");
    var anDocMethodStr=operInfoList[0];
    var anDocMethodIdStr=getIdStr(anDocMethodStr)
    $("#PrevAnaMethod").combobox('setValues',anDocMethodIdStr);
     $("#PatPreOper").val(operInfoList[1]);
    $("#PatPreDiag").val(operInfoList[2]);
    
    var otherInfo=appList[4];
    var otherInfoList=otherInfo.split("^");
    var post01=otherInfoList[0];
    var post02=otherInfoList[1];
    var post03=otherInfoList[2];
    var post04=otherInfoList[3];
    var post05=otherInfoList[4];
    var post06=otherInfoList[5];
    var post07=otherInfoList[6];
    var post08=otherInfoList[7];
    $("#ODS_VitalSignScore").combobox('setValue',post01);
	$("#ODS_MoveScore").combobox('setValue',post02);
	$("#ODS_VomitScore").combobox('setValue',post03);
	$("#ODS_PainScore").combobox('setValue',post04);
	$("#ODS_BleedingScore").combobox('setValue',post05);
	$("#ODS_OutScore").val(post06);
	$("#ODS_OtherNote").val(post07);
	$("#ASAClass").combobox('setValue',post08);
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
		//初始化拟施麻醉combox	
	var objPrevAnaMethod=$HUI.combobox("#PrevAnaMethod",{
		url:$URL+"?ClassName=web.DHCANOPArrangeHISUI&QueryName=FindAnaestMethod&ResultSetType=array",
		valueField:'ID',
		textField:'Des',
		multiple:true,
		onBeforeLoad:function(param){
			param.anmethod=param.q;
		},
		onLoadSuccess:function(data) {
			    }
		,mode: "remote"	
	});
    $("#btnCancel").linkbutton({
        onClick: closeWindow
    });
    $("#btnSave").linkbutton({
        onClick: saveOperExtendInfo
    });

    //
    $("#ODS_VitalSignScore").combobox('setValue',"");
	$("#ODS_MoveScore").combobox('setValue',"");
	$("#ODS_VomitScore").combobox('setValue',"");
	$("#ODS_PainScore").combobox('setValue',"");
	$("#ODS_BleedingScore").combobox('setValue',"");
	$("#ODS_OutScore").val("");
    
	}
//保存麻醉术前评估信息
function saveOperExtendInfo()
{
	var str=""
	var ODS_OtherNote=$("#ODS_OtherNote").val();
	var ODS_VitalSignScore=$("#ODS_VitalSignScore").combobox('getValue');
	var ODS_MoveScore=$("#ODS_MoveScore").combobox('getValue');
	var ODS_VomitScore=$("#ODS_VomitScore").combobox('getValue');
	var ODS_PainScore=$("#ODS_PainScore").combobox('getValue');
	var ODS_BleedingScore=$("#ODS_BleedingScore").combobox('getValue');
	var ODS_OutScore=$("#ODS_OutScore").val();
	str="ODS_VitalSignScore:"+ODS_VitalSignScore+"^"+"ODS_MoveScore:"+ODS_MoveScore
	+"^"+"ODS_VomitScore:"+ODS_VomitScore+"^"+"ODS_PainScore:"+ODS_PainScore
	+"^"+"ODS_BleedingScore:"+ODS_BleedingScore+"^"+"ODS_OutScore:"+ODS_OutScore
	+"^"+"ODS_OtherNote:"+ODS_OtherNote
	var datas=$.m({
        ClassName:"web.DHCANOPArrangeDayOper",
        MethodName:"SaveDayOperInfo",
        opaId:opaId,
        preStr:str,
        userId:session['LOGON.USERID']
    },false);
    if(datas!=0)
    {
	    $.messager.alert("提示", "评估失败"+datas, 'error');
	    return
    }
    else
    {
	    $.messager.alert("提示", "评估成功", 'info');
    }

}
//关闭窗口
function closeWindow(){
    window.close();
}
//获取选择的拟施麻醉方法
function getPrevAnaMethods(){
    var anaMethodArray = $("#PrevAnaMethod").combobox("getValues"),
        anaMethod="";
    if(anaMethodArray&&anaMethodArray.length>0)
    {
        anaMethod= anaMethodArray.join(",");
    }
    return anaMethod;
}
function setnewScore()
{
	var ODS_VitalSignScore=$("#ODS_VitalSignScore").combobox('getValue');
	var ODS_MoveScore=$("#ODS_MoveScore").combobox('getValue');
	var ODS_VomitScore=$("#ODS_VomitScore").combobox('getValue');
	var ODS_PainScore=$("#ODS_PainScore").combobox('getValue');
	var ODS_BleedingScore=$("#ODS_BleedingScore").combobox('getValue');
	var totalScore="";
	if((ODS_VitalSignScore!=" ")&&(ODS_MoveScore!=" ")&&(ODS_VomitScore!=" ")&&(ODS_PainScore!=" ")&&(ODS_BleedingScore!=" "))
	{
	totalScore=parseInt(parseInt(ODS_VitalSignScore)+parseInt(ODS_MoveScore)+parseInt(ODS_VomitScore)+parseInt(ODS_PainScore)+parseInt(ODS_BleedingScore));
	$("#ODS_OutScore").val(totalScore);
	}
}