function BodyLoadHandler() 
{
	InitUserInfo();
	InitEvent();	//初始化
}

function InitEvent()
{
	var obj=document.getElementById("BPrint");
	if (obj) obj.onclick=BPrint_Click;
	var obj=document.getElementById("BExport");
	if (obj) obj.onclick=BExport_Click;
}

function BPrint_Click()
{
	var ObjTJob=document.getElementById("TJobz1");
	if (ObjTJob)  TJob=ObjTJob.value;
	if (TJob=="")  return;
	PrintDHCEQEquipNew("FirstMove",0,TJob,"","")
	return
}

function BExport_Click()
{
	var ObjTJob=document.getElementById("TJobz1");
	if (ObjTJob)  TJob=ObjTJob.value;
	if (TJob=="")  return;
	PrintDHCEQEquipNew("FirstMove",1,TJob,"","")
	return
}

//定义页面加载方法
document.body.onload = BodyLoadHandler;
