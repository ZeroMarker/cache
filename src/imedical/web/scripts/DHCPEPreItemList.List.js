//FileName: DHCPEPreItemList.List.JS
var Rows;
var row=0;
function InitMe()	{
	Rows=GetTotalRows();
	var obj=document.getElementById("Control");
	if (obj) var Control=obj.value;
	if (Control!="Del"){
		SetDeleteVisable();
		SetRecLocDisabled();
	}
	else{
		SetDelete();
		SetChoiceRecLoc();
	}
	ColorTblColumn();

}
function ColorTblColumn(){
	var tbl=document.getElementById('tDHCPEPreItemList_List');	
	var row=tbl.rows.length;
	row=row-1;
	for (var j=1;j<Rows+1;j++) {
		var sLable=document.getElementById('TItemStatz'+j);
		var sItemStat=sLable.parentElement;
		//var strCell=sLable.innerText;
		var strCell=sLable.value;
		//strCell=strCell.replace(" ","")
		if (strCell!='1') {
			//sItemStat.bgColor="#FF1100"
			//sLable.foreColor="#FF1100"
			
			tbl.rows[j].style.background="#FF88AA";
			//tbl.rows[j].style.color="#FF1100";
		}
	}
}
function SetDelete()
{
	AdmType=document.getElementById("AdmType")
	AdmType=AdmType.value;
	//AdmType=="TEAMOrd")
	var GADM=GetCtlValueById("GADM",1)
		
	for (var j=1;j<Rows+1;j++) {
		
		var sLable=document.getElementById('TDeletez'+j);
		var sLableAdd=document.getElementById('TDeleteAddAmountz'+j);
		var obj=document.getElementById('TItemStatz'+j);
		var ItemStat=4;
		if (obj) ItemStat=obj.value;
		var TPreOrAdd="Ô¤Ô¼"
		var obj=document.getElementById('TPreOrAddz'+j);
		if (obj) TPreOrAdd=obj.innerText;
		if (ItemStat==1)
		{
			if (sLable) sLable.onclick = Delete_Click;
			if (sLableAdd) sLableAdd.onclick = DeleteAddAmount_Click;
		}
		else
		{
			if (sLable) sLable.style.visibility = "hidden";
			if (sLableAdd) sLableAdd.style.visibility = "hidden";
		}
		if ((TPreOrAdd=="¼ÓÏî")||(AdmType=="TEAMOrd")||(GADM==""))
		{
			if (sLableAdd) sLableAdd.style.visibility = "hidden";
		}
		
		//if (sLable) sLable.onclick = Delete_Click;
	}
}
function SetDeleteVisable()
{
	for (var j=1;j<Rows+1;j++) {
		var sLable=document.getElementById('TDeletez'+j);
		if (sLable) sLable.style.visibility = "hidden";
		var sLable=document.getElementById('TDeleteAddAmountz'+j);
		if (sLable) sLable.style.visibility = "hidden";
	}
}
function DeleteAddAmount_Click()
{
	if (!confirm(t["DeleteAdd"])) return false;
	var eSrc=window.event.srcElement;
	var rowObj=getRow(eSrc);
	var selectrow=rowObj.rowIndex;
	var encmeth=document.getElementById("DeleteBox");
	if (encmeth) encmeth=encmeth.value;
	var AdmID,AdmType,OrdSetID,OrdItemID
	AdmType=document.getElementById("AdmType")
	AdmType=AdmType.value;
	if (AdmType=="PERSONOrd")
	{
		AdmType="PERSON"
	}
	else if(AdmType=="TEAMOrd")
	{
		AdmType="TEAM"
	}
	OrdItemID=document.getElementById("TRowIdz"+selectrow);
	if (OrdItemID) OrdItemID=OrdItemID.value;
	AdmID=OrdItemID.split("||");
	AdmID=AdmID[0]
	OrdSetID=""
	//alert(AdmID+"^"+AdmType+"^"+OrdItemID+"^"+OrdSetID);
	var flag=cspRunServerMethod(encmeth,AdmID,AdmType,OrdItemID,OrdSetID,"1");
	if ((flag==1)||(flag==2)||(flag==3))
    {
	    alert(t[flag]);
	    return false;
    }
	window.location.reload();
}
function Delete_Click()
{
	var eSrc=window.event.srcElement;
	var rowObj=getRow(eSrc);
	var selectrow=rowObj.rowIndex;
	var encmeth=document.getElementById("DeleteBox");
	if (encmeth) encmeth=encmeth.value;
	var AdmID,AdmType,OrdSetID,OrdItemID
	AdmType=document.getElementById("AdmType")
	AdmType=AdmType.value;
	if (AdmType=="PERSONOrd")
	{
		AdmType="PERSON"
	}
	else if(AdmType=="TEAMOrd")
	{
		AdmType="TEAM"
	}
	OrdItemID=document.getElementById("TRowIdz"+selectrow);
	if (OrdItemID) OrdItemID=OrdItemID.value;
	AdmID=OrdItemID.split("||");
	AdmID=AdmID[0]
	OrdSetID=""
	//alert(AdmID+"^"+AdmType+"^"+OrdItemID+"^"+OrdSetID);
	var flag=cspRunServerMethod(encmeth,AdmID,AdmType,OrdItemID,OrdSetID,"0");
	if ((flag==1)||(flag==2)||(flag==3))
    {
	    alert(t[flag]);
	    return false;
    }
	window.location.reload();
}
function GetTotalRows() {
	var eSrc=window.event.srcElement;
	var objtbl=document.getElementById('tDHCPEPreItemList_List');	
	if (objtbl) { var rows=objtbl.rows.length; }
	return rows-1
}
function SetRecLocDisabled()
{
	for (var j=1;j<Rows+1;j++) {
		var sLable=document.getElementById('TRecLocz'+j);
		if (sLable) sLable.disabled = true;
		var sLable=document.getElementById('TSpecNamez'+j);
		if (sLable) sLable.disabled = true;
	}
}
function SetChoiceRecLoc()
{
	for (var j=1;j<Rows+1;j++) {
		var sLable=document.getElementById('TRecLocz'+j);
		obj=document.getElementById('TItemStatz'+j);
		var ItemStat=4;
		if (obj) ItemStat=obj.value;
		if (ItemStat==1)
		{
			if (sLable) sLable.onkeydown = ChoiceRecLoc;
		}
		else
		{
			if (sLable) sLable.disabled=true;
		}
		sLable=document.getElementById('TSpecNamez'+j);
		obj=document.getElementById('TItemIdz'+j);
		
		var ItemID="";
		if (obj) ItemID=obj.value;
		if ((ItemID!="")&&(ItemStat==1))
		{
			if (sLable) sLable.onkeydown = ChoiceSpecName;
		}
		else
		{
			if (sLable) sLable.disabled=true;
		}
	}
}
function ChoiceRecLoc()
{
	if (event.keyCode==13)
	{
		var eSrc=window.event.srcElement;
		payModeName=eSrc.id;
		row=payModeName.substr(8,payModeName.length)
		if (row==0) return;
		var obj=document.getElementById('TItemIdz'+row);
		var ItemID="";
		if (obj) ItemID=obj.value;
		var obj=document.getElementById('PAADM');
		var PAADM=""
		if (obj) PAADM=obj.value;
		var url='websys.lookup.csp';
		url += "?ID=&CONTEXT=K"+"web.DHCOPItemMast:AIMRecLoc";
		url += "&TLUJSF=SetRecLoc";
		url += "&P1="+PAADM+"&P2="+ItemID;
		websys_lu(url,1,"");
		return websys_cancel();
	}

}
function SetRecLoc(value)
{
	var RecStr=value.split("^");
	var LocID=RecStr[1];
	var obj=document.getElementById('TRowIdz'+row);
	if (obj) var RowID=obj.value;
	obj=document.getElementById('UpdateRecLoc');
	if (obj) var encmeth=obj.value;
	obj=document.getElementById("AdmType")
	if (obj) var AdmType=obj.value;
	if (AdmType=="PERSONOrd")
	{
		AdmType="PERSON"
	}
	else if(AdmType=="TEAMOrd")
	{
		AdmType="TEAM"
	}
	var Flag=cspRunServerMethod(encmeth,LocID,RowID,AdmType)
	if (Flag!=0)
	{
		alert(Flag);
		return;
	}
	var obj=document.getElementById('TRecLocz'+row);
	if (obj) obj.value=RecStr[0];
}

