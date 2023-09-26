var Split="",UNsplit="",itmid=""
$(function(){ 
	
	InitCombobox();  ///初始化combobox
	CustomEditor();  ///自定义编辑器
	
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

function save(flag)   ///保存配送申请时加参数  sufan 2018-03-22
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
		$.messager.confirm('确认', '确认要拆分成'+LocIDStringLength+'条申请单吗?', function(r){
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
	var UrgentFlag=""  ///加急标志
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
							$.messager.alert('提示','保存成功');
							$("#datagrid").datagrid('reload');
							clearForm();
						}else{
							 $.messager.alert('提示','保存失败'+data)
							 $("#datagrid").datagrid('reload')
							} 
					},"json")
}

function deleteRow(){
	select=$('#datagrid').datagrid('getSelected');
	if(null==select){
		$.messager.alert('提示','请选择');
		return;
	}
	var itm="";
	$.messager.confirm('确认', '确认要删除吗?', function(r){
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
		$.messager.alert("提示","请先选择配送类型")
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
		$.messager.alert("提示:","已选择拆分项目,不可再选择其它项目");
		return;
	}
	/* 
	if($('#recLoc').combobox('getValue')==""){
		$.messager.alert("提示","请先选择接受科室")
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
		$.messager.alert("提示:","已有其它项目,不能选择拆分项目!");
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
	    	$.messager.alert("提示:","接收科室不能与上一条项目不同")
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