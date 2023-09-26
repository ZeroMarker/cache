//DHCOutPh.Common.js
//

///document.onkeydown = DHCOutPhWeb_EStopSpaceKey;
///借用收费公共js



function DHCOutPhWeb_Get18IdFromCardNo(pId){
	pId=pId.toLowerCase();
    var arrVerifyCode = [1,0,"x",9,8,7,6,5,4,3,2];  
    var Wi = [7,9,10,5,8,4,2,1,6,3,7,9,10,5,8,4,2];  
    var Checker = [1,9,8,7,6,5,4,3,2,1,1];  
    if(pId.length != 15 && pId.length != 18){
		alert("身份证号共有 15 码或18位"); 
		return "";
    }
    var Ai=pId.length==18?pId.substring(0,17):pId.slice(0,6)+"19"+pId.slice(6,15);  
    
    if (!/^\d+$/.test(Ai))
    {
    	alert("身份证除最后一位外必须为数字");
    	return "";
    }
    var yyyy=Ai.slice(6,10),  mm=Ai.slice(10,12)-1,  dd=Ai.slice(12,14);
    var d=new Date(yyyy,mm,dd) ,  now=new Date();  
    var year=d.getFullYear() ,  mon=d.getMonth() , day=d.getDate();
    if (year!=yyyy||mon!=mm||day!=dd||d>now||year<1901){
	    alert( "身份证输入错误");
	    return "";
    }
    
    
	for(var i=0,ret=0;i<17;i++)  ret+=Ai.charAt(i)*Wi[i];      
	Ai+=arrVerifyCode[ret%=11];
	
	return Ai;
}

function DHCOutPhWeb_IsIdCardNo(pId){
	pId=pId.toLowerCase();
    var arrVerifyCode = [1,0,"x",9,8,7,6,5,4,3,2];  
    var Wi = [7,9,10,5,8,4,2,1,6,3,7,9,10,5,8,4,2];  
    var Checker = [1,9,8,7,6,5,4,3,2,1,1];  
    if(pId.length != 15 && pId.length != 18){
		alert("身份证号共有 15 码或18位"); 
		return false;
    }
    var Ai=pId.length==18?pId.substring(0,17):pId.slice(0,6)+"19"+pId.slice(6,15);  
    
    if (!/^\d+$/.test(Ai))
    {
    	alert("身份证除最后一位外必须为数字");
    	return false;
    }
    var yyyy=Ai.slice(6,10),  mm=Ai.slice(10,12)-1,  dd=Ai.slice(12,14);
    var d=new Date(yyyy,mm,dd) ,  now=new Date();  
    var year=d.getFullYear() ,  mon=d.getMonth() , day=d.getDate();
    if (year!=yyyy||mon!=mm||day!=dd||d>now||year<1901){
	    alert( "身份证输入错误");
	    return false;
    }
	for(var i=0,ret=0;i<17;i++)  ret+=Ai.charAt(i)*Wi[i];      
	Ai+=arrVerifyCode[ret%=11];
	return true;
}

function DHCOutPhWeb_ValidateEmail(v)
{
	var str = /\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*/i;
	return str.test(v);
}

/////Get Age from BirthDay
function DHCOutPhWeb_GetAgeFromBirthDay(BirthName)
{
	var myAge="";
	var myobj=document.getElementById(BirthName);
	if (myobj)
	{
		var bage=myobj.value;
		bage=bage.substring(0,4);
		var now = new Date();
        var yy = now.getFullYear();
		var myAge=yy-bage;
	}
	return myAge;
}

function DHCOutPhWeb_GetAgeFromBirthDayA(BirthDay)
{
	var myAge="";
	if (BirthDay==""){
		return "";
	}
	var bage=BirthDay;
	bage=bage.substring(0,4);
	var now = new Date();
    var yy = now.getFullYear();
	var myAge=yy-bage;
	return myAge;
}


