/// Description: 科护士长评价单评价界面 
/// Creator: congyue
/// CreateDate: 2018-04-16
var EvaRecordId="",LinkRecordId="",WinCode="",AuditList="",CancelAuditList="",StaFistAuditUser="",StsusGrant="",RepStaus="";
var userName="";
var AssessFlag="",LocHeadNurEvaFlag="",NurDepEvaFlag=""; ///评价按钮标识，科护士长评价按钮标识，护理部评价按钮标识
var EvaFlagList=""; /// 评价标识串  评价按钮标识^科护士长评价按钮标识^护理部评价按钮标识 
$(document).ready(function(){
	
	EvaRecordId=getParam("recordId");  //表单类型id
	LinkRecordId=getParam("LinkRecordId");  //关联表单记录ID
	AuditList=getParam("AuditList");  //审核串
	CancelAuditList=getParam("CancelAuditList");  //撤销审核串
	StaFistAuditUser=getParam("StaFistAuditUser");  //第一审批人
	StsusGrant=getParam("StsusGrant");  //审核标识
	RepStaus=getParam("RepStaus");  //报告状态
	WinCode=getParam("code");  //关联表单记录code
	EvaFlagList=getParam("EvaFlagList");  //评价标识串
	reportControl();			// 表单控制  	
	InitButton();				// 初始化按钮
	CheckTimeornum();  //时间校验
	InitCheckRadio();//加载界面checkboxradio在父元素没有勾选的情况下，子元素不可勾选，填写
});
//获取病人信息
function InitPatInfo(){};
// 表单控制
function reportControl(){
	$("#left-nav").hide();
	$("#anchor").hide();
	$("#gotop").hide();
	$("#gologin").hide();
	$("#footer").hide();
	$("#assefooter").show();
	$("#from").css({
		"margin-left":"20px",
		"margin-right":"20px"
	});
	$('#AuditMessage').hide(); //2018-06-12 cy 审批信息展现
	//复选框按钮事件
	$("input[type=radio]").each(function(){
		$(this).click(function(){
			$(this).is(':checked');
			InitCheckRadio();
		});
	});
	//复选框按钮事件
	$("input[type=checkbox]").each(function(){
		$(this).click(function(){
			$(this).is(':checked');
			InitCheckRadio();
		});
	});
	// 会议日期控制
	chkdate("HeadnurMeetDate","HeadnurMeetTime");
	add_event();
	
	//参会人员 
	$('#HeadnurParticipants').css({
		"width":800,
		"max-width":800
	});
	RepSetRead("HeadnurParticipants","input",1);	
	$("body").click(function(){
		AllStyle("textarea","",100);
  		InitLabInputText(".lable-input");
	})
	setTimeout(function(){ //延时点击body
        $("body").click();
    },500)	
    $(".lable-input").css('width','100px');
	$(".lable-input").css('max-width','100px');
	var EvaData=EvaFlagList.replace(/(^\s*)|(\s*$)/g,"").split("^");
	AssessFlag=EvaData[0];
	LocHeadNurEvaFlag=EvaData[1];
	NurDepEvaFlag=EvaData[2];
	
	if(EvaRecordId!="")	{
		// 添加按钮隐藏 
		$('#ParPantsAddBut').hide();
		//大科护理不良事件分析 不可编辑
		$("#LocHeadNurCauseAnalysis-panel input").attr("readonly",'readonly');
		$("#LocHeadNurCauseAnalysis-panel textarea").attr("readonly",'readonly');
		$("#HeadnurMeetDate").datebox({"disabled":true});
		$("#LocHeadNurCauseAnalysis-panel input[type=radio]").attr("disabled",true);  
		$("#LocHeadNurCauseAnalysis-panel input[type=checkbox]").attr("disabled",true);  
		$(".mytext").attr("readonly",'readonly');
		//现场工作评价  不可编辑
		$("[id^='LocHeadNurEvaluate-94416-']").each(function(){
			var rowid=this.id.split(".")[0];
			var rownum=this.id.split(".")[1];
			if ((this.value!="")){
				$("[id^='"+rowid+"'][id$='"+rownum+"']").attr("readonly",'readonly');
				$("input[id^='"+rowid+"'][id$='"+rownum+"']").datebox({"disabled":true});
				$('a:contains('+$g("删除")+')').parent().hide();
			}
			if(LocHeadNurEvaFlag!="1"){
				$("[id^='"+rowid+"'][id$='"+rownum+"']").attr("readonly",'readonly');
				$("input[id^='"+rowid+"'][id$='"+rownum+"']").datebox({"disabled":true});
				$('a:contains('+$g("增加")+')').parent().hide();
			}
			
			
		})
				
	}

}
//按钮控制与方法绑定
function InitButton(){
	$("#AsseSaveBut").on("click",function(){
		SaveAsse(0);
	})
	//参会人员 添加按钮事件
	$('#ParPantsAddBut').on("click",function(){
		StaffEnter();
	})
	$('#Find').bind("click",QueryName);   //点击查询
   	$('#Add').bind("click",MemAdd);     //点击添加，将勾选的人员添加到输入框 参会人员
  	$('#MonAdd').hide();  //隐藏 添加晨会人员按钮
}


