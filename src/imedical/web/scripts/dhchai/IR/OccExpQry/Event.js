//页面Event
function InitOccExpQryWinEvent(obj){
	CheckSpecificKey();
	// 渲染checkbox
	$.form.CheckBoxRender();
	$.form.iCheckRender();  //渲染复选框|单选钮

	/*****搜索功能*****/
    $("#btnsearch").on('click', function(){
       $('#gridExpReg').DataTable().search($('#search').val(),true,true).draw();
       
    });
	
    $("#search").keyup(function(event){
        if (event.keyCode == 13) {
	        obj.gridExpReg.search(this.value).draw();
        }
    });
    
    //导出
    $("#btnExport").on('click', function () {
		obj.gridExpReg.buttons(0,null)[1].node.click();
	});
	
	new $.fn.dataTable.Buttons(obj.gridExpReg, {
		buttons: [
			{
				extend: 'csv',
				text:'导出'
			},
			{
				extend: 'excel',
				text:'导出',
				title:"职业暴露查询列表"
				,footer: true
				,exportOptions: {
					columns: ':visible'
					,width:50
					,orthogonal: 'export'
					/*,format: {
	                    body: function ( data, row, column, node ) {
	                        if(data.toString().startsWith("0")){
	                            return "\0" + data;
	                        }else {
		                    	return data.replace(/<[^>]+>/g, ""); 
		                    }
	                    }
	                }*/
				},
				customize: function( xlsx ) {
					var sheet = xlsx.xl.worksheets['sheet.xml'];
					
				}
			},
			{
				extend: 'print',
				text:'打印'
				,title:""
				,footer: true
			}
		]
	});
    
    $("#btnQuery").on('click', function(){
        var DateFrom 	= $("#DateFrom").val();
		var DateTo 		= $("#DateTo").val();
		//obj.gridExpReg.clear().draw();  //不需要，测试组出现过错行bug
		if(DateFrom > DateTo){
			layer.msg('开始日期应小于或等于结束日期！',{time: 2000,icon: 2});
			return;
		}
	    var mylayer = layer.load(1);
		obj.gridExpReg.ajax.reload(function ( json ){
			setTimeout(function(){
			  	layer.closeAll('loading');
			}, 100);
		    if (json.data.length==0){
				layer.msg('没有找到相关数据！',{time: 2000,icon: 2});
				return;
			}
		});
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
			  area: ['95%', '95%'],
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
	
	//操作明细
    $('#gridExpReg').on('click','a.btnOperation', function (e) {	  
		var tr = $(this).closest('tr');
		var row = obj.gridExpReg.row(tr);
		var rd = row.data();
		obj.RepID  = rd["ID"];
		obj.gridExpRepLog.ajax.reload();
		layer.open({
			type: 1,
			zIndex: 100,
			area: '800px',
			title:'操作明细',
			content: $('#layer_one')		
		});	
    });
}