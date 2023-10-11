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
	var objoplev=$HUI.combobox("#OperCateD",{
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
        singleSelect: true,
        selectOnCheck:true,
        checkOnSelect:true,
        checkbox: true,
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
            param.appOperLocId=$("#ctloc").combobox('getValue');
	    },
        columns:[
        [
        	{field:'operate1',title:'审核',align:'center',width:50,
			formatter:function(value, row, index){ 
			var str = '<a href="#" id="btnAuditOper" class="hisui-linkbutton" onClick="AuditOper('+'\''+index+'\''+')" "></a>';
			return str;
			}},
			{field:'operate2',title:'拒绝',align:'center',width:50,
			formatter:function(value, row, index){ 
			var str = '<a href="#" id="btnDecline" class="hisui-linkbutton" onClick="DeclineOper('+'\''+index+'\''+')" "></a>';
			return str;
			}},
			
        	{ field: "tAuditId", title: "Id", width: 50 },
        	
          	{ field: "operCode", title: "代码", width: 100 },
        	{ field: "operDesc", title: "描述", width: 100 },
        	{ field: "operClass", title: "级别", width: 100 },
        	{ field: "ICDCode", title: "ICD码", width: 100 },
        	{ field: "operAlias", title: "别名", width: 100 },
      		{ field: "appUser", title: "申请用户", width: 100 },
        	{ field: "appLoc", title: "申请科室", width: 100 },
        	{ field: "appDate", title: "申请日期", width: 100 },
        	{ field: "appTime", title: "时间", width: 100 },
        	{ field: "status", title: "状态", width: 100 },
        	{ field: "auditUser", title: "审核人", width: 100 },
        	{ field: "auditLoc", title: "审核科室", width: 100 },
        	{ field: "auditDate", title: "审核日期", width: 100 },
        	{ field: "auditTime", title: "审核时间", width: 100 },
        	{ field: "passNote", title: "通过原因", width: 120 },
        	{ field: "declineNote", title: "拒绝原因", width: 120 },
        	{ field: "appUserId", title: "appUserId", hidden:true },
        	{ field: "appLocId", title: "appLocId", hidden:true },
        	{ field: "auditUserId", title: "auditUserId", hidden:true },
        	{ field: "auditLocId", title: "auditLocId", hidden:true },
        	{ field: "operClassDr", title: "operClassDr", hidden:true },
        	{ field: "operBladeDr", title: "operBladeDr", hidden:true },
        	{ field: "operBlade", title: "operBlade", hidden:true }
       	]
       	],
       	frozenColumns:[[
        { field: "check",checkbox:true }
        ]],
       	onLoadSuccess:function(data){  
         $("a[id='btnAuditOper']").linkbutton({text:'',plain:true,iconCls:'icon-write-order'});
        $("a[id='btnDecline']").linkbutton({text:'',plain:true,iconCls:'icon-cancel'});
        //$("a[id='btnAnDoc2']").linkbutton({text:'',plain:true,iconCls:'icon-add'});
        //$("a[id='btnAnDoc3']").linkbutton({text:'',plain:true,iconCls:'icon-add'});
       	}
	});
	$("#btnSearch").click(function(){
		$("#AuditOperBox").datagrid('reload');
	})
});

