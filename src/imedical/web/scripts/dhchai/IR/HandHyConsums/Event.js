function InitHHConsumsWinEvent(obj){ 
	CheckSpecificKey();
	
	$("#cboLoc").change(function(){
		obj.gridHHConsums.ajax.reload();
	});
	
	$("#cboHospital").change(function(){
		$("#cboLoc").data("param",$.form.GetValue("cboHospital")+"^^I^W^1");
		$.form.SelectRender("cboLoc");
		obj.gridHHConsums.clear().draw();
		obj.gridHHConsums.ajax.reload();
	});
	
	$("#DateFrom").change(function(){
		var DateFrom = $.form.GetValue("DateFrom");
		var DateTo   = $.form.GetValue("DateTo");
		if(DateFrom>DateTo){
			layer.alert('��ʼ���ڲ�������ڽ�������!',{icon: 0});
			return ;	
		}
		obj.gridHHConsums.clear().draw();
		obj.gridHHConsums.ajax.reload();
	});
	$("#DateTo").change(function(){
		var DateFrom = $.form.GetValue("DateFrom");
		var DateTo   = $.form.GetValue("DateTo");
		if(DateFrom>DateTo){
			layer.alert('��ʼ���ڲ�������ڽ�������!',{icon: 0});
			return ;	
		}
		obj.gridHHConsums.clear().draw();
		obj.gridHHConsums.ajax.reload();
	});
	
	/*****��������*****/
	$("#btnsearch").on('click', function(){
	   $('#gridHHConsums').DataTable().search($('#search').val(),true,true).draw();
	   
	});

	$("#search").keyup(function(event){
	    if (event.keyCode == 13) {
	        obj.gridHHConsums.search(this.value).draw();
	    }
	});
	/****************/
    $("#btnDelete").addClass('disabled');
	obj.gridHHConsums.on('select', function(e, dt, type, indexes) {
		var selectedRows = dt.rows({selected: true}).count();
		$("#btnDelete").removeClass('disabled');
		
	});
	
	obj.gridHHConsums.on('deselect', function(e, dt, type, indexes) {
		var selectedRows = dt.rows({selected: true}).count();
        $("#btnDelete").addClass('disabled');
       
	});
	
	obj.gridHHConsums.on('dblclick', 'tr', function(e) {
		var rd = obj.gridHHConsums.row(this).data();
		obj.layer_rd = rd;
		obj.Layer();
	    
	});
	
	$("#btnEdit").on('click', function(){
		obj.layer_rd = '';
		obj.Layer();
		
	});
	$('#gridHHConsums').on('click','a.btnReprot', function (e) {
		var tr = $(this).closest('tr');
		var row = obj.gridHHConsums.row(tr);
		var rd = row.data();
		obj.layer_rd = rd;
	    obj.Layer();
		
	});
	
	$("#btnDelete").on('click', function(){
		var flag = $("#btnDelete").hasClass("disabled");
		if(flag) return ;
		var selectedRows = obj.gridHHConsums.rows({selected: true}).count();
		if ( selectedRows !== 1 ) return;
		var rd = obj.gridHHConsums.rows({selected: true}).data().toArray()[0];
		
		var ID = rd["ID"];
		layer.confirm( 'ȷ���Ƿ�ɾ��?', {
			btn: ['ȷ��','ȡ��'],    //btnλ�ö�Ӧfunction��λ��
			btnAlign: 'c'
			},
			function(){ 
				var flg = $.Tool.RunServerMethod("DHCHAI.IR.HandHyConsums","DeleteById",ID);
				if (parseInt(flg)<0){
					layer.msg('ɾ��ʧ��!',{icon: 2});
				} else {
					obj.gridHHConsums.rows({selected:true}).remove().draw(false);
					layer.msg('ɾ���ɹ�!',{icon: 1});
				}
		 });
	});
	
	// ��������Ʒ���ĵǼ�
	obj.Layer = function(){
		$.form.iCheckRender();
		$.form.SelectRender('cboObsLoc');
		$.form.SelectRender('cboProduct');
		var rd = obj.layer_rd;
		if (rd){
			$.form.SetValue("cboObsLoc",rd["LocDr"],rd["LocDesc"]);
			$.form.SetValue("cboProduct",rd["ProductDr"],rd["ProductDesc"]);
			$.form.SetValue("ObsDate",rd["ObsDate"]);
			$.form.SetValue("txtConsum",rd["Consumption"]);
			$.form.SetValue("txtRecipient",rd["Recipient"]);
			$.form.SetValue("txtResume",rd["Resume"]);
			$.form.SetValue("chkIsActive",rd["IsActive"]== 1);
		} else {
			$.form.SetValue("cboObsLoc",'');
			$.form.SetValue("cboProduct",'');
			$.form.SetValue("ObsDate",'');
			$.form.SetValue("txtConsum",'');
			$.form.SetValue("txtRecipient",'');
			$.form.SetValue("txtResume",'');
			$.form.SetValue("chkIsActive",true);
		}
		
		layer.open({
			type: 1,
			zIndex: 100,
			area: '600px',
			skin: 'layer-class',
			title: '��������Ʒ�������༭', 
			content: $('#layer'),
			btn: ['���','����','�ر�'],
			btnAlign: 'c',
			yes: function(index, layero){
			  	obj.Layer_Add();
			},
			btn2: function(index, layero){
				obj.Layer_Save();
			  	return false;
			},
			success: function(layero){
				var button = layero.find(".layui-layer-btn0");
				if (rd) {
					$(button).hide();
				}
				layero.find(".layui-layer-btn1").css({"backgroundColor":"#2E8DED","color":"white","border":"1px solid #2E8DED"});
			}	
		}); 	
	}
	// ��������Ʒ���ĵǼ�-����
	obj.Layer_Save = function(){
		var rd = obj.layer_rd;
		var ID = (rd ? rd["ID"] : '');
		
		var LocDr       = $.form.GetValue("cboObsLoc");
		var ObsDate     = $.form.GetValue("ObsDate");
		var ProductDr   = $.form.GetValue("cboProduct");
		var Consumption = $.form.GetValue("txtConsum");
		var Recipient   = $.form.GetValue("txtRecipient");
		var IsActive    = $.form.GetValue("chkIsActive");
		var Resume      = $.form.GetValue("txtResume");
		
		var ErrorStr = "";
		if (LocDr == '') {
			ErrorStr += '���Ҳ�����Ϊ�գ�<br/>';	
		}
		if (ObsDate == '') {
			ErrorStr += '���ڲ�����Ϊ�գ�<br/>';
		}
		if (ProductDr == '') {
			ErrorStr += '��������Ʒ������Ϊ�գ�<br/>';
		}
		if (Consumption == '') {
			ErrorStr += '������������Ϊ�գ�<br/>';
		}
		if (Recipient == '') {
			ErrorStr += '�����˲�����Ϊ�գ�<br/>';
		}
		
		if (ErrorStr != '') {
			layer.alert(ErrorStr,{icon: 0});
			return;
		}
		
		var InputStr = ID;
		InputStr += "^" + LocDr;
		InputStr += "^" + ObsDate;
		InputStr += "^" + ProductDr;
		InputStr += "^" + Consumption;
		InputStr += "^" + Recipient;
		InputStr += "^" + "";
		InputStr += "^" + "";
		InputStr += "^" + $.LOGON.USERID;
		InputStr += "^" + IsActive;
		InputStr += "^" + Resume;
		
		var retval = $.Tool.RunServerMethod("DHCHAI.IR.HandHyConsums","Update",InputStr);
		if (parseInt(retval)>0){
			obj.gridHHConsums.ajax.reload(function(){
				var rowIndex = $.Tool.GetTableRowIndex(obj.gridHHConsums,retval);
				if (rowIndex > -1){
					var rd =obj.gridHHConsums.row(rowIndex).data();
					obj.layer_rd = rd;
				} else {
					obj.layer_rd = '';
				}
				layer.msg('����ɹ�!',{icon: 1});
			},false);
		} else {
			if(parseInt(retval)=='-100'){
				layer.alert('Ψһ���ظ���',{icon: 0});
			}else {
				layer.msg('����ʧ��',{icon: 2});
			}
		}
	}
	// ��������Ʒ���ĵǼ�-���
	obj.Layer_Add = function(){
		var rd = "";
		var ID = (rd ? rd["ID"] : '');
		
		var LocDr       = $.form.GetValue("cboObsLoc");
		var ObsDate     = $.form.GetValue("ObsDate");
		var ProductDr   = $.form.GetValue("cboProduct");
		var Consumption = $.form.GetValue("txtConsum");
		var Recipient   = $.form.GetValue("txtRecipient");
		var IsActive    = $.form.GetValue("chkIsActive");
		var Resume      = $.form.GetValue("txtResume");
		
		var ErrorStr = "";
		if (LocDr == '') {
			ErrorStr += '���Ҳ�����Ϊ�գ�<br/>';	
		}
		if (ObsDate == '') {
			ErrorStr += '���ڲ�����Ϊ�գ�<br/>';
		}
		if (ProductDr == '') {
			ErrorStr += '��������Ʒ������Ϊ�գ�<br/>';
		}
		if (Consumption == '') {
			ErrorStr += '������������Ϊ�գ�<br/>';
		}
		if (Recipient == '') {
			ErrorStr += '�����˲�����Ϊ�գ�<br/>';
		}
		
		if (ErrorStr != '') {
			layer.alert(ErrorStr,{icon: 0});
			return;
		}
		
		var InputStr = ID;
		InputStr += "^" + LocDr;
		InputStr += "^" + ObsDate;
		InputStr += "^" + ProductDr;
		InputStr += "^" + Consumption;
		InputStr += "^" + Recipient;
		InputStr += "^" + "";
		InputStr += "^" + "";
		InputStr += "^" + $.LOGON.USERID;
		InputStr += "^" + IsActive;
		InputStr += "^" + Resume;
		
		var retval = $.Tool.RunServerMethod("DHCHAI.IR.HandHyConsums","Update",InputStr);
		if (parseInt(retval)>0){
			obj.gridHHConsums.ajax.reload(function(){
				var rowIndex = $.Tool.GetTableRowIndex(obj.gridHHConsums,retval);
				if (rowIndex > -1){
					var rd =obj.gridHHConsums.row(rowIndex).data();
					obj.layer_rd = rd;
				} else {
					obj.layer_rd = '';
				}
				layer.msg('����ɹ�!',{icon: 1});
			},false);
		} else {
			if(parseInt(retval)=='-100'){
				layer.alert('Ψһ���ظ���',{icon: 0});
			}else {
				layer.msg('����ʧ��',{icon: 2});
			}
		}
	}
     //����
    $("#btnExport").on('click', function(){
	    var Rowcount = obj.gridHHConsums.rows().count();
		if ( Rowcount==0) {
			layer.msg('û������!',{icon: 2});
			$("#btnExport").blur();
			return;
		} 
		obj.gridHHConsums.buttons(0,null)[1].node.click();
	});
	new $.fn.dataTable.Buttons(obj.gridHHConsums, {
		buttons: [
			{
				extend: 'csv',
				text:'����'
			},
			{
				extend: 'excel',
				text:'����',
				title:"��������Ʒ�������б�"
				,footer: true
				,exportOptions: {
					columns: ':visible'
					,width:50
					,orthogonal: 'export'
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
}