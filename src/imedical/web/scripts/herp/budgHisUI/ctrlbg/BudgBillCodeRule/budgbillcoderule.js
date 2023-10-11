var userid = session['LOGON.USERID'];
var hospid= session['LOGON.HOSPID'];
$(function(){//初始化
    Init();
});
function Init(){ 
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
	                field:'Rule',
	                title:'规则定义',
	                align:'left',
		            halign:'left',
	                width:450,
	                editor: {
		                type:'text',
		                 
		                } 
                },
                {
	                field:'RuleDesc',
	                title:'规则描述',
	                align:'left',
		            halign:'left',
	                width:450,
	                editor:{type:'text'        
                }
                },
                {
	                field:'BillType',
	                title:'单据类型',
	                align:'left',
		            halign:'left',
		            required:true,
	                width:150,
	                formatter:function(value,row,index){
		                if(value==1){
			                return "项目报销单"
		                }else if(value==2){
			                return "项目资金申请单"
		                }else if(value==3){
			                return "一般支出报销单"
		                }else if(value==4){
			                return "一般支出资金申请单"
		                }else if(value==5){
			                return "一般支出预报销"
		                } 
		    			
		    			},
	                editor:{type:'combobox',
	                        options:{
	                        valueField:'id', 
	                        textField:'text',
	                        required:true,
	                        data:[
			                      {id:'1',text:'项目报销单'}
			                      ,{id:'2',text:'项目资金申请单'}
			                      ,{id:'3',text:'一般支出报销单'}
			                      ,{id:'4',text:'一般支出资金申请单'}
			                      ,{id:'5',text:'一般支出预报销'}
		                          ]
	                        }
	                }
                },
                {
	                field:'Table',
	                title:'单号对应的表',
	                align:'left',
	                halign:'left',
	                width:150,
	                editor:{
		                type:'combobox',
		                options:{
			                
			                valueField:'id', 
	                        textField:'text',
	                        data:[
	                        { id:'BudgPayBillMain',text:'BudgPayBillMain'},
	                        { id:'BudgCtrlFundBillMain',text:'BudgCtrlFundBillMain'},
	                        { id:'BudgCtrlPayBillMain',text:'BudgCtrlPayBillMain'},
	                        { id:'BudgProjectDict',text:'BudgProjectDict'},
	                        { id:'BudgCtrlPrePayBillMain',text:'BudgCtrlPrePayBillMain'}
	                        ]
			                
			                }
		                
		                }
	                } 
                
            ]];
    var MainGridObj = $HUI.datagrid("#MainGrid",{
        url:$URL,
        queryParams:{
            ClassName:"herp.budg.hisui.udata.uBudgBillCodeRule",
            MethodName:"List",
            hospid :    hospid, 
            Rule :      "",
            RuleDesc :      "", 
            BillType :      "",
            Table:          ""
        },
        fitColumns: false,//列固定
        loadMsg:"正在加载，请稍等…",
        autoRowHeight: true,
        autoSizeColumn:true, //调整列的宽度以适应内容
        rownumbers:true,//行号
        singleSelect: false, 
        checkOnSelect : true,//如果设置为 true，当用户点击某一行时，则会选中/取消选中复选框。如果设置为 false 时，只有当用户点击了复选框时，才会选中/取消选中复选框。
        selectOnCheck : true,//如果设置为 true，点击复选框将会选中该行。如果设置为 false，选中该行将不会选中复选框
        nowrap : true,//禁止单元格中的文字自动换行
        pageSize:20,
        pageList:[10,20,30,50,100], //页面大小选择列表
        pagination:true,//分页
        fit:true,
        //onClickRow:onClickRow,
        toolbar: '#tb',
        columns:MainColumns,
        onClickCell:onClickCell    
    }); 
    
    
    //点击单元格触发单元格编辑
     var editIndex = undefined;
        function endEditing(){
			if (editIndex == undefined){
				return true}
			if ($('#MainGrid').datagrid('validateRow', editIndex)){
				$('#MainGrid').datagrid('endEdit', editIndex);
				editIndex = undefined;
				return true;
			} else {
				return false;
			}
		}
        function onClickCell(index,field){
	            if(field=="RuleDesc"){
			            //alert("ok")
				        return false 
			         }
				if (endEditing()){
					$('#MainGrid').datagrid('selectRow', index)
					$('#MainGrid').datagrid('editCell', {index:index,field:field});
					editIndex = index;
				if(field=="Rule"){	
					var cellEdit = $('#MainGrid').datagrid("getEditor",{index:index,field:"Rule"});
					$(cellEdit.target).prop('disabled',true);
					var oldFormula=$('#MainGrid').datagrid('getSelected').FormulaDesc
		            formula(oldFormula,index,$("#MainGrid"),"Rule","RuleDesc")} 
		               
				} else {
					$('#MainGrid').datagrid('selectRow', editIndex);
				}
			     
		}
		
