/*
ģ��:����ҩ��
��ģ��:����ҩ��-ҩ��ͳ��-��ҩҩƷ����
createdate:2016-05-27
creator:dinghongying
modified by yunhaibao20160603
*/
var commonOutPhaUrl = "DHCST.OUTPHA.ACTION.csp";
var url = "dhcpha.outpha.returntotal.action.csp";
var gLocId=session['LOGON.CTLOCID'];
var gUserId=session['LOGON.USERID'];
var gGroupId=session['LOGON.GROUPID']; 
var combooption = {
	valueField :'RowId',    
	textField :'Desc',
	panelWidth:'200'
} 
$(function(){
	var depLocCombo=new ListCombobox("depLoc",commonOutPhaUrl+'?action=GetCtLocDs','',combooption);
	depLocCombo.init(); //��ʼ������	
	InitRefundSumList();	
	$('#BRetrieve').bind('click', Query);//�����ѯ
	$('#BPrint').bind('click',BPrintHandler);//�����ӡ	
	$('#BExport').bind('click', function(){
		ExportAllToExcel("RefundSumdg")
	});//�������
	$('#BReset').bind('click', InitCondition);//������
	InitCondition();
});
function InitCondition(){
	$("#startDate").datebox("setValue", formatDate(0)); 
	$("#endDate").datebox("setValue", formatDate(0)); 
	$("#depLoc").combobox("setValue","");  
	$('#RefundSumdg').datagrid('loadData',{total:0,rows:[]});
	$('#RefundSumdg').datagrid('options').queryParams.params = ""; 
}
//��ʼ����ҩ�����б�
function InitRefundSumList(){
	//����columns
	var columnspat=[[
        {field:'TPhDesc',title:'ҩƷ����',width:300},
        {field:'TPhUom',title:'��λ',align:'center',width:150},    
        {field:'TRetQty',title:'��ҩ����',align:'right',width:150,sortable:true},
        {field:'TRetMoney',title:'��ҩ���',align:'right',width:150,sortable:true}
         ]];  
	
   //����datagrid	
   $('#RefundSumdg').datagrid({    
      url:'',
      fit:true,
	  border:false,
	  singleSelect:true,
	  rownumbers:true,
      columns:columnspat,
      pageSize:100,  // ÿҳ��ʾ�ļ�¼����
	  pageList:[100,300,500,1000],   // ��������ÿҳ��¼�������б�
	  singleSelect:true,
	  loadMsg: '���ڼ�����Ϣ...',
	  pagination:true
	 
   });
  
}


///��ҩҩƷ���ܲ�ѯ
function Query(){	
	var startDate=$('#startDate').datebox('getValue');
	if (startDate==""){
		$.messager.alert('������ʾ',"�����뿪ʼ����!");
		return;
	}
	var endDate=$('#endDate').datebox('getValue');
	if (endDate==""){
		$.messager.alert('������ʾ',"�������ֹ����!");
		return;
	}
	var depLoc=$('#depLoc').combobox("getValue");
	if ($.trim($('#depLoc').combobox("getText"))==""){
		depLoc=""
	}
	var ldoctor=""
	var params=gLocId+"^"+startDate+"^"+endDate+"^"+depLoc+"^"+ldoctor
	$('#RefundSumdg').datagrid({
     	url:url+'?action=QueryReturnTotal',
     	queryParams:{
			params:params}
	});
	
}
function BPrintHandler() 
{
	if ($('#RefundSumdg').datagrid('getData').rows.length == 0) {//��ȡ���������������
		$.messager.alert("��ʾ","ҳ��û������","info");
		return ;
	}
	var RefundSumdgOption=$("#RefundSumdg").datagrid("options")
	var RefundSumdgparams=RefundSumdgOption.queryParams.params;
	var sortorder=RefundSumdgOption.sortOrder;
	var sortname=RefundSumdgOption.sortName;
	var RefundSumdgUrl=RefundSumdgOption.url;
	$.ajax({
		type: "GET",
		url: RefundSumdgUrl+"&page=1&rows=9999&params="+RefundSumdgparams+"&sort="+sortname+"&order="+sortorder,
		async:false,
		dataType: "json",
		success: function(returndata){
			PrintRefund(returndata);
		}
	});
}
function PrintRefund(returndata){
	var path=tkMakeServerCall("web.DHCDocConfig","GetPath");//��ȡģ��·��
	var tmpjsonObject = JSON.stringify(returndata.rows);
    var colarray = typeof tmpjsonObject != 'object' ? JSON.parse(tmpjsonObject) : tmpjsonObject;
    var str = '';
    var rows=colarray.length
    var startdate=$('#startDate').datebox('getValue');
    var enddate=$('#endDate').datebox('getValue');
	var xlApp,obook,osheet,xlsheet,xlBook
	var paymoney
	var Template
	Template = path + "yftyhz.xls"
	xlApp = new ActiveXObject("Excel.Application");
	xlBook = xlApp.Workbooks.Add(Template);
	xlsheet = xlBook.ActiveSheet
	xlsheet.cells(2,2).value =startdate  + enddate;
	for (var i = 0; i < colarray.length; i++) {	
		
	    xlsheet.cells(4 + i, 1).value = colarray[i]["TPhDesc"];
		xlsheet.cells(4 + i, 2).value = colarray[i]["TPhUom"];
		xlsheet.cells(4 + i, 3).value = colarray[i]["TRetQty"];
		xlsheet.cells(4 + i, 4).value = colarray[i]["TRetMoney"];	
    }			
	xlsheet.printout
	xlBook.Close(savechanges = false);
	xlApp = null;
	xlsheet = null
}



