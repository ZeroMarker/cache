function BodyLoadHandler()
{
	SetElement("SourceType",GetElementValue("SourceTypeDR"))
	InitPage();
	initButtonWidth()  //hisui����:�޸Ľ��水ť���Ȳ�һ�� add by lmm 2018-08-20
	// MZY0075	1905653		2021-05-20
	//ui���� add by hyy 2023-1-31
	initPanelHeaderStyle();
	initButtonColor();
	singlelookup("SourceID","PLAT.L.EquipType",[{name:"Desc",type:1,value:"SourceID"},{name:"GroupID",type:2,value:session['LOGON.GROUPID']},{name:"Flag",type:2,value:'0'},{name:"FacilityFlag",type:2,value:'2'}],"")
	if (GetElementValue("CancelFlag")=="Y")
	{
		DisableBElement("BAdd1",true);
		DisableBElement("BCreate",true);	// MZY0111	2411187		2022-01-14
		HiddenTblColumn("tDHCEQMaintPlanFind","TModify");	// MZY0112	2434107		2022-01-21
	}
	//add by lmm 2020-07-28 1435885
	SetElement("cEQTitle","�豸�����ƻ�")
	if ((GetElementValue("MaintTypeDR")=="5")&&(GetElementValue("CancelFlag")=="Y"))
	{
		SetElement("cEQTitle","�����ϼ����ƻ���ѯ")
	}
	if (jQuery("#BAdd1").length>0)
	{
		if ((typeof(HISUIStyleCode)!='undefined')&&(HISUIStyleCode=="lite")){
			// �����
			if (($("#BAdd1").attr('class')).indexOf("l-btn-disabled")==-1){
				$("#BAdd1").css({"background-color":"#28ba05","color":"#ffffff"})
			}else{
				$("#BAdd1").css({'background-color':'#E5E5E5','color':'#999'})
			}
		}
	}
}
function InitPage()
{
	
	if (GetElementValue("BussType")==2)
	{
		KeyUp("Name^MaintLoc^SourceID","N");
		Muilt_LookUp("Name^MaintLoc^SourceID","N");
	}
	else
	{
		KeyUp("Name^MaintType^MaintLoc^SourceID","N");
		Muilt_LookUp("Name^MaintType^MaintLoc^SourceID","N");
	}
	
	var obj=document.getElementById("BAdd1");;
	if (obj) obj.onclick=BAdd1_Click;
	//add by lmm 2020-12-02
	var obj=document.getElementById("BImport");
	if (obj) obj.onclick=BImport_Click;
	// MZY0076	2021-05-25
	var obj=document.getElementById("BCreate");
	if (obj) obj.onclick=BCreate_Click;
}
//add by lmm 2020-12-02
function BImport_Click()
{
	BImport_IE();
}
//add by lmm 2020-12-02
function BImport_IE()
{
	MaintPlanIDs=""
	var FileName=GetFileName();
	if (FileName=="") {return 0;}
	var xlApp,xlsheet,xlBook
	xlApp = new ActiveXObject("Excel.Application");
	xlBook = xlApp.Workbooks.Add(FileName);
	xlsheet =xlBook.Worksheets("ά���ƻ���");
	xlsheet = xlBook.ActiveSheet;
	var ExcelRows=xlsheet.UsedRange.Cells.Rows.Count;
	for (var Row=2;Row<=ExcelRows;Row++)
	{
		var Col=1;
		var PlanType=trim(xlsheet.cells(Row,Col++).text);  //�ƻ�����
		var PlanName=trim(xlsheet.cells(Row,Col++).text);  //�ƻ�����
		var FromDate=trim(xlsheet.cells(Row,Col++).text);	//�ƻ���ʼ����
		var CycleNumDesc=trim(xlsheet.cells(Row,Col++).text);	//ά������
		var CycleUnit=trim(xlsheet.cells(Row,Col++).text);	//���ڵ�λ
		var PreWarnDaysNum=trim(xlsheet.cells(Row,Col++).text);	//��ǰԤ������
		var EquipRange=trim(xlsheet.cells(Row,Col++).text); //�ƻ���Χ �豸���豸��
		var EquipRangeList=trim(xlsheet.cells(Row,Col++).text); //ָ����Χ��ϸ
		var CycleType=trim(xlsheet.cells(Row,Col++).text);	//�������� 1:�̶�����,2:�̶�ʱ��,3:��ʱ�ƻ�,4:���յȼ� //CZF0134 2021-02-23
		var SDate=trim(xlsheet.cells(Row,Col++).text);	//�̶���ʼ����
		var EDate=trim(xlsheet.cells(Row,Col++).text); 	//�̶���������
		var MaintFee=trim(xlsheet.cells(Row,Col++).text);  //��̨ά������
		var MeasureDept=trim(xlsheet.cells(Row,Col++).text); //��������
		var MeasureHandler=trim(xlsheet.cells(Row,Col++).text); //������ϵ��
		var MeasureTel=trim(xlsheet.cells(Row,Col++).text);	//������ϵ�绰
		
		var CycleTypeID=""		//CZF0134 2021-02-23 begin
		if (CycleType=="�̶�����") CycleTypeID=1
		else if (CycleType=="�̶�ʱ��") CycleTypeID=2
		else if (CycleType=="��ʱ�ƻ�") CycleTypeID=3
		else if (CycleType=="���յȼ�") CycleTypeID=4
		else CycleTypeID=""
		if (CycleTypeID="")
		{
			alertShow("�������Ͳ���Ϊ��!");
		    return 0;
		}
		/*
		if (FixTimeflag=="") var FixTimeflag="N"
		if (FixTimeflag=="��") var FixTimeflag="Y"
		if (FixTimeflag=="��") var FixTimeflag="N"
		*/		//CZF0134 2021-02-23 end

		if (PlanType=="")
		{
			alertShow("�ƻ����Ͳ���Ϊ��!");
		    return 0;
		}
		if (PlanName=="")
		{
			alertShow("�ƻ����Ʋ���Ϊ��!");
		    return 0;
		}
		if (EquipRange=="")
		{
			alertShow("ָ����Χ���Ͳ���Ϊ��!");
		    return 0;
		}
		if (EquipRangeList=="")
		{
			alertShow("ָ����Χ��ϸ����Ϊ��!");
		    return 0;
		}
		if (CycleNumDesc=="")
		{
			alertShow("ά�����ڲ���Ϊ��!");
		    return 0;
		}
		if (CycleUnit=="")
		{
			alertShow("ά�����ڵ�λ����Ϊ��!");
		    return 0;
		}
		if (PreWarnDaysNum=="")
		{
			alertShow("��ǰԤ����������Ϊ��!");
		    return 0;
		}
		if (FromDate=="")
		{
			alertShow("��⿪ʼ���ڲ���Ϊ��!");
		    return 0;
		}
		if (CycleTypeID=="2")		//CZF0134 2021-02-23
		{
			
			if (SDate=="")
			{
				alertShow("�̶���ʼ���ڲ���Ϊ��!");
			    return 0;
			}
			if (EDate=="")
			{
				alertShow("�̶��������ڲ���Ϊ��!");
			    return 0;
			}
			if (SDate>EDate)
			{
				alertShow("�̶�ʱ�䷶Χ��ʼ���ڴ��ڽ�������,������.");
				return 0;
			}
		}
		
		var EquipTypeFlag="N"
		var StatCatFlag="N"
		var LocFlag="N"
		var EquipFlag="N"
		var ItemFlag="N"		
		
		
	 	if (EquipRange="�豸")
	 	{
		 	var EQNo=EquipRangeList //�豸���
		 	var EquipRange=5
			var EquipFlag="Y"
		}
		else if (EquipRange="����")
		{
			var EQUseLoc=EquipRangeList  //ʹ�ÿ���
		 	var EquipRange=4 
			var LocFlag="Y"
		}
		else if (EquipRange="�豸��")
		{
			var EQEquipType=$p(EquipRangeList,"&&",1)  //����
			var EQMasterItem=$p(EquipRangeList,"&&",2)  //�豸��
		 	var EquipRange=6 
			var ItemFlag="Y"		
		}
	 	if (PlanType=="����") {  var PlanTypeDR=2;var MaintTypeDR=5;  }
	 	else if(PlanType=="����")  {  var PlanTypeDR=1;var MaintTypeDR="";   }
	 	else if(PlanType=="Ѳ��")  {  var PlanTypeDR=2;var MaintTypeDR=4;   }
		var EQMeasureFlag=""
		if ((PlanTypeDR==2)&&(MaintTypeDR==5))
		{
			var EQMeasureFlag="Y"
		}

		var CycleUnitDR=tkMakeServerCall("web.DHCEQImportDataTool","GetCycleUnitID",CycleUnit);
		if (CycleUnitDR=="")
		{
			alertShow("��"+Row+"�� ���ڵ�λ��Ϣ����ȷ:"+CycleUnit);
			return 0;
		}
		var MeasureDeptDR=""
		if (MeasureDept!="")
		{
			var MeasureDeptDR=tkMakeServerCall("web.DHCEQImportDataTool","GetMeasureDeptID",MeasureDept);
			if (MeasureDeptDR=="")
			{
				alertShow("��"+Row+"�� ����������Ϣ����ȷ:"+MeasureDept);
				return 0;
			}
		}
		if (EquipRange==4)
		{
			var EQUseLocDR=tkMakeServerCall("web.DHCEQImportDataTool","GetUseLocID",EQUseLoc);
			if (EQUseLocDR=="")
			{
				alertShow("��"+Row+"�� ʹ�ÿ�����Ϣ����ȷ:"+EQUseLoc);
				return 0;
			}
			var ValueDR=EQUseLocDR
		}
		if (EquipRange==5)
		{
			var EquipDR=tkMakeServerCall("web.DHCEQImportDataTool","GetEquipID",EQNo);
			if (EquipDR=="")
			{
				alertShow("��"+Row+"�� ����豸������:"+EQNo);
				return 0;
			}
			var ValueDR=EquipDR
		}
		if ((PlanTypeDR==2)&&(MaintTypeDR=5))
		{
			
			var MeterageFlag=tkMakeServerCall("web.DHCEQ.EM.BUSEquipAttribute","CheckEquipHaveAttribute","3",EquipDR,"11");
			if (MeterageFlag=="0")
			{
				alertShow("��"+Row+"�� �Ǽ����豸:"+EQNo);
				return 0;
			}
			
		}
		
		if (EquipRange==6)
		{
			var EQEquipTypeDR=tkMakeServerCall("web.DHCEQImportDataTool","GetEquipTypeID",EQEquipType);
			if (EQEquipTypeDR=="")
			{
				alertShow("��"+Row+"�� ������Ϣ����ȷ:"+EQEquipType);
				return 0;
			}
			var ItemDR=tkMakeServerCall("web.DHCEQImportDataTool","GetItemID",EQMasterItem,EQEquipType);
			if (ItemDR=="")
			{
				alertShow("��"+Row+"�� �豸����Ϣ����ȷ:"+EQMasterItem);
				return 0;
			}
			var ValueDR=EQEquipTypeDR
		}
		
		var combindata="";
	  	combindata=""; 
		combindata=combindata+"^"+PlanName ; 
		combindata=combindata+"^"+PlanTypeDR ; 
		combindata=combindata+"^"; 
		combindata=combindata+"^"; 
		combindata=combindata+"^"; 
		combindata=combindata+"^"+"";  //modify by lmm 2018-11-08 743473
		combindata=combindata+"^"+CycleNumDesc; 
		combindata=combindata+"^"+CycleUnitDR; 
		combindata=combindata+"^"+MaintTypeDR; 
		combindata=combindata+"^"+FromDate; 
		combindata=combindata+"^"; //+getElementValue("EndDate") 
		combindata=combindata+"^"+PreWarnDaysNum; 
		combindata=combindata+"^"+MaintFee; 
		combindata=combindata+"^";  //MaintLocDR
		combindata=combindata+"^";  //+getElementValue("MaintUserDR") 
		combindata=combindata+"^";  //+getElementValue("MaintModeDR") 
		combindata=combindata+"^"; //+getElementValue("ContractDR")
		combindata=combindata+"^"; //+getElementValue("MeasureFlag") 
		combindata=combindata+"^"+MeasureDeptDR ; 
		combindata=combindata+"^"+MeasureHandler ; 
		combindata=combindata+"^"+MeasureTel; 
		combindata=combindata+"^";   //+getElementValue("ServiceDR")
		combindata=combindata+"^";  //+getElementValue("ServiceHandler") 
		combindata=combindata+"^";  //+getElementValue("ServiceTel") 
		combindata=combindata+"^";  //+getElementValue("Remark") 
		combindata=combindata+"^"+"2"; //getElementValue("Status") 
		combindata=combindata+"^"+"N";  //getElementValue("InvalidFlag") 
		combindata=combindata+"^"+"" //getElementValue("Hold1"); 
		combindata=combindata+"^"+"" //getElementValue("Hold2"); 
		combindata=combindata+"^"+"" //getElementValue("Hold3"); 
		combindata=combindata+"^"+"" //getElementValue("Hold4"); 
		combindata=combindata+"^"+"" //getElementValue("Hold5"); 
		combindata=combindata+"^"+"" //getElementValue("TotalFee"); 
		combindata=combindata+"^"+"" //getElementValue("TempPlanflag");   //modify by lmm 2019-01-10 802911
		combindata=combindata+"^"+CycleTypeID;   //CZF0134 2021-02-23

		combindata=combindata+"^"+SDate; 
		combindata=combindata+"^"+EDate; 		
			
		EquipRangeval=""
		var EquipRangeval="";
	  	EquipRangeval=""; //getElementValue("EquipRangeDR")
		EquipRangeval=EquipRangeval+"^"  //+getElementValue("RangeDesc"); 
		EquipRangeval=EquipRangeval+"^"+"2"  //getElementValue("SourceType"); 
		EquipRangeval=EquipRangeval+"^"+""     //getElementValue("RowID") ; 
		EquipRangeval=EquipRangeval+"^"+EquipTypeFlag; 
		EquipRangeval=EquipRangeval+"^"+StatCatFlag; 
		EquipRangeval=EquipRangeval+"^N"; 
		EquipRangeval=EquipRangeval+"^"+LocFlag; 
		EquipRangeval=EquipRangeval+"^"+EquipFlag ;
		EquipRangeval=EquipRangeval+"^"+ItemFlag ;
		
		var MaintPlaninfo = tkMakeServerCall("web.DHCEQ.EM.BUSMaintPlan", "GetMaintPlanID",combindata,EquipRangeval);
		if (MaintPlaninfo=="")
		{
			//EquipRangevalList=rowData.TRowID+"^"+rowData.TTypeDR+"^"+rowData.TValueDR+"^"+rowData.TAccessFlag
			EquipRangevalList="^"+EquipRange+"^"+ValueDR+"^"+"Y"
			var Rtn = tkMakeServerCall("web.DHCEQ.EM.BUSMaintPlan", "SaveData",combindata,EquipRangeval,EquipRangevalList);
			if (Rtn<0) alertShow("��"+Row+"�� <"+xlsheet.cells(Row,8).text+"> ��Ϣ����ʧ��!!!dddd���ؼ�������Ϣ����������ٴε��������Ϣ.");;
			MaintPlanID=Rtn.split("^")[1]
		}
		else
		{
			MaintPlanID=MaintPlaninfo.split("^")[0]
			EquipRangeID=MaintPlaninfo.split("^")[1]
			EquipRangevalList="^"+EquipRange+"^"+ValueDR+"^"+"Y"
			var Rtn = tkMakeServerCall("web.DHCEQ.EM.BUSEquipRange", "SaveEquipRangeList",EquipRangeID,EquipRangevalList);
			if (Rtn<0) alertShow("��"+Row+"�� <"+xlsheet.cells(Row,8).text+"> ��Ϣ����ʧ��!!!���ؼ�������Ϣ����������ٴε��������Ϣ.");;
		}
		if (MaintPlanIDs=="")
		{
			MaintPlanIDs=MaintPlanID
		}
		else if ((","+MaintPlanIDs+",").indexOf(","+MaintPlanID+",")==-1)
		{
			MaintPlanIDs=MaintPlanIDs+","+MaintPlanID
		}
	}
		messageShow("confirm","","","����ƻ����Ƿ����?","",function(){
			var len=MaintPlanIDs.split(",").length
			for (i=0;i<len;i++)
			{
				var RowID=MaintPlanIDs.split(",")[i]
				var Rtn = tkMakeServerCall("web.DHCEQ.EM.BUSMaintPlan", "SubmitData",RowID);
				if (Rtn<0)
				{
					alertShow("ά���ƻ�id��"+RowID+" �ύʧ��:"+Rtn);
					return 0;
				}
				
			}
			xlsheet.Quit;
			xlsheet=null;
			xlBook.Close (savechanges=false);
			xlApp=null;
			alertShow("����ƻ���Ϣ�������!��˶������Ϣ.");
			window.location.reload();
			return;
		},function(MaintPlanIDs){
			xlsheet.Quit;
			xlsheet=null;
			xlBook.Close (savechanges=false);
			xlApp=null;
			alertShow("����ƻ���Ϣ�������!��˶������Ϣ.");
			window.location.reload();
			return;
		});	

//			xlsheet.Quit;
//			xlsheet=null;
//			xlBook.Close (savechanges=false);
//			xlApp=null;
//			alertShow("����ƻ���Ϣ�������!��˶������Ϣ.");
//			window.location.reload();
}



