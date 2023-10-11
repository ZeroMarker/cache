/// Description: 药品事件护士长评价单评价界面 
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
			setCheckBoxRelation(this.id);
			InitCheckRadio();
			setManImprove();
		});
	});
	//单选框按钮事件
	$("input[type=radio]").each(function(){
		$(this).click(function(){
			$(this).is(':checked');
			//setCheckBoxRelation(this.id);
			InitCheckRadio();
		});
	})
	// 晨会报告日期控制 sufan 2019-06-18 表单统一去掉晨会部分
	//chkdate("MornRepMeetDate");
	// 会议日期控制
	chkdate("MeetDate","MeetTime");
	add_event();
	var Caserow=0
	var CaseList=$('#CaseImprovement').val().split("\n")
	var Caselen=CaseList.length;
	for(i=0;i<Caselen;i++){
		Caserow=Caserow+parseInt(CaseList[i].length/50)+1;
	}
	var Caseheightlen=(Caserow)*18;
	if($('#CaseImprovement').val()!=""){
		$("#CaseImprovement").css({
			"height":Caseheightlen
		});
	}
	//if(RepStaus!="填报"){ //护士长审核
	var EvaData=EvaFlagList.replace(/(^\s*)|(\s*$)/g,"").split("^");
	AssessFlag=EvaData[0];
	LocHeadNurEvaFlag=EvaData[1];
	NurDepEvaFlag=EvaData[2];
	if(EvaRecordId!="")	{
		//晨会报告 不可编辑 sufan 2019-06-18 表单统一去掉晨会部分
		//$("#MornMeetReport-panel input").attr("readonly",'readonly');
		//$("#MornRepMeetDate").datebox({"disabled":true});
		// 添加按钮隐藏 
		$('#ParPantsAddBut').hide();
		//科室护理不良事件分析 不可编辑
		$("#HeadNurCauseAnalysis-panel input").attr("disabled",true);
		$("#HeadNurCauseAnalysis-panel textarea").attr("readonly",'readonly');
		$("#MeetDate").datebox({"disabled":true});
		$("#HeadNurCauseAnalysis-panel input[type=checkbox]").attr("disabled",true);  
		//整改措施 不可编辑
		$("#Recmeasure-panel input").attr("readonly",'readonly');
		$("#CaseImprovement").attr("readonly",'readonly');
		$("#Recmeasure-panel input[type=checkbox]").attr("disabled",true); 
		//护士长评价 不可编辑
		$("#HeadNurEvaluate-panel input[type=radio]").attr("disabled",true); 
		$("#AftImpMeasures-94925-94927").attr("readonly",'readonly');
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
	//晨会人员  sufan 2019-06-18 表单统一去掉晨会部分
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
	//晨会内容 sufan 2019-06-18 表单统一去掉晨会部分
	/*$('#MornRepMeetContent').css({
		"width":800,
		"max-width":800
	});*/
	//名称
	$('#ManaImprovement-94378-94951').css({
		"width":300,
		"max-width":300
	});
	//个案改进不可编辑
	$("#CaseImprovement").attr("readonly",'readonly');
	$("body").click(function(){
		AllStyle("textarea","",100);
  		InitLabInputText(".lable-input");
		$(".mytext").bind('input propertychange ',function(){
	    	setManImprove();
	 	});
	 	$(".mytext").blur('input propertychange ',function(){
	    	setManImprove();
	 	});
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
	}) */
	 
	//参会人员 添加按钮事件
	$('#ParPantsAddBut').on("click",function(){
		StaffEnter();
	})
	$('#Find').bind("click",QueryName);   //点击查询
   	$('#Add').bind("click",MemAdd);     //点击添加，将勾选的人员添加到输入框 参会人员
  	//$('#MonAdd').bind("click",MonAdd);  //点击添加，将勾选的人员添加到输入框 晨会人员  sufan 2019-06-18 表单统一去掉晨会部分
}


