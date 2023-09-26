//页面Event
function InitLabTestSetWinEvent(obj){
	CheckSpecificKey();
	 /*****搜索功能*****/
    $("#btnsearch_one").on('click', function(){
       $('#gridLabSetCat').DataTable().search($('#search_one').val(),true,true).draw();
       
    });
	
    $("#search_one").keyup(function(event){
        if (event.keyCode == 13) {
	        obj.gridLabSetCat.search(this.value).draw();
        }
    });
   /**********************/
    $("#btnEdit_one").addClass('disabled');
    $("#btnDelete_one").addClass('disabled');
	obj.gridLabSetCat.on('select', function(e, dt, type, indexes) {
		var selectedRows = dt.rows({selected: true}).count();
		$("#btnAdd_one").addClass('disabled');
		$("#btnEdit_one").removeClass('disabled');
		$("#btnDelete_one").removeClass('disabled');
		obj.gridLabTestSet.ajax.reload(function(){
			$("#btnAdd_two").removeClass('disabled');
		});
	});
	
	obj.gridLabSetCat.on('deselect', function(e, dt, type, indexes) {
		var selectedRows = dt.rows({selected: true}).count();
		$("#btnAdd_one").removeClass('disabled');
        $("#btnEdit_one").addClass('disabled');
        $("#btnDelete_one").addClass('disabled');
        obj.gridLabTestSet.ajax.reload(function(){
			$("#btnAdd_two").addClass('disabled');
		});
	});
	
	obj.gridLabSetCat.on('dblclick', 'tr', function(e) {
		var rd = obj.gridLabSetCat.row(this).data();
		obj.layer_rd = rd;
		obj.Layer_one();
	    
	});
	
	$("#btnAdd_one").on('click', function(){
		var flag = $("#btnAdd").hasClass("disabled");
		if(flag) return ;	
		obj.layer_rd = '';
		obj.Layer_one();
		
	});
	
	$("#btnEdit_one").on('click', function(){
		var flag = $("#btnEdit_one").hasClass("disabled");
		if(flag) return ;
		var selectedRows = obj.gridLabSetCat.rows({selected: true}).count();
		if ( selectedRows !== 1 ) return;
		var rd = obj.gridLabSetCat.rows({selected: true}).data().toArray()[0];
		
		obj.layer_rd = rd;
	    obj.Layer_one();
	
	});

	$("#btnDelete_one").on('click', function(){
		var flag = $("#btnDelete_one").hasClass("disabled");
		if(flag) return ;
		var selectedRows = obj.gridLabSetCat.rows({selected: true}).count();
		if ( selectedRows !== 1 ) return;
		var rd = obj.gridLabSetCat.rows({selected: true}).data().toArray()[0];
		
		var ID = rd["ID"];
		layer.confirm( '确认是否删除?', {
			btn: ['确认','取消'],    //btn位置对应function的位置
			btnAlign: 'c'
			},
			function(){ 
				var flg = $.Tool.RunServerMethod("DHCHAI.DP.LabTestSetCat","DeleteById",ID);
				if (parseInt(flg)<0){
					layer.msg('删除失败!',{icon: 2});
				} else {
					obj.gridLabSetCat.rows({selected:true}).remove().draw(false);
					layer.msg('删除成功!',{icon: 1});
				}
		 });
	});
  
	//检验医嘱分类编辑窗体-初始化
	obj.Layer_one = function(){
		
        var rd = obj.layer_rd;
		if (rd){
			$.form.SetValue("txtBTCode",rd["BTCode"]);
			$.form.SetValue("txtBTDesc",rd["BTDesc"]);
			
		} else {
			$.form.SetValue("txtBTCode",'');
			$.form.SetValue("txtBTDesc",''); 
		}
		layer.config({  
			extend: 'layerskin/style.css' 
		});
	    
		layer.open({
			type: 1,
			zIndex: 100,
			area: '600px',
			skin: 'layer-class',
			title: '检验医嘱分类编辑', 
			content: $('#layer_one'),
			btn: ['添加','保存','关闭'],
			btnAlign: 'c',
			yes: function(index, layero){
			  	obj.LayerOne_Add();
			},
			btn2: function(index, layero){
				obj.LayerOne_Save();
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
	
	
	//检验医嘱分类配置窗体-保存
	obj.LayerOne_Save = function(){
		var rd = obj.layer_rd;
		var ID = (rd ? rd["ID"] : '');
			                                                                         
		var BTCode   = $.form.GetValue("txtBTCode");
		var BTDesc  = $.form.GetValue("txtBTDesc");    		
	
		if (BTCode == '') {
			layer.alert("检验医嘱分类代码不允许为空",{icon: 0});
			return;
		}
	    if (BTDesc == '') {
			layer.alert("检验医嘱分类名称不允许为空",{icon: 0});
			return;
		}
		var InputStr = ID;
		InputStr += "^" + BTCode; 
		InputStr += "^" + BTDesc;
		
		var retval = $.Tool.RunServerMethod("DHCHAI.DP.LabTestSetCat","Update",InputStr);
		if (parseInt(retval)>0){
			obj.gridLabSetCat.ajax.reload(function(){
				var rowIndex = $.Tool.GetTableRowIndex(obj.gridLabSetCat,retval);
				if (rowIndex > -1){
					var rd =obj.gridLabSetCat.row(rowIndex).data();
					obj.layer_rd = rd;
				} else {
					obj.layer_rd = '';
				}
				layer.msg('保存成功!',{icon: 1});
			},false);
		} else {
			if(parseInt(retval)=='-100'){
				layer.alert('检验医嘱分类代码不允许修改!',{icon: 0});
			}else {
				layer.msg('保存失败!',{icon: 2});
			}
		}
	}
	
	//检验医嘱分类配置窗体-添加
	obj.LayerOne_Add = function(){
		var rd = "";
		var ID = (rd ? rd["ID"] : '');
	
		var BTCode   = $.form.GetValue("txtBTCode");
		var BTDesc  = $.form.GetValue("txtBTDesc");    		
	
		if (BTCode == '') {
			layer.alert("检验医嘱分类代码不允许为空",{icon: 0});
			return;
		}
	    if (BTDesc == '') {
			layer.alert("检验医嘱分类名称不允许为空",{icon: 0});
			return;
		}
		var InputStr = ID;
		InputStr += "^" + BTCode; 
		InputStr += "^" + BTDesc;
		var retval = $.Tool.RunServerMethod("DHCHAI.DP.LabTestSetCat","Update",InputStr);

		if (parseInt(retval)>0){
			obj.gridLabSetCat.ajax.reload(function(){
				var rowIndex = $.Tool.GetTableRowIndex(obj.gridLabSetCat,retval);
				if (rowIndex > -1){
					var rd =obj.gridLabSetCat.row(rowIndex).data();
					obj.layer_rd = rd;
				} else {
					obj.layer_rd = '';
				}
				layer.msg('保存成功!',{icon: 1});
			},false);
		} else {
			if(parseInt(retval)=='-100'){
				layer.alert('检验医嘱分类代码不允许修改!',{icon: 0});
			}else {
				layer.msg('保存失败!',{icon: 2});
			}
		}
	}
	
	//检验医嘱
    /*****搜索功能*****/
    $("#btnsearch_two").on('click', function(){
       $('#gridLabTestSet').DataTable().search($('#search_two').val(),true,true).draw();
       
    });
	
    $("#search_two").keyup(function(event){
        if (event.keyCode == 13) {
	        obj.gridLabTestSet.search(this.value).draw();
        }
    });
    /**********************/
    $("#btnAdd_two").addClass('disabled');
    $("#btnEdit_two").addClass('disabled');
    $("#btnDelete_two").addClass('disabled');
	obj.gridLabTestSet.on('select', function(e, dt, type, indexes) {
		var selectedRows = dt.rows({selected: true}).count();
		$("#btnAdd_two").addClass('disabled');
		$("#btnEdit_two").removeClass('disabled');
		$("#btnDelete_two").removeClass('disabled');
	});

	obj.gridLabTestSet.on('deselect', function(e, dt, type, indexes) {
		var selectedRows = dt.rows({selected: true}).count();
		$("#btnAdd_two").removeClass('disabled');
        $("#btnEdit_two").addClass('disabled');
        $("#btnDelete_two").addClass('disabled');
	});
	
	obj.gridLabTestSet.on('dblclick', 'tr', function(e) {
		var CatDr = $.form.GetValue('gridLabSetCat');      
		if (CatDr == ''){
			layer.alert('请先选择检验医嘱分类，再添加数据!',{icon: 0});
			return;
		}	
		var rd = obj.gridLabTestSet.row(this).data();
		obj.layer_rd = rd;
		obj.Layer_two();
	    
	});
	
	$("#btnAdd_two").on('click', function(){
		var flag = $("#btnAdd_two").hasClass("disabled");
		if(flag) return ;	
		obj.layer_rd = '';
		obj.Layer_two();
		
	});
	
	$("#btnEdit_two").on('click', function(){
		var flag = $("#btnEdit_two").hasClass("disabled");
		if(flag) return ;
		var selectedRows = obj.gridLabTestSet.rows({selected: true}).count();
		if ( selectedRows !== 1 ) return;
		var rd =  obj.gridLabTestSet.rows({selected: true}).data().toArray()[0];
		
		obj.layer_rd = rd;
	    obj.Layer_two();
	
	});

	$("#btnDelete_two").on('click', function(){
		var flag = $("#btnDelete_two").hasClass("disabled");
		if(flag) return ;
		var selectedRows =  obj.gridLabTestSet.rows({selected: true}).count();
		if ( selectedRows !== 1 ) return;
		var rd =  obj.gridLabTestSet.rows({selected: true}).data().toArray()[0];
		
		var ID = rd["ID"];
		layer.confirm( '确认是否删除?', {
			btn: ['确认','取消'],    //btn位置对应function的位置
			btnAlign: 'c'
			},
			function(){ 
				var flg = $.Tool.RunServerMethod("DHCHAI.DP.LabTestSet","DeleteById",ID);
				if (parseInt(flg)<0){
					layer.msg('删除失败!',{icon: 2});
				} else {
					 obj.gridLabTestSet.rows({selected:true}).remove().draw(false);
					layer.msg('删除成功!',{icon: 1});
				}
		 });
	});

  
	//检验医嘱编辑窗体-初始化
	obj.Layer_two = function(){
		$.form.iCheckRender(); //单选按钮
        var rd = obj.layer_rd;
		if (rd){
			$.form.SetValue("txtTSCode",rd["TSCode"]);
			$.form.SetValue("txtTestSet",rd["TestSet"]);
			$.form.SetValue("chkActive",rd["IsActive"]== 1);
			$.form.SetValue("txtNote",rd["Note"]);
			
		} else {
			$.form.SetValue("txtTSCode",'');
			$.form.SetValue("txtTestSet",''); 
			$.form.SetValue("chkActive",''); 
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
			title: '检验医嘱编辑', 
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
	
	//检验医嘱配置窗体-保存
	obj.LayerTwo_Save = function(){
		var rd = obj.layer_rd;
		var ID = (rd ? rd["ID"] : '');
		
		var CatDr = $.form.GetValue('gridLabSetCat');                                                                   
		var TSCode   = $.form.GetValue("txtTSCode");
		var TestSet  = $.form.GetValue("txtTestSet"); 
		var IsActive = $.form.GetValue("chkActive");                                                                            
		var Note     = $.form.GetValue("txtNote");                                                                             
	
		if (TSCode == '') {
			layer.alert("检验医嘱代码不允许为空",{icon: 0});
			return;
		}
	    if (TestSet == '') {
	        layer.alert("检验医嘱名称不允许为空", { icon: 0 });
			return;
		}
		if (CatDr == '') {
			layer.alert("分类不允许为空",{icon: 0});
			return;
		}
		var InputStr = ID;
		InputStr += "^" + TSCode; 
		InputStr += "^" + TestSet;
		InputStr += "^" + CatDr;
		InputStr += "^" + IsActive; 
		InputStr += "^" + Note;

		var retval = $.Tool.RunServerMethod("DHCHAI.DP.LabTestSet","Update",InputStr);
		if (parseInt(retval)>0){
			obj.gridLabTestSet.ajax.reload(function(){
				var rowIndex = $.Tool.GetTableRowIndex(obj.gridLabTestSet,retval);
				if (rowIndex > -1){
					var rd =obj.gridLabTestSet.row(rowIndex).data();
					obj.layer_rd = rd;
				} else {
					obj.layer_rd = '';
				}
				layer.msg('保存成功!',{icon: 1});
			},false);
		} else {
			if(parseInt(retval)=='-100'){
				layer.alert('代码重复!',{icon: 0});
			}else {
				layer.msg('保存失败!',{icon: 2});
			};
			
		}
	}
	
	//检验医嘱配置窗体-添加
	obj.LayerTwo_Add = function(){
		var rd = "";
		var ID = (rd ? rd["ID"] : '');
	    var CatDr = $.form.GetValue('gridLabSetCat');       
	    var TSCode   = $.form.GetValue("txtTSCode");
		var TestSet  = $.form.GetValue("txtTestSet"); 
		var IsActive = $.form.GetValue("chkActive");                                                                            
		var Note     = $.form.GetValue("txtNote");                                                                             
	
		if (TSCode == '') {
			layer.alert("检验医嘱代码不允许为空",{icon: 0});
			return;
		}
	    if (TestSet == '') {
	        layer.alert("检验医嘱名称不允许为空", { icon: 0 });
			return;
		}
		if (CatDr == '') {
			layer.alert("分类不允许为空",{icon: 0});
			return;
		}
		var InputStr = ID;
		InputStr += "^" + TSCode; 
		InputStr += "^" + TestSet;
		InputStr += "^" + CatDr;
		InputStr += "^" + IsActive; 
		InputStr += "^" + Note;
	
		var retval = $.Tool.RunServerMethod("DHCHAI.DP.LabTestSet","Update",InputStr);
		if (parseInt(retval)>0){
			obj.gridLabTestSet.ajax.reload(function(){
				var rowIndex = $.Tool.GetTableRowIndex(obj.gridLabTestSet,retval);
				if (rowIndex > -1){
					var rd =obj.gridLabTestSet.row(rowIndex).data();
					obj.layer_rd = rd;
				} else {
					obj.layer_rd = '';
				}
				layer.msg('保存成功!',{icon: 1});
			},false);
		} else {
			if(parseInt(retval)=='-100'){
				layer.alert('代码重复!',{icon: 0});
			}else {
				layer.msg('保存失败!',{icon: 2});
			};
			
		}
	}
}
