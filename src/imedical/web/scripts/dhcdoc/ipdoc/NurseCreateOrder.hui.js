$(function(){
	//初始化
	Init();
	//事件初始化
	InitEvent();
});
function Init(){
	if (ServerObj.EpisodeID!=""){
		var rtn=$.cm({ 
			ClassName:"web.DHCDocIPBookNew",
			MethodName:"GetPatDetail",
			PatientID:"",
			PatientNO:"",
			AdmID:ServerObj.EpisodeID,
			dataType:"text"
		},false);
		ServerObj.PatientNo=rtn.split("^")[1];
		$("#PatientNo").val(ServerObj.PatientNo);
	}else{
		$(".CreateByWard-tr").hide();
	}
	$("#StartDate").datebox('setValue',ServerObj.defStartDate);
	$("#EndDate").datebox('setValue',ServerObj.defEndDate);
	$("#wardDesc").val(ServerObj.wardDesc);
}
function InitEvent(){
	$("#Create").click(CreateClickHandle);
}
function CreateClickHandle(){
	DisableBtn("Create",true);
	var StartDate=$("#StartDate").datebox('getValue');
	var EndDate=$("#EndDate").datebox('getValue');
	if(StartDate==""){
		$.messager.alert("提示","开始日期不能为空!","info",function(){
			DisableBtn("Create",false);
		});
		return false;	
	}
	if(EndDate==""){
		$.messager.alert("提示","结束日期不能为空!","info",function(){
			DisableBtn("Create",false);
		});
		return false;	
	}
	var day=DateDiff(StartDate,EndDate);
	if(day>3){
		if (day>7){
			$.messager.alert("提示","不能生成超过7天的医嘱,请修改日期!","info",function(){
				DisableBtn("Create",false);
			});
			return false;
		}
		$.messager.confirm('确认对话框', '将生成超过三天的医嘱,是否继续?', function(r){
			if (r){
			    Creat();
			    return false;
			}else{
				DisableBtn("Create",false);
			}
		});
	}else{
		Creat();
	}
	function Creat(){
		if ($("#CreateByWard").checkbox('getValue')) ServerObj.PatientNo="";
		var ret=tkMakeServerCall('web.DHCCreateOrder','CreateOrder',StartDate,EndDate,ServerObj.PatientNo,ServerObj.EpisodeID,session['LOGON.WARDID']);
	    if (ret==0){
			$.messager.alert("提示","滚医嘱成功!");
		}else if (ret==-100){
			$.messager.alert("提示","未找到病区.");
		}else if (ret==-101){
			$.messager.alert("提示","该病区存在[生成长期领药医嘱]进程,为缓解系统压力,请稍后再试.");
		}else if (ret==-200){
			$.messager.alert("提示","未找到病人就诊记录.");
		}else if (ret==-201){
			$.messager.alert("提示","该病人存在[生成长期领药医嘱]进程,为缓解系统压力,请稍后再试.");
		}else{
			$.messager.alert("提示","滚医嘱失败!")
		}
		DisableBtn("Create",false);
	}
}
function DisableBtn(id,disabled){
	if (disabled){
		$HUI.linkbutton("#"+id).disable();
	}else{
		$HUI.linkbutton("#"+id).enable();
	}
}
function DateDiff(sDate1,sDate2){  
   var aDate,oDate1,oDate2,iDays ;
   if(ServerObj.sysDateFormat=="4"){
	   aDate =sDate1.split('/'); 
	   oDate1 = new Date(aDate[1]+'-'+aDate[0]+'-'+aDate[2]) ;
	   //转换为04-19-2007格式 
	   aDate = sDate2.split('/'); 
	   oDate2 = new Date(aDate[1]+'-'+ aDate[0] +'-'+aDate[2]); 
   }else{
	   aDate =sDate1.split('-'); 
	   oDate1 = new Date(aDate[1]+'-'+aDate[2]+'-'+aDate[0]) ;
	   //转换为04-19-2007格式 
	   aDate = sDate2.split('-'); 
	   oDate2 = new Date(aDate[1]+'-'+ aDate[2] +'-'+aDate[0]); 
   }
   iDays = parseInt(Math.abs(oDate2 -oDate1)/1000/60/60/24);//把相差的毫秒数转换为天数 
   return iDays+1 ;
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
///得到菜单参数
function GetMenuPara(ParaName) {
    var myrtn = "";
    var frm = dhcsys_getmenuform();
    if (frm) {
        myrtn = eval("frm." + ParaName + ".value");
    }
    return myrtn;
}
