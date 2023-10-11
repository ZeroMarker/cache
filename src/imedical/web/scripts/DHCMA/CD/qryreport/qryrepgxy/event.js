//ҳ��Event
function InitViewportEvent(obj){	
    
	obj.LoadEvent = function(args){ 
		$('#gridRepInfo').datagrid('loadData',{ 'total':'0',rows:[] });  //��ʼ������ʾ��¼Ϊ0
		obj.btnQuery_click();
		//��ѯ
		$('#btnQuery').on('click', function(){
			obj.btnQuery_click();
		});
		// ѡ�񵼳�
		$('#btnExport').on('click', function(){
			obj.btnExport_click();
		});
		// ��ӡ����
		$('#btnPrint').on('click', function(){
			obj.btnPrint_click();
		});
     	// �������
		$('#btnCheck').on('click', function(){
			obj.btnCheck_click();
		});
	
		//�ǼǺŻس���ѯ�¼�
		$('#txtRegNo').keydown(function (e) {
			var e = e || window.event;
			if (e.keyCode == 13) {
				RegNo=$('#txtRegNo').val().replace(/(^\s*)|(\s*$)/g, "");
				if ($.trim(RegNo)=="") return;
				var Reglength=RegNo.length;
				for(var i=0;i<(10-Reglength);i++)
				{
					RegNo="0"+RegNo;
				}
				$('#txtRegNo').val(RegNo);
				obj.gridRepInfoLoad();
			}	
		});
	}
    
	obj.btnQuery_click = function() {
		var FromDate = $('#txtFromDate').datebox('getValue')
		var ToDate = $('#txtToDate').datebox('getValue')
		if ((FromDate == '')||(ToDate == '')) {
			$.messager.alert("��ʾ","��ʼ���ڡ��������ڲ�����Ϊ��!");
		}
		if (Common_CompareDate(FromDate,ToDate)>0) {
			$.messager.alert("��ʾ","��ʼ���ڲ��ܴ��ڽ�������!");
		}
		obj.gridRepInfoLoad();
	}
	obj.btnExport_click = function() {
		var rows = obj.gridRepInfo.getRows().length;  
		if (rows>0) {
			grid2excel($("#gridRepInfo"), {IE11IsLowIE: false,filename:'��Ѫѹ�����ѯ��',allPage: true});
			/*var length = obj.gridRepInfo.getChecked().length;
			if (length>0) {
				$('#gridRepInfo').datagrid('toExcel', {
				    filename: '��Ѫѹ�����ѯ��.xls',
				    rows: obj.gridRepInfo.getChecked(),
				    worksheet: 'Worksheet'
				});
			} else {
				$.messager.alert("��ʾ", "��ѡ���ѯ��¼,�ٽ��е���!",'info');
				return;
			} */
		}else {
			$.messager.alert("ȷ��", "�����ݼ�¼,��������", 'info');
			return;
		}
	}
	// �������
	obj.btnCheck_click = function() {
		var record = obj.gridRepInfo.getChecked();
		var length = obj.gridRepInfo.getChecked().length; 	
		if (length>0) {
			var Count=0;
			for (var row = 0; row < length; row++) {
				var aReportID =  record[row]["ReportID"];
				var StatusDesc = record[row]["RepStatusDesc"];
				var CheckStr=aReportID+"^"+2+"^"+session['LOGON.USERID']+"^"+session['LOGON.CTLOCID'];
				if (StatusDesc == '�ϱ�') {
					var ret = $m({                  
						ClassName:"DHCMed.CD.CRReport",
						MethodName:"CheckReport",
						aInput:CheckStr,
						separete:"^"
					},false);
					Count++;
				}
			}
			if (Count < 1) {
				$.messager.alert("��ʾ��Ϣ", "������ѡ��һ�д����¼,�ٽ������!",'info');
				return;
			}
			$.messager.popover({
				msg: '������˳ɹ�',
				type: 'success',
				timeout: 2000, 		//0���Զ��رա�3000s
				showType: 'slide'  //show,fade,slide
			});
			obj.gridRepInfoLoad();
			obj.gridRepInfo.clearSelections();  ;  //�������ѡ�����
		} else {
			$.messager.alert("��ʾ��Ϣ", "��ѡ������¼,�ٽ������!",'info');
			return;
		}
		var rows = obj.gridRepInfo.getRows().length; 
		if(rows<1){
			$.messager.alert("��ʾ","���Ȳ�ѯ����������ˣ�",'info');
			return;
		}		
	}
	// ��ӡ����
	obj.btnPrint_click = function() {
		var record = obj.gridRepInfo.getChecked();
		var length = obj.gridRepInfo.getChecked().length; 	
		if (length>1) {
			$.messager.alert("��ʾ", "��ӡ����ֻ��ѡ��һ������", 'info');
			return;
		}else if (length==1){
			var aReportID =  record[0]["ReportID"];
			var PrintStr=aReportID+"^"+session['LOGON.USERID']+"^"+session['LOGON.CTLOCID']+"^"+"PRINT";
			var ret = $m({                  
				ClassName:"DHCMed.CD.CRReport",
				MethodName:"ExportReport",
				aInput:PrintStr,
				separete:"^"
			},false);
			if(parseInt(ret)<=0){
				$.messager.alert("����","��ӡ��ӡʧ��!"+ret, 'error');
				return;
			}else{
				var LODOP=getLodop();
				LODOP.PRINT_INIT("PrintCDGXYInfo");		//��ӡ���������
				LODOP.ADD_PRINT_HTM(1,600,300,100,"<span tdata='pageNO'>��##ҳ</span>/<span tdata='pageCount'>��##ҳ</span>");
				LODOP.SET_PRINT_STYLEA(0,"ItemType",1);			//ÿҳ����ӡҳ��
				LODOP.SET_PRINT_MODE("DOUBLE_SIDED_PRINT", 0);	//�˹�˫���ӡ(��ӡ����֧��˫���ӡʱ��1Ϊ��˫���ӡ��0Ϊ�����ӡ��2Ϊ˫���ӡ)
				LODOP.SET_PRINT_MODE("PRINT_DUPLEX", 0);		//�Զ�˫���ӡ(��ӡ��֧��˫���ӡʱ��1Ϊ��˫���ӡ��0Ϊ�����ӡ��2Ϊ˫���ӡ)
				LodopPrintURL(LODOP,"dhcma.cd.lodopgxy.csp?ReportID="+aReportID);
				LODOP.PRINT();			//ֱ�Ӵ�ӡ
			}
		}else{
			$.messager.alert("��ʾ","��ѡ���ѯ��¼���ٴ�ӡ���棡",'info');
			return;
		}
	}
	//������
	obj.OpenReport = function(aReportID,aEpisodeID) {
		var strUrl= "./dhcma.cd.reportgxy.csp?1=1&ReportID=" + aReportID + "&EpisodeID=" + aEpisodeID + "&LocFlag=" + 1;
	    websys_showModal({
			url:strUrl,
			title:'��Ѫѹ����',
			iconCls:'icon-w-epr',  
	        originWindow:window,
	        closable:false,
			width:1320,
			height:'638px',  //8.2���ϰ汾֧�ְٷֱȣ�8.2���µ��þ������أ���height:window.screen.availHeight-80,
			dataRow:{ReportID:aReportID},  
			onBeforeClose:function(){
				obj.gridRepInfoLoad();  //ˢ��
			} 
		});
	}
	
	obj.gridRepInfo_click = function() {
		var rowData = obj.gridRepInfo.getSelected();
		var index = obj.gridRepInfo.getRowIndex(rowData);  //��ȡ��ǰѡ���е��к�(��0��ʼ)
		
		var ReportID = rowData["ReportID"];
		var EpisodeID = rowData["EpisodeID"];
        var strUrl= "./dhcma.cd.reportgxy.csp?1=1&ReportID=" + ReportID + "&EpisodeID=" + EpisodeID + "&LocFlag=" + 1;

	    websys_showModal({
			url:strUrl,
			title:'��Ѫѹ����',
			iconCls:'icon-w-epr',  
	        originWindow:window,
	        closable:false,
			width:1320,
			height:'638px',  //8.2���ϰ汾֧�ְٷֱȣ�8.2���µ��þ������أ���height:window.screen.availHeight-80,
			dataRow:{ReportID:ReportID},  
			onBeforeClose:function(){
				obj.gridRepInfoLoad();  //ˢ��
			} 
		});
	}
	
	obj.gridRepInfoLoad = function(){	
		$("#gridRepInfo").datagrid("loading");		
		$cm ({
			ClassName:"DHCMed.CDService.QryService",
			QueryName:"QryGXYRepByDate",		
			aFromDate: $('#txtFromDate').datebox('getValue'), 
			aToDate: $('#txtToDate').datebox('getValue'),
			aHospID:$('#cboHospital').combobox('getValue'),   			
			aRepLoc: $('#cboRepLoc').combobox('getValue'), 
			aRepStatus: Common_CheckboxValue('chkStatusList'),
			aPatName:$('#txtPatName').val(),
			aRegNo:$('#txtRegNo').val(),
	    	page:1,
			rows:99999
		},function(rs){
			$('#gridRepInfo').datagrid({loadFilter:pagerFilter}).datagrid('loadData', rs);				
		});
    }
	
}