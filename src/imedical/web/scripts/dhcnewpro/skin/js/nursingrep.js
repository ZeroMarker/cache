/// Description: 护理不良事件
/// Creator: congyue
/// CreateDate: 2017-11-29
var eventtype=""
$(document).ready(function(){
	
	Assessscore(); //评估自动评分
	IfintNum();  //判断是否为正整数
	
});
//获取评估点击事件
function Assessscore(){
	//移动能力
	$("input[type=radio][name$='.88402']").live("click",function(event){
		eventtype=$("#NurEveType").combobox('getText')
		if (eventtype=="压疮事件"){
			score();
		}
	})
	//活动能力
	$("input[type=radio][name$='.88397']").live("click",function(event){
		eventtype=$("#NurEveType").combobox('getText')
		if (eventtype=="压疮事件"){
			score();
		}
	})
	//感知能力
	$("input[type=radio][name$='.88387']").live("click",function(event){
		eventtype=$("#NurEveType").combobox('getText')
		if (eventtype=="压疮事件"){
			score();
		}
	})
	//潮湿度
	$("input[type=radio][name$='.88392']").live("click",function(event){
		eventtype=$("#NurEveType").combobox('getText')
		if (eventtype=="压疮事件"){
			score();
		}
	})
	//移动摩擦和剪刀力
	$("input[type=radio][name$='.88412']").live("click",function(event){
		eventtype=$("#NurEveType").combobox('getText')
		if (eventtype=="压疮事件"){
			score();
		}
	})
	//营养支持
	$("input[type=radio][name$='.88407']").live("click",function(event){
		eventtype=$("#NurEveType").combobox('getText')
		if (eventtype=="压疮事件"){
			score();
		}
	})
	//组织灌注氧合
	$("input[type=radio][name$='.88459']").live("click",function(event){
		eventtype=$("#NurEveType").combobox('getText')
		if (eventtype=="压疮事件"){
			score();
		}
	})
	//一般情况
	$("input[type=radio][name$='.88464']").live("click",function(event){
		eventtype=$("#NurEveType").combobox('getText')
		if (eventtype=="压疮事件"){
			score();
		}
	})
	//意识状态
	$("input[type=radio][name$='.88469']").live("click",function(event){
		eventtype=$("#NurEveType").combobox('getText')
		if (eventtype=="压疮事件"){
			score();
		}
	})

}
//计算总分
function score(){
	
	var num=0;
	var MobileAbility=0,ActAbility=0,SensCapab=0,Damp=0,FrictShear=0,NutritSupport=0,QPerfuOxygen=0,NSituation=0,NConscState=0;
	
	//移动能力
	$("input[type=radio][name$='.88402']").each(function(){
		if($(this).is(':checked')){
			MobileAbility=this.value.replace(/[^0-9]/ig,"");
		}
	})
	//活动能力
	$("input[type=radio][name$='.88397']").each(function(){
		if($(this).is(':checked')){
			ActAbility=this.value.replace(/[^0-9]/ig,"");
		}
	})
	//感知能力
	$("input[type=radio][name$='.88387']").each(function(){
		if($(this).is(':checked')){
			SensCapab=this.value.replace(/[^0-9]/ig,"");
		}
	})
	//潮湿度
	$("input[type=radio][name$='.88392']").each(function(){
		if($(this).is(':checked')){
			Damp=this.value.replace(/[^0-9]/ig,"");
		}
	})
	//移动摩擦和剪刀力
	$("input[type=radio][name$='.88412']").each(function(){
		if($(this).is(':checked')){
			FrictShear=this.value.replace(/[^0-9]/ig,"");
		}
	})
	//营养支持
	$("input[type=radio][name$='.88407']").each(function(){
		if($(this).is(':checked')){
			NutritSupport=this.value.replace(/[^0-9]/ig,"");
		}
	})
	//组织灌注氧合
	$("input[type=radio][name$='.88459']").each(function(){
		if($(this).is(':checked')){
			QPerfuOxygen=this.value.replace(/[^0-9]/ig,"");
		}
	})
	//一般情况
	$("input[type=radio][name$='.88464']").each(function(){
		if($(this).is(':checked')){
			NSituation=this.value;
			NSituation=NSituation.replace(/[^0-9]/ig,"");
		}
	})
	//意识状态
	$("input[type=radio][name$='.88469']").each(function(){
		if($(this).is(':checked')){
			NConscState=this.value.replace(/[^0-9]/ig,"");
		}
	})
	num=parseInt(MobileAbility)+parseInt(ActAbility)+parseInt(SensCapab)+parseInt(Damp)+parseInt(FrictShear)+parseInt(NutritSupport)+parseInt(QPerfuOxygen)+parseInt(NSituation)+parseInt(NConscState);
	$('#Score').val(num+"分");

}
//判断输入是否符合规则
function IfintNum(){
	//误吸误咽次数  是否为大于0的整数
	$("#AspirNum").live("blur",function(event){
		eventtype=$("#NurEveType").combobox('getText')
		if (eventtype=="误吸/误咽事件"){
			var AspirNum=$("#AspirNum").val();   
			if(!(/(^\d+$)/.test(AspirNum))){
				$.messager.alert("提示:","请输入大于0的整数！");
				return ;	
			}
		}
	})
		
	//烧伤面积(%)
	$("#BurnArea").live("blur",function(event){
		eventtype=$("#NurEveType").combobox('getText')
		if (eventtype=="烧烫伤事件"){ //  ^(([0-9]+\\.[0-9]*[1-9][0-9]*)|([0-9]*[1-9][0-9]*\\.[0-9]+)|([0-9]*[1-9][0-9]*))$
			var BurnArea=Number($("#BurnArea").val());    //^(([0-9]{1,2})|([0-9]{1,2}))$|100
			if((BurnArea >100 )|| (BurnArea <0)||isNaN(BurnArea) ||((BurnArea == 100 || BurnArea == 0)&& (String(BurnArea) != $("#BurnArea").val()))){
				$.messager.alert("提示:","请输入符合百分比的数！");
				return ;
			}
			
		}
	})

}