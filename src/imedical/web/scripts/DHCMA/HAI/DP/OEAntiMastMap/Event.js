//页面Event
function InitOEAntiMastMapWinEvent(obj){
	//检索框
	$('#searchbox').searchbox({ 
		searcher:function(value,name){
			searchText($("#gridOEAntiMastMap"),value);
		}	
	});	
	$('#searchbox_two').searchbox({ 
		searcher:function(value,name){
			searchText($("#gridOEAntiMast"),value);
		}	
	});
	//按钮初始化
    obj.LoadEvent = function(args){
	    $('#gridOEAntiMastMap').datagrid('loadData',{ 'total':'0',rows:[] });  //初始加载显示记录为0
	    $('#gridOEAntiMast').datagrid('loadData',{ 'total':'0',rows:[] });  
   		obj.gridOEAntiMastMapLoad();
   		obj.gridOEAntiMastLoad();
   		
   		$('#btnSave').on('click', function(){
	     	obj.btnSave_click();
	 	});
		$('#btnClose').on('click', function(){
		    $HUI.dialog('#OEAntiMastMapEdit').close();
	    });
		//全部
		$('#btnAll').on('click', function(){
			aflg='';
			obj.gridOEAntiMastMapLoad();
		});
		//未对照
		$('#btnPend').on('click', function(){
			aflg=0;
			obj.gridOEAntiMastMapLoad();
		});
		//已对照
		$('#btnFin').on('click', function(){
			aflg=1;
			obj.gridOEAntiMastMapLoad();
		});
		//自动匹配
		$('#btnSyn').on('click', function(){
			var flg = $m({
				ClassName:'DHCHAI.DPS.OEAntiMastMapSrv',
				MethodName:'SynMapRule',
				aCatDesc:"抗菌药物医嘱",
				},false);
			if (parseInt(flg) <= 0) {
				$.messager.alert("错误提示", "没有可匹配项或匹配失败!" , 'info');		
			}else {
				$.messager.popover({msg: '成功匹配'+flg+'条!',type:'success',timeout: 1000});
				 obj.gridOEAntiMastMapLoad();
			}
		});
		//编辑
		$('#btnEdit').on('click', function(){
			var rd=obj.gridOEAntiMastMap.getSelected();
			obj.Layer(rd);
		});
		//对照
		$('#btnAdd').on('click', function(){
			obj.btnAdd_click();
		});
		//撤销
		$('#btnDelete').on('click', function(){
			obj.btnDelete_click();
		});
  }
  
  	//窗体初始化
	obj.OEAntiMastMapEdit =function() {
		$('#OEAntiMastMapEdit').dialog({
			title: '抗菌药物对照编辑',
			iconCls:"icon-w-paper",
			modal: true,
			isTopZindex:true
		});
	},
	
  //双击编辑事件
	obj.gridOEAntiMastMap_onDbselect = function(rd){
		obj.Layer(rd);
	}
	
	//选择
	obj.gridOEAntiMastMap_onSelect = function (){
		var rowData = obj.gridOEAntiMastMap.getSelected();
		if (rowData["ID"] == obj.RecRowID) {
			obj.RecRowID="";
			$("#btnAdd").linkbutton("disable");
			$("#btnEdit").linkbutton("disable");
			$("#btnDelete").linkbutton("disable");
			obj.gridOEAntiMastMap.clearSelections();
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
		var BTAnitDesc  = rd["BTAnitDesc"];
        var BTMapItemDr = rd["BTMapItemDr"];
		var BTMapNote   = $('#txtMapNote').val();
		var BTSCode = rd["BTSCode"];
		var IsActive  =$("#chkIsActive").checkbox('getValue')? '1':'0';
	    var ActUser   = session['LOGON.GROUPDESC'];
	    
		var InputStr = ID;
		InputStr += "^" + BTAnitDesc;
		InputStr += "^" + '';
		InputStr += "^" + '';
		InputStr += "^" + BTMapItemDr;
		InputStr += "^" + BTMapNote;
		InputStr += "^" + BTSCode;
		InputStr += "^" + IsActive;
		InputStr += "^" + '';
		InputStr += "^" + '';
		InputStr += "^" + ActUser;
		var flg = $m({
			ClassName:"DHCHAI.DP.OEAntiMastMap",
			MethodName:"Update",
			InStr:InputStr,
			aSeparete:"^"
		},false);
		if (parseInt(flg) <= 0) {
			$.messager.alert("错误提示", "保存失败" , 'info');	
			return;	
		}else {
			$HUI.dialog('#OEAntiMastMapEdit').close();
			$.messager.popover({msg: '保存成功！',type:'success',timeout: 1000});
			obj.RecRowID=flg;
			originalData["gridOEAntiMastMap"]="";  //重新加载前，初始数据置空

			obj.gridOEAntiMastMapLoad();
		}
	}

	//对照
	obj.btnAdd_click = function(){
		var Maprd = obj.gridOEAntiMastMap.getSelected();
		var Mastrd = obj.gridOEAntiMast.getSelected();
		var MapID  = (Maprd ? Maprd["ID"] : '');
		var MastID = (Mastrd ? Mastrd["ID"] : '');
		if ((MapID == "")||(MastID == "")) {
			$.messager.alert("错误提示",'设置对照关系需同时选择护理项目字典及对照项目!','info');
			return;	
		}else{
			var flg = $m({
				ClassName:"DHCHAI.DPS.OEAntiMastMapSrv",
				MethodName:"UpdateMap",
				ID:MapID,
				MastID:MastID,
				UserID:""
			},false);
			if (parseInt(flg) <= 0) {
				$.messager.alert("错误提示", "对照失败" , 'info');	
				return;		
			}else {
				$.messager.popover({msg: '对照成功',type:'success',timeout: 1000});
				originalData["gridOEAntiMastMap"]=""; //重新加载前，初始数据置空
				obj.gridOEAntiMastMapLoad();
			}
		}
	}
	
	//撤销
	obj.btnDelete_click = function(){
		var rd = obj.gridOEAntiMastMap.getSelected();
		var ID  = (rd ? rd["ID"] : '');
		if (rd["MapItemID"]=="") {
			$.messager.alert("错误提示",'没有对照关系，不可撤销!','info');
			return;	
		}else{
			$.messager.confirm("撤销", "确认是否撤销对照关系？", function (r) {
			if (r) {				
				var flg = $m({
					ClassName:"DHCHAI.DP.OEAntiMastMap",
					MethodName:"DeleteMapById",
					Id:ID
				},false);
				if (parseInt(flg) < 0) {
						$.messager.alert('撤销失败','info');	
						return;				
				} else {
					$.messager.popover({msg: '撤销成功！',type:'success',timeout: 1000});
					originalData["gridOEAntiMastMap"]="";   //重新加载前，初始数据置空
					obj.gridOEAntiMastMapLoad();
				}
			} 
			});
		}
	}

	obj.Layer= function(rd){
		if(rd){
			obj.RecRowID=rd["ID"];
			obj.layer_rd=rd
			var MapNote = rd["BTMapNote"];
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
			$('#OEAntiMastMapEdit').show();
			obj.OEAntiMastMapEdit();
	}
	obj.gridOEAntiMastMapLoad = function(){
		$("#gridOEAntiMastMap").datagrid("loading");	
		$cm ({
		    ClassName:"DHCHAI.DPS.OEAntiMastMapSrv",
			QueryName:"QryOEAntiMastMap",
			aFlg:aflg,			
	    	page:1,
			rows:9999
		},function(rs){
			$('#gridOEAntiMastMap').datagrid({loadFilter:pagerFilter}).datagrid('loadData', rs);					
		});
    }
    
    obj.gridOEAntiMastLoad = function(){
		$("#gridOEAntiMast").datagrid("loading");	
		$cm ({
		    ClassName:"DHCHAI.DPS.OEAntiMastSrv",
			QueryName:"QryOEAntiMast",			    
	    	page:1,
			rows:9999
		},function(rs){
			$('#gridOEAntiMast').datagrid({loadFilter:pagerFilter}).datagrid('loadData', rs);					
		});
    }
}