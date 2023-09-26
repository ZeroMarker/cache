/// Modified By HZY 2012-02-24 HZY0023
/// 修改函数:BodyLoadHandler , SetTableEvent 
/// 新增函数:GetIssue , 
/// ---------------------------------------------------------
/// Modified By HZY 2012-02-10 HZY0022
/// 修改函数:BOK_Click
var SelectedRow = 0;
var rowid=0;
var RowCount=0;
var TableCurRow=0;
var Component="tDHCEQFunds"
function BodyLoadHandler() 
{
	//InitStandardKeyUp();
	if (GetElementValue("FromType")=="7") Component="tDHCEQCAFunds";
	var GetIssueOperMethod=GetElementValue("GetIssueOperMethod");	
	if (GetIssueOperMethod=="") SetElement("GetIssueOperMethod", "0");	//Add BY HZY 2012-02-24 HZY0023
	if (1==GetElementValue("ReadOnly"))
	{
		DisableBElement("BAdd",true);
		DisableBElement("BUpdate",true);
		DisableBElement("BDelete",true);
		DisableBElement("BOK",true);
	}	
	InitButton(false);
	if (GetElementValue("GetSelfFundsID")=="")
	{
		alertShow("自有资金参数未设置!")
		return
	}
	SetTableEvent();
	RefreshTable()	//DJ0135
}

function InitButton(isselected)
{
	var obj=document.getElementById("BClose");
	if (obj) obj.onclick=BClose_Click;
	
	if (1==GetElementValue("ReadOnly")) return;
	var obj=document.getElementById("BAdd");
	if (obj) obj.onclick=BAdd_Click;	
	var obj=document.getElementById("BUpdate");
	if (obj) obj.onclick=BUpdate_Click;	
	var obj=document.getElementById("BDelete");
	if (obj) obj.onclick=BDelete_Click;	
	DisableBElement("BAdd",isselected);
	DisableBElement("BUpdate",!isselected);
	DisableBElement("BDelete",!isselected);
	var obj=document.getElementById("BOK");
	if (obj) obj.onclick=BOK_Click;	
}

function Selected(selectrow)
{
	if (SelectedRow==selectrow)	{	
		Clear();	
		SelectedRow=0;
		rowid=0;
		SetElement("RowID","");
		InitButton(false);
		}
	else{
		SelectedRow=selectrow;
		rowid=GetElementValue("TRowIDz"+SelectedRow);
		SetElement("RowID",rowid);
		SetData(rowid);
		InitButton(true);
		}
}

function BAdd_Click() 
{
	SaveData();
}

function BUpdate_Click() 
{
	SaveData();
}

function BDelete_Click() 
{
	rowid=GetElementValue("RowID");
	if (rowid=="")	{
		alertShow(t['04']);
		return;
	}
	var truthBeTold = window.confirm(t['03']);
    if (!truthBeTold) return;
	var encmeth=GetElementValue("GetDel");
	if (encmeth=="")
	{
		alertShow(t[-4001]);
		return;
	}
	var result=cspRunServerMethod(encmeth,rowid,GetElementValue("FromType"),GetElementValue("FromID"));
	
	if (result==0)
	{	location.reload();	}
}

function BClose_Click() 
{
	window.close();
}

function GetFundsType(value)
{
	GetLookUpID('FundsTypeDR',value);
}

function GetFundsRecord(value)
{
	GetLookUpID('NoDR',value);
}


function CombinData() 
{
	var combindata="";
	combindata=GetElementValue("RowID") ;
	combindata=combindata+"^"+GetElementValue("EquipDR");
	combindata=combindata+"^"+GetElementValue("FundsTypeDR");
	combindata=combindata+"^"+GetElementValue("Fee");
	combindata=combindata+"^"+GetElementValue("CheckListDR");
	combindata=combindata+"^"+GetElementValue("OldRowDR");
	combindata=combindata+"^"	//+GetElementValue("OperFlag");
	combindata=combindata+"^"	//+GetElementValue("UpdateUserDR");
	combindata=combindata+"^"	//+GetElementValue("UpdateDate");
	combindata=combindata+"^"	//+GetElementValue("UpdateTime");
	combindata=combindata+"^"	//+GetElementValue("InvalidFlag");
	combindata=combindata+"^"+GetElementValue("Hold1");
	combindata=combindata+"^"+GetElementValue("Hold2");
	combindata=combindata+"^"+GetElementValue("Hold3");
	combindata=combindata+"^"+GetElementValue("Hold4");
	combindata=combindata+"^"+GetElementValue("Hold5");
	combindata=combindata+"^"+GetElementValue("NoDR");
	combindata=combindata+"^"+GetElementValue("No");
  	return combindata;
}

