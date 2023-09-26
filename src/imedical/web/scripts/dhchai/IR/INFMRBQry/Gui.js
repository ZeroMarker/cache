//页面Gui
function InitMBRRepWin(){
	var obj = new Object();
    obj.ResultID="";
   
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
		$("#cboLocation").data("param",id+"^^I^W^1");
		$.form.SelectRender("cboLocation");  //渲染下拉框	
	});	
	$("#cboLocation").data("param",$.form.GetValue("cboHospital")+"^^I^W^1");
	$.form.SelectRender("cboLocation");  //渲染下拉框	
    $.form.SelectRender('cboLocation');	
	$.form.SelectRender('cboInfType');	
	$.form.SelectRender('cboBacteria');	
	$.form.SelectRender('cboMRBBact');	
   
    $.form.DateTimeRender('DateFrom',$.form.GetCurrDate('-'));
    $.form.DateTimeRender('DateTo',$.form.GetCurrDate('-'));
    //初始化高度
	var wh = $(window).height();
    $("#divLeft").height(wh-10);
    $("#divMain").height(wh);
	$("#divPanel").height(wh-65);
	//自适应高度
	$(window).resize(function(){
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
    $("#divPanel").mCustomScrollbar({
		theme: "minimal-dark",
		axis: "y",
		scrollInertia: 100
	});
	$("#layer_two").mCustomScrollbar({
		theme: "dark-thick",
		axis: "y",
		scrollInertia: 100
	});
	$("#layer_one").mCustomScrollbar({
		theme: "dark-thick",
		axis: "y",
		scrollInertia: 100
	});
	$('body').mCustomScrollbar({
		theme: "dark-thick",
		scrollInertia : 100
	});
    /*
    //默认获取当前日期
    var date = new Date();
    var mon = date.getMonth();
    var day = date.getDate();
    var year = date.getFullYear();
    var mydate = date.getFullYear() + "-" + (mon < 10 ? "0" + mon : mon) + "-" + (day < 10 ? "0" + day : day);
	if(mon==0){
		mon = 12;
		year--;
	}
	else
	{
		mon++;
	}

	if(mon<10) mon = '0'+mon;
	if(day<10) day = '0'+day;
	$("#DateFrom").val(year+'-'+mon+'-'+day);
	$("#DateTo").val(year+'-'+mon+'-'+day);
    */
	//耐药菌报告列表
	obj.gridMBRRep = $("#gridMBRRep").DataTable({
		dom: 'rt<"row"<"col-sm-6"pl><"col-sm-6"i>>',
		select: 'single',
		paging: true,
		ordering: true,
		info: true,
		autoWidth: false,
		"iDisplayLength": 50,
		"scrollX": true,
		"scrollY": true, //此处可以设定最大高度值
		ajax: {
			"url": "dhchai.query.datatables.csp",
			"data": function (d) {
				d.ClassName = "DHCHAI.IRS.INFMBRSrv";
				d.QueryName = "QryINFMBRSrv";
				d.Arg1 =$("#cboHospital").val();
				d.Arg2 =$("#DateFrom").val();
				d.Arg3 =$("#DateTo").val();
				d.Arg4 =$("#cboLocation").val();
				d.Arg5 =$("#cboInfType").val();
				d.Arg6 =$("#cboBacteria").val();
				d.Arg7 =$("#cboMRBBact").val();
				d.ArgCnt = 7;
			}
		},
		"columns": [
		    {"data": "AdmWardDesc"},
		    {"data": "MrNo",render: function (data, type, row) {   //病案号加不可见字符，适用导出、打印格式
				return type == 'export' ?
				String.fromCharCode(2)+row.MrNo:data;
				}
			},
			{"data": "PatName"},
			{"data": "Sex"},
			{"data": "Age"},
			{"data": "AdmDate"},
			{"data": "RepStatus", 
				render: function ( data, type, row ) {
					return '<a href="#" class="btnReprot">'+data+'</a>';
				}
			},
			{"data": "RepDate"},
			{"data": "MRBDesc"},
			{"data": null, 
				render: function ( data, type, row ) {
					return '<a href="#" class="btnLabSen">药敏结果</a>';
				}
			},
			{"data": "InfTypeDesc"},
			{"data": "InsulatDesc"},
		    {"data": "ContactListDesc"},
			{"data": "DropletListDesc"},
			{"data": "PlaceListDesc"},
			{"data": "UnitListDesc"},
			{"data": "TreatDesc"},
			{"data": "EnvDesc"},
			{"data": "ClothDesc"},
			{"data": "VisitListDesc"},
			{"data": "EndListDesc"},
			{"data": "SubmissDate"},
			{"data": "DischDate",
				render: function ( data, type, row ) {
					var editHtml = data+"&nbsp&nbsp&nbsp";
					return editHtml; 
				}
			}
		],
		"fnInitComplete" :function (oSettings) {
			$("#gridMBRRep_wrapper .dataTables_scrollBody").mCustomScrollbar({
				theme : "dark-thick",
				axis: "xy",
				callbacks:{
					whileScrolling:function(){
						$('#gridMBRRep_wrapper .dataTables_scrollHead').scrollLeft(-this.mcs.left); 
					}
				}
			});	
			//调整div高度
			var wh = $('#divMain').height();
			var arr1 = $('#gridMBRRep_wrapper .dataTables_scrollBody').children();
			if (arr1.length){
				var dh = $('#gridMBRRep_wrapper .dataTables_scrollHead').height();
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
		},
		"fnDrawCallback": function (oSettings) {
			$("#gridMBRRep_wrapper .dataTables_scrollBody").mCustomScrollbar("update");
			$("#gridMBRRep_wrapper .dataTables_scrollBody").mCustomScrollbar("scrollTo",$("#gridMBRRep tr td:first"));
        }
	});
	
	
	obj.gridIRDrugSen = $("#gridIRDrugSen").DataTable({
		dom: 'rt',
		info: true,
		paging: false,
		ajax: {
			"url": "dhchai.query.datatables.csp",
			"data": function (d) {
				d.ClassName = "DHCHAI.IRS.CtlMRBSrv";
				d.QueryName = "QryResultSen";
				d.Arg1 = obj.ResultID;
				d.ArgCnt = 1;
			}
		},
		"columns": [
			{"data": "AntDesc"},
			{"data": "Sensitivity"}
		]
	});
	
	
	
	InitMBRRepWinEvent(obj);
	return obj;
}