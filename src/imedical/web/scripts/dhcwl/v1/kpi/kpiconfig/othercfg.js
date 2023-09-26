$("#dimProAddButton").click(function(e){
	$.messager.confirm("提示","您确定操作么？",function(r){
		if (r){
			$m({
				ClassName:'web.DHCWL.V1.KPI.SysConfigFunction',
				MethodName:'AddGrpAndSubgrp'
			},function(e){
				myMsg(e);
			})
		}
	})
})