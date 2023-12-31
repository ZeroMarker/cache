function initPage(){
      initMsgTool();
      initMsgBox();
    }

    function initMsgBox(){
      $("#messageBox").datagrid({
        iconCls:"icon-paper",
        toolbar:"#messageTool",
		title:"短信发送记录",
        headerCls:"panel-header-gray",
        fit:true,
        singleSelect:true,
        pagination:true,
        url:ANCSP.MethodService,
        rownumbers:true,
        pageSize:50,
		height:660,
        columns:[[
            {field:"PatDeptDesc",title:"科室",width:120},
            {field:"PatName",title:"患者姓名",width:80},
            {field:"PatGender",title:"性别",width:50},
            {field:"RegNo",title:"登记号",width:100},
            {field:"PatPhoneNumber",title:"手机号",width:100},
            {field:"Content",title:"短信内容",width:480},
            {field:"SendUserDesc",title:"发送人",width:80},
            {field:"SendDT",title:"发送时间",width:200}
        ]],
        onBeforeLoad:function(param){
            param.ClassName=ANCLS.BLL.PhoneMessage;
            param.MethodName="GetPhoneMessages";
            var startDate=$("#startDate").datebox("getValue");
            var endDate=$("#endDate").datebox("getValue");
            var deptId=$("#dept").combobox("getValue");
            var content=$("#content").val();
            param.Arg1=startDate;
            param.Arg2=endDate;
            param.Arg3=deptId;
            param.Arg4=content;
            console.log(param);
            param.Arg5=param.page;
            param.Arg6=param.rows;
            param.ArgCnt=6;
        }
      });
    }

    function initMsgTool(){
	  dhccl.parseDateFormat();
	  dhccl.parseDateTimeFormat();
      var today=(new Date()).format("yyyy-MM-dd");
      $("#startDate,#endDate").datebox("setValue",today);

      $("#dept").combobox({
        url: ANCSP.DataQuery,
        onBeforeLoad: function(param) {
            param.ClassName = CLCLS.BLL.Admission;
            param.QueryName = "FindLocationOld";
            param.Arg1 = param.q?param.q:"";
            param.Arg2="INOPDEPT^OUTOPDEPT^EMOPDEPT";
            param.ArgCnt=2;
        },
        valueField: "RowId",
        textField: "Description",
        mode: "remote",
        width:160
      });

      $("#btnSearch").linkbutton({
        iconCls:"icon-w-find",
        onClick:function(){
          $("#messageBox").datagrid("reload");
        }
      })
    }

    $(document).ready(initPage);