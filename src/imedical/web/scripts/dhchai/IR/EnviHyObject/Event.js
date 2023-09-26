//页面Event
function InitEnviHyObjectWinEvent(obj){
	CheckSpecificKey();
	/*****搜索功能*****/
    $("#btnsearch").on('click', function(){
       $('#gridEvObject').DataTable().search($('#search').val(),true,true).draw();
       
    });
	
    $("#search").keyup(function(event){
        if (event.keyCode == 13) {
	        obj.gridEvObject.search(this.value).draw();
        }
    });
    /****************/
    $("#btnEdit").addClass('disabled');
    $("#btnDelete").addClass('disabled');
	obj.gridEvObject.on('select', function(e, dt, type, indexes) {
		var selectedRows = dt.rows({selected: true}).count();
		$("#btnAdd").addClass('disabled');
		$("#btnEdit").removeClass('disabled');
		$("#btnDelete").removeClass('disabled');
	});
	
	obj.gridEvObject.on('deselect', function(e, dt, type, indexes) {
		var selectedRows = dt.rows({selected: true}).count();
		$("#btnAdd").removeClass('disabled');
        $("#btnEdit").addClass('disabled');
        $("#btnDelete").addClass('disabled');
	});
	
	obj.gridEvObject.on('dblclick', 'tr', function(e) {
		var rd = obj.gridEvObject.row(this).data();
		
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
		var selectedRows = obj.gridEvObject.rows({selected: true}).count();
		if ( selectedRows !== 1 ) return;
		var rd = obj.gridEvObject.rows({selected: true}).data().toArray()[0];
		
		obj.layer_rd = rd;
		obj.Layer();
	});
	
	$("#btnDelete").on('click', function(){
		var flag = $("#btnDelete").hasClass("disabled");
		if(flag) return ;
		var selectedRows = obj.gridEvObject.rows({selected: true}).count();
		if ( selectedRows !== 1 ) return;
		var rd = obj.gridEvObject.rows({selected: true}).data().toArray()[0];
		
		var ID = rd["ID"];
		layer.confirm( '确认是否删除?', {
			btn: ['确认','取消'],    //btn位置对应function的位置
			btnAlign: 'c'
			},
			function(){ 
				var flg = $.Tool.RunServerMethod("DHCHAI.IR.EnviHyObject","DeleteById",ID);
				if (parseInt(flg)<0){
					layer.msg('删除失败!',{icon: 2});
				} else {
					obj.gridEvObject.rows({selected:true}).remove().draw(false);
					layer.msg('删除成功!',{icon: 1});
				}
		 });
	});
	
	//监测对象编辑窗体-初始化
	obj.Layer = function(){
		$.form.iCheckRender();
		$.form.SelectRender('cboSpecimenType');

		var rd = obj.layer_rd;
		if (rd){
			$.form.SetValue("txtObjDesc",rd["ObjectDesc"]);
			$.form.SetValue('cboSpecimenType',rd["SpecimenTypeID"],rd["SpecimenTypeDesc"]);
			$.form.SetValue("chkActive",rd["IsActive"]== 1);
		} else {
			$.form.SetValue("txtObjDesc",'');
			$.form.SetValue('cboSpecimenType','');
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
			title: '监测对象编辑', 
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
				
			}	
		}); 	
	}
	
	//监测对象编辑窗体-保存
	obj.Layer_Save = function(){
		var rd = obj.layer_rd;
		var ID = (rd ? rd["ID"] : '');
		
		var ObjDesc= $.form.GetValue("txtObjDesc");
		var SpecimenTypeDesc = $.form.GetText('cboSpecimenType');
		var SpecimenType = $.form.GetValue('cboSpecimenType');
		var IsActive =$.form.GetValue("chkActive");

		if (ObjDesc == '') {
			layer.alert("对象名称不允许为空",{icon: 0});
			return;
		}
		if (SpecimenType == '') {
			layer.alert("标本类型不允许为空",{icon: 0});
			return;
		}

		var InputStr = ID;
		InputStr += "^" + ObjDesc;
		InputStr += "^" + SpecimenTypeDesc;
		InputStr += "^" + IsActive;

		var retval = $.Tool.RunServerMethod("DHCHAI.IR.EnviHyObject","Update",InputStr);
		if (parseInt(retval)>0){
			obj.gridEvObject.ajax.reload(function(){
				var rowIndex = $.Tool.GetTableRowIndex(obj.gridEvObject,retval);
				if (rowIndex > -1){
					var rd =obj.gridEvObject.row(rowIndex).data();
					obj.layer_rd = rd;
				} else {
					obj.layer_rd = '';
				}
				layer.msg('保存成功!',{icon: 1});
			},false);
		} else {
			if(parseInt(retval)=='-100'){
				layer.alert('对象名称重复!',{icon: 0});
			}else {
				layer.msg('保存失败!',{icon: 2});
			}
		}
	}
	
	//监测对象编辑窗体-提交
	obj.Layer_Add = function(){
		var rd = "";
		var ID = (rd ? rd["ID"] : '');
		
		var ObjDesc = $.form.GetValue("txtObjDesc");
		var SpecimenTypeDesc = $.form.GetText('cboSpecimenType');
		var SpecimenType = $.form.GetValue('cboSpecimenType');
		var IsActive =$.form.GetValue("chkActive");

		if (ObjDesc == '') {
			layer.alert("对象名称不允许为空",{icon: 0});
			return;
		}
		if (SpecimenType == '') {
			layer.alert("标本类型不允许为空",{icon: 0});
			return;
		}
		
		var InputStr = ID;
		InputStr += "^" + ObjDesc;
		InputStr += "^" + SpecimenTypeDesc;
		InputStr += "^" + IsActive;
		
		var retval = $.Tool.RunServerMethod("DHCHAI.IR.EnviHyObject","Update",InputStr);
		if (parseInt(retval)>0){
			obj.gridEvObject.ajax.reload(function(){
				var rowIndex = $.Tool.GetTableRowIndex(obj.gridEvObject,retval);
				if (rowIndex > -1){
					var rd =obj.gridEvObject.row(rowIndex).data();
					obj.layer_rd = rd;
				} else {
					obj.layer_rd = '';
				}
				layer.msg('保存成功!',{icon: 1});
			},false);
		} else {
			if(parseInt(retval)=='-100'){
				layer.alert('对象名称重复!',{icon: 0});
			}else {
				layer.msg('保存失败!',{icon: 2});
			}
		}
	}
}