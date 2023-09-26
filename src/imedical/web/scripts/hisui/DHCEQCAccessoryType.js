//设备机型	add by wjt 2019-02-19
var SelectedRow = -1;
var rowid=0;
function BodyLoadHandler() 
{	
    InitUserInfo(); //系统参数
	InitEvent();	
	disabled(true);//灰化
	initButtonWidth(); 
	//InitButton();		Mozy003003	1246525		2020-3-27	注释
}
function InitEvent()
{
	var obj=document.getElementById("BAdd");
	if (obj) obj.onclick=BUpdate_Click;
	var obj=document.getElementById("BUpdate");
	if (obj) obj.onclick=BUpdate_Click;
	var obj=document.getElementById("BDelete");
	if (obj) obj.onclick=BDelete_Click;
	var obj=document.getElementById("BClear");
	if (obj) obj.onclick=BClear_Click;
}
function BClear_Click() 
{
	Clear();
	disabled(true);
}
function CombinData()
{
	var combindata="";
    combindata=GetElementValue("RowID") ;
	combindata=combindata+"^"+GetElementValue("Code") ;
  	combindata=combindata+"^"+GetElementValue("Desc") ;
  	combindata=combindata+"^"+GetElementValue("Remark") ;
  	combindata=combindata+"^"+GetChkElementValue("InvalidFlag") ;
  	return combindata;
}
function BUpdate_Click() 
{
	if (condition()) return;
	var encmeth=GetElementValue("GetUpdate");
	if (encmeth=="") return;
	var plist=CombinData(); //函数调用
	var result=cspRunServerMethod(encmeth,plist,"");
	if(result=="") 
	{
		//alertShow(t[-3001]);
		messageShow("","","",t["-3001"]);
		return
	}
	if (result>0)
	{
		//alertShow("操作成功");    //add by czf 2016-11-01  需求号：281632
		messageShow("","","",t["02"]);
		location.reload();	
	}
	// Mozy003008	1266885		2020-04-09 
	if(result==-9000) 
	{
		messageShow("","","","数据重复!");
		return
	}
}

//modified by csj 20190912 修改为hisui确认框 需求号：1027185
function BDelete_Click() 
{
	rowid=GetElementValue("RowID");
	messageShow("confirm","","",t[-4003],"",truthBeTold,Cancel);
	function truthBeTold(){
		var encmeth=GetElementValue("GetUpdate");
		if (encmeth=="") 
		{
			//alertShow(t[-3001])
			messageShow("","","",t["-3001"]);
			return;
		}
		var result=cspRunServerMethod(encmeth,rowid,'1');
		result=result.replace(/\\n/g,"\n")
		if (result>0)
		{
			//alertShow("操作成功");     //add by czf 2016-11-01  需求号：281632
			messageShow("","","",t["02"]);
			location.reload();	
		}
	}
	function Cancel(){
		return
	}	
}

///选择表格行触发此方法
function SelectRowHandler(rowIndex,rowData)
{
	/* var eSrc=window.event.srcElement;
	var objtbl=document.getElementById('tDHCEQCAccessoryType');
	var rows=objtbl.rows.length;
	var lastrowindex=rows - 1;
	var rowObj=getRow(eSrc);
	var selectrow=rowObj.rowIndex; */
	//if (!index)	 return;
	if (SelectedRow==rowIndex)
	{
		Clear();
		disabled(true);//灰化
		SelectedRow=-1;
		rowid=0;
		SetElement("RowID","");	
 	}
	else
	{
		SelectedRow=rowIndex;
		//rowid=GetElementValue("TRowIDz"+SelectedRow);
		rowid=rowData.TRowID;
		SetData(rowid);//调用函数
		disabled(false);//反灰化
	}
}
function Clear()
{
	SetElement("RowID","")
	SetElement("Code",""); 
	SetElement("Desc","");
	SetElement("Remark","");
	SetElement("InvalidFlag","");
}
function SetData(rowid)
{
	var encmeth=GetElementValue("GetData");
	if (encmeth=="") return;
	var gbldata=cspRunServerMethod(encmeth,rowid);
	var list=gbldata.split("^");
	SetElement("RowID",list[0])
	SetElement("Code",list[1]); 
	SetElement("Desc",list[2]);
	SetElement("Remark",list[3]);
	SetElement("InvalidFlag",list[4]);
}
function disabled(value)//灰化
{
	InitEvent();
	DisableBElement("BUpdate",value)
	DisableBElement("BDelete",value)	
	DisableBElement("BAdd",!value)
}	
function condition()//条件
{
	if (CheckMustItemNull()) return true;
	return false;
}
document.body.onload = BodyLoadHandler;
