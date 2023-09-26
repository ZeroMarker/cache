/*
模块:门诊药房
子模块:门诊药房-首页-侧菜单-门诊基数药品维护
createdate:2016-06-23
creator:yunhaibao
*/
var commonOutPhaUrl = "DHCST.OUTPHA.ACTION.csp";
var url = "dhcpha.outpha.addbasemed.action.csp";
var gLocId=session['LOGON.CTLOCID'];
var gUserId=session['LOGON.USERID'];
var gGroupId=session['LOGON.GROUPID']; 
$(function(){
	/// 初始化医生科室	
	var options={
		url:commonOutPhaUrl+'?action=GetCtLocDs'
	}
	$('#docLoc').dhcphaEasyUICombo(options);
	/// 初始化使用科室
	var options={
		url:commonOutPhaUrl+'?action=GetCtLocDs'
	}
	$('#useLoc').dhcphaEasyUICombo(options);
	/// 初始化使用科室
	var options={
		url:commonOutPhaUrl+'?action=GetInstuDs'
	}
	$('#instu').dhcphaEasyUICombo(options);
	/// 初始化药品
	InitCmgArcItm();
	
	InitBaseMedGrid();	
	$('#basemedgrid').datagrid('reload');
	$('#btnDelete').bind('click',btnDeleteHandler);//点击删除
	$('#btnClear').bind('click',btnClearHandler);//点击删除
	$('#btnAdd').bind('click', btnAddHandler);//点击增加
	$('#btnUpdate').bind('click',btnUpdateHandler);//点击修改
});
function InitCmgArcItm(){
    var tmpOptions={
	    url:"DHCST.QUERY.JSON.csp?Plugin=EasyUI.DataGrid&"+
				 "ClassName=web.DHCST.ARCITMMAST&QueryName=GetArcItmMast"+
				 "&StrParams="+"|@|",
	    columns: [[
			{field:'arcItmRowId',title:'arcItmRowId',width:100,sortable:true,hidden:true},
			{field:'arcItmCode',title:'药品代码',width:100,sortable:true},
			{field:'arcItmDesc',title:'药品名称',width:300,sortable:true}
	    ]],
		idField:'arcItmRowId',
		textField:'arcItmDesc',
		mode:"remote",
		pageSize:30, 
		pageList:[30,50,100],  
		pagination:true,
		panelWidth:500,
		onBeforeLoad: function(param) {
            param.StrParams = param.q;
        },
		onLoadSuccess:function(data) {
			/*
			LoadTimes=LoadTimes+1;
			if (LoadTimes==1){
				if (arcItmRowId!=""){
					$("#cmbLinkDict").combogrid("setValue",arcItmRowId);
				}else{
					$("#cmbLinkDict").combogrid("clear");
				}
			}
			*/
		}
    }
	$("#cmgArcItm").combogrid(tmpOptions);
}
//初始化基数药品grid
function InitBaseMedGrid(){
	//定义columns
	var columns=[[
        {field:'Tarcitm',title:'药品名称',width:275},
        {field:'Tinst',title:'用法',width:190},
        {field:'Tdocloc',title:'医生科室',width:220},
        {field:'Tuseloc',title:'使用科室',width:220},
		{field:'Tnote',title:'备注',width:200},
        {field:'Tphbr',title:'Tphbr',width:150,hidden:true},
        {field:'Tinstrowid',title:'Tinstrowid',width:150,hidden:true},
        {field:'Tdoclocdr',title:'Tdoclocdr',width:150,hidden:true},
        {field:'Tuselocdr',title:'Tuselocdr',width:150,hidden:true},
        {field:'Tarcdr',title:'Tarcdr',width:150,hidden:true},
        {field:'Tinci',title:'Tinci',width:150,hidden:true}
	]];  
	
   //定义datagrid	
   $('#basemedgrid').datagrid({    
        url:url+'?action=QueryLocBaseMed',
        fit:true,
        striped:true,
	    border:false,
	    toolbar:'#btnbar',
	    singleSelect:true,
	    rownumbers:false,
        columns:columns,
        pageSize:50,  // 每页显示的记录条数
	    pageList:[50,100,300],   // 可以设置每页记录条数的列表
	    singleSelect:true,
	    loadMsg: '正在加载信息...',
	    fitColumns:false,
	    pagination:true,
	    onClickRow:function(rowIndex,rowData){
			if (rowData){
				var RowId=rowData['TRowId'];
				$("#remark").val(rowData["Tnote"]);
				$("#cmgArcItm").combogrid("setValue",rowData["Tarcdr"]);
				$("#cmgArcItm").combogrid("setText",rowData["Tarcitm"]);
				$("#instu").combobox('setValue',rowData["Tinstrowid"]);
				$("#docLoc").combobox('setValue',rowData["Tdoclocdr"]);
				$("#useLoc").combobox('setValue',rowData["Tuselocdr"]);
			}
		}   
   });
}

