//页面Event
function InitMROBSItemMapWinEvent(obj){
	//检索框
	$('#searchbox').searchbox({ 
		searcher:function(value,name){
			searchText($("#gridMROBSItemMap"),value);
		}	
	});	
	$('#searchbox_two').searchbox({ 
		searcher:function(value,name){
			searchText($("#gridMROBSItem"),value);
		}	
	});
	//编辑窗体
	obj.SetDiaglog=function(){
		$('#winEdit').dialog({
			title: '护理项目对照编辑',
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
					$HUI.dialog('#winEdit').close();
				}
			}]
		});
	}
	//按钮初始化
    obj.LoadEvent = function(args){ 
   		obj.gridMROBSItemMapLoad();
		//全部
		$('#btnAll').on('click', function(){
			$("#gridMROBSItemMap").datagrid("loading");	
			$cm ({
			    ClassName:"DHCHAI.DPS.MROBSItemMapSrv",
				QueryName:"QryMROBSItemMap",
				aFlg:"",		
		    	page:1,
				rows:200
			},function(rs){
				$('#gridMROBSItemMap').datagrid({loadFilter:pagerFilter}).datagrid('loadData', rs);					
			});
		});
		//未对照
		$('#btnPend').on('click', function(){
			$("#gridMROBSItemMap").datagrid("loading");	
			$cm ({
			    ClassName:"DHCHAI.DPS.MROBSItemMapSrv",
				QueryName:"QryMROBSItemMap",
				aFlg:"0",		
		    	page:1,
				rows:200
			},function(rs){
				$('#gridMROBSItemMap').datagrid({loadFilter:pagerFilter}).datagrid('loadData', rs);					
			});
		});
		//已对照
		$('#btnFin').on('click', function(){
			$("#gridMROBSItemMap").datagrid("loading");	
			$cm ({
			    ClassName:"DHCHAI.DPS.MROBSItemMapSrv",
				QueryName:"QryMROBSItemMap",
				aFlg:"1",		
		    	page:1,
				rows:200
			},function(rs){
				$('#gridMROBSItemMap').datagrid({loadFilter:pagerFilter}).datagrid('loadData', rs);					
			});
		});
		//自动匹配
		$('#btnSyn').on('click', function(){
			var flg = $m({
				ClassName:'DHCHAI.DPS.MROBSItemMapSrv',
				MethodName:'SynMapRule',
				aCatDesc:"护理项目",
				},false);
			if (parseInt(flg) <= 0) {
				$.messager.alert("错误提示", "没有可匹配项或匹配失败" , 'info');		
			}else {
				$.messager.popover({msg: '成功匹配'+flg+'条!',type:'success',timeout: 1000});
				//obj.gridMROBSItemMap.reload() ;//刷新当前页
				 obj.gridMROBSItemMapLoad();
			}
		});
		//编辑
		$('#btnEdit').on('click', function(){
			var rd=obj.gridMROBSItemMap.getSelected();
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
				obj.gridMROBSItemMap.load({
					ClassName:'DHCHAI.DPS.MROBSItemMapSrv',
					QueryName:'QryMROBSItemMap'
				});
			}	
		});
		$('#btnsearch_two').searchbox({
		    	searcher:function(value,name){
		    	obj.gridMROBSItem.load({
					ClassName:"DHCHAI.DPS.MROBSItemSrv",
					QueryName:"QryMROBSItem"
				});
		    },
		});**/
  }
  
  //双击编辑事件
	obj.gridMROBSItemMap_onDbselect = function(rd){
		obj.InitDialog(rd);
	}
	//选择
	obj.gridMROBSItemMap_onSelect = function (){
		var rowData = obj.gridMROBSItemMap.getSelected();
		
		if (rowData["ID"] == obj.RecRowID) {
			obj.RecRowID="";
			$("#btnAdd").linkbutton("disable");
			$("#btnEdit").linkbutton("disable");
			$("#btnDelete").linkbutton("disable");
			obj.gridMROBSItemMap.clearSelections();
		} else {
			obj.RecRowID = rowData["ID"];
			$("#btnAdd").linkbutton("enable");
			$("#btnEdit").linkbutton("enable");
			$("#btnDelete").linkbutton("enable");
		}
	}
	//保存
	obj.btnSave_click = function(){
		var rd = obj.layer_rd;
		var ID = (rd ? rd["ID"] : '');
		var BTItemDesc  = rd["BTItemDesc"];
        var MapItemDr = rd["MapItemDr"];
		var BTMapNote   = $('#txtMapNote').val();
		var BTSCode = rd["BTSCode"];
		var IsActive  =$("#chkIsActive").checkbox('getValue')? '1':'0';
	    var ActUser   = session['LOGON.GROUPDESC'];
	    
		var InputStr = ID;
		InputStr += "^" + BTItemDesc;
		InputStr += "^" + MapItemDr;
		InputStr += "^" + BTMapNote;
		InputStr += "^" + BTSCode;
		InputStr += "^" + IsActive;
		InputStr += "^" + '';
		InputStr += "^" + '';
		InputStr += "^" + ActUser;
		var flg = $m({
				ClassName:"DHCHAI.DP.MROBSItemMap",
				MethodName:"Update",
				InStr:InputStr,
				aSeparete:"^"
			},false);
		if (parseInt(flg) <= 0) {
				$.messager.alert("错误提示", "保存失败" , 'info');	
				return;	
			}else {
				$HUI.dialog('#winEdit').close();
				$.messager.popover({msg: '保存成功！',type:'success',timeout: 1000});
				obj.RecRowID=flg;
				//obj.gridMROBSItemMap.reload() ;//刷新当前页
				obj.gridMROBSItemMapLoad();
			}
	}
	//对照
	obj.btnAdd_click = function(){
		if($("#btnAdd").hasClass("l-btn-disabled")) return;
		var Maprd = obj.gridMROBSItemMap.getSelected();
		var Itemrd = obj.gridMROBSItem.getSelected();
		var MapID  = (Maprd ? Maprd["ID"] : '');
		var ItemID = (Itemrd ? Itemrd["ID"] : '');
		if ((MapID == "")||(ItemID == "")) {
			$.messager.alert("错误提示",'设置对照关系需同时选择护理项目字典及对照项目!','info');
			return;	
		}else{
			var flg = $m({
				ClassName:"DHCHAI.DPS.MROBSItemMapSrv",
				MethodName:"UpdateMap",
				ID:MapID,
				ItemID:ItemID,
				UserName:Maprd["ActUser"]
			},false);
			if (parseInt(flg) <= 0) {
				$.messager.alert("错误提示", "对照失败" , 'info');	
				return;		
			}else {
				$.messager.popover({msg: '对照成功',type:'success',timeout: 1000});
				//obj.gridMROBSItemMap.reload() ;//刷新当前页
				 obj.gridMROBSItemMapLoad();
			}
		}
	}
	//撤销
	obj.btnDelete_click = function(){
		if($("#btnDelete").hasClass("l-btn-disabled")) return;
		var rd = obj.gridMROBSItemMap.getSelected();
		var ID  = (rd ? rd["ID"] : '');
		if (rd["MapItemID"]=="") {
			$.messager.alert("错误提示",'没有对照关系，不可撤销!','info');
			return;	
		}else{
			$.messager.confirm("撤销", "确认是否撤销对照关系？", function (r) {
			if (r) {				
				var flg = $m({
					ClassName:"DHCHAI.DP.MROBSItemMap",
					MethodName:"DeleteMapById",
					Id:ID
				},false);
				if (parseInt(flg) < 0) {
						$.messager.alert('撤销失败','info');	
						return;				
				} else {
					$.messager.popover({msg: '撤销成功！',type:'success',timeout: 1000});
					//obj.gridMROBSItemMap.reload() ;//刷新当前页
					 obj.gridMROBSItemMapLoad();
				}
			} 
		});
		}
	}
	obj.InitDialog= function(rd){
		if(rd){
			obj.RecRowID=rd["ID"];
			obj.layer_rd=rd
			var MapNote = rd["MapNote"];
			var IsActive = rd["BTIsActive"];
			IsActive = (IsActive=="1"? true: false)
			$('#txtMapNote').val(MapNote);
			$('#chkIsActive').checkbox('setValue',IsActive);
		}else{
			obj.RecRowID="";
			obj.layer_rd=""
			$('#txtMapNote').val('');
			$('#chkIsActive').checkbox('setValue',false);
		}
			$('#winEdit').show();
			obj.SetDiaglog();
	}
	obj.gridMROBSItemMapLoad = function(){
		$("#gridMROBSItemMap").datagrid("loading");	
		$cm ({
		    ClassName:"DHCHAI.DPS.MROBSItemMapSrv",
			QueryName:"QryMROBSItemMap",		
	    	page:1,
			rows:200
		},function(rs){
			$('#gridMROBSItemMap').datagrid({loadFilter:pagerFilter}).datagrid('loadData', rs);					
		});
    }
}