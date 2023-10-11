/*
* @Author: 基础数据平台-石萧伟
* @Date:   2018-08-07 15:41:35
* @Last Modified by:   admin
* @Last Modified time: 2018-11-05 10:41:54
* @描述:菌属对照
*/
var SAVE_ACTION_URL = "../csp/dhc.bdp.ext.entitydatatrans.csp?pClassName=web.DHCBL.KB.DHCPHGenusContrast&pClassMethod=SaveData&pEntityName=web.Entity.KB.DHCPHGenusContrast";
var DELETE_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.KB.DHCPHGenusContrast&pClassMethod=DeleteData";
var init=function()
{
   var columns =[[
        {field:'BTGECode',title:'代码',sortable:true,width:100},
        {field:'BTGEDesc',title:'描述',sortable:true,width:100},
        {field:'BTGEActiveFlag',title:'是否可用',sortable:true,width:100,
              formatter:ReturnFlagIcon
    	},
        {field:'BTGERowId',title:'rowid',sortable:true,width:100,hidden:true}
    ]];
    var gengrid = $HUI.datagrid("#gengrid",{
        url:$URL,
        queryParams:{
            ClassName:"web.DHCBL.KB.DHCPHBtGenus",
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
        idField:'BTGERowId',
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
            	ClassName:"web.DHCBL.KB.DHCPHGenusContrast",
            	QueryName:"GetList",
            	id:row.BTGERowId
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
    //搜索方法
    SearchGen=function()
    {
        var gendesc=$('#genDesc').val();
        $('#gengrid').datagrid('reload',  {
                ClassName:"web.DHCBL.KB.DHCPHBtGenus",
                QueryName:"GetList",
                desc:gendesc
        });
        $('#contrastgrid').datagrid('reload',  {
            ClassName:"web.DHCBL.KB.DHCPHGenusContrast",
            QueryName:"GetList"
        }); 
        $('#gengrid').datagrid('unselectAll');
        $('#contrastgrid').datagrid('unselectAll');        
    }    
    //重置
    $('#genRefresh').click(function(e){
    	$('#genDesc').val("");
    	$('#gengrid').datagrid('reload',  {
            	ClassName:"web.DHCBL.KB.DHCPHBtGenus",
            	QueryName:"GetList"
    	});
		$('#contrastgrid').datagrid('reload',  {
        	ClassName:"web.DHCBL.KB.DHCPHGenusContrast",
        	QueryName:"GetList"
		});
		$('#gengrid').datagrid('unselectAll');
		$('#contrastgrid').datagrid('unselectAll');
    });
    //自动匹配
    $('#BatchContrast').click(function(e){
        var result= tkMakeServerCall("web.DHCBL.KB.DHCPHGenusContrast","AutoContrastData");
        var result = eval('(' + result + ')');
        $('#gengrid').datagrid('reload',  {
                ClassName:"web.DHCBL.KB.DHCPHBtGenus",
                QueryName:"GetList"
        });
        $('#contrastgrid').datagrid('reload',  {
            ClassName:"web.DHCBL.KB.DHCPHGenusContrast",
            QueryName:"GetList"
        });
        $('#gengrid').datagrid('unselectAll');
        $('#contrastgrid').datagrid('unselectAll');
        $.messager.alert('操作提示','匹配完成！已成功匹配'+result.count+'条数据。',"info");
    });

    var hiscolumns =[[
	    {field:'RowID',title:'RowId',width:100,sortable:true,hidden:true},
	    {field:'Code',title:'代码',width:100,sortable:true},
	    {field:'CName',title:'描述',width:100,sortable:true},
      /*{field:'SYFActiveFlag',title:'是否可用',sortable:true,width:50,
          formatter: function(value,row,index){
                if(value=='N')  
                 {
                    return "<img  src='../scripts/bdp/Framework/icons/no.png' style='border: 0px'><span>"
                 }
                 else if(value=='Y') 
                 {
                     return "<img src='../scripts/bdp/Framework/icons/yes.png' style='border: 0px'><span>";
                 }
            }
      }, */     
	    {field:'opt',title:'操作',width:100,align:'center',
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
            ClassName:"web.DHCBL.KB.DHCPHGenusContrast",
            QueryName:"GetHisList"
        },
        columns: hiscolumns,  //列信息
        pagination: true,   //pagination	boolean	设置为 true，则在数据网格（datagrid）底部显示分页工具栏。
        pageSize:PageSizeMain,
        pageList:[5,10,15,20,25,30,50,75,100,200,300,500,1000],
        remoteSort:false,
        //ClassTableName:'User.MKBTermGJ',
		//SQLTableName:'MKB_Term',
        idField:'RowID',
        singleSelect:true,
        rownumbers:true,    //设置为 true，则显示带有行号的列。
        fixRowNumber:true,
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
    $('#hisgenDesc').keyup(function(event){
        if(event.keyCode == 13) {
          SearchHisGen();
        }
    });    
    //搜索方法
    SearchHisGen=function()
    {
        var hisgenDesc=$('#hisgenDesc').val();
        $('#hisgengrid').datagrid('reload',  {
                ClassName:"web.DHCBL.KB.DHCPHGenusContrast",
                QueryName:"GetHisList",
                desc:hisgenDesc
        });
        $('#hisgengrid').datagrid('unselectAll');       
    }    
    //重置
    $('#hisgenRefresh').click(function(e){
    	$('#hisgenDesc').val("");
    	$('#hisgengrid').datagrid('reload',  {
            	ClassName:"web.DHCBL.KB.DHCPHGenusContrast",
            	QueryName:"GetHisList"
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
				$.messager.alert('错误提示','请选择需要对照的菌属！',"error");
            	return;
			}
			var ids=record.BTGERowId+'^'+hisRecord.RowID;
			var data=tkMakeServerCall("web.DHCBL.KB.DHCPHGenusContrast","SaveData",ids);
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
	            	ClassName:"web.DHCBL.KB.DHCPHGenusContrast",
	            	QueryName:"GetList",
	            	id:record.BTGERowId
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
        {field:'PHGRowId',title:'rowid',width:100,hidden:true,sortable:true},
        {field:'PHGGenusCode',title:'代码',width:100,sortable:true},
        {field:'PHGGenusDesc',title:'描述',width:100,sortable:true},
        {field:'PHGHisGenusCode',title:'his代码',width:100,sortable:true},
        {field:'PHGHisGenusDesc',title:'his描述',width:100,sortable:true},
        {field:'opt',title:'操作',width:100,align:'center',
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
            ClassName:"web.DHCBL.KB.DHCPHGenusContrast",
            QueryName:"GetList"
        },
        columns: columns,  //列信息
        pagination: true,   //pagination	boolean	设置为 true，则在数据网格（datagrid）底部显示分页工具栏。
        pageSize:PageSizeMain,
        pageList:[5,10,15,20,25,30,50,75,100,200,300,500,1000],
        remoteSort:false,
        singleSelect:true,
        toolbar:[],//表头和数据之间的缝隙
        //ClassTableName:'User.DHCPHPartContrast',
		//SQLTableName:'DHC_PHPartContrast',
        idField:'PHGRowId',
        rownumbers:true,    //设置为 true，则显示带有行号的列。
        fixRowNumber:true,
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
        		var genrecord=$('#gengrid').datagrid('getSelected');
      			var rowid=record.PHGRowId;
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
						            	ClassName:"web.DHCBL.KB.DHCPHGenusContrast",
						            	QueryName:"GetList",
						            	id:genrecord.BTGERowId
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