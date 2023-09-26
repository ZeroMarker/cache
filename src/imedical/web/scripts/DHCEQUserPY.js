
var SelectedRow = 0;
var rowid=0;
//装载页面  函数名称固定
function BodyLoadHandler() {
	InitUserInfo();
	InitEvent();	//初始化
	SetElement("RowID","");
	SetElement("Name","");
	SetElement("PYCode","");
}

function InitEvent() //初始化
{
	var obj=document.getElementById("BUpdate");
	if (obj) obj.onclick=BUpdate_Click;
}

function BUpdate_Click()
{
	var rowid=GetElementValue("RowID")
	if (rowid=="") retrun
	var encmeth=GetElementValue("GetUpdate");
	if (encmeth=="") return;
	var plist=GetElementValue("RowID")+"^"+GetElementValue("Name")+"^"+GetElementValue("PYCode"); //函数调用
	var result=cspRunServerMethod(encmeth,plist);
	location.reload();
}

///选择表格行触发此方法
function SelectRowHandler()
{
	var eSrc=window.event.srcElement;
	var objtbl=document.getElementById('tDHCEQUserPY');//+组件名 就是你的组件显示 Query 结果的部分
	var rows=objtbl.rows.length;
	
	var lastrowindex=rows - 1;
	
	var rowObj=getRow(eSrc);
	
	var selectrow=rowObj.rowIndex;
	if (!selectrow)	 return;
	if (SelectedRow==selectrow)	{
		SelectedRow=0;
		rowid=0;
		SetElement("RowID","");
		SetElement("Name","");
		SetElement("PYCode","");
		}
	else{
		SelectedRow=selectrow;
		rowid=GetElementValue("TRowIDz"+SelectedRow);
		SetData(rowid);//调用函数
		}
}

function SetData(rowid)
{
	var encmeth=GetElementValue("GetData");
	if (encmeth=="") return;
	var gbldata=cspRunServerMethod(encmeth,rowid);
	gbldata=gbldata.replace(/\\n/g,"\n"); //"\n"转换为回车符
	var list=gbldata.split("^");
	SetElement("RowID",rowid); //rowid
	SetElement("Name",list[0]); //Name
	SetElement("PYCode",list[1]); //PYCode
}

//定义页面加载方法
document.body.onload = BodyLoadHandler;