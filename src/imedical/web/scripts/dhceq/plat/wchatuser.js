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
//��ʼ����ѯͷ���
function initTopPanel()
{
	initLookUp();
	initButton(); //��ť��ʼ�� add by wy 2019-4-22
    initButtonWidth();
	setRequiredElements("User");
	initMessage("");
	defindTitleStyle();
	initDHCEQWChatUser();			//��ʼ�����
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
            {field:'TChatID',title:'΢��ID',width:50,align:'center'}, 
            {field:'TUserDR',title:'�û�ID',width:50,align:'center',hidden:true}, 
            {field:'TUser',title:'�û�',width:100,align:'center'},
            {field:'TGroupDR',title:'��ȫ��ID',width:100,align:'center',hidden:true},
            {field:'TGroup',title:'��ȫ��',width:100,align:'center'},
            {field:'TLocDR',title:'����ID',width:100,align:'center',hidden:true},
            {field:'TLoc',title:'����',width:100,align:'center'},
            {field:'TWcDate',title:'������',width:120,align:'center'}, 
            {field:'TPassWord',title:'����',width:100,align:'center'},
            {field:'opt',title:'����',width:100,align:'center',formatter: fomartOperation},  
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
            btn=btn+'<A onclick="DeleteBind(&quot;'+row.TRowID+'&quot;)" href="#" style="margin-left:5px">���</A>';
        }
        return btn
}
 //��ѯ		�����:264231
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
                text: '���ڱ�����...'
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
                title: '��ʾ',
                msg: 'ɾ���ɹ�'
            }); 
            }   
            else {
               $.messager.alert('ɾ��ʧ�ܣ�',data, 'warning')
               return;
               }
            }
            })    
}
