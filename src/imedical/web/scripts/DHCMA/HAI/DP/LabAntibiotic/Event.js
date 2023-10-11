//页面Event
function InitLabAntibioticWinEvent(obj){
	//按钮初始化
	obj.LoadEvent = function(args){ 
		$('#gridLabAntibiotic').datagrid('loadData',{ 'total':'0',rows:[] });  //初始加载显示记录为0
		obj.gridLabAntibioticLoad();
		$('#btnAdd').on('click', function(){
			obj.InitDialog();
		});
		$('#btnEdit').on('click', function(){
			var rd=obj.gridLabAntibiotic.getSelected();
			obj.InitDialog(rd);
		});
		$('#btnDelete').on('click', function(){
			obj.btnDelete_click();
		});
		$('#search').searchbox({ 
			searcher:function(value,name){
				searchText($("#gridLabAntibiotic"),value);
			}	
		});	
     }
     //双击编辑事件
	obj.gridLabAntibiotic_onDbselect = function(rd){
		obj.InitDialog(rd);
	}
	//选择
	obj.gridLabAntibiotic_onSelect = function (){
		var rowData = obj.gridLabAntibiotic.getSelected();
		if (rowData["ID"] == obj.RecRowID) {
			obj.RecRowID="";
			$("#btnAdd").linkbutton("enable");
			$("#btnEdit").linkbutton("disable");
			$("#btnDelete").linkbutton("disable");
			obj.gridLabAntibiotic.clearSelections();
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
		var AntCode = $('#txtAntCode').val();
		var AntDesc = $('#txtAntDesc').val();
		var AntCat=$('#cboAntCat').combobox('getValue');
		var WCode = $('#txtWCode').val();
		var IsActive = $('#chkActive').checkbox('getValue');
		if (!AntCode) {
			errinfo = errinfo + "代码不允许为空!<br>";
		}
		if (!AntDesc) {
			errinfo = errinfo + "名称不允许为空!<br>";
		}
		if (!AntCat) {
			errinfo = errinfo + "分类不允许为空!<br>";
		}
		if (errinfo) {
			$.messager.alert("错误提示", errinfo, 'info');
			return;
		}
		IsActive = (IsActive==true? 1: 0);
		var inputStr = obj.RecRowID;
		inputStr = inputStr + '^' + AntCode;
		inputStr = inputStr + '^' + AntDesc;
		inputStr = inputStr + '^' + AntCat;
		inputStr = inputStr + '^' + WCode;
		inputStr = inputStr + '^' + IsActive;
		var flg = $m({
			ClassName:"DHCHAI.DP.LabAntibiotic",
			MethodName:"Update",
			InStr:inputStr,
			aSeparete:"^"
		},false);
		if (parseInt(flg) <= 0) {
			if (parseInt(flg) == '-100') {
				$.messager.alert("错误提示", "抗生素代码、名称重复!" , 'info');
				return;
			}else{
				$.messager.alert("错误提示", "保存失败" , 'info');
				return;
				}
		}else {
			$HUI.dialog('#winEdit').close();
			$.messager.popover({msg: '保存成功！',type:'success',timeout: 1000});
			obj.RecRowID = flg;
			obj.gridLabAntibioticLoad();//刷新当前页
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
					ClassName:"DHCHAI.DP.LabAntibiotic",
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
					obj.gridLabAntibioticLoad();//刷新当前页
				}
			} 
		});
	}
	//窗体
	obj.SetWinEdit=function (){
		$('#winEdit').dialog({
			title: '抗生素编辑',
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
			var AntCode = rd["AntCode"];
			var AntDesc = rd["AntDesc"];
			var CatDesc = rd["CatDesc"];
			var CatID = rd["CatID"];
			var WCode = rd["WCode"];
			var IsActive = rd["IsActDesc"];
			IsActive = (IsActive=='是'? true: false);
			$('#txtAntCode').val(AntCode);
			$('#txtAntDesc').val(AntDesc);
			$('#cboAntCat').combobox('setValue',CatID)
			$('#txtWCode').val(WCode);
			$('#chkActive').checkbox('setValue',IsActive);
			
		}else{
			obj.RecRowID = "";
			$('#txtAntCode').val('');
			$('#txtAntDesc').val('');
			$('#cboAntCat').combobox('setValue','');
			$('#txtWCode').val('');
			$('#chkActive').checkbox('setValue',false);
		}
		$('#winEdit').show();
		obj.SetWinEdit();
	}
	obj.gridLabAntibioticLoad = function(){
		//$("#gridLabAntibiotic").datagrid("loading");	
		originalData["gridLabAntibiotic"]="";
		$cm ({
		    ClassName:"DHCHAI.DPS.LabAntiSrv",
			QueryName:"QryLabAntibiotic",		
	    	page:1,
			rows:9999
		},function(rs){
			$('#gridLabAntibiotic').datagrid({loadFilter:pagerFilter}).datagrid('loadData', rs);					
		});
    }
}
	
