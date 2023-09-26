//ҳ��Gui
function InitOccExpQryWin(){
	var obj = new Object();
	obj.RepID="";
	obj.AdminPower  = '0';
	if (typeof tDHCMedMenuOper != 'undefined')
	{
		if (typeof tDHCMedMenuOper['Admin'] != 'undefined')
		{
			obj.AdminPower  = tDHCMedMenuOper['Admin'];
		}
	}
	var DataQuery = $.Tool.RunQuery('DHCHAI.IRS.OccExpTypeSrv','QryOccExpType',1);
	if(DataQuery){
		var arrDT = DataQuery.record;
		for (var ind = 0; ind < arrDT.length; ind++){
			var rd = arrDT[ind];
			if (!rd) continue;
			var RepID=rd["ID"];
			var RepType=rd["BTDesc"];
			var RepCode=rd["BTCode"];
			var imgType = "";
			if ((RepType.indexOf('ѪҺ')>-1)||(RepType.indexOf('��ҺҺ')>-1)) {
				imgType = "ѪҺ��Һ�Ӵ�";
			}
			if ((RepType.indexOf('�����')>-1)||(RepType.indexOf('����')>-1)) {
				imgType = "�����";
			}
			if ((RepType.indexOf('������')>-1)||(RepType.indexOf('��������')>-1)) {
				imgType = "������";
			}
			else {
				imgType = "ѪҺ��Һ�Ӵ�";
			}
			$("#tab-button").append('<a class="tabbtn" text="'+ RepID+ '"  href="#"><img src="../scripts/dhchai/img/'+imgType+'.png"><span>'+RepType+'</span></a>');
	
		}
	}

    $('#tab-button > a').click(function (e) {
		e.preventDefault();
		var aRegTypeID = $(this).attr("text");
		var aReportID = "";
        var url = '../csp/dhchai.ir.occexpreport.csp?1=1&RegTypeID='+aRegTypeID+'&ReportID='+aReportID+"&AdminPower="+obj.AdminPower+"&2=2"
		
		layer.open({
		  type: 2,
		  area: ['95%', '98%'],
		  closeBtn: 1,
		  title:'ְҵ��¶����',
		  fixed: false, //���̶�
		  content: [url,'no'],
		  success: function(layero, index){
			$("div.layui-layer-content").css("padding-right","2px");
		  },
		  end: function () {
          	obj.gridExpReg.ajax.reload(null,false);
          }
	  });
	});
	//���ÿ�ʼ����Ϊ����1��
	var currDate = $.form.GetCurrDate('-');
	var arrDate = currDate.split('-');
	var dateFrom = arrDate[0] + "-" + arrDate[1] + "-01"
    $.form.DateTimeRender('DateFrom',dateFrom);
    $.form.DateTimeRender('DateTo',$.form.GetCurrDate('-'));
	//��ֵ��ʼֵ
    $("#cboHospital").data("param",$.LOGON.HOSPID);	
	$.form.SelectRender("#cboHospital");  //��Ⱦ������
	//$("#cboLocation").data("param",$.form.GetValue("cboHospital")+"^^^^1");
	//$.form.SelectRender("cboLocation");  //��Ⱦ������
	$("#cboHospital option:selected").next().attr("selected", true)
	$("#cboHospital").select2();
	//��select2��ֵchange�¼�
	$("#cboHospital").on("select2:select", function (e) { 
		//���ѡ�е�ҽԺ
		var data= e.params.data;
		var id = data.id;
		var text =data.text;
		$("#cboLocation").data("param",id+"^^^^1");
		$.form.SelectRender("cboLocation");  //��Ⱦ������	
	});
	$.form.SelectRender("#cboRepType");
	$("#cboRepType option:selected").next().attr("selected", true)
	$("#cboRepType").select2();
	$.form.SelectRender("#cboDateType");
	$("#cboDateType").select2();		
	$.form.SelectRender("#cboStatus");
    $("#cboLocation").data("param",$.form.GetValue("cboHospital")+"^^^^1");
	$.form.SelectRender("cboLocation");  //��Ⱦ������
 
	obj.gridExpReg = $("#gridExpReg").DataTable({
		dom: 'rt<"row"<"col-sm-6 col-xs-6"pl><"col-sm-6 col-xs-6"i>>',
		select: 'single',
		paging: true,
		ordering: true,
		info: true,
		"scrollX": true,
		"scrollY": true, //�˴������趨���߶�ֵ
		ajax: {
			"url": "dhchai.query.datatables.csp",
			"data": function (d) {
				d.ClassName = "DHCHAI.IRS.OccExpRegSrv";
				d.QueryName = "QryOccExpReg";
				d.Arg1 = $("#cboHospital").val();
				d.Arg2 = $("#cboRepType").val();
				d.Arg3 = $("#cboDateType").val();
				d.Arg4 = $("#DateFrom").val();
				d.Arg5 = $("#DateTo").val();
				d.Arg6 = $("#cboLocation").val();
				d.Arg7 = $("#cboStatus").val();
				d.ArgCnt = 7;
			}
		},
		"columns": [
			{"data": "ID"},
			{"data": "RegLocDesc"},
			{"data": "RegTypeDesc"},
			{"data": "StatusDesc", 
				render: function ( data, type, row ) {
					return '<a href="#" class="btnReprot">'+data+'</a>';
				}
			},
			{"data": "null", 
				render: function ( data, type, row ) {
					return '<a href="#" class="btnOperation">������ϸ</a>';
				}
			},
			{"data": "RegUserDesc"},
			{"data": "Name"},
			{"data": "TelPhone"},
			{"data": "RegNo"},
			{"data": "Sex"},
			{"data": "WorkAge"},
			{"data": "Duty"},
			{"data": "ExpDate"},
			{"data": "RegDate"},
			{"data": "OERegType"},
			
			{"data": "OEReason"},
			{"data": "OEDegree"},
			
			{"data": "HbsAg"},
			{"data": "HCV-Ab"},
			{"data": "HIV"},
			{"data": "IsInterMed"},
			{"data": "name"}
		]
	});
		
	obj.gridExpRepLog = $("#gridExpRepLog").DataTable({
		dom: 'rt',
		info: true,
		paging: false,
		ajax: {
			"url": "dhchai.query.datatables.csp",
			"data": function (d) {
				d.ClassName = "DHCHAI.IRS.OccExpRegSrv";
				d.QueryName = "QryExpRepLog";
				d.Arg1 = obj.RepID;
				d.Arg2 = "";
				d.ArgCnt = 2;
			}
		},
		"columns": [
		    {"data": "SubID"},
			{"data": "StatusDesc"},
			{"data": "Opinion"},
			{"data": "UpdateDate"},
			{"data": "UpdateTime"},
			{"data": "UpdateUserDesc"}
		]
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
		theme: "dark-thick",
		axis: "y",
		scrollInertia: 100
	});
	$("body").mCustomScrollbar({
		theme: "dark-thick",
		axis: "y",
		scrollInertia: 100
	});
    
    $("#layer_one").mCustomScrollbar({
		theme: "dark-thick",
		axis: "y",
		scrollInertia: 100
	});
	
	InitOccExpQryWinEvent(obj);
	return obj;
}