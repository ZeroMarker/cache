
//名称	DHCPEPreIBaseInfo.List.js
//功能	个人基本信息维护
//组件	DHCPEPreIBaseInfo.List 	
//创建	2008.08.29
//创建人  xy

function BodyLoadHandler() {

	var obj;
	obj=document.getElementById("BFind");
	if (obj) {obj.onclick=BFind_Click;}

	obj=document.getElementById("RegNo");
	if (obj) {obj.onkeydown=RegNo_keydown; }
	
	obj=document.getElementById("PatName");
	if (obj) {obj.onkeydown=RegNo_keydown; }
	
	obj=document.getElementById("BNew");
	if (obj) {obj.onclick=BNew_Click; }
	
}

function BNew_Click()
{
	//var str='websys.default.hisui.csp?WEBSYS.TCOMPONENT=DHCPEPreIBaseInfo.Edit';
	//websys_lu(str,false,'width=1020,height=545,hisui=true,title=个人基本信息维护')
   // window.open(str,'_blank','toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width=1000,height=1200,left=120,top=0')
	var lnk="dhcpepreibaseinfo.edit.hisui.csp";
	websys_lu(lnk,false,'iconCls=icon-w-edit,width=795,height=640,hisui=true,title=个人基本信息维护')

}
function RegNo_keydown(e){
	
	var Key=websys_getKey(e);
	if ((13==Key)) {
		BFind_Click();
	}
}


function BFind_Click()
{   
   
    var RegNoLength=tkMakeServerCall("web.DHCPE.DHCPECommon","GetRegNoLength");
	iRegNo=getValueById("RegNo");
	if (iRegNo.length<RegNoLength&&iRegNo.length>0) { 
		iRegNo=RegNoMask(iRegNo);
		$("#RegNo").val(iRegNo);
	}
	
	var iPatName=getValueById("PatName");
	
    var iPatType=getValueById("PatType");
	
    var iPatSex=getValueById("PatSex");
	
    var iPatDOB=getValueById("PatDOB");
	
    var iPatIDCard=getValueById("PatIDCard");
	
  	var lnk="websys.default.hisui.csp?WEBSYS.TCOMPONENT="+"DHCPEPreIBaseInfo.List"
			+"&RegNo="+iRegNo
			+"&PatName="+iPatName
			+"&PatType="+iPatType
			+"&PatSex="+iPatSex
			+"&PatDOB="+iPatDOB
			+"&PatIDCard="+iPatIDCard
               
    //location.href=lnk; 
	$("#tDHCPEPreIBaseInfo_List").datagrid('load',{
	ComponentID:56111,
	RegNo:iRegNo,
	PatName:iPatName,
	PatType:iPatType,
	PatSex:iPatSex,
	PatDOB:iPatDOB,
	PatIDCard:iPatIDCard
	});
}




document.body.onload = BodyLoadHandler;



