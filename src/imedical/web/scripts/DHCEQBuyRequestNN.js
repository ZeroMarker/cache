///Add By DJ 2013-07-03
///------------------------------------------------------------------
///modified by GR0007 2014-09-09 ���"�豸�ɹ�����"�������ʱ��ʾ��Ϣ���� ȱ�ݺ�3122
///�޸�λ��:BUpdate_Clicked()
///----------------------------------------------------------------
///modified by GR 2014-09-15 begin ȱ�ݱ�� 3127 Ԥ�Ʒ�����ʾ��
///�޸�λ��:BUpdate_Clicked()
///----------------------------------------------------------------
///modified by GR 2014-09-15ȱ�ݺ�3155 ��ʾ��Ϣ��׼ȷ,��ʾ"��x��ԭֵ����ȷ"
///�޸�λ��:GetTableInfo()
///----------------------------------------------------------------
var selectrow=0;
///��¼ �豸 RowID?�����ظ�ѡ��RowID������
var ObjSources=new Array();

//���һ������Ԫ�ص����ֵĺ�׺���
var LastNameIndex;
//����һ������Ԫ�ص����ֵĺ�׺���
var NewNameIndex;

document.body.onload = BodyLoadHandler;

function BodyLoadHandler() 
{	
	KeyUp("RequestLoc^UseLoc^EquipType","N");
	InitUserInfo();
	InitPage();	
	FillData();
	IsYear();
	SetEnabled();
	InitEditFields(GetElementValue("ApproveSetDR"),GetElementValue("CurRole"));
	InitApproveButton();
	
	SetTableItem('','','');
	SetElementEnabled();
	Muilt_LookUp("RequestLoc^UseLoc^EquipType")
	RefreshListData();
}
function RefreshListData()
{
	var obj=document.getElementById("RowID");
	var RowID=obj.value;
	if ((RowID=="")||(RowID<1)) return;
    var objtbl=document.getElementById('tDHCEQBuyRequestNN');
	var rows=tableList.length
	for(var i=1;i<rows;i++)
	{
		if (tableList[i]=="0")
		{
			var TAllOption=GetElementValue("TAllOptionz"+i);
			if (TAllOption!="")
			{
				TAllOption=TAllOption.replace(/\\n/g,"\n");
				SetElement("TAllOptionz"+i,TAllOption)
			}
		}
	}
}
function SetEnabled()
{
	var Status=GetElementValue("Status");
	var WaitAD=GetElementValue("WaitAD");
	SetElement("ReadOnly",0);
	if (Status!="0")
	{
		DisableBElement("BDelete",true);
		DisableBElement("BSubmit",true);
		if (Status!="")
		{
			DisableBElement("BUpdate",true);
			DisableBElement("BAdd",true);
			DisableBElement("BClear",true);
			SetElement("ReadOnly",1);
			DisableElement("EquipType",true);
			document.getElementById("ld"+GetElementValue("GetComponentID")+"iEquipType").removeNode(true)
		}
	}
	if (Status!="2")
	{
		DisableBElement("BPrint",true);
	}
	if (WaitAD!="off")
	{
		DisableBElement("BUpdate",true);
		DisableBElement("BDelete",true);
		DisableBElement("BSubmit",true);
		DisableBElement("BAdd",true);
		DisableBElement("BClear",true);
		SetElement("ReadOnly",1);
	}
}

function FillData()
{
	var obj=document.getElementById("RowID");
	var RowID=obj.value;
	if ((RowID=="")||(RowID<1)) return;
	var obj=document.getElementById("fillData");
	if (obj){var encmeth=obj.value} else {var encmeth=""};
	var ReturnList=cspRunServerMethod(encmeth,"","",RowID);
	ReturnList=ReturnList.replace(/\\n/g,"\n");
	var list=ReturnList.split("@");
	var valueRequest=list[0].split("^");
	var sortRequest=45;
	SetElement("RequestNo",valueRequest[34])
	SetElement("RequestDate",valueRequest[5])
	SetElement("RequestLoc",valueRequest[sortRequest+0])
	SetElement("RequestLocDR",valueRequest[1])
	SetElement("UseLoc",valueRequest[sortRequest+1])
	SetElement("UseLocDR",valueRequest[3])
	SetElement("Year",valueRequest[4])
	SetChkElement("YearFlag",valueRequest[2])
	SetElement("Remark",valueRequest[26])
	SetElement("Status",valueRequest[15])
	//
	SetElement("ApproveSetDR",valueRequest[sortRequest+11]);
	SetElement("NextRoleDR",valueRequest[sortRequest+12]);
	SetElement("NextFlowStep",valueRequest[sortRequest+13]);
	SetElement("ApproveStatus",valueRequest[sortRequest+14]);
	SetElement("ApproveRoleDR",valueRequest[sortRequest+15]);
	SetElement("CancelFlag",valueRequest[sortRequest+16]);
	SetElement("CancelToFlowDR",valueRequest[sortRequest+17]);
}


