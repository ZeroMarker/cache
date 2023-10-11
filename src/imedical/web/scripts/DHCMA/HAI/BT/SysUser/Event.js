//页面Event
function InitWinEvent(obj){
	//事件初始化
	obj.LoadEvent = function(args){
		obj.gridSysUserLoad();
		$('#btnSyn').on('click', function(){
			obj.SyncSSUser();
		});
     }
	//选择
	obj.gridSysUser_onSelect = function (){
		var rowData = obj.gridSysUser.getSelected();

		if (rowData["ID"] == obj.RecRowID) {
			obj.RecRowID="";
			obj.gridSysUser.clearSelections();
		} else {
			obj.RecRowID = rowData["ID"];
		}
	}
    $('#searchbox').searchbox({
        searcher: function (value, name) {
            searchText($("#gridSysUser"), value);
        }
    });
	//核心方法-同步
	obj.SyncSSUser=function(){

		if (!$.LOGON.HISCode) {
			$.messager.alert("错误提示", "HIS系统代码为空!" , 'info');
			return;
		}
		var retval = $m({
			ClassName:"DHCHAI.DI.DHS.SyncHisInfo",
			MethodName:"SyncSSUser",
			aSCode:$.LOGON.HISCode,
			aHospCode:"",
			aUserID:$.LOGON.USERID
		},false)
	
		if (parseInt(retval)>0){
			$.messager.popover({msg: '用户信息同步成功！',type:'success',timeout: 1000});
		} else {
			$.messager.alert("错误提示", "用户列表同步失败!Error=" + retval, 'info');
		}
		obj.gridSysUser.reload();	
		
	}
    obj.gridSysUserLoad = function () {
        originalData["#gridSysUser"]="";
        //$("#gridSysUser").datagrid("loading"); //加载中提示信息
        $cm({
            ClassName:"DHCHAI.BTS.SysUserSrv",
            QueryName:"QrySysUser",
            page: 1,
            rows: 9999
        }, function (rs) {
            $('#gridSysUser').datagrid({ loadFilter: pagerFilter }).datagrid('loadData', rs);
        });
    }
}
