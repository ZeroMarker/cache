/*
ģ��:����ҩ��
��ģ��:����ҩ��-�ճ�ҵ��-����ҩ��������ѯ
createdate:2016-07-05
creator:dinghongying
*/
var commonOutPhaUrl ="DHCST.OUTPHA.ACTION.csp";
var commonInPhaUrl ="DHCST.INPHA.ACTION.csp";
var thisurl = "dhcpha.outpha.supplyquery.action.csp";
var gLocId=session['LOGON.CTLOCID'];
var gUserId=session['LOGON.USERID'];
var gGroupId=session['LOGON.GROUPID'];
var combooption = {
	valueField :'RowId',    
	textField :'Desc',
	panelWidth:'150'
} 
$(function(){
	InitSupplyQueryList();
	InitSupplyQueryTotalList();
	InitPhaLoc();
	//var wardLocCombo=new ListCombobox("wardLoc",commonInPhaUrl+'?action=GetWardLocDs','',combooption);
	//wardLocCombo.init(); //��ʼ������
    var basicLocCombo=new ListCombobox("basicLoc",commonOutPhaUrl+'?action=GetBasicLocList','',combooption);
	basicLocCombo.init(); //��ʼ����������
	
	$('#BClear').on('click', Reset);//������
	$('#BFind').on('click', Query);//���ͳ��
	$('#BPrint').on('click', Print)  //�����ӡ
		
	$('#supplyquerydg').datagrid('loadData',{total:0,rows:[]});
	$('#supplyquerydg').datagrid('options').queryParams.params = "";
	$('#supplyquerytotaldg').datagrid('loadData',{total:0,rows:[]});
	$('#supplyquerytotaldg').datagrid('options').queryParams.params = ""; 
	
});
function InitPhaLoc(){
	$('#phaLoc').combobox({  
		width:150,
		panelWidth: 150,
		url:commonOutPhaUrl+'?action=GetUserAllLocDs&gUserId='+gUserId,  
		valueField:'RowId',  
		textField:'Desc',
		onLoadSuccess: function(){
			var data = $('#phaLoc').combobox('getData');
            if (data.length > 0) {
                  $('#phaLoc').combobox('select', gLocId);
              }            
	    },
	    onSelect:function(){  
		}
	});
}
//��ʼ������ҩ�������б�
function InitSupplyQueryList(){
	//����columns
	var columns=[[
	    {field:'Tward',title:'����',width:60,align:'left',hidden:true},
	    {field:'Tdocloc',title:'��������',width:150,align:'left'},
	    {field:'Tsuppdate',title:'����',width:80,align:'right'},
	    {field:'Tsupptime',title:'ʱ��',width:70,align:'right'},
	    {field:'Tusername',title:'������',width:100,align:'left'},
	    {field:'Tsuppno',title:'����',width:150},
	    {field:'Tsupp',title:'',width:60,align:'center',hidden:true},
	    {field:'Tpid',title:'pid',width:60,align:'center',hidden:true}
	    //{field:'TSelect',title:'ѡ��',width:60,align:'center'}
	]];  
    //����datagrid	
    $('#supplyquerydg').datagrid({    
        url:thisurl+'?action=GetSupplyQueryList',
        fit:true,
	    border:false,
	    singleSelect:true,
	    rownumbers:true,
        columns:columns,
        pageSize:10,  // ÿҳ��ʾ�ļ�¼����
	    pageList:[10,30,50],   // ��������ÿҳ��¼�������б�
	    loadMsg: '���ڼ�����Ϣ...',
	    pagination:true,
	    onSelect:function(rowIndex,rowData){
		    QuerySub();
	    }
    });
    
}
//��ʼ������ҩ�����������б�
function InitSupplyQueryTotalList(){
	//����columns
	var columns=[[
	    {field:'Tincicode',title:'ҩƷ����',width:100},
	    {field:'Tincidesc',title:'ҩƷ����',width:300},
	    {field:'Tspec',title:'���',width:135},
	    {field:'Tqty',title:'��ҩ����',width:100,align:'right'}
	    
	]];  
    //����datagrid	
    $('#supplyquerytotaldg').datagrid({    
        url:thisurl+'?action=GetSupplyQueryTotalList',
        fit:true,
	    border:false,
	    singleSelect:true,
	    rownumbers:true,
        columns:columns,
        pageSize:50,  // ÿҳ��ʾ�ļ�¼����
	    pageList:[50,100,300],   // ��������ÿҳ��¼�������б�
	    singleSelect:true,
	    loadMsg: '���ڼ�����Ϣ...',
	    pagination:true
    });
}
///����ҩ���������
function Reset(){
	$("#startDate").datebox("setValue", formatDate(0));  //Init��ʼ����
	$("#endDate").datebox("setValue", formatDate(0));  //Init��������
	$('#startTime').timespinner('setValue',"");
	$('#endTime').timespinner('setValue',"");
	//$("#wardLoc").combobox("setValue", "");  //Init����
	$("#basicLoc").combobox("setValue", "");  //Init��������
	$("#dispNo").val(""); 
	//$("#OutFlag").attr('checked',false);  //Init�����־
	//$("#InFlag").attr('checked',false);  //InitסԺ��־
	$('#supplyquerydg').datagrid('loadData',{total:0,rows:[]});
	$('#supplyquerydg').datagrid('options').queryParams.params = ""; 
	$('#supplyquerytotaldg').datagrid('loadData',{total:0,rows:[]});
	$('#supplyquerytotaldg').datagrid('options').queryParams.params = ""; 

}
///����ҩ��������ѯ
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
	var DispLocId=$("#phaLoc").combobox("getValue");
	if (($.trim($("#phaLoc").combobox("getText"))=="")||(DispLocId==undefined)){
		DispLocId="";
		$.messager.alert('��ʾ',"��ѡ��ҩ��!","info");
		return;
	}
	var WardId="" //$("#wardLoc").combobox("getValue");
	//if (($.trim($("#wardLoc").combobox("getText"))=="")||(WardId==undefined)){
	//	WardId="";
	//}
	var DoctorLocId=$("#basicLoc").combobox("getValue");
	if (($.trim($("#basicLoc").combobox("getText"))=="")||(DoctorLocId==undefined)){
		DoctorLocId="";
	}
	var DispNo=$("#dispNo").val();
	var OutFlag="1"
	var InFlag="0"
	/*
	if ($('#OutFlag').is(':checked')){
		OutFlag=1 
	}
	else{
		OutFlag=0
	}
	var InFlag=""
	if ($('#InFlag').is(':checked')){
		InFlag=1 
	}
	else{
		InFlag=0
	}
	if ((OutFlag=="")&&(InFlag=="")){
		$.messager.alert('��ʾ',"�빴ѡ��Ҫ��ѯ������סԺ����!","info");
		return;
	}*/
	var PamStr=OutFlag+"^"+InFlag;
	var params=startDate+"#"+endDate+"#"+DispLocId+"#"+WardId+"#"+startTime+"#"+endTime+"#"+DoctorLocId+"#"+DispNo+"#"+PamStr
	$('#supplyquerydg').datagrid({
		url:thisurl+'?action=GetSupplyQueryList',
     	queryParams:{
			params:params}
	});	
}
///����ҩ���������ܲ�ѯ
function QuerySub(){
	var selecteddata = $('#supplyquerydg').datagrid('getSelected');
	if(selecteddata==null){
		return;	
	}
	var pid=selecteddata["Tpid"]
	var supp=selecteddata["Tsupp"]
	var params=pid+"^"+supp
	$('#supplyquerytotaldg').datagrid({
		url:thisurl+'?action=GetSupplyQueryTotalList',
     	queryParams:{
			params:params}
	});	
}
///����ҩ��������ӡ
function Print(){	
	if($('#supplyquerydg').datagrid('getData').rows.length == 0) //��ȡ��ǰ������������
	{
		$.messager.alert("��ʾ","ҳ��û������","info");
		return ;
	}
	if($('#supplyquerydg').datagrid('getSelected') == null) {
		$.messager.alert("��ʾ","��ѡ����Ҫ��ӡ����!","info");
		return ;
	}
	if($('#supplyquerytotaldg').datagrid('getData').rows.length == 0) //��ȡ��ǰ������������
	{
		$.messager.alert("��ʾ","ҳ��û������","info");
		return ;
	}
	var SupplyQueryTotaldgOption=$("#supplyquerytotaldg").datagrid("options")
	var SupplyQueryTotaldgparams=SupplyQueryTotaldgOption.queryParams.params;
	var SupplyQueryTotaldgUrl=SupplyQueryTotaldgOption.url;
	$.ajax({
		type: "GET",
		url: SupplyQueryTotaldgUrl+"&page=1&rows=9999&params="+SupplyQueryTotaldgparams,
		async:false,
		dataType: "json",
		success: function(supplyquerytotaldata){
			PrintSupplyQueryTotal(supplyquerytotaldata);
		}
	});
}
	