function SelectRowHandler()	{
	var eSrc=window.event.srcElement;
	var objtbl=document.getElementById(Component);
	var rows=objtbl.rows.length;
	
	var lastrowindex=rows - 1;
	
	var rowObj=getRow(eSrc);
	var selectrow=rowObj.rowIndex;

	if (!selectrow) return;
	Selected(selectrow);
}

function SetData(rowid)
{
	var encmeth=GetElementValue("GetDataByID");
	if (encmeth=="")
	{
		alertShow(t[-4001]);
		return;
	}
	var gbldata=cspRunServerMethod(encmeth,rowid);
	gbldata=gbldata.replace(/\\n/g,"\n");
	var list=gbldata.split("^");
	var sort=16
	SetElement("EquipDR",list[0]);
	SetElement("FundsTypeDR",list[1]);
	SetElement("FundsType",list[sort]);
	SetElement("Fee",list[2]);
	SetElement("CheckListDR",list[3]);
	SetElement("OldRowDR",list[4]);
	//SetElement("OperFlag",list[5]);
	//SetElement("UpdateUserDR",list[6]);
	//SetElement("UpdateDate",list[7]);
	//SetElement("UpdateTime",list[8]);
	//SetElement("InvalidFlag",list[9]);
	SetElement("Hold1",list[10]);
	SetElement("Hold2",list[11]);
	SetElement("Hold3",list[12]);
	SetElement("Hold4",list[13]);
	SetElement("Hold5",list[14]);
	SetElement("NoDR",list[15]);
	SetElement("No",list[sort+1]);
}

function SaveData()
{
	if (CheckMustItemNull()) return ;
	var encmeth=GetElementValue("GetSave");
	if (encmeth=="")
	{
		alertShow(t[-4001]);
		return;
	}
	if (!CheckAmount()) return;
	var plist=CombinData();
	var result=cspRunServerMethod(encmeth,"","",plist,GetElementValue("FromType"),GetElementValue("FromID"));
	if (result>0)
	{	location.reload();	}
}

function CheckAmount()
{
	var FromType=GetElementValue("FromType");
	var FromID=GetElementValue("FromID")
	var RowID=GetElementValue("RowID")
	var Fee=GetElementValue("Fee")
	if (Fee=="") return false;
	if (Fee<0)
	{
		alertShow(t['02']);
		return false;
	}
	var encmeth=GetElementValue("CheckAmount");	
	//alertShow(FromType+"&"+FromID+"&"+RowID+"&"+Fee)
	var result=cspRunServerMethod(encmeth,FromType,FromID,RowID,Fee);
	if (result=="2")
	{
		alertShow(t['01']);
		return false;
	}
	return true;
}

function InitStandardKeyUp()
{
	KeyUp("FundsType^No");
	Muilt_LookUp("FundsType^No");
}

function Clear()
{
	SetElement("RowID","");
	//SetElement("EquipDR","");
	SetElement("FundsType","");
	SetElement("FundsTypeDR","");
	SetElement("Fee","");
	SetElement("CheckListDR","");
	SetElement("OldRowDR","");
	SetElement("OperFlag","");
	//SetElement("UpdateUserDR","");
	//SetElement("UpdateDate","");
	//SetElement("UpdateTime","");
	//SetElement("InvalidFlag","");
	SetElement("Hold1","");
	SetElement("Hold2","");
	SetElement("Hold3","");
	SetElement("Hold4","");
	SetElement("Hold5","");
	SetElement("No","");
	SetElement("NoDR","");
}

