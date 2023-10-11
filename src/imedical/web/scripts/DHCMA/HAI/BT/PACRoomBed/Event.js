//页面Event
function InitPACRoomBedWinEvent(obj){	
	//检索框
	$('#search_one').searchbox({ 
		searcher:function(value,name){
			searchText($("#gridPACWard"),value);
		}	
	});	
	//检索框
	$('#btnsearch_two').searchbox({ 
		searcher:function(value,name){
			searchText($("#gridRoom"),value);
		}	
	});	
	//检索框
	$('#search_three').searchbox({ 
		searcher:function(value,name){
			searchText($("#gridBed"),value);
		}	
	});	
    
	obj.LoadEvent = function(args){ 	    
	    obj.gridPACWardLoad();
	    obj.gridRoomLoad();
	    obj.gridBedLoad();
	    //保存
     	$('#btnSave_two').on('click', function(){
	     	obj.btnSave_two_click();
     	});
		$('#btnSave_three').on('click', function(){
	     	obj.btnSave_three_click();
     	});
		//关闭
		$('#btnClose_two').on('click', function(){
	     	$HUI.dialog('#RoomEdit').close();
     	});
     	$('#btnClose_three').on('click', function(){
	     	$HUI.dialog('#BedEdit').close();
     	});
	    //添加
		$('#btnAdd_two').on('click', function(){
			var rd = obj.gridPACWard.getSelected();
			var LocDr = (rd ? rd["ID"] : ''); // 病区主键
			if (rd["IsMainWard"]=="0"){
				var retval = $m({
					ClassName:"DHCHAI.BT.PACWard",
					MethodName:"Update",
					aInputStr:"^"+LocDr+"^^^^1^",
					aSeparete:"^"
				},false);
			}
			obj.layer_rd = '';
			obj.Layer_two();
		});
		//编辑
		$('#btnEdit_two').on('click', function(){
			var rowData = obj.gridRoom.getSelected();
			obj.layer_rd=rowData;
			obj.Layer_two(rowData);
		});
		$('#btnEdit_three').on('click', function(){
			var rowData = obj.gridBed.getSelected();
			obj.layer_rd=rowData;
			obj.Layer_three(rowData);
		});
		//删除
		$('#btnDelete_two').on('click', function(){
			var rowData = obj.gridRoom.getSelected();
			var rowDataID =rowData["ID"];
			$.messager.confirm("删除", "确定删除选中数据记录?", function (r) {				
				if (r) {				
					var flg = $m({
						ClassName:"DHCHAI.BT.PACRoom",
						MethodName:"DeleteById",
						aId:rowDataID
					},false);
					if (parseInt(flg)<0){
						if (parseInt(flg)=='-777') {
							$.messager.alert("提示","-777：当前无删除权限，请启用删除权限后再删除记录!",'info');
						}else {
							$.messager.alert("提示","删除失败!",'info');
						}
						return;
					} else {
						$.messager.popover({msg: '删除成功！',type:'success',timeout: 1000});
						originalData["gridRoom"]="";   //重新加载前，初始数据置空
						obj.gridRoomLoad();
					}
				} 
			});	
		});	
		//床位图
		$('#btnBuildWard').on('click', function(){
			var rowData = obj.gridPACWard.getSelected();
			if(rowData){
				InitBedChart(rowData,rowData["ID"],"","","","");
			}
		});
	}

	//窗体初始化-房间信息编辑
	obj.RoomEdit =function() {
		$('#RoomEdit').dialog({
			title: '房间列表编辑',
			iconCls:"icon-w-paper",
			modal: true,
			isTopZindex:true
		})
	},
	
	//窗体初始化-床位信息编辑
	obj.BedEdit =function() {
		$('#BedEdit').dialog({
			title: '床位列表编辑',
			iconCls:"icon-w-paper",
			modal: true,
			isTopZindex:true
		})
	},
	//*********************** 病区列表 stt ***********************	
	//单击选中事件：选择部位
	obj.gridPACWard_onSelect = function (){
		var rowData = obj.gridPACWard.getSelected();
		if (rowData["ID"] == obj.RecRowID) {
			$("#btnAdd_two").linkbutton("disable");
			$("#btnEdit_two").linkbutton("disable");
			$("#btnDelete_two").linkbutton("disable");
			$("#btnBuildWard").linkbutton("disable");
			obj.RecRowID="";
			obj.RoomType = "";
			obj.gridPACWard.clearSelections();
			obj.gridRoomLoad();
			obj.gridBedLoad(); 
		}else{
			obj.RecRowID = rowData["ID"];
			$("#btnAdd_two").linkbutton("enable");
			$("#btnEdit_two").linkbutton("disable");
			$("#btnDelete_two").linkbutton("disable");
			$("#btnBuildWard").linkbutton("enable");
			obj.gridRoomLoad();
			obj.gridBedLoad(); 
		}
	},
	//*********************** 病区列表 end ***********************
	
	//*********************** 房间列表 stt ***********************
	//保存
	obj.btnSave_two_click = function(){
		var errinfo="";
		rowData = obj.gridPACWard.getSelected();
		var rowDataID =rowData["ID"];
		var LocDr = (rowData ? rowData["ID"] : '');
		obj.RecRowID2 = rowDataID;
		var rdRoomDx = obj.layer_rd;
		var ID = (rdRoomDx ? rdRoomDx["ID"] : '');
		var RoomDesc = $('#txtRoomDesc').val();
		var RoomDescPos = $('#RoomDescPos').combobox('getValue');
		var RoomType = $('#RoomType').combobox('getValue');
		var PosTop = $('#txtPosTop').val();
		var PosLeft = $('#txtPosLeft').val();
		var PosWidth = $('#txtPosWidth').val();
		var PosHeight = $('#txtPosHeight').val();
		var PosRotate = $('#txtPosRotate').val();
		var LeftBedCnt = $('#txtLeftBedCnt').val();
		var RightBedCnt = $('#txtRightBedCnt').val();
		var BedWidth = $('#txtBedWidth').val();
		var BedHeight = $('#txtBedHeight').val();
		var PACWardDr = $('#cboPACWardDr').combobox('getValue');
		var RoomColor = $('#txtRoomColor').val();
		var RoomIcon = $('#txtRoomIcon').val();
		if (!RoomDesc) {
			errinfo = errinfo + "房间名称不允许为空!<br>";
		}
		if (!PACWardDr) {
			errinfo = errinfo + "分区号不允许为空!<br>";
		}
		if (errinfo) {
			$.messager.alert("错误提示", errinfo, 'info');
			return;
		}	
		var InputStr = ID;
		InputStr += "^" + LocDr;
		InputStr += "^" + RoomDesc;
		InputStr += "^" + RoomDescPos;
		InputStr += "^" + RoomType;
		InputStr += "^" + PosTop;
		InputStr += "^" + PosLeft;
		InputStr += "^" + PosWidth;
		InputStr += "^" + PosHeight;
		InputStr += "^" + PosRotate;
		InputStr += "^" + LeftBedCnt;
		InputStr += "^" + RightBedCnt;
		InputStr += "^" + BedWidth;
		InputStr += "^" + BedHeight;
		InputStr += "^" + PACWardDr;
		InputStr += "^" + RoomColor;
		InputStr += "^" + RoomIcon;
	
		var retval = $m({
			ClassName:"DHCHAI.BT.PACRoom",
			MethodName:"Update",
			aInputStr:InputStr,
			aSeparete:"^"
		},false);
		if (parseInt(retval) <= 0) {
			if (parseInt(retval) == 0) {
				$.messager.alert("失败提示", "更新数据失败!返回码=" + retval, 'info');
			} else if (parseInt(retval) == -2) {
				$.messager.alert("失败提示", "代码重复!" , 'info');
			} else {
				$.messager.alert("失败提示", "更新数据失败!返回码=" + retval, 'info');
			}
		} else {
			$HUI.dialog('#RoomEdit').close();
			$.messager.popover({msg: '保存成功！',type:'success',timeout: 1000});
			originalData["gridRoom"]="";   //重新加载前，初始数据置空
			obj.gridRoomLoad();//刷新当前页
		}
	},
	
	//单击选中事件：选择房间列表
	obj.gridRoom_onSelect = function (){
		var rowData = obj.gridRoom.getSelected();
		if (rowData["ID"] == obj.RecRowID2) {
			$("#btnAdd_two").linkbutton("enable");
			$("#btnEdit_two").linkbutton("disable");
			$("#btnDelete_two").linkbutton("disable");
			obj.RecRowID2="";
			obj.RoomType = "";
			obj.RoomRowData="";
			obj.gridBedLoad();
			obj.gridRoom.clearSelections();
		}else{
			obj.RecRowID2 = rowData["ID"];
			$("#btnAdd_two").linkbutton("disable");
			$("#btnEdit_two").linkbutton("enable");
			$("#btnDelete_two").linkbutton("enable");
			var rdRoom = obj.gridRoom.getSelected();
			obj.RoomType = rdRoom['RoomType'];
			obj.RoomRowData=rowData;
			obj.gridBedLoad();
		}	
	},

	//双击编辑事件
	obj.gridRoom_onDbselect = function(rd){
		obj.layer_rd=rd;
		obj.Layer_two(rd);
	},	
	
	//编辑窗体-初始化
	obj.Layer_two = function(rd){
		//分区号下拉框
		obj.cbokind2 = $HUI.combobox('#cboPACWardDr', {              
			url: $URL,
			editable: false,
			//multiple:true,  //多选
			mode: 'remote',
			valueField: 'ID',
			textField: 'SubNo',
			onBeforeLoad: function (param) {
				param.ClassName = 'DHCHAI.BTS.PACWardSrv';
				param.QueryName = 'QryWardSubNo';
				param.aLocID = obj.RecRowID,
				param.ResultSetType = 'array'
			}
		});
		if (rd){	
			var txtRoomDesc = rd["RoomDesc"];
			var RoomDescPos = rd["RoomDescPos"];
			var RoomType = rd["RoomTypeDr"];
			var txtPosTop = rd["PosTop"];
			var txtPosLeft = rd["PosLeft"];
			var txtPosWidth = rd["PosWidth"];
			var txtPosHeight = rd["PosHeight"];
			var txtPosRotate = rd["PosRotate"];
			var txtLeftBedCnt = rd["LeftBedCnt"];
			var txtRightBedCnt = rd["RightBedCnt"];
			var txtBedWidth = rd["BedWidth"];
			var txtBedHeight = rd["BedHeight"];
			var cboPACWardDr = rd["WardDr"];
			var txtRoomColor = rd["RoomColor"];
			var txtRoomIcon = rd["RoomIcon"];
			$('#txtRoomDesc').val(txtRoomDesc);
			$('#RoomDescPos').combobox('setValue',RoomDescPos);
			$('#RoomType').combobox('setValue',RoomType);
			$('#txtPosTop').val(txtPosTop);
			$('#txtPosLeft').val(txtPosLeft);
			$('#txtPosWidth').val(txtPosWidth);
			$('#txtPosHeight').val(txtPosHeight);
			$('#txtPosRotate').val(txtPosRotate);
			$('#txtLeftBedCnt').val(txtLeftBedCnt);
			$('#txtRightBedCnt').val(txtRightBedCnt);
			$('#txtBedWidth').val(txtBedWidth);
			$('#txtBedHeight').val(txtBedHeight);
			$('#cboPACWardDr').combobox('setValue',cboPACWardDr);
			$('#txtRoomColor').val(txtRoomColor);
			$('#txtRoomIcon').val(txtRoomIcon);
			$("#txtRoomDesc,#cboPACWardDr").validatebox({required:true});
		}else {
			obj.RecRowID2="";
			$('#txtRoomDesc').val("");
			$('#RoomDescPos').combobox('setValue','');
			$('#RoomType').combobox('setValue','');
			$('#txtPosTop').val("");
			$('#txtPosLeft').val("");
			$('#txtPosWidth').val("");
			$('#txtPosHeight').val("");
			$('#txtPosRotate').val("");
			$('#txtLeftBedCnt').val("");
			$('#txtRightBedCnt').val("");
			$('#txtBedWidth').val("");
			$('#txtBedHeight').val("");
			$('#cboPACWardDr').combobox('setValue','');
			$('#txtRoomColor').val("");
			$('#txtRoomIcon').val("");
			$("#txtRoomDesc,#cboPACWardDr").validatebox({required:true});
		}
		$('#RoomEdit').show();
		obj.RoomEdit();
	},
	//*********************** 房间列表 end ***********************
	
	//*********************** 床位列表 stt ***********************
	//保存
	obj.btnSave_three_click = function(){		
		var errinfo="";
		var rd = obj.layer_rd;	
		var rowDataID =rd["ID"];
		var ID = (rd ? rd["ID"] : '');
				
		var LocDr = rd["LocID"];
		var RoomDr = rd["RoomID"];
		var BedDesc = rd["BedDesc"];
		var ActUserDr = rd["ActUserDr"];
		var XCode = rd["XCode"];
		var IndNo = $('#txtIndNo').val();
		var IsActive = $('#chkActive').checkbox('getValue');
		var PFIsActive = (IsActive==1 ? '1':'0');
		if (!BedDesc) {
			errinfo = errinfo + "床位名称不允许为空!<br>";
		}
		if (errinfo) {
			$.messager.alert("错误提示", errinfo, 'info');
			return;
		}	
		var InputStr = ID;
		InputStr += "^" + LocDr;
		InputStr += "^" + BedDesc;
		InputStr += "^" + IndNo;
		InputStr += "^" + "";
		InputStr += "^" + RoomDr;
		InputStr += "^" + XCode;
		InputStr += "^" + PFIsActive;
		InputStr += "^" + '';
		InputStr += "^" + '';
		InputStr += "^" + ActUserDr;
		var retval = $m({
			ClassName:"DHCHAI.BT.PACBed",
			MethodName:"Update",
			aInputStr:InputStr,
			aSeparete:"^"
		},false);
		
		if (parseInt(retval) <= 0) {
			if (parseInt(retval) == 0) {
				$.messager.alert("失败提示", "保存失败!返回码=" + retval, 'info');
			} else if (parseInt(retval) == -2) {
				$.messager.alert("失败提示", "代码重复!" , 'info');
			} else {
				$.messager.alert("失败提示", "保存失败!返回码=" + retval, 'info');
			}
		} else {
			$HUI.dialog('#BedEdit').close();
			obj.RecRowID3="";
			$.messager.popover({msg: '保存成功！',type:'success',timeout: 1000});
			originalData["gridBed"]="";   //重新加载前，初始数据置空
			obj.gridBedLoad();//刷新当前页
		}
	},
	
	//单击选中事件：选择感染诊断部位
	obj.gridBed_onSelect = function (){
		var bedRowData = obj.gridBed.getSelected();
		if (bedRowData["ID"] == obj.RecRowID3) {
			$("#btnEdit_three").linkbutton("disable");
			obj.gridBed.clearSelections();
			obj.RecRowID3="";
			obj.BedRowData="";
			obj.gridBedLoad();
		}else{
			obj.RecRowID3 = bedRowData["ID"];
			obj.BedRowData=bedRowData;
			$("#btnEdit_three").linkbutton("enable");
		}	
	},

	//双击编辑事件
	obj.gridBed_onDbselect = function(rd){
		obj.layer_rd=rd;
		obj.Layer_three(rd);
	},	
	
	//信息编辑窗体-初始化
	obj.Layer_three = function(rd){
		if (rd){
			var txtIndNo = rd["IndNo"];
			var chkActive = rd["IsActive"];
			chkActive = (chkActive=="1"? true: false);
			$('#txtIndNo').val(txtIndNo);
			$('#chkActive').checkbox('setValue',chkActive);;
		}else {
			obj.RecRowID="";
			$('#txtIndNo').val("");
			$('#chkActive').checkbox('setValue',"");
		}
		$('#BedEdit').show();
		obj.BedEdit();
	},
	//*********************** 床位列表 end ***********************
	//关联
	obj.editor_edit = function(id,IsRoomBed){
		var errinfo="";
		if (IsRoomBed !="0" ) return;
		var LocDr = obj.RecRowID;
		var RoomDr = obj.RoomRowData["ID"];
		var RoomLeftCont = obj.RoomRowData["LeftBedCnt"];
		var RoomRightCont = obj.RoomRowData["RightBedCnt"];
		var RoomBedCont = obj.RoomRowData["ContBedCnt"];
		var BedID = id;
		if ( parseInt(RoomBedCont) >= (parseInt(RoomLeftCont)+parseInt(RoomRightCont)) ) {
			errinfo = errinfo + "已关联床位数不能超过该房间床位总数!";
		}
		if (errinfo != '') {
			$.messager.alert('info', errinfo);
			return;
		}
		var InputStr = BedID;
		InputStr += "^" + LocDr;
		InputStr += "^" + RoomDr;							
		var flg = $m({
			ClassName:"DHCHAI.BT.PACBed",
			MethodName:"UpdateRoom",
			aInputStr:InputStr,
			aSeparete:"^"
		},false);
		if (parseInt(flg)<0){
			$.messager.alert("","保存失败!提示码=" + flg,'info');
		} else {
			$.messager.popover({msg: '保存成功！',type:'success',timeout: 1000});
			originalData["gridBed"]="";   //重新加载前，初始数据置空
			obj.gridBedLoad() ;//刷新当前页
		}
	}

	//取消关联
	obj.editor_canceledit = function(id){
		BedID = id;
		$.messager.confirm("信息", "确认取消房间与床位的关联?", function (r) {				
		if (r) {				
			var flg = $m({
			ClassName:"DHCHAI.BT.PACBed",
			MethodName:"DeleteRoom",
			aId:BedID
			},false);
			if (parseInt(flg)<0){
				$.messager.alert("失败提示","取消失败!提示码=" + flg,'info');
			} else {
				$.messager.popover({msg: '取消成功！',type:'success',timeout: 1000});
				originalData["gridBed"]="";   //重新加载前，初始数据置空
				obj.gridBedLoad() ;//刷新当前页
			}
		} 
		});	
	}
	
	obj.gridPACWardLoad = function(){
		$("#gridPACWard").datagrid("loading");	
		$cm ({
		   	ClassName:"DHCHAI.BTS.PACWardSrv",
			QueryName:"QryPACWard",		
	    	page:1,
			rows:9999
		},function(rs){
			$('#gridPACWard').datagrid({loadFilter:pagerFilter}).datagrid('loadData', rs);				
		});
    }
   	
   	//加载房间列表
	obj.gridRoomLoad= function () {
		var aCatID = "";
		if (obj.RecRowID) {
			aCatID =obj.RecRowID;
		}
		$("#gridRoom").datagrid("loading");	
		originalData["gridRoom"]="";
		$cm ({
			ClassName:"DHCHAI.BTS.PACRoomBedSrv",
			QueryName:"QryPACRoomSrv",
			aLocID:aCatID,		
	    	page:1,
			rows:9999
		},function(rs){
			$('#gridRoom').datagrid({loadFilter:pagerFilter}).datagrid('loadData', rs);
		});	
		obj.RecRowID2 = "";
		obj.RoomRowData="";
	}
	
	//加载房间列表
	obj.gridBedLoad= function () {
		var aCatID = "";
		if (obj.RecRowID) {
			aCatID =obj.RecRowID;
			$("#btnEdit_three").linkbutton("enable");
		}else{
			$("#btnEdit_three").linkbutton("disable");
		}
		$cm ({
		    ClassName:"DHCHAI.BTS.PACRoomBedSrv",
			QueryName:"QryPACBedSrv",
			aLocID:obj.RecRowID,
			aRoomID:obj.RecRowID2,		
	    	page:1,
			rows:9999
		},function(rs){	
			$('#gridBed').datagrid({loadFilter:pagerFilter}).datagrid('loadData', rs);			
		});	
	}
}