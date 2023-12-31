/// Description: 不良事件升级 公共方法 保存提交，界面跳转
/// Creator: congyue
/// CreateDate: 2017-09-06
var url="dhcadv.repaction.csp";
var LgParam=LgUserID+"^"+LgCtLocID+"^"+LgGroupID+"^"+LgHospID;
var RepID="",formId="",recordId="",RepStaus="",RepTypeDr="",StatusLast="",RepTypeCode="",RepType="";
var EpisodeID="",patientID="",editFlag="",RepUser="";
var adrNextLoc="";adrLocAdvice="";adrReceive="";
var discover=""; //发现人
var bodywidth="",freshflag=0,TmpEpisodeID="";
var WinUserId="",WinLocId="",WinGroupId="";
var RepDate=formatDate(0); //系统的当前日期
document.write('<script type="text/javascript" src="../scripts/dhcadvEvt/cmcommon.js"></script>');
var AssWinRecId="",PatOutWinRecId="";// 2018-04-15 cy 护理评价界面id   2018-05-07 转归界面id
var RepStausDr="",StatusNextID="",FileFlag="",StsusGrant="",StatusLastID="",StaFistAuditUser="",winflag="",SubUserflag="",AuditList="",CancelAuditList="",UserLeadflag="",StatusNext="",RepAppAuditFlag="",RepLocDr="";
var AssessFlag="",LocHeadNurEvaFlag="",NurDepEvaFlag=""; ///评价按钮标识，科护士长评价按钮标识，护理部评价按钮标识
$(document).ready(function(){
  	RepID=getParam("RepID"); 			//报告ID   yangyongtao  2017-11-24
	formId=$("#formId").val();  		//表单id
	recordId=$("#recordId").val();  	//表单填写记录id
	RepStaus=getParam("RepStaus");  	//表单状态描述
	RepTypeDr=getParam("RepTypeDr");    //表单类型id
	editFlag=getParam("editFlag");
	RepTypeCode=getParam("code");  		//报告类型代码
	RepType=getParam("desc");  			//报告类型描述
	freshflag=getParam("freshflag");	//刷新标识
	TmpEpisodeID=getParam("TmpEpisodeID");  //选择的datagrid的就诊ID
	adrReceive=getParam("adrReceive");  //接收状态dr
	RepStausDr=getParam("RepStausDr");  //报告状态id
	StatusNextID=getParam("StatusNextID");  //报告下一状态id
	StatusNext=getParam("StatusNext");  //报告下一状态
	FileFlag=getParam("FileFlag");  	//归档标识
	StsusGrant=getParam("StsusGrant");  //审核标识
	StatusLastID=getParam("StatusLastID");  		//上一个状态id
	StaFistAuditUser=getParam("StaFistAuditUser");  //被驳回人
	winflag=getParam("winflag");  					//窗口标识  1 查询界面，  2 审核界面
	SubUserflag=getParam("SubUserflag");  			//转抄人标识
	UserLeadflag=getParam("UserLeadflag") 			//科护士长标识 1科护士长 0 非科护士长
	RepLocDr=getParam("RepLocDr");  				//表单上报科室 sufan 2019-06-24
	RepAppAuditFlag=getParam("RepAppAuditFlag") 	//待审批标识 1需要审批 0 不需要审批
	WinUserId=getParam("WinUserId");  				//登录人id
	RepUser=getParam("RepUser"); 					//填报人
	if((WinUserId!="")&&(WinUserId!=undefined)){
		LgUserID=WinUserId;
	}
	WinLocId=getParam("WinLocId");  				//登录科室id
	if((WinLocId!="")&&(WinLocId!=undefined)){
		LgCtLocID=WinLocId;
	}
	WinGroupId=getParam("WinGroupId");  //登录安全组id
	if((WinGroupId!="")&&(WinGroupId!=undefined)){
		LgGroupID=WinGroupId;
	}
	AuditList=RepID+"^"+StatusNextID+"^"+LgUserID+"^"+LgCtLocID+"^"+LgGroupID+"^"+""+"^"+""+"^"+adrReceive+"^"+RepTypeCode;
	CancelAuditList=RepID+"^"+StatusLastID+"^"+LgUserID+"^"+LgCtLocID+"^"+LgGroupID+"^"+""+"^"+""+"^"+adrReceive+"^"+RepTypeCode;
	bodywidth=$("body").width();
	//$('#PipeReason').parent().parent().hide();  元素隐藏，不占用位置
	ReportControlCom();		// 表单控制  	
	BtnControlCom();		//按钮控制与方法绑定
    CheckTimeorNumCom();	//时间与数据控制输入
	ReportEnter();			//报告回车事件
     //bindEnter(); //2018-05-28 cy 注释
    InitBasicInfoCom(RepID);	///加载报告基本信息
    discover=$('#RepUserName').val();
	if ((discover=="匿名")){
		$('#RepUserName-label').append('<div id="switch-out" class="open-out"style="margin-left:15px;margin-right:10px;display:inline-block;" onclick="ClickTabs()"><div style="color:#FFFFFF;padding:5px 0 0 2px;">匿名</div><div id="switch-in" class="open-in"></div></div>');
		$('#RepUserName').val("匿名");
	}else {
		
		$('#RepUserName-label').append('<div id="switch-out" class="close-out"style="margin-left:5px;margin-right:10px;display:inline-block;" onclick="ClickTabs()"><div style="color:#FFFFFF;padding:5px 0 0 2px;">匿名</div><div id="switch-in" class="close-in"></div></div>');
	}
	$('#RepUserName').css("margin-left","0px");
});
// 表单控制
function ReportControlCom(){
	if ((recordId=="")&&(freshflag==0)){
		var frm = dhcadvdhcsys_getmenuform();
	
		if (frm) {
	        var adm = frm.EpisodeID.value;
	       
		    EpisodeID=adm;
	        InitPatInfoCom(adm);//获取病人信息
		}
	}
	if(freshflag==1)
	{
		EpisodeID=TmpEpisodeID
		InitPatInfoCom(EpisodeID);//获取病人信息
	}
	// 入院时间控制
	chkdate("InOrOutHospDate");
	
	// 出院时间控制
	chkdate("LeavHospTime");
		
	// 入院/门诊科室
	chkcombobox("InOrOutHospLoc");
	
	// 报告日期控制
	chkdate("ReportDate");
	
	// 发生科室
	chkcombobox("OccuLoc");
		
	// 发生日期控制
	chkdate("OccurDate","OccurTime");
	
	// 发生日期 勾选自动补录 日期类型
	$('#OccurDate').datebox({
	    onChange: function(){
		    var date=$("#OccurDate").datebox("getValue");
	        var DateType=QueryDateType(date);//日期类型
			RepSetValue("DateType","input",DateType);
			RepSetRead("DateType","input",1);
	    }
	})
	
	//判断输入的病人ID是否为数字
	$('#PatNo').bind("blur",function(){
		var	PatNo=$('#PatNo').val();
		if(isNaN(PatNo)){
			$.messager.alert("提示:","请输入数字！");
			$('#PatNo').val("");
			return;
		}
	})
	//判断输入的病案号是否为数字
	$('#PatMedicalNo').bind("blur",function(){
		var	PatMedicalNo=$('#PatMedicalNo').val();	
		if(isNaN(PatMedicalNo)){
			$.messager.alert("提示:","请输入数字！");
			$('#PatMedicalNo').val("");
			return;
		}
	})
	$("body").click(function(){
		AllStyle("textarea","",100);
  		InitLabInputText(".lable-input");
	})
	setTimeout(function(){ //延时点击body
        $("body").click();
    },500)
    
    ConLevInjury();   ////控制等级和伤害严重程度级
    
    //控制联系电话  sufan 2019-11-07
    ///控制穿刺部位药物外渗情况
	$("#HospPhone").on('keyup',function(){
		if(isNaN($(this).val())){
			$.messager.alert("提示","请录入正确的电话号码！")
			$(this).val("");
		}
	})
}
//按钮控制与方法绑定
function BtnControlCom(){
	
	runClassMethod("web.DHCADVCOMMON","GetAssessAuthority",{'adrRepID':RepID,'params':LgUserID+"^"+LgCtLocID+"^"+LgGroupID+"^"+RepTypeCode},
		function(data){
			AssessFlag=data;
		},"text",false);
	runClassMethod("web.DHCADVCOMMON","GetEmSysConfig",{'AdvCode':"LOCHEADNUREVAFLAG",'Params':LgUserID+"^"+LgCtLocID+"^"+LgGroupID+"^"+LgHospID},
		function(data){
			LocHeadNurEvaFlag=data;
		},"text",false);
	runClassMethod("web.DHCADVCOMMON","GetEmSysConfig",{'AdvCode':"NURDEPEVAFLAG",'Params':LgUserID+"^"+LgCtLocID+"^"+LgGroupID+"^"+LgHospID},
		function(data){
			NurDepEvaFlag=data;
		},"text",false);
	if (RepStaus!=""){
		$("#SubmitBut").hide(); //隐藏提交按钮
		if(winflag==2){
			if(StsusGrant=="1"){
				//$("#RepAudit").hide(); //确认审批  2019-07-25
				$("#RepCancelAudit").show(); //撤销审核  2018-04-13 cy 评价界面
				if(StatusLastID==""){ //2018-01-17
					$('#RepCancelAudit').text(" 取消提交");
			    }else{
					$('#RepCancelAudit').text(" 取消审核");            
			    }
			}
			if(RepAppAuditFlag=="1"){
				$("#RepAudit").show(); //确认审批  2018-04-13 cy 评价界面
				//$("#RepCancelAudit").hide(); //撤销审核  2019-07-25
				$("#Back").show(); //驳回  2018-04-13 cy 评价界面 
			}
			if(AssessFlag=="Y"){
				$("#AssessmentBut").show(); //2019-01-22 评估按钮展现(医疗与没有原因分析的护理类型使用此评估)
			}
		}
		$('#AuditMessage').show(); //2018-06-12 cy 审批信息展现
		RepSetAudMessage();
	}
	if (editFlag==-1){
		$("#SaveBut").hide(); //隐藏保存按钮
		$("#Back").css("margin-left","400px"); //基本居中 hxy 2018-05-30
		$("#SubmitBut").hide(); //隐藏提交按钮
	}
	$("#assefooter").hide();  ///2018-04-13 cy 评价界面
	//弹出审批窗口   ///2018-05-30 cy 
	$('#RepAudit').on("click",function(){
		RepAudit();
	})
	//确认审批   ///2018-04-13 cy 按钮页面展现
	$('#RepConfirmAudit').on("click",function(){
		RepConfirmAudit();
	}) 
	//撤销审核  ///2018-04-13 cy 按钮页面展现
	$('#RepCancelAudit').on("click",function(){
		RepCancelAuditBt();
	}) 
	//驳回 ///2018-04-13 cy 按钮页面展现
	$('#Back').on("click",function(){
		RejectWin();
	}) 
	//报告驳回 ///2018-04-13 cy 按钮页面展现
	$('#Reject').on("click",function(){
		BackBt();
	}) 
	//转抄   ///2018-07-10 cy 按钮页面展现
	$('#Transcription').on("click",function(){
		Transcription();
	}) 
	$("#AssessmentBut").on("click",function(){
		assessmentRep();
	})

}
//时间与数据控制输入
function CheckTimeorNumCom(){
	//时间输入校验
	//报告时间
	chktime("ReportTime");
	//发生时间
	chktime("OccurTime","OccurDate");
	//数字输入校验  
	//当事人工作年限(年)
	chknum("PartyWorkYears",1);
	//填报人工作年限(年)
	chknum("RepUserWorkYears",1);
	//发现人工作年限(年)
	chknum("FindWorkYears",1);

}
//匿名开关
function ClickTabs(){
	var div2=document.getElementById("switch-in");
	var div1=document.getElementById("switch-out");
	div2.onclick=function(){
		if((RepUser!="")&&(RepUser!=LgUserName)){return false;}   //非本人不能修改 sufan 2019-11-07
		div1.className=(div1.className=="close-out")?"open-out":"close-out";
		div2.className=(div2.className=="close-in")?"open-in":"close-in";
           var discovers=((discover=="")||(discover=="匿名"))?LgUserName:discover;
           var discovers=(div1.className=="close-out")?discovers:"匿名";
		$('#RepUserName').val(discovers);
	}
         
}
//加载报表病人信息公共
function InitPatInfoCom(EpisodeID)
{
	if(EpisodeID==""){return;}
	runClassMethod("web.DHCADVCOMMON","GetPatInfoJson",{'PatNo':'','EpisodeID':EpisodeID},
	function(Data){ 
      	var AdmType=Data.AdmType;				// 患者来源
		RepSetValue("PatOrigin-label","radio",AdmType);
		RepSetRead("PatOrigin-label","radio",1);//患者来源
		var PatNo=Data.PatNo;					// 登记号
		RepSetValue("PatNo","input",PatNo);
		var MedicalNo=Data.MedicalNo;			// 病案号
		RepSetValue("PatMedicalNo","input",MedicalNo);
		var PatName=Data.PatName;				// 病人姓名
		RepSetValue("PatName","input",PatName);
		RepSetRead("PatName","input",1);
		var PatSex=Data.PatSex;  				// 性别
		RepSetValue("PatSexinput","input",PatSex);
		RepSetRead("PatSexinput","input",1);
		var PatAge=Data.PatAge;					// 年龄
		RepSetValue("PatAge","input",PatAge);
		RepSetRead("PatAge","input",1);		
      	var PatDOB=Data.Birthday;			// 出生日期
      	if(PatDOB!=""){
			RepSetRead("PatDOB","datebox",1);
			RepSetValue("PatDOB","datebox",PatDOB);
		}else {
			RepSetRead("PatDOB","datebox",0);
			RepSetValue("PatDOB","datebox","");
		}		
		var PatPhone=Data.PatTelH;					// 联系电话
      	if(PatPhone!=""){
			RepSetValue("PatPhone","input",PatPhone);
			RepSetRead("PatPhone","input",1);		
		}else {
			RepSetValue("PatPhone","input","");
			RepSetRead("PatPhone","input",0);		
		}		
      	var CurBedcode=Data.CurBedcode;			// 床位号 
      	if(CurBedcode!=""){
      		RepSetValue("AdmBedNum","input",CurBedcode);
      	}else {
      		RepSetValue("AdmBedNum","input","");
      	}
      	RepSetRead("AdmBedNum","input",1);
      	var AdmDoctor=Data.AdmDoctor;			// 主治医师
		if(AdmDoctor!=""){
      		RepSetValue("Physician","input",AdmDoctor);
      	}else {
      		RepSetValue("Physician","input","");
      	}
      	RepSetRead("Physician","input",1);
		var HospTimes=Data.InTimes; //住院次数
		if(HospTimes!=""){
    		RepSetValue("HospTimes","input",HospTimes);
			
		}else {
    		RepSetValue("HospTimes","input","");
		}
		RepSetRead("HospTimes","input",1);
		var AdmLoc=Data.AdmLoc;					// 入院/门诊科室
		RepSetRead("InOrOutHospLoc","combobox",1);
		if(AdmLoc!==""){
			RepSetValue("InOrOutHospLoc","combobox",AdmLoc);
		}else{
			RepSetValue("InOrOutHospLoc","combobox","");
		}
		// 入院日期
		RepSetRead("InOrOutHospDate","datebox",1);
		if(AdmType=="住院"){
			var AdminDate=Data.AdminDate;			
			if(AdminDate!=""){
				RepSetValue("InOrOutHospDate","datebox",AdminDate);
			}else{
				RepSetValue("InOrOutHospDate","datebox","");
			}
		}else if(AdmType=="门诊"){
			var AdmDate=Data.AdmDate;			// 就诊日期
			if(AdmDate!=""){
				RepSetValue("InOrOutHospDate","datebox",AdmDate);
			}else{
				RepSetValue("InOrOutHospDate","datebox","");
			}
		}else{
			RepSetValue("InOrOutHospDate","datebox","");
		}
      	var DischgDate=Data.DischgDate;			// 出院日期
		RepSetRead("LeavHospTime","datebox",1);
      	if(DischgDate!=""){
			RepSetValue("LeavHospTime","datebox",DischgDate);
		}else {
			RepSetValue("LeavHospTime","datebox","");
		}				
		var PatOccupation=Data.PatOccupation;	// 病人职别
		RepSetValue("AdmOfficeRank","combobox",PatOccupation);
		var PatBill=Data.PatBill;				// 医疗类别
		RepSetValue("MedicalCategory","combobox",PatBill);
		var PatDiag=Data.PatDiag;				// 诊断
		if(PatDiag!=""){
      		RepSetValue("PatDiag","input",PatDiag);
      	}else{
      		RepSetValue("PatDiag","input","");
      	}
      	RepSetRead("PatDiag","input",1);
      	var NurLevel=Data.NurLevel;				// 护理级别
		RepSetValue("NursingLev","radio",NurLevel);
	},"json",false);
}


