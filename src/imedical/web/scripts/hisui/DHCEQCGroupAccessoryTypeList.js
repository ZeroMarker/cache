//安全组访问配件代码	add by wjt 2019-02-19
function BodyLoadHandler() 
{
	InitUserInfo();
	var obj=document.getElementById("BUpdate");
	if (obj) obj.onclick=BUpdate_Click;			
}
function BUpdate_Click() 
{
	//var eSrc=window.event.srcElement;
/* 	var objtbl=document.getElementById('tDHCEQCGroupAccessoryTypeList');//+组件名 就是你的组件显示 Query 结果的部分
	var rows=objtbl.rows.length;
	var lastrowindex=rows - 1; */
	var objtbl=$('#tDHCEQCGroupAccessoryTypeList').datagrid('getRows')
	var rows=objtbl.length
 	var Flag=false;
	for (var j=0;j<rows;j++)
	{
		var Default=GetChkElementValue("TDefaultz"+j);
		var Default=getColumnValue(j,"TDefault")
		if ((Default)&&(Flag))
		{
			//alertShow(t["01"]);
			messageShow("","","",t["01"]);
			return;
		}
		if (Default) Flag=true;
	}
	for (var i=0;i<rows;i++)
	{
		var RowID=GetElementValue("RowID")
		//var Codetable=GetElementValue("TRowIDz"+i);
		var Codetable=objtbl[i].TRowID
		//var Depre=GetChkElementValue("TPutInz"+i);
		var Depre=getColumnValue(i,"TPutIn")
		//var Default=GetChkElementValue("TDefaultz"+i);
		var Default=getColumnValue(i,"TDefault")
		if (Default)
		{
			Default="Y";
		}
		else
		{
			Default="N";
		}
		if (Depre==1)
		{
			var isDel="1";
			SetData(RowID,Codetable,isDel,Default);//调用函数	
		}
		if (Depre==0)
		{
			var isDel="2";
			SetData(RowID,Codetable,isDel,Default);
		}
		//alertShow(" RowID"+":"+RowID+" Codetable"+":"+Codetable+" Default"+":"+Default+" Depre"+":"+Depre+" isDel"+":"+isDel)//test
	}
	//alertShow("更新成功！")    //add by czf 2016-11-07 需求号：281621
	messageShow("","","",t["02"]);
	location.reload();	
	}	
function SetData(RowID,Codetable,isDel,Default)
{
	var encmeth=GetElementValue("GetData");
	if (encmeth=="") return;
	var gbldata=cspRunServerMethod(encmeth,'','',RowID,Codetable,isDel,Default);
}	

document.body.onload = BodyLoadHandler;	