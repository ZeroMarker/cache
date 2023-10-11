$(function(){//初始化
    Init();
}); 
function Init(){
     //查询函数
    var FindBtn= function(){
        var IsTwoUppDown   = $('#IsTwoUppDownbox').checkbox('getValue') ? 1 : 0; 
        var IsEconomicItem = $('#IsEconomicItembox').checkbox('getValue') ? 1 : 0; 
        MainGridObj.load({
                ClassName: "herp.budg.hisui.udata.uBudgInCharge",
                MethodName: "List",
                IsTwoUppDown : IsTwoUppDown,
                IsEconomicItem : IsEconomicItem
            })
    }

    MainColumns=[[  
                 {
	                field:'rowid',
	                title:'ID',
	                width:80,
	                hidden: true
                },{
			     	field:'IsTwoUppDown',
					title:'有无两上两下',
					width:220,
					halign:"center",
					align:'center',
					formatter: function (value) {
					    if(value==1){
							return '<input type="checkbox" checked="checked" value="' + value + '"/>';
						}else{
							return '<input type="checkbox" value=""/>';
						}
                        
                    },
					editor:{type:'checkbox',options:{on:'1',off:'0'}}
				},{
					field:'IsEconomicItem',
					title:'有无经济科目',
					width:220,
					halign:"center",
					align:'center',
					formatter: function (value) {
						if(value==1){
							return '<input type="checkbox" checked="checked" value="' + value + '"/>';
						}else{
							return '<input type="checkbox" value=""/>';
						}
                        
                    },
					editor:{type:'checkbox', options:{on:'1',off:'0'}}
				}	
            ]];
    var MainGridObj = $HUI.datagrid("#MainGrid",{
        url:$URL,
        queryParams:{
            ClassName:"herp.budg.hisui.udata.uBudgInCharge",
            MethodName:"List",
            IsTwoUppDown :"",
            IsEconomicItem : ""
        },
        fitColumns: false,//列固定
        loadMsg:"正在加载，请稍等…",
        autoRowHeight: true,
        autoSizeColumn:true, //调整列的宽度以适应内容
        rownumbers:true,//行号
        singleSelect: true, 
        nowap : true,//禁止单元格中的文字自动换行
        pageSize:20,
        pageList:[10,20,30,50,100], //页面大小选择列表
        pagination:true,//分页
        fit:true,
        columns:MainColumns,
        onClickRow: onClickRow,  //在用户点击一行的时候触发
        onClickCell:function(index,field,value){   //在用户点击一个单元格的时候触发
            if ((field=="IsEconomicItem")) {
	            var rows = $('#MainGrid').datagrid('getRows');
	            var row = rows[index];
                var rowid=row.rowid;
                if(!rowid){
	                 var ed2 = $('#MainGrid').datagrid('getEditor', { 'index': index, 'field': 'IsEconomicItem' });
	                 $(ed2.target).attr("disabled", false);
	                }
	            else{
		            $('#MainGrid').datagrid('selectRow', index).datagrid('beginEdit', index);
		            var ed2 = $('#MainGrid').datagrid('getEditor', { 'index': index, 'field': 'IsEconomicItem' });
	                //console.log("ed2:"+ed2);
	                $(ed2.target).attr("disabled", true);
		            }
            }
        },
        toolbar: [
        	{
	        	id: 'Add',
            	iconCls: 'icon-add',
           		text: '新增',
            	handler: function(){
	            	add()
           		}
        	},{
	        	id: 'Save',
	        	iconCls: 'icon-save',
	        	text: '保存',
	        	handler: function(){
		        	save()
            	}
        	},{
	        	id: 'Del',
	        	iconCls: 'icon-cancel',
	        	text: '删除',
	        	handler: function(){
		        	delect()
		        }
        	},
        ]      
    }); 
		var editIndex = undefined;
  		var curTr;
  		var curTd;
  		var change;
  		
  		function endEditing(){
			if (editIndex == undefined){return true}
			if ($('#MainGrid').datagrid('validateRow', editIndex)){
                $('#MainGrid').datagrid('endEdit', editIndex);
				editIndex = undefined;
				return true;
			} else {
				return false;
			}
		}
		function onClickRow(index){
			if (editIndex != index){
				if (endEditing()){
					$('#MainGrid').datagrid('selectRow', index)
					$('#MainGrid').datagrid('beginEdit', index);
					var ed2 = $('#MainGrid').datagrid('getEditor', { 'index': index, 'field': 'IsEconomicItem' });
					$(ed2.target).focus(function(){
	                 $(ed2.target).attr("disabled", true);})
					editIndex = index;
			     } else {
					$('#MainGrid').datagrid('selectRow', editIndex);
				}
			}
		}

    	function save(){
	    	if($('#MainGrid').datagrid("getSelections").length==0&&($('#MainGrid').datagrid("getChecked").length==0)){
			$.messager.popover({
				 msg:'没有选中的记录！',
				 timeout: 2000,type:'alert',
				 showType: 'show',
				 style:{"position":"absolute","z-index":"9999",
				 left:-document.body.scrollTop - document.documentElement.scrollTop/2}})
				 return;
			}
			$.messager.confirm('确定','确定要保存选定的数据吗？',function(t){
            if(t){
	            // 关闭最后一个当前编辑行，否则最后一行的数据不会被getChanges方法捕获到
	            $('#MainGrid').datagrid('endEdit', editIndex);
	            var row = $('#MainGrid').datagrid("getSelected");        
		             
		              var rowid= row.rowid;
		              //保存前不能为空列的验证
		             if (saveAllowBlankVaild($('#MainGrid'),row)){
			             
		              var IsTwoUppDown=((row.IsTwoUppDown==undefined)?'':row.IsTwoUppDown);
		              var IsEconomicItem=((row.IsEconomicItem==undefined)?'':row.IsEconomicItem);
					  //console.log("IsTwoUppDown:"+IsTwoUppDown+",IsEconomicItem:"+IsEconomicItem);
		              // 后台处理数据时先显示一个提示框，防止用户多次点击【保存】重复提交数据
                      $.messager.progress({
	                      title: '提示',
	                      msg: '正在保存，请稍候……'
	                  });
		              if(!row.rowid){    //新增的行保存
			              $.m({
					          ClassName:'herp.budg.hisui.udata.uBudgInCharge',
					          MethodName:'Insert',
					         IsTwoUppDown :IsTwoUppDown,
                             IsEconomicItem : IsEconomicItem
					          }, 
					       function(SQLCODE){
						        if(SQLCODE==0){
							         $.messager.popover({
									      msg: '保存成功！',
									      type:'success',
									      style:{"position":"absolute","z-index":"9999",
									      left:-document.body.scrollTop - document.documentElement.scrollTop/2,
									      top:1}});
									 $.messager.progress('close');
					                 $('#MainGrid').datagrid("reload");
					                  }  else{
						              $.messager.popover({
										  msg: '保存失败！'+SQLCODE,
										  type:'error',
										  style:{"position":"absolute","z-index":"9999",
										  left:-document.body.scrollTop - document.documentElement.scrollTop/2,
										  top:1}});
								  	 $.messager.progress('close');
								  	 $('#MainGrid').datagrid("reload");
								  	 }
							});
			          }else{   //行数据修改
				          $.m({
					          ClassName:'herp.budg.hisui.udata.uBudgInCharge',
					          MethodName:'Update',
					          rowid:rowid,
					          IsTwoUppDown :IsTwoUppDown,
					          IsEconomicItem : IsEconomicItem
					          },
					          function(SQLCODE){
						          if(SQLCODE==0){
							          $.messager.popover({
									      msg: '保存成功！',
									      type:'success',
									      style:{"position":"absolute","z-index":"9999",
									      left:-document.body.scrollTop - document.documentElement.scrollTop/2,
									      top:1}});
							      	  $.messager.progress('close');
							      	  $('#MainGrid').datagrid("reload");
							      }else{
								      $.messager.popover({
										  msg: '保存失败！'+SQLCODE,
										  type:'error',
										  style:{"position":"absolute","z-index":"9999",
										  left:-document.body.scrollTop - document.documentElement.scrollTop/2,
										  top:1}});
								  	  $.messager.progress('close');
								  	  $('#MainGrid').datagrid("reload");
								  }  
					          }
							);
				      }
	                }
		        
                editIndex = undefined;               
                $("#MainGrid").datagrid("unselectAll"); //取消选择所有当前页中所有的行
                
            }
			})
	    }
     //点击查询按钮 
    $("#FindBtn").click(FindBtn); 
    
    
    //新增方法
    function add(IsTwoUppDown,IsEconomicItem)
    {
	    var row = $('#MainGrid').datagrid('getRows');  
    
    	if(row.length>0){
	    	$.messager.popover({
				 msg:'已有数据，不可新增！',
				 timeout: 2000,type:'alert',
				 showType: 'show',
				 style:{"position":"absolute","z-index":"9999",
				 left:-document.body.scrollTop - document.documentElement.scrollTop/2}})
				 return;
	    }else{
		    editIndex=append($('#MainGrid'),{IsCheck:'未审核'},editIndex)};
		}
    }
    //删除方法
    function delect(){
	    if($('#MainGrid').datagrid("getSelections").length==0&&($('#MainGrid').datagrid("getChecked").length==0)){
			      $.messager.popover({
				      msg:'没有选中的记录！',
				      timeout: 2000,type:'alert',
				      showType: 'show',
				      style:{"position":"absolute","z-index":"9999",
				      left:-document.body.scrollTop - document.documentElement.scrollTop/2,
				      top:1}})
				      return;
			}
			
		        	var row = $('#MainGrid').datagrid("getSelected");
	                var rowid= row.rowid; 
	          
		        	$.m({
			        	ClassName:'herp.budg.hisui.udata.uBudgInCharge',
			        	MethodName:'Delete',
			        	rowid :rowid,
					          }, 
				function(SQLCODE){
					if(SQLCODE==0){
			        	$.messager.popover({
				        	msg: '删除成功！',
				        	type:'success',
				        	style:{"position":"absolute","z-index":"9999",
				        	left:-document.body.scrollTop - document.documentElement.scrollTop/2,
				        	top:1}});
				        	$.messager.progress('close');
				        	$('#MainGrid').datagrid("reload");
				        	} else{
					    $.messager.popover({
						    msg: '删除失败！'+SQLCODE,
						    type:'error',
						    style:{"position":"absolute","z-index":"9999",
						    left:-document.body.scrollTop - document.documentElement.scrollTop/2,
						    top:1}});
						    $.messager.progress('close');
								  	 }
				})
				
    }
				    
       
