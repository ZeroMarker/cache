var	userid = session['LOGON.USERID'];
var groupid = session['LOGON.GROUPID'];
var GroupDesc= session['LOGON.GROUPDESC'] ;
var CTLOCID= session['LOGON.CTLOCID'] ;
var TalStartDate='';
var ASRoomData="";
var DateFormat="";
var CurrDate=tkMakeServerCall("web.DHCBatchStopNew","GetCurrDate");
$(function(){
	Init() 
 });
 function Init(){
	InitLocDocTree()
	InitScheduleTab("")
	InitButton();
	InitWinCombo();
	//替诊页面
	InitReplaceWin(); 
	//停诊
	InitStopWin();
	InittabRBASApptNum("","","");
	/*
	if ((session['LOGON.GROUPDESC'].indexOf("门办")<0)&&(session['LOGON.CTLOCID']!=555)){
		//隐藏 toolbar 第二个和第三个按钮
		$('div.datagrid-toolbar a').eq(1).hide();
		$('div.datagrid-toolbar a').eq(2).hide();
		$('div.datagrid-toolbar a').eq(0).hide();
		$('div.datagrid-toolbar div').eq(0).hide();
		$('div.datagrid-toolbar div').eq(1).hide();
		$('div.datagrid-toolbar div').eq(2).hide();
	}*/
	$("#tree-panel").css("height",$(window).height()-120);
	DateFormat=tkMakeServerCall("websys.Conversions","DateFormat")
	$(document.body).bind("keydown",BodykeydownHandler)
 }
 function BodykeydownHandler(e) {
	if (window.event){
		var keyCode=window.event.keyCode;
		var type=window.event.type;
		var SrcObj=window.event.srcElement;
	}else{
		var keyCode=e.which;
		var type=e.type;
		var SrcObj=e.target;
	}
   //浏览器中Backspace不可用  
   var keyEvent;   
   if(e.keyCode==8){   
       var d=e.srcElement||e.target;
        if(d.tagName.toUpperCase()=='INPUT'||d.tagName.toUpperCase()=='TEXTAREA'){   
            keyEvent=d.readOnly||d.disabled;   
        }else{   
            keyEvent=true;   
        }   
    }else{   
        keyEvent=false;   
    }   
    if(keyEvent){   
        e.preventDefault();   
    }   
}
  function InitButton(){
	$("#SerchLoc").bind("keyup",findLocData);
	$("#SerchDoc").bind("keyup",findLocData);
	$("#FindAll").bind("click",function(){
		//取消tree结点的选中
		$('#LocDocTree').find('.tree-node-selected').removeClass('tree-node-selected');
		FindScheduleByLoc("","","")
	});
	
	$("#Find").bind("click",function(){
	
		var StartDate=$("#StartDate").datebox("getValue"); 
		$('#ScheduleTab').tabs({
			onSelect:function (){
			}
		})
	    var tabs = $("#ScheduleTab").tabs("tabs");
		var length = tabs.length;
		for(var i = 0; i < length; i++) {
		    var onetab = tabs[0];
		    var title = onetab.panel('options').tab.text();
		    $("#ScheduleTab").tabs("close", title);
		}
		InitScheduleTab(StartDate) ;
	});
	
	var GroupDesc= session['LOGON.GROUPDESC'] ;
	var CTLOCID= session['LOGON.CTLOCID'] ;
	if ((GroupDesc.indexOf("门办")<0)&&(CTLOCID!=555)){
		//$('#EChkRep').attr("disabled",true);
		$('#EChkStop').attr("disabled",true)
	}
	
	$("#ApptMax").bind("keyup",LimitApptMax);
	//$("#EChkRep").on("click", EChkRepClick);
	$("#EChkStop").on("click", EChkStopClick);
	
	$("#save").on("click", save);
	$("#cancel").on("click", cancel);
	$("#TRFlag").on("click", TRTimeRangeClick);
	
	//$("#PositiveMax").bind("keyup",LimitPositiveMax);

 }
 function TRTimeRangeClick(){
	 if($("#TRFlag").is(':checked')){
		 var SessTimeStart=$("#StartTime").val();
		 var SessTimeEnd=$("#EndTime").val();
		 $('#TRSartTime').attr('value',SessTimeStart);
		 $('#TREndTime').attr('value',SessTimeEnd);
	 }
	 
 }
 function LimitApptMax()
 {
	 	var EPositiveMax = $("#PositiveMax").val() ; 			//正号限额
		var EApptMax = $("#ApptMax").val() ; 				//预约限额
		var EStartPrefix = $("#EStartPrefix").val() ;		//预约起始号			
		if (parseInt(EPositiveMax)!=0){
			if ((parseInt(EPositiveMax))<(parseInt(EApptMax))){
				$.messager.alert('错误', "正号限额不能小于预约限额！ ");
				return false;
			}
			if (parseInt(EApptMax)!=0){
				if ((parseInt(EPositiveMax)-parseInt(EStartPrefix)+1)<(parseInt(EApptMax))){
					$.messager.alert('错误', "正号限额减去预约起始号要大于等于预约限额！  ");
					return false;
				}
			}

			if(parseInt(EApptMax)<=0){
				//$.messager.alert('错误', "预约限额不能小于或等于0");
				//return false;
			}
		}
		
		//$("#TRRegNum").attr('value',EApptMax);
 }
 function LimitPositiveMax(){
	var EPositiveMax = $("#PositiveMax").val() ; 
	if(EPositiveMax-3>0){
		$("#TRRegNum").attr('value',EPositiveMax-3); 
	}else{
		$("#TRRegNum").attr('value',""); 
	}
	
 }
 
 /*function EChkRepClick()
 {
	 var check=$("#EChkRep")[0].checked ;
	 if (check){
		 $('#EChkStop').attr("checked",false);
		 LimitECombo('enable','Rep')
	 }else{
		 LimitECombo('disable','Rep')
	 }
 } */
 function EChkStopClick()
 {
	 var check=$("#EChkStop")[0].checked ;
	 if (check){
		 //$('#EChkRep').attr("checked",false);
		 LimitECombo('enable','Stop')
	 }else{
		 LimitECombo('disable','Stop')
	 }
 }
 
 function LimitECombo(flag,type)
 {
	//$('#EAdmLoc').combobox(flag);
	//$('#EAdmDoc').combobox(flag);
	//$('#EDocSession').combobox(flag);
	$('#EReason').combobox(flag);
	$('#ELeader').combobox(flag);
	if (type=='Stop'){
		//$('#EAdmDoc').combobox('disable');
		//$('#EAdmLoc').combobox('disable');
		//$('#EDocSession').combobox('disable');
	}
 }
 
 function save()
 {
	if (!ValidateInput()) return ;
	var ASRowID=$("#ASRowID").val() ;
	if (ASRowID!=""){
		var ret=UpdateAS(ASRowID) ;
	}else{
		var ret=SaveNewAS() ;
	}
	if (ret) {
		/*var tab=$('#ScheduleTab').tabs("getSelected");
		var index = $('#ScheduleTab').tabs('getTabIndex',tab);
		var GridId = "ScheduleGrid"+index
		$("#"+GridId).datagrid('reload'); 	*/
		ReLoadScheduleGrid();	
		// var LocID=$("#AdmLoc").combogrid("getValue");	  // 按科室,方便同时看替/被替诊医生
		// FindScheduleByLoc(LocID,"","");
		cancel();
	}
 }
 
function UpdateAS(ASRowID) 
{
	var ret=tkMakeServerCall("web.DHCRBApptSchedule","ApptScheduleIsLater",ASRowID)
	if (ret<0){
		$.messager.alert('错误', "操作号源已超过号源可用时间! ");
		return false;
	}
	/*if($("#EChkRep")[0].checked)
	{		
		var mRepLocId =$("#AdmLoc").combogrid("getValue");	
		var mRepDoctorId=$("#EAdmDoc").combogrid("getValue");	
		if (mRepDoctorId==""){
			$.messager.alert('提示', '替诊医生不能为空!');
			return false;
		}
		var RepSessionTypeRowId=$("#EDocSession").combogrid("getValue");	
		if (RepSessionTypeRowId==""){
			$.messager.alert('提示', '替诊职称不能为空!');
			return false;
		}
					
		mRepLeaderId=$("#ELeader").combogrid("getValue");	
		mRepReasonId=$("#EReason").combogrid("getValue");	
		var IsAudit="0";
		if (ret>0){
			IsAudit="1";
		}
		
		var ret1 = cspHttpServerMethod(MRep.value,ASRowID,mRepDoctorId,mRepLocId,mRepReasonId,mRepLeaderId,RepSessionTypeRowId,IsAudit);
		var temparr=ret1.split("^");
		var ret=temparr[0];
		if (ret==0){
			$.messager.alert('提示', '替诊成功!');
			return true;
		}else{
			switch(parseInt(ret))
			{
			case 300:
				$.messager.alert('错误', '医生没有安排资源!');
		 		break;
			case 200:	
				$.messager.alert('错误', '医生已经有排班记录!');
				break;
			case 100:
		  		$.messager.alert('错误', '替诊失败!');
				break;
			case 101:
				$.messager.alert('错误', '复制被替诊医生的预约限额记录失败');		
		  		break;
			default:
				$.messager.alert('错误', ret);
				break;	
 	 		}
 	 		return false;
		}
	}else{*/
		var LockFlag="N";

		var total = $("#PositiveMax").val() ; 			//正号限额
		var book = $("#ApptMax").val() ; 				//预约限额
		var AppClientNum = tkMakeServerCall("web.DhcResEffDateSessionClass","GetAppClientNum",ASRowID,"RBASSchedule");
		if(+AppClientNum>+book)	{
			$.messager.alert('错误', "预约限额不能小于各个预约机构限额!");
			return false;
		}
		var over = $("#AddtionMax").val() ;				//加号限额
		var startNum = $("#EStartPrefix").val() ;		//预约起始号
		if (book==0){startNum=0}
		if (((startNum=="")||(startNum<=0))&(book>0)){
		  $.messager.alert('错误', "预约起始号数量格式不正确")
		  return false;
	    }			
		//var AutoLoad=$("#AutoLoad").val()
		//var ExtLoad=$("#ExtLoad").val()	
		var TimeStart = $("#StartTime").val() ;		
		var TimeEnd = $("#EndTime").val() ;		
		//分时段就诊
		var TRFlag="Y",TRStartTime="",TREndTime="",TRLength="",TRRegNum="",TRRegNumStr="",TRRegInfoStr="",StopRegNoFlag="Y";
		if(!$("#TRFlag").is(':checked')){
		   TRFlag = "N"
	    }
	    if(!$("#StopRegNoFlag").is(':checked')){
		   StopRegNoFlag = "N"
	    }
	    if (TRFlag=="Y"){
		    var TRStartTime=$("#TRSartTime").val() ;
			var TREndTime=$("#TREndTime").val() ;		
			var TRLength=$("#TRLength").val(); //'10'  ; //$("#StartTime").val() ;		
			var TRRegNum=$("#TRRegNum").val() ;
			if ((TRRegNum=="")||(TRRegNum==0)){
				$.messager.alert('错误', "分时段时段号数不能为空或0! ");
				return false;
			}
			var r = /^[0-9]*[1-9][0-9]*$/
			if (!r.test(TRRegNum)){
				$.messager.alert('错误', "分时段时段号数只能为正整数! ");
				return false;
		    }	
			if(+TRRegNum>+(total)){
				$.messager.alert('错误', "分时段时段号数不能大于正号限额! ");
				return false;
			}
			if ((TRRegNum!="")&&(!TRInfoCalculate(TRStartTime,TREndTime,TRLength,TRRegNum,startNum))) return false;
		
			TRRegNumStr=$("#TRRegNumStr").val() ;		
			TRRegInfoStr=$("#TRRegInfoStr").val() ;	
		}

		var AdmLoc = $("#AdmLoc").combogrid("getValue");	
		var AdmDoc = $("#AdmDoc").combogrid("getValue");	
		var TimeRange = $("#TimeRange").combogrid("getValue");	
		var LocArea = $("#LocArea").combogrid("getValue");	
		var DocSession = $("#DocSession").combogrid("getValue");
		var ClinicGroup	= $("#ClinicGroup").combogrid("getValue");
		var TimeRangeStr=TRFlag+"^"+TRStartTime+"^"+TREndTime+"^"+TRLength+"^"+TRRegNum+"^"+TRRegNumStr+"^"+TRRegInfoStr;
		
		if (total  && ASRowID)
		{
			//var ret1 = cspHttpServerMethod(MBase.value,ASRowID,LocArea,total,over,book,startNum,ClinicGroup,DocSession,LockFlag,TimeStart,TimeEnd,TimeRangeStr,AutoLoad,ExtLoad);
			var ret1 = cspHttpServerMethod(MBase.value,ASRowID,LocArea,total,over,book,startNum,ClinicGroup,DocSession,LockFlag,TimeStart,TimeEnd,TimeRangeStr,StopRegNoFlag);
			var temparr=ret1.split("^")
			var ret=temparr[0];
			if (ret == 0) 	{
				$.messager.alert('成功', "修改成功! ");
				return true;
			}else {
				  if (ret=="-201"){$.messager.alert('错误', "同一个医生不能在同一天同一时段安排两次！ "+temparr[1]);return;}
				  if (ret=="-202"){$.messager.alert('错误', "此诊室已经在同一天同一时段被安排过！ "+temparr[1]);return;}
				  if (ret=="-203"){$.messager.alert('错误', "正号限额不能小于已挂出号数! ");return;}
				  if (ret=="-204"){$.messager.alert('错误', "预约限额不能小于已预约数 ");return;}
				  if (ret=="-205"){$.messager.alert('错误', "加号限额不能小于已挂出数 ");return;}
				$.messager.alert('错误', "修改失败! ");
				return false;
			}
		}
	//}
} 
 
function SaveNewAS()
{
 	var scheduleDate=$("#AdmDate").datebox("getValue"); 
 	var StatusCode="A";				// 默认加诊
	
 	var total = $("#PositiveMax").val() ; 			//正号限额
	var book = $("#ApptMax").val() ; 				//预约限额
	var over = $("#AddtionMax").val() ;				//加号限额
	var startNum = $("#EStartPrefix").val() ;		//预约起始号
	if (book==0){startNum=0}
	if (((startNum=="")||(startNum<=0))&(book>0)){
	  $.messager.alert('错误', "预约起始号数量格式不正确")
	  return false;
    }
	//var AutoLoad=$("#AutoLoad").val()
	//var ExtLoad=$("#ExtLoad").val()	

	var TimeStart = $("#StartTime").val() ;		
	var TimeEnd = $("#EndTime").val() ;		
	
	//分时段就诊
	var TRFlag="Y",TRStartTime="",TREndTime="",TRLength="",TRRegNum="",TRRegNumStr="",TRRegInfoStr="",StopRegNoFlag="Y";
	if(!$("#TRFlag").is(':checked')){
		TRFlag = "N"
	}
	if(!$("#StopRegNoFlag").is(':checked')){
		StopRegNoFlag = "N"
	}
	if (TRFlag=="Y"){
		var TRStartTime=$("#TRSartTime").val() ;
		var TREndTime=$("#TREndTime").val() ;		
		var TRLength=$("#TRLength").val();	 //'10'  ; //$("#StartTime").val() ;		
		var TRRegNum=$("#TRRegNum").val() ;	
		if ((TRRegNum=="")||(TRRegNum==0)){
			$.messager.alert('错误', "分时段时段号数不能为空或0! ");
			return false;
		}
		if(+TRRegNum>+(total.value)){
			$.messager.alert('错误', "分时段时段号数不能大于正号限额! ");
			return false;
		}
		
		if (!TRInfoCalculate(TRStartTime,TREndTime,TRLength,TRRegNum,startNum)) return false;
		
		TRRegNumStr=$("#TRRegNumStr").val() ;		
		TRRegInfoStr=$("#TRRegInfoStr").val() ;	
	}
		

	var AdmLoc = $("#AdmLoc").combogrid("getValue");	
	var AdmDoc = $("#AdmDoc").combogrid("getValue");	
	var TimeRange = $("#TimeRange").combogrid("getValue");	
	var LocArea = $("#LocArea").combogrid("getValue");	
	var DocSession = $("#DocSession").combogrid("getValue");
	var ClinicGroup	= $("#ClinicGroup").combogrid("getValue");
	var TimeRangeStr=TRFlag+"^"+TRStartTime+"^"+TREndTime+"^"+TRLength+"^"+TRRegNum+"^"+TRRegNumStr+"^"+TRRegInfoStr;
	
	
	//var ret1 = cspHttpServerMethod(MNew.value,scheduleDate,AdmDoc,AdmLoc,TimeRange,total,book,over,LocArea,DocSession,ClinicGroup,startNum,TimeStart,TimeEnd,StatusCode,TimeRangeStr,"",AutoLoad,ExtLoad);
	var ret1 = cspHttpServerMethod(MNew.value,scheduleDate,AdmDoc,AdmLoc,TimeRange,total,book,over,LocArea,DocSession,ClinicGroup,startNum,TimeStart,TimeEnd,StatusCode,TimeRangeStr,"",StopRegNoFlag,session['LOGON.GROUPID']);
	var temparr=ret1.split("^");
	var ret=temparr[0];
	if (ret){
		if (ret=="0")	{
			var SucceASRowID=temparr[1];
			//var msg="新增排班记录成功,请根据情况修改限额！"
			var msg="新增排班记录成功！"
			//var RequestRet=tkMakeServerCall("web.DHCRBApptScheduleAudi","GetRBASRequestFlag","N",SucceASRowID,session['LOGON.GROUPID']);
			//var RequestRetArr=RequestRet.split("^");
			//var RequestFlag=RequestRetArr[0];
			var RequestFlag=temparr[2];
			if(RequestFlag==1){
				//var msg="申请新增排班记录成功,请等待相关人员审批后,根据情况修改限额！";
				var msg="申请新增排班记录成功,请等待相关人员审批！";
			}
			ReLoadScheduleGrid();
			return true;
		}else{
			switch(ret)	{
				case '-201':
					$.messager.alert('错误', "同一个医生不能在同一天同一时段安排两次！ "+temparr[1]);
					break;
				case '-202':
					$.messager.alert('错误', "此诊室已经在同一天同一时段被安排过！ "+temparr[1]);
					break;
				case '300':
					$.messager.alert('错误', "医生没有安排资源!");
					break;
				case '200':	
					$.messager.alert('错误', "当前医生已经有排班记录!");
					break;
				default:
					$.messager.alert('错误', "新增排班记录失败!！ ");
					break;
			}
		}
	}
}