///Modified By HZY 2012-02-10 HZY0022
function BOK_Click()
{
	//检测自有资金参数是否设置
	if (GetElementValue("GetSelfFundsID")=="")
	{
		alertShow("自有资金参数未设置!")
		return
	}
	//检测金额是否正确?及一致
	var fundsAmount=GetElementValue("FundsAmount");	//Add By HZY 2012-02-10 HZY0022
	var Amount=0
	for (var i=1;i<=RowCount;i++)
	{
		var CurFee=GetElementValue("TFeez"+i)
		var Desc=GetElementValue("TFundsTypez"+i)
		if (isNaN(CurFee)||((CurFee<0)&&(fundsAmount>0))||((CurFee>0)&&(fundsAmount<0)))
		{	//当'总金额'大于0时,每项资金来源的值应该大于或等于0;
			//当'总金额'小于0时,每项资金来源的值应该小于或等于0;
			//当'总金额'等于0时,每项资金来源可为正负数或0..Modified By HZY 2012-02-10 HZY0022
			alertShow("["+Desc+"]金额设置有误!请正确输入!")
			return
		}
		Amount=Amount+CurFee*1
		var CurFundsFee=GetElementValue("TCurFundsFeez"+i)		//DJ0135 begin
		var CurDepreTotalFee=GetElementValue("TCurDepreTotalFeez"+i)
		if ((isNaN(CurFundsFee))||(CurFundsFee<0))
		{
			alertShow("变动后资金来源金额不能小于0!")
			return
		}
		if ((isNaN(CurDepreTotalFee))||(CurDepreTotalFee<0))
		{
			alertShow("变动后累计折旧不能小于0!")
			return
		}
		if ((CurDepreTotalFee*1)>(CurFundsFee*1))	//DJ0135 end		//Modify DJ 2015-09-14 DJ0164
		{
			alertShow("变动后累计折旧不能大于变动后资金来源!")
			return
		}
	}	
	/// Modified by JDL 2012-2-27 JDL0117
	Amount=Amount.toFixed(2);
	if (Number(Amount)!=Number(GetElementValue("FundsAmount")))
	{
		alertShow("各项资金来源合计不等于总金额!")
		return
	}
	if (RowCount<=0)
	{
		alertShow("无明细记录保存!")
		return
	}
	//保存
	var encmeth=GetElementValue("GetSave");
	if (encmeth=="") return;
	var GetIssueOperMethod=GetElementValue("GetIssueOperMethod");
	var val=""
	for (var i=1;i<=RowCount;i++)
	{
		var val=val+GetElementValue("TRowIDz"+i);
		val=val+"^"+GetElementValue("TFundsTypeDRz"+i);
		val=val+"^"+GetElementValue("TFeez"+i);
		val=val+"^"+GetElementValue("TOldRowDRz"+i);
		val=val+"^"+GetElementValue("THold1z"+i);
		val=val+"^"+GetElementValue("TPreDepreTotalFeez"+i);	//DJ0135
		val=val+"^"+GetElementValue("THold4z"+i);
		val=val+"^"+GetElementValue("THold5z"+i);
		val=val+"^"+GetElementValue("TNoz"+i);
		val=val+"^"+GetIssueRowID(GetIssueOperMethod,i);	//TIssueDR. Add By HZY 2012-02-24 HZY0023
		val=val+"^"+GetElementValue("TDepreTotalz"+i);		///Mozy0148
		val=val+"^"+GetElementValue("TPreFundsFeez"+i);		//DJ0135
		val=val+"||"
	}
	var result=cspRunServerMethod(encmeth,GetElementValue("FromType"),GetElementValue("FromID"),val);
	result=result.replace(/\\n/g,"\n")
	if (result<0)
	{
		if (result==-3001)
		{
			alertShow(t['-3001'])
			return;
		}
		else
		{
			alertShow("保存失败!")
			return
		}
	}
	else
	{
		alertShow("保存成功!")
		location.reload();
		//刷新父界面
		parent.opener.SelfFunds_Change()
	}
}

/// Modified By HZY 2012-02-24 HZY0023
function SetTableEvent()
{
	var GetIssueOperMethod=GetElementValue("GetIssueOperMethod");	//Add BY HZY 2012-02-24 HZY0023
	var eSrc=window.event.srcElement;
	var objtbl=document.getElementById(Component);
	var rows=objtbl.rows.length;
	
	var lastrowindex=rows - 1;
	RowCount=lastrowindex;
	for (var i=1;i<=RowCount;i++)
	{
		var obj=document.getElementById("TFeez"+i);
		if (obj) obj.onkeyup=TFee_KeyUp;
		var obj=document.getElementById("TDepreTotalz"+i);	///Mozy0148
		if (obj) obj.onkeyup=TDepreTotal_KeyUp;
		//自有资金不可编辑
		if (GetElementValue("TFundsTypeDRz"+i)==GetElementValue("GetSelfFundsID"))
		{
			DisableElement("TFeez"+i,true)
			DisableElement("TNoz"+i,true)
			DisableElement("THold1z"+i,true)			//备注.Add By HZY 2012-02-08 HZY0021
			DisableLookup("TIssuez"+i,true)			//课题名称.Add By HZY 2012-02-08 HZY0021
			DisableElement("TDepreTotalz"+i,true);		///Mozy0148
		}
		//课题名称.Start Add By HZY 2012-02-24 HZY0023
		var objIssue=document.getElementById("TIssuez"+i);
		if (objIssue)
		{
			if (GetIssueOperMethod==1) 
			{
				objIssue.removeNode(true);
			}
			else
			{
				objIssue.onkeydown=Issue_KeyDown;
				objIssue.onchange=Standard_TableKeyUp;
				var IMGID=GetLookupNameT("TIssuez"+i);
				var objIssueIMG=document.getElementById(IMGID);	//放大镜图片.
				if (objIssueIMG) objIssueIMG.onclick=Issue_Click;
				//document.getElementsByTagName('IMG');
				//objtbl.rows[i].cells[9].firstChild.onclick=Issue_Click;
			}	
		}	
		// 非调账的资金来源不允许进行累计折旧调整
		if (GetElementValue("FromType")!=7) DisableLookup("TDepreTotalz"+i,true);	///Mozy0148
	}
}

