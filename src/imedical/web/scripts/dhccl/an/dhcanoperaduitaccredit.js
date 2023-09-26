var logUserId=session['LOGON.USERID'],
    logGroupId=session['LOGON.GROUPID'],
    logLocId=session['LOGON.CTLOCID'];
$(function(){
    initControls();
    initDataGrid();
})

//��ʼ�����
function initControls(){
    var anaactloc=$HUI.combobox("#ANAACtloc",{
        url:$URL+"?ClassName=web.DHCClinicCom&QueryName=FindLocList&ResultSetType=array",
        valueField:"ctlocId",
        textField:"ctlocDesc",
        required:true,
        onBeforeLoad:function(param)
        {
            param.desc=param.q;
            param.locListCodeStr="";
            param.EpisodeID="";
        },
        onLoadSuccess:function(data){
            anaactloc.setValue(logLocId);
        } 
    });
    anaactloc.disable();
    var ANAACtpcp=$HUI.combobox("#ANAACtpcp",{
        url:$URL+"?ClassName=web.UDHCANOPArrange&QueryName=FindCtcp&ResultSetType=array",
        valueField:"ctcpId",
        textField:"ctcpDesc",
        required:true,
        onBeforeLoad:function(param){
            param.needCtcpDesc=param.q;
            param.locListCodeStr="INOPDEPT^OUTOPDEPT^EMOPDEPT";
            param.locDescOrId=anaactloc.getValue();
            param.EpisodeID="";
            param.opaId="";
            param.ifDoctor="Y";
            param.ifSurgeon="";
        },
        defaultFilter:4,
        blurValidValue:true
    });
    var startdate=new Date();
    var enddate=new Date(startdate.getTime() + 3*24*60*60*1000);
    $("#ANAAStartDate").datebox('setValue',$.fn.datebox.defaults.formatter(startdate));
    $("#ANAAEndDate").datebox('setValue',$.fn.datebox.defaults.formatter(enddate));
}
//�������ݱ��
function initDataGrid(){
    var selectRowId=0,preRowId=0;
    var aduitaccreditdata=$HUI.datagrid("#AduitAccreditData",{
        fit: true,
        fitColumns:true,
        singleSelect: true,
        // nowrap: false,
        title:'��������Ȩ��Ϣά��',
        iconCls:'icon-paper',
        headerCls:'panel-header-gray',
        border:true,
        rownumbers: true,
        pagination: true,
        pageSize: 200,
        pageList: [50, 100, 200],
        url:$URL,
        queryParams:{
            ClassName:"web.DHCANAduitAccredit",
            QueryName:"FindAduitAccreditList",
            curLocId:($("#ANAACtloc").combobox('getValue')=="")?logLocId:$("#ANAACtloc").combobox('getValue')
        },
        columns:[
            [
                { field: "ANAARowId", title: "ϵͳ��", width: 60, sortable: true },
                { field: "ANAACtlocId", title: "��Ȩ����Id", width: 90 ,hidden:true},
                { field: "ANAACtlocDesc", title: "��Ȩ����", width: 200 },
                { field: "ANAACtpcpId", title: "��Ȩҽ��Id", width:90 ,hidden:true},
                { field: "ANAACtpcpDesc", title: "��Ȩҽ��", width: 100 },
                { field: "ANAAStartDT", title: "��Ȩ��ʼʱ��", width: 200 },
                { field: "ANAAEndDT", title: "��Ȩ����ʱ��", width: 200 },
                { field: "ANAACreateUserName", title: "������Ȩҽ��", width: 100 },
                { field: "ANAACreateDT", title: "��������", width: 160 }
            ]
        ],
        onSelect:function(rowIndex,rowData){
            
        },
        toolbar:[
            {
                iconCls:'icon-add',
                text:'����',
                handler:function(){
                    saveAduitAccreditHandler();
                }
            },
            {
                iconCls:'icon-edit',
                text:'�޸�',
                handler:function(){
                    var selectObj=$("#AduitAccreditData").datagrid('getSelected');
                    if(selectObj)
                    {
                        saveAduitAccreditHandler(selectObj);
                    }else{
                        $.messager.alert("��ʾ","��ѡ����Ҫ�޸ĵ��У�","warning");
                        return;
                    }
                }
            },
            {
                iconCls:'icon-remove',
                text:'ɾ��',
                handler:function(){
                    var selectObj=$("#AduitAccreditData").datagrid('getSelected');
                    if(selectObj)
                    {
                        deleteAduitAccredit(selectObj.ANAARowId);
                    }else{
                        $.messager.alert("��ʾ","��ѡ����Ҫɾ�����У�","warning");
                        return;
                    }
                }
            }
        ]
    })
}
function saveAduitAccreditHandler(obj)
{   var titleName="�������������Ȩ";
    if(obj)
    {
	    titleName="�޸����������Ȩ";
        $("#ANAARowID").val(obj.ANAARowId);
        $("#ANAACtloc").combobox('setValue',obj.ANAACtlocId);
        $("#ANAACtpcp").combobox('setValue',obj.ANAACtpcpId);
        $("#ANAAStartDate").datebox('setValue',obj.ANAAStartDT.split(" ")[0]);
        $("#ANAAStartTime").timespinner('setValue',obj.ANAAStartDT.split(" ")[1]);
        $("#ANAAEndDate").datebox('setValue',obj.ANAAEndDT.split(" ")[0]);
        $("#ANAAEndTime").timespinner('setValue',obj.ANAAEndDT.split(" ")[1]);
        
    }else{
		$("#ANAACtloc").combobox('setValue',logLocId);
		var startdate=new Date();
    	var enddate=new Date(startdate.getTime() + 3*24*60*60*1000);
    	$("#ANAAStartDate").datebox('setValue',$.fn.datebox.defaults.formatter(startdate));
    	$("#ANAAEndDate").datebox('setValue',$.fn.datebox.defaults.formatter(enddate));
	}
    $("#AduitAccreditDialog").show();
    $("#AduitAccreditDialog").dialog({
        iconCls:'icon-w-save',
        title:titleName,
        resizable:true,
        modal:true,
        buttons:[
            {
				text:'ȷ��',
				handler:function(){
                    saveAduitAccredit();
                }
            },
            {
				text:'�ر�',
				handler:function(){
                    $("#AduitAccreditDialog").dialog('close');
                }
            }
        ]
    })
}
function saveAduitAccredit(){
    var rowId=$("#ANAARowID").val();
    var ANAACtloc=$("#ANAACtloc").combobox('getValue');
    var ANAACtpcp=$("#ANAACtpcp").combobox('getValue');
	var ANAACtpcpDesc=$("#ANAACtpcp").combobox('getText');
    var ANAAStartDate=$("#ANAAStartDate").datebox('getValue');
	var ANAAStartTime=$("#ANAAStartTime").timespinner('getValue');
	var ANAAEndDate=$("#ANAAEndDate").datebox('getValue');
	var ANAAEndTime=$("#ANAAEndTime").timespinner('getValue');
    if(ANAACtloc=="")
    {
        $.messager.alert("��ʾ","��Ȩ���Ҳ���Ϊ�գ�","info");
        return;
    }
    if((ANAACtpcp=="")||(ANAACtpcpDesc==""))
    {
        $.messager.alert("��ʾ","��Ȩҽ������Ϊ�գ�","info");
        return;
    }
    if(ANAAStartDate=="")
    {
        $.messager.alert("��ʾ","��Ȩ��ʼ���ڲ���Ϊ�գ�","info");
        return;
    }
    if(ANAAStartTime=="")
    {
        $.messager.alert("��ʾ","��Ȩ��ʼʱ�䲻��Ϊ�գ�","info");
        return;
    }
    var result=$.m({
        ClassName:"web.DHCANAduitAccredit",
        MethodName:"SaveAduitAccredit",
        rowId:rowId,
        ctlocId:ANAACtloc,
        ctpcpId:ANAACtpcp,
        startDate:ANAAStartDate,
        startTime:ANAAStartTime,
        endDate:ANAAEndDate,
        endTime:ANAAEndTime,
        userId:logUserId
    },false)
    if(result>0)
    {
        $.messager.alert("��ʾ","ϵͳ��Ϊ"+result+"����Ȩ��Ϣ����ɹ���","info");
        $("#conditionForm").form('clear');
        $("#AduitAccreditDialog").dialog('close');
        $("#AduitAccreditData").datagrid("reload");
    }else
    {
        $.messager.alert("��ʾ","��Ȩ��Ϣ����ʧ�ܣ�","info");
        return ;
    }
}

function deleteAduitAccredit(rowId){
    var result=$.m({
        ClassName:"web.DHCANAduitAccredit",
        MethodName:"DeleteAduitAccredit",
        RowID:rowId
    },false);
    if(result==0)
    {
        $.messager.alert("��ʾ","��Ȩ��Ϣɾ���ɹ���","info");
        $("#conditionForm").form('clear');
        $("#AduitAccreditData").datagrid("reload");
    }else
    {
        $.messager.alert("��ʾ","��Ȩ��Ϣɾ��ʧ�ܣ�","info");
        return ;
    }
}