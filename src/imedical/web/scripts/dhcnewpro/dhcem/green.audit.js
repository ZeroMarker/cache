/// Creator:    hxy
/// CreateDate: 2022-07-15
$(document).ready(function() {
			
	initCombobox();
	
	initDateBox();
	
	initDatagrid()
	
	initMethod();
	
	initPage();
		
});

function initPage(){
	if(GREENAUDIT!="1"){
		$("#AUDITO").css("display","none");
		$("#AUDITT").css("display","none");
		$HUI.linkbutton("#P").disable();
		$HUI.linkbutton("#R").disable();
		$HUI.linkbutton("#C").disable();
	}else{
		$("#AUDITO").css("display","inline");
		$("#AUDITT").css("display","inline");
		$HUI.linkbutton("#P").enable();
		$HUI.linkbutton("#R").enable();
		$HUI.linkbutton("#C").enable();
	}
}

///初始化combobox
function initCombobox(){
	//医院
	$HUI.combobox("#hosp",{
		url:LINK_CSP+"?ClassName=web.DHCEmPatGreenRecAudit&MethodName=GetHosps&UserId="+LgUserID,
		valueField:'id',
		textField:'text',
		editable:false,
		panelHeight:'auto',
		onSelect:function(option){
	       
	    }	
	})
	$('#hosp').combobox('setValue',LgHospID);
	
}

///初始化事件控件
function initDateBox(){
	$HUI.datebox("#startDate").setValue(formatDate(-1));
	$HUI.datebox("#endDate").setValue(formatDate(0));
}

///绑定方法
function initMethod(){
	$('#regno').bind('keypress',function(event){
        if(event.keyCode == "13")    
        {
            RegNoBlur();
            search();
        }
    });	
    
    $('#name').bind('keypress',function(event){
        if(event.keyCode == "13")    
        {
            search();
        }
    });	
    
    //查找按钮导出按钮 保存按钮
    $("#searchBtn").on('click',function(){	
		search();
	})
	
}

function initDatagrid(){
	var columns = [[
        {field: 'select',title: '选择',checkbox: true},
        {field: 'Name',title: '姓名'},
        {field: 'RegNo',title: '登记号',formatter:formRegNo},
        {field: 'Loc',title: '科室'},
        {field: 'AdmDateTime',title: '就诊时间'},
        {field: 'GreenSta',title: '绿色通道状态'},
        {field: 'ThreeNo',title: '三无'},
        {field: 'AuditSta',title: '审核状态',formatter:formAuditSta},
        {field: 'DateTime',title: '申请时间'},
        {field: 'Hours',title: '申请时长(h)'},
        {field: 'Reason',title: '申请原因'},
        {field: 'User',title: '申请人'},
        {field: 'AuditUser',title: '审核人'},
        {field: 'AuditDateTime',title: '审核时间'} 
    ]]
        
	$HUI.datagrid('#Table',{
		url: 'dhcapp.broker.csp?ClassName=web.DHCEmPatGreenRecAudit&MethodName=List',
		fit:true,
		fitColumns:true,
		rownumbers:true,
		columns:columns,
		pageSize:60,  
		pageList:[60], 
		loadMsg: '正在加载信息...',
		rownumbers : false,
		pagination:true,
		singleSelect:false,
		selectOnCheck: true,
		checkOnSelect: true,
		title:'', //绿色通道申请查询
		toolbar:'#toolbar',
		iconCls:'icon-paper',
		headerCls:'panel-header-gray',
		queryParams:{
			Params:getParams()
		},
		onDblClickRow:function(index,row){
			//linkToCsp(row.AdmID,row.ChkID);
		},
		onLoadSuccess:function(data){
		}
    })
    
    var columns=[[
		{ field: 'User',align: 'center', title: '审核人',width:150},
		{ field: 'DateTime',align: 'center', title: '审核时间',width:150},
		{ field: 'Sta',align: 'center', title: '审核状态',width:150},
	]];
	
	///审核明细
	$HUI.datagrid("#DetailTable",{
		url:LINK_CSP+"?ClassName=web.DHCEmPatGreenRecAudit&MethodName=AuditList",
		queryParams:{
			Params:""
		},
		fit:true,
		rownumbers:true,
		columns:columns,
		fitColumns:true,
		pageSize:20,  
		pageList:[20,40,60], 
	    singleSelect:true,
		loadMsg: $g('正在加载信息...'),
		pagination:true
	})
	
}

///补零方法
function RegNoBlur()
{
	var i;
    var regno=$('#regno').val();
    var oldLen=regno.length;
    if (oldLen==8) return;
	if (regno!="") {
	    for (i=0;i<10-oldLen;i++)
	    {
	    	regno="0"+regno;
	    }
	}
    $("#regno").val(regno);
}

///查找按钮
function search(){
	
	$HUI.datagrid('#Table').load({
		Params:getParams()
	})
	return ;

}

