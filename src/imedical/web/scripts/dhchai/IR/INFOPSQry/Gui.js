var CHR_1 = String.fromCharCode(1);
var CHR_2 = String.fromCharCode(2);
//ҳ��Gui
function InitINFOPSQryWin(){
	var obj = new Object();
    obj.EpisodeID="";
    obj.ReportID="";
    var HospID=$.LOGON.HOSPID;
    
    $("#cboHospital").data("param",$.LOGON.HOSPID);	
	$.form.SelectRender("cboHospital");  //��Ⱦ������
	
    //��ʼ����ֵ
    $.form.DateTimeRender('DateFrom',$.form.GetCurrDate('-'));
    $.form.DateTimeRender('DateTo',$.form.GetCurrDate('-'));
    $.form.iCheckRender();
	$("#cboOperLocS").data("param",$.form.GetValue("cboHospital"));
	$.form.SelectRender("cboOperLocS");
	$.form.SelectRender("cboIncisionS");
	$.form.SelectRender("cboOperTypeS");
	$.form.SelectRender("cboInfPosS");
	
	//��ʼ���߶�
	var wh = $(window).height();
    $("#divLeft").height(wh-10);
    $("#divMain").height(wh-10);
	$("#divPanel").height(wh-65);
	$("#layer_one").height(wh-110);
	//����Ӧ�߶�
	$(window).resize(function(){
		var wh = $(window).height();
		$("#divLeft").height(wh-10);
		$("#divMain").height(wh-10);
		$("#divPanel").height(wh-65);
		$("#layer_one").height(wh-110);
	});
		
	var tableHeight = (($(window).height()-166) >400 ? ($(window).height()-166): 420);

	// �������鱨���б�
	obj.gridINFOPSQry = $("#gridINFOPSQry").DataTable({
		dom: 'rt<"row"<"col-sm-6"pl><"col-sm-6"i>>',
		paging: true,
		select: 'single',
		order: [[ 1, 'asc' ]],
		ordering: true,
		"iDisplayLength" : 10,
		"scrollX": true,
		"scrollY":tableHeight+'px',   //($(window).height()-167)+"px"�˴������趨���߶�ֵ
		info: true,
		ajax: {
			"url": "dhchai.query.datatables.csp",
			"data": function (d) {
				d.ClassName = "DHCHAI.IRS.INFOPSSrv";
				d.QueryName = "QryINFOPS";
				d.Arg1 =$("#DateFrom").val();
				d.Arg2 =$("#DateTo").val();
				d.Arg3 =$('#cboOperLocS').val();
				d.Arg4 =$('#cboIncisionS').val();
				d.Arg5 =$('#cboOperTypeS').val();
				d.Arg6 =$('#cboInfPosS').val();
				d.Arg7 =$('#txtOperDescS').val();
				d.Arg8 =$('#txtOperHours').val();
				d.Arg9 =$.form.GetValue("chkHospInfFlag");
				d.Arg10 =$.form.GetValue("chkCutInfFlag");
				d.Arg11 =$.form.GetValue("cboHospital");
				d.ArgCnt = 11;
			}
		},
		"columns": [
			{"data": "IsChecked", "targets": 0,orderable: false,
				"render": function (data, type, row) {
					if(data==1){
						return '<div class="icheckbox_square-blue checked" style="margin-top:4px"><input type="checkbox" style="opacity: 0;" checked></div>';
					}else{
						return '<div class="icheckbox_square-blue" style="margin-top:4px"><input type="checkbox" style="opacity: 0;"></div>';
					}
				}
			},
			{"data": "MrNo",render: function (data, type, row) {   //�����żӲ��ɼ��ַ������õ�������ӡ��ʽ
				return type == 'export' ?
				String.fromCharCode(2)+row.MrNo:data;
				}
			},
			{"data": "INFOPSID", 
				render: function (data, type, row ) {
					return '<a href="#" class="btnReport">'+data+'</a>';
				}
			},
			{"data": "RepStatus"},
			{"data": "PapmiNo",render: function (data, type, row) {   //�����żӲ��ɼ��ַ������õ�������ӡ��ʽ
				return type == 'export' ?
				String.fromCharCode(2)+row.PapmiNo:data;
				}
			},
			{"data": "PatName"},
			{"data": "Sex"},
			{"data": "Age"},
			{"data": "OperName"},
			{"data": "OperDate"},
			{"data": "OpertorName"},
			{"data": "OperLocDesc"},
			{"data": "AdmBed"},
			{"data": "RepUser"},
			{"data": "RepDate"},
			{"data": "UpdateDate"}
		]
		
	});
	// ����ҩ��
	obj.refreshgridINFAnti = function(){
		if(obj.gridINFAnti==undefined)
		{
			// ����ҩ����Ϣ
			obj.gridINFAnti = $("#gridINFAnti").DataTable({
				dom: 'rt',
				paging:false,
				select: 'single',
				ordering: false,
				ajax: {
					"url": "dhchai.query.datatables.csp",
					"data": function (d) {
						d.ClassName = "DHCHAI.IRS.INFAntiSrv";
						d.QueryName = "QryINFAntiByRep";
						d.Arg1 = obj.ReportID;
						d.Arg2 = '';
						d.ArgCnt = 2;
					}
				},
				columns: [
					{"data": "AntiDesc"}
					,{"data": "SttDate"}
					,{"data": "EndDate"}
					,{"data": "DoseQty"}
					,{"data": "DoseUnit"}
					,{"data": "PhcFreq"}
					,{"data": "MedUsePurpose"}
					,{"data": "AdminRoute"}
					,{"data": "MedPurpose"}
					,{"data": "TreatmentMode"}
					,{"data": "PreMedEffect"}
					,{"data": "PreMedIndicat"}
					,{"data": "CombinedMed"}
					,{"data": "PreMedTime"}
					,{"data": "PostMedDays"}
					,{"data": "SenAna"}
				]
			});
		}else{
			obj.gridINFAnti.ajax.reload(function(){});
		}
	}
	obj.refreshgridINFAnti();
	
	InitINFOPSQryWinEvent(obj);
	return obj;
}