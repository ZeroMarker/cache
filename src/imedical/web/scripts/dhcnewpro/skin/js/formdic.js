$(function(){
	if($("#userEdit").val()==1){
	    $("#goFormName").hide()
	    $("#subHidden").parent().parent().hide()
	}
	var IEVersion =serverCall("ext.util.String","GetIEVersion"); //hxy 2017-12-14 st
    $('#datagrid').datagrid({   
		url:'dhcapp.broker.csp?ClassName=web.DHCADVFormDic&MethodName=listGrid&IEVersion='+IEVersion
	});//ed
	$("#queryStyle").next().find(".combo-text").on("input propertychange",function(){  
     	$('#queryStyle').combobox('clear');
   		commonQuery({'datagrid':'#datagrid','formid':'#toolbar'})
	})
	$("#queryForm").next().find(".combo-text").on("input propertychange",function(){  
     	$('#queryForm').combobox('clear');
   		commonQuery({'datagrid':'#datagrid','formid':'#toolbar'})
	}) 	
	//$(".combo-text").change(function(){alert(1);}); 
	$("#queryFormBtn").hide(); 
	$("#queryField").keydown(
		function(e){
			if(e.keyCode==13) {
				commonQuery({'datagrid':'#datagrid','formid':'#toolbar'})
     		}	
		}
	
	) 
	$("#queryTreeField").keydown(
		function(e){
			if(e.keyCode==13) {
				val=$.trim($("#queryTreeField").val());
				var rowsData = $("#datagrid").datagrid('getSelected')
				var url = LINK_CSP+'?ClassName=web.DHCADVFormDic&MethodName=listTree&id='+rowsData.ID+'&text='+val;
				$('#formTree').tree('options').url=encodeURI(url);
				$('#formTree').tree('reload')
			
				
			}
		}
	)
	$("#subValue").keydown(
		function(e){
			if(e.keyCode==13) {
				if($("#subStyle").combobox('getValue')=='form'){
					queryFormDataGrid(); 	
				}
     		}	
		}
	
	) 
	$("#queryFormBtn").on('click',function(){
		queryFormDataGrid(); 
	})
	
	$(":radio").click(function(){
   		commonQuery({'datagrid':'#datagrid','formid':'#toolbar'})
  	}); 
	commonQuery({'datagrid':'#datagrid','formid':'#toolbar'})
});

function queryFormDataGrid(){
	$('#formDatagrid').datagrid('load', {    
    	queryStr: $("#subValue").val()  
	});
	$('#queryFormDialog').dialog("open");
}

function onClickRow(index,row){
	CommonRowClick(index,row,"#datagrid");
}

function addRow(){
	commonAddRow({'datagrid':'#datagrid',value:{'style':'input','newLine':'N'}})
}

function save(){
	saveByDataGrid("web.DHCADVFormDic","save","#datagrid",function(data){
		//�޸�
		if(data==0){
			$.messager.alert('��ʾ','����ɹ�')
			$("#datagrid").datagrid('reload'); 
		}else{
			if((data=-11)||(data=-12)){
				$.messager.alert('��ʾ','����ʧ��:Ψһ��ʾ�Ѵ���!')
			}else{
				$.messager.alert('��ʾ','����ʧ��:'+data)
			}
			
		}
		
	});	
}

function selectRow(index,row){
	$('#formTree').tree({    
    	url: LINK_CSP+"?ClassName=web.DHCADVFormDic&MethodName=listTree&id="+row.ID, 
    	lines:true,
    	onContextMenu: function(e, node){
			e.preventDefault();
			// ���ҽڵ�
			$('#formTree').tree('select', node.target);
			// ��ʾ��ݲ˵�
			$('#mm').menu('show', {
				left: e.pageX,
				top: e.pageY
			});
		}


	});
}

function addSub(){
	var rowsData = $("#datagrid").datagrid('getSelected')
	if (rowsData == null) {
		$.messager.alert("��ʾ","��ѡ���Ԫ��!");
		return;	
	}
	clearForm();
    $("#subParref").val(rowsData.ID)
    //$("#subField").val(rowsData.field)
    $("#subStyle").combobox('setValue',rowsData.style);
    if(rowsData.style=="form"){
	    $("#queryFormBtn").show(); 
	}else{
		$("#queryFormBtn").hide(); 
	}
	$("#seq").val(1)
	$('#sub').dialog("open");   
}

function appendSub(){
	clearForm();
    select=$('#formTree').tree('getSelected')
    $("#subParref").val(select.id)
    //$("#subField").val(select.field)
    $("#subStyle").combobox('setValue',select.style);
    if(select.style=="form"){
	    $("#queryFormBtn").show(); 
	}else{
		$("#queryFormBtn").hide(); 
	}
	$('#sub').dialog("open");  
}