function InitPage()
{
	var obj=document.getElementById("BUpdate");
	if (obj) obj.onclick=BUpdate_Clicked;
	var obj=document.getElementById("BDelete");
	if (obj) obj.onclick=BDelete_Clicked;
	var obj=document.getElementById("BSubmit");
	if (obj) obj.onclick=BSubmit_Clicked;
	var obj=document.getElementById("BPrint");
	if (obj) obj.onclick=BPrint_Clicked;
	var obj=document.getElementById("BClear");
	if (obj) obj.onclick=BClear_Clicked;
	var obj=document.getElementById("BAdd");
	if (obj) obj.onclick=AddClickHandler;
	var obj=document.getElementById("YearFlag");
	if (obj) obj.onchange=IsYear;

}

function IsYear()
{
	//modified by  ZY 2015-09-28 ZY0144    �����������������Ԫ��Year��cYear��ʾ
	var YearFlag=GetElementValue("YearFlag");
	if (YearFlag=="Y")
	{
		HiddenObj("YearFlag",1)
		var Year=new Date();
		Year=Year.getYear()+1;
		SetElement("Year",Year)
		DisableElement("Year",true);
	}
	else
	{
		HiddenObj("Year",1);
		HiddenObj("cYear",1);
		//DisableElement("Year",true);
		//SetElement("Year","");
	}
}

function IsVaildYear()
{
	var obj=document.getElementById("YearFlag");
	if (obj.checked)
	{
		var encmeth=GetElementValue("IsVaildYear");
		if (cspRunServerMethod(encmeth,GetElementValue("Year"))==1)
		{
			alertShow(t["04"]);
			return ture;
		}
	}
	return false;
}

function BUpdate_Clicked()
{
	if (IsVaildYear()) return;
	//����ҽ�ƴ�ѧ��һ����ҽԺ�ж��ظ���¼
	//modified by GR0007 2014-09-09 begin ���"�豸�ɹ�����"�������ʱ��ʾ��Ϣ����
	var len=tableList.length;
	for (var i=1;i<len;i++)
	{
		if(tableList[i]!="0") continue;
		var ICommonName=GetElementValue("TCommonNamez"+i)
		if (""==ICommonName||" "==ICommonName) {alertShow("��"+GetElementValue("TRowz"+i)+"��ͨ��������Ϊ��");return }
		var TPurchaseTypeDRz=GetElementValue("TPurchaseTypeDRz"+i)
		if (""==TPurchaseTypeDRz||" "==TPurchaseTypeDRz) {alertShow("��"+GetElementValue("TRowz"+i)+"���깺���Ͳ���Ϊ��");return }//
		for (var j=i+1;j<len;j++)
		{
			if(tableList[j]!="0") continue;
			var JCommonName=GetElementValue("TCommonNamez"+j)
			if (ICommonName==JCommonName)
			{
				alertShow("��"+GetElementValue("TRowz"+i)+"�����"+GetElementValue("TRowz"+j)+"��ͨ�����ظ�!")
				return;
			}
		}
	}
	//modified by GR0007 2014-09-09 end
	//�ܵ���Ϣ
	var combindata="";
  	combindata=GetElementValue("RowID") ;
  	combindata=combindata+"^"+GetElementValue("RequestNo") ;
  	combindata=combindata+"^"+GetElementValue("RequestDate") ;
  	combindata=combindata+"^"+GetElementValue("RequestLocDR") ;
  	combindata=combindata+"^"+GetElementValue("UseLocDR") ;
	//modified by  ZY 2015-09-28 ZY0144   ���YearFlag����
	if (GetElementValue("YearFlag")=="Y")
	{
		YearFlag=1
	}else
	{
		YearFlag=0
	}
  	combindata=combindata+"^"+GetElementValue("Year") ;
  	combindata=combindata+"^"+GetElementValue("Remark") ;
  	combindata=combindata+"^"+curUserID ;
  	combindata=combindata+"^"+GetElementValue("EquipTypeDR");	//2013-11-11 Mozy0112
  	combindata=combindata+"^"+GetElementValue("TRequestNumz2");//BR_QuantityNum modified by GR 2014-09-15 begin ȱ�ݱ�� 3127 Ԥ�Ʒ�����ʾ��
  	combindata=combindata+"^"+GetElementValue("TAmountz2");//BR_TotalFee modified by GR 2014-09-15 end
  	//��ϸ��Ϣ
  	var valList=GetTableInfo();
  	if (valList=="-1")  return;
  	var DelRowid=tableList.toString()
  	var encmeth=GetElementValue("Update")
  	if (encmeth=="") return;
	var Rtn=cspRunServerMethod(encmeth,combindata,valList,DelRowid);
	
	if (Rtn>0)
    {
	    //add by HHM 20150910 HHM0013
	    //��Ӳ����ɹ��Ƿ���ʾ
	    ShowMessage();
	    window.location.href= 'websys.default.csp?WEBSYS.TCOMPONENT=DHCEQBuyRequestNN&RowID='+Rtn+"&WaitAD=off"+"&YearFlag="+GetElementValue("YearFlag"); //modified by  ZY 2015-09-28 ZY0144   ���YearFlag����
	}
    else
    {
	    alertShow(EQMsg(t["01"],Rtn));
    }
}

