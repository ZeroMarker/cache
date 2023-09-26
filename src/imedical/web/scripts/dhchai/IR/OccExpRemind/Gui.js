//页面Gui
function InitOccExpRemindWin(){
	var obj = new Object();
	obj.RepID = "";
	obj.Status ="";
	obj.AdminPower  = '0';
	if (typeof tDHCMedMenuOper != 'undefined')
	{
		if (typeof tDHCMedMenuOper['Admin'] != 'undefined')
		{
			obj.AdminPower  = tDHCMedMenuOper['Admin'];
		}
	}
	
	//设置开始日期为当月1号
	var currDate = $.form.GetCurrDate('-');
	var arrDate = currDate.split('-');
	var dateFrom = arrDate[0] + "-" + arrDate[1] + "-01"
    $.form.DateTimeRender('DateFrom',dateFrom);
    $.form.DateTimeRender('DateTo',$.form.GetCurrDate('-'));
	//赋值初始值
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
		$("#cboLocation").data("param",id+"^^^^1");
		$.form.SelectRender("cboLocation");  //渲染下拉框	
	});
	$("#cboLocation").data("param",$.form.GetValue("cboHospital")+"^^^^1");
	$.form.SelectRender("cboLocation");  //渲染下拉框
    $.form.SelectRender("#cboRepType");
	$("#cboRepType option:selected").next().attr("selected", true)
	$("#cboRepType").select2();
	
	$.form.SelectRender("#cboDateType");
	$("#cboDateType").select2();
			
    var RemindDays = $.Tool.RunServerMethod("DHCHAI.BT.Config","GetValByCode","ExpLabRemindDays");
    PerDay = RemindDays.split("-")[0];
    AftDay = RemindDays.split("-")[1];
	$("#cboDateType").on("select2:select", function (e) { 
		var data= e.params.data;
		var id = data.id;
		var text =data.text;
		if (id ==1) {
			var BeforeDay = $.form.fun_date(-PerDay);
			var AfterDay = $.form.fun_date(+AftDay);
			$.form.DateTimeRender('DateFrom',BeforeDay);
			$.form.DateTimeRender('DateTo',AfterDay);	
		}else {
			$.form.DateTimeRender('DateFrom',dateFrom);	
			$.form.DateTimeRender('DateTo',$.form.GetCurrDate('-'));	
		}
	});
	var DateType =$.form.GetValue("cboDateType");	
	if (DateType ==1) {	
		var BeforeDay = $.form.fun_date(-PerDay);
		var AfterDay = $.form.fun_date(+AftDay);
		$.form.DateTimeRender('DateFrom',BeforeDay);
		$.form.DateTimeRender('DateTo',AfterDay);		
	}

	obj.gridExpRemind = $("#gridExpRemind").DataTable({
		dom: 'rt<"row"<"col-sm-6 col-xs-6"pl><"col-sm-6 col-xs-6"i>>',
		select: 'single',
		paging: true,
		ordering: true,
		info: true,
		//"scrollX": true,
		//"scrollY": true, //此处可以设定最大高度值
		ajax: {
			"url": "dhchai.query.datatables.csp",
			"data": function (d) {
				d.ClassName = "DHCHAI.IRS.OccExpRegSrv";
				d.QueryName = "QryOccExpRemind";
				d.Arg1 = $("#cboHospital").val();
				d.Arg2 = $("#cboRepType").val();
				d.Arg3 = $("#cboDateType").val();
				d.Arg4 = $("#DateFrom").val();
				d.Arg5 = $("#DateTo").val();
				d.Arg6 = $("#cboLocation").val();
				d.ArgCnt = 6;
			}
		},
		"columns": [
			{"data": "ID"},
			{"data": "Name"},
			{"data": "TelPhone"},
			{"data": "RegNo"},
			{"data": "Sex"},
			{"data": "WorkAge"},
			{"data": "Duty"},
			{"data": null, 
				render: function ( data, type, row ) {
					if ($("#cboDateType").val() =='1') {
						if (row['IsRequire'] == '1') {						
							return '<a href="#" class="btnRemind">提醒：'+data.RequireLsit.replace(/#/g,'<br />')+'</a>';
						}
					}else {
						if (row['IsRemind'] == '1'){
							return '已提醒'+'('+row['RemindDate']+')';
						}
					}
				}
			},
			{"data": null, 
				render: function ( data, type, row ) {
					if ($("#cboDateType").val() =='1') {
						if (row['IsRemind'] == '1') {
							return '<a href="#" class="btnOperation">提醒明细</a>';
						}else {
							return '';
						}
					}
					if ($("#cboDateType").val() =='2') {
						return '<a href="#" class="btnOperation">提醒明细</a>';
					}
				}
			},
		
			{"data": "RegUserDesc"},
			{"data": "RegLocDesc"},
			{"data": "RegTypeDesc"},
			{"data": "ExpDate"},
			{"data": "RegDate"}
		]
		
	});
	new $.fn.dataTable.Buttons(obj.gridExpRemind, {
		buttons: [
			{
				extend: 'excel',
				text:'导出',
				title:"职业暴露提醒"
				,footer: true
				,exportOptions: {
					columns: ':visible'
					,width:50
					,orthogonal: 'export'
				},
				customize: function( xlsx ) {
					var sheet = xlsx.xl.worksheets['sheet.xml'];
					
				}
			}
			/*
			,{
				extend: 'print',
				text:'打印'
				,title:""
				,footer: true
			}*/
		]
	});

	//合并相邻相同数据的单元格（可循环合并）
	$('#gridExpRemind').DataTable().on('draw',function(){
        var rows = [],nodes = obj.gridExpRemind.column(0).nodes();
        nodes.each(function(cell,i){
            if(i != 0) {
                if($(cell).text() == $(nodes[i-1]).text()) {
                    var row = rows.pop();
                    rows.push({
                        cell: cell,
                        rowspan: row.rowspan+1,
                    });
                } else {
                    rows.push({
                        cell : cell,
                        rowspan: 1,
                    });
                }
            } else {
                rows.push({
                    cell : cell,
                    rowspan: 1,
                });
            }
        });
        var index = 0;
        $(rows).each(function(cell,item){
            $(nodes[index]).attr('rowspan',item.rowspan);
            for(var i = 1; i<item.rowspan;i++){
                $(nodes[index+i]).remove();
            }
            index += item.rowspan;
        });
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
				d.Arg2 = obj.Status;
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
	
	
	InitOccExpRemindWinEvent(obj);
	return obj;
}