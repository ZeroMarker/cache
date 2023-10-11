function BodyLoadHandler() 
{
	$("body").parent().css("overflow-y","hidden");  //Add By DJ 2018-10-12 hiui-���� ȥ��y�� ������
	$("#tDHCEQMMaintRequestDetail").datagrid({showRefresh:false,showPageList:false,afterPageText:'',beforePageText:''});   //Add By DJ 2018-10-12 hisui���죺���ط�ҳ������
	InitUserInfo();	
	KeyUp("ExObj^RequestLoc^AcceptUser^ObjLoc"); //modify by zyq 2022-12-09
	Muilt_LookUp("ExObj^RequestLoc^AcceptUser");
	SetStatus();
	SetTableItem();		//Add By DJ 2016-11-24
	initButtonWidth();	//hisui���� Add By DJ 2018-10-12
	initButtonColor(); //hisui���� add by zyq 2023-01-31
	initPanelHeaderStyle();//hisui���� add by zyq 2023-01-31
	initKeywords();	//Add by QW2021518 BUG:QW0111 ����״̬����
	var obj=document.getElementById("BFind");
	if (obj) obj.onclick=BFind_Clicked;
	var obj=document.getElementById("BImport");		//add by CZF0073 2020-02-24
	if(obj) obj.onclick=BImport_Click;
	var obj=document.getElementById("BSaveExcel");		//add by CZF0074 2020-02-24
	if (obj) obj.onclick=BSaveExcel_Click;
	var obj=document.getElementById("BColSet");		//add by CSJ 2020-05-28
	if (obj) obj.onclick=BColSet_Click;
	
}
//Add by QW2021518 BUG:QW0111 ����״̬����
function initKeywords()
{
	if(getElementValue("ActionItemString")!="")
	{ 
		var arr=new Array()
		var  CurData=getElementValue("ActionItemString");
		var SplitNumCode=",";
		arr= CurData.split(SplitNumCode);
		for(var i=0 ;i <arr.length;i++)
		{ 
			$("#ActionItemDetail").keywords("select",arr[i])
		}
	}
 }
///Add By QW2021518 BUG:QW0111 ��ȡ ״̬����
function getKeywordsData()
{ 
	var SelectType=$("#ActionItemDetail").keywords("getSelected");
	var ActionItemString=""
	for (var j=0;j<SelectType.length;j++)
	{
		if(ActionItemString=="")
		{
			ActionItemString=SelectType[j].id
		}else
		{
			ActionItemString=ActionItemString+","+SelectType[j].id
		}
	}
	return ActionItemString;
	
}
///Add By QW2021518 BUG:QW0111 ��ʼ�� ״̬����
$(function(){
	initActionItem();
})


///Add By QW2021518 BUG:QW0111 ��ʼ�� ״̬����
function initActionItem()
{
	var ActionItem = [];
	var Vallist=tkMakeServerCall("web.DHCEQCommon","GetBussApproveFlow","31")
	Vallist=Vallist.replace(/\\n/g,"\n");
	
	ActionItem.push({text:'����',id:'0'});
	var list=Vallist.split("&");
	for (var i=0;i<=list.length-1;i++)
	{
		var id=list[i].split(",")[0];
		var text=list[i].split(",")[2]
		ActionItem.push({text:text,id:id});
	}

    $("#ActionItemDetail").keywords({
	    	singleSelect:true,
	    	//Modify by zx 2021-07-07 BUG ZX0136 ���⻻��
	    	items:ActionItem
	});
}

function RequestLoc(value)		//Modify DJ 2016-11-30
{
	GetLookUpID('RequestLocDR',value);
}
function ObjLoc(value)		//add by zyq 2022-12-09
{
	GetLookUpID('ObjLocDR',value);
}

