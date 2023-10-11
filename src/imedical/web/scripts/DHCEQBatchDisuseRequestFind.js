/// -------------------------------
/// ��    ��:ZY  2009-08-24  No.ZY0010
/// ���Ӻ���:BAdd_Clicked()
/// �޸�����:������������
/// -------------------------------
/// ��    ��:ZY  2009-08-16  No.ZY0009
/// �޸�����:�豸�������ϲ���
/// --------------------------------
var checkedItems=[];
function BodyLoadHandler(){
	InitUserInfo();
	fillData();	
	InitPage();
	//InitTblEvt();
	initButtonWidth()  //hisui���� add by lmm 2018-08-20
	initButtonColor();		//��ʼ�����������ť��ɫ   add by jyp 2023-02-06
	initPanelHeaderStyle();  //��ʼ��������������ʽ    add by jyp 2023-02-06
	
	//czf 2022-12-28 begin
	$('#tDHCEQBatchDisuseRequestFind').datagrid({
		onLoadSuccess:function(data){
			DHCEQBatchDisuseRequestFindRowData = data;
			var o = $('#tDHCEQBatchDisuseRequestFind');
			if (data.rows && data.rows.length>0){
				for(var i=0; i<data.rows.length; i++){
					o.datagrid('beginEdit', i)
					var rowData=data.rows[i];
					var TRowID=rowData.TRowID;
					//��checkbox����¼�
					var obj = getEditorCell(i, 'TFlag','tDHCEQBatchDisuseRequestFind');
				    obj.bind('click',function(e){
					    var rtn = $(this).prop("checked");
					    var CheckedRowID = $(this).parents('td[field=TFlag]').parent().children('td[field=TRowID]').text();
					    if(rtn) addcheckItem(CheckedRowID);
					    else removeSingleItem(CheckedRowID);
				    })
				    //��ʼ��checkboxѡ��
				    for (var j = 0; j < checkedItems.length; j++) {  
				        var CheckdRowID = checkedItems[j];	//��ȡ�к�
				    	if(TRowID==CheckdRowID){
					    	obj.prop("checked",true);
					    	break;
					    }
				    } 
				}
			}
		},
	});
	$('#tDHCEQBatchDisuseRequestFind').datagrid('options').view.onAfterRender = function () {
		fixTGrid();
		SetBackGroupColor('tDHCEQBatchDisuseRequestFind');
	};
	//czf 2022-12-28 end
}

//czf 2022-12-28         
function findCheckedItem(ID) {  
    for (var i = 0; i < checkedItems.length; i++) {  
        if (checkedItems[i] == ID) return i;  
    }  
    return -1;  
}  

//czf 2022-12-28
function addcheckItem(ID) {    
    if (findCheckedItem(ID) == -1) {  
        checkedItems.push(ID);  
    }  
} 

//czf 2022-12-28
function removeSingleItem(ID) {  
	var k = findCheckedItem(ID);  
	if (k != -1) {  
	    checkedItems.splice(k, 1);  
	}  
}

