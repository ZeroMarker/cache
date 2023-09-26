
   var LocObj;
   var objRes=document.getElementById("ResultStatus");
   var objIncludeAll=document.getElementById("IncludeAll");
   
function BodyLoadHandler(){
	InitControl();
	var objFind=document.getElementById('btnSearch');
	if (objFind) objFind.onclick=FindClickHandler;
	///20100301
	var objCall=document.getElementById('CallExec');
	if (objCall) objCall.onclick=CallClickHandler;
	///
	LocObj=document.getElementById('Location');
	LocObj.onkeyup=ClearLocId;
}
function InitControl(){
	//查询日期
	//var obj=document.getElementById("dfrom")
    //if (obj){
	//    obj.value=gettoday();
    // }
	//var obj=document.getElementById("dto")
    //if (obj){
	//    obj.value=gettoday();
    //}
	//结果状态
	var obj=document.getElementById("ResultStatus")
    if (obj){
	   obj.size=1;
	   obj.multiple=false;	
	   obj.options[1]=new Option(t['N'],"N");
	   obj.options[2]=new Option(t['Y'],"Y");
	}
}
function ClearLocId()
{
	var obj=document.getElementById('LocCode');
	obj.value="";
}
function getLocCode(value)	{
	var val=value.split("^");
	var obj=document.getElementById('LocCode');
	obj.value=val[1];
}
function gettoday(){
    var d=new Date();
    var s=d.getDate()+"/";
    s+=(d.getMonth()+1)+"/";
    s+=d.getYear();
    return(s);
}
function FindClickHandler(){
	var objDF=document.getElementById('dfrom');
	if (objDF) {dfrom=objDF.value} else {dfrom=""};
	//alert(dfrom);
	var objDT=document.getElementById('dto');
	if (objDT) {dto=objDT.value} else {dto=""};
	var objLoc=document.getElementById('LocCode')
	if (objLoc) {loc=objLoc.value} else {loc=""}
	var obj=document.getElementById('Search');
	var Include="N"
	if (objIncludeAll.checked){Include="Y"}
	obj.value=dfrom+"^"+dto+"^"+loc+"^"+objRes.value+"^"+Include;
	//alert(obj.value);
	return btnSearch_click();
}
///20100301
function CallClickHandler(){
	///alert("call");
      command="D:\\L64\\Executables\\QCGraph.exe L^demo^demo^^^^";
        //command+=session['LOGON.USERCODE']+' '+Password+' 3 '+Patient+' '+CHECKFLOW;
        //alert(command)
  var wsh= new ActiveXObject("WScript.Shell");
      //command="C:\\obilling\\obilling\\obilling.exe libo libo 3 20090516_71621 "
   if (wsh){
   wsh.run(command)
   }
}

document.body.onload=BodyLoadHandler;