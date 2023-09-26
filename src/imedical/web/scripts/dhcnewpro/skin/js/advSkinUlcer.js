/// Description: 压疮报告单
/// Creator: congyue
/// CreateDate: 2017-12-19
var eventtype=""
var RepDate=formatDate(0); //系统的当前日期
$(document).ready(function(){
	if ((recordId=="")){
		var frm = dhcadvdhcsys_getmenuform();
		if (frm) {
	        var adm = frm.EpisodeID.value;
		    EpisodeID=adm;
	        InitPatInfo(adm);//获取病人信息
		}
	}
	$('#OccuLoc').combobox({ 
		//url:'dhcapp.broker.csp?ClassName=web.DHCADVCOMMONPART&MethodName=QueryLocDescCombo',
		mode:'remote',  //,  //必须设置这个属性
		onShowPanel:function(){ 
			$('#OccuLoc').combobox('reload','dhcapp.broker.csp?ClassName=web.DHCADVCOMMONPART&MethodName=QueryLocDescCombo&hospId='+LgHospID+'')
		}
	});
	
	/*//科室1
	$('#DeptLocOne').combobox({ 
		url:'dhcapp.broker.csp?ClassName=web.DHCADVCOMMONPART&MethodName=GetAutLocCombox',
		mode:'remote',  //必须设置这个属性
		onSelect: function(rec){  
           var LocOneDr=rec.value; 
			ComboboxLocTwo(LocOneDr);        
	  }
	});*/
	$("#SaveBut").on("click",function(){
		SaveUlcerReport(0);
	})
	$("#SubmitBut").on("click",function(){
		SaveUlcerReport(1);
	})
	//复选框按钮事件
	$("input[type=checkbox]").each(function(){
		$(this).click(function(){
			$(this).is(':checked');
			InitCheck(this.id);
		});
	});
	//单选框按钮事件
	$("input[type=radio]").each(function(){
		$(this).click(function(){
			$(this).is(':checked');
			InitRadio(this.id);
		});
	});	
	//入院时间控制
	$('#PatAdmDate').datebox().datebox('calendar').calendar({
		validator: function(date){
			var now = new Date();
			return date<=now;
		}
	});
	//报告日期控制
	$('#ReportDate').datebox().datebox('calendar').calendar({
		validator: function(date){
			var now = new Date();
			return date<=now;
		}
	});
	//发现日期控制
	$("input[id^='UlcerPart-95158-95162-95192']").datebox().datebox('calendar').calendar({
		validator: function(date){
			var now = new Date();
			return date<=now;
		}
	});
	CheckTimeornum();  //时间校验
	InitCheckRadio();//加载界面checkboxradio在父元素没有勾选的情况下，子元素不可勾选，填写
	//部位 
	$("input[type=radio][id^='UlcerPart-95158-95166']").each(function(){
		if ($(this).is(':checked')){
			var checkrowid=this.id.split(".")[0];
			var checkrownum=this.id.split(".")[1];
			$("input:not([id$='"+checkrownum+"'])input[type=checkbox][id^='"+checkrowid+"']").attr("disabled",true);
		}
	})
	
	PatMedNoEnter();//病案号回车事件
	PatIDEnter();//登记号回车事件
	InitUlcerReport(recordId);//加载页面信息
});
//加载报表信息
function InitUlcerReport(recordId)
{
	if((recordId=="")||(recordId==undefined)){
		
		$('#OccuLoc').combobox('setValue',LgCtLocDesc);  //发生科室
		$('#RepHospType').val(LgHospDesc); //报告单位
		$('#RepHospType').attr("readonly","readonly"); //报告单位
		$('#RepUserName').val(LgUserName); //填报人姓名为登录人
		$('#RepUserName').attr("readonly","readonly");//填报人姓名为登录
		if(LgGroupDesc=="护理部"){
			$('#ReportDate').datebox({disabled:false});//报告日期
		}else{
			$('#ReportDate').datebox({disabled:'true'});//报告日期
		}
		$('#ReportDate').datebox("setValue",RepDate);   //报告日期
		//$('#HospPhone').val("64456715");//联系电话
		//$('#HospPhone').attr("readonly","readonly"); //联系电话		
		//病人信息	 
		$('#DisMedThingPatName').attr("readonly","readonly");//病人姓名	
	}else{
		//病人信息	 
		$('#DisMedThingPatName').attr("readonly","readonly");//病人姓名
		$('#PatSexinput').attr("readonly","readonly"); //性别
		$('#PatAge').attr("readonly","readonly"); //年龄
		$('#PatMedicalNo').attr("readonly","readonly"); //病案号
		$('#PatAdmDate').datebox({disabled:'true'});//入院日期     
		$('#PatDiag').attr("readonly","readonly");//诊断
		var date=$('#ReportDate').datebox("getValue");//报告日期
		if(LgGroupDesc=="护理部"){
			$('#ReportDate').datebox({disabled:false});//报告日期
			$('#ReportDate').datebox("setValue",date);   //报告日期
		}else{
			$('#ReportDate').datebox({disabled:'true'});//报告日期
			$('#ReportDate').datebox("setValue",date);   //报告日期
		}
		$("input[type=radio][id^='PatOrigin-label']").attr("disabled",true);  //自我照顾能力
    	$('#RepHospType').attr("readonly","readonly"); //报告单位
    	$('#RepUserName').attr("readonly","readonly");//填报人姓名为登录人
    	//$('#HospPhone').attr("readonly","readonly"); //联系电话
    	$("#from").form('validate');	
	} 
}
//报告保存
function SaveUlcerReport(flag)
{
	if($('#DisMedThingPatName').val()==""){
		$.messager.alert("提示:","患者姓名为空，请输入登记号或病案号回车选择记录录入患者信息！");	
		return false;
	} 
	///保存前,对页面必填项进行检查
	 if(!(checkRequired()&&checkother())){
		return;
	}
	var msg=checkTableRequired();
	if(msg!=""){
		return;
	}
	SaveReport(flag);
}
//加载报表病人信息
function InitPatInfo(EpisodeID)
{
	if(EpisodeID==""){return;}
	$.ajax({
		type: "POST",
		url: url,
		data: "action=getRepPatInfo&PatNo="+""+"&EpisodeID="+EpisodeID,
		success: function(val){
	    	var tmp=val.split("^");
	    	//病人信息
	    	$('#PatID').val(tmp[0]); //登记号
			$('#DisMedThingPatName').val(tmp[1]); //病人姓名
			$('#DisMedThingPatName').attr("readonly","readonly");
			$('#PatSexinput').val(tmp[3]);  //性别
			$('#PatSexinput').attr("readonly","readonly");
			$('#PatAge').val(tmp[4]);  //年龄
			$('#PatAge').attr("readonly","readonly");
			$('#PatMedicalNo').val(tmp[5]); //病案号
			$('#PatMedicalNo').attr("readonly","readonly");
			if(tmp[24]!=""){
	      		$('#PatAdmDate').datebox({disabled:'true'});	
	      	}
			$('#PatAdmDate').datebox("setValue",tmp[24]);  //入院日期
      		$('#PatDiag').val(tmp[10]);  //诊断
      		if(tmp[10]!=""){
	      		$('#PatDiag').attr("readonly","readonly");	
	      	}
	      	$("input[type=radio][id^='PatOrigin-label']").attr("disabled",false);  //自我照顾能力
	      	if((tmp[22]=="住院")||(tmp[22]=="门诊")||(tmp[22]=="急诊")||(tmp[22]=="日间病房")||(tmp[22]=="其他")){
		      	$("input[type=radio][value='"+tmp[22]+"']").click(); //患者来源
	      		$("input[type=radio][id^='PatOrigin-label']").attr("disabled",true);  //自我照顾能力
	      	}else{
	      		$("input[type=radio][id^='PatOrigin-label']").attr("disabled",false);  //自我照顾能力
		    }
	      	$("input[type=radio][value='"+tmp[23]+"']").click(); //护理级别
      		$("#from").form('validate');
			InitCheckRadio();
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
	var Riskpointtaboth=0;
	$("input[type=radio][id^='UseUlcerRiskpointtab']").each(function(){
		if($(this).is(':checked')){
			if ((this.value=="title")&&($("input[name$='.93878']").val()=="")){
				Riskpointtaboth=-1;
			}
		}
	})
	if(Riskpointtaboth==-1){
		$.messager.alert("提示:","【使用压疮风险评分表】勾选'其它'，请填写内容！");	
		return false;
	}
	
	//压疮发生原因  患者因素
	var PatReasonoth=0;
	$("input[type=checkbox][id^='UlcerOccurReason-94948-']").each(function(){
		if($(this).is(':checked')){
			if ((this.value=="title")&&($("input[name$='.93950'][class='lable-input']").val()=="")){
				PatReasonoth=-1;
			}
		}
	})
	if(PatReasonoth==-1){
		$.messager.alert("提示:","【压疮发生原因】勾选'患者因素其他'，请填写内容！");	
		return false;
	}
	//压疮发生原因  病情因素
	var IllnessReasonoth=0;
	$("input[type=checkbox][id^='UlcerOccurReason-94949-']").each(function(){
		if($(this).is(':checked')){
			if ((this.value=="title")&&($("input[name$='.93956'][class='lable-input']").val()=="")){
				IllnessReasonoth=-1;
			}
		}
	})
	if(IllnessReasonoth==-1){
		$.messager.alert("提示:","【压疮发生原因】勾选'病情因素其他'，请填写内容！");	
		return false;
	}
	//压疮发生原因  护理人员因素
	var NurReasonoth=0;
	$("input[type=checkbox][id^='UlcerOccurReason-94950-']").each(function(){
		if($(this).is(':checked')){
			if ((this.value=="title")&&($("input[name$='.93966'][class='lable-input']").val()=="")){
				NurReasonoth=-1;
			}
		}
	})
	if(NurReasonoth==-1){
		$.messager.alert("提示:","【压疮发生原因】勾选'护理人员因素其他'，请填写内容！");	
		return false;
	}
	//压疮发生原因  其他因素
	var OthReasonoth=0;
	$("input[type=checkbox][id^='UlcerOccurReason-94951-']").each(function(){
		if($(this).is(':checked')){
			if ((this.value=="title")&&($("input[name$='.93969'][class='lable-input']").val()=="")){
				OthReasonoth=-1;
			}
		}
	})
	if(OthReasonoth==-1){
		$.messager.alert("提示:","【压疮发生原因】勾选'其他因素'，请填写内容！");	
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
		$.messager.alert("提示:","【已采取护理措施(可多选)】勾选'其他'，请填写内容！");	
		return false;
	}
	var UlcerPartDate="",UlcerDateErr="";
	//发现日期
	 $("input[id^='UlcerPart-95158-95162-95192']").each(function(){
		if((this.id.split("-").length==4)){
			UlcerPartDate=$("input[id^='"+this.id+"']").datebox("getValue");
			if (UlcerPartDate!=""){
				UlcerDateErr=1;
			}else if(!compareSelTimeAndCurTime(UlcerPartDate)){
				UlcerDateErr=-2;
				return ;	
			} 
		}
	}) 
	if ((UlcerDateErr!="1")&&(UlcerDateErr!="-2")){
		$.messager.alert("提示:","【压疮部位发现日期】未填写，请填写相应内容！");	
		return false;
	}
	if (UlcerDateErr=="-2"){
		$.messager.alert("提示:","【压疮部位发现日期】不能大于当前日期，请填写相应内容！");	
		return false;
	}
	//压疮部位  来源 院外带入 labelUlcerPart-95158-95163-95170
	var PatOrign="",PatOrignList="",OrignErr="";
	 $("input[type=radio][id^='UlcerPart-95158-95163-95170.']").each(function(){
		if ($(this).is(':checked')){	
			PatOrign=this.value;
		}
	});
		
	$("input[type=radio][id^='UlcerPart-95158-95163-']").each(function(){
		if ($(this).is(':checked')){
			if(this.id.split("-").length==4){
				var PatOrignList="";
				var radiorowid=this.id.split(".")[0];
				var radiorownum=this.id.split(".")[1];
				PatOrign=this.value;
				
				$("input[type=radio][id^='UlcerPart-95158-95163-95171-'][id$='."+radiorownum+"']").each(function(){
					if (($(this).is(':checked'))&&(this.value!="")){
						PatOrignList=this.value
					}
				});
				if((radiorowid=="UlcerPart-95158-95163-95171")&&(PatOrignList=="")){
					$.messager.alert("提示:","【压疮来源】勾选【院外带入】，请勾选院外相应内容！");	
					OrignErr=-1;
					return false;
				}		
				
			}
		}
	});
	if (PatOrign==""){
		$.messager.alert("提示:","【压疮来源】未勾选，请勾选相应内容！");	
		OrignErr=-1;
		return false;
	}
	if(OrignErr=="-1"){
		return false;
	}
	//压疮部位 部位   
	var PatReason="",PartErr=0,radiorownum="";
	$("input[type=radio][id^='UlcerPart-95158-95166-']").each(function(){
		if(this.id.split("-").length==4){
			var PatReasonList="";
			if ($(this).is(':checked')){
				var radiorowid=this.id.split(".")[0];
				radiorownum=this.id.split(".")[1];
				PatReason=this.value;
				$("input[type=checkbox][id^='"+radiorowid+"-'][id$='."+radiorownum+"']").each(function(){
					if (($(this).is(':checked'))&&(this.value!="")){
						PatReasonList=this.value
					}
				});
				if((PatReason=="title")&&($("input[name$='.93932."+radiorownum+"'][class='lable-input']").val()=="")){ //UlcerPart-95158-95166-95182
					$.messager.alert("提示:","【压疮部位】勾选其他，请填写相应内容！");	
					PartErr=-1;
					return false;
				}		
				if ((PatReason!="枕部")&&(PatReason!="骶尾部")&&(PatReason!="title")&&(PatReasonList=="")){
					$.messager.alert("提示:","【压疮部位】勾选'"+PatReason+"'，请勾选相应内容！");	
					PartErr=-1;
					return false;
				}
				
			 }
		}
	});
	if(PartErr=="-1"){
		return false;
	}
	if(PatReason==""){
		$.messager.alert("提示:","【压疮部位】未勾选内容，请勾选相应内容！");	
		return false;
	}
	
	return true;
}
//页面初始加载checkbox,radio控制子元素不可以填写
function InitCheckRadio(){
	//患者来源
	$("input[type=radio][id^='PatOrigin-label']").each(function(){
		if ($(this).is(':checked')){
			var id=this.id;
			if (id=="PatOrigin-label-94337"){
				$('#PatAdmADLScore').val(""); //入院时ADL得分
				$('#PatAdmADLScore').css("background-color","#D4D0C8");
				$('#PatAdmADLScore').attr("readonly","readonly"); //入院时ADL得分
				$("label[data-parref='PatSelfCareAbility']").css("color","#D4D0C8")
				$("input[type=radio][id^='PatSelfCareAbility-']").removeAttr("checked");  //自我照顾能力
				$("input[type=radio][id^='PatSelfCareAbility-']").attr("disabled",true);  //自我照顾能力
			}else{
				$('#PatAdmADLScore').attr("readonly",false); //入院时ADL得分
				$('#PatAdmADLScore').css("background-color","#fff");
				$("label[data-parref='PatSelfCareAbility']").css("color","#000")
				$("input[type=radio][id^='PatSelfCareAbility-']").attr("disabled",false);  //自我照顾能力
			}
		}
	})
	//压疮部位  来源
	if($("input[type=radio][id^='UlcerPart-95158-95163-95171.']").is(':checked')){
		$("input[type=radio][id^='UlcerPart-95158-95163-95171-']").attr("disabled",false);

	}else{
		$("input[type=radio][id^='UlcerPart-95158-95163-95171-']").attr("disabled",true);
	}	
	//耳廓
	if($("input[type=radio][id^='UlcerPart-95158-95166-95173.']").is(':checked')){
		$("input[type=checkbox][id^='UlcerPart-95158-95166-95173-']").attr("disabled",false);
	}else{
		$("input[type=checkbox][id^='UlcerPart-95158-95166-95173-']").removeAttr("checked");
		$("input[type=checkbox][id^='UlcerPart-95158-95166-95173-']").attr("disabled",true);
	}
	//肩胛部
	if($("input[type=radio][id^='UlcerPart-95158-95166-95174.']").is(':checked')){
		$("input[type=checkbox][id^='UlcerPart-95158-95166-95174-']").attr("disabled",false);
	}else{
		$("input[type=checkbox][id^='UlcerPart-95158-95166-95174-']").removeAttr("checked");
		$("input[type=checkbox][id^='UlcerPart-95158-95166-95174-']").attr("disabled",true);
	}	
	//肘部
	if($("input[type=radio][id^='UlcerPart-95158-95166-95175.']").is(':checked')){
		$("input[type=checkbox][id^='UlcerPart-95158-95166-95175-']").attr("disabled",false);
	}else{
		$("input[type=checkbox][id^='UlcerPart-95158-95166-95175-']").removeAttr("checked");
		$("input[type=checkbox][id^='UlcerPart-95158-95166-95175-']").attr("disabled",true);
	}
	 //髂前上棘
	if($("input[type=radio][id^='UlcerPart-95158-95166-95176.']").is(':checked')){
		$("input[type=checkbox][id^='UlcerPart-95158-95166-95176-']").attr("disabled",false);
	}else{
		$("input[type=checkbox][id^='UlcerPart-95158-95166-95176-']").removeAttr("checked");
		$("input[type=checkbox][id^='UlcerPart-95158-95166-95176-']").attr("disabled",true);
	}
	//髋部
	if($("input[type=radio][id^='UlcerPart-95158-95166-95177.']").is(':checked')){
		$("input[type=checkbox][id^='UlcerPart-95158-95166-95177-']").attr("disabled",false);
	}else{
		$("input[type=checkbox][id^='UlcerPart-95158-95166-95177-']").removeAttr("checked");
		$("input[type=checkbox][id^='UlcerPart-95158-95166-95177-']").attr("disabled",true);
	}
	//膝部
	if($("input[type=radio][id^='UlcerPart-95158-95166-95179.']").is(':checked')){
		$("input[type=checkbox][id^='UlcerPart-95158-95166-95179-']").attr("disabled",false);
	}else{
		$("input[type=checkbox][id^='UlcerPart-95158-95166-95179-']").removeAttr("checked");
		$("input[type=checkbox][id^='UlcerPart-95158-95166-95179-']").attr("disabled",true);
	}
	//踝部
	if($("input[type=radio][id^='UlcerPart-95158-95166-95180.']").is(':checked')){
		$("input[type=checkbox][id^='UlcerPart-95158-95166-95180-']").attr("disabled",false);
	}else{
		$("input[type=checkbox][id^='UlcerPart-95158-95166-95180-']").removeAttr("checked");
		$("input[type=checkbox][id^='UlcerPart-95158-95166-95180-']").attr("disabled",true);
	}
	//足跟部
	if($("input[type=radio][id^='UlcerPart-95158-95166-95181.']").is(':checked')){
		$("input[type=checkbox][id^='UlcerPart-95158-95166-95181-']").attr("disabled",false);
	}else{
		$("input[type=checkbox][id^='UlcerPart-95158-95166-95181-']").removeAttr("checked");
		$("input[type=checkbox][id^='UlcerPart-95158-95166-95181-']").attr("disabled",true);
	}
	//其他
	if($("input[type=radio][id^='UlcerPart-95158-95166-95182.']").is(':checked')){
		$("input[type=checkbox][id^='UlcerPart-95158-95166-95181-']").attr("disabled",false);
		$("input[name$='.93730'][class='lable-input']").attr("readonly",false); 
	}else{
		$("input[name$='.93730'][class='lable-input']").val("");  //清空其他内容
		$("input[name$='.93730'][class='lable-input']").attr("readonly","readonly"); 
		$("input[name$='.93730'][class='lable-input']").hide();  
	}		
}
//勾选 radio 子元素可以勾选，取消勾选时，子元素取消勾选且不可以勾选
function InitRadio(id){
	//来源  院外带入 
	var radiorowid=id.split(".")[0];
	var radiorownum=id.split(".")[1];
	//压疮部位  来源
	if($("input[type=radio][id^='UlcerPart-95158-95163-95171.'][id$='"+radiorownum+"']").is(':checked')){
		$("input[type=radio][id^='UlcerPart-95158-95163-95171-'][id$='"+radiorownum+"']").attr("disabled",false);
	}else{
		$("input[type=radio][id^='UlcerPart-95158-95163-95171-'][id$='"+radiorownum+"']").removeAttr("checked");
		$("input[type=radio][id^='UlcerPart-95158-95163-95171-'][id$='"+radiorownum+"']").attr("disabled",true);
	}
	 //部位 
	var checkrowid=id.split(".")[0];
	var checkrownum=id.split(".")[1];
	if(checkrowid.indexOf("95166")>0){
	if($("input[type=radio][id^='UlcerPart-95158-95166-'][id$='"+checkrownum+"']").is(':checked')){
		$("input[type=checkbox][id^='UlcerPart-95158-95166-'][id$='."+checkrownum+"']").removeAttr("checked");
		$("input:not([id='"+id+"'])input[type=radio][id!='"+checkrowid+"'][id^='UlcerPart-95158-95166-'][id$='"+checkrownum+"']").removeAttr("checked");
		if (checkrowid!=="UlcerPart-95158-95166-95182"){
			$("input[name$='.93932."+checkrownum+"'][class='lable-input']").val("");  //清空其他内容
			$("input[name$='.93932."+checkrownum+"'][class='lable-input']").hide();  
		}
		$("input[type=checkbox][id^='UlcerPart-95158-95166-'][id$='."+checkrownum+"']").attr("disabled",true);
		$("input[type=checkbox][id^='"+checkrowid+"'][id$='."+checkrownum+"']").attr("disabled",false);
		
	}else{
		$("input[type=checkbox][id^='UlcerPart-95158-95166-'][id$='."+checkrownum+"']").removeAttr("checked");
		$("input[type=checkbox][id^='UlcerPart-95158-95166-'][id$='."+checkrownum+"']").attr("disabled",true);
	} 	 
	}
	//患者来源
	$("input[type=radio][id^='PatOrigin-label']").each(function(){
		if ($(this).is(':checked')){
			var id=this.id;
			if (id=="PatOrigin-label-94337"){
				$('#PatAdmADLScore').val(""); //入院时ADL得分
				$('#PatAdmADLScore').css("background-color","#D4D0C8");
				$('#PatAdmADLScore').attr("readonly","readonly"); //入院时ADL得分
				$("label[data-parref='PatSelfCareAbility']").css("color","#D4D0C8")
				$("input[type=radio][id^='PatSelfCareAbility-']").removeAttr("checked");  //自我照顾能力
				$("input[type=radio][id^='PatSelfCareAbility-']").attr("disabled",true);  //自我照顾能力
			}else{
				$('#PatAdmADLScore').attr("readonly",false); //入院时ADL得分
				$('#PatAdmADLScore').css("background-color","#fff");
				$("label[data-parref='PatSelfCareAbility']").css("color","#000")
				$("input[type=radio][id^='PatSelfCareAbility-']").attr("disabled",false);  //自我照顾能力
			}
		}
	})
}
function InitCheck(id){
	/* //部位 
	var checkrowid=id.split(".")[0];
	var checkrownum=id.split(".")[1];
	// 
	if($("input[type=radio][id^='"+checkrowid+".'][id$='"+checkrownum+"']").is(':checked')){
		$("input[type=checkbox][id^='"+checkrowid+"-'][id$='"+checkrownum+"']").attr("disabled",false);
	}else{
		$("input[type=checkbox][id^='"+checkrowid+"-'][id$='"+checkrownum+"']").removeAttr("checked");
		$("input[type=checkbox][id^='"+checkrowid+"-'][id$='"+checkrownum+"']").attr("disabled",true);
	}	 */
	
}

//时间 数字校验
function CheckTimeornum(){
	//时间输入校验
	//压疮面积 UlcerPart-95158-95189-94247
	//var regu="^([0-9])[0-9]*(\\.\\w*)?$";
	//var re=new RegExp(regu);
	$("input[id^='UlcerPart-95158-95189-94247']").live("keyup",function(){
		/* if(re.test(this.value)){
			this.value=this.value
		}else{
			this.value=""
		} */
		this.value=this.value.replace(/\D/g,'');
	})
	$("input[id^='UlcerPart-95158-95189-94249']").live("keyup",function(){
		this.value=this.value.replace(/\D/g,'');
	})
	$("input[id^='UlcerPart-95158-95189-94251']").live("keyup",function(){
		this.value=this.value.replace(/\D/g,'');
	})
	//数字输入校验  
	//填报人工作年限(年)
	$('#RepUserWorkYears').live("keyup",function(){
		this.value=this.value.replace(/\D/g,'');
	})
	//入院时ADL得分
	$('#PatAdmADLScore').live("keyup",function(){
		this.value=this.value.replace(/\D/g,'');
		if((this.value>100)||(this.value=="")){
			$.messager.alert("提示:","【入院时ADL得分】输入1-100的整数！");	
			$("input[type=radio][id^='PatSelfCareAbility-']").removeAttr("checked");
			this.value="";
		}else if((this.value>40)||(this.value<100)){
			$("input[type=radio][id^='PatSelfCareAbility-94346']").click();	
		}
		if(((this.value>0)||(this.value==0))&&((this.value<40)||(this.value==40))&&(this.value!="")){
			$("input[type=radio][id^='PatSelfCareAbility-94347']").click();	
		}
		if(this.value==100){
			$("input[type=radio][id^='PatSelfCareAbility-94345']").click();	
		}
	})
	
	//入院压疮风险评分
	$('#HospUlcerRiskScore').live("keyup",function(){
		this.value=this.value.replace(/\D/g,'');
		if(this.value>100){
			$.messager.alert("提示:","【入院压疮风险评分】输入不能大于100！");	
			this.value="";
		}
	})
	//发生压疮时风险评分
	$('#OccurUlcerRiskScore').live("keyup",function(){
		this.value=this.value.replace(/\D/g,'');
		if(this.value>100){
			$.messager.alert("提示:","【发生压疮时风险评分】输入不能大于100！");	
			this.value="";
		}
	})

}

function add_event(){
	//单选框按钮事件
	$("input[type=radio]").each(function(){
		$(this).click(function(){
			$(this).is(':checked');
			InitRadio(this.id);
		});
	});
	//复选框按钮事件
	$("input[type=checkbox]").each(function(){
		$(this).click(function(){
			$(this).is(':checked');
			InitCheck(this.id);
		});
	});
	CheckTimeornum();  //时间校验
	InitCheckRadio();//加载界面checkboxradio在父元素没有勾选的情况下，子元素不可勾选，填写
	//发现日期
	 $("input[id^='UlcerPart-95158-95162-95192']").each(function(){
		if((this.id.split("-").length==4)){
			var UlcerPartDate=$("input[id^='"+this.id+"']").datebox("getValue");
			if (UlcerPartDate!=""){
				$("input[id^='UlcerPart-95158-95162-95192.']").datebox("setValue",UlcerPartDate);
			}
		}
	}) 
	//来源  院外带入 
	var orign="";
	$("input[type=radio][id^='UlcerPart-95158-95163']").each(function(){
		if ($(this).is(':checked')){
			var checkrowid=this.id.split(".")[0];
			var checkrownum=this.id.split(".")[1];
			orign=this.value;
			var list=$("input[type=radio][id^='UlcerPart-95158-95163-95170."+checkrownum+"']:checked").val();
			if((this.id.split("-").length==4)){
				$("input[type=radio][id^='"+checkrowid+".']").click();		
			}else if(this.id.split("-").length==5){
				$("input[type=radio][id^='"+checkrowid+"']").click();
			}
		}
	})
	
	//部位 
	$("input[type=radio][id^='UlcerPart-95158-95166']").each(function(){
		if ($(this).is(':checked')){
			var checkrowid=this.id.split(".")[0];
			var checkrownum=this.id.split(".")[1];
			$("input:not([id$='"+checkrownum+"'])input[type=checkbox][id^='"+checkrowid+"']").attr("disabled",true);
		}
	}) 
}
//登记号自动补0
function getRePatNo(regno)
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
//通过住院号（病案号）获取病人基本信息
function PatMedNoEnter(){
	$('#PatMedicalNo').bind('keydown',function(event){
		if(event.keyCode == "13")    
		{
			var patientNO=$('#PatMedicalNo').val();
			if (patientNO=="")
			{
				$.messager.alert("提示:","病人病案号不能为空！");
				return;
			}
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
				url:'dhcadv.repaction.csp'+'?action=GetAdmList&Input='+patientNO ,
				columns: mycols,  //列信息
				nowrap:false,
				pagesize:10,  //一页显示记录数
				table: '#admdsgrid', //grid ID
				field:'Adm', //记录唯一标识
				params:null,  // 请求字段,空为null
				tbar:null //上工具栏,空为null
			}
			var win=new CreatMyDiv(input,$("#PatMedicalNo"),"drugsfollower","460px","335px","admdsgrid",mycols,mydgs,"","",SetAdmIdTxtVal);	
			win.init();
		}
	});
}
//获取病案号选择记录数据
function SetAdmIdTxtVal(rowData)
{
	EpisodeID=rowData.Adm;
	if(EpisodeID==undefined){
		EpisodeID="";
	}
	InitPatInfo(EpisodeID);
}
//根据科室1查询科室2   2018-01-15
function ComboboxLocTwo(LocOne){
   $('#DeptLocTwo').combobox({ 
		url:'dhcapp.broker.csp?ClassName=web.DHCADVCOMMONPART&MethodName=GetAutLocItmCombox'+'&AutLParentDesc='+encodeURI(LocOne),
		mode:'remote'  //,  //必须设置这个属性
	});   

}

//检查table中的必填
//如果填写了长款高，后面的信息都为必填，除了气味
function checkTableRequired(){
	var errMsg=""
	$("#UlcerPart").next().find("tbody tr").each(function(i){
		var flag=0
		$(this).children('td').eq(0).find("input").each(function(){
			if($(this).val()!=""){
				flag=1;
			}	
		})
		if(flag==1){
			var rowMsg=""
			//来源
			var str=jQuery("input[name][type=radio]:checked", $(this).children('td').eq(1));
			if(str.length==0){
				rowMsg=rowMsg+"来源,"
			}
			//部位
			var str1=jQuery("input[name][type=radio]:checked", $(this).children('td').eq(2));
			if(str1.length==0){
				rowMsg=rowMsg+"部位,"
			}
			//压疮分期
			var str2=jQuery("input[name][type=radio]:checked", $(this).children('td').eq(3));
			if(str2.length==0){
				rowMsg=rowMsg+"压疮分期,"
			}
			//面积
			var str3=$(this).children('td').eq(4).find("input").val()
			if(str3.length==0){
				rowMsg=rowMsg+"面积,"
			}
			if(rowMsg!=""){
				errMsg=errMsg+"\n"+rowMsg+"不能为空."
			}	
		}
	
	})
	if(errMsg!=""){
		$("html,body").stop(true);$("html,body").animate({scrollTop: $("#UlcerPart").offset().top}, 1000);
		$.messager.alert("提示:",errMsg);
	}
	return errMsg;
}
//登记号回车事件
function PatIDEnter(){
	$('#PatID').bind('keydown',function(event){

		 if(event.keyCode == "13")    
		 {
			 var PatID=$('#PatID').val();
			 if (PatID=="")
			 {
				 	$.messager.alert("提示:","病人登记号不能为空！");
					return;
			 }
			 var PatID=getRegNo(PatID);
			 var input=input+'&StkGrpRowId=&StkGrpType=G&Locdr=&NotUseFlag=N&QtyFlag=0&HospID=' ;
			 var mycols = [[
			 	{field:'Adm',title:'Adm',width:60}, 
			 	{field:'AdmLoc',title:'就诊科室',width:220}, 
			 	{field:'AdmDate',title:'就诊日期',width:80},
			 	{field:'AdmTime',title:'就诊时间',width:80},
			 	{field:'RegNo',title:'病人id',width:80}
			 ]];
			 var mydgs = {
				 url:'dhcadv.repaction.csp'+'?action=GetAdmDs&Input='+PatID ,
				 columns: mycols,  //列信息
				 pagesize:10,  //一页显示记录数
				 table: '#admdsgrid', //grid ID
				 field:'Adm', //记录唯一标识
				 params:null,  // 请求字段,空为null
				 tbar:null //上工具栏,空为null
				}
			 var win=new CreatMyDiv(input,$("#PatID"),"drugsfollower","650px","335px","admdsgrid",mycols,mydgs,"","",SetAdmTxtVal);	
			 win.init();
		}
	});	
}
//获取登记号选择记录数据
function SetAdmTxtVal(rowData)
{
	EpisodeID=rowData.Adm;
	if(EpisodeID==undefined){
		EpisodeID=""
	}
	InitPatInfo(EpisodeID);
	
}
