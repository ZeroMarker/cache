$(window).load(function(){
	var winheight=window.screen.availHeight;
	if($("#tabs").length >0){
		$HUI.tabs("#tabs",{
			onSelect: function(cfg,index) {
				//刷新iframe中的datagrid
				var refresh_tab = cfg.tabTitle?$(this).tabs('getTab',cfg.tabTitle):$(this).tabs('getSelected');//获取到选定的tab 
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
				    	var title = cfg; //$('.tabs-selected').text();
				    	if(typeof(PageAppListAllObj)=="object"){
					    	PageAppListAllObj.m_selTabTitle=title;
				    	}
				    	//setTimeout(function(){
					    	if(typeof(CureApplyDataGridLoad)=="function"){
					    		if((typeof(ServerObj)=="object")){
					    			if((ServerObj.CureAppVersion=="V1")&&(ServerObj.DHCDocCureAppQryNotWithTab!="1")){
					    				CureApplyDataGridLoad();
					    			}else{
						    			CheckSelectRow()
						    		}
					    		}
					    	}
					    	DataGridLoad(title);
					    //},200)
				    }
			    }       
			}
		}); 
	}
});

function DataGridLoad(title){
	title=$g(title)
	if (title==$g("预约")){
		appList_appResListObj.SelectScheduleTab();
		appList_appListObj.CureApplyAppDataGridLoad();
	}
	else if (title==$g("预约列表")){
		appList_appListObj.CureApplyAppDataGridLoad();
	}
	else if (title==$g("治疗处理")){
		if(typeof appList_execObj != "undefined"){
			appList_execObj.CureExecDataGridLoad();
		}else{
			workList_AppListObj.CureWorkApplyAppDataGridLoad();
		}
	}
	else if (title==$g("分配")){
		appList_triageResListObj.CureRBCResListDataGridLoad();
	}
	else if (title==$g("分配列表")){
		appList_triageListObj.CureTriageListDataGridLoad();
	}
	else if (title==$g("治疗记录列表")){
		workList_RecordListObj.CureRecordDataGridLoad();
	}
	else if (title==$g("治疗评估")){
		workList_AssListObj.CureAssessmentDataGridLoad();
	}
	else if (title==$g("直接执行")){
		appList_execObj.CureExecDataGridLoad();
	}
	else{
		$.messager.alert("提示","请在'common.inittab.js'的'DataGridLoad'方法中添加页签Grid数据加载方法","info")
	}
		
}