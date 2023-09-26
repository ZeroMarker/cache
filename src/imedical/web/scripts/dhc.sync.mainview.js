//DHC.Sync.MainView.js
$(function(){
	
	$("#tt").tabs("add",{
		title:"业务系统维护",
		content:''
	});	
	$("#tt").tabs("add",{
		title:"用户类别",
		content:''
	});
	$("#tt").tabs("add",{
		title:"密码修改",
		content:''
	});
	$("#tt").tabs("add",{
		title:"密码修改(需原密码)",
		content:''
	});	
	$("#tt").tabs("add",{
		title:"操作日志",
		content:''
	});
	$("#tt").tabs("add",{
		title:"科室信息",
		content:''
	});
	$("#tt").tabs("add",{
		title:"用户信息",
		content:'<iframe src="websys.default.jquery.csp?WEBSYS.TCOMPONENT=dhc.sync.data.User" scrolling="no" frameborder="0" style="width:100%;height:100%;"></iframe>'
	});
	var links = ["websys.default.jquery.csp?WEBSYS.TCOMPONENT=dhc.sync.data.System",
	"websys.default.jquery.csp?WEBSYS.TCOMPONENT=dhc.sync.data.UserType",
	"websys.default.jquery.csp?WEBSYS.TCOMPONENT=dhc.sync.data.password",
	"websys.default.jquery.csp?WEBSYS.TCOMPONENT=dhc.sync.data.srcpassword",
	"websys.default.jquery.csp?WEBSYS.TCOMPONENT=dhc.sync.data.changelog",
	"websys.default.jquery.csp?WEBSYS.TCOMPONENT=dhc.sync.data.Loc",
	"websys.default.jquery.csp?WEBSYS.TCOMPONENT=dhc.sync.data.User"
	]
	$("#tt").tabs("options").onSelect=function(title,index){
		var tab = $("#tt").tabs("getTab",index);
		if(tab.panel("options").content==""){
			$("#tt").tabs("update",{
				tab:tab,
				options:{
					content:'<iframe src="'+links[index]+'" scrolling="no" frameborder="0" style="width:100%;height:100%;"></iframe>'
				}
			});
		}
		//tab.panel();		
	}	
	//var frame=$('iframe', tab);if(frame.length>0){frame[0].contentWindow.document.write('');frame[0].contentWindow.close();frame.remove();if($.browser.msie){CollectGarbage();}}   	
});