//报告评价保存
function SaveAsse(flag)
{
	 ///保存前,对页面必填项进行检查
	if(!(checkRequired()&&checkother())){
		return;
	} 
	runClassMethod("web.DHCADVFormRecord","SaveRecord",
		{'user':LgUserID,
		 'formId':$("#formId").val(),
		 'formVersion':$("#formVersion").val(),
		 'par':loopStr("#from"),
		 'recordId':EvaRecordId,
		 'linkRecordId':LinkRecordId
		 },
		function(datalist){ 
			var data=datalist.replace(/(^\s*)|(\s*$)/g,"").split("^");
			EvaRecordId=data[1]
			if (data[0]=="0") {
				window.parent.CloseAsseWin();
				window.parent.location.reload();// 2018-11-20 cy 保存报告后，刷新父界面
				if(flag==1){
					window.parent.SetRepInfo(data[1],WinCode);
					window.parent.parent.CloseWinUpdate();
					window.parent.parent.Query();
				}
			}else{
				return;
			}
		},"text")
	
}

//检查界面勾选其他，是否填写输入框
function checkother(){
	//发生前防范措施落实情况 未落实 具体表现
	var BefPreventMeasures="";   //id是以后面的字符串开头
	if($("#BefPreventMeasures-94438").is(':checked')){
		$("input[type=checkbox][id^='BefPreMeaReason-']").each(function(){
			if($(this).is(':checked')){
				BefPreventMeasures=this.value;
			}
		})
		if(BefPreventMeasures==""){
			$.messager.alert($g("提示:"),"【"+$g("发生前防范措施落实情况")+"】"+$g("勾选")+$g('未落实')+"，"+$g("发生前防范措施未落实的原因-具体表现")+$g('内容')+"！");	
			return false;
		}
	}
	return true;
}
//页面初始加载checkbox,radio控制子元素不可以填写
function InitCheckRadio(){
	//发生前防范措施落实情况 未落实 具体表现
	$("input[type=radio][id^='BefPreventMeasures-']").each(function(){
		if ($(this).is(':checked')){
			var id=this.id;
			if (id=="BefPreventMeasures-94438"){
				$("input[type=checkbox][id^='BefPreMeaReason-']").attr("disabled",false);
			}else{
				$("input[type=checkbox][id^='BefPreMeaReason-']").removeAttr("checked"); //发生前防范措施未落实的原因
				$("input[type=checkbox][id^='BefPreMeaReason-']").attr("disabled",true); 
				$("#BefPreMeaReason-94448").nextAll(".lable-input").val(""); //发生前防范措施未落实的原因 其他
				$("#BefPreMeaReason-94448").nextAll(".lable-input").hide(); 
				
			}
			if(EvaRecordId!="")	{
				$("input[type=checkbox][id^='BefPreMeaReason-']").attr("disabled",true); 
			}
		}
	})
	//发生前防范措施未落实的原因
	$("input[type=checkbox][id^='BefPreMeaReason-']").each(function(){
		if ($(this).is(':checked')){
			$("input[type=radio][id='BefPreventMeasures-94438']").prop("checked",true) ;
		}
	})

}

function add_event(){
	AllStyle("textarea","",100);
	chkTableDate("LocHeadNurEvaluate-94416-94422-94427");
	//督查时间控制
	/*$("input[id^='LocHeadNurEvaluate-94416-94422-94427']").each(function(){
		if((this.id.split("-").length==4)){
			var datevalue=$("input[id^='"+this.id+"']").datebox("getValue");
			$("input[id='"+this.id+"']").datebox().datebox('calendar').calendar({
				validator: function(date){
					var now = new Date();
					return date<=now;
				}
			});
			$("input[id^='"+this.id+"']").datebox("setValue",datevalue);
		}
	}) */
}

