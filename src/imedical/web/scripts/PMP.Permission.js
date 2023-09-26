///PMP.Permission.js
//
var SelectedRow = 0;
var CurrentSel = 0;
var tables = document.getElementsByTagName("table");
var perRowid;

var admdepobj=document.getElementById('SSUserqx');
if (admdepobj) admdepobj.onkeydown=getadmdep4;
var admdepobj=document.getElementById('XQNetShenhe');
if (admdepobj) admdepobj.onkeydown=getadmdep6;
function BodyLoadHandler()
{
	var obj;
	
	obj=document.getElementById("new") ;
	if (obj) obj.onclick=newAdd;
	obj=document.getElementById("GLuserQX") ;
	if (obj) obj.onclick=GLuserQX_Click;
	
	obj=document.getElementById("Delete") ;
	if (obj) obj.onclick=Delete_Click;
	
	obj=document.getElementById("Update") ;
	if (obj) obj.onclick=Update_Click;
	
	obj=document.getElementById("updateqx") ;
	if (obj) obj.onclick=updateqx_click;
	
	var objtbl=document.getElementById('tPMP_Permission');
	
	trRep = tables[4];
	trRep.style.display = 'none';
	iniForm();
}
function getMaxLevel(){
	var getMaxLevelPath=document.getElementById('getMaxLevelPath');
	if (getMaxLevelPath) {var encmeth=getMaxLevelPath.value} else {var encmeth=''};
	var ProDRHidden = document.getElementById('ProDRHidden').value;
	var level = cspRunServerMethod(encmeth,ProDRHidden)
	document.getElementById('level').value = level
	}
function updateqx_click(){
	var ssuser=document.getElementById("SSUserqxid").value;
	var hasUser=tkMakeServerCall("web.PMPPermisBusiness","hasUser",perRowid,ssuser);
	//----begin---modify by baoshi 判断绑定人员不能为空,否则插入程序会插入数据-------
	var user=document.getElementById('SSUserqx').value;
	if (user=="")
		{
			alert("绑定用户不能为空");
			return;
		}
	//----end----------------------------------------------------------------
	if (hasUser=="2"){
		alert("绑定人员重复！")
		return;
		}
	var updatestr=tkMakeServerCall("web.PMPPermisBusiness","insertPermisBusiness",perRowid,ssuser);
	if(updatestr=="0"){
		alert("绑定成功!")
		var lnk = "websys.default.csp?WEBSYS.TCOMPONENT=PMP_Permission";
 		window.location.href=lnk;
		}else{
		alert("该用户已绑定，绑定失败！")	
			}
	
	}
function Look_SHENHEQK(value){
	var info=value.split("^");
    document.getElementById("SHENHEQK").value=info[0];
    document.getElementById("SHENEHQKID").value = info[1];
    
	}
