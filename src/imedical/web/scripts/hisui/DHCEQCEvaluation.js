// DHCEQCUserRole.js
var SelectedRow = -1;
var SelectRow = 0;
var rowid=0;
var rows;
function BodyLoadHandler()
{
	initButtonWidth()  //hisui改造 add by kdf 2018-10-16
	InitUserInfo();
	InitEvent();
	disabled(true);
//add by HHM 20150909 HHM0014
//控制独立标志、评价标志默认选中
	SetChkElement("IndependentFlag",1);
	SetChkElement("EvaluationFlag",1);
}
function InitEvent()
{
	var obj=document.getElementById("EvaluationOrder");
	if (obj) obj.onchange=EvaluationOrder_Change;
	var obj=document.getElementById("BAdd");
	if (obj) obj.onclick=BAdd_Click;
	var obj=document.getElementById("BUpdate");
	if (obj) obj.onclick=BUpdate_Click;
	var obj=document.getElementById("BDelete");
	if (obj) obj.onclick=BDelete_Click;
	
//add by HHM 20150901 HHM0014
//添加复选框选择控制
//*******************************************
	var obj=document.getElementById("MPEvaluationFlag");
	if (obj) obj.onclick=MPEvaluationFlage_CheckClick;
	var obj=document.getElementById("IndependentFlag");
	if (obj) obj.onclick=IndependentFlag_CheckClick;
//************************************************
	Muilt_LookUp("SourceType^Role^EquipType^Hospital");
	KeyUp("SourceType^Role^EquipType^Hospital","N");
}
function EvaluationOrder_Change()
{
	var EvaluationOrder=GetElementValue("EvaluationOrder");
	if (!(parseInt(EvaluationOrder)==EvaluationOrder))
  	{
   		 alertShow("评价顺序请填写整数");
   		 SetElement("EvaluationOrder","");
   		 return;
  	}
}
function BAdd_Click() //增加
{
	var SourceTypeDR=GetElementValue("SourceTypeDR");
	var RoleDR=GetElementValue("RoleDR");
	var EvaluationOrder=GetElementValue("EvaluationOrder");
	if (SourceTypeDR=="")
	{
		alertShow("请选择业务类型!")
		return
	}
	if (RoleDR=="")
	{
		alertShow("请选择角色!")
		return
	}
	if (EvaluationOrder=="")
	{
		alertShow("请输入评价顺序!")
		return
	}
//add by HHM 20150908 HHM0014
//检查同业务评价顺序不能重复
	var Flag=CheckedEvaluationOrder();
	if(Flag==1) return;
//*********************************
	if(condition()) return;
	var encmeth=GetElementValue("GetUpdate");
	if (encmeth==""){return;}
	var plist=CombinData(); //函数调用
	var result=cspRunServerMethod(encmeth,plist,'0');
	result=result.replace(/\\n/g,"\n");
	if (result>0) 
	{
		location.reload();	
	}
	else
	{
		messageShow("","","",t[result]);
	}
}
function BUpdate_Click() 
{
	var SourceTypeDR=GetElementValue("SourceTypeDR");
	var RoleDR=GetElementValue("RoleDR");
	var EvaluationOrder=GetElementValue("EvaluationOrder");
	if (SourceTypeDR=="")
	{
		alertShow("请选择业务类型!")
		return
	}
	if (RoleDR=="")
	{
		alertShow("请选择角色!")
		return
	}
	if (EvaluationOrder=="")
	{
		alertShow("请输入评价顺序!")
		return
	}
//add by HHM 20150908 HHM0014
//检查评价组输入是否重复
	var Flag=CheckedEvaluationOrder()
	if(Flag==1) return;
//**********************************
	var encmeth=GetElementValue("GetUpdate");
	if (encmeth=="") return;	
	var plist=CombinData(); //函数调用
	var result=cspRunServerMethod(encmeth,plist,'0');
	result=result.replace(/\\n/g,"\n");
	if (result>0)
	{
		location.reload();	
	}
	else
	{
		messageShow("","","",t[result]);
	}
}
//add by HHM 20150901 HHM0014
//添加复选框选择控制
function MPEvaluationFlage_CheckClick()
{
	var obj=document.getElementById("MPEvaluationFlag");
	if (obj.checked==true)
	{
		SetChkElement("IndependentFlag",1);	
	}
	
}
function IndependentFlag_CheckClick()
{
	var obj=document.getElementById("IndependentFlag");
	if (obj.checked==false)
	{
		SetChkElement("MPEvaluationFlag",0);	
	}	
}
//********************************************************
function CombinData()
{
	var combindata="";
    combindata=GetElementValue("RowID");//1
	combindata=combindata+"^"+GetElementValue("SourceTypeDR");//来源类型
  	combindata=combindata+"^"+GetElementValue("RoleDR");//用户
  	combindata=combindata+"^"+GetElementValue("HospitalDR");//医院
  	combindata=combindata+"^"+GetElementValue("EquipTypeDR");//类组
  	combindata=combindata+"^"+GetChkElementValue("EvaluationFlag");//评价标志
  	combindata=combindata+"^"+GetElementValue("CheckClass");//查看级别
  	combindata=combindata+"^"+GetElementValue("EvaluationOrder");//评价顺序
  	combindata=combindata+"^"+GetElementValue("MPEvaluationFlag");//评价标志
  	combindata=combindata+"^"+GetElementValue("IndependentFlag");//独立标志
  	combindata=combindata+"^"+GetElementValue("hold1");//
  	combindata=combindata+"^"+GetElementValue("hold2");//
  	combindata=combindata+"^"+GetElementValue("hold3");//
  	combindata=combindata+"^"+GetElementValue("hold4");//
  	combindata=combindata+"^"+GetElementValue("hold5");//  	
  	return combindata;
}

