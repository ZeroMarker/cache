/// Description: ��е�����¼�
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

//�ύ�������ж���е���������Ƿ�����߼��ж� dws 2017-11-24
function JudgmentDate(){
	var effectDate=$("input[name='153159.89802']").val(); //��Ч����
	var effectDate=new Date(Date.parse(effectDate));
	var productDate=$("input[name='153163.89811']").val(); //��������
	var productDate=new Date(Date.parse(productDate));
	var stopDate=$("input[name='153170.89813']").val(); //ͣ������
	var stopDate=new Date(Date.parse(stopDate));
	var inDate=$("input[name='153174.89815']").val(); //ֲ������
	var inDate=new Date(Date.parse(inDate));
	
	if(effectDate<productDate){
		$.messager.alert('Warning','��е��Ч���ڲ���С����������!');
		return;
	}
	if(stopDate<productDate){
		$.messager.alert('Warning','��еͣ�����ڲ���С����������!');
		return;
	}
	if((inDate!="Invalid Date")&&(inDate<productDate)){
		$.messager.alert('Warning','��еֲ�����ڲ���С����������!');
		return;
	}
}

//����ģ����д����  2017-08-23  zwq
function Mould()
{
	$('#MouldTable').window({
		title:'��дģ��',
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
//��ֵ��Textarea 2017-08-23  zwq
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
		Str1="��еʹ��ʱ��:"+MT1+"��";
	}
	if (MT2!==""){
		Str2="ʹ��Ŀ��:"+MT2+"��";
	}
	if (MT3!==""){
		Str3="ʹ������:"+MT3+"��";
	}
	if (MT4!==""){
		Str4="ʹ�����:"+MT4+"��";
	}
	if (MT5!==""){
		Str5="�����¼����:"+MT5+"��";
	}
	if (MT6!==""){
		Str6="�Ի���Ӱ��:"+MT6+"��";
	}
	if (MT7!==""){
		Str7="��ȡ���ƴ�ʩʱ��:"+MT7+"��";
	}
	if (MT8!==""){
		Str8="��ȡ���ƴ�ʩ:"+MT8+"��";
	}
	if (MT9!==""){
		Str9="�����¼���תʱ��:"+MT9+"��";
	}
	if (MT10!==""){
		Str10="��е����ʹ�����:"+MT10+"��";
	}
	if (MT11!==""){
		Str11="�¼�����ҽԺ:"+MT11+"��";
	}
	var EventDesc=EventDesc+Str1+Str2+Str3+Str4+Str5+Str6+Str7+Str8+Str9+Str10+Str11;
	$('#ProcessDesc').val(EventDesc);
	$('#MouldTable').window('close');
}

