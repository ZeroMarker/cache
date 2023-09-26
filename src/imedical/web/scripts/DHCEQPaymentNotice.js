/// DHCEQPaymentNotice.js
var selectrow=0;

///记录 设备 RowID 处理重复选择RowID的问题
var ObjSources=new Array();

//最后一行数据元素的名字的后缀序号
var LastNameIndex;
//新增一行数据元素的名字的后缀序号
var NewNameIndex;

function BodyLoadHandler() 
{
	KeyUp("Loc^Provider","N");
	
	InitPage();	
	FillData();
	SetEnabled();
	//InitEditFields(GetElementValue("ApproveSetDR"),GetElementValue("CurRole"));
	//InitApproveButton();
	SetTableItem('','','');
	
	Muilt_LookUp("Loc^Provider")
}
function InitPage()
{
	var obj=document.getElementById("BUpdate");
	if (obj) obj.onclick=BUpdate_Clicked;
	var obj=document.getElementById("BDelete");
	if (obj) obj.onclick=BDelete_Clicked;
	var obj=document.getElementById("BSubmit");
	if (obj) obj.onclick=BSubmit_Clicked;
	var obj=document.getElementById("BCancelSubmit");		// 作废
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
	var sort=31;
	SetElement("PaymentNoticeNo",list[0]);
	SetElement("PaymentNoticeDate",list[1]);
	SetElement("LocDR",list[2]);
	SetElement("Loc",list[sort+0]);
	SetElement("ProviderDR",list[3]);
	SetElement("Provider",list[sort+1]);
	SetElement("Bank",list[4]);
	SetElement("BankAccount",list[5]);
	SetElement("AccountDate",list[6]);
	SetElement("TotalFee",list[7]);
	SetElement("TotalFeeA",list[sort+2]);
	SetElement("PurposeType",list[8]);
	SetElement("AccountType",list[9]);
	SetElement("Agent",list[10]);
	SetElement("Status",list[11]);
	SetElement("Remark",list[12]);
	SetElement("Hold1",list[26]);
	SetElement("Hold2",list[27]);
	SetElement("Hold3",list[28]);
	SetElement("Hold4",list[29]);
	SetElement("Hold5",list[30]);
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
	//审核后才可打印及生成转移单
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
  	combindata=combindata+"^"+GetElementValue("PaymentNoticeNo");
  	combindata=combindata+"^"+GetElementValue("PaymentNoticeDate");
  	combindata=combindata+"^"+GetElementValue("LocDR");
  	combindata=combindata+"^"+GetElementValue("ProviderDR");
  	combindata=combindata+"^"+GetElementValue("Bank");
	combindata=combindata+"^"+GetElementValue("BankAccount");
	combindata=combindata+"^"+GetElementValue("AccountDate");
  	combindata=combindata+"^" //+GetElementValue("TotalFee");	由于金额带百分位不适合直接存储,该总金额在类更新时从明细汇总取
  	combindata=combindata+"^"+GetElementValue("PurposeType");
  	combindata=combindata+"^"+GetElementValue("AccountType");
  	combindata=combindata+"^"+GetElementValue("Agent");
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
  	//alertShow(DelRowid)
	var Rtn=cspRunServerMethod(encmeth,combindata,valList,DelRowid);
	if (Rtn>0)
    {
	    window.location.href= 'websys.default.csp?WEBSYS.TCOMPONENT=DHCEQPaymentNotice&RowID='+Rtn;
	}
    else
    {
	    alertShow(Rtn);
    }
}
function BDelete_Clicked()
{
	var truthBeTold = window.confirm("确定要删除该凭单?");
	if (!truthBeTold) return;
	var RowID=GetElementValue("RowID")
  	var encmeth=GetElementValue("DeleteData")
  	if (encmeth=="") return;
	var Rtn=cspRunServerMethod(encmeth,RowID);
	if (Rtn=="0")
    {
		window.location.href= 'websys.default.csp?WEBSYS.TCOMPONENT=DHCEQPaymentNotice';
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
function BCancelSubmit_Clicked() // 作废
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
	var objtbl=document.getElementById('tDHCEQPaymentNotice');
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
					if (obj) obj.innerText="合计:"
					obj=document.getElementById("BDeleteListz"+i);
					if (obj) obj.innerText="";
					tableList[i]=-1;
					continue;
				}
			}
			ChangeRowStyle(objtbl.rows[i],SourceType);		///改变一行的内容显示
		}
	}
	else
	{
		if (selectrow=='') selectrow=RowNo;
		tableList[RowNo]=0;
		ChangeRowStyle(objtbl.rows[selectrow],SourceType);	///改变一行的内容显示
	}
}
///改变一行的内容显示
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
			//html=CreatElementHtml(4,Id,objwidth,objheight,"KeyDown_Tab","SourceType_Change","1^入库单&2^转移单&3^减少单","")
			html=CreatElementHtml(4,Id,objwidth,objheight,"KeyDown_Tab","SourceType_Change","1^发票号","")
		}
		else if (colName=="TSourceNo")
		{
			if (CheckUnEditField(Status,colName)) continue;
			value=document.getElementById(Id).innerText
         	html=CreatElementHtml(2,Id,objwidth,objheight,"LookUpSourceNo","","","SourceNoKeyUp")
		}
		else if (colName=="TAmountFee")
		{
			if (CheckUnEditField(Status,colName)) continue;
			value=document.getElementById(Id).innerText;
       		html=CreatElementHtml(1,Id,objwidth,objheight,"KeyDown_Tab","","","SumList_Change")	
			var objTSourceType=document.getElementById(Id);
			if(objTSourceType)
			{
				objTSourceType.onkeypress=NumberPressHandler
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
function SourceType_Change()
{
	var eSrc=window.event.srcElement;
	if (eSrc.tagName=="IMG") eSrc=window.event.srcElement.parentElement;
	var objtbl=document.getElementById('tDHCEQPaymentNotice'); //得到表格   t+组件名称
	var rows=objtbl.rows.length;
	var lastrowindex=rows - 1;
	var rowObj=getRow(eSrc);
	selectrow=rowObj.rowIndex;								//当前选择行
	RowNo=GetTableCurRow();
	var TSourceType=GetElementValue("TSourceTypez"+RowNo)
	SetElement("TSourceTypeDRz"+RowNo,TSourceType);
	if (TSourceType==1)
	{
		SetTableItem(RowNo,"1",selectrow);		///改变一行的内容显示
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
				LookUpInvoice();
			}
		}
	}
}

