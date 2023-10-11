//页面Event
function InitLabSpecMapWinEvent(obj){
	//按钮初始化
	obj.LoadEvent = function(args){ 
		$('#gridLabSpecMap').datagrid('loadData',{ 'total':'0',rows:[] });  //初始加载显示记录为0
	    $('#gridLabSpecimen').datagrid('loadData',{ 'total':'0',rows:[] });  
   		obj.gridLabSpecMapLoad();
   		obj.gridLabSpecimenLoad();
   		//全部
		$('#btnAll').on('click', function(){
			obj.aFlag =""; //全部
			$cm ({
			    ClassName:"DHCHAI.DPS.LabSpecSrv",
				QueryName:"QryLabSpecMap",
				aFlg:"",		
				aAlias:$('#search').searchbox('getValue'),
		    	page:1,
				rows:20000
			},function(rs){
				$('#gridLabSpecMap').datagrid({loadFilter:pagerFilter}).datagrid('loadData', rs);					
			});
		});
		//未对照
		$('#btnPend').on('click', function(){
			obj.aFlag ="0"; 
			$cm ({
			    ClassName:"DHCHAI.DPS.LabSpecSrv",
				QueryName:"QryLabSpecMap",
				aFlg:"0",	
				aAlias:$('#search').searchbox('getValue'),	
		    	page:1,
				rows:20000
			},function(rs){
				$('#gridLabSpecMap').datagrid({loadFilter:pagerFilter}).datagrid('loadData', rs);					
			});
		});
		//已对照
		$('#btnFin').on('click', function(){
			obj.aFlag ="1"; 
			$cm ({
			    ClassName:"DHCHAI.DPS.LabSpecSrv",
				QueryName:"QryLabSpecMap",
				aFlg:"1",	
				aAlias:$('#search').searchbox('getValue'),	
		    	page:1,
				rows:20000
			},function(rs){
				$('#gridLabSpecMap').datagrid({loadFilter:pagerFilter}).datagrid('loadData', rs);					
			});
		});
		$('#btnSyn').on('click', function(){
			var flg = $m({
				ClassName:'DHCHAI.DPS.LabSpecSrv',
				MethodName:'SynMapRule',
				aCatDesc:"检验标本",
				},false);
			if (parseInt(flg) <= 0) {
				$.messager.alert("错误提示", "没有可匹配项或匹配失败" , 'info');		
			}else {
				$.messager.popover({msg: '成功匹配'+flg+'条!',type:'success',timeout: 1000});
				//obj.gridLabSpecMap.reload() ;//刷新当前页
				obj.gridLabSpecMapLoad();
			}
		});
		$('#btnEdit').on('click', function(){
			var rd=obj.gridLabSpecMap.getSelected();
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
			searchText($("#gridLabSpecMap"),value);
			}	
		});	
		
		//标本标准字典
		$('#btnAdd_two').on('click', function(){
			obj.InitDialog_two();
		});
		$('#btnEdit_two').on('click', function(){
			var rd=obj.gridLabSpecimen.getSelected();
			obj.InitDialog_two(rd);
		});
		$('#btnDelete_two').on('click', function(){
			obj.btnDelete_two_click();
		});
		$('#btnsearch_two').searchbox({ 
		searcher:function(value,name){
			searchText($("#gridLabSpecimen"),value);
			}	
		});	
	
  }
  //双击编辑事件
	obj.gridLabSpecMap_onDbselect = function(rd){
		obj.InitDialog(rd);
	}
	obj.gridLabSpecimen_onDbselect = function(rd){
		obj.InitDialog_two(rd);
	}
	//选择
	obj.gridLabSpecMap_onSelect = function (){
		var rowData = obj.gridLabSpecMap.getSelected();
		if($("#btnEdit").hasClass("l-btn-disabled")) obj.RecRowID="";
		if (rowData["ID"] == obj.RecRowID) {
			obj.RecRowID="";
			$("#btnAdd").linkbutton("disable");
			$("#btnEdit").linkbutton("disable");
			$("#btnDelete").linkbutton("disable");
			obj.gridLabSpecMap.clearSelections();
		} else {
			obj.RecRowID = rowData["ID"];
			$("#btnAdd").linkbutton("enable");
			$("#btnEdit").linkbutton("enable");
			$("#btnDelete").linkbutton("enable");
		}
	}
	obj.gridLabSpecimen_onSelect = function (){
		var rowData = obj.gridLabSpecimen.getSelected();
		if($("#btnEdit_two").hasClass("l-btn-disabled")) obj.RecRowID2="";
		if (rowData["ID"] == obj.RecRowID2) {
			obj.RecRowID2="";
			$("#btnAdd_two").linkbutton("enable");
			$("#btnEdit_two").linkbutton("disable");
			$("#btnDelete_two").linkbutton("disable");
			obj.gridLabSpecimen.clearSelections();
		} else {
			obj.RecRowID2 = rowData["ID"];
			$("#btnAdd_two").linkbutton("disable");
			$("#btnEdit_two").linkbutton("enable");
			$("#btnDelete_two").linkbutton("enable");
		}
	}
	//保存
	obj.btnSave_click = function(){
		var rd = obj.layer_rd;
		var ID = (rd ? rd["ID"] : '');
		var SpecDesc  = rd["SpecDesc"];
        var MapItemDr = rd["MapItemID"];
		var IsActive  =$("#chkActive").checkbox('getValue')? '1':'0';
		var MapNote   = $('#txtMapNote').val();
		var SCode     = rd["SCode"];	
	    var ActUser   = rd["ActUser"];
	    
	    var InputStr = ID;
		InputStr += "^" + SpecDesc;
		InputStr += "^" + MapItemDr;		
		InputStr += "^" + MapNote;
		InputStr += "^" + SCode;
		InputStr += "^" + IsActive;
		InputStr += "^" + ''; 
		InputStr += "^" + '';
		InputStr += "^" + ActUser;
		var flg = $m({
				ClassName:"DHCHAI.DP.LabSpecMap",
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
				//obj.gridLabSpecMap.reload() ;//刷新当前页
				originalData["gridLabSpecMap"]=""; 
				obj.gridLabSpecMapLoad();
			}
	}
	obj.btnSave_two_click = function(){
		var errinfo = "";
		var SpecCode = $('#txtSpecCode').val();
		var SpecDesc = $('#txtSpecDesc').val();
		var WCode = $('#txtWCode').val();
		var IsActive = $('#chkActive_two').checkbox('getValue');
		var Property= $('#cboProperty').combobox('getValue');
		if (!SpecCode) {
			errinfo = errinfo + "代码不允许为空!<br>";
		}
		if (!SpecDesc) {
			errinfo = errinfo + "名称不允许为空!<br>";
		}
		if (errinfo) {
			$.messager.alert("错误提示", errinfo, 'info');
			return;
		}
		IsActive = (IsActive==true? 1: 0);
		var inputStr = obj.RecRowID2;
		inputStr = inputStr + '^' + SpecCode;
		inputStr = inputStr + '^' + SpecDesc;
		inputStr = inputStr + '^' + WCode;
		inputStr = inputStr + '^' + IsActive;
		inputStr = inputStr + '^' + Property;
		var flg = $m({
			ClassName:"DHCHAI.DP.LabSpecimen",
			MethodName:"Update",
			InStr:inputStr,
			aSeparete:"^"
		},false);
		if (parseInt(flg) <= 0) {
			if (parseInt(flg) == '-100') {
				$.messager.alert("错误提示", "标本代码、名称重复!" , 'info');
			}else{
				$.messager.alert("错误提示", "保存失败" , 'info');
				}
		}else {
			$HUI.dialog('#winEdit_two').close();
			$.messager.popover({msg: '保存成功！',type:'success',timeout: 1000});
			obj.RecRowID2 = flg;
			obj.gridLabSpecimen.reload() ;//刷新当前页
			originalData["gridLabSpecimen"]=""; 
			obj.gridLabSpecimenLoad();
		}
	}
	//对照
	obj.btnAdd_click = function(){
		if($("#btnAdd").hasClass("l-btn-disabled")) return;
		var Maprd = obj.gridLabSpecMap.getSelected();
		var Sperd = obj.gridLabSpecimen.getSelected();
		var MapID  = (Maprd ? Maprd["ID"] : '');
		var SpeID = (Sperd ? Sperd["ID"] : '');
		if ((MapID == "")||(SpeID == "")) {
			$.messager.alert("错误提示",'设置对照关系需同时选择抗生素字典及对照项目!','info');
		}else{
			var flg = $m({
				ClassName:"DHCHAI.DPS.LabSpecSrv",
				MethodName:"UpdateMap",
				ID:MapID,
				SpeID:SpeID,
				UsersName:Maprd["ActUser"]
			},false);
			if (parseInt(flg) <= 0) {
				$.messager.alert("错误提示", "对照失败" , 'info');		
			}else {
				$.messager.popover({msg: '对照成功',type:'success',timeout: 1000});
				//obj.gridLabSpecMap.reload() ;//刷新当前页
				originalData["gridLabSpecMap"]=""; 
				obj.gridLabSpecMapLoad();
			}
		}
	}
	//撤销
	obj.btnDelete_click = function(){
		if($("#btnDelete").hasClass("l-btn-disabled")) return;
		var rd = obj.gridLabSpecMap.getSelected();
		var ID  = (rd ? rd["ID"] : '');
		if (rd["MapItemID"]=="") {
			$.messager.alert("错误提示",'没有对照关系，不可撤销!','info');
		}else{
			$.messager.confirm("撤销", "确认是否撤销对照关系？", function (r) {
			if (r) {				
				var flg = $m({
					ClassName:"DHCHAI.DP.LabSpecMap",
					MethodName:"DeleteMapById",
					Id:ID
				},false);
				if (parseInt(flg) < 0) {
						$.messager.alert('撤销失败','info');				
				} else {
					$.messager.popover({msg: '撤销成功！',type:'success',timeout: 1000});
					//obj.gridLabSpecMap.reload() ;//刷新当前页
					originalData["gridLabSpecMap"]=""; 
					obj.gridLabSpecMapLoad();
				}
			} 
		});
		}
	}
	obj.btnDelete_two_click = function(){
		if (obj.RecRowID2==""){
			$.messager.alert("提示", "选中数据记录,再点击删除!", 'info');
			return;
		}
		
		$.messager.confirm("删除", "是否删除选中数据记录?", function (r) {
			if (r) {				
				var flg = $m({
					ClassName:"DHCHAI.DP.LabSpecimen",
					MethodName:"DeleteById",
					Id:obj.RecRowID2
				},false);
				if (parseInt(flg) < 0) {
					if (parseInt(flg)=='-777') {
						$.messager.alert('错误提示','当前无删除权限，请启用删除权限后再删除记录!','info');
					}else {
						$.messager.alert('删除失败!','info');
					}				
				} else {
					$.messager.popover({msg: '删除成功！',type:'success',timeout: 1000});
					obj.RecRowID2 = "";
					//obj.gridLabSpecimen.reload() ;//刷新当前页
					originalData["gridLabSpecimen"]=""; 
					obj.gridLabSpecimenLoad();
				}
			} 
		});
	}
	obj.SetDiaglog=function (){
		$('#winEdit').dialog({
			title: '标本对照编辑',
			iconCls:'icon-w-paper',
			modal: true,
			isTopZindex:false,//true,
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
	obj.SetDiaglog_two=function (){
		$('#winEdit_two').dialog({
			title: '标本编辑',
			iconCls:'icon-w-paper',
			modal: true,
			isTopZindex:false,//true,
			buttons:[{
				text:'保存',
				handler:function(){
					obj.btnSave_two_click();
				}
			},{
				text:'关闭',
				handler:function(){
					$HUI.dialog('#winEdit_two').close();
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
	obj.InitDialog_two= function(rd){
		if(rd){
			obj.RecRowID2=rd["ID"];
			var SpecCode = rd["SpecCode"];
			var SpecDesc = rd["SpecDesc"];
			var WCode = rd["WCode"];
			var PropertyDesc = rd["PropertyDesc"];
			var PropertyID = rd["PropertyID"]
			var IsActive = rd["IsActDesc"];
			IsActive = (IsActive=='是'? true: false);
			$('#txtSpecCode').val(SpecCode);
			$('#txtSpecDesc').val(SpecDesc);
			$('#cboProperty').combobox('setValue',PropertyID)
			$('#txtWCode').val(WCode);
			$('#chkActive_two').checkbox('setValue',IsActive);
			
		}else{
			obj.RecRowID2 = "";
			$('#txtSpecCode').val('');
			$('#txtSpecDesc').val('');
			$('#cboProperty').combobox('setValue','');
			$('#txtWCode').val('');
			$('#chkActive_two').checkbox('setValue',false);
		}
		$('#winEdit_two').show();
		obj.SetDiaglog_two();
	}
	obj.gridLabSpecMapLoad = function(){
		$cm ({
		    ClassName:"DHCHAI.DPS.LabSpecSrv",
			QueryName:"QryLabSpecMap",	
			aFlg:obj.aFlag,	
			aAlias:$('#search').searchbox('getValue'),	
	    	page:1,
			rows:99999
		},function(rs){
			$('#gridLabSpecMap').datagrid({loadFilter:pagerFilter}).datagrid('loadData', rs);
			var sVal = $('#search').searchbox('getValue');
			if(sVal!="")
			{
			    var aa =$('#search');
			    //searchbox-button searchbox-button-hover
			    //$("span.searchbox-button").click();
			}
			
			{
				$('#search').searchbox('clear');
			}
						
		});
    }
    
    obj.gridLabSpecimenLoad = function(){
		$cm ({
		    ClassName:"DHCHAI.DPS.LabSpecSrv",
			QueryName:"QryLabSpecimen",			    
	    	page:1,
			rows:99999
		},function(rs){
			$('#gridLabSpecimen').datagrid({loadFilter:pagerFilter}).datagrid('loadData', rs);					
		});
    }
    
}
