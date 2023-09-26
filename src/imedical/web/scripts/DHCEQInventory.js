///-----------------------------------
/// Add By DJ 2010-05-31 DJ0046
/// Description:增加盘点过滤条件设置
///-----------------------------------
/// Modified By zc 2014-09-15 ZC0006
/// 新增函数:CheckNull
/// ----------------------------------
var SelectedRow=0;
var rowid=0;
var readonly;
function BodyLoadHandler() 
{
	InitPage();
	
	SetTableItem();
}

function InitPage()
{
	KeyUp("StoreLoc^UseLoc^StatCat^Origin^PrintLoc^ManageLoc","N")
	Muilt_LookUp("StoreLoc^UseLoc^StatCat^Origin^PrintLoc^ManageLoc");
	///var obj=document.getElementById("BFind");
	///if (obj) obj.onclick=BFind_Click;
	
	var obj=document.getElementById("BUpdate");
	if (obj) obj.onclick=BUpdate_Click;
	var obj=document.getElementById("BSubmit");
	if (obj) obj.onclick=BSubmit_Click;
	
	var obj=document.getElementById("EquipType");
	if (obj) obj.onchange=EquipType_Change;
	
	var obj=document.getElementById("BPrint");
	if (obj) obj.onclick=BPrint_Click;
	
	var obj=document.getElementById("BFilterInfo"); //2010-05-31 党军 DJ0046 盘点过滤条件设置
	if (obj) obj.onclick=BFilterInfo_Click;
	
	var obj=document.getElementById("BDelete");
	if (obj) obj.onclick=BDelete_Click;
	var obj=document.getElementById("BAudit");
	if (obj) obj.onclick=BAudit_Click;
	var obj=document.getElementById("PrintBarCode");  //条码打印
	if (obj) obj.onclick=PrintBarCode_Click;
	
	var obj=document.getElementById("BSave");
	if (obj) obj.onclick=BSave_Click;
	var obj=document.getElementById("BSelectAll");
	if (obj) obj.onclick=BSelectAll_Clicked;
	
	var obj=document.getElementById("BBarCodePrint");	//Add By DJ 2016-09-21
	if (obj) obj.onclick=BBarCodePrint_Click;
	GetInventoryDetail();
	FillEquipType();
	GetDisabledElement();
}

function GetEquipType (value)
{
    GetLookUpID("EquipTypeDR",value);
}

function GetOrigin (value)
{
    GetLookUpID("OriginDR",value);
}

function GetStatCat(value)
{
	GetLookUpID("StatCatDR",value);
}

function GetStoreLocID(value)
{
	GetLookUpID('StoreLocDR',value);	
}

function BUpdate_Click()
{
	SaveInventory(0);
}

