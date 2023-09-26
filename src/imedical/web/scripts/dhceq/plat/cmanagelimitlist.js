var SelectedRowID = 0;
var preRowID=0;
jQuery(document).ready
(
	function()
	{
		setTimeout("initDocument();",50);
	}
	
);
function initDocument()
{
	initPanel();
}
function initPanel()
{
	initTopPanel();		
}
//初始化查询头面板
function initTopPanel()
{
	initButtonWidth();
	initLookUp();
	jQuery('#BFind').on("click", BFind_Clicked);
	defindTitleStyle();
	initDHCEQCManageLimitList();			//初始化表格
}
 function setSelectValue(vElementID,item)
{
	setElement(vElementID+"DR",item.TRowID)			
}
function clearData(vElementID)
{
	setElement(vElementID+"DR","")
}

function DHCEQCManageLimitList_OnClickRow()
{
	
     var selected=$('#tDHCEQCManageLimitList').datagrid('getSelected');
     if (selected)
     {
        var SelectedRowID=selected.TRowID;
        if(preRowID!=SelectedRowID)
        {
	         setElement("RowID",SelectedRowID);
             setElement("ValueDR",selected.TValueDR);
             setElement("Value",selected.TValue);
             setElement("Accessflag",selected.TAccessflag);
             preRowID=SelectedRowID;
         }
         else
         {
	         ClearElement()
             SelectedRowID = 0;
             preRowID=0;
             $('#tDHCEQCManageLimitList').datagrid('unselectAll');
         }
     }
} 
function initDHCEQCManageLimitList(){
	$HUI.datagrid("#tDHCEQCManageLimitList",{   
	    url:$URL, 
    	queryParams:{
        	ClassName:"web.DHCEQ.Plat.CTManageLimit",
        	QueryName:"GetManageLimitList",
        	ManageLimitDR:getElementValue("ManageLimitDR"),
        	Type:getElementValue("Type"),
        	Value:getElementValue("ValueDR")
    	},
	    fie:true,
	    singleSelect:true,
		fitColumns:true,
		pagination:true,
    	toolbar:[{  
    			iconCls: 'icon-add',
                text:'新增',          
                handler: function(){   /// Modfied by zc 2015-07-30 ZC0027
                     AddgridData();
                }   
                },   //modify by lmm 2020-04-09
                {         
                iconCls: 'icon-update',
                text:'更新',          
                handler: function(){
                     SavegridData();
                }   
                },   //modify by lmm 2020-04-09
                {        
                iconCls: 'icon-cancel', 
                text:'删除',      
                 handler: function(){
                     DeleteGridData();
                     }      
                 }] , 
    	columns:[[
    		{field:'TRowID',title:'TRowID',width:50,hidden:'true'},    
        	{field:'TTypeDR',title:'TTypeDR',width:100,align:'center',hidden:'true'},
        	{field:'TType',title:'类型',width:100,align:'center'},
        	{field:'TValueDR',title:'TValueDR',width:300,align:'left',hidden:'true'},
        	{field:'TValue',title:'内容',width:300,align:'left'},
			{field:'TAccessflag',title:'访问标识',width:60,align:'center'}
    	]],
    	onClickRow : function (rowIndex, rowData) {
       	 DHCEQCManageLimitList_OnClickRow();
    	}, 
    	pagination:true,
   		pageSize:15,
    	pageNumber:1,
    	pageList:[15,30,45,60,75]    
	});
}
///限定明细无法查询
function BFind_Clicked(){
	$HUI.datagrid("#tDHCEQCManageLimitList",{   
	    url:$URL,
    queryParams:{
        ClassName:"web.DHCEQ.Plat.CTManageLimit",
        QueryName:"GetManageLimitList",
        ManageLimitDR:getElementValue("ManageLimitDR"),
        Type:getElementValue("Type"),
        Value:getElementValue("ValueDR")
    },
    border:'true',
    singleSelect:true});
}
/// 描述:新增AddgridData方法
function AddgridData(){
	if (getElementValue("Value")==""){
            $.messager.alert("错误", "内容不能为空！", 'error')
            return false;
    }
    $.ajax({
            url :"dhceq.jquery.method.csp",
            Type:"POST",
            data:{
                ClassName:"web.DHCEQ.Plat.CTManageLimit",
                MethodName:"AddManageLimitList",
                Arg1:getElementValue("ManageLimitDR"),
				Arg2:getElementValue("Type"),
        		Arg3:getElementValue("ValueDR"),
				Arg4:"Y",
                ArgCnt:4
            },
            beforeSend: function () {
                $.messager.progress({
                text: '正在保存中...'
                });
            },
           	error:function(XMLHttpRequest, textStatus, errorThrown){
                        alertShow(XMLHttpRequest.status);
                        alertShow(XMLHttpRequest.readyState);
                        alertShow(textStatus);
                    },
            success:function (data, response, status) {
            $.messager.progress('close');
            if (data >0) {
            $('#tDHCEQCManageLimitList').datagrid('reload'); 
            $.messager.show({
                title: '提示',
                msg: '保存成功'
            }); 
			ClearElement();      
            }   
            else {
               $.messager.alert('保存失败！',data, 'warning')
               return;
               }
           }         
        })
}
function SavegridData(){
	if (getElementValue("RowID")==""){
            $.messager.alert("错误", "请选择一行！", 'error')  
            return false;
    }
    if (getElementValue("Value")==""){
            $.messager.alert("错误", "内容不能为空！", 'error')
            return false;
    }
    $.ajax({
            url :"dhceq.jquery.method.csp",
            Type:"POST",
            data:{
                ClassName:"web.DHCEQ.Plat.CTManageLimit",
                MethodName:"SaveManageLimitList",
                Arg1:getElementValue("RowID"),
                Arg2:getElementValue("ManageLimitDR"),
				Arg3:getElementValue("Type"),
        		Arg4:getElementValue("ValueDR"),
        		Arg5:getElementValue("Accessflag"),
                ArgCnt:5
            },
            beforeSend: function () {
                $.messager.progress({
                text: '正在保存中...'
                });
            },
           	error:function(XMLHttpRequest, textStatus, errorThrown){
                        alertShow(XMLHttpRequest.status);
                        alertShow(XMLHttpRequest.readyState);
                        alertShow(textStatus);
                    },
            success:function (data, response, status) {
            $.messager.progress('close');
            //alertShow(data);
            if (data==0) {  
            $('#tDHCEQCManageLimitList').datagrid('reload'); 
            $.messager.show({
                title: '提示',
                msg: '保存成功'
            }); 
			ClearElement();   
            }   
            else {
               $.messager.alert('保存失败！',data, 'warning')
               return;
               }
           }         
        })
}
function DeleteGridData(){
    if (getElementValue("RowID")==""){
            $.messager.alert("错误", "请选择一行！", 'error')  
            return false;
    } 
    var rows = $('#tDHCEQCManageLimitList').datagrid('getSelections');
    var ids = [];
    var unSaveIndexs = [];
    if (rows.length > 0) {
        $.messager.confirm('请确认', '您确定要删除所选的行？', function (b) { 
        if (b==false)
        {
             return;
        }
        else
        {
        $.ajax({
            url :"dhceq.jquery.method.csp",
            Type:"POST",
            data:{
                ClassName:"web.DHCEQ.Plat.CTManageLimit",
                MethodName:"DeleteManageLimitList",
                Arg1:getElementValue("RowID"),
                ArgCnt:1
            },
            success:function (data, response, status) {
            $.messager.progress('close');
            if (data ==0) {
            $('#tDHCEQCManageLimitList').datagrid('reload');
            $.messager.show({
                title: '提示',
                msg: '删除成功'
            }); 
			ClearElement();    
            }   
            else {
               $.messager.alert('删除失败！',data, 'warning')
               return;
               }
           }
            
        })
        }       
        })
     
    }
    else
    {
        $.messager.alert("错误","请选择一行！",'error')
    }
}
/// 描述:新增清空函数
function ClearElement(){
	setElement("RowID","")
	setElement("Value","")
	setElement("ValueDR","")
	setElement("Accessflag","")
}
//$('#tDHCEQCManageLimitList').datagrid('hideColumn', 'rowid'),
//$('#tDHCEQCManageLimitList').datagrid('hideColumn', 'ManageLimitDR')
function accessOperation(value,row,index)
{
	if(value=="Y")
	{
		return '<input Type="checkbox" name="DataGridCheckbox" onclick="checkchange(this,'+index+')" checked="checked" value="" >';
	}
	else
	{
		return '<input Type="checkbox" name="DataGridCheckbox" onclick="checkchange(this,'+index+')" value="Y" >';
	}
}
function checkchange(obj,rowIndex)
{
	var row = $('#tDHCEQCManageLimitList').datagrid('getRows')[rowIndex];
	if (row)
	{
		if (obj.checked)
		{
			row.accessflag ="Y"
		}
		else
		{
			row.accessflag ="N"
		}
	}
}