var SelectedRowID = 0;
var preRowID=0; 
//界面入口
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
	initButton(); //按钮初始化 add by wy 2019-4-22
    initButtonWidth();
	//jQuery('#BAdd').on("click", BAdd_Clicked);    // MZY0154	3257806		2023-03-03  不能重复定义
	setRequiredElements("Code^Desc^ModuleType")
	initMessage("");
	defindTitleStyle(); 
	initModuleTypeData();
	initDHCEQCBussTypeData();
	setEnabled()	// add by yh 2020-02-17 1161681

}
function DHCEQCBussType_OnClickRow()
{	
     var selected=$('#tDHCEQCBussType').datagrid('getSelected');
     if (selected)
     {       
        var SelectedRowID=selected.TRowID;
        if(preRowID!=SelectedRowID)
        {
	    	 setElement("RowID",SelectedRowID)
	         setElement("Code",selected.TCode)
	         setElement("Desc",selected.TName)
	         setElement("ModuleType",selected.TModuleTypeDR)
             preRowID=SelectedRowID;
             UnderSelect();		// add by yh 2020-02-17 1161681
        } //Modify by zx 2020-03-03 BUG 1213713
         else
         {
             ClearElement();
             $('#tDHCEQCBussType').datagrid('unselectAll');
             SelectedRowID = 0;
             preRowID=0;
         }
     }
} 
function initDHCEQCBussTypeData(){
	$HUI.datagrid("#tDHCEQCBussType",{   
	    url:$URL, 
    	queryParams:{
        ClassName:"web.DHCEQ.Plat.CTBussType",
        QueryName:"GetBussType",
        Code:getElementValue("Code"),
        Desc:getElementValue("Desc"),
        ModuleType:getElementValue("ModuleType"),
    	},
  		singleSelect:true,
   		fitColumns:true,    
    columns:[[
    	{field:'TRowID',title:'TRowID',width:50,hidden:'ture'},    
        {field:'TCode',title:'代码',width:60,align:'center'},
        {field:'TName',title:'描述',width:100,align:'center'},       
        {field:'TModuleType',title:'模块',width:100,align:'center'},  
        {field:'TModuleTypeDR',title:'TModuleTypeDR',width:100,align:'center',hidden:'ture'},                
    ]],
    onClickRow : function (rowIndex, rowData) {
        DHCEQCBussType_OnClickRow();
    },
   
    pagination:true,
    pageSize:15,
    pageNumber:1,
    pageList:[15,30,45,60,75]   
});
}
function ClearElement()
{
	setElement("RowID","")
	setElement("Code","")
	setElement("Desc","")
	setElement("ModuleType","")
	setEnabled();		// add by yh 2020-02-17 1161681
	preRowID=""		// add by yh 2020-02-17 1161681
}	
function BFind_Clicked(){
	$HUI.datagrid("#tDHCEQCBussType",{   
	    url:$URL, 
    	queryParams:{
        ClassName:"web.DHCEQ.Plat.CTBussType",
        QueryName:"GetBussType",
        Code:getElementValue("Code"),
        Desc:getElementValue("Desc"),
        ModuleType:getElementValue("ModuleType"),
    },
});
}

