
//����	DHCPECopyTeam.js
//����	���Ʒ���
//���	DHCPECopyTeam	
//����	2018.09.10
//������  xy

document.body.onload = BodyLoadHandler;
function BodyLoadHandler() {
	var obj=document.getElementById("GBDesc");
	if (obj) obj.onchange=GBDesc_change;
	
	var obj=document.getElementById("BCopyTeam");
	if (obj) obj.onclick=BCopyTeam_click;
	
	initButtonWidth();
	

}

function GBDescSelectAfter(value)
{
	var Data=value.split("^");

	var obj=document.getElementById('GBDesc');
	if (obj) { obj.value=Data[0]; }
	
	var iCode=Data[2];
	obj=document.getElementById('GBID');
	if (obj) { obj.value=iCode; }
}

function GBDesc_change()
{
	var obj=document.getElementById('GBDesc');
	if(obj) obj.value="";
	obj=document.getElementById('GBID');
	if(obj) { obj.value=""; }
}

function BCopyTeam_click()
{
	var ToGID="";
	var obj=document.getElementById('ToGID');
	if (obj) ToGID=obj.value;
	if (ToGID==""){
		alert("���Ƶ�������IDΪ��");
		return false;
	}
	var objtbl = $("#tDHCPECopyTeam").datagrid('getRows');
	var row=objtbl.length;

	var vals="";
	var val="";
	var j=0
	for (var iLLoop=0;iLLoop<row;iLLoop++) {
		var TSelect=getCmpColumnValue(iLLoop,"TSelect","DHCPECopyTeam")
		if (TSelect=="1") {
			var TeamID="";
			var j=j+1
			 var TeamID=objtbl[iLLoop].TTeamID;
			if (TeamID=="") continue
			var ret=tkMakeServerCall("web.DHCPE.PreGTeam","CopyTeamData",TeamID,ToGID)
		}
	}
	if(j==0){
		top.$.messager.alert("��ʾ","δѡ������Ƶķ���","info");
		return false;
	}
   top.$.messager.alert("��ʾ","��鿴���ƽ��","info");
      $("#tDHCPECopyTeam").datagrid('load',{ComponentID:56780,VIP:"",ToGID:"",GBID:$("#GBID").val()});
	return false;
}

var selectrow=-1;
function SelectRowHandler(index,rowdata) {
	selectrow=index;
	if (selectrow==-1) return;
	 var objtbl = $("#tDHCPECopyTeam").datagrid('getRows');
	if(index==selectrow)
	{	
	 	var TeamID=objtbl[selectrow].TTeamID;
		lnk="websys.default.hisui.csp?WEBSYS.TCOMPONENT=DHCPECopyTeamItem&AdmType=TEAM"
			+"&AdmId="+TeamID+"&PreOrAdd=PRE";
		//alert(lnk)
		parent.frames["DHCPECopyTeamItem"].location.href=lnk;
	}else
	{
		SelectedRow=-1;
		
	}


}
