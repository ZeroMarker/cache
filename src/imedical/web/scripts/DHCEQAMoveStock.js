/// Created By HZY 2012-11-07  HZY0035
/// Desc:配件转移
/// --------------------------------
var selectrow=0;	
var ObjSources=new Array();	
var LastNameIndex;	//最后一行数据元素的名字的后缀序号
var NewNameIndex;	//新增一行数据元素的名字的后缀序号

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
	SetTableItem();
	SetDisplay();
	SetElement("Job",GetElementValue("TJobz1"));
	Muilt_LookUp("FromLoc^ToLoc^Reciver^AccessoryType");
	KeyUp("FromLoc^ToLoc^Reciver^AccessoryType","N");
	document.body.onunload = BodyUnloadHandler;
}

function SetEnabled()
{
	var Status=GetElementValue("Status");
	var WaitAD=GetElementValue("WaitAD");
	//alertShow(WaitAD+":"+Status)
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
	if (Status=="")
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
	}
}
function FillData()
{
	var RowID=GetElementValue("RowID");
	if (RowID=="") return;
	var obj=document.getElementById("fillData");
	if (obj)
	{
		var encmeth=obj.value;
	} 
	else{
		var encmeth="";
		return;
	}
	var ReturnList=cspRunServerMethod(encmeth,RowID);
	ReturnList=ReturnList.replace(/\\n/g,"\n");
	//alertShow(ReturnList)
	list=ReturnList.split("^");
	var sort=34;
	SetElement("MoveNo",list[0]);
	SetElement("AccessoryTypeDR",list[1]);
	SetElement("AccessoryType",list[sort+0]);
	SetElement("FromLocDR",list[3]);
	SetElement("FromLoc",list[sort+1]);
	SetElement("ToLocDR",list[4]);
	SetElement("ToLoc",list[sort+2]);
	SetElement("MakerDR",list[5]);
	SetElement("Maker",list[sort+3]);
	SetElement("MakeDate",list[6]);
	SetElement("OutAckUserDR",list[7]);
	SetElement("OutAckUser",list[sort+4]);
	SetElement("OutAckDate",list[8]);
	SetElement("OutAckTime",list[9]);
	SetElement("InAckUserDR",list[10]);
	SetElement("InAckUser",list[sort+5]);
	SetElement("InAckDate",list[11]);
	SetElement("InAckTime",list[12]);
	SetElement("MoveType",list[13]);
	SetElement("ReciverDR",list[14]);
	SetElement("Reciver",list[sort+5]);
	SetElement("BillAckUserDR",list[15]);
	SetElement("BillAckUser",list[sort+7]);
	SetElement("BillAckDate",list[16]);
	SetElement("BillAckTime",list[17]);
	SetElement("RejectReason",list[23]);
	SetElement("RejectUserDR",list[24]);
	SetElement("RejectUser",list[sort+8]);
	SetElement("RejectDate",list[25]);
	SetElement("RejectTime",list[26]);
	SetElement("Status",list[27]);
	SetElement("Remark",list[28]);
	SetElement("Hold1",list[29]);
	SetElement("Hold2",list[30]);
	SetElement("Hold3",list[31]);
	SetElement("Hold4",list[32]);
	SetElement("Hold5",list[33]);
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
	var obj=document.getElementById("BCancelSubmit");
	if (obj) obj.onclick=BCancelSubmit_Clicked;
	var obj=document.getElementById("BPrint");
	if (obj) obj.onclick=BPrint_Clicked;
	//var obj=document.getElementById("BPrintBar");	//暂不打条码
	//if (obj) obj.onclick=BPrintBar_Clicked;
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
		EQCommon_HiddenElement("BClose");
	}
	var obj=document.getElementById("BAdd");
	if (obj) obj.onclick=AddClickHandler;
}
function BClear_Clicked()
{
	window.location.href= 'websys.default.csp?WEBSYS.TCOMPONENT=DHCEQAMoveStock&Status=0&QXType=2&WaitAD=off';
}

function BUpdate_Clicked()
{
	if (CheckNull()) return;
	var combindata=GetValueList(); 	//总单信息
  	var valList=GetTableInfo(); 	//明细信息
  	if (valList=="-1")  return; 	//明细信息有误
  	var DelRowid=tableList.toString();
  	//alertShow(DelRowid);
  	var encmeth=GetElementValue("UpdateData");
  	if (encmeth=="") return;
	var rtn=cspRunServerMethod(encmeth,combindata,valList,DelRowid);
	var list=rtn.split("^");
	if ((list[1]!="")&&(list.length>1))
	{
		alertShow("第"+list[0]+"行"+list[1]);
	}
	else
	{
		if (list[0]>0)
		{
			alertShow("保存成功!")
			window.location.href= 'websys.default.csp?WEBSYS.TCOMPONENT=DHCEQAMoveStock&RowID='+rtn+"&WaitAD=off";
		}
		else
		{
			if (list[0]=="-1015")
			{
				alertShow(t[list[0]]);
			}
			else
			{
				alertShow(t["01"]);
			}
		}
	}
}

