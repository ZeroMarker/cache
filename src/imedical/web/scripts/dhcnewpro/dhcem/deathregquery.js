//===========================================================================================
// ���ߣ�      sufan
// ��д����:   2018-12-04
// ����:	   �����Ǽ�
//===========================================================================================
var excelData=[];
/// ҳ���ʼ������
function initPageDefault(){
	
	/// ��ʼ�����ز��˾���ID
	InitPatEpisodeID();
	
	InitPatInfoPanel();
	
	initDisable();
	
	/// ��ʼ�����ز����б�
	InitDeathRegList();
	
	InitMethod();
	
}

function initDisable(){
	$HUI.datebox("#WinRegDate").disable();
	$("#WinPatNo").attr("disabled",true);
	$("#WinName").attr("disabled",true);
	$("#WinPatSex").attr("disabled",true);
	$("#WinAdd").attr("disabled",true);
	$("#WinPatAge").attr("disabled",true);
	$("#WinTel").attr("disabled",true);
	
	$HUI.combobox("#Winsource").disable();
	$HUI.datebox("#WinBirthDate").disable();
	return;
}

/// ��ʼ�����ز��˾���ID
function InitPatEpisodeID(){
	EpisodeID = getParam("EpisodeID");
}

/// ��ʼ�����˻�����Ϣ
function InitPatInfoPanel(){
	
	
	$HUI.datebox("#stDate").setValue(formatDate(0)); 	///��ʼ����
	$HUI.datebox("#endDate").setValue(formatDate(0));	///��������
	
	///λ��
	$HUI.combobox("#Location",{
		url:LINK_CSP+"?ClassName=web.DHCEMVisitStat&MethodName=GetEmWard&HospID="+session['LOGON.HOSPID'],
		valueField:'id',
		textField:'text',
		panelHeight:"auto",
		onSelect:function(option){
	      
	    }	
	})
	
	
	///����������Դ
	$HUI.combobox("#Winsource",{
		url:LINK_CSP+"?ClassName=web.DHCEMVisitStat&MethodName=GetEmWard&HospID="+session['LOGON.HOSPID'],
		valueField:'id',
		textField:'text',
		panelHeight:"auto",
		onSelect:function(option){
	      
	    }	
	})
	
	/// ��Ԥ�������ڿ���
	$('#WinSendDate').datebox().datebox('calendar').calendar({
		validator: function(date){
			var now = new Date();
			return date<=now;
		}
	});
	
	/// �Ͳ��������ڿ���
	$('#WinSendMedDate').datebox().datebox('calendar').calendar({
		validator: function(date){
			var now = new Date();
			return date<=now;
		}
	});
	
}

///��ʼ���¼�
function InitMethod()
{
	///�ǼǺŻس��¼�
	$('#PatRegNo').bind('keypress',function(event){
        if(event.keyCode == "13")    
        {
            RegNoBlur();
            commonQuery();
        }
    });	
}

///���㷽��
function RegNoBlur()
{
	var i;
    var regno=$('#PatRegNo').val();
    var oldLen=regno.length;
    if (oldLen==10) return;
	if (regno!="") {  //add 0 before regno
	    for (i=0;i<10-oldLen;i++)
	    //for (i=0;i<8-oldLen;i++)
	    {
	    	regno="0"+regno 
	    }
	}
    $("#PatRegNo").val(regno);
}
/// ҳ��DataGrid��ʼ������ѡ�б�
function InitDeathRegList(){
	
	///  ����columns
	var columns=[[
		{field:'select',title:'ѡ��',checkbox:true,width:40,align:'center'},
		{field:'seqNo',title:'���',width:40,align:'center'},
		{field:'DeathNum',title:'���',width:80},
		{field:'PatRegNo',title:'�ǼǺ�',width:80},
		{field:'PatName',title:'����',width:60},
		{field:'PatSex',title:'�Ա�',width:80},
		{field:'PatAge',title:'ʵ������',width:80},
		{field:'HouseHoldName',title:'��������',width:80},
		{field:'RegDate',title:'�Ǽ�����',width:100},
		{field:'Birth',title:'��������',width:100},
		{field:'VistDate',title:'��������',width:100},
		{field:'DateDel',title:'��Ԥ��������',width:100},
		{field:'DateSendMed',title:'�Ͳ���������',width:100},
		{field:'Tel',title:'�绰',width:100},
		{field:'Add',title:'��ַ',width:100},
		{field:'Come',title:'��Դ',width:100}
	]];
	
	///  ����datagrid
	var option = {
		iconCls:'icon-paper', //hxy 2022-11-16 st
		title:$g('�����Ǽ�'),
		fitColumns:true, //ed
		//showHeader:false,
		toolbar:"#toolbar",
		border:true,
		headerCls:'panel-header-gray',
		rownumbers : false,
		singleSelect : true,
		checkOnSelect : false,
		selectOnCheck : false,
		pagination: true,
		onClickRow:function(rowIndex, rowData){
	    },
		onLoadSuccess:function(data){
			excelData = data.rows;
		}
	};

	var param = getSearParam();
	var uniturl = LINK_CSP+"?ClassName=web.DHCEMDeathRegQuery&MethodName=JSonQueryEmDeathData&params="+param;
	new ListComponent('deathreglist', columns, uniturl, option).Init();
}