function SaveReportCom(flag)
{
	///保存前,对页面必填项进行检查
	if(!checkRequired()){
		return;
	}
	var RepAuditList=""
	if (adrReceive==2){
		adrReceive=1;
	}
	//if((flag==1)&&(adrReceive!=2)){
	RepAuditList=LgUserID+"^"+LgCtLocID+"^"+LgGroupID+"^"+adrNextLoc+"^"+adrLocAdvice+"^"+adrReceive;
	//}
	//alert(adrReceive);
	//数据保存/提交
	var mesageShow=""
	if(flag==0){
		mesageShow="保存"
	}
	if(flag==1){		
		mesageShow="提交"		
	}
	if(LgCtLocID==""){
		$.messager.alert("提示:","数据保存失败，请重新登陆页面!");
		return ;	
	}
	$.messager.confirm("提示", "是否确认"+mesageShow+"数据", function (res) {//提示是否保存
		if (res) {
			var RepMaxNo="";
			if($("#EventNum").val()==""){
				runClassMethod("web.DHCADVCOMMONPART","GetAdrRepMaxNo",{'CurCode':'ADV','NoLen':4,'formId':""},
				function(val){ 
					RepMaxNo=val;
					RepSetRead("EventNum","input",0);
					RepSetValue("EventNum","input",RepMaxNo);
					RepSetRead("EventNum","input",1);
					
				},"text",false)
				if((RepMaxNo=="")||(RepMaxNo==-100)){
					$.messager.alert("提示:","出错!");
					return ;	
				}
			}
			runClassMethod("web.DHCADVCOMMONPART","SaveRepInfo",
			{
				'user':LgUserID,'formId':formId,
				'formVersion':$("#formVersion").val(),
				'par':loopStr("#from"),  //+"^"+loopStr("#popModalContent"),
				'recordId':recordId,
				'AuditList':RepAuditList,
				'locdr':LgCtLocID ,
				'EpisodeID':EpisodeID,
				'flag':flag},
				function(val){ 
					var data=val.replace(/(^\s*)|(\s*$)/g,"").split("^");
					if (data[0]=="0") {
						$.messager.alert("提示:",mesageShow+"成功!");
						RepID=data[1];
						recordId=data[2];
						RepTypeDr=data[3];
						InitBasicInfoCom(RepID);
						if(flag==1){		
							$("#SubmitBut").hide(); // 如果点击提交按钮，提交报告成功，隐藏提交按钮		
							//window.location.href='layoutform.csp?recordId='+recordID+'&RepStaus='+RepStaus+'&RepTypeDr='+RepTypeDr+'&code='+RepTypeCode+'&desc='+RepType+'&editFlag='+editFlag+'&RepID='+RepID;//刷新传参adrDataList为空
							//var iframe='<iframe scrolling="yes" width=100% height=100%  frameborder="0" src="layoutform.csp?recordId='+recordID+'&RepStaus='+RepStaus+'&RepTypeDr='+RepTypeDr+'&code='+RepTypeCode+'&desc='+RepType+'&editFlag='+editFlag+'&RepID='+RepID+'&adrReceive='+adrReceive+'"></iframe>';
						}
						if(editFlag==1){
							if((winflag!=2)||(flag!=0)){
								window.parent.CloseWinUpdate();
								window.parent.Query();
							}
						} 
					}else
					{
	  	 			if(val==-1){
							$.messager.alert("提示:","无权限");	
						}else if(val==-2){
							$.messager.alert("提示:","已是最后一个权限");	
						}else if(val==-3){
							$.messager.alert("提示:","无授权工作流");	
						}else if(val==-4){
							$.messager.alert("提示:","无配置子项");	
						}else{
							$.messager.alert("提示:","出错"+val);
						}
					}
				
				},"text",false)
			}
	});
}
//加载报表信息
function InitReportCom(recordId)
{
	if((recordId=="")||(recordId==undefined)){
		RepSetRead("OccuLoc","combobox",1);			// 发生科室
		RepSetValue("OccuLoc","combobox",LgCtLocDesc);			
		RepSetValue("RepHospType","input",LgHospDesc);		// 报告单位
		RepSetRead("RepHospType","input",1);
		RepSetValue("RepUserName","input",LgUserName);		// 填报人姓名为登录人
		RepSetRead("RepUserName","input",1);
		RepSetRead("ReportDate","datebox",1);
		RepSetValue("ReportDate","datebox",RepDate);		// 报告日期
		RepSetRead("ReportTime","input",1);		// 报告时间
		RepSetRead("PatName","input",1);		// 患者姓名
	}else{
		//病人信息
		//RepSetRead("PatNo","input",1);							// 登记号
		//RepSetRead("PatMedicalNo","input",1);						// 病案号
		RepSetRead("PatOrigin-label","radio",1);					// 患者来源
		RepSetRead("PatName","input",1);							// 病人姓名
		RepSetRead("PatSexinput","input",1);						// 性别
		RepSetRead("PatAge","input",1);								// 年龄
		RepSetRead("PatDOB","datebox",1);							// 出生日期
		RepSetValue("PatDOB","datebox",$('#PatDOB').datebox('getValue'));
		RepSetRead("AdmBedNum","input",1);							// 床位号 
		RepSetRead("Physician","input",1);							// 主治医师
		RepSetRead("HospTimes","input",1);							// 住院次数
		if($('#InOrOutHospLoc').combobox('getValue')!=""){
			RepSetRead("InOrOutHospLoc","combobox",1);
			RepSetValue("InOrOutHospLoc","combobox",$('#InOrOutHospLoc').combobox('getValue')); 	// 入院/门诊科室
		}
		if($('#InOrOutHospDate').datebox('getValue')!=""){
			RepSetRead("InOrOutHospDate","datebox",1);						
			RepSetValue("InOrOutHospDate","datebox",$('#InOrOutHospDate').datebox('getValue'));		// 入院日期
		}
		if($('#LeavHospTime').datebox('getValue')!=""){
			RepSetRead("LeavHospTime","datebox",1);						
			RepSetValue("LeavHospTime","datebox",$('#LeavHospTime').datebox('getValue'));			// 出院日期
		}
		RepSetRead("PatDiag","input",1);							// 疾病名称
		RepSetRead("ReportDate","datebox",1);						// 报告日期
		RepSetValue("ReportDate","datebox",$('#ReportDate').datebox('getValue'));
		RepSetRead("ReportTime","input",1);		// 报告时间		// 报告日期
		RepSetRead("OccuLoc","combobox",1);
		RepSetValue("OccuLoc","combobox",$('#OccuLoc').combobox('getValue')); 				// 发生科室
		RepSetRead("RepUserName","input",1);						// 填报人姓名为登录人
		RepSetRead("RepHospType","input",1);						// 报告单位
	}
	RepSetRead("EventNum","input",1);								// 事件编号不可编辑
	if(RepStaus==""){								// 事件编号不可编辑
		RepSetValue("ReportCardSta","input","未提交"); //报告卡状态
		RepSetRead("ReportCardSta","input",1);							// 报告卡状态不可编辑	
	}
}

