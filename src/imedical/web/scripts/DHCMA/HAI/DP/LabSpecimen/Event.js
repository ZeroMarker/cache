//页面Event
function InitLabSpecimenWinEvent(obj){
	//按钮初始化
	obj.LoadEvent = function(args){ 
		$('#gridLabSpecimen').datagrid('loadData',{ 'total':'0',rows:[] });  //初始加载显示记录为0
		obj.gridLabSpecimenLoad();
		$('#btnAdd').on('click', function(){
			obj.InitDialog();
		});
		$('#btnEdit').on('click', function(){
			var rd=obj.gridLabSpecimen.getSelected();
			obj.InitDialog(rd);
		});
		$('#btnDelete').on('click', function(){
			obj.btnDelete_click();
		});
		$('#search').searchbox({ 
		searcher:function(value,name){
			searchText($("#gridLabSpecimen"),value);
			}	
		});	
	
     }
     //双击编辑事件
	obj.gridLabSpecimen_onDbselect = function(rd){
		obj.InitDialog(rd);
	}
	//选择
	obj.gridLabSpecimen_onSelect = function (){
		var rowData = obj.gridLabSpecimen.getSelected();
		if (rowData["ID"] == obj.RecRowID) {
			obj.RecRowID="";
			$("#btnAdd").linkbutton("enable");
			$("#btnEdit").linkbutton("disable");
			$("#btnDelete").linkbutton("disable");
			obj.gridLabSpecimen.clearSelections();
		} else {
			obj.RecRowID = rowData["ID"];
			$("#btnAdd").linkbutton("disable");
			$("#btnEdit").linkbutton("enable");
			$("#btnDelete").linkbutton("enable");
		}
	}
	//保存
	obj.btnSave_click = function(){
		var errinfo = "";
		var SpecCode = $('#txtSpecCode').val();
		var SpecDesc = $('#txtSpecDesc').val();
		var WCode = $('#txtWCode').val();
		var IsActive = $('#chkActive').checkbox('getValue');
		var Property= $('#cboProperty').combobox('getValue');
		if (!SpecCode) {
			errinfo = errinfo + "代码不允许为空!<br>";
		}
		if (!SpecDesc) {
			errinfo = errinfo + "名称不允许为空!<br>";
		}
		if (errinfo) {
			$.messager.alert("错误提示", errinfo, 'info');
			return;
		}
		IsActive = (IsActive==true? 1: 0);
		var inputStr = obj.RecRowID;
		inputStr = inputStr + '^' + SpecCode;
		inputStr = inputStr + '^' + SpecDesc;
		inputStr = inputStr + '^' + WCode;
		inputStr = inputStr + '^' + IsActive;
		inputStr = inputStr + '^' + Property;
		var flg = $m({
			ClassName:"DHCHAI.DP.LabSpecimen",
			MethodName:"Update",
			InStr:inputStr,
			aSeparete:"^"
		},false);
		if (parseInt(flg) <= 0) {
			if (parseInt(flg) == '-100') {
				$.messager.alert("错误提示", "标本代码、名称重复!" , 'info');
				return;
			}else{
				$.messager.alert("错误提示", "保存失败" , 'info');
				return;
				}
		}else {
			$HUI.dialog('#winEdit').close();
			$.messager.popover({msg: '保存成功！',type:'success',timeout: 1000});
			obj.RecRowID = flg;
			obj.gridLabSpecimenLoad();//刷新当前页
		}
	}
	//删除
	obj.btnDelete_click = function(){
		if (obj.RecRowID==""){
			$.messager.alert("提示", "选中数据记录,再点击删除!", 'info');
			return;
		}
		
		$.messager.confirm("删除", "是否删除选中数据记录?", function (r) {
			if (r) {				
				var flg = $m({
					ClassName:"DHCHAI.DP.LabSpecimen",
					MethodName:"DeleteById",
					Id:obj.RecRowID
				},false);
				if (parseInt(flg) < 0) {
					if (parseInt(flg)=='-777') {
						$.messager.alert('错误提示','当前无删除权限，请启用删除权限后再删除记录!','info');
						return;
					}else {
						$.messager.alert('删除失败!','info');
						return;
					}				
				} else {
					$.messager.popover({msg: '删除成功！',type:'success',timeout: 1000});
					obj.RecRowID = "";
					obj.gridLabSpecimenLoad();//刷新当前页
				}
			} 
		});
	}
	//窗体
	obj.SetDiaglog=function (){
		$('#winEdit').dialog({
			title: '标本编辑',
			iconCls:'icon-w-paper',
			modal: true,
			isTopZindex:false,//true,
			buttons:[{
				text:'保存',
				handler:function(){
					obj.btnSave_click();
				}
			},{
				text:'关闭',
				handler:function(){
					$HUI.dialog('#winEdit').close();
				}
			}]
		});
	}
	//配置窗体-初始化
	obj.InitDialog= function(rd){
		if(rd){
			obj.RecRowID=rd["ID"];
			var SpecCode = rd["SpecCode"];
			var SpecDesc = rd["SpecDesc"];
			var WCode = rd["WCode"];
			var PropertyDesc = rd["PropertyDesc"];
			var PropertyID = rd["PropertyID"]
			var IsActive = rd["IsActDesc"];
			IsActive = (IsActive=='是'? true: false);
			$('#txtSpecCode').val(SpecCode);
			$('#txtSpecDesc').val(SpecDesc);
			$('#cboProperty').combobox('setValue',PropertyID)
			$('#txtWCode').val(WCode);
			$('#chkActive').checkbox('setValue',IsActive);
			
		}else{
			obj.RecRowID = "";
			$('#txtSpecCode').val('');
			$('#txtSpecDesc').val('');
			$('#cboProperty').combobox('setValue','');
			$('#txtWCode').val('');
			$('#chkActive').checkbox('setValue',false);
		}
		$('#winEdit').show();
		obj.SetDiaglog();
	}
	obj.gridLabSpecimenLoad = function(){
		//$("#gridLabAntiCat").datagrid("loading");	
		originalData["gridLabSpecimen"]="";
		$cm ({
		    ClassName:"DHCHAI.DPS.LabSpecSrv",
			QueryName:"QryLabSpecimen",	
	    	page:1,
			rows:9999
		},function(rs){
			$('#gridLabSpecimen').datagrid({loadFilter:pagerFilter}).datagrid('loadData', rs);					
		});
    }
}