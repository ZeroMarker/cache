//页面Event
function InitPhraseTypeWinEvent(obj){
	//CheckSpecificKey();
	//弹窗初始化
	obj.InitDialog=function(){
		$('#layer').dialog({
			title: '常用短语编辑',
			iconCls:'icon-w-paper',
			headerCls:'panel-header-gray',
			modal: true,
			isTopZindex:true,
		});
	}
	//$.form.iCheckRender();
	/*****搜索功能*****/
    //搜索常用短语分类
	$('#btnsearch').searchbox({ 
		searcher:function(value,name){
			searchText($("#gridPhraseType"),value);
		}	
	});
   /**********************/
   	
    obj.LoadEvent = function(args){
	    obj.gridPhraseTypeLoad();
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
			obj.layer("");
		});
		//编辑
		$('#btnEdit').on('click', function(){
			var rowData=obj.gridPhraseType.getSelected();
			obj.layer(rowData);
		});
		//删除
		$('#btnDelete').on('click', function(){
			obj.btnDelete_click();
		});
    }
    
    //选择常用短语分类
    obj.gridPhraseType_onSelect = function (){
	    var rowData = obj.gridPhraseType.getSelected();
	    if($("#btnEdit").hasClass("l-btn-disabled")) obj.RecRowID="";
	    
	    if (rowData["ID"] == obj.RecRowID){
		    $("#btnAdd").linkbutton("enable");
		    $("#btnEdit").linkbutton("disable");
		    $("#btnDelete").linkbutton("disable");
		    obj.RecRowID="";
		    obj.gridPhraseType.clearSelections();
		}else {
			obj.RecRowID = rowData["ID"];
			$("#btnAdd").linkbutton("disable");
			$("#btnEdit").linkbutton("enable");
			$("#btnDelete").linkbutton("enable");
		}
	}
	
	//双击编辑事件
	obj.gridPhraseType_onDbselect = function(rowData){
		obj.layer(rowData);
	}
	//保存
	obj.btnSave_click = function(){
		var errinfo = "";
		var Code = $('#txtCode').val();
		var Desc = $('#txtDesc').val();
		var DicTypeCode = $('#cboDicType').combobox('getValue');
		
		if (!Code) {
			errinfo = errinfo + "代码不允许为空!<br>";
		}
		if (!Desc) {
			errinfo = errinfo + "描述不允许为空!<br>";
		}
		if (!DicTypeCode) {
			errinfo = errinfo + "字典分类不允许为空!<br>";
		}
		if (errinfo) {
			$.messager.alert("错误提示", errinfo, 'info');
			return;
		}
		var inputStr = obj.RecRowID;
		inputStr = inputStr + "^" + Code;
		inputStr = inputStr + "^" + Desc;
		inputStr = inputStr + "^" + DicTypeCode;
		
		var flg = $m({
			ClassName:"DHCHAI.DP.PhraseType",
			MethodName:"Update",
			InStr:inputStr,
			aSeparete:"^"
		},false);
		if (parseInt(flg) <= 0){
			if (parseInt(flg) == 0){
				$.messager.alert("错误提示", "参数错误!" , 'info');
			}else if(parseInt(flg) == -100){
				$.messager.alert("错误提示", "数据重复!" , 'info');
			}else {
				$.messager.alert("错误提示", "更新数据错误!Error=" + flg, 'info');
			}
		}else{
			$HUI.dialog('#layer').close();
			$.messager.popover({msg: '保存成功！',type:'success',timeout: 1000});
			//obj.gridPhraseType.reload() ;//刷新当前页
			obj.gridPhraseTypeLoad();
		}
	}
   //删除
	obj.btnDelete_click = function(){
		var rowDataID = obj.gridPhraseType.getSelected()["ID"];
		if (rowDataID==""){
			$.messager.alert("提示", "选中数据记录,再点击删除!", 'info');
			return;
		}
		$.messager.confirm("删除", "是否删除选中数据记录?", function (r){
			if(r){
				var flg = $m({
					ClassName:"DHCHAI.DP.PhraseType",
					MethodName:"DeleteById",
					Id:rowDataID
				},false);
				if(parseInt(flg) < 0){
					$.messager.alert("错误提示","删除数据错误!Error=" + flg, 'info');
				}else{
					$.messager.popover({msg: '删除成功！',type:'success',timeout: 1000});
					obj.RecRowID = ""
					//obj.gridPhraseType.reload() ;//刷新当前页
					obj.gridPhraseTypeLoad();
				}
			}
		});
	}
   //配置窗体-初始化
	obj.layer = function(rowData){
		if(rowData){
			obj.RecRowID=rowData["ID"];
			var Code = rowData["Code"];
			var Desc = rowData["Desc"];
			//var DicTypeDesc = rowData["DicTypeDesc"];
			var DicTypeCode = rowData["DicTypeCode"];
			
			$('#txtCode').val(Code);
			$('#txtDesc').val(Desc);
			$('#cboDicType').combobox('setValue',DicTypeCode);
		}else{
			obj.RecRowID="";
			$('#txtCode').val('');
			$('#txtDesc').val('');
			$('#cboDicType').combobox('setValue','');
		}
		//$HUI.dialog('#layer').open();
		$('#layer').show();
		obj.InitDialog()
	}
	
	//加载明细
	obj.gridPhraseTypeLoad = function(){
		$("#gridPhraseType").datagrid("loading");
		originalData["gridPhraseType"]="";
		$cm ({
			ClassName:'DHCHAI.DPS.PhraseTypeSrv',
			QueryName:'QryPhraseType',
			ResultSetType:'array',
			aDesc:"",
			page:1,      //可选项，页码，默认1			
			rows:9999   //可选项，获取多少条数据，默认50
		},function(rs){
			$('#gridPhraseType').datagrid({loadFilter:pagerFilter}).datagrid('loadData', rs);				
		})
    }
	
}