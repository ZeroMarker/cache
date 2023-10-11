/*
Creator:石萧伟
CreatDate:2017-06-19
Description:医用知识库科室对照
*/
//界面初始化
var init = function(){
	//医用知识库科室
	var base=tkMakeServerCall("web.DHCBL.MKB.MKBLocContrast","getTermId","LOC");
	var DepId=session['LOGON.CTLOCID'];
	var mkbcolumns =[[
		  {field:'MKBTRowId',title:'MKBTRowId',width:150,sortable:true,hidden:true},
		  {field:'MKBTDesc',title:'科室名称',width:300,sortable:true},
		  {field:'MKBTCode',title:'科室代码',width:300,sortable:true},
	       {field:'MKBTPYCode',title:'拼音码',width:100,hidden:true,sortable:true}
    ]];
    var mkbgrid = $HUI.treegrid("#mkbgrid",{
		url:"../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.MKB.MKBAssInterface&pClassMethod=GetTreeJson&base="+base,
        columns: mkbcolumns,  //列信息
        singleSelect:true,
        remoteSort:false,
        ClassTableName:'User.MKBTerm'+base,
		SQLTableName:'MKB_Term',
        idField:'MKBTRowId',
        treeField:'MKBTDesc',  //树形列表必须定义 'treeField' 属性，指明哪个字段作为树节点。		
        fitColumns:true, //设置为 true，则会自动扩大或缩小列的尺寸以适应网格的宽度并且防止水平滚动
        //scrollbarSize :0,
        onClickRow:function(index,row)
        {
	       	$('#contrastgrid').datagrid('load',  {
	            ClassName:"web.DHCBL.MKB.MKBLocContrast",
	            QueryName:"GetContrastList",
	            id:row.MKBTRowId
        	});
	        RefreshSearchData("User.MKBTerm"+base,row.MKBTRowId,"A",row.MKBTDesc);
        },
        onLoadSuccess:function(data){
			$(this).prev().find('div.datagrid-body').prop('scrollTop',0);
        }
   	
    });
    //查询重置MKB
     $('#mkbDesc').searchcombobox({ 
		url:$URL+"?ClassName=web.DHCBL.BDP.BDPDataHistory&QueryName=GetDataForCmb1&ResultSetType=array&tablename=User.MKBTerm"+base,
		onSelect:function () 
		{	
			$(this).combobox('textbox').focus();
        	var desc=$("#mkbDesc").combobox('getText');
        	$("#mkbgrid").treegrid("search", desc)
			
		}
	});
	$('#mkbDesc').combobox('textbox').bind('keyup',function(e){ 
		if(e.keyCode==13){ 
        	var desc=$("#mkbDesc").combobox('getText');
        	$("#mkbgrid").treegrid("search", desc)
		}
	}); 

	$("#mkbSearch").click(function (e) { 
        var desc=$("#mkbDesc").combobox('getText');
        $("#mkbgrid").treegrid("search", desc)
	}) ;
	$("#mkbRefresh").click(function (e) { 
		$("#mkbDesc").combobox('setValue', '');//清空检索框
		$('#mkbgrid').treegrid('load',  { 
		'LastLevel':''	
		});
		$('#mkbgrid').treegrid('unselectAll');
		$('#contrastgrid').datagrid('load',  {
        	ClassName:"web.DHCBL.MKB.MKBLocContrast",
        	QueryName:"GetContrastList"       
		});
		
	});
	//础数据平台科室表
	var hiscolumns =[[
        {field:'CTLOCRowID',title:'rowid',width:100,hidden:true,sortable:true},
		{field:'CTLOCDesc',title:'科室名称',width:100,sortable:true},
		{field:'MKBLocDescs',title:'对照科室',width:100,sortable:true,
			formatter: function(value, row, index) {
				var content = '<span href="#" title="' + value + '" class="hisui-tooltip">' + value + '</span>';
				return content;
			}  
		},
        {field:'CTLOCCode',title:'科室代码',width:100,sortable:true},
        {field:'opt',title:'操作',width:50,align:'center',
			formatter:function(){  
				var btn = '<a class="contrast" href="#"  onclick="conMethod()" style="border:0px;cursor:pointer">对照</a>';  
				return btn;  
			}  
        },
        
    ]];
    var ctgrid = $HUI.datagrid("#ctgrid",{
        url:$URL,
        queryParams:{
            ClassName:"web.DHCBL.MKB.MKBLocContrast",
            QueryName:"GetList"
        },
        columns: hiscolumns,  //列信息
        pagination: true,   //pagination	boolean	设置为 true，则在数据网格（datagrid）底部显示分页工具栏。
        pageSize:PageSizeMain,
        pageList:[5,10,15,20,25,30,50,75,100,200,300,500,1000],
        remoteSort:false,
        ClassTableName:'User.CTLoc',
		SQLTableName:'CT_Loc',
        idField:'CTLOCRowID',
        singleSelect:true,
        rownumbers:true,    //设置为 true，则显示带有行号的列。
        fitColumns:true, //设置为 true，则会自动扩大或缩小列的尺寸以适应网格的宽度并且防止水平滚动
        onClickRow:function(index,row)
        {
	        RefreshSearchData("User.CTLoc",row.CTLOCRowID,"A",row.CTLOCDesc);
        },
        onLoadSuccess:function(data){
			$(this).prev().find('div.datagrid-body').prop('scrollTop',0);
        }	
    });
    //查询和重置
    $('#hisDesc').searchcombobox({ 
		url:$URL+"?ClassName=web.DHCBL.BDP.BDPDataHistory&QueryName=GetDataForCmb1&ResultSetType=array&tablename=User.CTLoc",
		onSelect:function () 
		{	
			$(this).combobox('textbox').focus();
			SearchFunLib()
			
		}
	});
	$('#hisDesc').combobox('textbox').bind('keyup',function(e){ 
		if(e.keyCode==13){ 
			SearchFunLib(); 
		}
	}); 

	$("#hisSearch").click(function (e) { 
			SearchFunLib();
	})    
    //查询方法
    function SearchFunLib(){
        var desc=$("#hisDesc").combobox('getText');
        $('#ctgrid').datagrid('load',  {
            ClassName:"web.DHCBL.MKB.MKBLocContrast",
            QueryName:"GetList",
            desc:desc	
        });
        $('#ctgrid').datagrid('unselectAll');
    }
    $("#hisRefresh").click(function (e) {
        $("#hisDesc").combobox('setValue', '');
        $('#ctgrid').datagrid('load',  {
            ClassName:"web.DHCBL.MKB.MKBLocContrast",
            QueryName:"GetList"
        });
        $('#ctgrid').datagrid('unselectAll');
    });

	//对照方法
	conMethod=function()
	{
		setTimeout(function(){
			var record=$('#mkbgrid').treegrid('getSelected');
			var hisRecord=$('#ctgrid').datagrid('getSelected');
			if(!record)
			{
				$.messager.alert('错误提示','请选择需要对照的科室！',"error");
            	return;
			}
			var ids=record.MKBTRowId+'^'+hisRecord.CTLOCRowID;
			var Flag=tkMakeServerCall("web.DHCBL.MKB.MKBLocContrast","JustData",ids);
			if(Flag=="Y")
			{
				$.messager.alert('错误提示','该记录已对照, 不能重复对照!',"error");
            	return;				
			}
			tkMakeServerCall("web.DHCBL.MKB.MKBLocContrast","SaveData",ids);
			$('#contrastgrid').datagrid('load',  {
            	ClassName:"web.DHCBL.MKB.MKBLocContrast",
            	QueryName:"GetContrastList",
            	id:record.MKBTRowId
    		});
		},100);	
	}
	//对照表
	var columns =[[
        {field:'MKBLCRowId',title:'rowid',width:100,hidden:true,sortable:true},
        {field:'MKBTDesc',title:'科室名称',width:100,sortable:true},
        {field:'MKBTCode',title:'科室代码',width:100,sortable:true},
        {field:'MKBHisLocDesc',title:'his科室名称',width:100,sortable:true},
        {field:'MKBHisLocCode',title:'his科室代码',width:100,sortable:true},
        {field:'opt',title:'操作',width:50,align:'center',
			formatter:function(){  
				var btn = '<a class="contrast" href="#"  onclick="delContrast()" style="border:0px;cursor:pointer">删除</a>';  
				return btn;  
			}  
        }

    ]];
    var congrid = $HUI.datagrid("#contrastgrid",{
        url:$URL,
        queryParams:{
            ClassName:"web.DHCBL.MKB.MKBLocContrast",
            QueryName:"GetContrastList"
        },
        columns: columns,  //列信息
        pagination: true,   //pagination	boolean	设置为 true，则在数据网格（datagrid）底部显示分页工具栏。
        pageSize:PageSizeMain,
        pageList:[5,10,15,20,25,30,50,75,100,200,300,500,1000],
        remoteSort:false,
        singleSelect:true,
        ClassTableName:'User.MKBLocContrast',
		SQLTableName:'MKB_LocContrast',
        idField:'MKBLCRowId',
        rownumbers:true,    //设置为 true，则显示带有行号的列。
        fitColumns:true, //设置为 true，则会自动扩大或缩小列的尺寸以适应网格的宽度并且防止水平滚动
        onClickRow:function(index,row)
        {
	        RefreshSearchData("User.MKBLocContrast",row.MKBLCRowId,"A",row.MKBTDesc);
        }
    	
    });	
	delContrast=function()
	{
		setTimeout(function(){
			var record=$('#contrastgrid').datagrid('getSelected');
			if(record)
			{
				tkMakeServerCall("web.DHCBL.MKB.MKBLocContrast","DeleteData",record.MKBLCRowId);
				var recordMKB=$('#mkbgrid').treegrid('getSelected');
				$('#contrastgrid').datagrid('load',  {
	            	ClassName:"web.DHCBL.MKB.MKBLocContrast",
	            	QueryName:"GetContrastList",
	            	id:recordMKB.MKBTRowId
        		});
			}		
		},100)
	}	
	$HUI.tooltip("#contrast_btn",{
		position:'bottom',
		content:"根据标识为科室对照的规则管理数据自动对照"	
	});
	$('#contrast_btn').click(function(){
		var result = tkMakeServerCall("web.DHCBL.MKB.MKBDataProcessing","LocConMigrate");
		var data=eval('('+result+')');
		if(data.success === "true"){
			$.messager.popover({msg: '自动对照成功！',type:'success',timeout: 1000});
		}else{
			var errorMsg="对照失败！";
			if(data.info){
				errorMsg=errorMsg+'</br>错误信息:'+data.info
			}
			$.messager.alert('错误提示',errorMsg,'error')
		}
	});
};
$(init);