function GetExObj(value)
{
	GetLookUpID('ExObjDR',value);
	
}
function GetAcceptUser(value)
{
	var val=value.split("^");
	SetElement("AcceptUser",val[2]);
	SetElement("Initials",val[6]);
	GetLookUpID('AcceptUserDR',value);
}
function SetStatus()
{
	SetElement("Status",GetElementValue("GetStatus"))
}
///Add By DJ 2016-11-24
function SetTableItem()
{
	var objtbl=document.getElementById('tDHCEQMMaintRequestDetail');
	var rows=objtbl.rows.length-1;
	for (var i=1;i<=rows;i++)
	{
		var obj=document.getElementById("BEvaluatez"+i);
		obj.onclick=BEvaluate_Click
	}
}
///Add By DJ 2016-11-24
function BEvaluate_Click()
{
	var eSrc=window.event.srcElement;
	if (eSrc.tagName=="IMG") eSrc=window.event.srcElement.parentElement;
	var rowObj=getRow(eSrc);
	selectrow=rowObj.rowIndex;								//��ǰѡ����
	var RowID=GetElementValue("TRowIDz"+selectrow);
	var CurRole=GetElementValue("TCurRolez"+selectrow);
	var EvaluateGroup=GetElementValue("TEvaluateGroupz"+selectrow);
	var ReturnStr=GetElementValue("CheckEvaluatez"+selectrow);
	var SourceNo=GetElementValue("TRequestNOz"+selectrow);
	var CheckEvaluate=ReturnStr.split("^");
	if (CheckEvaluate[0]<0)
	{
		alertShow(CheckEvaluate[1]);
		return
	}
	var ReadOnly=0
	if (CheckEvaluate[0]==0) ReadOnly=1;
	//�����۴���
	var str="dhceqevaluate.csp?&SourceType=31&SourceID="+RowID+"&CurRole="+CurRole+"&EvaluateGroup="+EvaluateGroup+"&SourceNo="+SourceNo+"&ERowID="+CheckEvaluate[1]+"&ReadOnly="+ReadOnly
    window.open(str,'_blank','toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width=890,height=650,left=120,top=0')
}
//modified by csj 2020-05-28 ���������������ά��������ڲ�ѯ
//modified by sjh 2020-09-29 ������������,Status��ֵ����
/* function BFind_Clicked()
{
	var CurGroupStr=GetElementValue("CurGroupID")
	var CurGroupInfo=CurGroupStr.split("^")
	var val="";
	//val="&Status="+GetElementValue("Status");
	val="&ExObjDR="+GetElementValue("ExObjDR");
	val=val+"&RequestLocDR="+GetElementValue("RequestLocDR");
	val=val+"&StartDate="+GetElementValue("StartDate");
	val=val+"&EndDate="+GetElementValue("EndDate");
	val=val+"&QXType="+GetElementValue("QXType");
	val=val+"&RequestNo="+GetElementValue("RequestNo");
	if (GetChkElementValue("InvalidFlag")==true)
	{
		val=val+"&InvalidFlag=Y"
	}
	else
	{
		val=val+"&InvalidFlag=N"
	}
	val=val+"&AcceptUserDR="+GetElementValue("AcceptUserDR");
	val=val+"&CurUser="+GetElementValue("CurUser");
	val=val+"&ExObj="+GetElementValue("ExObj");
	val=val+"&FinishFlag="+GetElementValue("FinishFlag");
	val=val+"&LeaderFlag="+GetElementValue("LeaderFlag");
	val=val+"&UserLocDR="+GetElementValue("UserLocDR");
	val=val+"&CurLocID="+curLocID;
	val=val+"&CurGroupID="+CurGroupInfo[0]+"^"+CurGroupInfo[1]+"^"+CurGroupInfo[2]+"^"+GetElementValue("Status")+"^"+GetElementValue("WaitAD");
	val=val+"&WaitAD="+GetElementValue("WaitAD");
	val=val+"&AcceptUser="+GetElementValue("AcceptUser");
	val=val+"&TMENU="+GetElementValue("TMENU");
	val=val+"&FinishStartDate="+GetElementValue("FinishStartDate")
	val=val+"&FinishEndDate="+GetElementValue("FinishEndDate")
	val=val+"&vData=^CurGroupID="+CurGroupInfo[0]+"^"+CurGroupInfo[1]+"^"+CurGroupInfo[2]+"^"+GetElementValue("Status")+"^"+GetElementValue("WaitAD");
	val=val+"^FinishStartDate="+GetElementValue("FinishStartDate")
	val=val+"^FinishEndDate="+GetElementValue("FinishEndDate")
	val=val+"^Status="+GetElementValue("Status")
	window.location.href= 'websys.default.hisui.csp?WEBSYS.TCOMPONENT=DHCEQMMaintRequestDetail'+val;
} */

