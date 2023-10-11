//ҳ��Event
function InitKeyWordWinEvent(obj){
	CheckSpecificKey();
     /*****��������*****/
    $("#btnsearch").on('click', function(){
       $('#gridKeyWord').DataTable().search($('#search').val(),true,true).draw();
       
    });
	
    $("#search").keyup(function(event){
        if (event.keyCode == 13) {
	        obj.gridKeyWord.search(this.value).draw();
        }
    });
   /**********************/
    $("#btnEdit").addClass('disabled');
    $("#btnDelete").addClass('disabled');
	obj.gridKeyWord.on('select', function(e, dt, type, indexes) {
		var selectedRows = dt.rows({selected: true}).count();
		$("#btnAdd").addClass('disabled');
		$("#btnEdit").removeClass('disabled');
		$("#btnDelete").removeClass('disabled');
	});
	
	obj.gridKeyWord.on('deselect', function(e, dt, type, indexes) {
		var selectedRows = dt.rows({selected: true}).count();
		$("#btnAdd").removeClass('disabled');
        $("#btnEdit").addClass('disabled');
        $("#btnDelete").addClass('disabled');
	});
	
	obj.gridKeyWord.on('dblclick', 'tr', function(e) {
		var rd = obj.gridKeyWord.row(this).data();
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
		var selectedRows = obj.gridKeyWord.rows({selected: true}).count();
		if ( selectedRows !== 1 ) return;
		var rd = obj.gridKeyWord.rows({selected: true}).data().toArray()[0];
		
		obj.layer_rd = rd;
	    obj.Layer();

	});

	$("#btnDelete").on('click', function(){
		var flag = $("#btnDelete").hasClass("disabled");
		if(flag) return ;
		var selectedRows = obj.gridKeyWord.rows({selected: true}).count();
		if ( selectedRows !== 1 ) return;
		var rd = obj.gridKeyWord.rows({selected: true}).data().toArray()[0];
		
		var ID = rd["ID"];
		layer.confirm( 'ȷ���Ƿ�ɾ��?', {
			btn: ['ȷ��','ȡ��'],    //btnλ�ö�Ӧfunction��λ��
			btnAlign: 'c'
			},
			function(){ 
				var flg = $.Tool.RunServerMethod("DHCHAI.IR.CCKeyWord","DeleteById",ID);
				if (parseInt(flg)<0){
					if (parseInt(flg)=='-777') {
						layer.msg('�ؼ���-777����ǰ��ɾ��Ȩ�ޣ�������ɾ��Ȩ�޺���ɾ����¼!',{icon: 2});
					}else {
						layer.msg('ɾ��ʧ��!',{icon: 2});
					}
				} else {
					obj.gridKeyWord.rows({selected:true}).remove().draw(false);
					layer.msg('ɾ���ɹ�!',{icon: 1});
				}
		 });
	});
  
	//�ؼ�����Ϣ�༭����-��ʼ��
	obj.Layer = function(){
		var rd = obj.layer_rd;
		if (rd){
			$.form.SetValue("txtDesc",rd["Desc"]);
			$.form.SetValue("txtNote",rd["Note"]);
			
		} else {
			$.form.SetValue("txtDesc",'');
			$.form.SetValue("txtNote",'');
		}
		layer.config({  
			extend: 'layerskin/style.css' 
		});
	
		layer.open({
			type: 1,
			zIndex: 100,
			area: '600px',
			skin: 'layer-class',
			title: '�ؼ������ñ༭', 
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
	
	
	//�ؼ�����Ϣ���ô���-����
	obj.Layer_Save = function(){
		var rd = obj.layer_rd;
		var ID = (rd ? rd["ID"] : '');
		
		var Desc = $.form.GetValue("txtDesc");
		var Note = $.form.GetValue("txtNote");

		if (Desc == '') {
			layer.alert("�ؼ������Ʋ�����Ϊ��",{icon: 0});
			return;
		}
		if (Note == '') {
			layer.alert("�ؼ���˵��������Ϊ��",{icon: 0});
			return;
		}
		var InputStr = ID;
		InputStr += "^" + Desc;
		InputStr += "^" + Note;
	
		var retval = $.Tool.RunServerMethod("DHCHAI.IR.CCKeyWord","Update",InputStr);
		if (parseInt(retval)>0){
			obj.gridKeyWord.ajax.reload(function(){
				var rowIndex = $.Tool.GetTableRowIndex(obj.gridKeyWord,retval);
				if (rowIndex > -1){
					var rd =obj.gridKeyWord.row(rowIndex).data();
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
	
	//�ؼ�����Ϣ���ô���-���
    obj.Layer_Add = function(){
		var rd = "";
		var ID = (rd ? rd["ID"] : '');
	
	    var Desc = $.form.GetValue("txtDesc");
		var Note = $.form.GetValue("txtNote");

		if (Desc == '') {
			layer.alert("�ؼ������Ʋ�����Ϊ��",{icon: 0});
			return;
		}
		if (Note == '') {
			layer.alert("�ؼ���˵��������Ϊ��",{icon: 0});
			return;
		}
		var InputStr = ID;
		InputStr += "^" + Desc;
		InputStr += "^" + Note;
	
		var retval = $.Tool.RunServerMethod("DHCHAI.IR.CCKeyWord","Update",InputStr);
		if (parseInt(retval)>0){
			obj.gridKeyWord.ajax.reload(function(){
				var rowIndex = $.Tool.GetTableRowIndex(obj.gridKeyWord,retval);
				if (rowIndex > -1){
					var rd =obj.gridKeyWord.row(rowIndex).data();
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
