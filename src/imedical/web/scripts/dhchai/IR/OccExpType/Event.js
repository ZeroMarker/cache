//ҳ��Event
function InitExpTypeWinEvent(obj){
	$.form.iCheckRender();
	CheckSpecificKey();
	/*****��������*****/
    $("#btnsearch").on('click', function(){
       $('#gridExpType').DataTable().search($('#search').val(),true,true).draw();
       
    });
	
    $("#search").keyup(function(event){
        if (event.keyCode == 13) {
	        obj.gridExpType.search(this.value).draw();
        }
    });
   /**********************/
    $("#btnEdit").addClass('disabled');
    $("#btnDelete").addClass('disabled');
	obj.gridExpType.on('select', function(e, dt, type, indexes) {
		var selectedRows = dt.rows({selected: true}).count();
		$("#btnAdd").addClass('disabled');
		$("#btnEdit").removeClass('disabled');
		$("#btnDelete").removeClass('disabled');
	});
	
	obj.gridExpType.on('deselect', function(e, dt, type, indexes) {
		var selectedRows = dt.rows({selected: true}).count();
		$("#btnAdd").removeClass('disabled');
        $("#btnEdit").addClass('disabled');
        $("#btnDelete").addClass('disabled');
	});
	
	obj.gridExpType.on('dblclick', 'tr', function(e) {
		var rd = obj.gridExpType.row(this).data();

		obj.layer_rd = rd;
		obj.Layer();
	    
	});
	
	$("#btnAdd").on('click', function(){
		var flag = $("#btnAdd").hasClass("disabled");
		if(flag) return ;	
		obj.layer_rd = '';
		obj.Layer();
		
	});
	
	$("#btnEdit").on('click', function(){
		var flag = $("#btnEdit").hasClass("disabled");
		if(flag) return ;
		var selectedRows = obj.gridExpType.rows({selected: true}).count();
		if ( selectedRows !== 1 ) return;
		var rd = obj.gridExpType.rows({selected: true}).data().toArray()[0];
		obj.layer_rd = rd;
	    obj.Layer();
		
	});
	
	$("#btnDelete").on('click', function(){
		var flag = $("#btnDelete").hasClass("disabled");
		if(flag) return ;
		var selectedRows = obj.gridExpType.rows({selected: true}).count();
		if ( selectedRows !== 1 ) return;
		var rd = obj.gridExpType.rows({selected: true}).data().toArray()[0];
		
		var ID = rd["ID"];
		layer.confirm( 'ȷ���Ƿ�ɾ��?', {
			btn: ['ȷ��','ȡ��'],    //btnλ�ö�Ӧfunction��λ��
			btnAlign: 'c'
			},
			function(){ 
				var flg = $.Tool.RunServerMethod("DHCHAI.IR.OccExpType","DeleteById",ID);
				if (parseInt(flg)<0){
					layer.msg('ɾ��ʧ��!',{icon: 2});
				} else {
					obj.gridExpType.rows({selected:true}).remove().draw(false);
					layer.msg('ɾ���ɹ�!',{icon: 1});
				}
		 });
		
	});
	
	//ְҵ��¶���ʹ���-��ʼ��
	obj.Layer = function(){
        var rd = obj.layer_rd;
		if (rd){
			$.form.SetValue("txtCode",rd["BTCode"]);
			$.form.SetValue("txtDesc",rd["BTDesc"]);
			$.form.SetValue("txtResume",rd["Resume"]);
			$.form.SetValue("chkActive",rd["IsActive"]== 1);
		} else {
			$.form.SetValue("txtCode",'');
			$.form.SetValue("txtDesc",'');
			$.form.SetValue("txtResume",'');
			$.form.SetValue("chkActive",'');
		}
		
		layer.config({  
			extend: 'layerskin/style.css' 
		});
	
		layer.open({
			type: 1,
			zIndex: 100,
			area: '600px',
			skin: 'layer-class',
			title: 'ְҵ��¶���ͱ༭', 
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
				
			}	
		}); 	
		
	}
	
	//ְҵ��¶���ʹ���-����
	 obj.Layer_Save = function(){
        var rd = obj.layer_rd;
		var ID = (rd ? rd["ID"] : '');
		
		var Code = $.form.GetValue("txtCode");
		var Desc = $.trim($.form.GetValue("txtDesc"));
		var Resume = $.form.GetValue("txtResume");
		var IsActive = $.form.GetValue("chkActive");
		
		if (Code== '') {
			layer.alert("���벻����Ϊ��",{icon: 0});
			return;
		}
		if (Desc== '') {
			layer.alert("����������Ϊ��",{icon: 0});
			return;
		}
		
		var InputStr = ID;
		InputStr += "^" + Code;
		InputStr += "^" + Desc;
		InputStr += "^" + IsActive;
		InputStr += "^" + Resume;
		var retval = $.Tool.RunServerMethod("DHCHAI.IR.OccExpType","Update",InputStr);
		if (parseInt(retval)>0){
			obj.gridExpType.ajax.reload(function(){
				var rowIndex = $.Tool.GetTableRowIndex(obj.gridExpType,retval);
				if (rowIndex > -1){
					var rd =obj.gridExpType.row(rowIndex).data();
					obj.layer_rd = rd;
				} else {
					obj.layer_rd = '';
				}
				layer.msg('����ɹ�!',{icon: 1});
			},false);
		} else {
			if(parseInt(retval)=='-2'){
				layer.alert('�����ظ�!',{icon: 0});
			}else {
				layer.msg('����ʧ��!',{icon: 2});
			}
		}
	}
	
	//ְҵ��¶���ʹ���-���
	 obj.Layer_Add = function(){
		var rd = "";
		var ID = (rd ? rd["ID"] : '');
		
		var Code = $.form.GetValue("txtCode");
		var Desc = $.trim($.form.GetValue("txtDesc"));
		var Resume = $.form.GetValue("txtResume");
		var IsActive = $.form.GetValue("chkActive");
		
		if (Code== '') {
			layer.alert("���벻����Ϊ��",{icon: 0});
			return;
		}
		if (Desc== '') {
			layer.alert("����������Ϊ��",{icon: 0});
			return;
		}
		
		var InputStr = ID;
		InputStr += "^" + Code;
		InputStr += "^" + Desc;
		InputStr += "^" + IsActive;
		InputStr += "^" + Resume;
		var retval = $.Tool.RunServerMethod("DHCHAI.IR.OccExpType","Update",InputStr);
		if (parseInt(retval)>0){
			obj.gridExpType.ajax.reload(function(){
				var rowIndex = $.Tool.GetTableRowIndex(obj.gridExpType,retval);
				if (rowIndex > -1){
					var rd =obj.gridExpType.row(rowIndex).data();
					obj.layer_rd = rd;
				} else {
					obj.layer_rd = '';
				}
				layer.msg('����ɹ�!',{icon: 1});
			},false);
		} else {
			if(parseInt(retval)=='-2'){
				layer.alert('�����ظ�!',{icon: 0});
			}else {
				layer.msg('����ʧ��!',{icon: 2});
			}
		}
	}
	
	$('#gridExpType').on('click','a.btnExt', function (e) {
		e.preventDefault();
		var tr = $(this).closest('tr');
		var row = obj.gridExpType.row(tr);
		var rowData = row.data();
		obj.layer_rd = rowData;
	    var Parref =rowData.ID;
	    var url = '../csp/dhchai.ir.occexptypeext.csp?Parref='+Parref+'&1=1';
		layer.open({
		      type: 2,
			  area: ['95%', '95%'],
			  closeBtn: 1,
			  title:'��Ŀ����',
			  fixed: false, //���̶�
			  content: [url,'no'],
			  success: function(layero, index){
			  		$("div.layui-layer-content").css("padding-right","2px");
			  }
		});
    });
    
    $('#gridExpType').on('click','a.btnCap', function (e) {
		e.preventDefault();
		var tr = $(this).closest('tr');
		var row = obj.gridExpType.row(tr);
		var rowData = row.data();
		obj.layer_rd = rowData;
		
		var Parref =rowData.ID;
	    var url = '../csp/dhchai.ir.occexptypeepd.csp?Parref='+Parref+'&1=1';
		layer.open({
		      type: 2,
			  area: ['95%', '95%'],
			  title:'����������',
			  fixed: false, //���̶�
			  content: [url,'no'],
			  success: function(layero, index){
			  		$("div.layui-layer-content").css("padding-right","2px");
			  }
		});
    });
    $('#gridExpType').on('click','a.btnLab', function (e) {
		e.preventDefault();
		var tr = $(this).closest('tr');
		var row = obj.gridExpType.row(tr);
		var rowData = row.data();
		obj.layer_rd = rowData;
		
		var Parref =rowData.ID;
	    var url = '../csp/dhchai.ir.occexptypelab.csp?Parref='+Parref+'&1=1';
		layer.open({
		      type: 2,
			  area: ['95%', '95%'],
			  title:'Ѫ��ѧ���ƻ�',
			  fixed: false, //���̶�
			  content: [url,'no'],
			  success: function(layero, index){
			  		$("div.layui-layer-content").css("padding-right","2px");
			  }
		});
    });
	
}