//modified by sjh SJH0044 2021-01-26 �޸Ĳ�ѯ��ʽ
function BFind_Clicked()
{
	if (!$(this).linkbutton('options').disabled){
		
		var CurGroupStr=GetElementValue("CurGroupID");
		var CurGroupInfo=CurGroupStr.split("^");
		if (GetChkElementValue("InvalidFlag")==true)
		{
			var invalidflag="Y";
		}
		else
		{
			var invalidflag="N";
		}
		//modified by wy 2022-5-5 WY0099 ά����ϸ��ѯ����ȡֵ
		var curGroupID="^vCurGroupID="+CurGroupInfo[0]+"^vCurRole="+CurGroupInfo[1]+"^vEvaluateGroup="+CurGroupInfo[2]+"^vStatus="+GetElementValue("Status")+"^WaitAD="+GetElementValue("WaitAD");
		var vdata=curGroupID+"^FinishStartDate="+GetElementValue("FinishStartDate")+"^FinishEndDate="+GetElementValue("FinishEndDate");	
		//Add By QW2021518 BUG:QW0111  ״̬���� Begin
		if (GetElementValue("ActionItemString")=="")
		{
			vdata=vdata+"^ActionItemString="+getKeywordsData();
		}
		else
		{
			vdata=vdata+"^ActionItemString="+GetElementValue("ActionItemString")
			
		}
		vdata=vdata+"^ApproveSDate="+GetElementValue("ApproveSDate");
		vdata=vdata+"^ApproveEDate="+GetElementValue("ApproveEDate");
		vdata=vdata+"^FeeType="+GetElementValue("FeeType");  /// Modefied by zc0125 2022-11-18 ���ӷ������Ͳ�ѯ����
		vdata=vdata+"^RequestUserDR="+GetElementValue("RequestUserDR");  /// Modefied by zc0125 2022-11-18 ���ӱ����˲�ѯ����
		//modified by zyq 2022-12-09
		$('#tDHCEQMMaintRequestDetail').datagrid('load',{ComponentID:getValueById("GetComponentID"),ExObjDR:getValueById("ExObjDR"),RequestLocDR:getValueById("RequestLocDR"),StartDate:$('#StartDate').datebox("getValue"),EndDate:$('#EndDate').datebox("getValue"),QXType:getValueById("QXType"),RequestNo:getValueById("RequestNo"),InvalidFlag:invalidflag,AcceptUserDR:getValueById("AcceptUserDR"),CurUser:getValueById("CurUser"),ExObj:getValueById("ExObj"),FinishFlag:getValueById("FinishFlag"),LeaderFlag:getValueById("LeaderFlag"),UserLocDR:getValueById("UserLocDR"),CurLocID:curLocID,WaitAD:getValueById("WaitAD"),AcceptUser:getValueById("AcceptUser"),TMENU:getValueById("TMENU"),ObjLocDR:getValueById("ObjLocDR"),vData:vdata});
	}
}

