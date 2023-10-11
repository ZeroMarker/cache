var columns=getCurColumnsInfo('PLAT.G.InStock.InvoiceInStockList','','','');  

$(document).ready(function () {
	initDocument();
});
function initDocument()
{
	initUserInfo();  ///Modefied by ZC0081 2020-09-07 ��ʼ���û���Ϣ
	defindTitleStyle(); 
	initButtonWidth();
	initButton();
	initLookUp();
	initCombobox();
	if (getElementValue("MapType")==1)
	{
		toolbar=[{
		    		id:"Save",
					iconCls:'icon-transfer', 
					text:'ȷ�Ϲ����ر�',
					handler:function(){MapCloseInvoice();}
				},{
		    		id:"Save",
					iconCls:'icon-transfer', 
					text:'����ȷ�Ϲ���',
					handler:function(){MapInvoice();}
				}]
	}
	else
	{
		toolbar=[{
		    		id:"Save",
					iconCls:'icon-add', 
					text:'��¼��Ʊ',
					handler:function(){AddGridData();}
				},  ///Modefied by ZC0081 2020-09-07 ��Ӵ�ӡ��ť  begin
				{
		    		id:"Print",
					iconCls:'icon-print', 
					text:'��ӡ',
					handler:function(){BPrint_Clicked();}
				}   ///Modefied by ZC0081 2020-09-07 ��Ӵ�ӡ��ť  end
				/*,{
		    		id:"Save",
					iconCls:'icon-transfer', 
					text:'��ѯ��Ʊ',
					handler:function(){FindGridData();}
				}*/
				]
		
	}
	// Mozy003007	1260544		2020-04-07
	var GetInStockListQueryName="GetInStockDetail"
	if(getElementValue("BussType")==3) 
	{
		GetInStockListQueryName="GetAInStockDetail"
	}
	
	$HUI.datagrid("#instocklistdatagrid",{   
    url:$URL, 
	idField:'TISLRowID', //����   //add by lmm 2018-10-23
    border : false,
	striped : true,
    cache: false,
    fit:true,
    singleSelect:false,
    queryParams:{
        ClassName:"web.DHCEQ.Plat.BUSInvoice",
        QueryName:GetInStockListQueryName,		// Mozy003007	1260544		2020-04-07
        ISNo:getElementValue("ISNo"),
        LocDR:'',
        StartDate:getElementValue("StartDate"),
        EndDate:getElementValue("EndDate"),
        InvoiceNos:getElementValue("InvoiceNos"),
        MinPrice:getElementValue("MinPrice"),
        MaxPrice:getElementValue("MaxPrice"),
        ProviderDR:getElementValue("ProviderDR"),
        Name:getElementValue("Name"),
        EquipTypeDR:getElementValue("EquipTypeDR"),
        InvoiceInfoDR:'',
        QXType:'',
        InvoiceID:getElementValue("InvoiceDR"),
        ShowType:getElementValue("ShowType"),
        HasInvoiceType:getElementValue("HasInvoiceType"),
        Params:getElementValue("Status")+"^"+getElementValue("StartAuditDate")+"^"+getElementValue("EndAuditDate")+"^"+getElementValue("Job")  //Modify by zx 2020-12-11 BUG ZX0121
	    },
		fitColumns:true,   //modify by lmm 2020-06-04
    	toolbar:toolbar, 			
		pagination:true,
    	columns:columns, 
	});
	if (getElementValue("MenuName")!="")
	{
		disableElement("Provider",true)
		$('#instocklistdatagrid').datagrid('hideColumn','TProvider');
	}
	
	if(getElementValue("Status")=="0")
	{
		disableElement("BAudit",true)
	}else if(getElementValue("Status")=="1"){
		//disableElement("Save",true)
	}else if(getElementValue("Status")=="2"){
		disableElement("Save",true)
		disableElement("BAudit",true)
	}else{
		disableElement("BAudit",true)
	}
	if(getElementValue("Status")=="0,1")
	{
		disableElement("Status",true)
	}
	//Modify by zx 2020-12-11 BUG ZX0121 ���ӵ�������
	$('#BExport').on("click", BExport_Clicked);	
	///modify by mwz 20220117 mwz0057
	$('#BColSet').on("click", BColSet_Click);		    
}

