var t=[]
t[-9201]="����Ϊ��"	//add by csj 20190508
jQuery(document).ready
(
	function()
	{
		setTimeout("initDocument();",50);
	}
)
function initDocument()
{
	setRequiredElements("Equip^MaintDate")	//modify by lmm 2020-05-11
	initButtonWidth();
	initLookUp();
	initTopPanel();
	FillData();
	FillEquipData();
	SetEnabled();
	defindTitleStyle();
}

//��ʼ����ѯͷ���
function initTopPanel()
{

	jQuery("#BUpdate").on("click", BUpdate_Click);
	jQuery("#BSubmit").on("click", BSubmit_Click);
	jQuery("#BDelete").on("click", BDelete_Click);
	jQuery("#BCancelSubmit").on("click", BCancelSubmit_Click);
	jQuery("#BPicture").on("click", BPicture_Click);
	jQuery("#BPMReport").on("click", BPMReport_Click);
	jQuery("#BFeeInfo").on("click", BFeeInfo_Click);	//Mozy0252	826991		2020-3-3
	//add by csj 20181129 ��ѡ�豸��ѡ�ƻ�
	$("#PlanName").lookup({"onBeforeShowPanel":function(){
	    if ($("#EquipDR").val()=="") {
	        messageShow("popover","","","����ѡ���豸!");
	        setElement("PlanName","");
	        setFocus("Equip");
	    	return false;    
	    }
	}
	});
}

/*
 *Description:�����Ч����
 *author:limm
*/
function CheckInvalidData()
{
	if (IsValidateNumber(getElementValue("MaintFee"),1,1,0,1)==0)
	{
		alertShow("�������������쳣,������.");
		return true;
	}
	return false;
}

/*
 *Description:������¼�����ַ���
 *author:limm
*/
function GetMaintInfoList()
{
	var combindata="";	
	combindata=getElementValue("RowID") ; //1
	combindata=combindata+"^"+getElementValue("EquipDR") ; //2
	combindata=combindata+"^"+getElementValue("BussType") ; //3
	combindata=combindata+"^"+getElementValue("PlanNameDR") ; //4
	combindata=combindata+"^"+getElementValue("MaintTypeDR") ; //5
	combindata=combindata+"^"+getElementValue("MaintDate") ; //6
	combindata=combindata+"^"+getElementValue("MaintLocDR") ; //7
	combindata=combindata+"^"+getElementValue("MaintUserDR") ; //8
	combindata=combindata+"^"+getElementValue("MaintModeDR") ; //9
	combindata=combindata+"^"+getElementValue("TotalFee") ; //10
	combindata=combindata+"^"+getElementValue("NormalFlag") ; //11
	combindata=combindata+"^"+getElementValue("ManageLocDR") ; //12
	combindata=combindata+"^"+getElementValue("UseLocDR") ; //13
	combindata=combindata+"^"+getElementValue("Status") ; //14
	combindata=combindata+"^"+getElementValue("Remark") ; //15
	/*
	combindata=combindata+"^"+getElementValue("UpdateUserDR") ; //
	combindata=combindata+"^"+getElementValue("UpdateDate") ; //
	combindata=combindata+"^"+getElementValue("UpdateTime") ; //
	combindata=combindata+"^"+getElementValue("AuditUserDR") ; //
	combindata=combindata+"^"+getElementValue("AuditDate") ; //
	combindata=combindata+"^"+getElementValue("AuditTime") ; //
	combindata=combindata+"^"+getElementValue("SubmitUserDR") ; //
	combindata=combindata+"^"+getElementValue("SubmitDate") ; //
	combindata=combindata+"^"+getElementValue("SubmitTime") ; //*/
	combindata=combindata+"^"+getElementValue("MaintFee") ; //16
	combindata=combindata+"^"+getElementValue("ContractDR") ; //17  Hold1��Ϊ��ͬ  modify by lmm 2020-04-29 1279496
	combindata=combindata+"^"+getElementValue("Hold2") ; //18
	combindata=combindata+"^"+getElementValue("Hold3") ; //19
	combindata=combindata+"^"+getElementValue("Hold4") ; //20
	combindata=combindata+"^"+getElementValue("Hold5") ; //21
	combindata=combindata+"^"+getElementValue("MeasureFlag") ; //22
	combindata=combindata+"^"+getElementValue("MeasureDeptDR") ; //23
	combindata=combindata+"^"+getElementValue("MeasureHandler") ; //24
	combindata=combindata+"^"+getElementValue("MeasureTel") ; //25
	combindata=combindata+"^"+getElementValue("MeasureUsers") ; //26
	combindata=combindata+"^"+getElementValue("ServiceDR") ; //27
	combindata=combindata+"^"+getElementValue("ServiceHandler") ; //28
	combindata=combindata+"^"+getElementValue("ServiceTel") ; //29
	combindata=combindata+"^"+getElementValue("ServiceUsers") ; //30
	combindata=combindata+"^"+getElementValue("InvalidFlag") ; //31
	combindata=combindata+"^"+getElementValue("CertificateValidityDate") ; //32
	combindata=combindata+"^"+getElementValue("CertificateNo") ; //33	Mozy0193	20170817
	combindata=combindata+"^"+getElementValue("PlanExecuteDR") ; //34	add by csj 20191018 �ƻ�ִ�е�ID

	/*
	combindata=combindata+"^"+getElementValue("DelUserDR") ; //
	combindata=combindata+"^"+getElementValue("DelDate") ; //
	combindata=combindata+"^"+getElementValue("DelTime") ; //*/
	//alertShow(combindata)
	return combindata;
}
/*
 *Description:������¼�������
 *author:limm
*/

