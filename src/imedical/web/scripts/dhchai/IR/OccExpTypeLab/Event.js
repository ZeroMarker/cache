//ҳ��Event
function InitExpTypeLabWinEvent(obj){
	$.form.iCheckRender();
	CheckSpecificKey();
	/*****��������*****/
    $("#btnsearch").on('click', function(){
       $('#gridExpTypeLab').DataTable().search($('#search').val(),true,true).draw();
       
    });
	
    $("#search").keyup(function(event){
        if (event.keyCode == 13) {
	        obj.gridExpTypeLab.search(this.value).draw();
        }
    });
   /**********************/
    $("#btnEdit").addClass('disabled');
    $("#btnDelete").addClass('disabled');
	obj.gridExpTypeLab.on('select', function(e, dt, type, indexes) {
		var selectedRows = dt.rows({selected: true}).count();
		$("#btnAdd").addClass('disabled');
		$("#btnEdit").removeClass('disabled');
		$("#btnDelete").removeClass('disabled');
	});
	
	obj.gridExpTypeLab.on('deselect', function(e, dt, type, indexes) {
		var selectedRows = dt.rows({selected: true}).count();
		$("#btnAdd").removeClass('disabled');
        $("#btnEdit").addClass('disabled');
        $("#btnDelete").addClass('disabled');
	});
	
	obj.gridExpTypeLab.on('dblclick', 'tr', function(e) {
		var rd = obj.gridExpTypeLab.row(this).data();

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
		var selectedRows = obj.gridExpTypeLab.rows({selected: true}).count();
		if ( selectedRows !== 1 ) return;
		var rd = obj.gridExpTypeLab.rows({selected: true}).data().toArray()[0];
		obj.layer_rd = rd;
	    obj.Layer();
		
	});
	
	$("#btnDelete").on('click', function(){
		var flag = $("#btnDelete").hasClass("disabled");
		if(flag) return ;
		var selectedRows = obj.gridExpTypeLab.rows({selected: true}).count();
		if ( selectedRows !== 1 ) return;
		var rd = obj.gridExpTypeLab.rows({selected: true}).data().toArray()[0];
		
		var ID = rd["ID"];
		layer.confirm( 'ȷ���Ƿ�ɾ��?', {
			btn: ['ȷ��','ȡ��'],    //btnλ�ö�Ӧfunction��λ��
			btnAlign: 'c'
			},
			function(){ 
				var flg = $.Tool.RunServerMethod("DHCHAI.IR.OccExpTypeLab","DeleteById",ID);
				if (parseInt(flg)<0){
					layer.msg('ɾ��ʧ��!',{icon: 2});
				} else {
					obj.gridExpTypeLab.rows({selected:true}).remove().draw(false);
					layer.msg('ɾ���ɹ�!',{icon: 1});
				}
		 });
		
	});
	//����ʱ������Ϊ����
	$('#txtDays').on('keyup', function() {
		$(this).val($(this).val().replace(/[^\d]/g,''));
	});
	
	//ְҵ��¶Ѫ��ѧ�ƻ�����-��ʼ��
	obj.Layer = function(){
        var rd = obj.layer_rd;
		if (rd){
			$.form.SetValue("txtDesc",rd["BTDesc"]);
			$.form.SetValue("txtIndNo",rd["BTIndNo"]);
			$.form.SetValue("txtDays",rd["BTDays"]);
			$.form.SetValue("txtResume",rd["Resume"]);
			$.form.SetValue("chkActive",rd["IsActive"]== 1);
		} else {
			$.form.SetValue("txtDesc",'');
			$.form.SetValue("txtIndNo",'');
			$.form.SetValue("txtDays",'');
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
			title: 'ְҵ��¶Ѫ��ѧ�ƻ��༭', 
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
	
	//ְҵ��¶Ѫ��ѧ�ƻ�����-����
	 obj.Layer_Save = function(){
        var rd = obj.layer_rd;
		var ID = (rd ? rd["ID"] : '');
		var SubID = (ID ? ID.split("||")[1] : '');
		
		var Desc = $.form.GetValue("txtDesc");
		var IndNo = $.form.GetValue("txtIndNo");
		var Days = $.form.GetValue("txtDays");
		var Resume = $.form.GetValue("txtResume");
		var IsActive = $.form.GetValue("chkActive");
		
		if (Desc== '') {
			layer.alert("���ʱ��������Ϊ��",{icon: 0});
			return;
		}
    if (Days== '') {
			layer.alert("ʱ����������Ϊ��",{icon: 0});
			return;
		}
		
		var InputStr = Parref;
		InputStr += "^" + SubID;
		InputStr += "^" + Desc;
		InputStr += "^" + IndNo;
		InputStr += "^" + Days;
		InputStr += "^" + IsActive;
		InputStr += "^" + Resume;
		var retval = $.Tool.RunServerMethod("DHCHAI.IR.OccExpTypeLab","Update",InputStr);
		if (parseInt(retval)>0){
			obj.gridExpTypeLab.ajax.reload(function(){
				var rowIndex = $.Tool.GetTableRowIndex(obj.gridExpTypeLab,retval);
				if (rowIndex > -1){
					var rd =obj.gridExpTypeLab.row(rowIndex).data();
					obj.layer_rd = rd;
				} else {
					obj.layer_rd = '';
				}
				layer.msg('����ɹ�!',{icon: 1});
			},false);
		} else {
			if(parseInt(retval)=='-2'){
				layer.alert('���ʱ���ظ�!',{icon: 0});
			}else {
				layer.msg('����ʧ��!',{icon: 2});
			}
		}
	}
	
	//ְҵ��¶Ѫ��ѧ�ƻ�����-���
	 obj.Layer_Add = function(){
		var rd = "";
		var ID = (rd ? rd["ID"] : '');
		var SubID = (ID ? ID.split("||")[1] : '');
		
		var Desc = $.form.GetValue("txtDesc");
		var IndNo = $.form.GetValue("txtIndNo");
		var Days = $.form.GetValue("txtDays");
		var Resume = $.form.GetValue("txtResume");
		var IsActive = $.form.GetValue("chkActive");
		
		if (Desc== '') {
			layer.alert("���ʱ��������Ϊ��",{icon: 0});
			return;
		}
    if (Days== '') {
			layer.alert("ʱ����������Ϊ��",{icon: 0});
			return;
		}
		
		var InputStr = Parref;
		InputStr += "^" + SubID;
		InputStr += "^" + Desc;
		InputStr += "^" + IndNo;
		InputStr += "^" + Days;
		InputStr += "^" + IsActive;
		InputStr += "^" + Resume;
		var retval = $.Tool.RunServerMethod("DHCHAI.IR.OccExpTypeLab","Update",InputStr);
		if (parseInt(retval)>0){
			obj.gridExpTypeLab.ajax.reload(function(){
				var rowIndex = $.Tool.GetTableRowIndex(obj.gridExpTypeLab,retval);
				if (rowIndex > -1){
					var rd =obj.gridExpTypeLab.row(rowIndex).data();
					obj.layer_rd = rd;
				} else {
					obj.layer_rd = '';
				}
				layer.msg('����ɹ�!',{icon: 1});
			},false);
		} else {
			if(parseInt(retval)=='-2'){
				layer.alert('���ʱ���ظ�!',{icon: 0});
			}else {
				layer.msg('����ʧ��!',{icon: 2});
			}
		}
	}
	
}