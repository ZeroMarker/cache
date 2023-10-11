$(function(){//��ʼ��
    Init();
}); 

function Init(){
	
    //Ԥ�����combox
    var YearboxObj = $HUI.combobox("#Yearbox",{
        url:$URL+"?ClassName=herp.budg.hisui.common.ComboMethod&MethodName=YearOrYearMon",
        mode:'remote',
        valueField:'year',    
        textField:'year',
        onBeforeLoad:function(param){
            param.str = param.q;
        },
        onSelect:function(data){
	        //console.log(JSON.stringify(data));
	        $('#Schembox').combobox('clear'); //���ԭ��������
	        var url = $URL+"?ClassName=herp.budg.hisui.common.ComboMethod&MethodName=BudgSchem&hospid="+hospid+"&userdr="+userid+"&flag=1&year="+data.year;
	        $('#Schembox').combobox('reload', url);//���������б�����  
        }
    });
    //Ԥ�㷽��
    var Schembox = $HUI.combobox("#Schembox",{
        url:$URL+"?ClassName=herp.budg.hisui.common.ComboMethod&MethodName=BudgSchem",
        mode:'remote',
        valueField:'rowid',    
        textField:'name',
        onBeforeLoad:function(param){
	        var year=$('#Yearbox').combobox('getValue');
	        if(year==""){
		        $.messager.popover({msg: '����ѡ����ȣ�',type:'info',timeout: 2000,showType: 'show',style:{"position":"absolute","z-index":"9999",
		               left:-document.body.scrollTop - document.documentElement.scrollTop/2,
		               top:1}});
		        return;
		    }
            param.str = param.q;
            param.hospid=hospid;
            param.userdr=userid;
            param.flag=1;
            param.year=year;
        },
        onSelect:function(data){
	        //console.log(JSON.stringify(data));
	        var IsLast = $('#IsLastBox').checkbox('getValue'); //�Ƿ�ĩ��
        	if(IsLast == true){
	       		IsLast=1;
	    	}else{
		    	IsLast=0;
			}
		    MainGridObj.load({
                	ClassName:"herp.budg.hisui.udata.uBudgSchemIncrement",
                	MethodName:"List",
                	hospid : hospid, 
                	year : $('#Yearbox').combobox('getValue'), 
                	bsmId : data.rowid, 
                	deptId : -1, 
                	bidTy : $('#ItemTypebox').combobox('getValue'), 
                	isLast : IsLast, 
                	bidCo : $('#Itemfield').val()
         	}) ; 
     	}
    });
                
     //��Ŀ���
    var Schembox = $HUI.combobox("#ItemTypebox",{
        url:$URL+"?ClassName=herp.budg.hisui.common.ComboMethod&MethodName=ItemType",
        mode:'remote',
        valueField:'code',    
        textField:'name',
        onBeforeLoad:function(param){
            param.str = param.q;
            param.flag=1;
        },
        onSelect:function(data){
	        //console.log(JSON.stringify(data));
	        var Schem=$('#Schembox').combobox('getValue');
	        if(Schem!==""){
		        var IsLast = $('#IsLastBox').checkbox('getValue'); //�Ƿ�ĩ��
        		if(IsLast == true){
	       			IsLast=1;
	    		}else{
		    		IsLast=0;
				}
		       	MainGridObj.load({
                	ClassName:"herp.budg.hisui.udata.uBudgSchemIncrement",
                	MethodName:"List",
                	hospid : hospid, 
                	year : $('#Yearbox').combobox('getValue'), 
                	bsmId : Schem, 
                	deptId : -1, 
                	bidTy : data.code, 
                	isLast : IsLast, 
                	bidCo : $('#Itemfield').val()
         		}) ;
		    }
	        
     	}
    });
  
	//�Ƿ�ĩ��
    $("#IsLastBox").checkbox({
        onCheckChange:function(event,value){
	        if(value == true){
	        	value=1;
	       	}else{
		       	value=0;
		   	}		   

        	var Schem		= $('#Schembox').combobox('getValue'); // ����
        	if(Schem!==""){
	        	MainGridObj.load({
                	ClassName:"herp.budg.hisui.udata.uBudgSchemIncrement",
                	MethodName:"List",
                	hospid : hospid, 
                	year : $('#Yearbox').combobox('getValue'), 
                	bsmId : Schem, 
                	deptId : -1, 
                	bidTy : $('#ItemTypebox').combobox('getValue'), 
                	isLast : value, 
                	bidCo : $('#Itemfield').val()
         		}) ;
	    	}
        }
    })
    
     //��ѯ����
    var FindBtn= function()
    {
	    
        var Year		= $('#Yearbox').combobox('getValue'); // Ԥ�����
        var Schem		= $('#Schembox').combobox('getValue'); // ����
        if(Schem==""){
	        $.messager.popover({
						    msg:'����ݷ�����ѯ��',timeout: 3000,type:'info',showType: 'show',
				            style:{
					            "position":"absolute",
					            "z-index":"9999",
					            left:document.body.scrollLeft/2 +document.documentElement.scrollLeft/2,
					            top:1
					        }
			});
	        return;
	    }
        var ItemType	= $('#ItemTypebox').combobox('getValue'); //��Ŀ���
        var Item		= $('#Itemfield').val(); // ��Ŀ
        var IsLast = $('#IsLastBox').checkbox('getValue'); //�Ƿ�ĩ��
        if(IsLast == true){
	       	IsLast=1;
	    }else{
		    IsLast=0;
		}

        MainGridObj.load({
                ClassName:"herp.budg.hisui.udata.uBudgSchemIncrement",
                MethodName:"List",
                hospid : hospid, 
                year : Year, 
                bsmId : Schem, 
                deptId : -1, 
                bidTy : ItemType, 
                isLast : IsLast, 
                bidCo : Item
         });
    }

    MainColumns=[[  
                {
	                field:'ck',
	                checkbox:true
	            },{
	                field:'rowid',
	                title:'ID',
	                width:80,
	                hidden: true
                },{
	                field:'CompName',
	                title:'ҽ�Ƶ�λ',
	                width:80,
	                hidden: true
	            },{
	                field:'bfyear',
	                title:'���',
	                width:70
                },{
	                field:'bfitemcode',
	                title:'��Ŀ����',
	                width:150
                },{
	                field:'bfitemcodename',
	                title:'��Ŀ����',
	                width:250
	            },{
		            field:'bfrealvaluelast',
		            title:'����ִ��',
		            width:150, 
		            align:'right',
					formatter: function (value, row, index) {
						if (row != null) {
							return (parseFloat(value).toFixed(2) + '').replace(/\d{1,3}(?=(\d{3})+(\.\d*)?$)/g, '$&,');
                        }
                    }
		        },{ 
			        field:'bfincreaserate',
			        title:'��������',
			        width:100, 
		            align:'right',
			        editor: {
				        type: 'numberbox',
				        options: {
					        required: true,
					        precision:2
					    } 
            		},
            		styler: function (value, row, index) {
	            		return 'background-color:#E7F7FE;color:red;cursor:hand;cursor:pointer;';
	            	}
			    },{
				    field:'bfplanvalue',
				    title:'����ƻ�',
				    width:150,  
		            align:'right',
					formatter: function (value, row, index) {
						if (row != null) {
							return (parseFloat(value).toFixed(2) + '').replace(/\d{1,3}(?=(\d{3})+(\.\d*)?$)/g, '$&,');
                        }
                    }
				},{
					field:'CalFlag',
					title:'���㷽��',
					width:150
				},{
					field:'IsLast',
					title:'�Ƿ�ĩ��',
					width:150,
					hidden:true
					
				}

            ]];
    var MainGridObj = $HUI.datagrid("#MainGrid",{
        url:$URL,
        fitColumns: false,//�й̶�
        loadMsg:"���ڼ��أ����Եȡ�",
        autoRowHeight: true,
        autoSizeColumn:true, //�����еĿ������Ӧ����
        rownumbers:true,//�к�
        singleSelect: false, 
        checkOnSelect : true,//�������Ϊ true�����û����ĳһ��ʱ�����ѡ��/ȡ��ѡ�и�ѡ���������Ϊ false ʱ��ֻ�е��û�����˸�ѡ��ʱ���Ż�ѡ��/ȡ��ѡ�и�ѡ��
        selectOnCheck : true,//�������Ϊ true�������ѡ�򽫻�ѡ�и��С��������Ϊ false��ѡ�и��н�����ѡ�и�ѡ��
        nowap : true,//��ֹ��Ԫ���е������Զ�����
        pageSize:20,
        pageList:[10,20,30,50,100], //ҳ���Сѡ���б�
        pagination:true,//��ҳ
        fit:true,
        columns:MainColumns,
        onClickRow: onClickRow,  //���û����һ�е�ʱ�򴥷�
        toolbar: [
        	{
	        	id: 'Save',
	        	iconCls: 'icon-save',
	        	text: '����',
	        	handler: function(){
		        	save()
            	}
        	},{
	        	id: 'Batch',
	        	iconCls: 'icon-batch-cfg',
	        	text: '����',
	        	handler: function(){
		        	Batch()
		        }
        	}
        ]      
    });    

  		var editIndex = undefined;
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
					$('#MainGrid').datagrid('selectRow', index).datagrid('beginEdit', index);
					editIndex = index;
				} else {
					$('#MainGrid').datagrid('selectRow', editIndex);
				}
			}
			if($('#MainGrid').datagrid("getSelected").IsLast==0){
				var ed1 = $('#MainGrid').datagrid('getEditor', { index: editIndex, field: 'bfincreaserate' });
			    $(ed1.target).numberbox("disable");};
		}	

    	function save(){
	    	if (editIndex == undefined){return}
			$.messager.confirm('ȷ��','ȷ��Ҫ����ѡ����������',function(t){
            if(t){
	            // �ر����һ����ǰ�༭�У��������һ�е����ݲ��ᱻgetChanges��������
	            $('#MainGrid').datagrid('endEdit', editIndex);
	            var rows = $('#MainGrid').datagrid("getChanges");
                if(rows.length>0){
	                for(var i=0; i<rows.length; i++){
		              var row=rows[i]; 
		              var rowid= row.rowid;
		              //����ǰ����Ϊ���е���֤
		             if (saveAllowBlankVaild($('#MainGrid'),row)){
			             
		              var incRate=row.bfincreaserate;
		              var calMeth=((row.bsdcalflag==undefined)?'':row.bsdcalflag);
		              var schId=$('#Schembox').combobox('getValue');

		              //console.log("CheckDate:"+CheckDate);
		              
		              // ��̨��������ʱ����ʾһ����ʾ�򣬷�ֹ�û���ε�������桿�ظ��ύ����
                      $.messager.progress({
	                      title: '��ʾ',
	                      msg: '���ڱ��棬���Ժ򡭡�'
	                  });
		              
			          $.m({
				          ClassName:'herp.budg.hisui.udata.uBudgSchemIncrement',
					      MethodName:'UpdateRec',
					      userId : userid, 
					      rowid : rowid, 
					      incRate : incRate, 
					      calMeth : calMeth, 
					      schId : schId
					      },
					      function(Data){
						      if(Data==0){
							      $.messager.popover({
								      msg:'�����ɹ���',timeout: 3000,type:'info',showType: 'show',
								      style:{
									      "position":"absolute",
									      "z-index":"9999",
									      left:document.body.scrollLeft/2 +document.documentElement.scrollLeft/2,
									      top:1
									   }
									});
							          $('#MainGrid').datagrid("reload");
							      	  $.messager.progress('close');
							      	  editIndex = undefined;
							   }else{
								   var message=""
								   if (Data=="RepName"){message="�����ظ���"	}
								   else{message=Data}
								   
								   $.messager.popover({
								      msg:message,timeout: 3000,type:'info',showType: 'show',
								      style:{
									      "position":"absolute",
									      "z-index":"9999",
									      left:document.body.scrollLeft/2 +document.documentElement.scrollLeft/2,
									      top:1
									   }
									});
								    $.messager.progress('close');
								  }
							});
	                }
		            } 
	                
	            }else{return}//û�иı䣬������
                editIndex = undefined;               
                $("#MainGrid").datagrid("unselectAll"); //ȡ��ѡ�����е�ǰҳ�����е���
                
            }
			})
	    }
	//����
	Batch=function (rowid){
		//console.log(rowid);
		var rows = $('#MainGrid').datagrid("getSelections");
        if(rows.length>0){
	        var schId=$('#Schembox').combobox('getValue');
	        var rowids="";
	        for(var i=0; i<rows.length; i++){
		        var row=rows[i];
		        var rowid= row.rowid;
		        if(rowids==""){
			        rowids=rowid;
			    }else{
				    rowids=rowids+"^"+rowid;
				}
		        var calMeth=((row.bsdcalflag==undefined)?'':row.bsdcalflag);
		    }
		}else{
			$.messager.popover({
				msg:'��ѡ����Ҫ�����ļ�¼',timeout: 3000,type:'info',showType: 'show',
				style:{
					"position":"absolute",
					"z-index":"9999",
					left:document.body.scrollLeft/2 +document.documentElement.scrollLeft/2,
					top:1
				 }
			 });
			 return;
		}
		$.messager.prompt("����������������", "��������%:", function (r) {
				 if (r) {
					 $.m({
						 ClassName:'herp.budg.hisui.udata.uBudgSchemIncrement',
						 MethodName:'UpdateRecs',
						 userId : userid, 
					     rowids : rowids, 
					     incRate : r, 
					     calMeth : calMeth, 
					     schId : schId
						 },
						 function(Data){
							 if(Data==0){
								 $.messager.popover({
								      msg:'�����ɹ���',timeout: 3000,type:'info',showType: 'show',
								      style:{
									      "position":"absolute",
									      "z-index":"9999",
									      left:document.body.scrollLeft/2 +document.documentElement.scrollLeft/2,
									      top:1
									   }
								 });
							          $('#MainGrid').datagrid("reload");
							}else{
								$.messager.popover({
								      msg:Data,timeout: 3000,type:'info',showType: 'show',
								      style:{
									      "position":"absolute",
									      "z-index":"9999",
									      left:document.body.scrollLeft/2 +document.documentElement.scrollLeft/2,
									      top:1
									   }
								});
								 
							 }
						});
				} else {
					return;
					}
		});	
				
				$("#MainGrid").datagrid("unselectAll"); //ȡ��ѡ�����е�ǰҳ�����е���
                editIndex = undefined;
	}
    //�����ѯ��ť 
    $("#FindBn").click(FindBtn); 
}