//页面Event
function InitMapDataWinEvent(obj){
	obj.LoadEvent = function(args){   	
		$('#btnAll').on('click', function(){
			aflg="";
			obj.gridMapData.load({
				ClassName:"DHCHAI.MAPS.MappingSrv",
				QueryName:"QryMapData",	
				aType:$('#cboMapCate').combobox('getValue'),
				aNoMapFlg:aflg,
				aAlias:$('#search').searchbox('getValue')				
			});	  
		});
		$('#btnPend').on('click', function(){
			aflg=1;
			obj.gridMapData.load({
				ClassName:"DHCHAI.MAPS.MappingSrv",
				QueryName:"QryMapData",	
				aType:$('#cboMapCate').combobox('getValue'),
				aNoMapFlg:aflg,
				aAlias:$('#search').searchbox('getValue')				
			});	  
		});
		$('#btnReload').on('click', function(){
			var flg = $m({
				ClassName:'DHCHAI.MAPS.MappingSrv',
				MethodName:'SynSourceData'
			},false);
			if (parseInt(flg) <= 0) {
				$.messager.alert("错误提示", "同步数据失败" , 'info');		
			}else {
				$.messager.popover({msg: '成功同步'+flg+'条!',type:'success',timeout: 1000});
				obj.gridMapData.reload() ;//刷新当前页
			}
		});
		
		$('#btnSyn').on('click', function(){
			var flg = $m({
				ClassName:'DHCHAI.MAPS.MappingSrv',
				MethodName:'SynMapData'
			},false);
			if (parseInt(flg) <= 0) {
				$.messager.alert("错误提示", "没有可匹配项或匹配失败" , 'info');		
			}else {
				$.messager.popover({msg: '成功匹配'+flg+'条!',type:'success',timeout: 1000});
				obj.gridMapData.reload() ;//刷新当前页
			}
		});
		
		$('#btnAdd').on('click', function(){
			obj.btnAdd_click();
		});
		$('#btnDelete').on('click', function(){
			obj.btnDelete_click();
		});
		
		$('#search').searchbox({ 
			searcher:function(value,name){
				obj.gridMapData.load({
					ClassName:"DHCHAI.MAPS.MappingSrv",
					QueryName:"QryMapData",	
					aType:$('#cboMapCate').combobox('getValue'),
					aNoMapFlg:aflg,
					aAlias:value					
				})	  
			}	
		});	
		$('#btnsearch_two').searchbox({ 
			searcher:function(value,name){
				obj.gridMapItem.load({
					ClassName:"DHCHAI.MAPS.MappingSrv",
					QueryName:"QryMapItem",	
					aType:$('#cboMapCate').combobox('getValue'),
					aAlias:value				
				})	  
			}	
		});	
		$('#btnAdd_two').on('click', function(){
			obj.InitDialog();
		});
		$('#btnEdit_two').on('click', function(){
			var rd=obj.gridMapItem.getSelected();
			obj.InitDialog(rd);
		});
		$('#btnDelete_two').on('click', function(){
			obj.btnDelete_two_click();
		});
	}
	
	//选择
	obj.gridMapData_onSelect = function (){
		var rowData = obj.gridMapData.getSelected();
		if (rowData["ID"] == obj.RecRowID) {
			obj.RecRowID="";
			$("#btnAdd").linkbutton("disable");
			$("#btnDelete").linkbutton("disable");
			obj.gridMapData.clearSelections();
		} else {
			obj.RecRowID = rowData["ID"];
			$("#btnAdd").linkbutton("enable");
			$("#btnDelete").linkbutton("enable");
		}
	}
	
	//对照
	obj.btnAdd_click = function(){
		var Datard = obj.gridMapData.getSelected();
		var Itemrd = obj.gridMapItem.getSelected();
		var MapID  = (Datard ? Datard["ID"] : '');
		var ItemID = (Itemrd ? Itemrd["ID"] : '');
		if ((MapID == "")||(ItemID == "")) {
			$.messager.alert("错误提示",'设置对照关系需同时选择数据项及对照值域字典!','info');
		}else{
			var flg = $m({
				ClassName:"DHCHAI.MAP.MapData",
				MethodName:"UpdateMap",
				aID:MapID,
				aItemID:ItemID
			},false);
			if (parseInt(flg) <= 0) {
				$.messager.alert("错误提示", "对照失败" , 'info');		
			}else {
				$.messager.popover({msg: '对照成功',type:'success',timeout: 1000});
				obj.gridMapData.reload() ;//刷新当前页
			}
		}
	}
	//撤销
	obj.btnDelete_click = function(){
		var rd = obj.gridMapData.getSelected();
		var ID  = (rd ? rd["ID"] : '');
		if (rd["ItemDr"]=="") {
			$.messager.alert("错误提示",'没有对照关系，不可撤销!','info');
		}else{
			$.messager.confirm("撤销", "确认是否撤销对照关系？", function (r) {
				if (r) {				
					var flg = $m({
						ClassName:"DHCHAI.MAP.MapData",
						MethodName:"DeleteMapById",
						aId:ID
					},false);
					if (parseInt(flg) < 0) {
						$.messager.alert('撤销失败','info');				
					} else {
						$.messager.popover({msg: '撤销成功！',type:'success',timeout: 1000});
						obj.gridMapData.reload() ;//刷新当前页
					}
				} 
			});
		}
	}
	
	 //双击编辑事件
	obj.gridMapItem_onDbselect = function(rd){
		obj.InitDialog(rd);
	}
	//选择
	obj.gridMapItem_onSelect = function (){
		var rowData = obj.gridMapItem.getSelected();
		if(!rowData) obj.ItemRowID="";
		if (rowData["ID"] == obj.ItemRowID) {
			obj.ItemRowID="";
			$("#btnAdd_two").linkbutton("enable");
			$("#btnEdit_two").linkbutton("disable");
			$("#btnDelete_two").linkbutton("disable");
			obj.gridMapItem.clearSelections();
		} else {
			obj.ItemRowID = rowData["ID"];
			$("#btnAdd_two").linkbutton("disable");
			$("#btnEdit_two").linkbutton("enable");
			$("#btnDelete_two").linkbutton("enable");
		}
	}
	//保存
	obj.btnSave_click = function(){
		var errinfo = "";
	
		var MapType = $('#txtMapType').val();
		var MapCate = $('#txtMapCate').val();
		var MapCode = $('#txtMapCode').val();
		var MapDesc = $('#txtMapDesc').val();
		var MapDesc2 = $('#txtMapDesc2').val();
		var IsActive = ($('#chkActive').checkbox('getValue') ? 1 : 0);
		if ((!MapType)||(!MapCate)) {
			errinfo = errinfo + "分类编码、描述不允许为空!<br>";
		}
		if (!MapCode) {
			errinfo = errinfo + "值域代码名称不允许为空!<br>";
		}
		if (!MapDesc) {
			errinfo = errinfo + "值域名称不允许为空!<br>";
		}
		if (errinfo) {
			$.messager.alert("错误提示", errinfo, 'info');
			return;
		}
		var inputStr = obj.ItemRowID;
		inputStr = inputStr + '^' + MapType; 
		inputStr = inputStr + '^' + MapCate; 
		inputStr = inputStr + '^' + MapCode; 
		inputStr = inputStr + '^' + MapDesc; 
		inputStr = inputStr + '^' + MapDesc2;
		inputStr = inputStr + '^' + '';
		inputStr = inputStr + '^' + IsActive;
	
		var flg = $m({
			ClassName:"DHCHAI.MAP.MapItem",
			MethodName:"Update",
			aInStr:inputStr,
			aSeparete:"^"
		},false);
		
		if (parseInt(flg) <= 0) {
			$.messager.alert("错误提示", "保存失败！" , 'info');
			return;
		}else {
			$HUI.dialog('#MapItemEdit').close();
			$.messager.popover({msg: '保存成功！',type:'success',timeout: 1000});
			obj.ItemRowID = flg;
			obj.gridMapItem.reload() ;//刷新当前页
		}
	}
	//删除
	obj.btnDelete_two_click = function(){
		if (obj.ItemRowID==""){
			$.messager.alert("提示", "选中数据记录,再点击删除!", 'info');
			return;
		}
		$.messager.confirm("删除", "是否删除选中数据记录?", function (r) {
			if (r) {				
				var flg = $m({
					ClassName:"DHCHAI.MAP.MapItem",
					MethodName:"DeleteById",
					Id:obj.ItemRowID
				},false);
				if (parseInt(flg) < 0) {
					$.messager.alert('删除失败!','info');
					return;							
				} else {
					$.messager.popover({msg: '删除成功！',type:'success',timeout: 1000});
					obj.ItemRowID = "";
					obj.gridMapItem.reload() ;//刷新当前页
				}
			} 
		});
	}
	//窗体
	obj.SetWinEdit=function (){
		$('#MapItemEdit').dialog({
			title: '标准值域字典维护',
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
					$HUI.dialog('#MapItemEdit').close();
				}
			}]
		});
	}
	//配置窗体-初始化
	obj.InitDialog= function(rd){
		if(rd){
			obj.ItemRowID=rd["ID"];
			var Type     = rd["Type"];
			var Cate     = rd["Cate"];
			var Code     = rd["Code"];
			var Desc     = rd["Desc"];
			var Desc2    = rd["Desc2"];
			var IsActive = rd["IsActive"];
			
			$('#txtMapType').val(Type);
			$('#txtMapCate').val(Cate);
			$('#txtMapCode').val(Code);
			$('#txtMapDesc').val(Desc);
			$('#txtMapDesc2').val(Desc2);
			$('#chkActive').checkbox('setValue',(IsActive==1 ? true:false));
			
		}else{
			obj.ItemRowID = "";
			$('#txtMapType').val('');
			$('#txtMapCate').val('');
			$('#txtMapCode').val('');
			$('#txtMapDesc').val('');
			$('#txtMapDesc2').val('');
			$('#chkActive').checkbox('setValue',false);
		}
		$('#MapItemEdit').show();
		obj.SetWinEdit();
	}
	

}
