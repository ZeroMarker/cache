//--------------------------------------------------
//modified by GR 2014-09-26 ȱ�ݺ�2944
//����ά��-��׼����-�������������ļ�¼��������¼ʱ����ʾ"web�������Ҫ���·�������ǰ�ύ����Ϣ"
//ԭ�򣺲���jsʹ�õ���scriptgenĿ¼�µ�js�����Һ��ҳ��url����������ÿ��ˢ�¶����������ʾ
//------------------------------------------------------------
var SelectedRow = -1;  //modify by lmm 2018-09-02 hisui���죺�޸��б�ʼ�к�
var tabNameStr="";	
var preFixStr="";
var ReadOnly="";

///modify by lmm 2018-09-02
///����������������¼�
///��Σ�index �к�
///      rowData ѡ����json�¼�
function SelectRowHandler(index,rowData)	{
	
	Selected(index,rowData);
}
///modify by lmm 2018-09-02 hisui���죺������� rowData
function Selected(selectrow,rowData)
{	
	if(ReadOnly!="1")
	{
		InitPage();	
	}
	if (SelectedRow==selectrow)	{			
		SelectedRow=-1;	  //modify by lmm 2018-09-02 hisui���죺�޸���亯����ʼ�к�	
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
		$('#tDHCEQCCodeTable').datagrid('unselectAll');  //add by lmm 2018-09-02 hisui���죺�ٵ��ȡ��ѡ��״̬
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
		SetData(SelectedRow,rowData);   //modify by lmm 2018-09-02 hisui���죺�������
	}			
}
///modify by lmm 2018-09-02 hisui���죺������� rowData,�޸�ֵ��ȡ
function SetData(SelectedRow,rowData)
{	
	var rowidstr=rowData.TRowID;
	var codestr=rowData.TCode;
	var descstr=rowData.TDesc;
	var remarkstr=rowData.TRemark;
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
	initButtonWidth()  //hisui���죺�޸İ�ť���� add by lmm 2018-09-02
	var obj=document.getElementById("cEQTitle");
	
	if(GetElementValue("titleName").length<1)
	{
		SetElement("titleName","��׼�����")
		}	//add by yh 20200402  1040241 
	
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
	var url="websys.default.hisui.csp?WEBSYS.TCOMPONENT=DHCEQCCodeTable&TabName="+tabNameStr+"&PreFix="+preFixStr+"&ReadOnly="+ReadOnly+"&titleName="+titleName;  //modify by lmm 2018-09-02 �޸�hisuiĬ��csp
	return url;
}

//==========Clice Star
function BAdd_Click() 
{	
	var encmeth=GetElementValue("GetExecMethod");
	if (encmeth=="")
	{
		messageShow("","","",t[-4001]);
		return;
	}
	SaveData(encmeth,0);		
}
	     
function BUpdate_Click() 
{	
	var encmeth=GetElementValue("GetExecMethod");
	if (encmeth=="")
	{
		messageShow("","","",t[-4001]);
		return;
	}
	SaveData(encmeth,1);
}

function BDelete_Click()
{
	var sqlStr="";	
	if (GetElementValue("RowID")=="")	{
		messageShow("","","",t['04']);
		return;
	}
	var truthBeTold = window.confirm(t['03']);
    if (truthBeTold) {	    
	    var encmeth=GetElementValue("GetExecMethod");
		if (encmeth=="")
		{
			messageShow("","","",t[-4001]);
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
			messageShow("","","",t[-2012]);
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
		messageShow("","","",t[-106]);
	}
}

function Clear()
{	
	SetElement("RowID","");
	SetElement("Code","");
	SetElement("Desc","");
	SetElement("Remark","");	
	$('#tDHCEQCCodeTable').datagrid('unselectAll');  //add by wy 2019-09-11���ѡ���¼� 1015798
	//add by wl 2020-02-17 WL0048
	DisableBElement("BAdd",false);		
	DisableBElement("BUpdate",true);
	DisableBElement("BDel",true);
	DisableBElement("BClear",false);	 
}

document.body.style.padding="10px 10px 10px 5px"  // modify by lmm 2019-02-19 829712
document.body.onload = BodyLoadHandler;