function SaveInventory(IsDel)
{
	///IsDel, InventoryDR, StoreLocDR, UseLocDR, EquipTypeDR, StatCatDR, OriginDR
	var encmeth=GetElementValue("GetUpdate");
	if (encmeth=="")
	{
		alertShow(t['NoMethod']);
		return;
	}
	if (CheckNull()) return;
	var InventoryDR=GetElementValue("InventoryDR");
	var StoreLocDR=GetElementValue("StoreLocDR");
	var UseLocDR=GetElementValue("UseLocDR");
	var EquipTypeIDs=GetElementValue("EquipTypeIDs");
	var StatCatDR=GetElementValue("StatCatDR");
	var OriginDR=GetElementValue("OriginDR");
	var FilterInfo=GetElementValue("FilterInfo");	//2010-05-31 党军 DJ0046
	var ManageLocDR=GetElementValue("ManageLocDR");
	//modified by zy 2015-08-25 ZY0136
	var StatusDR=GetElementValue("StatusDR");
	var ReadOnly=GetElementValue("ReadOnly");
	var result=cspRunServerMethod(encmeth,IsDel, InventoryDR, StoreLocDR, UseLocDR, EquipTypeIDs, StatCatDR, OriginDR, FilterInfo, ManageLocDR);	//2010-05-31 党军 DJ0046
	//alertShow(result);
	var list=result.split("^");
	if (list[0]!=0)
	{
		alertShow(t['saveFailed']+" "+list[1]);
		return;
	}
	else
	{
		var meg='saveSuccess'
		/*if (list[0]==-1)  //删除操作
		{
			list[0]=""
			SetElement("EquipTypeIDs","");
			SetElement("Status","");
			meg='deleteSuccess'
		}
		if (list[2]=='AuditSuccess')  //盘点完成操作
		{
			meg='AuditSuccess'
		}*/
		SetElement("InventoryDR",list[1]);
		alertShow(t[meg]);
		//BFind_click();	// 2011-8-11	Mozy0056
		window.location.href= 'websys.default.csp?WEBSYS.TCOMPONENT=DHCEQInventory&InventoryDR='+list[1]+"&EquipTypeIDs="+EquipTypeIDs+"&StoreLocDR="+StoreLocDR+"&StatusDR="+StatusDR+"&ReadOnly="+ReadOnly;  //modified by zy 2015-08-25 ZY0136
	}
}

function BSubmit_Click()
{
	var objtbl=document.getElementById('tDHCEQInventory');
	var rows=objtbl.rows.length;
	var lastrowindex=rows - 1;
	if (lastrowindex<=0)
	{
		alertShow("无盘点明细无法提交!请检查")
		return
	}
	var encmeth=GetElementValue("GetSubmit");
	if (encmeth=="")
	{
		alertShow(t['NoMethod']);
		return;
	}
	if (CheckNull()) return;
	var InventoryDR=GetElementValue("InventoryDR");
	var StoreLocDR=GetElementValue("StoreLocDR");
	var UseLocDR=GetElementValue("UseLocDR");
	var EquipTypeIDs=GetElementValue("EquipTypeIDs");
	var StatCatDR=GetElementValue("StatCatDR");
	var OriginDR=GetElementValue("OriginDR");
	var FilterInfo=GetElementValue("FilterInfo");	//2010-11-03 党军
	var ManageLocDR=GetElementValue("ManageLocDR");
	//modified by zy 2015-08-25 ZY0136
	var StatusDR=GetElementValue("StatusDR");
	var ReadOnly=GetElementValue("ReadOnly");
	var result=cspRunServerMethod(encmeth, InventoryDR, StoreLocDR, UseLocDR, EquipTypeIDs, StatCatDR, OriginDR, FilterInfo, ManageLocDR);
	if (0==result)
	{	alertShow(t['submitsuccess']);	
		//BFind_click();	// 2011-8-11	Mozy0056
		window.location.href= 'websys.default.csp?WEBSYS.TCOMPONENT=DHCEQInventory&InventoryDR='+InventoryDR+"&EquipTypeIDs="+EquipTypeIDs+"&StoreLocDR="+StoreLocDR+"&StatusDR="+StatusDR+"&ReadOnly="+ReadOnly; //modified by zy 2015-08-25 ZY0136
	}
	else
	{	alertShow(t['submitFailed']);	}
}
function CheckNull()
{
	if ((GetElementValue("EquipType")=="")&&(GetElementValue("EquipTypeDR")==""))
	{
		alertShow("没有选择类组,请选择类组!");  //Modefied by zc 2014-9-23 ZC0007
		return true;
	}
	return false;
}
function GetInventoryDetail()
{
	var encmeth=GetElementValue("GetOneDetail");
	if (encmeth=="")
	{
		alertShow(t['NoMethod']);
		return;
	}
	var InventoryDR=GetElementValue("InventoryDR");
	if (InventoryDR=="") 
	{
		var GetUnCheckNum=GetElementValue("GetUnCheckNum");
		if (GetUnCheckNum=="")
		{
			alertShow("未定义获取未盘点参数!")
		}
		var Job=GetElementValue("TJobz1")
		var result=cspRunServerMethod(GetUnCheckNum,Job);
		SetElement("UnCheckNum",result);
		SetElement("Status","");
		DisableButton()
		return;
	}
	
	var result=cspRunServerMethod(encmeth,InventoryDR);
	if (result!="")
	{
		var list=result.split("^");
		var sort=19;
		SetElement("InventoryNo",list[0]);
		SetElement("EquipTypeIDs",list[3]);
		SetElement("StoreLocDR",list[1]);
		SetElement("StoreLoc",list[sort+0]);	// 2011-8-11	Mozy0056
		SetElement("ManageLocDR",list[13]); //2010-11-04 DJ
		SetElement("ManageLoc",list[sort+9]); //2010-11-04 DJ
		SetElement("Date",list[sort+5]);
		SetElement("Time",list[sort+6]);
		SetElement("Status",list[9]);
		SetElement("UnCheckNum",list[sort+10]);
		if (list[9]==0)
		{
			var GetUnCheckNum=GetElementValue("GetUnCheckNum");
			if (GetUnCheckNum=="")
			{
				alertShow("未定义获取未盘点参数!")
			}
			var Job=GetElementValue("TJobz1")
			var result=cspRunServerMethod(GetUnCheckNum,Job);
			SetElement("UnCheckNum",result);
		}
		DisableButton();
	}
}

