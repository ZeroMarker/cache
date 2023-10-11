function BodyLoadHandler() 
{
	//modified by cjt 20230211 需求号3220778 UI页面改造
	initPanelHeaderStyle();
	InitUserInfo();
	InitEvent();	//初始化
	initButtonWidth(); //HISUI改造-修改按钮展示样式	add by kdf 2018-09-04
}

function InitEvent()
{
	var obj=document.getElementById("BPrint");
	if (obj) obj.onclick=BPrint_Click;
	var obj=document.getElementById("BExport");
	if (obj) obj.onclick=BExport_Click;
	
	var obj=document.getElementById("BFind");
	if (obj) obj.onclick=BFind_Click;
}

/// //HISUI改造-修改日期查询问题 add by kdf 2018-08-30 
function BFind_Click()
{
	var StartDate=GetElementValue("StartDate"); 
	var EndDate=GetElementValue("EndDate"); 
	val="&StartDate="+StartDate+"&EndDate="+EndDate ;
	if ('function'==typeof websys_getMWToken){		//czf 2023-02-14 token启用参数传递
		val += "&MWToken="+websys_getMWToken()
	}
	window.location.href="websys.default.hisui.csp?WEBSYS.TCOMPONENT=DHCEQFirstMove"+val;
}

function BPrint_Click()
{
	//var ObjTJob=document.getElementById("TJobz1");
	//if (ObjTJob)  TJob=ObjTJob.value;
	
	//HISUI改造-修改TJob取值获取不到的问题 begin add by kdf 2018-09-07
	var ObjTJob=$('#tDHCEQFirstMove').datagrid('getData');
	if (ObjTJob.rows[0]["TJob"])  TJob=ObjTJob.rows[0]["TJob"];
	//HISUI改造-修改TJob取值获取不到的问题  end add by kdf 2018-09-07
	
	if (TJob=="")  return;
	PrintDHCEQEquipNew("FirstMove",0,TJob,"","")
	return
}

function BExport_Click()
{
	//var ObjTJob=document.getElementById("TJobz1");
	//if (ObjTJob)  TJob=ObjTJob.value;
	
	//HISUI改造-修改TJob取值获取不到的问题 begin add by kdf 2018-09-07
	var ObjTJob=$('#tDHCEQFirstMove').datagrid('getData');
	if (ObjTJob.rows[0]["TJob"])  TJob=ObjTJob.rows[0]["TJob"];
	//HISUI改造-修改TJob取值获取不到的问题  end add by kdf 2018-09-07
	
	if (TJob=="")  return;
	PrintDHCEQEquipNew("FirstMove",1,TJob,"","")
	return
}

//定义页面加载方法
document.body.onload = BodyLoadHandler;