function InitPage()
{
	KeyUp("RequestLoc^EquipType^Status^PurchaseType^Equip^UseLoc^Hospital","N") //���ѡ��
	Muilt_LookUp("RequestLoc^EquipType^Status^PurchaseType^Equip^UseLoc^Hospital");  //�س�ѡ��	
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
	
	//Add By QW20201223 BUG: QW0085 ���ϻ����������� begin
	var obj=document.getElementById("BMergeOrder");
	if (obj) obj.onclick=BMergeOrder_Clicked;
	var MergeOrderMode=tkMakeServerCall("web.DHCEQCommon","GetSysInfo","601007")
	var Action=GetElementValue("Action")
	if(MergeOrderMode!=Action)EQCommon_HiddenElement("BMergeOrder")
	//Add By QW20201223 BUG: QW0085 ���ϻ����������� end
	//Add By QW20210629 BUG:QW0131 Ժ�� begin
	var HosCheckFlag=tkMakeServerCall("web.DHCEQCommon","GetSysInfo","990051");
	if(HosCheckFlag=="0")
	{
		hiddenObj("cHospital",1);
		hiddenObj("Hospital",1);
	}
	//Add By QW20210629 BUG:QW0131 Ժ�� end
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
	var url="websys.default.hisui.csp?WEBSYS.TCOMPONENT=DHCEQBatchDisuseRequestFind"+val;  //hisui���� modify by lmm 2018-08-17
    if ('function'==typeof websys_getMWToken){		//czf 2023-02-14 token���ò�������
		url += "&MWToken="+websys_getMWToken()
	}
	window.location.href=url;
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
	val=val+"^WaitAD="+(GetElementValue("WaitAD")==""?"false":GetElementValue("WaitAD")); //modified by csj 2020-11-24 ��ѡ�����ػ�ȡ��ֵ�ǿմ� ����ţ�1590702
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
	val=val+"^Action="+GetElementValue("Action");  //Add By QW202101121 BUG:QW0087 �����:1703209 �Ѿ���˵Ļ��ܵ������ȫ������ʾ�����豸��
	val=val+"^HospitalDR="+GetElementValue("HospitalDR");   //Add By QW20210629 BUG:QW0131 Ժ��
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
	val=val+"hos=Hospital="+GetElementValue("HospitalDR")+"^"; //Add By QW20210629 BUG:QW0131 Ժ��
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
    var url='dhceq.em.disusesimlpe.csp?WEBSYS.TCOMPONENT=DHCEQDisuseRequestSimple&RowID=&ApproveSetDR='+val  //hisui���� modify by lmm 2018-08-17
    if ('function'==typeof websys_getMWToken){		//czf 2023-02-14 token���ò�������
		url += "&MWToken="+websys_getMWToken()
	}
     window.location.href= url;
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
    var ApproveFlag=0;
    
    //czf 2022-12-28 begin
    var CurRole=GetElementValue("ApproveRole");
  	if (CurRole == "") return;
  	var RoleStepencmeth=GetElementValue("GetRoleStep");
  	if (RoleStepencmeth == "") return;
  	var encmeth=GetElementValue("AuditData");
  	if (encmeth == "") return;
  	
	var rows = checkedItems.length;
	if (rows<1)
	{
		messageShow('alert','info','��ʾ','δѡ�񵥾ݼ�¼!');
		return;
	}
	for (var i=0;i<rows;i++)
	{
		var TRowID=checkedItems[i];
		if (TRowID=="") continue;
		var RoleStep=cspRunServerMethod(RoleStepencmeth,TRowID,CurRole);
	  	var valuelist = TRowID+"^"+CurRole+"^"+RoleStep+"^"+"ͬ��";
	  	if (RoleStep == "") return;
		var ValueList = TRowID+"^"+curUserID;
		var Rtn=cspRunServerMethod(encmeth,valuelist);
		ApproveFlag=1;
	}
	//czf 2022-12-28 end
	if (ApproveFlag==0)
	{
		messageShow('alert','info','��ʾ','δѡ�񵥾ݼ�¼!');
	}
	else
	{
		window.location.reload();
	}
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
		//czf 2022-12-28 begin
		if(SelectAll){
			//ѡ��
			addcheckItem(objtbl[i].TRowID);
	    }else{
		    //ȡ��ѡ��
		    removeSingleItem(objtbl[i].TRowID);
		}
		//czf 2022-12-28 end
	}
}
//Add By QW20201223 BUG: QW0085 ���ϻ����������밴ť����
function BMergeOrder_Clicked()
{
		var url="dhceq.em.mergeorder.csp?&RowID=&SourceType=34&SubType=1"
	showWindow(url,"��������","","","icon-w-paper","modal","","","large"); 
}
//Add By QW20210629 BUG:QW0131 Ժ��
function GetHospital(value)
{
	GetLookUpID("HospitalDR",value); 			
}
document.body.onload = BodyLoadHandler;
