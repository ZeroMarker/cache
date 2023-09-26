/// Modified By HZY 2012-02-24 HZY0023
/// 修改函数:BodyLoadHandler , SetTableEvent 
/// 新增函数:GetIssue , 
/// ---------------------------------------------------------
/// Modified By HZY 2012-02-10 HZY0022
/// 修改函数:BOK_Click
///HISUI改造 modified by czf 20181019
var SelectedRow = -1;
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
		var Fee=$("#"+Component).datagrid('getColumnOption','TFee');	//modified by czf 20181106
		Fee.editor={};
		var Remark=$("#"+Component).datagrid('getColumnOption','THold1');
		Remark.editor={};
		var DepreTotal=$("#"+Component).datagrid('getColumnOption','TDepreTotal');
		if(DepreTotal) DepreTotal.editor={};
		var CurFee=$("#"+Component).datagrid('getColumnOption','TCurFundsFee');
		if(CurFee) CurFee.editor={};
		var CurDepreTotal=$("#"+Component).datagrid('getColumnOption','TCurDepreTotalFee');
		if(CurFee) CurDepreTotal.editor={};
	}	
	InitButton(false);
	if (GetElementValue("GetSelfFundsID")=="")
	{
		alertShow("自有资金参数未设置!")
		return
	}
	
	initButtonWidth()	//hisui改造：修改界面按钮长度不一致 add by czf2018-08-31
}
///add by czf 20190212
var onAfterRender = $.fn.datagrid.defaults.view.onAfterRender;
$.extend($.fn.datagrid.defaults.view, {
            onAfterRender: function(target){
                onAfterRender.call(this, target);
				RefreshTable();
                SetTableEvent();
            }
});
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
		messageShow("","","",t['04']);
		return;
	}
	var truthBeTold = window.confirm(t['03']);
    if (!truthBeTold) return;
	var encmeth=GetElementValue("GetDel");
	if (encmeth=="")
	{
		messageShow("","","",t[-4001]);
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
		messageShow("","","",t[-4001]);
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
		messageShow("","","",t[-4001]);
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
		messageShow("","","",t['02']);
		return false;
	}
	var encmeth=GetElementValue("CheckAmount");	
	//messageShow("","","",FromType+"&"+FromID+"&"+RowID+"&"+Fee)
	var result=cspRunServerMethod(encmeth,FromType,FromID,RowID,Fee);
	if (result=="2")
	{
		messageShow("","","",t['01']);
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

///HISUI改造 modified by czf 20180904
function InitEditTable()
{
	var rows = $('#'+Component).datagrid('getRows');
	var RowCount=rows.length;
	for (var i=0;i<RowCount;i++)
	{
		jQuery('#'+Component).datagrid('beginEdit',i);
		//add by czf 20190305
		var TFeeobj=$('#'+Component).datagrid('getEditor',{index:i,field:'TFee'});
		if (TFeeobj)
		{
			$(TFeeobj.target).bind("keyup",function(){		//text输入框绑定keyup事件 czf
				TFee_KeyUp();
			});
		}
		var TDepreTotalobj=$('#'+Component).datagrid('getEditor',{index:i,field:'TDepreTotal'})
		if (TDepreTotalobj)
		{
			$(TDepreTotalobj.target).bind("keyup",function(){
				TDepreTotal_KeyUp();
			});
		}
		var CurFee=$('#'+Component).datagrid('getEditor',{index:i,field:'TCurFundsFee'});
		if(CurFee) $(CurFee.target).attr('disabled','disabled');
		var CurDepreTotal=$('#'+Component).datagrid('getEditor',{index:i,field:'TCurDepreTotalFee'});
		if(CurDepreTotal) $(CurDepreTotal.target).attr('disabled','disabled');
		var THold1obj=$('#'+Component).datagrid('getEditor',{index:i,field:'THold1'});
		//自有资金不可编辑 add by czf 20190305
		if (rows[i].TFundsTypeDR==GetElementValue("GetSelfFundsID"))
		{
			if(TFeeobj) $(TFeeobj.target).attr('disabled','disabled');
			if(TDepreTotalobj) $(TDepreTotalobj.target).attr('disabled','disabled');
			if(THold1obj) $(THold1obj.target).attr('disabled','disabled')
		}
	}
}
///Modified By HZY 2012-02-10 HZY0022
///HISUI改造 modified by czf 20180904
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
	var rows = $('#'+Component).datagrid('getRows');
	if (rows=="") return;		//Mozy	951371	2019-7-22
	var RowCount=rows.length;
	if(RowCount<=0){
		jQuery.messager.alert("没有待保存数据");
		return;
	}
	for (var i=0;i<RowCount;i++)
	{
		jQuery('#'+Component).datagrid('endEdit',i);
		var CurFee=rows[i].TFee;
		var Desc=rows[i].TFundsType;
		if (isNaN(CurFee)||((CurFee<0)&&(fundsAmount>0))||((CurFee>0)&&(fundsAmount<0)))
		{	//当'总金额'大于0时,每项资金来源的值应该大于或等于0;
			//当'总金额'小于0时,每项资金来源的值应该小于或等于0;
			//当'总金额'等于0时,每项资金来源可为正负数或0..Modified By HZY 2012-02-10 HZY0022
			alertShow("["+Desc+"]金额设置有误!请正确输入!")
			InitEditTable()
			return
		}
		Amount=Amount+CurFee*1
		if(Component=="DHCEQCAFunds")
		{
			var CurFundsFee=rows[i].TCurFundsFee		//DJ0135 begin
			var CurDepreTotalFee=rows[i].TCurDepreTotalFee
			if ((isNaN(CurFundsFee))||(CurFundsFee<0))
			{
				alertShow("变动后资金来源金额不能小于0!")
				InitEditTable()
				return
			}
			if ((isNaN(CurDepreTotalFee))||(CurDepreTotalFee<0))
			{
				alertShow("变动后累计折旧不能小于0!")
				InitEditTable()
				return
			}
			if ((CurDepreTotalFee*1)>(CurFundsFee*1))	//DJ0135 end		//Modify DJ 2015-09-14 DJ0164
			{
				alertShow("变动后累计折旧不能大于变动后资金来源!")
				InitEditTable()
				return
			}
		}
	}	
	/// Modified by JDL 2012-2-27 JDL0117
	Amount=Amount.toFixed(2);
	if (Number(Amount)!=Number(GetElementValue("FundsAmount")))
	{
		alertShow("各项资金来源合计不等于总金额!")
		InitEditTable()
		return
	}
	//保存
	var encmeth=GetElementValue("GetSave");
	if (encmeth=="") return;
	var GetIssueOperMethod=GetElementValue("GetIssueOperMethod");
	var val=""
	for (var i=0;i<RowCount;i++)
	{
		var val=val+rows[i].TRowID;
		val=val+"^"+rows[i].TFundsTypeDR;
		val=val+"^"+rows[i].TFee;
		val=val+"^"+rows[i].TOldRowDR;
		val=val+"^"+rows[i].THold1;
		if(Component=="DHCEQCAFunds")
		{
			val=val+"^"+rows[i].TPreDepreTotalFee;	//DJ0135
		}
		else
		{
			val=val+"^";
		}
		val=val+"^"+rows[i].THold4;
		val=val+"^"+rows[i].THold5;
		val=val+"^"+rows[i].TNo;
		val=val+"^"+GetIssueRowID(GetIssueOperMethod,i);	//TIssueDR. Add By HZY 2012-02-24 HZY0023
		val=val+"^"+rows[i].TDepreTotal;	///Mozy0148
		val=val+"^"+rows[i].TPreFundsFee;		//DJ0135
		val=val+"||";
		
		// Mozy0231	访问资金来源类型
		var ret=tkMakeServerCall("web.DHCEQFunds","CheckFundsType",rows[i].TFundsTypeDR,rows[i].TFee);
		if (ret!=0)
		{
			messageShow('alert','error','错误提示',"设置金额的资金来源只能是:   "+ret);
			return;
		}
	}
	
	var result=cspRunServerMethod(encmeth,GetElementValue("FromType"),GetElementValue("FromID"),val);
	result=result.replace(/\\n/g,"\n")
	if (result<0)
	{
		if (result==-3001)
		{
			messageShow("","","",t['-3001'])
			InitEditTable()
			return;
		}
		else
		{
			alertShow("保存失败!")
			InitEditTable()
			return
		}
	}
	else
	{
		alertShow("保存成功!")
		location.reload();
		//刷新父界面
		websys_showModal("options").mth();  //modify by lmm 2019-02-19
	}
}

