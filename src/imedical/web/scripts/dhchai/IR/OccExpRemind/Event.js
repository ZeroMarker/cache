//ҳ��Event
function InitOccExpRemindWinEvent(obj){
	CheckSpecificKey();
	// ��Ⱦcheckbox
	$.form.CheckBoxRender();
	$.form.iCheckRender();  //��Ⱦ��ѡ��|��ѡť

	/*****��������*****/
    $("#btnsearch").on('click', function(){
       $('#gridExpRemind').DataTable().search($('#search').val(),true,true).draw();
       
    });
	
    $("#search").keyup(function(event){
        if (event.keyCode == 13) {
	        obj.gridExpRemind.search(this.value).draw();
        }
    });
	
	//����
    $("#btnExport").on('click', function(){
		obj.gridExpRemind.buttons(0,null)[0].node.click();
	});
    
    $("#btnQuery").on('click', function(){
        var DateFrom 	= $("#DateFrom").val();
		var DateTo 		= $("#DateTo").val();
		obj.gridExpRemind.clear().draw();
		if(DateFrom > DateTo){
			layer.msg('��ʼ����ӦС�ڻ���ڽ������ڣ�',{time: 2000,icon: 2});
			return;
		}
		
		var DateType =$.form.GetValue("cboDateType");
		/*
		var currDate = $.form.GetCurrDate('-');
		if (DateType ==1) {
			if ($.form.DateDiff(DateTo,currDate)>AftDay) {
    			layer.msg('�����Ѳ�ѯ�������ڲ����ڵ�ǰ����'+AftDay+'��֮��!',{time: 2000,icon: 2});
				return ;
    		}
    		if ($.form.DateDiff(currDate,DateFrom)>PerDay) {
    			layer.msg('�����Ѳ�ѯ��ʼ���ڲ�Ӧ�ڵ�ǰ����'+PerDay+'��֮ǰ!',{time: 2000,icon: 2});
				return ;
    		}
		}
		*/
	    var mylayer = layer.load(1);
		obj.gridExpRemind.ajax.reload(function ( json ){
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
    $('#gridExpRemind').on('click','a.btnRemind', function (e) {	  //����
		var tr = $(this).closest('tr');
		var row = obj.gridExpRemind.row(tr);
		var rd = row.data();
	    var ReportID  = rd["ID"];
	    var LabTimList = rd["LabTimList"];
	   
		var StatusDr = $.Tool.RunServerMethod("DHCHAI.BT.Dictionary","GetIDByCode","OERegStatus",11);		
		var Opinion  = '������'+"#"+LabTimList;
		var InputRegLog = ReportID;
		InputRegLog = InputRegLog + "^" + '';
		InputRegLog = InputRegLog + "^" + StatusDr;		//״̬
		InputRegLog = InputRegLog + "^" + Opinion;
		InputRegLog = InputRegLog + "^" + '';
		InputRegLog = InputRegLog + "^" + '';
		InputRegLog = InputRegLog + "^" + $.LOGON.USERID;
		
		var retval = $.Tool.RunServerMethod("DHCHAI.IR.OccExpRegLog","Update",InputRegLog);
		if(parseInt(retval)>0) {
			obj.gridExpRemind.ajax.reload(null,false);
	        layer.msg('���ѳɹ���',{time: 2000,icon: 1});
        }else{
			layer.msg('����ʧ�ܣ�',{time: 2000,icon: 2});
		}
		
    });
    
    obj.gridExpRemind.on('dblclick', 'tr', function(e) {
		var rd = obj.gridExpRemind.row(this).data();
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
              	obj.gridExpRemind.ajax.reload(null,false);
              }
		});
	    
	});
	
	//������ϸ
    $('#gridExpRemind').on('click','a.btnOperation', function (e) {	  
		var tr = $(this).closest('tr');
		var row = obj.gridExpRemind.row(tr);
		var rd = row.data();
		obj.RepID  = rd["ID"];
		obj.Status =11;
		obj.gridExpRepLog.ajax.reload();
		layer.open({
			type: 1,
			zIndex: 100,
			area: '800px',
			title:'��������ϸ',
			content: $('#layer_one')		
		});	
    });
}