function EquipTypeDR(value) //
{
	//messageShow("","","",value);
	var obj=document.getElementById("EquipTypeDR");
	var val=value.split("^");	
	if (obj) obj.value=val[1];
	//messageShow("","","",val[1]+"/"+val[2]);
}
function BDelete_Click()
{
	rowid=GetElementValue("RowID");
	var truthBeTold = window.confirm(t[-4003]);
    if (!truthBeTold) return;
	var encmeth=GetElementValue("GetUpdate");
	if (encmeth=="") {return;}
	var result=cspRunServerMethod(encmeth,rowid,'1');
	result=result.replace(/\\n/g,"\n");
	if (result>0) location.reload();	
	else
	{
		messageShow("","","",t[result]);
	}
}
///选择表格行触发此方法
// modified by kdf 2018-10-17 hisui-改造
//modify by wl 2020-02-18 WL0049删除不合适的默认控制
function SelectRowHandler(index,rowdata)
{
	if (SelectedRow==index)
	{
		Clear();
		disabled(true)//灰化
		SelectedRow=-1;
		$('#tDHCEQCEvaluation').datagrid('unselectAll');  //hisui改造 add by kdf 2018-10-17
		rowid=0;
		SetElement("RowID","");
//add by HHM 20150909 HHM0014
//控制独立标志、评价标志默认选中
		SetChkElement("EvaluationFlag",1);
	}
	else
	{
		SelectedRow=index;
		rowid=rowdata.TRowID ; 
		SetData(rowid);//调用函数
		disabled(false)//反灰化
	}
}

function disabled(value)
{
	InitEvent();
	DisableBElement("BAdd",!value);
	DisableBElement("BUpdate",value);
	DisableBElement("BDelete",value);
}
function Clear()
{
	SetElement("RowID","");
	SetElement("SourceTypeDR","");
	SetElement("SourceType","");
	SetElement("RoleDR","");
	SetElement("Role","");
	SetElement("HospitalDR","");
	SetElement("Hospital","");
	SetElement("EquipTypeDR","");
	SetElement("EquipType","");
	SetElement("EvaluationFlag","");
	SetElement("EvaluationOrder","");
	SetElement("MPEvaluationFlag","");
	SetElement("IndependentFlag","");
}

