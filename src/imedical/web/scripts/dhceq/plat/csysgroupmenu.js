//Modify by zx 2020-09-16
var editIndex=undefined;
var modifyBeforeRow = {};
/// Modfied by zc 2015-07-30 ZC0027
/// ����:����checkchange����
function checkchange(TAccessCheckbox,rowIndex)
{
	endEditing();  //Modify by zx 2020-09-16
	//var row = $('#menudatagrid').datagrid('getSelected');
	var row = $('#groupmenudatagrid').datagrid('getRows')[rowIndex];
	if (row) {
		if(TAccessCheckbox.checked==true) row.TOpt="Y"
		else row.TOpt="N"
		//var rowIndex = $('#menudatagrid').datagrid('getRowIndex', row);
		$('#groupmenudatagrid').datagrid('updateRow',{	//�ڱ����ĳ�������а���ͬ�¼�ʱ������Ӧ�������¼�������ִ��updateRow���������±��onclick�¼�ʧЧ
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
        {field:'name',title:'�˵�'}
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
                text:'����',          
                handler: function(){
                     SavegridData();}
                } /*,'-',{        
                iconCls: 'icon-cut', 
                text:'ɾ��',      
                 handler: function(){
                     DeleteGridData();
                     }      /// Modfied by zc 2015-07-30 ZC0027
                 },'-',{        
                iconCls: 'icon-search', 
                text:'��ѯ',      
                 handler: function(){
                     findGridData();
                     }        
                 }*/] , 
   
    columns:[[
    	{field:'TRowid',title:'TRowid',width:50,align:'center',hidden:true},    
        {field:'TGroupDR',title:'TGroupDR',width:200,align:'center',hidden:true}, /// Modfied by zc 2015-07-30 ZC0027
        {field:'TMenuDR',title:'TMenuDR',width:200,align:'center',hidden:true}, /// Modfied by zc 2015-07-30 ZC0027
        {field:'TMenuType',title:'�˵�����',width:50,align:'center'},    //Modify by zx 2020-09-16
        {field:'TMenuCode',title:'����',width:100,align:'center'},    //Modified by HHM 2016-04-06
        {field:'TMenu',title:'�˵�',width:100,align:'center'}, 
        {field:'TOpt',title:'����',width:50,align:'center',formatter: fomartOperation},  /// Modfied by zc 2015-07-30 ZC0027
        {field:'TUrlParms',title:'�ض������',width:100,align:'center',editor:{type: 'text',options:{}}}      //Modify by zx 2020-09-16        
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
/// ����:����fomartOperation����
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
/// ����:�޸�SavegridData����
function SavegridData(){         
	$('#groupmenudatagrid').datagrid('endEdit',editIndex);   //Modify by zx Bug ZX0119 �������༭�ı�ֵ��ȡ����
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
			beforeSend:function(){$.messager.progress({text:'���ڸ�����'})},
			success:function(data,response,status)
			{
				$.messager.progress('close');
				data=data.replace(/\ +/g,"")	//ȥ���ո�
				data=data.replace(/[\r\n]/g,"")	//ȥ���س�����
				data=data.split("^");
				if(data<0)
				{
					$.messager.popover({msg:"����ʧ��",type:'error'});
				}
				else
					$.messager.popover({msg:"���³ɹ�!",type:'success'});
					$('#groupmenudatagrid').datagrid('reload');
			}
		});

	}
}

/// Modfied by zx 202-09-16
/// ����:���ӿɱ༭�����
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
/// ����:�ɱ༭���ر�
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