var editFlag="undefined";
var PRRowID=getElementValue("PRRowID");
var Columns=getCurColumnsInfo('EM.G.Pay.UnPayList','','','')
var oneFillData={}

$(function(){
	initDocument();
});

function initDocument()
{
	initUserInfo();
	initMessage();
	defindTitleStyle();
	initButtonWidth();
	initLookUp(); //��ʼ���Ŵ�
	initPRPayFromType(); //Add By QW20210220 BUG:QW0093
	initSourceType();
	initButton(); //��ť��ʼ��
    setRequiredElements("PayFromType^SourceType");		//MZY0123	2665290		2022-05-12	^ProviderDR_VDesc
	payRecordReload();
	$("#BExport").on("click",function(){
		BExport_Clicked()
	})
	//add by mwz 20220117 mwz0057
	$("#BColSet").on("click",function(){
		BColSet_Click()
	})
};
function BFind_Clicked()
{
	if (checkMustItemNull("")) return  //Add By QW20210220 BUG:QW0093
	payRecordReload()
}
// �ϼ���Ϣ
function InitAmountInfo() {
	var rows=$('#DHCEQUnPayFind').datagrid('getRows')
	var TJob=""
	if(rows.length>0){
		TJob=rows[0].TJob;
	}
	var Data = tkMakeServerCall("web.DHCEQ.EM.BUSPayRequest","GetSumUnPayInfo",TJob);  
	$("#sumTotal").html(Data);	
}
///modify by mwz 20220117 mwz0057
function BExport_Clicked()
{
	var TJob=""
	var PrintFlag=tkMakeServerCall("web.DHCEQCommon","GetSysInfo",'990062');
	if (PrintFlag=="1")
	{
		var rows=$('#DHCEQUnPayFind').datagrid('getRows')
		var RowCount=rows.length;
		if(RowCount<=0){
			messageShow("","","","û������!")
			return;
		}
		else {
			TJob=rows[0].TJob;
		}
		// MZY0118	2474977,2475599		2022-03-28
		if (!CheckColset("EQUnPayRequestList"))
		{
			messageShow('popover','alert','��ʾ',"����������δ����!")
			return ;
		}
		var url="dhccpmrunqianreport.csp?reportName=DHCEQUnPayRequestListExport.raq&CurTableName=EQUnPayRequestList&CurUserID="+session['LOGON.USERID']+"&CurGroupID="+session['LOGON.GROUPID']+"&Job="+TJob;
    	if ('function'==typeof websys_getMWToken){		//czf 2023-02-14 token���ò�������
			url += "&MWToken="+websys_getMWToken()
		}
    	window.open(url,'_blank','toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width=890,height=650,left=120,top=0');   //
	}
	else
	{
		BExportExcel_Clicked();
	}
}
function BExportExcel_Clicked()
{
	var rows=$('#DHCEQUnPayFind').datagrid('getRows')
	if(rows.length>0){
		var TJob=rows[0].TJob;
	}
	else{
		return
	}

	var Node="UnPayRequestList";
	var TotalRows=tkMakeServerCall("web.DHCEQCommon","GetTempDataRows",Node,TJob);
	var TotalInfo = tkMakeServerCall("web.DHCEQ.EM.BUSPayRequest","GetSumUnPayInfoSimple",TJob); 
	var PageRows=TotalRows; //ÿҳ�̶�����
	var Pages=parseInt(TotalRows / PageRows) //��ҳ��-1  
	var ModRows=TotalRows%PageRows //���һҳ����
	if (ModRows==0) Pages=Pages-1
	
	try
	{
        var xlApp,xlsheet,xlBook;
		var TemplatePath=getElementValue("GetRepPath")
	    var Template=TemplatePath+"DHCEQUnPayRequestList.xls";
	    xlApp = new ActiveXObject("Excel.Application");
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
		    	var OneDetail=tkMakeServerCall("web.DHCEQCommon","GetTempData",Node,TJob,l);;
		    	var OneDetailList=OneDetail.split("^");
		    	
		    	var j=k+2;
		    	
		    	xlsheet.Rows(j).Insert();
		    	var col=1;
				//  0			1				2			3			4				5				6				7				8			9				10				11			12				13				14				15			16			17					18				19			20				
				//TRowID_"^"_TSourceType_"^"_TSourceNo_"^"_TDate_"^"_TEquipName_"^"_TOriginalFee_"^"_TQuantityNum_"^"_TTotalFee_"^"_TPaedFee_"^"_TNeedPayFee_"^"_TAmountFee_"^"_TRemark_"^"_TReduceQtyNum_"^"_TInvoiceNo_"^"_TInvoiceDate_"^"_TLoc_"^"_TEquipType_"^"_TGuaranteeDate_"^"_TGuaranteeFee_"^"_TRate_"^"_TOpenCheckDate
		    	xlsheet.cells(j,col++)=OneDetailList[2];//ҵ�񵥺�
		    	xlsheet.cells(j,col++)=OneDetailList[4];//�豸���� //add by csj 2020-05-08
		    	xlsheet.cells(j,col++)=OneDetailList[16];//����
		    	xlsheet.cells(j,col++)=OneDetailList[21];//��Ӧ��
		    	xlsheet.cells(j,col++)=OneDetailList[5];//ԭֵ
		    	xlsheet.cells(j,col++)=OneDetailList[6];//����
		    	xlsheet.cells(j,col++)=OneDetailList[7];//�ܽ��
		    	xlsheet.cells(j,col++)=OneDetailList[8];//�Ѹ�
		    	xlsheet.cells(j,col++)=OneDetailList[9];//δ��
		    	xlsheet.cells(j,col++)=OneDetailList[15];//����
		    	xlsheet.cells(j,col++)=OneDetailList[18];//�ʱ����
		    	xlsheet.cells(j,col++)=OneDetailList[17];//�ʱ���ֹ����
		    	xlsheet.cells(j,col++)=OneDetailList[20];//��������
		    	xlsheet.cells(j,col++)=OneDetailList[22];//�����������
		    	xlsheet.cells(j,col++)=OneDetailList[23];//��Դ
		    	xlsheet.cells(j,col++)=OneDetailList[24];//��ע
			}
			xlsheet.Rows(j+1).Delete();
//			xlsheet.Rows(j+2).Delete();
			xlsheet.cells(j+1,2)="�ϼ�:"
			xlsheet.cells(j+1,6)=TotalInfo.split("^")[0]	//�ϼ�����
			xlsheet.cells(j+1,7)=TotalInfo.split("^")[1]	//�ϼƽ��
			xlsheet.cells(j+1,8)=TotalInfo.split("^")[3]	//�ϼ��Ѹ�
			xlsheet.cells(j+1,9)=TotalInfo.split("^")[2]	//�ϼ�δ��
//			xlsheet.cells(j+2,7)="�Ʊ��ˣ�"+curUserName
//			xlsheet.cells(2,2)=getElementValue("PayEquipType")
//			xlsheet.cells(2,5)=getElementValue("Provider")
//			xlsheet.cells(j+1,1)="��"+(i+1)+"ҳ "+"��"+(Pages+1)+"ҳ"
			//xlsheet.cells(2,1)="ʱ�䷶Χ:"+getElementValue("StartDate")+"--"+getElementValue("EndDate")
			//xlsheet.cells(2,4)="�Ʊ���:"+curUserName

			var savepath=GetFileName();
			xlBook.SaveAs(savepath);
	    	xlBook.Close (savechanges=false);
	       	xlsheet.Quit;
	    	xlsheet=null;
	    }
	    xlApp=null;
	    alert("�������!");
	} 
	catch(e)
	{
		messageShow("","","",e.message);
	}

}
//Modified By QW20210220 BUG:QW0093
function payRecordReload()
{
	var SourceType=getElementValue("SourceType");
	var ProviderDR=getElementValue("ProviderDR");
	$HUI.datagrid("#DHCEQUnPayFind",{
		url:$URL,
		queryParams:{
		    	ClassName:"web.DHCEQ.EM.BUSPayRequest",
	        	QueryName:"GetUnPayList",
				vSourceType:SourceType,
				vProviderDR:ProviderDR,
				QXType:getElementValue("QXType")	//czf 2021-11-18 2215015
		},
		fitColumns : true, 
		scrollbarSize:0,
		rownumbers: true,  //���Ϊtrue������ʾһ���к��С�
		singleSelect:false,
		fit:true,
		border:false,
		columns:Columns,
		pagination:true,
		pageSize:25,
		pageNumber:1,
		toolbar:[{}],
		pageList:[25,50,75,100],
		onLoadSuccess:function(){
			InitAmountInfo()
		},
		onLoadError:function(err){
			alert(JSON.stringify(err))
			}
	});
}



