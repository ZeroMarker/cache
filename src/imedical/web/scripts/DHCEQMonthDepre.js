var EquipId="";	
var DepreSetId="";	
var DepreMethodId="";
var CostAllotId="";
var PreDepreMonth="";
var recordID="";

function formatFloat(src, pos)
{
    return Math.round(src*Math.pow(10, pos))/Math.pow(10, pos);
}
function BodyLoadHandler() 
{	
	recordID=GetElementValue("RowID");
	EquipId=GetElementValue("EquipDR");	
	DepreSetId=GetElementValue("DepreSetDR");	
	DepreMethodId=GetElementValue("DepreMethodDr");
	CostAllotId=GetElementValue("CostAllotDR");
	PreDepreMonth=GetElementValue("PreDepreMonth");	
	InitUserInfo();	
	InitPage();	
}
///��ʼ��ҳ��
function InitPage()
{	
	var encmeth=GetElementValue("GetInitInfo");	
	var YearStr="";	
	var MonthStr="";
	var result="";	
	if(recordID=="")
	{
		var value=PreDepreMonth.split("-")
		if(value.length != 2&&value!=""&&value!=null)
		{
			alertShow('�ϴ��۾��·ݸ�ʽ����,��������Χ!(��:2006-06)');
			parent.window.close();
		}
		else
		{
			result=cspRunServerMethod(encmeth,"",EquipId,DepreMethodId,PreDepreMonth);			
		}
	}
	else
	{
		//��������¼
		result=cspRunServerMethod(encmeth,recordID,"","","");			
	}
	if (result!="")
	{					
		var oResult=result.split("^")
		//fill data		
		SetData(oResult);			
		//�������
		if(oResult[0]== "")
		{
			DisableBElement("BAudit",true);
			DisableBElement("BUpdate",false);
			DisableBElement("BDelete",true);
			var obj=document.getElementById("BUpdate");
			if (obj) obj.onclick=BUpdate_Click;
		}
		//ֻ�������\����\ɾ��
		if(oResult[0]=="0")
		{
			DisableBElement("BAudit",false);
			DisableBElement("BUpdate",false);
			DisableBElement("BDelete",false);
			var obj=document.getElementById("BAudit");
			if (obj) obj.onclick=BAudit_Click;	
			var obj=document.getElementById("BUpdate");
			if (obj) obj.onclick=BUpdate_Click;			
			var obj=document.getElementById("BDelete");
			if (obj) obj.onclick=BDelete_Click;	
		}
		//�Ѿ����ɲ��������
		if(oResult[0]== "1")
		{
			DisableBElement("BAudit",true);
			DisableBElement("BUpdate",true);
			DisableBElement("BDelete",true);
		}
	}
	else
	{
		alertShow('�������ݳ���,֪ͨ����Ա!');
		window.close();
	}
}
//�������
function SetData(gbldata)
{	
//�¶��۾�״̬ ^ �¶��۾�ID ^ �豸ԭֵ ^ �������� ^ ʹ������ ^ ��ֵ ^ ��ֵ ^ �³��ۼƹ����� ^ ���¹�����^�Ѽ����۾�����^�����۾ɽ��^�۾��·�^��ע^��λ^��λID^�³��ۼ��۾ɽ��
	SetElement("EquipDR",EquipId);
	SetElement("DepreMethodDr",DepreMethodId);	
	SetElement("CostAllotDR","0");
	if (gbldata[1]=="")
	{
		SetElement("DepreSetDR",DepreSetId);
	}
	else
	{
		SetElement("DepreSetDR",gbldata[18]);
		SetElement("EquipDR",gbldata[19])
	}
	SetElement("AllotFlag","N");//�ѷ��䲻���޸�
	SetElement("MainFlag","N");//�����
	SetElement("Status",gbldata[0]);
	SetElement("RowID",gbldata[1]);	
	SetElement("OriginalValueFee",gbldata[2]);
	SetElement("DesignWorkLoadNum",gbldata[3]);	
	SetElement("LimitYearsNum",gbldata[4]);
	SetElement("NetValueFee",gbldata[5]);
	SetElement("NetRemainValueFee",gbldata[6]);
	SetElement("PreTotalWorkload",gbldata[7]);
	SetElement("WorkLoadNum",gbldata[8]);
	SetElement("DepreMonthsNum",gbldata[9]);
	SetElement("DepreFee",formatFloat(gbldata[10],2));
	SetElement("DepreMonth",gbldata[11]);
	SetElement("Remark",gbldata[12]);
	SetElement("WorkLoadUnit",gbldata[13]);
	SetElement("WorkLoadUnitDR",gbldata[14]);
	SetElement("PreTotalDepre",formatFloat(gbldata[15],2));
	SetElement("DepreMethod",gbldata[17]);
	SetElement("DepreMethodDr",gbldata[16]);
}
	
