//********************Common function***************************************
//要定义重载方法，就不能像强类型语言中那样做。但是仍然可以实现重载。就是通过函数的 arguments 属性。
//javascript 中函数的参数是没有类型的，并且参数个数也是任意的,但是你仍然可以再调用它是带入任意多个参数
//当然，参数类型也是任意的。至于是否出错，那是这个函数中所执行的内容来决定的,javascript 并不根据你指定的参数个数和参数类型来判断你调用的是哪个函数。
function add() {
    var sum = 0;
    for (var i = 0; i < arguments.length; i++) {
    	alert(arguments[i])
    }
}
function DHCC_FormatDesc(Desc){ 
	if (Desc.indexOf("-") != -1){
		var DescArr=Desc.split("-");
		Desc=DescArr[1];
	}
	return Desc;
}
function DHCC_FormatFloat(value,digits){ 
	if (value.indexOf(".") == -1){value += ".";}
	for (i=0; i<digits; i++){
		if (value.length - value.indexOf(".") < digits+1){value += "0";}
	}
	return value;
}

function DHCC_SetElementData(ElementName,Val){
	var obj=document.getElementById(ElementName);
	if (obj){
		if (obj.tagName=='LABEL'){
			obj.innerText=Val
		}else{
			if (obj.type=='checkbox'){
				obj.checked=Val;
				return;
			}
			obj.value=Val;
		}
	}
}

function DHCC_GetElementData(ElementName){
	var obj=document.getElementById(ElementName);
	if (obj){
		if (obj.tagName=='LABEL'){
			return obj.innerText
		}else{
			if (obj.type=='checkbox') return obj.checked;
			return obj.value
		}
	}
	return "";
}

function DHCC_GetColumnData(ColName,Row){
	var CellObj=document.getElementById(ColName+"z"+Row);
	//alert(CellObj.id+"^"+CellObj.tagName+"^"+CellObj.value);
	if (CellObj){
		if (CellObj.tagName=='LABEL'){
			return CellObj.innerText;
		}else{
			if (CellObj.type=="checkbox"){
				return CellObj.checked;
			}else{
				return CellObj.value;
			}
		}
	}
	return "";
}

function DHCC_SetColumnData(ColName,Row,Val){
	var CellObj=document.getElementById(ColName+"z"+Row);
	//var rowobj=tk_getRow(CellObj);
	//var objtbl=tk_getTBody(rowobj)
	if (CellObj){
	  //alert(CellObj.id+"^"+CellObj.tagName);
	  if (CellObj.tagName=='LABEL'){
	  	CellObj.innerText=Val;
	  }else{
			if (CellObj.type=="checkbox"){
				if (Val==1) {CellObj.checked=true;}else{CellObj.checked=false}
			}else{
				CellObj.value=Val;
			}
		}
	}
}

function DHCC_SetListStyle(ListName,Mode){
	var obj=document.getElementById(ListName);
	if (obj){
		obj.size=1;
		obj.multiple=false;
	}
}

function DHCC_ClearAllList(obj) {
	if (obj.options.length>0) {
		for (var i=obj.options.length-1; i>=0; i--) obj.options[i] = null;
	}
}

//DHCWebD_ClearAllListA("PayMode");
function DHCC_ClearList(ListName){
	var obj=document.getElementById(ListName);
	if (obj){DHCC_ClearAllList(obj);}
}

function DHCC_AddItemToList(obj,arytxt,aryval) {
	if (arytxt.length>0) {
		if (arytxt[0]!="") {
			var lstlen=obj.length;
			for (var i=0;i<arytxt.length;i++) {
				obj.options[lstlen] = new Option(arytxt[i],aryval[i]); 
				lstlen++;
			}
		}
	}
}

function DHCC_AddItemToListByStr(ListName,str) {
	var obj=document.getElementById(ListName);
	if (obj){
		var ary=str.split("^");
		if (ary.length>0) {
			for (var i=0;i<ary.length;i++) {
				var arytxt=ary[i].split(String.fromCharCode(1));
				obj.options[obj.length] = new Option(arytxt[1],arytxt[0]); 
			}
		}
		obj.selectedIndex=-1;
	}
}

