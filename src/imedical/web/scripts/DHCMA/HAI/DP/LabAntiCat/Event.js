//页面Event
function InitLabAntiCatWinEvent(obj){
	obj.LoadEvent = function(args){
		$('#gridLabAntiCat').datagrid('loadData',{ 'total':'0',rows:[] });  //初始加载显示记录为0
		obj.gridLabAntiCatLoad();
		//增加
		$('#btnAdd').on('click', function(){
			obj.InitDialog();
		});
		//修改
		$('#btnEdit').on('click', function(){
			var rd=obj.gridLabAntiCat.getSelected()
			obj.InitDialog(rd);
		});
		//删除
		$('#btnDelete').on('click', function(){
			obj.btnDelete_click();
		});
		//搜索
		$('#search').searchbox({ 
		searcher:function(value,name){
			searchText($("#gridLabAntiCat"),value);
			}	
		});
     }
     //双击编辑事件
	obj.gridLabAntiCat_onDbselect = function(rd){
		obj.InitDialog(rd);
	}
	//选择
	obj.gridLabAntiCat_onSelect = function (){
		var rowData = obj.gridLabAntiCat.getSelected();
		if(!rowData) obj.RecRowID="";
		if (rowData["ID"] == obj.RecRowID) {
			obj.RecRowID="";
			$("#btnAdd").linkbutton("enable");
			$("#btnEdit").linkbutton("disable");
			$("#btnDelete").linkbutton("disable");
			obj.gridLabAntiCat.clearSelections();
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
		var ACCode = $('#txtACCode').val();
		var ACDesc = $('#txtACDesc').val();
		if (!ACCode) {
			errinfo = errinfo + "抗生素分类代码不允许为空!<br>";
		}
		if (!ACDesc) {
			errinfo = errinfo + "抗生素分类名称不允许为空!<br>";
		}
		if (errinfo) {
			$.messager.alert("错误提示", errinfo, 'info');
			return;
		}
		var inputStr = obj.RecRowID;
		inputStr = inputStr + '^' + ACCode;
		inputStr = inputStr + '^' + ACDesc;
		var flg = $m({
			ClassName:"DHCHAI.DP.LabAntiCat",
			MethodName:"Update",
			InStr:inputStr,
			aSeparete:'^'
		},false);
		if (parseInt(flg) <= 0) {
			if (parseInt(flg) == '-100') {
				$.messager.alert("错误提示", "抗生素分类代码重复" , 'info');
				return;
			}
		}else {
			$HUI.dialog('#winEdit').close();
			$.messager.popover({msg: '保存成功！',type:'success',timeout: 1000});
			obj.RecRowID = flg;
			originalData["gridLabAntiCat"] =""
			obj.gridLabAntiCatLoad() ;//刷新当前页
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
					ClassName:"DHCHAI.DP.LabAntiCat",
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
					originalData["gridLabAntiCat"] =""
					obj.gridLabAntiCatLoad() ;//刷新当前页
				}
			} 
		});
	}
	//窗体
	obj.SetWinEdit=function (){
		$('#winEdit').dialog({
			title: '抗生素分类编辑',
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
				$HUI.dialog('#winEdit').close();
				}
			}]
		});
	}
	//配置窗体-初始化
	obj.InitDialog= function(rd){
		if(rd){
			obj.RecRowID=rd["ID"];
			var ACCode = rd["ACCode"];
			var ACDesc = rd["ACDesc"];
			
			$('#txtACCode').val(ACCode);
			$('#txtACDesc').val(ACDesc);
			
		}else{
			obj.RecRowID = "";
			$('#txtACCode').val('');
			$('#txtACDesc').val('');
		}
		$('#winEdit').show();
		obj.SetWinEdit();
	}
	
	obj.gridLabAntiCatLoad = function(){
		//$("#gridLabAntiCat").datagrid("loading");	
		$cm ({
		    ClassName:"DHCHAI.DPS.LabAntiSrv",
			QueryName:"QryLabAntiCat",		
	    	page:1,
			rows:9999
		},function(rs){
			$('#gridLabAntiCat').datagrid({loadFilter:pagerFilter}).datagrid('loadData', rs);					
		});
    }

}
