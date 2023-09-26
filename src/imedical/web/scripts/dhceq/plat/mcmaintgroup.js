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
	initButton(); //��ť��ʼ�� add by wy 2019-4-22
    initButtonWidth();
	jQuery('#BAdd').on("click", BAdd_Clicked);
	setRequiredElements("Code^Desc^User");
	initMessage("");
	defindTitleStyle();
	initdatagridData();			//��ʼ�����
	setEnabled();		// MZY0025	1318605		2020-05-13
}
function setSelectValue(vElementID,item)
{
	setElement(vElementID+"DR",item.TRowID)
}
function clearData(vElementID)
{
	setElement(vElementID+"DR","")
}
function maintgroupDataGrid_OnClickRow()  
{
     var selected=$('#maintgroupdatagrid').datagrid('getSelected');
     if (selected)
     {     
        var selectedRowID=selected.TRowID;
        if(preRowID!=selectedRowID)
        {	
         setElement("RowID",selected.TRowID);
		 setElement("Code",selected.TCode);
		 setElement("Desc",selected.TDesc);
		 setElement("Remark",selected.TRemark);
	     setElement("UserDR",selected.TUserdr);
	     setElement("User",selected.TUser);
	     setElement("ManageLocDR",selected.TManageLocDR);
	     setElement("ManageLoc",selected.TManageLoc);
	     setElement("InvalidFlag",selected.TInvalidFlag);
         preRowID=selectedRowID;
         setDisEnabled();		// MZY0025	1318605		2020-05-13
         }
         else
         {
	         CleareElement();
             selectedRowID = 0;
             preRowID=0;
              $('#maintgroupdatagrid').datagrid('unselectAll');  //add by mwz 20180313 �����:550796
              setEnabled();		// MZY0025	1318605		2020-05-13
         }
     }
} 
//ȥ���߿�border:'true', modfied by wy 2019-2-19
function initdatagridData(){

 $HUI.datagrid("#maintgroupdatagrid",{   
	url:$URL, 
    queryParams:{
        ClassName:"web.DHCEQ.Plat.MCMaintGroup",
        QueryName:"GetMaintGroup",
    },
    singleSelect:true,
    fitColumns:true,    
    columns:[[
    	{field:'TRowID',title:'TRowID',width:50,hidden:'true'},    
        {field:'TCode',title:'����',width:60,align:'center'},
        {field:'TDesc',title:'����',width:150,align:'center'},       
        {field:'TRemark',title:'��ע',width:100,align:'center'},  
        {field:'TInvalidFlag',title:'InvalidFlag',width:100,align:'center',hidden:true},
        {field:'TManageLocDR',title:'ManageLocDR',width:100,align:'center',hidden:true},
        {field:'TUserdr',title:'TUserdr',width:100,align:'center',hidden:true},
        {field:'TUser',title:'���쵼',width:100,align:'center'}, 
        {field:'TManageLoc',title:'�������',width:100,align:'center'},
        {field:'Check',title:'ά�����Ա',width:100,align:'center',formatter: CheckMaintGroupList} 
                       
    ]],
    onClickRow : function (rowIndex, rowData) {
        maintgroupDataGrid_OnClickRow();
    }, 
    pagination:true,
    pageSize:15,
    pageNumber:1,
    pageList:[15,30,45,60,75]   
	});
}
function CheckMaintGroupList(value,row)  //�鿴ά�����Ա
{
	var str=row.TRowID;        // modfied by wy  2019-2-1 815075
	var str="MGroupDR="+str;
	var url="dhceq.plat.mcmaintgrouplist.csp?"+str
	var width=""
	var height=""
    var icon="icon-paper"
	var title="ά�����Ա"
	//modify by lmm 2020-06-05 UI
	 var btn='<A onclick="showWindow(&quot;'+url+'&quot;,&quot;'+title+'&quot;,&quot;'+width+'&quot;,&quot;'+height+'&quot;,&quot;'+icon+'&quot;,&quot;&quot;,&quot;&quot;,&quot;&quot;,&quot;small&quot;)" href="#"><span class="icon-paper" style="display:inline-block;height:24px;width:24px;"></span></A>' /// modfied by wy 2019-2-1
	return btn;
}
 //��ѯ		�����:264231
