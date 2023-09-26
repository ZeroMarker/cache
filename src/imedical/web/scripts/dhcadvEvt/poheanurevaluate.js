/// Description: 管路滑脱护士长评价单评价界面 
/// Creator: congyue
/// CreateDate: 2018-04-13
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
	})
	//单选框按钮事件
	$("input[type=radio]").each(function(){
		$(this).click(function(){
			$(this).is(':checked');
			//setCheckBoxRelation(this.id);
			InitCheckRadio();
			setManImprove()
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
	var EvaData=EvaFlagList.replace(/(^\s*)|(\s*$)/g,"").split("^");
	AssessFlag=EvaData[0];
	LocHeadNurEvaFlag=EvaData[1];
	NurDepEvaFlag=EvaData[2];
	if(EvaRecordId!=""){ 
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
				$('a:contains("删除")').parent().hide();
			}
			if(AssessFlag!="Y"){
				$("[id^='"+rowid+"'][id$='"+rownum+"']").attr("readonly",'readonly');
				$("input[id^='"+rowid+"'][id$='"+rownum+"']").datebox({"disabled":true});
				$('a:contains("增加")').parent().hide();
			}

		})
	}

}
//按钮控制与方法绑定
function InitButton(){
	$("#AsseSaveBut").on("click",function(){
		SaveAsse(0);
	})
	/* //晨会人员 添加按钮事件
	$('#MorRepMeetAddBut').on("click",function(){
		StaffEnter();
	}) */
	 
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
    var list="",POHumFactor="",POMatFactor="",POManaFactor="",POEnvirFactor="",POOthFactor="";
    var i=0,j=0,k=0,l=0,h=0
    var POHumFactorlist="",POMatFactorlist="",POManaFactorlist="",POEnvirFactorlist="",POOthFactorlist=""; 
	$("input[id^='POHumFactor']").each(function(){  //PersonFactor-94800-94803-94815-94945  PersonFactor-94800-94803-94815
		if($(this).is(':checked')){                //PersonFactor-94800-94803
			if(this.id.indexOf("POHumFactor-94279")>=0){ //患者因素	
				i=i+1;
				POHumFactor=i+"、"+"患者因素："+this.parentElement.innerText+"			"+getInputValue(this.id)+"\n";
				POHumFactorlist=POHumFactorlist+POHumFactor;
			}
			if(this.id.indexOf("POHumFactor-94280-94295")>=0){     //护士因素——评估不当
				i=i+1;	
				POHumFactor=i+"、"+"护士因素——评估不当："+this.parentElement.innerText+"			"+getInputValue(this.id)+"\n";
				POHumFactorlist=POHumFactorlist+POHumFactor;
			} 
			if(this.id.indexOf("POHumFactor-94280-94296")>=0){     //护士因素——约束不当
				i=i+1;	
				POHumFactor=i+"、"+"护士因素——约束不当："+this.parentElement.innerText+"			"+getInputValue(this.id)+"\n";
				POHumFactorlist=POHumFactorlist+POHumFactor;
			} 
			if(this.id.indexOf("POHumFactor-94280-94297")>=0){     //护士因素——置管及固定不当
				i=i+1;	
				POHumFactor=i+"、"+"护士因素——置管及固定不当："+this.parentElement.innerText+"			"+getInputValue(this.id)+"\n";
				POHumFactorlist=POHumFactorlist+POHumFactor;
			} 
			if(this.id.indexOf("POHumFactor-94280-94298")>=0){     //护士因素——健康教育不当
				i=i+1;	
				POHumFactor=i+"、"+"护士因素——健康教育不当："+this.parentElement.innerText+"			"+getInputValue(this.id)+"\n";
				POHumFactorlist=POHumFactorlist+POHumFactor;
			} 
			if(this.id.indexOf("POHumFactor-94281")>=0){ //医生因素	
				i=i+1;
				POHumFactor=i+"、"+"医生因素："+this.parentElement.innerText+"			"+getInputValue(this.id)+"\n";
				POHumFactorlist=POHumFactorlist+POHumFactor
			}
			if(this.id.indexOf("POHumFactor-94283")>=0){ //其他因素	
				i=i+1;
				POHumFactor=i+"、"+"其他因素："+this.parentElement.innerText+"			"+getInputValue(this.id)+"\n";
				POHumFactorlist=POHumFactorlist+POHumFactor;
			}
		}
	});
	if(POHumFactorlist!=""){
		list=list+"\n"+"一、人员因素（医护、患者、陪护）"+"\n"+POHumFactorlist;
	}

	$("input[id^='POMatFactor']").each(function(){
		if($(this).is(':checked')){
			if(this.id.indexOf("POMatFactor-94348-")>=0){	//材料因素——导管或固定器具在使用中出现故障
				i=i+1;
				POMatFactor=i+"、"+"材料因素——导管或固定器具在使用中出现故障："+this.parentElement.innerText+"			"+getInputValue(this.id)+"\n";
				POMatFactorlist=POMatFactorlist+POMatFactor;
			} 
			if(this.id.indexOf("POMatFactor-94349-")>=0){	//材料因素——缺少相应的固定材
				i=i+1;
				POMatFactor=i+"、"+"材料因素——缺少相应的固定材："+this.parentElement.innerText+"			"+getInputValue(this.id)+"\n";
				POMatFactorlist=POMatFactorlist+POMatFactor;
			}
			if(this.id.indexOf("POMatFactor-94350")>=0){	//材料因素——其他
				i=i+1;
				POMatFactor=i+"、"+"材料因素——其他："+this.parentElement.innerText+"			"+getInputValue(this.id)+"\n";
				POMatFactorlist=POMatFactorlist+POMatFactor;
			}   
		}
	});	
	if(POMatFactorlist!=""){
		list=list+"\n"+"二、物：材料因素"+"\n"+POMatFactorlist;
	}
		
	$("input[id^='POManaFactor']").each(function(){
		if($(this).is(':checked')){
			k=k+1;
			POManaFactor=k+"、"+this.parentElement.innerText+"			"+getInputValue(this.id)+"\n";
			POManaFactorlist=POManaFactorlist+POManaFactor;
		}
	});
	if(POManaFactorlist!=""){
		list=list+"\n"+"三、法：方法、政策、管理因素"+"\n"+POManaFactorlist;
	}
	
	$("input[id^='POEnvirFactor']").each(function(){
		if($(this).is(':checked')){
			l=l+1;
			POEnvirFactor=l+"、"+this.parentElement.innerText+"			"+getInputValue(this.id)+"\n";
			POEnvirFactorlist=POEnvirFactorlist+POEnvirFactor;
		}
	});
	if(POEnvirFactorlist!=""){
		list=list+"\n"+"四、环：环境因素（温湿度、噪音、照明等）"+"\n"+POEnvirFactorlist;
	}
	
	$("input[id^='POOthFactor']").each(function(){
		if($(this).is(':checked')){
			h=h+1;
			POOthFactor=h+"、"+this.parentElement.innerText+"			"+getInputValue(this.id)+"\n";
			POOthFactorlist=POOthFactorlist+POOthFactor;
		}
	});
	if(POOthFactorlist!=""){
		list=list+"\n"+"五、其他因素"+"\n"+POOthFactorlist;
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
	//患者因素
	var POHumFactorhzoth=0;
	$("input[type=checkbox][id^='POHumFactor-94279-']").each(function(){
		if($(this).is(':checked')){
			if ((this.value=="title")&&($("input[name$='.94294'][class='lable-input']").val()=="")){
				POHumFactorhzoth=-1;
			}
		}
	})
	if(POHumFactorhzoth==-1){
		$.messager.alert("提示:","【患者因素】勾选'其他'，请填写内容！");	
		return false;
	}
	//护士因素-评估不当
	var POHumFactorhspgoth=0;
	$("input[type=checkbox][id^='POHumFactor-94280-94295-']").each(function(){
		if($(this).is(':checked')){
			if ((this.value=="title")&&($("input[name$='.94309'][class='lable-input']").val()=="")){
				POHumFactorhspgoth=-1;
			}
		}
	})
	if(POHumFactorhspgoth==-1){
		$.messager.alert("提示:","【护士因素-评估不当】勾选'其他'，请填写内容！");	
		return false;
	}
	//护士因素-约束不当
	var POHumFactorhsysoth=0;
	$("input[type=checkbox][id^='POHumFactor-94280-94296-']").each(function(){
		if($(this).is(':checked')){
			if ((this.value=="title")&&($("input[name$='.94316'][class='lable-input']").val()=="")){
				POHumFactorhsysoth=-1;
			}
		}
	})
	if(POHumFactorhsysoth==-1){
		$.messager.alert("提示:","【护士因素-约束不当】勾选'其他'，请填写内容！");	
		return false;
	}
	
	//护士因素-置管及固定不当
	var POHumFactorhszgoth=0;
	$("input[type=checkbox][id^='POHumFactor-94280-94297-']").each(function(){
		if($(this).is(':checked')){
			if ((this.value=="title")&&($("input[name$='.94324'][class='lable-input']").val()=="")){
				POHumFactorhszgoth=-1;
			}
		}
	})
	if(POHumFactorhszgoth==-1){
		$.messager.alert("提示:","【护士因素-置管及固定不当】勾选'其他'，请填写内容！");	
		return false;
	}
	//护士因素-健康教育不当
	var POHumFactorhsjkjyoth=0;
	$("input[type=checkbox][id^='POHumFactor-94280-94298-']").each(function(){
		if($(this).is(':checked')){
			if ((this.value=="title")&&($("input[name$='.94328'][class='lable-input']").val()=="")){
				POHumFactorhsjkjyoth=-1;
			}
		}
	})
	if(POHumFactorhsjkjyoth==-1){
		$.messager.alert("提示:","【护士因素-健康教育不当】勾选'其他'，请填写内容！");	
		return false;
	}
	//医生因素
	var POHumFactorysoth=0;
	$("input[type=checkbox][id^='POHumFactor-94281-']").each(function(){
		if($(this).is(':checked')){
			if ((this.value=="title")&&($("input[name$='.94336'][class='lable-input']").val()=="")){
				POHumFactorysoth=-1;
			}
		}
	})
	if(POHumFactorysoth==-1){
		$.messager.alert("提示:","【医生因素】勾选'其他'，请填写内容！");	
		return false;
	}
	//其他因素
	var POHumFactoroth=0;
	$("input[type=checkbox][id^='POHumFactor-94283-']").each(function(){
		if($(this).is(':checked')){
			if ((this.value=="title")&&($("input[name$='.94347'][class='lable-input']").val()=="")){
				POHumFactoroth=-1;
			}
		}
	})
	if(POHumFactoroth==-1){
		$.messager.alert("提示:","【其他因素】勾选'其他'，请填写内容！");	
		return false;
	}

	//材料因素-导管或固定器具在使用中出现故障
	var POMatFactordgoth=0,POMatFactordg="",POMatFactordgList="";
	$("input[type=checkbox][id='POMatFactor-94348']").each(function(){
		if ($(this).is(':checked')){
			POMatFactordg=this.value;
		}
	})
	if(POMatFactordg=="导管或固定器具在使用中出现故障"){
		$("input[type=checkbox][id^='POMatFactor-94348-']").each(function(){
			if (($(this).is(':checked'))&&(this.value!="")){
				POMatFactordgList=this.value
			}
		})
		if (POMatFactordgList==""){
			$.messager.alert("提示:","【材料因素】勾选'导管或固定器具在使用中出现故障'，请勾选相应内容！");	
			return false;
		}
	}
	$("input[type=checkbox][id^='POMatFactor-94348-']").each(function(){
		if($(this).is(':checked')){
			if ((this.value=="title")&&($("input[name$='.94356'][class='lable-input']").val()=="")){
				POMatFactordgoth=-1;
			}
		}
	})
	if(POMatFactordgoth==-1){
		$.messager.alert("提示:","【材料因素-导管或固定器具在使用中出现故障】勾选'其他'，请填写内容！");	
		return false;
	}
	
	//材料因素-缺少相应的固定材
	var POMatFactorqsoth=0,POMatFactorqs="",POMatFactorqsList="";
	$("input[type=checkbox][id='POMatFactor-94349']").each(function(){
		if ($(this).is(':checked')){
			POMatFactorqs=this.value;
		}
	})
	if(POMatFactorqs=="缺少相应的固定材"){
		$("input[type=checkbox][id^='POMatFactor-94349-']").each(function(){
			if (($(this).is(':checked'))&&(this.value!="")){
				POMatFactorqsList=this.value
			}
		})
		if (POMatFactorqsList==""){
			$.messager.alert("提示:","【材料因素】勾选'缺少相应的固定材'，请勾选相应内容！");	
			return false;
		}
	}
	$("input[type=checkbox][id^='POMatFactor-94349-']").each(function(){
		if($(this).is(':checked')){
			if ((this.value=="title")&&($("input[name$='.94359'][class='lable-input']").val()=="")){
				POMatFactorqsoth=-1;
			}
		}
	})
	if(POMatFactorqsoth==-1){
		$.messager.alert("提示:","【缺少相应的固定材】勾选'其他'，请填写内容！");	
		return false;
	}
	//材料因素
	var POMatFactoroth=0;
	$("input[type=checkbox][id^='POMatFactor-']").each(function(){
		if($(this).is(':checked')){
			if ((this.value=="title")&&($("input[name$='.94350'][class='lable-input']").val()=="")){
				POMatFactoroth=-1;
			}
		}
	})
	if(POMatFactoroth==-1){
		$.messager.alert("提示:","【材料因素】勾选'其他'，请填写内容！");	
		return false;
	}
	//三、法：方法、政策、管理因素
	var POManaFactoroth=0;
	$("input[type=checkbox][id^='POManaFactor-']").each(function(){
		if($(this).is(':checked')){
			if ((this.value=="title")&&($("input[name$='.94365'][class='lable-input']").val()=="")){
				POManaFactoroth=-1;
			}
		}
	})
	if(POManaFactoroth==-1){
		$.messager.alert("提示:","【方法、政策、管理因素】勾选'其他'，请填写内容！");	
		return false;
	}
	
	//四、环：环境因素（温湿度、噪音、照明等）
	var POEnvirFactoroth=0;
	$("input[type=checkbox][id^='POEnvirFactor-']").each(function(){
		if($(this).is(':checked')){
			if ((this.value=="title")&&($("input[name$='.94368'][class='lable-input']").val()=="")){
				POEnvirFactoroth=-1;
			}
		}
	})
	if(POEnvirFactoroth==-1){
		$.messager.alert("提示:","【环境因素（温湿度、噪音、照明等）】勾选'其他'，请填写内容！");	
		return false;
	}
	//五、其他
	var POOthFactor=0;
	$("input[type=checkbox][id^='POOthFactor']").each(function(){
		if($(this).is(':checked')){
			if ((this.value=="title")&&($("input[name$='.94287'][class='lable-input']").val()=="")){
				POOthFactor=-1;
			}
		}
	})
	if(POOthFactor==-1){
		$.messager.alert("提示:","【原因分析其他】勾选'其他'，请填写内容！");	
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
	//二、物：材料因素  导管或固定器具在使用中出现故障
	if($("input[type=checkbox][id='POMatFactor-94348']").is(':checked')){
		$("input[type=checkbox][id^='POMatFactor-94348-']").attr("disabled",false);

	}else{
		$("input[name$='.94356'][class='lable-input']").val("");
		$("input[name$='.94356'][class='lable-input']").hide();
		$("input[type=checkbox][id^='POMatFactor-94348-']").removeAttr("checked");
		$("input[type=checkbox][id^='POMatFactor-94348-']").attr("disabled",true);
		$("input[type=checkbox][id^='POMatFactor-94348-']").nextAll(".lable-input").hide();
	}	
	//二、物：材料因素   缺少相应的固定材
	if($("input[type=checkbox][id='POMatFactor-94349']").is(':checked')){
		$("input[type=checkbox][id^='POMatFactor-94349-']").attr("disabled",false);
	}else{
		$("input[name$='.94359'][class='lable-input']").val("");
		$("input[name$='.94359'][class='lable-input']").hide();
		$("input[type=checkbox][id^='POMatFactor-94349-']").removeAttr("checked");
		$("input[type=checkbox][id^='POMatFactor-94349-']").attr("disabled",true);
		$("input[type=checkbox][id^='POMatFactor-94349-']").nextAll(".lable-input").hide();
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
	   collapsible:true,
	   border:false,
	   closed:"true",
	   modal:true,
	   width:500,
	   height:400
	 }); 
    $('#staffwin').window('open');
    $("#UserNames").val("");
    $('#MonAdd').hide();// 添加晨会人员按钮隐藏
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
