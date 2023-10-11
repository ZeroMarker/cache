//页面Event
function InitMapRuleWinEvent(obj){
	//检索框
	$('#searchbox').searchbox({ 
		searcher:function(value,name){ 
			obj.gridMapRule.load({
				ClassName:'DHCHAI.DPS.DataMapRuleSrv',
				QueryName:'QryRulebByCat',
				aCatID:$('#cboCat').combobox('getValue'),
				aAlias:value
			});
		}	
	});
	$("#cboCat").combobox({
		onSelect:function(record){
			obj.gridMapRule.reload({
				ClassName:"DHCHAI.DPS.DataMapRuleSrv",
				QueryName:"QryRulebByCat",	
				aCatID:record.ID
			});					 	 
		}	 	
	})
	obj.LoadEvent = function(args){
		$('#btnSave').on('click', function(){
	     	obj.btnSave_click();
	 	});
	 	
		$('#btnClose').on('click', function(){
		    $HUI.dialog('#MapRuleEdit').close();
	    });
	    
		$("#btnAdd").on('click', function(){
		
			CatId = $('#cboCat').combobox('getValue');
			if (CatId == ''){
				$.messager.alert('信息','请选择分类!');
				return;
			}	
			obj.layer_rd = '';
			obj.Layer();
		});
		
		$("#btnEdit").on('click', function(){
			var CatId = $('#cboCat').combobox('getValue');
			if (CatId == ''){
				$.messager.alert('请选择分类!',errinfo, 'info');
				return;
			}
			var rowData = obj.gridMapRule.getSelected();
			obj.layer_rd=rowData;
			obj.Layer(rowData);
		});
			
		//删除		
		$('#btnDelete').click(function () {
			var rowData = obj.gridMapRule.getSelected();
			var rowDataID =rowData["ID"];
			$.messager.confirm("删除", "确定删除选中数据记录?", function (r) {				
				if (r) {				
					var flg = $m({
						ClassName:"DHCHAI.DP.DataMapRule",
						MethodName:"DeleteById",
						Id:rowDataID
					},false);
					if (parseInt(flg)<0){
						$.messager.alert("失败提示","删除失败!提示码=" + flg,'info');
					} else {
						$.messager.popover({msg: '删除成功！',type:'success',timeout: 1000});
						obj.RecRowID = "";
						obj.gridMapRule.reload() ;//刷新当前页
					}
				} 
			});	
		});
	}
	
	//窗体初始化
	obj.MapRuleEdit =function() {
		$('#MapRuleEdit').dialog({
			title: '对照匹配规则',
			iconCls:"icon-w-paper",
			modal: true,
			isTopZindex:true
		});
	},
	
	//保存
	obj.btnSave_click = function(){
		var errinfo="";
		var rd = obj.layer_rd;		
		var ID = (rd ? rd["ID"] : '');
		var CatDr = $('#cboCat').combobox('getValue');
		var Desc = $('#txtDesc').val();
		var MapDesc = $('#txtMapDesc').val();
		var Type = $('#cboType').combobox('getValue');
		if (!Desc) {
			errinfo = errinfo + "标准名称不允许为空!<br>";
		}
		if (!MapDesc) {
			errinfo = errinfo + "对照短语不允许为空!<br>";
		}
		if (!Type) {
			errinfo = errinfo + "类型不允许为空!<br>";
		}
		if (errinfo) {
			$.messager.alert("错误提示", errinfo, 'info');
			return;
		}		
		var InputStr = ID;
		InputStr += "^" + CatDr;
		InputStr += "^" + Desc;
		InputStr += "^" + MapDesc;
		InputStr += "^" + Type;
		var retval = $m({
			ClassName:"DHCHAI.DP.DataMapRule",
			MethodName:"Update",
			aInStr:InputStr,
			aSeparete:"^"
		},false);
		if (parseInt(retval) <= 0) {
			if (parseInt(retval) == 0) {
				$.messager.alert("失败提示", "保存失败!返回码=" + retval, 'info');
			} else if (parseInt(retval) == -2) {
				$.messager.alert("失败提示", "匹配规则重复或错误!" , 'info');
			} else {
				$.messager.alert("失败提示", "保存失败!返回码=" + retval, 'info');
			}
		} else {
			$HUI.dialog('#MapRuleEdit').close();
			$.messager.popover({msg: '保存成功！',type:'success',timeout: 1000});
			obj.gridMapRule.reload() ;//刷新当前页
		}
	}

	//单击选中事件：选择对照匹配规则
	obj.gridMapRule_onSelect = function (){
		var rowData = obj.gridMapRule.getSelected();
		if (rowData["ID"] == obj.RecRowID) {
			$("#btnAdd").linkbutton("enable");
			$("#btnEdit").linkbutton("disable");
			$("#btnDelete").linkbutton("disable");
			obj.RecRowID="";
			obj.gridMapRule.clearSelections();
		}else{
			obj.RecRowID = rowData["ID"];
			$("#btnAdd").linkbutton("disable");
			$("#btnEdit").linkbutton("enable");
			$("#btnDelete").linkbutton("enable")
		}	
	}
			
	//双击编辑事件
	obj.gridMapRule_onDbselect = function(rd){
		CatId = rd.CatID;
		if (CatId == ''){
			$.messager.alert('信息','请先选择分类，再添加数据!');
			return;
		}
		obj.layer_rd=rd;
		obj.Layer(rd);
	}
		
	//对照匹配规则信息编辑窗体-初始化
	obj.Layer = function(rd){
		if (rd){
			var txtDesc = rd["Desc"];
			var txtMapDesc = rd["MapDesc"];
			var cboType = rd["Type"];
			$('#txtDesc').val(txtDesc);
			$('#txtMapDesc').val(txtMapDesc);
			$('#cboType').combobox('setValue',cboType);
			$("#txtDesc,#txtMapDesc").validatebox({required:true});
		}else {
			obj.RecRowID="";
			$('#txtDesc').val("");
			$('#txtMapDesc').val("");
			$('#cboType').combobox('setValue','');
			$("#txtDesc,#txtMapDesc").validatebox({required:true});
		}
		$('#MapRuleEdit').show();
		obj.MapRuleEdit();
	}
}