///Get BirthDay from Age
function DHCOutPhWeb_GetBirthDayFromAge(AgeName)
{
	var myBirthDay=""
	var myobj=document.getElementById(AgeName);
	if (myobj)
	{
		var myage=myobj.value;
		if (isNaN(myage)){myage=0;}
		
		if (myage==""){
			return myBirthDay;
		}
		var mynow = new Date();
        var yy = mynow.getFullYear();
		var myYear=yy-myage;
		var myMonth = mynow.getMonth()+1;
		if (myMonth.toString().length==1){
			myMonth="0"+myMonth;
		}
		var myDate = mynow.getDate();
		if (myDate.toString().length==1){
			myDate="0"+myDate;
		}
		myBirthDay=myYear + "-"+ myMonth + "-" + myDate;
	}
	return myBirthDay;
}

function DHCOutPhWeb_EStopSpaceKey()
{
	if(event.keyCode == 8)
    {
        if(event.srcElement.tagName.toLowerCase() != "input"
           && event.srcElement.tagName.toLowerCase() != "textarea")
            event.returnValue = false;
	}
}

function DHCOutPhWeb_SetLimitNumABC(e)
{
	var key=e.keyCode;
	
	////if ((((key>47)&&(key<58))||(key==46)||(key==8)))
	
	if ((((key>47)&&(key<58))||(key==46)||(key==8)||((key>95)&&(key<106))||(key==37)||(key==38)||(key==39)||(key==40)))
	{}
	else
	{
		///event.returnValue=false;
		e.keyCode=0;
	}
}

function SetLimitNum(e)
{
	var key=e.keyCode;
	if (((key>47)&&(key<58))||(key==46)||(key==8)) 
	{}
	else
	{
		///event.returnValue=false;
		e.keyCode=0;
	}
}

function DHCOutPhWeb_SetLimitNum(){
	var mykey=event.keyCode;
	////||(mykey==44)
	if (mykey==13){
		return;
	}
	if ((mykey>57)||(mykey<48)){
		event.keyCode=0;
		return;
	}
}

function DHCOutPhWeb_SetLimitFloat(){
	var mykey=event.keyCode;
	////||(mykey==44)
	if (mykey==13){
		return;
	}
	if ((mykey>57)||(mykey<46)||(mykey==47)){
		event.keyCode=0;
		return;
	}
}


function DHCOutPhWeb_nextfocus(ename) {
	//alert(ename);
	for (var j=0;j<document.all.length;j++) {
		//alert(document.all[j].name);
		if ((websys_canfocus(document.all(j)))&&(document.all[j].name==ename) ) {
			websys_nextfocus(j);
			break;
		}
	}
}


function DHCOutPhWeb_Calobj(obj1,obj2,resobj,caloption)
{
	if ((obj1)&&(obj2))   //+-*%
	{
		var mynum1=parseFloat(obj1.value);
		if (isNaN(mynum1)) {var mynum1=0;}
		var mynum2=parseFloat(obj2.value);
		if (isNaN(mynum2)) {mynum2=0;}
		switch (caloption)
		{
			case "-":
				var myres=mynum1-mynum2;
				break;
			case "+":
				var myres=mynum1+mynum2;
				break;
			case "*":
				var myres=mynum1*mynum2;
				break;
			case "%":
				
				break;
			default:
				var myres=mynum1*mynum2;
				break;
		}
		myres=parseFloat(myres)+0.0000001;
		resobj.value =myres.toFixed(2).toString();
		return myres.toFixed(2);
	}
}

function DHCOutPhWeb_CalobjA(Num1,Num2,caloption)
{
	var mynum1=parseFloat(Num1);
	if (isNaN(mynum1)) {var mynum1=0;}
	var mynum2=parseFloat(Num2);
	if (isNaN(mynum2)) {mynum2=0;}
	switch (caloption)
	{
		case "-":
			var myres=mynum1-mynum2;
			break;
		case "+":
			var myres=mynum1+mynum2;
			break;
		case "*":
			var myres=mynum1*mynum2;
			break;
		case "%":
			
			break;
		default:
			var myres=mynum1*mynum2;
			break;
	}
	myres=parseFloat(myres)+0.00001;
	////resobj.value =myres.toFixed(2).toString();
	return myres.toFixed(2);
}

Number.prototype.toFixed=function(len) 
{
	///4  Re  5  to 10
	if(isNaN(len)||len==null) 
	{
		len = 0;
	}else {
		if(len<0){
			len = 0;
		}
	}
    return Math.round(this * Math.pow(10,len))/Math.pow(10,len); 
} 

