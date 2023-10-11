//页面Event
function InitLabAntiMapWinEvent(obj){
	
	//按钮初始化
	obj.LoadEvent = function(args){ 
		$('#gridLabAntiMap').datagrid('loadData',{ 'total':'0',rows:[] });  //初始加载显示记录为0
	    $('#gridLabAntibiotic').datagrid('loadData',{ 'total':'0',rows:[] });  
   		obj.gridLabAntiMapLoad();
   		obj.gridLabAntibioticLoad();
		//全部
		$('#btnAll').on('click', function(){
			//$("#gridLabAntiMap").datagrid("loading");	
			obj.aFlag = "";
			$cm ({
			    ClassName:"DHCHAI.DPS.LabAntiSrv",
				QueryName:"QryLabAntiMap",
				aFlg:"",
				LabAnti:$('#search').searchbox('getValue'),		
		    	page:1,
				rows:20000
			},function(rs){
				$('#gridLabAntiMap').datagrid({loadFilter:pagerFilter}).datagrid('loadData', rs);					
			});
		});
		//未对照
		$('#btnPend').on('click', function(){
			//$("#gridLabAntiMap").datagrid("loading");	
			obj.aFlag = "0";
			$cm ({
			    ClassName:"DHCHAI.DPS.LabAntiSrv",
				QueryName:"QryLabAntiMap",
				aFlg:"0",	
				LabAnti:$('#search').searchbox('getValue'),	
		    	page:1,
				rows:20000
			},function(rs){
				$('#gridLabAntiMap').datagrid({loadFilter:pagerFilter}).datagrid('loadData', rs);					
			});
		});
		//已对照
		$('#btnFin').on('click', function(){
			//$("#gridLabAntiMap").datagrid("loading");	
			obj.aFlag = "1";
			$cm ({
			    ClassName:"DHCHAI.DPS.LabAntiSrv",
				QueryName:"QryLabAntiMap",
				aFlg:"1",		
				LabAnti:$('#search').searchbox('getValue'),
		    	page:1,
				rows:20000
			},function(rs){
				$('#gridLabAntiMap').datagrid({loadFilter:pagerFilter}).datagrid('loadData', rs);					
			});
		}); 
		//自动匹配
		$('#btnSyn').on('click', function(){
			var flg = $m({
				ClassName:'DHCHAI.DPS.LabAntiSrv',
				MethodName:'SynMapRule',
				aCatDesc:"检验抗生素",
				},false);
			if (parseInt(flg) <= 0) {
				$.messager.alert("错误提示", "没有可匹配项或匹配失败" , 'info');		
			}else {
				$.messager.popover({msg: '成功匹配'+flg+'条!',type:'success',timeout: 1000});
				//obj.gridLabAntiMap.reload() ;//刷新当前页
				obj.gridLabAntiMapLoad();
			}
		});
		//编辑
		$('#btnEdit').on('click', function(){
			var rd=obj.gridLabAntiMap.getSelected();
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
			searchText($("#gridLabAntiMap"),value);
			}	
		});
		$('#btnsearch_two').searchbox({ 
		searcher:function(value,name){
			searchText($("#gridLabAntibiotic"),value);
			}	
		});		
  }
  //双击编辑事件
	obj.gridLabAntiMap_onDbselect = function(rd){
		obj.InitDialog(rd);
	}
	//选择
	obj.gridLabAntiMap_onSelect = function (){
		var rowData = obj.gridLabAntiMap.getSelected();
		
		if (rowData["ID"] == obj.RecRowID) {
			obj.RecRowID="";
			$("#btnAdd").linkbutton("disable");
			$("#btnEdit").linkbutton("disable");
			$("#btnDelete").linkbutton("disable");
			obj.gridLabAntiMap.clearSelections();
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
		var AntiDesc  = rd["AntiDesc"];
        var MapItemDr = rd["MapItemID"];
		var IsActive  =$("#chkActive").checkbox('getValue')? '1':'0';
		var MapNote   = $('#txtMapNote').val();
		var SCode     = rd["SCode"];	
	    var ActUser   = rd["ActUser"];
	    
	    var InputStr = ID;
		InputStr += "^" + AntiDesc;
		InputStr += "^" + MapItemDr;		
		InputStr += "^" + MapNote;
		InputStr += "^" + SCode;
		InputStr += "^" + IsActive;
		InputStr += "^" + ''; 
		InputStr += "^" + '';
		InputStr += "^" + ActUser;
		var flg = $m({
				ClassName:"DHCHAI.DP.LabAntiMap",
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
				//obj.gridLabAntiMap.reload() ;//刷新当前页
				originalData["gridLabAntiMap"]=""; 
				obj.gridLabAntiMapLoad();
			}
	}
	
	//对照
	obj.btnAdd_click = function(){
		if($("#btnAdd").hasClass("l-btn-disabled")) return;
		var Maprd = obj.gridLabAntiMap.getSelected();
		var Antird = obj.gridLabAntibiotic.getSelected();
		var MapID  = (Maprd ? Maprd["ID"] : '');
		var AntiID = (Antird ? Antird["ID"] : '');
		if ((MapID == "")||(AntiID == "")) {
			$.messager.alert("错误提示",'设置对照关系需同时选择抗生素字典及对照项目!','info');
			return;	
		}else{
			var flg = $m({
				ClassName:"DHCHAI.DPS.LabAntiSrv",
				MethodName:"UpdateMap",
				ID:MapID,
				AntiID:AntiID,
				UsersName:Maprd["ActUser"]
			},false);
			if (parseInt(flg) <= 0) {
				$.messager.alert("错误提示", "对照失败" , 'info');	
				return;		
			}else {
				$.messager.popover({msg: '对照成功',type:'success',timeout: 1000});
				//obj.gridLabAntiMap.reload() ;//刷新当前页
				originalData["gridLabAntiMap"]=""; 
				obj.gridLabAntiMapLoad();
			}
		}
	}
	
	//撤销
	obj.btnDelete_click = function(){
		if($("#btnDelete").hasClass("l-btn-disabled")) return;
		var rd = obj.gridLabAntiMap.getSelected();
		var ID  = (rd ? rd["ID"] : '');
		if (rd["MapItemID"]=="") {
			$.messager.alert("错误提示",'没有对照关系，不可撤销!','info');
			return;	
		}else{
			$.messager.confirm("撤销", "确认是否撤销对照关系？", function (r) {
			if (r) {				
				var flg = $m({
					ClassName:"DHCHAI.DP.LabAntiMap",
					MethodName:"DeleteMapById",
					Id:ID
				},false);
				if (parseInt(flg) < 0) {
						$.messager.alert('撤销失败','info');	
						return;				
				} else {
					$.messager.popover({msg: '撤销成功！',type:'success',timeout: 1000});
					//obj.gridLabAntiMap.reload() ;//刷新当前页
					originalData["gridLabAntiMap"]=""; 
					obj.gridLabAntiMapLoad();
				}
			} 
		});
		}
	}
	//窗体
	obj.SetDiaglog=function (){
		$('#winEdit').dialog({
			title: '抗生素对照编辑',
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
	obj.gridLabAntiMapLoad = function(){
		$cm ({
		    ClassName:"DHCHAI.DPS.LabAntiSrv",
			QueryName:"QryLabAntiMap",	
			aFlg:obj.aFlag,
			LabAnti:$('#search').searchbox('getValue'),			
	    	page:1,
			rows:99999
		},function(rs){
			$('#gridLabAntiMap').datagrid({loadFilter:pagerFilter}).datagrid('loadData', rs);					
		});
    }
    
    obj.gridLabAntibioticLoad = function(){
		$cm ({
		    ClassName:"DHCHAI.DPS.LabAntiSrv",
			QueryName:"QryLabAntibiotic",			    
	    	page:1,
			rows:99999
		},function(rs){
			$('#gridLabAntibiotic').datagrid({loadFilter:pagerFilter}).datagrid('loadData', rs);					
		});
    }
  
}
