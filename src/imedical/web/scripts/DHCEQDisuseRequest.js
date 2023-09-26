var SelectedRow = 0;
var rowid=0;

function BodyLoadHandler() 
{
	InitPage();
	SetData(GetElementValue("RowID"),GetElementValue("EquipDR"));
	InitStyle("RequestNo","5");	
	SetEnable();
	InitData();
	if (1==GetElementValue("ReadOnly"))
	{
		DisableBElement("BAdd",true);
		DisableBElement("BUpdate",true);
		DisableBElement("BDelete",true);
		DisableBElement("BAudit",true);
		DisableBElement("BSubmit",true);
		DisableBElement("BCancelSubmit",true);
	}
}

function InitData()
{
	SetEquipInfo();
	SetDefaultValue("RequestDate",GetElementValue("GetCurDate"));
	SetDefaultValue("DisureDate",GetElementValue("GetCurDate"));
}

function SetEnable()
{
	var reqenable,adtenable;
	if (GetElementValue("DType")==1){
		 reqenable=false;
		 adtenable=true;
		}
	else{
		 reqenable=true;
		 adtenable=false;
		}
	if (GetElementValue("Status")==""||GetElementValue("Status")=="0"){
		reqenable=reqenable||false;
		adtenable=true;
		}
	else if (GetElementValue("Status")==1){
		reqenable=true;
		adtenable=adtenable||false;
		}
	else{
		reqenable=true;
		adtenable=true;
		}
	DisableElement("StatusDisplay",true);
		
	DisableElement("Equip",reqenable);	
	DisableElement("Group",reqenable);
	DisableElement("RequestNo",true);
	DisableLookup("RequestLoc",reqenable);
	DisableLookup("RequestDate",reqenable);
	DisableElement("UseState",reqenable);
	DisableElement("ChangeReason",reqenable);
	DisableElement("Remark",reqenable);
	DisableBElement("BUpdate",reqenable);
	DisableBElement("BDelete",reqenable);
	DisableBElement("BSubmit",reqenable);	
	
	DisableLookup("DisuseType",reqenable);
	DisableLookup("DisureDate",adtenable);	
	DisableBElement("BAudit",adtenable);
	DisableBElement("BCancelSubmit",adtenable);
	
	var Type=GetElementValue("Type")
	var RoleStep=GetElementValue("RoleStep")
	var NextStep=GetElementValue("NextFlowStep")
	if (Type=="1")
	{
		var RoleStep=GetElementValue("RoleStep")
		if (RoleStep!=NextStep)
		{
			DisableBElement("BCancelSubmit",true);
			DisableBElement("BAudit",true);
		}
	}
	if (Type=="2")
	{
		if (NextStep!="")
		{
			DisableBElement("BCancelSubmit",true);
			DisableBElement("BAudit",true);
		}
	}
}

function InitPage()
{
	InitUserInfo();
	InitStandardKeyUp();	
	InitButton(false);	
}

function InitButton(isselected)
{
	
	var obj=document.getElementById("BUpdate");
	if (obj) obj.onclick=BUpdate_Click;
	var obj=document.getElementById("BAdd");
	if (obj) obj.onclick=BAdd_Click;
	var obj=document.getElementById("BDelete");
	if (obj) obj.onclick=BDelete_Click;
	var obj=document.getElementById("BAudit");
	if (obj) obj.onclick=BAudit_Click;
	
	var obj=document.getElementById("BSubmit");
	if (obj) obj.onclick=BSubmit_Click;
	var obj=document.getElementById("BCancelSubmit");
	if (obj) obj.onclick=BCancelSubmit_Click;
	
	
	var obj=document.getElementById("BPrint");
	if (obj) obj.onclick=BPrint_Click;
	//DisableBElement("BAdd",isselected);
	//DisableBElement("BUpdate",!isselected);
	//DisableBElement("BDelete",!isselected);
	//DisableBElement("BAudit",!isselected);
}

function BAudit_Click()
{
	AuditData();
}

function BSubmit_Click()
{
	SubmitData("",0);
}

function BCancelSubmit_Click()
{
	if (CheckItemNull(2,"RejectReason")) return;
	var RejectReason=GetElementValue("RejectReason");
	SubmitData(RejectReason,1);
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
		alertShow(t[-4002]);
		return;
	}
	var truthBeTold = window.confirm(t[-4003]);
    if (!truthBeTold) return;
	var encmeth=GetElementValue("GetUpdate");
	if (encmeth=="")
	{
		alertShow(t[-4001]);
		return;
	}
	var result=cspRunServerMethod(encmeth,'','',rowid,Guser,'1');
	if (result<0)
	{	alertShow(t[result]);}
	else
	{	Clear();
		//location.reload();
	}
}

