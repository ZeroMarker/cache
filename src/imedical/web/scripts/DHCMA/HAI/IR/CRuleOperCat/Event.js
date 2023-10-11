//页面Event
function InitOROperCatWinEvent(obj){
	//按钮初始化
    obj.LoadEvent = function(args){
		var flag ="";		
		obj.LoadgridOROper();
		
		//新增
		$('#btnAdd').on('click', function(){
			obj.OperCat('');
		});
		//编辑
		$('#btnEdit').on('click', function(){
			var rd=obj.gridOperCat.getSelected();
			obj.OperCat(rd);
		});
		
		//删除
		$('#btnDelete').on('click', function(){
			obj.btnDelete_click();
		});
		
		$('#btnSave').on('click', function(){
	     	obj.btnSave_click();
	 	});
		$('#btnClose').on('click', function(){
		    $HUI.dialog('#OperCatEdit').close();
	    });		
		
		//分类
		$('#btnOper').on('click', function(){
			obj.UpdateOperCat(1);	
		});
		//撤销
		$('#btnCancle').on('click', function(){
			obj.DeleteOperCat(1);		
		});
		
		//全部
		$('#btnAll').on('click', function(){
			flag="";
			obj.gridOROperLoad();
		});
		//未分类
		$('#btnUnCat').on('click', function(){
			flag="0";
			obj.gridOROperLoad(flag);
		
		});
		//已分类
		$('#btnCat').on('click', function(){
			flag="1";
			obj.gridOROperLoad(flag);
	
		});
		//自动匹配
		$('#btnSyn').on('click', function(){
			var flg = $m({
				ClassName:'DHCHAI.IRS.CRuleOperCatSrv',
				MethodName:'SynOperAnaesCat'
			},false);
			obj.gridOROperLoad();
			if (parseInt(flg) <= 0) {
				$.messager.alert("错误提示", "没有可匹配项或匹配失败!" , 'info');		
			}else {
				$.messager.popover({msg: '成功匹配'+flg+'条!',type:'success',timeout: 1000});
			}
		});
		//导出
		$('#btnExport').on('click', function(){
			obj.ExportOperInfo(flag);	
		});

		$("#cboOperCatMap").combobox({
			onSelect: function (record) {
				obj.gridOROperLoad(flag);
			},onUnselect: function (record) {
				obj.gridOROperLoad(flag);
			}
		})
	}

    
	//导出
	obj.ExportOperInfo= function(aType,aFlag) {
		var rows = $m({
			ClassName:"DHCHAI.IRS.CRuleOperCatSrv",
			QueryName:"QryOperAnaes",
			ResultSetType:'array',
			aOperCat:$('#cboOperCatMap').combobox('getValue'),
			aAlias:$('#searchbox').searchbox('getValue'),
			aFlag:aFlag,
			aShowAll:0
		},false);
		if (!rows) return false;   
		var rowList = JSON.parse(rows);
		if (rowList.length>0) {
			$('#gridOROper').datagrid('toExcel', {
			    filename: '手术信息.xls',
			    rows: rowList,
			    worksheet: '手术信息',
			});		
		}else {
			$.messager.alert("确认", "无数据记录,不允许导出", 'info');
			return;
		}			
	}
	
	//分类对照
	obj.UpdateOperCat= function(aType) {
		var Catrd  = $("#gridOperCat").datagrid('getSelected');
		var Operrd = $("#gridOROper").datagrid('getChecked');
	
		var CatID  = (Catrd ? Catrd["ID"] : '');
		var OperIDs="";
		for (ind=0;ind<Operrd.length;ind++) {
			OperIDs +=Operrd[ind].OperID+","
		}
		
		if ((OperIDs == "")||(CatID == "")) {
			$.messager.alert("错误提示",'维护分类关系需同时选择手术分类及手术信息!','info');
			return;
		}else{
			var flg = $m({
				ClassName:'DHCHAI.IRS.CRuleOperCatSrv',
				MethodName:'UpdateCat',
				aIDs:OperIDs,
				aCatID:CatID,
				aType:aType,
				aIsAll:1
			},false);
			if (parseInt(flg) <= 0) {
				$.messager.alert("错误提示", "分类维护失败" , 'info');	
				return;	
			}else {
				$.messager.popover({msg: '分类维护成功',type:'success',timeout: 1000});
				$("#gridOROper").datagrid('reload');
			}
		}	
	}
	//撤销对照
	obj.DeleteOperCat= function(aType) {
		var Catrd  = $("#gridOperCat").datagrid('getSelected');
		var Operrd = $("#gridOROper").datagrid('getChecked');
		
		var CatID  = (Catrd ? Catrd["ID"] : '');
		var OperIDs="";
		for (ind=0;ind<Operrd.length;ind++) {
			OperIDs +=Operrd[ind].OperID+","
		}
		
		var flg = $m({
			ClassName:'DHCHAI.IRS.CRuleOperCatSrv',
			MethodName:'DeleteCat',
			aIDs:OperIDs,
			aCatID:CatID,
			aType:aType,
			aIsAll:1
		},false);
	
		if (parseInt(flg) <=0) {
			if (parseInt(flg)==0) {
				$.messager.alert("提示", "无分类撤销" , 'info');	
				return;	
			}else {
				$.messager.alert("错误提示", "撤销分类维护失败" , 'info');	
				return;	
			}
		}else {
			$.messager.popover({msg: '撤销分类维护成功',type:'success',timeout: 1000});
			$("#gridOROper").datagrid('reload');
		}
	}
	
	
	//加载
	obj.gridOROperLoad = function(Flag) {
		$('#gridOROper').datagrid('load',{
			ClassName:"DHCHAI.IRS.CRuleOperCatSrv",
			QueryName:"QryOperAnaes",
			aOperCat:$('#cboOperCatMap').combobox('getValue'),
			aAlias:$('#searchbox').searchbox('getValue'),
			aFlag:Flag,
			aShowAll:0
		});
	}
	

	//检索
	$('#searchbox').searchbox({ 
		searcher:function(value,name){
			flag="";
			obj.gridOROperLoad();
		}	
	});
	
	$('#searchcat').searchbox({ 
		searcher:function(value,name){
			obj.gridOperCat.load({
				ClassName:"DHCHAI.IRS.CRuleOperCatSrv",
				QueryName:"QryOperCat",
				aAlias:value
			});
		}	
	});
		
	
	//窗体初始化
	obj.OperCatEdit =function() {
		$('#OperCatEdit').dialog({
			title: '手术分类维护',
			iconCls:"icon-w-paper",
			modal: true,
			isTopZindex:true
		});
	}
	
	//编辑窗体-初始化
	obj.OperCat = function(rd){
		if (rd){
			obj.RecRowID=rd["ID"];
			obj.RecKeyID=rd["KeyID"];
			var OperCat = rd["OperCat"];
			var OperType = rd["OperType"];
			var KeyType = rd["KeyType"];
			var IncludeKey = rd["IncludeKey"];
			var ExcludeKeys = rd["ExcludeKeys"];
		   
			$('#cboOperCat').combobox('setValue',obj.RecRowID);
			$('#cboOperCat').combobox('setText',OperCat);
			//$('#cboOperCat').combobox('disable');
			$('#cboOperType').combobox('setValue',OperType);
			$('#cboKeyType').combobox('setValue',KeyType);
			$('#txtIncludeKey').val(IncludeKey);
			$('#txtExcludeKeys').val(ExcludeKeys);

		}else {
			obj.RecRowID="";
			obj.RecKeyID="";
			$('#cboOperCat').combobox('enable');
			$('#cboOperCat').combobox('setValue',"");
			$('#cboOperType').combobox('setValue',"");
			$('#cboKeyType').combobox('setValue',"");
			$('#txtIncludeKey').val("");
			$('#txtExcludeKeys').val("");
		}
		$('#OperCatEdit').show();
		obj.OperCatEdit();
	}
	//双击编辑事件
	obj.gridOperCat_onDbselect = function(rd){
		obj.OperCat(rd);
	}
	
	//选择
	obj.gridOperCat_onSelect = function (){
		var rowData = obj.gridOperCat.getSelected();
		if (rowData["ID"] == obj.RecRowID) {
			obj.RecRowID="";
			$("#btnAdd").linkbutton("enable");
			$("#btnEdit").linkbutton("disable");
			$("#btnDelete").linkbutton("disable");
			obj.gridOperCat.clearSelections();
		} else {
			obj.RecRowID = rowData["ID"];
			$("#btnAdd").linkbutton("disable");
			$("#btnEdit").linkbutton("enable");
			$("#btnDelete").linkbutton("enable");
		}
	}
	
	//保存
	obj.btnSave_click = function(){
		var ID          = (obj.RecRowID ? obj.RecRowID: $('#cboOperCat').combobox('getValue'));		
		var OperCat     = $('#cboOperCat').combobox('getText');
		var OperType    = $('#cboOperType').combobox('getValue');
		var KeyType     = $('#cboKeyType').combobox('getValue');
		var IncludeKey  = $('#txtIncludeKey').val();
		var ExcludeKeys = $('#txtExcludeKeys').val();
	    var ActUser     = $.LOGON.USERID;
	     if (!OperCat) {
		    $.messager.alert("错误提示", "手术分类不允许为空！" , 'info');	
			return;	
	    }
	    if (!OperType) {
		    $.messager.alert("错误提示", "类别不允许为空！" , 'info');	
			return;	
	    }
	    if (!KeyType) {
		    $.messager.alert("错误提示", "关键词类型不允许为空！" , 'info');	
			return;	
	    }
	    if (!IncludeKey) {
		    $.messager.alert("错误提示", "包含词不允许为空！" , 'info');	
			return;	
	    }
		var InputStr = ID;
		InputStr += "^" + OperCat;
		InputStr += "^" + OperType;
		InputStr += "^" + 1;
		InputStr += "^" + '';
		InputStr += "^" + '';
		InputStr += "^" + ActUser;
		
		var flg = $m({
			ClassName:"DHCHAI.IR.CRuleOperCat",
			MethodName:"Update",
			aInputStr:InputStr,
			aSeparete:"^"
		},false);
		if (parseInt(flg) <= 0) {
			if (parseInt(flg)=='-2') {
				$.messager.alert("错误提示", "手术分类重复！" , 'info');	
				return;	
			}else {
				$.messager.alert("错误提示", "保存失败！" , 'info');	
				return;	
			}
		}else {
			var CatID=(ID ? ID : flg);
			var InputStr=CatID;
			InputStr += "^" + obj.RecKeyID;
			InputStr += "^" + KeyType;
			InputStr += "^" + IncludeKey;
			InputStr += "^" + ExcludeKeys;
			InputStr += "^" + 1;
			InputStr += "^" + '';
			InputStr += "^" + '';
			InputStr += "^" + ActUser;
			var ret = $m({
				ClassName:"DHCHAI.IR.CRuleOperCatKeys",
				MethodName:"Update",
				aInputStr:InputStr,
				aSeparete:"^"
			},false);
			if (parseInt(ret) <= 0) {
				if (parseInt(ret)=='-2') {
					$.messager.alert("错误提示", "手术分类包含词重复！" , 'info');	
					return;	
				}else {
					$.messager.alert("错误提示", "保存失败！" , 'info');	
					return;	
				}
			}else {
		
				$HUI.dialog('#OperCatEdit').close();
				$.messager.popover({msg: '保存成功！',type:'success',timeout: 1000});
				obj.RecRowID=flg;
				obj.gridOperCat.reload();
			}
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
					ClassName:"DHCHAI.IR.CRuleOperCat",
					MethodName:"DeleteById",
					aId:obj.RecRowID
				},false);
				if (parseInt(flg) < 0) {
					$.messager.alert('删除失败!','info');					
				} else {
					$.messager.popover({msg: '删除成功！',type:'success',timeout: 1000});
					obj.RecRowID = "";
					obj.gridOperCat.reload();
				}
			} 
		});
	}

	
}