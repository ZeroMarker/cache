/// -------------------------------
/// ��    ��:ZY  2009-08-24  No.ZY0010
/// ���Ӻ���:BAdd_Clicked()
/// �޸�����:������������
/// -------------------------------
/// ��    ��:ZY  2009-08-16  No.ZY0009
/// �޸�����:�豸�������ϲ���
/// --------------------------------
function BodyLoadHandler(){
	
	InitUserInfo();
	fillData();	
	InitPage();
	//InitTblEvt();
	initButtonWidth()  //hisui���� add by lmm 2018-08-20
}

function InitPage()
{
	KeyUp("RequestLoc^EquipType^Status^PurchaseType^Equip^UseLoc","N") //2011-10-27 DJ DJ0097
	Muilt_LookUp("RequestLoc^EquipType^Status^PurchaseType^Equip^UseLoc"); //2011-10-27 DJ DJ0097
	var Type=GetElementValue("Type");
	if (Type!="0")
	{
		DisableBElement("BAdd",true);
		DisableBElement("BAddSimple",true);
	}
	else
	{
		EQCommon_HiddenElement("BBatchApprove")  // modified by kdf 2019-04-03 ������������������˰�ť ����ţ�866131
		EQCommon_HiddenElement("cWaitAD");
		$("#WaitAD").parent().empty()	//Mozy	1015142	2019-9-14
		//HiddenCheckBox("WaitAD");  //hisui���� add by lmm 2018-08-09
	}
	if (Type!="1")
	{
		EQCommon_HiddenElement("ReplacesAD");
		EQCommon_HiddenElement("cReplacesAD");
	}
	var obj=document.getElementById("WaitAD");
	if (obj) obj.onchange=CheckChange;
	var obj=document.getElementById("ReplacesAD")
	if (obj) obj.onchange=CheckChange;
	var obj=document.getElementById("BAdd");
	if (obj) obj.onclick=BAdd_Clicked;
	var obj=document.getElementById("BFind");
	if (obj) obj.onclick=BFind_Clicked;
	var obj=document.getElementById("BAddSimple");
	if (obj) obj.onclick=BAddSimple_Clicked;
	
	//var obj=document.getElementById("SelectAll");
	//if (obj) obj.onclick=SelectAll_Clicked; 
	
	//modified by kdf 2019-03-06 begin
	$('#SelectAll').checkbox({
		onCheckChange:function(e,vaule){
			SelectAll_Clicked(vaule);
			}	
	});
	//modified by kdf 2019-03-06 end

	var obj=document.getElementById("BBatchApprove");
	if (obj) obj.onclick=BBatchApprove_Clicked;
}
///add by lmm 2018-08-09
///������hisui���� ���ع�ѡ��
///��Σ�name ��ѡ��id
function HiddenCheckBox(name)
{
	$("#"+name).parent(".hischeckbox_square-blue").css("display","none");
}

/// modified by kdf ����ţ�814952 ���ĵ���ʽ
function BAdd_Clicked()
{
    var val="&QXType="+GetElementValue("QXType")
    val=val+"&RequestLocDR="+GetElementValue("RequestLocDR");
    val=val+"&DType="+GetElementValue("DType");
    val=val+"&Type="+GetElementValue("Type");
    url='websys.default.hisui.csp?WEBSYS.TCOMPONENT=DHCEQBatchDisuseRequest&RowID=&ApproveSetDR='+val
    //modify by wy 2020-5-12 ����������UI��С
	showWindow(url,"�豸���ϵ�","","","icon-w-paper","modal","","","large")	//modify by lmm 2020-06-04 UI
}

function CheckChange()
{
	var eSrc=window.event.srcElement;
	if (eSrc.checked)
	{
		if (eSrc.id=="WaitAD") SetChkElement("ReplacesAD","0");
		if (eSrc.id=="ReplacesAD") SetChkElement("WaitAD","0");
	} 
}

function GetRequestLoc (value)
{
    GetLookUpID("RequestLocDR",value);
}
function GetEquipType (value)
{
    GetLookUpID("EquipTypeDR",value);
}
function GetStatus (value)
{
    GetLookUpID("StatusDR",value);
}
function GetPurchaseType (value)
{
    GetLookUpID("PurchaseTypeDR",value);
}
function GetEquip (value)
{
    GetLookUpID("EquipDR",value);
}

function BFind_Clicked()
{
	var val="&vData="
	val=val+GetVData();
	val=val+"&TMENU="+GetElementValue("TMENU");
	window.location.href="websys.default.hisui.csp?WEBSYS.TCOMPONENT=DHCEQBatchDisuseRequestFind"+val;  //hisui���� modify by lmm 2018-08-17
}

