/*
ģ��:����ҩ��
��ģ��:����ҩ��-ҩ��ͳ��-����ͳ��
createdate:2016-06-30
creator:dinghongying
*/
var commonOutPhaUrl ="DHCST.OUTPHA.ACTION.csp";
var thisurl = "dhcpha.outpha.prescnotj.action.csp";
var gLocId=session['LOGON.CTLOCID'];
var gUserId=session['LOGON.USERID'];
var gGroupId=session['LOGON.GROUPID'];
var gNewCatId="";
var combooption = {
	valueField :'RowId',    
	textField :'Desc',
	panelWidth:'150'
} 
$(function(){
	InitPrescnoTJList();
	var stkCatCombo=new ListCombobox("stkCat",commonOutPhaUrl+'?action=GetStkCatDs','',combooption);
	stkCatCombo.init(); //��ʼ��������
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
	$('#BReset').on('click', Reset);//������
	$('#BRetrieve').on('click', Query);//���ͳ��
	$('#BPrint').on('click', Print);//�����ӡ
	$('#BExport').on('click', function(){  //�������
		ExportAllToExcel("prescnotjdg")
	});
	$('#prescnotjdg').datagrid('loadData',{total:0,rows:[]});
	$('#prescnotjdg').datagrid('options').queryParams.params = ""; 
	
});
//��ʼ������ͳ���б�
function InitPrescnoTJList(){
	//����columns
	var columns=[[
	    {field:'TPrescType',title:'��������',width:100},
	    {field:'TPrescNum',title:'��������',width:100,align:'right'},
	    {field:'TPrescTotal',title:'��������',width:100,align:'right'},
	    {field:'TPrescBL',title:'��������(%)',width:80,align:'right'},
	    {field:'TPrescMax',title:'��ߴ���',width:100,hidden:true},
	    {field:'TPrescMin',title:'��ʹ���',width:100,hidden:true},
	    {field:'TPrescMaxPmi',title:'��߷��ǼǺ�',width:100,align:'center'},
	    {field:'TPrescMinPmi',title:'��ͷ��ǼǺ�',width:100,align:'center'},
	    {field:'TPrescMaxMoney',title:'��߷����',width:80,align:'right'},
	    {field:'TPrescMinMoney',title:'��ͷ����',width:80,align:'right'},
	    {field:'TPrescMoney',title:'�ϼƽ��',width:100,align:'right'},
	    {field:'TPrescPhNum',title:'Ʒ����',width:80,align:'right'},
	    {field:'TCYFS',title:'��ҩ����',width:80,align:'right'},
	    {field:'TJYFS',title:'��ҩ����',width:80,align:'right'},
	    {field:'TJYCF',title:'��ҩ����',width:80,align:'right'}
	]];  
    //����datagrid	
    $('#prescnotjdg').datagrid({    
        url:thisurl+'?action=GetPrescnoTJList',
        fit:true,
	    border:false,
	    singleSelect:true,
	    rownumbers:true,
        columns:columns,
        pageSize:30,  // ÿҳ��ʾ�ļ�¼����
	    pageList:[30,50,100],   // ��������ÿҳ��¼�������б�
	    singleSelect:true,
	    loadMsg: '���ڼ�����Ϣ...',
	    pagination:true
    });
}
///ҩ������ͳ�����
function Reset(){
	gNewCatId="";
	$("#startDate").datebox("setValue", formatDate(0));  //Init��ʼ����
	$("#endDate").datebox("setValue", formatDate(0));  //Init��������
	$('#startTime').timespinner('setValue',"");
	$('#endTime').timespinner('setValue',"");
	$("#phNum").val("");  //InitҩƷ����
	$("#stkCat").combobox("setValue", "");  //Init������
	$("#phcCat").val("");  //Initҩ�����
	$('#chkOP').attr("checked",false);
	$('#chkEM').attr("checked",false);
	$('#prescnotjdg').datagrid('loadData',{total:0,rows:[]}); 
	$('#prescnotjdg').datagrid('options').queryParams.params = ""; 

}
///ҩ������ͳ�Ʋ�ѯ
function Query(){
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
	var prescType=""; //û����
	if ($.trim($("#phcCat").val())==""){
		gNewCatId="";
	}
	var stkCatId=$("#stkCat").combobox("getValue");
	if (($.trim($("#stkCat").combobox("getText"))=="")||(stkCatId==undefined)){
		stkCatId="";
	}
	var OPFlag=""
	if ($('#chkOP').is(':checked')){
		OPFlag="Y"
	}
	var EMFlag=""
	if ($('#chkEM').is(':checked')){
		EMFlag="Y"
	}
	if ((OPFlag=="")&&(EMFlag=="")){
		$.messager.alert('��ʾ',"�빴ѡ��Ҫͳ�Ƶ��ż��ﴦ������!","info");
		return;
	}
	var phNum=$('#phNum').val();
	var params=startDate+"^"+endDate+"^"+startTime+"^"+endTime+"^"+gLocId+"^"+prescType+"^"+phNum+"^"+stkCatId+"^"+gNewCatId+"^"+OPFlag+"^"+EMFlag
	$('#prescnotjdg').datagrid({
		url:thisurl+'?action=GetPrescnoTJList',
     	queryParams:{
			params:params}
	});	
}

