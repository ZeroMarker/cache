$(function(){//��ʼ��
    Init();
}); 
function Init(){
     //��ѯ����
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
					title:'������������',
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
					title:'���޾��ÿ�Ŀ',
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
        fitColumns: false,//�й̶�
        loadMsg:"���ڼ��أ����Եȡ�",
        autoRowHeight: true,
        autoSizeColumn:true, //�����еĿ������Ӧ����
        rownumbers:true,//�к�
        singleSelect: true, 
        nowap : true,//��ֹ��Ԫ���е������Զ�����
        pageSize:20,
        pageList:[10,20,30,50,100], //ҳ���Сѡ���б�
        pagination:true,//��ҳ
        fit:true,
        columns:MainColumns,
        onClickRow: onClickRow,  //���û����һ�е�ʱ�򴥷�
        onClickCell:function(index,field,value){   //���û����һ����Ԫ���ʱ�򴥷�
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
           		text: '����',
            	handler: function(){
	            	add()
           		}
        	},{
	        	id: 'Save',
	        	iconCls: 'icon-save',
	        	text: '����',
	        	handler: function(){
		        	save()
            	}
        	},{
	        	id: 'Del',
	        	iconCls: 'icon-cancel',
	        	text: 'ɾ��',
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
				 msg:'û��ѡ�еļ�¼��',
				 timeout: 2000,type:'alert',
				 showType: 'show',
				 style:{"position":"absolute","z-index":"9999",
				 left:-document.body.scrollTop - document.documentElement.scrollTop/2}})
				 return;
			}
			$.messager.confirm('ȷ��','ȷ��Ҫ����ѡ����������',function(t){
            if(t){
	            // �ر����һ����ǰ�༭�У��������һ�е����ݲ��ᱻgetChanges��������
	            $('#MainGrid').datagrid('endEdit', editIndex);
	            var row = $('#MainGrid').datagrid("getSelected");        
		             
		              var rowid= row.rowid;
		              //����ǰ����Ϊ���е���֤
		             if (saveAllowBlankVaild($('#MainGrid'),row)){
			             
		              var IsTwoUppDown=((row.IsTwoUppDown==undefined)?'':row.IsTwoUppDown);
		              var IsEconomicItem=((row.IsEconomicItem==undefined)?'':row.IsEconomicItem);
					  //console.log("IsTwoUppDown:"+IsTwoUppDown+",IsEconomicItem:"+IsEconomicItem);
		              // ��̨��������ʱ����ʾһ����ʾ�򣬷�ֹ�û���ε�������桿�ظ��ύ����
                      $.messager.progress({
	                      title: '��ʾ',
	                      msg: '���ڱ��棬���Ժ򡭡�'
	                  });
		              if(!row.rowid){    //�������б���
			              $.m({
					          ClassName:'herp.budg.hisui.udata.uBudgInCharge',
					          MethodName:'Insert',
					         IsTwoUppDown :IsTwoUppDown,
                             IsEconomicItem : IsEconomicItem
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
					                  }  else{
						              $.messager.popover({
										  msg: '����ʧ�ܣ�'+SQLCODE,
										  type:'error',
										  style:{"position":"absolute","z-index":"9999",
										  left:-document.body.scrollTop - document.documentElement.scrollTop/2,
										  top:1}});
								  	 $.messager.progress('close');
								  	 $('#MainGrid').datagrid("reload");
								  	 }
							});
			          }else{   //�������޸�
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
									      msg: '����ɹ���',
									      type:'success',
									      style:{"position":"absolute","z-index":"9999",
									      left:-document.body.scrollTop - document.documentElement.scrollTop/2,
									      top:1}});
							      	  $.messager.progress('close');
							      	  $('#MainGrid').datagrid("reload");
							      }else{
								      $.messager.popover({
										  msg: '����ʧ�ܣ�'+SQLCODE,
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
                $("#MainGrid").datagrid("unselectAll"); //ȡ��ѡ�����е�ǰҳ�����е���
                
            }
			})
	    }
     //�����ѯ��ť 
    $("#FindBtn").click(FindBtn); 
    
    
    //��������
    function add(IsTwoUppDown,IsEconomicItem)
    {
	    var row = $('#MainGrid').datagrid('getRows');  
    
    	if(row.length>0){
	    	$.messager.popover({
				 msg:'�������ݣ�����������',
				 timeout: 2000,type:'alert',
				 showType: 'show',
				 style:{"position":"absolute","z-index":"9999",
				 left:-document.body.scrollTop - document.documentElement.scrollTop/2}})
				 return;
	    }else{
		    editIndex=append($('#MainGrid'),{IsCheck:'δ���'},editIndex)};
		}
    }
    //ɾ������
    function delect(){
	    if($('#MainGrid').datagrid("getSelections").length==0&&($('#MainGrid').datagrid("getChecked").length==0)){
			      $.messager.popover({
				      msg:'û��ѡ�еļ�¼��',
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
				        	msg: 'ɾ���ɹ���',
				        	type:'success',
				        	style:{"position":"absolute","z-index":"9999",
				        	left:-document.body.scrollTop - document.documentElement.scrollTop/2,
				        	top:1}});
				        	$.messager.progress('close');
				        	$('#MainGrid').datagrid("reload");
				        	} else{
					    $.messager.popover({
						    msg: 'ɾ��ʧ�ܣ�'+SQLCODE,
						    type:'error',
						    style:{"position":"absolute","z-index":"9999",
						    left:-document.body.scrollTop - document.documentElement.scrollTop/2,
						    top:1}});
						    $.messager.progress('close');
								  	 }
				})
				
    }
				    
       
