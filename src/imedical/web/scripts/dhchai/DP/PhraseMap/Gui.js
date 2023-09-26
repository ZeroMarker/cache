//页面Gui
function InitPhraseMapWin(){
	var obj = new Object();
    
    var IsActive = 0;
	var runQuery = $.Tool.RunQuery('DHCHAI.DPS.PhraseTypeSrv','QryPhraseType');
	if (runQuery){
		$("#ulPhraseType").addClass("list-group");
		$("#ulPhraseType").empty();
		var arrDT = runQuery.record;
		for (var indDT = 0; indDT < arrDT.length; indDT++){
			var rd = arrDT[indDT];
			if (!rd) continue;
			
			if (!IsActive){
				IsActive = 1;
				$("#ulPhraseType").val(rd["ID"]);
				$("#ulPhraseType").append('<li class="list-group-item active" value="' + rd["ID"] + '">' + rd["Desc"] + '</li>');
			} else {
				$("#ulPhraseType").append('<li class="list-group-item" value="' + rd["ID"] + '">' + rd["Desc"] + '</li>');
			}
		}
	}
	
	$('#ulPhraseType > li').click(function (e) {
		e.preventDefault();
		$('#ulPhraseType > li').removeClass('active');
		$(this).addClass('active');
		$('#ulPhraseType').val($(this).val());
		obj.gridPhraseMap.ajax.reload($('#gridPhraseMap').DataTable().search($('#search').val(),true,true).draw());
	});
	
	
	//常用短语对照维护
	obj.gridPhraseMap = $("#gridPhraseMap").DataTable({
		dom: 'rt<"row"<"col-sm-6"pl><"col-sm-6"i>>',
		select: 'single',
		paging: true,
		ordering: true,
		info: true,
		ajax: {
			"url": "dhchai.query.datatables.csp",
			"data": function (d) {
				d.ClassName = "DHCHAI.DPS.PhraseMapSrv";
				d.QueryName = "QryPhraseMapByType";
				d.Arg1 = $('#ulPhraseType').val();
				d.ArgCnt = 1;
			}
		},
		columns: [
			{"data": "ID"},
			{"data": "Code"},
			{"data": "Desc"},
			{"data": "PhraseTypeDesc"},
			{"data": "MapDicDesc"},
			{"data": "SCode"},
			{"data": "IsActive", 
				"render": function (data, type, row) {
					return (data == '1' ? '是' : '否');
				}
			}
		],
		drawCallback: function (settings) {
			$("#btnAdd").removeClass('disabled');
        	$("#btnEdit").addClass('disabled');
        	$("#btnDelete").addClass('disabled');
		}
	});
	
	//初始化高度
	var wh = $(window).height();
    $("#divLeft").height(wh-20);
    $("#divMain").height(wh-1);
	
	//自适应高度
	$(window).resize(function(){
		var wh = $(window).height();
		$("#divLeft").height(wh-20);
		$("#divMain").height(wh-1);
	});
	
	$("#divLeft").mCustomScrollbar({
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
	$('body').mCustomScrollbar({
		theme: "dark-thick",
		axis: "y",
		scrollInertia : 100
	});
	

	InitPhraseMapWinEvent(obj);
	return obj;
}