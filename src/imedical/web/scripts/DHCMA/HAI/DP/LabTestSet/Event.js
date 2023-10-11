//页面Event
function InitLabTestSetWinEvent(obj){
	
	var p = $('#gridLabSetCat').datagrid('getPager');
	    if (p){
	        $(p).pagination({ //设置分页功能栏
	           //分页功能可以通过Pagination的事件调用后台分页功能来实现
	        	onRefresh:function(){
		        	obj.RecRowID=""
					obj.gridLabTestSetLoad();  //刷新当前页
					$("#btnAdd_two").linkbutton("disable");
					$("#btnEdit_two").linkbutton("disable");
					$("#btnDelete_two").linkbutton("disable");
	        	}
	 
	        });
	    }
	//按钮初始化
	obj.LoadEvent = function(args){ 
		$('#gridLabSetCat').datagrid('loadData',{ 'total':'0',rows:[] });  //初始加载显示记录为0
		obj.gridLabSetCatLoad();
		$('#btnAdd_one').on('click', function(){
			obj.InitDialog();
		});
		$('#btnEdit_one').on('click', function(){
			var rd=obj.gridLabSetCat.getSelected();
			obj.InitDialog(rd);
		});
		$('#btnDelete_one').on('click', function(){
			obj.btnDelete_click();
		});
		$('#search_one').searchbox({ 
			searcher:function(value,name){
				searchText($("#gridLabSetCat"),value);
			}	
		});	

		
		$('#btnAdd_two').on('click', function(){
			obj.InitDialog_two();
		});
		$('#btnEdit_two').on('click', function(){
			var rd=obj.gridLabTestSet.getSelected();
			obj.InitDialog_two(rd);
		});
		$('#btnDelete_two').on('click', function(){
			obj.btnDelete_two_click();
		});
		$('#btnsearch_two').searchbox({ 
			searcher:function(value,name){ 
				searchText($("#gridLabTestSet"),value);
			}	
		});
     }
   //选择常规检验项目
	obj.gridLabSetCat_onSelect = function(){
		var rowData = obj.gridLabSetCat.getSelected();
		if (rowData["ID"] == obj.RecRowID) {
			$("#btnAdd_one").linkbutton("enable");
			$("#btnEdit_one").linkbutton("disable");
			$("#btnDelete_one").linkbutton("disable");
			obj.RecRowID="";
			obj.gridLabSetCat.clearSelections();  //清除选中行
			obj.gridLabTestSetLoad();
		} else {
			obj.RecRowID = rowData["ID"];
			$("#btnAdd_one").linkbutton("disable");
			$("#btnEdit_one").linkbutton("enable");
			$("#btnDelete_one").linkbutton("enable");
			obj.gridLabTestSetLoad();  //加载
			}
		}
		
	//加载项目结果
	obj.gridLabTestSetLoad = function () {
		var aCatID = "";
		if (obj.RecRowID) {
			aCatID =obj.RecRowID;
		}
		$cm ({
			ClassName:"DHCHAI.DPS.LabTestSetSrv",
			QueryName:"QryLabSetByCat",
			aCatID:aCatID,
			page:1,
			rows:9999
		},function(rs){
			$('#gridLabTestSet').datagrid({loadFilter:pagerFilter}).datagrid('loadData', rs);					
		});	
		
	}
	//双击编辑事件
	obj.gridLabSetCat_onDbselect = function(rd){
		obj.InitDialog(rd);
	}
	//双击编辑事件
	obj.gridLabTestSet_onDbselect = function(rd){
		obj.InitDialog_two(rd);
	}
	//选择2
	obj.gridLabTestSet_onSelect = function (){
		var rowData = obj.gridLabTestSet.getSelected();
		if($("#btnEdit_two").hasClass("l-btn-disabled")) obj.RecRowID2="";
		if (rowData["ID"] == obj.RecRowID2) {
			obj.RecRowID2="";
			$("#btnAdd_two").linkbutton("enable");
			$("#btnEdit_two").linkbutton("disable");
			$("#btnDelete_two").linkbutton("disable");
			obj.gridLabTestSet.clearSelections();
		} else {
			obj.RecRowID2 = rowData["ID"];
			$("#btnAdd_two").linkbutton("disable");
			$("#btnEdit_two").linkbutton("enable");
			$("#btnDelete_two").linkbutton("enable");
		}
	}
	//保存
	obj.btnSave_click = function(){
		var errinfo = "";
		var BTCode = $('#txtBTCode').val();
		var BTDesc = $('#txtBTDesc').val();
		if (!BTCode) {
			errinfo = errinfo + "检验医嘱分类代码不允许为空!<br>";
		}
		if (!BTDesc) {
			errinfo = errinfo + "检验医嘱分类名称不允许为空!<br>";
		}
		if (errinfo) {
			$.messager.alert("错误提示", errinfo, 'info');
			return;
		}
		var inputStr = obj.RecRowID;
		inputStr = inputStr + '^' + BTCode;
		inputStr = inputStr + '^' + BTDesc;
		var flg = $m({
			ClassName:"DHCHAI.DP.LabTestSetCat",
			MethodName:"Update",
			InStr:inputStr,
			aSeparete:"^"
		},false);
		if (parseInt(flg) <= 0) {
			if (parseInt(flg) == '-100') {
				$.messager.alert("错误提示", "代码重复!" , 'info');
				return;
			}else{
				$.messager.alert("错误提示", "保存失败" , 'info');
				return;
				}
		}else {
			$HUI.dialog('#winEdit').close();
			$.messager.popover({msg: '保存成功！',type:'success',timeout: 1000});
			obj.RecRowID = "";
			originalData["gridLabSetCat"] =""
			obj.gridLabSetCatLoad();//刷新当前页
		}
	}
	obj.btnSave_two_click = function(){
		var rowData = obj.gridLabSetCat.getSelected();
		var errinfo = "";
		var CatDr = rowData.ID;
		var TSCode = $('#txtTSCode').val();
		var TestSet = $('#txtTestSet').val();
		var Note = $('#txtNote').val();
		var IsActive = $('#chkActive').checkbox('getValue');
		if (!TSCode) {
			errinfo = errinfo + "检验医嘱代码不允许为空!<br>";
		}
		if (!TestSet) {
			errinfo = errinfo + "检验医嘱名称不允许为空!<br>";
		}
		if (!CatDr) {
			errinfo = errinfo + "分类不允许为空!<br>";
		}
		if (errinfo) {
			$.messager.alert("错误提示", errinfo, 'info');
			return;
		}
		IsActive = (IsActive==true? 1: 0);
		var IsSubItem = $('#chkSubItem').checkbox('getValue');
		var IsVirus = $('#chVirus').checkbox('getValue');
		IsSubItem = (IsSubItem==true? 1: 0);
		IsVirus = (IsVirus==true? 1: 0);
		
		var inputStr = obj.RecRowID2;
		inputStr = inputStr + '^' + TSCode;
		inputStr = inputStr + '^' + TestSet;
		inputStr = inputStr + '^' + CatDr;
		inputStr = inputStr + '^' + IsActive;
		inputStr = inputStr + '^' + Note;
		inputStr = inputStr + '^' + IsSubItem;
		inputStr = inputStr + '^' + IsVirus;
		var flg = $m({
			ClassName:"DHCHAI.DP.LabTestSet",
			MethodName:"Update",
			InStr:inputStr,
			aSeparete:"^"
		},false);
		if (parseInt(flg) <= 0) {
			if (parseInt(flg) == '-100') {
				$.messager.alert("错误提示", "代码重复!" , 'info');
				return;
			}else{
				$.messager.alert("错误提示", "保存失败" , 'info');
				return;
				}
		}else {
			$HUI.dialog('#winEdit_two').close();
			$.messager.popover({msg: '保存成功！',type:'success',timeout: 1000});
			obj.RecRowID2 = "";
			originalData["gridLabTestSet"] =""
			obj.gridLabTestSetLoad();//刷新当前页
		}
	}
	//删除
	obj.btnDelete_click = function(){
		if (obj.RecRowID==""){
			$.messager.alert("提示", "选中数据记录,再点击删除!", 'info');
			return;
		}
		
		$.messager.confirm("删除", "是否删除选中数据记录?", function (r) {
			if (r) {				
				var flg = $m({
					ClassName:"DHCHAI.DP.LabTestSetCat",
					MethodName:"DeleteById",
					Id:obj.RecRowID
				},false);
				if (parseInt(flg) < 0) {
					if (parseInt(flg)=='-777') {
						$.messager.alert('错误提示','当前无删除权限，请启用删除权限后再删除记录!','info');
						return;
					}else {
						$.messager.alert('删除失败!','info');
						return;
					}				
				} else {
					$.messager.popover({msg: '删除成功！',type:'success',timeout: 1000});
					obj.RecRowID = "";
					originalData["gridLabSetCat"] =""
					obj.gridLabSetCatLoad();//刷新当前页
				}
			} 
		});
	}
	obj.btnDelete_two_click = function(){
		if (obj.RecRowID2==""){
			$.messager.alert("提示", "选中数据记录,再点击删除!", 'info');
			return;
		}
		$.messager.confirm("删除", "是否删除选中数据记录?", function (r) {
			if (r) {				
				var flg = $m({
					ClassName:"DHCHAI.DP.LabTestSet",
					MethodName:"DeleteById",
					Id:obj.RecRowID2
				},false);
				if (parseInt(flg) < 0) {
					if (parseInt(flg)=='-777') {
						$.messager.alert('错误提示','当前无删除权限，请启用删除权限后再删除记录!','info');
						return;
					}else {
						$.messager.alert('删除失败!','info');
						return;
					}				
				} else {
					$.messager.popover({msg: '删除成功！',type:'success',timeout: 1000});
					obj.RecRowID2 = "";
					originalData["gridLabTestSet"] =""
					obj.gridLabTestSetLoad();//刷新当前页
				}
			} 
		});
	}
	//窗体
	obj.SetDiaglog=function (){
		$('#winEdit').dialog({
			title: '检验医嘱分类编辑',
			iconCls:'icon-w-paper',
			modal: true,
			isTopZindex:false,//true,
			buttons:[{
				text:'保存',
				handler:function(){
					obj.btnSave_click();
				}
			},{
				text:'关闭',
				handler:function(){
					$HUI.dialog('#winEdit').close();
				}
			}]
		});
	}
	//窗体
	obj.SetDiaglog_two=function (){
		$('#winEdit_two').dialog({
			title: '检验医嘱编辑',
			iconCls:'icon-w-paper',
			modal: true,
			isTopZindex:false,//true,
			buttons:[{
				text:'保存',
				handler:function(){
					obj.btnSave_two_click();
				}
			},{
				text:'关闭',
				handler:function(){
					$HUI.dialog('#winEdit_two').close();
				}
			}]
		});
	}
	
	//配置窗体-初始化
	obj.InitDialog= function(rd){
		if(rd){
			obj.RecRowID=rd["ID"];
			var BTCode = rd["BTCode"];
			var BTDesc = rd["BTDesc"];
			$('#txtBTCode').val(BTCode);
			$('#txtBTDesc').val(BTDesc);
		}else{
			obj.RecRowID = "";
			$('#txtBTCode').val('');
			$('#txtBTDesc').val('');
		}
		$('#winEdit').show();
		obj.SetDiaglog();
	}
	
	obj.InitDialog_two= function(rd){
		var rowData = obj.gridLabSetCat.getSelected();
		if (!rowData) {
				$.messager.alert('错误提示','分类不允许为空!<br>','info');
				return
			}
			if(rd){
				obj.RecRowID2=rd["ID"];
				var TSCode = rd["TSCode"];
				var TestSet = rd["TestSet"];
				var Note = rd["Note"];
				var IsActive = rd["IsActDesc"];
				IsActive = (IsActive=='是'? true: false);
				var IsSubItem = rd["IsSubItem"];
				IsSubItem = (IsSubItem=='1'? true: false);
				var IsVirus = rd["IsVirus"];
				IsVirus = (IsVirus=='1'? true: false);
				$('#txtTSCode').val(TSCode);
				$('#txtTestSet').val(TestSet);
				$('#txtNote').val(Note);
				$('#chkActive').checkbox('setValue',IsActive);
				$('#chkSubItem').checkbox('setValue',IsSubItem);
				$('#chVirus').checkbox('setValue',IsVirus);
				
				
			}else{
				obj.RecRowID2 = "";
				$('#txtTSCode').val('');
				$('#txtTestSet').val('');
				$('#txtNote').val('');
				$('#chkActive').checkbox('setValue','');
				$('#chkSubItem').checkbox('setValue',false);
				$('#chVirus').checkbox('setValue',false);
			}
			$('#winEdit_two').show();
			obj.SetDiaglog_two();
		}
	obj.gridLabSetCatLoad = function(){
		//$("#gridLabAntiCat").datagrid("loading");	
		$cm ({
		    ClassName:"DHCHAI.DPS.LabTestSetSrv",
			QueryName:"QryLabSetCat",		
	    	page:1,
			rows:9999
		},function(rs){
			$('#gridLabSetCat').datagrid('loadData', rs);					
		});
    }
}