function FillEquipType()
{
	var equiptypeinfos=GetElementValue("EquipTypeInfos");
	//alertShow(equiptypeinfos);
	var obj=document.getElementById("EquipType");
	var equiptypelist=equiptypeinfos.split("&");
	//var typeids=GetElementValue("ValEquipTypes");
	var typeids=GetElementValue("EquipTypeIDs");
	if (typeids!="") typeids=","+typeids+",";
	for (var i=0;i<equiptypelist.length;i++)
	{
		var list=equiptypelist[i].split("^");
		obj.options.add(new Option(list[1],list[13],true,true));	//2011-12-31 DJ	
		if (typeids.indexOf(","+list[13]+",")>-1) //2011-12-31 DJ
		{	obj.options[i].selected=true;	
			//alertShow(obj.options[i]);
		}
		else
		{	obj.options[i].selected=false;	}
	}	
}

///type: 1 ids  2 names
function GetSelectedEquipType(type)
{
	var typeids="";
	var obj=document.getElementById("EquipType");
	for (var i=0;i<obj.options.length;i++)
	{
		if (obj.options[i].selected!=true) continue;
		if (typeids!="") typeids=typeids+",";
		if (type==1)
		{	typeids=typeids+obj.options[i].value;}
		else
		{	typeids=typeids+obj.options[i].text;}
	}
	return typeids;
}

function EquipType_Change()
{
	var typeids=GetSelectedEquipType(1);
	SetElement("EquipTypeIDs",typeids);
}

