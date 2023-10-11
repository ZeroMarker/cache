//页面Event
function InitAreaMapWinEvent(obj){
	
	//按钮初始化
    obj.LoadEvent = function(args){ 
		//全部
		$('#btnAll').on('click', function(){
			aflg="";
			obj.gridAreaMapLoad();
		});
		//未对照
		$('#btnPend').on('click', function(){
			aflg=0;
			obj.gridAreaMapLoad();
		});
		//已对照
		$('#btnFin').on('click', function(){
			aflg=1;
			obj.gridAreaMapLoad();
		});
		
		//自动匹配
		$('#btnSyn').on('click', function(){
			var Source=$('#cboSource').combobox('getValue');
			if (Source=="") {
				$.messager.alert("错误提示", "先选择数据来源再执行自动匹配!" , 'info');
				return;
			}
			var flg = $m({
				ClassName:'DHCMA.Util.BTS.AreaIODicMapSrv',
				MethodName:'SynMapDic',
				aSource:$('#cboSource').combobox('getText'),
			},false);
			if (parseInt(flg) <= 0) {
				$.messager.alert("错误提示", "没有可匹配项或匹配失败!" , 'info');	
				return;	
			}else {
				$.messager.popover({msg: '成功匹配'+flg+'条!',type:'success',timeout: 1000});
				obj.gridAreaMapLoad();
			}
		});
		//对照
		$('#btnAdd').on('click', function(){
			obj.btnAdd_click();
		});
		//撤销
		$('#btnDelete').on('click', function(){
			obj.btnDelete_click();
		});
		
		//同步HIS地址
		$('#btnSynHIS').on('click', function(){
			var flg = $m({
				ClassName:'DHCMA.Util.BTS.AreaIODicMapSrv',
				MethodName:'SynHISAreaDic'
			},false);
			if (parseInt(flg) <= 0) {
				$.messager.alert("错误提示", "同步HIS地址失败!" , 'info');	
				return;	
			}else {
				$.messager.popover({msg: '成功同步'+flg+'条地址信息!',type:'success',timeout: 1000});
				 obj.gridAreaMapLoad();
			}
		});
		
		//作废
		$('#btnUnActive').on('click', function(){
			obj.btnOprActive_click(0);
		});
		
		//有效
		$('#btnActive').on('click', function(){
			obj.btnOprActive_click(1);
		});
	}
	
	//检索框
	$('#txtAlias').searchbox({ 
		searcher:function(value,name){
			obj.gridAreaMapLoad();
		}	
	});	
	
	
	obj.gridAreaMapLoad = function() {
		obj.gridAreaMap.load({
			ClassName:"DHCMA.Util.BTS.AreaIODicMapSrv",
			QueryName:"QryAreaIODicMap",
			aSource:$('#cboSource').combobox('getText'),
			aAlias:$('#txtAlias').searchbox('getValue'),
			aIsActive:'',
			aIsMap:aflg
		});
	}
   
	obj.btnOprActive_click = function(aIsActive){  	
		var IsSynEpd = ($('#chkSynEpd').checkbox('getValue')?1:0);
		var rows=obj.gridAreaDic.getSelected();
		
		var Code = rows["Code"];
		var flg = $m({
			ClassName:"DHCMed.SS.AreaDic",
			MethodName:"CheckActive",
			aCode:Code,
			aIsActive:aIsActive
		},false);
		if(IsSynEpd==1) {
			var flg = $m({
				ClassName:"DHCMed.EPD.AreaDic",
				MethodName:"CheckActive",
				aCode:Code,
				aIsActive:aIsActive
			},false);
		}
		$("#gridAreaDic").datagrid("reload");		
	}
	
	
	//对照
	obj.btnAdd_click = function(){
		var AreaDic = obj.gridAreaDic.getSelected();
		var AreaMap = obj.gridAreaMap.getSelected();
		var SrcID  = (AreaDic ? AreaDic["RowID"] : '');
		var MapID = (AreaMap ? AreaMap["MapID"] : '');
		var TargetID = (AreaMap ? AreaMap["DicID"] : '');
		
		if ((SrcID == "")||(TargetID == "")) {
			$.messager.alert("错误提示",'设置对照关系需同时省市县乡字典及对照项目!','info');
			return;	
		}else{
			var flg = $m({
				ClassName:"DHCMA.Util.BT.AreaIOMapping",
				MethodName:"UpdateMap",
				aID:MapID,
				aSrcID:SrcID,
				aTargetID:TargetID,
			},false);
			if (parseInt(flg) <= 0) {
				$.messager.alert("错误提示", "对照失败" , 'info');	
				return;		
			}else {
				$.messager.popover({msg: '对照成功',type:'success',timeout: 1000});
				 obj.gridAreaMapLoad();
			}
		}
	}
	
	//撤销
	obj.btnDelete_click = function(){
		var rd = obj.gridAreaMap.getSelected();
		var MapID  = (rd ? rd["MapID"] : '');
		if (rd["MapID"]=="") {
			$.messager.alert("错误提示",'没有对照关系，不可撤销!','info');
			return;	
		}else{
			$.messager.confirm("撤销", "确认是否撤销对照关系？", function (r) {
				if (r) {				
					var flg = $m({
						ClassName:"DHCMA.Util.BT.AreaIOMapping",
						MethodName:"DeleteById",
						aId:MapID
					},false);
					if (parseInt(flg) < 0) {
						$.messager.alert('撤销失败','info');	
						return;				
					} else {
						$.messager.popover({msg: '撤销成功！',type:'success',timeout: 1000});
						obj.gridAreaMapLoad();
					}
				} 
			});
		}
	}

}