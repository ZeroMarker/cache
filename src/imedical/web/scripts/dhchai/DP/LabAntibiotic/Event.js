//页面Event
function InitLabAntibioticWinEvent(obj){
	CheckSpecificKey();
	/*****搜索功能*****/
    $("#btnsearch").on('click', function(){
       $('#gridLabAntibiotic').DataTable().search($('#search').val(),true,true).draw();
       
    });
	
    $("#search").keyup(function(event){
        if (event.keyCode == 13) {
	        obj.gridLabAntibiotic.search(this.value).draw();
        }
    });
   /**********************/
    $("#btnEdit").addClass('disabled');
    $("#btnDelete").addClass('disabled');
	obj.gridLabAntibiotic.on('select', function(e, dt, type, indexes) {
		var selectedRows = dt.rows({selected: true}).count();
		$("#btnAdd").addClass('disabled');
		$("#btnEdit").removeClass('disabled');
		$("#btnDelete").removeClass('disabled');
	});
	
	obj.gridLabAntibiotic.on('deselect', function(e, dt, type, indexes) {
		var selectedRows = dt.rows({selected: true}).count();
		$("#btnAdd").removeClass('disabled');
        $("#btnEdit").addClass('disabled');
        $("#btnDelete").addClass('disabled');
	});
	
	obj.gridLabAntibiotic.on('dblclick', 'tr', function(e) {
		var rd = obj.gridLabAntibiotic.row(this).data();
		
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
		var selectedRows = obj.gridLabAntibiotic.rows({selected: true}).count();
		if ( selectedRows !== 1 ) return;
		var rd = obj.gridLabAntibiotic.rows({selected: true}).data().toArray()[0];
		
		obj.layer_rd = rd;
	    obj.Layer();
		
	});
	
	$("#btnDelete").on('click', function(){
		var flag = $("#btnDelete").hasClass("disabled");
		if(flag) return ;
		var selectedRows = obj.gridLabAntibiotic.rows({selected: true}).count();
		if ( selectedRows !== 1 ) return;
		var rd = obj.gridLabAntibiotic.rows({selected: true}).data().toArray()[0];
		
		var ID = rd["ID"];
		layer.confirm( '确认是否删除?', {
			btn: ['确认','取消'],    //btn位置对应function的位置
			btnAlign: 'c'
			},
			function(){ 
				var flg = $.Tool.RunServerMethod("DHCHAI.DP.LabAntibiotic","DeleteById",ID);
				if (parseInt(flg)<0){
					layer.msg('删除失败!',{icon: 2});
				} else {
					obj.gridLabAntibiotic.rows({selected:true}).remove().draw(false);
					layer.msg('删除成功!',{icon: 1});
				}
		 });
		
	});
	
	//抗生素编辑窗体-初始化
	obj.Layer = function(){
		$.form.iCheckRender();
		$.form.SelectRender('cboAntCat');	//渲染下拉框
		var rd = obj.layer_rd;
		
		if (rd){
			$.form.SetValue("txtAntCode",rd["AntCode"]);
			$.form.SetValue("txtAntDesc",rd["AntDesc"]);
			$.form.SetValue("cboAntCat",rd["CatID"],rd["ACDesc"]);
			$.form.SetValue("txtWCode",rd["WCode"]);
			$.form.SetValue("chkActive",rd["IsActive"]== 1);
		} else {
			$.form.SetValue("txtAntCode",'');   
			$.form.SetValue("txtAntDesc",''); 
			$.form.SetValue("cboAntCat",'');  
			$.form.SetValue("txtWCode",'');   
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
			title: '抗生素编辑', 
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
	//抗生素编辑窗体-保存
	obj.Layer_Save = function(){
		var rd = obj.layer_rd;
		var ID = (rd ? rd["ID"] : '');
		
		var AntCode   = $.form.GetValue("txtAntCode");
		var AntDesc   = $.form.GetValue("txtAntDesc");
		var AntCatDr  = $.form.GetValue("cboAntCat");
		var WCode     = $.form.GetValue("txtWCode");
		var IsActive  = $.form.GetValue("chkActive");
		
		var InputStr = ID;
		InputStr += "^" + AntCode;
		InputStr += "^" + AntDesc;
		InputStr += "^" + AntCatDr;
		InputStr += "^" + WCode;
		InputStr += "^" + IsActive;
		
		if (AntCode == '') {
			layer.alert("代码不允许为空",{icon: 0});
			return;
		}
		if (AntDesc == '') {
			layer.alert("名称不允许为空",{icon: 0});
			return;
		}
		/*
	    if (AntCatDr == '') {
			$.Tool.alert("分类不允许为空");
			return;
		}
        */
		var retval = $.Tool.RunServerMethod("DHCHAI.DP.LabAntibiotic","Update",InputStr);
		
		if (parseInt(retval)>0){
			obj.gridLabAntibiotic.ajax.reload(function(){
				var rowIndex = $.Tool.GetTableRowIndex(obj.gridLabAntibiotic,retval);
				if (rowIndex > -1){
					var rd =obj.gridLabAntibiotic.row(rowIndex).data();
					obj.layer_rd = rd;
				} else {
					obj.layer_rd = '';
				}
				layer.msg('保存成功!',{icon: 1});
			},false);
		} else {
			if(parseInt(retval)=='-100'){
				layer.alert('抗生素代码、名称不允许修改!',{icon: 0});
			}else {
				layer.msg('保存失败!',{icon: 2});
			}
		}
	}
	
	//抗生素编辑窗体-添加
	obj.Layer_Add = function(){
		var rd = "";
		var ID = (rd ? rd["ID"] : '');
		
		var AntCode   = $.form.GetValue("txtAntCode");
		var AntDesc   = $.form.GetValue("txtAntDesc");
		var AntCatDr  = $.form.GetValue("cboAntCat");
		var WCode     = $.form.GetValue("txtWCode");
		var IsActive  = $.form.GetValue("chkActive");
		
		var InputStr = ID;
		InputStr += "^" + AntCode;
		InputStr += "^" + AntDesc;
		InputStr += "^" + AntCatDr;
		InputStr += "^" + WCode;
		InputStr += "^" + IsActive;
		
		if (AntCode == '') {
			layer.alert("代码不允许为空",{icon: 0});
			return;
		}
		if (AntDesc == '') {
			layer.alert("名称不允许为空",{icon: 0});
			return;
		}
	    /*
		if (AntCatDr == '') {
			$.Tool.alert("分类不允许为空");
			return;
		}
		*/
		var retval = $.Tool.RunServerMethod("DHCHAI.DP.LabAntibiotic","Update",InputStr);
		
		if (parseInt(retval)>0){
			obj.gridLabAntibiotic.ajax.reload(function(){
				var rowIndex = $.Tool.GetTableRowIndex(obj.gridLabAntibiotic,retval);
				if (rowIndex > -1){
					var rd =obj.gridLabAntibiotic.row(rowIndex).data();
					obj.layer_rd = rd;
				} else {
					obj.layer_rd = '';
				}
				layer.msg('保存成功!',{icon: 1});
			},false);
		} else {
			if(parseInt(retval)=='-100'){
				layer.alert('抗生素代码、抗生素名称不允许重复!',{icon: 0});
			}else {
				layer.msg('保存失败!',{icon: 2});
			}
		}
	}
}