function AuditOper(index){
	 $("#AuditOperBox").datagrid("checkRow",index);
    var selectRows=$("#AuditOperBox").datagrid("getChecked");
    if(selectRows.length==0)
    {
         $.messager.alert("提示","请选择一条记录","warning");
         return;
    }
    if(selectRows.length>1)
    {
        $.messager.alert("提示","只能操作一条手术","error");
        $("#AuditOperBox").datagrid("clearChecked");
        return;
    }
    var auditId=selectRows[0].tAuditId;
   	var auditUserId=session['LOGON.USERID'];
	var auditLocId=session['LOGON.CTLOCID'];
	var status=selectRows[0].status;
    if ((status!='申请'))
    {
        $.messager.alert("提示","能操作的手术状态为:"+"申请","error");
        return;
    }
  	$("#OperCodeD").val(selectRows[0].operCode);
  	$("#OperDescD").val(selectRows[0].operDesc);
  	$("#OperICDD").val(selectRows[0].ICDCode);
  	$("#OperAliasD").val(selectRows[0].operAlias);
  	$("#OperCateD").combobox("setValue",selectRows[0].operClassDr);
  	
  	
   var titleName="手术信息确认";
    	$("#PassDialog").show();
	$("#PassDialog").dialog({
        iconCls:'icon-w-save',
        title:titleName,
        resizable:true,
        modal:true,
        /*
        buttons:[
            {
				text:'保存',
				handler:function(){
                        var auditId=selectRows[0].tAuditId;
					    var auditUserId=session['LOGON.USERID'];
						var auditLocId=session['LOGON.CTLOCID'];
						var auditCode=$("#OperCodeD").val();
						var auditDesc=$("#OperDescD").val();
						var auditICD=$("#OperICDD").val();
						var auditAlias=$("#OperAliasD").val();
						var auditCate=$("#OperCateD").combobox("getValue");
						
					    var passReason=$("#passNote").val();
					    var str=auditId+"^"+auditUserId+"^"+auditLocId+"^"+passReason+"^"+auditCode+"^";
					    var str=str+auditDesc+"^"+auditICD+"^"+auditAlias+"^"+auditCate;
					   
					    var result=$.m({
								ClassName:"web.DHCANCOperAudit",
								MethodName:"AuditOper",
								AuditStr:str
							},false);
						if(result!=0)
							{
								$.messager.alert('错误',result,'warning');
								return ;
							}
						else
						{
							$.messager.alert('审核成功',"审核成功",'info');
							 $("#PassDialog").dialog('close');
							 $("#AuditOperBox").datagrid('reload');
						}

                	}
            },
            {
				text:'关闭',
				handler:function(){
					
                    $("#PassDialog").dialog('close');
                }
            }
        ],
        */
        onBeforeClose:function(){
	       
	    },
	    onBeforeOpen:function(){
		}
    });
    $('#PassDialog').window('center')
    
}
function SaveOperInf()
{
	 var auditId=selectRows[0].tAuditId;
					    var auditUserId=session['LOGON.USERID'];
						var auditLocId=session['LOGON.CTLOCID'];
						var auditCode=$("#OperCodeD").val();
						var auditDesc=$("#OperDescD").val();
						var auditICD=$("#OperICDD").val();
						var auditAlias=$("#OperAliasD").val();
						var auditCate=$("#OperCateD").combobox("getValue");
						
					    var passReason=$("#passNote").val();
					    var str=auditId+"^"+auditUserId+"^"+auditLocId+"^"+passReason+"^"+auditCode+"^";
					    var str=str+auditDesc+"^"+auditICD+"^"+auditAlias+"^"+auditCate;
					   
					    var result=$.m({
								ClassName:"web.DHCANCOperAudit",
								MethodName:"AuditOper",
								AuditStr:str
							},false);
						if(result!=0)
							{
								$.messager.alert('错误',result,'warning');
								return ;
							}
						else
						{
							$.messager.alert('审核成功',"审核成功",'info');
							 $("#PassDialog").dialog('close');
							 $("#AuditOperBox").datagrid('reload');
						}

               
}
function closeDiag()
{
	$("#PassDialog").dialog('close');
}
function DeclineOper(index)
{
	$("#AuditOperBox").datagrid("checkRow",index);
	var selectRows=$("#AuditOperBox").datagrid("getChecked");
    if(selectRows.length==0)
    {
         $.messager.alert("提示","请选择一条记录","warning");
         return;
    }
    if(selectRows.length>1)
    {
        $.messager.alert("提示","只能操作一条手术","error");
        $("#AuditOperBox").datagrid("clearChecked");
        return;
    }
	var status=selectRows[0].status;
    if ((status!='申请'))
    {
        $.messager.alert("提示","能操作的手术状态为:"+"申请","error");
        return;
    }
    var titleName="拒绝手术";
    	$("#CaptionDialog").show();
	$("#CaptionDialog").dialog({
        iconCls:'icon-w-cancel',
        title:titleName,
        resizable:true,
        modal:true,
        buttons:[
            {
				text:'保存',
				handler:function(){
                        var auditId=selectRows[0].tAuditId;
					    var auditUserId=session['LOGON.USERID'];
						var auditLocId=session['LOGON.CTLOCID'];

					    var declineReason=$("#declineNote").val();
					    var str=auditId+"^"+auditUserId+"^"+auditLocId+"^"+declineReason;
					    var result=$.m({
								ClassName:"web.DHCANCOperAudit",
								MethodName:"DeclineAuditOper",
								AuditStr:str
							},false);
						if(result!=0)
							{
								$.messager.alert('错误',result,'warning');
								return ;
							}
						else
						{
							$.messager.alert('拒绝成功',"拒绝成功",'info');
							$("#CaptionDialog").dialog('close');
							 $("#AuditOperBox").datagrid('reload');
						}

                	}
            },
            {
				text:'关闭',
				handler:function(){
                    $("#CaptionDialog").dialog('close');
                }
            }
        ],
        onBeforeClose:function(){
	       	//$("#conditionForm").form('clear');
	    },
	    onBeforeOpen:function(){
		}
    });
    $('#CaptionDialog').window('center')

}