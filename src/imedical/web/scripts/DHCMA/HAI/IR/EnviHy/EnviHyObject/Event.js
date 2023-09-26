 //页面Event
function InitEnviHyObjectWinEvent(obj){
	//CheckSpecificKey();
	//弹窗初始化
	$('#winProEdit').dialog({
		title: '监测对象编辑',
		iconCls:'icon-w-paper',
		headerCls:'panel-header-gray',
		modal: true,
		isTopZindex:true,
	});
	
    obj.LoadEvent = function(args){
	    //保存
	    $('#btnSave').on('click', function(){
		    obj.btnSave_click();
		});
		//关闭
		$('#btnClose').on('click', function(){
			$HUI.dialog('#winProEdit').close();
		});
		//添加
		$('#btnAdd').on('click', function(){
			obj.layer("");
		});
		//编辑
		$('#btnEdit').on('click', function(){
			var rowData=obj.gridEvObject.getSelected();
			obj.layer(rowData);
		});
		//删除
		$('#btnDelete').on('click', function(){
			obj.btnDelete_click();
		});
    }
    
    //选择监测对象
    obj.gridEvObject_onSelect = function (){
	    var rowData = obj.gridEvObject.getSelected();
	    if($("#btnEdit").hasClass("l-btn-disabled")) obj.RecRowID="";
	    
	    if (rowData["ID"] == obj.RecRowID){
		    $("#btnAdd").linkbutton("enable");
		    $("#btnEdit").linkbutton("disable");
		    $("#btnDelete").linkbutton("disable");
		    obj.RecRowID="";
		    obj.gridEvObject.clearSelections();
		}else {
			obj.RecRowID = rowData["ID"];
			$("#btnAdd").linkbutton("disable");
			$("#btnEdit").linkbutton("enable");
			$("#btnDelete").linkbutton("enable");
		}
	}
	
	//双击编辑事件
	obj.gridEvObject_onDbselect = function(rowData){
		obj.layer(rowData);
	}
	
	//保存
	obj.btnSave_click = function(){
		var errinfo = "";
		var ObjectDesc = $('#ObjectDesc').val();
		var SpecimenType = $('#cboSpecimenType').combobox('getText');
		var IsActive = $("#chkActive").checkbox('getValue')? '1':'0';
		var HospID=$('#cboHospital').combobox('getValue');
		if (!ObjectDesc) {
			errinfo = errinfo + "对象名称为空!<br>";
		}
		if (!SpecimenType) {
			errinfo = errinfo + "标本类型为空!<br>";
		}
		if (errinfo) {
			$.messager.alert("错误提示", errinfo, 'info');
			return;
		}
		var inputStr = obj.RecRowID;
		inputStr = inputStr + "^" + ObjectDesc;
		inputStr = inputStr + "^" + SpecimenType;
		inputStr = inputStr + "^" + IsActive;
		inputStr = inputStr + "^" + HospID;
		inputStr = inputStr + "^" + $.LOGON.USERID;
		
		var flg = $m({
			ClassName:"DHCHAI.IR.EnviHyObject",
			MethodName:"Update",
			InStr:inputStr,
			aSeparete:"^"
		},false);
		if (parseInt(flg) <= 0){
			if (parseInt(flg) == 0){
				$.messager.alert("错误提示", "参数错误!" , 'info');
			}else if(parseInt(flg) == -2){
				$.messager.alert("错误提示", "数据重复!" , 'info');
			}else {
				$.messager.alert("错误提示", "更新数据错误!Error=" + flg, 'info');
			}
		}else{
			$HUI.dialog('#winProEdit').close();
			$.messager.popover({msg: '保存成功！',type:'success',timeout: 1000});
			obj.gridEvObject.reload() ;//刷新当前页
		}
	}
	
	//删除
	obj.btnDelete_click = function(){
		var rowDataID = obj.gridEvObject.getSelected()["ID"];
		if (rowDataID==""){
			$.messager.alert("提示", "选中数据记录,再点击删除!", 'info');
			return;
		}
		$.messager.confirm("删除", "是否删除选中数据记录?", function (r){
			if(r){
				var flg = $m({
					ClassName:"DHCHAI.IR.EnviHyObject",
					MethodName:"DeleteById",
					Id:rowDataID
				},false);
				if(parseInt(flg) < 0){
					$.messager.alert("错误提示","删除数据错误!Error=" + flg, 'info');
				}else{
					$.messager.popover({msg: '删除成功！',type:'success',timeout: 1000});
					obj.RecRowID = ""
					obj.gridEvObject.reload() ;//刷新当前页
				}
			}
		});
	}
	
	//配置窗体-初始化
	obj.layer = function(rowData){
		if(rowData){
			obj.RecRowID=rowData["ID"];
			var ObjectDesc = rowData["ObjectDesc"];
			var SpecimenTypeID = rowData["SpecimenTypeID"];
			var SpecimenTypeDesc = rowData["SpecimenTypeDesc"];
			var IsActDesc = rowData["IsActDesc"];
			IsActDesc = (IsActDesc=="是"? true: false)
			var HospID = rowData["HospID"];
			$('#ObjectDesc').val(ObjectDesc);
			$('#cboSpecimenType').combobox('setValue',SpecimenTypeID);
			$('#cboSpecimenType').combobox('setText',SpecimenTypeDesc);
			$('#chkActive').checkbox('setValue',IsActDesc);
			$('#cboHospital').combobox('setValue',HospID);
		}else{
			obj.RecRowID="";
			$('#ObjectDesc').val('');
			$('#cboSpecimenType').combobox('setValue','');
			$('#chkActive').checkbox('setValue',false);
			$('#cboHospital').combobox('setValue','');
		}
		$HUI.dialog('#winProEdit').open();
	}
}