function newAdd(){
	var getMaxLevelPath=document.getElementById('getMaxLevelPath');
	if (getMaxLevelPath) {var encmeth=getMaxLevelPath.value} else {var encmeth=''};
	var ProDRHidden = document.getElementById('ProDRHidden').value;
	var SHENEHQKID=document.getElementById('SHENEHQKID').value;
	var XQNetShenheid=document.getElementById('XQNetShenheid').value;
    if(SHENEHQKID==""){
	    alert(t["SHENEHQKID"]);
	    return;
	    }
	var level1 = cspRunServerMethod(encmeth,ProDRHidden)
	//获取最大值，并和添加获取的级别值比较，如果不一样，那么不能添加
	var level=document.getElementById('level').value;
	
	//alert("level1:"+level1)
	//alert("level:"+level)
	if (level1==level){
    if (level=="") {
		//alert("级别不能为空！");
		alert(t['level']);
		return;}

    var levelName=document.getElementById('levelName').value;
    if (levelName==""){
	    alert(t['levelName']);
	    return;
	    }
    var ProDRHidden=document.getElementById('ProDRHidden').value;
    if (ProDRHidden==""){
	    alert(t['ProDR']);
	    return;
	    }
	var XQbxsh=document.getElementById("XQbxsh").value
    var addPath=document.getElementById('addPath');
	if (addPath) {var encmeth=addPath.value} else {var encmeth=''};
	//var wintype=combo_WinTypeList.getActualValue()
	if(cspRunServerMethod(encmeth,level,levelName,ProDRHidden,SHENEHQKID,XQNetShenheid,XQbxsh)){
		//alert("添加成功");
		alert(t['add']);
		var lnk = "websys.default.csp?WEBSYS.TCOMPONENT=PMP_Permission";
 		window.location.href=lnk;
		}
	}else{
		alert("不能添加相同级别的权限!")
		}
}
function Update_Click(){
	
    var level=document.getElementById('level').value;
    var SHENEHQKID=document.getElementById('SHENEHQKID').value;
    if(SHENEHQKID==""){
	    alert(t["SHENEHQKID"]);
	    return;
	    }
    var levelName=document.getElementById('levelName').value;
    if (levelName==""){
	    alert(t['levelName']);
	    return;
	    }
    var ProDRHidden=document.getElementById('ProDRHidden').value;
    if (ProDRHidden==""){
	    alert(t['ProDR']);
	    return;
	    }
	var XQNetShenheid=document.getElementById("XQNetShenheid").value
	var XQNetShenhe=document.getElementById("XQNetShenhe").value
	if(XQNetShenhe==""){
		XQNetShenheid=""
		}
	var XQbxsh=document.getElementById("XQbxsh").value
    var updatePath=document.getElementById('updatePath');
	if (updatePath) {var encmeth=updatePath.value} else {var encmeth=''};
	//var wintype=combo_WinTypeList.getActualValue()
	
	var Shjd=document.getElementById("Shjd").value
	var Rowid = document.getElementById('Rowid').value;
	//alert("11");
	if(cspRunServerMethod(encmeth,Rowid,levelName,ProDRHidden,SHENEHQKID,XQNetShenheid,XQbxsh,Shjd)){
		alert(t['update']);
		var lnk = "websys.default.csp?WEBSYS.TCOMPONENT=PMP_Permission";
 		window.location.href=lnk;
		}
	
}
function Delete_Click(){
	
	var encmeth;
	var Rowid = document.getElementById('Rowid').value;
	var delPath=document.getElementById('delPath');
	if (delPath) {var encmeth=delPath.value} else {var encmeth=''};
	if(cspRunServerMethod(encmeth,Rowid)){
		alert(t['delete']);
		var lnk = "websys.default.csp?WEBSYS.TCOMPONENT=PMP_Permission";
 		window.location.href=lnk;
		return;
		}
	}
	
function SelectRowHandler()	{
	var eSrc=window.event.srcElement;
	objtbl=document.getElementById('tPMP_Permission');
	var rows=objtbl.rows.length;
	var lastrowindex=rows - 1;
	var rowObj=getRow(eSrc);
	var selectrow=rowObj.rowIndex;
	 if (selectrow==CurrentSel){	
       CurrentSel=0;
       document.getElementById('level').value="";
       document.getElementById('SHENHEQK').value="";
       document.getElementById('SHENEHQKID').value="";
	   document.getElementById('levelName').value="";
	   document.getElementById('ProDR').value="";
	   document.getElementById('ProDRHidden').value="";
	   document.getElementById('Rowid').value=""; 
	   document.getElementById("XQNetShenheid").value="";
       document.getElementById("XQNetShenhe").value = "";
       document.getElementById("SHENEHQKID").value="";
	   perRowid="";
	   document.getElementById("SSUserqxid").value="";
       return;
	 }
	var SelRowObj=document.getElementById('Tlevelz'+selectrow);
	var TSHENHEJK=document.getElementById('TSHENHEJKz'+selectrow);
	var SelRowObj1=document.getElementById('TlevelNamez'+selectrow);
	var SelRowObj2=document.getElementById('TProDRz'+selectrow);
	var SelRowObj3=document.getElementById('TProDRNamez'+selectrow);
    var SelRowObj4=document.getElementById('TDatez'+selectrow);
    var SelRowObj5=document.getElementById('TTimez'+selectrow);
    var SelRowObj6=document.getElementById('TRowidz'+selectrow);
    var SelRowObj7=document.getElementById('TNetShenhez'+selectrow);
    var SelRowObj8=document.getElementById('TNetShenheidz'+selectrow);
    //alert(SelRowObj8.value)
	document.getElementById('level').value=SelRowObj.innerText;
	document.getElementById('levelName').value=SelRowObj1.innerText;
	document.getElementById('ProDR').value=SelRowObj3.innerText;
	document.getElementById('ProDRHidden').value=SelRowObj2.innerText;
	document.getElementById('Rowid').value=SelRowObj6.innerText; 
	perRowid=SelRowObj6.innerText; 
	trRep = tables[4];
	trRep.style.display = '';
	document.getElementById('levelqx').value=SelRowObj.innerText;
	document.getElementById('levelNameqx').value=SelRowObj1.innerText;
	document.getElementById('ProDRqx').value=SelRowObj2.innerText;
	document.getElementById('ProNameqx').value=SelRowObj3.innerText;
	document.getElementById('SHENHEQK').value=TSHENHEJK.innerText;
	var updatestr=tkMakeServerCall("web.PMPPermission","Shenheid",TSHENHEJK.innerText);
	document.getElementById("SHENEHQKID").value=updatestr;
	document.getElementById("XQNetShenhe").value =SelRowObj7.innerText;
	document.getElementById("XQNetShenheid").value=SelRowObj8.value;
	var SelRowObj
	var obj	
	if (selectrow==CurrentSel){	
	CurrentSel=0;
	document.getElementById('level').value = ""
	document.getElementById('levelName').value = ""
	document.getElementById('ProDR').value = ""
	document.getElementById('SHENHEQK').value="";
    document.getElementById('SHENEHQKID').value="";
	trRep = tables[4];
	trRep.style.display = 'none';
	return;
	}	
	CurrentSel=selectrow
	SelectedRow = selectrow;
}

