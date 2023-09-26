//PMPStadz.js   张枕平  20150114  状态功能配置
var CurrentSel=0;
var userId=session['LOGON.USERID'];
var username=session['LOGON.USERNAME'];
var locid=session['LOGON.CTLOCID'];
function BodyLoadHandler()
{
	iniForm();
	var VerStr=tkMakeServerCall("web.PMP.Ztgndz","SelectStatus");
	//alert(VerStr);
	iniForman(VerStr);
	iniFormjm();
	var obj=document.getElementById("new");
	if (obj){ obj.onclick=New_click;}
	
	var obj=document.getElementById("delete");
	if (obj){ obj.onclick=Delete_click;}
}
function New_click()
{
	var DZzt=document.getElementById("DZzt").value;
	if(DZzt==""){
		alert(t["DZzt"]);
		return;
		}
	var DZan=document.getElementById("DZan").value;
	if(DZan==""){
		alert(t["DZan"]);
		return;
		}
	var DZjm=document.getElementById("DZjm").value;
	if(DZjm==""){
		alert(t["DZjm"]);
		return;
		}
	var VerStr=tkMakeServerCall("web.PMP.Ztgndz","insertsjdz",DZzt,DZan,userId,DZjm);
	alert(t[VerStr]);
	lnk="websys.default.csp?WEBSYS.TCOMPONENT=PMPStadz";
	location.href=lnk;
	}
function Delete_click()
{
	var DZzt=document.getElementById("DZzt").value;
	if(DZzt==""){
		alert(t["DZzt"]);
		return;
		}
	var DZan=document.getElementById("DZan").value;
	if(DZan==""){
		alert(t["DZan"]);
		return;
		}
	var DZjm=document.getElementById("DZjm").value;
	if(DZjm==""){
		alert(t["DZjm"]);
		return;
		}
	//alert(DZzt+"^"+DZan+"^"+DZjm);
	var VerStr=tkMakeServerCall("web.PMP.Ztgndz","deletesjdz",DZzt,DZan,userId,DZjm);
	alert(t[VerStr]);
	lnk="websys.default.csp?WEBSYS.TCOMPONENT=PMPStadz";
	location.href=lnk;
	}
function iniForman(str)
{
	var ztzh=str.split(",");
	var len=ztzh.length;
	var obj=document.getElementById("DZzt");
	var strstr;
	if (obj){
		obj.size=1;
		obj.multiple=false;
		obj.onchange=GetType_OnChangean;
		obj.options[0]=new Option("","");
		for(i=0;i<len;i++){
			strstr=ztzh[i].split("^");
			obj.options[i+1]=new Option(strstr[0],strstr[1]);
			obj.options[i+1].id=strstr[1];
			}
	    var xnhVal=document.getElementById("DZztid")
		if(xnhVal.value!=""){
		setElementValue("DZzt",xnhVal.value);
	}
	}
	}
function SelectRowHandler()	
{
  var eSrc=window.event.srcElement;	
  var objtbl=document.getElementById('tPMPStadz');
  var rowObj=getRow(eSrc);
  var selectrow=rowObj.rowIndex;
  if (!selectrow) return;
  var SelRowObj
	var obj	
	if (selectrow==CurrentSel){		
	
	    CurrentSel=0;
	    return;
	}		
  CurrentSel=selectrow;
  var row=selectrow;
  var DZzt=document.getElementById('Tztz'+row).innerText;
  var DZan=document.getElementById('Tanz'+row).innerText;
  var obj=document.getElementById('DZan');
  for (var i=0;i<obj.options.length;i++){
		if (DZan==obj.options[i].innerText){
		   obj.selectedIndex=i; 
		}
	}
   var obj=document.getElementById('DZzt');
   for (var i=0;i<obj.options.length;i++){
		if (DZzt==obj.options[i].innerText){
		   obj.selectedIndex=i; 
		}
	}
}
function FrameEnterkeyCode()
{
	var e=window.event;
	switch (e.keyCode){
		//上下移动光标键
	case 38:
		var objtbl=window.document.getElementById('tPMPStadz');
		if (iSeldRow==1) {break;}
		var objrow=objtbl.rows[iSeldRow-1];
		objrow.click();
		break;
	case 40:
		var objtbl=window.document.getElementById('tPMPStadz');
		var rows=objtbl.rows.length-1;
		if (iSeldRow==rows) {break;}
		var objrow=objtbl.rows[iSeldRow+1];
		objrow.click();
		break;
	}
}
function iniForm()
{
	var DZjm=document.getElementById("DZjm").value;
	var obj=document.getElementById("DZan");
	if (obj){
		obj.size=1;
		obj.multiple=false;
		obj.onchange=GetType_OnChange;
		obj.options[0]=new Option("","");
		obj.options[1]=new Option("同意改进","TONGYI");
		obj.options[2]=new Option("无需改进","BUTONGYI");
		obj.options[3]=new Option("指派人员","XQZhiPaiRenYuan");
		obj.options[4]=new Option("更改需求","XQUpdate");
		obj.options[5]=new Option("需求申请","Create");
		obj.options[6]=new Option("重置需求","CRUpdate");
		obj.options[7]=new Option("删除需求","CRdelete");
		obj.options[8]=new Option("提交申请","CRTijiaoshenqing");
		obj.options[9]=new Option("测试通过","YZceshitongguo");
		obj.options[10]=new Option("回执处理","YZceshibutongguo");
		obj.options[11]=new Option("同意修改","XGtongyi");
		obj.options[12]=new Option("拒绝修改","XGbutongyi");
		var xnhVal=document.getElementById("DZanid")
		if(xnhVal.value!=""){
			setElementValue("DZan",xnhVal.value);
		}
	}
	}
function iniFormjm()
{
	var obj=document.getElementById("DZjm");
	if (obj){
		obj.size=1;
		obj.multiple=false;
		obj.onchange=GetType_OnChangejm;
		obj.options[1]=new Option("","");
		obj.options[1]=new Option("审核界面","PMPImprovementFindByHospital");
		obj.options[2]=new Option("需求申请界面","PMPImprovementListNew");
		var xnhVal=document.getElementById("DZjmid")
		if(xnhVal.value!=""){
			setElementValue("DZjm",xnhVal.value);
		}
	}
	}
function GetType_OnChange()
{
	var myValue="";
	var obj=document.getElementById("DZan");
	if (obj)
	{
		var myIdx=obj.options.selectedIndex;
		if(myIdx<0)
		{
			return;
		}
		myValue=obj.options[myIdx].value;
		var AdmTypeValobj=document.getElementById("DZanid");
		AdmTypeValobj.value=myValue
	}
}
function GetType_OnChangejm()
{
	var myValue="";
	var obj=document.getElementById("DZjm");
	if (obj)
	{
		var myIdx=obj.options.selectedIndex;
		if(myIdx<0)
		{
			return;
		}
		myValue=obj.options[myIdx].value;
		var AdmTypeValobj=document.getElementById("DZjmid");
		AdmTypeValobj.value=myValue
	}
}
function GetType_OnChangean()
{
	var myValue="";
	var obj=document.getElementById("DZzt");
	if (obj)
	{
		var myIdx=obj.options.selectedIndex;
		if(myIdx<0)
		{
			return;
		}
		myValue=obj.options[myIdx].value;
		var AdmTypeValobj=document.getElementById("DZztid");
		AdmTypeValobj.value=myValue
	}
}
document.body.onload = BodyLoadHandler;