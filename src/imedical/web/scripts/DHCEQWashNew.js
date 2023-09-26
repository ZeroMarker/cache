var selectrow=0;
var opener=1;


///记录 设备 RowID?处理重复选择RowID的问题
var ObjSources=new Array();

//最后一行数据元素的名字的后缀序号
var LastNameIndex;
//新增一行数据元素的名字的后缀序号
var NewNameIndex;

function BodyLoadHandler() 
{	
	KeyUp("WashEquip^Washer^WashLoc","N");
	InitUserInfo();
	InitPage();	
	FillData();
	SetEnabled();
	InitEditFields(GetElementValue("ApproveSetDR"),GetElementValue("CurRole"));
	InitApproveButton();
	SetTableItem('','','');
	SetDisplay();

	SetFocus("WashEquip");
	Muilt_LookUp("WashEquip^Washer^WashLoc");

}

function SetEnabled()
{
	var Status=""//testvalue
	var Status=GetElementValue("Status");
	var WaitAD=GetElementValue("WaitAD");
	SetElement("ReadOnly",0);	//初始不为只读.Add By HZY 2012-01-31 HZY0021
	//状态为新增时,方可提交或删除
	//状态小于1时?方可增删改
	if (Status!="0")
	{
		DisableBElement("BDelete",true);
		DisableBElement("BSubmit",true);
		
		if (Status!="")
		{
			DisableBElement("BUpdate",true);
			DisableBElement("BAdd",true);
			DisableBElement("BClear",true);
			SetElement("ReadOnly",1);	//Add By HZY 2012-01-31 HZY0021
		}
	}
	//审核后才可打印及生成转移单
	if (Status!="2")
	{
		DisableBElement("BToMove",true);
		DisableBElement("BPrint",true);
		DisableBElement("BPrintBar",true);
	}
	//非建单据菜单,不可更新等操作单据
	if (WaitAD!="off")
	{
		DisableBElement("BUpdate",true);
		DisableBElement("BDelete",true);
		DisableBElement("BSubmit",true);
		DisableBElement("BAdd",true);
		DisableBElement("BClear",true);
		SetElement("ReadOnly",1);	//非建单据菜单,设为只读.Add By HZY 2012-01-31 HZY0021
	}
}

///filldata已修改20131226
function FillData()//填充信息
{
	var obj=document.getElementById("RowID");
	var RowID=obj.value;
	if ((RowID=="")||(RowID<1)){
		return;
	}
	var obj=document.getElementById("FillData");
	if (obj){var encmeth=obj.value} else {var encmeth=""};
	var ReturnList=cspRunServerMethod(encmeth,RowID);
	ReturnList=ReturnList.replace(/\\n/g,"\n");
	list=ReturnList.split("^");
	var sort=23;
	SetElement("WashNo",list[0]);
	SetElement("WashDate",list[1]);
	SetElement("WashTime",list[2]);
	SetElement("WasherDR",list[3]);
	SetElement("Washer",list[sort+0]);
	SetElement("WashEquipDR",list[4]);
	SetElement("WashEquip",list[sort+1]);
	SetElement("WashType",list[5]);
	SetElement("WashLocDR",list[6]);
	SetElement("WashLoc",list[sort+2]);
	SetElement("Status",list[7]);
	SetElement("UpdateUserDR",list[8]);
	SetElement("UpdateUser",list[sort+3]);
	SetElement("UpdateDate",list[9]);
	SetElement("UpdateTime",list[10]);
	SetElement("SubmitUserDR",list[10]);
	SetElement("SubmitUser",list[sort+4]);
	SetElement("SubmitDate",list[12]);
	SetElement("SubmitTime",list[13]);
	SetElement("AuditUserDR",list[14]);
	SetElement("AuditUser",list[sort+5]);
	SetElement("AuditDate",list[15]);
	SetElement("AuditTime",list[16]);

	SetElement("Hold1",list[17]);
	SetElement("Hold2",list[18]);
	SetElement("Hold3",list[19]);
	SetElement("Hold4",list[20]);
	SetElement("Hold5",list[21]);
	SetElement("InvalidFlag",list[22]);
	//AIRowID_"^"_ApproveSetDR_"^"_NextRoleDR_"^"_NextFlowStep_"^"_ApproveStatu_"^"_ApproveRoleDR_"^"_CancelFlag_"^"_CancelToFlowDR_"^"_ApproveRole_"^"_NextRole
	SetElement("ApproveSetDR",list[sort+7]);
	SetElement("NextRoleDR",list[sort+8]);
	SetElement("NextFlowStep",list[sort+9]);
	SetElement("ApproveStatu",list[sort+10]);
	SetElement("ApproveRoleDR",list[sort+11]);
	SetElement("CancelFlag",list[sort+12]);
	SetElement("CancelToFlowDR",list[sort+13]);
	

}

