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
				//ˢ��iframe�е�datagrid
				var refresh_tab = cfg.tabTitle?$(tabname).tabs('getTab',cfg.tabTitle):$(tabname).tabs('getSelected');//��ȡ��ѡ����tab 
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
	if (title=="ԤԼ"){
		CureRBCResSchduleDataGridLoad();
	}else if (title=="ԤԼ�б�"){
		CureApplyAppDataGridLoad();
	}
	else if (title=="�������"){
		CureWorkApplyAppDataGridLoad();
	}
	else if (title=="�ɷ�����Դ�б�"){
		CureRBCResListDataGridLoad();
	}
	else if (title=="�����б�"){
		CureTriageListDataGridLoad();
	}
	else if (title=="���Ƽ�¼�б�"){
		CureRecordDataGridLoad();
	}else if (title=="��������"){
		CureAssessmentDataGridLoad();
	}else if (title=="ֱ��ִ��"){
		CureExecDataGridLoad();
	}else{
		$.messager.alert("��ʾ","����'common.inittab.js'��'DataGridLoad'���������ҳǩGrid���ݼ��ط���","info")
	}
		
}