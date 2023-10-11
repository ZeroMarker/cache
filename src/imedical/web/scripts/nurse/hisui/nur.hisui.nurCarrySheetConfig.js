$("#Loading").hide();
$(function() {
	hospComp = GenHospComp("Nur_IP_NurCarrySheetSet",session["LOGON.USERID"]+'^'+session["LOGON.GROUPID"]+'^'+session["LOGON.CTLOCID"]+'^'+session["LOGON.HOSPID"]);
	hospID=hospComp.getValue();
	hospComp.options().onSelect = function(i,d){
		hospID=d.HOSPRowId;   
		loadCarrySheetConfig();
		initCarrySheetSplitConfig();
	}
	loadCarrySheetConfig();
	initCarrySheetSplitConfig();
})
function loadCarrySheetConfig(){
	$.cm({
		ClassName:"Nur.NIS.Service.SpecManage.CarrySheetConfig",
		MethodName:"getCarrySheetConfig",
		hospId:hospID
	},function(data){
		$("#maxSpecNum").numberbox("setValue",data.maxSpecNum);
		$("#specDisplayOrder").combobox("setValue",data.specDisplayOrder);
		$("[name='forBidSameSheetRules']").checkbox("setValue",false);
		for (var i=0;i<data.forBidSameSheetRules.split("^").length;i++){
			var id=data.forBidSameSheetRules.split("^")[i]
			if (id=="") continue;
			$("#"+id+"Checkbox").checkbox("setValue",true);
		}
		$("#defDisplaySheetType").combobox('setValue',data.defDisplaySheetType);
		$("#isAllowChangeDisplaySheetType").switchbox("setValue",data.isAllowChangeDisplaySheetType=="Y"?true:false);
	})
}
function saveCarrySheetConfig(){
	var maxSpecNum=$.trim($("#maxSpecNum").numberbox("getValue"));
	var specDisplayOrder=$("#specDisplayOrder").combobox("getValue");
	var checked=$("[name='forBidSameSheetRules']:checked");
	var forBidSameSheetRules="";
	for (var i=0;i<checked.length;i++){
		forBidSameSheetRules=forBidSameSheetRules+"^"+checked[i].value;
	}
	var defDisplaySheetType=$("#defDisplaySheetType").combobox('getValue');
	var isAllowChangeDisplaySheetType=$("#isAllowChangeDisplaySheetType").switchbox("getValue")?"Y":"N";
	$.cm({
		ClassName:"Nur.NIS.Service.SpecManage.CarrySheetConfig",
		MethodName:"saveCarrySheetConfig",
		maxSpecNum:maxSpecNum,
		disPlayOrder:specDisplayOrder,
		forBidSameSheetRules:forBidSameSheetRules,
		defDisplaySheetType:defDisplaySheetType,
		isAllowChangeDisplaySheetType:isAllowChangeDisplaySheetType,
		hospId:hospID
	},function(rtn){
		if(rtn==0){
			$.messager.popover({ msg: "保存成功！", type:'success' });	
		}else{
			$.messager.popover({ msg: "保存失败！", type:'error' });			
		}
	})
}
function initCarrySheetSplitConfig(){
	initCarrySplitGroupSetTab();
	initCarrySplitGroupItemSetTab();
}
function initCarrySplitGroupSetTab(){
	$('#carrySplitGroupSetTab').datagrid({
		nowrap: false,
        singleSelect: true,
        idField: 'Index',
        border:false,
        fit: true,
        url: $URL,
        queryParams: {
            ClassName: "Nur.NIS.Service.SpecManage.CarrySheetConfig",
            QueryName: 'getCarrySplitGroupList'
        },
        toolbar: '#carrySplitGroupSetTabToolBar',
        columns: [
            [
                { field: 'CSGName', title: '分组名称', width: 200, editor: 'text',options:{required: true} },
                { field: 'CSGActive', title: '状态',align:'center',width:75,editor :{
						type : 'icheckbox',options:{on:'Y',off:'N'}
					}
				}
            ]
        ],
        onDblClickRow: function(index, row) {
	    	$(this).datagrid('beginEdit', index);
	    },
        onBeforeLoad:function(param){
	        $("#carrySplitGroupSetTab").datagrid("unselectAll");
	        param.splitType=getSplitType();
	        param.HospDr=hospID;
	    },
	    onSelect:function(rowIndex, rowData){
		    $('#carrySplitGroupItemSetTab').datagrid("reload");
		}
	})
}
function carrySplitGroupAdd(){
	var maxRow=$("#carrySplitGroupSetTab").datagrid("getRows");
	$("#carrySplitGroupSetTab").datagrid("appendRow", {
		Index:maxRow.length,
        id: '',
        CSGName: '',
        CSGActive:'Y'
    })
    var editIndex=maxRow.length-1;
    $("#carrySplitGroupSetTab").datagrid("beginEdit", editIndex);
}
function deleteCarrySplitGroup(){
	var rows = $("#carrySplitGroupSetTab").datagrid("getSelections");
	if (rows.length > 0) {
		$.messager.confirm("提示", "确定要删除吗?",
        function(r) {
            if (r) {
                var delDataArr=[],delIndexArr=[];
                for (var i = 0; i < rows.length; i++) {
                    var id=rows[i].id;
                    if (id) {
                        delDataArr.push(id);
                    }
                    delIndexArr.push($("#carrySplitGroupSetTab").datagrid("getRowIndex",rows[i].Index));
                }
                var value=$.m({ 
					ClassName:"Nur.NIS.Service.SpecManage.CarrySheetConfig", 
					MethodName:"handleCarrySplitGroup",
					event:"DELETE",
					dataArr:JSON.stringify(delDataArr)
				},false);
		        if(value=="0"){
			       for (var i = delIndexArr.length-1; i >=0; i--) {
				       $("#carrySplitGroupSetTab").datagrid("deleteRow",delIndexArr[i]);
				   }
				   $('#carrySplitGroupItemSetTab').datagrid('reload');
			       $.messager.popover({msg: '删除成功!',type: 'success'});
		        }else{
			       $.messager.popover({msg: '删除失败:'+value,type: 'error'});
		        }
            }
        });
	}else{
		$.messager.popover({msg: '请选择要删除的行!',type: 'error'});
	}
}
function saveCarrySplitGroup(){	
	var saveDataArr=[],tableDataArr=[];NullValColumnArr=[],repeatArr=[];
    var rows = $('#carrySplitGroupSetTab').datagrid('getRows');
    for (var j=0;j<rows.length;j++){
	    var rowDataArr=[];
		var editors=$('#carrySplitGroupSetTab').datagrid('getEditors',j);
		if (editors.length ==0) {
			tableDataArr.push({"field":"CSGName","fieldValue":rows[j].CSGName});
			continue;
		}
		var CSGName=editors[0].target.val();
		if ($.hisui.indexOfArray(tableDataArr,"fieldValue",CSGName)>=0) {
			repeatArr.push("第"+(j+1)+"行");
		}
		tableDataArr.push({"field":"CSGName","fieldValue":CSGName});
			
		var rowNullValArr=[];
		for (var k=0;k<editors.length;k++){
			var field=editors[k].field;
			var fieldType=editors[k].type;
			if (fieldType=="text"){
				var value=editors[k].target.val();
			}else{
				var value=editors[k].target.checkbox("getValue")?"Y":"N";
			}
			value=$.trim(value);
			var fieldOpts = $('#carrySplitGroupSetTab').datagrid('getColumnOption',field);
			if (fieldOpts.options){
				if ((fieldOpts.options.required)&&(!value)){
					rowNullValArr.push(fieldOpts.title);
				}
			}
			rowDataArr.push({"field":field,"fieldValue":value});
		}
		if (rowNullValArr.length>0){
			NullValColumnArr.push("第"+(j+1)+"行"+rowNullValArr.join("、"));
		}
		if (rowDataArr.length>0){
			var id=rows[j].id;
			if (!id) id="";
			rowDataArr.push({"field":"id","fieldValue":id});
			rowDataArr.push({"field":"CSGType","fieldValue":getSplitType()});
			rowDataArr.push({"field":"CSGHospDr","fieldValue":hospID});
			saveDataArr.push(rowDataArr);
		}
	}
	if (saveDataArr.length==0){
		$.messager.popover({msg: '没有需要保存的数据！',type: 'error'});
		return false;
	}
	var ErrMsgArr=[];
	if (repeatArr.length>0){
		ErrMsgArr.push(repeatArr.join("、")+ " 数据重复！");
	}
	if (NullValColumnArr.length>0){
		ErrMsgArr.push(NullValColumnArr.join("、")+ " 不能为空！");
	}
	if (ErrMsgArr.length>0){
		$.messager.alert("提示",ErrMsgArr.join(";"));
		return false;
	}
	$.cm({
		ClassName:"Nur.NIS.Service.SpecManage.CarrySheetConfig",
		MethodName:"handleCarrySplitGroup",
		event:"SAVE",
		dataArr:JSON.stringify(saveDataArr)
	},function(rtn){
		if (rtn ==0) {
			$.messager.popover({msg: '保存成功！',type: 'success'});
			$('#carrySplitGroupSetTab').datagrid('reload');
		}else{
			$.messager.popover({msg: '保存失败！'+rtn,type: 'error'});
		}
	})
}
function initCarrySplitGroupItemSetTab(){
	$('#carrySplitGroupItemSetTab').datagrid({
		nowrap: false,
        singleSelect: false,
        idField: 'id',
        border:false,
        fit: true,
        url: $URL,
        queryParams: {
            ClassName: "Nur.NIS.Service.SpecManage.CarrySheetConfig",
            QueryName: 'getCarrySplitItemList'
        },
        toolbar: [{
			iconCls: 'icon-save',
			text: '保存',
			handler: function() {
				saveCarrySplitGroupItem();
			}
		}],
        columns: [
            [
            	{ field: 'id', title: '',checkbox:true},
                { field: 'desc', title: '标本类型', width: 190},
            ]
        ],
        onBeforeLoad:function(param){
	        $("#carrySplitGroupItemSetTab").datagrid("unselectAll");
	        var carrySheetGurop="";
	        var rows = $("#carrySplitGroupSetTab").datagrid("getSelections");
	        if (rows.length){
	        	carrySheetGurop=rows[0].id;
	        }
	        if (!carrySheetGurop) carrySheetGurop="";
	        param.carrySheetGurop=carrySheetGurop;
	    },
	    onLoadSuccess:function(data){
		    echoFilterSet(data.rows,"carrySplitGroupItemSetTab");
		    var splitType=getSplitType();
		    if (splitType=="Specimen"){
			    $('#carrySplitGroupItemSetTab').datagrid('setColumnTitle',{
					'desc': '标本类型'
				});
			}else if(splitType=="ItemSubCat"){
				$('#carrySplitGroupItemSetTab').datagrid('setColumnTitle',{
					'desc': '医嘱子类'
				});
			}
		}
	})
}
function saveCarrySplitGroupItem(){
	var rows=$("#carrySplitGroupSetTab").datagrid("getSelections");
	if (rows.length==0){
		$.messager.popover({msg: '请选择分组！',type: 'error'});
		return false;
	}else{
		var groupId=rows[0].id;
		if (!groupId) {
			$.messager.popover({msg: '请选择已保存的分组！',type: 'error'});
			return false;
		}
	}
	var rows=$("#carrySplitGroupItemSetTab").datagrid("getSelections");
	var selData=getStr(rows);
	var notSelData=getNotSelStr("carrySplitGroupItemSetTab");
	$.cm({
		ClassName:"Nur.NIS.Service.SpecManage.CarrySheetConfig",
		MethodName:"handleCarrySplitItem",
		groupId:groupId,
		selData:selData,
		notSelData:notSelData,
	},function(rtn){
		if (rtn ==0) {
			$.messager.popover({msg: '保存成功！',type: 'success'});
			$('#carrySplitGroupItemSetTab').datagrid('reload');
		}else{
			$.messager.popover({msg: '保存失败！'+rtn,type: 'error'});
		}
	})
}
function getStr(data){
	var str=""
	if(data.length>0){
		var array=[];
		data.forEach(function(val,index){
			var value=val.id;			
			array.push(value);	
		})
		str=array.join("^");	
	}	
	return str;	
}
function getNotSelStr(tableId){
	var rows=$('#'+tableId).datagrid('getRows');
	var GridSelectArr=$('#'+tableId).datagrid('getSelections');
	var subPara="";
	for (var i=0;i<rows.length;i++){
		var id=rows[i].id;
		if ($.hisui.indexOfArray(GridSelectArr,"id",id)<0) {
			if (subPara == "") subPara = id;
			else  subPara = subPara + "^" + id;
		}
	}
	return subPara;
}
function splitTypeChange(){
	setTimeout(function(){
		$("#carrySplitGroupSetTab,#carrySplitGroupItemSetTab").datagrid("reload");
	});
}
function getSplitType(){
	return $("#splitType").combobox("getValue");
}
function echoFilterSet(array,obj){
	$("#"+obj).datagrid("unselectAll");	
	if(array.length){
		if(typeof result=="number"){
			result=JSON.stringify(result);	
		}
		array.forEach(function(val,index){
			if (val.selected==1){
				$("#"+obj).datagrid("selectRecord",val);
			}	
		});				
	}		
}