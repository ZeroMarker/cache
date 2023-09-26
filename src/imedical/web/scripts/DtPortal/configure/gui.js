//DHC.Sync.MainView.js
$(function(){
	//$("#configureTitle").tabs("add",{
	//	title:"视图管理",
	//	content:''
	//});
	$("#configureTitle").tabs("add",{
		title:"数据规则配置",
		content:''
	});
	$("#configureTitle").tabs("add",{
		title:"医嘱配置",
		content:''
	});
	//$("#configureTitle").tabs("add",{
	//	title:"角色配置",
	//	content:''
	//});
	//$("#configureTitle").tabs("add",{
	//	title:"科室组配置",
	//	content:''
	//});
	
	
	var links = [
		"portal.DataRule.csp",
		"portal.arcimConfigure.csp"
	//	"portal.roleConfigure.csp"
	//	"portal.locGroup.csp",
		
	]
	$("#configureTitle").tabs("options").onSelect=function(title,index){
		var tab = $("#configureTitle").tabs("getTab",index);
		if(tab.panel("options").content==""){
			$("#configureTitle").tabs("update",{
				tab:tab,
				selected:2,
				options:{
					content:'<iframe src="'+links[index]+'" scrolling="no" frameborder="0" style="width:100%;height:100%;"></iframe>'
				}
			});
		}	
	}	
	var length=links.length-1;
	var tab = $("#configureTitle").tabs("getTab",length);
	$("#configureTitle").tabs("update",{
				tab:tab,
				options:{
					selected:true,
					content:'<iframe src="'+links[length]+'" scrolling="no" frameborder="0" style="width:100%;height:100%;"></iframe>'
				}
			});
	//var frame=$('iframe', tab);if(frame.length>0){frame[0].contentWindow.document.write('');frame[0].contentWindow.close();frame.remove();if($.browser.msie){CollectGarbage();}}   	
});