///已修改20131226
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
	var obj=document.getElementById("BPrintBar");
	if (obj) obj.onclick=DHCEQInStockPrintBar;
	if (opener)
	{
		var obj=document.getElementById("BClose");
		if (obj) obj.onclick=CloseWindow;
	}
	else
	{
		EQCommon_HiddenElement("BClose")	
	}
	var obj=document.getElementById("BAdd");
	if (obj) obj.onclick=AddClickHandler;
}

///已修改20131226
function BUpdate_Clicked()
{
	///20140311 qw增加
	if (CheckMustItemNull()) 
	{
		//alertShow("*不能为空!")
		return;
	}
	var combindata="";
  	combindata=GetElementValue("RowID") ;
  	combindata=combindata+"^"+GetElementValue("WashNo") ;
  	combindata=combindata+"^"+GetElementValue("WashDate") ;
  	combindata=combindata+"^"+GetElementValue("WashTime") ;
  	
  	combindata=combindata+"^"+GetElementValue("WasherDR") ;
  	
  	
  	combindata=combindata+"^"+GetElementValue("WashEquipDR") ;
  	combindata=combindata+"^"+GetElementValue("WashType") ;
  	combindata=combindata+"^"+GetElementValue("WashLocDR") ;
  	//combindata=combindata+"^"+GetElementValue("Status") ;
	combindata=combindata+"^"+curUserID;
  	
  	combindata=combindata+"^"+GetElementValue("Hold1");
  	combindata=combindata+"^"+GetElementValue("Hold2");
  	combindata=combindata+"^"+GetElementValue("Hold3");
  	combindata=combindata+"^"+GetElementValue("Hold4");
  	combindata=combindata+"^"+GetElementValue("Hold5");
  	var valList=GetTableInfo();
  	//alertShow(valList);
  	if (valList=="-1")  return;
  	var DelRowid=tableList.toString()
  	var encmeth=GetElementValue("Update")
  	if (encmeth=="") return;
	var Rtn=cspRunServerMethod(encmeth,combindata,valList,DelRowid);
	if (Rtn>0)
    {
	    window.location.href= 'websys.default.csp?WEBSYS.TCOMPONENT=DHCEQWashNew&RowID='+Rtn+"&WaitAD=off";
	}
    else
    {
	    ///Modified by JDL 2012-2-23 补充Mozy0076
	    alertShow(EQMsg(t["01"],Rtn));
    }
}
///已修改20131226
function BDelete_Clicked()
{
	var truthBeTold = window.confirm(t["-4003"]);
	if (!truthBeTold) return;
	var combindata=GetValueList();
  	var encmeth=GetElementValue("DeleteData")
  	if (encmeth=="") return;
	var Rtn=cspRunServerMethod(encmeth,combindata);
	if (Rtn=="0")
    {
		var WaitAD=GetElementValue("WaitAD");
		var QXType=GetElementValue("QXType");
		window.location.href= 'websys.default.csp?WEBSYS.TCOMPONENT=DHCEQWashNew&WaitAD='+WaitAD+"&QXType="+QXType;
	}
    else
    {
	    alertShow(t[Rtn]+"   "+t["01"]);
    }
}

