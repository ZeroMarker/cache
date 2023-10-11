﻿/*
* @Author: 基础数据平台-石萧伟
* @Date:   2018-07-26 15:41:35
* @Last Modified by:   admin
* @Last Modified time: 2018-10-11 11:01:04
* @描述:诊断与症状关联表维护
*/
var SAVE_ACTION_URL = "../csp/dhc.bdp.ext.entitydatatrans.csp?pClassName=web.DHCBL.KB.DHCPHDisLinkSym&pClassMethod=SaveData&pEntityName=web.Entity.KB.DHCPHDisLinkSym";
var DELETE_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.KB.DHCPHDisLinkSym&pClassMethod=DeleteData";
var init=function()
{
	var editIndex = undefined;
	var rowsvalue=undefined;
	var oldrowsvalue=undefined;
	var preeditIndex="";
    var eastcolumns =[[
        {field:'LSYIcdDrF',title:'诊断',sortable:true,width:100,
            formatter: function(value,row,index){
           		return parrefDesc;
            } 
    	},
        {field:'LSYIcdDr',title:'诊断id',sortable:true,width:100,hidden:true,editor:'validatebox'},
        {field:'SYMRowId',title:'症状id',sortable:true,width:100,hidden:true,editor:'validatebox'},
        {field:'LSYSymDr',title:'症状',sortable:true,width:100,editor:{
 		  	type:'combobox',
			options:{
				valueField:'SYMRowId',
				textField:'SYMDesc',
	        	url:$URL+"?ClassName=web.DHCBL.KB.DHCPHSymptom&QueryName=GetList&ResultSetType=array",
	            onHidePanel:function(){
		        	var val=$(this).combobox('getText');
		        	var ed = $('#eastgrid').datagrid('getEditor', {index:editIndex,field:'SYMRowId'});
					$(ed.target).val(val)
		        }					
			} 
    	}},
        {field:'LSYRowId',title:'rowid',sortable:true,width:100,hidden:true,editor:'validatebox'}      
    ]];
    var eastgrid = $HUI.datagrid("#eastgrid",{
        url:$URL,
        queryParams:{
            ClassName:"web.DHCBL.KB.DHCPHDisLinkSym",
            QueryName:"GetNewList",
            parref:parref
        },
        columns: eastcolumns,  //列信息
        pagination: true,   //pagination	boolean	设置为 true，则在数据网格（datagrid）底部显示分页工具栏。
        pageSize:PageSizePop,
        pageList:[5,10,15,20,25,30,50,75,100,200,300,500,1000],
        singleSelect:true,
        //checkOnSelect:false,
        remoteSort:false,
        //ClassTableName:'User.DHCPHExtPart',
		//SQLTableName:'DHC_PHExtPart',
        idField:'LSYRowId',
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
			$('#eastgrid').datagrid('selectRow', rowIndex);
			clickListGrid();
			ClickFun();
	    },
        onDblClickCell:function(rowIndex, field, value){
	        var rowData=$('#eastgrid').datagrid('getSelected');
			DblClickFun(rowIndex,rowData,field);
	    }  	
    });
    clickListGrid=function()
    {
    	var record = eastgrid.getSelected(); 
    	if(record)
    	{
    		//var labeldr=record.PDLLabelDrID
    		//alert(record.PDLLabelDr+"^"+record.PDLRowId)
    		//alert(record.LSYRowId)
    		var url="../csp/dhc.bdp.kb.dhcphdislinksyml.csp"+"?parref1="+record.LSYRowId+"&parrefDesc1="+record.LSYSymDr+"&icdDesc="+parrefDesc;
		    //token改造 GXP 20230209
			if('undefined'!==typeof websys_getMWToken)
			{
				url+="&MWToken="+websys_getMWToken()
			}	
        	$('#my_iframe').attr("src",url);
    	}
    }    
    //点击搜索按钮
    /*$('#btn_search').click(function(e){
    	var dis=$('#TextDesc').combobox('getValue');
    	$('#eastgrid').datagrid('load',  { 
            ClassName:"web.DHCBL.KB.DHCPHDisLinkSym",
            QueryName:"GetList",
			parref:parref,
			dis:dis
        });
        $('#eastgrid').datagrid('unselectAll');
       	editIndex = undefined;
		rowsvalue=undefined;
    });
    //点击重置按钮
    $('#btnRefresh').click(function(e){
    	ClearFunLib();
    });  
    function ClearFunLib()
    {
		$("#disId").combobox('setValue','');//清空检索框
        $('#eastgrid').datagrid('load',  { 
            ClassName:"web.DHCBL.KB.DHCSpecialPopuDis",
            QueryName:"GetList",
            parref:parref,
        });
		$('#eastgrid').datagrid('unselectAll'); 
		editIndex = undefined;
		rowsvalue=undefined;   	
    }*/
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
		temp=row.LSYSymDr;
		row.LSYSymDr=row.SYMRowId;
		row.SYMRowId=temp;
		$('#eastgrid').datagrid('updateRow',{
			index: Index,
			row:row
		});
	}
	function endEditing(){
		if (editIndex == undefined){return true}
		if ($('#eastgrid').datagrid('validateRow', editIndex))
		{
			$('#eastgrid').datagrid('endEdit', editIndex);
			rowsvalue=eastgrid.getRows()[editIndex];    //临时保存激活的可编辑行的row   
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
				if((rowsvalue.LSYSymDr!="")){
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
					$.messager.alert('错误提示','病症不能为空！','error')
					$('.messager-window').click(stopPropagation)
					$('#eastgrid').datagrid('selectRow', editIndex)
						.datagrid('beginEdit', editIndex);
					//AppendDom()
					return
				}
			}
		}
	}
	function DblClickFun (index,row,field){   //双击激活可编辑   （可精简）
		if(index==editIndex){
			return
		}
		if((row!=undefined)&&(row.LSYRowId!=undefined)){
			UpdataRow(row,index)
		}
		preeditIndex=editIndex
		if (editIndex != index){
			if (endEditing()){
				$('#eastgrid').datagrid('selectRow', index)
						.datagrid('beginEdit', index);
				editIndex = index;
			} else {
				$('#eastgrid').datagrid('selectRow', editIndex);
			}
		}
		oldrowsvalue=JSON.stringify(row);   //用于和rowvalue比较 以判断是否行值发生改变
		//AppendDom(field)
	}
	function AddData(){
		preeditIndex=editIndex;
		ClickFun('AddData')
		if (endEditing()){
			$('#eastgrid').datagrid('insertRow',{index:0,row:{LSYIcdDr:parref}});
			editIndex = 0;//$('#eastgrid').datagrid('getRows').length-1;
			$('#eastgrid').datagrid('selectRow', editIndex)
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
		var record=eastgrid.getSelected();
		if(!record){
			$.messager.alert('提示','请选择一条记录！','error');
			return;
		}
		//console.log(eastgrid.getSelected())
		if((record.LSYRowId==undefined)||(record.LSYRowId=="")){
			eastgrid.deleteRow(editIndex)
			$('#eastgrid').datagrid('reload');
			$('#eastgrid').datagrid('unselectAll');
			editIndex = undefined;
			rowsvalue=undefined;
			return;
		}
		$.messager.confirm('确认','您要删除这条数据吗?',function(r){
			if(r){
				id=record.LSYRowId;
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
							$('#eastgrid').datagrid('reload');
							$('#eastgrid').datagrid('unselectAll');
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
		var ed = $('#eastgrid').datagrid('getEditors',editIndex); 
		if(ed!=""){
			preeditIndex=editIndex;
			if (endEditing()){
				var record=eastgrid.getSelected();
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
				    record.LSYRowId=data.id
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
}
$(init);