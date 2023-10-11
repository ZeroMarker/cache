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
	initButton(); //按钮初始化 add by wy 2019-4-22
    initButtonWidth();
	setRequiredElements("User");
	initMessage("");
	defindTitleStyle();
	initDHCEQWChatUser();			//初始化表格
}
function setSelectValue(vElementID,item)
{
	setElement(vElementID+"DR",item.TRowID)
}
function clearData(vElementID)
{
	setElement(vElementID+"DR","")
}
function initDHCEQWChatUser(){

 $HUI.datagrid("#tDHCEQWChatUser",{   
	url:$URL, 
    queryParams:{
        ClassName:"web.DHCEQWChatUser",
        QueryName:"GetWChatUser",
    },
    singleSelect:true,
    fitColumns:true,    
    columns:[[
            {field:'TRowID',title:'TRowID',width:50,align:'center',hidden:true},  
            {field:'TChatID',title:'微信ID',width:50,align:'center'}, 
            {field:'TUserDR',title:'用户ID',width:50,align:'center',hidden:true}, 
            {field:'TUser',title:'用户',width:100,align:'center'},
            {field:'TGroupDR',title:'安全组ID',width:100,align:'center',hidden:true},
            {field:'TGroup',title:'安全组',width:100,align:'center'},
            {field:'TLocDR',title:'科室ID',width:100,align:'center',hidden:true},
            {field:'TLoc',title:'科室',width:100,align:'center'},
            {field:'TWcDate',title:'绑定日期',width:120,align:'center'}, 
            {field:'TPassWord',title:'密码',width:100,align:'center'},
            {field:'opt',title:'操作',width:100,align:'center',formatter: fomartOperation},  
            ]],
    pagination:true,
    pageSize:15,
    pageNumber:1,
    pageList:[15,30,45,60,75]   
	});
}
function fomartOperation(value,row,index){
        var btn=""
        if(row.TUserDR!=""){
            btn=btn+'<A onclick="DeleteBind(&quot;'+row.TRowID+'&quot;)" href="#" style="margin-left:5px">解绑</A>';
        }
        return btn
}
 //查询		需求号:264231
function BFind_Clicked()
{	 
 $HUI.datagrid("#tDHCEQWChatUser",{   
	url:$URL, 
    queryParams:{
        ClassName:"web.DHCEQWChatUser",
        QueryName:"GetWChatUser",
         User:getElementValue("UserDR"),
    },
    border:'true',
    singleSelect:true});	
}
function DeleteBind(RwoID){
    $.ajax({
            url :"dhceq.jquery.method.csp",
            type:"POST",
            data:{
                ClassName:"web.DHCEQWChatUser",
                MethodName:"DeleteBind",
                Arg1:RwoID,
                ArgCnt:1
            },
            beforeSend: function () {
                $.messager.progress({
                text: '正在保存中...'
                });
            },
            error:function(XMLHttpRequest, textStatus, errorThrown){
                        alert(XMLHttpRequest.status);
                        alert(XMLHttpRequest.readyState);
                        alert(textStatus);
                    },
            success:function (data, response, status) {
            $.messager.progress('close');
            //alert(data);
            if (data ==0) {
            $('#tDHCEQWChatUser').datagrid('reload'); 
            $.messager.show({
                title: '提示',
                msg: '删除成功'
            }); 
            }   
            else {
               $.messager.alert('删除失败！',data, 'warning')
               return;
               }
            }
            })    
}
