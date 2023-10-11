// 流调类型编辑->Event
function InitEsurTypeWinEvent(obj) {
	//初始化信息
    obj.LoadEvent = function (args) {
		//添加
		$('#btnAdd').on('click', function () {
		    obj.LayerEdit();        //打开编辑框
		    obj.layer("");          //初始化编辑框
		});
		//编辑
		$('#btnEdit').on('click', function(){
		    var rowData = obj.gridESurType.getSelected();
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
    //选中流调类型编辑
    obj.gridESurType_onSelect = function () {
        var rowData = obj.gridESurType.getSelected();
        if ($("#btnEdit").hasClass("l-btn-disabled")) obj.RecRowID = "";    //点击置空
        if (rowData["ID"] == obj.RecRowID) {    //取消选中
            $("#btnAdd").linkbutton("enable");
            $("#btnEdit").linkbutton("disable");
            $("#btnDelete").linkbutton("disable");
            obj.RecRowID = "";
            obj.gridESurType.clearSelections();
        } else {    //选中行
            obj.RecRowID = rowData["ID"];
            $("#btnAdd").linkbutton("disable");
            $("#btnEdit").linkbutton("enable");
            $("#btnDelete").linkbutton("enable");
        }
    }
	//保存
	obj.btnSave_click = function(){
	    var OccCode=$('#txtCode').val();
	    var OccDesc = $('#txtDesc').val();
	    var OccPinyin = $('#txtPinyin').val();
	    var IsActive = $('#chkActive').checkbox('getValue') ? '1' : '0';
		var OccCode	= OccCode.trim();
	    var OccDesc = OccDesc.trim();
	    if (OccCode == '') {
	        $.messager.alert("错误提示", "代码不允许为空!", 'info');
	        return;
	    }
	    if (OccDesc == '') {
	        $.messager.alert("错误提示", "描述不允许为空!", 'info');
	        return;
	    }
	    var InputStr = obj.RecRowID;
	    InputStr += "^" + OccCode;
	    InputStr += "^" + OccDesc;
	    InputStr += "^" + IsActive;
	    InputStr += "^" + OccPinyin;
		
		var flg = $m({
		    ClassName: "DHCMed.EPD.ESurType",
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
			obj.gridESurType.reload();   //刷新当前页
		}
	}
	//删除
	obj.btnDelete_click = function(){
	    var rowDataID = obj.gridESurType.getSelected()["ID"];
		if (rowDataID==""){
			$.messager.alert("提示", "选中数据记录,再点击删除!", 'info');
			return;
		}
		$.messager.confirm("删除", "是否删除选中数据记录?", function (r){
			if(r){
				var flg = $m({
				    ClassName: "DHCMed.EPD.ESurType",
				    MethodName: "DeleteById",
				    aId: rowDataID
				}, false);
				if ((parseInt(flg)<0)) {
				    $.messager.alert("错误提示", "删除数据错误!", 'info');
				} else {
				    $.messager.popover({ msg: '删除成功！', type: 'success', timeout: 1000 });
				    obj.RecRowID = ""
				    obj.gridESurType.reload();//刷新当前页
				}
			}
		});
	}
    // 流调类型编辑
	obj.LayerEdit = function () {
	    $('#LayerEdit').show();     
	    $HUI.dialog('#LayerEdit', {
	        title: "流调类型编辑",
	        iconCls: 'icon-w-paper',
	        modal: true,
	        isTopZindex: true
	    })
	}
	//流调类型-初始化
	obj.layer = function(rowData){
		if(rowData){
			obj.RecRowID=rowData["ID"];     //记录点击ID
			var OccCode = rowData["BTCode"];
			var OccDesc = rowData["BTDesc"];
			var IsActive = rowData["IsActive"];
			IsActive = (IsActive == "1" ? true : false)
			var Resume = rowData["Resume"];
			
			$('#txtCode').val(OccCode);
			$('#txtDesc').val(OccDesc);
			$('#txtPinyin').val(Resume);
			$('#chkActive').checkbox('setValue', IsActive);
		}else{
			obj.RecRowID="";
			$('#txtCode').val('');
			$('#txtDesc').val('');
			$('#txtPinyin').val('');
			$('#txtSpec').val('');
			$('#cboUnit').combobox('setValue', '');
			$('#txtAvgAmount').val('');
			$('#txtResume').val('');
			$('#chkActive').checkbox('setValue', false);
		}
		obj.LayerEdit();
	}
	 //项目定义点击事件
	obj.OpenView1 = function (aID) {
	    var strUrl = "./dhcma.epd.esurtypeext.csp?Parref="+ aID ;
	    websys_showModal({
	        url: strUrl,
	        title: '项目定义',
	        iconCls: 'icon-w-paper',
	        width: '95%',
	        height: '95%'
	    });
	}
}