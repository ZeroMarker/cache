/// DHCEQPayRequestNew.js
var selectrow=0;

///��¼ �豸 RowID �����ظ�ѡ��RowID������
var ObjSources=new Array();

//���һ������Ԫ�ص����ֵĺ�׺���
var LastNameIndex;
//����һ������Ԫ�ص����ֵĺ�׺���
var NewNameIndex;
var TotalFee=0;
var CheckLocFlag=0;	//�������Ƿ�һ�±�־
var tmpLoc="";
function BodyLoadHandler() 
{
	KeyUp("Loc^Provider","N");
	
	InitUserInfo();
	InitPage();	
	FillData();
	SetEnabled();
	SetTableItem('','','');
	Muilt_LookUp("Loc^Provider");
	if (GetElementValue("PayFromType")==3) SetElement("PurposeType",0);		// �������֧ȡĬ����;
	SetElement("SourceType",GetElementValue("SourceTypeVal"));
}
function InitPage()
{
	var obj=document.getElementById("BFind");
	if (obj) obj.onclick=BFind_Clicked;	//modified by 20150914 ZY0141
	var obj=document.getElementById("BUpdate");
	if (obj) obj.onclick=BUpdate_Clicked;
	var obj=document.getElementById("BDelete");
	if (obj) obj.onclick=BDelete_Clicked;
	var obj=document.getElementById("BSubmit");
	if (obj) obj.onclick=BSubmit_Clicked;
	var obj=document.getElementById("BCancelSubmit");		// ȡ���ύ
	if (obj) obj.onclick=BCancelSubmit_Clicked;
	var obj=document.getElementById("BAudit");
	if (obj) obj.onclick=BAudit_Click;
	var obj=document.getElementById("BPrint");
	if (obj) obj.onclick=BPrint_Clicked;
	var obj=document.getElementById("BAdd");
	if (obj) obj.onclick=AddClickHandler;
	var obj=document.getElementById("BInvalid");		// ����
	if (obj) obj.onclick=BInvalid_Clicked;
	var obj=document.getElementById("BPrintNew");
	if (obj) obj.onclick=BPrintNew_Clicked;
}
function FillData()
{
	var obj=document.getElementById("RowID");
	var RowID=obj.value;
	if ((RowID=="")||(RowID<1))
	{
		return;
	}
	var obj=document.getElementById("fillData");
	if (obj){var encmeth=obj.value} else {var encmeth=""};
	var ReturnList=cspRunServerMethod(encmeth,RowID);
	ReturnList=ReturnList.replace(/\\n/g,"\n");
	//alertShow(ReturnList)
	list=ReturnList.split("^");
	var sort=33;
	SetElement("PayRequestNo",list[0]);
	SetElement("MakeDate",list[1]);
	SetElement("LocDR",list[2]);
	SetElement("Loc",list[sort+0]);
	SetElement("ProviderDR",list[3]);
	SetElement("Provider",list[sort+1]);
	SetElement("Bank",list[4]);
	SetElement("BankAccount",list[5]);
	SetElement("AccountDate",list[6]);
	SetElement("TotalFee",list[7]);
	TotalFee=parseFloat(list[7])
	if (isNaN(TotalFee))
	{
		TotalFee=0
	}
	SetElement("TotalFeeA",list[sort+2]);
	SetElement("PurposeType",list[8]);
	SetElement("PayMode",list[9]);
	SetElement("Agent",list[10]);
	SetElement("Status",list[11]);
	SetElement("Remark",list[12]);
	SetElement("PayFromType",list[26]);
	SetElement("SourceType",list[27]);
	SetElement("Hold1",list[28]);
	SetChkElement("Hold2",list[29]);
	SetElement("Hold3",list[30]);
	SetChkElement("Hold4",list[31]);	//Mozy0203	20180224
	SetElement("Hold5",list[32]);
}
function SetEnabled()
{
	var Status=GetElementValue("Status");
	var Type=GetElementValue("Type");  //modified by zy 2015-08-21 ZY0135
	//alertShow("Status="+Status)
	if (Status=="")
	{
		DisableBElement("BDelete",true);
		DisableBElement("BSubmit",true);
		DisableBElement("BAudit",true);
		DisableBElement("BCancelSubmit",true);
		DisableBElement("BInvalid",true);
	}
	if (Status==0)
	{
		DisableBElement("BCancelSubmit",true);
		DisableBElement("BAudit",true);
		DisableBElement("BInvalid",true);
	}
	if (Status==1)
	{
		DisableBElement("BFind",true);
		DisableBElement("BAdd",true);
		DisableBElement("BUpdate",true);
		DisableBElement("BDelete",true);
		DisableBElement("BSubmit",true);
		DisableBElement("BInvalid",true);
	}
	if (Status==2)
	{
		DisableBElement("BFind",true);
		DisableBElement("BAdd",true);
		DisableBElement("BUpdate",true);
		DisableBElement("BDelete",true);
		DisableBElement("BSubmit",true);
		DisableBElement("BAudit",true);
		DisableBElement("BCancelSubmit",true);
	}
	if (Status==3)
	{
		DisableBElement("BFind",true);
		DisableBElement("BAdd",true);
		DisableBElement("BUpdate",true);
		DisableBElement("BDelete",true);
		DisableBElement("BSubmit",true);
		DisableBElement("BCancelSubmit",true);
		DisableBElement("BAudit",true);
		DisableBElement("BInvalid",true);
	}
	//��˺�ſɴ�ӡ������ת�Ƶ�
	if (Status!="2")
	{
		DisableBElement("BPrint",true);
		DisableBElement("BPrintNew",true);
	}
	//modified by zy 2015-08-21 ZY0135
	if (Type=="0")
	{
		DisableBElement("BAudit",true);	
		DisableBElement("BPrint",true);
		DisableBElement("BPrintNew",true);
		DisableBElement("BCancelSubmit",true);
	}
	else if (Type=="1")
	{
		DisableBElement("BFind",true);
		DisableBElement("BAdd",true);
		DisableBElement("BUpdate",true);
		DisableBElement("BDelete",true);
		DisableBElement("BSubmit",true);
	}
	else if (Type=="2")//�������뵥��ϸ�Ĳ�������285147 Add BY BRB 2016-11-10
	{
		DisableBElement("BFind",true);
		DisableBElement("BAdd",true);
		DisableBElement("BUpdate",true);
		DisableBElement("BDelete",true);
		DisableBElement("BSubmit",true);
		DisableBElement("BCancelSubmit",true);
		DisableBElement("BAudit",true);
		DisableBElement("BInvalid",true);
	}
}
//20150929 ZY0145�������뵥�����޸�,���Ҳ�������Ϣ;
function BFind_Clicked()
{
	if (CheckNull()) return;
	var val="";
  	val="&RowID="+GetElementValue("RowID");
  	val=val+"&PayFromType="+GetElementValue("PayFromType");
  	val=val+"&ProviderDR="+GetElementValue("ProviderDR");
  	val=val+"&Provider="+GetElementValue("Provider");
  	val=val+"&SourceType="+GetElementValue("SourceType");
  	val=val+"&Type="+GetElementValue("Type");
  	if (GetChkElementValue("Hold4")==true) val=val+"&Hold4=1";	//Mozy0203	20180224
  	val=val+"&Bank="+GetElementValue("Bank");                //add by kdf 2017-11-14 ����ţ�468628
  	val=val+"&BankAccount="+GetElementValue("BankAccount");  //add by kdf 2017-11-14 ����ţ�468628
  	
  	var str="websys.default.csp?WEBSYS.TCOMPONENT=DHCEQPayRequestNew"+val
	window.location.href=str;
}
//modified by 20150914 ZY0141
function BUpdate_Clicked()
{
	if (CheckNull()) return;
	var combindata="";
  	combindata=GetElementValue("RowID");
  	combindata=combindata+"^"+GetElementValue("PayRequestNo");
  	combindata=combindata+"^"+GetElementValue("MakeDate");
  	combindata=combindata+"^"+GetElementValue("LocDR");
  	combindata=combindata+"^"+GetElementValue("ProviderDR");
  	combindata=combindata+"^"+GetElementValue("Bank");
	combindata=combindata+"^"+GetElementValue("BankAccount");
	combindata=combindata+"^"+GetElementValue("AccountDate");
  	combindata=combindata+"^"+GetElementValue("TotalFee");	//���ڽ����ٷ�λ���ʺ�ֱ�Ӵ洢,���ܽ���������ʱ����ϸ����ȡ
  	combindata=combindata+"^"+GetElementValue("PurposeType");
  	combindata=combindata+"^"+GetElementValue("PayMode");
  	combindata=combindata+"^"+GetElementValue("Agent");
  	//combindata=combindata+"^"+GetElementValue("Status");
  	combindata=combindata+"^"+GetElementValue("Remark");
  	combindata=combindata+"^"+GetElementValue("PayFromType");	//����ҵ������	�豸1��ά��2�����3
  	combindata=combindata+"^"+GetElementValue("SourceType");	//ҵ������
  	combindata=combindata+"^"+GetElementValue("Hold1");
  	combindata=combindata+"^"+GetChkElementValue("Hold2");
  	combindata=combindata+"^"+GetElementValue("Hold3");
  	combindata=combindata+"^"+GetChkElementValue("Hold4");		//Mozy0203	20180224
  	combindata=combindata+"^"+GetElementValue("Hold5");
  	var valList=GetTableInfo();
  	if (valList=="-1")
  	{
	  	alertShow("û��ѡ����ϸ!��ѡ����ϸ!")
	  	return;
	}
  	var DelRowid=tableList.toString();
  	var encmeth=GetElementValue("Update");
  	if (encmeth=="") return;
  	//alertShow(DelRowid)
	//var Rtn=cspRunServerMethod(encmeth,combindata,valList,DelRowid);
	var Rtn=cspRunServerMethod(encmeth,combindata,valList,"");
	if (Rtn>0)
    {
		var val="&RowID="+Rtn;
		val=val+"&PayFromType="+GetElementValue("PayFromType");
		val=val+"&SourceType="+GetElementValue("SourceType");
	  	val=val+"&ProviderDR="+GetElementValue("ProviderDR");
	  	val=val+"&Provider="+GetElementValue("Provider");
		val=val+"&Type="+GetElementValue("Type");  //modified by zy 2015-08-21 ZY0135
		if (GetChkElementValue("Hold4")==true) val=val+"&Hold4=1";	//Mozy0203	20180224
		//window.location.href="websys.default.csp?WEBSYS.TCOMPONENT=DHCEQPayRequestNew"+val;
		var url=window.location.href //GR0026 �´��ڴ�ģ̬����,ͨ���ı����ֵ���Ԥ�������⣿
	    if(url.indexOf("killcache=1")!=-1)  window.location.href='websys.default.csp?WEBSYS.TCOMPONENT=DHCEQPayRequestNew&killcache=0'+val;
	    else 								window.location.href='websys.default.csp?WEBSYS.TCOMPONENT=DHCEQPayRequestNew&killcache=0'+val;
	}
    else
    {
	    alertShow(Rtn);
    }
}
function BDelete_Clicked()
{
	var truthBeTold = window.confirm("ȷ��Ҫɾ����ƾ��?");
	if (!truthBeTold) return;
	var RowID=GetElementValue("RowID")
  	var encmeth=GetElementValue("DeleteData")
  	if (encmeth=="") return;
	var Rtn=cspRunServerMethod(encmeth,RowID);
	if (Rtn=="0")
    {
		var val="&PayFromType="+GetElementValue("PayFromType");
	  	val=val+"&ProviderDR="+GetElementValue("ProviderDR");
	  	val=val+"&Provider="+GetElementValue("Provider");
	  	val=val+"&SourceType="+GetElementValue("SourceType");
		val=val+"&Type="+GetElementValue("Type");  //modified by zy 2015-08-21 ZY0135
		//window.location.href="websys.default.csp?WEBSYS.TCOMPONENT=DHCEQPayRequestNew"+val;
		var url=window.location.href //GR0026 �´��ڴ�ģ̬����,ͨ���ı����ֵ���Ԥ�������⣿
	    if(url.indexOf("killcache=1")!=-1)  window.location.href='websys.default.csp?WEBSYS.TCOMPONENT=DHCEQPayRequestNew&killcache=0'+val; // Mozy		880894	2019-5-10
	    else 								window.location.href='websys.default.csp?WEBSYS.TCOMPONENT=DHCEQPayRequestNew&killcache=1'+val;
	}
    else
    {
	    alertShow(Rtn);
    }
}
function BSubmit_Clicked()
{
	var rowid=GetElementValue("RowID");
	if (rowid=="") retrun;
  	var valList=GetTableInfo("0");
  	if (valList=="-1")
  	{
	  	alertShow("û��ѡ����ϸ!��ѡ����ϸ������!")
	  	return;
	}
	if (CheckLocFlag!=0)
	{
		alertShow("���Ҳ�һ��!");
		return;
	}
	var encmeth=GetElementValue("SubmitData");
	if (encmeth=="") return;
	var result=cspRunServerMethod(encmeth,rowid);
	if (result<0)
	{
		alertShow(result);
	}
	else
	{
		//modify by mwz 20171108 �����467490
		var val="&RowID="+rowid;
		val=val+"&PayFromType="+GetElementValue("PayFromType");
		val=val+"&SourceType="+GetElementValue("SourceType");
	  	val=val+"&ProviderDR="+GetElementValue("ProviderDR");
	  	val=val+"&Provider="+GetElementValue("Provider");
		val=val+"&Type=2";  
		var url=window.location.href //GR0026 �´��ڴ�ģ̬����,ͨ���ı����ֵ���Ԥ�������⣿
	    if(url.indexOf("killcache=1")!=-1)  window.location.href='websys.default.csp?WEBSYS.TCOMPONENT=DHCEQPayRequestNew&killcache=0'+val;
	    else 								window.location.href='websys.default.csp?WEBSYS.TCOMPONENT=DHCEQPayRequestNew&killcache=0'+val; 
	}
}
function BInvalid_Clicked() // ����
{
	var truthBeTold = window.confirm("ȷ��Ҫ���ϸõ�����?");
    if (truthBeTold)
    {
		CancelSubmit("1");
	}
}
function BCancelSubmit_Clicked() //  ȡ���ύ
{
	CancelSubmit("0")
}
function CancelSubmit(InvalidFlag)
{
	var rowid=GetElementValue("RowID");
	if (rowid=="") retrun;
	var encmeth=GetElementValue("CancelSubmitData");
	if (encmeth=="") return;
	var result=cspRunServerMethod(encmeth,rowid,InvalidFlag);
	if (result<0)
	{	
		alertShow(result);
	}
	else
	{
		var url=window.location.href
	    if(url.indexOf("killcache=1")!=-1)  url=url.replace(/killcache=1/,"killcache=0") //GR0026 �´��ڴ�ģ̬����,ͨ���ı����ֵ���Ԥ�������⣿
	    else 								url=url.replace(/killcache=0/,"killcache=1")
	    window.location.href=url 
	}
}
function BAudit_Click()
{
	var rowid=GetElementValue("RowID");
	if (rowid=="") retrun;
  	var valList=GetTableInfo("0");
  	if (valList=="-1")
  	{
	  	alertShow("û��ѡ����ϸ!��ѡ����ϸ������!")
	  	return;
	}
	var encmeth=GetElementValue("AuditData");
	if (encmeth=="") return;
	var result=cspRunServerMethod(encmeth,rowid,valList);
	if (result<0)
	{
		alertShow(result);
	}
	else
	{
		//location.reload();	
		var url=window.location.href
	    if(url.indexOf("killcache=1")!=-1)  url=url.replace(/killcache=1/,"killcache=0") //GR0026 �´��ڴ�ģ̬����,ͨ���ı����ֵ���Ԥ�������⣿
	    else 								url=url.replace(/killcache=0/,"killcache=1")
	    window.location.href=url 
	}
}

