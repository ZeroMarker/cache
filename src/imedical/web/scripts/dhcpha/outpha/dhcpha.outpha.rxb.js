/*
ģ��:����ҩ��
��ģ��:����ҩ��-ҩ��ͳ��-������ͳ��
createdate:2016-06-28
creator:yunhaibao
*/
var commonOutPhaUrl = "DHCST.OUTPHA.ACTION.csp";
var url = "dhcpha.outpha.rxb.action.csp";
var gLocId=session['LOGON.CTLOCID'];
var gLocDesc=session['LOGON.CTLOCDESC'];
var gUserId=session['LOGON.USERID'];
var gGroupId=session['LOGON.GROUPID'];
var gInciRowId=""; 
var gNewCatId="";
var combooption = {
	valueField :'RowId',    
	textField :'Desc',
	panelWidth:'150'
} 
$(function(){	
	InitRXBGrid();	
	var fyUserCombo=new ListCombobox("fyUser",commonOutPhaUrl+'?action=GetPYUserList&gLocId='+gLocId+'&gUserId='+gUserId,'',combooption);
	fyUserCombo.init(); //��ʼ����ҩ��
	var manaGroupCombo=new ListCombobox("manaGroup",commonOutPhaUrl+'?action=GetManaGroupDs&gLocId='+gLocId,'',combooption);
	manaGroupCombo.init(); //��ʼ��������
	var stkCatCombo=new ListCombobox("stkCat",commonOutPhaUrl+'?action=GetStkCatDs','',combooption);
	stkCatCombo.init(); //��ʼ��������
	$('#inciDesc').bind('keypress',function(event){
	 	if(event.keyCode == "13")    
	 	{
		 var input=$.trim($("#inciDesc").val());
		 if (input!="")
		 {
			var mydiv = new IncItmDivWindow($("#inciDesc"), input,getDrugList);
            mydiv.init();
		 }else{
			inciRowId="";
		 }	
	 }
	});
	$('#phcCatLink').bind('click',function(event){
		var retstr=showModalDialog('dhcst.phccatall.csp?gNewCatId='+gNewCatId,'','dialogHeight:600px;dialogWidth:1000px;center:yes;help:no;resizable:no;status:no;scroll:no;menubar=no;toolbar=no;location=no')
		if (!(retstr)){
			return;
		}   
		if (retstr==""){
			return;
		}
		var phacstr=retstr.split("^")
		$("#phcCat").val(phacstr[0]);
		gNewCatId=phacstr[1];
	});
	$('#BReset').bind('click', InitConditon);//������
	$('#BRetrieve').bind('click', BRetrieveHandler);//���ͳ��
	$('#BPrint').bind('click', BPrintHandler);//�����ӡ
	$('#BExport').bind('click', function(){
		ExportAllToExcel("rxbgrid")
	});
	InitConditon();
});



//��ʼ��������grid
function InitRXBGrid(){
	//����columns
	var columns=[[
        {field:'TPhCode',title:'ҩƷ����',width:80,sortable:true},
        {field:'TPhDesc',title:'ҩƷ����',width:250,sortable:true}, 
        {field:'TOutQty',title:'��������',width:100,align:'right',sortable:true}, 
        {field:'TPhUom',title:'��λ',width:100,sortable:true}, 
        {field:'TPrice',title:'�ۼ�',width:75,align:'right',sortable:true}, 
        {field:'TOutMoney',title:'�������',width:100,align:'right',sortable:true},
        {field:'TOutRp',title:'����',width:75,align:'right',sortable:true}, 
        {field:'TOutRpAmt',title:'���۽��',width:100,align:'right',sortable:true}, 
        {field:'TOutStkQty',title:'�������',width:100,align:'right',sortable:true},         
        {field:'TFactory',title:'��������',width:200,sortable:true}   
    ]];  
	
   //����datagrid	
   $('#rxbgrid').datagrid({    
      url:'',
      fit:true,
	  border:false,
	  singleSelect:true,
	  rownumbers:true,
      columns:columns,
	  singleSelect:true,
	  loadMsg: '���ڼ�����Ϣ...',
	  nowrap:false,
	  pageSize:100,  // ÿҳ��ʾ�ļ�¼����
	  pageList:[100,300,500,1000],   // ��������ÿҳ��¼�������б�
	  pagination:true
	 
   });
  
}


