var selectRowId=""
$(function () {
	//页面选中行
	
	//页面自动筛选
	$("#code").keyup(function(){
	      FindymData()
	   });
	   $("#desc").keyup(function(){
	      FindymData()
	   });
	   $("#addym-dialog").dialog({
		   width:300,
		   //弹出带有遮罩的模式窗体
		   modal:true,
		   shadow:false,
		   //不自动打开
		   closed:true 
	   })
	   //表格下拉框
	   $('#bgtable').combobox({ 
	

       url: 'dhcdocorderlistset.request.csp?action=getgrid&DOPRowId='+selectRowId,

        valueField:'rowid', 

        textField:'desc' 

    });
	$('#updatemessage-dialog').dialog({ 
     title: '页面消息提示', 
	 width:500, 
	 height:165, 
     closed: true, 
     modal: true ,
	 shadow:false
     });
	 $('#grid-dialog').dialog({ 
     title: '表格', 
	 width:600, 
	 height:500, 
     closed: true, 
     modal: true ,
	 shadow:false
     });
	 $('#updategrid-dialog').dialog({ 
     title: '表格', 
	 width:300, 
	 height:200, 
     closed: true, 
     modal: true ,
	 shadow:false
     });
	
	 

  $('#updateym').click( function (){
    var url="dhcdocorderlistset.request.csp?action=updateym&id="+$('#ymid').val()+"&ymCode="+$('#ymCode').val()+"&ymDesc="+$('#ymDesc').val();
    if ($('#ymCode').val()==""){
	        $.messager.alert("错误", "页面代码不能为空！", 'error')
	        return false;
    }
    if ($('#ymDesc').val()==""){
	       $.messager.alert("错误", "页面名称不能为空！", 'error')
	       return false;
    }
   $.ajax({
            url : url,
            type:"POST",
            success:function (response) {
			if ($('#updateym').attr("value")=="添加") var successmsg="添加成功"
	           else var successmsg="修改成功"
                response = eval('(' + response + ')');
                if (response.ResultCode == 0) {
	               $("#addym-dialog").dialog("close")
				   $('#ym').datagrid('rejectChanges');
                   //$('#ym').datagrid('reload');
                    $.messager.show({
	                        
                            msg : successmsg,
                            title : "成功"
                    });
                } else {
                   //$('#ym').datagrid('reload');
                    $.messager.alert("错误", "保存失败" + "," + response.ResultMsg, 'error')
                }
            }
            
        })
       /* $('#addym-form').form({ 
	    
          
       onSubmit: function(){ 
	   alert($('#ymDesc').val())
         if ($('#ymCode').val()==""){
	        $.messager.alert("错误", "页面代码不能为空！", 'error')
	        return false;
        }
        if ($('#ymDesc').val()==""){
	       $.messager.alert("错误", "页面名称不能为空！", 'error')
	       return false;
       }

      }, 
      success:function (response) {
	           if ($('#updateym').attr("value")=="添加") var successmsg="添加成功"
	           else var successmsg="修改成功"
                response = eval('(' + response + ')');
                if (response.ResultCode == 0) {
	               $("#addym-dialog").dialog("close")
                 $('#ym').datagrid('reload');
                    $.messager.show({
	                        
                            msg : successmsg,
                            title : "成功"
                    });
                } else {
                   //$('#ym').datagrid('reload');
                    $.messager.alert("错误", "添加失败" + "," + response.ResultMsg, 'error')
                }
            }
}); */
	
	 }
)
	   //增加页面表单提交

	$('#ym').datagrid({
		 url : 'dhcdocorderlistset.request.csp?action=ym',
                //pagination : 'true',
                //fit : true,
                border : 'true',
                fitColumns:'true',
                singleSelect:true,
				width : 600,
                pagination : 'true',
				pagePosition : 'bottom',
				pageSize : 10,
				height: 500,
                toolbar:[{  		
      			iconCls: 'icon-add',
      			text:'增加',  		
 			    handler: function(){
	 			$("#addym-dialog").dialog("open");
	 			//清空表单数据
	 			$('#addym-form').form("clear")
	 			 $('#updateym').val("添加")   
	 			}  	
  				},'-',{  		
  				iconCls: 'icon-cut', 
  				text:'删除', 		
 				 handler: function(){
	 				 DeleteymData();
	 				 }  	
 				 },'-',{  		
  				iconCls: 'icon-edit', 
  				text:'修改', 		
 				 handler: function(){
	 				 UpdateymData();
	 				 }  	
 				 }] , 

                columns : [[{
                            field : 'rowid',
                            title : '编号',
                            width : 10,
                            hidden:true
                            //checkbox:true
                            
                        }, {
                            field : 'code',
                            title : '页面代码',
                            width : 200,
                            sortable:true
                            
                        }, {
                            field : 'desc',
                            title : '页面描述',
                            width : 100,
                            sortable:true
                            
                        }]],
                        onClickRow : function (rowIndex, rowData) {
	                          $('#dg').datagrid('load',{  
           					          DOGRowId:""}  
            				         );									     
	                        selectRowId=rowData["rowid"]
							$('#message').datagrid('load',{
							          DOPRowId:selectRowId}							 
								);
	                        $('#bgtable').combogrid({ 
                                   url: 'dhcdocorderlistset.request.csp?action=getgrid&DOPRowId='+selectRowId,
                                   valueField:'rowid', 
                                   textField:'desc',
                                   columns:[[ 
								   {field:'rowid',title:'表格ID',hidden:true},
                                    {field:'code',title:'表格代码'},
                                    {field:'desc',title:'表格描述'}, 
                                    {field:'type',title:'表格类型'}
                                   ]] ,
								   onLoadSuccess:function(){  
								      //默认选中第一行
                                     if(($('#bgtable').combogrid('grid').datagrid("getRows").length)>=1){
									 $('#bgtable').combogrid('grid').datagrid("selectRow",0)
									 //$('#bgtable').combogrid('grid').
									 }								 
                                    }  ,
                                   onSelect:function(){
	                                   $('#dg').datagrid('load',{  
           					          DOGRowId:$('#bgtable').combogrid('grid').datagrid('getSelected').rowid}  
            				         );  
            				         
	                                   //alert()
                                   }

                             });
							  $('#grid').datagrid('load',{  
           					          DOPRowId:selectRowId  
            				         });  
                       		
                       },
					   onDblClickRow: function (rowIndex, rowData) {
					        UpdateymData();
					   }
		 
	 });
	 ///消息提示表格
	 $('#message').datagrid({
		 url : 'dhcdocorderlistset.request.csp?action=message',
				width : 600,
                pagination : 'true',
				pagePosition : 'bottom',
				pageSize : 10,
				height: 400,
                //fit : true,
                border : 'true',
                //fitColumns:'true',
                //singleSelect:true,
                toolbar:[{  		
      			iconCls: 'icon-add',
      			text:'增加',  		
 			    handler: function(){
	 			$('#updatemessage-dialog').dialog("open")
				//清空表单数据
	 			$('#updatemessage-form').form("clear")
	 			}  	
  				},'-',{  		
  				iconCls: 'icon-cut', 
  				text:'删除', 		
 				 handler: function(){
	 				 DeleteMessageData();
	 				 }  	
 				 },'-',{  		
  				iconCls: 'icon-edit', 
  				text:'修改', 		
 				 handler: function(){
	 				 UpdateMessageData();
	 				 }  	
 				 }] , 

                columns : [[{
                            field : 'rowid',
                            title : '编号',
                            //width : 100,
                            hidden:true
                            //checkbox:true
                            
                        }, {
                            field : 'code',
                            title : '提示代码',
                            //width : 200,
                            sortable:true
                            
                        }, {
                            field : 'desc',
                            title : '提示描述',
                            //width : 100,
                            sortable:true
                            
                        }, {
                            field : 'otherdesc',
                            title : '提示外文描述',
                           // width : 100,
                            sortable:true
                            
                        }]],
					   onDblClickRow: function (rowIndex, rowData) {
					        UpdateMessageData();
					   }
	 });
	    ///页面表格
		$('#grid').datagrid({
		 url : 'dhcdocorderlistset.request.csp?action=grid&DOPRowId='+selectRowId,
                pagination : 'true',
                fit : true,
                border : 'true',
                fitColumns:'true',
                singleSelect:true,
                toolbar:[{  		
      			iconCls: 'icon-add',
      			text:'增加',  		
 			    handler: function(){
	 			$("#updategrid-dialog").dialog("open");
	 			//清空表单数据
	 			$('#updategrid-form').form("clear")
	 			}  	
  				},'-',{  		
  				iconCls: 'icon-cut', 
  				text:'删除', 		
 				 handler: function(){
	 				 DeleteGridData();
	 				 }  	
 				 },'-',{  		
  				iconCls: 'icon-edit', 
  				text:'修改', 		
 				 handler: function(){
	 				 UpdategridData();
	 				 }  	
 				 }] , 

                columns : [[{
                            field : 'rowid',
                            title : '编号',
                            width : 100,
                            hidden:true
                            //checkbox:true
                            
                        }, {
                            field : 'code',
                            title : '表格代码',
                            width : 200,
                            sortable:true
                            
                        }, {
                            field : 'desc',
                            title : '表格描述',
                            width : 100,
                            sortable:true
                            
                        }, {
                            field : 'type',
                            title : '表格类型',
                            width : 100,
                            sortable:true
                            
                        }]],
                       
					   onDblClickRow: function (rowIndex, rowData) {
					        UpdategridData();
					   }
		 
	 });
	 //列表格
        $('#dg').datagrid({
                url : 'dhcdocorderlistset.request.csp?action=colset',
                pagination : 'true',
                //fit : true,
                border : 'true',
				width : 600,
                pagination : 'true',
				pagePosition : 'bottom',
				pageSize : 10,
				height: 400,
                columns : [[{
                            field : 'rowid',
                            title : '编号',
                            width : 100,
                            checkbox : true
                        }, {
                            field : 'code',
                            title : '列ID',
                            width : 100,
                            editor : 'text'
                        }, {
                            field : 'desc',
                            title : '列描述',
                            width : 100,
                            editor : 'text'
                        }, {
                            field : 'colwidth',
                            title : '列宽',
                            width : 100,
                            editor : 'text'
                        }, {
                            field : 'hidden',
                            title : '是否隐藏',
                            width : 100,
                            editor : {
                                type : 'checkbox',
                                options : {
                                    on : 'Y',
                                    off : ''
                                }
                            }
                        }, {
                            field : 'expression',
                            title : '表达式',
                            editor : 'text',
                            width : 300
                        }
                    ]],
                toolbar : [{
                        id : 'btnadd',
                        text : '增加',
                        iconCls : 'icon-add',
                        handler : function () {
                            //判断是否需要增加行
                            var IsCanAddRow = true;
                            var IsCanAddRow = CheckData();
                            
                            var Rows = $('#dg').datagrid("getRows");
                            if (IsCanAddRow == true) {
                                $('#dg').datagrid('insertRow', {
                                        index : Rows.length,
                                        row : {
                                            rowid : '',
                                            code : '',
                                            desc : '',
                                            colwidth : '',
                                            expression : ''
                                        }
                                    });
                                $('#dg').datagrid('beginEdit', Rows.length - 1);
                                var ed = $('#dg').datagrid('getEditor', {
                                            index : Rows.length - 1,
                                            field : 'code'
                                        });
                                $(ed.target).focus();
                            }
                            
                        }
                    }, '-', {
                        id : 'btncut',
                        text : '删除',
                        iconCls : 'icon-cut',
                        handler : function () {
                            DeleteData();
                        }
                    }, '-', {
                        id : 'btnsave',
                        text : '保存',
                        iconCls : 'icon-save',
                        handler : function () {
                            //保存所有未保存的行
                            var IsCanSave = CheckData();
                            if (IsCanSave == false)
                                return;
                            var Data = $('#dg').datagrid("getData");
                            var Rows = $('#dg').datagrid("getRows");
                            for (var i = 0; i < Rows.length; i++) {
                                $('#dg').datagrid('endEdit', i);
                                SaveDataToServer(Data.rows[i]);
                            }
                            $('#dg').datagrid('reload');
                        }
                    }, '-', {
                        id : 'btnredo',
                        text : '取消编辑',
                        iconCls : 'icon-redo',
                        handler : function () {
                            $('#dg').datagrid('rejectChanges');
                            $('#dg').datagrid('unselectAll')
                        }
                    }
                ],
                onDblClickRow : function (rowIndex, rowData) {
                    var rowid_ed = $('#dg').datagrid('getEditor', {
                                index : rowIndex,
                                field : 'rowid'
                            });
                    if (rowid_ed == null) {
                        $('#dg').datagrid('beginEdit', rowIndex);
                    } else {
                        $('#dg').datagrid('endEdit', rowIndex);
                    }
                },
                onAfterEdit : function (rowIndex, rowData, changes) {},
                onLoadSuccess : function (data) {}
            });
    });

