//页面Event
function InitOccExpRegWinEvent(obj){
	$.form.iCheckRender();
	CheckSpecificKey();
	/*****搜索功能*****/
    $("#btnsearch").on('click', function(){
       $('#gridExpReg').DataTable().search($('#search').val(),true,true).draw();
       
    });
	
    $("#search").keyup(function(event){
        if (event.keyCode == 13) {
	        obj.gridExpReg.search(this.value).draw();
        }
    });
   /**********************/
    $('#gridExpReg').on('click','a.btnReprot', function (e) {	  
		var tr = $(this).closest('tr');
		var row = obj.gridExpReg.row(tr);
		var rd = row.data();
		var RepTypeID = rd["RegTypeID"];
		var ReportID  = rd["ID"];
	    var url = '../csp/dhchai.ir.occexpreport.csp?1=1&RegTypeID='+RepTypeID+'&ReportID='+ReportID+"&AdminPower="+obj.AdminPower+"&2=2"
		layer.open({
		      type: 2,
			  area: ['95%', '98%'],
			  closeBtn: 1,
			  title:'职业暴露报告',
			  fixed: false, //不固定
			  content: [url,'no'],
			  success: function(layero, index){
			  		$("div.layui-layer-content").css("padding-right","2px");
			  },
			  end: function () {
              	obj.gridExpReg.ajax.reload(null,false);
              }
		});

    });
    
    obj.gridExpReg.on('dblclick', 'tr', function(e) {
		var rd = obj.gridExpReg.row(this).data();
		var RepTypeID = rd["RegTypeID"];
		var ReportID  = rd["ID"];
	    var url = '../csp/dhchai.ir.occexpreport.csp?1=1&RegTypeID='+RepTypeID+'&ReportID='+ReportID+"&AdminPower="+obj.AdminPower+"&2=2"
		layer.open({
		      type: 2,
			  area: ['95%', '98%'],
			  closeBtn: 1,
			  title:'职业暴露报告',
			  fixed: false, //不固定
			  content: [url,'no'],
			  success: function(layero, index){
			  		$("div.layui-layer-content").css("padding-right","2px");
			  },
			  end: function () {
              	obj.gridExpReg.ajax.reload(null,false);
              }
		});
	    
	});
}