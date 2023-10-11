//页面Event
function InitBaseMappingWinEvent(obj){
	//检索框
	$('#searchbox').searchbox({ 
		searcher:function(value,name){
			searchText($("#gridBaseMapping"),value);
		}	
	});
	$('#searchbox2').searchbox({ 
		searcher:function(value,name){
			//searchText($("#gridBaseRange"),value);
			var rowData = obj.gridBaseMapping.getSelected();
			var aType="";
			if (rowData) aType=rowData["Type"];
			obj.gridBaseRange.reload({
				ClassName:"DHCHAI.MAPS.CssMappingSrv",
				QueryName:"QryBaseRange",
				aType:aType,	
				aAlis:value
			});
		}	
	});
	$("#cboCat").combobox({
		onSelect:function(record){
			$cm ({
			    ClassName:"DHCHAI.MAPS.CssMappingSrv",
				QueryName:"QryBaseMapping",
				aType:record.xType,		
		    	page:1,
				rows:200
			},function(rs){
				$('#gridBaseMapping').datagrid({loadFilter:pagerFilter}).datagrid('loadData', rs);					
			});
			obj.gridBaseRange.reload({
				ClassName:"DHCHAI.MAPS.CssMappingSrv",
				QueryName:"QryBaseRange",	
				aType:record.xType
			});					 	 
		}	 	
	})
	//编辑窗体
	obj.SetDiaglog2=function(){
		$('#winEdit2').dialog({
			title: '值域字典对照编辑',
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
    	obj.gridBaseMappingLoad();
    	//增加
		$('#btnAdd').on('click', function(){
			obj.InitDialog();
		});
		//编辑
		$('#btnEdit').on('click', function(){
			var rd=obj.gridBaseMapping.getSelected();
			obj.InitDialog(rd);
		});
		//删除
		$('#btnDelete').on('click', function(){
			obj.btnDelete_click();
		});
		//未对照
		$('#btnNoMap').on('click', function(){
			obj.btnNoMap_click();
		});
		//未对照
		$('#btnAllMap').on('click', function(){
			obj.btnAllMap_click();
		});
		
		//对照
		$('#btnAddMap').on('click', function(){
			obj.btnAdd_click();
		});
		//撤销
		$('#btnDelMap').on('click', function(){
			obj.btnDeleteMap_click();
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
			var rd=obj.gridBaseRange.getSelected();
			obj.InitDialog2(rd);
		});
		$('#btnDelete_one').on('click', function(){
			obj.btnDelete_oneclick();
		});
  }
	//编辑窗体2
	obj.SetDiaglog=function(){
		$('#winEdit').dialog({
			title: '标准值域字典编辑',
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
	obj.gridBaseMapping_onDbselect = function(rd){
		obj.InitDialog(rd);
	}
	//选择
	obj.gridBaseMapping_onSelect = function (){
		var rowData = obj.gridBaseMapping.getSelected();
		
		if (rowData["ID"] == obj.RecRowID) {
			obj.RecRowID="";
			$("#btnAdd").linkbutton("enable");
			$("#btnEdit").linkbutton("disable");
			$("#btnDelete").linkbutton("disable");
			$("#btnAddMap").linkbutton("disable");
			$("#btnNoMap").linkbutton("enable");
			$("#btnDelMap").linkbutton("disable");
			obj.gridBaseMapping.clearSelections();
		} else {  //选中
			obj.RecRowID = rowData["ID"];
			$("#btnAdd").linkbutton("disable");
			$("#btnEdit").linkbutton("enable");
			$("#btnDelete").linkbutton("enable");
			$("#btnAddMap").linkbutton("enable");
			$("#btnNoMap").linkbutton("enable");
			$("#btnDelMap").linkbutton("enable");
			obj.gridBaseRange.reload({
				ClassName:"DHCHAI.MAPS.CssMappingSrv",
				QueryName:"QryBaseRange",	
				aType:rowData["Type"]
			});
		}
	}
	//双击检查项目字典
	obj.gridBaseRange_onDbselect = function(rd){
		obj.InitDialog2(rd);
	}
	
	//单击事件
	obj.gridBaseRange_onSelect = function (rd,yindex){
		var yindex=yindex-1;
		if (rd["ID"] == obj.RecRowID2) {
			obj.RecRowID2="";
			$("#btnAdd_one").linkbutton("enable");
			$("#btnEdit_one").linkbutton("disable");
			$("#btnDelete_one").linkbutton("disable");
			obj.gridBaseRange.clearSelections();
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
		var RangeDr      = rd["RangeDr"];
		var txtBMType    = $('#txtBMType').val();
		var txtBMKeyVal  = $('#txtBMKeyVal').val();
		var txtBMKeyText = $('#txtBMKeyText').val();
		var IsActive     = $("#chkMapActive").checkbox('getValue')? '1':'0';
		var ActUserDr    = $.LOGON.USERID;
		
		var errinfo ="";
		if (!txtBMType) {
			errinfo = errinfo + "分类编码不允许为空!<br>";
		}	
		if (!txtBMKeyVal) {
			errinfo = errinfo + "唯一键值不允许为空!<br>";
		}
		if (!txtBMKeyText) {
			errinfo = errinfo + "键值描述不允许为空!<br>";
		}	
		if (errinfo) {
			$.messager.alert("错误提示", errinfo, 'info');
			return;
		}
	
		var InputStr = ID;
		InputStr += "^" + txtBMType;
		InputStr += "^" + txtBMKeyVal;  
		InputStr += "^" + txtBMKeyText;  
		InputStr += "^" + RangeDr;
		InputStr += "^" + IsActive;
		InputStr += "^";
		InputStr += "^";
		InputStr += "^" + ActUserDr;
		var flg = $m({
				ClassName:"DHCHAI.MAP.CssMapping",
				MethodName:"Update",
				InStr:InputStr,
				aSeparete:"^"
		},false);
		if (parseInt(flg) <= 0) {
			if(parseInt(flg)=='-100'){
				$.messager.alert("错误提示", "同分类的唯一键值不允许重复!" , 'info');
			}
			else
			{
				$.messager.alert("错误提示", "保存失败" , 'info');	
			}				
			return;	
		}else {
				$HUI.dialog('#winEdit2').close();
				$.messager.popover({msg: '保存成功！',type:'success',timeout: 1000});
				obj.RecRowID=flg;
				obj.gridBaseMappingLoad();
		}
	}
	//未对照
	obj.btnNoMap_click = function(){
		$cm ({
		    ClassName:"DHCHAI.MAPS.CssMappingSrv",
			QueryName:"QryBaseMapping",
			aType:"",
			aNoMapFlg:"1",		
	    	page:1,
			rows:200
		},function(rs){
			$('#gridBaseMapping').datagrid({loadFilter:pagerFilter}).datagrid('loadData', rs);					
		});
	}
	//全部
	obj.btnAllMap_click = function(){
		$cm ({
		    ClassName:"DHCHAI.MAPS.CssMappingSrv",
			QueryName:"QryBaseMapping",
			aType:"",
			aNoMapFlg:"",		
	    	page:1,
			rows:200
		},function(rs){
			$('#gridBaseMapping').datagrid({loadFilter:pagerFilter}).datagrid('loadData', rs);					
		});
	}
	//对照
	obj.btnAdd_click = function(){
		var Maprd = obj.gridBaseMapping.getSelected();
		var Rangerd = obj.gridBaseRange.getSelected();
		var MapID  = (Maprd ? Maprd["ID"] : '');
		var ItemID = (Rangerd ? Rangerd["ID"] : '');
		if ((MapID == "")||(ItemID == "")) {
			$.messager.alert("错误提示",'设置对照关系需同时选择基础字典及标准对照字典!','info');
			return;	
		}else{
			var flg = $m({
				ClassName:"DHCHAI.MAPS.CssMappingSrv",
				MethodName:"UpdateMap",
				ID:MapID,
				RangeID:ItemID,
				UserDr:$.LOGON.USERID
			},false);
			if (parseInt(flg) <= 0) {
				$.messager.alert("错误提示", "对照失败" , 'info');	
				return;		
			}else {
				$.messager.popover({msg: '对照成功',type:'success',timeout: 1000});
				$("#gridBaseMapping").datagrid("loading");	
				$cm ({
				    ClassName:"DHCHAI.MAPS.CssMappingSrv",
					QueryName:"QryBaseMapping",
					aType:Maprd["Type"],		
			    	page:1,
					rows:200
				},function(rs){
					$('#gridBaseMapping').datagrid({loadFilter:pagerFilter}).datagrid('loadData', rs);					
				});
			}
		}
	}
	//撤销
	obj.btnDeleteMap_click = function(){
		var rd = obj.gridBaseMapping.getSelected();
		var ID  = (rd ? rd["ID"] : '');
		if (rd["RangeDr"]=="") {
			$.messager.alert("错误提示",'没有对照关系，不可撤销!','info');
			return;	
		}else{
			$.messager.confirm("撤销", "确认是否撤销对照关系？", function (r) {
			if (r) {				
				var flg = $m({
					ClassName:"DHCHAI.MAPS.CssMappingSrv",
					MethodName:"DeleteMapById",
					Id:ID
				},false);
				if (parseInt(flg) < 0) {
						$.messager.alert('撤销失败','info');	
						return;				
				} else {
					$.messager.popover({msg: '撤销成功！',type:'success',timeout: 1000});
					obj.gridBaseMappingLoad();
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
		var txtBRType = $('#txtBRType').val();
		var txtBRCode = $('#txtBRCode').val();
		var txtBRDesc = $('#txtBRDesc').val(); 
		var IsActive  = $("#chkActive").checkbox('getValue')? '1':'0'; 
	
		if (!txtBRType) {
			errinfo = errinfo + "分类编码不允许为空!<br>";
		}	
		if (!txtBRCode) {
			errinfo = errinfo + "值域代码不允许为空!<br>";
		}
		if (!txtBRDesc) {
			errinfo = errinfo + "值域名称不允许为空!<br>";
		}	
		if (errinfo) {
			$.messager.alert("错误提示", errinfo, 'info');
			return;
		}
		var InputStr = ID;
		InputStr += "^" + txtBRType;
		InputStr += "^" + txtBRCode;
		InputStr += "^" + txtBRDesc;
		InputStr += "^" + IsActive;
		
		var flg = $m({
				ClassName:"DHCHAI.MAP.CssRange",
				MethodName:"Update",
				InStr:InputStr,
				aSeparete:"^"
			},false);
		if (parseInt(flg) <= 0) {
			if(parseInt(flg)=='-100'){
				$.messager.alert("错误提示", "同分类的代码不允许重复!" , 'info');
			}else{
				$.messager.alert("错误提示", "保存失败" , 'info');	
				return;	}
			}else {
				$HUI.dialog('#winEdit').close();
				$.messager.popover({msg: '保存成功！',type:'success',timeout: 1000});
				obj.RecRowID=flg;
				obj.gridBaseRange.reload() ;//刷新当前页
			}
	}
	//删除对照
	obj.btnDelete_click = function(){
		if (obj.RecRowID==""){
			$.messager.alert("提示", "选中数据记录,再点击删除!", 'info');
			return;
		}
		$.messager.confirm("删除", "是否删除选中数据记录?", function (r) {				
			if (r) {				
				var flg = $m({
					ClassName:"DHCHAI.MAP.CssMapping",
					MethodName:"DeleteById",
					Id:obj.RecRowID
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
					obj.RecRowID = "";
					obj.gridBaseMappingLoad();
				}
			}
		});
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
					ClassName:"DHCHAI.MAP.CssRange",
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
					obj.gridBaseRange.reload();//刷新当前页
				}
			}
		});
	}
	obj.InitDialog= function(rd){
		if(rd){
			obj.RecRowID=rd["ID"];
			obj.layer_rd=rd;
			var Type = rd["Type"];
			var KeyVal = rd["KeyVal"];
			var KeyText = rd["KeyText"];
			var IsActive = rd["IsActive"];
			IsActive = (IsActive=="1"? true: false)
			$('#txtBMType').val(Type).validatebox("validate");
			$('#txtBMKeyVal').val(KeyVal).validatebox("validate");
			$('#txtBMKeyText').val(KeyText).validatebox("validate");
			$('#chkMapActive').checkbox('setValue',IsActive);
		}else{
			obj.RecRowID="";
			obj.layer_rd=""
			$('#txtBMType').val("");
			$('#txtBMKeyVal').val("");
			$('#txtBMKeyText').val("");
			$('#chkMapActive').checkbox('setValue',true);
		}
			$('#winEdit2').show();
			obj.SetDiaglog2();
	}
	obj.InitDialog2= function(rd){
		if(rd){
			obj.RecRowID2=rd["ID"];
			obj.layer2_rd=rd
			var Type   = rd["Type"];
			var BRCode = rd["BRCode"];
			var BRDesc = rd["BRDesc"];
			var IsActive = rd["IsActive"];
			IsActive = (IsActive=="1"? true: false);
			$('#txtBRType').val(Type).validatebox("validate");
			$('#txtBRCode').val(BRCode).validatebox("validate");
			$('#txtBRDesc').val(BRDesc).validatebox("validate");
			$('#chkActive').checkbox('setValue',IsActive);
		}else{
			obj.RecRowID2="";
			obj.layer2_rd=""
			$('#txtBRType').val("");
			$('#txtBRCode').val("");
			$('#txtBRDesc').val("");
			$('#chkActive').checkbox('setValue',true);
		}
			$('#winEdit').show();
			obj.SetDiaglog();
	}
	obj.gridBaseMappingLoad = function(){
			$("#gridBaseMapping").datagrid("loading");	
			$cm ({
			    ClassName:"DHCHAI.MAPS.CssMappingSrv",
				QueryName:"QryBaseMapping",
				aType:"",		
		    	page:1,
				rows:200
			},function(rs){
				$('#gridBaseMapping').datagrid({loadFilter:pagerFilter}).datagrid('loadData', rs);					
			});
	    }
}