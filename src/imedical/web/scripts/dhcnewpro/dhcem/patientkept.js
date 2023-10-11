///Creator:qqa
///CreatDate:2017-01-01
///���۲���
$(function (){   

	initParams();  
	
	initCombobox();
	
	initDateBox();
	
	initTable();
    
	initMethod();
	
	flashTable(1);   //��ʼ��Ĭ�ϲ�ѯ  
})

function initCombobox(){
	$HUI.combobox("#obsLoc",{
		url:LINK_CSP+"?ClassName=web.DHCEMKeptPatient&MethodName=GetObsLoc&CurLoc="+LocId,
		valueField:'value',
		textField:'text',
		onSelect:function(option){
	       
	    },
	    onLoadSuccess:function(data){
		   
			$HUI.combobox("#obsLoc").setValue(data[0].value);   
		}
	})
}

///ȫ�ֲ���
function initParams(){
	excelData=[];  //��������
	DateFormat = "";   //���ڸ�ʽ
	runClassMethod("web.DHCEMCommonUtil","DateFormat",{},  //hxy 2017-03-07 ���ڸ�ʽ������
	function(data){
		DateFormat = data;
	});	
}	

function initDateBox(){
	$HUI.datebox("#startDate").setValue(formatDate(0));
	$HUI.datebox("#endDate").setValue(formatDate(0));
}
	
function initTable(){

    var columns= [[
		{field: 'Num',title: '���',width:50},
		{field: 'Date',title: '����',width:100}, 
		{field: 'Time',title: 'ʱ��',width:80},
		{field: 'Department',title: '�ű�',width:100},
		{field: 'Sex',title: '�Ա�',width:50},
		{field: 'Age',title: '����',width:50},
		{field: 'BedNum',title: '����',width:50},
		{field: 'Name',title: '����',width:100},
		{field: 'MRDiagnos',title: '���',width:100},
		{field: 'CurregNo',title: '�ǼǺ�',width:100},
		{field: 'IPBKRowID',title: 'ת��Ժ',width:60, formatter:function(value,row,index){
				var ret="";
				if(row.IPBKRowID){
					row.InHospWardDesc?ret="��":"";
				}
				return ret;
			}
		},
		{field: 'InHospWardDesc',title: 'ת�벡��',width:100},
		{field: 'ObsDoc',title: '����û�',width:100},
		{field: 'GoDate',title: '��Ժ����',width:100},
		{field: 'GoTime',title: '��Ժʱ��',width:80},
		{field: 'DisDoc',title: '��Ժ�û�',width:100},
		{field: 'LGTime',title: '����ʱ��',width:100},
		{field: 'OrdAction',title: '��ϵ�绰',width:100},
		{field: 'PatLocDesc',title: '����',width:100},
		{field: 'Where',title: '����ȥ��',width:80},
		{field: 'Notes',title: '��ע',width:100},
		{field: 'Apache',title: 'Apache����',width:100}
		]];
	
	$HUI.datagrid('#keptPatTable',{
		url:'dhcapp.broker.csp?ClassName=web.DHCEMKeptPatient&MethodName=ListObservationPatient',
		fit:true,
		rownumbers:true,
		columns:columns,
		pageSize:60,  
		pageList:[30,60,90], 
		loadMsg: $g('���ڼ�����Ϣ...'),
		rownumbers : false,
		pagination:true,
		singleSelect:true,
		selectOnCheck: false,
		checkOnSelect: false,
		title:$g('���۵Ǽǲ�ѯ'), //hxy 2018-10-19 st
		toolbar:'#toolbar',
		iconCls:'icon-paper',
		headerCls:'panel-header-gray', //ed
		queryParams:{
			startDate:$HUI.datebox("#startDate").getValue(),
	        endDate:$HUI.datebox("#endDate").getValue(),
	        Loc:$HUI.combobox('#obsLoc').getValue()
		},
		onDblClickRow:function(index,row){
		
		},
		onLoadSuccess:function(data){
			excelData = data.rows;
		}
    })
	
}