//获取原因分析，设置整改措施
function setManImprove()
{
	var list="",PersonCause="",DeviceCause="",goodsCase="",ManaCase="",EveCause="";
	var i=0,j=0,k=0,l=0,m=0
	var PersonCauselist="",DeviceCauselist="",goodsCaselist="",ManaCaselist="",EveCauselist="";
	$("input[id^='PersonCause']").each(function(){
		if($(this).is(':checked')){
			if(this.id.indexOf("PersonCause-94275-94404")>=0){	
				i=i+1;
				PersonCause=i+"、"+$g("护士因素")+"——"+$g("医嘱处理")+"："+this.parentElement.innerText+"			"+getInputValue(this.id)+"\n";
				PersonCauselist=PersonCauselist+PersonCause;
			}
			if(this.id.indexOf("PersonCause-94275-94516")>=0){	
				i=i+1;
				PersonCause=i+"、"+$g("护士因素")+"——"+$g("药物领药")+"："+this.parentElement.innerText+"			"+getInputValue(this.id)+"\n";
				PersonCauselist=PersonCauselist+PersonCause;
			}		
			if(this.id.indexOf("PersonCause-94275-94517")>=0){	
				i=i+1;
				PersonCause=i+"、"+$g("护士因素")+"——"+$g("药物配制")+"："+this.parentElement.innerText+"			"+getInputValue(this.id)+"\n";
				PersonCauselist=PersonCauselist+PersonCause;
			}
			if(this.id.indexOf("PersonCause-94275-94518-94531")>=0){	
				i=i+1;
				PersonCause=i+"、"+$g("护士因素")+"——"+$g("执行给药")+"——"+$g("非抢救状态执行")+"："+this.parentElement.innerText+"			"+getInputValue(this.id)+"\n";
				PersonCauselist=PersonCauselist+PersonCause;
			}
			if(this.id.indexOf("PersonCause-94275-94518-94532")>=0){	
				i=i+1;
				PersonCause=i+"、"+$g("护士因素")+"——"+$g("执行给药")+"——"+$g("抢救状态执行")+"："+this.parentElement.innerText+"			"+getInputValue(this.id)+"\n";
				PersonCauselist=PersonCauselist+PersonCause;
			}
			if(this.id.indexOf("PersonCause-94275-94519")>=0){	
				i=i+1;
				PersonCause=i+"、"+$g("护士因素")+"——"+$g("护理人员因专业知识缺乏致给药错误")+"："+this.parentElement.innerText+"			"+getInputValue(this.id)+"\n";
				PersonCauselist=PersonCauselist+PersonCause;
			}
			if(this.id.indexOf("PersonCause-94275-94520")>=0){	
				i=i+1;
				PersonCause=i+"、"+$g("护士因素")+"："+this.parentElement.innerText+"			"+getInputValue(this.id)+"\n";
				PersonCauselist=PersonCauselist+PersonCause;
			}
			if(this.id.indexOf("PersonCause-94276")>=0){	
				i=i+1;
				PersonCause=i+"、"+$g("医生因素")+"："+this.parentElement.innerText+"			"+getInputValue(this.id)+"\n";
				PersonCauselist=PersonCauselist+PersonCause;
			}	
			if(this.id.indexOf("PersonCause-94402")>=0){	
				i=i+1;
				PersonCause=i+"、"+$g("药剂人员因素")+"："+this.parentElement.innerText+"			"+getInputValue(this.id)+"\n";
				PersonCauselist=PersonCauselist+PersonCause;
			}			
			if(this.id.indexOf("PersonCause-94403")>=0){	
				i=i+1;
				PersonCause=i+"、"+$g("患者因素")+"："+this.parentElement.innerText+"			"+getInputValue(this.id)+"\n";
				PersonCauselist=PersonCauselist+PersonCause;
			}									
		}
	});
	if(PersonCauselist!=""){
		list=list+"\n"+$g("一、人员因素")+"\n"+PersonCauselist;
	}

	$("input[id^='DeviceCause']").each(function(){
		if($(this).is(':checked')){
			j=j+1;
			DeviceCause=j+"、"+this.parentElement.innerText+"			"+getInputValue(this.id)+"\n";
			DeviceCauselist=DeviceCauselist+DeviceCause;
		}
	});
	if(DeviceCauselist!=""){
		list=list+"\n"+$g("二、设备因素（机）")+"\n"+DeviceCauselist;
	}

	$("input[id^='goodsCase']").each(function(){
		if($(this).is(':checked')){
			k=k+1;
			goodsCase=k+"、"+this.parentElement.innerText+"			"+getInputValue(this.id)+"\n";
			goodsCaselist=goodsCaselist+goodsCase;
		}
	});
	if(goodsCaselist!=""){
		list=list+"\n"+$g("三、物品因素（物）")+"\n"+goodsCaselist;
	}

	$("input[id^='ManaCase']").each(function(){
		if($(this).is(':checked')){
			l=l+1;
			ManaCase=l+"、"+this.parentElement.innerText+"			"+getInputValue(this.id)+"\n";
			ManaCaselist=ManaCaselist+ManaCase;
		}
	});
	if(ManaCaselist!=""){
		list=list+"\n"+$g("四、管理因素（法）")+"\n"+ManaCaselist;
	}

	$("input[id^='EveCause']").each(function(){
		if($(this).is(':checked')){
			m=m+1;
			EveCause=m+"、"+this.parentElement.innerText+"			"+getInputValue(this.id)+"\n";
			EveCauselist=EveCauselist+EveCause;
		}
		
	});
	if(EveCauselist!=""){
		list=list+"\n"+$g("五、环境因素")+"\n"+EveCauselist;
	}
	var Caserow=0
	var CaseList=list.split("\n")
	var Caselen=CaseList.length;
	for(i=0;i<Caselen;i++){
		Caserow=Caserow+parseInt(CaseList[i].length/50)+1;
	}
	var Caseheightlen=(Caserow)*18;
	$("#CaseImprovement").css({
		"height":Caseheightlen
	});
	$('#CaseImprovement').val(list)
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
			//alert(11)
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
	//护士因素-医嘱处理
	var DocAdvice=0;   //id是以后面的字符串开头
	$("input[type=checkbox][id^='PersonCause-94275-94404-94523']").each(function(){
		if($(this).is(':checked')){
			if ((this.value=="title")&&($("input[name$='.94523'][class='lable-input']").val()=="")){
				DocAdvice=-1;	
			}
		}
	})
	if(DocAdvice==-1){
		$.messager.alert($g("提示:"),"【"+$g("护士因素")+"-"+$g("医嘱处理")+"】"+$g("勾选")+$g('其他')+"，"+$g("请填写内容")+"！");	
		return false;
	}
	
	//护士因素-药物领取
	var DruReceive=0;   //id是以后面的字符串开头
	$("input[type=checkbox][id^='PersonCause-94275-94516-94526']").each(function(){
		if($(this).is(':checked')){
			if ((this.value=="title")&&($("input[name$='.94526'][class='lable-input']").val()=="")){
				DruReceive=-1;
				
			}
		}
	})
	if(DruReceive==-1){
		$.messager.alert($g("提示:"),"【"+$g("护士因素")+"-"+$g("药物领取")+"】"+$g("勾选")+$g('其他')+"，"+$g("请填写内容")+"！");	
		return false;
	}
	
	
	//护士因素-药物配制
	var DruAlloc=0;   //id是以后面的字符串开头
	$("input[type=checkbox][id^='PersonCause-94275-94517-94530']").each(function(){
		if($(this).is(':checked')){
			if ((this.value=="title")&&($("input[name$='.94530'][class='lable-input']").val()=="")){
				DruAlloc=-1;
				
			}
		}
	})
	if(DruAlloc==-1){
		$.messager.alert($g("提示:"),"【"+$g("护士因素")+"-"+$g("药物配制")+"】"+$g("勾选")+$g('其他')+"，"+$g("请填写内容")+"！");	
		return false;
	}
	
	//护士因素-执行给药-非抢救状态执行
	var NoRescue=0;   //id是以后面的字符串开头
	$("input[type=checkbox][id^='PersonCause-94275-94518-94531-94543']").each(function(){
		if($(this).is(':checked')){
			if ((this.value=="title")&&($("input[name$='.94543'][class='lable-input']").val()=="")){
				NoRescue=-1;
				
			}
		}
	})
	if(NoRescue==-1){
		$.messager.alert($g("提示:"),"【"+$g("护士因素")+"-"+$g("执行给药")+"-"+$g("非抢救状态执行")+"】"+$g("勾选")+$g('其他')+"，"+$g("请填写内容")+"！");	
		return false;
	}
	
	//护士因素-执行给药-抢救状态执行
	var Rescue=0;   //id是以后面的字符串开头
	$("input[type=checkbox][id^='PersonCause-94275-94518-94532-94545']").each(function(){
		if($(this).is(':checked')){
			if ((this.value=="title")&&($("input[name$='.94545'][class='lable-input']").val()=="")){
				Rescue=-1;
				
			}
		}
	})
	if(Rescue==-1){
		$.messager.alert($g("提示:"),"【"+$g("护士因素")+"-"+$g("执行给药")+"-"+$g("抢救状态执行")+"】"+$g("勾选")+$g('其他')+"，"+$g("请填写内容")+"！");	
		return false;
	}
	
	//护士因素-护理人员因专业知识缺乏致给药错误
	var DoseError=0;   //id是以后面的字符串开头
	$("input[type=checkbox][id^='PersonCause-94275-94519-94546']").each(function(){
		if($(this).is(':checked')){
			if ((this.value=="title")&&($("input[name$='.94546'][class='lable-input']").val()=="")){
				DoseError=-1;
				
			}
		}
	})
	if(DoseError==-1){
		$.messager.alert($g("提示:"),"【"+$g("护士因素")+"-"+$g("护理人员因专业知识缺乏致给药错误")+"】"+$g("勾选")+$g('其他')+"，"+$g("请填写内容")+"！");	
		return false;
	}
	
	//护士因素-其他
	var NurFactor=0;   //id是以后面的字符串开头
	$("input[type=checkbox][id^='PersonCause-94275-94520']").each(function(){
		if($(this).is(':checked')){
			if ((this.value=="title")&&($("input[name$='.94520'][class='lable-input']").val()=="")){
				NurFactor=-1;
				
			}
		}
	})
	if(NurFactor==-1){
		$.messager.alert($g("提示:"),"【"+$g("护士因素")+"-"+$g("其他")+"】"+$g("勾选")+$g('其他')+"，"+$g("请填写内容")+"！");	
		return false;
	}
		
	//医生因素-其他
	var DocFactor=0;   //id是以后面的字符串开头
	$("input[type=checkbox][id^='PersonCause-94276-94551']").each(function(){
		if($(this).is(':checked')){
			if ((this.value=="title")&&($("input[name$='.94551'][class='lable-input']").val()=="")){
				DocFactor=-1;
				
			}
		}
	})
	if(DocFactor==-1){
		$.messager.alert($g("提示:"),"【"+$g("医生因素")+"-"+$g("其他")+"】"+$g("勾选")+$g('其他')+"，"+$g("请填写内容")+"！");	
		return false;
	}
	
	//药剂人员因素-其他
	var PhaFactor=0;   //id是以后面的字符串开头
	$("input[type=checkbox][id^='PersonCause-94402-94554']").each(function(){
		if($(this).is(':checked')){
			if ((this.value=="title")&&($("input[name$='.94554'][class='lable-input']").val()=="")){
				PhaFactor=-1;
				
			}
		}
	})
	if(PhaFactor==-1){
		$.messager.alert($g("提示:"),"【"+$g("药剂人员因素")+"-"+$g("其他")+"】"+$g("勾选")+$g('其他')+"，"+$g("请填写内容")+"！");	
		return false;
	}
	
	//患者因素-其他
	var PatFactor=0;   //id是以后面的字符串开头
	$("input[type=checkbox][id^='PersonCause-94403-94557']").each(function(){
		if($(this).is(':checked')){
			if ((this.value=="title")&&($("input[name$='.94557'][class='lable-input']").val()=="")){
				PatFactor=-1;
				
			}
		}
	})
	if(PatFactor==-1){
		$.messager.alert($g("提示:"),"【"+$g("患者因素")+"-"+$g("其他")+"】"+$g("勾选")+$g('其他')+"，"+$g("请填写内容")+"！");	
		return false;
	}
	
	
	//设备因素-其他
	var EquFactor=0;   //id是以后面的字符串开头
	$("input[type=checkbox][id^='DeviceCause-94561']").each(function(){
		if($(this).is(':checked')){
			if ((this.value=="title")&&($("input[name$='.94561'][class='lable-input']").val()=="")){
				EquFactor=-1;
				
			}
		}
	})
	if(EquFactor==-1){
		$.messager.alert($g("提示:"),"【"+$g("设备因素")+"-"+$g("其他")+"】"+$g("勾选")+$g('其他')+"，"+$g("请填写内容")+"！");	
		return false;
	}
	
	//物品因素-其他
	var GoodsFactor=0;   //id是以后面的字符串开头
	$("input[type=checkbox][id^='goodsCase-94565']").each(function(){
		if($(this).is(':checked')){
			if ((this.value=="title")&&($("input[name$='.94565'][class='lable-input']").val()=="")){
				GoodsFactor=-1;
				
			}
		}
	})
	if(GoodsFactor==-1){
		$.messager.alert($g("提示:"),"【"+$g("物品因素")+"-"+$g("其他")+"】"+$g("勾选")+$g('其他')+"，"+$g("请填写内容")+"！");	
		return false;
	}
		
	//环境因素-其他
	var EnvFactor=0;   //id是以后面的字符串开头
	$("input[type=checkbox][id^='EveCause-94795']").each(function(){
		if($(this).is(':checked')){
			if ((this.value=="title")&&($("input[name$='.94795'][class='lable-input']").val()=="")){
				EnvFactor=-1;
				
			}
		}
	})
	if(EnvFactor==-1){
		$.messager.alert($g("提示:"),"【"+$g("环境因素")+"-"+$g("其他")+"】"+$g("勾选")+$g('其他')+"，"+$g("请填写内容")+"！");	
		return false;
	}
	
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
	var AftImpMeasures=0;   //id是以后面的字符串开头
	$("input[type=radio][id^='AftImpMeasures-94925']").each(function(){
		if($(this).is(':checked')){
			if (($("#AftImpMeasures-94925-94927").val()=="")){
				AftImpMeasures=-1;
			}
		}
	})
	if(AftImpMeasures==-1){
		$.messager.alert($g("提示:"),"【"+$g("事件发生后整改措施落实效果")+"】"+$g("勾选")+$g('未落实')+"，"+$g("请填写内容")+"！");	
		return false;
	}
	return true;
}
//页面关联设置
function setCheckBoxRelation(id){
	if($('#'+id).is(':checked')){
		//改进措施-管理改进 名称的填写控制
		if(id=="ManaImprovement-94378"){
			$('#ManaImprovement-94378-95229').attr("readonly",false);//医嘱给药时间
		}
	}
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
	//事件发生后整改措施落实效果 未落实 原因
	$("input[type=radio][id^='AftImpMeasures-']").each(function(){
		if ($(this).is(':checked')){
			var id=this.id;
			if (id=="AftImpMeasures-94925"){
				$("#AftImpMeasures-94925-94927").attr("readonly",false);
				InitLabInputText("#AftImpMeasures-94925-94927");
			}else{
				$("#AftImpMeasures-94925-94927").val("");
				$("#AftImpMeasures-94925-94927").unbind('click').on('click',function(){
				}); 
				
			}
		}
	})
	$("#AftImpMeasures-94925-94927").bind('input propertychange ',function(){
		if($("#AftImpMeasures-94925-94927").val()!=""){
			$("input[type=radio][id='AftImpMeasures-94925']").prop("checked",true) ;
			InitLabInputText("#AftImpMeasures-94925-94927");
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
	})*/ 
	
}
///处理护理不良事件评价原因分析勾选因素所填写的改进措施   如果input值为改进措施：  则返回""
function getInputValue(id){
	var inputvalue=getHideInputValue(id);
	if(inputvalue=="无"){
		inputvalue="";
	}
	if((inputvalue!="无")&&(inputvalue!="")){
		inputvalue=$g("整改措施：")+inputvalue;
	}
	return inputvalue;
	
}
