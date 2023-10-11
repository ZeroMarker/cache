/*
* @Author: 基础数据平台-石萧伟
* @Date:   2018-08-07 15:41:35
* @Last Modified by:   admin
* @Last Modified time: 2018-10-24 09:36:27
* @描述:科室字典对照
*/
var SAVE_ACTION_URL = "../csp/dhc.bdp.ext.entitydatatrans.csp?pClassName=web.DHCBL.KB.DHCPHHospLocCon&pClassMethod=SaveData&pEntityName=web.Entity.KB.DHCPHHospLocCon";
var DELETE_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.KB.DHCPHHospLocCon&pClassMethod=DeleteData";
var init=function()
{
   var columns =[[
        {field:'HOSPLCode',title:'代码',sortable:true,width:100},
        {field:'HOSPLDesc',title:'描述',sortable:true,width:100},
        {field:'HOSPLActiveFlag',title:'是否可用',sortable:true,width:100,
              formatter:ReturnFlagIcon
    	},
        {field:'HOSPLRowId',title:'rowid',sortable:true,width:100,hidden:true}
    ]];
    var locgrid = $HUI.datagrid("#locgrid",{
        url:$URL,
        queryParams:{
            ClassName:"web.DHCBL.KB.DHCPHHospLoc",
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
        idField:'HOSPLRowId',
        rownumbers:true,    //设置为 true，则显示带有行号的列。
        fitColumns:true, //设置为 true，则会自动扩大或缩小列的尺寸以适应网格的宽度并且防止水平滚动
        onLoadSuccess:function(data)
        {
			$(this).prev().find('div.datagrid-body').prop('scrollTop',0);
        },
        onClickRow:function(index,row)
        {
	        $('#contrastgrid').datagrid('reload',  {
            	ClassName:"web.DHCBL.KB.DHCPHHospLocCon",
            	QueryName:"GetList",
            	id:row.HOSPLRowId
    		});        	
        }		
    });

    //搜索
    $('#locsearch').click(function(e){
      SearchLoc()
    });
    //搜索回车事件
    $('#locDesc').keyup(function(event){
      if(event.keyCode == 13) {
       SearchLoc();
     }
    });    
    //搜索方法
    SearchLoc=function()
    {
      var locdesc=$('#locDesc').val();
      $('#locgrid').datagrid('reload',  {
              ClassName:"web.DHCBL.KB.DHCPHHospLoc",
              QueryName:"GetList",
              desc:locdesc
      });
      $('#contrastgrid').datagrid('reload',  {
          ClassName:"web.DHCBL.KB.DHCPHHospLocCon",
          QueryName:"GetList"
      }); 
      $('#locgrid').datagrid('unselectAll');
      $('#contrastgrid').datagrid('unselectAll');
    }    
    //重置
    $('#locRefresh').click(function(e){
    	$('#locDesc').val("");
    	$('#locgrid').datagrid('reload',  {
            	ClassName:"web.DHCBL.KB.DHCPHHospLoc",
            	QueryName:"GetList"
    	});
		$('#contrastgrid').datagrid('reload',  {
        	ClassName:"web.DHCBL.KB.DHCPHHospLocCon",
        	QueryName:"GetList"
		});
		$('#locgrid').datagrid('unselectAll');
		$('#contrastgrid').datagrid('unselectAll');
    });

    //自动匹配
  $('#BatchContrast').click(function(e){
        var result= tkMakeServerCall("web.DHCBL.KB.DHCPHHospLocCon","AutoContrastData");
        var result = eval('(' + result + ')');
        $('#locgrid').datagrid('reload',  {
          ClassName:"web.DHCBL.KB.DHCPHHospLoc",
          QueryName:"GetList"
        });
        $('#contrastgrid').datagrid('reload',  {
            ClassName:"web.DHCBL.KB.DHCPHHospLocCon",
            QueryName:"GetList"
        });
        $('#locgrid').datagrid('unselectAll');
		    $('#contrastgrid').datagrid('unselectAll');
        $.messager.alert('操作提示','匹配完成！已成功匹配'+result.count+'条数据。',"info");
  });


    var hiscolumns =[[
	    {field:'CTLOCRowID',title:'RowId',width:150,sortable:true,hidden:true},
	    {field:'CTLOCCode',title:'代码',width:100,sortable:true},
	    {field:'CTLOCDesc',title:'描述',width:100,sortable:true},
	    {field:'CTLOCType',title:'科室类型',width:100,sortable:true,
            formatter:function(value,row,index)
            {
               if(value=="W")
               {
                    return "Ward"
               }
               else if(value=="E")
               {
                    return "Execute"
               }
               else if(value=="DI")
               {
                    return "Drug Injection"
               }
               else if(value=="D")
               {
                    return "Dispensing"
               }
               else if(value=="C")
               {
                    return "Cashier"
               } 
               else if(value=="O")
               {
                    return "Other"
               }
               else if(value=="OP")
               {
                    return "Operating Theatre"
               }
               else if(value=="EM")
               {
                    return "Emergency"
               }
               else if(value=="DS")
               {
                    return "Day Surgery"
               } 
               else if(value=="MR")
               {
                    return "Medical Records"
               }  
               else if(value=="OR")
               {
                    return "OutPatient Consulting Room"
               } 
               else if(value=="CL")
               {
                    return "Clinic"
               }  
               else if(value=="ADM")
               {
                    return "Admission Point"
               }                                                                                           
            }
        },
	    {field:'DEPDesc',title:'部门组',width:100,sortable:true},
	    {field:'opt',title:'操作',width:50,align:'center',
        formatter:function(){  
          //var btn = '<a class="contrast" href="#"  onclick="conMethod()" style="border:0px;cursor:pointer">对照</a>';
          var btn =  '<img class="contrast mytooltip" title="对照" onclick="conMethod()" src="../scripts_lib/hisui-0.1.0/dist/css/icons/compare.png" style="border:0px;cursor:pointer">'   
          return btn;  
        }  
      }

    ]];
    var hislocgrid = $HUI.datagrid("#hislocgrid",{
        url:$URL,
        queryParams:{
            ClassName:"web.DHCBL.CT.CTLoc",
            QueryName:"GetList"
        },
        columns: hiscolumns,  //列信息
        pagination: true,   //pagination	boolean	设置为 true，则在数据网格（datagrid）底部显示分页工具栏。
        pageSize:PageSizeMain,
        pageList:[5,10,15,20,25,30,50,75,100,200,300,500,1000],
        remoteSort:false,
        //ClassTableName:'User.MKBTermGJ',
		    //SQLTableName:'MKB_Term',
        idField:'CTLOCRowID',
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
    $('#hislocsearch').click(function(e){
      SearchHisLoc();
    });
    //搜索回车事件
    $('#hislocDesc').keyup(function(event){
      if(event.keyCode == 13) {
        SearchHisLoc();
      }
    });    
    //搜索方法
    SearchHisLoc=function()
    {
      var hislocDesc=$('#hislocDesc').val();
      $('#hislocgrid').datagrid('reload',  {
              ClassName:"web.DHCBL.CT.CTLoc",
              QueryName:"GetList",
              desc:hislocDesc
      });
      $('#hislocgrid').datagrid('unselectAll');      
    }    
    //重置
    $('#hislocRefresh').click(function(e){
    	$('#hislocDesc').val("");
    	$('#hislocgrid').datagrid('reload',  {
            	ClassName:"web.DHCBL.CT.CTLoc",
            	QueryName:"GetList"
    	});
    	$('#hislocgrid').datagrid('unselectAll');
    });
    //对照，1对1
    conMethod=function()
    {
 		setTimeout(function(){
			var record=$('#locgrid').datagrid('getSelected');
			var hisRecord=$('#hislocgrid').datagrid('getSelected');
			if(!record)
			{
				$.messager.alert('错误提示','请选择需要对照的科室！',"error");
            	return;
			}
			var ids=record.HOSPLRowId+'^'+hisRecord.CTLOCRowID;
			var data=tkMakeServerCall("web.DHCBL.KB.DHCPHHospLocCon","SaveData",ids);
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
				});*/
        $.messager.popover({msg: '对照成功！',type:'success',timeout: 1000}); 
				$('#contrastgrid').datagrid('load',  {
	            	ClassName:"web.DHCBL.KB.DHCPHHospLocCon",
	            	QueryName:"GetList",
	            	id:record.HOSPLRowId
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
        {field:'HOSPLRowId',title:'rowid',width:100,hidden:true,sortable:true},
        {field:'HOSPLCode',title:'代码',width:100,sortable:true},
        {field:'HOSPLDesc',title:'描述',width:100,sortable:true},
        {field:'HOSPLHisCode',title:'his代码',width:100,sortable:true},
        {field:'HOSPLHisDesc',title:'his描述',width:100,sortable:true},
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
            ClassName:"web.DHCBL.KB.DHCPHHospLocCon",
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
        idField:'HOSPLRowId',
        rownumbers:true,    //设置为 true，则显示带有行号的列。
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
        		var locrecord=$('#locgrid').datagrid('getSelected');
      			var rowid=record.HOSPLRowId;
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
						            	ClassName:"web.DHCBL.KB.DHCPHHospLocCon",
						            	QueryName:"GetList",
						            	id:locrecord.HOSPLRowId
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