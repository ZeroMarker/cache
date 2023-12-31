///--------------------------------------------
///Created By LZY 2013-9-25 . Bug LZY0001
///Description:在代码维护菜单下新增系统类型子菜单?实现对系统类型信息的管理?
///--------------------------------------------

var SelectedRow = -1;	//hisui改造：修改开始行号  Add By DJ 2018-10-12
var rowid=0;
function BodyLoadHandler() 
{		
    $("body").parent().css("overflow-y","hidden");  //Add By DJ 2018-10-12 hiui-改造 去掉y轴 滚动条
	$("#tDHCEQMCFaultReason").datagrid({showRefresh:false,showPageList:false,afterPageText:'',beforePageText:''});   //Add By DJ 2018-10-12 hisui改造：隐藏翻页条内容
	InitUserInfo(); //系统参数
	InitEvent();
	initButtonWidth();	//hisui改造 Add By DJ 2018-10-12
	initPanelHeaderStyle();//hisui改造 add by zyq 2023-02-02	
	disabled(true);//灰化	
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
	var obj=document.getElementById("BFind")
	if (obj) obj.onclick=BFind_Click;
	
}
function BFind_Click()
{
	var val="&Desc="+GetElementValue("Desc");
	val=val+"&Code="+GetElementValue("Code");
	//val=val+"&Type="+GetElementValue("Type")
	val=val+"&Remark="+GetElementValue("Remark")
	if ('function'==typeof websys_getMWToken){		//czf 2023-02-14 token启用参数传递
		val += "&MWToken="+websys_getMWToken()
	}
	window.location.href="websys.default.csp?WEBSYS.TCOMPONENT=DHCEQMCFaultReason"+val;
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
 	combindata=combindata+"^"+GetElementValue("InvalidFlag") ; //
  	//combindata=combindata+"^"+GetElementValue("Type") ; //    	
  	return combindata;
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
		$('#tDHCEQMCFaultReason').datagrid('unselectAll'); 
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
	//SetElement("Type","");
	SetElement("Remark","");	
	}
function SetData(rowid)
{		
	var encmeth=GetElementValue("GetData");	
	if (encmeth=="") return;
	var gbldata=cspRunServerMethod(encmeth,rowid);		
	var list=gbldata.split("^");		
	
	SetElement("RowID",rowid); //rowid
	SetElement("Code",list[0]); //
	SetElement("Desc",list[1]); //
	SetElement("Remark",list[2]);//	
	SetElement("InvalidFlag",list[3]);//	
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


