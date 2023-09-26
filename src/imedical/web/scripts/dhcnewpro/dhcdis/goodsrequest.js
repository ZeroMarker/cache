var Split="",UNsplit="",itmid=""
$(function(){ 
	
	InitCombobox();  ///��ʼ��combobox
	CustomEditor();  ///�Զ���༭��
	
});
function InitCombobox()
{
	/* $('#recLoc').combobox({    
    	url:LINK_CSP+"?ClassName=web.DHCDISCommonDS&MethodName=LocCombo&HospID="+LgHospID,    
    	valueField:'id',    
    	textField:'text',
    	mode:'remote'   
	}); */
	$('#disType').combobox({    
    	url:LINK_CSP+"?ClassName=web.DHCDISAffirmStatus&MethodName=GetDisTypeCombobox",    
    	valueField:'id',    
    	textField:'text',
    	onChange: function () {
			 var rows = $("#datagrid").datagrid('getRows');
			 for ( var i = 0; i < rows.length; i++) {
		         $("#datagrid").datagrid('endEdit', i);
			} 
		}
	});
	
}
function CustomEditor()
{
	
		 $.extend($.fn.datagrid.defaults.editors, {
			combogrid: {
				init: function(container, options){
					var input = $('<input type="text" class="datagrid-editable-input">').appendTo(container); 
					//options.url='dhcapp.broker.csp?ClassName=web.DHCDISCommonDS&MethodName=DisLocItmComboGrid&Loc='+$('#recLoc').combobox('getValue');
					options.url='dhcapp.broker.csp?ClassName=web.DHCDISCommonDS&MethodName=DisLocItmComboGrid&type='+$('#disType').combobox('getValue');
					input.combogrid(options);
					return input;
				},
				destroy: function(target){
					$(target).combogrid('destroy');
				},
				getValue: function(target){
					return $(target).combogrid('getText');
				},
				setValue: function(target, value){
					$(target).combogrid('setValue', value);
					
				},
				resize: function(target, width){
					$(target).combogrid('resize',width);
				}
			}
	});
}

function save(flag)   ///������������ʱ�Ӳ���  sufan 2018-03-22
{
	if(!$('#detail').form('validate')){
		return;	
	}
	var rows = $("#datagrid").datagrid('getRows');
	for ( var i = 0; i < rows.length; i++) {
         $("#datagrid").datagrid('endEdit', i);
	}
	var LocIDStringLength=$("#recLoc").combobox('getValues').length;
	if((LocIDStringLength>1)&&(Split=="Y"))
	{
		$.messager.confirm('ȷ��', 'ȷ��Ҫ��ֳ�'+LocIDStringLength+'�����뵥��?', function(r){
		if (r){
				SplitSave(flag);
			}
		})
	}
	else{
		SplitSave(flag);
	}
	
	
}
function SplitSave(flag)
{
	var UrgentFlag=""  ///�Ӽ���־
		$("input[type=checkbox][name=urgentFlag]").each(function(){
			if($(this).is(':checked')){
				UrgentFlag='Y';
			}else{
				UrgentFlag='N'
			}
		})	
		var tableData=$("#datagrid").datagrid('getRows');
		var ItmlistData = [];
		for(var i=0;i<tableData.length;i++){
			//var data=tableData[i].itmid+"^"+tableData[i].locid+"^"+tableData[i].qty;
			var data=tableData[i].itmid+"^"+tableData[i].qty;
			ItmlistData.push(data);
		}
		var ItmInfo=ItmlistData.join("$$");

		var REQCreateUser=LgUserID   
		var REQLocDr=LgCtLocID;		
		var REQRecLocDr=$("#recLoc").combobox('getValues');
		var REQRemarks=$("#remark").val();  
		var REQExeDate=$('#exeDate').datetimebox('getValue').split(" ")[0] 
		var REQExeTime=$('#exeDate').datetimebox('getValue').split(" ")[1]      
		var REQCreateDate=(new Date()).Format("yyyy-MM-dd")            
		var REQCreateTime=(new Date()).Format("hh:mm:ss");
		var REQDisType=$("#disType").combobox('getValue');
		var RequestDateList=REQCreateUser+"^"+REQLocDr+"^"+REQRecLocDr+"^"+REQRemarks+"^"+REQExeDate+"^"+REQExeTime+"^"+REQCreateDate+"^"+REQCreateTime+"^"+REQDisType+"^"+UrgentFlag;
		runClassMethod("web.DHCDISGoodsRequest",
					"saveReqString",
					{'mainStrings':RequestDateList,'subStr':ItmInfo,"flag":flag},
					function(data){
						if(data==0)
						{
							$.messager.alert('��ʾ','����ɹ�');
							$("#datagrid").datagrid('reload');
							clearForm();
						}else{
							 $.messager.alert('��ʾ','����ʧ��'+data)
							 $("#datagrid").datagrid('reload')
							} 
					},"json")
}

