//页面Gui
function InitCtlBactResultWin(){
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
		$("#cboLocation").data("param",id+"^^I|E^W^1");
		$.form.SelectRender("cboLocation");  //渲染下拉框
		$("#cboWard").data("param",id+"^^I|E^W^1");
		$.form.SelectRender("cboWard");  //渲染下拉框			
	});	
	$.form.SelectRender("#cboDateType");
	$("#cboLocation").data("param",$.form.GetValue("cboHospital")+"^^I|E^W^1");
	$.form.SelectRender("cboLocation");  //渲染下拉框
	$("#cboWard").data("param",$.form.GetValue("cboHospital")+"^^I|E^W^1");
	$.form.SelectRender("cboWard");  //渲染下拉框	
	$.form.SelectRender('cboInfType');	
	$.form.SelectRender('cboBacteria');	
	$.form.SelectRender('cboMRBBact');	
	$.form.SelectRender('cboLabSpec');	
   
    $.form.DateTimeRender('DateFrom',$.form.GetCurrDate('-'));
    $.form.DateTimeRender('DateTo',$.form.GetCurrDate('-'));
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
    //初始化高度
	var wh = $(window).height();
    $("#divLeft").height(wh-10);
	$("#divPanel").height(wh-65);
	$("#divMain").height(wh);
	//自适应高度
	$(window).resize(function(){
		//alert(1111);
		$("#gridCtlResult_wrapper .dataTables_scrollBody").mCustomScrollbar("scrollTo",$("#gridCtlResult tr td:first"));
		var wh = $(window).height();
		$("#divLeft").height(wh-10);
		$("#divPanel").height(wh-65);
		$("#divMain").height(wh);
	});
	
	$("#divLeft").mCustomScrollbar({
		theme: "dark-thick",
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
    $("#divPanel").mCustomScrollbar({
		theme: "dark-thick",
		axis: "y",
		scrollInertia: 100
	});
	$("#divMain").mCustomScrollbar({
		theme: "dark-thick",
		axis: "y",
		scrollInertia: 100
	});
	$("body").mCustomScrollbar({
		theme: "dark-thick",
		axis: "y",
		scrollInertia: 100
	});
	
	//耐药菌列表
	obj.gridCtlResult = $("#gridCtlResult").DataTable({
		dom: 'rt<"row"<"col-sm-6 col-xs-6"pl><"col-sm-6 col-xs-6"i>>',
		select: 'single',
		paging: true,
		ordering: true,
		info: true,
		"scrollX": true,
		"scrollY":true,   //此处可以设定最大高度值
		ajax: {
			"url": "dhchai.query.datatables.csp",
			"data": function (d) {
				d.ClassName = "DHCHAI.IRS.CtlMRBSrv";
				d.QueryName = "QryBactResult";
				d.Arg1 =$("#cboHospital").val();
				d.Arg2 =$("#cboDateType").val();
				d.Arg3 =$("#DateFrom").val();
				d.Arg4 =$("#DateTo").val();
				d.Arg5 =$("#cboLocation").val();
				d.Arg6 =$("#cboInfType").val();
				d.Arg7 =$("#cboBacteria").val();
				d.Arg8 =$("#cboMRBBact").val();
				d.Arg9 =$("#cboLabSpec").val();
				d.Arg10 =$("#cboWard").val();
				d.ArgCnt = 10;
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
			{"data": null, 
				render: function ( data, type, row ) {
					if (row.MRBDesc2!=""){
						return row.MRBDesc+","+row.MRBDesc2;
					}else{
						return row.MRBDesc;
					}
				}
			},
			{"data": null, 
				render: function ( data, type, row ) {
					return '<a href="#" class="btnLabSen">药敏结果</a>';
				}
			},
			{"data": "Specimen"},
			{"data": "Bacteria"},
			{"data": "ActDate"},
			{"data": "RepDate"},
			{"data": "LocDesc"},
			{"data": "LabWardDesc"},
			{"data": "DischDate"}		
		],
		"columnDefs": [
			{ 
				"type": "date-euro", 
				targets: [5,9,10,11,14] 	//适配日/月/年类型日期时的排序
			}
        ]
		,"fnDrawCallback": function (oSettings) {
			
			$("#gridCtlResult_wrapper .dataTables_scrollBody").mCustomScrollbar({
				theme : "dark-thick",
				axis: "xy",
				callbacks:{
					whileScrolling:function(){
						//alert(333);
						$('#gridCtlResult_wrapper .dataTables_scrollHead').scrollLeft(-this.mcs.left); 
					}
				}
			});			
			$("#gridCtlResult_wrapper .dataTables_scrollBody").mCustomScrollbar("scrollTo",$("#gridCtlResult tr td:first"));
			//调整div高度
			var wh = $('#divMain').height();
			var arr1 = $('#gridCtlResult_wrapper .dataTables_scrollBody').children();
			if (arr1.length){
				var dh = $('#gridCtlResult_wrapper .dataTables_scrollHead').height();
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
	
	
	
	InitCtlBactResultWinEvent(obj);
	return obj;
}