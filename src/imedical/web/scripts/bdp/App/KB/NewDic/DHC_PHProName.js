/*
* @Author: 基础数据平台-石萧伟
* @Date:   2018-08-11 15:41:35
* @Last Modified by:   admin
* @Last Modified time: 2018-11-07 15:19:11
* @描述:药品商品名字典表
*/
var SAVE_ACTION_URL = "../csp/dhc.bdp.ext.entitydatatrans.csp?pClassName=web.DHCBL.KB.DHCPHProName&pClassMethod=SaveData&pEntityName=web.Entity.KB.DHCPHProName";
var OPEN_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.KB.DHCPHProName&pClassMethod=OpenData";
var DELETE_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.KB.DHCPHProName&pClassMethod=DeleteData";
var init=function()
{
    var columns =[[
        {field:'PHNCode',title:'代码',sortable:true,width:100},
        {field:'PHNDesc',title:'描述',sortable:true,width:100},
        {field:'PHNFormDr',title:'剂型',sortable:true,width:100},
        {field:'PHNGenericDr',title:'通用名',sortable:true,width:100},
        {field:'PHNToxicity',title:'毒性',sortable:true,width:100},
        {field:'PHNManfDR',title:'厂家',sortable:true,width:100},
        {field:'PHNActiveFlag',title:'是否可用',sortable:true,width:100,
              formatter:ReturnFlagIcon
    	},
        {field:'PHNSysFlag',title:'是否系统标识',sortable:true,width:100,
              formatter:ReturnFlagIcon
    	}, 
        {field:'PHNWholeFlag',title:'是否整支',sortable:true,width:100,
              formatter:ReturnFlagIcon
    	},     	   	
        {field:'PHNRowId',title:'rowid',sortable:true,width:100,hidden:true}
    ]];
    var mygrid = $HUI.datagrid("#mygrid",{
        url:$URL,
        queryParams:{
            ClassName:"web.DHCBL.KB.DHCPHProName",
            QueryName:"GetList"
        },
        columns: columns,  //列信息
        pagination: true,   //pagination	boolean	设置为 true，则在数据网格（datagrid）底部显示分页工具栏。
        pageSize:PageSizeMain,
        pageList:[5,10,15,20,25,30,50,75,100,200,300,500,1000],
        singleSelect:true,
        remoteSort:false,
       // ClassTableName:'User.DHCPHExtPart',
		//SQLTableName:'DHC_PHExtPart',
        idField:'PHNRowId',
        rownumbers:true,    //设置为 true，则显示带有行号的列。
        fixRowNumber:true,
        fitColumns:true, //设置为 true，则会自动扩大或缩小列的尺寸以适应网格的宽度并且防止水平滚动
        onDblClickRow:function(index,row)
        {
        	updateData();
        },
        onLoadSuccess:function(data){
			$(this).prev().find('div.datagrid-body').prop('scrollTop',0);
        }	 	
    });
    //搜索时剂型断下拉框
	$('#GlPPointer').combobox({
        url:$URL+"?ClassName=web.DHCBL.KB.DHCPHExtForm&QueryName=GetDataForCmb1&ResultSetType=array",
        valueField:'PHEFRowId',
        textField:'PHEFDesc'
        //mode:'remote',
        //panelWidth:250 
    });
    /**************************************下拉框*******************************************/
    //剂型下拉框
	$('#PHNFormDr').combobox({
        url:$URL+"?ClassName=web.DHCBL.KB.DHCPHExtForm&QueryName=GetDataForCmb1&ResultSetType=array",
        valueField:'PHEFRowId',
        textField:'PHEFDesc',
		blurValidValue:true
        //mode:'remote',
    });
    //通用名下拉框
	$('#PHNGenericDr').combobox({
        url:$URL+"?ClassName=web.DHCBL.KB.DHCPHExtGeneric&QueryName=GetDataForCmb2&ResultSetType=array&libcode=DRUG",
        valueField:'PHEGRowId',
        textField:'PHEGDesc',
		blurValidValue:true
        //mode:'remote'
    }); 
    //毒性下拉框
	$('#PHNToxicity').combobox({
        url:$URL+"?ClassName=web.DHCBL.KB.DHCPHToxicity&QueryName=GetDataForCmb1&ResultSetType=array",
        valueField:'ToxRowId',
        textField:'ToxDesc',
		blurValidValue:true
    });
    //厂家下拉框
	$('#PHNManfDR').combobox({
        url:$URL+"?ClassName=web.DHCBL.KB.DHCPHManf&QueryName=GetDataForCmb1&ResultSetType=array",
        valueField:'PHMARowId',
        textField:'PHMADesc',
		blurValidValue:true
    });           
    /**************************************下拉框结束***************************************/
    //点击添加按钮
    $('#add_btn').click(function(e){
    	AddData();
    });
    //点击修改按钮
    $('#update_btn').click(function(){
    	updateData();
    });
    //点击删除按钮
    $('#del_btn').click(function(e){
    	delData();
    });
     //点击搜索按钮
    $('#btnSearch').click(function(e){
    	 SearchFunLib();
    });
    //搜索回车事件
	$('#TextDesc,#TextCode').keyup(function(event){
		if(event.keyCode == 13) {
		  SearchFunLib();
		}
	});    
    //搜索方法
    SearchFunLib=function()
    {
    	var code=$("#TextCode").val();
    	var desc=$("#TextDesc").val();
    	var form=$('#GlPPointer').combobox('getValue');
    	$('#mygrid').datagrid('load',  { 
            ClassName:"web.DHCBL.KB.DHCPHProName",
            QueryName:"GetList",
            desc:desc,
            code:code,
            form:form
        });
        $('#mygrid').datagrid('unselectAll');    	
    }    
    //点击重置按钮
    $('#btnRefresh').click(function(e){
		$("#TextDesc").val('');//清空检索框
		$("#TextCode").val('');
		$('#GlPPointer').combobox('setValue','');
        $('#mygrid').datagrid('load',  { 
            ClassName:"web.DHCBL.KB.DHCPHProName",
            QueryName:"GetList"
        });
		$('#mygrid').datagrid('unselectAll');
    });
 	//点击添加按钮方法
    AddData=function(){ 
        //$('#PHNCode').attr("disabled",false);
        //$('#PHNDesc').attr("disabled",false); 
		$('#PHNCode').attr("readonly",false);
        $('#PHNCode')[0].readonly=false;
        $('#PHNCode').css({'background-color':'#ffffff'});

		$('#PHNDesc').attr("readonly",false);
        $('#PHNDesc')[0].readonly=false;
        $('#PHNDesc').css({'background-color':'#ffffff'});       	
		$("#myWin").show();
    	$('#othergrid').datagrid('load',  { 
            ClassName:"web.DHCBL.BDP.BDPAlias",
            QueryName:"GetList"
        });		
		//$('#PHNCode').validatebox('enable');
		//$('#PHNDesc').validatebox('enable');
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
					SaveFunLib("",1);
				}
			},{
				text:'继续新增',
				id:'save_goon',
				handler:function(){
					//goOnSaveData();
					SaveFunLib("",2)
				}
			},{
				text:'关闭',
				handler:function(){
			    	$('#othergrid').datagrid('load',  { 
			            ClassName:"web.DHCBL.BDP.BDPAlias",
			            QueryName:"GetList"
			        });						
					myWin.close();
					editIndex = undefined;
				}
			}],
			onClose:function(){
				//防止弹窗
		    	$('#othergrid').datagrid('load',  { 
		            ClassName:"web.DHCBL.BDP.BDPAlias",
		            QueryName:"GetList"
		        });		
		        editIndex = undefined;				
			}
		});
		$('#form-save').form("clear");
		//默认选中
		$HUI.checkbox("#PHNActiveFlag").setValue(true);
		$HUI.checkbox("#PHNSysFlag").setValue(true);
		$HUI.checkbox("#PHNWholeFlag").setValue(true);
		$('#tabOther').tabs('select',0);		
	}
	SaveFunLib=function(id,flagT)
	{
		//结束可编辑表格的可编辑状态
		endEditing();		
		//判断别名是否为空
	    var rows = $('#othergrid').datagrid('getRows');//获取当前页的数据行   
	    for (var i = 0; i < rows.length; i++) {  
	        //total += rows[i]['SCORE']; //获取指定列
	        //alert(editIndex);
	        //alert(rows[i]['DataAlias']);
	        if (rows[i]['DataAlias'] == "")
	        {
				$.messager.alert('错误提示','别名不能为空！','error');
                var newEditIndex=$('#othergrid').datagrid('getRowIndex',$('#othergrid').datagrid('getSelected'));
                othergrid.deleteRow(newEditIndex);				
				return 				        	
	        }
	    } 		
		//alert(flag)
		var code=$.trim($("#PHNCode").val());
		var desc=$.trim($("#PHNDesc").val());	
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
                param.PHNRowId = id;
            },
		success: function (data) { 
		  	var data=eval('('+data+')'); 
		  	if (data.success == 'true') {
		  		//保存别名
		  		var DataRefer=data.id;
				var otherdata=$('#othergrid').datagrid('getData');
				//alert(data.rows[0].DataAlias);
				var dataforSave="";
				for(i=0;i<otherdata.rows.length;i++)
				{
					//alert(otherdata.rows[i].DataAlias)
					var dataRow=otherdata.rows[i].AliasRowId+"^"+"DHC_PHProName"+"^"+otherdata.rows[i].DataAlias+"^"+DataRefer;
					if(dataforSave=="")
					{
						dataforSave=dataRow;
					}
					else
					{
						dataforSave += "#"+dataRow;
					}
				}
				if(dataforSave=="")
				{
					//return false;
				}
				else
				{
					var datao=tkMakeServerCall("web.DHCBL.BDP.BDPAlias","SaveEntity",dataforSave);
				}		  		
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
				$('#mygrid').datagrid('reload');  // 重新载入当前页面数据 
				if(flagT==1)
				{
					$('#myWin').dialog('close'); // close a dialog
				}
				else
				{
					$('#form-save').form("clear");
					//默认选中
					$HUI.checkbox("#PHNActiveFlag").setValue(true);	
					$HUI.checkbox("#PHNSysFlag").setValue(true);	
					$HUI.checkbox("#PHNWholeFlag").setValue(true);		
					$('#othergrid').datagrid('load',  { 
		            	ClassName:"web.DHCBL.BDP.BDPAlias",
		            	QueryName:"GetList"
		        	});		
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
			var id=record.PHNRowId;
			//alert(1)
			//加载别名列表
	    	$('#othergrid').datagrid('load',  { 
	            ClassName:"web.DHCBL.BDP.BDPAlias",
	            QueryName:"GetList",
				TableN:"DHC_PHProName",
				DataRefer:id
	        });				
			$.cm({
				ClassName:"web.DHCBL.KB.DHCPHProName",
				MethodName:"NewOpenData",
				id:id
			},function(jsonData){
				//给是否可用单独赋值	
				//alert(jsonData.PHLFSysFlag)		
				//alert(jsonData.PHLFActiveFlag)		
				if (jsonData.PHNActiveFlag=="Y"){
					$HUI.checkbox("#PHNActiveFlag").setValue(true);		
				}else{
					$HUI.checkbox("#PHNActiveFlag").setValue(false);
				}
				if (jsonData.PHNSysFlag=="Y"){
					$HUI.checkbox("#PHNSysFlag").setValue(true);		
				}else{
					$HUI.checkbox("#PHNSysFlag").setValue(false);
				}
				if (jsonData.PHNWholeFlag=="Y"){
					$HUI.checkbox("#PHNWholeFlag").setValue(true);		
				}else{
					$HUI.checkbox("#PHNWholeFlag").setValue(false);
				}								
				$('#form-save').form("load",jsonData);	
			});	
            //如果已对照则不能修改
            var contrastFlag=tkMakeServerCall("web.DHCBL.KB.DHCPHProName","GetRefFlag",id);
            //alert(contrastFlag)
            if(contrastFlag.indexOf("商品名与His对照")>0)
            {
                //$('#PHNCode').attr("disabled",true);//代码不可修改
                //$('#PHNDesc').attr("disabled",true);//代码不可修改

                $('#PHNCode').attr("readonly",true);
				$('#PHNCode')[0].readonly=true;
				$('#PHNCode').css({'background-color':'#EBEBE4'});

				$('#PHNDesc').attr("readonly",true);
				$('#PHNDesc')[0].readonly=true;
				$('#PHNDesc').css({'background-color':'#EBEBE4'});
            }
            else
            {
               // $('#PHNCode').attr("disabled",false);
                //$('#PHNDesc').attr("disabled",false);

				$('#PHNCode').attr("readonly",false);
		        $('#PHNCode')[0].readonly=false;
		        $('#PHNCode').css({'background-color':'#ffffff'});

				$('#PHNDesc').attr("readonly",false);
		        $('#PHNDesc')[0].readonly=false;
		        $('#PHNDesc').css({'background-color':'#ffffff'});                
            } 			
			$("#myWin").show();
			//$('#PHNCode').validatebox('disable');
			//$('#PHNDesc').validatebox('disable');
			$('#tabOther').tabs('select',0);
			var myWin = $HUI.dialog("#myWin",{
				iconCls:'icon-w-edit',
				resizable:true,
				title:'修改',
				modal:true,
				buttons:[{
					text:'保存',
					id:'save_btn',
					handler:function(){
						SaveFunLib(id,1)
					}
				},{
					text:'关闭',
					handler:function(){
						myWin.close();
						editIndex = undefined;
					}
				}],
				onClose:function()
				{
					editIndex = undefined;
				}
			});							
		}else{
			$.messager.alert('错误提示','请先选择一条记录!',"error");
		}
	}
	delData=function()
	{
		var row = $("#mygrid").datagrid("getSelected"); 
		if (!(row))
		{	$.messager.alert('错误提示','请先选择一条记录!',"error");
			return;
		}
		var rowid=row.PHNRowId;
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
							  	var datad=tkMakeServerCall("web.DHCBL.BDP.BDPAlias","DeleteAll","DHC_PHProName",data.id);
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
	//别名可编辑列表
	var editIndex = undefined;
	var rowsvalue=undefined;
	var oldrowsvalue=undefined;
	var preeditIndex="";
	var othercolumns =[[  
	  {field:'AliasRowId',title:'AliasRowId',width:50,sortable:true,hidden:true,editor:'validatebox'},
	  {field:'DataAlias',title:'别名',width:200,sortable:true,editor:'validatebox'}
	 ]];
	var othergrid = $HUI.datagrid("#othergrid",{
		url:$URL,
		queryParams:{
			ClassName:"web.DHCBL.BDP.BDPAlias",         ///调用Query时
			QueryName:"GetList"
		},
		//ClassTableName:'User.BDPTableList',
		//SQLTableName:'BDP_TableList',
		idField:'AliasRowId',
		columns: othercolumns,  //列信息
		pagination: false,   //pagination	boolean	设置为 true，则在数据网格（datagrid）底部显示分页工具栏。
		pageSize:PageSizePop,
		pageList:[5,10,15,20,25,30,50,75,100,200,300,500,1000], 
		singleSelect:true,
		rownumbers:true,    //设置为 true，则显示带有行号的列。
		fitColumns:true, //设置为 true，则会自动扩大或缩小列的尺寸以适应网格的宽度并且防止水平滚动
		remoteSort:false,  //定义是否从服务器排序数据。true
		onDblClickRow:function(rowIndex,rowData){
			DblClickFun(rowIndex,rowData)
        },
        onClickRow:function(rowIndex,rowData){
			$('#othergrid').datagrid('selectRow', rowIndex);
			//ClickFun();
	    },
        onLoadSuccess:function(data){
        }
	});
	//用于单击非grid行保存可编辑行
	$(document).bind('click',function(){ 
	    ClickFun();
	});
	$('#addo_btn').click(function (e){
        AddDataO();

    });
    $('#delo_btn').click(function (e){
	    //$('#knoExe').css('display','none'); 
        DelDataO();
    });
	function DelDataO(){
		var record=othergrid.getSelected();
		if(!record){
			$.messager.alert('提示','请选择一条记录！','error');
			return;
		}
		//console.log(mygrid.getSelected())
		//console.log(record)
		if((record.AliasRowId==undefined) || (record.AliasRowId=="")){
			//othergrid.deleteRow(editIndex)
			var newEditIndex=$('#othergrid').datagrid('getRowIndex',$('#othergrid').datagrid('getSelected'));
			othergrid.deleteRow(newEditIndex)
			//editIndex = undefined;
			return;
		}
		
		$.messager.confirm('确认','您要删除这条数据吗?',function(r){
			if(r){
				id=record.AliasRowId;
				$.ajax({
					url:"../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.BDP.BDPAlias&pClassMethod=DeleteData",
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
							$('#othergrid').datagrid('reload');
							$('#othergrid').datagrid('unselectAll');
							//editIndex = undefined;
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
	function AddDataO(){
		if(ClickFun('AddDataO')==0){
			return
		}		
		preeditIndex=editIndex;
		ClickFun('AddDataO')
		
		if (endEditing()){
			$('#othergrid').datagrid('insertRow',{index:0,row:{}});
			editIndex = 0;//$('#mygrid').datagrid('getRows').length-1;
			$('#othergrid').datagrid('selectRow', editIndex)
					.datagrid('beginEdit', editIndex);
		}
        //AppendDom()
	}    
	function ClickFun(type){   //单击执行保存可编辑行
		if (endEditing()){
			//console.log(rowsvalue)
			if(rowsvalue!= undefined){
				if((rowsvalue.DataAlias!="")){
				    var rows = $('#othergrid').datagrid('getRows');//获取当前页的数据行    
				    for (var i = 0; i < rows.length; i++) {  
				        //total += rows[i]['SCORE']; //获取指定列
				        //alert(editIndex);
				        //alert(rows[i]['DataAlias']);
				        var valuerow = rows[i]['DataAlias'];
				        if (valuerow == rowsvalue.DataAlias && i != editIndex && editIndex!=undefined)
				        {
							$.messager.alert('错误提示','别名重复！','error');
							editIndex=undefined
							/*$('#othergrid').datagrid('selectRow', editIndex)
								.datagrid('beginEdit', editIndex);*/
							var newEditIndex=$('#othergrid').datagrid('getRowIndex',$('#othergrid').datagrid('getSelected'));
							othergrid.deleteRow(newEditIndex)								
							//AppendDom()
							return 				        	
				        }
				    }  
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
							//SaveDataO (rowsvalue,type);
						}
						else{
							//UpdataRow(rowsvalue,editIndex)
							editIndex=undefined
							rowsvalue=undefined
						}
				}
				else{
					//$.messager.alert('错误提示','别名不能为空！','error')
                    var newEditIndex=$('#othergrid').datagrid('getRowIndex',$('#othergrid').datagrid('getSelected'));
                    othergrid.deleteRow(newEditIndex) 					
					$('.messager-window').click(stopPropagation)
					/*$('#othergrid').datagrid('selectRow', editIndex)
						.datagrid('beginEdit', editIndex);*/
					//AppendDom()
					return 0
				}
			}

		}
	}	
	function DblClickFun (index,row){   //双击激活可编辑   （可精简）
		
		if(index==editIndex){
			return
		}
		/*if((row!=undefined)&&(row.AliasRowId!=undefined)){
			UpdataRow(row,index)
		}*/
		preeditIndex=editIndex
		if (editIndex != index){
			if (endEditing()){
				$('#othergrid').datagrid('selectRow', index)
						.datagrid('beginEdit', index);
				editIndex = index;
			} else {
				$('#othergrid').datagrid('selectRow', editIndex);
			}
		}
		oldrowsvalue=JSON.stringify(row);   //用于和rowvalue比较 以判断是否行值发生改变
		//AppendDom()
	}
	function endEditing(){
		if (editIndex == undefined){return true}
		if ($('#othergrid').datagrid('validateRow', editIndex)){
			$('#othergrid').datagrid('endEdit', editIndex);
			rowsvalue=othergrid.getRows()[editIndex];    //临时保存激活的可编辑行的row   
			//editIndex = undefined;
			return true;
		} else {
			return false;
		}
	}				
}
$(init);

