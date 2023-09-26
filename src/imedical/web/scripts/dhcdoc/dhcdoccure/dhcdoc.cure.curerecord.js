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
///����ԤԼ��¼��Ӧ��ҽ��
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
	    alert("ֻ������ҽʦ�ſ��޸����Ƽ�¼");
		return; 
	}
    var DCAARowId=$('#DCAARowId').val();
    var DCRRowId=$("#DCRRowId").val();
    if((DCAARowId=="")&&(DCRRowId==""))
    {
	   alert("��ѡ��һ��ԤԼ��¼����һ�����Ƽ�¼");
	   return; 
	}
	var DCRTitle=$("#DCRTitle").val();
	if (DCRTitle=="")
	{
		alert("���Ʊ��ⲻ��Ϊ��");
		return;
	}
	var DCRContent=$("#DCRContent").val();
	if (DCRContent=="")
	{
		alert("���Ƽ�¼����Ϊ��");
		return;
	}
	//��ȡ��ʾ��Ϣ
	var AlertMesag=tkMakeServerCall("DHCDoc.DHCDocCure.Record","GetAlertMesage",DCAARowId);
	if (AlertMesag!=""){
		alert(AlertMesag);
	}
	
	var Para=DCRRowId+"^"+DCAARowId+"^"+DCRTitle+"^"+DCRContent+"^"+session['LOGON.USERID'];
	var ret=tkMakeServerCall("DHCDoc.DHCDocCure.Record","SaveCureRecord",Para);
	if(ret==0)
	{
		alert('����ɹ�');
	}else{
		var err=""
		if (ret==100) err=""
		else if (ret==100) err=",�������Ƽ�¼,����ѡ��һ��ԤԼ��¼"
		else if (ret==101) err=",һ��ԤԼ��¼���޿����һ�����Ƽ�¼"
		else if (ret==102) err=",ԤԼ��¼û�ж�Ӧ��ִ�м�¼,����������"
		else if (ret==103) err=",��������"
		else  err=ret
		alert('����ʧ��'+err);
		return false
	}
}
function IntDataGrid()
{
	// �����¼
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
		loadMsg : '������..',  
		pagination : true,  //
		rownumbers : true,  //
		idField:"OEOrdID",
		pageNumber:0,
		pageSize : 0,
		pageList : [10,50,100,200],
		//frozenColumns : FrozenCateColumns,
		columns :[[ 
					
					{field:'RowCheck',checkbox:true}, 
					{field:'OrderName',title:'ҽ������',width:100,align:'center',hidden:false},  
					{field:'statDesc',title:'ҽ��״̬',width:100,align:'center',hidden:false},  
        			{field:'OrderNum',title:'ҽ������',width:100,align:'center'},
        			{field:'OrderBilled',title:'�շ�״̬',width:100,align:'center'},
        			{field:'OrderRecDep',title:'���տ���',width:80,align:'center'}, 
        			{field:'UserAdd',title:'ҽ��¼����',width:100,align:'center'}, 
        			{field:'UserDepart',title:'ҽ��¼�����',width:80,align:'center'},   
        			{field:'DateTime',title:'ҽ��¼��ʱ��',width:100,align:'center'},
        			{field:'Order',title:'Order',width:150,align:'center'},
        			{field:'DHCAOrdeID',title:'DHCAOrdeID',width:100,hidden:true},
        			{field:'Adm',title:'Adm',width:150,align:'center'}  
    			 ]] ,
		onClickRow:function(rowIndex, rowData){
		//OrderName,statDesc,OrderNum,OrderBilled,OrderRecDep,UserAdd,UserDepart,DateTime,Order,DHCAOrdeID,Adm
		}
	});
}
