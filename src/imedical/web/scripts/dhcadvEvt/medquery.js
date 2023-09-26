
/// Creator: yangyongtao
/// CreateDate: 2016-3-3
//  Descript: ҩƷ��Ϣ��ѯ
var url = "dhcadv.repaction.csp";
$(function(){
	$('#Find').bind("click",Query);  //�����ѯ
	$('#exportCount').bind("click",ExportExcel); 	  //����
	$("#stDate").datebox("setValue", formatDate(-2));  //Init��ʼ����
	$("#endDate").datebox("setValue", formatDate(0));  //Init��������
	QueryList(); //��ʼ��ҩƷ��Ϣ�б�
	

}) 

//��ѯ
function Query()
{   
	var StDate=$('#stDate').datebox('getValue');   //��ʼ����
	var EndDate=$('#endDate').datebox('getValue'); //��ֹ����
	
	var params=StDate+"^"+EndDate;
	
	   $('#maindg').datagrid({
		url:url+'?action=getMedQuery',	
		queryParams:{
			params:params}
	});
	
	
   // $('#maindg').datagrid('load',{params:params}); 	
}

 

//��ʼ��ҩƷ��Ϣ�б�
function QueryList()
{

	//����columns
	var columns=[[
	    {field:"medsrRepLocDesc",title:'����',width:120,align:'center'},
	    {field:'restDayNum',title:'�ڼ���',width:50,align:'center'},
	    {field:'workDayNum',title:'������',width:50,align:'center'},
		{field:'medsrOccBatbNo',title:'�װ�',width:50,align:'center'},
		{field:'medsrOccBatyNo',title:'ҹ��',width:50,align:'center'},
		{field:'medsrOccBatjNo',title:'���Ӱ�',width:60,align:'center'},
		{field:'medsrDoctorsMes',title:'��ʽҽ��',width:80,align:'center'},
		{field:'medsrDoctoryMes',title:'�о���',width:60,align:'center'},
		{field:'medsrDoctorjMes',title:'����ҽ��',width:80,align:'center'},
		{field:'medsrApothecarysMes',title:'��ʽҩʦ',width:80,align:'center'},
		{field:'medsrApothecaryxMes',title:'ʵϰҩʦ',width:80,align:'center'},
		{field:'medsrApothecaryjMes',title:'����ҩʦ',width:80,align:'center'},
		{field:'medsrNursesMes',title:'��ʽ��ʿ',width:80,align:'center'},
		{field:'medsrNursexMes',title:'ʵϰ��ʿ',width:80,align:'center'},
		{field:'medsrNursejMes',title:'���޻�ʿ',width:80,align:'center'},
		{field:'MedsRepResultwDr',title:'����δ�ﵽ����',width:120,align:'center'},
		{field:'MedsRepResultdDr',title:'����ﵽ����',width:120,align:'center'},
		{field:'medsrDoctorsNum',title:'ҽ�����ڴ�������',width:120,align:'center',formatter:setCellViewSymbolOne},
		{field:'medsrApothecaryNum',title:'ҩʦ���ڴ�������',width:120,align:'center',formatter:setCellViewSymbolTwo},
		{field:'medsrDispNum',title:'���ʹ�������',width:120,align:'center',formatter:setCellViewSymbolThree},
		{field:'medsrNurseNum',title:'��ʿ���ڴ�������',width:120,align:'center',formatter:setCellViewSymbolFour},
		{field:'medsrPatDrNum',title:'���߻��ڴ�������',width:120,align:'center',formatter:setCellViewSymbolFive},
		
		//{field:'medsrDoctorsNum',title:'ҽ�����ڴ����������',width:230,align:'center'},
		//{field:'medsrApothecaryNum',title:'ҩʦ���ڴ����������',width:230,align:'center'},
		//{field:'medsrDispNum',title:'���ͻ��ڴ����������',width:230,align:'center'},
		//{field:'medsrNurseNum',title:'��ʿ���ڴ����������',width:230,align:'center'},
		//{field:'medsrPatDrNum',title:'���߻��ڴ����������',width:230,align:'center'},
	]];
	
	//����datagrid
	

	$('#maindg').datagrid({
		title:'��ҩ���ͳ�Ʋ�ѯ�б�',
		url:'',
		fit:true,		
		rownumbers:true,
		//������
		frozenColumns:[[
		//param = pid +"^"+ LocID +"^"+ medULinkid +"^"+ LinkItmCode;
		        //{field:"ck",checkbox:true,width:20},
			    //{field:"medsrRepLocDr",title:'����',width:120,align:'center'},
		        {field:'medsrOccDate',title:'��������',width:100,align:'center',hidden:true},
		        {field:'medsrOccTime',title:'����ʱ��',width:100,align:'center',hidden:true},
		]],
		
		columns:columns,
		pageSize:40,  // ÿҳ��ʾ�ļ�¼����
		pageList:[40,80],   // ��������ÿҳ��¼�������б�
	    singleSelect:false,
		loadMsg: '���ڼ�����Ϣ...',
		pagination:true,
		onLoadSuccess:function(data){
			var rows = $("#maindg").datagrid('getRows');
			var rowcount=rows.length ;			   
			if (rowcount==0) return;
            $('#maindg').datagrid('mergeCells', {
                index: rowcount - 1,
                field: 'restDayNum',
                colspan: 2
            });
		}
	});

   $('#maindg').datagrid({
		url:url+'?action=getMedQuery',	
		queryParams:{
			params:''}
	});
	initScroll("#maindg");//��ʼ����ʾ���������
	$('#maindg').datagrid('loadData', {total:0,rows:[]}); 
}





