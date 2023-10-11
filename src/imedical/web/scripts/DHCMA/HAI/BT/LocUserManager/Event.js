//手术切口调查表[Event]
function InitLocUserEvent(obj) {
	
    //初始化
    obj.LoadEvent=function(){
		//加载表格
		obj.refreshLocUser();
	}
	 //检索框
    $('#searchbox').searchbox({
        searcher: function (value, name) {
	        if(value=="") {
		       obj.refreshLocUser();
		    } else {
			    searchText($("#gridLocUser"), value);
			}           
        }
    });
   obj.gridLocUser_onSelect = function(){
	   var rowData = obj.gridLocUser.getSelected();

		if (rowData["ID"] == obj.RecRowID) {
			obj.RecRowID="";
			obj.gridLocUser.clearSelections();
		} else {
			obj.RecRowID = rowData["ID"];
		}
	   
   }
   //双击编辑
	obj.gridLocUser_onDbselect = function(rd){
		obj.InitDialog(rd);
	}
    //刷新表
    obj.refreshLocUser = function () {
       
        var Ret = $cm({
			ClassName:"DHCHAI.BTS.LocUserManagerSrv",
			QueryName:"QryLocUserManager",
			aDateFrom: "",
            aDateTo: "",
            aLocID: "",
            aHospIDs: "",
            page: 1,
            rows: 99999
        }, function (rs) {
            $('#gridLocUser').datagrid({ loadFilter: pagerFilter }).datagrid('loadData', rs);
		});
		
    }
	//窗体-初始化
	obj.InitDialog= function(rows){
		if(!rows){
			obj.RecRowID="";
			$('#cboLoc').combobox('clear');
			$('#txtPhone').val("");
			
			$('#cboUser').combobox('clear');
			$('#dtEffect').datebox('setValue', Common_GetDate(new Date()));
			$('#dtExpiry').datebox('setValue',"");
			/*$.messager.alert("提示","先选择某一行再执行该操作!", 'info');
			return;*/
	    }else {
			obj.RecRowID=rows["xID"];
			$('#cboLoc').combobox('setValue',rows["xLocID"]);
			$('#cboUser').combobox('setValue',rows["UserID"]);
			$('#txtPhone').val(rows["PhoneNo"]);
		    $('#dtEffect').datebox('setValue', rows["EffectDate"]);
			$('#dtExpiry').datebox('setValue',rows["ExpiryDate"]);

			$('#chkIsActive').checkbox('setValue',(rows["IsActive"]=='是' ? true : false));
			
		}
		$('#winEdit').show();
		$('#winEdit').dialog({
			title: '编辑',
			iconCls:'icon-w-paper',
			modal: true,
			isTopZindex:true,
		});
		
	}
	$('#btnEdit').on('click', function () {
		var rows =  $('#gridLocUser').datagrid('getSelected');
        obj.InitDialog(rows);
    });
	$('#btnClose').on('click', function () {
		$HUI.dialog('#winEdit').close();
	});
	$('#btnSave').on('click', function () {
		obj.Save();
	});
	//核心方法-更新
	obj.Save = function(){
		var errinfo = "";
		var UserID = $('#cboUser').combobox('getValue');
		var LocID = $('#cboLoc').combobox('getValue');
		var Phone = $('#txtPhone').val();
		var EffectDate = $('#dtEffect').datebox("getValue");
		var ExpiryDate = $('#dtExpiry').datebox("getValue");
		var IsActive = ($("#chkIsActive").checkbox('getValue')? 1 : 0);
		
		if (!UserID) {
			errinfo = errinfo + "请重新填写用户信息!<br>";
		}
		if (!LocID) {
			errinfo = errinfo + "请重新填写科室信息!<br>";
		}
		if (errinfo) {
			$.messager.alert("错误提示", errinfo, 'info');
			return ;
		}
		var InputStr=obj.RecRowID;
		InputStr += "^" + UserID;
		InputStr += "^" + LocID;
		InputStr += "^" + Phone;
		InputStr += "^" + EffectDate;
		InputStr += "^" + ExpiryDate;
		InputStr += "^" + IsActive;
		
		var flg = $m({
			ClassName:"DHCHAI.BTS.LocUserManagerSrv",
			MethodName:"Update",
			aInputStr:InputStr,
		},false);
		if (parseInt(flg)> 0) {
			obj.RecRowID = "";
			obj.refreshLocUser();		//刷新当前页
			$HUI.dialog('#winEdit').close();
			$.messager.popover({msg: '保存成功！',type:'success',timeout: 1000});
		}else if(parseInt(flg) == '-2'){
			$.messager.alert("错误提示", "代码重复!" , 'info');
		}else{
			$.messager.alert("错误提示", "保存失败!Error=" + flg, 'info');
		}
		//清除选中
		obj.gridLocUser.clearSelections();
	}
}