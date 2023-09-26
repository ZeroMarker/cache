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
	
	$.messager.defaults = {  width:400,height:300, resizable:true,ok:'��',cancel:'��' }; 
})

//��ʼ���ؼ�
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
//��ʼ�����
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
                { field: "oproomdes", title: "������", width: 120 },
                { field: "opordno", title: "̨��", width: 60 },
                { field: "locdes", title: "����", width: 120 },
                { field: "bedCode", title: "����", width: 60 },
                { field: "patName", title: "����", width: 120 },
                { field: "sex", title: "�Ա�", width: 60 },
                { field: "age", title: "����", width: 60 },
                { field: "regNo", title: "�ǼǺ�", width: 120 },
                { field: "opdes", title: "��������", width: 280 },
                { field: "inRoom", title: "��������ʱ��", width: 140 },
                { field: "inRoomRecorder", title: "���Һ˲���Ա", width: 120 },
                { field: "outRoom", title: "��������ʱ��", width: 140 },
                { field: "outRoomRecorder", title: "���Һ˲���Ա", width: 120 },
                { field: "outArea", title: "��������ʱ��", width: 140 ,hidden:true},
                { field: "Status", title: "״̬", width: 60 },
                { field: "jzstat", title: "����", width: 60 },
                { field: "diag", title: "��ǰ���", width: 180 },
                { field: "opdate", title: "��������", width: 140 },
                { field: "opd", title: "����", width: 80 },
                { field: "patWard", title: "����", width: 180 },
                { field: "medCareNo", title: "סԺ��", width: 80 },
                { field: "opaId", title: "������", width: 60 },
                { field: "EpisodeID", title: "�����", width: 80 },
                { field: "inArea", title: "��������ʱ��", width: 140 ,hidden:true},
                { field: "inPACU", title: "��PACUʱ��", width: 140 ,hidden:true },
                { field: "outPACU", title: "��PACUʱ��", width: 140 ,hidden:true },
                
               
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
			 		$.messager.alert('��ʾ',GetReceiveStatRet,'warning');
			 		return false;
				}
				var msgTitle="���Һ˲�ȷ��";
				if(type=="OutRoom") msgTitle="���Һ˲�ȷ��";
				var message='<table style="white-space:nowrap;"><tr><td>������:</td><td>'+oproomdes+'&nbsp;&nbsp;</td><td>̨��:</td><td>'+opordno+'</td></tr>';
				message+='<tr><td>����:</td><td>'+locdes+'&nbsp;&nbsp;</td><td>����:</td><td>'+bedCode+'</td></tr>';
				message+='<tr><td>��������:</td><td>'+patName+'&nbsp;&nbsp;</td><td>�Ա�:</td><td>'+sex+'&nbsp;&nbsp;</td></tr>'
				message+='<tr><td>סԺ��:</td><td>'+medCareNo+'&nbsp;&nbsp;</td><td>����:</td><td>'+age+'</td></tr>';
				message+='<tr><td>�ǼǺ�:</td><td>'+regNo+'</td></tr>';
				message+='<tr><td>����ʽ:</td><td colspan=3>'+anmethod+'</td></tr>';
				message+='<tr><td>��������:</td><td colspan=3 style="white-space:normal;">'+opdes+'</td></tr>'
				message+='<tr><td>������λ:</td><td colspan=3>'+bodsDesc+'</td></tr>';
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
							$.messager.alert('��ʾ',"�˲�ɹ�",'warning');
							$("#RegNo").val("");
							$("#PatInOutRoomBox").datagrid('reload');
						}		
					}
				});	
	   		 }
    		else
    		{
	    		$.messager.alert('��ʾ','���޴���','warning');
				return;
	    	}
	    });
	}
}


