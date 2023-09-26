$(window).load(function(){
	var winheight=window.screen.availHeight;
	var tabname="";
	var ops={};
	var DCARowIdStr="";
	var winheightdow=winheight;
	if($("#configtabs").length >0){
		tabname="#configtabs";
		winheightdow=winheightdow*0.7;
	}else if($("#configrbtabs").length >0){
		tabname="#configrbtabs";
		winheightdow=winheightdow*0.7;
	}else if($("#tabs").length >0){
		tabname="#tabs";
		winheightdow=winheightdow*0.38;
	}
	ops={
		height:	winheightdow,
	}
	if(tabname!=""){
		$HUI.tabs(tabname,{
			onSelect: function(cfg,tabTitle) {
				//刷新iframe中的datagrid
				var refresh_tab = cfg.tabTitle?$(tabname).tabs('getTab',cfg.tabTitle):$(tabname).tabs('getSelected');//获取到选定的tab 
			    if(refresh_tab){
			    	if(refresh_tab.find('iframe').length > 0){ 
					    var _refresh_ifram = refresh_tab.find('iframe')[0];//获取到选定的tab下的iframe
					    if(_refresh_ifram){
							var newurl=""
							if(newurl==""){
					    		_refresh_ifram.contentWindow.location.reload(true);//刷新当前页面
							}else{
								refreshTab({tabTitle:title,url:newurl}); 
							}
							
					    } else{ 
					    	refind.click();//找到元素ID时，进行点击事件刷新。
					    }
			    	}else{
				    	var title = $('.tabs-selected').text();
				    	setTimeout(function(){
					    	if(typeof(CureApplyDataGridLoad)=="function"){
					    		CureApplyDataGridLoad();
					    	}
					    	DataGridLoad(title);
					    },100)
				    }
			    }       
			}
		}); 
		
		var tabobj=$HUI.tabs(tabname,ops);
	}
});

function DataGridLoad(title){
	if (title=="预约"){
		CureRBCResSchduleDataGridLoad();
	}else if (title=="预约列表"){
		CureApplyAppDataGridLoad();
	}
	else if (title=="治疗添加"){
		CureWorkApplyAppDataGridLoad();
	}
	else if (title=="可分配资源列表"){
		CureRBCResListDataGridLoad();
	}
	else if (title=="分配列表"){
		CureTriageListDataGridLoad();
	}
	else if (title=="治疗记录列表"){
		CureRecordDataGridLoad();
	}else if (title=="治疗评估"){
		CureAssessmentDataGridLoad();
	}else if (title=="直接执行"){
		CureExecDataGridLoad();
	}else{
		$.messager.alert("提示","请在'common.inittab.js'的'DataGridLoad'方法中添加页签Grid数据加载方法","info")
	}
		
}