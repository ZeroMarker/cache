   	 var ops={
	 	eventDate:(new Date()).format("yyyy-MM-dd"),
	 	dayDepts:["93","95","235","236","237","296"]  	 
	 };
   	function initPage()
   	{
	   	initCalendar();
	   	initOperList();
	   	removeFunction();
	   	initDSNoteDialog();
        initAction();
	}
	function initCalendar()
	{
		$("#calendar").fullCalendar({
	        height: 640,
	        editable: true,
	        selectable: true,
	        dayClick: function(date, jsEvent, view) {
	           ops.eventDate=date.format();
	           $("#operlistBox").datagrid("reload");
	        },
	        eventClick: function(calEvent, jsEvent, view) {
                $HUI.radio("[id='self']",{
                    checked:true});
                    $HUI.radio("[id='loc']",{
                        checked:false});
                        $HUI.radio("[id='all']",{
                            checked:false});
		        ops.eventDate=calEvent.OperDate;
                //20211101
                $('#operlistBox').datagrid({
                    url: ANCSP.MethodService,
                    queryParams: {
                        ClassName: "CIS.AN.BL.DayCalendar",
                        MethodName: "GetScheduleList",
                        ArgCnt: 5
                    },
                     onBeforeLoad:function(param)
                     {
                        param.Arg1=ops.eventDate || '';
                        param.Arg2="";
                        param.Arg3=$("#filterRegNo").val();
                        param.Arg4=$("#filterName").val();
                        param.Arg5=session.CareProvID;
                      
                    }
                });
		        //$("#operlistBox").datagrid("reload");
	            //console.log(calEvent);
	        },
	        events: function(start, end, timezone, callback) {
		        var status="Application^Audit^Receive^Arrange^RoomIn^RoomOut^PACUIn^PACUOut^Finish^DaySurgery"
		        var surgeonId="";
		        var testDateStr=start.format()+"|"+end.format();
		   		//if (ops.dayDepts.indexOf(session.DeptID)<0) surgeonId=session.CareProvID || '';
		        var daySurgeryQty=dhccl.runServerMethod(ANCLS.BLL.DaySurgery,"GetDaySurgeryQty",start.format(),end.format(),status,surgeonId)
		        if (daySurgeryQty){
			        var event = toCalendarDatas(daySurgeryQty);
	                callback(event);
			    }
	        }
	    });	
	}
    function initOperList(){
		 
        var columns=[[
            {field:"CheckStatus",title:"勾选",checkbox:true},
            {field:"StatusDesc",title:"状态",width:50,styler:function(value,row,index){
                return "background-color:" + row.StatusColor + ";";
            }}, 
            {field:"OperDate",title:"手术日期",width:100},
            {field:"RegNo",title:"登记号",width:95},
            {field:"PatName",title:"患者姓名",width:76},
            {field:"PatGender",title:"性别",width:45},
            {field:"PatAge",title:"年龄",width:50},
            {field:"PatPhoneNumber",title:"手机号",width:100},
            {field:"PrevDiagnosisDesc",title:"术前诊断",width:160},
            {field:"OperDesc",title:"手术名称",width:200},
            {field:"SurgeonDesc",title:"主刀",width:62},
            {field:"Requirement",title:"手术要求",width:200},
            {field:"AnaMethod",title:"麻醉方法",width:100,formatter:function(value,row,index){
                return row.AnaMethodDesc;
            }},
            {field:"DaySurgeryNote",title:"日间备注",width:160,formatter:function(value,row,index){
	         	return "<span title='"+value+"'>"+value+"</span>";   
	         }},
	         {field:"OperRoom",title:"手术间",width:69,formatter:function(value,row,index){
                return row.RoomDesc;
            }},
            {field:"OperSeq",title:"台次",width:60},
            {field:"PatDeptDesc",title:"患者科室",width:120},
            {field:"AdmDate",title:"就诊日期",width:90},
            {field:"AdmDocDesc",title:"就诊医生",width:76},
            {field:"AppDeptDesc",title:"申请科室",width:100},
            {field:"OperDeptDesc",title:"手术室",width:100},
            {field:"PlanSeq",title:"申请台次",width:76},
            {field:"PatBedCode",title:"床号",width:76},
            {field:"OperNote",title:"备注",width:120},
            {field:"AsstDesc",title:"助手",width:80},
            {field:"OperPositionDesc",title:"体位",width:62},
            {field:"Infection",title:"感染",width:120,styler:function(value,row,index){
                var infection=(row.Infection);
                   if(infection&&(infection.indexOf('阳性')>=0)) return 'BACKGROUND-COLOR: #FFFF00;';
            }},
            {field:"ScrubNurse",title:"器械护士",width:112,formatter:function(value,row,index){
                return row.ScrubNurseDesc;
            }},
            {field:"CircualNurse",title:"巡回护士",width:112,formatter:function(value,row,index){
                return row.CircualNurseDesc;
            }},
            
            {field:"Anesthesiologist",title:"麻醉医生",width:80,formatter:function(value,row,index){
                return row.AnesthesiologistDesc;
            }},
            {field:"AnaExpert",title:"麻醉指导",width:80,formatter:function(value,row,index){
                return row.AnaExpertDesc;
            }},
            {field:"AnaAssistant",title:"麻醉助手",width:120,formatter:function(value,row,index){
                return row.AnaAssistantDesc;
            }},
            {field:"DaySurgery",title:"日间",width:45},
            {field:"OPSID",title:"手术ID",width:80},
            {field:"EpisodeID",title:"就诊ID",width:120,sortable: true},
            {field:"SourceTypeDesc",title:"类型",width:50,styler: function (value, row, index) {
                switch (row.SourceType) {
                    case "B":
                        return "background-color:"+SourceTypeColors.Book+";";
                    case "E":
                        return "background-color:"+SourceTypeColors.Emergency+";";
                    default:
                        return "background-color:white;";
                }
            }}
        ]];

        $("#operlistBox").datagrid({
            fit:true,
            title:"手术列表",
            headerCls:"panel-header-gray",
            iconCls:"icon-paper",
            rownumbers: true,
            pagination: true,
            pageSize: 50,
            pageList: [10,20,30,40,50, 100, 200,300,400,500],
            checkbox: true,
            checkOnSelect:true,
            selectOnCheck:true,
            singleSelect:true,
            toolbar:"#operlistTool",
            columns:columns,
            //sortName: "EpisodeID",  //日间手术日程列表上默认按照就诊日期排序 20210106 zt
            url: ANCSP.MethodService,
            queryParams: {
                ClassName: "CIS.AN.BL.DayCalendar",
                MethodName: "GetScheduleList",
                ArgCnt: 5
            },
             onBeforeLoad:function(param)
             {
                        param.Arg1=ops.eventDate || '';
                        param.Arg2="";
                        param.Arg3=$("#filterRegNo").val();
                        param.Arg4=$("#filterName").val();
                        param.Arg5=session.CareProvID;
              
            },
            onLoadError:function(res){
                alert(res.responseText)
                //console.log("ABC");
            },
            onSelect:function(rowIndex,rowData){
	        	dhccl.setHeaderParam(rowData);    
	        }

        });
        
        $("#btnQuery").linkbutton({
	    	onClick:function(){
		    	$("#operlistBox").datagrid("reload");	
		    }    
	    });
	    
	    $("#filterRegNo").keydown(function(e){
	        if(e.keyCode===13){
		        console.log(e);
	            var text=$("#filterRegNo").val();
	            if(text && text.length<10){
	                var zeroArr=[];
	                for(var i=0;i<10-text.length;i++){
	                    zeroArr.push(0);
	                }
	                $("#filterRegNo").val(zeroArr.join("")+text);
	            }
	            $("#operlistBox").datagrid("reload");
	        }
	    });
	    
	    $("#filterName").keydown(function(e){
		   if(e.keyCode===13){
			   var text=$("#filterName").val();
			   $("#operlistBox").datagrid("reload");
			} 
		});
        //----------------
        $HUI.radio("[id='self']",{
            checked:true,
       onChecked:function(e,value){

        $('#operlistBox').datagrid({
            url: ANCSP.MethodService,
            queryParams: {
                ClassName: "CIS.AN.BL.DayCalendar",
                MethodName: "GetScheduleList",
                ArgCnt: 5
            },
             onBeforeLoad:function(param)
             {
                param.Arg1=ops.eventDate || '';
                param.Arg2="";
                param.Arg3=$("#filterRegNo").val();
                param.Arg4=$("#filterName").val();
                param.Arg5=session.CareProvID;
              
            }
        });
        $HUI.datagrid("#operlistBox").reload();
       }
   });   

   $HUI.radio("[id='loc']",{
       onChecked:function(e,value){
        
        $('#operlistBox').datagrid({
            url: ANCSP.MethodService,
            queryParams: {
                ClassName: "CIS.AN.BL.DayCalendar",
                MethodName: "GetScheduleList",
                ArgCnt: 5
            },
             onBeforeLoad:function(param)
             {
                param.Arg1=ops.eventDate || '';
                param.Arg2=session.DeptID;
                param.Arg3=$("#filterRegNo").val();
                param.Arg4=$("#filterName").val();
                param.Arg5="";
              
            }
           
        })
        $HUI.datagrid("#operlistBox").reload();
       }
   });
   $HUI.radio("[id='all']",{
       
       onChecked:function(e,value){

          $('#operlistBox').datagrid({
            url: ANCSP.MethodService,
            queryParams: {
                ClassName: "CIS.AN.BL.DayCalendar",
                MethodName: "GetScheduleList",
                ArgCnt: 5
            },
             onBeforeLoad:function(param)
             {
                param.Arg1=ops.eventDate || '';
                param.Arg2="";
                param.Arg3=$("#filterRegNo").val();
                param.Arg4=$("#filterName").val();
                param.Arg5="";
              
            }
           
        })
        $HUI.datagrid("#operlistBox").reload();
    }
   });   
   //-----------------------
	}
	function initDSNoteDialog()
	{
		$("#btnSaveDSNote").linkbutton({
			onClick:function(){
				var rowData=$("#operlistBox").datagrid("getSelected");
		        if(!rowData){
		          $.messager.alert("提示","请先选择一条手术，再进入工作站！","warning");
		          return;
		         }
			     
			     if(rowData.DaySurgery!="Y"){
		             $.messager.alert("提示","请先选择日间手术","warning");
		             return;
		         }
	    		 
	    		 var note=$("#DaySurgeryNote").val();
	    		 var saveRet=AIS.Action({action:"AN/SaveDSNote",opsId:rowData.OPSID,DSNote:note,log:"Y"});
	    		 if(saveRet.indexOf("S^")===0)
	    		 {
		    		$.messager.popover({type:"success",timeout:1500,msg:"保存日间备注成功"});
		    		$("#DSNoteDialog").dialog("close");	
		    		$("#operlistBox").datagrid("reload");	 
		    	}else{
			    	$.messager.alert("提示","保存日间备注失败，原因："+saveRet,"error");	
			    }
			}	
		});
		
		$("#btnExistDSDialog").linkbutton({
			onClick:function(){
				$("#DSNoteDialog").dialog("close");	
			}	
		});
		
		$("#DSNoteDialog").dialog({
			onClose:function(){
				$("#DSNoteForm").form("clear");	
			}	
		})
	}
	function initAction()
    {
        var retType=dhccl.runServerMethodNormal("CIS.AN.BL.DayCalendar","GetDocLocType",session.DeptID,session.UserID,session.GroupID);
       // alert(retType)
        if(retType!="DOCTOR")
        {
            $("#btnPanel").css("display", "block"); 
        }
        else{
            $("#btnPreDaySurgery").remove();
            //$("#btnPreDaySurgery").remove();
            //$("#btnPreDaySurgery").remove();
        }
//202002+dyl
$("#btnEditDaySurgery").linkbutton({
    onClick:editDaySurgery
});
$("#btnConfirmDaySurgery").linkbutton({
    onClick:confirmDaySurgery
});
$("#btnPreDaySurgery").linkbutton({
    //onClick:preDaySurgery
});
$("#btnPostDaySurgery").linkbutton({
    onClick:postDaySurgery
});
//202003+dyl
$("#btnOutDaySurgery").linkbutton({
    onClick:outDaySurgery
});
$("#btnCancelDayOper").linkbutton({
    onClick:QuitDaySurgery
});
$("#btnOperFollowup").linkbutton({
    onClick:operFollowup
});
}
function operFollowup() {
    var selectedData=$("#operlistBox").datagrid("getSelected");
    if(!selectedData){
        $.messager.alert("提示","请先选择手术记录，再进行修改。","warning");
        return;
    }
    if(!selectedData.DaySurgery)
    {
        $.messager.alert("提示","只能操作日间手术。","warning");
        return; 
    }
    if((selectedData.StatusCode!="Finish"))
    {
        $.messager.alert("提示","只能操作完成状态的日间手术。","warning");
        return; 
    }
    var url="CIS.AN.OperFollowupDayCommon.csp?opsId="+selectedData.OPSID+"&EpisodeID="+selectedData.EpisodeID+"&PatientID="+selectedData.PatientID+"&MRAdmID="+selectedData.MRAdmID;
    
    var href="<iframe scrolling='yes' frameborder='0' src='" + url + "' style='width:100%;height:100%'></iframe>";
    $("#editDaySurgeryApp").dialog({
        content:href,
        title:selectedData.PatName+"的术后随访",
        iconCls:"icon-w-edit",
      resizable:true,
      width:1110,
    height:670
    });
    
    $("#editDaySurgeryApp").dialog("open");


}
function outDaySurgery()
{
    var selectedData=$("#operlistBox").datagrid("getSelected");
    if(!selectedData){
        $.messager.alert("提示","请先选择手术记录，再进行修改。","warning");
        return;
    }
    var curStatus=selectedData.DaySurgery;
    if(curStatus!="Y"){
        $.messager.alert("提示","请先选择日间手术，再进行修改。","warning");
        return;
    }
    if(selectedData.StatusCode!="Finish")
    {
        $.messager.alert("提示","只能操作完成状态的日间手术。","warning");
        return; 
    }
    var url="CIS.AN.DaySurgeryOut.csp?opsId="+selectedData.OPSID+"&EpisodeID="+selectedData.EpisodeID+"&PatientID="+selectedData.PatientID+"&MRAdmID="+selectedData.MRAdmID;
    var href="<iframe scrolling='yes' frameborder='0' src='" + url + "' style='width:100%;height:100%'></iframe>";
    $("#editDaySurgeryApp").dialog({
        content:href,
        title:selectedData.PatName+"的日间出院评估",
        iconCls:"icon-w-edit",
	    resizable:true,
	    width:1054,
		height:690
    });
    
    $("#editDaySurgeryApp").dialog("open");
}
function postDaySurgery()
{
    var selectedData=$("#operlistBox").datagrid("getSelected");
    if(!selectedData){
        $.messager.alert("提示","请先选择手术记录，再进行修改。","warning");
        return;
    }
    var curStatus=selectedData.DaySurgery;
    if(curStatus!="Y"){
        $.messager.alert("提示","请先选择日间手术，再进行修改。","warning");
        return;
    }
    if(selectedData.StatusCode!="Finish")
  {
      $.messager.alert("提示","只能操作完成状态的日间手术。","warning");
      return; 
  }

    var url="CIS.AN.DaySurgeryPost.csp?opsId="+selectedData.OPSID+"&EpisodeID="+selectedData.EpisodeID+"&PatientID="+selectedData.PatientID+"&MRAdmID="+selectedData.MRAdmID;
    var href="<iframe scrolling='yes' frameborder='0' src='" + url + "' style='width:100%;height:100%'></iframe>";
    $("#editDaySurgeryApp").dialog({
        content:href,
        title:selectedData.PatName+"的日间恢复评估",
        iconCls:"icon-w-edit",
	    resizable:true,
	    width:1054,
		height:695
    });
    
    $("#editDaySurgeryApp").dialog("open");
}
function QuitDaySurgery(){
    //退出日间
    var selectedData=$("#operlistBox").datagrid("getSelected");
  if(!selectedData){
      $.messager.alert("提示","请先选择手术记录，再进行修改。","warning");
      return;
  }
  if((selectedData.StatusCode!="DaySurgery")&&(selectedData.StatusCode!="Application")&&(selectedData.StatusCode!="Finish"))
  {
      $.messager.alert("提示","只能操作日间、申请或完成状态的日间手术。","warning");
      return; 
  }
  var url="CIS.AN.DaySurgeryDecline.csp?opsId="+selectedData.OPSID+"&EpisodeID="+selectedData.EpisodeID+"&PatientID="+selectedData.PatientID+"&MRAdmID="+selectedData.MRAdmID;
  
  var href="<iframe scrolling='yes' frameborder='0' src='" + url + "' style='width:100%;height:100%'></iframe>";
  $("#editDaySurgeryApp").dialog({
      content:href,
      title:selectedData.PatName+"退出日间",
      iconCls:"icon-w-edit",
    resizable:true,
    width:360,
  height:370
  });

  $("#editDaySurgeryApp").dialog("open");
  }
	//202002+dyl
