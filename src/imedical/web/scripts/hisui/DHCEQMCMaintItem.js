var SelectedRow = -1;	//hisui改造：修改开始行号  Add By DJ 2018-10-12
var rowid=0;
function BodyLoadHandler() 
{		
    $("body").parent().css("overflow-y","hidden");  //Add By DJ 2018-10-12 hiui-改造 去掉y轴 滚动条
	$("#tDHCEQMCMaintItem").datagrid({showRefresh:false,showPageList:false,afterPageText:'',beforePageText:''});   //Add By DJ 2018-10-12 hisui改造：隐藏翻页条内容
	InitUserInfo(); //系统参数
	InitEvent();
	initButtonWidth();	//hisui改造 Add By DJ 2018-10-12
	initPanelHeaderStyle();//hisui改造 add by zyq 2023-02-02		
	disabled(true);//灰化	
}
function InitEvent()
{	
	var obj=document.getElementById("BAdd");
	if (obj) obj.onclick=BAdd_Click;
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
    combindata=GetElementValue("RowID") ;//1
	combindata=combindata+"^"+GetElementValue("Code") ;//
  	combindata=combindata+"^"+GetElementValue("Desc") ; //
   	combindata=combindata+"^"+GetElementValue("Remark") ; //
 	//combindata=combindata+"^"+GetElementValue("InvalidFlag") ; //
  	combindata=combindata+"^"+GetElementValue("Type") ; //    	
  	return combindata;
}

function BAdd_Click() 
{	
	if (condition()) return;	
	var encmeth=GetElementValue("GetUpdate");
	if (encmeth=="") return;
	var plist=CombinData(); //函数调用
	var list=plist.split("^");
    var code=list[1];
    if(code=="") return;
    
	var result=cspRunServerMethod(encmeth,plist);
	result=result.replace(/\\n/g,"\n")
	if (result>0)
	{
		alertShow("操作成功!") 
		location.reload();
		return;
	}
	else
	{
		messageShow("","","",t[result]);
	}

}

function BUpdate_Click() 
{	
	if (condition()) return;	
	var encmeth=GetElementValue("GetUpdate");
	if (encmeth=="") return;
	var plist=CombinData(); //函数调用
	var list=plist.split("^");
    var code=list[1];
    if(code=="") return;
    
	var result=cspRunServerMethod(encmeth,plist);
	result=result.replace(/\\n/g,"\n")
	if (result>0)
	{
		alertShow("操作成功")
		location.reload();
		return;
	}
	else
	{
		messageShow("","","",t[result]);
	}
}

function BDelete_Click() 
{
	rowid=GetElementValue("RowID");
	var truthBeTold = window.confirm(t[-4003]);
    if (!truthBeTold) return;
	var encmeth=GetElementValue("GetUpdate");
	if (encmeth=="") 
	{
		messageShow("","","",t[-4001])
		return;
	}
	var result=cspRunServerMethod(encmeth,rowid,'1');
	//messageShow("","","",result);
	result=result.replace(/\\n/g,"\n")
	if (result>0)
	{
		alertShow("操作成功")
		location.reload();
	}	
}
///hisui改造： Add By DJ 2018-10-12
function SelectRowHandler(index,rowdata){
	if (index==SelectedRow){
		Clear();
		SelectedRow= -1;
		disabled(true); 
		$('#tDHCEQMCMaintItem').datagrid('unselectAll'); 
		return;
		}
		
	SetData(rowdata.TRowID); 
	disabled(false)  
    SelectedRow = index;
}
function Clear()
{
	SetElement("RowID","")
	SetElement("Code",""); 
	SetElement("Desc","");
	SetElement("Type","");
	SetElement("Remark","");	
	}
function SetData(rowid)
{
	var encmeth=GetElementValue("GetData");
	if (encmeth=="") return;
	var gbldata=cspRunServerMethod(encmeth,rowid);
	//messageShow("","","",gbldata);
	var list=gbldata.split("^");
	SetElement("RowID",rowid); //rowid
	SetElement("Code",list[0]); //
	SetElement("Desc",list[1]); //
	SetElement("Remark",list[2]);//
	//SetElement("InvalidFlag",list[3]);//
	SetElement("Type",list[4]);//	
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
