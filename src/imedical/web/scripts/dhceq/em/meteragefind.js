var columns=getCurColumnsInfo('DHCEQ.G.Maint.MaintList','','','');  
var toolbar=""  //Modefied by zc0107 2021-11-15
$(document).ready(function () {
	initDocument();
});
function initDocument()
{
	initUserInfo();
	defindTitleStyle(); 
	initButtonWidth();
	initButton();
	initLookUp();
	var TempFlag=$("#TempFlag").val();
	if (TempFlag==1) {hiddenObj("BAdd",1)}
    //modified by ZY20221115 �ظ������¼�
	//jQuery("#BAdd").linkbutton({iconCls: 'icon-w-add'});
	//jQuery("#BAdd").on("click", BAdd_Clicked);
	if (getElementValue("CollectFlag")=="Y")
	{
		jQuery("#BAdd").linkbutton("disable")
		jQuery("#BAdd").unbind();			
	}
	//Modefied by zc0103 2021-06-02 ������Ϣ���� begin
	if ((getElementValue("BussType")==2)&&(getElementValue("MaintTypeDR")==5))
	{
		toolbar=[
			{
				id:"import",
				iconCls:'icon-import',
				text:'����',
				handler:function(){ImportData();}
			}	
		]
	}
	if (getElementValue("PrivateFlag")!="")
	{
		setElement("PrivateFlag",curUserID);//MZY0121 2022-04-15
		disableElement("MaintUser",1);//MZY0124 2022-05-23
		setElement("MaintUser",curUserName);//modified by cjt 20221215 �����3118651
		setElement("MaintUserDR",curUserID);//modified by cjt 20221215 �����3118651
	}
	//Modefied by zc0103 2021-06-02 ������Ϣ���� end
	$HUI.datagrid("#maintfinddatagrid",{   
	   	url:$URL, 
		idField:'TRowID', //����
	    border : false,
		striped : true,
	    cache: false,
	    fit:true,
	    singleSelect:false,
	    queryParams:{
	        ClassName:"web.DHCEQ.EM.BUSMaint",
	        QueryName:"GetMaint",
	        BussType:getElementValue("BussType"),
	        EquipDR:getElementValue("EquipDR"),
	        MaintLocDR:getElementValue("ManageLocDR"),
	        MaintUserDR:getElementValue("MaintUserDR"),
	        MaintTypeDR:getElementValue("MaintTypeDR"),
	        StartDate:getElementValue("StartDate"),
	        EndDate:getElementValue("EndDate"),
	        Status:getElementValue("Status"),
	        QXType:getElementValue("QXType"),
	        CurUser:getElementValue("PrivateFlag"),	// MZY0121	2022-04-15
	        TypeCode:'',
	        MaintIDs:getElementValue("MaintIDs")	//CZF0134 2021-02-23
		},
		//fitColumns:true,
		pagination:true,
    	columns:columns, 
	});
	//End By QW20181225 �����:786608
	var TDetail=$("#maintfinddatagrid").datagrid('getColumnOption','TDetail');
	TDetail.formatter=	function(value,row,index){
			return mainOperation(value,row,index)	
		}	    
	var TMaintPlan=$("#maintfinddatagrid").datagrid('getColumnOption','TMaintPlan');
	TMaintPlan.formatter=	function(value,row,index){
			return mainplanOperation(value,row,index)	
		}
		
	//add by lmm 2018-11-14 begin 606420
	if (jQuery("#Status").prop("type")!="hidden")
	{
		var MapType = $HUI.combobox('#Status',{
		valueField:'id', textField:'text',panelHeight:"auto",
		data: [{
			id: '0',
			text: '����'
		},{
			id: '1',
			text: '�ύ'
		},{
			id: '2',
			text: '���'
		}],
		});
	}
	var TMaintDate=$('#maintfinddatagrid').datagrid('getColumnOption','TMaintDate');
	var TMaintLoc=$('#maintfinddatagrid').datagrid('getColumnOption','TMaintLoc');
	var TMaintMode=$('#maintfinddatagrid').datagrid('getColumnOption','TMaintMode');
	var TMaintType=$('#maintfinddatagrid').datagrid('getColumnOption','TMaintType');
	var TMaintUser=$('#maintfinddatagrid').datagrid('getColumnOption','TMaintUser');
	
	if ((getElementValue("BussType")==2)&&(getElementValue("MaintTypeDR")==5))
	{
		TMaintDate.title='��������'
		TMaintLoc.title='��������'
		TMaintMode.title='������ʽ'
		TMaintType.title='��������'
		TMaintUser.title='������'
	}
	else if (getElementValue("BussType")==1)
	{
		TMaintDate.title="��������"
		TMaintLoc.title='��������'
		TMaintMode.title='������ʽ'
		TMaintType.title='��������'
		TMaintUser.title='������'
	}	
	else
	{
		TMaintDate.title='Ѳ������'
		TMaintLoc.title='Ѳ�����'
		TMaintMode.title='Ѳ�췽ʽ'
		TMaintType.title='Ѳ������'
		TMaintUser.title='Ѳ����'
	}
	$('#maintfinddatagrid').datagrid();
	
	jQuery("#BColSet").linkbutton({iconCls: 'icon-w-config'});
	jQuery("#BColSet").on("click", BColSet_Clicked);
	jQuery("#BSaveExcel").linkbutton({iconCls: 'icon-w-export'});
	jQuery("#BSaveExcel").on("click", BSaveExcel_Clicked);
}

