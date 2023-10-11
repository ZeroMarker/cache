/*
Creator:谷雪萍
CreatDate:2020-03-19
Description:医用知识库医为百科和医嘱项对照
*/
//界面初始化
var init = function(){
	
	var QUERY_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.MKB.MKBTermProDetail&pClassMethod=GetMyList";
    //工具栏属性下拉框
	$('#propertyCombo').combobox({
        url:$URL+"?ClassName=web.DHCBL.MKB.MKBOrderContrast&QueryName=GetDataForCmb&ResultSetType=array",
        valueField:'MKBTPRowId',
        textField:'MKBTPDesc',
		onLoadSuccess:function(){
			var data= $(this).combobox("getData");
            if (data.length > 0) {
                 $('#propertyCombo').combobox('select', data[0].MKBTPRowId);
            }

		},
		onSelect:function(record){
			TermSearch();
		}
    }); 
    //医为百科属性内容列
	var mkbcolumns =[[
		  {field:'MKBTPDRowId',title:'MKBTPDRowId',width:150,sortable:true,hidden:true},
		  {field:'MKBTPDDesc',title:'中心词',width:200,sortable:true},
		  {field:'MKBTPDRemark',title:'备注',width:300,sortable:true,
					formatter:function(value,row,index){  
						//鼠标悬浮显示备注信息
						return '<span title="'+row.MKBTPDRemark+'">'+value+'</span>'
					}}
    ]];
    
    //医为百科属性内容列表
    var mkbgrid = $HUI.datagrid("#mkbgrid",{  	
    	pagination: true,   //pagination	boolean	设置为 true，则在数据网格（datagrid）底部显示分页工具栏。
    	pageSize:PageSizeMain,
		pageList:[5,10,15,20,25,30,50,75,100,200,300,500,1000], 
		rownumbers:true,    //设置为 true，则显示带有行号的列。
        columns: mkbcolumns,  //列信息
        singleSelect:true,
        remoteSort:false,
        idField:'MKBTPDRowId',
        treeField:'MKBTPDDesc',  //树形列表必须定义 'treeField' 属性，指明哪个字段作为树节点。		
        fitColumns:true, //设置为 true，则会自动扩大或缩小列的尺寸以适应网格的宽度并且防止水平滚动
        //scrollbarSize :0,
        onClickRow:function(index,row)
        {
        	$('#contrastgrid').datagrid('options').url=$URL;  
	       	$('#contrastgrid').datagrid('load',  {
	            ClassName:"web.DHCBL.MKB.MKBOrderContrast",
	            QueryName:"GetContrastList",
	            id:row.MKBTPDRowId
        	});
        },
        onLoadSuccess:function(data){
			$(this).prev().find('div.datagrid-body').prop('scrollTop',0);
        }
   	
    });

	//术语搜索按钮
	$("#mkbSearch").click(function (e) { 
        TermSearch();
	}) ;
	//术语重置按钮
	$("#mkbRefresh").click(function (e) { 
		TermReset();
		
	});
	
    //术语搜索方法
	TermSearch=function()
	{
		var property=$("#propertyCombo").combobox('getValue');
		var desc=$.trim($('#mkbDesc').val());
		$('#mkbgrid').datagrid('options').url = QUERY_ACTION_URL; // 重新赋值url 属性
		$('#mkbgrid').datagrid('load',  {		
			'desc':desc,	
			'property':property
		});
		$('#mkbgrid').datagrid('unselectAll');
		$('#contrastgrid').datagrid('loadData',{ total: 0, rows: [] });
	}
	
	//术语清屏方法
	TermReset=function()
	{
		var property=$("#propertyCombo").combobox('getValue');
		$("#mkbDesc").val("");
		$('#mkbgrid').datagrid('options').url = QUERY_ACTION_URL; // 重新赋值url 属性
		$('#mkbgrid').datagrid('load',  {		
			'desc':"",	
			'property':property
		});
		$('#mkbgrid').datagrid('unselectAll');
		$('#contrastgrid').datagrid('loadData',{ total: 0, rows: [] });
	}
	
	//医嘱项列表列
	var hiscolumns =[[
        {field:'ARCIMRowId',title:'ARCIMRowId',width:100,hidden:true,sortable:true},
		{field:'ARCIMCode',title:'医嘱项代码',width:100,sortable:true},
        {field:'ARCIMDesc',title:'医嘱项描述',width:100,sortable:true},
        {field:'opt',title:'操作',width:50,align:'center',
			formatter:function(){  
				var btn = '<a class="contrast" href="#"  onclick="conMethod()" style="border:0px;cursor:pointer">对照</a>';  
				return btn;  
			}  
        }
        
    ]];
    //医嘱项列表
    var hisgrid = $HUI.datagrid("#hisgrid",{
        url:$URL,
        queryParams:{
            ClassName:"web.DHCBL.CT.ARCItmMast",
            QueryName:"GetDataForCmb1"
        },
        columns: hiscolumns,  //列信息
        pagination: true,   //pagination	boolean	设置为 true，则在数据网格（datagrid）底部显示分页工具栏。
        pageSize:PageSizeMain,
        pageList:[5,10,15,20,25,30,50,75,100,200,300,500,1000],
        remoteSort:false,
        idField:'RowId',
        singleSelect:true,
        rownumbers:true,    //设置为 true，则显示带有行号的列。
        fitColumns:true, //设置为 true，则会自动扩大或缩小列的尺寸以适应网格的宽度并且防止水平滚动
        onClickRow:function(index,row)
        {
        },
        onLoadSuccess:function(data){
			$(this).prev().find('div.datagrid-body').prop('scrollTop',0);
        }	
    });

	//医嘱项列表工具栏查询按钮
	$("#hisSearch").click(function (e) { 
			SearchOrder();
	})    
    //医嘱项列表工具栏查询方法
    function SearchOrder(){
        var desc=$.trim($('#hisDesc').val());
        $('#hisgrid').datagrid('load',  {
            ClassName:"web.DHCBL.CT.ARCItmMast",
            QueryName:"GetDataForCmb1",
            desc:desc	
        });
        $('#hisgrid').datagrid('unselectAll');
    }
    //医嘱项列表工具栏清屏按钮
    $("#hisRefresh").click(function (e) {
		ResetOrder();
    });
    
    //医嘱项列表工具栏清屏方法
    function ResetOrder(){
        $("#hisDesc").val('');
        $('#hisgrid').datagrid('load',  {
            ClassName:"web.DHCBL.CT.ARCItmMast",
            QueryName:"GetDataForCmb1"
        });
        $('#hisgrid').datagrid('unselectAll');
    }
	//对照方法
	conMethod=function()
	{
		setTimeout(function(){
			var record=$('#mkbgrid').treegrid('getSelected');
			var hisRecord=$('#hisgrid').datagrid('getSelected');
			if(!record)
			{
				$.messager.alert('错误提示','请选择一条医为百科数据！',"error");
            	return;
			}
			var ids=record.MKBTPDRowId+'^'+hisRecord.ARCIMRowId;
			var data=tkMakeServerCall("web.DHCBL.MKB.MKBOrderContrast","SaveData",ids);
			var data=eval('('+data+')');
			if(data.success=='true'){
				$.messager.popover({msg: '对照成功！',type:'success',timeout: 1000});
				$('#contrastgrid').datagrid('options').url=$URL;  
				$('#contrastgrid').datagrid('load',  {
	            	ClassName:"web.DHCBL.MKB.MKBOrderContrast",
	            	QueryName:"GetContrastList",
	            	id:record.MKBTPDRowId
	    		});
			}
			else{
				var errorMsg="对照失败！";
				if(data.info){
					errorMsg=errorMsg+'</br>错误信息:'+data.info
				}
				$.messager.alert('错误提示',errorMsg,'error',function(){})
		   }

		},100);	
	}
	//对照表列
	var columns =[[
        {field:'RowId',title:'RowId',width:100,hidden:true,sortable:true},
		{field:'MKBDetailDesc',title:'中心词',width:100,sortable:true},
		{field:'ARCIMCode',title:'医嘱项代码',width:100,sortable:true},
        {field:'ARCIMDesc',title:'医嘱项描述',width:100,sortable:true},
        {field:'OrderType',title:'医嘱类型',width:100,hidden:true,sortable:true},
        {field:'opt',title:'操作',width:50,align:'center',
			formatter:function(){  
				var btn = '<a class="contrast" href="#"  onclick="delContrast()" style="border:0px;cursor:pointer">删除</a>';  
				return btn;  
			}  
        }

    ]];
    
    //对照表
    var congrid = $HUI.datagrid("#contrastgrid",{
        //url:$URL,
        columns: columns,  //列信息
        pagination: true,   //pagination	boolean	设置为 true，则在数据网格（datagrid）底部显示分页工具栏。
        pageSize:PageSizeMain,
        pageList:[5,10,15,20,25,30,50,75,100,200,300,500,1000],
        remoteSort:false,
        singleSelect:true,
        idField:'RowId',
        rownumbers:true,    //设置为 true，则显示带有行号的列。
        fitColumns:true, //设置为 true，则会自动扩大或缩小列的尺寸以适应网格的宽度并且防止水平滚动
        onClickRow:function(index,row)
        {
        }
    	
    });	
    
    //删除对照的方法
	delContrast=function()
	{
		setTimeout(function(){
			var record=$('#contrastgrid').datagrid('getSelected');
			if(record)
			{
				var data=tkMakeServerCall("web.DHCBL.MKB.MKBOrderContrast","DeleteData",record.RowId);
				var data=eval('('+data+')');
				if(data.success=='true'){
					$.messager.popover({msg: '删除成功！',type:'success',timeout: 1000});
					var recordMKB=$('#mkbgrid').datagrid('getSelected');
					$('#contrastgrid').datagrid('options').url=$URL;  
					$('#contrastgrid').datagrid('load',  {
		            	ClassName:"web.DHCBL.MKB.MKBOrderContrast",
		            	QueryName:"GetContrastList",
		            	id:recordMKB.MKBTPDRowId
		    		});
				}
				else{
					var errorMsg="删除失败！";
					if(data.info){
						errorMsg=errorMsg+'</br>错误信息:'+data.info
					}
					$.messager.alert('错误提示',errorMsg,'error',function(){})
			   }
			}		
		},100)
	}	
};
$(init);