//确认审批  2018-04-24
function FormConfirmAudit()
{	
	if(!(checkRequired()&&checkother())){
		return;
	} 
	runClassMethod("web.DHCADVCOMMONPART","AuditMataReport",{'params':AuditList},
	function(jsonString){ 
		if(jsonString.ErrCode < 0){
			$.messager.alert("提示:","审核错误,错误原因:"+"<font style='color:red;'>"+jsonString.ErrMsg+"</font>");   ///+"第"+errnum+"条数据"
			return ;
		}
		if(jsonString.ErrCode == 0){
			SaveAsse(1);
		}
	},"json",false);
	
}
//撤销审批 2018-04-24
function FormCancelAuditBt()
{	
	if ((StaFistAuditUser!="")&(StaFistAuditUser!=LgUserName)){
		$.messager.alert("提示:","报告为驳回报告，且未驳回给当前登录人，无权限撤销审核！");
		return;
	}
	//保存数据
	runClassMethod("web.DHCADVCOMMONPART","CancelAuditReport",{'params':CancelAuditList},
	function(jsonString){ 
		if(jsonString.ErrCode < 0){
			$.messager.alert("提示:","撤销审核错误,错误原因:"+"<font style='color:red;'>"+jsonString.ErrMsg+"</font>");   ///+"第"+errnum+"条数据"
			return;
		}
		if(jsonString.ErrCode == 0){
			SaveAsse(1);
		}
	},"json",false);
		
}

//时间 数字校验
function CheckTimeornum(){
	//时间输入校验
	//会议时间
	chktime("HeadnurMeetTime","HeadnurMeetDate");
	
}
//人员回车事件加载窗口
function StaffEnter()
{
	$('#staffwin').show();
	$('#staffwin').window({
		title:$g('科室人员信息'),
		collapsible:false,
		minimizable:false,
		maximizable:false,
		border:false,
		closed:"true",
		modal:true,
		width:500,
		height:400
	 }); 
    $('#staffwin').window('open');
    $("#UserNames").val("");
    InitStaffGrid() ;      
}

//初始化科室人员列表
function InitStaffGrid()
{
	//定义columns
	var columns=[[
	     {field:"ck",checkbox:'true',width:40},
		 {field:'userCode',title:$g('用户Code'),width:100},
		 {field:'userName',title:$g('用户姓名'),width:100}
		]];
	
	//定义datagrid
	$('#user').datagrid({
		url:'dhcadv.repaction.csp'+'?action=GetStaff&Input='+LgCtLocID,
		fit:true,
		border:false,
		rownumbers:true,
		columns:columns,
		pageSize:200,  // 每页显示的记录条数
		pageList:[200,400],   // 可以设置每页记录条数的列表
	    singleSelect:false,
		loadMsg: '正在加载信息...',
		pagination:true,
		selectOnCheck:true,
		onUnselect:function(rowIndex, rowData)
		{
			userName=$("#UserNames").val();
			var name =rowData.userName
             if(userName.indexOf(name) != -1)
             {
	             userName=userName.replace(name+"，","")
	             $("#UserNames").val(userName);
             }
		},
		 onSelect:function(rowIndex, rowData)
		 {
	       var userName = rowData.userName
	       MeetMember(userName)
		 },onLoadSuccess:function(data){  
			if(userName!=""){
				for(var i=0;i<data.rows.length;i++){
					var Name = data.rows[i].userName+"，";
					if(userName.indexOf(Name)>=0){
						$("#user").datagrid("selectRow",i);
					}
				}
			}
		}	
	});	
	$("#UserNames").val($("#HeadnurParticipants").val()); /// 给弹出的人员窗口里面人员赋值(表单的参会人员)
	$(".datagrid-header-check input[type=checkbox]").on("click",function(){ ///2018-04-13 cy 评价界面
		AllMember();
	})
}
function AllMember(){
	var rows = $("#user").datagrid('getSelections');
	if(rows.length==0){
		$("#UserNames").val("");
	}
	var userNames="";
	for(var i=0;i<rows.length;i++){
		if(userNames==""){
			userNames=rows[i].userName+"，";
		}else{
			userNames=userNames+rows[i].userName+"，";
		}
		
	}
	$("#UserNames").val(userNames);
	//MeetMember(userNames) ;
}
//查询
function QueryName()
{
	//1、清空datagrid 
	$('#user').datagrid('loadData', {total:0,rows:[]}); 
	//2、查询
	var UserName=$("#UserName").val();
	var params=UserName+"^"+LgCtLocID;
	$('#user').datagrid({
		url:'dhcadv.repaction.csp'+'?action=GetStaff',
		queryParams:{
		Input:params}	
	});
}

//添加到参会人员
function MemAdd()
{
  userName=$("#UserNames").val()
  $("#HeadnurParticipants").val(userName)	
  $('#staffwin').window('close');
}
//添加到晨会人员
function MonAdd()
{
  userName=$("#UserNames").val()
  $("#MornRepMeetpants").val(userName)	
  $('#staffwin').window('close');
}
//选择参会人员
function MeetMember(name)
{
	if(name==""){
	  $("#UserNames").val("");
	}
	userName=$("#UserNames").val();
    if(userName.indexOf(name) != -1){
	    return true;  
    }
	if(userName==""){
	  userName=name+"，";
	}else{
	  userName=userName+name+"，";
	}
	$("#UserNames").val(userName);		
}
