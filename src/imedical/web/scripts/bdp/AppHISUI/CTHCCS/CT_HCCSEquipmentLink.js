/*
* @Author: 基础数据平台-杨帆
* @Date:   2020-12-23
* @描述:医呼通设备-发放记录查询弹窗
*/

var init=function()
{
   //发放记录查询
   var columns =[[
					{field:'ELCLRowId',title:'ELCLRowId',width:100,sortable:true,hidden:true},
					{field:'ELCLUser',title:'用户',width:200,sortable:true},
					{field:'ELCLLoc',title:'科室',width:200,sortable:true},
					{field:'HCCSCLVOIPNumber',title:'VOIP号码',width:180,sortable:true},
					{field:'ELCLDateFrom',title:'关联开始日期',width:120,sortable:true},
					{field:'ELCLDateTo',title:'关联结束日期',width:120,sortable:true}
    ]];
    var grid = $HUI.datagrid("#grid",{
        url:$URL,
        queryParams:{
            ClassName:"web.DHCBL.CT.CTHCCSEquipLinkContList",
            QueryName:"GetList",
			equipmentDR:EQRowId
        },
        columns: columns,  //列信息
        pagination: true,   //pagination	boolean	设置为 true，则在数据网格（datagrid）底部显示分页工具栏。
        pageSize:10,
        pageList:[5,10,15,20,25,30,50,75,100,200,300,500,1000],
        singleSelect:true,
        remoteSort:false,
        //ClassTableName:'User.CTHCCSEquipLinkContList',
		//SQLTableName:'CT_HCCSEquipLinkContList',
        idField:'ELCLRowId',
        rownumbers:true,    //设置为 true，则显示带有行号的列。
        fitColumns:true, //设置为 true，则会自动扩大或缩小列的尺寸以适应网格的宽度并且防止水平滚动
        onDblClickRow:function(rowIndex,rowData){
        	UpdateData();
        },
        onLoadSuccess:function(data){
	        $(this).prev().find('div.datagrid-body').prop('scrollTop',0);  //如果有滚动条，滚动到最上面
        	$(this).datagrid('columnMoving'); //列可以拖拽改变顺序
        }		
    });

    //搜索
    $('#btnSearch').click(function(e){
        SearchEquipment();
    });
	
    //搜索方法
    SearchEquipment=function()
    {
		var EquipmentUser=$("#EquipmentUser").combobox('getValue');
		var EquipmentLoc=$("#EquipmentLoc").combobox('getValue');
        $('#grid').datagrid('reload',  {
                ClassName:"web.DHCBL.CT.CTHCCSEquipLinkContList",
                QueryName:"GetList",
				'equipmentDR':EQRowId,
				'userid':EquipmentUser,
				'locid':EquipmentLoc,
        });
        $('#grid').datagrid('unselectAll');        
    }    
    //重置
    $('#btnRefresh').click(function(e){
    	RefreshEquipment();
    });

    //重置方法
    RefreshEquipment=function()
    {
		$("#EquipmentUser").combobox('setValue','');
		$("#EquipmentLoc").combobox('setValue','');
    	$('#grid').datagrid('reload',  {
            	ClassName:"web.DHCBL.CT.CTHCCSEquipLinkContList",
            	QueryName:"GetList",
				equipmentDR:EQRowId
    	});
		$('#grid').datagrid('unselectAll');     
    } 
	
	//查询工具栏用户下拉框
	$('#EquipmentUser').combobox({ 
		url:$URL+"?ClassName=web.DHCBL.CT.SSUser&QueryName=GetDataForCmb1&ResultSetType=array",
		valueField:'SSUSRInitials',
		textField:'SSUSRName',
		onBeforeLoad: function(param){
			param.hospid = HospID;
		}
	});
	
	//查询工具栏科室下拉框
	$('#EquipmentLoc').combobox({ 
		url:$URL+"?ClassName=web.DHCBL.CT.CTLoc&QueryName=GetDataForCmb1&ResultSetType=array",
		valueField:'CTLOCCode',
		textField:'CTLOCDesc',
		onBeforeLoad: function(param){
			param.hospid = HospID;
		}
	});
	
}
$(init);