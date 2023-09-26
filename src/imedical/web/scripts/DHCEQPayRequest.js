var SelectedRow = 0;
var rowid=0;

function BodyLoadHandler() 
{	
	InitUserInfo();
	InitPage();
	KeyUp("Provider","N");
	Muilt_LookUp("Provider");
	SetElement("SourceType",GetElementValue("SourceTypeDR"));
	SetElement("Status",GetElementValue("StatusDR"));
	SetEnabled();
	SetTableEvent();
	EditFieldsInit();
}

function EditFieldsInit()
{
	var QXType=GetElementValue("QXType")
	if (QXType=="1")
	{
		var CurRole=GetElementValue("ApproveRole");
	  	if (CurRole=="") return;
		var eSrc=window.event.srcElement;
		var Objtbl=document.getElementById('tDHCEQPayRequest');
		var Rows=Objtbl.rows.length;
		var Count=0
		for (var i=1;i<Rows;i++)
		{	
			InitEditFields(GetElementValue("TApproveSetz"+i),CurRole)
		}
		SetTableItem()
	}
}

function SetEnabled()
{
	var QXType=GetElementValue("QXType")
	var OperatorFlag=GetChkElementValue("OperatorFlag")
	var Status=GetElementValue("Status")
	if (QXType!="0")
	{
		HiddenObj("OperatorFlag",1)
		HiddenObj("cOperatorFlag",1)
	}
	if (OperatorFlag=="0") //付款申请
	{
		DisableBElement("BSubmit",true);
		DisableBElement("BAudit",true);
		DisableBElement("BDelete",true);
		DisableBElement("BCancelSubmit",true);
		HiddenObj("Status",1)
		HiddenObj("cStatus",1)
	}
	else //付款记录
	{
		if (QXType=="0")
		{
			DisableBElement("BAudit",true);
			DisableBElement("BCancelSubmit",true);
			HiddenObj("BPayRequest",1);  //modify BY GBX  GBX0033
			if (Status!="0")
			{
				DisableBElement("BUpdate",true);
				DisableBElement("BDelete",true);
				DisableBElement("BSubmit",true);
			}
		}
		else
		{
			DisableBElement("BUpdate",true);
			DisableBElement("BDelete",true);
			DisableBElement("BSubmit",true);
			HiddenObj("BPayRequest",1);  //modify BY GBX	 GBX0033	
			if (Status!="1")
			{
				DisableBElement("BCancelSubmit",true);
				DisableBElement("BAudit",true);
			}
		}
	}
}
function InitPage()
{
	var obj=document.getElementById("BFind"); //查找
	if (obj) obj.onclick=BFind_Click;
	var obj=document.getElementById("BSelectAll"); //全选
	if (obj) obj.onclick=BSelectAll_Click;
	var obj=document.getElementById("BUpdate"); //更新
	if (obj) obj.onclick=BUpdate_Click;
	var obj=document.getElementById("SourceType"); //SourceType
	if (obj) obj.onchange=SourceType_Change;	
	var obj=document.getElementById("BSubmit"); //提交
	if (obj) obj.onclick=BSubmit_Click;
	var obj=document.getElementById("BAudit"); //审核
	if (obj) obj.onclick=BSubmit_Click;
	var obj=document.getElementById("BDelete"); //删除
	if (obj) obj.onclick=BDelete_Click;
	var obj=document.getElementById("BCancelSubmit"); //取消提交
	if (obj) obj.onclick=BCancelSubmit_Click;
	var obj=document.getElementById("OperatorFlag");
	if (obj) obj.onclick=OperatorFlag_Click;
	
	var obj=document.getElementById("BPayRequest"); //按供应商汇总
	if (obj) obj.onclick=BPayRequest_Click;
}

