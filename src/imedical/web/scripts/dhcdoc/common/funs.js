//�����ַ�����ȡdate����
function GetDateObj(DateStr)
{
    if(typeof DateStr=='object') return DateStr;
    var dim='',formater='';
    if(DateStr.indexOf('/')>-1) dim='/',formater='DMY';
    else if(DateStr.indexOf('-')>-1) dim='-',formater='YMD';
    var dateArr=DateStr.split(dim);
    var dateObj=new Array();
    for(var i=0;i<formater.length;i++){
        var c=formater.charAt(i);
        dateObj[c]=parseInt(dateArr[i]);
    }
    return new Date(dateObj.Y,dateObj.M-1,dateObj.D);
}
//��ȡ���ڼӼ������������
function GetDateAddDays(DateStr,Days)
{
    var date = GetDateObj(DateStr);
    date.setDate(date.getDate()+parseInt(Days));
    return $.fn.datebox.defaults.formatter(date);
}
//��ȡ���ڵ����ڼ� ��1-7��
function GetDateWeek(DateStr)
{
    var date = GetDateObj(DateStr);
    var Week=date.getDay();
    if(Week==0) Week=7;
    return Week;
}
//��ȡ��ǰ����
function GetCurrentDate()
{
    return $.fn.datebox.defaults.formatter(new Date());
}
//��ȡ��ǰʱ��
function GetCurrentTime()
{
    var date = new Date();
    var h=date.getHours();
    if(h<10) h='0'+h;
    var m=date.getMinutes();
    if(m<10) m='0'+m;
    var s=date.getSeconds();
    if(s<10) s='0'+s;
    return h+':'+m+':'+s;
}
///�Ƚ��������ڴ�С 1���� 0��� -1С��
function CompareDate(s1,s2){
    var d1=GetDateObj(s1);
    var d2=GetDateObj(s2);
    if(d1>d2) return 1;
    if(d1<d2) return -1;
    return 0;
}
///��ȡ���������������
function GetDateDiffDay(dateStr1,dateStr2){
    var date1 = GetDateObj(dateStr1);
    var date2 = GetDateObj(dateStr2);
    return (date1.getTime()-date2.getTime())/(24 * 60 * 60 * 1000); 
}
///��ȡcss�����Ƿ�֧��ĳ��ֵ
function SuportCSSProperty(property,value)
{
    var element = document.createElement('div');
    if(property in element.style){
        if(typeof value=='undefined') return true;
        element.style[property] = value;
       return element.style[property] === value;
    }
    return false;
}
///��ȡ�ͻ���IP
function GetClientIPAddress()
{
    try{
        var locator=new ActiveXObject("WbemScripting.SWbemLocator");
        var service=locator.ConnectServer(".");
        var properties = service.ExecQuery("Select * from Win32_NetworkAdapterConfiguration Where IPEnabled =True");
        var e = new Enumerator(properties);
        var p = e.item();
        var IPAddress=p.IPAddress(0);
        return IPAddress;
    }catch(e){
        return ''
    }
}
///ͨ����������ȡ�ͻ���IP
function GetCacheIPAddress(){
	
	var IPAddressStr=$.cm({ 
		ClassName:"User.DHCClientLogin",
		MethodName:"GetInfo", 
		dataType:"text"
	},false);
	var IPAddress=IPAddressStr.split("^")[0]
	return IPAddress;
}
//��ȡ�ַ������
function GetTextWidth(content){
	var $span=$("<span>"+content+"</span>").hide().appendTo('body');
	var width=$span.width()
	$span.remove();
	return width;
}
//�ر����е���(ͨ�������л����ߣ��ֲ�ˢ��ʱ)
function ClearWindow(){
    $(".messager-button a").click();
	$('.hisui-dialog:visible').dialog('destroy');
}
///��д��ǰҳ��url,��ֹˢ��
function RewriteUrl(ParamObj){
    if (typeof(history.pushState) === 'function') {
        var NewUrl=rewriteUrl(window.location.href, ParamObj);
        history.pushState("", "", NewUrl);
        return NewUrl;
    }
    return null;
}
//�ֲ�ˢ��������ҳ�� paramObj��������forceRefresh�Ƿ�ǿ��ˢ�±�־(��srcû�оֲ�ˢ�µķ���ʱ,�Ƿ�����ҳ��)
function xhrRefreshFrames(paramObj,forceRefresh)
{
    if(!paramObj.EpisodeID&&paramObj.adm) paramObj.EpisodeID=paramObj.adm;
    if(!paramObj.PatientID&&paramObj.papmi) paramObj.PatientID=paramObj.papmi;
    $('iframe').each(function(){
        var src=$(this).attr('src');
        if(!src){
            if(ServerObj&&ServerObj.FrameSrc) src=ServerObj.FrameSrc[$(this).attr('name')];
            if(src) $(this).attr('src',rewriteUrl(src,paramObj));
        }else{
            var xhrRefresh=this.contentWindow.xhrRefresh;
            if(xhrRefresh){
                xhrRefresh(paramObj);
            }else if(forceRefresh){
                $(this).attr('src',rewriteUrl(src,paramObj));
            }
        }
    });
}
//��ȡurl���� ת����
function urlToObj(url)
{
	var paramObj=new Object();
	var urlPara=url.split("?")[1];
	if(urlPara){
        urlPara=decodeURIComponent(urlPara)
		var urlParaArray=urlPara.split("&");
		for(var i=0;i<urlParaArray.length;i++){
		    var oneUrlPara=urlParaArray[i];
		    var ParaName=oneUrlPara.split("=")[0];
		    var ParaValue=oneUrlPara.split("=")[1];
		    paramObj[ParaName] =ParaValue;
		}
	}
	return paramObj;
}