function BSubmit_Clicked()//提交
{
	var combindata=GetValueList();
  	var valList=GetTableInfo();
  	if (valList=="")
  	{
	  	alertShow(t["-1003"])
	  	return;
	}
	///end by zy 2011-10-25 zy0083
  	var encmeth=GetElementValue("SubmitData")
  	if (encmeth=="") return;
	var Rtn=cspRunServerMethod(encmeth,combindata);
	if (Rtn>0)
    {
		var WaitAD=GetElementValue("WaitAD");
		window.location.href= 'websys.default.csp?WEBSYS.TCOMPONENT=DHCEQWashNew&RowID='+Rtn+"&WaitAD="+WaitAD;
	}
    else
    {
	    alertShow(t[Rtn]+"   "+t["01"]);
    }
}
function BCancelSubmit_Clicked() // 反提交
{
	var combindata=GetValueList();
  	var encmeth=GetElementValue("CancelSubmitData")
  	if (encmeth=="") return;
  	//Mozy0064	2011-10-24

  	//Modified by jdl 2011-3-2  JDL0071
	var Rtn=cspRunServerMethod(encmeth,combindata,GetElementValue("CurRole"));
    if (Rtn>0)
    {
	    window.location.href= 'websys.default.csp?WEBSYS.TCOMPONENT=DHCEQWashNew&RowID='+Rtn+"&QXType="+GetElementValue("QXType");
	}
    else
    {
	    alertShow(Rtn+"   "+t["01"]);
    }
}
/////////////////////////////////////////////////////////
function BApprove_Clicked()//审核
{
	
	var combindata=GetValueList();
	var CurRole=GetElementValue("CurRole");
	var ApproveSetDR=GetElementValue("ApproveSetDR");
  	if (CurRole=="") return;

	var RoleStep=GetElementValue("RoleStep");

  	if (RoleStep=="") return;
  	
  	var objtbl=document.getElementById('tDHCEQWashNew');
	var EditFieldsInfo=ApproveEditFieldsInfo(objtbl);
	if (EditFieldsInfo=="-1") return;
	///20140306:新增更新回送人及会送接收人
	var valList=GetTableInfo();
  	if (valList=="")
  	{
	  	alertShow(t["-1003"])
	  	return;
	}

  	
  	var encmeth=GetElementValue("AuditData")
  	if (encmeth=="") return;
	var Rtn=cspRunServerMethod(encmeth,combindata,valList,CurRole,RoleStep,EditFieldsInfo);
    if (Rtn>0)
    {

	    window.location.reload();
	}
    else
    {
	    alertShow(t["01"]);
    }
}
/////////////////////////////////////////////////////////

function BClear_Clicked()
{
	var QXType=GetElementValue("QXType");
	window.location.href= 'websys.default.csp?WEBSYS.TCOMPONENT=DHCEQWashNew&Type=0&QXType='+QXType+'&WaitAD=off';
}

function BPrint_Clicked()
{
	var id=GetElementValue("RowID");
	if (""!=id) PrintWash(id);
}

function PrintWash(Washid)
{
	PrintWashStandard(Washid);
	return;
}



