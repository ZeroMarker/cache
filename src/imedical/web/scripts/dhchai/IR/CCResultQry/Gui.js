//页面Gui
function InitPatFindWin(){
	var obj = new Object();
	//初始化赋值
    $("#cboHospital").data("param",$.LOGON.HOSPID);	
	$.form.SelectRender("#cboHospital");  //渲染下拉框	
	$("#cboHospital option:selected").next().attr("selected", true)
	$("#cboHospital").select2();
	$("#cboLocation").data("param",$.form.GetValue("cboHospital")+"^^I|E^E^1");
	$.form.SelectRender("cboLocation");  //渲染下拉框
	$.form.SelectRender("cboItems");  //渲染下拉框
	$.form.iCheckRender();
	$("#cboItems").select2({
		multiple: true
		,placeholder: "--请选择--",
		placeholderOption: "first",
		allowClear: true
	});
	//给select2赋值change事件
	$("#cboHospital").on("select2:select", function (e) { 
		//获得选中的医院
		var data= e.params.data;
		var id = data.id;
		var text =data.text;
		$("#cboLocation").data("param",id+"^^I|E^E^1");
		$.form.SelectRender("cboLocation");  //渲染下拉框			
	
	});	
    $.form.DateTimeRender('DateFrom');
    $.form.DateTimeRender('DateTo');

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
	/*
    $("#divPanel").mCustomScrollbar({
		//scrollButtons: { enable: true },
		//autoHideScrollbar: true,
		theme: "dark-thick",
		axis: "y",
		scrollInertia: 100
	});*/
	/*
	$('body').mCustomScrollbar({
		theme : "minimal-dark",
		scrollInertia : 100
	});
	*/
	
	//就诊列表
	obj.gridAdm = $("#gridAdm").DataTable({
		dom: 'rt<"row"<"col-sm-6 col-xs-6"pl><"col-sm-6 col-xs-6"i>>',
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
				var DateType	= $.form.GetValue("ItemsAnd");  //逻辑关系
				var DateFrom 	= $("#DateFrom").val();
				var DateTo 		= $("#DateTo").val();
				var LocationID  = $("#cboLocation").val();
				//reslist=$("#c01-select").select2("data");    
				var reslist	 	= $("#cboItems").select2("data");
				var Items = "";
				
				for(var i = 0;i<reslist.length;i++){
					var dataObj = reslist[i];
					var id = dataObj.id;
					if(id!="")
					{
						if(Items=="")
						{
							Items = id;
						}
						else
						{
							Items = Items +"|"+id;
						}
					}
				}
				//alert(DateType+"----"+Items);
				d.ClassName = "DHCHAI.IRS.CCResultSrv";
				d.QueryName = "QryResultPatList";
				d.Arg1 =DateType;
				d.Arg2 =DateFrom;
				d.Arg3 =DateTo;
				d.Arg4 =LocationID
				d.Arg5 =HospIDs;				
				d.Arg6 =Items;
				d.ArgCnt = 6;
			}
		},
		"columns": [
			{
				"data": "RegNo"
				,render:function(data, type, row)
				{
					return type === 'export' ?
								String.fromCharCode(2)+data:data;
				}
			},
			{"data": "PatName"},
			{"data": "Sex"},
			{"data": "Age"},			
			{
			"data": null,
				render: function ( data, type, row ) {
				return '<a href="#" class="zy">摘要</a>';
				}
			},
			{"data": "CurrLocDesc"},
			{"data": "CurrBed"},			
			{"data": "IsNeedAtt", 
				render: function ( data, type, row ) {
					if (data=="1"){
						return '是';
					}else{
						return '否'
					}
				}
			},
			{"data": "SuspendDesc"},
			{"data": "CCItemDesc"},			
			{"data": "CCActDate"},
			{"data": "CCResult"}
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
