
///modified by ZY 20221115 3081237
Array.prototype.indexOf = function(val) {
    for (var i = 0; i < this.length; i++) {
        if (this[i] == val) return i;
    }
    return -1;
};
Array.prototype.remove = function(val) {
    var index = this.indexOf(val);
    if (index > -1) {
        this.splice(index, 1);
    }
};
var fileview = $.extend({}, $.fn.datagrid.defaults.view, { onAfterRender: function (target) { isselectItem(); } });
var selectItems = new Array();
var columns=getCurColumnsInfo('EM.G.Equip.EquipList','','','','N');
var frozencolumns=getCurColumnsInfo('EM.G.Equip.EquipList','','','','Y');
$(function(){
	initDocument();
});

function initDocument()
{
	initUserInfo();
	initLookUp();
	defindTitleStyle();
	initButton(); //��ť��ʼ��
	//initButtonWidth();  //add by lmm 2019-10-23 1060991
}
function setSelectValue(vElementID,item)
{
	setElement(vElementID+"DR",item.TRowID)
}
function clearData(vElementID)
{
	setElement(vElementID+"DR","")
	if(vElementID=="EquipType")
	{
		setElement("StatCatDR","")
		setElement("StatCat","")
	}
}
$HUI.datagrid("#DHCEQEquipFacilityFind",{   
    url:$URL, 
    queryParams:{
        ClassName:"web.DHCEQ.EM.BUSEquip",
        QueryName:"GetEquipList",
        Data:GetParams()+"^InitFlag=Y",	//modified ZY20221226 bug:3081274
        Ejob:getElementValue("Job"),    //add by yh 2020-01-15
        ReadOnly:""
    },
    border:false,
    fit:true,
	fitColumns:false,		// MZY0153	3206641		2023-02-20
    //singleSelect:true,	//modified by ZY 20221115 3081237
    rownumbers: true,  //���Ϊtrue������ʾһ���к���
	columns:columns, 
	frozenColumns:frozencolumns,
	pagination:true,
	pageSize:25,
	pageNumber:1,
	pageList:[25,50,75,100],
	toolbar:[{
				iconCls: 'icon-print',
            	text:'������ӡ����',          
            	handler: function(){
                	BPrintBar_Clicked();
            }},
            {
                iconCls: 'icon-batch-cfg',
                text:'����������',
                handler: function(){
                     BColSet_Click();
            }},    //modify by lmm 2020-04-03
            {
            	iconCls: 'icon-export',
            	text:'����',
            	handler: function(){
                	BSaveExcel_Clicked();
            }},    //modify by zc0125 2022-11-09 ���ӵ��밴ť begin
            {
            	iconCls: 'icon-import',
            	text:'����',
            	handler: function(){
                	BImport_Click();
            }}],	//modify by zc0125 2022-11-09 ���ӵ��밴ť end
	//modify by cjt 20220925 �����2801297
	onDblClickRow:function(rowIndex, rowData)
	{	
		if (rowData.TRowID!="")
		{
			if (getElementValue("ClassFlag")=="N")
			{
				var str="dhceq.em.equipfacility.csp?RowID="+rowData.TRowID+"&ReadOnly=";
				showWindow(str,"����̨��","","586px","icon-w-paper","modal","","","large")     //MZY0157	3220853		2023-03-29
			}
			else
			{
				var str="dhceq.em.equipclass.csp?RowID="+rowData.TRowID+"&ReadOnly=";
				showWindow(str,"����̨��","655px","282px","icon-w-paper","modal","","","small")     // MZY0151	2023-02-01  //modified by txr 20230324
			}
		}
	},
	onLoadSuccess: function (data) {
		//var lable_innerText='������:'+totalSum("DHCEQEquipFacilityFind","TQuantity")+'&nbsp;&nbsp;&nbsp;�ܽ��:'+totalSum("DHCEQEquipFacilityFind","TOriginalFee").toFixed(2)
		//$("#sumTotal").html(lable_innerText);
		InitToolbarForAmountInfo();  //add by wy 2022-3-31 WY0099
		//add by wy 2022-4-15  ���β���ʾ����
		if (getElementValue("ClassFlag")=="Y") {
			var fields = $("#DHCEQEquipFacilityFind").datagrid('getColumnFields');
            for (var i = 0; i < fields.length; i++) {
	            
                var option = $("#DHCEQEquipFacilityFind").datagrid('getColumnOption', fields[i]);
	           $('#DHCEQEquipFacilityFind').datagrid('hideColumn',option.field );

            }
		$('#DHCEQEquipFacilityFind').datagrid('showColumn','TCommonName')
		$('#DHCEQEquipFacilityFind').datagrid('showColumn','TEquipType')
		$('#DHCEQEquipFacilityFind').datagrid('showColumn','TStatCat')
		$('#DHCEQEquipFacilityFind').datagrid('showColumn','TEquiCat')
		$('#DHCEQEquipFacilityFind').datagrid('hideColumn','TNo')
		}


    },
    //modified by ZY 20221115 3081237
    onClickRow:function(rowIndex,rowData){addselectItem(rowIndex,rowData);},
});
// add by wy 2022-3-31 WY0099 ����̨����ϸ�˵�������ʾ�ϼ���Ϣ
function InitToolbarForAmountInfo() {
    
    //modified by ZY 20221115 3081219 �޸ĺϼ���ȡֵλ��
    //var Data = tkMakeServerCall("web.DHCEQEquipSave","GetEquipSumInfo",'',getElementValue("Job"),0);   //Modified by JYP0019 ̨�����job�Զ��û��������� //add by wy 2022-3-31 WY0099 ���Ӳ���vType
    var Data = tkMakeServerCall("web.DHCEQ.Plat.LIBCommon","GetTempGlobalTotalInfo",'EquipList','',getElementValue("Job"),'','1'); 
    $("#sumTotal").html(Data);  
    
    //var Data = tkMakeServerCall("web.DHCEQEquipSave","GetEquipSumInfo",'',getElementValue("Job"),1);   //Modified by JYP0019 ̨�����job�Զ��û���������
    //$("#sumTotal").html(Data);  
}
///��ӡ����
function BPrintBar_Clicked()
{
	var url='websys.default.hisui.csp?WEBSYS.TCOMPONENT=DHCEQPrintBarCode&Job='+getElementValue("Job");  //modified by csj 2020-03-01 ����ţ�1206002
    showWindow(url,"������ӡ����","","7row","icon-w-paper","modal","","","small")  //modify by lmm 2020-06-04 UI
}