Number.prototype.toRound=function(len,RNum)
{
	///5  Re  6  to 10
	if(isNaN(len)||len==null) 
	{
		len = 0;
	}else {
		if(len<0){
			len = 0;
		}
	}
	
    return Math.round(((this * Math.pow(10,len+1))-(RNum-5)+0.5)/Math.pow(10,1))/Math.pow(10,len);
}


String.prototype.Trim=function(){   
  return this.replace(/(^\s*)|(\s*$)/g,"");   
}

Array.prototype.indexOf = function(v)
{
	for(var i = this.length; i-- && this[i] !== v;);
	return i; 
}
	 

//Number.prototype.toFixed=function(len)
function DD()
{
    var add = 0;
    var s,temp;
    var s1 = this + "";
    var start = s1.indexOf(".");
    if(s1.substr(start+len+1,1)>=5)add=1;
    var temp = Math.pow(10,len);
    s = Math.floor(this * temp) + add;
    return s/temp;
}


function DHCOutPhWeb_SetListStyle(SObj,TObj)	{
		Stop=parseInt(SObj.style.top,10);
		if (isNaN(Stop)) {var Stop=0};
		Sleft=parseInt(SObj.style.left,10);
		if (isNaN(Sleft)) {var Sleft=0};
		Swidth=parseInt(SObj.style.width,10);
		if (isNaN(Swidth)) {var Swidth=0};
		Sheight=parseInt(SObj.style.height,10);
		if (isNaN(Sheight)) {var Sheight=0};
		//
		//if (TObj) alert(TObj.style.top);
		Ttop=parseInt(TObj.style.top,10);
		if (isNaN(Ttop)) {var Ttop=0};
		Tleft=parseInt(TObj.style.left,10);
		if (isNaN(Tleft)) {var Tleft=0};
		Twidth=parseInt(TObj.style.width,10);
		if (isNaN(Twidth)) {var Twidth=0};
		Theight=parseInt(TObj.style.height,10);
		if (isNaN(Theight)) {var Theight=0};
		//
		Ttop=Stop;
		Tleft=Sleft;
		Twidth=Swidth+330;
		Theight=100;
		//
		Ttop=Ttop.toString(10)+"px";
		Tleft=Tleft.toString(10)+"px";
		Twidth=Twidth.toString(10)+"px";
		Theight=Theight.toString(10)+"px";
		//
		TObj.style.top=Ttop;
		TObj.style.left=Tleft;
		TObj.style.width=Twidth;
		TObj.style.height=Theight;
}
function DHCOutPhWeb_ResetStyle(Obj)	{
		Obj.style.width="0px";
		Obj.style.height="0px";
}

function DHCOutPhWeb_ChkRead(objName)
{
	var obj=document.getElementById(objName);
	if (obj) {
		try {
			//obj.focus();
			if (obj.readOnly){return true;}
			else{return false;}
		} catch(e) {}
	}
}

function DHCOutPhWeb_GetRowIdx(wobj)
{
	try{
		var eSrc=wobj.event.srcElement;
		if (eSrc.tagName=="IMG") eSrc=wobj.event.srcElement.parentElement;
		var rowObj=getRow(eSrc);
		var selectrow=rowObj.rowIndex;
		return 	selectrow
	}catch(e)
	{
		alert(e.toString());
		return -1;
	}
}

function DHCOutPhWeb_GetRowCount(wobj)
{
	try{
		var tabOPList=wobj.document.getElementById('tDHCOPOEList');
		var rows=tabOPList.rows.length-1;
		return 	rows
	}catch(e)
	{
		alert(e.toString());
		return -1;
	}
}

function DHCOutPhWeb_GetTBRows(TbName)
{
	try{
		var myrows=0;
		var tabObj=document.getElementById(TbName);
		if (tabObj){
			var myrows=tabObj.rows.length-1;
		}
		return myrows;
	}catch(e){
		alert(e.toString);
		return 0;
	}
}

function DHCOutPhWeb_WPPrint(){
	
	var teststr="\\\\192.168.2.188\\TrakCareP5\\web\\config.xml"
	var mystr="";
	

	var myobj=document.getElementById("ClsBillPrint");
	//alert(teststr+":::::"+mystr);
	var rtn=myobj.ToPrint(teststr,mystr);
	//alert(rtn);
	return rtn;
}

