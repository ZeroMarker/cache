var userid = session['LOGON.USERID'];
var hospid=session['LOGON.HOSPID'];
$(function(){//��ʼ��
    
    Init();
});

function Init(){
	
	var YMboxObj = $HUI.combobox("#YMbox",{
        url:$URL+"?ClassName=herp.budg.hisui.common.ComboMethod&MethodName=YearOrYearMon",
        mode:'remote',
        delay:200,
        valueField:'year',    
        textField:'year',
        onBeforeLoad:function(param){
            param.str = param.q;
        },
        onSelect: function () {
	            $('#CodeDatabox').combobox('clear');
				$('#CodeDatabox').combobox('reload');
				$('#MainGrid').datagrid('load', {
					ClassName: 'herp.budg.hisui.udata.BudgTravelCashCtrlem',
					MethodName: 'List',
					hospid :hospid, 
                    Year : $("#YMbox").combobox('getValue'),
                    ItemCode :"", 
                    Type :""
					
				});

			}
    });
    
    var YMboxObj = $HUI.combobox("#CodeDatabox",{
        url:$URL+"?ClassName=herp.budg.hisui.common.ComboMethod&MethodName=CtrlItemCode",
        mode:'remote',
        delay:200,
        valueField:'code',    
        textField:'name',
        onBeforeLoad:function(param){
            param.str = param.q;
        },
        onSelect: function () {
	            
				$('#MainGrid').datagrid('load', {
					ClassName: 'herp.budg.hisui.udata.BudgTravelCashCtrlem',
					MethodName: 'List',
					hospid :hospid, 
                    Year : $("#YMbox").combobox('getValue'),
                    ItemCode :$("#CodeDatabox").combobox('getValue'), 
                    Type :""
					
				});

			}
    });
    
    MainColumns=[[  
                {
	                field:'ckbox',
	                checkbox:true,
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
	                field:'Year',
	                title:'���',
	                width:150,
	                editor: {
		                type:'combobox',
		                options:{
			                valueField:'year',    
                            textField:'year',
                            mode:'remote',
                            url:$URL+"?ClassName=herp.budg.hisui.common.ComboMethod&MethodName=YearOrYearMon",
                            delay:200,
			                onBeforeLoad:function (param){
				                param.flag = '';
                                param.str = param.q;
                               },
		                }
			                
		                }
	                
                },
                {
	                field:'ItemCode',
	                title:'���÷ѿ�����',
	                width:350,
					formatter:function(value,row,index){
						return row.Name},
	                editor:{type:'combobox',
	                        options:{
		                       url:$URL+"?ClassName=herp.budg.hisui.common.ComboMethod&MethodName=CtrlItemCode",
                               mode:'remote',
                               delay:200,
                               valueField:'code',     
                               textField:'name',
                               onBeforeLoad:function(param){
                                            param.str = param.q;
                                            }    
			               }   
                }
                },
                {
	                field:'Type',
	                title:'��������',
	                width:150,
	                hidden: true
                } 
                
            ]];
    var MainGridObj = $HUI.datagrid("#MainGrid",{
        url:$URL,
        queryParams:{
            ClassName:"herp.budg.hisui.udata.BudgTravelCashCtrlem",
            MethodName:"List",
            hospid :    hospid, 
            Year :      "",
            ItemCode :      "", 
            Type :      ""
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
	
	//��ѯ����
    var FindBtn= function()
    {
	    //alert('ok')
        var year    = $('#YMbox').combobox('getValue'); // �������
        var ItemCode  = $('#CodeDatabox').combobox('getValue'); // ���ο���
        MainGridObj.load({
	        ClassName:"herp.budg.hisui.udata.BudgTravelCashCtrlem",
	        MethodName:"List",
	        hospid : hospid, 
	        Year : year, 
            ItemCode : ItemCode,
            Type: ""
       })
    }

    //�����ѯ��ť 
    $("#FindBn").click(FindBtn);
	
	//����
    var AddBtn = function()
   {
	    if (endEditing()) {
			$('#MainGrid').datagrid('appendRow', {
				//IsLast: 0
			});
		editIndex = $('#MainGrid').datagrid('getRows').length - 1;
		$('#MainGrid').datagrid('selectRow', editIndex).datagrid('beginEdit', editIndex);	
		}		
    }
    
    //���������ť
    $("#AddBn").click(AddBtn);
    
    
    //ɾ��
    var DelBtn = function()
    {
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
			del(grid, "herp.budg.hisui.udata.BudgTravelCashCtrlem", "Delete"); 
		}	
	};
    //���ɾ����ť
    $("#DelBn").click(DelBtn);
    
    
    //���� 
    var saveOrder = function() {
        var rows = $('#MainGrid').datagrid("getSelections");
        var length=rows.length;
        if(length<1){
            $.messager.alert('��ʾ','����ѡ������һ������!','info');
            return false;
        }else{
            var indexs=$('#MainGrid').datagrid('getEditingRowIndexs')
            if(indexs.length>0){
                for(var i=0;i<indexs.length;i++){
                    $("#MainGrid").datagrid("endEdit", indexs[i]);
                }
            }
            for(var i=0; i<length; i++){
                var row = rows[i];
                rowid=row.rowid;
                CompDR=hospid;
                Year=row.Year;
                ItemCode=row.ItemCode;
                Type=row.Type
            	
            	
                if(rowid==null){
	                //alert('���������µ��У�����')
                    $.m({
                        ClassName:'herp.budg.hisui.udata.BudgTravelCashCtrlem',
                        MethodName:'InsertRec',
                        Year:Year,
                        CompDR:CompDR,
                        ItemCode:ItemCode,
                        //Type:"���÷ѿ���"
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
	                            
                                //$.messager.alert('��ʾ','���ÿ������ظ�������������','info');
                                $.messager.popover({
					            msg: '���ÿ������ظ�������������',
					            type:'success',
					            style:{"position":"absolute","z-index":"9999",
		                        left:-document.body.scrollTop - document.documentElement.scrollTop/2,
		                        top:1}});
			                    $.messager.progress('close');
                            }
                        }
                    );
                }else{
	                //alert('���±༭���У�����')
                    $.m({
                        ClassName:'herp.budg.hisui.udata.BudgTravelCashCtrlem',
                        MethodName:'UpdateRec',
                        rowid:rowid,
                        Year:Year,
                        CompDR:CompDR,
                        ItemCode:ItemCode,
                        Type: Type
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
												msg: '����ʧ��'+SQLCODE,
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