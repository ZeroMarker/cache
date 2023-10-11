/// 名称: 通用名对照
/// 描述: 包含通用名表与his通用名表对照功能，与已对照通用名删除功能
/// 编写者: 基础数据平台组-丁亚男
/// 编写日期: 2018-07-27
var DELETE_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.KB.DHCGenItmContrast&pClassMethod=DeleteData";
var init=function()
{
   var columns =[[
   		{field:'PHEGRowId',title:'PHEGRowId',sortable:true,width:100,hidden:true},
        {field:'PHEGCode',title:'代码',sortable:true,width:100},
        {field:'PHEGDesc',title:'描述',sortable:true,width:100},
        {field:'PHEGActiveFlag',title:'启用',sortable:true,width:100,align:'center',formatter:ReturnFlagIcon},
        {field:'OTFlag',title:'医嘱类型标识',sortable:true,width:100,
					  formatter:function(v,row,index){  
							if(v=='TS'){return '医嘱套';}
							if(v=='TC'){return '医嘱项';}
						}
        }
        
    ]];
    var gengrid = $HUI.datagrid("#gengrid",{
       url:$URL,
        queryParams:{
            ClassName:"web.DHCBL.KB.DHCGenItmContrast",
            QueryName:"GetLABList"
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
    		$('#textHisDesc').val("");
    		if($('#lis').combobox('getValue') == 'LAB'){
				var OTFlag=row.OTFlag;
		 		if(OTFlag=="TS"){
					$('#hisgengrid').datagrid('reload',  {
			    		ClassName:"web.DHCBL.CT.CTTestSet",
		            	QueryName:"GetList"
			    		});	
		 		}else{
		 			$('#hisgengrid').datagrid('reload',  {
			    		ClassName:"web.DHCBL.CT.CTTestCode",
		            	QueryName:"GetList"
			    		});	
		 		}
		 	}
        }		
    });
	//主要成分标识
	$HUI.combobox("#lis",{
		valueField:'id',
		textField:'text',
		value:'LAB',
		data:[
			{id:'LAB',text:'检验项目'},
			{id:'SPEC',text:'检验标本'}		
		],
		onSelect:function(record){
			if(record.id=='LAB'){
				$('#gengrid').datagrid('reload',  {
	    		ClassName:"web.DHCBL.KB.DHCGenItmContrast",
            	QueryName:"GetLABList"
	    		});	
				$('#hisgengrid').datagrid('reload',  {
	    		ClassName:"web.DHCBL.CT.CTTestCode",
            	QueryName:"GetList"
	    		});				
			}
			else
			{
				$('#gengrid').datagrid('reload',  {
	    		ClassName:"web.DHCBL.KB.DHCGenItmContrast",
            	QueryName:"GetSPECList"
	    		});	
				$('#hisgengrid').datagrid('reload',  {
	    		ClassName:"web.DHCBL.CT.CTSpecimen",
            	QueryName:"GetList"
	    		});
	    	}
			$('#gengrid').datagrid('reload')
			$('#hisgengrid').datagrid('reload')
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
    SearchGen=function()
    {
    	var gendesc=$('#genDesc').val();
    	var genflag=$.trim($('#lis').combobox('getValue'));
    	if (genflag=="LAB"){
	    	$('#gengrid').datagrid('reload',  {
	    		ClassName:"web.DHCBL.KB.DHCGenItmContrast",
            	QueryName:"GetLABList",
            	desc:gendesc
	    		});	
				
				$('#hisgengrid').datagrid('reload',  {
	    		ClassName:"web.DHCBL.CT.CTTestCode",
            	QueryName:"GetList"
	    		});	
    	}
    	else
    	{
    		$('#gengrid').datagrid('reload',  {
	    		ClassName:"web.DHCBL.KB.DHCGenItmContrast",
            	QueryName:"GetSPECList",
            	desc:gendesc
	    		});	
				$('#hisgengrid').datagrid('reload',  {
	    		ClassName:"web.DHCBL.CT.CTSpecimen",
            	QueryName:"GetList"
	    		});
    	
    	}
		$('#gengrid').datagrid('unselectAll');
		$('#hisgengrid').datagrid('unselectAll');    	
    }    
    //重置
    $('#genRefresh').click(function(e){
    	$('#genDesc').val("");
    	var genflag=$.trim($('#lis').combobox('getValue'));
    	if (genflag=="LAB"){
	    	$('#gengrid').datagrid('reload',  {
	    		ClassName:"web.DHCBL.KB.DHCGenItmContrast",
            	QueryName:"GetLABList"
	    		});	
				
				$('#hisgengrid').datagrid('reload',  {
	    		ClassName:"web.DHCBL.CT.CTTestCode",
            	QueryName:"GetList"
	    		});	
    	}
    	else
    	{
			$('#gengrid').datagrid('reload',  {
				ClassName:"web.DHCBL.KB.DHCGenItmContrast",
				QueryName:"GetSPECList"
				});	
				$('#hisgengrid').datagrid('reload',  {
				ClassName:"web.DHCBL.CT.CTSpecimen",
				QueryName:"GetList"
				});
    	
    	}
		$('#contrastgrid').datagrid('load',  {
			 ClassName:"web.DHCBL.KB.DHCGenItmContrast",
   			 QueryName:"GetList",
        	 id:""
		});    	
		$('#gengrid').datagrid('unselectAll');
		$('#hisgengrid').datagrid('unselectAll');
    });
	
	//2021-05-24 by：xuwenhu
	//自动匹配
	$('#BatchContrast').click(function(e){
		var genflag=$.trim($('#lis').combobox('getValue'));
		var result= tkMakeServerCall("web.DHCBL.KB.DHCGenItmContrast","AutoContrastLisData",genflag);
		var result = eval('(' + result + ')');
		if (genflag=="LAB"){
			$('#gengrid').datagrid('reload',  {
				ClassName:"web.DHCBL.KB.DHCGenItmContrast",
				QueryName:"GetLABList"
			});
		}
		else
		{
			$('#gengrid').datagrid('reload',  {
				ClassName:"web.DHCBL.KB.DHCGenItmContrast",
				QueryName:"GetSPECList"
			});	
		}
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
            ClassName:"web.DHCBL.CT.CTTestCode",
            QueryName:"GetList"
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
    	var genflag=$.trim($('#lis').combobox('getValue'));
    	var row = $("#gengrid").datagrid("getSelected"); 
    	if (!(row))
		{	
			var OTFlag=""
		}
		else
		{
			 var OTFlag=row.OTFlag;
		}
    	if (genflag=="LAB"){
	 		if(OTFlag=="TS"){
				$('#hisgengrid').datagrid('reload',  {
		    		ClassName:"web.DHCBL.CT.CTTestSet",
	            	QueryName:"GetList",
	            	desc:textHisDesc
		    		});	
	 		}else{
	 			$('#hisgengrid').datagrid('reload',  {
		    		ClassName:"web.DHCBL.CT.CTTestCode",
	            	QueryName:"GetList",
	            	desc:textHisDesc
		    		});	
	 		}
    	}
    	else
    	{
    		$('#hisgengrid').datagrid('reload',  {
	    		ClassName:"web.DHCBL.CT.CTSpecimen",
            	QueryName:"GetList",
	            desc:textHisDesc
	    	});
    	
    	}
    	$('#hisgengrid').datagrid('unselectAll');    	
    }    
    //重置
    $('#hisgenRefresh').click(function(e){
    	$('#textHisDesc').val("");
    	var genflag=$.trim($('#lis').combobox('getValue'));
    	var row = $("#gengrid").datagrid("getSelected"); 
    	if (!(row))
		{	
			var OTFlag=""
		}
		else
		{
			 var OTFlag=row.OTFlag;
		}
    	if (genflag=="LAB"){
    		if(OTFlag=="TS"){
				$('#hisgengrid').datagrid('reload',  {
		    		ClassName:"web.DHCBL.CT.CTTestSet",
	            	QueryName:"GetList"
		    		});	
	 		}else{
	 			$('#hisgengrid').datagrid('reload',  {
		    		ClassName:"web.DHCBL.CT.CTTestCode",
	            	QueryName:"GetList"
		    		});	
	 		}
    	}
    	else
    	{
    		$('#hisgengrid').datagrid('reload',  {
	    		ClassName:"web.DHCBL.CT.CTSpecimen",
            	QueryName:"GetList"
	    	});
    	
    	}
    	$('#hisgengrid').datagrid('unselectAll');
    });
    //对照，1对1
    conMethod=function()
    {
 		setTimeout(function(){
			var record=$('#gengrid').datagrid('getSelected');
			var hisRecord=$('#hisgengrid').datagrid('getSelected');
			var flag = $('#lis').combobox('getValue')
			
			if(!record)
			{
				$.messager.alert('错误提示','请先选择一条通用名对照！',"error");
            	return;
			}
			var otflag=record.OTFlag;
			var ids=record.PHEGRowId+'^'+hisRecord.RowId+'^'+flag+'^'+otflag;
			var data=tkMakeServerCall("web.DHCBL.KB.DHCGenItmContrast","SaveLisData",ids);
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
        {field:'GICTCoeff',title:'转换系数',width:100,sortable:true,editor : {
		                  type : 'validatebox'
		             }},
        {field:'opt',title:'操作',width:50,align:'center',
			formatter:function(){  
				//var btn = '<a class="contrast" href="#"  onclick="delContrast()" style="border:0px;cursor:pointer">删除</a>';  
				var btn =  '<img class="contrast" onclick="delContrast()" src="../scripts_lib/hisui-0.1.0/dist/css/icons/cancel.png" style="border:0px;cursor:pointer">' 
				return btn;  
			}  
        }

    ]];
    //是否有正在编辑的行true/false
    var editIndex=undefined
	function endEditing(){
		if (editIndex == undefined){return true}
		if ($('#contrastgrid').datagrid('validateRow', editIndex)){
			$('#contrastgrid').datagrid('endEdit', editIndex);
			editIndex = undefined;
			return true;
		} else {
			return false;
		}
	}  
	
    
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
        toolbar:[],//表头和数据之间的缝隙
        fitColumns:true, //设置为 true，则会自动扩大或缩小列的尺寸以适应网格的宽度并且防止水平滚动  
        onClickCell:function(index, field){
        	if (endEditing()) {
				if(field=="GICTCoeff"){
					$(this).datagrid('beginEdit', index);
					var ed = $(this).datagrid('getEditor', {index:index,field:field});
					$(ed.target).focus();
				}		
				editIndex = index;
			}
			//$('#contrastgrid').datagrid('onClickRow')

        },
        onAfterEdit:function(index, row, changes) {
        	
        	var genrecord=$('#gengrid').datagrid('getSelected');
        	var updated = $('#contrastgrid').datagrid('getChanges', 'updated');
			if (updated.length < 1) {
				editRow = "";
				$('#contrastgrid').datagrid('unselectAll');
				return;
			} else {
				$.m({
						ClassName:"web.DHCBL.KB.DHCGenItmContrast",
						MethodName:"SaveCoeff",
						coeff:row.GICTCoeff,
						id:row.GICTRowId
					},function (data) { 
						  var data=eval('('+data+')'); 
						  if (data.success == 'true') {
								/*$.messager.show({ 
								  title: '提示消息', 
								  msg: '提交成功', 
								  showType: 'show', 
								  timeout: 1000, 
								  style: { 
									right: '', 
									bottom: ''
								  } 
								}); */
								$.messager.popover({msg: '保存成功！',type:'success',timeout: 1000});
								$('#contrastgrid').datagrid('load',  {
						            	ClassName:"web.DHCBL.KB.DHCGenItmContrast",
						            	QueryName:"GetList",
						            	id:genrecord.PHEGRowId
					        		}); 
						  } 
						  else { 
								var errorMsg ="提交失败！"
								if (data.errorinfo) {
									errorMsg =errorMsg+ '<br/>错误信息:' + data.errorinfo
								}
								$.messager.alert('操作提示',errorMsg,"error");
						}
						
				} ); 
			}

        }
    });
	delContrast=function()
	{
		//alert(1)
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
									});*/
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