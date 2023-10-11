//===========================================================================================
// ���ߣ�      huaxiaoying
// ��д����:   2018-04-27
// ����:	   ������ϸͳ��
//===========================================================================================
/// ҳ���ʼ������


var LgUserID = session['LOGON.USERID'];  /// �û�ID
var LgLocID = session['LOGON.CTLOCID'];  /// ����ID
var LgHospID = session['LOGON.HOSPID'];  /// ҽԺID
var LgGroupID = session['LOGON.GROUPID'] /// ��ȫ��ID
function initPageDefault(){

	InitPageDataGrid();		  /// ��ʼ��ҳ��datagrid
	InitPageComponent(); 	  /// ��ʼ������ؼ�����

}

/// ��ʼ������ؼ�����
function InitPageComponent(){
	
	/// ��ʼ����
	$HUI.datebox("#CstStartDate").setValue(GetCurSysDate(-2));
	
	/// ��������
	$HUI.datebox("#CstEndDate").setValue(GetCurSysDate(0));
	
	/// �������� 2021-01-29
	$HUI.combobox("#CstType",{ 
		url:LINK_CSP+"?ClassName=web.DHCEMConsultCom&MethodName=JsonAllCstType&HospID="+session['LOGON.HOSPID'],
		valueField: "value", 
		textField: "text",
		editable:true,
		onLoadSuccess:function(data){
	    }	
	})
	
	/// �������� hxy 2021-04-15
	$HUI.combobox("#consNature",{
		url:LINK_CSP+"?ClassName=web.DHCEMConsultCom&MethodName=JsonCstProp&LgHospID="+LgHospID, //hxy 2020-05-29 add LgHospID
		valueField: "itmID", 
		textField: "itmDesc",
		panelHeight:'auto',
		editable:true
		
	})
	
	/// �������
	$HUI.combobox("#consRLoc",{
		url: LINK_CSP+"?ClassName=web.DHCEMConsultCom&MethodName=JsonLoc&HospID="+LgHospID,
		valueField: "value", 
		textField: "text",
		editable:true,
		mode:'remote'
	})
	
	/// �������
	$HUI.combobox("#consultLoc",{
		url: LINK_CSP+"?ClassName=web.DHCEMConsultCom&MethodName=JsonLoc&HospID="+LgHospID,
		valueField: "value", 
		textField: "text",
		editable:true,
		mode:'remote'
	})
	/*var uniturl = LINK_CSP+"?ClassName=web.DHCEMConsStatus&MethodName=";
	/// ״̬����
	var option = {
		panelHeight:"auto",
		onSelect:function(option){
		}
	}
	var url = uniturl+"jsonConsStat&HospID="+session['LOGON.HOSPID'];
	new ListCombobox("CstType",url,'',option).init();*/
}

