var DateFormat="";
$(function(){
	DateFormat=tkMakeServerCall("websys.Conversions","DateFormat");
	//CreateWindow("Dialog_DeathDateTime");
	//SetDefaultDate();
	$("#BSave").click(BSaveClickHandle);
	$("#BCancel").click(BCancelClickHandle);
})
function BSaveClickHandle(){
	var DeathDate=$("#DeathDate").datebox('getValue');
	var DeathTime=$("#DeathTime").timespinner('getValue'); //$("#DeathTime").val();
	if(DeathDate==""){
		$.messager.alert("提示信息","请填写死亡日期");
		return false;	
	}
	if(DeathTime==""){
		$.messager.alert("提示信息","请填写死亡时间");
		return false;	
	}
	
	var returnstr=DeathDate+"!"+DeathTime;
	var cret=tkMakeServerCall("web.DHCDocUtil","CompareSysDateTime",returnstr)
	if(cret=="0"){
		$.messager.alert("提示信息","死亡时间不能晚于当前时间");
		return false;	
	}
	if (websys_showModal('options').CallBackFunc) {
		websys_showModal('options').CallBackFunc(returnstr);
	}else{
		window.returnValue=returnstr;
		window.close();
	}
}
function BCancelClickHandle(){
	if (websys_showModal('options').CallBackFunc) {
		websys_showModal('options').CallBackFunc(null);
	}else{
		window.returnValue=null;
		window.close();
	}
}
/*function CreateWindow(param1) {
	//默认宽高
	var winWidth=300;
	var winHeight=250;
	//获取窗口宽度
	if (window.innerWidth) winWidth = window.innerWidth;
	else if ((document.body) && (document.body.clientWidth)) winWidth = document.body.clientWidth;
	//获取窗口高度
	if (window.innerHeight) winHeight = window.innerHeight;
	else if ((document.body) && (document.body.clientHeight)) winHeight = document.body.clientHeight;
	$("#"+param1+"").dialog({
		width:winWidth,    
		height:winHeight,
		title:"填写患者死亡时间",
		closed:false,
		cache: false,
		modal:true,
		inline:true,
		buttons:[{
			text:'保存',
			iconCls:'icon-save',
			handler:function(){
				var DeathDate=$("#DeathDate").datebox('getValue');
				var DeathTime=$("#DeathTime").val();
				if(DeathDate==""){
					$.messager.alert("提示信息","请填写死亡日期");
					return false;	
				}
				if(DeathTime==""){
					$.messager.alert("提示信息","请填写死亡时间");
					return false;	
				}
				
				var returnstr=DeathDate+"!"+DeathTime;
				var cret=tkMakeServerCall("web.DHCDocUtil","CompareSysDateTime",returnstr)
				if(cret=="0"){
					$.messager.alert("提示信息","死亡时间不能晚于当前时间");
					return false;	
				}
				window.returnValue=returnstr;
				window.close();
			}
		},{
			text:'取消',
			iconCls:'icon-cancel',
			handler:function(){
				window.returnValue=null;
				window.close();
			}
		}]
	});
}*/

function myformatter(date){
	var y = date.getFullYear();
	var m = date.getMonth()+1;
	var d = date.getDate();
	//return y+'-'+(m<10?('0'+m):m)+'-'+(d<10?('0'+d):d);
	if (DateFormat==3){
		return y+'-'+(m<10?('0'+m):m)+'-'+(d<10?('0'+d):d);
	}else if(DateFormat==4){
		return (d<10?('0'+d):d)+"/"+(m<10?('0'+m):m)+"/"+y
	}
}
function myparser(s){
	if (!s) return new Date();
	if (DateFormat==3){
		var ss = s.split('-');
		var y = parseInt(ss[0],10);
		var m = parseInt(ss[1],10);
		var d = parseInt(ss[2],10);
		if (!isNaN(y) && !isNaN(m) && !isNaN(d)){
			return new Date(y,m-1,d);
		} else {
			return new Date();
		}
	}else if(DateFormat==4){
		var ss = s.split('/');
		var y = parseInt(ss[2],10);
		var m = parseInt(ss[1],10);
		var d = parseInt(ss[0],10);
		if (!isNaN(y) && !isNaN(m) && !isNaN(d)){
			return new Date(y,m-1,d);
		} else {
			return new Date();
		}
	}
}

function SetDefaultDate()  
{     
    /*var curr_time=new Date();     
    var strDate=curr_time.getFullYear()+"-";     
	strDate +=curr_time.getMonth()+1+"-";     
    strDate +=curr_time.getDate();     
   	strTime =curr_time.getHours()+":";     
    strTime +=curr_time.getMinutes()+":";     
    strTime +=curr_time.getSeconds();*/
    var gret=tkMakeServerCall("web.DHCDocUtil","GetHisSysDateTime",DateFormat);
    var gretArr=gret.split(String.fromCharCode(1));
    var strDate =gretArr[0];
    var strTime =gretArr[1]
    $("#DeathDate").datebox("setValue",strDate);  
   	$("#DeathTime").timespinner("setValue",strTime);  
} 
	