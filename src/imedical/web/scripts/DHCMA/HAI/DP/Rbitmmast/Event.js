//页面Event
function InitRBItmMastWinEvent(obj){
	//检索框
	$('#searchbox').searchbox({ 
		searcher:function(value,name){
			searchText($("#gridRBItmMastMap"),value);
		}	
	});
	//编辑窗体
	obj.SetDiaglog2=function(){
		$('#winEdit2').dialog({
			title: '检查项目对照编辑',
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
	//按钮初始化
    obj.LoadEvent = function(args){ 
    	obj.gridRBItmMastMapLoad();
		//全部
		$('#btnAll').on('click', function(){
			$("#gridRBItmMastMap").datagrid("loading");	
			$cm ({
			    ClassName:"DHCHAI.DPS.RBItmMastMapSrv",
				QueryName:"QryRBItmMastMap",
				aFlg:"",		
		    	page:1,
				rows:200
			},function(rs){
				$('#gridRBItmMastMap').datagrid({loadFilter:pagerFilter}).datagrid('loadData', rs);					
			});
		});
		//未对照
		$('#btnPend').on('click', function(){
			$("#gridRBItmMastMap").datagrid("loading");	
			$cm ({
			    ClassName:"DHCHAI.DPS.RBItmMastMapSrv",
				QueryName:"QryRBItmMastMap",
				aFlg:"0",		
		    	page:1,
				rows:200
			},function(rs){
				$('#gridRBItmMastMap').datagrid({loadFilter:pagerFilter}).datagrid('loadData', rs);					
			});
		});
		//已对照
		$('#btnFin').on('click', function(){
			$("#gridRBItmMastMap").datagrid("loading");	
			$cm ({
			    ClassName:"DHCHAI.DPS.RBItmMastMapSrv",
				QueryName:"QryRBItmMastMap",
				aFlg:"1",		
		    	page:1,
				rows:200
			},function(rs){
				$('#gridRBItmMastMap').datagrid({loadFilter:pagerFilter}).datagrid('loadData', rs);					
			});
		});
		//自动匹配
		$('#btnSyn').on('click', function(){
			var flg = $m({
				ClassName:'DHCHAI.DPS.RBItmMastMapSrv',
				MethodName:'SynMapRule',
				aCatDesc:"检查项目"
			},false);
			if (parseInt(flg) <= 0) {
				$.messager.alert("错误提示", "没有可匹配项或匹配失败" , 'info');	
				return;	
			}else {
				$.messager.popover({msg: '成功匹配'+flg+'条!',type:'success',timeout: 1000});
				//obj.gridRBItmMastMap.reload() ;//刷新当前页
				obj.gridRBItmMastMapLoad();
			}
		});
		//编辑
		$('#btnEdit').on('click', function(){
			var rd=obj.gridRBItmMastMap.getSelected();
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
		/*$('#btnsearch_two').searchbox({
		    	searcher:function(value,name){
		    	obj.gridRBItmMast.load({
					ClassName:"DHCHAI.DPS.MROBSItemSrv",
					QueryName:"QryMROBSItem"
				});
		    },
		});*/
		
		$('#btnAdd_one').on('click', function(){
			obj.InitDialog2();
		});
		$('#btnEdit_one').on('click', function(){
			var rd=obj.gridRBItmMast.getSelected();
			obj.InitDialog2(rd);
		});
		$('#btnDelete_one').on('click', function(){
			obj.btnDelete_oneclick();
		});
  }
	//编辑窗体2
	obj.SetDiaglog=function(){
		$('#winEdit').dialog({
			title: '检查项目编辑',
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
	//双击编辑事件
	obj.gridRBItmMastMap_onDbselect = function(rd){
		obj.InitDialog(rd);
	}
	//选择
	obj.gridRBItmMastMap_onSelect = function (){
		var rowData = obj.gridRBItmMastMap.getSelected();
		
		if (rowData["ID"] == obj.RecRowID) {
			obj.RecRowID="";
			$("#btnAdd").linkbutton("disable");
			$("#btnEdit").linkbutton("disable");
			$("#btnDelete").linkbutton("disable");
			obj.gridRBItmMastMap.clearSelections();
		} else {
			obj.RecRowID = rowData["ID"];
			$("#btnAdd").linkbutton("enable");
			$("#btnEdit").linkbutton("enable");
			$("#btnDelete").linkbutton("enable");
		}
	}
	//双击检查项目字典
	obj.gridRBItmMast_onDbselect = function(rd){
		obj.InitDialog2(rd);
	}
	
	//单击事件
	obj.gridRBItmMast_onSelect = function (rd,yindex){
		var yindex=yindex-1;
		if (rd["ID"] == obj.RecRowID2) {
			obj.RecRowID2="";
			$("#btnAdd_one").linkbutton("enable");
			$("#btnEdit_one").linkbutton("disable");
			$("#btnDelete_one").linkbutton("disable");
			obj.gridRBItmMast.clearSelections();
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
		var CHKItem   = rd["BTMRCHKItem"];
		var MapItemDr = rd["MapItemDr"];
		var MapNote   = $('#txtMapNote').val();
		var MapSCode  = rd["BTSCode"]
		var IsActive  =$("#chkMapActive").checkbox('getValue')? '1':'0';
		var ActUser   = $.LOGON.USERDESC;
	
		var InputStr = ID;
		InputStr += "^" + CHKItem;
		InputStr += "^" + MapItemDr;  
		InputStr += "^" + MapNote;  
		InputStr += "^" + MapSCode;
		InputStr += "^" + IsActive;
		InputStr += "^";
		InputStr += "^";
		InputStr += "^" + ActUser;
		var flg = $m({
				ClassName:"DHCHAI.DP.RBItmMastMap",
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
				//obj.gridRBItmMastMap.reload() ;//刷新当前页
				obj.gridRBItmMastMapLoad();
		}
	}
	//对照
	obj.btnAdd_click = function(){
		var Maprd = obj.gridRBItmMastMap.getSelected();
		var Itemrd = obj.gridRBItmMast.getSelected();
		var MapID  = (Maprd ? Maprd["ID"] : '');
		var ItemID = (Itemrd ? Itemrd["ID"] : '');
		if ((MapID == "")||(ItemID == "")) {
			$.messager.alert("错误提示",'设置对照关系需同时选择检验项目字典及对照项目!','info');
			return;	
		}else{
			var flg = $m({
				ClassName:"DHCHAI.DPS.RBItmMastMapSrv",
				MethodName:"UpdateMap",
				ID:MapID,
				MapItemID:ItemID,
				UsersName:Maprd["ActUser"]
			},false);
			if (parseInt(flg) <= 0) {
				$.messager.alert("错误提示", "对照失败" , 'info');	
				return;		
			}else {
				$.messager.popover({msg: '对照成功',type:'success',timeout: 1000});
				//obj.gridRBItmMastMap.reload() ;//刷新当前页
				obj.gridRBItmMastMapLoad();
			}
		}
	}
	//撤销
	obj.btnDelete_click = function(){
		var rd = obj.gridRBItmMastMap.getSelected();
		var ID  = (rd ? rd["ID"] : '');
		if (rd["MapItemID"]=="") {
			$.messager.alert("错误提示",'没有对照关系，不可撤销!','info');
			return;	
		}else{
			$.messager.confirm("撤销", "确认是否撤销对照关系？", function (r) {
			if (r) {				
				var flg = $m({
					ClassName:"DHCHAI.DP.RBItmMastMap",
					MethodName:"DeleteMapById",
					Id:ID
				},false);
				if (parseInt(flg) < 0) {
						$.messager.alert('撤销失败','info');	
						return;				
				} else {
					$.messager.popover({msg: '撤销成功！',type:'success',timeout: 1000});
					//obj.gridRBItmMastMap.reload() ;//刷新当前页
					obj.gridRBItmMastMapLoad();
				}
			} 
		});
		}
	}
	//保存手术项目字典
	obj.btnSave2_click = function(){
		var errinfo='';
		var rd = obj.layer2_rd;
		var ID = (rd ? rd["ID"] : '');
		var BTCode = $('#txtBTCode').val();
		var BTCName = $('#txtBTCName').val(); 
		var IsActive = $("#chkActive").checkbox('getValue')? '1':'0'; 
	
		if (!BTCode) {
			errinfo = errinfo + "检查编码不允许为空!<br>";
		}	
		if (!BTCName) {
			errinfo = errinfo + "检查描述不允许为空!<br>";
		}	
		if (errinfo) {
			$.messager.alert("错误提示", errinfo, 'info');
			return;
		}
		var InputStr = ID;
		InputStr += "^" + BTCode;
		InputStr += "^" + BTCName;
		InputStr += "^" + IsActive;
		
		if (BTCode == '') {
			errinfo = errinfo + "检查编码不允许为空!<br>";
		}
		if (BTCName == '') {
			errinfo = errinfo + "检查描述不允许为空!<br>";
		}
		var flg = $m({
				ClassName:"DHCHAI.DP.RBItmMast",
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
				obj.gridRBItmMast.reload() ;//刷新当前页
			}
	}
	//删除分类
	obj.btnDelete_oneclick = function(){
		if (obj.RecRowID2==""){
			$.messager.alert("提示", "选中数据记录,再点击删除!", 'info');
			return;
		}
		$.messager.confirm("删除", "是否删除选中数据记录?", function (r) {				
			if (r) {				
				var flg = $m({
					ClassName:"DHCHAI.DP.RBItmMast",
					MethodName:"DeleteById",
					Id:obj.RecRowID2
				},false);
				if (parseInt(flg) < 0) {
					if (parseInt(flg)=='-777') {
						$.messager.alert("错误提示","-777：当前无删除权限，请启用删除权限后再删除记录!",'info');
					}else {
						$.messager.alert("错误提示","删除失败" + flg, 'info');
					}
					return;
				} else {
					$.messager.popover({msg: '删除成功!',type:'success',timeout: 1000});
					obj.RecRowID2 = "";
					obj.gridRBItmMast.reload() ;//刷新当前页
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
			var BTDesc = rd["BTCName"];
			var IsActive = rd["BTIsActive"];
			IsActive = (IsActive=="1"? true: false)
			$('#txtBTCode').val(BTCode);
			$('#txtBTCName').val(BTDesc);
			$('#chkActive').checkbox('setValue',IsActive);
		}else{
			obj.RecRowID2="";
			obj.layer2_rd=""
			$('#txtBTCode').val('');
			$('#txtBTCName').val('');
			$('#chkActive').checkbox('setValue',false);
		}
			$('#winEdit').show();
			obj.SetDiaglog();
	}
	obj.gridRBItmMastMapLoad = function(){
			$("#gridRBItmMastMap").datagrid("loading");	
			$cm ({
			    ClassName:"DHCHAI.DPS.RBItmMastMapSrv",
				QueryName:"QryRBItmMastMap",		
		    	page:1,
				rows:200
			},function(rs){
				$('#gridRBItmMastMap').datagrid({loadFilter:pagerFilter}).datagrid('loadData', rs);					
			});
	    }
}