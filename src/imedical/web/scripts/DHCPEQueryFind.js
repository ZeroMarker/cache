
/// DHCPEPositiveRecord.js


var CurRow=0
var CurrentSel=0
function BodyLoadHandler() {

	var obj;
	obj=document.getElementById("BFind");
	if (obj){obj.onclick=BFind_click;}
	obj=O("GroupDesc");
	if (obj) obj.onchange=GroupDesc_change;
}
function BFind_click()
{
	var objtbl=document.getElementById('tDHCPEQueryFind');	
	var rows=objtbl.rows.length;
	var IDs="",Arg1="",StartDate="",EndDate="",MinAge="",MaxAge="",Sex="",GroupID="",SetsID="";
	for (var i=1;i<rows;i++)
	{
		var obj=document.getElementById("TSelectz"+i);
		if (obj&&obj.checked)
		{
			obj=document.getElementById("TIDz"+i);
			if (obj){
				var ID=obj.value;
				if (IDs==""){
					IDs=ID;
				}else{
					IDs=IDs+"^"+ID;
				}
			}
		}
	}
	StartDate=V("StartDate");
	EndDate=V("EndDate");
	MinAge=V("MinAge");
	MaxAge=V("MaxAge");
	Sex=V("Sex");
	if (parent.frames["left2"]) GroupID=parent.frames["left2"].GetSelectGroupIDs()
	if (parent.frames["left3"]) SetsID=parent.frames["left3"].GetSelectSetIDs()
	Arg1=StartDate+"^"+EndDate+"^"+MinAge+"^"+MaxAge+"^"+Sex+"^"+GroupID+"^"+SetsID;
	Arg2=IDs;
	
	var Job=session['LOGON.CTLOCID']+"$"+session['LOGON.USERID'];
	SetQueryValue(0,Job,Arg1,Arg2);
	//return false;
	if (parent.frames["right"]){
		lnk="websys.default.csp?WEBSYS.TCOMPONENT="+"DHCPEQueryRecordStatistic"
		+"&"+"ArgValue"+"="+Arg1+"&"+"ArgValue2"+"="+Arg2+"&Job="+Job;
		//alert(lnk)
		parent.frames["right"].location.href=lnk;
	}
}
function SetQueryValue(StartAdmID,Job,Arg1,Arg2)
{
	var ret=tkMakeServerCall("web.DHCPE.Report.QueryResult","SetResultRecord",StartAdmID,Job,Arg1,Arg2)
	if (ret!=""){
		SetQueryValue(ret,Job,Arg1,Arg2)
	}
}
function V(ElementName)
{
	var value="";
	var obj=O(ElementName);
	if (obj){
		value=obj.value;	
	}
	return value;
}
function SV(ElementName,value)
{
	var obj=O(ElementName);
	if (obj){
		obj.value=value;	
	}
}
function O(ElementName)
{
	return document.getElementById(ElementName);
}
function SelectGroupAfter(value)
{
	if (value=="") return false;
	var Arr=value.split("^");
	SV("GroupID",Arr[0]);
	SV("GroupDesc",Arr[1]);
}
function GroupDesc_change()
{
	SV("GroupID","");
}
function SelectRowHandler()	
{	
	var eSrc = window.event.srcElement;	
	//var objtbl=document.getElementById('tDHCPEQueryFind');	
	//var rows=objtbl.rows.length;
	//var lastrowindex=rows - 1;
	var rowObj=getRow(eSrc);
	var Row=rowObj.rowIndex;
	var obj=document.getElementById("TIDz"+Row)
	if (obj){
		var ParRef=obj.value;
		if (parent.frames["right"]){
			lnk="dhcpepositiverecordcon.csp"
			+"?"+"ParrefRowId"+"="+ParRef+"&"+"Type"+"="+"PR";
			//alert(lnk)
			parent.frames["right"].location.href=lnk;
		}
	}
}

document.body.onload = BodyLoadHandler;

