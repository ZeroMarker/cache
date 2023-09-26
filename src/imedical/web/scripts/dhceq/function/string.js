//string类型相关js
//=========================================库函数=============================
//从url中获取指定参数值
//var rowid=GetQueryString("rowid")
function GetQueryString(name)
{
     var reg = new RegExp("(^|&)"+ name +"=([^&]*)(&|$)");
     var r = window.location.search.substr(1).match(reg);
     if(r!=null)return  unescape(r[2]); return "";
}

