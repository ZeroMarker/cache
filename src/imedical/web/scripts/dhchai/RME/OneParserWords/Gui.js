//页面Gui
function InitOneParserWordsWin(){
	var obj = new Object();
    obj.gridOneWords = $("#gridOneWords").DataTable({
		dom: 'rt<"row"<"col-sm-12"pl><"col-sm-12"i>>',
		select: 'single',
		ordering: true,
		serverSide : true,           //开启服务器模式:启用服务器分页
		paging : true,               //是否分页
		pagingType : "full_numbers", //除首页、上一页、下一页、末页四个按钮还有页数按钮
		info: true,
		ajax: {
			"url": "dhchai.query.datatables2.csp",
			"data": function (d) {
				d.ClassName = "DHCHAI.RMES.OneWordsSrv";
				d.QueryName = "QryOneWords";
				d.Arg1 = $.form.GetValue("cboVerSearch");
				d.ArgCnt = 1;
			}
		},
		columns: [
			{"data": "ID"},
			{"data": "OneWord"},
			{"data": "CatDesc"},
			{"data": "ActDate"}
			
		],
		drawCallback: function (settings) {
			$("#btnAdd_one").removeClass('disabled');
        	$("#btnEdit_one").addClass('disabled');
        	$("#btnDelete_one").addClass('disabled');
		}
	});

    $('#gridOneWords').on('click','tr', function(e) {
		var rd = obj.gridOneWords.row(this).data();
		if (rd){
			$('#gridOneWords').val(rd["ID"]);
		}
		obj.gridParserWords.ajax.reload();   
	}); 

	//语义词维护
	obj.gridParserWords = $("#gridParserWords").DataTable({
		dom: 'rt<"row"<"col-sm-6"pl><"col-sm-6"i>>',
		select: 'single',
		paging: true,
		ordering: true,
		info: true,
		ajax: {
			"url": "dhchai.query.datatables.csp",
			"data": function (d) {
				d.ClassName = "DHCHAI.RMES.ParserWordsSrv";
				d.QueryName = "QryParserWords";
				var rd = obj.gridOneWords.rows({selected: true}).data().toArray()[0];
				if (rd) {
					d.Arg1 = rd["VerID"];
					d.Arg2 = rd["ID"];
				} else {
					d.Arg1 = $.form.GetValue("cboVerSearch");
					d.Arg2 = "";
				}
				d.ArgCnt = 2;
			}
		},
		columns: [
			{"data": "ID"},
			{"data": "KeyWord"},
			{"data": "LimitWord"},
			{"data": "Context"},
			{"data": "OneWord"},
			{"data": "IsCheck", 
				"render": function (data, type, row) {
					return (data == '1' ? '是' : '否');
				}
			},
			{"data": "IsActive", 
				"render": function (data, type, row) {
					return (data == '1' ? '是' : '否');
				}
			},
			{"data": "ActDate"},
			{"data": "ActUser"}
		],
		drawCallback: function (settings) {
			$("#btnEdit_two").addClass('disabled');
        	$("#btnDelete_two").addClass('disabled');
		}
	});
	
	$("body").mCustomScrollbar({
		theme: "dark-thick",
		axis: "y",
		scrollInertia: 100
	});
	
	InitOneParserWordsWinEvent(obj);
	return obj;
}