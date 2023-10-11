//页面Event
function InitLabBactMapWinEvent(obj){
	obj.LoadEvent = function(args){ 
		$('#gridLabBactMap').datagrid('loadData',{ 'total':'0',rows:[] });  //初始加载显示记录为0
	    $('#gridLabBacteria').datagrid('loadData',{ 'total':'0',rows:[] });  
   		obj.gridLabBactMapLoad();
   		obj.gridLabBacteriaLoad();
		//全部
		$('#btnAll').on('click', function(){
			obj.aFlag="";       //全部
			$cm ({
			    ClassName:"DHCHAI.DPS.LabBactSrv",
				QueryName:"QryLabBactMap",
				aFlg:"",	
				aAlias:$('#search').searchbox('getValue'),
		    	page:1,
				rows:20000
			},function(rs){
				$('#gridLabBactMap').datagrid({loadFilter:pagerFilter}).datagrid('loadData', rs);					
			});
		});
		
		//未对照
		$('#btnPend').on('click', function(){
			obj.aFlag="0";       //全部
			$cm ({
			    ClassName:"DHCHAI.DPS.LabBactSrv",
				QueryName:"QryLabBactMap",
				aFlg:"0",	
				aAlias:$('#search').searchbox('getValue'),	
		    	page:1,
				rows:20000
			},function(rs){
				$('#gridLabBactMap').datagrid({loadFilter:pagerFilter}).datagrid('loadData', rs);					
			});
		});
		//已对照
		$('#btnFin').on('click', function(){
			obj.aFlag="1";       //全部
			$cm ({
			    ClassName:"DHCHAI.DPS.LabBactSrv",
				QueryName:"QryLabBactMap",
				aFlg:"1",	
				aAlias:$('#search').searchbox('getValue'),	
		    	page:1,
				rows:20000
			},function(rs){
				$('#gridLabBactMap').datagrid({loadFilter:pagerFilter}).datagrid('loadData', rs);					
			});
		});
		$('#btnSyn').on('click', function(){
			var flg = $m({
				ClassName:'DHCHAI.DPS.LabBactSrv',
				MethodName:'SynMapRule',
				aCatDesc:"检验细菌",
				},false);
			if (parseInt(flg) <= 0) {
				$.messager.alert("错误提示", "没有可匹配项或匹配失败" , 'info');		
			}else {
				$.messager.popover({msg: '成功匹配'+flg+'条!',type:'success',timeout: 1000});
				//obj.gridLabBactMap.reload() ;//刷新当前页
				obj.gridLabBactMapLoad();
			}
		});
		$('#btnEdit').on('click', function(){
			var rd=obj.gridLabBactMap.getSelected();
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
			searchText($("#gridLabBactMap"),value);
			}	
		});	
		$('#btnsearch_two').searchbox({ 
		searcher:function(value,name){
			searchText($("#gridLabBacteria"),value);
			}	
		});	
  }
  //双击编辑事件
	obj.gridLabBactMap_onDbselect = function(rd){
		obj.InitDialog(rd);
	}
	//选择
	obj.gridLabBactMap_onSelect = function (){
		var rowData = obj.gridLabBactMap.getSelected();		
		if (rowData["ID"] == obj.RecRowID) {
			obj.RecRowID="";
			$("#btnAdd").linkbutton("disable");
			$("#btnEdit").linkbutton("disable");
			$("#btnDelete").linkbutton("disable");
			obj.gridLabBactMap.clearSelections();
		} else {
			obj.RecRowID = rowData["ID"];
			$("#btnAdd").linkbutton("enable");
			$("#btnEdit").linkbutton("enable");
			$("#btnDelete").linkbutton("enable");
		}
	}
	//保存
	obj.btnSave_click = function(){
		//调整逻辑传空字符去后台的暂时不修改
		var rd = obj.layer_rd;
		var ID = (rd ? rd["ID"] : '');
		var Bacteria  = rd["Bacteria"];
        var MapItemDr = rd["MapItemID"];
		var IsActive  =$("#chkActive").checkbox('getValue')? '1':'0';
		var MapNote   = $('#txtMapNote').val();
		var SCode     = rd["SCode"];
	    var ActUser   = rd["ActUser"];
	    
	    var InputStr = ID;
		//InputStr += "^" + Bacteria;
		//InputStr += "^" + MapItemDr;		
		InputStr += "^" + MapNote;
		//InputStr += "^" + SCode;
		InputStr += "^" + IsActive;
		//InputStr += "^" + ''; 
		//InputStr += "^" + '';
		//InputStr += "^" + ActUser;
		var flg = $m({
				ClassName:"DHCHAI.DP.LabBactMap",
				MethodName:"UpdateActive",
				InStr:InputStr,
				aSeparete:"^"
			},false);
		if (parseInt(flg) <= 0) {
				$.messager.alert("错误提示", "保存失败" , 'info');		
			}else {
				$HUI.dialog('#winEdit').close();
				$.messager.popover({msg: '保存成功！',type:'success',timeout: 1000});
				obj.RecRowID=flg;
				//obj.gridLabBactMap.reload() ;//刷新当前页
				originalData["gridLabBactMap"]=""; 
				obj.gridLabBactMapLoad();
			}
	}
	
	//对照
	obj.btnAdd_click = function(){
		if($("#btnAdd").hasClass("l-btn-disabled")) return;
		var Maprd = obj.gridLabBactMap.getSelected();
		var Bactrd = obj.gridLabBacteria.getSelected();
		var MapID  = (Maprd ? Maprd["ID"] : '');
		var BactID = (Bactrd ? Bactrd["ID"] : '');
		if ((MapID == "")||(BactID == "")) {
			$.messager.alert("错误提示",'设置对照关系需同时选择抗生素字典及对照项目!','info');
			return;
		}else{
			var flg = $m({
				ClassName:"DHCHAI.DPS.LabBactSrv",
				MethodName:"UpdateMap",
				ID:MapID,
				BactID:BactID,
				UsersName:Maprd["ActUser"]
			},false);
			if (parseInt(flg) <= 0) {
				$.messager.alert("错误提示", "对照失败" , 'info');	
				return;	
			}else {
				$.messager.popover({msg: '对照成功',type:'success',timeout: 1000});
				//obj.gridLabBactMap.reload() ;//刷新当前页
				originalData["gridLabBactMap"]=""; 
				obj.gridLabBactMapLoad();
			}
		}
	}
	//撤销
	obj.btnDelete_click = function(){
		if($("#btnDelete").hasClass("l-btn-disabled")) return;
		var rd = obj.gridLabBactMap.getSelected();
		var ID  = (rd ? rd["ID"] : '');
		if (rd["MapItemID"]=="") {
			$.messager.alert("错误提示",'没有对照关系，不可撤销!','info');
		}else{
			$.messager.confirm("撤销", "确认是否撤销对照关系？", function (r) {
			if (r) {				
				var flg = $m({
					ClassName:"DHCHAI.DP.LabBactMap",
					MethodName:"DeleteMapById",
					Id:ID
				},false);
				if (parseInt(flg) < 0) {
						$.messager.alert('撤销失败','info');				
				} else {
					$.messager.popover({msg: '撤销成功！',type:'success',timeout: 1000});
					//obj.gridLabBactMap.reload() ;//刷新当前页
					originalData["gridLabBactMap"]=""; 
					obj.gridLabBactMapLoad();
					}
				} 
			});
		}
	}
		//窗体
	obj.SetDiaglog=function (){
		$('#winEdit').dialog({
			title: '细菌字典对照编辑',
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
	obj.gridLabBactMapLoad = function(){
		$cm ({
		    ClassName:"DHCHAI.DPS.LabBactSrv",
			QueryName:"QryLabBactMap",
			aFlg:obj.aFlag,	
			aAlias:$('#search').searchbox('getValue'),			
	    	page:1,
			rows:99999
		},function(rs){
			$('#gridLabBactMap').datagrid({loadFilter:pagerFilter}).datagrid('loadData', rs);					
		});
    }
    
    obj.gridLabBacteriaLoad = function(){
		$cm ({
		    ClassName:"DHCHAI.DPS.LabBactSrv",
			QueryName:"QryLabBacteria",			    
	    	page:1,
			rows:99999
		},function(rs){
			$('#gridLabBacteria').datagrid({loadFilter:pagerFilter}).datagrid('loadData', rs);					
		});
    }
    
}
