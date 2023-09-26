var type=dhccl.getUrlParam("type");
var logUserId=session['LOGON.USERID'],
    logGroupId=session['LOGON.GROUPID'],
    logLocId=session['LOGON.CTLOCID'];
var InAreaFlag=0,
	InRoomFlag=1,
	InPACUFlag=0,
	OutPACUFlag=0,
	OutRoomFlag=0,
	OutAreaFlag=0;
$(function(){
	
	InitControls();
	
	InitDataGrid();
	
	InitEvents();
	
	$.messager.defaults = {  width:400,height:300, resizable:true,ok:'是',cancel:'否' }; 
})

//初始化控件
function InitControls(){
	var curDate=$.m({
        ClassName:"web.DHCANOPCom",
        MethodName:"GetInitialDate",
        userId:logUserId,
        userGroupId:"", 
        ctlocId:logLocId
    },false);
	//$("#DateFrom").datebox('setValue',curDate);
    //$("#DateTo").datebox('setValue',curDate);
    $("#OperDate").datebox('setValue',curDate);
    
    $("#OperRoom").combobox({
        url:$URL+"?ClassName=web.UDHCANOPArrange&QueryName=FindAncOperRoom&ResultSetType=array",
        panelHeight:"auto",
        valueField:"oprId",
        textField:"oprDesc",
        onBeforeLoad:function(param)
        {
            param.oprDesc=param.q;
            param.locDescOrId="";
            param.locListCodeStr="OP^OUTOP^EMOP";
            param.EpisodeID="";
            param.opaId="";
            param.oprBedType="T";
            param.appLocDescOrId=logLocId;
        }
    });
    
    $("#InRoom").radio('setValue',true);
	$("#OutRoom").radio('setDisable',true);
    if(type=="OutRoom") 
	{
		$("#OutRoom").radio('setValue',true);
		$("#OutRoom").radio('setDisable',false);
		$("#InRoom").radio('setDisable',true);
	}
}
//初始化表格
function InitDataGrid(){
	$("#PatInOutRoomBox").datagrid({
		fit:true,
		singleSelect: true,
        nowrap: true,
        rownumbers: true,
        pagination: true,
        pageSize: 200,
        pageList: [50, 100, 200],
        url:$URL,
        queryParams:{
            ClassName:"web.DHCANArrange",
            QueryName:"GetOpInfoList"
        },
        onBeforeLoad:function(param){
	   		//param.sDate=$("#DateFrom").datebox('getValue'),
			//param.eDate=$("#DateTo").datebox('getValue'),
			param.opDate=$("#OperDate").datebox('getValue'),
			param.registerNo=$("#RegNo").val(),
			param.operRoomId=$("#OperRoom").combobox('getValue'),
			param.inRoomFlag=$("#InRoom").radio('getValue')?1:0,
			param.outRoomFlag=$("#OutRoom").radio('getValue')?1:0
	   	},
        columns:[[
                { field: "oproomdes", title: "手术间", width: 120 },
                { field: "opordno", title: "台次", width: 60 },
                { field: "locdes", title: "科室", width: 120 },
                { field: "bedCode", title: "床号", width: 60 },
                { field: "patName", title: "姓名", width: 120 },
                { field: "sex", title: "性别", width: 60 },
                { field: "age", title: "年龄", width: 60 },
                { field: "regNo", title: "登记号", width: 120 },
                { field: "opdes", title: "手术名称", width: 280 },
                { field: "inRoom", title: "入手术间时间", width: 140 },
                { field: "inRoomRecorder", title: "入室核查人员", width: 120 },
                { field: "outRoom", title: "出手术间时间", width: 140 },
                { field: "outRoomRecorder", title: "出室核查人员", width: 120 },
                { field: "outArea", title: "出手术区时间", width: 140 ,hidden:true},
                { field: "Status", title: "状态", width: 60 },
                { field: "jzstat", title: "类型", width: 60 },
                { field: "diag", title: "术前诊断", width: 180 },
                { field: "opdate", title: "手术日期", width: 140 },
                { field: "opd", title: "主刀", width: 80 },
                { field: "patWard", title: "病区", width: 180 },
                { field: "medCareNo", title: "住院号", width: 80 },
                { field: "opaId", title: "手术号", width: 60 },
                { field: "EpisodeID", title: "就诊号", width: 80 },
                { field: "inArea", title: "入手术区时间", width: 140 ,hidden:true},
                { field: "inPACU", title: "入PACU时间", width: 140 ,hidden:true },
                { field: "outPACU", title: "出PACU时间", width: 140 ,hidden:true },
                
               
        ]]
	})
}

