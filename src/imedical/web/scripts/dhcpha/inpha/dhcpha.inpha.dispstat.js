/*
ģ��:סԺҩ��
��ģ��:סԺҩ��-��ҩͳ��
createdate:2016-06-29
creator:yunhaibao
*/
var commonInPhaUrl = "DHCST.INPHA.ACTION.csp";
var commonOutPhaUrl="DHCST.OUTPHA.ACTION.csp";
var thisUrl="dhcpha.inpha.dispstat.action.csp"
var gLocId=session['LOGON.CTLOCID'];
var gUserId=session['LOGON.USERID'];
var gGroupId=session['LOGON.GROUPID'];
var gInciRowID="";
var combooption = {
	valueField :'RowId',    
	textField :'Desc',
	panelWidth:'225'
}
$(function(){
	var stkGrpCombo=new ListCombobox("stkGrp",commonInPhaUrl+'?action=GetLocStkGrpDs&locId='+gLocId,'',combooption);
	stkGrpCombo.init(); //��ʼ������
	var dispTypeCombo=new ListCombobox("dispType",commonInPhaUrl+'?action=GetLocDispTypeDs&locId='+gLocId,'',combooption);
	dispTypeCombo.init(); //��ʼ����ҩ���
	InitPhaLoc();
	InitDispWardGrid(); //��ʼ������grid
	InitDispStatGrid(); //��ʼ����ҩͳ����ϸ
	InitCondition();
	$('#inciDesc').bind('keypress',function(event){
	 	if(event.keyCode == "13")    
	 	{
		 var input=$.trim($("#inciDesc").val());
		 if (input!="")
		 {
			var mydiv = new IncItmDivWindow($("#inciDesc"), input,getDrugList);
            mydiv.init();
		 }else{
			gInciRowID="";
		 }	
	 }
	});
	$('#chkWard').on('click', function(){
		if ($('#chkWard').is(':checked')){
			$('#chkLoc').attr('checked',false); 
		}else{
			$('#chkLoc').attr('checked',true); 
		}
	});
	$('#chkLoc').on('click', function(){
		if ($('#chkLoc').is(':checked')){
			$('#chkWard').attr('checked',false); 
		}else{
			$('#chkWard').attr('checked',true);
		}
	});
	$('#btnClear').on('click', InitCondition);//������
	$('#btnFind').on('click', btnFindHandler);//���ͳ��
	$('#btnFindSum').on('click', btnFindSumHandler);//���ͳ����ϸ
	$('#btnPrint').on('click', btnPrintHandler);//�����ӡ��ϸ
});
 //��ʼ������
function InitCondition(){
	gInciRowID="";
	$("#inciDesc").val("");
	$("#startDate").datebox("setValue", formatDate(0));  
	$("#endDate").datebox("setValue", formatDate(0));  
	$('#startTime').timespinner('setValue',"");
	$('#endTime').timespinner('setValue',"");
	$('#stkGrp').combobox("setValue","");
	$('#dispType').combobox("setValue","");
	$('#phaLoc').combobox("setValue",gLocId);
	$('#dispstatgrid').datagrid('loadData',{total:0,rows:[]});
	$('#dispstatgrid').datagrid('options').queryParams.params = ""; 
	$('#dispwardgrid').datagrid('loadData',{total:0,rows:[]});
	$('#dispwardgrid').datagrid('options').queryParams.params = ""; 
}
function InitPhaLoc(){
	$('#phaLoc').combobox({  
		width:225,
		panelWidth: 225,
		url:commonInPhaUrl+'?action=GetStockPhlocDs&groupId='+gGroupId,  
		valueField:'RowId',  
		textField:'Desc',
		onLoadSuccess: function(){
			var data = $('#phaLoc').combobox('getData');
            if (data.length > 0) {
                  $('#phaLoc').combobox('select', gLocId);
              }            
	    },
	    onSelect:function(){
		    var selectLoc=$('#phaLoc').combobox("getValue")
	        $('#stkGrp').combobox('reload',commonInPhaUrl+'?action=GetLocStkGrpDs&locId='+selectLoc);           
	        $('#dispType').combobox('reload',commonInPhaUrl+'?action=GetLocDispTypeDs&locId='+selectLoc);           
		}

	});
}

