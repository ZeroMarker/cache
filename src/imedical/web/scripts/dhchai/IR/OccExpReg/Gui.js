//ҳ��Gui
function InitOccExpRegWin(){
	var obj = new Object();
	
	obj.AdminPower  = '0';
	if (typeof tDHCMedMenuOper != 'undefined')
	{
		if (typeof tDHCMedMenuOper['Admin'] != 'undefined')
		{
			obj.AdminPower  = tDHCMedMenuOper['Admin'];
		}
	}
	 obj.GroupDesc =session['LOGON.GROUPDESC'];
	var SupNurFlg = 0;
    var SupDocFlg = 0;
    if (obj.GroupDesc.indexOf('��ʿ��')>-1) {
	    SupNurFlg = 1;
    }
    if (obj.GroupDesc.indexOf('����')>-1) {
	    SupDocFlg = 1
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
			$("#tab-button").append('<a class="tabbtn" text="'+ RepID+ '"  href="#"><img src="../scripts/dhchai/img/'+ imgType+ '.png"><span>'+RepType+'</span></a>');
		}
	}
	$('#tab-button > a').click(function (e) {
		var RepID = $(this).attr('text');
		var flag = $.Tool.RunQuery("DHCHAI.IRS.OccExpTypeSrv","QryOccExpTypeExt",RepID);
		var len = flag.record.length;
		if(len!=0){
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
	   	}else{
		 	layer.msg('��¶��ĿΪ�գ��벿��!',{icon: 2});
			return false;
		 }

	});
	
	//���ÿ�ʼ����Ϊ����1��
	var currDate = $.form.GetCurrDate('-');
	var arrDate = currDate.split('-');
	var dateFrom = arrDate[0] + "-" + arrDate[1] + "-01"
   
	obj.gridExpReg = $("#gridExpReg").DataTable({
		dom: 'rt<"row"<"col-sm-6 col-xs-6"pl><"col-sm-6 col-xs-6"i>>',
		select: 'single',
		paging: true,
		ordering: true,
		info: true,
		ajax: {
			"url": "dhchai.query.datatables.csp",
			"data": function (d) {
				d.ClassName = "DHCHAI.IRS.OccExpRegSrv";
				d.QueryName = "QryExpRegInfo";
				if ((obj.AdminPower==1)||(SupNurFlg==1)||(SupDocFlg==1)) {
					d.Arg1 ="";
				}else {
					d.Arg1 = $.LOGON.USERID;
				}
				d.Arg2 = $.LOGON.LOCID;
				d.ArgCnt = 2;
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
			{"data": "RegUserDesc"},
			{"data": "Name"},
			{"data": "RegNo"},
			{"data": "Sex"},
			{"data": "WorkAge"},
			{"data": "Duty"},
			{"data": "ExpDate"},
			{"data": "ExpTime"},
			{"data": "RegDate"},
			{"data": "RegTime"}
		]
		,"aaSorting": [
			[0, "desc" ]
		]
	
	});
	
	$("body").mCustomScrollbar({
		theme: "dark-thick",
		axis: "y",
		scrollInertia: 100
	});
	
	InitOccExpRegWinEvent(obj);
	return obj;
}