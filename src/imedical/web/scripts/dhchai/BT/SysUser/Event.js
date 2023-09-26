//页面Event
function InitSysUserWinEvent(obj){
	/*****搜索功能*****/
    $("#btnsearch").on('click', function(){
       $('#gridSysUser').DataTable().search($('#search').val(),true,true).draw();
       
    });
	
    $("#search").keyup(function(event){
        if (event.keyCode == 13) {
	        obj.gridSysUser.search(this.value).draw();
        }
    });
    /****************/
   
	
	$("#btnsyn").on('click', function(){
		if (!$.LOGON.HISCode) {
			layer.msg('HIS系统代码为空!',{icon: 2});
			return;
		}
		var retval = $.Tool.RunServerMethod("DHCHAI.DI.DHS.SyncHisInfo","SyncSSUser",$.LOGON.HISCode,"",$.LOGON.USERID);
		if (parseInt(retval)>0){
			layer.msg('用户信息同步成功!',{icon: 1});
		} else {
			layer.msg('用户列表同步失败!',{icon: 2});
		}
		obj.gridSysUser.ajax.reload();
	});

}