///add by lmm 2019-09-19
///desc:�����ϸ��ѯ�¼�
function BFind_Clicked()
{
	// Mozy003007	1260544		2020-04-07
	var GetInStockListQueryName="GetInStockDetail"
	if(getElementValue("BussType")==3) 
	{
		GetInStockListQueryName="GetAInStockDetail"
	}
	$HUI.datagrid("#instocklistdatagrid",{   
    url:$URL, 
    queryParams:{
        ClassName:"web.DHCEQ.Plat.BUSInvoice",
        QueryName:GetInStockListQueryName,		// Mozy003007	1260544		2020-04-07
        ISNo:getElementValue("ISNo"),
        LocDR:'',
        StartDate:getElementValue("StartDate"),
        EndDate:getElementValue("EndDate"),
        InvoiceNos:getElementValue("InvoiceNos"),
        MinPrice:getElementValue("MinPrice"),
        MaxPrice:getElementValue("MaxPrice"),
        ProviderDR:getElementValue("ProviderDR"),
        Name:getElementValue("Name"),
        EquipTypeDR:getElementValue("EquipTypeDR"),
        InvoiceInfoDR:'',
        QXType:'',
        InvoiceID:getElementValue("InvoiceDR"),
        ShowType:getElementValue("ShowType"),
        HasInvoiceType:getElementValue("HasInvoiceType"),
        Params:getElementValue("Status")+"^"+getElementValue("StartAuditDate")+"^"+getElementValue("EndAuditDate")+"^"+getElementValue("Job")  //Modify by zx 2020-12-11 BUG ZX0121
	    },
	    onLoadSuccess:function(){
		    	if(getElementValue("Status")=="0")
				{
					disableElement("BAudit",true)
				}else if(getElementValue("Status")=="1"){
					disableElement("BAudit",false)
				}else if(getElementValue("Status")=="2"){
					disableElement("Save",true)
					disableElement("BAudit",true)
				}else{
					disableElement("BAudit",true)
				}

		}
	});
	
	$('#instocklistdatagrid').datagrid("unselectAll");  //add by lmm 2021-02-02 1749740
}

///add by csj 20200102
///desc:��˷�Ʊ�¼�
function BAudit_Clicked()
{
	if(getElementValue("Status")!="1") return
	var rows = $('#instocklistdatagrid').datagrid('getChecked');
    if (rows=="")
    {
		messageShow("","","","δѡ�����ݣ�")
	    return;
	    
	}
	var combindata=""
	$.each(rows, function(rowIndex, rowData){
		if (combindata=="")
		{ 
			combindata=rowData.TISLRowID;
		}
		 else combindata=combindata+","+rowData.TISLRowID; 
	}); 
	var Rtn = tkMakeServerCall("web.DHCEQ.Plat.BUSInvoice", "AuditInvoice",combindata,getElementValue("BussType"));	// Mozy003007	1260544		2020-04-07
	if (Rtn=='0')
	{
		$.messager.popover({msg: '��˳ɹ���',type:'success',timeout: 1000});
		$("#instocklistdatagrid").datagrid('reload');
		$('#instocklistdatagrid').datagrid("unselectAll"); //Modify by zx 2020-09-10 BUG ZX0108 ˢ�º���Ҫ���ѡ��
		return;
	}
	else
	{
		$.messager.popover({msg: '���ʧ�ܣ�',type:'error',timeout: 1000});		
		return;
	}


}

///add by lmm 2019-07-01
///desc:��¼��Ʊ������ϸ����
function AddGridData()
{
	
    var combindata="";
    var providerinfos=""
    var rows = $('#instocklistdatagrid').datagrid('getChecked');
    if (rows=="")
    {
		messageShow("","","","δѡ�����ݣ�")
	    return;
	    
	 }
	$.each(rows, function(rowIndex, rowData){
		if (combindata=="")
		{ 
			combindata=rowData.TISLRowID;
		}
		 else combindata=combindata+","+rowData.TISLRowID; 
		 if (providerinfos=="")
		 {
			providerinfos=rowData.TProviderDR
			ProviderDR=rowData.TProviderDR
		 }
		 else
		 {
			if ((","+providerinfos+",").indexOf(","+rowData.TProviderDR+",")==-1)
			{
			providerinfos=providerinfos+","+rowData.TProviderDR
			}
			 
		 }
	}); 
	var prolen=providerinfos.split(",").length
	if (prolen>1)
	{
		messageShow("","","","ѡ�������ϸ��Ӧ�̲�һ�£�");
		return;
	}
	var url="dhceq.plat.invoiceinstocklist.csp?"+"&BussType="+getElementValue("BussType")+"&InStockListStr="+combindata+"&ProviderDR="+ProviderDR+"&RequestLocDR="+getElementValue("RequestLocDR");
	var title="��¼��ⷢƱ"
	var width=""
	var height=""
	var icon="icon-w-edit"
	var showtype=""
	showWindow(url,title,width,height,icon,showtype,"","","large")

	
}