function LookUpInvoice()
{
	LookUp("","web.DHCEQPaymentNotice:GetInvoice","GetInvoice",",ProviderDR,TSourceNoz"+selectrow+",TRowIDz"+selectrow);
}
function GetInvoice(value)
{
	Clear();
	var TotalFlag=GetElementValue("TotalFlag")
	var list=value.split("^")
	var Length=ObjSources.length
	for (var i=1;i<Length;i++)
	{
		//alertShow(ObjSources[i].SourceType+"&"+ObjSources[i].SourceID+"&"+list[1]);
		if ((tableList[i]=="0")&&(ObjSources[i].SourceType=="1")&&(ObjSources[i].SourceID==list[0])&&(selectrow!=i))
		{
			alertShow("选择的入库单与第"+GetCElementValue("TRowz"+i)+"行重复!")
			return;
		}
	}
	SetElement("TSourceIDz"+selectrow,list[0]);
	SetElement("TExtendTypez"+selectrow,list[1]);
	SetElement("TExtendIDz"+selectrow,list[2]);
	SetElement("TSourceNoz"+selectrow,list[3]);
	SetElement("TExtendNoz"+selectrow,list[4]);
	SetElement("TExtendDatez"+selectrow,list[5]);
	SetElement("TEquipNamez"+selectrow,list[6]);
	SetElement("TManuFactoryz"+selectrow,list[7]);
	SetElement("TOriginalFeez"+selectrow,list[8]);
	SetElement("TQuantityNumz"+selectrow,list[9]);
	SetElement("TTotalFeez"+selectrow,list[8]*list[9]);
	SetElement("TAmountFeez"+selectrow,list[8]*list[9]);
	SumList_Change();
	ObjSources[selectrow]=new SourceInfo("1",list[0]);
	var obj=document.getElementById("TSourceNoz"+selectrow);
	if (obj) websys_nextfocusElement(obj);
}