//条码打印
//add BY:GBX 2015-1-27 16:19:33  GBX0034
function PrintBarCode_Click()
{
	var locid=GetElementValue("PrintLocDR");
	var locName=GetElementValue("PrintLoc");
	var TJob=GetElementValue("TJobz2")
	if (locid!="")
	{
		var truthBeTold = window.confirm("是否打印: "+locName+" 的设备条码?");
		if (!truthBeTold) return;
	}
	else
	{
		var truthBeTold = window.confirm("确认打印条码?");
		if (!truthBeTold) return;
	}
	
	if (locid!="")
	{
		var encmeth=GetElementValue("GetNextLoc");
		if (encmeth=="")
		{
			alertShow(t['NoMethod']);
			return;
		}
		
		var encmeth=GetElementValue("GetLocEquip");
		if (encmeth=="")
		{
			alertShow(t['NoMethod']);
			return 0;
		}
	
		var InventoryDR=GetElementValue("InventoryDR");	
		if (""==InventoryDR) return 0;
		var InventoryNo=GetElementValue("InventoryNo");	
		var equipdr
		var rowid
		equipdr="";
		rowid="";
		do
		{			
			result=cspRunServerMethod(encmeth,InventoryDR,locid,equipdr,rowid);
			if (result=="")
			{
				equipdr="";
				rowid="";
			}
			else
			{
				var list=result.split("^");
				equipdr=list[0];
				rowid=list[1];
				PrintBars(equipdr,"tiaoma","固定资产")
			}
		}while(rowid!="")
	}
	else
	{
		var encmeth=GetElementValue("GetNum");  //获取打印数量
		num=cspRunServerMethod(encmeth,"",TJob);
		if (num<=0) 
		{
			alertShow("无数据可打印")
			return
		}
		encmeth=GetElementValue("GetList");  //获取打印信息
		for (var i=1; i<=num; i++)
		{
			var EquipID="";
			var str=cspRunServerMethod(encmeth,i,"",TJob);
			var List=str.split("^");
			EquipID=List[2];
			PrintBars(EquipID,"tiaoma","固定资产")
		}
	}	
}

