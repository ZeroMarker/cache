
/**
 * @author 2019-06-28 by 谢海睿
 * 说明：
 * 		1.别名维护面板
 * 		2.公共方法:
 * 			saveAlias()   ----保存别名数据(包括：修改、新增)
 * 			loadGrid()    ----加载grid数据
 * 			delAlias()    ----删除一条别名(local and remote)
 * 			clearGrid()   ----清空grid数据(local)
 * 			
 */

var	ALIAS_QUERY_ACTION_URL = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.MRCICDAlias&pClassQuery=GetList";
var ALIAS_DELETE_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.MRCICDAlias&pClassMethod=DeleteData";
var	ALIAS_SAVE_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.MRCICDAlias&pClassMethod=SaveAll";
var init = function(){
	var editIndex = undefined;
	var rowsvalue=undefined;
	var oldrowsvalue=undefined;
	
	var columns=[[
		{field:'ALIASParRef',title:'ALIASParRef',sortable:true,width:100,hidden:true,editor:'validatebox'},
        {field:'ALIASRowId',title:'ALIASRowId',sortable:true,width:100,hidden:true,editor:'validatebox'},
        {field:'ALIASText',title:'别名',sortable:true,width:100,editor:'validatebox'}, 
	]];
	var AliasGrid = $HUI.datagrid("#AliasGrid",{
		url:$URL,
		queryParams:{
			ClassName:"web.DHCBL.CT.MRCICDAlias",         ///调用Query时
			QueryName:"GetList"
		},
		idField:'ALIASRowId',//ALIASRowId
		columns: columns,  //列信息
		pageSize:15,
		pageList:[5,10,15,20,25,30,50,75,100,200,300,500,1000], 
		singleSelect:true,
		ClassTableName:'User.MRCICDAlias',
		SQLTableName:'MRC_ICDAlias', 
		fitColumns:true, //设置为 true，则会自动扩大或缩小列的尺寸以适应网格的宽度并且防止水平滚动
		remoteSort:false,  //定义是否从服务器排序数据。true
		onDblClickRow:function(rowIndex, field){
			DblClickFun(rowIndex,field)
	        
	    },
		onClickRow:function(rowIndex,field){
			//数据表格单击事件
		   $('#AliasGrid').datagrid('selectRow', rowIndex);
		   ClickFun();
	    },
		onLoadSuccess:function(data){
		}
		
	});
	$('#add_btn1').click(function (e){	
        AddDatao();
    });
  
    $('#del_btn1').click(function (e){ 
        DelData();
	});

	//用于单击非grid行保存可编辑行
	$(document).bind('click',function(){ 
	    ClickFun();
	});
	//结束表格的可编辑状态
	function endEditing(){
		if (editIndex == undefined){return true}
		if ($('#AliasGrid').datagrid('validateRow', editIndex))//验证指定的行，当验证有效的时候返回true
		{
			$('#AliasGrid').datagrid('endEdit', editIndex);//结束编辑行
			rowsvalue=AliasGrid.getRows()[editIndex];    //临时保存激活的可编辑行的row   
			return true;
		} else 
		{
			return false;
		}
	}
 	function ClickFun(type){   //单击执行保存可编辑行
		if (endEditing()){
			if(rowsvalue!= undefined){
				if((rowsvalue.ALIASText!=""))
				{
					var rows = $('#AliasGrid').datagrid('getRows');//获取当前页的数据行    
				    for (var i = 0; i < rows.length; i++) {  
				        var valuerow = rows[i]['ALIASText'];
				        if (valuerow == rowsvalue.ALIASText && i != editIndex)
				        {
				        	$.messager.alert('错误提示','别名重复！','error');
							var newEditIndex=$('#AliasGrid').datagrid('getRowIndex',$('#AliasGrid').datagrid('getSelected'));
							AliasGrid.deleteRow(newEditIndex)								
							return 				        	
				        }
				    }  		
					var differentflag="";
					if(oldrowsvalue!= undefined)
					{
						var oldrowsvaluearr=JSON.parse(oldrowsvalue)
						for(var params in rowsvalue)
						{
							if(oldrowsvaluearr[params]!=rowsvalue[params])
							{
								differentflag=1
							}
						}
					}
					else
					{
						differentflag=1
					}
					if(differentflag==1)
					{
						preeditIndex=editIndex;
					}
					else
					{
						editIndex=undefined
						rowsvalue=undefined
					}
				}
				else
				{
					$.messager.alert('错误提示','代码或描述不能为空！','error')
					$('.messager-window').click(stopPropagation)
					$('#AliasGrid').datagrid('selectRow', editIndex)
					.datagrid('beginEdit', editIndex);
					return 0
				}
			}
		}
	}
	function DblClickFun (index,row)    //双击激活可编辑   （可精简）
	{   
		if(index==editIndex){
			return
		}
		preeditIndex=editIndex;
		if (editIndex != index)
		{
			if (endEditing())
			{
				$('#AliasGrid').datagrid('selectRow', index)
				.datagrid('beginEdit', index);
				editIndex = index;
			} 
			else 
			{
				$('#AliasGrid').datagrid('selectRow', editIndex);
			}
		}
		oldrowsvalue=JSON.stringify(row);   //用于和rowvalue比较 以判断是否行值发生改变
	} 
    //新增
	function AddDatao()
	{
		 if(ClickFun('AddDatao')==0){
			return
		} 
	    preeditIndex=editIndex;
		if (endEditing())
		{
			$('#AliasGrid').datagrid('insertRow',{index:0,row:{}});//插入新行
			editIndex = 0;
			$('#AliasGrid').datagrid('selectRow', editIndex)
			.datagrid('beginEdit', editIndex);
		}
    }
	//删除
	
	function DelData(){
		var record=AliasGrid.getSelected();
		if(!record)
		{
			$.messager.alert('提示','请选择一条记录！','error');
			return;
		}
		if((record.ALIASRowId==undefined)||(record.ALIASRowId==""))
		{
			AliasGrid.deleteRow(editIndex)
			editIndex = undefined;
			return;
		}
		$.messager.confirm('确认','您要删除这条数据吗?',function(r)
		{
			if(r){
				id=record.ALIASRowId;
				$.ajax({
					url:"../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.MRCICDAlias&pClassMethod=DeleteData",
					data:{"id":id},
					type:'POST',
					success:function(data){
						var data=eval('('+data+')');
						if(data.success=='true')
						{
							$.messager.popover({msg: '删除成功！',type:'success',timeout: 1000});
							$('#AliasGrid').datagrid('reload');
							$('#AliasGrid').datagrid('unselectAll');
							editIndex = undefined;
							rowsvalue=undefined;
						}
						else
						{
							var errorMsg="删除失败！";
							if(data.info)
							{
								errorMsg=errorMsg+'</br>错误信息:'+data.info
							}
							$.messager.alert('错误提示',errorMsg,'error')
						}
					}
				});
			}
		});
	}	
}
$(init);