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
	jQuery('#BAdd').on("click", BAdd_Clicked);
	setRequiredElements("Code^Desc")
	initMessage("");
	defindTitleStyle(); 
	initLocFlagData();
	initDHCEQCApproveRoleData();
	setEnabled();	// MZY0025	1318601		2020-05-13
}
function DHCEQCApproveRole_OnClickRow()
{	
     var selected=$('#tDHCEQCApproveRole').datagrid('getSelected');
     if (selected)
     {       
        var SelectedRowID=selected.TRowID;
        if(preRowID!=SelectedRowID)
        {
	    	 setElement("RowID",SelectedRowID)
	         setElement("Code",selected.TCode)
	         setElement("Desc",selected.TName)
	         setElement("LocFlag",selected.TLocFlagDR)
	         setElement("Remark",selected.TRemark)
             preRowID=SelectedRowID;
             setDisEnabled();	// MZY0025	1318601		2020-05-13
         }
         else
         {
             ClearElement();
             $('#tDHCEQCApproveRole').datagrid('unselectAll');
             SelectedRowID = 0;
             preRowID=0;
             setEnabled();	// MZY0025	1318601		2020-05-13
         }
     }
} 
function initDHCEQCApproveRoleData(){
	$HUI.datagrid("#tDHCEQCApproveRole",{   
	    url:$URL, 
    	queryParams:{
        ClassName:"web.DHCEQ.Plat.CTApproveRole",
        QueryName:"GetRole",
        Code:getElementValue("Code"),
        Desc:getElementValue("Desc"),
        LocFlag:getElementValue("LocFlag"),
    	},
  		singleSelect:true,
   		fitColumns:true,       
    columns:[[
    	{field:'TRowID',title:'TRowID',width:50,hidden:'ture'},    
        {field:'TCode',title:'����',width:60,align:'center'},
        {field:'TName',title:'����',width:100,align:'center'},       
        {field:'TLocFlag',title:'������ҷ�Χ',width:100,align:'center'},  
        {field:'TLocFlagDR',title:'TLocFlagDR',width:100,align:'center',hidden:'ture'},
        {field:'TRemark',title:'��ע',width:100,align:'center'}, 
        {field:'opt',title:'ҵ��',width:100,align:'center',formatter: fomartOperation},                
    ]],
    onClickRow : function (rowIndex, rowData) {
        DHCEQCApproveRole_OnClickRow();
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
	setElement("LocFlag","")
	setElement("Remark","")
	setEnabled(); //Add By QW20210311 BUG:QW0095 ��������1804780
}	
function BFind_Clicked(){
	$HUI.datagrid("#tDHCEQCApproveRole",{   
	    url:$URL, 
    	queryParams:{
        ClassName:"web.DHCEQ.Plat.CTApproveRole",
        QueryName:"GetRole",
        Code:getElementValue("Code"),
        Desc:getElementValue("Desc"),
        LocFlag:getElementValue("LocFlag"),
    },
});
}
function fomartOperation(value,row,index)
 {
	var url='dhceq.plat.crolebuss.csp?&Role='+row.TRowID   //add by wy 2019-2-1 815075
	var width=""
	var height=""
	var icon="icon-paper"
	var title="��ɫ����ҵ����"
	var btn='<A onclick="showWindow(&quot;'+url+'&quot;,&quot;'+title+'&quot;,&quot;'+width+'&quot;,&quot;'+height+'&quot;,&quot;'+icon+'&quot;,&quot;&quot;,&quot;&quot;,&quot;&quot;,&quot;small&quot;)" href="#"><span class="icon-paper" style="display:inline-block;height:24px;width:24px;"></span></A>'  // modfied by wy 2019-2-19
	return btn;
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
                ClassName:"web.DHCEQ.Plat.CTApproveRole",
                MethodName:"AddRole",
                Arg1:getElementValue("Code"),
                Arg2:getElementValue("Desc"),
                Arg3:getElementValue("Remark"),
                Arg4:getElementValue("LocFlag"),
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
            if (data >0) {
            $('#tDHCEQCApproveRole').datagrid('reload'); 
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
                ClassName:"web.DHCEQ.Plat.CTApproveRole",
                MethodName:"SaveRole",
                Arg1:getElementValue("RowID"),
                Arg2:getElementValue("Code"),
                Arg3:getElementValue("Desc"),
                Arg4:getElementValue("Remark"),
                Arg5:getElementValue("LocFlag"),
                ArgCnt:5
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
            $('#tDHCEQCApproveRole').datagrid('reload'); 
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
    var rows = $('#tDHCEQCApproveRole').datagrid('getSelections');
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
                ClassName:"web.DHCEQ.Plat.CTApproveRole",
                MethodName:"DeleteRole",
                Arg1:getElementValue("RowID"),
                ArgCnt:1
            },
            success:function (data, response, status) {
            $.messager.progress('close');
            if (data ==0) {
            $('#tDHCEQCApproveRole').datagrid('reload');
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
function initLocFlagData()
{
	var LocFlag = $HUI.combobox('#LocFlag',{
		valueField:'id', textField:'text',panelHeight:"auto",
		data:[{
				id: '',
				text: ''
			},{
				id: '0',
				text: '����'
			},{
				id: '1',
				text: '����Ȩ��'
			},{
				id: '2',
				text: '����'
			},{
				id: '3',
				text: '��Ժ'
			},{
				id: '4',
				text: '����'
			},{
				id: '5',
				text: '����'
			}]
});
}

// MZY0025	1318601		2020-05-13
function setEnabled()
{
	disableElement("BSave",true);
	disableElement("BDelete",true);
	disableElement("BAdd",false);
}
function setDisEnabled()
{
	disableElement("BSave",false);
	disableElement("BDelete",false);
	disableElement("BAdd",true);
}