/// ҳ��DataGrid��ʼ������ѡ�б�
function InitPageDataGrid(){
	
	///  ����columns
	var columns=[[
		{field:'CstType',title:'��������',width:100,align:'left'},
		{field:'CstRLoc',title:'�������',width:140},
		{field:'CstRUser',title:'������',width:100},
		{field:'CstRDate',title:'��������',width:100,align:'left'},
		{field:'CstRTime',title:'����ʱ��',width:100,align:'left'},
		{field:'CstNDate',title:'��������',width:100,align:'left'},
		{field:'CstNTime',title:'����ʱ��',width:100,align:'left'},
		{field:'PatName',title:'��������',width:100,align:'left'},
		{field:'PatRegNo',title:'�ǼǺ�',width:100,align:'left'},
		{field:'PatMrNo',title:'������',width:100,align:'left'}, //hxy 2021-06-24
		{field:'CstTrePro',title:'����ժҪ',width:100,align:'left',formatter:SetCellField},//
		{field:'CstPurpose',title:'�������ɼ�Ҫ��',width:120,align:'left',formatter:SetCellField},//
		{field:'CstStat',title:'״̬',width:100,align:'left'},
		{field:'CsLocDesc',title:'�������',width:140,align:'left'},
		{field:'CsUser',title:'������',width:100,align:'left'}, //hxy 2021-06-24
		//{field:'CstECLArriTime',title:'����ʱ��',width:150,align:'center'},
		{field:'CstLogOverTime',title:'���ʱ��',width:150,align:'left'},
		{field:'CstECLUser',title:'ȷ����',width:100,align:'left'},
		{field:'CstECLTime',title:'ȷ��ʱ��',width:150,align:'left'},
		{field:'CstNature',title:'��������',width:100,align:'left'}, //hxy 2021-04-15
		{field:'CsOpinion',title:'�������',align:'left',width:250,formatter:SetCellField}, //hxy 2022-06-27
	]];
	
	///  ����datagrid
	var option = {
		title:$g('������ϸͳ��'), //hxy 2020-04-30 st
		headerCls:'panel-header-gray', 
		border:true,
		iconCls:'icon-paper',//ed
		//fitColumns:true,
		//showHeader:false,
		pageSize:10000,
	    pageList:[10000,50000],
		fitColumn:true,
		rownumbers : true,
		singleSelect : true,
		pagination: true,
		onClickRow:function(rowIndex, rowData){
	    },
		onLoadSuccess:function(data){
			BindTips(); /// ����ʾ��Ϣ
		}
	};
	
	/// init
	var uniturl = LINK_CSP+"?ClassName=web.DHCEMConsultStatistic&MethodName=JsonGetConsultNo";
	new ListComponent('dgCstDetList', columns, uniturl, option).Init();
}

/// ���������ַ�
function SetCellField(value, rowData, rowIndex){
	return $_TrsTxtToSymbol(value);
}

/// ��ѯ
function QryConsList(){
	
	var CstStartDate = $HUI.datebox("#CstStartDate").getValue();  /// ��ʼ����
	var CstEndDate = $HUI.datebox("#CstEndDate").getValue();      /// ��������
	var CstStatus = $("input[name='CstStatus']:checked").val();   /// ״̬
	if(CstStatus==undefined){CstStatus="";}
	//var CstTypeID = $HUI.combobox("#CstType").getValue();    /// ״̬
	var CstType = $HUI.combobox("#CstType").getValue()==undefined?"":$HUI.combobox("#CstType").getValue(); //hxy 2021-01-29
	var consNature = $HUI.combobox("#consNature").getValue()==undefined?"":$HUI.combobox("#consNature").getValue(); //hxy 2021-04-15
	var cstRLocID = $HUI.combobox("#consRLoc").getValue()==undefined?"":$HUI.combobox("#consRLoc").getValue();    //�������
	var cstLocID = $HUI.combobox("#consultLoc").getValue()==undefined?"":$HUI.combobox("#consultLoc").getValue(); //�������
	var DOCA = $HUI.checkbox("#DOCA").getValue()?"Y":"N"; //hxy 2022-09-02
    /// ���¼��ػ����б�
	var params = CstStartDate +"^"+ CstEndDate +"^"+ CstStatus +"^"+ LgHospID +"^"+ CstType +"^"+ consNature+"^"+cstRLocID+"^"+cstLocID+"^"+DOCA;
	$("#dgCstDetList").datagrid("load",{"Params":params});
}

/// ��ȡϵͳ����
function GetCurSysDate(offset){

	var SysDate = "";
	runClassMethod("web.DHCEMConsultCom","GetCurSystemDate",{"offset":offset},function(jsonString){

		if (jsonString != ""){
			SysDate = jsonString;
		}
	},'',false)
	return SysDate;
}

