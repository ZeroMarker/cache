
/// Creator: yangyongtao
/// CreateDate: 2016-3-3
//  Descript: 药品信息查询
var url = "dhcadv.repaction.csp";
$(function(){
	$('#Find').bind("click",Query);  //点击查询
	$('#exportCount').bind("click",ExportExcel); 	  //导出
	$("#stDate").datebox("setValue", formatDate(-2));  //Init起始日期
	$("#endDate").datebox("setValue", formatDate(0));  //Init结束日期
	QueryList(); //初始化药品信息列表
	

}) 

//查询
function Query()
{   
	var StDate=$('#stDate').datebox('getValue');   //起始日期
	var EndDate=$('#endDate').datebox('getValue'); //截止日期
	
	var params=StDate+"^"+EndDate;
	
	   $('#maindg').datagrid({
		url:url+'?action=getMedQuery',	
		queryParams:{
			params:params}
	});
	
	
   // $('#maindg').datagrid('load',{params:params}); 	
}

 

//初始化药品信息列表
function QueryList()
{

	//定义columns
	var columns=[[
	    {field:"medsrRepLocDesc",title:'科室',width:120,align:'center'},
	    {field:'restDayNum',title:'节假日',width:50,align:'center'},
	    {field:'workDayNum',title:'工作日',width:50,align:'center'},
		{field:'medsrOccBatbNo',title:'白班',width:50,align:'center'},
		{field:'medsrOccBatyNo',title:'夜班',width:50,align:'center'},
		{field:'medsrOccBatjNo',title:'交接班',width:60,align:'center'},
		{field:'medsrDoctorsMes',title:'正式医生',width:80,align:'center'},
		{field:'medsrDoctoryMes',title:'研究生',width:60,align:'center'},
		{field:'medsrDoctorjMes',title:'进修医生',width:80,align:'center'},
		{field:'medsrApothecarysMes',title:'正式药师',width:80,align:'center'},
		{field:'medsrApothecaryxMes',title:'实习药师',width:80,align:'center'},
		{field:'medsrApothecaryjMes',title:'进修药师',width:80,align:'center'},
		{field:'medsrNursesMes',title:'正式护士',width:80,align:'center'},
		{field:'medsrNursexMes',title:'实习护士',width:80,align:'center'},
		{field:'medsrNursejMes',title:'进修护士',width:80,align:'center'},
		{field:'MedsRepResultwDr',title:'错误未达到患者',width:120,align:'center'},
		{field:'MedsRepResultdDr',title:'错误达到患者',width:120,align:'center'},
		{field:'medsrDoctorsNum',title:'医生环节错误总数',width:120,align:'center',formatter:setCellViewSymbolOne},
		{field:'medsrApothecaryNum',title:'药师环节错误总数',width:120,align:'center',formatter:setCellViewSymbolTwo},
		{field:'medsrDispNum',title:'配送错误总数',width:120,align:'center',formatter:setCellViewSymbolThree},
		{field:'medsrNurseNum',title:'护士环节错误总数',width:120,align:'center',formatter:setCellViewSymbolFour},
		{field:'medsrPatDrNum',title:'患者环节错误总数',width:120,align:'center',formatter:setCellViewSymbolFive},
		
		//{field:'medsrDoctorsNum',title:'医生环节错误各类数量',width:230,align:'center'},
		//{field:'medsrApothecaryNum',title:'药师环节错误各类数量',width:230,align:'center'},
		//{field:'medsrDispNum',title:'配送环节错误各类数量',width:230,align:'center'},
		//{field:'medsrNurseNum',title:'护士环节错误各类数量',width:230,align:'center'},
		//{field:'medsrPatDrNum',title:'患者环节错误各类数量',width:230,align:'center'},
	]];
	
	//定义datagrid
	

	$('#maindg').datagrid({
		title:'用药差错统计查询列表',
		url:'',
		fit:true,		
		rownumbers:true,
		//冻结列
		frozenColumns:[[
		//param = pid +"^"+ LocID +"^"+ medULinkid +"^"+ LinkItmCode;
		        //{field:"ck",checkbox:true,width:20},
			    //{field:"medsrRepLocDr",title:'科室',width:120,align:'center'},
		        {field:'medsrOccDate',title:'发生日期',width:100,align:'center',hidden:true},
		        {field:'medsrOccTime',title:'发生时间',width:100,align:'center',hidden:true},
		]],
		
		columns:columns,
		pageSize:40,  // 每页显示的记录条数
		pageList:[40,80],   // 可以设置每页记录条数的列表
	    singleSelect:false,
		loadMsg: '正在加载信息...',
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
	initScroll("#maindg");//初始化显示横向滚动条
	$('#maindg').datagrid('loadData', {total:0,rows:[]}); 
}





///设置编辑连接
 function setCellViewSymbolOne(value, rowData, rowIndex){
	 	
		var pid = rowData.pid;  
		var LocID = rowData.LocID;
		var medULinkid = 1;
		var param = pid +"^"+ LocID +"^"+ medULinkid+"^"+ value;
		
		return "<a href='#' onclick=\"showEditWin('"+ param +"')\" >"+ value +"</a>";
		
} 

///设置编辑连接
 function setCellViewSymbolTwo(value, rowData, rowIndex){
	 	
	
		var pid = rowData.pid;  
		var LocID = rowData.LocID;
		var medULinkid = 2;
		var param = pid +"^"+ LocID +"^"+ medULinkid+"^"+ value;

	    return "<a href='#' onclick=\"showEditWin('"+ param +"')\">"+ value +"</a>";
		
} 

///设置编辑连接
 function setCellViewSymbolThree(value, rowData, rowIndex){
	 	

		var pid = rowData.pid;  
		var LocID = rowData.LocID;
		var medULinkid = 3;
		var param = pid +"^"+ LocID +"^"+ medULinkid +"^"+ value;
		
		return "<a href='#' onclick=\"showEditWin('"+ param +"')\">"+ value +"</a>";
		
} 
///设置编辑连接
 function setCellViewSymbolFour(value, rowData, rowIndex){
	 	

		var pid = rowData.pid;  
		var LocID = rowData.LocID;
		var medULinkid = 4;
		var param = pid +"^"+ LocID +"^"+ medULinkid +"^"+ value;
		
		return "<a href='#' onclick=\"showEditWin('"+ param +"')\">"+ value +"</a>";
		
} 
///设置编辑连接
 function setCellViewSymbolFive(value, rowData, rowIndex){
	 	
		var pid = rowData.pid;  
		var LocID = rowData.LocID;
		var medULinkid = 5;
		var param = pid +"^"+ LocID +"^"+ medULinkid +"^"+ value;
		
		return "<a href='#' onclick=\"showEditWin('"+ param +"')\">"+ value +"</a>";
		
} 
function showEditWin(params){
	
	
	//if($('#win').is(":visible")){return;}  //窗体处在打开状态,退出

	//$('body').append('<div id="win"></div>');
	//$('#win').append('<div id="m"></div>');
	if($('#win').is(":hidden")){
		$('#win1').datagrid('reload',{"params":params});
		$('#win').window('open');
		return;
	}
	
	$('#win').window({
		
		title:'用药错误统计明细',
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
		{field:'medULinkItmDesc',title:'描述',width:150},
		{field:'medULinkItmNum',title:'数量',width:100},
		{field:'pid',title:'pid',width:50,hidden:true},
		{field:'InLocID',title:'科室ID',width:50,hidden:true},
		{field:'medULinkid',title:'环节ID',width:50,hidden:true}
	
	]];
	
	//定义datagrid
	$('#win1').datagrid({
		url:url+'?action=getMedLinkDetail&params='+params,
		fit:true,
		rownumbers:true,
		columns:columns,
		pageSize:40,  // 每页显示的记录条数
		pageList:[40,80],   // 可以设置每页记录条数的列表
	    singleSelect:false,
		loadMsg: '正在加载信息...',
		pagination:true
	});
	$('#exportDetail').bind("click",ExportDetail); 	  //导出
	$('#win').window('open');
	
	
	
}
 
 
// 导出Excel(用药差错统计详情)
function ExportDetail()
{
	var selItems = $('#win1').datagrid('getSelections');
	if (!selItems.length){
		$.messager.alert('提示',"<font style='color:red;font-weight:bold;font-size:20px;'>请先选择一行记录!</font>","error");
		return;
	}
	var filePath=browseFolder();
	var re=/[a-zA-Z]:\\/;
	if ((filePath==undefined)||(filePath.match(re)=="")||(filePath.match(re)==null)){
		$.messager.alert("提示:","<font style='color:red;font-weight:bold;font-size:20px;'>请选择路径后,重试！</font>","error");
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
	$.messager.alert("提示:","<font style='color:green;font-weight:bold;font-size:20px;'>导出完成！导出目录为:"+filePath+"</font>","info");
} 
 // 导出Excel(用药差错统计详情)
function ExportExcelDetail(param,filePath)
{ 
		var retval=tkMakeServerCall("web.DHCADVSAFECOUNT","getMedLinkDetailCount",param);
		if(retval==""){
			$.messager.alert("提示:","取数据错误！");
			return;
		}
		//DHCADV_DetailCount.xls
		var retvalArr=retval.split("^");
		
		//1、获取XLS导出路径
		
		var path=tkMakeServerCall("web.DHCDocConfig","GetPath");
		
		var Template = path+"DHCADV_DetailCount.xls";
		var xlApp = new ActiveXObject("Excel.Application");
		var xlBook = xlApp.Workbooks.Add(Template);
		var objSheet = xlBook.ActiveSheet;
		//设置工作薄名称  
        objSheet.name = "用药错误详情统计"; 
		objSheet.Cells(3,1).value=retvalArr[0]; //Code
		
		objSheet.Cells(3,2).value=retvalArr[1]; //描述
		var fileName=retvalArr[1];	
	 fileName=fileName.replace(/\//g,'');//去掉描述中的/\//g 
	    
	      
    /*   if(fileName.indexOf("/")){
		var fileName=fileName.replace("/","");
	     }  */
	     
		objSheet.Cells(3,3).value=retvalArr[2]; //数量
	
		xlBook.SaveAs(filePath+fileName+".xls");
		
		xlApp=null;
		xlBook.Close(savechanges=false);
		objSheet=null;	
}
 
// 导出Excel(用药差错统计)
function ExportExcel() {
		 var StDate=$('#stDate').datebox('getValue');   //起始日期
	     var EndDate=$('#endDate').datebox('getValue'); //截止日期

		 var filePath=browseFolder();
	     var re=/[a-zA-Z]:\\/;
	     if ((filePath==undefined)||(filePath.match(re)=="")||(filePath.match(re)==null)){
		 	$.messager.alert("提示:","<font style='color:red;font-weight:bold;font-size:20px;'>请选择路径后,重试！</font>","error");
		 	return;
	     }
         //获取Datagride的列  
         var rows = $('#maindg').datagrid('getRows');  
         var columns = $("#maindg").datagrid("options").columns[0];  
         var xlApp = new ActiveXObject("Excel.Application"); //创建AX对象excel   
         var path=tkMakeServerCall("web.DHCDocConfig","GetPath");
		 var Template = path+"DHCADV_DrugCount.xls";
         var xlBook = xlApp.Workbooks.Add(Template); //获取workbook对象   
         var objSheet = xlBook.ActiveSheet; //激活当前sheet        
         //xlApp.Range(xlApp.Cells(1,10),xlApp.Cells(1,12)).MergeCells = true;
		 objSheet.Cells(1,14).value="( "+StDate+"至"+EndDate+" )";  //开始日期到结束日期
         //alert(objSheet.Cells(1,10).value)
             
         //设置工作薄名称  
         objSheet.name = "用药错误统计";  
         //设置表头  
         for (var i = 0; i < columns.length; i++) {  
         	objSheet.Cells(2, i+1).value = columns[i].title;  
         	//alert(columns.length)

         }  
         //设置内容部分  
         for (var i = 0; i < rows.length; i++) {  
         	//动态获取每一行每一列的数据值  
         	for (var j = 0; j < columns.length; j++) {    
            	//alert(rows.length)             
            	objSheet.Cells(i + 3, j+1).value = rows[i][columns[j].field];
         	} 
         	xlApp.Range(xlApp.Cells(rows.length+2, 2),xlApp.Cells(rows.length+2, 3)).MergeCells = true;     
      	 }                
         xlApp.Visible = false; //设置excel可见属性  true
         xlBook.SaveAs(filePath+"用药错误统计"+".xls");
		 xlApp=null;
		 xlBook.Close(savechanges=false);
		 objSheet=null;
            
          $.messager.alert("提示:","<font style='color:green;font-weight:bold;font-size:20px;'>导出完成！导出目录为:"+filePath+"</font>","info");
}  
 
 
 
 
 
 
