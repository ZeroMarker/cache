//ҳ��Event
function InitLocPatListWinEvent(obj){
	//ҳ���ʼ��
	obj.LoadEvent = function(args){
		//��ѯ��ť
		$('#btnQuery').on('click', function(){
			obj.btnQuery_click();
		});
	}
	
	//��ѯ��ť
	obj.btnQuery_click = function(){		
		var tDateFrom=$('#dtDateFrom').datebox('getValue');
		var tDateTo=$('#dtDateTo').datebox('getValue');
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
		obj.gridLocPatListLoad();
	}
	
	//���ؿ��һ����б�����
	obj.gridLocPatListLoad = function(){
		obj.gridLocPatList.load({
			ClassName:'DHCHAI.ANTS.OrdAntiPatSrv',
			QueryName:'QryLocAntiPat',
			aDateFrom:$('#dtDateFrom').datebox('getValue'),
			aDateTo:$('#dtDateTo').datebox('getValue'),
			aLocDr:$.LOGON.LOCID,
			aAdmStatus: Common_CheckboxValue('chkAdmStatus'),
			aRegNo:$('#txtRegNo').val(),
			aMrNo:$('#txtMrNo').val(),
			aAntiMastDr:$('#cboAntiMast').combobox('getValue')
	    });
    }
    //�ǼǺŻس���ѯ�¼�
		$('#txtRegNo').keydown(function (e) {
			var e = e || window.event;
			if (e.keyCode == 13) {
				RegNo=$('#txtRegNo').val().replace(/(^\s*)|(\s*$)/g, "");
				if ($.trim(RegNo)=="") return;
				var Reglength=RegNo.length
				for(var i=0;i<(10-Reglength);i++)
				{
					RegNo="0"+RegNo;
				}
				$('#txtRegNo').val(RegNo);
				obj.gridLocPatListLoad();
			}
		});
	//�ϱ���ť����ʱ��
	obj.btnReport_Click = function(aEpisodeID,aReportID,aOrdItemID,pindex){
		var strUrl = "./dhcma.hai.ant.report.csp?1=1"+
			"&EpisodeID=" + aEpisodeID + 
			"&ReportID=" + aReportID +
			"&OrdItemID=" + aOrdItemID +				   
			"&LocFlag=" + 1;
		
	    websys_showModal({
			url:strUrl,
			title:'̼��ùϩ/��ӻ����࿹��ҩ����ҩ�����',
			iconCls:'icon-w-epr',
	        originWindow:window,
			width:1340,
			height:'90%',  //8.2���ϰ汾֧�ְٷֱȣ�8.2���µ��þ������أ���height:window.screen.availHeight-80,
			onBeforeClose:function(){
				var expander = $('#gridLocPatList').datagrid('getExpander',pindex);  //��ȡչ����
				if(expander.length && expander.hasClass('datagrid-row-collapse')){
					$('#gridLocPatList').datagrid('collapseRow',pindex); //�۵�
					$('#gridLocPatList').datagrid('expandRow',pindex);   //չ��			
					
					$('#gridAntiDrugList'+pindex).datagrid('reload');   //ˢ��	
				}	
			}
		});
	}
	
}