function DHCC_GetListSelectedText(ListName){
	var Val="";
	var obj=document.getElementById(ListName);
	if (obj) {
		if (obj.selectedIndex!=-1){Val=obj.options[obj.selectedIndex].text};
	}
	return Val;
}

function DHCC_GetListSelectedValue(ListName){
	var Val="";
	var obj=document.getElementById(ListName);
	if (obj) {
		if (obj.selectedIndex!=-1){Val=obj.options[obj.selectedIndex].value};
	}
	return Val;
}

//此函数需保证list在初始化数据时Option.value由至少两个值组成(Option.value=val1+"^"+val2)
function DHCC_SelectOptionByCode(ListName,Val){
	
	var obj=document.getElementById(ListName);
	if (obj){
		for (var i=0;i<obj.length;i++) {
			var scode=obj.options[i].value;
			var pmod=scode.split("^");	
			if (pmod[2]==Val) {obj.options[i].selected=true;}else{obj.options[i].selected=false;}
	 	}	
	}
}

function DHCC_SelectOptionByValue(ListName,Val){
	var obj=document.getElementById(ListName);
	var selectindex=-1;
	for (var i=0;i<obj.length;i++) {
		var scode=obj.options[i].value;
		if (scode==Val) {obj.options[i].selected=true;selectindex=i}else{obj.options[i].selected=false;}
 	}
 	return selectindex
}

function DHCC_AddToListA(ListName,txtdesc,valdesc,ListIdx,SelFlag)	{
	var ListObj=document.getElementById(ListName);
	if (!ListObj){return;}
	var aryitmdes=txtdesc		//.split("^");
	var aryitminfo=valdesc		//.split("^");
	if (aryitmdes.length>0)	{
		ListObj.options[ListIdx] = new Option(aryitmdes,aryitminfo);	//,aryval[i]	
		if (isNaN(SelFlag)){ SelFlag=0;}
		if (SelFlag==1){
			ListObj.options[ListIdx].selected=true;
		}
	}
}

function DHCC_FindTableRow(TableName,ColumnName,Val){
	var ColumnData="";
	var objtbl=document.getElementById(TableName);
	if (objtbl){
		var rows=objtbl.rows.length;
		if ((DHCC_GetColumnData(ColumnName,1)=="")&&(rows==2)) return 0;
		for (var j=1;j<rows;j++) {
			ColumnData=DHCC_GetColumnData(ColumnName,j);
			if (ColumnData.indexOf(Val)>-1){return j}
		}
		var val=DHCC_GetColumnData(ColumnName,j);
		
	}
	return 0
}

function DHCC_ClearTable(TableName){
	var objtbl=document.getElementById(TableName);
	if (objtbl){
		var rows=objtbl.rows.length;
		var lastrowindex=rows-1;
		
		for (var j=1;j<lastrowindex;j++) {objtbl.deleteRow(1);}
		var objtbody=tk_getTBody(objtbl.rows[1]);
		DHCC_ClearTableRow(objtbl.rows[1]);
		tk_ResetRowItems(objtbody);
	//alert(objtbl.innerHTML)
	}
}

function DHCC_InsertRowToTable(objtbl){
	var row=objtbl.rows.length;
	var objlastrow=objtbl.rows[row-1];
	var objnewrow=objlastrow.cloneNode(true);
	var rowitems=objnewrow.all; //IE only
	if (!rowitems) rowitems=objnewrow.getElementsByTagName("*"); //N6
	for (var j=0;j<rowitems.length;j++) {
		if (rowitems[j].id) {
			var Id=rowitems[j].id;
			var arrId=Id.split("z");
			arrId[arrId.length-1]=eval(arrId[arrId.length-1])+1;
			rowitems[j].id=arrId.join("z");
			rowitems[j].name=arrId.join("z");
			//rowitems[j].value="";
			if (rowitems[j].tagName=='LABEL'){rowitems[j].innerText=""}else{rowitems[j].value=""}
		}
	}
	objtbody=tk_getTBody(objlastrow);
	objnewrow=objtbody.appendChild(objnewrow);
	{if ((objnewrow.rowIndex)%2==0) {objnewrow.className="RowEven";} else {objnewrow.className="RowOdd";}}	
}