function FillData()
{
	//modified by csj 20191022�˴�Ϊȡ̨��(����)��Ϣ�����豸����ת�ƻὫ��ǰά����¼���Ҹ���
	//modified by mwz 1135595 ע�ʹ���ע�ͺ�δ����豸��ʹ�ÿ��ҡ���ȡ��ע�͡�
	var EquipDR=getElementValue("EquipDR");
	if (EquipDR!="")
	{
		$cm({
			ClassName:"web.DHCEQ.EM.BUSEquip",
			MethodName:"GetOneEquip",
			RowID:EquipDR
		},function(jsonData){
			if (jsonData.SQLCODE<0) {$.messager.alert(jsonData.Data);return;}
    			setElement("Equip",jsonData.Data["EQName"]);
				setElement("UseLocDR",jsonData.Data["EQUseLocDR"]);
				setElement("UseLoc",jsonData.Data["EQUseLocDR_CTLOCDesc"]);
		});
	}
	var RowID=getElementValue("RowID");
  	if (RowID=="") return;
	var list = tkMakeServerCall("web.DHCEQ.EM.BUSMaint", "GetOneMaint",RowID);
//	list=list.replace(/\ +/g,"")	//modified by csj 2020-03-28 ��������1247380 ��Ա���ո����
	list=list.replace(/[\r\n]/g,"")	//ȥ���س�����
	list=list.split("^");


	var sort=42;
	setElement("EquipDR",list[0]);
	setElement("BussType",list[1]);
	setElement("PlanNameDR",list[2]);
	setElement("MaintTypeDR",list[3]);
	setElement("MaintDate",list[4]);
	setElement("MaintLocDR",list[5]);
	setElement("MaintUserDR",list[6]);
	setElement("MaintModeDR",list[7]);
	setElement("TotalFee",list[8]);
	//if(list[9]=="Y") $("#NormalFlag").prop("checked","checked")
	setElement("NormalFlag",list[9]);
	setElement("ManageLocDR",list[10]);
	setElement("UseLocDR",list[11]);
	setElement("Status",list[12]);
	setElement("Remark",list[13]);
	/*
	setElement("UpdateUserDR",list[0]);
	setElement("UpdateDate",list[0]);
	setElement("UpdateTime",list[0]);
	setElement("AuditUserDR",list[0]);
	setElement("AuditDate",list[0]);
	setElement("AuditTime",list[0]);
	setElement("SubmitUserDR",list[0]);
	setElement("SubmitDate",list[0]);
	setElement("SubmitTime",list[0]);
	*/
	setElement("MaintFee",list[23]);
	setElement("ContractDR",list[24]);   //Hold1��Ϊ��ͬ modify by lmm 2020-04-29 1279496
	setElement("Contract",list[sort+20]);   //modify by lmm 2020-04-29 1279496
	setElement("Hold2",list[25]);
	setElement("Hold3",list[26]);
	setElement("Hold4",list[27]);
	setElement("Hold5",list[28]);
	setElement("MeasureFlag",list[17]);
	//if(list[29]=="Y") $("#MeasureFlag").prop("checked","checked")
	setElement("MeasureDeptDR",list[30]);
	setElement("MeasureHandler",list[31]);
	setElement("MeasureTel",list[32]);
	setElement("MeasureUsers",list[33],"text");
	setElement("ServiceDR",list[34]);
	setElement("ServiceHandler",list[35]);
	setElement("ServiceTel",list[36]);
	setElement("ServiceUsers",list[37]);
	setElement("InvalidFlag",list[38]);
	//if(list[38]=="Y") $("#InvalidFlag").prop("checked","checked")
	/*
	setElement("DelUserDR",list[0]);
	setElement("DelDate",list[0]);
	setElement("DelTime",list[0]);*/
	setElement("Equip",list[sort+0])
	setElement("PlanName",list[sort+2])
	setElement("MaintType",list[sort+3])
	setElement("MaintLoc",list[sort+4])
	setElement("MaintUser",list[sort+5])
	setElement("MaintMode",list[sort+6])
	setElement("ManageLoc",list[sort+7])
	setElement("UseLoc",list[sort+8])
	setElement("MeasureDept",list[sort+13])
	setElement("Service",list[sort+14])
	setElement("CertificateValidityDate",list[sort+16])
	setElement("CertificateNo",list[sort+17])	//Mozy0193	20170817 
	setElement("PlanExecuteDR",list[sort+18])	//add by csj 20181103 �ƻ�ִ��DR
	setElement("PlanExecute",list[sort+19])		//add by csj 20181103 �ƻ�ִ�е���
	//modified by csj 20191018 ��������ִ�е���
	if(getElementValue("PlanExecuteDR")=="") { 
		disableElement("PlanExecute",true);
	}else{
		disableElement("PlanExecute",false);
	}
	//setElement("ModelDR",list[sort+17])
	//setElement("Model",list[sort+18])
	
}
/*
 *Description:�豸�������
 *author:csj
*/
function FillEquipData()
{
	$("#Banner").attr("src",'dhceq.plat.banner.csp?&EquipDR='+getElementValue("EquipDR"))
}