function BDelete_Clicked()
{
	var truthBeTold = window.confirm(t["02"]);
	if (!truthBeTold) return;
	var Return=UpdateBuyRequest("","","","1");
    var list=Return.split("^");
	if (list[1]!="0")
	{
		alertShow("�����쳣   "+list[1])
	}
	else
    {
	    window.location.href= 'websys.default.csp?WEBSYS.TCOMPONENT=DHCEQBuyRequestNN'+"&YearFlag="+GetElementValue("YearFlag"); //modified by  ZY 2015-09-28 ZY0144   ���YearFlag����
	}
}

function UpdateBuyRequest(RequestValue,ListValue,DetailValue,AppType)
{
	var RowID=GetElementValue("RowID");
	RequestValue=RowID+"^"+RequestValue;
	var encmeth=GetElementValue("upd");
	var ReturnValue=cspRunServerMethod(encmeth,RequestValue,ListValue,DetailValue,AppType);
	return ReturnValue;
}

function BSubmit_Clicked()
{
	//����ҽ�ƴ�ѧ��һ����ҽԺ�ж��Ƿ���Ҫ��֤��Ч�����
  	var encmeth=GetElementValue("CheckAnalyandArgu")
  	if (encmeth=="") return;
	var objtbl=document.getElementById('tDHCEQBuyRequestNN');
	var rows=tableList.length
	var RejectFlag=0;
	for(var i=1;i<rows;i++)
	{
		if (tableList[i]=="0")
		{
			var TOptionType=GetElementValue("TOptionTypez"+i);
			var TRowID=GetElementValue("TRowIDz"+i);
			var TRow=GetElementValue("TRowz"+i);
			if (TOptionType=="��ͬ��")
			{
				RejectFlag=1;
			}
			var CheckReturn=cspRunServerMethod(encmeth,TRowID,"DHCEQ0001");
			if (CheckReturn==1)
			{
				alertShow("��"+TRow+"����Ҫ��֤��!")
				return
			}
			var CheckReturn=cspRunServerMethod(encmeth,TRowID,"DHCEQ0002");
			if (CheckReturn==1)
			{
				alertShow("��"+TRow+"����Ҫ��֤��!")
				return
			}
			var CheckReturn=cspRunServerMethod(encmeth,TRowID,"DHCEQ0003");
			if (CheckReturn==1)
			{
				alertShow("��"+TRow+"����Ҫ�����Ա���!")
				return
			}
			var CheckReturn=cspRunServerMethod(encmeth,TRowID,"DHCEQ0004");
			if (CheckReturn==1)
			{
				alertShow("��"+TRow+"����Ҫ�����¼!")
				return
			}
			var CheckReturn=cspRunServerMethod(encmeth,TRowID,"DHCEQ0005");
			if (CheckReturn==1)
			{
				alertShow("��"+TRow+"����ҪЧ�����!")
				return
			}
		}
	}
	if (RejectFlag!=0)
	{
		var truthBeTold = window.confirm(t["-1111"]);
		if (!truthBeTold) return;
	}
	
	var combindata=GetValueList();
  	var valList=GetTableInfo();
  	if (valList=="")
  	{
	  	alertShow(t["-1003"])
	  	return;
	}
	
  	var encmeth=GetElementValue("SubmitData")
  	if (encmeth=="") return;
	var Rtn=cspRunServerMethod(encmeth,combindata);
	if (Rtn>0)
    {
		var WaitAD=GetElementValue("WaitAD");
		window.location.href= 'websys.default.csp?WEBSYS.TCOMPONENT=DHCEQBuyRequestNN&RowID='+Rtn+"&WaitAD="+WaitAD+"&YearFlag="+GetElementValue("YearFlag"); //modified by  ZY 2015-09-28 ZY0144   ���YearFlag����
	}
    else
    {
	    alertShow(t[Rtn]+"   "+t["01"]);
    }
}

function BCancelSubmit_Clicked() // ���ύ
{
	var combindata=GetValueList();
    var objtbl=document.getElementById('tDHCEQBuyRequestNN');
	var rows=tableList.length
	var valList="";
	var RejectFlag=0;
	for(var i=1;i<rows;i++)
	{
		if (tableList[i]=="0")
		{
			var TRow=GetCElementValue("TRowz"+i);
			var TOptionType=GetElementValue("TOptionTypez"+i);
			var TApproveOption=GetElementValue("TApproveOptionz"+i);
			var TRowID=GetElementValue("TRowIDz"+i);
			if (TOptionType==2)
			{
				RejectFlag=1;
				if (TApproveOption=="")
				{
					alertShow("�������������д�ܾ�ԭ��!")
					SetFocusColumn("TApproveOption",i)
					return "-1"
				}
			}
			if (valList!="") {valList=valList+"&"}
			valList=valList+TRowID+"^"+TApproveOption
		}
	}
	if (RejectFlag==0)
	{
		alertShow("�޾ܾ���¼!")
		return
	}
  	var encmeth=GetElementValue("CancelSubmitData");
  	if (encmeth=="") return;
	var rtn=cspRunServerMethod(encmeth,combindata,GetElementValue("CurRole"),valList);
    if (rtn>0)
    {
	    window.location.href= 'websys.default.csp?WEBSYS.TCOMPONENT=DHCEQBuyRequestNN&RowID='+rtn+"&WaitAD="+GetElementValue("WaitAD")+"&YearFlag="+GetElementValue("YearFlag"); //modified by  ZY 2015-09-28 ZY0144   ���YearFlag����
	}
    else
    {
	    alertShow(rtn+"   "+t["01"]);
    }
}

