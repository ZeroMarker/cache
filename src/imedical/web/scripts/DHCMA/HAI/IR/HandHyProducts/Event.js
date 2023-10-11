 //页面Event
function InitHandHyProductsWinEvent(obj) {
	//初始化信息
    obj.LoadEvent = function(args){
	    //保存
	    $('#btnSave').on('click', function(){
		    obj.btnSave_click();
		});
		//关闭
		$('#btnClose').on('click', function(){
		    $HUI.dialog('#LayerEdit').close();
		});
		//添加
		$('#btnAdd').on('click', function () {
		    obj.LayerEdit();
			obj.layer("");
		});
		//编辑
		$('#btnEdit').on('click', function(){
		    var rowData = obj.gridHdProducts.getSelected();
		    obj.LayerEdit(); 
			obj.layer(rowData);
		});
		//删除
		$('#btnDelete').on('click', function () {
		    obj.btnDelete_click();

		});
    }
    //选中手卫生用品
    obj.gridHdProducts_onSelect = function () {
        var rowData = obj.gridHdProducts.getSelected();
        if ($("#btnEdit").hasClass("l-btn-disabled")) obj.RecRowID = "";    //点击置空
        if (rowData["ID"] == obj.RecRowID) {    //取消选中
            $("#btnAdd").linkbutton("enable");
            $("#btnEdit").linkbutton("disable");
            $("#btnDelete").linkbutton("disable");
            obj.RecRowID = "";
            obj.gridHdProducts.clearSelections();
        } else {    //选中行
            obj.RecRowID = rowData["ID"];
            $("#btnAdd").linkbutton("disable");
            $("#btnEdit").linkbutton("enable");
            $("#btnDelete").linkbutton("enable");
        }
    }
	//保存
	obj.btnSave_click = function(){
	    var ErrorStr = "";
	    var HHPCode=$('#txtCode').val();
	    var HHPDesc = $('#txtDesc').val();
	    var HHPPinyin = $('#txtPinyin').val();
	    var HHPSpec = $('#txtSpec').val();
	    var UnitDesc = $('#cboUnit').combobox('getValue');
	    var AvgAmount = $('#txtAvgAmount').val();
	    var Resume = $('#txtResume').val();
	    var IsActive = $('#chkIsActive').checkbox('getValue') ? '1' : '0';

	    if (HHPCode == '') {
	        ErrorStr += '代码不允许为空！<br/>';
	    }
	    if (HHPDesc == '') {
	        ErrorStr += '名称不允许为空！<br/>';
	    }
	    if (HHPSpec == '') {
	        ErrorStr += '规格不允许为空！<br/>';
	    }
	    if (UnitDesc == '') {
	        ErrorStr += '单位不允许为空！<br/>';
	    }
	    if (AvgAmount == '') {
	        ErrorStr += '次均用量不允许为空！<br/>';
	    }
	    if (ErrorStr != '') {
	        $.messager.alert("错误提示", ErrorStr, 'info');
	        return;
	    }
	    var InputStr = obj.RecRowID;
	    InputStr += "^" + HHPCode;
	    InputStr += "^" + HHPDesc;
	    InputStr += "^" + HHPPinyin;
	    InputStr += "^" + HHPSpec;
	    InputStr += "^" + UnitDesc;
	    InputStr += "^" + AvgAmount;
	    InputStr += "^" + IsActive;
	    InputStr += "^" + Resume;
		
		var flg = $m({
		    ClassName: "DHCHAI.IR.HandHyProducts",
		    MethodName: "Update",
		    aInputStr: InputStr,
			aSeparete:"^"
		},false);
		if (parseInt(flg) <= 0){
			if (parseInt(flg) == 0){
				$.messager.alert("错误提示", "填写数据错误!" , 'info');
			}else if(parseInt(flg) == -101){
				$.messager.alert("错误提示", "代码已存在，不允许重复!" , 'info');
			}else if(parseInt(flg) == -100){
				$.messager.alert("错误提示", "名称+规格已存在，不允许重复!" , 'info');
			}else {
				$.messager.alert("错误提示", "更新数据错误!Error=" + flg, 'info');
			}
		} else {
		    $HUI.dialog('#LayerEdit').close();
			$.messager.popover({msg: '保存成功！',type:'success',timeout: 1000});
			obj.gridHdProducts.reload();//刷新当前页
		}
	}
	//删除
	obj.btnDelete_click = function(){
	    var rowDataID = obj.gridHdProducts.getSelected()["ID"];
		if (rowDataID==""){
			$.messager.alert("提示", "选中数据记录,再点击删除!", 'info');
			return;
		}
		$.messager.confirm("删除", "是否删除选中数据记录?", function (r){
			if(r){
				var flg = $m({
				    ClassName: "DHCHAI.IR.HandHyProducts",
				    MethodName: "DeleteById",
				    aId: rowDataID
				}, false);
				if ((parseInt(flg) == -1)) {
				    $.messager.alert("错误提示", "删除数据错误!", 'info');
				} else if ((parseInt(flg) == -2)) {
				    $.messager.alert("错误提示", '该记录已被"手卫生用品消耗登记表"引用，不能删除!', 'info');
				} else if ((parseInt(flg) >= 0)) {
				    $.messager.popover({ msg: '删除成功！', type: 'success', timeout: 1000 });
				    obj.RecRowID = ""
				    obj.gridHdProducts.reload();//刷新当前页
				}
			}
		});
	}
    // 弹出手卫生用品消耗量编辑
	obj.LayerEdit = function () {
		$('#LayerEdit').show(); 
	    $HUI.dialog('#LayerEdit', {
	        title: "手卫生用品维护编辑",
	        iconCls: 'icon-w-paper',
	        modal: true,
	        isTopZindex: true
	    })
	}
	//手卫生用品维护窗体-初始化
	obj.layer = function(rowData){
		if(rowData){
			obj.RecRowID=rowData["ID"];     //记录点击ID
			var HHPCode = rowData["HHPCode"];
			var HHPDesc = rowData["HHPDesc"];
			var HHPPinyin = rowData["HHPPinyin"];
			var HHPSpec = rowData["HHPSpec"];
			var UnitDr = rowData["UnitDr"];
			var UnitDesc = rowData["UnitDesc"];
			var AvgAmount = rowData["AvgAmount"];
			var IsActive = rowData["IsActive"];
			IsActive = (IsActive == "1" ? true : false)
			var Resume = rowData["Resume"];
			
			$('#txtCode').val(HHPCode);
			$('#txtDesc').val(HHPDesc);
			$('#txtPinyin').val(HHPPinyin);
			$('#txtSpec').val(HHPSpec);
			$('#cboUnit').combobox('setValue', UnitDr);
			$('#cboUnit').combobox('setText', UnitDesc);
			$('#txtAvgAmount').val(AvgAmount);
			$('#txtResume').val(Resume);
			$('#chkIsActive').checkbox('setValue', IsActive);
		}else{
			obj.RecRowID="";
			$('#txtCode').val('');
			$('#txtDesc').val('');
			$('#txtPinyin').val('');
			$('#txtSpec').val('');
			$('#cboUnit').combobox('setValue', '');
			$('#txtAvgAmount').val('');
			$('#txtResume').val('');
			$('#chkIsActive').checkbox('setValue', false);
		}
		obj.LayerEdit();
	}
   
}