//页面Event
function InitOEItmMastWinEvent(obj){
	//检索框
	$('#searchbox').searchbox({ 
		searcher:function(value,name){
			searchText($("#gridOEItmMast"),value);
		}	
	});	
	
	obj.LoadEvent = function(args){
		$('#gridOEItmMast').datagrid('loadData',{ 'total':'0',rows:[] });  //初始加载显示记录为0
		obj.gridOEItmMastLoad();
		$('#btnSave').on('click', function(){
	     	obj.btnSave_click();
	 	});
	 	
		$('#btnClose').on('click', function(){
		    $HUI.dialog('#OEItmMastEdit').close();
	    });
	    
		$("#btnAdd").on('click', function(){
			obj.layer_rd = '';
			obj.Layer();
		});
		
		$("#btnEdit").on('click', function(){
			var rowData = obj.gridOEItmMast.getSelected();
			obj.layer_rd=rowData;
			obj.Layer(rowData);
		});
			
		//删除		
		$('#btnDelete').click(function () {
			var rowData = obj.gridOEItmMast.getSelected();
			var rowDataID =rowData["ID"];
			$.messager.confirm("删除", "确定删除选中数据记录?", function (r) {				
				if (r) {				
					var flg = $m({
						ClassName:"DHCHAI.DP.OEItmMast",
						MethodName:"DeleteById",
						Id:rowDataID
					},false);
					if (parseInt(flg)<0){
						if (parseInt(flg)=='-777') {
							$.messager.alert("提示","-777：当前无删除权限，请启用删除权限后再删除记录!",'info');
						}else {
							$.messager.alert("提示","删除失败!",'info');
						}
						return;
					} else {
						$.messager.popover({msg: '删除成功！',type:'success',timeout: 1000});
						obj.RecRowID = "";
						obj.gridOEItmMastLoad();//刷新当前页
					}
				} 
			});		

		});
	}
	
	//窗体初始化
	obj.OEItmMastEdit =function() {
		$('#OEItmMastEdit').dialog({
			title: '医嘱项编辑',
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
		var BTCode = $('#txtBTCode').val();
		var BTDesc = $('#txtBTDesc').val();
		var BTCatDr = $('#cboBTCatDr').combobox('getValue');
		var IsActive = $('#chkIsActive').checkbox('getValue');
		var PFIsActive = (IsActive==1 ? '1':'0');
		if (!BTCode) {
			errinfo = errinfo + "医嘱代码不允许为空!<br>";
		}
		if (!BTDesc) {
			errinfo = errinfo + "医嘱名称不允许为空!<br>";
		}
		if (errinfo) {
			$.messager.alert("错误提示", errinfo, 'info');
			return;
		}	
		var inputStr = ID;
		inputStr = inputStr + "^" + BTCode;
		inputStr = inputStr + "^" + BTDesc;
		inputStr = inputStr + "^" + BTCatDr;
		inputStr = inputStr + "^" + PFIsActive;
		var flg = $m({
			ClassName:"DHCHAI.DP.OEItmMast",
			MethodName:"Update",
			InStr:inputStr,
			aSeparete:"^"
		},false);
		if (parseInt(flg) <= 0) {
			if (parseInt(flg) == 0) {
				$.messager.alert("失败提示", "保存失败!返回码=" + flg, 'info');
			} else if (parseInt(flg) == '-100') {
				$.messager.alert("失败提示", "代码重复!" , 'info');
			} else {
				$.messager.alert("失败提示", "保存失败!返回码=" + flg, 'info');
			}
		} else {
			$HUI.dialog('#OEItmMastEdit').close();
			$.messager.popover({msg: '保存成功！',type:'success',timeout: 1000});
			obj.gridOEItmMastLoad();//刷新当前页
		}
	}

	//单击选中事件：选择易感因素
	obj.gridOEItmMast_onSelect = function (){
		var rowData = obj.gridOEItmMast.getSelected();
		if (rowData["ID"] == obj.RecRowID) {
			$("#btnAdd").linkbutton("enable");
			$("#btnEdit").linkbutton("disable");
			$("#btnDelete").linkbutton("disable");
			obj.RecRowID="";
			obj.gridOEItmMast.clearSelections();
		}else{
			obj.RecRowID = rowData["ID"];
			$("#btnAdd").linkbutton("disable");
			$("#btnEdit").linkbutton("enable");
			$("#btnDelete").linkbutton("enable");
		}	
	}
		
	//双击编辑事件
	obj.gridOEItmMast_onDbselect = function(rd){
		//alert(JSON.stringify(rowData));
		obj.layer_rd=rd;
		obj.Layer(rd);
	}
	
	//易感因素编辑窗体-初始化
	obj.Layer = function(rd){
		if (rd){
			var txtCode = rd["BTCode"];
			var txtDesc = rd["BTDesc"];
			var cboBTCatDr= rd["BTCatDr"];
			var BTIsActive = rd["BTIsActive"];
			chkIsActive = (BTIsActive=="1"? true: false);
			$('#txtBTCode').val(txtCode);
			$('#txtBTDesc').val(txtDesc);
			$('#cboBTCatDr').combobox('setValue',cboBTCatDr);
			$('#chkIsActive').checkbox('setValue',chkIsActive);
			$("#txtBTCode,#txtBTDesc").validatebox({required:true});
		}else {
			obj.RecRowID="";
			$('#txtBTCode').val("");
			$('#txtBTDesc').val("");
			$('#cboBTCatDr').combobox('setValue','');
			$('#chkIsActive').checkbox('setValue',"");
			$("#txtBTCode,#txtBTDesc").validatebox({required:true});
		}
		$('#OEItmMastEdit').show();
		obj.OEItmMastEdit();
	}

	obj.gridOEItmMastLoad = function(){
		$("#gridOEItmMast").datagrid("loading");	
		$cm ({
		    ClassName:"DHCHAI.DPS.OEItmMastSrv",
			QueryName:"QryOEItmMast",		
	    	page:1,
			rows:9999
		},function(rs){
			$('#gridOEItmMast').datagrid({loadFilter:pagerFilter}).datagrid('loadData', rs);					
		});
    }
}