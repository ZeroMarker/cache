//页面Event
function InitHISUIWinEvent(obj){
	//事件绑定
	obj.LoadEvents = function(arguments){
		$("#btnSave").on('click',function(){
			obj.btnSave_click();
		});
		$("#btnDelete").on('click',function(){
			obj.btnDelete_click();
		});	
		obj.GridArcItemLoad();
	};
		//搜索框定义
	$('#search').searchbox({ 
		searcher:function(value,name){
			obj.GridArcLoad(value);
		}, 
		prompt:'搜索' 
	})
	$('#searchArc').searchbox({ 
		searcher:function(value,name){
			obj.GridArcItemLoad(value);
		}, 
		prompt:'搜索' 
	})
	
	$HUI.tabs("#tabs",{
		onSelect:function(title,index){
			if(title.indexOf("科室")>-1){
				$("#HospItem").hide();
				$("#LocItem").show();
				$("#TypeItem").hide();
				$("#PathItem").hide();
				obj.ArcFlag=2
				obj.GridArcLoad();
			}else if(title=="路径类型") {
				$("#HospItem").hide();
				$("#LocItem").hide();
				$("#TypeItem").show();
				$("#PathItem").hide();
				obj.ArcFlag=3
				obj.GridArcLoad();
			}else if(title.indexOf("路径")>-1) {
				$("#HospItem").hide();
				$("#LocItem").hide();
				$("#TypeItem").hide();
				$("#PathItem").show();
				obj.ArcFlag=4
				obj.GridArcLoad();
			}else{
				$("#HospItem").show();
				$("#LocItem").hide();
				$("#TypeItem").hide();
				$("#PathItem").hide();
				obj.ArcFlag=1
				obj.GridArcLoad();
			}
		}
	});
	
	$HUI.tabs("#arcTabs",{
		onSelect:function(title,index){
			if(title.indexOf("医嘱子类")>-1) {
				obj.ArcItemFlag=2
				obj.GridArcItemLoad();
			}else if(title.indexOf("医嘱项")>-1) {
				obj.ArcItemFlag=3
				obj.GridArcItemLoad();
			}else if(title.indexOf("医嘱大类")>-1){
				obj.ArcItemFlag=1
				obj.GridArcItemLoad();
			}
		}
	});
	
	//提交后台保存
	obj.btnSave_click=function(){		
		var errinfo = "";
		var row = $('#GridArcItem').datagrid('getSelected');
		var userID = session['DHCMA.USERID'];
		var Level="",LevelType="",ARCType=""
		if (obj.ArcFlag==1){
			var Level="H"
			var LevelType = $('#cboSSHosp').combobox('getValues').join(',');
			if(!LevelType){
				errinfo = errinfo + "医院不可以为空！<br>";
			}	
		}else if(obj.ArcFlag==2){
			var Level="L"
			var LevelType = $('#cboLoc').combobox('getValues').join(',');	
			if(!LevelType){
				errinfo = errinfo + "科室不可以为空！<br>";
			}
		}else if(obj.ArcFlag==3){
			var Level="T"
			var LevelType = $('#cboType').combobox('getValues').join(',');	
			if(!LevelType){
				errinfo = errinfo + "路径类型不可以为空！<br>";
			}
		}else if(obj.ArcFlag==4){
			var Level="P"
			var LevelType = $('#cboPath').combobox('getValues').join(',');
			if(!LevelType){
				errinfo = errinfo + "路径不可以为空！<br>";
			}
		}
		
		if (obj.ArcItemFlag==1){
			var ARCType="G"
		}else if(obj.ArcItemFlag==2){
			var ARCType="C"
		}else if(obj.ArcItemFlag==3){
			var ARCType="M"
		}
		
		if (!row){
			errinfo = errinfo + "医嘱信息不可以为空！<br>";
		}
	
		if (errinfo) {
			$.messager.alert("错误提示", errinfo, 'info');
			return;
		}
		var ArcimID = row.BTID;
		var flg = $m({
			ClassName:"DHCMA.CPW.BT.NoVarOrder",
			MethodName:"CheckOrd",
			aLevel:Level,
			aLevelType:LevelType,
			aARCType:ARCType,
			ARCID:ArcimID,
		},false);
		if (flg!=""){
			$.messager.alert("失败","添加失败，医嘱信息在【"+flg+"】中已维护！", 'error');
			return ;
		}
		
		var InputStr = "^"+ARCType+"^"+ArcimID+"^"+Level+"^"+LevelType+"^"+userID;
		var data = $.cm({
				ClassName:"DHCMA.CPW.BT.NoVarOrder",
				MethodName:"Update",
				"aInputStr":InputStr,
				"aSeparete":"^"
			},false);
		if(parseInt(data)<=0){
			$.messager.alert("失败","添加失败!Error=" + data, 'error');
			return ;
		}else{
			$.messager.popover({msg: '添加成功！',type:'success',timeout: 1000});
			obj.GridArcLoad();
		}
	};
	//删除
	obj.btnDelete_click=function(){	
		var row = $('#GridArc').datagrid('getSelected');	
		if (!row){
			$.messager.alert("提示","请选择要删除的医嘱信息！",'info');
			return;
		}
		$.messager.confirm("删除", "是否删除选中数据记录?", function (r) {				
			if (r) {
				var data = $.cm({
					ClassName:"DHCMA.CPW.BT.NoVarOrder",
					MethodName:"DeleteById",
					"aId":row.BTID
				},false);
				if(parseInt(data)<0){
					$.messager.alert("提示","删除失败！",'error');	
					return;
				}else{	
					$.messager.popover({msg: '删除成功！',type:'success',timeout: 1000});
					obj.GridArcLoad();
				}
			}
		});
	};
	
	//医嘱信息加载
	obj.GridArcItemLoad = function(value){
		var QueryName=""	
		if (obj.ArcItemFlag==1){
			var QueryName="QryOrCatDesc"
		}else if(obj.ArcItemFlag==2){
			var QueryName="QryICDesc"	
		}else{
			var QueryName="QryArcimDesc"	
		}
		$cm({
			ClassName:"DHCMA.CPW.BTS.NoVarOrderSrv",
			QueryName:QueryName,
			aHospID:session['DHCMA.HOSPID'],
			q:value,
			page:1,      //可选项，页码，默认1
			rows:999    //可选项，获取多少条数据，默认50
		},function(rs){
			$('#GridArcItem').datagrid('loadData', rs);
		});
	}
	
	//已维护的医嘱加载
	obj.GridArcLoad = function(value){
		var Level="",LevelType=""
		if (obj.ArcFlag==1){
			var Level="H"
			var LevelType = $('#cboSSHosp').combobox('getValues').join(',');	
		}else if(obj.ArcFlag==2){
			var Level="L"
			var LevelType = $('#cboLoc').combobox('getValues').join(',');	
		}else if(obj.ArcFlag==3){
			var Level="T"
			var LevelType = $('#cboType').combobox('getValues').join(',');	
		}else if(obj.ArcFlag==4){
			var Level="P"
			var LevelType = $('#cboPath').combobox('getValues').join(',');
		}
		$cm({
			ClassName:"DHCMA.CPW.BTS.NoVarOrderSrv",
			QueryName:"QryNoVarOrder",
			aLevel:Level,
			aLevelType:LevelType,
			q:value,
			page:1,      //可选项，页码，默认1
			rows:999    //可选项，获取多少条数据，默认50
		},function(rs){
			$('#GridArc').datagrid('loadData', rs);
		});
	}	
}


