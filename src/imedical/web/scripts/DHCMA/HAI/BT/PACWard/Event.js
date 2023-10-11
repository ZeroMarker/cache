//页面Event
function InitPACWardWinEvent(obj){
	//检索框
	$('#searchbox').searchbox({ 
		searcher:function(value,name){
			searchText($("#gridPACWard"),value);
		}	
	});	
	
	obj.LoadEvent = function(args){
		$('#gridPACWard').datagrid('loadData',{ 'total':'0',rows:[] });  //初始加载显示记录为0
		obj.gridPACWardLoad();
		$('#btnSave').on('click', function(){
	     	obj.btnSave_click();
	 	});
		$('#btnClose').on('click', function(){
		    $HUI.dialog('#PACWardEdit').close();
	    });
		$("#btnWardSubNo").on('click', function(){
			var rowData = obj.gridPACWard.getSelected();
			var rowDataID =rowData["WardID"];				
			var flg = $m({
				ClassName:"DHCHAI.BTS.PACWardSrv",
				MethodName:"PACWardSubNo",
				aWardID:rowDataID 
			},false);
			if (parseInt(flg)<0){
				$.messager.alert("失败提示","分区失败!提示码=" + flg,'info');
			} else {
				$.messager.popover({msg: '分区成功!',type:'success',timeout: 1000});
				obj.RecRowID = "";
				obj.gridPACWardLoad() ;//刷新当前页
			}
		});	
		$("#btnEdit").on('click', function(){
			var rowData = obj.gridPACWard.getSelected();
			obj.layer_rd=rowData;
			obj.Layer(rowData);
		});	
		//删除		
		$('#btnDelete').click(function () {
			var rowData = obj.gridPACWard.getSelected();
			var rowDataID =rowData["WardID"];
			$.messager.confirm("重置", "确定重置选中病区信息?", function (r) {				
				if (r) {				
					var flg = $m({
						ClassName:"DHCHAI.BT.PACWard",
						MethodName:"DeleteById",
						aId:rowDataID
					},false);
					if (parseInt(flg)<0){
						$.messager.alert("失败提示","重置失败!提示码=" + flg,'info');
					} else {
						$.messager.popover({msg: '重置成功！',type:'success',timeout: 1000});
						obj.RecRowID = "";
						obj.gridPACWardLoad() ;//刷新当前页
					}
				} 
			});	
		});
	}
	
	//窗体初始化
	obj.PACWardEdit =function() {
		$('#PACWardEdit').dialog({
			title: '病区分布定义',
			iconCls:"icon-w-paper",
			modal: true,
			isTopZindex:true
		});
	},

	// 病区分布定义-保存
	obj.btnSave_click = function(){
		var errinfo="";
		var rd = obj.layer_rd;		
		var ID         = (rd ? rd["WardID"] : '');
		var LocDr      = (rd ? rd["ID"] : '');
		var BuildingDr = $('#WardBuilding').combobox('getValue');
		var Floor      = $('#txtFloor').val();
		var Area       = $('#txtArea').val();
		var SubNo      = $('#txtSubNo').val();
		var AreaColor  = $('#txtAreaColor').val();
		if (!LocDr) {
			errinfo = errinfo + "科室不允许为空!<br>";
		}
		if (!SubNo) {
			errinfo = errinfo + "分区号不允许为空!<br>";
		}
		if (!BuildingDr) {
			errinfo = errinfo + "病房大楼不允许为空!<br>";
		}
		if (!/^(-|\+)?[0-9]*$/.test(Floor)) {
			errinfo = errinfo + "楼层必须为数字!<br>";
		}
		if (!/^(-|\+)?[0-9]*$/.test(SubNo)) {
			errinfo = errinfo + "分区号必须为数字!<br>";
		}
		if (errinfo) {
			$.messager.alert("错误提示", errinfo, 'info');
			return;
		}		
		var InputStr = ID;		
		InputStr += "^" + LocDr;
		InputStr += "^" + BuildingDr;
		InputStr += "^" + Floor;
		InputStr += "^" + Area;
		InputStr += "^" + SubNo;
		InputStr += "^" + AreaColor;
		var retval = $m({
			ClassName:"DHCHAI.BT.PACWard",
			MethodName:"Update",
			aInputStr:InputStr,
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
			$HUI.dialog('#PACWardEdit').close();
			$.messager.popover({msg: '保存成功！',type:'success',timeout: 1000});
			originalData["gridPACWard"]=""
			obj.gridPACWardLoad() ;//刷新当前页
		}
	}

	//单击选中事件
	obj.gridPACWard_onSelect = function (){
		var rowData = obj.gridPACWard.getSelected();
		if (rowData["ID"] == obj.RecRowID) {
			$("#btnWardSubNo").linkbutton("disable");
			$("#btnEdit").linkbutton("disable");
			$("#btnDelete").linkbutton("disable");
			obj.RecRowID="";
			obj.gridPACWard.clearSelections();
		}else{
			obj.RecRowID = rowData["ID"];
			if(!rowData["Building"]){
				$("#btnWardSubNo").linkbutton("disable");
				}else{
					$("#btnWardSubNo").linkbutton("enable");
				}
			$("#btnEdit").linkbutton("enable");
			$("#btnDelete").linkbutton("enable");
			$("#btnWardSubNo").linkbutton("enable");
		}	
	}
			
	//双击编辑事件
	obj.gridPACWard_onDbselect = function(rd){
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
			var WardBuildingID = rd["BuildingID"];
			var WardBuildingDesc = rd["Building"];
			var txtFloor = rd["Floor"];
			var txtArea = rd["Area"];
			var SubNo=rd["SubNo"];
			if (SubNo=="") {SubNo=1} // 默认为1
			var txtSubNo = SubNo;
			var txtAreaColor = rd["AreaColor"];
			
			$('#WardBuilding').combobox('setValue',WardBuildingID);
			$('#WardBuilding').combobox('setText',WardBuildingDesc);
			$('#txtFloor').val(txtFloor);
			$('#txtArea').val(txtArea);
			$('#txtSubNo').val(txtSubNo);
			$('#txtAreaColor').val(txtAreaColor);
			$("#WardBuilding,#txtSubNo").validatebox({required:true});
		}else {
			obj.RecRowID="";
			$('#WardBuilding').combobox('setValue','');
			$('#txtFloor').val("");
			$('#txtArea').val("");
			$('#txtSubNo').val("1");
			$('#txtAreaColor').val("");
			$("#WardBuilding,#txtSubNo").validatebox({required:true});
		}
		$('#PACWardEdit').show();
		obj.PACWardEdit();
	}
	
	obj.gridPACWardLoad = function(){
		$("#gridPACWard").datagrid("loading");	
		$cm ({
		    ClassName:"DHCHAI.BTS.PACWardSrv",
			QueryName:"QryWard",		
	    	page:1,
			rows:9999
		},function(rs){
			$('#gridPACWard').datagrid({loadFilter:pagerFilter}).datagrid('loadData', rs);					
		});
    }
}