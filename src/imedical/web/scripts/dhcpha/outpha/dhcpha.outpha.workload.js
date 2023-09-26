/*
ģ��:����ҩ��
��ģ��:����ҩ��-ҩ��ͳ��-������ͳ��
createdate:2016-06-06
creator:dinghongying
modified by yunhaibao20160612
*/
var url = "dhcpha.outpha.workload.action.csp";
var gLocId=session['LOGON.CTLOCID'];
var gUserId=session['LOGON.USERID'];
var gGroupId=session['LOGON.GROUPID']; 
$(function(){	
	InitWorkLoadList();	
	$('#BReset').bind('click', Reset);//������
	$('#BRetrieve').bind('click', Query);//���ͳ��
	$('#BPrint').bind('click', PrintHandler);//�����ӡ
	$('#BExport').bind('click', function(){
		ExportAllToExcel("workloaddg")
	});
	Reset();
});



//��ʼ��������ͳ���б�
function InitWorkLoadList(){
	//����columns
	var columns=[[
        {field:'TPhName',title:'ҩ����Ա',width:100},
        {field:'TPYRC',title:'��ҩ����',width:100,align:'right',sortable:true},    
        {field:'TFYRC',title:'��ҩ����',width:100,align:'right',sortable:true}, 
        {field:'TPYJE',title:'��ҩ���',width:100,align:'right',sortable:true}, 
        {field:'TFYJE',title:'��ҩ���',width:100,align:'right',sortable:true},
        {field:'TPYL',title:'��ҩ��',width:100,align:'right',sortable:true},
        {field:'TFYL',title:'��ҩ��',width:100,align:'right',sortable:true},
        {field:'TRetPresc',title:'��ҩ����',width:100,align:'right',sortable:true}, 
        {field:'TRetMoney',title:'��ҩ���',width:100,align:'right',sortable:true},
        {field:'TRetYL',title:'��ҩ��',width:100,align:'right',sortable:true},
        {field:'TPyFS',title:'��ҩ����',width:100,hidden:true,align:'right',sortable:true}, 
        {field:'TFyFS',title:'��ҩ����',width:100,align:'right',sortable:true}, 
        {field:'TTyFS',title:'��ҩ����',width:100,align:'right',sortable:true}, 
        {field:'TJYFS',title:'��ҩ����',width:100,hidden:true,sortable:true},
        {field:'TJYCF',title:'��ҩ����',width:100,hidden:true,sortable:true}
         ]];  
	
   //����datagrid	
   $('#workloaddg').datagrid({    
      url:'',
      fit:true,
	  border:false,
	  singleSelect:true,
	  rownumbers:true,
      columns:columns,
	  singleSelect:true,
	  loadMsg: '���ڼ�����Ϣ...'
	 
   });
  
}


///ҩ��������ͳ�����
function Reset()
{
	$("#startDate").datebox("setValue",formatDate(0));  //Init��ʼ����
	$("#endDate").datebox("setValue", formatDate(0));  //Init��������
	$('#startTime').timespinner('setValue',"");
	$('#endTime').timespinner('setValue',"");
	$('#workloaddg').datagrid('loadData',{total:0,rows:[]}); 
}

///ҩ��������ͳ�Ʋ�ѯ
function Query()
{
	var startDate=$('#startDate').datebox('getValue');
	if (startDate==""){
		$.messager.alert('��ʾ',"�����뿪ʼ����!","info");
		return;
	}
	var endDate=$('#endDate').datebox('getValue');
	if (endDate==""){
		$.messager.alert('��ʾ',"�������ֹ����!","info");
		return;
	}
	var startTime=$('#startTime').timespinner('getValue');
	var endTime=$('#endTime').timespinner('getValue');
	var params=gLocId+"^"+startDate+"^"+endDate+"^"+startTime+"^"+endTime;
	$('#workloaddg').datagrid({
     	url:url+'?action=GetWorkLoadList',
     	queryParams:{
			params:params}
	});
	
}

function PrintHandler()
{
	
	if ($('#workloaddg').datagrid('getData').rows.length == 0) //��ȡ���������������
	{
		$.messager.alert("��ʾ","ҳ��û������","info");
		return ;
	}
	var WorkLoaddgOption=$("#workloaddg").datagrid("options")
	var WorkLoaddgparams=WorkLoaddgOption.queryParams.params;
	var WorkLoaddgUrl=WorkLoaddgOption.url;
	$.ajax({
		type: "GET",
		url: WorkLoaddgUrl+"&page=1&rows=9999&params="+WorkLoaddgparams,
		async:false,
		dataType: "json",
		success: function(workloaddata){
			PrintWorkLoad(workloaddata);
		}
	});
}
	
function PrintWorkLoad(workloaddata){
	
	var path=tkMakeServerCall("web.DHCDocConfig","GetPath");//��ȡģ��·��
	var tmpjsonObject = JSON.stringify(workloaddata.rows);
    var colarray = typeof tmpjsonObject != 'object' ? JSON.parse(tmpjsonObject) : tmpjsonObject;
    var rows=colarray.length
	var datestart = $('#startDate').datebox('getValue');
	var dateend = $('#endDate').datebox('getValue');
	var xlApp,obook,osheet,xlsheet,xlBook
	var Template
	Template = path + "YFGZL.XLS"
	//alert(Template);
	xlApp = new ActiveXObject("Excel.Application");
	xlBook = xlApp.Workbooks.Add(Template);
	xlsheet = xlBook.ActiveSheet
	xlsheet.cells(2,6).value = datestart + "��" +dateend
	for (i = 0; i < rows; i++) 
		{
			xlsheet.cells(4 + i, 1).value = colarray[i].TPhName
			xlsheet.cells(4 + i, 2).value = colarray[i].TPYRC
			xlsheet.cells(4 + i, 3).value = colarray[i].TFYRC
			xlsheet.cells(4 + i, 4).value = colarray[i].TPYJE
			xlsheet.cells(4 + i, 5).value = colarray[i].TFYJE
			xlsheet.cells(4 + i, 6).value = colarray[i].TPYL
			xlsheet.cells(4 + i, 7).value = colarray[i].TFYL
			xlsheet.cells(4 + i, 8).value = colarray[i].TRetPresc
			xlsheet.cells(4 + i, 9).value = colarray[i].TRetMoney
			xlsheet.cells(4 + i, 10).value = colarray[i].TRetYL
			//xlsheet.cells(4 + i, 11).value = colarray[i].TPyFS
			xlsheet.cells(4 + i, 12).value = colarray[i].TFyFS
			xlsheet.cells(4 + i, 13).value = colarray[i].TTyFS
			xlsheet.cells(4 + i, 14).value = colarray[i].TJYFS
			xlsheet.cells(4 + i, 15).value = colarray[i].TJYCF
	    }
		xlsheet.printout
	    xlBook.Close(savechanges = false);
	    xlApp = null;
	    xlsheet = null
}