//add by CZF0073 2020-02-24
/// ����ά����ϸ
function BImport_Click()
{
  	var Loc=curLocID;
	var FileName=GetFileName();
  	if (FileName=="") return
  	var ErrStr=""
  	var xlApp,xlsheet,xlBook
 	xlApp = new ActiveXObject("Excel.Application");
  	xlBook = xlApp.Workbooks.Add(FileName);
  	xlsheet =xlBook.Worksheets("ά�޵�");
  	xlsheet = xlBook.ActiveSheet;
  	var ExcelRows=xlsheet.UsedRange.Cells.Rows.Count;
  	for (var Row=2;Row<=ExcelRows;Row++)
	{
		var Col=1;
		var SourceType=trim(xlsheet.cells(Row,Col++).text);	//��Դ���� 1:�豸 2:δ����
	    var EquipNo=trim(xlsheet.cells(Row,Col++).text);
	    var EquipName=trim(xlsheet.cells(Row,Col++).text);
	    var UseLoc=trim(xlsheet.cells(Row,Col++).text);
	    var StartDate=trim(xlsheet.cells(Row,Col++).text);
	    var RequestDate=trim(xlsheet.cells(Row,Col++).text);
	    var RequestUser=trim(xlsheet.cells(Row,Col++).text);
	    var FaultCase=trim(xlsheet.cells(Row,Col++).text);	//��������
	    var FaultCaseRemark=trim(xlsheet.cells(Row,Col++).text); //��������ע
	    var FaultReason=trim(xlsheet.cells(Row,Col++).text);//����ԭ��
	    var FaultReasonRemark=trim(xlsheet.cells(Row,Col++).text);//����ԭ��ע
	    var DealMethod=trim(xlsheet.cells(Row,Col++).text); //�������
	    var DealMethodRemark=trim(xlsheet.cells(Row,Col++).text);//���������ע
	    var DealDate=trim(xlsheet.cells(Row,Col++).text); 	//�������  
	    var AcceptUser=trim(xlsheet.cells(Row,Col++).text);	//ά�޸�����
	    var MaintFee=trim(xlsheet.cells(Row,Col++).text);	//ά�޷���
	    var OtherFee=trim(xlsheet.cells(Row,Col++).text);	//�������
	    var TotalFee=trim(xlsheet.cells(Row,Col++).text);	//�ܷ���
	    var MaintMode=trim(xlsheet.cells(Row,Col++).text);	//ά�޷�ʽ
	    var WorkHour=trim(xlsheet.cells(Row,Col++).text);	//��ʱ
	    var Remark=trim(xlsheet.cells(Row,Col++).text);		//��ע
 		var Status=2
 		var EquipType=trim(xlsheet.cells(Row,Col++).text);	//�豸����
		var RequestNo=trim(xlsheet.cells(Row,Col++).text);	//ԭά�޵���
 		
 		var SourceTypeDR=""
 		if (SourceType=="�豸" ) SourceTypeDR=1
 		else if(SourceType=="δ����") SourceTypeDR=2
 		else
 		{
	 		ErrStr="��"+Row+"����Դ���Ͳ���ȷ!";
	 		messageShow("","","",ErrStr)
	 		return;
	 	}
	    var encmeth=GetElementValue("GetEquipIDByNo");
	    if (EquipNo!="")
		{
			EQID=cspRunServerMethod(encmeth,EquipNo);
			if (EQID=="")
			{
				ErrStr="��"+Row+"�� �豸������:"+EquipNo;
				messageShow("","","",ErrStr)
				return;
			}
		}
		else
		{
			ErrStr="�豸��Ų���Ϊ��!"
			messageShow("","","",ErrStr)
		    return;
		}
		encmeth=GetElementValue("GetIDByDesc");
		var UseLocDR=""
	    if (UseLoc!="")
		{
			UseLocDR=cspRunServerMethod(encmeth,"CTLoc",UseLoc);
			if (UseLocDR=="")
			{
				ErrStr="��"+Row+"�� ʹ�ò��ŵ���Ϣ����ȷ:"+UseLoc;
	 			messageShow("","","",ErrStr)
				return;
			}
		}
		var RequestUserDR=""
	    if (RequestUser!="")
		{
			RequestUserDR=cspRunServerMethod(encmeth,"SSUser",RequestUser);
			if (RequestUserDR=="")
			{
				ErrStr="��"+Row+"�� ��������Ϣ����ȷ:"+RequestUser;
	 			messageShow("","","",ErrStr)	
				return;
			}
		}
		var AcceptUserDR=""
		if (AcceptUser!="")
		{
			AcceptUserDR=cspRunServerMethod(encmeth,"SSUser",AcceptUser);
			if (AcceptUserDR=="")
			{
				ErrStr="��"+Row+"�� ά������Ϣ����ȷ:"+AcceptUser;
	 			messageShow("","","",ErrStr)
				return;
			}
		}
		var MaintModeDR=""
		if (MaintMode!="")
		{
			MaintModeDR=cspRunServerMethod(encmeth,"DHCEQMCMaintMode",MaintMode);
			if (MaintModeDR=="")
			{
				ErrStr="��"+Row+"�� ά�޷�ʽ����ȷ:"+MaintMode;
	 			messageShow("","","",ErrStr)
				return;
			}
		}
		var EquipTypeDR=""
		if (EquipType!="")
		{
			EquipTypeDR=cspRunServerMethod(encmeth,"DHCEQCEquipType",EquipType);
			if (EquipTypeDR=="")
			{
				ErrStr="��"+Row+"�� ������Ϣ����ȷ:"+EquipType;
	 			messageShow("","","",ErrStr)
				return;
			}
		}
		//�Զ�����ά�޶���
		encmeth=GetElementValue("AutoSaveExObj")
  		if (encmeth=="") return;
  		var ExObjDR=cspRunServerMethod(encmeth,EQID);
  		if (ExObjDR<=0)
  		{
	  		ErrStr="����ά�޶���ʧ��!"
	 		messageShow("","","",ErrStr)
	  		return;
  		}
  		var FaultCaseDR=""
  		if (FaultCase!="")
  		{
	  		var val=GetPYCode(FaultCase)+"^"+FaultCase;
		 	encmeth=GetElementValue("UpdFaultCase");
		 	var FaultCaseDR=cspRunServerMethod(encmeth,val);
			if (FaultCaseDR<0)
		  	{
			  	ErrStr="�������󱣴��ֵ�ʧ��!";
	 			messageShow("","","",ErrStr)
			  	return;
		  	}
	  	}
	  	var FaultReasonDR=""
	  	if (FaultReason!="")
	  	{
		  	val="^"+FaultReason;
		 	encmeth=GetElementValue("UpdFaultReason");
			var FaultReasonDR=cspRunServerMethod(encmeth,val);
		  	if (FaultReasonDR<0)
		  	{
			  	ErrStr="����ԭ�򱣴��ֵ�ʧ��!"
	 			messageShow("","","",ErrStr)
			  	return;
		  	}
		}
		var DealMethodDR=""
		if (DealMethod!="")
		{
			val="^"+DealMethod;
		 	encmeth=GetElementValue("UpdDealMethod");
			var DealMethodDR=cspRunServerMethod(encmeth,val);
		  	if (DealMethodDR<0)
		  	{
			  	ErrStr="������������ֵ�ʧ��!";
	 			messageShow("","","",ErrStr)
			  	return;
		  	}
		}
	  	
		var combindata=""
		combindata=combindata+RequestNo		//ά�޵��� 1
		combindata=combindata+"^"				//ά�޶����豸���� MR_ObjTypeDR 2
		combindata=combindata+"^"+ExObjDR		//ά�޶��� MR_ExObjDR 3
		combindata=combindata+"^"+UseLocDR		//ά�޶����������� MR_ObjLocDR 4
		combindata=combindata+"^"+session['LOGON.CTLOCID']	//������� MR_RequestLocDR 5
		combindata=combindata+"^"+FaultCaseDR	//�������� 6
		combindata=combindata+"^"+FaultCaseRemark //��������ע 7
		combindata=combindata+"^"+FaultReasonDR //����ԭ�� 8
		combindata=combindata+"^"+FaultReasonRemark //����ԭ��ע 9
		combindata=combindata+"^"+DealMethodDR  //������� 10
		combindata=combindata+"^"+DealMethodRemark //���������ע 11
		combindata=combindata+"^"+DealDate		//������� MR_EndDate 12
		combindata=combindata+"^"				//���ʱ�� MR_EndTime 13
		combindata=combindata+"^"+RequestDate	//�������� MR_RequestDate 14
		combindata=combindata+"^"				//����ʱ�� MR_RequestTime 15
		combindata=combindata+"^"+RequestUserDR	//������ MR_RequestUserDR 16
		combindata=combindata+"^"				//��ϵ�绰 MR_RequestTel 17
		combindata=combindata+"^"				//�ص� MR_Place 18
		combindata=combindata+"^"				//�������� MR_FaultTypeDR 19
		combindata=combindata+"^"+DealDate		//�������� MR_AcceptDate 20	
		combindata=combindata+"^"				//����ʱ�� MR_AcceptTime 21
 		combindata=combindata+"^"+AcceptUserDR	//������ MR_AcceptUser 22
		combindata=combindata+"^"				//ָ���� MR_AssignDR 23
 		combindata=combindata+"^"+MaintModeDR	//ά�޷�ʽ MR_MaintModeDR 24
 		combindata=combindata+"^"+WorkHour		//ʵ�ʹ�ʱ MR_WorkHour 25
 		combindata=combindata+"^"+Remark		//��ע 26
 		combindata=combindata+"^"+Status		//״̬ MR_Status 27
 		combindata=combindata+"^"+MaintFee		//ά�޷� 28
 		combindata=combindata+"^"+OtherFee		//����� 29
 		combindata=combindata+"^"+TotalFee		//�ܷ��� 30
 		combindata=combindata+"^"+SourceTypeDR	//��Դ���� 31
		combindata=combindata+"^"+"Y"			//�����־ InputFlag 32
		combindata=combindata+"^"+EquipTypeDR	//�豸���� 33
		
		encmeth=GetElementValue('ImportData');
		if (encmeth=="") return;
		var ReturnValue=cspRunServerMethod(encmeth,"","",combindata);
		if (ReturnValue<0) 
		{
			ErrStr="��"+Row+"�� <"+EquipName+"> ��Ϣ����ʧ��!!!���ؼ�������Ϣ����������ٴε��������Ϣ.";
	 		messageShow("","","",ErrStr)
			return;
		}		
	}
	
	xlsheet.Quit;
	xlsheet=null;
	xlBook.Close (savechanges=false);
	xlApp=null;
	messageShow("","","","����ά����Ϣ�������!��˶������Ϣ.")
	window.location.reload();
}


