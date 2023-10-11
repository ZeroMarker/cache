//页面Event
function InitOEAntiMastWinEvent(obj){	
	//检索框
	$('#searchbox').searchbox({ 
		searcher:function(value,name){
			searchText($("#gridOEAntiMast"),value);
		}	
	});	
	
	obj.LoadEvent = function(args){
		$('#gridOEAntiMast').datagrid('loadData',{ 'total':'0',rows:[] });  //初始加载显示记录为0
		obj.gridOEAntiMastLoad();
		$('#btnSave').on('click', function(){
	     	obj.btnSave_click();
	 	});
		$('#btnClose').on('click', function(){
		    $HUI.dialog('#OEAntiMastEdit').close();
	    });
		$("#btnAdd").on('click', function(){
			obj.layer_rd = '';
			obj.Layer();
		});
		$("#btnEdit").on('click', function(){
			var rowData = obj.gridOEAntiMast.getSelected();
			obj.layer_rd=rowData;
			obj.Layer(rowData);
		});	
		//删除		
		$('#btnDelete').click(function () {
			var rowData = obj.gridOEAntiMast.getSelected();
			var rowDataID =rowData["ID"];
			$.messager.confirm("删除", "确定删除选中数据记录?", function (r) {				
				if (r) {				
					var flg = $m({
						ClassName:"DHCHAI.DP.OEAntiMast",
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
						obj.gridOEAntiMastLoad();//刷新当前页
					}
				} 
			});		

		});
	}
	
	//窗体初始化
	obj.OEAntiMastEdit =function() {
		$('#OEAntiMastEdit').dialog({
			title: '抗菌药物字典编辑',
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
		var BTName = $('#txtBTName').val();
		var BTName1 = $('#txtBTName1').val();
		var BTCatDr = $('#cboBTCatDr').combobox('getValue');
		var IsActive = $('#chkIsActive').checkbox('getValue');
		var PFIsActive = (IsActive==1 ? '1':'0');
		var IsKeyDrugs = $('#chkIsKeyDrugs').checkbox('getValue');
		var IsKeyDrugs = (IsKeyDrugs==1 ? '1':'0');
		
		if (!BTCode) {
			errinfo = errinfo + "代码不允许为空!<br>";
		}
		if (!BTName) {
			errinfo = errinfo + "中文名不允许为空!<br>";
		}
		if (errinfo) {
			$.messager.alert("错误提示", errinfo, 'info');
			return;
		}	
		var inputStr = ID;
		inputStr = inputStr + "^" + BTCode;
		inputStr = inputStr + "^" + BTName;
		inputStr = inputStr + "^" + BTName1;
		inputStr = inputStr + "^" + BTCatDr;
		inputStr = inputStr + "^" + PFIsActive;
		inputStr = inputStr + "^" + IsKeyDrugs;
		var flg = $m({
			ClassName:"DHCHAI.DP.OEAntiMast",
			MethodName:"Update",
			InStr:inputStr,
			aSeparete:"^"
		},false);
		if (parseInt(flg) <= 0) {
			if (parseInt(flg) == 0) {
				$.messager.alert("失败提示", "保存失败!返回码=" + flg, 'info');
			} else if (parseInt(flg) == '-100') {
				$.messager.alert("失败提示", "代码或中文名重复!" , 'info');
			} else {
				$.messager.alert("失败提示", "保存失败!返回码=" + flg, 'info');
			}
		} else {
			$HUI.dialog('#OEAntiMastEdit').close();
			$.messager.popover({msg: '保存成功！',type:'success',timeout: 1000});
			obj.gridOEAntiMastLoad();//刷新当前页
		}
	}

	//单击选中事件
	obj.gridOEAntiMast_onSelect = function (){
		var rowData = obj.gridOEAntiMast.getSelected();
		if (rowData["ID"] == obj.RecRowID) {
			$("#btnAdd").linkbutton("enable");
			$("#btnEdit").linkbutton("disable");
			$("#btnDelete").linkbutton("disable");
			obj.RecRowID="";
			obj.gridOEAntiMast.clearSelections();
		}else{
			obj.RecRowID = rowData["ID"];
			$("#btnAdd").linkbutton("disable");
			$("#btnEdit").linkbutton("enable");
			$("#btnDelete").linkbutton("enable");
		}	
	}
		
	//双击编辑事件
	obj.gridOEAntiMast_onDbselect = function(rd){
		obj.layer_rd=rd;
		obj.Layer(rd);
	}
	
	//编辑窗体-初始化
	obj.Layer = function(rd){
		if (rd){
			var txtCode = rd["BTCode"];
			var txtName = rd["BTName"];
			var txtName1 = rd["BTName1"];
			var cboBTCatDr = rd["BTCatDr"];
			var BTIsActive = rd["BTIsActive"];
			BTIsActive = (BTIsActive=="1"? true: false);
			var IsKeyDrugs= rd["IsKeyDrugs"];
			IsKeyDrugs = (IsKeyDrugs=="1"? true: false);
			$('#txtBTCode').val(txtCode);
			$('#txtBTName').val(txtName);
			$('#txtBTName1').val(txtName1);
			$('#cboBTCatDr').combobox('setValue',cboBTCatDr);
			$('#chkIsActive').checkbox('setValue',BTIsActive);
			$('#chkIsKeyDrugs').checkbox('setValue',IsKeyDrugs);	
			$("#txtBTCode,#txtBTName").validatebox({required:true});
		}else {
			obj.RecRowID="";
			$('#txtBTCode').val("");
			$('#txtBTName').val("");
			$('#txtBTName1').val("");
			$('#cboBTCatDr').combobox('setValue','');
			$('#chkIsActive').checkbox('setValue',"");
			$('#chkIsKeyDrugs').checkbox('setValue',false);
			$("#txtBTCode,#txtBTName").validatebox({required:true});
		}
		$('#OEAntiMastEdit').show();
		obj.OEAntiMastEdit();
	}
	
	obj.gridOEAntiMastLoad = function(){
		$("#gridOEAntiMast").datagrid("loading");	
		$cm ({
		    ClassName:"DHCHAI.DPS.OEAntiMastSrv",
			QueryName:"QryOEAntiMast",		
	    	page:1,
			rows:9999
		},function(rs){
			$('#gridOEAntiMast').datagrid({loadFilter:pagerFilter}).datagrid('loadData', rs);					
		});
    }
}