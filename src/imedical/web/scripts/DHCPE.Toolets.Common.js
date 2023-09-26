/*
/Created by Robert 2006/2/16
/Description: JavaScript小工具
/filename: Bob.Toolets.Common.JS
/--------方法列表----------
/	function Val(sourceStr)
/	function MyReplace(OrigalStr, insteadedStr, inteadorStr) 
/	function DAlert(msg) 
/	function FormatAdmNo(admNo)
/-------------------------
*/

//返回一个字符串的值 ? 如?val("123abc")=123
function Val(sourceStr){
	sourceStr=sourceStr.replace(" ","")
	var ret=""
	for(var i=0;i<sourceStr.length;i++){
		chr=sourceStr.charAt(i);
		if ((i==0)&((chr=="-")|(chr=="+"))) continue;
		if (isNaN(ret+chr)==false) {
			ret=ret+chr;
		}
		else
			break;
	}
	if ((ret!="")&(sourceStr.charAt(0)=="-")){
		ret="-"+ret;
	}
	if (ret=="") ret="0";
	
	return ret*1;
}

/*
/Created by robert 2006/1/16
/Description: a toolet to instead String.Replace.
/*/
function MyReplace(OrigalStr, insteadedStr, inteadorStr) 
{
	var arrTemp=OrigalStr.split(insteadedStr);
	var returnStr=arrTemp[0];	
	for (i=1;i<arrTemp.length;i++)
		returnStr += (inteadorStr+arrTemp[i]);
	return returnStr;
}

/*
/Created by robert 2006/1/16
/Description: alerts when it is debug, else does not alert.
/*/
function DAlert(msg) 
{
	//alert("---DebugInfo:---"+msg);  //mlh0718
}

/*
/Created by Robert 2006/5/16
/Description: format AdmNO 
*/
function FormatAdmNo(admNo)
{
	var temp="00000000";
	var ret="";
	ret=temp.substr(1, temp.length-admNo.length)+admNo;
	return ret;	
}

//点中某一行选中指定的CheckBox(ItemName)
function ChangeCheckStatus(ItemName)
{
	var eSrc=window.event.srcElement;
	
	var rowObj=getRow(eSrc);
	
	var selectrow=rowObj.rowIndex;

	if (!selectrow) return;
	var obj=document.getElementById(ItemName+"z"+selectrow);
	if (obj) obj.checked=!obj.checked;
}
function Muilt_LookUp(Value)
   {   
        var value=Value.split("^")
	var i=0;
	for (i=0;i<value.length;i++)
	{
		var obj=document.getElementById(value[i]);
	    	if (obj) obj.onkeydown=KeyDown_LookUp;
	}
}
function KeyDown_LookUp()
{  
	if (event.keyCode==13)
	{   
		var eSrc=window.event.srcElement;
		var lobj=document.getElementById(GetLookupName(eSrc.id));
		if (lobj) lobj.click();
	}
}
function GetLookupName(name)
{  
	return "ld"+document.getElementById("GetComponentID").value+"i"+name
}
function JudgeArrivedNum(PreIADM)
{
	var Flag=tkMakeServerCall("web.DHCPE.PreManager","JudgeArriveNum",PreIADM);
	var Arr=Flag.split("^")
	var ArrivedFlag=Arr[0];
	if (ArrivedFlag==0) return true;
	var ArrivedOverNum=Arr[1];
	//if (confirm("到达此人将要超出限额"+ArrivedOverNum+"人,是否继续到达?")) return true;
	return false;
}
