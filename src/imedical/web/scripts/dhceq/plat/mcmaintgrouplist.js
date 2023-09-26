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
//��ʼ����ѯͷ���
function initTopPanel()
{
    initLookUp();
	initButtonWidth();
	jQuery('#BFind').on("click", BFind_Clicked);
	setRequiredElements("User")
	initMessage("");
	defindTitleStyle();
	initdatagridData();			//��ʼ�����
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
                text:'����',          
                handler: function(){
                     AddGridData();
                }   
                },  //modify by lmm 2020-04-09
                {         
                iconCls: 'icon-save',
                text:'����',          
                handler: function(){
                     UpdateGridData();
                }   
                },  //modify by lmm 2020-04-09
                {        
                iconCls: 'icon-cancel', 
                text:'ɾ��',      
                 handler: function(){
                     DeleteGridData();
                     }      
                 }] , 
   
    columns:[[
    	{field:'TRowID',title:'TRowID',width:50,hidden:true},
        {field:'TMaintGroupDR',title:'MaintGroupDR',width:100,align:'center',hidden:true},
        {field:'TMaintGroup',title:'ά����',width:100,align:'center'},   
        {field:'TUser',title:'��Ա',width:90,align:'center'},
        {field:'TUserdr',title:'UserDR',width:100,align:'center',hidden:true},
        {field:'TManagerFlag',title:'������',width:100,align:'center'},
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
function BFind_Clicked()  // ��ѯ
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
                text: '���ڱ�����...'
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
                title: '��ʾ',
                msg: '����ɹ�'
            });
			ClearElement();	///�����������Ӧ���		
            }   
            else {
               $.messager.alert('����ʧ�ܣ�',data, 'warning')
               return;
               }
           }
        })
}
function getUrlParam(MGroupDR) 
{
	var reg = new RegExp("(^|&)" + MGroupDR + "=([^&]*)(&|$)"); //����һ������Ŀ�������������ʽ����
	var r = window.location.search.substr(1).match(reg);  //ƥ��Ŀ�����
	if (r != null) return unescape(r[2]); return null; //���ز���ֵ
}
function UpdateGridData(){
	if (getElementValue("RowID")==""){
		$.messager.alert("����", "��ѡ��һ�У�", 'error') 
            return false;
	}
    if (getElementValue("UserDR")==""){
            $.messager.alert("����", "��Ա����Ϊ�գ�", 'error')
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
                text: '���ڸ�����...'
                });
            },
           	error:function(XMLHttpRequest, textStatus, errorThrown){
                        messageShow("","","",XMLHttpRequest.status);
                        messageShow("","","",XMLHttpRequest.readyState);
                        messageShow("","","",textStatus);
                    },
            success:function (data, response, status) {
            $.messager.progress('close');
            if (data==0) {  /// ���ݷ���ֵ�ж��Ƿ�ɹ�
            $('#maintgrouplistdatagrid').datagrid('reload'); 
            $.messager.show({
                title: '��ʾ',
                msg: '���³ɹ�'
            });
            ClearElement(); 
            }   
            else {
               $.messager.alert('����ʧ�ܣ�',data, 'warning')
               return;
               }
           }
        })
}
function DeleteGridData(){
    if (getElementValue("RowID")==""){
            $.messager.alert("����", "��ѡ��һ�У�", 'error') 
            return false;
    } 
    var rows = $('#maintgrouplistdatagrid').datagrid('getSelections');
    var ids = [];
    var unSaveIndexs = [];
    if (rows.length > 0) {
        $.messager.confirm('��ȷ��', '��ȷ��Ҫɾ����ѡ���У�', function (b) { 
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
                title: '��ʾ',
                msg: 'ɾ���ɹ�'
            });
			ClearElement();  ///  ɾ���������Ӧ���	
            }   
            else {
               $.messager.alert('ɾ��ʧ�ܣ�',data, 'warning')
               return;
               }
           }
            
        })
        }       
        })
       
    }
    else
    {
        $.messager.alert("����","��ѡ��һ�У�",'err')
    }
}
/// ����:��պ���
function ClearElement(){
	setElement("RowID","")
    setElement("UserDR","")
	setElement("User","")
    setElement("MaintGroupDR","")
	setElement("ManagerFlag","")
}
