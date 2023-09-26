//DHCINSUCommon.js
//医保组公共JS
//Cread at 2010-09-03

function validateCNDate( strValue ) 
{
	var objRegExp = /^\d{4}(\-|\/|\.)\d{1,2}\1\d{1,2}$/ 
	
	if(!objRegExp.test(strValue))
	   { 
		alert("请按格式输入正确的日期");
		return false; 
	   }
	else
	   { 
		var arrayDate = strValue.split(RegExp.$1); 
		var intDay = parseInt(arrayDate[2],10); 
		var intYear = parseInt(arrayDate[0],10); 
		var intMonth = parseInt(arrayDate[1],10); 
		if(intMonth > 12 || intMonth < 1) 
			{ 
			return false;
			}
		var arrayLookup = { '1' : 31,'3' : 31, '4' : 30,'5' : 31,'6' : 30,'7' : 31, 
		'8' : 31,'9' : 30,'10' : 31,'11' : 30,'12' : 31} 
		if(arrayLookup[parseInt(arrayDate[1])] != null) 
			{ 
			if(intDay <= arrayLookup[parseInt(arrayDate[1])] && intDay != 0) 
				{return true;} 
			}
		if (intMonth-2 ==0) 
			{
			var booLeapYear = (intYear % 4 == 0 && (intYear % 100 != 0 || intYear % 400 == 0)); 
			if( ((booLeapYear && intDay <= 29) || (!booLeapYear && intDay <=28)) && intDay !=0) 
				{return true;}
			else 
				{
				alert("请按格式输入正确的日期")
				return false; 
				} 
			}
		}
		alert("请按格式输入正确的日期")
		return false; 
}

 //去掉字符串前后空格
function cTrim(inStr)
{
	var outStr
	outStr=inStr.replace(/(^\s*)|(\s*$)/g,    "");
	return outStr
}

//获取IP地址方法1
//获取所有网卡的IP地址，以;分割。
//最真实的客户端
function GetLocalIPAddress()  
{  
    var obj = null;  
    var rslt = "";  
    try  
    {  
    	//Zhan 20190314
	    if((typeof(ClientIPAddress)=="undefined")||ClientIPAddress=="undefined"){
	        obj = new ActiveXObject("rcbdyctl.Setting");  
	        rslt = obj.GetIPAddress;  
	      	rslt=rslt.split(";")[0]
	        obj = null;  
		}else{
			rslt=ClientIPAddress
		}

    }  
    catch(e)  
    {  
          alert("异常，rcbdyctl.dll动态库未注册，请先注册!")
          rslt="";
    } 
    return rslt
}


function FillTypeList(obj){
	//var OutStr=-1
var VerStr="";
	VerStr=tkMakeServerCall("web.INSUDicDataCom","GetSys","","","TariType");
	if ((VerStr=="0")||(VerStr=="")){
		alert("请在医保字典表中维护医保的目录类别")
		return false;
	}
	var i
	var VerArr1=VerStr.split("!");
	var ArrTxt= new Array(VerArr1.length-2);     //定义数组长度
	var ArrValue = new Array(VerArr1.length-2);  //定义数组长度
	for(i=1;i<VerArr1.length;i++){
		var VerCol=VerArr1[i].split("^");
		var VerArr3=VerCol[5].split("#");
		for(j=1;j<=VerArr3.length;j++)
		{
			//根据医保码列维护的安全组列表吗判断本目录哪些人可以看见
			if(GROUPID==VerArr3[j-1]||(VerCol[5]=="ALL")||(VerCol[5]==""))
			{
				ArrTxt[i-1]=VerCol[3];
				ArrValue[i-1]=VerCol[2];
			}
		}
		//ArrTxt[i-1]=VerArr2[3];
		//ArrValue[i-1]=VerArr2[2];
		}
	ClearAllList(obj);
	var Flag=AddItemToList(obj,ArrTxt,ArrValue);
	return Flag;
	}
function ClearAllList(obj) {
	if (obj.options.length>0) {
	for (var i=obj.options.length-1; i>=0; i--) obj.options[i] = null;
	}
}	
function AddItemToList(obj,arytxt,aryval) {
	if (arytxt.length>0) {
		if (arytxt[0]!="") {
			var lstlen=obj.length;
			for (var i=0;i<arytxt.length;i++) {
				obj.options[lstlen] = new Option(arytxt[i],aryval[i]); 
				
				/*
				var AvlQty=aryval[i].split("&")
				//alert(AvlQty[4])
				if ( AvlQty[4]== 1 ) {
					obj.options[lstlen].style.color="green";
				}
				if( AvlQty[4]<1 ){
					obj.options[lstlen].style.color="red";
				}
				*/
				lstlen++;
			}
			return true;
		}
	}
}