//页面Event
function InitOEItmMastMapWinEvent(obj){
	//检索框
	$('#searchbox').searchbox({ 
		searcher:function(value,name){
			searchText($("#gridOEItmMastMap"),value);
		}	
	});	
	$('#searchbox_two').searchbox({ 
		searcher:function(value,name){
			searchText($("#gridOEItmMast"),value);
		}	
	});
	
	//按钮初始化
    obj.LoadEvent = function(args){ 
   		obj.gridOEItmMastMapLoad();
   		obj.gridOEItmMastLoad();

   		$('#btnSave').on('click', function(){
	     	obj.btnSave_click();
	 	});
		$('#btnClose').on('click', function(){
		    $HUI.dialog('#OEItmMastMapEdit').close();
	    });
		//全部
		$('#btnAll').on('click', function(){
			aflg="";
			obj.gridOEItmMastMapLoad();
		});
		//未对照
		$('#btnPend').on('click', function(){
			aflg=0;
			obj.gridOEItmMastMapLoad();
		});
		//已对照
		$('#btnFin').on('click', function(){
			aflg=1;
			obj.gridOEItmMastMapLoad();
		});
		//自动匹配
		$('#btnSyn').on('click', function(){
			var flg = $m({
				ClassName:'DHCHAI.DPS.OEItmMastMapSrv',
				MethodName:'SynMapRule',
				aCatDesc:"医嘱项",
				},false);
			if (parseInt(flg) <= 0) {
				$.messager.alert("错误提示", "没有可匹配项或匹配失败!" , 'info');		
			}else {
				$.messager.popover({msg: '成功匹配'+flg+'条!',type:'success',timeout: 1000});
				 obj.gridOEItmMastMapLoad();
			}
		});
		//编辑
		$('#btnEdit').on('click', function(){
			var rd=obj.gridOEItmMastMap.getSelected();
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
		//ADD(2022-12) 新增'三管感染防控督查表'自动匹配规则
		var IsCreateIExAByOEOrd = $m({ 
            ClassName: "DHCHAI.BT.Config",
            MethodName: "GetValByCode",
            aCode: "IsCreateIExAByOEOrd"
        }, false);
		if(IsCreateIExAByOEOrd=="1"){
			$('#IA_1').show();
			$('#IA_2').show();
			$('#gridOEItmMastMap').datagrid('showColumn','IADesc');
			$('#gridOEItmMastMap').datagrid('showColumn','IATypeDesc');
		}
		else{
			$('#IA_1').hide();
			$('#IA_2').hide();
			$('#gridOEItmMastMap').datagrid('hideColumn','IADesc')
			$('#gridOEItmMastMap').datagrid('hideColumn','IATypeDesc')
		}
  	}
  
  	//窗体初始化
	obj.OEItmMastMapEdit =function() {
		$('#OEItmMastMapEdit').dialog({
			title: '医嘱项对照编辑',
			iconCls:"icon-w-paper",
			modal: true,
			isTopZindex:true
		});
	},
	
  	//双击编辑事件
	obj.gridOEItmMastMap_onDbselect = function(rd){
		obj.Layer(rd);
	}
	
	//选择
	obj.gridOEItmMastMap_onSelect = function (){
		var rowData = obj.gridOEItmMastMap.getSelected();
		if (rowData["ID"] == obj.RecRowID) {
			obj.RecRowID="";
			$("#btnAdd").linkbutton("disable");
			$("#btnEdit").linkbutton("disable");
			$("#btnDelete").linkbutton("disable");
			obj.gridOEItmMastMap.clearSelections();
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
		var BTItmDesc  = rd["BTOrdDesc"];
        var OrdCatDesc = rd["OrdCatDesc"];
        var BTMapItemDr = rd["BTMapItemDr"];
		var BTMapNote   = $('#txtBTMapNote').val();
		var BTSCode = rd["BTSCode"];
		var IsActive  =$("#chkIsActive").checkbox('getValue')? '1':'0';
	    var ActUser   = session['LOGON.GROUPDESC'];
	    //ADD(2022-12) 新增'三管感染防控督查表'自动匹配规则
	    var IATypeDr = $('#cboIATypeDr').combobox('getValue');
	    
		var InputStr = ID;
		InputStr += "^" + BTItmDesc;
		InputStr += "^" + OrdCatDesc;
		InputStr += "^" + BTMapItemDr;
		InputStr += "^" + BTMapNote;
		InputStr += "^" + BTSCode;
		InputStr += "^" + IsActive;
		InputStr += "^" + '';
		InputStr += "^" + '';
		InputStr += "^" + ActUser;
		InputStr += "^" + IATypeDr;
		var flg = $m({
			ClassName:"DHCHAI.DP.OEItmMastMap",
			MethodName:"Update",
			InStr:InputStr,
			aSeparete:"^"
		},false);
		if (parseInt(flg) <= 0) {
			$.messager.alert("错误提示", "保存失败" , 'info');	
			return;	
		}else {
			$HUI.dialog('#OEItmMastMapEdit').close();
			$.messager.popover({msg: '保存成功！',type:'success',timeout: 1000});
			obj.RecRowID=flg;
			originalData["gridOEItmMastMap"]="";
			obj.gridOEItmMastMapLoad();
		}
	}

	//对照
	obj.btnAdd_click = function(){
		var Maprd = obj.gridOEItmMastMap.getSelected();
		var Mastrd = obj.gridOEItmMast.getSelected();
		var MapID  = (Maprd ? Maprd["ID"] : '');
		var MastID = (Mastrd ? Mastrd["ID"] : '');
		if ((MapID == "")||(MastID == "")) {
			$.messager.alert("错误提示",'设置对照关系需同时选择护理项目字典及对照项目!','info');
			return;	
		}else{
			var flg = $m({
				ClassName:"DHCHAI.DPS.OEItmMastMapSrv",
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
				originalData["gridOEItmMastMap"]="";
				obj.gridOEItmMastMapLoad();
			}
		}
	}
	
	//撤销
	obj.btnDelete_click = function(){
		var rd = obj.gridOEItmMastMap.getSelected();
		var ID  = (rd ? rd["ID"] : '');
		if (rd["MapItemID"]=="") {
			$.messager.alert("错误提示",'没有对照关系，不可撤销!','info');
			return;	
		}else{
			$.messager.confirm("撤销", "确认是否撤销对照关系？", function (r) {
			if (r) {				
				var flg = $m({
					ClassName:"DHCHAI.DP.OEItmMastMap",
					MethodName:"DeleteMapById",
					Id:ID
				},false);
				if (parseInt(flg) < 0) {
					$.messager.alert('撤销失败','info');	
					return;				
				} else {
					$.messager.popover({msg: '撤销成功！',type:'success',timeout: 1000});
					originalData["gridOEItmMastMap"]="";
					obj.gridOEItmMastMapLoad();
				}
			}});
		}
	}

	obj.Layer= function(rd){
		if(rd){
			obj.RecRowID=rd["ID"];
			obj.layer_rd=rd
			var MapNote = rd["BTMapNote"];
			var IsActive = rd["BTIsActive"];
			IsActive = (IsActive=="1"? true: false)
			$('#txtBTMapNote').val(MapNote);
			$('#chkIsActive').checkbox('setValue',IsActive);
			//ADD(2022-12) 新增'三管感染防控督查表'自动匹配规则
			var IADr=rd["IAID"];
			$('#cboIADr').combobox('select',IADr);
			var IATypeDr=rd["IATypeID"];
			$('#cboIATypeDr').combobox('select',IATypeDr);
		}else{
			obj.RecRowID="";
			obj.layer_rd=""
			$('#txtBTMapNote').val('');
			$('#chkIsActive').checkbox('setValue',false);
			//ADD(2022-12) 新增'三管感染防控督查表'自动匹配规则
			$('#cboIADr').combobox('clear')
			$('#cboIATypeDr').combobox('clear')
		}
			$('#OEItmMastMapEdit').show();
			obj.OEItmMastMapEdit();
	}
	
	obj.gridOEItmMastMapLoad = function(){ 
		$("#gridOEItmMastMap").datagrid("loading");	
		$cm ({
		    ClassName:"DHCHAI.DPS.OEItmMastMapSrv",
			QueryName:"QryOEItmMastMap",
            aFlg:aflg,		
	    	page:1,
			rows:9999
		},function(rs){
			$('#gridOEItmMastMap').datagrid({loadFilter:pagerFilter}).datagrid('loadData', rs);	
			if ($('#searchbox').searchbox('getValue')) {
				searchText($("#gridOEItmMastMap"),$('#searchbox').searchbox('getValue'));
			}
		});
    }
    
    obj.gridOEItmMastLoad = function(){
		$("#gridOEItmMast").datagrid("loading");	
		$cm ({
		    ClassName:"DHCHAI.DPS.OEItmMastSrv",
			QueryName:"QryOEItmMast",		
	    	page:1,
			rows:9999
		},function(rs){
			$('#gridOEItmMast').datagrid({loadFilter:pagerFilter}).datagrid('loadData', rs);					
		});
    }
}