/// Modfied by zc 2015-07-30 ZC0027
/// ����:����checkchange����
function checkchange(TAccessCheckbox,rowIndex)
{
		//var row = $('#menudatagrid').datagrid('getSelected');
		var row = $('#managelimitlistinfodatagrid').datagrid('getRows')[rowIndex];
		if (row) {
			if(TAccessCheckbox.checked==true) row.opt="Y"
			else row.opt="N"
    		//var rowIndex = $('#menudatagrid').datagrid('getRowIndex', row);
    		$('#managelimitlistinfodatagrid').datagrid('updateRow',{	//�ڱ����ĳ�������а���ͬ�¼�ʱ������Ӧ�������¼�������ִ��updateRow���������±��onclick�¼�ʧЧ
			index:rowIndex,
			row:row})
			$('#managelimitlistinfodatagrid').datagrid('selectRow',rowIndex)
			$('#managelimitlistinfodatagrid').datagrid('options').onClickRow(rowIndex,row)
		}
}
$(document).ready(function () {
   var str=window.location.search.substr(1);
   var list=str.split("&");
   var tmp=list[0].split("=");
   var tid=tmp[1];
   //messageShow("","","",tid);
   var temp=list[1].split("=");
   var eid=temp[1];
   //messageShow("","","",eid);
   var tsmp=list[2].split("=");
   var sid=tsmp[1];
   //messageShow("","","",sid); 
$('#managelimitlistinfodatagrid').datagrid({   
    url:'dhceq.jquery.csp', 
    queryParams:{
        ClassName:"web.DHCEQCManageLimit",
        QueryName:"GetManageLimitListinfo",
        Arg1:tid,
        Arg2:eid,
        Arg3:sid,
        ArgCnt:3
    },
    border:'true',
    //height:'100%',
    singleSelect:true,
    columns:[[
    	{field:'rowid',title:'LRowid',width:50,hidden:true},    
        {field:'managelimitdr',title:'managelimitdr',width:150,align:'center',hidden:true},
        {field:'typedr',title:'typedr',width:150,align:'center',hidden:true}, 
        {field:'valuedr',title:'valuedr',width:150,align:'center',hidden:true},
        {field:'value',title:'����',width:200,align:'center'},
        {field:'opt',title:'����',width:100,align:'center',formatter: fomartOperation},
        //{field:'opt',title:'����',width:100,align:'center'},
    ]],
    singleSelect: true, 
	selectOnCheck: true,
	checkOnSelect: true,
	onLoadSuccess:function(data){
       if(data){
            $.each(data.rows, function(index, item){
                if(item.checked){
                   $('#managelimitlistinfodatagrid').datagrid('checkRow', index);
               }
 
           });
        }}, 
    toolbar:[{
                iconCls: 'icon-save',
                text:'����',          
                handler: function(){
                     SavegridData();
                }
                 }],
    pagination:true,
    pageSize:10,
    pageNumber:1,
    pageList:[10,20,30,40,50]
});
function editrow(target){
			$('#managelimitlistinfodatagrid').datagrid('beginEdit', getRowIndex(target));
}
/// Modfied by zc 2015-07-30 ZC0027
/// ����:�޸�fomartOperation����
function fomartOperation(value,row,index){
			if(value=="Y"){
			return '<input type="checkbox" name="DataGridCheckbox" onclick="checkchange(this,'+index+')" checked="checked" value="" >';
		}
		else{
		return '<input type="checkbox" name="DataGridCheckbox" onclick="checkchange(this,'+index+')" value="Y" >';
		}
}

/// Modfied by zc 2015-07-30 ZC0027
/// ����:�޸�SavegridData����
function SavegridData(){
	var effectRow = new Object();
	effectRow["data"]=JSON.stringify($('#managelimitlistinfodatagrid').datagrid('getRows'))
	//messageShow("","","",effectRow["data"]); 
	eval(" effectRow[\"data\"] = '"+effectRow["data"]+"';");
	$.post("dhceq.jquery.operationtype.csp?&action=updatemanagelimitlistinfo", effectRow, function(text, status) {
                            if(status=="success"){
                                $.messager.alert("��ʾ", "����ɹ�!");
                                $('#managelimitlistinfodatagrid').datagrid('reload');
                            }
                        }, "text").error(function() { //JSON����������Ҫ����Content-Type���ԣ�
                            $.messager.alert("��ʾ", "�ύ�����ˣ�");
                            $('#managelimitlistinfodatagrid').datagrid('reload');
                        })
}

});
