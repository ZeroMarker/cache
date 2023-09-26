var selectrow=0;
//���һ������Ԫ�ص����ֵĺ�׺���
var LastNameIndex;
//����һ������Ԫ�ص����ֵĺ�׺���
var NewNameIndex;

function BodyLoadHandler()
{
	InitUserInfo(); //ϵͳ����
	//SetElement("Status",GetElementValue("GetStatus"));
	SetTableItem();
	InitEvent();
	//FillData();
}
function InitEvent()
{
	var obj=document.getElementById("BUpdate");
	if (obj) obj.onclick=BUpdate_Clicked;
	var obj=document.getElementById("BSubmit");
	if (obj) obj.onclick=BSubmit_Clicked;
}

function FillData()
{
	var SwapDR=GetElementValue("SwapDR");
	if (SwapDR=="") return
	var obj=document.getElementById("fillData");
	if (obj){var encmeth=obj.value} else {var encmeth=""};
	var ReturnList=cspRunServerMethod(encmeth,SwapDR);
	ReturnList=ReturnList.replace(/\\n/g,"\n");
	list=ReturnList.split("^");
	var sort=25;
	SetElement("SwapNo",list[0]);
	SetElement("Type",list[1]);
	SetElement("LocDR",list[2]);
	SetElement("Loc",list[sort]);
	SetElement("RequestLocDR",list[3]);
	SetElement("RequestLoc",list[sort+1]);
	SetElement("RequestDate",list[4]);
	SetElement("RequestUserDR",list[5]);
	SetElement("RequestUser",list[sort+2]);
	SetElement("Status",list[9]);
}

function GetValueList()
{
	var combindata="";
  	combindata=GetElementValue("SwapDR");
  	combindata=combindata+"^"+GetElementValue("Type") ;
  	combindata=combindata+"^"+GetElementValue("LocDR") ;
  	combindata=combindata+"^"+GetElementValue("RequestLocDR") ;
	combindata=combindata+"^"+GetElementValue("RequestDate") ;
	combindata=combindata+"^"+GetElementValue("RequestUserDR") ;
	combindata=combindata+"^"+curUserID;
	combindata=combindata+"^"+GetElementValue("Job");
	return combindata
}

function GetTableInfo()
{
	var rows=tableList.length
	var valList="";
	for(var i=1;i<rows;i++)
	{
		if (tableList[i]=="0") //����0��ʾҳ����ʾ��¼
		{
			var TRow=GetCElementValue("TRowz"+i);
			var TRowID=GetElementValue('TRowIDz'+i);
			var TSwapDR=GetElementValue('TSwapDRz'+i);
			var TSwapListDR=GetElementValue('TSwapListDRz'+i);
			var TMasterItem=GetElementValue('TMasterItemz'+i);
			if (TMasterItem=="")
			{
				alertShow("��"+TRow+"��δѡ���豸!")
				return "-1"			
			}
			var TMasterItemDR=GetElementValue('TMasterItemDRz'+i);
			var TModelDR=GetElementValue('TModelDRz'+i);
			if (TMasterItemDR=="")
			{
				alertShow("��"+TRow+"����ϸΪ��,����!")
				return "-1"
			}
			
			var TQuantityNum=parseInt(GetElementValue('TQuantityNumz'+i));
			if ((TQuantityNum=="")||(TQuantityNum<=0))
			{
				alertShow("��"+TRow+"��������������,����!")
				return "-1"
			}
			if (GetElementValue('TQuantityNumz'+i)!=TQuantityNum)
			{
				alertShow("��"+TRow+"����������ȷ,����ΪС��!");
				SetFocusColumn("TQuantityNum",i)
				return "-1";
			}
			var TSupplementNum=parseInt(GetElementValue('TSupplementNumz'+i));
			if ((TSupplementNum=="")||(TSupplementNum<=0))
			{
				alertShow("��"+TRow+"��������������,����!")
				return "-1"
			}
			if (GetElementValue('TSupplementNumz'+i)!=TSupplementNum)
			{
				alertShow("��"+TRow+"����������ȷ,����ΪС��!");
				SetFocusColumn("TSupplementNum",i)
				return "-1";
			}
			var TLocDR=GetElementValue('TLocDRz'+i);
			var TDamagedAllotQty=GetElementValue('TDamagedAllotQtyz'+i);
			var TDifference=GetElementValue('TDifferencez'+i);
			var THold1=GetElementValue("THold1z"+i);
			var THold2=GetElementValue("THold2z"+i);
			var THold3=GetElementValue("THold3z"+i);
			var THold4=GetElementValue("THold4z"+i);
			var THold5=GetElementValue("THold5z"+i);
			if(valList!="") {valList=valList+"&";}
			valList=valList+TRow+"^"+TRowID+"^"+TSwapDR+"^"+TSwapListDR+"^"+TLocDR+"^"+TMasterItemDR+"^"+TModelDR+"^"+TQuantityNum+"^"+TSupplementNum+"^"+TDifference+"^"+TDamagedAllotQty+"^"+THold1+"^"+THold2+"^"+THold3+"^"+THold4+"^"+THold5;		
		}
	}
	return  valList
}