//congyue 2017-09-06 点击首页图标，返回首页
function Gologin(){
	location.href='dhcadv.homepage.csp';
}
//congyue 2017-09-06 点击侧菜单跳转页面(点击首页填报类型跳转页面)
function InterfaceJump(code,desc){
	if (code=="index"){
		Gologin();
	}else{
		var Rel='dhcadv.layoutform.csp?code='+code+'&desc='+desc;
		location.href=Rel;
	}
}

//编辑窗体  专家评估界面
function assessmentRep()
{
	if($('#assessmentwin').is(":visible")){return;}  //窗体处在打开状态,退出
	$('body').append('<div id="assessmentwin"></div>');
	$('#assessmentwin').window({
		title:'报告评估',
		collapsible:false,
		minimizable:false,
		maximizable:false,
		border:false,
		closed:"true",
		modal:true,
		width:screen.availWidth-300,    ///2017-11-23  cy  修改弹出窗体大小 1250
		height:screen.availHeight-150,
		top:$('body').scrollTop()+(50/8)
	});
	var iframe='<iframe scrolling="yes" width=100% height=100%  frameborder="0" src="dhcadv.newrepmanage.csp?RepID='+RepID+'&RepTypeDr='+RepTypeDr+'&RepType='+RepType+'"></iframe>';
	$('#assessmentwin').html(iframe);
	$('#assessmentwin').window('open');
	ConWinSroll("assessmentwin");
}
function closeRepWindow(assessID)   //wangxuejian 2016-10-09      关闭评估窗口
{   
	//2017-06-12 报告已评估，不可修改
	if(assessID!=""){
		$("#SaveBut").hide();
		$("#Back").css("margin-left","400px"); //基本居中 hxy 2018-05-30
		$("#SubmitBut").hide();
	}
	$('#assessmentwin').window('close');
}
///2017-11-13 congyue  添加获取病人菜单信息方法
function dhcadvdhcsys_getmenuform(){
	var frm = null;
	try{
		var win=top.frames['eprmenu'];
		if (win) {
			frm = win.document.forms['fEPRMENU'];
			if(frm) return frm;
		}
		//在新窗口打开的界面
		win = opener;
		if (win) {
			frm = win.document.forms['fEPRMENU'];
			if (frm) return frm;
		}
		win = parent.frames[0];
		if (win){
			frm = win.document.forms["fEPRMENU"];
			if (frm) return frm;
		}
		if (top){
			frm =top.document.forms["fEPRMENU"];
			if(frm) return frm
		}
	}catch(e){}
	return frm;
}
//登记号自动补0
function getRegNo(regno)
{
	//return regno;
	var len=regno.length;
	var  reglen=10
	var zerolen=reglen-len
	var zero=""
	for (var i=1;i<=zerolen;i++)
	{zero=zero+"0" ;
		}
	return zero+regno ;
}
//通过住院号（病案号）、登记号 获取病人基本信息
function ReportEnter(){
	var patientNO="",actiontype="",PatOrigin="",PatOrigintype="";
	$('#PatMedicalNo').bind('keydown',function(event){
		if(event.keyCode == "13")    
		{
			patientNO=$('#PatMedicalNo').val();
			if (patientNO=="")
			{
				$.messager.alert("提示:","病案号不能为空！");
				return false;
			}
			if($("#admnogrid").length>0)
			{
			   $("#admnogrid").remove(); 
			   $("#admdsgrid").remove(); 
			}
			GetGridWin(patientNO,"PatMedicalNo","GetAdmList","admgrid");
		}
	});
	$('#PatNo').bind('keydown',function(event){
		if(event.keyCode == "13")    
		{
			patientNO=$('#PatNo').val();
			if (patientNO=="")
			{
				$.messager.alert("提示:","登记号不能为空！");
				return false;
			}
			patientNO=getRegNo(patientNO); //登记号补0
			if($("#admgrid").length>0)
			{
			   $("#admgrid").remove(); 
			   $("#admdsgrid").remove(); 
			}
			GetGridWin(patientNO,"PatNo","GetAdmDs","admnogrid");
		}
	});
	/* $('#PatID').bind('keydown',function(event){
		if(event.keyCode == "13")    
		{
			patientNO=$('#PatID').val();
			if (patientNO=="")
			{
				$.messager.alert("提示:","登记号不能为空！");
				return false;
			}
			patientNO=getRegNo(patientNO); //登记号补0
			if($("#admgrid").length>0)
			{
			   $("#admgrid").remove(); 
			   $("#admdsgrid").remove(); 
			}
			GetGridWin(patientNO,"PatID","GetAdmDs","admnogrid");
		}
	}); */
}
//通过住院号（病案号）、登记号 获取病人基本信息
function GetGridWin(patientNO,id,actiontype,tableid){
	var input=input+'&StkGrpRowId=&StkGrpType=G&Locdr=&NotUseFlag=N&QtyFlag=0&HospID=' ;
	var mycols = [[
		{field:'RegNo',title:'病人id',width:80},
		{field:'AdmTypeDesc',title:'就诊类型',width:60}, 
		{field:'AdmLoc',title:'就诊科室',width:120}, 
		{field:'AdmDate',title:'就诊日期',width:80},
		{field:'AdmTime',title:'就诊时间',width:70},
		{field:'Adm',title:'Adm',width:60,hidden:true} 
	]];
	var mydgs = {
		url:'dhcadv.repaction.csp'+'?action='+actiontype+'&Input='+patientNO+'&Type='+"" ,
		columns: mycols,  //列信息
		nowrap:false,
		pagesize:10,  //一页显示记录数
		table: '#admdsgrid', //grid ID
		field:'Adm', //记录唯一标识
		params:null,  // 请求字段,空为null
		tbar:null //上工具栏,空为null
	}
	var win=new CreatMyDiv(input,$("#"+id),tableid,"460px","335px","admdsgrid",mycols,mydgs,"","",SetAdmIdTxtVal);	
	win.init();
}
//获取病案号/登记号选择记录数据
function SetAdmIdTxtVal(rowData)
{
	if((rowData.Adm!=undefined)&&(EpisodeID!="")&&(rowData.Adm!=EpisodeID)){   //sufan 就诊ID变了后，处理列表问题
		$.messager.confirm("提示", "信息未保存,是否继续操作", function (res) {//提示是否删除
			if (res) {
				freshflag=1
				EpisodeID=rowData.Adm==undefined?"":rowData.Adm;
				location.href='dhcadv.layoutform.csp?code='+RepTypeCode+'&freshflag='+freshflag+'&TmpEpisodeID='+EpisodeID;
				/* EpisodeID=rowData.Adm==undefined?EpisodeID:rowData.Adm;   //sufan 2019-11-12 解决已经选择了患者，再手动关闭登记号窗口会给原来的就诊id赋为""
				if(EpisodeID==undefined){
					EpisodeID="";
				}
				InitPatInfoCom(EpisodeID);	 */
			}else{
				InitPatInfoCom(EpisodeID);
				return false;
			}
		})
	}else{
		EpisodeID=rowData.Adm==undefined?EpisodeID:rowData.Adm;
		InitPatInfoCom(EpisodeID);
	}
}
function bindEnter(){
	var suspectWin='<div id="mwin">';
	    suspectWin+='<div class="easyui-layout" fit="true">';
	    suspectWin+='<div region="north"  style="width:100%;height:30px">'
	    suspectWin+='<div id="dlg-buttons">';
        suspectWin+='<table cellpadding="0" cellspacing="0" style="width:100%">'
		suspectWin+='<tr>'
		suspectWin+='<td style="text-align:left">'		
		suspectWin+='<button  id="addDrg" class="dhcc-btn" style="margin-left:5px;margin-top:1px"">添加</button>';
		suspectWin+='<button  class="dhcc-btn" style="margin-left:5px;margin-top:1px" onclick="clsDrgWin()">取消</button>';	
		suspectWin+='</td>'			
		suspectWin+='</tr>'		
		suspectWin+='</table>'	
		suspectWin+='</div>'
		suspectWin+='</div>'
		suspectWin+='<div region="center" style="width:100%;height:430px">';
		suspectWin+='<div id="medInfo"></div>';
		suspectWin+='</div>';
		suspectWin+='</div>';
	    suspectWin+='</div>';
	$('body').append(suspectWin);
	var height=510,width=1000; //hxy 2018-01-22 
	var top=Math.round((window.screen.height-height)/2); 
    var left=Math.round((window.screen.width-width)/2);  
	$('#mwin').window({
		title:'用药列表',
		collapsible:false,
		collapsed:false, 
		border:false,
		closed:"true",
		minimizable: false, 
		maximizable: false,
		width:1000,
		height:510,
		top:top,
		left:left,
		resizable:false
	});	
   
	$("input[id^='SuspectNewDrug-']").live('keydown',function(event){	
		 if(event.keyCode == "13")    
		 {
		   if(EpisodeID==""){
			   $.messager.alert('Warning','请先选择患者就诊记录！');
			   return;
			   }
		   drgname=$(this).attr("name")
           showDrugListWin();
        }
    });
    $("input[id^='BlendNewDrug-']").live('keydown',function(event){	
		 if(event.keyCode == "13")    
		 {
		   if(EpisodeID==""){
			   $.messager.alert('Warning','请先选择患者就诊记录！');
			   return;
			 }
		   drgname=$(this).attr("name")
           showDrugListWin();
        }
    });
	}