/*
 *Description:��ť�һ��¼�
 *author:limm
*/
function SetEnabled()
{
	
	var Status=getElementValue("Status");
	if (Status=="")
	{
		jQuery("#BDelete").linkbutton("disable")
		jQuery("#BSubmit").linkbutton("disable")
		jQuery("#BCancelSubmit").linkbutton("disable")
		jQuery("#BPicture").linkbutton("disable")
		jQuery("#BPMReport").linkbutton("disable")
		jQuery("#BMaintPlanItem").linkbutton("disable")
		jQuery("#BFeeInfo").linkbutton("disable")	//Mozy0252	826991		2020-3-3
		jQuery("#BCancelSubmit").unbind();
		jQuery("#BSubmit").unbind();
		jQuery("#BDelete").unbind();
		jQuery("#BPicture").unbind();
		jQuery("#BPMReport").unbind();
		jQuery("#BMaintPlanItem").unbind();
		jQuery("#BFeeInfo").unbind();	//Mozy0252	826991		2020-3-3
		
	}
	else if (Status=="0")
	{
		jQuery("#BCancelSubmit").linkbutton("disable")
		jQuery("#BCancelSubmit").unbind();
	}
	//add by lmm 2018-11-09 begin 612401
	else if (Status=="2")
	{
		jQuery("#BUpdate").linkbutton("disable")
		jQuery("#BDelete").linkbutton("disable")
		jQuery("#BSubmit").linkbutton("disable")
		jQuery("#BUpdate").unbind();
		jQuery("#BDelete").unbind();
		jQuery("#BSubmit").unbind();
	}	
	//add by lmm 2018-11-09 end 612401
	else 
	{
		
		jQuery("#BUpdate").linkbutton("disable")
		jQuery("#BDelete").linkbutton("disable")
		jQuery("#BSubmit").linkbutton("disable")
		jQuery("#BCancelSubmit").linkbutton("disable")
		jQuery("#BUpdate").unbind();
		jQuery("#BDelete").unbind();
		jQuery("#BSubmit").unbind();
		jQuery("#BCancelSubmit").unbind();
		
	}
	//add by lmm 2019-08-28 begin 991853
	var ReadOnly=getElementValue("ReadOnly")
	if (ReadOnly=="1")
	{
		jQuery("#BUpdate").linkbutton("disable")
		jQuery("#BDelete").linkbutton("disable")
		jQuery("#BSubmit").linkbutton("disable")
		jQuery("#BCancelSubmit").linkbutton("disable")
		jQuery("#BUpdate").unbind();
		jQuery("#BDelete").unbind();
		jQuery("#BSubmit").unbind();
		jQuery("#BCancelSubmit").unbind();
		
	}	
	//add by lmm 2019-08-28 end
	
}


