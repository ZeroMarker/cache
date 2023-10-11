//页面Event
function InitMROBSItemCatWinEvent(obj){
	
	//按钮初始化
	obj.InitDialog=function(){
		$('#layer').dialog({
			title: '护理分类维护',
			iconCls:"icon-w-paper",
			modal: true,
			isTopZindex:true,
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
	$('#btnsearch').searchbox({ 
		searcher:function(value,name){
			searchText($("#gridMROBSItemCat"),value);
		}	
	});
	obj.LoadEvent = function(args){ 
		//保存
		$('#btnSave').on('click', function(){
	     	obj.btnSave_click();
     	});
		//关闭
		$('#btnClose').on('click', function(){
	     	$HUI.dialog('#layer').close();
     	});
		//添加
		$('#btnAdd').on('click', function(){
			obj.layer();
		});
		//编辑
		$('#btnEdit').on('click', function(){
			var rd=obj.gridMROBSItemCat.getSelected()
			obj.layer(rd);	
		});
		//删除
		$('#btnDelete').on('click', function(){
			obj.btnDelete_click();
		}); 
     }
     //双击编辑事件
	obj.gridMROBSItemCat_onDbselect = function(rd){
		obj.layer(rd);
	}
	//选择
	obj.gridMROBSItemCat_onSelect = function (){
		var rowData = obj.gridMROBSItemCat.getSelected();
		if($("#btnEdit").hasClass("l-btn-disabled")) obj.RecRowID="";
		if (rowData["ID"] == obj.RecRowID) {
			obj.RecRowID="";
			$("#btnAdd").linkbutton("enable");
			$("#btnEdit").linkbutton("disable");
			$("#btnDelete").linkbutton("disable");
			
			obj.gridMROBSItemCat.clearSelections();
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
		var Code = $('#txtBTCode').val();
		var Desc = $('#txtBTDesc').val();
		Code=$.trim(Code)
		Desc=$.trim(Desc)
		
		if (!Code) {
			errinfo = errinfo + "代码不允许为空!<br>";
		}
		if (!Desc) {
			errinfo = errinfo + "名称不允许为空!<br>";
		}	
		if (errinfo) {
			$.messager.alert("错误提示", errinfo, 'info');
			return;
		}
		
		var inputStr = obj.RecRowID;
		inputStr = inputStr + CHR_1 + Code;
		inputStr = inputStr + CHR_1 + Desc;	
		var flg = $m({
			ClassName:"DHCHAI.DP.MROBSItemCat",
			MethodName:"Update",
			InStr:inputStr,
			aSeparete:CHR_1
		},false);
		if (parseInt(flg) <= 0) {
			if (parseInt(flg) == 0) {
				$.messager.alert("错误提示", "参数错误!" , 'info');
				//注意code 与产品的匹配
			} else if(parseInt(flg) == -100){
				$.messager.alert("错误提示" , '护理分类代码重复!');
			}else{
				$.messager.alert("错误提示", "保存失败!Error=" + flg, 'info');
			}
		}else {
			$HUI.dialog('#layer').close();
			$.messager.popover({msg: '保存成功！',type:'success',timeout: 1000});
			obj.RecRowID = flg
			obj.gridMROBSItemCat.reload() ;//刷新当前页
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
					ClassName:"DHCHAI.DP.MROBSItemCat",
					MethodName:"DeleteById",
					Id:obj.RecRowID
				},false);

				if (parseInt(flg) < 0) {
					if (parseInt(flg)=='-777') {
						$.messager.alert("错误提示","-777：当前无删除权限，请启用删除权限后再删除记录!",'info');
					}else {
						$.messager.alert("错误提示","删除数据错误!Error=" + flg, 'info');
					}
					return;
				} else {
					$.messager.popover({msg: '删除成功！',type:'success',timeout: 1000});
					obj.RecRowID = "";
					obj.gridMROBSItemCat.reload() ;//刷新当前页
				}
			} 
		});
	}
	//配置窗体-初始化
	obj.layer= function(rd){
		if(rd){
			obj.RecRowID = rd["ID"];
			var Code = rd["BTCode"];
			var Desc = rd["BTDesc"];
			
			$('#txtBTCode').val(Code);
			$('#txtBTDesc').val(Desc);
		}else{
			obj.RecRowID = "";
			$('#txtBTCode').val('');
			$('#txtBTDesc').val('');
			
		}
		$('#layer').show();
		obj.InitDialog()
		
	}
}