function BDelete_Clicked()
{
	var truthBeTold = window.confirm(t["02"]);
	if (!truthBeTold) return;
	var RowID=GetElementValue("RowID");
  	var encmeth=GetElementValue("DeleteData");
  	if (encmeth=="") return;
	var rtn=cspRunServerMethod(encmeth,RowID);
	if (rtn==0)
    {
		window.location.href= 'websys.default.csp?WEBSYS.TCOMPONENT=DHCEQAMoveStock&WaitAD=off&QXType='+GetElementValue("QXType");
	}
    else
    {
	    alertShow(rtn+"   "+t["01"]);
    }
}
//add by wl 2019-11-21 WL0013 
function BPrint_Clicked()
{
	var AMSRowID = GetElementValue("RowID"); //出库ID
	var PrintFlag = GetElementValue("PrintFlag");	 //打印方式标志位 excel：0  润乾:1   
	var PreviewRptFlag = GetElementValue("PreviewRptFlag"); //润乾预览标志 不预览 :0  预览 :1
	var HOSPDESC = GetElementValue("GetHospitalDesc");
	var filename = ""
	//Excel打印方式
	if(PrintFlag==0)  
	{
		PrintExcel();
	}
	//润乾打印
	if(PrintFlag==1)
	{
		if(PreviewRptFlag==0)
		{ 
		    fileName="{DHCEQAMoveStock.raq(AMSRowID="+AMSRowID
		    +";HOSPDESC="+HOSPDESC
		    +";curUserName="+curUserName
		    +";PrintFlag=1"
		    +")}";
		    
	        DHCCPM_RQDirectPrint(fileName);		
		}
		
		if(PreviewRptFlag==1)
		{ 
			fileName="DHCEQAMoveStock.raq&AMSRowID="+AMSRowID
		    +"&HOSPDESC="+HOSPDESC
		    +"&curUserName="+curUserName	   
			DHCCPM_RQPrint(fileName);
			
		}
	}	
	
}
//modify by wl 2019-11-21 WL0013
function PrintExcel()
{
	var AMoveStockid=GetElementValue("RowID");
	if (AMoveStockid=="")
	{
		alertShow("无记录!");
		return;
	}
	var encmeth=GetElementValue("fillData");
	if (encmeth=="") return;
	var ReturnList=cspRunServerMethod(encmeth,AMoveStockid);
	ReturnList=ReturnList.replace(/\\n/g,"\n");
	var lista=ReturnList.split("^");
	//alertShow(lista);
	var movetype=lista[13];
	var encmeth=GetElementValue("GetList");
	if (encmeth=="") return;
	var gbldata=cspRunServerMethod(encmeth,AMoveStockid);
	var list=gbldata.split(GetElementValue("SplitNumCode"));
	var Listall=list[0];
	rows=list[1];
	
	var PageRows=8;
	var Pages=parseInt(rows / PageRows); 	//总页数-1
	var ModRows=rows%PageRows;
	if (ModRows==0) {Pages=Pages-1;}
	
	var encmeth=GetElementValue("GetRepPath");
	if (encmeth=="") return;
	var	TemplatePath=cspRunServerMethod(encmeth);
	
	try {
        var xlApp,xlsheet,xlBook;
	    var Template;
    	Template=TemplatePath+"DHCEQAMoveStock.xls";
	    xlApp = new ActiveXObject("Excel.Application");
	    var sort=34;
	    var Listsort=18;	
	    for (var i=0;i<=Pages;i++)
	    {
		    xlBook = xlApp.Workbooks.Add(Template);
	    	xlsheet = xlBook.ActiveSheet;
	    	xlsheet.PageSetup.TopMargin=0;
	    	
	    	if (movetype=="0")
			{
				xlsheet.cells(1,2)="[Hospital]配件出库单";
				xlsheet.cells(2,8)="出库单号:"+lista[0];  //凭单号
		    	//xlsheet.cells(3,6)=GetShortName(lista[sort+1],"-");//供给部门
		    	xlsheet.cells(2,2)=xlsheet.cells(2,2)+GetShortName(lista[sort+2],"-");//接收部门
	    	}
			else if (movetype=="1")
			{
		    	xlsheet.cells(1,2)="[Hospital]配件调配单";
		    	xlsheet.cells(2,8)="调配单号:"+lista[0];  //凭单号
		    	//xlsheet.cells(3,6)=GetShortName(lista[sort+1],"-");//供给部门
		    	xlsheet.cells(2,2)=xlsheet.cells(2,2)+GetShortName(lista[sort+2],"-");//接收部门
			}
	    	if (movetype=="2")
	    	{
		    	xlsheet.cells(1,2)="[Hospital]配件退库单";
		    	xlsheet.cells(2,8)="退库单号:"+lista[0];  //凭单号
		    	//xlsheet.cells(3,6)=GetShortName(lista[sort+1],"-");//供给部门
		    	xlsheet.cells(2,2)=xlsheet.cells(2,2)+GetShortName(lista[sort+2],"-");//接收部门
	    	}
	    	xlsheet.cells.replace("[Hospital]",GetElementValue("GetHospitalDesc"))
	    	xlsheet.cells(2,6)=ChangeDateFormat(lista[6]);	    	
	    	//xlsheet.cells(3,2)="类组:"+lista[sort+0];
	    	
	    	var OnePageRow=PageRows;
	   		if ((i==Pages)&&(ModRows!=0)) OnePageRow=ModRows;
			for (var Row=1;Row<=OnePageRow;Row++)
			{
				var Lists=Listall.split(GetElementValue("SplitRowCode"));
				var Listl=Lists[i*PageRows+Row];
				//alertShow(Listl);
				var List=Listl.split("^");
				var cellRow=Row+3;
				if (List[4]=='合计') cellRow=11;
				xlsheet.cells(cellRow,2)=List[4];//配件名称
				xlsheet.cells(cellRow,4)=List[5];//机型
				xlsheet.cells(cellRow,5)=List[Listsort+2];//单位
				xlsheet.cells(cellRow,6)=List[11];//数量
				xlsheet.cells(cellRow,7)=List[10];//原值
				xlsheet.cells(cellRow,8)=List[12];//总价
				//xlsheet.cells(cellRow,8)=List[Listsort+3];//生产厂商
				xlsheet.cells(cellRow,9)=List[Listsort+4];//入库单号
	    	}
		    xlsheet.cells(12,2)=xlsheet.cells(12,2)+lista[sort+5]; //接收人
		    xlsheet.cells(12,5)=xlsheet.cells(12,5)+lista[sort+3]+" "; //制单人
		    xlsheet.cells(12,9)="第"+(i+1)+"页 "+"共"+(Pages+1)+"页"; 
		    
		    var obj = new ActiveXObject("PaperSet.GetPrintInfo");
			var size=obj.GetPaperInfo("DHCEQInStock");
			if (0!=size) xlsheet.PageSetup.PaperSize = size;
		    
		    xlsheet.printout; //打印输出
		    xlBook.Close(savechanges=false);
		    xlsheet.Quit;
		    xlsheet=null;
	    }
	    xlApp=null;
	} 
	catch(e)
	{
		alertShow(e.message);
	}
	/// Mozy	2016-6-15
	var encmeth=GetElementValue("SaveOperateLog");
	if (encmeth=="") return;
	cspRunServerMethod(encmeth,"^A02^"+AMoveStockid,1);
}