/*
 *Description:���汣����¼
 *author:limm
*/
function BUpdate_Click()
{
	if (checkMustItemNull()) return;	//add by csj 20190508
	//checkMustItemNull();
	if(CheckInvalidData()) return;
	var combindata=GetMaintInfoList();
	var Rtn = tkMakeServerCall("web.DHCEQ.EM.BUSMaint", "SaveData",combindata);
	if (Rtn<0) 
	{
		alertShow("����ʧ�ܣ�");
		return;	
	}
	alertShow("����ɹ���");  //add by lmm 2020-04-26 1293295
	if ((getElementValue("BussType")==2)&&(getElementValue("MaintTypeDR")==5))
	{
		var url="dhceq.em.meterage.csp?";
	}
	else if (getElementValue("BussType")==1)
	{
		var url="dhceq.em.maint.csp?";
	}	
	else
	{
		var url="dhceq.em.inspect.csp?";
	}
    window.location.href= url+"?&RowID="+Rtn+"&EquipDR="+getElementValue("EquipDR")+"&BussType="+getElementValue("BussType")+"&MaintTypeDR="+getElementValue("MaintTypeDR");
	
}
/*
 *Description:������¼�ύ�¼�
 *author:limm
*/
function BSubmit_Click()
{
	
	var RowID=getElementValue("RowID");
  	if (RowID=="") return;
	//var MaintPlanDR=getElementValue("MaintPlanDR");
	var EquipDR=getElementValue("EquipDR");
	var PlanNameDR=getElementValue("PlanNameDR"); 
	var PERowID=getElementValue("PlanExecuteDR");
	//var Remark=getElementValue("Remark");
	var MaintDate=getElementValue("MaintDate");
	var BussType=getElementValue("BussType");
	if (MaintDate=="")
	{
		alertShow("������ڲ���Ϊ�գ�");
		return;
	}
	//modified by csj 2019-10-18
	//modify by lmm 2020-04-03
	if (PERowID!="")
	{
		//var truthBeTold = window.confirm("�����ȷ����ִ���ϴμƻ�ִ�У������ȡ���������ֹ���¼");	
		//if (!truthBeTold) var PERowID="";
		messageShow("confirm","","","�����ȷ����ִ���ϴμƻ�ִ�У������ȡ���������ֹ���¼","",function(){
		//add by lmm 2020-05-07 begin 1301246
			SubmitData(RowID,PERowID,BussType,EquipDR,"N")  
			},
			function(){
				//var PERowID="";  //add by lmm 2020-05-06 1301246
				SubmitData(RowID,PERowID,BussType,EquipDR,"Y")
				
			});
	}
	else
	{
		SubmitData(RowID,PERowID,BussType,EquipDR,"Y")
	}
}
//add by lmm 2020-05-07 1301246 ������� CancelFlag
function SubmitData(RowID,PERowID,BussType,EquipDR,CancelFlag){	
	//PERowID, MaintRowID, EquipID, BussType
	var Rtn = tkMakeServerCall("web.DHCEQ.EM.BUSMaint", "SubmitData",RowID,PERowID,BussType,EquipDR,"",CancelFlag);
	if (Rtn<0) 
	{
		alertShow("����ʧ�ܣ�");
		return;	
	}
	if ((getElementValue("BussType")==2)&&(getElementValue("MaintTypeDR")==5))
	{
		var url="dhceq.em.meterage.csp?";
	}
	else if (getElementValue("BussType")==1)
	{
		var url="dhceq.em.maint.csp?";
	}	
	else
	{
		var url="dhceq.em.inspect.csp?";
	}
    window.location.href= url+"?&RowID="+Rtn+"&EquipDR="+getElementValue("EquipDR")+"&BussType="+getElementValue("BussType")+"&MaintTypeDR="+getElementValue("MaintTypeDR");
	
}
/*
 *Description:������¼ɾ���¼�
 *author:limm
*/