function CombinData()
{
	var combindata="";
  	combindata=GetElementValue("RowID") ;
  	combindata=combindata+"^"+GetElementValue("EquipDR") ;
  	combindata=combindata+"^"+GetElementValue("GroupDR") ;
  	combindata=combindata+"^"+GetElementValue("RequestLocDR") ;
  	combindata=combindata+"^"+GetElementValue("RequestDate") ;
  	combindata=combindata+"^"+GetElementValue("UseState") ;
  	combindata=combindata+"^"+GetElementValue("DisuseTypeDR") ;
  	combindata=combindata+"^"+GetElementValue("ChangeReason") ;
  	combindata=combindata+"^"+GetElementValue("DisureDate") ;
  	combindata=combindata+"^"+GetElementValue("Remark") ;
  	//begin 11 to 33
  	for (var j=11;j<34;j++)
	{
		combindata=combindata+"^"
	}
  	combindata=combindata+"^"+GetElementValue("RequestNo") ;
  	return combindata;
}

function AuditData()
{
	var rowid=GetElementValue("RowID");
	if (rowid=="") 
		{alertShow(t['04']);
		 return;	}
	var Type=GetElementValue("Type");
	if (Type=="2")
	{
		var encmeth=GetElementValue("GetAudit");
		if (encmeth=="")
		{
			alertShow(t[-4001]);
			return;
		}
	
		var result=cspRunServerMethod(encmeth,'','',rowid,Guser,GetElementValue("ChangeTypeDR"));
	}
	
	
	if (Type=="1")
	{
		var encmeth=GetElementValue("GetAuditSP");
		if (encmeth=="")
		{
			alertShow(t[-4001]);
			return;
		}
		if (CheckAuditNull()) return;
		var val=GetOpinion();
		var result=cspRunServerMethod(encmeth,rowid+"^"+val,GetElementValue("ChangeTypeDR"))
	}
	if (result<0)
	{	alertShow(t[result]);}
	else
	{	location.reload();	}
}
function CheckAuditNull()
{
	var ApproveRole=GetElementValue("CurRole");
	var CurStep=GetElementValue("RoleStep");
	if (CheckItemNull(2,"Opinion_"+ApproveRole+"_"+CurStep)) return true;
	return false
}
function GetOpinion()
{
	var ApproveRole=GetElementValue("CurRole");
	var CurStep=GetElementValue("RoleStep");
	var combindata=""
	combindata=combindata+GetElementValue("CurRole") ;
  	combindata=combindata+"^"+GetElementValue("RoleStep") ;
  	combindata=combindata+"^"+GetElementValue("Opinion_"+ApproveRole+"_"+CurStep) ;
  	combindata=combindata+"^"+GetElementValue("OpinionRemark") ;
  	return combindata;
}
function SubmitData(RejectReason,iscancel)
{
	var encmeth=GetElementValue("GetSubmit");
	if (encmeth=="")
	{
		alertShow(t[-4001]);
		return;
	}
	var rowid=GetElementValue("RowID");
	if (rowid=="") 
		{alertShow(t[-4002]);
		 retrun;	}	
	var result=cspRunServerMethod(encmeth,'','',rowid,Guser,iscancel,GetElementValue("ChangeTypeDR"),RejectReason);
	if (result<0)
	{	alertShow(t[result]);}
	else
	{	location.reload();	}
}

function SaveData()
{
	if (CheckSaveData()) return;
	var encmeth=GetElementValue("GetUpdate");
	if (encmeth=="")
	{
		alertShow(t[-4001]);
		return;
	}
	var plist=CombinData();
	var result=cspRunServerMethod(encmeth,'','',plist,Guser,'0');
	var Type=GetElementValue("Type");
	if (result>0)
	{
		if ("DHCEQDisuseRequestNew"!=GetElementValue("ComponentName"))
		{	window.location.href = "websys.default.csp?WEBSYS.TCOMPONENT=DHCEQDisuseRequest&ChangeTypeDR=6&EquipDR="+GetElementValue("EquipDR")+"&DType="+GetElementValue("DType")+"&Type="+GetElementValue("Type")+"&ApproveSetDR="+GetElementValue("ApproveSetDR")+"&ReadOnly="+GetElementValue("ReadOnly")+"&QXType="+GetElementValue("QXType")}
		else
		{	parent.DHCEQDisuseRequestListAdd.location.href="websys.default.csp?WEBSYS.TCOMPONENT=DHCEQDisuseRequestListAdd&Type="+Type+"&DisuseRequestDR="+result+"&RequestLocDR="+GetElementValue("RequestLocDR");
			parent.DHCEQDisuseRequestList.location.href="websys.default.csp?WEBSYS.TCOMPONENT=DHCEQDisuseRequestList&Type="+Type+"&DisuseRequestDR="+result+"&RequestLocDR="+GetElementValue("RequestLocDR");
			window.location.href = "websys.default.csp?WEBSYS.TCOMPONENT=DHCEQDisuseRequestNew&ChangeTypeDR=6&EquipDR="+GetElementValue("EquipDR")+"&DType="+GetElementValue("DType")+"&Type="+GetElementValue("Type")+"&ApproveSetDR="+GetElementValue("ApproveSetDR")+"&ReadOnly="+GetElementValue("ReadOnly")+"&QXType="+GetElementValue("QXType")+"&RowID="+result}
		//location.reload();	
	}
	else
	{	alertShow(t[result]);}
}

