//页面Event
function InitDictionaryWinEvent(obj){
	//检索框
	$('#searchbox').searchbox({ 
		searcher:function(value,name){
			obj.gridMRICDDxMap.reload();
			searchText($("#gridMRICDDxMap"),value);
		}	
	});	
	/**
	$('#searchbox_two').searchbox({ 
		searcher:function(value,name){
			searchText($("#gridMRICDDx"),value);
		}	
	});	**/
	//编辑窗体
	obj.SetDiaglog2=function(){
		$('#winEdit2').dialog({
			title: '诊断字典对照项目编辑',
			iconCls:"icon-w-paper",
			modal: true,
			isTopZindex:false,
			buttons:[{
				text:'保存',
				handler:function(){
					obj.btnSave_click();
				}
			},{
				text:'关闭',
				handler:function(){
					$HUI.dialog('#winEdit2').close();
				}
			}]
		});
	}
	
	//编辑窗体2
	obj.SetDiaglog=function(){
		$('#winEdit').dialog({
			title: '诊断项目编辑',
			iconCls:"icon-w-paper",
			modal: true,
			isTopZindex:false,
			buttons:[{
				text:'保存',
				handler:function(){
					obj.btnSave2_click();
				}
			},{
				text:'关闭',
				handler:function(){
					$HUI.dialog('#winEdit').close();
				}
			}]
		});
	}
	//按钮初始化
    obj.LoadEvent = function(args){ 
    	obj.gridMRICDDxMapLoad();
		//全部
		$('#btnAll').on('click', function(){
			$("#gridMRICDDxMap").datagrid("loading");	
			$cm ({
			    ClassName:"DHCHAI.DPS.MRICDDxMapSrv",
				QueryName:"QryMRICDDxMap",
				aFlg:"",		
		    	page:1,
				rows:200
			},function(rs){
				$('#gridMRICDDxMap').datagrid({loadFilter:pagerFilter}).datagrid('loadData', rs);					
			});
		});
		//未对照
		$('#btnPend').on('click', function(){
			$("#gridMRICDDxMap").datagrid("loading");	
			$cm ({
			    ClassName:"DHCHAI.DPS.MRICDDxMapSrv",
				QueryName:"QryMRICDDxMap",
				aFlg:"0",		
		    	page:1,
				rows:200
			},function(rs){
				$('#gridMRICDDxMap').datagrid({loadFilter:pagerFilter}).datagrid('loadData', rs);					
			});
		});
		//已对照
		$('#btnFin').on('click', function(){
			$("#gridMRICDDxMap").datagrid("loading");	
			$cm ({
			    ClassName:"DHCHAI.DPS.MRICDDxMapSrv",
				QueryName:"QryMRICDDxMap",
				aFlg:"1",		
		    	page:1,
				rows:200
			},function(rs){
				$('#gridMRICDDxMap').datagrid({loadFilter:pagerFilter}).datagrid('loadData', rs);					
			});
		});
		//自动匹配
		$('#btnSyn').on('click', function(){
			var flg = $m({
				ClassName:'DHCHAI.DPS.MRICDDxMapSrv',
				MethodName:'SynMapRule',
				aCatDesc:"诊断项目",
				},false);
			if (parseInt(flg) <= 0) {
				$.messager.alert("错误提示", "没有可匹配项或匹配失败" , 'info');		
			}else {
				$.messager.popover({msg: '成功匹配'+flg+'条!',type:'success',timeout: 1000});
				//obj.gridMRICDDxMap.reload() ;//刷新当前页
				obj.gridMRICDDxMapLoad();
			}
		});
		//编辑
		$('#btnEdit').on('click', function(){
			var rd=obj.gridMRICDDxMap.getSelected();
			obj.InitDialog(rd);
		});
		//对照
		$('#btnAdd').on('click', function(){
			obj.btnAdd_click();
		});
		//撤销
		$('#btnDelete').on('click', function(){
			obj.btnDelete_click();
		});
		/**$('#search').searchbox({ 
			searcher:function(value,name){ 
				obj.gridMRICDDxMap.load({
					ClassName:'DHCHAI.DPS.MRICDDxMapSrv',
					QueryName:'QryMRICDDxMap'
				});
			}	
		});
		$('#btnsearch_two').searchbox({
		    	searcher:function(value,name){
		    	obj.gridMRICDDx.load({
					ClassName:"DHCHAI.DPS.MROBSItemSrv",
					QueryName:"QryMROBSItem"
				});
		    },
		});**/
		
		$('#btnAdd_one').on('click', function(){
			obj.InitDialog2();
		});
		$('#btnEdit_one').on('click', function(){
			var rd=obj.gridMRICDDx.getSelected();
			obj.InitDialog2(rd);
		});
		$('#btnDelete_one').on('click', function(){
			obj.btnDelete_oneclick();
		});
  }
  //双击编辑事件
	obj.gridMRICDDxMap_onDbselect = function(rd){
		obj.InitDialog(rd);
	}
	//选择
	obj.gridMRICDDxMap_onSelect = function (){
		var rowData = obj.gridMRICDDxMap.getSelected();
		
		if (rowData["ID"] == obj.RecRowID) {
			obj.RecRowID="";
			$("#btnAdd").linkbutton("disable");
			$("#btnEdit").linkbutton("disable");
			$("#btnDelete").linkbutton("disable");
			obj.gridMRICDDxMap.clearSelections();
		} else {
			obj.RecRowID = rowData["ID"];
			$("#btnAdd").linkbutton("enable");
			$("#btnEdit").linkbutton("enable");
			$("#btnDelete").linkbutton("enable");
		}
	}
	//双击诊断项目字典
	obj.gridMRICDDx_onDbselect = function(rd){
		obj.InitDialog2(rd);
	}
	
	//单击事件
	obj.gridMRICDDx_onSelect = function (rd,yindex){
		var yindex=yindex-1;
		if (rd["ID"] == obj.RecRowID2) {
			obj.RecRowID2="";
			$("#btnAdd_one").linkbutton("enable");
			$("#btnEdit_one").linkbutton("disable");
			$("#btnDelete_one").linkbutton("disable");
			obj.gridMRICDDx.clearSelections();
		} else {
			obj.RecRowID2 = rd["ID"];
			$("#btnAdd_one").linkbutton("disable");
			$("#btnEdit_one").linkbutton("enable");
			$("#btnDelete_one").linkbutton("enable");
		}
	}
	//保存
	obj.btnSave_click = function(){
		var rd = obj.layer_rd;
		var ID = (rd ? rd["ID"] : '');
		var DiagDesc  = rd["BTDiagDesc"];
        var MapItemDr = rd["MapItemDr"];
		var MapNote   = $('#txtMapNote').val();
		var MapSCode = rd["BTSCode"];
		var IsActive  =$("#chkMapActive").checkbox('getValue')? '1':'0';
	    var ActUser   = session['LOGON.GROUPDESC'];
	    
		var InputStr = ID;
		InputStr += "^" + DiagDesc;
		InputStr += "^" + MapItemDr;  
		InputStr += "^" + MapNote;  
		InputStr += "^" + MapSCode;
		InputStr += "^" + IsActive;
		InputStr += "^" + '';
		InputStr += "^" + '';
		InputStr += "^" + ActUser;
		var flg = $m({
				ClassName:"DHCHAI.DP.MRICDDxMap",
				MethodName:"Update",
				InStr:InputStr,
				aSeparete:"^"
			},false);
		if (parseInt(flg) <= 0) {
				$.messager.alert("错误提示", "保存失败" , 'info');	
				return;	
			}else {
				$HUI.dialog('#winEdit2').close();
				$.messager.popover({msg: '保存成功！',type:'success',timeout: 1000});
				obj.RecRowID=flg;
				//obj.gridMRICDDxMap.reload() ;//刷新当前页
				obj.gridMRICDDxMapLoad();
			}
	}
	//对照
	obj.btnAdd_click = function(){
		if($("#btnAdd").hasClass("l-btn-disabled")) return;
		var Maprd = obj.gridMRICDDxMap.getSelected();
		var Itemrd = obj.gridMRICDDx.getSelected();
		var MapID  = (Maprd ? Maprd["ID"] : '');
		var ItemID = (Itemrd ? Itemrd["ID"] : '');
		if ((MapID == "")||(ItemID == "")) {
			$.messager.alert("错误提示",'设置对照关系需同时选择诊断项目字典及对照项目!','info');
			return;	
		}else{
			var flg = $m({
				ClassName:"DHCHAI.DPS.MRICDDxMapSrv",
				MethodName:"UpdateMap",
				ID:MapID,
				ICDDxID:ItemID,
				UsersName:Maprd["ActUser"]
			},false);
			if (parseInt(flg) <= 0) {
				$.messager.alert("错误提示", "对照失败" , 'info');	
				return;		
			}else {
				$.messager.popover({msg: '对照成功',type:'success',timeout: 1000});
				//obj.gridMRICDDxMap.reload() ;//刷新当前页
				obj.gridMRICDDxMapLoad();
			}
		}
	}
	//撤销
	obj.btnDelete_click = function(){
		if($("#btnDelete").hasClass("l-btn-disabled")) return;
		var rd = obj.gridMRICDDxMap.getSelected();
		var ID  = (rd ? rd["ID"] : '');
		if (rd["MapItemID"]=="") {
			$.messager.alert("错误提示",'没有对照关系，不可撤销!','info');
			return;	
		}else{
			$.messager.confirm("撤销", "确认是否撤销对照关系？", function (r) {
			if (r) {				
				var flg = $m({
					ClassName:"DHCHAI.DP.MRICDDxMap",
					MethodName:"DeleteMapById",
					Id:ID
				},false);
				if (parseInt(flg) < 0) {
						$.messager.alert('撤销失败','info');	
						return;				
				} else {
					$.messager.popover({msg: '撤销成功！',type:'success',timeout: 1000});
					//obj.gridMRICDDxMap.reload() ;//刷新当前页
					obj.gridMRICDDxMapLoad();
				}
			} 
		});
		}
	}
	//保存诊断项目字典
	obj.btnSave2_click = function(){
		var errinfo = "";
		var rd = obj.layer2_rd;
		var ID = (rd ? rd["ID"] : '');
		var BTCode = $('#txtBTCode').val();
		var BTDesc = $('#txtBTDesc').val();
		var IsActive  =$("#chkActive").checkbox('getValue')? '1':'0';

		var InputStr = ID;
		InputStr += "^" + BTCode;
		InputStr += "^" + BTDesc;
		InputStr += "^" + IsActive;
		
		if (!BTCode) {
			errinfo = errinfo + "代码不允许为空!<br>";
		}
		if (!BTDesc) {
			errinfo = errinfo + "名称不允许为空!<br>";
		}
		if (errinfo) {
			$.messager.alert("错误提示", errinfo, 'info');
			return;
		}
		var flg = $m({
				ClassName:"DHCHAI.DP.MRICDDx",
				MethodName:"Update",
				InStr:InputStr,
				aSeparete:"^"
			},false);
		if (parseInt(flg) <= 0) {
			if(parseInt(flg)=='-100'){
				$.messager.alert("错误提示", "代码、名称重复!" , 'info');
			}else{
				$.messager.alert("错误提示", "保存失败" , 'info');	
				return;	}
			}else {
				$HUI.dialog('#winEdit').close();
				$.messager.popover({msg: '保存成功！',type:'success',timeout: 1000});
				obj.RecRowID=flg;
				obj.gridMRICDDx.reload() ;//刷新当前页
			}
	}
	//删除分类
	obj.btnDelete_oneclick = function(){
		var rd = obj.gridMRICDDx.getSelected();
		var ID  = (rd ? rd["ID"] : '');
		if (ID==""){
			$.messager.alert("提示", "选中数据记录,再点击删除!", 'info');
			return;
		}
		$.messager.confirm("删除", "是否删除选中数据记录?", function (r) {				
			if (r) {				
				var flg = $m({
					ClassName:"DHCHAI.DP.MRICDDx",
					MethodName:"DeleteById",
					Id:ID
				},false);
				if (parseInt(flg) < 0) {
					if (parseInt(flg)=='-777') {
						$.messager.alert("错误提示","诊断字典-777：当前无删除权限，请启用删除权限后再删除记录!",'info');
					}else {
						$.messager.alert("错误提示","删除失败" + flg, 'info');
					}
					return;
				} else {
					$.messager.popover({msg: '删除成功!',type:'success',timeout: 1000});
					obj.RecRowID2 = "";
					obj.gridMRICDDx.reload() ;//刷新当前页
				}
			}
		});
	}
	obj.InitDialog= function(rd){
		if(rd){
			obj.RecRowID=rd["ID"];
			obj.layer_rd=rd
			var MapNote = rd["BTMapNote"];
			var IsActive = rd["BTIsActive"];
			IsActive = (IsActive=="1"? true: false)
			$('#txtMapNote').val(MapNote);
			$('#chkMapActive').checkbox('setValue',IsActive);
		}else{
			obj.RecRowID="";
			obj.layer_rd=""
			$('#txtMapNote').val('');
			$('#chkMapActive').checkbox('setValue',false);
		}
			$('#winEdit2').show();
			obj.SetDiaglog2();
	}
	obj.InitDialog2= function(rd){
		if(rd){
			obj.RecRowID2=rd["ID"];
			obj.layer2_rd=rd
			var BTCode = rd["BTCode"];
			var BTDesc = rd["BTDesc"];
			var IsActive = rd["BTIsActive"];
			IsActive = (IsActive=="1"? true: false)
			$('#txtBTCode').val(BTCode);
			$('#txtBTDesc').val(BTDesc);
			$('#chkActive').checkbox('setValue',IsActive);
		}else{
			obj.RecRowID2="";
			obj.layer2_rd=""
			$('#txtBTCode').val('');
			$('#txtBTDesc').val('');
			$('#chkActive').checkbox('setValue',false);
		}
			$('#winEdit').show();
			obj.SetDiaglog();
	}
	obj.gridMRICDDxMapLoad = function(){
		$("#gridMRICDDxMap").datagrid("loading");	
		$cm ({
		    ClassName:"DHCHAI.DPS.MRICDDxMapSrv",
			QueryName:"QryMRICDDxMap",		
	    	page:1,
			rows:99999
		},function(rs){
			$('#gridMRICDDxMap').datagrid({loadFilter:pagerFilter}).datagrid('loadData', rs);					
		});
    }
}