function BDelete_Click()
{
	var RowID=getElementValue("RowID");
  	if (RowID=="") return;
	messageShow("confirm","","","��ȷ��Ҫɾ���ü�¼��?","",DeleteData,"");
}

function DeleteData()
{
	var RowID=getElementValue("RowID");   //add by lmm 2020-04-24 1290177
	var Rtn = tkMakeServerCall("web.DHCEQ.EM.BUSMaint","DeleteData",RowID);
	
	if (Rtn!=0) 
	{
		alertShow("���治�ɹ���");
		return;	
	}
	if ((getElementValue("BussType")==2)&&(getElementValue("MaintTypeDR")==5))
	{
		var url="dhceq.em.meterage.csp?";
	}
	else if (getElementValue("BussType")==1)
	{
		var url="dhceq.em.maint.csp?";
	}	
	else
	{
		var url="dhceq.em.inspect.csp?";
	}
	window.location.href= url+"?&BussType="+getElementValue("BussType")+"&MaintTypeDR="+getElementValue("MaintTypeDR");
}
/*
 *Description:������¼�����¼�
 *author:limm
*/
function BCancelSubmit_Click()
{

	var RowID=getElementValue("RowID");
  	if (RowID=="") return;	
	var Rtn = tkMakeServerCall("web.DHCEQ.EM.BUSMaint","CancelSubmitData",RowID);	
	if (Rtn<0) 
	{
		alertShow("״̬�Ѿ�Ϊ�ύ!");
		return;	
	}
	if ((getElementValue("BussType")==2)&&(getElementValue("MaintTypeDR")==5))
	{
		var url="dhceq.em.meterage.csp?";
	}
	else if (getElementValue("BussType")==1)
	{
		var url="dhceq.em.maint.csp?";
	}	
	else
	{
		var url="dhceq.em.inspect.csp?";
	}
    window.location.href= url+"?&BussType="+getElementValue("BussType")+"&MaintTypeDR="+getElementValue("MaintTypeDR");		//2011-08-29 HZY0005 

	
}
/*
 *Description:ͼƬ�ϴ����ӽ���
 *author:limm
*/
function BPicture_Click()
{
	if (getElementValue("RowID")=="") return; 
	if (getElementValue("EquipDR")=="") {alertShow("��ѡ���豸");return}
	var Status=getElementValue("Status")
	//modify by lmm 2020-05-19 1319957
	var str='dhceq.plat.picturemenu.csp?&CurrentSourceType=32&CurrentSourceID='+getElementValue("EquipDR")+'&EquipDR='+getElementValue("EquipDR");	//modified by lmm 2020-04-27 1282940
	showWindow(str,"�ϴ�ͼƬ","","","icon-w-paper","modal","","","middle"); //modify by lmm 2020-06-05 UI
}
/*
 *Description:pm�����ӡ���ӽ���
 *author:limm
*/
function BPMReport_Click()
{
	if (getElementValue("RowID")=="") return; 
	if (getElementValue("EquipDR")=="") {alertShow("��ѡ���豸");return}
	var Status=getElementValue("Status")
	var ReadOnly=getElementValue("ReadOnly")
	var str='dhceq.em.pmreport.csp?&MaintDR='+getElementValue("RowID")+"&ReadOnly="+ReadOnly;	//modified by csj 20190524 ���������ӡcsp�����޸�
	showWindow(str,"PM�����ӡ","","","icon-w-paper","modal","","","large");   //modify by lmm 2019-02-16
	
}
/*
 Mozy0252	826991		2020-3-3
 *Description:������ϸ���ӽ���
 *author:Mozy
*/
function BFeeInfo_Click()
{
	if (getElementValue("RowID")=="") return; 
	if (getElementValue("EquipDR")=="") {alertShow("��ѡ���豸");return}
	var str='dhceqmaintfeeinfo.csp?&RowID='+getElementValue("RowID")+'&Status='+getElementValue("Status")+'&ReadOnly='+getElementValue("ReadOnly");
	showWindow(str,"������ϸ","","","icon-w-paper","modal","","","small");  //modify by lmm 2020-06-05 UI
}
/*
 *Description:�豸�������ݻص�����
 *author:limm
*/
function GetEquipID(value) 
{
	var val=value.split("^");
	setElement("EquipDR",val[0]);
	setElement("Equip",val[1]);
	setElement("UseLocDR",val[2]);
	setElement("UseLoc",val[3]);
	FillEquipData();
}


