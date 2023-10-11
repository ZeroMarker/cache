/**
*Description:	化妆品不良事件
*Creator: 		hujianghai
*CreDate: 		2020-07-06
**/
var RepDate=formatDate(0);	// 系统的当前日期
$(document).ready(function(){
	InitButton();				// 初始化按钮
	reportControl();			// 表单控制 
	InitReport(recordId);	// 加载页面信息

})


function InitButton(){
	
	// 保存
	$("#SaveBut").on("click",function(){
		SaveCosReport(0);
	})
	
	// 提交
	$("#SubmitBut").on("click",function(){
		SaveCosReport(1);
	})
	
}

// 表单控制
function reportControl(){
	
	// 复选框按钮事件
	$("input[type=checkbox]").each(function(){
		$(this).click(function(){
			$(this).is(':checked');	
			InitCheckRadio(this.id);	
		});
	});
	//单选框按钮事件
	$("input[type=radio]").each(function(){
		$(this).click(function(){
			$(this).is(':checked');
			InitCheckRadio(this.id);
		});
	});
	
	/// 报告类型 勾选严重 严重选项可勾选，否则 严重选项不可勾选
	$("input[type=radio][id^='repTypeHz-']").each(function(){
		if($("#repTypeHz-99880").is(':checked')){
			$("input[type=checkbox][id^='CriticalOptions-']").attr("disabled",false);
		}else{
			$("input[type=checkbox][id^='CriticalOptions-']").attr("disabled",true);
		}
	})
	
	/// 化妆品信息-类别 特殊 Cosmetics-101199-101220-101235
	$("input[type=radio][id^='Cosmetics-101199-101220-101235']").each(function(){
		if($("input[type=radio][id^='Cosmetics-101199-101220-101235'][id$='."+this.id.split(".")[1]+"']").is(':checked')){
			$("input[type=radio][id^='Cosmetics-101199-101220-101235-'][id$='."+this.id.split(".")[1]+"']").attr("disabled",false);
		}else{
			$("input[type=radio][id^='Cosmetics-101199-101220-101235-'][id$='."+this.id.split(".")[1]+"']").attr("disabled",true);
		}
	})
	/// 化妆品信息-类别 普通
	$("input[type=radio][id^='Cosmetics-101199-101220-101236']").each(function(){
		if($("input[type=radio][id^='Cosmetics-101199-101220-101236'][id$='."+this.id.split(".")[1]+"']").is(':checked')){
			$("input[type=radio][id^='Cosmetics-101199-101220-101236-'][id$='."+this.id.split(".")[1]+"']").attr("disabled",false);
				if($("input[type=radio][id^='Cosmetics-101199-101220-101236-101260'][id$='."+this.id.split(".")[1]+"']").is(':checked')){
					$("input[type=radio][id^='Cosmetics-101199-101220-101236-101260-'][id$='."+this.id.split(".")[1]+"']").attr("disabled",false);
				}else if ($("input[type=radio][id^='Cosmetics-101199-101220-101236-101261.']").is(':checked')){
					$("input[type=radio][id^='Cosmetics-101199-101220-101236-101261-'][id$='."+this.id.split(".")[1]+"']").attr("disabled",false);
				}else if ($("input[type=radio][id^='Cosmetics-101199-101220-101236-101262.']").is(':checked')){
					$("input[type=radio][id^='Cosmetics-101199-101220-101236-101262-'][id$='."+this.id.split(".")[1]+"']").attr("disabled",false);
				}else {
					$("input[type=radio][id^='Cosmetics-101199-101220-101236-101260-'][id$='."+this.id.split(".")[1]+"']").attr("disabled",true);
					$("input[type=radio][id^='Cosmetics-101199-101220-101236-101261-'][id$='."+this.id.split(".")[1]+"']").attr("disabled",true);
					$("input[type=radio][id^='Cosmetics-101199-101220-101236-101262-'][id$='."+this.id.split(".")[1]+"']").attr("disabled",true);
				}
				
		}else{
			$("input[type=radio][id^='Cosmetics-101199-101220-101236-'][id$='."+this.id.split(".")[1]+"']").attr("disabled",true);
		}
	})
	
	/// 化妆品信息-化妆品有关斑贴试验
	$("input[type=radio][id^='Cosmetics-101199-101225-101245']").each(function(){
		if($("input[type=radio][id^='Cosmetics-101199-101225-101245'][id$='."+this.id.split(".")[1]+"']").is(':checked')){
			$("input[id^='Cosmetics-101199-101225-101245-'][id$='."+this.id.split(".")[1]+"']").attr("readonly",false);
		}else{
			$("input[id^='Cosmetics-101199-101225-101245-'][id$='."+this.id.split(".")[1]+"']").attr("readonly","readonly");
		}
	})
	/// 化妆品信息-欧标、澳标变应原系列斑贴试验
	$("input[type=radio][id^='Cosmetics-101199-101226-101247']").each(function(){
		if($("input[type=radio][id^='Cosmetics-101199-101226-101247'][id$='."+this.id.split(".")[1]+"']").is(':checked')){
			$("input[type=radio][id^='Cosmetics-101199-101226-101247-'][id$='."+this.id.split(".")[1]+"']").attr("disabled",false);
		}else{
			$("input[type=radio][id^='Cosmetics-101199-101226-101247-'][id$='."+this.id.split(".")[1]+"']").attr("disabled",true);
		}
	})
	/// 化妆品信息-欧标、澳标变应原系列斑贴试验 已做  有呈阳性受试物质
	$("input[type=radio][id^='Cosmetics-101199-101226-101247-101287']").each(function(){
		if($("input[type=radio][id^='Cosmetics-101199-101226-101247-101287'][id$='."+this.id.split(".")[1]+"']").is(':checked')){
			$("input[id^='Cosmetics-101199-101226-101247-101287-101327'][id$='."+this.id.split(".")[1]+"']").show();
			$("input[id^='Cosmetics-101199-101226-101247-101287-101327'][id$='."+this.id.split(".")[1]+"']").attr("readonly",false);
		}else{
			$("input[id^='Cosmetics-101199-101226-101247-101287-101327'][id$='."+this.id.split(".")[1]+"']").val("");
			$("input[id^='Cosmetics-101199-101226-101247-101287-101327'][id$='."+this.id.split(".")[1]+"']").hide();
		}
	})
	
	/// 化妆品信息-其他辅助检查
	$("input[type=radio][id^='Cosmetics-101199-101227-']").each(function(){
		if($("input[type=radio][id^='Cosmetics-101199-101227-101248'][id$='."+this.id.split(".")[1]+"']").is(':checked')){
			$("input[id^='Cosmetics-101199-101227-101248-101310.'][id$='."+this.id.split(".")[1]+"']").attr("readonly",false);
			$("input[id^='Cosmetics-101199-101227-101248-101312.'][id$='."+this.id.split(".")[1]+"']").attr("readonly",false);
		}else{
			$("input[id^='Cosmetics-101199-101227-101248-101310.'][id$='."+this.id.split(".")[1]+"']").val("");
			$("input[id^='Cosmetics-101199-101227-101248-101312.'][id$='."+this.id.split(".")[1]+"']").val("");
			$("input[id^='Cosmetics-101199-101227-101248-101310.'][id$='."+this.id.split(".")[1]+"']").attr("readonly","readonly");
			$("input[id^='Cosmetics-101199-101227-101248-101312.'][id$='."+this.id.split(".")[1]+"']").attr("readonly","readonly");
		}
	})
	// 开始使用日期
	chkdate("StartUseDate");
}

