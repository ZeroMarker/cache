/// Description: 器械不良事件
/// Creator: zwq
/// CreateDate: 2017-08-04

$(document).ready(function(){
	$('#DModelWrite').click(function(){
		Mould();
	})	
 	$("#SaveBut").on("click",function(){
		JudgmentDate();
	})
	$("#SubmitBut").on("click",function(){
		JudgmentDate();
	}) 
	
});

//提交保存是判断器械几种日期是否符合逻辑判断 dws 2017-11-24
function JudgmentDate(){
	var effectDate=$("input[name='153159.89802']").val(); //有效日期
	var effectDate=new Date(Date.parse(effectDate));
	var productDate=$("input[name='153163.89811']").val(); //生产日期
	var productDate=new Date(Date.parse(productDate));
	var stopDate=$("input[name='153170.89813']").val(); //停用日期
	var stopDate=new Date(Date.parse(stopDate));
	var inDate=$("input[name='153174.89815']").val(); //植入日期
	var inDate=new Date(Date.parse(inDate));
	
	if(effectDate<productDate){
		$.messager.alert('Warning','器械有效日期不能小于生产日期!');
		return;
	}
	if(stopDate<productDate){
		$.messager.alert('Warning','器械停用日期不能小于生产日期!');
		return;
	}
	if((inDate!="Invalid Date")&&(inDate<productDate)){
		$.messager.alert('Warning','器械植入日期不能小于生产日期!');
		return;
	}
}

//创建模板填写窗体  2017-08-23  zwq
function Mould()
{
	$('#MouldTable').window({
		title:'填写模板',
		collapsible:false,
		border:false,
		closed:"true",
		minimizable:false,
		maximizable:false,
		resizable:false,
		width:430,
		height:550
	}); 
	$('#MouldTable').window('open');
	//$('#matadrEventDesc').val();
	$('#MT1').datebox("setValue","");;   
	$('#MT2').val("");
	$('#MT3').val("");
	$('#MT4').val("");
	$('#MT5').val("");
	$('#MT6').val("");
	$('#MT7').datebox("setValue","");
	$('#MT8').val("");
	$('#MT9').datebox("setValue","");
	$('#MT10').val("");
	$('#MT11').val("");
}
//赋值到Textarea 2017-08-23  zwq
function saveMouldTable(){
	var EventDesc=$('#ProcessDesc').val()
	var MT1=$('#MT1').datebox('getValue');   
	var MT2=$('#MT2').val();
	var MT3=$('#MT3').val();
	var MT4=$('#MT4').val();
	var MT5=$('#MT5').val();
	var MT6=$('#MT6').val();
	var MT7=$('#MT7').datebox('getValue');
	var MT8=$('#MT8').val();
	var MT9=$('#MT9').datebox('getValue');
	var MT10=$('#MT10').val();
	var MT11=$('#MT11').val();
	var Str1="",Str2="",Str3="",Str4="",Str5="",Str6="",Str7="",Str8="",Str9="",Str10="",Str11="";
	if (MT1!==""){
		Str1="器械使用时间:"+MT1+"；";
	}
	if (MT2!==""){
		Str2="使用目的:"+MT2+"；";
	}
	if (MT3!==""){
		Str3="使用依据:"+MT3+"；";
	}
	if (MT4!==""){
		Str4="使用情况:"+MT4+"；";
	}
	if (MT5!==""){
		Str5="不良事件情况:"+MT5+"；";
	}
	if (MT6!==""){
		Str6="对患者影响:"+MT6+"；";
	}
	if (MT7!==""){
		Str7="采取治疗措施时间:"+MT7+"；";
	}
	if (MT8!==""){
		Str8="采取治疗措施:"+MT8+"；";
	}
	if (MT9!==""){
		Str9="不良事件好转时间:"+MT9+"；";
	}
	if (MT10!==""){
		Str10="器械联合使用情况:"+MT10+"；";
	}
	if (MT11!==""){
		Str11="事件发生医院:"+MT11+"；";
	}
	var EventDesc=EventDesc+Str1+Str2+Str3+Str4+Str5+Str6+Str7+Str8+Str9+Str10+Str11;
	$('#ProcessDesc').val(EventDesc);
	$('#MouldTable').window('close');
}