function InitDispWardGrid(){
	//����columns
	var columns=[
		{field:"ProcessID",title:'ProcessID',width:80,hidden:true},
		{field:"AdmLocRowid",title:'AdmLocRowid',width:80,hidden:true},
		{field:"TSelect",checkbox:true},
		{field:"AdmLocDesc",title:'����',width:250,sortable:true}									
	];
	//����datagrid
	$('#dispwardgrid').datagrid({
		border:false,
		url:'',
		fit:true,
		rownumbers:true,
		nowrap:false,
		columns:[columns],
	    singleSelect:false,
		loadMsg: '���ڼ�����Ϣ...',
		selectOnCheck: true, 
		checkOnSelect: true,
		pageSize:999,  // ÿҳ��ʾ�ļ�¼����
		pageList:[999],  // ��������ÿҳ��¼�������б�
	    onBeforeLoad:function(param){
			KillTmpBeforeLoad();
		}
	});
}

function InitDispStatGrid(){
	//����columns
	var columns=[[
		{field:"PID",title:'PID',width:50,hidden:true},
		{field:"AdmLocID",title:'AdmLocID',width:50,hidden:true},
		{field:"Tinci",title:'Tinci',width:100,hidden:true},
		{field:"DispItmCode",title:'ҩƷ����',width:75,sortable:true},
		{field:"DispItmDesc",title:'ҩƷ����',width:220},
		{field:"DispQty",title:'��ҩ����',width:60,align:'right',sortable:true},		
		{field:"RetQty",title:'��ҩ����',width:60,align:'right',sortable:true},	
		{field:"Total",title:'�ϼ�����',width:60,align:'right',sortable:true},	
		{field:"Uom",title:'��λ',width:60},
		{field:"TPhciPrice",title:'����',width:75,align:'right',sortable:true},		
		{field:"Amount",title:'���',width:100,align:'right',sortable:true},
		{field:"TBarCode",title:'���',width:80},		
		{field:"TManf",title:'����',width:120},	
		{field:"TPhcfDesc",title:'����',width:100},	
		{field:"Tward",title:'����',width:150},	
		{field:"Tgeneric",title:'ͨ����',width:100,hidden:true},
		{field:"TTotalUom",title:'����(��λ)',width:100,hidden:true}						
	]];
	//����datagrid
	$('#dispstatgrid').datagrid({
		border:false,
		url:'', //thisUrl+'?action=jsQueryDispList',
		fit:true,
		//rownumbers:true,
		nowrap:false,
		columns:columns,
	    singleSelect:true,
		loadMsg: '���ڼ�����Ϣ...',
		//chectOnCheck: true, 
		//checkOnSelect: true,
		pageSize:100,  // ÿҳ��ʾ�ļ�¼����
		pageList:[100,300,500],   // ��������ÿҳ��¼�������б�
		pagination:true,
		onRowContextMenu: onRowContextMenu, //[��ͷ(tab)�Ҽ�onHeaderContextMenu,����(tree)�Ҽ�onContextMenu]
	    onBeforeLoad:function(param){
		//	KillTmpBeforeLoad();
		}
	});
	//initScroll("#dispstatgrid"); //�˳�ʼ���ᵼ��Ĭ��������1
}
////����һ��˵�����
function onRowContextMenu(e, rowIndex, rowData){
   e.preventDefault();
    $('#rightmenu').menu('show', {
        left:e.pageX,
        top:e.pageY
    });       
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
function btnFindHandler(){
	var startDate=$('#startDate').datebox('getValue');
	if (startDate==""){
		$.messager.alert('��ʾ',"�����뿪ʼ����!","info");
		return;
	}
	var endDate=$('#endDate').datebox('getValue');
	if (endDate==""){
		$.messager.alert('��ʾ',"�����뿪ʼ����!","info");
		return;
	}
	var startTime=$('#startTime').timespinner('getValue');
	var endTime=$('#endTime').timespinner('getValue');
	var phaLoc=$('#phaLoc').combobox("getValue")
	if (($.trim($('#phaLoc').combobox("getText"))=="")||(phaLoc==undefined)){
		phaLoc="";
		$.messager.alert('��ʾ',"ҩ��������Ϊ��!","info");
		return;
	}
	var stkGrp=$('#stkGrp').combobox("getValue")
	if (($.trim($('#stkGrp').combobox("getText"))=="")||(stkGrp==undefined)){
		stkGrp="";
	}
	var dispType=$('#dispType').combobox("getValue")
	if (($.trim($('#dispType').combobox("getText"))=="")||(dispType==undefined)){
		dispType="";
	}
	if ($.trim($("#inciDesc").val())==""){
		gInciRowId="";
	}
	var statFlag=""
	if ($('#chkWard').is(':checked')){
		statFlag="1"
	}
	if ($('#chkLoc').is(':checked')){
		statFlag="0"
	}
	$('#dispstatgrid').datagrid('loadData',{total:0,rows:[]});
	$('#dispstatgrid').datagrid('options').queryParams.params = ""; 
	var phcCat="",includeDisp="",patNo=""
	var params=startDate+"^"+endDate+"^"+phaLoc+"^"+dispType+"^"+startTime
		  +"^"+endTime+"^"+gInciRowId+"^"+statFlag+"^"+phcCat+"^"+includeDisp
		  +"^"+patNo+"^"+stkGrp
	$('#dispwardgrid').datagrid({
		url:thisUrl+'?action=QueryDispStat',	
		queryParams:{
			params:params}
	});
}
 //��ѯѡ�����ķ�ҩͳ����ϸ
function btnFindSumHandler(){
	var dispwardgridrowsdata=$('#dispwardgrid').datagrid("getRows");
	var dispwardgridrows=dispwardgridrowsdata.length;
	if (dispwardgridrows<=0){
		$.messager.alert('��ʾ',"��ѡ������!","info");
		return;
	}
	var checkedItems = $('#dispwardgrid').datagrid('getChecked');
	if ((checkedItems==null)||(checkedItems=="")){
		$.messager.alert('��ʾ',"�빴ѡ��Ҫͳ�ƵĿ���!","info");
		return;
	}
	var admLocStr="",pid="";	
	$.each(checkedItems, function(index, item){
		if (admLocStr==""){
			admLocStr=item.AdmLocRowid;
		}else{
			admLocStr=admLocStr+"^"+item.AdmLocRowid;
		}
		pid=item.ProcessID
	});
	var params=pid+","+admLocStr;
	$('#dispstatgrid').datagrid({
		url:thisUrl+'?action=QueryDispStatDetail',	
		queryParams:{
			params:params}
	});
}
//����
function ExportClick(){
	ExportAllToExcel("dispstatgrid")
}
//��ӡ
function btnPrintHandler(){
	if ($('#dispstatgrid').datagrid('getData').rows.length == 0){
		$.messager.alert("��ʾ","ҳ��û������","info");
		return ;
	}
	var statgridOption=$("#dispstatgrid").datagrid("options")
	var statgridParams=statgridOption.queryParams.params;
	var statgridUrl=statgridOption.url;
	$.ajax({
		type: "GET",
		url: statgridUrl+"&page=1&rows=9999&params="+statgridParams,
		async:false,
		dataType: "json",
		success: function(returndata){
			PrintDispStat(returndata);
		}
	});

}
function PrintDispStat(returndata){
	
	var path=tkMakeServerCall("web.DHCDocConfig","GetPath");//��ȡģ��·��
	var locdesc=$("#phaLoc").combobox("getText");
	if (locdesc.indexOf("-")>0){
		locdesc=locdesc.split("-")[1];
	}
	var tmpjsonObject = JSON.stringify(returndata.rows);
    var colarray = typeof tmpjsonObject != 'object' ? JSON.parse(tmpjsonObject) : tmpjsonObject;
    var rows=colarray.length;
	var datestart = $('#startDate').datebox('getValue');
	var dateend = $('#endDate').datebox('getValue');
	var xlApp,obook,osheet,xlsheet,xlBook;
	var Template;
	Template = path + "DHCSTP_PhaDispStat_ZYD.xls"
	xlApp = new ActiveXObject("Excel.Application");
	xlBook = xlApp.Workbooks.Add(Template);
	xlsheet = xlBook.ActiveSheet;
	var startRow=3,cols=11,h=1,j=0;
	for (var i=0;i<rows;i++){
		var itmdesc=colarray[i].DispItmDesc;
		var dispqty=colarray[i].DispQty;
		var retqty=colarray[i].RetQty;
		var totalqty=colarray[i].Total;
		var uom=colarray[i].Uom;
		var amt=colarray[i].Amount;
		var rPhcfDesc=colarray[i].TPhcfDesc;
		var rmanf=colarray[i].TManf;
		var BarCode=colarray[i].TBarCode;
		var phciprice=colarray[i].TPhciPrice;
		var ward=colarray[i].Tward;
		var TotalQtyUom=colarray[i].TTotalUom;
		if ((tmpward!=ward)&&($.trim(ward)!="")){
			startRow=startRow+4
		    xlsheet.Cells(i+startRow-2,1).Value="����:"+ward+"   "+"��ʼ����:"+datestart+" "+"   "+"��������:"+dateend
			xlsheet.Cells(i+startRow-1,1).Value="���"
			xlsheet.Cells(i+startRow-1,2).Value="ҩƷ����"
			xlsheet.Cells(i+startRow-1,3).Value="���"
			xlsheet.Cells(i+startRow-1,4).Value="����"
			xlsheet.Cells(i+startRow-1,5).Value="����"
			xlsheet.Cells(i+startRow-1,6).Value="��λ"
			xlsheet.Cells(i+startRow-1,7).Value="��ҩ����"
			xlsheet.Cells(i+startRow-1,8).Value="��ҩ����"
			xlsheet.Cells(i+startRow-1,9).Value="�ϼ�����"
			xlsheet.Cells(i+startRow-1,10).Value="ҩƷ����"
			xlsheet.Cells(i+startRow-1,11).Value="ҩƷ���"
			for (j=1;j<=cols;j++){ 
  		       xlsheet.Cells(i+startRow-1,j).Borders(9).LineStyle = 1;    
       	       xlsheet.Cells(i+startRow-1,j).Borders(7).LineStyle = 1;    
      	       xlsheet.Cells(i+startRow-1,j).Borders(10).LineStyle = 1;   
       	       xlsheet.Cells(i+startRow-1,j).Borders(8).LineStyle = 1;    
 	       	   xlApp.ActiveSheet.Cells(i+startRow-1,j).HorizontalAlignment = 3;
   	        }
			h=1
		}		
		for (j=1;j<=cols;j++){ 
  
	       xlsheet.Cells(i+startRow,j).Borders(9).LineStyle = 1;    
   	       xlsheet.Cells(i+startRow,j).Borders(7).LineStyle = 1;    
  	       xlsheet.Cells(i+startRow,j).Borders(10).LineStyle = 1;   
   	       xlsheet.Cells(i+startRow,j).Borders(8).LineStyle = 1;    
       	   xlApp.ActiveSheet.Cells(i+startRow,j).HorizontalAlignment = 3;
        }
	    var tmpitm=itmdesc.split("(")
		itmdesc=tmpitm[0];
		xlsheet.Cells(i+startRow,1).Value=h  //���
		xlsheet.Cells(i+startRow,2).Value=itmdesc;
		xlsheet.Cells(i+startRow,3).Value=BarCode;
		xlsheet.Cells(i+startRow,4).Value=rPhcfDesc;
		xlsheet.Cells(i+startRow,5).Value=rmanf;
		xlsheet.Cells(i+startRow,6).Value=uom;
		xlsheet.Cells(i+startRow,7).Value=dispqty;
		xlsheet.Cells(i+startRow,8).Value=retqty;
		xlsheet.Cells(i+startRow,9).Value=TotalQtyUom;
		xlsheet.Cells(i+startRow,10).Value=phciprice;
		xlsheet.Cells(i+startRow,11).Value=amt;		
		var tmpward=ward
		h=h+1
    }
	xlsheet.printout
    xlBook.Close(savechanges = false);
    xlApp = null;
    xlsheet = null
}

function KillTmpBeforeLoad(){
	var dispwardgridrowsdata=$('#dispwardgrid').datagrid("getRows");
	var dispwardgridrows=dispwardgridrowsdata.length;
	if (dispwardgridrows>0){
		var selecteddata=$('#dispwardgrid').datagrid('getData').rows[0];
		var killret=tkMakeServerCall("web.DHCSTPCHCOLLS","KillCollTmpGlobal","","",selecteddata["ProcessID"])
	}
}
window.onbeforeunload = function (){
	KillTmpBeforeLoad();
}
