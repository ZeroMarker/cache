//װ��ҳ��  �������ƹ̶�
function BodyLoadHandler() {
    initPanelHeaderStyle() //added by LMH 20230211 UI �������������������ʽ
	initButtonColor(); //added by LMH 20230210 UI ��ʼ����ť��ɫ
	//showBtnIcon('BAdd^BUpdate^BDelete^BFind',false); //modified by LMH 20230211 ��̬�����Ƿ񼫼���ʾ��ťͼ��
	//initButtonWidth();///Add By QW 2018-08-31 HISUI����:�޸İ�ť����
	setButtonText();///Add By QW 2018-09-29 HISUI����:��ť���ֹ淶
	InitPage();
	ChangeStatus(false);
	InitUserInfo();
	//SetLink();
	initEquipType();	//add by sjh SJH0042 2020-12-16 �����Ϊ��ѡ start	
	var EquipTypeDR=GetElementValue("EquipTypeDR");
	if (EquipTypeDR.indexOf(",")>-1)
	{
		EquipTypeDR=EquipTypeDR.split(",")
	}
	$("#EquipType").combogrid("setValues",EquipTypeDR); //add by sjh SJH0042 2020-12-16  end
	initBDPHospComponent("DHC_EQCApproveSet");	//CZF0138 ��Ժ������
}

//CZF0138 ƽ̨ҽԺ���ѡ���¼�
function onBDPHospSelectHandler()
{
	BClear_Clicked();
	initApproveSetGrid();
}

//CZF0138
function initApproveSetGrid()
{
	var HospDR=GetBDPHospValue("_HospList");
	$("#tDHCEQCApproveSet").datagrid( {
		url:$URL,
		queryParams:{
			ComponentID:GetElementValue("GetComponentID"),
			gHospId:curSSHospitalID,
			BDPHospId:HospDR
		},
		showRefresh:false,
		showPageList:false,
		afterPageText:'',
		beforePageText:''
	})
}

function SetLink()
{
	var SelRowObj;
	var objtbl=document.getElementById('tDHCEQCApproveSet');
	var rows=objtbl.rows.length;
	return;
	for (var i=1;i<rows;i++)
	{
		SelRowObj=document.getElementById('TApproveFlowz'+i);
		if (SelRowObj)
		{
		SelRowObj.onclick=lnk_Click;//����
		SelRowObj.href="#";
		}
	}	
}
function lnk_Click()
{
	var eSrc=window.event.srcElement;	//��ȡ�¼�Դͷ
	var row=GetRowByColName(eSrc.id);//����
	var lnk=GetHref(row);//����
    window.open(lnk,'_blank','toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width=590,height=460,left=420,top=0');
}
function GetRowByColName(colname)
{
	var offset=colname.lastIndexOf("z");
	var row=colname.substring(offset+1);
	return row;
}
function GetHref(row)
{
	var RowIDobj=document.getElementById('TRowIDz'+row);
	var RowID=RowIDobj.value;
	var lnk="";
    lnk='websys.default.hisui.csp?WEBSYS.TCOMPONENT=DHCEQCApproveFlow&ApproveSetDR='+RowID;	
	return lnk;
}