function DHCC_ClearTableRowByIndex(objtbl,Rowindex){
	var objrow=objtbl.rows[Rowindex];
	DHCC_ClearTableRow(objrow);
}

function DHCC_ClearTableRow(objrow){
	var rowitems=objrow.all; //IE only
	if (!rowitems) rowitems=objrow.getElementsByTagName("*"); //N6
	for (var j=0;j<rowitems.length;j++) {
		if (rowitems[j].id) {
			var Id=rowitems[j].id;
			var arrId=Id.split("z");
			rowitems[j].id=arrId.join("z");
			rowitems[j].name=arrId.join("z");
			if (rowitems[j].tagName=='LABEL'){
			  rowitems[j].innerText=""
			}else{
				rowitems[j].value="";
			}		
		}
	}	
}

function DHCC_Nextfoucs(e) {
	var eSrc=window.event.srcElement;
	var key=websys_getKey(e);
	if (key==13) {
		websys_nexttab(eSrc.tabIndex);
	}
}

function typeofObject(objClass)
 {
     if ( objClass && objClass.constructor ) {
         var strFun = objClass.constructor.toString();
         var className = strFun.substr(0, strFun.indexOf('('));
         className = className.replace('function', '');
         return className.replace(/(^\s*)|(\s*$)/ig, '');  
     }
     return typeof(objClass);
 }
 
 
 function DHCC_StrToArray(str){
	var x=new Array();
	var Arr=str.split('^');
	for(var i=0;i<Arr.length;i++){
		var Arr1=Arr[i].split(String.fromCharCode(1));
		var label=Arr1[1];
		var val=Arr1[0];
		if((typeof(val)=="undefined")||(val===null))val=label;
		x[i]=[val,label];
	}
	return x;
}

///格式:2014-02-01,2014-03-01
///Date2>Date1 return false
///Date2<=Date1 return true
function DHCC_DateCompare(Date1,Date2) {
	if (Date1=="") return true;
	if (Date2=="") return true;
	
	var dt=Date1;
	if (dt.indexOf('-')==-1) return false;
	var dtArr=dt.split('-');
	var len=dtArr.length;
	if (len>3) return false;
	for (var i=0; i<len; i++) {
		if (dtArr[i]=='') return false;
	}
	
	dt=Date2;
	if (dt.indexOf('-')==-1) return false;
	dtArr=dt.split('-');
	len=dtArr.length;
	if (len>3) return false;
	for (var i=0; i<len; i++) {
		if (dtArr[i]=='') return false;
	}
 
 	var Date1Arr=Date1.split("-");
	var Date1Year=Date1Arr[0];
	var Date1Month=parseFloat(Date1Arr[1])-1;
	var Date1Day=Date1Arr[2];
	
	var Date2Arr=Date2.split("-");
	var Date2Year=Date2Arr[0];
	var Date2Month=parseFloat(Date2Arr[1])-1;
	var Date2Day=Date2Arr[2];
	
	var objDate = new Date(Date1Year,Date1Month,Date1Day,0,0,0);
	var minDate = new Date(Date2Year,Date2Month,Date2Day,0,0,0);
	//alert(minDate.getTime()+"^"+objDate.getTime());
	if (minDate.getTime() > objDate.getTime()) return false;
	return true;
}