function BPrint_Click()
{	
	var result;
	var obj=document.getElementById("BPrint");
	if ((!obj)||(obj.disabled)) return;
	var encmeth=GetElementValue("GetNextLoc");
	if (encmeth=="")
	{
		alertShow(t['NoMethod']);
		return;
	}
	
	var InventoryDR=GetElementValue("InventoryDR");	
	if (""==InventoryDR) return;
	
	var GetRepPath=GetElementValue("GetRepPath");
	if (GetRepPath=="") return;
	var TemplatePath=cspRunServerMethod(GetRepPath);
	var Template=TemplatePath+"DHCEQInventoryLoc.xls";
	
  var xlApp,xlsheet,xlBook;
	xlApp = new ActiveXObject("Excel.Application");    
	
	var locid=GetElementValue("PrintLocDR");
	
	xlBook = xlApp.Workbooks.Add(Template);
	xlsheet = xlBook.ActiveSheet;
	if (locid!="")
	{
		
		result=PrintOneLoc(locid,xlsheet);
		if (result>0) xlsheet.printout; //打印输出
	}
	else
	{
		do
		{			
			var locid=cspRunServerMethod(encmeth,InventoryDR,locid);
			if (locid!="")
			{
				result=PrintOneLoc(locid,xlsheet);
				if (result>0) 
				{
					xlsheet.printout; //打印输出
					if (result>1)
					{
						var rows=result+3;
						var rows="5:"+rows
						xlsheet.Rows(rows).Delete();
					}
					xlsheet.Rows(4).ClearContents()
				}
			}
		} while(locid!="")
	}
	xlBook.Close (savechanges=false);	    
	xlsheet.Quit;
	xlsheet=null;
	xlApp=null;
}
function GetPrintLoc(value)
{
	GetLookUpID('PrintLocDR',value);
}
function PrintOneLoc(locid,xlsheet)
{
	var equipdr,rowid;
	var row;
	var result;
	if (locid=="") return 0;
	var encmeth=GetElementValue("GetLocEquip");
	if (encmeth=="")
	{
		alertShow(t['NoMethod']);
		return 0;
	}
	
	var InventoryDR=GetElementValue("InventoryDR");	
	if (""==InventoryDR) return 0;
	var InventoryNo=GetElementValue("InventoryNo");	
	var curDate=GetCurrentDate();
	var username=curUserName;
	var loc="";
	
	row=0;
	equipdr="";
	rowid="";
	//if (locid>10) return 0;
	do
	{			
		result=cspRunServerMethod(encmeth,InventoryDR,locid,equipdr,rowid);
		if (result=="")
		{
			equipdr="";
			rowid="";
		}
		else
		{
			var list=result.split("^");
			equipdr=list[0];
			rowid=list[1];
			row=row+1;
			xlsheet.Rows(row+3).Insert();
			//NewEquipDR,NewRowID,Name,Model,Manufactory,No,Unit,EquipCat,StoreLoc,UseLocDR,UseLoc,OriginalFee,Origin,StorePlace,CheckDate,OpenCheckDate,Country,ManageUser,InDate
			xlsheet.cells(row+3,2)=list[5];	//No
			xlsheet.cells(row+3,3)=list[2];	//Name
			xlsheet.cells(row+3,4)=list[3];	//Model
			xlsheet.cells(row+3,5)=list[6];	//Unit
			xlsheet.cells(row+3,6)=list[4];	//Manufactory
			xlsheet.cells(row+3,7)=FormatDate(list[18]);	//InDate
			if (""==loc) loc=list[8];	//StoreLoc
		}
	} while(rowid!="")
	if (0==row) return 0;
	xlsheet.cells(2,3)=loc;
	xlsheet.cells(2,7)=InventoryNo;
	var delRow=row+4;
	xlsheet.Rows(delRow).Delete();
	xlsheet.cells(row+4,3)=FormatDate(curDate);
	xlsheet.cells(row+4,7)=username;
	
	return row;	
}
///新增:2010-05-31 党军 DJ0046
///描述:盘点过滤条件设置
function BFilterInfo_Click()
{
	var str='websys.default.csp?WEBSYS.TCOMPONENT=DHCEQInventoryFilterInfo&InventoryDR='+GetElementValue("InventoryDR")+'&FilterInfo='+GetElementValue("FilterInfo")
    window.open(str,'_blank','toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width=890,height=650,left=120,top=0')
}
/*
function BDelete_Click()
{
	SaveInventory(1);
}
function BAudit_Click()
{
	SaveInventory(2);	
}
*/
function DisableButton()
{
	var Status=GetElementValue("Status");
	if (Status=='')
	{
		DisableBElement("BSubmit",true);
		DisableBElement("BDelete",true);
	}
	if (Status>0)
	{
		DisableLookup("EquipType",true)
		DisableLookup("StoreLoc",true)
		DisableBElement("BUpdate",true);
		DisableBElement("BFind",true); //modified by zy 2015-08-25 ZY0136
		DisableBElement("BSubmit",true);
		DisableBElement("BDelete",true);
		DisableBElement("BFilterInfo",true);  //modified by zy 2015-08-25 ZY0136
	}
	// 2011-8-11	Mozy0056	begin
	if (Status!=1)
	{
		DisableBElement("BAudit",true);
		DisableBElement("BInventory",true);
		DisableBElement("PrintBarCode",true);
	}
	if (Status<1)
	{
		//modified by zy 2015-08-25 ZY0136
		DisableBElement("BPrint",true);
		DisableBElement("BResult",true);
		DisableBElement("BResultStat",true);
	}
	// 2011-8-11	Mozy0056	end
	//modified by zy 2015-08-25 ZY0136
	var StatusDR=GetElementValue("StatusDR");
	var ReadOnly=GetElementValue("ReadOnly");
	if (StatusDR<1)
	{
		//HiddenObj("BDelete",1)
		HiddenObj("BAudit",1);
		HiddenObj("BInventory",1);
		HiddenObj("BResult",1);
		HiddenObj("BResultStat",1);
		HiddenObj("BSave",1);
	}
	else if (StatusDR==1)
	{
		HiddenObj("BFind",1)
		HiddenObj("BUpdate",1)
		HiddenObj("BDelete",1);
		HiddenObj("BSubmit",1);
		HiddenObj("BFilterInfo",1)
	}
	else if (StatusDR==2)
	{
		HiddenObj("BFind",1)
		HiddenObj("BUpdate",1)
		HiddenObj("BDelete",1);
		HiddenObj("BSubmit",1);
		HiddenObj("BFilterInfo",1)
		HiddenObj("BAudit",1);
		HiddenObj("BInventory",1);
	}
	if (ReadOnly=="0")
	{
		HiddenObj("BAudit",1);
		HiddenObj("BInventory",1);
		//HiddenObj("BResult",1);
		//HiddenObj("BResultStat",1);
	}
	else
	{
		HiddenObj("BSave",1);
		HiddenObj("BInventory",1);
		HiddenObj("BSelectAll",1);
		HiddenObj("cBSelectAll",1);
	}
	//end by zy 2015-08-25 ZY0136
}

