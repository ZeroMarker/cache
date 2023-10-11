//页面Event
function InitLabBacteriaWinEvent(obj){
	//按钮初始化
	obj.LoadEvent = function(args){ 
		$('#gridLabBacteria').datagrid('loadData',{ 'total':'0',rows:[] });  //初始加载显示记录为0
		obj.gridLabBacteriaLoad();
		$('#btnAdd').on('click', function(){
			obj.InitDialog();
		});
		$('#btnEdit').on('click', function(){
			var rd=obj.gridLabBacteria.getSelected();
			obj.InitDialog(rd);
		});
		$('#btnDelete').on('click', function(){
			obj.btnDelete_click();
		});
		$('#search').searchbox({ 
		searcher:function(value,name){
			searchText($("#gridLabBacteria"),value);
			}	
		});	
     }
     //双击编辑事件
	obj.gridLabBacteria_onDbselect = function(rd){
		obj.InitDialog(rd);
	}
	//选择
	obj.gridLabBacteria_onSelect = function (){
		var rowData = obj.gridLabBacteria.getSelected();
		if (rowData["ID"] == obj.RecRowID) {
			obj.RecRowID="";
			$("#btnAdd").linkbutton("enable");
			$("#btnEdit").linkbutton("disable");
			$("#btnDelete").linkbutton("disable");
			obj.gridLabBacteria.clearSelections();
		} else {
			obj.RecRowID = rowData["ID"];
			$("#btnAdd").linkbutton("disable");
			$("#btnEdit").linkbutton("enable");
			$("#btnDelete").linkbutton("enable");
		}
	}
	//保存
	obj.btnSave_click = function(){
		var errinfo = "";
		var BacCode = $('#txtBacCode').val();
		var BacDesc = $('#txtBacDesc').val();
		var BacName = $('#txtBacName').val();
		var BacTypeDr=$('#cboBacType').combobox('getValue');
		var BacCatDr=$('#cboBacCat').combobox('getValue');
		var WCode = $('#txtWCode').val();
		var IsActive = $('#chkActive').checkbox('getValue');
		var IsCommon = $('#chkIsCommon').checkbox('getValue');
		var IsSkinBact = $('#chkIsSkinBact').checkbox('getValue');
		
		if (!BacCode) {
			errinfo = errinfo + "代码不允许为空!<br>";
		}
		if (!BacDesc) {
			errinfo = errinfo + "名称不允许为空!<br>";
		}
		if (!BacName) {
			errinfo = errinfo + "英文名不允许为空!<br>";
		}
		if (errinfo) {
			$.messager.alert("错误提示", errinfo, 'info');
			return;
		}
		IsActive = (IsActive==true? 1: 0);
		IsCommon = (IsCommon==true? 1: 0);
		IsSkinBact = (IsSkinBact==true? 1: 0);
		var inputStr = obj.RecRowID;
		inputStr = inputStr + '^' + BacCode;
		inputStr = inputStr + '^' + BacDesc;
		inputStr = inputStr + '^' + BacName;
		inputStr = inputStr + "^" + BacTypeDr;
		inputStr = inputStr + "^" + BacCatDr;
		inputStr = inputStr + "^" + WCode;
		inputStr = inputStr + "^" + IsActive;
		inputStr = inputStr + "^" + "";
		inputStr = inputStr + "^" + "";
		inputStr = inputStr + "^" + IsCommon;
		inputStr = inputStr + "^" + IsSkinBact;
		
		var flg = $m({
			ClassName:"DHCHAI.DP.LabBacteria",
			MethodName:"Update",
			InStr:inputStr,
			aSeparete:"^"
		},false);
		if (parseInt(flg) <= 0) {
			if (parseInt(flg) == '-100') {
				$.messager.alert("错误提示", "细菌代码重复!" , 'info');
				return;
			}else{
				$.messager.alert("错误提示", "保存失败" , 'info');
				return;
			}
		}else {
			$HUI.dialog('#winEdit').close();
			$.messager.popover({msg: '保存成功！',type:'success',timeout: 1000});
			obj.RecRowID = flg;
			obj.gridLabBacteriaLoad();//刷新当前页
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
					ClassName:"DHCHAI.DP.LabBacteria",
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
					obj.gridLabBacteriaLoad();//刷新当前页
				}
			} 
		});
	}
	obj.SetDiaglog=function (){
		$('#winEdit').dialog({
			title: '细菌编辑',
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
	//配置窗体-初始化
	obj.InitDialog= function(rd){
		if(rd){
			obj.RecRowID=rd["ID"];
			var WCode = rd["WCode"];
			var BacCode = rd["BacCode"];
			var BacDesc = rd["BacDesc"];
			var BacName = rd["BacName"];
			var TypeDesc = rd["TypeDesc"];
			var TypeID = rd["TypeID"];
			var CatDesc = rd["CatDesc"];
			var CatID = rd["CatID"];
			var IsActive = rd["IsActDesc"];
			var IsCommon = rd["IsCommon"];
			var IsSkinBact = rd["IsSkinBact"];
			IsActive = (IsActive=='是'? true: false);
			$('#txtBacCode').val(BacCode);
			$('#txtBacDesc').val(BacDesc);
			$('#txtBacName').val(BacName);
			$('#cboBacType').combobox('setValue',TypeID)
			$('#cboBacCat').combobox('setValue',CatID)
			$('#txtWCode').val(WCode);
			$('#chkIsCommon').checkbox('setValue',IsCommon);
			$('#chkActive').checkbox('setValue',IsActive);
			$('#chkIsSkinBact').checkbox('setValue',IsSkinBact);
			
		}else{
			obj.RecRowID = "";
			$('#txtBacCode').val("");
			$('#txtBacDesc').val("");
			$('#txtBacName').val("");
			$('#cboBacType').combobox('setValue',"")
			$('#cboBacCat').combobox('setValue',"")
			$('#txtWCode').val("");
			$('#chkIsCommon').checkbox('setValue',false);
			$('#chkActive').checkbox('setValue',false);
			$('#chkIsSkinBact').checkbox('setValue',false);
		}
		$('#winEdit').show();
		obj.SetDiaglog();
	}
	obj.gridLabBacteriaLoad = function(){
		$('.searchbox-text').val("");
		//$("#gridLabAntiCat").datagrid("loading");	
		originalData["gridLabBacteria"]="";
		$cm ({
		    ClassName:"DHCHAI.DPS.LabBactSrv",
			QueryName:"QryLabBacteria",		
	    	page:1,
			rows:9999
		},function(rs){
			$('#gridLabBacteria').datagrid({loadFilter:pagerFilter}).datagrid('loadData', rs);					
		});
    }
}