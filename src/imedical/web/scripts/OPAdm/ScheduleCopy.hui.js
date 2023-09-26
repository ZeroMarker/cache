$(function(){
	var hospComp = GenUserHospComp();
	//事件初始化
	InitEvent();
});
function InitEvent(){
	$("#BCopy").click(CopyClick);
}
function CopyClick(){
	var FromDate=$("#FromDate").datebox('getValue');
	var ToDate=$("#ToDate").datebox('getValue'); 
	var StartDate=$("#StartDate").datebox('getValue'); 
	var EndDate=$("#EndDate").datebox('getValue');
	var CopyByOneWeek=$("#CopyByOneWeek").checkbox('getValue')?'on':'';
	var ret=$.cm({
	    ClassName : "web.DHCRBApptSchedule",
	    MethodName : "CopySchedules",
	    CopyStartDate:FromDate, CopyEndDate:ToDate, CreatStartDate:StartDate, CreatEndDate:EndDate, CopyByOneWeek:CopyByOneWeek,
	    HospID:$HUI.combogrid('#_HospUserList').getValue(),
	    dataType:"text"
	},false)
	if (ret!=0){
		$.messager.alert("提示","复制排班失败！"+ret.split("^")[1])
		return false
	}else{
		$.messager.popover({msg: '复制排班成功!',type:'success',timeout: 1000});
	}
}
function myformatter(date){
	var y = date.getFullYear();
	var m = date.getMonth()+1;
	var d = date.getDate();
	if (ServerObj.sysDateFormat=="3") return y+'-'+(m<10?('0'+m):m)+'-'+(d<10?('0'+d):d);
	else if (ServerObj.sysDateFormat=="4") return (d<10?('0'+d):d)+"/"+(m<10?('0'+m):m)+"/"+y
	else return y+'-'+(m<10?('0'+m):m)+'-'+(d<10?('0'+d):d);
}
function myparser(s){
    if (!s) return new Date();
    if(ServerObj.sysDateFormat=="4"){
		var ss = s.split('/');
		var y = parseInt(ss[2],10);
		var m = parseInt(ss[1],10);
		var d = parseInt(ss[0],10);
	}else{
		var ss = s.split('-');
		var y = parseInt(ss[0],10);
		var m = parseInt(ss[1],10);
		var d = parseInt(ss[2],10);
	}
	if (!isNaN(y) && !isNaN(m) && !isNaN(d)){
		return new Date(y,m-1,d);
	} else {
		return new Date();
	}
}