function BCancelSubmit_Clicked() 
{
	var combindata=GetValueList();
  	var encmeth=GetElementValue("CancelSubmitData");
  	if (encmeth=="") return;
  	var obj=document.getElementById("RejectReason");  
  	var RejectReason=GetElementValue("RejectReason");
  	if ((obj)&&(RejectReason==""))
  	{
	  	alertShow("拒绝原因为空,不能进行取消.");
	  	return;
  	}
  	combindata=combindata+"^"+RejectReason;
	var rtn=cspRunServerMethod(encmeth,combindata,GetElementValue("CurRole"));
    if (rtn>0)
    {
	    window.location.href= 'websys.default.csp?WEBSYS.TCOMPONENT=DHCEQAMoveStock&RowID='+rtn; //+"&QXType="+GetElementValue("QXType");
	}
    else
    {
	    alertShow(rtn+"   "+t["01"]);
    }
}

function BSubmit_Clicked()
{
	if (CheckNull()) return;
	var encmeth=GetElementValue("CheckLocType");
	if (encmeth=="") return;
	var rtn=cspRunServerMethod(encmeth,GetElementValue("RowID"));
	if (rtn!="")
	{
		alertShow(rtn);
		return;
	}
	var combindata=GetValueList();
  	var valList=GetTableInfo();
  	if (valList=="-1") return;
  	if (valList=="")
  	{
	  	alertShow("无明细记录不可保存!");
	  	return;
  	}
  	var encmeth=GetElementValue("SubmitData");
  	if (encmeth=="") return;
	var rtn=cspRunServerMethod(encmeth,combindata);
	if (rtn>0)
    {
	    window.location.href='websys.default.csp?WEBSYS.TCOMPONENT=DHCEQAMoveStock&RowID='+rtn+"&QXType="+GetElementValue("QXType")+"&WaitAD="+GetElementValue("WaitAD");
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

function BApprove_Clicked()
{
	var combindata=GetValueList();
	var CurRole=GetElementValue("CurRole");
  	if (CurRole=="") return;
	var RoleStep=GetElementValue("RoleStep");
  	if (RoleStep=="") return;
  	var objtbl=document.getElementById('tDHCEQAMoveStock');  
	var EditFieldsInfo=ApproveEditFieldsInfo(objtbl); 
	if (EditFieldsInfo=="-1") return ;
  	var encmeth=GetElementValue("AuditData");
  	if (encmeth=="") return;
  	//alertShow(combindata+" # "+CurRole+" # "+RoleStep+" # "+EditFieldsInfo)
	var rtn=cspRunServerMethod(encmeth,combindata,CurRole,RoleStep,EditFieldsInfo);
    if (rtn>0)
    {
	    window.location.reload();
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

function GetValueList()
{
	var combindata="";
  	combindata=GetElementValue("RowID"); //RowID,AccessoryTypeDR,FromLocDR,ToLocDR,MoveType,ReciverDR,Remark,LOGON.USERID,CancelToFlowDR,ApproveSetDR,Job
  	combindata=combindata+"^"+GetElementValue("AccessoryTypeDR") ;
  	combindata=combindata+"^"+GetElementValue("FromLocDR") ;
  	combindata=combindata+"^"+GetElementValue("ToLocDR") ;
  	combindata=combindata+"^"+GetElementValue("MoveType") ;
	combindata=combindata+"^"+GetElementValue("ReciverDR") ;
	combindata=combindata+"^"+GetElementValue("Remark") ;
	combindata=combindata+"^"+curUserID;				//8
	combindata=combindata+"^"+GetElementValue("CancelToFlowDR");	//9
	combindata=combindata+"^"+GetElementValue("ApproveSetDR");		//10
	combindata=combindata+"^"+GetElementValue("Job");
	return combindata;
}

function CheckNull()
{
	if (CheckMustItemNull()) return true;
	return false;
}
function GetFromLoc(value)
{
    GetLookUpID("FromLocDR",value);
}
function GetToLoc(value)
{
    //GetLookUpID("ToLocDR",value);
	var val=value.split("^");
	SetElement("ToLoc",val[0]);
	SetElement("ToLocDR",val[1]);
	//SetElement("ReciverDR",val[3]);
	//SetElement("Reciver",val[4]);
}
function GetReciver(value)
{
    GetLookUpID("ReciverDR",value);
}

function GetAccessoryType(value)
{
    GetLookUpID("AccessoryTypeDR",value);
}

function BPrintBar_Clicked()
{
	//暂时不用打印条码.
	//DHCEQStoreMovePrintBar();
}

/// 描述:修改配件转移类型的时候,给供给科室和接受科室传递不同的科室类型参数
/// -------------------------------
function MoveType()
{
	var value=GetElementValue("MoveType");
	if (value=="0") //出库
	{
		SetElement("FromLocType","0101");
		SetElement("ToLocType","0102");
	}
	else if (value=="1") //库房调配
	{
		SetElement("FromLocType","0101");
		SetElement("ToLocType","0101");
	}
	else if (value=="2") //退库
	{
		SetElement("FromLocType","0102");
		SetElement("ToLocType","0101");
	}
}

function SetTableItem()
{
	var objtbl=document.getElementById('tDHCEQAMoveStock');
	var rows=objtbl.rows.length-1;
	for (var i=1;i<=rows;i++)
	{
		var TSourceType="";
		var TSourceID="";
		var TRow=document.getElementById("TRowz"+i).innerHTML;  //列表数组初始化			
		var TRowID=GetElementValue("TRowIDz"+i);
		var TotalFlag=GetElementValue("TotalFlag");
		///ObjSources[i]=new SourceInfo(TSourceType,TSourceID); //TSourceType:1,单台配件 2,入库明细
		if (TRowID==-1)
		{
			obj=document.getElementById("TRowz"+i);
			if (obj) obj.innerText="合计:";
			obj=document.getElementById("BDeleteListz"+i);
			if (obj) obj.innerText="";
			obj=document.getElementById("TBSerialNoz"+i);
			if (obj) obj.innerText="";
			obj=document.getElementById("BMRequestz"+i);
			if (obj) obj.innerText="";
			tableList[i]=-1;
			document.getElementById("TQuantityNumz"+i).style.color="#ff8000";
			document.getElementById("TQuantityNumz"+i).style.fontWeight=900;
			document.getElementById("TAmountz"+i).style.color="#ff8000";
			document.getElementById("TAmountz"+i).style.fontWeight=900;
			continue;
		}
		tableList[i]=0;
		ChangeRowStyle(objtbl.rows[i]);		///改变一行的内容显示
		document.getElementById("TQuantityNumz"+i).style.color="#0000ff";
	   	document.getElementById("TQuantityNumz"+i).style.fontWeight=900;
		document.getElementById("TPricez"+i).style.color="#0000ff";
	   	document.getElementById("TPricez"+i).style.fontWeight=900;
		document.getElementById("TAmountz"+i).style.fontWeight=900;
	}
}

///改变一行的内容显示
function ChangeRowStyle(RowObj)
{
	var Status=GetElementValue("Status");
	for (var j=0;j<RowObj.cells.length;j++)
	{
		if (!RowObj.cells[j].firstChild) {continue;}
    	var value="";
    	var html="";
		var Id=RowObj.cells[j].firstChild.id;
		var offset=Id.lastIndexOf("z");
		var colName=Id.substring(0,offset);
		var objindex=Id.substring(offset+1);
		var objwidth=RowObj.cells[j].style.width;
		var objheight=RowObj.cells[j].style.height;
		
		if (colName=="TDesc")
		{
			if (CheckUnEditField(Status,colName)) continue;
			value=GetCElementValue(Id);
         	html=CreatElementHtml(2,Id,objwidth,objheight,"LookUpAccessory","","","KeyUpAccessory");
		}
		else if (colName=="TRemark")
		{
			if (CheckUnEditField(Status,colName)) continue;
			value=GetCElementValue(Id);
			html=CreatElementHtml(1,Id,objwidth,objheight,"KeyDown_Tab","","","");
		}
		else if (colName=="TQuantityNum")
		{
			if (CheckUnEditField(Status,colName)) continue;
			value=GetCElementValue(Id);
         	html=CreatElementHtml(1,Id,objwidth,objheight,"KeyDown_Tab","","","TotalFee_Change");	
		}
		else if (colName=="TSerialFlag")
		{
			value=GetCElementValue(Id);
			html=CreatElementHtml(5,Id,objwidth,objheight,"ClickCheckBox","","","")	// 5 ClickCheckBox
			//RowObj.cells[j].firstChild.disabled=true;	
		}
		else if (colName=="TFlag")//qw0005-2014-06-12
		{
			value=GetCElementValue(Id)
			html=CreatElementHtml(5,Id,objwidth,objheight,"","","","")
		}
		else if (colName=="TBatchFlag")
		{
			value=GetCElementValue(Id);
			html=CreatElementHtml(5,Id,objwidth,objheight,"ClickCheckBox","","","")	// 5 ClickCheckBox
			//RowObj.cells[j].firstChild.disabled=true;	
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
		else if (colName=="TBSerialNo")
		{
			RowObj.cells[j].onclick=BSerialNoClick;
		}
		else if (colName=="THold3")
		{
			if (CheckUnEditField(Status,colName)) continue;
			value=GetCElementValue(Id);
			html=CreatElementHtml(1,Id,objwidth,objheight,"KeyDown_Tab","","","");
		}
		else if (colName=="THold4")
		{
			if (CheckUnEditField(Status,colName)) continue;
			value=GetCElementValue(Id);
			html=CreatElementHtml(1,Id,objwidth,objheight,"KeyDown_Tab","","","");
		}
		else if (colName=="TEquipName")
		{
			if (CheckUnEditField(Status,colName)) continue;
			value=GetCElementValue(Id);
         	html=CreatElementHtml(2,Id,objwidth,objheight,"LookUpEquip","","","KeyUpEquip");
		}
		/// 设置维修单链接可视性
		obj=document.getElementById("BMRequestz"+objindex);
		if ((obj)&&(GetElementValue("TMRRowIDz"+objindex)=="")) obj.innerText="";
		
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
					 //add by:GBX 2014-8-22 13:58:14
				    //勾选框设为不可编辑
				    if ((colName=="TSerialFlag")||(colName=="TBatchFlag"))
				    {
					    RowObj.cells[j].firstChild.disabled=true;
				    }	
					//RowObj.cells[j].firstChild.disabled=true;	//
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
	var TPrice=GetElementValue("TPricez"+selectrow);
	//201702-04	Mozy
	var TQuantityNum=+GetElementValue("TQuantityNumz"+selectrow);
	var TMoveNum=+GetElementValue("TMoveNumz"+selectrow);	//可转移的数量
	//alertShow(TQuantityNum+":"+TMoveNum);
	if(TQuantityNum>TMoveNum)
	{
		var TBatchFlag=GetElementValue("TBatchFlagz"+selectrow);
		if (TBatchFlag)
		{
			alertShow("修改数量超出了可用数量范围!");
			SetElement('TQuantityNumz'+selectrow,'');
			TQuantityNum="";
		}
		else
		{
			alertShow("修改数量超出了可用数量范围!");	//Add By DJ 2014-09-12
			SetElement('TQuantityNumz'+selectrow,1);
			TQuantityNum=1;
		}
	}
	if (isNaN(TPrice)||isNaN(TQuantityNum))
	{
		SetElement('TAmountz'+selectrow,'');
		alertShow("输入的数量或单价为无效数值!");
	}
	else
	{
		var TotalFee=TPrice*TQuantityNum;
		if (TotalFee<=0)
		{
			SetElement('TAmountz'+selectrow,'');
		}
		else
		{
			SetElement('TAmountz'+selectrow,TotalFee.toFixed(2));
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
	SetElement('TModelz'+selectrow,"");
	SetElement('TModelDRz'+selectrow,"");
	SetElement('TManuFactoryz'+selectrow,"");
	SetElement('TManuFactoryDRz'+selectrow,"");
	SetElement('TBaseUOMDRz'+selectrow,"");		//Modify DJ 2014-09-10 begin
	SetElement('TBaseUOMz'+selectrow,"");		
	SetElement('TDescz'+selectrow,"");		
	SetElement('TAInStockListDRz'+selectrow,"");
	SetElement('TSerialFlagz'+selectrow,"");
	SetElement('TBatchFlagz'+selectrow,"");
	SetElement('TFlagz'+selectrow,"");		//Modify DJ 2014-09-10 end
	SetElement('TQuantityNumz'+selectrow,"");
	SetElement('TRemarkz'+selectrow,"");
	SetElement('TMoveNumz'+selectrow,"");
	SetElement('TPricez'+selectrow,"");
	SetElement('TAmountz'+selectrow,"");
	SetElement('TStockDetailDRz'+selectrow,"");
	SetElement('THold5z'+selectrow,"");		//需求号:271031		Mozy	2016-10-19
	if (GetElementValue("TotalFlag")!=0)
	{
		SumList_Change();
	}
}

function AddClickHandler() 
{
	try 
	{
		var objtbl=document.getElementById('tDHCEQAMoveStock');
		var ret=CanAddRow(objtbl);
		if (ret)
		{
			NewNameIndex=tableList.length;
	    	AddRowToList(objtbl,LastNameIndex,NewNameIndex);
			//ObjSources[NewNameIndex]=new SourceInfo("","");
	    	var TBSerialNo=document.getElementById("TBSerialNoz"+NewNameIndex); //
			if (TBSerialNo)	 TBSerialNo.onclick=BSerialNoClick;
	    }
	} catch(e) {}
}

function CanAddRow(objtbl)
{
	var rows=objtbl.rows.length;
    if (rows==1) return false;
	var TotalFlag=GetElementValue("TotalFlag"); //合计行设置参数值
	if (TotalFlag==2) rows=rows-1;
	LastNameIndex=GetRowIndex(objtbl.rows[rows-1]);
	var TDesc=GetElementValue("TDescz"+LastNameIndex);
	if  (TDesc=="")
	{
		// Mozy	2016-1-18	自动添加一行时不做过滤
		//SetFocusColumn("TDesc",LastNameIndex);
		//return false;
	}
	return true;
}

function DeleteClickHandler() {
	var truthBeTold = window.confirm(t["-4003"]);
	if (!truthBeTold) return;
	try
	{
		var objtbl=document.getElementById('tDHCEQAMoveStock');
		var rows=objtbl.rows.length;
		selectrow=GetTableCurRow();
		var TotalFlag=GetElementValue("TotalFlag");
		var TRowID=GetElementValue('TRowIDz'+selectrow);
		tableList[selectrow]=TRowID	;
		var delNo=GetElementValue("TRowz"+selectrow);
		//判断是否删除仅剩的1行记录
		if (((TotalFlag==0)&&(rows<=2))||((rows<=3)&&((TotalFlag==1)||(TotalFlag==2)))) 
		{
			tableList[selectrow]=0;
			if (TRowID!="")
			{
				SetElement('TRowIDz'+selectrow,"");				
				tableList[tableList.length]=TRowID;
			}
			ClearValue();
			//SetElement("Job","");
		}
		else
		{
			DeleteTabRow(objtbl,selectrow);
			if (TotalFlag!=0)
			{
				SumList_Change();
			}
		}
	    //SetRowNo(selectrow,delNo) ;
	    ResetNo(selectrow,delNo);
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
	var rows=tableList.length;
	var valList="";
	for(var i=1;i<rows;i++)
	{
		if (tableList[i]=="0") //等于0表示页面显示记录
		{
			var TRow=GetCElementValue("TRowz"+i);
			var TItemDR=GetElementValue('TItemDRz'+i);
			if (TItemDR=="")
			{
				//continue;
				//需求序号:	418216		Mozy	20170731	无明细记录不能进行更新
				alertShow("第"+TRow+"行未选择配件!");
				return -1;		
			}
			var TRowID=GetElementValue('TRowIDz'+i);
			var TCode=GetElementValue('TCodez'+i);
			var TDesc=GetElementValue('TDescz'+i);
			var TModel=GetElementValue('TModelz'+i);
			var TBaseUOMDR=GetElementValue('TBaseUOMDRz'+i);
			var TManuFactoryDR=GetElementValue('TManuFactoryDRz'+i);
			var TBatchFlag=GetElementValue('TBatchFlagz'+i);
			var TSerialFlag=GetElementValue('TSerialFlagz'+i);
			var TPrice=GetElementValue('TPricez'+i);
			//201702-04	Mozy
			var TQuantityNum=+GetElementValue('TQuantityNumz'+i);
			if ((TQuantityNum=="")||(TQuantityNum<=0))
			{
				alertShow("第"+TRow+"行数量输入有误,请检查!");
				return "-1";
			}
			/*if (GetElementValue('TQuantityNumz'+i)!=TQuantityNum)
			{
				alertShow("第"+TRow+"行数量不正确,不能为小数!");
				SetFocusColumn("TQuantityNum",i);
				return "-1";
			}*/
			var TAmount=GetElementValue('TAmountz'+i);
			var TRemark=GetElementValue('TRemarkz'+i);
			var TStockDetailDR=GetElementValue("TStockDetailDRz"+i);
			var TAInStockListDR=GetElementValue("TAInStockListDRz"+i);
			var TEquipDR=GetElementValue("TEquipDRz"+i);
			var THold1=GetElementValue("THold1z"+i);
			var THold2=GetElementValue("THold2z"+i);
			var THold3=GetElementValue("THold3z"+i);
			var THold4=GetElementValue("THold4z"+i);
			var THold5=+GetElementValue("THold5z"+i);
			var TMoveNum=+GetElementValue("TMoveNumz"+i);
			/*if (TQuantityNum>TMoveNum)
			{
				alertShow("第"+TRow+"行出库数量大于库存数!");
				SetFocusColumn("TQuantityNum",i);
				return "-1";
			}*/
			if(valList!="") {valList=valList+"&";}
			valList=valList+TRow+"^"+TRowID+"^"+TItemDR+"^"+TCode+"^"+TDesc+"^"+TModel+"^"+TBaseUOMDR+"^"+TManuFactoryDR+"^"+TBatchFlag+"^"+TSerialFlag+"^"+TPrice+"^"+TQuantityNum+"^"+TAmount+"^"+TRemark+"^"+TStockDetailDR;		
			valList=valList+"^"+TAInStockListDR+"^"+TEquipDR+"^"+THold1+"^"+THold2+"^"+THold3+"^"+THold4+"^"+THold5;
		}
	}
	return  valList;
}

function SetDisplay()
{
	ReadOnlyCustomItem(GetParentTable("MoveNo"),GetElementValue("Status"));
	ReadOnlyElements("MoveNo",true);
}

function SumList_Change()
{
	var length=tableList.length;
	var Num=0;
	var Fee=0;
	var index="";
	for (var i=0;i<length;i++)
	{
		if (tableList[i]=="0")
		{
			var TPrice=parseFloat(GetElementValue("TPricez"+i));
			var TQuantityNum=parseFloat(GetElementValue("TQuantityNumz"+i));	//201702-04	Mozy
			if ((isNaN(TPrice))||(isNaN(TQuantityNum))) continue;
			var TotalFee=TPrice*TQuantityNum;
			Num=Num+TQuantityNum;
			Fee=Fee+TotalFee;
		}
		else if (tableList[i]==-1)
		{
			index=i;
		}
	}
	SetElement('TQuantityNumz'+index,Num.toFixed(2));	//201702-04	Mozy
	SetElement('TAmountz'+index,Fee.toFixed(2));
}

function LookUpAccessory(vClickEventFlag)
{
	selectrow=GetTableCurRow();
	var changeType=GetElementValue("ChangeType"); //modify by:GBX 2014-8-31 13:27:16
	if (event.keyCode==13||event.keyCode==0||vClickEventFlag==1)
	{
		if (CheckNull()) return;
		LookUp("","web.DHCEQAReduce:GetAStockDetailNew","GetAStockDetailNew","TStockDetailDRz"+selectrow+",FromLocDR,AccessoryTypeDR,TDescz"+selectrow+",TFlagz"+selectrow+",ChangeType,TRowIDz"+selectrow);
	}	
}

function KeyUpAccessory()
{
	selectrow=GetTableCurRow();
	SetElement('TStockDetailDRz'+selectrow,"");
}
//201702-04	Mozy
function LookUpEquip(vClickEventFlag)
{
	selectrow=GetTableCurRow();
	if (event.keyCode==13||event.keyCode==0||vClickEventFlag==1)
	{
		if (CheckNull()) return;
		LookUp("","web.DHCEQEquip:GetShortEquip","SetEquip","TEquipNamez"+selectrow);
	}
}
function KeyUpEquip()
{
	selectrow=GetTableCurRow();
	SetElement('TEquipDRz'+selectrow,"");
	SetElement("TFileNoz"+selectrow,"");
}
function SetEquip(value)
{
	var list=value.split("^");
	SetElement("TEquipNamez"+selectrow,list[0]);
	SetElement("TEquipDRz"+selectrow,list[1]);
	SetElement("TFileNoz"+selectrow,list[15]);
}
// Modify By :GBX GBX0024 2014-8-28 00:08:46 数量赋值调整?点击赋值可转移的数量
function GetAStockDetail(value)
{
	AddClickHandler();
	//TRowID,TDesc,TCode,TLocDR,TLoc,TAccessoryTypeDR,TAccessoryType,TStatus,THasStockFlag,TItemDR,TItem,TAInStockListDR,TBatchNo,TExpiryDate,TBprice,TSerialNo,TNo,TBaseUOMDR,TBaseUOM,TManuFactoryDR,TManuFactory,TModel,TProviderDR,TProvider,TStock,TFreezeStock,TStartDate,TDisuseDate,TStockDR,TInType,TInSourceID,TToType,TToSourceID,TOriginDR,TOrigin,CanUseNum,FreezeNum,TReturnFee,TTotalFee,TInStockNo,TInDate,TBatchFlag
	//   0     1     2      3     4        5                6           7          8           9     10        11            12        13         14       15    16     17         18       19             20          21      22           23      24      25            26         27          28      29      30          31     32           33         34      35      36			37		38           39      40		41
	list=value.split("^");
	//modify BY?GBX 2014-8-25 14:11:47
	//转移单为同一个入库单时只能做一条数据
	var Length=tableList.length
	//alertShow("Length="+Length);
	var currow=GetCElementValue("TRowz"+selectrow);
	for (var i=1;i<Length;i++)
	{
		if ((tableList[i]=="0")&&(list[11]==GetElementValue('TAInStockListDRz'+i))&&(list[0]==GetElementValue('TAStockDetailDRz'+i))) //modified by wsp 201512-23
		{
			var TRow=GetCElementValue("TRowz"+i);
			if (TRow==currow)
			{
				continue;
			}
			alertShow("当前选择行与明细中第"+(TRow)+"行重复,请直接修改数量")
			return;
		}
	}

	//alertShow("value="+value+"   selectrow="+selectrow);
	SetElement("TAStockDetailDRz"+selectrow,list[0]);  //add by wsp 2015-12-23 用来判断序列号是否重复
	SetElement("TAInStockListDRz"+selectrow,list[11]);
	//alertShow(GetElementValue('TAInStockListDRz'+selectrow))
	SetElement("TStockDetailDRz"+selectrow,list[0]);
	SetElement("TItemDRz"+selectrow,list[9]);
	SetElement("TCodez"+selectrow,list[2]);
	SetElement("TDescz"+selectrow,list[1]);
	SetElement("TBaseUOMDRz"+selectrow,list[17]);
	SetElement("TBaseUOMz"+selectrow,list[18]);
	SetElement("TModelz"+selectrow,list[21]);
	SetElement("TPricez"+selectrow,list[14]);
	SetElement("THold5z"+selectrow,list[35]);		//库存数
	SetElement("TMoveNumz"+selectrow,list[35]);		//可转数量
	SetElement("TQuantityNumz"+selectrow,list[35]);		//201702-04	Mozy
	var TotalFee=list[14]*list[35];					//可转总值
	SetElement("TAmountz"+selectrow,TotalFee.toFixed(2));
	SetElement("TManuFactoryDRz"+selectrow,list[19]);
	SetElement("TManuFactoryz"+selectrow,list[20]);
	//qw0005-2014-06-09
	/*if (list[15]!="")	//无批号即为有序列号
	{
		SetElement("TSerialFlagz"+selectrow,1);
	}
	else
	{
		SetElement("TSerialFlagz"+selectrow,0);
	}
	if (list[12]!="")	//有批号
	{
		SetElement("TBatchFlagz"+selectrow,1);
	}
	else
	{
		SetElement("TBatchFlagz"+selectrow,0);
	}*/
	if (list[41]=="Y")	//有批号	//Modify DJ 2014-09-10
	{
		SetElement("TBatchFlagz"+selectrow,1);
		SetElement("TSerialFlagz"+selectrow,0);
	}
	else  //无批号即为有序列号
	{
		SetElement("TBatchFlagz"+selectrow,0);
		SetElement("TSerialFlagz"+selectrow,1);
	}
	
	if (GetElementValue("TotalFlag")!=0)
	{
		SumList_Change();
	}
}

function BSerialNoClick()
{
	selectrow=GetTableCurRow();
	if (true!=GetElementValue("TSerialFlagz"+selectrow))
	{
		alertShow("不是按序列号管理,无须选择序列号.");
		return;
	}
	var AListDR=GetElementValue("TRowIDz"+selectrow)
	//if (AListDR=="") return;
	var QuantityNum=GetElementValue("TQuantityNumz"+selectrow)
	if (QuantityNum=="") return;
	var StockDetailDR=GetElementValue("TStockDetailDRz"+selectrow)
	if (StockDetailDR=="") return;
	var lnk="websys.default.csp?WEBSYS.TCOMPONENT=DHCEQUpdateAccessoryByList";
	lnk=lnk+"&SourceID="+StockDetailDR;
	lnk=lnk+"&QuantityNum="+QuantityNum;
	lnk=lnk+"&Job="+GetElementValue("Job");
	lnk=lnk+"&index="+selectrow;
	lnk=lnk+"&MXRowID="+AListDR;
	lnk=lnk+"&StoreLocDR="+GetElementValue("FromLocDR");
	lnk=lnk+"&Status="+GetElementValue("Status");
	lnk=lnk+"&Type=1";
   	window.open(lnk,'_blank','toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width=890,height=650,left=120,top=0')
}

function ClickCheckBox()
{
	var Id=window.event.srcElement.id; //TSerialFlagz1   TBatchFlagz1 
	var offset=Id.lastIndexOf("z");
	var colName=Id.substring(0,offset);
	var index=Id.substring(offset+1);
	if (colName=="TSerialFlag")
	{
		var val=GetElementValue('TSerialFlagz'+index);
		SetElement("TBatchFlagz"+index,!val);
	}
	else if (colName=="TBatchFlag")
	{
		var val=GetElementValue('TBatchFlagz'+index);
		SetElement("TSerialFlagz"+index,!val);
	}
}

function BodyUnloadHandler()
{
	var Job=GetElementValue("Job");
  	var encmeth=GetElementValue("KillTEMPEQ");
  	if (encmeth=="") return;
	var rtn=cspRunServerMethod(encmeth,Job);
}
function GetAStockDetailNew(value)
{
	AddClickHandler();
	//TRowID,TLocDR,TAccessoryTypeDR,TItemDR,TAInStockListDR,TBaseUOMDR,TManuFactoryDR,TProviderDR,TStockDR,TInType,TInSourceID,TToType,TToSourceID,TOriginDR,TDesc,TCode,TLoc,TAccessoryType,TModel,TBprice,TManuFactory,TProvider,TStock,CanUseNum,FreezeNum,TInStockNo,TInDate,TStatus,THasStockFlag,TItem,TBatchNo,TExpiryDate,TSerialNo,TNo,TBaseUOM,TFreezeStock,TStartDate,TDisuseDate,TOrigin,TReturnFee,TTotalFee,TBatchFlag)
	//   0     1     		2      		3     		4        		5              6         7          8       9     	10        11          12        13       14    15   16     17         	18       19        20          21      22     23      	24      	25      26       27          28      29      30         31     	   32     33     34      	35          36		  37		38        39        40		  41
	list=value.split("^");
	//转移单为同一个入库单时只能做一条数据
	var Length=tableList.length
	//alertShow("Length="+Length);
	var currow=GetCElementValue("TRowz"+selectrow);
	for (var i=1;i<Length;i++)
	{
		if ((tableList[i]=="0")&&(list[4]==GetElementValue('TAInStockListDRz'+i))&&(list[0]==GetElementValue('TAStockDetailDRz'+i)))
		{
			var TRow=GetCElementValue("TRowz"+i);
			if (TRow==currow)
			{
				continue;
			}
			alertShow("当前选择行与明细中第"+(TRow)+"行重复,请直接修改数量")
			return;
		}
	}
	SetElement("TAStockDetailDRz"+selectrow,list[0]);  //判断序列号是否重复
	SetElement("TStockDetailDRz"+selectrow,list[0]);
	SetElement("TItemDRz"+selectrow,list[3]);
	SetElement("TAInStockListDRz"+selectrow,list[4]);
	SetElement("TBaseUOMDRz"+selectrow,list[5]);
	SetElement("TManuFactoryDRz"+selectrow,list[6]);
	SetElement("TDescz"+selectrow,list[14]);
	SetElement("TCodez"+selectrow,list[15]);
	SetElement("TModelz"+selectrow,list[18]);
	SetElement("TPricez"+selectrow,list[19]);
	SetElement("TManuFactoryz"+selectrow,list[20]);
	SetElement("TProviderz"+selectrow,list[43]);  //add by kdf 2018-01-31 需求号：542709
	SetElement("TBaseUOMz"+selectrow,list[34]);
	SetElement("THold5z"+selectrow,list[22]);		//库存数
	SetElement("TMoveNumz"+selectrow,list[23]);		//可转数量
	SetElement("TQuantityNumz"+selectrow,list[23]);
	//201702-04	Mozy
	var TotalFee=list[19]*list[23];					//可转总值
	SetElement("TAmountz"+selectrow,TotalFee.toFixed(2));
	/*if (list[32]!="")	//无批号即为有序列号
	{
		SetElement("TSerialFlagz"+selectrow,1);
	}
	else
	{
		SetElement("TSerialFlagz"+selectrow,0);
	}
	if (list[30]!="")	//有批号
	{
		SetElement("TBatchFlagz"+selectrow,1);
	}
	else
	{
		SetElement("TBatchFlagz"+selectrow,0);
	}*/
	if (list[41]=="Y")	//有批号
	{
		SetElement("TBatchFlagz"+selectrow,1);
		SetElement("TSerialFlagz"+selectrow,0);
	}
	else  //无批号即为有序列号
	{
		SetElement("TBatchFlagz"+selectrow,0);
		SetElement("TSerialFlagz"+selectrow,1);
	}
	
	if (GetElementValue("TotalFlag")!=0)
	{
		SumList_Change();
	}
	var obj=document.getElementById("TDescz"+selectrow);
	if (obj) websys_nextfocusElement(obj);	//焦点异常(跳至第2格)
}
