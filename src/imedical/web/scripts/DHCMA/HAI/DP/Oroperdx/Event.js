//页面Event
function InitOROperDxWinEvent(obj){
	//检索框
	$('#searchbox').searchbox({ 
		searcher:function(value,name){
			searchText($("#gridOROperDxMap"),value);
		}	
	});
	//
	/**$('#searchbox_two').searchbox({ 
		searcher:function(value,name){
			searchText($("#gridOROperDx"),value);
		}	
	});**/
	//编辑窗体
	obj.SetDiaglog2=function(){
		$('#winEdit2').dialog({
			title: '手术对照项目编辑',
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
			title: '手术项目编辑',
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
    	obj.gridOROperDxMapLoad();
		//全部
		$('#btnAll').on('click', function(){
			$("#gridOROperDxMap").datagrid("loading");	
			$cm ({
			    ClassName:"DHCHAI.DPS.OROperDxMapSrv",
				QueryName:"QryOROperDxMap",
				aFlg:"",		
		    	page:1,
				rows:200
			},function(rs){
				$('#gridOROperDxMap').datagrid({loadFilter:pagerFilter}).datagrid('loadData', rs);					
			});
		});
		//未对照
		$('#btnPend').on('click', function(){
			$("#gridOROperDxMap").datagrid("loading");	
			$cm ({
			    ClassName:"DHCHAI.DPS.OROperDxMapSrv",
				QueryName:"QryOROperDxMap",
				aFlg:"0",		
		    	page:1,
				rows:200
			},function(rs){
				$('#gridOROperDxMap').datagrid({loadFilter:pagerFilter}).datagrid('loadData', rs);					
			});
		});
		//已对照
		$('#btnFin').on('click', function(){
			$("#gridOROperDxMap").datagrid("loading");	
			$cm ({
			    ClassName:"DHCHAI.DPS.OROperDxMapSrv",
				QueryName:"QryOROperDxMap",
				aFlg:"1",		
		    	page:1,
				rows:200
			},function(rs){
				$('#gridOROperDxMap').datagrid({loadFilter:pagerFilter}).datagrid('loadData', rs);					
			});
		});
		//自动匹配
		$('#btnSyn').on('click', function(){
			var flg = $m({
				ClassName:'DHCHAI.DPS.OROperDxMapSrv',
				MethodName:'SynMapRule',
				aCatDesc:"手术项目"
			},false);
			if (parseInt(flg) <= 0) {
				$.messager.alert("错误提示", "没有可匹配项或匹配失败" , 'info');	
				return;	
			}else {
				$.messager.popover({msg: '成功匹配'+flg+'条!',type:'success',timeout: 1000});
				//obj.gridOROperDxMap.reload() ;//刷新当前页
				obj.gridOROperDxMapLoad();
			}
		});
		//编辑
		$('#btnEdit').on('click', function(){
			var rd=obj.gridOROperDxMap.getSelected();
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
		$('#search').searchbox({ 
			searcher:function(value,name){ 
				obj.gridOROperDxMap.load({
					ClassName:'DHCHAI.DPS.OROperDxMapSrv',
					QueryName:'QryOROperDxMap'
				});
			}	
		});
		$('#btnsearch_two').searchbox({
		    	searcher:function(value,name){
		    	obj.gridOROperDx.load({
					ClassName:"DHCHAI.DPS.MROBSItemSrv",
					QueryName:"QryMROBSItem"
				});
		    },
		});
		
		$('#btnAdd_one').on('click', function(){
			obj.InitDialog2();
		});
		$('#btnEdit_one').on('click', function(){
			var rd=obj.gridOROperDx.getSelected();
			obj.InitDialog2(rd);
		});
		$('#btnDelete_one').on('click', function(){
			obj.btnDelete_oneclick();
		});
  }
  //双击编辑事件
	obj.gridOROperDxMap_onDbselect = function(rd){
		obj.InitDialog(rd);
	}
	//选择
	obj.gridOROperDxMap_onSelect = function (){
		var rowData = obj.gridOROperDxMap.getSelected();
		
		if (rowData["ID"] == obj.RecRowID) {
			obj.RecRowID="";
			$("#btnAdd").linkbutton("disable");
			$("#btnEdit").linkbutton("disable");
			$("#btnDelete").linkbutton("disable");
			obj.gridOROperDxMap.clearSelections();
		} else {
			obj.RecRowID = rowData["ID"];
			$("#btnAdd").linkbutton("enable");
			$("#btnEdit").linkbutton("enable");
			$("#btnDelete").linkbutton("enable");
		}
	}
	//双击诊断项目字典
	obj.gridOROperDx_onDbselect = function(rd){
		obj.InitDialog2(rd);
	}
	
	//单击事件
	obj.gridOROperDx_onSelect = function (rd,yindex){
		var yindex=yindex-1;
		if (rd["ID"] == obj.RecRowID2) {
			obj.RecRowID2="";
			$("#btnAdd_one").linkbutton("enable");
			$("#btnEdit_one").linkbutton("disable");
			$("#btnDelete_one").linkbutton("disable");
			obj.gridOROperDx.clearSelections();
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
		var OperDesc  = rd["BTOperDesc"];
        var MapOperDr = rd["BTMapOperDr"];
		var MapNote   = $('#txtMapNote').val();
		var MapSCode = rd["BTSCode"];
		var IsActive  =$("#chkMapActive").checkbox('getValue')? '1':'0';
	    var ActUser   = $.LOGON.USERDESC;
	    
		var InputStr = ID;
		InputStr += "^" + OperDesc;
		InputStr += "^" + MapOperDr;  
		InputStr += "^" + MapNote;  
		InputStr += "^" + MapSCode;
		InputStr += "^" + IsActive;
		InputStr += "^" + '';
		InputStr += "^" + '';
		InputStr += "^" + ActUser;
		var flg = $m({
				ClassName:"DHCHAI.DP.OROperDxMap",
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
				//obj.gridOROperDxMap.reload() ;//刷新当前页
				obj.gridOROperDxMapLoad();
		}
	}
	//对照
	obj.btnAdd_click = function(){
		var Maprd = obj.gridOROperDxMap.getSelected();
		var Itemrd = obj.gridOROperDx.getSelected();
		var MapID  = (Maprd ? Maprd["ID"] : '');
		var ItemID = (Itemrd ? Itemrd["ID"] : '');
		if ((MapID == "")||(ItemID == "")) {
			$.messager.alert("错误提示",'设置对照关系需同时选择手术项目字典及对照项目!','info');
			return;	
		}else{
			var flg = $m({
				ClassName:"DHCHAI.DPS.OROperDxMapSrv",
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
				//obj.gridOROperDxMap.reload() ;//刷新当前页
				obj.gridOROperDxMapLoad();
			}
		}
	}
	//撤销
	obj.btnDelete_click = function(){
		var rd = obj.gridOROperDxMap.getSelected();
		var ID  = (rd ? rd["ID"] : '');
		if (rd["MapItemID"]=="") {
			$.messager.alert("错误提示",'没有对照关系，不可撤销!','info');
			return;	
		}else{
			$.messager.confirm("撤销", "确认是否撤销对照关系？", function (r) {
			if (r) {				
				var flg = $m({
					ClassName:"DHCHAI.DP.OROperDxMap",
					MethodName:"DeleteMapById",
					Id:ID
				},false);
				if (parseInt(flg) < 0) {
						$.messager.alert('撤销失败','info');	
						return;				
				} else {
					$.messager.popover({msg: '撤销成功！',type:'success',timeout: 1000});
					//obj.gridOROperDxMap.reload() ;//刷新当前页
					obj.gridOROperDxMapLoad();
				}
			} 
		});
		}
	}
	//保存手术项目字典
	obj.btnSave2_click = function(){
		var errinfo = "";
		var rd = obj.layer2_rd;
		var ID = (rd ? rd["ID"] : '');
		var BTCode = $('#txtBTOperCode').val();
		var BTDesc = $('#txtBTOperDesc').val();
		var BTOperIncDr = $('#cboBTOperIncDr').combobox('getValue');
		var BTOperInc = $('#cboBTOperIncDr').combobox('getText');
		var IsActive  =$("#chkActive").checkbox('getValue')? '1':'0';

		var InputStr = ID;
		InputStr += "^" + BTCode;
		InputStr += "^" + BTDesc;
		InputStr += "^" + BTOperIncDr;
		InputStr += "^" + IsActive;
		
		if (BTCode == '') {
			errinfo = errinfo + "手术编码不允许为空！<br>";
		}
		if (BTDesc == '') {
			errinfo = errinfo + "手术名称不允许为空!<br>";
		}	
		if (errinfo) {
			$.messager.alert("错误提示", errinfo, 'info');
			return;
		}
		var flg = $m({
				ClassName:"DHCHAI.DP.OROperDx",
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
				obj.gridOROperDx.reload() ;//刷新当前页
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
					ClassName:"DHCHAI.DP.OROperDx",
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
					obj.gridOROperDx.reload() ;//刷新当前页
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
			var BTCode = rd["BTOperCode"];
			var BTDesc = rd["BTOperDesc"];
			
			var BTOperIncDr=rd["IncDr"];
			var BTOperInc=rd["IncDesc"];
			var IsActive = rd["BTIsActive"];
			IsActive = (IsActive=="1"? true: false)
			$('#txtBTOperCode').val(BTCode);
			$('#txtBTOperDesc').val(BTDesc);
			$('#cboBTOperIncDr').combobox('setValue',BTOperIncDr);
			$('#cboBTOperIncDr').combobox('setText',BTOperInc);
			$('#chkActive').checkbox('setValue',IsActive);
		}else{
			obj.RecRowID2="";
			obj.layer2_rd=""
			$('#txtBTOperCode').val('');
			$('#txtBTOperDesc').val('');
			$('#cboBTOperIncDr').combobox('setValue','');
			$('#chkActive').checkbox('setValue',false);
		}
			$('#winEdit').show();
			obj.SetDiaglog();
	}
	obj.gridOROperDxMapLoad = function(){
		$("#gridOROperDxMap").datagrid("loading");	
		$cm ({
		    ClassName:"DHCHAI.DPS.OROperDxMapSrv",
			QueryName:"QryOROperDxMap",		
	    	page:1,
			rows:200
		},function(rs){
			$('#gridOROperDxMap').datagrid({loadFilter:pagerFilter}).datagrid('loadData', rs);					
		});
    }
}