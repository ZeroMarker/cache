/// 
//名称	DHCPERebateFind
//功能	体检费用打折查询
//组件	DHCPERebateFind	
//创建	2012.01.11


var TFORM="";
function BodyLoadHandler() {
	var obj;

	obj=document.getElementById("GroupDesc");
	if (obj) {
		obj.onchange=GroupDesc_change;
		
	}
	


	obj=document.getElementById("BFind");
	if (obj) { obj.onclick=BFind_Click; }
	
	iniForm();
	Muilt_LookUp('GroupDesc');
}
function iniForm(){

	
	var obj;
	obj=document.getElementById('Type');
	if (obj){Type=obj.value}
	obj=document.getElementById("Group");
	if (obj) {
		if (Type.indexOf("G")>-1) { obj.checked=true; }
		else { obj.checked=false; }
	}
    
	obj=document.getElementById("Person");
	if (obj) { 
	if (Type.indexOf("I")>-1) { obj.checked=true; }
		else { obj.checked=false; }
	}
}


function SelectGruop(value)
{
	if (value=="") return;
	var ValueArr=value.split("^");
	var obj=document.getElementById("GroupDesc");
	if (obj) obj.value=ValueArr[0];
	var obj=document.getElementById("GroupID");
	if (obj) obj.value=ValueArr[1];
}





function GroupDesc_change() {

	var obj;

	obj=document.getElementById('GroupID');
	if (obj) { obj.value="";}
}



function BFind_Click(){

	var iDateFrom='',iDateTo='',iPatRegNo='',iPatName='',iRebateFrom='',iRebateTo='',iGroupID='',iPersonFlag='N',iGroupFlag='N',iFlag="";
	var obj;
	obj=document.getElementById('PatRegNo');
	if (obj) { iPatRegNo=obj.value; }

	obj=document.getElementById('PatName');
	if (obj) { iPatName=obj.value; }
	
	obj=document.getElementById('GroupID');
	if (obj) { iGroupID=obj.value; }
	
	obj=document.getElementById('DateFrom');
	if (obj) { iDateBegin=obj.value; }
	
	obj=document.getElementById('DateTo');
	if (obj) { iDateEnd=obj.value; }
	
	obj=document.getElementById('RebateFrom');
	if (obj) { iRebateFrom=obj.value; }
	
	obj=document.getElementById('RebateTo');
	if (obj) { iRebateTo=obj.value }
	
	obj=document.getElementById('Person');
	if (obj && obj.checked) { iPersonFlag="Y"; iFlag="I"}
	obj=document.getElementById('Group');
	if (obj && obj.checked) { iGroupFlag="Y" ; iFlag=iFlag+"^"+"G" }

	var lnk='websys.default.csp?WEBSYS.TCOMPONENT='+'DHCPERebateFind'
			+"&DateFrom="+iDateBegin
			+"&DateTo="+iDateEnd
		    +"&PatRegNo="+iPatRegNo
		    +"&PatName="+iPatName
		    +"&GroupID="+iGroupID
		    +"&RebateFrom="+iRebateFrom
		    +"&RebateTo="+iRebateTo
		    +"&PersonFlag="+iPersonFlag
		    +"&GroupFlag="+iGroupFlag
		    +"&Type="+iFlag	
	
	location.href=lnk;
	
}

document.body.onload = BodyLoadHandler;