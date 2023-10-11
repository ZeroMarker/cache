/**
  *creator��guoguoming
  *date:2019-06-17
  *
 **/
var StDate="";  			
var EndDate=formatDate(0);  //ϵͳ�ĵ�ǰ����
var StrParam="";
var url = "dhcadv.repaction.csp";
$(function(){ 
	InitPageComponent(); 	  /// ��ʼ������ؼ�����
	InitPageButton();         /// ���水ť����
	InitPageDataGrid();		  /// ��ʼ��ҳ��datagrid
});
// ��ʼ������ؼ�����
function InitPageComponent()
{
	var myDate = new Date();
    var yearArr = [];//�����������-��10��
    for(year= parseInt(myDate.getFullYear())-10;year<=parseInt(myDate.getFullYear());year++)
	{
		yearArr.push({"value":year,"text":year});
	}
	//����������
	$("#year").combobox({
		data:yearArr,
        valueField:'value',
        textField:'text'
    });
    $("#year").combobox("setValue", myDate.getFullYear()); 
	$('#dept').combobox({ 
		mode:'remote',  //���������������
		onShowPanel:function(){ 
			$('#dept').combobox('reload',url+'?action=GetAllLocNewVersion&hospId='+LgHospID+'')
		}
	});
	$("#reqList").height($(window).height()-245);
}
// ��ʼ�����水ť����
function InitPageButton()
{
	$('#FindByLoc').bind("click",Query);  //��ѯ
    $('#ExportByLoc').bind("click",ExportByMonths); //����
}

//��ʼ�������б�
function InitPageDataGrid()
{
	//����columns
	var columns=[[
	    {field:'locName',title:$g('�ϱ�����'),width:120},
	    {field:'oneMonNum',title:$g('һ��'),width:60},
	    {field:'TwoMonNum',title:$g('����'),width:60},
	    {field:'ThreeMonNum',title:$g('����'),width:60},
	    {field:'SpringMonNum',title:$g('һ����'),width:60},
	    {field:'FourMonNum',title:$g('����'),width:60},
	    {field:'FiveMonNum',title:$g('����'),width:60},
	    {field:'SixMonNum',title:$g('����'),width:60},
	    {field:'SummerMonNum',title:$g('������'),width:60},
	    {field:'SevenMonNum',title:$g('����'),width:60},
	    {field:'EightMonNum',title:$g('����'),width:60},
	    {field:'NineMonNum',title:$g('����'),width:60},
	    {field:'AutumnMonNum',title:$g('������'),width:60},
	    {field:'TenMonNum',title:$g('ʮ��'),width:60},
	    {field:'ElevenMonNum',title:$g('ʮһ��'),width:60},
	    {field:'TwelveMonNum',title:$g('ʮ����'),width:60},
	    {field:'WinterMonNum',title:$g('�ļ���'),width:60},
	    {field:'TotleNum',title:$g('�ϼ�'),width:60}
	

	]];
  
	//����datagrid
	$('#maindg').datagrid({
		toolbar: '#toolbar',
		title:'',
		method:'get',
		url:'dhcapp.broker.csp?ClassName=web.DHCADVCOMMONPART&MethodName=StatAllRepByLocMon'+'&StrParam='+StrParam+'&LgParam='+LgParam,
		fit:true,
		rownumbers:true,
		columns:columns,
		pageSize:40,  			// ÿҳ��ʾ�ļ�¼����
		pageList:[40,80],   	// ��������ÿҳ��¼�������б�
	    singleSelect:true,
		loadMsg: $g('���ڼ�����Ϣ...'),
		pagination:true,
		nowrap:false,
		//height:300,
		rowStyler:function(index,row){
	        if ((row.StaFistAuditUser==LgUserName)||(row.BackAuditUser==LgUserName)){  
	            return 'background-color:red;';  
	        }  
    	}
	});
	if(StrParam==""){
		Query();
	}
	//initScroll("#maindg");//��ʼ����ʾ���������
}

function Query()
{
	$('#maindg').datagrid('loadData', {total:0,rows:[]}); 
	var Year= $("#year").combobox("getValue") ; //���
	var LocID=$('#dept').combobox('getValue');     //����ID
	if (LocID==undefined){LocID="";}
	var StrParam=Year+"^"+ LocID ; 
	$('#maindg').datagrid({
		url:'dhcapp.broker.csp?ClassName=web.DHCADVCOMMONPART&MethodName=StatAllRepByLocMon',	
		queryParams:{
			StrParam:StrParam,
			LgParam:LgParam}
	});
}