///�󶨷���
function initMethod(){
	$('#searchBtn').on('click',flashTable);

	$('#exportBtn').on('click',expExcelAjax);
	
	$('#patName').bind('keypress',function(event){
        if(event.keyCode == "13") {
            flashTable()
        }
    });	
	
}

///����	
function expExcelAjax(){

 	if(excelData.length){
		expExcelNew(excelData);	
	}else{
		$.messager.alert("��ʾ","û�����ݵ�����");	
	}
	
}
	
function expExcel(itbl)
{		
		runClassMethod("web.UDHCJFCOMMON","getpath",{'itmjs':'','itmjsex':''},function(jsonString){
			TemplatePath = jsonString;
		},'',false)
	
		//TemplatePath=TemplatePath+"DHCEM_PatKeptObs.xlsx"; //cy

 	 	xlsExcel = new ActiveXObject("Excel.Application");
 	 	xlsBook = xlsExcel.Workbooks.Add() 
    	xlsSheet = xlsBook.ActiveSheet; 
    	xlsExcel.Visible = true;  
    	
    	xlsExcel.Range(xlsSheet.Cells(1,1),xlsSheet.Cells(1,20)).MergeCells = true;
    	xlsExcel.Range(xlsSheet.Cells(2,1),xlsSheet.Cells(2,20)).MergeCells = true;
    	xlsSheet.cells(1,1).Font.Bold = true;
    	xlsSheet.cells(2,1).Font.Bold = true;
    	xlsSheet.cells(1,1).Font.Size =24;
    	xlsSheet.cells(1,1).HorizontalAlignment = -4108;
    	xlsSheet.cells(2,1).HorizontalAlignment = -4108;
    	for(i=1;i<21;i++){
	    	if(i==1) xlsSheet.cells(1,i).ColumnWidth=5;
	    	if(i!=1) xlsSheet.cells(1,i).ColumnWidth=10;	
	    }
    	runClassMethod("web.DHCEMRegister","gethHospitalName",{'locId':LocId},function(HospName){
			xlsSheet.cells(1,1) = "  "+HospName;     //QQA  2016-10-16   
		},'text',false)
		var exportLimitPress=$HUI.combobox('#obsLoc').getText()+":"+$HUI.datebox("#startDate").getValue()+"��"+$HUI.datebox("#endDate").getValue();
  	  	xlsSheet.cells(2,1)="����Ǽ�"+"("+exportLimitPress+")";
    	xlsSheet.cells(3,1)="���";
		xlsSheet.cells(3,2)="����";
	   	xlsSheet.cells(3,3)="ʱ��";
	    xlsSheet.cells(3,4)="�ǼǺ�";
	    xlsSheet.cells(3,5)="����";
	    xlsSheet.cells(3,6)="�Ա�";
	    xlsSheet.cells(3,7)="����";
	    xlsSheet.cells(3,8)="����";
		xlsSheet.cells(3,9)="����";
	    xlsSheet.cells(3,10)="���";
	    xlsSheet.cells(3,11)="��Ժ����";
	    xlsSheet.cells(3,12)="��Ժʱ��";
	    xlsSheet.cells(3,13)="����ʱ��";
		xlsSheet.cells(3,14)="��ϵ�绰";
		xlsSheet.cells(3,15)="����";
		xlsSheet.cells(3,16)="�ű�";
		xlsSheet.cells(3,17)="����ȥ��";
		xlsSheet.cells(3,18)="����û�";
		xlsSheet.cells(3,19)="��Ժ�û�";
		xlsSheet.cells(3,20)="Apache����";
   
    if (itbl.length==0) {alert("û��ѡ�����ݣ�"); return}	
    for (var i=0; i<itbl.length; i++) {
	    xlsSheet.cells(i+4,1)=i+1;
		xlsSheet.cells(i+4,2)="'"+itbl[i].Date;
	    xlsSheet.cells(i+4,3)=itbl[i].Time;
	    xlsSheet.cells(i+4,4)="'"+itbl[i].CurregNo;
	    xlsSheet.cells(i+4,5)=itbl[i].Name;
	    xlsSheet.cells(i+4,6)=itbl[i].Sex;
	    xlsSheet.cells(i+4,7)=itbl[i].Age;
	    xlsSheet.cells(i+4,8)=itbl[i].PatLocDesc;
	    xlsSheet.cells(i+4,9)=itbl[i].BedNum;                   //����
	    xlsSheet.cells(i+4,10)=itbl[i].MRDiagnos; 
	    xlsSheet.cells(i+4,11)="'"+itbl[i].GoDate;
	    xlsSheet.cells(i+4,12)=itbl[i].GoTime;   
	    xlsSheet.cells(i+4,13)=itbl[i].LGTime;  
	    xlsSheet.cells(i+4,14)="'"+itbl[i].OrdAction;  
	    xlsSheet.cells(i+4,15)=itbl[i].PatLocDesc;  
	    xlsSheet.cells(i+4,16)=itbl[i].Department;  	     
	    xlsSheet.cells(i+4,17)=itbl[i].Where; 
	    xlsSheet.cells(i+4,18)=itbl[i].ObsDoc; 
	    xlsSheet.cells(i+4,19)=itbl[i].DisDoc; 
	    xlsSheet.cells(i+4,20)=itbl[i].Apache;  
 	 }
	gridlist(xlsSheet,3,itbl.length+3,1,20)
	xlsBook.SaveAs("D:\\���۲���ͳ��.xlsx");
	$.messager.alert("��ʾ","�ļ��ɹ�����,D:\\���۲���ͳ��.xls.ע�����D���к��и��ļ������Ḳ�ǣ�");
	xlsExcel=null;
	xlsBook.Close(savechanges=false);
	xlsSheet=null;
}



