//ҳ��Gui
function InitScreenScoreWin(){
	var obj = new Object();
	
    //��ʼ����ֵ
    $("#cboHospital").data("param",$.LOGON.HOSPID);
	$.form.SelectRender("#cboHospital");  //��Ⱦ������
	$("#cboLocation").data("param",$.form.GetValue("cboHospital")+"^^I^W^1");
	$.form.SelectRender("cboLocation");  //��Ⱦ������
	$("#cboHospital option:selected").next().attr("selected", true)
	$("#cboHospital").select2();
	//��select2��ֵchange�¼�
	$("#cboHospital").on("select2:select", function (e) { 
		//���ѡ�е�ҽԺ
		var data= e.params.data;
		var id = data.id;
		var text =data.text;
		$("#cboLocation").data("param",id+"^^I^W^1");
		$.form.SelectRender("cboLocation");  //��Ⱦ������	
	});
    $.form.SelectRender('cboLocation');
    $.form.DateTimeRender('txtDateFrom',$.form.GetCurrDate('-'));
    $.form.DateTimeRender('txtDateTo',$.form.GetCurrDate('-'));
    $.form.SetValue("txtMinScore",'10');
    $.form.SetValue('txtMaxScore','100');
    
	//����ɸ�������б�
	obj.gridScreenSoreList = $("#gridScreenSoreList").DataTable({
		dom: 'rt<"row"<"col-sm-6"pl><"col-sm-6"i>>',
		paging: true,
		ordering: true,
		info: true,
		"scrollX": true,
		"scrollY":true, //�˴������趨���߶�ֵ
		ajax: {
			"url": "dhchai.query.datatables.csp",
			"data": function (d) {
				d.ClassName = "DHCHAI.IRS.CCScreenSoreSrv";
				d.QueryName = "QryScreenPatList";
				d.Arg1 =$("#cboHospital").val();
				d.Arg2 =$("#txtDateFrom").val();
				d.Arg3 =$("#txtDateTo").val();
				d.Arg4 =$("#txtMinScore").val();
				d.Arg5 =$("#txtMaxScore").val();
				d.Arg6 =$("#cboLocation").val();
				d.ArgCnt = 6;
			}
		},
		"columns": [
			{"data": "EpisodeDr"},
		    {"data": "PapmiNo",render: function (data, type, row) {
				return type == 'export' ?
				String.fromCharCode(2)+row.PapmiNo:data;
				}
			},
			{"data": "PatName"},
			{"data": "Sex"},
			{"data": "Age"},
			{"data": "ScoreCnt"},
			{"data": "SuspendDesc"},
			{
			"data": null,
				render: function ( data, type, row ) {
				return '<a href="#" class="zy">ժҪ</a>';
				}
			},
			{"data": "AdmDate"},
			{"data": "LocDesc"},
		    {"data": "WardDesc"},
		    {"data": "CurrBed"},
			{"data": "DischDate"}
		]
		,"fnDrawCallback": function (oSettings) {
			$("#gridScreenSoreList_wrapper .dataTables_scrollBody").mCustomScrollbar({
				theme : "dark-thick",
				axis: "xy",
				callbacks:{
					whileScrolling:function(){
						$('#gridScreenSoreList_wrapper .dataTables_scrollHead').scrollLeft(-this.mcs.left); 
					}
				}
			});			
			$("#gridScreenSoreList_wrapper .dataTables_scrollBody").mCustomScrollbar("scrollTo",$("#gridScreenSoreList tr td:first"));
			getContentSize();
        }
	});
	
	//��ʼ���߶�
	var wh = $(window).height();
    $("#divLeft").height(wh-10);
    $("#divMain").height(wh);
	$("#divPanel").height(wh-65);
	//����Ӧ�߶�
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
	$('body').mCustomScrollbar({
		theme: "dark-thick",
		scrollInertia : 100
	});
	
	InitScreenScoreWinEvent(obj);
	return obj;
}