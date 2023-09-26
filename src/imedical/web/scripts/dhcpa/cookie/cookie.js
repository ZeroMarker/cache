//===============================================================================
// 名    称: cookie设置文件
// 描    述: cookie的设置、获取和删除
// 编 写 者：李明忠
// 编写日期: 2010-12-16
//===============================================================================

//设置cookies函数,两个参数，name:cookie名称，value:cookie值
var setCookie=function(name,value){
	//设置cookie保存天数
    var Days = 30; 
	//设置cookie的日期
    var exp  = new Date();    //new Date("December 31, 9998");
	//设置cookie的时间长
    exp.setTime(exp.getTime() + Days*24*60*60*1000);
	//保存cookie
    document.cookie = name + "="+ escape (value) + ";expires=" + exp.toGMTString();
}

//根据cookie名称获取cookie函数,一个参数，name:cookie名称
var getCookie=function(name){
    var arr = document.cookie.match(new RegExp("(^| )"+name+"=([^;]*)(;|$)"));
	
    if(arr != null){
		return unescape(arr[2]);
	}else{
		return null;
	}
}

//根据cookie名称删除cookie函数,一个参数，name:cookie名称
var delCookie=function(name){
    var exp = new Date();
    exp.setTime(exp.getTime() - 1);
    var cval=getCookie(name);
    if(cval!=null){
		document.cookie= name + "="+cval+";expires="+exp.toGMTString();
	}
}