///add by lmm 2019-07-02
///��Ʊ��ѯ���� ������
function FindGridData()
{
    var combindata="";
    var providerinfos=""
    var rows = $('#instocklistdatagrid').datagrid('getChecked');
	$.each(rows, function(rowIndex, rowData){
		if (combindata=="")
		{ 
			combindata=rowData.TISLRowID;
		}
		 else combindata=combindata+","+rowData.TISLRowID; 
		 if (providerinfos=="")
		 {
			providerinfos=rowData.TProviderDR
			ProviderDR=rowData.TProviderDR
		 }
		 else
		 {
			if ((","+providerinfos+",").indexOf(","+rowData.TProviderDR+",")==-1)
			{
			providerinfos=providerinfos+","+rowData.TProviderDR
			}
			 
		 }
	}); 
	var prolen=providerinfos.split(",").length
	if (prolen>1)
	{
		messageShow("","","","ѡ�������ϸ��Ӧ�̲�һ�£�")
		return
	}
	var url="dhceq.plat.invoicemapinstock.csp?"+"&BussType="+getElementValue("BussType")+"&InStockListStr="+combindata+"&ProviderDR="+ProviderDR+"&MenuName=InStockList";
	var title="�����ϸ��Ʊ��ѯ�б�"
	var width=""
	var height=""
	var icon="icon-w-edit"
	var showtype=""
	showWindow(url,title,width,height,icon,showtype,"","","large")
	
}

///add by lmm 2019-09-19
///desc:�ص��¼�
function setSelectValue(vElementID,item)
{
	setElement(vElementID+"DR",item.TRowID)
}

///add by lmm 2019-09-19
///desc:����¼�
function clearData(vElementID)
{
	setElement(vElementID+"DR","")	
}

///add by lmm 2019-09-19
///desc:�����ϸ�뷢Ʊ��������
function MapInvoice()
{
	var InvoiceDR=getElementValue("InvoiceDR")
	if (InvoiceDR=="")
	{
		messageShow("","","","δѡ�з�Ʊ��")
		return;	
		
	}
    var combindata="";
    var rows = $('#instocklistdatagrid').datagrid('getChecked');
    if (rows=="")
    {
		messageShow("","","","δѡ������豸��")
		return; 
	    
	}
	$.each(rows, function(rowIndex, rowData){
		if (combindata=="")
		{ 
			combindata=rowData.TISLRowID;
		}
		 else combindata=combindata+","+rowData.TISLRowID; 
	}); 	
		
	var Rtn = tkMakeServerCall("web.DHCEQ.Plat.BUSInvoice", "InvoiceMapBuss",InvoiceDR,combindata,getElementValue("BussType"));	// Mozy003007	1260544		2020-04-07
	if (Rtn=='0')
	{
		websys_showModal("options").mth(combindata);  
		$.messager.popover({msg: 'ȷ�Ϲ�����',type:'success',timeout: 1000});		
		$("#instocklistdatagrid").datagrid('reload');
		return;
	}
	else
	{
		$.messager.popover({msg: '����ʧ�ܣ�',type:'error',timeout: 1000});		
		return;
	}
	
	
}

///add by lmm 2019-09-19
///desc:�����ϸ�뷢Ʊ�����ر�
function MapCloseInvoice()
{
	var InvoiceDR=getElementValue("InvoiceDR")
	if (InvoiceDR=="")
	{
		messageShow("","","","δѡ�з�Ʊ��")
		return;	
		
	}
    var combindata="";
    var rows = $('#instocklistdatagrid').datagrid('getChecked');
    if (rows=="")
    {
		messageShow("","","","δѡ������豸��")
		return; 
	    
	}
	$.each(rows, function(rowIndex, rowData){
		if (combindata=="")
		{ 
			combindata=rowData.TISLRowID;
		}
		 else combindata=combindata+","+rowData.TISLRowID; 
	}); 	
		
	var Rtn = tkMakeServerCall("web.DHCEQ.Plat.BUSInvoice", "InvoiceMapBuss",InvoiceDR,combindata,getElementValue("BussType"));	// Mozy003007	1260544		2020-04-07
	if (Rtn=='0')
	{
		websys_showModal("options").mth(combindata);  
		$.messager.popover({msg: 'ȷ�Ϲ�����',type:'success',timeout: 1000});		
		//$("#instocklistdatagrid").datagrid('reload');
		closeWindow("modal")
		return;
	}
	else
	{
		$.messager.popover({msg: '����ʧ�ܣ�',type:'error',timeout: 1000});		
		return;
	}
	
	
}

