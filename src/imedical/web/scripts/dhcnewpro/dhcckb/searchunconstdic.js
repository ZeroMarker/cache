var dicArr = [{"value":"DrugPreMetData","text":'给药途径字典'},{"value":"DrugFreqData","text":'用药频率字典'}];

$(document).ready(function() {
	initCombobox();
   
    initButton();
    
    initdicGrid();       			 //加载统计数据 
   
})
//加载结果数据
function initdicGrid(){
	

	///  定义columns
	var columns=[[
		{field:"id",width:100,title:"id",hidden:false},	
		{field:"code",width:100,title:"项目代码"},
		{field:"desc",width:320,title:"项目描述"},
		{field:"type",width:100,title:"药品类型"}
	]];
	
	///  定义datagrid
	var option = {		
		bordr:false,
		//fit:true,
		//fitColumns:true,
		singleSelect:true,	
		nowrap: false,
		striped: true, 
		pagination:true,
		rownumbers:true,
		pageSize:3000,
		pageList:[3000,6000,9000],	
	 	onClickRow: function (rowIndex, rowData) {					        
 	 	}  
	};
	var dicType = $HUI.combobox("#dictype").getValue();
	var hospCode = $HUI.combobox("#hosp").getValue();
	var params = dicType +"^"+ hospCode;
	var uniturl =  $URL+"?ClassName=web.DHCCKBSearchconDic&MethodName=QueryNewDicList&params="+params;
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
	var dicType = $HUI.combobox("#dictype").getValue();
	var hospCode = $HUI.combobox("#hosp").getValue();
	var params = dicType +"^"+ hospCode;
	var name = ""
	if (dicType == "DrugPreMetData"){
		name = "给药途径字典"
	}
	if (dicType == "DrugFreqData"){
		name = "用药频率字典"
	}
	
	var rtn = $cm({
		dataType:'text',
		ResultSetType:"Excel",
		ExcelName: name+"新增字典数据", //默认DHCCExcel
		ClassName:"web.DHCCKBSearchconDic",
		QueryName:"ExportNewDicList",
		params:params 
	},false);
	//web.Util.Menu SelectGroupMenu
	location.href = rtn;
	
	return;
	var rtn = tkMakeServerCall("websys.Query","ToExcel","新增字典数据.csv","web.DHCCKBSearchconDic","ExportNewDicList",params);
	location.href = rtn;	

}