///���ñ༭����
 function setCellViewSymbolOne(value, rowData, rowIndex){
	 	
		var pid = rowData.pid;  
		var LocID = rowData.LocID;
		var medULinkid = 1;
		var param = pid +"^"+ LocID +"^"+ medULinkid+"^"+ value;
		
		return "<a href='#' onclick=\"showEditWin('"+ param +"')\" >"+ value +"</a>";
		
} 

///���ñ༭����
 function setCellViewSymbolTwo(value, rowData, rowIndex){
	 	
	
		var pid = rowData.pid;  
		var LocID = rowData.LocID;
		var medULinkid = 2;
		var param = pid +"^"+ LocID +"^"+ medULinkid+"^"+ value;

	    return "<a href='#' onclick=\"showEditWin('"+ param +"')\">"+ value +"</a>";
		
} 

///���ñ༭����
 function setCellViewSymbolThree(value, rowData, rowIndex){
	 	

		var pid = rowData.pid;  
		var LocID = rowData.LocID;
		var medULinkid = 3;
		var param = pid +"^"+ LocID +"^"+ medULinkid +"^"+ value;
		
		return "<a href='#' onclick=\"showEditWin('"+ param +"')\">"+ value +"</a>";
		
} 
///���ñ༭����
 function setCellViewSymbolFour(value, rowData, rowIndex){
	 	

		var pid = rowData.pid;  
		var LocID = rowData.LocID;
		var medULinkid = 4;
		var param = pid +"^"+ LocID +"^"+ medULinkid +"^"+ value;
		
		return "<a href='#' onclick=\"showEditWin('"+ param +"')\">"+ value +"</a>";
		
} 
///���ñ༭����
 function setCellViewSymbolFive(value, rowData, rowIndex){
	 	
		var pid = rowData.pid;  
		var LocID = rowData.LocID;
		var medULinkid = 5;
		var param = pid +"^"+ LocID +"^"+ medULinkid +"^"+ value;
		
		return "<a href='#' onclick=\"showEditWin('"+ param +"')\">"+ value +"</a>";
		
} 
function showEditWin(params){
	
	
	//if($('#win').is(":visible")){return;}  //���崦�ڴ�״̬,�˳�

	//$('body').append('<div id="win"></div>');
	//$('#win').append('<div id="m"></div>');
	if($('#win').is(":hidden")){
		$('#win1').datagrid('reload',{"params":params});
		$('#win').window('open');
		return;
	}
	
	$('#win').window({
		
		title:'��ҩ����ͳ����ϸ',
		collapsible:true,
		border:false,
		closed:"true",
		width:450,
		height:400
	});
	
	//
	var columns=[[
	    {field:"ck",checkbox:true,width:20},
        {field:'medULinkItmCode',title:'Code',width:80},
		{field:'medULinkItmDesc',title:'����',width:150},
		{field:'medULinkItmNum',title:'����',width:100},
		{field:'pid',title:'pid',width:50,hidden:true},
		{field:'InLocID',title:'����ID',width:50,hidden:true},
		{field:'medULinkid',title:'����ID',width:50,hidden:true}
	
	]];
	
	//����datagrid
	$('#win1').datagrid({
		url:url+'?action=getMedLinkDetail&params='+params,
		fit:true,
		rownumbers:true,
		columns:columns,
		pageSize:40,  // ÿҳ��ʾ�ļ�¼����
		pageList:[40,80],   // ��������ÿҳ��¼�������б�
	    singleSelect:false,
		loadMsg: '���ڼ�����Ϣ...',
		pagination:true
	});
	$('#exportDetail').bind("click",ExportDetail); 	  //����
	$('#win').window('open');
	
	
	
}
 
 
// ����Excel(��ҩ���ͳ������)
function ExportDetail()
{
	var selItems = $('#win1').datagrid('getSelections');
	if (!selItems.length){
		$.messager.alert('��ʾ',"<font style='color:red;font-weight:bold;font-size:20px;'>����ѡ��һ�м�¼!</font>","error");
		return;
	}
	var filePath=browseFolder();
	var re=/[a-zA-Z]:\\/;
	if ((filePath==undefined)||(filePath.match(re)=="")||(filePath.match(re)==null)){
		$.messager.alert("��ʾ:","<font style='color:red;font-weight:bold;font-size:20px;'>��ѡ��·����,���ԣ�</font>","error");
		return;
	 }

	$.each(selItems, function(index, item){
		var pid=item.pid
		var InLocID=item.InLocID
		var medULinkid=item.medULinkid
		var medULinkItmCode=item.medULinkItmCode
		var param = pid +"^"+ InLocID +"^"+ medULinkid+"^"+medULinkItmCode;
		
		ExportExcelDetail(param,filePath);
	})
	$.messager.alert("��ʾ:","<font style='color:green;font-weight:bold;font-size:20px;'>������ɣ�����Ŀ¼Ϊ:"+filePath+"</font>","info");
} 
 // ����Excel(��ҩ���ͳ������)
