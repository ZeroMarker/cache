//页面Event
function InitPathEntityListWinEvent(obj){
	
	//按钮初始化
	$('#winPathEntityEdit').dialog({
		title: '并发症分级字典维护',
		iconCls:"icon-w-paper",
		closed: true,
		modal: true,
		isTopZindex:true
	});
	
	// 检查删除按钮是否允许删除，若否则隐藏该按钮
	if(!chkDelBtnIsAble("DHCMA.IMP.BT.IMPOperCompLvl")){
		$("#btnDelete").hide();	
	}else{
		$("#btnDelete").show();	
	}
	
	obj.LoadEvent = function(args){ 
		//保存
		$('#btnSave').on('click', function(){
	     	obj.btnSave_click();
     	});
		//关闭
		$('#btnClose').on('click', function(){
	     	$HUI.dialog('#winPathEntityEdit').close();
     	});
		//添加
		$('#btnAdd').on('click', function(){
			obj.layer();
			
		});
		//编辑
		$('#btnEdit').on('click', function(){
			var rd=obj.gridPathEntity.getSelected();
			obj.layer(rd);	
		});
		//删除
		$('#btnDelete').on('click', function(){
			obj.btnDelete_click();
		});
	}   
	//单击路径字典
	obj.gridPathEntity_onSelect = function (rowID){
		//var rowID = obj.gridPathEntity.getSelected()["BTID"];
		if($("#btnEdit").hasClass("l-btn-disabled")) obj.RecRowID="";
		
		if (rowID["BTID"] == obj.RecRowID) {
			obj.RecRowID="";
			$("#btnAdd").linkbutton("enable");
			$("#btnEdit").linkbutton("disable");
			$("#btnDelete").linkbutton("disable");
			obj.gridPathEntity.clearSelections();
		}
		else {
			obj.RecRowID = rowID["BTID"];
			$("#btnAdd").linkbutton("disable");
			$("#btnEdit").linkbutton("enable");
			$("#btnDelete").linkbutton("enable");	 
		}
	}
	//双击编辑事件
	obj.gridPathEntity_onDbselect = function(rd){
		obj.layer(rd);
	}	
	//更新方法
	obj.btnSave_click = function(){
		var errinfo = "";
		var myDate = new Date();
		var Code = $('#txtCode').val();
		var Desc = $('#txtDesc').val();
		var LinkLevel = $('#txtLinkLevel').val();
		var Order = $('#txtOrder').val();
		var IsActive = $("#chkIsActive").checkbox('getValue')? '1':'0';
		
		if (!Code) {
			errinfo = errinfo + "代码为空!<br>";
		}
		if (!Desc) {
			errinfo = errinfo + "名称为空!<br>";
		}
		if(!LinkLevel){
			errinfo = errinfo + "关联等级为空!<br>";
		}
		var IsCheck = $m({
			ClassName:"DHCMA.IMP.BT.OperCompLvL",
			MethodName:"CheckPTCode",
			aCode:Code,
			aID:obj.RecRowID
		},false);
	  	if(IsCheck>=1) {
	  		errinfo = errinfo + "代码与列表中现有项目重复，请检查修改!<br>";
	  	}
	  	
		if (errinfo) {
			$.messager.alert("错误提示", errinfo, 'info');
			return;
		}
		
		var inputStr = obj.RecRowID;
		inputStr = inputStr + CHR_1 + Code;
		inputStr = inputStr + CHR_1 + Desc;
		inputStr = inputStr + CHR_1 + LinkLevel;
		inputStr = inputStr + CHR_1 + IsActive;
		inputStr = inputStr + CHR_1 + Order;
		inputStr = inputStr + CHR_1 + "";
		inputStr = inputStr + CHR_1 + "";
		inputStr = inputStr + CHR_1 + session['LOGON.USERID'];
		var flg = $m({
			ClassName:"DHCMA.IMP.BT.OperCompLvL",
			MethodName:"Update",
			aInputStr:inputStr,
			aSeparete:CHR_1
		},false);
		if (parseInt(flg) <= 0) {
			if (parseInt(flg) == 0) {
				$.messager.alert("错误提示", "参数错误!" , 'info');
			}else if (parseInt(flg) == -2) {
				$.messager.alert("错误提示", "数据重复!" , 'info');
			} else {
				$.messager.alert("错误提示", "更新数据错误!Error=" + flg, 'info');
			}
		}else {
			$HUI.dialog('#winPathEntityEdit').close();
			$.messager.popover({msg: '保存成功！',type:'success',timeout: 1000});
			obj.RecRowID = flg;	
			obj.gridPathEntity.reload();//刷新当前页
		}
	}
	//删除分类 
	obj.btnDelete_click = function(){
		var rowID=obj.gridPathEntity.getSelected()["BTID"];
		if(rowID==""){
			$.messager.alert("提示", "选中数据记录,再点击删除!", 'info');
			return;
		}
		$.messager.confirm("删除", "是否删除选中数据记录?", function (r) {				
			if (r) {		
				var flg = $m({
					ClassName:"DHCMA.IMP.BT.OperCompLvL",
					MethodName:"DeleteById",
					aId:rowID
				},false);
				if (parseInt(flg) < 0) {
					$.messager.alert("错误提示","删除数据错误!Error=" + flg, 'info');
				} else {
					$.messager.popover({msg: '删除成功！',type:'success',timeout: 1000});
					obj.gridPathEntity.reload() ;//刷新当前页
				}
			} 
		});

	}
	//配置窗体-初始化
	obj.layer= function(rd){
		if(rd){
			obj.RecRowID = rd["BTID"];
			var Code = rd["BTCode"];
			var Desc = rd["BTDesc"];
			var Order = rd["BTOrder"];
			var LinkLevel =rd["BTLinkLevel"];
			var BTIsActive = rd["BTIsActive"];
			BTIsActive = (BTIsActive=="是"? true: false)
			$('#txtCode').val(Code);
			$('#txtDesc').val(Desc);
			$('#txtLinkLevel').val(LinkLevel);
			$('#txtOrder').val(Order);
			$('#chkIsActive').checkbox('setValue',BTIsActive);
		}else{
			obj.RecRowID = "";
			$('#txtCode').val('');
			$('#txtDesc').val('');
			$('#txtOrder').val('');
			$('#txtLinkLevel').val('');
			$('#chkIsActive').checkbox('setValue',false);
		}
		$HUI.dialog('#winPathEntityEdit').open();
	}	
	
}