function editDaySurgery()
{
    var selectedData=$("#operlistBox").datagrid("getSelected");
    if(!selectedData){
        $.messager.alert("提示","请先选择手术记录，再进行修改。","warning");
        return;
    }
   
    if(selectedData.StatusCode!="DaySurgery"){
        $.messager.alert("提示","当前状态无修改手术的权限。","warning");
        return;
    }

    var url="CIS.AN.DaySurgeryApp.csp?opsId="+selectedData.OPSID+"&EpisodeID="+selectedData.EpisodeID+"&PatientID="+selectedData.PatientID+"&MRAdmID="+selectedData.MRAdmID+"&IsConfirm="+"N";
    var href="<iframe scrolling='yes' frameborder='0' src='" + url + "' style='width:100%;height:100%'></iframe>";
    $("#editDaySurgeryApp").dialog({
        content:href,
        title:selectedData.PatName+"的日间手术修改",
        iconCls:"icon-w-edit",
	    resizable:true,
	    width:1130,
		height:700
    });
    
    $("#editDaySurgeryApp").dialog("open");
}
//确认
function confirmDaySurgery()
{
    var selectedData=$("#operlistBox").datagrid("getSelected");
    if(!selectedData){
        $.messager.alert("提示","请先选择手术记录，再进行修改。","warning");
        return;
    }
    if(selectedData.StatusCode!="DaySurgery"){
        $.messager.alert("提示","当前状态无修改手术的权限。","warning");
        return;
    }
    var url="CIS.AN.DaySurgeryApp.csp?opsId="+selectedData.OPSID+"&EpisodeID="+selectedData.EpisodeID+"&PatientID="+selectedData.PatientID+"&MRAdmID="+selectedData.MRAdmID+"&IsConfirm="+"Y";
    var href="<iframe scrolling='yes' frameborder='0' src='" + url + "' style='width:100%;height:100%'></iframe>";
    $("#editDaySurgeryApp").dialog({
        content:href,
        title:selectedData.PatName+"的日间手术确认",
        iconCls:"icon-w-edit",
	    resizable:true,
	    width:1130,
		height:700
    });
    
    $("#editDaySurgeryApp").dialog("open");
}
function closeDaySurgeryDiag()
{
    $("#editDaySurgeryApp").dialog("close");
    $("#operlistBox").datagrid("clearSelections");
    $("#operlistBox").datagrid("reload");
}
function closePreDaySurgery()
{
    $("#editDaySurgeryApp").dialog("close");
    $("#operlistBox").datagrid("clearSelections");
    $("#operlistBox").datagrid("reload");
}
	
	
	function toCalendarDatas(jsonDatas) {
	    var calendarDatas = [];
	    if (jsonDatas && jsonDatas.length > 0) {
	        $.each(jsonDatas, function(index, item) {
	            calendarDatas.push({
	                id: item.RowId,
	                title: item.OperQty,
	                allDay: true,
	                start: item.OperDate,
	                end: item.OperDate,
	                OperDate: item.OperDate
	            });
	        });
	    }
	    return calendarDatas;
	}
	
	function removeFunction(){
		if (ops.dayDepts.indexOf(session.DeptID)<0){
			//$("#btnConfirmDaySurgery").remove();
			$("#btnBatchConfirmDaySurgery").remove();	
			$("#btnDocWorkstation").remove();	
		}	
		
	}
    //20211101+dyl
    function RegSearch()
    {
        if(window.event.keyCode==13)
        {
            var newregno=dhccl.runServerMethodNormal("CIS.AN.BL.OperSchedule","FormatPatientNo",$("#filterRegNo").val())
            $("#filterRegNo").val(newregno);
            $HUI.datagrid("#operlistBox").load();
        }
    }
	
	$(document).ready(initPage);
	
	