function TRInfoCalculate(TRStartTime,TREndTime,TRLength,TRRegNum,TRStartNum){
	if (TRStartTime==""){
		$.messager.alert('错误', "分时段开始时间格式不正确")
		return false;
	}
	if (TREndTime==""){
		$.messager.alert('错误', "分时段结束时间格式不正确")
		return false;
	}
	if ((TRLength=="")||(TRLength<0)){
		$.messager.alert('错误', "分时段时间间隔格式不正确")
		return false;
	}
	if ((TRRegNum=="")||(TRRegNum<0)){
		$.messager.alert('错误', "分时段号源数量格式不正确")
		return false;
	}
	if (parseFloat(TRStartNum)<0){
		$.messager.alert('错误', "预约起始号数量格式不正确")
		return false;
	}
	//var ret=tkMakeServerCall("web.DHCRBResSession","TRInfoCalculateNew",TRStartTime,TREndTime,TRRegNum,TRStartNum)
	var ret=tkMakeServerCall("web.DHCRBResSession","TRInfoCalculate",TRStartTime,TREndTime,TRLength,TRRegNum)
	var arr=ret.split("^");
	if (arr[0]!="0"){
		$.messager.alert('错误', arr[1]);
		return false;
	}else{
		RegNumStr=$("#TRRegNumStr").val() ;
		RegInfoStr=$("#TRRegInfoStr").val() ;		
		if ((RegNumStr!=""&&RegNumStr!=arr[1])||(RegInfoStr!=""&&RegInfoStr!=arr[2]))
		{
			if (!(confirm("旧号段信息"+RegNumStr+"\n新号段信息"+arr[1]+"\n旧时段信息"+RegInfoStr+"\n新时段信息"+arr[2]+"\n是否替换?"))) return false;
		}
		$("#TRRegNumStr").attr('value',arr[1]);
		$("#TRRegInfoStr").attr('value',arr[2]);
		return true;
	}
	
}
 
function ValidateInput()
{
	var ASDate=$("#AdmDate").datebox("getValue"); 			
	if (ASDate==""){
		$.messager.alert('错误', "出诊日期不能为空！ ");
		return false;
	}
	var AdmLoc = $("#AdmLoc").combogrid("getValue");	
	if (AdmLoc==''){
		$.messager.alert('错误', "出诊科室不能为空！ ");
		return false;
	}
	var AdmDoc = $("#AdmDoc").combogrid("getValue");	
	if (AdmDoc==''){
		$.messager.alert('错误', "出诊医生不能为空！ ");
		return false;
	}
	var TimeRange = $("#TimeRange").combogrid("getValue");	
	if (TimeRange==''){
		$.messager.alert('错误', "出诊时段不能为空！ ");
		return false;
	}
	var EPositiveMax = $("#PositiveMax").val() ; 		//正号限额
	var EApptMax = $("#ApptMax").val() ; 				//预约限额
	var EAddtionMax = $("#AddtionMax").val() ;			//加号限额
	var EStartPrefix = $("#EStartPrefix").val() ;		//预约起始号
    var ESessionType = $("#DocSession").combogrid("getValue");
	if (ESessionType==''){
		$.messager.alert('错误', "挂号职称不能为空！ ");
		return false;
		}	
	if (EPositiveMax==''){
		$.messager.alert('错误', "正号限额不能为空！ ");
		return false;
	}
	
	if ((parseFloat(EApptMax)>0)&&(EStartPrefix=='')){
		$.messager.alert('错误', "预约起始号不能为空！");
		return false;
	}

	if ((parseInt(EPositiveMax))<(parseInt(EApptMax))){
		$.messager.alert('错误', "正号限额不能小于预约限额！ ");
		return false;
	}
	if (parseInt(EApptMax)!=0){
		if ((parseInt(EPositiveMax)-parseInt(EStartPrefix)+1)<(parseInt(EApptMax))){
			$.messager.alert('错误', "正号限额减去预约起始号要大于等于预约限额！  ");
			return false;
		}
	}
	
	if (parseInt(EPositiveMax)>999){
		$.messager.alert('错误', "正号限额不能超过999!  ");
		return false;
	}
	
	if (parseInt(EApptMax)>99){
		//$.messager.alert('错误', "预约限额不能超过99!  ");
		//return false;
	}	
	/*var AutoLoad=$("#AutoLoad").val();
	var ExtLoad=$("#ExtLoad").val();
	if(parseInt(AutoLoad)>parseInt(EPositiveMax)){
		alert("自助限额不能大于正号限额")
		return
	}
	if(parseInt(ExtLoad)>parseInt(EPositiveMax)){
		alert("外部限额不能大于正号限额")
		return
	}*/
	return true;	
}

 
function cancel()
{
	$('#EditWin').window('close', true); 
}

