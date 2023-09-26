var logUserId=session['LOGON.USERID'],
    logGroupId=session['LOGON.GROUPID'],
    logLocId=session['LOGON.CTLOCID'];

$(function(){
	initControls();
	setDefaultValue();
	initDataGrid();
	initEvents();
})

function initControls(){
	 var appLoc=$HUI.combobox("#AppLoc",{
        url:$URL+"?ClassName=web.DHCClinicCom&QueryName=FindLocList&ResultSetType=array",
        valueField:"ctlocId",
        textField:"ctlocDesc",
        onBeforeLoad:function(param)
        {
            param.desc=param.q;
            param.locListCodeStr="INOPDEPT^OUTOPDEPT^EMOPDEPT";
            param.EpisodeID="";
        }   
    });
    var patWard=$HUI.combobox("#PatWard",{
        url:$URL+"?ClassName=web.DHCClinicCom&QueryName=GetWard&ResultSetType=array",
        valueField:"rw",
        textField:"desc",
        onBeforeLoad:function(param)
        {
            param.code=param.q;
        }
    });
    var operStat=$HUI.combobox("#OperStat",{
        url:$URL+"?ClassName=web.DHCClinicCom&QueryName=LookUpComCode&ResultSetType=array",
        valueField:"tCode",
        textField:"tDesc",
        onBeforeLoad:function(param)
        {
            param.type="OpaStatus";
        }
    });
    var OperType=$HUI.combobox("#OperType",{
        valueField:"typecode",
        textField:"typedesc",
        data:[{'typedesc':"ȫ��",'typecode':"A"},{'typedesc':"����",'typecode':"B"},{'typedesc':"����",'typecode':"E"}]
    })

    var operRoom=$HUI.combobox("#OperRoom",{
        url:$URL+"?ClassName=web.DHCANOPArrangeHISUI&QueryName=FindAncOperRoom&ResultSetType=array",
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
            param.appLocDescOrId=appLoc.getValue();
        }
    });
}

function setDefaultValue(){
	var dateFrom=$.m({
        ClassName:"web.DHCANOPCom",
        MethodName:"GetInitialDate",
        userId:logUserId,
        userGroupId:"", 
        ctlocId:logLocId
    },false);
    var dateTo=$.m({
        ClassName:"web.DHCANOPCom",
        MethodName:"GetInitialDateOld",
        userId:logUserId,
        userGroupId:"", 
        ctlocId:logLocId
    },false);
    $("#DateFrom").datebox('setValue',dateFrom);
    $("#DateTo").datebox('setValue',dateTo);
}

function initEvents(){
	$("#btnSearch").click(function(){
        $HUI.datagrid("#OperationListBox").load();
    });
    
    $("#ReceviceSure").bind('click',function(){
	    if ($(this).linkbutton('options').disabled == true) return;
	    var row=$("#OperationListBox").datagrid('getSelected');
	    if(row)
	    {
		    var opaId=row.opaId;
		    var receiveAssTime=row.receiveAssTime;
		    if(receiveAssTime!="")
			{
				$.messager.alert("��ʾ","�Ӳ��˻�������ʱ����ȷ�ϣ������ظ�ȷ�ϣ�","warning");
				return;
			}
			var ret=$.cm({
				ClassName:"web.DHCANOPTransfer",
				MethodName:"insertReceiveAss",
				opaId:opaId,
				userId:logUserId
			},false)
			if(ret==0)
			{
				$.messager.alert("��ʾ","�Ӳ��˻�������ȷ�ϳɹ���","info");
				$("#OperationListBox").datagrid('reload');
			}else{
				$.messager.alert("��ʾ",ret,"waring");
				return;
			}
		}else{
			$.messager.alert("��ʾ","��ѡ��һ�����˵�����Ϣ��","warning");
			return;
		}
    });
	$("#PatInRoom").bind('click',function(){
	    if ($(this).linkbutton('options').disabled == true) return;
		var row=$("#OperationListBox").datagrid('getSelected');
	    if(row)
	    {
		    var opaId=row.opaId;
		    var receiveBackTime=row.receiveBackTime;
		    if(receiveBackTime!="")
			{
				$.messager.alert("��ʾ","����������ȷ�ϣ������ظ�ȷ�ϣ�","warning");
				return;
			}
			var ret=$.cm({
				ClassName:"web.DHCANOPTransfer",
				MethodName:"insertPatInRoom",
				opaId:opaId,
				userId:logUserId
			},false)
			if(ret==0)
			{
				$.messager.alert("��ʾ","��������ȷ�ϳɹ���","info");
				$("#OperationListBox").datagrid('reload');
			}else{
				$.messager.alert("��ʾ",ret,"waring");
				return;
			}
		}else{
			$.messager.alert("��ʾ","��ѡ��һ�����˵�����Ϣ��","warning");
			return;
		}
	});
	$("#SendSure").bind('click',function(){
	    if ($(this).linkbutton('options').disabled == true) return;
		var row=$("#OperationListBox").datagrid('getSelected');
	    if(row)
	    {
		    var opaId=row.opaId;
		    var sendAssTime=row.sendAssTime;
		    if(sendAssTime!="")
			{
				$.messager.alert("��ʾ","�Ͳ��˻�������ʱ����ȷ�ϣ������ظ�ȷ�ϣ�","warning");
				return;
			}
			var ret=$.cm({
				ClassName:"web.DHCANOPTransfer",
				MethodName:"insertSendAss",
				opaId:opaId,
				userId:logUserId
			},false)
			if(ret==0)
			{
				$.messager.alert("��ʾ","�Ͳ��˻�������ʱ��ȷ�ϳɹ���","info");
				$("#OperationListBox").datagrid('reload');
			}else{
				$.messager.alert("��ʾ",ret,"waring");
				return;
			}
		}else{
			$.messager.alert("��ʾ","��ѡ��һ�����˵�����Ϣ��","warning");
			return;
		}
	});
	$("#PatOutRoom").bind('click',function(){
	    if ($(this).linkbutton('options').disabled == true) return;
		var row=$("#OperationListBox").datagrid('getSelected');
	    if(row)
	    {
		    var opaId=row.opaId;
		    var sendBackTime=row.sendBackTime;
		    if(sendBackTime!="")
			{
				$.messager.alert("��ʾ","��������ʱ����ȷ�ϣ������ظ�ȷ�ϣ�","warning");
				return;
			}
			var ret=$.cm({
				ClassName:"web.DHCANOPTransfer",
				MethodName:"insertPatOutRoom",
				opaId:opaId,
				userId:logUserId
			},false)
			if(ret==0)
			{
				$.messager.alert("��ʾ","��������ʱ��ȷ�ϳɹ���","info");
				$("#OperationListBox").datagrid('reload');
			}else{
				$.messager.alert("��ʾ",ret,"waring");
				return;
			}
		}else{
			$.messager.alert("��ʾ","��ѡ��һ�����˵�����Ϣ��","warning");
			return;
		}
	});
}