///入库打印
function PrintWashStandard(Washid)
{
	if (Washid=="") return;
	var encmetha=GetElementValue("fillData");
	if (encmetha=="") return;
	var ReturnList=cspRunServerMethod(encmetha,Washid);
	ReturnList=ReturnList.replace(/\\n/g,"\n");
	var lista=ReturnList.split("^");
	var encmeth=GetElementValue("GetList");
	if (encmeth=="") return;
	var gbldata=cspRunServerMethod(encmeth,Washid);
	//alertShow(ReturnList);
	var list=gbldata.split("_");
	var Listall=list[0];
	rows=list[1];
	//rows=rows-1;
	var PageRows=10;
	var Pages=parseInt(rows / PageRows); //总页数?1  3为每页固定行数
	var ModRows=rows%PageRows; //最后一页行数
	if (ModRows==0) {Pages=Pages-1;}
	
	var encmeth=GetElementValue("GetRepPath");
	if (encmeth=="") return;
	var	TemplatePath=cspRunServerMethod(encmeth);
	//try {

        var xlApp,xlsheet,xlBook;
	    var Template=TemplatePath+"DHCEQWashSP.xls";
	    xlApp = new ActiveXObject("Excel.Application");
	    for (var i=0;i<=Pages;i++)
	    {
	    	xlBook = xlApp.Workbooks.Add(Template);
	    	xlsheet = xlBook.ActiveSheet;
	    	var sort=23;
	    	//医院名称替换 Add By DJ 2011-07-14
	    	//xlsheet.cells.replace("[Hospital]",GetElementValue("GetHospitalDesc"))
	    	xlsheet.cells(2,2)="入库单号:"+lista[0]; //入库单号
	    	xlsheet.cells(2,7)=lista[2]; //时间
	    	xlsheet.cells(2,10)=GetShortName(lista[sort+2],"-"); //洗涤科室
	    	xlsheet.cells(3,2)="洗涤人:"+GetShortName(lista[sort+0],"-");//洗涤人
	    	xlsheet.cells(3,7)=ChangeDateFormat(lista[1]);	//洗涤日期
	    	xlsheet.cells(3,9)="洗涤设备"+GetShortName(lista[sort+1],"-"); //洗涤设备
	    	
	   		var OnePageRow=PageRows;
	   		if ((i==Pages)&&(ModRows!=0)) OnePageRow=ModRows;
	    		
	    	var FeeAll=0;
	    	for (var j=1;j<=OnePageRow;j++)
			{
				var Lists=Listall.split(":");
				var Listl=Lists[i*PageRows+j];
				var List=Listl.split("^");
				var Row=4+j;
				xlsheet.cells(Row,2)=List[0];//设备项
				xlsheet.cells(Row,4)=List[1];//机型
				xlsheet.cells(Row,5)=List[2];//数量
				xlsheet.cells(Row,6)=List[3];//Loc
				xlsheet.cells(Row,7)=List[4];//LocSendUser
				xlsheet.cells(Row,8)=List[5];//ReturnUser
				xlsheet.cells(Row,9)=List[6];//ReceiveUser

				var Row=Row+1;
				
	    	}
	    	
	    	xlsheet.cells(15,10)="制单人:"+username; //制单人
	    	
	    	xlsheet.cells(16,10)="第"+(i+1)+"页 "+"共"+(Pages+1)+"页";
	    	
	    	var obj = new ActiveXObject("PaperSet.GetPrintInfo");
		    var size=obj.GetPaperInfo("DHCEQWash");
		    if (0!=size) xlsheet.PageSetup.PaperSize = size;
	    	
	    	xlsheet.printout; 	//打印输出

	    	xlBook.Close (savechanges=false);
	    	
	    	xlsheet.Quit;
	    	xlsheet=null;
	    }
	    xlApp=null;
}

///生成出库单,并转到该出库单
function BToMove()
{
	var obj=document.getElementById("BToMove");
	if ((!obj)||(obj.disabled)) return;
	var encmeth=GetElementValue("GetToMove");
	var RowID=GetElementValue("RowID");
	if ((RowID=="")||(encmeth=="")) return;
	var StoreMoveID=cspRunServerMethod(encmeth,RowID,Guser);
	if (StoreMoveID<1)
	{
		alertShow(t["05"]);
	}
	else
	{
		window.location.href= 'websys.default.csp?WEBSYS.TCOMPONENT=DHCEQWashFind&RowID='+StoreMoveID+"&WaitAD=off";
	}
}