function deleteRow(){
	select=$('#datagrid').datagrid('getSelected');
	if(null==select){
		$.messager.alert('��ʾ','��ѡ��');
		return;
	}
	var itm="";
	$.messager.confirm('ȷ��', 'ȷ��Ҫɾ����?', function(r){
	if (r){
		itmid="";
		index=$('#datagrid').datagrid('getRowIndex',select);
		$('#datagrid').datagrid('deleteRow',index);
		}
		var rows = $('#datagrid').datagrid('getChanges');
		for(var i=0;i<rows.length-1;i++){
	 	
    		var row = rows[i];
			if(itm=="")
			{
				itm=row.locid;
			}else{
				itm=itm+"^"+row.locid;
			}
		}
		$('#recLoc').combobox({    
    		url:LINK_CSP+"?ClassName=web.DHCDISCommonDS&MethodName=ItmLocCombo&itmid="+itm,    
    		valueField:'id',    
    		textField:'text',
    		mode:'remote'   
		});
	});
	
}

function addRow(){
	if($('#disType').combobox('getValue')==""){
		$.messager.alert("��ʾ","����ѡ����������")
		return;	
	}
	var DatagridLen=$('#datagrid').datagrid('getChanges').length;
	if(DatagridLen<1)
	{
		Split="";
		UNsplit="";
	}
	if(Split!="")
	{
		$.messager.alert("��ʾ:","��ѡ������Ŀ,������ѡ��������Ŀ");
		return;
	}
	/* 
	if($('#recLoc').combobox('getValue')==""){
		$.messager.alert("��ʾ","����ѡ����ܿ���")
		return;	
	} */
	commonAddRow({datagrid:'#datagrid',value:{qty:1}})	
}

function onClickRow(index,row){
	CommonRowClick(index,row,"#datagrid");
}

function fillValue(rowIndex, rowData){
	if((rowData.locnum>1)&&(UNsplit=="Y"))
	{
		$.messager.alert("��ʾ:","����������Ŀ,����ѡ������Ŀ!");
		$('#datagrid').datagrid('deleteRow',0);
		return;
	}
	
	if(rowData.locnum>1)
	{
		Split="Y";
	}
	else{
		UNsplit="Y"
	}
	var reclocid=rowData.locid;
	var rows = $('#datagrid').datagrid('getChanges');
	for(var i=0;i<rows.length-1;i++){
	 	
    	var row = rows[i];
    	if((reclocid!=row.locid)&&(row.locid!=""))
    	{
	    	$.messager.alert("��ʾ:","���տ��Ҳ�������һ����Ŀ��ͬ")
	    	$('#datagrid').datagrid('deleteRow',0)
			return;
		}
	}
	if(itmid=="")
	{
		itmid=rowData.id
	}else{
		itmid=itmid+"^"+rowData.id
	}
	$('#recLoc').combobox({    
    	url:LINK_CSP+"?ClassName=web.DHCDISCommonDS&MethodName=ItmLocCombo&itmid="+itmid,    
    	valueField:'id',    
    	textField:'text',
    	mode:'remote'   
	});

	//ed=$('#datagrid').datagrid('getEditor', {index:editIndex,field:'loc'})
	//$(ed.target).combogrid('setValue',rowData.locdesc);
	$('#datagrid').datagrid('getRows')[editIndex]['itmid']=rowData.id
	$('#datagrid').datagrid('getRows')[editIndex]['locid']=rowData.locid
}

function fillLocValue(rowIndex, rowData){
	$('#datagrid').datagrid('getRows')[editIndex]['locid']=rowData.id
}

function clearForm(){
	$('#detail').form('clear');
	$('#datagrid').datagrid('loadData', { total: 0, rows: [] });
}