function GetVData()
{
	var	val="^ReplacesAD="+GetElementValue("ReplacesAD");
	val=val+"^ApproveRole="+GetElementValue("ApproveRole");
	val=val+"^Type="+GetElementValue("Type");
	val=val+"^StatusDR="+GetElementValue("StatusDR");
	val=val+"^Status="+GetElementValue("Status");
	val=val+"^EquipDR="+GetElementValue("EquipDR");
	val=val+"^RequestLocDR="+GetElementValue("RequestLocDR");
	val=val+"^EquipTypeDR="+GetElementValue("EquipTypeDR");
	val=val+"^PurchaseTypeDR="+GetElementValue("PurchaseTypeDR");	
	val=val+"^StartDate="+GetElementValue("StartDate");
	val=val+"^EndDate="+GetElementValue("EndDate");
	val=val+"^WaitAD="+GetElementValue("WaitAD");
	val=val+"^QXType="+GetElementValue("QXType");
	val=val+"^Name="+GetElementValue("Name");
	val=val+"^UseLocDR="+GetElementValue("UseLocDR");
	val=val+"^RequestNo="+GetElementValue("RequestNo");
	val=val+"^EquipName="+GetElementValue("EquipName");
	val=val+"^MinValue="+GetElementValue("MinValue");
	val=val+"^MaxValue="+GetElementValue("MaxValue");
	val=val+"^StartInDate="+GetElementValue("StartInDate");
	val=val+"^EndInDate="+GetElementValue("EndInDate");
	val=val+"^EquipNo="+GetElementValue("EquipNo");		//20141202  Mozy0147
	return val;
}

function fillData()
{
	var vData=GetElementValue("vData")
	if (vData!="")
	{
		var list=vData.split("^");
		for (var i=1; i<list.length; i++)
		{
			Detail=list[i].split("=");
			switch (Detail[0])
			{
				case "ReplacesAD":
					if (Detail[1]=="true")
					{
						SetChkElement(Detail[0],1);
					}
					else
					{
						SetChkElement(Detail[0],0);
					}
					break;
				case "WaitAD":
					if (Detail[1]=="true")
					{
						SetChkElement(Detail[0],1);
					}
					else
					{
						SetChkElement(Detail[0],0);
					}
					break;
				default :
					SetElement(Detail[0],Detail[1]);
					break;
			}
		}
	}
	var val="";
	val=val+"equip=Equip="+GetElementValue("EquipDR")+"^";
	val=val+"equiptype=EquipType="+GetElementValue("EquipTypeDR")+"^";
	val=val+"purchase=PurchaseType="+GetElementValue("PurchaseTypeDR")+"^";
	val=val+"dept=RequestLoc="+GetElementValue("RequestLocDR")+"^";
	val=val+"dept=UseLoc="+GetElementValue("UseLocDR")+"^"; //2011-20-27 DJ DJ0097
	var encmeth=GetElementValue("GetDRDesc");
	var result=cspRunServerMethod(encmeth,val);
	var list=result.split("^");
	for (var i=1; i<list.length; i++)
	{
		var Detail=list[i-1].split("=");
		SetElement(Detail[0],Detail[1]);
	}
}

function RefreshData()
{
	var vdata1=GetElementValue("vData");
	var vdata2=GetVData();
	if (vdata1!=vdata2) BFind_Clicked();
}

///ѡ�����д����˷���
function InitTblEvt()
	{
	var objtbl=document.getElementById('tDHCEQBatchDisuseRequestFind');//+����� ������������ʾ Query ����Ĳ���
	var rows=objtbl.rows.length;
	
	for (var i=1; i<rows; i++)
	{
		var obj=document.getElementById("TDetailz"+i);
		if (obj) obj.onclick=TDetail_Clicked;
	}
}

function TDetail_Clicked()
{
	var CurRow=GetTableCurRow();
	var val="&RowID="+GetElementValue("TRowIDz"+CurRow);
    val=val+"&CurRole="+GetElementValue("ApproveRole");
    val=val+"&QXType="+GetElementValue("QXType");
    val=val+"&Type="+GetElementValue("Type");
    
    //Modified By JDL 2011-12-02 JDL0104
    var KindFlag=GetElementValue("TKindFlagz"+CurRow);
    var LinkComponentName="DHCEQBatchDisuseRequest";
    if (KindFlag==2)
    {
	    LinkComponentName="DHCEQDisuseRequestSimple";
    }
    var str= 'websys.default.csp?WEBSYS.TCOMPONENT='+LinkComponentName+val  //2011-10-27 DJ DJ0097
    window.open(str,'_blank','toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width=1000,height=680,left=120,top=0') //2011-10-27 DJ DJ0097
}

