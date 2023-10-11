//页面Event
function InitWinEvent(obj){
	//事件初始化
	obj.LoadEvent = function(args){
		obj.gridConfigLoad();
		
		$('#btnAdd').on('click', function(){
			obj.InitDialog();
		});
		$('#btnEdit').on('click', function(){
			var rd=obj.gridConfig.getSelected()
			obj.InitDialog(rd);
		});
		$('#btnDelete').on('click', function(){
			obj.btnDelete_click();
		});
		
		$('#winBtnEdit').on('click', function(){
			obj.Save();
		});
		$('#winBtnClose').on('click', function(){
			$HUI.dialog('#winEdit').close();
		});
		$('#searchbox').searchbox({ 
			searcher:function(value,name){
				searchText($("#gridConfig"),value);
			}	
		});
     }
	  //检索框
    $('#searchbox').searchbox({
        searcher: function (value, name) {
            searchText($("#gridConfig"), value);
        }
    });
    //双击编辑
	obj.gridConfig_onDbselect = function(rd){
		obj.InitDialog(rd);
	}
	//选择
	obj.gridConfig_onSelect = function (){
		var rowData = obj.gridConfig.getSelected();

		if (rowData["ID"] == obj.RecRowID) {
			obj.RecRowID="";
			$("#btnAdd").linkbutton("enable");
			$("#btnEdit").linkbutton("disable");
			$("#btnDelete").linkbutton("disable");
			obj.gridConfig.clearSelections();
		} else {
			obj.RecRowID = rowData["ID"];
			$("#btnAdd").linkbutton("disable");
			$("#btnEdit").linkbutton("enable");
			$("#btnDelete").linkbutton("enable");
		}
	}
	//核心方法-更新
	obj.Save = function(){
		var errinfo = "";
		var Code = $('#txtCode').val();
		var Desc = $('#txtDesc').val();
		var Value = $('#txtValue').val();
		var HospDr = $("#cboHospital").combobox('getValue');
		var Mod = $("#cboAddMod").combobox('getText');
		var Resume = $('#txtResume').val();
		var IndNo = $('#txtIndNo').val();
		var IsActive = $("#chkIsActive").checkbox('getValue');
		IsActive = (IsActive==true? 1 : 0);
	
		if (!Code) {
			errinfo = errinfo + "代码为空!<br>";
		}
		if (!Desc) {
			errinfo = errinfo + "描述为空!<br>";
		}
		if (!Value) {
			errinfo = errinfo + "配置值不允许为空!<br>";
		}
		if (!Mod){
			errinfo = errinfo + "所属模块不允许为空!<br>";
		}
		if (errinfo) {
			$.messager.alert("错误提示", errinfo, 'info');
			return ;
		}
		var InputStr=obj.RecRowID;
		InputStr += "^" + Code;
		InputStr += "^" + Desc;
		InputStr += "^" + Value;
		InputStr += "^" + HospDr;
		InputStr += "^" + IsActive;
		InputStr += "^" + Mod;
		InputStr += "^" + Resume;
		InputStr += "^" + IndNo;
		var flg = $m({
			ClassName:"DHCHAI.BT.Config",
			MethodName:"Update",
			aInputStr:InputStr,
		},false);
		if (parseInt(flg)> 0) {
			$HUI.dialog('#winEdit').close();
			$.messager.popover({msg: '保存成功！',type:'success',timeout: 1000});
			obj.RecRowID=flg;
			originalData["gridConfig"]="";
			obj.gridConfigLoad();
		}else if(parseInt(flg) == '-2'){
			$.messager.alert("错误提示", "代码重复!" , 'info');
		}else{
			$.messager.alert("错误提示", "新增失败!Error=" + flg, 'info');
		}
	}
	//核心方法-删除
	obj.btnDelete_click = function(){
		if (obj.RecRowID==""){
			$.messager.alert("提示", "请选中数据,再点击删除!", 'info');
			return;
		}
		$.messager.confirm("删除", "确认是否删除?", function (r) {
			if (r) {				
				var flg = $m({
					ClassName:"DHCHAI.BT.Config",
					MethodName:"DeleteById",
					aId:obj.RecRowID
				},false);
				
				if (flg == '0') {
					$.messager.popover({msg: '删除成功！',type:'success',timeout: 1000});
					obj.RecRowID = "";
					obj.gridConfigLoad(); //刷新当前页
				} else {
					if (parseInt(flg)=='-777') {
						$.messager.alert("提示","-777：当前无删除权限，请启用删除权限后再删除记录!",'info');
					}else {
						$.messager.alert("错误提示","删除失败!Error=" + flg, 'info');
					}
				}
			} 
		});
	}
	// 加载（前台）分页
	obj.gridConfigLoad = function(){
		var ModDesc=$('#cboModList').combobox('getText');
		
		originalData["gridConfig"]="";
		$cm ({
		    ClassName:"DHCHAI.BTS.ConfigSrv",
			QueryName:"QueryByCode",
			aCode:"",
			aDesc:"",
			aMod:ModDesc,		
	    	page:1,
			rows:9999
		},function(rs){
			$('#gridConfig').datagrid({loadFilter:pagerFilter}).datagrid('loadData', rs);
			if ($('#searchbox').searchbox('getValue')) {
				searchText($("#gridConfig"),$('#searchbox').searchbox('getValue'));
			}					
		});
    }
    //窗体-初始化
	obj.InitDialog= function(rd){
		if(rd){
			$('#txtCode').val(rd["BTCode"]).validatebox("validate");
			$('#txtDesc').val(rd["BTDesc"]).validatebox("validate");
			$('#txtValue').val(rd["Value"]).validatebox("validate");
			$('#cboHospital').combobox('setValue',rd["HospDr"]);
			$('#cboHospital').combobox('setText',rd["HospDesc"]);
			$('#chkIsActive').checkbox('setValue',(rd["IsActive"]=='1' ? true : false));
			$("#cboAddMod").combobox('setValue',rd["Mod"]);
			$("#cboAddMod").combobox('setText',rd["Mod"]);
			$('#txtResume').val(rd["Resume"]);
			$('#txtIndNo').val(rd["IndNo"]);
			
			obj.RecRowID=rd["ID"];
		}else{
			$('#txtCode').val('').validatebox("validate");
			$('#txtDesc').val('').validatebox("validate");
			$('#txtValue').val('').validatebox("validate");
			$('#cboHospital').combobox('setValue','');
			$('#chkIsActive').checkbox('setValue',false);
			$("#cboAddMod").combobox('setValue','');
			$('#txtResume').val('');
			$('#txtIndNo').val('');
			
			obj.RecRowID = "";
		}
		
		$('#winEdit').show();
		$('#winEdit').dialog({
			title: '系统参数设置',
			iconCls:'icon-w-paper',
			modal: true,
			isTopZindex:true
		});
	}
}
