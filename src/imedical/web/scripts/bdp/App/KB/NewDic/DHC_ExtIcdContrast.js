/*
* @Author: 基础数据平台-石萧伟
* @Date:   2018-07-31 15:41:35
* @Last Modified by:   admin
* @Last Modified time: 2018-10-29 09:11:16
* @描述:诊断与his诊断对照
*/
var SAVE_ACTION_URL = "../csp/dhc.bdp.ext.entitydatatrans.csp?pClassName=web.DHCBL.KB.DHCExtIcdContrast&pClassMethod=SaveData&pEntityName=web.Entity.KB.DHCExtIcdContrast";
var DELETE_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.KB.DHCExtIcdContrast&pClassMethod=DeleteData";
var init=function()
{
   var columns =[[
        {field:'ICDCode',title:'代码',sortable:true,width:100},
        {field:'ICDDesc',title:'描述',sortable:true,width:100},
        {field:'ICDType',title:'类型',sortable:true,width:100,
        	formatter:function(value,row,index){
        		if(value=="9")
        		{
        			return "ICD9";
        		}
        		else if(value=="10")
        		{
        			return "ICD10";
        		}
        		else if(value=="99")
        		{
        			return "非ICD";
        		}
        	}
    	},
        {field:'ICDAcitveFlag',title:'是否可用',sortable:true,width:100,formatter: ReturnFlagIcon},
        {field:'ICDSysFlag',title:'系统标识',sortable:true,width:100,formatter: ReturnFlagIcon},
        {field:'ICDRowId',title:'rowid',sortable:true,width:100,hidden:true}
    ]];
    var partgrid = $HUI.datagrid("#partgrid",{
        url:$URL,
        queryParams:{
            ClassName:"web.DHCBL.KB.DHCExtIcdFeild",
            QueryName:"GetList"
        },
        columns: columns,  //列信息
        pagination: true,   //pagination	boolean	设置为 true，则在数据网格（datagrid）底部显示分页工具栏。
        pageSize:PageSizeMain,
        pageList:[5,10,15,20,25,30,50,75,100,200,300,500,1000],
        singleSelect:true,
        remoteSort:false,
        //ClassTableName:'User.DHCPHExtPart',
		//SQLTableName:'DHC_PHExtPart',
        idField:'ICDRowId',
        rownumbers:true,    //设置为 true，则显示带有行号的列。
        fitColumns:true, //设置为 true，则会自动扩大或缩小列的尺寸以适应网格的宽度并且防止水平滚动
        onLoadSuccess:function(data)
        {
			$(this).prev().find('div.datagrid-body').prop('scrollTop',0);
        },
        onClickRow:function(index,row)
        {
	        $('#contrastgrid').datagrid('reload',  {
            	ClassName:"web.DHCBL.KB.DHCExtIcdContrast",
            	QueryName:"GetList",
            	id:row.ICDRowId
    		});        	
        }		
    });

    //搜索
    $('#partsearch').click(function(e){
        SearchPart();
    });
    //搜索回车事件
    $('#partDesc').keyup(function(event){
        if(event.keyCode == 13) {
          SearchPart();
        }
    });    
    //搜索方法
    SearchPart=function()
    {
        var partdesc=$('#partDesc').val();
        $('#partgrid').datagrid('reload',  {
                ClassName:"web.DHCBL.KB.DHCExtIcdFeild",
                QueryName:"GetList",
                desc:partdesc
        });
        $('#contrastgrid').datagrid('reload',  {
            ClassName:"web.DHCBL.KB.DHCExtIcdContrast",
            QueryName:"GetList"
        }); 
        $('#partgrid').datagrid('unselectAll');
        $('#contrastgrid').datagrid('unselectAll');        
    }    
    //重置
    $('#partRefresh').click(function(e){
    	$('#partDesc').val("");
    	$('#partgrid').datagrid('reload',  {
            	ClassName:"web.DHCBL.KB.DHCExtIcdFeild",
            	QueryName:"GetList"
    	});
		$('#contrastgrid').datagrid('reload',  {
        	ClassName:"web.DHCBL.KB.DHCExtIcdContrast",
        	QueryName:"GetList"
		});
		$('#partgrid').datagrid('unselectAll');
		$('#contrastgrid').datagrid('unselectAll');
    });
    //自动匹配
    $('#BatchContrast').click(function(e){
        var result= tkMakeServerCall("web.DHCBL.KB.DHCExtIcdContrast","AutoContrastData");
        var result = eval('(' + result + ')');
        $('#partgrid').datagrid('reload',  {
            ClassName:"web.DHCBL.KB.DHCExtIcdFeild",
            QueryName:"GetList"
        });
        $('#contrastgrid').datagrid('reload',  {
            ClassName:"web.DHCBL.KB.DHCExtIcdContrast",
            QueryName:"GetList"
        });
        $('#partgrid').datagrid('unselectAll');
        $('#contrastgrid').datagrid('unselectAll');
        $.messager.alert('操作提示','匹配完成！已成功匹配'+result.count+'条数据。',"info");
  });

    var hiscolumns =[[
	  {field:'MRCIDRowId',title:'RowId',width:150,sortable:true,hidden:true},
	  {field:'MRCIDICD9CMCode',title:'代码',width:150,sortable:true},
	  {field:'MRCIDDesc',title:'描述',width:150,sortable:true},
	  {field:'opt',title:'操作',width:50,align:'center',
			formatter:function(){  
                //var btn = '<a class="contrast" href="#"  onclick="conMethod()" style="border:0px;cursor:pointer">对照</a>';  
                var btn =  '<img class="contrast mytooltip" title="对照" onclick="conMethod()" src="../scripts_lib/hisui-0.1.0/dist/css/icons/compare.png" style="border:0px;cursor:pointer">'   
				return btn;  
			}  
      }

    ]];
    var hispartgrid = $HUI.datagrid("#hispartgrid",{
        url:$URL,
        queryParams:{
            ClassName:"web.DHCBL.CT.MRCICDDx",
            QueryName:"GetDataForCmb1"
        },
        columns: hiscolumns,  //列信息
        pagination: true,   //pagination	boolean	设置为 true，则在数据网格（datagrid）底部显示分页工具栏。
        pageSize:PageSizeMain,
        pageList:[5,10,15,20,25,30,50,75,100,200,300,500,1000],
        remoteSort:false,
        //ClassTableName:'User.MKBTermGJ',
		//SQLTableName:'MKB_Term',
        idField:'MRCIDRowId',
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
    $('#hispartsearch').click(function(e){
        SearchHisPart();
    });
    //搜索回车事件
    $('#hispartDesc').keyup(function(event){
        if(event.keyCode == 13) {
          SearchHisPart();
        }
    });    
    //搜索方法
    SearchHisPart=function()
    {
        var hispartDesc=$('#hispartDesc').val();
        $('#hispartgrid').datagrid('reload',  {
                ClassName:"web.DHCBL.CT.MRCICDDx",
                QueryName:"GetDataForCmb1",
                desc:hispartDesc
        });
        $('#hispartgrid').datagrid('unselectAll');        
    }    
    //重置
    $('#hispartRefresh').click(function(e){
    	$('#hispartDesc').val("");
    	$('#hispartgrid').datagrid('reload',  {
            	ClassName:"web.DHCBL.CT.MRCICDDx",
            	QueryName:"GetDataForCmb1"
    	});
    	$('#hispartgrid').datagrid('unselectAll');
    });
    //对照，1对1
    conMethod=function()
    {
 		setTimeout(function(){
			var record=$('#partgrid').datagrid('getSelected');
			var hisRecord=$('#hispartgrid').datagrid('getSelected');
			if(!record)
			{
				$.messager.alert('错误提示','请选择需要对照的诊断！',"error");
            	return;
			}
			var ids=record.ICDRowId+'^'+hisRecord.MRCIDRowId;
			var data=tkMakeServerCall("web.DHCBL.KB.DHCExtIcdContrast","SaveData",ids);
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
	            	ClassName:"web.DHCBL.KB.DHCExtIcdContrast",
	            	QueryName:"GetList",
	            	id:record.ICDRowId
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
        {field:'ICONRowId',title:'rowid',width:100,hidden:true,sortable:true},
        {field:'ICONCode',title:'代码',width:100,sortable:true},
        {field:'ICONDesc',title:'描述',width:100,sortable:true},
        {field:'ICONHisCode',title:'his代码',width:100,sortable:true},
        {field:'ICONHisDesc',title:'his描述',width:100,sortable:true},
        {field:'opt',title:'操作',width:50,align:'center',
			formatter:function(){  
				//var btn = '<a class="contrast" href="#"  onclick="delContrast()" style="border:0px;cursor:pointer">删除</a>'; 
                var btn =  '<img class="contrast" onclick="delContrast()" src="../scripts_lib/hisui-0.1.0/dist/css/icons/cancel.png" style="border:0px;cursor:pointer">' 
				return btn;  
			}  
        }

    ]];
    var congrid = $HUI.datagrid("#contrastgrid",{
        url:$URL,
        queryParams:{
            ClassName:"web.DHCBL.KB.DHCExtIcdContrast",
            QueryName:"GetList"
        },
        columns: columns,  //列信息
        pagination: true,   //pagination	boolean	设置为 true，则在数据网格（datagrid）底部显示分页工具栏。
        pageSize:PageSizeMain,
        pageList:[5,10,15,20,25,30,50,75,100,200,300,500,1000],
        remoteSort:false,
        singleSelect:true,
        //ClassTableName:'User.DHCPHPartContrast',
		//SQLTableName:'DHC_PHPartContrast',
        idField:'ICONRowId',
        rownumbers:true,    //设置为 true，则显示带有行号的列。
        fixRowNumber:true,
        toolbar:[],//表头和数据之间的缝隙
        fitColumns:true, //设置为 true，则会自动扩大或缩小列的尺寸以适应网格的宽度并且防止水平滚动
        onClickRow:function(index,row)
        {
	        //RefreshSearchData("User.MKBSZTermContrast",row.MKBSZRowId,"A",row.MKBTDesc);
        }    	
    });
	delContrast=function()
	{
		setTimeout(function(){
			var record=$('#contrastgrid').datagrid('getSelected');
			if(record)
			{
        		var partrecord=$('#partgrid').datagrid('getSelected');
      			var rowid=record.ICONRowId;
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
									});*/
                                    $.messager.popover({msg: '删除成功！',type:'success',timeout: 1000}); 
									 //$('#mygrid').datagrid('reload');  // 重新载入当前页面数据 
									 //$('#mygrid').datagrid('unselectAll');  // 清空列表选中数据
									$('#contrastgrid').datagrid('load',  {
						            	ClassName:"web.DHCBL.KB.DHCExtIcdContrast",
						            	QueryName:"GetList",
						            	id:partrecord.ICDRowId
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