function TFee_KeyUp()
{
	var OtherFunds=0
	var CurRow=0
	for (var i=1; i<=RowCount;i++)
	{
		var CurFee=GetElementValue("TFeez"+i)	//Add By DJ 2015-01-20 DJ0135
		var PreFundsFee=GetElementValue("TPreFundsFeez"+i)
		var CurFundsFee=(CurFee*1)+(PreFundsFee*1)
		//SetElement("TCurFundsFeez"+i,CurFundsFee.toFixed(2))
		if (GetElementValue("TFundsTypeDRz"+i)!=GetElementValue("GetSelfFundsID"))
		{
			OtherFunds=OtherFunds+GetElementValue("TFeez"+i)*1;
		}
		else
		{
			CurRow=i
		}
	}
	var Fee=GetElementValue("FundsAmount")-OtherFunds
	SetElement("TFeez"+CurRow,Fee.toFixed(2))
	RefreshTable()	//DJ0135
}

///Add By HZY 2012-02-27 HZY0023
function GetIssue(value)
{
	var val=value.split("^");
	SetElement("TIssuez"+TableCurRow,val[0]);
	SetElement("TIssueDRz"+TableCurRow,val[1]);
	//GetLookUpID("TIssueDRz"+TableCurRow,value);
}

///Add By HZY 2012-02-27 HZY0023
function LookUpIssue(jsfunction,paras)
{
	LookUp("","web.DHCEQIssue:GetIssue",jsfunction,paras);
}

///Add By HZY 2012-02-27 HZY0023
function Issue_KeyDown()
{
	TableCurRow=GetTableCurRow();
	if (event.keyCode==13)
	{
		LookUpIssue("GetIssue","TIssuez"+TableCurRow);
	}
}

///Add By HZY 2012-02-27 HZY0023
function Issue_Click()
{
	TableCurRow=GetTableCurRow();
	LookUpIssue("GetIssue","TIssuez"+TableCurRow);
}
///Mozy0148
function TDepreTotal_KeyUp()
{
	var OtherDepreTotal=0
	var CurRow=0
	for (var i=1; i<=RowCount;i++)
	{
		if (GetElementValue("TFundsTypeDRz"+i)!=GetElementValue("GetSelfFundsID"))
		{
			OtherDepreTotal=OtherDepreTotal+GetElementValue("TDepreTotalz"+i)*1;
		}
		else
		{
			CurRow=i
		}
	}
	var TDepreTotal=GetElementValue("DepreTotal")-OtherDepreTotal;
	SetElement("TDepreTotalz"+CurRow,TDepreTotal.toFixed(2));
	RefreshTable()	//DJ0135
}
///Add By DJ 2015-01-20 DJ0135
function RefreshTable()
{
	for (var i=1; i<=RowCount;i++)
	{
		var CurFee=GetElementValue("TFeez"+i)
		var PreFundsFee=GetElementValue("TPreFundsFeez"+i)
		var DepreTotal=GetElementValue("TDepreTotalz"+i)
		var PreDepreTotalFee=GetElementValue("TPreDepreTotalFeez"+i)
		var CurFundsFee=(CurFee*1)+(PreFundsFee*1)
		var CurDepreTotalFee=(DepreTotal*1)+(PreDepreTotalFee*1)
		SetElement("TCurFundsFeez"+i,CurFundsFee.toFixed(2))
		SetElement("TCurDepreTotalFeez"+i,CurDepreTotalFee.toFixed(2))
	}
}
document.body.onload = BodyLoadHandler;