//加载报表信息
function InitReport(recordId)
{
	InitReportCom(recordId);
	if((recordId=="")||(recordId==undefined)){
	}else{
		//病人信息
    	$("#from").form('validate');			
	} 
}

//报告保存
function SaveCosReport(flag)
{
	if($('#PatName').val()==""){
		$.messager.alert($g("提示:"),$g("患者姓名为空，请输入登记号或病案号回车选择记录录入患者信息！"));	
		return false;
	} 
	///保存前,对页面必填项进行检查
	 if(!(checkother()&&checkRequired())){
		return;
	}
	
	SaveReportCom(flag);
}

//加载报表病人信息
function InitPatInfo(EpisodeID)
{
	if(EpisodeID==""){return;}
	InitPatInfoCom(EpisodeID);
	$("#from").form('validate'); 
}



function InitCheckRadio(id){
	/// 报告类型 勾选严重 严重选项可勾选，否则 严重选项不可勾选
	if(id.indexOf("repTypeHz-")>=0){
		if($("#repTypeHz-99880").is(':checked')){
			$("input[type=checkbox][id^='CriticalOptions-']").attr("disabled",false);
		}else{
			$("input[type=checkbox][id^='CriticalOptions-']").removeAttr("checked");
			$("input[type=checkbox][id^='CriticalOptions-']").attr("disabled",true);
		}
	}
	var checkrowid=id.split(".")[0];
	var checkrownum=id.split(".")[1];
	/// 化妆品信息-类别 特殊 Cosmetics-101199-101220-101235 Cosmetics-101199-101220-101235
	if(checkrowid.indexOf("101220")>0){
		if($("input[type=radio][id^='Cosmetics-101199-101220-'][id$='"+checkrownum+"']").is(':checked')){
			if(checkrowid.split("-").length==4){ // 特殊、 普通
				$("input:not([id='"+id+"'])input[type=radio][id!='"+checkrowid+"'][id^='Cosmetics-101199-101220-'][id$='"+checkrownum+"']").removeAttr("checked");
				if(checkrowid=="Cosmetics-101199-101220-101235"){
					$("input[type=radio][id^='Cosmetics-101199-101220-101235-'][id$='."+checkrownum+"']").attr("disabled",false);
					$("input[type=radio][id^='Cosmetics-101199-101220-101236-'][id$='."+checkrownum+"']").attr("disabled",true);
				}
				if(checkrowid=="Cosmetics-101199-101220-101236"){
					$("input[type=radio][id^='Cosmetics-101199-101220-101235-'][id$='."+checkrownum+"']").attr("disabled",true);
					$("input[type=radio][id^='Cosmetics-101199-101220-101236-'][id$='."+checkrownum+"']").attr("disabled",false);
				}
			}
			if(checkrowid.split("-").length==5){ //  普通  发用类 护肤类 美容修饰类 香水类
				$("input:not([id='"+id+"'])input[type=radio][id!='"+checkrowid+"'][id^='Cosmetics-101199-101220-101236-'][id$='"+checkrownum+"']").removeAttr("checked");
				if(checkrowid=="Cosmetics-101199-101220-101236-101260"){
					$("input[type=radio][id^='Cosmetics-101199-101220-101236-101260-'][id$='."+checkrownum+"']").attr("disabled",false);
					$("input[type=radio][id^='Cosmetics-101199-101220-101236-101261-'][id$='."+checkrownum+"']").attr("disabled",true);
					$("input[type=radio][id^='Cosmetics-101199-101220-101236-101262-'][id$='."+checkrownum+"']").attr("disabled",true);
				}
				if(checkrowid=="Cosmetics-101199-101220-101236-101261"){
					$("input[type=radio][id^='Cosmetics-101199-101220-101236-101260-'][id$='."+checkrownum+"']").attr("disabled",true);
					$("input[type=radio][id^='Cosmetics-101199-101220-101236-101261-'][id$='."+checkrownum+"']").attr("disabled",false);
					$("input[type=radio][id^='Cosmetics-101199-101220-101236-101262-'][id$='."+checkrownum+"']").attr("disabled",true);
				}
				if(checkrowid=="Cosmetics-101199-101220-101236-101262"){
					$("input[type=radio][id^='Cosmetics-101199-101220-101236-101260-'][id$='."+checkrownum+"']").attr("disabled",true);
					$("input[type=radio][id^='Cosmetics-101199-101220-101236-101261-'][id$='."+checkrownum+"']").attr("disabled",true);
					$("input[type=radio][id^='Cosmetics-101199-101220-101236-101262-'][id$='."+checkrownum+"']").attr("disabled",false);
				}
				if(checkrowid=="Cosmetics-101199-101220-101236-101263"){
					$("input[type=radio][id^='Cosmetics-101199-101220-101236-101260-'][id$='."+checkrownum+"']").attr("disabled",true);
					$("input[type=radio][id^='Cosmetics-101199-101220-101236-101261-'][id$='."+checkrownum+"']").attr("disabled",true);
					$("input[type=radio][id^='Cosmetics-101199-101220-101236-101262-'][id$='."+checkrownum+"']").attr("disabled",true);
				}
			}
		}	 
	}
	/// 化妆品信息-产品来源 其他
	if(checkrowid.indexOf("101223")>0){
		if($("input[type=radio][id^='Cosmetics-101199-101223-'][id$='"+checkrownum+"']").is(':checked')){
			if (checkrowid!=="Cosmetics-101199-101223-101242"){
				$("input[type=radio][id^='Cosmetics-101199-101223-101242'][id$='."+checkrownum+"']").nextAll(".lable-input").val("");
				$("input[type=radio][id^='Cosmetics-101199-101223-101242'][id$='."+checkrownum+"']").nextAll(".lable-input").hide();
			}
		}	 
	}	
	/// 化妆品信息-化妆品有关斑贴试验 
	if(checkrowid.indexOf("101225")>0){
		if($("input[type=radio][id^='Cosmetics-101199-101225-'][id$='"+checkrownum+"']").is(':checked')){
			if(checkrowid.split("-").length==4){
				$("input:not([id='"+id+"'])input[type=radio][id!='"+checkrowid+"'][id^='Cosmetics-101199-101225-'][id$='"+checkrownum+"']").removeAttr("checked");
				if (checkrowid!=="Cosmetics-101199-101225-101245"){
					$("input[id^='Cosmetics-101199-101225-101245-101280'][id$='."+checkrownum+"']").val("");
					$("input[id^='Cosmetics-101199-101225-101245-101280'][id$='."+checkrownum+"']").attr("readonly","readonly");
					$("input[id^='Cosmetics-101199-101225-101245-101281'][id$='."+checkrownum+"']").val("");
					$("input[id^='Cosmetics-101199-101225-101245-101281'][id$='."+checkrownum+"']").attr("readonly","readonly");
				}else{
					$("input[id^='Cosmetics-101199-101225-101245-101280'][id$='."+checkrownum+"']").attr("readonly",false);
					$("input[id^='Cosmetics-101199-101225-101245-101281'][id$='."+checkrownum+"']").attr("readonly",false);
				}
			}
		}else{
			$("input[id^='Cosmetics-101199-101225-101245-101280'][id$='."+checkrownum+"']").val("");
			$("input[id^='Cosmetics-101199-101225-101245-101280'][id$='."+checkrownum+"']").attr("readonly","readonly");
			$("input[id^='Cosmetics-101199-101225-101245-101281'][id$='."+checkrownum+"']").val("");
			$("input[id^='Cosmetics-101199-101225-101245-101281'][id$='."+checkrownum+"']").attr("readonly","readonly");
		} 	 
	}
	/// 化妆品信息-欧标、澳标变应原系列斑贴试验
	if(checkrowid.indexOf("101226")>0){
		if($("input[type=radio][id^='Cosmetics-101199-101226-'][id$='"+checkrownum+"']").is(':checked')){
			if(checkrowid.split("-").length==4){
				if ((checkrowid!=="Cosmetics-101199-101226-101247")){
					$("input[id^='Cosmetics-101199-101226-101247-101287-101327'][id$='."+checkrownum+"']").val("");
					$("input[id^='Cosmetics-101199-101226-101247-101287-101327'][id$='."+checkrownum+"']").hide();
					$("input[type=radio][id^='Cosmetics-101199-101226-101247-'][id$='."+checkrownum+"']").removeAttr("checked");
					$("input[type=radio][id^='Cosmetics-101199-101226-101247-'][id$='."+checkrownum+"']").attr("disabled",true);
				}else{
					$("input[type=radio][id^='Cosmetics-101199-101226-101247-'][id$='."+checkrownum+"']").attr("disabled",false);
				}
			}
		}else{
			$("input[type=radio][id^='Cosmetics-101199-101226-'][id$='."+checkrownum+"']").removeAttr("checked");
			$("input[type=radio][id^='Cosmetics-101199-101226-'][id$='."+checkrownum+"']").attr("disabled",true);
		} 	 
	}
	
	
	/// 化妆品信息-欧标、澳标变应原系列斑贴试验 子元素单选	Cosmetics-101199-101226-101247-101287-101327
	if(checkrowid.indexOf("101247")>0){
		if($("input[type=radio][id^='Cosmetics-101199-101226-101247-'][id$='"+checkrownum+"']").is(':checked')){
			if (checkrowid!=="Cosmetics-101199-101226-101247-101287"){
				$("input[id^='Cosmetics-101199-101226-101247-101287-101327'][id$='."+checkrownum+"']").val("");
				$("input[id^='Cosmetics-101199-101226-101247-101287-101327'][id$='."+checkrownum+"']").hide();
			}else{
				$("input[id^='Cosmetics-101199-101226-101247-101287-101327'][id$='."+checkrownum+"']").show();
				$("input[id^='Cosmetics-101199-101226-101247-101287-101327'][id$='."+checkrownum+"']").attr("readonly",false);
			}
		}	 
	}
	/// 化妆品信息-其他辅助检查
	if(checkrowid.indexOf("101227")>0){ 
		if($("input[type=radio][id^='Cosmetics-101199-101227-'][id$='"+checkrownum+"']").is(':checked')){
			$("input:not([id='"+id+"'])input[type=radio][id!='"+checkrowid+"'][id^='Cosmetics-101199-101227-'][id$='"+checkrownum+"']").removeAttr("checked");
			if (checkrowid!=="Cosmetics-101199-101227-101248"){
				$("input[id^='Cosmetics-101199-101227-101248-101310'][id$='."+checkrownum+"']").attr("readonly","readonly");
				$("input[id^='Cosmetics-101199-101227-101248-101312'][id$='."+checkrownum+"']").attr("readonly","readonly");
				$("input[id^='Cosmetics-101199-101227-101248-101310'][id$='."+checkrownum+"']").val("");
				$("input[id^='Cosmetics-101199-101227-101248-101312'][id$='."+checkrownum+"']").val("");
			}else{
				$("input[id^='Cosmetics-101199-101227-101248-101310'][id$='."+checkrownum+"']").attr("readonly",false);
				$("input[id^='Cosmetics-101199-101227-101248-101312'][id$='."+checkrownum+"']").attr("readonly",false);
			}			
		}else{
			$("input[id^='Cosmetics-101199-101227-101248-101310'][id$='."+checkrownum+"']").attr("readonly","readonly");
			$("input[id^='Cosmetics-101199-101227-101248-101312'][id$='."+checkrownum+"']").attr("readonly","readonly");
		} 	 
	}
	/// 过程描述 3.皮损部位 勾选 无 取消非 无 的勾选项的勾选
	if(id.indexOf("ProcessDescriptionHZ-99921-")>=0){
		if($("input[type=checkbox][id^='ProcessDescriptionHZ-99921-").is(':checked')){
			if(id=="ProcessDescriptionHZ-99921-99948"){
				$("input:not([id='ProcessDescriptionHZ-99921-99948'])input[type=checkbox][id^='ProcessDescriptionHZ-99921-']").removeAttr("checked");
				$("#ProcessDescriptionHZ-99921-99949").nextAll(".lable-input").val("");
				$("#ProcessDescriptionHZ-99921-99949").nextAll(".lable-input").hide();
			}else{
				$("#ProcessDescriptionHZ-99921-99948").removeAttr("checked");
			}
		}
	}
	
	/// 过程描述 4.皮损形态 勾选 无 取消非 无 的勾选项的勾选
	if(id.indexOf("ProcessDescriptionHZ-99922-")>=0){
		if($("input[type=checkbox][id^='ProcessDescriptionHZ-99922-").is(':checked')){
			if(id=="ProcessDescriptionHZ-99922-99980"){
				$("input:not([id='ProcessDescriptionHZ-99922-99980'])input[type=checkbox][id^='ProcessDescriptionHZ-99922-']").removeAttr("checked");
				$("#ProcessDescriptionHZ-99922-99981").nextAll(".lable-input").val("");
				$("#ProcessDescriptionHZ-99922-99981").nextAll(".lable-input").hide();
			}else{
				$("#ProcessDescriptionHZ-99922-99980").removeAttr("checked");
			}
		}
	}
	/// 过程描述 5.其他损害 勾选 无 取消非 无 的勾选项的勾选
	if(id.indexOf("ProcessDescriptionHZ-99923-")>=0){
		if($("input[type=checkbox][id^='ProcessDescriptionHZ-99923-").is(':checked')){
			if(id=="ProcessDescriptionHZ-99923-99986"){
				$("input:not([id='ProcessDescriptionHZ-99923-99986'])input[type=checkbox][id^='ProcessDescriptionHZ-99923-']").removeAttr("checked");
				$("#ProcessDescriptionHZ-99923-99987").nextAll(".lable-input").val("");
				$("#ProcessDescriptionHZ-99923-99987").nextAll(".lable-input").hide();
			}else{
				$("#ProcessDescriptionHZ-99923-99986").removeAttr("checked");
			}
		}
	}

}

