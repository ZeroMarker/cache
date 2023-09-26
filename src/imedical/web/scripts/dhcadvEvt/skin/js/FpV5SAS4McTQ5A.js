/// Description: 压疮报告单
/// Creator: congyue
/// CreateDate: 2017-12-16
var eventtype=""
var RepDate=formatDate(0); //系统的当前日期
$(document).ready(function(){
	if ((recordId=="")){
		var frm = dhcadvdhcsys_getmenuform();
		if (frm) {
			var papmi = frm.PatientID.value;		
	        var adm = frm.EpisodeID.value;
	        if ((papmi=="")||(papmi=="undefined")){
		        papmi="" ;
		    }
	        $.ajax({
			   	   type: "POST",
			       url: url,
			       async: false, //同步
			       data: "action=getPatNo&patID="+papmi,
			       success: function(val){
				      	 papmi=val;
			       }
			    });	
		    EpisodeID=adm;
		    patientID=papmi;
	        InitPatInfo(papmi,adm);//获取病人信息
		}
	}
	$('#OccuLoc').combobox({ 
		//url:'dhcapp.broker.csp?ClassName=web.DHCADVCOMMONPART&MethodName=QueryLocDescCombo',
		mode:'remote'  //,  //必须设置这个属性
	});
	$("#SaveBut").on("click",function(){
		SaveDrugErrReport(0);
	})
	$("#SubmitBut").on("click",function(){
		SaveDrugErrReport(1);
	})
	//复选框按钮事件
	$("input[type=checkbox]").each(function(){
		$(this).click(function(){
			$(this).is(':checked');
			//setCheckBoxRelation(this.id);
			//InitCheckRadio();
		});
	});
	//复选框按钮事件
	$("input[type=radio]").each(function(){
		$(this).click(function(){
			$(this).is(':checked');
			//setCheckBoxRelation(this.id);
			InitCheckRadio(id);
		});
	});
	
	CheckTimeornum();  //时间校验
	InitCheckRadio();//加载界面checkboxradio在父元素没有勾选的情况下，子元素不可勾选，填写
	InitDrugErrReport(recordId);//加载页面信息
	
});
//加载报表信息
function InitDrugErrReport(recordId)
{
	if((recordId=="")||(recordId==undefined)){
		
		$('#OccuLoc').combobox('setValue',LgCtLocDesc);  //发生科室
		$('#RepHospType').val(LgHospDesc); //报告单位
		
		$('#RepUserName').val(LgUserName); //填报人姓名为登录人
		$('#ReportDate').datebox("setValue",RepDate);   //报告日期
		$('#HospPhone').val("64456715");//联系电话
	
	}else{
		
	} 
}