function BColSet_Clicked()
{
	var para="&TableName=Maint&SetType=0&SetID=0"
	var url="websys.default.hisui.csp?WEBSYS.TCOMPONENT=DHCEQCColSet"+para;
	colSetWindows(url)
}
// MZY0074	1839435		2021-04-30	����Jobȡֵ
function BSaveExcel_Clicked()
{
	var rows = $("#maintfinddatagrid").datagrid('getRows');
	if (rows.length>0)
	{
    	var vData=GetLnk()
		PrintDHCEQEquipNew("Maint",1,rows[0].TJob,vData,"",100);
	}
}
function GetLnk()
{
	var lnk="";
	lnk=lnk+"^BussType="+getElementValue("BussType");
	lnk=lnk+"^EquipDR="+getElementValue("EquipDR");
	lnk=lnk+"^ManageLocDR="+getElementValue("ManageLocDR");
	lnk=lnk+"^MaintUserDR="+getElementValue("MaintUserDR");
	lnk=lnk+"^MaintTypeDR="+getElementValue("MaintTypeDR");
	lnk=lnk+"^StartDate="+getElementValue("StartDate");
	lnk=lnk+"^EndDate="+getElementValue("EndDate");
	lnk=lnk+"^Status="+getElementValue("Status");
	lnk=lnk+"^QXType="+getElementValue("QXType");
	lnk=lnk+"^QXType=";
	lnk=lnk+"^CurUser=";
	lnk=lnk+"^TypeCode=";
	return lnk
}

