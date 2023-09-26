/// 创    建:ZY  2010-03-26  No.ZY0019
/// 修改描述:设备转移
/// --------------------------------
var selectrow=0;
///记录 设备 RowID?处理重复选择RowID的问题
var ObjSources=new Array();
//最后一行数据元素的名字的后缀序号
var LastNameIndex;
//新增一行数据元素的名字的后缀序号
var NewNameIndex;

document.body.onload = BodyLoadHandler;

function BodyLoadHandler()
{
	InitUserInfo();
	InitPage();
	SetElement("MoveType",0);
	FillData();
	MoveType();
	SetEnabled();
	InitEditFields(GetElementValue("ApproveSetDR"),GetElementValue("CurRole"));
	InitApproveButton();
	SetTableItem()
	SetDisplay()
	SetElement("Job",GetElementValue("TJobz1"));
	Muilt_LookUp("FromLoc^ToLoc^Reciver^EquipType^StatCat^InStockNo^EquipNo");
	KeyUp("FromLoc^ToLoc^Reciver^EquipType^StatCat^InStockNo^EquipNo","N");
	document.body.onunload = BodyUnloadHandler;
}

function SetEnabled()
{
	
	var Status=GetElementValue("Status");
	var WaitAD=GetElementValue("WaitAD");
	if (Status!="0")
	{
		DisableBElement("BDelete",true);
		DisableBElement("BSubmit",true);
		if (Status!="")
		{
			DisableBElement("BUpdate",true);
			DisableBElement("BAdd",true);
			DisableBElement("BClear",true);			
		}
	}
	if (Status!="2")
	{
		DisableBElement("BPrint",true);
		DisableBElement("BPrintBar",true);
	}	
	if (WaitAD!="off")
	{
		DisableBElement("BUpdate",true);
		DisableBElement("BDelete",true);
		DisableBElement("BSubmit",true);
		DisableBElement("BAdd",true);
		DisableBElement("BClear",true);
	}
}
function FillData()
{
	var RowID=GetElementValue("RowID");
	if (RowID=="") return
	var obj=document.getElementById("fillData");
	if (obj){var encmeth=obj.value} else {var encmeth=""};
	var ReturnList=cspRunServerMethod(encmeth,RowID);
	ReturnList=ReturnList.replace(/\\n/g,"\n");
	list=ReturnList.split("^");
	var sort=27;
	SetElement("StoreMoveNo",list[0]);
	SetElement("FromLocDR",list[1]);
	SetElement("FromLoc",list[sort+0]);
	SetElement("ToLocDR",list[2]);
	SetElement("ToLoc",list[sort+1]);
	SetElement("MakerDR",list[3]);
	SetElement("Maker",list[sort+2]);
	SetElement("MakeDate",list[4]);
	SetElement("AckUserDR",list[5]);
	SetElement("AckUser",list[sort+3]);
	SetElement("AckDate",list[6]);
	SetElement("AckTime",list[7]);
	SetElement("InAckUserDR",list[8]);
	SetElement("InAckUser",list[sort+4]);
	SetElement("InAckDate",list[9]);
	SetElement("InAckTime",list[10]);
	SetElement("MoveType",list[11]);
	SetElement("Status",list[12]);
	SetElement("Remark",list[13]);
	SetElement("ReciverDR",list[14]);
	SetElement("Reciver",list[sort+5]);
	SetElement("EquipTypeDR",list[15]);
	SetElement("EquipType",list[sort+6]);
	SetElement("StatCatDR",list[16]);
	SetElement("StatCat",list[sort+7]);
	SetElement("ApproveSetDR",list[sort+12]);
	SetElement("NextRoleDR",list[sort+13]);
	SetElement("NextFlowStep",list[sort+14]);
	SetElement("ApproveStatu",list[sort+15]);
	SetElement("ApproveRoleDR",list[sort+16]);
	SetElement("CancelFlag",list[sort+17]);
	SetElement("CancelToFlowDR",list[sort+18]);
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
	var obj=document.getElementById("BPrintBar");
	if (obj) obj.onclick=BPrintBar_Clicked;
	var obj=document.getElementById("BClear");
	if (obj) obj.onclick=BClear_Clicked;
	
	var obj=document.getElementById("MoveType");
	if (obj) obj.onchange=MoveType;
	if (opener)
	{
		var obj=document.getElementById("BClose");
		if (obj) obj.onclick=BCloseClick;
	}
	else
	{
		EQCommon_HiddenElement("BClose")
	}
	var obj=document.getElementById("BAdd");
	if (obj) obj.onclick=AddClickHandler;
}
function BClear_Clicked()
{
	window.location.href= 'websys.default.csp?WEBSYS.TCOMPONENT=DHCEQStoreMoveNew&Status=0&QXType='+GetElementValue("QXType")+'&WaitAD=off';
}

