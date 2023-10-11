//页面Event
function InitInfPosWinEvent(obj){
	//检索框
	$('#searchbox').searchbox({ 
		searcher:function(value,name){
			searchText($("#gridInfPos"),value);
		}	
	});	

	obj.LoadEvent = function(args){ 
		obj.chkInfSub();
	    obj.gridInfPosLoad();
	    //保存
		$('#btnSave').on('click', function(){
	     	obj.btnSave_click();
     	});
     	
		//关闭
		$('#btnClose').on('click', function(){
	     	$HUI.dialog('#InfPosEdit').close();
     	});
		
	    //添加
		$('#btnAdd').on('click', function(){
			obj.layer_rd = '';
			obj.Layer();
		});
		//编辑
		$('#btnEdit').on('click', function(){
			var rowData = obj.gridInfPos.getSelected();
			obj.layer_rd=rowData;
			obj.Layer(rowData);
		});
		
		//删除
		$('#btnDelete').on('click', function(){
			var rowData = obj.gridInfPos.getSelected();
			var rowDataID =rowData["ID"];
			$.messager.confirm("删除", "确定删除选中数据记录?", function (r) {				
				if (r) {				
					var flg = $m({
						ClassName:"DHCHAI.BT.InfPos",
						MethodName:"DeleteById",
						aId:rowDataID
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
						obj.gridInfPosLoad();
					}
				} 
			});	
		});	
		
		//诊断依据弹窗
		$('#btnGistSave').on('click', function(){
	     	obj.btnSave_Gist_click();
	 	});
		$('#btnGistClose').on('click', function(){
		    $HUI.dialog('#layergist').close();
	    });
		$("#btnGistAdd").on('click', function(){
			obj.layergist_rd = '';
			obj.Layer_Gist();
		});
		$("#btnGistEdit").on('click', function(){
			var rowData = obj.gridInfPosGist.getSelected();
			obj.layergist_rd=rowData;
			obj.Layer_Gist(rowData);
		});
		
		//删除		
		$('#btnGistDelete').click(function () {
			var rowData = obj.gridInfPosGist.getSelected();
			var rowDataID =rowData["ID"];
			$.messager.confirm("删除", "确定删除选中数据记录?", function (r) {				
				if (r) {				
					var flg = $m({
						ClassName:"DHCHAI.BT.InfPosGist",
						MethodName:"DeleteById",
						aId:rowDataID
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
						obj.gridInfPosGist.reload() ;//刷新当前页
					}
				} 
			});		
		});	
	}

	
	//窗体初始化
	obj.InfPosEdit =function() {
		$('#InfPosEdit').dialog({
			title: '感染诊断部位编辑',
			iconCls:"icon-w-paper",
			modal: true,
			isTopZindex:true
		})
	},
	
	//保存
	obj.btnSave_click = function(){
		var errinfo="";
		var rd = obj.layer_rd;
		var rowDataID =rd["ID"];
		var ID = (rd ? rd["ID"] : '');
		var Code = $('#txtBTCode').val();
		var Desc = $('#txtBTDesc').val();
		var GCode = $('#txtGCode').val();
		var DiagFlag = $('#chkDiagFlag').checkbox('getValue');
		var DiagFlag = (DiagFlag==1 ? '1':'0');
		var IsActive = $('#chkActive').checkbox('getValue');
		var IsActive = (IsActive==1 ? '1':'0');
		if (!Code) {
			errinfo = errinfo + "代码不允许为空!<br>";
		}
		if (!Desc) {
			errinfo = errinfo + "名称不允许为空!<br>";
		}
		if (!GCode) {
			errinfo = errinfo + "层级编码不允许为空!<br>";
		}
		if (errinfo) {
			$.messager.alert("错误提示", errinfo, 'info');
			return;
		}	
		if (DiagFlag == 0) {
			var rechk = $m({
				ClassName:"DHCHAI.BT.InfPosExt",
				MethodName:"CheckIsRelat",
				aId:rowDataID
			},false);
		
			if(rechk == 10 || rechk == 11){
				$.messager.alert("提示","该诊断已关联诊断分类，请先取消关联！",'info');
				var chkDiagFlag = rd["DiagFlag"];
				chkDiagFlag = (chkDiagFlag==1? true: false);
				$('#chkDiagFlag').checkbox('setValue',chkDiagFlag);
				return;
			}
		}	
		var inputStr = ID;
		inputStr = inputStr + "^" + Code;
		inputStr = inputStr + "^" + Desc;
		inputStr = inputStr + "^" + DiagFlag;
		inputStr = inputStr + "^" + GCode;
		inputStr = inputStr + "^" + IsActive;
	
		var retval = $m({
			ClassName:"DHCHAI.BT.InfPos",
			MethodName:"Update",
			aInputStr:inputStr,
			aSeparete:"^"
		},false);
		if (parseInt(retval) <= 0) {
			if (parseInt(retval) == 0) {
				$.messager.alert("失败提示", "更新数据失败!返回码=" + retval, 'info');
			} else if (parseInt(retval) == -2) {
				$.messager.alert("失败提示", "代码重复!" , 'info');
			} else {
				$.messager.alert("失败提示", "更新数据失败!返回码=" + retval, 'info');
			}
		} else {
			$HUI.dialog('#InfPosEdit').close();
			$.messager.popover({msg: '保存成功！',type:'success',timeout: 1000});
			obj.gridInfPosLoad();//刷新当前页
		}
	},
	
	//单击选中事件：选择感染诊断部位
	obj.gridInfPos_onSelect = function (){
		var rowData = obj.gridInfPos.getSelected();
		if (rowData["ID"] == obj.RecRowID) {
			$("#btnAdd").linkbutton("enable");
			$("#btnEdit").linkbutton("disable");
			$("#btnDelete").linkbutton("disable");
			obj.RecRowID="";
			obj.gridInfPos.clearSelections();
			obj.chkInfSub();
		}else{
			obj.RecRowID = rowData["ID"];
			$("#btnAdd").linkbutton("disable");
			$("#btnEdit").linkbutton("enable");
			$("#btnDelete").linkbutton("enable");
			obj.chkInfSub();
		}	
	},

	//双击编辑事件
	obj.gridInfPos_onDbselect = function(rd){
		obj.layer_rd=rd;
		obj.Layer(rd);
	},	
	
	//感染诊断（部位）信息编辑窗体-初始化
	obj.Layer = function(rd){
		if (rd){
			var txtBTCode = rd["Code"];
			var txtBTDesc = rd["Desc"];
			var txtGCode = rd["GCode"];
			var chkDiagFlag = rd["DiagFlag"];
			chkDiagFlag = (chkDiagFlag=="1"? true: false);
			var chkActive = rd["IsActive"];
			chkActive = (chkActive=="1"? true: false);
			$('#txtBTCode').val(txtBTCode);
			$('#txtBTDesc').val(txtBTDesc);
			$('#txtGCode').val(txtGCode);
			$('#chkDiagFlag').checkbox('setValue',chkDiagFlag);
			$('#chkActive').checkbox('setValue',chkActive);
			$("#txtBTCode,#txtBTDesc,#txtGCode").validatebox({required:true});
		}else {
			obj.RecRowID="";
			$('#txtBTCode').val("");
			$('#txtBTDesc').val("");
			$('#txtGCode').val("");
			$('#chkDiagFlag').checkbox('setValue',"");
			$('#chkActive').checkbox('setValue',"");
			$("#txtBTCode,#txtBTDesc,#txtGCode").validatebox({required:true});
		}
		$('#InfPosEdit').show();
		obj.InfPosEdit();
	},
	
	//窗体初始化
	obj.bodyPosGist =function() {
		$('#bodyPosGist').dialog({
			title: '诊断依据编辑',
			iconCls:"icon-w-paper",
			modal: true,
			isTopZindex:true
		})
	},
	obj.layergist =function() {
		$('#layergist').dialog({
			title: '诊断依据编辑',
			iconCls:"icon-w-paper",
			modal: true,
			isTopZindex:true
		});
	},
	
	//保存
	obj.btnSave_Gist_click = function(){
		var errinfo="";
		var rd = obj.layergist_rd;
		var rowDataID = (rd ? rd["ID"] : '');
	
		var ID = (rd ? rd["ID"] : '');
		var DiagCode = $('#txtCode').val();
		var DiagDesc = $('#txtDesc').val();
		var TypeDr = $('#cboDiagType').combobox('getValue');
		if (!TypeDr) {
			errinfo = errinfo + "诊断依据类型不允许为空!<br>";
		}
		if (!DiagCode) {
			errinfo = errinfo + "诊断依据代码不允许为空!<br>";
		}
		if (!DiagDesc) {
			errinfo = errinfo + "诊断依据内容不允许为空!<br>";
		}
		if (errinfo) {
			$.messager.alert("错误提示", errinfo, 'info');
			return;
		}	
		var inputStr = ID;
		inputStr = inputStr + "^" + obj.InfPosID;
		inputStr = inputStr + "^" + TypeDr;
		inputStr = inputStr + "^" + DiagCode;
		inputStr = inputStr + "^" + DiagDesc;	
		InputStr = inputStr + "^" + "";
		InputStr = inputStr + "^" + "";
		InputStr = inputStr + "^" + $.LOGON.USERID;
		var retval = $m({
			ClassName:"DHCHAI.BT.InfPosGist",
			MethodName:"Update",
			aInputStr:inputStr,
			aSeparete:"^"
		},false);
		if (parseInt(retval) <= 0) {
			if (parseInt(retval) == 0) {
				$.messager.alert("失败提示", "更新数据失败!返回码=" + retval, 'info');
			} else if (parseInt(retval) == -2) {
				$.messager.alert("失败提示", "不允许重复添加!" , 'info');
			} else {
				$.messager.alert("失败提示", "保存失败!返回码=" + retval, 'info');
			}
		} else {
			$HUI.dialog('#layergist').close();
			$.messager.popover({msg: '保存成功！',type:'success',timeout: 1000});
			obj.gridInfPosGist.reload() ;//刷新当前页
		}
	}	
	
	//单击选中事件：选择感染诊断依据
	obj.gridInfPosGist_onSelect = function (){
		var rowData = obj.gridInfPosGist.getSelected();
		if (rowData["ID"] == obj.RecRowID) {
			$("#btnGistAdd").linkbutton("enable");
			$("#btnGistEdit").linkbutton("disable");
			$("#btnGistDelete").linkbutton("disable");
			obj.RecRowID="";
			obj.gridInfPosGist.clearSelections();
		}else{
			obj.RecRowID = rowData["ID"];
			$("#btnGistAdd").linkbutton("disable");
			$("#btnGistEdit").linkbutton("enable");
			$("#btnGistDelete").linkbutton("enable");
		}	
	}
	
	//双击编辑事件
	obj.gridInfPosGist_onDbselect = function(rd){
		obj.layergist_rd=rd;
		obj.Layer_Gist(rd);
	}	

	//诊断依据编辑窗体-初始化
	obj.Layer_Gist = function(rd){
		if (rd){
			var cboDiagType = rd["TypeDr"];
			var txtCode = rd["Code"];
			var txtDesc = rd["Desc"];
			$('#cboDiagType').combobox('setValue',cboDiagType);
			$('#txtCode').val(txtCode);
			$('#txtDesc').val(txtDesc);
			$("#txtCode,#txtDesc").validatebox({required:true});
		}else {
			obj.RecRowID="";
			$('#txtCode').val("");
			$('#txtDesc').val("");
			$('#cboDiagType').combobox('setValue','');
			$("#txtCode,#txtDesc").validatebox({required:true});
		}
		$('#layergist').show();
		obj.layergist();
	}
	
	//打开诊断依据
	obj.openInfPos = function(id){
		obj.InfPosID=id;
	   	obj.gridInfPosGist.load({
			ClassName:"DHCHAI.BTS.InfPosGistSrv",
			QueryName:"QryGistByInfPos",
			aInfPosID:id
		});
	    $('#bodyPosGist').show(id);
	    obj.bodyPosGist();
	}
	obj.gridInfPosLoad = function(){
		originalData["gridInfPos"]="";
		$("#gridInfPos").datagrid("loading");	
		$cm ({
		    ClassName:"DHCHAI.BTS.InfPosSrv",
			QueryName:"QryInfPos",		
	    	page:1,
			rows:200
		},function(rs){
			$('#gridInfPos').datagrid({loadFilter:pagerFilter}).datagrid('loadData', rs);					
		});
    }
}