function append(){
	clearForm();
    select=$('#formTree').tree('getSelected')
    $("#subParref").val(select.parRef)
    //$("#subField").val(select.field)
    $("#subStyle").combobox('setValue',select.style);
    if(select.style=="form"){
	    $("#queryFormBtn").show(); 
	}else{
		$("#queryFormBtn").hide(); 
	}
	$('#sub').dialog("open");
}

function edit(){
	clearForm();
	select=$('#formTree').tree('getSelected')
	ret=serverCall("web.DHCADVFormDic","findById",{'id':select.id})
	arr=ret.split("^");
	$("#subId").val(select.id);
	$("#subParref").val(arr[4]);
	$("#subField").val(arr[0]);
	$("#subStyle").combobox('setValue',arr[1]);
	$("#subValue").val(arr[5]);
	$("#subTitle").val(arr[2]);
	$("#subUrl").val(arr[3]);
	$("#subNewLine").combobox('setValue',arr[6]);
	
	$("#subWidth").val(arr[8]);
	$("#subHeight").val(arr[9]);
	$("#subCols").val(arr[10]);
	$("#subRows").val(arr[11]);
	
	$("#subSameLevel").combobox('setValue',arr[13]);
	$("#subHiddenValue").val(arr[14]);
	$("#subHiddenSub").combobox('setValue',arr[15]);
	if(arr[1]=='form'){
		$('#queryFormBtn').show()
	}else{
    	$('#queryFormBtn').hide()
    }
    
    $("#subDicSameLine").combobox('setValue',arr[16]);
	//��Ԫ�غ͸�Ԫ��ͬ��
	$("#canCopy").combobox('setValue',arr[17]); 
	
	$("#seq").val(arr[19]);
	$("#subHidden").combobox('setValue',arr[21]);   //hxy 2018-04-26 
	$('#sub').dialog("open");
}

function remove(){
	$.messager.confirm('ȷ�϶Ի���', 'ȷ��Ҫɾ����', function(r){
		if (r){
				select=$('#formTree').tree('getSelected')
	    		runClassMethod(
	 				"web.DHCADVFormDic",
	 				"remove",
	 				{'id':select.id},
	 				function(data){
	 					if(data==0){
		 					$.messager.alert("��ʾ","ɾ���ɹ�!");
		 					$('#formTree').tree('reload');
		 				}else{
			 				$.messager.alert("����","ɾ��ʧ��!"+data);
			 			} 
	 				})
		}
	});
}

function saveSub(){
	 
	 if($("#form").form('validate')){;
		 subId=$("#subId").val();
		 subParref=$("#subParref").val();
		 subField=$("#subField").val();
		 subStyle=$("#subStyle").combobox('getValue');
		 subValue=$("#subValue").val();
		 subTitle=$("#subTitle").val();
		 subUrl=$("#subUrl").val();
		 subWidth=$("#subWidth").val();
		 subHeight=$("#subHeight").val();
		 subCols=$("#subCols").val();
		 subRows=$("#subRows").val();
		 subNewLine=$("#subNewLine").combobox('getValue');
		 sameLevel=$("#subSameLevel").combobox('getValue');
		 subHiddenValue=$("#subHiddenValue").val();
		 subHiddenSub=$("#subHiddenSub").combobox('getValue');
		 subHidden=$("#subHidden").combobox('getValue'); //hxy 2018-04-26
		 //��Ԫ�غ͸�Ԫ��ͬ��
		 subDicSameLine=$("#subDicSameLine").combobox('getValue');
		 //���Ը���
		 canCopy=$("#canCopy").combobox('getValue');
		 //��Ԫ����ʾ˳��
		 seq=$("#seq").val();
		 par=subField+"^"+subTitle+"^"+subStyle+"^"+subId+"^"+subParref+"^"+subUrl+"^"+subValue+"^"+subNewLine 
		 par=par+"^"+subWidth+"^"+subHeight+"^"+subCols+"^"+subRows+"^^"+sameLevel+"^"+subHiddenValue+"^"+subHiddenSub+"^^"+subDicSameLine+"^"+canCopy+"^^"+seq
		 par=par+"^^"+subHidden;//hxy 2018-04-26

		 runClassMethod(
	 				"web.DHCADVFormDic",
	 				"save",
	 				{'params':par},
	 				function(data){
	 					if(data==0){
		 					$.messager.alert("��ʾ","����ɹ�!");
		 					$('#formTree').tree('reload');
		 					clearForm();
		 					$('#sub').dialog("close");
		 				}else{
			 				if((data=-11)||(data=-12)){
								$.messager.alert('��ʾ','����ʧ��:Ψһ��ʾ�Ѵ���!')
							}else{
								$.messager.alert('��ʾ','����ʧ��:'+data)
							}
			 			} 
	 				})
 				
	 }	
}

function clearForm(){
	$(':input','#form')    
    .not(':button, :submit, :reset')    
    .val('')
}

function goFormName(){
	window.location.href="dhcadv.formname.csp"	
}

function onSelectForm(index,row){
	$('#queryFormDialog').dialog("close");
	$("#subValue").val(row.code)
}
