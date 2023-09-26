
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
    
    var otherInfo=appList[3];
    var otherInfoList=otherInfo.split("^");
    var post01=otherInfoList[0];
    var post02=otherInfoList[1];
    var post03=otherInfoList[2];
    var post04=otherInfoList[3];
    var post05=otherInfoList[4];
    var post06=otherInfoList[5];
    var post07=otherInfoList[6];
    var post08=otherInfoList[7];
    $("#PDS_MoveScore").combobox('setValue',post01);
	$("#PDS_RespScore").combobox('setValue',post02);
	$("#PDS_CircleScore").combobox('setValue',post03);
	$("#PDS_CondciousScore").combobox('setValue',post04);
	$("#PDS_SPO2Score").combobox('setValue',post05);
	$("#PDS_AldreteScore").val(post06);
	$("#PDS_OtherNote").val(post07);
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
	var movescore=$HUI.combobox("#PDS_MoveScore",{
        valueField:"typecode",
        textField:"typedesc",
        editable:false,
        panelHeight:'auto',
        data:[{'typedesc':"能够自主或根据指令移动四肢(四级2分)",'typecode':"2"}
        ,{'typedesc':"自主或根据指令移动两个肢体(二级1分)",'typecode':"1"}
        ,{'typedesc':"不能自主或根据指令移动肢体(零级0分)",'typecode':"0"}
        ]
    }) 
    var repscore=$HUI.combobox("#PDS_RespScore",{
        valueField:"typecode",
        textField:"typedesc",
        editable:false,
        panelHeight:'auto',
        data:[{'typedesc':"可深呼吸和随意咳嗽(2分)",'typecode':"2"}
        ,{'typedesc':"呼吸宭迫或呼吸受限(1分)",'typecode':"1"}
        ,{'typedesc':"无呼吸(0分)",'typecode':"0"}
        ]
    }) 
    var cirscore=$HUI.combobox("#PDS_CircleScore",{
        valueField:"typecode",
        textField:"typedesc",
        editable:false,
        panelHeight:'auto',
        data:[{'typedesc':"±20%以内(2分)",'typecode':"2"}
        ,{'typedesc':"±20%～49%(1分)",'typecode':"1"}
        ,{'typedesc':"±50%以上(0分)",'typecode':"0"}
        ]
    }) 
    var spo2score=$HUI.combobox("#PDS_SPO2Score",{
        valueField:"typecode",
        textField:"typedesc",
        editable:false,
        panelHeight:'auto',
        data:[{'typedesc':"吸空气血氧饱和度≥92%(2分)",'typecode':"2"}
        ,{'typedesc':"需吸氧才能维持血氧饱和度≥90%(1分)",'typecode':"1"}
        ,{'typedesc':"吸氧条件下血氧饱和度仍小于90%(0分)",'typecode':"0"}
        ]
    }) 
    var conscore=$HUI.combobox("#PDS_CondciousScore",{
        valueField:"typecode",
        textField:"typedesc",
        editable:false,
        panelHeight:'auto',
        data:[{'typedesc':"完全清醒(2分)",'typecode':"2"}
        ,{'typedesc':"嗜睡但可被叫醒(1分)",'typecode':"1"}
        ,{'typedesc':"对刺激无反应(0分)",'typecode':"0"}
        ]
    }) 
    
    $("#btnCancel").linkbutton({
        onClick: closeWindow
    });
    $("#btnSave").linkbutton({
        onClick: saveOperExtendInfo
    });
    
    //
    $("#PDS_MoveScore").combobox('setValue',"");
	$("#PDS_RespScore").combobox('setValue',"");
	$("#PDS_CircleScore").combobox('setValue',"");
	$("#PDS_CondciousScore").combobox('setValue',"");
	$("#PDS_SPO2Score").combobox('setValue',"");
	$("#PDS_AldreteScore").val("");
    
	}
//保存麻醉术前评估信息
function saveOperExtendInfo()
{
	var str=""
	var PDS_OtherNote=$("#PDS_OtherNote").val();
	var PDS_MoveScore=$("#PDS_MoveScore").combobox('getValue');
	var PDS_RespScore=$("#PDS_RespScore").combobox('getValue');
	var PDS_CircleScore=$("#PDS_CircleScore").combobox('getValue');
	var PDS_CondciousScore=$("#PDS_CondciousScore").combobox('getValue');
	var PDS_SPO2Score=$("#PDS_SPO2Score").combobox('getValue');
	var PDS_AldreteScore=$("#PDS_AldreteScore").val();
	str="PDS_MoveScore:"+PDS_MoveScore+"^"+"PDS_RespScore:"+PDS_RespScore
	+"^"+"PDS_CircleScore:"+PDS_CircleScore+"^"+"PDS_CondciousScore:"+PDS_CondciousScore
	+"^"+"PDS_SPO2Score:"+PDS_SPO2Score+"^"+"PDS_AldreteScore:"+PDS_AldreteScore
	+"^"+"PDS_OtherNote:"+PDS_OtherNote
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
	var PDS_MoveScore=$("#PDS_MoveScore").combobox('getValue');
	var PDS_RespScore=$("#PDS_RespScore").combobox('getValue');
	var PDS_CircleScore=$("#PDS_CircleScore").combobox('getValue');
	var PDS_CondciousScore=$("#PDS_CondciousScore").combobox('getValue');
	var PDS_SPO2Score=$("#PDS_SPO2Score").combobox('getValue');
	var totalScore="";
	//
	if((PDS_MoveScore!=" ")&&(PDS_RespScore!=" ")&&(PDS_CircleScore!=" ")&&(PDS_CondciousScore!=" ")&&(PDS_SPO2Score!=" "))
	{
	totalScore=parseInt(parseInt(PDS_MoveScore)+parseInt(PDS_RespScore)+parseInt(PDS_CircleScore)+parseInt(PDS_SPO2Score)+parseInt(PDS_CondciousScore));
	$("#PDS_AldreteScore").val(totalScore);
	}
}