function SaveDataToServer(rowData) {
    var SuccessMessage = "添加成功";
    var ErrorMessage = "添加失败！";
    var DOGRowId=$('#bgtable').combogrid('grid').datagrid('getSelected').rowid
	
    if (rowData["rowid"] == "") {
        url = "dhcdocorderlistset.request.csp?action=add&DOGRowId="+DOGRowId+"&code="+ rowData["code"] + "&desc=" + rowData["desc"] + "&colwidth=" + rowData["colwidth"] + "&hidden=" + rowData["hidden"] + "&expression=" + rowData["expression"] 
   } else {
        url = "dhcdocorderlistset.request.csp?action=update&rowid=" + rowData["rowid"] + "&code=" + rowData["code"] + "&desc=" + rowData["desc"] + "&colwidth=" + rowData["colwidth"] + "&hidden=" + rowData["hidden"] + "&expression=" + rowData["expression"]
			SuccessMessage = "修改成功";
        ErrorMessage = "修改失败！";
    }
    $.ajax({
            url : url,
            type:"POST",
            success : function (response) {
                response = eval('(' + response + ')');
                if (response.ResultCode == 0) {
                    $('#dg').datagrid('acceptChanges');
                    $.messager.show({
                            msg : SuccessMessage,
                            title : "成功"
                        });
                } else {
                    $('#dg').datagrid('rejectChanges');
                    $.messager.alert("错误", ErrorMessage + "," + response.ResultMsg, 'error')
                }
            }
            
        })
    
}
function DeleteData() {
    var rows = $('#dg').datagrid('getSelections');
    var ids = [];
    var unSaveIndexs = [];
    if (rows.length > 0) {
        $.messager.confirm('请确认', '您确定要删除所选的项目？', function (b) {
                if (b) {
                    for (var i = 0; i < rows.length; i++) {
                        if ($.trim(rows[i].rowid) == "") {						  
                            unSaveIndexs.push($('#dg').datagrid('getRowIndex',rows[i]));
                        } else {
                            ids.push(rows[i].rowid);
                        }
                    }
                    //删除已经保存的数据
                    if (ids.length > 0) {
                        $.ajax({
                                url : "dhcdocorderlistset.request.csp?action=del&IDs=" + ids.join('^'),
                                success : function (response) {
                                    response = eval('(' + response + ')');
                                    if (response.ResultCode == 0) {
                                        $('#dg').datagrid('reload');
                                        $('#dg').datagrid('unselectAll')
                                        $.messager.show({
                                                msg : "删除成功！",
                                                title : "成功"
                                            })
                                        
                                    } else {
                                        //$('#dg').datagrid('rejectChanges');
                                        $.messager.alert("错误", "删除失败," + response.ResultMsg, 'error')
                                    }
                                }
                                
                            });
                    }
                    //删除未保存的页面数据
                    if (unSaveIndexs.length > 0) {
                        for (var i = 0; i < unSaveIndexs.length; i++) {
                            var RowIndex = unSaveIndexs[i];
                            $("#dg").datagrid("deleteRow", RowIndex);
                        }
                    }
                    
                }
            })
    }
}
//删除页面
function DeleteymData(){
	 var rows = $('#ym').datagrid('getSelections');
    var ids = [];
    var unSaveIndexs = [];
    if (rows.length > 0) {
        $.messager.confirm('请确认', '您确定要删除所选的项目？', function (b) {
                if (b) {
                    for (var i = 0; i < rows.length; i++) {
                            ids.push(rows[i].rowid);
                    }
                    //删除已经保存的数据
                    if (ids.length > 0) {
                        $.ajax({
                                url : "dhcdocorderlistset.request.csp?action=delym&IDs=" + ids.join('^'),
                                success : function (response) {
                                    response = eval('(' + response + ')');
                                    if (response.ResultCode == 0) {
                                        $('#ym').datagrid('reload');
                                        $('#ym').datagrid('unselectAll')
                                        $.messager.show({
                                                msg : "删除成功！",
                                                title : "成功"
                                            })
                                        
                                    } else {
                                        //$('#dg').datagrid('rejectChanges');
                                         $('#ym').datagrid('reload');
                                        $('#ym').datagrid('unselectAll')
                                        $.messager.alert("错误", "删除失败," + response.ResultMsg, 'error')
                                    }
                                }
                                
                            });
                    }
                    
                    
                }
            })
    }else{
	    $.messager.alert("错误","选择一行！",'err')
	            
     }
	
}
//删除页面消息提示
function DeleteMessageData(){
var rows = $('#message').datagrid('getSelections');
    var ids = [];
    var unSaveIndexs = [];
    if (rows.length > 0) {
        $.messager.confirm('请确认', '您确定要删除所选的项目？', function (b) {
                if (b) {
                    for (var i = 0; i < rows.length; i++) {
                            ids.push(rows[i].rowid);
                    }
                    //删除已经保存的数据
                    if (ids.length > 0) {
                        $.ajax({
                                url : "dhcdocorderlistset.request.csp?action=delelemessage&IDs=" + ids.join('^'),
                                success : function (response) {
                                    response = eval('(' + response + ')');
                                    if (response.ResultCode == 0) {
                                        $('#message').datagrid('reload');
                                        $('#message').datagrid('unselectAll')
                                        $.messager.show({
                                                msg : "删除成功！",
                                                title : "成功"
                                            })
                                        
                                    } else {
                                        //$('#dg').datagrid('rejectChanges');
                                         $('#message').datagrid('reload');
                                        $('#message').datagrid('unselectAll')
                                        $.messager.alert("错误", "删除失败," + response.ResultMsg, 'error')
                                    }
                                }
                                
                            });
                    }
                    
                    
                }
            })
    }else{
	    $.messager.alert("错误","选择一行！",'err')
	            
     }


}
//删除表格
function DeleteGridData(){
var rows = $('#grid').datagrid('getSelections');
    var ids = [];
    var unSaveIndexs = [];
    if (rows.length > 0) {
        $.messager.confirm('请确认', '您确定要删除所选的项目？', function (b) {
                if (b) {
                    for (var i = 0; i < rows.length; i++) {
                            ids.push(rows[i].rowid);
                    }
                    //删除已经保存的数据
                    if (ids.length > 0) {
                        $.ajax({
                                url : "dhcdocorderlistset.request.csp?action=delelegrid&IDs=" + ids.join('^'),
                                success : function (response) {
                                    response = eval('(' + response + ')');
                                    if (response.ResultCode == 0) {
                                        $('#grid').datagrid('reload');
                                        $('#grid').datagrid('unselectAll')
										 //重新加载表格下拉框
				                         reloadbgtable()
                                        $.messager.show({
                                                msg : "删除成功！",
                                                title : "成功"
                                            })
                                        
                                    } else {
                                        //$('#dg').datagrid('rejectChanges');
                                         $('#grid').datagrid('reload');
                                        $('#grid').datagrid('unselectAll')
                                        $.messager.alert("错误", "删除失败," + response.ResultMsg, 'error')
                                    }
                                }
                                
                            });
                    }
                    
                    
                }
            })
    }else{
	    $.messager.alert("错误","选择一行！",'err')
	            
     }


}
//审查页面数据是否可以保存或者增加行,返回true 可以,false 不可以
function CheckData() {
    var myrtn = true;
    var Data = $('#dg').datagrid("getData");
    var Rows = $('#dg').datagrid("getRows");
    for (var i = 0; i < Rows.length; i++) {
        var code_ed = $('#dg').datagrid('getEditor', {
                    index : i,
                    field : 'code'
                });
        if (code_ed == null)
            continue;
        var code = $(code_ed.target).val();
        var desc_ed = $('#dg').datagrid('getEditor', {
                    index : i,
                    field : 'desc'
                });
        var desc = $(desc_ed.target).val();
        var colwidth_ed = $('#dg').datagrid('getEditor', {
                    index : i,
                    field : 'colwidth'
                });
        var colwidth = $(colwidth_ed.target).val();
        var expression_ed = $('#dg').datagrid('getEditor', {
                    index : i,
                    field : 'expression'
                });
        var expression = $(expression_ed.target).val();
        if ($.trim(code) == "") {
            alert("列ID不能为空");
            $(code_ed.target).focus();
            myrtn = false;
        } else if ($.trim(desc) == "") {
            alert("列描述不能为空");
            $(desc_ed.target).focus();
            myrtn = false;
        } else if ($.trim(colwidth) == "") {
            alert("列宽不能为空");
            $(colwidth_ed.target).focus();
            myrtn = false;
        } else if ($.trim(expression) == "") {
            alert("表达式不能为空");
            $(expression_ed.target).focus();
            myrtn = false;
        }
    }
    return myrtn;
}
 function FindymData(){  
        $('#ym').datagrid('load',{  
            Code:$('#code').val(),  
            Desc:$('#desc').val()}  
            );  
    }  
 ////修改页面函数
