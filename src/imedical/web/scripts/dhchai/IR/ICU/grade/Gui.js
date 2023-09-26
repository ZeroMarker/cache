//页面Gui
function InitGradeWin(){
	var obj = new Object();
	
    $("#cboHospital").data("param",$.LOGON.HOSPID);	
	$.form.SelectRender("#cboHospital");  //渲染下拉框
	$("#cboHospital option:selected").next().attr("selected", true)
	$("#cboHospital").select2();
	//给select2赋值change事件
	$("#cboHospital").on("select2:select", function (e) { 
		//获得选中的医院
		var data= e.params.data;
		var id = data.id;
		var text =data.text;
		refreshLocList();
	});
    refreshLocList();
	
	obj.dateCom = $("#startDate").datetimepicker({
	     format: "yyyy-mm",
	     autoclose: true,
	     todayBtn: true,
	     startView:3,
		 minView:3,
		 todayHighlight: 1,
		 forceParse: 0,
		 showMeridian: 1,
	     language: 'zh-CN',
	     fontAwesome:true    //显示字体图标
	});
	var dateNow = new Date();
	var year = dateNow.getFullYear();
	var month = dateNow.getMonth();
	month++;
	/*
	if(month==0){
		month = 12;
		year--;
	}
	else
	{
		month++;
	}
	*/
	var lastDay = new Date(year,month,0).getDate();
	if(month<10) month = '0'+month;
	$("#startDate").val(year+'-'+month);
	
	var LocID=$.LOGON.LOCID; //登录科室
	var IsAdmin = 0;
	if (tDHCMedMenuOper['Admin']==1) {
		IsAdmin = 1;  //管理员权限
	}
    if (IsAdmin!=1) {	
		$.form.SetValue("cboHospital",$.LOGON.HOSPID,$.LOGON.HOSPDESC);// 默认加载登录院区
		var hospId = $.form.GetValue("cboHospital");
		$("#cboHospital").attr('disabled','disabled');
		var IsActive = 0;
		var runQuery = $.Tool.RunQuery('DHCHAI.BTS.LocationSrv','QryICULoc',hospId,$.LOGON.LOCID);
		if (runQuery){
			$("#ulLoc").empty();
			var arrOL = runQuery.record;
			for (var indOL = 0; indOL < arrOL.length; indOL++){
				var rd = arrOL[indOL];
				if (!rd) continue;
				//if(LocID !=rd["ID"]) continue;
				if (!IsActive){
					IsActive = 1;
					$("#ulLoc").val(rd["ID"]);
					$("#ulLoc").append('<li class="active" value="' + rd["ID"] + '">' + rd["LocDesc2"] + '</li>');
				} else {
					$("#ulLoc").append('<li value="' + rd["ID"] + '">' + rd["LocDesc2"] + '</li>');
				}
			}
		}
		$('#ulLoc > li').click(function (e) {
			e.preventDefault();
			$('#ulLoc > li').removeClass('active');
			$(this).addClass('active');
			$('#ulLoc').val($(this).val());
			obj.gridGrade.ajax.reload();
		});
		
    }
  
	//科室列表
	
	function refreshLocList() {
		var hospId = $.form.GetValue("cboHospital");
		var IsActive = 0;
		var runQuery = $.Tool.RunQuery('DHCHAI.BTS.LocationSrv','QryICULoc',hospId);
		if (runQuery){
			$("#ulLoc").empty();
			var arrOL = runQuery.record;
			for (var indOL = 0; indOL < arrOL.length; indOL++){
				var rd = arrOL[indOL];
				if (!rd) continue;
				if (!IsActive){
					IsActive = 1;
					$("#ulLoc").val(rd["ID"]);
					$("#ulLoc").append('<li class="active" value="' + rd["ID"] + '">' + rd["LocDesc2"] + '</li>');
				} else {
					$("#ulLoc").append('<li value="' + rd["ID"] + '">' + rd["LocDesc2"] + '</li>');
				}
			}
		}
		
		$('#ulLoc > li').click(function (e) {
			e.preventDefault();
			$('#ulLoc > li').removeClass('active');
			$(this).addClass('active');
			$('#ulLoc').val($(this).val());
			obj.gridGrade.ajax.reload();
		});
	}
	
	obj.gridGrade = $("#gridGrade").DataTable({
		dom: 'rt',
		select: 'single',
		paging: true,
		ordering: true,
		info: true,
		ajax: {
			"url": "dhchai.query.datatables.csp",
			"data": function (d) {
				d.ClassName = "DHCHAI.IRS.ICUGradeSrv";
				d.QueryName = "QryIGByMonth";
				d.Arg1 =$("#ulLoc").val();
				d.Arg2 =$("#startDate").val();
				d.ArgCnt = 2;
			}
		},
		"columns": [
			{"data": "IGGrade"},
			{"data": "IGScore"},
			{"data": "IGWeek1"},
			{"data": "IGWeek2"},
			{"data": "IGWeek3"},
			{"data": "IGWeek4"}
		]      
    });
    
   
	
	//初始化高度
	var wh = $(window).height();
    $("#divLeft").height(wh-10);
    $("#divMain").height(wh-5);
    $("#divPanel").height(wh-160);
	//自适应高度
	$(window).resize(function(){
		var wh = $(window).height();
		$("#divLeft").height(wh-10);
		$("#divMain").height(wh-5);
		$("#divPanel").height(wh-160);	
	});
	
	$("#divLeft").mCustomScrollbar({
		theme: "dark-thick",
		axis: "y",
		scrollInertia: 100
	});
	$("#divMain").mCustomScrollbar({
		theme: "dark-thick",
		axis: "y",
		scrollInertia: 100
	});
	
    $("#divPanel").mCustomScrollbar({
		theme: "dark-thick",
		axis: "y",
		scrollInertia: 100
	});
  
	$("body").mCustomScrollbar({
		theme: "dark-thick",
		axis: "y",
		scrollInertia: 100
	});


	InitGradeWinEvent(obj);
	return obj;
}