function BAdd_Clicked(){
	if (getElementValue("RowID")!=""){
			$.messager.popover({msg:"新增失败,你可能选中一条记录",type:'alert'});
            return false;
    } 
	if (checkMustItemNull()) return;
    $.ajax({
            url :"dhceq.jquery.method.csp",
            type:"POST",
            data:{
                ClassName:"web.DHCEQ.Plat.CTBussType",
                MethodName:"AddBussType",
                Arg1:getElementValue("Code"),
                Arg2:getElementValue("Desc"),
                Arg3:getElementValue("ModuleType"),
                ArgCnt:3
            },
            beforeSend: function () {
                $.messager.progress({
                text: '正在保存中...'
                });
            },
           	error:function(XMLHttpRequest, textStatus, errorThrown){
                        messageShow("","","",XMLHttpRequest.status);
                        messageShow("","","",XMLHttpRequest.readyState);
                        messageShow("","","",textStatus);
                    },
            success:function (data, response, status) {
            $.messager.progress('close');
            if (data >0) {
            $('#tDHCEQCBussType').datagrid('reload'); 
            $.messager.popover({msg:"保存成功",type:'success'});
			ClearElement();
            }   
            else {
	           $.messager.popover({msg:"保存失败",type:'error'});
               return;
               }
           }
           
  
        })
}
function BSave_Clicked(){
	if (getElementValue("RowID")==""){
			$.messager.popover({msg:"请选择一行",type:'alert'});
            return false;
    } 
    if (checkMustItemNull()) return;
    $.ajax({
            url :"dhceq.jquery.method.csp",
            type:"POST",
            data:{
                ClassName:"web.DHCEQ.Plat.CTBussType",
                MethodName:"SaveBussType",
                Arg1:getElementValue("RowID"),
                Arg2:getElementValue("Code"),
                Arg3:getElementValue("Desc"),
                Arg4:getElementValue("ModuleType"),
                ArgCnt:4
            },
            beforeSend: function () {
                $.messager.progress({
                text: '正在保存中...'
                });
            },
           	error:function(XMLHttpRequest, textStatus, errorThrown){
                        messageShow("","","",XMLHttpRequest.status);
                        messageShow("","","",XMLHttpRequest.readyState);
                        messageShow("","","",textStatus);
                    },
            success:function (data, response, status) {
            $.messager.progress('close');
            if (data==0) { 
            $('#tDHCEQCBussType').datagrid('reload'); 
            $.messager.popover({msg:"保存成功",type:'success'});
			ClearElement();
            }   
            else {
               $.messager.popover({msg:"保存失败",type:'error'});
               return;
               }
           }
           
  
        })
}
function BDelete_Clicked(){
    if (getElementValue("RowID")==""){
            $.messager.popover({msg:"请选择一行",type:'alert'}); 
            return false;
    } 
    var rows = $('#tDHCEQCBussType').datagrid('getSelections');
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
            type:"POST",
            data:{
                ClassName:"web.DHCEQ.Plat.CTBussType",
                MethodName:"DeleteBussType",
                Arg1:getElementValue("RowID"),
                ArgCnt:1
            },
            success:function (data, response, status) {
            $.messager.progress('close');
            if (data ==0) {
            $('#tDHCEQCBussType').datagrid('reload');
            $.messager.popover({msg:"删除成功",type:'success'});
			ClearElement();
            }   
            else {
	           $.messager.popover({msg:"删除失败",type:'error'});
               return;
               }
           }
            
        })
        }       
        })
     
    }
}
function initModuleTypeData()
{
	var ModuleType = $HUI.combobox('#ModuleType',{
		valueField:'id', textField:'text',panelHeight:"auto",
		data:[{
				id: '',
				text: ''
			},{
				id: '1',
				text: '设备管理'
			},{
				id: '2',
				text: '维修管理'
			},{
				id: '3',
				text: '效益分析'
			},{
				id: '4',
				text: '移动盘点'
			},{
				id: '5',
				text: '移动维修'
			},
			//Modified By QW20200116 begin BUG:QW0039增加移动验收及报废
			{
				id: '6',
				text: '移动验收'
			},{
				id: '7',
				text: '移动报废'
			}]
			//Modified By QW20200116 end BUG:QW0039增加移动验收及报废
});
}

// add by yh 2020-02-17 1161681
function setEnabled()
{
	disableElement("BSave",true);
	disableElement("BDelete",true);
	disableElement("BAdd",false);
}
// add by yh 2020-02-17 1161681
function UnderSelect()
{
	disableElement("BSave",false);
	disableElement("BDelete",false);
	disableElement("BAdd",true);
}


