
//����	DHCPENoCheckItem.hisui.js
//����	δ����Ŀ��ѯ
//����	2019.06.10
//������  xy

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
        
    //��ѯ
	$("#BFind").click(function() {	
		BFind_click();		
        });
     
     //����
	$("#BClear ").click(function() {	
		BClear_click();		
        });

       //��������
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
		//displayMsg:"",//���ط�ҳ���������"��ʾ��ҳ����ҳ,������������"
		singleSelect: false,
		checkOnSelect: true, //���Ϊfalse, ���û����ڵ���ø�ѡ���ʱ��Żᱻѡ�л�ȡ��
		selectOnCheck: true,
		toolbar: [],
		queryParams:{
			ClassName:"web.DHCPE.StationOrder",
			QueryName:"StationOrderList",
		},
		columns:[[
			{title:'ѡ��',field:'Select',width:60,checkbox:true},
			{field:'STORD_ARCIM_DR',title:'ARCIMDR',hidden: true},
			{field:'STORD_ARCIM_Desc',width:'230',title:'����'},
			{field:'STORD_ARCIM_Code',width:'120',title:'����'},
			
					
		]],
		
	//ȡ��ѡ���к���	
	onUncheck:function(rowIndex,rowData){
				GetSelectIds();
			},
			
	//ѡ���к���
	onCheck:function(rowIndex,rowData){
				GetSelectIds();
			},		
			
	})
}


// ��ȡ��Ŀ 
function GetSelectIds(){
	var SelectIds=""
	var selectrow = $("#ItemListTab").datagrid("getChecked");//��ȡ�������飬��������
	
	for(var i=0;i<selectrow.length;i++){
		SelectIds =SelectIds+selectrow[i].STORD_ARCIM_DR+"^";
		
	}
	if (""!=SelectIds) { SelectIds="^"+SelectIds; }
	$("#OEList").val(SelectIds);
	
}

//��ѯ
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


//����
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

//��������
function BExport_click(){
	try{
		
		var prnpath=tkMakeServerCall("web.DHCPE.Report.MonthStatistic","getpath");
	    var Templatefilepath=prnpath+'DHCPENoCheckItem.xlsx';
	   
	    xlApp = new ActiveXObject("Excel.Application"); //�̶�
	    xlApp.UserControl = true;
        xlApp.visible = true; 
		xlBook = xlApp.Workbooks.Add(Templatefilepath); //�̶�
		xlsheet = xlBook.WorkSheets("Sheet1"); //Excel�±������
		
		var iBeginDate="",iEndDate="";
    	var iBeginDate=$("#DateFrom").datebox('getValue');
		var iEndDate=$("#DateTo").datebox('getValue');
	 	if (iEndDate==""){ iEndDate=EndDate();}
	 	
		xlsheet.cells(1,1)=iBeginDate+"--"+iEndDate+"δ����Ŀͳ��";
		
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
			{field:'TPatName',width:'120',title:'����'},
			{field:'TRegNo',width:'120',title:'�ǼǺ�'},
			{field:'TRegDate',width:'120',title:'�Ǽ�����'},
			{field:'ItemDesc',width:'300',title:'δ����Ŀ'},
			{field:'StatDesc',width:'80',title:'״̬'},
			{field:'TFactPrice',width:'120',title:'���',align:'right'},
				
		]],
			
	})
}



function InitCombobox(){	
	
	//����
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
			{field:'GBI_RowId',title:'����ID',width:80},
			{field:'GBI_Desc',title:'��������',width:140},
			{field:'GBI_Code',title:'�������',width:100},

		]]
		})

	//δ��״̬
	var NoCheckStatusObj = $HUI.combobox("#NoCheckStatus",{
		valueField:'id',
		textField:'text',
		panelHeight:'100',
		data:[
            {id:'��ʵ',text:'��ʵ'},
            {id:'л�����',text:'л�����'},
           
        ]

	});

}