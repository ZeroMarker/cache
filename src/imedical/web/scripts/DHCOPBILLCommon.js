//add by wanghc  2010-02-24
//input:   隐藏元素名,各个参数
//output:  类中的返回值
/*sample:  
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
function $(element) {
if (arguments.length > 1) {
for (var i = 0, elements = [], length = arguments.length; i < length; i++)
elements.push($(arguments[i]));
return elements;
}
if (typeof element=="string")
return document.getElementById(element);
}


function $V(element) {
return $(element).value;
}
function gridlist(objSheet,row1,row2,c1,c2)
{
	objSheet.Range(objSheet.Cells(row1, c1), objSheet.Cells(row2,c2)).Borders(1).LineStyle=1;
	objSheet.Range(objSheet.Cells(row1, c1), objSheet.Cells(row2,c2)).Borders(2).LineStyle=1;
	objSheet.Range(objSheet.Cells(row1, c1), objSheet.Cells(row2,c2)).Borders(3).LineStyle=1;
	objSheet.Range(objSheet.Cells(row1, c1), objSheet.Cells(row2,c2)).Borders(4).LineStyle=1; 
} 