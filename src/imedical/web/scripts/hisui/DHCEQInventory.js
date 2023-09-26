///-----------------------------------
/// Add By DJ 2010-05-31 DJ0046
/// Description:�����̵������������
///-----------------------------------
/// Modified By zc 2014-09-15 ZC0006
/// ��������:CheckNull
/// ----------------------------------
var SelectedRow=0;
var rowid=0;
var readonly;
function BodyLoadHandler() 
{
	InitPage();
	initButtonWidth(); //HISUI���� add by MWZ 2018-10-10
	setButtonText();	//HISUI���� add by MWZ 2018-10-10
	initUserInfo();  // Modified By QW20181225 �����:758406,744327
	SetTableItem();
	InitMessage();  //add by mwz 2020-04-27  MWZ0036
	var ReadOnly=GetElementValue("ReadOnly")
	var Status=GetElementValue("Status")
	if((ReadOnly=="0")&&(Status==1))
	{
		addColumsEditor();		//modified by czf 20190111
	}
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
	
	var obj=document.getElementById("BFilterInfo"); //2010-05-31 ���� DJ0046 �̵������������
	if (obj) obj.onclick=BFilterInfo_Click;
	
	var obj=document.getElementById("BDelete");
	if (obj) obj.onclick=BDelete_Click;
	var obj=document.getElementById("BAudit");
	if (obj) obj.onclick=BAudit_Click;
	var obj=document.getElementById("PrintBarCode");  //�����ӡ
	if (obj) obj.onclick=PrintBarCode_Click;
	
	var obj=document.getElementById("BSave");
	if (obj) obj.onclick=BSave_Click;
	var obj=document.getElementById("BSelectAll");
	if (obj) obj.onclick=BSelectAll_Clicked;
	
	var obj=document.getElementById("BBarCodePrint");	//Add By DJ 2016-09-21
	if (obj) obj.onclick=BBarCodePrint_Click;
	var obj=document.getElementById("BResultStat");	//�����:757357 add by MWZ 2018-12-25 
	if (obj) obj.onclick=BResultStat_Click;
	var obj=document.getElementById("BResult");	//�����:757357 add by MWZ 2018-12-25
	if (obj) obj.onclick=BResult_Click;
	
	var obj=document.getElementById("BSaveTXT");	/// 2019-08-29 	Mozy0224
	if (obj) obj.onclick=BSaveTXT_Click;
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
	//����
	//add by mwz 2020-04-27  MWZ0036 BEGIN
	var rows = $('#tDHCEQInventory').datagrid('getRows');
	var RowCount=rows.length
	if(RowCount<=0){
		messageShow("","","",t[-9248]);
		return;
	}
	//add by mwz 2020-04-27  MWZ0036 END
	var encmeth=GetElementValue("GetUpdate");
	if (encmeth=="")
	{
		messageShow("","","",t['NoMethod']);
		return;
	}
	if (CheckNull()) return;
	var InventoryDR=GetElementValue("InventoryDR");
	var StoreLocDR=GetElementValue("StoreLocDR");
	var UseLocDR=GetElementValue("UseLocDR");
	var EquipTypeIDs=GetElementValue("EquipTypeIDs");
	var StatCatDR=GetElementValue("StatCatDR");
	var OriginDR=GetElementValue("OriginDR");
	var FilterInfo=GetElementValue("FilterInfo");	//2010-05-31 ���� DJ0046
	var ManageLocDR=GetElementValue("ManageLocDR");
	//modified by zy 2015-08-25 ZY0136
	var StatusDR=GetElementValue("StatusDR");
	var ReadOnly=GetElementValue("ReadOnly");
	//add hly 2019-12-09 bug:1110591
	//modify by mwz �������޸������⣬����1110591��Ӧ�ÿ��ƿⷿ
	//if (getElementValue("StoreLoc")=="")
	//{
	//	messageShow("","","","�豸�ⷿ����Ϊ��");
	//	return
	//}

	var result=cspRunServerMethod(encmeth,IsDel, InventoryDR, StoreLocDR, UseLocDR, EquipTypeIDs, StatCatDR, OriginDR, FilterInfo, ManageLocDR);	//2010-05-31 ���� DJ0046
	var list=result.split("^");
	if (list[0]!=0)
	{
		messageShow("","","",t['saveFailed']+" "+list[1]);
		return;
	}
	else
	{
		var meg='saveSuccess'
		/*if (list[0]==-1)  //ɾ������
		{
			list[0]=""
			SetElement("EquipTypeIDs","");
			SetElement("Status","");
			meg='deleteSuccess'
		}
		if (list[2]=='AuditSuccess')  //�̵���ɲ���
		{
			meg='AuditSuccess'
		}*/
		SetElement("InventoryDR",list[1]);
		messageShow("","","",t[meg]);
		//BFind_click();	// 2011-8-11	Mozy0056
		url= 'websys.default.hisui.csp?WEBSYS.TCOMPONENT=DHCEQInventory&InventoryDR='+list[1]+"&EquipTypeIDs="+EquipTypeIDs+"&StoreLocDR="+StoreLocDR+"&StatusDR="+StatusDR+"&ReadOnly="+ReadOnly;  //modified by zy 2015-08-25 ZY0136
		window.setTimeout(function(){window.location.href=url},50);    //modify by mwz 2020-04-03 MWZ0032 
	}
}
function BSubmit_Click()
{
	var objtbl = $("#tDHCEQInventory").datagrid('getRows'); //HISUI���� add by MWZ 2018-10-10
    var rows=objtbl.length
	var lastrowindex=rows;   //modified by mwz 1168624 
	if (lastrowindex<=0)
	{
		messageShow('alert','error','������ʾ','���̵���ϸ�޷��ύ!����');
		return
	}
	var encmeth=GetElementValue("GetSubmit");
	if (encmeth=="")
	{
		messageShow("","","",t['NoMethod']);
		return;
	}
	if (CheckNull()) return;
	var InventoryDR=GetElementValue("InventoryDR");
	var StoreLocDR=GetElementValue("StoreLocDR");
	var UseLocDR=GetElementValue("UseLocDR");
	var EquipTypeIDs=GetElementValue("EquipTypeIDs");
	var StatCatDR=GetElementValue("StatCatDR");
	var OriginDR=GetElementValue("OriginDR");
	var FilterInfo=GetElementValue("FilterInfo");	//2010-11-03 ����
	var ManageLocDR=GetElementValue("ManageLocDR");
	//modified by zy 2015-08-25 ZY0136
	var StatusDR=GetElementValue("StatusDR");
	var ReadOnly=GetElementValue("ReadOnly");
	var result=cspRunServerMethod(encmeth, InventoryDR, StoreLocDR, UseLocDR, EquipTypeIDs, StatCatDR, OriginDR, FilterInfo, ManageLocDR);
	if (0==result)
	{	messageShow("","","",t['submitsuccess']);	
		//BFind_click();	// 2011-8-11	Mozy0056
		url= 'websys.default.hisui.csp?WEBSYS.TCOMPONENT=DHCEQInventory&InventoryDR='+InventoryDR+"&EquipTypeIDs="+EquipTypeIDs+"&StoreLocDR="+StoreLocDR+"&StatusDR="+StatusDR+"&ReadOnly="+ReadOnly; //modified by zy 2015-08-25 ZY0136
		window.setTimeout(function(){window.location.href=url},50);   //modify by mwz 2020-04-03 MWZ0032 
	}
	else
	{	messageShow("","","",t['submitFailed']);	}
}
function CheckNull()
{
	//modify hly 2019-12-14 bug:1110591
	if (GetElementValue("EquipTypeIDs")=="")
	{
		
		messageShow("","","","û��ѡ������,��ѡ������!");
		return true;
	}
	return false;
}
function GetInventoryDetail()
{
	var encmeth=GetElementValue("GetOneDetail");
	if (encmeth=="")
	{
		messageShow("","","",t['NoMethod']);
		return;
	}
	var InventoryDR=GetElementValue("InventoryDR");
	if (InventoryDR=="") 
	{
		var GetUnCheckNum=GetElementValue("GetUnCheckNum");
		if (GetUnCheckNum=="")
		{
			messageShow('alert','error','������ʾ','δ�����ȡδ�̵����!');
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
				messageShow('alert','error','������ʾ','δ�����ȡδ�̵����!');
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
	//messageShow("","","",equiptypeinfos);
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
			//messageShow("","","",obj.options[i]);
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

//�����ӡ
//add BY:GBX 2015-1-27 16:19:33  GBX0034
function PrintBarCode_Click()
{
	var locid=GetElementValue("PrintLocDR");
	var locName=GetElementValue("PrintLoc");
	var TJob=GetElementValue("TJobz2")
	//modify by mwz 2020-04-03 MWZ0032 begin
	if (locid!="")
	{
		messageShow("confirm","","","�Ƿ��ӡ: "+locName+" ���豸����?","",ConfirmOpt,DisConfirmOpt);
	}
	else
	{
		messageShow("confirm","","","ȷ�ϴ�ӡ����?","",ConfirmOpt,DisConfirmOpt);
	}
	//modify by mwz 2020-04-03 MWZ0032 end
	
}

//add by mwz 2020-04-03 MWZ0032 begin
function ConfirmOpt()
{
	var locid=GetElementValue("PrintLocDR");
	var locName=GetElementValue("PrintLoc");
	var TJob=GetElementValue("TJobz2")

	if (locid!="")
	{
		var encmeth=GetElementValue("GetNextLoc");
		if (encmeth=="")
		{
			messageShow("","","",t['NoMethod']);
			return;
		}
		
		var encmeth=GetElementValue("GetLocEquip");
		if (encmeth=="")
		{
			messageShow("","","",t['NoMethod']);
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
				PrintBars(equipdr,"tiaoma","�̶��ʲ�")
			}
		}while(rowid!="")
	}
	else
	{
		var encmeth=GetElementValue("GetNum");  //��ȡ��ӡ����
		num=cspRunServerMethod(encmeth,"",TJob);
		if (num<=0) 
		{
			messageShow('alert','error','������ʾ','�����ݿɴ�ӡ');
			return
		}
		encmeth=GetElementValue("GetList");  //��ȡ��ӡ��Ϣ
		for (var i=1; i<=num; i++)
		{
			var EquipID="";
			var str=cspRunServerMethod(encmeth,i,"",TJob);
			var List=str.split("^");
			EquipID=List[2];
			PrintBars(EquipID,"tiaoma","�̶��ʲ�")
		}
	}	
}

function DisConfirmOpt()
{
}
//add by mwz 2020-04-03 MWZ0032 end

// modified by sjh 2019-12-03 BUG00018
// modify by wl 2019-12-23 WL0041 ������Ǭ����
function BPrint_Click()
{
	var StoreLocDR=GetElementValue("StoreLocDR");
	var PrintLocDR=GetElementValue("PrintLocDR");
	var InventoryDR=GetElementValue("InventoryDR");
	var PrintFlag = GetElementValue("PrintFlag");	 //��ӡ��ʽ��־λ excel��0  ��Ǭ:1   
	var PreviewRptFlag = GetElementValue("PreviewRptFlag"); //��ǬԤ����־ ��Ԥ�� :0  Ԥ�� :1
	var HOSPDESC = GetElementValue("GetHospitalDesc");
	var filename = ""
	//Excel��ӡ��ʽ
	if(PrintFlag==0)  
	{
		PrintInventory();
	}
	//��Ǭ��ӡ
	if(PrintFlag==1)
	{
		if(PreviewRptFlag==0)
		{ 
		    fileName="{DHCEQInventoryPrint.raq(InventoryDR="+InventoryDR+";StoreLocDR="+StoreLocDR+";PrintLocDR="+PrintLocDR
		    +";HOSPDESC="+HOSPDESC
		    +";USERNAME="+curUserName
		    +")}";	
	        DHCCPM_RQDirectPrint(fileName);		
		}
		
		if(PreviewRptFlag==1)
		{ 
			fileName="DHCEQInventoryPrint.raq&InventoryDR="+InventoryDR+"&StoreLocDR="+StoreLocDR+"&PrintLocDR="+PrintLocDR
		    +"&HOSPDESC="+HOSPDESC
		    +"&USERNAME="+curUserName	   
			DHCCPM_RQPrint(fileName);	
		}
	}		
}

function PrintInventory()
{	
	var result;
	var obj=document.getElementById("BPrint");
	if ((!obj)||(obj.disabled)) return;
	var encmeth=GetElementValue("GetNextLoc");
	if (encmeth=="")
	{
		messageShow("","","",t['NoMethod']);
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
		if (result>0) xlsheet.printout; //��ӡ���
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
					xlsheet.printout; //��ӡ���
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
		messageShow("","","",t['NoMethod']);
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
///����:2010-05-31 ���� DJ0046
///����:�̵������������
function BFilterInfo_Click()
{
	var str='websys.default.hisui.csp?WEBSYS.TCOMPONENT=DHCEQInventoryFilterInfo&InventoryDR='+GetElementValue("InventoryDR")+'&FilterInfo='+GetElementValue("FilterInfo")
    //window.open(str,'_blank','toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width=890,height=650,left=120,top=0')
	showWindow(str,"�̵������������","","11row","icon-w-paper","modal","","","middle");	//modified by lmm 2020-06-05 UI
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
///����:���ӹ������
function GetManageLoc(value)
{
	GetLookUpID('ManageLocDR',value);
}
//modify by mwz 2020-04-03 MWZ0032 begin
function BDelete_Click()
{
	messageShow("confirm","","","�Ƿ�ȷ��ɾ����ǰ�̵㵥?","",DeleteInventory,DisConfirmOpt);
}
function DeleteInventory()
{
	var encmeth=GetElementValue("UpdateInventory");
	if (encmeth=="") return
	var InventoryDR=GetElementValue("InventoryDR")
	if (InventoryDR=="") return
	//modified by zy 2015-08-25 ZY0136
	var StatusDR=GetElementValue("StatusDR");
	var ReadOnly=GetElementValue("ReadOnly");
	var result=cspRunServerMethod(encmeth, InventoryDR, 1);
	if (result<0)
	{
		messageShow('alert','error','������ʾ','ɾ���̵㵥ʧ��!');
	}
	else
	{
		messageShow("","","","�ɹ�ɾ���̵㵥!");
		//ˢ�½���
		url= "websys.default.hisui.csp?WEBSYS.TCOMPONENT=DHCEQInventory"+"&StatusDR="+StatusDR+"&ReadOnly="+ReadOnly;  //modified by zy 2015-08-25 ZY0136
		window.setTimeout(function(){window.location.href=url},50);  
	}
}

function BAudit_Click()
{
	//��ʾ�Ƿ��̵����
	messageShow("confirm","","","�Ƿ�ȷ����ǰ�̵㵥���̵����","",FinishInventory,DisConfirmOpt);	
}
function FinishInventory()
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

	var result=cspRunServerMethod(encmeth, InventoryDR, 2);
	if (result<0)
	{
		messageShow('alert','error','������ʾ','����ʧ��!');
	}
	else
	{
		messageShow("","","","�˴��̵����!")
		//BFind_click();	// 2011-8-11	Mozy0056
		url= 'websys.default.hisui.csp?WEBSYS.TCOMPONENT=DHCEQInventory&InventoryDR='+InventoryDR+"&EquipTypeIDs="+EquipTypeIDs+"&StoreLocDR="+StoreLocDR+"&StatusDR="+StatusDR+"&ReadOnly="+ReadOnly;  //modified by zy 2015-08-25 ZY0136
		window.setTimeout(function(){window.location.href=url},50); 
	}
}
//modify by mwz 2020-04-03 MWZ0032 end

//modified by zy 2015-08-25 ZY0136
function SetTableItem()
{
	var ReadOnly=GetElementValue("ReadOnly")
	if (ReadOnly!="0") return;
	var objtbl=document.getElementById('tDHCEQInventory');//+�����
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
	//var objtbl=document.getElementById('tDHCEQInventory');//+�����
	//var rows=objtbl.rows.length-1;
	var rows = $('#tDHCEQInventory').datagrid('getRows');
	var RowCount=rows.length
	if(RowCount<=0){
		messageShow('alert','error','������ʾ','û�д���������!');
		return;
	}
	var valList="";
	for (var i=0;i<RowCount;i++)
	{
		$('#tDHCEQInventory').datagrid('endEdit',i);
		var TRowID=rows[i].TRowID;
		var TActerStoreLocDR="";					//modified by czf
		if (rows[i].TActerStoreLoc!=""&&rows[i].TActerStoreLoc!=undefined){	//modified by csj 20190121
			TActerStoreLocDR=rows[i].TActerStoreLoc;
		}
		var TActerUseLocDR=""
		if (rows[i].TActerUseLoc!=""&&rows[i].TActerUseLoc!=undefined){	//modified by csj 20190121
			TActerUseLocDR=rows[i].TActerUseLoc
		}
		var TRemark=rows[i].TRemark 
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
		messageShow("","","",EQMsg(t["saveFailed"],result))
		initEditTable();		//����ʧ��ʱ���ñ༭�� czf 20190111
	}
}
function BSelectAll_Clicked()
{
	var objtbl=document.getElementById('tDHCEQInventory');//+�����
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
///����:�̵㵥δ�̵��豸�����ӡ
function BBarCodePrint_Click()
{
	var InventoryDR=GetElementValue("InventoryDR");
	if (InventoryDR=="")
	{
		messageShow('alert','error','������ʾ','���������̵㵥!');
		return
	}
	var Status=GetElementValue("Status");
	if ((Status=="")||(Status<=0))
	{
		messageShow('alert','error','������ʾ','δȷ���̵㵥���ܴ�ӡ����!');
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
			PrintBars(Strs,"tiaoma","�̶��ʲ�")
		}
	} while (Strs!="")
}
///end by zy 2015-08-25 ZY0136
//�����:757357 add by MWZ 2018-12-25  �������Ӵ���LINKʱ�Ḳ��ԭ�Ӵ���
function BResultStat_Click()
{
	var str='websys.default.hisui.csp?WEBSYS.TCOMPONENT=DHCEQInventoryResultStat&InventoryDR='+GetElementValue("InventoryDR")
    //window.open(str,'_blank','toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width=600,height=600,left=350,top=3')
	showWindow(str,"�̵�������","","11row","icon-w-paper","modal","","","middle"); //modify by lmm 2020-06-05 UI
}
//�����:757357 add by MWZ 2018-12-25	 �������Ӵ���LINKʱ�Ḳ��ԭ�Ӵ���
function BResult_Click()
{
	var str='websys.default.hisui.csp?WEBSYS.TCOMPONENT=DHCEQInventoryResult&InventoryDR='+GetElementValue("InventoryDR")
	//window.open(str,'_blank','toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width=600,height=600,left=350,top=3')
	showWindow(str,"�̵���","","11row","icon-w-paper","modal","","","middle"); //modify by lmm 2020-06-05 UI
}

//add by czf 20190111
function addColumsEditor()
{
	var Component="tDHCEQInventory"
	var Remark=$('#'+Component).datagrid('getColumnOption','TRemark');
	var columobj={TDataType:4,TLookupCustomComponent:'',TLookupProperties:'',TLookupJavascriptFunction:''}
	Remark.editor=setEditorStyle(columobj)
	var ActerStoreLoc=$('#'+Component).datagrid('getColumnOption','TActerStoreLoc');	
	columobj={TDataType:9,TLookupCustomComponent:'PLAT.L.Loc',TLookupProperties:"",TLookupJavascriptFunction:""}
	ActerStoreLoc.editor=setEditorStyle(columobj)
}
//add by czf 20190111
function initEditTable()
{
	var Component="tDHCEQInventory"
	var rows = $('#'+Component).datagrid('getRows');
	var RowCount=rows.length;
	for (var i=0;i<RowCount;i++)
	{
		jQuery('#'+Component).datagrid('beginEdit',i);
	}
}
/// 2019-08-29 	Mozy0224
function BSaveTXT_Click()
{
	var InventoryDR=GetElementValue("InventoryDR");	
	if (InventoryDR=="")
	{
		messageShow("","","","������!");
		return;
	}
	var locid=cspRunServerMethod(GetElementValue("GetNextLoc"),InventoryDR,"");
	if (locid=="")
	{
		messageShow("","","","���̵㵥δȷ��,��������!");
		return;
	}
	try
	{
		var FileName=GetFileNameToTXT();
		var fso = new ActiveXObject("Scripting.FileSystemObject");
    	var f = fso.OpenTextFile(FileName,2,true);	//����д�ļ�
		//д�����
		f.WriteLine("�̵㵥��:"+GetElementValue("InventoryNo")+"\t��������:"+FormatDate(GetCurrentDate()));
	    var tmpString="���"+"\t"+"ʹ�ÿ���"+"\t"+"�豸����"+"\t"+"Ժ�����"+"\t"+"�豸����"+"\t"+"ԭֵ"+"\t"+"��λ"+"\t"+"����"+"\t"+"����ͺ�"+"\t"+"��������"+"\t"+"�������"+"\t"+"��Ӧ��"+"\t"+"����������"+"\t"+"ʵ������"+"\t"+"��ע";
	    f.WriteLine(tmpString);
		
		//д���¼
		var row=0;		//���
		do
		{
			if (locid!="")
			{
				var equipdr="";
				var rowid="";
				var TotalFee=0;
				var Count=0;
				var encmeth=GetElementValue("GetLocEquip");
				do
				{
					result=cspRunServerMethod(encmeth,InventoryDR,locid,equipdr,rowid);
					result=result.replace(/\r\n/g,"");
					//alertShow(result)
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
						//NewEquipDR,NewRowID,Name,Model,Manufactory,No,Unit,EquipCat,StoreLoc,UseLocDR,UseLoc,OriginalFee,Origin,StorePlace,CheckDate,OpenCheckDate,Country,ManageUser,InDate,EquipType,LeaveFactoryNo,Provider
						tmpString=row+"\t"+list[8]+"\t"+list[2]+"\t"+list[5]+"\t"+list[19]+"\t"+list[11]+"\t"+list[6]+"\t"+1+"\t"+list[3]+"\t"+list[4]+"\t"+list[20]+"\t"+list[21]+"\t"+FormatDate(list[18]);
						f.WriteLine(tmpString);
						TotalFee=TotalFee+parseFloat(list[11]);
						Count=Count+1;
					}
				} while(rowid!="")
				f.WriteLine("С��"+"\t\t\t\t\t"+TotalFee+"\t\t"+Count);
			}
			locid=cspRunServerMethod(GetElementValue("GetNextLoc"),InventoryDR,locid);
		} while(locid!="")
		f.Close();
		messageShow("","","","�������!");
	} 
	catch(e)
	{
		messageShow("","","",e.message);
	}

}
///add by mwz 2019-12-16 MWZ0025
///bugZY0170
///����: 2018-09-30
///����: ����datagrid�е�editor ������Ҫ��html 
///Input: value  
///       row			�ж���
///       index			������
///       oneItem		һ��Ԫ�ض���
function setEditorStyle(oneItem)
{
	var editor=""
    if (oneItem.TDataType==0)
    {
		editor={type: 'text',options:{}}
	}
	else if (oneItem.TDataType==1)
	{
		editor={type: 'textarea',options:{}}
	}
	else if (oneItem.TDataType==2)
	{
		editor={type: 'checkbox',options:{on:'Y',off:'N'}}
	}
	else if (oneItem.TDataType==3)
	{
		editor={type: 'numberbox',options:{precision:2}}
	}
	else if (oneItem.TDataType==4)
	{
		editor={type: 'validatebox',options:{}}
	}
	else if (oneItem.TDataType==5)
	{
		editor={type: 'datebox',options:{}}
	}
	else if (oneItem.TDataType==6)
	{
		editor={type: 'datetimebox',options:{}}
	}
	else if (oneItem.TDataType==7)
	{
		editor={type: 'combobox',options:{}}
	}
	else if (oneItem.TDataType==8)
	{
		editor={type: 'combotree',options:{}}
	}
	else if (oneItem.TDataType==9)
	{
		///modified by zy0172  hisui����  �޸����ļ���λ��
		var lookupinfo=tkMakeServerCall("web.DHCEQ.Plat.CTCComponentSet","GetComponentsInfo",oneItem.TLookupCustomComponent)
		var lookupObj=JSON.parse(lookupinfo)
		var componentInfo=lookupObj[oneItem.TLookupCustomComponent]
		if (componentInfo!="")
		{
			var objcomponent =new component(componentInfo)
			editor={type: 'combogrid',options:{
														panelWidth:400,
														mode: 'remote',
														pagination:true,
														lazy:true,
														showPageList:false,
														showRefresh:false,
														minQueryLen:1,
														isCombo:true,
														queryParams:{ClassName: objcomponent.className,QueryName: objcomponent.queryName},
														url: $URL,
														idField:objcomponent.idField,
														textField:objcomponent.textField,
														columns:objcomponent.columns,
													    onBeforeLoad:function(param){
															//�ж��˲�����
															if (oneItem.TLookupProperties!="") objcomponent.params=oneItem.TLookupProperties
															var option=objcomponent.params.split("#");
														    for (var i=0;i<option.length;i++)
														    {
															    var oneParaInfo=option[i].split("*");
															    //��ȡcombogrid�����ֵ
															    if(oneParaInfo[2]=="1") {param[oneParaInfo[0]]=param.q;}
																//��ȡĬ��ֵ  ����
																else if(oneParaInfo[2]=="2"){param[oneParaInfo[0]]=oneParaInfo[3];}
																//��ȡsessionֵ
																else if(oneParaInfo[2]=="3"){param[oneParaInfo[0]]=session[oneParaInfo[3]];}
																//ͨ��jsдgetParam����ȡֵ
																else if(oneParaInfo[2]=="5"){param[oneParaInfo[0]]=getParam(oneParaInfo[0]);}
																//��ȡ��������Ԫ��ֵ
																else{param[oneParaInfo[0]]=getElementValue(oneParaInfo[3]);}
															}
															return true;
														},
														onSelect:eval(oneItem.TLookupJavascriptFunction)
														/*
														onSelect:function (ind,item){
															//oneItem.TLookupJavascriptFunction
															//messageShow("","","",editIndex+"$(this)="+$(this).id)
															/*
															if ((vfunction)&&(vfunction!=undefined)&&(vfunction!=""))
															{
																vfunction(item);
															}
															else
															{
																setSelectValue(vElementID,item);
															}
														}
															*/
													}
    											}
    										}
	}
	else if (oneItem.TDataType==10)
	{
		editor={type: 'icheckbox',options:{on:'Y',off:'N'}}
	}
	else if (oneItem.TDataType==11)
	{
		editor={type: 'linkbutton',options:{}}
	}
	else if (oneItem.TDataType==12)
	{
		editor={type: 'switchbox',options:{}}
	}
	return editor
}
document.body.onload = BodyLoadHandler;