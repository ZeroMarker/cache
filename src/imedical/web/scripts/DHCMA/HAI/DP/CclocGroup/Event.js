function InitCCLocGroupLocWinEvent(obj){
	
	//初始tab页签
	var tab = $('#divTabs').tabs('getSelected');
	var index = $('#divTabs').tabs('getTabIndex',tab);
	if (index==0) {
		$("#divtab0").css('display','block');			
	}	
	$HUI.tabs("#divTabs",{
		onSelect:function(title,index){
			obj.type=index;
			obj.SysUserID="";
			obj.LocID="";
			obj.LocGrpID="";
			$('#searchbox2').searchbox('clear');
			if (index==0){
				//清除选中
				obj.gridLocation.clearSelections();
				$("#divtab0").css('display','block');
				$("#divgridUser").removeAttr("style");	
				loadgridUser();
			}	
			if (index==1){
				//清除选中
				obj.gridSysUser.clearSelections();
				$("#divtab1").css('display','block');
				$("#divtab0").css('display','none');
				loadgridLoc();
			}
		}
	});
	
	$("#cboLocGrpType,#cboHospital").combobox({
         onChange:function(){
            obj.gridLocationLoad();
        }
    });

    //检索框
	$('#searchbox').searchbox({ 
		searcher:function(value,name){
			obj.gridLocationLoad();
		}	
	});

    //加载明细
	obj.gridLocationLoad = function(){
		 //后台加载刷新
        obj.gridLocation.load({
           ClassName:'DHCHAI.IRS.CCLocGroupSrv',
			QueryName:'QryLoc',
			aHospIDs:$("#cboHospital").combobox('getValue'),
			aGrpType:$("#cboLocGrpType").combobox('getValue'),
			aAlias:$('#searchbox').searchbox('getValue'), 
			aLocCate:"",
			aLocType:"",
			aIsActive:""
        })
    } 
	
	$("#cboLocGrpTypeT,#cboHospitalT").combobox({
         onChange:function(){
            obj.gridSysUserLoad();
        }
    });
    //检索框
	$('#searchboxT').searchbox({ 
		searcher:function(value,name){
			searchText($("#gridSysUser"),value);
		}	
	});
	$('#btnEditT').on('click', function(){
		 var rd=obj.gridSysUser.getSelected();
         obj.InitDiagPhone(rd);
    });
	
	//加载明细
	obj.gridSysUserLoad = function(){
		 //后台加载刷新
        obj.gridSysUser.load({
            ClassName:'DHCHAI.BTS.SysUserSrv',
			QueryName:'QrySysUserList',
			aLocID:"", 
			aTypeID:"", 
			aUserName:"",
			aUserCode:"", 
			aIsActive:"",
			aHospID:$("#cboHospitalT").combobox('getValue')
        })
    } 

	//编辑窗体
	obj.InitDiagPhone=function(rd){
		
		obj.SysUserID=rd["ID"];
		$('#txtUserCode,#txtUserDesc,#txtUserLoc').attr('disabled','disabled');
		$('#txtUserCode').val(rd["UserCode"]);
		$('#txtUserDesc').val(rd["UserDesc"]);
		$('#txtUserLoc').val(rd["LocDesc"]);
		$('#txtUserPhone').val(rd["PhoneNo"]);
		
		$('#EidtPhone').show();
			
		$('#EidtPhone').dialog({
			title: '手机号维护',
			iconCls:"icon-w-paper",
			modal: true,
			isTopZindex:false,
			buttons:[{
				text:'保存',
				handler:function(){
					obj.SavePhone();
				}
			},{
				text:'关闭',
				handler:function(){
					$HUI.dialog('#EidtPhone').close();
				}
			}]
		});
	}
    
    obj.SavePhone = function(){
		var Phone = $('#txtUserPhone').val();		
		if (!Phone) {
			$.messager.alert("错误提示","请填写手机号！",'info');
			return ;
		}
		var isMblNum = /^[1][3,4,5,7,8,9][0-9]{9}$/;
        var isPhNum = /^((0\d{2,3})-)(\d{7,8})(-(\d{3,}))?$/;
        if (!isMblNum.test(Phone) && !isPhNum.test(Phone)) {
            $.messager.alert("提示", "手机号格式有误!", 'info');
            return false;
        }

		var flg = $m({
			ClassName:"DHCHAI.BT.SysUser",
			MethodName:"ChangePhone",
			aUserId:obj.SysUserID,
			aPhone:Phone
		},false);
		if (parseInt(flg)> 0) {
			var rows = $('#gridSysUser').datagrid('getSelected');
			var index = $("#gridSysUser").datagrid('getRowIndex', rows);
			$('#gridSysUser').datagrid('updateRow',{
				index: index,
				row: {
					PhoneNo:Phone
				}
			});
			$HUI.dialog('#EidtPhone').close();
			$.messager.popover({msg: '保存成功！',type:'success',timeout: 1000});
		}else{
			$.messager.alert("错误提示", "保存失败!Error=" + flg, 'info');
		}
	}
		
    //责任人/责任科室维护
	$('#btnEdit').on('click', function(){
        var rd=$('#gridUser').datagrid('getSelected');       
        if (obj.type==1) {
			obj.InitDiagLoc(rd);
		}else {
			obj.InitDiaglog(rd);
		}
    });
	$('#btnAdd').on('click', function(){
        if (obj.type==1) {
			obj.InitDiagLoc("");
		}else {
			obj.InitDiaglog("");
		}
    });
	$('#btnDelete').on('click', function(){
       var rd=$('#gridUser').datagrid('getSelected'); 
        if (rd["ID"]==""){
			$.messager.alert("提示", "选中数据记录,再点击删除!", 'info');
			return;
		}
		$.messager.confirm("删除", "是否删除选中数据记录?", function (r) {				
			if (r) {				
				var flg = $m({
					ClassName:"DHCHAI.IR.CCLocGroup",
					MethodName:"DeleteById",
					aId:rd["ID"]
				},false);
				if (flg == '0') {
					if (obj.type==1) {  //刷新
						obj.gridLocLoad();
					}else {
						obj.gridUserLoad();
					}
					$.messager.popover({msg: '删除成功！',type:'success',timeout: 1000});
				} else {
					if (parseInt(flg)=='-777') {
						$.messager.alert("错误提示","-777：当前无删除权限，请启用删除权限后再删除记录!",'info');
					}else {
						$.messager.alert("错误提示","删除失败!Error=" + flg, 'info');
					}			
				}
			}
		});
    });
	
	 
	//检索框
	$('#searchbox2').searchbox({ 
		searcher:function(value,name){
			searchText($("#gridUser"),value);
		}	
	});
	//加载责任人
	obj.gridUserLoad = function(){
		originalData["gridUser"]="";  //重新加载前，初始数据置空
		 //后台加载刷新
        $('#gridUser').datagrid('load',{
            ClassName:'DHCHAI.IRS.CCLocGroupSrv',
			QueryName:'QryUser',
			aGrpType:$("#cboLocGrpType").combobox('getValue'),
			aLocID: obj.LocID,
			aAlias:$('#searchbox2').searchbox('getValue'), 
			aIsActive:""
        })
    }

	//加载责任科室
	obj.gridLocLoad = function(){
		originalData["gridUser"]="";  //重新加载前，初始数据置空
		 //后台加载刷新
        $('#gridUser').datagrid('load',{
            ClassName:'DHCHAI.IRS.CCLocGroupSrv',
			QueryName:'QryUserLocGroup',
			aHospIDs:$("#cboHospitalT").combobox('getValue'),
			aGrpType:$("#cboLocGrpTypeT").combobox('getValue'),
			aUserID: obj.SysUserID
        })
    }
    
	//编辑窗体
	obj.InitDiaglog=function(rd){
		Common_ComboToLoc('cboLoc',$("#cboHospital").combobox('getValue'));
		$('#cboUser').lookup('enable');
		$('#txtPhone').removeAttr("disabled");
		$('#cboLoc').combobox('disable');
		
		if(rd==""){
			$('#cboLoc').combobox('clear');
			if (obj.LocID!=""){
				$('#cboLoc').combobox('setValue',obj.LocID);
			}
			
			$('#txtPhone').val("");
			$('#cboUser').lookup('clear');
			$('#dtEffect').datebox('setValue', Common_GetDate(new Date()));
			$('#dtExpiry').datebox('setValue',"");
			$('#chkIsActive').checkbox('setValue',false);
			obj.LocGrpID=""
	    }else {
			$('#cboLoc').combobox('setValue',rd["LocID"]);
			if (obj.LocID!=""){
				$('#cboLoc').combobox('setValue',obj.LocID);
			}
			$('#cboUser').lookup('setText',rd["UserDesc"]);
			obj.UserID=rd["CCLocUser"];
			$('#cboUserID').val(obj.UserID);
			$('#txtPhone').val(rd["PhoneNo"]);
		    $('#dtEffect').datebox('setValue', rd["BTEffectDate"]);
			$('#dtExpiry').datebox('setValue',rd["BTExpiryDate"]);

			$('#chkIsActive').checkbox('setValue',(rd["IsActive"]=='是' ? true : false));
			obj.LocGrpID=rd["ID"];
		}
		$('#layer').show();
			
		$('#layer').dialog({
			title: '责任人维护',
			iconCls:"icon-w-paper",
			modal: true,
			isTopZindex:false,
			buttons:[{
				text:'保存',
				handler:function(){
					obj.Save();
				}
			},{
				text:'关闭',
				handler:function(){
					$HUI.dialog('#layer').close();
				}
			}]
		});
	}

	//核心方法-更新
	obj.Save = function(){
		var errinfo = "";
		var GrpType=$("#cboLocGrpType").combobox('getValue');
		var UserID = obj.UserID;
		var LocID = $('#cboLoc').combobox('getValue');
		var Phone = $('#txtPhone').val();
		var EffectDate = $('#dtEffect').datebox("getValue");
		var ExpiryDate = $('#dtExpiry').datebox("getValue");
		var IsActive = ($("#chkIsActive").checkbox('getValue')? 1 : 0);
		if (!GrpType){
			errinfo = errinfo + $g("工作组类型获取错误!")+"<br>";
		}
		if (!UserID) {
			errinfo = errinfo + $g("请重新填写用户信息!")+"<br>";
		}
		if (!Phone) {
			errinfo = errinfo + $g("请填写手机号!")+"<br>";
		}
		if ((!EffectDate)&&(ExpiryDate)) {
			errinfo = errinfo +$g("请填写生效日期!")+"<br>";
		}
		if ((EffectDate)&&(ExpiryDate)&&(Common_CompareDate(EffectDate,ExpiryDate))) {
			errinfo = errinfo +$g("生效日期不能大于截止日期!")+"<br>";
		}
		var isMblNum = /^[1][3,4,5,7,8,9][0-9]{9}$/;
        var isPhNum = /^((0\d{2,3})-)(\d{7,8})(-(\d{3,}))?$/;
        if ((Phone)&&(!isMblNum.test(Phone) && !isPhNum.test(Phone))) {
           	errinfo = errinfo + $g("手机号格式错误!")+"<br>";
        }
		if (errinfo) {
			$.messager.alert("错误提示", errinfo, 'info');
			return ;
		}
		var InputStr=obj.LocGrpID;
		InputStr += "^" + LocID;
		InputStr += "^" + GrpType;
		InputStr += "^" + UserID;
		InputStr += "^" + Phone;
		InputStr += "^" + $.LOGON.USERID;
		InputStr += "^" + EffectDate;
		InputStr += "^" + ExpiryDate;
		InputStr += "^" + IsActive;
		
		var flg = $m({
			ClassName:"DHCHAI.IRS.CCLocGroupSrv",
			MethodName:"Update",
			aInputStr:InputStr,
		},false);
		if (parseInt(flg)> 0) {
			obj.gridUserLoad();		//刷新
			$HUI.dialog('#layer').close();
			$.messager.popover({msg: '保存成功！',type:'success',timeout: 1000});
		}else{
			$.messager.alert("错误提示", "保存失败!Error=" + flg, 'info');
		}
		//清除选中
		$('#gridUser').datagrid('clearSelections');
	}
	
	
	//编辑窗体
	obj.InitDiagLoc=function(rd){
		Common_ComboToMSLoc("cboLoc",$("#cboHospital").combobox('getValue'));
		
		$('#cboUserID').val(obj.SysUserID);
		$('#cboUser').lookup('setText',obj.UserDesc);
		$('#cboUser').lookup('disable');
		$('#txtPhone').val(obj.PhoneNum);
		$('#txtPhone').attr('disabled','disabled');
		$('#cboLoc').combobox('enable');
	
		if(rd==""){				
			$('#cboLoc').combobox('clear');
			$('#dtEffect').datebox('setValue', Common_GetDate(new Date()));
			$('#dtExpiry').datebox('setValue',"");
			$('#chkIsActive').checkbox('setValue',false);
	    }else {
		    $('#cboLoc').combobox ({    //修改时应只能单选
			   multiple:false, 
		    })
			$('#cboLoc').combobox('setValue',rd["LocID"]);
		    $('#dtEffect').datebox('setValue', rd["EffectDate"]);
			$('#dtExpiry').datebox('setValue',rd["ExpiryDate"]);

			$('#chkIsActive').checkbox('setValue',(rd["IsActive"]==1 ? true : false));
			obj.LocGrpID=rd["ID"];
		}
		$('#layer').show();
			
		$('#layer').dialog({
			title: '责任科室维护',
			iconCls:"icon-w-paper",
			modal: true,
			isTopZindex:false,
			buttons:[{
				text:'保存',
				handler:function(){
					obj.SaveUserLoc();
				}
			},{
				text:'关闭',
				handler:function(){
					$HUI.dialog('#layer').close();
				}
			}]
		});
	}

	//核心方法-更新
	obj.SaveUserLoc = function(){
		var errinfo = "";
		var GrpType=$("#cboLocGrpType").combobox('getValue');
		var UserID = obj.SysUserID;
		var arrLoc = $('#cboLoc').combobox('getValues');
		var Phone = $('#txtPhone').val();
		var EffectDate = $('#dtEffect').datebox("getValue");
		var ExpiryDate = $('#dtExpiry').datebox("getValue");
		var IsActive = ($("#chkIsActive").checkbox('getValue')? 1 : 0);
		var LocIDs = arrLoc.toString();
	
		if (!GrpType){
			errinfo = errinfo + ($g("工作组类型获取错误!")+"<br>");
		}
		
		if (!LocIDs) {
			errinfo = errinfo + ($g("请重新填写科室信息!")+"<br>");
		}
		if (errinfo) {
			$.messager.alert("错误提示", errinfo, 'info');
			return ;
		}
		var Len =arrLoc.length;
		
		var InputStr=obj.LocGrpID;
		InputStr += "^" + LocIDs;
		InputStr += "^" + GrpType;
		InputStr += "^" + UserID;
		InputStr += "^" + Phone;
		InputStr += "^" + $.LOGON.USERID;
		InputStr += "^" + EffectDate;
		InputStr += "^" + ExpiryDate;
		InputStr += "^" + IsActive;
		
		var flg = $m({
			ClassName:"DHCHAI.IRS.CCLocGroupSrv",
			MethodName:"BatchSave",
			aInputStr:InputStr,
			aSeparete:"^"
		},false);
		if (parseInt(flg)> 0) {
			obj.gridLocLoad();		//刷新
			$HUI.dialog('#layer').close();
			$.messager.popover({msg: '保存成功！',type:'success',timeout: 1000});
		}else if(parseInt(flg) == '-2'){
			$.messager.alert("错误提示", "代码重复!" , 'info');
		}else{
			$.messager.alert("错误提示", "保存失败!Error=" + flg, 'info');
		}
		//清除选中
		$('#gridUser').datagrid('clearSelections');
	}

}