function showDrugListWin(){
	InitPatMedGrid();
	$('#mwin').window('open');
	//点增加按钮
	$("#addDrg").click(function(){
		addDrg()
		});
	}
	
	
//初始化病人用药列表
function InitPatMedGrid()
{
	//定义columns
	var columns=[[
		{field:"orditm",title:'orditm',width:90,hidden:true},
		{field:'phcdf',title:'phcdf',width:80,hidden:true},
		{field:'incidesc',title:'名称',width:140},
		{field:'genenic',title:'通用名',width:140},
	    {field:'batno',title:'生产批号',width:60,hidden:true},
	    {field:'staDate',title:'开始日期',width:60,hidden:true},
	    {field:'endDate',title:'结束日期',width:60,hidden:true},
		{field:'genenicdr',title:'genenicdr',width:80,hidden:true},
		{field:'dosage',title:'剂量',width:60},
		{field:'dosuomID',title:'dosuomID',width:80,hidden:true},
		{field:'instru',title:'用法',width:80},
		{field:'instrudr',title:'instrudr',width:80,hidden:true},
		{field:'freq',title:'频次',width:40},//priorty
		{field:'priorty',title:'优先级',width:60},//priorty
		{field:'freqdr',title:'freqdr',width:80,hidden:true},
		{field:'duration',title:'疗程',width:40},
		{field:'durId',title:'durId',width:80,hidden:true},
		{field:'apprdocu',title:'批准文号',width:140},
		{field:'manf',title:'厂家',width:140},
		{field:'manfdr',title:'manfdr',width:80,hidden:true},
		{field:'form',title:'剂型',width:80},
		{field:'formdr',title:'formdr',width:80,hidden:true}
	]];
	
	//定义datagrid
	$('#medInfo').datagrid({
		url:'',
        fit:true,
		border:false,
		rownumbers:false,
		columns:columns,
		pageSize:15,  // 每页显示的记录条数
		pageList:[15,30,45],   // 可以设置每页记录条数的列表
	    singleSelect:true,
		loadMsg: '正在加载信息...',
		pagination:true
	});
	$('#medInfo').datagrid({
		url:'dhcadv.repaction.csp'+'?action=GetPatOEInfo',	
		queryParams:{
			params:EpisodeID}
	});
	
	$('#medInfo').datagrid('reload'); //重新加载
}

//关闭病人用药窗口
function clsDrgWin()
{
	$('#mwin').window('close');
}

//添加药品
function addDrg()
{   
       var row = $('#medInfo').datagrid('getSelected');
	   if(row==""){	
	    $.messager.alert("warning","请选择待添加药品！");
		return;
	    }
	  clsDrgWin();
      var $td =$("input[name='"+drgname+"'][type=input]").parent().parent().children('td');
      $td.eq(0).find("input").val(row.apprdocu);
      $td.eq(1).find("input").val(row.incidesc);
      $td.eq(2).find("input").val(row.genenic+"/["+row.form+"]");
      $td.eq(3).find("input").val(row.manf) 
      $td.eq(5).find("input").val(row.dosage+"/"+row.instru+"/"+row.freq);
      $td.eq(6).find("input").datebox("setValue",row.staDate); 
      $td.eq(7).find("input").datebox("setValue",row.endDate); 
  
}

function GetAssessRecordID(AssWinCode){
	var AssWinRecId="";
	runClassMethod("web.DHCADVCOMMONPART","GetRecordId",
		{'LinkRecordId':recordId,
		 'FormCode':AssWinCode},
		function(data){ 
			 AssWinRecId=data
	},"text",false) 
	return AssWinRecId;
}
//编辑窗体  2018-04-13 cy 评价界面
function showAssessmentWin(AssWinCode,AssWinRecId)
{
	if($('#assewin').is(":visible")){return;}  //窗体处在打开状态,退出

	$('body').append('<div id="assewin"></div>');
	$('#assewin').window({
		title:LgGroupDesc+'评价',
		collapsible:false,
		minimizable:false,
		maximizable:false,
		border:false,
		closed:"true",
		modal:true,
		width:screen.availWidth-150,    ///2017-11-23  cy  修改弹出窗体大小 1250
		height:screen.availHeight-150,
		top:$('body').scrollTop()+(50/8)
	});
	
	var iframe='<iframe scrolling="yes" width=100% height=100%  frameborder="0" src="dhcadv.layoutform.csp?recordId='+AssWinRecId+'&code='+AssWinCode+'&LinkRecordId='+recordId+'&AuditList='+AuditList+'&CancelAuditList='+CancelAuditList+'&StaFistAuditUser='+StaFistAuditUser+'&StsusGrant='+StsusGrant+'&RepStaus='+RepStaus+'"></iframe>'; 
	$('#assewin').html(iframe);
	$('#assewin').window('open');
	ConWinSroll("assewin");
}
//编辑窗体  2018-05-07 cy 转归界面
function showPatOutcomWin(PatOutWinCode)
{
	if($('#patoutwin').is(":visible")){return;}  //窗体处在打开状态,退出

	$('body').append('<div id="patoutwin"></div>');
	$('#patoutwin').window({
		title:'患者转归',
		collapsible:false,
		minimizable:false,
		maximizable:false,
		border:false,
		closed:"true",
		modal:true,
		width:800,    ///2017-11-23  cy  修改弹出窗体大小 1250
		height:400,
		top:$('body').scrollTop()+((screen.availHeight-400)/4)
	});
	 runClassMethod("web.DHCADVCOMMONPART","GetRecordId",
		{'LinkRecordId':recordId,
		 'FormCode':PatOutWinCode},
		function(data){ 
			 PatOutWinRecId=data
	},"text",false) 
	var iframe='<iframe scrolling="yes" width=100% height=100%  frameborder="0" src="dhcadv.layoutform.csp?recordId='+PatOutWinRecId+'&code='+PatOutWinCode+'&LinkRecordId='+recordId+'&RepID='+RepID+'"></iframe>'; 
	$('#patoutwin').html(iframe);
	$('#patoutwin').window('open');
	ConWinSroll("patoutwin");
}
//处理未定义的变量
function $g(param){
	return param==undefined?"":	param;
}
//radio和checkbox数据获取
function radioValue(param,data){
	//alert(param);
	var ret=[]
	
	if(param==="") return "";
	paramArray = param.split(",");
	
	for(var i =0;i<paramArray.length;i++){
		if($g(data[paramArray[i]])!=""){
			ret.push($g(data[paramArray[i]]));
		}
	}
	
	return ret.join("； ");
}

//radio和checkbox数据获取  带有子元素拼串
function checksubValue(data,param,subdata){
	//alert(param);
	var ret=[]
	if(param==="") return "";
	paramArray = param.split(",");
	for(var i =0;i<paramArray.length;i++){
		if($g(subdata[paramArray[i]])!=""){
			ret.push($g(subdata[paramArray[i]]));
		}
	}
	if (ret.join("； ")!=""){
		data=data+"（"+ret.join("； ")+"）";
	}
	return data;
}
function myRadioValue(param,data){
	var ret = radioValue(param,data);
	if(ret===""){
		ret="无";
	}
	return ret;
}
//表单界面 科护士长评价赋值
function SetLocHeaNurInfo(data){
	var List="";
	var MeetDate=$g(data["MeetDate"]); //会议日期
	if(MeetDate!=""){List=List+"\n会议日期："+MeetDate+"；";}
	var MeetTime=$g(data["MeetTime"]); //会议时间
	if(MeetTime!=""){List=List+"会议时间："+MeetTime+"；";}
	var MeetPlace=$g(data["MeetPlace"]); //会议地点
	if(MeetPlace!=""){List=List+"会议地点："+MeetPlace+"；";}
	var Participants=$g(data["Participants"]); //参会人员
	if(Participants!=""){List=List+"参会人员："+Participants+"；";}
	//案例管理评价 
	var LocCaseTimeliness=radioValue("LocCaseTimeliness-94432,LocCaseTimeliness-94433",data); 
	if(LocCaseTimeliness!=""){List=List+"\n科室案例分析及时性："+LocCaseTimeliness+"。";}
	var FindReason=radioValue("FindReason-94434,FindReason-94435",data); 
	if(FindReason!=""){List=List+"\n原因分析找到真因："+FindReason+"。";}
	var BefPreventMeasures=radioValue("BefPreventMeasures-94436,BefPreventMeasures-94437",data); 
	if(BefPreventMeasures!=""){List=List+"\n发生前防范措施落实情况："+BefPreventMeasures+"。";}
	var BefPreventMeasuresipt=$g(data["BefPreventMeasures-94439"]);  //具体表现
	if ((BefPreventMeasuresipt!="")&&(BefPreventMeasures=="")){
		List=List+"\n发生前防范措施落实情况：未落实具体表现："+BefPreventMeasuresipt+"。";
	}
	if ((BefPreventMeasuresipt!="")&&(BefPreventMeasures!="")){
		List=List+"未落实具体表现："+BefPreventMeasuresipt+"。";
	}
	var BefPreMeaReason=radioValue("BefPreMeaReason-94441,BefPreMeaReason-94442,BefPreMeaReason-94443,BefPreMeaReason-94444,BefPreMeaReason-94445,BefPreMeaReason-94446,BefPreMeaReason-94447,BefPreMeaReason-94448",data); 
	if(BefPreMeaReason!=""){List=List+"\n发生前防范措施未落实的原因：具体表现："+BefPreMeaReason+"。";}
	var AftImpPertinence=radioValue("AftImpPertinence-94449,AftImpPertinence-94450",data); 
	if(AftImpPertinence!=""){List=List+"\n事件发生后整改措施的针对性："+AftImpPertinence+"。";}
	var AftImpTimeliness=radioValue("AftImpTimeliness-94451,AftImpTimeliness-94452",data); 
	if(AftImpTimeliness!=""){List=List+"\n事件发生后整改措施落实的及时性："+AftImpTimeliness+"。";}
	var HeadNurReformMark=radioValue("HeadNurReformMark-94453,HeadNurReformMark-94454",data); 
	if(HeadNurReformMark!=""){List=List+"\n护士长整改落实的痕迹："+HeadNurReformMark+"。";}
	var ManaIfStandard=radioValue("ManaIfStandard-94455,ManaIfStandard-94456",data); 
	if(ManaIfStandard!=""){List=List+"\n护理记录书写："+ManaIfStandard+"。";}
	var LocHeadView=$g(data["LocHeadView"]);  //大科意见
	if(LocHeadView!=""){List=List+"\n大科意见："+LocHeadView+"。";}

	// 现场工作评价
	var ListLocaleEvaluate=""                           //现场评价字体加粗
	var LocHeadNurEvaluate=$g(data["LocHeadNurEvaluate"]);
	var LocHeadNurEvaluatelen=LocHeadNurEvaluate.length; //科护士长评价个数
	var LocHeadNurEvaluateList="科护士长效果评价：";
	for(var k=0;k<LocHeadNurEvaluatelen;k++){
		var LHNElist="\n<font style='font-Weight:bold;'>记录"+(k+1)+"</font>："
		//var LHNElist="\n记录"+(k+1)+"："
		var LHNEdate=$g(LocHeadNurEvaluate[k]["LocHeadNurEvaluate-94416-94422-94427"]); //督查时间
		if(LHNEdate!=""){LHNElist=LHNElist+"督查时间："+LHNEdate+"。";}
		var LHNEobject=$g(LocHeadNurEvaluate[k]["LocHeadNurEvaluate-94416-94423-94428"]); //督查对象
		if(LHNEobject!=""){LHNElist=LHNElist+"督查对象："+LHNEobject+"。";}
		var LHNEcontent=$g(LocHeadNurEvaluate[k]["LocHeadNurEvaluate-94416-94424-94429"]); //督查内容
		if(LHNEcontent!=""){LHNElist=LHNElist+"督查内容："+LHNEcontent+"。";}		
		var LHNEresult=$g(LocHeadNurEvaluate[k]["LocHeadNurEvaluate-94416-94425-94430"]); //督查结果
		if(LHNEresult!=""){LHNElist=LHNElist+"督查结果："+LHNEresult+"。";}		
		var LHNEpeople=$g(LocHeadNurEvaluate[k]["LocHeadNurEvaluate-94416-94425-94431"]); //督查人
		if(LHNEpeople!=""){LHNElist=LHNElist+"督查人："+LHNEpeople+"。";}		
		LocHeadNurEvaluateList=LocHeadNurEvaluateList+LHNElist
	}
	if(LocHeadNurEvaluateList!=""){ListLocaleEvaluate=ListLocaleEvaluate+LocHeadNurEvaluateList;}
	var LHNrow=0
	var LHNList=List.split("\n")
	var LHNlen=LHNList.length;
	for(i=0;i<LHNlen;i++){
		LHNrow=LHNrow+parseInt(LHNList[i].length/60)+1;
	}
	//var HNrow=parseInt(HeadNurEvaList.length/60);
	var LHNheightlen=(LHNrow+LocHeadNurEvaluatelen)*18;
	$("#LocHeadNurEvale").css({
		"height":LHNheightlen
	});	
	$('#LocHeadNurEvale').val(List);
	$('#LocHeadNurEvale').append('<div id="LocaleEvaluate"></div>');  
	$('#LocaleEvaluate').html(ListLocaleEvaluate);
}

