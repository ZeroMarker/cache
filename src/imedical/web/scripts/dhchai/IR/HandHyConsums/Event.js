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
			layer.alert('开始日期不允许大于结束日期!',{icon: 0});
			return ;	
		}
		obj.gridHHConsums.clear().draw();
		obj.gridHHConsums.ajax.reload();
	});
	$("#DateTo").change(function(){
		var DateFrom = $.form.GetValue("DateFrom");
		var DateTo   = $.form.GetValue("DateTo");
		if(DateFrom>DateTo){
			layer.alert('开始日期不允许大于结束日期!',{icon: 0});
			return ;	
		}
		obj.gridHHConsums.clear().draw();
		obj.gridHHConsums.ajax.reload();
	});
	
	/*****搜索功能*****/
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
		layer.confirm( '确认是否删除?', {
			btn: ['确认','取消'],    //btn位置对应function的位置
			btnAlign: 'c'
			},
			function(){ 
				var flg = $.Tool.RunServerMethod("DHCHAI.IR.HandHyConsums","DeleteById",ID);
				if (parseInt(flg)<0){
					layer.msg('删除失败!',{icon: 2});
				} else {
					obj.gridHHConsums.rows({selected:true}).remove().draw(false);
					layer.msg('删除成功!',{icon: 1});
				}
		 });
	});
	
	// 手卫生用品消耗登记
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
			title: '手卫生用品消耗量编辑', 
			content: $('#layer'),
			btn: ['添加','保存','关闭'],
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
	// 手卫生用品消耗登记-保存
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
			ErrorStr += '科室不允许为空！<br/>';	
		}
		if (ObsDate == '') {
			ErrorStr += '日期不允许为空！<br/>';
		}
		if (ProductDr == '') {
			ErrorStr += '手卫生用品不允许为空！<br/>';
		}
		if (Consumption == '') {
			ErrorStr += '消耗量不允许为空！<br/>';
		}
		if (Recipient == '') {
			ErrorStr += '领用人不允许为空！<br/>';
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
				layer.msg('保存成功!',{icon: 1});
			},false);
		} else {
			if(parseInt(retval)=='-100'){
				layer.alert('唯一性重复！',{icon: 0});
			}else {
				layer.msg('保存失败',{icon: 2});
			}
		}
	}
	// 手卫生用品消耗登记-添加
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
			ErrorStr += '科室不允许为空！<br/>';	
		}
		if (ObsDate == '') {
			ErrorStr += '日期不允许为空！<br/>';
		}
		if (ProductDr == '') {
			ErrorStr += '手卫生用品不允许为空！<br/>';
		}
		if (Consumption == '') {
			ErrorStr += '消耗量不允许为空！<br/>';
		}
		if (Recipient == '') {
			ErrorStr += '领用人不允许为空！<br/>';
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
				layer.msg('保存成功!',{icon: 1});
			},false);
		} else {
			if(parseInt(retval)=='-100'){
				layer.alert('唯一性重复！',{icon: 0});
			}else {
				layer.msg('保存失败',{icon: 2});
			}
		}
	}
     //导出
    $("#btnExport").on('click', function(){
	    var Rowcount = obj.gridHHConsums.rows().count();
		if ( Rowcount==0) {
			layer.msg('没有数据!',{icon: 2});
			$("#btnExport").blur();
			return;
		} 
		obj.gridHHConsums.buttons(0,null)[1].node.click();
	});
	new $.fn.dataTable.Buttons(obj.gridHHConsums, {
		buttons: [
			{
				extend: 'csv',
				text:'导出'
			},
			{
				extend: 'excel',
				text:'导出',
				title:"手卫生用品消耗量列表"
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
				text:'打印'
				,title:""
				,footer: true
			}
		]
	});
}