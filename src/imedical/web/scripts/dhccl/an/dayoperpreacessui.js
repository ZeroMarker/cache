
var EpisodeID=dhccl.getUrlParam("EpisodeID"),
    opaId=dhccl.getUrlParam("opaId");

$(function(){
	InitForm();
	if(EpisodeID!="")
	{
	     var validStr=$.m({
            ClassName:"web.DHCANAdaptor",
            MethodName:"CheckValidDayOper",
            AdmId:EpisodeID
        },false);
        var newvalidstr=validStr.split("^");
        if((newvalidstr[0]=="Y")&&newvalidstr[1]=="A")
        {
	       $.messager.alert("提示","该日间申请已确认，无法修改术前麻醉评估信息！","error");
	      	$("#btnSave").linkbutton("disable");
        }
		loadDatas();
	}
});
function loadDatas()
{
	var patInfo=getPatInfo();
	
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
    if(anDocMethodIdStr!="")
    {
    $("#PrevAnaMethod").combobox('setValues',anDocMethodIdStr);
    }
     $("#PatPreOper").val(operInfoList[1]);
    $("#PatPreDiag").val(operInfoList[2]);
    
    var otherInfo=appList[2];
    var otherInfoList=otherInfo.split("^");
    //alert(otherInfoList)
    var pre01=otherInfoList[0];
    if(pre01=="Y") $("#BDS_ASAIVOrV").checkbox('setValue',true);
    
    var pre02=otherInfoList[1];
    if(pre02=="Y") $("#BDS_ChildInDanger").checkbox('setValue',true);
    
    var pre03=otherInfoList[2];
    if(pre03=="Y") $("#BDS_LossMoreBlood").checkbox('setValue',true);

    var pre04=otherInfoList[3];
    if(pre04=="Y") $("#BDS_Disease").checkbox('setValue',true);
    
    var pre05=otherInfoList[4];
    if(pre05=="Y") $("#BDS_RespiaratDif").checkbox('setValue',true);
    
    var pre06=otherInfoList[5];
    if(pre06=="Y") $("#BDS_BreathDif").checkbox('setValue',true);
    
    var pre07=otherInfoList[6];
    if(pre07=="Y") $("#BDS_LongRFatAndSleep").checkbox('setValue',true);
    
    var pre08=otherInfoList[7];
    if(pre08=="Y") $("#BDS_DrugAddiction").checkbox('setValue',true);
    
    var pre09=otherInfoList[8];
    if(pre09=="Y") $("#BDS_BipolarDisorder").checkbox('setValue',true);
    
    var pre10=otherInfoList[9];
    if(pre10=="Y") $("#BDS_NoCompanion").checkbox('setValue',true);
    
    var pre11=otherInfoList[10];
    $("#BDS_IsCanDayOper").combobox('setValue',pre11);

    var pre12=otherInfoList[11];
    $("#BDS_OtherNote").val(pre12);

    var pre13=otherInfoList[12];
    $("#Pre_Height").val(pre13);
    
    var pre14=otherInfoList[13];
    $("#Pre_Weight").val(pre14);
    
    var pre15=otherInfoList[14];
    $("#Pre_Pulse").val(pre15);
    
    var pre16=otherInfoList[15];
    $("#Pre_Respiration").val(pre16);
    
    var pre17=otherInfoList[16];
    $("#Pre_BP").val(pre17);
    
    var pre18=otherInfoList[17];
     $("#ASAClass").combobox('setValue',pre18);

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
		//初始化拟施麻醉combox	
	var objPrevAnaMethod=$HUI.combobox("#PrevAnaMethod",{
		url:$URL+"?ClassName=web.DHCANOPArrangeHISUI&QueryName=FindAnaestMethod&ResultSetType=array",
		valueField:'ID',
		textField:'Des',
		multiple:true,
		editable:false,
		onBeforeLoad:function(param){
			param.anmethod=param.q;
		},
		onLoadSuccess:function(data) {
			    }
		,mode: "remote"	
	});
	var asa=$HUI.combobox("#ASAClass",{
        valueField:"typecode",
        textField:"typedesc",
        editable:false,
        panelHeight:'auto',
        data:[{'typedesc':"I",'typecode':"I"}
        ,{'typedesc':"II",'typecode':"II"}
        ,{'typedesc':"III",'typecode':"III"}
        ,{'typedesc':"IV",'typecode':"IV"}
        ,{'typedesc':"V",'typecode':"V"}
        ,{'typedesc':"VI",'typecode':"VI"}
        ]
    }) 
    var yesno=$HUI.combobox("#BDS_IsCanDayOper",{
        valueField:"typecode",
        textField:"typedesc",
        editable:false,
        panelHeight:'auto',
        data:[{'typedesc':"是",'typecode':"Y"},{'typedesc':"否",'typecode':"N"}]
    }) 
    $("#btnCancel").linkbutton({
        onClick: closeWindow
    });
    $("#btnSave").linkbutton({
        onClick: saveOperExtendInfo
    });
	}