function SetData(rowid)
{
	var encmeth=GetElementValue("GetData");
	if (encmeth==""){return;}
	var gbldata=cspRunServerMethod(encmeth,rowid);
	gbldata=gbldata.replace(/\\n/g,"\n");
	//alertShow("gbldata="+gbldata);
	var list=gbldata.split("^");
	var sort=17+1    // hisui-改造 modified by kdf 2018-10-17
	SetElement("RowID",list[0]);//rowid
	SetElement("SourceTypeDR",list[1]);
	SetElement("SourceType",list[sort+0]); //来源类型1
	
	SetElement("RoleDR",list[2]);
	SetElement("Role",list[sort+1]);
	
	SetElement("HospitalDR",list[3]);
	SetElement("Hospital",list[sort+2]);
	
	SetElement("EquipTypeDR",list[4]);
	SetElement("EquipType",list[sort+3]);
	
	SetElement("EvaluationOrder",list[7]);
	SetElement("CheckClass",list[6]);
	
	if (list[5]=="0")   //modify by wl 2020-02-18 WL0049
	{	SetChkElement("EvaluationFlag",0);	}
	else
	{	SetChkElement("EvaluationFlag",1);	}
	
	if (list[8]=="N")
	{	SetChkElement("MPEvaluationFlag",0);	}
	else
	{	SetChkElement("MPEvaluationFlag",1);	}
	if (list[9]=="N")
	{	SetChkElement("IndependentFlag",0);	}
	else
	{	SetChkElement("IndependentFlag",1);	}
	
	
}

function GetRole(value)
{
	//messageShow("","","",value)
	var type=value.split("^");
	var obj=document.getElementById("RoleDR");
	obj.value=type[1];
}
function GetBussType(value)
{
	var type=value.split("^");
	var obj=document.getElementById("SourceTypeDR");
	obj.value=type[1];
}

function Source_keydown()
{
	if (event.keyCode==13)
	{
		Source_Click();
	}
}
function Source_Click()
{
	//messageShow("","","",GetElementValue("SourceType"));
	if (GetElementValue("SourceType")==2) //安全组
	{
		LookUpGroup("GetSourceDR","Source");
	}
	if (GetElementValue("SourceType")==1) //用户名
	{
		LookUpCTUser("GetSourceDR","Source");
	}
}
function GetHospital(value)
{
	///messageShow("","","",value);
	var obj=document.getElementById("HospitalDR");
	var val=value.split("^");	
	if (obj) obj.value=val[1];
}
function condition()//条件
{
	if (CheckMustItemNull()) return true;
	return false;
}
///判断评价顺序是否有重复，返回值: 0 无重复   1 有重复
function CheckedEvaluationOrder()
{
	var EvaluationOrder=GetElementValue("EvaluationOrder");
	var SourceTypeDR=GetElementValue("SourceTypeDR");
	if (EvaluationOrder=="")        //add by czf 2016-10-10  需求号：266040
	{
		alertShow("请填写评价顺序");
		return 1
	}
	if (!(parseInt(EvaluationOrder)==EvaluationOrder))
  	{
   		 alertShow("评价顺序请填写整数");
   		 return 1
  	}
    var rowid=GetElementValue("RowID");
    //messageShow("","","",rowid);
    var encmeth=GetElementValue("CheckedEvaluationOrder")
    var result=cspRunServerMethod(encmeth,SourceTypeDR,EvaluationOrder,rowid);
    result=result.replace(/\\n/g,"\n");
  	//messageShow("","","",result);
    if (result==1)
    {
	    alertShow("评价顺序有重复,请确认!");
	    return 1;
    }
    return 0;
}
document.body.onload = BodyLoadHandler;