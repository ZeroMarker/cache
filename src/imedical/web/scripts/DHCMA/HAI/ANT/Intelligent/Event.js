//ҳ��Event
function InitAntMoniWinEvent(obj){
	
	obj.LoadEvent = function(args){
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
				obj.gridAntMonitorLoad();
			}	
		});
		//��ѯ��ť
		$('#btnQuery').on('click', function(){
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
			obj.gridAntMonitorLoad();
		});
	
		obj.gridAntMonitorLoad = function(){
			obj.gridAntMonitor.load({
				ClassName:'DHCHAI.ANTS.OrdAntiPatSrv',
				QueryName:'QryIntMonitor',
				aDateFrom:$('#dtDateFrom').datebox('getValue'),
				aDateTo:$('#dtDateTo').datebox('getValue'),
				aHospIDs:$('#cboHospital').combobox('getValue'),
				aLocDr:$('#cboLoc').combobox('getValue'),
				aPatNo:$('#txtRegNo').val(),
				aQryStatus:$('#cboQryStatus').combobox('getValue'),
				aAntiMastDr:$('#cboAntiMast').combobox('getValue')
			});
		}
	
		//�ϱ���ť����ʱ��
		obj.btnReport_Click = function(aEpisodeID,aReportID,aOrdItemID,pindex){
			var strUrl = "./dhcma.hai.ant.report.csp?1=1"+
				"&EpisodeID=" + aEpisodeID + 
				"&ReportID=" + aReportID +
				"&OrdItemID=" + aOrdItemID +
				"&LocFlag=" + 0;
				
			websys_showModal({
				url:strUrl,
				title:'̼��ùϩ/��ӻ����࿹��ҩ����ҩ�����',
				iconCls:'icon-w-epr',
				originWindow:window,
				width:1340,
				height:'90%',  //8.2���ϰ汾֧�ְٷֱȣ�8.2���µ��þ������أ���height:window.screen.availHeight-80,
				onBeforeClose:function(){
					var expander = $('#AntMonitor').datagrid('getExpander',pindex);  //��ȡչ����
					if(expander.length && expander.hasClass('datagrid-row-collapse')){
						$('#AntMonitor').datagrid('collapseRow',pindex); //�۵�
						$('#AntMonitor').datagrid('expandRow',pindex);   //չ��			
						$('#gridAntiDrugList'+pindex).datagrid('reload');   //ˢ��	
					}		
				}
			});
		}
	}
}