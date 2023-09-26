/// DHCEQAccountNo.js
var selectrow=0;

///��¼ �豸 RowID �����ظ�ѡ��RowID������
var ObjSources=new Array();

//���һ������Ԫ�ص����ֵĺ�׺���
var LastNameIndex;
//����һ������Ԫ�ص����ֵĺ�׺���
var NewNameIndex;

function BodyLoadHandler() 
{
	KeyUp("Loc^Provider^EquipType","N");
	InitUserInfo();		//2013-11-11  Mozy0112 �����û��ȳ�ʼ����Ϣ
	InitPage();	
	FillData();
	SetEnabled();	
	//InitEditFields(GetElementValue("ApproveSetDR"),GetElementValue("CurRole"));
	//InitApproveButton();
	SetTableItem('','','');
	
	Muilt_LookUp("Loc^Provider^EquipType")
}
function InitPage()
{
	var obj=document.getElementById("BUpdate");
	if (obj) obj.onclick=BUpdate_Clicked;
	var obj=document.getElementById("BDelete");
	if (obj) obj.onclick=BDelete_Clicked;
	var obj=document.getElementById("BSubmit");
	if (obj) obj.onclick=BSubmit_Clicked;
	var obj=document.getElementById("BCancelSubmit");		// ����
	if (obj) obj.onclick=BCancelSubmit_Clicked;
	var obj=document.getElementById("BAudit");
	if (obj) obj.onclick=BAudit_Click;
	var obj=document.getElementById("BPrint");
	if (obj) obj.onclick=BPrint_Clicked;
	var obj=document.getElementById("BAdd");
	if (obj) obj.onclick=AddClickHandler;
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
	var sort=28;
	SetElement("AccountNo",list[0]);
	SetElement("AccountDate",list[1]);
	SetElement("LocDR",list[2]);
	SetElement("Loc",list[sort+0]);
	SetElement("ProviderDR",list[3]);
	SetElement("Provider",list[sort+1]);
	SetElement("EquipTypeDR",list[4]);
	SetElement("EquipType",list[sort+2]);
	SetElement("CheckDate",list[5]);
	SetElement("Status",list[8]);
	SetElement("Remark",list[9]);
	SetElement("Hold1",list[23]);
	SetElement("Hold2",list[24]);
	SetElement("Hold3",list[25]);
	SetElement("Hold4",list[26]);
	SetElement("Hold5",list[27]);
}
function SetEnabled()
{
	var Status=GetElementValue("Status");
	//alertShow("Status="+Status)
	if (Status=="")
	{
		DisableBElement("BDelete",true);
		DisableBElement("BSubmit",true);
		DisableBElement("BAudit",true);
		DisableBElement("BCancelSubmit",true);
	}
	if (Status==0)
	{
		DisableBElement("BCancelSubmit",true);
	}
	if (Status==1)
	{
		DisableBElement("BAdd",true);
		DisableBElement("BUpdate",true);
		DisableBElement("BDelete",true);
	}
	if (Status==2)
	{
		DisableBElement("BAdd",true);
		DisableBElement("BUpdate",true);
		DisableBElement("BDelete",true);
		DisableBElement("BSubmit",true);
		DisableBElement("BAudit",true);
	}
	if (Status==3)
	{
		DisableBElement("BAdd",true);
		DisableBElement("BUpdate",true);
		DisableBElement("BDelete",true);
		DisableBElement("BSubmit",true);
		DisableBElement("BCancelSubmit",true);
		DisableBElement("BAudit",true);
	}
	//��˺�ſɴ�ӡ������ת�Ƶ�
	if (Status!="2")
	{
		DisableBElement("BPrint",true);
	}
}