///�����¼�
function BAdd_Clicked()
{
    //add by wy 2022-4-15 �ֿ������豸�������豸
	if (getElementValue("ClassFlag")=="N")
	{
		var url='dhceq.em.equipfacility.csp?RowID=';
		showWindow(url,"����̨��","","586px","icon-w-paper","modal","","","large")     //MZY0157	3220853		2023-03-29
	}
	else
	{
		var url='dhceq.em.equipclass.csp?RowID=';
		showWindow(url,"����̨��","655px","280px","icon-w-paper","modal","","","small")     // MZY0151	2023-02-01   //modified by txr 20230324
	}
}

///��ѯ�¼�
function BFind_Clicked()
{
	$HUI.datagrid("#DHCEQEquipFacilityFind",{
		url:$URL, 
	    queryParams:{
	        ClassName:"web.DHCEQ.EM.BUSEquip",
	        QueryName:"GetEquipList",
	        Data:GetParams(),
	       Ejob:getElementValue("Job"),//add by yh 2020-01-15 
	        ReadOnly:""
	    }
	});
}
function BSaveExcel_Clicked()
{
    vData=GetParams();
    ///modified by ZY 20221115 bug:3081207
    PrintDHCEQEquipNew("Equip",1,getElementValue("Job"),vData,"EquipList",100);  //modify by lmm 2020-05-26 1333444
}
function BColSet_Click() //��������������
{
	var para="&TableName=Equip&SetType=0&SetID=0"
	var url="websys.default.hisui.csp?WEBSYS.TCOMPONENT=DHCEQCColSet"+para;
	colSetWindows(url)     //modify by lmm 2020-06-02 UI
}
function GetParams()
{
	var Params="^No="+getElementValue("No");
	Params=Params+"^Name="+getElementValue("Name");
	Params=Params+"^UseLocDR="+getElementValue("UseLocDR");
	Params=Params+"^Code="+getElementValue("Code");
	Params=Params+"^EquipTypeDR="+getElementValue("EquipTypeDR");
	Params=Params+"^MinValue="+getElementValue("MinValue");
	Params=Params+"^MaxValue="+getElementValue("MaxValue");
	Params=Params+"^BeginInStockDate="+getElementValue("BeginInStockDate");
	Params=Params+"^EndInStockDate="+getElementValue("EndInStockDate");
	Params=Params+"^FacilityFlag="+getElementValue("FacilityFlag");
	Params=Params+"^IsDisused=N";
	Params=Params+"^IsOut=N";
	Params=Params+"^ConditionLimit=1";  ///Modefied by ZC0081 2020-09-07 ���ConditionLimit������Ʋ��ܼ�������
	Params=Params+"^ClassFlag="+getElementValue("ClassFlag");  //add by wy 2022-4-15 ������
	return Params;
}
function  PrintDHCEQEquip(TableName,SaveOrPrint,job,vData,TempNode,GetRowsPerTime)
{
	window.clipboardData.clearData();
	if (!TempNode)
	{
		TempNode="";
	} 
	var num=tkMakeServerCall("web.DHCEQEquipSave","GetNum","",job)  // �����������޸� modify by jyp 20200212    JYP0020  ����ţ�1188971
	
	if (num<1) {alertShow("��ûֵ")}
	else
	{
     try {
	     if (SaveOrPrint=="1")
	     {
		     var FileName=GetFileName();
		     if (FileName=="") {return;}
	     }
      	var TemplatePath=tkMakeServerCall("web.DHCEQStoreMoveSP","GetPath");

		var	colsets=tkMakeServerCall("web.DHCEQCColSet","GetColSets","","2","",TableName); //�û�������
		if (colsets=="")
		{
			var	colsets=tkMakeServerCall("web.DHCEQCColSet","GetColSets","","1","",TableName); //��ȫ�鼶����
			if (colsets=="")
			{
				var	colsets=tkMakeServerCall("web.DHCEQCColSet","GetColSets","","0","",TableName); //ϵͳ����
			}
		}
		if (colsets=="")
		{
			alertShow("����������δ����!")
			return
		}
		var colsetlist=colsets.split("&");
		var colname=new Array()
		var colcaption=new Array()
		var colposition=new Array()
		var colformat=new Array()
		var colwidth=new Array()
		var cols=colsetlist.length
		for (i=0;i<cols;i++)
		{
			var colsetinfo=colsetlist[i].split("^");
			colcaption[i]=colsetinfo[1];
			colname[i]=colsetinfo[2];
			colposition[i]=colsetinfo[3];
			colformat[i]=colsetinfo[4];
			colwidth[i]=colsetinfo[5];
		}
			
        var xlApp,xlsheet,xlBook
	    var Template=TemplatePath+"DHCEQBlank.xls";
	    xlApp = new ActiveXObject("Excel.Application");
	    xlBook = xlApp.Workbooks.Add(Template);
	    xlsheet = xlBook.ActiveSheet
	    //��ȡ��ͷ��Ϣ
	    var TitleInfo=tkMakeServerCall("web.DHCEQCommon","GetTitleInfo","Equip");
	    var TitleRow=0
	    if (TitleInfo!="")
	    {
		    TitleInfo=TitleInfo.split("@")
		    TitleRow=TitleInfo[0]*1
		    var ParaInfo=TitleInfo[1].split("&")
		    for (i=1;i<=TitleRow;i++)
		    {
			    xlsheet.Range(xlsheet.Cells(i,1),xlsheet.Cells(i,cols)).MergeCells = true;
			    xlsheet.cells(i,1)=ParaInfo[i-1]
		    }
		    if (TitleRow>0)
		    {
			    xlsheet.cells(1,1).Font.Bold = true;
			    xlsheet.cells(1,1).Font.Size = 20;
			    xlsheet.cells(1,1).EntireRow.AutoFit
			    xlsheet.cells(1,1).HorizontalAlignment = 3;
			    xlsheet.PageSetup.PrintTitleRows ="$1:$"+(TitleRow+1)
		    }
		    ParameterReplace(xlsheet,vData)
	    }
	    else
	    {
		    xlsheet.PageSetup.PrintTitleRows ="$1:$1"
	    }
	    xlsheet.PageSetup.LeftFooter="�Ʊ���:"+curUserName
	    xlsheet.PageSetup.RightFooter="��&Pҳ(��&Nҳ)"
	    //
	    for (i=0;i<cols;i++)
	    {
		    xlsheet.cells(TitleRow+1,i+1)=colcaption[i];
	    	if (colwidth[i]!="")
	    	{
		    	xlsheet.Columns(i+1).ColumnWidth =colwidth[i];
	    	}
		}
	    num=parseFloat(num);
	    ///�Ż�̨�ʵ���Ч��?���Ӳ���ÿ�λ�ȡ������Ϣ
	    var splitChar=String.fromCharCode(2);
	    var endRow;
	    
	    for (Row=1;Row<=num;Row++)
	    { 
	   		var list=document.getElementById('GetList');
		 	if (list) {var encmeth=list.value} else {var encmeth=''};
		 	
		 	///�Ż�̨�ʵ���Ч��?���Ӳ���ÿ�λ�ȡ������Ϣ
		 	if (!GetRowsPerTime)
		 	{	endRow=Row;	}
		 	else
			{	endRow=Row+GetRowsPerTime-1;	}
			if (endRow>num) endRow=num;
			var rowsCount=endRow-Row+1;
			var strConcat="";
			var strArr=new Array();
			var beginRow=Row;
			var fieldVal;
		
		 	if (!GetRowsPerTime)
		 	{
			 	var str=tkMakeServerCall("web.DHCEQEquipSave","GetList",TempNode,job,Row);
		 	}
		 	else
		 	{
				var str=tkMakeServerCall("web.DHCEQEquipSave","GetList",TempNode,job,Row,rowsCount)
		 	}
			var rowVal=str.split(splitChar);
			
			for (j=0;j<rowsCount;j++)
			{			
				var List=rowVal[j].split("^");
		    	var strLine=""
		    	for (i=1;i<=cols;i++)
		    	{
			    	var position=colposition[i-1];
			    	if (position>0)
			    	{	position=position-1;}
			    	else
			    	{	position=0}
			    	
			    	fieldVal=List[position];
			    	if (colformat[i-1]==2)
				    {
					   	if (Row==1) xlsheet.Range(xlsheet.Cells(2+TitleRow,i),xlsheet.Cells(num+TitleRow+1,i)).NumberFormatLocal = "0.00_ ";
					}
					else if (colformat[i-1]==4)
					{
					    if (Row==1) xlsheet.Range(xlsheet.Cells(2+TitleRow,i),xlsheet.Cells(num+TitleRow+1,i)).NumberFormatLocal = "@";
					}
				    else if (colformat[i-1]!="")
				    {
				    	fieldVal=ColFormat(fieldVal,colformat[i-1]);
				    }
				    fieldVal=fieldVal.replace(/\t/g," ");
				    fieldVal=fieldVal.replace(/\r\n/g," ");
				    strLine=strLine+fieldVal;
				    if (i<cols) strLine=strLine+"\t";
		    	}
		    	if (j!=0) strLine="\r"+strLine;
		    	strArr.push(strLine);
		    	if (Row<endRow) Row++;
			}
	     	strConcat=String.prototype.concat.apply("",strArr);
	     	xlsheet.Cells(beginRow+TitleRow+1,1).Select();
		 	window.clipboardData.setData("Text",strConcat);
		 	xlsheet.Paste();
	     }
	     
	     if (SaveOrPrint=="1")
	     {
		     xlBook.SaveAs(FileName);
	     }
	     else
	     {
		     xlsheet.printout; //��ӡ���
	     }
	    
	    xlBook.Close (savechanges=false);
	    xlApp.Quit();
	    xlApp=null;
	    xlsheet.Quit;
	    xlsheet=null;
	    if (SaveOrPrint=="1")
	    {
		    alertShow("�������!");
	    }
	    } 
	catch(e)
	 {
		alertShow(e.message);
	 }
	}
}

