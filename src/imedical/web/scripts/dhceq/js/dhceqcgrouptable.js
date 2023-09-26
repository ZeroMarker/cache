var str=window.location.search.substr(1);
var list=str.split("&");
var tmp=list[0].split("=");
var tid=tmp[1];

$(document).ready(function () {
$('#grouptabledatagrid').datagrid({    
    url:'dhceq.jquery.csp', 
    queryParams:{
        ClassName:"web.DHCEQCGroupCTable",
        QueryName:"Codetable",
        Arg1:tid,
        ArgCnt:1
    },
    //fitColumns:'true',
    border:'true',
//    toolbar:[{          
//                iconCls: 'icon-save',
//                text:'����',          
//                handler: function(){
//                     SavegridData();
//                }   
//                 }] , 
   //"TCodetable:%String,TROWID:%String,TPutIn:%String,TRow:%String"
    columns:[[
        {field:'TRow',title:'���',width:50,align:'center'},
        {field:'TROWID',title:'TROWID',width:200,align:'center',hidden:true},   
    	{field:'TCodetable',title:'����',width:200,align:'center'}, 
        {field:'TPutIn',title:'�ύ',width:50,align:'center',formatter:formatterOperation},          
    ]],
    singleSelect: true, 
	selectOnCheck: true,
	checkOnSelect: true,
	onLoadSuccess:function(data){                    
       if(data){
            $.each(data.rows, function(index, item){
                if(item.checked){
                   $('#grouptabledatagrid').datagrid('checkRow', index);
               }
 
           });

        }},
    pagination:true,
    pageSize:25,
    pageNumber:1,
    pageList:[25,50,75,100,125] 
});
	$("#BUpdate").on("click",SavegridData);
});
/// add by csj 2015-07-30 ZC0027
function SavegridData(){
	var effectRow = new Object();    
	effectRow["data"]=JSON.stringify($('#grouptabledatagrid').datagrid('getRows'))
	//messageShow("","","",effectRow["data"]); 
	eval(" effectRow[\"data\"] = '"+effectRow["data"]+"';");
  	$.post("dhceq.jquery.operationtype.csp?&action=updategrouptable&str="+tid, effectRow, function(text, status) {
	            if(status=="success"){
	                $.messager.alert("��ʾ", "����ɹ�");
	                //$('#menudatagrid').datagrid('acceptChanges');
	                $('#grouptabledatagrid').datagrid('reload');
	            }
            }, "text").error(function() { //JSON����������Ҫ����Content-Type���ԣ�
                $.messager.alert("��ʾ", "�ύ�����ˣ�");
                $('#grouptabledatagrid').datagrid('reload');
            })      
	}
	
function formatterOperation(value,row,index){
	if(value=="Y"){
		return '<input type="checkbox" name="DataGridCheckbox" onclick="checkchange(this,'+index+')" checked="checked" value="" >';
	}
	else{
	return '<input type="checkbox" name="DataGridCheckbox" onclick="checkchange(this,'+index+')" value="N" >';
	}
}
/// Modfied by zc 2015-07-30 ZC0027
/// ����:����checkchange����
function checkchange(TAccessCheckbox,rowIndex)
{
		//var row = $('#menudatagrid').datagrid('getSelected');
		var row = $('#grouptabledatagrid').datagrid('getRows')[rowIndex];
		if (row) {
			if(TAccessCheckbox.checked==true) row.TPutIn="Y"
			else row.TPutIn="N"
    		//var rowIndex = $('#menudatagrid').datagrid('getRowIndex', row);
    		$('#grouptabledatagrid').datagrid('updateRow',{	//�ڱ����ĳ�������а���ͬ�¼�ʱ������Ӧ�������¼�������ִ��updateRow���������±��onclick�¼�ʧЧ
			index:rowIndex,
			row:row})
			$('#grouptabledatagrid').datagrid('selectRow',rowIndex)
			$('#grouptabledatagrid').datagrid('options').onClickRow(rowIndex,row)
		}
}
