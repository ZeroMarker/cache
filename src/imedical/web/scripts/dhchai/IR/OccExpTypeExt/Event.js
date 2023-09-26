//ҳ��Event
function InitExpTypeExtWinEvent(obj){
	$.form.iCheckRender();
	CheckSpecificKey();
	/*****��������*****/
    $("#btnsearch").on('click', function(){
       $('#gridExpTypeExt').DataTable().search($('#search').val(),true,true).draw();
       
    });
	
    $("#search").keyup(function(event){
        if (event.keyCode == 13) {
	        obj.gridExpTypeExt.search(this.value).draw();
        }
    });
   /**********************/
    $("#btnEdit").addClass('disabled');
    $("#btnDelete").addClass('disabled');
	obj.gridExpTypeExt.on('select', function(e, dt, type, indexes) {
		var selectedRows = dt.rows({selected: true}).count();
		$("#btnAdd").addClass('disabled');
		$("#btnEdit").removeClass('disabled');
		$("#btnDelete").removeClass('disabled');
	});
	
	obj.gridExpTypeExt.on('deselect', function(e, dt, type, indexes) {
		var selectedRows = dt.rows({selected: true}).count();
		$("#btnAdd").removeClass('disabled');
        $("#btnEdit").addClass('disabled');
        $("#btnDelete").addClass('disabled');
	});
	
	obj.gridExpTypeExt.on('dblclick', 'tr', function(e) {
		var rd = obj.gridExpTypeExt.row(this).data();
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
		var selectedRows = obj.gridExpTypeExt.rows({selected: true}).count();
		if ( selectedRows !== 1 ) return;
		var rd = obj.gridExpTypeExt.rows({selected: true}).data().toArray()[0];
		obj.layer_rd = rd;
	    obj.Layer();
		
	});
	
	$("#btnDelete").on('click', function(){
		var flag = $("#btnDelete").hasClass("disabled");
		if(flag) return ;
		var selectedRows = obj.gridExpTypeExt.rows({selected: true}).count();
		if ( selectedRows !== 1 ) return;
		var rd = obj.gridExpTypeExt.rows({selected: true}).data().toArray()[0];
		
		var ID = rd["ID"];
		layer.confirm( 'ȷ���Ƿ�ɾ��?', {
			btn: ['ȷ��','ȡ��'],    //btnλ�ö�Ӧfunction��λ��
			btnAlign: 'c'
			},
			function(){ 
				var flg = $.Tool.RunServerMethod("DHCHAI.IR.OccExpTypeExt","DeleteById",ID);
				if (parseInt(flg)<0){
					layer.msg('ɾ��ʧ��!',{icon: 2});
				} else {
					obj.gridExpTypeExt.rows({selected:true}).remove().draw(false);
					layer.msg('ɾ���ɹ�!',{icon: 1});
				}
		 });
		
	});
	
	//ְҵ��¶��Ŀ����-��ʼ��
	obj.Layer = function(){
		$.form.SelectRender('cboExtType');
	 	$.form.SelectRender('cboDatType');
		$.form.SelectRender('cboDicType');
        var rd = obj.layer_rd;
		if (rd){
			$.form.SetValue("txtCode",rd["Code"]);
			$.form.SetValue("txtDesc",rd["Desc"]);
			$.form.SetValue('cboExtType',rd["TypeID"],rd["TypeDesc"]);
			$.form.SetValue('cboDatType',rd["DatID"],rd["DatDesc"]);
			$.form.SetValue('cboDicType',rd["DicID"],rd["DicDesc"]);
			$.form.SetValue("chkIsRequired",rd["IsRequired"]==1);
		} else {
			$.form.SetValue("txtCode",'');
			$.form.SetValue("txtDesc",'');
			$.form.SetValue('cboExtType','');
			$.form.SetValue("cboDatType",'');
			$.form.SetValue("cboDicType",'');
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
			title: 'ְҵ��¶��Ŀ�༭', 
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
	
	//ְҵ��¶��Ŀ����-����
	 obj.Layer_Save = function(){
        var rd = obj.layer_rd;
		var ID = (rd ? rd["ID"] : '');
		var SubID = (ID ? ID.split("||")[1] : '');
	    
		var Code = $.form.GetValue("txtCode");
		var Desc = $.form.GetValue("txtDesc");
		var ExtTypeDr = $.form.GetValue("cboExtType");
		var DatTypeDr = $.form.GetValue("cboDatType");
		var DicTypeDr = $.form.GetValue("cboDicType");
		var IsRequired = $.form.GetValue("chkIsRequired");
		
		if (Code== '') {
			layer.alert("���벻����Ϊ��",{icon: 0});
			return;
		}
		if (Desc== '') {
			layer.alert("����������Ϊ��",{icon: 0});
			return;
		}
		if (ExtTypeDr== '') {
			layer.alert("��Ŀ���಻����Ϊ��",{icon: 0});
			return;
		}
		
		var InputStr = Parref;
		InputStr += "^" + SubID;
		InputStr += "^" + Code;
		InputStr += "^" + Desc;
		InputStr += "^" + ExtTypeDr;
		InputStr += "^" + DatTypeDr;
		InputStr += "^" + DicTypeDr;
		InputStr += "^" + IsRequired;
	    
		var retval = $.Tool.RunServerMethod("DHCHAI.IR.OccExpTypeExt","Update",InputStr);
		if (parseInt(retval)>0){
			obj.gridExpTypeExt.ajax.reload(function(){
				var rowIndex = $.Tool.GetTableRowIndex(obj.gridExpTypeExt,retval);
			
				if (rowIndex > -1){
					var rd =obj.gridExpTypeExt.row(rowIndex).data();
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
	
	//ְҵ��¶��Ŀ����-���
	 obj.Layer_Add = function(){
		var rd = "";
		var ID = (rd ? rd["ID"] : '');
		var SubID = (ID ? ID.split("||")[1] : '');
		
		var Code = $.form.GetValue("txtCode");
		var Desc = $.form.GetValue("txtDesc");
		var ExtTypeDr = $.form.GetValue("cboExtType");
		var DatTypeDr = $.form.GetValue("cboDatType");
		var DicTypeDr = $.form.GetValue("cboDicType");
		var IsRequired = $.form.GetValue("chkIsRequired");
				
		if (Code== '') {
			layer.alert("���벻����Ϊ��",{icon: 0});
			return;
		}
		if (Desc== '') {
			layer.alert("����������Ϊ��",{icon: 0});
			return;
		}
		if (ExtTypeDr== '') {
			layer.alert("��Ŀ���಻����Ϊ��",{icon: 0});
			return;
		}
		var InputStr = Parref;
		InputStr += "^" + SubID;
		InputStr += "^" + Code;
		InputStr += "^" + Desc;
		InputStr += "^" + ExtTypeDr;
		InputStr += "^" + DatTypeDr;
		InputStr += "^" + DicTypeDr;
		InputStr += "^" + IsRequired;
		
		var retval = $.Tool.RunServerMethod("DHCHAI.IR.OccExpTypeExt","Update",InputStr);
		if (parseInt(retval)>0){
			obj.gridExpTypeExt.ajax.reload(function(){
				var rowIndex = $.Tool.GetTableRowIndex(obj.gridExpTypeExt,retval);
				if (rowIndex > -1){
					var rd =obj.gridExpTypeExt.row(rowIndex).data();
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
	
}