function BUpdate_Clicked()
{
	if (CheckNull()) return;
  	var valList=GetTableInfo(); //��ϸ��Ϣ
  	if (valList=="-1")  return; //��ϸ��Ϣ����	
  	var SwapDR=GetElementValue('TSwapDRz2');
  	var QuantityNum=GetElementValue('TQuantityNumz1');
  	var SupplementNum=GetElementValue('TSupplementNumz1');
  	var encmeth=GetElementValue("CheckData")
  	if (encmeth=="") return;
  	var rtn=cspRunServerMethod(encmeth,SwapDR,QuantityNum,SupplementNum);
  	if (rtn!="")
  	{
		alertShow(rtn)
		return  	
	}
	var encmeth=GetElementValue("UpdateData")
  	if (encmeth=="") return;
	var rtn=cspRunServerMethod(encmeth,SwapDR,valList);
	var list=rtn.split("^");
	if ((list[1]!="")&&(list.length>1))
	{
		alertShow("��"+list[0]+"��"+list[1])
	}
	else
	{
		if (list[0]>0)
		{
			window.location.href= 'websys.default.csp?WEBSYS.TCOMPONENT=DHCEQSwapListDetail&SwapDR='+rtn;
		}
		else
		{
			if (list[0]=="-1015")
			{
				alertShow(t[list[0]])
			}
			else
			{
				alertShow(t["01"])
			}
		}
	}
}

function BSubmit_Clicked()
{
	if (CheckNull()) return;
	var combindata=GetValueList();
  	var valList=GetTableInfo();
  	if (valList=="-1") return
  	if (valList=="")
  	{
	  	alertShow("����ϸ��¼���ɱ���!")
	  	return
  	}
  	var encmeth=GetElementValue("SubmitData")
  	if (encmeth=="") return;
	var rtn=cspRunServerMethod(encmeth,combindata,valList);
	if (rtn>0)
    {
	    window.location.href='websys.default.csp?WEBSYS.TCOMPONENT=DHCEQSwapListDetail&SwapDR='+rtn;
	}
    else
    {
	    if (isNaN(rtn))
	    {
		    alertShow(rtn+"   "+t["01"]);
	    }
	    else
	    {
		    alertShow(t[rtn]+"   "+t["01"]);
	    }
    }
}


function SetTableItem()
{
	var objtbl=document.getElementById('tDHCEQSwapListDetail');
	var rows=objtbl.rows.length-1;
	for (var i=1;i<=rows;i++)
	{
		var TRow=document.getElementById("TRowz"+i).innerHTML;  //�б������ʼ��			
		var TRowID=GetElementValue("TRowIDz"+i);
		//var TotalFlag=GetElementValue("TotalFlag")
		if (TRowID==-1)
		{
			obj=document.getElementById("BDeleteListz"+i);
			if (obj) obj.innerText=""
			tableList[i]=-1
			continue;
		}
		tableList[i]=0
		ChangeRowStyle(objtbl.rows[i]);		///�ı�һ�е�������ʾ
	}
}

