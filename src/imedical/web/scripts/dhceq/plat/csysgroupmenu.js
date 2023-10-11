//Modify by zx 2020-09-16
var editIndex=undefined;
var modifyBeforeRow = {};
/// Modfied by zc 2015-07-30 ZC0027
/// 描述:新增checkchange方法
function checkchange(TAccessCheckbox,rowIndex)
{
	endEditing();  //Modify by zx 2020-09-16
	//var row = $('#menudatagrid').datagrid('getSelected');
	var row = $('#groupmenudatagrid').datagrid('getRows')[rowIndex];
	if (row) {
		if(TAccessCheckbox.checked==true) row.TOpt="Y"
		else row.TOpt="N"
		//var rowIndex = $('#menudatagrid').datagrid('getRowIndex', row);
		$('#groupmenudatagrid').datagrid('updateRow',{	//在表格与某个具体列绑定相同事件时，先响应具体列事件，但是执行updateRow方法将导致表格onclick事件失效
		index:rowIndex,
		row:row})
		$('#groupmenudatagrid').datagrid('selectRow',rowIndex)
		$('#groupmenudatagrid').datagrid('options').onClickRow(rowIndex,row)
	}
}
$(document).ready(function () { 
/*$('#menu').combogrid({ 
	url:'dhceq.jquery.csp',      
	idField:'rowid',
	textField:'name',
	method:"post",
	mode:'remote',
	queryParams:{
		ClassName:"web.DHCEQCSysMenus",
		QueryName:"GetMenu",
		ArgCnt:0
	},
	onChange: function(newValue, oldValue){
		//messageShow("","","",newValue);
		 $('#menu').combogrid("grid").datagrid("reload",{
		ClassName:"web.DHCEQCSysMenus",
		QueryName:"GetMenu",
		Arg1:$('#Rowid').val(),
		Arg2:$('#menu').combogrid('getText'),
		ArgCnt:2
		})
    },	
	columns:[[    
        {field:'rowid',title:'rowid',hidden:true},    
        {field:'name',title:'菜单'}
        ]]   
    });
    $('#group').validatebox({    
  		width: 160
    }); 
var SelectedRowID = 0;
var preRowID=0;  */  /// Modfied by zc 2015-07-30 ZC0027
 var str=window.location.search.substr(1);
   var list=str.split("&");
   var tmp=list[0].split("=");
   var tid=tmp[1];
   //messageShow("","","",tid);
/// Modfied by zc 2015-07-30 ZC0027   
/*function groupmenudatagrid_OnClickRow()
{
     var selected=$('#groupmenudatagrid').datagrid('getSelected');
     if (selected)
     {       
        var SelectedRowID=selected.rowid;
        if(preRowID!=SelectedRowID)
        {
             $('#Rowid').val(selected.rowid);
             $('#group').val(selected.groupdr);
             $('#menu').combogrid('setValue',selected.menu);
             preRowID=SelectedRowID;
         }
         else
         {
             $('#Rowid').val("");
             //$('#group').combogrid('setValue',"");
             $('#menu').combogrid('setValue',""); 
             SelectedRowID = 0; 
             preRowID=0;
         }
     }
} */   
$HUI.datagrid('#groupmenudatagrid',{    
    url:$URL, 
    queryParams:{
        ClassName:"web.DHCEQ.Plat.CTSysGroupMenu",
        QueryName:"GetGroupmenu",
        Group:tid,
    },
    border:'true',
    fitColumns:true,   //add by lmm 2020-06-05 UI
    fit:true,   //add by lmm 2020-06-05 UI
    toolbar:[{          
                iconCls: 'icon-save',
                text:'保存',          
                handler: function(){
                     SavegridData();}
                } /*,'-',{        
                iconCls: 'icon-cut', 
                text:'删除',      
                 handler: function(){
                     DeleteGridData();
                     }      /// Modfied by zc 2015-07-30 ZC0027
                 },'-',{        
                iconCls: 'icon-search', 
                text:'查询',      
                 handler: function(){
                     findGridData();
                     }        
                 }*/] , 
   
    columns:[[
    	{field:'TRowid',title:'TRowid',width:50,align:'center',hidden:true},    
        {field:'TGroupDR',title:'TGroupDR',width:200,align:'center',hidden:true}, /// Modfied by zc 2015-07-30 ZC0027
        {field:'TMenuDR',title:'TMenuDR',width:200,align:'center',hidden:true}, /// Modfied by zc 2015-07-30 ZC0027
        {field:'TMenuType',title:'菜单类型',width:50,align:'center'},    //Modify by zx 2020-09-16
        {field:'TMenuCode',title:'代码',width:100,align:'center'},    //Modified by HHM 2016-04-06
        {field:'TMenu',title:'菜单',width:100,align:'center'}, 
        {field:'TOpt',title:'操作',width:50,align:'center',formatter: fomartOperation},  /// Modfied by zc 2015-07-30 ZC0027
        {field:'TUrlParms',title:'重定义参数',width:100,align:'center',editor:{type: 'text',options:{}}}      //Modify by zx 2020-09-16        
    ]],
    singleSelect: true, 
	selectOnCheck: true,
	checkOnSelect: true,
	onLoadSuccess:function(data){                    
       if(data){
            $.each(data.rows, function(index, item){
                if(item.checked){
                   $('#groupmenudatagrid').datagrid('checkRow', index);
               }
           });

        }},
    /*onClickRow : function (rowIndex, rowData) {
        groupmenudatagrid_OnClickRow();  /// Modfied by zc 2015-07-30 ZC0027
    },*/  
    pagination:true,
    pageSize:15,
    pageNumber:1,
    pageList:[15,30,45,60,75]      
});
});
/// Modfied by zc 2015-07-30 ZC0027
/// 描述:新增fomartOperation方法
function fomartOperation(value,row,index){
			if(value=="Y"){
			return '<input type="checkbox" name="DataGridCheckbox" onclick="checkchange(this,'+index+')" checked="checked" value="" >';
		}
		else{
		return '<input type="checkbox" name="DataGridCheckbox" onclick="checkchange(this,'+index+')" value="Y" >';
		}
}
/*function fomartOperation(value,row,index)
{
	if(row.rowid!="")
	{ return '<input type="checkbox" id="ck" checked="checked">'; 	}
	else{
 	return '<input type="checkbox" id="ck">'; }
}*/

