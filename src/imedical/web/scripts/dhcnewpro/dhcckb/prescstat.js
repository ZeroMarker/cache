
var curMonthLastDate = getCurMonthFirstDay();  //当月第一天
var flagcode = "";    //调用代码
$(function (){   

	initParams();  
	
	initCombobox();
	
	initDateBox();
	
	initTable();
    
	initMethod();
	
	flashTable(1);   //初始化默认查询  
})

function initCombobox(){
	
	$HUI.combobox("#HospID",{
		url:$URL+"?ClassName=web.DHCCKBCalculateval&MethodName=QueryHospList",  
    	valueField:'value',    
    	textField:'text',
    	mode: 'remote',
    	onShowPanel: function () { //数据加载完毕事件
			
	 	}
	})
	
}

///全局参数
function initParams(){
	excelData=[];  //导出数据
	DateFormat = "";   //日期格式
	runClassMethod("web.DHCEMCommonUtil","DateFormat",{},  //hxy 2017-03-07 日期格式走配置
	function(data){
		DateFormat = data;
	});	
	
	flagcode =  getParam("code"); 
}	

function initDateBox(){
	var stDate = "",endDate = "";
	if(flagcode == "day"){
		stDate = formatDate(0);
		endDate = formatDate(0);
	}else if(flagcode == "month"){
		stDate = curMonthLastDate;
		endDate = formatDate(0);
	}else{
		stDate = formatDate(0);
		endDate = formatDate(0);
	}
	$HUI.datebox("#startDate").setValue(stDate);
	$HUI.datebox("#endDate").setValue(endDate);
	
	
}
	
function initTable(){

    var columns= [[
    	{field: 'hosptialNum',title: '医疗机构',width:250,align:'center'},
		{field: 'auditNum',title: '处方审查数量',width:150,align:'center',sortable:'true'}, 
		{field: 'errNum',title: '处方风险数量',width:150,align:'center',sortable:'true'},
		{field: 'errRate',title: '风险比例',width:150,align:'center',sortable:'true'},
		{field: 'ordEnaNum',title: '正常',width:100,align:'center',sortable:'true'},
		{field: 'ordTipNum',title: '提醒',width:100,align:'center',sortable:'true'},
		{field: 'ordWarnNum',title: '警示',width:100,align:'center',sortable:'true'},
		{field: 'ordForNum',title: '禁止',width:100,align:'center',sortable:'true'},
		{field: 'date',title: '日期',width:300,align:'center'}
		]];
	
	$HUI.datagrid('#keptPatTable',{
		url:$URL+'?ClassName=web.DHCCKBPrescStatQuery&MethodName=QueryMesSummary',
		fit:true,
		rownumbers:true,
		columns:columns,
		pageSize:30,  
		pageList:[30,60,90], 
		loadMsg: '正在加载信息...',
		rownumbers : false,
		pagination:true,
		singleSelect:true,
		selectOnCheck: false,
		checkOnSelect: false,
		remoteSort:true,
		queryParams:{
			params:$HUI.datebox("#startDate").getValue() +"^"+ $HUI.datebox("#endDate").getValue() +"^"+ $HUI.combobox('#HospID').getValue(),
		},
		onDblClickRow:function(index,row){
		
		},
		onLoadSuccess:function(data){
			console.log(data)
		},
		rowStyler: function(index,row){
	        if (row.hosptialNum=='合计' ){
	            return 'color:white;font-weight:bold;background-color:#FF7239;';  
	            
	        }				
	    }
    })
	
}

///绑定方法
function initMethod(){
	$('#searchBtn').on('click',flashTable);

	$('#exportBtn').on('click',exportAll)
}



//刷新表格
function flashTable(){
	
	var hospID=$HUI.combobox('#HospID').getValue();
	var stdate=$HUI.datebox("#startDate").getValue();
    var eddate=$HUI.datebox("#endDate").getValue();
    if(stdate==''||eddate==""){
	   $.messager.alert('提示','日期不能为空'); 
	   return;
	}
	if(new Date(stdate.replace(/\-/g,'/'))>new Date(eddate.replace(/\-/g,'/'))){
		$.messager.alert('提示','开始日期不能早于结束日期'); 
	     return;
		
	}
	if(hospID!=""){
		$('#keptPatTable').datagrid("options").url = $URL+'?ClassName=web.DHCCKBPrescStatQuery&MethodName=QueryMesterState';		
	}
	else{
		
		$('#keptPatTable').datagrid("options").url = $URL+'?ClassName=web.DHCCKBPrescStatQuery&MethodName=QueryMesSummary';
				
	}
	var params = stdate +"^"+ eddate +"^"+ hospID;
	$HUI.datagrid('#keptPatTable').load({
        params:params
        
	})
	return;
}


function myFormatDate(date){
	if(date.indexOf("/")){
		dateArr = date.split("/");
		return dateArr[2]+"-"+dateArr[1]+"-"+dateArr[0];
	}else{
		return date;	
	}
}
function exportAll(){
	var stdate=$HUI.datebox("#startDate").getValue();
    var eddate=$HUI.datebox("#endDate").getValue();
    var exec=$("#exeRadio:checked").val()=="on"?"Y":"N";
	var params=$HUI.combobox('#HospID').getValue()+"^"+$HUI.combobox('#Area').getValue()+"^"+exec
	
	 runClassMethod("web.DHCCKBMonMaster","QueryMesterStat",{"page":1,"rows":99999,"stdate":stdate,"eddate":eddate,"params":params},function(data){
   		var strjData=data.rows;
   		exportData(strjData)
 	},'json')
}
function exportData(strjData){

	var htmlStr="<table  border='0' cellspacing='0' style='width:100%'>" ;
	htmlStr=htmlStr+'<tr><td style="font-size:30px;font-weight:bold;text-align:center;margin-top:20px;height:40px;" colspan="12">'+'安全用药统计'+'</td></tr>'
	htmlStr=htmlStr+"<tr><td>医疗机构</td>";
	htmlStr=htmlStr+"<td>区域</td>";
	htmlStr=htmlStr+"<td>处方审查数量</td>";
	htmlStr=htmlStr+"<td>处方风险数量</td>";
	htmlStr=htmlStr+"<td>风险比例</td>";
	htmlStr=htmlStr+"<td>日期</td></tr>";
	
	for (i=1;i<=strjData.length;i++)
	{		   
		
	    htmlStr=htmlStr+"<tr><td>"+strjData[i-1].hosptialNum+"</td>";
	    htmlStr=htmlStr+"<td>"+strjData[i-1].CMArea+"</td>";
	    htmlStr=htmlStr+"<td>"+strjData[i-1].auditNum+"</td>";
	    htmlStr=htmlStr+"<td>"+strjData[i-1].errNum+"</td>";
	    htmlStr=htmlStr+"<td>"+strjData[i-1].errRate+"</td>";
	    htmlStr=htmlStr+"<td>"+strjData[i-1].date+"</td></tr>";
	    

	}
	htmlStr=htmlStr+"</table>";
	ExportTableToExcel("安全用药统计导出",htmlStr)
	
	
}
function getCurMonthFirstDay(){
    var curDate = new Date();
    var y = curDate.getFullYear();
    var m = curDate.getMonth()+1 ;//本身就得+1才等于当前月份
    return y + '-' + (m < 10 ? '0'+m : m) + '-' + '01';
 
}