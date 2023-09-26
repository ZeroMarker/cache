//ҳ��Event
function InitOccExpQryWinEvent(obj){
	CheckSpecificKey();
	// ��Ⱦcheckbox
	$.form.CheckBoxRender();
	$.form.iCheckRender();  //��Ⱦ��ѡ��|��ѡť

	/*****��������*****/
    $("#btnsearch").on('click', function(){
       $('#gridExpReg').DataTable().search($('#search').val(),true,true).draw();
       
    });
	
    $("#search").keyup(function(event){
        if (event.keyCode == 13) {
	        obj.gridExpReg.search(this.value).draw();
        }
    });
    
    //����
    $("#btnExport").on('click', function () {
		obj.gridExpReg.buttons(0,null)[1].node.click();
	});
	
	new $.fn.dataTable.Buttons(obj.gridExpReg, {
		buttons: [
			{
				extend: 'csv',
				text:'����'
			},
			{
				extend: 'excel',
				text:'����',
				title:"ְҵ��¶��ѯ�б�"
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
				text:'��ӡ'
				,title:""
				,footer: true
			}
		]
	});
    
    $("#btnQuery").on('click', function(){
        var DateFrom 	= $("#DateFrom").val();
		var DateTo 		= $("#DateTo").val();
		//obj.gridExpReg.clear().draw();  //����Ҫ����������ֹ�����bug
		if(DateFrom > DateTo){
			layer.msg('��ʼ����ӦС�ڻ���ڽ������ڣ�',{time: 2000,icon: 2});
			return;
		}
	    var mylayer = layer.load(1);
		obj.gridExpReg.ajax.reload(function ( json ){
			setTimeout(function(){
			  	layer.closeAll('loading');
			}, 100);
		    if (json.data.length==0){
				layer.msg('û���ҵ�������ݣ�',{time: 2000,icon: 2});
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
    
    obj.gridExpReg.on('dblclick', 'tr', function(e) {
		var rd = obj.gridExpReg.row(this).data();
		var RepTypeID = rd["RegTypeID"];
		var ReportID  = rd["ID"];
	    var url = '../csp/dhchai.ir.occexpreport.csp?1=1&RegTypeID='+RepTypeID+'&ReportID='+ReportID+"&AdminPower="+obj.AdminPower+"&2=2"
		layer.open({
		      type: 2,
			  area: ['95%', '95%'],
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
	
	//������ϸ
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
			title:'������ϸ',
			content: $('#layer_one')		
		});	
    });
}