function BUpdate_Clicked()
{
	if (CheckNull()) return;
	var combindata=GetValueList(); //总单信息
  	var valList=GetTableInfo(); //明细信息
  	if (valList=="-1")  return; //明细信息有误
  	var DelRowid=tableList.toString()
  	var encmeth=GetElementValue("UpdateData")
  	if (encmeth=="") return;
	var rtn=cspRunServerMethod(encmeth,combindata,valList,DelRowid);
	var list=rtn.split("^");
	if ((list[1]!="")&&(list.length>1))
	{
		alertShow("第"+list[0]+"行"+list[1])
	}
	else
	{
		if (list[0]>0)
		{
			alertShow("更新成功!")       //Modified By CZF      需求号：262462
			window.location.href= 'websys.default.csp?WEBSYS.TCOMPONENT=DHCEQStoreMoveNew&RowID='+rtn+"&WaitAD=off";
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

function BDelete_Clicked()
{
	var truthBeTold = window.confirm(t["02"]);
	if (!truthBeTold) return;
	var combindata=GetValueList();
  	var encmeth=GetElementValue("DeleteData")
  	if (encmeth=="") return;
	var rtn=cspRunServerMethod(encmeth,combindata);
	if (rtn==0)
    {
		window.location.href= 'websys.default.csp?WEBSYS.TCOMPONENT=DHCEQStoreMoveNew&WaitAD=off&QXType='+GetElementValue("QXType");
	}
    else
    {
	    alertShow(rtn+"   "+t["01"]);
    }
}

function BPrint_Clicked()
{
	var id=GetElementValue("RowID")
	if (id!="") PrintStoreMove(id);
}

function BCancelSubmit_Clicked() 
{
	var combindata=GetValueList();
  	var encmeth=GetElementValue("CancelSubmitData")
  	if (encmeth=="") return;
  	//Modified by jdl 2011-3-9  jdl0073
	var rtn=cspRunServerMethod(encmeth,combindata,GetElementValue("CurRole"));
    if (rtn>0)
    {
	    window.location.href= 'websys.default.csp?WEBSYS.TCOMPONENT=DHCEQStoreMoveNew&RowID='+rtn;		//+"&QXType="+GetElementValue("QXType");
	}
    else
    {
	    alertShow(rtn+"   "+t["01"]);
    }
}
function BSubmit_Clicked()
{
	if (CheckNull()) return;
	var encmeth=GetElementValue("CheckLocType")
	if (encmeth=="") return;
	var rtn=cspRunServerMethod(encmeth,GetElementValue("RowID"))
	if (rtn!="")
	{
		alertShow(rtn)
		return
	}
	var combindata=GetValueList();
  	var valList=GetTableInfo();
  	if (valList=="-1") return
  	if (valList=="")
  	{
	  	alertShow("无明细记录不可保存!")
	  	return
  	}
  	var encmeth=GetElementValue("SubmitData")
  	if (encmeth=="") return;
	var rtn=cspRunServerMethod(encmeth,combindata);
	if (rtn>0)
    {
	    window.location.href='websys.default.csp?WEBSYS.TCOMPONENT=DHCEQStoreMoveNew&RowID='+rtn+"&QXType="+GetElementValue("QXType")+"&WaitAD="+GetElementValue("WaitAD");
	}
    else
    {
	    if (isNaN(rtn)) //2011-05-27 DJ
	    {
		    alertShow(rtn+"   "+t["01"]);
	    }
	    else
	    {
		    alertShow(t[rtn]+"   "+t["01"]);
	    }
    }
}

/////////////////////////////////////////////////////////
function BApprove_Clicked()
{
	var combindata=GetValueList();
	var CurRole=GetElementValue("CurRole")
  	if (CurRole=="") return;
	var RoleStep=GetElementValue("RoleStep")
  	if (RoleStep=="") return;
  	var objtbl=document.getElementById('tDHCEQStoreMoveNew');  //2010-08-17 DJ
	var EditFieldsInfo=ApproveEditFieldsInfo(objtbl); //2010-08-17 DJ
	if (EditFieldsInfo=="-1") return //2010-08-27
  	var encmeth=GetElementValue("AuditData")
  	if (encmeth=="") return;
	var rtn=cspRunServerMethod(encmeth,combindata,CurRole,RoleStep,EditFieldsInfo);
    if (rtn>0)
    {
	    window.location.reload();
	}
    else
    {
	    if (isNaN(rtn)) //2011-05-27 DJ
	    {
		    alertShow(rtn+"   "+t["01"]);
	    }
	    else
	    {
		    alertShow(t[rtn]+"   "+t["01"]);
	    }
    }
}
/////////////////////////////////////////////////////////
function GetValueList()
{
	var combindata="";
  	combindata=GetElementValue("RowID");
  	combindata=combindata+"^"+GetElementValue("FromLocDR") ;
  	combindata=combindata+"^"+GetElementValue("ToLocDR") ;
  	combindata=combindata+"^"+GetElementValue("MoveType") ;
  	combindata=combindata+"^"+GetElementValue("Remark") ;
	combindata=combindata+"^"+GetElementValue("ReciverDR") ;
	combindata=combindata+"^"+GetElementValue("EquipTypeDR") ;
  	combindata=combindata+"^"+GetElementValue("StatCatDR") ;
	combindata=combindata+"^"+curUserID;
	combindata=combindata+"^"+GetElementValue("CancelToFlowDR");
	combindata=combindata+"^"+GetElementValue("ApproveSetDR");
	combindata=combindata+"^"+GetElementValue("Job");
	return combindata
}

function CheckNull()
{
	if (CheckMustItemNull()) return true;
	return false;
}
function GetFromLoc (value)
{
    GetLookUpID("FromLocDR",value);
}
function GetToLoc (value)
{
    GetLookUpID("ToLocDR",value);
}
function GetReciver (value)
{
    GetLookUpID("ReciverDR",value);
}
function GetStatCat (value)
{
    GetLookUpID("StatCatDR",value);
}
function GetEquipType (value)
{
    GetLookUpID("EquipTypeDR",value);
}

function BPrintBar_Clicked()
{
	DHCEQStoreMovePrintBar()
}
/// 创建:zy 2009-07-15 BugNo.ZY0007
/// 创建函数?MoveType
/// 描述:修改设备转移类型的时候给供给科室和接受科室传递不同的科室类型参数
/// -------------------------------
function MoveType()
{
	SetElement("CurHosptailID","");		//Add By DJ 2017-03-22
	var value=GetElementValue("MoveType")
	if (value=="0") //库房分配
	{
		SetElement("FromLocType","0101");
		SetElement("ToLocType","0102");
	}else if (value=="3") //科室退库
	{
		SetElement("FromLocType","0102");
		SetElement("ToLocType","0101");
	}else if (value=="1") //科室调配
	{
		SetElement("FromLocType","0102");
		SetElement("ToLocType","0102");
	}else //库房调配 2010-10-26
	{
		SetElement("CurHosptailID","0");		//Add By DJ 2017-03-22
		SetElement("FromLocType","0101");
		SetElement("ToLocType","0101");
	}
}

function SetTableItem()
{
	var objtbl=document.getElementById('tDHCEQStoreMoveNew');
	var rows=objtbl.rows.length-1;
	for (var i=1;i<=rows;i++)
	{
		var TSourceType=""
		var TSourceID=""
		var TRow=document.getElementById("TRowz"+i).innerHTML;  //列表数组初始化			
		var InStockListDR=GetElementValue("TInStockListDRz"+i)
		var TEquipDR=GetElementValue("TEquipDRz"+i);
		var TRowID=GetElementValue("TRowIDz"+i);
		var TotalFlag=GetElementValue("TotalFlag")
		if (TEquipDR=="")
		{
			TSourceType=2
			TSourceID=InStockListDR
		}
		else
		{
			TSourceType=1
			TSourceID=TEquipDR
		}
		ObjSources[i]=new SourceInfo(TSourceType,TSourceID); //TSourceType:1,单台设备 2,入库明细
		if (TRowID==-1)
		{
			obj=document.getElementById("TRowz"+i);
			if (obj) obj.innerText="合计:"
			obj=document.getElementById("BDeleteListz"+i);
			if (obj) obj.innerText=""
			obj=document.getElementById("TEquipListz"+i);
			if (obj)
			{
				obj.innerText=""
				DisableBElement("TEquipListz"+i,true);
				HiddenObj("TEquipListz"+i,1)
			}
			tableList[i]=-1
			continue;
		}
		tableList[i]=0
		ChangeRowStyle(objtbl.rows[i]);		///改变一行的内容显示
	}
}

///改变一行的内容显示
function ChangeRowStyle(RowObj)
{
	var Status=GetElementValue("Status");
	var WaitAD=GetElementValue("WaitAD");
	for (var j=0;j<RowObj.cells.length;j++)
	{
		if (!RowObj.cells[j].firstChild) {continue}
    	var value=""
    	var html=""
		var Id=RowObj.cells[j].firstChild.id;
		var offset=Id.lastIndexOf("z");
		var colName=Id.substring(0,offset);
		var objindex=Id.substring(offset+1);
		var objwidth=RowObj.cells[j].style.width;
		var objheight=RowObj.cells[j].style.height;
		
		if (colName=="TEquip")
		{
			if (CheckUnEditField(Status,colName)) continue;
			value=GetCElementValue(Id)
         	html=CreatElementHtml(2,Id,objwidth,objheight,"LookUpInStockList","","","KeyupEquip")
		}
		else if (colName=="TFlag")
		{
			value=GetCElementValue(Id)
			html=CreatElementHtml(5,Id,objwidth,objheight,"","","","")
		}
		else if (colName=="TRemark")
		{
			if (CheckUnEditField(Status,colName)) continue;
			value=GetCElementValue(Id)
			html=CreatElementHtml(1,Id,objwidth,objheight,"KeyDown_Tab","","","")
		}
		else if (colName=="TQuantityNum")
		{
			if (CheckUnEditField(Status,colName)) continue;
			value=GetCElementValue(Id)
         	html=CreatElementHtml(1,Id,objwidth,objheight,"KeyDown_Tab","","","TotalFee_Change")	
		}
		else if (colName=="BDeleteList")
		{
			if ((Status>0)||(WaitAD!="off"))
			{
				HiddenObj(colName+"z"+objindex,1)
				continue;
			}
			RowObj.cells[j].onclick=DeleteClickHandler;
		}
		else if (colName=="TEquipList")
		{
			RowObj.cells[j].onclick=EquipListClick;
		}
		//add by zy 2012-04-13 ZY0092  出库明细增加存放地点和保留字段
		else if (colName=="TLocation")
		{
			if (CheckUnEditField(Status,colName)) continue;
			value=GetCElementValue(Id)
			html=CreatElementHtml(2,Id,objwidth,objheight,"LookUpLocationNew","","","Standard_TableKeyUp")	
		}
		else if (colName=="TCommonName") //2013-06-24 DJ0118
		{
			if (CheckUnEditField(Status,colName)) continue;
			value=GetCElementValue(Id)
		    html=CreatElementHtml(1,Id,objwidth,objheight,"KeyDown_Tab","","","")
		}
		if (html!="") RowObj.cells[j].innerHTML=html;
		if (value!="")
		{
		    if (RowObj.cells[j].firstChild.tagName=="LABEL")
		    {
			    value=trim(value);
			    RowObj.cells[j].firstChild.innerText=value;
			}
			else
		    {			    
			    if ((RowObj.cells[j].firstChild.tagName=="INPUT")&&(RowObj.cells[j].firstChild.type=="checkbox"))
			    {
				    if (value==true)
				    {
					    RowObj.cells[j].firstChild.checked=true;
				    }
				    else
				    {
					    RowObj.cells[j].firstChild.checked=false;
					}
				}
			    else
			    {
				    value=trim(value);
			    	RowObj.cells[j].firstChild.value=value;
			    }
		    }
		}
	}
}

function TotalFee_Change()
{
	selectrow=GetTableCurRow();
	var TOriginalFee=GetElementValue("TOriginalFeez"+selectrow)
	var TQuantityNum=parseInt(GetElementValue("TQuantityNumz"+selectrow))
	var TMoveNum=parseInt(GetElementValue("TMoveNumz"+selectrow))
	if((TQuantityNum>TMoveNum)||(TQuantityNum<1))
	{
		alertShow("转移数量无效!")
		SetElement('TQuantityNumz'+selectrow,'');
		TQuantityNum=""
	}
	if (isNaN(TOriginalFee)||isNaN(TQuantityNum))
	{
		SetElement('TTotalFeez'+selectrow,'');
	}
	else
	{
		var TotalFee=TOriginalFee*TQuantityNum
		if (TotalFee<=0)
		{
			SetElement('TTotalFeez'+selectrow,'');
		}
		else
		{
			SetElement('TTotalFeez'+selectrow,TotalFee.toFixed(2));
		}
	}
	if (GetElementValue("TotalFlag")!=0)
	{
		SumList_Change();
	}
}

function ClearValue()
{
	selectrow=GetTableCurRow();
	SetElement('TEquipz'+selectrow,"");
	SetElement('TModelz'+selectrow,"");
	SetElement('TModelDRz'+selectrow,"");
	SetElement('TManuFactoryz'+selectrow,"");
	SetElement('TManuFactoryDRz'+selectrow,"");
	SetElement('TUnitDRz'+selectrow,"");
	SetElement('TUnitz'+selectrow,"");
	SetElement('TEquipCatDRz'+selectrow,"");
	SetElement('TEquipCatz'+selectrow,"");
	SetElement('TStatCatDRz'+selectrow,"");
	SetElement('TStatCatz'+selectrow,"");
	SetElement('TQuantityNumz'+selectrow,"");
	SetElement('TRemarkz'+selectrow,"");
	SetElement('TMoveNumz'+selectrow,"");
	SetElement('TOriginalFeez'+selectrow,"");
	SetElement('TUserYearsNumz'+selectrow,"");
	SetElement('TTotalFeez'+selectrow,"");
	SetElement('TEquipDRz'+selectrow,"");
	SetElement('TInStockListDRz'+selectrow,"");
	SetElement('TCommonNamez'+selectrow,"");	//2013-06-24 DJ0118
	if (GetElementValue("TotalFlag")!=0)
	{
		SumList_Change();
	}
}

function LookUpInStockList(vClickEventFlag)
{
	if (event.keyCode==13||event.keyCode==0||vClickEventFlag==1)
	{
		if (CheckNull()) return;
		selectrow=GetTableCurRow();
		LookUp("","web.DHCEQStoreMoveNew:GetInStockList","GetInStockList","TRowIDz"+selectrow+",FromLocDR,EquipTypeDR,StatCatDR,StockStatus,ProvderDR,ListType,TEquipz"+selectrow+",'','',TFlagz"+selectrow);
	}
}

function GetInStockList(value)
{
	var list=value.split("^");
	var Length=tableList.length
	var LastSourceType=ObjSources[selectrow].SourceType //变动之前的SourceType
	var LastSourceID=ObjSources[selectrow].SourceID //变动之前的SourceID
	if (list[2]==0)  //单台设备
	{
		for (var i=1;i<Length;i++)
		{
			if ((tableList[i]=="0")&&(ObjSources[i].SourceType=="1")&&(ObjSources[i].SourceID==list[1])&&(selectrow!=i))
			{
				var TRow=GetCElementValue("TRowz"+i);
				alertShow("当前选择行与明细中第"+(TRow)+"行重复!")
				return;
			}
		}
		list[2]="" //2011-05-27 DJ
		ObjSources[selectrow]=new SourceInfo(1,list[1])
	}
	else //入库明细
	{
		for (var i=1;i<Length;i++)
		{
			if ((tableList[i]=="0")&&(ObjSources[i].SourceType=="2")&&(ObjSources[i].SourceID==list[2])&&(selectrow!=i))
			{
				var TRow=GetCElementValue("TRowz"+i);
				alertShow("当前选择行与明细中第"+(TRow)+"行重复!")
				return;
			}
		}
		ObjSources[selectrow]=new SourceInfo(2,list[2])
	}
	
	SetElement('TEquipz'+selectrow,list[0]);
	SetElement('TEquipDRz'+selectrow,list[1]);
	SetElement('TInStockListDRz'+selectrow,list[2]);
	SetElement('TModelDRz'+selectrow,list[3]);
	SetElement('TModelz'+selectrow,list[4]);
	SetElement('TManuFactoryDRz'+selectrow,list[5]);
	SetElement('TManuFactoryz'+selectrow,list[6]);
	SetElement('TUnitDRz'+selectrow,list[7]);
	SetElement('TUnitz'+selectrow,list[8]);
	SetElement('TMoveNumz'+selectrow,list[9]);
	SetElement('TQuantityNumz'+selectrow,list[9]);
	SetElement('TOriginalFeez'+selectrow,list[10]);
	//add by zy 2012-04-13 ZY0092  出库明细增加存放地点
	SetElement('TLocationDRz'+selectrow,list[15]);
	SetElement('TLocationz'+selectrow,list[16]);
	SetElement('TTotalFeez'+selectrow,(list[9]*list[10]).toFixed(2));
	SetElement('TCommonNamez'+selectrow,list[18]); //2013-11-11 Mozy0112
	//明细记录发生变化时清空当前记录(批量记录)对应设备RowID串
	if ((LastSourceType!=ObjSources[selectrow].SourceType)||(LastSourceID!=ObjSources[selectrow].SourceID))
	{
		SetTEMPEQ(selectrow)
	}
	if (GetElementValue("TotalFlag")!=0)
	{
		SumList_Change();
	}
	var obj=document.getElementById("TEquipz"+selectrow);
	if (obj) websys_nextfocusElement(obj); 
}



function AddClickHandler() {
	try 
	{
		var objtbl=document.getElementById('tDHCEQStoreMoveNew');
		var ret=CanAddRow(objtbl);
		if (ret)
		{
			NewNameIndex=tableList.length;
	    	AddRowToList(objtbl,LastNameIndex,NewNameIndex);
			ObjSources[NewNameIndex]=new SourceInfo("","")
	    	var TEquipList=document.getElementById("TEquipListz"+NewNameIndex); //出厂编号
			if (TEquipList)	TEquipList.onclick=EquipListClick;
	    }
	    //begin add by jyp 2018-03-12 544959
	    else
	    {
		    alertShow("上一行设备名称为空!")     
		}
		//end add by jyp 2018-03-12 544959
	} catch(e) {};
}
//检测是否可以增加新记录
function CanAddRow(objtbl)
{
	var rows=objtbl.rows.length;
    if (rows==1) return false;
	var TotalFlag=GetElementValue("TotalFlag") //合计行设置参数值
	if (TotalFlag==2) rows=rows-1
	LastNameIndex=GetRowIndex(objtbl.rows[rows-1]);
	var TEquip=GetElementValue("TEquipz"+LastNameIndex)
	if  (TEquip=="")
	{
		SetFocusColumn("TEquip",LastNameIndex);
		return false;
	}
	return true;
}

function DeleteClickHandler() {
	var truthBeTold = window.confirm(t["-4003"]);
	if (!truthBeTold) return
	try
	{
		var objtbl=document.getElementById('tDHCEQStoreMoveNew');
		var rows=objtbl.rows.length;
		selectrow=GetTableCurRow();
		var TotalFlag=GetElementValue("TotalFlag")
		
		var TRowID=GetElementValue('TRowIDz'+selectrow);
		tableList[selectrow]=TRowID	
		var delNo=GetElementValue("TRowz"+selectrow);
		//判断是否删除仅剩的1行记录
		if (((TotalFlag==0)&&(rows<=2))||((rows<=3)&&((TotalFlag==1)||(TotalFlag==2)))) 
		{
			//Modified by jdl 2011-01-28 JDL0068
			//修改删除仅剩的一行后?编辑保存数据异常?无法保存的问题
			tableList[selectrow]=0;
			if (TRowID!="")
			{
				SetElement('TRowIDz'+selectrow,"");				
				tableList[tableList.length]=TRowID;
			}
			ClearValue()
			//SetElement("Job","")		//Modify DJ 2015-09-10 DJ0163
		}
		else
		{
			DeleteTabRow(objtbl,selectrow);
			if (TotalFlag!=0)
			{
				SumList_Change();
			}
		}
		// 20121127  Mozy0091
	    ResetNo(selectrow,delNo) //重新产生新的序号
	} catch(e) {};
}
function DeleteTabRow(objtbl,selectrow)
{
	var rows=objtbl.rows.length;
	if (rows>2)
	{
		var eSrc=window.event.srcElement;
		var rowObj=getRow(eSrc);
		var selectrow=rowObj.rowIndex; //当前选择行
		objtbl.deleteRow(selectrow);
	}
}
function GetTableInfo()
{
	var rows=tableList.length
	var valList="";
	for(var i=1;i<rows;i++)
	{
		if (tableList[i]=="0") //等于0表示页面显示记录
		{
			var TRow=GetCElementValue("TRowz"+i);
			var TEquip=GetElementValue('TEquipz'+i);
			if (TEquip=="")
			{
				alertShow("第"+TRow+"行未选择设备!")
				return -1			
			}
			var TRowID=GetElementValue('TRowIDz'+i);
			var TEquipDR=GetElementValue('TEquipDRz'+i);
			var TManuFactoryDR=GetElementValue('TManuFactoryDRz'+i);
			var TModelDR=GetElementValue('TModelDRz'+i);
			var TUnitDR=GetElementValue('TUnitDRz'+i);
			var TRemark=GetElementValue('TRemarkz'+i);
			var TInStockListDR=GetElementValue('TInStockListDRz'+i);	
			if ((TEquipDR=="")&&(TInStockListDR==""))
			{
				alertShow("第"+TRow+"行明细为空,请检查!")
				return "-1"
			}
			
			var TQuantityNum=parseInt(GetElementValue('TQuantityNumz'+i));
			if ((TQuantityNum=="")||(TQuantityNum<=0))
			{
				alertShow("第"+TRow+"行数量输入有误,请检查!")
				return "-1"
			}
			//Modified by JDL 2011-12-15  JDL0105 数量不能为小数
			if (GetElementValue('TQuantityNumz'+i)!=TQuantityNum)
			{
				alertShow("第"+TRow+"行数量不正确,不能为小数!");
				SetFocusColumn("TQuantityNum",i)
				return "-1";
			}
	        var TLocationDR=GetLocationRowID(GetElementValue("GetLocationOperMethod"),i)		//Add By DJ 2016-08-25
		    if ((TLocationDR<=0)&&(GetElementValue('TLocationz'+i)!=""))
		    {
			    alertShow("存放地点登记错误!")
			    return
		    }
			//add by zy 2012-04-13 ZY0092  出库明细增加存放地点和保留字段
			var TOriginalFee=trim(GetCElementValue("TOriginalFeez"+i));
			//var TLocationDR=GetElementValue('TLocationDRz'+i);
			var THold1=GetElementValue("THold1z"+i);
			var THold2=GetElementValue("THold2z"+i);
			var THold3=GetElementValue("THold3z"+i);
			var THold4=GetElementValue("THold4z"+i);
			var THold5=GetElementValue("THold5z"+i);
			var TCommonName=GetElementValue("TCommonNamez"+i);	//2013-06-24 DJ0118
			if(valList!="") {valList=valList+"&";}
			valList=valList+i+"^"+TRowID+"^"+TEquipDR+"^"+TInStockListDR+"^"+TEquip+"^"+TManuFactoryDR+"^"+TOriginalFee+"^"+TQuantityNum+"^"+TModelDR+"^"+TUnitDR+"^"+TRemark+"^"+TLocationDR;		
			valList=valList+"^"+THold1+"^"+THold2+"^"+THold3+"^"+THold4+"^"+THold5+"^"+TCommonName;	//2013-06-24 DJ0118
		}
	}
	return  valList
}

function SetDisplay()
{
	ReadOnlyCustomItem(GetParentTable("StoreMoveNo"),GetElementValue("Status"));
	ReadOnlyElements("StoreMoveNo",true)
}

function SumList_Change()
{
	var length=tableList.length
	var Num=0
	var Fee=0
	var index=""
	for (var i=0;i<length;i++)
	{
		if (tableList[i]=="0")
		{
			var TOriginalFee=parseFloat(GetElementValue("TOriginalFeez"+i))
			var TQuantityNum=parseInt(GetElementValue("TQuantityNumz"+i))
			if ((isNaN(TOriginalFee))||(isNaN(TQuantityNum))) continue;
			var TotalFee=TOriginalFee*TQuantityNum
			SetElement('TTotalFeez'+i,TotalFee.toFixed(2));  //总价显示 需求号276214 modify by mwz 2016-11-14 
			Num=Num+TQuantityNum
			Fee=Fee+TotalFee
		}
		else if (tableList[i]==-1)
		{
			var index=i
		}
	}
	SetElement('TQuantityNumz'+index,Num);
	SetElement('TTotalFeez'+index,Fee.toFixed(2));
}
function EquipListClick()
{
	selectrow=GetTableCurRow();
	var InStockListDR=GetElementValue("TInStockListDRz"+selectrow)
	var EquipDR=GetElementValue("TEquipDRz"+selectrow)
	if ((InStockListDR=="")&&(EquipDR=="")) return
	var QuantityNum=GetElementValue("TQuantityNumz"+selectrow)
	if (QuantityNum=="") return
	var lnk="websys.default.csp?WEBSYS.TCOMPONENT=DHCEQUpdateEquipsByList";
	lnk=lnk+"&SourceID="+InStockListDR
	lnk=lnk+"&QuantityNum="+QuantityNum
	lnk=lnk+"&Job="+GetElementValue("Job")
	lnk=lnk+"&index="+selectrow
	lnk=lnk+"&MXRowID="+GetElementValue("TRowIDz"+selectrow)
	lnk=lnk+"&StoreLocDR="+GetElementValue("FromLocDR")
	lnk=lnk+"&Status="+GetElementValue("Status")
	lnk=lnk+"&Type=1"
	lnk=lnk+"&EquipID="+EquipDR
   	window.open(lnk,'_blank','toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width=890,height=650,left=120,top=0')
}
///明细记录发生变化时清空之前选择记录(批量记录)对应设备RowID串
function SetTEMPEQ(index)
{
	var InStockListDR=GetElementValue("TInStockListDRz"+index)
	if (InStockListDR=="") return
	var QuantityNum=GetElementValue("TQuantityNumz"+index)
	if (QuantityNum=="") return
	var val=GetElementValue("Job")
	val=val+"^"+index
	val=val+"^"+GetElementValue("TRowIDz"+index)
  	var encmeth=GetElementValue("SetTEMPEQ")
  	if (encmeth=="") return;
	var rtn=cspRunServerMethod(encmeth,val);
	if (rtn>0)
	{
		SetElement("Job",rtn)
	}
}

///选择入库单自动保存记录
function GetInStockListInfo(value)
{
	var SMRowID=GetElementValue("RowID");
	if (SMRowID!="")
	{
		var truthBeTold = window.confirm("确定生成新单吗?");
		if (!truthBeTold) return
	}
	//获取总单及明细信息
	var val=value.split("^");
	var encmeth=GetElementValue("GetSMInfoByISL");
	if (encmeth=="") return;
	//Mozy0096	2013-4-3	增加MoveType
	//add by lmm 2017-08-08 404562 begin
	FromLocDR=GetElementValue("FromLocDR");  
	var SMInfo=cspRunServerMethod(encmeth,val[1],val[2],GetElementValue("MoveType"),FromLocDR); 
	//add by lmm 2017-08-08 404562 end
	var combindata=SMInfo+GetElementValue("Job"); //总单信息
	if (val[2]==0)
	{
		var EquipDR=val[1]
		var InStockListDR=""
	}
	else
	{
		var EquipDR=""
		var InStockListDR=val[2]
	}
	//add by zy 2012-04-13 ZY0092  出库明细增加存放地点和保留字段
	var valList="1^^"+EquipDR+"^"+InStockListDR+"^"+val[0]+"^"+val[5]+"^"+val[10]+"^"+val[9]+"^"+val[3]+"^"+val[7]+"^^"+val[15]+"^^^^^^"+val[18];	//2013-06-24 DJ0118
	var encmeth=GetElementValue("UpdateData")
  	if (encmeth=="") return;
	var rtn=cspRunServerMethod(encmeth,combindata,valList,"");
	var list=rtn.split("^");
	if ((list[1]!="")&&(list.length>1))
	{
		alertShow("第"+list[0]+"行"+list[1])
	}
	else
	{
		if (list[0]>0)
		{
			window.location.href= 'websys.default.csp?WEBSYS.TCOMPONENT=DHCEQStoreMoveNew&RowID='+rtn+"&WaitAD=off";
		}
		else
		{
			alertShow(t["01"])
		}
	}
}

function KeyupEquip()
{
	selectrow=GetTableCurRow();
	SetElement('TEquipDRz'+selectrow,"");
	SetElement('TInStockListDRz'+selectrow,"");
}
//add by zy 2012-04-13 ZY0092  出库明细增加存放地点
function LookUpLocationNew(vClickEventFlag)
{
	selectrow=GetTableCurRow();
	if (event.keyCode==13||event.keyCode==0||vClickEventFlag==1)
	{
		if (CheckNull()) return;
		LookUp("","web.DHCEQCLocation:GetShortLocation","SetLocation","TLocationz"+selectrow);
	}	
}

//add by zy 2012-04-13 ZY0092  出库明细增加存放地点
function SetLocation(value)
{
	var list=value.split("^");
	SetElement("TLocationDRz"+selectrow,list[0]);
	SetElement("TLocationz"+selectrow,list[2]);
	var obj=document.getElementById("TLocationz"+selectrow);
	if (obj) websys_nextfocusElement(obj);
}
function BodyUnloadHandler()
{
	var Job=GetElementValue("Job")
  	var encmeth=GetElementValue("KillTEMPEQ")
  	if (encmeth=="") return;
	var rtn=cspRunServerMethod(encmeth,Job);
}
///选择设备自动保存记录
function GetEquipInfo(value)
{
	var SMRowID=GetElementValue("RowID");
	if (SMRowID!="")
	{
		var truthBeTold = window.confirm("确定生成新单吗?");
		if (!truthBeTold) return;
	}
	var val=value.split("^");
	//总单信息
	var combindata="^"+val[2]+"^^"+val[10]+"^^^"+val[3]+"^"+val[4]+"^"+Guser+"^^^"+GetElementValue("Job");
	// 出库明细增加存放地点和保留字段
	//index,SMLRowID,SML_EquipDR,SML_InStockListDR,SML_Equip,SML_TManuFactoryDR,SML_TOriginalFee,SML_TQuantityNum,SML_TModelDR,SML_TUnitDR,SML_TRemark,LocationDR
	var valList="1^^"+val[1]+"^^"+val[11]+"^"+val[6]+"^"+val[12]+"^1^"+val[7]+"^"+val[8]+"^^"+val[9]+"^^^^^";
	var encmeth=GetElementValue("UpdateData");
  	if (encmeth=="") return;
	var rtn=cspRunServerMethod(encmeth,combindata,valList,"");
	//alertShow(combindata)
	var list=rtn.split("^");
	if ((list[1]!="")&&(list.length>1))
	{
		alertShow("第"+list[0]+"行"+list[1])
	}
	else
	{
		if (list[0]>0)
		{
			window.location.href= 'websys.default.csp?WEBSYS.TCOMPONENT=DHCEQStoreMoveNew&RowID='+rtn+"&WaitAD=off";
		}
		else
		{
			alertShow(t["01"])
		}
	}
}