function Print(){	
	if($('#prescnotjdg').datagrid('getData').rows.length == 0) //��ȡ���������������
	{
		alert("ҳ��û������");
		return ;
	}
	var PrescNotjdgOption=$("#prescnotjdg").datagrid("options")
	var PrescNotjdgparams=PrescNotjdgOption.queryParams.params;
	var PrescNotjdgUrl=PrescNotjdgOption.url;
	$.ajax({
		type: "GET",
		url: PrescNotjdgUrl+"&page=1&rows=9999&params="+PrescNotjdgparams,
		async:false,
		dataType: "json",
		success: function(prescnotjdata){
			PrintPrescNotj(prescnotjdata);
		}
	});
}
	
function PrintPrescNotj(prescnotjdata){
	var path=tkMakeServerCall("web.DHCDocConfig","GetPath");//��ȡģ��·��
	var tmpjsonObject = JSON.stringify(prescnotjdata.rows);
    var colarray = typeof tmpjsonObject != 'object' ? JSON.parse(tmpjsonObject) : tmpjsonObject;
    var rows=colarray.length
	var datestart = $('#startDate').datebox('getValue');
	var dateend = $('#endDate').datebox('getValue');
	var xlApp,obook,osheet,xlsheet,xlBook
	var Template
	Template = path + "yfcftj.xls"
	xlApp = new ActiveXObject("Excel.Application");
	xlBook = xlApp.Workbooks.Add(Template);
	xlsheet = xlBook.ActiveSheet
	xlsheet.cells(2,1).value = " ͳ������:"+datestart + "��" +dateend
	var colnum=13;
	xlsheet.Range(xlsheet.Cells(3, 1), xlsheet.Cells(3+rows, colnum)).Borders(1).LineStyle=1 ;
	xlsheet.Range(xlsheet.Cells(3, 1), xlsheet.Cells(3+rows, colnum)).Borders(2).LineStyle=1 ;
	xlsheet.Range(xlsheet.Cells(3, 1), xlsheet.Cells(3+rows, colnum)).Borders(3).LineStyle=1 ;
	xlsheet.Range(xlsheet.Cells(3, 1), xlsheet.Cells(3+rows, colnum)).Borders(4).LineStyle=1 ;
	for (i = 0; i < rows; i++) {
		xlsheet.cells(4 + i, 1).value = colarray[i].TPrescType
		xlsheet.cells(4 + i, 2).value = colarray[i].TPrescNum
		xlsheet.cells(4 + i, 3).value = colarray[i].TPrescTotal
		xlsheet.cells(4 + i, 4).value = colarray[i].TPrescBL
		xlsheet.cells(4 + i, 5).value = colarray[i].TPrescMaxPmi
		xlsheet.cells(4 + i, 6).value = colarray[i].TPrescMinPmi
		xlsheet.cells(4 + i, 7).value = colarray[i].TPrescMaxMoney
		xlsheet.cells(4 + i, 8).value = colarray[i].TPrescMinMoney
		xlsheet.cells(4 + i, 9).value = colarray[i].TPrescMoney
		xlsheet.cells(4 + i, 10).value = colarray[i].TPrescPhNum
		xlsheet.cells(4 + i, 11).value = colarray[i].TCYFS
		xlsheet.cells(4 + i, 12).value = colarray[i].TJYFS
		xlsheet.cells(4 + i, 13).value = colarray[i].TJYCF
    }
	xlsheet.printout
    xlBook.Close(savechanges = false);
    xlApp = null;
    xlsheet = null
}