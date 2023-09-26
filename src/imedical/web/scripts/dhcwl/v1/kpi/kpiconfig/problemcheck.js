var init=function(){
	/*$HUI.datagrid("#kpiProblemCheckGrid",{
		url:$URL,
		queryParams:{
			ClassName:'web.DHCWL.V1.KPI.SysConfigFunction',
			QueryName:'GetKPIErrInforQuery'
		},
		fitColumns:true
	})*/
	
	
	var checkObj = $HUI.datagrid("#kpiProblemCheckGrid",{
		url:$URL,
		queryParams:{
			ClassName:'web.DHCWL.V1.KPI.SysConfigFunction',
			QueryName:'GetKPIErrInforQuery'
		},
		fitColumns:true,
		toolbar:[{
			iconCls:'icon-ok',
			text:'开始检查',
			handler:function(){
				checkObj.load({ClassName:'web.DHCWL.V1.KPI.SysConfigFunction',QueryName:'GetKPIErrInforQuery',flag:1});
			}
		}],
		onDblClickCell: function(index,field,value){
			if (field == "errInfor"){
				$("#errShowDialog").show();
				$HUI.dialog("#errShowDialog",{
					modal:true,
					resizable:true
				})
				$("#errShowTextbox").val(value);
			}
		}
	})
}
init();