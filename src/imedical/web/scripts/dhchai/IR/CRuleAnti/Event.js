//页面Event
function InitCRuleAntiWinEvent(obj){
	CheckSpecificKey();
	layer.config({  
		extend: 'layerskin/style.css' 
	});
	
	//*********************** 抗菌用药列表 stt ***********************
	$("#btnsearch_two").on('click', function(){
       $('#gridCRuleAnti').DataTable().search($('#search_two').val(),true,true).draw();
    });
	
    $("#search_two").keyup(function(event){
        if (event.keyCode == 13) {
	        obj.gridCRuleAnti.search(this.value).draw();
        }
    });
	
    $("#btnEdit").addClass('disabled');
    $("#btnDelete").addClass('disabled');
	obj.gridCRuleAnti.on('select', function(e, dt, type, indexes) {
		var selectedRows = dt.rows({selected: true}).count();
		$("#btnAdd").addClass('disabled');
		$("#btnEdit").removeClass('disabled');
		$("#btnDelete").removeClass('disabled');
	});
	obj.gridCRuleAnti.on('deselect', function(e, dt, type, indexes) {
		var selectedRows = dt.rows({selected: true}).count();
		$("#btnAdd").removeClass('disabled');
        $("#btnEdit").addClass('disabled');
        $("#btnDelete").addClass('disabled');
	});
	obj.gridCRuleAnti.on('dblclick', 'tr', function(e) {
		var rd = obj.gridCRuleAnti.row(this).data();
		obj.AntiLayer_rd = rd;
		obj.Layer_two();
	});
	$("#btnAdd").on('click', function(){
		var flag = $("#btnAdd").hasClass("disabled");
		if(flag) return ;	
		obj.AntiLayer_rd = '';
		obj.Layer_two();
	});
	$("#btnEdit").on('click', function(){
		var selectedRows =  obj.gridCRuleAnti.rows({selected: true}).count();
		if ( selectedRows !== 1 ) return;
		var rd = obj.gridCRuleAnti.rows({selected: true}).data().toArray()[0];
		
		obj.AntiLayer_rd = rd;
	   	obj.Layer_two();
	});
	$("#btnDelete").on('click', function(){
		var selectedRows =  obj.gridCRuleAnti.rows({selected: true}).count();
		if ( selectedRows !== 1 ) return;
		var rd =  obj.gridCRuleAnti.rows({selected: true}).data().toArray()[0];
		
		var ID = rd["ID"];
		layer.confirm( '确认是否删除?', {
			btn: ['确认','取消'],    //btn位置对应function的位置
			btnAlign: 'c'
			},
			function(){ 
				var flg = $.Tool.RunServerMethod("DHCHAI.IR.CRuleAnti","DeleteById",ID);
				if (parseInt(flg)<0){
					layer.msg('删除失败!',{icon: 2});
				} else {
					obj.gridCRuleAnti.rows({selected:true}).remove().draw(false);
					layer.msg('删除成功!',{icon: 1});
				}
			}
		 );
	});
	obj.Layer_two = function(){
		$.form.SelectRender("#cboType");
		$.form.SelectRender("#cboLocation");
		$.form.SelectRender("#cboAntiCat");
		$.form.SelectRender("#cboAntiMast");
		$.form.iCheckRender();
		
		var rd = obj.AntiLayer_rd;
		if (rd){
			$.form.SetValue("cboType",rd["Type"]);
			$.form.SetValue("cboLocation",rd["LocID"],rd["LocDesc"]);
			$.form.SetValue("cboAntiCat",rd["AntiCatID"],rd["AntiCatDesc"]);
			$.form.SetValue("cboAntiMast",rd["AntiMastID"],rd["AntiMastDesc"]);
			$.form.SetValue("chkActive",(rd["IsActive"]==1));
		} else {
			$.form.SetValue("cboType",'');
			$.form.SetValue("cboLocation",'');
			$.form.SetValue("cboAntiCat","","");
			$.form.SetValue("cboAntiMast","","");
			$.form.SetValue("chkActive",true);
		}
		
		layer.open({
			type: 1,
			zIndex: 100,
			area: '600px',
			skin: 'layer-class',
			title: '抗菌用药信息编辑',
			content: $('#layer_two'),
			btn: ['添加','保存','关闭'],
			btnAlign: 'c',
			yes: function(index, layero){
			  	obj.LayerTwo_Add();
			},
			btn2: function(index, layero){
				obj.LayerTwo_Save();
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
	//保存抗菌用药信息
	obj.LayerTwo_Save = function(){
		var rdOperDx = obj.AntiLayer_rd;
		var ID = (rdOperDx ? rdOperDx["ID"] : '');
		var Type       = $.form.GetValue("cboType");
		var LocDr      = $.form.GetValue("cboLocation");
		var AntiCatDr  = $.form.GetValue("cboAntiCat");
		var AntiMastDr = $.form.GetValue("cboAntiMast");
		var IsActive   = $.form.GetValue("chkActive");
		
		if (LocDr== '') {
			layer.alert("科室不允许为空",{icon: 0});
			return;
		}
		if (AntiCatDr== '') {
			layer.alert("抗生素分类不允许为空",{icon: 0});
			return;
		}
		if (AntiMastDr== '') {
			layer.alert("抗菌用药不允许为空",{icon: 0});
			return;
		}
		
		var InputStr = ID;
		InputStr += "^" + Type;
		InputStr += "^" + $.LOGON.HOSPGRPID;
		InputStr += "^" + $.LOGON.HOSPID;
		InputStr += "^" + LocDr;
		InputStr += "^" + AntiCatDr;
		InputStr += "^" + AntiMastDr;
		InputStr += "^" + "";
		InputStr += "^" + IsActive;
		InputStr += "^" + '';
		InputStr += "^" + '';
		InputStr += "^" + $.LOGON.USERID;
		
		var retval =  $.Tool.RunServerMethod("DHCHAI.IR.CRuleAnti","Update",InputStr);
		if (parseInt(retval)>0){
			obj.gridCRuleAnti.ajax.reload(function(){
				var rowIndex =  $.Tool.GetTableRowIndex(obj.gridCRuleAnti,retval);
				if (rowIndex > -1){
					var rd =obj.gridCRuleAnti.row(rowIndex).data();
					obj.AntiLayer_rd = rd;
				} else {
					obj.AntiLayer_rd = '';
				}
				layer.msg('保存成功!',{icon: 1});
			},false);
		} else {
			if(parseInt(retval)=='-100'){
				layer.alert('抗菌用药维护重复!',{icon: 0});
			}else {
				layer.msg('保存失败!',{icon: 2});
			}
		}
	}
	// 添加抗菌用药信息
	obj.LayerTwo_Add = function(){
		var rdOperDx = "";
		var ID = (rdOperDx ? rdOperDx["ID"] : '');
		var Type      = $.form.GetValue("cboType");
		var LocDr     = $.form.GetValue("cboLocation");
		var AntiCatDr = $.form.GetValue("cboAntiCat");
		var AntiMastDr  = $.form.GetValue("cboAntiMast");
		var IsActive  = $.form.GetValue("chkActive");
		
		if (LocDr== '') {
			layer.alert("科室不允许为空",{icon: 0});
			return;
		}
		if (AntiCatDr== '') {
			layer.alert("抗生素分类不允许为空",{icon: 0});
			return;
		}
		if (AntiMastDr== '') {
			layer.alert("抗菌用药不允许为空",{icon: 0});
			return;
		}
		
		var InputStr = ID;
		InputStr += "^" + Type;
		InputStr += "^" + $.LOGON.HOSPGRPID;
		InputStr += "^" + $.LOGON.HOSPID;
		InputStr += "^" + LocDr;
		InputStr += "^" + AntiCatDr;
		InputStr += "^" + AntiMastDr;
		InputStr += "^" + "";
		InputStr += "^" + IsActive;
		InputStr += "^" + '';
		InputStr += "^" + '';
		InputStr += "^" + $.LOGON.USERID;
		
		var retval =  $.Tool.RunServerMethod("DHCHAI.IR.CRuleAnti","Update",InputStr);
		if (parseInt(retval)>0){
			obj.gridCRuleAnti.ajax.reload(function(){
				var rowIndex =  $.Tool.GetTableRowIndex(obj.gridCRuleAnti,retval);
				if (rowIndex > -1){
					var rd =obj.gridCRuleAnti.row(rowIndex).data();
					obj.AntiLayer_rd = rd;
				} else {
					obj.AntiLayer_rd = '';
				}
				layer.msg('保存成功!',{icon: 1});
			},false);
		} else {
			if(parseInt(retval)=='-100'){
				layer.alert('抗菌用药维护重复!',{icon: 0});
			}else {
				layer.msg('保存失败!',{icon: 2});
			}
		}
	}
	//*********************** 抗菌用药列表 end ***********************
}
