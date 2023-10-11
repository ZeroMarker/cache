function InitPatFindWinEvent(obj){

	CheckSpecificKey();
	var CheckFlg = 0; 
	if(tDHCMedMenuOper['Admin']==1) {
		CheckFlg = 1; //���Ȩ��
	}
	obj.LoadEvent = function(args){
		//��ѯ��ť
		$("#btnQuery").on('click',function(){
			obj.reloadgridApply();
		});
		$("#btnExport").on('click',function(){
			obj.btnExport_click();
		});
		//��˽��
		$('#btnChkReps').on('click', function(){
			obj.btnCheckRep_onClick();
		});
		//ȡ����˽��
		$('#btnUnChkReps').on('click', function(){
			obj.btnUnCheckRep_onClick();
		});
		//������������ ,aHospDr: $.LOGON.HOSPID
		var dtCode = $m({
			ClassName: "DHCHAI.BT.Config",
			MethodName: "GetValByCode",
			aCode: "DataCenterCodeHDM"
		},false);
		$("#btnExportXML").on('click',function(){
			if(dtCode=="bjs")
			{
				obj.btnExportInterface_click();
			}
			else if(dtCode=="scs")
			{
				obj.btnExportXML_click();
			}
			else
			{
				//2022�����浼����Ĭ�Ϸ�ʽ
				obj.btnExportXML2022_click();
			}
		});	
		
		if ((dtCode=="bjs")||(dtCode=="scs")||(dtCode=="bzb")) {
			$("#btnExportXML").show();	
		}
	}
	$("#txtPatName").keydown(function(event){
		if (event.keyCode ==13)obj.reloadgridApply();	
	});	
	//��˽��
	obj.btnCheckRep_onClick = function(){
		var rows = $("#gridApply").datagrid('getRows').length;
		if (rows>0) {
			var chkRows=$HUI.datagrid('#gridApply').getChecked();
			if (chkRows.length>0) {
				 $.messager.confirm("ȷ��", "�Ƿ�������˱���?", function (r) {
					if (r) {
						var reportIds = '';
						for (var row = 0; row < chkRows.length; row++){
							var rd = chkRows[row];
							if (!rd) continue;
							var repId = rd['RepID'];
							if (reportIds != ''){
								reportIds += ',' + repId;
							} else {
								reportIds = repId;
							}
						}
						
						var flg = $m({
							ClassName   : "DHCHAI.IRS.INFReportSrv",
							MethodName  : "SaveCSSReportStatus",
							aReportIDs  : reportIds,
							aStatusCode : 3
						},false);
						if (parseInt(flg) < 1) {
							$.messager.alert("������ʾ","������˱����������!Error=" + flg, 'info');
						} else {
							$.messager.popover({msg: '������˱�������ɹ���',type:'success',timeout: 1000});
							obj.reloadgridApply();  //ˢ��
						}
					}
				});
			} else {
				$.messager.alert("������ʾ", "��ѡ�м�¼,���ɲ���!",'info');
				return;
			}
		}else {
			$.messager.alert("������ʾ", "�޼�¼,���ɲ���!", 'info');
			return;
		}
	}
	//ȡ����˽��
	obj.btnUnCheckRep_onClick = function(){
		var rows = $("#gridApply").datagrid('getRows').length;
		if (rows>0) {
			var chkRows=$HUI.datagrid('#gridApply').getChecked();
			if (chkRows.length>0) {
				 $.messager.confirm("ȷ��", "�Ƿ�����ȡ����˱���?", function (r) {
					if (r) {
						var reportIds = '';
						for (var row = 0; row < chkRows.length; row++){
							var rd = chkRows[row];
							if (!rd) continue;
							var repId = rd['RepID'];
							if (reportIds != ''){
								reportIds += ',' + repId;
							} else {
								reportIds = repId;
							}
						}
						
						var flg = $m({
							ClassName   : "DHCHAI.IRS.INFReportSrv",
							MethodName  : "SaveCSSReportStatus",
							aReportIDs  : reportIds,
							aStatusCode : 6
						},false);
						if (parseInt(flg) < 1) {
							$.messager.alert("������ʾ","����ȡ����˱����������!Error=" + flg, 'info');
						} else {
							$.messager.popover({msg: '����ȡ����˱�������ɹ���',type:'success',timeout: 1000});
							obj.reloadgridApply();  //ˢ��
						}
					}
				});
			} else {
				$.messager.alert("������ʾ", "��ѡ�м�¼,���ɲ���!",'info');
				return;
			}
		}else {
			$.messager.alert("������ʾ", "�޼�¼,���ɲ���!", 'info');
			return;
		}
	}
	//������
	obj.OpenReport = function(EpisodeID,SurvNumber,ReportID,Index,RepStatus) {
		var strUrl = '../csp/dhcma.hai.ir.cssreport.csp?EpisodeID='+EpisodeID+'&SurvNumber='+$("#cboSurvNumber").combobox("getValue")+'&ReportID='+ReportID+'&AdminPower='+CheckFlg+'&RepStatus='+RepStatus+'&inputParams='+obj.Params+'&1=1';
		websys_showModal({
			url:strUrl,
			title:'��������:'+$("#cboSurvNumber").combobox("getText"),
			iconCls:'icon-w-epr',  
	        originWindow:window,
	        closable:true,
			width:1320,
			height:'95%',  //8.2���ϰ汾֧�ְٷֱȣ�8.2���µ��þ������أ���height:window.screen.availHeight-80,
			onBeforeClose:function(){
				obj.reloadgridApply();
				/*/ˢ����
				var CssDataList = $cm({
            		ClassName: "DHCHAI.IRS.INFCSSSrv",
           		 	QueryName: "QryNewCSSByPaadm",
            		aEpisodeID: EpisodeID,
            		aSurNumber:$("#cboSurvNumber").combobox('getValue'),
            		rows:999
       			}, false);
				var CssData = CssDataList.rows[0];
				if(CssData!=""){
					$('#gridApply').datagrid('updateRow', {
            			index: Index,
            			row: {
							"RepID":CssData.RepID,
							"RepStatus": CssData.RepStatus,
							"AllDiag": CssData.AllDiag,
							"OBSCnt": CssData.OBSCnt==1?"��":"��",
							"InfPosDescs": CssData.InfPosDescs,
							"IRAntiFlag": CssData.IRAntiFlag==1?"��":"��",
							"PurposeDesc": CssData.PurposeDesc,
							"CombinDesc": CssData.CombinDesc,
							"IRAntiSenFlag": CssData.IRAntiSenFlag==1?"��":"��",
							"OperFlag": CssData.OperFlag==1?"��":"��",
							"CuteType": CssData.CuteType,
						}
					});
				}*/
			} 
		});
	}
	
	//������
	obj.OpenMainView = function(EpisodeID) {
		var strUrl = '../csp/dhchai.ir.view.main.csp?PaadmID='+EpisodeID+'&PageType=WinOpen';
		websys_showModal({
			url:strUrl,
			title:'ҽԺ��Ⱦ������ͼ',
			iconCls:'icon-w-epr',  
	        originWindow:window,
	        closable:true,
			width:1320,
			height:'95%',  //8.2���ϰ汾֧�ְٷֱȣ�8.2���µ��þ������أ���height:window.screen.availHeight-80,
			onBeforeClose:function(){
				obj.reloadgridApply();  //ˢ��
			} 
		});
	}
	setTimeout(function(){obj.reloadgridApply();},1000);
	//���¼��ر������
	obj.reloadgridApply = function(){
		var HospIDs 	= $("#cboHospital").combobox('getValue');
		var LocationID  = $("#cboLocation").combobox('getValue');
		var SEID	 	= $("#cboSurvNumber").combobox('getValue');
		var PatName 	= $("#txtPatName").val();
		var PapmiNo 	= "";  
		var MrNo 		= "";
		//����״̬
		var Status=Common_CheckboxValue('chkStatunit');
        var CssInfType=$("#cboInfCategoryDr").combobox('getText');
		var Inputs = HospIDs+'^'+LocationID+'^'+""+"^"+SEID+'^'+PatName+'^'+PapmiNo+'^'+MrNo+"^"+Status+"^"+CssInfType;
		
		var ErrorStr="";
		if (HospIDs=="") {
			ErrorStr += '��ѡ��Ժ��!<br/>';
		}
		if (SEID==""){
			ErrorStr += '��ѡ������ţ�<br/>';
			
		}
		if(LocationID==""){
			//ErrorStr += '��ѡ�����\������<br/>';
		}
		
		if (ErrorStr != '') {
			$.messager.alert("������ʾ",ErrorStr, 'info');
			return;
		}else{
			//obj.Params = HospIDs+'^'+LocationID+'^'+""+"^"+SEID+'^'+""+'^'+""+'^'+""+"^"+Status;
			obj.Params = HospIDs+'^'+LocationID+'^'+""+"^"+SEID+'^'+""+'^'+""+'^'+""+"^";
			$("#gridApply").datagrid("loading");
			$cm ({
				ClassName:"DHCHAI.IRS.INFCSSSrv",
				QueryName:"QryAdm",
				ResultSetType:"array",
				aIntputs:Inputs,
				page:1,
				rows:1000
			},function(rs){
				$('#gridApply').datagrid({loadFilter:pagerFilter}).datagrid('loadData', rs);
				$('#gridApply').datagrid('selectRow', obj.rowIndex );				
			});
		
		};
	}
	obj.btnExport_click = function() {
		var rows=$("#gridApply").datagrid('getRows').length;
		if (rows>0) {
			var length = $("#gridApply").datagrid('getChecked').length;
			if (length>0) {
				$('#gridApply').datagrid('toExcel', {
				    filename: '��������.xls',
				    rows: $("#gridApply").datagrid('getChecked'),
				    worksheet: 'Worksheet',
				});
			} else {
				$('#gridApply').datagrid('toExcel','��������.xls');
			} 
		}else {
			$.messager.alert("ȷ��", "�����ݼ�¼,��������", 'info');
			return;
		}	
	}
	
	obj.btnExportXML_click = function(){
		var rows=$("#gridApply").datagrid('getRows').length;
		var Err="",CSSIDs=""
		if (rows>0) {
			var objrow=$("#gridApply").datagrid('getChecked')
			var length = $("#gridApply").datagrid('getChecked').length;
			if (length>0) {
				for (i=0;i<length;i++){
					var row=objrow[i]
					var CSSID=row.CSSID
					var MrNo=row.MrNo
					if (CSSID=='') {
						Err+="�����ţ�"+MrNo+"����δ���е���<br/>"
						continue
					}
					CSSIDs+=CSSID+"^"
				}
				if(CSSIDs!="")
				{
					obj.ExportXML(CSSIDs)
				}
			} else {
				var objRows=$("#gridApply").datagrid('getRows')
				for (i=0;i<rows;i++){
					var row=objRows[i]
					var CSSID=row.CSSID
					var MrNo=row.MrNo
					if (CSSID=='') {
						Err+="�����ţ�"+MrNo+"����δ���е���<br/>"
						continue
					}
					CSSIDs+=CSSID+"^"
				}
				if(CSSIDs!="")
				{
					obj.ExportXML(CSSIDs)
				}
			} 
			if (Err!=""){
				$.messager.alert("��ʾ",Err, 'info');
			}
		}else {
			$.messager.alert("ȷ��", "�����ݼ�¼,��������", 'info');
			return;
		}
	}
	obj.ExportXML = function(aCSSIDs){
	    var LocDesc=$('#cboLocation').combobox('getText')	//$.form.GetText('cboLocation')
	    if(LocDesc=="")
	    {
			LocDesc="ȫ����������";    
		}
		try {
			var count=0
			/*
			fso = new ActiveXObject("scripting.FileSystemObject");
			path = "D:\\��������\\"+LocDesc+"\\";
			if (!fso.FolderExists("D:\\��������\\")){
				fso.CreateFolder("D:\\��������\\");
			}
			if (!fso.FolderExists(path)){   // ����ǰ·�������ڣ��򴴽���·����
				 fso.CreateFolder(path);
			}
			*/
			var CSSInfo=$m({
				ClassName:'DHCHAI.IRX.Output',
				MethodName:'BatExportXML',
				aCSSIDs:aCSSIDs
			},false)	//$.Tool.RunServerMethod("DHCHAI.IRX.Output","BatExportXML",aCSSIDs);
			var CSSStr=CSSInfo.split("^")[0];
			//path +=  LocDesc+".xml";   // �����ĵ���·����
			//tf = fso.CreateTextFile(path, true,true);   // �������ļ���
			//tf.WriteLine(CSSStr);
			//tf.Close();			
			//path = "D:\\��������\\"+LocDesc+"\\";
			//$.messager.alert("ȷ��",'����xml��ɣ��ļ�λ��'+path, 'info');
			var zip = new JSZip();			
			zip.file(LocDesc+".xml", CSSStr);
			zip.generateAsync({type:"blob"}).then(function(content) {
			    // content����blob���ݣ�������example.zip��������    
			    // ʹ����FileSaver.js 
			    var filename = LocDesc + '.zip'; 
			    saveAs(content, filename);
			});
		}catch(e){
			alert(e)
		}
	}
	//������ƽӿ�
	obj.btnExportInterface_click = function (objBtn, objEvent, skipMapping) {
		
		//�Ƿ������ֵ���ռ�飨true��������
		if (typeof skipMapping == 'undefined') skipMapping = false;
		
		var RepIDs="",Err="";  // ����ID�б�
		var objrow=$("#gridApply").datagrid('getChecked')
		var length = $("#gridApply").datagrid('getChecked').length;
		if (length>0) {
			for (i=0;i<length;i++){
				var row=objrow[i]
				var tmpRepID=row.RepID
				var MrNo=row.MrNo
				if (tmpRepID=='') {
					Err+="�����ţ�"+MrNo+"����δ���е���<br/>"
					continue
				}
				RepIDs +=  "^"+tmpRepID;
			}
		} else {
			var objRows=$("#gridApply").datagrid('getRows')
			for (i=0;i<objRows.length;i++){
				var row=objRows[i]
				var tmpRepID=row.RepID
				var MrNo=row.MrNo
				if (tmpRepID=='') {
					Err+="�����ţ�"+MrNo+"����δ���е���<br/>"
					continue
				}
				RepIDs +=  "^"+tmpRepID;
			}
		} 
		/*
		if (Err!=""){
			$.messager.alert("��ʾ",Err, 'info');
		}
		*/
		//alert(RepIDs)
		RepIDs=RepIDs.substring(1);
		if (RepIDs == "") {
			$.messager.alert("��ʾ","û�е��鱨�浼�������Ƚ��е��飡", 'info'); //layer.msg('��ѡ����Ҫ�������ֻ��ʱ���!',{icon: 2});
			return;
		}
		var arrList = RepIDs.split("^");
		ExtTool.RunQuery(
			{
				ClassName : 'DHCHAI.MK.ExportToMKSrv',
				QueryName : 'QryValidateInfonew',
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
								
								$.messager.confirm("���","��������" + intTotalCnt + "�ݻ����ֻ��ʵ��鱨����Ϣ,�Ƿ���ļ�����ļ���!", function (r){
									if (r) {
										var WshShell = new ActiveXObject("WScript.Shell");
										var oExec = WshShell.Exec("explorer.exe " + ExportPath);
										/*	
										if ((BrowserVer=="isLessIE11")||(BrowserVer=="isIE11")) { //IE�����
											var WshShell = new ActiveXObject("WScript.Shell");
											var oExec = WshShell.Exec("explorer.exe " + ExportPath);
										}else {
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
										}
										*/
								 	}								 	
								 });
		 						/*	
								ExtTool.confirm("�ӿ��ļ�", "��������" + intTotalCnt + "�ݻ��߸�Ⱦ������Ϣ,�Ƿ���ļ�����ļ���!", function(btn, txt) {
									if (btn == 'yes') {
										var WshShell = new ActiveXObject("WScript.Shell");
										var oExec = WshShell.Exec("explorer.exe " + ExportPath);
									}
								});
								*/
							}
						},
						null,
						false,
						"D:\\�ֻ��ʵ��鱨��ӿ��ļ�"
					)
				}
			}
			,obj
			,skipMapping
		)
	};
	//����2022XML
	obj.btnExportXML2022_click = function() {
		//��׼��
		var sNo = $m({
			ClassName: "DHCHAI.MAPS.CssInterfaceSrv",
			MethodName: "CurrTimeNo"
		}, false);
		var ExportPath = "NIOA-"+sNo;
		obj.ExportXMLPath = ExportPath;
		var zip = new JSZip();
		var cntVal =0;
		var aRepIDs="";
		//ѭ���ܵ������ѵ�������
		var objRows=$("#gridApply").datagrid('getRows')
		for (i=0;i<objRows.length;i++){
			var row=objRows[i]
			var tmpRepID=row.RepID
			if (tmpRepID!='') {
				if(aRepIDs=='')
				{
					aRepIDs=tmpRepID
				}
				else
				{
					aRepIDs=aRepIDs+","+tmpRepID;
				}
				cntVal++;
			}
		}
		if (cntVal>0) {
			var oldOk = $.messager.defaults.ok;
			var oldCancel = $.messager.defaults.cancel;
			//$.messager.defaults.ok = "ͬ��";
			//$.messager.defaults.cancel = "�ܾ�";
			$.messager.confirm("ȷ��", "ȷ�����������������ݼ���"+"?", function (r) {
				if (r) {
					//$.messager.popover({ msg: "�����ȷ��", type: 'info' });					
					$.messager.progress({
						title: "��ʾ",
						msg: '���ڵ�������',
						text: '������....'
					});
					//���ɵ��黼������Ϣ
					var strMain = $m({
						ClassName: "DHCHAI.MAPS.CssInterfaceSrv",
						MethodName: "GetEpisodeMain",
						aRepIDs:aRepIDs
					}, false);	
							
					strMain = obj.ReplaceText(strMain, String.fromCharCode(2), "\r\n");
					zip.file("PatientMain.xml", strMain);	
					//���ɵ����Ⱦ��Ϣ
					var strInfectInfo = $m({
						ClassName: "DHCHAI.MAPS.CssInterfaceSrv",
						MethodName: "GetEpisodeInfs",
						aRepIDs:aRepIDs
					}, false);					
					strInfectInfo = obj.ReplaceText(strInfectInfo, String.fromCharCode(2), "\r\n");
					zip.file("InfectInfo.xml", strInfectInfo);	
					//���ɵ������Ϣ
					var strPatho = $m({
						ClassName: "DHCHAI.MAPS.CssInterfaceSrv",
						MethodName: "GetEpisodePathos",
						aRepIDs:aRepIDs
					}, false);					
					strPatho = obj.ReplaceText(strPatho, String.fromCharCode(2), "\r\n");
					zip.file("PathoInfo.xml", strPatho);
					//���ɵ����ҩ����Ϣ
					var strAntibInfo = $m({
						ClassName: "DHCHAI.MAPS.CssInterfaceSrv",
						MethodName: "GetEpisodeAntis",
						aRepIDs:aRepIDs
					}, false);					
					strAntibInfo = obj.ReplaceText(strAntibInfo, String.fromCharCode(2), "\r\n");
					zip.file("AntibInfo.xml", strAntibInfo);							
					//�����������ļ� $.LOGON.USERDESC
					var strSum = $m({
						ClassName: "DHCHAI.MAPS.CssInterfaceSrv",
						MethodName: "ExportReportSum",
						aSurNo:$("#cboSurvNumber").combobox('getValue'),
						aRepIDs:aRepIDs,
						aFileName:obj.ExportXMLPath,
						aUserDesc:''
					}, false);					
					strSum = obj.ReplaceText(strSum, String.fromCharCode(2), "\r\n");
					zip.file("UserInfo.xml", strSum);
					zip.generateAsync({type:"blob"}).then(function(content) {
						// content����blob���ݣ�������example.zip��������    
						// ʹ����FileSaver.js 
						var filename = obj.ExportXMLPath + '.zip'; 
						saveAs(content, filename);
					});		
					setTimeout('$.messager.progress("close");', 1 * 1000);
				} else {
					$.messager.popover({ msg: "����ȡ�����������������ݼ�" });
				}
				/*Ҫд�ڻص�������,�����ھɰ��¿��ܲ��ܻص�����*/
				$.messager.defaults.ok = oldOk;
				$.messager.defaults.cancel = oldCancel;
			});			
		}else {
			$.messager.alert("ȷ��", "û�е�������,��������", 'info');
			return;
		}		
	};
	obj.ReplaceText = function(str, find, repl)
	{
		var strTmp = str;
		while(strTmp.indexOf(find) >=0)
		{
			strTmp = strTmp.replace(find, repl);	
		}	
		return strTmp;
	};
}