function ChoiceSpecName()
{
	if (event.keyCode==13)
	{
		var eSrc=window.event.srcElement;
		payModeName=eSrc.id;
		row=payModeName.substr(10,payModeName.length)
		if (row==0) return;
		var obj=document.getElementById('TItemIdz'+row);
		var ItemID="";
		if (obj) ItemID=obj.value;
		if (ItemID=="") return;
		var url='websys.lookup.csp';
		url += "?ID=&CONTEXT=K"+"web.DHCPE.BarPrint:SerchSpecName";
		url += "&TLUJSF=SetSpecName";
		url += "&P1="+ItemID;
		websys_lu(url,1,"");
		return websys_cancel();
	}

}
function SetSpecName(value)
{
	var RecStr=value.split("^");
	var SpecID=RecStr[0];
	var SpecName=RecStr[1];
	var obj=document.getElementById('TRowIdz'+row);
	if (obj) var RowID=obj.value;
	obj=document.getElementById('UpdateSpecName');
	if (obj) var encmeth=obj.value;
	obj=document.getElementById("AdmType")
	if (obj) var AdmType=obj.value;
	if (AdmType=="PERSONOrd")
	{
		AdmType="PERSON"
	}
	else if(AdmType=="TEAMOrd")
	{
		AdmType="TEAM"
	}
	var Flag=cspRunServerMethod(encmeth,SpecID+"^"+SpecName,RowID,AdmType)
	if (Flag!=0)
	{
		alert(Flag);
		return;
	}
	var obj=document.getElementById('TSpecNamez'+row);
	if (obj) obj.value=SpecName;
}

document.body.onload = InitMe;