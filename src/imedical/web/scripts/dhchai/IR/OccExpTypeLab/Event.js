//页面Event
function InitExpTypeLabWinEvent(obj){
	$.form.iCheckRender();
	CheckSpecificKey();
	/*****搜索功能*****/
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
		layer.confirm( '确认是否删除?', {
			btn: ['确认','取消'],    //btn位置对应function的位置
			btnAlign: 'c'
			},
			function(){ 
				var flg = $.Tool.RunServerMethod("DHCHAI.IR.OccExpTypeLab","DeleteById",ID);
				if (parseInt(flg)<0){
					layer.msg('删除失败!',{icon: 2});
				} else {
					obj.gridExpTypeLab.rows({selected:true}).remove().draw(false);
					layer.msg('删除成功!',{icon: 1});
				}
		 });
		
	});
	//控制时间间隔仅为数字
	$('#txtDays').on('keyup', function() {
		$(this).val($(this).val().replace(/[^\d]/g,''));
	});
	
	//职业暴露血清学计划窗体-初始化
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
			title: '职业暴露血清学计划编辑', 
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
	
	//职业暴露血清学计划窗体-保存
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
			layer.alert("检查时机不允许为空",{icon: 0});
			return;
		}
    if (Days== '') {
			layer.alert("时间间隔不允许为空",{icon: 0});
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
				layer.msg('保存成功!',{icon: 1});
			},false);
		} else {
			if(parseInt(retval)=='-2'){
				layer.alert('检查时机重复!',{icon: 0});
			}else {
				layer.msg('保存失败!',{icon: 2});
			}
		}
	}
	
	//职业暴露血清学计划窗体-添加
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
			layer.alert("检查时机不允许为空",{icon: 0});
			return;
		}
    if (Days== '') {
			layer.alert("时间间隔不允许为空",{icon: 0});
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
				layer.msg('保存成功!',{icon: 1});
			},false);
		} else {
			if(parseInt(retval)=='-2'){
				layer.alert('检查时机重复!',{icon: 0});
			}else {
				layer.msg('保存失败!',{icon: 2});
			}
		}
	}
	
}