///add by lmm 2019-09-19
///desc:�����б��ʼ��
function initCombobox()
{
	var HasInvoiceType = $HUI.combobox('#HasInvoiceType',{
		valueField:'id', textField:'text',panelHeight:"auto",
		data:[{
				id: '',
				text: '������ϸ'
			},{
				id: '1',
				text: '����������Ʊ'
			},{
				id: '2',
				text: '������������Ʊ'
			}]
	});	
	var Status = $HUI.combobox('#Status',{
		valueField:'id', textField:'text',panelHeight:"auto",
		data:[{
				id: '0,1',
				text: '�������ύ'
			},{
				id: '1',
				text: '�ύ'
			},{
				id: '2',
				text: '���'
			}],
			onSelect:function(record){
				BFind_Clicked()
			}
		});	
}

///Modefied by CSJ 2020-11-11 �����Ǭ��ӡ
function BPrint_Clicked()
{
	//Modify by zx 2020-12-11
	//var curDate=GetCurrentDate();
	var InvoiceNos=getElementValue("InvoiceNos")
	if (InvoiceNos=="")
	{
		messageShow("","","","δ���뷢Ʊ�Ų�ѯ��");
		return;
	}
	var TotalRows=tkMakeServerCall("web.DHCEQ.Plat.BUSInvoice", "GetTempDataRows",'InStockDetailPrint',curUserID);	
	if (TotalRows=="")
	{
		messageShow("","","","û�����ݲ��ܴ�ӡ��")
		return;
	}
	var PrintFlag=getElementValue("PrintFlag");
	if(PrintFlag==0)
	{
		//Modify by zx 2020-12-11 BUG ZX0121 ��ӡ�͵����ϲ�����
		/*
		var	TemplatePath=tkMakeServerCall("web.DHCEQStoreMoveSP", "GetPath",'','');	// Mozy003007	1260544	
		try {
	    	var xlApp,xlsheet,xlBook;
			var Template=TemplatePath+"DHCEQInvoice.xls";
			xlApp = new ActiveXObject("Excel.Application");
		    xlBook = xlApp.Workbooks.Add(Template);
		    xlsheet = xlBook.ActiveSheet;
		    xlsheet.cells.replace("[Hospital]",curHospitalName)
		    var delRow=3;
		    var sum=0
		    var sumFee=0
		    for (var j=1;j<=TotalRows;j++)
			{
			    	var OneDetail=tkMakeServerCall("web.DHCEQ.Plat.BUSInvoice", "GetTempData",'InStockDetailPrint',curUserID,j);
			    	var OneDetailList=OneDetail.split("^");
			    	///TISRowID_"^"_TProvider_"^"_TInDate_"^"_TISNo_"^"_TLoc_"^"_TStatCat_"^"_TEquipType_"^"_TISLRowID_"^"_TEquipName_"^"_TModel_"^"_TUnit_"^"_TQuantityNum_"^"_TOriginalFee_"^"_TTotalFee_"^"_TEquipCat_"^"_TUseYearsNum_"^"_TInvoice
					/// 0				1			2			3		4			5			6				7				8			9			10			11					12				13			14				15			16
					xlsheet.Rows(j+2).Insert();
					xlsheet.cells(j+2,1)=OneDetailList[3];//��ⵥ��
					xlsheet.cells(j+2,2)=OneDetailList[16];//��Ʊ��
					xlsheet.cells(j+2,3)=OneDetailList[8];//�豸����
					xlsheet.cells(j+2,4)=OneDetailList[9];//����
					xlsheet.cells(j+2,5)=OneDetailList[1];//��Ӧ��
					xlsheet.cells(j+2,6)=OneDetailList[2];//�������
					xlsheet.cells(j+2,7)=OneDetailList[12];//ԭֵ
					xlsheet.cells(j+2,8)=OneDetailList[11];//����
					xlsheet.cells(j+2,9)=OneDetailList[13];//�ܽ��
					sum=sum+parseInt(OneDetailList[11])
					sumFee=sumFee+parseFloat(OneDetailList[13])
					var delRow=j+3;
			}
			xlsheet.cells(delRow,3)="�ϼ�";//�豸����
			xlsheet.cells(delRow,8)=sum;//�豸����
			xlsheet.cells(delRow,9)=sumFee;//�豸����
			//xlsheet.Rows(delRow).Delete();
			xlsheet.cells(delRow+1,1)="��ӡ����:"
			xlsheet.cells(delRow+1,2)=FormatDate(curDate);
			xlsheet.cells(delRow+1,5)="�Ƶ���:"
			xlsheet.cells(delRow+1,6)=curUserName;
		   	xlsheet.printout; 	//��ӡ���
		
		    xlBook.Close (savechanges=false);
		    	
		    xlsheet.Quit;
		    xlsheet=null;
		  	 	
		 	xlApp=null;
		} 
		catch(e)
		{
			alertShow(e.message);
		}
		*/
		BExcel_Operate("1");
	}
	if(PrintFlag==1)
	{
		var PreviewRptFlag=getElementValue("PreviewRptFlag");
		var fileName=""	;
        if(PreviewRptFlag==0)
        {
        fileName="{DHCEQInvoice.raq(CurUser="+curUserID+";USERNAME="+curUserName+";HOSPDESC="+curSSHospitalName+")}";
        DHCCPM_RQDirectPrint(fileName);
        }
        if(PreviewRptFlag==1)
        { 
        fileName="DHCEQInvoice.raq&CurUser="+curUserID+"&USERNAME="+curUserName+"&HOSPDESC="+curSSHospitalName;
        DHCCPM_RQPrint(fileName);
        }												
	}
  

}