function ParameterReplace(xlsheet,vData)
{
	var Find=xlsheet.cells.find("[Hospital]")
	var Hospital=tkMakeServerCall("web.DHCEQCommon","GetHospitalDesc")
	if (Find!=null) {xlsheet.cells.replace("[Hospital]",Hospital)}
	
	var vInfo=vData.split("^")
	var vCount=vInfo.length
	var vCurInfo=""
	for (var i=1;i<vCount;i++)
	{
		vCurInfo=vInfo[i].split("=")
		Find=xlsheet.cells.find("["+vCurInfo[0]+"]")
		if (Find!=null)
		{
			xlsheet.cells.replace("["+vCurInfo[0]+"]",vCurInfo[1])
		}
	}
}
function ColFormat(val,format)
{
	//"1:YYYY-MM-DD"
	//"11:YYYY��MM��DD��"
	//"12:dd/mm/yyyy"
	//"2:0.00"
	//"3:�����Ƹ���-��ȡ
	//"4:�ı���ʽ?��Ҫ�������豸��ŵȿ�ѧ��������ʾ������?
	if (format=="1")
	{
		return FormatDate(val,"","");
	}
	else if (format=="2")
	{
		val=val*100;
		val=Math.round(val,2);
		val=val/100;
		val=val.toFixed(2);
		return val;
	}
	else if (format=="3")
	{
		val=GetShortName(val,"-");
		return val;
	}
	else
	{
		return val
	}
}
//modified by ZY 20221115 3081237
function isselectItem() {
        for (var i = 0; i < selectItems.length; i++) {
            jQuery('#DHCEQEquipFacilityFind').datagrid('selectRecord', selectItems[i]); //����idѡ���� 
        }
}

