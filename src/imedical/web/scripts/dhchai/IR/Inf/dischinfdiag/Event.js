function InitDischDiagWinEvent(obj){
	CheckSpecificKey();

	//��ֵ��ʼֵ
    $("#cboHospital").data("param",$.LOGON.HOSPID);	
	$.form.SelectRender("#cboHospital");  //��Ⱦ������	
	$("#cboHospital option:selected").next().attr("selected", true)
	$("#cboHospital").select2();
	// ��select2��ֵchange�¼�
	$("#cboHospital").on("select2:select", function (e) { 
		// ���ѡ�е�ҽԺ
		var data= e.params.data;
		var id = data.id;
		var text =data.text;
		$("#cboLocation").data("param",id+"^^I^E^1");
		$.form.SelectRender("cboLocation");  //��Ⱦ������	
		$("#cboInfLocation").data("param",id+"^^I^E^1");
		$.form.SelectRender("cboInfLocation");  //��Ⱦ������	
	});	
	$("#cboLocation").data("param",$.form.GetValue("cboHospital")+"^^I^E^1");
	$.form.SelectRender("cboLocation");  //��Ⱦ������
	$("#cboInfLocation").data("param",$.form.GetValue("cboHospital")+"^^I^E^1");
	$.form.SelectRender("cboInfLocation");
	$.form.SelectRender("#cboStatus");
	
	/*****��������*****/
	$("#btnsearch").on('click', function(){
	   $('#gridDischDiag').DataTable().search($('#search').val(),true,true).draw();
	   
	});

	$("#search").keyup(function(event){
	    if (event.keyCode == 13) {
	        obj.gridDischDiag.search(this.value).draw();
	    }
	});
	refreshgridDischDiag();
	/****************/
    //��ѯ��ť
    $("#btnQuery").on('click', function(){
		var DateFrom = $.form.GetValue("DateFrom");
		var DateTo   = $.form.GetValue("DateTo");
		if ((DateFrom == '')||(DateTo=='')) {
			layer.alert('��Ժ���ڲ�����Ϊ��!',{icon: 0});
			return ;
		}
		//add
		if(DateFrom>DateTo){
			layer.alert('��ʼ���ڲ�������ڽ�������!',{icon: 0});
			return ;	
		}
		//end
	   if(obj.gridDischDiag){                                      //��գ���refreshgridDischDiag()��ʼ����񣬷�ֹ���ݹ����ѱ��ſ���������ȥ
		    $("#gridDischDiag_wrapper .dataTables_scrollBody").mCustomScrollbar("destroy");
		    $("#gridDischDiag").dataTable().fnDestroy();
		    obj.gridDischDiag=null;
		    refreshgridDischDiag();
	    }else{
			refreshgridDischDiag();
	    }
	});
    $("#txtMrNo").keyup(function(event){
	    if (event.keyCode == 13) {
	        $("#btnQuery").click();
	    }
	});
     //����
    $("#btnExport").on('click', function(){
		obj.gridDischDiag.buttons(0,null)[0].node.click();
	});
	
	$('#gridDischDiag').on('dblclick', 'tr', function(e) {
		return ;
	});
	
	function refreshgridDischDiag()
	{
		if(obj.gridDischDiag==null)
		{
			//��Ժ��Ⱦ����б�
			obj.gridDischDiag = $("#gridDischDiag").DataTable({
				dom: 'rt<"row"<"col-sm-6 col-xs-6"pl><"col-sm-6 col-xs-6"i>>',
				paging: true,
				ordering: true,
				info: true,
				"bAutoWidth": false,	//add
				"iDisplayLength" : 50,
				"autoWidth": false,
				"processing" : true,
				"scrollX": true,
				"scrollY":($(window).height()-165)+"px",//true, //�˴������趨���߶�ֵ
				//"scrollY":"410px",
				ajax: {
					"url": "dhchai.query.datatables.csp",
					"data": function (d) {
						d.ClassName = "DHCHAI.IRS.INFDiagnosSrv";
						d.QueryName = "QryDischInfDiag";
						d.Arg1 =$.form.GetValue("cboHospital"); //ҽԺ
						d.Arg2 =$("#DateFrom").val();
						d.Arg3 =$("#DateTo").val();
						d.Arg4 =$.form.GetValue("cboLocation");
						d.Arg5 =$.form.GetValue("cboStatus");
						d.Arg6 =$.form.GetValue("txtMrNo");  //������
						d.ArgCnt = 6;
					}
				},
				"columns": [
					{
						"data": "MrNo"
						,render: function (data, type, row) {
							return type === 'export' ?
								String.fromCharCode(2)+data:data;
						}
					},
					{"data": "PatName"},
					{"data": "Sex"},
					{"data": "Age"},
					{"data": "AdmLocDesc"},
					{"data": "ActStatus"},
					{"data": null,   // ����
						render: function ( data, type, row ) {
							return '<a href="#" class="qz">ȷ��</a>&nbsp;&nbsp;<a href="#" class="ys">����</a>&nbsp;&nbsp;<a href="#" class="pc">�ų�</a>';
						}
					},
					//{"data": "ActOpinion"},   
					{"data": "InfDiagList"},
					{"data": null,
						render: function ( data, type, row ) {
							return '<a href="#" class="zy">ժҪ</a>';
						}
					},
					{"data": null,
						render: function ( data, type, row ) {
							return '<a href="#" class="Emr_Record">���Ӳ���</a>';
						}
					},
					{"data": "InfPosDesc",
						render: function ( data, type, row ) {
							if (data==""){
								return '<a href="#" class="btnReprot">�½�</a>';
							}else{
								return data;
							}
							 
						}
					},
					//{"data": "IRInfDate"},
					{"data": "DischDate"}
				],"fnDrawCallback": function (oSettings) {
					$("#gridDischDiag_wrapper .dataTables_scrollBody").mCustomScrollbar({
						theme : "dark-thick",
						axis: "xy",
						callbacks:{
							whileScrolling:function(){
								$('#gridDischDiag_wrapper .dataTables_scrollHead').scrollLeft(-this.mcs.left); 
							}
						}
					});			
					$("#gridDischDiag_wrapper .dataTables_scrollBody").mCustomScrollbar("scrollTo",$("#gridDischDiag tr td:first"));
		        }
					
			});
			
			new $.fn.dataTable.Buttons(obj.gridDischDiag, {
				buttons: [					
					{
						extend: 'excel',
						text:'����',
						title:"��Ժ��Ⱦ��ϲ�ѯ"
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
				]
			});
		} else {
			obj.gridDischDiag.ajax.reload( function ( json ) {
				setTimeout(function(){
				  	layer.closeAll('loading');
				}, 100);
			    if (json.data.length==0){
					layer.msg('û���ҵ�������ݣ�',{time: 2000,icon: 2});
					return;
				}
			});
		}
	}
	// �½�Ժ�б���
    $('#gridDischDiag').on('click','a.btnReprot', function (e) {
	    e.preventDefault();
		var tr = $(this).closest('tr');
		var row = obj.gridDischDiag.row(tr);
		var rowData = row.data();	
		
		var EpisodeID = rowData.EpisodeDr;
		var IsNewBaby = rowData.IsNewBaby;
      
        if (IsNewBaby==1) {
	        var url = '../csp/dhcma.hai.ir.inf.nreport.csp?EpisodeID='+EpisodeID+'&1=1';
			websys_showModal({
				url:url,
				title:'������ҽԺ��Ⱦ����',
				iconCls:'icon-w-epr',  
				originWindow:window,
				closable:false,
				width:1320,
				height:'95%',
				onBeforeClose:function(){
					obj.gridDischDiag.ajax.reload(null,false);
				} 
			});
        }else {
			var url = '../csp/dhcma.hai.ir.inf.report.csp?EpisodeID='+EpisodeID+'&1=1';
			websys_showModal({
				url:url,
				title:'ҽԺ��Ⱦ����',
				iconCls:'icon-w-epr',  
				originWindow:window,
				closable:false,
				width:1320,
				height:'95%',
				onBeforeClose:function(){
					obj.gridDischDiag.ajax.reload(null,false);
				} 
			});

        }
        obj.gridDischDiag.ajax.reload(null, false);		//add
    });
    $('#gridDischDiag').on('click','a.Emr_Record', function (e) {
	    e.preventDefault();
		var tr = $(this).closest('tr');
		var row = obj.gridDischDiag.row(tr);
		var rowData = row.data();
		var EpisodeID = rowData.EpisodeDr;
		obj.btnEmrRecord_Click(EpisodeID);
    });		
	obj.btnEmrRecord_Click = function(EpisodeID)
	{		
	    var rst = $.Tool.RunServerMethod("DHCHAI.DPS.PAAdmSrv","GetPaAdmHISx",EpisodeID);
		if(rst=="")return;
		var EpisodeID = rst.split("^")[0];
		var PatientID = rst.split("^")[1];
		var url = cspUrl+'&PatientID=' + PatientID+'&EpisodeID='+EpisodeID + '&2=2';
		//var url = '../csp/emr.record.browse.csp?PatientID=' + PatientID+'&EpisodeID='+EpisodeID + '&2=2';
		showFullScreenDiag(url,"�������",1);
        /*
		parent.layer.open({
		      type: 2,
			  area: ['95%', '95%'],
			  title:false,
			  closeBtn:1,
			  fixed: false, //���̶�
			  maxmin: false,
			  maxmin: false,
			  content: [url,'no']
		});
		*/
	};
	// ժҪ
    $('#gridDischDiag').on('click','a.zy', function (e) {
	    e.preventDefault();
		var tr = $(this).closest('tr');
		var row = obj.gridDischDiag.row(tr);
		var rowData = row.data();	
		
		var EpisodeID = rowData.EpisodeDr;
		var url = '../csp/dhchai.ir.view.main.csp?PaadmID='+EpisodeID+'&1=1';
		/*parent.layer.open({
		      type: 2,
			  area: ['95%', '95%'],
			  title:false,
			  closeBtn:0,
			  fixed: false, //���̶�
			  maxmin: false,
			  maxmin: false,
			  content: [url,'no']
		});*/
		showFullScreenDiag(url,"");
    });	
    // ȷ��
    $('#gridDischDiag').on('click','a.qz', function (e) {
	    e.preventDefault();
		var tr = $(this).closest('tr');
		var row = obj.gridDischDiag.row(tr);
		var rowData = row.data();
		var EpisodeDr = rowData.EpisodeDr;
		
		var InputStr  = EpisodeDr;
		InputStr += "^" + "1";             // ����״̬ ȷ��
		InputStr += "^" + "";              // �������
		InputStr += "^" + $.LOGON.USERID;  // ������
		
		var retval = $.Tool.RunServerMethod("DHCHAI.IRS.CCDiagnosSrv","SaveCCDiagnos",InputStr,"^");
		if (parseInt(retval)>0){
			layer.msg('ȷ��ɹ�!',{time: 1000,icon: 1});
			$(this).parent().prev().html("ȷ��");
			//obj.gridDischDiag.ajax.reload(function(){},false);
		} else {
			layer.msg('ȷ��ʧ��!',{icon: 2});
		}
    });	
    // ����
    $('#gridDischDiag').on('click','a.ys', function (e) {
	    e.preventDefault();
		var tr = $(this).closest('tr');
		var row = obj.gridDischDiag.row(tr);
		var rowData = row.data();	
		var EpisodeDr = rowData.EpisodeDr;
		
		var InputStr  = EpisodeDr;
		InputStr += "^" + "2";             // ����״̬ ����
		InputStr += "^" + "";              // �������
		InputStr += "^" + $.LOGON.USERID;  // ������
		
		var retval = $.Tool.RunServerMethod("DHCHAI.IRS.CCDiagnosSrv","SaveCCDiagnos",InputStr,"^");
		if (parseInt(retval)>0){
			layer.msg('���Ƴɹ�!',{time: 1000,icon: 1});
			$(this).parent().prev().html("����");
			//obj.gridDischDiag.ajax.reload(function(){},false);
		} else {
			layer.msg('����ʧ��!',{icon: 2});
		}
		
    });	
    // �ų�
    $('#gridDischDiag').on('click','a.pc', function (e) {
	    e.preventDefault();
		var tr = $(this).closest('tr');
		var row = obj.gridDischDiag.row(tr);
		var rowData = row.data();	
		var EpisodeDr = rowData.EpisodeDr;
		
		var InputStr  = EpisodeDr;
		InputStr += "^" + "3";             // ����״̬ �ų�
		InputStr += "^" + "";              // �������
		InputStr += "^" + $.LOGON.USERID;  // ������
		
		var retval = $.Tool.RunServerMethod("DHCHAI.IRS.CCDiagnosSrv","SaveCCDiagnos",InputStr,"^");
		if (parseInt(retval)>0){
			layer.msg('�ų��ɹ�!',{time: 1000,icon: 1});
			$(this).parent().prev().html("�ų�");
			//obj.gridDischDiag.ajax.reload(function(){},false);
		} else {
			layer.msg('�ų�ʧ��!',{icon: 2});
		}
    });	
}