/// Description: 院外压疮护士长评价单评价界面 
/// Creator: wxj
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
	InitCheckRadio()
	CheckTimeornum();  //时间校验
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
	$("input[type=checkbox]").each(function(){
		$(this).click(function(){
			$(this).is(':checked');
			InitCheckRadio();
		});
	});
	//单选框按钮事件
	$("input[type=radio]").each(function(){
		$(this).click(function(){
			$(this).is(':checked');
			//setCheckBoxRelation(this.id);
			InitCheckRadio();
		});
	});
	// 会议日期控制
	chkdate("MeetDate","MeetTime");
	add_event();
	var EvaData=EvaFlagList.replace(/(^\s*)|(\s*$)/g,"").split("^");
	AssessFlag=EvaData[0];
	LocHeadNurEvaFlag=EvaData[1];
	NurDepEvaFlag=EvaData[2];
	if(EvaRecordId!="")	{
		// 添加按钮隐藏 
		$('#ParPantsAddBut').hide();
		//科室护理不良事件分析 不可编辑
		$("#HeadNurCauseAnalysis-panel input").attr("readonly",'readonly');
		$("#HeadNurCauseAnalysis-panel textarea").attr("readonly",'readonly');
		$("#MeetDate").datebox({"disabled":true});
		$("#CauseAnalysis-text").attr("readonly",'readonly');
		$("#HeadNurCauseAnalysis-panel input[type=checkbox]").attr("disabled",true);  
		//整改措施 不可编辑
		$("#Recmeasure-panel input").attr("readonly",'readonly');
		$("#CaseImprovement").attr("readonly",'readonly');
		$("#Recmeasure-panel input[type=checkbox]").attr("disabled",true); 
		//护士长评价 不可编辑
		$("#HeadNurEvaluate-panel input[type=radio]").attr("disabled",true); 
		$("#UlcNurImpMeasures-label-94932-94933").attr("readonly",'readonly');
		$("[id^='HeadNurEvaluate-94387-']").each(function(){
			var rowid=this.id.split(".")[0];
			var rownum=this.id.split(".")[1];
			if ((this.value!="")){
				$("[id^='"+rowid+"'][id$='"+rownum+"']").attr("readonly",'readonly');
				$("input[id^='"+rowid+"'][id$='"+rownum+"']").datebox({"disabled":true});
				$('a:contains('+$g("删除")+')').parent().hide();
			}
			if(AssessFlag!="Y"){
				$("[id^='"+rowid+"'][id$='"+rownum+"']").attr("readonly",'readonly');
				$("input[id^='"+rowid+"'][id$='"+rownum+"']").datebox({"disabled":true});
				$('a:contains('+$g("增加")+')').parent().hide();
			}
		})
		/* //护士长评价 督查日期 不可编辑
		 $("input[id^='HeadNurEvaluate-94387-94393-94398']").each(function(){
			if ((this.value!="")){
				var rowid=this.id.split(".")[0];
				var rownum=this.id.split(".")[1];
				$("input[id^='"+rowid+"'][id$='"+rownum+"']").datebox({"disabled":true});
			}
		})  */
	}
	//晨会人员 sufan 2019-06-18 表单统一去掉晨会部 
	/*$('#MornRepMeetpants').css({
		"width":800,
		"max-width":800
	});*/
	//参会人员 
	$('#Participants').css({
		"width":800,
		"max-width":800
	});
	RepSetRead("Participants","input",1);	
	//晨会内容 sufan 2019-06-18 表单统一去掉晨会部 
	/*$('#MornRepMeetContent').css({
		"width":800,
		"max-width":800
	});*/
	//名称
	$('#ManaImprovement-94378-94951').css({
		"width":300,
		"max-width":300
	});
	$("body").click(function(){
		AllStyle("textarea","",100);
  		InitLabInputText(".lable-input");
	})
	setTimeout(function(){ //延时点击body
        $("body").click();
    },500)	
	$(".lable-input").css('width','100px');
	$(".lable-input").css('max-width','100px');
}
//按钮控制与方法绑定
function InitButton(){
	$("#AsseSaveBut").on("click",function(){
		SaveAsse(0);
	})	
	/* //确认审批   ///2018-04-13 cy 按钮页面展现
	$('#FormAudit').on("click",function(){
		FormConfirmAudit();
	}) 
	//撤销审核  ///2018-04-13 cy 按钮页面展现
	$('#FormCancelAudit').on("click",function(){
		FormCancelAuditBt();
	}) 
	if(RepStaus!="填报"){  //护士长审核
		$("#FormAudit").hide(); //确认审批  2018-04-13 cy 评价界面
		$("#FormCancelAudit").show(); //撤销审核  2018-04-13 cy 评价界面
	}else{
		$("#FormAudit").show(); //确认审批  2018-04-13 cy 评价界面
		$("#FormCancelAudit").hide(); //撤销审核  2018-04-13 cy 评价界面
	} 
	//晨会人员 添加按钮事件
	$('#MorRepMeetAddBut').on("click",function(){
		StaffEnter();
	})  */
	
	//参会人员 添加按钮事件
	$('#ParPantsAddBut').on("click",function(){
		StaffEnter();
	})
	$('#Find').bind("click",QueryName);   //点击查询
   	$('#Add').bind("click",MemAdd);     //点击添加，将勾选的人员添加到输入框 参会人员
  	//$('#MonAdd').bind("click",MonAdd);  //点击添加，将勾选的人员添加到输入框 晨会人员 sufan 2019-06-18 表单统一去掉晨会部
}
//报告评价保存
function SaveAsse(flag)
{
	
	 ///保存前,对页面必填项进行检查
	if(!(checkRequired()&&checkother())){
		return;
	} 
	
	//alert("formId:"+formId+"par:"+loopStr("#from")+"recordId:"+EvaRecordId+"linkRecordId:"+LinkRecordId);
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
	
	//管理改进  ManaImprovement-94378-96091
	var ManaImprovementoth=0;
	$("input[type=checkbox][id^='ManaImprovement']").each(function(){
		if ($(this).is(':checked')){
			if((this.value=="title")&&($("input[name$='.96082'][class='lable-input']").val()=="")){
				ManaImprovementoth=-1;
			}
			if((this.value==$g("制度、流程及规范制定或修订"))){
				if(!($("#ManaImprovement-94378-94949").is(':checked'))&&!($("#ManaImprovement-94378-94950").is(':checked'))){
					ManaImprovementoth=-2;
				}
				if($("input[id='ManaImprovement-94378-94951']").val()==""){
					ManaImprovementoth=-2;
				}
			}
		}	
	})
	if(ManaImprovementoth==-2){
		$.messager.alert($g("提示:"),"【"+$g("管理改进")+"】"+$g("勾选")+$g('制度、流程及规范制定或修订')+"，"+$g("请勾选和填写内容")+"！");	
		return false;
	}
	if(ManaImprovementoth==-1){
		$.messager.alert($g("提示:"),"【"+$g("管理改进")+"】"+$g("勾选")+$g('其他')+"，"+$g("请填写内容")+"！");	
		return false;
	}
	
	//事件发生后整改措施落实效果 未落实 原因
	var UlcNurImpMeasures=0;   //id是以后面的字符串开头
	$("input[type=radio][id^='UlcNurImpMeasures-label-94932']").each(function(){
		if($(this).is(':checked')){
			if (($("#UlcNurImpMeasures-label-94932-94933").val()=="")){
				UlcNurImpMeasures=-1;
			}
		}
	})
	if(UlcNurImpMeasures==-1){
		$.messager.alert($g("提示:"),"【"+$g("院外压疮：护理措施落实效果")+"】"+$g("勾选")+$g('未落实')+"，"+$g("请填写内容")+"！");	
		return false;
	}
	

	return true;
}

