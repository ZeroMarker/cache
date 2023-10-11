var hospId=session['LOGON.HOSPID'];
var HospEnvironment=true;
$(function () {
	/**
    * @description: 初始化界面
    */
	function initUI() {
		if (typeof GenHospComp == "undefined") {
			HospEnvironment=false;
		
		}
		if(HospEnvironment){
			initHosp();
		}else{
			var hospDesc=tkMakeServerCall("NurMp.DHCNURTemPrintLInk","GetHospDesc",session['LOGON.HOSPID'])
			$("#_HospList").val(hospDesc)
			$('#_HospList').attr('disabled',true);
			//$("#_HospListLabel").css("display","none")
	    	//$("#_HospList").css("display","none")
		}
		initEvent();
		initBindGrid()
	}
	
	function initHosp(){
		var hospComp = GenHospComp("Nur_IP_PropertyMap",session['LOGON.USERID']+"^"+session['LOGON.GROUPID']+"^"+session['LOGON.CTLOCID']+"^"+session['LOGON.HOSPID']);  
		hospComp.options().onSelect = function(){
			if(HospEnvironment) hospId=$HUI.combogrid('#_HospList').getValue()
			$('#bindGrid').datagrid({
				url: $URL,
				queryParams: {
					ClassName: 'NurMp.InOutVolume.PropertyMap',
					QueryName: 'FindBindData',
					hospId:hospId
				
				}
			});
		} ;
		hospId = hospComp.options().value;
	}
	
	function initEvent(){
		$('#clearscreen').bind("click",clearScreen)
		
	}
	
	function initBindGrid(){
		
		$('#bindGrid').datagrid({
			url: $URL,
			queryParams: {
				ClassName: 'NurMp.InOutVolume.PropertyMap',
				QueryName: 'FindBindData',
				hospId:hospId
			},
			nowrap: false,
			toolbar: [{
					iconCls: 'icon-add',
					text: '增加',
					handler: addDataItem
				}, {
					iconCls: 'icon-edit',
					text: '修改',
					handler: editDataItem
				}, {
					iconCls: 'icon-remove',
					text: '删除',
					handler: deleteDataItem
				}
			],
			rownumbers: true,
			singleSelect: true,
			pagination: true,
			pageSize: 15,
			pageList: [15,30,60,120],
			onClickRow: bindGridClickRow,
		});
	}
	
	function bindGridClickRow(rowIndex, rowData){
		setCommonInfo(rowData);
	}
	
	function setCommonInfo(rowData) {
		for (var item in rowData) {
			
	        var domID = "#" + item;
	        if (domID == "#proportys")
			{
				var tempVal = rowData[item].replace(/\^/g, "\n");	
				$(domID).val(tempVal);
			}
			else
				$(domID).val(rowData[item]);        
	    }
	}

	
	function deleteDataItem(){
		var bindRow=$('#bindGrid').datagrid("getSelected");
		if(!bindRow){
			$.messager.popover({msg:"请选择一行数据！",type:'error'});
			return;
		}
		
		$m({
			ClassName:'NurMp.InOutVolume.PropertyMap',
			MethodName:'delete',
			indentity:bindRow.indentity
		},function(result){
			$.messager.popover({msg:"删除成功",type:"success"});
			$('#bindGrid').datagrid('reload');
		});
	}
	function editDataItem(){
		var bindRow=$('#bindGrid').datagrid("getSelected");
		if(!bindRow){
			$.messager.popover({msg:"请选择一行数据！",type:'error'});
			return;
		}
		
		var name = $('#name').val();
		var proportys = $('#proportys').val();
		var units = $('#units').val();
		
		if(name==""){
			$.messager.popover({msg:'名称不能为空!',type:'error'});
			return;
		}
		if(units==""){
			$.messager.popover({msg:'单位不能为空!',type:'error'});
			return;
		}
		if(proportys==""){
			$.messager.popover({msg:'属性不能为空!',type:'error'});
			return;
		}
		
		proportys = proportys.replace(/\n/g, "^");
		
		$m({
			ClassName:'NurMp.InOutVolume.PropertyMap',
			MethodName:'save',
			pName:name,
			pUnits:units,
			items:proportys,
			indentity:bindRow.indentity,
			hospId:hospId
		},function(result){
			if(result==0){
				$.messager.popover({msg:"保存成功",type:"success"});
			}else{
				$.messager.popover({msg:result,type:"error"});
			}
			$('#bindGrid').datagrid('reload');
		});
	}
	function clearScreen(){
		$('#name').val("");
		$('#proportys').val("");
		$('#units').val("");
	}
    function addDataItem(){
		var name = $('#name').val();
		var proportys = $('#proportys').val();
		var units = $('#units').val();
		
		if(name==""){
			$.messager.popover({msg:'名称不能为空!',type:'error'});
			return;
		}
		if(units==""){
			$.messager.popover({msg:'单位不能为空!',type:'error'});
			return;
		}
		if(proportys==""){
			$.messager.popover({msg:'属性不能为空!',type:'error'});
			return;
		}
		
		proportys = proportys.replace(/\n/g, "^");
		
		$m({
			ClassName:'NurMp.InOutVolume.PropertyMap',
			MethodName:'save',
			pName:name,
			pUnits:units,
			items:proportys,
			guid:'',
			hospId:hospId
		},function(result){
			if(result==0){
				$.messager.popover({msg:"保存成功",type:"success"});
			}else{
				$.messager.popover({msg:result,type:"error"});
			}
			$('#bindGrid').datagrid('reload');
			
		});
	}
	
	initUI();
});