function SetData(rowid,equipdr)
{
	///alertShow(rowid+"&"+equipdr);
	if (equipdr==""&&rowid=="") return;
	var encmeth=GetElementValue("GetData");
	if (encmeth=="")
	{
		alertShow(t[-4001]);
		return;
	}
	var gbldata=cspRunServerMethod(encmeth,'','',rowid,equipdr);
	if (gbldata=="") return;
	gbldata=gbldata.replace(/\\n/g,"\n");
	var list=gbldata.split("^");
	var sort=49
	SetElement("EquipDR",list[0]);
	SetElement("Equip",list[sort+0]);
	SetElement("GroupDR",list[1]);
	SetElement("Group",list[sort+1]);
	SetElement("RequestLocDR",list[2]);
	SetElement("RequestLoc",list[sort+2]);
	SetElement("RequestDate",list[3]);
	SetElement("UseState",list[4]);
	SetElement("DisuseTypeDR",list[5]);
	SetElement("DisuseType",list[sort+3]);
	SetElement("ChangeReason",list[6]);
	SetElement("DisureDate",list[7]);
	SetElement("Remark",list[8]);
	SetElement("Status",list[9]);
	SetElement("AddUserDR",list[10]);
	SetElement("AddUser",list[sort+4]);
	SetElement("AddDate",list[11]);
	SetElement("AddTime",list[12]);
	SetElement("UpdateUserDR",list[13]);
	SetElement("UpdateUser",list[sort+5]);
	SetElement("UpdateDate",list[14]);
	SetElement("UpdateTime",list[15]);
	SetElement("SubmitUserDR",list[16]);
	SetElement("SubmitUser",list[sort+6]);
	SetElement("SubmitDate",list[17]);
	SetElement("SubmitTime",list[18]);
	SetElement("AuditUserDR",list[19]);
	SetElement("AuditUser",list[sort+7]);
	SetElement("AuditDate",list[20]);
	SetElement("AuditTime",list[21]);
	SetElement("RejectReason",list[22]);
	SetElement("RejectUserDR",list[23]);
	SetElement("RejectUser",list[sort+8]);
	SetElement("RejectDate",list[24]);
	SetElement("RejectTime",list[25]);
	SetElement("ApproveSetDR",list[26]);
	SetElement("ApproveSet",list[sort+9]);
	SetElement("NextRoleDR",list[27]);
	SetElement("NextRole",list[sort+10]);
	SetElement("NextFlowStep",list[28]);
	SetElement("ApproveStatu",list[29]);
	SetElement("ApproveRoleDR",list[30]);
	SetElement("ApproveRole",list[sort+11]);
	SetElement("Hold1",list[31]);
	SetElement("RequestNo",list[32]);
	SetElement("RowID",list[sort+12]);
}

function InitStandardKeyUp()
{
	KeyUp("Equip^Group^RequestLoc^DisuseType","N");
	Muilt_LookUp("Equip^Group^RequestLoc^DisuseType");
	return
	
	var obj=document.getElementById("Equip");
	if (obj) obj.onkeyup=Standard_KeyUp;
	var obj=document.getElementById("Group");
	if (obj) obj.onkeyup=Standard_KeyUp;
	var obj=document.getElementById("RequestLoc");
	if (obj) obj.onkeyup=Standard_KeyUp;
	var obj=document.getElementById("DisuseType");
	if (obj) obj.onkeyup=Standard_KeyUp;
	var obj=document.getElementById("AddUser");
	if (obj) obj.onkeyup=Standard_KeyUp;
	var obj=document.getElementById("UpdateUser");
	if (obj) obj.onkeyup=Standard_KeyUp;
	var obj=document.getElementById("SubmitUser");
	if (obj) obj.onkeyup=Standard_KeyUp;
	var obj=document.getElementById("AuditUser");
	if (obj) obj.onkeyup=Standard_KeyUp;
	var obj=document.getElementById("Sign1");
	if (obj) obj.onkeyup=Standard_KeyUp;
	var obj=document.getElementById("Sign2");
	if (obj) obj.onkeyup=Standard_KeyUp;
	var obj=document.getElementById("Sign3");
	if (obj) obj.onkeyup=Standard_KeyUp;
	var obj=document.getElementById("Sign4");
	if (obj) obj.onkeyup=Standard_KeyUp;
	var obj=document.getElementById("Sign5");
	if (obj) obj.onkeyup=Standard_KeyUp;
}