function ExportExcelDetail(param,filePath)
{ 
		var retval=tkMakeServerCall("web.DHCADVSAFECOUNT","getMedLinkDetailCount",param);
		if(retval==""){
			$.messager.alert("��ʾ:","ȡ���ݴ���");
			return;
		}
		//DHCADV_DetailCount.xls
		var retvalArr=retval.split("^");
		
		//1����ȡXLS����·��
		
		var path=tkMakeServerCall("web.DHCDocConfig","GetPath");
		
		var Template = path+"DHCADV_DetailCount.xls";
		var xlApp = new ActiveXObject("Excel.Application");
		var xlBook = xlApp.Workbooks.Add(Template);
		var objSheet = xlBook.ActiveSheet;
		//���ù���������  
        objSheet.name = "��ҩ��������ͳ��"; 
		objSheet.Cells(3,1).value=retvalArr[0]; //Code
		
		objSheet.Cells(3,2).value=retvalArr[1]; //����
		var fileName=retvalArr[1];	
	 fileName=fileName.replace(/\//g,'');//ȥ�������е�/\//g 
	    
	      
    /*   if(fileName.indexOf("/")){
		var fileName=fileName.replace("/","");
	     }  */
	     
		objSheet.Cells(3,3).value=retvalArr[2]; //����
	
		xlBook.SaveAs(filePath+fileName+".xls");
		
		xlApp=null;
		xlBook.Close(savechanges=false);
		objSheet=null;	
}
 
// ����Excel(��ҩ���ͳ��)
function ExportExcel() {
		 var StDate=$('#stDate').datebox('getValue');   //��ʼ����
	     var EndDate=$('#endDate').datebox('getValue'); //��ֹ����

		 var filePath=browseFolder();
	     var re=/[a-zA-Z]:\\/;
	     if ((filePath==undefined)||(filePath.match(re)=="")||(filePath.match(re)==null)){
		 	$.messager.alert("��ʾ:","<font style='color:red;font-weight:bold;font-size:20px;'>��ѡ��·����,���ԣ�</font>","error");
		 	return;
	     }
         //��ȡDatagride����  
         var rows = $('#maindg').datagrid('getRows');  
         var columns = $("#maindg").datagrid("options").columns[0];  
         var xlApp = new ActiveXObject("Excel.Application"); //����AX����excel   
         var path=tkMakeServerCall("web.DHCDocConfig","GetPath");
		 var Template = path+"DHCADV_DrugCount.xls";
         var xlBook = xlApp.Workbooks.Add(Template); //��ȡworkbook����   
         var objSheet = xlBook.ActiveSheet; //���ǰsheet        
         //xlApp.Range(xlApp.Cells(1,10),xlApp.Cells(1,12)).MergeCells = true;
		 objSheet.Cells(1,14).value="( "+StDate+"��"+EndDate+" )";  //��ʼ���ڵ���������
         //alert(objSheet.Cells(1,10).value)
             
         //���ù���������  
         objSheet.name = "��ҩ����ͳ��";  
         //���ñ�ͷ  
         for (var i = 0; i < columns.length; i++) {  
         	objSheet.Cells(2, i+1).value = columns[i].title;  
         	//alert(columns.length)

         }  
         //�������ݲ���  
         for (var i = 0; i < rows.length; i++) {  
         	//��̬��ȡÿһ��ÿһ�е�����ֵ  
         	for (var j = 0; j < columns.length; j++) {    
            	//alert(rows.length)             
            	objSheet.Cells(i + 3, j+1).value = rows[i][columns[j].field];
         	} 
         	xlApp.Range(xlApp.Cells(rows.length+2, 2),xlApp.Cells(rows.length+2, 3)).MergeCells = true;     
      	 }                
         xlApp.Visible = false; //����excel�ɼ�����  true
         xlBook.SaveAs(filePath+"��ҩ����ͳ��"+".xls");
		 xlApp=null;
		 xlBook.Close(savechanges=false);
		 objSheet=null;
            
          $.messager.alert("��ʾ:","<font style='color:green;font-weight:bold;font-size:20px;'>������ɣ�����Ŀ¼Ϊ:"+filePath+"</font>","info");
}  
 
 
 
 
 
 