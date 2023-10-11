var userid = session['LOGON.USERID'];
var hospid=session['LOGON.HOSPID'];

$(function(){//��ʼ��
    
    Init();
});

function Init(){
    //�Ƿ���Ч
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
	                title:'ҽԺID',
	                width:80,
	                hidden: true
                },
                {
	                field:'Code',
	                title:'����',
	                width:150,
	                allowBlank:false,
	                align:'left',
	                editor: {type:'validatebox',options:{required:true}}
	                
                },
                {
	                field:'Name',
	                title:'����',
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
	                title:'�Ƿ���Ч', 
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
         fitColumns: false,//�й̶�
        loadMsg:"���ڼ��أ����Եȡ�",
        autoRowHeight: true,
        rownumbers:true,//�к�
        ctrlSelec:true, //�����ö���ѡ���ʱ������ʹ��Ctrl��+������ķ�ʽ���ж�ѡ����
        scheckOnSelect : true,//�������Ϊ true�����û����ĳһ��ʱ�����ѡ��/ȡ��ѡ�и�ѡ���������Ϊ false ʱ��ֻ�е��û�����˸�ѡ��ʱ���Ż�ѡ��/ȡ��ѡ�и�ѡ��
        selectOnCheck : false,
        singleSelect: true, //ֻ����ѡ��һ��
        pageSize:20,
        pageList:[10,20,30,50,100], //ҳ���Сѡ���б�
        pagination:true,//��ҳ
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
    
    //��ѯ����
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

    //�����ѯ��ť 
    $("#FindBn").click(FindBtn);
    
    //ɾ��
    var DelBtn = function()
    {
	        //var index = ('#MainGrind').datagrid('getRows').length-1
	        //alert(index)
	    	var grid = $('#MainGrid')
			if($('#MainGrid').datagrid("getSelections").length==0&&($('#MainGrid').datagrid("getChecked").length==0)){
				$.messager.popover({
				msg: '��ѡ����Ҫɾ�����У�',
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
    //���ɾ����ť
    $("#DelBn").click(DelBtn);
    
    //����
    var AddBtn = function()
   {
	   
	    if (endEditing()) {
		$('#MainGrid').datagrid('appendRow', {IsValid: '1'});
		editIndex = $('#MainGrid').datagrid('getRows').length - 1;
		$('#MainGrid').datagrid('selectRow', editIndex).datagrid('beginEdit', editIndex);
			
		}		
    }
    
    //���������ť
    $("#AddBn").click(AddBtn);
    
    //���༭
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
	
	 //���� 
    var saveOrder = function() {
	    var indexs = $('#MainGrid').datagrid('getEditingRowIndexs');
		if (indexs.length > 0) {
			for (i = 0; i < indexs.length; i++) {
				$('#MainGrid').datagrid("endEdit", indexs[i]);
			}
		}
        var rows = $('#MainGrid').datagrid("getChanges");
        if(rows.length < 0){
            $.messager.alert('��ʾ','����ѡ������һ������!','info');
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
					msg: '�������Ϊ��!',
					type:'success',
					style:{"position":"absolute","z-index":"9999",
		            left:-document.body.scrollTop - document.documentElement.scrollTop/2,
		            top:1}});
			        return false;
            	} 
               
                if(rowid==null){
	                 //alert('���������µ��У�����')
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
					             //$.messager.alert('��ʾ','����ɹ���','info');
					             $.messager.popover({
					            msg: '����ɹ���',
					            type:'success',
					            style:{"position":"absolute","z-index":"9999",
		                        left:-document.body.scrollTop - document.documentElement.scrollTop/2,
		                        top:1}});
			                    $.messager.progress('close');
                                 $('#MainGrid').datagrid("reload");     
                            }else{
	                            var message="SQLERROE:"+Data;
	                           if(Data="RepName") message="������Ŀ�����ظ�"
	                           if(Data="RepCode") message="������Ŀ���븴"
	                           
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
	                //alert('���±༭���У�����')
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
								          msg: '����ɹ���',
								          type:'success',
								           style:{"position":"absolute","z-index":"9999",
								                 left:-document.body.scrollTop - document.documentElement.scrollTop/2,
		                                         top:1}});
							      	  $.messager.progress('close');
							      	  //$('#MainGrid').datagrid("reload");
							      	  editIndex = undefined;
							          }else{
								          $.messager.popover({
												msg: '������Ŀ�ظ�,����ʧ��!',
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
             //alert('���������µ��У�����ֱ�Ӽ��ر��')
            $('#MainGrid').datagrid("reload");       
        }        
    }
    //������水ť 
    $("#SaveBn").click(saveOrder);
	
	
}

