//--------------------------------------------------
//modified by GR 2014-09-26 缺陷号2944
//代码维护-标准代码-查找描述方法的记录后，新增记录时，提示"web浏览器需要重新发送您以前提交的信息"
//原因：查找js使用的是scriptgen目录下的js，查找后的页面url不含参数，每次刷新都会有这个提示
//------------------------------------------------------------
var SelectedRow = 0;
var tabNameStr="";	
var preFixStr="";
var ReadOnly="";


function SelectRowHandler()	{
	var eSrc=window.event.srcElement;
	var objtbl=document.getElementById('tDHCEQCCodeTable');
	var rows=objtbl.rows.length;
	
	var lastrowindex=rows - 1;
	
	var rowObj=getRow(eSrc);
	var selectrow=rowObj.rowIndex;
	if (!selectrow) return;
	Selected(selectrow);
}

function Selected(selectrow)
{	
	if(ReadOnly!="1")
	{
		InitPage();	
	}
	if (SelectedRow==selectrow)	{			
		SelectedRow=0;		
		Clear()	
		//取消选取记录后:填写框,添加,查找 可用 
		if(ReadOnly!="1")
		{
		DisableBElement("BAdd",false);
		DisableBElement("BUpdate",true);
		DisableBElement("BDel",true);
		DisableBElement("BClear",false);
		DisableBElement("BFind",false);
	
		DisableElement("RowID",false);
		DisableElement("Code",false);
		DisableElement("Desc",false);
		DisableElement("Remark",false);						
		}
	}
	else
	{		
		//选取记录后:新增不可用
		if(ReadOnly!="1")
		{
		DisableBElement("BAdd",true);
		DisableBElement("BUpdate",false);
		DisableBElement("BDel",false);
		DisableBElement("BClear",false);   //modify by lmm 2017-03-30 355667
		//DisableBElement("BFind",true);   //Modefied by zc 2014-09-05 ZC0004
	
		DisableElement("RowID",false);
		DisableElement("Code",false);
		DisableElement("Desc",false);
		DisableElement("Remark",false);	
		}	
		SelectedRow=selectrow;		
		SetData(SelectedRow);		
	}			
}

function SetData(index)
{	
	var rowidstr=GetElementValue("TRowIDz"+SelectedRow);
	var codestr=GetCElementValue("TCodez"+SelectedRow);
	var descstr=GetCElementValue("TDescz"+SelectedRow);
	var remarkstr=GetCElementValue("TRemarkz"+SelectedRow);
	SetElement("RowID",rowidstr);
	SetElement("Code",codestr);
	SetElement("Desc",descstr);
	SetElement("Remark",remarkstr);	
}

function BodyLoadHandler() 
{
	//document.body.scroll="no";
	tabNameStr=GetElementValue("TabName");	
	preFixStr=GetElementValue("PreFix");
	ReadOnly=GetElementValue("ReadOnly");
	InitUserInfo();	
	Clear();
	InitPage();
	var obj=document.getElementById("cEQTitle");
	if (obj)
	{
		SetElement("cEQTitle",GetElementValue("titleName"))
	}
	if(tabNameStr!="")
	{		
		if(ReadOnly=="1")
		{	//全部不可用		
			DisableBElement("BAdd",true);
			DisableBElement("BUpdate",true);
			DisableBElement("BDel",true);
			DisableBElement("BClear",true);
			DisableBElement("BFind",true);
	
			DisableElement("RowID",false);
			DisableElement("Code",false);
			DisableElement("Desc",false);
			DisableElement("Remark",false);
		}
		else
		{
			//填写框?添加?查找 可用 			
			DisableBElement("BAdd",false);
			DisableBElement("BUpdate",true);
			DisableBElement("BDel",true);
			DisableBElement("BClear",false);
			DisableBElement("BFind",false);
	
			DisableElement("RowID",false);
			DisableElement("Code",false);
			DisableElement("Desc",false);
			DisableElement("Remark",false);
		}		
	}
	else
	{		
		DisableBElement("BAdd",true);
		DisableBElement("BUpdate",true);
		DisableBElement("BDel",true);
		DisableBElement("BClear",true);
		DisableBElement("BFind",true);
	
		DisableElement("RowID",true);
		DisableElement("Code",true);
		DisableElement("Desc",true);
		DisableElement("Remark",true);	
	}	
}
///初始化页面
function InitPage()
{		
	var obj=document.getElementById("BAdd");
	if (obj) obj.onclick=BAdd_Click;
	
	var obj=document.getElementById("BUpdate");
	if (obj) obj.onclick=BUpdate_Click;
	
	var obj=document.getElementById("BDel");
	if (obj) obj.onclick=BDelete_Click;
	
	var obj=document.getElementById("BClear");
	if (obj) obj.onclick=BClear_Click;	
	
	var obj=document.getElementById("BFind");//modified by GR 2014-09-26 缺陷号2944
	if (obj) obj.onclick=BFind_Click;
}

