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
	        var url = $URL+"?ClassName=herp.budg.hisui.common.ComboMethod&MethodName=BudgSchem&hospid="+hospid+"&userdr="+userid+"&flag=2&year="+data.year;
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
		        $.messager.popover({msg: '����ѡ����ȣ�',type:'info',timeout: 2000,showType: 'show',
		                      style:{
					            "position":"absolute",
					            "z-index":"9999",
					            left:document.body.scrollLeft/2 +document.documentElement.scrollLeft/2,
					            top:1
					        }});
		        return;
		    }
            param.str = param.q;
            param.hospid=hospid;
            param.userdr=userid;
            param.flag=2;
            param.year=year;
        },
        onSelect:function(data){
	        //console.log(JSON.stringify(data));
	        $('#Deptbox').combobox('clear'); //���ԭ��������
	        var url = $URL+"?ClassName=herp.budg.hisui.common.ComboMethod&MethodName=Dept&flag=7&schemedr="+data.rowid;
	        $('#Deptbox').combobox('reload', url);//���������б�����  
	        var deptId = $('#Deptbox').combobox('getValue');
	        if(deptId!==""){
	        	console.log(JSON.stringify(data));
	        	var IsLast = $('#IsLastBox').checkbox('getValue'); //�Ƿ�ĩ��
        		if(IsLast == true){
	       			IsLast=1;
	    		}else{
		    		IsLast=0;
				}
		    	MainGridObj.load({ 
                	ClassName:"herp.budg.hisui.udata.uBudgSchemIncrement",
                	MethodName:"ListDept",
                	hospid : hospid, 
                	Year : $('#Yearbox').combobox('getValue'), 
                	Schemdr : data.rowid, 
                	Deptdr : deptId, 
                	itemty : $('#ItemTypebox').combobox('getValue'), 
                	isLast : IsLast, 
                	Code : $('#Itemfield').val()
         		}) ; 
     		}
     	}
    });
    
      //����
    var Deptbox = $HUI.combobox("#Deptbox",{
        url:$URL+"?ClassName=herp.budg.hisui.common.ComboMethod&MethodName=Dept",
        mode:'remote',
        valueField:'rowid',    
        textField:'name',
        onBeforeLoad:function(param){
	        var schemedr=$('#Schembox').combobox('getValue');
	        if(schemedr==""){
		        $.messager.popover({msg: '����ѡ�񷽰���',type:'info',timeout: 2000,showType: 'show',
		                  style:{
					            "position":"absolute",
					            "z-index":"9999",
					            left:document.body.scrollLeft/2 +document.documentElement.scrollLeft/2,
					            top:1
					        }});
		        return;
		    }
            param.str = param.q;
            param.flag=7;
            param.schemedr=schemedr;
        },
        onSelect:function(data){
	        //console.log(JSON.stringify(data)); 
	        var bsmId = $('#Schembox').combobox('getValue');
	        if(bsmId!==""){
	        	//console.log(JSON.stringify(data));
	        	var IsLast = $('#IsLastBox').checkbox('getValue'); //�Ƿ�ĩ��
        		if(IsLast == true){
	       			IsLast=1;
	    		}else{
		    		IsLast=0;
				}
		    	MainGridObj.load({
                	ClassName:"herp.budg.hisui.udata.uBudgSchemIncrement",
                	MethodName:"ListDept",
                	hospid : hospid, 
                	Year : $('#Yearbox').combobox('getValue'), 
                	Schemdr : bsmId, 
                	Deptdr : data.rowid, 
                	itemty : $('#ItemTypebox').combobox('getValue'), 
                	isLast : IsLast, 
                	Code : $('#Itemfield').val()
         		}) ; 
     		}
     	}
    });
               
     //��Ŀ���
    var ItemTypebox = $HUI.combobox("#ItemTypebox",{
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
	        var deptId = $('#Deptbox').combobox('getValue');
	        if(deptId!==""){
	        	//console.log(JSON.stringify(data));
	        	var IsLast = $('#IsLastBox').checkbox('getValue'); //�Ƿ�ĩ��
        		if(IsLast == true){
	       			IsLast=1;
	    		}else{
		    		IsLast=0;
				}
		    	MainGridObj.load({
                	ClassName:"herp.budg.hisui.udata.uBudgSchemIncrement",
                	MethodName:"ListDept",
                	hospid : hospid, 
                	Year : $('#Yearbox').combobox('getValue'), 
                	Schemdr : $('#Schembox').combobox('getValue'), 
                	Deptdr : deptId, 
                	itemty : data.code, 
                	isLast : IsLast, 
                	Code : $('#Itemfield').val()
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

        	var deptId = $('#Deptbox').combobox('getValue');
	        if(deptId!==""){
	        	//console.log(JSON.stringify(data));
		    	MainGridObj.load({
                	ClassName:"herp.budg.hisui.udata.uBudgSchemIncrement",
                	MethodName:"ListDept",
                	hospid : hospid, 
                	Year : $('#Yearbox').combobox('getValue'), 
                	Schemdr : $('#Schembox').combobox('getValue'), 
                	Deptdr : deptId, 
                	itemty : $('#ItemTypebox').combobox('getValue'), 
                	isLast : value, 
                	Code : $('#Itemfield').val()
         		}) ; 
     		}
        }
    })
    
     //��ѯ����
    var FindBtn= function()
    {
	    
        var Year		= $('#Yearbox').combobox('getValue'); // Ԥ�����
        var Schem		= $('#Schembox').combobox('getValue'); // ����
        var deptId 		= $('#Deptbox').combobox('getValue'); //����
        //console.log(JSON.stringify(deptId));
        if(Schem==""||(deptId=="")){
	        $.messager.popover({
						    msg:'����ݷ����Ϳ��Ҳ�ѯ��',timeout: 3000,type:'info',showType: 'show',
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
                MethodName:"ListDept",
                hospid : hospid, 
                Year : Year, 
                Schemdr : Schem, 
                Deptdr : deptId, 
                itemty : ItemType, 
                isLast : IsLast, 
                Code : Item
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
	                field:'bfdeptname',
	                title:'Ԥ�����',
	                width:200,
	                hidden: true
                },{
	                field:'bfitemcode',
	                title:'��Ŀ����',
	                width:150
                },{
	                field:'bfitemcodename',
	                title:'��Ŀ����',
	                align:'left',
	                halign:'left',
	                width:250
	            },{
		            field:'bfrealvaluelast',
		            title:'����ִ��',
		            width:150, 
		            align:'right',
					formatter: function (value, row, index) {
						if (row != null) {
							if(value=="") value=0;
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
	            		return 'cursor:hand;cursor:pointer;';
	            	}
			    },{
				    field:'bfplanvalue',
				    title:'����ƻ�',
				    width:150,  
		            align:'right',
					formatter: function (value, row, index) {
						if (row != null) {
							if(value=="") value=0;
							return (parseFloat(value).toFixed(2) + '').replace(/\d{1,3}(?=(\d{3})+(\.\d*)?$)/g, '$&,');
                        }
                    }
				},{
					field:'CalFlag',
					title:'���㷽��',
					width:150
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
								      msg:message,timeout: 3000,type:'error',showType: 'show',
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
								      msg:Data,timeout: 3000,type:'error',showType: 'show',
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