function CheckOrderStartDate(OrderStartDate,CurrDate){
	if (CurrDate=="") return true;
	if (OrderStartDate=="") return true;
	
	var dt=OrderStartDate;
	var DateFormat=tkMakeServerCall('websys.Conversions','DateFormat');
	if (DateFormat==3){
		if (dt.indexOf('-')==-1) return false;
		var dtArr=dt.split('-');
		var len=dtArr.length;
		if (len>3) return false;
		for (i=0; i<len; i++) {
		if (dtArr[i]=='') return false;
		}
	 
	 	var OrderStartDateArr=OrderStartDate.split("-");
		var OrderStartDateYear=OrderStartDateArr[0];
		var OrderStartDateMonth=parseFloat(OrderStartDateArr[1])-1;
		var OrderStartDateDay=OrderStartDateArr[2];
		
		var CurrDateArr=CurrDate.split("-");
		var CurrDateYear=CurrDateArr[0];
		var CurrDateMonth=parseFloat(CurrDateArr[1])-1;
		var CurrDateDay=CurrDateArr[2];
	}else if(DateFormat==4){
		if (dt.indexOf('/')==-1) return false;
		var dtArr=dt.split('/');
		var len=dtArr.length;
		if (len>3) return false;
		for (i=0; i<len; i++) {
		if (dtArr[i]=='') return false;
		}
	 
	 	var OrderStartDateArr=OrderStartDate.split("/");
		var OrderStartDateYear=OrderStartDateArr[2];
		var OrderStartDateMonth=parseFloat(OrderStartDateArr[1])-1;
		var OrderStartDateDay=OrderStartDateArr[0];
		
		var CurrDateArr=CurrDate.split("/");
		var CurrDateYear=CurrDateArr[2];
		var CurrDateMonth=parseFloat(CurrDateArr[1])-1;
		var CurrDateDay=CurrDateArr[0];
	}
	
	
	
	var objDate = new Date(OrderStartDateYear,OrderStartDateMonth,OrderStartDateDay,0,0,0);
	var minDate = new Date(CurrDateYear,CurrDateMonth,CurrDateDay,0,0,0);
	//alert(minDate.getTime()+"^"+objDate.getTime());
	if (minDate.getTime() > objDate.getTime()) return false;
	return true;
}

function DHCC_IsValidDate(fld) {
 var dt=fld.value;
 var re = /^(\s)+/ ; dt=dt.replace(re,'');
 var re = /(\s)+$/ ; dt=dt.replace(re,'');
 var re = /(\s){2,}/g ; dt=dt.replace(re,' ');
 if (dt=='') {fld.value=''; return 1;}

 re = /[^0-9A-Za-z]/g ;
 dt=dt.replace(re,'-');

 if ((dt.indexOf('-')==-1)) return 0;
 var dtArr=dt.split('-');
 var len=dtArr.length;
 if (len>3) return 0;
 for (i=0; i<len; i++) {
  if (dtArr[i]=='') return 0;
 }

 var dy,mo,yr;
 yr=dtArr[0];mo=dtArr[1];dy=dtArr[2];
 if ((String(yr).length!=2)&&(String(yr).length!=4)&&(String(yr).length!=0)) return 0;
 if ((String(yr).length==4)&&(yr<1840)) return 0;

 var today=new Date();
 if (yr=='') {
  yr=today.getYear();
  if (mo=='') mo=today.getMonth()+1;
 }
 if ((isNaN(dy))||(isNaN(mo))||(isNaN(yr))) return 0;
 if ((dy<1)||(dy>31)||(dy.length>=3)||(mo<1)||(mo>12)||(yr<0)) return 0;
 if (mo==2) {
  if (dy>29) return 0;
  if ((!isLeapYear(yr))&&(dy>28)) return 0;
 }
 if (((mo==4)||(mo==6)||(mo==9)||(mo==11))&&(dy>30)) return 0;
 if (isMaxedDate(dy,mo,yr)) return 0;
 fld.value=DHCC_ReWriteDate(dy,mo,yr);
 websys_returnEvent();
 return 1;
}

function isLeapYear(y) {
 return ((y%4)==0)&&(!(((y%100)==0)&&((y%400)!=0)));
}

function isMaxedDate(dy,mo,yr) {
 var maxDate = new Date();
 maxDate.setTime(maxDate.getTime() + (1000*24*60*60*1000));
 yr = parseInt(yr,10); if (yr<15) yr+=2000; else if (yr<100) yr+=1900;
 if ((yr>99)&&(yr<1000)) yr+=1900;
 var objDate = new Date(yr,mo-1,dy,0,0,0);
 if (maxDate.getTime() < objDate.getTime()) return 1;
 return 0;
}