///��ӡ
function PrtConsList(){
    
	var CstStartDate = $HUI.datebox("#CstStartDate").getValue();  /// ��ʼ����
	var CstEndDate = $HUI.datebox("#CstEndDate").getValue();      /// ��������
	
	var xlsExcel = new ActiveXObject("Excel.Application");
	var xlsBook = xlsExcel.Workbooks.Add();
	var objSheet = xlsBook.ActiveSheet;
	xlsExcel.Range(objSheet.Cells(1,1),objSheet.Cells(1,17)).MergeCells = true;
	objSheet.cells(1,1).Font.Bold = true;
	//objSheet.cells(1,1).Font.Size =24;
	//objSheet.cells(1,1).HorizontalAlignment = -4108;
	objSheet.cells(1,1)="������ϸͳ��("+CstStartDate+"��"+CstEndDate+")";
	var strjLen=$HUI.datagrid("#dgCstDetList").getData().rows.length;
	for (i=1;i<=strjLen;i++)
     { 	
	    objSheet.cells(i+2,1)=i;
	    objSheet.cells(i+2,2)=$HUI.datagrid("#dgCstDetList").getData().rows[i-1].CstType;
	    objSheet.cells(i+2,3)=$HUI.datagrid("#dgCstDetList").getData().rows[i-1].CstRLoc;
	    objSheet.cells(i+2,4)=$HUI.datagrid("#dgCstDetList").getData().rows[i-1].CstRUser;
	    objSheet.cells(i+2,5)=$HUI.datagrid("#dgCstDetList").getData().rows[i-1].CstRDate;
	    objSheet.cells(i+2,6)=$HUI.datagrid("#dgCstDetList").getData().rows[i-1].CstRTime;
	    objSheet.cells(i+2,7)=$HUI.datagrid("#dgCstDetList").getData().rows[i-1].CstNDate;
	    
	    objSheet.cells(i+2,8)=$HUI.datagrid("#dgCstDetList").getData().rows[i-1].CstNTime;
	    objSheet.cells(i+2,9)=$HUI.datagrid("#dgCstDetList").getData().rows[i-1].PatName;
	    objSheet.cells(i+2,10)=$HUI.datagrid("#dgCstDetList").getData().rows[i-1].PatRegNo;
	    objSheet.cells(i+2,11)=$HUI.datagrid("#dgCstDetList").getData().rows[i-1].CstTrePro;
	    objSheet.cells(i+2,12)=$HUI.datagrid("#dgCstDetList").getData().rows[i-1].CstPurpose;
	    objSheet.cells(i+2,13)=$HUI.datagrid("#dgCstDetList").getData().rows[i-1].CstStat;
	    objSheet.cells(i+2,14)=$HUI.datagrid("#dgCstDetList").getData().rows[i-1].CsLocDesc;
		//objSheet.cells(i+2,15)=$HUI.datagrid("#dgCstDetList").getData().rows[i-1].CstECLArriTime;
		objSheet.cells(i+2,15)=$HUI.datagrid("#dgCstDetList").getData().rows[i-1].CstLogOverTime;
		objSheet.cells(i+2,16)=$HUI.datagrid("#dgCstDetList").getData().rows[i-1].CstECLUser;
		objSheet.cells(i+2,17)=$HUI.datagrid("#dgCstDetList").getData().rows[i-1].CstECLTime;
		objSheet.Rows(i+2).RowHeight = 30; 
		for (j=1;j<=18;j++)
     	{ 	
			xlsExcel.Range(xlsExcel.Cells(i+2,j),xlsExcel.Cells(i+2,j)).Borders(1).LineStyle=1;  //�����ϱ߿�
			xlsExcel.Range(xlsExcel.Cells(i+2,j),xlsExcel.Cells(i+2,j)).Borders(2).LineStyle=1;  //�����ϱ߿�
			xlsExcel.Range(xlsExcel.Cells(i+2,j),xlsExcel.Cells(i+1,j)).Borders(4).LineStyle=1;  //�����ϱ߿�
 	 	}

 	 }
     
    //objSheet.Columns.AutoFit;
	objSheet.printout();
	
	xlsExcel=null;
	xlsBook.Close(savechanges=false);
	objSheet=null;

}