function Clear()
{
	SetElement("RowID","");
	SetElement("Equip","");
	SetElement("EquipDR","");
	SetElement("Group","");
	SetElement("GroupDR","");
	SetElement("RequestLoc","");
	SetElement("RequestLocDR","");
	SetElement("RequestDate","");
	SetElement("UseState","");
	SetElement("DisuseType","");
	SetElement("DisuseTypeDR","");
	SetElement("ChangeReason","");
	SetElement("DisureDate","");
	SetElement("Remark","");
	SetElement("Status","");
	SetElement("AddUser","");
	SetElement("AddUserDR","");
	SetElement("AddDate","");
	SetElement("AddTime","");
	SetElement("UpdateUser","");
	SetElement("UpdateUserDR","");
	SetElement("UpdateDate","");
	SetElement("UpdateTime","");
	SetElement("SubmitUser","");
	SetElement("SubmitUserDR","");
	SetElement("SubmitDate","");
	SetElement("SubmitTime","");
	SetElement("AuditUser","");
	SetElement("AuditUserDR","");
	SetElement("AuditDate","");
	SetElement("AuditTime","");
}


function CheckSaveData()
{
	if (CheckMustItemNull()) return true;
	//if (CheckRequired("RequestLocDR,EquipDR,DisuseTypeDR,RequestDate,UseState,ChangeReason")==false) return false
	return false;
}

function SetEquipDR(value)
{
	var obj=document.getElementById("EquipDR");
	var val=value.split("^");	
	if (obj) obj.value=val[1];
	parent.frames["DHCEQBanner"].location.href='websys.default.csp?WEBSYS.TCOMPONENT=DHCEQBanner&RowIDB='+val[1];
	SetEquipInfo();	
}

function SetEquipInfo()
{
	var equipid=GetElementValue("EquipDR");
	if (equipid=="") return;
	var encmeth=GetElementValue("GetEquip");
	if (encmeth=="")	{
		alertShow(t[-4001]);
		return;
	}
	var gbldata=cspRunServerMethod(encmeth,'','',equipid);
	var list=gbldata.split("^");
	var sort=EquipGlobalLen;
	
	SetElement("Equip",list[0]);
	SetDefaultValue("RequestLoc",list[sort+7]);
	SetDefaultValue("RequestLocDR",list[18]);
}

function GetRequestLocID(value)
{
	GetLookUpID('RequestLocDR',value);
}

function GetDisuseTypeID(value)
{
	GetLookUpID('DisuseTypeDR',value);
}

///判断元素串?以DR为结尾的元素作为指向型来判断
function CheckRequired(objnames)
{
	var objlist=objnames.split(",")
	var objname,obj
	var i=objlist.length;
	for (var j=0;j<i;j++)
	{
		objname=objlist[j];
		var last= objname.lastIndexOf("DR");
		///is refrence
		if ((last>0)&&((objname.length-2)==last))
		{
			obj=document.getElementById("c"+objname.substring(0,last));
			if (obj&&(obj.className=="clsRequired"))
			{
				if (GetElementValue(objname)==""||GetElementValue(objname.substring(0,last))=="")
				{
					alertShow(obj.innerText+t[-4005]);
					return false;
				}				
			}
		}
		else
		{
			obj=document.getElementById("c"+objname);
			if (obj&&(obj.className=="clsRequired"))
			{
				if (GetElementValue(objname)=="")
				{
					alertShow(obj.innerText+t[-4005]);
					return false;
				}				
			}
		}
	}
	return true;
}

