//页面Event
function InitCRuleLocArgsWinEvent(obj){
	CheckSpecificKey();
	/*****搜索功能*****/
    $("#btnsearch").on('click', function(){
       $('#gridCRuleLocArgs').DataTable().search($('#search').val(),true,true).draw();
       
    });
	
    $("#search").keyup(function(event){
        if (event.keyCode == 13) {
	        obj.gridCRuleLocArgs.search(this.value).draw();
        }
    });
   /**********************/

    $("#btnEdit").addClass('disabled');
    $("#btnDelete").addClass('disabled');
	obj.gridCRuleLocArgs.on('select', function(e, dt, type, indexes) {
		var selectedRows = dt.rows({selected: true}).count();
		$("#btnAdd").addClass('disabled');
		$("#btnEdit").removeClass('disabled');
		$("#btnDelete").removeClass('disabled');
	});
	
	obj.gridCRuleLocArgs.on('deselect', function(e, dt, type, indexes) {
		var selectedRows = dt.rows({selected: true}).count();
		$("#btnAdd").removeClass('disabled');
        $("#btnEdit").addClass('disabled');
        $("#btnDelete").addClass('disabled');
	});
	
	obj.gridCRuleLocArgs.on('dblclick', 'tr', function(e) {
		var rd = obj.gridCRuleLocArgs.row(this).data();
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
		var selectedRows = obj.gridCRuleLocArgs.rows({selected: true}).count();
		if ( selectedRows !== 1 ) return;
		var rd = obj.gridCRuleLocArgs.rows({selected: true}).data().toArray()[0];
		obj.layer_rd = rd;
	    obj.Layer();
	
		
	});
	
	$("#btnDelete").on('click', function(){
		var flag = $("#btnDelete").hasClass("disabled");
		if(flag) return ;
		var selectedRows = obj.gridCRuleLocArgs.rows({selected: true}).count();
		if ( selectedRows !== 1 ) return;
		var rd = obj.gridCRuleLocArgs.rows({selected: true}).data().toArray()[0];
		
		var ID = rd["ID"];
		layer.confirm( '确认是否删除?', {
			btn: ['确认','取消'],    //btn位置对应function的位置
			btnAlign: 'c'
			},
			function(){ 
				var flg = $.Tool.RunServerMethod("DHCHAI.IR.CRuleLocArgs","DeleteById",ID);
				if (parseInt(flg)<0){
					layer.msg('删除失败!',{icon: 2});
				} else {
					obj.gridCRuleLocArgs.rows({selected:true}).remove().draw(false);
					layer.msg('删除成功!',{icon: 1});
				}
		 });
		
	});
	
	// 科室参数设置-初始化
	obj.Layer = function(){
		$.form.SelectRender("#cboType");
		$.form.SelectRender("#cboLocation"); 
        var rd = obj.layer_rd;
		if (rd){
			$.form.SetValue("cboType",rd["Type"]);
			$.form.SetValue("cboLocation",rd["LocID"],rd["LocDesc"]);
			$.form.SetValue("txtFeverMax",rd["FeverMax"]);
			$.form.SetValue("txtFeverMin",rd["FeverMin"]);
			$.form.SetValue("txtDiarrMin",rd["DiarrMin"]);
			$.form.SetValue("txtDiarrMin2",rd["DiarrMin2"]);
		} else {
			$.form.SetValue("cboType",'');
			$.form.SetValue("cboLocation",'');
			$.form.SetValue("txtFeverMax",'');
			$.form.SetValue("txtFeverMin",'');
			$.form.SetValue("txtDiarrMin",'');
			$.form.SetValue("txtDiarrMin2",'');
		}
		
		layer.config({  
			extend: 'layerskin/style.css' 
		});
	
		layer.open({
			type: 1,
			zIndex: 100,
			area: '600px',
			skin: 'layer-class',
			title: '科室参数设置', 
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
	
	// 科室参数设置-保存
	 obj.Layer_Save = function(){
        var rd = obj.layer_rd;
		var ID = (rd ? rd["ID"] : '');
		var Type     = $.form.GetValue("cboType");
		var LocDr     = $.form.GetValue("cboLocation");
		var FeverMax  = $.form.GetValue("txtFeverMax");
		var FeverMin  = $.form.GetValue("txtFeverMin");
		var DiarrMin  = $.form.GetValue("txtDiarrMin");
		var DiarrMin2 = $.form.GetValue("txtDiarrMin2");
	
		if (LocDr== '') {
			layer.alert("科室不允许为空",{icon: 0});
			return;
		}
		if (FeverMax < FeverMin) {
			layer.alert("体温上限应高于体温下限",{icon: 0});
			return;
		}
		
		var InputStr = ID;
		InputStr += "^" + Type;
		InputStr += "^" + LocDr;
		InputStr += "^" + "";
		InputStr += "^" + "";
		InputStr += "^" + $.LOGON.USERID; 
		InputStr += "^" + FeverMax;
		InputStr += "^" + FeverMin;
		InputStr += "^" + DiarrMin;
		InputStr += "^" + DiarrMin2;
		
		var retval = $.Tool.RunServerMethod("DHCHAI.IR.CRuleLocArgs","Update",InputStr);
		if (parseInt(retval)>0){
			obj.gridCRuleLocArgs.ajax.reload(function(){
				var rowIndex = $.Tool.GetTableRowIndex(obj.gridCRuleLocArgs,retval);
				if (rowIndex > -1){
					var rd =obj.gridCRuleLocArgs.row(rowIndex).data();
					obj.layer_rd = rd;
				} else {
					obj.layer_rd = '';
				}
				layer.msg('保存成功!',{icon: 1});
			},false);
		} else {
			if(parseInt(retval)=='-100'){
				layer.alert('类型或科室重复!',{icon: 0});
			}else {
				layer.msg('保存失败!',{icon: 2});
			}
		}
	}
	
	// 科室参数设置-添加
	 obj.Layer_Add = function(){
		var rd = "";
		var ID = (rd ? rd["ID"] : '');
		var Type     = $.form.GetValue("cboType");
		var LocDr     = $.form.GetValue("cboLocation");
		var FeverMax  = $.form.GetValue("txtFeverMax");
		var FeverMin  = $.form.GetValue("txtFeverMin");
		var DiarrMin  = $.form.GetValue("txtDiarrMin");
		var DiarrMin2 = $.form.GetValue("txtDiarrMin2");
	
		if (LocDr== '') {
			layer.alert("科室不允许为空",{icon: 0});
			return;
		}
		if (FeverMax < FeverMin) {
			layer.alert("体温上限应高于体温下限",{icon: 0});
			return;
		}
		
		var InputStr = ID;
		InputStr += "^" + Type;
		InputStr += "^" + LocDr;
		InputStr += "^" + "";
		InputStr += "^" + "";
		InputStr += "^" + $.LOGON.USERID; 
		InputStr += "^" + FeverMax;
		InputStr += "^" + FeverMin;
		InputStr += "^" + DiarrMin;
		InputStr += "^" + DiarrMin2;
		
		var retval = $.Tool.RunServerMethod("DHCHAI.IR.CRuleLocArgs","Update",InputStr);
		if (parseInt(retval)>0){
			obj.gridCRuleLocArgs.ajax.reload(function(){
				var rowIndex = $.Tool.GetTableRowIndex(obj.gridCRuleLocArgs,retval);
				if (rowIndex > -1){
					var rd =obj.gridCRuleLocArgs.row(rowIndex).data();
					obj.layer_rd = rd;
				} else {
					obj.layer_rd = '';
				}
				layer.msg('保存成功!',{icon: 1});
			},false);
		} else {
			if(parseInt(retval)=='-100'){
				layer.alert('类型+科室重复!',{icon: 0});
			}else {
				layer.msg('保存失败!',{icon: 2});
			}
		}
	}
	
}