/// Modfied by CSJ 20181023
/// 描述:修改SavegridData方法
function SavegridData(){         
	$('#groupmenudatagrid').datagrid('endEdit',editIndex);   //Modify by zx Bug ZX0119 不结束编辑改变值获取不到
	var rows = jQuery("#groupmenudatagrid").datagrid('getRows');
	//messageShow("","","",JSON.stringify(rows))
	for(var i=0;i<rows.length;i++)
	{
		var PSTData="";
		PSTData=rows[i].TRowid;
		PSTData=PSTData+"^"+rows[i].TGroupDR;
		PSTData=PSTData+"^"+rows[i].TMenuDR;
		PSTData=PSTData+"^"+rows[i].TOpt;
		PSTData=PSTData+"^"+rows[i].TUrlParms;  //Modify by zx 2020-09-16
		$.ajax({
			url:'dhceq.jquery.method.csp',
			Type:'POST',
			data:{
				ClassName:'web.DHCEQ.Plat.CTSysGroupMenu',
				MethodName:'SaveData',
				Arg1:PSTData,
				ArgCnt:1
			},
			beforeSend:function(){$.messager.progress({text:'正在更新中'})},
			success:function(data,response,status)
			{
				$.messager.progress('close');
				data=data.replace(/\ +/g,"")	//去掉空格
				data=data.replace(/[\r\n]/g,"")	//去掉回车换行
				data=data.split("^");
				if(data<0)
				{
					$.messager.popover({msg:"更新失败",type:'error'});
				}
				else
					$.messager.popover({msg:"更新成功!",type:'success'});
					$('#groupmenudatagrid').datagrid('reload');
			}
		});

	}
}

/// Modfied by zx 202-09-16
/// 描述:增加可编辑表格处理
function onClickRow(index)
{
	if (editIndex!=index) 
	{
		if (endEditing())
		{
			$('#groupmenudatagrid').datagrid('selectRow', index).datagrid('beginEdit', index);
		
			editIndex = index;
			modifyBeforeRow = $.extend({},$('#groupmenudatagrid').datagrid('getRows')[editIndex]);
		} else {
			$('#groupmenudatagrid').datagrid('selectRow', editIndex);
		}
	}
	else
	{
		endEditing();
	}
}
/// Modfied by zx 202-09-16
/// 描述:可编辑表格关闭
function endEditing(){
	if (editIndex == undefined){return true}
	if ($('#groupmenudatagrid').datagrid('validateRow', editIndex)){
		$('#groupmenudatagrid').datagrid('endEdit', editIndex);
		editIndex = undefined;
		return true;
	} else {
		return false;
	}
}