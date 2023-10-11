//页面Event
function InitHISUIWinEvent(obj){
	//事件绑定
	obj.LoadEvents = function(arguments){

		$('#btnAdd').on('click', function(){
	     	obj.btn_AddGroup(this.id);
     	})
     	$('#btnEdit').on('click', function(){
	     	obj.btn_EditGroup(this.id);
     	})
     	$('#btnCancelEdit').on('click', function(){
	     	obj.btn_CancelEdit(this.id);
     	})
     	$('#btnDelete').on('click', function(){
	     	obj.btn_DelGroup(this.id);	
     	})
     	$('#btnSave').on('click', function(){
	     	obj.btn_SaveGroup();
	    })
	    $('#btnConfirm').on('click', function(){
		    obj.btn_Confirm();
		})
		$('#btnClose').on('click', function(){
		    obj.btn_Close();
		})
		
		$("#reSetGroup").on('click', function(){
			obj.btn_ReSetGroup();
		})
	}
	
	// 新增分组
	obj.btn_AddGroup = function(id) {
		obj.ViewMode="Edit";
		obj.SetBtnAvaliable(id);
		
		$.messager.popover({msg: '请先勾选指定医嘱，再点击下方【保存分组】按钮！',type:'alert'});
		obj.gridOrders.load({
			ClassName:"DHCMA.CPW.BTS.PathFormEpSrv",
			QueryName:"QryPathFormEpItemOrdAll",		
			aPathFormEpDr:curFormEpID,
			aPathFormEpItemDr:"",
			aHospID:HospID,
			aOrdDesc:"",
			aOrdGroupID:"",
			page:1,
			rows:99999
		});
			
	}
	
	// 编辑分组
	obj.btn_EditGroup = function(id) {
		if (obj.curOrdGrpID==""){
			$.messager.popover({msg: '请先选择分组方案！',type:'alert'});
			return;
		}
		obj.ViewMode="Edit";
		obj.gridOrders.load({
			ClassName:"DHCMA.CPW.BTS.PathFormEpSrv",
			QueryName:"QryPathFormEpItemOrdAll",		
			aPathFormEpDr:curFormEpID,
			aPathFormEpItemDr:"",
			aHospID:HospID,
			aOrdDesc:"",
			aOrdGroupID:"",
			page:1,
			rows:99999
		});

		obj.SetBtnAvaliable(id);
	}
	
	// 取消编辑
	obj.btn_CancelEdit = function(id) {
		obj.ViewMode="View";
		obj.SetBtnAvaliable(id);
		
		obj.gridOrders.load({
			ClassName:"DHCMA.CPW.BTS.PathFormEpSrv",
			QueryName:"QryPathFormEpItemOrdAll",		
			aPathFormEpDr:curFormEpID,
			aPathFormEpItemDr:"",
			aHospID:HospID,
			aOrdDesc:"",
			aOrdGroupID:obj.curOrdGrpID,
			page:1,
			rows:99999
		});
		if (obj.curOrdGrpID==""){
			$("#txtName").val("");
			$("#txtNote").val("");	
		}
		
		$('#cboOrdGroup').combogrid('grid').datagrid("selectRecord",obj.curOrdGrpID);
	}
	
	
	// 删除分组
	obj.btn_DelGroup = function(id) {
		if (obj.curOrdGrpID==""){
			$.messager.popover({msg: '请先选择分组方案！',type:'alert'});
			return;
		}else {
			$.messager.confirm("确认","确定删除?",function(r){	
				if(r){
					var ordsInfo=obj.GetCurGroupOrds();		//获取所有依赖医嘱信息
					var ret = $cm({ClassName:"DHCMA.CPW.BTS.PathOrdGroupSrv",MethodName:"DeleteOrdGroupSrv",aGroupID:obj.curOrdGrpID,aOrdsInfo:ordsInfo},false);
					if(parseInt(ret)==1){
						$.messager.alert("提示","删除成功！");
						obj.cboOrdGroup.clear();
						obj.curOrdGrpID="";	
						$("#txtName").val("");
						$("#txtNote").val("");
						
						obj.btn_ReSetGroup();
						//重新加载数据 
						$cm ({
							ClassName:"DHCMA.CPW.BTS.PathOrdGroupSrv",
							QueryName:"QryPathOrdGroup",
							ResultSetType:"array",
							aFormEpID:curFormEpID
						},function(rs){
							$('#cboOrdGroup').combogrid('grid').datagrid("loadData",rs);
						});	
					}else{			
						$.messager.alert("提示","删除失败！");
					}   
				}
			})
		}
	}
	
	// 保存分组
	obj.btn_SaveGroup = function() {
		var rows = $('#gridOrders').datagrid("getChecked");
		if (rows.length==0){
			$.messager.popover({msg: '未勾选任何医嘱！',type:'alert'});	 
			return	
		}
		
		var girdData = $('#cboOrdGroup').combogrid('grid');	// 获取数据表格对象
		var selRow = girdData.datagrid('getSelected');	// 获取选择的行
		if (selRow!=null){
			$("#txtName").val(selRow.OrdGroupDesc);
			$("#txtNote").val(selRow.OrdGroupNote);
		}
		$HUI.dialog('#winOrdGroupEdit').open();
	}
	
	// 保存分组-确认事件
	obj.btn_Confirm = function(){	
		var rows = $('#gridOrders').datagrid("getRows");
		if(rows.length==0) {
			$.messager.popover({msg: '未勾选任何医嘱！',type:'alert'});	 
			return;
		}
		if($("#txtName").val()==""){
			$.messager.popover({msg: '请填写分组名称！',type:'alert'});	 
			return;	
		}
		var chkGroupName=$m({
			ClassName:"DHCMA.CPW.BTS.PathOrdGroupSrv",
			MethodName:"CheckNameIsExist",
			aFormEpDr:curFormEpID,
			aGroupName:$("#txtName").val(),
			aGroupID:obj.curOrdGrpID
		},false);
		if (parseInt(chkGroupName)==1) {
			$.messager.alert("错误提示","本阶段下已存在同名分组，请修改分组名称重新提交！", 'info');
			return;
		}

		var ordsInfo=""
		$.each(rows, function(i, item){
   			{
	   			var isChecked=$("#gridOrders").parent().find("div.datagrid-cell-check").children("input[type='checkbox']").eq(i).checkbox('getValue');		//获取checkbox选中状态
				var isChecked=isChecked?"1":"0";
				ordsInfo=ordsInfo+CHR_1+isChecked+"^"+item.xID;
	   		}
		})
		ordsInfo=ordsInfo.substr(1,ordsInfo.length)
				
		$cm({
			ClassName:"DHCMA.CPW.BTS.PathOrdGroupSrv",
			MethodName:"SplitOrdGroupSrv",
			aOrdsOrTCMInfo:ordsInfo,
			aGroupID:obj.curOrdGrpID,
			aGroupName:$("#txtName").val(),
			aGroupNote:$("#txtNote").val(),
			aFormEpID:curFormEpID,
			dataType:"text"
		},function(ret){
			if (parseInt(ret.split("^")[0])<0) {
				$.messager.alert("错误提示","更新数据错误!Error=" + flg, 'info');
				return;
			} else {
				$.messager.alert("提示","保存成功");
			}
		})
		$HUI.dialog('#winOrdGroupEdit').close();
		$cm ({
			ClassName:"DHCMA.CPW.BTS.PathOrdGroupSrv",
			QueryName:"QryPathOrdGroup",
			ResultSetType:"array",
			aFormEpID:curFormEpID
		},function(rs){
			$('#cboOrdGroup').combogrid('grid').datagrid("loadData",rs);		
		});
		
		obj.btn_CancelEdit();
		
	}
	
	// 保存分组-关闭事件
	obj.btn_Close = function(){
		$HUI.dialog('#winOrdGroupEdit').close();	
	}
	
	//显示方剂信息明细
	obj.ShowFJDetail = function(FJid){
		$cm({
			ClassName:"DHCMA.CPW.BTS.PathTCMExtSrv",
			QueryName:"QryPathTCMExt",
			aParRef:FJid,
			ResultSetType:"array"
		},function(rs){
			var PopHtml=""
			if (rs.length>0){
				for(var i=0;i<rs.length;i++){
					PopHtml=PopHtml+rs[i].BTTypeDesc+"&nbsp&nbsp&nbsp"+rs[i].BTOrdMastID+"&nbsp&nbsp&nbsp"+rs[i].ArcResumeDesc+"<br/>"
				}
			}
			$HUI.popover('#pop'+FJid,{content:PopHtml,trigger:'hover',placement:'auto-right'});
			$('#pop'+FJid).popover('show');
		})
	}
	//销毁方剂明细显示
	obj.DestoryFJDetail = function(FJid){
		$('#pop'+FJid).popover('destroy');
	}
	
	//获取当前分组下医嘱信息，供删除分组使用
	obj.GetCurGroupOrds = function(){
		var rows = $('#gridOrders').datagrid("getRows");
		if(rows.length==0) {
			return "";
		}
		
		var ordsInfo=""
		$.each(rows, function(i, item){
   			{
				var isChecked="0";
				ordsInfo=ordsInfo+CHR_1+isChecked+"^"+item.xID;
	   		}
		})
		ordsInfo=ordsInfo.substr(1,ordsInfo.length)
		return ordsInfo;
	}
	
	// 恢复显示全部医嘱
	obj.btn_ReSetGroup = function(){
		obj.ViewMode="View";
		obj.cboOrdGroup.clear();
		obj.curOrdGrpID="";	
		$("#txtName").val("");
		$("#txtNote").val("");
		obj.SetBtnAvaliable();
				
		$cm ({
			ClassName:"DHCMA.CPW.BTS.PathFormEpSrv",
			QueryName:"QryPathFormEpItemOrdAll",
			ResultSetType:"array",
			aPathFormEpDr:curFormEpID,
			aPathFormEpItemDr:"",
			aHospID:HospID,
			aOrdDesc:"",
			aOrdGroupID:obj.curOrdGrpID,
			page:1,
			rows:99999
		},function(rs){
			$('#gridOrders').datagrid('loadData', rs);				
		});		
	}
	
	// 统一设置按钮可用性
	obj.SetBtnAvaliable = function(id){
		if (obj.ViewMode=="View"){
			$('#gridOrders').datagrid('hideColumn','checkOrd');
			$("#div-south").css("display","none");
		
			//重置中间布局高度
			var win_height = $("#cc").height();
			var c=$('#cc').layout('panel',"center");
			c.panel('resize',{height:win_height});
		}else{
			$('#gridOrders').datagrid('showColumn','checkOrd'); 		//显示列
			$("#div-south").css("display","block");
			$.parser.parse();
		}
		switch (id){
			case "btnAdd":
				$('#btnAdd').linkbutton("disable");
				$('#btnEdit').linkbutton("disable");
				$('#btnDelete').linkbutton("disable");
				$('#btnCancelEdit').linkbutton("enable");
				$("#cboOrdGroup").combogrid("enable");
				break;
			case "btnEdit":
				$('#btnAdd').linkbutton("disable");
				$('#btnEdit').linkbutton("disable");
				$('#btnDelete').linkbutton("disable");
				$('#btnCancelEdit').linkbutton("enable");
				$("#cboOrdGroup").combogrid("disable");
				break;
			case "btnDelete":
				$('#btnAdd').linkbutton("enable");
				$('#btnEdit').linkbutton("disable");
				$('#btnDelete').linkbutton("disable");
				$('#btnCancelEdit').linkbutton("enable");
				$("#cboOrdGroup").combogrid("enable");
				break;
			default:
				if (obj.curOrdGrpID==""){
					$('#btnAdd').linkbutton("enable");
					$('#btnEdit').linkbutton("disable");
					$('#btnDelete').linkbutton("disable");
					$('#btnCancelEdit').linkbutton("disable");
				}else{
					$('#btnAdd').linkbutton("disable");
					$('#btnEdit').linkbutton("enable");
					$('#btnDelete').linkbutton("enable");
					$('#btnCancelEdit').linkbutton("disable");
				}
				$("#cboOrdGroup").combogrid("enable");
		}			
	}

}