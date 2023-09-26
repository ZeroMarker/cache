//--------------------------------------------------
//modified by GR 2014-09-26 ȱ�ݺ�2944
//����ά��-��׼����-�������������ļ�¼��������¼ʱ����ʾ"web�������Ҫ���·�������ǰ�ύ����Ϣ"
//ԭ�򣺲���jsʹ�õ���scriptgenĿ¼�µ�js�����Һ��ҳ��url����������ÿ��ˢ�¶����������ʾ
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
		//ȡ��ѡȡ��¼��:��д��,���,���� ���� 
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
		//ѡȡ��¼��:����������
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
		{	//ȫ��������		
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
			//��д��?���?���� ���� 			
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
///��ʼ��ҳ��
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
	
	var obj=document.getElementById("BFind");//modified by GR 2014-09-26 ȱ�ݺ�2944
	if (obj) obj.onclick=BFind_Click;
}

function BFind_Click()                   //add function by GR 2014-09-26 ȱ�ݺ�2944
{
	
	var codeStr=GetElementValue("Code");
	var descStr=GetElementValue("Desc");	
	var remarkStr=GetElementValue("Remark");
	var url=GetData()+"&Code="+codeStr+"&Desc="+descStr+"&Remark="+remarkStr;
	window.location.href=url;
	}
function GetData()                  //add function by GR 2014-09-26 ȱ�ݺ�2944
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
		//modified by zy 2017-03-24  �޸ı�׼����ά��������߼�
		//sqlStr="update SqlUser."+tabNameStr+" set "+preFixStr+"_InvalidFlag='Y' where "+preFixStr+"_RowID=" + GetElementValue("RowID");
		var result=cspRunServerMethod(encmeth,2,tabNameStr,preFixStr,GetElementValue("RowID"),"","","");		
		if (result=="0")
		{
			alertShow("ɾ���ɹ�!")
			//location.reload();
			window.location.href=GetData();//modified by GR 2014-09-26 ȱ�ݺ�2944
			
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
	//typeStr 0:���� 1:�޸�
	if (CheckMustItemNull()) return true;
	var sqlStr="";	
	var rowidStr=GetElementValue("RowID");	
	var codeStr=GetElementValue("Code");
	var descStr=GetElementValue("Desc");	
	var remarkStr=GetElementValue("Remark");	
	///2010-06-11 ���� begin
	var CheckData=GetElementValue("CheckData");
	var TableName=tabNameStr.replace("_","");
	var find=cspRunServerMethod(CheckData,TableName,rowidStr, codeStr, descStr)
	if (find>0)
	{
		alertShow("¼�������ظ�!����!")
		return
	}
	//modified by zy 2017-03-24  �޸ı�׼����ά��������߼�
		///Add by JDL 20150914 ������ַ�������������Ϊ<empty>������
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
	///2010-06-11 ���� end
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
			alertShow("�����ɹ�")
			//location.reload();
			window.location.href=GetData();//modified by GR 2014-09-26 ȱ�ݺ�2944
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
