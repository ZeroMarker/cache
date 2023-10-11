function BodyLoadHandler() 
{
	InitUserInfo();
	var EquipDRs=GetElementValue("EquipDRs")
	FindNodeByEquipDR(EquipDRs);
}

Node.prototype.UpdateNode= function(text)
{
	SetCElement("Link"+EquipDR,text);
}

///树 begin
///GetEncmeth  用于获取获得LoadData的方法
///GetParIDEncmeth   用于获取获得父ID的方法
///NodeClickHandler(nod)   点击事件激发此方法
function ShowID(EquipDR,lev)
{
	if (lev>50) return false;
	if (!CheckNodeExist(EquipDR))
	{
		var parid=1;
		if (!ShowID(parid)) return false;
	}
	ReloadNode(EquipDR);
	return true;
}
function CheckNodeExist(EquipDR)
{
	var obj=document.getElementById("Child"+EquipDR);
	if (!obj) return false;
	return true;
}
function ReloadNode(EquipDR)
{
	var nod=new Node(EquipDR);
	if (!CheckNodeExist(EquipDR)) return;
	var haschild=0;
	var layer=nod.Layer;	
	layer=parseInt(layer)+1;
	var data=LoadData(EquipDR,layer,GetPreLine(EquipDR));
	var obj=document.getElementById("Child"+EquipDR);
	if (!obj) return;
	obj.innerHTML=data;
	if (data!="") haschild=1;
	SetExpandIcon(EquipDR,haschild,1);
}

function Node(EquipDR)
{
	this.IsLast=GetElementValue("IsLast"+EquipDR);
	this.Parent=GetElementValue("Parent"+EquipDR);
	this.Loaded=GetElementValue("Loaded"+EquipDR);
	this.Layer=GetElementValue("Layer"+EquipDR);
	this.HasChild=GetElementValue("HasChild"+EquipDR);
	this.ID=GetElementValue("ID"+EquipDR);
	this.Text=GetCElementValue("Link"+EquipDR);
	if (this.Parent!="") this.ParentNode=new Node(this.Parent);
}
function NodeClick(EquipDR)
{
	var nod=new Node(EquipDR);
	NodeClickHandler(nod);
}
function NodeClickHandler(nod)
{
	var lnk='websys.default.hisui.csp?WEBSYS.TCOMPONENT=DHCEQAssociated&ParEquipDR='+nod.ID+"&ReadOnly="+getElementValue("ReadOnly");
	if ('function'==typeof websys_getMWToken){
		lnk += "&MWToken="+websys_getMWToken()
	}
	parent.frames["DHCEQAssociated"].location.href=lnk;
}
function LoadData(EquipDR,layer,preline)
{
	if (EquipDR==0)
	{
		var meth=GetElementValue("RootEquipDR");
		var ParEquipDR=GetElementValue("ParEquipDR");
		ParEquipDR=cspRunServerMethod(meth,ParEquipDR);
	}
	var encmeth=GetElementValue("GetTreeNodeEquipDRs");
	if (encmeth=="")
	{
		alertShow(t[-4001]);
		return "";
	}
	var ChildEquipDRs=cspRunServerMethod(encmeth,EquipDR,ParEquipDR);
	var listChildEquipDR=ChildEquipDRs.split("^");
	
	var i=listChildEquipDR.length;
	var data="";
	encmeth=GetElementValue("GetTreeNode");
	if (encmeth=="")
	{
		alertShow(t[-4001]);
		return "";
	}
	for (var j=0;j<i;j++)
	{
		//alertShow("parEquipDR="+EquipDR+",layer="+layer+",preline="+preline+",listChildEquipDR["+j+"]="+listChildEquipDR[j])
		data=data+cspRunServerMethod(encmeth,EquipDR,layer,preline,listChildEquipDR[j]);
	}
	
	return data;
}

///根据EquipDRs定位 每个节点信息用","分开
///每个节点信息中包括节点的指针即相对于根节点的位置^
function FindNodeByEquipDR(EquipDRs)
{	
	if (EquipDRs=="") return;
	var arrDRInfo=EquipDRs.split(",");
	var arrDR;
	var i,j;
	for (i=0;i<arrDRInfo.length;i++)
	{		
		var tmp=arrDRInfo[i];
		arrDR=tmp.split("^");
		for (j=0;j<arrDR.length;j++)
		{
			var obj=document.getElementById("Child"+arrDR[j]);
			if ((!obj)||(obj.style.display="none"))
			{
				ExpandTree(arrDR[j]);
			}
			if ((i==arrDRInfo.length-1)&&(j==arrDR.length-1))
			{
				websys_setfocus("Link"+arrDR[j])
			}
		}
	}
}
function ExpandTree(EquipDR)
{
	var nod=new Node(EquipDR);
	if (nod.HasChild!="1") return;
	layer=parseInt(nod.Layer)+1;
	var child=document.getElementById("Child"+EquipDR);
	if (!child) return;
	
	var obj=document.getElementById("Loaded"+EquipDR);
	var data="";
	if (!obj) return;
	if (obj.value=="0")
	{
		data=LoadData(EquipDR,layer,GetPreLine(EquipDR));
	 	obj.value="1";
	}
	else
	{
		data=child.innerHTML;
	}
	
	var child=document.getElementById("Child"+EquipDR);
	if (!child) return;
	child.innerHTML=data;
	var expand=0;
	if (child.style.display=="none") expand=1;
	SetExpandIcon(EquipDR,nod.HasChild,expand);
}
function SetExpandIcon(EquipDR,haschild,expand)
{
	var src="";
	var icon="";
	
	var obj=document.getElementById("Child"+EquipDR);
	if (!obj) return;
	if (expand)
	{
		icon="M";
		obj.style.display="";
	}
	else
	{
		icon="P";
		obj.style.display="none";
	}
	SetElement("HasChild"+EquipDR,haschild);
	
	var eSrc=document.getElementById("Expand"+EquipDR);
	if (!eSrc) return;
	src=eSrc.src;
	lensrc=src.length;
	
	if (haschild)
	{
		eSrc.style.cursor="hand";
	}
	else
	{
		eSrc.style.cursor="";
		icon="L";
	}
	eSrc.src=src.substring(0,lensrc-6)+icon+src.substring(lensrc-5,lensrc);
}

function GetPreLine(EquipDR)
{	
	return GetParentLine(EquipDR,"");
}
function GetParentLine(EquipDR,linehtml)
{	
	var parid=GetElementValue("Parent"+EquipDR);
	if (parid==""||parid==0)
	{
		if (!document.getElementById("Link"+parid)) return linehtml;
	}
	if (GetElementValue("IsLast"+EquipDR)=="0")
	{
		if (linehtml=="")
		{	linehtml="4";	}
		else
		{	linehtml="4^"+linehtml;	}
	}
	else
	{
		if (linehtml=="")
		{	linehtml="5";	}
		else
		{	linehtml="5^"+linehtml;	}
	}	
	return GetParentLine(parid,linehtml)
}

document.body.onload = BodyLoadHandler;