/// Modified By HZY 2012-02-24 HZY0023
function SetTableEvent()
{
	var GetIssueOperMethod=GetElementValue("GetIssueOperMethod");	//Add BY HZY 2012-02-24 HZY0023
	//var eSrc=window.event.srcElement;
	//var objtbl=document.getElementById(Component);		
	//var rows=objtbl.rows.length;
	//var lastrowindex=rows - 1;
	//RowCount=lastrowindex;
	var rows = $('#'+Component).datagrid('getRows');	/// add by czf 20190212 begin
	var RowCount=rows.length;
	InitEditTable();	//首先开启列编辑状态,否则TFeeobj为null
	for (var i=0;i<RowCount;i++)
	{
		//var obj=document.getElementById("TFeez"+i);
		//if (obj) obj.onkeyup=TFee_KeyUp;
		//var obj=document.getElementById("TDepreTotalz"+i);	///Mozy0148
		//if (obj) obj.onkeyup=TDepreTotal_KeyUp;
		var TFeeobj=$('#'+Component).datagrid('getEditor',{index:i,field:'TFee'});
		if (TFeeobj)
		{
			$(TFeeobj.target).bind("keyup",function(){		//text输入框绑定keyup事件 czf
				TFee_KeyUp();
			});
		}
		var TDepreTotalobj=$('#'+Component).datagrid('getEditor',{index:i,field:'TDepreTotal'})
		if (TDepreTotalobj)
		{
			$(TDepreTotalobj.target).bind("keyup",function(){
				TDepreTotal_KeyUp();
			});
		}
		var CurFee=$('#'+Component).datagrid('getEditor',{index:i,field:'TCurFundsFee'});
		if(CurFee) $(CurFee.target).attr('disabled','disabled');
		var CurDepreTotal=$('#'+Component).datagrid('getEditor',{index:i,field:'TCurDepreTotalFee'});
		if(CurDepreTotal) $(CurDepreTotal.target).attr('disabled','disabled');
		var THold1obj=$('#'+Component).datagrid('getEditor',{index:i,field:'THold1'});
		//自有资金不可编辑
		if (rows[i].TFundsTypeDR==GetElementValue("GetSelfFundsID"))
		{
			if(TFeeobj) $(TFeeobj.target).attr('disabled','disabled');
			if(TDepreTotalobj) $(TDepreTotalobj.target).attr('disabled','disabled');
			if(THold1obj) $(THold1obj.target).attr('disabled','disabled')
			//DisableElement("TFeez"+i,true)
			//DisableElement("TNoz"+i,true)
			//DisableElement("THold1z"+i,true)			//备注.Add By HZY 2012-02-08 HZY0021
			//DisableLookup("TIssuez"+i,true)			//课题名称.Add By HZY 2012-02-08 HZY0021
			//DisableElement("TDepreTotalz"+i,true);		///Mozy0148
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
		if (GetElementValue("FromType")!=7) 
		{
			if(TDepreTotalobj) $(TDepreTotalobj.target).attr('disabled','disabled');
		}
		//DisableLookup("TDepreTotalz"+i,true);	///Mozy0148		/// Modified by czf 20190212 end
	}
}

//modified by czf 20190212
function TFee_KeyUp()
{
	var OtherFunds=0
	var CurRow=0
	//InitEditTable();	//首先开启列编辑状态,否则TFeeobj为null // Modified by wy 2019-4-8 856188
	var rows = $('#'+Component).datagrid('getRows');
	var RowCount=rows.length;
	for (var i=0; i<RowCount;i++)
	{
		var TFeeobj=$('#'+Component).datagrid('getEditor',{index:i,field:'TFee'});
		var CurFee=$(TFeeobj.target).val()
		//var CurFee=GetElementValue("TFeez"+i)	//Add By DJ 2015-01-20 DJ0135
		var PreFundsFee=rows[i].TPreFundsFee
		//var PreFundsFee=GetElementValue("TPreFundsFeez"+i)
		var CurFundsFee=(CurFee*1)+(PreFundsFee*1)
		//SetElement("TCurFundsFeez"+i,CurFundsFee.toFixed(2))
		if (rows[i].TFundsTypeDR!=GetElementValue("GetSelfFundsID"))
		{
			OtherFunds=OtherFunds+CurFee*1;
		}
		else
		{
			CurRow=i
		}
	}
	var Fee=GetElementValue("FundsAmount")-OtherFunds
	var obj=$('#'+Component).datagrid('getEditor',{index:CurRow,field:'TFee'});
	if(obj) $(obj.target).val(Fee.toFixed(2))
	//SetElement("TFeez"+CurRow,Fee.toFixed(2))
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
///modified by czf 20190212
function TDepreTotal_KeyUp()
{
	var OtherDepreTotal=0
	var CurRow=0
	//InitEditTable();	//首先开启列编辑状态,否则TFeeobj为null // Modified by wy 2019-4-8 856188
	var rows = $('#'+Component).datagrid('getRows');
	var RowCount=rows.length;
	for (var i=0; i<RowCount;i++)
	{
		var TDepreTotalobj=$('#'+Component).datagrid('getEditor',{index:i,field:'TDepreTotal'});
		if(TDepreTotalobj) var TDepreTotal=$(TDepreTotalobj.target).val()
		else var TDepreTotal=rows[i].TDepreTotal
		if (rows[i].TFundsTypeDR!=GetElementValue("GetSelfFundsID"))
		{
			OtherDepreTotal=OtherDepreTotal+TDepreTotal*1;
		}
		else
		{
			CurRow=i
		}
	}
	var TDepreTotal=GetElementValue("DepreTotal")-OtherDepreTotal;
	var obj=$('#'+Component).datagrid('getEditor',{index:CurRow,field:'TDepreTotal'})
	if(obj) $(obj.target).val(TDepreTotal.toFixed(2))
	//SetElement("TDepreTotalz"+CurRow,TDepreTotal.toFixed(2));
	RefreshTable()	//DJ0135
}
///Add By DJ 2015-01-20 DJ0135
///modfied by czf 20190212
function RefreshTable()
{
	var rows = $('#'+Component).datagrid('getRows');
	var RowCount=rows.length;
	for (var i=0; i<RowCount;i++)
	{
		var TFeeobj=$('#'+Component).datagrid('getEditor',{index:i,field:'TFee'});
		var TDepreTotalobj=$('#'+Component).datagrid('getEditor',{index:i,field:'TDepreTotal'})
		var CurFeeobj=$('#'+Component).datagrid('getEditor',{index:i,field:'TCurFundsFee'})
		var CurDepreTotalobj=$('#'+Component).datagrid('getEditor',{index:i,field:'TCurDepreTotalFee'})
		if(TFeeobj) var CurFee=$(TFeeobj.target).val();
		else var CurFee=rows[i].TFee
		if(TDepreTotalobj) var DepreTotal=$(TDepreTotalobj.target).val();
		else var DepreTotal=rows[i].TDepreTotal;
		var PreFundsFee=rows[i].TPreFundsFee;
		var PreDepreTotalFee=rows[i].TPreDepreTotalFee;
		var CurFundsFee=(CurFee*1)+(PreFundsFee*1)
		var CurDepreTotalFee=(DepreTotal*1)+(PreDepreTotalFee*1)
		if(CurFeeobj) $(CurFeeobj.target).val(CurFundsFee.toFixed(2));
		if(CurDepreTotalobj) $(CurDepreTotalobj.target).val(CurDepreTotalFee.toFixed(2));
		//SetElement("TCurFundsFeez"+i,CurFundsFee.toFixed(2))
		//SetElement("TCurDepreTotalFeez"+i,CurDepreTotalFee.toFixed(2))
	}
}

document.body.onload = BodyLoadHandler;