function SetTableItem(RowNo,SourceType,selectrow)
{
	var objtbl=document.getElementById('tDHCEQPayRequestNew');
	var rows=objtbl.rows.length-1;
	if (RowNo=="")
	{
		for (var i=1;i<=rows;i++)
		{
			var TSourceID=document.getElementById("TSourceIDz"+i).value;
			var TSourceType=GetElementValue("TSourceTypeDRz"+i);
			ObjSources[i]=new SourceInfo(TSourceType,TSourceID);
			tableList[i]=0;
			var TRowID=document.getElementById("TRowIDz"+i).value;
			var TotalFlag=GetElementValue("TotalFlag");
			if (TRowID==-1)
			{
				if ((TotalFlag==1)||(TotalFlag==2))
				{
					obj=document.getElementById("TRowz"+i);
					if (obj) obj.innerText="�ϼ�:"
					obj=document.getElementById("TFlagz"+i);
					if (obj) obj.innerText="";
					tableList[i]=-1;
					continue;
				}
			}
			ChangeRowStyle(objtbl.rows[i],SourceType);		///�ı�һ�е�������ʾ
		}
	}
	else
	{
		if (selectrow=='') selectrow=RowNo;
		tableList[RowNo]=0;
		ChangeRowStyle(objtbl.rows[selectrow],SourceType);	///�ı�һ�е�������ʾ
	}
}
///�ı�һ�е�������ʾ
function ChangeRowStyle(RowObj,SourceType)
{
	var Status=GetElementValue("Status");
	for (var j=0;j<RowObj.cells.length;j++)
	{
		var html="";
		var value="";

    	if (!RowObj.cells[j].firstChild) {continue}
		var Id=RowObj.cells[j].firstChild.id;
		var offset=Id.lastIndexOf("z");
		var objindex=Id.substring(offset+1);
		var colName=Id.substring(0,offset);
		var objwidth=RowObj.cells[j].style.width;
		var objheight=RowObj.cells[j].style.height;
		if (colName=="TAmountFee")
		{
			if (CheckUnEditField(Status,colName)) continue;
			value=document.getElementById(Id).innerText;
       		html=CreatElementHtml(1,Id,objwidth,objheight,"KeyDown_Tab","Flag_Change","","SumList_Change")	
			var objTSourceType=document.getElementById(Id);
			if(objTSourceType)
			{
				objTSourceType.onkeypress=NumberPressHandler
			}
		}
		else if (colName=="TFlag")
		{
			if (CheckUnEditField(Status,colName)) continue;
			value=GetCElementValue(Id)
			html=CreatElementHtml(5,Id,objwidth,objheight,"SetAmountFee","","","")
			/*
			if (Status>0)
			{
				HiddenObj(colName+"z"+objindex,1)
				continue;
			}
			RowObj.cells[j].onclick=DeleteClickHandler;
			*/
		}else if (colName=="BDeleteList")
		{
		///�޸��ύ���״̬��ɾ����ť��ʾ   �����279466  modify by mwz 2016-11-08
			if (Status>0)
			{
				HiddenObj(colName+"z"+objindex,1)
				continue;
			}
			RowObj.cells[j].onclick=DeleteClickHandler;
		}
		if (html!="") RowObj.cells[j].innerHTML=html;
	    if (value!="")
	    {
		    value=trim(value);
		    if (RowObj.cells[j].firstChild.tagName=="LABEL")
		    {
			    RowObj.cells[j].firstChild.innerText=value;
			}
			else if ((RowObj.cells[j].firstChild.tagName=="INPUT")&&(RowObj.cells[j].firstChild.type=="checkbox"))
		    {
			    RowObj.cells[j].firstChild.checked=value;
			}
			else
		    {
			    RowObj.cells[j].firstChild.value=value;
		    }
	    }
	}
}

