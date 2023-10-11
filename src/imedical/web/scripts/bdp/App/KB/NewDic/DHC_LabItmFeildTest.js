/*
* @Author: 基础数据平台-石萧伟
* @Date:   2018-07-23 15:41:35
* @Last Modified by:   admin
* @Last Modified time: 2018-09-28 14:47:44
* @描述:知识库目录字典
*/
var SAVE_ACTION_URL = "../csp/dhc.bdp.ext.entitydatatrans.csp?pClassName=web.DHCBL.KB.DHCPHInstLabel&pClassMethod=SaveData&pEntityName=web.Entity.KB.DHCPHInstLabel";
var DELETE_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.KB.DHCPHInstLabel&pClassMethod=DeleteData";
var init = function(){
 var columns =[[
        {field:'PINLCode',title:'代码',sortable:true,width:100},
        {field:'PINLDesc',title:'描述',sortable:true,width:100},
        {field:'PINLLabelDr',title:'知识库标识',sortable:true,width:100},
        {field:'PINLOrderNum',title:'顺序',sortable:true,width:100,
        		sorter:function (a,b){  
						    if(a.length > b.length) return 1;
						        else if(a.length < b.length) return -1;
						        else if(a > b) return 1;
						        else return -1;
				},hidden:true
    	},
        {field:'PINLManageMode',title:'管理模式',sortable:true,width:100,
        	formatter: function(value,row,index){
        		if(value=="W")
        		{
        			return "Warn";
        		}
        		else if(value=="C")
        		{
        			return "Control";
        		}
        		else if(value=="S")
        		{
        			return "Star"
        		}
        	}
    	},
        {field:'PHLIRowId',title:'知识库标识字典rowid',sortable:true,width:100,hidden:true},
        {field:'PINLAlertMsg',title:'提示消息',sortable:true,width:100},
        {field:'PINLIcon',title:'图标路径',sortable:true,width:100},
        {field:'PINLAllFlag',title:'是否全部通过',sortable:true,width:100,
              formatter:ReturnFlagIcon
    	},
        {field:'PINLRowID',title:'rowid',sortable:true,width:100,hidden:true}
    ]];
    var mygrid = $HUI.datagrid("#mygrid",{
        url:$URL,
        queryParams:{
            ClassName:"web.DHCBL.KB.DHCPHInstLabel",
            QueryName:"GetList"
        },
        columns: columns,  //列信息
        pagination: true,   //pagination	boolean	设置为 true，则在数据网格（datagrid）底部显示分页工具栏。
        pageSize:PageSizeMain,
        pageList:[5,10,15,20,25,30,50,75,100,200,300,500,1000],
        singleSelect:true,
        remoteSort:false,
        ClassTableName:'User.DHCPHInstLabel',
		SQLTableName:'DHC_PHInstLabel',
        idField:'PINLRowID',
        sortName : 'PINLOrderNum',
		sortOrder : 'asc', 
        rownumbers:true,    //设置为 true，则显示带有行号的列。
        fixRowNumber:true,
        fitColumns:true, //设置为 true，则会自动扩大或缩小列的尺寸以适应网格的宽度并且防止水平滚动
        onDblClickRow:function(index,row)
        {
        	updateData();
        	//changeUpDownStatus(index);
        },
        onClickRow:function(index,row)
        {
        	changeUpDownStatus(index);
        },
        onLoadSuccess:function(data){
			$(this).prev().find('div.datagrid-body').prop('scrollTop',0);
        }	
    	
    });
	//工具栏知识库标识下拉框
	$('#KnoDesc').combobox({
        url:$URL+"?ClassName=web.DHCBL.KB.DHCPHLibaryLabel&QueryName=GetDataForCmb1&ResultSetType=array",
        valueField:'PHLIRowId',
        textField:'PHLIDesc',
        //mode:'remote',
        panelWidth:250 
    });
    //弹出框知识库标识下拉框
	$('#PINLLabelDr').combobox({
        url:$URL+"?ClassName=web.DHCBL.KB.DHCPHLibaryLabel&QueryName=GetDataForCmb1&ResultSetType=array",
        valueField:'PHLIRowId',
        textField:'PHLIDesc',
        //mode:'remote',
        panelWidth:250 
    }); 
    //管理模式下拉框
    $("#PINLManageMode").combobox({
        valueField:'id',
        textField:'text',
        data:[
            {id:'W',text:'Warn'},
            {id:'C',text:'Control'},
            {id:'S',text:'Stat'}
        ]
    });
    //点击搜索按钮
    $('#btn_search').click(function(e){
    	var code=$("#CodeDesc").val();
    	var desc=$("#TextDesc").val();
    	var knoflag=$('#KnoDesc').combobox('getValue');
    	$('#mygrid').datagrid('load',  { 
            ClassName:"web.DHCBL.KB.DHCPHInstLabel",
            QueryName:"GetList",
            desc:desc,
            code:code,
            lib:knoflag
        });
        $('#mygrid').datagrid('unselectAll');
    });
    //点击重置按钮
    $('#btnRefresh').click(function(e){
		$("#TextDesc").val('');//清空检索框
		$("#CodeDesc").val('');
		$('#KnoDesc').combobox('setValue','');
        $('#mygrid').datagrid('load',  { 
            ClassName:"web.DHCBL.KB.DHCPHInstLabel",
            QueryName:"GetList"
        });
		$('#mygrid').datagrid('unselectAll');
    });
    //点击添加按钮
    $('#add_btn').click(function(e){
    	addData();
    });
    //点击修改按钮
    $('#update_btn').click(function(e){
    	updateData();
    });
    //点击删除按钮
    $('#del_btn').click(function(e){
    	delData();
    }); 
    delData=function()
    {
		var row = $("#mygrid").datagrid("getSelected"); 
		if (!(row))
		{	$.messager.alert('错误提示','请先选择一条记录!',"error");
			return;
		}
		var rowid=row.PINLRowID;
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
								$.messager.show({ 
								  title: '提示消息', 
								  msg: '删除成功', 
								  showType: 'show', 
								  timeout: 1000, 
								  style: { 
									right: '', 
									bottom: ''
								  } 
								}); 
								 $('#mygrid').datagrid('reload');  // 重新载入当前页面数据 
								 $('#mygrid').datagrid('unselectAll');  // 清空列表选中数据 
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
    addData=function()
    {
    	//singleselect=true;
 		$("#myWin").show();
		var myWin = $HUI.dialog("#myWin",{
			iconCls:'icon-w-add',
			resizable:true,
			title:'新增',
			modal:true,
			buttonAlign : 'center',
			buttons:[{
				text:'保存',
				id:'save_btn',
				handler:function(){
					saveFunLib("",1)
				}
			},
			{
				text:'继续添加',
				id:'save_goon',
				handler:function(){
					saveFunLib("",2)
				}
			},{
				text:'关闭',
				handler:function(){
					myWin.close();
				}
			}],
			onOpen:function(){
				//Disable2();
				Disable(2,author,myTMenuID,ObjectType,ObjectReference);
			}

		});
		$('#form-save').form("clear");
		var lastcode=tkMakeServerCall("web.DHCBL.KB.DHCPHInstLabel","GetLastOrder");
		$('#PINLOrderNum').val(lastcode);		
		$HUI.checkbox("#PINLAllFlag").setValue(true);	
    } 
    updateData=function()
	{
		var record = mygrid.getSelected(); 
		if(record)
		{
			var id=record.PINLRowID;
			$.cm({
				ClassName:"web.DHCBL.KB.DHCPHInstLabel",
				MethodName:"NewOpenData",
				id:id
			},function(jsonData){
				//给是否可用单独赋值	
				//alert(jsonData.PHLFSysFlag)		
				//alert(jsonData.PHLFActiveFlag)		
				if (jsonData.PINLAllFlag=="Y"){
					$HUI.checkbox("#PINLAllFlag").setValue(true);		
				}else{
					$HUI.checkbox("#PINLAllFlag").setValue(false);
				}
				$('#form-save').form("load",jsonData);	
			});	
			$("#myWin").show();
			var myWin = $HUI.dialog("#myWin",{
				iconCls:'icon-w-edit',
				resizable:true,
				title:'修改',
				modal:true,
				buttons:[{
					text:'保存',
					id:'save_btn',
					handler:function(){
						saveFunLib(id,1)
					}
				},{
					text:'关闭',
					handler:function(){
						myWin.close();
					}
				}],
				onOpen:function(){
					//Disable2();
					Disable(2,author,myTMenuID,ObjectType,ObjectReference);
				}
			});							
		}else{
			$.messager.alert('错误提示','请先选择一条记录!',"error");
		}
	}
    saveFunLib=function(id,flagT)
    {
    	var code=$.trim($("#PINLCode").val());
		var desc=$.trim($("#PINLDesc").val());	
		if (code=="")
		{
			$.messager.alert('错误提示','代码不能为空!',"error");
			return;
		}
		if (desc=="")
		{
			$.messager.alert('错误提示','描述不能为空!',"error");
			return;
		}
		$('#form-save').form('submit', {
			url:SAVE_ACTION_URL,
			onSubmit: function(param){
                param.PINLRowID = id;
            },
			success: function (data) { 
			  	var data=eval('('+data+')'); 
			  	if (data.success == 'true') {
					$.messager.show({ 
				 	title: '提示消息', 
				  	msg: '提交成功', 
				  	showType: 'show', 
				  	timeout: 1000, 
				  	style: { 
					right: '', 
					bottom: ''
				  	} 
				}); 
				$('#mygrid').datagrid('reload');  // 重新载入当前页面数据 
				if(flagT==1)
				{
					$('#myWin').dialog('close'); // close a dialog
				}
				else
				{
					$('#form-save').form("clear");
				}
		    } 
		  	else { 
				var errorMsg ="更新失败！"
				if (data.errorinfo) {
					errorMsg =errorMsg+ '<br/>错误信息:' + data.errorinfo
				}
			 	$.messager.alert('操作提示',errorMsg,"error");
			}

		} 
		});		    	
    }  
    $('#btnUp').click(function(e){
    	OrderProperty(1);
    });
    $('#btnDown').click(function(e){
    	OrderProperty(2);
    });
	///属性上移、下移
	OrderProperty=function (type){  
		//更新
		var row = $("#mygrid").datagrid("getSelected"); 
		if (!(row))
		{
			$.messager.alert('错误提示','请先选择一条记录!',"error");
			return;
		}	   
		var index = $("#mygrid").datagrid('getRowIndex', row);	
		mysort(index, type, "mygrid")
		
		//改变上移、下移按钮的状态
		var nowrow = $('#mygrid').datagrid('getSelected');  
		var rowIndex=$('#mygrid').datagrid('getRowIndex',nowrow); 
		changeUpDownStatus(rowIndex)
		//遍历列表
		var order=""
		var rows = $('#mygrid').datagrid('getRows');	
		for(var i=0; i<rows.length; i++){	
			var id =rows[i].PINLRowID; //频率id
			if (order!=""){
				order = order+"^"+id
			}else{
				order = id
			}	
		}
		//获取级别默认值
		$.m({
			ClassName:"web.DHCBL.KB.DHCPHInstLabel",
			MethodName:"NewSaveDragOrder",
			order:order
			},function(txtData){
			//alert(order+txtData)
		});
	} 
	function mysort(index, type, gridname) {
		if (1 == type) {
			if (index != 0) {
				var toup = $('#' + gridname).datagrid('getData').rows[index];
				var todown = $('#' + gridname).datagrid('getData').rows[index - 1];
				$('#' + gridname).datagrid('getData').rows[index] = todown;
				$('#' + gridname).datagrid('getData').rows[index - 1] = toup;
				$('#' + gridname).datagrid('refreshRow', index);
				$('#' + gridname).datagrid('refreshRow', index - 1);
				$('#' + gridname).datagrid('selectRow', index - 1);
			}
		} 
		else if (2 == type) {
			var rows = $('#' + gridname).datagrid('getRows').length;
			if (index != rows - 1) {
				var todown = $('#' + gridname).datagrid('getData').rows[index];
				var toup = $('#' + gridname).datagrid('getData').rows[index + 1];
				$('#' + gridname).datagrid('getData').rows[index + 1] = todown;
				$('#' + gridname).datagrid('getData').rows[index] = toup;
				$('#' + gridname).datagrid('refreshRow', index);
				$('#' + gridname).datagrid('refreshRow', index + 1);
				$('#' + gridname).datagrid('selectRow', index + 1);
			}
		}
	}
	 //改变上移下移按钮状态
	changeUpDownStatus=function(rowIndex)
	{
			if(rowIndex==0){
				$('#btnUp').linkbutton('disable');
				//$('#btnFirst').linkbutton('disable');
			}else
			{
				$('#btnUp').linkbutton('enable');
				//$('#btnFirst').linkbutton('enable');
			}
			var rows = $('#mygrid').datagrid('getRows');
			if ((rowIndex+1)==rows.length){
				$('#btnDown').linkbutton('disable');
			}else
			{
				$('#btnDown').linkbutton('enable');
			}
	}	
	Disable(1,author,myTMenuID,ObjectType,ObjectReference);	         
}
$(init);