function GetUseLoc (value) //2011-10-27 DJ DJ0097
{
    GetLookUpID("UseLocDR",value);
}

//Add by JDL 2011-11-29 JDL0104
function BAddSimple_Clicked1()
{
    var val="&QXType="+GetElementValue("QXType")
    val=val+"&RequestLocDR="+GetElementValue("RequestLocDR");
    val=val+"&DType="+GetElementValue("DType");
    val=val+"&Type="+GetElementValue("Type");
    //window.location.href= 'websys.default.hisui.csp?WEBSYS.TCOMPONENT=DHCEQDisuseRequestSimple&RowID=&ApproveSetDR='+val  //hisui���� modify by lmm 2018-08-17
     window.location.href= 'dhceq.em.disusesimlpe.csp?WEBSYS.TCOMPONENT=DHCEQDisuseRequestSimple&RowID=&ApproveSetDR='+val  //hisui���� modify by lmm 2018-08-17
}

///modified by kdf 2019-01-22 
function BAddSimple_Clicked() 
{
	var val="&QXType="+GetElementValue("QXType")
    val=val+"&RequestLocDR="+GetElementValue("RequestLocDR");
    val=val+"&DType="+GetElementValue("DType");
    val=val+"&Type="+GetElementValue("Type");
    //url="dhceq.em.disusesimlpe.csp?"+val
	url="dhceq.em.disusesimlpe.csp?WEBSYS.TCOMPONENT=DHCEQDisuseRequestSimple&RowID=&ApproveSetDR=&WaitAD=false"+val
	showWindow(url,"�豸���ϵ�","","","icon-w-paper","modal","","","large")	//modify by lmm 2020-06-04 UI
}

///add by lmm 2018-08-17
///hisui���� ��ϸ��ť�е���
///��Σ�rowData �б�json����
///      rowIndex �����
function TDetailHandler(rowData,rowIndex)  
{
	var val="&RowID="+rowData.TRowID;
    val=val+"&CurRole="+GetElementValue("ApproveRole");
    val=val+"&QXType="+GetElementValue("QXType");
    val=val+"&Type="+GetElementValue("Type");
    
    //Modified By JDL 2011-12-02 JDL0104
    var KindFlag=rowData.TKindFlag;
    var LinkComponentName="DHCEQBatchDisuseRequest";
    if (KindFlag==2)
    {
	    LinkComponentName="DHCEQDisuseRequestSimple";
    }
    var str= 'websys.default.hisui.csp?WEBSYS.TCOMPONENT='+LinkComponentName+val  //2011-10-27 DJ DJ0097
    window.open(str,'_blank','toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width=1000,height=680,left=120,top=0') //2011-10-27 DJ DJ0097
	
	
}
/// �������
/// modified by kdf 2019-03-06
function BBatchApprove_Clicked()
{
	var ValueList="";
	var objtbl = $("#tDHCEQBatchDisuseRequestFind").datagrid('getRows'); //HISUI���� add by MWZ 2018-10-10
    var rows=objtbl.length
	for (var i=0;i<rows;i++)
	{
		var TRowID=objtbl[i].TRowID
		if (TRowID=="") return;
		var ValueList = TRowID+"^"+curUserID
		var TFlag=getColumnValue(i,"TFlag")  //modified  by kdf 2019-03-06  ����ţ�836864
		if (TFlag==1) //true
		{
			var CurRole=GetElementValue("ApproveRole")
		  	if (CurRole=="") return;
		  	var RoleStepencmeth=GetElementValue("GetRoleStep")
		  	var RoleStep=cspRunServerMethod(RoleStepencmeth,TRowID,CurRole);
		  	var valuelist=TRowID+"^"+CurRole+"^"+RoleStep+"^"+"ͬ��"
		  	if (RoleStep=="") return;
		  	var encmeth=GetElementValue("AuditData")
		  	if (encmeth=="") return;
			var Rtn=cspRunServerMethod(encmeth,valuelist);
		}			
	}
	 window.location.reload();
}

/// modified by kdf 2019-03-06 
function SelectAll_Clicked(value)
{
	var SelectAll=""
	if (value==true) 
	{
		var SelectAll=1
	}
	else
	{ 
		var SelectAll=0
	}
	var objtbl = $("#tDHCEQBatchDisuseRequestFind").datagrid('getRows');
    var rows=objtbl.length;
	for (var i=0;i<rows;i++)
	{
		setColumnValue(i,"TFlag",SelectAll);
	}
}


document.body.onload = BodyLoadHandler;