function GetTableInfo()
{
    var objtbl=document.getElementById('tDHCEQWashNew');
	var rows=tableList.length
	var valList="";
	for(var i=1;i<rows;i++)
	{
		if (tableList[i]=="0")
		{
			var TRow=GetCElementValue("TRowz"+i);
			var TRowID=GetElementValue("TRowIDz"+i);
			var TMasterItemDR=GetElementValue("TMasterItemDRz"+i);				
			var TModelDR=GetModelRowID(GetElementValue("GetModelOperMethod"),i)
			var TQuantityNum=GetElementValue("TQuantityNumz"+i);
			var TLocDR=GetElementValue("TLocDRz"+i);
			var TLocSendUserDR=GetElementValue("TLocSendUserDRz"+i);
			var TReturnUserDR=GetElementValue("TReturnUserDRz"+i);
			var TReceiveUserDR=GetElementValue("TReceiveUserDRz"+i);

			if ((TQuantityNum=="")||(parseInt(TQuantityNum)<=0))
			{
				alertShow("第"+TRow+"行数量不正确!");
				SetFocusColumn("TQuantityNum",i)
				return "-1";
			}
			//Modified by JDL 2011-12-15  JDL0105 数量不能为小数
			if (parseInt(TQuantityNum)!=TQuantityNum)
			{
				alertShow("第"+TRow+"行数量不正确,不能为小数!");
				SetFocusColumn("TQuantityNum",i)
				return "-1";
			}
				
			var THold1=GetElementValue("THold1z"+i);
			var THold2=GetElementValue("THold2z"+i);
			var THold3=GetElementValue("THold3z"+i);
			var THold4=GetElementValue("THold4z"+i);
			var THold5=GetElementValue("THold5z"+i);
			
			if(valList!="") {valList=valList+"&";}
					
			valList=valList+TRow+"^"+TRowID+"^"+TMasterItemDR+"^"+TModelDR+"^"+TQuantityNum+"^"+TLocDR+"^"+TLocSendUserDR+"^"+TReturnUserDR+"^"+TReceiveUserDR;
			valList=valList+"^"+THold1+"^"+THold2+"^"+THold3+"^"+THold4+"^"+THold5;

		}
	}
	return  valList
}

//获取审核信息
function GetValueList()
{
	var ValueList="";
	ValueList=GetElementValue("RowID");
	//ValueList=ValueList+"^"+GetElementValue("RejectReasonDR");
	ValueList=ValueList+"^"+curUserID;
	ValueList=ValueList+"^"+GetElementValue("Remark");
	//ValueList=ValueList+"^"+GetElementValue("StatCatDR");
	//ValueList=ValueList+"^"+GetElementValue("EquipTypeDR");
	ValueList=ValueList+"^"+GetElementValue("CancelToFlowDR");
	ValueList=ValueList+"^"+GetElementValue("ApproveSetDR");
	return ValueList;
}

function GetWasher (value)//2014-05-23 qw lookup 可以自己写
{
    //GetLookUpID("WasherDR",value);
    var val=value.split("^");
	var obj=document.getElementById("WasherDR");
	if (obj)	
	{	obj.value=val[6];
	    var Washer=document.getElementById("Washer");
	    Washer.value=val[2];
	}
	else {alertShow(ename);}
}
function GetWashLoc (value)
{
    GetLookUpID("WashLocDR",value);
}
function GetWashEquip (value)
{
    var val=value.split("^");
    SetElement("WashEquipDR",val[0])
    SetElement("WashEquip",val[1])
}
function GetRejectReason (value)
{
    GetLookUpID("RejectReasonDR",value);
}

///已修改20131226,最后一次循环rowid如何为-1
function SetTableItem(RowNo,selectrow)
{
	var objtbl=document.getElementById('tDHCEQWashNew');
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
			ChangeRowStyle(objtbl.rows[i]);		///改变一行的内容显示
		}
	}
	else
	{
		if (selectrow=='') selectrow=RowNo
		tableList[RowNo]=0;
		ChangeRowStyle(objtbl.rows[selectrow]);		///改变一行的内容显示
	}
}

function SetDisplay()
{
	//ReadOnlyElements("TReturnUser",true);
	ReadOnlyElements("WashNo",true)
}