//保存麻醉术前评估信息
function saveOperExtendInfo()
{
	var str=""
	var anaMethod=getPrevAnaMethods();
	var anaClassId=$HUI.combobox("#ASAClass").getValue();
	var BDS_ASAIVOrV=$("#BDS_ASAIVOrV").checkbox('getValue')?"Y":"N";
	var BDS_ChildInDanger=$("#BDS_ChildInDanger").checkbox('getValue')?"Y":"N";
	var BDS_LossMoreBlood=$("#BDS_LossMoreBlood").checkbox('getValue')?"Y":"N";
	var BDS_Disease=$("#BDS_Disease").checkbox('getValue')?"Y":"N";
	var BDS_RespiaratDif=$("#BDS_RespiaratDif").checkbox('getValue')?"Y":"N";
	var BDS_BreathDif=$("#BDS_BreathDif").checkbox('getValue')?"Y":"N";
	var BDS_LongRFatAndSleep=$("#BDS_LongRFatAndSleep").checkbox('getValue')?"Y":"N";
	var BDS_DrugAddiction=$("#BDS_DrugAddiction").checkbox('getValue')?"Y":"N";
	var BDS_BipolarDisorder=$("#BDS_BipolarDisorder").checkbox('getValue')?"Y":"N";
	var BDS_NoCompanion=$("#BDS_NoCompanion").checkbox('getValue')?"Y":"N";
	var BDS_OtherNote=$("#BDS_OtherNote").val();
	var BDS_IsCanDayOper=$("#BDS_IsCanDayOper").combobox('getValue');
	if(BDS_IsCanDayOper=="")
	{
		$.messager.alert("提示","请选择是否适合日间手术！","error");
		return;
	}
	var Height=$("#Pre_Height").val();
	var Weight=$("#Pre_Weight").val();
	var Pre_Pulse=$("#Pre_Pulse").val();
	var Pre_Respiration=$("#Pre_Respiration").val();
	var Pre_BP=$("#Pre_BP").val();
	str="BDS_ASAIVOrV:"+BDS_ASAIVOrV+"^"+"BDS_ChildInDanger:"+BDS_ChildInDanger+"^"+"BDS_LossMoreBlood:"+BDS_LossMoreBlood
	+"^"+"BDS_Disease:"+BDS_Disease+"^"+"BDS_RespiaratDif:"+BDS_RespiaratDif+"^"+"BDS_BreathDif:"+BDS_BreathDif
	+"^"+"BDS_LongRFatAndSleep:"+BDS_LongRFatAndSleep+"^"+"BDS_DrugAddiction:"+BDS_DrugAddiction+"^"+"BDS_BipolarDisorder:"+BDS_BipolarDisorder
	+"^"+"BDS_NoCompanion:"+BDS_NoCompanion+"^"+"BDS_IsCanDayOper:"+BDS_IsCanDayOper+"^"+"BDS_OtherNote:"+BDS_OtherNote
	+"^"+"Pre_Height:"+Height+"^"+"Pre_Weight:"+Weight+"^"+"Pre_Pulse:"+Pre_Pulse
	+"^"+"Pre_Respiration:"+Pre_Respiration+"^"+"Pre_BP:"+Pre_BP+"^"+"BDS_IsAnAudit:"+"Y"
	+"^"+"BDS_AnAuditUserId:"+session['LOGON.USERID']+"^"+"ASAClass:"+anaClassId
	var datam=$.m({
        ClassName:"web.DHCANOPArrangeDayOper",
        MethodName:"SaveDayOperANMInfo",
        opaId:opaId,
        anmth:anaMethod,
        userId:session['LOGON.USERID']
    },false);
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
	    //alert(datas);
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
