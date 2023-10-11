var userid = session['LOGON.USERID'];
var hospid=session['LOGON.HOSPID'];

$(function(){//初始化
    
    Init();
});

function Init(){
    //是否有效
    $("#IsValid").checkbox({
        onCheckChange:function(event,value){
        	FindBtn();   
        }
    })
    MainColumns=[[  
                {
	                field:'ckbox',
	                checkbox:true
                },
                {
	                field:'rowid',
	                title:'ID',
	                width:80,
	                hidden: true
                },
                {
	                field:'CompDR',
	                title:'医院ID',
	                width:80,
	                hidden: true
                },
                {
	                field:'Code',
	                title:'编码',
	                width:150,
	                allowBlank:false,
	                align:'left',
	                editor: {type:'validatebox',options:{required:true}}
	                
                },
                {
	                field:'Name',
	                title:'名称',
	                width:150,
	                allowBlank:false,
	                required:true,
	                align:'left',
	                editor:{type:'validatebox',
	                	options:{
		                	required:true}}
                },
                 
                {
	                field:'IsValid',
	                title:'是否有效', 
	                width:150, 
	                align:'center',
	                
	                formatter: function (value) {
		           
					   if(value==1){
							return '<input type="checkbox" checked="checked" value="' + value + '"/>';
						}else{
							return '<input type="checkbox" value=""/>';
						}
						  
						 
                    },
	                editor:{
		                type:'checkbox',
		                //checkbox:true,
		                options:{
			                
			                on:'1',
			                off:'0'           
	            } 
	                }
                }   
            ]];
        var MainGridObj = $HUI.datagrid("#MainGrid",{
        url:$URL,
        queryParams:{
            ClassName:"herp.budg.hisui.udata.uBudgTravelItem",
            MethodName:"List",
            hospid :    hospid, 
            Code :      "",
            Name :      "", 
            IsValid :      ""
             
        },
         fitColumns: false,//列固定
        loadMsg:"正在加载，请稍等…",
        autoRowHeight: true,
        rownumbers:true,//行号
        ctrlSelec:true, //在启用多行选择的时候允许使用Ctrl键+鼠标点击的方式进行多选操作
        scheckOnSelect : true,//如果设置为 true，当用户点击某一行时，则会选中/取消选中复选框。如果设置为 false 时，只有当用户点击了复选框时，才会选中/取消选中复选框。
        selectOnCheck : false,
        singleSelect: true, //只允许选中一行
        pageSize:20,
        pageList:[10,20,30,50,100], //页面大小选择列表
        pagination:true,//分页
        fit:true,
        columns:MainColumns,
        rowStyler: function(index,row){
            if(index%2==1){
                return 'background-color:#FAFAFA;';
            }
        },
        onClickRow: onClickRow,
        toolbar: '#tb'     
    });
    
    //查询函数
    var FindBtn= function()
    {
        var IsValid = $('#IsValid').checkbox('getValue');
        	if(IsValid == true){
	        	IsValid=1;
	        }else{
		        IsValid=0;
		    }
		var Code = $('#Data').val();
        MainGridObj.load({
	        ClassName:"herp.budg.hisui.udata.uBudgTravelItem",
	        MethodName:"List",
	        hospid : hospid, 
            Code : Code,
            Name : "",
            IsValid: IsValid
             
       })
    }

    //点击查询按钮 
    $("#FindBn").click(FindBtn);
    
    //删除
    var DelBtn = function()
    {
	        //var index = ('#MainGrind').datagrid('getRows').length-1
	        //alert(index)
	    	var grid = $('#MainGrid')
			if($('#MainGrid').datagrid("getSelections").length==0&&($('#MainGrid').datagrid("getChecked").length==0)){
				$.messager.popover({
				msg: '请选择所要删除的行！',
				timeout: 2000,
				type: 'alert',
				showType: 'show',
				style: {
					"position": "absolute",
					"z-index": "9999",
					left: -document.body.scrollTop - document.documentElement.scrollTop / 2,
					top: 0
				}
			});
		} else {
			del(grid, "herp.budg.hisui.udata.uBudgTravelItem", "Delete"); 	  
		}
		
		  
	};
    //点击删除按钮
    $("#DelBn").click(DelBtn);
    
    //新增
    var AddBtn = function()
   {
	   
	    if (endEditing()) {
		$('#MainGrid').datagrid('appendRow', {IsValid: '1'});
		editIndex = $('#MainGrid').datagrid('getRows').length - 1;
		$('#MainGrid').datagrid('selectRow', editIndex).datagrid('beginEdit', editIndex);
			
		}		
    }
    
    //点击新增按钮
    $("#AddBn").click(AddBtn);
    
    //表格编辑
    var editIndex = undefined;
	function endEditing() {
		if (editIndex == undefined) {
			return true
		}
		if ($('#MainGrid').datagrid('validateRow', editIndex)) {
			
			$('#MainGrid').datagrid('endEdit', editIndex);
			editIndex = undefined;
			return true;
		} else {
			return false;
		}
	}
	
	function onClickRow(index) {
		    $('#MainGrid').datagrid('endEdit', editIndex);
			if (endEditing()) { 
				$('#MainGrid').datagrid('selectRow', index);
				$('#MainGrid').datagrid('beginEdit', index);
				editIndex = index;
			}else{
				$('#MainGrid').datagrid('selectRow', editIndex);
			}  
		
	}
	
	 //保存 
    var saveOrder = function() {
	    var indexs = $('#MainGrid').datagrid('getEditingRowIndexs');
		if (indexs.length > 0) {
			for (i = 0; i < indexs.length; i++) {
				$('#MainGrid').datagrid("endEdit", indexs[i]);
			}
		}
        var rows = $('#MainGrid').datagrid("getChanges");
        if(rows.length < 0){
            $.messager.alert('提示','请先选中至少一行数据!','info');
            return false;
        }else{
                for(var i=0;i<rows.length;i++){
                var row = rows[i];
                rowid=row.rowid;
                Code=row.Code;
               	Name=row.Name;
	        	IsValid=row.IsValid;
            	CompDR=hospid;
            	if((!Code)&&(!Name))
            	{
                    $.messager.popover({
					msg: '必填项不能为空!',
					type:'success',
					style:{"position":"absolute","z-index":"9999",
		            left:-document.body.scrollTop - document.documentElement.scrollTop/2,
		            top:1}});
			        return false;
            	} 
               
                if(rowid==null){
	                 //alert('新增插入新的列！！！')
                    $.m({
                        ClassName:'herp.budg.hisui.udata.uBudgTravelItem',
                        MethodName:'InsertRec',
                        Code:Code,
                        Name:Name,
                        IsValid:IsValid,
                        CompDR:CompDR
                        },
                        function(Data){
                            if(Data==0){
					             //$.messager.alert('提示','保存成功！','info');
					             $.messager.popover({
					            msg: '保存成功！',
					            type:'success',
					            style:{"position":"absolute","z-index":"9999",
		                        left:-document.body.scrollTop - document.documentElement.scrollTop/2,
		                        top:1}});
			                    $.messager.progress('close');
                                 $('#MainGrid').datagrid("reload");     
                            }else{
	                            var message="SQLERROE:"+Data;
	                           if(Data="RepName") message="差旅项目名称重复"
	                           if(Data="RepCode") message="差旅项目编码复"
	                           
                               $.messager.popover({
					            	msg: message,
					            	type:'success',
					            	style:{"position":"absolute","z-index":"9999",
		                        	left:-document.body.scrollTop - document.documentElement.scrollTop/2,
		                        	top:1}
		                        });
			                    $.messager.progress('close');
                            }
                        }
                    );
                }else{
	                //alert('更新编辑的列！！！')
                    $.m({
                        ClassName:'herp.budg.hisui.udata.uBudgTravelItem',
                        MethodName:'UpdateRec',
                        rowid:rowid,
                        Code:Code,
                        Name:Name,
                        IsValid:IsValid,
                        CompDR:CompDR
                        },
                        function(Data){
                             if(Data==0){
							          $.messager.popover({
								          msg: '保存成功！',
								          type:'success',
								           style:{"position":"absolute","z-index":"9999",
								                 left:-document.body.scrollTop - document.documentElement.scrollTop/2,
		                                         top:1}});
							      	  $.messager.progress('close');
							      	  //$('#MainGrid').datagrid("reload");
							      	  editIndex = undefined;
							          }else{
								          $.messager.popover({
												msg: '差旅项目重复,保存失败!',
												type:'error',
												style:{"position":"absolute","z-index":"9999",
												left:-document.body.scrollTop - document.documentElement.scrollTop/2,
												top:1}
												})
										   $.messager.progress('close');
										   $('#MainGrid').datagrid("reload"); 
								      
								      }
                        }
                    );
                }
            }
             //alert('新增插入新的列！！！直接加载表格')
            $('#MainGrid').datagrid("reload");       
        }        
    }
    //点击保存按钮 
    $("#SaveBn").click(saveOrder);
	
	
}

