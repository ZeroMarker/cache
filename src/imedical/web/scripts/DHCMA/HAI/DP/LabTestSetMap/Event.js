//页面Event
function InitLabTestSetMapWinEvent(obj){
	obj.LoadEvent = function(args){ 
	
		//初始tab页签
		var tab = $('#divTabs').tabs('getSelected');
		var index = $('#divTabs').tabs('getTabIndex',tab);
		if (index==0) {
			$("#divtab0").css('display','block');			
		}	
		$HUI.tabs("#divTabs",{
			onSelect:function(title,index){
				if (index==0){
					$("#divtab0").css('display','block');
					$("#divtab1").css('display','none');						
				}	
				if (index==1){
					$("#divtab1").css('display','block');
					$("#divtab0").css('display','none');
				}
			}
		});
   	
		$('#btnAll').on('click', function(){
			aflg="";
			obj.gridLabTestSetMap.load({
				ClassName:"DHCHAI.DPS.LabTestSetSrv",
				QueryName:"QryLabTestSetMap",	
				aFlg:aflg,
				aAlias:$('#search').searchbox('getValue')				
			})	  
		});
		$('#btnPend').on('click', function(){
			aflg=0;
			obj.gridLabTestSetMap.load({
				ClassName:"DHCHAI.DPS.LabTestSetSrv",
				QueryName:"QryLabTestSetMap",	
				aFlg:aflg,
				aAlias:$('#search').searchbox('getValue')				
			})	  

		});
		$('#btnFin').on('click', function(){
			aflg=1;
			obj.gridLabTestSetMap.load({
				ClassName:"DHCHAI.DPS.LabTestSetSrv",
				QueryName:"QryLabTestSetMap",	
				aFlg:aflg,
				aAlias:$('#search').searchbox('getValue')				
			})	  

		});
		
		$('#btnSyn').on('click', function(){
			var flg = $m({
				ClassName:'DHCHAI.DPS.LabTestSetSrv',
				MethodName:'SynMapRule',
				aCatDesc:"检验医嘱",
				},false);
			if (parseInt(flg) <= 0) {
				$.messager.alert("错误提示", "没有可匹配项或匹配失败" , 'info');		
			}else {
				$.messager.popover({msg: '成功匹配'+flg+'条!',type:'success',timeout: 1000});
				obj.gridLabTestSetMap.reload() ;//刷新当前页
			}
		});
		$('#btnEdit').on('click', function(){
			var rd=obj.gridLabTestSetMap.getSelected();
			obj.InitDialog(rd);
		});
		$('#btnAdd').on('click', function(){
			obj.btnAdd_click();
		});
		$('#btnDelete').on('click', function(){
			obj.btnDelete_click();
		});
		
		$('#search').searchbox({ 
			searcher:function(value,name){
				obj.gridLabTestSetMap.load({
					ClassName:"DHCHAI.DPS.LabTestSetSrv",
					QueryName:"QryLabTestSetMap",	
					aAlias:value				
				})	  
			}	
		});	
		$('#btnsearch_two').searchbox({ 
			searcher:function(value,name){
				obj.gridLabTestSet.load({
					ClassName:"DHCHAI.DPS.LabTestSetSrv",
					QueryName:"QryLabTestSet",	
					aAlias:value				
				})	  
			}	
		});	
		
		$('#btnAllTC').on('click', function(){
			aflg="";
			obj.gridLabTestCode.load({
				ClassName:"DHCHAI.DPS.LabTCMapSrv",
				QueryName:"QryMapTestCode",	
				aFlg:aflg,
				aAlias:$('#searchTC').searchbox('getValue')				
			})	   
		});
		$('#btnPendTC').on('click', function(){
			aflg=0;
			obj.gridLabTestCode.load({
				ClassName:"DHCHAI.DPS.LabTCMapSrv",
				QueryName:"QryMapTestCode",	
				aFlg:aflg,
				aAlias:$('#searchTC').searchbox('getValue')				
			})	   
		});
		$('#btnFinTC').on('click', function(){
			aflg=1;
			obj.gridLabTestCode.load({
				ClassName:"DHCHAI.DPS.LabTCMapSrv",
				QueryName:"QryMapTestCode",	
				aFlg:aflg,
				aAlias:$('#searchTC').searchbox('getValue')				
			})	   
			
		});

		$('#btnAddTC').on('click', function(){
			obj.btnAddTC_click();
		});
		$('#btnDeleteTC').on('click', function(){
			obj.btnDeleteTC_click();
		});
		$('#searchTC').searchbox({ 
			searcher:function(value,name){
				obj.gridLabTestCode.load({
					ClassName:"DHCHAI.DPS.LabTCMapSrv",
					QueryName:"QryMapTestCode",	
					aAlias:value
				});
			}	
		});	
	
  }
   //双击编辑事件
	obj.gridLabTestSetMap_onDbselect = function(rd){
		obj.InitDialog(rd);
	}
	//选择
	obj.gridLabTestSetMap_onSelect = function (){
		var rowData = obj.gridLabTestSetMap.getSelected();
		if (rowData["ID"] == obj.RecRowID) {
			obj.RecRowID="";
			$("#btnAdd").linkbutton("disable");
			$("#btnEdit").linkbutton("disable");
			$("#btnDelete").linkbutton("disable");
			obj.gridLabTestSetMap.clearSelections();
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
		var TestSet  = rd["TestSet"];
        var OrdDesc = rd["OrdDesc"];
        var MapItemDr = rd["MapItemID"];
		var IsActive  =$("#chkActive").checkbox('getValue')? '1':'0';
		var MapNote   = $('#txtMapNote').val();
		var SCode     = rd["SCode"];	
	    var ActUser   = rd["ActUser"];
	    
	    var InputStr = ID;
		InputStr += "^" + TestSet;
		InputStr += "^" + OrdDesc;		
		InputStr += "^" + MapItemDr;
		InputStr += "^" + MapNote;
		InputStr += "^" + SCode;
		InputStr += "^" + IsActive;
		InputStr += "^" + ''; 
		InputStr += "^" + '';
		InputStr += "^" + ActUser;
		var flg = $m({
			ClassName:"DHCHAI.DP.LabTestSetMap",
			MethodName:"Update",
			InStr:InputStr,
			aSeparete:"^"
		},false);
		if (parseInt(flg) <= 0) {
			$.messager.alert("错误提示", "保存失败" , 'info');		
		}else {
			$HUI.dialog('#winEdit').close();
			$.messager.popover({msg: '保存成功！',type:'success',timeout: 1000});
			obj.RecRowID=flg;
			obj.gridLabTestSetMap.reload() ;//刷新当前页
		}
	}
	//对照
	obj.btnAdd_click = function(){
		var Maprd = obj.gridLabTestSetMap.getSelected();
		var Setrd = obj.gridLabTestSet.getSelected();
		var MapID  = (Maprd ? Maprd["ID"] : '');
		var SetID = (Setrd ? Setrd["ID"] : '');
		if ((MapID == "")||(SetID == "")) {
			$.messager.alert("错误提示",'设置对照关系需同时选择抗生素字典及对照项目!','info');
		}else{
			var flg = $m({
				ClassName:"DHCHAI.DPS.LabTestSetSrv",
				MethodName:"UpdateMap",
				ID:MapID,
				SetID:SetID,
				UsersName:Maprd["ActUser"]
			},false);
			if (parseInt(flg) <= 0) {
				$.messager.alert("错误提示", "对照失败" , 'info');		
			}else {
				$.messager.popover({msg: '对照成功',type:'success',timeout: 1000});
				obj.gridLabTestSetMap.reload() ;//刷新当前页
			}
		}
	}
	//撤销
	obj.btnDelete_click = function(){
		var rd = obj.gridLabTestSetMap.getSelected();
		var ID  = (rd ? rd["ID"] : '');
		if (rd["MapItemID"]=="") {
			$.messager.alert("错误提示",'没有对照关系，不可撤销!','info');
		}else{
			$.messager.confirm("撤销", "确认是否撤销对照关系？", function (r) {
				if (r) {				
					var flg = $m({
						ClassName:"DHCHAI.DP.LabTestSetMap",
						MethodName:"DeleteMapById",
						Id:ID
					},false);
					if (parseInt(flg) < 0) {
							$.messager.alert('撤销失败','info');				
					} else {
						$.messager.popover({msg: '撤销成功！',type:'success',timeout: 1000});
						obj.gridLabTestSetMap.reload() ;//刷新当前页
					}
				} 
			});
		}
	}
	//窗体
	obj.SetDiaglog=function (){
		$('#winEdit').dialog({
			title: '检验医嘱对照编辑',
			iconCls:'icon-w-paper',
			modal: true,
			isTopZindex:true,//true,
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
	obj.InitDialog= function(rd){
		if(rd){
			obj.RecRowID=rd["ID"];
			obj.layer_rd=rd
			var MapNote = rd["MapNote"];
			var IsActive = rd["IsActDesc"];
			IsActive = (IsActive=="是"? true: false)
			$('#txtMapNote').val(MapNote);
			$('#chkActive').checkbox('setValue',IsActive);
		}else{
			obj.RecRowID="";
			obj.layer_rd=""
			$('#txtMapNote').val('');
			$('#chkActive').checkbox('setValue',false);
		}
		$('#winEdit').show();
		obj.SetDiaglog();
	}

	//选择
	obj.gridLabTestCode_onSelect = function (){
		var rowData = obj.gridLabTestCode.getSelected();
		if (rowData["ID"] == obj.RecRowIDTC) {
			obj.RecRowIDTC="";
			$("#btnAddTC").linkbutton("disable");
			$("#btnDeleteTC").linkbutton("disable");
			obj.gridLabTestCode.clearSelections();
		} else {
			obj.RecRowIDTC = rowData["ID"];
			$("#btnAddTC").linkbutton("enable");
			$("#btnDeleteTC").linkbutton("enable");
		}
	}
	
	//对照
	obj.btnAddTC_click = function(){
		var Maprd = obj.gridLabTestCode.getSelected();
		var Setrd = obj.gridLabTestSet.getSelected();
		var MapID  = (Maprd ? Maprd["ID"] : '');
		var SetID = (Setrd ? Setrd["ID"] : '');
		if ((MapID == "")||(SetID == "")) {
			$.messager.alert("错误提示",'设置对照关系需同时选择抗生素字典及对照项目!','info');
		}else{
			var flg = $m({
				ClassName:"DHCHAI.DP.LabTCMap",
				MethodName:"UpdateMap",
				aID:MapID,
				aSetID:SetID
			},false);
			if (parseInt(flg) <= 0) {
				$.messager.alert("错误提示", "对照失败" , 'info');		
			}else {
				$.messager.popover({msg: '对照成功',type:'success',timeout: 1000});
				obj.gridLabTestCode.reload() ;//刷新当前页
			}
		}
	}
	//撤销
	obj.btnDeleteTC_click = function(){
		var rd = obj.gridLabTestCode.getSelected();
		var ID  = (rd ? rd["ID"] : '');
		if (rd["MapItemID"]=="") {
			$.messager.alert("错误提示",'没有对照关系，不可撤销!','info');
		}else{
			$.messager.confirm("撤销", "确认是否撤销对照关系？", function (r) {
				if (r) {				
					var flg = $m({
						ClassName:"DHCHAI.DP.LabTCMap",
						MethodName:"DeleteMapById",
						Id:ID
					},false);
					if (parseInt(flg) < 0) {
						$.messager.alert('撤销失败','info');				
					} else {
						$.messager.popover({msg: '撤销成功！',type:'success',timeout: 1000});
						obj.gridLabTestCode.reload() ;//刷新当前页
					}
				} 
			});
		}
	}

}