function BAudit_Click() 
{
	var sqlStr="";
	var encmeth=GetElementValue("AuditExec");
	if (encmeth=="")
	{
		alertShow(t[-4001]);
		return;
	}
	var RowID=GetElementValue("RowID")
	if (RowID=="")
	{
		alertShow(t[-4002])
		return
	}
	var DepreSetDR=GetElementValue("DepreSetDR")
	var User=curUserID
	var result=cspRunServerMethod(encmeth,RowID,GetElementValue("DepreMonth"),DepreSetDR,User);//DepreSetId		
	if (result=="0")
	{
		parent.DHCEQMonthDepreFind.location.reload();
		parent.DHCEQMonthDepre.location.reload();	
		//opener.parent.DHCEQDepreSet.SetElement("PreDepreMonth",GetElementValue("DepreMonth"));
	}
	else
	{
		alertShow(t[-2012]);		
	}
}

function BUpdate_Click() 
{
	if (CheckMustItemNull()) return true;
	var MonthStr=GetElementValue("DepreMonth");
	var encmeth=GetElementValue("GetExecMethod");
	var sqlVal="";
	var result="";
	if (encmeth=="")
	{
		alertShow(t[-4001]);
		return;
	}		
	sqlVal=GetElementValue("EquipDR") + "^" + GetElementValue("DepreSetDR") + "^N^" + GetElementValue("DepreMethodDr") + "^" + GetElementValue("OriginalValueFee") + "^" + GetElementValue("DepreMonth") + "^" + GetElementValue("DesignWorkLoadNum") + "^" + GetElementValue("WorkLoadUnitDR") + "^" + GetElementValue("LimitYearsNum") + "^" + GetElementValue("DepreMonthsNum") + "^" + GetElementValue("PreTotalWorkload") + "^" + GetElementValue("PreTotalDepre") + "^" + GetElementValue("WorkLoadNum") + "^" + GetElementValue("DepreFee") + "^" + GetElementValue("CostAllotDR") + "^" + GetElementValue("NetValueFee") + "^" + GetElementValue("NetRemainValueFee") + "^N^0^" + GetElementValue("Remark") + "^" + curUserID;
	result=cspRunServerMethod(encmeth,"0",GetElementValue("RowID"),sqlVal);
	if (result>0)
	{
		parent.DHCEQMonthDepreFind.location.reload();
		parent.DHCEQMonthDepre.location.reload();
	}
	else
	{
		alertShow(result);
	}
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
		var result=cspRunServerMethod(encmeth,"2",GetElementValue("RowID"),"");
		if (result=="0")
		{
			parent.DHCEQMonthDepreFind.location.reload();
			parent.DHCEQMonthDepre.location.reload();
		}
		else
		{
			alertShow('ɾ��ʧ��!');			
		}
    }
}
function GetUnitID(value)
{	
	GetTheLook('WorkLoadUnit','WorkLoadUnitDR',value);	
}
function GetTheLook(ename0,ename1,value)
{
	var val=value.split("^");	
	var obj0=document.getElementById(ename0);
	if (obj0)	{	obj0.value=val[0];	}
	var obj1=document.getElementById(ename1);
	if (obj1)	{	obj1.value=val[1];	}	
}
	
document.body.onload = BodyLoadHandler;