/*
 *Description:���ݼƻ������������
 *author:limm
*/
/*
function GetPlanNameID(value)
{
	var val=value.split("^");
	setElement("PlanNameDR",val[0]);
	setElement("PlanName",val[1]);
	var PlanNameDR=getElementValue("PlanNameDR")
	if (PlanNameDR=="")  return
	
	var Rtn = tkMakeServerCall("web.DHCEQ.EM.BUSMaintPlan","GetOneMaintPlan",PlanNameDR);
	
	Rtn=Rtn.replace(/\\n/g,"\n");
	var list=Rtn.split("^");
	var sort=50;	//DHC_EQMaintPlan  44
	setElement("PlanName",list[0],"text");
	setElement("ModelDR",list[4]);
	setElement("MaintTypeDR",list[8]);
	setElement("MaintFee",list[12]);
	setElement("MaintLocDR",list[13]);
	setElement("MaintUserDR",list[14]);
	setElement("MaintModeDR",list[15]);
	if(list[17]=="Y") $("#MeasureFlag").prop("checked","checked")
	setElement("MeasureDeptDR",list[18]);
	setElement("MeasureHandler",list[19]);
	setElement("MeasureTel",list[20]);
	setElement("ServiceDR",list[21]);
	setElement("ServiceHandler",list[22]);
	setElement("ServiceTel",list[23]);
	setElement("Remark",list[24]);
	if(list[35]=="Y") $("#InvalidFlag").prop("checked","checked")
	setElement("MaintType",list[sort+4]);
	setElement("MaintLoc",list[sort+5]);
	setElement("MaintUser",list[sort+6]);
	setElement("MaintMode",list[sort+7]);
	setElement("MeasureDept",list[sort+9]);
	setElement("Service",list[sort+10]);
}
*/
//add by csj 20181103�Ŵ�ѡȡ��ִ�з���
function setSelectValue(vElementID,rowData)
{
	if(vElementID=="Equip")
	{
		setElement("EquipDR",rowData.TRowID);
		setElement("Equip",rowData.TName);
		setElement("UseLocDR",rowData.TUseLocDR);
		setElement("UseLoc",rowData.TUseLoc);
		FillEquipData();
	}
	else if(vElementID=="PlanName")
	{
		setElement("PlanNameDR",rowData.TRowID);
		setElement("PlanName",rowData.TName);
		var PlanNameDR=getElementValue("PlanNameDR")
		if (PlanNameDR=="")  return
		var Rtn = tkMakeServerCall("web.DHCEQ.EM.BUSMaintPlan","GetOneMaintPlan",PlanNameDR);
		
		Rtn=Rtn.replace(/\\n/g,"\n");
		var list=Rtn.split("^");
		var sort=50;	//DHC_EQMaintPlan  44
		setElement("PlanName",list[0]);
		setElement("ModelDR",list[4]);
		setElement("MaintTypeDR",list[8]);
		setElement("MaintFee",list[12]);
		setElement("MaintLocDR",list[13]);
		setElement("MaintUserDR",list[14]);
		setElement("MaintModeDR",list[15]);
		setElement("MeasureFlag",list[17]);
		//if(list[17]=="Y") $("#MeasureFlag").prop("checked","checked");
		setElement("MeasureDeptDR",list[18]);
		setElement("MeasureHandler",list[19]);
		setElement("MeasureTel",list[20]);
		setElement("ServiceDR",list[21]);
		setElement("ServiceHandler",list[22]);
		setElement("ServiceTel",list[23]);
		setElement("Remark",list[24]);
		setElement("InvalidFlag",list[35]);
		//if(list[35]=="Y") $("#InvalidFlag").prop("checked","checked");
		//setElement("FixTimeFlag",list[46]); //add by csj 20181127
		setElement("MaintType",list[sort+4]);
		setElement("MaintLoc",list[sort+5]);
		setElement("MaintUser",list[sort+6]);
		setElement("MaintMode",list[sort+7]);
		setElement("MeasureDept",list[sort+9]);
		setElement("Service",list[sort+10]);
		//modified by csj 20191018 �����мƻ�ִ�е�
//		if(list[46]!="Y") {
//			disableElement("PlanExecute",true);
//		}else{
//			disableElement("PlanExecute",false);
//		}
	}
	else if(vElementID=="PlanExecute")
	{
		setElement("PlanExecuteDR",rowData.TPlanExecuteID);	//modified by csj 20191018
		setElement("PlanExecute",rowData.TPlanExecuteNo);
	}
	else if(vElementID=="MaintType")
	{
		setElement("MaintTypeDR",rowData.TRowID);
		setElement("MaintType",rowData.TDesc);
	}
	else if(vElementID=="MaintMode")
	{
		setElement("MaintModeDR",rowData.TRowID);
		setElement("MaintMode",rowData.TDesc);
	}
	else if(vElementID=="MaintUser")
	{
		setElement("MaintUserDR",rowData.TRowID);
		setElement("MaintUser",rowData.TName);//modified by csj 20190111
	}
	else if(vElementID=="MaintLoc")
	{
		setElement("MaintLocDR",rowData.TRowID);
		setElement("MaintLoc",rowData.TName);
	}
	else if(vElementID=="UseLoc")
	{
		setElement("UseLocDR",rowData.TRowID);
		setElement("UseLoc",rowData.TName);
	}
	else if(vElementID=="Service")
	{
		setElement("ServiceDR",rowData.TRowID);
		setElement("Service",rowData.TDescription);
		setElement("ServiceHandler",rowData.TContPerson);	//add by yh 20191121 ���ݷ������Զ�������ϵ��
		setElement("ServiceTel",rowData.TTel);			//add by yh 20191121 ���ݷ������Զ�������ϵ�绰
	}
	//add by lmm 2020-05-08 1307160
	else if(vElementID=="Contract")
	{
		setElement("ContractDR",rowData.TRowID);
		setElement("Contract",rowData.TContractName);
		setElement("EquipDR","");
		setElement("Equip","");
		setElement("UseLocDR","");
		setElement("UseLoc","");
		
	}
	//add by lmm 2020-04-29 1279496
	else
	{
		setElement(vElementID+"DR",rowData.TRowID);
	}
}

//add by csj 20181103 onChange����¼�
function clearData(vElementID)
{
	if($("#"+vElementID+"DR").length>0)
	{
		setElement(vElementID+"DR","");	//ͳһ���DR
		
		if(vElementID=="Equip")
		{
			setElement("UseLocDR","")
			setElement("UseLoc","")
			FillEquipData()
		}
		else if(vElementID=="PlanName")
		{
			setElement("ModelDR","");
			setElement("MaintTypeDR","");
			setElement("MaintFee","");
			setElement("MaintLocDR","");
			setElement("MaintUserDR","");
			setElement("MaintModeDR","");
			setElement("MeasureDeptDR","");
			setElement("MeasureHandler","");
			setElement("MeasureTel","");
			setElement("ServiceDR","");
			setElement("ServiceHandler","");
			setElement("ServiceTel","");
			setElement("Remark","");
			setElement("MaintType","");
			setElement("MaintLoc","");
			setElement("MaintUser","");
			setElement("MaintMode","");
			setElement("MeasureDept","");
			setElement("Service","");
		}
	}
}
