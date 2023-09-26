function InitINFOPSSurvWinEvent(obj){
	var CheckFlg = 0;  
	if(EpisodeID!="")
	{
		$("#divLeft").hide();
		//$("#divLeft").css("visibility","hidden");
	}
	CheckSpecificKey();
	layer.config({  
		extend: 'layerskin/style.css' 
	});
	if (tDHCMedMenuOper['Admin']==1) {
		CheckFlg = 1; //审核权限
	}
	$("#cboHospital").change(function(){
		//加载科室
		obj.initLoc();
	});
	/*
	$("#cboHospital").change(function(){
		$("#ulOperLoc").val("");
		var IsActive = 0;
		var runQuery = $.Tool.RunQuery('DHCHAI.IRS.CRuleOperSrv','QryOperLocList',$.form.GetValue("cboHospital"));  //$.LOGON.HOSPID
		if (runQuery){
			$("#ulOperLoc").empty();
			var arrOL = runQuery.record;
			//全院
			//增加管理员权限才可以查询全院的
			if (tDHCMedMenuOper['Admin']==1) {
				if (arrOL.length>0) {
					$("#ulOperLoc").append('<li value="0">' + '全  院' + '</li>');
				}
			}
			for (var indOL = 0; indOL < arrOL.length; indOL++){
				var rd = arrOL[indOL];
				if (!rd) continue;
				//增加管理员权限才可以查询全院的
				if (tDHCMedMenuOper['Admin']!=1) {
					if(rd["ID"]!=$.LOGON.LOCID)continue;
					$("#ulOperLoc").val($.LOGON.LOCID);
				}
				if (!IsActive){
					IsActive = 1;
					$("#ulOperLoc").val(rd["ID"]);
					$("#ulOperLoc").append('<li class="active" value="' + rd["ID"] + '">' + rd["LocDesc"] + '</li>');
				} else {
					$("#ulOperLoc").append('<li value="' + rd["ID"] + '">' + rd["LocDesc"] + '</li>');
				}
			}
		}
		if ($('#ulOperLoc').val()==""){$('#ulOperLoc').val($.LOGON.LOCID);}
		$('#ulOperLoc > li').click(function (e) {
			e.preventDefault();
			$('#ulOperLoc > li').removeClass('active');
			$(this).addClass('active');
			$('#ulOperLoc').val($(this).val());
			obj.gridINFOPSSurv.clear().draw();
			obj.gridINFOPSSurv.ajax.reload();
		});
		obj.gridINFOPSSurv.clear().draw();
		obj.gridINFOPSSurv.ajax.reload();		
	});
	$('#ulOeItemN li:first-child').click();
	
	$("#DateFrom").change(function(){
		obj.gridINFOPSSurv.clear().draw();
		obj.gridINFOPSSurv.ajax.reload();
	});
	$("#DateTo").change(function(){
		obj.gridINFOPSSurv.clear().draw();
		obj.gridINFOPSSurv.ajax.reload();
	});
	$("#cboCuteType").change(function(){
		obj.gridINFOPSSurv.clear().draw();
		obj.gridINFOPSSurv.ajax.reload();
	});
	*/
	var LayIndex = 0;       //获取抗菌用药编辑页面的index
	$("#btnQuery").click(function() {
		checkDateBox();
		obj.gridINFOPSSurv.clear().draw();
		obj.gridINFOPSSurv.ajax.reload();
	});
	
	//检查日期框格式
	function checkDateBox() {
		var DateFrom 	= $("#DateFrom").val();
		var DateTo 		= $("#DateTo").val();
		if(DateFrom > DateTo){
			layer.msg('开始日期应小于或等于结束日期！');
			return;
		}
		if ((DateFrom=="")||(DateTo=="")){
			layer.msg('请选择开始日期、结束日期！');
			return;
		}
	}

	/*****搜索功能*****/
	$("#btnsearch").on('click', function(){
	   $('#gridINFOPSSurv').DataTable().search($('#search').val(),true,true).draw();
	   
	});

	$("#search").keyup(function(event){
	    if (event.keyCode == 13) {
	        obj.gridINFOPSSurv.search(this.value).draw();
	    }
	});
	/****************/
	
     //导出
    $("#btnExport").on('click', function(){
		obj.gridINFOPSSurv.buttons(0,null)[1].node.click();
	});
    /*
 	//打印
    $("#btnPrint").on('click', function(){
	    obj.gridINFOPSSurv.buttons(0,null)[2].node.click();
		
	});
	*/
	new $.fn.dataTable.Buttons(obj.gridINFOPSSurv, {
		buttons: [
			{
				extend: 'csv',
				text:'导出'
			},
			{
				extend: 'excel',
				text:'导出',
				title:"手术切口调查列表"
				,footer: true
				,exportOptions: {
					columns: ':visible'
					,width:50
					,orthogonal: 'export'
				},
				customize: function( xlsx ) {
					var sheet = xlsx.xl.worksheets['sheet.xml'];
					
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
	
	// 手术切口调查报告
    $('#gridINFOPSSurv').on('click','a.btnReprot', function (e) {
	    $.form.CheckBoxRender();
	    $.form.iCheckRender();
	  	$.form.SelectRender("cboOperType");
	  	$.form.SelectRender("cboIncision");
	  	$.form.SelectRender("cboHealing");
	  	$.form.SelectRender("cboAnesMethod");
	  	$.form.SelectRender("cboASAScore");
	  	$.form.SelectRender("cboInfPos");
	  	$.form.SelectRender("cboNNISLevel");
		$("#cboInfPos").attr("disabled","disabled");
	    $('#chkIsOperInf + .iCheck-helper').click(function(){
		    $.form.SetValue("cboInfPos","","");
			if ($("#chkIsOperInf").parent().hasClass("checked")){
				$("#cboInfPos").removeAttr("disabled");
			}else {
				$("#cboInfPos").attr("disabled","disabled");
			}
		});
		
		var tr = $(this).closest('tr');
		var row = obj.gridINFOPSSurv.row(tr);
		var rd = row.data();
		obj.layer_rd = rd;
		obj.EpisodeID = rd["EpisodeDr"];
		obj.ReportID  = rd["ReportID"];     // 感染报告id
		var RepStatus = rd["RepStatus"];
		
		// 刷新抗菌用药列表
		obj.refreshgridINFAnti();
		
		$.form.SetValue("txtRegNo",rd["PapmiNo"]);
		$.form.SetValue("txtName",rd["PatName"]);
		$.form.SetValue("txtSex",rd["Sex"]);
		$.form.SetValue("txtAge",rd["Age"]);
		$.form.SetValue("txtAdmDate",rd["AdmDate"]);
		$.form.SetValue("txtDischDate",rd["DischDate"]);
		$.form.SetValue("txtMrNo",rd["MrNo"]);
        $.form.SetValue("txtBed",rd["AdmBed"]);
		$.form.SetValue("txtDiagnose",rd["MRDiagnos"]);
		
        var INFOPSID = rd["INFOPSID"];
        if (INFOPSID!="") {
	    	objInfo = $.Tool.RunServerMethod("DHCHAI.IRS.INFOPSSrv","GetReportString",INFOPSID);
	    	$.form.SetValue("txtOperDesc",objInfo.split("^")[3]);
	    	$.form.SetValue("txtOpertorName",objInfo.split("^")[6]);
	        $.form.DateTimeRender1('txtSttDateTime',objInfo.split("^")[4]);
            $.form.DateTimeRender1("txtEndDateTime",objInfo.split("^")[5]);
			$('#cboOperType').val(objInfo.split("^")[7].split(",")[0]).select2();
			$('#cboAnesMethod').val(objInfo.split("^")[8].split(",")[0]).select2();
			$('#cboIncision').val(objInfo.split("^")[10].split(",")[0]).select2();
			$('#cboHealing').val(objInfo.split("^")[11].split(",")[0]).select2();
			$('#cboASAScore').val(objInfo.split("^")[12].split(",")[0]).select2();
			$('#cboNNISLevel').val(objInfo.split("^")[9].split(",")[0]).select2();
			$.form.SetValue("txtORWBC",objInfo.split("^")[16]);
			$.form.SetValue("txtInciNum",objInfo.split("^")[17]);
			$.form.SetValue("txtBloodLoss",objInfo.split("^")[21]);
			$.form.SetValue("txtBloodTrans",objInfo.split("^")[22]);
			$.form.SetValue("chkAntiFlag",objInfo.split("^")[20]==1);
			$.form.SetValue("chkSightGlass",objInfo.split("^")[18]==1);
			$.form.SetValue("chkImplants",objInfo.split("^")[19]==1);
			$.form.SetValue("chkInHospInf",objInfo.split("^")[15]==1);
			$.form.SetValue("chkIsOperInf",objInfo.split("^")[14]==1);
			$('#cboInfPos').val(objInfo.split("^")[13].split(",")[0]).select2();
			var OperCompList = objInfo.split("^")[23];
	        for (var indx=0;indx<OperCompList.split(",").length-1;indx++) { 
	        	var OperComp = OperCompList.split(",")[indx];
	            $("#"+OperComp).iCheck('check');
	        }
	        if (objInfo.split("^")[14]==1){
				$("#cboInfPos").removeAttr("disabled");
			}
	    }else {
	        $.form.SetValue("txtOperDesc",rd["OperDesc"]);
	        $.form.SetValue("txtOpertorName",rd["OpertorName"]);
	        $.form.DateTimeRender1('txtSttDateTime',rd["OperDate"]+" "+rd["SttTime"]);
            $.form.DateTimeRender1("txtEndDateTime",rd["EndDate"]+" "+rd["EndTime"]);
			$('#cboOperType').val(rd["MapTypeDicDR"]).select2();
			$('#cboAnesMethod').val(rd["MapAnesDicDR"]).select2();
			$('#cboIncision').val(rd["MapIncDicDR"]).select2();
			$('#cboHealing').val(rd["MapHealDicDR"]).select2();
			$('#cboASAScore').val(rd["MapASADicDR"]).select2();
			$('#cboNNISLevel').val(rd["MapNNISDicDR"]).select2();
			$.form.SetValue("txtORWBC",rd["WBC"]);
			$.form.SetValue("txtInciNum",rd["IncisionNum"]);
			$.form.SetValue("txtBloodLoss",rd["LoseBlood"]);
			$.form.SetValue("txtBloodTrans",rd["GotBlood"]);
			$.form.SetValue("chkAntiFlag","");  // 术前口服抗生素
			$.form.SetValue("chkSightGlass",rd["IsSightGlass"]== 1);
			$.form.SetValue("chkImplants",rd["IsImplants"]== 1);
			$.form.SetValue("chkInHospInf",rd["IsOperInf"]== 1);   // 是否院感
			$.form.SetValue("chkIsOperInf",rd["IsInHospInf"]== 1); // 是否切口感染
			if (rd["IsOperInf"]== 1){
				$("#cboInfPos").removeAttr("disabled");
			}
			$.form.SetValue("cboInfPos",rd["InfTypeID"],rd["InfTypeDesc"]);    // 感染部位
			var OperCompList = "";              // 并发症
	        for (var indx=0;indx<OperCompList.split(",").length-1;indx++) { 
	        	var OperComp = OperCompList.split(",")[indx];
	            $("#"+OperComp).iCheck('check');
	        }
	    }
	    
	    layer.open({
			type: 1,
			zIndex: 100,
			skin: 'btn-all-blue',
			area: ['90%','99%'],
			title: '手术切口调查表', 
			//maxmin: true, 
			content: $('#layer_one'),
			btn: ['保存','提交','审核','删除'],		//作废-->删除
			btnAlign: 'c',
			yes: function(index, layero){ // 保存
		 		var ret = obj.Layer_Save("1");
				
				if(parseInt(ret)>0)
				{
					
					obj.gridINFOPSSurv.ajax.reload(function(){
						var rowIndex = $.Tool.GetTableRowIndex(obj.gridINFOPSSurv,"INFOPSID",ret);
						if (rowIndex > -1){
							var rd =obj.gridINFOPSSurv.row(rowIndex).data();
							obj.layer_rd = rd;
						} else {
							obj.layer_rd = '';
						}
						layer.msg('保存成功!',{time: 2000,icon: 1});
					},false);
					
					
					return false;
				}
				else
				{
					layer.msg('保存失败!',{icon: 2});
					return false;
				}
			},
			btn2: function(index, layero){ // 提交
				var ret = obj.Layer_Save("2");
				if(parseInt(ret)>0)
				{
					obj.gridINFOPSSurv.ajax.reload(function(){
						layer.msg('提交成功!',{time: 2000,icon: 1});
					},false);		
					obj.doClose();
				}
				else
				{
					layer.msg('提交失败!',{icon: 2});
					return false;
				}				  	
			},
			btn3: function(index, layero){ // 审核
				var ret = obj.Layer_Save("3");
				if(parseInt(ret)>0)
				{
					obj.gridINFOPSSurv.ajax.reload(function(){
						layer.msg('审核成功!',{time: 2000,icon: 1});
					},false);
					return true;						
				}
				else
				{
					layer.msg('审核失败!',{icon: 2});
					return false;
				}	
			},
			btn4: function(index, layero){ // 作废
				var ret = obj.Layer_Save("4");
			  	if(parseInt(ret)>0)
				{
				var flg = $.Tool.RunServerMethod("DHCHAI.IR.INFOPS","DeleteById",INFOPSID);
				if (flg >= 0) {
				obj.gridINFOPSSurv.ajax.reload(function(){
						layer.msg('删除成功!',{time: 2000,icon: 1});
					},false);
					return true;
			}							
				}
				else
				{
					layer.msg('删除失败!',{icon: 2});
					return false;
				}	
			},
			success: function(layero){
		
				var button0 = layero.find(".layui-layer-btn0"); //保存
				var button1 = layero.find(".layui-layer-btn1"); //提交
				var button2 = layero.find(".layui-layer-btn2"); //审核
				var button3 = layero.find(".layui-layer-btn3"); //作废
				if (!RepStatus) {
					$(button2).hide();
					$(button3).hide();
				}else if (RepStatus =='保存') {
					$(button2).hide();
				}else if (RepStatus =='提交') {
					$(button0).hide();
					if (CheckFlg !='1') {
						$(button2).hide();
					}
				}else if (RepStatus =='审核') {
					$(button0).hide();
					$(button1).hide();
					$(button2).hide();
					if (CheckFlg !='1') {
						$(button3).hide();
					}
				}else if (RepStatus =='作废') {
					$(button2).hide();
					$(button3).hide();
				}
			},
			cancel: function(index){ 
				obj.doClose();
			}
		});
    });
    obj.Layer_Save =function(Status) {
	    var rd = obj.layer_rd;
	    var ReportID         = rd["ReportID"];          // 报告ID
	    var INFOPSID         = rd["INFOPSID"];          // 手术切口调查表ID
		var EpisodeDR        = rd["EpisodeDr"];         // 就诊记录
		var IRRepType        = "4";                     // 手术切口调查表类型
		var IRRepDate        = rd["RepDate"];           // 报告日期
		var IRRepTime        = rd["RepTime"];           // 报告时间
		var IRRepLocDr       = $.LOGON.LOCID;           // 报告科室？手术科室(rd["OperLocID"])
		var IRRepUser        = $.LOGON.USERID;          // 报告人
		var IRStatusDr       = Status;                  // 报告状态 非ID
		var IRLinkDiags      = "";                      // 感染诊断
		var IRLinkICDs       = "";                      // 疾病诊断
		var IRLinkLabs       = "";                      // 病原学送检
		var IRLinkAntis      = "";                      // 抗菌用药
		var IRLinkOPSs       = INFOPSID;                // 手术信息
		var IRLinkMRBs       = "";                      // 多耐信息
		var IRLinkInvOpers   = "";                      // 侵害性操作
		var IRLinkICUUCs     = "";                      // ICU导尿管
		var IRLinkICUVAPs    = "";                      // ICU呼吸机
		var IRLinkICUPICCs   = "";                      // ICU中心静脉
		var IRDiagnosisBasis = "";                      // 诊断依据
		var IRDiseaseCourse  = "";                      // 感染性疾病病程
		var IRInLocDr        = "";                      // 入科来源
		var IROutLocDr       = "";                      // 出科去向
		var IRInDate         = "";                      // 入科时间
		var IROutDate        = "";                      // 出科时间 
		var IRAPACHEScore    = "";                      // APACHEⅡ评分
		var IROutIntubats    = "";                      // 转出ICU带管情况
		var IROut48Intubats  = "";                      // 转出ICU48带管情况
		
	    var AnaesID       = rd["ID"];                           // 手术记录ID
	    var OperLocDR     = rd["OperLocID"];                    // 手术科室
	    var OperDxDr      = rd["OperDxDr"];                     // 标准手术ID
	    var OperDesc      = $.form.GetValue("txtOperDesc");     // 手术名称
		var SttDateTime   = $.form.GetValue("txtSttDateTime");  // 开始日期时间
			SttDateTime   = SttDateTime.replace(" ","")
	    var StartDate     = SttDateTime.substring(0,10);        // 开始日期
	    var StartTime     = SttDateTime.substring(10,15);       // 开始时间
	    var EndDateTime   = $.form.GetValue("txtEndDateTime");  // 结束日期时间
			EndDateTime   = EndDateTime.replace(" ","")
	    var EndDate       = EndDateTime.substring(0,10);        // 结束日期
	    var EndTime       = EndDateTime.substring(10,15);       // 结束时间
	    var OpertorName   = $.form.GetValue("txtOpertorName");  // 手术医生
	    var OperTypeDR    = $.form.GetValue("cboOperType");     // 手术类型
	    var AnesMethodDR  = $.form.GetValue("cboAnesMethod");   // 麻醉方式
	    var IncisionDR    = $.form.GetValue("cboIncision");     // 切口等级
	    var HealingDR     = $.form.GetValue("cboHealing");      // 愈合情况
	    var NNISLevelDR   = $.form.GetValue("cboNNISLevel");    // NNIS分级
	    var ASAScoreDR    = $.form.GetValue("cboASAScore");     // ASA评分
	    var InfPosDR      = $.form.GetValue("cboInfPos");       // 感染部位
	    var ORWBC         = $.form.GetValue("txtORWBC");        // 术前外周WBC
	    var InciNum       = $.form.GetValue("txtInciNum");      // 切口个数
	    var BloodLoss     = $.form.GetValue("txtBloodLoss");    // 失血量
	    var BloodTrans    = $.form.GetValue("txtBloodTrans");   // 输血量
	    var AntiFlag      = $.form.GetValue("chkAntiFlag");     // 术前口服抗生素
	    var SightGlass    = $.form.GetValue("chkSightGlass");   // 是否使用窥镜
	    var Implants      = $.form.GetValue("chkImplants");     // 植入物
	    var InHospInf     = $.form.GetValue("chkInHospInf");    // 是否引起院感
	    var IsOperInf     = $.form.GetValue("chkIsOperInf");    // 切口感染
        var OperCompList="";                                    // 并发症
        $('input:checkbox',$("#chkOperComp")).each(function(){
       		if(true == $(this).is(':checked')){
            	OperCompList+=$(this).attr("id")+",";
       		}
    	});
    	
		// 报告信息
		var InputRepStr = ReportID;     // 报告ID DHCHAI.IR.INFReport	
		InputRepStr += "^" + EpisodeDR;
		InputRepStr += "^" + IRRepType;
		InputRepStr += "^" + IRRepDate;
		InputRepStr += "^" + IRRepTime;
		InputRepStr += "^" + IRRepLocDr;
		InputRepStr += "^" + IRRepUser; 
		InputRepStr += "^" + IRStatusDr;
		InputRepStr += "^" + IRLinkDiags;
		InputRepStr += "^" + IRLinkICDs;
		InputRepStr += "^" + IRLinkLabs;
		InputRepStr += "^" + IRLinkAntis;
		InputRepStr += "^" + IRLinkOPSs;
		InputRepStr += "^" + IRLinkMRBs;
		InputRepStr += "^" + IRLinkInvOpers;
		InputRepStr += "^" + IRLinkICUUCs;
		InputRepStr += "^" + IRLinkICUVAPs;
		InputRepStr += "^" + IRLinkICUPICCs;
		InputRepStr += "^" + IRDiagnosisBasis;
		InputRepStr += "^" + IRDiseaseCourse;
		InputRepStr += "^" + IRInLocDr;
		InputRepStr += "^" + IRInDate;
		InputRepStr += "^" + IROutDate;
		InputRepStr += "^" + IRAPACHEScore;  
		InputRepStr += "^" + IROutIntubats; 
		InputRepStr += "^" + IROut48Intubats; 
		
		// 手术切口调查报告信息
    	var InputOPSStr = INFOPSID;
		InputOPSStr += "^" + EpisodeDR;
		InputOPSStr += "^" + AnaesID;
		InputOPSStr += "^" + OperLocDR;
		InputOPSStr += "^" + OperDesc;
		InputOPSStr += "^" + OperDxDr;
		InputOPSStr += "^" + StartDate;
		InputOPSStr += "^" + EndDate;
		InputOPSStr += "^" + StartTime;
		InputOPSStr += "^" + EndTime;
		InputOPSStr += "^" + "";         // 手术时长
		InputOPSStr += "^" + OpertorName;
		InputOPSStr += "^" + "";         //手术医生DR
		InputOPSStr += "^" + OperTypeDR;
		InputOPSStr += "^" + AnesMethodDR;
		InputOPSStr += "^" + NNISLevelDR;
		InputOPSStr += "^" + IncisionDR;
		InputOPSStr += "^" + HealingDR;
		InputOPSStr += "^" + IsOperInf;
		InputOPSStr += "^" + InfPosDR;
		InputOPSStr += "^" + InHospInf;
		InputOPSStr += "^" + ASAScoreDR;
		InputOPSStr += "^" + ORWBC;
		InputOPSStr += "^" + InciNum;
		InputOPSStr += "^" + SightGlass;
		InputOPSStr += "^" + Implants;
		InputOPSStr += "^" + AntiFlag;
		InputOPSStr += "^" + BloodLoss;
		InputOPSStr += "^" + BloodTrans;
		InputOPSStr += "^" + OperCompList;
	    InputOPSStr += "^" + "";   // 更新日期
	    InputOPSStr += "^" + "";   // 更新时间
	    InputOPSStr += "^" + $.LOGON.USERID;
		
	    // 日志信息
	    var InputLogStr = "";            // DHCHAI.IR.INFReport-->ID
		InputLogStr += "^" + Status;     // 状态
	    InputLogStr += "^" + "";         // 操作意见
	    InputLogStr += "^" + $.LOGON.USERID;
		
	    // 抗菌药物信息
	    var InputAnti=obj.ANT_Save();
	    
	    var InputStr = InputOPSStr+"#"+InputRepStr+"#"+InputLogStr+"#"+InputAnti;
		var retval = $.Tool.RunServerMethod("DHCHAI.IRS.INFOPSSrv","SaveINFOPS",InputStr);
		return retval;
    }
    
    
   //------------抗菌药物信息--------------//
   function refreshgridINFAntiSync(){
		if(obj.gridINFAntiSync==undefined)
		{
			obj.gridINFAntiSync = $("#gridINFAntiSync").DataTable({
				dom: 'rt',
				paging:false,
				select: 'single',
				ordering: false,
				ajax: {
					"url": "dhchai.query.datatables.csp",
					"data": function (d) {
						d.ClassName = "DHCHAI.IRS.INFAntiSrv";
						d.QueryName = "QryINFAntiByRep";
						d.Arg1 = '';
						d.Arg2 = obj.EpisodeID;
						d.ArgCnt = 2;
					}
				},
				columns: [
					{"data": "AntiDesc"}
					,{"data": "SttDate"}
					,{"data": "EndDate"}
					,{"data": "DoseQty"}
					,{"data": "DoseUnit"}
					,{"data": "PhcFreq"}
					,{"data": "AdminRoute"}
					,{"data": "MedPurpose"}
				]
			});
			obj.gridINFAntiSync.on('dblclick', 'tr', function(e) {
				var data  = obj.gridINFAntiSync.row(this).data();
				if (typeof(data)=='undefined') return;
				layer.close(layer.index);
				OpenINFAntiEdit(data,'');
			});
		}else{
			obj.gridINFAntiSync.ajax.reload(function(){});
		}
	}
	refreshgridINFAntiSync();
	// 弹出抗菌药物提取框
	function OpenINFAntiSync(){
		refreshgridINFAntiSync();
		obj.LayerOpenINFAntiSync = layer.open({
				type: 1,
				zIndex: 100,
				maxmin: false,
				title: "抗菌用药-提取[双击数据进行编辑]", 
				area: '75%',
				content: $('#LayerOpenINFAntiSync')
		});	
	}
	// 弹出抗菌药物编辑框
	function OpenINFAntiEdit(d, r) {
		obj.LayerOpenINFAntiEdit = layer.open({
				type: 1,
				zIndex: 100,
				maxmin: false,
				title: "抗菌用药-编辑", 
				area: ['700px',''],
				content: $('#LayerOpenINFAntiEdit'),
				btnAlign: 'c',
				btn: ['保存', '取消'],
				yes: function(index, layero){
				  	// 添加数据
					INFAntiAdd(d,r);
				}
				,success: function(layero){
					InitINFAntiEditData(d,r);
				}
		});	
	}
	function INFAntiAdd(d,r){
	    var ID = '';
		var AntiUseID = '';
		var AntiDesc2 = '';
		if (LayIndex==0)       //获取页面的index
		{
            LayIndex = layer.index;
		}
		if (d){
			ID = d.ID;
			AntiUseID = d.AntiUseID;
			AntiDesc2 = d.AntiDesc2;
		}
		var AntiDesc = $.form.GetText("cboAnti");
		var DoseQty = $.form.GetValue("txtDoseQty");
		var DoseUnitID = $.form.GetValue("cboDoseUnit");
		if (DoseUnitID==''){
			var DoseUnit='';
		}else{
			var DoseUnit = $.form.GetText("cboDoseUnit");
		}
		var PhcFreqID = $.form.GetValue("cboPhcFreq");
		if (PhcFreqID==''){
			var PhcFreq='';
		}else{
			var PhcFreq = $.form.GetText("cboPhcFreq");
		}
		var MedUsePurposeID = $.form.GetValue("cboMedUsePurpose");
		if (MedUsePurposeID==''){
			var MedUsePurpose='';
		}else{
			var MedUsePurpose = $.form.GetText("cboMedUsePurpose");
		}
		var AdminRouteID = $.form.GetValue("cboAdminRoute");
		if (AdminRouteID==''){
			var AdminRoute='';
		}else{
			var AdminRoute = $.form.GetText("cboAdminRoute");
		}
		var MedPurposeID = $.form.GetValue("cboMedPurpose");
		if (MedPurposeID==''){
			var MedPurpose='';
		}else{
			var MedPurpose = $.form.GetText("cboMedPurpose");
		}
		var TreatmentModeID = $.form.GetValue("cboTreatmentMode");
		if (TreatmentModeID==''){
			var TreatmentMode='';
		}else{
			var TreatmentMode = $.form.GetText("cboTreatmentMode");
		}	
		var PreMedEffectID = $.form.GetValue("cboPreMedEffect");
		if (PreMedEffectID==''){
			var PreMedEffect='';
		}else{
			var PreMedEffect = $.form.GetText("cboPreMedEffect");
		}	
		var PreMedIndicatID = $.form.GetValue("cboPreMedIndicat");
		if (PreMedIndicatID==''){
			var PreMedIndicat='';
		}else{
			var PreMedIndicat = $.form.GetText("cboPreMedIndicat");
		}
		var CombinedMedID = $.form.GetValue("cboCombinedMed");
		if (CombinedMedID==''){
			var CombinedMed='';
		}else{
			var CombinedMed = $.form.GetText("cboCombinedMed");
		}
		var SttDate = $.form.GetValue("txtSttDate");
		var EndDate = $.form.GetValue("txtEndDate");
		var PreMedTime = $.form.GetValue("txtPreMedTime");
		var PostMedDays = $.form.GetValue("txtPostMedDays");
		var SenAnaID = $.form.GetValue("cboSenAna");
		if (SenAnaID==''){
			var SenAna='';
		}else{
			var SenAna = $.form.GetText("cboSenAna");
		}
		if (($.form.GetValue("cboAnti")=='')&&(AntiDesc=='--请选择--')){
    		layer.msg('医嘱名不能为空!',{icon: 2});
			return;
    	}
    	if (DoseQty==''){
    		layer.msg('剂量不能为空!',{icon: 2});
			return;
    	}
    	if (DoseUnit==''){
    		layer.msg('剂量单位不能为空!',{icon: 2});
			return;
    	}
    	if (PhcFreq==''){
    		layer.msg('频次不能为空!',{icon: 2});
			return;
    	}
		/*
		if (MedUsePurpose==''){
    		layer.msg('用途不能为空!',{icon: 2});
			return;
    	}
    	*/
    	if (AdminRoute==''){
    		layer.msg('给药途径不能为空!',{icon: 2});
			return;
    	}
    	if (MedPurpose==''){
    		layer.msg('目的不能为空!',{icon: 2});
			return;
    	}
    	if (MedPurpose.indexOf("预防") >= 0) {
    	    if (MedPurpose.indexOf("治疗") >= 0) {
    	        if (TreatmentMode == '') {
    	            layer.msg('目的为治疗+预防时,治疗用药方式不能为空!', { icon: 2 });
    	            return;
    	        }
    	        if (PreMedEffect == '') {
    	            layer.msg('目的为治疗+预防时,预防用药效果不能为空!', { icon: 2 });
    	            return;
    	        }
    	        if (PreMedIndicat == '') {
    	            layer.msg('目的为治疗+预防时,预防用药指征不能为空!', { icon: 2 });
    	            return;
    	        }
    	    }
	    	if (PreMedEffect==''){
	    		layer.msg('目的为预防时,预防用药效果不能为空!',{icon: 2});
				return;
	    	}
	    	if (PreMedIndicat==''){
	    		layer.msg('目的为预防时,预防用药指征不能为空!',{icon: 2});
				return;
	    	}
    	}else {
    	    if (MedPurpose.indexOf("治疗") >= 0) {
    	        if (TreatmentMode == '') {
    	            layer.msg('目的为治疗时,治疗用药方式不能为空!', { icon: 2 });
    	            return;
    	        }
    	    }
	    }
    	if (CombinedMed==''){
    		layer.msg('联合用药不能为空!',{icon: 2});
			return;
    	}
    	if (SttDate==''){
    		layer.msg('开始日期不能为空!',{icon: 2});
			return;
    	}
    	/*
    	if (EndDate==''){
    		layer.msg('结束日期不能为空!',{icon: 2});
			return;
    	}*/
		if(EndDate!=''){
			if (!$.form.CompareDate(EndDate,SttDate)){
				layer.msg('结束日期不能在开始日期之前!',{icon: 2});
				return;
			}
		}
		var row ={
			'ID':ID,
			'EpisodeID':obj.EpisodeID,
			'ReportID':obj.ReportID,
			'AntiUseID':AntiUseID,
			'AntiDesc':AntiDesc,
			'AntiDesc2':AntiDesc2,
			'SttDate':SttDate,
			'EndDate':EndDate,
			'DoseQty':DoseQty,
			'DoseUnitID':DoseUnitID,
			'DoseUnit':DoseUnit,
			'PhcFreqID':PhcFreqID,
			'PhcFreq':PhcFreq,
			'MedUsePurposeID':MedUsePurposeID,
			'MedUsePurpose':MedUsePurpose,
			'AdminRouteID':AdminRouteID,
			'AdminRoute':AdminRoute,
			'MedPurposeID':MedPurposeID,
			'MedPurpose':MedPurpose,
			'TreatmentModeID':TreatmentModeID,
			'TreatmentMode':TreatmentMode,
			'PreMedEffectID':PreMedEffectID,
			'PreMedEffect':PreMedEffect,
			'PreMedIndicatID':PreMedIndicatID,
			'PreMedIndicat':PreMedIndicat,
			'CombinedMedID':CombinedMedID,
			'CombinedMed':CombinedMed,
			'PreMedTime':PreMedTime,
			'PostMedDays':PostMedDays,
			'SenAnaID':SenAnaID,
			'SenAna':SenAna,
			'UpdateDate':'',
			'UpdateTime':'',
			',UpdateUserID':$.LOGON.USERID,
			'UpdateUser':''
		}

		// 数据重复标志
    	var dataRepeatFlg = 0;
    	for (var i=0;i<obj.gridINFAnti.data().length;i++){
    		if (r) {
    			if ($(r).context._DT_RowIndex==i){
    				continue;
    			}
    		}
    		if ((AntiDesc==obj.gridINFAnti.data()[i].AntiDesc)&&(SttDate==obj.gridINFAnti.data()[i].SttDate)){
    			dataRepeatFlg = 1;
    		}
    	}
    	if (dataRepeatFlg == 1) {
    		layer.confirm('存在开始日期、抗生素相同的记录,是否添加抗生素信息？', {
			  btn: ['是','否'] //按钮
			}, function(){
				InsertAnti(r,row);
			});
    	}else{
    		InsertAnti(r,row);
    	};
	}

	function InsertAnti(r,row){
		if (r){  //修改
			var rowIndex = $(r).context._DT_RowIndex; //行号
			obj.gridINFAnti.row(r).data(row).draw();
		}else{	//添加
			obj.gridINFAnti.row.add(row).draw();
		}
	    // 关闭弹框 
		layer.close(LayIndex);
		LayIndex = 0;
	}

	function InitINFAntiEditData(d,r){
		// 渲染控件
		$.form.SelectRender('cboDoseUnit');
		$.form.SelectRender('cboPhcFreq');
		$.form.SelectRender('cboMedUsePurpose');
		$.form.SelectRender('cboAdminRoute');
		$.form.SelectRender('cboMedPurpose');
		$.form.SelectRender('cboTreatmentMode');
		$.form.SelectRender('cboPreMedEffect');
		$.form.SelectRender('cboPreMedIndicat');
		$.form.SelectRender('cboCombinedMed');
		$.form.SelectRender('cboSenAna');
		$.form.SelectRender('cboAnti');
		// 控件赋值
		if (d){
			$.form.DateRender('txtSttDate',d.SttDate,'top-right');
			$.form.DateRender('txtEndDate',d.EndDate,'top-right');
			$.form.SetValue('cboAnti','',d.AntiDesc);
			$.form.SetValue('txtDoseQty',d.DoseQty);
			$.form.SetValue('cboDoseUnit',d.DoseUnitID,d.DoseUnit);
			$.form.SetValue('cboPhcFreq',d.PhcFreqID,d.PhcFreq);
			$.form.SetValue('cboMedUsePurpose',d.MedUsePurposeID,d.MedUsePurpose);
			$.form.SetValue('cboAdminRoute',d.AdminRouteID,d.AdminRoute);
			$.form.SetValue('cboMedPurpose',d.MedPurposeID,d.MedPurpose);
			$.form.SetValue('cboTreatmentMode',d.TreatmentModeID,d.TreatmentMode);
			$.form.SetValue('cboPreMedEffect',d.PreMedEffectID,d.PreMedEffect);
			$.form.SetValue('cboPreMedIndicat',d.PreMedIndicatID,d.PreMedIndicat);
			$.form.SetValue('cboCombinedMed',d.CombinedMedID,d.CombinedMed);
			$.form.SetValue('cboSenAna',d.SenAnaID,d.SenAna);
			$.form.SetValue('txtPreMedTime',d.PreMedTime);
			$.form.SetValue('txtPostMedDays',d.PostMedDays);
		}else{
			$.form.DateRender('txtSttDate','','top-right');
			$.form.DateRender('txtEndDate','','top-right');
			$.form.SetValue('cboAnti','','');
			$.form.SetValue('txtDoseQty','');
			$.form.SetValue('cboDoseUnit','','');
			$.form.SetValue('cboPhcFreq','','');
			$.form.SetValue('cboMedUsePurpose','','');
			$.form.SetValue('cboAdminRoute','','');
			$.form.SetValue('cboMedPurpose','','');
			$.form.SetValue('cboTreatmentMode','','');
			$.form.SetValue('cboPreMedEffect','','');
			$.form.SetValue('cboPreMedIndicat','','');
			$.form.SetValue('cboCombinedMed','','单联');
			$.form.SetValue('cboSenAna','','');
			$.form.SetValue('txtPreMedTime','');
			$.form.SetValue('txtPostMedDays','');
		}
	}
	// 添加抗菌药物事件
	$("#btnINFAntiAdd").click(function(e){
		OpenINFAntiEdit('','');
	});
	// 抗菌药物提取事件
	$('#btnINFAntiSync').click(function(e){
		// TODO同步医嘱
		//$.Tool.RunServerMethod('DHCHAI.DI.DHS.SyncHisInfo','SyncAdmOEOrdItem',HISCode,EpisodeIDx,ServiceDate,ServiceDate);
		OpenINFAntiSync();
	});
	// 删除抗菌药物事件
	$("#btnINFAntiDel").click(function(e){
		var selectedRows = obj.gridINFAnti.rows({selected: true}).count();
		if (selectedRows!== 1 ) {
			layer.msg('请选择一行数据!',{icon: 2});
			return;
		}else{
			var rd = obj.gridINFAnti.rows({selected: true}).data().toArray()[0];
			layer.confirm('是否删除抗菌用药：'+rd.AntiDesc+'？', {
			  btn: ['是','否'] //按钮
			}, function(){
				obj.gridINFAnti.rows({selected:true}).remove().draw(false);
				layer.msg('删除抗菌用药成功！', {icon: 1});
			});
			// obj.gridINFAnti.rows({selected:true}).remove().draw(false);
		}
	});
	// 抗菌药物信息列表双击事件
	obj.gridINFAnti.on('dblclick', 'tr', function(e) {
		var data  = obj.gridINFAnti.row(this).data();
		if (typeof(data)=='undefined') return;
		OpenINFAntiEdit(data,this);
	});

	obj.ANT_Save = function(){
		// 抗菌药物
    	var InputAnti = '';
    	for (var i=0;i<obj.gridINFAnti.data().length;i++){
    		var Input = obj.gridINFAnti.data()[i].ID;
    		Input = Input + CHR_1 + obj.gridINFAnti.data()[i].EpisodeID;
    		Input = Input + CHR_1 + obj.gridINFAnti.data()[i].AntiUseID;
    		Input = Input + CHR_1 + obj.gridINFAnti.data()[i].AntiDesc;
    		Input = Input + CHR_1 + obj.gridINFAnti.data()[i].AntiDesc2;
    		Input = Input + CHR_1 + obj.gridINFAnti.data()[i].SttDate;
    		Input = Input + CHR_1 + obj.gridINFAnti.data()[i].EndDate;
    		Input = Input + CHR_1 + obj.gridINFAnti.data()[i].DoseQty;
    		Input = Input + CHR_1 + obj.gridINFAnti.data()[i].DoseUnitID;
    		Input = Input + CHR_1 + obj.gridINFAnti.data()[i].PhcFreqID;
    		Input = Input + CHR_1 + obj.gridINFAnti.data()[i].MedUsePurposeID;
    		Input = Input + CHR_1 + obj.gridINFAnti.data()[i].AdminRouteID;
    		Input = Input + CHR_1 + obj.gridINFAnti.data()[i].MedPurposeID;
    		Input = Input + CHR_1 + obj.gridINFAnti.data()[i].TreatmentModeID;
    		Input = Input + CHR_1 + obj.gridINFAnti.data()[i].PreMedEffectID;
    		Input = Input + CHR_1 + obj.gridINFAnti.data()[i].PreMedIndicatID;
    		Input = Input + CHR_1 + obj.gridINFAnti.data()[i].CombinedMedID;
    		Input = Input + CHR_1 + obj.gridINFAnti.data()[i].PreMedTime;
    		Input = Input + CHR_1 + obj.gridINFAnti.data()[i].PostMedDays;
    		Input = Input + CHR_1 + obj.gridINFAnti.data()[i].SenAnaID;
    		Input = Input + CHR_1 + '';
    		Input = Input + CHR_1 + '';
    		Input = Input + CHR_1 + $.LOGON.USERID;
    		InputAnti = InputAnti + CHR_2 + Input;
    	}
    	if (InputAnti) InputAnti = InputAnti.substring(1,InputAnti.length);
    	return InputAnti;
	};
	obj.doClose =function ()
	{
		
		var tt =parent.window.opener;
	   if(EpisodeID!="")
	   {
		   window.top.opener = null;  
		   window.top.close(); 
	   }  
	   //ShowModal 参数暂未用
	   
	};
}