///Add 2010-11-03 DJ
///描述:增加管理科室
function GetManageLoc(value)
{
	GetLookUpID('ManageLocDR',value);
}

function BDelete_Click()
{
	var encmeth=GetElementValue("UpdateInventory");
	if (encmeth=="") return
	var InventoryDR=GetElementValue("InventoryDR")
	if (InventoryDR=="") return
	//modified by zy 2015-08-25 ZY0136
	var StatusDR=GetElementValue("StatusDR");
	var ReadOnly=GetElementValue("ReadOnly");
	//提示是否确定删除当前盘点单
	var truthBeTold = window.confirm("是否确定删除当前盘点单");
    if (!truthBeTold) return;
	var result=cspRunServerMethod(encmeth, InventoryDR, 1);
	if (result<0)
	{
		alertShow("删除盘点单失败!")
	}
	else
	{
		alertShow("成功删除盘点单!")
		//刷新界面
		window.location.href= "websys.default.csp?WEBSYS.TCOMPONENT=DHCEQInventory"+"&StatusDR="+StatusDR+"&ReadOnly="+ReadOnly;  //modified by zy 2015-08-25 ZY0136
	}
}

function BAudit_Click()
{
	var encmeth=GetElementValue("UpdateInventory");
	if (encmeth=="") return
	var InventoryDR=GetElementValue("InventoryDR")
	if (InventoryDR=="") return
	var EquipTypeIDs=GetElementValue("EquipTypeIDs");
	var StoreLocDR=GetElementValue("StoreLocDR");
	//modified by zy 2015-08-25 ZY0136
	var StatusDR=GetElementValue("StatusDR");
	var ReadOnly=GetElementValue("ReadOnly");
	//提示是否盘点完成
	var truthBeTold = window.confirm("是否确定当前盘点单已盘点完成");
    if (!truthBeTold) return;
	var result=cspRunServerMethod(encmeth, InventoryDR, 2);
	if (result<0)
	{
		alertShow("操作失败!")
	}
	else
	{
		alertShow("此次盘点完成!")
		//BFind_click();	// 2011-8-11	Mozy0056
		window.location.href= 'websys.default.csp?WEBSYS.TCOMPONENT=DHCEQInventory&InventoryDR='+InventoryDR+"&EquipTypeIDs="+EquipTypeIDs+"&StoreLocDR="+StoreLocDR+"&StatusDR="+StatusDR+"&ReadOnly="+ReadOnly;  //modified by zy 2015-08-25 ZY0136
	}
}

