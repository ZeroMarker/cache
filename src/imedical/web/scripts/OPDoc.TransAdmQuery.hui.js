var PageLogicObj={
	m_TransAdmTabDataGrid:"",
	m_selDeptRowId:"",
	m_PatientNoLength:10
};
$(function(){
	//初始化
	Init();
	//事件初始化
	InitEvent();
	//页面元素初始化
	PageHandle();
	//表格数据初始化
	TransAdmTabDataGridLoad();
});
function Init(){
	PageLogicObj.m_TransAdmTabDataGrid=InitTransAdmTabDataGrid();
}
function InitTransAdmTabDataGrid(){
	var Columns=[[ 
		//{field:'Tind',title:'序号',width:40},
		{field:'TransAdmType',title:'就诊类型',width:80},
		{field:'PatNo',title:'登记号',width:100},
		{field:'PatName',title:'病人姓名',width:100},
		{field:'AdmReasonDesc',title:'病人类型',width:80},
		{field:'AdmDepLoc',title:'转诊原科室',width:120},
		{field:'Tarcdesc',title:'转诊原号别',width:120},
		{field:'TUserDesc',title:'转诊人',width:100},
		{field:'TransDate',title:'转诊日期',width:100},
		{field:'TransTime',title:'转诊时间',width:100},
		{field:'TDepLocDesc',title:'转诊后科室',width:120},
		{field:'TFeeDocDesc',title:'转诊后医生(号别)',width:120}
    ]]
	var TransAdmTabDataGrid=$("#TransAdmTab").datagrid({
		fit : true,
		border : false,
		striped : true,
		singleSelect : true,
		fitColumns : false,
		autoRowHeight : false,
		pagination : true,  
		pageSize: 15,
		pageList : [15,100,200],
		idField:'Tind',
		columns :Columns,
		onClickRow:function(index, row){
			SetSelRowData(row);
		}
	});
	return TransAdmTabDataGrid;
}
function InitEvent(){
	$('#BFind').click(TransAdmTabDataGridLoad);
	$('#BClear').click(BClearClickHandle);
	$('#RegNo').keydown(RegNoKeydownHandler);
}
function PageHandle(){
	$("#FDate,#TDate").datebox('setValue',ServerObj.CurDate);
	InitLocLookUp();
	InitUserLookUp();
}
function TransAdmTabDataGridLoad(){
	if ($("#TLocDesc").lookup('getText')=="") PageLogicObj.m_selDeptRowId="";
	$.q({
	    ClassName : "web.TransAdmTest",
	    QueryName : "FindTransAdm",
	    FDate:$("#FDate").datebox('getValue'),
	    TDate:$("#TDate").datebox('getValue'),
	    RegNo:$("#RegNo").val(),
	    locid:PageLogicObj.m_selDeptRowId,
	    TUserName:$("#TUserName").lookup('getText'), PName:$("#PName").val(),
	    Pagerows:PageLogicObj.m_TransAdmTabDataGrid.datagrid("options").pageSize,rows:99999
	},function(GridData){
		PageLogicObj.m_TransAdmTabDataGrid.datagrid({loadFilter:DocToolsHUI.lib.pagerFilter}).datagrid('loadData',GridData);
	}); 
}
function InitLocLookUp(){
	$("#TLocDesc").lookup({
        url:$URL,
        mode:'remote',
        method:"Get",
        idField:'TLocRowid',
        textField:'TLocDesc',
        columns:[[  
            {field:'TLocRowid',title:'',hidden:true},
			{field:'TLocDesc',title:'科室名称',width:350}
        ]], 
        pagination:true,
        panelWidth:400,
        panelHeight:400,
        isCombo:true,
        minQueryLen:2,
        delay:'500',
        queryOnSameQueryString:false,
        queryParams:{ClassName: 'web.TransAdmTest',QueryName: 'SearchLoc'},
        onBeforeLoad:function(param){
	        var desc=param['q'];
			param = $.extend(param,{TLocDesc:desc, hospid:session['LOGON.HOSPID']});
	    },
	    onSelect:function(index, rec){
		    PageLogicObj.m_selDeptRowId=rec['TLocRowid'];
		    $("#TUserName").lookup('setText','');
		    TransAdmTabDataGridLoad();
		}
    });
}
function InitUserLookUp(){
	if ($("#TLocDesc").lookup('getText')=="") PageLogicObj.m_selDeptRowId="";
	$("#TUserName").lookup({
        url:$URL,
        mode:'remote',
        method:"Get",
        idField:'UserRowid',
        textField:'UserName',
        columns:[[  
            {field:'UserRowid',title:'',hidden:true},
			{field:'UserName',title:'名称',width:350}
        ]], 
        pagination:true,
        panelWidth:400,
        panelHeight:400,
        isCombo:true,
        minQueryLen:2,
        delay:'500',
        queryOnSameQueryString:true,
        queryParams:{ClassName: 'web.TransAdmTest',QueryName: 'FindUser'},
        onBeforeLoad:function(param){
	        var desc=param['q'];
	        if ($("#TLocDesc").lookup('getText')=="") PageLogicObj.m_selDeptRowId="";
			param = $.extend(param,{TUserName:desc, locid:PageLogicObj.m_selDeptRowId});
	    },onSelect:function(index, rec){
		    TransAdmTabDataGridLoad();
		}
    });
}
function BClearClickHandle(){
	$("#FDate,#TDate").datebox('setValue',ServerObj.CurDate),
	$("#RegNo,#PName").val('');
	PageLogicObj.m_selDeptRowId="";
	$("#TLocDesc,#TUserName").lookup('setText','');
	TransAdmTabDataGridLoad();
}
function RegNoKeydownHandler(e){
	var type=websys_getType(e);
	var key=websys_getKey(e);
	if ((type=='keydown')&&(key==13)) {
		var RegNo=$('#RegNo').val();
		if (RegNo!="") {
			if (RegNo.length<PageLogicObj.m_PatientNoLength) {
				for (var i=(PageLogicObj.m_PatientNoLength-RegNo.length-1); i>=0; i--) {
					RegNo="0"+RegNo;
				}
			}
			$("#RegNo").val(RegNo);
			TransAdmTabDataGridLoad();
		}
	}
}
function myformatter(date){
	var y = date.getFullYear();
	var m = date.getMonth()+1;
	var d = date.getDate();
	if (ServerObj.sysDateFormat=="3") return y+'-'+(m<10?('0'+m):m)+'-'+(d<10?('0'+d):d);
	else if (ServerObj.sysDateFormat=="4") return (d<10?('0'+d):d)+"/"+(m<10?('0'+m):m)+"/"+y
	else return y+'-'+(m<10?('0'+m):m)+'-'+(d<10?('0'+d):d);
}
function myparser(s){
    if (!s) return new Date();
    if(ServerObj.sysDateFormat=="4"){
		var ss = s.split('/');
		var y = parseInt(ss[2],10);
		var m = parseInt(ss[1],10);
		var d = parseInt(ss[0],10);
	}else{
		var ss = s.split('-');
		var y = parseInt(ss[0],10);
		var m = parseInt(ss[1],10);
		var d = parseInt(ss[2],10);
	}
	if (!isNaN(y) && !isNaN(m) && !isNaN(d)){
		return new Date(y,m-1,d);
	} else {
		return new Date();
	}
}