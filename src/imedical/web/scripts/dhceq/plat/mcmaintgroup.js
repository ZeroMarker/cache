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
	initButton(); //按钮初始化 add by wy 2019-4-22
    initButtonWidth();
	jQuery('#BAdd').on("click", BAdd_Clicked);
	setRequiredElements("Code^Desc^User");
	initMessage("");
	defindTitleStyle();
	initdatagridData();			//初始化表格
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
              $('#maintgroupdatagrid').datagrid('unselectAll');  //add by mwz 20180313 需求号:550796
              setEnabled();		// MZY0025	1318605		2020-05-13
         }
     }
} 
//去除边框border:'true', modfied by wy 2019-2-19
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
        {field:'TCode',title:'代码',width:60,align:'center'},
        {field:'TDesc',title:'描述',width:150,align:'center'},       
        {field:'TRemark',title:'备注',width:100,align:'center'},  
        {field:'TInvalidFlag',title:'InvalidFlag',width:100,align:'center',hidden:true},
        {field:'TManageLocDR',title:'ManageLocDR',width:100,align:'center',hidden:true},
        {field:'TUserdr',title:'TUserdr',width:100,align:'center',hidden:true},
        {field:'TUser',title:'组领导',width:100,align:'center'}, 
        {field:'TManageLoc',title:'管理科室',width:100,align:'center'},
        {field:'Check',title:'维修组成员',width:100,align:'center',formatter: CheckMaintGroupList} 
                       
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
function CheckMaintGroupList(value,row)  //查看维修组成员
{
	var str=row.TRowID;        // modfied by wy  2019-2-1 815075
	var str="MGroupDR="+str;
	var url="dhceq.plat.mcmaintgrouplist.csp?"+str
	var width=""
	var height=""
    var icon="icon-paper"
	var title="维修组成员"
	//modify by lmm 2020-06-05 UI
	 var btn='<A onclick="showWindow(&quot;'+url+'&quot;,&quot;'+title+'&quot;,&quot;'+width+'&quot;,&quot;'+height+'&quot;,&quot;'+icon+'&quot;,&quot;&quot;,&quot;&quot;,&quot;&quot;,&quot;small&quot;)" href="#"><span class="icon-paper" style="display:inline-block;height:24px;width:24px;"></span></A>' /// modfied by wy 2019-2-1
	return btn;
}
 //查询		需求号:264231
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
/// 新增AddGridData方法
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
            $('#maintgroupdatagrid').datagrid('reload'); 
            $.messager.show({
                title: '提示',
                msg:'保存成功'
            });
		CleareElement();	
            }   
            else {
               $.messager.alert('保存失败！',data, 'warning')
               return;
               }
           }
        })
}
function BSave_Clicked() //更新
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
            if (data==0) {   ///根据返回值判断是否成功
            $('#maintgroupdatagrid').datagrid('reload'); 
            $.messager.show({
                title: '提示',
                msg: '更新成功'
            }); 
    
            }   
            else {
               $.messager.alert('更新失败！',data, 'warning')
               return;
               }
           }
        })
}
function BDelete_Clicked(){
    if ($('#RowID').val()==""){
            $.messager.alert("错误", "请选中一行！", 'error') 
            return false;
    } 
    var rows = $('#maintgroupdatagrid').datagrid('getSelections');
    var ids = [];
    var unSaveIndexs = [];
    if (rows.length > 0) {
        $.messager.confirm('请确认','您确定要删除所选的行？', function (b) { 
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
                title: '提示',
                msg: '删除成功'
            });
		CleareElement();  /// 删除后输入框应清空	
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

/// 描述:新增清空函数
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