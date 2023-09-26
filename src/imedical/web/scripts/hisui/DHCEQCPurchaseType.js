//申购类别代码表
function BodyLoadHandler() 
{
	InitUserInfo();
	InitEvent();
	//KeyUp("Omdr")	//清空选择
	disabled(true);//灰化
	initButtonWidth();
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
function BUpdate_Click() 
{
	if (condition()) return;
var encmeth=GetElementValue("GetUpdate");
	if (encmeth=="")return;
	var plist=CombinData(); //函数调用
	//alertShow("plist:"+plist);
	var result=cspRunServerMethod(encmeth,'','',plist);
	result=result.replace(/\\n/g,"\n")
	if(result==-2001)messageShow("","","",t[-3002]);
	if (result==-99) //2010-06-11 党军 begin
	{
		alertShow("数据重复!请检查!")
		return
	} //2010-06-11 党军 end
	if (result>0)
	{
	alertShow("更新成功!");   // add by kdf 2018-01-16 需求号：531038
	location.reload();
	}		
}
function CombinData()
{	
	var AutoFlag="";
	var combindata="";
	combindata=GetElementValue("RowID") ;
	combindata=combindata+"^"+GetElementValue("Code") ;//代码2
  	combindata=combindata+"^"+GetElementValue("Desc") ; //描述3
  	combindata=combindata+"^"+GetElementValue("Remark") ; //备注4
  	var obj=document.getElementById("DefaultFlag")
  	if (obj.checked){ var AutoFlag="Y"}
  			else  	{ var AutoFlag="N" }
  	combindata=combindata+"^"+AutoFlag; //默认标志5
  	return combindata;
}
function BAdd_Click() 
{
	if (condition()) return;
	var encmeth=GetElementValue("GetUpdate");
	if (encmeth=="")return;
	var plist=CombinData(); //函数调用
	//alertShow("plist:"+plist);
	var result=cspRunServerMethod(encmeth,'','',plist,'2');
	result=result.replace(/\\n/g,"\n")
	if(result==-2001) messageShow("","","",t[-3001]);
	if (result==-99) //2010-06-11 党军 begin
	{
		alertShow("数据重复!请检查!")
		return
	} //2010-06-11 党军 end
	if (result>0)
	{
	alertShow("增加成功!");  // add by kdf 2018-01-16 需求号：531035
	location.reload();
	}
}
function BDelete_Click() 
{
	rowid=GetElementValue("RowID");
	var truthBeTold = window.confirm(t[-4003]);
    if (!truthBeTold) return;
	var encmeth=GetElementValue("GetUpdate");
	if (encmeth=="") return;
	var result=cspRunServerMethod(encmeth,'','',rowid,'1');
	result=result.replace(/\\n/g,"\n")
	if (result>0) 
	{
	alertShow("删除成功!") ;     //add by kdf 2018-01-16 需求号：531110
	location.reload();
	}
}
	
///选择表格行触发此方法
var SelectedRow = -1;
var rowid=0;
function SelectRowHandler(index,rowdata)
{
	if (SelectedRow==index)
	{
		Clear();
		disabled(true)//灰化
		SelectedRow=-1;
		rowid=0;
		SetElement("RowID","");
	}
	else
	{
		SelectedRow=index;
		rowid=rowdata.TRowID;
		SetData(rowid);//调用函数
		disabled(false)//反灰化
	}
}
function SetData(rowid)
{
	var encmeth=GetElementValue("GetData");
	if (encmeth=="") return;
	var gbldata=cspRunServerMethod(encmeth,'','',rowid);
	gbldata=gbldata.replace(/\\n/g,"\n");
	var list=gbldata.split("^");
	//alertShow("list"+list);
	SetElement("RowID",list[0]); //rowid
	SetElement("Code",list[1]); //设备
	SetElement("Desc",list[2]); //部位
	SetElement("Remark",list[3]);//备注
	var obj=document.getElementById("DefaultFlag")
	if(list[4]=="Y"){obj.checked=true}
	else{obj.checked=false}
}
function Clear()
{
	SetElement("Code",""); 
	SetElement("Desc","");
	SetElement("Remark","");
	var obj=document.getElementById("DefaultFlag");
	obj.checked=false;
	}		
function disabled(value)//反灰化
{
	InitEvent();
	DisableBElement("BUpdate",value)
	DisableBElement("BDelete",value)	
	DisableBElement("BAdd",!value)
}
function condition()//条件
{
	if (CheckMustItemNull()) return true;
	//if (CheckItemNull(0,"Code")) return true;
	return false;
}	
document.body.onload = BodyLoadHandler	
