var editIndex=undefined;
var modifyBeforeRow={};
var Columns=getCurColumnsInfo('PLAT.G.CT.PicTypeAccess','','','')

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
	jQuery('#BFind').on("click", BFind_Clicked);
	defindTitleStyle();
	initdatagrid();			
}
function initdatagrid(){
    $HUI.datagrid("#menudatagrid",{   
	    url:$URL,
    queryParams:{
        ClassName:"web.DHCEQ.Plat.CTPicType",
        QueryName:"GetPicTypeAndAccess",
        Desc:getElementValue("pictype"),
        CurrentSourceType:getElementValue("CurrentSourceType"),
    },
    border:false,
	fitColumns:true,   //add by lmm 2020-06-05 UI
    fit:true,   //add by lmm 2020-06-05 UI
    //border:'true',   //modify by lmm 2020-04-09  该行去掉
    toolbar:[{
                text : "保存",
                iconCls : "icon-save",
                handler : function() {SavegridData();}
                    
            }],         
    columns:Columns,
    pagination:true,
    pageSize:10,
    pageNumber:1,
    pageList:[10,20,30,40,50] 
});
}
function BFind_Clicked()
{
	$HUI.datagrid("#menudatagrid",{   
	    url:$URL, 
	    queryParams:{
	        ClassName:"web.DHCEQ.Plat.CTPicType",
	        QueryName:"GetPicTypeAndAccess",
	        Desc:getElementValue("pictype"),
	        CurrentSourceType:getElementValue("CurrentSourceType"),
	    },
	})  
  
}
function SavegridData()
{
	var str=ListData()
	var data = tkMakeServerCall("web.DHCEQ.Plat.CTPicType", "SavePicSourceType",getElementValue("CurrentSourceType"),str);
	if (data=="0")
	{
		$.messager.popover({msg:"保存成功",type:'success'});
		$('#menudatagrid').datagrid('reload');
	}
	else
	{
		$.messager.popover({msg:"保存失败",type:'info'});
	}
}
function ListData()
{
	var ListData=""
	if(editIndex>="0"){
		jQuery("#menudatagrid").datagrid('endEdit', editIndex);
	}
	var rows = jQuery("#menudatagrid").datagrid('getRows');    //modify by lmm 2018-11-14
	if(rows.length<=0) return ListData;
	
	var dataList = [];
	for(var i=0;i<rows.length;i++)
	{
		if(rows[i].TPicTypeDR=="") return -1;
		var tmp=""
		tmp=rows[i].TRowID
		tmp=tmp+"^"
		tmp=tmp+"^"+rows[i].TPicTypeDR
		tmp=tmp+"^"
		tmp=tmp+"^"	
		tmp=tmp+"^"	
		tmp=tmp+"^"	
		tmp=tmp+"^"
		tmp=tmp+"^"	
		tmp=tmp+"^"	
		tmp=tmp+"^"+rows[i].TPicFlag
		tmp=tmp+"^"+rows[i].TFileFlag
		tmp=tmp+"^"+rows[i].TMustFlag  
		tmp=tmp+"^"+rows[i].TApproveSetDR

		dataList.push(tmp);
	}
	var ListData=dataList.join("#");
	return ListData
}
function onClickRow(index)
{
	if (editIndex!=index) 
	{
		if (endEditing())
		{
			$('#menudatagrid').datagrid('selectRow', index).datagrid('beginEdit', index);
			editIndex = index;
			modifyBeforeRow = $.extend({},$('#menudatagrid').datagrid('getRows')[editIndex]);
			//bindGridEvent();  //编辑行监听响应
		} else {
			$('#menudatagrid').datagrid('selectRow', editIndex);
		}
	}
	else
	{
		endEditing();
	}
}

function endEditing()
{
	if (editIndex == undefined){return true}
	if ($('#menudatagrid').datagrid('validateRow', editIndex)){
		$('#menudatagrid').datagrid('endEdit', editIndex);
		editIndex = undefined;
		return true;
	} else {
		return false;
	}
}
function getApproveSet(index,data)
{
	var rowData = $('#menudatagrid').datagrid('getSelected');
	rowData.TApproveSetDR=data.TRowID;
	var ApproveSetDRLDescEdt = $('#menudatagrid').datagrid('getEditor', {index:editIndex,field:'TApproveSet'});
	$(ApproveSetDRLDescEdt.target).combogrid("setValue",data.TDesc);
	$('#menudatagrid').datagrid('endEdit',editIndex);
}
function checkboxPicFlagChange(TPicFlag,rowIndex)
{
	var row = jQuery('#menudatagrid').datagrid('getRows')[rowIndex];
	if (row)
	{
		$.each(row,function(key,val){
			if (TPicFlag==key)
			{
				if (((val=="N")||val=="")) row.TPicFlag="Y"
				else row.TPicFlag="N"
			}
		})
	}
}
function checkboxFileFlagChange(TFileFlag,rowIndex)
{
	var row = jQuery('#menudatagrid').datagrid('getRows')[rowIndex];
	if (row)
	{
		$.each(row,function(key,val){
			if (TFileFlag==key)
			{
				if (((val=="N")||val=="")) row.TFileFlag="Y"
				else row.TFileFlag="N"
			}
		})
	}
}
function checkboxMustFlagChange(TMustFlag,rowIndex)
{
	var row = jQuery('#menudatagrid').datagrid('getRows')[rowIndex];
	if (row)
	{
		$.each(row,function(key,val){
			if (TMustFlag==key)
			{
				if (((val=="N")||val=="")) row.TMustFlag="Y"
				else row.TMustFlag="N"
			}
		})
	}
}