function BAdd_Clicked()
{
	var height="";   //Modefied by zc0132 2023-03-15 ��ʼ�������߶�
	var model="large"  //Modefied by zc0132 2023-03-15 ��ʼ��������С
	//modify by lmm 2018-11-14 begin 748324
	if ((getElementValue("BussType")==2)&&(getElementValue("MaintTypeDR")==5))
	{
		var url="dhceq.em.meterage.csp?"+"&BussType="+getElementValue("BussType")+"&MaintTypeDR="+getElementValue("MaintTypeDR"); //modified by csj 20181211
		var title="������¼";
		model="middle"   //Modefied by zc0132 2023-03-15 �Զ��嵯����С
		height="10row" 	 //Modefied by zc0132 2023-03-15 �Զ��嵯���߶�
	}
	else if (getElementValue("BussType")==1)
	{
		// MZY0078	1958704		2021-05-31
		//var url="dhceq.em.maint.csp?"+"&BussType="+getElementValue("BussType")+"&MaintTypeDR="+getElementValue("MaintTypeDR"); //modified by csj 20181211
		//var title="������¼"
		var url="dhceq.em.preventivemaint.csp?"+"&BussType="+getElementValue("BussType")+"&MaintTypeDR="+getElementValue("MaintTypeDR");
		var title="Ԥ����ά����¼";
	}	
	else
	{
		var url="dhceq.em.inspect.csp?"+"&BussType="+getElementValue("BussType")+"&MaintTypeDR="+getElementValue("MaintTypeDR"); //modified by csj 20181211
		var title="Ѳ���¼";
	}
	//modify by lmm 2020-05-09 1311841
	var width=""
	// MZY0082	1965403		2021-07-14
	//var height="11row"   //MODIFY BY LMM 2021-03-09 1775358
	//var height="";    //Modefied by zc0132 2023-03-15 ��ʼ�������߶�λ�õ���
	var icon="icon-w-edit"
	var showtype=""
	showWindow(url,title,width,height,icon,showtype,"","",height);   //Modefied by zc0132 2023-03-15 �Զ��嵯����С
	//modify by lmm 2018-11-14 end 748324
}
//Modified By QW20181225 �����:786608
function BFind_Clicked()
{
		$HUI.datagrid("#maintfinddatagrid",{   
	    url:$URL, 
	    queryParams:{
	        ClassName:"web.DHCEQ.EM.BUSMaint",
	        QueryName:"GetMaint",
	        BussType:getElementValue("BussType"),
	        EquipDR:getElementValue("EquipDR"),
	        MaintLocDR:getElementValue("MaintLocDR"),	//  modify by yh 2019-10-28 YH00018
	        MaintUserDR:getElementValue("MaintUserDR"),
	        MaintTypeDR:getElementValue("MaintTypeDR"),//modified by csj 20181211
	        StartDate:getElementValue("StartDate"),
	        EndDate:getElementValue("EndDate"),
	        Status:getElementValue("Status"),
	        QXType:getElementValue("QXType"),
	        CurUser:getElementValue("PrivateFlag"),	// MZY0121	2022-04-15
	        TypeCode:'',
        MaintIDs:getElementValue("MaintIDs")	//CZF0134 2021-02-23
		    },
	});
}
///modify by lmm 2019-02-16 ���ӱ��⼰�����ߴ�
function mainplanOperation(value,row,index)
{
	var btn=""
	var height="710px"  //Modefied by zc0132 2023-03-15 ��ʼ�������߶�
	//modify by lmm 2020-05-26 1336941
		var para="&ReadOnly=1&BussType="+getElementValue("BussType")+"&SourceType=2&QXType=1&MaintLocDR="+row.TMaintLocDR+"&RowID="+row.TMaintPlanDR+"&ReadOnly=1"+"&EquipRangeDR="+row.TEquipRangeID;	//CZF0134 2021-02-23
	if ((getElementValue("BussType")==2)&&(getElementValue("MaintTypeDR")==5))
	{
		var url="dhceq.em.meterageplan.csp?";
		var title="�����ƻ�"
	}
	else if (getElementValue("BussType")==1)
	{
		// MZY0082	1965403		2021-07-14	�������Ӵ���
		var url="dhceq.em.maintplan.csp?";
		//var title="�����ƻ�"
		var title="Ԥ����ά���ƻ�";
	}	
	else
	{
		var url="dhceq.em.inspectplan.csp?";
		var title="Ѳ��ƻ�"
		height="560px"  //Modefied by zc0132 2023-03-15 Ѳ���ض��嵯���߶�
	}	
		
		url=url+para;
		var icon="icon-w-paper"	 //modify by lmm 2018-11-14
		var type=""	 //modify by lmm 2018-11-14
		//modified by csj 20181128 �����:762692
		//modify by lmm 2020-0202-06-05 UI
		btn='<A onclick="showWindow(&quot;'+url+'&quot;,&quot;'+title+'&quot;,&quot;&quot;,&quot;'+height+'&quot;,&quot;'+icon+'&quot;,&quot;'+type+'&quot;,&quot;&quot;,&quot;&quot;,&quot;large&quot;)" href="#">'+row.TMaintPlan+'</A>';   //Modefied by zc0132 2023-03-15 �޸ĵ����߶�
	return btn;
	
}
//Add By QW20181225 �����:786608
function setSelectValue(vElementID,item)
{
	setElement(vElementID+"DR",item.TRowID)
	//add hly 2019-10-14
	if(vElementID=="MaintType")
	{
		setElement("MaintType",item.TDesc);
	}
}
//Add By QW20181225 �����:786608
function clearData(vElementID)
{
	setElement(vElementID+"DR","")
}
function mainOperation(value,row,index)
{
	var btn=""
	var height="";   //Modefied by zc0132 2023-03-15 ��ʼ�������߶�
	var model="large"  //Modefied by zc0132 2023-03-15 ��ʼ��������С
	//modify by lmm 2020-08-10
		var para="&BussType="+getElementValue("BussType")+"&EquipDR="+row.TEquipDR+"&RowID="+row.TRowID+"&CollectFlag="+getElementValue("CollectFlag");
		if ((getElementValue("BussType")==2)&&(getElementValue("MaintTypeDR")==5))
		{
			var url="dhceq.em.meterage.csp?";
			var title="������¼"
			model="middle"   //Modefied by zc0132 2023-03-15 �Զ��嵯����С
			height="10row" 	 //Modefied by zc0132 2023-03-15 �Զ��嵯���߶�
		}
		else if (getElementValue("BussType")==1)
		{
			// MZY0076	2021-05-25
			//var url="dhceq.em.maint.csp?";
			//var title="������¼"
			var url="dhceq.em.preventivemaint.csp?";
			var title="Ԥ����ά����¼";
		}	
		else
		{
			var url="dhceq.em.inspect.csp?";
			var title="Ѳ���¼"
		}	
		url=url+para;	
		var icon="icon-w-paper"
		var type=""
		btn='<A onclick="showWindow(&quot;'+url+'&quot;,&quot;'+title+'&quot;,&quot;&quot;,&quot;'+height+'&quot;,&quot;'+icon+'&quot;,&quot;'+type+'&quot;,&quot;&quot;,&quot;&quot;,&quot;'+model+'&quot;)" href="#"><img border=0 complete="complete" src="../scripts_lib/hisui-0.1.0/dist/css/icons/paper.png" /></A>'; //Modefied by zc0132 2023-03-15 �Զ��嵯����С
	return btn;
}