function Flag_Change()
{
	selectrow=GetTableCurRow();
	var TAmountFee=parseFloat(GetElementValue("TAmountFeez"+selectrow));
	var TNeedPayFee=parseFloat(GetElementValue("TNeedPayFeez"+selectrow))
	if (TAmountFee>0)
	{
		if (TAmountFee>TNeedPayFee)
		{
			alertShow("������ܴ���δ�����!")
			return
		}	
		SetElement('TFlagz'+selectrow,1);
	}
	else
	{
		SetElement('TFlagz'+selectrow,0);
	}
}
function Clear()
{
	SetElement("TSourceIDz"+selectrow,"");
	SetElement("TSourceNoz"+selectrow,"");
	SetElement("TExtendTypez"+selectrow,"");
	SetElement("TExtendIDz"+selectrow,"");
	SetElement("TExtendNoz"+selectrow,"");
	SetElement("TExtendDatez"+selectrow,"");
	SetElement("TEquipNamez"+selectrow,"");
	SetElement("TManuFactoryz"+selectrow,"");
	SetElement("TOriginalFeez"+selectrow,"");
	SetElement("TQuantityNumz"+selectrow,"");
	SetElement("TTotalFeez"+selectrow,"");
}
//modified by 20150914 ZY0141
function GetTableInfo()
{
    var objtbl=document.getElementById('tDHCEQPayRequestNew');
	var rows=tableList.length;
	var valList="";
	var flag=0;
	for(var i=1;i<rows;i++)
	{
		var TFlag=GetElementValue("TFlagz"+i);
		if (TFlag=="Y") TFlag=true
		if (TFlag==true) flag=1
		var TRow=GetCElementValue("TRowz"+i);
		var TRowID=GetElementValue("TRowIDz"+i);
		var TSourceType=GetElementValue("TSourceTypeDRz"+i);
		var TSourceID=GetElementValue("TSourceIDz"+i);
		if (TSourceID=="")
		{
			alertShow("��"+TRow+"��,��ѡ����ȷ���豸ҵ��.")
			return "-1";
		}
		var TAmountFee=GetElementValue("TAmountFeez"+i);
		var TTotalFee=GetElementValue("TTotalFeez"+i);	//�ܽ��
		var TPaedFee=GetElementValue("TPaedFeez"+i);	//�Ѹ����
		var TNeedPayFee=GetElementValue("TNeedPayFeez"+i);	//δ�����
		var TRemark=GetElementValue("TRemarkz"+i);
		/// 20150922  Mozy0166
		if (parseFloat(TAmountFee)>parseFloat(TNeedPayFee))
		{
			alertShow("��"+TRow+"��,ҵ�񵥸������δ�����.")
			return "-1";
		}
		var TListInfo=GetElementValue("TListInfoz"+i);
		if (TFlag)
		{
			if (tmpLoc=="") tmpLoc=GetElementValue("TLocz"+i);
			if (tmpLoc!=GetElementValue("TLocz"+i)) CheckLocFlag=-1;
		}
		if(valList!="") valList=valList+"&";
		valList=valList+TFlag+"^"+TRow+"^"+TRowID+"^"+TSourceType+"^"+TSourceID+"^"+TAmountFee+"^"+TTotalFee+"^"+TPaedFee+"^"+TNeedPayFee+"^"+TRemark+"^"+TListInfo;
	}
	if (flag==0) return "-1"
	return  valList
}

