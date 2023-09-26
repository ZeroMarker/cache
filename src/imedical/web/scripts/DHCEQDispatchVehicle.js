/// DHCEQDispatchVehicle.js

var selectrow=0;
var ObjSources=new Array();
//最后一行数据元素的名字的后缀序号
var LastNameIndex;
//新增一行数据元素的名字的后缀序号
var NewNameIndex;
document.body.onload = BodyLoadHandler;

function BodyLoadHandler() 
{
	KeyUp("RequestUser","N");
	InitMessage();
	//InitUserInfo();
	InitPage();	
	FillData();
	
	SetEnabled();
	InitEditFields(GetElementValue("ApproveSetDR"),GetElementValue("CurRole"));
	InitApproveButton();
	SetTableItem("","","");
	
	SetFocus("RequestReason");
	Muilt_LookUp("RequestUser");
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
}

function BUpdate_Clicked()
{
	if (CheckMustItemNull()) return;
	if (CheckItemNull(0,"DispatchTime","出车时间")) return true;
	if (CheckItemNull(0,"PatchTime","归队时间")) return true;
	var combindata="";
  	combindata=GetElementValue("RowID");
  	combindata=combindata+"^"+GetElementValue("DispatchVehicleNo");
  	combindata=combindata+"^"+GetElementValue("RequestDate");
  	combindata=combindata+"^"+GetElementValue("RequestUserDR");
  	combindata=combindata+"^"+GetElementValue("UserName");
  	combindata=combindata+"^"+GetElementValue("RequestReason");
  	combindata=combindata+"^"+GetElementValue("Arrive");
  	combindata=combindata+"^"+GetElementValue("DispatchDate");
  	combindata=combindata+"^"+GetElementValue("DispatchTime");
  	combindata=combindata+"^"+GetElementValue("PatchDate");
  	combindata=combindata+"^"+GetElementValue("PatchTime");
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
	    window.location.href= 'websys.default.csp?WEBSYS.TCOMPONENT=DHCEQDispatchVehicle&RowID='+Rtn+"&WaitAD=off&QXType="+GetElementValue("QXType");
	}
    else
    {
	    alertShow(EQMsg(t["01"],Rtn));
    }
}
function BDelete_Clicked()
{
	var truthBeTold = window.confirm(t["-4003"]);
	if (!truthBeTold) return;
  	var encmeth=GetElementValue("Delete");
  	if (encmeth=="") return;
	var Rtn=cspRunServerMethod(encmeth,GetElementValue("RowID"));
	if (Rtn=="0")
    {
		var WaitAD=GetElementValue("WaitAD");
		var QXType=GetElementValue("QXType");
		window.location.href= 'websys.default.csp?WEBSYS.TCOMPONENT=DHCEQDispatchVehicle&WaitAD='+WaitAD+"&QXType="+QXType;
	}
    else
    {
	    alertShow(t[Rtn]+"   "+t["01"]);
    }
}
function BSubmit_Clicked()
{
	if (CheckMustItemNull()) return;
  	var encmeth=GetElementValue("SubmitData")
  	if (encmeth=="") return;
	var Rtn=cspRunServerMethod(encmeth,GetElementValue("RowID"));
	if (Rtn>0)
    {
		var WaitAD=GetElementValue("WaitAD");
		window.location.href= 'websys.default.csp?WEBSYS.TCOMPONENT=DHCEQDispatchVehicle&RowID='+Rtn+"&WaitAD="+WaitAD;
	}
    else
    {
	    alertShow(t[Rtn]+"   "+t["01"]);
    }
}
function BCancelSubmit_Clicked() // 取消提交
{
  	var encmeth=GetElementValue("CancelSubmitData")
  	if (encmeth=="") return;
  	var Rtn=cspRunServerMethod(encmeth,GetElementValue("RowID"),GetElementValue("CurRole"),GetElementValue("CancelToFlowDR"));
    if (Rtn>0)
    {
	    window.location.href= 'websys.default.csp?WEBSYS.TCOMPONENT=DHCEQDispatchVehicle&RowID='+Rtn+"&QXType="+GetElementValue("QXType");
	}
    else
    {
	    alertShow(Rtn+"   "+t["01"]);
    }
}
// 20140331  Mozy0124
/*
function BPrint_Clicked()
{
	var id=GetElementValue("RowID");
	//if (""!=id) PrintInStore(id);
}
function BClear_Clicked()
{
	var QXType=GetElementValue("QXType");
	window.location.href= 'websys.default.csp?WEBSYS.TCOMPONENT=DHCEQInStockNew&Type=0&QXType='+QXType+'&WaitAD=off';
}*/
function AddClickHandler()
{
	try
	{
		var objtbl=document.getElementById('tDHCEQDispatchVehicle');
		var ret=CanAddRow(objtbl);
		if (ret)
		{
			NewNameIndex=tableList.length;
	    	AddRowToList(objtbl,LastNameIndex,NewNameIndex);
	    }
        return false;
	} 
	catch(e){};
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
	//alertShow(ReturnList)
	ReturnList=ReturnList.replace(/\\n/g,"\n");
	list=ReturnList.split("^");
	var sort=30;
	SetElement("DispatchVehicleNo",list[0]);
	SetElement("RequestDate",list[1]);
	SetElement("Status",list[2]);
	SetElement("RequestUserDR",list[12]);
	SetElement("RequestUser",list[sort+0]);
	SetElement("UserName",list[13]);
	SetElement("RequestReason",list[14]);
	SetElement("Arrive",list[15]);
	SetElement("DispatchDate",list[16]);
	SetElement("DispatchTime",list[17]);
	SetElement("PatchDate",list[18]);
	SetElement("PatchTime",list[19]);
	SetElement("Remark",list[20]);
	SetElement("Hold1",list[25]);
	SetElement("Hold2",list[26]);
	SetElement("Hold3",list[27]);
	SetElement("Hold4",list[28]);
	SetElement("Hold5",list[29]);
	//alertShow(list[sort+2])
	SetElement("ApproveSetDR",list[sort+2]);
	SetElement("NextRoleDR",list[sort+3]);
	SetElement("NextFlowStep",list[sort+4]);
	SetElement("ApproveStatus",list[sort+5]);
	SetElement("ApproveRoleDR",list[sort+6]);
	SetElement("CancelFlag",list[sort+7]);
	SetElement("CancelToFlowDR",list[sort+8]);
}