//表单界面 护理部评价赋值
function SetNurDepInfo(data){
	var List="";
	var MeetDate=$g(data["MeetDate"]); //会议日期
	if(MeetDate!=""){List=List+"\n会议日期："+MeetDate+"；";}
	var MeetTime=$g(data["MeetTime"]); //会议时间
	if(MeetTime!=""){List=List+"会议时间："+MeetTime+"；";}
	var MeetPlace=$g(data["MeetPlace"]); //会议地点
	if(MeetPlace!=""){List=List+"会议地点："+MeetPlace+"；";}
	var Participants=$g(data["Participants"]); //参会人员
	if(Participants!=""){List=List+"参会人员："+Participants+"；";}
	//案例管理评价 
	
	var RepLevel=radioValue("RepLevel-94496,RepLevel-94498,RepLevel-94499,RepLevel-94500,RepLevel-94501,RepLevel-94502",data); 
	if(RepLevel!=""){List=List+"\n护理不良事件级别："+RepLevel+"。";}
	var MLocCaseTimeliness=radioValue("MLocCaseTimeliness-94503,MLocCaseTimeliness-94504",data); 
	if(MLocCaseTimeliness!=""){List=List+"\n科室案例分析及时性："+MLocCaseTimeliness+"。";}
	var HadeLocCaseTimeliness=radioValue("HadeLocCaseTimeliness-94505,HadeLocCaseTimeliness-94506",data); 
	if(HadeLocCaseTimeliness!=""){List=List+"\n大科室案例分析："+HadeLocCaseTimeliness+"。";}
	var FindReason=radioValue("FindReason-94434,FindReason-94435",data); 
	if(FindReason!=""){List=List+"\n原因分析找到真因："+FindReason+"。";}
	var BefPreventMeasures=radioValue("BefPreventMeasures-94436,BefPreventMeasures-94437",data); 
	if(BefPreventMeasures!=""){List=List+"\n发生前防范措施落实情况："+BefPreventMeasures+"。";}
	var BefPreventMeasuresipt=$g(data["BefPreventMeasures-94439"]);  //具体表现
	if ((BefPreventMeasuresipt!="")&&(BefPreventMeasures=="")){
		List=List+"\n发生前防范措施落实情况：未落实具体表现："+BefPreventMeasuresipt+"。";
	}
	if ((BefPreventMeasuresipt!="")&&(BefPreventMeasures!="")){
		List=List+"未落实具体表现："+BefPreventMeasuresipt+"。";
	}
	var BefPreMeaReason=radioValue("BefPreMeaReason-94441,BefPreMeaReason-94442,BefPreMeaReason-94443,BefPreMeaReason-94444,BefPreMeaReason-94445,BefPreMeaReason-94446,BefPreMeaReason-94447,BefPreMeaReason-94448",data); 
	if(BefPreMeaReason!=""){List=List+"\n发生前防范措施未落实的原因：具体表现："+BefPreMeaReason+"。";}
	var AftImpPertinence=radioValue("AftImpPertinence-94449,AftImpPertinence-94450",data); 
	if(AftImpPertinence!=""){List=List+"\n事件发生后整改措施的针对性："+AftImpPertinence+"。";}
	var AftImpTimeliness=radioValue("AftImpTimeliness-94451,AftImpTimeliness-94452",data); 
	if(AftImpTimeliness!=""){List=List+"\n事件发生后整改措施落实的及时性："+AftImpTimeliness+"。";}
	var HeadNurReformMark=radioValue("HeadNurReformMark-94453,HeadNurReformMark-94454",data); 
	if(HeadNurReformMark!=""){List=List+"\n护士长整改落实的痕迹："+HeadNurReformMark+"。";}
	var LocHeadNurReformMark=radioValue("LocHeadNurReformMark-94507,LocHeadNurReformMark-94508",data); 
	if(LocHeadNurReformMark!=""){List=List+"\n科护士长效果评价痕迹："+LocHeadNurReformMark+"。";}
	var ManaIfStandard=radioValue("ManaIfStandard-94455,ManaIfStandard-94456",data); 
	if(ManaIfStandard!=""){List=List+"\n护理记录书写："+ManaIfStandard+"。";}
	
	//事件定性与考评
	var InSkiUlcQualita=radioValue("InSkiUlcQualita-94509,InSkiUlcQualita-94510",data); 
	if(InSkiUlcQualita!=""){List=List+"\n院内压疮事件定性："+InSkiUlcQualita+"。";}
	var DrugErrQualita=radioValue("DrugErrQualita-94511,DrugErrQualita-94512,DrugErrQualita-94513,DrugErrQualita-94514",data); 
	if(DrugErrQualita!=""){List=List+"\n给药缺陷事件定性："+DrugErrQualita+"。";}
	var OthQualita=radioValue("OthQualita-94515,OthQualita-94516",data); 
	if(OthQualita!=""){List=List+"\n其它事件定性："+OthQualita+"。";}
	var OverEvaluation=radioValue("OverEvaluation-94517,OverEvaluation-94518,OverEvaluation-94519",data); 
	if(OverEvaluation!=""){List=List+"\n总体评价："+OverEvaluation+"。";}
	var NextStep=radioValue("NextStep-94520,NextStep-94521,NextStep-94522",data); 
	if(NextStep!=""){List=List+"\n下一步要求："+NextStep+"。";}
	var NurDepAdvice=$g(data["NurDepAdvice"]);  //护理部意见
	if(NurDepAdvice!=""){List=List+"\n护理部意见："+NurDepAdvice+"。";}

	// 护理部追踪记录
	var ListTraRecord=""                           //追踪记录字体加粗
	var NurDepRecord=$g(data["NurDepRecord"]);
	var NurDepRecordlen=NurDepRecord.length; //科护士长评价个数
	var NurDepRecordList="护理部追踪记录：";
	for(var k=0;k<NurDepRecordlen;k++){
	//	var NDRlist="\n记录"+(k+1)+"："
		var NDRlist="\n<font style='font-Weight:bold;'>记录"+(k+1)+"</font>：" 
		var NDRdate=$g(NurDepRecord[k]["NurDepRecord-94470-94476-94480"]); //日期
		if(NDRdate!=""){NDRlist=NDRlist+"日期："+NDRdate+"。";}
		var NDRmode=radioValue("NurDepRecord-94470-94477-94481,NurDepRecord-94470-94477-94482,NurDepRecord-94470-94477-94483,NurDepRecord-94470-94477-94484",data); //方式
		if(NDRmode!=""){NDRlist=NDRlist+"方式："+NDRmode+"。";}
		var NDRcontent=$g(NurDepRecord[k]["NurDepRecord-94470-94478-94485"]); //内容
		if(NDRcontent!=""){NDRlist=NDRlist+"内容："+NDRcontent+"。";}		
		var NDRpeople=$g(NurDepRecord[k]["NurDepRecord-94470-94479-94486"]); //记录者
		if(NDRpeople!=""){NDRlist=NDRlist+"记录者："+NDRpeople+"。";}		
		NurDepRecordList=NurDepRecordList+NDRlist
	}
	if(NurDepRecordList!=""){ListTraRecord=ListTraRecord+NurDepRecordList;}
	var NDrow=0
	var NDList=List.split("\n");
	var NDlen=NDList.length;
	for(i=0;i<NDlen;i++){
		NDrow=NDrow+parseInt(NDList[i].length/60)+1;
	}
	//var HNrow=parseInt(HeadNurEvaList.length/60);
	var NDheightlen=(NDrow+1+NurDepRecordlen)*18;
	$("#NurDepEvale").css({
		"height":NDheightlen
	});	
	
	$('#NurDepEvale').val(List);
	$('#NurDepEvale').append('<div id="TraRecord"></div>');
	$('#TraRecord').html(ListTraRecord);
}
//审核 窗口
function RepAudit()
{
	var RepFileFlag=""; //归档状态 2018-01-23
	if (FileFlag=="已归档"){
		RepFileFlag="-1";
	}
	
	if (RepFileFlag=="-1"){
		$.messager.alert("提示:","所选报告存在已归档报告，不能驳回！");
		return;
	}
	$('#Process').window({
		title:'审核',
		collapsible:false,
		minimizable:false,
		maximizable:false,
		border:false,
		closed:false,
		closable:true,
		modal:true,
		width:400,
		height:420,
		top:$('body').scrollTop()+((screen.availHeight-400)/4)
	});
	//指向科室 2018-07-05 cy 指向科室即为分派科室
	$('#matadrNextLoc').combobox({
		url:url+'?action=QueryAuditLocList&RepTypeCode='+RepTypeCode+'&CurStatusDR='+StatusNextID
	}); 
	$('#NextLocList').show();
	
	$('#Process').window('open'); 
	$("#matadrLocAdvice").empty();
	$("#matadrRecProgress").empty(); // 2018-07-12 调查核实内容清空
	ConWinSroll("Process");
}
//确认审批  2018-04-24
function RepConfirmAudit()
{	
	var NextLoc=$('#matadrNextLoc').combobox('getValue');
	/* if (NextLoc==""){
		$.messager.alert("提示:","指向科室不能为空！");
		return;
	} */
	var RecProgress=$.trim($('#matadrRecProgress').val());
	if (RecProgress==""){
		$.messager.alert("提示:","调查核实不能为空！");
		return;
	}
	RecProgress = $_TrsSymbolToTxt(RecProgress); /// 处理特殊符号	
	var LocAdvice=$.trim($('#matadrLocAdvice').val());
	if (LocAdvice==""){
		$.messager.alert("提示:","处理意见不能为空！");
		return;
	}
	LocAdvice = $_TrsSymbolToTxt(LocAdvice); /// 处理特殊符号	
	var params=RepID+"^"+StatusNextID+"^"+LgUserID+"^"+LgCtLocID+"^"+LgGroupID+"^"+NextLoc+"^"+LocAdvice+"^"+adrReceive+"^"+RepTypeCode+"^"+RecProgress;   //参数串
	runClassMethod("web.DHCADVCOMMONPART","AuditMataReport",{'params':params,'LgParam':LgParam},
	function(jsonString){ 
		if(jsonString.ErrCode < 0){
			$.messager.alert("提示:","审核错误,错误原因:"+"<font style='color:red;'>"+jsonString.ErrMsg+"</font>");   ///+"第"+errnum+"条数据"
		}
		if(jsonString.ErrCode == 0){
			window.parent.CloseWinUpdate();
			window.parent.Query();
		}
	},"json");
		
}
//撤销审批 2018-04-24
function RepCancelAuditBt()
{	var NextLoc=""; //$('#matadrNextLoc').combobox('getValue');
	var RecProgress="";
	var LocAdvice=""; //$('#matadrLocAdvice').val();
	if ((StaFistAuditUser!="")&(StaFistAuditUser!=LgUserName)){
		$.messager.alert("提示:","报告为驳回报告，且未驳回给当前登录人，无权限撤销审核！");
		return;
	}
	var params=RepID+"^"+StatusLastID+"^"+LgUserID+"^"+LgCtLocID+"^"+LgGroupID+"^"+NextLoc+"^"+LocAdvice+"^"+adrReceive+"^"+RepTypeCode+"^"+RecProgress;   //参数串
	//alert(params);
	//保存数据
	runClassMethod("web.DHCADVCOMMONPART","CancelAuditReport",{'params':params},
	function(jsonString){ 
		//var resobj = jQuery.parseJSON(jsonString);
		//var num=$('#maindg').datagrid("getRowIndex",item)+1; //2017-04-06  获取行数 区分哪一行操作出错
		if(jsonString.ErrCode < 0){
			$.messager.alert("提示:","审核错误,错误原因:"+"<font style='color:red;'>"+jsonString.ErrMsg+"</font>");   ///+"第"+errnum+"条数据"
		}
		if(jsonString.ErrCode == 0){
			window.parent.CloseWinUpdate();
			window.parent.Query();
		}
	},"json");
		
}
//驳回 2018-04-24
function RejectWin()
{
	var RepFileFlag=""; //归档状态 2018-01-23
	if (FileFlag=="已归档"){
		RepFileFlag="-1";
	}
	
	if (RepFileFlag=="-1"){
		$.messager.alert("提示:","所选报告存在已归档报告，不能驳回！");
		return;
	}
	$('#RetWin').window({
		title:'驳回',
		collapsible:false,
		border:false,
		closed:false,
		minimizable:false,
		maximizable:false,
		closable:false,
		modal:true,
		width:400,
		height:280,
		top:$('body').scrollTop()+((screen.availHeight-280)/4)
	}); 
	//驳回指向 状态
	$('#RevStatus').combobox({
		url:'dhcapp.broker.csp?ClassName=web.DHCADVCOMMONPART&MethodName=GetRevStatusComboxNew&EvenCode='+RepTypeCode+'&Status='+RepStausDr //"NursingRep"
	});
	//if (LgGroupDesc!="护理部"){
		//$('#RevStatus').combobox({disabled:true});;  //驳回指向
		$('#RevStatus').combobox('setValue',RepStausDr);  //驳回指向
	//}
	$('#RetWin').window('open'); 
	$("#retreason").empty(); 
	ConWinSroll("RetWin");
}
//确认驳回 2018-04-24
function BackBt()
{
	var NextLoc="";
	var LocAdvice="";
	var Retreason=$.trim($('#retreason').val());
	Retreason = $_TrsSymbolToTxt(Retreason); /// 处理特殊符号	
	var RevStatus=$('#RevStatus').combobox('getValue');  //驳回指向
	if (RevStatus==""){
		$.messager.alert("提示:","请选择驳回指向！");
		return;
	}
	if ($('#RevStatus').combobox('getText')=="护理部审核"){
		$.messager.alert("提示:","护理部未审核，驳回指向不能为护理部审核！");
		return;
	}
	if (Retreason==""){
		$.messager.alert("提示:","请填写驳回意见！");
		return;
	}
	var params=RepID+"^"+LgUserID+"^"+LgCtLocID+"^"+LgGroupID+"^"+NextLoc+"^"+LocAdvice+"^"+adrReceive+"^"+RepTypeCode+"^"+RepStausDr+"^"+Retreason+"^"+RevStatus;   //参数串
	runClassMethod("web.DHCADVCOMMONPART","ReportBack",{'params':params},
			function(jsonString){ 
				if(jsonString.ErrCode < 0){
					$.messager.alert("提示:","驳回错误,错误原因:"+"<font style='color:red;'>"+jsonString.ErrMsg+"</font>");   ///+"第"+errnum+"条数据"
				}
				if(jsonString.ErrCode == 0){
					window.parent.CloseWinUpdate();
					window.parent.Query();
				}
	},"json");
	$('#RetWin').window('close');
}
//选择时间与当前时间比较 2017-03-06
function compareSelTimeAndCurTime(SelDateTime)
{
	var SelDateArr="",SelYear="",SelMonth="",SelDate="";
	if(DateFormat=="4"){ //日期格式 4:"DMY" DD/MM/YYYY
		SelDateArr=SelDateTime.split("/");
		SelYear=SelDateArr[2];
		SelMonth=parseInt(SelDateArr[1]);
		SelDate=parseInt(SelDateArr[0]);
	}else if(DateFormat=="3"){ //日期格式 3:"YMD" YYYY-MM-DD
		SelDateArr=SelDateTime.split("-");
		SelYear=SelDateArr[0];
		SelMonth=parseInt(SelDateArr[1]);
		SelDate=parseInt(SelDateArr[2]);
	}else if(DateFormat=="1"){ //日期格式 1:"MDY" MM/DD/YYYY
		SelDateArr=SelDateTime.split("/");
		SelYear=SelDateArr[2];
		SelMonth=parseInt(SelDateArr[0]);
		SelDate=parseInt(SelDateArr[1]);
	}
	
	var myDate=new Date();
	var curYear=myDate.getFullYear();
	if(SelYear>curYear){
		return false;
	}
	var curMonth=myDate.getMonth()+1;
	if((SelYear==curYear)&(SelMonth>curMonth)){
		return false;
	}
	var curDate=myDate.getDate();
	if((SelYear==curYear)&(SelMonth==curMonth)&(SelDate>curDate)){
		return false;
	}
	return true;
}
function RepSetAudMessage(){
	runClassMethod("web.DHCADVCOMMONPART","QueryAuditMesJson",{'ReportID':RepID,'TypeDr':RepTypeDr},
	function(data){ 
		var len=data.length;  //审批信息
		var List="<div class='dhcc-panel-header'><div class='dhcc-panel-title'>事件处理反馈信息</div></div>  ";
		for(var k=0;k<len;k++){
			List=List+"<table class='dhcadv-auditTable'>"
			List=List+"<tr><th colspan='10'><img src='../scripts/dhcadvEvt/images/th-list.png'></img><span>"+data[k].Status+"</span></i></th></tr>"
			List=List+"<tr><td>处理人</td><td>"+data[k].AuditUser+"</td></tr>"
			List=List+"<tr><td>处理时间</td><td>"+data[k].AuditDateTime+"</td></tr>"
			List=List+"<tr><td>科室指向</td><td>"+data[k].NextLoc+"</td></tr>"
			List=List+"<tr><td>调查核实</td><td>"+$_TrsTxtToSymbol(data[k].RecProgress)+"</td></tr>"
			List=List+"<tr><td>科室意见</td><td>"+$_TrsTxtToSymbol(data[k].LocAdvice)+"</td></tr>"  ///data[k].LocAdvice
			List=List+"</table>"
			
			var TranMessdata=data[k].TranMess; //转抄信息
			var sublen=TranMessdata.length; //转抄信息个数
			var Sublist="";
			for (var i=0;i<sublen;i++){
				Sublist=Sublist+"<table class='dhcadv-auditTable'>"
				Sublist=Sublist+"<tr><th colspan='10'><img src='../scripts/dhcadvEvt/images/th-list.png'></img><span>"+"转抄"+"</span></i></th></tr>"
				Sublist=Sublist+"<tr><td>处理人</td><td>"+TranMessdata[i].MedIAuditUser+"</td></tr>"
				Sublist=Sublist+"<tr><td>处理时间</td><td>"+TranMessdata[i].MedIAuditDateTime+"</td></tr>"
				Sublist=Sublist+"<tr><td>科室指向</td><td>"+TranMessdata[i].MedINextLoc+"</td></tr>"
				Sublist=Sublist+"<tr><td>科室意见</td><td>"+$_TrsTxtToSymbol(TranMessdata[i].MedILocAdvice)+"</td></tr>"
				Sublist=Sublist+"<tr><td>人员指向</td><td>"+TranMessdata[i].MedINextUser+"</td></tr>"
				Sublist=Sublist+"<tr><td>人员处理时间</td><td>"+TranMessdata[i].MedIReceiveDateTime+"</td></tr>"
				Sublist=Sublist+"<tr><td>人员意见</td><td>"+$_TrsTxtToSymbol(TranMessdata[i].MedIUserAdvice)+"</td></tr>"
				Sublist=Sublist+"</table>"
				
			}
			List=List+Sublist
		}
		$('#AuditMessage').html(List);
		if(len==0){
			$('#AuditMessage').hide();
		}
	},"json",false)

}
//通过年龄获取年龄段
function getAgeBracket(age){
	var rtnStr=""
	
	if(age==""){
		rtnStr="不明";
		}
	if(rtnStr!="")
	return rtnStr;
	
	
	if((age.split("月").length>1)&&(age.split("天").length>1)){
		
		var month=age.split("月")[0].replace(/[^0-9]/ig,"");
		var day=age.split("月")[1].replace(/[^0-9]/ig,"");
		if((month==1)&&(day>0)){
			rtnStr="新生儿";
		}else if((month==2)&&(day==0)){
			rtnStr="新生儿";
			}else if((month>2)&&(month<12)){
				rtnStr="周岁以下";
				}
	}
	if(rtnStr!="")
	return rtnStr;

	if((age.split("天").length>1)){
		var ageNum= age.replace(/[^0-9]/ig,"")/30;
		if((ageNum>0)&&(ageNum<=2)){
			rtnStr="新生儿";
		}else if((ageNum>2)&&(ageNum<12)){
				rtnStr="周岁以下";	
		}
		}
	if(rtnStr!="")
	return rtnStr;
	
	if(age.split("月").length>1){				//包含月的
		var ageNum= age.replace(/[^0-9]/ig,"");
		if((ageNum==1)||(ageNum==2)){
			rtnStr="新生儿";
		}else if((ageNum>2)&&(ageNum<12)){
				rtnStr="周岁以下";	
		}
	}
	if(rtnStr!="")
	return rtnStr;


	if(age.split("岁").length>1){				//包含月的
		var ageNum= age.replace(/[^0-9]/ig,"");
		if((ageNum>0)&&(ageNum<18)){
			rtnStr="未成年";	

		}else if((ageNum<=0)||(ageNum>130)){
			rtnStr="请输入正确的年龄！";
		}else{
			rtnStr="成年";	
		}
	}
	if(rtnStr!="")
	return rtnStr;
	return rtnStr;


}
//转抄  2016-05-13 增加
function Transcription()
{	
	//清空输入框
	$('#medadrUser').attr("disabled",false);
	$('#medadrDateTime').attr("disabled",false);
	$("#tranLocAdvic").attr("disabled",false);
	$("#medadrUser").val("");
	$("#medadrDateTime").val("");
	$("#tranLocAdvic").val("");
	$("#tranLocDr").combobox('setValue',"");
	$("#tranReplyMess").val("");

	if(checkTranPermiss() == -1){	//qunianpeng 2018/1/11 不能转抄则直接不打开转抄界面
		$.messager.alert("提示:","<font style='color:red;'>"+"无审核权限不能进行转抄"+"</font>");
		return ;	
	}
	$('#TranWin').window({
		title:'转抄',
		collapsible:false,
		minimizable:false,
		maximizable:false,
		border:false,
		closed:false,
		modal:true,
		width:900,
		height:480,
		top:$('body').scrollTop()+((screen.availHeight-480)/4)
	});
	$('#TranWin').window('open');
	ConWinSroll("TranWin");
	var params=RepID+"^"+RepTypeCode+"^"+LgUserID;
	TranUserList(RepID,RepTypeCode,SubUserflag);//转抄指向人员
	TranLocUserList(RepID,RepTypeCode,SubUserflag);//转抄科室人员意见信息
	if(SubUserflag==0){
		//清空输入框
		getDateTime(); //2016-10-08 congyue
		$('#medadrUser').attr("disabled",false);
		$('#medadrDateTime').attr("disabled",false);
		$("#tranLocAdvic").attr("disabled",false);
		$("#medadrUser").val(LgUserName);//显示转抄人(当前登陆人)
		$("#medadrUser").attr("disabled",true);
		$("#medadrDateTime").attr("disabled",true);
		$("#tranLocAdvic").val("");
		$("#tranLocDr").combobox('setValue',"");
		$("#tranReplyMess").val("");
		$("#tranReply").hide();
		$("#tranReplyMess").hide();	
		$("#replyFlag").hide();//是否转抄回复

	}
	$.ajax({
		type: "POST",// 请求方式
    	url: url,
    	data: "action=SearchAuditMess&params="+params,
		success: function(data){
			var tmp=data.split("^");
			if(SubUserflag==1){
				$('#medadrUser').val(tmp[0]); //处理人员
				$('#medadrUser').attr("disabled","true");
				$('#medadrDateTime').val(tmp[1]+" "+tmp[2]);   //处理时间
				$('#medadrDateTime').attr("disabled","true");
				$('#tranLocAdvic').val(tmp[3].replace(/\∑/g,'"')); //处理意见
				$('#tranLocAdvic').attr("disabled","true");
				$("#tranReply").show();
		        $("#tranReplyMess").show();
		        $("#replyFlag").show();//是否转抄回复
				//var UserID=rowData.UserID;
				if ((tmp[5]!=LgUserID)&(tmp[6]!=LgCtLocID)){
					errflag=1;
					$("#tranLocDr").combobox('setValue',"");
				}else{
					errflag=0;
				}
	
			}
			else{
				errflag=0;
			}
		}
	});
	if(SubUserflag==1){
		$('#transub').hide();
		$('#tranreply').show();
		$('#tranrec').show();

	}else{
		$('#transub').show();
		$('#tranreply').hide();
		$('#tranrec').hide();
    }
   $("#reply").attr("checked",false);   //quninapeng 2018/1/26 每次进入转抄回复 清除责任人的选中状态	
}
//转抄指向人员
function TranUserList(RepID,RepTypeCode,SubUserflag)
{
	//转抄科室
	$('#tranLocDr').combobox({
		url:url+'?action=GetQueryLoc&RepTypeCode='+RepTypeCode,
		onSelect:function(){
			var tranLocDr=$('#tranLocDr').combobox('getValue');
			$('#selectdg').datagrid({
				url:url+'?action=GetUserDr',	
				queryParams:{
					params:RepTypeCode+"^"+tranLocDr}
			});
		}
	}); 
	//定义columns
	var usercolumns=[[
		{field:"ID",title:'ID',width:90,hidden:true},
		{field:"LocID",title:'LocID',width:90,hidden:true},
		{field:"Locname",title:'Locname',width:90,hidden:true},
		{field:"UserID",title:'UserID',width:90,hidden:true},
		{field:'Username',title:'科室人员',width:120}
	]];
	var titleNotes="";
	if(SubUserflag==1){
		titleNotes="";
	}else{
		titleNotes='<span style="font-size:10pt;font-family:华文楷体;color:red;">[双击行即可添加至转抄信息表]</span>';
	}
	var params=RepID+"^"+RepTypeCode;
	//定义datagrid
	$('#selectdg').datagrid({
		title:'指向人员'+titleNotes,
		url:url+'?action=QueryUserMess&paramsuser='+params,
		fit:true,
		rownumbers:true,
		columns:usercolumns,
		border:false,
		pageSize:40,  // 每页显示的记录条数
		pageList:[40,80],   // 可以设置每页记录条数的列表
	    singleSelect:false,
		loadMsg: '正在加载信息...',
		pagination:true,
		onDblClickRow:function(rowIndex, rowData){ 
			if((SubUserflag==1)){ //(SubUserflag==1)||(TranFlag==1)
				$('#selectdg').datagrid({title:'指向人员'});
				return;
			}else{
				$('#selectdg').datagrid({title:'指向人员'+titleNotes});
				if ((editRow != "")||(editRow == "0")) {
	            	$("#selectdg").datagrid('endEdit', editRow);
				}
				var LocID=rowData.LocID;
				var UserID=rowData.UserID;
				var Username=rowData.Username;
			
				var tranLocDr=$('#tranLocDr').combobox('getValue');
				var tranLocDesc=$('#tranLocDr').combobox('getText');
				//2017-11-23 cy 判断转抄科室为空不能添加人员
				if(tranLocDesc==""){
					$.messager.alert("提示:","转抄科室不能为空！");	
					return;
				}
				//2017-11-23 cy 判断添加人员不能重复添加
				var  dataList=$('#tranmesdg').datagrid('getData'); 
				for(var i=0;i<dataList.rows.length;i++){
					if(UserID==dataList.rows[i].nameID){
						$.messager.alert("提示","该人员已添加！"); 
						return ;
					}
				}				

				$('#tranmesdg').datagrid('insertRow',{
					 index: 0,	// index start with 0
					 row: {
						ID:"",
						name: Username,
						nameID: UserID,
						LocDesc: tranLocDesc,
						LocDr: tranLocDr
					}
		        });
		    }
		}
     
	});
}
//转抄科室人员意见信息
function TranLocUserList(RepID,RepTypeCode,SubUserflag)
{
	//定义columns
	var columns=[[
		{field:"ID",title:'ID',width:90,hidden:true},
		{field:"tranDateTime",title:'转抄时间',width:90,hidden:true},
		{field:'tranuser',title:'转抄人',width:120,hidden:true},
		{field:"tranuserID",title:'tranuserID',width:90,hidden:true},
		{field:'LocDesc',title:'科室',width:120},
		{field:"LocDr",title:'LocDr',width:90,hidden:true},
		{field:'name',title:'人员',width:80},
		{field:"nameID",title:'nameID',width:90,hidden:true},
		{field:'LocAdvice',title:'处理意见',width:100,formatter:transAdvice},
		{field:'advice',title:'回复内容',width:100,formatter:transAdvice},
		{field:'DutyFlag',title:'备注',width:200},
		{field:"tranreceive",title:'接收状态',width:90,hidden:true},
		{field:"tranrecedate",title:'接收日期',width:90,hidden:true},
		{field:"trancompdate",title:'完成日期',width:90,hidden:true}
	]];
	var titleOpNotes="";
	if(SubUserflag==1){
		titleOpNotes="";
	}else{
		titleOpNotes='<span style="font-size:10pt;font-family:华文楷体;color:red;">[双击行即可清除此条数据]</span>';
	}
	var params=RepID+"^"+RepTypeCode;
	//定义datagrid
	$('#tranmesdg').datagrid({
		title:'转抄信息表'+titleOpNotes,
		url:url+'?action=QueryTranLocUser&params='+params,
		fit:true,
		border:false,
		rownumbers:true,
		columns:columns,
		pageSize:40,  // 每页显示的记录条数
		pageList:[40,80],   // 可以设置每页记录条数的列表
	    singleSelect:false,
		loadMsg: '正在加载信息...',
		pagination:true,
        nowrap:false,
		onDblClickRow:function(rowIndex, rowData){  //双击清除选中行
			if((SubUserflag==1)){ //(SubUserflag==1)||(TranFlag==1)
				return;
			}else{
				if((rowData.LocAdvice==undefined)||(rowData.LocAdvice=="")){
					$('#tranmesdg').datagrid('deleteRow',rowIndex);
				}else{
					alert("已转抄,不可删除");	
				}
			}
		}
	});	
	
}
//转抄提交
function TranSub(id) //hxy 2018-01-25 (id) ie8回车莫名调未写方法修复
{
	if(errflag==1){
		$.messager.alert("提示:","非转抄被指向人员，无权限操作");
		return;
	}
	var tranLocDr=$('#tranLocDr').combobox('getValue');
	var tranLocAdvic=$('#tranLocAdvic').val();
	tranLocAdvic = tranLocAdvic.replace(/\"/g,"∑");	 //qunianpeng 2018/1/10 转换引号
	tranLocAdvic=$_TrsSymbolToTxt(tranLocAdvic);
	var tranReplyMess=$('#tranReplyMess').val();
	tranReplyMess = tranReplyMess.replace(/\"/g,"∑");  //qunianpeng 2018/1/10 转换引号
	tranReplyMess=$_TrsSymbolToTxt(tranReplyMess);
	var mediReceive="",mediRecDate="",mediRecTime="",mediCompleteDate="",mediCompleteTime="",medadrList="";	
	var selItems = $('#maindg').datagrid('getSelections');
	if (!selItems.length){
		$.messager.alert("提示:","请选中行,重试！");
		return;
	}
	$.each(selItems, function(index, item){
		var RepID=item.RepID;         //报表ID
		var RepTypeCode=item.RepTypeCode; //报告类型代码
		var Medadrreceivedr=item.Medadrreceivedr;//接收状态
		var StatusNextID=item.StatusNextID; //下一个状态
		var RepStausDr=item.RepStausDr //当前状态
		medadrList=RepID+"^"+RepTypeCode+"^"+tranLocDr+"^"+tranLocAdvic+"^"+Medadrreceivedr+"^"+StatusNextID+"^"+LgUserID+"^"+LgCtLocID+"^"+LgGroupID+"^"+RepStausDr;   //参数串
	})		
	var rows = $("#tranmesdg").datagrid('getChanges');
	if(rows.length<=0){
		$.messager.alert("提示","没有待保存数据!");
		return;
	}
	var dataList = [];
	for(var i=0;i<rows.length;i++)
	{
		if((rows[i].LocDr=="")||(rows[i].nameID=="")){
			$.messager.alert("提示","科室指向或人员不能为空!"); 
			return false;
		}
		if(tranLocAdvic==""){
			$.messager.alert("提示","处理意见不能为空!"); 
			return false;
		}
		var List=rows[i].ID+"^"+LgUserID+"^"+rows[i].LocDr+"^"+rows[i].nameID+"^"+tranReplyMess+"^"+mediReceive+"^"+mediRecDate+"^"+mediRecTime+"^"+mediCompleteDate+"^"+mediCompleteTime+"^"+tranLocAdvic;
		dataList.push(List);
	} 
	var medadriList=dataList.join("&&");
	var params="medadrList="+medadrList+"&medadriList="+medadriList; 

	//保存数据
	$.post(url+'?action=SaveTranMess',{"medadrList":medadrList,"medadriList":medadriList},function(jsonString){
		var resobj = jQuery.parseJSON(jsonString);
		if(resobj.ErrCode==0){
			//TranFlag=1;
			$.messager.alert("提示:","提交成功");
			$('#maindg').datagrid('reload'); //重新加载
			$('#maindg').datagrid('unselectAll') //2017-04-06 清除全选 $('#maindg').datagrid('clearSelections')  //2017-06-09 清除全选
     			$('#tranmesdg').datagrid('reload'); //重新加载 qunianpeng 2018/1/17			
		}
		if(resobj.ErrCode < 0){
			$.messager.alert("提示:","转抄提交错误,错误原因:"+"<font style='color:red;'>"+resobj.ErrMsg+"</font>");
			return ;
		}
	});
}
//转抄回复
function TranReply(Replyflag)
{   var tranDutyFlag="N"  //转抄之后未回复
	var tranLocDr=$('#tranLocDr').combobox('getValue');
	var tranLocAdvic=$('#tranLocAdvic').val();
	var tranReplyMess=$('#tranReplyMess').val();
	tranReplyMess = tranReplyMess.replace(/\"/g,"∑"); //qunianpeng 2018/1/10 转换引号
	tranReplyMess=$_TrsSymbolToTxt(tranReplyMess);
	if($("#reply").is(':checked')){
		tranDutyFlag="Y";
	}
	var medadriList=LgUserID+"^"+tranReplyMess+"^"+Replyflag+"^"+tranDutyFlag;
	
	var rows = $("#tranmesdg").datagrid('getRows');
	var dataList = [];
	for(var i=0;i<rows.length;i++)
	{
		if((Replyflag==1)&&(rows[i].advice!="")&&(rows[i].nameID==LgUserID)){
			$.messager.alert("提示:","已提交成功，请勿重复点击");
			return false;
		}
		
		if((Replyflag==0)&&(rows[i].tranrecedate!="")&&(rows[i].nameID==LgUserID)){
			$.messager.alert("提示:","已接收成功，请勿重复点击");
			return false;
		}
		if((Replyflag==0)&&(rows[i].advice!="")&&(rows[i].nameID==LgUserID)){
			$.messager.alert("提示:","回复已提交，接收无效");
			return false;
		}
	} 
	/* if((TranFlag==1)&(Replyflag==1)){
		$.messager.alert("提示:","已提交成功，请勿重复点击");
		return;
	}
	if((TranFlag==2)&(Replyflag==0)){
		$.messager.alert("提示:","已接收成功，请勿重复点击");
		return;
	}
	if((TranFlag==1)&(Replyflag==0)){
		$.messager.alert("提示:","回复已提交，接收无效");
		return;
	} */
	
	if((errflag==1)&(Replyflag==0)){
		$.messager.alert("提示:","非转抄被指向人员，无权限操作");
		return;
	}
	if((Replyflag==1)&(tranReplyMess=="")){
		$.messager.alert("提示:","回复提交操作，回复内容不能为空");
		return;
	}
	if((Replyflag==0)&(tranReplyMess!="")){
		$.messager.alert("提示:","接收操作，回复内容不填");
		return;
	}
	var selItems = $('#maindg').datagrid('getSelections');
	var medadrList="";
	if (!selItems.length){
		$.messager.alert("提示:","请选中行,重试！");
		return;
	}
	$.each(selItems, function(index, item){
		var RepID=item.RepID;         //报表ID
		var RepTypeCode=item.RepTypeCode; //报告类型代码
		var Medadrreceivedr=item.Medadrreceivedr;//接收状态
		var StatusNextID=item.StatusNextID; //下一个状态
		medadrList=RepID+"^"+RepTypeCode+"^"+tranLocDr+"^"+tranLocAdvic+"^"+Medadrreceivedr+"^"+StatusNextID;   //参数串
		//var params="medadrList="+medadrList+"&medadriList="+medadriList; 
	})
	//alert(params);
	//保存数据
	$.post(url+'?action=SaveReplyMess',{"medadrList":medadrList,"medadriList":medadriList},function(jsonString){
		var resobj = jQuery.parseJSON(jsonString);
		if(resobj.ErrCode==0){
			if(Replyflag==1){
				//TranFlag=1;
				$('#maindg').datagrid('reload'); //重新加载
				$('#maindg').datagrid('unselectAll') //2017-04-06 清除全选 $('#maindg').datagrid('clearSelections')  //2017-06-09 清除全选
			}
			$.messager.alert("提示:","操作成功");
			   closeDrgWindow();	
		}
		if(resobj.ErrCode < 0){
			$.messager.alert("提示:","操作错误,错误原因:"+"<font style='color:red;'>"+resobj.ErrMsg+"</font>");
		}
		
	});
}

//关闭转抄窗口
function closeDrgWindow()
{  
	$('#TranWin').window('close');
}
///qunianpeng 2018/1/11 判断是否有审核权限，是否可以转抄
function checkTranPermiss(){
	var ret=0;	
	var paramss=RepID+"^"+RepTypeDr+"^"+LgUserID+"^"+LgCtLocID+"^"+LgGroupID;
	$.ajax({  
		url:'dhcapp.broker.csp?ClassName=web.DHCADVCOMMON&MethodName=CheckTranPermiss'+'&params='+paramss, 	        
        async : false,	 // 注意此处需要同步，因为返回完数据后，下面才能让结果的第一条selected  
        type : "POST",  
        success : function(data) {       
        	if (data == -1){ret = -1;}
			else{ret = 0; }
			
        }  
	});	
	return ret;
}
/// qunianpeng 2018/1/3 ￠转换成^    ∑转换成"
function transAdvice(value, rowData, rowIndex){
	if (value != undefined) {
		value = $_TrsTxtToSymbol(value);
		return value;
	}
	return "";
}
//获取处理时间 2016-10-08 congyue
function getDateTime(){
	var tmp="";
	var time="";
  		$.ajax({
	  	async: false,
		type: "POST",// 请求方式
    	url: url,
    	data: "action=GetDealDateTime",
		success: function(data){
		var tmp=data.split("^");
		$('#medadrDateTime').val(tmp[0]+" "+tmp[1]);   //处理时间
		}
  	}); 
} 
//窗口滚动条控制 2018-12-20 cy 打开窗口父窗口滚动条隐藏，关闭窗口父窗口滚动条显示
function ConWinSroll(id){
	$('body').css('overflow-y','hidden');
	setInterval(function() { 
		if($('#'+id).is(":hidden")) { 
			clearInterval(ConWinSroll());    
			$('body').css('overflow-y','scroll');
			id="";
		}  
	}, 100); 
}
//控制等级和伤害严重程度级
function ConLevInjury()
{
	$("input[type=radio][id^='EventRepLevel-']").attr("disabled",true);
	$("input[type='radio'][id^='Severity']").on("click",function()
	{
		if($("input[type='radio'][id='Severity-98857']").is(":checked")==true)
		{
	
			$("input[type=radio][id^='EventRepLevel-96426']").attr("checked",true);
		}
		if(($("input[type='radio'][id='Severity-98858']").is(":checked")==true)||($("input[type='radio'][id='Severity-98859']").is(":checked")==true)||($("input[type='radio'][id='Severity-98860']").is(":checked")==true))
		{
			$("input[type=radio][id^='EventRepLevel-96425']").attr("checked",true);
		}
		if(($("input[type='radio'][id='Severity-98861']").is(":checked")==true)||($("input[type='radio'][id='Severity-98862']").is(":checked")==true)||($("input[type='radio'][id='Severity-98863']").is(":checked")==true)||($("input[type='radio'][id='Severity-98864']").is(":checked")==true))
		{
			$("input[type=radio][id^='EventRepLevel-96424']").attr("checked",true);
		}
		if($("input[type='radio'][id='Severity-98865']").is(":checked")==true)
		{
			$("input[type=radio][id^='EventRepLevel-96423']").attr("checked",true);
		}
		if($("input[type='radio'][id='Severity-98866']").is(":checked")==true)
		{
			$("input[type=radio][id^='EventRepLevel-96426']").attr("checked",true);
		}
		
	})
}
 
//加载报表基本信息公共
function InitBasicInfoCom(RepID)
{
	if(RepID==""){return;}
	runClassMethod("web.DHCADVCOMMONPART","GetRepBasicInfo",{'RepID':RepID},
	function(Data){ 
      	var ReportTime=Data.RepTime;				// 报告时间
		RepSetRead("ReportTime","input",0);								
		RepSetValue("ReportTime","input",ReportTime); 
		RepSetRead("ReportTime","input",1);		
		
		var ReportCardSta=Data.RepStaus;					// 报告卡状态
		if(ReportCardSta!=""){
			RepSetRead("ReportCardSta","input",0);								
			RepSetValue("ReportCardSta","input",ReportCardSta); 
			RepSetRead("ReportCardSta","input",1);							// 报告卡状态不可编辑	
		}
	},"json",false);
}
//2018-05-09 关闭转归窗口
function ClosePatOutWin(){
	$('#patoutwin').window('close');
}
