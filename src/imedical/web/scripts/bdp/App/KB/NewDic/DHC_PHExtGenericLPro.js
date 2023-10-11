﻿/// 名称: 通用名检验属性
/// 描述: 包含增删改查、维护成分功能
/// 编写者: 基础数据平台组-丁亚男
/// 编写日期: 2018-07-23

var init = function(){
	
	var SAVE_ACTION_URL = "../csp/dhc.bdp.ext.entitydatatrans.csp?pClassName=web.DHCBL.KB.DHCLisGenPro&pClassMethod=SaveData&pEntityName=web.Entity.KB.DHCLisGenPro";
	var DELETE_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.KB.DHCLisGenPro&pClassMethod=DeleteData";
	
	//标准码查询框
	$('#LGPStCode').keyup(function(event){
		if(event.keyCode == 13) {
		  SearchFunLib();
		}
		if(event.keyCode == 27) {
		  ClearFunLib();
		}
	    
	});
	 //查询方法
	SearchFunLib=function (){
		var gen=selectrow
		var code=$.trim($('#LGPStCode').val());
		$('#mygrid').datagrid('load',  { 
			ClassName:"web.DHCBL.KB.DHCLisGenPro",
			QueryName:"GetNewList",
			'gen':gen,
			'code':code
		});
		$('#mygrid').datagrid('unselectAll');
		editIndex = undefined;
		rowsvalue=undefined;
	}
	
	//重置方法
	ClearFunLib=function ()
	{
		$('#LGPGenDr').combobox('setValue', '');
		$("#LGPStCode").val("");
		$('#mygrid').datagrid('load',  { 
			ClassName:"web.DHCBL.KB.DHCLisGenPro",
			QueryName:"GetNewList",
			gen:selectrow
		});
		$('#mygrid').datagrid('unselectAll');
		editIndex = undefined;
		rowsvalue=undefined;		
	}
	/*	
	//通用名下拉框（添加弹框、隐藏）
	$('#LGPGenDrF').combobox({ 
		url:$URL+"?ClassName=web.DHCBL.KB.DHCPHExtGeneric&QueryName=GetDataForCmb1&ResultSetType=array&code=LAB",
		valueField:'PHEGRowId',
		textField:'PHEGDesc'
	});
	
	//分类/类型下拉框（添加弹框)
	$HUI.combotree('#LGPCatDrF',{
		url:"../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.KB.DHCBusMainNew&pClassMethod=GetTreeProComboJson&lib=LAB",
		panelWidth:255,
		panelHeight:200
		});	
	//删除按钮
	$("#btnDel").click(function (e) { 

			Datagrid_DelData('mygrid',DELETE_ACTION_URL);
	 }) 

	 //查询方法
	SearchFunLib=function (){
		var gen=selectrow
		var code=$.trim($('#LGPStCode').val());
		$('#mygrid').datagrid('load',  { 
			ClassName:"web.DHCBL.KB.DHCLisGenPro",
			QueryName:"GetList",
			'gen':gen,
			'code':code
		});
		$('#mygrid').datagrid('unselectAll');
	}
	
	//重置方法
	ClearFunLib=function ()
	{
		$('#LGPGenDr').combobox('setValue', '');
		$("#LGPStCode").val("");
		$('#mygrid').datagrid('load',  { 
			ClassName:"web.DHCBL.KB.DHCLisGenPro",
			QueryName:"GetList",
			gen:selectrow
		});
		$('#mygrid').datagrid('unselectAll');
	}
	
	///添加、修改
	SaveFunLib=function(id)
	{		
		if ($('#LGPStCodeF').val()=="")
		{
			$.messager.alert('错误提示','标准码不能为空!',"error");
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
		if ($('#LGPStCodeF').val()=="")
		{
			$.messager.alert('错误提示','标准码不能为空!',"error");
			return;
		}
		$('#form-save').form('submit', { 
			url: SAVE_ACTION_URL, 
			success: function (data) { 
				  var data=eval('('+data+')'); 
				  if (data.success == 'true') {
				  		$('#form-save').form("clear");
				  		$('#LGPGenDrF').val(selectrow);
				  		$HUI.checkbox("#LGPSysFlagF").setValue(true);
				  		$HUI.radio("#FlagTs").setValue(true);
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
		$('#LGPGenDrF').combobox('reload');
		$('#LGPCatDrF').combotree('reload');
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
		$('#LGPGenDrF').val(selectrow);
		$HUI.checkbox("#LGPSysFlagF").setValue(true);
		$HUI.radio("#FlagTs").setValue(true);
	}
	
	//点击修改按钮
	UpdateData=function () 
	{
		$('#LGPGenDrF').combobox('reload');
		$('#LGPCatDrF').combotree('reload');
		var record = $("#mygrid").datagrid("getSelected"); 
		if (!(record))
		{	
			$.messager.alert('错误提示','请先选择一条记录!',"error");
			return;
		}
		$.cm({
			ClassName:"web.DHCBL.KB.DHCLisGenPro",
			MethodName:"NewOpenData",
			id: record.LGPRowId      ///rowid
		},function(jsonData){
			if (jsonData.LGPSysFlag=="Y"){
				$HUI.checkbox("#LGPSysFlagF").setValue(true);		
			}else{
				$HUI.checkbox("#LGPSysFlagF").setValue(false);
			}
			var check = jsonData.LGPOTFlag; 
			$HUI.radio("#Flag"+check).setValue(true)
			$('#form-save').form("load",jsonData);	
			$("#myWin").show(); 
			var myWin = $HUI.dialog("#myWin",{
				iconCls:'icon-updatelittle',
				resizable:true,
				title:'修改',
				modal:true,
				buttons:[{
					text:'保存',
					//iconCls:'icon-save',
					id:'save_btn',
					handler:function(){
						SaveFunLib(record.LGPRowId)
					}
				},{
					text:'关闭',
					//iconCls:'icon-cancel',
					handler:function(){
						myWin.close();
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
				  {field:'LGPRowId',title:'LGPRowId',width:80,sortable:true,hidden:true,editor:'validatebox'},
				  {field:'PHEGDesc',title:'通用名',width:150,sortable:true,
				  		formatter:function(value,row,index)
				  		{
				  			return selectrowDesc;
				  		}
				  },
				  {field:'LGPGenDr',title:'通用名ID',width:150,sortable:true,hidden:true,editor:'validatebox'},
				  {field:'LGPStCode',title:'标准码',width:150,sortable:true,editor:'validatebox'},
				  {field:'LGPCatDr',title:'分类',width:150,sortable:true,editor:{
			 		  	type:'combotree',
						options:{
				        	url:"../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.KB.DHCBusMainNew&pClassMethod=GetTreeProComboJson&lib=LAB",
				            onHidePanel:function(){
				            	var target=$(this);
				            	setTimeout(function(){
						        	var val=target.combo('getText');
						        	var ed = $('#mygrid').datagrid('getEditor', {index:editIndex,field:'LGPCatDrF'});
									$(ed.target).val(val);
								},100)
								if($(this).combo('getText')==""){
									$(this).combo('setValue',"")
								}								
					        }					
						}       	
			        }
				  },
				  {field:'LGPCatDrF',title:'分类F',width:150,sortable:true,editor:'validatebox',hidden:true},
				  {field:'LGPOTFlag',title:'医嘱类型标识',width:150,sortable:true,editor:{
				 		  	type:'combobox',
							options:{
						        valueField:'id',
						        textField:'text',
						        data:[
						            {id:'TS',text:'检验套'},
						            {id:'TC',text:'检验项'}
						        ],
						        value:'TS',
					            onHidePanel:function(){
						        	var val=$(this).combobox('getText');
						        	var ed = $('#mygrid').datagrid('getEditor', {index:editIndex,field:'LGPOTFlagF'});
									$(ed.target).val(val)
						        }					
							} 
			    		},
					  formatter:function(v,row,index){  
							if(v=='TS'){return '检验套';}
							if(v=='TC'){return '检验项';}
						}},
				  {field:'LGPOTFlagF',title:'医嘱类型标识F',width:150,sortable:true,hidden:true,editor:'validatebox'},
				  {field:'LGPSysFlag',title:'是否系统标识',width:150,sortable:true,align:'center',editor:{
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
						        	var ed = $('#mygrid').datagrid('getEditor', {index:editIndex,field:'LGPSysFlagF'});
									$(ed.target).val(val)
						        }					
							} 
			    		},
				  	formatter:ReturnFlagIcon
				  },
				  {field:'LGPSysFlagF',title:'是否系统标识F',width:150,sortable:true,align:'center',hidden:true,editor:'validatebox'}
	 ]];
	 
	 
	var mygrid = $HUI.datagrid("#mygrid",{
		url:$URL,
		queryParams:{
			ClassName:"web.DHCBL.KB.DHCLisGenPro",         ///调用Query时
			QueryName:"GetNewList",
			gen:selectrow
		},
		ClassTableName:'User.DHCLisGenPro',
		SQLTableName:'DHC_LisGenPro',
		idField:'LGPRowId',
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
    //点击添加按钮
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
		temp=row.LGPCatDr;
		row.LGPCatDr=row.LGPCatDrF;
		row.LGPCatDrF=temp;

		temp=row.LGPOTFlag;
		row.LGPOTFlag=row.LGPOTFlagF;
		row.LGPOTFlag=temp;

		temp=row.LGPSysFlag;
		row.LGPSysFlag=row.LGPSysFlagF;
		row.LGPSysFlag=temp;
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
				if((rowsvalue.LGPStCode!="")){
					var differentflag="";
					if(oldrowsvalue!= undefined){
						var oldrowsvaluearr=JSON.parse(oldrowsvalue)
						if(oldrowsvaluearr.LGPRowId==""){
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
					$.messager.alert('错误提示','标准码不能为空！','error')
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
		if((row!=undefined)&&(row.LGPRowId!=undefined)){
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
			$('#mygrid').datagrid('insertRow',{index:0,row:{LGPGenDr:selectrow}});
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
		if((record.LGPRowId==undefined)||(record.LGPRowId=="")){
			mygrid.deleteRow(editIndex)
			$('#mygrid').datagrid('reload');
			$('#mygrid').datagrid('unselectAll');
			editIndex = undefined;
			rowsvalue=undefined;
			return;
		}
		$.messager.confirm('确认','您要删除这条数据吗?',function(r){
			if(r){
				id=record.LGPRowId;
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
				    record.LGPRowId=data.id
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


 

