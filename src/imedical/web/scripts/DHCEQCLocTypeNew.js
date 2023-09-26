/// 描述:新科室类型设置
/// DHCEQCLocTypeNew.js
var SelectedRow = 0;
var rowid=0;

//装载页面  函数名称固定
function BodyLoadHandler()
{
	//document.body.scroll="no";
	InitEvent();			//初始化
	disabled(true);
	KeyUp("ManageUser","N");  							//add by kdf 2018-03-7 需求号：548401
	Muilt_LookUp("ManageUser^Title1^Title2^Title3");    //modified by kdf 2018-3-7 需求号：548401
}

function InitEvent()
{
	var obj=document.getElementById("BUpdate");
	if (obj) obj.onclick=BUpdate_Click;
	
	var obj=document.getElementById("BFind");
	if (obj) obj.onclick=BFind_Click;
	var obj=document.getElementById("BClear");
	if (obj) obj.onclick=BClear_Click;
	var obj=document.getElementById("Title1");
	if (obj) obj.onchange=Title1_changehandler;
	var obj=document.getElementById("Title2");
	if (obj) obj.onchange=Title2_changehandler;
	var obj=document.getElementById("Title3");
	if (obj) obj.onchange=Title3_changehandler;
}

function BUpdate_Click()
{
	if (condition()) return;
	if ((GetElementValue("LocDR")!=GetElementValue("RowID"))||(GetElementValue("LocDR")==""))
	{
		alertShow("科室发生变动或异常.请重新设置!");
		return;
	}
	var encmeth=GetElementValue("GetUpdate");
	if (encmeth=="") return;
	var plist=CombinData();
	var result=cspRunServerMethod(encmeth,plist);
	if (result>0)
	{
		location.reload();
	}
	else
	{
		alertShow("操作发生异常!");
	}
}

function BClear_Click()
{
	Clear();
	disabled(true);
}

function BFind_Click()
{
	var val="&QXType="+GetElementValue("QXType");
	var AllLocFlag=GetChkElementValue("AllLocFlag");
	if (AllLocFlag==true) AllLocFlag="Y";
	if (AllLocFlag==false) AllLocFlag="N";
	val=val+"&AllLocFlag="+AllLocFlag;
	var UnCheckFlag=GetChkElementValue("UnCheckFlag");
	if (UnCheckFlag==true) UnCheckFlag="Y";
	if (UnCheckFlag==false) UnCheckFlag="N";
	val=val+"&UnCheckFlag="+UnCheckFlag;
	val=val+"&Loc="+GetElementValue("Loc");
	val=val+"&Hospital="+GetElementValue("Hospital");
	val=val+"&Title1="+GetElementValue("Title1");
	val=val+"&GroupIDOne="+GetElementValue("GroupIDOne");
	val=val+"&Title2="+GetElementValue("Title2");
	val=val+"&GroupIDTwo="+GetElementValue("GroupIDTwo");
	val=val+"&Title3="+GetElementValue("Title3");
	val=val+"&GroupIDThree="+GetElementValue("GroupIDThree");
	//alertShow(val)
	window.location.href="websys.default.csp?WEBSYS.TCOMPONENT=DHCEQCLocTypeNew"+val;
}

function Clear()
{
	SetElement("RowID",""); 		//rowid
	SetElement("LocDR",""); 		//科室id
	SetElement("Loc","");			//科室
	SetElement("Hospital","");		//院区
	SetElement("TypeIDOne","");		//类型id1
	SetElement("GroupIDOne","");	//分组id1
	SetElement("Title1","");		//职能1
	SetElement("TypeIDTwo","");		//类型id2
	SetElement("GroupIDTwo","");	//分组id2
	SetElement("Title2","");		//职能2
	SetElement("TypeIDThree","");	//类型id3
	SetElement("GroupIDThree","");	//分组id3
	SetElement("Title3","");		//职能3
	SetElement("Remark","");
	SetElement("ManageUserDR","");
	SetElement("ManageUser","");
	SetElement("Location","");
	SetElement("Tel","");
	SetElement("Hold1","");
	SetElement("Hold2","");
	SetElement("Hold3","");
	SetElement("Hold4","");
	SetElement("Hold5","");
}

function disabled(value)//灰化
{
	InitEvent();
	DisableBElement("BUpdate",value);
}

