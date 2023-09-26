/// Modfied by zc 2015-07-30 ZC0027
/// 描述:新增checkchange方法
function checkchange(TAccessCheckbox,rowIndex)
{
		//var row = $('#menudatagrid').datagrid('getSelected');
		var row = $('#managelimitlistinfodatagrid').datagrid('getRows')[rowIndex];
		if (row) {
			if(TAccessCheckbox.checked==true) row.opt="Y"
			else row.opt="N"
    		//var rowIndex = $('#menudatagrid').datagrid('getRowIndex', row);
    		$('#managelimitlistinfodatagrid').datagrid('updateRow',{	//在表格与某个具体列绑定相同事件时，先响应具体列事件，但是执行updateRow方法将导致表格onclick事件失效
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
        {field:'value',title:'内容',width:200,align:'center'},
        {field:'opt',title:'操作',width:100,align:'center',formatter: fomartOperation},
        //{field:'opt',title:'操作',width:100,align:'center'},
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
                text:'保存',          
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
/// 描述:修改fomartOperation方法
function fomartOperation(value,row,index){
			if(value=="Y"){
			return '<input type="checkbox" name="DataGridCheckbox" onclick="checkchange(this,'+index+')" checked="checked" value="" >';
		}
		else{
		return '<input type="checkbox" name="DataGridCheckbox" onclick="checkchange(this,'+index+')" value="Y" >';
		}
}

/// Modfied by zc 2015-07-30 ZC0027
/// 描述:修改SavegridData方法
function SavegridData(){
	var effectRow = new Object();
	effectRow["data"]=JSON.stringify($('#managelimitlistinfodatagrid').datagrid('getRows'))
	//messageShow("","","",effectRow["data"]); 
	eval(" effectRow[\"data\"] = '"+effectRow["data"]+"';");
	$.post("dhceq.jquery.operationtype.csp?&action=updatemanagelimitlistinfo", effectRow, function(text, status) {
                            if(status=="success"){
                                $.messager.alert("提示", "保存成功!");
                                $('#managelimitlistinfodatagrid').datagrid('reload');
                            }
                        }, "text").error(function() { //JSON返回类型需要设置Content-Type属性？
                            $.messager.alert("提示", "提交错误了！");
                            $('#managelimitlistinfodatagrid').datagrid('reload');
                        })
}

});
