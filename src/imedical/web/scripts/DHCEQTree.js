///树 begin
///GetEncmeth  用于获取获得LoadData的方法
///GetParIDEncmeth   用于获取获得父ID的方法
///NodeClickHandler(nod)   点击事件激发此方法
///
///

function ReloadNode(id)
{
	var nod=new Node(id);
	if (!CheckNodeExist(id)) return;
	var haschild=0;
	var layer=nod.Layer;	
	layer=parseInt(layer)+1;
	var data=LoadData(id,layer,GetPreLine(id));
	var obj=document.getElementById("Child"+id);
	if (!obj) return;
	obj.innerHTML=data;
	if (data!="") haschild=1;
	SetExpandIcon(id,haschild,1);
}

function ShowID(id,lev)
{
	if (lev>50) return false;
	if (!CheckNodeExist(id))
	{
		var parid=1;		
		if (!ShowID(parid)) return false;
	}
	ReloadNode(id);
	return true;
}

function GetParID(id)
{
	var encmeth=GetParIDEncmeth();
	if (encmeth=="")
	{
		alertShow(t[-4001]);
		return "";
	}
	var data=cspRunServerMethod(encmeth,'','',id);
	return data;		
}

function CheckNodeExist(id)
{
	var obj=document.getElementById("Child"+id);
	if (!obj) return false;
	return true;
}

function SetExpandIcon(id,haschild,expand)
{
	var src="";
	var icon="";
	
	var obj=document.getElementById("Child"+id);
	if (!obj) return;
	if (expand)	{
		icon="M";
		obj.style.display="";}
	else{
		icon="P";
		obj.style.display="none";}		
	SetElement("HasChild"+id,haschild);
	
	var eSrc=document.getElementById("Expand"+id);
	if (!eSrc) return;
	src=eSrc.src;
	lensrc=src.length;
	
	if (haschild){
		eSrc.style.cursor="hand";	}
	else{
		eSrc.style.cursor="";
		icon="L";}
	eSrc.src=src.substring(0,lensrc-6)+icon+src.substring(lensrc-5,lensrc);
}

function ExpandTree(id)
{
	var nod=new Node(id);	
	if (nod.HasChild!="1") return;
	layer=parseInt(nod.Layer)+1;
	
	var child=document.getElementById("Child"+id);
	if (!child) return;
	
	var obj=document.getElementById("Loaded"+id);
	var data="";
	if (!obj) return;
	if (obj.value=="0")
	{data=LoadData(id,layer,GetPreLine(id));
	 obj.value="1";
	}
	else	{
		data=child.innerHTML;
	}
	
	var child=document.getElementById("Child"+id);
	if (!child) return;
	child.innerHTML=data;
	var expand=0;
	if (child.style.display=="none") expand=1;
	SetExpandIcon(id,nod.HasChild,expand);
}

function GetParentLine(id,linehtml)
{	
	var parid=GetElementValue("Parent"+id);
	if (parid==""||parid==0)
	{
		if (!document.getElementById("Link"+parid)) return linehtml;
	}
	if (GetElementValue("IsLast"+id)=="0"){
		if (linehtml=="")
		{linehtml="4";}
		else
		{linehtml="4^"+linehtml;}
	}
	else	{
		if (linehtml=="")
		{linehtml="5";}
		else
		{linehtml="5^"+linehtml;}
	}	
	return GetParentLine(parid,linehtml)
}

function GetPreLine(id)
{	
	return GetParentLine(id,"");
}

function Node(id)
{
	this.IsLast=GetElementValue("IsLast"+id);
	this.Parent=GetElementValue("Parent"+id);
	this.Loaded=GetElementValue("Loaded"+id);
	this.Layer=GetElementValue("Layer"+id);
	this.HasChild=GetElementValue("HasChild"+id);
	this.ID=GetElementValue("ID"+id);
	this.Text=GetCElementValue("Link"+id);
	if (this.Parent!="") this.ParentNode=new Node(this.Parent);		
	
}

Node.prototype.UpdateNode= function(text)
{
	SetCElement("Link"+id,text);		
}


function NodeClick(id)
{
	var nod=new Node(id);	
	NodeClickHandler(nod);
}

function LoadData(id,layer,preline)
{
	var encmeth=GetNodeIDsEncmeth();
	if (encmeth=="")
	{
		alertShow(t[-4001]);
		return "";
	}
	var ids=cspRunServerMethod(encmeth,id);
	
	//add by jdl 2009-9-10 JDL0026
	if (ids=="") return "";
	
	encmeth=GetNodeEncmeth();
	if (encmeth=="")
	{
		alertShow(t[-4001]);
		return "";
	}
	var listid=ids.split("^");
	var i=listid.length;
	var data="";
	for (var j=0;j<i;j++)
	{
		data=data+cspRunServerMethod(encmeth,id,layer,preline,listid[j]);
	}
	return data;
}

///根据Ids定位 每个节点信息用?,?分开?
///每个节点信息中包括节点的指针即相对于根节点的位置^
function FindNodeByIds(ids)
{	
	if (ids=="") return;
	var arrIdInfo=ids.split(",");
	var arrid;
	var i,j;
	for (i=0;i<arrIdInfo.length;i++)
	{		
		var tmp=arrIdInfo[i];
		arrid=tmp.split("^");
		for (j=0;j<arrid.length;j++)
		{
			var obj=document.getElementById("Child"+arrid[j]);
			if ((!obj)||(obj.style.display="none"))
			{
				ExpandTree(arrid[j]);
			}
			if ((i==arrIdInfo.length-1)&&(j==arrid.length-1))
			{
				websys_setfocus("Link"+arrid[j])
			}
		}
	}
}

///树 end
///
/*
var SelectedRow = 0;
var rowid=0;


function BodyLoadHandler() 
{
}

function NodeClickHandler(nod)
{
	alertShow(nod.IsLast);
	alertShow(nod.Parent);
	alertShow(nod.ID);
	ExpandTree(nod.ID);
}

function GetEncmeth()
{
	return GetElementValue("GetNodes");
	var nod=new Node(id);
	nod.UpdateNode(text);
}

document.body.onload = BodyLoadHandler;*/