//===============================================================================
// ��    ��: cookie�����ļ�
// ��    ��: cookie�����á���ȡ��ɾ��
// �� д �ߣ�������
// ��д����: 2010-12-16
//===============================================================================

//����cookies����,����������name:cookie���ƣ�value:cookieֵ
var setCookie=function(name,value){
	//����cookie��������
    var Days = 30; 
	//����cookie������
    var exp  = new Date();    //new Date("December 31, 9998");
	//����cookie��ʱ�䳤
    exp.setTime(exp.getTime() + Days*24*60*60*1000);
	//����cookie
    document.cookie = name + "="+ escape (value) + ";expires=" + exp.toGMTString();
}

//����cookie���ƻ�ȡcookie����,һ��������name:cookie����
var getCookie=function(name){
    var arr = document.cookie.match(new RegExp("(^| )"+name+"=([^;]*)(;|$)"));
	
    if(arr != null){
		return unescape(arr[2]);
	}else{
		return null;
	}
}

//����cookie����ɾ��cookie����,һ��������name:cookie����
var delCookie=function(name){
    var exp = new Date();
    exp.setTime(exp.getTime() - 1);
    var cval=getCookie(name);
    if(cval!=null){
		document.cookie= name + "="+cval+";expires="+exp.toGMTString();
	}
}
