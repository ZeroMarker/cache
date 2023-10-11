$(function(){//��ʼ��
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
	     title:'��Ʊ���ģ��ID',
	     hidden: true
	     },{
		 field:'ReportItemCode',
		 title:'���������',
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
	     title:'����������',
	     width:280,
		 align:'left',
		 halign:'left',
		 editor:{
		     type:'validatebox',
		     options:{
			     required:true}}
	     },{
		 field:'FormulaDesc',
		 title:'��Ŀ��ʽ����',
		 width:300,
		 align:'left',
		 halign:'left',
		 editor:{type:'text',}
		 },{
		 field:'FormulaCode',
         title:'��Ŀ��ʽ����',
         width:300,
		 align:'left',
		 halign:'left',
		 hidden:true,
		 editor:{type:'text'}	
		 },{
	     field:'RowNo',
	     title:'������',
	     width:80,
	     align:'center',
	     halign:'center',
	     editor:{type:'text'}
	     },{
		 field:'ColNO',
		 title:'������',
		 width:80,
		 align:'center',
		 halign:'center',
		 editor:{type:'text'}
		 },{
		 field:'CompOrderNo',
		 title:'����˳��',
		 width:80,
		 align:'center',
		 halign:'center',
		 editor:{type:'text'}
		 },{
		 field:'DispType',
		 title:'��ʾ����',
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
				 {rowid:'0',name:'��ʾ'},
				 {rowid:'1',name:'����ʾ'}],
				 }}
	     },{
	     field:'DispDistribution',
	     title:'��ʾ����',
	     width:80,
	     align:'left',
	     halign:'left',
	     editor:{type:'text'}
		 },{
		 field:'InitValue',
		 title:'Ĭ��ֵ',
		 width:100,
		 align:'left',
		 halign:'left',
		 editor:{type:'text'}
		 }]]
		     		 
		 
   //��֤��
   $(function(){
	   $.extend($.fn.validatebox.defaults.rules,{         
		  a:{validator : 
		     function(value) {
			     var num=value.indexOf($('#MainGrid').datagrid("getSelected").ReportCode+"-");
				   if(num!=0){
					  $.fn.validatebox.defaults.rules.a.message = '�뱣���뱨�����һ�£�';
					 return false;
					   }else{
					 return true;
					 }}},
		  b:{validator : 
			  function(value) {	
			    var lenD=value.length;
		        var lenM=$('#MainGrid').datagrid("getSelected").ReportCode.length;
					 if(lenD-lenM-1!=4){
					  $.fn.validatebox.defaults.rules.b.message = '�������λ���֣�';
					 return false;
					   }else{
					 return true;
					 }}},
		  c:{validator :
			  function(value) {
				  var lenM=$('#MainGrid').datagrid("getSelected").ReportCode.length;	 
				  var str = value.substring(lenM);
						 if(isNaN(str)){
					  $.fn.validatebox.defaults.rules.c.message = '�������λ���֣�';
					 return false;
					   }else{
					 return true;}}}
				   })
				   });

	  var detailtableObj = $HUI.datagrid("#DetailGrid",{
        url:$URL,
        fitColumns: false,//�й̶�
        loadMsg:"���ڼ��أ����Եȡ�",
        autoRowHeight: true,
        autoSizeColumn:true, //�����еĿ������Ӧ����
        rownumbers:true,//�к�
        singleSelect: true, 
        checkOnSelect : true,//�������Ϊ true�����û����ĳһ��ʱ�����ѡ��/ȡ��ѡ�и�ѡ���������Ϊ false ʱ��ֻ�е��û�����˸�ѡ��ʱ���Ż�ѡ��/ȡ��ѡ�и�ѡ��
        selectOnCheck : true,//�������Ϊ true�������ѡ�򽫻�ѡ�и��С��������Ϊ false��ѡ�и��н�����ѡ�и�ѡ��
        nowrap : true,//��ֹ��Ԫ���е������Զ�����
        pageSize:20,
        pageList:[10,20,30,50,100], //ҳ���Сѡ���б�
        pagination:true,//��ҳ
        fit:true,
        //onClickRow:onClickRow,
        toolbar: '#dtb',
        columns:MainColumns,
        onClickCell:onClickCell
        })
                      
   //�����Ԫ�񴥷���Ԫ��༭
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
	        if(row.ReortStatus=="���"){
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

    // ��ѯ 
  $("#DetailFindBtn").click(function(){
	  var row=$('#MainGrid').datagrid("getSelected");
	  if(row==null){
		  $.messager.popover({
		      msg:'����ѡ�񱨱�',
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
      //ɾ��
  $("#DDelBn").click(function() {
	 var row = $('#DetailGrid').datagrid('getSelected');
	 //console.log("row:"+JSON.stringify(row))
	 if(row == null){
		   $.messager.popover({
		        msg:'��ѡ����Ҫɾ�����У�',
		        timeout: 2000,type:'alert',
		        showType: 'show',
		        style:{"position":"absolute","z-index":"9999",
		               left:-document.body.scrollTop - document.documentElement.scrollTop/2,
		               top:1}}); 
                return;
      }else{
	      var rowid = row.rowid
	      $.messager.confirm('ȷ��','ȷ��ɾ����',function(t){
		      if(t){
			      if(rowid>0){
			      $.m({
			        	ClassName:'herp.budg.hisui.udata.uReportTemplet',
			        	MethodName:'DetailDelete',
			        	rowid : rowid,
					          },
				function(SQLCODE){
					$.messager.progress({
	                      title: '��ʾ',
	                      msg: '����ɾ�������Ժ򡭡�'
	                  });
	                  if(SQLCODE==0){
			        	$.messager.popover({
				        	msg: 'ɾ���ɹ���',
				        	type:'success',
				        	style:{"position":"absolute","z-index":"9999",
				        	left:-document.body.scrollTop - document.documentElement.scrollTop/2,
				        	top:1}});
				        $.messager.progress('close');
		                $("#DetailGrid").datagrid("reload");
		                } else{
					    $.messager.popover({
						    msg: 'ɾ��ʧ�ܣ�'+SQLCODE,
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
//����
  $("#DAddBn").click(function(){
	  var row=$('#MainGrid').datagrid("getSelected");
	  if(row==null){
		  $.messager.popover({
		      msg:'����ѡ�񱨱�',
		      timeout: 2000,type:'alert',
		      showType: 'show',
		      style:{"position":"absolute","z-index":"9999",
			         left:-document.body.scrollTop - document.documentElement.scrollTop/2,
			         top:1}})
			         return;
	}else if(row.ReortStatus=="���"){
		$.messager.popover({
		      msg:'��������ˣ��������ӱ����',
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


 //����
  $("#DSaveBn").click(function(){
	 $('#DetailGrid').datagrid('endEdit', editIndex);
	 //alert(editIndex);
     if($('#DetailGrid').datagrid("getChanges").length==0){
	     $.messager.popover({
		      msg:'û����Ҫ����ļ�¼��',
		      timeout: 2000,type:'alert',
		      showType: 'show',
		      style:{"position":"absolute","z-index":"9999",
			         left:-document.body.scrollTop - document.documentElement.scrollTop/2,
			         top:1}})
			         return;
			
	     }
	     $.messager.confirm('ȷ��','ȷ��Ҫ����ѡ����������',function(t){
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
				             msg: '��������벻��Ϊ��',
						     type:'alert',
				             style:{"position":"absolute","z-index":"9999",
	        		                left:-document.body.scrollTop - document.documentElement.scrollTop/2,
	        		                top:1}
						        	})
						        	return;
						        }
					 if(!ReportItemName){
			             $.messager.popover({
				             msg: '���������Ʋ���Ϊ��',
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
	                      title: '��ʾ',
	                      msg: '���ڱ��棬���Ժ򡭡�'
	                  })
	                  if(!row.rowid){//����
		              $.m({
			              ClassName:'herp.budg.hisui.udata.uReportTemplet',
					      MethodName:'DetailInsert',
					      data:data
					          },
					      function(SQLCODE){
						          if(SQLCODE==0){
							          $.messager.popover({
								          msg: '����ɹ���',
								          type:'success',
								           style:{"position":"absolute","z-index":"9999",
								                 left:-document.body.scrollTop - document.documentElement.scrollTop/2,
		                                         top:1}});
							      	  $.messager.progress('close');
							      	  $('#DetailGrid').datagrid("reload");
							      	  editIndex = undefined;
							          }else{
								          $.messager.popover({
												msg: '����ʧ��'+SQLCODE,
												type:'error',
												style:{"position":"absolute","z-index":"9999",
												left:-document.body.scrollTop - document.documentElement.scrollTop/2,
												top:1}
												})
										   $.messager.progress('close'); 
								      
								      }})
		               }else{//�������޸�
			           $.m({
						   ClassName:'herp.budg.hisui.udata.uReportTemplet',
			               MethodName:'DetailUpdate',
				           rowid:rowid,
				           data:data
				           },
		                  function(SQLCODE){
			                  if(SQLCODE==0){
				     			$.messager.popover({
					    			 msg: '����ɹ���',
					     			 type:'success',
					     			 style:{"position":"absolute","z-index":"9999",
								     		left:-document.body.scrollTop - document.documentElement.scrollTop/2,
		                         			top:1}});
		                	$('#DetailGrid').datagrid("reload");
							$.messager.progress('close');
				  		}else{
					  		$.messager.popover({
						  		msg: '����ʧ��'+SQLCODE,
						  		type:'error',
						  		style:{"position":"absolute","z-index":"9999",
						        		left:-document.body.scrollTop - document.documentElement.scrollTop/2,
								 		top:1}})}
							 $.messager.progress('close');
						     });		
						}
	            editIndex = undefined;               
                $("#DetailGrid").datagrid("unselectAll"); //ȡ��ѡ�����е�ǰҳ�����е���
	                 }
	          }else{return}
	     }})
	  })     
        
   }