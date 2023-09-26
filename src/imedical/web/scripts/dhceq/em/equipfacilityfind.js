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
	initButtonWidth();  //add by lmm 2019-10-23 1060991
	$("#BAdd").on("click", BAdd_Clicked);
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
        Data:GetParams(),
        Ejob:getElementValue("Job"),	//add by yh 2020-01-15
	    ReadOnly:""
    },
    border:false,
    fit:true,
    singleSelect:true,
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
            }},    //modify by lmm 2020-04-03
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
            }}], 
	onDblClickRow:function(rowIndex, rowData)
	{	
		if (rowData.TRowID!=""){
			var str="dhceq.em.equipfacility.csp?RowID="+rowData.TRowID+"&ReadOnly=";
			showWindow(url,"����̨��","","13row","icon-w-paper","modal","","","large")     //modify by lmm 2020-06-01 UI
		}
	},
	onLoadSuccess: function (data) {
		var lable_innerText='������:'+totalSum("DHCEQEquipFacilityFind","TQuantity")+'&nbsp;&nbsp;&nbsp;�ܽ��:'+totalSum("DHCEQEquipFacilityFind","TOriginalFee").toFixed(2)
		$("#sumTotal").html(lable_innerText);
	},
});
	
///��ӡ����
function BPrintBar_Clicked()
{
	var url='websys.default.hisui.csp?WEBSYS.TCOMPONENT=DHCEQPrintBarCode&Job='+getElementValue("Job");  //modified by csj 2020-03-01 ����ţ�1206002
    showWindow(url,"������ӡ����","","7row","icon-w-paper","modal","","","small")  //modify by lmm 2020-06-04 UI
}

///�����¼�
function BAdd_Clicked()
{
	var url='dhceq.em.equipfacility.csp?RowID=';
	showWindow(url,"����̨��","","13row","icon-w-paper","modal","","","large")     //modify by lmm 2020-06-01 UI
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
	PrintDHCEQEquipNew("Equip",1,getElementValue("Job"),vData,"",100);  //modify by lmm 2020-05-26 1333444
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