///add by czf ������ʷά����¼
function maintHistoryList(index)
{
	var curRowObj=$('#maintfinddatagrid').datagrid('getRows')[index];
	var MPType=getElementValue("BussType");
	var MaintType=getElementValue("MaintTypeDR");
	var EquipDR=curRowObj.TEquipDR;
	$.cm({
		ClassName:"web.DHCEQ.EM.BUSMaint",
		QueryName:"GetMaint",
		BussType:MPType,
		EquipDR:EquipDR,
		CurUser:getElementValue("PrivateFlag"),	// MZY0121	2022-04-15
		MaintTypeDR:MaintType
	},function(jsonData){
		if(jsonData.rows.length<1)
		{
			alertShow("û����ʷά����¼");
			return;
		}
		else
		{
			var url="dhceq.em.mainthistorylist.csp?&MPType="+MPType+"&MaintType="+MaintType+"&EquipDR="+EquipDR;
			//modify by lmm 2020-06-03
			showWindow(url,"��ʷά����¼","","16row","icon-w-paper","modal","","","small") //modify by lmm 2020-06-05 UI
		}
	});
}
//Modefied by zc0103 2021-06-02 ������Ϣ���� 
function ImportData()
{
	if (getElementValue("ChromeFlag")=="1")
	{
		BImport_Chrome()
	}
	else
	{
		BImport_IE()
	}
}
//Modefied by zc0103 2021-06-02 ������Ϣ���� 
function BImport_Chrome()
{
	var RowInfo=websys_ReadExcel('');
	if ((RowInfo=="")||(RowInfo.length<=1))
	{
		alertShow("û�����ݵ��룡")
		return 0;
	}
    var EquipIDs=""
	for (var Row=2;Row<=RowInfo.length;Row++)
	{
	    var Col=0;  
		var	EquipID=""
		var EqNo=trim(RowInfo[Row-1][Col++]);   						//�豸���
		if (EqNo==undefined) EqNo=""
		var EqName=trim(RowInfo[Row-1][Col++]);							//�豸����
		if (EqName==undefined) EqName=""
		var UseLoc=trim(RowInfo[Row-1][Col++]);						//ʹ�ÿ���
		if (UseLoc==undefined) UseLoc=""
		var UseLocDR="";  
		var MaintLoc=trim(RowInfo[Row-1][Col++]);						//��������
		if (MaintLoc==undefined) MaintLoc=""
		var MaintLocDR="";  
		var MaintType=trim(RowInfo[Row-1][Col++]);						//������ʽ
		if (MaintType==undefined) MaintType=""
		var MaintTypeDR=""
		var MaintDate=trim(RowInfo[Row-1][Col++]);						//��������
		if (MaintDate==undefined) MaintDate=""
		var CertificateNo=trim(RowInfo[Row-1][Col++]);					//����֤���
		if (CertificateNo==undefined) CertificateNo=""
		var CertificateValidityNum=trim(RowInfo[Row-1][Col++]);	//������Ч��(��)
		if (CertificateValidityNum==undefined) CertificateValidityNum=""
		var MaintFee=trim(RowInfo[Row-1][Col++]);						//��������
		if (MaintFee==undefined) MaintFee=""
		if (EqNo=="")
		{
		    alertShow("��"+Row+"��"+"�豸���Ϊ��!");
		    return 0;
		}
		if (EqName=="")
		{
		    alertShow("��"+Row+"��"+"�豸����Ϊ��!");
		    return 0;
		}
		if (MaintDate=="")
		{
		    alertShow("��"+Row+"��"+"��������Ϊ��!");
		    return 0;
		}
		if (MaintType=="")
		{
		    alertShow("��"+Row+"��"+"��������Ϊ��!");
		    return 0;
		}
		if (CertificateValidityNum=="")
		{
		    alertShow("��"+Row+"��"+"������Ч��Ϊ��!");
		    return 0;
		}
		if (isNaN(CertificateValidityNum))
		{
		    alertShow("��"+Row+"��"+"������Ч��(��)��Ϊ��ֵ!");
		    return 0;
		}
		var CertificateValidityDate=tkMakeServerCall("web.DHCEQCommon","DateAdd",'M',CertificateValidityNum,MaintDate);
		if (CertificateNo=="")
		{
		    alertShow("��"+Row+"��"+"����֤���Ϊ��!");
		    return 0;
		}
		if (CertificateValidityDate=="")
		{
		    alertShow("��"+Row+"��"+"������Ч��Ϊ��!");
		    return 0;
		}
		var EquipID=tkMakeServerCall("web.DHCEQEquip","GetEquipIDByNo",EqNo);
		if (EquipID=="")
		{
			alertShow("��"+Row+"��"+EqName+"������!");
		    return 1;
		}
		if (UseLoc!="")
		{
			UseLocDR=tkMakeServerCall("web.DHCEQImportDataTool","GetUseLocID",UseLoc);
			if (UseLocDR=="")
			{
				alertShow("��"+Row+"�� ʹ�ÿ��ҵ���Ϣ����ȷ:"+MaintLoc);
				return 0;
			}
		}
		if (MaintLoc!="")
		{
			MaintLocDR=tkMakeServerCall("web.DHCEQImportDataTool","GetUseLocID",MaintLoc);
			if (MaintLocDR=="")
			{
				alertShow("��"+Row+"�� �������ҵ���Ϣ����ȷ:"+MaintLoc);
				return 0;
			}
		}
		if (MaintType!="")
		{
			MaintTypeDR=tkMakeServerCall("web.DHCEQCommonEX","GetIDByDesc","DHCEQCMaintType",MaintType);
			if (MaintTypeDR=="")
			{
				alertShow("��"+Row+"�� �������ҵ���Ϣ����ȷ:"+MaintType);
				return 0;
			}
		}
		var combindata="";	//1
		combindata="" ; //1
		combindata=combindata+"^"+EquipID ; //2
		combindata=combindata+"^"+getElementValue("BussType") ; //3
		combindata=combindata+"^"+"" ; //4
		combindata=combindata+"^"+MaintTypeDR; //5
		combindata=combindata+"^"+MaintDate ; //6
		combindata=combindata+"^"+MaintLocDR ; //7
		combindata=combindata+"^"+"" ; //8
		combindata=combindata+"^"+""; //9
		combindata=combindata+"^"+MaintFee ; //10
		combindata=combindata+"^"+"" ; //11
		combindata=combindata+"^"+"" ; //12
		combindata=combindata+"^"+UseLocDR ; //13
		combindata=combindata+"^"+"" ; //14
		combindata=combindata+"^"+"" ; //15
		combindata=combindata+"^"+MaintFee ; //16
		combindata=combindata+"^"+"" ; //17  Hold1��Ϊ��ͬ  modify by lmm 2020-04-29 1279496
		combindata=combindata+"^"+"" ; //18
		combindata=combindata+"^"+"" ; //19
		combindata=combindata+"^"+""; //20
		combindata=combindata+"^"+"" ; //21
		combindata=combindata+"^"+"" ; //22
		combindata=combindata+"^"+"" ; //23
		combindata=combindata+"^"+"" ; //24
		combindata=combindata+"^"+"" ; //25
		combindata=combindata+"^"+"" ; //26
		combindata=combindata+"^"+""; //27
		combindata=combindata+"^"+"" ; //28
		combindata=combindata+"^"+"" ; //29
		combindata=combindata+"^"+"" ; //30
		combindata=combindata+"^"+"0" ; //31
		combindata=combindata+"^"+CertificateValidityDate ; //32
		combindata=combindata+"^"+CertificateNo ; //33	Mozy0193	20170817
		combindata=combindata+"^"+"" ; //34	add by csj 20191018 �ƻ�ִ�е�ID
	}    
	var Rtn = tkMakeServerCall("web.DHCEQ.EM.BUSMaint", "SaveData",combindata,'1','1');
		
	if (Rtn<0) 
	{
		alertShow("��"+i+"�� <"+xlsheet.cells(i,4).text+"> ��Ϣ����ʧ��!!!���ؼ�������Ϣ����������ٴε��������Ϣ.");;
		return;	
	}
	else
	{
		var result = tkMakeServerCall("web.DHCEQ.EM.BUSMaint", "SubmitData",Rtn,"",getElementValue("BussType"),EquipID,"","");
		if (result<0) 
		{
			alertShow("��"+i+"�� <"+xlsheet.cells(i,4).text+"> ��Ϣ���뵼��ɹ���Ҫ�ֹ��ύ������Ϣ.");;
			return;	
		}
	}
	alertShow("���������Ϣ�������!��˶������Ϣ.");
	window.location.reload();

}
//Modefied by zc0103 2021-06-02 ������Ϣ���� 
function BImport_IE()
{
	
	var FileName=GetFileName();
	if (FileName=="") {return 0;}
	var xlApp,xlsheet,xlBook
	xlApp = new ActiveXObject("Excel.Application");
	xlBook = xlApp.Workbooks.Add(FileName);
	xlsheet =xlBook.Worksheets(1);
	xlsheet = xlBook.ActiveSheet;
	var ExcelRows=xlsheet.UsedRange.Cells.Rows.Count;
	for (var Row=2;Row<=ExcelRows;Row++)
	{
		var Col=1;
		var	EquipID=""
		var EqNo=trim(xlsheet.cells(Row,Col++).text);     						//�豸���
		var EqName=trim(xlsheet.cells(Row,Col++).text);							//�豸����
		var UseLoc=trim(xlsheet.cells(Row,Col++).text);						//ʹ�ÿ���
		var UseLocDR="";  
		var MaintLoc=trim(xlsheet.cells(Row,Col++).text);						//��������
		var MaintLocDR="";  
		var MaintType=trim(xlsheet.cells(Row,Col++).text);						//������ʽ
		var MaintTypeDR=""
		var MaintDate=trim(xlsheet.cells(Row,Col++).text);						//��������
		var CertificateNo=trim(xlsheet.cells(Row,Col++).text);					//����֤���
		var CertificateValidityNum=trim(xlsheet.cells(Row,Col++).text);		//������Ч��(��)
		var MaintFee=trim(xlsheet.cells(Row,Col++).text);						//��������
		if (EqNo=="")
		{
		    alertShow("��"+Row+"��"+"�豸���Ϊ��!");
		    return 0;
		}
		if (EqName=="")
		{
		    alertShow("��"+Row+"��"+"�豸����Ϊ��!");
		    return 0;
		}
		if (MaintDate=="")
		{
		    alertShow("��"+Row+"��"+"��������Ϊ��!");
		    return 0;
		}
		if (MaintType=="")
		{
		    alertShow("��"+Row+"��"+"��������Ϊ��!");
		    return 0;
		}
		if (CertificateValidityNum=="")
		{
		    alertShow("��"+Row+"��"+"������Ч��Ϊ��!");
		    return 0;
		}
		if (isNaN(CertificateValidityNum))
		{
		    alertShow("��"+Row+"��"+"������Ч��(��)��Ϊ��ֵ!");
		    return 0;
		}
		var CertificateValidityDate=tkMakeServerCall("web.DHCEQCommon","DateAdd",'M',CertificateValidityNum,MaintDate);
		if (CertificateNo=="")
		{
		    alertShow("��"+Row+"��"+"����֤���Ϊ��!");
		    return 0;
		}
		if (CertificateValidityDate=="")
		{
		    alertShow("��"+Row+"��"+"������Ч��Ϊ��!");
		    return 0;
		}
		var EquipID=tkMakeServerCall("web.DHCEQEquip","GetEquipIDByNo",EqNo);
		if (EquipID=="")
		{
			alertShow("��"+Row+"��"+EqName+"������!");
		    return 1;
		}
		if (UseLoc!="")
		{
			UseLocDR=tkMakeServerCall("web.DHCEQImportDataTool","GetUseLocID",UseLoc);
			if (UseLocDR=="")
			{
				alertShow("��"+Row+"�� ʹ�ÿ��ҵ���Ϣ����ȷ:"+MaintLoc);
				return 0;
			}
		}
		if (MaintLoc!="")
		{
			MaintLocDR=tkMakeServerCall("web.DHCEQImportDataTool","GetUseLocID",MaintLoc);
			if (MaintLocDR=="")
			{
				alertShow("��"+Row+"�� �������ҵ���Ϣ����ȷ:"+MaintLoc);
				return 0;
			}
		}
		if (MaintType!="")
		{
			MaintTypeDR=tkMakeServerCall("web.DHCEQCommonEX","GetIDByDesc","DHCEQCMaintType",MaintType);
			if (MaintTypeDR=="")
			{
				alertShow("��"+Row+"�� �������ҵ���Ϣ����ȷ:"+MaintType);
				return 0;
			}
		}
		var combindata="";	//1
		combindata="" ; //1
		combindata=combindata+"^"+EquipID ; //2
		combindata=combindata+"^"+getElementValue("BussType") ; //3
		combindata=combindata+"^"+"" ; //4
		combindata=combindata+"^"+MaintTypeDR; //5
		combindata=combindata+"^"+MaintDate ; //6
		combindata=combindata+"^"+MaintLocDR ; //7
		combindata=combindata+"^"+"" ; //8
		combindata=combindata+"^"+""; //9
		combindata=combindata+"^"+MaintFee ; //10
		combindata=combindata+"^"+"" ; //11
		combindata=combindata+"^"+"" ; //12
		combindata=combindata+"^"+UseLocDR ; //13
		combindata=combindata+"^"+"" ; //14
		combindata=combindata+"^"+"" ; //15
		combindata=combindata+"^"+MaintFee ; //16
		combindata=combindata+"^"+"" ; //17  Hold1��Ϊ��ͬ  modify by lmm 2020-04-29 1279496
		combindata=combindata+"^"+"" ; //18
		combindata=combindata+"^"+"" ; //19
		combindata=combindata+"^"+""; //20
		combindata=combindata+"^"+"" ; //21
		combindata=combindata+"^"+"" ; //22
		combindata=combindata+"^"+"" ; //23
		combindata=combindata+"^"+"" ; //24
		combindata=combindata+"^"+"" ; //25
		combindata=combindata+"^"+"" ; //26
		combindata=combindata+"^"+""; //27
		combindata=combindata+"^"+"" ; //28
		combindata=combindata+"^"+"" ; //29
		combindata=combindata+"^"+"" ; //30
		combindata=combindata+"^"+"0" ; //31
		combindata=combindata+"^"+CertificateValidityDate ; //32
		combindata=combindata+"^"+CertificateNo ; //33	Mozy0193	20170817
		combindata=combindata+"^"+"" ; //34	add by csj 20191018 �ƻ�ִ�е�ID
	}
	xlsheet.Quit;
	xlsheet=null;
	xlBook.Close (savechanges=false);
	xlApp=null;
	
	var Rtn = tkMakeServerCall("web.DHCEQ.EM.BUSMaint", "SaveData",combindata,'1','1');
		
	if (Rtn<0) 
	{
		alertShow("��"+i+"�� <"+xlsheet.cells(i,4).text+"> ��Ϣ����ʧ��!!!���ؼ�������Ϣ����������ٴε��������Ϣ.");;
		return;	
	}
	else
	{
		var result = tkMakeServerCall("web.DHCEQ.EM.BUSMaint", "SubmitData",Rtn,"",getElementValue("BussType"),EquipID,"","");
		if (result<0) 
		{
			alertShow("��"+i+"�� <"+xlsheet.cells(i,4).text+"> ��Ϣ���뵼��ɹ���Ҫ�ֹ��ύ������Ϣ.");;
			return;	
		}
	}
	alertShow("���������Ϣ�������!��˶������Ϣ.");
	window.location.reload();
}