//Add by zx 2020-12-11
//��Ʊ��˽��浼��
//modify by mwz 20220116 mwz0057 
function BExport_Clicked()
{
	var PrintFlag=tkMakeServerCall("web.DHCEQCommon","GetSysInfo",'990062');
	if (PrintFlag=="1")
	{
		//add by mwz 20230104 mwz0066 begin
		var Rows = $('#instocklistdatagrid').datagrid('getRows');
		var RowCount=Rows.length;
		if(RowCount<=0){
			messageShow("","","","û������!")
			return;
		}
		//add by mwz 20230104 mwz0066 end
		// MZY0113	2435347		2022-01-25
		if (!CheckColset("EQInStockDetailInvoice"))
		{
			messageShow('popover','alert','��ʾ',"����������δ����!")
			return ;
		}
		var url="dhccpmrunqianreport.csp?reportName=DHCEQInStockDetailInvoiceExport.raq&CurTableName=EQInStockDetailInvoice&CurUserID="+session['LOGON.USERID']+"&CurGroupID="+session['LOGON.GROUPID']+"&Job="+getElementValue("Job")
    	if ('function'==typeof websys_getMWToken){		//czf 2023-02-14 token���ò�������
			url += "&MWToken="+websys_getMWToken()
		}
    	window.open(url,'_blank','toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width=890,height=650,left=120,top=0');   //
	}
	else
	{
		if (getElementValue("ChromeFlag")=="1")
		{
			BSaveExcel_Chrome();
		}
		else
		{
			BSaveExcel_IE();
		}
	}
}

