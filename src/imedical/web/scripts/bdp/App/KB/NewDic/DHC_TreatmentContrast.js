/// 名称: 治疗项目与HIS对照
/// 描述: 包含通用名表与his通用名表对照功能，与已对照通用名删除功能
/// 编写者: 基础数据平台组-丁亚男
/// 编写日期: 2018-08-01
var DELETE_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.KB.DHCGenItmContrast&pClassMethod=DeleteData";
var init=function()
{
   var columns =[[
   		{field:'PHEGRowId',title:'PHEGRowId',sortable:true,width:100,hidden:true},
        {field:'PHEGCode',title:'代码',sortable:true,width:100},
        {field:'PHEGDesc',title:'描述',sortable:true,width:100},
        {field:'PHEGActiveFlag',title:'启用',sortable:true,width:100,align:'center',formatter:ReturnFlagIcon},
        {field:'PHEGSysFlag',title:'系统标识',sortable:true,width:100,align:'center',formatter:ReturnFlagIcon}
        
    ]];
    var gengrid = $HUI.datagrid("#gengrid",{
        url:$URL,
        queryParams:{
            ClassName:"web.DHCBL.KB.DHCGenItmContrast",
            QueryName:"GetTreatmentList"
        },
        columns: columns,  //列信息
        pagination: true,   //pagination	boolean	设置为 true，则在数据网格（datagrid）底部显示分页工具栏。
        pageSize:20,
        pageList:[5,10,15,20,25,30,50,75,100,200,300,500,1000],
        singleSelect:true,
        remoteSort:false,
        //ClassTableName:'User.DHCPHExtPart',
		//SQLTableName:'DHC_PHExtPart',
        idField:'PHEGRowId',
        rownumbers:true,    //设置为 true，则显示带有行号的列。
        fixRowNumber:true,
        fitColumns:true, //设置为 true，则会自动扩大或缩小列的尺寸以适应网格的宽度并且防止水平滚动
        onLoadSuccess:function(data)
        {
			$(this).prev().find('div.datagrid-body').prop('scrollTop',0);
        },
        onClickRow:function(index,row)
        {
	        $('#contrastgrid').datagrid('reload',  {
            	ClassName:"web.DHCBL.KB.DHCGenItmContrast",
            	QueryName:"GetList",
            	id:row.PHEGRowId
    		});        	
        }		
    });
  //搜索
    $('#gensearch').click(function(e){
    	SearchGen();
    });
    //搜索回车事件
    $('#genDesc').keyup(function(event){
        if(event.keyCode == 13) {
          SearchGen();
        }
    }); 
    
    //搜索
    SearchGen=function(){
    	var gendesc=$('#genDesc').val();
    	$('#gengrid').datagrid('reload',  {
            	ClassName:"web.DHCBL.KB.DHCGenItmContrast",
            	QueryName:"GetTreatmentList",
            	desc:gendesc
    	});
		$('#contrastgrid').datagrid('reload',  {
        	ClassName:"web.DHCBL.KB.DHCGenItmContrast",
        	QueryName:"GetList"
		}); 
		$('#gengrid').datagrid('unselectAll');
		$('#contrastgrid').datagrid('unselectAll');
    };
    //重置
    $('#genRefresh').click(function(e){
    	$('#genDesc').val("");
    	$('#gengrid').datagrid('reload',  {
            	ClassName:"web.DHCBL.KB.DHCGenItmContrast",
            	QueryName:"GetTreatmentList"
    	});
		$('#contrastgrid').datagrid('reload',  {
        	ClassName:"web.DHCBL.KB.DHCGenItmContrast",
        	QueryName:"GetList"
		});
		$('#gengrid').datagrid('unselectAll');
		$('#contrastgrid').datagrid('unselectAll');
    });
	
	//2021-05-24 by：xuwenhu
	//自动匹配
	$('#BatchContrast').click(function(e){
		var result= tkMakeServerCall("web.DHCBL.KB.DHCGenItmContrast","AutoContrastTreatData");
		var result = eval('(' + result + ')');
		$('#gengrid').datagrid('reload',  {
			ClassName:"web.DHCBL.KB.DHCGenItmContrast",
			QueryName:"GetTreatmentList"
		});
		$('#contrastgrid').datagrid('reload',  {
			ClassName:"web.DHCBL.KB.DHCGenItmContrast",
			QueryName:"GetList"
		});
		$.messager.alert('操作提示','匹配完成！已成功匹配'+result.count+'条数据。',"info");
	});

    var hiscolumns =[[
	  {field:'RowId',title:'RowId',width:150,sortable:true,hidden:true},
	  {field:'Code',title:'代码',width:150,sortable:true},
	  {field:'Desc',title:'描述',width:250,sortable:true},
	  {field:'opt',title:'操作',width:50,align:'center',
			formatter:function(){  
				//var btn = '<a class="contrast" href="#"  onclick="conMethod()" style="border:0px;cursor:pointer">对照</a>';  
				var btn =  '<img class="contrast mytooltip" title="对照" onclick="conMethod()" src="../scripts_lib/hisui-0.1.0/dist/css/icons/compare.png" style="border:0px;cursor:pointer">'   
				return btn;  
			}  
      }

    ]];
    var hisgengrid = $HUI.datagrid("#hisgengrid",{
        url:$URL,
        queryParams:{
            ClassName:"web.DHCBL.CT.Arcim",
            QueryName:"GetTreatmentList"
        },
        columns: hiscolumns,  //列信息
        pagination: true,   //pagination	boolean	设置为 true，则在数据网格（datagrid）底部显示分页工具栏。
        pageSize:20,
        pageList:[5,10,15,20,25,30,50,75,100,200,300,500,1000],
        remoteSort:false,
        //ClassTableName:'User.MKBTermGJ',
		//SQLTableName:'MKB_Term',
        idField:'RowId',
        singleSelect:true,
        rownumbers:true,    //设置为 true，则显示带有行号的列。
        fitColumns:true, //设置为 true，则会自动扩大或缩小列的尺寸以适应网格的宽度并且防止水平滚动
        onLoadSuccess:function(data){
			$(this).prev().find('div.datagrid-body').prop('scrollTop',0);
			$('.mytooltip').tooltip({
                trackMouse:true,
                onShow:function(e){
                  $(this).tooltip('tip').css({
                  });
                }
              });
        }	
    });
    //搜索
    $('#hisgensearch').click(function(e){
    	SearchHisGen();
    });
    //搜索回车事件
    $('#textHisDesc').keyup(function(event){
        if(event.keyCode == 13) {
          SearchHisGen();
        }
    });
    SearchHisGen=function()
    {
    	var textHisDesc=$('#textHisDesc').val();
    	$('#hisgengrid').datagrid('reload',  {
            	 ClassName:"web.DHCBL.CT.Arcim",
           		 QueryName:"GetTreatmentList",
            	desc:textHisDesc
    	});
    	$('#hisgengrid').datagrid('unselectAll');
    };
    //重置
    $('#hisgenRefresh').click(function(e){
    	$('#textHisDesc').val("");
    	$('#hisgengrid').datagrid('reload',  {
            	 ClassName:"web.DHCBL.CT.Arcim",
           		 QueryName:"GetTreatmentList"
    	});
    	$('#hisgengrid').datagrid('unselectAll');
    });
    //对照，1对1
    conMethod=function()
    {
 		setTimeout(function(){
			var record=$('#gengrid').datagrid('getSelected');
			var hisRecord=$('#hisgengrid').datagrid('getSelected');
			if(!record)
			{
				$.messager.alert('错误提示','请选择需要对照的项目！',"error");
            	return;
			}
			var ids=record.PHEGRowId+'^'+hisRecord.RowId;
			var data=tkMakeServerCall("web.DHCBL.KB.DHCGenItmContrast","SavePartData",ids);
			var data=eval('('+data+')');
			if (data.success == 'true') {
				/*$.messager.show({ 
				  title: '提示消息', 
				  msg: '对照成功', 
				  showType: 'show', 
				  timeout: 1000, 
				  style: { 
					right: '', 
					bottom: ''
				  } 
				}); */
                $.messager.popover({msg: '对照成功！',type:'success',timeout: 1000});
				$('#contrastgrid').datagrid('load',  {
	            	ClassName:"web.DHCBL.KB.DHCGenItmContrast",
	            	QueryName:"GetList",
	            	id:record.PHEGRowId
	    		});
			}
			else
			{
				var errorMsg ="对照失败！"
				if (data.info) {
					errorMsg =errorMsg+ '<br/>错误信息:' + data.info
				}
				 $.messager.alert('操作提示',errorMsg,"error");				
			}
		},100);	   	
    }


    //对照表
    var columns =[[
        {field:'GICTRowId',title:'GICTRowId',width:100,hidden:true,sortable:true},
        {field:'GICTCode',title:'代码',width:100,sortable:true},
        {field:'GICTDesc',title:'描述',width:100,sortable:true},
        {field:'GICTHisCode',title:'his代码',width:100,sortable:true},
        {field:'GICTHisDesc',title:'his描述',width:100,sortable:true},
        {field:'opt',title:'操作',width:50,align:'center',
			formatter:function(){ 
                var btn =  '<img class="contrast" onclick="delContrast()" src="../scripts_lib/hisui-0.1.0/dist/css/icons/cancel.png" style="border:0px;cursor:pointer">' 
				//var btn = '<a class="contrast" href="#"  onclick="delContrast()" style="border:0px;cursor:pointer">删除</a>';  
				return btn;  
			}  
        }

    ]];
    var congrid = $HUI.datagrid("#contrastgrid",{
        url:$URL,
        queryParams:{
            ClassName:"web.DHCBL.KB.DHCGenItmContrast",
            QueryName:"GetList"
        },
        columns: columns,  //列信息
        pagination: true,   //pagination	boolean	设置为 true，则在数据网格（datagrid）底部显示分页工具栏。
        pageSize:20,
        pageList:[5,10,15,20,25,30,50,75,100,200,300,500,1000],
        remoteSort:false,
        singleSelect:true,
        idField:'GICTRowId',
        rownumbers:true,    //设置为 true，则显示带有行号的列。
        fixRowNumber:true,
        toolbar:[],//表头和数据之间的缝隙
        fitColumns:true //设置为 true，则会自动扩大或缩小列的尺寸以适应网格的宽度并且防止水平滚动  	
    });
	delContrast=function()
	{
		setTimeout(function(){
			var record=$('#contrastgrid').datagrid('getSelected');
			if(record)
			{
        		var genrecord=$('#gengrid').datagrid('getSelected');
      			var rowid=record.GICTRowId;
	        	$.messager.confirm('提示', '确定要删除所选的数据吗?', function(r){
				if (r){
					$.ajax({
						url:DELETE_ACTION_URL,  
						data:{"id":rowid},  
						type:"POST",   
						//dataType:"TEXT",  
						success: function(data){
								  var data=eval('('+data+')'); 
								  if (data.success == 'true') {
									/*$.messager.show({ 
									  title: '提示消息', 
									  msg: '删除成功', 
									  showType: 'show', 
									  timeout: 1000, 
									  style: { 
										right: '', 
										bottom: ''
									  } 
									}); */
                                    $.messager.popover({msg: '删除成功！',type:'success',timeout: 1000});
									 //$('#mygrid').datagrid('reload');  // 重新载入当前页面数据 
									 //$('#mygrid').datagrid('unselectAll');  // 清空列表选中数据
									$('#contrastgrid').datagrid('load',  {
						            	ClassName:"web.DHCBL.KB.DHCGenItmContrast",
						            	QueryName:"GetList",
						            	id:genrecord.PHEGRowId
					        		}); 
								  } 
								  else { 
									var errorMsg ="删除失败！"
									if (data.info) {
										errorMsg =errorMsg+ '<br/>错误信息:' + data.info
									}
									 $.messager.alert('操作提示',errorMsg,"error");
						
								}			
							}  
						})
					}
				});	
			}		
		},100)
	}	        
}
$(init);