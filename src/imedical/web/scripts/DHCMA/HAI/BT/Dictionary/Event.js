function InitPhraseMapWinEvent(obj){
	
    obj.LoadEvent = function(args){
		$('#btnAdd').on('click', function(){
			obj.layer();
		});
		$('#btnEdit').on('click', function(){
			var rd=obj.gridDictionary.getSelected();
			obj.layer(rd);
		});
		$('#btnDelete').on('click', function(){
			obj.btnDelete_click();
		});
		$('#winBtnEdit').on('click', function(){
			obj.btnSave_click();
		});
		$('#winBtnClose').on('click', function(){
			$HUI.dialog('#layer').close();
		});
		$('#searchbox').searchbox({ 
			searcher:function(value,name){
				searchText($("#gridDictionary"),value);
			}	
		});
		$('#searchDicType').searchbox({ 
			searcher:function(value,name){
				obj.refreshDicType(value);
			}	
		});
		
		
    }
    //单击事件
	obj.gridDictionary_onSelect = function (rd,yindex){
		var yindex=yindex-1;
		if (rd["ID"] == obj.RecRowID) {
			obj.RecRowID="";
			$("#btnAdd").linkbutton("enable");
			$("#btnEdit").linkbutton("disable");
			$("#btnDelete").linkbutton("disable");
			obj.gridDictionary.clearSelections();
		} else {
			obj.RecRowID = rd["ID"];
			$("#btnAdd").linkbutton("disable");
			$("#btnEdit").linkbutton("enable");
			$("#btnDelete").linkbutton("enable");
		}
	}
	
	//双击编辑事件
	obj.gridDictionary_onDbselect = function(rd){
		obj.layer(rd);
	}
	//更新方法
	obj.btnSave_click = function(){
		
		var errinfo = "";
	    
		var DicCode = $('#txtDicCode').val();
		var DicDesc = $('#txtDicDesc').val();
		var TypeDr  = $(".hisui-accordion ul>li.active")[0]['id'];
		var IndNo   = $('#txtIndNo').val();
		var IsActive = $("#chkActive").checkbox('getValue')? '1':'0';
		
		if (!DicCode) {
			errinfo = errinfo + "字典代码不允许为空!<br>";
		}
		if (!DicDesc) {
			errinfo = errinfo + "字典名称不允许为空!<br>";
		}
		if (!TypeDr) {
			errinfo = errinfo + "字典分组不允许为空!<br>";
		}
		
		if (errinfo) {
			$.messager.alert("错误提示", errinfo, 'info');
			return ;
		}
		
		var InputStr = obj.RecRowID;
		InputStr += CHR_1 + DicCode;
		InputStr += CHR_1 + DicDesc;
		InputStr += CHR_1 + TypeDr;
		InputStr += CHR_1 + IndNo;
		InputStr += CHR_1 + IsActive;
		
		var flg = $m({
			ClassName:"DHCHAI.BT.Dictionary",
			MethodName:"Update",
			aInputStr:InputStr,
			aSeparete:CHR_1
		},false);
		if (parseInt(flg) > 0) {
			
			obj.RecRowID = "";
			$HUI.dialog('#layer').close();
			obj.qryDictionaryLoad($(".hisui-accordion ul>li.active")[0]['id']);//刷新当前页
			$.messager.popover({msg: '保存成功！',type:'success',timeout: 1000});
		}else {
			if (parseInt(flg) == -2) {
				$.messager.alert("错误提示", "代码重复!" , 'info');
			} else {
				$.messager.alert("错误提示", msgType+"失败!!Error=" + flg, 'info');
			}
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
					ClassName:"DHCHAI.BT.Dictionary",
					MethodName:"DeleteById",
					aId:obj.RecRowID
				},false);
				if (flg == '0') {
					obj.RecRowID = "";
					obj.qryDictionaryLoad($(".hisui-accordion ul>li.active")[0]['id']);	//刷新当前页
					$.messager.popover({msg: '删除成功！',type:'success',timeout: 1000});
				} else {
					if (parseInt(flg)=='-777') {
						$.messager.alert("错误提示","-777：当前无删除权限，请启用删除权限后再删除记录!",'info');
					}else {
						$.messager.alert("错误提示","删除失败!Error=" + flg, 'info');
					}			
				}
			}
		});
	}
	//配置窗体-初始化
	obj.layer= function(rd){
		if(rd){
			obj.RecRowID =rd["ID"];
			
			$('#txtDicCode').val(rd["DicCode"]);
			$('#txtDicDesc').val(rd["DicDesc"]);
			$('#txtIndNo').val(rd["IndNo"]);
			$("#chkActive").checkbox('setValue',(rd["IsActive"]=="1"? true: false));
		}else{
			obj.RecRowID ='';
			
			$('#txtDicCode').val("");
			$('#txtDicDesc').val('');
			$('#txtIndNo').val('');
			$("#chkActive").checkbox('setValue',false);
		} 
		$('#layer').show();
		$('#layer').dialog({
			title: '字典信息编辑',
			iconCls:"icon-w-paper",
			modal: true,
			isTopZindex:false
		});
	}

}