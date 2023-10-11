$(function(){
	
	$("#AuditStatus").combobox({
        valueField:"code",
        textField:"desc",
        panelHeight:"auto",
        data:[
			{"code":"A","desc":"申请"},
			{"code":"C","desc":"撤销"},
			{"code":"D","desc":"拒绝"},
			{"code":"F","desc":"完成"}
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
					title: '分类',
					width: 100
				}, {
					field: 'operCategId',
					title: '分类ID'
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
          	{ field: "operCode", title: "代码", width: 80 },
        	{ field: "operDesc", title: "描述", width: 80 },
        	{ field: "operClass", title: "级别", width: 100 },
        	{ field: "ICDCode", title: "ICD码", width: 80 },
        	{ field: "operAlias", title: "别名", width: 80 },
      		{ field: "appUser", title: "申请用户", width: 80 },
        	{ field: "appLoc", title: "申请科室", width: 100 },
        	{ field: "appDate", title: "申请日期", width: 120 },
        	{ field: "appTime", title: "时间", width: 80 },
        	{ field: "status", title: "状态", width: 60 },
        	{ field: "auditUser", title: "审核人", width: 80 },
        	{ field: "auditLoc", title: "审核科室", width: 80 },
        	{ field: "auditDate", title: "审核日期", width: 120 },
        	//{ field: "auditTime", title: "审核时间", width: 180 },
        	//{ field: "auditNote", title: "拒绝原因", width: 180 },
        	{ field: "passNote", title: "通过原因", width: 180 },
        	{ field: "declineNote", title: "拒绝原因", width: 180 },
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
                text:'新增',
                handler:function(){
                    saveGroupCaptionHandler()
                }
            },
            {
                iconCls:'icon-write-order',
                text:'修改',
                handler:function(){
                    var selectRow=$("#AuditOperBox").datagrid('getSelected');
                    if(selectRow)
                    {
	                    saveGroupCaptionHandler(selectRow)
	                }else{
		             	$.messager.alert('提示','请选择要修改的行！','warning')
		             }
                }
            },
            {
                iconCls:'icon-cancel',
                text:'删除',
                handler:function(){
                    var selectRow=$("#AuditOperBox").datagrid('getSelected');
                    if(selectRow)
                    {
	                    var appUserId=session['LOGON.USERID'];
	                    var curUserId=selectRow.appUserId;
	                    var status=selectRow.status;
    					if ((status!='申请'))
    					{
        					$.messager.alert("提示","能操作的手术状态为:"+"申请","error");
        					return;
    					}
	                    if(appUserId!=curUserId)
	                    {
		                    $.messager.alert('提示','非申请人不能撤销该手术记录','info');
		                    return;
	                    }
	                    $.messager.confirm("确认","确认撤销用户："+selectRow.appUser+"的"+selectRow.operDesc,function(r)
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
					             
									$.messager.alert('提示','该条自定义手术信息撤销成功','info');
		 							$('#operDescD').val("");
									$('#operCodeD').val("");
									$('#operICDD').val("");
									$('#operAliasD').val("");
		 							
		 							
		 							$("#AuditOperBox").datagrid('reload');
					            }else{
						            $.messager.alert('错误','该条自定义手术信息撤销失败！','warning');
						            return;
						        }
			                }
		                });
	                }else{
		             	$.messager.alert('提示','请选择要撤销的行！','warning')
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

	var titleName="新增手术审核";
	var iconCls="icon-w-add";
	if(selectRow)
	{
		titleName="修改手术审核";
		iconCls="icon-w-edit";
		var status=selectRow.status;
    	if ((status!='申请'))
    	{
        	$.messager.alert("提示","能操作的手术状态为:"+"申请","error");
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
				text:'保存',
				handler:function(){
                    saveGroupCaption();
                }
            },
            {
				text:'关闭',
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
		$.messager.alert('提示','手术名称不能为空！','warning');
		return;
	}
	if(sOperCode=="")
	{
		$.messager.alert('提示','手术代码不能为空！','warning');
		return;
	}
	if(sOperClass=="")
	{
		$.messager.alert('提示','手术分级不能为空！','warning');
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
			$.messager.alert('错误',result,'warning');
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