function InitPage(){
	var BAobj=document.getElementById("BAdd");
	if (BAobj) BAobj.onclick=BUpdate_click;
	var BUobj=document.getElementById("BUpdate");
	if (BUobj) BUobj.onclick=BUpdate_click;
	var BDobj=document.getElementById("BDelete");
	if (BDobj) BDobj.onclick=BDelete_click;
	var BFobj=document.getElementById("BFind");   // add by myl 2022-03-08 ���Ӳ�ѯ��ť
	if (BFobj) BFobj.onclick=BFind_Click;
	
	KeyUp("EquipType^PurchaseType^SpecialType^ApproveType","N");
	Muilt_LookUp("EquipType^PurchaseType^SpecialType^ApproveType");
}
//�����������������,�������ƹ̶�
///Modify By QW 2018-08-31 HISUI���죺���ѡ���к󣬽����޷������������
///�����������index,rowdata�������������޸��ж��߼�
var SelectedRow = -1;
function SelectRowHandler(index,rowdata)	{
    if(index==SelectedRow)
    {
	    BClear_Clicked();		//CZF0138
		return;
	 }
	ChangeStatus(true);
	FillData(rowdata.TRowID)
	SelectedRow = index
}
///Modify By QW 2018-08-31 HISUI���죺���ѡ���к󣬽����޷������������
///�޸�FillData�����Ĵ������
function FillData(RowID)
{
	SetElement("RowID",RowID);
	var obj=document.getElementById("fillData");
	if (obj){var encmeth=obj.value} else {var encmeth=""};
	var ReturnList=cspRunServerMethod(encmeth,RowID);
	ReturnList=ReturnList.replace(/\\n/g,"\n");
	Fill(ReturnList)
}
function Fill(ReturnList)
{
	list=ReturnList.split("^");
	var sort=11;
	SetElement("ApproveTypeDR",list[0]);
	SetElement("Desc",list[1]);
	SetElement("Code",list[2]);
	//SetElement("EquipTypeDR",list[3]);
	SetElement("PurchaseTypeDR",list[4]);
	SetElement("SpecialTypeDR",list[5]);
	SetElement("SingleMinFee",list[6]);
	SetElement("SingleMaxFee",list[7]);
	SetChkElement("AutoAuditFlag",list[8]);
	SetElement("YearFlag",list[9]);
	//SetElement("EquipType",list[sort+0]);
	SetElement("PurchaseType",list[sort+1]);
	SetElement("SpecialType",list[sort+2]);
	SetElement("ApproveType",list[sort+3]);
	var EquipType=list[sort+0];      //modified by sjh SJH0042 2020-12-04  start
	if (EquipType.indexOf(",")>-1)			
	{
		EquipType=EquipType.split(",");
		$("#EquipType").combogrid("setValues",EquipType);
	}
	else
	{
		$("#EquipType").combogrid("setValue",EquipType);
	}
		 
	SetElement("EquipTypeDR",list[3]); //modified by sjh SJH0042 2020-12-04  end
	
}

// add by myl 2022-03-08 ���Ӳ�ѯ��ť����¼�
function BFind_Click()
{
	if (!$(this).linkbutton('options').disabled){
		$('#tDHCEQCApproveSet').datagrid('load',{ComponentID:getValueById("GetComponentID"),ApproveType:getValueById("ApproveType"),Desc:getValueById("Desc")});
	}
}

//���°�ť�������
function BUpdate_click()
{
	if (CheckNull()) return;
  	var MinFee=GetElementValue("SingleMinFee") ;
  	var MaxFee=GetElementValue("SingleMaxFee") ;
  	if ((MinFee<0)||(MaxFee<0))
  	{
	  	alertShow("����ȷ������С���������!")
	  	return
  	}
  	if ((MinFee!="")&&(MaxFee!="")&&(MinFee>MaxFee))
  	{
	  	alertShow("��С�����������!")
	  	return
  	}
	var val=GetValue();
	var Return=UpdateData(val,"0");
	var RtnCode=Return;				//CZF0138
	var ErrMsg="";
	if(Return.indexOf("^")>-1){
		RtnCode=Return.split("^")[0];
		ErrMsg=Return.split("^")[1];
	}
	if (RtnCode!=0)
	{
		messageShow("","","",ErrMsg+"  "+t["01"]+",�������:"+RtnCode);
	}
	else
	{
		alertShow("�����ɹ�!");
		BClear_Clicked();		//CZF0138
		$("#tDHCEQCApproveSet").datagrid('reload');
		//window.location.reload();
	}
}
function GetValue()
{
	var combindata="";
  	combindata=GetElementValue("RowID") ;
  	combindata=combindata+"^"+GetElementValue("ApproveTypeDR") ;
  	combindata=combindata+"^"+GetElementValue("Desc") ;
  	combindata=combindata+"^"+GetElementValue("Code") ;
  	//combindata=combindata+"^"+GetElementValue("EquipTypeDR") ;
  	combindata=combindata+"^"+GetElementValue("PurchaseTypeDR") ;
  	combindata=combindata+"^"+GetElementValue("SpecialTypeDR") ;
  	combindata=combindata+"^"+GetElementValue("SingleMinFee") ;
  	combindata=combindata+"^"+GetElementValue("SingleMaxFee") ;
  	combindata=combindata+"^"+GetChkElementValue("AutoAuditFlag") ;
  	combindata=combindata+"^"+GetElementValue("YearFlag") ;
  	combindata=combindata+"^"+($("#EquipType").combogrid("getValues")) //modified by sjh SJH0042 2020-12-16
	return combindata;
}
//ɾ����ť�������
function BDelete_click()
{
	var truthBeTold = window.confirm(t["02"]);
	if (!truthBeTold) return;
	var RowID=GetElementValue("RowID");
	var Return=UpdateData(RowID,"1");
	if (Return<0)
	{
		messageShow("","","",Return+"  "+t["01"]);
	}
	else
	{
		alertShow("ɾ���ɹ�!");
		BClear_Clicked();		//CZF0138
		$("#tDHCEQCApproveSet").datagrid('reload');
		//window.location.reload();
	}
}
function CheckNull()
{
	if (CheckMustItemNull()) return true;
	/*
	if (CheckItemNull(2,"Desc")) return true;
	if (CheckItemNull(1,"ApproveType")) return true;
	*/
	return false;
}
function UpdateData(val,AppType)
{
	SetElement("EquipTypeDR",$("#EquipType").combogrid("getValues")); //add by sjh SJH0042 2020-12-16  
	var encmeth=GetElementValue("upd");
	var Return=cspRunServerMethod(encmeth,val,AppType,curSSHospitalID,GetBDPHospValue("_HospList"));
	return Return;
}

