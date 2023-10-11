var userid = session['LOGON.USERID'];
var hospid= session['LOGON.HOSPID'];
$(function(){//��ʼ��
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
	                title:'ҽԺID',
	                width:80,
	                hidden: true
                },
                {
	                field:'Rule',
	                title:'������',
	                align:'left',
		            halign:'left',
	                width:450,
	                editor: {
		                type:'text',
		                 
		                } 
                },
                {
	                field:'RuleDesc',
	                title:'��������',
	                align:'left',
		            halign:'left',
	                width:450,
	                editor:{type:'text'        
                }
                },
                {
	                field:'BillType',
	                title:'��������',
	                align:'left',
		            halign:'left',
		            required:true,
	                width:150,
	                formatter:function(value,row,index){
		                if(value==1){
			                return "��Ŀ������"
		                }else if(value==2){
			                return "��Ŀ�ʽ����뵥"
		                }else if(value==3){
			                return "һ��֧��������"
		                }else if(value==4){
			                return "һ��֧���ʽ����뵥"
		                }else if(value==5){
			                return "һ��֧��Ԥ����"
		                } 
		    			
		    			},
	                editor:{type:'combobox',
	                        options:{
	                        valueField:'id', 
	                        textField:'text',
	                        required:true,
	                        data:[
			                      {id:'1',text:'��Ŀ������'}
			                      ,{id:'2',text:'��Ŀ�ʽ����뵥'}
			                      ,{id:'3',text:'һ��֧��������'}
			                      ,{id:'4',text:'һ��֧���ʽ����뵥'}
			                      ,{id:'5',text:'һ��֧��Ԥ����'}
		                          ]
	                        }
	                }
                },
                {
	                field:'Table',
	                title:'���Ŷ�Ӧ�ı�',
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
        fitColumns: false,//�й̶�
        loadMsg:"���ڼ��أ����Եȡ�",
        autoRowHeight: true,
        autoSizeColumn:true, //�����еĿ������Ӧ����
        rownumbers:true,//�к�
        singleSelect: false, 
        checkOnSelect : true,//�������Ϊ true�����û����ĳһ��ʱ�����ѡ��/ȡ��ѡ�и�ѡ���������Ϊ false ʱ��ֻ�е��û�����˸�ѡ��ʱ���Ż�ѡ��/ȡ��ѡ�и�ѡ��
        selectOnCheck : true,//�������Ϊ true�������ѡ�򽫻�ѡ�и��С��������Ϊ false��ѡ�и��н�����ѡ�и�ѡ��
        nowrap : true,//��ֹ��Ԫ���е������Զ�����
        pageSize:20,
        pageList:[10,20,30,50,100], //ҳ���Сѡ���б�
        pagination:true,//��ҳ
        fit:true,
        //onClickRow:onClickRow,
        toolbar: '#tb',
        columns:MainColumns,
        onClickCell:onClickCell    
    }); 
    
    
    //�����Ԫ�񴥷���Ԫ��༭
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
		
////ɾ��
  $("#DelBn").click(function() {
	 var row = $('#MainGrid').datagrid('getSelected');
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
			        	ClassName:'herp.budg.hisui.udata.uBudgBillCodeRule',
			        	MethodName:'Delete',
			        	rowid : rowid
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
		                $("#MainGrid").datagrid("reload");
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
		       editIndex= $('#MainGrid').datagrid('getRows').length-1;
		       $('#MainGrid').datagrid('cancelEdit', editIndex).datagrid('deleteRow', editIndex);  
		      }
	      }
		    
  })
}})

//����
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
		

//����
  $("#SaveBn").click(function(){
	 $('#MainGrid').datagrid('endEdit', editIndex);
	 //alert(editIndex);
     if($('#MainGrid').datagrid("getChanges").length==0){
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
	                      title: '��ʾ',
	                      msg: '���ڱ��棬���Ժ򡭡�'
	                  })
	                  if(!row.rowid){//����
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
								          msg: '����ɹ���',
								          type:'success',
								           style:{"position":"absolute","z-index":"9999",
								                 left:-document.body.scrollTop - document.documentElement.scrollTop/2,
		                                         top:1}});
							      	  $.messager.progress('close');
							      	  $('#MainGrid').datagrid("reload");
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
					    			 msg: '����ɹ���',
					     			 type:'success',
					     			 style:{"position":"absolute","z-index":"9999",
								     		left:-document.body.scrollTop - document.documentElement.scrollTop/2,
		                         			top:1}});
		                	$('#MainGrid').datagrid("reload");
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
                $("#MainGrid").datagrid("unselectAll"); //ȡ��ѡ�����е�ǰҳ�����е���
	                 }
	          }else{return}
	     }})
	  })    
		
		
	}