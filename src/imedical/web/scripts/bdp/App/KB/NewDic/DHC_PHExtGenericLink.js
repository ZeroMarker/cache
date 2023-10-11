/// 名称: 药品通用名和剂型关联
/// 描述: 包含增删改查、维护成分功能
/// 编写者: 基础数据平台组-丁亚男
/// 编写日期: 2018-07-24

var init = function(){
	
	var SAVE_ACTION_URL = "../csp/dhc.bdp.ext.entitydatatrans.csp?pClassName=web.DHCBL.KB.DHCGenLinkPointer&pClassMethod=SaveData&pEntityName=web.Entity.KB.DHCGenLinkPointer";
	var DELETE_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.KB.DHCGenLinkPointer&pClassMethod=DeleteData";
	
	//剂型查询下拉框
	$('#GlPPointer').combobox({ 
		url:$URL+"?ClassName=web.DHCBL.KB.DHCPHExtForm&QueryName=GetDataForCmb1&ResultSetType=array",
		valueField:'PHEFRowId',
		textField:'PHEFDesc'
	});
	 //查询方法
	SearchFunLib=function (){
		var pointer=$.trim($('#GlPPointer').combobox('getValue'));
		$('#mygrid').datagrid('load',  { 
			ClassName:"web.DHCBL.KB.DHCGenLinkPointer",
			QueryName:"GetNewList",
			'gen':selectrow,
			'pointer':pointer
		});
		$('#mygrid').datagrid('unselectAll');
		editIndex = undefined;
		rowsvalue=undefined;		
	}
	
	//重置方法
	ClearFunLib=function ()
	{
		$('#GlPPointer').combobox('setValue', '');
		$('#mygrid').datagrid('load',  { 
			ClassName:"web.DHCBL.KB.DHCGenLinkPointer",
			QueryName:"GetNewList",
			gen:selectrow
		});
		$('#mygrid').datagrid('unselectAll');
		editIndex = undefined;
		rowsvalue=undefined;		
	}
	/*
	//删除按钮
	$("#btnDel").click(function (e) { 

			Datagrid_DelData('mygrid',DELETE_ACTION_URL);
	 }) 
	//剂型下拉框（添加弹框）
	$('#GlPPointerF').combobox({ 
		url:$URL+"?ClassName=web.DHCBL.KB.DHCPHExtForm&QueryName=GetDataForCmb1&ResultSetType=array",
		valueField:'PHEFRowId',
		textField:'PHEFDesc'
	});
	//剂型下拉框（修改弹框）
	$('#GlPPointerFU').combobox({ 
		url:$URL+"?ClassName=web.DHCBL.KB.DHCPHExtForm&QueryName=GetDataForCmb1&ResultSetType=array",
		valueField:'PHEFRowId',
		textField:'PHEFDesc'
	});	
	///添加
	SaveFunLib=function(id)
	{		
		if (($('#GlPPointerF').combobox('getValue')==undefined)&&($('#GlPPointerF').combobox('getText')!=""))
		{
			$.messager.alert('错误提示','剂型不能为空!',"error");
			return;
		}
		
		$('#form-save').form('submit', { 
			url: SAVE_ACTION_URL,
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
						$('#myWin').dialog('close'); // close a dialog
				  } 
				  else { 
						var errorMsg ="提交失败！"
						if (data.errorinfo) {
							errorMsg =errorMsg+ '<br/>错误信息:' + data.errorinfo
						}
						$.messager.alert('操作提示',errorMsg,"error");
		
				}

			} 
		});
		

	}
	
	///继续添加
	TAddFunLib=function(id)
	{		
		if (($('#GlPPointerF').combobox('getValue')==undefined)&&($('#GlPPointerF').combobox('getText')!=""))
		{
			$.messager.alert('错误提示','剂型不能为空!',"error");
			return;
		}
		$('#form-save').form('submit', { 
			url: SAVE_ACTION_URL,
			success: function (data) { 
				  var data=eval('('+data+')'); 
				  if (data.success == 'true') {
				  		$('#form-save').form("clear");
				  		$('#GlPGenDrF').val(selectrow);
				  		$HUI.checkbox("#GlPActiveFlagF").setValue(true);
				  		$HUI.checkbox("#GlPSysFlagF").setValue(true);
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
				  } 
				  else { 
						var errorMsg ="提交失败！"
						if (data.errorinfo) {
							errorMsg =errorMsg+ '<br/>错误信息:' + data.errorinfo
						}
						$.messager.alert('操作提示',errorMsg,"error");
		
				}

			} 
		});
		

	}
	
	//点击添加按钮
	AddData=function () 
	{
		$('#GlPPointerF').combobox('reload');
		$("#myWin").show();
		var myWin = $HUI.dialog("#myWin",{
			iconCls:'icon-addlittle',
			resizable:true,
			title:'添加',
			modal:true,
			buttonAlign : 'center',
			buttons:[{
				text:'保存',
				//iconCls:'icon-save',
				id:'save_btn',
				handler:function(){
					SaveFunLib("")
				}
			},{
				text:'继续添加',
				//iconCls:'icon-cancel',
				handler:function(){
					TAddFunLib("")
				}
			},{
				text:'关闭',
				//iconCls:'icon-cancel',
				handler:function(){
					myWin.close();
				}
			}]
		});	
		$('#form-save').form("clear");
		$('#GlPGenDrF').val(selectrow);
		$HUI.checkbox("#GlPActiveFlagF").setValue(true);
		$HUI.checkbox("#GlPSysFlagF").setValue(true);
	}
	///修改
	SaveFunLibUpdate=function(id)
	{		
		if (($('#GlPPointerFU').combobox('getValue')==undefined)&&($('#GlPPointerFU').combobox('getText')!=""))
		{
			$.messager.alert('错误提示','剂型不能为空!',"error");
			return;
		}
		$('#form-save-Update').form('submit', { 
			url: SAVE_ACTION_URL, 
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
						$('#myWinUpdate').dialog('close'); // close a dialog
				  } 
				  else { 
						var errorMsg ="提交失败！"
						if (data.errorinfo) {
							errorMsg =errorMsg+ '<br/>错误信息:' + data.errorinfo
						}
						$.messager.alert('操作提示',errorMsg,"error");
		
				}

			} 
		});
		

	}
	//点击修改按钮
	UpdateData=function () 
	{
		$('#GlPPointerFU').combobox('reload');
		var record = $("#mygrid").datagrid("getSelected"); 
		if (!(record))
		{	
			$.messager.alert('错误提示','请先选择一条记录!',"error");
			return;
		}
		$.cm({
			ClassName:"web.DHCBL.KB.DHCGenLinkPointer",
			MethodName:"NewOpenData",
			id: record.GlPRowId      ///rowid
		},function(jsonData){
			if (jsonData.GlPActiveFlag=="Y"){
				$HUI.checkbox("#GlPActiveFlagFU").setValue(true);		
			}else{
				$HUI.checkbox("#GlPActiveFlagFU").setValue(false);
			}
			if (jsonData.GlPSysFlag=="Y"){
				$HUI.checkbox("#GlPSysFlagFU").setValue(true);		
			}else{
				$HUI.checkbox("#GlPSysFlagFU").setValue(false);
			}
			
			$('#form-save-Update').form("load",jsonData);	
			$("#myWinUpdate").show(); 
			var myWinUpdate = $HUI.dialog("#myWinUpdate",{
				iconCls:'icon-updatelittle',
				resizable:true,
				title:'修改',
				modal:true,
				buttons:[{
					text:'保存',
					//iconCls:'icon-save',
					id:'save_btn_update',
					handler:function(){
						SaveFunLibUpdate(record.GlPRowId)
					}
				},{
					text:'关闭',
					//iconCls:'icon-cancel',
					handler:function(){
						myWinUpdate.close();
					}
				}]
			});
		});
		
	}
	*/
	var editIndex = undefined;
	var rowsvalue=undefined;
	var oldrowsvalue=undefined;	 
	var columns =[[  
				  {field:'GlPRowId',title:'GlPRowId',width:80,sortable:true,editor:'validatebox',hidden:true},
				  {field:'PHEGDesc',title:'药品通用名',width:150,sortable:true,
				  		formatter:function(value,row,index)
				  		{
				  			return selectrowDesc;
				  		}
				  },
				  {field:'GlPGenDr',title:'通用名ID',width:150,sortable:true,hidden:true,editor:'validatebox',hidden:true},
				  {field:'GlPPointer',title:'剂型',width:150,sortable:true,editor:{
					  	type:'combobox',
					  	options:{
							url:$URL+"?ClassName=web.DHCBL.KB.DHCPHExtForm&QueryName=GetDataForCmb1&ResultSetType=array",
							//multiple:true,
							//panelHeight: 'auto',
							valueField:'PHEFRowId',
							textField:'PHEFDesc',
							onHidePanel:function(){
					            //var opts = $(this).combobox('options');
					        	var val=$(this).combobox('getText');
					        	var ed = $('#mygrid').datagrid('getEditor', {index:editIndex,field:'GlPPointerF'});
								$(ed.target).val(val)
					        }
						}
					}
				  },
				  {field:'GlPPointerF',title:'剂型多选框F',width:150,sortable:true,editor:'validatebox',hidden:true},
				  {field:'GlPActiveFlag',title:'是否可用',width:150,sortable:true,align:'center',editor:{
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
						        	var ed = $('#mygrid').datagrid('getEditor', {index:editIndex,field:'GlPActiveFlagF'});
									$(ed.target).val(val)
						        }					
							} 
			    		},
				  	formatter:ReturnFlagIcon
				  },
				  {field:'GlPActiveFlagF',title:'是否可用F',width:150,sortable:true,editor:'validatebox',hidden:true},
				  {field:'GlPSysFlag',title:'是否系统标识',width:150,sortable:true,align:'center',editor:{
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
						        	var ed = $('#mygrid').datagrid('getEditor', {index:editIndex,field:'GlPSysFlagF'});
									$(ed.target).val(val)
						        }					
							} 
			    		},
				  	formatter:ReturnFlagIcon
				  },
				  {field:'GlPSysFlagF',title:'是否系统标识F',width:150,sortable:true,editor:'validatebox',hidden:true}
	 ]];
	 
	 
	var mygrid = $HUI.datagrid("#mygrid",{
		url:$URL,
		queryParams:{
			ClassName:"web.DHCBL.KB.DHCGenLinkPointer",         ///调用Query时
			QueryName:"GetNewList",
			gen:selectrow
		},
		ClassTableName:'User.DHCGenLinkPointer',
		SQLTableName:'DHC_GenLinkPointer',
		idField:'GlPRowId',
		columns: columns,  //列信息
		pagination: true,   //pagination	boolean	设置为 true，则在数据网格（datagrid）底部显示分页工具栏。
		pageSize:PageSizePop,
		pageList:[5,10,15,20,25,30,50,75,100,200,300,500,1000], 
		singleSelect:true,
		rownumbers:true,    //设置为 true，则显示带有行号的列。
		fixRowNumber:true,
		fitColumns:true, //设置为 true，则会自动扩大或缩小列的尺寸以适应网格的宽度并且防止水平滚动
		remoteSort:false,  //定义是否从服务器排序数据。true
        onDblClickRow:function(index,row)
        {
        	//updateData();
        },
        onLoadSuccess:function(data){
			$(this).prev().find('div.datagrid-body').prop('scrollTop',0);
        },	
        onClickRow:function(rowIndex,rowData){
			$('#mygrid').datagrid('selectRow', rowIndex);
			ClickFun();
	    },
        onDblClickCell:function(rowIndex, field, value){
	        var rowData=$('#mygrid').datagrid('getSelected');
			DblClickFun(rowIndex,rowData,field);
	    }
	});
	//ShowUserHabit('mygrid');
   $('#add_btn').click(function(e){
    	AddData();
    });
    //点击修改按钮
    $('#update_btn').click(function(e){
    	var ed = $('#mygrid').datagrid('getEditors',editIndex); 
		if(ed!=""){
			 if (ClickFun()==0)
    		{
    			return
    		}
		}
		else{
			$.messager.alert('警告','请双击选择一条数据！','warning')
		}
  
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
		temp=row.GlPPointer;
		row.GlPPointer=row.GlPPointerF;
		row.GlPPointerF=temp;

		temp=row.GlPActiveFlag;
		row.GlPActiveFlag=row.GlPActiveFlagF;
		row.GlPActiveFlag=temp;

		temp=row.GlPSysFlag;
		row.GlPSysFlag=row.GlPSysFlagF;
		row.GlPSysFlag=temp;
		$('#mygrid').datagrid('updateRow',{
			index: Index,
			row:row
		});
	}
	function endEditing(){
		if (editIndex == undefined){return true}
		if ($('#mygrid').datagrid('validateRow', editIndex))
		{
			$('#mygrid').datagrid('endEdit', editIndex);
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
				if((rowsvalue.GlPPointer!="")){
					var differentflag="";
					if(oldrowsvalue!= undefined){
						var oldrowsvaluearr=JSON.parse(oldrowsvalue)
						if(oldrowsvaluearr.GlPRowId==""){
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
					$.messager.alert('错误提示','剂型不能为空！','error')
					$('.messager-window').click(stopPropagation)
					$('#mygrid').datagrid('selectRow', editIndex)
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
		if((row!=undefined)&&(row.GlPRowId!=undefined)){
			UpdataRow(row,index)
		}
		preeditIndex=editIndex
		if (editIndex != index){
			if (endEditing()){
				$('#mygrid').datagrid('selectRow', index)
						.datagrid('beginEdit', index);
				editIndex = index;
			} else {
				$('#mygrid').datagrid('selectRow', editIndex);
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
			$('#mygrid').datagrid('insertRow',{index:0,row:{GlPGenDr:selectrow}});
			editIndex = 0;//$('#mygrid').datagrid('getRows').length-1;
			$('#mygrid').datagrid('selectRow', editIndex)
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
		if((record.GlPRowId==undefined)||(record.GlPRowId=="")){
			mygrid.deleteRow(editIndex)
			$('#mygrid').datagrid('reload');
			$('#mygrid').datagrid('unselectAll');
			editIndex = undefined;
			rowsvalue=undefined;
			return;
		}
		$.messager.confirm('确认','您要删除这条数据吗?',function(r){
			if(r){
				id=record.GlPRowId;
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
							$('#mygrid').datagrid('reload');
							$('#mygrid').datagrid('unselectAll');
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
		var ed = $('#mygrid').datagrid('getEditors',editIndex); 
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
				    record.GlPRowId=data.id
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
};
$(init);


 