function findLocData(event)
{
	var PyCode=$.trim($("#SerchLoc").val());
	var DocCode=$.trim($("#SerchDoc").val());
	var url = $("#LocDocTree").tree('options').url = "dhcrbapptschedulequeryrequest.csp?pid=0"+"&desc="+PyCode+"&userid="+userid+"&groupid="+groupid+"&docdesc="+DocCode ;
	$('#LocDocTree').tree('options').url =encodeURI(url);
	$(LocDocTree).tree('reload');
}

 function InitScheduleTab(StartDate)
 {
	var AdmDateStr=tkMakeServerCall("web.DHCApptScheduleNew","GetAdmDateStr",StartDate)
	var AdmDateStrArr=AdmDateStr.split("^")
	for(var i=0;i<AdmDateStrArr.length;i++){
		var admDate=AdmDateStrArr[i]
		$("#ScheduleTab").tabs("add",{
			title:admDate,
			content:'Tab Body'
		})
	}
	$('#ScheduleTab').tabs({
		heigth:'auto',
		onSelect: function(title,index){
			var CurrentTabPanel=$('#ScheduleTab').tabs("getSelected");
			var LocRowid=""
			var ExaRowid=""
			var DocRowid=""
			//判断科室有没有被选中的
			var selObj=$("#LocDocTree").tree("getSelected")
			if(selObj){
				var idStr=selObj.id
				var idStrArr=idStr.split("^")
				if(idStrArr[0]=="Loc"){
					LocRowid=idStrArr[1]
					var parentObj=$("#LocDocTree").tree("getParent",selObj.target)
					if (parentObj){
						var idStr=parentObj.id;
				        var idStrArr=idStr.split("^");
				        ExaRowid=idStrArr[1];
					}else{
						ExaRowid=idStrArr[2];
					}
				}else{
					debugger;
					if(idStrArr[0]=="Exa"){
						ExaRowid=idStrArr[1]
					}
					if(idStrArr[0]=="Doc"){
						var DocRowid=idStrArr[1];
						var parentNode=$("#LocDocTree").tree("getParent",selObj.target) ;
						var parentNodeid=parentNode.id ;
						var parentNodeidArr=parentNodeid.split("^")
						var LocRowid=parentNodeidArr[1];
					    /*//FindScheduleByLoc(LocRowid,DocRowid,"");
					    var grandPaNode = $("#LocDocTree").tree("getParent",parentNode.target);
						var grandPaNodeid=grandPaNode.id ;
						var grandPaNodeidArr=grandPaNodeid.split("^");
						ExaRowid=grandPaNodeidArr[1];
					    GetASRoomData(ExaRowid);*/
					}
				}
				
				//$("#LocDocTree").tree("uncheck",selObj.target)
			}
			//if (document.getElementById("ScheduleGrid"+index)){
			
			//} else{
				var TemplateTable=$('<div><table id="ScheduleGrid'+index+'"></table></div>');
				CurrentTabPanel.html(TemplateTable);
				var StartDate=title.split("(")[0]
				TalStartDate=StartDate ;
				InitScheduleGrid("ScheduleGrid"+index,CurrentTabPanel.height());
				if(LocRowid!=""){
					//setTimeout("ScheduleGridLoad('ScheduleGrid"+index+"','"+StartDate+"','"+LocRowid+"','','')",500)
					setTimeout("ScheduleGridLoad('ScheduleGrid"+index+"','"+StartDate+"','"+LocRowid+"','"+DocRowid+"','"+ExaRowid+"')",500)
					//(LocRowid+","+DocRowid+","+StartDate+","+userid+","+","+groupid+","+ExaRowid)
					return
				}
				if(ExaRowid!=""){
					setTimeout("ScheduleGridLoad('ScheduleGrid"+index+"','"+StartDate+"','"+''+"','','"+ExaRowid+"')",500)
					return
				}
				setTimeout("ScheduleGridLoad('ScheduleGrid"+index+"','"+StartDate+"','"+LocRowid+"','','')",500)
				
			//}
			
		}
	})
	$("#ScheduleTab").tabs("select",0)
 }
 
 function InitScheduleGrid(GridId,height){
	 //idField:'LocRowId',
	$("#"+GridId).datagrid({
		//title:"<img src='/dthealth/web/images/uiimages/createschedulelist.png' style='vertical-align:middle;'>&nbsp;&nbsp;排班记录",
		remoteSort:false,
		width:$(window).width()-360,
		border:true,
		striped:true,
		autoRowHeight:false,
		fitColumns : false,
		url:'',
		height:height-50,
		loadMsg:'正在加载',
		rownumbers:true,
		columns:[[
			{field:'check',title:'',width:120,align:'center',checkbox:true},
			{field:'ASRowId',title:'ASRowId',width:10,hidden:true},
			{field:'LocDesc',title:'出诊科室',width:150,align:'left',sortable:true},
			{field:'DocDesc',title:'出诊医生',width:100,align:'left',sortable:true,  
                formatter:function(value,rec){ 
                   var btn = '<a class="editcls" onclick="ApptUpDateLogShow(\'' + rec.ASRowId + '\')">'+value+'</a>';
			       return btn;
                }
            },
            {field:'ASRoom',title:'诊室名称',width:120,align:'left',sortable:true},
			{field:'ASSessionType',title:'职称',width:100,align:'left',sortable:true},
			{field:'TimeRange',title:'午别',width:60,align:'left',sortable:true},
			{field:'ASSessStartTime',title:'开始时间',width:60,align:'left'},
			{field:'ASSessionEndTime',title:'结束时间',width:60,align:'left'},
			{field:'ASLoad',title:'挂号限额',width:60,align:'left'},
			{field:'ASAppLoad',title:'预约限额',width:60,align:'left'},
			{field:'AppStartSeqNo',title:'预约起始号',width:80,align:'left'},
			{field:'ASAddLoad',title:'加号限额',width:60,align:'left'},
			{field:'ASQueueNoCount',title:'合计限额',width:60,align:'left'},
			//{field:'ASAutoLoad',title:'自助限额',width:40,align:'left'},
			//{field:'ASExtLoad',title:'外部限额',width:40,align:'left'},
			{field:'RegisterNum',title:'已挂号数',width:60,align:'left'},
			{field:'AppedNum',title:'已预约数',width:60,align:'left',
			   formatter:function(value,rec){ 
                   var btn = '<a class="editcls" onclick="AppedDataShow(\'' + rec.ASRowId + '\')">'+value+'</a>';
			       return btn;
                }
			},
			{field:'AppedArriveNum',title:'已取号数',width:60,align:'left'},
			{field:'QueueNO',title:'剩号',width:60,align:'left'},
			{field:'ASStatus',title:'状态',width:40,align:'left',sortable:true
				/*,formatter:function(val,rec){ 
					
					if (val =="停诊"){ 
						return '<span style="color:red; backcolor:blue; ">('+val+')</span>'; 
					} else { 
						return val; 
					}
				}  */
			},
			{field:'ASReason',title:'停替诊原因',width:80,align:'left'},
			{field:'IrregularFlag',title:'异常',width:40,align:'left'}
			//{field:'LoginTime',title:'登录时间',width:40,align:'left'},
			//{field:'LoginStatus',title:'是否在线',width:40,align:'left'}
			
		]],
		rowStyler:function(index,row){
			if (row.ASStatus=="停诊"){
				return 'background-color:pink;color:blue;font-weight:bold;';
			}/**/
			if (row.ASStatus=="替诊"){
				return 'background-color:yellow;color:blue;font-weight:bold;';
			}
			if (row.ASStatus=="被替诊"){
				return 'background-color:yellow;color:blue;font-weight:bold;';
			}if(row.IrregularFlag=="A"){
				//不规则排班
				return 'background-color:purple;color:white;font-weight:bold;';
			}
		},
		toolbar :[
			{	
				text: '新增排班',
	            iconCls: 'icon-add-custom',
	            handler: function() {
					/*if ((GroupDesc.indexOf("门办")<0)&&(CTLOCID!=555)){
						$.messager.alert('错误', "非门办人员不允许手动加诊!  ");
						return false;
					}else{
						EditAppSchedule("");
					}*/
					EditAppSchedule("");
				}
			},'-',{	
				text: '单个排班替诊',
	            iconCls: 'icon-add-custom',
	            handler: function() {
		           	/*if ((GroupDesc.indexOf("门办")<0)&&(CTLOCID!=555)){
						$.messager.alert('错误', "非门办人员不允许手动替诊!  ");
						return false;
					}else{
						ReplaceAppSchedule();
					}*/
					ReplaceAppSchedule();
				}
			},'-',{	
				text: '停诊',
	            iconCls: 'icon-add-custom',
	            handler: function() {
		           	/*if ((GroupDesc.indexOf("门办")<0)&&(CTLOCID!=555)){
						$.messager.alert('错误', "非门办人员不允许手动停诊!  ");
						return false;
					}else{
						StopAppSchedule();
					}*/
					StopAppSchedule();
				}
			},'-',{
				text: '本周班次',
	            iconCls: 'icon-undo-custom',
	            handler: function() {
		            var StartDate=GetDateStr(0) ;
		            	StartDate=tkMakeServerCall("web.DHCApptScheduleNew","GetMonday",StartDate);   // 从周一开始计算
		            $("#StartDate").datebox("setValue",StartDate); 
					$('#ScheduleTab').tabs({
						onSelect:function (){
						}
					})
				 	var tabs = $("#ScheduleTab").tabs("tabs");
					var length = tabs.length;
					for(var i = 0; i < length; i++) {
					    var onetab = tabs[0];
					    var title = onetab.panel('options').tab.text();
					    $("#ScheduleTab").tabs("close", title);
					}
					InitScheduleTab(StartDate) ;
				}
			},'-',{
				text: '下周班次',
	            iconCls: 'icon-redo-custom',
	            handler: function() {
		            var StartDate=GetDateStr(7) ;
		            	StartDate=tkMakeServerCall("web.DHCApptScheduleNew","GetMonday",StartDate);	 // 从周一开始计算
		            $("#StartDate").datebox("setValue",StartDate); 
					$('#ScheduleTab').tabs({
						onSelect:function (){
						}
					})
				 	var tabs = $("#ScheduleTab").tabs("tabs");
					var length = tabs.length;
					for(var i = 0; i < length; i++) {
					    var onetab = tabs[0];
					    var title = onetab.panel('options').tab.text();
					    $("#ScheduleTab").tabs("close", title);
					}
					InitScheduleTab(StartDate) ;
				}
			},'-',{	
				text: '撤消停诊',
	            iconCls: 'icon-add-custom',
	            handler: function() {
		           	/*if ((GroupDesc.indexOf("门办")<0)&&(CTLOCID!=555)){
						$.messager.alert('错误', "非门办人员不允许手动撤消停诊!  ");
						return false;
					}else{
						CancelStopAppSchedule();
					}*/
					CancelStopAppSchedule();
				}
			},'-',{	
				text: '非现场预约号修改',
	            iconCls: 'icon-edit',
	            handler: function() {
		           	 var tab = $('#ScheduleTab').tabs('getSelected');
					 var index = $('#ScheduleTab').tabs('getTabIndex',tab);
					 var GridId="ScheduleGrid"+index
					 var rows=$("#"+GridId).datagrid("getSelections")
					 var idStr="",ASAppLoad="",AppStartSeqNo=""
					 for(var i=0;i<rows.length;i++){
						if(idStr==""){
							idStr=rows[i].ASRowId
						}else{
							idStr=idStr+"^"+rows[i].ASRowId
						}
						var ASAppLoad=rows[i].ASAppLoad
					    var AppStartSeqNo=rows[i].AppStartSeqNo
					 }
					 if(idStr==""){
						alert("请选择要修改的排班记录")
						return false;
					 }
					 if(idStr.split("^").length>1){
						 alert("请选择单个排班进行修改!")
						 return false;
					 }
					 //$("#EditWin").panel({title:"新增排班模板"+"<font color='red'>("+dow+")</font>"});
					 $("#EditApptNumWin").panel({title:"<img src='/dthealth/web/images/uiimages/createschedulelist.png' style='vertical-align:middle;'>&nbsp;&nbsp;修改非现场预约限额"+"&nbsp;&nbsp;预约限额:"+"<font color='red'>"+ASAppLoad+"</font>"+"&nbsp;&nbsp;预约起始号:"+"<font color='red'>"+AppStartSeqNo+"</font>"});
					 InittabRBASApptNum(idStr,ASAppLoad,AppStartSeqNo);
					 $("#EditApptNumWin").window("open")
				}
			}
		],
		onSelect:function(rowid,RowData){
			
		},
		onDblClickRow:function(rowIndex,rowData){
			EditAppSchedule(rowData.ASRowId);
			//var TarItemCatId=rowData.TarItemCatId
			//window.returnValue=TarItemCatId
			//window.close()
		}
	}); 
 }
 function ApptUpDateLogShow(ASRowId){
	var url ="websys.default.csp?WEBSYS.TCOMPONENT=DHCApptSchedule.UpdateLog&vRBASID="+ASRowId;
	window.open(url,"_blank","height=600,width=800,left=50,top=50,status=yes,toolbar=no,scrollbars=yes,menubar=no")
 }
 function AppedDataShow(ASRowId){
	//var url ="websys.default.csp?WEBSYS.TCOMPONENT=DHCOPAdm.Appointment&vRBASID="+ASRowId;
	var url ="opadm.appcancel.hui.csp?vRBASID="+ASRowId;
	window.open(url,"_blank","height=600,width=1300,left=50,top=50,status=yes,toolbar=no,scrollbars=yes,menubar=no")
 }
 function InittabRBASApptNum(RBASRowId,ASAppLoad,AppStartSeqNo)
 {
	 var RBASApptToolBar = [{
            text: '保存',
            iconCls: 'icon-save',
            handler: function() {
			  var rows = RBASApptDataGrid.datagrid("getRows"); 
			  var AppQtySum=0,paraString="";
			  for(var i=0;i<rows.length;i++){
				  var ASQRowId=rows[i].ASQRowId;
				  var ApptMethodDr=rows[i].ApptMethodDr;
				  var editors = RBASApptDataGrid.datagrid('getEditors', i); 
				  var AppQty =  editors[0].target.val();
				  AppQtySum=AppQtySum+(+AppQty);
				  var AppStartNum =  editors[1].target.val();
				  if(((+AppStartNum)<(+AppStartSeqNo))&&(AppStartNum!=0)){
					  $.messager.alert('错误', "各个预约机构预约的预约起始号不能小于预约排班的预约起始号:"+AppStartSeqNo);
				      return false;
				  }
				  if(paraString=="") paraString=ASQRowId+"^"+ApptMethodDr+"^"+AppQty+"^"+AppStartNum;
				  else paraString=paraString+","+ASQRowId+"^"+ApptMethodDr+"^"+AppQty+"^"+AppStartNum;
			  }
			  if(AppQtySum>(+ASAppLoad)){
				  $.messager.alert('错误', "各个预约机构预约限额总和不能大于预约限额:"+ASAppLoad);
				  return false;
			  }
			  var retcode = tkMakeServerCall("web.DHCRBApptScheduleAppQty","SaveScheduleAppQty",paraString);
			  if(retcode!=0){
				  $.messager.alert('错误', "保存失败"+retcode);
				  return false;
			  }
			  $('#EditApptNumWin').window('close', true); 
            }
        }];
        //ASQRowId:%String,ApptMethodDr:%String,AppMethodName:%String,AppQty:%String,AppStartNum:%String
	RBASApptColumns=[[    
                    { field: 'ASQRowId', title: 'ASQRowId', width: 1, align: 'center', sortable: true,hidden:true
					},
					{ field: 'ApptMethodDr', title: 'ApptMethodDr', width: 1, align: 'center', sortable: true,hidden:true
					},
        			{ field: 'AppMethodName', title: '预约方式', width: 150, align: 'center', sortable: true
					},
					{ field: 'AppQty', title: '预约限额',  align: 'center', sortable: true,
					   editor : {
                                type : 'text'
                       }
					},
					{ field: 'AppStartNum', title: '预约起始号',  align: 'center', sortable: true,
					   editor : {
                                type : 'text'
                       }
					}
    			 ]];
	RBASApptDataGrid=$('#tabRBASApptNum').datagrid({  
		fit : true,
		width : 'auto', //
		border : false,
		striped : true,
		singleSelect : true,
		fitColumns : false, //为true时 不显示横向滚动条
		autoRowHeight : false,
		url : PUBLIC_CONSTANT.URL.QUERY_GRID_URL,
		loadMsg : '加载中..',  
		pagination : true,  //是否分页
		rownumbers : true,  //
		idField:"ApptMethodDr",
		pageList : [15,50,100,200],
		columns :RBASApptColumns,
		toolbar :RBASApptToolBar,
		onBeforeLoad:function(param){
			if(RBASRowId=="") return false;
	        param.ClassName ='web.DHCRBApptScheduleAppQty';
	        param.QueryName ='FindAppQty';
	        param.Arg1 =RBASRowId;
	        param.ArgCnt =1;
	    },
	    onLoadSuccess:function(data){
		    for(var index=0;index<data.total;index++){
			    RBASApptDataGrid.datagrid('beginEdit',index);
			}
		}
	});
 }
 function GetDateStr(AddDayCount) { 
	var dd = new Date(); 
	dd.setDate(dd.getDate()+AddDayCount);//获取AddDayCount天后的日期 
	var y = dd.getFullYear(); 
	var m = dd.getMonth()+1;//获取当前月份的日期 
	if (Number(m)<10) m="0"+m
	var d = dd.getDate(); 
	if (Number(d)<10) d="0"+d
	if (DateFormat==3){
		return y+"-"+m+"-"+d; 
	}
	if (DateFormat==4){
		return d+"/"+m+"/"+y; 
	}
	
} 
 function ScheduleGridLoad(GridId,StartDate,LocRowid,DocRowid,ExaRowid)
 {
	 $("#"+GridId).datagrid("unselectAll");
	//alert(LocRowid+","+DocRowid+","+StartDate+","+userid+","+","+groupid+","+ExaRowid)
	var queryParams = new Object();
	queryParams.ClassName ='web.DHCApptScheduleNew';
	queryParams.QueryName ='GetApptSchedule';
	queryParams.Arg1 =LocRowid;
	queryParams.Arg2 =DocRowid;
	queryParams.Arg3 =StartDate;
	queryParams.Arg4 =StartDate;
	queryParams.Arg5 =userid;
	queryParams.Arg6 =groupid;
	queryParams.Arg7 ="";	// 资源ID
	queryParams.Arg8 =ExaRowid;
	queryParams.ArgCnt = 8;
	var opts = $("#"+GridId).datagrid("options");
	opts.url = "./dhcdoc.cure.query.grid.easyui.csp"
	$("#"+GridId).datagrid('load', queryParams); 
 }
 
 function InitLocDocTree(){
	var url = "dhcrbapptschedulequeryrequest.csp?pid=0&userid="+userid+"&groupid="+groupid ;
	$("#LocDocTree").tree({
		url:url,
		multiple:true,
		lines:true,
		onCheck:function(node,checked){
			//AddDataToSelLocDoc(node,checked)
		},
		onBeforeExpand:function(node,param){
            //$("#LocDocTree").tree('options').url = "dhcrbapptschedulequeryrequest.csp?pid="+node.id+"&action=appt"+"&userid="+userid+"&groupid="+groupid+"&docdesc="+$.trim($("#SerchDoc").val());
			var url = $("#LocDocTree").tree('options').url = "dhcrbapptschedulequeryrequest.csp?pid="+node.id+"&action=appt"+"&userid="+userid+"&groupid="+groupid+"&docdesc="+$.trim($("#SerchDoc").val());
			$('#LocDocTree').tree('options').url =encodeURI(url);
		}, 
		onLoadSuccess:function(node,data){
		},
		onSelect:function(node){
			var id=node.id
			var idArr=id.split("^")
			if(idArr[0]=="Loc"){
				var LocRowid=idArr[1]
					var parentNode=$("#LocDocTree").tree("getParent",node.target) ;
					if (parentNode){
						var parentNodeid=parentNode.id ;
						var parentNodeidArr=parentNodeid.split("^")
						var ExaRowid=parentNodeidArr[1];
					}else{
						var ExaRowid=idArr[2];
					}
                    GetASRoomData(ExaRowid);
					FindScheduleByLoc(LocRowid,"",ExaRowid)
			}else if (idArr[0]=="Doc"){
				    var DocRowid=idArr[1];
					var parentNode=$("#LocDocTree").tree("getParent",node.target) ;
					var parentNodeid=parentNode.id ;
					var parentNodeidArr=parentNodeid.split("^")
					var LocRowid=parentNodeidArr[1];
				    FindScheduleByLoc(LocRowid,DocRowid,"");
				    var grandPaNode = $("#LocDocTree").tree("getParent",parentNode.target);
				    if (grandPaNode){
					    var grandPaNodeid=grandPaNode.id ;
						var grandPaNodeidArr=grandPaNodeid.split("^");
						ExaRowid=grandPaNodeidArr[1];
					}else{
						ExaRowid=parentNodeidArr[2];
					}
					
				    GetASRoomData(ExaRowid);
			}else{
				
				var ExaRowid=idArr[1] ;
				FindScheduleByLoc("","",ExaRowid)
				GetASRoomData(ExaRowid);
			}
		}
	}); 
 }
 function FindScheduleByLoc(LocRowId,DocrowId,ExaRowId)
 {
	var tab=$('#ScheduleTab').tabs("getSelected");
	
	var opts=tab.panel("options")
	var index = $('#ScheduleTab').tabs('getTabIndex',tab);
	//if (document.getElementById("ScheduleGrid"+index)) return
	var title=opts.title
	var StartDate=title.split("(")[0]
	ScheduleGridLoad("ScheduleGrid"+index,StartDate,LocRowId,DocrowId,ExaRowId)
	 
 }
 
 function ClearWinData()
 {
	$("#ASRowID").attr('value','');
	$("#AdmDate").datebox("setValue",TalStartDate);  
	$("#AdmLoc").combogrid("setValue", '');
	$("#LocArea").combogrid("setValue", '');
	$("#TimeRange").combogrid("setValue", '');
	$("#AdmDoc").combogrid("setValue", '');
	$("#DocSession").combogrid("setValue", '');
	$('#StartTime').attr('value','');
	$("#EndTime").attr('value','');
	$("#PositiveMax").attr('value','');
	$("#ApptMax").attr('value','');
	$("#AddtionMax").attr('value','');

	$("#TRSartTime").attr('value','');
	$("#TREndTime").attr('value','');
	$("#TRRegNum").attr('value','');
	$("#TRRegNumStr").attr('value','');
	$("#TRRegInfoStr").attr('value','');	
	$("#EStartPrefix").attr('value','');

	//$('#EChkRep').attr("checked",false);
	$('#EChkStop').attr("checked",false);
	//$("#EAdmLoc").combogrid("setValue", '');
	//$("#EAdmDoc").combogrid("setValue", '');
	//$("#EDocSession").combogrid("setValue", '');
	//$("#EAdmLoc").combogrid("disable",true);
	//$("#EAdmDoc").combogrid("disable",true);
	//$("#EDocSession").combogrid("disable",true);
	//$("#AutoLoad").attr('value','');
	//$("#ExtLoad").attr('value','');
	$("#TRFlag").attr('checked',false);
 }
 
 function EditAppSchedule(ASRowId)
 {
	var selLocRowId="",selLocDesc="";
	var selDocRowId="",selDocDesc="";
	var selExamRowId=""
	var selObj=$("#LocDocTree").tree("getSelected");
	if(selObj){
		var idStr=selObj.id;
		var idStrArr=idStr.split("^")
		if(idStrArr[0]=="Loc"){
			selLocRowId=idStrArr[1];
			selLocDesc=selObj.text;
		}else{
			if(idStrArr[0]=="Doc"){
				selDocRowId=idStrArr[1];
				selDocDesc=selObj.text;
				var parentObj=$("#LocDocTree").tree("getParent",selObj.target)
				var idStr=parentObj.id;
		        var idStrArr=idStr.split("^");
				selLocRowId=idStrArr[1];
			    selLocDesc=parentObj.text;
			}else{
				selExamRowId=idStrArr[1];
			}
		}
	}
	//var tab = $('#ScheduleTab').tabs('getSelected');
	//var index = $('#ScheduleTab').tabs('getTabIndex',tab);
	//var GridId="ScheduleGrid"+index
	//var rows=$("#ScheduleGrid0").datagrid("getSelections")
	//$("#EditWin").window({onBeforeClose}
	
	//$("#AdmDate").combogrid("setValue", '');
	ClearWinData() ;
    
	if (ASRowId!=""){
		InitWinInfo(ASRowId) ;
		var GroupDesc= session['LOGON.GROUPDESC'] ;
		var CTLOCID= session['LOGON.CTLOCID'] ;
		LimitCombo('disable');
		LimitText(true);
		$("#ApptMax").attr("readonly",false);
		/*
		if ((GroupDesc.indexOf("门办")<0)&&(CTLOCID!=555)){
			LimitCombo('disable')
			LimitText(true)
			$("#ApptMax").attr("readonly",false);
		}else{
			//$('#EChkRep').attr("disabled",false);
			$('#EChkStop').attr("disabled",false);
		}
		//$("#LocArea").combogrid("grid").datagrid("loadData", ASRoomData);
		*/
	}else{
		if ((selLocRowId=="")&&(selDocRowId=="")){
			LoadAdmLoc("",selExamRowId)
		}
		if (selLocRowId!=""){
			LoadClinicGroup(selLocRowId)
		}
		setTimeout(function(){
			LimitCombo('enable')
			LimitText(false)
			$("#AdmLoc").combogrid("setValue", selLocRowId);
			$("#AdmLoc").combogrid("setText", selLocDesc);
			//$("#LocArea").combogrid("grid").datagrid("loadData", ASRoomData);
	        LoadAdmDoc(selLocRowId)
			$("#AdmDoc").combogrid("setValue", selDocRowId);
			$("#AdmDoc").combogrid("setText", selDocDesc);
	        if(selDocRowId!=""){
		        var sessTypeDr = tkMakeServerCall("web.DhcResEffDateSessionClass","GetSessTypeByDocId",selDocRowId,selLocRowId);
				if(sessTypeDr != ""){
					$("#DocSession").combogrid('grid').datagrid("selectRecord",sessTypeDr.toString());
				}
				var encmeth=GetDocResource.value;
				if (encmeth!=''){
					var ret=cspRunServerMethod(encmeth,selLocRowId,selDocRowId);
					if (ret!=""){
						//var Arr=ret.split("^");	
						var Arr1=ret.split("$")[0];
						var Arr2=ret.split("$")[1];
						var Arr3=ret.split("$")[2];
						var Arr=Arr1.split("^");	
						$("#PositiveMax").attr('value',Arr[2]);
						$("#ApptMax").attr('value',Arr[3]);
						if(Arr.length>=18){
						    $("#ClinicGroup").combogrid('grid').datagrid("selectRecord",Arr[18]);
						}else{
							$("#ClinicGroup").combobox("setValue", "");
							$("#ClinicGroup").combobox("setText", "");
						}
						$("#EStartPrefix").attr('value',Arr[4]);
						$("#AddtionMax").attr('value',Arr[5]);

				
						//$("#PositiveMax").attr('value',Arr[2]);
						//$("#ApptMax").attr('value',Arr[3]);
						/*if(Arr[2]-3>0){
							$("#TRRegNum").attr('value',Arr[2]-3);
						}else{
							$("#TRRegNum").attr('value',"");
						}*/
						//$("#EStartPrefix").attr('value',Arr[4]);
						//$("#AddtionMax").attr('value',Arr[5]);
						if(Arr3!=""){
							var TRInfoArr=Arr3.split("^");
							var TRFlag=TRInfoArr[0];
							var TRStTime=TRInfoArr[1];
							var TREnTime=TRInfoArr[2];
							var TRLenghth=TRInfoArr[3];
							var TRSDHS=TRInfoArr[4];
							var TRRegNumStr=TRInfoArr[5];
							var TRRegInfoStr=TRInfoArr[6];
							if(TRFlag=="Y"){
								$("#TRFlag").attr('checked',true);	
								$("#TRLength").attr('value',TRLenghth);
								$("#TRRegNum").attr('value',TRSDHS);
								$("#TRSartTime").attr('value',TRStTime);
								$("#TREndTime").attr('value',TREnTime);
								$("#TRRegNumStr").attr('value',TRRegNumStr);
								$("#TRRegInfoStr").attr('value',TRRegInfoStr);
							}else{
								$("#TRFlag").attr('checked',false);	
								$("#TRLength").attr('value',"");
								$("#TRRegNum").attr('value',"");
								$("#TRSartTime").attr('value',"");
								$("#TREndTime").attr('value',"");
								$("#TRRegNumStr").attr('value',"");
								$("#TRRegInfoStr").attr('value',"");	
							}
						}else{
							$("#TRFlag").attr('checked',false);	
							$("#TRLength").attr('value',"");
							$("#TRRegNum").attr('value',"");
							$("#TRSartTime").attr('value',"");
							$("#TREndTime").attr('value',"");
							$("#TRRegNumStr").attr('value',"");
							$("#TRRegInfoStr").attr('value',"");	
						}
						
					}
				}
		    }
		},500)	
		
	}
	//$("#AutoLoad").numeral(); 
	//$("#ExtLoad").numeral(); 
	$("#EditWin").window("open")
 }
 function ReplaceAppSchedule(){
	 $("#ReplaceASRowIDStr").val("");
	 var tab = $('#ScheduleTab').tabs('getSelected');
	 var index = $('#ScheduleTab').tabs('getTabIndex',tab);
	 var GridId="ScheduleGrid"+index
	 var rows=$("#"+GridId).datagrid("getSelections")
	 var idStr=""
	 for(var i=0;i<rows.length;i++){
		if(idStr==""){
			idStr=rows[i].ASRowId
		}else{
			idStr=idStr+"^"+rows[i].ASRowId
		}
	 }
	 if(idStr==""){
		alert("请选择要替诊的排班记录")
		return false;
	 }
	 if(idStr.split("^").length>1){
		 alert("请选择单个排班进行替诊操作!")
		 return false;
	 }
	 var Status=rows[0].ASStatus;
	 if (Status=="停诊"){
		 alert("已经停诊的记录不能替诊")
		 return false;
	 }else if (Status=="被替诊"){
		 alert("已经替诊的记录不能替诊")
		 return false;
	 }
	 var selLocDesc=rows[0].LocDesc;
	 $("#ReplaceASRowIDStr").val(idStr);
	 ClearReplaceData();
	 //InitReplaceWin();
	 
	 //初始化页面数据
	 var RBResInfo=tkMakeServerCall("web.DHCApptScheduleNew","GetApptScheduleInfo",idStr)
	 $("#ERepLoc").combogrid("setValue", RBResInfo.split("^")[2]);
	 $("#ERepLoc").combogrid("setText", selLocDesc);
	 LoadERepDoc("");
	 LoadERepSessionType();
	 $("#ERepLeader").combogrid("setValue", session['LOGON.USERID']);
	 $("#ERepLeader").combogrid("setText", session['LOGON.USERNAME']);
	 $('#ReplaceSave').unbind('click'); 
	 $("#ReplaceSave").on("click", ReplaceSave)
	 $("#ReplaceCancel").on("click", ReplaceCancel)
	 $("#ReplaceWin").window("open")
 }
 function ReplaceCancel(){
	 $('#ReplaceWin').window('close', true); 
 }
 function StopAppSchedule(ASRowId)
 {
	$("#StopASRowIDStr").val("");
	var tab = $('#ScheduleTab').tabs('getSelected');
	var index = $('#ScheduleTab').tabs('getTabIndex',tab);
	var GridId="ScheduleGrid"+index
	var rows=$("#"+GridId).datagrid("getSelections")
	var idStr=""
	for(var i=0;i<rows.length;i++){
		var status=rows[i].ASStatus
		if((status=="停诊")||(status=="被替诊")) {
			//continue
			alert("已停诊或被替诊的排班记录不能停诊,请重新选择！")
			return false;
		}
		var AppedCount=tkMakeServerCall("web.DHCRBApptSchedule","GetAppedSeqNoCount",rows[i].ASRowId);
	    if(AppedCount>=1){
		    if (!(confirm(rows[i].LocDesc+" "+rows[i].DocDesc+" "+rows[i].TimeRange+"的排班信息已存在预约记录,是否确认停诊?"))) return false;
		}
		if(idStr==""){
			idStr=rows[i].ASRowId
		}else{
			idStr=idStr+"^"+rows[i].ASRowId
		}
	}
	if(idStr==""){
		alert("请选择要停诊的排班记录")
		return 
	}
	$("#StopASRowIDStr").val(idStr)
	//InitStopWin();
	$("#EReason").combogrid("setValue", '');
	$("#EPassword").val('');
	//$("#ELeader").combogrid("setValue", '');
	$("#ELeader").combogrid("setValue", session['LOGON.USERID']);
	$("#ELeader").combogrid("setText", session['LOGON.USERNAME']);
	/*if (ASRowId!=""){
		InitWinInfo(ASRowId) ;
		var GroupDesc= session['LOGON.GROUPDESC'] ;
		var CTLOCID= session['LOGON.CTLOCID'] ;
		if ((GroupDesc.indexOf("门办")<0)&&(CTLOCID!=555)){
			LimitCombo('disable')
			LimitText(true)
		}else{
			$('#EChkRep').attr("disabled",false);
			$('#EChkStop').attr("disabled",false);
		}
	}else{
		$.messager.alert('错误', "请选择要停诊的排班");

	}*/
	$("#StopWin").window("open")
 }
 function CancelStopAppSchedule(ASRowId)
 {
	$("#StopASRowIDStr").val("");
	var tab = $('#ScheduleTab').tabs('getSelected');
	var index = $('#ScheduleTab').tabs('getTabIndex',tab);
	var GridId="ScheduleGrid"+index
	var rows=$("#"+GridId).datagrid("getSelections")
	var idStr=""
	var rtn=""
	for(var i=0;i<rows.length;i++){
		var status=rows[i].ASStatus
		if(status!="停诊") continue
		if(idStr==""){
			idStr=rows[i].ASRowId
		}else{
			idStr=idStr+"^"+rows[i].ASRowId
		}
		
		var IsAudit="0";
		var RequestRet=tkMakeServerCall("web.DHCRBApptScheduleAudi","GetRBASRequestFlag","SC",rows[i].ASRowId,session['LOGON.GROUPID']);
		var RequestRetArr=RequestRet.split("^");
		var RequestFlag=RequestRetArr[0];
		if (RequestFlag==1) RequestLocDesc=RequestRetArr[1]+","+RequestLocDesc
		if(RequestFlag=="0")IsAudit="1";
		var rtn=tkMakeServerCall("web.DHCRBApptSchedule","CancelStopOneSchedule",rows[i].ASRowId,IsAudit)
		if(rtn!=0){
			var rtnArr=rtn.split("^")
			if(rtnArr[0]=='-201'){
				alert("不能撤销停诊,"+rtnArr[1]+"存在相同时段的排班!")
				break;
			}else{
				alert("撤销停诊失败!"+rtnArr[0])
				break;
			}
		}
	}
	
	if(idStr==""){
		alert("请选择要撤消停诊的排班记录")
		return 
	}else{
		if(rtn==0){
			//撤销停诊、停诊是批量，提示如何处理？
			var msg="撤消停诊成功!";
			if(NotRequestLocDesc!=""){msg=NotRequestLocDesc+"撤消停诊成功!"};
			if(RequestLocDesc!=""){
				if(msg!=""){msg=msg+";"+RequestLocDesc+"撤消停诊申请成功!请等待相关人员审核后生效."}
				else{msg=RequestLocDesc+"撤消停诊申请成功!请等待相关人员审核后生效."}	
			}
			
			alert(msg)
			//$.messager.alert('提示',msg)
			ReLoadScheduleGrid();
		}
	}
 }
 
 
 function LoadERepSessionType(){
	 var CurrDate=tkMakeServerCall("web.DHCBatchStopNew","GetCurrDate");
	 var queryParams = new Object();
	queryParams.ClassName = "web.DHCApptScheduleNew";
	queryParams.QueryName = "LookUpSessionType";
	queryParams.Arg1 = CurrDate.split("^")[0];
	queryParams.ArgCnt = 1;
	InitComboData('#ERepSessionType',queryParams)
 }
 function StopCancel(){
	 $('#StopWin').window('close', true); 
 }
 function InitReplaceWin(){
	 $("#ERepDoc").combogrid({
		panelWidth:150,
		panelHeight:200,
		delay: 0,    
		mode: 'remote',    
		url: PUBLIC_CONSTANT.URL.QUERY_GRID_URL,
		fitColumns: true,   
		striped: true,   
		editable:true,   
		collapsible:false,//是否可折叠的   
		fit: true,//自动大小   
		method:'post', 
		idField: 'RowId',    
		textField: 'Desc', 
		//disabled:true,
		columns: [[    
			{field:'Desc',title:'替诊医生',width:150,sortable:true},
			{field:'RowId',title:'RowId',width:20,hidden:true}
		]],
		onSelect: function (rowIndex, rowData){
			var sessTypeDr = tkMakeServerCall("web.DhcResEffDateSessionClass","GetSessTypeByDocId",rowData.RowId,$("#ERepLoc").combogrid("getValue"));
			if(sessTypeDr != ""){
				$("#ERepSessionType").combogrid('grid').datagrid("selectRecord",sessTypeDr.toString());
			}
			var selected = $('#ERepDoc').combogrid('grid').datagrid('getSelected');  
			if (selected) { 
			  $('#ERepDoc').combogrid("options").value=selected.RowId;
			}
		},
		keyHandler:{
			up: function () {
                //取得选中行
                var selected = $('#ERepDoc').combogrid('grid').datagrid('getSelected');
                if (selected) {
                    //取得选中行的rowIndex
                    var index = $('#ERepDoc').combogrid('grid').datagrid('getRowIndex', selected);
                    //向上移动到第一行为止
                    if (index > 0) {
                        $('#ERepDoc').combogrid('grid').datagrid('selectRow', index - 1);
                    }
                } else {
                    var rows = $('#ERepDoc').combogrid('grid').datagrid('getRows');
                    $('#ERepDoc').combogrid('grid').datagrid('selectRow', rows.length - 1);
                }
             },
             down: function () {
              //取得选中行
                var selected = $('#ERepDoc').combogrid('grid').datagrid('getSelected');
                if (selected) {
                    //取得选中行的rowIndex
                    var index = $('#ERepDoc').combogrid('grid').datagrid('getRowIndex', selected);
                    //向下移动到当页最后一行为止
                    if (index < $('#ERepDoc').combogrid('grid').datagrid('getData').rows.length - 1) {
                        $('#ERepDoc').combogrid('grid').datagrid('selectRow', index + 1);
                    }
                } else {
                    $('#ERepDoc').combogrid('grid').datagrid('selectRow', 0);
                }
				
            },
			left: function () {
				return false;
            },
			right: function () {
				return false;
            },            
			enter: function () { 
			    //文本框的内容为选中行的的字段内容
                var selected = $('#ERepDoc').combogrid('grid').datagrid('getSelected');  
			    if (selected) { 
			      	$('#ERepDoc').combogrid("options").value=selected.RowId;
			    }
                //选中后让下拉表格消失
                $('#ERepDoc').combogrid('hidePanel');
            },
			query:function(q){
				if (this.AutoSearchTimeOut) {
					window.clearTimeout(this.AutoSearchTimeOut)
					this.AutoSearchTimeOut=window.setTimeout("LoadERepDoc('"+q+"')",400)
				}else{
					this.AutoSearchTimeOut=window.setTimeout("LoadERepDoc('"+q+"')",400)
				}

				$('#ERepDoc').combogrid("setValue",q);
            }
		}
	});
	
	$('#ERepLoc').combogrid({
		panelWidth:400,
		panelHeight:380,
		delay: 0,
		mode: 'remote',    
		url: PUBLIC_CONSTANT.URL.QUERY_GRID_URL,
		fitColumns: true,   
		striped: true,   
		editable:true,   
		pagination : true,//是否分页   
		rownumbers:true,//序号   
		collapsible:false,//是否可折叠的   
		fit: true,//自动大小   
		pageSize: 10,//每页显示的记录条数，默认为10   
		pageList: [10],//可以设置每页记录条数的列表   
		method:'post', 
		idField: 'RowId',    
		textField: 'LocDesc', 
		//disabled:true,
		columns: [[    
			{field:'LocDesc',title:'科室名称',width:400,sortable:true},
			{field:'RowId',title:'RowId',width:120,sortable:true}
		]],
		keyHandler:{
			up: function () {
                //取得选中行
                var selected = $('#ERepLoc').combogrid('grid').datagrid('getSelected');
                if (selected) {
                    //取得选中行的rowIndex
                    var index = $('#ERepLoc').combogrid('grid').datagrid('getRowIndex', selected);
                    //向上移动到第一行为止
                    if (index > 0) {
                        $('#ERepLoc').combogrid('grid').datagrid('selectRow', index - 1);
                    }
                } else {
                    var rows = $('#ERepLoc').combogrid('grid').datagrid('getRows');
                    $('#ERepLoc').combogrid('grid').datagrid('selectRow', rows.length - 1);
                }
             },
             down: function () {
              //取得选中行
                var selected = $('#ERepLoc').combogrid('grid').datagrid('getSelected');
                if (selected) {
                    //取得选中行的rowIndex
                    var index = $('#ERepLoc').combogrid('grid').datagrid('getRowIndex', selected);
                    //向下移动到当页最后一行为止
                    if (index < $('#ERepLoc').combogrid('grid').datagrid('getData').rows.length - 1) {
                        $('#ERepLoc').combogrid('grid').datagrid('selectRow', index + 1);
                    }
                } else {
                    $('#ERepLoc').combogrid('grid').datagrid('selectRow', 0);
                }
				
            },
			left: function () {
				return false;
            },
			right: function () {
				return false;
            },            
			enter: function () { 
			    //文本框的内容为选中行的的字段内容
                var selected = $('#ERepLoc').combogrid('grid').datagrid('getSelected');  
			    if (selected) { 
			      	$('#ERepLoc').combogrid("options").value=selected.RowId;
			      	LoadERepDoc("") ;
					$('#ERepDoc').combogrid("setValue","");
					$('#ERepDoc').combogrid("setText","");
			    }
                //选中后让下拉表格消失
                $('#ERepLoc').combogrid('hidePanel');
				//$("#AdmLoc").focus();
            },
			query:function(q){
				if (this.AutoSearchTimeOut) {
					window.clearTimeout(this.AutoSearchTimeOut)
					this.AutoSearchTimeOut=window.setTimeout("LoadERepLoc('"+q+"')",400) //#ERepLoc
				}else{
					this.AutoSearchTimeOut=window.setTimeout("LoadERepLoc('"+q+"')",400)
				}

				$('#ERepLoc').combogrid("setValue",q);
				//LoadDiagnosData(q);
				
            }
		},
		onClickRow: function (index, row){
			var selected = $('#ERepLoc').combogrid('grid').datagrid('getSelected');  
			if (selected) { 
				  $('#ERepLoc').combogrid("options").value=selected.RowId;
				  LoadERepDoc("");
				  $('#ERepDoc').combogrid("setValue","");
				  $('#ERepDoc').combogrid("setText","");
			}
		},
		onLoadSuccess:function(data){
			var CurrentOrdName=$(this).combogrid('getValue');
			if(CurrentOrdName!=""){
				var CheckValue=/^\d+$/;
				if (CheckValue.test(CurrentOrdName)){
					$(this).combogrid("setValue","");
					$(this).combo("setText", "")
				}
			}
			$(this).next('span').find('input').focus();
		},
		onChange:function(newValue,oldValue){
			if (newValue==""){
				$('#ERepDoc').combogrid('grid').datagrid('loadData',{ total: 0, rows: [] }) //.datagrid('loadData', { total: 0, rows: [] });  
				$('#ERepDoc').combogrid('setValue',"");
				$('#ERepDoc').combogrid('setText',"");
			}
		}
	});
	
	$("#ERepSessionType").combogrid({
		panelWidth:150,
		panelHeight:200,
		delay: 0,    
		mode: 'remote',    
		url: PUBLIC_CONSTANT.URL.QUERY_GRID_URL,
		fitColumns: true,   
		striped: true,   
		editable:false,   
		collapsible:false,//是否可折叠的   
		fit: true,//自动大小   
		method:'post', 
		//disabled:true,
		idField: 'RowId',    
		textField: 'Desc', 
		columns: [[    
			{field:'Desc',title:'替诊职称',width:150,sortable:true},
			{field:'RowId',title:'RowId',width:20,hidden:true}
		]]	   
	});
	
	
	
	$("#ERepReason").combogrid({
		panelWidth:150,
		panelHeight:200,
		delay: 0,    
		mode: 'remote',    
		url: PUBLIC_CONSTANT.URL.QUERY_GRID_URL,
		fitColumns: true,   
		striped: true,   
		editable:true,   
		collapsible:false,//是否可折叠的   
		fit: true,//自动大小   
		method:'post', 
		disabled:false,
		idField: 'RowId',    
		textField: 'Desc', 
		columns: [[    
			{field:'Desc',title:'批准原因',width:150,sortable:true},
			{field:'RowId',title:'RowId',width:20,hidden:true}
		]],
		keyHandler:{
			up: function () {
                //取得选中行
                var selected = $('#ERepReason').combogrid('grid').datagrid('getSelected');
                if (selected) {
                    //取得选中行的rowIndex
                    var index = $('#ERepReason').combogrid('grid').datagrid('getRowIndex', selected);
                    //向上移动到第一行为止
                    if (index > 0) {
                        $('#ERepReason').combogrid('grid').datagrid('selectRow', index - 1);
                    }
                } else {
                    var rows = $('#ERepReason').combogrid('grid').datagrid('getRows');
                    $('#ERepReason').combogrid('grid').datagrid('selectRow', rows.length - 1);
                }
             },
             down: function () {
              //取得选中行
                var selected = $('#ERepReason').combogrid('grid').datagrid('getSelected');
                if (selected) {
                    //取得选中行的rowIndex
                    var index = $('#ERepReason').combogrid('grid').datagrid('getRowIndex', selected);
                    //向下移动到当页最后一行为止
                    if (index < $('#ERepReason').combogrid('grid').datagrid('getData').rows.length - 1) {
                        $('#ERepReason').combogrid('grid').datagrid('selectRow', index + 1);
                    }
                } else {
                    $('#ERepReason').combogrid('grid').datagrid('selectRow', 0);
                }
				
            },
			left: function () {
				return false;
            },
			right: function () {
				return false;
            },            
			enter: function () { 
			    //文本框的内容为选中行的的字段内容
                var selected = $('#ERepReason').combogrid('grid').datagrid('getSelected');  
			    if (selected) { 
			      	$('#ERepReason').combogrid("options").value=selected.RowId;
			    }
                //选中后让下拉表格消失
                $('#ERepReason').combogrid('hidePanel');
				//$("#AdmLoc").focus();
            },
			query:function(q){
				if (this.AutoSearchTimeOut) {
					window.clearTimeout(this.AutoSearchTimeOut)
					this.AutoSearchTimeOut=window.setTimeout("LoadReason('ERepReason','"+q+"')",400)
				}else{
					this.AutoSearchTimeOut=window.setTimeout("LoadReason('ERepReason','"+q+"')",400)
				}

				$('#ERepReason').combogrid("setValue",q);
            }
		},
		onShowPanel:function(){
			LoadReason("ERepReason","")
		}
	});
	
	$("#ERepLeader").combogrid({
		panelWidth:150,
		panelHeight:200,
		delay: 0,    
		mode: 'remote',    
		url: PUBLIC_CONSTANT.URL.QUERY_GRID_URL,
		fitColumns: true,   
		striped: true,   
		editable:true,   
		collapsible:false,//是否可折叠的   
		fit: true,//自动大小   
		method:'post', 
		disabled:false,
		idField: 'RowId',    
		textField: 'Desc', 
		columns: [[    
			{field:'Desc',title:'批准人',width:150,sortable:true},
			{field:'RowId',title:'RowId',width:20,hidden:true}
		]],
		keyHandler:{
			up: function () {
                //取得选中行
                var selected = $('#ERepLeader').combogrid('grid').datagrid('getSelected');
                if (selected) {
                    //取得选中行的rowIndex
                    var index = $('#ERepLeader').combogrid('grid').datagrid('getRowIndex', selected);
                    //向上移动到第一行为止
                    if (index > 0) {
                        $('#ERepLeader').combogrid('grid').datagrid('selectRow', index - 1);
                    }
                } else {
                    var rows = $('#ERepLeader').combogrid('grid').datagrid('getRows');
                    $('#ERepLeader').combogrid('grid').datagrid('selectRow', rows.length - 1);
                }
             },
             down: function () {
              //取得选中行
                var selected = $('#ERepLeader').combogrid('grid').datagrid('getSelected');
                if (selected) {
                    //取得选中行的rowIndex
                    var index = $('#ERepLeader').combogrid('grid').datagrid('getRowIndex', selected);
                    //向下移动到当页最后一行为止
                    if (index < $('#ERepLeader').combogrid('grid').datagrid('getData').rows.length - 1) {
                        $('#ERepLeader').combogrid('grid').datagrid('selectRow', index + 1);
                    }
                } else {
                    $('#ERepLeader').combogrid('grid').datagrid('selectRow', 0);
                }
				
            },
			left: function () {
				return false;
            },
			right: function () {
				return false;
            },            
			enter: function () { 
			    //文本框的内容为选中行的的字段内容
                var selected = $('#ERepLeader').combogrid('grid').datagrid('getSelected');  
			    if (selected) { 
			      	$('#ERepLeader').combogrid("options").value=selected.RowId;
			    }
                //选中后让下拉表格消失
                $('#ERepLeader').combogrid('hidePanel');
				//$("#AdmLoc").focus();
            },
			query:function(q){
				if (this.AutoSearchTimeOut) {
					window.clearTimeout(this.AutoSearchTimeOut)
					this.AutoSearchTimeOut=window.setTimeout("LoadELeader('ERepLeader','"+q+"')",400)
				}else{
					this.AutoSearchTimeOut=window.setTimeout("LoadELeader('ERepLeader','"+q+"')",400)
				}

				$('#ERepLeader').combogrid("setValue",q);
				
            }
		},
		onChange:function (newValue, oldValue) { 
		    //alert(newValue+","+oldValue)
		    //如果审批人非当前登陆用户,则显示密码
		    if (newValue!=session['LOGON.USERID']){
			    $("#td-ERepPassword").removeAttr("style");
			}else{
				$("#td-ERepPassword").attr("style","display:none;");
			}
	    }	   
	});
	/*var queryParams = new Object();
	queryParams.ClassName = "web.DHCApptScheduleNew";
	//queryParams.QueryName = "LookUpELeader";;
	queryParams.QueryName = "LookUpELeaderNew";
	//queryParams.Arg1 = CurrDate.split("^")[0];
	queryParams.Arg1 = session['LOGON.CTLOCID'];
	queryParams.ArgCnt = 1;
	InitComboData('#ERepLeader',queryParams);*/
	LoadELeader("ERepLeader","");
		
	
	/*var queryParams = new Object();
		queryParams.ClassName = "web.DHCApptScheduleNew";
		queryParams.QueryName = "LookUpReasonNotAvail";;
		queryParams.Arg1 = CurrDate.split("^")[0];
		queryParams.ArgCnt = 1;
		InitComboData('#ERepReason',queryParams);*/
	LoadERepSessionType();
	
 }
 function LoadReason(obj,q){
	 var queryParams = new Object();
		queryParams.ClassName = "web.DHCApptScheduleNew";
		queryParams.QueryName = "LookUpReasonNotAvail";;
		queryParams.Arg1 = CurrDate.split("^")[0];
		queryParams.ArgCnt = 1;
		InitComboData('#'+obj+'',queryParams);
}
 function InitStopWin(){
	$("#EReason").combogrid({
		panelWidth:150,
		panelHeight:200,
		delay: 0,    
		mode: 'remote',    
		url: PUBLIC_CONSTANT.URL.QUERY_GRID_URL,
		fitColumns: true,   
		striped: true,   
		editable:true,   
		collapsible:false,//是否可折叠的   
		fit: true,//自动大小   
		method:'post', 
		disabled:false,
		idField: 'RowId',    
		textField: 'Desc', 
		columns: [[    
			{field:'Desc',title:'批准原因',width:150,sortable:true},
			{field:'RowId',title:'RowId',width:20,hidden:true}
		]],
		keyHandler:{
			up: function () {
                //取得选中行
                var selected = $('#EReason').combogrid('grid').datagrid('getSelected');
                if (selected) {
                    //取得选中行的rowIndex
                    var index = $('#EReason').combogrid('grid').datagrid('getRowIndex', selected);
                    //向上移动到第一行为止
                    if (index > 0) {
                        $('#EReason').combogrid('grid').datagrid('selectRow', index - 1);
                    }
                } else {
                    var rows = $('#EReason').combogrid('grid').datagrid('getRows');
                    $('#EReason').combogrid('grid').datagrid('selectRow', rows.length - 1);
                }
             },
             down: function () {
              //取得选中行
                var selected = $('#EReason').combogrid('grid').datagrid('getSelected');
                if (selected) {
                    //取得选中行的rowIndex
                    var index = $('#EReason').combogrid('grid').datagrid('getRowIndex', selected);
                    //向下移动到当页最后一行为止
                    if (index < $('#EReason').combogrid('grid').datagrid('getData').rows.length - 1) {
                        $('#EReason').combogrid('grid').datagrid('selectRow', index + 1);
                    }
                } else {
                    $('#EReason').combogrid('grid').datagrid('selectRow', 0);
                }
				
            },
			left: function () {
				return false;
            },
			right: function () {
				return false;
            },            
			enter: function () { 
			    //文本框的内容为选中行的的字段内容
                var selected = $('#EReason').combogrid('grid').datagrid('getSelected');  
			    if (selected) { 
			      	$('#EReason').combogrid("options").value=selected.RowId;
			    }
                //选中后让下拉表格消失
                $('#EReason').combogrid('hidePanel');
				//$("#AdmLoc").focus();
            },
			query:function(q){
				if (this.AutoSearchTimeOut) {
					window.clearTimeout(this.AutoSearchTimeOut)
					this.AutoSearchTimeOut=window.setTimeout("LoadReason('EReason','"+q+"')",400)
				}else{
					this.AutoSearchTimeOut=window.setTimeout("LoadReason('EReason','"+q+"')",400)
				}

				$('#EReason').combogrid("setValue",q);
				
            }
		},
		onShowPanel:function(){
			LoadReason("EReason","")
		}	   
	});
	
	$("#ELeader").combogrid({
		panelWidth:150,
		panelHeight:200,
		delay: 0,    
		mode: 'remote',    
		url: PUBLIC_CONSTANT.URL.QUERY_GRID_URL,
		fitColumns: true,   
		striped: true,   
		editable:true,   
		collapsible:false,//是否可折叠的   
		fit: true,//自动大小   
		method:'post', 
		disabled:false,
		idField: 'RowId',    
		textField: 'Desc', 
		columns: [[    
			{field:'Desc',title:'批准人',width:150,sortable:true},
			{field:'RowId',title:'RowId',width:20,hidden:true}
		]],
		keyHandler:{
			up: function () {
                //取得选中行
                var selected = $('#ELeader').combogrid('grid').datagrid('getSelected');
                if (selected) {
                    //取得选中行的rowIndex
                    var index = $('#ELeader').combogrid('grid').datagrid('getRowIndex', selected);
                    //向上移动到第一行为止
                    if (index > 0) {
                        $('#ELeader').combogrid('grid').datagrid('selectRow', index - 1);
                    }
                } else {
                    var rows = $('#ELeader').combogrid('grid').datagrid('getRows');
                    $('#ELeader').combogrid('grid').datagrid('selectRow', rows.length - 1);
                }
             },
             down: function () {
              //取得选中行
                var selected = $('#ELeader').combogrid('grid').datagrid('getSelected');
                if (selected) {
                    //取得选中行的rowIndex
                    var index = $('#ELeader').combogrid('grid').datagrid('getRowIndex', selected);
                    //向下移动到当页最后一行为止
                    if (index < $('#ELeader').combogrid('grid').datagrid('getData').rows.length - 1) {
                        $('#ELeader').combogrid('grid').datagrid('selectRow', index + 1);
                    }
                } else {
                    $('#ELeader').combogrid('grid').datagrid('selectRow', 0);
                }
				
            },
			left: function () {
				return false;
            },
			right: function () {
				return false;
            },            
			enter: function () { 
			    //文本框的内容为选中行的的字段内容
                var selected = $('#ELeader').combogrid('grid').datagrid('getSelected');  
			    if (selected) { 
			      	$('#ELeader').combogrid("options").value=selected.RowId;
			    }
                //选中后让下拉表格消失
                $('#ELeader').combogrid('hidePanel');
				//$("#AdmLoc").focus();
            },
			query:function(q){
				if (this.AutoSearchTimeOut) {
					window.clearTimeout(this.AutoSearchTimeOut)
					this.AutoSearchTimeOut=window.setTimeout("LoadELeader('ELeader','"+q+"')",400)
				}else{
					this.AutoSearchTimeOut=window.setTimeout("LoadELeader('ELeader','"+q+"')",400)
				}

				$('#ELeader').combogrid("setValue",q);
				
            }
		},
		onChange:function (newValue, oldValue) { 
		    //alert(newValue+","+oldValue)
		    //如果审批人非当前登陆用户,则显示密码
		    if (newValue!=session['LOGON.USERID']){
			    $("#tr-EPassword").removeAttr("style");
			}else{
				$("#tr-EPassword").attr("style","display:none;");
			}
	    }	   
	});
	/*var CurrDate=tkMakeServerCall("web.DHCBatchStopNew","GetCurrDate");
	var queryParams = new Object();
		queryParams.ClassName = "web.DHCApptScheduleNew";
		queryParams.QueryName = "LookUpReasonNotAvail";;
		queryParams.Arg1 = CurrDate.split("^")[0];
		queryParams.ArgCnt = 1;
		InitComboData('#EReason',queryParams)*/
	LoadELeader("ELeader","");
	/*var queryParams = new Object();
		queryParams.ClassName = "web.DHCApptScheduleNew";
		//queryParams.QueryName = "LookUpELeader";;
		queryParams.QueryName = "LookUpELeaderNew";
		//queryParams.Arg1 = CurrDate.split("^")[0];
		queryParams.Arg1 = session['LOGON.CTLOCID'];
		queryParams.ArgCnt = 1;
		InitComboData('#ELeader',queryParams)*/
	$("#StopSave").on("click", StopSave)
	$("#StopCancel").on("click", StopCancel)
	
 }
 function LoadELeader(obj,q){
	 var queryParams = new Object();
	queryParams.ClassName = "web.DHCApptScheduleNew";
	queryParams.QueryName = "LookUpELeaderNew";
	queryParams.Arg1 = session['LOGON.CTLOCID'];
	queryParams.Arg2 = q;
	queryParams.ArgCnt = 2;
	InitComboData('#'+obj+'',queryParams)
 }
 function ClearReplaceData(){
	 $("#ERepDoc").combogrid("setValue", '');
	 $("#ERepDoc").combogrid("setText", '');
	 $("#ERepSessionType").combogrid("setValue", '');
	 $("#ERepSessionType").combogrid("setText", '');
	 $("#ERepReason").combogrid("setValue", '');
	 $("#ERepReason").combogrid("setText", '');
	 $("#ERepPassword").val('');
	 
 }
 //替诊
 function ReplaceSave(){
	 var ERepLoc=$("#ERepLoc").combogrid("getValue");
	 if(ERepLoc==""){
		 alert("请选择替诊科室!")
		 return false;
	 }
	 var ERepDoc=$("#ERepDoc").combogrid("getValue");
	 if(ERepDoc==""){
		 alert("请选择替诊医生!")
		 return false;
	 }
	 var ERepSessionType=$("#ERepSessionType").combogrid("getValue");
	 if(ERepSessionType==""){
		 alert("请选择替诊职称!")
		 return false;
	 }
	 var ERepReason=$("#ERepReason").combogrid("getValue");
	 var _data = $("#ERepReason").combogrid('grid').datagrid('getData')['rows'];
	 var _options = $("#ERepReason").combogrid('options'); 
	 var _b = false;/* 标识是否在下拉列表中找到了用户输入的字符 */    
	 for (var i = 0; i < _data.length; i++) {       
		 if (_data[i][_options.idField] == ERepReason) {           
		 	 _b = true;            
		 	 break;       
		  }    
     }   
     if (!_b) { 
    	ERepReason="";
   	 };
	 if(ERepReason==""){
		 alert("请选择替诊原因!")
		 return false;
	 }
	 var ERepLeader=$("#ERepLeader").combogrid("getValue");
	 if ((ERepLeader!="")&&(ERepLeader!=session['LOGON.USERID'])){
		 var UserName=$("#ERepLeader").combogrid("getText");	
		 var ERepPassword=$("#ERepPassword").val();
		 if(ERepPassword==""){
			alert("请输入批准人【"+UserName+"】的登陆密码!");
			$("#EPassword").focus();
			return false;
		}
		var err=tkMakeServerCall('web.DHCOEOrdItem','PinLogNumberValid',ERepLeader,ERepPassword);
		if (err==-1){
			alert("该用户不存在!")
			return false;
		}else if(err==-4){
			alert("密码错误!")
			return false;
		}
	 }
	 var ASRowID=$("#ReplaceASRowIDStr").val();
	 var ret=tkMakeServerCall("web.DHCRBApptSchedule","ApptScheduleIsLater",ASRowID)
	 if (ret<0){
		$.messager.alert('错误', "操作号源已超过号源可用时间! ");
		return false;
	 }
	 var IsAudit=0;
	 var RequestRet=tkMakeServerCall("web.DHCRBApptScheduleAudi","GetRBASRequestFlag","R",ASRowID,session['LOGON.GROUPID']);
	 var RequestRetArr=RequestRet.split("^");
	 var RequestFlag=RequestRetArr[0];
	 if(RequestFlag=="0")IsAudit="1";
	 var ret1 = cspHttpServerMethod(MRep.value,ASRowID,ERepDoc,ERepLoc,ERepReason,ERepLeader,ERepSessionType,0,IsAudit);
	 var temparr=ret1.split("^");
	 var ret=temparr[0];
	 if (ret==0){
		var msg="替诊成功!"
		if(RequestFlag==1){
			var msg="替诊申请成功!请等待相关人员审核后生效.";
		}
		$.messager.alert('提示', msg);
		//$.messager.alert('提示', '替诊成功!');
		ReplaceCancel();
	 	ReLoadScheduleGrid();
		return true;
	 }else{
		switch(parseInt(ret))
		{
		case 300:
			$.messager.alert('错误', '医生没有安排资源!');
	 		break;
		case 200:	
			$.messager.alert('错误', '医生已经有排班记录!');
			break;
		case 100:
	  		$.messager.alert('错误', '替诊失败!');
			break;
		case 101:
			$.messager.alert('错误', '复制被替诊医生的预约限额记录失败');		
	  		break;
		default:
			$.messager.alert('错误', ret);
			break;	
 		}
 		return false;
	 }
	 
 }
 //停诊
 function StopSave(){
	mStopLeaderId=$("#ELeader").combogrid("getValue");	
	if ((mStopLeaderId!="")&&(mStopLeaderId!=session['LOGON.USERID'])){
		var UserName=$("#ELeader").combogrid("getText");	
		var EPassword=$("#EPassword").val();
		if(EPassword==""){
			alert("请输入批准人【"+UserName+"】的登陆密码!");
			$("#EPassword").focus();
			return false;
		}
		var err=tkMakeServerCall('web.DHCOEOrdItem','PinLogNumberValid',mStopLeaderId,EPassword);
		if (err==-1){
			alert("该用户不存在!")
			return false;
		}else if(err==-4){
			alert("密码错误!")
			return false;
		}
	}
	mStopReasonId=$("#EReason").combogrid("getValue");
	var _data = $("#EReason").combogrid('grid').datagrid('getData')['rows'];
	var _options = $("#EReason").combogrid('options'); 
	var _b = false;/* 标识是否在下拉列表中找到了用户输入的字符 */    
	for (var i = 0; i < _data.length; i++) {       
		 if (_data[i][_options.idField] == mStopReasonId) {           
		 	 _b = true;            
		 	 break;       
		  }    
    }   
    if (!_b) { 
    	mStopReasonId="";
   	};
	if (mStopReasonId==""){
		$.messager.alert('提示', '请选择停诊原因!');
		return false;
	}	
	var ASRowidStr=$("#StopASRowIDStr").val();
	var NotRequestLocDesc="";
	var RequestLocDesc="";
	for (var i=0;i<ASRowidStr.split("^").length;i++){
		var ret=tkMakeServerCall("web.DHCRBApptSchedule","ApptScheduleIsLater",ASRowidStr.split("^")[i]);
		if (ret<0){ //<0过时了 >0中途停诊 
		  alert(t["ApptScheduleIsLater"]);
		  return false;
	    }
		
	    var StatusCode="S"
		if (ret==1) StatusCode="PS";
		var IsAudit="0";
		if (ret==2) IsAudit="1";
		var RequestRet=tkMakeServerCall("web.DHCRBApptScheduleAudi","GetRBASRequestFlag","S",ASRowidStr.split("^")[i],session['LOGON.GROUPID']);
		var RequestRetArr=RequestRet.split("^");
		var RequestFlag=RequestRetArr[0];
		if (RequestFlag==1) RequestLocDesc=RequestRetArr[1]+","+RequestLocDesc
		if(RequestFlag==0)IsAudit="1";
		var ret = cspHttpServerMethod(MStop.value,ASRowidStr.split("^")[i],mStopReasonId,mStopLeaderId,StatusCode,IsAudit);
		if (ret!= 0) {
			$.messager.alert('错误', '停诊失败!'+ret);
			return false;
		}
	}
	var msg="停诊成功!";
	if(NotRequestLocDesc!=""){msg=NotRequestLocDesc+"停诊成功!"};
	if(RequestLocDesc!=""){
		if(msg!=""){msg=msg+";"+RequestLocDesc+"停诊申请成功!请等待相关人员审核后生效."}
		else{msg=RequestLocDesc+"停诊申请成功!请等待相关人员审核后生效."}	
	}
	
	$.messager.alert('提示', msg);
	StopCancel();
	ReLoadScheduleGrid();
	return true;
 }
 function ReLoadScheduleGrid(){
	var tab = $('#ScheduleTab').tabs('getSelected');
	var index = $('#ScheduleTab').tabs('getTabIndex',tab);
	var GridId="ScheduleGrid"+index
	$("#"+GridId).datagrid('load');
 }
 function LimitCombo(flag)
 {
	$("#AdmDate").datebox(flag);
	$('#AdmLoc').combobox(flag);
	$('#TimeRange').combobox(flag);
	$('#AdmDoc').combobox(flag);
	$('#DocSession').combobox(flag);
	//$('#ClinicGroup').combobox(flag);
 }
 function LimitText(flag)
 {
	$('#StartTime').attr("readonly",flag);
	$("#EndTime").attr("readonly",flag);
	//$("#PositiveMax").attr("readonly",flag);
	$("#ApptMax").attr("readonly",flag);
	$("#TRSartTime").attr("readonly",flag);
	$("#TREndTime").attr("readonly",flag);
	//$("#TRRegNum").attr("readonly",flag);
	$("#TRRegNumStr").attr("readonly",flag);
	$("#TRRegInfoStr").attr("readonly",flag);
	//$("#EStartPrefix").attr("readonly",flag);
 }
 
 ///排班修改窗口初始化
 ///初始化科室
 function InitWinCombo()
 {	
	$('#AdmLoc').combogrid({
		panelWidth:400,
		panelHeight:380,
		delay: 0,    
		mode: 'remote',    
		url: PUBLIC_CONSTANT.URL.QUERY_GRID_URL,
		fitColumns: true,   
		striped: true,   
		editable:true,   
		pagination : true,//是否分页   
		rownumbers:true,//序号   
		collapsible:false,//是否可折叠的   
		fit: true,//自动大小   
		pageSize: 10,//每页显示的记录条数，默认为10   
		pageList: [10],//可以设置每页记录条数的列表   
		method:'post', 
		idField: 'RowId',    
		textField: 'LocDesc', 
		columns: [[    
			{field:'LocDesc',title:'科室名称',width:400,sortable:true},
			{field:'RowId',title:'RowId',width:120,sortable:true}
		]],
		keyHandler:{
			up: function () {
                //取得选中行
                var selected = $('#AdmLoc').combogrid('grid').datagrid('getSelected');
                if (selected) {
                    //取得选中行的rowIndex
                    var index = $('#AdmLoc').combogrid('grid').datagrid('getRowIndex', selected);
                    //向上移动到第一行为止
                    if (index > 0) {
                        $('#AdmLoc').combogrid('grid').datagrid('selectRow', index - 1);
                    }
                } else {
                    var rows = $('#AdmLoc').combogrid('grid').datagrid('getRows');
                    $('#AdmLoc').combogrid('grid').datagrid('selectRow', rows.length - 1);
                }
             },
             down: function () {
              //取得选中行
                var selected = $('#AdmLoc').combogrid('grid').datagrid('getSelected');
                if (selected) {
                    //取得选中行的rowIndex
                    var index = $('#AdmLoc').combogrid('grid').datagrid('getRowIndex', selected);
                    //向下移动到当页最后一行为止
                    if (index < $('#AdmLoc').combogrid('grid').datagrid('getData').rows.length - 1) {
                        $('#AdmLoc').combogrid('grid').datagrid('selectRow', index + 1);
                    }
                } else {
                    $('#AdmLoc').combogrid('grid').datagrid('selectRow', 0);
                }
				
            },
			left: function () {
				return false;
            },
			right: function () {
				return false;
            },            
			enter: function () { 
			    //文本框的内容为选中行的的字段内容
                var selected = $('#AdmLoc').combogrid('grid').datagrid('getSelected');  
			    if (selected) { 
			      	$('#AdmLoc').combogrid("options").value=selected.RowId;
			      	LoadAdmDoc(selected.RowId) ;
			    }
                //选中后让下拉表格消失
                $('#AdmLoc').combogrid('hidePanel');
				//$("#AdmLoc").focus();
				LoadLocArea("");
				$("#LocArea").combogrid("setValue", "");
			    $("#LocArea").combogrid("setText", "");
			    LoadClinicGroup(selected.RowId);
			    $("#ClinicGroup").combogrid("setValue", "");
			    $("#ClinicGroup").combogrid("setText", "");
			    
            },
			query:function(q){
				if (this.AutoSearchTimeOut) {
					window.clearTimeout(this.AutoSearchTimeOut)
					this.AutoSearchTimeOut=window.setTimeout("LoadAdmLoc('"+q+"')",400)
				}else{
					this.AutoSearchTimeOut=window.setTimeout("LoadAdmLoc('"+q+"')",400)
				}

				$('#AdmLoc').combogrid("setValue",q);
				//LoadDiagnosData(q);
				
            }
		},
		onSelect: function (){
			var selected = $('#AdmLoc').combogrid('grid').datagrid('getSelected');  
			if (selected) { 
			  $("#ClinicGroup").combogrid("setValue", "");
			  $("#ClinicGroup").combogrid("setText", "");
			  LoadClinicGroup(selected.RowId);
			  setTimeout(function(){
				$('#AdmLoc').combogrid("options").value=selected.RowId;
				  LoadAdmDoc(selected.RowId);
				  LoadLocArea("");
				  $("#LocArea").combogrid("setValue", "");
				  $("#LocArea").combogrid("setText", "");
				},500)	
			}
		},
		onLoadSuccess:function(data){
			var CurrentOrdName=$('#AdmLoc').combogrid('getValue');
			if(CurrentOrdName!=""){
				var CheckValue=/^\d+$/;
				if (CheckValue.test(CurrentOrdName)){
					$('#AdmLoc').combogrid("setValue","");
					$('#AdmLoc').combo("setText", "")
				}
			}
			$('#AdmLoc').next('span').find('input').focus();
		}
	});
	
$('#LocArea').combogrid({
		panelWidth:400,
		panelHeight:380,
		delay: 0,    
		mode: 'remote',    
		url: PUBLIC_CONSTANT.URL.QUERY_GRID_URL,
		fitColumns: true,   
		striped: true,   
		editable:true,   
		pagination : true,//是否分页   
		rownumbers:true,//序号   
		collapsible:false,//是否可折叠的   
		fit: true,//自动大小   
		pageSize: 10,//每页显示的记录条数，默认为10   
		pageList: [10],//可以设置每页记录条数的列表   
		method:'post', 
		idField: 'RowId',    
		textField: 'Desc', 
		columns: [[    
			{field:'Desc',title:'诊室名称',width:400,sortable:true},
			{field:'RowId',title:'RowId',width:20,sortable:true,hidden:true}
		]],
		keyHandler:{
			up: function () {
                //取得选中行
                var selected = $('#LocArea').combogrid('grid').datagrid('getSelected');
                if (selected) {
                    //取得选中行的rowIndex
                    var index = $('#LocArea').combogrid('grid').datagrid('getRowIndex', selected);
                    //向上移动到第一行为止
                    if (index > 0) {
                        $('#LocArea').combogrid('grid').datagrid('selectRow', index - 1);
                    }
                } else {
                    var rows = $('#LocArea').combogrid('grid').datagrid('getRows');
                    $('#LocArea').combogrid('grid').datagrid('selectRow', rows.length - 1);
                }
             },
             down: function () {
              //取得选中行
                var selected = $('#LocArea').combogrid('grid').datagrid('getSelected');
                if (selected) {
                    //取得选中行的rowIndex
                    var index = $('#LocArea').combogrid('grid').datagrid('getRowIndex', selected);
                    //向下移动到当页最后一行为止
                    if (index < $('#LocArea').combogrid('grid').datagrid('getData').rows.length - 1) {
                        $('#LocArea').combogrid('grid').datagrid('selectRow', index + 1);
                    }
                } else {
                    $('#LocArea').combogrid('grid').datagrid('selectRow', 0);
                }
				
            },
			left: function () {
				return false;
            },
			right: function () {
				return false;
            },            
			enter: function () { 
			    //文本框的内容为选中行的的字段内容
                var selected = $('#LocArea').combogrid('grid').datagrid('getSelected');  
			    if (selected) { 
			      $('#LocArea').combogrid("options").value=selected.RowId;
			    }
                //选中后让下拉表格消失
                $('#LocArea').combogrid('hidePanel');
				//$("#LocArea").focus();
            },
			query:function(q){
				if (this.AutoSearchTimeOut) {
					window.clearTimeout(this.AutoSearchTimeOut)
					this.AutoSearchTimeOut=window.setTimeout("LoadLocArea('"+q+"')",400)
				}else{
					this.AutoSearchTimeOut=window.setTimeout("LoadLocArea('"+q+"')",400)
				}

				$('#LocArea').combogrid("setValue",q);
				//LoadDiagnosData(q);
				
            }
		},onShowPanel:function(){
			LoadLocArea("");
		},
		onLoadSuccess:function(data){
			/*var CurrentOrdName=$('#LocArea').combogrid('getValue');
			if(CurrentOrdName!=""){
				var CheckValue=/^\d+$/;
				if (CheckValue.test(CurrentOrdName)){
					$('#LocArea').combogrid("setValue","");
					$('#LocArea').combo("setText", "")
				}
			}
			$('#LocArea').next('span').find('input').focus();*/
		}
	});
	$('#AdmDoc').combogrid({
		panelWidth:350,
		panelHeight:360,
		delay: 0,    
		mode: 'remote',    
		url: PUBLIC_CONSTANT.URL.QUERY_GRID_URL,
		fitColumns: true,   
		striped: true,   
		editable:true,   
		pagination : false,//是否分页   
		rownumbers:true,//序号   
		collapsible:false,//是否可折叠的   
		fit: true,//自动大小   
		pageSize: 10,//每页显示的记录条数，默认为10   
		pageList: [10],//可以设置每页记录条数的列表   
		method:'post', 
		idField: 'RowId',    
		textField: 'Desc', 
		columns: [[    
			{field:'Desc',title:'医生名称',width:250,sortable:true},
			{field:'RowId',title:'RowId',width:100,sortable:true}
		]],
		keyHandler:{
			up: function () {
                //取得选中行
                var selected = $('#AdmDoc').combogrid('grid').datagrid('getSelected');
                if (selected) {
                    //取得选中行的rowIndex
                    var index = $('#AdmDoc').combogrid('grid').datagrid('getRowIndex', selected);
                    //向上移动到第一行为止
                    if (index > 0) {
                        $('#AdmDoc').combogrid('grid').datagrid('selectRow', index - 1);
                    }
                } else {
                    var rows = $('#AdmDoc').combogrid('grid').datagrid('getRows');
                    $('#AdmDoc').combogrid('grid').datagrid('selectRow', rows.length - 1);
                }
             },
             down: function () {
              //取得选中行
                var selected = $('#AdmDoc').combogrid('grid').datagrid('getSelected');
                if (selected) {
                    //取得选中行的rowIndex
                    var index = $('#AdmDoc').combogrid('grid').datagrid('getRowIndex', selected);
                    //向下移动到当页最后一行为止
                    if (index < $('#AdmDoc').combogrid('grid').datagrid('getData').rows.length - 1) {
                        $('#AdmDoc').combogrid('grid').datagrid('selectRow', index + 1);
                    }
                } else {
                    $('#AdmDoc').combogrid('grid').datagrid('selectRow', 0);
                }
				
            },
			left: function () {
				return false;
            },
			right: function () {
				return false;
            },            
			enter: function () { 
			    //文本框的内容为选中行的的字段内容
                var selected = $('#AdmDoc').combogrid('grid').datagrid('getSelected');  
			    if (selected) { 
			      	$('#AdmDoc').combogrid("options").value=selected.RowId;
			    }
                //选中后让下拉表格消失
                $('#AdmDoc').combogrid('hidePanel');
            },
			query:function(q){
				var selLocRowId=$("#AdmLoc").combogrid("getValue");
				if (this.AutoSearchTimeOut) {
					window.clearTimeout(this.AutoSearchTimeOut)
					this.AutoSearchTimeOut=window.setTimeout(function(){LoadAdmDoc(selLocRowId,q);},400)
				}else{
					this.AutoSearchTimeOut=window.setTimeout(function(){LoadAdmDoc(selLocRowId,q);},400)
				}
				
				$('#AdmDoc').combogrid("setValue",q);
				//LoadDiagnosData(q);
				
            }
		},
		onSelect: function (rowIndex, rowData){
			var sessTypeDr = tkMakeServerCall("web.DhcResEffDateSessionClass","GetSessTypeByDocId",rowData.RowId,$("#AdmLoc").combogrid("getValue"));
			if(sessTypeDr != ""){
				$("#DocSession").combogrid('grid').datagrid("selectRecord",sessTypeDr.toString());
			}
			var selected = $('#AdmDoc').combogrid('grid').datagrid('getSelected');  
			if (selected) { 
			    DocSelectFun();
				/*var AdmLoc = $("#AdmLoc").combogrid("getValue");	
				var AdmDoc = selected.RowId ;
				var TimeRange=$("#TimeRange").combogrid("getValue");
				var encmeth=GetDocResource.value;
				if (encmeth!=''){
					var ret=cspRunServerMethod(encmeth,AdmLoc,AdmDoc,TimeRange);
					if (ret!=""){
						var Arr=ret.split("^");	
						$("#PositiveMax").attr('value',Arr[2]);
						$("#ApptMax").attr('value',Arr[3]);
						$("#TRRegNum").attr('value',Arr[3]);
						$("#EStartPrefix").attr('value',Arr[4]);
						$("#AddtionMax").attr('value',Arr[5]);
					}
				}*/
			}
		}
	});
	
	/*$("#EAdmDoc").combogrid({
		panelWidth:150,
		panelHeight:200,
		delay: 0,    
		mode: 'remote',    
		url: PUBLIC_CONSTANT.URL.QUERY_GRID_URL,
		fitColumns: true,   
		striped: true,   
		editable:true,   
		collapsible:false,//是否可折叠的   
		fit: true,//自动大小   
		method:'post', 
		idField: 'RowId',    
		textField: 'Desc', 
		disabled:true,
		columns: [[    
			{field:'Desc',title:'替诊医生',width:150,sortable:true},
			{field:'RowId',title:'RowId',width:20,hidden:true}
		]],
		onSelect: function (rowIndex, rowData){
			var sessTypeDr = tkMakeServerCall("web.DhcResEffDateSessionClass","GetSessTypeByDocId",rowData.RowId,rowData.RowId,$("#AdmLoc").combogrid("getValue"));
			if(sessTypeDr != ""){
				$("#EDocSession").combogrid('grid').datagrid("selectRecord",sessTypeDr.toString());
			}
		}
	});*/
	
	/*$('#EAdmLoc').combogrid({
		panelWidth:400,
		panelHeight:380,
		delay: 0,
		mode: 'remote',    
		url: PUBLIC_CONSTANT.URL.QUERY_GRID_URL,
		fitColumns: true,   
		striped: true,   
		editable:true,   
		pagination : true,//是否分页   
		rownumbers:true,//序号   
		collapsible:false,//是否可折叠的   
		fit: true,//自动大小   
		pageSize: 10,//每页显示的记录条数，默认为10   
		pageList: [10],//可以设置每页记录条数的列表   
		method:'post', 
		idField: 'RowId',    
		textField: 'LocDesc', 
		disabled:true,
		columns: [[    
			{field:'LocDesc',title:'科室名称',width:400,sortable:true},
			{field:'RowId',title:'RowId',width:120,sortable:true}
		]],
		keyHandler:{
			up: function () {
                //取得选中行
                var selected = $('#EAdmLoc').combogrid('grid').datagrid('getSelected');
                if (selected) {
                    //取得选中行的rowIndex
                    var index = $('#EAdmLoc').combogrid('grid').datagrid('getRowIndex', selected);
                    //向上移动到第一行为止
                    if (index > 0) {
                        $('#EAdmLoc').combogrid('grid').datagrid('selectRow', index - 1);
                    }
                } else {
                    var rows = $('#EAdmLoc').combogrid('grid').datagrid('getRows');
                    $('#EAdmLoc').combogrid('grid').datagrid('selectRow', rows.length - 1);
                }
             },
             down: function () {
              //取得选中行
                var selected = $('#EAdmLoc').combogrid('grid').datagrid('getSelected');
                if (selected) {
                    //取得选中行的rowIndex
                    var index = $('#EAdmLoc').combogrid('grid').datagrid('getRowIndex', selected);
                    //向下移动到当页最后一行为止
                    if (index < $('#EAdmLoc').combogrid('grid').datagrid('getData').rows.length - 1) {
                        $('#EAdmLoc').combogrid('grid').datagrid('selectRow', index + 1);
                    }
                } else {
                    $('#EAdmLoc').combogrid('grid').datagrid('selectRow', 0);
                }
				
            },
			left: function () {
				return false;
            },
			right: function () {
				return false;
            },            
			enter: function () { 
			    //文本框的内容为选中行的的字段内容
                var selected = $('#EAdmLoc').combogrid('grid').datagrid('getSelected');  
			    if (selected) { 
			      	$('#EAdmLoc').combogrid("options").value=selected.RowId;
			      	LoadAdmDoc(selected.RowId) ;
			    }
                //选中后让下拉表格消失
                $('#EAdmLoc').combogrid('hidePanel');
				//$("#AdmLoc").focus();
            },
			query:function(q){
				if (this.AutoSearchTimeOut) {
					window.clearTimeout(this.AutoSearchTimeOut)
					this.AutoSearchTimeOut=window.setTimeout("LoadEAdmLoc('"+q+"')",400)
				}else{
					this.AutoSearchTimeOut=window.setTimeout("LoadEAdmLoc('"+q+"')",400)
				}

				$('#EAdmLoc').combogrid("setValue",q);
				//LoadDiagnosData(q);
				
            }
		},
		onSelect: function (){
			var selected = $('#EAdmLoc').combogrid('grid').datagrid('getSelected');  
			if (selected) { 
			  $('#EAdmLoc').combogrid("options").value=selected.RowId;
			  LoadEAdmDoc(selected.RowId) ;
			}
		}
	});*/
	
	/// 选项不多, 不做检索了
	
	$("#TimeRange").combogrid({
		panelWidth:150,
		panelHeight:200,
		delay: 0,    
		//mode: 'remote',    
		url: PUBLIC_CONSTANT.URL.QUERY_GRID_URL,
		fitColumns: true,   
		striped: true,   
		editable:true,   
		collapsible:false,//是否可折叠的   
		fit: true,//自动大小   
		method:'post', 
		idField: 'RowId',    
		textField: 'Desc', 
		columns: [[    
			{field:'Desc',title:'时段',width:150,sortable:true},
			{field:'RowId',title:'RowId',width:20,hidden:true}
		]],
		onSelect: function (){
			var selected = $('#TimeRange').combogrid('grid').datagrid('getSelected');  
			if (selected) { 
			    DocSelectFun()
				var encmeth=GetTRTimeStrMethod.value;
				if (encmeth!=''){
					var ret=cspRunServerMethod(encmeth,selected.RowId);
					var Arr=ret.split("^");
					var SessTimeStart=Arr[0];
					var SessTimeEnd=Arr[1];
					$('#StartTime').attr('value',SessTimeStart);
					$('#EndTime').attr('value',SessTimeEnd);
					$('#TRSartTime').attr('value',SessTimeStart);
					$('#TREndTime').attr('value',SessTimeEnd);
				}
				$('#TimeRange').combogrid('hidePanel');
			}
		}
	});
			
	$("#DocSession").combogrid({
		panelWidth:150,
		panelHeight:200,
		delay: 0,    
		//mode: 'remote',    
		url: PUBLIC_CONSTANT.URL.QUERY_GRID_URL,
		fitColumns: true,   
		striped: true,   
		editable:true,   
		collapsible:false,//是否可折叠的   
		fit: true,//自动大小   
		method:'post', 
		idField: 'RowId',    
		textField: 'Desc', 
		columns: [[    
			{field:'Desc',title:'职称',width:150,sortable:true},
			{field:'RowId',title:'RowId',width:20,hidden:true}
		]]	   
	});
	
	/*$("#EDocSession").combogrid({
		panelWidth:150,
		panelHeight:200,
		delay: 0,    
		mode: 'remote',    
		url: PUBLIC_CONSTANT.URL.QUERY_GRID_URL,
		fitColumns: true,   
		striped: true,   
		editable:true,   
		collapsible:false,//是否可折叠的   
		fit: true,//自动大小   
		method:'post', 
		disabled:true,
		idField: 'RowId',    
		textField: 'Desc', 
		columns: [[    
			{field:'Desc',title:'替诊职称',width:150,sortable:true},
			{field:'RowId',title:'RowId',width:20,hidden:true}
		]]	   
	});*/
	
	$("#ClinicGroup").combogrid({
		panelWidth:150,
		panelHeight:200,
		delay: 0,    
		//mode: 'remote',    
		url: PUBLIC_CONSTANT.URL.QUERY_GRID_URL,
		fitColumns: true,   
		striped: true,   
		editable:true,   
		collapsible:false,//是否可折叠的   
		fit: true,//自动大小   
		method:'post', 
		idField: 'RowId',    
		textField: 'Desc', 
		columns: [[    
			{field:'Desc',title:'亚专业',width:150,sortable:true},
			{field:'RowId',title:'RowId',width:20,hidden:true}
		]]	   
	});
	
	LoadOtherCombo() ;

}
function DocSelectFun(){
	//var selected = $('#AdmDoc').combogrid('grid').datagrid('getSelected'); 
	var AdmLoc = $("#AdmLoc").combogrid("getValue");	
	//var AdmDoc = selected.RowId ;
	var AdmDoc = $("#AdmDoc").combogrid("getValue");
	if(AdmDoc=="") return false;
	var TimeRange=$("#TimeRange").combogrid("getValue");
	var encmeth=GetDocResource.value;
	if (encmeth!=''){
		var ret=cspRunServerMethod(encmeth,AdmLoc,AdmDoc,TimeRange);
		if (ret!=""){
			var Arr1=ret.split("$")[0];
			var Arr2=ret.split("$")[1];
			var Arr3=ret.split("$")[2];
			//var Arr=ret.split("^");
			var Arr=Arr1.split("^");	
			$("#PositiveMax").attr('value',Arr[2]);
			$("#ApptMax").attr('value',Arr[3]);
			/*if(Arr[2]-3>0){
				$("#TRRegNum").attr('value',Arr[2]-3);
			}else{
				$("#TRRegNum").attr('value',"");
			}*/
			if(Arr.length>=18){
			    $("#ClinicGroup").combogrid('grid').datagrid("selectRecord",Arr[18]);
			}else{
				$("#ClinicGroup").combobox("setValue", "");
				$("#ClinicGroup").combobox("setText", "");
			}
			$("#EStartPrefix").attr('value',Arr[4]);
			$("#AddtionMax").attr('value',Arr[5]);
			//$("#AutoLoad").attr('value',Arr2.split("^")[0]);
			//$("#ExtLoad").attr('value',Arr2.split("^")[1]);
			if(Arr3!=""){
				var TRInfoArr=Arr3.split("^");
				var TRFlag=TRInfoArr[0];
				var TRStTime=TRInfoArr[1];
				var TREnTime=TRInfoArr[2];
				var TRLenghth=TRInfoArr[3];
				var TRSDHS=TRInfoArr[4];
				var TRRegNumStr=TRInfoArr[5];
				var TRRegInfoStr=TRInfoArr[6];
				if(TRFlag=="Y"){
					$("#TRFlag").attr('checked',true);	
					$("#TRLength").attr('value',TRLenghth);
					$("#TRRegNum").attr('value',TRSDHS);
					$("#TRSartTime").attr('value',TRStTime);
					$("#TREndTime").attr('value',TREnTime);
					$("#TRRegNumStr").attr('value',TRRegNumStr);
					$("#TRRegInfoStr").attr('value',TRRegInfoStr);
				}else{
					$("#TRFlag").attr('checked',false);	
					$("#TRLength").attr('value',"");
					$("#TRRegNum").attr('value',"");
					$("#TRSartTime").attr('value',"");
					$("#TREndTime").attr('value',"");
					$("#TRRegNumStr").attr('value',"");
					$("#TRRegInfoStr").attr('value',"");	
				}
			}else{
				$("#TRFlag").attr('checked',false);	
				$("#TRLength").attr('value',"");
				$("#TRRegNum").attr('value',"");
				$("#TRSartTime").attr('value',"");
				$("#TREndTime").attr('value',"");
				$("#TRRegNumStr").attr('value',"");
				$("#TRRegInfoStr").attr('value',"");	
			}
		}
	}
}
function LoadAdmDoc(AdmLocID,q)
{
	if(q==undefined)q="";
	//$("#AdmDoc").combogrid('loadData', { total: 0, rows: [] }); 
	//$("#AdmDoc").combogrid("grid").datagrid("reload");
	if (AdmLocID=="") return;
	var desc=q;
	var TimeRange=$("#TimeRange").combogrid("getValue");
	var AdmDate=$("#AdmDate").datebox("getValue"); 
	var queryParams = new Object();
	queryParams.ClassName ='web.DHCApptScheduleNew';
	queryParams.QueryName ='FinNoRegDoc'; 
	queryParams.Arg1 =AdmDate;
	queryParams.Arg2 =AdmLocID;
	queryParams.Arg3 =TimeRange;
	queryParams.Arg4 =desc;
	queryParams.ArgCnt =4;
	InitComboData('#AdmDoc',queryParams)
	//InitComboData('#EAdmDoc',queryParams)
	//$("#AdmDoc").combogrid("setValue",'');
} 
function LoadEAdmDoc(AdmLocID)
{
	//$("#AdmDoc").combogrid('loadData', { total: 0, rows: [] }); 
	$("#EAdmDoc").combogrid("grid").datagrid("reload");
	if (AdmLocID=="") return;
	var TimeRange=$("#TimeRange").combogrid("getValue");
	var AdmDate=$("#AdmDate").datebox("getValue"); 
	var queryParams = new Object();
	queryParams.ClassName ='web.DHCApptScheduleNew';
	queryParams.QueryName ='FinNoRegDoc'; 
	queryParams.Arg1 =AdmDate;
	queryParams.Arg2 =AdmLocID;
	queryParams.Arg3 =TimeRange;
	queryParams.ArgCnt =3;
	InitComboData('#EAdmDoc',queryParams)
	$("#EAdmDoc").combogrid("setValue",'');
}
function LoadEAdmLoc(q)
{
	var desc=q;
	//if (desc=="") return;
	var queryParams = new Object();
	queryParams.ClassName ='web.DHCApptScheduleNew';
	queryParams.QueryName ='FindLoc'; 
	queryParams.Arg1 =desc;
	queryParams.Arg2 =userid;
	queryParams.Arg3 =groupid;
	queryParams.ArgCnt =3;
	InitComboData('#EAdmLoc',queryParams)
}
function LoadERepLoc(q){
	var desc=q;
	var queryParams = new Object();
	queryParams.ClassName ='web.DHCApptScheduleNew';
	queryParams.QueryName ='FindLoc'; 
	queryParams.Arg1 =desc;
	queryParams.Arg2 =userid;
	queryParams.Arg3 =groupid;
	queryParams.ArgCnt =3;
	InitComboData('#ERepLoc',queryParams)
}
function InitComboData(ComboGridID,queryParams)
{
	var jQueryComboGridObj = $(ComboGridID);
	var opts = jQueryComboGridObj.combogrid("grid").datagrid("options");
	opts.url = PUBLIC_CONSTANT.URL.QUERY_GRID_URL;
	opts.queryParams = queryParams;
	jQueryComboGridObj.combogrid("grid").datagrid("reload");
}