//�ж�ѡ�м�¼��ID�Ƿ��Ѵ���checkedItems���������
function findSelectItem(ID) {
        for (var i = 0; i < selectItems.length; i++) {
            if (selectItems[i] == ID) return i;
        }
        return -1;
}
//��ѡ�м�¼��ID�Ǵ洢checkedItems���������
function addselectItem(rowIndex, rowData) {
        //var row = jQuery('#tDHCEQEquipList').datagrid('getSelections');
        var rowid=rowData.TRowID;
        /// modefied by by zc 2017-06-25 ZC0031 begin
        var res = tkMakeServerCall("web.DHCEQBatchDisuseRequest", "CheckEquipDR",'','',rowData.TRowID,'','','Y');
        var ret=res.split("^");
        if (ret[0]!="0")
        {
            $.messager.popover({msg:ret[1],type:'alert'});
            $('#DHCEQEquipFacilityFind').datagrid('unselectRow', rowIndex);
        }
        // modfied by ZY0306 20220711  ̨��ѡ���д�ֵ��������
        else
        {
            var findindex=findSelectItem(rowid)
            if (findindex == -1) {
                    selectItems.push(rowid);
                }
            else
            {
                selectItems.splice(findindex, 1);
            }
        }
}
//�������ѡ�м�¼��ID
function removeAllItem(rows) {
        for (var i = 0; i < rows.length; i++) {
            var k = findSelectItem(rows[i].TRowID);
            if (k != -1) {
                selectItems.splice(i, 1);
            }
        }
}
//�������ѡ�м�¼��ID
function removeSingleItem(rowIndex, rowData) {
        var k = findSelectItem(rowData.TRowID);
        if (k != -1) {
            selectItems.splice(k, 1);
        }
}