function OperatorFlag_Click()
{
	var OperatorFlag=GetChkElementValue("OperatorFlag")
	var QXType=GetElementValue("QXType")
	if (OperatorFlag==true)
	{
		HiddenObj("Status",0)
		HiddenObj("cStatus",0)
		if (QXType==0)
		{
			SetElement("Status",0)
			SetElement("StatusDR",0)
		}
	}
	else
	{
		HiddenObj("Status",1)
		HiddenObj("cStatus",1)
	}
}

function SourceType_Change()
{
	SetElement("SourceTypeDR",GetElementValue("SourceType"))
}

function BFind_Click()
{
	var Flag=GetChkElementValue("OperatorFlag")
	if (Flag==false)
	{
		Flag=0
	}
	else
	{
		Flag=1
	}
	var val="&ProviderDR="+GetElementValue("ProviderDR");
	val=val+"&Provider="+GetElementValue("Provider");
	val=val+"&No="+GetElementValue("No");
	val=val+"&PStartDate="+GetElementValue("PStartDate");
	val=val+"&PEndDate="+GetElementValue("PEndDate");
	val=val+"&PayStartDate="+GetElementValue("PayStartDate");
	val=val+"&PayEndDate="+GetElementValue("PayEndDate");
	val=val+"&SourceTypeDR="+GetElementValue("SourceTypeDR");
	val=val+"&Status="+GetElementValue("Status");
	val=val+"&OperatorFlag="+Flag;
	val=val+"&PayRecordNo="+GetElementValue("PayRecordNo");
	val=val+"&QXType="+GetElementValue("QXType");
	val=val+"&ApproveRole="+GetElementValue("ApproveRole");
	window.location.href="websys.default.csp?WEBSYS.TCOMPONENT=DHCEQPayRequest"+val;
}
function getcombindata(row)
{
	var combindata=GetElementValue("TRowIDz"+row);
	combindata=combindata+"^"+GetElementValue("TSourceTypeDRz"+row);
	combindata=combindata+"^"+GetElementValue("TSourceIDz"+row);
	combindata=combindata+"^"+GetElementValue("TPayPlanDRz"+row);
	combindata=combindata+"^"+GetElementValue("TCurAmountz"+row);
	combindata=combindata+"^"+GetElementValue("TInvoicez"+row);
	combindata=combindata+"^"+GetElementValue("TPayModeDRz"+row);
	combindata=combindata+"^"+GetElementValue("TRemarkz"+row);
	combindata=combindata+"^"+GetElementValue("TPayTypeDRz"+row);
	combindata=combindata+"^"+GetElementValue("TPlanDatez"+row);
	//详细信息
	combindata=combindata+"^"+GetElementValue("TAllAmountz"+row);
	combindata=combindata+"^"+GetElementValue("TProviderDRz"+row);
	combindata=combindata+"^"+GetElementValue("TNoz"+row);
	combindata=combindata+"^"+GetElementValue("TItemz"+row);
	combindata=combindata+"^"+GetElementValue("TEquipTypeDRz"+row);
	combindata=combindata+"^"+GetElementValue("TPricez"+row);
	combindata=combindata+"^"+GetElementValue("TQuantityz"+row);
	combindata=combindata+"^"+GetElementValue("TCheckNoz"+row);  //Modefied by zc 2014-9-15 ZC0006
	return combindata
}

