var SelectedRowID = 0;
var preRowID=0; 
//�������
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
	initButton(); //��ť��ʼ�� add by wy 2019-4-22
    initButtonWidth();
	//jQuery('#BAdd').on("click", BAdd_Clicked);    // MZY0154	3257806		2023-03-03  �����ظ�����
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
        {field:'TCode',title:'����',width:60,align:'center'},
        {field:'TName',title:'����',width:100,align:'center'},       
        {field:'TModuleType',title:'ģ��',width:100,align:'center'},  
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
			$.messager.popover({msg:"����ʧ��,�����ѡ��һ����¼",type:'alert'});
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
            if (data >0) {
            $('#tDHCEQCBussType').datagrid('reload'); 
            $.messager.popover({msg:"����ɹ�",type:'success'});
			ClearElement();
            }   
            else {
	           $.messager.popover({msg:"����ʧ��",type:'error'});
               return;
               }
           }
           
  
        })
}
function BSave_Clicked(){
	if (getElementValue("RowID")==""){
			$.messager.popover({msg:"��ѡ��һ��",type:'alert'});
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
            if (data==0) { 
            $('#tDHCEQCBussType').datagrid('reload'); 
            $.messager.popover({msg:"����ɹ�",type:'success'});
			ClearElement();
            }   
            else {
               $.messager.popover({msg:"����ʧ��",type:'error'});
               return;
               }
           }
           
  
        })
}
function BDelete_Clicked(){
    if (getElementValue("RowID")==""){
            $.messager.popover({msg:"��ѡ��һ��",type:'alert'}); 
            return false;
    } 
    var rows = $('#tDHCEQCBussType').datagrid('getSelections');
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
                ClassName:"web.DHCEQ.Plat.CTBussType",
                MethodName:"DeleteBussType",
                Arg1:getElementValue("RowID"),
                ArgCnt:1
            },
            success:function (data, response, status) {
            $.messager.progress('close');
            if (data ==0) {
            $('#tDHCEQCBussType').datagrid('reload');
            $.messager.popover({msg:"ɾ���ɹ�",type:'success'});
			ClearElement();
            }   
            else {
	           $.messager.popover({msg:"ɾ��ʧ��",type:'error'});
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
				text: '�豸����'
			},{
				id: '2',
				text: 'ά�޹���'
			},{
				id: '3',
				text: 'Ч�����'
			},{
				id: '4',
				text: '�ƶ��̵�'
			},{
				id: '5',
				text: '�ƶ�ά��'
			},
			//Modified By QW20200116 begin BUG:QW0039�����ƶ����ռ�����
			{
				id: '6',
				text: '�ƶ�����'
			},{
				id: '7',
				text: '�ƶ�����'
			}]
			//Modified By QW20200116 end BUG:QW0039�����ƶ����ռ�����
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


