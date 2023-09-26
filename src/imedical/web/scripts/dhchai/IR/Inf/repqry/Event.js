function InitCtlResultWinEvent(obj){
	CheckSpecificKey();
    // ��ʼ��Ȩ��
	// ��Ⱦcheckbox
	$.form.CheckBoxRender();
	$.form.iCheckRender();  //��Ⱦ��ѡ��|��ѡť
	//��ֵ��ʼֵ
    $("#cboHospital").data("param",$.LOGON.HOSPID);	
	$.form.SelectRender("#cboHospital");  //��Ⱦ������
	$("#cboHospital option:selected").next().attr("selected", true);	
	$("#cboHospital").select2();
    $("#cboLocation").data("param",$.form.GetValue("cboHospital")+"^^I^E^1");
	$.form.SelectRender("cboLocation");  //��Ⱦ������
	$("#cboInfLocation").data("param",$.form.GetValue("cboHospital")+"^^I^E^1");
	$.form.SelectRender("cboInfLocation");
	$.form.SelectRender("cboRepType");
   
    
    //������ٴ����ң����ñ�����Ҳ�����
    if (tDHCMedMenuOper['Clinical'] == 1) {
        //�������Ĭ�ϲ���ѡ��
        $("#cboLocation").attr("disabled", "disabled");
        //��ȡ�ٴ�����
        var LocId = $.LOGON.LOCID;	//session['LOGON.CTLOCID']; 
        $("#cboLocation").data("param", "^^I^E^1^"+LocId);
        $.form.SelectRender("cboLocation");  //��Ⱦ������
        //��������Ҹ���ʼֵ
        $.form.SetValue("cboLocation", $("#cboLocation>option:nth-child(" + 2 + ")").val(), $("#cboLocation>option:nth-child(" + 2 + ")").text());
    }
    else                                                    //Ĭ�Ϲ���ԱȨ��
    {
        obj.AdminPower = '0';
        if (typeof tDHCMedMenuOper != 'undefined') {
            if (typeof tDHCMedMenuOper['Admin'] != 'undefined') {
                obj.AdminPower = tDHCMedMenuOper['Admin'];
            }
        }
        //��select2��ֵchange�¼�
        $("#cboHospital").on("select2:select", function (e) {
            //���ѡ�е�ҽԺ
            var data = e.params.data;
            var id = data.id;
            var text = data.text;
            $("#cboLocation").data("param", id + "^^I^E^1");
            $.form.SelectRender("cboLocation");  //��Ⱦ������	
             $("#cboInfLocation").data("param", id + "^^I^E^1");
            $.form.SelectRender("cboInfLocation");  //��Ⱦ������	
        });
    }
	
	$.form.SelectRender("#cboStatus");
	$.form.CheckBoxRender("#divpInfEffect");
	$.form.iCheckRender();  //��Ⱦ��ѡ��|��ѡť
	
	/*****��������*****/
	$("#btnsearch").on('click', function(){
	   $('#gridReport').DataTable().search($('#search').val(),true,true).draw();
	   
	});

	$("#search").keyup(function(event){
	    if (event.keyCode == 13) {
	        obj.gridReport.search(this.value).draw();
	    }
	});
	refreshGridReport();
	/****************/
    //��ѯ��ť
    $("#btnQuery").on('click', function(){
        //add
		var DateFrom = $.form.GetValue("DateFrom");
		var DateTo   = $.form.GetValue("DateTo");
		
		if ((DateFrom == '')||(DateTo=='')) {
			layer.alert('��Ժ���ڲ�����Ϊ��!',{icon: 0});
			return ;
		}
		
		if(DateFrom>DateTo){
			layer.alert('��ʼ���ڲ�������ڽ�������!',{icon: 0});
			return ;	
		}
		//end
	    
	   if(obj.gridReport){                                      
	        //��գ���refreshGridReport()��ʼ����񣬷�ֹ���ݹ����ѱ��ſ���������ȥ
		    //$("#gridReport_wrapper .dataTables_scrollBody").mCustomScrollbar("destroy");
		    //$("#gridReport").dataTable().fnDestroy();
		    //obj.gridReport=null;
			//��յ�����û���� bug 605394
		    refreshGridReport();
	    }
		refreshGridReport();
	});
    $("#txtMrNO").keyup(function(event){
	    if (event.keyCode == 13) {
	        $("#btnQuery").click();
	    }
	});
     //����
    $("#btnExport").on('click', function(){
		obj.gridReport.buttons(0,null)[0].node.click();
	});
	//������Ϣ
    //����ѡ�з�ʽ
    $('#gridReport').on('click','a.editor_msg', function (e) {
	    e.preventDefault();
		var tr = $(this).closest('tr');
		var row = obj.gridReport.row(tr);
		var rowData = row.data();
		var patName = rowData.PatName;
		var EpisodeID=rowData.EpisodeID;
		obj.btnMsgSend_Click(patName,EpisodeID);
    });		
	obj.btnMsgSend_Click = function(patName,EpisodeID)
	{		
		var url = "../csp/dhchai.ir.ccmessage.csp?EpisodeDr=" + EpisodeID + "&PageType=layerOpen&MsgType=1";
		obj.idxLayerMsg = layer.open({
			type: 2,  //0(��Ϣ��,Ĭ��) 1(ҳ���)  2(iframe��) 3(���ز�) 4(tips��)
			maxmin: false,
			title: [patName,"text-align:center;background-color: #4C9CE4;color:#fff"], 
			area: ['800px','500px'],
			content: [url,'no']
		});
	};
	$('#gridReport').on('click','a.Emr_Record', function (e) {
	    e.preventDefault();
		var tr = $(this).closest('tr');
		var row = obj.gridReport.row(tr);
		var rowData = row.data();
		var EpisodeID=rowData.EpisodeID;
		obj.btnEmrRecord_Click(EpisodeID);
    });		
	obj.btnEmrRecord_Click = function(EpisodeID)
	{		
	    var rst = $.Tool.RunServerMethod("DHCHAI.DPS.PAAdmSrv","GetPaAdmHISx",EpisodeID);
		if(rst=="")return;
		var EpisodeID = rst.split("^")[0];
		var PatientID = rst.split("^")[1];
		var url = cspUrl+'&PatientID=' + PatientID+'&EpisodeID='+EpisodeID + '&DefaultOrderPriorType=ALL&2=2';	
		//var url = '../csp/emr.record.browse.csp?PatientID=' + PatientID+'&EpisodeID='+EpisodeID + '&2=2';
		/*parent.layer.open({
		      type: 2,
			  area: ['95%', '95%'],
			  title:false,
			  closeBtn:1,
			  fixed: false, //���̶�
			  maxmin: false,
			  maxmin: false,
			  content: [url,'no']
		});*/
		showFullScreenDiag(url,"���Ӳ���",1);
	};
	$('#gridReport').on('click','a.abstract_msg', function (e) {
	    e.preventDefault();
		var tr = $(this).closest('tr');
		var row = obj.gridReport.row(tr);
		var rowData = row.data();
		var EpisodeID=rowData.EpisodeID;
		obj.btnAbstractMsg_Click(EpisodeID);
    });		
	obj.btnAbstractMsg_Click = function(EpisodeID)
	{	
	    var url = '../csp/dhchai.ir.view.main.csp?PaadmID='+EpisodeID+'&1=1';
		/*
		parent.layer.open({
		      type: 2,
			  area: ['95%', '95%'],
			  title:false,
			  closeBtn:0,
			  fixed: false, //���̶�
			  maxmin: false,
			  maxmin: false,
			  content: [url,'no']
		});
		*/
		showFullScreenDiag(url,"");
	};
	//������ƽӿ�
	obj.btnExportInterface_click = function (objBtn, objEvent, skipMapping) {
		
		//�Ƿ������ֵ���ռ�飨true��������
		if (typeof skipMapping == 'undefined') skipMapping = false;
		
		var RepIDs="";  // ����ID�б�
		$('#gridReport tbody .icheckbox_square-blue').each(function(){
			if ($(this).hasClass("checked")){
				//var tmpRepID = $(this).parent().next().text();
				var tr = $(this).closest("tr");
				var row = obj.gridReport.row(tr);
				var rd = row.data();
				var tmpRepID = rd["ReportID"];
				if (tmpRepID!="") {
					RepIDs +=  "^"+tmpRepID;
				} 
			}
		});
		RepIDs=RepIDs.substring(1);
		if (RepIDs == "") {
			layer.msg('��ѡ����Ҫ�����ı���!',{icon: 2});
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
									var repInfo = $.Tool.RunServerMethod("DHCHAI.MK.ExportToMKSrv","GetReportInfo",repID);
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
								
								layer.confirm("�ӿ��ļ�:��������" + intTotalCnt + "�ݻ��߸�Ⱦ������Ϣ,�Ƿ���ļ�����ļ���!", {
									btn: ['ȷ��','ȡ��'],    //btnλ�ö�Ӧfunction��λ��
									btnAlign: 'c'
									},
									function(){ 
										var WshShell = new ActiveXObject("WScript.Shell");
										var oExec = WshShell.Exec("explorer.exe " + ExportPath);
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
						"D:\\��Ƹ�Ⱦ����ӿ��ļ�"
					)
				}
			}
			,obj
			,skipMapping
		)
	};
	$("#btnExportMK").on('click', function () {
		obj.btnExportInterface_click();	
	});
	
    $(".checkall + .iCheck-helper").click(function(){
		if ($(".checkall + .iCheck-helper").parent().attr("class").indexOf("checked")>=0){
			$('#gridReport tbody .icheckbox_square-blue').addClass("checked");
		}
		else{
			$('#gridReport tbody .icheckbox_square-blue').removeClass("checked");
		}
	});
	$('#gridReport tbody').on('click', '.icheckbox_square-blue', function(){
    	if(!$(this).hasClass('checked')){
	    	// ѡ��
	    	//var tmpRepID = $(this).parent().next().text(); 	
			$(this).addClass("checked");
			$(".checkall + .iCheck-helper").parent().addClass("checked");
			$('#gridReport tbody .icheckbox_square-blue').each(function(){
				if (!$(this).hasClass("checked")){
					$(".checkall + .iCheck-helper").parent().removeClass("checked");
				}
			});
			
    	}else{
	    	// ȡ��
			$(this).removeClass("checked");
			$(".checkall + .iCheck-helper").parent().removeClass("checked");	
	    }
    });
	
    /*
 	//��ӡ
    $("#btnPrint").on('click', function(){
	    obj.gridReport.buttons(0,null)[1].node.click();
		
	});
	*/
	
	$('#gridReport').on('dblclick', 'tr', function(e) {
		var rd = obj.gridReport.row(this).data();
		var ReportID = rd["ReportID"];
		var RepType  = rd["RepType"];
		if (!ReportID) return;
		if (RepType=="1"){
			obj.winOpenInfReport(ReportID);
		}
		if (RepType=="2"){
			obj.winOpenNewInfReport(ReportID);
		}
	});
	
    //����ѡ�з�ʽ
    $('#gridReport').on('click','a.editor_report', function (e) {
	    e.preventDefault();
		var tr = $(this).closest('tr');
		var row = obj.gridReport.row(tr);
		var rowData = row.data();
		var ReportID = rowData.ReportID;
		var RepType  = rowData.RepType;
		if (RepType=="1"){
			obj.winOpenInfReport(ReportID);
		}
		if (RepType=="2"){
			obj.winOpenNewInfReport(ReportID);
		}
    });
	$('#gridReport').on('click','a.editor_diagnos', function (e) {
	    e.preventDefault();
		var tr = $(this).closest('tr');
		var row = obj.gridReport.row(tr);
		var rd = row.data();
		obj.layer_rd = rd;
		var EpisodeID = $(this).attr("data-EpisodeID");
		var DiasID = $(this).attr("data-DiasID");
		OpenINFDiagnosEdit(EpisodeID, DiasID);
    });
	
	function refreshGridReport()
	{
		if(obj.gridReport==null)
		{
			//��Ⱦ�����б�
			obj.gridReport = $("#gridReport").DataTable({
				dom: 'rt<"row"<"col-sm-6 col-xs-6"pl><"col-sm-6 col-xs-6"i>>',
				paging: true,
				ordering: true,
				"order": [[ 1, 'asc' ]], //Ĭ�ϵڶ�����������,ȥ��Ĭ�ϵ�һ������ͼ��
				select: 'single',
				info: true,
				"iDisplayLength" : 10,
				//"autoWidth": true,
				"processing" : true,
				"scrollX": true,
				"scrollY":($(window).height()-165)+"px",//true, //�˴������趨���߶�ֵ
				//"scrollY":"410px",
				"createdRow": function ( row, data, index ) {
					if ( data.ReportStatusDesc == "�ύ") {
						$('td', row).parent().addClass('text-danger');
					}else if (data.ReportStatusDesc != "���") {
						$('td', row).parent().addClass('text-success');
					}
				},
				ajax: {
					"url": "dhchai.query.datatables.csp",
					"data": function (d) {
						d.ClassName = "DHCHAI.IRS.INFDiagnosSrv";
						d.QueryName = "QryRepInfoByDateLoc";
						d.Arg1 =$.form.GetValue("cboDateType");
						d.Arg2 =aDateFrom?aDateFrom:$("#DateFrom").val();
						d.Arg3 =aDateTo?aDateTo:$("#DateTo").val();
						d.Arg4 =$.form.GetValue("cboLocation");
						d.Arg5 =Status?Status:$.form.GetValue("cboStatus");
						//d.Arg6 =$.form.GetValue("cboRepType"); //1:Ժ�б��� 2:����������
						d.Arg6 =aRepType?aRepType:$("#cboRepType").val(); //1:Ժ�б��� 2:����������
						d.Arg7 ="";  //�ǼǺ�
						d.Arg8 =$.form.GetValue("txtMrNO");  //������
						d.Arg9 =$.form.GetValue("txtPatName");  //
						d.Arg10 =$.form.GetValue("cboHospital"); //ҽԺ
						d.Arg11 =$.form.GetValue("cboInfLocation");
						d.ArgCnt = 11;
					}
				},
				"columns": [
					{"data": "IsChecked",orderable: false,
				        "render": function (data, type, row) {
							if(data==1){
								return '<div class="icheckbox_square-blue checked" style="margin-top:4px"><input type="checkbox" style="opacity: 0;" checked></div>';
							}else{
								return '<div class="icheckbox_square-blue" style="margin-top:4px"><input type="checkbox" style="opacity: 0;"></div>';
							}
						}
			        },
					{
						"data": "PatMrNo"
						,render: function (data, type, row) {
							return type === 'export' ?
								String.fromCharCode(2)+data:data;
						}
					},
					{
						"data": null,
						render: function ( data, type, row ) {
							var editHtml = '<a href="#" class="editor_report">'+data.ReportID+'</a>';
							return editHtml;
						}
					},
					{"data": "PatName"},
					{"data": "PatSex"},
					{"data": "PatAge", orderable: false},
					{"data": "ReportStatusDesc"},
					{"data": "ReportLocDesc"},
					{"data": "ReportDate"},
					{"data": "InfLocDesc"},
					{"data": "IRInfDate"},
					{
						"data": "InfPos"
						,render: function (data, type, row) {
							var rs = row["ReportStatusDesc"];
							var InfPos = row["InfPos"];
							var DiasID = row["DiasID"];
							var InfPosArray = InfPos.split(",");
							var DiasIDArray = DiasID.split(",");
							var InfPosHtml = "";
							for (var i=0; i<InfPosArray.length; i++) {
								if ((rs == "���")||(rs == "����")||(rs == "ɾ��")||(rs == "�˻�")) {
									InfPosHtml += InfPosArray[i];
									if (i !== InfPosArray.length-1) InfPosHtml += '<br>';
								} else {
									InfPosHtml += '<a href="#" class="editor_diagnos" data-EpisodeID="' +row["EpisodeID"]+ '" data-DiasID="'+ DiasIDArray[i] +'">'+InfPosArray[i]+'</a>';
									if (i !== InfPosArray.length-1) InfPosHtml += '<br>';
								}
							}
							return InfPosHtml;
						}
					},
					{
						"data": null,
						render: function ( data, type, row ) {
							var editHtml = '<a href="#" class="abstract_msg">ժҪ</a>';
							return editHtml;
						}
					},
					{
						"data": null,
						render: function ( data, type, row ) {
							var editHtml = '<a href="#" class="Emr_Record">���Ӳ���</a>';
							return editHtml;
						}
					},
					//{"data": "InfEffectDesc"},
					//{"data": "InfEffectDate"},
					{
						"data": null,
						render: function ( data, type, row ) {
							var editHtml = '<a href="#" class="editor_msg">��ͨ��¼</a>';
							return editHtml;
						}
					},
					{"data": "ReportUserDesc",
						render: function ( data, type, row ) {
							var editHtml = data+'&nbsp&nbsp&nbsp';
							return editHtml;
						}
					},
					{"data": "ReturnReason",
						render: function ( data, type, row ) {
							var editHtml = data+"&nbsp&nbsp&nbsp";
							return editHtml; 
						}
					}
				],
				"columnDefs": [
					{ 
						"type": "date-euro", 
						targets: [8,10,15] 	//������/��/����������ʱ������
					}
				]
				,"fnDrawCallback": function (oSettings) {
					if($('#gridReport tbody .icheckbox_square-blue').length>0){
						$(".checkall + .iCheck-helper").parent().addClass("checked");
						$('#gridReport tbody .icheckbox_square-blue').each(function(){
							if (!$(this).hasClass("checked")){
							$(".checkall + .iCheck-helper").parent().removeClass("checked");
						}
						});
					}
					$("#gridReport_wrapper .dataTables_scrollBody").mCustomScrollbar({
						theme : "dark-thick",
						axis: "xy",
						callbacks:{
							whileScrolling:function(){
								$('#gridReport_wrapper .dataTables_scrollHead').scrollLeft(-this.mcs.left); 
							}
						}
					});			
					$("#gridReport_wrapper .dataTables_scrollBody").mCustomScrollbar("scrollTo",$("#gridReport tr td:first"));
		        }
					
			});
			
			new $.fn.dataTable.Buttons(obj.gridReport, {
				buttons: [					
					{
						extend: 'excel',
						text:'����',
						title:"��Ⱦ�����ѯ"
						,footer: true
						,exportOptions: {
							columns: ':visible'
							,width:50
							,orthogonal: 'export'
						},
						customize: function( xlsx ) {
							var sheet = xlsx.xl.worksheets['sheet.xml'];
							
						}
					}
					/*
					,{
						extend: 'print',
						text:'��ӡ'
						,title:""
						,footer: true
					}*/
				]
			});
		} else {
			obj.gridReport.ajax.reload( function ( json ) {
				$(".checkall + .iCheck-helper").parent().removeClass("checked");	
				setTimeout(function(){
				  	layer.closeAll('loading');
				}, 100);
			    if (json.data.length==0){
					layer.msg('û���ҵ�������ݣ�',{time: 2000,icon: 2});
					return;
				}
			});
		}
		
	}
	
	obj.winOpenInfReport = function(aReportID)
	{
		if (!aReportID) return;
		var url="dhcma.hai.ir.inf.report.csp?1=1&ReportID="+aReportID+'&AdminPower='+ obj.AdminPower+"&2=2";
		websys_showModal({
			url:url,
			title:'ҽԺ��Ⱦ����',
			iconCls:'icon-w-epr',
			closable:false,
			width:1320,
			height:'95%',
			onBeforeClose:function(){
				obj.gridReport.ajax.reload(null,false);
				$(".checkall + .iCheck-helper").parent().removeClass("checked");	
			}
		});
	}
	obj.winOpenNewInfReport = function(aReportID)
	{
		if (!aReportID) return;
		var url="dhcma.hai.ir.inf.nreport.csp?1=1&ReportID="+aReportID+'&AdminPower='+ obj.AdminPower+"&2=2";
		websys_showModal({
			url:url,
			title:'������ҽԺ��Ⱦ����',
			iconCls:'icon-w-epr',
			closable:false,
			width:1320,
			height:'95%',
			onBeforeClose:function(){
				obj.gridReport.ajax.reload(null,false);
				$(".checkall + .iCheck-helper").parent().removeClass("checked");	
			}
		});
	}
	
	// ������Ⱦ��Ϣ����
	function OpenINFDiagnosEdit(aEpisodeID,aDiasID) {
		layer.open({
			type: 1,
			zIndex: 100,
			maxmin: false,
			title: "��Ⱦ��Ϣ-�༭", 
			area: ['700px',''],
			content: $('#LayerINFDiagnosEidt'),
			btnAlign: 'c',
			btn: ['����','ȡ��'],
			yes: function(index, layero){
				INFDiagnosAdd(aEpisodeID, aDiasID);
			}
			,success: function(layero){
				InitINFDiagnosEidtData(aEpisodeID, aDiasID);
			}
		});	
	}
	
	obj.checkDate = function(d) {
		d = $.Tool.RunServerMethod("DHCHAI.IO.FromHisSrv","DateHtmlToLogical",d);
		var cDateFrom = obj.layer_rd.AdmitDate;
		var cDateTo = obj.layer_rd.DischDate;
		if (cDateTo==''){
			cDateTo = $.form.GetCurrDate('-');
		}
		var flg1 = $.form.CompareDate(d,cDateFrom);
		var flg2 = $.form.CompareDate(cDateTo,d);
		if (flg1&&flg2){
			return true;
		}else{
			return false;
		}
	}
	
	// ��ʼ����Ⱦ��Ϣ�༭������
	function InitINFDiagnosEidtData(aEpisodeID, aDiasID){
		if (!aDiasID) return;
		// ��Ⱦ�ؼ�
		$.form.SelectRender("#cboInfPos");
		$("#cboInfSub").data("param","^");	
		$.form.SelectRender("#cboInfSub");
		$.form.SelectRender('cboInfEffect');
		$("#cboInfLoc").data("param",aEpisodeID+"^E");
		$.form.SelectRender('cboInfLoc');
		// ��Ⱦ��Ϻͷ�����й���
		$("#cboInfPos").change(function(){
			var InfPosID = $.form.GetValue("cboInfPos");
			$("#cboInfSub").data("param",InfPosID+"^");	
			$.form.SelectRender("#cboInfSub");
		});
		
		// �༭��ֵ
		var InfDiag = $.Tool.RunServerMethod('DHCHAI.IRS.INFDiagnosSrv','GetStrByRowID', aDiasID);
		if (!InfDiag) return;
		var InfDiagArray = InfDiag.split("^");
		if (InfDiagArray){
			$.form.SetValue("cboInfPos",InfDiagArray[1],InfDiagArray[2]);
			$.form.SetValue("cboInfSub",InfDiagArray[3],InfDiagArray[4]);
			$.form.DateRender('txtInfDate',InfDiagArray[5]);
			$.form.DateRender('txtInfXDate',InfDiagArray[10]);
			$.form.SetValue("cboInfLoc",InfDiagArray[6],InfDiagArray[7]);
			$.form.SetValue("cboInfEffect",InfDiagArray[11],InfDiagArray[12]);
			if (InfDiagArray[13]!=''){
				var selector = '#chkDeathRelation '+'#'+InfDiagArray[13];
				$(selector).iCheck('check');
			}
			$('#txtDiagnosisBasis').val(InfDiagArray[8]);
			$('#txtDiseaseCourse').val(InfDiagArray[9]);
			obj.IsReportDiag = InfDiagArray[15];	// �Ƿ��ٴ��ϱ����
		}else{
			$.form.SetValue("cboInfPos",'','');
			$.form.SetValue("cboInfSub",'','');
			$.form.DateRender('txtInfDate','');
			$.form.DateRender('txtInfXDate','');
			// ֻ��һ������Ĭ��ѡ��˿���
			if ($('#cboInfLoc>option').length==2){
				$.form.SetValue("cboInfLoc",$("#cboInfLoc>option:nth-child(2)").val(),$("#cboInfLoc>option:nth-child(2)").text());
			};
			$("input[name='chkDeathRelation']").iCheck('uncheck');
			$('#txtDiagnosisBasis').val('');
			$('#txtDiseaseCourse').val('');
			obj.IsReportDiag = 1;	// �Ƿ��ٴ��ϱ����
		}
	}
	
	function INFDiagnosAdd(aEpisodeID, aDiasID) {
		var InfPosID = $.form.GetValue("cboInfPos");
		if (InfPosID==''){
			var InfPos='';
		}else{
			var InfPos = $.form.GetText("cboInfPos");
		}
		var InfSubID = $.form.GetValue("cboInfSub");
		if (InfSubID==''){
			var InfSub='';
		}else{
			var InfSub = $.form.GetText("cboInfSub");
		}
		var InfDate = $.form.GetValue("txtInfDate");
		var InfLocID = $.form.GetValue("cboInfLoc");
		if (InfLocID==''){
			var InfLoc = '';
		}else{
			var InfLoc = $.form.GetText("cboInfLoc");
		}
		var InfXDate = $.form.GetValue("txtInfXDate");
		var InfEffectID = $.form.GetValue("cboInfEffect");
		if (InfEffectID==''){
			var InfEffect = '';
		}else{
			var InfEffect = $.form.GetText("cboInfEffect");
		}
		var DiagnosisBasis = $.form.GetValue("txtDiagnosisBasis");
		var DiseaseCourse = $.form.GetValue("txtDiseaseCourse");
		var DeathRelationID = '';
		var DeathRelation = '';
        $('input:radio',$("#chkDeathRelation")).each(function(){
       		if(true == $(this).is(':checked')){
            	DeathRelationID=$(this).attr("id");
            	DeathRelation = $(this).parent().parent().text();
       		}
    	})

        if (InfPosID==''){
    		layer.msg('��Ⱦ��ϲ���Ϊ��!',{icon: 2});
			return;
    	}

    	// ��Ⱦ����
    	if (InfDate==''){
    		layer.msg('��Ⱦ���ڲ���Ϊ��!',{icon: 2});
			return;
    	}else{
	    	if (!obj.checkDate(InfDate)){
				layer.msg('��Ⱦʱ����Ҫ��סԺ�ڼ�!',{icon: 2});
				return;
			}
		}
    	if (InfLocID==''){
    		layer.msg('��Ⱦ���Ҳ���Ϊ��!',{icon: 2});
			return;
    	}

    	// ��Ⱦ�������� ��Ⱦת��
    	if (InfXDate!=''){
    		if (!$.form.CompareDate(InfXDate,InfDate)){
    			layer.msg('��Ⱦ�������ڲ����ڸ�Ⱦ����֮ǰ!',{icon: 2});
				return;
    		}
			if (!obj.checkDate(InfXDate)){
				layer.msg('��Ⱦ������������סԺ�ڼ��Ҳ�Ӧ������ǰ����!',{icon: 2});
				return;
			}
    		if (InfEffectID==''){
		    	layer.msg('��Ⱦ�������Ⱦת�鲻��Ϊ��!',{icon: 2});
				return;
		    }
    	}else{
    		// ��Ⱦת��Ϊ��������������ת�����Ⱦ��������
    		if ((InfEffect=='����')||(InfEffect=='����')||(InfEffect=='��ת')){
    			layer.msg('��Ⱦת��Ϊ��������������ת��Ⱦ�������ڲ���Ϊ��!',{icon: 2});
				return;
			}
    	}

    	// ������������Ⱦת��Ϊ������������ϵ����
    	if (((obj.layer_rd.IsDeath=='1')||(InfEffect=='����'))&&(DeathRelationID=='')){
    		layer.msg('��Ⱦת��Ϊ����������������������ϵ����Ϊ��!',{icon: 2});
				return;
    	};
		var InputStr = aDiasID;
		InputStr += "^" + aEpisodeID;
		InputStr += "^" + InfPosID;
		InputStr += "^" + InfSubID;
		InputStr += "^" + InfDate;
		InputStr += "^" + InfLocID;
		InputStr += "^" + DiagnosisBasis;
		InputStr += "^" + DiseaseCourse;
		InputStr += "^" + InfXDate;
		InputStr += "^" + InfEffectID;
		InputStr += "^" + DeathRelationID;
		InputStr += "^" + "";
		InputStr += "^" + "";
		InputStr += "^" + $.LOGON.USERID;
		InputStr += "^" + obj.IsReportDiag;
		InputStr += "^" + "";
		//����
		var retval = $.Tool.RunServerMethod("DHCHAI.IR.INFDiagnos","Update", InputStr, "^");
		if (parseInt(retval)>0){
			refreshGridReport();
			layer.msg('����ɹ�!',{icon: 1});
		} else {
			layer.msg('����ʧ��!',{icon: 2});
		}
	}
	
	//�������
    obj.refreshgridDiagBasis = function () {
		if(obj.gridDiagBasis==undefined)
		{
			obj.gridDiagBasis = $("#gridDiagBasis").DataTable({	
				dom: 'rt',
			    //select: 'single',
				ordering: true,
				"order": [[1, 'asc']], //Ĭ�ϵڶ�����������,ȥ��Ĭ�ϵ�һ������ͼ��
			    paging: false,
			    "aoColumnDefs": [ 
					{
						"bSortable": false, 
						"aTargets": [ 0 ] 
					}
				],
				info: true,
				ajax: {
					"url": "dhchai.query.datatables.csp",
					"data": function (d) {
						d.ClassName = "DHCHAI.BTS.InfPosGistSrv";
						d.QueryName = "QryInfPosGist";
						var InfPosID = $.form.GetValue("cboInfPos");
						d.Arg1 = "";
						d.Arg2 = InfPosID;
						d.ArgCnt = 2;
					}
				},
				columns: [
		            {"data": "IsChecked",
				        "render": function (data, type, row) {	
							if(data==1){
								return '<div class="icheckbox_square-blue checked" style="margin-top:4px"><input type="checkbox" style="opacity: 0;" checked></div>';
							
							}else{
								return '<div class="icheckbox_square-blue" style="margin-top:4px"><input type="checkbox" style="opacity: 0;"></div>';
							}
						}
			        },
					{"data": "ID","visible": false},
		            {"data": "BTDesc",
					    render: function(data, type, row, meta) { 
							return '<span style="float:left;" title="'+data +'">'+data +'</span>';
				  	 	} 
					},
		            {"data": "TypeDesc",
					    render: function(data, type, row, meta) {
							return '<span style="float:center;" title="'+data +'">'+data +'</span>';
				  	 	}
					},
					{"data": "InfPos","visible": false}
				],
		        "drawCallback": function(settings) {
		            var api = this.api();
		            var rows = api.rows({
		                page: 'current'
		            }).nodes();
		            var last = null;
					
		            api.column(4, {  //���ݵ�5�з���
		                page: 'current'
		            }).data().each(function(group, i) {
		                if (last !== group) {
		                    $(rows).eq(i).before('<tr class="group"><td colspan="2" style="text-align:left">' + group + '</td></tr>');
		                    last = group;
		                }
		            });
		        }
				
			});
		}else{
			obj.gridDiagBasis.ajax.reload(function(){});
		}
	}
	var DiagBasisList="";
    $('#gridDiagBasis tbody').on('click', '.icheckbox_square-blue', function(){
    	if(!$(this).hasClass('checked')){
	    	// ѡ��
	    	var BTDesc = $(this).parent().next().text(); 	
			$(this).addClass("checked");
			DiagBasisList += BTDesc+" ";
    	}else{
	    	// ȡ��  	
	    	var BTDesc = $(this).parent().next().text();
			$(this).removeClass("checked");
			DiagBasisList = DiagBasisList.replace(BTDesc+" ","")		
	    }
    });
	//�������
	$("#btnDiagBasis").click(function(e){
		obj.refreshgridDiagBasis();
		obj.LayerBasis = layer.open({
			type: 1,  
			zIndex: 101,
			title: '�������-ѡ��', 
			area: '700px',
			content: $('#LayerDiagBasis'),
			btn: ['ȷ��','ȡ��'],
			btnAlign: 'c',
			yes: function(index, layero){
				var DiagBasis = $.form.GetValue("txtDiagnosisBasis"); 
				if (!DiagBasis) {
					$('#txtDiagnosisBasis').val(DiagBasisList);
				}else {
				    $('#txtDiagnosisBasis').val(DiagBasis+DiagBasisList);
				}
				layer.close(index);
			},end:function (){
				 DiagBasisList="";
			 }
		});
	});
    //��������
    obj.refreshgridDiagCourse = function(){
		if(obj.gridDiagCourse==undefined)
		{
			obj.gridDiagCourse = $("#gridDiagCourse").DataTable({
				dom: 'rt',
				paging: false,
				//select: 'single',
				"aoColumnDefs": [ 
					{
						"bSortable": false, 
						"aTargets": [ 0 ] 
					}
				],
				info: true,
				ajax: {
					"url": "dhchai.query.datatables.csp",
					"data": function (d) {
						d.ClassName = "DHCHAI.BTS.DictionarySrv";
						d.QueryName = "QryDic";
						d.Arg1 ="DiseaseCourse";
						d.Arg2 = 1;
						d.ArgCnt = 2;
					}
				},
				columns: [
					{"data": "IsChecked",
				        "render": function (data, type, row) {	
							if(data==1){
								return '<div class="icheckbox_square-blue checked" style="margin-top:4px"><input type="checkbox" style="opacity: 0;" checked></div>';
							
							}else{
								return '<div class="icheckbox_square-blue" style="margin-top:4px"><input type="checkbox" style="opacity: 0;"></div>';
							}
						}
			         },
					{"data": "ID","visible": false},
					{"data": "DicDesc",
					    render: function(data, type, row, meta) { 
							return '<span style="float:left;" title="'+data +'">'+data +'</span>';
				  	 	} 
					}	
				]
			});
		}else {
			obj.gridDiagCourse.ajax.reload(function(){});
		}
    }
	var DiagCourseList="";
    $('#gridDiagCourse tbody').on('click', '.icheckbox_square-blue', function(){
    	if(!$(this).hasClass('checked')){
	    	// ѡ��
	    	var DicDesc = $(this).parent().next().text(); 	
			$(this).addClass("checked");
			DiagCourseList += DicDesc+" ";
    	}else{
	    	// ȡ��  	
	    	var DicDesc = $(this).parent().next().text();
			$(this).removeClass("checked");
			DiagCourseList = DiagCourseList.replace(DicDesc+" ","")		
	    }
    });
   
	$("#btnDiagCourse").click(function(e){
		obj.refreshgridDiagCourse();	
		obj.LayerCourse = layer.open({
			type: 1,  
			zIndex: 101,
			title: '��Ⱦ�Լ�������-ѡ��', 
			area: '500px',
			content: $('#LayerDiagCourse'),
			btn: ['ȷ��','ȡ��'],
			btnAlign: 'c',
			yes: function(index, layero){
				var DiagCourse = $.form.GetValue("txtDiseaseCourse"); 
				if (!DiagCourse) {
					$('#txtDiseaseCourse').val(DiagCourseList);
				}else {
				    $('#txtDiseaseCourse').val(DiagCourse+DiagCourseList);
				}
				layer.close(index);
			},
			end:function (){
				 DiagCourseList="";
			 }
		});
	});
	
}

//function getContentSize() {
//    var wh = document.documentElement.clientHeight; 
//    var eh = 166;
//    var ch = (wh - eh) + "px";
//    var obj = $("#divMain .mCustomScrollBox.mCS-dark-thick.mCSB_vertical_horizontal.mCSB_inside")[0];
//    var dh=$('div.dataTables_scrollHead').height();
//    var sh=(wh - eh + dh )+ "px"; 
//    if (obj){  
//   		obj.style.height = ch;
//    }else {
//	   $('div.dataTables_scrollBody').css('height',sh);
//    }
//}
/*
//Chrome�ڴ��ڸı��Сʱ��ִ������       
var isResizing = false;
window.onresize =function(){	
	if (!isResizing) {
		getContentSize();   
		setTimeout(function () {
			isResizing = false;
		}, 100);
	}
	isResizing = true;
}
window.onload = function(){
	 setTimeout(function () {
     	getContentSize();
    }, 100);
}*/
