var dicArr = [{"value":"西药","text":'西药'},{"value":"中成药","text":'中成药'},{"value":"草药","text":'草药'}];

$(document).ready(function() {
	initCombobox();
   
    initButton();
    
    initdicGrid();       			 //加载统计数据 
   
})
//加载结果数据
function initdicGrid(){
	

	///  定义columns
	var columns=[[
		{field:"itmmastId",width:100,title:"itmmastId",hidden:false},
		{field:"type",width:100,title:"药品类型"},
		{field:"drugCode",width:100,title:"药品代码"},
		{field:"drugDesc",width:320,title:"药品描述"},
		{field:"dosform",width:100,title:"剂型"},
		{field:"manufact",width:150,title:"生产厂商"},
		{field:"specificat",width:150,title:"规格"},
		{field:"commonname",width:200,title:"通用名"},
		{field:"tradename",width:120,title:"商品名",hidden:true},
		{field:"remark",width:180,title:"批准文号"}
	]];
	
	///  定义datagrid
	var option = {
		fitColumn:true,
		rownumbers : true,
		singleSelect : true,
		remoteSort:false,
		//fit : true,
		pageSize : [3000],
		pageList : [3000,6000,9000],
	 	onClickRow: function (rowIndex, rowData) {
					        
 	 	}  
	};
	var dicType = $HUI.combobox("#dictype").getValue();
	var hospCode = $HUI.combobox("#hosp").getValue();
	var params = dicType +"^"+ hospCode;
	var uniturl =  $URL+"?ClassName=web.DHCCKBSearchconDic&MethodName=QueryDrugList&params="+params;
	new ListComponent('maingrid', columns, uniturl, option).Init();

}

///查询字典
function Query()
{
	var dicType = $HUI.combobox("#dictype").getValue();
	var hospCode = $HUI.combobox("#hosp").getValue();
	var params = dicType +"^"+ hospCode;
	$("#maingrid").datagrid('load',{'params':params});

}

///初始化combobox
function initCombobox()
{
	$HUI.combobox("#dictype",{
		data:dicArr,
		valueField:'value',
		textField:'text',
		panelHeight:"160",
		mode:'remote',
		onSelect:function(ret){
			//Query();
		 }
	})	
	
	var uniturl = $URL+"?ClassName=web.DHCCKBSearchconDic&MethodName=GetHosp"  

	$HUI.combobox("#hosp",{
		url:uniturl,
		valueField:'value',
		textField:'text',
		panelHeight:"160",
		mode:'remote',
		onSelect:function(ret){
			
		}
	})	
	
	$HUI.combobox("#hosp").setValue(LgHospID)
	
}


///查询
function initButton()
{
	$('#find').bind("click",Query);
	
	$('#export').bind("click",exportList);
}

///导出
function exportList()
{
	var datas = $('#maingrid').datagrid("getData");
	exportData(datas.rows);
}
function exportData(datas)
{
	
	var stDate = "2021-06-24";
	var endDate = "2021-06-24";
	
	if(datas.length==0){
		$.messager.alert("提示","无需导出数据！");
		return;	
	}
	
	//var Str = "(function test(x){"+
	var xlApp = new ActiveXObject('Excel.Application');
	var xlBook = xlApp.Workbooks.Add();
	var objSheet = xlBook.ActiveSheet;
	var beginRow=2;
	var colNuber=0;;
	for (var i=0;i<datas.length;i++){
		colNuber=0;
		objSheet.Cells(i+beginRow+1,(colNuber+=1)).value=datas[i].type; 		//类型
		objSheet.Cells(i+beginRow+1,(colNuber+=1)).value=datas[i].drugCode; 			//药品代码
		objSheet.Cells(i+beginRow+1,(colNuber+=1)).value=datas[i].drugDesc;	//品描述
		
		objSheet.Cells(i+beginRow+1,(colNuber+=1)).value=datas[i].dosform;	//剂型
		objSheet.Cells(i+beginRow+1,(colNuber+=1)).value=datas[i].manufact;			//厂商
		objSheet.Cells(i+beginRow+1,(colNuber+=1)).value=datas[i].specificat;	 	//规格
		objSheet.Cells(i+beginRow+1,(colNuber+=1)).value=datas[i].commonname;	//通用名
		objSheet.Cells(i+beginRow+1,(colNuber+=1)).value=datas[i].remark;	//批准文号
	}
	
	colNuber=0;
	objSheet.Cells(beginRow,1).value='药品类型';   //药品类型
	objSheet.Cells(beginRow,2).value='药品代码'; 	 	   //药品代码

	objSheet.Cells(beginRow,3).value='药品名称';	   //药品名称
	
	objSheet.Cells(beginRow,4).value='剂型';		   //剂型
	objSheet.Cells(beginRow,5).value='生产厂商';			   //生产厂商
	objSheet.Cells(beginRow,6).value='规格';	 		       //规格
	objSheet.Cells(beginRow,7).value='通用';		   //通用名
	objSheet.Cells(beginRow,8).value='批准文号';		   //批准文号
	
	xlApp.Range(xlApp.Cells(1,1),xlApp.Cells(1,8)).MergeCells = true;
	//objSheet.Cells(1,1).value= '统计时间:"+stDate+"至"+endDate+"';
	
	gridlistDetail(objSheet,beginRow,datas.length+beginRow,1,8)
	
	xlApp.Visible=true;
	xlApp=null;
	xlBook=null;
	objSheet=null;
    //"return 1;}());";
    //以上为拼接Excel打印代码为字符串
    //CmdShell.notReturn = 1;   //设置无结果调用，不阻塞调用
	//var rtn = CmdShell.EvalJs(Str);   //通过中间件运行打印程序 
	return;
}


function gridlistDetail(objSheet,row1,row2,c1,c2)
{
	objSheet.Range(objSheet.Cells(row1, c1), objSheet.Cells(row2,c2)).Borders(1).LineStyle=1;
	objSheet.Range(objSheet.Cells(row1, c1), objSheet.Cells(row2,c2)).Borders(1).Weight=2
	objSheet.Range(objSheet.Cells(row1, c1), objSheet.Cells(row2,c2)).Borders(2).LineStyle=1;
	objSheet.Range(objSheet.Cells(row1, c1), objSheet.Cells(row2,c2)).Borders(2).Weight=2
	objSheet.Range(objSheet.Cells(row1, c1), objSheet.Cells(row2,c2)).Borders(3).LineStyle=1;
	objSheet.Range(objSheet.Cells(row1, c1), objSheet.Cells(row2,c2)).Borders(3).Weight=2
	objSheet.Range(objSheet.Cells(row1, c1), objSheet.Cells(row2,c2)).Borders(4).LineStyle=1; 
	objSheet.Range(objSheet.Cells(row1, c1), objSheet.Cells(row2,c2)).Borders(4).Weight=2
}