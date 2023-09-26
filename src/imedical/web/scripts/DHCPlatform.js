/**
*
*@author: wanghc
*@para:    隐藏元素名,各个参数值
*@return:  类中的返回值
Usage:  
var obj = document.getElementById("itemName") ;        |
if(obj){            							       |
	var encmeth = obj.value ;					       |
}else{                                             	   |<=> var rtn = executeServerRequest("itemName",args1,args2,...) ;
	var encmeth = "" ;							       |
}												       |
var rtn = cspRunServerMethod(encmeth,args1,args2,...) ;| 
*/
function executeServerRequest(itemName){
	var obj = document.getElementById(itemName) ; 
	if (obj) {
		var encmeth = obj.value ;
	}else{
		alert("没有发现元素:\n\n\t" + itemName) ;
		return ;
	}
	arguments[0] = encmeth ;
	var rtn = cspRunServerMethod.apply(this,arguments) ;
	return rtn ;
}
String.prototype.trim = function(){
	return this.replace(/(^\s+)|(\s+$)/g,"");
}
function parseJSON(data) {
	var pre="";	
	return window.JSON && window.JSON.parse ? window.JSON.parse( pre + data ) : ( new Function("return " + (pre+data)) )();
	//return eval('(' + data + ')');
	//RFC 4627 中给出的检查 JSON 字符串的方法
	//var my_JSON_object = !(/[^,:{}\[\]0-9.\-+Eaeflnr-u \n\r\t]/.test(data.replace(/"(\\.|[^"\\])*"/g, ''))) && eval('(' + data + ')');
	return json;
}
function getValue(obj){
	if (!obj) return "" ;
	var v = "";
	if(!obj.tagName) return "";
	switch (obj.tagName){
		case "INPUT":
			v = obj.value;
			if(obj.type=="checkbox"){
				v = obj.checked;			
			}else if(obj.type=="select-one"){
				v = obj.options[obj.selectedIndex].text
			}
			break;
		case "LABEL":			
			v = obj.innerText || obj.textContent;	//table-td  IE-innerText ff-textContent
			break;
		case "SELECT":
			v = obj.options[obj.selectedIndex].value;
			break;
		default:
			v = obj.value || obj.textContent;
			break;
	}
	if ("undefined" == typeof v) v="";
	return v;
}