function UpdateymData(){ 
	var rows = $('#ym').datagrid('getSelections');
    if (rows.length ==1) {
       $("#addym-dialog").dialog("open");
	 //清空表单数据
	 $('#addym-form').form("clear")
	
	 $('#addym-form').form("load",{
		 ymid:rows[0].rowid,
		 ymCode:rows[0].code,
		 ymDesc:rows[0].desc
	 })
      $('#updateym').val("修改")        
     }else if (rows.length>1){
	     $.messager.alert("错误","您选择了多行！",'err')
     }else{
	     $.messager.alert("错误","请选择一行！",'err')
     }
   
}
///修改页面提示消息函数
function UpdateMessageData(){
   var rows = $('#message').datagrid('getSelections');
    if (rows.length ==1) {
       $("#updatemessage-dialog").dialog("open");
	 //清空表单数据
	 $('#updatemessage-form').form("clear")
	
	 $('#updatemessage-form').form("load",{
		 messageid:rows[0].rowid,
		 messagecode:rows[0].code,
		 messagedesc:rows[0].desc,
		 messageOtherDesc:rows[0].otherdesc
	 })
      //$('#updatemessage-button').val("修改")        
     }else if (rows.length>1){
	     $.messager.alert("错误","您选择了多行！",'err')
     }else{
	     $.messager.alert("错误","请选择一行！",'err')
     }

}
///修改表格函数
function UpdategridData(){
   var rows = $('#grid').datagrid('getSelections');
    if (rows.length ==1) {
       $("#updategrid-dialog").dialog("open");
	 //清空表单数据
	 $('#updategrid-form').form("clear")
	
	 $('#updategrid-form').form("load",{
		 gridid:rows[0].rowid,
		 gridcode:rows[0].code,
		 griddesc:rows[0].desc,
		 gridtype:rows[0].type
	 })
      //$('#updatemessage-button').val("修改")        
     }else if (rows.length>1){
	     $.messager.alert("错误","您选择了多行！",'err')
     }else{
	     $.messager.alert("错误","请选择一行！",'err')
     }

}
function updatemessage(){
     var url="dhcdocorderlistset.request.csp?action=updatemessage&id="+$('#messageid').val()+"&Code="+$('#messageCode').val()+"&Desc="+$('#messageDesc').val()+"&OtherDesc="+$('#messageOtherDesc').val()+"&DOPRowId="+selectRowId;
    if ($('#messageCode').val()==""){
	        $.messager.alert("错误", "代码不能为空！", 'error')
	        return false;
    }
    if ($('#messageDesc').val()==""){
	       $.messager.alert("错误", "名称不能为空！", 'error')
	       return false;
    }
   $.ajax({
            url : url,
            type:"POST",
            success:function (response) {
			   var successmsg="保存成功"
                response = eval('(' + response + ')');
                if (response.ResultCode == 0) {
	               $("#updatemessage-dialog").dialog("close")
				   //$('#message').datagrid('rejectChanges');
                   $('#message').datagrid('reload');
                    $.messager.show({
	                        
                            msg : successmsg,
                            title : "成功"
                    });
                } else {
                   //$('#ym').datagrid('reload');
                    $.messager.alert("错误", "保存失败" + "," + response.ResultMsg, 'error')
                }
            }
            
        })
}
function closeupdatemessagedialog(){
   $("#updatemessage-dialog").dialog("close");
}
function opengrid(){
   $('#grid-dialog').dialog("open")
}
function updategrid(){
   var url="dhcdocorderlistset.request.csp?action=updategrid&ID="+$('#gridId').val()+"&Code="+$('#gridCode').val()+"&Desc="+$('#gridDesc').val()+"&Type="+$('#gridType').val()+"&DOPRowId="+selectRowId;
    if ($('#gridCode').val()==""){
	        $.messager.alert("错误", "代码不能为空！", 'error')
	        return false;
    }
    if ($('#gridDesc').val()==""){
	       $.messager.alert("错误", "名称不能为空！", 'error')
	       return false;
    }
	if ($('#gridType').val()==""){
	       $.messager.alert("错误", "类型不能为空！", 'error')
	       return false;
    }
   $.ajax({
            url : url,
            type:"POST",
            success:function (response) {
			   var successmsg="保存成功"
                response = eval('(' + response + ')');
                if (response.ResultCode == 0) {
	               $("#updategrid-dialog").dialog("close")
				   //$('#message').datagrid('rejectChanges');
                   $('#grid').datagrid('reload');
				   //重新加载表格下拉框
				   reloadbgtable()
                    $.messager.show({
	                        
                            msg : successmsg,
                            title : "成功"
                    });
                } else {
                   //$('#ym').datagrid('reload');
                    $.messager.alert("错误", "保存失败" + "," + response.ResultMsg, 'error')
                }
            }
            
        })

}
function closeupdategriddialog(){
  $("#updategrid-dialog").dialog("close");
}
function reloadbgtable(){
           $('#bgtable').combogrid({ 
                                   url: 'dhcdocorderlistset.request.csp?action=getgrid&DOPRowId='+selectRowId,
                                   valueField:'rowid', 
                                   textField:'desc',
                                   columns:[[ 
								   {field:'rowid',title:'表格ID',hidden:true},
                                    {field:'code',title:'表格代码'},
                                    {field:'desc',title:'表格描述'}, 
                                    {field:'type',title:'表格类型'}
                                   ]] ,
								   onLoadSuccess:function(){  
								      //默认选中第一行
                                     if(($('#bgtable').combogrid('grid').datagrid("getRows").length)>=1){
									 $('#bgtable').combogrid('grid').datagrid("selectRow",0)
									 //$('#bgtable').combogrid('grid').
									 }								 
                                    }  ,
                                   onSelect:function(){
	                                   $('#dg').datagrid('load',{  
           					          DOGRowId:$('#bgtable').combogrid('grid').datagrid('getSelected').rowid}  
            				         );  
            				         
	                                   //alert()
                                   }

                             })
}