// MZY0154	3259097		2023-03-03	����������
function BImport_Click()
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
function BImport_IE()
{
	var FileName=GetFileName();
  	if (FileName=="") {return 0;}
  	var xlApp,xlsheet,xlBook
  	xlApp = new ActiveXObject("Excel.Application");
  	xlBook = xlApp.Workbooks.Add(FileName);
  	var xlsheet =xlBook.Worksheets(1);
  	var MaxRow=xlsheet.UsedRange.Cells.Rows.Count;
  	//alert(ExcelRows)
  	for (var Row=2;Row<=MaxRow;Row++)
	{
		var Col=1;
    	var EquipType=trim(xlsheet.cells(Row,Col++).text);
    	var EquipTypeDR="";
    	var Name=trim(xlsheet.cells(Row,Col++).text);
    	var No=trim(xlsheet.cells(Row,Col++).text);
    	var EquipDR="";
    	var Model=trim(xlsheet.cells(Row,Col++).text);
    	var ModelDR="";
    	var Quantity=trim(xlsheet.cells(Row,Col++).text);
    	var OriginalFee=trim(xlsheet.cells(Row,Col++).text);
    	var UseLoc=trim(xlsheet.cells(Row,Col++).text);
    	var UseLocDR="";
    	var Status=trim(xlsheet.cells(Row,Col++).text);
    	var StatusDR="";
    	var Provider=trim(xlsheet.cells(Row,Col++).text);
    	var ProviderDR="";
    	var ManuFactory=trim(xlsheet.cells(Row,Col++).text);
    	var ManuFactoryDR="";   
    	var LeaveFactoryNo=trim(xlsheet.cells(Row,Col++).text);
    	var Remark=trim(xlsheet.cells(Row,Col++).text);
		if (EquipType=="")
    	{
	    	alert("�豸���鲻��Ϊ��!");
	    	return 0;
    	}
    	if (EquipType!="")
		{
			EquipTypeDR=tkMakeServerCall("web.DHCEQImportDataTool","GetEquipTypeID",EquipType);
			if (EquipTypeDR=="")
			{
				alert("��"+Row+"�� �豸�������Ϣ����ȷ:"+EquipType);
				return 0;
			}
		}
    	if (Name=="")
    	{
	    	alert("�豸����Ϊ��!");
	    	return 0;
    	}
    	if (Status=="")
    	{
	    	alert("״̬����Ϊ��!");
	    	return 0;
    	}
		var ItemInfo=tkMakeServerCall("web.DHCEQCMasterItem","GetMasterInfoByDesc",Name,EquipTypeDR);
		if (ItemInfo=="")
		{
			alert("��"+Row+"�� "+Name+":��δ�����豸��,���ȶ����豸��!");
	   	 	return 0;
		}
		if (No!="")
		{
			EquipDR=tkMakeServerCall("web.DHCEQEquip","GetEquipIDByNo",No);
			if (EquipDR!="")
			{
				alert("��"+Row+"�� ��ŵ���Ϣ�Ѵ���:"+No);
				return 0;
			}
		}
		if (Model!="")
		{
			ModelDR=tkMakeServerCall("web.DHCEQImportDataTool","GetModelID",Model,Name,EquipType);
			if (ModelDR=="")
			{
				alert("��"+Row+"�� "+Model+":��δ�������,���ȶ������!");
				return 0;
			}
		}
		if (parseInt(Quantity)<=0)
  		{
	  		alert("��"+Row+"�� �豸��������,������ȷ��������!")
	  		return 0;
 		}
 		if (parseInt(Quantity)!=Quantity)
		{
			alert("��"+Row+"�� �豸��������,����������С��λ����,��������!");
			return 0;
		}
		if (Status=="����")
		{
			StatusDR=0
		}
		else if (Status=="����")
		{
			StatusDR=1
		}
		else
		{
			StatusDR=""
		}
		if (StatusDR=="")
		{
			alert("��"+Row+"�� ״̬����Ϣ����ȷ:"+Status);
			return 0;
		}
    	if (UseLoc!="")
		{
			UseLocDR=tkMakeServerCall("web.DHCEQImportDataTool","GetUseLocID",UseLoc) 
			if (UseLocDR=="")
			{
				alert("��"+Row+"�� ʹ�ò��ŵ���Ϣ����ȷ:"+UseLoc);
				return 0;
			}
		}
		if (Provider!="")
		{
			ProviderDR=tkMakeServerCall("web.DHCEQImportDataTool","GetProviderID",Provider,'1') 
			if (ProviderDR=="")
			{
				alert("��"+Row+"�� "+Provider+":��δ���幩Ӧ��,���ȶ��幩Ӧ��!");
				return 0;
			}
		}
  		if (ManuFactory!="")
		{
			ManuFactoryDR=tkMakeServerCall("web.DHCEQImportDataTool","GetManuFactoryID",ManuFactory) 
			if (ManuFactoryDR=="")
			{
				alert("��"+Row+"�� "+ManuFactory+":��δ������������,���ȶ�����������!");
				return 0;
			}
		}
		
  		//alert("Saving...")
		//�Զ����ñ������յ�
		var list=ItemInfo.split("^");
		var sort=26;	// MZY0154	3259138		2023-03-03
		if (Quantity=="1")
		{
			var combindata="";
  			combindata=combindata+"^"+Name;
  			combindata=combindata+"^";
  			combindata=combindata+"^"+ModelDR; 
  			combindata=combindata+"^"+list[3]; 
  			combindata=combindata+"^"+list[6];
  			combindata=combindata+"^"+list[1];
  			combindata=combindata+"^"+list[sort+8];
  			combindata=combindata+"^";
  			combindata=combindata+"^";
  			combindata=combindata+"^"+LeaveFactoryNo;
  			combindata=combindata+"^";
  			combindata=combindata+"^";
  			combindata=combindata+"^";
  			combindata=combindata+"^";
			combindata=combindata+"^false";
  			combindata=combindata+"^";
  			combindata=combindata+"^";
  			combindata=combindata+"^";
	  		combindata=combindata+"^"+UseLocDR;
  			combindata=combindata+"^";
  			combindata=combindata+"^";
  			combindata=combindata+"^";
  			combindata=combindata+"^";
  			combindata=combindata+"^";
    		combindata=combindata+"^"+ProviderDR;
  			combindata=combindata+"^"+ManuFactoryDR;
  			combindata=combindata+"^"+OriginalFee;
  			combindata=combindata+"^";
  			combindata=combindata+"^";
  			combindata=combindata+"^";
  			combindata=combindata+"^";
  			combindata=combindata+"^";
  			combindata=combindata+"^";
  			combindata=combindata+"^"+Remark;
  			combindata=combindata+"^";
  			combindata=combindata+"^";
  			combindata=combindata+"^";
  			combindata=combindata+"^"+StatusDR;
  			combindata=combindata+"^";
  			combindata=combindata+"^";
  			combindata=combindata+"^";
  			combindata=combindata+"^";
  			combindata=combindata+"^";
  			combindata=combindata+"^";  //add by zx 2017-11-10 ���ڸ�ʽת��ȥ�� Bug ZX0048 �����:479138
  			combindata=combindata+"^";
  			combindata=combindata+"^";
  			combindata=combindata+"^";
  			combindata=combindata+"^";
  			combindata=combindata+"^";
  			combindata=combindata+"^";
  			combindata=combindata+"^";
  			combindata=combindata+"^";
  			combindata=combindata+"^";
  			combindata=combindata+"^";
  			combindata=combindata+"^";
  			combindata=combindata+"^";
  			combindata=combindata+"^";
  			combindata=combindata+"^"+list[2];
  			combindata=combindata+"^";
  			combindata=combindata+"^";
  			combindata=combindata+"^";
  			combindata=combindata+"^"+UseLocDR;
  			combindata=combindata+"^";
  			combindata=combindata+"^";
  			combindata=combindata+"^";
  			combindata=combindata+"^"+No;
  			combindata=combindata+"^";;
  			combindata=combindata+"^";
  			combindata=combindata+"^"+list[4];
  			combindata=combindata+"^";
  			combindata=combindata+"^";
  			combindata=combindata+"^";
  			combindata=combindata+"^";
  			combindata=combindata+"^";
  			combindata=combindata+"^";
  			combindata=combindata+"^";
			combindata=combindata+"^false";
  			combindata=combindata+"^";
  			combindata=combindata+"^";
  			combindata=combindata+"^";
  			combindata=combindata+"^";
  			combindata=combindata+"^";
  			combindata=combindata+"^";
  			combindata=combindata+"^";
  			combindata=combindata+"^";
  			combindata=combindata+"^";
  			combindata=combindata+"^";
  			combindata=combindata+"^";
  			combindata=combindata+"^";
  			combindata=combindata+"^"+Name;
  			combindata=combindata+"^";
  			combindata=combindata+"^";
  			combindata=combindata+"^";
  			combindata=combindata+"^";
  			combindata=combindata+"^";
  			combindata=combindata+"^";
			combindata=combindata+"^false";
  			combindata=combindata+"^";
  			combindata=combindata+"^";
  			combindata=combindata+"^";
  			combindata=combindata+"^";
  			combindata=combindata+"^";
			combindata=combindata+"^";
  			combindata=combindata+"^";
  			combindata=combindata+"^";
  			combindata=combindata+"^";
  			combindata=combindata+"^";
			var result=tkMakeServerCall("web.DHCEQEquip","SaveData",'','',combindata,curUserID,'','2') 
			if (result<0) alert("��"+i+"�� <"+xlsheet.cells(i,4).text+"> ��Ϣ����ʧ��!!!���ؼ�������Ϣ����������ٴε��������Ϣ.");
		}
		else
		{
			for (var j=0;j<Quantity;j++)
			{
				var combindata="";
  				combindata=combindata+"^"+Name;
  				combindata=combindata+"^";
  				combindata=combindata+"^"+ModelDR; 
  				combindata=combindata+"^"+list[3]; 
  				combindata=combindata+"^"+list[6];
  				combindata=combindata+"^"+list[1];
  				combindata=combindata+"^"+list[sort+8];
  				combindata=combindata+"^";
  				combindata=combindata+"^";
  				combindata=combindata+"^"+LeaveFactoryNo;
  				combindata=combindata+"^";
  				combindata=combindata+"^";
  				combindata=combindata+"^";
  				combindata=combindata+"^";
				combindata=combindata+"^false";
  				combindata=combindata+"^";
  				combindata=combindata+"^";
  				combindata=combindata+"^";
	  			combindata=combindata+"^"+UseLocDR;
  				combindata=combindata+"^";
  				combindata=combindata+"^";
  				combindata=combindata+"^";
  				combindata=combindata+"^";
  				combindata=combindata+"^";
    			combindata=combindata+"^"+ProviderDR;
  				combindata=combindata+"^"+ManuFactoryDR;
  				combindata=combindata+"^"+OriginalFee;
  				combindata=combindata+"^";
  				combindata=combindata+"^";
  				combindata=combindata+"^";
  				combindata=combindata+"^";
  				combindata=combindata+"^";
  				combindata=combindata+"^";
  				combindata=combindata+"^"+Remark;
  				combindata=combindata+"^";
  				combindata=combindata+"^";
  				combindata=combindata+"^";
  				combindata=combindata+"^"+StatusDR;
  				combindata=combindata+"^";
  				combindata=combindata+"^";
  				combindata=combindata+"^";
  				combindata=combindata+"^";
  				combindata=combindata+"^";
  				combindata=combindata+"^";  //add by zx 2017-11-10 ���ڸ�ʽת��ȥ�� Bug ZX0048 �����:479138
  				combindata=combindata+"^";
  				combindata=combindata+"^";
  				combindata=combindata+"^";
  				combindata=combindata+"^";
  				combindata=combindata+"^";
  				combindata=combindata+"^";
  				combindata=combindata+"^";
  				combindata=combindata+"^";
  				combindata=combindata+"^";
  				combindata=combindata+"^";
  				combindata=combindata+"^";
  				combindata=combindata+"^";
  				combindata=combindata+"^";
  				combindata=combindata+"^"+list[2];
  				combindata=combindata+"^";
  				combindata=combindata+"^";
  				combindata=combindata+"^";
  				combindata=combindata+"^"+UseLocDR;
  				combindata=combindata+"^";
  				combindata=combindata+"^";
  				combindata=combindata+"^";
  				combindata=combindata+"^"+No;
  				combindata=combindata+"^";;
  				combindata=combindata+"^";
  				combindata=combindata+"^"+list[4];
  				combindata=combindata+"^";
  				combindata=combindata+"^";
  				combindata=combindata+"^";
  				combindata=combindata+"^";
  				combindata=combindata+"^";
  				combindata=combindata+"^";
  				combindata=combindata+"^";
				combindata=combindata+"^false";
  				combindata=combindata+"^";
  				combindata=combindata+"^";
  				combindata=combindata+"^";
  				combindata=combindata+"^";
  				combindata=combindata+"^";
  				combindata=combindata+"^";
  				combindata=combindata+"^";
  				combindata=combindata+"^";
  				combindata=combindata+"^";
  				combindata=combindata+"^";
  				combindata=combindata+"^";
  				combindata=combindata+"^";
  				combindata=combindata+"^"+Name;
  				combindata=combindata+"^";
  				combindata=combindata+"^";
  				combindata=combindata+"^";
  				combindata=combindata+"^";
  				combindata=combindata+"^";
  				combindata=combindata+"^";
				combindata=combindata+"^false";
  				combindata=combindata+"^";
  				combindata=combindata+"^";
  				combindata=combindata+"^";
  				combindata=combindata+"^";
  				combindata=combindata+"^";
				combindata=combindata+"^";
  				combindata=combindata+"^";
  				combindata=combindata+"^";
  				combindata=combindata+"^";
  				combindata=combindata+"^";
				var result=tkMakeServerCall("web.DHCEQEquip","SaveData",'','',combindata,curUserID,'','2') 
				if (result<0) alert("��"+i+"�� <"+xlsheet.cells(i,4).text+"> ��Ϣ����ʧ��!!!���ؼ�������Ϣ����������ٴε��������Ϣ.");
			}	
		}
	}
	
  	xlsheet.Quit;
  	xlsheet=null;
  	xlBook.Close (savechanges=false);
  	xlApp=null;
  	alert("��������豸��Ϣ�������!��˶������Ϣ.");
	window.location.reload();
}
function BImport_Chrome()
{
	var RowInfo=websys_ReadExcel('');
	if ((RowInfo=="")||(RowInfo.length<=1))		//add by czf 20200611 1342552 begin		//czf 20200811 1456821
	{
		alertShow("û�����ݵ��룡")
		return 0;
	}		//add by czf 20200611 1342552 end
	var Error=""
	for (var Row=2;Row<=RowInfo.length;Row++)
	{
		var Col=0;
    	var EquipType=trim(RowInfo[Row-1][Col++]);
    	var EquipTypeDR="";
    	var Name=trim(RowInfo[Row-1][Col++]);
    	var No=trim(RowInfo[Row-1][Col++]);
    	var EquipDR="";
    	var Model=trim(RowInfo[Row-1][Col++]);
    	var ModelDR="";
    	var Quantity=trim(RowInfo[Row-1][Col++]);
    	var OriginalFee=trim(RowInfo[Row-1][Col++]);
    	var UseLoc=trim(RowInfo[Row-1][Col++]);
    	var UseLocDR="";
    	var Status=trim(RowInfo[Row-1][Col++]);
    	var StatusDR="";
    	var Provider=trim(RowInfo[Row-1][Col++]);
    	var ProviderDR="";
    	var ManuFactory=trim(RowInfo[Row-1][Col++]);
    	var ManuFactoryDR="";   
    	var LeaveFactoryNo=trim(RowInfo[Row-1][Col++]);
    	var Remark=trim(RowInfo[Row-1][Col++]);
		if (EquipType=="")
    	{
	    	alert("�豸���鲻��Ϊ��!");
	    	return 0;
    	}
    	if (EquipType!="")
		{
			EquipTypeDR=tkMakeServerCall("web.DHCEQImportDataTool","GetEquipTypeID",EquipType);
			if (EquipTypeDR=="")
			{
				alert("��"+Row+"�� �豸�������Ϣ����ȷ:"+EquipType);
				return 0;
			}
		}
    	if (Name=="")
    	{
	    	alert("�豸����Ϊ��!");
	    	return 0;
    	}
    	if (Status=="")
    	{
	    	alert("״̬����Ϊ��!");
	    	return 0;
    	}
		var ItemInfo=tkMakeServerCall("web.DHCEQCMasterItem","GetMasterInfoByDesc",Name,EquipTypeDR);
		if (ItemInfo=="")
		{
			alert("��"+Row+"�� "+Name+":��δ�����豸��,���ȶ����豸��!");
	   	 	return 0;
		}
		if (No!="")
		{
			EquipDR=tkMakeServerCall("web.DHCEQEquip","GetEquipIDByNo",No);
			if (EquipDR!="")
			{
				alert("��"+Row+"�� ��ŵ���Ϣ�Ѵ���:"+No);
				return 0;
			}
		}
		if (Model!="")
		{
			ModelDR=tkMakeServerCall("web.DHCEQImportDataTool","GetModelID",Model,Name,EquipType);
			if (ModelDR=="")
			{
				alert("��"+Row+"�� "+Model+":��δ�������,���ȶ������!");
				return 0;
			}
		}
		if (parseInt(Quantity)<=0)
  		{
	  		alert("��"+Row+"�� �豸��������,������ȷ��������!")
	  		return 0;
 		}
 		if (parseInt(Quantity)!=Quantity)
		{
			alert("��"+Row+"�� �豸��������,����������С��λ����,��������!");
			return 0;
		}
		if (Status=="����")
		{
			StatusDR=0
		}
		else if (Status=="����")
		{
			StatusDR=1
		}
		else
		{
			StatusDR=""
		}
		if (StatusDR=="")
		{
			alert("��"+Row+"�� ״̬����Ϣ����ȷ:"+Status);
			return 0;
		}
    	if (UseLoc!="")
		{
			UseLocDR=tkMakeServerCall("web.DHCEQImportDataTool","GetUseLocID",UseLoc) 
			if (UseLocDR=="")
			{
				alert("��"+Row+"�� ʹ�ò��ŵ���Ϣ����ȷ:"+UseLoc);
				return 0;
			}
		}
		if (Provider!="")
		{
			ProviderDR=tkMakeServerCall("web.DHCEQImportDataTool","GetProviderID",Provider,'1') 
			if (ProviderDR=="")
			{
				alert("��"+Row+"�� "+Provider+":��δ���幩Ӧ��,���ȶ��幩Ӧ��!");
				return 0;
			}
		}
  		if (ManuFactory!="")
		{
			ManuFactoryDR=tkMakeServerCall("web.DHCEQImportDataTool","GetManuFactoryID",ManuFactory) 
			if (ManuFactoryDR=="")
			{
				alert("��"+Row+"�� "+ManuFactory+":��δ������������,���ȶ�����������!");
				return 0;
			}
		}
		
  		//alert("Saving...")
		//�Զ����ñ������յ�
		var list=ItemInfo.split("^");
		var sort=26;	// MZY0154	3259138		2023-03-03
		if (Quantity=="1")
		{
			var combindata="";
  			combindata=combindata+"^"+Name;
  			combindata=combindata+"^";
  			combindata=combindata+"^"+ModelDR; 
  			combindata=combindata+"^"+list[3]; 
  			combindata=combindata+"^"+list[6];
  			combindata=combindata+"^"+list[1];
  			combindata=combindata+"^"+list[sort+8];
  			combindata=combindata+"^";
  			combindata=combindata+"^";
  			combindata=combindata+"^"+LeaveFactoryNo;
  			combindata=combindata+"^";
  			combindata=combindata+"^";
  			combindata=combindata+"^";
  			combindata=combindata+"^";
			combindata=combindata+"^false";
  			combindata=combindata+"^";
  			combindata=combindata+"^";
  			combindata=combindata+"^";
	  		combindata=combindata+"^"+UseLocDR;
  			combindata=combindata+"^";
  			combindata=combindata+"^";
  			combindata=combindata+"^";
  			combindata=combindata+"^";
  			combindata=combindata+"^";
    		combindata=combindata+"^"+ProviderDR;
  			combindata=combindata+"^"+ManuFactoryDR;
  			combindata=combindata+"^"+OriginalFee;
  			combindata=combindata+"^";
  			combindata=combindata+"^";
  			combindata=combindata+"^";
  			combindata=combindata+"^";
  			combindata=combindata+"^";
  			combindata=combindata+"^";
  			combindata=combindata+"^"+Remark;
  			combindata=combindata+"^";
  			combindata=combindata+"^";
  			combindata=combindata+"^";
  			combindata=combindata+"^"+StatusDR;
  			combindata=combindata+"^";
  			combindata=combindata+"^";
  			combindata=combindata+"^";
  			combindata=combindata+"^";
  			combindata=combindata+"^";
  			combindata=combindata+"^";  //add by zx 2017-11-10 ���ڸ�ʽת��ȥ�� Bug ZX0048 �����:479138
  			combindata=combindata+"^";
  			combindata=combindata+"^";
  			combindata=combindata+"^";
  			combindata=combindata+"^";
  			combindata=combindata+"^";
  			combindata=combindata+"^";
  			combindata=combindata+"^";
  			combindata=combindata+"^";
  			combindata=combindata+"^";
  			combindata=combindata+"^";
  			combindata=combindata+"^";
  			combindata=combindata+"^";
  			combindata=combindata+"^";
  			combindata=combindata+"^"+list[2];
  			combindata=combindata+"^";
  			combindata=combindata+"^";
  			combindata=combindata+"^";
  			combindata=combindata+"^"+UseLocDR;
  			combindata=combindata+"^";
  			combindata=combindata+"^";
  			combindata=combindata+"^";
  			combindata=combindata+"^"+No;
  			combindata=combindata+"^";;
  			combindata=combindata+"^";
  			combindata=combindata+"^"+list[4];
  			combindata=combindata+"^";
  			combindata=combindata+"^";
  			combindata=combindata+"^";
  			combindata=combindata+"^";
  			combindata=combindata+"^";
  			combindata=combindata+"^";
  			combindata=combindata+"^";
			combindata=combindata+"^false";
  			combindata=combindata+"^";
  			combindata=combindata+"^";
  			combindata=combindata+"^";
  			combindata=combindata+"^";
  			combindata=combindata+"^";
  			combindata=combindata+"^";
  			combindata=combindata+"^";
  			combindata=combindata+"^";
  			combindata=combindata+"^";
  			combindata=combindata+"^";
  			combindata=combindata+"^";
  			combindata=combindata+"^";
  			combindata=combindata+"^"+Name;
  			combindata=combindata+"^";
  			combindata=combindata+"^";
  			combindata=combindata+"^";
  			combindata=combindata+"^";
  			combindata=combindata+"^";
  			combindata=combindata+"^";
			combindata=combindata+"^false";
  			combindata=combindata+"^";
  			combindata=combindata+"^";
  			combindata=combindata+"^";
  			combindata=combindata+"^";
  			combindata=combindata+"^";
			combindata=combindata+"^";
  			combindata=combindata+"^";
  			combindata=combindata+"^";
  			combindata=combindata+"^";
  			combindata=combindata+"^";
			var result=tkMakeServerCall("web.DHCEQEquip","SaveData",'','',combindata,curUserID,'','2') 
			if (result<0) 
			{
				Error="��"+Row+"����Ϣ����ʧ��!!!"
				alertShow(Error);
				Row=RowInfo.length+1
			}
		}
		else
		{
			for (var j=0;j<Quantity;j++)
			{
				var combindata="";
  				combindata=combindata+"^"+Name;
  				combindata=combindata+"^";
  				combindata=combindata+"^"+ModelDR; 
  				combindata=combindata+"^"+list[3]; 
  				combindata=combindata+"^"+list[6];
  				combindata=combindata+"^"+list[1];
  				combindata=combindata+"^"+list[sort+8];
  				combindata=combindata+"^";
  				combindata=combindata+"^";
  				combindata=combindata+"^"+LeaveFactoryNo;
  				combindata=combindata+"^";
  				combindata=combindata+"^";
  				combindata=combindata+"^";
  				combindata=combindata+"^";
				combindata=combindata+"^false";
  				combindata=combindata+"^";
  				combindata=combindata+"^";
  				combindata=combindata+"^";
	  			combindata=combindata+"^"+UseLocDR;
  				combindata=combindata+"^";
  				combindata=combindata+"^";
  				combindata=combindata+"^";
  				combindata=combindata+"^";
  				combindata=combindata+"^";
    			combindata=combindata+"^"+ProviderDR;
  				combindata=combindata+"^"+ManuFactoryDR;
  				combindata=combindata+"^"+OriginalFee;
  				combindata=combindata+"^";
  				combindata=combindata+"^";
  				combindata=combindata+"^";
  				combindata=combindata+"^";
  				combindata=combindata+"^";
  				combindata=combindata+"^";
  				combindata=combindata+"^"+Remark;
  				combindata=combindata+"^";
  				combindata=combindata+"^";
  				combindata=combindata+"^";
  				combindata=combindata+"^"+StatusDR;
  				combindata=combindata+"^";
  				combindata=combindata+"^";
  				combindata=combindata+"^";
  				combindata=combindata+"^";
  				combindata=combindata+"^";
  				combindata=combindata+"^";  //add by zx 2017-11-10 ���ڸ�ʽת��ȥ�� Bug ZX0048 �����:479138
  				combindata=combindata+"^";
  				combindata=combindata+"^";
  				combindata=combindata+"^";
  				combindata=combindata+"^";
  				combindata=combindata+"^";
  				combindata=combindata+"^";
  				combindata=combindata+"^";
  				combindata=combindata+"^";
  				combindata=combindata+"^";
  				combindata=combindata+"^";
  				combindata=combindata+"^";
  				combindata=combindata+"^";
  				combindata=combindata+"^";
  				combindata=combindata+"^"+list[2];
  				combindata=combindata+"^";
  				combindata=combindata+"^";
  				combindata=combindata+"^";
  				combindata=combindata+"^"+UseLocDR;
  				combindata=combindata+"^";
  				combindata=combindata+"^";
  				combindata=combindata+"^";
  				combindata=combindata+"^"+No;
  				combindata=combindata+"^";;
  				combindata=combindata+"^";
  				combindata=combindata+"^"+list[4];
  				combindata=combindata+"^";
  				combindata=combindata+"^";
  				combindata=combindata+"^";
  				combindata=combindata+"^";
  				combindata=combindata+"^";
  				combindata=combindata+"^";
  				combindata=combindata+"^";
				combindata=combindata+"^false";
  				combindata=combindata+"^";
  				combindata=combindata+"^";
  				combindata=combindata+"^";
  				combindata=combindata+"^";
  				combindata=combindata+"^";
  				combindata=combindata+"^";
  				combindata=combindata+"^";
  				combindata=combindata+"^";
  				combindata=combindata+"^";
  				combindata=combindata+"^";
  				combindata=combindata+"^";
  				combindata=combindata+"^";
  				combindata=combindata+"^"+Name;
  				combindata=combindata+"^";
  				combindata=combindata+"^";
  				combindata=combindata+"^";
  				combindata=combindata+"^";
  				combindata=combindata+"^";
  				combindata=combindata+"^";
				combindata=combindata+"^false";
  				combindata=combindata+"^";
  				combindata=combindata+"^";
  				combindata=combindata+"^";
  				combindata=combindata+"^";
  				combindata=combindata+"^";
				combindata=combindata+"^";
  				combindata=combindata+"^";
  				combindata=combindata+"^";
  				combindata=combindata+"^";
  				combindata=combindata+"^";
				var result=tkMakeServerCall("web.DHCEQEquip","SaveData",'','',combindata,curUserID,'','2') 
				if (result<0) 
				{
					Error="��"+Row+"����Ϣ����ʧ��!!!"
					alertShow(Error);
					Row=RowInfo.length+1
				}
			}	
		}
	}
	
  	if (Error=="")
	{
		messageShow('alert','info','��ʾ','��������豸��Ϣ�������!��˶������Ϣ.','',importreload,'');		
	}
}
function importreload()
{
	window.location.reload();
}
//modify by zc0125 2022-11-09 ���ӵ��빦�� end