function DHCC_ReWriteDate(d,m,y) {
 y=parseInt(y,10);
 if (y<15) y+=2000; else if (y<100) y+=1900;
 if ((y>99)&&(y<1000)) y+=1900;
 if ((d<10)&&(String(d).length<2)) d='0'+d;
 if ((m<10)&&(String(m).length<2)) m='0'+m;
 var newdate='';
 newdate=y+'-'+m+'-'+d;
 return newdate;
}

function DHCC_GetComboValue(obj) {
	if (obj){
		if (obj.getSelectedText()!=""){	return obj.getActualValue();}
	}
	return ""
}

function DHCC_GetInfoFromID(val){
	var birthdayValue,sexValue;
	if(15==val.length){ //15位身份证号码
		birthdayValue = val.charAt(6)+val.charAt(7);
		if(parseInt(birthdayValue)<10)	{
			birthdayValue = '20'+birthdayValue;
		}else{
			birthdayValue = '19'+birthdayValue;
		}
		
		birthdayValue=birthdayValue+'-'+val.charAt(8)+val.charAt(9)+'-'+val.charAt(10)+val.charAt(11);
		if(parseInt(val.charAt(14)/2)*2!=val.charAt(14))	sexValue='男';
		else sexValue='女';
	}
	
	if(18==val.length)	{ //18位身份证号码
		birthdayValue=val.charAt(6)+val.charAt(7)+val.charAt(8)+val.charAt(9)+'-'+val.charAt(10)+val.charAt(11)+'-'+val.charAt(12)+val.charAt(13);
		if(parseInt(val.charAt(16)/2)*2!=val.charAt(16)) sexValuee='男';
		else	sexValue='女';
	}
	return [birthdayValue,sexValue];
}