///获取Params
function getParams(){
	var HospID=$('#hosp').combobox('getValue');
	if(HospID==undefined)HospID="";
	var startDate=$HUI.datebox("#startDate").getValue();
	var endDate=$HUI.datebox("#endDate").getValue();
	var name=$("#name").val();
	var regno=$("#regno").val();
	var AuditFlag=$("input[name='AuditFlag']:checked").val();
	if(AuditFlag==undefined)AuditFlag="";
	var Params=HospID+"^"+startDate+"^"+endDate+"^"+name+"^"+regno+"^"+AuditFlag;
	return Params;
}

///审核
function Audit(Status){
	
	var selItems = $('#Table').datagrid('getSelections');
	if (!selItems.length){
		$.messager.alert("提示:","请选中行,重试！");
		return;
	}
	var ParRefS="";
	var AuditedFlag=""; //存在已审的标志
	var CancelFlag="";  //存在撤销审核的标志
	var NoAdmFlag="";   //存在未挂号的标志
	var UnAuditFlag=""; //存在待审的标志
	var FailureFlag=""; //存在失效标志
	$.each(selItems, function(index, item){
		var ID=item.ID;
		if(ParRefS==""){
			ParRefS=ID;
		}else{
			ParRefS=ParRefS+"$$"+ID;
		}
		if(item.AuditedFlag=="Y"){
			AuditedFlag="1";
		}
		if(item.AuditedFlag=="N"){
			UnAuditFlag="1";
		}
		if(item.AuditSta==$g("撤销审核")){
			CancelFlag="1";
		}
		if(item.AdmID==""){
			NoAdmFlag="1";
		}
		if(item.GreenSta==$g("失效")){
			FailureFlag="1";
		}
	})
	if ((AuditedFlag=="1")&&(Status!="C")){
		$.messager.alert("提示:","所选报告存在已审核记录，不能审核！");
		return;
	}
	if ((CancelFlag=="1")&&(Status=="C")){
		$.messager.alert("提示:","所选报告存在撤销审核记录，不需撤销审核！");
		return;
	}
	if ((UnAuditFlag=="1")&&(Status=="C")){
		$.messager.alert("提示:","所选报告存在待审核记录，不需撤销审核！");
		return;
	}
	if (NoAdmFlag=="1"){
		$.messager.alert("提示:","所选报告存在未挂号记录，不能审核！");
		return;
	}
	if((FailureFlag=="1")&&((Status=="P")||(Status=="R"))){
		if(selItems.length==1){
			$.messager.alert("提示:","此申请已失效，请重新提交申请！");
		}else{
			$.messager.alert("提示:","存在已失效记录，请重新选择待审核记录！");
		}
		return;
	}
	
	$m({
		ClassName:"web.DHCEmPatGreenRecAudit",
		MethodName:"InsAuditS",
		ParRefS:ParRefS,
		Creator:LgUserID,
		Status:Status,
		LgGrp:LgGroupID
	},function(txtData){
		if(txtData==1){
			$.messager.alert("提示:","非最新申请记录，不能撤销审核！");
			return;
		}
		if(txtData=="-2"){
			$.messager.alert("提示:","不能撤销他人审核记录！");
			return;
		}
		if(txtData!=0){
			$.messager.alert('提示','审核失败')
		}else{
			$("#Table").datagrid('reload');
			$("#Table").datagrid("uncheckAll");
		}
	});
	
}

function formAuditSta(value, rowData, rowIndex){
	return '<a style="text-decoration:none" href="#" onclick="ShowDetail(\''+rowData.ID+'\')">&nbsp;'+value+'&nbsp;</a>';
}

///查询明细
function ShowDetail(value){	
	$HUI.datagrid("#DetailTable").load({"Params":value});	
	$HUI.window("#DetailWin").open();
}

function linkToCsp(EpisodeID,EmPCLvID){
	var lnk = "dhcem.emerpatientinfom.csp?EpisodeID="+ EpisodeID+"&EmPCLvID="+EmPCLvID;
	var blankWidth="",blankHeight="";
	if(window.top==window.self){
		blankWidth = $(window).width();
		blankHeight = $(window).height();
	}else{
		blankWidth = $(window.parent).width();
		blankHeight = $(window.parent).height();
	}
	websys_showModal({ //hxy 2022-11-17 st
		url: lnk,
		width:(blankWidth-20),
		height:(blankHeight-180),
		iconCls:"icon-w-paper",
		title: $g('患者分诊信息'),
		closed: true,
		onClose:function(){}
	});
//	var leftW=(screen.availWidth-(blankWidth-20))/2;
//	var topw=(screen.availHeight-(blankHeight-180))/2;
//	window.open(lnk,"_blank","top="+topw+",left="+leftW+",width="+(blankWidth-20)+"px,height="+(blankHeight-180)+"px,menubar=yes,scrollbars=yes,toolbar=no,status=no");//ed
}

//登记号弹窗 hxy 2022-08-31
function formRegNo(value, rowData, rowIndex){
	var AdmID=rowData.AdmID;
	var ChkID=rowData.ChkID;
	return '<a style="text-decoration:none" href="#" onclick="linkToCsp(\''+AdmID+'\',\''+ChkID+'\')">'+value+'</a>';
}