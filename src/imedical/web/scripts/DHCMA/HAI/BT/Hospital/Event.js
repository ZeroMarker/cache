//页面Event
function InitWinEvent(obj){
	//事件初始化
	obj.LoadEvent = function(args){
		obj.gridHospitalLoad();
		
		$('#btnSyn').on('click', function(){
			obj.SyncHosp();
		});
		
		$('#btnEdit').on('click', function(){
			var rd=obj.gridHospital.getSelected()
			obj.InitDialog(rd);
		});
		
		$('#winBtnSave').on('click', function(){
			obj.SaveHosp();
		});
		
		$('#winBtnClose').on('click', function(){
			$HUI.dialog('#winEdit').close();
		});
     }
    //双击编辑
	obj.gridHospital_onDbselect = function(rd){
		obj.InitDialog(rd);
	}
	//选择
	obj.gridHospital_onSelect = function (){
		var rowData = obj.gridHospital.getSelected();

		if (rowData["ID"] == obj.RecRowID) {
			obj.RecRowID="";
			$("#btnSyn").linkbutton("enable");
			$("#btnEdit").linkbutton("disable");
			obj.gridHospital.clearSelections();
		} else {
			obj.RecRowID = rowData["ID"];
			$("#btnSyn").linkbutton("disable");
			$("#btnEdit").linkbutton("enable");
		}
	}
	
	//核心方法-同步
	obj.SyncHosp=function(){
		
		if (!$.LOGON.HISCode) {
			$.messager.alert("错误提示", "HIS系统代码为空!" , 'info');
			return;
		}
		var retval = $m({
			ClassName:"DHCHAI.DI.DHS.SyncHisInfo",
			MethodName:"SyncHospital",
			aSCode:$.LOGON.HISCode,
			aUserID:$.LOGON.USERID
		},false)

		if (parseInt(retval)>0){
			$.messager.popover({msg: '医院信息同步成功！',type:'success',timeout: 1000});
		} else {
			$.messager.alert("错误提示", "医院列表同步失败!Error=" + retval, 'info');
		}
		obj.gridHospital.reload();	
		
	}
	//核心方法-更新
	obj.SaveHosp = function(){
		var errinfo = "";
		var Code = $('#txtCode').val();
		var Desc = $('#txtDesc').val();
		var Desc2 = $('#txtDesc2').val();
		var HospGroupDr = $('#cboHospGroup').combobox("getValue");
		var IsActive = ($("#chkIsActive").checkbox('getValue')? 1 : 0);
		var ActUserDr = $.LOGON.USERID;
		
		if (!Code) {
			errinfo = errinfo + "组织机构代码不允许为空!<br>";
		}
		if (!Desc) {
			errinfo = errinfo + "医疗机构名称不允许为空!<br>";
		}
		if (!HospGroupDr) {
			errinfo = errinfo + "医院分组不允许为空!<br>";
		}
		if (errinfo) {
			$.messager.alert("错误提示", errinfo, 'info');
			return ;
		}
		
		var XCode=obj.XCode;
		if (!XCode){
			$.messager.alert("错误提示", "不知名错误，请刷新页面！", 'info');
			return ;
		}
		
		var InputStr=obj.RecRowID;
		InputStr += "^" + Code;
		InputStr += "^" + Desc;
		InputStr += "^" + Desc2;
		InputStr += "^" + HospGroupDr;
		InputStr += "^" + XCode;
		InputStr += "^" + IsActive;
		InputStr += "^" + "";
		InputStr += "^" + "";
		InputStr += "^" + ActUserDr;
		
		var flg = $m({
			ClassName:"DHCHAI.BT.Hospital",
			MethodName:"Update",
			aInputStr:InputStr,
		},false);
		if (parseInt(flg)> 0) {
			obj.RecRowID = "";
			obj.gridHospitalLoad();		//刷新当前页
			$HUI.dialog('#winEdit').close();
			$.messager.popover({msg: '保存成功！',type:'success',timeout: 1000});
		}else if(parseInt(flg) == '-2'){
			$.messager.alert("错误提示", "代码重复!" , 'info');
		}else{
			$.messager.alert("错误提示", "保存失败!Error=" + flg, 'info');
		}
		//清除选中
		obj.RecRowID="";
		$("#btnSyn").linkbutton("enable");
		$("#btnEdit").linkbutton("disable");
		obj.gridHospital.clearSelections();
	}
	// 加载（前台）分页
	obj.gridHospitalLoad = function(){
		$cm ({
		    ClassName:"DHCHAI.BTS.HospitalSrv",
			QueryName:"QryHospital",
	    	page:1,
			rows:9999
		},function(rs){
			$('#gridHospital').datagrid({loadFilter:pagerFilter}).datagrid('loadData', rs);					
		});
    }
    //窗体-初始化
	obj.InitDialog= function(rd){
		if(rd){
			$('#txtCode').val(rd["BTCode"]).validatebox("validate");
			$('#txtDesc').val(rd["BTDesc"]).validatebox("validate");
			$('#txtDesc2').val(rd["BTDesc2"]);
			$('#cboHospGroup').combobox("setValue",rd["BTGroupDr"]);
			$('#cboHospGroup').combobox("setText",rd["BTGroupDesc"]);
			
			$('#chkIsActive').checkbox('setValue',(rd["BTIsActive"]=='1' ? true : false));
			obj.RecRowID=rd["ID"];
			obj.XCode=rd["BTXCode"];
			$('#winEdit').show();
			$('#winEdit').dialog({
				title: '医院信息维护编辑',
				iconCls:'icon-w-paper',
				modal: true,
				isTopZindex:true,
			});
		}
	}
}