function DHCOutPhWeb_LoadCLSID()
{
	var mywin=parent.window.open("","","width=0,height=0");
	var mydoc=mywin.document;
	mydoc.write("<object ID='ClsBillPrint' WIDTH=0 HEIGHT=0 CLASSID='CLSID:F30DC1D4-5E29-4B89-902F-2E3DC81AE46D' CODEBASE='../addins/client/DHCOPPrint.CAB#version=1,0,0,0' VIEWASTEXT>");
	mydoc.write("</object>");

	var teststr="E:\config.xml"
	var mystr="PatName" +String.fromCharCode(2) + "Check^";
	mystr+="FeeSum" +String.fromCharCode(2) + "100^";
	mystr+="FeeCapSum" +String.fromCharCode(2) + "1000^";
	
	var myobj=mydoc.getElementById("ClsBillPrint");
	var rtn=myobj.ToPrint(teststr,mystr);
	mywin.opener=null;
	mywin.close();
	
}

function convertCurrency(currencyDigits) {
 	var MAXIMUM_NUMBER = 99999999999.99;
 	// Predefine the radix characters and currency symbols for output:
 
// Variables:
 var integral; // Represent integral part of digit number.
 var decimal; // Represent decimal part of digit number.
 var outputCharacters; // The output result.
 var parts;
 var digits, radices, bigRadices, decimals;
 var zeroCount;
 var i, p, d;
 var quotient, modulus;
 
// Validate input string:
 currencyDigits = currencyDigits.toString();
 if (currencyDigits == "") {
  alert("Empty input!");
  return "";
 }
 if (currencyDigits.match(/[^,.\d]/) != null) {
  alert("Invalid characters in the input string!");
  return "";
 }
 if ((currencyDigits).match(/^((\d{1,3}(,\d{3})*(.((\d{3},)*\d{1,3}))?)|(\d+(.\d+)?))$/) == null) {
  alert("Illegal format of digit number!");
  return "";
 }
 
// Normalize the format of input digits:
 currencyDigits = currencyDigits.replace(/,/g, ""); // Remove comma delimiters.
 currencyDigits = currencyDigits.replace(/^0+/, ""); // Trim zeros at the beginning.
 // Assert the number is not greater than the maximum number.
 if (Number(currencyDigits) > MAXIMUM_NUMBER) {
  alert("Too large a number to convert!");
  return "";
 }
 
// Process the coversion from currency digits to characters:
 // Separate integral and decimal parts before processing coversion:
 parts = currencyDigits.split(".");
 if (parts.length > 1) {
  integral = parts[0];
  decimal = parts[1];
  // Cut down redundant decimal digits that are after the second.
  decimal = decimal.substr(0, 2);
 }
 else {
  integral = parts[0];
  decimal = "";
 }
 // Prepare the characters corresponding to the digits:
 digits = new Array(CN_ZERO, CN_ONE, CN_TWO, CN_THREE, CN_FOUR, CN_FIVE, CN_SIX, CN_SEVEN, CN_EIGHT, CN_NINE);
 radices = new Array("", CN_TEN, CN_HUNDRED, CN_THOUSAND);
 bigRadices = new Array("", CN_TEN_THOUSAND, CN_HUNDRED_MILLION);
 decimals = new Array(CN_TEN_CENT, CN_CENT);
 // Start processing:
 outputCharacters = "";
 // Process integral part if it is larger than 0:
 if (Number(integral) > 0) {
  zeroCount = 0;
  for (i = 0; i < integral.length; i++) {
   p = integral.length - i - 1;
   d = integral.substr(i, 1);
   quotient = p / 4;
   modulus = p % 4;
   if (d == "0") {
    zeroCount++;
   }
   else {
    if (zeroCount > 0)
    {
     outputCharacters += digits[0];
    }
    zeroCount = 0;
    outputCharacters += digits[Number(d)] + radices[modulus];
   }
   if (modulus == 0 && zeroCount < 4) {
    outputCharacters += bigRadices[quotient];
   }
  }
  outputCharacters += CN_DOLLAR;
 }
 // Process decimal part if there is:
 if (decimal != "") {
  for (i = 0; i < decimal.length; i++) {
   d = decimal.substr(i, 1);
   if (d != "0") {
    outputCharacters += digits[Number(d)] + decimals[i];
   }
  }
 }
 // Confirm and return the final output string:
 if (outputCharacters == "") {
  outputCharacters = CN_ZERO + CN_DOLLAR;
 }
 if (decimal == "") {
  outputCharacters += CN_INTEGER;
 }
 outputCharacters = CN_SYMBOL + outputCharacters;
 return outputCharacters;
}

