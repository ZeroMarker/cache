var LList=document.getElementById("LList")
var RList=document.getElementById("RList")

function BodyLoadHandler()
{
	Init();
	SetElement("SaveType",2)
	initButtonWidth();	//modified by czf 20180910 HISUI改造
	//alertShow($("#SaveType").combobox('getValue'))
	//saveType_change()
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
	//var obj=document.getElementById("SaveType"); //2011-07-15 DJ
	//messageShow("","","",obj)
	//if (obj) obj.onchange=SaveType_change;
	
	//modify by lmm 2019-09-05 begin 999284
	var obj=document.getElementById("LList");
	if (obj) obj.onchange=LList_Change;
	var obj=document.getElementById("RList");
	if (obj) obj.onchange=RList_Change;
	LList.multiple=true;
	RList.multiple=true;
	//LList.Style="lbOwnerDrawFixed";
	//LList.DrawMode=OwnerDrawVariable;
	//LList.ItemHeight=5000;
	//modify by lmm 2019-09-05 end 999284
}
///add by lmm 2019-09-05 999284
///描述：左列表行号改变事件
function LList_Change()
{
	var LListids=GetSelectedList(3,"LList");
	SetElement("LListids",LListids);
}
///add by lmm 2019-09-05 999284
///描述：右列表行号改变事件
function RList_Change()
{
	var RListids=GetSelectedList(3,"RList");
	SetElement("RListids",RListids);
}
///add by lmm 2019-09-05 999284
///描述：获取列表选中信息
///入参：type 1：行id  2：行文本 3：行号
///      List：列表id
function GetSelectedList(type,List)
{
	var typeids="";
	var obj=document.getElementById(List);
	for (var i=0;i<obj.options.length;i++)
	{
		if (obj.options[i].selected!=true) continue;
		if (typeids!="") typeids=typeids+",";
		if (type==1)
		{	typeids=typeids+obj.options[i].value;}
		else if (type==2)
		{	typeids=typeids+obj.options[i].text;}
		else
		{	typeids=typeids+i;}
	}
	return typeids;
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
	//add by lmm 2019-09-05 begin  改变列表中行间距
	$('#LList option[height!="22px"]').css({"height":"22px","padding-top":"4px"})
	$('#RList option[height!="22px"]').css({"height":"22px","padding-top":"4px"})
	//add by lmm 2019-09-05 end
	//add by lmm 2019-09-19 begin 更改listbox边框色为蓝色
	$('#LList').css({"border":"1px solid #9ed2f2"})
	$('#RList').css({"border":"1px solid #9ed2f2"})
	//add by lmm 2019-09-19 end
		
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

///modify by lmm 2019-09-05 单选左移改为多选左移 999284
function Left_Click()
{
	var RListids=GetElementValue("RListids");
	var RListids=RListids.split(",")
	RListidslen=RListids.length;
	var reduce=0
	//var i=RList.selectedIndex;
	var len=RList.length;
	for (j=0;j<RListidslen;j++)
	{
		var i=RListids[j]-reduce
		if ((len>=1)&&(i<len)) 
		{
			AddItem(LList,RList.options[i].value,RList.options[i].text); //2011-07-15 DJ
			RList.remove(i);
			var reduce=reduce+1
		}
	}

}
///modify by lmm 2019-09-05 单选右移改为多选右移 999284
function Right_Click()
{
	
	var LListids=GetElementValue("LListids");
	var LListids=LListids.split(",")
	LListidslen=LListids.length;
	var reduce=0
	var len=LList.length;
	for (j=0;j<LListidslen;j++)
	{
		var i=LListids[j]-reduce
		if ((len>=1)&&(i<len)) 
		{
			if (HasSelected(RList,LList.options[i].value)==0)
			{
				AddItem(RList,LList.options[i].value,LList.options[i].text);
				LList.remove(i); //2011-07-15 DJ
				var reduce=reduce+1
			}
			else
			{
				messageShow("","","",t['exists']);
			}
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
		messageShow("","","",t['failed']+SQLCODE);
		return;
	}
	else
	{
		//modified by ZY20230309 bug:3308989
		//messageShow("","success","",t['success'])
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

 //  add by wy 	
$("#SaveType").combobox({
    onChange: function () {
	initUserInfo() //add by lmm 2018-10-26
    SetType = $("#SaveType").combobox('getValue')
	var SetID=curUserID  //modify by lmm 2018-10-26
	var SaveTypeName=""

     if ((SetType=="")||(SetType=="2"))
	{
		
		SetType=2
		SaveTypeName=curUserName  //modify by lmm 2018-10-26
		SetElement("SaveTypeName",SaveTypeName)
	
	}
	else if (SetType=="1")
	{
	
		SetID=session['LOGON.GROUPID']
		SaveTypeName=session['LOGON.GROUPDESC']
	SetElement("SaveTypeName",SaveTypeName)
	}
	else
	{
		SetID=0
		SetElement("SaveTypeName","")
	}
      
	SetElement("SaveType",SetType)
	SetElement("SetType",SetType)
	SetElement("SetID",SetID)
	SetElement("SaveTypeName",SaveTypeName)
	SetElement("Columns","")
	SetElement("ColumnsWidth","")
	FillData(SetType);
      
      
      
      }
    })
//}
/*function SaveType_change()
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
	SetElement("SaveType",SetType)
	SetElement("SetType",SetType)
	SetElement("SetID",SetID)
	SetElement("SaveTypeName",SaveTypeName)
	SetElement("Columns","")
	SetElement("ColumnsWidth","")
	FillData(SetType);
}*/

document.body.onload=BodyLoadHandler;
