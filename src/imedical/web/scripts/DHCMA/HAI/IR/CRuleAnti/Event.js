//页面Event
function InitCRuleAntiWinEvent(obj){
	
	//检索框
	$('#btnsearch').searchbox({ 
		searcher:function(value,name){
			searchText($("#gridCRuleAnti"),value);
		}	
	});	
	//编辑窗体
	obj.SetDiaglog=function(){
		$('#layer').dialog({
			title: '抗菌用药信息编辑',
			iconCls:"icon-w-paper",
			modal: true,
			isTopZindex:false,
			buttons:[{
				text:'保存',
				handler:function(){
					obj.btnSave_click();
				}
			},{
				text:'关闭',
				handler:function(){
					$HUI.dialog('#layer').close();
				}
			}]
		});
	}
	//按钮初始化
    obj.LoadEvent = function(args){ 
   		obj.gridCRuleAntiLoad();
   		
		//添加
		$('#btnAdd').on('click', function(){
			obj.layer();
		});
		//编辑
		$('#btnEdit').on('click', function(){
			var rd=obj.gridCRuleAnti.getSelected()
			obj.layer(rd);	
		});
		//删除
		$('#btnDelete').on('click', function(){
			obj.btnDelete_click();
		}); 
   	}
   	//双击编辑事件
	obj.gridCRuleAnti_onDbselect = function(rd){
		obj.layer(rd);
	}
	//选择
	obj.gridCRuleAnti_onSelect = function (){
		var rowData = obj.gridCRuleAnti.getSelected();
		if (rowData["ID"] == obj.RecRowID) {
			obj.RecRowID="";
			$("#btnAdd").linkbutton("enable");
			$("#btnEdit").linkbutton("disable");
			$("#btnDelete").linkbutton("disable");
			
			obj.gridCRuleAnti.clearSelections();
		}
		else {
			obj.RecRowID = rowData["ID"];
			$("#btnAdd").linkbutton("disable");
			$("#btnEdit").linkbutton("enable");
			$("#btnDelete").linkbutton("enable");
		}
	}
	//保存分类
	obj.btnSave_click = function(){
		var errinfo = "";
		var Type 		= $('#cboType').combobox('getValue');
		var Location 	= $('#cboLocation').combobox('getValue');
		var AntiCat 	= $('#cboAntiCat').combobox('getValue');
		var AntiMast 	= $('#cboAntiMast').combobox('getValue');
		var IsActive 	= $("#chkIsActive").checkbox('getValue')? '1':'0';
		
		if (!Type) {
			errinfo = errinfo + "类型不允许为空!<br>";
		}	
		if (!Location) {
			errinfo = errinfo + "科室不允许为空!<br>";
		}
		if (!AntiCat) {
			errinfo = errinfo + "抗生素分类不允许为空!<br>";
		}
		if (!AntiMast) {
			errinfo = errinfo + "抗菌用药不允许为空!<br>";
		}
		if (errinfo) {
			$.messager.alert("错误提示", errinfo, 'info');
			return;
		}
		
		var InputStr = obj.RecRowID;
		InputStr += "^" + Type;
		InputStr += "^" + $.LOGON.HOSPGRPID;
		InputStr += "^" + $.LOGON.HOSPID;
		InputStr += "^" + Location;
		InputStr += "^" + AntiCat;
		InputStr += "^" + AntiMast;
		InputStr += "^" + "";
		InputStr += "^" + IsActive;
		InputStr += "^" + '';
		InputStr += "^" + '';
		InputStr += "^" + $.LOGON.USERID;
		var flg = $m({
			ClassName:"DHCHAI.IR.CRuleAnti",
			MethodName:"Update",
			InStr:InputStr,
			aSeparete:"^"
		},false);
		if (parseInt(flg) <= 0) {
			if(parseInt(flg) == -2){
				$.messager.alert("代码重复!" , 'info');
			}else{
				$.messager.alert("错误提示", "保存失败!Error=" + flg, 'info');
			}
		}else {
			$HUI.dialog('#layer').close();
			$.messager.popover({msg: '保存成功！',type:'success',timeout: 1000});
			obj.RecRowID = flg
			obj.gridCRuleAntiLoad(); //刷新当前页
		}
	}
	//删除分类 
	obj.btnDelete_click = function(){
		if (obj.RecRowID==""){
			$.messager.alert("提示", "选中数据记录,再点击删除!", 'info');
			return;
		}
		$.messager.confirm("删除", "是否删除选中数据记录?", function (r) {				
			if (r) {				
				var flg = $m({
					ClassName:"DHCHAI.IR.CRuleAnti",
					MethodName:"DeleteById",
					Id:obj.RecRowID
				},false);

				if (parseInt(flg) < 0) {
					if (parseInt(flg)=='-777') {
						$.messager.alert("错误提示","-777：当前无删除权限，请启用删除权限后再删除记录!",'info');
					}else {
						$.messager.alert("错误提示","删除失败!Error=" + flg, 'info');
					}
					return;
				} else {
					$.messager.popover({msg: '删除成功！',type:'success',timeout: 1000});
					obj.RecRowID = "";
					obj.gridCRuleAntiLoad();  //刷新当前页
				}
			} 
		});
	}
	//配置窗体-初始化
	obj.layer= function(rd){
		if(rd){
			obj.RecRowID 		= rd["ID"];
			var Type 			= rd["Type"];
			var LocID			= rd["LocID"];
			var LocDesc 		= rd["LocDesc"];
			
			var AntiCatID 		= rd["AntiCatID"];
			var AntiCatDesc 	= rd["AntiCatDesc"];
			
			var AntiMastID 		= rd["AntiMastID"];
			var AntiMastDesc 	= rd["AntiMastDesc"];
			var IsActive 		= rd["IsActive"];
			$('#cboType').combobox('setValue',Type);
			$('#cboLocation').combobox('setValue',LocID);
			$('#cboLocation').combobox('setText',LocDesc);
			$('#cboAntiCat').combobox('setValue',AntiCatID);
			$('#cboAntiCat').combobox('setText',AntiCatDesc);
			$('#cboAntiMast').combobox('setValue',AntiMastID);
			$('#cboAntiMast').combobox('setText',AntiMastDesc);
			
			$('#chkIsActive').checkbox('setValue',IsActive);
			
			
			
		}else{
			obj.RecRowID = "";
			$('#cboType').combobox('setValue','');
			$('#cboLocation').combobox('setValue','');
			$('#cboAntiCat').combobox('setValue','');
			$('#cboAntiMast').combobox('setValue','');
			$('#chkIsActive').checkbox('setValue',false);
		}
		$('#layer').show();
		obj.SetDiaglog();
		
	}
	
	obj.gridCRuleAntiLoad = function(){
		originalData["gridCRuleAnti"]="";
		$("#gridCRuleAnti").datagrid("loading");	
		$cm ({
		    ClassName:"DHCHAI.IRS.CRuleAntiSrv",
			QueryName:"QryCRuleAnti",		
	    	page:1,
			rows:999
		},function(rs){
			$('#gridCRuleAnti').datagrid({loadFilter:pagerFilter}).datagrid('loadData', rs);					
		});
    }
}