function DHCOutPhWeb_replaceAll(src,fnd,rep) 
{ 
	//rep:replace
	//src:source
	//fnd:find
	if (src.length==0) 
	{ 
		return ""; 
	} 
	try{
		var myary=src.split(fnd);
		var dst=myary.join(rep);
	}catch(e){
		alert(e.message);
		return ""
	}
	return dst; 
} 

function DHCOutPhWeb_TextEncoder(transtr){
	if (transtr.length==0){
		return "";
	}
	var dst=transtr;
	try{
		dst = DHCOutPhWeb_replaceAll(dst, '\\"', '\"');
		dst = DHCOutPhWeb_replaceAll(dst, "\\r\\n", "\r\t");
		dst = DHCOutPhWeb_replaceAll(dst, "\\r", "\r");
		dst = DHCOutPhWeb_replaceAll(dst, "\\n", "\n");
		dst = DHCOutPhWeb_replaceAll(dst, "\\t", "\t");
	}catch(e){
		alert(e.message);
		return "";
	}
	return dst;
}

function DHCOutPhWeb_setfocus(objName) {
	window.setTimeout('DHCOutPhWeb_setfocus2(\''+objName+'\')',500);
}

function DHCOutPhWeb_setfocus2(objName) {
	///alert(objName);
	var obj=document.getElementById(objName);
	if (obj) {
		try {
			obj.focus();
			obj.select();
		} catch(e) {}
	}
}

function DHCOutPhWeb_OtherDocsetfocus(frameName,objName) {
	window.setTimeout('DHCOutPhWeb_OtherDocsetfocus2(\''+ frameName +'\', \''+objName+'\')',2000);
}

function DHCOutPhWeb_OtherDocsetfocus2(frameName, objName) {
	var obj = parent.frames[frameName].document.getElementById(objName);
	if (obj) {
		try {
			obj.focus();
			obj.select();
		} catch(e) {}
	}
}


////Disable the Button;
function DHCOutPhWeb_DisBtn(obj){
	obj.disabled=true;
	obj.onclick=function(){return false;}
}

////Disable the Button;
function DHCOutPhWeb_DisBtnA(objName){
	var obj=document.getElementById(objName);
	if (obj){
		obj.disabled=true;
		obj.onclick=function(){return false;}
	}
}


function DHCOutPhWeb_AddToList(ListName,txtdesc,valdesc,ListIdx)	{
	var ListObj=document.getElementById(ListName);
	if (!ListObj){
		return;
	}
	var aryitmdes=txtdesc		//.split("^");
	var aryitminfo=valdesc		//.split("^");
	if (aryitmdes.length>0)	{
		ListObj.options[ListIdx] = new Option(aryitmdes,aryitminfo);	//,aryval[i]	
	}
}

function DHCOutPhWeb_AddToListA(ListName,txtdesc,valdesc,ListIdx,SelFlag)	{
	var ListObj=document.getElementById(ListName);
	if (!ListObj){
		return;
	}
	var aryitmdes=txtdesc		//.split("^");
	var aryitminfo=valdesc		//.split("^");
	if (aryitmdes.length>0)	{
		ListObj.options[ListIdx] = new Option(aryitmdes,aryitminfo);	//,aryval[i]	
		if (isNaN(SelFlag)){ SelFlag=0;}
		if (SelFlag==1){
			ListObj.options[ListIdx].selected=true;
			
			///ListObj.selectedIndex=ListIdx;
		}
	}
}

function DHCOutPhWeb_GetListBoxValue(ObjName)
{
	///get ListBox Control Current Value;
	
	var myValue="";
	var obj=document.getElementById(ObjName);
	if (obj){
		var myIdx=obj.options.selectedIndex;
		if(myIdx<0){
			return myValue;
		}
		myValue=obj.options[myIdx].value;
	}
	return myValue;
	
}