function SumList_Change()
{
	var length=tableList.length;
	var Fee=0;
	for (var i=1;i<length;i++)
	{
		if (tableList[i]=="0")
		{
			var TAmountFee=parseFloat(GetElementValue("TAmountFeez"+i));
			if (isNaN(TAmountFee)) continue;
			Fee=Fee+TAmountFee;
		}
		else if (tableList[i]==-1)
		{
			var index=i;
		}
	}
	SetElement('TAmountFeez'+index,Fee.toFixed(2));
}
function AddClickHandler()
{
	try 
	{
		var objtbl=document.getElementById('tDHCEQPaymentNotice');
		var ret=CanAddRow(objtbl);
		if (ret)
		{
			NewNameIndex=tableList.length;
	    	AddRowToList(objtbl,LastNameIndex,NewNameIndex);
	    	
			//设置默认的来源类型与上一行一致
			var PreSourceType=GetElementValue("TSourceTypez"+LastNameIndex);
			SetElement("TSourceTypez"+NewNameIndex,PreSourceType);
			//新增行隐藏附件图标
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
	var truthBeTold = window.confirm("您确认要删除该记录吗?");
	if (!truthBeTold) return;
	try
	{
		var objtbl=document.getElementById('tDHCEQPaymentNotice');
		var rows=objtbl.rows.length;
		selectrow=GetTableCurRow();
		var TotalFlag=GetElementValue("TotalFlag")
		var TRowID=GetElementValue('TRowIDz'+selectrow);
		tableList[selectrow]=TRowID;
		var delNo=GetElementValue("TRowz"+selectrow);

		if (((TotalFlag==0)&&(rows<=2))||((rows<=3)&&((TotalFlag==1)||(TotalFlag==2))))
		{
			//修改删除仅剩的一行后,编辑保存数据异常,无法保存的问题
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
function GetTableInfo()
{
    var objtbl=document.getElementById('tDHCEQPaymentNotice');
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
			var TExtendType=GetElementValue("TExtendTypez"+i);
			var TExtendID=GetElementValue("TExtendIDz"+i);
			var ProviderDR=GetElementValue("ProviderDR");
			var TAmountFee=GetElementValue("TAmountFeez"+i);
			var TRemark=GetElementValue("TRemarkz"+i);
			var TSourceNo=GetElementValue("TSourceNoz"+i);
			if ((TSourceNo=="")||(TSourceID==""))
			{
				alertShow("第"+TRow+"行,请选择正确的设备业务单.")
				SetFocusColumn("TSourceNo",i)
				return "-1";
			}
			var THold1=GetElementValue("THold1z"+i);
			var THold2=GetElementValue("THold2z"+i);
			var THold3=GetElementValue("THold3z"+i);
			var THold4=GetElementValue("THold4z"+i);
			var THold5=GetElementValue("THold5z"+i);
			
			if(valList!="") valList=valList+"&";
			valList=valList+TRow+"^"+TRowID+"^"+TSourceType+"^"+TSourceID+"^"+TExtendType+"^"+TExtendID+"^"+ProviderDR+"^"+TAmountFee+"^"+TRemark;
			valList=valList+"^"+111+"^"+222+"^"+333+"^"+444+"^"+555;
			valList=valList+"^"+THold1+"^"+THold2+"^"+THold3+"^"+THold4+"^"+THold5;
		}
	}
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
			if (isNaN(TAmountFee)) continue;
			Fee=Fee+TAmountFee;
		}
		else if (tableList[i]==-1)
		{
			var index=i
		}
	}
	SetElement('TAmountFeez'+index,Fee.toFixed(2));
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
	var encmeth=GetElementValue("GetRepPath");
	if (encmeth=="") return;
	var	TemplatePath=cspRunServerMethod(encmeth);
	
	try
	{
        var xlApp,xlsheet,xlBook;
	    var Template=TemplatePath+"DHCEQPaymentNotice.xls";
	    xlApp = new ActiveXObject("Excel.Application");
    	xlBook = xlApp.Workbooks.Add(Template);
	   	xlsheet = xlBook.ActiveSheet;
	    var sort=31;
	    //医院名称替换
	    xlsheet.cells.replace("[Hospital]",GetElementValue("GetHospitalDesc"));
    	xlsheet.cells(2,2)=list[0];
    	xlsheet.cells(2,4)=list[sort+1];
    	xlsheet.cells(3,2)=list[5];
		xlsheet.cells(3,4)=list[4];
		xlsheet.cells(4,2)=list[sort+2];
		xlsheet.cells(5,2)=list[7];
    	xlsheet.cells(5,4)=ChangeDateFormat(list[6]);
    	xlsheet.cells(6,2)=list[8];
    	xlsheet.cells(7,2)=list[9];
		xlsheet.cells(7,4)=list[10];
    	xlsheet.cells(7,6)=list[sort+3];
    	
		var obj = new ActiveXObject("PaperSet.GetPrintInfo");
		var size=obj.GetPaperInfo("DHCEQInStock");
		if (0!=size) xlsheet.PageSetup.PaperSize = size;
		
		//xlsheet.printout; 	//打印输出
		xlApp.Visible=true;
	    xlsheet.PrintPreview();
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
document.body.onload = BodyLoadHandler;