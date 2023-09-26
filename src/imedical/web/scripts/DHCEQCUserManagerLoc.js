//装载页面  函数名称固定
function BodyLoadHandler() {
	/*var cobj=document.getElementById("PurposeTypes")
	cobj.multiple=false;   //多选属性
	cobj.size=1;  //多选属性为false时下拉列表框*/
	InitPage();
	ChangeStatus(false);
	InitUserInfo();
	SetListData();
	//SetLink();
}
function SetListData()
{
	var encmeth=GetElementValue("GetPurposeTypes");
	var PurposeTypes=cspRunServerMethod(encmeth);
	var OneStr=PurposeTypes.split("^");
	var j=OneStr.length;
	for (i=0;i<j;i++)
	{
		var OnePurpose=OneStr[i].split(",");
		var ID=OnePurpose[1];
		var Desc=OnePurpose[0];
		var obj=document.getElementById("PurposeTypes");
		var myListIdx=obj.length;
		obj.options[myListIdx]=new Option(Desc, ID);
	}
}
function InitPage(){
	var BAobj=document.getElementById("BAdd");
	if (BAobj) BAobj.onclick=BUpdate_click;
	var BUobj=document.getElementById("BUpdate");
	if (BUobj) BUobj.onclick=BUpdate_click;
	var BDobj=document.getElementById("BDelete");
	if (BDobj) BDobj.onclick=BDelete_click;
	
	KeyUp("User^Loc");
	Muilt_LookUp("User^Loc");
}
//点击表格项填充自由项,函数名称固定
var SelectedRow = 0;
function SelectRowHandler()	{
	var eSrc=window.event.srcElement;
	if (eSrc.tagName=="IMG") eSrc=window.event.srcElement.parentElement;
	
	var objtbl=document.getElementById('tDHCEQCUserManagerLoc'); //得到表格   t+组件名称
	
	var rows=objtbl.rows.length;
	var lastrowindex=rows - 1;
	var rowObj=getRow(eSrc);
	var selectrow=rowObj.rowIndex; //当前选择行
	if (selectrow==SelectedRow){
		SetElement("RowID","");
		Fill("^^^^^^^^^^^^^")
		SelectedRow=0;
		ChangeStatus(false);
		return;}
	ChangeStatus(true);
	FillData(selectrow)
    SelectedRow = selectrow;
}
function FillData(selectrow)
{
	var RowID=document.getElementById("TRowIDz"+selectrow).value;
	SetElement("RowID",RowID);
	var obj=document.getElementById("fillData");
	if (obj){var encmeth=obj.value} else {var encmeth=""};
	var ReturnList=cspRunServerMethod(encmeth,RowID);
	ReturnList=ReturnList.replace(/\\n/g,"\n");
	Fill(ReturnList)
}
function Fill(ReturnList)
{
	list=ReturnList.split("^");
	SetElement("RowID",list[0]);
	SetElement("UserDR",list[1]);
	SetElement("User",list[2]);
	SetElement("LocDR",list[3]);
	SetElement("Loc",list[4]);
	var PurposeStr=list[5];
  	var obj=document.getElementById("PurposeTypes");
  	var j=obj.length;
  	for (i=0;i<j;i++)
  	{
	  	var PurposeType=obj.options[i].value;
	  	obj.options[i].selected=false;
	    if ("Y"==PurposeTypeIsIn(PurposeStr,PurposeType))
	  	{
		  	obj.options[i].selected=true;
	  	}
  	}
}
function PurposeTypeIsIn(PurposeStr,PurposeType)
{
	var Purposes=PurposeStr.split(",");
	var k=Purposes.length;
	var Flag="N"
	for (m=0;m<k;m++)
	{
		if (Purposes[m]==PurposeType)
		{
			Flag="Y"
		}
		if (Flag=="Y") {break;}
	}
	return Flag
}
//更新按钮点击函数
function BUpdate_click()
{
	if (CheckNull()) return;
	var encmeth=GetElementValue("IsHad");
	var RowID=GetElementValue("RowID");
	var UserID=GetElementValue("UserDR");
	var LocID=GetElementValue("LocDR");
	var Flag=cspRunServerMethod(encmeth,UserID,LocID,RowID);
	if (Flag=="Y")
	{
		alertShow(t["03"]);
		return;
	}
	var val=GetValue();
	var Return=UpdateData(val,"0");
	if (Return!=0)
	{
		alertShow(Return+"  "+t["01"]);
	}
	else
	{
		window.location.reload();
	}
}
function GetValue()
{
	var combindata="";
  	combindata=GetElementValue("RowID") ;
  	combindata=combindata+"^"+GetElementValue("UserDR") ;
  	combindata=combindata+"^"+GetElementValue("LocDR") ;
  	var PurposeStr=""
  	var obj=document.getElementById("PurposeTypes");
  	var j=obj.length;
  	for (i=0;i<j;i++)
  	{
	  	if (obj.options[i].selected)
	  	{
		 	if (PurposeStr=="")
		 	{
			 	PurposeStr=obj.options[i].value
			 }
			 else
			 {
				 PurposeStr=PurposeStr+","+obj.options[i].value
			 }	
	  	}
  	}
  	combindata=combindata+"^"+PurposeStr ;
  	return combindata;
}
//删除按钮点击函数
function BDelete_click()
{
	var truthBeTold = window.confirm(t["02"]);
	if (!truthBeTold) return;
	var RowID=GetElementValue("RowID");
	var Return=UpdateData(RowID,"1");
	if (Return<0)
	{
		alertShow(Return+"  "+t["01"]);
	}
	else
	{
		window.location.reload();
	}
}
function CheckNull()
{
	if (CheckMustItemNull()) return true;
	/*
	if (CheckItemNull(1,"User")) return true;
	if (CheckItemNull(1,"Loc")) return true;
	if (CheckItemNull(2,"PurposeTypes")) return true;
	*/
	return false;
}
function UpdateData(val,AppType)
{
	var encmeth=GetElementValue("upd");
	var Return=cspRunServerMethod(encmeth,val,AppType);
	return Return;
}

function GetUser(value) {
	var user=value.split("^");
	var obj=document.getElementById("UserDR");
	obj.value=user[1];
}
function GetLoc(value) {
	var user=value.split("^");
	var obj=document.getElementById("LocDR");
	obj.value=user[1];
}
function ChangeStatus(Value)
{
	InitPage();
	DisableBElement("BUpdate",!Value);
	DisableBElement("BDelete",!Value);
	DisableBElement("BAdd",Value);
}

//定义页面加载方法
document.body.onload = BodyLoadHandler;