///��ѯ
function commonQuery()
{
	var param = getSearParam();
	$HUI.datagrid('#deathreglist').load({
		"params":param
	})
}
///����
function commonExport()
{
	if(excelData.length){
		expExcel(excelData);	
	}else{
		$.messager.alert("��ʾ","û�����ݵ�����");	
	}
}
///����
function expExcelOld(itbl)
{		
//		runClassMethod("web.UDHCJFCOMMON","getpath",{'itmjs':'','itmjsex':''},function(jsonString){
//			TemplatePath = jsonString;
//		},'',false)
//		
		var TemplatePath = serverCall("web.DHCDocConfig","GetPath");
		var hospName = "";
		runClassMethod("web.DHCEMRegister","gethHospitalName",{'locId':LgCtLocID},function(jsonString){
			hospName = jsonString;  
		},'text',false)
		
 	 	xlsExcel = new ActiveXObject("Excel.Application");
 	 	xlsBook = xlsExcel.Workbooks.Add() 
    	xlsSheet = xlsBook.ActiveSheet; 
    	xlsExcel.Visible = true;  
    	xlsExcel.Range(xlsSheet.Cells(1,1),xlsSheet.Cells(1,15)).MergeCells = true;
    	xlsExcel.Range(xlsSheet.Cells(2,1),xlsSheet.Cells(2,15)).MergeCells = true;
    	xlsSheet.cells(1,1).Font.Bold = true;
    	xlsSheet.cells(2,1).Font.Bold = true;
    	xlsSheet.cells(1,1).Font.Size =24;
    	xlsSheet.cells(1,1).HorizontalAlignment = -4108;
    	xlsSheet.cells(2,1).HorizontalAlignment = -4108;
    	for(i=1;i<15;i++){
	    	if(i==1) xlsSheet.cells(1,i).ColumnWidth=5;
	    	if(i!=1) xlsSheet.cells(1,i).ColumnWidth=10;	
	    }
    	
    	
		xlsSheet.cells(1,1) =hospName;     
  	  	xlsSheet.cells(2,1)="�����Ǽ�";
    	xlsSheet.cells(3,1)="���";
		xlsSheet.cells(3,2)="���";
	   	xlsSheet.cells(3,3)="�ǼǺ�";
	    xlsSheet.cells(3,4)="����";
	    xlsSheet.cells(3,5)="�Ա�";
	    xlsSheet.cells(3,6)="ʵ������";
	    xlsSheet.cells(3,7)="��������";
	    xlsSheet.cells(3,8)="�Ǽ�����";
		xlsSheet.cells(3,9)="��������";
	    xlsSheet.cells(3,10)="��������";
	    xlsSheet.cells(3,11)="��Ԥ��������";
	    xlsSheet.cells(3,12)="�Ͳ���������";
	    xlsSheet.cells(3,13)="�绰";
		xlsSheet.cells(3,14)="��ַ";
		xlsSheet.cells(3,15)="��Դ";
   
    if (itbl.length==0) {
	    $.messager.alert("��ʾ","û��ѡ�����ݣ�");
	    return;
	}	
    for (var i=0; i<itbl.length; i++) {
	    xlsSheet.cells(i+4,1)=i+1;
		xlsSheet.cells(i+4,2)="'"+itbl[i].DeathNum;
	    xlsSheet.cells(i+4,3)="'"+itbl[i].PatRegNo;
	    xlsSheet.cells(i+4,4)="'"+itbl[i].PatName;
	    xlsSheet.cells(i+4,5)=itbl[i].PatSex;
	    xlsSheet.cells(i+4,6)=itbl[i].PatAge;
	    xlsSheet.cells(i+4,7)=itbl[i].HouseHoldName;
	    xlsSheet.cells(i+4,8)=itbl[i].RegDate;
	    xlsSheet.cells(i+4,9)=itbl[i].Birth;                   
	    xlsSheet.cells(i+4,10)=itbl[i].VistDate; 
	    xlsSheet.cells(i+4,11)="'"+itbl[i].DateDel;
	    xlsSheet.cells(i+4,12)=itbl[i].DateSendMed;   
	    xlsSheet.cells(i+4,13)=itbl[i].Tel;  
	    xlsSheet.cells(i+4,14)="'"+itbl[i].Add;  
	    xlsSheet.cells(i+4,15)=itbl[i].Come;    
 	 }
	gridlist(xlsSheet,3,itbl.length+3,1,15)
	xlsSheet.Columns.AutoFit; 
	xlsExcel.ActiveWindow.Zoom = 75 
	xlsExcel.UserControl = true;  //����Ҫ,����ʡ��,��Ȼ������� ��˼��excel�����û����� 

	xlsExcel=null; 
    xlsBook=null; 
    xlsSheet=null; 
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

///����
function expExcel(itbl)
{		var Dea=$g('�����Ǽ�');
		var DeathNum=$g('���');
		var PatRegNo=$g('�ǼǺ�')
		var PatName=$g('����');
		var PatSex=$g('�Ա�');
		var PatAge=$g('ʵ������');
		var HouseHoldName=$g('��������');
		var RegDate=$g('�Ǽ�����');
		var Birth=$g('��������');
		var VistDate=$g('��������');
		var DateDel=$g('��Ԥ��������');
		var DateSendMed=$g('�Ͳ���������');
		var Tel=$g('�绰');
		var Add=$g('��ַ');
		var Come=$g('��Դ');
		
		var TemplatePath = serverCall("web.DHCDocConfig","GetPath");
		var hospName = "";
		runClassMethod("web.DHCEMRegister","gethHospitalName",{'locId':LgCtLocID},function(jsonString){
			hospName = jsonString;  
		},'text',false)
	
 	 	var Str = "(function test(x){"+
		"var xlApp = new ActiveXObject('Excel.Application');"+
		"var xlBook = xlApp.Workbooks.Add();"+
		"var xlSheet = xlBook.ActiveSheet;";
		
		Str=Str+"xlApp.Range(xlApp.Cells(1,1),xlApp.Cells(1,15)).MergeCells = true;"+ //�ϲ���Ԫ��
		"xlApp.Range(xlApp.Cells(2,1),xlApp.Cells(2,15)).MergeCells = true;"+ //�ϲ���Ԫ��
		"xlSheet.Cells(1,1).Font.Bold = true;"+
		"xlSheet.Cells(2,1).Font.Bold = true;"+
		"xlSheet.Cells(1,1).Font.Size = 24;"+
		"xlSheet.Cells(1,1).HorizontalAlignment = -4108;"+
		"xlSheet.Cells(2,1).HorizontalAlignment = -4108;";
    	for(i=1;i<15;i++){
	    	if(i==1) Str=Str+"xlSheet.cells(1,"+i+").ColumnWidth=5;";
	    	if(i!=1) Str=Str+"xlSheet.cells(1,"+i+").ColumnWidth=10;";
	    }
    	
		Str=Str+"xlSheet.cells(1,1) ='"+hospName+"';"+    
  	  	"xlSheet.cells(2,1).value='"+Dea+"';"+
    	"xlSheet.cells(3,2).value='"+DeathNum+"';"+
    	"xlSheet.cells(3,3).value='"+PatRegNo+"';"+
    	"xlSheet.cells(3,4).value='"+PatName+"';"+
    	"xlSheet.cells(3,5).value='"+PatSex+"';"+
    	"xlSheet.cells(3,6).value='"+PatAge+"';"+
		"xlSheet.cells(3,7).value='"+HouseHoldName+"';"+
		"xlSheet.cells(3,8).value='"+RegDate+"';"+
		"xlSheet.cells(3,9).value='"+Birth+"';"+
		"xlSheet.cells(3,10).value='"+VistDate+"';"+
		"xlSheet.cells(3,11).value='"+DateDel+"';"+
		"xlSheet.cells(3,12).value='"+DateSendMed+"';"+
		"xlSheet.cells(3,13).value='"+Tel+"';"+
		"xlSheet.cells(3,14).value='"+Add+"';"+
		"xlSheet.cells(3,15).value='"+Come+"';";
   
    if (itbl.length==0) {
	    $.messager.alert("��ʾ","û��ѡ�����ݣ�");
	    return;
	}	
    for (var i=0; i<itbl.length; i++) {
	    Str=Str+"xlSheet.cells("+(i+4)+",1).value='"+(i+1)+"';"+
	    "xlSheet.Columns(2).NumberFormatLocal='@';"+
	    "xlSheet.Columns(3).NumberFormatLocal='@';"+
	    "xlSheet.Columns(4).NumberFormatLocal='@';"+
	    "xlSheet.Columns(11).NumberFormatLocal='@';"+
	    "xlSheet.Columns(13).NumberFormatLocal='@';"+
	    "xlSheet.Columns(14).NumberFormatLocal='@';"+
	    "xlSheet.cells("+(i+4)+",2)='"+itbl[i].DeathNum+"';"+
	    "xlSheet.cells("+(i+4)+",3)='"+itbl[i].PatRegNo+"';"+
	    "xlSheet.cells("+(i+4)+",4)='"+itbl[i].PatName+"';"+
	    "xlSheet.cells("+(i+4)+",5)='"+itbl[i].PatSex+"';"+
	    "xlSheet.cells("+(i+4)+",6)='"+itbl[i].PatAge+"';"+
	    "xlSheet.cells("+(i+4)+",7)='"+itbl[i].HouseHoldName+"';"+
	    "xlSheet.cells("+(i+4)+",8)='"+itbl[i].RegDate+"';"+
	    "xlSheet.cells("+(i+4)+",9)='"+itbl[i].Birth+"';"+
	    "xlSheet.cells("+(i+4)+",10)='"+itbl[i].VistDate+"';"+
	    "xlSheet.cells("+(i+4)+",11)='"+itbl[i].DateDel+"';"+
	    "xlSheet.cells("+(i+4)+",12)='"+itbl[i].DateSendMed+"';"+
	    "xlSheet.cells("+(i+4)+",13)='"+itbl[i].Tel+"';"+
	    "xlSheet.cells("+(i+4)+",14)='"+itbl[i].Add+"';"+
	    "xlSheet.cells("+(i+4)+",15)='"+itbl[i].Come+"';";
 	 }
    
    var row1=3,row2=itbl.length+3,c1=1,c2=15;
	Str=Str+"xlSheet.Range(xlSheet.Cells("+row1+","+c1+"),xlSheet.Cells("+row2+","+c2+")).Borders(1).LineStyle=1;"+
	"xlSheet.Range(xlSheet.Cells("+row1+","+c1+"),xlSheet.Cells("+row2+","+c2+")).Borders(1).Weight=2;"+
	"xlSheet.Range(xlSheet.Cells("+row1+","+c1+"),xlSheet.Cells("+row2+","+c2+")).Borders(2).LineStyle=1;"+
	"xlSheet.Range(xlSheet.Cells("+row1+","+c1+"),xlSheet.Cells("+row2+","+c2+")).Borders(2).Weight=2;"+
	"xlSheet.Range(xlSheet.Cells("+row1+","+c1+"),xlSheet.Cells("+row2+","+c2+")).Borders(3).LineStyle=1;"+
	"xlSheet.Range(xlSheet.Cells("+row1+","+c1+"),xlSheet.Cells("+row2+","+c2+")).Borders(3).Weight=2;"+
	"xlSheet.Range(xlSheet.Cells("+row1+","+c1+"),xlSheet.Cells("+row2+","+c2+")).Borders(4).LineStyle=1;"+ 
	"xlSheet.Range(xlSheet.Cells("+row1+","+c1+"),xlSheet.Cells("+row2+","+c2+")).Borders(4).Weight=2;"+
	"xlSheet.Columns.AutoFit;"+
	"xlApp.Visible=true;"+
	"xlApp=null;"+
	"xlBook=null;"+
	"xlSheet=null;"+
    "return 1;}());";
    //����Ϊƴ��Excel��ӡ����Ϊ�ַ���
    CmdShell.notReturn = 1;   //�����޽�����ã�����������
	var rtn = CmdShell.CurrentUserEvalJs(Str);   //ͨ���м�����д�ӡ���� 
	return; 
}

///�����Ǽ�
function DeathRegist()
{
	var rowObj=$('#deathreglist').datagrid('getSelected');
	if(rowObj==null)
	{
		$.messager.alert("��ʾ","��ѡ��һ����¼��");
		return false;
	}
	$('#DeathWin').window({
		iconCls:'icon-w-edit',
		title:$g('�����Ǽ�'),
		collapsible:false,
		minimizable:false,
		maximizable:false,
		border:false,
		closed:false,
		width:720,
		height:340
	});
			
	$('#DeathWin').window('open');
	initWinInfo(rowObj)     ///������������Ϣ
}
///������Ϣ��ѯ
function initWinInfo(rowObj)
{
	$("#WinNumber").val(rowObj.DeathNum);					///���
	if(rowObj.RegDate==""){
		$HUI.datebox("#WinRegDate").setValue(formatDate(0));	///�Ǽ�����
	}else{
		$HUI.datebox("#WinRegDate").setValue(rowObj.RegDate);	///�Ǽ�����
	}
	$("#WinPatNo").val(rowObj.PatRegNo);					///�ǼǺ�
	$("#WinName").val(rowObj.PatName);						///����
	$("#WinPatSex").val(rowObj.PatSex);						///�Ա�
	$HUI.datebox("#WinBirthDate").setValue(rowObj.Birth);	///��������
	$HUI.datebox("#WinDeathDate").setValue(rowObj.VistDate); ///��������
	$HUI.datebox("#WinSendDate").setValue(rowObj.DateDel);  ///��Ԥ��������
	$HUI.datebox("#WinSendMedDate").setValue(rowObj.DateSendMed);  ///�Ͳ���������
	$("#WinPatAge").val(rowObj.PatAge);						///ʵ������
	$("#WinTel").val(rowObj.Tel);							///�绰
	$("#WinAdd").val(rowObj.Add);							///סַ
	$HUI.combobox("#Winsource").setValue(rowObj.Come);		///��Դ
	$("#WinHomeName").val(rowObj.HouseHoldName);			///��������
	$("#WinFundis").val(rowObj.FundLetDis);					///������������
			
	
}
///��ȡ����
function getSearParam()
{
	var stDate=$HUI.datebox("#stDate").getValue();   		///��ʼ����
	var edDate=$HUI.datebox("#endDate").getValue();	 		///��������
	var PatRegNo=$("#PatRegNo").val();				 		///�ǼǺ�
	var PatName=$("#PatName").val();				 		///����
	var Location=$HUI.combobox("#Location").getText();		///λ��
	return stDate +"^"+ edDate +"^"+ PatRegNo +"^"+ PatName +"^"+ Location+"^"+LgHospID; //hxy 2020-06-03 LgHospID
}

///���滼�߻�����Ϣ
function SavePatInfo()
{
	var rowObj=$('#deathreglist').datagrid('getSelected');
	var PatientID=rowObj.PatientID;									/// ����ID
	var DeathPatNum=$("#WinNumber").val();							/// �������߱��
	var DelPreSecDate=$HUI.datebox("#WinSendDate").getValue();		/// ��Ԥ��������
	var DelMedRecDate=$HUI.datebox("#WinSendMedDate").getValue();	/// �Ͳ���������
	var FundLetDis=$("#WinFundis").val();							/// ������������
	var HouHolderName=$("#WinHomeName").val();						/// ��������
	var Params=PatientID +"^"+ DeathPatNum +"^"+ DelPreSecDate +"^"+ DelMedRecDate +"^"+ FundLetDis +"^"+ HouHolderName +"^"+ LgUserID;
	runClassMethod("web.DHCEMDeathRegQuery","SaveDeathInfo",{'Params':Params},function(data){
			if(data==0)
			{
				$("#DeathWin").window('close');
				commonQuery();
			}
			
		},'',false)
}
///���ڵ���
function exportList()
{
	var data=$("#deathreglist").datagrid('getChecked');
	
	if(data.length==0){
		$.messager.alert("��ʾ","û�����ݵ�����");
		return;
	}
	
	expExcel(data);
	$("#DeathWin").window('close');
}

function CloseWindow(express){
	$(express).window('close');	
}
/// JQuery ��ʼ��ҳ��
$(function(){ initPageDefault(); })



