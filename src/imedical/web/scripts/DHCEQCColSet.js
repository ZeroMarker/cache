var LList=document.getElementById("LList")
var RList=document.getElementById("RList")

function BodyLoadHandler()
{
	Init();
	SetElement("SaveType",2)
	SaveType_change()
}

function Init()
{
	var obj=document.getElementById("Down");
	if (obj) obj.onclick=Down_Click;
	var obj=document.getElementById("Up");
	if (obj) obj.onclick=Up_Click;
	var obj=document.getElementById("Left");
	if (obj) obj.onclick=Left_Click;
	var obj=document.getElementById("Right");
	if (obj) obj.onclick=Right_Click;
	var obj=document.getElementById("BSave");
	if (obj) obj.onclick=BSave_Click;
	var obj=document.getElementById("RList"); //2011-07-15 DJ
	if (obj) obj.onclick=RList_Click;
	var obj=document.getElementById("SaveType"); //2011-07-15 DJ
	if (obj) obj.onchange=SaveType_change;
	
	LList.multiple=false;
	RList.multiple=false;
}

function FillData(SetType)
{
	var encmeth=GetElementValue("GetFillLeft");
	var vdata=cspRunServerMethod(encmeth,GetElementValue("TableID"),SetType);
	for (i=LList.options.length; i>0; i--) //清空原始数据
	{
		LList.remove(i-1);
	}
	FillListBox(LList,vdata);
	var encmeth=GetElementValue("GetFillRight");
	var vdata=cspRunServerMethod(encmeth,GetElementValue("TableID"),SetType,0);
	for (i=RList.options.length; i>0; i--) //清空原始数据
	{
		RList.remove(i-1);
	}
	FillListBox(RList,vdata);	
}

function FillListBox(lst,vdata)
{
	if (!lst) return;
	if (vdata=="") return;
	var arrlist=vdata.split("&");
	var rows=arrlist.length;
	
	for (i=0;i<rows;i++)
	{
		var listinfo=arrlist[i].split("^");
		AddItem(lst,listinfo[0],listinfo[1]);
	}
}

function AddItem(lst,id,text)
{
	lst.options[lst.options.length] = new Option(text,id);
}

function Down_Click()
{
	var i=RList.selectedIndex;
	var len=RList.length;
	if ((len>1)&&(i<(len-1))) {
		Swap(i,i+1)
	 }
}

function Up_Click()
{
	var i=RList.selectedIndex;
	var len=RList.length;
	if ((len>1)&&(i<len)) 
	{
		Swap(i,i-1)
	}
}

function Left_Click()
{
	var i=RList.selectedIndex;
	var len=RList.length;
	if ((len>=1)&&(i<len)) 
	{
		AddItem(LList,RList.options[i].value,RList.options[i].text); //2011-07-15 DJ
		RList.remove(i);
	}
}

function Right_Click()
{
	var i=LList.selectedIndex;
	var len=LList.length;
	if ((len>=1)&&(i<len)) 
	{
		if (HasSelected(RList,LList.options[i].value)==0)
		{
			AddItem(RList,LList.options[i].value,LList.options[i].text);
			LList.remove(i); //2011-07-15 DJ
		}
		else
		{
			alertShow(t['exists']);
		}
	}
}

function BSave_Click()
{
	var TableName=GetElementValue("TableName")
	var SetType=GetElementValue("SetType")
	var SetID=GetElementValue("SetID")
	var Data=""
	
	var len=RList.length;
	//if (len<1) return "";
	var SaveType=GetElementValue("SaveType")
	var truthBeTold=true
	if (SaveType=="0")
	{
		var truthBeTold=window.confirm("确定修改系统导出列设置?");
	}
	else if (SaveType=="1")
	{
		var truthBeTold=window.confirm("确定修改["+GetElementValue("SaveTypeName")+"]安全组导出列设置?");
	}
	else if (SaveType=="")
	{
		alertShow("请选择列设置保存类型!")
		return
	}
	if (!truthBeTold) return ""
	for (i=0;i<len;i++)
	{
		if (Data!="") Data=Data+"&";
		var ColWidth=""
		var ColFlag=""
		if (RList.options[i].text==GetElementValue("Columns"))
		{
			ColWidth=GetElementValue("ColumnsWidth")
			ColFlag=1
		}
		Data=Data+RList[i].value+"^"+ColWidth+"^"+ColFlag;
	}
	var encmeth=GetElementValue("GetUpdate");
	var SQLCODE=cspRunServerMethod(encmeth,TableName,SetType,SetID,Data);
	if (SQLCODE!="0")
	{
		alertShow(t['failed']+SQLCODE);
		return;
	}
	else
	{
		alertShow(t['success'])
		location.reload();
	}
}

function Swap(a,b) {
	var opta=RList[a];
	var optb=RList[b];
	RList[a]= new Option(optb.text,optb.value);
	RList[a].style.color=optb.style.color;
	RList[a].style.backgroundColor=optb.style.backgroundColor;
	RList[b]= new Option(opta.text,opta.value);
	RList[b].style.color=opta.style.color;
	RList[b].style.backgroundColor=opta.style.backgroundColor;
	RList.selectedIndex=b;
}

function HasSelected(lst,val)
{
	var len=lst.length;
	if (len<1) return 0;
	
	for (i=0;i<len;i++)
	{
		if (lst[i].value==val) return 1
	}
	return 0;
}

function RList_Click()
{
	var i=RList.selectedIndex;
	var len=RList.length;
	if ((len>=1)&&(i<len)) 
	{
		SetElement("Columns",RList.options[i].text)
		var encmeth=GetElementValue("GetColSetWidth");
		var ColumnsWidth=cspRunServerMethod(encmeth,GetElementValue("TableID"),GetElementValue("SetType"),GetElementValue("SetID"),RList.options[i].value);
		SetElement("ColumnsWidth",ColumnsWidth)
	}
}

function SaveType_change()
{
	var SetType=GetElementValue("SaveType")
	var SetID=curUserID
	var SaveTypeName=""
	if ((SetType=="")||(SetType=="2"))
	{
		SetType=2
		SaveTypeName=curUserName
	}
	else if (SetType=="1")
	{
		SetID=session['LOGON.GROUPID']
		SaveTypeName=session['LOGON.GROUPDESC']
	}
	else
	{
		SetID=0
	}
	SetElement("SetType",SetType)
	SetElement("SetID",SetID)
	SetElement("SaveTypeName",SaveTypeName)
	SetElement("Columns","")
	SetElement("ColumnsWidth","")
	FillData(SetType);
}

document.body.onload=BodyLoadHandler;