function initDataGrid(){
	var logLocType=getLogLocType();
	$("#OperationListBox").datagrid({
		fit:true,
        rownumbers: true,
        singleSelect:true,
        pagination: true,
        pageSize: 200,
        pageList: [50, 100, 200],
        headerCls:'panel-header-gray',
        toolbar:"#tb",
        url:$URL,
        queryParams:{
            ClassName:"web.DHCANOPTransfer",
            QueryName:"GetANOPTransferList"
        },
        onBeforeLoad:function(param)
        {
	        param.stdate=$("#DateFrom").datebox('getValue');
	        param.enddate=$("#DateTo").datebox('getValue');
	        param.stat=$("#OperStat").combobox('getValue');
	        param.oproom=$("#OperRoom").combobox('getValue');
	        param.Dept=$("#AppLoc").combobox('getValue');
	        param.MedCareNo=$("#MedCareNo").val();
	        param.NurWardId=$("#PatWard").combobox('getValue');
	        param.operType=$("#OperType").combobox('getValue');
	        param.ifAllLoc=($("#IfAllLoc").checkbox('getValue')==true)?'Y':'N';
	        param.EpisodeID="";
        },
        columns:[
        [
        	{ field: "oproomdes", title: "����", width: 80 },
        	{ field: "opaId", title: "������", width: 60 },
        	{ field: "patName", title: "����", width: 80 },
        	{ field: "age", title: "����", width: 50 },
        	{ field: "sex", title: "�Ա�", width: 50 },
        	{ field: "regNo", title: "�ǼǺ�", width: 100 },
        	{ field: "opstdate", title: "������ʼ����", width: 100 },
        	{ field: "opsttime", title: "������ʼʱ��", width: 100 },
        	{ field: "status", title: "״̬", width: 50 },
        	{ field: "receiveDate", title: "�Ӳ�������", width: 80 ,hidden:true},
        	{ field: "receiveTime", title: "�Ӳ���ʱ��", width: 100 ,
        		editor:{
	        		type:'datetimebox',
	        		options:{
		        		showSeconds: false	
		        	}
	        	}
        	},
        	{ field: "receiveUser", title: "������", width: 100 ,
        		editor:{
						type:'combobox',
						options:{
							panelWidth:120,
							valueField:'ctcpId',
							textField:'ctcpDesc',
							data:getTempList()	
						}
					},
				formatter:function(value,row){
					var tempList=getTempList();
					for(var i=0;i<tempList.length;i++)
					{
						if(tempList[i].ctcpId==value)
						{
							return tempList[i].ctcpDesc;
						}
					}
					return value;
				}
        	},
        	{ field: "receiveAssDate", title: "�Ӳ��˻�����������", width: 120 ,hidden:true},
        	{ field: "receiveAssTime", title: "�Ӳ��˻�������", width: 100 },
        	{ field: "receiveBackDate", title: "������������", width: 100 ,hidden:true},
        	{ field: "receiveBackTime", title: "��������ʱ��", width: 100 },
        	{ field: "sendDate", title: "�Ͳ�������", width: 80 ,hidden:true},
        	{ field: "sendTime", title: "�Ͳ���ʱ��", width: 80 ,
        		editor:{
	        		type:'datetimebox',
	        		options:{
		        		showSeconds: false	
		        	}
	        	}
        	},
        	{ field: "sendUser", title: "������", width: 100 ,
        		editor:{
						type:'combobox',
						options:{
							panelWidth:120,
							valueField:'ctcpId',
							textField:'ctcpDesc',
							data:getTempList()	
						}
					},
				formatter:function(value,row){
					var tempList=getTempList();
					for(var i=0;i<tempList.length;i++)
					{
						if(tempList[i].ctcpId==value)
						{
							return tempList[i].ctcpDesc;
						}
					}
					return value;
				}
        	},
        	{ field: "sendBackDate", title: "�����߻�����", width: 100 ,hidden:true},
        	{ field: "sendAssDate", title: "�Ͳ��˻�����������", width: 120 ,hidden:true},
        	{ field: "sendAssTime", title: "�Ͳ��˻�������", width: 100 },
        	{ field: "sendBackTime", title: "��������ʱ��", width: 100 },
        	{ field: "receiveAppDate", title: "����Ӳ�������", width: 100 },
        	{ field: "receiveAppTime", title: "����Ӳ���ʱ��", width: 80 },
        	{ field: "receiveAppUser", title: "�Ӳ���������", width: 100 },
        	{ field: "sendAppDate", title: "�����Ͳ�������", width: 100 },
        	{ field: "sendAppTime", title: "�����Ͳ���ʱ��", width: 100 },
        	{ field: "sendAppUser", title: "�Ͳ���������", width: 100 }
        ]
        ],onClickCell:onClickCell,
        onBeforeEdit:function(rowIndex,rowData){
			if(logLocType!="OP")
			{
				return false;
			}
		},
		onAfterEdit:function(rowIndex,rowData,changes){
			var opaId=rowData.opaId;
			if(changes.receiveTime&&changes.receiveTime!=undefined)
			{
				var rTime=changes.receiveTime.split(" ")[1];
				var result=$.m({
					ClassName:"web.DHCANOPTransfer",
					MethodName:"updateReceiveTime",
					opaId:opaId,
					receiveTime:rTime,
					userId:logUserId
				},false)
				if(result!=0)
				{
					$.messager.alert("����",result,"warning");
					$('#OperationListBox').datagrid('reload');
				}
			}
			if(changes.receiveUser&&changes.receiveUser!=undefined)
			{
				var result=$.m({
					ClassName:"web.DHCANOPTransfer",
					MethodName:"updateReceiveUser",
					opaId:opaId,
					receiveUserStr:changes.receiveUser,
					userId:logUserId
				},false)
				if(result!=0)
				{
					$.messager.alert("����",result,"warning");
					$('#OperationListBox').datagrid('reload');
				}
			}
			if(changes.sendTime&&changes.sendTime!=undefined)
			{
				var sTime=changes.sendTime.split(" ")[1];
				var result=$.m({
					ClassName:"web.DHCANOPTransfer",
					MethodName:"updateSendTime",
					opaId:opaId,
					sendTime:sTime,
					userId:logUserId
				},false)
				if(result!=0)
				{
					$.messager.alert("����",result,"warning");
					$('#OperationListBox').datagrid('reload');
				}
			}
			if(changes.sendUser&&changes.sendUser!=undefined)
			{
				var result=$.m({
					ClassName:"web.DHCANOPTransfer",
					MethodName:"updateSendUser",
					opaId:opaId,
					sendUserStr:changes.sendUser,
					userId:logUserId
				},false)
				if(result!=0)
				{
					$.messager.alert("����",result,"warning");
					$('#OperationListBox').datagrid('reload');
				}
			}
		}
	})
	
	if(logLocType!="OP")
	{
		$("#ReceviceSure").linkbutton('disable');
		$("#PatInRoom").linkbutton('disable');
		$("#SendSure").linkbutton('disable');
		$("#PatOutRoom").linkbutton('disable');
	}
}

var editIndex = undefined;
function endEditing()
{
	if (editIndex == undefined){return true}
	if ($('#OperationListBox').datagrid('validateRow', editIndex)){
		$('#OperationListBox').datagrid('endEdit', editIndex);
		editIndex = undefined;
		return true;
	} else {
		return false;
	}
}
function onClickCell(index, field)
{
	if (endEditing()){
	$('#OperationListBox').datagrid('selectRow', index).datagrid('editCell', {index:index,field:field});
		editIndex = index;
	}
}

//��ȡ��������
function getLogLocType(){
    var logLocType="App";
    var locFlag=$.m({
        ClassName:"web.UDHCANOPSET",
        MethodName:"ifloc",
        Loc:logLocId
    },false);
    if(locFlag==1) logLocType="OP";
	if(locFlag==2) logLocType="AN";
    return logLocType;
}
//��ȡ���Ͳ��˻���
function getTempList(){
	var result=$.cm({
		ClassName:"web.DHCANOPTransfer",
		QueryName:"GetTempGroup",
		ResultSetType:"array",
		GroupId:""
	},false)
	return result;
}
