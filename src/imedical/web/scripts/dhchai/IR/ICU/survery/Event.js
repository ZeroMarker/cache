//页面Event
function InitSurveryWinEvent(obj){
	CheckSpecificKey();
	var LocID=$.LOGON.LOCID; //登录科室
	var LocDesc=$.LOGON.LOCDESC; //登录科室
	var IsAdmin = 0;
	if (tDHCMedMenuOper['Admin']==1) {
		IsAdmin = 1;  //管理员权限
	}
	$('#gridLocPatients,#gridLocNPatients,gridLocNAPatients').on('draw.dt', function () {   //渲染复选框
    	$.form.iCheckRender();
    });
    //日期切换刷新
	$("#startDate").change(function(){
	    var txt=$('#ulLoc > li.active').attr("text");
	    var arr = txt.split("^");
		myLoading();
		if ($(".Loading_animate_content").length != 0) {
			myLoadingBug();
			$(".Loading_animate_content").css("display","block");
		}
		if(arr.length==2)
		{
			var locID = arr[0];
			var nicuFlag = arr[1];
			$('#ulLoc').val(locID);
			if(nicuFlag=="1"){  //NICU科室
				if (NICUISApgar==1){
					var objGrid = $('#gridLogsNA');
					if (objGrid){
						objGrid.DataTable().clear().draw();
					}
					$('.icu-mode-list').hide();
					$('.nicu-mode-list').hide();
					$('.nicu-apgar-mode-list').show();
					setTimeout(refreshGridLogsN,0.2*1000);  //错开达到异步
				}else{
					var objGrid = $('#gridLogsN');
					if (objGrid){
						objGrid.DataTable().clear().draw();
					}
					$('.icu-mode-list').hide();
					$('.nicu-mode-list').show();
					$('.nicu-apgar-mode-list').hide();
					setTimeout(refreshGridLogsNA,0.2*1000);  //错开达到异步
				}
			}else if (nicuFlag=="0"){  //ICU科室
				var objGrid = $('#gridLogs');
				if (objGrid){
					objGrid.DataTable().clear().draw();
				}
				$('.nicu-mode-list').hide();
				$('.nicu-apgar-mode-list').hide();
				$('.icu-mode-list').show();
				setTimeout(refreshGridLogs,0.2*1000);  //错开达到异步
			}else{  //未配置
				var objGrid = $('#gridLogs');
				if (objGrid){
					objGrid.DataTable().clear().draw();
				}
				$('.nicu-mode-list').hide();
				$('.nicu-apgar-mode-list').hide();
				$('.icu-mode-list').show();
				//setTimeout(refreshGridLogs,0.2*1000);  //错开达到异步
				myLoadHiden();
			}
		}	    			
	});
	//给select2赋值change事件
	$("#cboHospital").on("select2:select", function (e) { 
		//获得选中的医院
		var data= e.params.data;
		var id = data.id;
		var text =data.text;
		refreshLocList();
		
	});
	refreshLocList();
	//科室列表
	function refreshLocList() {
		if (IsAdmin!=1) {
			$.form.SetValue("cboHospital",$.LOGON.HOSPID,$.LOGON.HOSPDESC);// 默认加载登录院区
			$("#cboHospital").attr('disabled','disabled');
			var hospId = $.form.GetValue("cboHospital");
			var runQuery = $.Tool.RunQuery('DHCHAI.BTS.LocationSrv','QryICULoc',hospId,$.LOGON.LOCID);
		}else{
			var hospId = $.form.GetValue("cboHospital");
			var runQuery = $.Tool.RunQuery('DHCHAI.BTS.LocationSrv','QryICULoc',hospId);
		}
		
		if(runQuery){
			//$("#ulLoc").addClass("list-group");
			$("#ulLoc").empty();
			var icuLocFlag = 0;
			var arrDT = runQuery.record;
			for (var idx = 0; idx < arrDT.length; idx++){
				var obj = arrDT[idx];
				// if((IsAdmin!=1)&&(LocID!=obj.ID)) {
				// 	continue;
				// }
				icuLocFlag = 1;
				//$("#ulLoc").val(22);
				if (obj.IsNICU=="1"){
					$("#ulLoc").append('<li class="active" text="' + obj.ID + '^1">' + obj.LocDesc2 + '<small class="pull-right bg-yellow">NICU</small></li>');
				} else {
					$("#ulLoc").append('<li text="'+obj.ID+'^0">' + obj.LocDesc2 + '</li>');
				}
			}
			if (icuLocFlag<1){
				$("#ulLoc").append('<li text="'+LocID+'^-1">' + LocDesc + '（未配置）</li>');
			}
			if(arrDT.length>0){
				//防止表格未渲染完就点击
				if ($(".Loading_animate_content").length != 0) {
					if ($(".Loading_animate_bg").length == 0) {
						var html = '<div class="Loading_animate_bg">'
				    		+'<div class="loading">'
							+	'<img src="../scripts/dhchai/img/loading.gif"/>'
				    		+'</div>'
				    		+'</div>'
							+ '<div class="Loading_animate_font">加载中...</div>';
						$(".Loading_animate_content").append(html);
					}
				}
			}
		}
		//科室选中逻辑
		$('#ulLoc > li').click(function (e) {
			e.preventDefault();
			$('#ulLoc > li').removeClass('active');
			$(this).addClass('active');
			var txt = $(this).attr("text");
			var arr = txt.split("^");
			
			myLoading();
			if ($(".Loading_animate_content").length != 0) {
				myLoadingBug();
				$(".Loading_animate_content").css("display","block");
			}
			if(arr.length==2)
			{
				var locID = arr[0];
				var nicuFlag = arr[1];
				$('#ulLoc').val(locID);
				//写死$("#ulLoc").val("22");
				if (nicuFlag=="1"){  //NICU科室
					if (NICUISApgar==1){
					
						$('.icu-mode-list').hide();
						$('.nicu-mode-list').hide();
						$('.nicu-apgar-mode-list').show();
						setTimeout(refreshGridLogsNA,0.2*1000);  //错开达到异步
					}else{
						$('.icu-mode-list').hide();
						$('.nicu-apgar-mode-list').hide();
						$('.nicu-mode-list').show();
						setTimeout(refreshGridLogsN,0.2*1000);  //错开达到异步
					}
				}else if (nicuFlag=="0"){  //ICU科室
					$('.nicu-mode-list').hide();
					$('.nicu-apgar-mode-list').hide();
					$('.icu-mode-list').show();
					setTimeout(refreshGridLogs,0.2*1000);  //错开达到异步
				}else{  //未配置
					var objGrid = $('#gridLogs');
					if (objGrid){
						//objGrid.DataTable().clear().draw();
					}
					$('.nicu-mode-list').hide();
					$('.nicu-apgar-mode-list').hide();
					$('.icu-mode-list').show();
					myLoadHiden();
					//setTimeout(refreshGridLogs,0.2*1000);  //错开达到异步
				}
			}	    		
		});
		//科室第一条选中触发
		$('#ulLoc li:first-child').click();
	}
	
	
	//ICU链接选中方式
    $('#gridLogs').on('click', 'a.editor_edit', function (e) {
        e.preventDefault();
		var tr = $(this).closest('tr');
		var row = obj.gridLogs.row(tr);
		var rowData = row.data();
		obj.layerSel = rowData;
		//alert(rowData.LocID+"---"+rowData.SurveryDate);
		//$("#ICULogTitle").html("ICU插管情况("+rowData.LocDesc+" "+rowData.SurveryDate+")");
		obj.layerIdxPat = layer.open({
				type: 1,  //0(信息框,默认) 1(页面层)  2(iframe层) 3(加载层) 4(tips层)
				zIndex: 101,
				area: ['100%','100%'],
				maxmin: false
				,title: "ICU插管情况("+rowData.LocDesc+" "+rowData.SurveryDate+")", 
				content: $('#winICULogsEditModal'),
				btn: [],
				success: function(layero){
										
					//展示回调
					refreshGridLocPatients();
					if(obj.gridICUOEItems==undefined)
					{
						
					}
					else
					{
						obj.layerSelPat.Paadm = "";
						obj.gridICUOEItems.clear().draw();
					}
				}
		});
		
		
    } );
	$("#sendLogDtl").on('click', function(){
		//带管日志明细
		if (obj.layerSel){
		} else {
			layer.msg("请选择对应的确认日期记录！");
			return;
		}
		
		var ILLocDr =obj.layerSel.LocID;
		var ILDate = obj.layerSel.SurveryDate;
		$('#gridLocPatients tbody tr').each( function (){
			var tr = $(this);
			var row = obj.gridLocPatients.row(tr);
			var data=row.data();
			var td7 = $('td',tr).eq(7);
			var chk1 = $('td input:checkbox',tr).eq(0);  //静脉
			var chk2 = $('td input:checkbox',tr).eq(1); //呼吸机
			var chk3 = $('td input:checkbox',tr).eq(2); //泌尿
			var ID ="";
			var Paadm = data.Paadm;
			//debugger
			var ILIsVAP ="0",ILIsPICC="0",ILIsUC="0",ILIsOper="0";
			if (chk1.is(":checked")){
				ILIsPICC = "1";
			}
			if (chk2.is(":checked")){
				ILIsVAP = "1";
			}
			if (chk3.is(":checked")){
				ILIsUC = "1";
			}
			
			var InputStr = ID;
			InputStr += "^" + Paadm;
			InputStr += "^" + ILLocDr;
			InputStr += "^" + ILDate;
			InputStr += "^" + ILIsVAP;
			InputStr += "^" + ILIsPICC;
			InputStr += "^" + ILIsUC;
			InputStr += "^" + ILIsOper;
			var retval = $.Tool.RunServerMethod("DHCHAI.IR.ICULogDtl","Update",InputStr);
		});
		var retval = $.Tool.RunServerMethod("DHCHAI.IRS.ICULogSrv","CreateICULogByDay",ILDate,ILDate,ILLocDr);
		if (parseInt(retval)>0){
			layer.msg('ICU日志确认成功!',{time: 2000,icon: 1});
			refreshGridLogs();
			layer.close(obj.layerIdxPat);
		} else {
			layer.msg('ICU日志确认失败!',{icon: 2});
		}
	});
	$("#sendLogNDtl").on('click', function(){
		//NICU带管日志明细
		if (obj.layerSel){
		} else {
			layer.msg("请选择对应的确认日期记录！");
			return;
		}
		var ILLocDr =obj.layerSel.LocID;
		var ILDate = obj.layerSel.SurveryDate;
		$('#gridLocNPatients tbody tr').each( function (){
			var tr = $(this);
			var row = obj.gridLocNPatients.row(tr);
			var data=row.data();
			var td7 = $('td',tr).eq(7);
			var chk1 = $('td input:checkbox',tr).eq(0);  //脐、静脉
			var chk2 = $('td input:checkbox',tr).eq(1); //呼吸机
			//var chk3 = $('td input:checkbox',tr).eq(2); //泌尿
			var ID ="";
			var Paadm = data.Paadm;
			//debugger
			var ILIsVAP ="0",ILIsPICC="0",ILIsUC="0",ILIsOper="0";
			if(chk1.is(":checked"))
			{
				ILIsPICC = "1";
			}
			if(chk2.is(":checked"))
			{
				ILIsVAP = "1";
			}
			
			var InputStr = ID;
			InputStr += "^" + Paadm;
			InputStr += "^" + ILLocDr;
			InputStr += "^" + ILDate;
			InputStr += "^" + ILIsVAP;
			InputStr += "^" + ILIsPICC;
			InputStr += "^" + ILIsUC;
			InputStr += "^" + ILIsOper;
			var retval = $.Tool.RunServerMethod("DHCHAI.IR.ICULogDtl","Update",InputStr);
		});
		var retval = $.Tool.RunServerMethod("DHCHAI.IRS.ICULogSrv","CreateICULogByDay",ILDate,ILDate,ILLocDr);
		if (parseInt(retval)>0){
			layer.msg('NICU日志确认成功!',{time: 2000,icon: 1});
			refreshGridLogsN();
			layer.close(obj.layerIdxNPat);
		} else {
			layer.msg('NICU日志确认失败!',{icon: 2});
		}
	});
	$("#sendLogNADtl").on('click', function(){
		//NICU带管日志明细
		if (obj.layerSel){
		} else {
			layer.msg("请选择对应的确认日期记录！");
			return;
		}
		var ILLocDr =obj.layerSel.LocID;
		var ILDate = obj.layerSel.SurveryDate;
		$('#gridLocNAPatients tbody tr').each( function (){
			var tr = $(this);
			var row = obj.gridLocNAPatients.row(tr);
			var data=row.data();
			var td7 = $('td',tr).eq(7);
			var chk1 = $('td input:checkbox',tr).eq(0);  //脐、静脉
			var chk2 = $('td input:checkbox',tr).eq(1); //呼吸机
			//var chk3 = $('td input:checkbox',tr).eq(2); //泌尿
			var ID ="";
			var Paadm = data.Paadm;
			//debugger
			var ILIsVAP ="0",ILIsPICC="0",ILIsUC="0",ILIsOper="0";
			if(chk1.is(":checked"))
			{
				ILIsPICC = "1";
			}
			if(chk2.is(":checked"))
			{
				ILIsVAP = "1";
			}
			
			var InputStr = ID;
			InputStr += "^" + Paadm;
			InputStr += "^" + ILLocDr;
			InputStr += "^" + ILDate;
			InputStr += "^" + ILIsVAP;
			InputStr += "^" + ILIsPICC;
			InputStr += "^" + ILIsUC;
			InputStr += "^" + ILIsOper;
			var retval = $.Tool.RunServerMethod("DHCHAI.IR.ICULogDtl","Update",InputStr);
		});
		var retval = $.Tool.RunServerMethod("DHCHAI.IRS.ICULogSrv","CreateICULogByDay",ILDate,ILDate,ILLocDr);
		if (parseInt(retval)>0){
			layer.msg('NICU日志确认成功!',{time: 2000,icon: 1});
			refreshGridLogsNA();
			layer.close(obj.layerIdxNAPat);
		} else {
			layer.msg('NICU日志确认失败!',{icon: 2});
		}
	});
	$("#btnAdd").on('click', function(){
		myLoading();
		if ($(".Loading_animate_content").length != 0) {
			myLoadingBug();
			$(".Loading_animate_content").css({"display":"block","z-index":"9999","position":"absolute","top":"0","width":"100%","height":"100%"});   //覆盖在modal上面，显示出来
		}
		setTimeout(createICULogs,0.2*1000);  //错开达到异步				 
	});
	function createICULogs()
	{
		//根据医嘱生成插拔管日志
		var Count = 0;
		var aDateFrom = obj.layerSel.SurveryDate;
		var aDateTo =obj.layerSel.SurveryDate;
		var aLocDr = obj.layerSel.LocID;
		var aEpisodeDr ="";
		var rowsdata=obj.gridLocPatients.rows().data();
		for (var indRst = 0; indRst < rowsdata.length; indRst++){
			var data = rowsdata[indRst];
			var retval = $.Tool.RunServerMethod("DHCHAI.IRS.ICULogSrv","CreateICULogByOEOrd",aDateFrom,aDateTo,aLocDr,data.Paadm);
			if (parseInt(retval)>0){
				Count++;
			}
		}
		//add 20190513 生成日志明细同时生成日志汇总
		var retval = $.Tool.RunServerMethod("DHCHAI.IRS.ICULogSrv","CreateICULogByDay",aDateFrom,aDateTo,aLocDr);
		if (parseInt(retval)>0){
			refreshGridLogs();
		}
		refreshGridLocPatients();  //myLoadHiden(); 放到加载数据里了
		
		layer.msg('根据医嘱自动生成插拔管日志成功:'+Count+'',{icon: 1});
	};
	$("#btnAddN").on('click', function(){
		myLoading();
		if ($(".Loading_animate_content").length != 0) {
			myLoadingBug();
			$(".Loading_animate_content").css({"display":"block","z-index":"9999","position":"absolute","top":"0","width":"100%","height":"100%"});    //覆盖在modal上面，显示出来
		}
		setTimeout(createNICULogs,0.2*1000);  //错开达到异步			
	});
	function createNICULogs()
	{
		//根据医嘱生成插拔管日志
		var Count = 0;
		var aDateFrom = obj.layerSel.SurveryDate;
		var aDateTo =obj.layerSel.SurveryDate;
		var aLocDr = obj.layerSel.LocID;
		var aEpisodeDr ="";
		var rowsdata=obj.gridLocNPatients.rows().data();
		for (var indRst = 0; indRst < rowsdata.length; indRst++){
			var data = rowsdata[indRst];
			var retval = $.Tool.RunServerMethod("DHCHAI.IRS.ICULogSrv","CreateICULogByOEOrd",aDateFrom,aDateTo,aLocDr,data.Paadm);
			if (parseInt(retval)>0){
				Count++;
			}
		}
		//add 20190513 生成日志明细同时生成日志汇总
		var retval = $.Tool.RunServerMethod("DHCHAI.IRS.ICULogSrv","CreateICULogByDay",aDateFrom,aDateTo,aLocDr);
		if (parseInt(retval)>0){
			refreshGridLogs();
		}
		refreshGridLocNPatients();
		layer.msg('根据医嘱自动生成插拔管日志成功:'+Count+'',{icon: 1});
	};
	$("#btnAddNA").on('click', function(){
		myLoading();
		if ($(".Loading_animate_content").length != 0) {
			myLoadingBug();
			$(".Loading_animate_content").css({"display":"block","z-index":"9999","position":"absolute","top":"0","width":"100%","height":"100%"});    //覆盖在modal上面，显示出来
		}
		setTimeout(createNICUApgarLogs,0.2*1000);  //错开达到异步			
	});
	function createNICUApgarLogs()
	{
		//根据医嘱生成插拔管日志
		var Count = 0;
		var aDateFrom = obj.layerSel.SurveryDate;
		var aDateTo =obj.layerSel.SurveryDate;
		var aLocDr = obj.layerSel.LocID;
		var aEpisodeDr ="";
		var rowsdata=obj.gridLocNAPatients.rows().data();
		for (var indRst = 0; indRst < rowsdata.length; indRst++){
			var data = rowsdata[indRst];
			var retval = $.Tool.RunServerMethod("DHCHAI.IRS.ICULogSrv","CreateICULogByOEOrd",aDateFrom,aDateTo,aLocDr,data.Paadm);
			if (parseInt(retval)>0){
				Count++;
			}
		}
		//add 20190513 生成日志明细同时生成日志汇总
		var retval = $.Tool.RunServerMethod("DHCHAI.IRS.ICULogSrv","CreateICULogByDay",aDateFrom,aDateTo,aLocDr);
		if (parseInt(retval)>0){
			refreshGridLogs();
		}
		refreshGridLocNAPatients();
		layer.msg('根据医嘱自动生成插拔管日志成功:'+Count+'',{icon: 1});
	};
	/*
	$("#btnPrint").on('click', function(){
		obj.gridLogs.buttons(0,null)[2].node.click();
	});
	*/
	$("#btnExport").on('click', function(){
		//导出
		obj.gridLogs.buttons(0,null)[1].node.click();
		
	});
	//NICU表格
	/*
	$("#btnPrintN").on('click', function(){
		obj.gridLogsN.buttons(0,null)[1].node.click();
	});
	*/
	$("#btnExportN").on('click', function(){
		//导出
		obj.gridLogsN.buttons(0,null)[0].node.click();
	});
		
	//NICU链接选中方式
    $('#gridLogsN').on('click', 'a.editor_edit', function (e) {
        e.preventDefault();
		var tr = $(this).closest('tr');
		var row = obj.gridLogsN.row(tr);
		var rowData = row.data();
		//alert(rowData.LocID+"---"+rowData.SurveryDate);
		obj.layerSel = rowData;
		obj.layerIdxNPat = layer.open({
				type: 1,  //0(信息框,默认) 1(页面层)  2(iframe层) 3(加载层) 4(tips层)
				zIndex: 101,
				area: ['100%','100%'],
				maxmin: false
				,title: "NICU插管情况("+rowData.LocDesc+" "+rowData.SurveryDate+")", 
				content: $('#winICULogsNEditModal'),
				btn: [],
				success: function(layero){
					//展示回调
					refreshGridLocNPatients();
					if(obj.gridNICUOEItems==undefined)
					{
						
					}
					else
					{
						obj.layerSelPat.Paadm = "";
						obj.gridNICUOEItems.clear().draw();
					}
				}
		});
    });
  $('#gridLogsNA').on('click', 'a.editor_edit', function (e) {
        e.preventDefault();
		var tr = $(this).closest('tr');
		var row = obj.gridLogsNA.row(tr);
		var rowData = row.data();
		//alert(rowData.LocID+"---"+rowData.SurveryDate);
		obj.layerSel = rowData;
		obj.layerIdxNAPat = layer.open({
				type: 1,  //0(信息框,默认) 1(页面层)  2(iframe层) 3(加载层) 4(tips层)
				zIndex: 101,
				area: ['100%','100%'],
				maxmin: false
				,title: "NICU插管情况("+rowData.LocDesc+" "+rowData.SurveryDate+")", 
				content: $('#winICULogsNAEditModal'),
				btn: [],
				success: function(layero){
					//展示回调
					refreshGridLocNAPatients();
					if(obj.gridNICUApgarOEItems==undefined)
					{
						
					}
					else
					{
						obj.layerSelPat.Paadm = "";
						obj.gridNICUApgarOEItems.clear().draw();
					}
				}
		});
    });
	$('#ulOeItem > li').click(function (e) {
		e.preventDefault();
		$('#ulOeItem > li').removeClass('active');
		$(this).addClass('active');
		var val = $(this).val();
		$('#ulOeItem').val(val);
		if (!obj.layerSelPat.Paadm) return;
		//obj.gridICUOEItems.ajax.reload();
		if(obj.gridICUOEItems==undefined)
		{
			obj.gridICUOEItems = $("#gridICUOEItems").DataTable({
				dom: 'rt<"row"<"col-sm-10 col-xs-10"pl>>',
				select: 'single',
				paging: true,
				ordering: true,
				ajax: {
					"url": "dhchai.query.datatables.csp",
					"data": function (d) {
						d.ClassName = "DHCHAI.IRS.ICULogSrv";
						d.QueryName = "QryICUAdmOeItem";
						d.Arg1=obj.layerSelPat.Paadm;
						d.Arg2=$('#ulOeItem').val();
						d.ArgCnt = 2;
					}
				},
				columns: [
					{"data": "OeItemDesc"},
					{"data": "StartDt"},
					{"data": "EndDt"}
				],
				"createdRow": function ( row, data, index ) {
					if ( data.TypeValue=="临时医嘱") {
						$('td', row).addClass('danger');
					}
				}
			});
		}
		else
		{
			//存在情况下
			obj.gridICUOEItems.ajax.reload(function(){});
		}
	});
	$('#ulOeItemN > li').click(function (e) {
		e.preventDefault();
		$('#ulOeItemN > li').removeClass('active');
		$(this).addClass('active');
		var val = $(this).val();
		$('#ulOeItemN').val(val);
		if (!obj.layerSelPat.Paadm) return;
		if(obj.gridNICUOEItems==undefined)
		{
			obj.gridNICUOEItems = $("#gridNICUOEItems").DataTable({
				dom: 'rt<"row"<"col-sm-10 col-xs-10"pl>>',
				select: 'single',
				paging: true,
				ordering: true,
				ajax: {
					"url": "dhchai.query.datatables.csp",
					"data": function (d) {
						d.ClassName = "DHCHAI.IRS.ICULogSrv";
						d.QueryName = "QryICUAdmOeItem";
						d.Arg1=obj.layerSelPat.Paadm;
						d.Arg2=$('#ulOeItemN').val();
						d.ArgCnt = 2;
					}
				},
				columns: [
					{"data": "OeItemDesc"},
					{"data": "StartDt"},
					{"data": "EndDt"}
				],
				"createdRow": function ( row, data, index ) {
					if ( data.TypeValue=="临时医嘱") {
						$('td', row).addClass('danger');
					}
				}
			});
		}
		else
		{
			//存在情况下
			obj.gridNICUOEItems.ajax.reload(function(){				
			});
		}
	});
	$('#ulOeItemNA > li').click(function (e) {
		e.preventDefault();
		$('#ulOeItemNA > li').removeClass('active');
		$(this).addClass('active');
		var val = $(this).val();
		$('#ulOeItemNA').val(val);
		if (!obj.layerSelPat.Paadm) return;
		if(obj.gridNICUApgarOEItems==undefined)
		{
			obj.gridNICUApgarOEItems = $("#gridNICUApgarOEItems").DataTable({
				dom: 'rt<"row"<"col-sm-10 col-xs-10"pl>>',
				select: 'single',
				paging: true,
				ordering: true,
				ajax: {
					"url": "dhchai.query.datatables.csp",
					"data": function (d) {
						d.ClassName = "DHCHAI.IRS.ICULogSrv";
						d.QueryName = "QryICUAdmOeItem";
						d.Arg1=obj.layerSelPat.Paadm;
						d.Arg2=$('#ulOeItemNA').val();
						d.ArgCnt = 2;
					}
				},
				columns: [
					{"data": "OeItemDesc"},
					{"data": "StartDt"},
					{"data": "EndDt"}
				],
				"createdRow": function ( row, data, index ) {
					if ( data.TypeValue=="临时医嘱") {
						$('td', row).addClass('danger');
					}
				}
			});
		}
		else
		{
			//存在情况下
			obj.gridNICUApgarOEItems.ajax.reload(function(){				
			});
		}
	});
	//刷新ICU患者列表
	function refreshGridLogs()
	{
		//var rd = obj.layerRep_rd;
		if(obj.gridLogs==undefined)
		{
			//列表
			obj.gridLogs = $("#gridLogs").on('processing.dt', function ( e, settings, processing ) {
				//$('#processingIndicator').css( 'display', processing ? 'block' : 'none' );
				if(!processing)
				{
					$("#gridLogs").dataTable().fnAdjustColumnSizing();
					myLoadHiden();
				}
			}).DataTable({
				dom: 'rt',
				paging:false,
				ordering: false,
				columnDefs: [
						{"className": "dt-center", "targets": "_all"}
				],				
				ajax: {
					"url": "dhchai.query.datatables.csp",
					"data": function (d) {
						d.ClassName = "DHCHAI.IRS.ICULogSrv";
						d.QueryName = "QryAISByMonth";
						d.Arg1=$("#startDate").val();
						d.Arg2=$('#ulLoc').val();
						d.ArgCnt = 2;
					}
				},
				columns: [
					{"data": "SurveryDay",render: function (data, type, row) {
						return type === 'export' ?
							row.SurveryDate:'<a href="#" class="editor_edit">'+data+'</a>';
					}},
					{"data": "AISItem1"},
					{
						"data": null,
						 render: function ( data, type, row ) {
							return '<a href="#" class="editor_edit">'+data.AISItem2+'</a>';
						}
					},
					{"data": "AISItem3"},
					{"data": "AISItem6"},
					{"data": "AISItem4"},
					{"data": "AISItem5"}
				],
				
				"footerCallback": function ( row, data, start, end, display ) {
					var api = this.api();
					// Remove the formatting to get integer data for summation
					var intVal = function ( i ) {
						return typeof i === 'string' ?
							i.replace(/[\$,]/g, '')*1 :
							typeof i === 'number' ?
								i : 0;
					};
					// 新入科人
					var total1 = api
						.column(1)
						.data()
						.reduce( function (a, b) {
							return intVal(a) + intVal(b);
						},0 );
					// 在科人数
					var col2 = api.rows().data();
					var total2 =0;
					col2.each( function (d) {
						total2 = total2+ intVal(d.AISItem2);
					});    
					// 出科人数
					var total3 = api
						.column(3)
						.data()
						.reduce( function (a, b) {
							return intVal(a) + intVal(b);
						},0 );
					// 泌尿道插管
					var total4 = api
						.column(4)
						.data()
						.reduce( function (a, b) {
							return intVal(a) + intVal(b);
						},0 );
					// 呼吸机
					var total5 = api
						.column(5)
						.data()
						.reduce( function (a, b) {
							return intVal(a) + intVal(b);
						},0 );
					// 中心静脉置管
					var total6 = api
						.column(6)
						.data()
						.reduce( function (a, b) {
							return intVal(a) + intVal(b);
						},0 );
					// Update footer
					$(api.column(1).footer()).html(total1);  
					$(api.column(2).footer()).html(total2);
					$(api.column(3).footer()).html(total3);
					$(api.column(4).footer()).html(total4);
					$(api.column(5).footer()).html(total5);
					$(api.column(6).footer()).html(total6);
					
				}
			});
		
			//增加ICU表格导出打印
			new $.fn.dataTable.Buttons( obj.gridLogs, {
				buttons: [
					{
						extend: 'csv',
						text:'导出'
					},
					{
						extend: 'excel',
						text:'导出',
						title:"ICU日志"
						,footer: true
						,exportOptions: {
							columns: ':visible'
							,width:50
							,orthogonal: 'export'
						},
						customize: function( xlsx ) {
							//console.log(xlsx);
							var sheet = xlsx.xl.worksheets['sheet1.xml'];
							var downrows = 1;
							var clRow = $('row', sheet);
							//update Row
							clRow.each(function () {
								var attr = $(this).attr('r');
								var ind = parseInt(attr);
								ind = ind + downrows;
								$(this).attr("r",ind);
							});
					 
							// Update  row > c
							$('row c ', sheet).each(function () {
								var attr = $(this).attr('r');
								var pre = attr.substring(0, 1);
								var ind = parseInt(attr.substring(1, attr.length));
								ind = ind + downrows;
								$(this).attr("r", pre + ind);
							});
							/*
							function Addrow(index, data) {
								var row = sheet.createElement('row');
								row.setAttribute("r", index);              
								   for (i = 0; i < data.length; i++) {
									   var key = data[i].key;
									   var value = data[i].value;

									   var c  = sheet.createElement('c');
									   c.setAttribute("t", "inlineStr");
									   c.setAttribute("s", "2");
									   c.setAttribute("r", key + index);

									   var is = sheet.createElement('is');
									   var t = sheet.createElement('t');
									   var text = sheet.createTextNode(value)

									   t.appendChild(text);                                      
									   is.appendChild(t);
									   c.appendChild(is);
									   row.appendChild(c);               
								   }
								   return row;
							}
							*/
							//$('row:eq('+(row-1)+') c', sheet).attr( 's', '51' ); // centre
				
							//var r1 = Addrow(1, [{ key: 'A', value: '标题:' }, { key: 'B', value: 'ICU' }]);
							/*
							//sheet.childNodes[0].childNodes[1].innerHTML = r1 + r2+ r3+ sheet.childNodes[0].childNodes[1].innerHTML;
							//var sheetData = sheet.getElementsByTagName('sheetData')[0];
							//sheetData.insertBefore(r1,sheetData.childNodes[0]);
							var lastCol = sheet.getElementsByTagName('col').length - 1;
							var colRange = createCellPos( lastCol ) + '1';
							//Has to be done this way to avoid creation of unwanted namespace atributes.
							var afSerializer = new XMLSerializer();
							var xmlString = afSerializer.serializeToString(sheet);
							var parser = new DOMParser();
							var xmlDoc = parser.parseFromString(xmlString,'text/xml');
							
							var $('row', sheet);
							
							var mergeCells = sheet.createElement('mergeCells');
							mergeCells.setAttribute( 'count', 1 );
							
							var c  = sheet.createElement('mergeCell');
							c.setAttribute("ref", "A1:H1");
							mergeCells.appendChild(c); 
							//$(sheet).append(mergeCells);
							debugger
							var sheetData = sheet.getElementsByTagName('sheetData')[0];
							sheetData.insertBefore(mergeCells);*/
							//console.log(xlsx);
						}
					},
					{
						extend: 'print',
						text:'打印'
						,title:""
						,footer: true
					}
				]
			});
			
			
		}
		else
		{
			//存在情况下
			obj.gridLogs.ajax.reload(function(){});
		}
		//myLoadHiden(); //移到表格渲染结束
	}
	//刷新NICU患者列表
	function refreshGridLogsN()
	{
		//var rd = obj.layerRep_rd;
		if(obj.gridLogsN==undefined)
		{
			//Nicu日志列表
			obj.gridLogsN = $("#gridLogsN").on('processing.dt', function ( e, settings, processing ) {
				//$('#processingIndicator').css( 'display', processing ? 'block' : 'none' );
				
				if(!processing)
				{
					$("#gridLogsN").dataTable().fnAdjustColumnSizing();
					myLoadHiden();
				}
			}).DataTable({
				dom: 'rt',
				paging:false,
				ordering: false,
				columnDefs: [
						{"className": "dt-center", "targets": "_all"}
				],
				ajax: {
					"url": "dhchai.query.datatables.csp",
					"data": function (d) {
						d.ClassName = "DHCHAI.IRS.ICULogSrv";
						d.QueryName = "QryNAISByMonth";
						d.Arg1=$("#startDate").val();
						d.Arg2=$('#ulLoc').val();
						d.ArgCnt = 2;
					}
				},
				columns: [
					{"data": "SurveryDay",render: function (data, type, row) {
						return type === 'export' ?
							row.SurveryDate:'<a href="#" class="editor_edit">'+data+'</a>';
					}},
					
					{"data": "AISItem1"},
					{
						"data": "AISItem2"
					},
					{"data": "AISItem3"},
					{"data": "AISItem4"},
					{"data": "AISItem5"},
					{
						"data": "AISItem6"
					},
					{"data": "AISItem7"},
					{"data": "AISItem8"},
					{"data": "AISItem9"},
					{
						"data": "AISItem10"
					},
					{"data": "AISItem11"},
					{"data": "AISItem12"},
					{"data": "AISItem13"},
					{
						"data": "AISItem14"
					},
					{"data": "AISItem15"},
					{"data": "AISItem16"},
					{"data": "AISItem17"},
					{
						"data": "AISItem18"
					},
					{"data": "AISItem19"},
					{"data": "AISItem20"},
				],
				"footerCallback": function ( row, data, start, end, display ) {
					var api = this.api();
					// Remove the formatting to get integer data for summation
					var intVal = function ( i ) {
						return typeof i === 'string' ?
							i.replace(/[\$,]/g, '')*1 :
							typeof i === 'number' ?
								i : 0;
					};
					// 新入科人
					var total1 = api
						.column(1)
						.data()
						.reduce( function (a, b) {
							return intVal(a) + intVal(b);
						},0 );
					// 在科人数
					var col2 = api.rows().data();
					var total2 =0;
					col2.each( function (d) {
						total2 = total2+ intVal(d.AISItem2);
					});
  					var total3 = api
						.column(3)
						.data()
						.reduce( function (a, b) {
							return intVal(a) + intVal(b);
						},0 );
					var total4 = api
						.column(4)
						.data()
						.reduce( function (a, b) {
							return intVal(a) + intVal(b);
						},0 );	
					var total5 = api
						.column(5)
						.data()
						.reduce( function (a, b) {
							return intVal(a) + intVal(b);
						},0 );
					var total6 = api
						.column(6)
						.data()
						.reduce( function (a, b) {
							return intVal(a) + intVal(b);
						},0 );
					var total7 = api
						.column(7)
						.data()
						.reduce( function (a, b) {
							return intVal(a) + intVal(b);
						},0 );
					var total8 = api
						.column(8)
						.data()
						.reduce( function (a, b) {
							return intVal(a) + intVal(b);
						},0 );
					var total9 = api
						.column(9)
						.data()
						.reduce( function (a, b) {
							return intVal(a) + intVal(b);
						},0 );
					var total10 = api
						.column(10)
						.data()
						.reduce( function (a, b) {
							return intVal(a) + intVal(b);
						},0 );
					var total11 = api
						.column(11)
						.data()
						.reduce( function (a, b) {
							return intVal(a) + intVal(b);
						},0 );
					var total12 = api
						.column(12)
						.data()
						.reduce( function (a, b) {
							return intVal(a) + intVal(b);
						},0 );
					var total13 = api
						.column(13)
						.data()
						.reduce( function (a, b) {
							return intVal(a) + intVal(b);
						},0 );	
					var total14 = api
						.column(14)
						.data()
						.reduce( function (a, b) {
							return intVal(a) + intVal(b);
						},0 );
					var total15 = api
						.column(15)
						.data()
						.reduce( function (a, b) {
							return intVal(a) + intVal(b);
						},0 );
					var total16 = api
						.column(16)
						.data()
						.reduce( function (a, b) {
							return intVal(a) + intVal(b);
						},0 );	
					var total17 = api
						.column(17)
						.data()
						.reduce( function (a, b) {
							return intVal(a) + intVal(b);
						},0 );	
					var total18 = api
						.column(18)
						.data()
						.reduce( function (a, b) {
							return intVal(a) + intVal(b);
						},0 );
					var total19 = api
						.column(19)
						.data()
						.reduce( function (a, b) {
							return intVal(a) + intVal(b);
						},0 );	
					var total20 = api
						.column(20)
						.data()
						.reduce( function (a, b) {
							return intVal(a) + intVal(b);
						},0 );	
					// Update footer
					$(api.column(1).footer()).html(total1);  
					$(api.column(2).footer()).html(total2);
					$(api.column(3).footer()).html(total3);  
					$(api.column(4).footer()).html(total4);  
					$(api.column(5).footer()).html(total5);
					$(api.column(6).footer()).html(total6);  
					$(api.column(7).footer()).html(total7);  
					$(api.column(8).footer()).html(total8);  
					$(api.column(9).footer()).html(total9); 
					$(api.column(10).footer()).html(total10);  
					$(api.column(11).footer()).html(total11);  
					$(api.column(12).footer()).html(total12);  
					$(api.column(13).footer()).html(total13);
					$(api.column(14).footer()).html(total14);  
					$(api.column(15).footer()).html(total15);  
					$(api.column(16).footer()).html(total16);
					$(api.column(17).footer()).html(total17);
					$(api.column(18).footer()).html(total18);  
					$(api.column(19).footer()).html(total19);
					$(api.column(20).footer()).html(total20);
				}
			});
		
			//增加NICU表格导出打印
			new $.fn.dataTable.Buttons( obj.gridLogsN, {
				buttons: [
					{
						extend: 'excel',
						text:'导出',
						title:"NICU日志"
						,footer: true
						,exportOptions: {
							columns: ':visible'
							,width:50
							,orthogonal: 'export'
						},
						customize: function( xlsx ) {
							var sheet = xlsx.xl.worksheets['sheet1.xml'];
						}
					},
					{
						extend: 'print',
						text:'打印'
						,title:""
						,footer: true
						,exportOptions: { orthogonal: 'export' }				
					}
				]
			});
		}
		else
		{
			//存在情况下
			obj.gridLogsN.ajax.reload(function(){});
		}
		//myLoadHiden();
	}
	//刷新NICU患者列表
	function refreshGridLogsNA()
	{
		//var rd = obj.layerRep_rd;
		if(obj.gridLogsNA==undefined)
		{
			//Nicu日志列表
			obj.gridLogsNA = $("#gridLogsNA").on('processing.dt', function ( e, settings, processing ) {
				//$('#processingIndicator').css( 'display', processing ? 'block' : 'none' );
				
				if(!processing)
				{
					$("#gridLogsNA").dataTable().fnAdjustColumnSizing();
					myLoadHiden();
				}
			}).DataTable({
				dom: 'rt',
				paging:false,
				ordering: false,
				columnDefs: [
						{"className": "dt-center", "targets": "_all"}
				],
				ajax: {
					"url": "dhchai.query.datatables.csp",
					"data": function (d) {
						d.ClassName = "DHCHAI.IRS.ICULogSrv";
						d.QueryName = "QryNAISByMonth";
						d.Arg1=$("#startDate").val();
						d.Arg2=$('#ulLoc').val();
						d.ArgCnt = 2;
					}
				},
				columns: [
					{"data": "SurveryDay",render: function (data, type, row) {
						return type === 'export' ?
							row.SurveryDate:'<a href="#" class="editor_edit">'+data+'</a>';
					}},
					
					{"data": "AISItem1"},
					{
						"data": "AISItem2"
					},
					{"data": "AISItem3"},
					{"data": "AISItem4"},
					{"data": "AISItem5"},
					{
						"data": "AISItem6"
					},
					{"data": "AISItem7"},
					{"data": "AISItem8"},
					{"data": "AISItem9"},
					{
						"data": "AISItem10"
					},
					{"data": "AISItem11"},
					{"data": "AISItem12"},
					{"data": "AISItem13"},
					{
						"data": "AISItem14"
					},
					{"data": "AISItem15"},
					{"data": "AISItem16"}
					
				],
				"footerCallback": function ( row, data, start, end, display ) {
					var api = this.api();
					// Remove the formatting to get integer data for summation
					var intVal = function ( i ) {
						return typeof i === 'string' ?
							i.replace(/[\$,]/g, '')*1 :
							typeof i === 'number' ?
								i : 0;
					};
					// 新入科人
					var total1 = api
						.column(1)
						.data()
						.reduce( function (a, b) {
							return intVal(a) + intVal(b);
						},0 );
					// 在科人数
					var col2 = api.rows().data();
					var total2 =0;
					col2.each( function (d) {
						total2 = total2+ intVal(d.AISItem2);
					});
  					var total3 = api
						.column(3)
						.data()
						.reduce( function (a, b) {
							return intVal(a) + intVal(b);
						},0 );
					var total4 = api
						.column(4)
						.data()
						.reduce( function (a, b) {
							return intVal(a) + intVal(b);
						},0 );	
					var total5 = api
						.column(5)
						.data()
						.reduce( function (a, b) {
							return intVal(a) + intVal(b);
						},0 );
					var total6 = api
						.column(6)
						.data()
						.reduce( function (a, b) {
							return intVal(a) + intVal(b);
						},0 );
					var total7 = api
						.column(7)
						.data()
						.reduce( function (a, b) {
							return intVal(a) + intVal(b);
						},0 );
					var total8 = api
						.column(8)
						.data()
						.reduce( function (a, b) {
							return intVal(a) + intVal(b);
						},0 );
					var total9 = api
						.column(9)
						.data()
						.reduce( function (a, b) {
							return intVal(a) + intVal(b);
						},0 );
					var total10 = api
						.column(10)
						.data()
						.reduce( function (a, b) {
							return intVal(a) + intVal(b);
						},0 );
					var total11 = api
						.column(11)
						.data()
						.reduce( function (a, b) {
							return intVal(a) + intVal(b);
						},0 );
					var total12 = api
						.column(12)
						.data()
						.reduce( function (a, b) {
							return intVal(a) + intVal(b);
						},0 );
					var total13 = api
						.column(13)
						.data()
						.reduce( function (a, b) {
							return intVal(a) + intVal(b);
						},0 );	
					var total14 = api
						.column(14)
						.data()
						.reduce( function (a, b) {
							return intVal(a) + intVal(b);
						},0 );
					var total15 = api
						.column(15)
						.data()
						.reduce( function (a, b) {
							return intVal(a) + intVal(b);
						},0 );
					var total16 = api
						.column(16)
						.data()
						.reduce( function (a, b) {
							return intVal(a) + intVal(b);
						},0 );	
				
					// Update footer
					$(api.column(1).footer()).html(total1);  
					$(api.column(2).footer()).html(total2);
					$(api.column(3).footer()).html(total3);  
					$(api.column(4).footer()).html(total4);  
					$(api.column(5).footer()).html(total5);
					$(api.column(6).footer()).html(total6);  
					$(api.column(7).footer()).html(total7);  
					$(api.column(8).footer()).html(total8);  
					$(api.column(9).footer()).html(total9); 
					$(api.column(10).footer()).html(total10);  
					$(api.column(11).footer()).html(total11);  
					$(api.column(12).footer()).html(total12);  
					$(api.column(13).footer()).html(total13);
					$(api.column(14).footer()).html(total14);  
					$(api.column(15).footer()).html(total15);  
					$(api.column(16).footer()).html(total16);
					
				}
			});
		
			//增加NICU表格导出打印
			new $.fn.dataTable.Buttons( obj.gridLogsNA, {
				buttons: [
					{
						extend: 'excel',
						text:'导出',
						title:"NICU日志"
						,footer: true
						,exportOptions: {
							columns: ':visible'
							,width:50
							,orthogonal: 'export'
						},
						customize: function( xlsx ) {
							var sheet = xlsx.xl.worksheets['sheet1.xml'];
						}
					},
					{
						extend: 'print',
						text:'打印'
						,title:""
						,footer: true
						,exportOptions: { orthogonal: 'export' }				
					}
				]
			});
		}
		else
		{
			//存在情况下
			obj.gridLogsNA.ajax.reload(function(){});
		}
		//myLoadHiden();
	}
	//刷新ICU患者列表
	function refreshGridLocPatients()
	{
		//var rd = obj.layerRep_rd;
		//查询数据
		if(obj.gridLocPatients==undefined)
		{
			obj.gridLocPatients = $("#gridLocPatients").on('processing.dt', function ( e, settings, processing ) {
				//$('#processingIndicator').css( 'display', processing ? 'block' : 'none' );
				if(!processing)
				{
					$("#gridLocPatients").dataTable().fnAdjustColumnSizing();
					myLoadHiden();
				}
			}).DataTable({
				dom: 'rt<"row"<"col-sm-6 col-xs-6"pl><"col-sm-6 col-xs-6"i>>',
				select: 'single',
				paging: true,
				ordering: true,
				info: true,
				ajax: {
					"url": "dhchai.query.datatables.csp",
					"data": function (d) {
						d.ClassName = "DHCHAI.IRS.ICULogSrv";
						d.QueryName = "QryICUAdmStr";
						d.Arg1=obj.layerSel.SurveryDate;
						d.Arg2=obj.layerSel.LocID;
						d.ArgCnt = 2;
					}
				},
				
				columns: [
					{"data": null},
					{"data": "PapmiNo"},
					{"data": "PatientName"},
					{"data": "Sex"},
					{"data": "Age"},
					{"data": "PAAdmBed"},
					{"data": null,
						render: function ( data, type, row ) {
						return '<a href="#" class="zy">摘要</a>';
						}
					},
					{"data": "PAAdmDate"},
					{"data": "PADischDate"},
					{
						"data": null,
						 render: function ( data, type, row ) {
							 var rst = "";
							 if(data.IsPICC=="1")
								 rst = '<input type="checkbox" value="'+data.IsPICC+'" checked/>';
							 else
								 rst = '<input type="checkbox" value="'+data.IsPICC+'"/>';
							return rst
						}
					}
					,
					{
						"data": null,
						 render: function ( data, type, row ) {
							var rst = "";
							 if(data.IsVAP=="1")
								 rst = '<input type="checkbox" value="'+data.IsVAP+'" checked/>';
							 else
								 rst = '<input type="checkbox" value="'+data.IsVAP+'"/>';
							
							return rst
						}
					},
					{
						"data": null,
						 render: function ( data, type, row ) {
							var rst = "";
							 if(data.IsUC=="1")
								 rst = '<input type="checkbox" value="'+data.IsUC+'" checked/>';
							 else
								 rst = '<input type="checkbox" value="'+data.IsUC+'"/>';
							return rst
						}
					}
				],
				"createdRow": function ( row, data, index ) {
					if ( data.IsPICCO=="1") {
						$('td', row).eq(9).addClass('success');
					}
					if ( data.IsVAPO=="1") {
						$('td', row).eq(10).addClass('success');
					}
					if ( data.IsUCO=="1") {
						$('td', row).eq(11).addClass('success');
					}
				}
				,"columnDefs": [{
					"searchable": false,	
					"orderable": false,
					"visible": true,
					"type":"date-euro",
					"targets": [0,4,7,8]
				}],
				"order": [[ 1, 'asc' ]]
			});
			obj.gridLocPatients.on('order.dt search.dt',function() {
				obj.gridLocPatients.column(0, {
					"search": 'applied',
					"order": 'applied'
					}).nodes().each(function(cell, i) {
				cell.innerHTML = i + 1;
				});
			}).draw();
			// 摘要点击
			$('#gridLocPatients').on('click','a.zy', function (e) {
				e.preventDefault();
				var tr = $(this).closest('tr');
				var row = obj.gridLocPatients.row(tr);
				var rowData = row.data();
				
				var EpisodeDr = rowData.Paadm;
				var url = '../csp/dhchai.ir.view.main.csp?PaadmID='+EpisodeDr+'&1=1';
				if (parent.layer) {
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
				}else {
					layer.open({
						  type: 2,
						  area: ['99%', '99%'],
						  title:false,
						  closeBtn:0,
						  fixed: false, //不固定
						  maxmin: false,
						  maxmin: false,
						  content: [url,'no']
					});
				}
				
			});
			
			
			//为表格增加选中事件
			obj.gridLocPatients.on('select', function(e, dt, type, indexes) {
				//获得选中行
				obj.layerSelPat=obj.gridLocPatients.rows({selected: true}).data().toArray()[0];
				//alert(obj.layerSelPat.Paadm+"===1");
				//$('#ulOeItem').val(0); //默认检索条件
				$('#ulOeItem li:first-child').click();
			});
			
		} else {
			obj.gridLocPatients.ajax.reload();
		}
	}
		
	//刷新NICU患者列表
	function refreshGridLocNPatients()
	{
		//var rd = obj.layerRep_rd;
		//查询数据
		if(obj.gridLocNPatients==undefined)
		{
			obj.gridLocNPatients = $("#gridLocNPatients").on('processing.dt', function ( e, settings, processing ) {
				//$('#processingIndicator').css( 'display', processing ? 'block' : 'none' );
				
				if(!processing)
				{
					$("#gridLocNPatients").dataTable().fnAdjustColumnSizing();
					myLoadHiden();
				}
			}).DataTable({
				dom: 'rt<"row"<"col-sm-6 col-xs-6"pl><"col-sm-6 col-xs-6"i>>',
				select: 'single',
				paging: true,
				ordering: true,
				info: true,
				ajax: {
					"url": "dhchai.query.datatables.csp",
					"data": function (d) {
						d.ClassName = "DHCHAI.IRS.ICULogSrv";
						d.QueryName = "QryICUAdmStr";
						d.Arg1=obj.layerSel.SurveryDate;
						d.Arg2=obj.layerSel.LocID;
						d.ArgCnt = 2;
					}
				},
				columns: [
					{"data": null},
					{"data": "PapmiNo"},
					{"data": "PatientName"},
					{"data": "Sex"},
					{"data": "Age"},
					{"data": "PAAdmBed"},
					{"data": null,
						render: function ( data, type, row ) {
						return '<a href="#" class="zy">摘要</a>';
						}
					},
					{"data": "PAAdmDate"},
					{"data": "PADischDate"},
					{"data": "PatWeight"},
					{
						"data": null,
						 render: function ( data, type, row ) {
							 var rst = "";
							 if(data.IsPICC=="1")
								 rst = '<input type="checkbox" value="'+data.IsPICC+'" checked/>';
							 else
								 rst = '<input type="checkbox" value="'+data.IsPICC+'"/>';
							return rst
						}
					},
					{
						"data": null,
						 render: function ( data, type, row ) {
							var rst = "";
							 if(data.IsVAP=="1")
								 rst = '<input type="checkbox" value="'+data.IsVAP+'" checked/>';
							 else
								 rst = '<input type="checkbox" value="'+data.IsVAP+'"/>';
							
							return rst
						}
					},
					{
						"data": null,
						 render: function ( data, type, row ) {
							 var rst = '<a href="#" class="editor_edit">补体重&nbsp;&nbsp;</a>';
							 
							return rst
						}
					}
				],
				"createdRow": function ( row, data, index ) {
					if ( data.IsPICCO=="1") {
						$('td', row).eq(10).addClass('success');
					}
					if ( data.IsVAPO=="1") {
						$('td', row).eq(11).addClass('success');
					}
				}
				,"columnDefs": [{
					"searchable": false,
					"orderable": false,
					"visible": true,
					"targets": 0
				}],
				"order": [[ 1, 'asc' ]]
			});
			obj.gridLocNPatients.on('order.dt search.dt',function() {
				obj.gridLocNPatients.column(0, {
					"search": 'applied',
					"order": 'applied'
					}).nodes().each(function(cell, i) {
				cell.innerHTML = i + 1;
				});
			}).draw();
			// 摘要点击
			$('#gridLocNPatients').on('click','a.zy', function (e) {
				e.preventDefault();
				var tr = $(this).closest('tr');
				var row = obj.gridLocNPatients.row(tr);
				var rowData = row.data();
				
				var EpisodeDr = rowData.EpisodeDr;
				var url = '../csp/dhchai.ir.view.main.csp?PaadmID='+EpisodeDr+'&1=1';
				if (parent.layer) {
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
				}else {
					layer.open({
					  type: 2,
					  area: ['95%', '95%'],
					  title:false,
					  closeBtn:0,
					  fixed: false, //不固定
					  maxmin: false,
					  maxmin: false,
					  content: [url,'no']
					});
				}
			});
			
			obj.gridLocNPatients.on('select', function(e, dt, type, indexes) {
				//获得选中行
				obj.layerSelPat=obj.gridLocNPatients.rows({selected: true}).data().toArray()[0];
				//alert(obj.layerSelPat.Paadm+"===1");
				//$('#ulOeItemN').val(0); //默认检索条件
				$('#ulOeItemN li:first-child').click();
			});
			
			//编辑体重
			$('#gridLocNPatients').on('click', 'a.editor_edit', function (e) {
				e.preventDefault();			
				var tr = $(this).closest('tr');
				var row = obj.gridLocNPatients.row(tr);
				var rowData = row.data();
				//prompt层
				layer.prompt({title: '输入患者体重，并确认',btnAlign: 'c'}, function(PatWeight, index){
					//校验数据格式是否有效
					var reg = new RegExp("^[0-9]*$");  //浮点数 ^(-?\d+)(\.\d+)?$ 两位小数的正实数：^[0-9]+(.[0-9]{2})?$ 
					if(!reg.test(PatWeight)){
						layer.msg("请输入数字",{time: 2000,icon: 1});
						return;
					}	
					var intPatWeight =  parseInt(PatWeight);
					if(intPatWeight<1)
					{
						layer.msg("体重必须大于0",{time: 2000,icon: 1});
						return;
					}
					if(intPatWeight>=999000)
					{
						layer.msg("体重必须小于999kg",{time: 2000,icon: 1});
						return;
					}
					//后台保存				
					var retval = $.Tool.RunServerMethod("DHCHAI.DPS.PAAdmSrv","UpdateWeight",rowData.Paadm,PatWeight);
					
					if(retval=="1")
					{
						//更新表格
						rowData.PatWeight =PatWeight;
						obj.gridLocNPatients
							.row( tr )
							.data( rowData )
							.draw();
						layer.close(index);
					}
					else
					{
						layer.msg("保存体重失败！");					
					}
					
				});
				
			});
		} else {
			obj.gridLocNPatients.ajax.reload();
		}
	}
	//刷新NICU患者列表
	function refreshGridLocNAPatients()
	{
		//var rd = obj.layerRep_rd;
		//查询数据
		if(obj.gridLocNAPatients==undefined)
		{
			obj.gridLocNAPatients = $("#gridLocNAPatients").on('processing.dt', function ( e, settings, processing ) {
				//$('#processingIndicator').css( 'display', processing ? 'block' : 'none' );
				
				if(!processing)
				{
					$("#gridLocNAPatients").dataTable().fnAdjustColumnSizing();
					myLoadHiden();
				}
			}).DataTable({
				dom: 'rt<"row"<"col-sm-6 col-xs-6"pl><"col-sm-6 col-xs-6"i>>',
				select: 'single',
				paging: true,
				ordering: true,
				info: true,
				ajax: {
					"url": "dhchai.query.datatables.csp",
					"data": function (d) {
						d.ClassName = "DHCHAI.IRS.ICULogSrv";
						d.QueryName = "QryICUAdmStr";
						d.Arg1=obj.layerSel.SurveryDate;
						d.Arg2=obj.layerSel.LocID;
						d.ArgCnt = 2;
					}
				},
				columns: [
					{"data": null},
					{"data": "PapmiNo"},
					{"data": "PatientName"},
					{"data": "Sex"},
					{"data": "Age"},
					{"data": "PAAdmBed"},
					{"data": null,
						render: function ( data, type, row ) {
						return '<a href="#" class="zy">摘要</a>';
						}
					},
					{"data": "PAAdmDate"},
					{"data": "PADischDate"},
					{"data": "PatApgar"},
					{
						"data": null,
						 render: function ( data, type, row ) {
							 var rst = "";
							 if(data.IsPICC=="1")
								 rst = '<input type="checkbox" value="'+data.IsPICC+'" checked/>';
							 else
								 rst = '<input type="checkbox" value="'+data.IsPICC+'"/>';
							return rst
						}
					},
					{
						"data": null,
						 render: function ( data, type, row ) {
							var rst = "";
							 if(data.IsVAP=="1")
								 rst = '<input type="checkbox" value="'+data.IsVAP+'" checked/>';
							 else
								 rst = '<input type="checkbox" value="'+data.IsVAP+'"/>';
							
							return rst
						}
					},
					{
						"data": null,
						 render: function ( data, type, row ) {
							 var rst = '<a href="#" class="editor_edit">补Apgar评分&nbsp;&nbsp;</a>';
							 
							return rst
						}
					}
				],
				"createdRow": function ( row, data, index ) {
					if ( data.IsPICCO=="1") {
						$('td', row).eq(10).addClass('success');
					}
					if ( data.IsVAPO=="1") {
						$('td', row).eq(11).addClass('success');
					}
				}
				,"columnDefs": [{
					"searchable": false,
					"orderable": false,
					"visible": true,
					"targets": 0
				}],
				"order": [[ 1, 'asc' ]]
			});
			obj.gridLocNAPatients.on('order.dt search.dt',function() {
				obj.gridLocNAPatients.column(0, {
					"search": 'applied',
					"order": 'applied'
					}).nodes().each(function(cell, i) {
				cell.innerHTML = i + 1;
				});
			}).draw();
			// 摘要点击
			$('#gridLocNAPatients').on('click','a.zy', function (e) {
				e.preventDefault();
				var tr = $(this).closest('tr');
				var row = obj.gridLocNAPatients.row(tr);
				var rowData = row.data();
				
				var EpisodeDr = rowData.EpisodeDr;
				var url = '../csp/dhchai.ir.view.main.csp?PaadmID='+EpisodeDr+'&1=1';
				if (parent.layer) {
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
				}else {
					layer.open({
					  type: 2,
					  area: ['95%', '95%'],
					  title:false,
					  closeBtn:0,
					  fixed: false, //不固定
					  maxmin: false,
					  maxmin: false,
					  content: [url,'no']
					});
				}
			});
			
			obj.gridLocNAPatients.on('select', function(e, dt, type, indexes) {
				//获得选中行
				obj.layerSelPat=obj.gridLocNAPatients.rows({selected: true}).data().toArray()[0];
				//alert(obj.layerSelPat.Paadm+"===1");
				//$('#ulOeItemN').val(0); //默认检索条件
				$('#ulOeItemN li:first-child').click();
			});
			
	
			$('#gridLocNAPatients').on('click', 'a.editor_edit', function (e) {
				e.preventDefault();			
				var tr = $(this).closest('tr');
				var row = obj.gridLocNAPatients.row(tr);
				var rowData = row.data();
				//prompt层
				layer.prompt({title: '输入患者apgar，并确认',btnAlign: 'c'}, function(Apgar, index){
					//校验数据格式是否有效
					var reg = new RegExp("^[0-9]*$");  //浮点数 ^(-?\d+)(\.\d+)?$ 两位小数的正实数：^[0-9]+(.[0-9]{2})?$ 
					if(!reg.test(Apgar)){
						layer.msg("请输入数字",{time: 2000,icon: 1});
						return;
					}	
					var intApgar =  parseInt(Apgar);
					if((intApgar<0)||(intApgar>10))
					{
						layer.msg("Apgar评分一般在0-10之间",{time: 2000,icon: 1});
						return;
					}
					
					//后台保存				
					var retval = $.Tool.RunServerMethod("DHCHAI.DPS.PAAdmSrv","UpdateApgar",rowData.Paadm,intApgar);
					
					if(retval=="1")
					{
						//更新表格
						rowData.PatApgar =intApgar;
						obj.gridLocNAPatients
							.row( tr )
							.data( rowData )
							.draw();
						layer.close(index);
					}
					else
					{
						layer.msg("保存Apgar评分失败！");					
					}
					
				});
				
			});
		} else {
			obj.gridLocNAPatients.ajax.reload();
		}
	}
	function myLoading() {
		if ($(".Loading_animate_content").length != 0) {
			if ($(".Loading_animate_bg").length == 0) {
				var html = '<div class="Loading_animate_bg">'
				    +'<div class="loading">'
					+	'<img src="../scripts/dhchai/img/loading.gif"/>'
				    +'</div>'
				    +'</div>'
					+ '<div class="Loading_animate_font">加载中...</div>';
				$(".Loading_animate_content").append(html);
			}
		}
	}
	function myLoadingBug() {
		$('.Loading_animate_bg').css({ height: $(document).height() });
		$('.Loading_animate_font').css({ left: ($(document).width() - 36) / 2 });
	
	}
	function myLoadHiden()
	{
		if ($(".Loading_animate_content").length != 0) {
			$(".Loading_animate_content").removeAttr("style");   //加这一句主要是为了，去掉在modal上面显示的“加载中”这层的z-index等属性
			$(".Loading_animate_content").css("display", "none");
			$(".Loading_animate_font").text("加载中...");
		}
	}
}