/// Modfied by zc 2015-07-30 ZC0027
/// ����:����checkchange����
function checkchange(TAccessCheckbox,rowIndex)
{
		var row = $('#grouphospdatagrid').datagrid('getRows')[rowIndex];
		if (row) {
			if(TAccessCheckbox.checked==true) row.opt="Y"
			else row.opt="N"
    		$('#grouphospdatagrid').datagrid('updateRow',{	//�ڱ����ĳ�������а���ͬ�¼�ʱ������Ӧ�������¼�������ִ��updateRow���������±��onclick�¼�ʧЧ
			index:rowIndex,
			row:row})
			$('#grouphospdatagrid').datagrid('selectRow',rowIndex)
			$('#grouphospdatagrid').datagrid('options').onClickRow(rowIndex,row)
		}
}
$(document).ready(function () {
   var str=window.location.search.substr(1);
   var list=str.split("&");
   var tmp=list[0].split("=");
   var tid=tmp[1];
$('#grouphospdatagrid').datagrid({    
    url:'dhceq.jquery.csp', 
    queryParams:{
        ClassName:"web.DHCEQCGroupHospital",
        QueryName:"GetGroupHospital",
        Arg1:tid,
        ArgCnt:1
    },
    border:'true',
    toolbar:[{          
                iconCls: 'icon-save',
                text:'����',          
                handler: function(){
                     SavegridData();
                }   
                 }] , 
   
    columns:[[
    	{field:'rowid',title:'rowid',width:50,align:'center',hidden:true}, 
    	{field:'groupdr',title:'groupdr',width:200,align:'center',hidden:true},   
        {field:'hospitaldr',title:'hospitaldr',width:200,align:'center',hidden:true}, 
        {field:'hospital',title:'Ժ��',width:200,align:'center'},
        {field:'opt',title:'����',width:100,align:'center',formatter: fomartOperation},               
    ]],
    singleSelect: true, 
	selectOnCheck: true,
	checkOnSelect: true,
	onLoadSuccess:function(data){                    
       if(data){
            $.each(data.rows, function(index, item){
                if(item.checked){
                   $('#grouphospdatagrid').datagrid('checkRow', index);
               }
 
           });

        }},
    pagination:true,
    pageSize:10,
    pageNumber:1,
    pageList:[10,20,30,40,50] 
});
	
function fomartOperation(value,row,index){
			if(value=="Y"){
			return '<input type="checkbox" name="DataGridCheckbox" onclick="checkchange(this,'+index+')" checked="checked" value="" >';
		}
		else{
		return '<input type="checkbox" name="DataGridCheckbox" onclick="checkchange(this,'+index+')" value="N" >';
		}
}

function SavegridData(){
        var effectRow = new Object();    
   effectRow["data"]=JSON.stringify($('#grouphospdatagrid').datagrid('getRows'))
   eval(" effectRow[\"data\"] = '"+effectRow["data"]+"';");
  $.post("dhceq.jquery.operationtype.csp?&action=updategrouphospital", effectRow, function(text, status) {
                            if(status=="success"){
                                $.messager.alert("��ʾ", "����ɹ�");
                                $('#grouphospdatagrid').datagrid('reload');
                            }
                        }, "text").error(function() { //JSON����������Ҫ����Content-Type���ԣ�
                            $.messager.alert("��ʾ", "�ύ�����ˣ�");
                            $('#grouphospdatagrid').datagrid('reload');
                        })      
}
});