function SetEnabled()
{
	SetElement("ReadOnly",0);
	var WaitAD=GetElementValue("WaitAD");
	var Status=GetElementValue("Status");
	//alertShow("Status="+Status+"WaitAD="+WaitAD)
	//状态为新增时,方可提交或删除
	//状态小于1时,方可增删改
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
		}
	}
	//审核后才可打印及生成转移单
	if (Status!="2")
	{
		DisableBElement("BPrint",true);
	}
	//非建单据菜单,不可更新等操作单据
	if (WaitAD!="off")
	{
		DisableBElement("BUpdate",true);
		DisableBElement("BDelete",true);
		DisableBElement("BSubmit",true);
		DisableBElement("BAdd",true);
		DisableBElement("BClear",true);
		SetElement("ReadOnly",1);	//非建单据菜单,设为只读
	}
}

function SetTableItem(RowNo,SourceType,selectrow)
{
	var objtbl=document.getElementById('tDHCEQDispatchVehicle');
	var rows=objtbl.rows.length-1;
	if (RowNo=="")
	{
		for (var i=1;i<=rows;i++)
		{
			tableList[i]=0;
			var TRowID=document.getElementById("TRowIDz"+i).value;
			var TotalFlag=GetElementValue("TotalFlag")
			if (TRowID==-1)
			{
				if ((TotalFlag==1)||(TotalFlag==2))
				{
					obj=document.getElementById("TRowz"+i);
					if (obj) obj.innerText="合计:"
					obj=document.getElementById("BDeleteListz"+i);
					if (obj) obj.innerText=""
					
					tableList[i]=-1;
					continue;
				}
			}
			ChangeRowStyle(objtbl.rows[i],SourceType);		///改变一行的内容显示
		}
	}
	else
	{
		if (selectrow=='') selectrow=RowNo
		tableList[RowNo]=0;
		ChangeRowStyle(objtbl.rows[selectrow],SourceType);		///改变一行的内容显示
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
		
		if (colName=="BDeleteList")
		{
			if (Status>0)
			{
				HiddenObj(colName+"z"+objindex,1)
				continue;
			}
			RowObj.cells[j].onclick=DeleteClickHandler;
		}
		else if (colName=="TEquip")
		{
			if (CheckUnEditField(Status,colName)) continue;
			value=document.getElementById(Id).innerText;
         	html=CreatElementHtml(2,Id,objwidth,objheight,"LookUpVehicle","","","VehicleKeyUp")
		}
		else if (colName=="TDriver")
		{
			if (CheckUnEditField(Status,colName)) continue;
			value=document.getElementById(Id).innerText;
         	html=CreatElementHtml(2,Id,objwidth,objheight,"LookUpDriver","","","DriverKeyUp")
		}
		else if (colName=="TCardNo")		//20140228  Mozy0120
		{
			// 20140331  Mozy0124
			if (CheckUnEditField(Status,colName)) continue;
			if (Status<1) continue;
			value=document.getElementById(Id).innerText;
			html=CreatElementHtml(1,Id,objwidth,objheight,"KeyDown_Tab","","","")
		}
		else if (colName=="TRunDate")
		{
			// 20140331  Mozy0124
			if (CheckUnEditField(Status,colName)) continue;
			if (Status<1) continue;
			value=document.getElementById(Id).innerText;
			html=CreatElementHtml(3,Id,objwidth,objheight,"LookUpTableDate","TDate_changehandler","","")
		}
		else if (colName=="TRunTime")
		{
			// 20140331  Mozy0124
			if (CheckUnEditField(Status,colName)) continue;
			if (Status<1) continue;
			value=document.getElementById(Id).innerText;
			html=CreatElementHtml(1,Id,objwidth,objheight,"KeyDown_Tab","","","")
		}
		else if (colName=="TEndDate")
		{
			// 20140331  Mozy0124
			if (CheckUnEditField(Status,colName)) continue;
			if (Status<1) continue;
			value=document.getElementById(Id).innerText;
			html=CreatElementHtml(3,Id,objwidth,objheight,"LookUpTableDate","TDate_changehandler","","")
		}
		else if (colName=="TEndTime")
		{
			// 20140331  Mozy0124
			if (CheckUnEditField(Status,colName)) continue;
			if (Status<1) continue;
			value=document.getElementById(Id).innerText;
			html=CreatElementHtml(1,Id,objwidth,objheight,"KeyDown_Tab","","","")
		}
		else if (colName=="TEndMileage")
		{
			// 20140331  Mozy0124
			if (CheckUnEditField(Status,colName)) continue;
			if (Status<1) continue;
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

function DeleteClickHandler()
{
	var truthBeTold = window.confirm(t["-4003"]);
	if (!truthBeTold) return;
	try
	{
		var objtbl=document.getElementById('tDHCEQDispatchVehicle');
		var rows=objtbl.rows.length;
		selectrow=GetTableCurRow();
		var TotalFlag=GetElementValue("TotalFlag");
		var TRowID=GetElementValue("TRowIDz"+selectrow);
		tableList[selectrow]=TRowID;
		var delNo=GetElementValue("TRowz"+selectrow);
		if (((TotalFlag==0)&&(rows<=2))||((rows<=3)&&((TotalFlag==1)||(TotalFlag==2))))
		{
			tableList[selectrow]=0;
			if (TRowID!="")
			{
				SetElement("TRowIDz"+selectrow,"");
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
	} 
	catch(e) 
	{}
}

function LookUpVehicle(vClickEventFlag)
{
	if (event.keyCode==13||event.keyCode==0||vClickEventFlag==1)
	{
		if (CheckMustItemNull()) return;
		selectrow=GetTableCurRow();
		LookUp("","web.DHCEQDispatchVehicle:GetVehicleInfo","GetVehicleInfo","TEquipz"+selectrow+",TRowIDz"+selectrow);
	}
}
function LookUpDriver(vClickEventFlag)
{
	if (event.keyCode==13||event.keyCode==0||vClickEventFlag==1)
	{
		if (CheckMustItemNull()) return;
		selectrow=GetTableCurRow();
		LookUp("","web.DHCEQDispatchVehicle:GetDriverInfo","GetDriverInfo","TDriverz"+selectrow+",TRowIDz"+selectrow+",RowID");
	}
}
function GetRequestUser (value)
{
    GetLookUpID("RequestUserDR",value);
}

function GetVehicleInfo(value)
{
	//alertShow(value)
	Clear();
	var list=value.split("^")
	var Length=ObjSources.length
	for (var i=1;i<Length;i++)
	{
		if ((tableList[i]=="0")&&(ObjSources[i].SourceID==list[1])&&(selectrow!=i))
		{
			alertShow("选择的车辆与第"+GetCElementValue("TRowz"+i)+"行重复!");
			return;
		}
	}
	var objtbl=document.getElementById('tDHCEQDispatchVehicle');
	var rows=objtbl.rows.length;
	SetElement("TEquipz"+selectrow,list[0]);
	SetElement("TEquipDRz"+selectrow,list[1]);
	SetElement("TEquipNoz"+selectrow,list[2]);
	SetElement("TVehicleNoz"+selectrow,list[3]);
	SetElement("TModelz"+selectrow,list[4]);
	SetElement("TColorz"+selectrow,list[5]);
	SetElement("TDisplacemintz"+selectrow,list[6]);
	//SetElement("TMileagez"+selectrow,list[7]);
	SetElement("TStartMileagez"+selectrow,list[7]);
}
function VehicleKeyUp()
{
	var eSrc=window.event.srcElement;
	if (!eSrc) return;
	var Id=eSrc.id
	var offset=Id.lastIndexOf("z");
	var index=Id.substring(offset+1);
	SetElement("TEquipDRz"+index,"");
}
function GetDriverInfo(value)
{
	//alertShow(value)
	var list=value.split("^");
	var Length=ObjSources.length;
	for (var i=1;i<Length;i++)
	{
		if ((tableList[i]=="0")&&(ObjSources[i].SourceID==list[1])&&(selectrow!=i))
		{
			alertShow("选择的设备项与第"+GetCElementValue("TRowz"+i)+"行重复!");
			return;
		}
	}
	var objtbl=document.getElementById('tDHCEQDispatchVehicle');
	var rows=objtbl.rows.length;
	SetElement("TDriverz"+selectrow,list[0]);
	SetElement("TDriverDRz"+selectrow,list[1]);
}
function DriverKeyUp()
{
	var eSrc=window.event.srcElement;
	if (!eSrc) return;
	var Id=eSrc.id
	var offset=Id.lastIndexOf("z");
	var index=Id.substring(offset+1);
	SetElement("TDriverDRz"+index,"");
}
function Clear()
{
	SetElement('TEquipz'+selectrow,"");
	SetElement('TEquipDRz'+selectrow,"");
	SetElement('TEquipNoz'+selectrow,"");
	SetElement('TVehicleNoz'+selectrow,"");
	SetElement('TModelz'+selectrow,"");
	SetElement('TColorz'+selectrow,"");
	SetElement('TDisplacemintz'+selectrow,"");
	SetElement('TMileagez'+selectrow,"");
	SetElement('TDriverz'+selectrow,"");
	SetElement('TDriverDRz'+selectrow,"");
	SetElement('TCardNoz'+selectrow,"");
}

function GetTableInfo()
{
    var objtbl=document.getElementById('tDHCEQDispatchVehicle');
	var rows=tableList.length;
	var valList="";
	for(var i=1;i<rows;i++)
	{
		if (tableList[i]=="0")
		{
			var TRow=GetCElementValue("TRowz"+i);
			var TRowID=GetElementValue("TRowIDz"+i);
			var TEquip=GetElementValue("TEquipz"+i);
			var TEquipDR=GetElementValue("TEquipDRz"+i);
			if ((TEquip=="")||(TEquipDR==""))
			{
				alertShow("第"+TRow+"行,请选择正确的设备或车辆!");
				SetFocusColumn("TEquip",i);
				return "-1";
			}
			//20140228  Mozy0120
			var TDriverDR=GetElementValue("TDriverDRz"+i);
			if (TDriverDR=="")
			{
				alertShow("第"+TRow+"行,请选择正确的驾驶员!");
				SetFocusColumn("TDriver",i);
				return "-1";
			}
			var TCardNo=trim(GetElementValue("TCardNoz"+i));
			var TRunDate=trim(GetElementValue("TRunDatez"+i));
			var TRunTime=trim(GetElementValue("TRunTimez"+i));
			var TEndDate=trim(GetElementValue("TEndDatez"+i));
			var TEndTime=trim(GetElementValue("TEndTimez"+i));
			var TStartMileage=GetElementValue("TStartMileagez"+i);
			var TEndMileage=GetElementValue("TEndMileagez"+i);
			var TRemark=GetElementValue("TRemarkz"+i);
			var THold1=GetElementValue("THold1z"+i);
			var THold2=GetElementValue("THold2z"+i);
			var THold3=GetElementValue("THold3z"+i);
			var THold4=GetElementValue("THold4z"+i);
			var THold5=GetElementValue("THold5z"+i);
			
			if(valList!="") {valList=valList+"&";}
			valList=valList+TRow+"^"+TRowID+"^"+TEquipDR+"^"+TDriverDR+"^"+TCardNo+"^"+TRunDate+"^"+TRunTime+"^"+TEndDate+"^"+TEndTime+"^"+TStartMileage+"^"+TEndMileage+"^"+TRemark+"^"+THold1+"^"+THold2+"^"+THold3+"^"+THold4+"^"+THold5;;
		}
	}
	return  valList;
}

function CanAddRow(objtbl)
{
	var rows=objtbl.rows.length;
    if (rows==1) return false;
	var TotalFlag=GetElementValue("TotalFlag");
	if (TotalFlag==2) rows=rows-1;
	LastNameIndex=GetRowIndex(objtbl.rows[rows-1]);
	
	return true;
}

function BApprove_Clicked()
{
	var CurRole=GetElementValue("CurRole")
  	if (CurRole=="") return;
	var RoleStep=GetElementValue("RoleStep")
  	if (RoleStep=="") return;
  	var objtbl=document.getElementById("tDHCEQDispatchVehicle");
	var EditFieldsInfo=ApproveEditFieldsInfo(objtbl);
	if (EditFieldsInfo=="-1") return;
  	var encmeth=GetElementValue("AuditData");
  	if (encmeth=="") return;
	var Rtn=cspRunServerMethod(encmeth,GetElementValue("RowID"),CurRole,RoleStep,EditFieldsInfo);
	//alertShow(Rtn+":"+EditFieldsInfo)
    if (Rtn>0)
    {
	    window.location.reload();
	}
    else
    {
	    alertShow(t["01"]);
    }
}
//20140228  Mozy0120
function TRunDate_lookupSelect(dateval)
{
	var obj=document.getElementById('TRunDatez'+selectRow);
	obj.value=dateval;
}
function TEndDate_lookupSelect(dateval)
{
	var obj=document.getElementById('TEndDatez'+selectRow);
	obj.value=dateval;
}