function expExcelNew(itbl)
{		
	runClassMethod("web.UDHCJFCOMMON","getpath",{'itmjs':'','itmjsex':''},function(jsonString){
		TemplatePath = jsonString;
	},'',false)

	var Str = "(function test(x){"+
	"xlsExcel = new ActiveXObject('Excel.Application');"+
	"xlsBook = xlsExcel.Workbooks.Add();"+
	"xlsSheet = xlsBook.ActiveSheet;"+
	"xlsExcel.Visible = true;"+
	"xlsExcel.Range(xlsSheet.Cells(1,1),xlsSheet.Cells(1,19)).MergeCells = true;"+
	"xlsExcel.Range(xlsSheet.Cells(2,1),xlsSheet.Cells(2,19)).MergeCells = true;"+
	"xlsSheet.cells(2).NumberFormatLocal='@';"+
	"xlsSheet.cells(4).NumberFormatLocal='@';"+
	"xlsSheet.cells(11).NumberFormatLocal='@';"+
	"xlsSheet.cells(14).NumberFormatLocal='@';"+
	"xlsSheet.cells(1,1).Font.Bold = true;"+
	"xlsSheet.cells(2,1).Font.Bold = true;"+
	"xlsSheet.cells(1,1).Font.Size =24;"+
	"xlsSheet.cells(1,1).HorizontalAlignment = -4108;"+
	"xlsSheet.cells(2,1).HorizontalAlignment = -4108;";
	for(i=1;i<21;i++){
		if(i==1) Str=Str+"xlsSheet.cells(1,"+i+").ColumnWidth=5;";
		if(i!=1) Str=Str+"xlsSheet.cells(1,"+i+").ColumnWidth=10;";	
	}
	runClassMethod("web.DHCEMRegister","gethHospitalName",{'locId':LocId},function(HospName){
		Str=Str+"xlsSheet.cells(1,1) = '"+HospName+"';";     
	},'text',false)
	var exportLimitPress=$HUI.combobox('#obsLoc').getText()+":"+$HUI.datebox("#startDate").getValue()+"��"+$HUI.datebox("#endDate").getValue();

	Str=Str+"xlsSheet.cells(2,1)='����Ǽ�("+exportLimitPress+")';"+
	"xlsSheet.cells(3,1)='���';"+
	"xlsSheet.cells(3,2)='����';"+
	"xlsSheet.cells(3,3)='ʱ��';"+
	"xlsSheet.cells(3,4)='�ǼǺ�';"+
	"xlsSheet.cells(3,5)='����';"+
	"xlsSheet.cells(3,6)='�Ա�';"+
	"xlsSheet.cells(3,7)='����';"+
	"xlsSheet.cells(3,8)='����';"+
	"xlsSheet.cells(3,9)='����';"+
	"xlsSheet.cells(3,10)='���';"+
	"xlsSheet.cells(3,11)='��Ժ����';"+
	"xlsSheet.cells(3,12)='��Ժʱ��';"+
	"xlsSheet.cells(3,13)='����ʱ��';"+
	"xlsSheet.cells(3,14)='��ϵ�绰';"+
	//"xlsSheet.cells(3,15)='����';"+
	"xlsSheet.cells(3,15)='�ű�';"+
	"xlsSheet.cells(3,16)='����ȥ��';"+
	"xlsSheet.cells(3,17)='����û�';"+
	"xlsSheet.cells(3,18)='��Ժ�û�';"+
	"xlsSheet.cells(3,19)='Apache����';";
   
    if (itbl.length==0) {
	    $.messager.alert("��ʾ","û��ѡ�����ݣ�"); 
	    return
	}

    for (var i=0; i<itbl.length; i++) {
	    Str=Str+
		"xlsSheet.cells("+(i+4)+",1)='"+(i+1)+"';"+
		"xlsSheet.cells("+(i+4)+",2)='"+itbl[i].Date+"';"+
	    "xlsSheet.cells("+(i+4)+",3)='"+itbl[i].Time+"';"+
	    "xlsSheet.cells("+(i+4)+",4)='"+itbl[i].CurregNo+"';"+
	    "xlsSheet.cells("+(i+4)+",5)='"+itbl[i].Name+"';"+
	    "xlsSheet.cells("+(i+4)+",6)='"+itbl[i].Sex+"';"+
	    "xlsSheet.cells("+(i+4)+",7)='"+itbl[i].Age+"';"+
	    "xlsSheet.cells("+(i+4)+",8)='"+itbl[i].PatLocDesc+"';"+
	    "xlsSheet.cells("+(i+4)+",9)='"+itbl[i].BedNum+"';"+                   //���� 
	    "xlsSheet.cells("+(i+4)+",10).WrapText=true;"+ 
	    "xlsSheet.cells("+(i+4)+",10)='"+formatHtmlToValue(itbl[i].MRDiagnos)+"';"+ 
	    "xlsSheet.cells("+(i+4)+",11)='"+itbl[i].GoDate+"';"+
	    "xlsSheet.cells("+(i+4)+",12)='"+itbl[i].GoTime+"';"+   
	    "xlsSheet.cells("+(i+4)+",13)='"+itbl[i].LGTime+"';"+  
	    "xlsSheet.cells("+(i+4)+",14)='"+itbl[i].OrdAction+"';"+ 
	    //"xlsSheet.cells("+(i+4)+",15)='"+itbl[i].PatLocDesc+"';"+  
	    "xlsSheet.cells("+(i+4)+",15)='"+itbl[i].Department+"';"+  	     
	    "xlsSheet.cells("+(i+4)+",16)='"+itbl[i].Where+"';"+ 
	    "xlsSheet.cells("+(i+4)+",17)='"+itbl[i].ObsDoc+"';"+ 
	    "xlsSheet.cells("+(i+4)+",18)='"+itbl[i].DisDoc+"';"+ 
	    "xlsSheet.cells("+(i+4)+",19)='"+itbl[i].Apache+"';";
 	}
	
	var row1=3,row2=itbl.length+3,c1=1,c2=19;
	Str=Str+"xlsSheet.Range(xlsSheet.Cells("+row1+","+c1+"),xlsSheet.Cells("+row2+","+c2+")).Borders(1).LineStyle=1;"+
	"xlsSheet.Range(xlsSheet.Cells("+row1+","+c1+"),xlsSheet.Cells("+row2+","+c2+")).Borders(1).Weight=2;"+
	"xlsSheet.Range(xlsSheet.Cells("+row1+","+c1+"),xlsSheet.Cells("+row2+","+c2+")).Borders(2).LineStyle=1;"+
	"xlsSheet.Range(xlsSheet.Cells("+row1+","+c1+"),xlsSheet.Cells("+row2+","+c2+")).Borders(2).Weight=2;"+
	"xlsSheet.Range(xlsSheet.Cells("+row1+","+c1+"),xlsSheet.Cells("+row2+","+c2+")).Borders(3).LineStyle=1;"+
	"xlsSheet.Range(xlsSheet.Cells("+row1+","+c1+"),xlsSheet.Cells("+row2+","+c2+")).Borders(3).Weight=2;"+
	"xlsSheet.Range(xlsSheet.Cells("+row1+","+c1+"),xlsSheet.Cells("+row2+","+c2+")).Borders(4).LineStyle=1;"+ 
	"xlsSheet.Range(xlsSheet.Cells("+row1+","+c1+"),xlsSheet.Cells("+row2+","+c2+")).Borders(4).Weight=2;";
	
	Str=Str+"xlsSheet.Columns.AutoFit;"; 
	Str=Str+"xlsBook.SaveAs('���۲���ͳ��.xlsx');"+
	"xlsExcel.Visible=true;"+
	"xlsExcel=null;"+
	"xlsBook=null;"+
	"xlsSheet=null;"+
	"return 1;}());";
	
	
	//����Ϊƴ��Excel��ӡ����Ϊ�ַ���
	CmdShell.notReturn = 1;   //�����޽�����ã�����������
	var rtn = CmdShell.CurrentUserEvalJs(Str);   //ͨ���м�����д�ӡ���� 
	return;
	//$.messager.alert("��ʾ","�ļ��ɹ�����,D:\\���۲���ͳ��.xls.ע�����D���к��и��ļ������Ḳ�ǣ�");
	
}