//Modified By QW20210220 BUG:QW0093
function initSourceType()
{
	//{id:'11',text:'��ͬ�ܵ�'},{id:'12',text:'��ͬ��ϸ'},{id:'13',text:'������ϸ'},{id:'14',text:'�����ϸ'},{id:'15',text:'�״γ�����ϸ(���Ƽ�)'},{id:'16',text:'�˻���ϸ'}
	//{id:'21',text:'ά����ͬ�ܵ�'},{id:'22',text:'ά����ͬ��ϸ'}
	//{id:'31',text:'������'},{id:'32',text:'�״��������(���Ƽ�)'},{id:'33',text:'����˻�'}
	//{id:'41',text:'����'}
	//{id:'51',text:'����'},{id:'52',text:'���'},{id:'53',text:'ά��'}
	var PRPayFromType=getElementValue("PayFromType")
	var PRSourceTypeData=[]
	if (PRPayFromType=="1")	{PRSourceTypeData=[{id:'11',text:'��ͬ�ܵ�'},{id:'12',text:'��ͬ��ϸ'},{id:'13',text:'������ϸ'},{id:'14',text:'�����ϸ'},{id:'16',text:'�˻���ϸ'}]}
	else if (PRPayFromType=="2"){PRSourceTypeData=[{id:'21',text:'ά����ͬ�ܵ�'}]}	// ,{id:'22',text:'ά����ͬ��ϸ'}	MZY0113	2435642		2022-01-25
	else if (PRPayFromType=="3"){PRSourceTypeData=[{id:'31',text:'������'},{id:'33',text:'����˻�'}]}
	else if (PRPayFromType=="4"){PRSourceTypeData=[{id:'41',text:'����'}]}
	else if (PRPayFromType=="5"){PRSourceTypeData=[{id:'51',text:'����'},{id:'52',text:'���'},{id:'53',text:'ά��'}]}
	else if (PRPayFromType=="9"){
		var PRSourceTypeStr=tkMakeServerCall("web.DHCEQ.EM.BUSPayRequest","GetPayCostType")
		var PRSourceTypeCount=PRSourceTypeStr.split("@")
		for (var i=0; i<PRSourceTypeCount.length; i++)
		{
			var OneInfo=new CustomData(PRSourceTypeCount[i])
			PRSourceTypeData.push(OneInfo)
		}
	}
	var PRSourceType = $HUI.combobox('#SourceType',{
		valueField:'id', textField:'text',panelHeight:"auto",
		data:PRSourceTypeData,
		onSelect : function(){}
	});
}
//Modified By QW20210220 BUG:QW0093
function initPRPayFromType()
{
	var PRPayFromType = $HUI.combobox('#PayFromType',{
		valueField:'id', textField:'text',panelHeight:"auto",
		data:[
			{id: '1',text: '�¹��豸'}
//			{id: '2',text: 'ά����ͬ'},
//			{id: '3',text: '���'},
//			{id: '4',text: '���˸���'},
//			{id: '5',text: 'ά������'},
//			{id: '9',text: '��������'}
			],
		onSelect : function(){
			initSourceType()
			}
	});
}
function setSelectValue(elementID,rowData)
{
	if(elementID=="ProviderDR_VDesc")
	{
		setElement("ProviderDR",rowData.TRowID)
//		setElement("PRBank",rowData.TBank)
//		setElement("PRBankAccount",rowData.TBankNo)
	}
}

function clearData(vElementID)
{
	var _index = vElementID.indexOf('_')
	if(_index != -1){
		var vElementDR = vElementID.slice(0,_index)
		if($("#"+vElementDR).length>0)
		{
			setElement(vElementDR,"");
		}
	}
}
//add by mwz 20220117 mwz0057
//��������������
function BColSet_Click() 
{
	var para="&TableName=EQUnPayRequestList&SetType=0&SetID=0"
	var url="websys.default.hisui.csp?WEBSYS.TCOMPONENT=DHCEQCColSet"+para;
	showWindow(url,"����������","","","icon-w-paper","","","","large");		// MZY0116	2474977		2022-03-14
}
