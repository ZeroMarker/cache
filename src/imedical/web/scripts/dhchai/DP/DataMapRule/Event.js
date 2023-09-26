//页面Event
function InitMapRuleWinEvent(obj){
	CheckSpecificKey();
	$.form.SelectRender("cboCat");  //渲染下拉框
	$('#cboCat').on('change',function(){
		/*
		var CatId = $.form.GetValue('cboCat');
		if (CatId == ''){
			layer.alert('请选择分类!',{icon: 0});
			return;
		}
		*/
		obj.gridMapRule.ajax.reload();
	});
	/*****搜索功能*****/
    $("#btnsearch").on('click', function(){
       $('#gridMapRule').DataTable().search($('#search').val(),true,true).draw();
       
    });
	
    $("#search").keyup(function(event){
        if (event.keyCode == 13) {
	        obj.gridMapRule.search(this.value).draw();
        }
    });
   /**********************/
    $("#btnEdit").addClass('disabled');
    $("#btnDelete").addClass('disabled');
	obj.gridMapRule.on('select', function(e, dt, type, indexes) {
		var selectedRows = dt.rows({selected: true}).count();
		$("#btnAdd").addClass('disabled');
		$("#btnEdit").removeClass('disabled');
		$("#btnDelete").removeClass('disabled');
	});
	
	obj.gridMapRule.on('deselect', function(e, dt, type, indexes) {
		var selectedRows = dt.rows({selected: true}).count();
		$("#btnAdd").removeClass('disabled');
        $("#btnEdit").addClass('disabled');
        $("#btnDelete").addClass('disabled');
	});
	
	obj.gridMapRule.on('dblclick', 'tr', function(e) {
		var CatId = $.form.GetValue('cboCat');
		if (CatId == ''){
			layer.alert('请先选择分类，再添加数据!',{icon: 0});
			return;
		}
		var rd = obj.gridMapRule.row(this).data();
		
		obj.layer_rd = rd;
		obj.Layer();
	    
	});
	
	$("#btnAdd").on('click', function(){
		var flag = $("#btnAdd").hasClass("disabled");
		if(flag) return ;
		var CatId = $.form.GetValue('cboCat');
		if (CatId == ''){
			layer.alert('请选择分类!',{icon: 0});
			return;
		}	
		obj.layer_rd = '';
		obj.Layer();
		
	});
	
	$("#btnEdit").on('click', function(){
		var flag = $("#btnEdit").hasClass("disabled");
		if(flag) return ;
		var selectedRows = obj.gridMapRule.rows({selected: true}).count();
		if ( selectedRows !== 1 ) return;
		var CatId = $.form.GetValue('cboCat');
		if (CatId == ''){
			layer.alert('请选择分类!',{icon: 0});
			return;
		}
		var rd = obj.gridMapRule.rows({selected: true}).data().toArray()[0];	
		obj.layer_rd = rd;
	    obj.Layer();
	
	});
	
	$("#btnDelete").on('click', function(){
		var flag = $("#btnDelete").hasClass("disabled");
		if(flag) return ;
	
		var selectedRows = obj.gridMapRule.rows({selected: true}).count();
		if ( selectedRows !== 1 ) return;
		var rd = obj.gridMapRule.rows({selected: true}).data().toArray()[0];
		
		var ID = rd["ID"];
		layer.confirm( '确认是否删除?', {
			btn: ['确认','取消'],    //btn位置对应function的位置
			btnAlign: 'c'
			},
			function(){ 
				var flg = $.Tool.RunServerMethod("DHCHAI.DP.DataMapRule","DeleteById",ID);
				if (parseInt(flg)<0){
					layer.msg('删除失败!',{icon: 2});
				} else {
					obj.gridMapRule.rows({selected:true}).remove().draw(false);
					layer.msg('删除成功!',{icon: 1});
				}
		 });
	});
	
	//对照匹配规则窗体-初始化
	obj.Layer = function(){	
        $.form.SelectRender('cboType');	
		var rd = obj.layer_rd;
		if (rd){
			$.form.SetValue("txtDesc",rd["Desc"]);
			$.form.SetValue("txtMapDesc",rd["MapDesc"]);
			$.form.SetValue("cboType",rd["Type"],rd["TypeDesc"]);			
		} else {
			$.form.SetValue("txtDesc",'');   
			$.form.SetValue("txtMapDesc",'');
			$.form.SetValue("cboType",'');   	
		}
		
		layer.config({  
			extend: 'layerskin/style.css' 
		});

		layer.open({
			type: 1,
			zIndex: 100,
			area: '600px',
			skin: 'layer-class',
			title: '对照匹配规则', 
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
	
	//对照匹配规则窗体-保存
	obj.Layer_Save = function(){
		var rd = obj.layer_rd;
		var ID = (rd ? rd["ID"] : '');
		
		var CatDr    = $.form.GetValue("cboCat");
		var Desc     = $.form.GetValue("txtDesc");
		var MapDesc  = $.form.GetValue("txtMapDesc");
		var Type     = $.form.GetValue("cboType");
		
		var InputStr = ID;
		InputStr += "^" + CatDr;
		InputStr += "^" + Desc;
		InputStr += "^" + MapDesc;
		InputStr += "^" + Type;
        
		var ErrorStr = "";
		
		if (Desc == '') {
			ErrorStr +='标准名称不允许为空!<br/>';
		}
		
        if (MapDesc == '') {
			ErrorStr +='对照短语不允许为空!<br/>';
		}
		
	    if (Type == '') {
			ErrorStr +='类型不允许为空!<br/>';
		}
		
		if (ErrorStr != '') {
			layer.alert(ErrorStr,{icon: 0});
			return;
		}
	
		var retval = $.Tool.RunServerMethod("DHCHAI.DP.DataMapRule","Update",InputStr);
		if (parseInt(retval)>0){
			obj.gridMapRule.ajax.reload(function(){
				var rowIndex = $.Tool.GetTableRowIndex(obj.gridMapRule,retval);
				if (rowIndex > -1){
					var rd =obj.gridMapRule.row(rowIndex).data();
					obj.layer_rd = rd;
				} else {
					obj.layer_rd = '';
				}
				layer.msg('保存成功!',{icon: 1});
			},false);
		} else {
			if (parseInt(retval)=='-2') {
				layer.alert('匹配规则重复或错误!',{icon: 0});
			}else {
				layer.msg('保存失败!',{icon: 2});
			}
		}
	}
	
	//对照匹配规则窗体-添加
	obj.Layer_Add = function(){
		var rd = "";
		var ID = (rd ? rd["ID"] : '');
		
		var CatDr   = $.form.GetValue("cboCat");
		var Desc    = $.form.GetValue("txtDesc");
		var MapDesc = $.form.GetValue("txtMapDesc");
		var Type     = $.form.GetValue("cboType");
		
		var InputStr = ID;
		InputStr += "^" + CatDr;
		InputStr += "^" + Desc;
		InputStr += "^" + MapDesc;
		InputStr += "^" + Type;
        
		var ErrorStr = "";
		
		if (Desc == '') {
			ErrorStr +='标准名称不允许为空!<br/>';
		}
		
        if (MapDesc == '') {
			ErrorStr +='对照短语不允许为空!<br/>';
		}
		
	    if (Type == '') {
			ErrorStr +='类型不允许为空!<br/>';
		}
		
		if (ErrorStr != '') {
			layer.alert(ErrorStr,{icon: 0});
			return;
		}
		
		var retval = $.Tool.RunServerMethod("DHCHAI.DP.DataMapRule","Update",InputStr);
		if (parseInt(retval)>0){
			obj.gridMapRule.ajax.reload(function(){
				var rowIndex = $.Tool.GetTableRowIndex(obj.gridMapRule,retval);
				if (rowIndex > -1){
					var rd =obj.gridMapRule.row(rowIndex).data();
					obj.layer_rd = rd;
				} else {
					obj.layer_rd = '';
				}
				layer.msg('保存成功!',{icon: 1});
			},false);
		} else {
			if (parseInt(retval)=='-2') {
				layer.alert('匹配规则重复或错误!',{icon: 0});
			}else {
				layer.msg('保存失败!',{icon: 2});
			}
		}
	}
}