//ˢ�±��
function flashTable(){
	
	var initFlag=arguments[0];
	var obsLocID="";
	if(initFlag==1) obsLocID=GetObsLocID();
	if(initFlag!=1) obsLocID=$HUI.combobox('#obsLoc').getValue();
	var patName=$("#patName").val();
	var transInHosp=$HUI.checkbox("#transInHospCheckBox").getValue()?"Y":"";
	var otherParams=patName+"^"+transInHosp;
	$HUI.datagrid('#keptPatTable').load({
		startDate:$HUI.datebox("#startDate").getValue(),
        endDate:$HUI.datebox("#endDate").getValue(),
        Loc:obsLocID,
        otherParams:otherParams
	})
	return;
}

function GetObsLocID(){
	var ObsLocID="";
	var ObsLocID = $HUI.combobox('#obsLoc').getValue()
	if(ObsLocID==""||ObsLocID==undefined){
		runClassMethod("web.DHCEMKeptPatient","GetObsLoc",{"CurLoc":LocId},  //hxy 2017-03-07 ���ڸ�ʽ������
		function(data){
			ObsLocID = data[0].value;
		},"json",false);		
	}
	return ObsLocID;
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

function myFormatDate(date){
	if(date.indexOf("/")){
		dateArr = date.split("/");
		return dateArr[2]+"-"+dateArr[1]+"-"+dateArr[0];
	}else{
		return date;	
	}
}


function formatHtmlToValue(text){
	text = text.replace(new RegExp('&nbsp;',"g"),' '); //text.replaceAll("&nbsp;"," ");
	text = text.replace(new RegExp('&nbsp',"g"),' '); //text.replaceAll("&nbsp"," ");
	return text;
}