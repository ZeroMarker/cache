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
//��ʼ����ѯͷ���
function initTopPanel()
{
	initButtonWidth();
	initLookUp();
	jQuery('#BFind').on("click", BFind_Clicked);
	defindTitleStyle();
	initDHCEQCManageLimitList();			//��ʼ�����
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
                text:'����',          
                handler: function(){   /// Modfied by zc 2015-07-30 ZC0027
                     AddgridData();
                }   
                },   //modify by lmm 2020-04-09
                {         
                iconCls: 'icon-update',
                text:'����',          
                handler: function(){
                     SavegridData();
                }   
                },   //modify by lmm 2020-04-09
                {        
                iconCls: 'icon-cancel', 
                text:'ɾ��',      
                 handler: function(){
                     DeleteGridData();
                     }      
                 }] , 
    	columns:[[
    		{field:'TRowID',title:'TRowID',width:50,hidden:'true'},    
        	{field:'TTypeDR',title:'TTypeDR',width:100,align:'center',hidden:'true'},
        	{field:'TType',title:'����',width:100,align:'center'},
        	{field:'TValueDR',title:'TValueDR',width:300,align:'left',hidden:'true'},
        	{field:'TValue',title:'����',width:300,align:'left'},
			{field:'TAccessflag',title:'���ʱ�ʶ',width:60,align:'center'}
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
///�޶���ϸ�޷���ѯ
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
/// ����:����AddgridData����
function AddgridData(){
	if (getElementValue("Value")==""){
            $.messager.alert("����", "���ݲ���Ϊ�գ�", 'error')
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
                text: '���ڱ�����...'
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
                title: '��ʾ',
                msg: '����ɹ�'
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
function SavegridData(){
	if (getElementValue("RowID")==""){
            $.messager.alert("����", "��ѡ��һ�У�", 'error')  
            return false;
    }
    if (getElementValue("Value")==""){
            $.messager.alert("����", "���ݲ���Ϊ�գ�", 'error')
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
                text: '���ڱ�����...'
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
                title: '��ʾ',
                msg: '����ɹ�'
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
    var rows = $('#tDHCEQCManageLimitList').datagrid('getSelections');
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
                title: '��ʾ',
                msg: 'ɾ���ɹ�'
            }); 
			ClearElement();    
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
        $.messager.alert("����","��ѡ��һ�У�",'error')
    }
}
/// ����:������պ���
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