/*function LoadAdmLoc(q)
{
	var desc=q;
	//if (desc=="") return;
	var queryParams = new Object();
	queryParams.ClassName ='web.DHCApptScheduleNew';
	queryParams.QueryName ='FindLoc'; 
	queryParams.Arg1 =desc;
	queryParams.Arg2 =userid;
	queryParams.Arg3 =groupid;
	queryParams.ArgCnt =3;
	InitComboData('#AdmLoc',queryParams)
}*/
function LoadAdmLoc(q,selExamRowId)
{
	if (typeof selExamRowId=="undefined"){
		selExamRowId=""
	}
	var desc=q;
	//if (desc=="") return;
	var queryParams = new Object();
	queryParams.ClassName ='web.DHCApptScheduleNew';
	queryParams.QueryName ='FindLoc'; 
	queryParams.Arg1 =desc;
	queryParams.Arg2 =userid;
	queryParams.Arg3 =groupid;
	queryParams.Arg4 =selExamRowId
	queryParams.ArgCnt =4;
	InitComboData('#AdmLoc',queryParams)
}

function LoadERepDoc(q)
{
	var AdmLocID=$("#ERepLoc").combogrid("getValue");
	$("#ERepDoc").combogrid("grid").datagrid("reload");
	if (AdmLocID=="") return;
	var ReplaceASRowID=$("#ReplaceASRowIDStr").val();
	var ReplaceASRowIDInfo=tkMakeServerCall("web.DHCApptScheduleNew","GetApptScheduleInfo",ReplaceASRowID);
	var TimeRange=ReplaceASRowIDInfo.split("^")[0]; //$("#TimeRange").combogrid("getValue");
	var AdmDate=ReplaceASRowIDInfo.split("^")[1]; //$("#AdmDate").datebox("getValue"); 
	var queryParams = new Object();
	queryParams.ClassName ='web.DHCApptScheduleNew';
	queryParams.QueryName ='FinNoRegDoc'; 
	queryParams.Arg1 =AdmDate;
	queryParams.Arg2 =AdmLocID;
	queryParams.Arg3 =TimeRange;
	queryParams.Arg4 =q;
	queryParams.ArgCnt =4;
	InitComboData('#ERepDoc',queryParams)
}
function GetASRoomData(ERowid){
	ASRoomData =eval('(' + tkMakeServerCall("web.DhcResEffDateSessionClass","GetConsultingRoomByBoruID",ERowid) + ')'); 
}
function GetExaRowid(){
	var selObj=$("#LocDocTree").tree("getSelected");
	if(selObj){
		var idStr=selObj.id;
		var idStrArr=idStr.split("^")
		if(idStrArr[0]=="Loc"){
			var parentObj=$("#LocDocTree").tree("getParent",selObj.target)
			var parentNodeid=parentObj.id ;
			var parentNodeidArr=parentNodeid.split("^")
			var ExaRowid=parentNodeidArr[1];
			return ExaRowid;
		}else{
			if(idStrArr[0]=="Doc"){
				var parentObj=$("#LocDocTree").tree("getParent",selObj.target);
				var parentObj=$("#LocDocTree").tree("getParent",parentObj.target);
				var parentNodeid=parentObj.id ;
				var parentNodeidArr=parentNodeid.split("^")
				var ExaRowid=parentNodeidArr[1];
				return ExaRowid;
			}else{
				var ExaRowid=idStrArr[1];
				return ExaRowid;
			}
		}
	}
	return "";
}
///初始化诊室
function LoadLocArea(q) 
{
	var LocID = $('#AdmLoc').combogrid("getValue");
	var desc=q;
	var queryParams = new Object();
	var ClassName = "web.DHCApptScheduleNew";
	//var QueryName = "LookUpRoomByUser";
	var QueryName = "LookUpRoomByUserNew";
	queryParams.ClassName = ClassName;
	queryParams.QueryName = QueryName;
	queryParams.Arg1 = desc;
	queryParams.Arg2 = userid;
	queryParams.Arg3 = LocID;
	queryParams.ArgCnt = 3;
	InitComboData('#LocArea',queryParams)
} 

