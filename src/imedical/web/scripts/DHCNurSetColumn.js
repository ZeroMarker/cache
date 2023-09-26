
 var selrow;
 var transType = document.getElementById("sheetType");
 var selectedValue = "newSheet"
 function BodyLoadHandler()
{
	/*if(transType)
    {
		transType=dhtmlXComboFromSelect("sheetType","newSheet$c(2)住院$c(1)oldSheet$c(2)门诊");
		transType.selectHandle=function(){
			//var selectedValue = transType.getActualValue();
			quertAllType(selectedValue);
		}
    }*/
	var Default=document.getElementById("DefaultTyp");
	var SureBt=document.getElementById("SureBt");
	if (SureBt) {SureBt.onclick=SureBtclick;}
	var obj=document.getElementById('search');
	if (obj) {obj.onclick=sch_click;}
	sch_click();
	var CodeList=document.getElementById("CodeColum");
	if (CodeList) {CodeList.ondblclick=Codedblclick;}
	var PrintJYHZD=document.getElementById("ifPrintJYHZD");
	if (PrintJYHZD) {
		PrintJYHZD.onclick=setIfPrintJYHZD;
		var value=tkMakeServerCall("web.DHCLCNURCOLUMNSETPRINT","getIfPrintJYHZD");
		value=(value==1?true:false)
		PrintJYHZD.checked=value
	}
	quertAllType(selectedValue);
	/*	
	var index=document.getElementById("index").value;
	var LeftWidth=document.getElementById("LeftMargeW");
    if (index!=""){
	  CodeList.selectedIndex=index;
	  var Typ=CodeList.options[index].value;
	  alert(Typ)
      var GetDefaultTyp=document.getElementById("GetDefaultTyp").value
	  var ret;
	  ret=cspRunServerMethod(GetDefaultTyp,Typ);
	  var data;
	  data=ret.split("^");
	  if (data[0]=="1")
	  {
		Default.checked=true;
	  }
      LeftWidth.value=data[1]; 
    }
    */
}
function quertAllType(type)
{
	var allTypeList = document.getElementById("CodeColum");
	allTypeList.options.length=0;
	var HospitalRowId="";
	var objHospitalRowId = document.getElementById("HospitalRowId");
		if (objHospitalRowId) HospitalRowId = objHospitalRowId.value;
	var allTypeStr = tkMakeServerCall("web.DHCCLNURSET","getAllType",type,HospitalRowId);
	var optionArray = allTypeStr.split("^");
	for(var i=0;i<optionArray.length;i++)
	{
		option= optionArray[i].split("|");
		var optionObj = new Option(option[0], option[1]); 	
	    allTypeList.options[allTypeList.options.length]=optionObj;
	}	
}

function setIfPrintJYHZD()
{
	var value=document.getElementById("ifPrintJYHZD").checked;
	value=(value==true?1:0)

	var ret=tkMakeServerCall("web.DHCLCNURCOLUMNSETPRINT","setIfPrintJYHZD",value);

}
function SureBtclick()  //she zhi mo ren ge shi
{
	var Default=document.getElementById("DefaultTyp").checked
	var Code=document.getElementById("CodeColum");
	var LeftWidth=document.getElementById("LeftMargeW");
	var index=Code.selectedIndex;
	if (index==-1){return false;}
	var Typ=Code.options[index].value;
	var SaveDefTyp=document.getElementById("SaveDefTyp").value;
	var ret;
	
	if (isNumber(LeftWidth.value)){
		}
	else{
		alert("请输数字类型!");
		}
	if (Default==true)
	{
	ret=cspRunServerMethod(SaveDefTyp,Typ,LeftWidth.value*56.7);
	alert("OK");
	}

}

function Codedblclick()
{   
  	var Code=document.getElementById("CodeColum");
	var index=Code.selectedIndex;
	var Default=document.getElementById("DefaultTyp")

	if (index==-1){return false;}
	var LeftWidth=document.getElementById("LeftMargeW");
    if (index>=0){
	  Code.selectedIndex=index;
	  var Typ=Code.options[index].value;
      var GetDefaultTyp=document.getElementById("GetDefaultTyp").value
	  var ret;
	  ret=cspRunServerMethod(GetDefaultTyp,Typ);
	  var data;
	  data=ret.split("^");
	  if (data[0]=="1")
	  {
		Default.checked=true;
	  }
	  else Default.checked=false;
	  if (data[1]!=""){
      	LeftWidth.value=data[1]; 
	  }
    }
	var Typ=Code.options[index].value;
	var TypCode=Typ.split("@")[1];
    var HospitalRowId=Typ.split("@")[0];
    var lnk= "websys.default.csp?WEBSYS.TCOMPONENT=DHCNurSetColumnList&queryTypeCode="+TypCode+"&Index="+index+"&HospitalRowId="+HospitalRowId;
    parent.frames[1].location.href=lnk; 
}
function sch_click()
{
	//var selectedValue = transType.getActualValue();
	if (selectedValue != "") {
		quertAllType(selectedValue);
	} else {
		var HospitalName,
		HospitalRowId,
		sheetType = "";
		var objHospitalRowId = document.getElementById("HospitalRowId");
		if (objHospitalRowId)
			HospitalRowId = objHospitalRowId.value;
		else
			HospitalRowId = "";
		var objHospitalName = document.getElementById("HospitalName");
		if (objHospitalName)
			HospitalName = objHospitalName.value;
		else
			HospitalName = "";
		if (HospitalName == "") {
			HospitalRowId = "";
		}
		//alert("HospitalName="+HospitalName+" "+"HospitalRowId="+HospitalRowId)
		var objGetSelHospTyp = document.getElementById("GetSelHospTyp").value;
		var res = cspRunServerMethod(objGetSelHospTyp, HospitalRowId)
			//alert(res);
			var selobj = document.getElementById("CodeColum")
			addlistoption(selobj, res, "^");
	}
}
function GetHospital(str)
{
	var obj=document.getElementById('HospitalRowId');
	var tem=str.split("^");
	obj.value=tem[1];
	var obj=document.getElementById('HospitalName');
	obj.value=tem[0];
}
function addlistoption(selobj,resStr,del)
{
    var resList=new Array();
    var tmpList=new Array();
    selobj.options.length=0;
    resList=resStr.split(del);
   // alert (selobj.length);
    for (i=0;i<resList.length;i++)
    {
	    tmpList=resList[i].split("|")
	    selobj.add(new Option(tmpList[1],tmpList[0]));
	}
}
function Trim(str)
{
	return str.replace(/[\t\n\r ]/g, "");
}

function isInteger(objStr){
	var reg=/^\+?[0-9]*[0-9][0-9]*$/;
	var ret=objStr.match(reg);
  if(ret==null){return false}else{return true}
}

function isNumber(objStr){
 strRef = "-1234567890.";
 for (i=0;i<objStr.length;i++) {
  tempChar= objStr.substring(i,i+1);
  if (strRef.indexOf(tempChar,0)==-1) {return false;}
 }
 return true;
}
document.body.onload = BodyLoadHandler;
