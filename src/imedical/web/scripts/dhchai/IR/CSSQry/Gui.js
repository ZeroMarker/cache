//页面Gui
function InitPatFindWin(){
	var obj = new Object();
	
	//初始化赋值
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
		$("#cboLocation").data("param",id+"^^I|E^E^1");
		$.form.SelectRender("cboLocation");  //渲染下拉框
		$("#cboSurvNumber").data("param","^"+id+"^1");
		$.form.SelectRender("cboSurvNumber");  //渲染下拉框
	});	
	$("#cboLocation").data("param",$.form.GetValue("cboHospital")+"^^I|E^E^1");
	$.form.SelectRender("cboLocation");  //渲染下拉框
	$("#cboSurvNumber").data("param","^"+$.form.GetValue("cboHospital")+"^1");
	$.form.SelectRender("#cboSurvNumber");  //渲染下拉框	
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
		//scrollButtons: { enable: true },
		//autoHideScrollbar: true,
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
	
	
	//就诊列表
	obj.gridAdm = $("#gridAdm").DataTable({
		dom: 'rt<"row"<"col-sm-6"pl><"col-sm-6"i>>',
		paging: true,
		ordering: true,
		info: true,
		"deferRender": true,
		"processing" : true,
		"scrollX": true,
		"scrollY": true,  //"380px",  //或者固定高度 75vh 代表容器百分比
        // "scrollCollapse": true,
		ajax: {
			"url": "dhchai.query.datatables.csp",
			"data": function (d) {
				var HospIDs 	= $("#cboHospital").val();
				var LocationID  = $("#cboLocation").val();
				var SEID	 	= $("#cboSurvNumber").val();
				var PatName 	= "";
				var PapmiNo 	= "";  //$("#txtPapmiNo").val()
				var MrNo 		= "";
				var aInputs = HospIDs+'^'+LocationID+'^'+SEID+'^'+PatName+'^'+PapmiNo+'^'+MrNo;
				d.ClassName = "DHCHAI.IRS.INFCSSSrv";
				d.QueryName = "QryAdm";
				d.Arg1 =aInputs;
				d.ArgCnt = 1;
			}
		},
		"columns": [			
			{"data": "EpisodeIDx"},
			{"data":"AdmTimes"},
			{"data":"AdmWardDesc"},
			{
				"data": "PapmiNo"
				,render:function(data, type, row)
				{
					return type === 'export' ?
								String.fromCharCode(2)+data:data;
				}
			},
			{
				"data": "MrNo"
				,render:function(data, type, row)
				{
					return type === 'export' ?
								String.fromCharCode(2)+data:data;
				}
			},
			{"data": "PatName"},
			{"data": "Sex"},
			{"data": "Age"},
			{"data": "IdentityCode"
				,render:function(data, type, row)
				{
					return type === 'export' ?
								String.fromCharCode(2)+data:data;
				}
			},
			{
			"data": null,
				render: function ( data, type, row ) {
				return '<a href="#" class="zy">摘要</a>';
				}
			},
			{
			"data": null,
				render: function ( data, type, row ) {
					var txt = "调查";
					if(data.RepID!="")
					{
						txt = data.RepID;
					}
				return '<a href="#" class="btnReprot">'+txt+'</a>';
				}
			}
			,{"data":"AllDiag"}
			,{"data":"OBSCnt", 
				"render": function (data, type, row) {
					return (data == '1' ? '是' : '否');
				}}
			,{"data":"InfPosDescs"}
			,{"data":"IRAntiFlag", 
				"render": function (data, type, row) {
					return (data == '1' ? '是' : '否');
				}}
			,{"data":"PurposeDesc"}
			,{"data":"CombinDesc"}
			,{"data":"IRAntiSenFlag", 
				"render": function (data, type, row) {
					return (data == '1' ? '是' : '否');
				}}
			,{"data":"OperFlag", 
				"render": function (data, type, row) {
					return (data == '1' ? '是' : '否');
				}}
			,{"data":"CuteType"}
			,{"data":"AdmDate"}
			,{"data":"DischDate"}			
		]
		,"fnDrawCallback": function (oSettings) {
			$("#gridAdm_wrapper .dataTables_scrollBody").mCustomScrollbar({
				theme : "dark-thick",
				axis: "xy",
				callbacks:{
					whileScrolling:function(){
						$('#gridAdm_wrapper .dataTables_scrollHead').scrollLeft(-this.mcs.left); 
					}
				}
			});			
			$("#gridAdm_wrapper .dataTables_scrollBody").mCustomScrollbar("scrollTo",$("#gridAdm tr td:first"));
        	getContentSize();
        }
	});
	function getContentSize() {
    	var wh = document.documentElement.clientHeight; 
   		var eh = 166;
    	var ch = (wh - eh) + "px";
    	obj1 = document.getElementById("mCSB_3");
    	var dh=$('div.dataTables_scrollHead').height();
    	var sh=(wh - eh + dh )+ "px"; 
    	if (obj1){  
   			obj1.style.height = ch;
    	}else {
	   		$('div.dataTables_scrollBody').css('height',sh);
    	}
	}
	InitPatFindWinEvent(obj);
	obj.LoadEvents(arguments);
	return obj;
}
