
var init = function()
{
	var columns =[[  
				  {field:'ck',checkbox:true},
				  {field:'Flag',title:'表简称',width:80,sortable:true,hidden:true},
				  {field:'ID',title:'引用ID',width:150,sortable:true,hidden:true},
				  {field:'Desc',title:'引用信息',width:150,sortable:true}
	 ]];
	 
	 
	var mygrid = $HUI.datagrid("#mygrid",{
		url:$URL,
		queryParams:{
			ClassName:"web.DHCBL.MKB.MKBReference",         ///调用Query时
			QueryName:"GetReferedList",
			MKBReferFlag:MKBReferFlag,
			MKBReferID:MKBReferID
		},
		idField:'ID',
		columns: columns,  //列信息
		pagination: true,   //pagination	boolean	设置为 true，则在数据网格（datagrid）底部显示分页工具栏。
		pageSize:50,
		pageList:[5,10,15,20,25,30,50,75,100,200,300,500,1000], 
		singleSelect:true,
		checkOnSelect:false,
		selectOnCheck:false,
		rownumbers:true,    //设置为 true，则显示带有行号的列。
		fixRowNumber:true,
		fitColumns:true, //设置为 true，则会自动扩大或缩小列的尺寸以适应网格的宽度并且防止水平滚动
		remoteSort:false,  //定义是否从服务器排序数据。true
		onDblClickRow:function(rowIndex,rowData){
        	
        },
        onLoadSuccess:function(data){
	        $(this).prev().find('div.datagrid-body').prop('scrollTop',0);  //如果有滚动条，滚动到最上面
        	$(this).datagrid('columnMoving'); //列可以拖拽改变顺序
        }
	});
	 //删除引用数据
    $("#delRefered_btn").click(function(e){
		delRefered()
	})
	//批量删除引用数据
	delRefered = function(){
		var Checkedrecord =  $('#mygrid').datagrid('getChecked')
		if (!(Checkedrecord)) {
			$.messager.alert('提示','请选择需要删除的引用数据!',"warning");
			return;
		} 
		var CheckedRowStr=""
		for(var i = 0; i < Checkedrecord.length; i++){
			if (CheckedRowStr=="")
			{
				CheckedRowStr=Checkedrecord[i].Flag+"^"+Checkedrecord[i].ID
			}
			else
			{
				CheckedRowStr=CheckedRowStr+"&"+Checkedrecord[i].Flag+"^"+Checkedrecord[i].ID
			}
			
		}
		//alert(MKBReferFlag+"[A]"+MKBReferID+"[A]"+CheckedRowStr)
		var result=tkMakeServerCall("web.DHCBL.MKB.MKBReference","DeleteSelected",MKBReferFlag,MKBReferID,CheckedRowStr);
		if(result==''){  
			$.messager.popover({msg: '删除成功!',type:'success',timeout: 1000});
			$('#mygrid').datagrid('reload');
			$('#mygrid').datagrid('clearChecked');
		}else{
			var errorMsg="删除失败！";
			errorMsg=errorMsg+'</br>错误信息:'+result
			
			$.messager.alert('错误提示',errorMsg,'error')
		}		
	}
}
$(init);