//add by CZF0074 2020-02-24
//modified by csj 2020-05-28 ��Ϊ������ж��嵼��
//����ά����ϸ
function BSaveExcel_Click()
{
	/*
	var Node="DHCEQMMaintRequestDetail";
	var encmeth=GetElementValue("GetTempDataRows");
	var currentobj=$("#tDHCEQMMaintRequestDetail").datagrid('getRows');
	if (currentobj) {var TJob=currentobj[0]['TJob'];} 
	if (TJob=="")  return;
	var TotalRows=cspRunServerMethod(encmeth,Node,TJob);
	var PageRows=TotalRows; //ÿҳ�̶�����
	var Pages=parseInt(TotalRows / PageRows) //��ҳ��-1  
	var ModRows=TotalRows%PageRows //���һҳ����
	if (ModRows==0) Pages=Pages-1
	
	try
	{
        var xlApp,xlsheet,xlBook;
        var encmeth=GetElementValue("GetRepPath");
		if (encmeth=="") return;
		var TemplatePath=cspRunServerMethod(encmeth);
	    var Template=TemplatePath+"DHCEQMMaintDetail.xls";
	    xlApp = new ActiveXObject("Excel.Application");
	    var encmeth=GetElementValue("GetTempData");
	    for (var i=0;i<=Pages;i++)
	    {
	    	xlBook = xlApp.Workbooks.Add(Template);
	    	xlsheet = xlBook.ActiveSheet;
	    	xlsheet.PageSetup.TopMargin=0;
	    	var OnePageRow=PageRows;
	    	if ((i==Pages)&&(ModRows!=0)) OnePageRow=ModRows;
	    	//xlsheet.cells(2,1)=xlsheet.cells(2,1) //+MonthStr;	//FormatDate(BeginDate)+"--"+FormatDate(EndDate);
	    	for (var k=1;k<=OnePageRow;k++)
	    	{
		    	var l=i*PageRows+k
		    	var OneDetail=cspRunServerMethod(encmeth,Node,TJob,l);
		    	var OneDetailList=OneDetail.split("^");
		    	
		    	var j=k+3;
		    	
		    	xlsheet.Rows(j).Insert();
		    	var col=1;
		    	//	1		2			3				4					5						6					7				8				9			10			11					12				13				14				15				16			17			18				19				20				21				22			23				24			25				26			27					28			29				30			31				32					33				34			35					36				37			38			39
				//TRow_"^"_TExObj_"^"_TUseLoc_"^"_TFaultCaseRemark_"^"_TFaultReasonRemark_"^"_TDealMethodRemark_"^"_TStartDate_"^"_TStartTime_"^"_TEndDate_"^"_TEndTime_"^"_TRequestDate_"^"_TRequestTime_"^"_TAcceptDate_"^"_TAcceptTime_"^"_TMaintFee_"^"_TUserOpinion_"^"_TRemark_"^"_TRequestLoc_"^"_TFaultCase_"^"TFaultReason_"^"_TDealMethod_"^"_TFaultType_"^"_TAcceptUser_"^"_TAssign_"^"_TMaintMode_"^"_TUserSign_"^"_TManageLoc_"^"_TService_"^"_TOtherFee_"^"_TRequestNO_"^"_TManageType_"^"_TWorkHour_"^"_TEstimateWorkHour_"^"_TContract_"^"_TRequestTel_"^"_TRequestUser_"^"_TTotalFee_"^"_TEQNo_"^"_TFileNo
		    	xlsheet.cells(j,col++)=OneDetailList[0];		//���
		    	xlsheet.cells(j,col++)=OneDetailList[29];		//ά�޵���
		    	xlsheet.cells(j,col++)=OneDetailList[1];		//�豸����
		    	xlsheet.cells(j,col++)=OneDetailList[37];		//�豸���
		    	xlsheet.cells(j,col++)=OneDetailList[2];		//ʹ�ÿ���
		    	xlsheet.cells(j,col++)=OneDetailList[10];		//��������
		    	xlsheet.cells(j,col++)=OneDetailList[35];		//������
		    	xlsheet.cells(j,col++)=OneDetailList[18];		//��������
		    	xlsheet.cells(j,col++)=OneDetailList[19];		//����ԭ��
		    	xlsheet.cells(j,col++)=OneDetailList[20];		//�������
		    	xlsheet.cells(j,col++)=OneDetailList[8];		//�������
		    	xlsheet.cells(j,col++)=OneDetailList[22];		//ά�޸�����
		    	xlsheet.cells(j,col++)=OneDetailList[14];		//ά�޽��
		    	xlsheet.cells(j,col++)=OneDetailList[28];		//������
		    	xlsheet.cells(j,col++)=OneDetailList[36];		//�ܽ��
		    	xlsheet.cells(j,col++)=OneDetailList[31];		//ʵ�ʹ�ʱ
			}
			xlsheet.Rows(j+1).Delete();
			//xlsheet.cells(j+1,1)="��"+(i+1)+"ҳ "+"��"+(Pages+1)+"ҳ"
			//xlsheet.cells(2,1)="ʱ�䷶Χ:"+GetElementValue("StartDate")+"--"+GetElementValue("EndDate")
			//xlsheet.cells(2,4)="�Ʊ���:"+session['LOGON.USERNAME']

			var savepath=GetFileName();
			xlBook.SaveAs(savepath);
	    	xlBook.Close (savechanges=false);
	       	xlsheet.Quit;
	    	xlsheet=null;
	    }
	    xlApp=null;
	    alertShow("�������!");
	} 
	catch(e)
	{
		alertShow(e.message);
	}
	*/
	var currentobj=$("#tDHCEQMMaintRequestDetail").datagrid('getRows');
	if (currentobj) {var TJob=currentobj[0]['TJob'];} 
	if (TJob=="")  return;
	PrintDHCEQEquipNew("MaintRequestDetail",1,TJob,"","DHCEQMMaintRequestDetail");    
	return

}
//add by csj 2020-05-28
function BColSet_Click() //��������������
{
	var para="&TableName=MaintRequestDetail&SetType=0&SetID=0"
	var url="websys.default.hisui.csp?WEBSYS.TCOMPONENT=DHCEQCColSet"+para;
	//showWindow(url,"����������","","82%","icon-w-paper")     //modify by lmm 2020-01-16 999286
	showWindow(url,"����������","","","icon-w-paper","","","","middlelonger")     //modify by lmm 2020-01-16 999286
	//Modefidy by zc0046 �޸ĵ����ڲ�ͬ�ֱ��ʵ�����������
	//Modefied by zc0044 2018-11-22 �޸ĵ�����С
}
/// Modefied by zc0125 2022-11-18 ���ӱ����˲�ѯ begin
function GetRequestUser(value)
{
	GetLookUpID('RequestUserDR',value);
	
}
/// Modefied by zc0125 2022-11-18 ���ӱ����˲�ѯ end
document.body.onload = BodyLoadHandler;
