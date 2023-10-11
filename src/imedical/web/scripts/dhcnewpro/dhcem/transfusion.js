/// Creator: huaxiaoying
/// CreateDate: 2016-08-15
$(document).ready(function() {
			
	initCombobox();
	
	initDateBox();
	
	initDatagrid()
	
	initMethod();
		
});

///�󶨷���
function initMethod(){

    //���Ұ�ť������ť ���水ť
    $("#searchBtn").on('click',function(){	
		search();
	})
	
}

///��ʼ��combobox
function initCombobox(){
	$(".prev").parent().css("visibility","hidden"); //����

	//�ű����
	$HUI.combobox("#Loc",{
		url:LINK_CSP+"?ClassName=web.DHCEMConsultCom&MethodName=JsonLoc&HospID="+hosp,
		valueField:'value',
		textField:'text',
		mode:"remote",
		onSelect:function(option){
	       
	    }	
	})
	
}

///��ʼ���¼��ؼ�
function initDateBox(){
	$HUI.datebox("#startDate").setValue(formatDate(0));
	$HUI.datebox("#endDate").setValue(formatDate(0));
}

function initDatagrid(){
	var columns = [[
        {field: 'seqNo',title: '���',width:100},
        {field: 'admType',title: '��������',width:100,formatter:function(value,row,index){
				if (value=='E'){
					return $g('����');
				}else if(value=='O'){
					return $g('����');
				}else{return "";}
			}//hxy 2022-12-12
		},
        {field: 'patCardNo',title: '����',width:100}, 
        {field: 'patName',title: '��������',width:100}, 
        {field: 'patSeatNo',title: '��λ��',width:100},
        {field: 'exeDate',title: '��Һ����',width:100},
        {field: 'exeTime',title: '��Һʱ��',width:100},
        {field: 'execNur',title: 'ִ�л�ʿ',width:100},
        {field: 'tOrdDep',title: '�������',width:100}
        ]]
	$HUI.datagrid('#Table',{
		url: 'dhcapp.broker.csp?ClassName=web.DHCEMPatientSeat&MethodName=ListTrans',
		fit:true,
		rownumbers:true,
		columns:columns,
		fitColumns:true,//hxy 2022-10-09
		pageSize:30,  
		pageList:[30,60], 
		loadMsg: $g('���ڼ�����Ϣ...'),
		rownumbers : false,
		pagination:true,
		singleSelect:true,
		selectOnCheck: false,
		checkOnSelect: false,
		title:$g('��Һ��¼�б�'), //hxy 2018-10-09 st
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

///���Ұ�ť
function search(){
	
	$HUI.datagrid('#Table').load({Params:getParams()})
	return ;
}

///��ȡParams
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