//hisui���� add by lmm 2018-08-17 begin  �л������б����¶�����Դ������
///modify by lmm 2018-12-04
$("#SourceType").combobox({
    onChange: function () {
	SourceType_Click()
	var SourceType=$("#SourceType").combobox('getValue')
	if (SourceType==1){    //1:�豸����
		// MZY0075	1905653		2021-05-20
		singlelookup("SourceID","PLAT.L.EquipType",[{name:"Desc",type:1,value:"SourceID"},{name:"GroupID",type:2,value:session['LOGON.GROUPID']},{name:"Flag",type:2,value:'0'},{name:"FacilityFlag",type:2,value:'2'}],"")
	}
	else if (SourceType==2)
	{    
		singlelookup("SourceID","PLAT.L.StatCat",[{name:"SourceID",type:1,value:"SourceID"},{name:"EquipTypeDR",type:2,value:''},{name:"EquipTypeFlag",type:2,value:'Y'}],"")   //modify by lmm 2019-08-29 990959

	}
	else if (SourceType==4)
	{    
		singlelookup("SourceID","PLAT.L.Loc","","")

	}
	else if (SourceType==6)
	{    
		singlelookup("SourceID","EM.L.GetMasterItem","","")

	}
	else if (SourceType==5) //3:�豸
	{
		singlelookup("SourceID","EM.L.Equip","","")
	
	}
  }
})
//hisui���� add by lmm 2018-08-17 end 
function SourceType_Click()
{    
	SetElement("SourceTypeDR",GetElementValue("SourceType"))
	SetElement('SourceID',"");
	SetElement('SourceIDDR',"");
}

