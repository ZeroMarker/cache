/// Description: �������¼�
/// Creator: congyue
/// CreateDate: 2017-11-29
var eventtype=""
$(document).ready(function(){
	
	Assessscore(); //�����Զ�����
	IfintNum();  //�ж��Ƿ�Ϊ������
	
});
//��ȡ��������¼�
function Assessscore(){
	//�ƶ�����
	$("input[type=radio][name$='.88402']").live("click",function(event){
		eventtype=$("#NurEveType").combobox('getText')
		if (eventtype=="ѹ���¼�"){
			score();
		}
	})
	//�����
	$("input[type=radio][name$='.88397']").live("click",function(event){
		eventtype=$("#NurEveType").combobox('getText')
		if (eventtype=="ѹ���¼�"){
			score();
		}
	})
	//��֪����
	$("input[type=radio][name$='.88387']").live("click",function(event){
		eventtype=$("#NurEveType").combobox('getText')
		if (eventtype=="ѹ���¼�"){
			score();
		}
	})
	//��ʪ��
	$("input[type=radio][name$='.88392']").live("click",function(event){
		eventtype=$("#NurEveType").combobox('getText')
		if (eventtype=="ѹ���¼�"){
			score();
		}
	})
	//�ƶ�Ħ���ͼ�����
	$("input[type=radio][name$='.88412']").live("click",function(event){
		eventtype=$("#NurEveType").combobox('getText')
		if (eventtype=="ѹ���¼�"){
			score();
		}
	})
	//Ӫ��֧��
	$("input[type=radio][name$='.88407']").live("click",function(event){
		eventtype=$("#NurEveType").combobox('getText')
		if (eventtype=="ѹ���¼�"){
			score();
		}
	})
	//��֯��ע����
	$("input[type=radio][name$='.88459']").live("click",function(event){
		eventtype=$("#NurEveType").combobox('getText')
		if (eventtype=="ѹ���¼�"){
			score();
		}
	})
	//һ�����
	$("input[type=radio][name$='.88464']").live("click",function(event){
		eventtype=$("#NurEveType").combobox('getText')
		if (eventtype=="ѹ���¼�"){
			score();
		}
	})
	//��ʶ״̬
	$("input[type=radio][name$='.88469']").live("click",function(event){
		eventtype=$("#NurEveType").combobox('getText')
		if (eventtype=="ѹ���¼�"){
			score();
		}
	})

}
//�����ܷ�
function score(){
	
	var num=0;
	var MobileAbility=0,ActAbility=0,SensCapab=0,Damp=0,FrictShear=0,NutritSupport=0,QPerfuOxygen=0,NSituation=0,NConscState=0;
	
	//�ƶ�����
	$("input[type=radio][name$='.88402']").each(function(){
		if($(this).is(':checked')){
			MobileAbility=this.value.replace(/[^0-9]/ig,"");
		}
	})
	//�����
	$("input[type=radio][name$='.88397']").each(function(){
		if($(this).is(':checked')){
			ActAbility=this.value.replace(/[^0-9]/ig,"");
		}
	})
	//��֪����
	$("input[type=radio][name$='.88387']").each(function(){
		if($(this).is(':checked')){
			SensCapab=this.value.replace(/[^0-9]/ig,"");
		}
	})
	//��ʪ��
	$("input[type=radio][name$='.88392']").each(function(){
		if($(this).is(':checked')){
			Damp=this.value.replace(/[^0-9]/ig,"");
		}
	})
	//�ƶ�Ħ���ͼ�����
	$("input[type=radio][name$='.88412']").each(function(){
		if($(this).is(':checked')){
			FrictShear=this.value.replace(/[^0-9]/ig,"");
		}
	})
	//Ӫ��֧��
	$("input[type=radio][name$='.88407']").each(function(){
		if($(this).is(':checked')){
			NutritSupport=this.value.replace(/[^0-9]/ig,"");
		}
	})
	//��֯��ע����
	$("input[type=radio][name$='.88459']").each(function(){
		if($(this).is(':checked')){
			QPerfuOxygen=this.value.replace(/[^0-9]/ig,"");
		}
	})
	//һ�����
	$("input[type=radio][name$='.88464']").each(function(){
		if($(this).is(':checked')){
			NSituation=this.value;
			NSituation=NSituation.replace(/[^0-9]/ig,"");
		}
	})
	//��ʶ״̬
	$("input[type=radio][name$='.88469']").each(function(){
		if($(this).is(':checked')){
			NConscState=this.value.replace(/[^0-9]/ig,"");
		}
	})
	num=parseInt(MobileAbility)+parseInt(ActAbility)+parseInt(SensCapab)+parseInt(Damp)+parseInt(FrictShear)+parseInt(NutritSupport)+parseInt(QPerfuOxygen)+parseInt(NSituation)+parseInt(NConscState);
	$('#Score').val(num+"��");

}
//�ж������Ƿ���Ϲ���
function IfintNum(){
	//�������ʴ���  �Ƿ�Ϊ����0������
	$("#AspirNum").live("blur",function(event){
		eventtype=$("#NurEveType").combobox('getText')
		if (eventtype=="����/�����¼�"){
			var AspirNum=$("#AspirNum").val();   
			if(!(/(^\d+$)/.test(AspirNum))){
				$.messager.alert("��ʾ:","���������0��������");
				return ;	
			}
		}
	})
		
	//�������(%)
	$("#BurnArea").live("blur",function(event){
		eventtype=$("#NurEveType").combobox('getText')
		if (eventtype=="�������¼�"){ //  ^(([0-9]+\\.[0-9]*[1-9][0-9]*)|([0-9]*[1-9][0-9]*\\.[0-9]+)|([0-9]*[1-9][0-9]*))$
			var BurnArea=Number($("#BurnArea").val());    //^(([0-9]{1,2})|([0-9]{1,2}))$|100
			if((BurnArea >100 )|| (BurnArea <0)||isNaN(BurnArea) ||((BurnArea == 100 || BurnArea == 0)&& (String(BurnArea) != $("#BurnArea").val()))){
				$.messager.alert("��ʾ:","��������ϰٷֱȵ�����");
				return ;
			}
			
		}
	})

}