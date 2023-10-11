function getRegNo(regno)
{
	//return regno;
	var len=regno.length;
	var  reglen=10
	var zerolen=reglen-len
	var zero=""
	for (var i=1;i<=zerolen;i++)
	{zero=zero+"0" ;
		}
	return zero+regno ;
}
function dhcsys_getmenuform(){
	var frm = null;
	try{
		var win=top.frames['eprmenu'];
		if (win) {
			frm = win.document.forms['fEPRMENU'];
			if(frm) return frm;
		}
		//在新窗口打开的界面
		win = opener;
		if (win) {
			frm = win.document.forms['fEPRMENU'];
			if (frm) return frm;
		}
		win = parent.frames[0];
		if (win){
			frm = win.document.forms["fEPRMENU"];
			if (frm) return frm;
		}
		if (top){
			frm =top.document.forms["fEPRMENU"];
			if(frm) return frm
		}
	}catch(e){}
	return frm;
}
//获取评估权限标志
function GetAssessAuthority(ReportID,params)
{
	var Assessflag="";
	$.ajax({
		type: "POST",
		url: "dhcadv.repaction.csp",
		async: false, //同步
		data: "action=GetAssessAuthority&ReportID="+ReportID+"&params="+params,
		success: function(val){						
			Assessflag=val.replace(/(^\s*)|(\s*$)/g,"");
		}
	});
	return Assessflag ;
}

//选择时间与当前时间比较 2017-03-06
function compareSelTimeAndCurTime(SelDateTime)
{
	var SelDateArr="",SelYear="",SelMonth="",SelDate="";
	if(DateFormat=="4"){ //日期格式 4:"DMY" DD/MM/YYYY
		SelDateArr=SelDateTime.split("/");
		SelYear=SelDateArr[2];
		SelMonth=parseInt(SelDateArr[1]);
		SelDate=parseInt(SelDateArr[0]);
	}else if(DateFormat=="3"){ //日期格式 3:"YMD" YYYY-MM-DD
		SelDateArr=SelDateTime.split("-");
		SelYear=SelDateArr[0];
		SelMonth=parseInt(SelDateArr[1]);
		SelDate=parseInt(SelDateArr[2]);
	}else if(DateFormat=="1"){ //日期格式 1:"MDY" MM/DD/YYYY
		SelDateArr=SelDateTime.split("/");
		SelYear=SelDateArr[2];
		SelMonth=parseInt(SelDateArr[0]);
		SelDate=parseInt(SelDateArr[1]);
	}
	
	var myDate=new Date();
	var curYear=myDate.getFullYear();
	if(SelYear>curYear){
		return false;
	}
	var curMonth=myDate.getMonth()+1;
	if((SelYear==curYear)&(SelMonth>curMonth)){
		return false;
	}
	var curDate=myDate.getDate();
	if((SelYear==curYear)&(SelMonth==curMonth)&(SelDate>curDate)){
		return false;
	}
	return true;
}


$(document).ready(function(){
		$('textarea').keydown(function(e){
		if(e.keyCode==13){
   			//pos=$(this).getFieldPos()
   			//$(this).insertPos(pos,"\n")
		}
	});
})	
