/// Description: 跌倒坠床护士长评价单评价界面 
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
	InitCheckRadio();//加载界面checkboxradio在父元素没有勾选的情况下，子元素不可勾选，填写
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
			//setCheckBoxRelation(this.id);
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
	});
	// 晨会报告日期控制 sufan 2019-06-18 表单统一去掉晨会部
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
	bodywidth=$("body").width();
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

function setManImprove()
{
    var list="",PersonFactor="",DiviceFactor="",ManaFactor="",EnvirFactor="";
    var i=0,j=0,k=0,l=0;
    var PersonFactorlist="",DiviceFactorlist="",ManaFactorlist="",EnvirFactorlist="";
	$("input[id^='PersonFactor']").each(function(){  
		if($(this).is(':checked')){                
			if(this.id.indexOf("PersonFactor-94800-94803")>=0) {         //患者因素-患者患有疾病或生理功能障碍
				if(this.id.indexOf("PersonFactor-94800-94803-94815")>=0){  //患者因素-患者患有疾病或生理功能障碍-疾病
					i=i+1;
					if($(this).val()==$g("疾病")){
						i=i-1;
						PersonFactor="";
					}else{
						PersonFactor=i+"、"+$g("患者因素")+"——"+$g("患者患有疾病或生理功能障碍")+"——"+$g("疾病")+"："+this.parentElement.innerText+"			"+getInputValue(this.id)+"\n";
					}
					PersonFactorlist=PersonFactorlist+PersonFactor;
				}else if(this.id.indexOf("PersonFactor-94800-94803-94957")>=0) { //患者因素-患者患有疾病或生理功能障碍-突发病情变化
					i=i+1;
					if($(this).val()==$g("突发病情变化")){
						i=i-1;
						PersonFactor="";
					}else{
						PersonFactor=i+"、"+$g("患者因素")+"——"+$g("患者患有疾病或生理功能障碍")+"——"+$g("突发病情变化")+"："+this.parentElement.innerText+"			"+getInputValue(this.id)+"\n";
					}
					PersonFactorlist=PersonFactorlist+PersonFactor;
				}else{  
			    	i=i+1;
					PersonFactor=i+"、"+$g("患者因素")+"——"+$g("患者患有疾病或生理功能障碍")+"："+this.parentElement.innerText+"			"+getInputValue(this.id)+"\n";
			    	PersonFactorlist=PersonFactorlist+PersonFactor;
				}
			
			}
			if(this.id.indexOf("PersonFactor-94800-94804")>=0){        //患者因素——患者依从性差               
				i=i+1;
				PersonFactor=i+"、"+$g("患者因素")+"——"+$g("患者依从性差")+"："+this.parentElement.innerText+"			"+getInputValue(this.id)+"\n";
				PersonFactorlist=PersonFactorlist+PersonFactor;
			}
			if(this.id.indexOf("PersonFactor-94800-94805")>=0){     //患者因素——患者自我认知能力差 
				i=i+1;	
				PersonFactor=i+"、"+$g("患者因素")+"——"+$g("患者自我认知能力差")+"："+this.parentElement.innerText+"			"+getInputValue(this.id)+"\n";
				PersonFactorlist=PersonFactorlist+PersonFactor;
			} 

			if(this.id.indexOf("PersonFactor-94801")>=0) { //患者因素——家属（家长）或陪护人员
				i=i+1;	
				PersonFactor=i+"、"+$g("家属（家长）或陪护人员")+"："+this.parentElement.innerText+"			"+getInputValue(this.id)+"\n";
				PersonFactorlist=PersonFactorlist+PersonFactor;
			} 

			if(this.id.indexOf("PersonFactor-94802-94806")>=0){ //护理人员——评估不到位
				i=i+1;	
				PersonFactor=i+"、"+$g("护理人员")+"——"+$g("评估不到位")+"："+this.parentElement.innerText+"			"+getInputValue(this.id)+"\n";
				PersonFactorlist=PersonFactorlist+PersonFactor;
			}

			if(this.id.indexOf("PersonFactor-94802-94807")>=0){ //护理人员——安全措施落实不到位
				i=i+1;	
				PersonFactor=i+"、"+$g("护理人员")+"——"+$g("安全措施落实不到位")+"："+this.parentElement.innerText+"			"+getInputValue(this.id)+"\n";
				PersonFactorlist=PersonFactorlist+PersonFactor;
			}  
		}
	});
	if(PersonFactorlist!=""){
		list=list+"\n"+$g("一、人员因素")+"\n"+PersonFactorlist;
	}

	$("input[id^='DiviceFactor']").each(function(){
		if($(this).is(':checked')){
			if(this.id.indexOf("DiviceFactor-94874")>=0){   //床档
				j=j+1;
				DiviceFactor=j+"、"+$g("床档")+"："+this.parentElement.innerText+"			"+getInputValue(this.id)+"\n";
				DiviceFactorlist=DiviceFactorlist+DiviceFactor;
			}
			if(this.id.indexOf("DiviceFactor-94875")>=0){
				j=j+1;
				DiviceFactor=j+"、"+$g("轮椅平车")+"："+this.parentElement.innerText+"			"+getInputValue(this.id)+"\n";
				DiviceFactorlist=DiviceFactorlist+DiviceFactor	;
			}
			if(this.id.indexOf("DiviceFactor-94876")>=0){
				j=j+1;
				DiviceFactor=j+"、"+$g("呼叫系统")+"："+this.parentElement.innerText+"			"+getInputValue(this.id)+"\n";
				DiviceFactorlist=DiviceFactorlist+DiviceFactor;	
			}
			if(this.id.indexOf("DiviceFactor-94877")>=0) {
				j=j+1;
				DiviceFactor=j+"、"+$g("防滑设施")+"："+this.parentElement.innerText+"			"+getInputValue(this.id)+"\n";
				DiviceFactorlist=DiviceFactorlist+DiviceFactor;	
			}

			if(this.id.indexOf("DiviceFactor-94878")>=0){
				j=j+1;
				DiviceFactor=j+"、"+$g("卫生间、洗浴间设施障碍")+"："+this.parentElement.innerText+"			"+getInputValue(this.id)+"\n";
				DiviceFactorlist=DiviceFactorlist+DiviceFactor;	
			}
			if(this.id.indexOf("DiviceFactor-94879")>=0){
				j=j+1;
				DiviceFactor=j+"、"+this.parentElement.innerText+"			"+getInputValue(this.id)+"\n";
				DiviceFactorlist=DiviceFactorlist+DiviceFactor;	
			}
		}
	});	
	if(DiviceFactorlist!=""){
		list=list+"\n"+$g("二、机：设备因素")+"\n"+DiviceFactorlist;
	}

	$("input[id^='ManaFactor']").each(function(){
		if($(this).is(':checked')){
			k=k+1;
			ManaFactor=k+"、"+this.parentElement.innerText+"			"+getInputValue(this.id)+"\n";
			ManaFactorlist=ManaFactorlist+ManaFactor;

		}
	});
	if(ManaFactorlist!=""){
		list=list+"\n"+$g("三、法：方法、政策、管理因素")+"\n"+ManaFactorlist;
	}
		
	$("input[id^='EnvirFactor']").each(function(){
		if($(this).is(':checked')){
			l=l+1;
			EnvirFactor=l+"、"+this.parentElement.innerText+"			"+getInputValue(this.id)+"\n";
			EnvirFactorlist=EnvirFactorlist+EnvirFactor;
		}
	});
	if(EnvirFactorlist!=""){
		list=list+"\n"+$g("四、环：环境因素（温湿度、噪音、照明等）")+"\n"+EnvirFactorlist;
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
	//患者因素-患者患有疾病或生理功能障碍  疾病
	var PersonFactorjboth=0,PersonFactorjb="",PersonFactorjbList="";
	$("input[type=checkbox][id='PersonFactor-94800-94803-94815']").each(function(){
		if ($(this).is(':checked')){
			PersonFactorjb=this.value;
		}
	})
	if(PersonFactorjb==$g("疾病")){
		$("input[type=checkbox][id^='PersonFactor-94800-94803-94815-']").each(function(){
			if (($(this).is(':checked'))&&(this.value!="")){
				PersonFactorjbList=this.value
			}
		})
		if (PersonFactorjbList==""){
			$.messager.alert($g("提示:"),"【"+$g("患者因素")+"-"+$g("患者患有疾病或生理功能障碍")+"】"+$g("勾选")+$g('疾病')+"，"+$g("请勾选相应内容")+"！");	
			return false;
		}
	}
	$("input[type=checkbox][id^='PersonFactor-94800-94803-94815-94955']").each(function(){
		if($(this).is(':checked')){
			if ((this.value=="title")&&($("input[name$='.95725'][class='lable-input']").val()=="")){
				PersonFactorjboth=-1;
			}
		}
	})
	if(PersonFactorjboth==-1){
		$.messager.alert($g("提示:"),"【"+$g("患者因素")+"-"+$g("患者患有疾病或生理功能障碍")+"-"+$g("疾病")+"】"+$g("勾选")+$g('其他')+"，"+$g("请填写内容")+"！");	
		return false;
	}
	//患者因素-患者患有疾病或生理功能障碍  突发病情变化
	var PersonFactortfoth=0,PersonFactortf="",PersonFactortfList="";
	$("input[type=checkbox][id='PersonFactor-94800-94803-94957']").each(function(){
		if ($(this).is(':checked')){
			PersonFactortf=this.value;
		}
	})
	if(PersonFactortf==$g("突发病情变化")){
		$("input[type=checkbox][id^='PersonFactor-94800-94803-94957-']").each(function(){
			if (($(this).is(':checked'))&&(this.value!="")){
				PersonFactortfList=this.value
			}
		})
		if (PersonFactortfList==""){
			$.messager.alert($g("提示:"),"【"+$g("患者因素")+"-"+$g("患者患有疾病或生理功能障碍")+"】"+$g("勾选")+$g('突发病情变化')+"，"+$g("请勾选相应内容")+"！");	
			return false;
		}
	}
	$("input[type=checkbox][id^='PersonFactor-94800-94803-94957-94965']").each(function(){
		if($(this).is(':checked')){
			if ((this.value=="title")&&($("input[name$='.95735'][class='lable-input']").val()=="")){
				PersonFactortfoth=-1;
			}
		}
	})
	if(PersonFactortfoth==-1){
		$.messager.alert($g("提示:"),"【"+$g("患者因素")+"-"+$g("患者患有疾病或生理功能障碍")+"-"+$g("突发病情变化")+"】"+$g("勾选")+$g('其他')+"，"+$g("请填写内容")+"！");	
		return false;
	}
	//患者因素-患者依从性差
	var PersonFactorycxoth=0;
	$("input[type=checkbox][id^='PersonFactor-94800-94804-94872']").each(function(){
		if($(this).is(':checked')){
			if ((this.value=="title")&&($("input[name$='.95743'][class='lable-input']").val()=="")){
				PersonFactorycxoth=-1;
			}
		}
	})
	if(PersonFactorycxoth==-1){
		$.messager.alert($g("提示:"),"【"+$g("患者因素")+"-"+$g("患者依从性差")+"】"+$g("勾选")+$g('其他')+"，"+$g("请填写内容")+"！");	
		return false;
	}
	//患者因素-患者自我认知能力差
	var PersonFactorrzoth=0;
	$("input[type=checkbox][id^='PersonFactor-94800-94805-94845']").each(function(){
		if($(this).is(':checked')){
			if ((this.value=="title")&&($("input[name$='.95748'][class='lable-input']").val()=="")){
				PersonFactorrzoth=-1;
			}
		}
	})
	if(PersonFactorrzoth==-1){
		$.messager.alert($g("提示:"),"【"+$g("患者因素")+"-"+$g("患者自我认知能力差")+"】"+$g("勾选")+$g('其他')+"，"+$g("请填写内容")+"！");	
		return false;
	}
	
	//家属（家长）或陪护人员
	var PersonFactorjsoth=0;
	$("input[type=checkbox][id^='PersonFactor-94801-94853']").each(function(){
		if($(this).is(':checked')){
			if ((this.value=="title")&&($("input[name$='.95757'][class='lable-input']").val()=="")){
				PersonFactorjsoth=-1;
			}
		}
	})
	if(PersonFactorjsoth==-1){
		$.messager.alert($g("提示:"),"【"+$g("家属（家长）或陪护人员")+"】"+$g("勾选")+$g('其他')+"，"+$g("请填写内容")+"！");	
		return false;
	}

	//护理人员-评估不到位
	var PersonFactorhlpgoth=0;
	$("input[type=checkbox][id^='PersonFactor-94802-94806-94862']").each(function(){
		if($(this).is(':checked')){
			if ((this.value=="title")&&($("input[name$='.95768'][class='lable-input']").val()=="")){
				PersonFactorhlpgoth=-1;
			}
		}
	})
	if(PersonFactorhlpgoth==-1){
		$.messager.alert($g("提示:"),"【"+$g("护理人员")+"-"+$g("评估不到位")+"】"+$g("勾选")+$g('其他')+"，"+$g("请填写内容")+"！");	
		return false;
	}
	//护理人员-安全措施落实不到位
	var PersonFactorhlcsoth=0;
	$("input[type=checkbox][id^='PersonFactor-94802-94807-94870']").each(function(){
		if($(this).is(':checked')){
			if ((this.value=="title")&&($("input[name$='.95777'][class='lable-input']").val()=="")){
				PersonFactorhlcsoth=-1;
			}
		}
	})
	if(PersonFactorhlcsoth==-1){
		$.messager.alert($g("提示:"),"【"+$g("护理人员")+"-"+$g("安全措施落实不到位")+"】"+$g("勾选")+$g('其他')+"，"+$g("请填写内容")+"！");	
		return false;
	}
	
	//三、法：方法、政策、管理因素
	var ManaFactoroth=0;
	$("input[type=checkbox][id^='ManaFactor-94904']").each(function(){
		if($(this).is(':checked')){
			if ((this.value=="title")&&($("input[name$='.95809'][class='lable-input']").val()=="")){
				ManaFactoroth=-1;
			}
		}
	})
	if(ManaFactoroth==-1){
		$.messager.alert($g("提示:"),"【"+$g("法：方法、政策、管理因素")+"】"+$g("勾选")+$g('其他')+"，"+$g("请填写内容")+"！");	
		return false;
	}
	
	//四、环：环境因素（温湿度、噪音、照明等）
	var EnvirFactoroth=0;
	$("input[type=checkbox][id^='EnvirFactor-94912']").each(function(){
		if($(this).is(':checked')){
			if ((this.value=="title")&&($("input[name$='.95816'][class='lable-input']").val()=="")){
				EnvirFactoroth=-1;
			}
		}
	})
	if(EnvirFactoroth==-1){
		$.messager.alert($g("提示:"),"【"+$g("环境因素（温湿度、噪音、照明等）")+"】"+$g("勾选")+$g('其他')+"，"+$g("请填写内容")+"！");	
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
//页面初始加载checkbox,radio控制子元素不可以填写
function InitCheckRadio(){
	//患者因素-患者患有疾病或生理功能障碍  疾病
	if($("input[type=checkbox][id='PersonFactor-94800-94803-94815']").is(':checked')){
		$("input[type=checkbox][id^='PersonFactor-94800-94803-94815-']").attr("disabled",false);

	}else{
		$("input[name$='.95725'][class='lable-input']").val("");
		$("input[name$='.95725'][class='lable-input']").hide();
		$("input[type=checkbox][id^='PersonFactor-94800-94803-94815-']").removeAttr("checked");
		$("input[type=checkbox][id^='PersonFactor-94800-94803-94815-']").attr("disabled",true);
		$("input[type=checkbox][id^='PersonFactor-94800-94803-94815-']").nextAll(".lable-input").hide();
	}	
	//患者因素-患者患有疾病或生理功能障碍  突发病情变化
	if($("input[type=checkbox][id='PersonFactor-94800-94803-94957']").is(':checked')){
		$("input[type=checkbox][id^='PersonFactor-94800-94803-94957-']").attr("disabled",false);
	}else{
		$("input[name$='.95735'][class='lable-input']").val("");
		$("input[name$='.95735'][class='lable-input']").hide();
		$("input[type=checkbox][id^='PersonFactor-94800-94803-94957-']").removeAttr("checked");
		$("input[type=checkbox][id^='PersonFactor-94800-94803-94957-']").attr("disabled",true);
		$("input[type=checkbox][id^='PersonFactor-94800-94803-94957-']").nextAll(".lable-input").hide();
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
			$.messager.alert($g("提示:"),"审核错误,错误原因:"+"<font style='color:red;'>"+jsonString.ErrMsg+"</font>");   ///+"第"+errnum+"条数据"
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
		$.messager.alert($g("提示:"),"报告为驳回报告，且未驳回给当前登录人，无权限撤销审核！");
		return;
	}
	//保存数据
	runClassMethod("web.DHCADVCOMMONPART","CancelAuditReport",{'params':CancelAuditList},
	function(jsonString){ 
		if(jsonString.ErrCode < 0){
			$.messager.alert($g("提示:"),"撤销审核错误,错误原因:"+"<font style='color:red;'>"+jsonString.ErrMsg+"</font>");   ///+"第"+errnum+"条数据"
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