function LoadOtherCombo() 
{
	var CurrDate=tkMakeServerCall("web.DHCBatchStopNew","GetCurrDate");
	var queryParams = new Object();
		queryParams.ClassName = "web.DHCApptScheduleNew";
		queryParams.QueryName = "LookUpTimeRange";
		queryParams.Arg1 = CurrDate.split("^")[0];
		queryParams.ArgCnt = 1;
		InitComboData('#TimeRange',queryParams)
	
	var queryParams = new Object();
		queryParams.ClassName = "web.DHCApptScheduleNew";
		queryParams.QueryName = "LookUpSessionType";
		queryParams.Arg1 = CurrDate.split("^")[0];
		queryParams.ArgCnt = 1;
		InitComboData('#DocSession',queryParams)
		//InitComboData('#EDocSession',queryParams)
	LoadClinicGroup("");	
}
function LoadClinicGroup(LocRowid){
	var CurrDate=tkMakeServerCall("web.DHCBatchStopNew","GetCurrDate");
	var queryParams = new Object();
		queryParams.ClassName = "web.DHCApptScheduleNew";
		queryParams.QueryName = "LookUpClinicGroup";;
		queryParams.Arg1 = CurrDate.split("^")[0];
		queryParams.Arg2 = LocRowid;
		queryParams.ArgCnt = 2;
		InitComboData('#ClinicGroup',queryParams)
}
 
 function formatdate(Date)
 {
	return tkMakeServerCall("web.DHCBatchStopNew","FormatStringToDate",Date,DateFormat);
 }
 
 function formattime(Time)
 {
	return tkMakeServerCall("web.DHCBatchStopNew","FormatStringToTime",Time);
 }
 
 function InitWinInfo(ASRowId)
 {
	 //  ID,LocationName,LocationID,DoctorName,DoctorID,RoomName,RoomID,ScheduleDate,SessionStartTime,SessEndTime,
	 // SessionTimeName,SessionTypeDesc,SessionTimeID,Price,TotalNum,BookNum,OverBookNum,AppStartNo,QueueNO,Status,
	 // StatusDesc,RegisterNum,AppedNum,AppedArriveNum,TRDoc,SessionClinicGroupDr,SessionClinicGroupDesc,
	 // SessionTypeDr,LockFlag,IrregularFlag,TRInfo")
	var queryParams = new Object();
	queryParams.ClassName ='web.DHCRBApptSchedule';
	queryParams.QueryName ='ApptScheduleListQuery';
	queryParams.Arg1 ="";
	queryParams.Arg2 ="";
	queryParams.Arg3 ="";
	queryParams.Arg4 ="";
	queryParams.Arg5 =ASRowId;
	queryParams.Arg6 ="";
	queryParams.ArgCnt = 6;
	url = "./dhcdoc.cure.query.grid.easyui.csp"
	$.ajax({
	   type: 'POST',
	   url: url,
	   data: queryParams,
	   dataType: 'json',
	   async: true,
	   success: function(data, textStatus, jqXHR){
		    $("#ASRowID").attr('value', data.rows[0].ID);
		    
		    $("#AdmLoc").combogrid("setValue", data.rows[0].LocationID);
		    if (data.rows[0].LocationID!="") {
			    LoadAdmDoc(data.rows[0].LocationID);
			    LoadClinicGroup(data.rows[0].LocationID);
			}
		    
		    $("#AdmLoc").combogrid("setText", data.rows[0].LocationName);
		    $("#LocArea").combogrid("setValue", data.rows[0].RoomID);
			$("#LocArea").combogrid("setText", data.rows[0].RoomName);
			$("#TimeRange").combogrid("setValue", data.rows[0].SessionTimeID);
			$("#TimeRange").combogrid("setText", data.rows[0].SessionTimeName);
			$("#AdmDoc").combogrid("setValue", data.rows[0].DoctorID);
			$("#AdmDoc").combogrid("setText", data.rows[0].DoctorName);
			$("#DocSession").combogrid("setValue", data.rows[0].SessionTypeDr);
			$("#DocSession").combogrid("setText", data.rows[0].SessionTypeDesc);
			$("#ClinicGroup").combogrid("setValue", data.rows[0].SessionClinicGroupDr);
			$("#ClinicGroup").combogrid("setText", data.rows[0].SessionClinicGroupDesc);
			if (data.rows[0].ScheduleDate!=""){
				var AdmDate=formatdate(data.rows[0].ScheduleDate); 
				$("#AdmDate").datebox("setValue",AdmDate);  
			}
			$('#StartTime').attr('value',data.rows[0].SessionStartTime);
			$('#EndTime').attr('value',data.rows[0].SessEndTime);

			$('#PositiveMax').attr('value',data.rows[0].TotalNum);
			$('#ApptMax').attr('value',data.rows[0].BookNum);
			$('#AddtionMax').attr('value',data.rows[0].OverBookNum);
			$("#EStartPrefix").attr('value',data.rows[0].AppStartNo);
			//$("#AutoLoad").attr('value',data.rows[0].AutoLoad);
			//$("#ExtLoad").attr('value',data.rows[0].ExtLoad);

			if (data.rows[0].TRInfo!="") {
				var TRInfoNum=data.rows[0].TRInfo.split("^") ;
				var ASTimeRangeFlag=TRInfoNum[0];
				var TRSartTime=formattime(TRInfoNum[1]);
				var TREndTime=formattime(TRInfoNum[2]);
				var TRLength=TRInfoNum[3];
				var TRRegNum=TRInfoNum[4];
				var TRRegNumStr=TRInfoNum[5];
				var TRRegInfoStr=TRInfoNum[6];
				var StopRegNoFlag=TRInfoNum[8];
                if (ASTimeRangeFlag=="Y"){
	                $("#TRFlag").attr('checked',true);
	            }else{
		            $("#TRFlag").attr('checked',false);
		        }
		        if (StopRegNoFlag=="Y"){
	                $("#StopRegNoFlag").attr('checked',true);
	            }else{
		            $("#StopRegNoFlag").attr('checked',false);
		        }
		        $('#TRLength').attr('value',TRLength);
				$('#TRSartTime').attr('value',TRSartTime);
				$('#TREndTime').attr('value',TREndTime);
				$('#TRRegNum').attr('value',TRRegNum);
				$('#TRRegNumStr').attr('value',TRRegNumStr);
				$('#TRRegInfoStr').attr('value',TRRegInfoStr);
				if ((TRSartTime=="")||(TREndTime=="")){
					TRTimeRangeClick();
				}
				
			}
	   },
	   error: function(XMLHttpRequest, textStatus, errorThrown){
			alert(textStatus+"("+errorThrown+")");
	   }
	}); 
 }
 ////文本框只能输入数字，并屏蔽输入法和粘贴
 $.fn.numeral = function() {     
    $(this).css("ime-mode", "disabled");     
    this.bind("keypress",function(e) {     
    var code = (e.keyCode ? e.keyCode : e.which);  //兼容火狐 IE      
		if(!$.browser.msie&&(e.keyCode==0x8))  //火狐下不能使用退格键     
		{     
			return ;     
		}     
        return code >= 48 && code<= 57;     
    });     
    this.bind("blur", function() {     
        if (this.value.lastIndexOf(".") == (this.value.length - 1)) {     
            this.value = this.value.substr(0, this.value.length - 1);     
        } else if (isNaN(this.value)) {     
            this.value = "";     
        }     
    });     
    this.bind("paste", function() {     
        var s = clipboardData.getData('text');     
        if (!/\D/.test(s));     
        value = s.replace(/^0*/, '');     
        return false;     
    });     
    this.bind("dragenter", function() {     
        return false;     
    });     
    this.bind("keyup", function() {
		if(this.value==0) return 
        if (/(^0+)/.test(this.value)) {     
			this.value = this.value.replace(/^0*/, '');     
        }     
    });     
};     
function myformatter(date){
			var y = date.getFullYear();
			var m = date.getMonth()+1;
			var d = date.getDate();
			if (DateFormat==3){
				return y+'-'+(m<10?('0'+m):m)+'-'+(d<10?('0'+d):d);
			}else if(DateFormat==4){
				return (d<10?('0'+d):d)+"/"+(m<10?('0'+m):m)+"/"+y
				//return y+'-'+(m<10?('0'+m):m)+'-'+(d<10?('0'+d):d);
			}
			
}
function myparser(s){
			if (!s) return new Date();
			if (DateFormat==3){
				var ss = s.split('-');
				var y = parseInt(ss[0],10);
				var m = parseInt(ss[1],10);
				var d = parseInt(ss[2],10);
				if (!isNaN(y) && !isNaN(m) && !isNaN(d)){
					return new Date(y,m-1,d);
				} else {
					return new Date();
				}
			}else if(DateFormat==4){
				var ss = s.split('/');
				var y = parseInt(ss[2],10);
				var m = parseInt(ss[1],10);
				var d = parseInt(ss[0],10);
				if (!isNaN(y) && !isNaN(m) && !isNaN(d)){
					return new Date(y,m-1,d);
				} else {
					return new Date();
				}
			}
			
}
