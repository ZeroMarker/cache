//ҳ��Gui
function InitCtlResultWin(){
	var obj = new Object();
    obj.ResultID="";
    //��ʼ����ֵ
    $("#cboHospital").data("param",$.LOGON.HOSPID);	
	$.form.SelectRender("#cboHospital");  //��Ⱦ������
	$("#cboHospital option:selected").next().attr("selected", true)
	$("#cboHospital").select2();
	//��select2��ֵchange�¼�
	$("#cboHospital").on("select2:select", function (e) { 
		//���ѡ�е�ҽԺ
		var data= e.params.data;
		var id = data.id;
		var text =data.text;
		$("#cboLocation").data("param",id+"^^I|E^W^1");
		$.form.SelectRender("cboLocation");  //��Ⱦ������
		$("#cboWard").data("param",id+"^^I|E^W^1");
		$.form.SelectRender("cboWard");  //��Ⱦ������		
	});	
	$.form.SelectRender("#cboDateType");
	$("#cboLocation").data("param",$.form.GetValue("cboHospital")+"^^I|E^W^1");
	$.form.SelectRender("cboLocation");  //��Ⱦ������	
	$("#cboWard").data("param",$.form.GetValue("cboHospital")+"^^I|E^W^1");
	$.form.SelectRender("cboWard");  //��Ⱦ������
	$.form.SelectRender('cboInfType');
	$.form.SelectRender('cboMakeInfType');		
	//$.form.SelectRender('cboBacteria');	
	$.form.SelectRender('cboMRBBact');	
   
   	if (HomeFlag=='1'){
		$("#divLeft").hide();
	}else{
		HomeFlag=false;
	}
   	
    $.form.DateTimeRender('DateFrom',$.form.GetCurrDate('-'));
    $.form.DateTimeRender('DateTo',$.form.GetCurrDate('-'));
    
	//��ҩ���б�
	obj.gridCtlResult = $("#gridCtlResult").DataTable({
		dom: 'rt<"row"<"col-sm-6 col-xs-6"pl><"col-sm-6 col-xs-6"i>>',
		select: 'single',
		paging: true,
		ordering: true,
		info: true,
		"iDisplayLength" : 50,
		"autoWidth": false,
		"scrollX": true,
		"scrollY":true,   //�˴������趨���߶�ֵ
		ajax: {
			"url": "dhchai.query.datatables.csp",
			"data": function (d) {
				d.ClassName = "DHCHAI.IRS.CtlMRBSrv";
				d.QueryName = "QryMRBResult";
				d.Arg1 =HomeFlag?$.LOGON.HOSPID:$("#cboHospital").val();
				d.Arg2 =HomeFlag?2:$("#cboDateType").val();
				d.Arg3 =HomeFlag?aHomeDateFrom:$("#DateFrom").val();
				d.Arg4 =HomeFlag?aHomeDateTo:$("#DateTo").val();
				//d.Arg5 =(tDHCMedMenuOper['Admin']==1)?$("#cboLocation").val():$.LOGON.XLocID;
				d.Arg5 =(tDHCMedMenuOper['Admin']==1)?$("#cboLocation").val():$.LOGON.LOCID;
				d.Arg6 =$("#cboInfType").val();
				d.Arg7 ="";
				d.Arg8 =$("#cboMRBBact").val();
				d.Arg9 =$("#cboWard").val();
				d.ArgCnt = 9;
			}
		},
		"columns": [		
			{"data": "MrNo",render: function (data, type, row) {   //�����żӲ��ɼ��ַ������õ�������ӡ��ʽ
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
			{"data": "MakeInfType", 
				render: function ( data, type, row ) {
					if (data!=""){
						return '<a href="#" class="btnEdit">'+data+'</a>';
					}else{
						return '<a href="#" class="btnEdit">���</a>';
					}
				}
			},
			{"data": null, 
				render: function ( data, type, row ) {
					return '<a href="#" class="btnLabSen">ҩ�����</a>';
				}
			},
			{
				"data": null,
				render: function ( data, type, row ) {
					var editHtml = '<a href="#" class="abstract_msg">ժҪ</a>';
					return editHtml;
				}
			},
			{
				"data": null,
				render: function ( data, type, row ) {
					var editHtml = '<a href="#" class="screen_single">����ɸ��</a>';
					return editHtml;
				}
			},
			{"data": "INFMBRID", 
				render: function ( data, type, row ) {
					var ReportID=data;
					if ((ReportID!="")&(ReportID!=undefined)){
						return '<a href="#" class="btnReprot">'+ReportID+'</a>';
					}else {
						return '<a href="#" class="btnReprot">�½�</a>';
					}
				}
			},
			{"data": null, 
				render: function ( data, type, row ) {
					if (tDHCMedMenuOper['Admin'] != '1') {
						return '';
					} else {
					return '<a href="#" class="btnMRBMsg">������Ϣ</a>';
					}
				}
			},
			{"data": "Specimen"},
			{"data": "Bacteria"},
			{"data": "ActDate"},
			{"data": "ISOOrdDesc"},
			{"data": "ISOSttDate"},
			{"data": "RepDate"},
			{"data": "LocDesc"},
			{"data": "LabWardDesc"},
			{"data": "DischDate",
				render: function ( data, type, row ) {
					var editHtml = data+"&nbsp&nbsp&nbsp";
					return editHtml; 
				}
			}	
			
		],
		"createdRow": function ( row, data, index ) {
			if ( data.IsByHand=="1") {
				$('td', row).eq(6).css('background-color','#FFB5C5');
			}
		},
		"columnDefs": [
			{ 
				"type": "date-euro", 
				targets: [4,14,16,17,20] 	//������/��/����������ʱ������
			}
        ]
		,"fnDrawCallback": function (oSettings) {
			$("#gridCtlResult_wrapper .dataTables_scrollBody").mCustomScrollbar({
				theme : "dark-thick",
				axis: "xy",
				callbacks:{
					whileScrolling:function(){
						$('#gridCtlResult_wrapper .dataTables_scrollHead').scrollLeft(-this.mcs.left); 
					}
				}
			});			
			$("#gridCtlResult_wrapper .dataTables_scrollBody").mCustomScrollbar("scrollTo",$("#gridCtlResult tr td:first"));
			getContentSize();
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
	
	//��ʼ���߶�
	var wh = $(window).height();
    $("#divLeft").height(wh-10);
	$("#divPanel").height(wh-65);
	$("#divMain").height(wh);
	//����Ӧ�߶�
	$(window).resize(function(){
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
	
	InitCtlResultWinEvent(obj);
	return obj;
}