///����ҳ
function Gologin(){
	location.href='dhcadv.homepage.csp';
}
// ����Excel
function ExportByMonths()
{	
	var strjLen=0; 
 	var strjData="";
 	var Year= $("#year").combobox("getValue") ; //���
	var LocID=$('#dept').combobox('getValue');     //����ID
	if (LocID==undefined){LocID="";}
	var StrParam=Year+"^"+ LocID+"^"+LgHospID+"^"+LgGroupID+"^"+LgCtLocID+"^"+LgUserID ; //hxy 2020-02-26 4567	
	runClassMethod("web.DHCADVCOMMONPART","StatAllRepByLocMon",{"StrParam":StrParam,"LgParam":LgParam},
	function(data){ 
		strjData=data.rows;
		strjLen=data.total;
	},'json',false)
	
	var TemplatePath="";
	var xlsApp,xlsSheet,xlsBook;
	runClassMethod("web.UDHCJFCOMMON","getpath",{'itmjs':'','itmjsex':''},function(jsonString){
		TemplatePath = jsonString;
	},'',false)
	
	xlsApp = new ActiveXObject("Excel.Application");
	xlsBook = xlsApp.Workbooks.Add();
	xlsSheet = xlsBook.ActiveSheet;
	xlsSheet.PageSetup.LeftMargin=0;  
	xlsSheet.PageSetup.RightMargin=0;
	xlsSheet.Application.Visible = true;
	
	xlsApp.Range(xlsSheet.Cells(1,1),xlsSheet.Cells(1,18)).MergeCells = true;
	xlsSheet.cells(1,1).Font.Bold = true;
	xlsSheet.cells(1,1).Font.Size =18;
	xlsSheet.cells(1,1).HorizontalAlignment = -4108;
	
	xlsSheet.cells(1,1) = LgHospDesc;     
	xlsSheet.cells(2,1)=$g("�ϱ�����");  
	xlsSheet.cells(2,2)=$g("һ��");
   	xlsSheet.cells(2,3)=$g("����");
    xlsSheet.cells(2,4)=$g("����");
    xlsSheet.cells(2,5)=$g("һ����");
    xlsSheet.cells(2,6)=$g("����");
    xlsSheet.cells(2,7)=$g("����");
    xlsSheet.cells(2,8)=$g("����");
    xlsSheet.cells(2,9)=$g("������");
    xlsSheet.cells(2,10)=$g("����");
    xlsSheet.cells(2,11)=$g("����");
    xlsSheet.cells(2,12)=$g("����");
    xlsSheet.cells(2,13)=$g("������");
    xlsSheet.cells(2,14)=$g("ʮ��");
    xlsSheet.cells(2,15)=$g("ʮһ��");
    xlsSheet.cells(2,16)=$g("ʮ����");
    xlsSheet.cells(2,17)=$g("�ļ���");
    xlsSheet.cells(2,18)=$g("�ϼ�");
    for (i=1;i<=strjLen;i++)
    { 
    
	    xlsSheet.cells(i+2,1)=strjData[i-1].locName;
		xlsSheet.cells(i+2,2)="'"+strjData[i-1].oneMonNum;
	    xlsSheet.cells(i+2,3)="'"+strjData[i-1].TwoMonNum;
	    xlsSheet.cells(i+2,4)="'"+strjData[i-1].ThreeMonNum;
	    xlsSheet.cells(i+2,5)="'"+strjData[i-1].SpringMonNum;
	    xlsSheet.cells(i+2,6)="'"+strjData[i-1].FourMonNum;
	    xlsSheet.cells(i+2,7)="'"+strjData[i-1].FiveMonNum;
	    xlsSheet.cells(i+2,8)="'"+strjData[i-1].SixMonNum; 
	    xlsSheet.cells(i+2,9)="'"+strjData[i-1].SummerMonNum; 
	    xlsSheet.cells(i+2,10)="'"+strjData[i-1].SevenMonNum; 
	    xlsSheet.cells(i+2,11)="'"+strjData[i-1].EightMonNum;
	    xlsSheet.cells(i+2,12)="'"+strjData[i-1].NineMonNum;
	    xlsSheet.cells(i+2,13)="'"+strjData[i-1].AutumnMonNum; 
	    xlsSheet.cells(i+2,14)="'"+strjData[i-1].TenMonNum
	    xlsSheet.cells(i+2,15)="'"+strjData[i-1].ElevenMonNum
	    xlsSheet.cells(i+2,16)="'"+strjData[i-1].TwelveMonNum;
	    xlsSheet.cells(i+2,17)="'"+strjData[i-1].WinterMonNum;
	    xlsSheet.cells(i+2,18)="'"+strjData[i-1].TotleNum;	   
	    
 	 }
	xlsSheet.Columns.AutoFit; 
	succflag=xlsBook.SaveAs(Year+"�갴�ϱ����Һ��·ݲ�ѯ.xls");
	xlsApp.Visible=true;
     
	xlsBook=null; 
	xlsSheet=null;
	return succflag; 
}
function gridlist(objSheet,row1,row2,c1,c2)
{
	objSheet.Range(objSheet.Cells(row1, c1), objSheet.Cells(row2,c2)).Borders(1).LineStyle=1;
	objSheet.Range(objSheet.Cells(row1, c1), objSheet.Cells(row2,c2)).Borders(1).Weight=2
	objSheet.Range(objSheet.Cells(row1, c1), objSheet.Cells(row2,c2)).Borders(2).LineStyle=1;
	objSheet.Range(objSheet.Cells(row1, c1), objSheet.Cells(row2,c2)).Borders(2).Weight=2
	objSheet.Range(objSheet.Cells(row1, c1), objSheet.Cells(row2,c2)).Borders(3).LineStyle=1;
	objSheet.Range(objSheet.Cells(row1, c1), objSheet.Cells(row2,c2)).Borders(3).Weight=2
	objSheet.Range(objSheet.Cells(row1, c1), objSheet.Cells(row2,c2)).Borders(4).LineStyle=1; 
	objSheet.Range(objSheet.Cells(row1, c1), objSheet.Cells(row2,c2)).Borders(4).Weight=2
}

