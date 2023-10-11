//PDCA模板
function InitModWinEvent(obj) {
	//初始化信息
    obj.LoadEvent = function (args) {
		//添加
		$('#btnAdd').on('click', function () {
		    obj.LayerEdit();        //打开编辑框
		    obj.layer("");          //初始化编辑框
		});
		//编辑
		$('#btnEdit').on('click', function(){
		    var rowData = obj.gridMod.getSelected();
		    obj.LayerEdit();        //打开编辑框
		    obj.layer(rowData);     //初始化编辑框
		});
		//删除
		$('#btnDelete').on('click', function(){
			obj.btnDelete_click();
		});
        //保存
		$('#btnSave').on('click', function () {
		    obj.btnSave_click();
		});
        //关闭
		$('#btnClose').on('click', function () {
		    $HUI.dialog('#LayerEdit').close();
		});
    }
    //选中PDCA模板
    obj.gridMod_onSelect = function () {
        var rowData = obj.gridMod.getSelected();
        if ($("#btnEdit").hasClass("l-btn-disabled")) obj.RecRowID = "";    //点击置空
        if (rowData["ModID"] == obj.RecRowID) {    //取消选中
            $("#btnAdd").linkbutton("enable");
            $("#btnEdit").linkbutton("disable");
            $("#btnDelete").linkbutton("disable");
            obj.RecRowID = "";
            obj.gridMod.clearSelections();
        } else {    //选中行
            obj.RecRowID = rowData["ModID"];
            $("#btnAdd").linkbutton("disable");
            $("#btnEdit").linkbutton("enable");
            $("#btnDelete").linkbutton("enable");
        }
    }
	//保存PDCA模板
	obj.btnSave_click = function(){
	    var ModCode=$('#txtCode').val();
	    var ModName = $('#txtDesc').val();
	    var ModResume = $('#txtResume').val();
	    var IsActive = $('#chkActive').checkbox('getValue') ? '1' : '0';
		var ModCode	= ModCode.trim();
	    var ModName = ModName.trim();
	    if (ModCode == '') {
	        $.messager.alert("错误提示", "代码不允许为空!", 'info');
	        return;
	    }
	    if (ModName == '') {
	        $.messager.alert("错误提示", "模板名称不允许为空!", 'info');
	        return;
	    }
	    var InputStr = obj.RecRowID;
	    InputStr += "^" + ModCode;
	    InputStr += "^" + ModName;
	    InputStr += "^" + IsActive;
	    InputStr += "^" + ModResume;
		
		var flg = $m({
		    ClassName: "DHCHAI.IR.PDCAMod",
		    MethodName: "Update",
		    aInputStr: InputStr,
			aSeparete:"^"
		},false);
		if (parseInt(flg) <= 0){
			if(parseInt(flg) == -2){
				$.messager.alert("错误提示", "数据重复!" , 'info');
			}else {
				$.messager.alert("错误提示", "更新数据错误!Error=" + flg, 'info');
			}
		} else {
		    $HUI.dialog('#LayerEdit').close();
			$.messager.popover({msg: '保存成功！',type:'success',timeout: 1000});
			obj.gridMod.reload();   //刷新当前页
		}
	}
	//删除PDCA模板
	obj.btnDelete_click = function(){
	    var rowDataID = obj.gridMod.getSelected()["ModID"];
		if (rowDataID==""){
			$.messager.alert("提示", "选中数据记录,再点击删除!", 'info');
			return;
		}
		$.messager.confirm("删除", "是否删除选中数据记录?", function (r){
			if(r){
				var flg = $m({
				    ClassName: "DHCHAI.IR.PDCAMod",
				    MethodName: "DeleteById",
				    aID: rowDataID
				}, false);
				if ((parseInt(flg)<0)) {
				    $.messager.alert("错误提示", "删除数据错误!", 'info');
				} else {
				    $.messager.popover({ msg: '删除成功！', type: 'success', timeout: 1000 });
				    obj.RecRowID = ""
				    obj.gridMod.reload();//刷新当前页
				}
			}
		});
	}
    // PDCA模板编辑
	obj.LayerEdit = function () {
	    $('#LayerEdit').show();     
	    $HUI.dialog('#LayerEdit', {
	        title: "PDCA模板",
	        iconCls: 'icon-w-paper',
	        modal: true,
	        isTopZindex: true
	    })
	}
	//PDCA模板-初始化
	obj.layer = function(rowData){
		if(rowData){
			obj.RecRowID=rowData["ModID"];     //记录点击ID
			var ModCode = rowData["ModCode"];
			var ModName = rowData["ModName"];
			var IsActive = rowData["IsActive"];
			IsActive = (IsActive == "1" ? true : false)
			var ModResume = rowData["ModResume"];
			
			$('#txtCode').val(ModCode);
			$('#txtDesc').val(ModName);
			$('#txtResume').val(ModResume);
			$('#chkActive').checkbox('setValue', IsActive);
		}else{
			obj.RecRowID="";
			$('#txtCode').val('');
			$('#txtDesc').val('');
			$('#txtResume').val('');
			$('#chkActive').checkbox('setValue', false);
		}
		obj.LayerEdit();
	}
    //PDCA模板定义点击事件
	obj.OpenView = function (aID) {
	    var strUrl = "./dhcma.hai.ir.pdca.modext.csp?Parref=" + aID ;
	    websys_showModal({
	        url: strUrl,
	        title: '模板定义',
	        iconCls: 'icon-w-paper',
	        width: '95%',
	        height: '95%'
	    });
	}
}