////删除
  $("#DelBn").click(function() {
	 var row = $('#MainGrid').datagrid('getSelected');
	 //console.log("row:"+JSON.stringify(row))
	 if(row == null){
		   $.messager.popover({
		        msg:'请选择所要删除的行！',
		        timeout: 2000,type:'alert',
		        showType: 'show',
		        style:{"position":"absolute","z-index":"9999",
		               left:-document.body.scrollTop - document.documentElement.scrollTop/2,
		               top:1}}); 
                return;
      }else{
	      var rowid = row.rowid
	      $.messager.confirm('确定','确认删除吗？',function(t){
		      if(t){
			      if(rowid>0){
			      $.m({
			        	ClassName:'herp.budg.hisui.udata.uBudgBillCodeRule',
			        	MethodName:'Delete',
			        	rowid : rowid
					          },
				function(SQLCODE){
					$.messager.progress({
	                      title: '提示',
	                      msg: '正在删除，请稍候……'
	                  });
	                  if(SQLCODE==0){
			        	$.messager.popover({
				        	msg: '删除成功！',
				        	type:'success',
				        	style:{"position":"absolute","z-index":"9999",
				        	left:-document.body.scrollTop - document.documentElement.scrollTop/2,
				        	top:1}});
				        $.messager.progress('close');
		                $("#MainGrid").datagrid("reload");
		                } else{
					    $.messager.popover({
						    msg: '删除失败！'+SQLCODE,
						    type:'error',
						    style:{"position":"absolute","z-index":"9999",
						    left:-document.body.scrollTop - document.documentElement.scrollTop/2,
						    top:1}})
						    $.messager.progress('close');
						    }  
		      })
	      }else{
		       editIndex= $('#MainGrid').datagrid('getRows').length-1;
		       $('#MainGrid').datagrid('cancelEdit', editIndex).datagrid('deleteRow', editIndex);  
		      }
	      }
		    
  })
}})

//新增
  $("#AddBn").click(function(){
	  
	  /**if (endEditing()) {
			$('#MainGrid').datagrid('appendRow', {
				IsLast: 0
			});
		editIndex = $('#MainGrid').datagrid('getRows').length - 1;
		$('#MainGrid').datagrid('selectRow', editIndex).datagrid('beginEdit', editIndex);	
		}**/
	  
	  if (endEditing()){
		  $('#MainGrid').datagrid('appendRow',{});
		  editIndex = $('#MainGrid').datagrid('getRows').length;
		  $('#MainGrid').datagrid('selectRow',editIndex)
		  }})
		

//保存
  $("#SaveBn").click(function(){
	 $('#MainGrid').datagrid('endEdit', editIndex);
	 //alert(editIndex);
     if($('#MainGrid').datagrid("getChanges").length==0){
	     $.messager.popover({
		      msg:'没有需要保存的记录！',
		      timeout: 2000,type:'alert',
		      showType: 'show',
		      style:{"position":"absolute","z-index":"9999",
			         left:-document.body.scrollTop - document.documentElement.scrollTop/2,
			         top:1}})
			         return;
			
	     }
	     $.messager.confirm('确定','确定要保存选定的数据吗？',function(t){
		     if(t){
		     var rows = $('#MainGrid').datagrid("getChanges");
		     //console.log("row:"+JSON.stringify(rows));
		     if(rows.length>0){
	                for(var i=0; i<rows.length; i++){
		                var row=rows[i]; 
		                 rowid= row.rowid;
		                 CompDR=hospid;
		                 Rule=row.Rule;
		                 RuleDesc=row.RuleDesc;
		                 BillType=row.BillType;
		                 Table=row.Table; 
		              $.messager.progress({
	                      title: '提示',
	                      msg: '正在保存，请稍候……'
	                  })
	                  if(!row.rowid){//新增
		              $.m({
			              ClassName:'herp.budg.hisui.udata.uBudgBillCodeRule',
					      MethodName:'InsertRec',
					      BillType:BillType,
					      Rule:Rule,
					      RuleDesc:RuleDesc,
					      Table:Table, 
					      CompDR:CompDR
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
							      	  editIndex = undefined;
							          }else{
								          $.messager.popover({
												msg: '保存失败'+SQLCODE,
												type:'error',
												style:{"position":"absolute","z-index":"9999",
												left:-document.body.scrollTop - document.documentElement.scrollTop/2,
												top:1}
												})
										   $.messager.progress('close'); 
								      
								      }})
		               }else{//行数据修改
			           $.m({
						   ClassName:'herp.budg.hisui.udata.uBudgBillCodeRule',
			               MethodName:'UpDateRec',
				           rowid:rowid,
				           BillType:BillType,
					       Rule:Rule,
					       RuleDesc:RuleDesc,
					       Table:Table, 
					       CompDR:CompDR
				           },
		                  function(SQLCODE){
			                  if(SQLCODE==0){
				     			$.messager.popover({
					    			 msg: '保存成功！',
					     			 type:'success',
					     			 style:{"position":"absolute","z-index":"9999",
								     		left:-document.body.scrollTop - document.documentElement.scrollTop/2,
		                         			top:1}});
		                	$('#MainGrid').datagrid("reload");
							$.messager.progress('close');
				  		}else{
					  		$.messager.popover({
						  		msg: '保存失败'+SQLCODE,
						  		type:'error',
						  		style:{"position":"absolute","z-index":"9999",
						        		left:-document.body.scrollTop - document.documentElement.scrollTop/2,
								 		top:1}})}
							 $.messager.progress('close');
						     });		
						}
	            editIndex = undefined;               
                $("#MainGrid").datagrid("unselectAll"); //取消选择所有当前页中所有的行
	                 }
	          }else{return}
	     }})
	  })    
		
		
	}