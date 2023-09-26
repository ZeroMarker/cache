// DHCEQCUserRole.js
var SelectedRow = 0;
var SelectRow = 0;
var rowid=0;
var rows;
function BodyLoadHandler()
{
	InitUserInfo();
	InitEvent();
	disabled(true);
	SetElement("ItemScore","5"); 
}
function InitEvent()
{
	var obj=document.getElementById("BAdd");
	if (obj) obj.onclick=BAdd_Click;
	var obj=document.getElementById("BUpdate");
	if (obj) obj.onclick=BUpdate_Click;
	var obj=document.getElementById("BDelete");
	if (obj) obj.onclick=BDelete_Click;

}
function BAdd_Click() //增加
{
	var Flag=CheckShowOrder();
	if (Flag==-1) {return;}
	var encmeth=GetElementValue("GetUpdate");
	if (encmeth==""){return;}
	var plist=CombinData(); //函数调用
	var result=cspRunServerMethod(encmeth,plist,'0');
	result=result.replace(/\\n/g,"\n");
	if (result>0) 
	{   
	    alertShow("新增成功")     //add by wy 2018-1-16
		location.reload();	
	}
	else
	{
		alertShow(t[result]);
		return;
	}
}
function BUpdate_Click() 
{
	var Flag=CheckShowOrder();
	if (Flag==-1) {return;}
	var encmeth=GetElementValue("GetUpdate");
	if (encmeth=="") return;	
	var plist=CombinData(); //函数调用
	var result=cspRunServerMethod(encmeth,plist,'0');
	result=result.replace(/\\n/g,"\n");
	if (result>0) 
	{   
	    alertShow("更新成功")     //add by wy 2018-1-16
		location.reload();	
	}
	else
	{
		alertShow(t[result]);
	}
}
function CheckShowOrder()
{
	var ShowOrder=GetElementValue("ShowOrder");
	if (ShowOrder=="")             //add by czf 2016-10-10 需求号：266040
	{
		alertShow("请填写显示顺序");
		return -1;
	}
	if (!(parseInt(ShowOrder)==ShowOrder))
  	{
   		 alertShow("显示顺序请填写整数");
   		 return -1;
  	}
    var EvaluationID=GetElementValue("EvaluationDR");
    var EvaluationListID=GetElementValue("RowID");
    var encmeth=GetElementValue("CheckShowOrder");
    var result=cspRunServerMethod(encmeth,ShowOrder,EvaluationID,EvaluationListID);
    result=result.replace(/\\n/g,"\n");
   
    if (result==1)
    {
	    alertShow("显示顺序有重复,请确认!");
	    SetElement("ShowOrder","");
	    return -1;
    }
    return;
}
function CombinData()
{
	var combindata="";
	combindata=GetElementValue("RowID");//1
	combindata=combindata+"^"+GetElementValue("EvaluationDR");//
  	combindata=combindata+"^"+GetElementValue("EvaluateTypeDR");//
  	combindata=combindata+"^"+GetElementValue("ItemScore");//医院
  	combindata=combindata+"^"+GetElementValue("EvaluateGroupDR");//类组
  	combindata=combindata+"^"+GetElementValue("ShowOrder");//评价标志
  	combindata=combindata+"^"+GetElementValue("hold1");//
  	combindata=combindata+"^"+GetElementValue("hold2");//
  	combindata=combindata+"^"+GetElementValue("hold3");//
  	combindata=combindata+"^"+GetElementValue("hold4");//
  	combindata=combindata+"^"+GetElementValue("hold5");//  	
  	return combindata;
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
	if (result>0) 
	{   
	    alertShow("删除成功")     //add by wy 2018-1-16
		location.reload();	
	}
	else
	{
		alertShow(t[result]);
	}	
}
///选择表格行触发此方法
var SelectedRow = 0;
var rowid=0;
function SelectRowHandler()
{
	var eSrc=window.event.srcElement;
	var objtbl=document.getElementById('tDHCEQCEvaluationList');
	var rows=objtbl.rows.length;
	var lastrowindex=rows - 1;
	var rowObj=getRow(eSrc);
	var selectrow=rowObj.rowIndex;
	if (!selectrow)	 return;
	if (SelectedRow==selectrow)
	{
		Clear();
		SetElement("ItemScore","5"); 
		disabled(true)//灰化
		SelectedRow=0;
		rowid=0;
		SetElement("RowID","");
	}
	else
	{
		SelectedRow=selectrow;
		rowid=GetElementValue("TRowIDz"+SelectedRow);
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
	SetElement("EvaluationTypeDR","");
	SetElement("EvaluationType","");
	SetElement("ItemScore","");
	SetElement("EvaluateGroupDR","");
	SetElement("EvaluateGroup","");
	SetElement("ShowOrder","");
	SetElement("hold1","");
	SetElement("hold2","");
	SetElement("hold3","");
	SetElement("hold4","");
	SetElement("hold5","");
}

function SetData(rowid)
{
	var encmeth=GetElementValue("GetData");
	if (encmeth==""){return;}
	var gbldata=cspRunServerMethod(encmeth,rowid);
	gbldata=gbldata.replace(/\\n/g,"\n");
	//alertShow("gbldata="+gbldata);
	var list=gbldata.split("^");
	var sort=12
	SetElement("RowID",list[0]);//rowid
	SetElement("EvaluateTypeDR",list[2]);
	SetElement("EvaluationType",list[sort+0]); 
	SetElement("ItemScore",list[3]); 
	SetElement("EvaluateGroupDR",list[4]); 
	SetElement("EvaluateGroup",list[sort+1]);
	SetElement("ShowOrder",list[5]);
	SetElement("hold1",list[6]); 
	SetElement("hold2",list[7]); 
	SetElement("hold3",list[8]); 
	SetElement("hold4",list[9]); 
	SetElement("hold5",list[10]);  
}

function GetEvaluateGroup(value)
{
	var type=value.split("^");
	SetElement("EvaluateGroup",type[2])
	var obj=document.getElementById("EvaluateGroupDR");
	obj.value=type[0];
}
function GetEvaluationType(value)
{
	var type=value.split("^");
	var obj=document.getElementById("EvaluateTypeDR");
	obj.value=type[2];
}

function CheckEvaluationGroup()
{
	var Flag=false;
	var EvaluationDR=GetElementValue("EvaluationDR");
	var encmeth=GetElementValue("FindEvaluationGroup");
    var result=cspRunServerMethod(encmeth,EvaluationDR);
    result=result.replace(/\\n/g,"\n");
    if(result=="N")
    {
	    var EvaluateGroup=GetElementValue("EvaluateGroup");
	    var TEvaluateGroup=GetElementValue("TEvaluateGroupz1");
	    if((EvaluateGroup!=TEvaluateGroup)&&(TEvaluateGroup!=""))
		{
			alertShow("评教组只有一个！");
			return;
		}
		else
		{
			Flag=true;
		}
	}
	else
	{
		Flag=true;
	}
  	return Flag;
}
document.body.onload = BodyLoadHandler;