///add by lmm 2018-08-17
///������hisui���� ������ֵ
///��Σ�item ѡ����json����
function GetSourceID(item) 
{
	SetElement('SourceIDDR',item.EQRowID);
}

function GetNameID(value)
{
	GetLookUpID('NameDR',value);
}
function GetMaintType(value)
{
	GetLookUpID('MaintTypeDR',value);
}
function GetMaintLoc(value)
{
	GetLookUpID('MaintLocDR',value);
}
function SetEquipCat(id,text)
{
	SetElement('SourceID',text);
	SetElement('SourceIDDR',id);
}
///add by lmm 2018-08-17
///������hisui���� ������ֵ
///��Σ�item ѡ����json����
function GetCatID(item) 
{
	SetElement('SourceIDDR',item.ECRowID);
}
///add by lmm 2018-08-17
///������hisui���� ������ֵ
///��Σ�item ѡ����json����
function GetMasterItemID(item) 
{
	SetElement('SourceIDDR',item.MIRowID);
}
///add by lmm 2018-10-31 hisui���죺�����������
function BAdd1_Click() //GR0026 ����������´��ڴ�ģ̬����
{
	var BussType=GetElementValue("BussType");
	var QXType=GetElementValue("QXType"); 
	var MaintTypeDR=GetElementValue("MaintTypeDR");
	var val="&BussType="+BussType+"&QXType="+QXType+"&MaintTypeDR="+MaintTypeDR;
	url="dhceq.em.meterageplan.csp?"+val
	//add by lmm 2018-01-18 begin
	var title="�豸�����ƻ�"
	var height="710px"  //Modefied by zc0132 2023-03-15 ��ʼ�������߶�
	if (GetElementValue("MaintTypeDR")=="4")
	{
		url="dhceq.em.inspectplan.csp?"+val
		var title="�豸Ѳ��ƻ�"
		height="560px"  //Modefied by zc0132 2023-03-15 Ѳ���ض��嵯���߶�
	}
	if (BussType=="1")
	{
		url="dhceq.em.maintplan.csp?"+val
		var title="�豸�����ƻ�"
	}
	showWindow(url,title,"",height,"icon-w-paper","modal","","","large");   //Modefied by zc0132 2023-03-15 �޸ĵ����߶�
}
///add by lmm 2019-1-12 804471
///������������ֵ�¼�
function setSelectValue(vElementID,item)
{
	setElement(vElementID+"DR",item.TRowID)
	
}
///add by lmm 2019-1-12 804471
///����������������¼�
function clearData(vElementID)
{
	setElement(vElementID+"DR","")
}
// MZY0076	2021-05-25
function BCreate_Click()
{
	var url="dhceq.em.createmaintplan.csp";
	var title="�豸�����ƻ�";	// MZY0099	2198140		2021-11-13
	showWindow(url,title,"","","icon-w-paper","modal","","","large");
}
//add by LMH 20221220 3117341 Ԫ�ز������»�ȡֵ
function getParam(ID)
{
	if (ID=="EquipTypeDR"){return ''}
}
document.body.onload = BodyLoadHandler;