function BUpdate_Click()
{
	var eSrc=window.event.srcElement;
	var Objtbl=document.getElementById('tDHCEQPayRequest');
	var Rows=Objtbl.rows.length;
	var Count=0
	for (var i=1;i<Rows;i++)
	{
		var selobj=document.getElementById('TOperatorz'+i);
		if (selobj.checked)
		{
			Count=1
			var CurAmount=GetElementValue("TCurAmountz"+i)
			var RemainFee=GetElementValue("TRemainFeez"+i)
			var Item=GetElementValue("TItemz"+i)
			if (CurAmount<=0)
			{
				alertShow("请正确输入付款金额!["+Item+"]")
				SetFocus("TCurAmountz"+i)
				return
			}
			var RowID=GetElementValue("TRowIDz"+i)
			if ((RowID=="")&&(parseFloat(RemainFee)<parseFloat(CurAmount)))
			{
				alertShow("["+Item+"]最大付款金额为:"+RemainFee)
				SetFocus("TCurAmountz"+i)
				return
			}
		}
	}
	if (Count==0)
	{
		alertShow("请选择需要付款的记录!")
		return
	}
	//保存
	var encmeth=GetElementValue("SaveData")
  	if (encmeth=="") return;
  	var ErrorStr=""
	for (var i=1;i<Rows;i++)
	{
		var selobj=document.getElementById('TOperatorz'+i);
		if (selobj.checked)
		{
			var combindata=getcombindata(i)
			var Rtn=cspRunServerMethod(encmeth,combindata);
			var list=Rtn.split("^");
			if (list[0]=="-1")
			{
				if (ErrorStr=="")
				{
					ErrorStr=GetElementValue("TItemz"+i)+"="+list[1]
				}
				else
				{
					ErrorStr=ErrorStr+" , "+GetElementValue("TItemz"+i)+"="+list[1]
				}
			}
		}
	}
	if (ErrorStr!="")
	{
		alertShow(ErrorStr)
	}
	BFind_Click();
}

//modify BY GBX  GBX0033
function BPayRequest_Click()
{	
	var eSrc=window.event.srcElement;
	var Objtbl=document.getElementById('tDHCEQPayRequest');
	var Rows=Objtbl.rows.length;
	var Count=0
	for (var i=1;i<Rows;i++)
	{
		var selobj=document.getElementById('TOperatorz'+i);
		if (selobj.checked)
		{
			Count=1
			var CurAmount=GetElementValue("TCurAmountz"+i)
			var RemainFee=GetElementValue("TRemainFeez"+i)
			var Item=GetElementValue("TItemz"+i)
			if (CurAmount<=0)
			{
				alertShow("请正确输入付款金额!["+Item+"]")
				SetFocus("TCurAmountz"+i)
				return
			}
			var RowID=GetElementValue("TRowIDz"+i)
			if ((RowID=="")&&(parseFloat(RemainFee)<parseFloat(CurAmount)))
			{
				alertShow("["+Item+"]最大付款金额为:"+RemainFee)
				SetFocus("TCurAmountz"+i)
				return
			}
		}
	}
	if (Count==0)
	{
		alertShow("请选择需要付款的记录!")
		return
	}

	var Num=1
	var Job=GetElementValue("TJobz1")
	var encmeth=GetElementValue("KillTempGloble")
	if (encmeth=="") 
	{
		return;
	}
	var KillTempGlb=cspRunServerMethod(encmeth,Job)
	var encmeth=""
	for (var i=1;i<Rows;i++)
	{
		var selobj=document.getElementById('TOperatorz'+i);
		if (selobj.checked)
		{
			var combindata=getcombindata(i)
			var encmeth=GetElementValue("GetPayRequestInfo")
				var Rtn=cspRunServerMethod(encmeth,combindata,Job,Num)
			Num=Num+1
		}
	}
	var encmeth=GetElementValue("SavePayRequestInfo")
	var result=cspRunServerMethod(encmeth,Job)
	if (result<0)
	{
		alertShow("汇总失败")
		//return;
	}
	else if (result==0)
	{
		alertShow("汇总失败")
		//return;
	}
	else
	{
		alertShow("汇总成功!");
		//return;
	}
	BFind_Click();
}
function BSubmit_Click()
{
	var QXType=GetElementValue("QXType")
	var eSrc=window.event.srcElement;
	var Objtbl=document.getElementById('tDHCEQPayRequest');
	var Rows=Objtbl.rows.length;
	var Count=0
	var isAudit=0
	var CurRole=""
	for (var i=1;i<Rows;i++)
	{
		var selobj=document.getElementById('TOperatorz'+i);
		if (selobj.checked) { Count=1 }
	}
	if (Count==0)
	{
		alertShow("请选择需要提交的记录!")
		return
	}
	//提交
	if (QXType=="1")
	{
		isAudit=1
		CurRole=GetElementValue("ApproveRole");
	  	if (CurRole=="") return;
	}
	var encmeth=GetElementValue("SubmitData")
  	if (encmeth=="") return;
  	var ErrorStr=""
	for (var i=1;i<Rows;i++)
	{
		var selobj=document.getElementById('TOperatorz'+i);
		if (selobj.checked)
		{
			var RowID=GetElementValue("TRowIDz"+i)
			var RoleStep=GetElementValue("TRoleStepz"+i);
			var EditFieldsInfo=""
			if (QXType=="1")
			{
				var objtbl=document.getElementById('tDHCEQPayRequest');
				EditFieldsInfo=ApproveEditFieldsInfo(objtbl,i);
				if (EditFieldsInfo=="-1") return;
			}
			var Rtn=cspRunServerMethod(encmeth,RowID,CurRole,RoleStep,EditFieldsInfo,isAudit);
			if (Rtn<0)
			{
				if (ErrorStr=="")
				{
					ErrorStr=GetElementValue("TItemz"+i)+"="+Rtn
				}
				else
				{
					ErrorStr=ErrorStr+" , "+GetElementValue("TItemz"+i)+"="+Rtn
				}
			}
		}
	}
	if (ErrorStr!="")
	{
		alertShow(ErrorStr)
	}
	BFind_Click();
}

