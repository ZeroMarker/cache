//页面Event
function InitCRuleAntiWinEvent(obj){
	
	//检索框
	$('#btnsearch').searchbox({ 
		searcher:function(value,name){
			searchText($("#gridCRuleLocArgs"),value);
		}	
	});	
	//编辑窗体
	obj.SetDiaglog=function(){
		$('#layer').dialog({
			title: '科室参数维护',
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
   		obj.gridCRuleLocArgsLoad();
   		
		//添加
		$('#btnAdd').on('click', function(){
			obj.layer();
		});
		//编辑
		$('#btnEdit').on('click', function(){
			var rd=obj.gridCRuleLocArgs.getSelected()
			obj.layer(rd);	
		});
		//删除
		$('#btnDelete').on('click', function(){
			obj.btnDelete_click();
		}); 
   	}
   	//双击编辑事件
	obj.gridCRuleLocArgs_onDbselect = function(rd){
		obj.layer(rd);
	}
	//选择
	obj.gridCRuleLocArgs_onSelect = function (){
		var rowData = obj.gridCRuleLocArgs.getSelected();
		if (rowData["ID"] == obj.RecRowID) {
			obj.RecRowID="";
			$("#btnAdd").linkbutton("enable");
			$("#btnEdit").linkbutton("disable");
			$("#btnDelete").linkbutton("disable");
			
			obj.gridCRuleLocArgs.clearSelections();
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
		var Hospital 	= $('#cboHospital').combobox('getValue');
		var Location 	= $('#cboLocation').combobox('getValue');
		var FeverMax	= $.trim($('#txtFeverMax').val());
		var FeverMin	= $.trim($('#txtFeverMin').val());
		var DiarrMin	= $.trim($('#txtDiarrMin').val());
		var DiarrMin2	= $.trim($('#txtDiarrMin2').val());
		
		if (!Type) {
			errinfo = errinfo + "类型不允许为空!<br>";
		}	
		if (!Hospital) {
			errinfo = errinfo + "院区不允许为空!<br>";
		}
		if (!Location) {
			errinfo = errinfo + "科室不允许为空!<br>";
		}
		if (errinfo) {
			$.messager.alert("错误提示", errinfo, 'info');
			return;
		}
		var InputStr = obj.RecRowID;
		InputStr += "^" + Type;
		InputStr += "^" + Location;
		InputStr += "^" + "";
		InputStr += "^" + "";
		InputStr += "^" + $.LOGON.USERID; 
		InputStr += "^" + FeverMax;
		InputStr += "^" + FeverMin;
		InputStr += "^" + DiarrMin;
		InputStr += "^" + DiarrMin2;
		
		console.log(InputStr);
		var flg = $m({
			ClassName:"DHCHAI.IR.CRuleLocArgs",
			MethodName:"Update",
			InStr:InputStr,
			aSeparete:"^"
		},false);
		if (parseInt(flg) <= 0) {
			if(parseInt(flg) == -100){
				$.messager.alert("错误提示" , '数据重复！');
			}else{
				$.messager.alert("错误提示", "保存失败!Error=" + flg, 'info');
			}
		}else {
			$HUI.dialog('#layer').close();
			$.messager.popover({msg: '保存成功！',type:'success',timeout: 1000});
			obj.RecRowID = flg
			obj.gridCRuleLocArgsLoad(); //刷新当前页
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
					ClassName:"DHCHAI.IR.CRuleLocArgs",
					MethodName:"DeleteById",
					aId:obj.RecRowID
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
					obj.gridCRuleLocArgsLoad();  //刷新当前页
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
			var HospID			= rd["HospID"];
			
			var FeverMax 		= rd["FeverMax"];
			var FeverMin 		= rd["FeverMin"];
			var DiarrMin 		= rd["DiarrMin"];
			var DiarrMin2 		= rd["DiarrMin2"];
			
			$('#cboType').combobox('setValue',Type);
			$('#cboHospital').combobox('setValue',HospID);
			$('#cboLocation').combobox('setValue',LocID);
			$('#cboLocation').combobox('setText',LocDesc);
			$('#txtFeverMax').val(FeverMax);
			$('#txtFeverMin').val(FeverMin);
			$('#txtDiarrMin').val(DiarrMin);
			$('#txtDiarrMin2').val(DiarrMin2);
			
		}else{
			obj.RecRowID = "";
			$('#cboType').combobox('setValue','');
			$('#cboHospital').combobox('setValue','');
			$('#cboLocation').combobox('setValue','');
			$('#txtFeverMax').val('');
			$('#txtFeverMin').val('');
			$('#txtDiarrMin').val('');
			$('#txtDiarrMin2').val('');
		}
		$('#layer').show();
		obj.SetDiaglog();
		
	}
	
	obj.gridCRuleLocArgsLoad = function(){
		originalData["gridCRuleLocArgs"]="";
		$("#gridCRuleLocArgs").datagrid("loading");	
		$cm ({
		    ClassName:"DHCHAI.IRS.CRuleLocArgsSrv",
			QueryName:"QryCRuleLocArgs",		
	    	page:1,
			rows:999
		},function(rs){
			$('#gridCRuleLocArgs').datagrid({loadFilter:pagerFilter}).datagrid('loadData', rs);					
		});
    }
}