function DHCOutPhWeb_SetListDefaultValue(ObjName,DefValue,SplitVal,DefIdx)
{
	///Set Default Value by Default Value;
	///DefIdx:  Default Value Position
	///
	if (SplitVal==""){
		return;
	}
	
	var myValue="";
	var obj=document.getElementById(ObjName);
	if (obj){
		var mylen=obj.options.length;
		for (var myIdx=0;myIdx<mylen;myIdx++){
			myValue=obj.options[myIdx].value;
			var myary=myValue.split(SplitVal);
			if (myary[DefIdx]==DefValue){
				obj.options.selectedIndex=myIdx;
				break;
			}
		}
	}
}

function DHCOutPhWeb_TransListData(SName,TName)
{
	var sobj=document.getElementById(SName);
	var tobj=document.getElementById(TName);
	if((sobj)&&(tobj)){
		var myIdx=sobj.options.selectedIndex;
		if (myIdx>=0){
			var myoptobj=sobj.options[myIdx];
			var myListIdx=tobj.length;
			tobj.options[myListIdx]=new Option(myoptobj.text, myoptobj.value);
			sobj.options[myIdx]= null;
			if ((myIdx+1)<sobj.options.length){
				sobj.options[myIdx].selected=true;
			}else{
				sobj.options[myIdx-1].selected=true;
			}
		}
	}
}



function nextfocus() {
	var eSrc=window.event.srcElement;
	//alert(eSrc.tabIndex);
	var key=websys_getKey(e);
	if (key==13) {
		websys_nexttab(eSrc.tabIndex);
	}
}

function DHCOutPhWeb_Nextfocus(){
	var eSrc=window.event.srcElement;
	//alert(eSrc.tabIndex);
	var key=websys_getKey(e);
	if (key==13) {
		websys_nexttab(eSrc.tabIndex);
	}
}

function DHCOutPhWeb_NextfocusA(){
	var eSrc=window.event.srcElement;
	//alert(eSrc.tabIndex);
	var key=websys_getKey(e);
	if (key==13) {
		websys_nexttab(eSrc.tabIndex);
	}
}


function DHCOutPhWeb_IsDate(DateString,Dilimeter) 
{
	if (DateString==null) return false; 
	if (Dilimeter=='' || Dilimeter==null) 
	Dilimeter ='-'; 
	var tempy=''; 
	var tempm=''; 
	var tempd=''; 
	var tempArray; 
	if (DateString.length<8 && DateString.length>10) 
		return false;  
	tempArray = DateString.split(Dilimeter); 
	if (tempArray.length!=3) 
		return false; 
	if (tempArray[0].length==4) 
	{ 
		tempy = tempArray[0]; 
		tempd = tempArray[2]; 
	} else 
	{ 
		tempy = tempArray[2]; 
		tempd = tempArray[1]; 
	} 
	
	tempm = tempArray[1]; 
	var tDateString = tempy + '/'+tempm + '/'+tempd+' 8:0:0';//加八小时是因为我们处于东八区 
	//alert(tempy+"^"+tempd)
	//alert(tDateString)
	var tempDate = new Date(tDateString); 
	//if (isNaN(tempDate)) 
	//return false; 
	tempm=eval(tempm)-1
	tempd=eval(tempd)
	//alert(tempDate.getUTCFullYear().toString()+"^"+tempy+"  "+tempDate.getMonth()+"^"+tempm+"  "+tempDate.getDate()+"^"+tempd)
	if (((tempDate.getUTCFullYear()).toString()==tempy) && (tempDate.getMonth()==tempm) && (tempDate.getDate()==parseInt(tempd))) 
	{ 
		return true; 
	} 
	else 
	{ 
		return false; 
	} 
}

function DHCOutPhWebD_AutoSetDocValue(InfoStr,Spt1,Spt2){
	if (InfoStr==""){
		return;
	}
	
	var myAry=InfoStr.split(Spt1);
	var myCount=myAry.length;
	for(var i=0;i<myCount;i++){
		var myinfoary=myAry[i].split(Spt2);
		
		DHCOutPhWebD_SetObjValueC(myinfoary[0],myinfoary[1]);
	}
	
}