function BClear_Clicked()
{
	var QXType=GetElementValue("QXType");
	window.location.href= 'websys.default.csp?WEBSYS.TCOMPONENT=DHCEQBuyRequestNN&Type=0&QXType='+QXType+'&WaitAD=off'+"&YearFlag="+GetElementValue("YearFlag"); //modified by  ZY 2015-09-28 ZY0144   ���YearFlag����
}

function AddClickHandler() {
	try 
	{
		var objtbl=document.getElementById('tDHCEQBuyRequestNN');
		var ret=CanAddRow(objtbl);
		if (ret)
		{
			NewNameIndex=tableList.length;
	    	AddRowToList(objtbl,LastNameIndex,NewNameIndex);
			//����������ͼ��
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
	//����ҽ�ƴ�ѧ��һ����ҽԺ�����豸���ȡ����
	if  (GetElementValue('TItemz'+LastNameIndex)=="")
	{
		SetFocusColumn("TItem",LastNameIndex);
		return false;
		
	}
	if  (GetElementValue('TCommonNamez'+LastNameIndex)=="")
	{
		SetFocusColumn("TCommonName",LastNameIndex);
	 	return false;
	}
	return true;
}

function SetTableItem(RowNo,SourceType,selectrow)
{
	var objtbl=document.getElementById('tDHCEQBuyRequestNN');
	var rows=objtbl.rows.length-1;
	if (RowNo=="")
	{
		for (var i=1;i<=rows;i++)
		{
			var TSourceID=document.getElementById("TItemDRz"+i).value;
			ObjSources[i]=new SourceInfo(0,TSourceID);
			tableList[i]=0;
			var TRowID=document.getElementById("TRowIDz"+i).value
			var TotalFlag=GetElementValue("TotalFlag");
			if (TRowID==-1)
			{
				if ((TotalFlag==1)||(TotalFlag==2))
				{
					obj=document.getElementById("TRowz"+i);
					if (obj) obj.innerText="�ϼ�:"
					obj=document.getElementById("BDeleteListz"+i);
					if (obj) obj.innerText=""
					obj=document.getElementById("BAffectAnalysez"+i);
					if (obj) obj.innerText=""
					obj=document.getElementById("BArgumentationz"+i);
					if (obj) obj.innerText=""
					obj=document.getElementById("BPrintListz"+i);
					if (obj) obj.innerText=""
					tableList[i]=-1;
					continue;
				}
			}
			ChangeRowStyle(objtbl.rows[i],SourceType);		///�ı�һ�е�������ʾ
		}
	}
	else
	{
		if (selectrow=='') selectrow=RowNo
		tableList[RowNo]=0;
		ChangeRowStyle(objtbl.rows[selectrow],SourceType);		///�ı�һ�е�������ʾ
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
		if (colName=="TItem")
		{
			if (CheckUnEditField(Status,colName)) continue;
			value=document.getElementById(Id).innerText
         	html=CreatElementHtml(2,Id,objwidth,objheight,"LookUpEquip","","","Standard_TableKeyUp")
		}
		else if (colName=="TCommonName")
		{
			if (CheckUnEditField(Status,colName)) continue;
			value=document.getElementById(Id).innerText;
			html=CreatElementHtml(1,Id,objwidth,objheight,"KeyDown_Tab","","","")
		}
		else if (colName=="TAdviseModel")
		{
			if (CheckUnEditField(Status,colName)) continue;
			value=document.getElementById(Id).innerText;
			html=CreatElementHtml(1,Id,objwidth,objheight,"KeyDown_Tab","","","")
		}
		else if (colName=="TModel")
		{
			if (CheckUnEditField(Status,colName)) continue;
			value=document.getElementById(Id).innerText;
         	html=CreatElementHtml(2,Id,objwidth,objheight,"LookUpModelNew","","","Standard_TableKeyUp")
		}
		else if (colName=="TRequestNum")
		{
			if (CheckUnEditField(Status,colName)) continue;
			value=document.getElementById(Id).innerText;
         	html=CreatElementHtml(1,Id,objwidth,objheight,"KeyDown_Tab","","","TotalFee_Change")
			//����
			var objTQuantityNum=document.getElementById(Id);
			if(objTQuantityNum)
			{
				objTQuantityNum.onkeypress=NumberPressHandler
			}
		}
		else if (colName=="TUnit")
		{
			if (CheckUnEditField(Status,colName)) continue;
			value=document.getElementById(Id).innerText
         	html=CreatElementHtml(2,Id,objwidth,objheight,"LookUpUnitNew","","","Standard_TableKeyUp")
		}
		else if (colName=="TPurchaseType")
		{
			if (CheckUnEditField(Status,colName)) continue;
			value=document.getElementById(Id).innerText
         	html=CreatElementHtml(2,Id,objwidth,objheight,"LookUpPurchaseTypeNew","","","Standard_TableKeyUp")
		}
		else if (colName=="TPurposeType")
		{
			if (CheckUnEditField(Status,colName)) continue;
			value=document.getElementById(Id).innerText
         	html=CreatElementHtml(2,Id,objwidth,objheight,"LookUpPurposeTypeNew","","","Standard_TableKeyUp")
		}
		else if (colName=="TPriceFee")
		{
			if (CheckUnEditField(Status,colName)) continue;
			value=document.getElementById(Id).innerText;
         	html=CreatElementHtml(1,Id,objwidth,objheight,"KeyDown_Tab","","","TotalFee_Change")
			var objTSourceType=document.getElementById(Id);
			if(objTSourceType)
			{
				objTSourceType.onkeypress=NumberPressHandler
			}
		}
		else if (colName=="TFundsOrigin")
		{
			if (CheckUnEditField(Status,colName)) continue;
			value=document.getElementById(Id).innerText
         	html=CreatElementHtml(2,Id,objwidth,objheight,"LookUpFundsOrigin","","","Standard_TableKeyUp")
		}
		else if (colName=="TApproveNum")
		{
			if (GetElementValue("Status")<1) continue;
			value=document.getElementById(Id).innerText;
         	html=CreatElementHtml(1,Id,objwidth,objheight,"KeyDown_Tab","","","")
			//����
			var objTQuantityNum=document.getElementById(Id);
			if(objTQuantityNum)
			{
				objTQuantityNum.onkeypress=NumberPressHandler
			}
		}
		else if (colName=="TRemark")
		{
			if (CheckUnEditField(Status,colName)) continue;
			value=document.getElementById(Id).innerText;
			html=CreatElementHtml(1,Id,objwidth,objheight,"KeyDown_Tab","","","")
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
		else if (colName=="BPrintList")
		{
			if (Status<1)
			{
				HiddenObj(colName+"z"+objindex,1)
				continue;
			}
			RowObj.cells[j].onclick=PrintListClickHandler;
		}
		else if (colName=="BAffectAnalyse")
		{
			RowObj.cells[j].onclick=BAffectAnalyseClick;
		}
		else if (colName=="BArgumentation")
		{
			RowObj.cells[j].onclick=BArgumentationClick;
		}
		else if (colName=="TOptionType")
		{
			if (GetElementValue("Status")<1) continue;
			html=CreatElementHtml(4,Id,objwidth,objheight,"KeyDown_Tab","","1^ͬ��&2^��ͬ��","")
		}
		else if (colName=="TApproveOption")
		{
			if (GetElementValue("Status")<1) continue;
			value=document.getElementById(Id).innerText;
			html=CreatElementHtml(1,Id,objwidth,objheight,"KeyDown_Tab","","","")
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


function SetElementEnabled()
{
	var Status=GetElementValue("Status");
	if (Status!="1")
	{
		SetElementsReadOnly("CancelReason",true);
	}
	else
	{
		SetElementsReadOnly("CancelReason",false);
	}
}

function SetElementsReadOnly(val,flag)
{
	var List=val.split("^")
	for(var i = 0; i < List.length; i++)
	{
		DisableElement(List[i],flag);
		ReadOnlyElement(List[i],flag);
		if (document.getElementById(GetLookupName(List[i])))
		{
			DisableElement(GetLookupName(List[i]),flag);
		}
	}
}


function GetRequestLoc (value)
{
    GetLookUpID("RequestLocDR",value);
}

function GetUseLoc (value)
{
    GetLookUpID("UseLocDR",value);
}


function LookUpModelNew(vClickEventFlag)
{
	selectrow=GetTableCurRow();
	if (event.keyCode==13||event.keyCode==0||vClickEventFlag==1)
	{
		LookUpModel("GetModel","TItemDRz"+selectrow+",TModelz"+selectrow);
	}
}

function GetModel(value)
{
	var list=value.split("^")
	SetElement('TModelz'+selectrow,list[0]);
	SetElement('TModelDRz'+selectrow,list[1]);
	var obj=document.getElementById("TModelz"+selectrow);
	if (obj) websys_nextfocusElement(obj);
}

function LookUpUnitNew(vClickEventFlag)
{
	selectrow=GetTableCurRow();
	if (event.keyCode==13||event.keyCode==0||vClickEventFlag==1)
	{
		LookUpUnit("GetUnitIDNew","TUnitz"+selectrow+",GetEquipUnitType");
	}
}

function GetUnitIDNew(value)
{
	var list=value.split("^")
	SetElement('TUnitz'+selectrow,list[0]);
	SetElement('TUnitDRz'+selectrow,list[1]);
	var obj=document.getElementById("TUnitz"+selectrow);
	if (obj) websys_nextfocusElement(obj);
}

function LookUpPurchaseTypeNew(vClickEventFlag)
{
	selectrow=GetTableCurRow();
	if (event.keyCode==13||event.keyCode==0||vClickEventFlag==1)
	{
		LookUpPurchaseType("GetPurchaseType","TPurchaseTypez"+selectrow);
	}
}

function GetPurchaseType(value)
{
	var list=value.split("^")
	SetElement('TPurchaseTypez'+selectrow,list[0]);
	SetElement('TPurchaseTypeDRz'+selectrow,list[1]);
	var obj=document.getElementById("TPurchaseTypez"+selectrow);
	if (obj) websys_nextfocusElement(obj);
}

function LookUpPurposeTypeNew(vClickEventFlag)
{
	selectrow=GetTableCurRow();
	if (event.keyCode==13||event.keyCode==0||vClickEventFlag==1)
	{
		LookUpPurposeType("GetPurposeType","TPurposeTypez"+selectrow);
	}
}

function GetPurposeType(value)
{
	var list=value.split("^")
	SetElement('TPurposeTypez'+selectrow,list[0]);
	SetElement('TPurposeTypeDRz'+selectrow,list[1]);
	var obj=document.getElementById("TPurposeTypez"+selectrow);
	if (obj) websys_nextfocusElement(obj);
}

function LookUpFundsOrigin(vClickEventFlag)
{
	selectrow=GetTableCurRow();
	if (event.keyCode==13||event.keyCode==0||vClickEventFlag==1)
	{
		LookUpFundsType("GetFundsType","");
	}
}

function GetFundsType(value)
{
	var list=value.split("^")
	SetElement('TFundsOriginz'+selectrow,list[0]);
	SetElement('TFundsOriginDRz'+selectrow,list[1]);
	var obj=document.getElementById("TFundsOriginz"+selectrow);
	if (obj) websys_nextfocusElement(obj);
}

function TotalFee_Change()
{
	selectrow=GetTableCurRow();
	var TPriceFee=GetElementValue("TPriceFeez"+selectrow)
	var TRequestNum=GetElementValue("TRequestNumz"+selectrow)
	
	var TotalFee=TPriceFee*TRequestNum
	if (TotalFee<=0)
	{
		SetElement('TAmountz'+selectrow,'');
	}
	else
	{
		SetElement('TAmountz'+selectrow,TotalFee.toFixed(2));
	}
	SumList_Change()
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
			var TPriceFee=parseFloat(GetElementValue("TPriceFeez"+i))
			var TRequestNum=parseInt(GetElementValue("TRequestNumz"+i))
			if ((isNaN(TPriceFee))||(isNaN(TRequestNum))) continue;
			var TotalFee=TPriceFee*TRequestNum
			Num=Num+TRequestNum
			Fee=Fee+TotalFee
		}
		else if (tableList[i]==-1)
		{
			var index=i
		}
	}
	SetElement('TRequestNumz'+index,Num);
	SetElement('TAmountz'+index,Fee.toFixed(2));
}

function LookUpEquip(vClickEventFlag)
{
	if (event.keyCode==13||event.keyCode==0||vClickEventFlag==1)
	{
		if (CheckNull()) return;
		selectrow=GetTableCurRow();
		LookUpMasterItem("GetMasterItem","EquipTypeDR,,TItemz"+selectrow);
	}
}

function CheckNull()
{
	if (CheckMustItemNull("EquipType")) return true;
	var obj=document.getElementById("cEquipType");
	if ((obj)&&(obj.className=="clsRequired"))
	{
		if (CheckItemNull(1,"EquipType")==true) return true;	
	}
	return false;
}

function GetMasterItem(value)
{
	Clear()
	//�ж��豸���ظ�--����ҽ�ƴ�ѧ��һ����ҽԺ����Ҫ���ж�
	var list=value.split("^")
	var Length=ObjSources.length
	for (var i=1;i<Length;i++)
	{
		var CurItemDR=GetElementValue("TItemDRz"+i)
		if ((tableList[i]=="0")&&(CurItemDR==list[1])&&(selectrow!=i))
		{
			alertShow("ѡ����豸�����"+GetCElementValue("TRowz"+i)+"���ظ�!")
			return;
		}
	}
	/****************************/
	var list=value.split("^")
	SetElement('TItemz'+selectrow,list[0]);
	SetElement('TItemDRz'+selectrow,list[1]);
	SetElement('TUnitDRz'+selectrow,list[5]);
	SetElement('TUnitz'+selectrow,list[6]);
	SetElement('TCommonNamez'+selectrow,list[0]);
	ObjSources[selectrow]=new SourceInfo("1",list[1]);
	var obj=document.getElementById("TItemz"+selectrow);
	if (obj) websys_nextfocusElement(obj);
}

function Clear()
{
	SetElement('TItemz'+selectrow,"");
	SetElement('TItemDRz'+selectrow,"");
	//����ҽ�ƴ�ѧ�����������Ϣ
	SetElement('TUnitDRz'+selectrow,"");
	SetElement('TUnitz'+selectrow,"");
	SetElement('TAdviseModelz'+selectrow,"");
	SetElement('TCommonNamez'+selectrow,"");
	SetElement('TFundsOriginz'+selectrow,"");
	SetElement('TFundsOriginDRz'+selectrow,"");
	SetElement('TModelz'+selectrow,"");
	SetElement('TModelDRz'+selectrow,"");
	SetElement('TPriceFeez'+selectrow,"");
	SetElement('TAmountz'+selectrow,"");
	SetElement('TPurchaseTypez'+selectrow,"");
	SetElement('TPurchaseTypeDRz'+selectrow,"");
	SetElement('TPurposeTypez'+selectrow,"");
	SetElement('TPurposeTypeDRz'+selectrow,"");
	SetElement('TRemarkz'+selectrow,"");
	SetElement('TRequestNumz'+selectrow,"");
}

function DeleteClickHandler() {
	var truthBeTold = window.confirm(t["-4003"]);
	if (!truthBeTold) return;
	try
	{
		var objtbl=document.getElementById('tDHCEQBuyRequestNN');
		var rows=objtbl.rows.length;
		selectrow=GetTableCurRow();
		var TotalFlag=GetElementValue("TotalFlag")
		
		var TRowID=GetElementValue('TRowIDz'+selectrow);
		tableList[selectrow]=TRowID;
		
		var delNo=GetElementValue("TRowz"+selectrow);

		if (((TotalFlag==0)&&(rows<=2))||((rows<=3)&&((TotalFlag==1)||(TotalFlag==2))))
		{
			//Modified by jdl 2011-01-28 JDL0068
			//�޸�ɾ����ʣ��һ�к�?�༭���������쳣?�޷����������
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


function GetTableInfo()
{
    var objtbl=document.getElementById('tDHCEQBuyRequestNN');
	var rows=tableList.length
	var valList="";
	for(var i=1;i<rows;i++)
	{
		if (tableList[i]=="0")
		{
			var TRow=GetCElementValue("TRowz"+i);
			var TRowID=GetElementValue("TRowIDz"+i);
			var TItemDR=GetElementValue("TItemDRz"+i);
			//����ҽ�ƴ�ѧ��һ����ҽԺ����Ҫ���ж�
			if (TItemDR=="")
			{
				alertShow("��"+TRow+"��,��ѡ����ȷ���豸���豸��")
				SetFocusColumn("TItem",i)
				return "-1"
			}
			var TCommonName=GetElementValue("TCommonNamez"+i);
			//����ҽ�ƴ�ѧ��һ����ҽԺ��Ҫ���ж�
			if (TCommonName=="")
			{
				alertShow("��"+TRow+"��,�������豸����!")
				SetFocusColumn("TCommonName",i)
				return "-1"
			}
			var TAdviseModel=GetElementValue("TAdviseModelz"+i);
			var TModelDR=GetModelRowID(GetElementValue("GetModelOperMethod"),i)
			if (TModelDR<0)
			{
				alertShow("��"+TRow+"��,����Զ�����ʧ��!")
				return "-1"
			}
			var TRequestNum=GetElementValue("TRequestNumz"+i);
			var TPriceFee=GetElementValue("TPriceFeez"+i);
			if ((TRequestNum=="")||(parseInt(TRequestNum)<=0))
			{
				alertShow("��"+TRow+"����������ȷ!");
				SetFocusColumn("TRequestNum",i)
				return "-1";
			}
			
			if (parseInt(TRequestNum)!=TRequestNum)
			{
				alertShow("��"+TRow+"����������ȷ,����ΪС��!");
				SetFocusColumn("TRequestNum",i)
				return "-1";
			}
				
			if ((TPriceFee=="")||(parseInt(TPriceFee)<0))
			{
				alertShow("��"+TRow+"��Ԥ�㵥�۲���ȷ!");   //Modefied by zc 2014-09-10 ZC0005
				SetFocusColumn("TPriceFee",i)
				return "-1";
			}
			var TUnitDR=GetElementValue("TUnitDRz"+i);
			var TPurchaseTypeDR=GetElementValue("TPurchaseTypeDRz"+i);
			var TPurposeTypeDR=GetElementValue("TPurposeTypeDRz"+i);
			var TFundsOriginDR=GetElementValue("TFundsOriginDRz"+i);
			var TRemark=GetElementValue("TRemarkz"+i);
			
			if(valList!="") {valList=valList+"&";}			
			valList=valList+TRow+"^"+TRowID+"^"+TItemDR+"^"+TCommonName+"^"+TAdviseModel+"^"+TModelDR+"^"+TRequestNum+"^"+TPriceFee+"^"+TUnitDR+"^"+TPurchaseTypeDR+"^"+TPurposeTypeDR+"^"+TFundsOriginDR+"^"+TRemark;
		}
	}
	return  valList
}

function GetValueList()
{
	var ValueList="";
	ValueList=GetElementValue("RowID");
	ValueList=ValueList+"^"+curUserID;
	ValueList=ValueList+"^"+GetElementValue("CancelToFlowDR");
	ValueList=ValueList+"^^^"+GetElementValue("RejectReason");
	
	return ValueList;
}

function GetRejectReason (value)
{
    GetLookUpID("RejectReasonDR",value);
}

function GetEquipType (value)
{
    GetLookUpID("EquipTypeDR",value);
}

function BApprove_Clicked()
{
	var combindata=GetValueList();
	//��ϸ��¼��֤--��������?�������
    var objtbl=document.getElementById('tDHCEQBuyRequestNN');
	var rows=tableList.length
	var valList="";
	var RejectFlag=0;
	for(var i=1;i<rows;i++)
	{
		if (tableList[i]=="0")
		{
			var TRow=GetCElementValue("TRowz"+i);
			var TApproveNum=GetElementValue("TApproveNumz"+i);
			var TOptionType=GetElementValue("TOptionTypez"+i);
			var TApproveOption=GetElementValue("TApproveOptionz"+i);
			var TRowID=GetElementValue("TRowIDz"+i);
			if ((TApproveNum=="")||(parseInt(TApproveNum)<=0))
			{
				alertShow("��"+TRow+"��������������ȷ!");
				SetFocusColumn("TApproveNum",i)
				return "-1";
			}
			if (parseInt(TApproveNum)!=TApproveNum)
			{
				alertShow("��"+TRow+"��������������ȷ,����ΪС��!");
				SetFocusColumn("TApproveNum",i)
				return "-1";
			}
			if ((TOptionType==1)&&(TApproveOption=="")) {TApproveOption="ͬ��"}
			if (TOptionType==2)
			{
				RejectFlag=1;
				if (TApproveOption=="")
				{
					alertShow("�������������д�ܾ�ԭ��!��ȡ���ύ!")
					SetFocusColumn("TApproveOption",i)
					return "-1"
				}
			}
			if (valList!="") {valList=valList+"&"}
			valList=valList+TRowID+"^"+TApproveOption
		}
	}
	if (RejectFlag!=0)
	{
		alertShow("��ϸ�д��ھܾ���¼�������������д�ܾ�ԭ��ȡ���ύ!")
		return
	}
	var CurRole=GetElementValue("CurRole")
  	if (CurRole=="") return;
	var RoleStep=GetElementValue("RoleStep")
  	if (RoleStep=="") return;
  	
  	var objtbl=document.getElementById('tDHCEQBuyRequestNN');
	var EditFieldsInfo=ApproveEditFieldsInfo(objtbl);
	if (EditFieldsInfo=="-1") return;
  	var encmeth=GetElementValue("AuditData")
  	if (encmeth=="") return;
	var Rtn=cspRunServerMethod(encmeth,combindata,CurRole,RoleStep,EditFieldsInfo,valList);
    if (Rtn>0)
    {
	    window.location.reload();
	}
    else
    {
	    alertShow(t["01"]);
    }
}

/****************************************************/
function BPrint_Clicked()
{
	var id=GetElementValue("RowID");
	if (""!=id)
	{
		//��ӡ
	}
}

//��ϸ��ӡ
function PrintListClickHandler()
{
	var RowID=GetElementValue("RowID");
	var Status=GetElementValue("Status");
	if (RowID>0)
	{
		
	}
	else
	{
		alertShow("���ȱ�������!")
		return
	}
}

//��֤
function BArgumentationClick()
{
	selectrow=GetTableCurRow();
	var SourceID=GetElementValue("RowID");
	var SourceListID=GetElementValue("TRowIDz"+selectrow);
	var SourceStatus=GetElementValue("Status");
	if (SourceListID>0)
	{
		var encmeth=GetElementValue("GetListOriginalFee")
		if (encmeth=="") return;
		var Rtn=cspRunServerMethod(encmeth,SourceListID);
		if (Rtn==0) //50�������豸��֤
		{
			var str='websys.default.csp?WEBSYS.TCOMPONENT=DHCEQ0001&SourceID='+SourceID+'&SourceListID='+SourceListID+'&SourceStatus='+SourceStatus;
		}
		else
		{
			var str='websys.default.csp?WEBSYS.TCOMPONENT=DHCEQ0002&SourceID='+SourceID+'&SourceListID='+SourceListID+'&SourceStatus='+SourceStatus;
		}
		window.open(str,'_blank','toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width=1100,height=640,left=80,top=0')
	}
	else
	{
		alertShow("���ȱ�������!")
		return
	}
}
//Ч�����

function BAffectAnalyseClick()
{
	selectrow=GetTableCurRow();
	var SourceID=GetElementValue("RowID");
	var SourceListID=GetElementValue("TRowIDz"+selectrow);
	var SourceStatus=GetElementValue("Status");
	if (SourceListID>0)
	{
		var encmeth=GetElementValue("GetListOriginalFee")
		if (encmeth=="") return;
		var Rtn=cspRunServerMethod(encmeth,SourceListID);
		if (Rtn==1)
		{
			var str='websys.default.csp?WEBSYS.TCOMPONENT=DHCEQ0005&SourceID='+SourceID+'&SourceListID='+SourceListID+'&SourceStatus='+SourceStatus;
    		window.open(str,'_blank','toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width=1100,height=640,left=80,top=0')
		}
		else
		{
			alertShow("50�������豸����ҪЧ�����!")
			return
		}
	}
	else
	{
		alertShow("���ȱ�������!")
		return
	}
}