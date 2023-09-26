
//名称	DHCPENoCheckItem.hisui.js
//功能	未检项目查询
//创建	2019.06.10
//创建人  xy

$(function(){
			
	InitCombobox();
	
	InitItemListDataGrid();
	
	InitNoCheckItemDataGrid();  
     
    $("#RegNo").keydown(function(e) {
			
			if(e.keyCode==13){
				BFind_click();
			}
			
        });
    
    $("#PatName").keydown(function(e) {
			
			if(e.keyCode==13){
				BFind_click();
			}
			
        });
        
    //查询
	$("#BFind").click(function() {	
		BFind_click();		
        });
     
     //清屏
	$("#BClear ").click(function() {	
		BClear_click();		
        });

       //导出数据
	$("#BExport").click(function() { 
		BExport_click(); 
        });
 
 
})

function InitItemListDataGrid(){

	$HUI.datagrid("#ItemListTab",{
		url:$URL,
		fit : true,
		border : false,
		striped : true,
		fitColumns : false,
		autoRowHeight : false,
		rownumbers:true,
		pagination : true,  
		rownumbers : true,  
		pageSize: 20,
		pageList : [20,100,200],
		//displayMsg:"",//隐藏分页下面的文字"显示几页到几页,共多少条数据"
		singleSelect: false,
		checkOnSelect: true, //如果为false, 当用户仅在点击该复选框的时候才会被选中或取消
		selectOnCheck: true,
		toolbar: [],
		queryParams:{
			ClassName:"web.DHCPE.StationOrder",
			QueryName:"StationOrderList",
		},
		columns:[[
			{title:'选择',field:'Select',width:60,checkbox:true},
			{field:'STORD_ARCIM_DR',title:'ARCIMDR',hidden: true},
			{field:'STORD_ARCIM_Desc',width:'230',title:'名称'},
			{field:'STORD_ARCIM_Code',width:'120',title:'编码'},
			
					
		]],
		
	//取消选中行函数	
	onUncheck:function(rowIndex,rowData){
				GetSelectIds();
			},
			
	//选中行函数
	onCheck:function(rowIndex,rowData){
				GetSelectIds();
			},		
			
	})
}


// 获取项目 
function GetSelectIds(){
	var SelectIds=""
	var selectrow = $("#ItemListTab").datagrid("getChecked");//获取的是数组，多行数据
	
	for(var i=0;i<selectrow.length;i++){
		SelectIds =SelectIds+selectrow[i].STORD_ARCIM_DR+"^";
		
	}
	if (""!=SelectIds) { SelectIds="^"+SelectIds; }
	$("#OEList").val(SelectIds);
	
}

//查询
function BFind_click(){
	var RegNoLength=tkMakeServerCall("web.DHCPE.DHCPECommon","GetRegNoLength");
	iRegNo=$("#RegNo").val();
	if (iRegNo.length<RegNoLength && iRegNo.length>0) { 
			iRegNo=tkMakeServerCall("web.DHCPE.DHCPECommon","RegNoMask",iRegNo);
			$("#RegNo").val(iRegNo)
		};
	var GID=$("#GName").combogrid('getValue');
	if (($("#GName").combogrid('getValue')==undefined)||($("#GName").combogrid('getValue')=="")){var GID="";}
	$("#NoCheckItemTab").datagrid('load',{
			ClassName:"web.DHCPE.Query.ItemNoCheck",
			QueryName:"QueryOEItem",
			DateFrom:$("#DateFrom").datebox('getValue'),
		    DateTo:$("#DateTo").datebox('getValue'),
		    RegNo:$("#RegNo").val(),
		    PatName:$("#PatName").val(),
			GID:GID,
			OEList:$("#OEList").val(),
			NoCheckStatus:$("#NoCheckStatus").combobox('getValue')
		});	
}


//清屏
function BClear_click(){
	$("#DateFrom,#DateTo").datebox('setValue',"")
	$("#GName").combogrid('setValue',"")
	$("#RegNo,#PatName").val("")
	
}

