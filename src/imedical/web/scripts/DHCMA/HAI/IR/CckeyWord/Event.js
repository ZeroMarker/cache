//页面Event
function InitKeyWordWinEvent(obj){
	//检索框
	$('#btnsearch').searchbox({ 
		searcher:function(value,name){
			searchText($("#gridKeyWord"),value);
		}	
	});	
//编辑窗体
	obj.SetDiaglog=function(){
		$('#layer').dialog({
			title: '关键词定义编辑',
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
   		obj.gridKeyWordLoad();
		//添加
		$('#btnAdd').on('click', function(){
			obj.layer();
		});
		//编辑
		$('#btnEdit').on('click', function(){
			var rd=obj.gridKeyWord.getSelected()
			obj.layer(rd);	
		});
		//删除
		$('#btnDelete').on('click', function(){
			obj.btnDelete_click();
		}); 
   	}
   	//双击编辑事件
	obj.gridKeyWord_onDbselect = function(rd){
		obj.layer(rd);
	}
	//选择
	obj.gridKeyWord_onSelect = function (){
		var rowData = obj.gridKeyWord.getSelected();
		if($("#btnEdit").hasClass("l-btn-disabled")) obj.RecRowID="";
		if (rowData["ID"] == obj.RecRowID) {
			obj.RecRowID="";
			$("#btnAdd").linkbutton("enable");
			$("#btnEdit").linkbutton("disable");
			$("#btnDelete").linkbutton("disable");
			
			obj.gridKeyWord.clearSelections();
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
		var Desc = $('#txtDesc').val();
		var Note = $('#txtNote').val();
		var Desc = Desc.trim();
		var Note = Note.trim();
		if (!Note) {
			errinfo = errinfo + "关键词说明不允许为空!<br>";
		}
		if (!Desc) {
			errinfo = errinfo + "关键词名称不允许为空!<br>";
		}	
		if (errinfo) {
			$.messager.alert("错误提示", errinfo, 'info');
			return;
		}
		
		var InputStr = obj.RecRowID;
		InputStr += "^" + Desc;
		InputStr += "^" + Note;
		var flg = $m({
			ClassName:"DHCHAI.IR.CCKeyWord",
			MethodName:"Update",
			aInputStr:InputStr,
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
			obj.gridKeyWordLoad(); //刷新当前页
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
					ClassName:"DHCHAI.IR.CCKeyWord",
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
					obj.gridKeyWordLoad();  //刷新当前页
				}
			} 
		});
	}
	//配置窗体-初始化
	obj.layer= function(rd){
		if(rd){
			obj.RecRowID = rd["ID"];
			var Desc = rd["Desc"];
			var Note = rd["Note"];
			
			$('#txtDesc').val(Desc);
			$('#txtNote').val(Note);
		}else{
			obj.RecRowID = "";
			$('#txtDesc').val('');
			$('#txtNote').val('');
			
		}
		$('#layer').show();
		obj.SetDiaglog();
		
	}
	obj.gridKeyWordLoad = function(){
		originalData["gridKeyWord"]="";
		$("#gridKeyWord").datagrid("loading");	
		$cm ({
		    ClassName:"DHCHAI.IRS.CCKeyWordSrv",
			QueryName:"QryKeyWordSrv",		
	    	page:1,
			rows:200
		},function(rs){
			$('#gridKeyWord').datagrid({loadFilter:pagerFilter}).datagrid('loadData', rs);					
		});
    }
}