//Add by zx 2020-12-11
//Chrome�������������
function BSaveExcel_Chrome()
{
	var Node="InStockDetailInvoice";
	var Job=getElementValue("Job");
	var TotalRows=tkMakeServerCall("web.DHCEQCommon","GetTempDataRows",Node,Job);	
	var PageRows=TotalRows; //ÿҳ�̶�����
	var Pages=parseInt(TotalRows / PageRows) //��ҳ��-1  
	var ModRows=TotalRows%PageRows //���һҳ����
	if (ModRows==0) Pages=Pages-1
    var TemplatePath=tkMakeServerCall("web.DHCEQStoreMoveSP", "GetPath",'','');
    var Template=TemplatePath+"DHCEQInvoice.xls";
	//var Template="http://114.242.246.243:18080/imedical/med/Results/Template/DHCEQInvoice.xls"
	var AllListInfo=new Array();
	for (var i=0;i<=Pages;i++)
	{
    	var OnePageRow=PageRows;
    	if ((i==Pages)&&(ModRows!=0)) OnePageRow=ModRows;
    	for (var k=1;k<=OnePageRow;k++)
    	{
	    	var l=i*PageRows+k
	    	var OneDetail=tkMakeServerCall("web.DHCEQCommon", "GetTempData",Node,Job,l);
	    	var OneDetail =OneDetail.replace(",","��");
	    	var OneDetailList=OneDetail.split("^");
	    	AllListInfo.push(OneDetail)
    	}
	}
	var FileName=GetFileName();
	if (FileName=="") {return 0;}
	var NewFileName=filepath(FileName,"\\","\\\\")
	var NewFileName=NewFileName.substr(0,NewFileName.length-4)
	
	//Chorme����������Դ���
	var Str ="(function test(x){"
	Str +="var xlApp,xlsheet,xlBook;"
	Str +="xlApp = new ActiveXObject('Excel.Application');"
	Str +="for (var i=0;i<="+Pages+";i++){"
	Str +="xlBook = xlApp.Workbooks.Add('"+Template+"');"
	Str +="xlsheet = xlBook.ActiveSheet;"
	Str +="xlsheet.PageSetup.TopMargin=0;"
	Str +="var OnePageRow="+PageRows+";"
	Str +="if ((i=="+Pages+")&&("+ModRows+"!=0)) OnePageRow="+ModRows+";"
	Str +="xlsheet.cells.replace('[Hospital]','"+curSSHospitalName+"');" //modify by mwz 20210415 MWZ0046 
	Str +="for (var k=1;k<=OnePageRow;k++){"
	Str +="var l=i*"+PageRows+"+k;"
	Str +="var AllListInfoStr='"+AllListInfo+"';"
	Str +="var AllListInfo=AllListInfoStr.split(',');"
	Str +="var OneDetailList=AllListInfo[l-1].split('^');"
	Str +="var j=k+2;"   //modfiy by lmm 2020-21-2-2 1749527
	Str +="xlsheet.Rows(j).Insert();"
	Str +="var col=1;"
	Str +="xlsheet.cells(j,col++)=OneDetailList[3];"
	Str +="xlsheet.cells(j,col++)=OneDetailList[16];"
	Str +="xlsheet.cells(j,col++)=OneDetailList[8];"
	Str +="xlsheet.cells(j,col++)=OneDetailList[9];"
	Str +="xlsheet.cells(j,col++)=OneDetailList[1];"
	Str +="xlsheet.cells(j,col++)=OneDetailList[2];"
	Str +="xlsheet.cells(j,col++)=OneDetailList[12];"
	Str +="xlsheet.cells(j,col++)=OneDetailList[11];"
	Str +="xlsheet.cells(j,col++)=OneDetailList[13];"
	Str +="xlsheet.cells(j,col++)=OneDetailList[6];"
	Str +="xlsheet.cells(j,col++)=OneDetailList[18];"
	Str +="xlsheet.cells(j,col++)=OneDetailList[19];"
	Str +="xlsheet.cells(j,col++)=OneDetailList[17];}"
	Str +="xlsheet.Rows(j+1).Delete();"
	Str +="var printpage='';"
	Str +="if (i>0) {printpage='_'+i;}"  
	Str +="xlsheet.cells(j+1,1)='��ӡ����:';" //modify by mwz 20210515 MWZ0046 begin
	Str +="xlsheet.cells(j+1,2)=FormatDate(GetCurrentDate());"      
	Str +="xlsheet.cells(j+1,11)='�Ƶ���:';" 
	Str +="xlsheet.cells(j+1,12)='"+curUserName+"';" //modify by mwz 20210515 MWZ0049  end
	Str +="var savefile='"+NewFileName+"'+printpage+'.xls';"
	Str +="xlBook.SaveAs(savefile);"
	Str +="xlBook.Close (savechanges=false);"
	Str +="xlsheet.Quit;"
	Str +="xlsheet=null;}"
	Str +="xlApp=null;"
	Str +="return 1;}());";
	//����Ϊƴ��Excel��ӡ����Ϊ�ַ���
	CmdShell.notReturn = 0;   //�����޽�����ã�����������
	var rtn = CmdShell.EvalJs(Str);   //ͨ���м�����д�ӡ����
    alertShow("�������!");
}

//Add by zx 2020-12-11
//IE�������������
function BSaveExcel_IE()
{
	BExcel_Operate("0");
}