function BUpdate_Clicked()
{
	if (CheckNull()) return;
	var combindata="";
  	combindata=GetElementValue("RowID");
  	combindata=combindata+"^"+GetElementValue("AccountNo");
  	combindata=combindata+"^"+GetElementValue("AccountDate");
  	combindata=combindata+"^"+GetElementValue("LocDR");
  	combindata=combindata+"^"+GetElementValue("ProviderDR");
  	combindata=combindata+"^"+GetElementValue("EquipTypeDR");
	combindata=combindata+"^"+GetElementValue("CheckDate");
	combindata=combindata+"^"+GetElementValue("CheckUserDR");
  	combindata=combindata+"^"+GetElementValue("TotalFee");
  	//combindata=combindata+"^"+GetElementValue("Status");
  	combindata=combindata+"^"+GetElementValue("Remark");
  	combindata=combindata+"^"+GetElementValue("Hold1");
  	combindata=combindata+"^"+GetElementValue("Hold2");
  	combindata=combindata+"^"+GetElementValue("Hold3");
  	combindata=combindata+"^"+GetElementValue("Hold4");
  	combindata=combindata+"^"+GetElementValue("Hold5");
  	var valList=GetTableInfo();
  	if (valList=="-1") return;
  	var DelRowid=tableList.toString();
  	var encmeth=GetElementValue("Update");
  	if (encmeth=="") return;
	var Rtn=cspRunServerMethod(encmeth,combindata,valList,DelRowid);
	if (Rtn>0)
    {
	     //add by HHM 20150910 HHM0013
		//��Ӳ����ɹ��Ƿ���ʾ
		ShowMessage();
		//****************************
	    window.location.href= 'websys.default.csp?WEBSYS.TCOMPONENT=DHCEQAccountNo&RowID='+Rtn;
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
		window.location.href= 'websys.default.csp?WEBSYS.TCOMPONENT=DHCEQAccountNo';
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
	var encmeth=GetElementValue("SubmitData");
	if (encmeth=="") return;
	var result=cspRunServerMethod(encmeth,rowid);
	if (result<0)
	{	
		alertShow(result);
	}
	else
	{
		location.reload();	
	}
}
function BCancelSubmit_Clicked() // ����
{
	var rowid=GetElementValue("RowID");
	if (rowid=="") retrun;
	var encmeth=GetElementValue("CancelSubmitData");
	if (encmeth=="") return;
	var result=cspRunServerMethod(encmeth,rowid);
	if (result<0)
	{	
		alertShow(result);
	}
	else
	{
		location.reload();	
	}
}
function BAudit_Click()
{
	var rowid=GetElementValue("RowID");
	if (rowid=="") retrun;
	var encmeth=GetElementValue("GetAudit");
	if (encmeth=="") return;
	var result=cspRunServerMethod(encmeth,rowid);
	if (result<0)
	{	
		alertShow(result);
	}
	else
	{
		location.reload();	
	}
}

function SetTableItem(RowNo,SourceType,selectrow)
{
	var objtbl=document.getElementById('tDHCEQAccountNo');
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
					obj=document.getElementById("BDeleteListz"+i);
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
		if (colName=="TSourceType")
		{
			if (CheckUnEditField(Status,colName)) continue;
			value=GetElementValue("TSourceTypeDRz"+objindex);	
			//html=CreatElementHtml(4,Id,objwidth,objheight,"KeyDown_Tab","SourceType_Change","1^��ⵥ&2^ת�Ƶ�&3^���ٵ�","")
			html=CreatElementHtml(4,Id,objwidth,objheight,"KeyDown_Tab","SourceType_Change","1^��ⵥ","")
		}
		else if (colName=="TSourceNo")
		{
			if (CheckUnEditField(Status,colName)) continue;
			value=document.getElementById(Id).innerText
         	html=CreatElementHtml(2,Id,objwidth,objheight,"LookUpSourceNo","","","SourceNoKeyUp")
		}
		else if (colName=="BDeleteList")
		{
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
function SourceType_Change()
{
	var eSrc=window.event.srcElement;
	if (eSrc.tagName=="IMG") eSrc=window.event.srcElement.parentElement;
	var objtbl=document.getElementById('tDHCEQAccountNo'); //�õ����   t+�������
	var rows=objtbl.rows.length;
	var lastrowindex=rows - 1;
	var rowObj=getRow(eSrc);
	selectrow=rowObj.rowIndex;								//��ǰѡ����
	RowNo=GetTableCurRow();
	var TSourceType=GetElementValue("TSourceTypez"+RowNo)
	SetElement("TSourceTypeDRz"+RowNo,TSourceType);
	if (TSourceType==1)
	{
		SetTableItem(RowNo,"1",selectrow);		///�ı�һ�е�������ʾ
	}
	if (TSourceType==2)
	{
		SetTableItem(RowNo,"2",selectrow);		///�ı�һ�е�������ʾ
	}
	if (TSourceType==3)
	{
		SetTableItem(RowNo,"3",selectrow);		///�ı�һ�е�������ʾ
	}
	selectrow=RowNo;
	Clear();
	SetFocusColumn("TSourceType",selectrow);
}
function SourceNoKeyUp()
{
	var eSrc=window.event.srcElement;
	if (!eSrc) return;
	var Id=eSrc.id
	var offset=Id.lastIndexOf("z");
	var index=Id.substring(offset+1);
	SetElement("TSourceIDz"+index,"");
}
function LookUpSourceNo(vClickEventFlag)
{
	if (event.keyCode==13||event.keyCode==0||vClickEventFlag==1)
	{
		if (CheckNull()) return;
		selectrow=GetTableCurRow();
		var ObjTSourceType=document.getElementById('TSourceTypez'+selectrow);
		if (ObjTSourceType)
		{
			var TSourceType=ObjTSourceType.value;
			if (TSourceType==1)
			{
				LookUpInStock();
			}
			else if (TSourceType==2)
			{
				LookUpStoreMove();
			}
			else if (TSourceType==3)
			{
				LookUpReturn();
			}	
		}
	}
}

function LookUpInStock()
{
	LookUp("","web.DHCEQAccountNo:GetInStock","GetInStock","EquipTypeDR,ProviderDR,TSourceNoz"+selectrow+",TRowIDz"+selectrow);
}
function GetInStock(value)
{
	Clear()
	var TotalFlag=GetElementValue("TotalFlag")
	var list=value.split("^")
	var Length=ObjSources.length
	
	for (var i=1;i<Length;i++)
	{
		//alertShow(ObjSources[i].SourceType+"&"+ObjSources[i].SourceID+"&"+list[1]);
		if ((tableList[i]=="0")&&(ObjSources[i].SourceType=="1")&&(ObjSources[i].SourceID==list[0])&&(selectrow!=i))
		{
			alertShow("ѡ�����ⵥ���"+GetCElementValue("TRowz"+i)+"���ظ�!")
			return;
		}
	}
	SetElement("TSourceIDz"+selectrow,list[0]);
	SetElement("TSourceNoz"+selectrow,list[1]);
	SetElement("TMakeDatez"+selectrow,list[2]);
	SetElement("TEquipNamez"+selectrow,list[3]);
	SetElement("TManuFactoryz"+selectrow,list[4]);
	SetElement("TTotalNumz"+selectrow,list[5]);
	SetElement("TTotalFeez"+selectrow,list[6]);
	SetElement("TLocz"+selectrow,list[7]);
	SetElement("TRemarkz"+selectrow,list[8]);
	SumList_Change();
	ObjSources[selectrow]=new SourceInfo("1",list[0]);
	var obj=document.getElementById("TSourceNoz"+selectrow);
	if (obj) websys_nextfocusElement(obj);
}

function LookUpStoreMove()
{
	alertShow("����������...")
	return
	LookUp("","web.DHCEQAccountNo:GetStoreMove","GetStoreMove","EquipTypeDR,ProviderDR,TSourceNoz"+selectrow);
}
function GetStoreMove(value)
{
	Clear()
	var TotalFlag=GetElementValue("TotalFlag")
	var list=value.split("^")
	var Length=ObjSources.length

	for (var i=1;i<Length;i++)
	{
		//alertShow(ObjSources[i].SourceType+"&"+ObjSources[i].SourceID+"&"+list[1]);
		if ((tableList[i]=="0")&&(ObjSources[i].SourceType=="1")&&(ObjSources[i].SourceID==list[1])&&(selectrow!=i))
		{
			alertShow("ѡ����豸�����"+GetCElementValue("TRowz"+i)+"���ظ�!")
			return;
		}
	}
	SetElement('TEquipz'+selectrow,list[0]);
	SetElement('TItemDRz'+selectrow,list[1]);
	SetElement('TEquipCatDRz'+selectrow,list[3]);
	SetElement('TEquipCatz'+selectrow,list[4]);
	SetElement('TUnitDRz'+selectrow,list[5]);
	SetElement('TUnitz'+selectrow,list[6]);
	SetElement('TEquipTypeDRz'+selectrow,list[7]);
	SetElement('TEquipTypez'+selectrow,list[8]);
	SetElement('TStatCatDRz'+selectrow,list[9]);
	SetElement('TStatCatz'+selectrow,list[10]);
	SetElement('TUserYearsNumz'+selectrow,list[13]);
	SetElement('TSourceIDz'+selectrow,list[1]);
	
	SumList_Change();
	ObjSources[selectrow]=new SourceInfo("1",list[1]);
	var obj=document.getElementById("TEquipz"+selectrow);
	if (obj) websys_nextfocusElement(obj);
}

function LookUpReturn()
{
	alertShow("����������...")
	return
	LookUp("","web.DHCEQAccountNo:GetReturn","GetReturn","EquipTypeDR,ProviderDR,TSourceNoz"+selectrow);
}
function GetReturn(value)
{
	Clear()
	var TotalFlag=GetElementValue("TotalFlag")
	var list=value.split("^")
	var Length=ObjSources.length

	for (var i=1;i<Length;i++)
	{
		//alertShow(ObjSources[i].SourceType+"&"+ObjSources[i].SourceID+"&"+list[1]);
		if ((tableList[i]=="0")&&(ObjSources[i].SourceType=="1")&&(ObjSources[i].SourceID==list[1])&&(selectrow!=i))
		{
			alertShow("ѡ����豸�����"+GetCElementValue("TRowz"+i)+"���ظ�!")
			return;
		}
	}
	SetElement('TEquipz'+selectrow,list[0]);
	SetElement('TItemDRz'+selectrow,list[1]);
	SetElement('TEquipCatDRz'+selectrow,list[3]);
	SetElement('TEquipCatz'+selectrow,list[4]);
	SetElement('TUnitDRz'+selectrow,list[5]);
	SetElement('TUnitz'+selectrow,list[6]);
	SetElement('TEquipTypeDRz'+selectrow,list[7]);
	SetElement('TEquipTypez'+selectrow,list[8]);
	SetElement('TStatCatDRz'+selectrow,list[9]);
	SetElement('TStatCatz'+selectrow,list[10]);
	SetElement('TUserYearsNumz'+selectrow,list[13]);
	SetElement('TSourceIDz'+selectrow,list[1]);
	
	SumList_Change();
	ObjSources[selectrow]=new SourceInfo("1",list[1]);
	var obj=document.getElementById("TEquipz"+selectrow);
	if (obj) websys_nextfocusElement(obj);
}
function AddClickHandler()
{
	try 
	{
		var objtbl=document.getElementById('tDHCEQAccountNo');
		var ret=CanAddRow(objtbl);
		if (ret)
		{
			NewNameIndex=tableList.length;
	    	AddRowToList(objtbl,LastNameIndex,NewNameIndex);
	    	
			//����Ĭ�ϵ���Դ��������һ��һ��
			var PreSourceType=GetElementValue("TSourceTypez"+LastNameIndex);
			SetElement("TSourceTypez"+NewNameIndex,PreSourceType);
			//���������ظ���ͼ��
			//var TAffix=document.getElementById("TAffixz"+NewNameIndex);
			//if (TAffix) TAffix.removeNode(true);
	    }
        return false;
	} 
	catch(e) 
	{};
}
function CanAddRow(objtbl)
{
	var rows=objtbl.rows.length;
    if (rows==1) return false;
	var TotalFlag=GetElementValue("TotalFlag")
	if (TotalFlag==2) rows=rows-1
	LastNameIndex=GetRowIndex(objtbl.rows[rows-1]);
	var TSourceType=document.getElementById('TSourceTypez'+LastNameIndex).value
	if  (GetElementValue('TSourceTypez'+LastNameIndex)=="")
	{
		SetFocusColumn("TSourceType",LastNameIndex);
		return false;
		
	}
	if  (GetElementValue('TSourceIDz'+LastNameIndex)=="")
	{
		SetFocusColumn("TSourceNo",LastNameIndex);
	 	return false;
	}
	return true;
}
function DeleteClickHandler()
{
	var truthBeTold = window.confirm("��ȷ��Ҫɾ���ü�¼��?");
	if (!truthBeTold) return;
	try
	{
		var objtbl=document.getElementById('tDHCEQAccountNo');
		var rows=objtbl.rows.length;
		selectrow=GetTableCurRow();
		var TotalFlag=GetElementValue("TotalFlag")
		var TRowID=GetElementValue('TRowIDz'+selectrow);
		tableList[selectrow]=TRowID;
		var delNo=GetElementValue("TRowz"+selectrow);

		if (((TotalFlag==0)&&(rows<=2))||((rows<=3)&&((TotalFlag==1)||(TotalFlag==2))))
		{
			//�޸�ɾ����ʣ��һ�к�,�༭���������쳣,�޷����������
			tableList[selectrow]=0;
			if (TRowID!="")
			{
				SetElement('TRowIDz'+selectrow,"");
				tableList[tableList.length]=TRowID;
			}
			Clear();
		} 
		else
		{
	    	var eSrc=window.event.srcElement;
			var rowObj=getRow(eSrc);
			objtbl.deleteRow(rowObj.rowIndex);
		}
		ResetNo(selectrow,delNo);
	    SumList_Change();
	} 
	catch(e) 
	{};
}
function Clear()
{
	SetElement("TSourceIDz"+selectrow,"");
	SetElement("TSourceNoz"+selectrow,"");
	SetElement("TMakeDatez"+selectrow,"");
	SetElement("TEquipNamez"+selectrow,"");
	SetElement("TTotalNumz"+selectrow,"");
	SetElement("TTotalFeez"+selectrow,"");
	SetElement("TLocz"+selectrow,"");
	SetElement("TRemarkz"+selectrow,"");
}
function GetTableInfo()
{
    var objtbl=document.getElementById('tDHCEQAccountNo');
	var rows=tableList.length;
	var valList="";
	for(var i=1;i<rows;i++)
	{
		if (tableList[i]=="0")
		{
			var TRow=GetCElementValue("TRowz"+i);
			var TRowID=GetElementValue("TRowIDz"+i);
			var TSourceType=GetElementValue("TSourceTypez"+i);
			var TSourceID=GetElementValue("TSourceIDz"+i);
			var EquipTypeDR=GetElementValue("EquipTypeDR");
			var ProviderDR=GetElementValue("ProviderDR");
			var TManuFactory=GetElementValue("TManuFactoryz"+i);
			var TEquipName=GetElementValue("TEquipNamez"+i);
			var TTotalNum=GetElementValue("TTotalNumz"+i);
			var TTotalFee=GetElementValue("TTotalFeez"+i);
			var TRemark=GetElementValue("TRemarkz"+i);
			var TSourceNo=GetElementValue("TSourceNoz"+i);
			if ((TSourceNo=="")||(TSourceID==""))
			{
				alertShow("��"+TRow+"��,��ѡ����ȷ���豸ҵ��.")
				SetFocusColumn("TSourceNo",i)
				return "-1";
			}
			
			var THold1=GetElementValue("THold1z"+i);
			var THold2=GetElementValue("THold2z"+i);
			var THold3=GetElementValue("THold3z"+i);
			var THold4=GetElementValue("THold4z"+i);
			var THold5=GetElementValue("THold5z"+i);
			
			if(valList!="") valList=valList+"&";
			valList=valList+TRow+"^"+TRowID+"^"+TSourceType+"^"+TSourceID+"^"+EquipTypeDR+"^"+ProviderDR+"^"+TManuFactory+"^"+TEquipName+"^"+TTotalNum+"^"+TTotalFee+"^"+TRemark;
			valList=valList+"^"+THold1+"^"+THold2+"^"+THold3+"^"+THold4+"^"+THold5;
		}
	}
	return  valList
}

function SumList_Change()
{	
	var length=tableList.length
	var Num=0
	var Fee=0
	for (var i=1;i<length;i++)
	{
		if (tableList[i]=="0")
		{
			var TTotalNum=parseInt(GetElementValue("TTotalNumz"+i))
			var TTotalFee=parseFloat(GetElementValue("TTotalFeez"+i))
			if ((isNaN(TTotalNum))||(isNaN(TTotalFee))) continue;
			Num=Num+TTotalNum;
			Fee=Fee+TTotalFee;
		}
		else if (tableList[i]==-1)
		{
			var index=i
		}
	}
	SetElement('TTotalNumz'+index,Num);
	SetElement('TTotalFeez'+index,Fee.toFixed(2));
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
    GetLookUpID("ProviderDR",value);
}
function CheckNull()
{
	if (CheckMustItemNull("Provider")) return true;
	//2013-11-11 Mozy0112	
	var obj=document.getElementById("cProvider");
	if ((obj)&&(obj.className=="clsRequired"))
	{
		if (CheckItemNull("","Provider")==true) return true;
	}
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
	var lista=ReturnList.split("^");
	var encmeth=GetElementValue("GetList");
	if (encmeth=="") return;
	var gbldata=cspRunServerMethod(encmeth,RowID);
	//alertShow(gbldata);
	var list=gbldata.split("_");
	var Listall=list[0];
	rows=list[1];
	
	var PageRows=5;
	var Pages=parseInt(rows / PageRows); //��ҳ�� 1  3Ϊÿҳ�̶�����
	var ModRows=rows%PageRows; //���һҳ����
	if (ModRows==0) {Pages=Pages-1;}
	
	var encmeth=GetElementValue("GetRepPath");
	if (encmeth=="") return;
	var	TemplatePath=cspRunServerMethod(encmeth);
	
	try
	{
        var xlApp,xlsheet,xlBook;
	    var Template=TemplatePath+"DHCEQAccountNo.xls";
	    xlApp = new ActiveXObject("Excel.Application");
	   	for (var i=0;i<=Pages;i++)
	    {
	    	xlBook = xlApp.Workbooks.Add(Template);
	    	xlsheet = xlBook.ActiveSheet;
	    	var sort=28;
	    	//ҽԺ�����滻
	    	xlsheet.cells.replace("[Hospital]",GetElementValue("GetHospitalDesc"));
	    	var pro=GetShortName(lista[sort+1],"-");
	    	xlsheet.cells(2,1)="��Ӧ��:"+pro.substring(0);
	    	xlsheet.cells(2,4)=lista[0];	//"ƾ֤��:"+
	    	xlsheet.cells(2,6)=ChangeDateFormat(lista[1]);	//"ƾ֤����:"+
	   		var OnePageRow=PageRows;
	   		if ((i==Pages)&&(ModRows!=0)) OnePageRow=ModRows;
	    		
	    	for (var j=1;j<=OnePageRow;j++)
			{
				//SourceType_"^"_TSourceNo_"^"_EquipType_"^"_Provider_"^"_ManuFactory_"^"_EquipName_"^"_QuantityNum_"^"_Amount_"^"_Remark
				var Lists=Listall.split(":");
				var Listl=Lists[i*PageRows+j];
				var List=Listl.split("^");
				var Row=3+j;
				xlsheet.cells(Row,1)=List[0];		//��Դ����
				xlsheet.cells(Row,2)=List[1];		//����
				xlsheet.cells(Row,3)=List[5];		//�豸����
				xlsheet.cells(Row,4)=List[4];		//��������
				xlsheet.cells(Row,5)=List[6];		//����
				xlsheet.cells(Row,6)=List[7];		//�ܽ��
				xlsheet.cells(Row,7)=List[8];		//��ע
	    	}
	    	xlsheet.cells(9,2)=(list[1]-1)+" ��";
	    	//xlsheet.cells(16,10)="��"+(i+1)+"ҳ "+"��"+(Pages+1)+"ҳ";
		    var obj = new ActiveXObject("PaperSet.GetPrintInfo");
			var size=obj.GetPaperInfo("DHCEQInStock");
			if (0!=size) xlsheet.PageSetup.PaperSize = size;
		    
		    //xlsheet.printout; 	//��ӡ���
		    xlApp.Visible=true;
	    	xlsheet.PrintPreview();
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
document.body.onload = BodyLoadHandler;