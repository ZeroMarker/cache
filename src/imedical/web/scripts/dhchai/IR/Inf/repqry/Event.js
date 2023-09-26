function InitCtlResultWinEvent(obj){
	CheckSpecificKey();
    // 初始化权限
	// 渲染checkbox
	$.form.CheckBoxRender();
	$.form.iCheckRender();  //渲染复选框|单选钮
	//赋值初始值
    $("#cboHospital").data("param",$.LOGON.HOSPID);	
	$.form.SelectRender("#cboHospital");  //渲染下拉框
	$("#cboHospital option:selected").next().attr("selected", true);	
	$("#cboHospital").select2();
    $("#cboLocation").data("param",$.form.GetValue("cboHospital")+"^^I^E^1");
	$.form.SelectRender("cboLocation");  //渲染下拉框
	$("#cboInfLocation").data("param",$.form.GetValue("cboHospital")+"^^I^E^1");
	$.form.SelectRender("cboInfLocation");
	$.form.SelectRender("cboRepType");
   
    
    //如果是临床科室，设置报告科室不可用
    if (tDHCMedMenuOper['Clinical'] == 1) {
        //报告科室默认不可选中
        $("#cboLocation").attr("disabled", "disabled");
        //获取临床科室
        var LocId = $.LOGON.LOCID;	//session['LOGON.CTLOCID']; 
        $("#cboLocation").data("param", "^^I^E^1^"+LocId);
        $.form.SelectRender("cboLocation");  //渲染下拉框
        //给报告科室赋初始值
        $.form.SetValue("cboLocation", $("#cboLocation>option:nth-child(" + 2 + ")").val(), $("#cboLocation>option:nth-child(" + 2 + ")").text());
    }
    else                                                    //默认管理员权限
    {
        obj.AdminPower = '0';
        if (typeof tDHCMedMenuOper != 'undefined') {
            if (typeof tDHCMedMenuOper['Admin'] != 'undefined') {
                obj.AdminPower = tDHCMedMenuOper['Admin'];
            }
        }
        //给select2赋值change事件
        $("#cboHospital").on("select2:select", function (e) {
            //获得选中的医院
            var data = e.params.data;
            var id = data.id;
            var text = data.text;
            $("#cboLocation").data("param", id + "^^I^E^1");
            $.form.SelectRender("cboLocation");  //渲染下拉框	
             $("#cboInfLocation").data("param", id + "^^I^E^1");
            $.form.SelectRender("cboInfLocation");  //渲染下拉框	
        });
    }
	
	$.form.SelectRender("#cboStatus");
	$.form.CheckBoxRender("#divpInfEffect");
	$.form.iCheckRender();  //渲染复选框|单选钮
	
	/*****搜索功能*****/
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
    //查询按钮
    $("#btnQuery").on('click', function(){
        //add
		var DateFrom = $.form.GetValue("DateFrom");
		var DateTo   = $.form.GetValue("DateTo");
		
		if ((DateFrom == '')||(DateTo=='')) {
			layer.alert('出院日期不允许为空!',{icon: 0});
			return ;
		}
		
		if(DateFrom>DateTo){
			layer.alert('开始日期不允许大于结束日期!',{icon: 0});
			return ;	
		}
		//end
	    
	   if(obj.gridReport){                                      
	        //清空，在refreshGridReport()初始化表格，防止内容过长把表格撑开又缩不回去
		    //$("#gridReport_wrapper .dataTables_scrollBody").mCustomScrollbar("destroy");
		    //$("#gridReport").dataTable().fnDestroy();
		    //obj.gridReport=null;
			//清空的问题没有用 bug 605394
		    refreshGridReport();
	    }
		refreshGridReport();
	});
    $("#txtMrNO").keyup(function(event){
	    if (event.keyCode == 13) {
	        $("#btnQuery").click();
	    }
	});
     //导出
    $("#btnExport").on('click', function(){
		obj.gridReport.buttons(0,null)[0].node.click();
	});
	//发送消息
    //链接选中方式
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
			type: 2,  //0(信息框,默认) 1(页面层)  2(iframe层) 3(加载层) 4(tips层)
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
			  fixed: false, //不固定
			  maxmin: false,
			  maxmin: false,
			  content: [url,'no']
		});*/
		showFullScreenDiag(url,"电子病历",1);
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
			  fixed: false, //不固定
			  maxmin: false,
			  maxmin: false,
			  content: [url,'no']
		});
		*/
		showFullScreenDiag(url,"");
	};
	//导出民科接口
	obj.btnExportInterface_click = function (objBtn, objEvent, skipMapping) {
		
		//是否跳过字典对照检查（true：跳过）
		if (typeof skipMapping == 'undefined') skipMapping = false;
		
		var RepIDs="";  // 报告ID列表
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
			layer.msg('请选择需要导出的报告!',{icon: 2});
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
					ExtTool.prompt("文件路径", "请输入民科接口文件存放路径...",
						function(e, text){
							if (e == "ok") {
								var objExportMinke = new ExportMinke();
								var ExportPath = text;
							
								//创建进度条
								Ext.MessageBox.progress("接口文件", "开始导出民科接口文件...");
								var intTotalCnt = arrList.length;
								for(var indRec = 0; indRec < intTotalCnt; indRec++)
								{
									var repID = arrList[indRec];
									var repInfo = $.Tool.RunServerMethod("DHCHAI.MK.ExportToMKSrv","GetReportInfo",repID);
									var PatName = repInfo.split("^")[0];
									var PatMrNo = repInfo.split("^")[1];
									var PatAdmDate = repInfo.split("^")[2];
									//更新进度条
									Ext.MessageBox.updateProgress(indRec/intTotalCnt, '', "正在处理：" + PatMrNo + " " + PatName);
									var strfolderName = PatMrNo + " " + PatName + " " + PatAdmDate;
									var strPath = ExportPath + "\\" + strfolderName;
									objExportMinke.ExportMinkeData(repID, strPath,RepIDs);
								}
								
								//关闭进度条
								Ext.MessageBox.hide();
								
								layer.confirm("接口文件:共处理了" + intTotalCnt + "份患者感染报告信息,是否打开文件存放文件夹!", {
									btn: ['确认','取消'],    //btn位置对应function的位置
									btnAlign: 'c'
									},
									function(){ 
										var WshShell = new ActiveXObject("WScript.Shell");
										var oExec = WshShell.Exec("explorer.exe " + ExportPath);
								 });
		 						/*	
								ExtTool.confirm("接口文件", "共处理了" + intTotalCnt + "份患者感染报告信息,是否打开文件存放文件夹!", function(btn, txt) {
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
						"D:\\民科感染报告接口文件"
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
	    	// 选中
	    	//var tmpRepID = $(this).parent().next().text(); 	
			$(this).addClass("checked");
			$(".checkall + .iCheck-helper").parent().addClass("checked");
			$('#gridReport tbody .icheckbox_square-blue').each(function(){
				if (!$(this).hasClass("checked")){
					$(".checkall + .iCheck-helper").parent().removeClass("checked");
				}
			});
			
    	}else{
	    	// 取消
			$(this).removeClass("checked");
			$(".checkall + .iCheck-helper").parent().removeClass("checked");	
	    }
    });
	
    /*
 	//打印
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
	
    //链接选中方式
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
			//感染报告列表
			obj.gridReport = $("#gridReport").DataTable({
				dom: 'rt<"row"<"col-sm-6 col-xs-6"pl><"col-sm-6 col-xs-6"i>>',
				paging: true,
				ordering: true,
				"order": [[ 1, 'asc' ]], //默认第二列升序排序,去掉默认第一列升序图标
				select: 'single',
				info: true,
				"iDisplayLength" : 10,
				//"autoWidth": true,
				"processing" : true,
				"scrollX": true,
				"scrollY":($(window).height()-165)+"px",//true, //此处可以设定最大高度值
				//"scrollY":"410px",
				"createdRow": function ( row, data, index ) {
					if ( data.ReportStatusDesc == "提交") {
						$('td', row).parent().addClass('text-danger');
					}else if (data.ReportStatusDesc != "审核") {
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
						//d.Arg6 =$.form.GetValue("cboRepType"); //1:院感报告 2:新生儿报告
						d.Arg6 =aRepType?aRepType:$("#cboRepType").val(); //1:院感报告 2:新生儿报告
						d.Arg7 ="";  //登记号
						d.Arg8 =$.form.GetValue("txtMrNO");  //病案号
						d.Arg9 =$.form.GetValue("txtPatName");  //
						d.Arg10 =$.form.GetValue("cboHospital"); //医院
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
								if ((rs == "审核")||(rs == "作废")||(rs == "删除")||(rs == "退回")) {
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
							var editHtml = '<a href="#" class="abstract_msg">摘要</a>';
							return editHtml;
						}
					},
					{
						"data": null,
						render: function ( data, type, row ) {
							var editHtml = '<a href="#" class="Emr_Record">电子病历</a>';
							return editHtml;
						}
					},
					//{"data": "InfEffectDesc"},
					//{"data": "InfEffectDate"},
					{
						"data": null,
						render: function ( data, type, row ) {
							var editHtml = '<a href="#" class="editor_msg">沟通记录</a>';
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
						targets: [8,10,15] 	//适配日/月/年类型日期时的排序
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
						text:'导出',
						title:"感染报告查询"
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
						text:'打印'
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
					layer.msg('没有找到相关数据！',{time: 2000,icon: 2});
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
			title:'医院感染报告',
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
			title:'新生儿医院感染报告',
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
	
	// 弹出感染信息弹框
	function OpenINFDiagnosEdit(aEpisodeID,aDiasID) {
		layer.open({
			type: 1,
			zIndex: 100,
			maxmin: false,
			title: "感染信息-编辑", 
			area: ['700px',''],
			content: $('#LayerINFDiagnosEidt'),
			btnAlign: 'c',
			btn: ['保存','取消'],
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
	
	// 初始化感染信息编辑框数据
	function InitINFDiagnosEidtData(aEpisodeID, aDiasID){
		if (!aDiasID) return;
		// 渲染控件
		$.form.SelectRender("#cboInfPos");
		$("#cboInfSub").data("param","^");	
		$.form.SelectRender("#cboInfSub");
		$.form.SelectRender('cboInfEffect');
		$("#cboInfLoc").data("param",aEpisodeID+"^E");
		$.form.SelectRender('cboInfLoc');
		// 感染诊断和分类进行关联
		$("#cboInfPos").change(function(){
			var InfPosID = $.form.GetValue("cboInfPos");
			$("#cboInfSub").data("param",InfPosID+"^");	
			$.form.SelectRender("#cboInfSub");
		});
		
		// 编辑框赋值
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
			obj.IsReportDiag = InfDiagArray[15];	// 是否临床上报诊断
		}else{
			$.form.SetValue("cboInfPos",'','');
			$.form.SetValue("cboInfSub",'','');
			$.form.DateRender('txtInfDate','');
			$.form.DateRender('txtInfXDate','');
			// 只有一个科室默认选择此科室
			if ($('#cboInfLoc>option').length==2){
				$.form.SetValue("cboInfLoc",$("#cboInfLoc>option:nth-child(2)").val(),$("#cboInfLoc>option:nth-child(2)").text());
			};
			$("input[name='chkDeathRelation']").iCheck('uncheck');
			$('#txtDiagnosisBasis').val('');
			$('#txtDiseaseCourse').val('');
			obj.IsReportDiag = 1;	// 是否临床上报诊断
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
    		layer.msg('感染诊断不能为空!',{icon: 2});
			return;
    	}

    	// 感染日期
    	if (InfDate==''){
    		layer.msg('感染日期不能为空!',{icon: 2});
			return;
    	}else{
	    	if (!obj.checkDate(InfDate)){
				layer.msg('感染时间需要在住院期间!',{icon: 2});
				return;
			}
		}
    	if (InfLocID==''){
    		layer.msg('感染科室不能为空!',{icon: 2});
			return;
    	}

    	// 感染结束日期 感染转归
    	if (InfXDate!=''){
    		if (!$.form.CompareDate(InfXDate,InfDate)){
    			layer.msg('感染结束日期不能在感染日期之前!',{icon: 2});
				return;
    		}
			if (!obj.checkDate(InfXDate)){
				layer.msg('感染结束日期需在住院期间且不应超出当前日期!',{icon: 2});
				return;
			}
    		if (InfEffectID==''){
		    	layer.msg('感染结束后感染转归不能为空!',{icon: 2});
				return;
		    }
    	}else{
    		// 感染转归为治愈、死亡、好转必填感染结束日期
    		if ((InfEffect=='治愈')||(InfEffect=='死亡')||(InfEffect=='好转')){
    			layer.msg('感染转归为治愈、死亡、好转感染结束日期不能为空!',{icon: 2});
				return;
			}
    	}

    	// 死亡病例、感染转归为死亡，死亡关系必填
    	if (((obj.layer_rd.IsDeath=='1')||(InfEffect=='死亡'))&&(DeathRelationID=='')){
    		layer.msg('感染转归为死亡、死亡病例与死亡关系不能为空!',{icon: 2});
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
		//保存
		var retval = $.Tool.RunServerMethod("DHCHAI.IR.INFDiagnos","Update", InputStr, "^");
		if (parseInt(retval)>0){
			refreshGridReport();
			layer.msg('保存成功!',{icon: 1});
		} else {
			layer.msg('保存失败!',{icon: 2});
		}
	}
	
	//诊断依据
    obj.refreshgridDiagBasis = function () {
		if(obj.gridDiagBasis==undefined)
		{
			obj.gridDiagBasis = $("#gridDiagBasis").DataTable({	
				dom: 'rt',
			    //select: 'single',
				ordering: true,
				"order": [[1, 'asc']], //默认第二列升序排序,去掉默认第一列升序图标
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
					
		            api.column(4, {  //根据第5列分组
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
	    	// 选中
	    	var BTDesc = $(this).parent().next().text(); 	
			$(this).addClass("checked");
			DiagBasisList += BTDesc+" ";
    	}else{
	    	// 取消  	
	    	var BTDesc = $(this).parent().next().text();
			$(this).removeClass("checked");
			DiagBasisList = DiagBasisList.replace(BTDesc+" ","")		
	    }
    });
	//诊断依据
	$("#btnDiagBasis").click(function(e){
		obj.refreshgridDiagBasis();
		obj.LayerBasis = layer.open({
			type: 1,  
			zIndex: 101,
			title: '诊断依据-选择', 
			area: '700px',
			content: $('#LayerDiagBasis'),
			btn: ['确认','取消'],
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
    //疾病病程
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
	    	// 选中
	    	var DicDesc = $(this).parent().next().text(); 	
			$(this).addClass("checked");
			DiagCourseList += DicDesc+" ";
    	}else{
	    	// 取消  	
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
			title: '感染性疾病病程-选择', 
			area: '500px',
			content: $('#LayerDiagCourse'),
			btn: ['确认','取消'],
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
//Chrome在窗口改变大小时会执行两次       
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