function InitCheckRadio()
{
	//管理改进  制度、流程及规范制定或修订  名称  填写名称自动勾选制度、流程及规范制定或修订，取消勾选时，名称为空
	if($("input[type=checkbox][id='ManaImprovement-94378']").is(':checked')){
		$("#ManaImprovement-94378-94951").attr("readonly",false);
	}else{
		$("#ManaImprovement-94378-94951").val("");
		$("input[type=radio][id^='ManaImprovement-94378-']").removeAttr("checked");
	}
	$("#ManaImprovement-94378-94951").bind("blur",function(){
		if($("#ManaImprovement-94378-94951").val()!=""){
			$("input[type=checkbox][id='ManaImprovement-94378']").prop("checked",true) ;
		}
	})
	if($("input[type=radio][id^='ManaImprovement-94378-']").is(':checked')){
		$("input[type=checkbox][id='ManaImprovement-94378']").prop("checked",true) ;
	}
	//院外压疮：护理措施落实效果 未落实 原因
	$("input[type=radio][id^='UlcNurImpMeasures-label-']").each(function(){
		if ($(this).is(':checked')){
			var id=this.id;
			if (id=="UlcNurImpMeasures-label-94932"){
				$("#UlcNurImpMeasures-label-94932-94933").attr("readonly",false);
			}else{
				$("#UlcNurImpMeasures-label-94932-94933").val("");
			}
			if (id=="UlcNurImpMeasures-label-94932"){
				$("#UlcNurImpMeasures-label-94932-94933").attr("readonly",false);
				InitLabInputText("#UlcNurImpMeasures-label-94932-94933");
			}else{
				$("#UlcNurImpMeasures-label-94932-94933").val("");
				$("#UlcNurImpMeasures-label-94932-94933").unbind('click').on('click',function(){
				}); 
				
			}
		}
	})
	$("#UlcNurImpMeasures-label-94932-94933").bind('input propertychange ',function(){
		if($("#UlcNurImpMeasures-label-94932-94933").val()!=""){
			$("input[type=radio][id='UlcNurImpMeasures-label-94932']").prop("checked",true) ;
			InitLabInputText("#UlcNurImpMeasures-label-94932-94933");
		}
	})
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
			return;
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
	//晨会时间  sufan 2019-06-18 表单统一去掉晨会部分
	/*chktime("MornRepMeetTime");*/
	//会议时间
	chktime("MeetTime","MeetDate");
	
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
	$("#UserNames").val($("#Participants").val()); /// 给弹出的人员窗口里面人员赋值(表单的参会人员)
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
  $("#Participants").val(userName)	
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
function add_event(){
	AllStyle("textarea","",100);
	chkTableDate("HeadNurEvaluate-94387-94393-94398");
	//督查时间控制
	/*$("input[id^='HeadNurEvaluate-94387-94393-94398']").each(function(){
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
