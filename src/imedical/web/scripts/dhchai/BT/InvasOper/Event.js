//页面Event
function InitInvasOperWinEvent(obj){
	CheckSpecificKey();
	/*****搜索功能*****/
    $("#btnsearch").on('click', function(){
       $('#gridInvasOper').DataTable().search($('#search').val(),true,true).draw();
       
    });
	
    $("#search").keyup(function(event){
        if (event.keyCode == 13) {
	        obj.gridInvasOper.search(this.value).draw();
        }
    });
    /****************/
    $("#btnEdit").addClass('disabled');
    $("#btnDelete").addClass('disabled');
	obj.gridInvasOper.on('select', function(e, dt, type, indexes) {
		var selectedRows = dt.rows({selected: true}).count();
		$("#btnAdd").addClass('disabled');
		$("#btnEdit").removeClass('disabled');
		$("#btnDelete").removeClass('disabled');
	});
	
	obj.gridInvasOper.on('deselect', function(e, dt, type, indexes) {
		var selectedRows = dt.rows({selected: true}).count();
		$("#btnAdd").removeClass('disabled');
        $("#btnEdit").addClass('disabled');
        $("#btnDelete").addClass('disabled');
	});
	
	obj.gridInvasOper.on('dblclick', 'tr', function(e) {
		var rd = obj.gridInvasOper.row(this).data();
		
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
		var selectedRows = obj.gridInvasOper.rows({selected: true}).count();
		if ( selectedRows !== 1 ) return;
		var rd = obj.gridInvasOper.rows({selected: true}).data().toArray()[0];
		
		obj.layer_rd = rd;
		obj.Layer();
	});
	
	$("#btnDelete").on('click', function(){
		var flag = $("#btnDelete").hasClass("disabled");
		if(flag) return ;
		var selectedRows = obj.gridInvasOper.rows({selected: true}).count();
		if ( selectedRows !== 1 ) return;
		var rd = obj.gridInvasOper.rows({selected: true}).data().toArray()[0];
		
		var ID = rd["ID"];
		layer.confirm( '确认是否删除?', {
			btn: ['确认','取消'],    //btn位置对应function的位置
			btnAlign: 'c'
			},
			function(){ 
				var flg = $.Tool.RunServerMethod("DHCHAI.BT.InvasOper","DeleteById",ID);
				if (parseInt(flg)<0){
					layer.msg('删除失败!',{icon: 2});
				} else {
					obj.gridInvasOper.rows({selected:true}).remove().draw(false);
					layer.msg('删除成功!',{icon: 1});
				}
		 });
	});
	
	//侵害性操作编辑窗体-初始化
	obj.Layer = function(){
		$.form.iCheckRender();
		
		var rd = obj.layer_rd;
		if (rd){
			$.form.SetValue("txtCode",rd["BTCode"]);
			$.form.SetValue("txtDesc",rd["BTDesc"]);
			$.form.SetValue("txtIndNo",rd["BTIndNo"]);
			$.form.SetValue("chkIsActive",(rd["BTIsActive"] == '是'));
		} else {
			$.form.SetValue("txtCode",'');
			$.form.SetValue("txtDesc",'');
			$.form.SetValue("txtIndNo",'');
			$.form.SetValue("chkIsActive",'');
		}
		
		layer.config({  
			extend: 'layerskin/style.css' 
		});
	
		layer.open({
			type: 1,
			zIndex: 100,
			area: '600px',
			skin: 'layer-class',
			title: '侵害性操作编辑', 
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
	
	//侵害性操作编辑窗体-保存
	obj.Layer_Save = function(){
		var rd = obj.layer_rd;
		var ID = (rd ? rd["ID"] : '');
		
		var IOCode = $.form.GetValue("txtCode");
		var IODesc = $.form.GetValue("txtDesc");
		var IOIndNo = $.form.GetValue("txtIndNo");
		var IOIsActive = $.form.GetValue("chkIsActive");
		
		if (IOCode == '') {
			layer.alert("代码不允许为空",{icon: 0});
			return;
		}
		if (IODesc == '') {
			layer.alert("名称不允许为空",{icon: 0});
			return;
		}
		
		var InputStr = ID;
		InputStr += "^" + IOCode;
		InputStr += "^" + IODesc;
		InputStr += "^" + IOIndNo;
		InputStr += "^" + IOIsActive;
		
		var retval = $.Tool.RunServerMethod("DHCHAI.BT.InvasOper","Update",InputStr);
		if (parseInt(retval)>0){
			obj.gridInvasOper.ajax.reload(function(){
				var rowIndex = $.Tool.GetTableRowIndex(obj.gridInvasOper,retval);
				if (rowIndex > -1){
					var rd =obj.gridInvasOper.row(rowIndex).data();
					obj.layer_rd = rd;
				} else {
					obj.layer_rd = '';
				}
			layer.msg('保存成功!',{icon: 1});
			},false);
		} else {
			if(parseInt(retval)=='-2'){
				layer.alert('代码重复!',{icon: 0});
			}else {
				layer.msg('保存失败!',{icon: 2});
			}
		}
	}
	
	//侵害性操作编辑窗体-提交
	obj.Layer_Add = function(){
		var rd = "";
		var ID = (rd ? rd["ID"] : '');
		
		var IOCode = $.form.GetValue("txtCode");
		var IODesc = $.form.GetValue("txtDesc");
		var IOIndNo = $.form.GetValue("txtIndNo");
		var IOIsActive = $.form.GetValue("chkIsActive");
		
		if (IOCode == '') {
			layer.alert("代码不允许为空",{icon: 0});
			return;
		}
		if (IODesc == '') {
			layer.alert("名称不允许为空",{icon: 0});
			return;
		}
		
		var InputStr = ID;
		InputStr += "^" + IOCode;
		InputStr += "^" + IODesc;
		InputStr += "^" + IOIndNo;
		InputStr += "^" + IOIsActive;
		
		var retval = $.Tool.RunServerMethod("DHCHAI.BT.InvasOper","Update",InputStr);
		if (parseInt(retval)>0){
			obj.gridInvasOper.ajax.reload(function(){
				var rowIndex = $.Tool.GetTableRowIndex(obj.gridInvasOper,retval);
				if (rowIndex > -1){
					var rd =obj.gridInvasOper.row(rowIndex).data();
					obj.layer_rd = rd;
				} else {
					obj.layer_rd = '';
				}
				layer.msg('保存成功!',{icon: 1});
			},false);
		} else {
			if(parseInt(retval)=='-2'){
				layer.alert('代码重复!',{icon: 0});
			}else {
				layer.msg('保存失败!',{icon: 2});
			}
		}
	}
}