function InitEvents(){
	$("#btnSearch").click(function(){
		$("#PatInOutRoomBox").datagrid('load');	
	})
}

function RegKeyDown()
{
	if(window.event.keyCode==13)
	{
		var newregno=$.m({
        	ClassName:"web.DHCDTHealthCommon",
        	MethodName:"FormatPatientNo",
        	PatientNo:$("#RegNo").val()
    	},false);
		$("#RegNo").val(newregno);		
		$.m({
        	ClassName:"web.DHCANArrange",
        	MethodName:"GetOpaIdByRegNo",
        	opDate:$("#OperDate").datebox('getValue'),
        	registerNo:newregno
    	},function(operId){
	    	if(operId>0)
    		{
	    		var operInfo=$.m({
        			ClassName:"web.DHCANArrange",
        			MethodName:"GetOperInfoByOpaId",
        			opaId:operId
    			},false);
    			//console.log(operInfo.split("^"))
    			var oproomId=operInfo.split("^")[0],
    				oproomdes=operInfo.split("^")[1],
	   				opordno=operInfo.split("^")[2],
	    			patName=operInfo.split("^")[3],
	    			sex=operInfo.split("^")[4],
	    			age=operInfo.split("^")[5],
	    			medCareNo=operInfo.split("^")[6],
	    			regNo=operInfo.split("^")[7],
	    			locdes=operInfo.split("^")[8],
	    			bedCode=operInfo.split("^")[9];
	    			anmethod=operInfo.split("^")[10];
	    			opdes=operInfo.split("^")[11];
	    			bodsDesc=operInfo.split("^")[12];
	    			
	    
	    		var GetReceiveStatRet=$.m({
        			ClassName:"web.DHCANOPArrange",
        			MethodName:"GetEditStat",
        			opaId:operId,
        			opRoomId:oproomId
    			},false);
    			if(GetReceiveStatRet!="1") 
				{
			 		$.messager.alert('提示',GetReceiveStatRet,'warning');
			 		return false;
				}
				var msgTitle="入室核查确认";
				if(type=="OutRoom") msgTitle="离室核查确认";
				var message='<table style="white-space:nowrap;"><tr><td>手术间:</td><td>'+oproomdes+'&nbsp;&nbsp;</td><td>台次:</td><td>'+opordno+'</td></tr>';
				message+='<tr><td>科室:</td><td>'+locdes+'&nbsp;&nbsp;</td><td>床号:</td><td>'+bedCode+'</td></tr>';
				message+='<tr><td>病人姓名:</td><td>'+patName+'&nbsp;&nbsp;</td><td>性别:</td><td>'+sex+'&nbsp;&nbsp;</td></tr>'
				message+='<tr><td>住院号:</td><td>'+medCareNo+'&nbsp;&nbsp;</td><td>年龄:</td><td>'+age+'</td></tr>';
				message+='<tr><td>登记号:</td><td>'+regNo+'</td></tr>';
				message+='<tr><td>麻醉方式:</td><td colspan=3>'+anmethod+'</td></tr>';
				message+='<tr><td>手术名称:</td><td colspan=3 style="white-space:normal;">'+opdes+'</td></tr>'
				message+='<tr><td>手术部位:</td><td colspan=3>'+bodsDesc+'</td></tr>';
				message+='</table>';
	    		$.messager.confirm(msgTitle,message,function(r){	
					if(r)
					{ 
						var flagStr="0^1^0^0^0^0";
						if(type=="OutRoom")  flagStr="0^0^0^0^1^0";
						var result=$.m({
        					ClassName:"web.DHCANArrange",
        					MethodName:"CheckInAreaDateTime",
        					opaId:operId,
        					patSite:flagStr
    					},false);
    					if(result!=0) alert(result)
						else 
						{
							$.messager.alert('提示',"核查成功",'warning');
							$("#RegNo").val("");
							$("#PatInOutRoomBox").datagrid('reload');
						}		
					}
				});	
	   		 }
    		else
    		{
	    		$.messager.alert('提示','查无此人','warning');
				return;
	    	}
	    });
	}
}


