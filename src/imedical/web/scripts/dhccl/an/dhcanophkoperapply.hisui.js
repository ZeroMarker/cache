$(function(){
	
	$("#AuditStatus").combobox({
        valueField:"code",
        textField:"desc",
        panelHeight:"auto",
        data:[
			{"code":"A","desc":"����"},
			{"code":"C","desc":"����"},
			{"code":"D","desc":"�ܾ�"},
			{"code":"F","desc":"���"}
		]
	});
	var objoplev=$HUI.combobox("#operClassD",{
		url:$URL+"?ClassName=web.DHCANCOperAudit&QueryName=FindORCOperationCategory&ResultSetType=array",
		valueField:'operCategId',
		textField:'operCategLDesc',
		multiple:false,
		onBeforeLoad:function(param){
	
		},
		onLoadSuccess:function(data) {
			    }
		,mode: "remote"	
		,columns: [
				[{
					field: 'operCategLDesc',
					title: '����',
					width: 100
				}, {
					field: 'operCategId',
					title: '����ID'
				}]
			]
		});
		var objctloc=$HUI.combobox("#ctloc",{
		url:$URL+"?ClassName=web.DHCClinicCom&QueryName=FindLocList&ResultSetType=array",
		valueField:'ctlocId',
		textField:'ctlocDesc',
		onBeforeLoad:function(param){
			param.desc=param.q;
			param.locListCodeStr ='INOPDEPT^OUTOPDEPT^EMOPDEPT';
			param.EpisodeID = "";
		},
		onLoadSuccess:function(data) {
			    }	
	});
	$HUI.datebox("#DateFrom",{
	})
	$HUI.datebox("#DateTo",{
	})
		$("#AuditOperBox").datagrid({
		fit: true,
        fitColumns:true,
        singleSelect: true,
        nowrap: true,
        rownumbers: true,
        pagination: true,
        pageSize: 20,
        pageList: [20, 50, 100],
		border:false,			 
        url:$URL,
        queryParams:{
            ClassName:"web.DHCANCOperAudit",
            QueryName:"FindOperAuditList"
        },
        onBeforeLoad:function(param){
	    	param.frDate=$("#DateFrom").datebox('getValue');
            param.toDate=$("#DateTo").datebox('getValue');
            param.fstatu=$("#AuditStatus").combobox('getValue');
            param.operdesc=$("#OpName").val();
            param.appOperLocId=session['LOGON.CTLOCID'];;
	    },
        columns:[
        [
        	{ field: "tAuditId", title: "Id", width: 50 },
          	{ field: "operCode", title: "����", width: 80 },
        	{ field: "operDesc", title: "����", width: 80 },
        	{ field: "operClass", title: "����", width: 100 },
        	{ field: "ICDCode", title: "ICD��", width: 80 },
        	{ field: "operAlias", title: "����", width: 80 },
      		{ field: "appUser", title: "�����û�", width: 80 },
        	{ field: "appLoc", title: "�������", width: 100 },
        	{ field: "appDate", title: "��������", width: 120 },
        	{ field: "appTime", title: "ʱ��", width: 80 },
        	{ field: "status", title: "״̬", width: 60 },
        	{ field: "auditUser", title: "�����", width: 80 },
        	{ field: "auditLoc", title: "��˿���", width: 80 },
        	{ field: "auditDate", title: "�������", width: 120 },
        	//{ field: "auditTime", title: "���ʱ��", width: 180 },
        	//{ field: "auditNote", title: "�ܾ�ԭ��", width: 180 },
        	{ field: "passNote", title: "ͨ��ԭ��", width: 180 },
        	{ field: "declineNote", title: "�ܾ�ԭ��", width: 180 },
        	{ field: "appUserId", title: "appUserId", hidden:true },
        	{ field: "appLocId", title: "appLocId", hidden:true },
        	{ field: "auditUserId", title: "auditUserId", hidden:true },
        	{ field: "auditLocId", title: "auditLocId", hidden:true },
        	{ field: "operClassDr", title: "operClassDr", hidden:true },
        	{ field: "operBladeDr", title: "operBladeDr", hidden:true },
        	{ field: "operBlade", title: "operBlade", hidden:true }
       	]
       	],
       	toolbar:[
            {
                iconCls:'icon-add',
                text:'����',
                handler:function(){
                    saveGroupCaptionHandler()
                }
            },
            {
                iconCls:'icon-write-order',
                text:'�޸�',
                handler:function(){
                    var selectRow=$("#AuditOperBox").datagrid('getSelected');
                    if(selectRow)
                    {
	                    saveGroupCaptionHandler(selectRow)
	                }else{
		             	$.messager.alert('��ʾ','��ѡ��Ҫ�޸ĵ��У�','warning')
		             }
                }
            },
            {
                iconCls:'icon-cancel',
                text:'ɾ��',
                handler:function(){
                    var selectRow=$("#AuditOperBox").datagrid('getSelected');
                    if(selectRow)
                    {
	                    var appUserId=session['LOGON.USERID'];
	                    var curUserId=selectRow.appUserId;
	                    var status=selectRow.status;
    					if ((status!='����'))
    					{
        					$.messager.alert("��ʾ","�ܲ���������״̬Ϊ:"+"����","error");
        					return;
    					}
	                    if(appUserId!=curUserId)
	                    {
		                    $.messager.alert('��ʾ','�������˲��ܳ�����������¼','info');
		                    return;
	                    }
	                    $.messager.confirm("ȷ��","ȷ�ϳ����û���"+selectRow.appUser+"��"+selectRow.operDesc,function(r)
	                    {
		                    if(r)
		                    {
			                    var result=$.m({
				                	ClassName:"web.DHCANCOperAudit",
				                	MethodName:"DeleteOperAudit",
				                	auditId:selectRow.tAuditId
				                },false);
				                if(result=='0')
				                {
					             
									$.messager.alert('��ʾ','�����Զ���������Ϣ�����ɹ�','info');
		 							$('#operDescD').val("");
									$('#operCodeD').val("");
									$('#operICDD').val("");
									$('#operAliasD').val("");
		 							
		 							
		 							$("#AuditOperBox").datagrid('reload');
					            }else{
						            $.messager.alert('����','�����Զ���������Ϣ����ʧ�ܣ�','warning');
						            return;
						        }
			                }
		                });
	                }else{
		             	$.messager.alert('��ʾ','��ѡ��Ҫ�������У�','warning')
		             }
                }
            }
        ]
        
	});
	$("#btnSearch").click(function(){
		$("#AuditOperBox").datagrid('reload');
	})

});
function saveGroupCaptionHandler(selectRow){
 //tAuditId,appUserId,appUser,appLocId,appLoc,appDate,appTime,status
 //,auditUserId,auditUser,auditLocId,auditLoc,auditDate,auditDate,auditTime
  //,operCode,operDesc,operClassDr,operClass,operBladeDr,operBlade,ICDCode,operAlias
	$('#operDescD').val("");
	$('#operCodeD').val("");
	$('#operICDD').val("");
	$('#operAliasD').val("");
	$('#operClassD').combobox("setValue","");

	var titleName="�����������";
	var iconCls="icon-w-add";
	if(selectRow)
	{
		titleName="�޸��������";
		iconCls="icon-w-edit";
		var status=selectRow.status;
    	if ((status!='����'))
    	{
        	$.messager.alert("��ʾ","�ܲ���������״̬Ϊ:"+"����","error");
        	return;
    	}
		$("#operAuditRowId").val(selectRow.tAuditId);
		$("#operDescD").val(selectRow.operDesc);
		$("#operCodeD").val(selectRow.operCode);
		$("#operICDD").val(selectRow.ICDCode);
		$("#operClassD").combobox('setValue',selectRow.operClassDr);
		$("#operAliasD").val(selectRow.operAlias);
	}					
	$("#CaptionDialog").show();
	$("#CaptionDialog").dialog({
        iconCls:iconCls,
        title:titleName,
        resizable:true,
        modal:true,
        /*
        buttons:[
            {
				text:'����',
				handler:function(){
                    saveGroupCaption();
                }
            },
            {
				text:'�ر�',
				handler:function(){
					
                    $("#CaptionDialog").dialog('close');
                }
            }
        ],
        */
        onBeforeClose:function(){
	       	$("#conditionForm").form('clear');
	    },
	    onBeforeOpen:function(){
			//$('#operDescD').val("");
			//$('#operCodeD').val("");
			//$('#operICDD').val("");
			//$('#operAliasD').val("");
			//$('#operClassD').combobox("reload");
		}
    });
    $('#CaptionDialog').window('center')
}
function closeDiag()
{
	 $("#CaptionDialog").dialog('close');
}
function saveGroupCaption(){
	var appUserId=session['LOGON.USERID'];
	var appLocId=session['LOGON.CTLOCID'];
	
	var auditRowId=$("#operAuditRowId").val();
	var sOperDesc=$("#operDescD").val();
	var sOperCode=$("#operCodeD").val();
	var sOperICD=$("#operICDD").val();
	var sOperAlias=$("#operAliasD").val();
	var sOperClass=$("#operClassD").combobox('getValue');
	var str=appUserId+"^"+appLocId+"^"+sOperCode+"^"+sOperDesc+"^"+sOperICD+"^"+sOperAlias+"^"+sOperClass;
	if(sOperDesc=="")
	{
		$.messager.alert('��ʾ','�������Ʋ���Ϊ�գ�','warning');
		return;
	}
	if(sOperCode=="")
	{
		$.messager.alert('��ʾ','�������벻��Ϊ�գ�','warning');
		return;
	}
	if(sOperClass=="")
	{
		$.messager.alert('��ʾ','�����ּ�����Ϊ�գ�','warning');
		return;
	}
	var result=0;
	if(auditRowId=="")
	{
		result=$.m({
			ClassName:"web.DHCANCOperAudit",
			MethodName:"InsertOperAudit",
			AuditStr:str
		},false);
		
	}else{
		result=$.m({
			ClassName:"web.DHCANCOperAudit",
			MethodName:"UpdateOperAudit",
			AuditId:auditRowId,
			AuditStr:str
		},false);
	}
	if(result!=0)
		{
			$.messager.alert('����',result,'warning');
			return ;
		}
		 $("#CaptionDialog").dialog('close');
		 $("#operDescD").val("");
		 $("#operCodeD").val("");
		 $("#operICDD").val("");
		 $("#operAliasD").val("");
		 $("#operClassD").combobox('setValue',"");
		 $("#AuditOperBox").datagrid('reload');
	
}