///�ı�һ�е�������ʾ
function ChangeRowStyle(RowObj)
{
	//var Status=GetElementValue("THold1z2"); //modify BY:GBX
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
		/*
		if (colName=="TMasterItem")
		{
			if (CheckUnEditField(Status,colName)) continue;
			value=document.getElementById(Id).innerText;
         	html=CreatElementHtml(2,Id,objwidth,objheight,"LookUpMasterItemNew","","","KeyupMasterItem")
		}
		else if (colName=="TModel")
		{
			if (CheckUnEditField(Status,colName)) continue;
			value=document.getElementById(Id).innerText;
         	html=CreatElementHtml(2,Id,objwidth,objheight,"LookUpModelNew","","","Standard_TableKeyUp")	
		}
		*/
		if (colName=="TQuantityNum")
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
		else if (colName=="TSupplementNum")
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

//��ϸɾ������
function DeleteClickHandler()
{
	var truthBeTold = window.confirm(t["-4003"]);
	if (!truthBeTold) return
	try
	{
		var objtbl=document.getElementById('tDHCEQSwapNew');
		var rows=objtbl.rows.length;
		selectrow=GetTableCurRow();
		
		var TRowID=GetElementValue('TRowIDz'+selectrow);
		tableList[selectrow]=TRowID	
		var delNo=GetElementValue("TRowz"+selectrow);
		//�ж��Ƿ�ɾ����ʣ��1�м�¼
		if (rows<=3) 
		{
			//Modified by jdl 2011-01-28 JDL0068
			//�޸�ɾ����ʣ��һ�к�?�༭���������쳣?�޷����������
			tableList[selectrow]=0;
			if (TRowID!="")
			{
				SetElement('TRowIDz'+selectrow,"");				
				tableList[tableList.length]=TRowID;
			}
			ClearValue()
			SetElement("Job","")
		}
		else
		{
			DeleteTabRow(objtbl,selectrow);
			SumList_Change();
		}
	    ResetNo(selectrow,delNo) //���²����µ����
	} catch(e) {};
}
function DeleteTabRow(objtbl,selectrow)
{
	var rows=objtbl.rows.length;
	if (rows>2)
	{
		var eSrc=window.event.srcElement;
		var rowObj=getRow(eSrc);
		var selectrow=rowObj.rowIndex; //��ǰѡ����
		objtbl.deleteRow(selectrow);
	}
}

function TotalFee_Change()
{
	selectrow=GetTableCurRow();
	var TQuantityNum=parseInt(GetElementValue("TQuantityNumz"+selectrow))
	var TSupplementNum=parseInt(GetElementValue("TSupplementNumz"+selectrow))
	/*
	/��֤�����Ƿ���ȷ?�Ƿ��ڿ�淶Χ�ڵ�?�ȴ�����
	if((TQuantityNum>TMoveNum)||(TQuantityNum<1))
	{
		alertShow("������Ч!")
		SetElement('TQuantityNumz'+selectrow,'');
		TQuantityNum=""
	}
	if (isNaN(TSupplementNum)||isNaN(TQuantityNum))
	{
		SetElement('TTotalFeez'+selectrow,'');
	}
	*/
	SumList_Change();
}

function SumList_Change()
{
	var length=tableList.length
	var TotalQty=0
	var TotalSmt=0
	var index=""
	for (var i=0;i<length;i++)
	{
		if (tableList[i]=="0")
		{
			var TSupplementNum=parseInt(GetElementValue("TSupplementNumz"+i))
			var TQuantityNum=parseInt(GetElementValue("TQuantityNumz"+i))
			if ((isNaN(TSupplementNum))||(isNaN(TQuantityNum))) continue;
			TotalQty=TotalQty+TQuantityNum
			TotalSmt=TotalSmt+TSupplementNum
		}
		else if (tableList[i]==-1)
		{
			var index=i
		}
	}
	SetElement('TQuantityNumz'+index,TotalQty);
	SetElement('TSupplementNumz'+index,TotalSmt);
}

function LookUpMasterItemNew(vClickEventFlag)
{
	if (event.keyCode==13||event.keyCode==0||vClickEventFlag==1)
	{
		if (CheckNull()) return;
		selectrow=GetTableCurRow();
		LookUpMasterItem("GetMasterItem","EquipTypeDR,StatCatDR,TMasterItemz"+selectrow);
	}
}

function GetMasterItem(value)
{
	Clear()
	var list=value.split("^")
	var Length=selectrow

	for (var i=1;i<Length;i++)
	{
		if ((tableList[i]=="0")&&(GetElementValue("TMasterItemDRz"+i)==list[1])&&(selectrow!=i))
		{
			alertShow("ѡ����豸�����"+GetCElementValue("TRowz"+i)+"���ظ�!")
			return;
		}
	}
	SetElement('TMasterItemz'+selectrow,list[0]);
	SetElement('TMasterItemDRz'+selectrow,list[1]);
	var obj=document.getElementById("TMasterItemz"+selectrow);
	if (obj) websys_nextfocusElement(obj);
}

function KeyupMasterItem()
{
	selectrow=GetTableCurRow();
	SetElement('TMasterItemDRz'+selectrow,"");
}

function LookUpModelNew(vClickEventFlag)
{
	selectrow=GetTableCurRow();
	if (event.keyCode==13||event.keyCode==0||vClickEventFlag==1)
	{
		LookUpModel("GetModel","TMasterItemDRz"+selectrow+",TModelz"+selectrow);
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


function CheckNull()
{
	if (CheckMustItemNull()) return true;
	return false;
}

function Clear()
{
	
}

function GetRequestUser (value)
{
    GetLookUpID("RequestUserDR",value);
}

function GetRequestLoc (value)
{
    GetLookUpID("RequestLocDR",value);
}

function GetLoc (value)
{
    GetLookUpID("LocDR",value);
}

document.body.onload = BodyLoadHandler;