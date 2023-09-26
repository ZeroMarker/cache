//页面Gui
function InitOmissionWin(){
	var obj = new Object();
	//初始化赋值
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
		$("#cboLocation").data("param",id+"^^I^E^1");
		$.form.SelectRender("cboLocation");  //渲染下拉框
	
	});	
	$("#cboLocation").data("param",$.form.GetValue("cboHospital")+"^^I^E^1");
	$.form.SelectRender("cboLocation");  //渲染下拉框
	$.form.iCheckRender();
    $.form.DateTimeRender('DateFrom');
    $.form.DateTimeRender('DateTo');
	$("#DateFrom").val($.form.GetCurrDate('-'));
	$("#DateTo").val($.form.GetCurrDate('-'));

	//初始化高度
	var wh = $(window).height();
    $("#divLeft").height(wh-10);
    $("#divMain").height(wh);
	$("#divPanel").height(wh-65);
	//自适应高度
	$(window).resize(function(){
		$("#gridAdm_wrapper .dataTables_scrollBody").mCustomScrollbar("scrollTo",$("#gridAdm tr td:first"));
		var wh = $(window).height();
		$("#divLeft").height(wh-10);
		$("#divMain").height(wh);
		$("#divPanel").height(wh-65);
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
	/*
    $("#divPanel").mCustomScrollbar({
		theme: "dark-thick",
		axis: "y",
		scrollInertia: 100
	});*/
	
	
    //就诊列表
	obj.gridAdm = $("#gridAdm").DataTable({
		dom: 'rt<"row"<"col-sm-6"pl><"col-sm-6"i>>',
		paging: true,
		ordering: true,
		info: true,
		"deferRender": true,
		"processing" : true,
		"iDisplayLength" : 50,
		"scrollX": true,
		"scrollY": true,//"300px",  //或者固定高度 75vh 代表容器百分比
        // "scrollCollapse": true,
		ajax: {
			"url": "dhchai.query.datatables.csp",
			"data": function (d) {
				d.ClassName = "DHCHAI.IRS.InfOmissionSrv";
				d.QueryName = "QryOmission";
				d.Arg1 = $("#cboHospital").val();
				d.Arg2 = $("#cboLocation").val();
				d.Arg3 = $("#DateFrom").val();
				d.Arg4 = $("#DateTo").val();
				d.Arg5 = $.form.GetValue("chkInHospFlag");
				d.ArgCnt = 5;
			}
		},
		"columns": [
			{
				"data": "PapmiNo"
				,render:function(data, type, row)
				{
					return type === 'export' ?
								String.fromCharCode(2)+data:data;
				}
			},
			{
				"data": "MrNo"
				,render:function(data, type, row)
				{
					return type === 'export' ?
								String.fromCharCode(2)+data:data;
				}
			},
			{"data": "PatName"},
			{"data": "Sex"},
			{"data": "Age"},
			{
			"data": null,
				render: function ( data, type, row ) {
				return '<a href="#" class="zy">摘要</a>';
				}
			},
			{"data": "AdmType", 
				render: function ( data, type, row ) {
					if (data=="O"){
						return '门诊';
					}else if (data=="E"){
						return '急诊';
					}else if (data=="EP"){
						return '急诊留观';
					}else if (data=="I"){
						return '住院';
					}
				}
			},
			{"data": "AdmDate"},
			{"data": "AdmTime"},
			{"data": "AdmLocDesc"},
			{"data": "AdmWardDesc"},
			{"data": "DischDate"},
			{"data": "DischTime"},
			{"data": "IsDeath", 
				render: function ( data, type, row ) {
					if (data=="1"){
						return '是';
					}else{
						return '否'
					}
				}
			}
		],"columnDefs": [{
			"type":"date-euro",
			"targets": [4,7,11]
		}]
		,"fnDrawCallback": function (oSettings) {
			$("#gridAdm_wrapper .dataTables_scrollBody").mCustomScrollbar({
				//scrollButtons: { enable: true },
				theme : "dark-thick",
				axis: "xy",
				callbacks:{
					whileScrolling:function(){
						$('#gridAdm_wrapper .dataTables_scrollHead').scrollLeft(-this.mcs.left); 
					}
				}
			});
			$("#gridAdm_wrapper .dataTables_scrollBody").mCustomScrollbar("scrollTo",$("#gridAdm tr td:first"));
			//调整div高度
			var wh = $('#divMain').height();
			var arr1 = $('#gridAdm_wrapper .dataTables_scrollBody').children();
			if (arr1.length){
				var dh = $('#gridAdm_wrapper .dataTables_scrollHead').height();
				var hh = (wh - dh - 135) + "px";
				var divID = "#" + arr1[0].id;
				$(divID).height(hh);
			}
			var arr2 = $('#divMain').children();
			if (arr2.length){
				var hh = wh + "px";
				var divID = "#" + arr2[0].id;
				$(divID).height(hh);
			}
        }
	});
	function getContentSize() {
    	var wh = document.documentElement.clientHeight; 
   		var eh = 166;
    	var ch = (wh - eh) + "px";
    	obj1 = document.getElementById("mCSB_3");
    	var dh=$('div.dataTables_scrollHead').height();
    	var sh=(wh - eh + dh )+ "px"; 
    	if (obj1){  
   			obj1.style.height = ch;
    	}else {
	   		$('div.dataTables_scrollBody').css('height',sh);
    	}
	}
	
		
	InitOmissionWinEvent(obj);
	obj.LoadEvents(arguments);
	return obj;
}
