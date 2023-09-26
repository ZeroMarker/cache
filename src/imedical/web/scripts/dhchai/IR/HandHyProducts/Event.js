function InitHHProductsWinEvent(obj){
	CheckSpecificKey();
	layer.config({  
		extend: 'layerskin/style.css' 
	});
	
   /*****搜索*****/
    $("#btnsearch").on('click', function(){
       $('#gridHHProducts').DataTable().search($('#search').val(),true,true).draw();
       
    });
	
    $("#search").keyup(function(event){
        if (event.keyCode == 13) {
	        obj.gridHHProducts.search(this.value).draw();
        }
    });
   /**********************/
    $("#btnEdit").addClass('disabled');
    $("#btnDelete").addClass('disabled');
	obj.gridHHProducts.on('select', function(e, dt, type, indexes) {
		var selectedRows = dt.rows({selected: true}).count();
		$("#btnAdd").addClass('disabled');
		$("#btnEdit").removeClass('disabled');
		$("#btnDelete").removeClass('disabled');
		
	});
	
	obj.gridHHProducts.on('deselect', function(e, dt, type, indexes) {
		var selectedRows = dt.rows({selected: true}).count();
		$("#btnAdd").removeClass('disabled');
        $("#btnEdit").addClass('disabled');
        $("#btnDelete").addClass('disabled');
       
	});
	
	obj.gridHHProducts.on('dblclick', 'tr', function(e) {
		var rd = obj.gridHHProducts.row(this).data();
		
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
		var selectedRows = obj.gridHHProducts.rows({selected: true}).count();
		if ( selectedRows !== 1 ) return;
		var rd = obj.gridHHProducts.rows({selected: true}).data().toArray()[0];
		
		obj.layer_rd = rd;
	    obj.Layer();
		
	});
	
	$("#btnDelete").on('click', function(){
		var flag = $("#btnDelete").hasClass("disabled");
		if(flag) return ;
		var selectedRows = obj.gridHHProducts.rows({selected: true}).count();
		if ( selectedRows !== 1 ) return;
		var rd = obj.gridHHProducts.rows({selected: true}).data().toArray()[0];
		
		var ID = rd["ID"];
		layer.confirm( '确认是否删除?', {
			btn: ['确认','取消'],    //btn位置对应function的位置
			btnAlign: 'c'
			},
			function(){ 
				var flg = $.Tool.RunServerMethod("DHCHAI.IR.HandHyProducts","DeleteById",ID);
				if ((parseInt(flg)==-1)){
					layer.msg('删除失败!',{icon: 2});
				} else if((parseInt(flg)==-2)){
					layer.msg('该记录已被"手卫生用品消耗登记表"引用，不能删除!',{icon: 2});
				} else if ((parseInt(flg)>=0)){
					obj.gridHHProducts.rows({selected:true}).remove().draw(false);
					layer.msg('删除成功!',{icon: 1});
				}
				/*if (parseInt(flg)<0){
					layer.msg('删除失败!',{icon: 2});
				} else {
					obj.gridHHProducts.rows({selected:true}).remove().draw(false);
					layer.msg('删除成功!',{icon: 1});
				}*/
		 });
	});
	
	// 手卫生用品
	obj.Layer = function(){
		$.form.iCheckRender();
		$.form.SelectRender('cboUnit');
		var rd = obj.layer_rd;
		if (rd){
			$.form.SetValue("txtCode",rd["HHPCode"]);
			$.form.SetValue("txtDesc",rd["HHPDesc"]);
			$.form.SetValue("txtPinyin",rd["HHPPinyin"]);
			$.form.SetValue("txtSpec",rd["HHPSpec"]);
			$.form.SetValue("cboUnit",rd["UnitDr"],rd["UnitDesc"]);
			$.form.SetValue("txtAvgAmount",rd["AvgAmount"]);
			$.form.SetValue("txtResume",rd["Resume"]);
			$.form.SetValue("chkIsActive",rd["IsActive"]== 1);
		} else {
			$.form.SetValue("txtCode",'');
			$.form.SetValue("txtDesc",'');
			$.form.SetValue("txtPinyin",'');
			$.form.SetValue("txtSpec",'');
			$.form.SetValue("cboUnit",'');
			$.form.SetValue("txtAvgAmount",'3');
			$.form.SetValue("txtResume",'');
			$.form.SetValue("chkIsActive",true);
		}
		
		layer.open({
			type: 1,
			zIndex: 100,
			area: '600px',
			skin: 'layer-class',
			title: '手卫生用品编辑', 
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
	//手卫生用品-保存
	obj.Layer_Save = function(){
		var rd = obj.layer_rd;
		var ID = (rd ? rd["ID"] : '');
		
		var Code      = $.form.GetValue("txtCode");
		var Desc      = $.form.GetValue("txtDesc");
		var Pinyin    = $.form.GetValue("txtPinyin");
		var Spec      = $.form.GetValue("txtSpec");
		var UnitDr    = $.form.GetValue("cboUnit");
		var AvgAmount = $.form.GetValue("txtAvgAmount");
		var Resume    = $.form.GetValue("txtResume");
		var IsActive  = $.form.GetValue("chkIsActive");
		
		var ErrorStr = "";
		if (Code == '') {
			ErrorStr += '代码不允许为空！<br/>';	
		}
		if (Desc == '') {
			ErrorStr += '名称不允许为空！<br/>';
		}
		if (Spec == '') {
			ErrorStr += '规格不允许为空！<br/>';
		}
		if (UnitDr == '') {
			ErrorStr += '单位不允许为空！<br/>';
		}
		if (AvgAmount == '') {
			ErrorStr += '次均用量不允许为空！<br/>';
		}
		if (ErrorStr != '') {
			layer.alert(ErrorStr,{icon: 0});
			return;
		}
		
		var InputStr = ID;
		InputStr += "^" + Code;
		InputStr += "^" + Desc;
		InputStr += "^" + Pinyin;
		InputStr += "^" + Spec;
		InputStr += "^" + UnitDr;
		InputStr += "^" + AvgAmount;
		InputStr += "^" + IsActive;
		InputStr += "^" + Resume;
		
		var retval = $.Tool.RunServerMethod("DHCHAI.IR.HandHyProducts","Update",InputStr);
		if (parseInt(retval)>0){
			obj.gridHHProducts.ajax.reload(function(){
				var rowIndex = $.Tool.GetTableRowIndex(obj.gridHHProducts,retval);
				if (rowIndex > -1){
					var rd =obj.gridHHProducts.row(rowIndex).data();
					obj.layer_rd = rd;
				} else {
					obj.layer_rd = '';
				}
				layer.msg('保存成功!',{icon: 1});
			},false);
		} else {
			if(parseInt(retval)=='-100'){
				layer.alert('名称重复！',{icon: 0});
			}else if(parseInt(retval)=='-101'){
				layer.alert('代码重复！',{icon: 0});
			}else {
				layer.msg('保存失败',{icon: 2});
			}
		}
	}
	// 手卫生用品-添加
	obj.Layer_Add = function(){
		var rd = "";
		var ID = (rd ? rd["ID"] : '');
		
		var Code      = $.form.GetValue("txtCode");
		var Desc      = $.form.GetValue("txtDesc");
		var Pinyin    = $.form.GetValue("txtPinyin");
		var Spec      = $.form.GetValue("txtSpec");
		var UnitDr    = $.form.GetValue("cboUnit");
		var AvgAmount = $.form.GetValue("txtAvgAmount");
		var Resume    = $.form.GetValue("txtResume");
		var IsActive  = $.form.GetValue("chkIsActive");
		
		var ErrorStr = "";
		if (Code == '') {
			ErrorStr += '代码不允许为空！<br/>';	
		}
		if (Desc == '') {
			ErrorStr += '名称不允许为空！<br/>';
		}
		if (Spec == '') {
			ErrorStr += '规格不允许为空！<br/>';
		}
		if (UnitDr == '') {
			ErrorStr += '单位不允许为空！<br/>';
		}
		if (AvgAmount == '') {
			ErrorStr += '次均用量不允许为空！<br/>';
		}
		if (ErrorStr != '') {
			layer.alert(ErrorStr,{icon: 0});
			return;
		}
		
		var InputStr = ID;
		InputStr += "^" + Code;
		InputStr += "^" + Desc;
		InputStr += "^" + Pinyin;
		InputStr += "^" + Spec;
		InputStr += "^" + UnitDr;
		InputStr += "^" + AvgAmount;
		InputStr += "^" + IsActive;
		InputStr += "^" + Resume;
		
		var retval = $.Tool.RunServerMethod("DHCHAI.IR.HandHyProducts","Update",InputStr);
		if (parseInt(retval)>0){
			obj.gridHHProducts.ajax.reload(function(){
				var rowIndex = $.Tool.GetTableRowIndex(obj.gridHHProducts,retval);
				if (rowIndex > -1){
					var rd =obj.gridHHProducts.row(rowIndex).data();
					obj.layer_rd = rd;
				} else {
					obj.layer_rd = '';
				}
				layer.msg('保存成功!',{icon: 1});
			},false);
		} else {
			if(parseInt(retval)=='-100'){
				layer.alert('名称重复！',{icon: 0});
			}else if(parseInt(retval)=='-101'){
				layer.alert('代码重复！',{icon: 0});
			}else {
				layer.msg('保存失败',{icon: 2});
			}
		}
	}
}