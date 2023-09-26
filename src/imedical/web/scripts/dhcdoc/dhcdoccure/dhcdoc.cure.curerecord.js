var cureItemList;
var cureDCAAorderGrid;
var cureAppId="";
$(function(){
	var DCAARowId=$('#DCAARowId').val();
	var DCRRowId=$('#DCRRowId').val();
	if((DCAARowId=="")&&(DCRRowId==""))return;
	initCureRecordInfo()
	$('#btnSave').bind("click",function(){
		SaveCureRecord();	
	}); 
	IntDataGrid()
});
function Int()
{
	LoadGridData()
	
}
///加载预约记录对应的医嘱
function LoadGridData(){
	
	var DCAARowId=$('#DCAARowId').val();
	try{
	var queryParams = new Object();
	queryParams.ClassName ='DHCDoc.DHCDocCure.Apply';
	queryParams.QueryName ='FindOrder';
	queryParams.Arg1 =DCAARowId;
	queryParams.ArgCnt =1;
	var opts = cureDCAAorderGrid.datagrid("options");
	opts.url = "./dhcdoc.cure.query.grid.easyui.csp"
	cureDCAAorderGrid.datagrid('load', queryParams);
	cureDCAAorderGrid.datagrid('unselectAll');
	}catch(e){}	
}

function initCureRecordInfo(){
	var DCRRowId=$('#DCRRowId').val();
	//alert(DCRRowId);
	var ret=tkMakeServerCall("DHCDoc.DHCDocCure.Record","GetCureRecord",DCRRowId);
	if (ret=="") return;
	var TempArr=ret.split("^");
	var DCRTitle=TempArr[2];
	var DCRContent=TempArr[3];
	var CreateUser=TempArr[5];
	var CreateDate=TempArr[6];
	var UpdateUser=TempArr[8];
	var UpdateDate=TempArr[9];
	$("#DCRTitle").val(DCRTitle);
	$("#DCRContent").val(DCRContent);
	$("#CreateUser").prop("innerText",CreateUser);
	$("#CreateDate").prop("innerText",CreateDate);
	$("#UpdateUser").prop("innerText",UpdateUser);
	$("#UpdateDate").prop("innerText",UpdateDate);
}
function SaveCureRecord()
{
    
    var OperateType=$('#OperateType').val();
    if(OperateType!="ZLYS")
    {
	    alert("只有治疗医师才可修改治疗记录");
		return; 
	}
    var DCAARowId=$('#DCAARowId').val();
    var DCRRowId=$("#DCRRowId").val();
    if((DCAARowId=="")&&(DCRRowId==""))
    {
	   alert("请选择一条预约记录或者一条治疗记录");
	   return; 
	}
	var DCRTitle=$("#DCRTitle").val();
	if (DCRTitle=="")
	{
		alert("治疗标题不能为空");
		return;
	}
	var DCRContent=$("#DCRContent").val();
	if (DCRContent=="")
	{
		alert("治疗记录不能为空");
		return;
	}
	//获取提示信息
	var AlertMesag=tkMakeServerCall("DHCDoc.DHCDocCure.Record","GetAlertMesage",DCAARowId);
	if (AlertMesag!=""){
		alert(AlertMesag);
	}
	
	var Para=DCRRowId+"^"+DCAARowId+"^"+DCRTitle+"^"+DCRContent+"^"+session['LOGON.USERID'];
	var ret=tkMakeServerCall("DHCDoc.DHCDocCure.Record","SaveCureRecord",Para);
	if(ret==0)
	{
		alert('保存成功');
	}else{
		var err=""
		if (ret==100) err=""
		else if (ret==100) err=",新增治疗记录,必须选择一条预约记录"
		else if (ret==101) err=",一条预约记录仅限开添加一条治疗记录"
		else if (ret==102) err=",预约记录没有对应的执行记录,不能做治疗"
		else if (ret==103) err=",其他错误"
		else  err=ret
		alert('保存失败'+err);
		return false
	}
}
function IntDataGrid()
{
	// 就诊记录
	cureDCAAorderGrid=$('#DCAAorderList').datagrid({  
		fit : true,
		width : 'auto',
		border : true,
		striped : true,
		singleSelect : true,
		fitColumns : true,
		autoRowHeight : false,
		nowrap: false,
		collapsible:false,
		singleSelect:true,    
		url : '',
		loadMsg : '加载中..',  
		pagination : true,  //
		rownumbers : true,  //
		idField:"OEOrdID",
		pageNumber:0,
		pageSize : 0,
		pageList : [10,50,100,200],
		//frozenColumns : FrozenCateColumns,
		columns :[[ 
					
					{field:'RowCheck',checkbox:true}, 
					{field:'OrderName',title:'医嘱名称',width:100,align:'center',hidden:false},  
					{field:'statDesc',title:'医嘱状态',width:100,align:'center',hidden:false},  
        			{field:'OrderNum',title:'医嘱数量',width:100,align:'center'},
        			{field:'OrderBilled',title:'收费状态',width:100,align:'center'},
        			{field:'OrderRecDep',title:'接收科室',width:80,align:'center'}, 
        			{field:'UserAdd',title:'医嘱录入人',width:100,align:'center'}, 
        			{field:'UserDepart',title:'医嘱录入科室',width:80,align:'center'},   
        			{field:'DateTime',title:'医嘱录入时间',width:100,align:'center'},
        			{field:'Order',title:'Order',width:150,align:'center'},
        			{field:'DHCAOrdeID',title:'DHCAOrdeID',width:100,hidden:true},
        			{field:'Adm',title:'Adm',width:150,align:'center'}  
    			 ]] ,
		onClickRow:function(rowIndex, rowData){
		//OrderName,statDesc,OrderNum,OrderBilled,OrderRecDep,UserAdd,UserDepart,DateTime,Order,DHCAOrdeID,Adm
		}
	});
}