///打印报废单
function PrintDisuse(disuseid,equipdr)
{
	if (disuseid=="") return;
	var encmeth=GetElementValue("GetData");	
	if (encmeth=="") return;
	var RequestData=cspRunServerMethod(encmeth,'','',disuseid,equipdr);
	RequestData=RequestData.replace(/\\n/g,"\n");
	var lista=RequestData.split("^");
	encmeth=GetElementValue("GetList");
	if (encmeth=="") return;
	var RequestListData=cspRunServerMethod(encmeth,disuseid);
	var RLList=RequestListData.split("^");
	var rows=RLList.length;
	//if (rows>0) rows=rows+1;
	var sumFee=0;
	var sumQty=0;
	
	encmeth=GetElementValue("GetOneListData");
	
	var PageRows=4;//每页固定行数
	var Pages=parseInt(rows / PageRows); //总页数-1  
	var ModRows=rows%PageRows; //最后一页行数
	if (ModRows==0) {Pages=Pages-1;}
	var sort;
	var	TemplatePath=GetElementValue("GetRepPath");
	
	try {
        var xlApp,xlsheet,xlBook;
	    var Template=TemplatePath+"DHCEQDisuse.xls";
	    xlApp = new ActiveXObject("Excel.Application");
	    for (var i=0;i<=Pages;i++)
	    {
		    xlBook = xlApp.Workbooks.Add(Template);
	    	xlsheet = xlBook.ActiveSheet;
	    	//xlsheet.PageSetup.LeftMargin=0;  //lgl+
	    	//xlsheet.PageSetup.RightMargin=0;
	    	xlsheet.PageSetup.TopMargin=0;
	    	sort=49;	    	
	    	xlsheet.cells(3,1)="报废单号:"+lista[32];  //凭单号
	    	xlsheet.cells(3,8)=GetShortName(lista[sort+2],"-");// 使用科室
	    	xlsheet.cells(3,4)=ChangeDateFormat(lista[3]);// 日期
	    	
	    	var OnePageRow=0;
	    	if (ModRows==0)
	    	{
		    	OnePageRow=PageRows;
	    	}
	    	else
	    	{
	    		if (i==Pages)
	    		{
		    		OnePageRow=ModRows;
	    		}
		    	else
		    	{
			    	OnePageRow=PageRows;
		    	}
	    	}
	    	var ss=5+(+OnePageRow);
			sort=13;
			for (var Row=1;Row<=OnePageRow;Row++)
			{
				var Location=i*PageRows+Row-1;
				/*if (Location==rows-1)
				{
					//xlsheet.Rows(Row+4).Insert();
					//xlsheet.cells(Row+4,1)="合计";//设备名称
					//xlsheet.cells(Row+4,4)=sumQty;//数量
					//xlsheet.cells(Row+4,4)=sumFee;//总价					
				}
				else
				{*/
				var RLID=RLList[Location];
				var Data=cspRunServerMethod(encmeth,'','',RLID);
				var List=Data.split("^");
				xlsheet.Rows(Row+4).Insert();
				xlsheet.cells(Row+4,1)=List[sort+2];//设备编号
				xlsheet.cells(Row+4,2)=List[sort+1];//设备名称
				xlsheet.cells(Row+4,3)=List[sort+6];//规格型号
				xlsheet.cells(Row+4,4)=List[sort+7];//单价
				xlsheet.cells(Row+4,5)=ChangeDateFormat(List[sort+3]);//日期
				xlsheet.cells(Row+4,6)=List[2];				
				xlsheet.cells(Row+4,7)=List[4];
				sumFee=sumFee+List[sort+7]*1;
				sumQty=sumQty+1;
				//}				
	    	}
	    //xlsheet.cells(OnePageRow+7,7)="制单人:"+lista[sort+2];
	    xlsheet.Rows(OnePageRow+5).Delete();
	    
	    var getDXX=GetElementValue("DXXZH");	    
		var DXSumFee=cspRunServerMethod(getDXX,"","",sumFee);
		//alertShow(sumFee+" "+DXSumFee);
	    xlsheet.cells(OnePageRow+5,2)=DXSumFee;
	    
	    xlsheet.cells(OnePageRow+12,2)=ChangeDateFormat(lista[3]) ;//lista[4]  //时间
	    xlsheet.cells(OnePageRow+12,6)="第"+(i+1)+"页 "+"共"+(Pages+1)+"页";   //时间    

	    xlsheet.printout; //打印输出
	    //xlBook.SaveAs("D:\\Return"+i+".xls");   //lgl+
	    xlBook.Close (savechanges=false);
	    
	    xlsheet.Quit;
	    xlsheet=null;
	    }
	    xlApp=null;
	} 
	catch(e)
	{
		alertShow(e.message);
	}	
}

function BPrint_Click()
{
	var disuseid=GetElementValue("RowID");
	var equipdr=GetElementValue("EquipDR");
	PrintDisuse(disuseid,equipdr);
}

document.body.onload = BodyLoadHandler;