///增加
function btnAddHandler(){
	var remark=$("#remark").val();
	var arcim=$("#cmgArcItm").combogrid("getValue")||"";
	if (arcim==""){
		$.messager.alert('提示',"请录入药品名称!","info");
		return;
	}
	var instu=$("#instu").combobox('getValue');
	if  ($.trim($("#instu").combobox('getText'))==""){
		instu="";
	}
	var docloc=$("#docLoc").combobox('getValue');
	if  ($.trim($("#docLoc").combobox('getText'))==""){
		docloc="";
	}
	if (docloc==""){
		$.messager.alert('提示',"请选择医生科室!","info");
		return;
	}
	var useloc=$("#useLoc").combobox('getValue');
	if  ($.trim($("#useLoc").combobox('getText'))==""){
		useloc="";
	}
	if (useloc==""){
		$.messager.alert('提示',"请选择使用科室!","info");
		return;
	}
    var returnValue= tkMakeServerCall("web.DHCOutPhAddBaseMed","AddBaseMed",arcim,instu,docloc,useloc,remark);
    if(returnValue==0){
	    $.messager.alert('提示',"不允许添加重复数据!","info");
	    return;
    }else if (returnValue>0){
	    $('#basemedgrid').datagrid('reload');
	    btnClearHandler();
    }
}


///删除
function btnDeleteHandler(){
	var seletcted = $("#basemedgrid").datagrid("getSelected");
	if (seletcted==null){
		$.messager.alert('提示',"请先选择需要删除的记录!","info");
		return;
	}
	var phbr=seletcted["Tphbr"];
	$.messager.confirm('提示',"确认删除吗？",function(r){
		if(r){
			var retValue=tkMakeServerCall("web.DHCOutPhAddBaseMed","DelBaseMed",phbr);
			if(retValue==0){
				$('#basemedgrid').datagrid('reload');
				btnClearHandler();
			}
			else{
				$.messager.alert('提示',"删除失败,错误代码:"+retValue,"error");
			}
		}
	});
}
///修改
function btnUpdateHandler(){
	var seletcted = $("#basemedgrid").datagrid("getSelected");
	if (seletcted==null){
		$.messager.alert('提示',"请先选择需要修改的记录!","info");
		return;
	}
	var remark=$("#remark").val();
	var arcim=$("#cmgArcItm").combogrid("getValue")||"";
	if (arcim==""){
		$.messager.alert('提示',"请录入药品名称!","info");
		return;
	}
	var instu=$("#instu").combobox('getValue');
	if  ($.trim($("#instu").combobox('getText'))==""){
		instu="";
	}
	var docloc=$("#docLoc").combobox('getValue');
	if  ($.trim($("#docLoc").combobox('getText'))==""){
		docloc="";
	}
	if (docloc==""){
		$.messager.alert('提示',"请选择医生科室!","info");
		return;
	}
	var useloc=$("#useLoc").combobox('getValue');
	if  ($.trim($("#useLoc").combobox('getText'))==""){
		useloc="";
	}
	if (useloc==""){
		$.messager.alert('提示',"请选择使用科室!","info");
		return;
	}
	var phbr=seletcted["Tphbr"];
    var returnValue= tkMakeServerCall("web.DHCOutPhAddBaseMed","UpdBaseMed",phbr,arcim,instu,docloc,useloc,remark);
    if (returnValue==0){
	    $('#basemedgrid').datagrid('reload');
	    btnClearHandler();
    }else if(returnValue==-2){
	    $.messager.alert('提示',"修改后的记录已存在!","info");
    }else {
	    $.messager.alert('提示',"修改失败,错误代码:"+returnValue,"error");
	}
}
///清空
function btnClearHandler(){
	$("input[name=txtCondition]").val("");
	$("#docLoc").combobox('setValue',"");
	$("#useLoc").combobox('setValue',"");
	$("#instu").combobox('setValue',"");
	$("#cmgArcItm").combogrid("clear");
	$("#cmgArcItm").combogrid("grid").datagrid("options").queryParams.q="";
	$("#cmgArcItm").combogrid("grid").datagrid("reload");
	$('#basemedgrid').datagrid('loadData',{total:0,rows:[]});
	$('#basemedgrid').datagrid({
     	url:url+'?action=QueryLocBaseMed',
     	queryParams:{
			params:""
		}
	});
}