function EndDate(){
   var s=""; 
 	var date = new Date(); 
    var y = date.getFullYear(); 
    var m = date.getMonth()+1; 
    var d = date.getDate(); 
    var dtformat=tkMakeServerCall("web.DHCPE.DHCPECommon","GetSYSDatefomat")
		if (dtformat=="YMD"){
			var s=y+"-"+m+"-"+d;
		}else if (dtformat=="DMY"){
			var s=d+"/"+m+"/"+y;
		} 
   return(s); 
}

//导出数据
function BExport_click(){
	try{
		
		var prnpath=tkMakeServerCall("web.DHCPE.Report.MonthStatistic","getpath");
	    var Templatefilepath=prnpath+'DHCPENoCheckItem.xlsx';
	   
	    xlApp = new ActiveXObject("Excel.Application"); //固定
	    xlApp.UserControl = true;
        xlApp.visible = true; 
		xlBook = xlApp.Workbooks.Add(Templatefilepath); //固定
		xlsheet = xlBook.WorkSheets("Sheet1"); //Excel下标的名称
		
		var iBeginDate="",iEndDate="";
    	var iBeginDate=$("#DateFrom").datebox('getValue');
		var iEndDate=$("#DateTo").datebox('getValue');
	 	if (iEndDate==""){ iEndDate=EndDate();}
	 	
		xlsheet.cells(1,1)=iBeginDate+"--"+iEndDate+"未检项目统计";
		
		var User=session['LOGON.USERID']
		var Rows=tkMakeServerCall("web.DHCPE.Query.ItemNoCheck","GetItemNoCheckRows",User);
		for (var i=1;i<=Rows;i++){
			var Datas=tkMakeServerCall("web.DHCPE.Query.ItemNoCheck","GetItemNoCheckData",User,i)

			var DayData=Datas.split("^");
			for (var iDayLoop=0;iDayLoop<DayData.length;iDayLoop++) {
				xlsheet.cells(i+2, iDayLoop+1)=DayData[iDayLoop];
			}

		} 
		xlsheet.Range(xlsheet.Cells(2,1),xlsheet.Cells(parseInt(Rows)+2,6)).Borders.LineStyle=1; 
		xlBook.Close(savechanges = true);
		xlApp.Quit();
		xlApp = null;
		xlsheet = null;

   	}
	catch(e)
	{
		alert(e+"^"+e.message);
	}

}

function InitNoCheckItemDataGrid(){
	 
	$HUI.datagrid("#NoCheckItemTab",{
		url:$URL,
		fit : true,
		border : false,
		striped : true,
		fitColumns : false,
		autoRowHeight : false,
		rownumbers:true,
		pagination : true,  
		rownumbers : true,  
		pageSize: 20,
		pageList : [20,100,200],
		singleSelect: true,
		selectOnCheck: true,
		queryParams:{
			ClassName:"web.DHCPE.Query.ItemNoCheck",
			QueryName:"QueryOEItem",  
		},
		columns:[[
		 	{field:'TPAADMDR',title:'PAADMDR',hidden: true},
			{field:'TPatName',width:'120',title:'姓名'},
			{field:'TRegNo',width:'120',title:'登记号'},
			{field:'TRegDate',width:'120',title:'登记日期'},
			{field:'ItemDesc',width:'300',title:'未检项目'},
			{field:'StatDesc',width:'80',title:'状态'},
			{field:'TFactPrice',width:'120',title:'金额',align:'right'},
				
		]],
			
	})
}



function InitCombobox(){	
	
	//团体
	var GroupNameObj = $HUI.combogrid("#GName",{
		panelWidth:350,
		url:$URL+"?ClassName=web.DHCPE.DHCPEGBaseInfo&QueryName=DHCPEGBaseInfoList",
		mode:'remote',
		delay:200,
		idField:'GBI_RowId',
		textField:'GBI_Desc',
		onBeforeLoad:function(param){
			param.Desc= param.q;
		},
		columns:[[
			{field:'GBI_RowId',title:'团体ID',width:80},
			{field:'GBI_Desc',title:'团体名称',width:140},
			{field:'GBI_Code',title:'团体编码',width:100},

		]]
		})

	//未检状态
	var NoCheckStatusObj = $HUI.combobox("#NoCheckStatus",{
		valueField:'id',
		textField:'text',
		panelHeight:'100',
		data:[
            {id:'核实',text:'核实'},
            {id:'谢绝检查',text:'谢绝检查'},
           
        ]

	});

}