function PrintSupplyQueryTotal(supplyquerytotaldata){
	var supplyselect=$('#supplyquerydg').datagrid('getSelected');
	var warddesc=supplyselect["Tward"];
	var phalocdesc=$("#phaLoc").combobox("getText");
	var path=tkMakeServerCall("web.DHCDocConfig","GetPath");//��ȡģ��·��
	var tmpjsonObject = JSON.stringify(supplyquerytotaldata.rows);
    var colarray = typeof tmpjsonObject != 'object' ? JSON.parse(tmpjsonObject) : tmpjsonObject;
    var rows=colarray.length
	var xlApp,obook,osheet,xlsheet,xlBook
	var Template
	Template = path + "STP_DSY_BJXH.xls"
	xlApp = new ActiveXObject("Excel.Application");
	xlBook = xlApp.Workbooks.Add(Template);
	xlsheet = xlBook.ActiveSheet
	xlsheet.Cells(2, 1).Value = "��ҩ����:"+phalocdesc + " ����:"+warddesc+ " ����:"+getPrintDateTime()+ " ��ӡ��:"+session['LOGON.USERNAME'];
	setBottomLine(xlsheet,3,1,3);
	for (i = 0; i < rows; i++) {
		setBottomLine(xlsheet,4+i,1,3);
		xlsheet.cells(4 + i, 1).value = colarray[i].Tincidesc
		xlsheet.cells(4 + i, 2).value = colarray[i].Tspec
		xlsheet.cells(4 + i, 3).value = colarray[i].Tqty
    }
	xlsheet.printout
    xlBook.Close(savechanges = false);
    xlApp = null;
    xlsheet = null
}