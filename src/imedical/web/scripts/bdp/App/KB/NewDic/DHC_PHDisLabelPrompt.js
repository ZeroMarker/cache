/*
* @Author: 基础数据平台-石萧伟
* @Date:   2018-08-16 15:41:35
* @Last Modified by:   admin
* @Last Modified time: 2018-11-14 09:51:30
* @描述:推导目录提示表
*/
var SAVE_ACTION_URL =  "../csp/dhc.bdp.ext.entitydatatrans.csp?pClassName=web.DHCBL.KB.DHCPHDisLabelPrompt&pClassMethod=SaveData&pEntityName=web.Entity.KB.DHCPHDisLabelPrompt";
var DELETE_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.KB.DHCPHDisLabelPrompt&pClassMethod=DeleteData";
var editIndex = undefined;
var rowsvalue=undefined;
var oldrowsvalue=undefined;
var preeditIndex="";
var init = function(){
	var columns =[[
        {field:'PDPLastId',title:'诊断逻辑推导目录Id',sortable:true,width:100,hidden:true,editor:'validatebox'},
        {field:'PDPLabelDrFF',title:'关联目录FF',sortable:true,width:100,hidden:true,editor:'validatebox'},
        {field:'PDPLabelDr',title:'关联目录',sortable:true,width:100,editor:{
		  	type:'combobox',
			options:{
				valueField:'PGLRowId',
				textField:'PGLDesc',
				//panelHeight: 'auto',
				url:$URL+"?ClassName=web.DHCBL.KB.DHCPHGuideLabel&QueryName=GetDataForCmb1&ResultSetType=array",
	            onHidePanel:function(){
		        	var val=$(this).combobox('getText');
		        	var ed = $('#Promptgrid').datagrid('getEditor', {index:editIndex,field:'PDPLabelDrF'});
					$(ed.target).val(val)
		        },
		        onSelect:function(record){
		        	var labeldrff=record.PGLRowId
		        	var ed=$("#Promptgrid").datagrid('getEditor',{index:editIndex,field:'PDPLabelDrFF'})
		        	var labeldr=$(ed.target).val(labeldrff)	

		        	var eb=$("#Promptgrid").datagrid('getEditor',{index:editIndex,field:'PDPPrompt'})  
		        	var pdgid=$(eb.target).combobox("setValue","") 	        	
		        }						
			}
        }},
        {field:'PDPLabelDrF',title:'关联目录F',sortable:true,width:100,hidden:true,editor:'validatebox'},
        {field:'PDPPrompt',title:'关联项目',sortable:true,width:100,editor:{
		  	type:'combobox',
			options:{
				valueField:'RowId',
				textField:'Desc',
				//panelHeight: 'auto',
				url:$URL+"?ClassName=web.DHCBL.KB.DHCPHDiseaseGuide&QueryName=GetIDDataForCmb&ResultSetType=array",
	            onHidePanel:function(){
		        	var val=$(this).combobox('getText');
		        	var ed = $('#Promptgrid').datagrid('getEditor', {index:editIndex,field:'PDPPromptF'});
					$(ed.target).val(val)
		        },
		        onShowPanel:function(){
		        	var ed=$("#Promptgrid").datagrid('getEditor',{index:editIndex,field:'PDPLabelDrFF'})
		        	var labeldr=$(ed.target).val()
		        	//PDPPrompt$(this).combobox('reload',$URL+"?ClassName=web.DHCBL.KB.DHCPHDiseaseGuide&QueryName=GetIDDataForCmb&ResultSetType=array&labeldr="+labeldr)
		        }						
			}
        }
    	},
        {field:'PDPPromptF',title:'关联项目F',sortable:true,width:100,editor:'validatebox',hidden:true},
        {field:'PDPPromptVal',title:'结果',sortable:true,width:100,editor:'validatebox'},
        {field:'PDPSysFlag',title:'是否系统标识',sortable:true,width:100,editor:{
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
				        	var ed = $('#Promptgrid').datagrid('getEditor', {index:editIndex,field:'PDPSysFlagF'});
							$(ed.target).val(val)
				        }					
					} 
	    		},
                formatter:ReturnFlagIcon
        }, 
        {field:'PDPSysFlagF',title:'是否系统标识F',sortable:true,width:100,editor:'validatebox',hidden:true},       
        {field:'PDPRowId',title:'rowid',sortable:true,width:100,hidden:true}
    ]];
    var mygrid = $HUI.datagrid("#Promptgrid",{
        url:$URL,
        queryParams:{
            ClassName:"web.DHCBL.KB.DHCPHDisLabelPrompt",
            QueryName:"GetNewList",
            lastid:parref
        },
        columns: columns,  //列信息
        pagination: true,   //pagination	boolean	设置为 true，则在数据网格（datagrid）底部显示分页工具栏。
        pageSize:PageSizePop,
        pageList:[5,10,15,20,25,30,50,75,100,200,300,500,1000],
        singleSelect:true,
        remoteSort:false,
        //ClassTableName:'User.DHCLabItmResult',
		//SQLTableName:'DHC_LabItmResult',
        idField:'PDPRowId',
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
			$('#Promptgrid').datagrid('selectRow', rowIndex);
			ClickFun();
	    },
        onDblClickCell:function(rowIndex, field, value){
	        var rowData=$('#Promptgrid').datagrid('getSelected');
			DblClickFun(rowIndex,rowData,field);
	    }
    });   
	//搜索是关联目录下拉框
	$('#PromptId').combobox({
        url:$URL+"?ClassName=web.DHCBL.KB.DHCPHGuideLabel&QueryName=GetDataForCmb1&ResultSetType=array",
        valueField:'PGLRowId',
        textField:'PGLDesc'
        //mode:'remote', 
    });
    //点击搜索按钮
    $('#btn_search').click(function(e){
    	var labeldr=$('#PromptId').combobox('getValue');
    	$('#Promptgrid').datagrid('load',  { 
            ClassName:"web.DHCBL.KB.DHCPHDisLabelPrompt",
            QueryName:"GetNewList",
			lastid:parref,
			labeldr:labeldr
        });
        $('#Promptgrid').datagrid('unselectAll');
		editIndex = undefined;
		rowsvalue=undefined;             
    });
    //点击重置按钮
    $('#btnRefresh').click(function(e){
		$("#PromptId").combobox('setValue','');//清空检索框
        $('#Promptgrid').datagrid('load',  { 
            ClassName:"web.DHCBL.KB.DHCPHDisLabelPrompt",
            QueryName:"GetNewList",
            lastid:parref
        });
		$('#Promptgrid').datagrid('unselectAll');
		editIndex = undefined;
		rowsvalue=undefined;     		
    });
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
		temp=row.PDPLabelDr;
		row.PDPLabelDr=row.PDPLabelDrF;
		row.PDPLabelDrF=temp;

		temp=row.PDPPrompt;
		row.PDPPrompt=row.PDPPromptF;
		row.PDPPromptF=temp;

		temp=row.PDPSysFlag;
		row.PDPSysFlag=row.PDPSysFlagF;
		row.PDPSysFlag=temp;
			
		$('#Promptgrid').datagrid('updateRow',{
			index: Index,
			row:row
		});
	}
	function endEditing(){
		if (editIndex == undefined){return true}
		if ($('#Promptgrid').datagrid('validateRow', editIndex))
		{
			$('#Promptgrid').datagrid('endEdit', editIndex);
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
				if((rowsvalue.PDPLabelDr!="") && (rowsvalue.PDPPrompt!="")){
					var differentflag="";
					if(oldrowsvalue!= undefined){
						var oldrowsvaluearr=JSON.parse(oldrowsvalue)
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
					$.messager.alert('错误提示','关联项目和关联目录不能为空！','error')
					$('.messager-window').click(stopPropagation)
					$('#Promptgrid').datagrid('selectRow', editIndex)
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
		if((row!=undefined)&&(row.PDPRowId!=undefined)){
			UpdataRow(row,index)
		}
		preeditIndex=editIndex
		if (editIndex != index){
			if (endEditing()){
				$('#Promptgrid').datagrid('selectRow', index)
						.datagrid('beginEdit', index);
				editIndex = index;
			} else {
				$('#Promptgrid').datagrid('selectRow', editIndex);
			}

			//加载下拉框
        	var ed=$("#Promptgrid").datagrid('getEditor',{index:editIndex,field:'PDPLabelDrFF'})
        	var labeldr=$(ed.target).val()
        	var edi=$("#Promptgrid").datagrid('getEditor',{index:editIndex,field:'PDPPrompt'})
        	$(edi.target).combobox('reload',$URL+"?ClassName=web.DHCBL.KB.DHCPHDiseaseGuide&QueryName=GetIDDataForCmb&ResultSetType=array&labeldr="+labeldr)			
		}
		oldrowsvalue=JSON.stringify(row);   //用于和rowvalue比较 以判断是否行值发生改变
		//AppendDom(field)
	}
	function AddData(){
		preeditIndex=editIndex;
		if(ClickFun('AddData')==0){
			return
		}			
		ClickFun('AddData')
		if (endEditing()){
			$('#Promptgrid').datagrid('insertRow',{index:0,row:{PDPLastId:parref}});
			editIndex = 0;//$('#mygrid').datagrid('getRows').length-1;
			$('#Promptgrid').datagrid('selectRow', editIndex)
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
		if((record.PDPRowId==undefined)||(record.PDPRowId=="")){
			mygrid.deleteRow(editIndex)
			$('#Promptgrid').datagrid('reload');
			$('#Promptgrid').datagrid('unselectAll');
			editIndex = undefined;
			rowsvalue=undefined;
			return;
		}
		$.messager.confirm('确认','您要删除这条数据吗?',function(r){
			if(r){
				id=record.PDPRowId;
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
							$('#Promptgrid').datagrid('reload');
							$('#Promptgrid').datagrid('unselectAll');
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
		var ed = $('#Promptgrid').datagrid('getEditors',editIndex); 
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
				    record.PDPRowId=data.id
					UpdataRow(record,preeditIndex)
					if(type!='AddData'){
						editIndex=undefined
						rowsvalue=undefined
					}

		        }
		        else{
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
	//添加关联目录下拉框
	$('#PDPPrompt').combobox({
        url:$URL+"?ClassName=web.DHCBL.KB.DHCPHGuideLabel&QueryName=GetIDDataForCmb&ResultSetType=array",
        valueField:'RowId',
        textField:'Desc'
    }); 
	//添加关联项目下拉框
	$('#PDPLabelDr').combobox({
        url:$URL+"?ClassName=web.DHCBL.KB.DHCPHGuideLabel&QueryName=GetDataForCmb1&ResultSetType=array",
        valueField:'PGLRowId',
        textField:'PGLDesc',
        onSelect:function(record)
        {
        	var id=record.PGLRowId;
        	$('#PDPPrompt').combobox('clear');
        	$('#PDPPrompt').combobox('reload',$URL+"?ClassName=web.DHCBL.KB.DHCPHDiseaseGuide&QueryName=GetIDDataForCmb&ResultSetType=array&labeldr="+id);
        }
    });      
    //点击搜索按钮
    $('#btn_search').click(function(e){
    	var labeldr=$('#PromptId').combobox('getValue');
    	$('#Promptgrid').datagrid('load',  { 
            ClassName:"web.DHCBL.KB.DHCPHDisLabelPrompt",
            QueryName:"GetList",
			lastid:parref,
			labeldr:labeldr
        });
        $('#Promptgrid').datagrid('unselectAll');
    });
    //点击重置按钮
    $('#btnRefresh').click(function(e){
		$("#PromptId").combobox('setValue','');//清空检索框
        $('#Promptgrid').datagrid('load',  { 
            ClassName:"web.DHCBL.KB.DHCPHDisLabelPrompt",
            QueryName:"GetList",
            lastid:parref
        });
		$('#Promptgrid').datagrid('unselectAll');
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
 		var row = $("#Promptgrid").datagrid("getSelected"); 
		if (!(row))
		{	$.messager.alert('错误提示','请先选择一条记录!',"error");
			return;
		}
		var rowid=row.PDPRowId;
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
								 $('#Promptgrid').datagrid('reload');  // 重新载入当前页面数据 
								 $('#Promptgrid').datagrid('unselectAll');  // 清空列表选中数据 
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
				text:'继续新增',
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
		$HUI.checkbox("#PDPSysFlag").setValue(true);		
    } 
    saveFunLib=function(id,flagT)
    {
		//var desc=$.trim($("#PHLFDesc").val());
		var id1=$('#PDPLabelDr').combobox('getValue')	
		if (id1=="")
		{
			$.messager.alert('错误提示','关联目录不能为空!',"error");
			return;
		}
		var id2=$('#PDPPrompt').combobox('getValue')	
		if (id2=="")
		{
			$.messager.alert('错误提示','关联项目不能为空!',"error");
			return;
		}
		$('#PDPLastId').val(parref);		
		$('#form-save').form('submit', {
			url:SAVE_ACTION_URL,
			onSubmit: function(param){
                param.PDPRowId = id;
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
				$('#Promptgrid').datagrid('reload');  // 重新载入当前页面数据 
				if(flagT==1)
				{
					$('#myWin').dialog('close'); // close a dialog
				}
				else
				{
					$('#form-save').form("clear");
					$HUI.checkbox("#PDPSysFlag").setValue(true);
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
		var record = listgrid.getSelected(); 
		if(record)
		{
			var id=record.PDPRowId;
			$.cm({
				ClassName:"web.DHCBL.KB.DHCPHDisLabelPrompt",
				MethodName:"NewOpenData",
				id:id
			},function(jsonData){
				//alert(jsonData.PDPLabelDr)
				if (jsonData.PDPSysFlag=="Y"){
					$HUI.checkbox("#PDPSysFlag").setValue(true);		
				}else{
					$HUI.checkbox("#PDPSysFlag").setValue(false);
				}					
				$('#PDPPrompt').combobox('reload',$URL+"?ClassName=web.DHCBL.KB.DHCPHDiseaseGuide&QueryName=GetIDDataForCmb&ResultSetType=array&labeldr="+jsonData.PDPLabelDr);
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
	}
	*/  
};
$(init);