function InitCtlResultWinEvent(obj){
	obj.LoadEvent=function(){    
		$('#gridReport').datagrid('loadData',{ 'total':'0',rows:[] });  //��ʼ������ʾ��¼Ϊ0
		obj.gridReportLoad();	
		$("#btnQuery").on('click',function(){
			obj.reloadgridReport();
		});
		$("#btnExport").on('click',function(){
			obj.btnExportSel_click();
		});
		$("#btnExportMK").on('click',function(){
			obj.btnExportInterface_click();
		});
		//�ǼǺŲ��� lengthλ��
		var length=10;
		obj.PapmiNo=""
		$("#txtRegNo").keydown(function(event){
			 if (event.keyCode ==13) {
				obj.PapmiNo = $("#txtRegNo").val();
				if(!obj.PapmiNo) return;
				$("#txtRegNo").val((Array(length).join('0') + obj.PapmiNo).slice(-length)); 
				obj.reloadgridReport();
			}
		});	
	}
	//���¼��ر������
	obj.reloadgridReport = function(){
		var ErrorStr="";
		var HospIDs=$("#cboHospital").combobox('getValue');
		var DateType=$("#cboDateType").combobox('getValue');
	    var DateFrom=$("#DateFrom").datebox('getValue');
	    var DateTo=$("#DateTo").datebox('getValue');
	    if (!HospIDs) {
			ErrorStr += $g("��ѡ��Ժ��!")+'<br/>';
		}
		if (!DateType) {
			ErrorStr += $g("��ѡ����������!")+'<br/>';
		}
		if (DateFrom=="") {
			ErrorStr += $g("��ѡ��ʼ����!")+'<br/>';
		}
		if (DateTo == "") {
			ErrorStr += $g("��ѡ���������!")+'<br/>';
		}
		if (Common_CompareDate(DateFrom,DateTo)) {
			ErrorStr += $g("��ʼ���ڲ��ܴ��ڽ�������!")+'<br/>';
		}
		if (ErrorStr != '') {
			$.messager.alert("������ʾ",ErrorStr, 'info');
			return;
		}
		obj.gridReportLoad();
		$('#gridReport').datagrid('unselectAll');

	};
	//��ȡ������ʽ 0Ϊ���� 1Ϊcsp
	obj.flg = $m({
		ClassName:"DHCHAI.BT.Config",
		MethodName:"GetValByCode",
		aCode:"IsShowModal"
	},false);
	//��Ⱦ���
	obj.OpenInfPosDialog = function(aEpisodeID,aDiasID,aAdmitDate,aDischDate,rs){
		if(rs==3){
			rs="1";
		}
		var strUrl = "./dhcma.hai.ir.infdiagnos.csp?EpisodeID=" + aEpisodeID + "&DiagID=" + aDiasID +"&AdmitDate=" + aAdmitDate +"&DischDate=" + aDischDate+"&rs=" + rs;
		var ratio =detectZoom();
        var PageWidth=Math.round(1000*ratio);
		if(obj.flg=="1"){
			websys_showModal({
				url:strUrl,
				title:$g("��Ⱦ���-�༭"),
				iconCls:'icon-w-paper',  
				width:PageWidth,
				height:'560',
				onBeforeClose:function(){
					obj.reloadgridReport();
				} 
			});
		}
		else{
			var page= websys_createWindow(strUrl,"","width="+PageWidth+",height=95%");
				//--�ر�ǰˢ�²�ѯ�б�
				var Loop=setInterval(function() {     
 	    		if(page.closed) {   	
 	    			clearInterval(Loop);
 	    			//ˢ���б�
 	    			obj.reloadgridReport();
 	    			}
 	   			});
			}
    }
	//������
	obj.ShowResutlDtl=function(aReportID) {	
		if (!aReportID) return;	
		var strUrl="dhcma.hai.ir.inf.report.csp?1=1&ReportID="+aReportID+'&AdminPower='+ obj.AdminPower+"&2=2";	
		var ratio =detectZoom();
        var PageWidth=Math.round(1322*ratio);
		if(obj.flg=="1"){
			websys_showModal({
				url:strUrl,
				title:$g("ҽԺ��Ⱦ����"),
				iconCls:'icon-w-paper',
				closable:true,  
				width:PageWidth,
				height:'95%',
				onBeforeClose:function(){
					obj.reloadgridReport();
				} 
			});
		}
		else{
			var page=websys_createWindow(strUrl,"","width="+PageWidth+",height=95%");
			//--�ر�ǰˢ�²�ѯ�б�
			var Loop=setInterval(function() {     
	 	    	if(page.closed) {   	
	 	    		clearInterval(Loop);
	 	    		//ˢ���б�
	 	    		obj.reloadgridReport();
	 	    	}
	 	    });
		}
	}
	
	//��ȡ��ǰҳ�������ֵ
	function detectZoom() {
		var ratio = 1;
		if(BrowserVer=="isChrome") {   //ҽΪ�����Ϊ Chrome 49
			var userAgent = navigator.userAgent;
            var ChromePos = userAgent.indexOf("Chrome");  //Chrome��λ
            var ChromeStr = userAgent.substr(ChromePos);  //Chrome��
            var ChromeArr = ChromeStr.split(" ");
            var ChromeVer = parseInt(ChromeArr[0].split("/")[1]);      //Chrome�汾
			if (ChromeVer<=58) {    
				ratio = window.devicePixelRatio;
			}
		}
		return ratio;
	}

	//ժҪ
	obj.btnAbstractMsg_Click = function(EpisodeID)
	{	
	    var page="";
		var LocFlag=(obj.AdminPowe==1?0:1);
		var strUrl = '../csp/dhchai.ir.view.main.csp?PaadmID='+EpisodeID+'&PageType=WinOpen&LocFlag='+LocFlag;
		if(obj.flg=="1"){
			websys_showModal({
				url:strUrl,
				title:$g("ҽԺ��Ⱦ������ͼ"),
				iconCls:'icon-w-epr',
				closable:true,
				width:'95%',
				height:'95%',
				onBeforeClose: function () {
		        //ˢ���б�
				obj.reloadgridReport();
		    	}
			});
		}
		else{
			var page= websys_createWindow(strUrl,"","width=95%,height=95%");
			//--�ر�ǰˢ�²�ѯ�б�
			var Loop=setInterval(function() {     
			if(page.closed) {   	
				clearInterval(Loop);
				//ˢ���б�
				obj.reloadgridReport();
				}
			});
		}
	};
	//���Ӳ���
	obj.btnEmrRecord_Click = function(EpisodeID)
	{		
		var rst = $m({
			ClassName:"DHCHAI.DPS.PAAdmSrv",
			MethodName:"GetPaAdmHISx",
			aEpisodeID:EpisodeID
		},false);
		if(rst=="")return;
		var EpisodeID = rst.split("^")[0];
		var PatientID = rst.split("^")[1];
		var strUrl = cspUrl+'&PatientID=' + PatientID+'&EpisodeID='+EpisodeID + '&DefaultOrderPriorType=ALL&2=2';
		if(obj.flg=="1"){
			websys_showModal({
				url:strUrl,
				title:$g("���Ӳ���"),
				iconCls:'icon-w-epr',
				closable:true,
				width:'95%',
				height:'95%'
			});
		}
		else{
			var page= websys_createWindow(strUrl,"","width=95%,height=95%");
		}
	};
	//��ͨ��¼
	obj.btnMsgSend_Click = function(PatName,EpisodeID)
	{	
		var MsgType=1;
		if (obj.AdminPower!=1) MsgType=2;
		var url = "../csp/dhcma.hai.ir.ccmessage.csp?EpisodeDr=" + EpisodeID + "&PageType=layerOpen&MsgType="+MsgType;
		websys_showModal({
			url:url,
			title:$g("���������� ")+$g(PatName),
			iconCls:'icon-w-epr',
			originWindow:window,
			width:800,
			height:500
		});
	};
	
	obj.gridReportLoad = function(){
		$('#gridReport').datagrid("loading")
		$cm ({
		    ClassName:'DHCHAI.IRS.INFDiagnosSrv',
		    QueryName:'QryRepInfoByDateLoc',
		    aDateType:$("#cboDateType").combobox('getValue'),
	        aDateFrom:$("#DateFrom").datebox('getValue'),
	        aDateTo:$("#DateTo").datebox('getValue'),
	        aRepLoc:$("#cboLocation").combobox('getValue'),
	        aRepStatus:$("#cboStatus").combobox('getValue'),
	        aRepType:1,
	        aRegNo:$("#txtRegNo").val(),
	        aMrNo:$("#txtMrNO").val(),
	        aPatName:$("#txtPatName").val(),
	        aHospIDs:$("#cboHospital").combobox('getValue'),
	        aInfLoc:$("#cboInfLocation").combobox('getValue'),
	        aInfDiags:$('#cboInfDiags').combobox('getValues').join(),
	    	page:1,
			rows:9999
		},function(rs){
			$('#gridReport').datagrid({loadFilter:pagerFilter}).datagrid('loadData', rs);	
			$('#gridReport').datagrid('selectRow', obj.rowIndex );				
		});
    }
	
	//����
	obj.btnExportSel_click = function() {
		var rows=$("#gridReport").datagrid('getRows').length;	
		if (rows>0) {
			$('#gridReport').datagrid('toExcel','��Ⱦ�����ѯ.xls');
		}else {
			$.messager.alert("ȷ��", "�����ݼ�¼,��������", 'info');
			return;
		}
		
	}
	//������ƽӿ�
	obj.btnExportInterface_click = function (objBtn, objEvent, skipMapping) {
		
		//�Ƿ������ֵ���ռ�飨true��������
		if (typeof skipMapping == 'undefined') skipMapping = false;
		
		var RepIDs="";  // ����ID�б�
		var length=$("#gridReport").datagrid('getChecked').length;
		if (length>0) {
			var rows = $("#gridReport").datagrid('getChecked');
			for(var i=0;i<length;i++){
				var tmpRepID = rows[i]["ReportID"];
				if (tmpRepID!="") {
						RepIDs +=  "^"+tmpRepID;
					} 
				}
		}
		RepIDs=RepIDs.substring(1);
		if (RepIDs == "") {
			$.messager.alert("ȷ��", "��ѡ����Ҫ�����ı���!", 'info');
			return;
		}
		var arrList = RepIDs.split("^");
		ExtTool.RunQuery(
			{
				ClassName : 'DHCHAI.MK.ExportToMKSrv',
				QueryName : 'QryValidateInfo',
				Arg1 : RepIDs,
				Arg2 : "^",
				Arg3 : "1",
				ArgCnt : 3
			},
			function(arryResult, skipMapping){
				if ((arryResult.length > 0) && (!skipMapping)) {
					var objFrm = new InitwinProblem(RepIDs, "^",obj);
					objFrm.winProblem.show();
				} else {
					ExtTool.prompt("�ļ�·��", "��������ƽӿ��ļ����·��...",
						function(e, text){
							if (e == "ok") {
								var objExportMinke = new ExportMinke();
								var ExportPath = text;
							
								//����������
								Ext.MessageBox.progress("�ӿ��ļ�", "��ʼ������ƽӿ��ļ�...");
								var intTotalCnt = arrList.length;
								for(var indRec = 0; indRec < intTotalCnt; indRec++)
								{
									var repID = arrList[indRec];
									//var repInfo = $.Tool.RunServerMethod("DHCHAI.MK.ExportToMKSrv","GetReportInfo",repID);
									var repInfo = $m({
										ClassName:"DHCHAI.MK.ExportToMKSrv",
										MethodName:"GetReportInfo",
										aReportID:repID
									},false)				
									var PatName = repInfo.split("^")[0];
									var PatMrNo = repInfo.split("^")[1];
									var PatAdmDate = repInfo.split("^")[2];
									//���½�����
									Ext.MessageBox.updateProgress(indRec/intTotalCnt, '', "���ڴ���" + PatMrNo + " " + PatName);
									var strfolderName = PatMrNo + " " + PatName + " " + PatAdmDate;
									var strPath = ExportPath + "\\" + strfolderName;
									objExportMinke.ExportMinkeData(repID, strPath,RepIDs);
								}
								
								//�رս�����
								Ext.MessageBox.hide();
								//$.messager.confirm("ɾ��", "�Ƿ�ɾ��ѡ�����ݼ�¼?", function (r) {
								$.messager.confirm("���","��������" + intTotalCnt + "�ݻ��߸�Ⱦ������Ϣ,�Ƿ���ļ�����ļ���!", function (r){
									if (r) {	
										/*if ((BrowserVer=="isLessIE11")||(BrowserVer=="isIE11")) { //IE�����
											var WshShell = new ActiveXObject("WScript.Shell");
											var oExec = WshShell.Exec("explorer.exe " + ExportPath);
										}else {*/
											if (EnableLocalWeb==1) {  //��IE��������������м��
												var Str ="(function test(x){"
												Str += "var WshShell = new ActiveXObject('WScript.Shell');"+ '\n'
												var arryFolder = ExportPath.split("\\");
												var strPath = arryFolder[0];
												for(var i = 1; i < arryFolder.length; i ++){
													if(arryFolder[i] == "") continue;
													strPath += "\\\\" + arryFolder[i];		
												}
												Str += "var oExec = WshShell.Exec('"+"explorer.exe " +strPath+"');"+ '\n'
									            Str += "return 1;}());";
												CmdShell.notReturn =0;  
												var rtn = CmdShell.EvalJs(Str);   //ͨ���м�����д�ӡ���� 
											}
										//}
								 	}
								 });
							}
						},
						null,
						false,
						"D:\\��Ƹ�Ⱦ����ӿ��ļ�"
					)
				}
			}
			,obj
			,skipMapping
		)
	};
	//������
    $('#searchbox').searchbox({
        searcher: function (value, name) {
	        if(value=="") {
		       $('#btnQuery').click();
		    } else {
			    searchText($("#gridReport"), value,1);
			}           
        }
    });
}

