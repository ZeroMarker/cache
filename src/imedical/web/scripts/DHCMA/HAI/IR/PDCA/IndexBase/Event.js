function InitIndexBaseWinEvent(obj) {
	//初始化信息
    obj.LoadEvent = function (args) {
		//添加
		$('#btnAdd').on('click', function () {
		    obj.LayerEdit();        //打开编辑框
		    obj.layer("");          //初始化编辑框
		});
		//编辑
		$('#btnEdit').on('click', function(){
		    var rowData = obj.gridIndexBase.getSelected();
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
		//搜索
		$('#searchbox').searchbox({ 
			searcher:function(value,name){
				searchText($("#gridIndexBase"),value);
			}	
		});
    }
    //选中PDCA指标
    obj.gridIndexBase_onSelect = function () {
        var rowData = obj.gridIndexBase.getSelected();
        if ($("#btnEdit").hasClass("l-btn-disabled")) obj.RecRowID = "";    //点击置空
        if (rowData["ID"] == obj.RecRowID) {    //取消选中
            $("#btnAdd").linkbutton("enable");
            $("#btnEdit").linkbutton("disable");
            $("#btnDelete").linkbutton("disable");
            obj.RecRowID = "";
            obj.gridIndexBase.clearSelections();
        } else {    //选中行
            obj.RecRowID = rowData["ID"];
            $("#btnAdd").linkbutton("disable");
            $("#btnEdit").linkbutton("enable");
            $("#btnDelete").linkbutton("enable");
        }
    }
	//保存
	obj.btnSave_click = function(){
	    var IndexCode 	= $('#txtIndexCode').val();		//指标代码
	    var IndexCode	= IndexCode.trim();
	    var IndexDesc 	= $('#txtIndexDesc').val();		//指标名称
	    var IndexDesc 	= IndexDesc.trim();
	    var IndexType 	= "";							//指标分类
	    /*指标分类(暂时不启用)
	    var IndexType = $('#txtIndexType').val();
	    var IndexType = IndexType();
	    */
	    var KPA			= $('#txtKPA').val();			//标准值
	    var LinkRep		= $('#txtLinkRep').val();		//报表名称
	    var LinkRep		= LinkRep.trim();	
	    var LinkRepPath	= $('#txtLinkRepPath').val();	//报表路径
	    var LinkRepPath	= LinkRepPath.trim();
	    var LinkParm	= $('#txtLinkParm').val();		//报表参数
	    var LinkCsp		= $('#txtLinkCsp').val();		//关联Csp
	    var LinkCsp		= LinkCsp.trim();
	    var IsActive 	= $('#chkActive').checkbox('getValue') ? '1' : '0';
	   
		if (IndexCode == '') {
	        $.messager.alert("错误提示", "指标代码不允许为空!", 'info');
	        return;
	    }
	    if (IndexDesc == '') {
	        $.messager.alert("错误提示", "指标名称不允许为空!", 'info');
	        return;
	    }
	    if (LinkRep == '') {
	        $.messager.alert("错误提示", "报表名称不允许为空!", 'info');
	        return;
	    }
	    if (LinkRepPath == '') {
	        $.messager.alert("错误提示", "报表路径不允许为空!", 'info');
	        return;
	    }
	    if (LinkCsp == '') {
	        $.messager.alert("错误提示", "关联Csp不允许为空!", 'info');
	        return;
	    }
	    	     
	    var InputStr = obj.RecRowID;
	    InputStr += "^" + IndexCode;
	    InputStr += "^" + IndexDesc;
	    InputStr += "^" + IndexType;
	    InputStr += "^" + KPA;
	    InputStr += "^" + LinkRep;
	    InputStr += "^" + LinkRepPath;
	    InputStr += "^" + LinkParm;
	    InputStr += "^" + LinkCsp;
	    InputStr += "^" + IsActive;
		
		var flg = $m({
		    ClassName: "DHCHAI.IR.PDCAIndexBase",
		    MethodName: "Update",
		    aInputStr: InputStr,
			aSeparete:"^"
		},false);
		if(parseInt(flg)>0){
			$HUI.dialog('#LayerEdit').close();
			$.messager.popover({msg: '保存成功！',type:'success',timeout: 1000});
			obj.gridIndexBase.reload();   //刷新当前页
		}
		else{
			if(parseInt(flg) == -2){
				$.messager.alert("错误提示", "指标代码重复!" , 'info');
			}
			else if(parseInt(flg) == -3){
				$.messager.alert("错误提示", "指标名称重复!" , 'info');
			}
			else {
				$.messager.alert("错误提示", "更新数据错误!Error=" + flg, 'info');
			}
		}
	}
	//删除
	obj.btnDelete_click = function(){
	    var rowDataID = obj.gridIndexBase.getSelected()["ID"];
		if (rowDataID==""){
			$.messager.alert("提示", "选中数据记录,再点击删除!", 'info');
			return;
		}
		$.messager.confirm("删除", "是否删除选中数据记录?", function (r){
			if(r){
				var flg = $m({
				    ClassName: "DHCHAI.IR.PDCAIndexBase",
				    MethodName: "DeleteById",
				    aID: rowDataID
				}, false);
				if ((parseInt(flg)<0)) {
				    $.messager.alert("错误提示", "删除数据错误!", 'info');
				} else {
				    $.messager.popover({ msg: '删除成功！', type: 'success', timeout: 1000 });
				    obj.RecRowID = ""
				    obj.gridIndexBase.reload();//刷新当前页
				}
			}
		});
	}
    // PDCA指标库编辑
	obj.LayerEdit = function () {
	    $('#LayerEdit').show();     
	    $HUI.dialog('#LayerEdit', {
	        title: "PDCA指标库",
	        iconCls: 'icon-w-paper',
	        modal: true,
	        isTopZindex: true
	    })
	}
	//PDCA指标库-初始化
	obj.layer = function(rowData){
		if(rowData){
			obj.RecRowID=rowData["ID"];     //记录点击ID
			var IndexCode	= rowData["IndexCode"];
			var IndexDesc 	= rowData["IndexDesc"];
			var IndexType 	= rowData["IndexType"];
			var KPA			= rowData["KPA"];
			var LinkRep 	= rowData["LinkRep"];
			var LinkRepPath = rowData["LinkRepPath"];
			var LinkParm	= rowData["LinkParm"];
			var LinkCsp 	= rowData["LinkCsp"];
			var IsActive	= rowData["IsActive"];
			IsActive 		= (IsActive == "1" ? true : false)
			
			$('#txtIndexCode').val(IndexCode).validatebox("validate");
			$('#txtIndexDesc').val(IndexDesc).validatebox("validate");
			$('#txtIndexType').val(IndexType).validatebox("validate");
			$('#txtKPA').val(KPA);
			$('#txtLinkRep').val(LinkRep).validatebox("validate");
			$('#txtLinkRepPath').val(LinkRepPath).validatebox("validate");
	    	$('#txtLinkParm').val(LinkParm);
	    	$('#txtLinkCsp').val(LinkCsp).validatebox("validate");
			$('#chkActive').checkbox('setValue', IsActive);
		}else{
			obj.RecRowID="";
			$('#txtIndexCode').val('').validatebox("validate");
			$('#txtIndexDesc').val('').validatebox("validate");
			$('#txtIndexType').val('').validatebox("validate");
			$('#txtKPA').val('');
			$('#txtLinkRep').val('').validatebox("validate");
			$('#txtLinkRepPath').val('').validatebox("validate");
	    	$('#txtLinkParm').val('');
	    	$('#txtLinkCsp').val('').validatebox("validate");
			$('#chkActive').checkbox('setValue', false);
		}
		obj.LayerEdit();
	}
}