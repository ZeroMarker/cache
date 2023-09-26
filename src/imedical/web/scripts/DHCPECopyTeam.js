document.body.onload = BodyLoadHandler;
function BodyLoadHandler() {
	var obj=document.getElementById('GBDesc');
	if (obj) obj.onchange=GBDesc_change;
	
	var obj=document.getElementById('BCopyTeam');
	if (obj) obj.onclick=BCopyTeam_click;
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
	var tbl=document.getElementById("tDHCPECopyTeam");	//取表格元素?名称
	var ToGID="";
	var obj=document.getElementById('ToGID');
	if (obj) ToGID=obj.value;
	if (ToGID==""){
		alert("复制到的团体ID为空");
		return false;
	}
	var row=tbl.rows.length;
	var vals="";
	var val="";
	var j=0
	for (var iLLoop=1;iLLoop<row;iLLoop++) {
		obj=document.getElementById('TSelect'+'z'+iLLoop);
		if (obj && obj.checked) {
			var TeamID="";
			var j=j+1
			var obj=document.getElementById('TTeamID'+'z'+iLLoop);
			if (obj) TeamID=obj.value;
			if (TeamID=="") continue
			var ret=tkMakeServerCall("web.DHCPE.PreGTeam","CopyTeamData",TeamID,ToGID)
		}
	}
	if(j==0){
		alert("未选择待复制的分组");
		return false;
	}

	alert("请查看复制结果")
	return false;
}
function DelGTeamTemp()
{
	var eSrc=window.event.srcElement;
	var ID=eSrc.id;
	ret=tkMakeServerCall("web.DHCPE.PreGTeam","GTeamTempSet","",ID,"Del"); 
	location.reload();
	
}
function SelectRowHandler() {

	var eSrc=window.event.srcElement;
	
	var rowObj=getRow(eSrc);
	
	var selectrow=rowObj.rowIndex;

	if (!selectrow) return;
	var obj=document.getElementById('TTeamID'+'z'+selectrow);
	if (obj) TeamID=obj.value;
	lnk="websys.default.csp?WEBSYS.TCOMPONENT=DHCPECopyTeamItem&AdmType=TEAM"
			+"&AdmId="+TeamID+"&PreOrAdd=PRE";
	//alert(lnk)
	parent.frames["DHCPECopyTeamItem"].location.href=lnk;
	
}