function BDelete_Click()
{
	var eSrc=window.event.srcElement;
	var Objtbl=document.getElementById('tDHCEQPayRequest');
	var Rows=Objtbl.rows.length;
	var Count=0
	for (var i=1;i<Rows;i++)
	{
		var selobj=document.getElementById('TOperatorz'+i);
		if (selobj.checked) { Count=1 }
	}
	if (Count==0)
	{
		alertShow("请选择需要删除的记录!")
		return
	}
	//删除
	var encmeth=GetElementValue("DeleteData")
  	if (encmeth=="") return;
  	var ErrorStr=""
	for (var i=1;i<Rows;i++)
	{
		var selobj=document.getElementById('TOperatorz'+i);
		if (selobj.checked)
		{
			var RowID=GetElementValue("TRowIDz"+i)
			var Rtn=cspRunServerMethod(encmeth,RowID);
			if (Rtn<0)
			{
				if (ErrorStr=="")
				{
					ErrorStr=GetElementValue("TItemz"+i)+"="+Rtn
				}
				else
				{
					ErrorStr=ErrorStr+" , "+GetElementValue("TItemz"+i)+"="+Rtn
				}
			}
		}
	}
	if (ErrorStr!="")
	{
		alertShow(ErrorStr)
	}
	BFind_Click();
}

function BCancelSubmit_Click()
{
	var eSrc=window.event.srcElement;
	var Objtbl=document.getElementById('tDHCEQPayRequest');
	var Rows=Objtbl.rows.length;
	var Count=0
	for (var i=1;i<Rows;i++)
	{
		var selobj=document.getElementById('TOperatorz'+i);
		if (selobj.checked) { Count=1 }
	}
	if (Count==0)
	{
		alertShow("请选择需要取消提交的记录!")
		return
	}
	//删除
	var encmeth=GetElementValue("CancelData")
  	if (encmeth=="") return;
  	var ErrorStr=""
	for (var i=1;i<Rows;i++)
	{
		var selobj=document.getElementById('TOperatorz'+i);
		if (selobj.checked)
		{
			var RowID=GetElementValue("TRowIDz"+i)
			var Rtn=cspRunServerMethod(encmeth,RowID);
			if (Rtn<0)
			{
				if (ErrorStr=="")
				{
					ErrorStr=GetElementValue("TItemz"+i)+"="+Rtn
				}
				else
				{
					ErrorStr=ErrorStr+" , "+GetElementValue("TItemz"+i)+"="+Rtn
				}
			}
		}
	}
	if (ErrorStr!="")
	{
		alertShow(ErrorStr)
	}
	BFind_Click();
}

