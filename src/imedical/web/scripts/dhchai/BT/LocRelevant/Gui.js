//页面Gui
function InitLocRelevWin(){
	var obj = new Object();
	obj.relevCount=0;
	$.form.SelectRender("cboCat");  //渲染下拉框
	//  分类默认选中第一项
	$.form.SetValue("cboCat",$("#cboCat>option:nth-child(2)").val(),$("#cboCat>option:nth-child(2)").text());
	
	var wh = $(window).height();
	$("body").height(wh);
	obj.SelectLocRelevID = "";
	obj.ClickLocID="";
	
	//科室相关性列表
	obj.gridLocRelev = $("#gridLocRelev").DataTable({
		dom: 'rt<"row"<"col-sm-6 col-xs-6"pl><"col-sm-6 col-xs-6"i>>',
		select: 'single',
		paging: true,
		ordering: true,
		info: true,
		ajax: {
			"url": "dhchai.query.datatables.csp",
			"data": function (d) {
				d.ClassName = "DHCHAI.BTS.LocRelevantSrv";
				d.QueryName = "QryLocRelev";
				d.Arg1 = $.form.GetValue("cboCat");
				d.ArgCnt = 1;
			}
		},
		"columns" : [
			{ "data": "ID" },
			{ "data": "Name" },
			{ "data": "LocDescList" },
			{ "data": "IsActive",
				render: function ( data, type, row ) {
					return (data == '1' ? '是' : '否');
				}
			},
			{ "data": "ActUser" }
		],
		drawCallback: function (settings) {
			$("#btnAdd").removeClass('disabled');
        	$("#btnEdit").addClass('disabled');
        	$("#btnDelete").addClass('disabled');
		}
	});
	
	//列表
	obj.gridLoc = $("#gridLoc").DataTable({
		dom: 'rtpl',
		select: 'single',
		paging: true,
		order:([ 2, 'desc']),
		deferRender: true,  //数据量较多时只加载第一页
		info: true,
		ajax: {
			"url": "dhchai.query.datatables.csp",
			"data": function (d) {
				d.ClassName = "DHCHAI.BTS.LocRelevantSrv";
				d.QueryName = "QryLoc";
				d.Arg1 = "";
				d.Arg2 = "";
				d.Arg3 = "";
				d.Arg4 = "";
				d.Arg5 = "1";
				d.Arg6 = obj.SelectLocRelevID;
				d.ArgCnt = 6;
			}
		},
		columns: [
			{"data": "LocCode",
			    render: function(data, type, row, meta) { 
					return '<span title="'+data +'">'+data +'</span>';
		  	 	} 
			},
			{"data": "LocDesc2",
			    render: function(data, type, row, meta) { 
					return '<span title="'+data +'">'+data +'</span>';
		  	 	} 
			},
			{"data": null,
				render: function(data, type, row, meta) {
					if (data.IsRelev == 1) {
						return '<a href="#" class="deleteRelev"><img src="../scripts/dhchai/img/取消关联.png">取消关联</a>';
					} else {
						return '<a href="#" class="addRelev"><img src="../scripts/dhchai/img/关联.png">关联</a>';
					}
					
		  	 	} 
			}
		],
		"fnDrawCallback": function(oSettings) {
			if (typeof oSettings.json == "undefined") return;
			var dataJson=oSettings.json.data;
			obj.relevCount=0;
			$.each(dataJson, function(index, value) {
				if (value.IsRelev == "1") obj.relevCount+=1;
			});
		}
	});
	
//	$("#gridLocRelev").mCustomScrollbar({
//		theme: "dark-thick",
//		axis: "y",
//		scrollInertia: 100
//	});
	$("body").mCustomScrollbar({
		theme: "dark-thick",
		axis: "y",
		scrollInertia: 100
	});
	
	InitLocRelevWinEvent(obj);
	return obj;
}