function BFind_Click()                   //add function by GR 2014-09-26 缺陷号2944
{
	
	var codeStr=GetElementValue("Code");
	var descStr=GetElementValue("Desc");	
	var remarkStr=GetElementValue("Remark");
	var url=GetData()+"&Code="+codeStr+"&Desc="+descStr+"&Remark="+remarkStr;
	window.location.href=url;
	}
function GetData()                  //add function by GR 2014-09-26 缺陷号2944
{
	titleName=GetElementValue("titleName")
	tabNameStr=GetElementValue("TabName");	
	preFixStr=GetElementValue("PreFix");
	ReadOnly=GetElementValue("ReadOnly");
	var url="websys.default.csp?WEBSYS.TCOMPONENT=DHCEQCCodeTable&TabName="+tabNameStr+"&PreFix="+preFixStr+"&ReadOnly="+ReadOnly+"&titleName="+titleName;
	return url;
}

//==========Clice Star
function BAdd_Click() 
{	
	var encmeth=GetElementValue("GetExecMethod");
	if (encmeth=="")
	{
		alertShow(t[-4001]);
		return;
	}
	SaveData(encmeth,0);		
}
	     
function BUpdate_Click() 
{	
	var encmeth=GetElementValue("GetExecMethod");
	if (encmeth=="")
	{
		alertShow(t[-4001]);
		return;
	}
	SaveData(encmeth,1);
}

function BDelete_Click()
{
	var sqlStr="";	
	if (GetElementValue("RowID")=="")	{
		alertShow(t['04']);
		return;
	}
	var truthBeTold = window.confirm(t['03']);
    if (truthBeTold) {	    
	    var encmeth=GetElementValue("GetExecMethod");
		if (encmeth=="")
		{
			alertShow(t[-4001]);
			return;
		}
		//modified by zy 2017-03-24  修改标准代码维护界面的逻辑
		//sqlStr="update SqlUser."+tabNameStr+" set "+preFixStr+"_InvalidFlag='Y' where "+preFixStr+"_RowID=" + GetElementValue("RowID");
		var result=cspRunServerMethod(encmeth,2,tabNameStr,preFixStr,GetElementValue("RowID"),"","","");		
		if (result=="0")
		{
			alertShow("删除成功!")
			//location.reload();
			window.location.href=GetData();//modified by GR 2014-09-26 缺陷号2944
			
		}
		else
		{
			alertShow(t[-2012]);
		}
    }
}

function BClear_Click()
{
	Clear();
}
//==========Clice end

function SaveData(encmeth,typeStr)
{
	//typeStr 0:新增 1:修改
	if (CheckMustItemNull()) return true;
	var sqlStr="";	
	var rowidStr=GetElementValue("RowID");	
	var codeStr=GetElementValue("Code");
	var descStr=GetElementValue("Desc");	
	var remarkStr=GetElementValue("Remark");	
	///2010-06-11 党军 begin
	var CheckData=GetElementValue("CheckData");
	var TableName=tabNameStr.replace("_","");
	var find=cspRunServerMethod(CheckData,TableName,rowidStr, codeStr, descStr)
	if (find>0)
	{
		alertShow("录入数据重复!请检查!")
		return
	}
	//modified by zy 2017-03-24  修改标准代码维护界面的逻辑
		///Add by JDL 20150914 解决空字符串，保存数据为<empty>的问题
	/*if (""==codeStr)
	{	codeStr="null";	}
	else
	{	codeStr="'"+codeStr+"'";	}
	if (""==descStr)
	{	descStr="null";	}
	else
	{	descStr="'"+descStr+"'";	}
	if (""==remarkStr)
	{	remarkStr="null";	}
	else
	{	remarkStr="'"+remarkStr+"'";	}
	///2010-06-11 党军 end
	if(typeStr==0)
	{
		sqlStr="insert into SqlUser."+tabNameStr+" ("+preFixStr+"_Code,"+preFixStr+"_Desc,"+preFixStr+"_Remark,"+preFixStr+"_InvalidFlag) values ('"+codeStr+"','"+descStr+"','"+remarkStr+"','N')";
	}
	if(typeStr==1)
	{
		sqlStr="update SqlUser."+tabNameStr+" set "+preFixStr+"_Code='"+codeStr+"',"+preFixStr+"_Desc='"+descStr+"',"+preFixStr+"_Remark='"+remarkStr+"' where "+preFixStr+"_RowID="+rowidStr;
	}*/
	var result=cspRunServerMethod(encmeth,typeStr,tabNameStr,preFixStr,rowidStr,codeStr,descStr,remarkStr);

	if (result=="0")
	{
			alertShow("操作成功")
			//location.reload();
			window.location.href=GetData();//modified by GR 2014-09-26 缺陷号2944
	}
	else
	{
		alertShow(t[-106]);
	}
}

function Clear()
{	
	SetElement("RowID","");
	SetElement("Code","");
	SetElement("Desc","");
	SetElement("Remark","");	
}


document.body.onload = BodyLoadHandler;
