/// Description: 压疮护士长评价单评价界面 
/// Creator: congyue
/// CreateDate: 2018-04-17
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
	$("input[type=checkbox]").each(function(){
		$(this).click(function(){
			$(this).is(':checked');
			//setCheckBoxRelation(this.id);
			InitCheckRadio();
			setManImprove()
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
	// 晨会报告日期控制  sufan 2019-06-18 表单统一去掉晨会部分
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
	var EvaData=EvaFlagList.replace(/(^\s*)|(\s*$)/g,"").split("^");
	AssessFlag=EvaData[0];
	LocHeadNurEvaFlag=EvaData[1];
	NurDepEvaFlag=EvaData[2];
	if(EvaRecordId!="")	{
		// 添加按钮隐藏 
		$('#ParPantsAddBut').hide();
		//科室护理不良事件分析 不可编辑
		$("#HeadNurCauseAnalysis-panel input").attr("disabled",true);
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
		$("#AftImpMeasures-94925-94927").attr("readonly",'readonly');
		$("[id^='HeadNurEvaluate-94387-']").each(function(){
			var rowid=this.id.split(".")[0];
			var rownum=this.id.split(".")[1];
			if ((this.value!="")){
				$("[id^='"+rowid+"'][id$='"+rownum+"']").attr("readonly",'readonly');
				$("input[id^='"+rowid+"'][id$='"+rownum+"']").datebox({"disabled":true});
				$('a:contains("删除")').parent().hide();
			}
			if(AssessFlag!="Y"){
				$("[id^='"+rowid+"'][id$='"+rownum+"']").attr("readonly",'readonly');
				$("input[id^='"+rowid+"'][id$='"+rownum+"']").datebox({"disabled":true});
				$('a:contains("增加")').parent().hide();
			}
		})
		/* //护士长评价 督查日期 不可编辑
		 $("input[id^='HeadNurEvaluate-94387-94393-94398']").each(function(){
			if ((this.value!="")){
				var rowid=this.id.split(".")[0];
				var rownum=this.id.split(".")[1];
				$("input[id^='"+rowid+"'][id$='"+rownum+"']").datebox({"disabled":true});
			}
		}) */ 
		
	}
	//参会人员 
	$('#Participants').css({
		"width":800,
		"max-width":800
	});
	
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
	
	
	//参会人员 添加按钮事件
	$('#ParPantsAddBut').on("click",function(){
		StaffEnter();
	})
	$('#Find').bind("click",QueryName);   //点击查询
   	$('#Add').bind("click",MemAdd);     //点击添加，将勾选的人员添加到输入框 参会人员
  	//$('#MonAdd').bind("click",MonAdd);  //点击添加，将勾选的人员添加到输入框 晨会人员 sufan 2019-06-18 表单统一去掉晨会部分
}
//获取原因分析，设置整改措施
function setManImprove()
{
    var list="",HumFactor="",DeviceCause="",MatFactor="",MethodFactor="",  EnvirFactor="", ManaFactor="";
	var i=0,j=0,k=0,l=0,m=0,n=0
    var HumFactorlist="",DeviceCauselist="",MatFactorlist="",MethodFactorlist="",  EnvirFactorlist="", ManaFactorlist="";
	$("input[id^='HumFactor']").each(function(){
		if($(this).is(':checked')){
			if(this.id.indexOf("HumFactor-94914-95118")>=0){	
				i=i+1;
				if($(this).val()=="12岁以上人群"){
					i=i-1;
					HumFactor="";
				}else{
					HumFactor=i+"、"+"患者因素——12岁以上人群体重指数（BMI）:"+this.parentElement.innerText+"			"+getInputValue(this.id)+"\n";
				}
				HumFactorlist=HumFactorlist+HumFactor;
			}else if(this.id.indexOf("HumFactor-94914-95122")>=0){	
				i=i+1;
				if($(this).val()=="12岁以下人群"){
					i=i-1;
					HumFactor="";
				}else{
					HumFactor=i+"、"+"患者因素——12岁以下人群:"+this.parentElement.innerText+"			"+getInputValue(this.id)+"\n";
				}
				HumFactorlist=HumFactorlist+HumFactor;
			}else if(this.id.indexOf("HumFactor-94914-95122")>=0){	
				i=i+1;
				if($(this).val()=="12岁以下人群"){
					i=i-1;
					HumFactor="";
				}else{
					HumFactor=i+"、"+"患者因素——12岁以下人群:"+this.parentElement.innerText+"			"+getInputValue(this.id)+"\n";
				}
				HumFactorlist=HumFactorlist+HumFactor;
			}else if(this.id.indexOf("HumFactor-94914-95127")>=0){	
				i=i+1;
				if($(this).val()=="皮肤类型"){
					i=i-1;
					HumFactor="";
				}else{
					HumFactor=i+"、"+"患者因素——皮肤类型:"+this.parentElement.innerText+"			"+getInputValue(this.id)+"\n";
				}
				HumFactorlist=HumFactorlist+HumFactor;
			}else if(this.id.indexOf("HumFactor-94914-95135")>=0){	
				i=i+1;
				if($(this).val()=="活动"){
					i=i-1;
					HumFactor="";
				}else{
					HumFactor=i+"、"+"患者因素——活动:"+this.parentElement.innerText+"			"+getInputValue(this.id)+"\n";
				}
				HumFactorlist=HumFactorlist+HumFactor;
			}else if(this.id.indexOf("HumFactor-94914-95136")>=0){	
				i=i+1;
				if($(this).val()=="运动"){
					i=i-1;
					HumFactor="";
				}else{
					HumFactor=i+"、"+"患者因素——运动:"+this.parentElement.innerText+"			"+getInputValue(this.id)+"\n";
				}
				HumFactorlist=HumFactorlist+HumFactor;
			}else if(this.id.indexOf("HumFactor-94914-95137")>=0){	
				i=i+1;
				if($(this).val()=="营养因素"){
					i=i-1;
					HumFactor="";
				}else{
					HumFactor=i+"、"+"患者因素——营养因素:"+this.parentElement.innerText+"			"+getInputValue(this.id)+"\n";
				}
				HumFactorlist=HumFactorlist+HumFactor;
			}else if(this.id.indexOf("HumFactor-94914-95155")>=0){	
				i=i+1;
				if($(this).val()=="精神状况"){
					i=i-1;
					HumFactor="";
				}else{
					HumFactor=i+"、"+"患者因素——精神状况:"+this.parentElement.innerText+"			"+getInputValue(this.id)+"\n";
				}
				HumFactorlist=HumFactorlist+HumFactor;
			}else if(this.id.indexOf("HumFactor-94914-95160")>=0){	
				i=i+1;
				if($(this).val()=="组织灌注和氧合"){
					i=i-1;
					HumFactor="";
				}else{
					HumFactor=i+"、"+"患者因素——组织灌注和氧合:"+this.parentElement.innerText+"			"+getInputValue(this.id)+"\n";
				}
				HumFactorlist=HumFactorlist+HumFactor;
			}else if(this.id.indexOf("HumFactor-94914-95162")>=0){	
				i=i+1;
				if($(this).val()=="拒绝使用保护措施"){
					i=i-1;
					HumFactor="";
				}else{
					HumFactor=i+"、"+"患者因素——拒绝使用保护措施:"+this.parentElement.innerText+"			"+getInputValue(this.id)+"\n";
				}
				HumFactorlist=HumFactorlist+HumFactor;
			}else if(this.id.indexOf("HumFactor-94914")>=0){
				i=i+1;
				HumFactor=i+"、"+"患者因素:"+this.parentElement.innerText+"			"+getInputValue(this.id)+"\n";
				HumFactorlist=HumFactorlist+HumFactor; 		
			}else if(this.id.indexOf("HumFactor-94915-95180-95183")>=0){
				i=i+1;
				HumFactor=i+"、"+"护士因素——健康教育不到位——压疮预防健康教育针对性不强:"+this.parentElement.innerText+"			"+getInputValue(this.id)+"\n";
				HumFactorlist=HumFactorlist+HumFactor ;		
			}else if(this.id.indexOf("HumFactor-94915-95169")>=0){
				i=i+1;
				if($(this).val()=="护理措施落实不到位"){
					i=i-1;
					HumFactor="";
				}else{  
					HumFactor=i+"、"+"护士因素——护理措施落实不到位:"+this.parentElement.innerText+"			"+getInputValue(this.id)+"\n";
				}
				HumFactorlist=HumFactorlist+HumFactor; 		
			}else if(this.id.indexOf("HumFactor-94915-95180")>=0){
				i=i+1;
				if($(this).val()=="健康教育不到位"){
					i=i-1;
					HumFactor="";
				}else{  
					HumFactor=i+"、"+"护士因素——健康教育不到位:"+this.parentElement.innerText+"			"+getInputValue(this.id)+"\n";
				}
				HumFactorlist=HumFactorlist+HumFactor ;		
			}else if(this.id.indexOf("HumFactor-94915")>=0){
				i=i+1;
				HumFactor=i+"、"+"护士因素:"+this.parentElement.innerText+"			"+getInputValue(this.id)+"\n";
				HumFactorlist=HumFactorlist+HumFactor ;
			}else if(this.id.indexOf("HumFactor-94916")>=0){
				i=i+1;
				HumFactor=i+"、"+"医疗因素:"+this.parentElement.innerText+"			"+getInputValue(this.id)+"\n";
				HumFactorlist=HumFactorlist+HumFactor ;		
			}else if(this.id.indexOf(" HumFactor-94917-95198")>=0){
				i=i+1;
				if($(this).val()=="未落实压疮预防健康教育要求"){
					i=i-1;
					HumFactor="";
				}else{  
					HumFactor=i+"、"+"护理员、陪护因素——未落实压疮预防健康教育要求:"+this.parentElement.innerText+"			"+getInputValue(this.id)+"\n";
				}
				HumFactorlist=HumFactorlist+HumFactor ;		
			}else if(this.id.indexOf("HumFactor-94917")>=0){
				i=i+1;
				HumFactor=i+"、"+"护理员、陪护因素:"+this.parentElement.innerText+"			"+getInputValue(this.id)+"\n";
				HumFactorlist=HumFactorlist+HumFactor ;		
			}
		}
	});
	if(HumFactorlist!=""){
		list=list+"\n"+"一、人的因素:"+"\n"+HumFactorlist;
	}

	$("input[id^='UlcDeviceCause']").each(function(){
		if($(this).is(':checked')){
			if(this.id.indexOf("UlcDeviceCause-94920")>=0){	
				j=j+1;
				if($(this).val()=="设备设施不适用"){
					j=j-1;
					DeviceCause="";
				}else{
					DeviceCause=j+"、"+"设备设施不适用:"+this.parentElement.innerText+"			"+getInputValue(this.id)+"\n";
				}
				DeviceCauselist=DeviceCauselist+DeviceCause;
			}else if(this.id.indexOf("UlcDeviceCause-94921")>=0){	
				j=j+1;
				if($(this).val()=="提供预防压疮相应设施、设备不足"){
					j=j-1;
					DeviceCause="";
				}else{
					DeviceCause=j+"、"+"提供预防压疮相应设施、设备不足:"+this.parentElement.innerText+"			"+getInputValue(this.id)+"\n";
				}
				DeviceCauselist=DeviceCauselist+DeviceCause;
			}else if(this.id.indexOf("UlcDeviceCause-94922")>=0){	
				j=j+1;
				if($(this).val()=="仪器、设备故障"){
					j=j-1;
					DeviceCause="";
				}else{
					DeviceCause=j+"、"+"仪器、设备故障:"+this.parentElement.innerText+"			"+getInputValue(this.id)+"\n";
				}
				list=list+DeviceCause;
			}else if(this.id.indexOf("UlcDeviceCause")>=0){	
				j=j+1;
				DeviceCause=j+"、"+this.parentElement.innerText+"			"+getInputValue(this.id)+"\n";
				DeviceCauselist=DeviceCauselist+DeviceCause;
			}
		}
	});
	if(DeviceCauselist!=""){
		list=list+"\n"+"二、设备设施因素:"+"\n"+DeviceCauselist;
	}

	$("input[id^='MatFactor']").each(function(){
		if($(this).is(':checked')){
			if(this.id.indexOf("MatFactor-94925")>=0){	
				k=k+1;
				if($(this).val()=="医疗器具压迫"){
					k=k-1;
					MatFactor="";
				}else{
					MatFactor=k+"、"+"医疗器具压迫:"+this.parentElement.innerText+"			"+getInputValue(this.id)+"\n";
				}
				MatFactorlist=MatFactorlist+MatFactor;
			}else if(this.id.indexOf("MatFactor")>=0){	
				k=k+1;
				MatFactor=k+"、"+this.parentElement.innerText+"			"+getInputValue(this.id)+"\n";
				MatFactorlist=MatFactorlist+MatFactor;
			} 
		}
	});
	if(MatFactorlist!=""){
		list=list+"\n"+"三、材料因素:"+"\n"+MatFactorlist;
	}

	$("input[id^='UlcMethodFactor']").each(function(){
		if($(this).is(':checked')){
			l=l+1;
			MethodFactor=k+"、"+this.parentElement.innerText+"			"+getInputValue(this.id)+"\n";
			MethodFactorlist=MethodFactorlist+MethodFactor;
		}
	});
	if(MethodFactorlist!=""){
		list=list+"\n"+"四、方法因素:"+"\n"+MethodFactorlist;
	}

	$("input[id^='UlcEnvirFactor']").each(function(){
		if($(this).is(':checked')){
			m=m+1;
			EnvirFactor=m+"、"+this.parentElement.innerText+"			"+getInputValue(this.id)+"\n";
			EnvirFactorlist=EnvirFactorlist+EnvirFactor;
		}
	});
	if(EnvirFactorlist!=""){
		list=list+"\n"+"五、环境因素:"+"\n"+EnvirFactorlist;
	}

	$("input[id^='UlcManaFactor']").each(function(){
		if($(this).is(':checked')){
			n=n+1;
			ManaFactor=n+"、"+this.parentElement.innerText+"			"+getInputValue(this.id)+"\n";
			ManaFactorlist=ManaFactorlist+ManaFactor;
		}
	});
	if(ManaFactorlist!=""){
		list=list+"\n"+"六、管理因素:"+"\n"+ManaFactorlist;
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
  $('#CaseImprovement').val(list)
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
//校验
function checkother(){
	//一、人的因素
	//患者因素-12岁以上人群
	var HumFactorys=0,HumFactorysList="";
	$("input[type=checkbox][id='HumFactor-94914-95118']").each(function(){
		if ($(this).is(':checked')){
			HumFactorys=this.value;
		}
	})
	if(HumFactorys=="12岁以上人群"){
		$("input[type=checkbox][id^='HumFactor-94914-95118-']").each(function(){
			if (($(this).is(':checked'))&&(this.value!="")){
				HumFactorysList=this.value
			}
		})
		if (HumFactorysList==""){
			$.messager.alert("提示:","【患者因素】勾选'12岁以上人群'，请勾选相应内容！");	
			return false;
		}
	}
	
	//患者因素-12岁以下人群
	var HumFactoryx=0,HumFactoryxList="";
	$("input[type=checkbox][id='HumFactor-94914-95122']").each(function(){
		if ($(this).is(':checked')){
			HumFactoryx=this.value;
		}
	})
	if(HumFactoryx=="12岁以下人群"){
		$("input[type=checkbox][id^='HumFactor-94914-95122-']").each(function(){
			if (($(this).is(':checked'))&&(this.value!="")){
				HumFactoryxList=this.value
			}
		})
		if (HumFactoryxList==""){
			$.messager.alert("提示:","【患者因素】勾选'12岁以下人群'，请勾选相应内容！");	
			return false;
		}
	}

	//患者因素-皮肤类型
	var HumFactorpf=0,HumFactorpfList="";
	$("input[type=checkbox][id='HumFactor-94914-95127']").each(function(){
		if ($(this).is(':checked')){
			HumFactorpf=this.value;
		}
	})
	if(HumFactorpf=="皮肤类型"){
		$("input[type=checkbox][id^='HumFactor-94914-95127-']").each(function(){
			if (($(this).is(':checked'))&&(this.value!="")){
				HumFactorpfList=this.value
			}
		})
		if (HumFactorpfList==""){
			$.messager.alert("提示:","【患者因素】勾选'皮肤类型'，请勾选相应内容！");	
			return false;
		}
	}

	//患者因素-活动
	var HumFactorhd=0,HumFactorhdList="";
	$("input[type=checkbox][id='HumFactor-94914-95135']").each(function(){
		if ($(this).is(':checked')){
			HumFactorhd=this.value;
		}
	})
	if(HumFactorhd=="活动"){
		$("input[type=checkbox][id^='HumFactor-94914-95135-']").each(function(){
			if (($(this).is(':checked'))&&(this.value!="")){
				HumFactorhdList=this.value
			}
		})
		if (HumFactorhdList==""){
			$.messager.alert("提示:","【患者因素】勾选'活动'，请勾选相应内容！");	
			return false;
		}
	}

	//患者因素-运动
	var HumFactoryd=0,HumFactorydList="";
	$("input[type=checkbox][id='HumFactor-94914-95136']").each(function(){
		if ($(this).is(':checked')){
			HumFactoryd=this.value;
		}
	})
	if(HumFactoryd=="运动"){
		$("input[type=checkbox][id^='HumFactor-94914-95136-']").each(function(){
			if (($(this).is(':checked'))&&(this.value!="")){
				HumFactorydList=this.value
			}
		})
		if (HumFactorydList==""){
			$.messager.alert("提示:","【患者因素】勾选'运动'，请勾选相应内容！");	
			return false;
		}
	}

	//患者因素-营养因素
	var HumFactoryy=0,HumFactoryyList="";
	$("input[type=checkbox][id='HumFactor-94914-95137']").each(function(){
		if ($(this).is(':checked')){
			HumFactoryy=this.value;
		}
	})
	if(HumFactoryy=="营养因素"){
		$("input[type=checkbox][id^='HumFactor-94914-95137-']").each(function(){
			if (($(this).is(':checked'))&&(this.value!="")){
				HumFactoryyList=this.value
			}
		})
		if (HumFactoryyList==""){
			$.messager.alert("提示:","【患者因素】勾选'营养因素'，请勾选相应内容！");	
			return false;
		}
	}
	
	//患者因素-精神状况
	var HumFactorjs=0,HumFactorjsList="";
	$("input[type=checkbox][id='HumFactor-94914-95155']").each(function(){
		if ($(this).is(':checked')){
			HumFactorjs=this.value;
		}
	})
	if(HumFactorjs=="精神状况"){
		$("input[type=checkbox][id^='HumFactor-94914-95155-']").each(function(){
			if (($(this).is(':checked'))&&(this.value!="")){
				HumFactorjsList=this.value
			}
		})
		if (HumFactorjsList==""){
			$.messager.alert("提示:","【患者因素】勾选'精神状况'，请勾选相应内容！");	
			return false;
		}
	}
	
	//患者因素-组织灌注和氧合
	var HumFactoryh=0,HumFactoryhList="";
	$("input[type=checkbox][id='HumFactor-94914-95160']").each(function(){
		if ($(this).is(':checked')){
			HumFactoryh=this.value;
		}
	})
	if(HumFactoryh=="组织灌注和氧合"){
		$("input[type=checkbox][id^='HumFactor-94914-95160-']").each(function(){
			if (($(this).is(':checked'))&&(this.value!="")){
				HumFactoryhList=this.value
			}
		})
		if (HumFactoryhList==""){
			$.messager.alert("提示:","【患者因素】勾选'组织灌注和氧合'，请勾选相应内容！");	
			return false;
		}
	}

	//患者因素-拒绝使用保护措施
	var HumFactorcs=0,HumFactorcsList="";
	$("input[type=checkbox][id='HumFactor-94914-95162']").each(function(){
		if ($(this).is(':checked')){
			HumFactorcs=this.value;
		}
	})
	if(HumFactorcs=="拒绝使用保护措施"){
		$("input[type=checkbox][id^='HumFactor-94914-95162-']").each(function(){
			if (($(this).is(':checked'))&&(this.value!="")){
				HumFactorcsList=this.value
			}
		})
		if (HumFactorcsList==""){
			$.messager.alert("提示:","【患者因素】勾选'拒绝使用保护措施'，请勾选相应内容！");	
			return false;
		}
	}

	//护士因素-患者患有疾病或生理功能障碍
	var HumFactorzaoth=0,HumFactorza="",HumFactorzaList="";
	$("input[type=checkbox][id='HumFactor-94915-95169']").each(function(){
		if ($(this).is(':checked')){
			HumFactorza=this.value;
		}
	})
	if(HumFactorza=="护理措施落实不到位"){
		$("input[type=checkbox][id^='HumFactor-94915-95169-']").each(function(){
			if (($(this).is(':checked'))&&(this.value!="")){
				HumFactorzaList=this.value
			}
		})
		if (HumFactorzaList==""){
			$.messager.alert("提示:","【护士因素】勾选'护理措施落实不到位'，请勾选相应内容！");	
			return false;
		}
	}
	$("input[type=checkbox][id^='HumFactor-94915-95169-95179']").each(function(){
		if($(this).is(':checked')){
			if ((this.value=="title")&&($("input[name$='.96008'][class='lable-input']").val()=="")){
				HumFactorzaoth=-1;
			}
		}
	})
	if(HumFactorzaoth==-1){
		$.messager.alert("提示:","【护士因素-护理措施落实不到位】勾选'其他'，请填写内容！");	
		return false;
	}
	//护士因素-健康教育不到位
	var HumFactorjy="",HumFactorjyList="";
	$("input[type=checkbox][id='HumFactor-94915-95180']").each(function(){
		if ($(this).is(':checked')){
			HumFactorjy=this.value;
		}
	})
	if(HumFactorjy=="护理措施落实不到位"){
		$("input[type=checkbox][id^='HumFactor-94915-95180-']").each(function(){
			if (($(this).is(':checked'))&&(this.value!="")){
				HumFactorjyList=this.value
			}
		})
		if (HumFactorjyList==""){
			$.messager.alert("提示:","【护士因素】勾选'护理措施落实不到位'，请勾选相应内容！");	
			return false;
		}
	}
	//压疮预防健康教育针对性不强
	var HumFactorffoth=0,HumFactorff="",HumFactorffList="";
	$("input[type=checkbox][id='HumFactor-94915-95180-95183']").each(function(){
		if ($(this).is(':checked')){
			HumFactorff=this.value;
		}
	})
	if(HumFactorff=="压疮预防健康教育针对性不强"){
		$("input[type=checkbox][id^='HumFactor-94915-95180-95183-']").each(function(){
			if (($(this).is(':checked'))&&(this.value!="")){
				HumFactorffList=this.value
			}
		})
		if (HumFactorffList==""){
			$.messager.alert("提示:","【护士因素-护理措施落实不到位】勾选'压疮预防健康教育针对性不强'，请勾选相应内容！");	
			return false;
		}
	}
	$("input[type=checkbox][id^='HumFactor-94915-95180-95183-95188']").each(function(){
		if($(this).is(':checked')){
			if ((this.value=="title")&&($("input[name$='.96017'][class='lable-input']").val()=="")){
				HumFactorffoth=-1;
			}
		}
	})
	if(HumFactorffoth==-1){
		$.messager.alert("提示:","【护士因素-护理措施落实不到位-压疮预防健康教育针对性不强】勾选'其他'，请填写内容！");	
		return false;
	}
	//医疗因素
	var HumFactoroth=0;
	$("input[type=checkbox][id^='HumFactor-94916-95196']").each(function(){
		if($(this).is(':checked')){
			if ((this.value=="title")&&($("input[name$='.96026'][class='lable-input']").val()=="")){
				HumFactoroth=-1;
			}
		}
	})
	if(HumFactoroth==-1){
		$.messager.alert("提示:","【医疗因素】勾选'其他'，请填写内容！");	
		return false;
	}

	//护理员、陪护因素
	var HumFactoroth=0;
	$("input[type=checkbox][id^='HumFactor-94917-95210']").each(function(){
		if($(this).is(':checked')){
			if ((this.value=="title")&&($("input[name$='.96041'][class='lable-input']").val()=="")){
				HumFactoroth=-1;
			}
		}
	})
	if(HumFactoroth==-1){
		$.messager.alert("提示:","【护理员、陪护因素】勾选'其他'，请填写内容！");	
		return false;
	}
	
	//护理员、陪护因素--未落实压疮预防健康教育要求
	var HumFactorjyoth=0,HumFactorjy="",HumFactorjyList="";
	$("input[type=checkbox][id='HumFactor-94917-95198']").each(function(){
		if ($(this).is(':checked')){
			HumFactorjy=this.value;
		}
	})
	if(HumFactorjy=="未落实压疮预防健康教育要求"){
		$("input[type=checkbox][id^='HumFactor-94917-95198-']").each(function(){
			if (($(this).is(':checked'))&&(this.value!="")){
				HumFactorjyList=this.value
			}
		})
		if (HumFactorjyList==""){
			$.messager.alert("提示:","【护理员、陪护因素】勾选'未落实压疮预防健康教育要求'，请勾选相应内容！");	
			return false;
		}
	}
	$("input[type=checkbox][id^='HumFactor-94917-95198-95206']").each(function(){
		if($(this).is(':checked')){
			if ((this.value=="title")&&($("input[name$='.96037'][class='lable-input']").val()=="")){
				HumFactorjyoth=-1;
			}
		}
	})
	if(HumFactorjyoth==-1){
		$.messager.alert("提示:","【护理员、陪护因素-未落实压疮预防健康教育要求】勾选'其他'，请填写内容！");	
		return false;
	}
	
	//二、设备设施因素
	var UlcDeviceCauseoth=0;
	$("input[type=checkbox][id^='UlcDeviceCause-94923']").each(function(){
		if($(this).is(':checked')){
			if ((this.value=="title")&&($("input[name$='.96055'][class='lable-input']").val()=="")){
				UlcDeviceCauseoth=-1;
			}
		}
	})
	if(UlcDeviceCauseoth==-1){
		$.messager.alert("提示:","【设备设施因素】勾选'其他'，请填写内容！");	
		return false;
	}
	//设备设施因素-设备设施不适用
	var UlcDeviceCausesboth=0,UlcDeviceCausesb="",UlcDeviceCausesbList="";
	$("input[type=checkbox][id='UlcDeviceCause-94920']").each(function(){
		if ($(this).is(':checked')){
			UlcDeviceCausesb=this.value;
		}
	})
	if(UlcDeviceCausesb=="设备设施不适用"){
		$("input[type=checkbox][id^='UlcDeviceCause-94920-']").each(function(){
			if (($(this).is(':checked'))&&(this.value!="")){
				UlcDeviceCausesbList=this.value
			}
		})
		if (UlcDeviceCausesbList==""){
			$.messager.alert("提示:","【设备设施因素】勾选'设备设施不适用'，请勾选相应内容！");	
			return false;
		}
	}
	$("input[type=checkbox][id^='UlcDeviceCause-94920-95213']").each(function(){
		if($(this).is(':checked')){
			if ((this.value=="title")&&($("input[name$='.96045'][class='lable-input']").val()=="")){
				UlcDeviceCausesboth=-1;
			}
		}
	})
	if(UlcDeviceCausesboth==-1){
		$.messager.alert("提示:","【设备设施因素-设备设施不适用】勾选'其他'，请填写内容！");	
		return false;
	}
	
	//提供预防压疮相应设施、设备不足
	var UlcDeviceCausecsoth=0,UlcDeviceCausecs="",UlcDeviceCausecsList="";
	$("input[type=checkbox][id='UlcDeviceCause-94921']").each(function(){
		if ($(this).is(':checked')){
			UlcDeviceCausecs=this.value;
		}
	})
	if(UlcDeviceCausecs=="提供预防压疮相应设施、设备不足"){
		$("input[type=checkbox][id^='UlcDeviceCause-94921-']").each(function(){
			if (($(this).is(':checked'))&&(this.value!="")){
				UlcDeviceCausecsList=this.value
			}
		})
		if (UlcDeviceCausecsList==""){
			$.messager.alert("提示:","【设备设施因素】勾选'提供预防压疮相应设施、设备不足'，请勾选相应内容！");	
			return false;
		}
	}
	$("input[type=checkbox][id^='UlcDeviceCause-94921-95221']").each(function(){
		if($(this).is(':checked')){
			if ((this.value=="title")&&($("input[name$='.96050'][class='lable-input']").val()=="")){
				UlcDeviceCausecsoth=-1;
			}
		}
	})
	if(UlcDeviceCausecsoth==-1){
		$.messager.alert("提示:","【设备设施因素-提供预防压疮相应设施、设备不足】勾选'其他'，请填写内容！");	
		return false;
	}
	
	//仪器、设备故障
	var UlcDeviceCausegzoth=0,UlcDeviceCausegz="",UlcDeviceCausegzList="";
	$("input[type=checkbox][id='UlcDeviceCause-94922']").each(function(){
		if ($(this).is(':checked')){
			UlcDeviceCausegz=this.value;
		}
	})
	if(UlcDeviceCausegz=="仪器、设备故障"){
		$("input[type=checkbox][id^='UlcDeviceCause-94922-']").each(function(){
			if (($(this).is(':checked'))&&(this.value!="")){
				UlcDeviceCausegzList=this.value
			}
		})
		if (UlcDeviceCausegzList==""){
			$.messager.alert("提示:","【设备设施因素】勾选'仪器、设备故障'，请勾选相应内容！");	
			return false;
		}
	}
	$("input[type=checkbox][id^='UlcDeviceCause-94922-95218']").each(function(){
		if($(this).is(':checked')){
			if ((this.value=="title")&&($("input[name$='.96054'][class='lable-input']").val()=="")){
				UlcDeviceCausegzoth=-1;
			}
		}
	})
	if(UlcDeviceCausegzoth==-1){
		$.messager.alert("提示:","【设备设施因素-仪器、设备故障】勾选'其他'，请填写内容！");	
		return false;
	}
	
	//三、材料因素
	var MatFactoroth=0;
	$("input[type=checkbox][id^='MatFactor-94927']").each(function(){
		if($(this).is(':checked')){
			if ((this.value=="title")&&($("input[name$='.96064'][class='lable-input']").val()=="")){
				MatFactoroth=-1;
			}
		}
	})
	if(MatFactoroth==-1){
		$.messager.alert("提示:","【材料因素】勾选'其他'，请填写内容！");	
		return false;
	}
	
	//三、材料因素 医疗器具压迫
	var MatFactorqjoth=0,MatFactorqj="",MatFactorqjList="";
	$("input[type=checkbox][id='MatFactor-94925']").each(function(){
		if ($(this).is(':checked')){
			MatFactorqj=this.value;
		}
	})
	if(MatFactorqj=="医疗器具压迫"){
		$("input[type=checkbox][id^='MatFactor-94925-']").each(function(){
			if (($(this).is(':checked'))&&(this.value!="")){
				MatFactorqjList=this.value
			}
		})
		if (MatFactorqjList==""){
			$.messager.alert("提示:","【医疗器具压迫】勾选'仪器、设备故障'，请勾选相应内容！");	
			return false;
		}
	}
	$("input[type=checkbox][id^='MatFactor-94925-95227']").each(function(){
		if($(this).is(':checked')){
			if ((this.value=="title")&&($("input[name$='.96062'][class='lable-input']").val()=="")){
				MatFactorqjoth=-1;
			}
		}
	})
	if(MatFactorqjoth==-1){
		$.messager.alert("提示:","【材料因素-医疗器具压迫】勾选'其他'，请填写内容！");	
		return false;
	}
	
	//四、方法因素
	var methodFactoroth=0;
	$("input[type=checkbox][id^='methodFactor-94931']").each(function(){
		if($(this).is(':checked')){
			if ((this.value=="title")&&($("input[name$='.96067'][class='lable-input']").val()=="")){
				methodFactoroth=-1;
			}
		}
	})
	if(methodFactoroth==-1){
		$.messager.alert("提示:","【方法因素】勾选'其他'，请填写内容！");	
		return false;
	}
	
	//六、管理因素
	var UlcManaFactoroth=0;
	$("input[type=checkbox][id^='UlcManaFactor-94942']").each(function(){
		if($(this).is(':checked')){
			if ((this.value=="title")&&($("input[name$='.96076'][class='lable-input']").val()=="")){
				UlcManaFactoroth=-1;
			}
		}
	})
	if(UlcManaFactoroth==-1){
		$.messager.alert("提示:","【管理因素】勾选'其他'，请填写内容！");	
		return false;
	}
	
	//管理改进  ManaImprovement-94378-96091
	var ManaImprovementoth=0;
	$("input[type=checkbox][id^='ManaImprovement']").each(function(){
		if ($(this).is(':checked')){
			if((this.value=="title")&&($("input[name$='.96082'][class='lable-input']").val()=="")){
				ManaImprovementoth=-1;
			}
			if((this.value=="制度、流程及规范制定或修订")){
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
		$.messager.alert("提示:","【管理改进】勾选'制度、流程及规范制定或修订'，请勾选和填写内容！");	
		return false;
	}
	if(ManaImprovementoth==-1){
		$.messager.alert("提示:","【管理改进】勾选'其他'，请填写内容！");	
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
		$.messager.alert("提示:","【事件发生后整改措施落实效果】勾选'未落实'，请填写内容！");	
		return false;
	}
		
	return true;
}
//页面初始加载checkbox,radio控制子元素不可以填写
function InitCheckRadio(){
	//患者因素-12岁以上人群 
	if($("input[type=checkbox][id='HumFactor-94914-95118']").is(':checked')){
		$("input[type=checkbox][id^='HumFactor-94914-95118-']").attr("disabled",false);

	}else{
		$("input[type=checkbox][id^='HumFactor-94914-95118-']").removeAttr("checked");
		$("input[type=checkbox][id^='HumFactor-94914-95118-']").attr("disabled",true);
	}	
	//患者因素-12岁以下人群 
	if($("input[type=checkbox][id='HumFactor-94914-95122']").is(':checked')){
		$("input[type=checkbox][id^='HumFactor-94914-95122-']").attr("disabled",false);

	}else{
		$("input[type=checkbox][id^='HumFactor-94914-95122-']").removeAttr("checked");
		$("input[type=checkbox][id^='HumFactor-94914-95122-']").attr("disabled",true);
	}	
	//患者因素-皮肤类型
	if($("input[type=checkbox][id='HumFactor-94914-95127']").is(':checked')){
		$("input[type=checkbox][id^='HumFactor-94914-95127-']").attr("disabled",false);

	}else{
		$("input[type=checkbox][id^='HumFactor-94914-95127-']").removeAttr("checked");
		$("input[type=checkbox][id^='HumFactor-94914-95127-']").attr("disabled",true);
	}	
	//患者因素-活动
	if($("input[type=checkbox][id='HumFactor-94914-95135']").is(':checked')){
		$("input[type=checkbox][id^='HumFactor-94914-95135-']").attr("disabled",false);

	}else{
		$("input[type=checkbox][id^='HumFactor-94914-95135-']").removeAttr("checked");
		$("input[type=checkbox][id^='HumFactor-94914-95135-']").attr("disabled",true);
	}	
	//患者因素-运动
	if($("input[type=checkbox][id='HumFactor-94914-95136']").is(':checked')){
		$("input[type=checkbox][id^='HumFactor-94914-95136-']").attr("disabled",false);

	}else{
		$("input[type=checkbox][id^='HumFactor-94914-95136-']").removeAttr("checked");
		$("input[type=checkbox][id^='HumFactor-94914-95136-']").attr("disabled",true);
	}	
	//患者因素-营养因素
	if($("input[type=checkbox][id='HumFactor-94914-95137']").is(':checked')){
		$("input[type=checkbox][id^='HumFactor-94914-95137-']").attr("disabled",false);

	}else{
		$("input[type=checkbox][id^='HumFactor-94914-95137-']").removeAttr("checked");
		$("input[type=checkbox][id^='HumFactor-94914-95137-']").attr("disabled",true);
	}	
	//患者因素-精神状况
	if($("input[type=checkbox][id='HumFactor-94914-95155']").is(':checked')){
		$("input[type=checkbox][id^='HumFactor-94914-95155-']").attr("disabled",false);

	}else{
		$("input[type=checkbox][id^='HumFactor-94914-95155-']").removeAttr("checked");
		$("input[type=checkbox][id^='HumFactor-94914-95155-']").attr("disabled",true);
	}	
	//患者因素-组织灌注和氧合
	if($("input[type=checkbox][id='HumFactor-94914-95160']").is(':checked')){
		$("input[type=checkbox][id^='HumFactor-94914-95160-']").attr("disabled",false);

	}else{
		$("input[type=checkbox][id^='HumFactor-94914-95160-']").removeAttr("checked");
		$("input[type=checkbox][id^='HumFactor-94914-95160-']").attr("disabled",true);
	}	
	//患者因素-拒绝使用保护措施
	if($("input[type=checkbox][id='HumFactor-94914-95162']").is(':checked')){
		$("input[type=checkbox][id^='HumFactor-94914-95162-']").attr("disabled",false);

	}else{
		$("input[type=checkbox][id^='HumFactor-94914-95162-']").removeAttr("checked");
		$("input[type=checkbox][id^='HumFactor-94914-95162-']").attr("disabled",true);
	}	
	
	//护士因素-护理措施落实不到位
	if($("input[type=checkbox][id='HumFactor-94915-95169']").is(':checked')){
		$("input[type=checkbox][id^='HumFactor-94915-95169-']").attr("disabled",false);
	}else{
		$("input[name$='.96008'][class='lable-input']").val("");
		$("input[name$='.96008'][class='lable-input']").hide();
		$("input[type=checkbox][id^='HumFactor-94915-95169-']").removeAttr("checked");
		$("input[type=checkbox][id^='HumFactor-94915-95169-']").attr("disabled",true);
	}
	//护士因素-健康教育不到位
	if($("input[type=checkbox][id='HumFactor-94915-95180']").is(':checked')){
		$("input[type=checkbox][id^='HumFactor-94915-95180-']").attr("disabled",false);
	}else{
		$("input[name$='.96017'][class='lable-input']").val("");
		$("input[name$='.96017'][class='lable-input']").hide();
		$("input[type=checkbox][id^='HumFactor-94915-95180-']").removeAttr("checked");
		$("input[type=checkbox][id^='HumFactor-94915-95180-']").attr("disabled",true);
	}
	//护士因素-健康教育不到位-压疮预防健康教育针对性不强
	if($("input[type=checkbox][id='HumFactor-94915-95180-95183']").is(':checked')){
		$("input[type=checkbox][id^='HumFactor-94915-95180-95183-']").attr("disabled",false);
	}else{
		$("input[name$='.96017'][class='lable-input']").val("");
		$("input[name$='.96017'][class='lable-input']").hide();
		$("input[type=checkbox][id^='HumFactor-94915-95180-95183-']").removeAttr("checked");
		$("input[type=checkbox][id^='HumFactor-94915-95180-95183-']").attr("disabled",true);
	}
	//护理员、陪护因素-未落实压疮预防健康教育要求
	if($("input[type=checkbox][id='HumFactor-94917-95198']").is(':checked')){
		$("input[type=checkbox][id^='HumFactor-94917-95198-']").attr("disabled",false);
	}else{
		$("input[name$='.96037'][class='lable-input']").val("");
		$("input[name$='.96037'][class='lable-input']").hide();
		$("input[type=checkbox][id^='HumFactor-94917-95198-']").removeAttr("checked");
		$("input[type=checkbox][id^='HumFactor-94917-95198-']").attr("disabled",true);
	}
	
	//二、设备设施因素-设备设施不适用
	if($("input[type=checkbox][id='UlcDeviceCause-94920']").is(':checked')){
		$("input[type=checkbox][id^='UlcDeviceCause-94920-']").attr("disabled",false);
	}else{
		$("input[name$='.96045'][class='lable-input']").val("");
		$("input[name$='.96045'][class='lable-input']").hide();
		$("input[type=checkbox][id^='UlcDeviceCause-94920-']").removeAttr("checked");
		$("input[type=checkbox][id^='UlcDeviceCause-94920-']").attr("disabled",true);
	}
	//二、设备设施因素-提供预防压疮相应设施、设备不足
	if($("input[type=checkbox][id='UlcDeviceCause-94921']").is(':checked')){
		$("input[type=checkbox][id^='UlcDeviceCause-94921-']").attr("disabled",false);
	}else{
		$("input[name$='.96050'][class='lable-input']").val("");
		$("input[name$='.96050'][class='lable-input']").hide();
		$("input[type=checkbox][id^='UlcDeviceCause-94921-']").removeAttr("checked");
		$("input[type=checkbox][id^='UlcDeviceCause-94921-']").attr("disabled",true);
	}
	//二、设备设施因素-提供预防压疮相应设施、设备不足
	if($("input[type=checkbox][id='UlcDeviceCause-94922']").is(':checked')){
		$("input[type=checkbox][id^='UlcDeviceCause-94922-']").attr("disabled",false);
	}else{
		$("input[name$='.96054'][class='lable-input']").val("");
		$("input[name$='.96054'][class='lable-input']").hide();
		$("input[type=checkbox][id^='UlcDeviceCause-94922-']").removeAttr("checked");
		$("input[type=checkbox][id^='UlcDeviceCause-94922-']").attr("disabled",true);
	}
	
	//三、材料因素-医疗器具压迫
	if($("input[type=checkbox][id='MatFactor-94925']").is(':checked')){
		$("input[type=checkbox][id^='MatFactor-94925-']").attr("disabled",false);
	}else{
		$("input[name$='.96062'][class='lable-input']").val("");
		$("input[name$='.96062'][class='lable-input']").hide();
		$("input[type=checkbox][id^='MatFactor-94925-']").removeAttr("checked");
		$("input[type=checkbox][id^='MatFactor-94925-']").attr("disabled",true);
	}

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
		title:'科室人员信息',
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
		 {field:'userCode',title:'用户Code',width:100},
		 {field:'userName',title:'用户姓名',width:100}
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
		 },	
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
///处理护理不良事件评价原因分析勾选因素所填写的改进措施   如果input值为改进措施：  则返回""
function getInputValue(id){
	var inputvalue=getHideInputValue(id);
	if(inputvalue=="无"){
		inputvalue="";
	}
	if((inputvalue!="无")&&(inputvalue!="")){
		inputvalue="整改措施："+inputvalue;
	}
	return inputvalue;
	
}
