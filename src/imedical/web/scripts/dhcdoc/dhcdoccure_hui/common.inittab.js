$(window).load(function(){
	var winheight=window.screen.availHeight;
	if($("#tabs").length >0){
		$HUI.tabs("#tabs",{
			onSelect: function(cfg,index) {
				//ˢ��iframe�е�datagrid
				var refresh_tab = cfg.tabTitle?$(this).tabs('getTab',cfg.tabTitle):$(this).tabs('getSelected');//��ȡ��ѡ����tab 
			    if(refresh_tab){
			    	if(refresh_tab.find('iframe').length > 0){ 
					    var _refresh_ifram = refresh_tab.find('iframe')[0];//��ȡ��ѡ����tab�µ�iframe
					    if(_refresh_ifram){
							var newurl=""
							if(newurl==""){
					    		_refresh_ifram.contentWindow.location.reload(true);//ˢ�µ�ǰҳ��
							}else{
								refreshTab({tabTitle:title,url:newurl}); 
							}
							
					    } else{ 
					    	refind.click();//�ҵ�Ԫ��IDʱ�����е���¼�ˢ�¡�
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
	if (title==$g("ԤԼ")){
		appList_appResListObj.SelectScheduleTab();
		appList_appListObj.CureApplyAppDataGridLoad();
	}
	else if (title==$g("ԤԼ�б�")){
		appList_appListObj.CureApplyAppDataGridLoad();
	}
	else if (title==$g("���ƴ���")){
		if(typeof appList_execObj != "undefined"){
			appList_execObj.CureExecDataGridLoad();
		}else{
			workList_AppListObj.CureWorkApplyAppDataGridLoad();
		}
	}
	else if (title==$g("����")){
		appList_triageResListObj.CureRBCResListDataGridLoad();
	}
	else if (title==$g("�����б�")){
		appList_triageListObj.CureTriageListDataGridLoad();
	}
	else if (title==$g("���Ƽ�¼�б�")){
		workList_RecordListObj.CureRecordDataGridLoad();
	}
	else if (title==$g("��������")){
		workList_AssListObj.CureAssessmentDataGridLoad();
	}
	else if (title==$g("ֱ��ִ��")){
		appList_execObj.CureExecDataGridLoad();
	}
	else{
		$.messager.alert("��ʾ","����'common.inittab.js'��'DataGridLoad'���������ҳǩGrid���ݼ��ط���","info")
	}
		
}