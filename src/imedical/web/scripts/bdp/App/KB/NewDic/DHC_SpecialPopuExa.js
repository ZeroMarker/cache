/*
* @Author: 基础数据平台-石萧伟
* @Date:   2018-08-01 15:41:35
* @Last Modified by:   admin
* @Last Modified time: 2018-10-22 14:16:27
* @描述:特殊人群与检查结果关联表维护
*/
var SAVE_ACTION_URL = "../csp/dhc.bdp.ext.entitydatatrans.csp?pClassName=web.DHCBL.KB.DHCSpecialPopuExa&pClassMethod=SaveData&pEntityName=web.Entity.KB.DHCSpecialPopuExa";
var DELETE_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.KB.DHCSpecialPopuExa&pClassMethod=DeleteData";
var init = function(){
	var editIndex = undefined;
	var rowsvalue=undefined;
	var oldrowsvalue=undefined;
	var preeditIndex="";
	var columns =[[	
        {field:'SPEEPODrF',title:'特殊人群',sortable:true,width:100,
            formatter: function(value,row,index){
           		return parrefDesc;
            } 
    	},
        {field:'SPEEPODr',title:'特殊人群id',sortable:true,width:100,hidden:true,editor:'validatebox'},
        {field:'ExaRowId',title:'检查结果F',sortable:true,width:100,hidden:true,editor:'validatebox'},
        {field:'SPEEEXDr',title:'检查结果',sortable:true,width:100,editor:{
 		  	type:'combobox',
			options:{
				valueField:'ExaRowId',
				textField:'ExaResult',
	        	url:$URL+"?ClassName=web.DHCBL.KB.DHCExamineFeild&QueryName=GetNewDataForCmb1&ResultSetType=array",
	            onHidePanel:function(){
		        	var val=$(this).combobox('getText');
		        	var ed = $('#resultgrid').datagrid('getEditor', {index:editIndex,field:'ExaRowId'});
					$(ed.target).val(val)
		        }					
			} 
    	}},
    	{field:'SPEEActiveFlagF',title:'是否可用F',sortable:true,width:100,hidden:true,editor:'validatebox'},
        {field:'SPEEActiveFlag',title:'是否可用',sortable:true,width:100,editor:{
	 		  	type:'combobox',
				options:{
			        valueField:'id',
			        textField:'text',
			        data:[
			            {id:'Y',text:'是'},
			            {id:'N',text:'否'}
			        ],
			        value:'Y',
		            onHidePanel:function(){
			        	var val=$(this).combobox('getText');
			        	var ed = $('#resultgrid').datagrid('getEditor', {index:editIndex,field:'SPEEActiveFlagF'});
						$(ed.target).val(val)
			        }					
				} 
    		},
            formatter:ReturnFlagIcon
    	},
    	{field:'SPEESysFlagF',title:'系统标识F',sortable:true,width:100,hidden:true,editor:'validatebox'},
        {field:'SPEESysFlag',title:'系统标识',sortable:true,width:100,editor:{
	 		  	type:'combobox',
				options:{
			        valueField:'id',
			        textField:'text',
			        data:[
			            {id:'Y',text:'是'},
			            {id:'N',text:'否'}
			        ],
			        value:'Y',
		            onHidePanel:function(){
			        	var val=$(this).combobox('getText');
			        	var ed = $('#resultgrid').datagrid('getEditor', {index:editIndex,field:'SPEESysFlagF'});
						$(ed.target).val(val)
			        }					
				} 
    		},
            formatter:ReturnFlagIcon
    	},        
        {field:'SPEERowId',title:'rowid',sortable:true,width:100,editor:'validatebox',hidden:true}
    ]];
    var mygrid = $HUI.datagrid("#resultgrid",{
        url:$URL,
        queryParams:{
            ClassName:"web.DHCBL.KB.DHCSpecialPopuExa",
            QueryName:"GetNewList",
            parref:parref
        },
        columns: columns,  //列信息
        pagination: true,   //pagination	boolean	设置为 true，则在数据网格（datagrid）底部显示分页工具栏。
        pageSize:PageSizePop,
        pageList:[5,10,15,20,25,30,50,75,100,200,300,500,1000],
        singleSelect:true,
        remoteSort:false,
        //ClassTableName:'User.DHCLabItmResult',
		//SQLTableName:'DHC_LabItmResult',
        idField:'SPEERowId',
        rownumbers:true,    //设置为 true，则显示带有行号的列。
        fixRowNumber:true,
        fitColumns:true, //设置为 true，则会自动扩大或缩小列的尺寸以适应网格的宽度并且防止水平滚动
        onDblClickRow:function(index,row)
        {
        	//updateData();
        },
        onLoadSuccess:function(data){
			$(this).prev().find('div.datagrid-body').prop('scrollTop',0);
        },	
        onClickRow:function(rowIndex,rowData){
			$('#resultgrid').datagrid('selectRow', rowIndex);
			ClickFun();
	    },
        onDblClickCell:function(rowIndex, field, value){
	        var rowData=$('#resultgrid').datagrid('getSelected');
			DblClickFun(rowIndex,rowData,field);
	    }
    	
    });
	//搜索是检验结果下拉框
	$('#TextExa').combobox({
        url:$URL+"?ClassName=web.DHCBL.KB.DHCExamineFeild&QueryName=GetNewDataForCmb1&ResultSetType=array",
        valueField:'ExaRowId',
        textField:'ExaResult',
        mode:'remote'
    });   
    //点击搜索按钮
    $('#btnSearch').click(function(e){
    	var exa=$('#TextExa').combobox('getValue');
    	$('#resultgrid').datagrid('load',  { 
            ClassName:"web.DHCBL.KB.DHCSpecialPopuExa",
            QueryName:"GetNewList",
			parref:parref,
			exa:exa
        });
        $('#resultgrid').datagrid('unselectAll');
        editIndex = undefined;
		rowsvalue=undefined;
    });
    //点击重置按钮
    $('#btnRefresh').click(function(e){
    		ClearFunLib();
    }); 
    function ClearFunLib()
    {
  		$("#TextExa").combobox('setValue','');//清空检索框
        $('#resultgrid').datagrid('load',  { 
            ClassName:"web.DHCBL.KB.DHCSpecialPopuExa",
            QueryName:"GetNewList",
            parref:parref
        });
		$('#resultgrid').datagrid('unselectAll'); 
		editIndex = undefined;
		rowsvalue=undefined; 	
    } 
    //点击添加按钮
    $('#add_btn').click(function(e){
    	AddData();
    });
    //点击修改按钮
    $('#update_btn').click(function(e){
    	SaveFunLib();
    });
    //点击删除按钮
    $('#del_btn').click(function(e){
    	DelData();
    });
    $('.datagrid-pager').find('a').each(function(){
		$(this).click(function(){
			editIndex = undefined;
			rowsvalue=undefined;
			oldrowsvalue=undefined;
			preeditIndex="";
		})
	});
	//用于单击非grid行保存可编辑行
	$(document).bind('click',function(){ 
	    ClickFun();
	});
	//下拉框等组件所在显示列和隐藏列值的互换
	function UpdataRow(row,Index)
	{
		var temp;
		temp=row.SPEEEXDr;
		row.SPEEEXDr=row.ExaRowId;
		row.ExaRowId=temp;

		temp=row.SPEEActiveFlag;
		row.SPEEActiveFlag=row.SPEEActiveFlagF;
		row.SPEEActiveFlag=temp;

		temp=row.SPEESysFlag;
		row.SPEESysFlag=row.SPEESysFlagF;
		row.SPEESysFlag=temp;
		$('#resultgrid').datagrid('updateRow',{
			index: Index,
			row:row
		});
	}
	function endEditing(){
		if (editIndex == undefined){return true}
		if ($('#resultgrid').datagrid('validateRow', editIndex))
		{
			$('#resultgrid').datagrid('endEdit', editIndex);
			rowsvalue=mygrid.getRows()[editIndex];    //临时保存激活的可编辑行的row   
			return true;
		} 
		else
		{
			return false;
		}
	}
	function ClickFun(type){   //单击执行保存可编辑行
		if (endEditing()){
			if(rowsvalue!= undefined){
				if((rowsvalue.SPEEEXDr!="")){
					var differentflag="";
					if(oldrowsvalue!= undefined){
						var oldrowsvaluearr=JSON.parse(oldrowsvalue)
						if(oldrowsvaluearr.SPEERowId==""){
							differentflag=1
						}
						for(var params in rowsvalue){
							if(oldrowsvaluearr[params]!=rowsvalue[params]){
								differentflag=1
							}
						}
					}
					else{
						differentflag=1
					}
					if(differentflag==1){
						preeditIndex=editIndex
						SaveData (rowsvalue,type);
					}
					else{
						UpdataRow(rowsvalue,editIndex)
						editIndex=undefined
						rowsvalue=undefined
					}
				}
				else{
					$.messager.alert('错误提示','检查结果不能为空！','error')
					$('.messager-window').click(stopPropagation)
					$('#resultgrid').datagrid('selectRow', editIndex)
						.datagrid('beginEdit', editIndex);
					//AppendDom()
					return 0
				}
			}
		}
	}
	function DblClickFun (index,row,field){   //双击激活可编辑   （可精简）
		if(index==editIndex){
			return
		}
		if((row!=undefined)&&(row.SPEERowId!=undefined)){
			UpdataRow(row,index)
		}
		preeditIndex=editIndex
		if (editIndex != index){
			if (endEditing()){
				$('#resultgrid').datagrid('selectRow', index)
						.datagrid('beginEdit', index);
				editIndex = index;
			} else {
				$('#resultgrid').datagrid('selectRow', editIndex);
			}
		}
		oldrowsvalue=JSON.stringify(row);   //用于和rowvalue比较 以判断是否行值发生改变
		//AppendDom(field)
	}
	function AddData(){
		preeditIndex=editIndex;
		if(ClickFun('AddData')==0){
			return
		}			
		//ClickFun('AddData')
		if (endEditing()){
			$('#resultgrid').datagrid('insertRow',{index:0,row:{SPEEPODr:parref}});
			editIndex = 0;//$('#mygrid').datagrid('getRows').length-1;
			$('#resultgrid').datagrid('selectRow', editIndex)
					.datagrid('beginEdit', editIndex);
		}
		$('.eaitor-label span').each(function(){	                    
            $(this).unbind('click').click(function(){
                if($(this).prev()._propAttr('checked')){
                    $(target).combobox('unselect',$(this).attr('value'));

                }
                else{
	                $(target).combobox('select',$(this).attr('value'));
	            }
            })
        });
        //AppendDom()
	}
	function DelData(){
		var record=mygrid.getSelected();
		if(!record){
			$.messager.alert('提示','请选择一条记录！','error');
			return;
		}
		//console.log(mygrid.getSelected())
		if((record.SPEERowId==undefined)||(record.SPEERowId=="")){
			mygrid.deleteRow(editIndex)
			$('#resultgrid').datagrid('reload');
			$('#resultgrid').datagrid('unselectAll');
			editIndex = undefined;
			rowsvalue=undefined;
			return;
		}
		$.messager.confirm('确认','您要删除这条数据吗?',function(r){
			if(r){
				id=record.SPEERowId;
				$.ajax({
					url:DELETE_ACTION_URL,
					data:{"id":id},
					type:'POST',
					success:function(data){
						var data=eval('('+data+')');
						if(data.success=='true'){
							/*$.messager.show({
								title:'提示信息',
								msg:'删除成功',
								showType:'show',
								timeout:1000,
								style:{
									right:'',
									bottom:''
								}
							});*/
							$.messager.popover({msg: '删除成功！',type:'success',timeout: 1000});
							$('#resultgrid').datagrid('reload');
							$('#resultgrid').datagrid('unselectAll');
							editIndex = undefined;
							rowsvalue=undefined;
						}
						else{
							var errorMsg="删除失败！";
							if(data.info){
								errorMsg=errorMsg+'</br>错误信息:'+data.info
							}
							$.messager.alert('错误提示',errorMsg,'error')
						}
					}
				});
			}
		});
	}
	function SaveFunLib (){
		var ed = $('#resultgrid').datagrid('getEditors',editIndex); 
		if(ed!=""){
			preeditIndex=editIndex;
			if (endEditing()){
				var record=mygrid.getSelected();
				//console.log(record)	  
				//return
				SaveData(record);
			}
		}
		else{
			$.messager.alert('警告','请双击选择一条数据！','warning')
		}
	}
	function SaveData (record,type){
		$.ajax({
		    type: 'post',
		    url: SAVE_ACTION_URL,
		    data: record,
		    success: function (data) { //返回json结果
		        var data=eval('('+data+')');
		        if(data.success=='true'){   
				    /*$.messager.show({
						title:'提示信息',
						msg:'保存成功',
						showType:'show',
						timeout:1000,
						style:{
							right:'',
							bottom:''
						}
					});*/
					$.messager.popover({msg: '保存成功！',type:'success',timeout: 1000});
					
				    if(type=='AddData'){
				        preeditIndex=preeditIndex+1;
				    }
				    record.SPEERowId=data.id
					UpdataRow(record,preeditIndex)
					if(type!='AddData'){
						editIndex=undefined
						rowsvalue=undefined
					}

		        }
		        else{
		        	if(type=='AddData'){
				       mygrid.deleteRow(1)
				    }
		          	var errorMsg="修改失败！";
		          	if(data.errorinfo){
		            	errorMsg=errorMsg+'</br>错误信息:'+data.errorinfo
		          	}
		          	$.messager.alert('错误提示',errorMsg,'error',function(){
						UpdataRow(record,preeditIndex)
			       		editIndex=undefined
			       		DblClickFun (preeditIndex,record);
			        })
			        $('.messager-window').click(stopPropagation) 
		       }
		    }
		});
	}	    		    					
    /*
    	//添加时检验结果下拉框
	$('#SPEEEXDr').combobox({
        url:$URL+"?ClassName=web.DHCBL.KB.DHCExamineFeild&QueryName=GetNewDataForCmb1&ResultSetType=array",
        valueField:'ExaRowId',
        textField:'ExaResult',
        mode:'remote'
    });
    delData=function()
    {
 		var row = $("#resultgrid").datagrid("getSelected"); 
		if (!(row))
		{	$.messager.alert('错误提示','请先选择一条记录!',"error");
			return;
		}
		var rowid=row.SPEERowId;
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
								 $('#resultgrid').datagrid('reload');  // 重新载入当前页面数据 
								 $('#resultgrid').datagrid('unselectAll');  // 清空列表选中数据 
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
			}]
		});
		$('#form-save').form("clear");
		$HUI.checkbox("#SPEEActiveFlag").setValue(true);
		$HUI.checkbox("#SPEESysFlag").setValue(true);			
    } 
    saveFunLib=function(id,flagT)
    {
		//var desc=$.trim($("#PHLFDesc").val());
		var ids=$('#SPEEEXDr').combobox('getValue')	
		if (ids=="")
		{
			$.messager.alert('错误提示','既往史不能为空!',"error");
			return;
		}

		$('#SPEEPODr').val(parref);
		$('#form-save').form('submit', {
			url:SAVE_ACTION_URL,
			onSubmit: function(param){
                param.SPEERowId = id;
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
				$('#resultgrid').datagrid('reload');  // 重新载入当前页面数据 
				if(flagT==1)
				{
					$('#myWin').dialog('close'); // close a dialog
				}
				else
				{
					$('#form-save').form("clear");
					$HUI.checkbox("#SPEEActiveFlag").setValue(true);
					$HUI.checkbox("#SPEESysFlag").setValue(true);					
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
   	updateData=function()
	{
		var record = mygrid.getSelected(); 
		if(record)
		{
			var id=record.SPEERowId;
			$.cm({
				ClassName:"web.DHCBL.KB.DHCSpecialPopuExa",
				MethodName:"NewOpenData",
				id:id
			},function(jsonData){
				if (jsonData.SPEEActiveFlag=="Y"){
					$HUI.checkbox("#SPEEActiveFlag").setValue(true);		
				}else{
					$HUI.checkbox("#SPEEActiveFlag").setValue(false);
				}
				if(jsonData.SPEESysFlag=="Y"){
					$HUI.checkbox('#SPEESysFlag').setValue(true);
				}else{
					$HUI.checkbox('#SPEESysFlag').setValue(false);
				}				
				//alert(jsonData.PHLFIGenDr)
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
				}]
			});							
		}else{
			$.messager.alert('错误提示','请先选择一条记录!',"error");
		}
	}*/  
};
$(init);