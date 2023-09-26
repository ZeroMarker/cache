/// Description: 医疗护理风险防范(堵漏/隐患)事件报告单
/// Creator: congyue
/// CreateDate: 2017-12-15
var eventtype=""
$(document).ready(function(){
	
	$('#AFLoc').combobox({ 
		//url:'dhcapp.broker.csp?ClassName=web.DHCADVCOMMONPART&MethodName=QueryLocDescCombo',
		mode:'remote',  //,  //必须设置这个属性
		onShowPanel:function(){ 
			$('#AFLoc').combobox('reload','dhcapp.broker.csp?ClassName=web.DHCADVCOMMONPART&MethodName=QueryLocDescCombo&hospId='+LgHospID+'')
		}
	});
	$('#WallLoc').combobox({ 
		//url:'dhcapp.broker.csp?ClassName=web.DHCADVCOMMONPART&MethodName=QueryLocDescCombo',
		mode:'remote',  //,  //必须设置这个属性
		onShowPanel:function(){ 
			$('#WallLoc').combobox('reload','dhcapp.broker.csp?ClassName=web.DHCADVCOMMONPART&MethodName=QueryLocDescCombo&hospId='+LgHospID+'')
		}
	});
	$("#SaveBut").on("click",function(){
		SaveWallReport(0);
	})
	$("#SubmitBut").on("click",function(){
		SaveWallReport(1);
	})
	//发现日期控制
	$('#FindDate').datebox().datebox('calendar').calendar({
		validator: function(date){
			var now = new Date();
			return date<=now;
		}
	});
	CheckTimeornum();  //时间校验
	InitWallReport(recordId);//加载页面信息
	
});
//加载报表信息
function InitWallReport(recordId)
{
	if((recordId=="")||(recordId==undefined)){	
		$('#AFLoc').combobox('setValue',LgCtLocDesc);  //发生科室
		//$('#AFLoc').combobox('setText',LgCtLocDesc);  //发生科室
		$('#WallDiscover').val(LgUserName); //默认发现人为登录人
		$('#WallDiscover').attr("readonly","readonly"); //默认发现人为登录人
	}else{
		$('#WallDiscover').attr("readonly","readonly"); //默认发现人为登录人
	}
}
//报告保存
function SaveWallReport(flag)
{
	///保存前,对页面必填项进行检查
	if(!checkRequired()){
		return;
	}
	//判断勾选其他时，input是否填写 -93871
	var RelatedAreasoth=0
	$("input[type=checkbox][id^='RelatedAreas']").each(function(){
		if($(this).is(':checked')){
			if ((this.value=="title")&&($("input[class='lable-input']").val()=="")){
				RelatedAreasoth=-1;				
			}
		}
	})
	if (RelatedAreasoth==-1){
		$.messager.alert("提示:","【相关领域】勾选'其他'，请填写内容！");	
		return ;
	}
	SaveReport(flag);
}

//时间 数字校验
function CheckTimeornum(){
	//数字输入校验  WallWorkYears
	//工作年限(年)
	$('#WallWorkYears').live("keyup",function(){
		this.value=this.value.replace(/\D/g,'');
	})
	//工作年限(年)
	$('#WLManWorkLife').live("keyup",function(){
		this.value=this.value.replace(/\D/g,'');
	})

}

