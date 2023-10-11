//页面Event
function InitLocRelevWinEvent(obj){
	/*$HUI.combobox('#cboCat',{
		onChange:function(){
    			obj.gridLocRelevLoad();
		}
	});*/
	//检索框
	$('#searchbox').searchbox({ 
		searcher:function(value,name){
			searchText($("#gridLoc"),value);
		}	
	});
	
	//编辑窗体
	obj.SetDiaglog=function(){
		$('#layer').dialog({
			title: '科室相关性编辑',
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
					$HUI.dialog('#layer').close();
				}
			}]
		});
	}
		//按钮初始化
    obj.LoadEvent = function(args){ 
    	obj.gridLocRelevLoad();
    	obj.gridLocLoad('');
		//新增
		$('#btnAdd').on('click', function(){
			$.messager.alert("提示" , '不选中左侧列表时点击右侧列表的关联按钮即可添加!');
		});
    	//修改
		$('#btnEdit').on('click', function(){
			var rd=obj.gridLocRelev.getSelected();
			obj.InitDialog(rd);
		});
		//删除
		$('#btnDelete').on('click', function(){
			obj.btnDelete_click();
		});
		
    }
    
		//关联与取消关联按钮(添加)
		obj.Relev_Click = function(aLocID,aRelevID){
			var errinfo="";
			var selectedRows = obj.gridLocRelev.getSelected();
			if ( selectedRows == null ) {
				//新增科室相关性
				obj.ClickLocID = aLocID;
				obj.InitDialog();
				return;
			} else {
				//判断 取消最后关联
				if((aRelevID==1)&&(obj.relevCount==1)){
					errinfo = errinfo + "请点击删除按钮!";
				}
				if (errinfo != '') {
					$.messager.alert('info', errinfo);
					return;
				}
				//关联和取消关联
				obj.ClickLocID = "";
				var rd = obj.gridLocRelev.getSelected();
				
				var flg = $m({
					ClassName:"DHCHAI.BTS.LocRelevantSrv",
					MethodName:"relateRelevLoc",
					aRelevID:obj.RecRowID,
					aLocID:aLocID,
					aUserID:$.LOGON.USERID
				},false);
				if (parseInt(flg) <= 0) {
					$.messager.alert("保存失败!Error=" + flg, 'info');
				}else{
					$.messager.popover({msg: '保存成功！',type:'success',timeout: 1000});
					obj.gridLocRelevLoad();
					obj.gridLocLoad(obj.RecRowID);//刷新当前页
				}
			}
	    }
    //双击编辑事件
	obj.gridLocRelev_onDbselect = function(rd){
		obj.InitDialog(rd);
	}
	//保存
	obj.btnSave_click = function(){
		var rd = obj.layer_rd;
		var errinfo = "";
		var LocIDList = (rd ? rd["LocIDList"].split(",").join("|") : '');
		var Name = $('#txtName').val();
		var IsActive = $("#chkActive").checkbox('getValue')? '1':'0';
		var CatValue = $('#cboCat').combobox('getValue');
		
		if (!CatValue) {
			errinfo = errinfo + "分类不可为空!<br>";
		}	
		if (errinfo) {
			$.messager.alert("错误提示", errinfo, 'info');
			return;
		}
		var InputStr = obj.RecRowID;
		InputStr += "^" + Name;
		InputStr += "^" + CatValue;
		InputStr += "^" + (LocIDList==""?obj.ClickLocID:LocIDList);
		InputStr += "^" + IsActive;
		InputStr += "^^^" + $.LOGON.USERID;
		var flg = $m({
			ClassName:"DHCHAI.BT.LocRelevant",
			MethodName:"Update",
			aInputStr:InputStr,
			aSeparete:"^"
		},false);
		if (parseInt(flg) <= 0) {
			if(parseInt(flg) == -2){
				$.messager.alert("代码重复!" , 'info');
			}else{
				$.messager.alert("保存失败!Error=" + flg, 'info');
			}
		}else {
			$HUI.dialog('#layer').close();
			$.messager.popover({msg: '保存成功！',type:'success',timeout: 1000});
			obj.RecRowID = flg
			obj.gridLocRelevLoad();//刷新当前页
		}
	}
	//删除
	obj.btnDelete_click = function(){
		if (obj.RecRowID==""){
			$.messager.alert("提示", "选中数据记录,再点击删除!", 'info');
			return;
		}
		$.messager.confirm("删除", "是否删除选中数据记录?", function (r) {				
			if (r) {				
				var flg = $m({
					ClassName:"DHCHAI.BT.LocRelevant",
					MethodName:"DeleteById",
					aId:obj.RecRowID
				},false);

				if (parseInt(flg) < 0) {
					$.messager.alert("删除失败!Error=" + flg, 'info');
					return;
				} else {
					$.messager.popover({msg: '删除成功！',type:'success',timeout: 1000});
					obj.RecRowID = "";
					obj.gridLocRelevLoad();//刷新当前页
				}
			} 
		});
	}
	
	//选择
	obj.gridLocRelev_onSelect = function (){
		var rowData = obj.gridLocRelev.getSelected();
		var Parref  = (rowData ? rowData["ID"] : '');
		if (rowData["ID"] == obj.RecRowID) {
			obj.RecRowID="";
			$("#btnAdd").linkbutton("enable");
			$("#btnEdit").linkbutton("disable");
			$("#btnDelete").linkbutton("disable");
			obj.gridLocRelev.clearSelections();
		} else {
			obj.RecRowID = rowData["ID"];
			$("#btnAdd").linkbutton("disable");
			$("#btnEdit").linkbutton("enable");
			$("#btnDelete").linkbutton("enable");
		}
		obj.gridLocLoad(Parref);
	}
	obj.gridLoc_onSelect=function(){
		var rowData = obj.gridLoc.getSelected();
	}
    
    obj.InitDialog= function(rd){
		if(rd){
			obj.RecRowID=rd["ID"];
			obj.layer_rd=rd
			var Name = rd["Name"];
			var IsActive = rd["IsActive"];
			IsActive = (IsActive=="1"? true: false)
			$('#txtName').val(Name);
			$('#chkActive').checkbox('setValue',IsActive);
		}else{
			obj.RecRowID="";
			obj.layer_rd=""
			$('#txtName').val('');
			$('#chkActive').checkbox('setValue',false);
		}
			$('#layer').show();
			obj.SetDiaglog();
	}
    
    obj.gridLocRelevLoad = function(){
			$("#gridLocRelev").datagrid("loading");	
			$cm ({
			    ClassName:"DHCHAI.BTS.LocRelevantSrv",
				QueryName:"QryLocRelev",	
				aTypeID:$("#cboCat").combobox('getValue'),	
				aIsActive:"1",
		    	page:1,
				rows:200
			},function(rs){
				$('#gridLocRelev').datagrid({loadFilter:pagerFilter}).datagrid('loadData', rs);					
			});
	}
    obj.gridLocLoad = function(aRelevID){
			$("#gridLoc").datagrid("loading");	
			$cm ({
			    ClassName:"DHCHAI.BTS.LocRelevantSrv",
				QueryName:"QryLoc",	
				aHospIDs:"",
				aAlias:"",
				aLocCate:"",
				aLocType:"",
				aIsActive:"1",
				aRelev:aRelevID,
		    	page:1,
				rows:200
			},function(rs){
				$('#gridLoc').datagrid({loadFilter:pagerFilter}).datagrid('loadData', rs);					
			});
	}
}