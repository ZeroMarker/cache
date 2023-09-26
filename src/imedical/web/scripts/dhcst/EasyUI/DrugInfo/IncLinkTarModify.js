/**
 * ģ��:		ҩ��
 * ��ģ��:		���������շ���ά��
 * createdate:	2018-11-09
 * creator:		yunhaibao
 */
var CurDate=$.fn.datebox.defaults.formatter(new Date());
var HASBEENUSED="";	// �Ƿ���ҵ��
$(function(){
	try{
		InitDict();
		InitIncLinkTarGrid();
		$("#btnAdd").on("click",AddIncLinkTar);
		$("#btnUpdate").on("click",SaveIncLinkTar);
	    $("#btnClear").on("click",ClearContent);
		$("#btnClose").on("click",CloseContent);
		document.onkeypress = DHCSTEASYUI.BanBackspace;
		document.onkeydown = DHCSTEASYUI.BanBackspace;
	}catch(e){
		$.messager.alert("������ʾ",e.message,"error");
		$.messager.progress('close');
	}
});

function InitDict(){
	$("#dtStDate,#dtEdDate").datebox({});
	$("#dtStDate").datebox("setValue",CurDate);
	var tmpOptions={
		ClassName:"web.DHCST.INCLINKTAR",
		QueryName:"GetTarItem",
		StrParams:"",
		pageSize:30, 
		pageList:[30,50,100],  
		pagination:true,	
    	columns: [[
			{field:'tarItmId',title:'tarItmId',width:100,sortable:true,hidden:true},
			{field:'tarItmCode',title:'�շ������',width:100,sortable:true},
			{field:'tarItmDesc',title:'�շ�������',width:100,sortable:true}
	    ]],
		idField:'tarItmId',
		textField:'tarItmDesc',
		mode:"remote",
		onLoadSuccess:function(data) {
			//$("#cmbTarItm").combogrid("clear");
		}	
    };
	$("#cmbTarItm").dhcstcombogrideu(tmpOptions);

}

function InitIncLinkTarGrid(){
		var gridColumns=[[ 
		{field:'lnkId',title:'����Id',width:155,hidden:true,align:'center'},
		{field:'tarItmId',title:'�շ���Id',width:155,hidden:true,align:'center'},
		{field:'tarItmCode',title:'�շ������',width:100,align:'left'},
		{field:'tarItmDesc',title:'�շ�������',width:200,align:'left'},
		{field:'uomDesc',title:'��λ',width:80,hidden:false},
		{field:'qty',title:'����',width:50,hidden:false},
		{field:'sp',title:'�۸�',width:80,align:"right"},
		{field:'lnkStDate',title:'��ʼ����',width:100,hidden:false,align:'center'},
		{field:'lnkEdDate',title:'��������',width:100,hidden:false,align:'center'}
		
	]];
	var options={
		ClassName:"web.DHCST.INCLINKTAR",
		QueryName:"QueryIncLinkTar",
		queryParams:{
			StrParams:urlIncItmId 
		},
		nowrap:false,
		pagination:false,
		columns:gridColumns,
		onClickRow:function(rowIndex,rowData){
			if (rowData){
				$("#dtStDate").datebox("setValue",rowData.lnkStDate||"");
				$("#dtEdDate").datebox("setValue",rowData.lnkEdDate||"");
				$("#cmbTarItm").combogrid("setValue",rowData.tarItmId);
				$("#cmbTarItm").combogrid("setText",rowData.tarItmDesc);
				MakeReadOnly(true)
			}
		}
	};
	$('#incLinkTarGrid').dhcstgrideu(options);  
}


function CloseContent(){
	$.messager.confirm('�ر���ʾ', '��ȷ�Ϲر���?', function(r){
		if (r){	
			parent.$('#maintainWin').window("close");
		}
	});
}
// �˴�����,����Ҫ��ʾ
function ClearContent(){
	$("#dtStDate").datebox("setValue",CurDate);
	$("#dtEdDate").datebox("setValue","");
	$("#cmbTarItm").combogrid("clear")
	$("#incLinkTarGrid").datagrid("reload");
	MakeReadOnly(false);
}
function AddIncLinkTar(){
	var gridSelected=$('#incLinkTarGrid').datagrid('getSelected')||"";
	
	if (gridSelected!=""){
		debugger
		$.messager.alert("��ʾ","ѡ�����ڼ�¼��,ֻ���޸Ļ�����������","error");
		return;
	}
	SaveIncLinkTar();
}
function SaveIncLinkTar(){
	var incId=urlIncItmId;
	var tarItmId=$("#cmbTarItm").combobox("getValue");
	var stDate=$("#dtStDate").datebox("getValue");
	var edDate=$("#dtEdDate").datebox("getValue");
	var lnkId="";
	var gridSelected=$('#incLinkTarGrid').datagrid('getSelected');
	if (gridSelected){
		lnkId=gridSelected.lnkId||"";
	}
	var inputStr=incId+"^"+tarItmId+"^"+1+"^"+stDate+"^"+edDate
	var saveRet=tkMakeServerCall("web.DHCST.INCLINKTAR","SaveIncLinkTar",lnkId,inputStr);
	var saveArr=saveRet.split("^");
	var saveVal=saveArr[0];
	var saveInfo=saveArr[1];
	if (saveVal<0){
		$.messager.alert("��ʾ",saveInfo,saveVal==-10?"warning":"error");
	}else{
		ClearContent();
	}
}

function MakeReadOnly(tfFlag){
	$("#cmbTarItm").combogrid("readonly",tfFlag)
	$("#dtStDate").datebox("readonly",tfFlag)
}