function SumList_Change()
{
	var length=tableList.length
	var Fee=0
	for (var i=1;i<length;i++)
	{
		if (tableList[i]=="0")
		{
			var TAmountFee=parseFloat(GetElementValue("TAmountFeez"+i))
			var TNeedPayFee=parseFloat(GetElementValue("TNeedPayFeez"+i));
			var TRow=GetElementValue("TRowz"+i);
			if (isNaN(TAmountFee)) continue;
			if (isNaN(TNeedPayFee)) continue;
			if (TAmountFee>TNeedPayFee)
			{
				alertShow("��"+TRow+"�и��������δ�����!")
				SetElement('TAmountFeez'+i,"")
				SetElement('TFlagz'+i,0)
				continue
			}
			Fee=Fee+TAmountFee;
		}
		else if (tableList[i]==-1)
		{
			var index=i
		}
	}
	//SetElement('TAmountFeez'+index,Fee.toFixed(2));
	SetElement('TotalFee',Fee.toFixed(2))
	//ModiFied By QW20190312 BUG:844060
	SetElement('TotalFeeA',"")
	if (Fee!=0) SetElement('TotalFeeA',ChineseNum(Fee))
	//End By QW20190312 BUG:844060
}

function GetValueList()
{
	var ValueList="";
	ValueList=GetElementValue("RowID");
	ValueList=ValueList+"^"+GetElementValue("EquipTypeDR");
	ValueList=ValueList+"^"+curUserID;
	
	return ValueList;
}
function GetEquipType (value)
{
    GetLookUpID("EquipTypeDR",value);
}
function GetProvider (value)
{
	var list=value.split("^")
	SetElement("ProviderDR",list[1])
	SetElement("Provider",list[0])
	SetElement("Bank",list[7])
	SetElement("BankAccount",list[8])
}
function CheckNull()
{
	if (CheckMustItemNull()) return true;
	return false;
}
function BPrint_Clicked()
{
	var RowID=GetElementValue("RowID");
	if (RowID=="") return;
	var encmetha=GetElementValue("fillData");
	if (encmetha=="") return;
	var ReturnList=cspRunServerMethod(encmetha,RowID);
	ReturnList=ReturnList.replace(/\\n/g,"\n");
	var list=ReturnList.split("^");
	//alertShow(ReturnList);
	var OtherInfo=list[35]	
	var OtherInfoList=OtherInfo.split("#");
	var len=OtherInfoList.length
	var AllFee=""
	var Hold1=0
	var InvoicesNum=0
	for (var i=0;i<len-1;i++)
	{
		var OtherStr=OtherInfoList[i]
		var OtherStr=OtherStr.split("$");
		if (AllFee=="")
		{
			
			AllFee=OtherStr[0]+":"+OtherStr[1]
		}
		else
		{
			AllFee=AllFee+","+OtherStr[0]+":"+OtherStr[1]
		}
		var Hold1=Hold1+parseFloat(OtherStr[3])
		var Invoices=OtherStr[4].split(",")
		var InvoicesNum=InvoicesNum+Invoices.length
	}

	var InStockS=OtherInfoList[len-1].split(",")
	InStockS=InStockS.length
	var encmeth=GetElementValue("GetRepPath");
	if (encmeth=="") return;
	var	TemplatePath=cspRunServerMethod(encmeth);
	
	try
	{
        var xlApp,xlsheet,xlBook;
	    var Template=TemplatePath+"DHCEQPayRequestNew.xls";
	    xlApp = new ActiveXObject("Excel.Application");
    	xlBook = xlApp.Workbooks.Add(Template);
	   	xlsheet = xlBook.ActiveSheet;
	    var sort=33;
	    //ҽԺ�����滻
	    xlsheet.cells.replace("[Hospital]",GetElementValue("GetHospitalDesc"));
    	//xlsheet.cells(2,3)=list[sort+1];  //�ջ���λ
    	//xlsheet.cells(2,5)=list[4];		  //������
    	//xlsheet.cells(3,5)=list[5];	  	//�ʺ�
		//xlsheet.cells(4,2)="��Ʊ��( "+list[26]+" )��";
		//xlsheet.cells(4,3)="������:"+list[7];	//Сд
    	//xlsheet.cells(4,4)=list[sort+2];  //��д;
    	//xlsheet.cells(3,2)=AllFee+"Ԫ";    //�豸���
    	//xlsheet.cells(3,8)=list[0];    //�����

    	//xlsheet.cells(4,2)=ChangeDateFormat(list[6]);    //��������
    	xlsheet.cells(5,2)="��Ʊ( "+InvoicesNum+" )��";    //��Ʊ����
    	//if(Hold1==0) Hold1=""
    	//xlsheet.cells(4,6)=Hold1+"��";    //������������
    	//xlsheet.cells(4,8)=InStockS+"��";    //rukudan����

    	xlsheet.cells(3,3)=list[sort+1];  //��Ӧ��
    	xlsheet.cells(3,5)=list[4];       //������
    	xlsheet.cells(4,5)=list[5];       //�˺�
		//xlsheet.cells(3,4)=list[4];       //PN_ProviderDR
		xlsheet.cells(5,4)="��д:   "+list[sort+2];  //��д���
		xlsheet.cells(5,3)="������:"+list[7]+"Ԫ";       //Сд���
    	//xlsheet.cells(5,4)=ChangeDateFormat(list[6]);  //��������
    	//xlsheet.cells(9,3)=list[8];//������;
    	//xlsheet.cells(7,2)=list[9];//���ʽ
		//xlsheet.cells(6,5)=list[10];  //������
    	//xlsheet.cells(7,6)=list[sort+3];//������
		var obj = new ActiveXObject("PaperSet.GetPrintInfo");
		var size=obj.GetPaperInfo("DHCEQInStock");
		if (0!=size) xlsheet.PageSetup.PaperSize = size;
		
		xlApp.Visible=true;
	    //xlsheet.PrintPreview();
		xlsheet.printout; 	//��ӡ���
		//xlBook.SaveAs("D:\\InStock"+i+".xls");
		xlBook.Close (savechanges=false);
		xlsheet.Quit;
		xlsheet=null;
	    xlApp=null;
	} 
	catch(e)
	{
		alertShow(e.message);
	}
}
function SetAmountFee()
{
	selectrow=GetTableCurRow();
	var encmeth=GetElementValue("CheckSourceID");
	if (encmeth=="") return;
	var CheckResult=cspRunServerMethod(encmeth,GetElementValue("RowID"),GetElementValue("TSourceTypeDRz"+selectrow),GetElementValue("TSourceIDz"+selectrow),GetElementValue("TNeedPayFeez"+selectrow));
	var list=CheckResult.split("^");
	var CheckFlag=GetChkElementValue('TFlagz'+selectrow);			//Add By DJ 2015-12-23
	if ((CheckFlag==true)&&(list[0]>0))								//Add By DJ 2015-12-23
	{
		SetChkElement('TFlagz'+selectrow,"0");
		alertShow("��ǰ��¼��"+list[0]+"����������û�в�����ϵĸ����¼.������"+list[1]+".���Ȳ������ⵥ��!")
		return
	}
	var TFlag=GetElementValue("TFlagz"+selectrow);
	//ModiFied By QW20190312 BUG:844060
	var TNeedPayFee=GetElementValue("TNeedPayFeez"+selectrow);
	if (TNeedPayFee=="") TNeedPayFee=0
	TNeedPayFee=parseFloat(TNeedPayFee);
	var TAmountFee=GetElementValue("TAmountFeez"+selectrow)
	if (TAmountFee=="") TAmountFee=0
	TAmountFee=parseFloat(TAmountFee);
	var TotalFee=GetElementValue("TotalFee")
	if (TotalFee=="") TotalFee=0
	TotalFee=parseFloat(TotalFee);
	//End By QW20190312 BUG:844060
	if (TFlag==true)
	{
		if (TAmountFee>0)
		{
			TotalFee=TotalFee+TAmountFee
		}
		else
		{
			TotalFee=TotalFee+TNeedPayFee
			SetElement('TAmountFeez'+selectrow,TNeedPayFee.toFixed(2));
		}
	}
	else
	{
		TotalFee=TotalFee-TAmountFee;  //ModiFied By QW20190312 BUG:844060
		SetElement('TAmountFeez'+selectrow,"");
	}
	
	SetElement('TotalFee',TotalFee.toFixed(2))
	//ModiFied By QW20190312 BUG:844060
	SetElement('TotalFeeA',"")
	if (TotalFee!=0) SetElement('TotalFeeA',ChineseNum(TotalFee))
	//End By QW20190312 BUG:844060
}
//add by wl 2019-11-21 WL0013
function BPrintNew_Clicked()
{ 
	var RowID=GetElementValue("RowID");
	if  (RowID=="" ) return;
	var HOSPDESC = GetElementValue("GetHospitalDesc");
	var USERNAME = curUserName;
	var PrintFlag = GetElementValue("PrintFlag");	 //��ӡ��ʽ��־λ excel��0  ��Ǭ:1   
	var PreviewRptFlag = GetElementValue("PreviewRptFlag"); //��ǬԤ����־ ��Ԥ�� :0  Ԥ�� :1
	var CurGroupID = session['LOGON.GROUPID']
	var HOSPDESC = GetElementValue("GetHospitalDesc");
		//Excel��ӡ��ʽ
	if(PrintFlag==0)  
	{
		PrintNewExcel();
	}
	//��Ǭ��ӡ
	if(PrintFlag==1)
	{
		if(PreviewRptFlag==0)
		{ 
		    fileName="{DHCEQPayRequestList.raq(PayRequestDR="+RowID
		    +";CurGroupID="+CurGroupID
		    +";HOSPDESC="+HOSPDESC
		    +";USERNAME="+USERNAME
		    +")}";
	        DHCCPM_RQDirectPrint(fileName);		
		}
		if(PreviewRptFlag==1)
		{ 
			fileName="DHCEQPayRequestList.raq&PayRequestDR="+RowID
		    +"&CurGroupID="+CurGroupID
		    +"&HOSPDESC="+HOSPDESC
		    +"&USERNAME="+USERNAME
			DHCCPM_RQPrint(fileName);
		}
	}
}
//modify by wl 2019-11-21 WL0013
function PrintNewExcel()
{
	var RowID=GetElementValue("RowID");
	if (RowID=="") return;
	var encmetha=GetElementValue("fillData");
	if (encmetha=="") return;
	var ReturnList=cspRunServerMethod(encmetha,RowID);	//������Ϣ
	ReturnList=ReturnList.replace(/\\n/g,"\n");
	//alertShow(ReturnList)
	var lista=ReturnList.split("^");
	var encmeth=GetElementValue("GetListNew");		//��ϸ������Ϣ
	if (encmeth=="") return;
	var gbldata=cspRunServerMethod(encmeth,RowID);
	//alertShow(RowID+":"+gbldata);
	var list=gbldata.split(GetElementValue("SplitNumCode"));
	var Listall=list[0];
	rows=list[1];
	var PageRows=17;
	var ModRows=rows%PageRows;
	var Pages=parseInt(rows / PageRows);
	if (ModRows==0) {Pages=Pages-1;}
	var encmeth=GetElementValue("GetRepPath");
	if (encmeth=="") return;
	var	TemplatePath=cspRunServerMethod(encmeth);
	
	try
	{
        var xlApp,xlsheet,xlBook;
	    var Template=TemplatePath+"DHCEQPayRequestList.xls";
	    if (lista[3]=571) Template=TemplatePath+"DHCEQPayRequestListQCK.xls";	//�豸���ĿƲֿ�
	    xlApp = new ActiveXObject("Excel.Application");
		var flag=0;
	    for (var i=0;i<=Pages;i++)
	    {
	    	xlBook = xlApp.Workbooks.Add(Template);
		   	xlsheet = xlBook.ActiveSheet;
		    var sort=33;
	    	
		    //ҽԺ�����滻
		    xlsheet.cells.replace("[Hospital]",GetElementValue("GetHospitalDesc"));
		    xlsheet.cells(3,1)=xlsheet.cells(3,1)+lista[sort+1];  //��Ӧ��
		    xlsheet.cells(3,4)=xlsheet.cells(3,4)+ChangeDateFormat(lista[1]);  //��������
		    xlsheet.cells(3,8)=lista[0];    //�����
		    //xlsheet.cells(25,1)=xlsheet.cells(25,1)+GetShortName(lista[sort+0],"-");	//�Ʊ�λ
		    xlsheet.cells(25,4)=xlsheet.cells(25,4)+curUserName;	//Mozy	745766	2018-12-2
		    xlsheet.cells(25,8)=ChangeDateFormat(GetCurrentDate());
		    xlsheet.cells(25,10)="��"+(i+1)+"ҳ "+"��"+(Pages+1)+"ҳ";
	    	
	    	var OnePageRow=PageRows;
	   		if ((i==Pages)&&(ModRows!=0)) OnePageRow=ModRows;
	    	for (var j=1;j<=OnePageRow;j++)
			{
				var Lists=Listall.split(GetElementValue("SplitRowCode"));
				var Listl=Lists[i*PageRows+j];
				var List=Listl.split("^");
				//alertShow(List[9])
				var Row=4+j;
				if (List[0]=="�ϼ�")
				{
					xlsheet.cells(22,1)="�ϼ�(��д):"+lista[sort+2];
					xlsheet.cells(22,7)="��:"+List[9];
				}
				else
				{
					xlsheet.cells(Row,1)=j;	//���
		    		xlsheet.cells(Row,2)=List[0];//����
		    		xlsheet.cells(Row,3)=List[1];//�豸����
					xlsheet.cells(Row,4)=List[2];//����
					xlsheet.cells(Row,5)=List[3];//��λ
					xlsheet.cells(Row,6)=List[4];//����
					xlsheet.cells(Row,7)=List[5];//ԭֵ
					xlsheet.cells(Row,8)=List[9];//������		List[6];//���
					xlsheet.cells(Row,9)=List[7];//������Դ
					xlsheet.cells(Row,10)=List[8];//��ŵص�
					if (List[10]==6) flag=1;
				}
				var Row=Row+1;
			}
			if (flag==1) xlsheet.cells(1,1)=xlsheet.cells(1,1)+"(��ֵ)";
			
			xlApp.Visible=true;
		    xlsheet.PrintPreview();
			//xlsheet.printout; 	//��ӡ���
			//xlBook.SaveAs("D:\\InStock"+i+".xls");
			xlBook.Close (savechanges=false);
			xlsheet.Quit;
			xlsheet=null;
	    }
	    xlApp=null;
	} 
	catch(e)
	{
		alertShow(e.message);
	}
}
function DeleteClickHandler()
{
	var truthBeTold = window.confirm(t["-4003"]);
	if (!truthBeTold) return;
	try
	{
		var objtbl=document.getElementById('tDHCEQPayRequestNew');
		var rows=objtbl.rows.length;
		selectrow=GetTableCurRow();
		var PayFromType=GetElementValue("PayFromType");
		var SourceType=GetElementValue("SourceType");
		var TSourceID=GetElementValue("TSourceIDz"+selectrow);
		tableList[selectrow]=TSourceID;
		var delNo=GetElementValue("TRowz"+selectrow);
		//alertShow(PayFromType+","+SourceType+","+TSourceID)
		var encmeth=GetElementValue("InvalidSourceList");
		if (encmeth=="") return;
		var rtn=cspRunServerMethod(encmeth,PayFromType,SourceType,TSourceID,GetChkElementValue("Hold4"));	//Mozy0203	20180224
		if (rtn=="0")
		{
			alertShow("����ʧ��!");
			return;
		}
	    var eSrc=window.event.srcElement;
		var rowObj=getRow(eSrc);
		objtbl.deleteRow(rowObj.rowIndex);
		
		ResetNo(selectrow,delNo);
	} 
	catch(e)
	{};
}
document.body.onload = BodyLoadHandler;