function DHCC_CheckEmailIsMatch(email){
	var regu = "^(([0-9a-zA-Z]+)|([0-9a-zA-Z]+[_.0-9a-zA-Z-]*[0-9a-zA-Z-]+))@([a-zA-Z0-9-]+[.])+([a-zA-Z]|net|NET|asia|ASIA|com|COM|gov|GOV|mil|MIL|org|ORG|edu|EDU|int|INT|cn|CN|cc|CC)$"
	var re = new RegExp(regu);
	if(email.search(re)!=-1){
	   return true;
	}else{
	  dhcsys_alert("邮箱地址格式不正确！");
	  return false;
	}
}
function Trim(str)
{
	return str.replace(/[\t\n\r ]/g, "");
}
function DHCC_IsIdCardNo(){
	var Errors=new Array( 
	true,
	"身份证号码位数不对!",
	"身份证号码出生日期超出范围或含有非法字符!",
	"身份证号码校验错误!",
	"身份证地区非法!"
	); 
	var area={11:"北京",12:"天津",13:"河北",14:"山西",15:"内蒙古",21:"辽宁",22:"吉林",23:"黑龙江",31:"上海",32:"江苏",33:"浙江",34:"安徽",35:"福建",36:"江西",37:"山东",41:"河南",42:"湖北",43:"湖南",44:"广东",45:"广西",46:"海南",50:"重庆",51:"四川",52:"贵州",53:"云南",54:"西藏",61:"陕西",62:"甘肃",63:"青海",64:"宁夏",65:"新疆",71:"台湾",81:"香港",82:"澳门",91:"国外"} 
	var idcard,Y,JYM; 
	var S,M; 
	var idcard_array = new Array(); 
	idcard_array = idcard.split(""); 
	//地区检验 
	if(area[parseInt(idcard.substr(0,2))]==null) return Errors[4]; 
	//身份号码位数及格式检验 
	switch(idcard.length){ 
		case 15: 
		if ( (parseInt(idcard.substr(6,2))+1900) % 4 == 0 || ((parseInt(idcard.substr(6,2))+1900) % 100 == 0 && (parseInt(idcard.substr(6,2))+1900) % 4 == 0 )){ 
			ereg=/^[1-9][0-9]{5}[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|[1-2][0-9]))[0-9]{3}$/;//测试出生日期的合法性 
		} else { 
			ereg=/^[1-9][0-9]{5}[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|1[0-9]|2[0-8]))[0-9]{3}$/;//测试出生日期的合法性 
		} 
		if(ereg.test(idcard)) return Errors[0]; 
		else return Errors[2]; 
		break; 
		case 18: 
		//18位身份号码检测 
		//出生日期的合法性检查 
		//闰年月日:((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|[1-2][0-9])) 
		//平年月日:((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|1[0-9]|2[0-8])) 
		if ( parseInt(idcard.substr(6,4)) % 4 == 0 || (parseInt(idcard.substr(6,4)) % 100 == 0 && parseInt(idcard.substr(6,4))%4 == 0 )){ 
			ereg=/^[1-9][0-9]{5}19[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|[1-2][0-9]))[0-9]{3}[0-9Xx]$/;//闰年出生日期的合法性正则表达式 
		}else { 
			ereg=/^[1-9][0-9]{5}19[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|1[0-9]|2[0-8]))[0-9]{3}[0-9Xx]$/;//平年出生日期的合法性正则表达式 
		} 
		if(ereg.test(idcard)){//测试出生日期的合法性 
			//计算校验位 
			S = (parseInt(idcard_array[0]) + parseInt(idcard_array[10])) * 7 
			+ (parseInt(idcard_array[1]) + parseInt(idcard_array[11])) * 9 
			+ (parseInt(idcard_array[2]) + parseInt(idcard_array[12])) * 10 
			+ (parseInt(idcard_array[3]) + parseInt(idcard_array[13])) * 5 
			+ (parseInt(idcard_array[4]) + parseInt(idcard_array[14])) * 8 
			+ (parseInt(idcard_array[5]) + parseInt(idcard_array[15])) * 4 
			+ (parseInt(idcard_array[6]) + parseInt(idcard_array[16])) * 2 
			+ parseInt(idcard_array[7]) * 1 
			+ parseInt(idcard_array[8]) * 6 
			+ parseInt(idcard_array[9]) * 3 ; 
			Y = S % 11; 
			M = "F"; 
			JYM = "10X98765432"; 
			M = JYM.substr(Y,1);//判断校验位 
			if(M == idcard_array[17]) return Errors[0]; //检测ID的校验位 
			else return Errors[3]; 
		} 
		else return Errors[2]; 
		break; 
		default: 
		return Errors[1]; 
		break; 
	}
}

//判断字符串是否为数字
function DHCC_isNumber(objStr){
 strRef = "+1234567890";
 for (i=0;i<objStr.length;i++) {
  tempChar= objStr.substring(i,i+1);
  if (strRef.indexOf(tempChar,0)==-1) {return false;}
 }
 return true;
}