function SaveDrugErrReport(flag)
{
	///保存前,对页面必填项进行检查
	if(!(checkRequired()&&checkother())){
		return;
	}
	
	//alert(ss);
	var AuditList=""
	
	if(flag==1){
		var AuditList=LgUserID+"^"+LgCtLocID+"^"+LgGroupID+"^"+adrNextLoc+"^"+adrLocAdvice+"^"+adrReceive;
		//AuditList=359+"^"+6+"^"+134+"^"+adrNextLoc+"^"+adrLocAdvice+"^"+adrReceive;
	}
	//数据保存/提交
	var mesageShow=""
	if(flag==0){
		mesageShow="保存"
	}
	if(flag==1){		
		mesageShow="提交"		
	}
	SaveReport(flag)
}
//加载报表病人信息
function InitPatInfo(patientID,EpisodeID)
{
	if((patientID=="")&&(EpisodeID=="")){return;}
	$.ajax({
		type: "POST",
		url: url,
		data: "action=getRepPatInfo&PatNo="+patientID+"&EpisodeID="+EpisodeID,
		success: function(val){
	    	var tmp=val.split("^");
			//病人信息
			$('#DisMedThingPatName').val(tmp[1]); //病人姓名
			$('#DisMedThingPatName').attr("disabled","readonly");
			$('#PatSexinput').val(tmp[3]);  //性别
			$('#PatSexinput').attr("disabled","readonly");
			$('#PatAge').val(tmp[4]);  //年龄
			$('#PatAge').attr("disabled","readonly");
			$('#PatMedicalNo').val(tmp[5]); //病案号
			$('#PatMedicalNo').attr("disabled","readonly");
			$('#PatAdmDate').datebox({disabled:'true'});
			$('#PatAdmDate').datebox("setValue",tmp[8]);  //就诊日期
           	$('#PatDiag').val(tmp[10]);  //诊断
			$('#PatDiag').attr("disabled","readonly");
           	$("#from").form('validate')
		}
	})
}
//检查界面勾选其他，是否填写输入框
function checkother(){
	//患者来源
	var PatOriginoth=0;
	$("input[type=radio][id^='PatOrigin-label']").each(function(){
		if($(this).is(':checked')){
			if ((this.value=="title")&&($("input[name$='.94109']").val()=="")){
				PatOriginoth=-1;
			}
		}
	})
	if(PatOriginoth==-1){
		$.messager.alert("提示:","【患者来源】勾选'其他'，请填写内容！");	
		return false;
	}
	//使用压疮风险评分表
	var UlcerRiskpointtaboth=0;
	$("input[type=radio][id^='UseUlcerRiskpointtab-94932']").each(function(){
		if($(this).is(':checked')){
			if ((this.value=="title")&&($("input[name$='.93878']").val()=="")){
				UlcerRiskpointtaboth=-1;
			}
		}
	})
	if(UlcerRiskpointtaboth==-1){
		$.messager.alert("提示:","【使用压疮风险评分表】勾选'其它'，请填写内容！");	
		return false;
	}
	
	//压疮发生原因 患者因素
	var PatReasonoth=0;
	$("input[type=checkbox][id^='UlcerOccurReason-94948']").each(function(){
		if($(this).is(':checked')){
			if ((this.value=="title")&&($("input[name$='.93950'][class='lable-input']").val()=="")){
				PatReasonoth=-1;
			}
		}
	})
	if(PatReasonoth==-1){
		$.messager.alert("提示:","【压疮发生原因】勾选'患者因素  其他'，请填写内容！");	
		return false;
	}
	//压疮发生原因 病情因素
	var IllnesReasonoth=0;
	$("input[type=checkbox][id^='UlcerOccurReason-94949']").each(function(){
		if($(this).is(':checked')){
			if ((this.value=="title")&&($("input[name$='.93956'][class='lable-input']").val()=="")){
				IllnesReasonoth=-1;
			}
		}
	})
	if(IllnesReasonoth==-1){
		$.messager.alert("提示:","【压疮发生原因】勾选'病情因素  其他'，请填写内容！");	
		return false;
	}
	//压疮发生原因 护理人员因素
	var NurReasonoth=0;
	$("input[type=checkbox][id^='UlcerOccurReason-94950']").each(function(){
		if($(this).is(':checked')){
			if ((this.value=="title")&&($("input[name$='.93966'][class='lable-input']").val()=="")){
				NurReasonoth=-1;
			}
		}
	})
	if(NurReasonoth==-1){
		$.messager.alert("提示:","【压疮发生原因】勾选'护理人员因素  其他'，请填写内容！");	
		return false;
	}
	//压疮发生原因 其他因素
	var PatReasonoth=0;
	$("input[type=checkbox][id^='UlcerOccurReason-94951']").each(function(){
		if($(this).is(':checked')){
			if ((this.value=="title")&&($("input[name$='.93969'][class='lable-input']").val()=="")){
				PatReasonoth=-1;
			}
		}
	})
	if(PatReasonoth==-1){
		$.messager.alert("提示:","【压疮发生原因】勾选'其他因素  其他'，请填写内容！");	
		return false;
	}
	//已采取护理措施(可多选)
	var AdoptNursMeasureoth=0;
	$("input[type=checkbox][id^='AdoptNursMeasure']").each(function(){
		if($(this).is(':checked')){
			if ((this.value=="title")&&($("input[name$='.93979'][class='lable-input']").val()=="")){
				AdoptNursMeasureoth=-1;
			}
		}
	})
	if(AdoptNursMeasureoth==-1){
		$.messager.alert("提示:","【已采取护理措施(可多选)】勾选'其他因素  其他'，请填写内容！");	
		return false;
	}

	return true;
}
//页面初始加载checkbox,radio控制子元素不可以填写
function InitCheckRadio(){
	// 
	//var a=$('#UlcerPart').datagrid('getRows');
	//alert(a);
	//给药时间错误
	if($("input[type=radio][id^='labelUlcerPart-95158-95163-95171.']").is(':checked')){
		//var id=inputid.split(".")[1];
		//var id=this.split(".")[1];
		$("input[type=radio][id^='labelUlcerPart-95158-95163-95171-9'][id$=.'"+id+"']").attr("disabled",false);//医嘱给药时间
	}else{
		var id=inputid.split(".")[1];
		$("input[type=radio][id^='labelUlcerPart-95158-95163-95171-9'][id$=.'"+id+"']").removeAttr("checked");
		$("input[type=radio][id^='labelUlcerPart-95158-95163-95171-9'][id$=.'"+id+"']").attr("disabled",true);
	}	
	
}
//时间 数字校验
function CheckTimeornum(){
	
	//数字输入校验
	//填报人工作年限
	$('#RepUserWorkYears').live("keyup",function(){
		this.value=this.value.replace(/\D/g,'');
	})
}
function add_event(){
	//复选框按钮事件
	$("input[type=radio]").each(function(){
		$(this).click(function(){
			$(this).is(':checked');
			//setCheckBoxRelation(this.id);
			InitCheckRadio();
		});
	});
	
	CheckTimeornum();  //时间校验
	InitCheckRadio();//加载界面checkboxradio在父元素没有勾选的情况下，子元素不可勾选，填写
	
	
}
