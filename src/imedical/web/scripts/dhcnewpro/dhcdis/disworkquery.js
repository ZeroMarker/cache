
///Descript: ���͹�����ͳ��
///Creator:  zhaowuqiang
//CreatDate: 2017-04-08

var p_URL="";
$(function(){
	
	$('#Search').bind("click",Query);  //�����ѯ
	
})
function Query()
{
	var StDate=$('#StDate').datebox('getValue');
	var EndDate=$('#EndDate').datebox('getValue');
	if((StDate=="")||(EndDate==""))
	{
		//$.message.alert("��ʾ:","���ڲ���Ϊ�գ�");
		$.messager.alert('���ڲ���Ϊ�գ�');  
		return;
	}
	
	p_URL = 'dhccpmrunqianreport.csp?reportName=DTHealth-DIS-���͹�����ͳ��(����Ա).raq&StDate='+StDate+'&EndDate='+EndDate;
	var reportframe=document.getElementById("reportFrame")
	reportframe.src=p_URL;

}