//页面Event
function InitSystemMapWinEvent(obj){
	$.form.iCheckRender();
	CheckSpecificKey();
	/*****搜索功能*****/
    $("#btnsearch").on('click', function(){
       $('#gridSystemMap').DataTable().search($('#search').val(),true,true).draw();
       
    });
	
    $("#search").keyup(function(event){
        if (event.keyCode == 13) {
	        obj.gridSystemMap.search(this.value).draw();
        }
    });
    /****************/
    $("#btnEdit").addClass('disabled');
    $("#btnDelete").addClass('disabled');
	obj.gridSystemMap.on('select', function(e, dt, type, indexes) {
		var selectedRows = dt.rows({selected: true}).count();
		$("#btnAdd").addClass('disabled');
		$("#btnEdit").removeClass('disabled');
		$("#btnDelete").removeClass('disabled');
	});
	
	obj.gridSystemMap.on('deselect', function(e, dt, type, indexes) {
		var selectedRows = dt.rows({selected: true}).count();
		$("#btnAdd").removeClass('disabled');
        $("#btnEdit").addClass('disabled');
        $("#btnDelete").addClass('disabled');
	});
	
	obj.gridSystemMap.on('dblclick', 'tr', function(e) {
		var rd = obj.gridSystemMap.row(this).data();
		
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
		var selectedRows = obj.gridSystemMap.rows({selected: true}).count();
		if ( selectedRows !== 1 ) return;
		var rd = obj.gridSystemMap.rows({selected: true}).data().toArray()[0];
		
		obj.layer_rd = rd;
		obj.Layer();
	});
	
	
	$("#btnDelete").on('click', function(){
		var flag = $("#btnDelete").hasClass("disabled");
		if(flag) return ;
		var selectedRows = obj.gridSystemMap.rows({selected: true}).count();
		if ( selectedRows !== 1 ) return;
		var rd =  obj.gridSystemMap.rows({selected: true}).data().toArray()[0];
		
		var ID = rd["ID"];
		layer.confirm( '确认是否删除?', {
			btn: ['确认','取消'],    //btn位置对应function的位置
			btnAlign: 'c'
			},
			function(){ 
				var flg = $.Tool.RunServerMethod("DHCHAI.BT.SystemMap","DeleteById",ID);
				if (parseInt(flg)<0){
					layer.msg('删除失败!',{icon: 2});
				} else {
					obj.gridSystemMap.rows({selected:true}).remove().draw(false);
					layer.msg('删除成功!',{icon: 1});
				}
		 });
	});
	
	//子系统对照编辑窗体-初始化
	obj.Layer = function(){	
		var rd = obj.layer_rd;
		$.form.SelectRender('#layer');	
		if (rd){
			$.form.SetValue("txtSysCode",rd["Code"]);
			$.form.SetValue("txtSysDesc",rd["Desc"]);
			$.form.SetValue("txtHISCode",rd["HISCode"]);
			$.form.SetValue("cboType",rd["SysID"],rd["SysDesc"]);
			$.form.SetValue("cboHosp",rd["HospID"],rd["HospDesc"]);
			$.form.SetValue("chkActive",rd["IsActive"]== 1);
		} else {
			$.form.SetValue("txtSysCode",'');
			$.form.SetValue("txtSysDesc",'');
			$.form.SetValue("txtHISCode",'');
			$.form.SetValue("cboType",'');
			$.form.SetValue("cboHosp",'');
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
			title: '子系统定义维护编辑', 
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
	
	//子系统对照编辑窗体-保存
	obj.Layer_Save = function(){
		var rd = obj.layer_rd;
		var ID = (rd ? rd["ID"] : '');
		
		var SysCode = $.form.GetValue("txtSysCode");
		var SysDesc = $.form.GetValue("txtSysDesc");
		var HISCode = $.form.GetValue("txtHISCode");
		var TypeDr = $.form.GetValue("cboType");
		var HospDr = $.form.GetValue("cboHosp");
        var IsActive = $.form.GetValue("chkActive");
		
		if (SysCode == '') {
			layer.alert("系统代码不允许为空",{icon: 0});
			return;
		}
		if (SysDesc == '') {
			layer.alert("系统名称不允许为空",{icon: 0});
			return;
		}
		if (HISCode == '') {
			layer.alert("HIS关联码不允许为空",{icon: 0});
			return;
		}
		if (TypeDr == '') {
			layer.alert("系统分类不允许为空",{icon: 0});
			return;
		}
		if (HospDr == '') {
			layer.alert("医院选择不允许为空",{icon: 0});
			return;
		}
		
		var InputStr = ID;
		InputStr += "^" + SysCode; // 子系统代码
		InputStr += "^" + SysDesc; // 子系统名称 
		InputStr += "^" + HISCode; // HIS关联码
		InputStr += "^" + TypeDr;  // 系统类型 
		InputStr += "^" + HospDr;  // 医院 
		InputStr += "^" + IsActive;
		InputStr += "^" + "";      // 处置日期
		InputStr += "^" + "";      // 处置时间
		InputStr += "^" + $.LOGON.USERID; // 处置人
		
		var retval = $.Tool.RunServerMethod("DHCHAI.BT.SystemMap","Update",InputStr);
		if (parseInt(retval)>0){
			obj.gridSystemMap.ajax.reload(function(){
				var rowIndex = $.Tool.GetTableRowIndex(obj.gridSystemMap,retval);
				if (rowIndex > -1){
					var rd =obj.gridSystemMap.row(rowIndex).data();
					obj.layer_rd = rd;
				} else {
					obj.layer_rd = '';
				}
				layer.msg('保存成功!',{icon: 1});
			},false);
		} else {
			layer.msg('保存失败!',{icon: 2});
		}
	}
	
	//子系统对照编辑窗体-提交
	obj.Layer_Add = function(){
		var rd = "";
		var ID = (rd ? rd["ID"] : '');
		
		var SysCode = $.form.GetValue("txtSysCode");
		var SysDesc = $.form.GetValue("txtSysDesc");
		var HISCode = $.form.GetValue("txtHISCode");
		var TypeDr = $.form.GetValue("cboType");
		var HospDr = $.form.GetValue("cboHosp");
		var IsActive = $.form.GetValue("chkActive");
		
		if (SysCode == '') {
			layer.alert("系统代码不允许为空",{icon: 0});
			return;
		}
		if (SysDesc == '') {
			layer.alert("系统名称不允许为空",{icon: 0});
			return;
		}
		if (HISCode == '') {
			layer.alert("HIS关联码不允许为空",{icon: 0});
			return;
		}
		if (TypeDr == '') {
			layer.alert("系统分类不允许为空",{icon: 0});
			return;
		}
		if (HospDr == '') {
			layer.alert("医院选择不允许为空",{icon: 0});
			return;
		}
		var InputStr = ID;
		InputStr += "^" + SysCode; // 子系统代码
		InputStr += "^" + SysDesc; // 子系统名称 
		InputStr += "^" + HISCode; // HIS关联码
		InputStr += "^" + TypeDr;  // 系统类型 
		InputStr += "^" + HospDr;  // 医院 
		InputStr += "^" + IsActive;
		InputStr += "^" + "";      // 处置日期
		InputStr += "^" + "";      // 处置时间
		InputStr += "^" + $.LOGON.USERID; // 处置人
		
		var retval = $.Tool.RunServerMethod("DHCHAI.BT.SystemMap","Update",InputStr);
		if (parseInt(retval)>0){
			obj.gridSystemMap.ajax.reload(function(){
				var rowIndex = $.Tool.GetTableRowIndex(obj.gridSystemMap,retval);
				if (rowIndex > -1){
					var rd =obj.gridSystemMap.row(rowIndex).data();
					obj.layer_rd = rd;
				} else {
					obj.layer_rd = '';
				}
				layer.msg('保存成功!',{icon: 1});
			},false);
		} else {
			layer.msg('保存失败!',{icon: 2});
		}
	}
}