////Look Up Item Trans Keypress event
function DHCOutPhWeb_LookUpItemTransKeyPress()
{
	var type=websys_getType(e);
	var key=websys_getKey(e);
	///alert(type+ "  "+key);
	///evtName
	if ((type=='keypress')&&(key==13)){
		var eSrc=window.event.srcElement;
		var myobj=document.getElementById(eSrc.name);
		if ((myobj)&&(myobj.onkeydown)) {
			var myNewEvent=document.createEventObject();
			myNewEvent.keyCode = 117;
			myobj.fireEvent("onkeydown",myNewEvent);
			event.cancleBubble=true;
		}
	}
}


////Auto Exec
DHCOutPhWebD_SetStatusTip();

function DHCOutPhWebD_SetStatusTip(){
	//window.defaultStatus=session['LOGON.USERCODE']+"     "+session['LOGON.USERNAME'] + "    "+session['LOGON.GROUPDESC'];
	////top.document.title+ "    "+
	//var myStatusTip="^"+session['LOGON.USERCODE']+"     "+session['LOGON.USERNAME'] + "    "+session['LOGON.GROUPDESC'];
	//var myary=top.document.title.split("^");
	//top.document.title=myary[0]+ "    "+myStatusTip
	//window.status=session['LOGON.USERCODE']+"     "+session['LOGON.USERNAME'] + "    "+session['LOGON.GROUPDESC'];
}