///��ʼ������
function InitConditon()
{
	gNewCatId="";
	gInciRowId="";
	$("#startDate").datebox("setValue",formatDate(0));  //Init��ʼ����
	$("#endDate").datebox("setValue", formatDate(0));  //Init��������
	$('#startTime').timespinner('setValue',"");
	$('#endTime').timespinner('setValue',"");
	$('#inciDesc').val("");
	$('#phcCat').val("");
	$('#inciSp').val("");
	$('#fyUser').combobox("setValue","");
	$('#stkCat').combobox("setValue","");
	$('#manaGroup').combobox("setValue","");
	$('#chkMana').attr("checked",false);
	$('#rxbgrid').datagrid('loadData',{total:0,rows:[]}); 
	$('#rxbgrid').datagrid('options').queryParams.params = ""; 
}
function getDrugList(returndata){
	if (returndata["Inci"]>0){
		$("#inciDesc").val(returndata["InciDesc"]);
		gInciRowId=returndata["Inci"];
	}
	else{
		$("#inciDesc").val("");
		gInciRowId="";
	}
}
///ҩ��������ͳ��
function BRetrieveHandler()
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
	if ($.trim($("#inciDesc").val())==""){
		gInciRowId="";
	}
	if ($.trim($("#phcCat").val())==""){
		gNewCatId="";
	}
	var stkCatId=$("#stkCat").combobox("getValue");
	if (($.trim($("#stkCat").combobox("getText"))=="")||(stkCatId==undefined)){
		stkCatId="";
	}
	var fyUserId=$("#fyUser").combobox("getValue");
	if (($.trim($("#fyUser").combobox("getText"))=="")||(fyUserId==undefined)){
		fyUserId="";
	}
	var manaGroupId=$("#manaGroup").combobox("getValue");
	if (($.trim($("#manaGroup").combobox("getText"))=="")||(manaGroupId==undefined)){
		manaGroupId="";
	}
	var price=$("#inciSp").val();
	var chkmana="N"
	if ($('#chkMana').is(':checked')){
		chkmana="Y"
	}
	var params=gLocId+"^"+startDate+"^"+endDate+"^"+fyUserId+"^"+gInciRowId+
		       "^"+stkCatId+"^"+price+"^"+gNewCatId+"^"+chkmana+"^"+manaGroupId+
		       "^"+gUserId+"^"+""+"^"+startTime+"^"+endTime;
	$('#rxbgrid').datagrid({
     	url:url+'?action=QueryGYFRXB',
     	queryParams:{
			params:params}
	});
	
}

function BPrintHandler()
{
	
	if ($('#rxbgrid').datagrid('getData').rows.length == 0) //��ȡ���������������
	{
		$.messager.alert("��ʾ","ҳ��û������","info");
		return ;
	}
	var rxbgridOption=$("#rxbgrid").datagrid("options")
	var rxbgridParams=rxbgridOption.queryParams.params;
	var rxbgridUrl=rxbgridOption.url;
	$.ajax({
		type: "GET",
		url: rxbgridUrl+"&page=1&rows=9999&params="+rxbgridParams,
		async:false,
		dataType: "json",
		success: function(returndata){
			PrintRXB(returndata);
		}
	});
}
	
function PrintRXB(returndata){
	
	var path=tkMakeServerCall("web.DHCDocConfig","GetPath");//��ȡģ��·��
	var locdesc=tkMakeServerCall("web.DHCOutPhRetrieve","GetLocDesc",gLocId)
	var tmpjsonObject = JSON.stringify(returndata.rows);
    var colarray = typeof tmpjsonObject != 'object' ? JSON.parse(tmpjsonObject) : tmpjsonObject;
    var rows=colarray.length
	var datestart = $('#startDate').datebox('getValue');
	var dateend = $('#endDate').datebox('getValue');
	var xlApp,obook,osheet,xlsheet,xlBook
	var Template
	Template = path + "yfrxb.xls"
	xlApp = new ActiveXObject("Excel.Application");
	xlBook = xlApp.Workbooks.Add(Template);
	xlsheet = xlBook.ActiveSheet
	xlsheet.cells(1,1).value = locdesc+"������"
	xlsheet.cells(3,1).value = datestart + "��" +dateend
	for (i = 0; i < rows; i++){
		xlsheet.cells(5 + i, 1).value = colarray[i].TPhCode;
		xlsheet.cells(5 + i, 2).value = colarray[i].TPhDesc;
		xlsheet.cells(5 + i, 3).value = colarray[i].TPhUom;
		xlsheet.cells(5 + i, 4).value = colarray[i].TPrice;
		xlsheet.cells(5 + i, 5).value = colarray[i].TOutQty;
		xlsheet.cells(5 + i, 6).value = colarray[i].TOutMoney;
    }
	xlsheet.printout
    xlBook.Close(savechanges = false);
    xlApp = null;
    xlsheet = null
}