//Add by zx 2020-12-11 
//excel�������ӡ
function BExcel_Operate(printFlag)
{
	var Node="InStockDetailInvoice";
	var Job=getElementValue("Job");
	var TotalRows=tkMakeServerCall("web.DHCEQCommon","GetTempDataRows",Node,Job);	
	var PageRows=TotalRows; //ÿҳ�̶�����
	var Pages=parseInt(TotalRows / PageRows) //��ҳ��-1  
	var ModRows=TotalRows%PageRows //���һҳ����
	if (ModRows==0) Pages=Pages-1
	
	try
	{
        var xlApp,xlsheet,xlBook;
		var TemplatePath=tkMakeServerCall("web.DHCEQStoreMoveSP", "GetPath",'','');
	    var Template=TemplatePath+"DHCEQInvoice.xls";
	    xlApp = new ActiveXObject("Excel.Application");
	    for (var i=0;i<=Pages;i++)
	    {
	    	xlBook = xlApp.Workbooks.Add(Template);
	    	xlsheet = xlBook.ActiveSheet;
	    	xlsheet.PageSetup.TopMargin=0;
	    	var OnePageRow=PageRows;
	    	if ((i==Pages)&&(ModRows!=0)) OnePageRow=ModRows;
			var sum=0
			var sumFee=0
			var delRow=0;
		    xlsheet.cells.replace("[Hospital]",curHospitalName)
	    	for (var j=1;j<=OnePageRow;j++)
	    	{
		    	var l=i*PageRows+j
		    	var OneDetail=tkMakeServerCall("web.DHCEQCommon", "GetTempData",Node,Job,l);
		    	var OneDetailList=OneDetail.split("^");
		    	
			    xlsheet.Rows(j+2).Insert();
				xlsheet.cells(j+2,1)=OneDetailList[3];//��ⵥ��
				xlsheet.cells(j+2,2)=OneDetailList[16];//��Ʊ��
				xlsheet.cells(j+2,3)=OneDetailList[8];//�豸����
				xlsheet.cells(j+2,4)=OneDetailList[9];//����
				xlsheet.cells(j+2,5)=OneDetailList[1];//��Ӧ��
				xlsheet.cells(j+2,6)=OneDetailList[2];//�������
				xlsheet.cells(j+2,7)=OneDetailList[12];//ԭֵ
				xlsheet.cells(j+2,8)=OneDetailList[11];//����
				xlsheet.cells(j+2,9)=OneDetailList[13];//�ܽ��
				xlsheet.cells(j+2,10)=OneDetailList[6];//��������
				xlsheet.cells(j+2,11)=OneDetailList[18];//�ɹ�����
				xlsheet.cells(j+2,12)=OneDetailList[19];//��Դ
				xlsheet.cells(j+2,13)=OneDetailList[17];//��ע
				sum=sum+parseInt(OneDetailList[11]);
				sumFee=sumFee+parseFloat(OneDetailList[13]);
				delRow=j+3;
			}
	    	
		   	if(printFlag=="1")
		   	{
			   	xlsheet.cells(delRow,3)="�ϼ�";//�豸����
				xlsheet.cells(delRow,8)=sum;//�ϼ�����
				xlsheet.cells(delRow,9)=sumFee;//�ϼƽ��
				//xlsheet.Rows(OnePageRow+3).Delete();
				xlsheet.cells(delRow+1,1)="��ӡ����:"
				xlsheet.cells(delRow+1,2)=FormatDate(GetCurrentDate());
				xlsheet.cells(delRow+1,11)="�Ƶ���:"
				xlsheet.cells(delRow+1,12)=curUserName;
			   	xlsheet.printout; 	//��ӡ���
			}else{
				var savepath=GetFileName();
				xlBook.SaveAs(savepath);
		    	xlBook.Close (savechanges=false);
			}
	       	xlsheet.Quit;
	    	xlsheet=null;
	    }
	    xlApp=null;
	    alertShow("�������!");
	} 
	catch(e)
	{
		messageShow("","","",e.message);
	}
}
//add by mwz 20220117 mwz0057
//��������������
function BColSet_Click() 
{
	var para="&TableName=EQInStockDetailInvoice&SetType=0&SetID=0"
	var url="websys.default.hisui.csp?WEBSYS.TCOMPONENT=DHCEQCColSet"+para;
	showWindow(url,"����������","","","icon-w-paper","","","","large");   //modify by mwz 20220418 mwz0060 
}