///选择表格行触发此方法
function SelectRowHandler()
{
	var eSrc=window.event.srcElement;
	var objtbl=document.getElementById('tDHCEQCLocTypeNew');//+组件名 就是你的组件显示 Query 结果的部分
	var rows=objtbl.rows.length;
	var lastrowindex=rows - 1;
	var rowObj=getRow(eSrc);
	var selectrow=rowObj.rowIndex;
	if (!selectrow)	 return;
	if (SelectedRow==selectrow)
	{
		Clear();
		disabled(true);
		SelectedRow=0;
		rowid=0;
		SetElement("RowID","");
	}
	else
	{
		SelectedRow=selectrow;
		rowid=GetElementValue("TLocDRz"+SelectedRow);
		SetData(rowid);
		disabled(false);//反灰化
	}
}

function SetData(rowid)
{
	var encmeth=GetElementValue("GetData");
	if (encmeth=="") return;
	var gbldata=cspRunServerMethod(encmeth,"", "", rowid);
	gbldata=gbldata.replace(/\\n/g,"\n"); //"\n"转换为回车符
	//alertShow(gbldata)
	var list=gbldata.split("^");
	SetElement("RowID",list[0]); 		//rowid
	SetElement("LocDR",list[0]); 		//科室id
	SetElement("Loc",list[1]);			//科室
	SetElement("Hospital",list[2]);		//院区
	SetElement("TypeIDTwo",list[3]);	//类型id2
	SetElement("GroupIDTwo",list[4]);	//分组id2
	SetElement("Title2",list[5]);		//职能2
	SetElement("TypeIDThree",list[6]);	//类型id3
	SetElement("GroupIDThree",list[7]);	//分组id3
	SetElement("Title3",list[8]);		//职能3
	SetElement("TypeIDOne",list[9]);	//类型id1
	SetElement("GroupIDOne",list[10]);	//分组id1
	SetElement("Title1",list[11]);		//职能1
	SetElement("Remark",list[12]);
	SetElement("ManageUserDR",list[13]);
	SetElement("ManageUser",list[14]);
	SetElement("Location",list[15]);
	SetElement("Tel",list[16]);
	SetElement("Hold1",list[17]);
	SetElement("Hold2",list[18]);
	SetElement("Hold3",list[19]);
	SetElement("Hold4",list[20]);
	SetElement("Hold5",list[21]);
}

function CombinData()
{
	var combindata=GetElementValue("LocDR");//科室
  	combindata=combindata+"^"+GetElementValue("TypeIDOne");		//类型id
  	combindata=combindata+"^"+GetElementValue("GroupIDOne");	//分组id
  	combindata=combindata+"^"+GetElementValue("TypeIDTwo");
  	combindata=combindata+"^"+GetElementValue("GroupIDTwo");
	combindata=combindata+"^"+GetElementValue("TypeIDThree");
  	combindata=combindata+"^"+GetElementValue("GroupIDThree");
	combindata=combindata+"^"+GetElementValue("Remark");
	combindata=combindata+"^"+GetElementValue("ManageUserDR");
	combindata=combindata+"^"+GetElementValue("Location");
	combindata=combindata+"^"+GetElementValue("Tel");
	combindata=combindata+"^"+GetElementValue("Hold1");
	combindata=combindata+"^"+GetElementValue("Hold2");
	combindata=combindata+"^"+GetElementValue("Hold3");
	combindata=combindata+"^"+GetElementValue("Hold4");
	combindata=combindata+"^"+GetElementValue("Hold5");
  	return combindata;
}
/*
function GetLoc(value)
{
	var obj=document.getElementById("LocDR");
	var val=value.split("^");
	if (obj) obj.value=val[1];
}*/
function GetGroupIDOne(value)
{
	var obj=document.getElementById("GroupIDOne");
	var val=value.split("^");
	if (obj) obj.value=val[1];
}
function GetGroupIDTwo(value)
{
	var obj=document.getElementById("GroupIDTwo");
	var val=value.split("^");
	if (obj) obj.value=val[1];
}
//201702-04	Mozy
function GetGroupIDThree(value)
{
	var obj=document.getElementById("GroupIDThree");
	var val=value.split("^");
	if (obj) obj.value=val[1];
}
function Title1_changehandler()
{
	SetElement("GroupIDOne","")
}
function Title2_changehandler()
{
	SetElement("GroupIDTwo","")
}
//201702-04	Mozy
function Title3_changehandler()
{
	SetElement("GroupIDThree","")
}
function condition()//条件
{
	if (CheckMustItemNull()) return true;
	return false;
}
function GetManageUser(value)
{
    GetLookUpID("ManageUserDR",value);
}
document.body.onload = BodyLoadHandler;
