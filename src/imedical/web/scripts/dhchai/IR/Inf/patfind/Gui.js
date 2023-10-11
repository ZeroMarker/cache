//页面Gui
function InitPatFindWin(){
	var obj = new Object();
    $("#cboHospital").data("param",$.LOGON.HOSPID);	
	$.form.SelectRender("#cboHospital");  //渲染下拉框	
	$("#cboHospital option:selected").next().attr("selected", true)
	$("#cboHospital").select2();
	$("#cboLocation").data("param",$.form.GetValue("cboHospital")+"^^I|E^E^1");
	$.form.SelectRender("cboLocation");  //渲染下拉框
	$("#cboWard").data("param",$.form.GetValue("cboHospital")+"^^I|E^W^1");
	$.form.SelectRender("#cboWard");  //渲染下拉框
	$.form.SelectRender("cboItems");  //渲染下拉框
	$("#cboItems").select2({
		multiple: true
		,placeholder: "--请选择--",
		placeholderOption: "first",
		allowClear: true
	});	
	//给select2赋值change事件
	$("#cboHospital").on("select2:select", function (e) { 
		//获得选中的医院
		var data= e.params.data;
		var id = data.id;
		var text =data.text;
		$("#cboLocation").data("param",id+"^^I|E^E^1");
		$.form.SelectRender("cboLocation");  //渲染下拉框	
		$("#cboWard").data("param",id+"^^I|E^W^1");
		$.form.SelectRender("cboWard");  //渲染下拉框
	
	});	
    $.form.DateTimeRender('DateFrom');
    $.form.DateTimeRender('DateTo');

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
	
	$("#divPanel").mCustomScrollbar({
		//scrollButtons: { enable: true },
		//autoHideScrollbar: true,
		theme: "dark-thick",
		axis: "y",
		scrollInertia: 100
	});
	$("#divLeft").mCustomScrollbar({
		//scrollButtons: { enable: true },
		//autoHideScrollbar: true,
		theme: "dark-thick",
		axis: "y",
		scrollInertia: 100
	});
	$("#divMain").mCustomScrollbar({
		//scrollButtons: { enable: true },
		//autoHideScrollbar: true,
		theme: "dark-thick",
		axis: "y",
		scrollInertia: 100
	});
	
	//就诊列表
	obj.gridAdm = $("#gridAdm").DataTable({
		dom: 'rt<"row"<"col-sm-6 col-xs-6"pl><"col-sm-6 col-xs-6"i>>',
		select: 'single',
		paging: true,
		ordering: true,
		info: true,
		//autoWidth: false,
		"iDisplayLength" : 50,
		"deferRender": true,
		"processing" : true,
		"scrollX": true,
		"scrollY": true,  //"380px",  //或者固定高度 75vh 代表容器百分比
        // "scrollCollapse": true,
		ajax: {
			"url": "dhchai.query.datatables.csp",
			"data": function (d) {
				var HospIDs 	= $("#cboHospital").val();
				var DateType	= $("#cboDateType").val();
				var DateFrom 	= $("#DateFrom").val();
				var DateTo 		= $("#DateTo").val();
				var LocationID  = $("#cboLocation").val();
				var WardID	 	= $("#cboWard").val();
				var PatName 	= $("#txtPatName").val();
				var PapmiNo 	= $("#txtPapmiNo").val();
				var MrNo 		= $("#txtMrNo").val();
				var reslist	 	= $("#cboItems").select2("data");
				var Items = "";
				for(var i = 0;i<reslist.length;i++){
					var dataObj = reslist[i];
					var id = dataObj.id;
					if(id!="")
					{
						if(Items=="")
						{
							Items = id;
						}
						else
						{
							Items = Items +"|"+id;
						}
					}
				}
				
				var aInputs = HospIDs+'^'+DateType+'^'+DateFrom+'^'+DateTo+'^'+LocationID+'^'+WardID+'^'+PatName+'^'+PapmiNo+'^'+MrNo+'^'+Items;
				d.ClassName = "DHCHAI.DPS.PAAdmSrv";
				d.QueryName = "QryAdm";
				d.Arg1 = aInputs;
				d.Arg2 = $('#search').val();
				d.ArgCnt = 2;
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
			{"data":"AdmTimes"},
			{"data": "PatName"},
			{"data": "Sex"},
			{"data": "Age", orderable: false},
			{"data": "IdentityCode"
				,render:function(data, type, row)
				{
					return type === 'export' ?
								String.fromCharCode(2)+data:data;
				}
			},
			{
			"data": null,
				render: function ( data, type, row ) {
				return '<a href="#" class="zy">摘要</a>';
				}
			},{
			"data": null,
				render: function ( data, type, row ) {
				return '<a href="#" class="dzbl">电子病历</a>';
				}
			},
			{
			"data": null,
				render: function ( data, type, row ) {
				return '<a href="#" class="btnReprot">新建</a>';
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
			{"data": "DischLocDesc"},
			{"data": "DischWardDesc"},
			{"data": "IsDeath", 
				render: function ( data, type, row ) {
					if (data=="1"){
						return '是';
					}else{
						return '否'
					}
				}
			},
			{"data": "DeathDate"},
			{"data": "DeathTime"},
			{"data": "HomeAddress"},
			{"data": "Company"},
			{"data": "RelativeName"},
			{"data": "RelativeTel"
				,render:function(data, type, row)
				{
					return type === 'export' ?
								String.fromCharCode(2)+data:data;
				}
			},
			{"data": "EpisodeIDx",
				render: function ( data, type, row ) {
					var editHtml = data+"&nbsp&nbsp&nbsp";
					return editHtml; 
				}
			}
		],
		"columnDefs": [
                { 
                	"type": "date-euro", 
                	targets: [11,15,20] 
                },
                {
					"orderable": false,
					"visible": true,
					"targets": 5
				}
        ],
		"fnInitComplete" :function (oSettings) {
			$("#gridAdm_wrapper .dataTables_scrollBody").mCustomScrollbar({
				theme : "dark-thick",
				axis: "xy",
				callbacks:{
					whileScrolling:function(){
						$('#gridAdm_wrapper .dataTables_scrollHead').scrollLeft(-this.mcs.left); 
					}
				}
			})
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
		},
		"fnDrawCallback": function (oSettings) {
			$("#gridAdm_wrapper .dataTables_scrollBody").mCustomScrollbar("update");
			$("#gridAdm_wrapper .dataTables_scrollBody").mCustomScrollbar("scrollTo",$("#gridAdm tr td:first"));
        }
	});
	
	InitPatFindWinEvent(obj);
	obj.LoadEvents(arguments);
	return obj;
}