//modified by zy 2015-08-25 ZY0136
function SetTableItem()
{
	var ReadOnly=GetElementValue("ReadOnly")
	if (ReadOnly!="0") return;
	var objtbl=document.getElementById('tDHCEQInventory');//+组件名
	var rows=objtbl.rows.length-1;
	for (var i=1;i<=rows;i++)
	{
		var RowObj=objtbl.rows[i]
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
			//var objwidth=100+"px";
			//var objheight=25+"px";
			if (colName=="TActerStoreLoc")
			{
				value=document.getElementById(Id).innerText
	      html=CreatElementHtml(2,Id,objwidth,objheight,"LookUpUseLoc","","","Clear")
			}
			else if (colName=="TRemark")
			{
				value=document.getElementById(Id).innerText
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
}
function LookUpUseLoc(vClickEventFlag)
{
	if (event.keyCode==13||event.keyCode==0||vClickEventFlag==1)
	{
		SelectedRow=GetTableCurRow();		
		LookUp("","web.DHCEQFind:GetEQLoc","SetActerStoreLocID",",TActerStoreLocz"+SelectedRow);
	}
}
function SetActerStoreLocID(value)
{
	var list=value.split("^")
	SetElement('TActerStoreLocz'+SelectedRow,list[0]);
	SetElement('TActerStoreLocDRz'+SelectedRow,list[1]);
	SetElement('TActerUseLocz'+SelectedRow,list[0]);
	SetElement('TActerUseLocDRz'+SelectedRow,list[1]);
}

function Clear()
{
	var eSrc=window.event.srcElement;
	if (!eSrc) return;
	var Id=eSrc.id
	var offset=Id.lastIndexOf("z");
	var index=Id.substring(offset+1);
	//SetElement('TActerStoreLocz'+index,"");
	SetElement('TActerStoreLocDRz'+index,"");
	//SetElement('TActerUseLocz'+index,"");
	SetElement('TActerUseLocDRz'+index,"");
}
function BSave_Click()
{
	var objtbl=document.getElementById('tDHCEQInventory');//+组件名
	var rows=objtbl.rows.length-1;
	var valList="";
	for (var i=1;i<=rows;i++)
	{
		var TRowID=GetElementValue("TRowIDz"+i);
		var TActerStoreLocDR=GetElementValue("TActerStoreLocDRz"+i);
		var TActerUseLocDR=GetElementValue("TActerUseLocDRz"+i);
		var TRemark=GetElementValue("TRemarkz"+i);
		if(valList!="") {valList=valList+"&";}			
		valList=valList+TRowID+"^"+TActerStoreLocDR+"^"+TActerUseLocDR+"^"+TRemark;
	}
	var encmeth=GetElementValue("SaveResult");
	if (encmeth=="") return;
	var result=cspRunServerMethod(encmeth,valList);
	if (result==0)
	{
		location.reload();
	}
	else
	{
		alertShow(EQMsg(t["saveFailed"],result))
	}
}
function BSelectAll_Clicked()
{
	var objtbl=document.getElementById('tDHCEQInventory');//+组件名
	var rows=objtbl.rows.length-1;
	for (var i=1;i<=rows;i++)
	{
		var TRowID=GetElementValue("TRowIDz"+i);
		var TBillStoreLocDR=GetElementValue("TBillStoreLocDRz"+i);
		var TBillStoreLoc=GetElementValue("TBillStoreLocz"+i);
		var TBillUseLocDR=GetElementValue("TBillUseLocDRz"+i);
		var TBillUseLoc=GetElementValue("TBillUseLocz"+i);
		SetElement("TActerStoreLocDRz"+i,TBillStoreLocDR);
		SetElement("TActerStoreLocz"+i,TBillStoreLoc);
		SetElement("TActerUseLocDRz"+i,TBillUseLocDR);
		SetElement("TActerUseLocz"+i,TBillUseLoc);
	}
}
///Add By DJ 2016-09-21
///描述:盘点单未盘点设备条码打印
function BBarCodePrint_Click()
{
	var InventoryDR=GetElementValue("InventoryDR");
	if (InventoryDR=="")
	{
		alertShow("请先生成盘点单!")
		return
	}
	var Status=GetElementValue("Status");
	if ((Status=="")||(Status<=0))
	{
		alertShow("未确认盘点单不能打印条码!")
		return
	}
	var encmeth=GetElementValue("GetEQBarInfo");
	var Strs=""
	do
	{
		var RowID=InventoryDR+"^"+Strs
		var Strs=cspRunServerMethod(encmeth,RowID,"Inventory");
		if (Strs!="")
		{
			PrintBars(Strs,"tiaoma","固定资产")
		}
	} while (Strs!="")
}
///end by zy 2015-08-25 ZY0136
document.body.onload = BodyLoadHandler;