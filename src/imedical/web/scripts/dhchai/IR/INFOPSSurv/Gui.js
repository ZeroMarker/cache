var CHR_1 = String.fromCharCode(1);
var CHR_2 = String.fromCharCode(2);
//页面Gui
function InitINFOPSSurvWin(){
	var obj = new Object();
    obj.EpisodeID="";
    obj.ReportID="";
	obj.ClickCnt = 0;
    $("#cboHospital").data("param",$.LOGON.HOSPID);	
	$.form.SelectRender("cboHospital");  //渲染下拉框
	// 默认加载登录院区
	$.form.SetValue("cboHospital",$.LOGON.HOSPID,$.LOGON.HOSPDESC);
	//加载科室
	obj.initLoc = function(){
		if (tDHCMedMenuOper['Admin']!=1&&EpisodeID=="") {
			//非管理员权限仅加载登录科室
			$.form.SetValue("cboLocation",$.LOGON.LOCID,$.LOGON.LOCDESC);
			$("#cboLocation").attr("disabled",true);
		} else {
			$("#cboLocation").data("param",$.form.GetValue("cboHospital"));
			$.form.SelectRender("cboLocation");  //渲染下拉框
		}
	}
	obj.initLoc();
	
	/*
	//科室列表
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
		//科室
		for (var indOL = 0; indOL < arrOL.length; indOL++){
			var rd = arrOL[indOL];
			if (!rd) continue;
			//增加管理员权限才可以查询全院的
			if (tDHCMedMenuOper['Admin']!=1) {
				//if(rd["ID"]!=$.LOGON.XLocID)continue;
				if(rd["ID"]!=$.LOGON.LOCID)continue;
			}
			if (!IsActive){
				IsActive = 1;
				$("#ulOperLoc").val(rd["ID"]);
				$("#ulOperLoc").append('<li class="active treeview" value="' + rd["ID"] + '">' + rd["LocDesc"] + '</li>');
			} else {
				$("#ulOperLoc").append('<li class="treeview" value="' + rd["ID"] + '">' + rd["LocDesc"] + '</li>');
			}
		}
	}
	
	$('#ulOperLoc > li').click(function (e) {
		e.preventDefault();
		$('#ulOperLoc > li').removeClass('active');
		$(this).addClass('active');
		$('#ulOperLoc').val($(this).val());
		obj.gridINFOPSSurv.clear().draw();
		obj.gridINFOPSSurv.ajax.reload();
	});
	*/
	
    //初始化赋值
    $.form.DateTimeRender('DateFrom',$.form.GetCurrDate('-'));
    $.form.DateTimeRender('DateTo',$.form.GetCurrDate('-'));
 
	$.form.SelectRender("cboCuteType");  //渲染下拉框

	var tableHeight = (($(window).height()-166) >400 ? ($(window).height()-166): 420);
	// 手术调查列表
	obj.gridINFOPSSurv = $("#gridINFOPSSurv").DataTable({
		dom: 'rt<"row"<"col-sm-6 col-xs-6"pl><"col-sm-6 col-xs-6"i>>',
		select: 'single',
		paging: true,
		ordering: true,
		info: true,
		"processing" : true,
		"iDisplayLength" : 10,
		"scrollX": true,
		"scrollY":tableHeight+'px',   //($(window).height()-167)+"px"此处可以设定最大高度值
		ajax: {
			"url": "dhchai.query.datatables.csp",
			"data": function (d) {
				d.ClassName = "DHCHAI.DPS.OROperAnaesSrv";
				d.QueryName = "QryINFOPSSurv";
				d.Arg1 =$("#DateFrom").val();
				d.Arg2 =$("#DateTo").val();
				d.Arg3 =$.form.GetValue("cboLocation");
				d.Arg4 =$.form.GetValue("cboHospital");
				d.Arg5 =$.form.GetValue("cboCuteType");
				d.Arg6 = EpisodeID;
				d.ArgCnt = 6;
			}
		},
		"columns": [
			{"data": "MrNo",render: function (data, type, row) {   //病案号加不可见字符，适用导出、打印格式
				return type == 'export' ?
				String.fromCharCode(2)+row.MrNo:data;
				}
			},
			{"data": "INFOPSID",
				render: function (data, type, row ) {
					if ((data!="")&(data!=undefined)){
						return '<a href="#" class="btnReprot">'+data+'</a>';
					}else {
						return '<a href="#" class="btnReprot">新建</a>';
					}
				}
			},
			{"data": "RepStatus"},
			{"data": "PapmiNo",render: function (data, type, row) {   //病案号加不可见字符，适用导出、打印格式
				return type == 'export' ?
				String.fromCharCode(2)+row.PapmiNo:data;
				}
			},
			{"data": "PatName"},
			{"data": "Sex"},
			{"data": "Age"},
			{"data": "OperDesc",
				render: $.fn.dataTable.render.ellipsis(12)
			},
			{"data": "OperDate"},
			{"data": "OpertorName"},
			{"data": "OperLocDesc"},
			{"data": "MapTypeDicDesc"},
			{"data": "MapIncDicDesc"},
			{"data": "MapASADicDesc"},
			{"data": "AdmDate"},
			{"data": "DischDate"},
			{"data": "InLocDate"},
			{"data": "OutLocDate"},
			{"data": "AdmBed"},
			{"data": "RepUser"},
			{"data": "RepDate"}
		]
	});
	// 抗菌药物
	obj.refreshgridINFAnti = function(){
		if(obj.gridINFAnti==undefined)
		{
			// 抗菌药物信息
			obj.gridINFAnti = $("#gridINFAnti").DataTable({
				dom: 'rt',
				paging:false,
				select: 'single',
				ordering: false,
				ajax: {
					"url": "dhchai.query.datatables.csp",
					"data": function (d) {
						d.ClassName = "DHCHAI.IRS.INFAntiSrv";
						d.QueryName = "QryINFAntiByRep";
						d.Arg1 = obj.ReportID;
						d.Arg2 = '';
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
					,{"data": "MedUsePurpose"}
					,{"data": "AdminRoute"}
					,{"data": "MedPurpose"}
					,{"data": "TreatmentMode"}
					,{"data": "PreMedEffect"}
					,{"data": "PreMedIndicat"}
					,{"data": "CombinedMed"}
					,{"data": "PreMedTime"}
					,{"data": "PostMedDays"}
					,{"data": "SenAna"}
				]
			});
		}else{
			obj.gridINFAnti.ajax.reload(function(){});
		}
	}
	obj.refreshgridINFAnti();

	//初始化高度
	var wh = $(window).height();
    $("#divLeft").height(wh-10);
    $("#divMain").height(wh-10);
	$("#panelBody").height(wh-65);
	$("#layer_one").height(wh-110);
	//自适应高度
	$(window).resize(function(){
		var wh = $(window).height();
		$("#divLeft").height(wh-10);
		$("#divMain").height(wh-10);
		$("#panelBody").height(wh-65);
		$("#layer_one").height(wh-110);
	});
	
	InitINFOPSSurvWinEvent(obj);
	return obj;
}