function SetElementEnabled()
{
	var Status=GetElementValue("Status");
	alertShow(Status);

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

//20140416 qw 003
///改变一行的内容显示
function ChangeRowStyle(RowObj)
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
		if (colName=="TMasterItem")
		{
			if (CheckUnEditField(Status,colName)) continue;
			value=document.getElementById(Id).innerText;	
			html=CreatElementHtml(2,Id,objwidth,objheight,"LookUpMasterItemNew","","","")	//Old
		}
		else if (colName=="TLoc")
		{
			if (CheckUnEditField(Status,colName)) continue;
			value=document.getElementById(Id).innerText;
         	html=CreatElementHtml(2,Id,objwidth,objheight,"LookUpLocNew","","","")
		}
		else if (colName=="TLocSendUser")
		{
			if (CheckUnEditField(Status,colName)) continue;
			value=document.getElementById(Id).innerText;
			html=CreatElementHtml(2,Id,objwidth,objheight,"LookUpLocSendUserNew","","","")
		}
		else if (colName=="TReturnUser")
		{
			//2014-05-23 qw
			if (CheckUnEditField(Status,colName)) continue;
			value=document.getElementById(Id).innerText;
			html=CreatElementHtml(2,Id,objwidth,objheight,"LookUpReturnUserNew","","","")
		}
		else if (colName=="TModel")
		{
			if (CheckUnEditField(Status,colName)) continue;
			value=document.getElementById(Id).innerText;
         	html=CreatElementHtml(2,Id,objwidth,objheight,"LookUpModelNew","","","")		
		}
		else if (colName=="TReceiveUser")
		{
			//2014-05-23 qw
			if (CheckUnEditField(Status,colName)) continue;
			value=document.getElementById(Id).innerText;
         	html=CreatElementHtml(2,Id,objwidth,objheight,"LookUpReceiveUserNew","","","")
		
		}
	
		else if (colName=="TQuantityNum")
		{
			if (CheckUnEditField(Status,colName)) continue;
			value=document.getElementById(Id).innerText;
         	html=CreatElementHtml(1,Id,objwidth,objheight,"KeyDown_Tab","","","")	
			
			//数量
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

function LookUpMasterItemNew(vClickEventFlag)
{

	selectrow=GetTableCurRow();	
	if (GetElementValue("TLocz"+selectrow)=="")
	{
		alertShow("科室不能为空!")
		return;
	}
	if (event.keyCode==13||event.keyCode==0||vClickEventFlag==1)
	{
		//20140416 qw003
		LookUpMasterItembyLoc("GetMasterItem",",TLocDRz"+selectrow);
		//LookUpMasterItembyLoc("GetMasterItem",",,,TMasterItemz"+selectrow);
	}
}
//2014-03-10QW引用rent中函数
/*function LookUpMasterItemNew()
{
	selectrow=GetTableCurRow();
	if (event.keyCode==13||event.keyCode==0)
	{
		LookUpCTEquipByItem("GetMasterItem","TMasterItemz"+selectrow+"TLocDRz"+selectrow);
	}
}*/

function GetMasterItem(value)
{
	
	var list=value.split("^")
	SetElement('TMasterItemz'+selectrow,list[0]);
	SetElement('TMasterItemDRz'+selectrow,list[1]);
	var obj=document.getElementById("TMasterItemz"+selectrow);
	if (obj) websys_nextfocusElement(obj);
}
//20140416 qw003
function LookUpMasterItembyLoc(jsfunction,paras)
{
	LookUp("","web.DHCEQWashNew:GetMasterItemByLoc",jsfunction,paras);
}

function LookUpReceiveUserNew(vClickEventFlag)
{
	selectrow=GetTableCurRow();
	if (event.keyCode==13||event.keyCode==0||vClickEventFlag==1)
	{
		LookUpUser("GetReceiveUser","");  //2014-05-23 qw
	}
}

function GetReceiveUser(value)
{
	var list=value.split("^")
	SetElement('TReceiveUserz'+selectrow,list[2]);
	SetElement('TReceiveUserDRz'+selectrow,list[6]);
	var obj=document.getElementById("TReceiveUserz"+selectrow);
	if (obj) websys_nextfocusElement(obj);
}

function LookUpLocNew(vClickEventFlag)
{
	selectrow=GetTableCurRow();
	if (event.keyCode==13||event.keyCode==0||vClickEventFlag==1)
	{
		LookUpCTLoc("GetLoc",",TLocz"+selectrow);//DHCEQLookUp.js
	}
}

function GetLoc(value)
{
	var list=value.split("^")
	SetElement('TLocz'+selectrow,list[0]);
	SetElement('TLocDRz'+selectrow,list[1]);
	var obj=document.getElementById("TLocz"+selectrow);
	if (obj) websys_nextfocusElement(obj);
}

function LookUpReturnUserNew(vClickEventFlag)
{
	selectrow=GetTableCurRow();
	if (event.keyCode==13||event.keyCode==0||vClickEventFlag==1)
	{
		LookUpUser("GetReturnUser",""); //2014-05-23 qw
	}
}

function GetReturnUser(value)
{
	var list=value.split("^")
	SetElement('TReturnUserz'+selectrow,list[2]);
	SetElement('TReturnUserDRz'+selectrow,list[6]);
	var obj=document.getElementById("TReturnUserz"+selectrow);
	if (obj) websys_nextfocusElement(obj);
}

function LookUpLocSendUserNew(vClickEventFlag)
{
	selectrow=GetTableCurRow();
	if (event.keyCode==13||event.keyCode==0||vClickEventFlag==1)
	{
		LookUpUser("GetLocSendUser","");//2014-05-23 qw
	}
}

function GetLocSendUser(value)
{
	
	var list=value.split("^")
	SetElement('TLocSendUserz'+selectrow,list[2]);
	SetElement('TLocSendUserDRz'+selectrow,list[6]);
	var obj=document.getElementById("TLocSendUserz"+selectrow);
	if (obj) websys_nextfocusElement(obj);
}

function LookUpUser(jsfunction,paras) //2014-05-23 qw
{
	LookUp("","web.DHCEQCTypeEmployee:TypeEmployee",jsfunction,paras);
}
///OK
function DeleteClickHandler() {
	var truthBeTold = window.confirm(t["-4003"]);
	if (!truthBeTold) return;
	try
	{
		var objtbl=document.getElementById('tDHCEQWashNew');
		var rows=objtbl.rows.length;
		selectrow=GetTableCurRow();
		var TotalFlag=GetElementValue("TotalFlag")
		alertShow(TotalFlag);
		var TRowID=GetElementValue('TRowIDz'+selectrow);
		tableList[selectrow]=TRowID;
		
		var delNo=GetElementValue("TRowz"+selectrow);
	
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
			alertShow("clear");
			Clear();			 
		} 
		else
		{
	    	var eSrc=window.event.srcElement;
			var rowObj=getRow(eSrc);
			objtbl.deleteRow(rowObj.rowIndex);
		}
		ResetNo(selectrow,delNo);
	    //SumList_Change();
	} 
	catch(e) 
	{};
}
//清空tableitem即设置为空
function Clear()
{
	SetElement('TMasterItemz'+selectrow,"");
	SetElement('TMasterItemDRz'+selectrow,"");
	SetElement('TModelz'+selectrow,"");
	SetElement('TModelDRz'+selectrow,"");
	SetElement('TQuantityNumz'+selectrow,"");
	SetElement('TLocDRz'+selectrow,"");
	SetElement('TLocz'+selectrow,"");
	SetElement('TLocSendUserDRz'+selectrow,"");
	SetElement('TLocSendUserz'+selectrow,"");
	SetElement('TReturnUserz'+selectrow,"");
	SetElement('TReturnUserDRz'+selectrow,"");
	SetElement('TReceiveUserz'+selectrow,"");
	SetElement('TReceiveUserDRz'+selectrow,"");
}
//小添加按钮的事件响应
function AddClickHandler() {
	try 
	{
		var objtbl=document.getElementById('tDHCEQWashNew');
		var ret=CanAddRow(objtbl);
		if (ret)
		{
			NewNameIndex=tableList.length;
	    	AddRowToList(objtbl,LastNameIndex,NewNameIndex);
	    }
        return false;
	} 
	catch(e) 
	{};
}

//判断增加一行的可行性
function CanAddRow(objtbl)
{
	var rows=objtbl.rows.length;
    if (rows==1) return false;
	var TotalFlag=GetElementValue("TotalFlag")
	if (TotalFlag==2) rows=rows-1
	LastNameIndex=GetRowIndex(objtbl.rows[rows-1]);
	var TMasterItem=document.getElementById('TMasterItemz'+LastNameIndex).value
	if  (GetElementValue('TMasterItemz'+LastNameIndex)=="")
	{
		SetFocusColumn("TMasterItem",LastNameIndex);
		alertShow("设备名称未填写");//qw003 20140416
		return false;
	}
	if  (GetElementValue('TModelz'+LastNameIndex)=="")
	{
		SetFocusColumn("TModel",LastNameIndex);
		alertShow("未填写规格");
	 	return false;
	}
	return true;
}

document.body.onload = BodyLoadHandler;