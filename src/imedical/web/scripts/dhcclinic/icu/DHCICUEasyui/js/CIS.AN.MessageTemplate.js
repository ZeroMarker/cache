 function initPage(){
      initTemplateBox();
      initTemplateDialog();
	  dhccl.parseDateFormat();
	  dhccl.parseDateTimeFormat();
    }

    function initTemplateBox(){
      $("#filterDeptID").combobox({
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

      $("#filterActive").checkbox({
        label:"激活"
      });
      
      

      $("#filterCreateDate").datebox();
      
      $("#btnSearch").linkbutton({
	     iconCls:"icon-w-find",
	     onClick:function(){
		 	 $("#templateBox").datagrid("reload");   
		 } 
	  });

      $("#templateBox").datagrid({
        //title:"短信模板",
        iconCls:"icon-paper",
        toolbar:"#templateTool",
        headerCls:"panel-header-gray",
        fit:true,
        border:false,
        singleSelect:true,
        rownumbers:true,
        //nowrap:false,
        url:ANCSP.MethodService,
        columns:[[
            {field:"Operator",title:"操作",formatter:function(value,row,index){
                var html="<a href='#' data-index='"+index+"' data-row='"+JSON.stringify(row)+"' class='operator-edit'></a>";
                html+="<a href='#' data-index='"+index+"' data-row='"+JSON.stringify(row)+"' class='operator-del'></a>";
                return html;
            }},
            {field:"MessageDesc",title:"模板名称",width:120},
            {field:"MessageText",title:"模板文本",width:320,formatter:function(value,row,index){
	        	return "<span>"+value+"</span>"    
	        }},
            {field:"DeptDesc",title:"科室",width:160},
            {field:"OperDesc",title:"手术名称",width:200},
            {field:"CreateUserDesc",title:"创建人",width:80},
            {field:"CreateDate",title:"创建日期",width:120},
            {field:"ActiveDesc",title:"激活",width:60}
        ]],
        onBeforeLoad:function(param){
            param.ClassName=ANCLS.BLL.MessageTemplate;
            param.MethodName="GetMessageTemplates";
            param.Arg1=$("#filterDeptID").combogrid("getValue");
            param.Arg2=$("#filterOperID").val();
            param.Arg3=$("#filterActive").checkbox("getValue")?"Y":"";
            param.Arg4=$("#filterCreateDate").datebox("getValue");
            param.ArgCnt=4;
        },
        onSelect:function(rowIndex,rowData){
            $("#templateForm").form("load",rowData);
            if(rowData.Active==="Y")
            {
	        	$("#Active").checkbox("setValue",true);    
	        }
	        else
	        {
		        $("#Active").checkbox("setValue",false); 
		    }
        },
        onLoadSuccess:function(data){
          $(".operator-edit").linkbutton({
            onClick:function(){
              var rowData=JSON.parse($(this).attr("data-row"));
              $("#templateForm").form("clear");
              $("#templateForm").form("load",rowData);
			  $("#OperID").combogrid("setText",rowData.OperDesc);
              $("#Active").checkbox("setValue",rowData.Active==="Y"?true:false);
              $("#templateDialog").dialog({
		      	iconCls:'icon-w-edit',
		      	title:'修改短信模板'    
		      });
              $("#templateDialog").dialog("open");
            },
            iconCls:'icon-write-order',
            plain:true
          });

          $(".operator-del").linkbutton({
            onClick:function(){
              var rowData=JSON.parse($(this).attr("data-row"));
              $.messager.confirm("提示","是否删除选中的短信模板？",function(r){
                if((r)){
                  delMessageTemplate(rowData);
                }
              });
            },
            iconCls:'icon-cancel',
            plain:true
          });
        }
      });

      

      $("#btnAdd").linkbutton({
        onClick:function(){
	      initTemplateDialog();
          $("#templateForm").form("clear");
          $("#Active").checkbox("setValue",true);
          $("#templateDialog").dialog({
	      	iconCls:'icon-w-add',
	      	title:'新增短信模板'    
	      });
        $("#MessageText").val("【***医院】 您好，这里是***医院日间手术中心,您的手术安排在{{OperMonth}}月{{OperDay}}日{{OperHour}}点{{OperMin}}分 。\r\n请您在手术前一晚及或术晨淋浴，手术部位最好以抗菌皂液清洗。手术当天穿宽松衣裤，衣物上面不要有金属物品，并提前取下身上所有的首饰、隐形眼镜，美瞳等，清除指甲油。手术当日需要一名家属陪同。术前术后保持手术部位清洁。\r\n请带上门诊医生开好的所有单据及本人证件，至日间手术中心报到办理入院。\r\n手术等候时间15分钟到2小时不等,甚至更久，建议手术日请假一天。\r\n手术安排资源紧张，一经约定，就请守约。因特殊情况不得已取消或改期时，请您务必提前知会我们，请提前致电：********。\r\n谢谢您的合作！祝您生活愉快！\t\r\n另：按照上级要求，所有手术患者均需检测核酸。所以，如果您没有48小时内的核酸结果，请您提前一天到达医院，进行核酸检测。对您的理解与配合，我们深表感谢！");
          $("#templateDialog").dialog("open");
        },
        iconCls:"icon-add",
        plain:true
      });
    }

    function initTemplateDialog(){
      $("#templateDialog").dialog({
        closed:true,
        width:746,
        modal:true,
        buttons:[{
          text:'保存',
          handler:function(){
            var templateData=$("#templateForm").serializeJson();
            saveMessageTemplate(templateData);
          }
        },{
          text:'关闭',
          handler:function(){$("#templateDialog").dialog("close");}
        }]
      });

      $("#DeptID").combobox({
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
        width:260
      });

      $("#OperID").combogrid({
        url: ANCSP.DataQuery,
        onBeforeLoad: function(param) {
            //if(!param.q || param.q==="") return false;
            param.ClassName = ANCLS.BLL.Operation;
            param.QueryName = "FindOperation";
            param.Arg1 = param.q?param.q:"";
            param.Arg2 = "";
            param.Arg3 = $("#DeptID").combogrid("getValue");
            param.ArgCnt = 3;
        },
        panelWidth:600,
        panelHeight:400,
        idField: "RowId",
        textField: "Description",
        columns:[[
            {field:"RowId",title:"ID",hidden:true},
            {field:"Description",title:"名称",width:390},
            {field:"OperClassDesc",title:"分级",width:60},
            {field:"ICDCode",title:"ICD码",width:130},
            {field:"ExternalID",title:"ExternalID",hidden:true}
        ]],
        pagination:true,
        pageSize:10,
        mode: "remote",
        width:660
      });

      $("#MessageText").validatebox({
        validType:"length[0,2000]",
        required:true
      });
     


      $("#MessageDesc").validatebox({
        validType:"length[0,200]",
        required:true,
        width:240
      });
      
      $("#Active").checkbox({
		//required:true,
		label:"激活"    
	  })
    }

    function saveMessageTemplate(rowData){
      if (!$("#templateForm").form("validate")) return; 
      var newData={
        RowId:rowData.RowId || '',
        DeptID:rowData.DeptID || '',
        OperID:rowData.OperID || '',
        MessageText:rowData.MessageText,
        MessageDesc:rowData.MessageDesc
      }
      newData.Active=$("#Active").checkbox("getValue")?"Y":"N";
      //var ret=dhccl.runServerMethod(ANCLS.BLL.MessageTemplate,"SaveMessageTemplate",JSON.stringify(newData),session.UserID);
      var ret=AIS.Action({action:"AN/SaveMsgTemplate",jsonData:JSON.stringify(newData),updateUserID:session.UserID})
      if(ret.indexOf("S^")===0){
        $.messager.popover({
          msg:"短信模板保存成功",
          type:"success",
          timeout:2000
        });
        $("#templateDialog").dialog("close");
        $("#templateBox").datagrid("reload");
      }else{
        $.messager.alert("提示","短信模板保存失败，原因："+ret.result,"error");
      }
    }

    function delMessageTemplate(rowData){
      var dataRowId=rowData.RowId;
      var ret=dhccl.runServerMethod(ANCLS.BLL.MessageTemplate,"DelMessageTemplate",dataRowId,session.UserID);
      if(ret.success){
	      $("#templateBox").datagrid("reload");
        $.messager.popover({
          msg:"短信模板删除成功",
          type:"success",
          timeout:2000
        });
      }else{
        $.messager.alert("提示","短信模板删除失败，原因："+ret.result,"error");
      }
    }

    $(document).ready(initPage);