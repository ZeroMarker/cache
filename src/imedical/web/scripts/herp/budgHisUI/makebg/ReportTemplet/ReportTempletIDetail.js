$(function(){//初始化
$('#ReportItemCodeBox').val('')
$('#ReportItemNameBox').val('')
    Init();
}); 
function Init(){
	MainColumns=[[{
	     field:'ReportTempletDetailID',
	     hidden: true
	     },{
	     field:'ReportTempletID',
	     title:'会计报表模板ID',
	     hidden: true
	     },{
		 field:'ReportItemCode',
		 title:'报表项编码',
		 width:120,
		 align:'left',
		 halign:'left',
		 editor:{
		     type:'validatebox',
		     options:{
			     required:true,
			     validType:['a','b','c']
			     }}
		 },{
	     field:'ReportItemName',
	     title:'报表项名称',
	     width:280,
		 align:'left',
		 halign:'left',
		 editor:{
		     type:'validatebox',
		     options:{
			     required:true}}
	     },{
		 field:'FormulaDesc',
		 title:'项目公式描述',
		 width:300,
		 align:'left',
		 halign:'left',
		 editor:{type:'text',}
		 },{
		 field:'FormulaCode',
         title:'项目公式编码',
         width:300,
		 align:'left',
		 halign:'left',
		 hidden:true,
		 editor:{type:'text'}	
		 },{
	     field:'RowNo',
	     title:'所属行',
	     width:80,
	     align:'center',
	     halign:'center',
	     editor:{type:'text'}
	     },{
		 field:'ColNO',
		 title:'所属列',
		 width:80,
		 align:'center',
		 halign:'center',
		 editor:{type:'text'}
		 },{
		 field:'CompOrderNo',
		 title:'计算顺序',
		 width:80,
		 align:'center',
		 halign:'center',
		 editor:{type:'text'}
		 },{
		 field:'DispType',
		 title:'显示类型',
		 width:100, 
		 align:'center',
		 halign:'center',
		 formatter:comboboxFormatter,
		 editor:{
			 type:'combobox',
			 options:{
				 valueField:'rowid',
				 textField:'name',
				 data:[
				 {rowid:'0',name:'显示'},
				 {rowid:'1',name:'不显示'}],
				 }}
	     },{
	     field:'DispDistribution',
	     title:'显示分区',
	     width:80,
	     align:'left',
	     halign:'left',
	     editor:{type:'text'}
		 },{
		 field:'InitValue',
		 title:'默认值',
		 width:100,
		 align:'left',
		 halign:'left',
		 editor:{type:'text'}
		 }]]
		     		 
		 
   //验证框
   $(function(){
	   $.extend($.fn.validatebox.defaults.rules,{         
		  a:{validator : 
		     function(value) {
			     var num=value.indexOf($('#MainGrid').datagrid("getSelected").ReportCode+"-");
				   if(num!=0){
					  $.fn.validatebox.defaults.rules.a.message = '请保持与报表编码一致！';
					 return false;
					   }else{
					 return true;
					 }}},
		  b:{validator : 
			  function(value) {	
			    var lenD=value.length;
		        var lenM=$('#MainGrid').datagrid("getSelected").ReportCode.length;
					 if(lenD-lenM-1!=4){
					  $.fn.validatebox.defaults.rules.b.message = '请添加四位数字！';
					 return false;
					   }else{
					 return true;
					 }}},
		  c:{validator :
			  function(value) {
				  var lenM=$('#MainGrid').datagrid("getSelected").ReportCode.length;	 
				  var str = value.substring(lenM);
						 if(isNaN(str)){
					  $.fn.validatebox.defaults.rules.c.message = '请添加四位数字！';
					 return false;
					   }else{
					 return true;}}}
				   })
				   });

	  var detailtableObj = $HUI.datagrid("#DetailGrid",{
        url:$URL,
        fitColumns: false,//列固定
        loadMsg:"正在加载，请稍等…",
        autoRowHeight: true,
        autoSizeColumn:true, //调整列的宽度以适应内容
        rownumbers:true,//行号
        singleSelect: true, 
        checkOnSelect : true,//如果设置为 true，当用户点击某一行时，则会选中/取消选中复选框。如果设置为 false 时，只有当用户点击了复选框时，才会选中/取消选中复选框。
        selectOnCheck : true,//如果设置为 true，点击复选框将会选中该行。如果设置为 false，选中该行将不会选中复选框
        nowrap : true,//禁止单元格中的文字自动换行
        pageSize:20,
        pageList:[10,20,30,50,100], //页面大小选择列表
        pagination:true,//分页
        fit:true,
        //onClickRow:onClickRow,
        toolbar: '#dtb',
        columns:MainColumns,
        onClickCell:onClickCell
        })
                      
   //点击单元格触发单元格编辑
     var editIndex = undefined;
        function endEditing(){
			if (editIndex == undefined){
				return true}
			if ($('#DetailGrid').datagrid('validateRow', editIndex)){
				$('#DetailGrid').datagrid('endEdit', editIndex);
				editIndex = undefined;
				return true;
			} else {
				return false;
			}
		}
        function onClickCell(index,field){
	        var row = $('#MainGrid').datagrid('getSelected');
	        if(row.ReortStatus=="审核"){
	                  return;
	        }else{
				if (endEditing()){
					$('#DetailGrid').datagrid('selectRow', index)
					$('#DetailGrid').datagrid('editCell', {index:index,field:field});
					editIndex = index;
				if(field=="FormulaDesc"){	
					var cellEdit = $('#DetailGrid').datagrid("getEditor",{index:index,field:"FormulaDesc"});
					$(cellEdit.target).prop('disabled',true);
					var oldFormula=$('#DetailGrid').datagrid('getSelected').FormulaDesc
		            formula(oldFormula,index,$("#DetailGrid"),"FormulaDesc","FormulaCode")}
				} else {
					$('#DetailGrid').datagrid('selectRow', editIndex);
				}
			}     
		} 

    // 查询 
  $("#DetailFindBtn").click(function(){
	  var row=$('#MainGrid').datagrid("getSelected");
	  if(row==null){
		  $.messager.popover({
		      msg:'请先选择报表！',
		      timeout: 2000,type:'alert',
		      showType: 'show',
		      style:{"position":"absolute","z-index":"9999",
			         left:-document.body.scrollTop - document.documentElement.scrollTop/2,
			         top:1}})
			         return;
		  }
	    var ReportItemCode   = $('#ReportItemCodeBox').val()
        var ReportItemName   = $('#ReportItemNameBox').val()
         
        detailtableObj.load({
                ClassName: "herp.budg.hisui.udata.uReportTemplet",
                MethodName: "DetailList",
                ReportTempletID:row.rowid, 
                ReportItemCode : ReportItemCode,
                ReportItemName : ReportItemName,
            })});
      //删除
  $("#DDelBn").click(function() {
	 var row = $('#DetailGrid').datagrid('getSelected');
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
			        	ClassName:'herp.budg.hisui.udata.uReportTemplet',
			        	MethodName:'DetailDelete',
			        	rowid : rowid,
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
		                $("#DetailGrid").datagrid("reload");
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
		       editIndex= $('#DetailGrid').datagrid('getRows').length-1;
		       $('#DetailGrid').datagrid('cancelEdit', editIndex).datagrid('deleteRow', editIndex);  
		      }
	      }
		    
  })
}})
//新增
  $("#DAddBn").click(function(){
	  var row=$('#MainGrid').datagrid("getSelected");
	  if(row==null){
		  $.messager.popover({
		      msg:'请先选择报表！',
		      timeout: 2000,type:'alert',
		      showType: 'show',
		      style:{"position":"absolute","z-index":"9999",
			         left:-document.body.scrollTop - document.documentElement.scrollTop/2,
			         top:1}})
			         return;
	}else if(row.ReortStatus=="审核"){
		$.messager.popover({
		      msg:'主表已审核，不可增加报表项！',
		      timeout: 2000,type:'alert',
		      showType: 'show',
		      style:{"position":"absolute","z-index":"9999",
			         left:-document.body.scrollTop - document.documentElement.scrollTop/2,
			         top:1}})
			         return;
    }else{
	  if (endEditing()){
		  $('#DetailGrid').datagrid('appendRow',{ReportItemCode:row.ReportCode+"-"});
		  editIndex = $('#MainGrid').datagrid('getRows').length;
		  $('#DetailGrid').datagrid('selectRow',editIndex)
		  }}})     


 //保存
  $("#DSaveBn").click(function(){
	 $('#DetailGrid').datagrid('endEdit', editIndex);
	 //alert(editIndex);
     if($('#DetailGrid').datagrid("getChanges").length==0){
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
		     var rows = $('#DetailGrid').datagrid("getChanges");
		     //console.log("row:"+JSON.stringify(rows));
		     if(rows.length>0){
	                for(var i=0; i<rows.length; i++){
		                var row=rows[i]; 
		                var rowid= row.rowid;
		                var ReportTempletID="";
		              if(!row.rowid){
			              ReportTempletID=($('#MainGrid').datagrid("getSelected")).rowid
			          }else{
			              ReportTempletID=row.ReportTempletID
			              };
		              var ReportItemCode=((row.ReportItemCode==undefined)?'':row.ReportItemCode);
		              var ReportItemName=((row.ReportItemName==undefined)?'':row.ReportItemName);
		              var FormulaCode=((row.FormulaCode==undefined)?'':row.FormulaCode);
		              var RowNo=((row.RowNo==undefined)?'':row.RowNo);
		              var ColNO=((row.ColNO==undefined)?'':row.ColNO);
		              var InitValue=((row.InitValue==undefined)?'':row.InitValue);
		              var CompOrderNo=((row.CompOrderNo==undefined)?'':row.CompOrderNo);
		              var DispType=((row.DispType==undefined)?'':row.DispType);
		              var DispDistribution=((row.DispDistribution==undefined)?'':row.DispDistribution);
		              var FormulaDesc=((row.FormulaDesc==undefined)?'':row.FormulaDesc);

		             if(!ReportItemCode){
			             $.messager.popover({
				             msg: '报表项编码不能为空',
						     type:'alert',
				             style:{"position":"absolute","z-index":"9999",
	        		                left:-document.body.scrollTop - document.documentElement.scrollTop/2,
	        		                top:1}
						        	})
						        	return;
						        }
					 if(!ReportItemName){
			             $.messager.popover({
				             msg: '报表项名称不能为空',
						     type:'alert',
				             style:{"position":"absolute","z-index":"9999",
	        		                left:-document.body.scrollTop - document.documentElement.scrollTop/2,
	        		                top:1}
						        	})
						        	return;
						        }
				     
                     var data=ReportTempletID+"|"+ReportItemCode+"|"+ReportItemName+"|"+FormulaCode
		                      +"|"+RowNo+"|"+ColNO+"|"+InitValue
		              	      +"|"+CompOrderNo+"|"+DispType+"|"+DispDistribution+"|"+FormulaDesc
		              $.messager.progress({
	                      title: '提示',
	                      msg: '正在保存，请稍候……'
	                  })
	                  if(!row.rowid){//新增
		              $.m({
			              ClassName:'herp.budg.hisui.udata.uReportTemplet',
					      MethodName:'DetailInsert',
					      data:data
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
							      	  $('#DetailGrid').datagrid("reload");
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
						   ClassName:'herp.budg.hisui.udata.uReportTemplet',
			               MethodName:'DetailUpdate',
				           rowid:rowid,
				           data:data
				           },
		                  function(SQLCODE){
			                  if(SQLCODE==0){
				     			$.messager.popover({
					    			 msg: '保存成功！',
					     			 type:'success',
					     			 style:{"position":"absolute","z-index":"9999",
								     		left:-document.body.scrollTop - document.documentElement.scrollTop/2,
		                         			top:1}});
		                	$('#DetailGrid').datagrid("reload");
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
                $("#DetailGrid").datagrid("unselectAll"); //取消选择所有当前页中所有的行
	                 }
	          }else{return}
	     }})
	  })     
        
   }