//格式化登记号
function DHCC_FormatPatNo(ElementName){
	var PatientNo="";
	var PAPMINoObj=document.getElementById(ElementName);
	if (PAPMINoObj){
		var tkClass='web.DHCDTHealthCommon';
	  var tkMethod='FormatPatientNo';
	  PatientNo=tkMakeServerCall(tkClass,tkMethod,PAPMINoObj.value);
	  if (PAPMINoObj.tagName=='LABEL'){
	  	PAPMINoObj.innerText=PatientNo;
	  }else{
	  	PAPMINoObj.value=PatientNo;
	  }
  }
  
  return PatientNo;
}
//得到登记号系统设置长度
function DHCC_GetPatNoLen(){
	var tkClass='web.DHCDTHealthCommon';
  var tkMethod='GetPatientNoLen';
  var PatNoLen=tkMakeServerCall(tkClass,tkMethod);
  
  return PatNoLen;
}
////Disable the Button;
function DHCC_DisBtn(obj) {
	obj.disabled = true;
	//obj.className="disabledField";
	obj.style.color='darkgray';
	obj.style.backgroundColor='';
	obj.onclick = function () {
		return false;
	}
}
//Availability the Button
function DHCC_AvailabilityBtn(obj) {
	obj.disabled = false;
	//obj.className="";
	obj.style.color='black';
	//obj.style.backgroundColor='LightGrey';
	obj.onclick = function () {
		return true;
	}

}
/*  
用途：检查输入是否正确的电话和手机号  
输入：  
value：字符串  
返回：  
如果通过验证返回true,否则返回false
/^1[34578]\d{9}$/;  
*/  
function DHCC_IsTelOrMobile(telephone){ 
	//var teleReg = /^((0\d{2,3})-)(\d{7,8})$/;
	var teleReg1 = /^((0\d{2,3})-)(\d{7,8})$/;
	var teleReg2 = /^((0\d{2,3}))(\d{7,8})$/;  
	var mobileReg =/^1[3|4|5|6|7|8|9][0-9]{9}$/;
	if (!teleReg1.test(telephone)&& !teleReg2.test(telephone) && !mobileReg.test(telephone)){  
		return false;  
	}else{  
		return true;  
	}  
}

//记录时间日志,用于在操作页面功能的时候需要记录时间
function DHCC_SetTimeLog(Flag,UniqueID) {
	var tkClass='web.DHCDocCommon';
	var tkMethod='SetTimeLog';
	var ret=tkMakeServerCall(tkClass,tkMethod,Flag,UniqueID);
	return;
}

//********************Common function***************************************

///复写dhtmlXCombo的原型方法setComboValue,将为空的判断提前,为提高页面初始化速度

if (typeof dhtmlXCombo == "function") {
	dhtmlXCombo.prototype.setComboValue = function(text){
	if (text=="") {
		this.DOMelem_input.value="";
		this.DOMelem_hidden_input.value = "";
		this.unSelectOption();
	}
	//this.setComboText(text);
	var myary=text.split("^");
	for(var i=0; i<this.optionsArr.length; i++){
		if(this.optionsArr[i].data()[0].length==0) continue;
		if (this.optionsArr[i].data()[0].split("^")[0]==myary[0])
		{
			this.selectOption(i);
			this.DOMelem_hidden_input.value = text;
			this._displayText();
			break;
		}
	}

	}
}

///creator:郭荣勇
///date:20170929
///desc:得到元素的x坐标
function DHCC_getElementLeft(element){ 
	var actualLeft = element.offsetLeft; 
	var current = element.offsetParent; 
	while (current !== null){
		actualLeft += current.offsetLeft; 
		current = current.offsetParent; 
	} 
	return actualLeft; 
} 
///creator:郭荣勇
///date:20170929
///desc:得到元素的y坐标
function DHCC_getElementTop(element){ 
	var actualTop = element.offsetTop; 
	var current = element.offsetParent; 
	while (current !== null){
	　　actualTop += current.offsetTop; 
	　　current = current.offsetParent; 
	} 

	return actualTop; 
}

///字符转ASCII码,以冒号(:)拼接返回
function DHCC_CharTransAsc(Str) {
	if ((Str==="")||(typeof Str == "undefind")) return "";
	var rtnStr="";
	var len=Str.length;
	for (var i=0;i<len;i++) {
		var oneStr=Str.substr(i,1);
		if (rtnStr=="") {
			rtnStr=oneStr.charCodeAt();
		}else{
			rtnStr=rtnStr+":"+oneStr.charCodeAt();
		}
	}
	return rtnStr;
}

///ASCII码转字符,以冒号(:)拼接传入
function DHCC_AscTransChar(AscStr) {
	if ((AscStr==="")||(typeof AscStr == "undefind")) return "";
	var rtnStr="";
	var AscStrAry=AscStr.split(':');
	for (var i=0;i<AscStrAry.length;i++) {
		if (rtnStr=="") {
			rtnStr=String.fromCharCode(AscStrAry[i]);
		}else{
			rtnStr=rtnStr+String.fromCharCode(AscStrAry[i]);
		}
	}
	return rtnStr;
}