function BFind_Clicked()
{	 
 $HUI.datagrid("#maintgroupdatagrid",{   
	url:$URL, 
    queryParams:{
        ClassName:"web.DHCEQ.Plat.MCMaintGroup",
        QueryName:"GetMaintGroup",
         vCode:getElementValue("Code"),
         VDesc:getElementValue("Desc"),
         vuser:getElementValue("UserDR"),
         vLocDR:getElementValue("ManageLocDR"),
         vRemark:getElementValue("Remark"),

    },
    border:'true',
    singleSelect:true});
    //CleareElement();		
}
/// ����AddGridData����
    function BAdd_Clicked(){
	if (checkMustItemNull()) return
     var MaintGroupInfo="^"+getElementValue("Code")+"^"+getElementValue("Desc")+"^"+getElementValue("Remark")+"^"+getElementValue("UserDR")+"^"+getElementValue("InvalidFlag")+"^"+getElementValue("ManageLocDR")
    $.ajax({
            url :"dhceq.jquery.method.csp",
            type:"POST",
            data:{
                ClassName:"web.DHCEQ.Plat.MCMaintGroup",
                MethodName:"SaveMaintGroup",
                Arg1:MaintGroupInfo,
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
            $('#maintgroupdatagrid').datagrid('reload'); 
            $.messager.show({
                title: '��ʾ',
                msg:'����ɹ�'
            });
		CleareElement();	
            }   
            else {
               $.messager.alert('����ʧ�ܣ�',data, 'warning')
               return;
               }
           }
        })
}
function BSave_Clicked() //����
{
	 if (checkMustItemNull()) return
    	   var MaintGroupInfo=getElementValue("RowID")+"^"+getElementValue("Code")+"^"+getElementValue("Desc")+"^"+getElementValue("Remark")+"^"+getElementValue("UserDR")+"^"+getElementValue("InvalidFlag")+"^"+getElementValue("ManageLocDR")
    $.ajax({
            url :"dhceq.jquery.method.csp",
            type:"POST",
            data:{
                ClassName:"web.DHCEQ.Plat.MCMaintGroup",
                MethodName:"SaveMaintGroup",
                Arg1:MaintGroupInfo,
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
            if (data==0) {   ///���ݷ���ֵ�ж��Ƿ�ɹ�
            $('#maintgroupdatagrid').datagrid('reload'); 
            $.messager.show({
                title: '��ʾ',
                msg: '���³ɹ�'
            }); 
    
            }   
            else {
               $.messager.alert('����ʧ�ܣ�',data, 'warning')
               return;
               }
           }
        })
}
function BDelete_Clicked(){
    if ($('#RowID').val()==""){
            $.messager.alert("����", "��ѡ��һ�У�", 'error') 
            return false;
    } 
    var rows = $('#maintgroupdatagrid').datagrid('getSelections');
    var ids = [];
    var unSaveIndexs = [];
    if (rows.length > 0) {
        $.messager.confirm('��ȷ��','��ȷ��Ҫɾ����ѡ���У�', function (b) { 
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
                ClassName:"web.DHCEQ.Plat.MCMaintGroup",
                MethodName:"DeleteMaintGroup",
                Arg1:$('#RowID').val(),
                ArgCnt:1
            },
            success:function (data, response, status) {
            $.messager.progress('close');
            if (data ==0) {
            $('#maintgroupdatagrid').datagrid('reload');
            $.messager.show({
                title: '��ʾ',
                msg: 'ɾ���ɹ�'
            });
		CleareElement();  /// ɾ���������Ӧ���	
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

/// ����:������պ���
function CleareElement()
{
	setElement("RowID","")
	setElement("Code","")
	setElement("Desc","")
	setElement("Remark","")
    setElement("UserDR","")
	setElement("User","")
    setElement("ManageLocDR","")
	setElement("ManageLoc","")
	setElement("InvalidFlag","")
}

// MZY0025	1318605		2020-05-13
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