function BSelectAll_Click()
{
	var obj=document.getElementById("BSelectAll")
	if (obj.innerText=="全选(当前页)")
	{
		obj.innerText="反选(当前页)"
		var flag=1
	}
	else
	{
		obj.innerText="全选(当前页)"
		var flag=0
	}
	var eSrc=window.event.srcElement;
	var Objtbl=document.getElementById('tDHCEQPayRequest');
	var Rows=Objtbl.rows.length;
	for (var i=1;i<Rows;i++)
	{
		var selobj=document.getElementById('TOperatorz'+i);
		selobj.checked=flag;
	}
}

///选择表格行触发此方法
function SelectRowHandler()
{
	var eSrc=window.event.srcElement;
	var Objtbl=document.getElementById('tDHCEQPayRequest');
	var Rows=Objtbl.rows.length;
	var Count=0
	for (var i=1;i<Rows;i++)
	{
		var selobj=document.getElementById('TOperatorz'+i);
		if (selobj.checked)
		{
			Count=Count+1
		}
	}
	var obj=document.getElementById("BSelectAll")
	if (Count==(Rows-1))
	{
		obj.innerText="反选(当前页)"
	}
	else
	{
		obj.innerText="全选(当前页)"
	}
}

function SetTableEvent()
{
	var eSrc=window.event.srcElement;
	var Objtbl=document.getElementById('tDHCEQPayRequest');
	var Rows=Objtbl.rows.length;
	for (var i=1;i<Rows;i++)
	{
		var obj=document.getElementById("TPayModez"+i)
		if (obj) obj.onkeydown=PayMode_KeyDown
		var Desc="lt"+GetElementValue("GetComponentID")+"iTPayModez";
		var obj=document.getElementById(Desc+i);
		if (obj) obj.onclick=LookUpPayMode;
	}
}

function PayMode_KeyDown()
{
	if (event.keyCode==13)
	{
		LookUpPayMode();
	}
}

function LookUpPayMode()
{
	SelectedRow=GetTableCurRow();
	LookUp("","web.DHCEQFind:GetCodeTable","GetPayModeID","'DHCEQCPayMode'");
}

function GetPayModeID(value)
{
	var type=value.split("^");
	SetElement("TPayModeDRz"+SelectedRow,type[0]);
	SetElement("TPayModez"+SelectedRow,type[2]);
}

function SetTableItem()
{
	var objtbl=document.getElementById('tDHCEQPayRequest');
	var rows=objtbl.rows.length-1;
	for (var i=1;i<=rows;i++)
	{
		tableList[i]=0;
		var TRowID=document.getElementById("TRowIDz"+i).value;
		ChangeRowStyle(objtbl.rows[i],'');		///改变一行的内容显示
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
		if (colName=="TRemark")
		{
			if (CheckUnEditField(Status,colName)) continue;
			value=document.getElementById(Id).innerText;
			html=CreatElementHtml(1,Id,objwidth,objheight,"KeyDown_Tab","","","")
		}
		else if (colName=="TCheckNo")
		{
			if (CheckUnEditField(Status,colName)) continue;
			value=document.getElementById(Id).innerText;
			html=CreatElementHtml(1,Id,objwidth,objheight,"KeyDown_Tab","","","")
		}
		else if (colName=="TPayMode")
		{
			if (CheckUnEditField(Status,colName)) continue;
			value=document.getElementById(Id).innerText;
         	html=CreatElementHtml(2,Id,objwidth,objheight,"LookUpPayMode","","","Standard_TableKeyUp")		
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

document.body.onload = BodyLoadHandler;
