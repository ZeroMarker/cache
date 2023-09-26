var selectedRowID = 0;
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
    initLookUp();
	initButtonWidth();
	jQuery('#BFind').on("click", BFind_Clicked);
	setRequiredElements("User")
	initMessage("");
	defindTitleStyle();
	initdatagridData();			//初始化表格
}
function GetCheckValue(checkName)
{
	return (jQuery("#" + checkName).is(':checked')==true)?"Y":"N";
}
function setSelectValue(vElementID,item)
{
	setElement(vElementID+"DR",item.TRowID)
}
function clearData(vElementID)
{
	setElement(vElementID+"DR","")
}
function maintgrouplistDataGrid_OnClickRow()
{
     var selected=$('#maintgrouplistdatagrid').datagrid('getSelected');
     if (selected)
     {       
        var selectedRowID=selected.TRowID;
        if(preRowID!=selectedRowID)
        {
	        
         setElement("RowID",selected.TRowID)
	     setElement("UserDR",selected.TUserdr)
	     setElement("User",selected.TUser)
	     setElement("ManagerFlag",selected.TManagerFlag)
		     preRowID=selectedRowID;
	     }
         else
         {
             ClearElement();
             SelectedRowID = 0;
             preRowID=0;
         }
     }
} 
function initdatagridData(){
$('#maintgrouplistdatagrid').datagrid({   
    url:'dhceq.jquery.csp', 
    queryParams:{
        ClassName:"web.DHCEQ.Plat.MCMaintGroupList",
        QueryName:"GetMaintGroupList",
        Arg1:"",
        Arg2:getElementValue("MGroupDR"),
        ArgCnt:2
    },
    border:false,   //modify by lmm 2020-04-09
    singleSelect:true,
    toolbar:[{  
                iconCls: 'icon-add',
                text:'新增',          
                handler: function(){
                     AddGridData();
                }   
                },  //modify by lmm 2020-04-09
                {         
                iconCls: 'icon-save',
                text:'保存',          
                handler: function(){
                     UpdateGridData();
                }   
                },  //modify by lmm 2020-04-09
                {        
                iconCls: 'icon-cancel', 
                text:'删除',      
                 handler: function(){
                     DeleteGridData();
                     }      
                 }] , 
   
    columns:[[
    	{field:'TRowID',title:'TRowID',width:50,hidden:true},
        {field:'TMaintGroupDR',title:'MaintGroupDR',width:100,align:'center',hidden:true},
        {field:'TMaintGroup',title:'维修组',width:100,align:'center'},   
        {field:'TUser',title:'成员',width:90,align:'center'},
        {field:'TUserdr',title:'UserDR',width:100,align:'center',hidden:true},
        {field:'TManagerFlag',title:'管理者',width:100,align:'center'},
    ]],
    onClickRow : function (rowIndex, rowData) {
        maintgrouplistDataGrid_OnClickRow();
    }, 
    pagination:true,
    pageSize:15,
    pageNumber:1,
    pageList:[15,30,45,60,75]   
});
}
function BFind_Clicked()  // 查询
{ 
	$HUI.datagrid("#maintgrouplistdatagrid",{   
	url:$URL, 
    queryParams:{
        ClassName:"web.DHCEQ.Plat.MCMaintGroupList",
        QueryName:"GetMaintGroupList", 
        MemberUser:getElementValue("User"),	
        MGroupDR:getElementValue("MGroupDR"),
        MFlag:GetCheckValue("ManagerFlag"),	
        CurUserID:getElementValue("CurUserID"),
    },
    border:'true',
    singleSelect:true});
    //ClearElement();
}
function AddGridData(){	
	 if (checkMustItemNull()) return
       var MaintGroupListInfo="^"+getUrlParam('MGroupDR')+"^"+getElementValue("UserDR")+"^"+GetCheckValue("ManagerFlag")+"^"+getElementValue("InvalidFlag")
    $.ajax({
            url :"dhceq.jquery.method.csp",
            type:"POST",
            data:{
                ClassName:"web.DHCEQ.Plat.MCMaintGroupList",
                MethodName:"SaveMaintGroupList",
                Arg1:MaintGroupListInfo,
                ArgCnt:1
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
            if (data ==0) {
            $('#maintgrouplistdatagrid').datagrid('reload'); 
            $.messager.show({
                title: '提示',
                msg: '保存成功'
            });
			ClearElement();	///新增后输入框应清空		
            }   
            else {
               $.messager.alert('保存失败！',data, 'warning')
               return;
               }
           }
        })
}
function getUrlParam(MGroupDR) 
{
	var reg = new RegExp("(^|&)" + MGroupDR + "=([^&]*)(&|$)"); //构造一个含有目标参数的正则表达式对象
	var r = window.location.search.substr(1).match(reg);  //匹配目标参数
	if (r != null) return unescape(r[2]); return null; //返回参数值
}
function UpdateGridData(){
	if (getElementValue("RowID")==""){
		$.messager.alert("错误", "请选中一行！", 'error') 
            return false;
	}
    if (getElementValue("UserDR")==""){
            $.messager.alert("错误", "成员不能为空！", 'error')
            return false;
    }
    var MaintGroupInfoListInfo=getElementValue("RowID")+"^"+getUrlParam('MGroupDR')+"^"+getElementValue("UserDR")+"^"+GetCheckValue("ManagerFlag")
   $.ajax({            
     url :"dhceq.jquery.method.csp",
            type:"POST",
            data:{
                ClassName:"web.DHCEQ.Plat.MCMaintGroupList",
                MethodName:"SaveMaintGroupList",
                Arg1:MaintGroupInfoListInfo,
		        ArgCnt:1
            },
            beforeSend: function () {
                $.messager.progress({
                text: '正在更新中...'
                });
            },
           	error:function(XMLHttpRequest, textStatus, errorThrown){
                        messageShow("","","",XMLHttpRequest.status);
                        messageShow("","","",XMLHttpRequest.readyState);
                        messageShow("","","",textStatus);
                    },
            success:function (data, response, status) {
            $.messager.progress('close');
            if (data==0) {  /// 根据返回值判断是否成功
            $('#maintgrouplistdatagrid').datagrid('reload'); 
            $.messager.show({
                title: '提示',
                msg: '更新成功'
            });
            ClearElement(); 
            }   
            else {
               $.messager.alert('更新失败！',data, 'warning')
               return;
               }
           }
        })
}
function DeleteGridData(){
    if (getElementValue("RowID")==""){
            $.messager.alert("错误", "请选中一行！", 'error') 
            return false;
    } 
    var rows = $('#maintgrouplistdatagrid').datagrid('getSelections');
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
                ClassName:"web.DHCEQ.Plat.MCMaintGroupList",
                MethodName:"DeleteMaintGroupList",
                Arg1:getElementValue("RowID"),
                ArgCnt:1
            },
            success:function (data, response, status) {
            $.messager.progress('close');
            if (data ==0) {
            $('#maintgrouplistdatagrid').datagrid('reload');
            $.messager.show({
                title: '提示',
                msg: '删除成功'
            });
			ClearElement();  ///  删除后输入框应清空	
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
        $.messager.alert("错误","请选择一行！",'err')
    }
}
/// 描述:清空函数
function ClearElement(){
	setElement("RowID","")
    setElement("UserDR","")
	setElement("User","")
    setElement("MaintGroupDR","")
	setElement("ManagerFlag","")
}
