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
	if(DateFormat=="4"){ 				//���ڸ�ʽ 4:"DMY" DD/MM/YYYY
		StDate="01"+"/"+"01"+"/"+2018;  //���꿪ʼ����
	}else if(DateFormat=="3"){ 			//���ڸ�ʽ 3:"YMD" YYYY-MM-DD
		StDate=2018+"-"+"01"+"-"+"01";  //���꿪ʼ����
	}else if(DateFormat=="1"){ 			//���ڸ�ʽ 1:"MDY" MM/DD/YYYY
		StDate="01"+"/"+"01"+"/"+2018;  //���꿪ʼ����
	}
	$('#dept').combobox({ //  yangyongtao   2017-11-17
		mode:'remote',  //���������������
		onShowPanel:function(){ 
			$('#dept').combobox('reload',url+'?action=GetAllLocNewVersion&hospId='+LgHospID+'')
		}
	});
	$('#FindByLoc').bind("click",Query);  	   				    //��ѯ
    $('#ExportByLoc').bind("click",ExportByMonths); 	 			//����
	$("#stdate").datebox("setValue", StDate);  
	$("#enddate").datebox("setValue", EndDate); 
	$("#reqList").height($(window).height()-245)//hxy 08-28 st
	InitPatList();
});

//��ʼ�������б�
function InitPatList()
{
	//����columns
	var columns=[[
	    {field:'locName',title:'�ϱ�����',width:120},
	    {field:'oneMonNum',title:'һ��',width:60},
	    {field:'TwoMonNum',title:'����',width:60},
	    {field:'ThreeMonNum',title:'����',width:60},
	    {field:'SpringMonNum',title:'һ����',width:60},
	    {field:'FourMonNum',title:'����',width:60},
	    {field:'FiveMonNum',title:'����',width:60},
	    {field:'SixMonNum',title:'����',width:60},
	    {field:'SummerMonNum',title:'������',width:60},
	    {field:'SevenMonNum',title:'����',width:60},
	    {field:'EightMonNum',title:'����',width:60},
	    {field:'NineMonNum',title:'����',width:60},
	    {field:'AutumnMonNum',title:'������',width:60},
	    {field:'TenMonNum',title:'ʮ��',width:60},
	    {field:'ElevenMonNum',title:'ʮһ��',width:60},
	    {field:'TwelveMonNum',title:'ʮ����',width:60},
	    {field:'WinterMonNum',title:'�ļ���',width:60},
	    {field:'TotleNum',title:'�ϼ�',width:60}
	

	]];
	var StDate=$('#stdate').datebox('getValue');   //��ʼ����
	var EndDate=$('#enddate').datebox('getValue'); //��ֹ����
	var LocID=$('#dept').combobox('getValue');     //����ID
	if (LocID==undefined){LocID="";}
	var StrParam=StDate +"^"+ EndDate +"^"+ LocID+"^"+LgHospID+"^"+LgGroupID+"^"+LgCtLocID+"^"+LgUserID ; //hxy 2020-02-26 4567
  
	//����datagrid
	$('#maindg').datagrid({
		toolbar: '#toolbar',
		title:'',
		method:'get',
		url:'dhcapp.broker.csp?ClassName=web.DHCADVCOMMONPART&MethodName=StatAllRepByLocMon'+'&StrParam='+StrParam,
		fit:true,
		rownumbers:true,
		columns:columns,
		pageSize:40,  			// ÿҳ��ʾ�ļ�¼����
		pageList:[40,80],   	// ��������ÿҳ��¼�������б�
	    singleSelect:true,
		loadMsg: '���ڼ�����Ϣ...',
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
	var StDate=$('#stdate').datebox('getValue');   //��ʼ����
	var EndDate=$('#enddate').datebox('getValue'); //��ֹ����
	var LocID=$('#dept').combobox('getValue');     //����ID
	if (LocID==undefined){LocID="";}
	var StrParam=StDate+"^"+EndDate+"^"+LocID
	$('#maindg').datagrid({
		url:'dhcapp.broker.csp?ClassName=web.DHCADVCOMMONPART&MethodName=StatAllRepByLocMon',	
		queryParams:{
			StrParam:StrParam}
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
 	var StDate=$('#stdate').datebox('getValue');   //��ʼ����
	var EndDate=$('#enddate').datebox('getValue'); //��ֹ����
	var LocID=$('#dept').combobox('getValue');     //����ID
	if (LocID==undefined){LocID="";}
	var StrParam=StDate +"^"+ EndDate +"^"+ LocID+"^"+LgHospID+"^"+LgGroupID+"^"+LgCtLocID+"^"+LgUserID ; //hxy 2020-02-26 4567	
	runClassMethod("web.DHCADVCOMMONPART","StatAllRepByLocMon",{"StrParam":StrParam},
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
	//alert(TemplatePath)
	xlsBook = xlsApp.Workbooks.Add();
	xlsSheet = xlsBook.ActiveSheet;
	xlsSheet.PageSetup.LeftMargin=0;  
	xlsSheet.PageSetup.RightMargin=0;
	xlsSheet.Application.Visible = true;
	
	xlsApp.Range(xlsSheet.Cells(1,1),xlsSheet.Cells(1,18)).MergeCells = true;
	xlsSheet.cells(1,1).Font.Bold = true;
	xlsSheet.cells(1,1).Font.Size =18;
	xlsSheet.cells(1,1).HorizontalAlignment = -4108;
	
	runClassMethod("web.DHCEMRegister","gethHospitalName",{'locId':LgCtLocID},function(jsonString){
		xlsSheet.cells(1,1) = jsonString;     //QQA  2016-10-16   
	},'text',false)
	xlsSheet.cells(2,1)="�ϱ�����";  
	xlsSheet.cells(2,2)="һ��";
   	xlsSheet.cells(2,3)="����";
    xlsSheet.cells(2,4)="����";
    xlsSheet.cells(2,5)="һ����";
    xlsSheet.cells(2,6)="����";
    xlsSheet.cells(2,7)="����";
    xlsSheet.cells(2,8)="����";
    xlsSheet.cells(2,9)="������";
    xlsSheet.cells(2,10)="����";
    xlsSheet.cells(2,11)="����";
    xlsSheet.cells(2,12)="����";
    xlsSheet.cells(2,13)="������";
    xlsSheet.cells(2,14)="ʮ��";
    xlsSheet.cells(2,15)="ʮһ��";
    xlsSheet.cells(2,16)="ʮ����";
    xlsSheet.cells(2,17)="�ļ���";
    xlsSheet.cells(2,18)="�ϼ�";
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
	succflag=xlsBook.SaveAs("���ϱ����Һ��·ݲ�ѯ.xls");
	xlApp.Visible=true;
     
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

function $g(){	
	if (arguments[0]== null || arguments[0]== undefined) return "" 
	return arguments[0];
}