function LookUp_ProDesc(value){
    var info=value.split("^");
    document.getElementById("ProDRHidden").value=info[0];
    document.getElementById('ProDR').value = info[1];
    getMaxLevel();
}

function getUserId(value){
	var info=value.split("^");
    document.getElementById("SSUserqx").value=info[0];
    document.getElementById("SSUserqxid").value = info[2];
    
	}
	
function getadmdep4()
{if (window.event.keyCode==13) 
	{  window.event.keyCode=117;
	  SSUserqx_lookuphandler();
		}
	}
function GLuserQX_Click(){
	if(perRowid==""){
		alert(t["1001"]);
		return;
		}
	else {
	    Userid=document.getElementById("SSUserqxid").value
	    window.open('websys.default.csp?WEBSYS.TCOMPONENT=PMP.PermissionUserList&Rowid='+perRowid+'&Userid='+Userid, '权限明细管理', 'resizable=yes,height=500,width=850,left=200,top=100');
	}
	}
function SelectTXSH1(value){
	var info=value.split("^");
    document.getElementById("XQNetShenheid").value=info[0];
    document.getElementById("XQNetShenhe").value = info[1];
	}	
function iniForm()
{
	var obj=document.getElementById("XQbxsh");
	if (obj){
		obj.size=1;
		obj.multiple=false;
		obj.onchange=GetType_OnChange;
		obj.options[0]=new Option("必须审核","Y");
		obj.options[1]=new Option("非必须审核","N");
		obj.options[2]=new Option("需求分配","F");
		obj.options[3]=new Option("院长审核","E");
		 var xnhVal=document.getElementById("XQbxshid")
		if(xnhVal.value!=""){
			setElementValue("XQbxsh",xnhVal.value);
		}
	}
	
	
	var obj1=document.getElementById("Shjd");
	if (obj1){
		obj1.size=1;
		obj1.multiple=false;
		obj1.onchange=GetJd_OnChange;
		obj1.options[0]=new Option("审核节点","Y");
		obj1.options[1]=new Option("非审核节点","N");
		 var xshVal=document.getElementById("Shjdid")
		if(xshVal.value!=""){
			setElementValue("Shjd",xshVal.value);
		}
	}
	}
function getadmdep6()
{
	if (window.event.keyCode==13) 
		{  window.event.keyCode=117;
	  		XQNetShenhe_lookuphandler();
		}
}
function GetType_OnChange()
{
	var myValue="";
	var obj=document.getElementById("XQbxsh");
	if (obj)
	{
		var myIdx=obj.options.selectedIndex;
		if(myIdx<0)
		{
			return;
		}
		myValue=obj.options[myIdx].value;
		var AdmTypeValobj=document.getElementById("XQbxshid");
		AdmTypeValobj.value=myValue
	}
}

function GetJd_OnChange()
{
	var myValue="";
	var obj=document.getElementById("Shjd");
	if (obj)
	{
		var myIdx=obj.options.selectedIndex;
		if(myIdx<0)
		{
			return;
		}
		myValue=obj.options[myIdx].value;
		var AdmTypeValobj=document.getElementById("Shjdid");
		AdmTypeValobj.value=myValue
	}
}
document.body.onload=BodyLoadHandler;
