//ҳ��Event
function InitAntCheckWinEvent(obj){
	
	obj.LoadEvent = function(args){
	
		//��ѯ��ť
		$('#btnQuery').on('click', function(){
			var tDateFrom=$('#dtDateFrom').datebox('getValue');
			var tDateTo=$('#dtDateTo').datebox('getValue');
			var loc=$('#cboLoc').combobox('getValue');
			if ((tDateFrom!='')&&(tDateTo!='')) {
				var ret=Common_CompareDate(tDateFrom,tDateTo);
				if (ret>0) {
					$.messager.popover({msg: '��ʼ���ڲ��ܴ��ڽ������ڣ�',type:'error',timeout: 1000})
					return;
				}
			} else {
				$.messager.popover({msg: '��ʼ���ڡ��������ڲ�����Ϊ�գ�',type:'error',timeout: 1000})
				return;
			}
			obj.gridAntCheckLoad();
		});	
		//����
		$('#btnExport').on('click', function(){
			obj.gridAntMajorLoad();
			obj.gridAntMinorLoad();
			var rows = obj.gridMajor.getRows().length;
			if (rows>0) {
			   ExportGridByCls(obj.gridMajor,obj.gridMinor,'������ҩ��˱�');
			}else {
				$.messager.alert("ȷ��", "�����ݼ�¼,��������", 'info');
			}
		});	
	}
	
	//˫�����¼�
	obj.openHandler = function(aEpisodeID,aReportID,aOrdItemID){
		var strUrl = "./dhcma.hai.ant.report.csp?1=1"+
			"&EpisodeID=" + aEpisodeID + 
			"&ReportID=" + aReportID +
			"&OrdItemID="+ aOrdItemID+
			"&LocFlag=" + 0;
        	
	    websys_showModal({
			url:strUrl,
			title:'̼��ùϩ/��ӻ����࿹��ҩ����ҩ�����',
			iconCls:'icon-w-epr',
	        originWindow:window,
			width:1340,
			height:'90%',  //8.2���ϰ汾֧�ְٷֱȣ�8.2���µ��þ������أ���height:window.screen.availHeight-80,
			onBeforeClose:function(){
				obj.gridAntCheckLoad();  //ˢ�µ�ǰҳ
			}
		});
		
	}
	
	obj.gridAntCheckLoad = function(){	
		$cm ({
			ClassName:"DHCHAI.ANTS.OrdAntiPatSrv",
			QueryName:"QryAntiCheck",	
			ResultSetType:"array",			
	        aHospital:$('#cboHospital').combobox('getValue'),
			aDateFrom:$('#dtDateFrom').datebox('getValue'),
			aDateTo:$('#dtDateTo').datebox('getValue'),
			aLocDr:$('#cboLoc').combobox('getValue'),
			aAntiMastDr:$('#cboAntiMast').combobox('getValue'),
			aQryStatus:$('#cboQryStatus').combobox('getValue'),
			page:1,
			rows:999
		},function(rs){
			$('#AntCheck').datagrid({loadFilter:pagerFilter}).datagrid('loadData', rs);				
		});
    }
    
    obj.gridAntMajorLoad = function(){	
		var rs=$cm ({
				ClassName:"DHCHAI.ANTS.OrdAntiPatSrv",
				QueryName:"QryAntiExport",	
				ResultSetType:"array",			
				aHospital:$('#cboHospital').combobox('getValue'),
				aDateFrom:$('#dtDateFrom').datebox('getValue'),
				aDateTo:$('#dtDateTo').datebox('getValue'),
				aLocDr:$('#cboLoc').combobox('getValue'),
				aAntiMastDr:$('#cboAntiMast').combobox('getValue'),
				aQryStatus:$('#cboQryStatus').combobox('getValue'),
				page:1,
				rows:999
			},false);
		$('#Major').datagrid({loadFilter:pagerFilter}).datagrid('loadData', rs);	
 	}
    obj.gridAntMinorLoad = function(){	
		var rs=$cm ({
				ClassName:"DHCHAI.ANTS.OrdAntiPatSrv",
				QueryName:"QryEtiologyEvi",	
				ResultSetType:"array",			
				aHospital:$('#cboHospital').combobox('getValue'),
				aDateFrom:$('#dtDateFrom').datebox('getValue'),
				aDateTo:$('#dtDateTo').datebox('getValue'),
				aLocDr:$('#cboLoc').combobox('getValue'),
				aAntiMastDr:$('#cboAntiMast').combobox('getValue'),
				page:1,
				rows:999
			},false);
		$('#Minor').datagrid({loadFilter:pagerFilter}).datagrid('loadData', rs);	
    }

}