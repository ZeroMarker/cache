
///Descript: 陪送工作量统计
///Creator:  zhaowuqiang
//CreatDate: 2017-04-08

var p_URL="";
$(function(){
	
	$('#Search').bind("click",Query);  //点击查询
	
})
function Query()
{
	var StDate=$('#StDate').datebox('getValue');
	var EndDate=$('#EndDate').datebox('getValue');
	if((StDate=="")||(EndDate==""))
	{
		//$.message.alert("提示:","日期不能为空！");
		$.messager.alert('日期不能为空！');  
		return;
	}
	
	p_URL = 'dhccpmrunqianreport.csp?reportName=DTHealth-DIS-陪送工作量统计(按人员).raq&StDate='+StDate+'&EndDate='+EndDate;
	var reportframe=document.getElementById("reportFrame")
	reportframe.src=p_URL;

}