/* function GetEquipType(value) {
	var user=value.split("^");
	var obj=document.getElementById("EquipTypeDR");
	obj.value=user[1];
} */
//add by sjh SJH0042 2020-12-16  �����Ϊ��ѡ  
function initEquipType()
{
		$HUI.combogrid('#EquipType',{   
	    url:$URL, 
	    queryParams:{
	        ClassName:"web.DHCEQ.Plat.CTEquipType",
	        QueryName:"GetEquipType",
	        FacilityFlag:'2'   //add by wy 2023-4-7 3455740��ʾȫ��������
	    },
	    idField:'TRowID',
		textField:'TName',
	    multiple: true,
	    rowStyle:'checkbox', 
	    selectOnNavigation:false,
	    fitColumns:true,
	    fit:true,
	    border:'true',
	    columns:[[
	    	{field:'check',checkbox:true},
	    	{field:'TRowID',title:'TRowID',width:50,hidden:true},
	        {field:'TName',title:'ȫѡ',width:150},
	    ]]
	});
}
function GetPurchaseType(value) {
	var user=value.split("^");
	var obj=document.getElementById("PurchaseTypeDR");
	obj.value=user[1];
}
function GetSpecialType(value) {
	var user=value.split("^");
	var obj=document.getElementById("SpecialTypeDR");
	obj.value=user[1];
}
function GetApproveType(value) {
	var user=value.split("^");
	var obj=document.getElementById("ApproveTypeDR");
	obj.value=user[1];
}
function ChangeStatus(Value)
{
	InitPage();
	DisableBElement("BUpdate",!Value);
	DisableBElement("BDelete",!Value);
	DisableBElement("BAdd",Value);
}

//CZF0138
//��հ�ť�����¼���ȡ��ѡ���д����¼�
function BClear_Clicked()
{
	SetElement("RowID","");
	SetElement("ApproveTypeDR","");
	SetElement("ApproveType","");
	SetElement("Desc","");
	SetElement("Code","");
	SetElement("PurchaseTypeDR","");
	SetElement("PurchaseType","");
	SetElement("SpecialType","");
	SetElement("SpecialTypeDR","");
	SetElement("SingleMinFee","");
	SetElement("SingleMaxFee","");
	SetChkElement("AutoAuditFlag","");
	SetElement("YearFlag","");
	$("#EquipType").combogrid("setValues","");	 
	SetElement("EquipTypeDR","");
	SetElement("EquipType","");
	ChangeStatus(false);
	SelectedRow=-1;
	$('#tDHCEQCApproveSet').datagrid('unselectAll');
}
//����ҳ����ط���
document.body.onload = BodyLoadHandler;