function DHCOutPhWeb_GetSessionPara()
{
	var mystr="";
	///session['LOGON.SITECODE']='DHCHealth';
	/////session['LOGON.USERID']='2';
	////session['LOGON.USERCODE']='cashier';
	////session['LOGON.USERNAME']='cashier';
	////session['LOGON.GROUPID']='5';
	////session['LOGON.GROUPDESC']='Outpatient Cashier';
	////session['LOGON.LANGID']='101';
	////session['LOGON.CTLOCID']='207';
	////session['XMONTHSSHORT']='Jan,Feb,Mar,Apr,May,Jun,Jul,Aug,Sep,Oct,Nov,Dec';
	////session['CONTEXT']='';
	
	mystr+="^";			///IP
	mystr+=session['LOGON.USERID']+"^";
	mystr+=session['LOGON.CTLOCID']+"^";
	mystr+=session['LOGON.GROUPID']+"^";
	mystr+="^";
	mystr+=session['LOGON.SITECODE']+"^";
	
	return mystr;
}
function DHCOutPhWeb_DocumentOnKeydownFY(e) { //ALT-* PGUP PGDN
	DHCOutPhWeb_EStopSpaceKey();
	var keycode;
	var myOPPatinfo=parent.frames["DHCOutPatienDispFY"];
	try {keycode=websys_getKey(e);} catch(e) {keycode=websys_getKey();}
	 if (keycode==35)
  {
	  
  	  var cardcode=myOPPatinfo.document.getElementById("CardNo").value;
  	  var pmino=myOPPatinfo.document.getElementById("CPmiNo").value;
  	  if (pmino!="") return;
  	  if (cardcode!="") return;
  		var BAdmQueryobj=myOPPatinfo.document.getElementById("CReadCard");
  	 
    //if (BAdmQueryobj)
    	 ReadHFMagCardDF_Click();
  	
  }
  
  if (keycode==113){                     //F2
	 	var BAdmQueryobj=myOPPatinfo.document.getElementById("BRefuseDisp");
    if (BAdmQueryobj)	 myOPPatinfo.BRefuseDisp_click();

	}
	if (keycode==115){                     //F4
	 	var BAdmQueryobj=myOPPatinfo.document.getElementById("BReset");
    if (BAdmQueryobj)	 myOPPatinfo.Reset_click();

	}
	
	
	if (keycode==45){                     //Insert
	 	var BAdmQueryobj=myOPPatinfo.document.getElementById("BPrintBQ");
    if (BAdmQueryobj)	 myOPPatinfo.PrintBQ_Click();

	}
	
	if (keycode==123){                    //F12
       
	var BAdmQueryobj=myOPPatinfo.document.getElementById("BDisp");
if (BAdmQueryobj)	 myOPPatinfo.BDisp_click();
	}
	if (keycode==119){                    //F8
		
		 	var BAdmQueryobj=myOPPatinfo.document.getElementById("BRetrieve");
    if (BAdmQueryobj)	 myOPPatinfo.Find_click();

	}

if (keycode==40){
	
	myOPPatinfo.KeyArrDown()
  }

if (keycode==38){
	
	myOPPatinfo.KeyArrUp()
  }

}
function DHCOutPhWeb_DocumentOnKeydownDFPY(e) { //ALT-* PGUP PGDN
	DHCOutPhWeb_EStopSpaceKey();
	var keycode;
	var myOPPatinfo=parent.frames["DHCOutPatienDFDispPY"];
	try {keycode=websys_getKey(e);} catch(e) {keycode=websys_getKey();}
	
	if (keycode==115){                     //F4
	 	var BAdmQueryobj=myOPPatinfo.document.getElementById("BReset");
    if (BAdmQueryobj)	 myOPPatinfo.Reset_click();

	}
	if (keycode==123){                    //F12
       
	var BAdmQueryobj=myOPPatinfo.document.getElementById("BDisp");
if (BAdmQueryobj)	 myOPPatinfo.UpdatePyd_Click();
	}
	if (keycode==119){                    //F8
		
		 	var BAdmQueryobj=myOPPatinfo.document.getElementById("BRetrieve");
    if (BAdmQueryobj)	 myOPPatinfo.Find_click();

	}

if (keycode==40){

	myOPPatinfo.KeyArrDown()
  }

if (keycode==38){
	
	myOPPatinfo.KeyArrUp()
  }

}
function DHCOutPhWeb_DocumentOnKeydownDSP(e) { //ALT-* PGUP PGDN
	DHCOutPhWeb_EStopSpaceKey();
	var lkeycode;
	var myOPPatinfo=parent.frames["DHCOutPatienDisp"];
	try {lkeycode=websys_getKey(e);} catch(e) {lkeycode=websys_getKey();}
	
  if (lkeycode==35)
  {
  	var pmino=myOPPatinfo.document.getElementById("CPmiNo").value;
  	  var cardcode=myOPPatinfo.document.getElementById("CardNo").value;
  	if (pmino!="") return;
  	  if (cardcode!="") return;
  		var BAdmQueryobj=myOPPatinfo.document.getElementById("CReadCard");
    //if (BAdmQueryobj)	
     ReadHFMagCardDF_Click();
  	
  }
	if (lkeycode==45){                     //Insert
	 	var BAdmQueryobj=myOPPatinfo.document.getElementById("BPrintBQ");
    if (BAdmQueryobj)	 myOPPatinfo.PrintBQ_Click();

	}
	if (lkeycode==115){                     //F4
	 	var BAdmQueryobj=myOPPatinfo.document.getElementById("BReset");
    if (BAdmQueryobj)	 myOPPatinfo.Reset_click();

	}
	
		if (lkeycode==113){                     //F2
	 	var BAdmQueryobj=myOPPatinfo.document.getElementById("BRefuseDisp");
    if (BAdmQueryobj)	 myOPPatinfo.BRefuseDisp_click();

	}
	
	if (lkeycode==123){                    //F12
       
	var BAdmQueryobj=myOPPatinfo.document.getElementById("BDisp");
if (BAdmQueryobj)	 myOPPatinfo.BDisp_click();
	}
	if (lkeycode==119){                    //F8
		
		 	var BAdmQueryobj=myOPPatinfo.document.getElementById("BRetrieve");
    if (BAdmQueryobj)	 myOPPatinfo.Find_click();

	}
if (lkeycode==40){
	
	myOPPatinfo.KeyArrDown()
  }

if (lkeycode==38){
	
	myOPPatinfo.KeyArrUp()
  }
  
 
}
 function DHCOutPh_POPDispClose(flag)
  {
	  
	 // var myparentframe=parent.frames["DHCOutPatienChangeDisp"]
	 // alert(myparentframe)
	 if (flag=="DispFY"){
	   	var myOPPatinfo=parent.opener.parent.frames["DHCOutPatienDispFY"];
	 
	          myOPPatinfo.Find_click();
	 }
	  if (flag=="Disp"){
	   	var myOPPatinfo=parent.opener.parent.frames["DHCOutPatienDisp"];
	 
	          myOPPatinfo.Find_click();
	 }
  }