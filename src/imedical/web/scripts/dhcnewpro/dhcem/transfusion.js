/// Creator: huaxiaoying
/// CreateDate: 2016-08-15
$(document).ready(function() {
			
	initCombobox();
	
	initDateBox();
	
	initDatagrid()
	
	initMethod();
		
});

///绑定方法
function initMethod(){

    //查找按钮导出按钮 保存按钮
    $("#searchBtn").on('click',function(){	
		search();
	})
	
}

///初始化combobox
function initCombobox(){
	$(".prev").parent().css("visibility","hidden"); //隐藏

	//号别科室
	$HUI.combobox("#Loc",{
		url:LINK_CSP+"?ClassName=web.DHCEMConsultCom&MethodName=JsonLoc&HospID="+hosp,
		valueField:'value',
		textField:'text',
		mode:"remote",
		onSelect:function(option){
	       
	    }	
	})
	
}

///初始化事件控件
function initDateBox(){
	$HUI.datebox("#startDate").setValue(formatDate(0));
	$HUI.datebox("#endDate").setValue(formatDate(0));
}

function initDatagrid(){
	var columns = [[
        {field: 'seqNo',title: '序号',width:100},
        {field: 'admType',title: '就诊类型',width:100,formatter:function(value,row,index){
				if (value=='E'){
					return $g('急诊');
				}else if(value=='O'){
					return $g('门诊');
				}else{return "";}
			}//hxy 2022-12-12
		},
        {field: 'patCardNo',title: '卡号',width:100}, 
        {field: 'patName',title: '病人姓名',width:100}, 
        {field: 'patSeatNo',title: '座位号',width:100},
        {field: 'exeDate',title: '输液日期',width:100},
        {field: 'exeTime',title: '输液时间',width:100},
        {field: 'execNur',title: '执行护士',width:100},
        {field: 'tOrdDep',title: '就诊科室',width:100}
        ]]
	$HUI.datagrid('#Table',{
		url: 'dhcapp.broker.csp?ClassName=web.DHCEMPatientSeat&MethodName=ListTrans',
		fit:true,
		rownumbers:true,
		columns:columns,
		fitColumns:true,//hxy 2022-10-09
		pageSize:30,  
		pageList:[30,60], 
		loadMsg: $g('正在加载信息...'),
		rownumbers : false,
		pagination:true,
		singleSelect:true,
		selectOnCheck: false,
		checkOnSelect: false,
		title:$g('输液记录列表'), //hxy 2018-10-09 st
		toolbar:'#toolbar',
		iconCls:'icon-paper',
		headerCls:'panel-header-gray', //ed
		queryParams:{
			Params:getParams()
		},
		onLoadSuccess:function(data){

		}
    })
}

///查找按钮
function search(){
	
	$HUI.datagrid('#Table').load({Params:getParams()})
	return ;
}

///获取Params
function getParams(){
	var startDate=$HUI.datebox("#startDate").getValue();
	var endDate=$HUI.datebox("#endDate").getValue();
	var startTime=$HUI.timespinner('#startTime').getValue();
	var endTime=$HUI.timespinner('#endTime').getValue();
	var EMCheck="",OPCheck="";
	if($("#EMCheck").is(":checked")){
		EMCheck=1;
	}
	if($("#OPCheck").is(":checked")){
		OPCheck=1;
	}
	var Loc = $u($HUI.combobox('#Loc').getValue());
	var Params = startDate+"^"+endDate+"^"+startTime+"^"+endTime+"^"+locId+"^"+Loc+"^"+OPCheck+"^"+EMCheck+"^"+hosp;
	return Params;locId
}

function $u(){	
	if (arguments[0]== null || arguments[0]== undefined) return "" 
	return arguments[0];
}

