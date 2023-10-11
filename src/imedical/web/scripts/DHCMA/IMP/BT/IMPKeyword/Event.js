//页面Event
function InitWinEvent(obj){
	
	$('#winIMPKeyword').dialog({
		title: '重点患者关键词维护',
		iconCls:"icon-w-paper",
		closed: true,
		modal: true,
		isTopZindex:true
		
	});

	$('#winSemanticWord').dialog({
		title: '重点患者语义词维护',
		iconCls:"icon-w-paper",
		closed: true,
		modal: true,
		isTopZindex:true
		
	});	
	
	// 检查删除按钮是否允许删除，若否则隐藏该按钮
	if(!chkDelBtnIsAble("DHCMA.IMP.BT.IMPKeyword")){
		$("#btnDelete").hide();	
	}else{
		$("#btnDelete").show();	
	}
	// 检查删除按钮是否允许删除，若否则隐藏该按钮
	if(!chkDelBtnIsAble("DHCMA.IMP.BT.IMPSemanticWord")){
		$("#btnSubDelete").hide();	
	}else{
		$("#btnSubDelete").show();	
	}
	
    obj.LoadEvent = function(args){ 
     	//保存
		$('#btnSave').on('click', function(){
	     	obj.btnSave_click();
     	});
		//关闭
		$('#btnClose').on('click', function(){
	     	$HUI.dialog('#winIMPKeyword').close();
     	});
		//添加
     	$('#btnAdd').on('click', function(){
			obj.layer1();
     	});
		//编辑
		$('#btnEdit').on('click', function(){
	     	var rd=obj.gridIMPKeyword.getSelected()
			obj.layer1(rd);	
     	});
		//删除
		$('#btnDelete').on('click', function(){
	     	obj.btnDelete_click();
     	});
		//保存子类
		$('#btnSubSave').on('click', function(){
	     	obj.btnSaveSub_click();
     	});
		//关闭子类
		$('#btnSubClose').on('click', function(){
	     	$HUI.dialog('#winSemanticWord').close();
     	});
		//删除子类
     	$('#btnSubDelete').on('click', function(){
			if(!obj.RecRowID1)  return;
	     	obj.btnDeleteSub_click();
     	});
		//编辑子类
     	$('#btnSubEdit').on('click', function(){
			if(!obj.RecRowID1)return;
	     	var rd=obj.gridSemanticWord.getSelected();
			obj.layer2(rd);		
     	});
		//添加子类
     	$('#btnSubAdd').on('click', function(){
			if(!obj.RecRowID1)return;
			obj.layer2();	
     	});
		//关键字查询
		$('#ItemKey').searchbox({
		    searcher:function(value,name){
		    	obj.gridIMPKeyword.load({
						ClassName:"DHCMA.IMP.BTS.IMPKeywordSrv",
						QueryName:"QryIMPKeywordByKey",
						aIsActive:"1",
						aKey:value		
						});
		    },
		    prompt:'请输入关键字/代码'
		});
     }
	
	//前台保存数据
	$.extend($.fn.datagrid.methods, {
		editCell: function(jq,param){
			return jq.each(function(){
				var opts = $(this).datagrid('options');
				var fields = $(this).datagrid('getColumnFields',true).concat($(this).datagrid('getColumnFields'));
				for(var i=0; i<fields.length; i++){
					var col = $(this).datagrid('getColumnOption', fields[i]);
					col.editor1 = col.editor;
					if (fields[i] != param.field){
						col.editor = null;
					}
				}
				$(this).datagrid('beginEdit', param.index);
				for(var i=0; i<fields.length; i++){
					var col = $(this).datagrid('getColumnOption', fields[i]);
					col.editor = col.editor1;
				}
			});
		}
	});
	
	//选择关键词
	obj.gridIMPKeyword_onSelect = function(){
		if($("#btnEdit").hasClass("l-btn-disabled")) obj.RecRowID1="";
		var rowData = obj.gridIMPKeyword.getSelected();
	
		if (rowData["BTID"] == obj.RecRowID1) {

			$("#btnAdd").linkbutton("enable");
			$("#btnEdit").linkbutton("disable");
			$("#btnDelete").linkbutton("disable");
			$("#btnSubAdd").linkbutton("disable");
			$("#btnSubEdit").linkbutton("disable");
			$("#btnSubDelete").linkbutton("disable");
			obj.RecRowID1="";
			//obj.PathTCMExtLoad();
			obj.gridSemanticWord.loadData([]);
			obj.gridIMPKeyword.clearSelections();  //清除选中行
		} else {
			obj.RecRowID1 = rowData["BTID"];
			$("#btnAdd").linkbutton("disable");
			$("#btnEdit").linkbutton("enable");
			$("#btnDelete").linkbutton("enable");
			obj.SemanticWordLoad();  //加载子分类	
		}
	}	
	//双击编辑事件 父表
	obj.gridIMPKeyword_onDbselect = function(rd){
		obj.layer1(rd);	
	}
	//选择子项
    obj.gridSemanticWord_onSelect = function (){
		if($("#btnEdit").hasClass("l-btn-disabled")) return;
		if(!obj.RecRowID1)return;
		if($("#btnSubEdit").hasClass("l-btn-disabled")) obj.RecRowID2="";
		var rowData = obj.gridSemanticWord.getSelected();
		if (rowData["BTID"] == obj.RecRowID2) {
			$("#btnSubAdd").linkbutton("enable");
			$("#btnSubEdit").linkbutton("disable");
			$("#btnSubDelete").linkbutton("disable");
			obj.RecRowID2="";
			obj.gridSemanticWord.clearSelections();  //清除选中行
		} else {
			obj.RecRowID2 = rowData["BTID"];
			$("#btnSubAdd").linkbutton("disable");
			$("#btnSubEdit").linkbutton("enable");
			$("#btnSubDelete").linkbutton("enable");	
		}
	}
    //双击编辑事件 子表
	obj.gridSemanticWord_onDbSelect = function(rd){
		if($("#btnEdit").hasClass("l-btn-disabled")){
		$.messager.alert("错误提示", "请先选择左表中的数据" , 'info');			
		return;
		}
		if(!obj.RecRowID1) return;
		
		obj.layer2(rd);	
	}
	//保存分类
	obj.btnSave_click = function(){
		var errinfo = "";
		var Code = $('#txtKCode').val();
		var Desc = $('#txtKDesc').val();
		var IsActive = $('#KIsActive').checkbox('getValue');
		IsActive = (IsActive==true? 1: 0);
		if (!Code) {
			errinfo = errinfo + "关键词代码为空!<br>";
		}
		if (!Desc) {
			errinfo = errinfo + "特因描述为空!<br>";
		}	
		if (errinfo) {
			$.messager.alert("错误提示", errinfo, 'info');
			return;
		}
		
		var inputStr = obj.RecRowID1;
		inputStr = inputStr + "^" + Code;
		inputStr = inputStr + "^" + Desc;
		inputStr = inputStr + "^" + IsActive;
	
		var flg = $m({
			ClassName:"DHCMA.IMP.BT.IMPKeyword",
			MethodName:"Update",
			aInputStr:inputStr,
			aSeparete:"^"
		},false);
		
		if (parseInt(flg) <= 0) {
			if (parseInt(flg) == 0) {
				$.messager.alert("错误提示", "参数错误!" , 'info');
			} else {
				$.messager.alert("错误提示", "更新数据错误!Error=" + flg, 'info');
			}
		}else {
			$.messager.popover({msg: '保存成功！',type:'success',timeout: 1000});
			obj.RecRowID1=flg;
			obj.gridIMPKeyword.reload() ;//刷新当前页
			obj.gridSemanticWord.loadData([]);//刷新当前
			$HUI.dialog('#winIMPKeyword').close();
		}
	}
	//删除分类 
	obj.btnDelete_click = function(){
		var rowData = obj.gridIMPKeyword.getSelected();
		var rowID=rowData["BTID"]
		if (rowID==""){
			$.messager.alert("提示", "选中数据记录,再点击删除!", 'info');
		}
		$.messager.confirm("删除", "是否删除选中数据记录?", function (r) {				
			if (r) {				
				var flg = $m({
					ClassName:"DHCMA.IMP.BT.IMPKeyword",
					MethodName:"DeleteById",
					aId:rowID
				},false);
				if (parseInt(flg) < 0) {
					$.messager.alert("错误提示","删除数据错误!Error=" + flg, 'info');	
				} else {
					$.messager.popover({msg: '删除成功！',type:'success',timeout: 1000});
					obj.RecRowID1="";
					obj.gridSemanticWord.reload();//刷新当前
					obj.gridIMPKeyword.reload() ;//刷新当前页	
				}
			} 
		});
	}
	//保存子类
	obj.btnSaveSub_click =  function(){
		var errinfo = "";	
		var inputStr= ""
		var Desc = $('#txtSDesc').val();
		var IsActive = $('#SIsActive').checkbox('getValue');
		IsActive = (IsActive==true? 1: 0);
		if (!Desc) {
			errinfo = errinfo + "语义词为空!<br>";
		}	
		if (errinfo) {
			$.messager.alert("错误提示", errinfo, 'info');
			return;
		}
		var inputStr = obj.RecRowID2;
		inputStr = inputStr + "^" + Desc;
		var rd=$('#gridIMPKeyword').datagrid('getSelected');
		var DicTID=rd.BTID
		inputStr = inputStr + "^" + DicTID;
		inputStr = inputStr + "^" + IsActive;
		
		var flg = $m({
			ClassName:"DHCMA.IMP.BT.SemanticWord",
			MethodName:"Update",
			aInputStr:inputStr,
			aSeparete:"^"
		},false);
		//console.log((parseInt(flg)<=0)+flg+inputStr);
		if (parseInt(flg) <= 0) {
			if (parseInt(flg) == 0) {
				$.messager.alert("错误提示", "参数错误!", 'info');
			} else {
				$.messager.alert("错误提示", "更新数据错误!Error=" + flg, 'info');
			}
		}else {
			$.messager.popover({msg: '保存成功！',type:'success',timeout: 1000});
			obj.RecRowID2 =flg
			obj.gridSemanticWord.reload() ;//刷新当前页
			$HUI.dialog('#winSemanticWord').close();
		}
	}
	//删除子分类
	obj.btnDeleteSub_click = function(){
		var rowData = obj.gridSemanticWord.getSelected();
		var rowDataID =rowData["BTID"];
		if ((obj.RecRowID1=="")||(rowDataID=="")){
			$.messager.alert("提示", "选中数据记录,再点击删除!", 'info');
		}
		$.messager.confirm("删除", "是否删除选中数据记录?", function (r) {
			if (r) {				
				 var flg = $m({
					ClassName:"DHCMA.IMP.BT.SemanticWord",
					MethodName:"DeleteById",
					aId:rowDataID
				},false);		
				if (parseInt(flg) < 0) {
					$.messager.alert("错误提示","删除数据错误!Error=" + flg, 'info');
					return;
				} else {
					$.messager.popover({msg: '删除成功！',type:'success',timeout: 1000});
					obj.RecRowID2="";
					obj.gridSemanticWord.reload() ;//刷新当前页		
				}							
			}
		});

	}
	//加载子表
	obj.SemanticWordLoad = function () {
		var ParRef = "";
		if (obj.RecRowID1) {
			ParRef =obj.RecRowID1;
		}
		obj.gridSemanticWord.load({
			ClassName:"DHCMA.IMP.BTS.SemanticWordSrv",
			QueryName:"QrySemanticWByKeyI",
			aParRef:ParRef
		});	
	}
	//配置窗体-初始化
	obj.layer1= function(rd){
		if(rd){
			obj.RecRowID1=rd["BTID"];
			var Code = rd["Code"];
			var Desc = rd["Desc"];
			
			var IsActive = rd["BTIsActive"];
			IsActive = (IsActive=="是"? true: false);
			
			$('#txtKCode').val(Code);
			$('#txtKDesc').val(Desc);
			$('#KIsActive').checkbox('setValue',IsActive);
		}else{
			obj.RecRowID1="";
			
			$('#txtKCode').val('');
			$('#txtKDesc').val('');
			$('#KIsActive').checkbox('setValue',false);
		}
		$HUI.dialog('#winIMPKeyword').open();
	}
    //配置窗体-初始化
	obj.layer2= function(rd){
		if(!obj.RecRowID1){
			//若（obj.RecRowID1 为空）父表未被选中，则子表不进行操作
			$.messager.alert("错误提示","请先选定关键词",'info');
			return;
		}	
		if(rd){
			obj.RecRowID2 =rd["BTID"];
			var Desc = rd["BTDesc"];
			var IsActive = rd["BTIsActive"];
			IsActive = (IsActive=='是'? true: false);
			
			$('#txtSDesc').val(Desc);
			$('#SIsActive').checkbox('setValue',IsActive);
		}else{
			obj.RecRowID2 ="";
			$('#txtSDesc').val('');
			$('#SIsActive').checkbox('setValue',false);	
		}
		$HUI.dialog('#winSemanticWord').open();
	}			
}