//检查界面勾选其他，是否填写输入框
function checkother(){
	// 报告类型 严重 repTypeHz-99880
	var RepTypeList="",RepTypeOthErr="";
	if($("#repTypeHz-99880").is(':checked')){
		$("input[type=checkbox][id^='CriticalOptions-']").each(function(){
			if ($(this).is(':checked')){
				RepTypeList=this.value;
			}
		})
		if ((RepTypeList=="")){
			$.messager.alert($g("提示:"),$g("【报告类型】勾选'严重'，请勾选【严重选项】！"));	
			RepTypeOthErr=-1;
			return false;
		}
	}
	if(RepTypeOthErr=="-1"){
		return false;
	}
	
	// 化妆品信息-类别 
	var TypeList="",TypeOthErr="";
	$("input[type=radio][id^='Cosmetics-101199-101220-']").each(function(){
		if ($(this).is(':checked')){
				var TypeList="";
				var radiorowid=this.id.split(".")[0];
				var radiorownum=this.id.split(".")[1];
				var TypeValue=this.value;
				if(radiorowid.split("-").length==4){ // 特殊、 普通
					$("input[type=radio][id^='"+radiorowid+"-'][id$='."+radiorownum+"']").each(function(){
						if (($(this).is(':checked'))&&(this.value!="")){
							TypeList=this.value;
						}
					});
					if ((TypeValue!="")&&(TypeList=="")){
						$.messager.alert($g("提示:"),$g("【化妆品信息-类别】勾选'"+TypeValue+"'，请勾选相应内容！"));	
						TypeOthErr=-1;
						return false;
					}
				}
				
				if((radiorowid.split("-").length==5)&&(radiorowid.indexOf("Cosmetics-101199-101220-101236")>=0)){ //  普通  发用类 护肤类 美容修饰类 香水类
					$("input[type=radio][id^='"+radiorowid+"-'][id$='."+radiorownum+"']").each(function(){
							if (($(this).is(':checked'))&&(this.value!="")){
								TypeList=this.value;
							}
						});
						if ((TypeValue!="")&&(TypeValue!="香水类")&&(TypeList=="")){
							$.messager.alert($g("提示:"),$g("【化妆品信息-类别-普通】勾选'"+TypeValue+"'，请勾选相应内容！"));	
							TypeOthErr=-1;
							return false;
						}
				}
		}
	});
	if(TypeOthErr=="-1"){
		return false;
	}

	// 化妆品信息  化妆品有关斑贴试验 
	var BTDoneList="",BTOthErr="";
	$("input[type=radio][id^='Cosmetics-101199-101225-']").each(function(){
		if ($(this).is(':checked')){
				var BTDoneList="";
				var radiorowid=this.id.split(".")[0];
				var radiorownum=this.id.split(".")[1];
				if(radiorowid=="Cosmetics-101199-101225-101245"){
					BTDoneList=BTDoneList+$("input[id^='Cosmetics-101199-101225-101245-101280'][id$='."+radiorownum+"']").val();
					BTDoneList=BTDoneList+$("input[id^='Cosmetics-101199-101225-101245-101281'][id$='."+radiorownum+"']").val();
				}
				if((radiorowid=="Cosmetics-101199-101225-101245")&&(BTDoneList=="")){
					$.messager.alert($g("提示:"),$g("【化妆品信息-化妆品有关斑贴试验】勾选【已做】，请填写已做相应内容！"));	
					BTOthErr=-1;
					return false;
				}		
		}
	});
	if(BTOthErr=="-1"){
		return false;
	}
	
	// 化妆品信息  欧标、澳标变应原系列斑贴试验
	var OBDoneList="",OBOthErr="";
	$("input[type=radio][id^='Cosmetics-101199-101226-']").each(function(){
		if ($(this).is(':checked')){
				var OBDoneList="";
				var radiorowid=this.id.split(".")[0];
				var radiorownum=this.id.split(".")[1];
				if((radiorowid.split("-").length==4)||(radiorowid=="Cosmetics-101199-101226-101247")){ // 已做
					$("input[type=radio][id^='Cosmetics-101199-101226-101247-'][id$='."+radiorownum+"']").each(function(){
						if (($(this).is(':checked'))&&(this.value!="")){
							OBDoneList=this.value;
						}
					});
					if((radiorowid=="Cosmetics-101199-101226-101247")&&(OBDoneList=="")){
						$.messager.alert($g("提示:"),$g("【化妆品信息-欧标、澳标变应原系列斑贴试验】勾选【已做】，请勾选已做相应内容！"));	
						OBOthErr=-1;
						return false;
					}
				}
				if((radiorowid.split("-").length==5)||(radiorowid=="Cosmetics-101199-101226-101247-101287")){ // 有呈阳性受试物质
					OBDoneList=$("input[id^='Cosmetics-101199-101226-101247-101287-101327'][id$='."+radiorownum+"']").val();
					if((radiorowid=="Cosmetics-101199-101226-101247-101287")&&(OBDoneList=="")){
						$.messager.alert($g("提示:"),$g("【化妆品信息-欧标、澳标变应原系列斑贴试验-已做】勾选【有呈阳性受试物质】，请填写相应内容！"));		
						OBOthErr=-1;
						return false;
					}
				}
		}
	});
	if(OBOthErr=="-1"){
		return false;
	}
	// 化妆品信息  产品来源 
	var OrignErr="";
	$("input[type=radio][id^='Cosmetics-101199-101223-']").each(function(){
		if ($(this).is(':checked')){
			var radiorowid=this.id.split(".")[0];
			var radiorownum=this.id.split(".")[1];
			if((radiorowid=="Cosmetics-101199-101223-101242")&&($("input[type=radio][id^='"+radiorowid+"'][id$='."+radiorownum+"']").nextAll(".lable-input").val()=="")){ //UlcerPart-95158-95166-95182
				$.messager.alert($g("提示:"),$g("【化妆品信息-产品来源】勾选【其他】，请填写相应内容！"));	
				OrignErr=-1;
				return false;
			}
		}
	});
	if(OrignErr=="-1"){
		return false;
	}
	// 化妆品信息  其他辅助检查 
	var OthErr="";
	$("input[type=radio][id^='Cosmetics-101199-101227-101248']").each(function(){
		if ($(this).is(':checked')){
			var radiorowid=this.id.split(".")[0];
			var radiorownum=this.id.split(".")[1];
			if(($("input[id^='Cosmetics-101199-101227-101248-101310'][id$='."+radiorownum+"']").val()=="")){ //UlcerPart-95158-95166-95182
				$.messager.alert($g("提示:"),$g("【化妆品信息-其他辅助检查】勾选【有】，请填写名称！"));	
				OthErr=-1;
				return false;
			}
			if(($("input[id^='Cosmetics-101199-101227-101248-101312'][id$='."+radiorownum+"']").val()=="")){ //UlcerPart-95158-95166-95182
				$.messager.alert($g("提示:"),$g("【化妆品信息-其他辅助检查】勾选【有】，请填结果！"));	
				OthErr=-1;
				return false;
			}
		}
	});
	if(OthErr=="-1"){
		return false;
	}
	
	// 过程描述-皮损部位 
	var SkinList="",SkinOthErr="";
	$("input[type=checkbox][id^='ProcessDescriptionHZ-99921-']").each(function(){
		if ($(this).is(':checked')){
				var SkinList="";
				var radiorowid=this.id;
				var SkinValue=this.value;
				if(radiorowid.split("-").length==3){ 
					$("input[type=checkbox][id^='"+radiorowid+"-']").each(function(){
						if (($(this).is(':checked'))&&(this.value!="")){
							SkinList=this.value;
						}
					});
					if ((SkinValue=="面部")&&(SkinList=="")){
						$.messager.alert($g("提示:"),$g("【过程描述-皮损部位】勾选'"+SkinValue+"'，请勾选相应内容！"));	
						SkinOthErr=-1;
						return false;
					}
				}
			
		}
	});
	if(SkinOthErr=="-1"){
		return false;
	}
	return true;
}

function add_event(){
	reportControl();
}
