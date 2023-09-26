//页面Gui
function InitDictionaryWin(){
	var obj = new Object();
	
	//字典类型列表
	var IsActive = 0;
	var runQuery = $.Tool.RunQuery('DHCHAI.BTS.DicTypeSrv','QrySortDicType');
	if (runQuery){
		$("#ulDicType").addClass("list-group");
		$("#ulDicType").empty();
		var arrDT = runQuery.record;
		for (var indDT = 0; indDT < arrDT.length; indDT++){
			var rd = arrDT[indDT];
			if (!rd) continue;
			
			if (!IsActive){
				IsActive = 1;
				$("#ulDicType").val(rd["ID"]);
				$("#ulDicType").append('<li class="list-group-item active" value="' + rd["ID"] + '">' + rd["Desc"] + '</li>');
			} else {
				$("#ulDicType").append('<li class="list-group-item" value="' + rd["ID"] + '">' + rd["Desc"] + '</li>');
			}
		}
	}
	
	$('#ulDicType > li').click(function (e) {
		e.preventDefault();
		$('#ulDicType > li').removeClass('active');
		$(this).addClass('active');
		$('#ulDicType').val($(this).val());
		obj.gridDictionary.ajax.reload($('#gridDictionary').DataTable().search($('#search').val(),true,true).draw());
	});
	
	//字典列表
	obj.gridDictionary = $("#gridDictionary").DataTable({
		dom: 'rt<"row"<"col-sm-6 col-xs-6"pl><"col-sm-6 col-xs-6"i>>',
		select: 'single',
		paging: true,
		ordering: true,
		info: true,
		ajax: {
			"url": "dhchai.query.datatables.csp",
			"data": function (d) {
				d.ClassName = "DHCHAI.BTS.DictionarySrv";
				d.QueryName = "QryDictionary";
				d.Arg1=$('#ulDicType').val();
				d.ArgCnt = 1;
			}
		},
		columns: [
			{"data": "ID"},
			{"data": "DicCode"},
			{"data": "DicDesc"},
			{"data": "IndNo"},
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
		theme: "dark-thick",
		axis: "y",
		scrollInertia: 100
	});
	
	$('body').mCustomScrollbar({
		theme : "dark-thick",
		axis: "y",
		scrollInertia : 100
	});
	
	InitDictionaryWinEvent(obj);
	return obj;
}