///���������ݹȸ�
function ExpConsList(){	
	var CstStartDate = $HUI.datebox('#CstStartDate').getValue();  /// ��ʼ����
	var CstEndDate = $HUI.datebox('#CstEndDate').getValue();      /// ��������
	var CstType = $HUI.combobox("#CstType").getText();            ///�������� hxy 2021-04-15 st
	var Nature = $HUI.combobox("#consNature").getText();          ///��������
	var CstStatus = $("input[name='CstStatus']:checked").val(); /// ״̬
	var Note="";
	if((CstType!="")&&(CstType!=undefined)){
		CstType="+"+CstType;
	}
	if((Nature!="")&&(Nature!=undefined)){
		Nature="+"+Nature;
	}
	if(CstStatus!=""){
		CstStatus="+"+CstStatus+"״̬";
	}
	Note=CstType+Nature+CstStatus; //ed

	
	var Str = "(function test(x){"+
	"var xlsExcel = new ActiveXObject('Excel.Application');"+
	"var xlsBook = xlsExcel.Workbooks.Add();"+
	"var objSheet = xlsBook.ActiveSheet;"+ 
	"xlsExcel.Visible = true;"+ 
	"xlsExcel.Range(objSheet.Cells(1,1),objSheet.Cells(1,20)).MergeCells = true;"+
	"objSheet.Columns(5).NumberFormatLocal='@';"+
	"objSheet.Columns(7).NumberFormatLocal='@';"+
	"objSheet.Columns(9).NumberFormatLocal='@';"+
	"objSheet.Columns(10).NumberFormatLocal='@';"+
	"objSheet.Columns(11).NumberFormatLocal='@';"+ //
	"objSheet.Columns(12).NumberFormatLocal='@';"+ //
	"objSheet.Columns(13).NumberFormatLocal='@';"+ //
	"objSheet.Columns(17).NumberFormatLocal='@';"+
	"objSheet.Columns(19).NumberFormatLocal='@';"+
	"objSheet.cells(1,1).Font.Bold = true;"+
	"objSheet.cells(1,1).Font.Size =20;"+
	"objSheet.cells(1,1).HorizontalAlignment = -4108;"+
	"objSheet.cells(1,1)='������ϸͳ��("+CstStartDate+"��"+CstEndDate+Note+")';"+
	"objSheet.cells(2,1)='���';"+
	"objSheet.cells(2,2)='��������';"+
	"objSheet.cells(2,3)='�������';"+
	"objSheet.cells(2,4)='������';"+
	"objSheet.cells(2,5)='��������';"+
	"objSheet.cells(2,6)='����ʱ��';"+
	"objSheet.cells(2,7)='��������';"+
	"objSheet.cells(2,8)='����ʱ��';"+
	"objSheet.cells(2,9)='��������';"+ //hxy 2021-05-11 add
	"objSheet.cells(2,10)='�ǼǺ�';"+  //hxy 2021-05-11 add
	"objSheet.cells(2,11)='������';"+  //hxy 2021-06-24 add
	"objSheet.cells(2,12)='����ժҪ';"+
	"objSheet.cells(2,13)='�������ɼ�Ҫ��';"+
	"objSheet.cells(2,14)='״̬';"+
	"objSheet.cells(2,15)='�������';"+
	"objSheet.cells(2,16)='������';"+  //hxy 2021-06-24 add
	//"objSheet.cells(2,13)='����ʱ��';"+ //hxy 2021-05-11 ע��
	"objSheet.cells(2,17)='���ʱ��';"+
	"objSheet.cells(2,18)='ȷ����';"+
	"objSheet.cells(2,19)='ȷ��ʱ��';"+
	"objSheet.cells(2,20)='��������';"+
	"objSheet.cells(2,21)='�������';"; //hxy 2022-06-27
	
	var strjLen=$HUI.datagrid('#dgCstDetList').getData().rows.length;
	
	for (i=1;i<=strjLen;i++){
		Str=Str+"objSheet.cells("+(i+2)+",1)='"+i+"';"+
		"objSheet.cells("+(i+2)+",2)='"+$HUI.datagrid('#dgCstDetList').getData().rows[i-1].CstType+"';"+
		"objSheet.cells("+(i+2)+",3)='"+$HUI.datagrid('#dgCstDetList').getData().rows[i-1].CstRLoc+"';"+
		"objSheet.cells("+(i+2)+",4)='"+$HUI.datagrid('#dgCstDetList').getData().rows[i-1].CstRUser+"';"+
		"objSheet.cells("+(i+2)+",5)='"+$HUI.datagrid('#dgCstDetList').getData().rows[i-1].CstRDate+"';"+
		"objSheet.cells("+(i+2)+",6)='"+$HUI.datagrid('#dgCstDetList').getData().rows[i-1].CstRTime+"';"+
		"objSheet.cells("+(i+2)+",7)='"+$HUI.datagrid('#dgCstDetList').getData().rows[i-1].CstNDate+"';"+
		"objSheet.cells("+(i+2)+",8)='"+$HUI.datagrid('#dgCstDetList').getData().rows[i-1].CstNTime+"';"+
		"objSheet.cells("+(i+2)+",9)='"+$HUI.datagrid('#dgCstDetList').getData().rows[i-1].PatName+"';"+
		"objSheet.cells("+(i+2)+",10)='"+$HUI.datagrid('#dgCstDetList').getData().rows[i-1].PatRegNo+"';"+
		"objSheet.cells("+(i+2)+",11)='"+$HUI.datagrid('#dgCstDetList').getData().rows[i-1].PatMrNo+"';"+
		"objSheet.cells("+(i+2)+",12)='"+$HUI.datagrid('#dgCstDetList').getData().rows[i-1].CstTrePro.replace(/\n/g,"\\n").replace(/\'/g,"\\'")+"';"+
		"objSheet.cells("+(i+2)+",13)='"+$HUI.datagrid('#dgCstDetList').getData().rows[i-1].CstPurpose.replace(/\'/g,"\\'")+"';"+
		"objSheet.cells("+(i+2)+",14)='"+$HUI.datagrid('#dgCstDetList').getData().rows[i-1].CstStat+"';"+
		"objSheet.cells("+(i+2)+",15)='"+$HUI.datagrid('#dgCstDetList').getData().rows[i-1].CsLocDesc+"';"+
		"objSheet.cells("+(i+2)+",16)='"+$HUI.datagrid('#dgCstDetList').getData().rows[i-1].CsUser+"';"+
		//"objSheet.cells("+(i+2)+",13)='"+$HUI.datagrid('#dgCstDetList').getData().rows[i-1].CstECLArriTime+"';"+
		"objSheet.cells("+(i+2)+",17)='"+$HUI.datagrid('#dgCstDetList').getData().rows[i-1].CstLogOverTime+"';"+
		"objSheet.cells("+(i+2)+",18)='"+$HUI.datagrid('#dgCstDetList').getData().rows[i-1].CstECLUser+"';"+
		"objSheet.cells("+(i+2)+",19)='"+$HUI.datagrid('#dgCstDetList').getData().rows[i-1].CstECLTime+"';"+
		"objSheet.cells("+(i+2)+",20)='"+$HUI.datagrid('#dgCstDetList').getData().rows[i-1].CstNature+"';"+
		"objSheet.cells("+(i+2)+",21)='"+$HUI.datagrid('#dgCstDetList').getData().rows[i-1].CsOpinion+"';" //hxy 2022-06-27
	}
	var row1=2,row2=strjLen+2,c1=1,c2=21;
	Str=Str+"objSheet.Range(objSheet.Cells("+row1+","+c1+"),objSheet.Cells("+row2+","+c2+")).Borders(1).LineStyle=1;"+
	"objSheet.Range(objSheet.Cells("+row1+","+c1+"),objSheet.Cells("+row2+","+c2+")).Borders(1).Weight=2;"+
	"objSheet.Range(objSheet.Cells("+row1+","+c1+"),objSheet.Cells("+row2+","+c2+")).Borders(2).LineStyle=1;"+
	"objSheet.Range(objSheet.Cells("+row1+","+c1+"),objSheet.Cells("+row2+","+c2+")).Borders(2).Weight=2;"+
	"objSheet.Range(objSheet.Cells("+row1+","+c1+"),objSheet.Cells("+row2+","+c2+")).Borders(3).LineStyle=1;"+
	"objSheet.Range(objSheet.Cells("+row1+","+c1+"),objSheet.Cells("+row2+","+c2+")).Borders(3).Weight=2;"+
	"objSheet.Range(objSheet.Cells("+row1+","+c1+"),objSheet.Cells("+row2+","+c2+")).Borders(4).LineStyle=1;"+ 
	"objSheet.Range(objSheet.Cells("+row1+","+c1+"),objSheet.Cells("+row2+","+c2+")).Borders(4).Weight=2;"+
	"objSheet.Columns.AutoFit;"+ 
	"xlsExcel.ActiveWindow.Zoom = 75 ;"+
	"xlsExcel.UserControl = true;"+  	//����Ҫ,����ʡ��,��Ȼ������� ��˼��excel�����û����� 
	"xlsExcel=null;"+ 
	"xlsBook=null;"+ 
	"objSheet=null;"+ 
    "return 1;}());";
	//����Ϊƴ��Excel��ӡ����Ϊ�ַ���
    CmdShell.notReturn = 1;   //�����޽�����ã�����������
	var rtn = CmdShell.CurrentUserEvalJs(Str);   //ͨ���м�����д�ӡ���� 
	return;

}

///����
function ExpConsListOld(){	
	var xlsExcel = new ActiveXObject("Excel.Application");
 	var xlsBook = xlsExcel.Workbooks.Add() 
	var objSheet = xlsBook.ActiveSheet; 
	var CstStartDate = $HUI.datebox("#CstStartDate").getValue();  /// ��ʼ����
	var CstEndDate = $HUI.datebox("#CstEndDate").getValue();      /// ��������
	xlsExcel.Visible = true; 
	xlsExcel.Range(objSheet.Cells(1,1),objSheet.Cells(1,16)).MergeCells = true;
	objSheet.cells(1,1).Font.Bold = true;
	objSheet.cells(1,1).Font.Size =24;
	objSheet.cells(1,1).HorizontalAlignment = -4108;
	objSheet.cells(1,1)="������ϸͳ��("+CstStartDate+"��"+CstEndDate+")";
	var strjLen=$HUI.datagrid("#dgCstDetList").getData().rows.length;
	objSheet.cells(2,1)="���";
	objSheet.cells(2,2)="��������";
	objSheet.cells(2,3)="�������";
	objSheet.cells(2,4)="����ҽ��";
   	objSheet.cells(2,5)="��������";
    objSheet.cells(2,6)="����ʱ��";
    objSheet.cells(2,7)="��������";
    objSheet.cells(2,8)="����ʱ��";
    objSheet.cells(2,9)="����ժҪ";
	objSheet.cells(2,10)="�������ɼ�Ҫ��";
    objSheet.cells(2,11)="״̬";
    objSheet.cells(2,12)="�������";
    objSheet.cells(2,13)="����ʱ��";
    objSheet.cells(2,14)="���ʱ��";
	objSheet.cells(2,15)="ȷ��ҽ��";
	objSheet.cells(2,16)="ȷ��ʱ��";
	for (i=1;i<=strjLen;i++)
     { 	
	    objSheet.cells(i+2,1)=i;
	    objSheet.cells(i+2,2)=$HUI.datagrid("#dgCstDetList").getData().rows[i-1].CstType;
	    objSheet.cells(i+2,3)=$HUI.datagrid("#dgCstDetList").getData().rows[i-1].CstRLoc;
	    objSheet.cells(i+2,4)=$HUI.datagrid("#dgCstDetList").getData().rows[i-1].CstRUser;
	    objSheet.cells(i+2,5)=$HUI.datagrid("#dgCstDetList").getData().rows[i-1].CstRDate;
	    objSheet.cells(i+2,6)=$HUI.datagrid("#dgCstDetList").getData().rows[i-1].CstNTime;
	    objSheet.cells(i+2,7)=$HUI.datagrid("#dgCstDetList").getData().rows[i-1].CstNDate;
	    objSheet.cells(i+2,8)=$HUI.datagrid("#dgCstDetList").getData().rows[i-1].CstNTime;
	    objSheet.cells(i+2,9)=$HUI.datagrid("#dgCstDetList").getData().rows[i-1].CstTrePro;
	    objSheet.cells(i+2,10)=$HUI.datagrid("#dgCstDetList").getData().rows[i-1].CstPurpose;
	    objSheet.cells(i+2,11)=$HUI.datagrid("#dgCstDetList").getData().rows[i-1].CstStat;
	    objSheet.cells(i+2,12)=$HUI.datagrid("#dgCstDetList").getData().rows[i-1].CsLocDesc;
		objSheet.cells(i+2,13)=$HUI.datagrid("#dgCstDetList").getData().rows[i-1].CstECLArriTime;
		objSheet.cells(i+2,14)=$HUI.datagrid("#dgCstDetList").getData().rows[i-1].CstLogOverTime;
		objSheet.cells(i+2,15)=$HUI.datagrid("#dgCstDetList").getData().rows[i-1].CstECLUser;
		objSheet.cells(i+2,16)=$HUI.datagrid("#dgCstDetList").getData().rows[i-1].CstECLTime;
 	 }
	
	 gridlist(objSheet,2,strjLen+2,1,16)
 	 objSheet.Columns.AutoFit; 
	 xlsExcel.ActiveWindow.Zoom = 75 
	 xlsExcel.UserControl = true;  //����Ҫ,����ʡ��,��Ȼ������� ��˼��excel�����û����� 

	 xlsExcel=null; 
     xlsBook=null; 
     objSheet=null; 

}

function gridlist(objSheet,row1,row2,c1,c2)
{
	var ret="";
	ret=ret+"objSheet.Range(objSheet.Cells("+row1+","+c1+"),objSheet.Cells("+row2+","+c2+")).Borders(1).LineStyle=1;";
	ret=ret+"objSheet.Range(objSheet.Cells("+row1+","+c1+"),objSheet.Cells("+row2+","+c2+")).Borders(1).Weight=2;";
	ret=ret+"objSheet.Range(objSheet.Cells("+row1+","+c1+"),objSheet.Cells("+row2+","+c2+")).Borders(2).LineStyle=1;";
	ret=ret+"objSheet.Range(objSheet.Cells("+row1+","+c1+"),objSheet.Cells("+row2+","+c2+")).Borders(2).Weight=2;"
	ret=ret+"objSheet.Range(objSheet.Cells("+row1+","+c1+"),objSheet.Cells("+row2+","+c2+")).Borders(3).LineStyle=1;";
	ret=ret+"objSheet.Range(objSheet.Cells("+row1+","+c1+"),objSheet.Cells("+row2+","+c2+")).Borders(3).Weight=2;";
	ret=ret+"objSheet.Range(objSheet.Cells("+row1+","+c1+"),objSheet.Cells("+row2+","+c2+")).Borders(4).LineStyle=1;"; 
	ret=ret+"objSheet.Range(objSheet.Cells("+row1+","+c1+"),objSheet.Cells("+row2+","+c2+")).Borders(4).Weight=2;";
	return ret;
}

function gridlistOld(objSheet,row1,row2,c1,c2)
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

/// �����Ŀ����ʾ��
function BindTips(){
	
	var html='<div id="tip" style="word-break:break-all;border-radius:3px; display:none; border:1px solid #000; padding:10px; margin:5px; position: absolute; background-color: #000;color:#FFF;"></div>';
	$('body').append(html);
	
	/// ����뿪
	$('td[field="CstTrePro"],td[field="CstPurpose"],td[field="CsOpinion"]').on({
		'mouseleave':function(){
			$("#tip").css({display : 'none'});
		}
	})
	/// ����ƶ�
	$('td[field="CstTrePro"],td[field="CstPurpose"],td[field="CsOpinion"]').on({
		'mousemove':function(){
			
			var tleft=(event.clientX + 10);
			if ($(this).text().length <= 20){
				return;
			}
			if ( window.screen.availWidth - tleft < 600){ tleft = tleft - 600;}
			/// tip ��ʾ��λ�ú������趨
			$("#tip").css({
				display : 'block',
				top : (event.clientY + 10) + 'px',   
				left : tleft + 'px',
				//right:10+'px',
				//bottom:5+'px',
				'z-index' : 9999,
				opacity: 0.8
			}).text($(this).text());
		}
	})
}

/// JQuery ��ʼ��ҳ��
$(function(){ initPageDefault(); })