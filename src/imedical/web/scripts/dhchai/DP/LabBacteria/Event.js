//页面Event
function InitLabBacteriaWinEvent(obj){
	CheckSpecificKey();
	/*****搜索功能*****/
    $("#btnsearch").on('click', function(){
       $('#gridLabBacteria').DataTable().search($('#search').val(),true,true).draw();
       
    });
	
    $("#search").keyup(function(event){
        if (event.keyCode == 13) {
	        obj.gridLabBacteria.search(this.value).draw();
        }
    });
   /**********************/
    $("#btnEdit").addClass('disabled');
    $("#btnDelete").addClass('disabled');
	obj.gridLabBacteria.on('select', function(e, dt, type, indexes) {
		var selectedRows = dt.rows({selected: true}).count();
		$("#btnAdd").addClass('disabled');
		$("#btnEdit").removeClass('disabled');
		$("#btnDelete").removeClass('disabled');
	});
	
	obj.gridLabBacteria.on('deselect', function(e, dt, type, indexes) {
		var selectedRows = dt.rows({selected: true}).count();
		$("#btnAdd").removeClass('disabled');
        $("#btnEdit").addClass('disabled');
        $("#btnDelete").addClass('disabled');
	});
	
	obj.gridLabBacteria.on('dblclick', 'tr', function(e) {
		var rd = obj.gridLabBacteria.row(this).data();
		
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
		var selectedRows = obj.gridLabBacteria.rows({selected: true}).count();
		if ( selectedRows !== 1 ) return;
		var rd = obj.gridLabBacteria.rows({selected: true}).data().toArray()[0];
		
		obj.layer_rd = rd;
	    obj.Layer();
	
	});
	
	$("#btnDelete").on('click', function(){
		var flag = $("#btnDelete").hasClass("disabled");
		if(flag) return ;
		var selectedRows = obj.gridLabBacteria.rows({selected: true}).count();
		if ( selectedRows !== 1 ) return;
		var rd = obj.gridLabBacteria.rows({selected: true}).data().toArray()[0];
		
		var ID = rd["ID"];
		layer.confirm( '确认是否删除?', {
			btn: ['确认','取消'],    //btn位置对应function的位置
			btnAlign: 'c'
			},
			function(){ 
				var flg = $.Tool.RunServerMethod("DHCHAI.DP.LabBacteria","DeleteById",ID);
				if (parseInt(flg)<0){
					if (parseInt(flg)=='-777') {
						layer.msg('-777：当前无删除权限，请启用删除权限后再删除记录!',{icon: 2});
					}else {
						layer.msg('删除失败!',{icon: 2});
					}
				} else {
					obj.gridLabBacteria.rows({selected:true}).remove().draw(false);
					layer.msg('删除成功!',{icon: 1});
				}
		 });
	});
	
	//细菌编辑窗体-初始化
	obj.Layer = function(){
		$.form.iCheckRender();
		$.form.SelectRender("#layer");  //渲染下拉框

		var rd = obj.layer_rd;
		
		if (rd){
			$.form.SetValue("txtBacCode",rd["BacCode"]);
			$.form.SetValue("txtBacDesc",rd["BacDesc"]);
			$.form.SetValue("txtBacName",rd["BacName"]);
			$.form.SetValue("cboBacCat",rd["CatID"],rd["CatDesc"]);
			$.form.SetValue("cboBacType",rd["TypeID"],rd["TypeDesc"]);
			$.form.SetValue("txtWCode",rd["WCode"]);
			$.form.SetValue("chkActive",rd["IsActive"]== 1);
			$.form.SetValue("chkIsCommon",rd["IsCommon"]== 1);
		} else {
			$.form.SetValue("txtBacCode",'');   
			$.form.SetValue("txtBacDesc",'');
			$.form.SetValue("txtBacName",'');   
			$.form.SetValue("cboBacCat",'');
			$.form.SetValue("txtWCode",'');   
			$.form.SetValue("chkActive",''); 
			$.form.SetValue("chkIsCommon",''); 
		}
		
		layer.config({  
			extend: 'layerskin/style.css' 
		});

		layer.open({
			type: 1,
			zIndex: 100,
			area: '600px',
			skin: 'layer-class',
			title: '细菌编辑', 
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
	
	//细菌编辑窗体-保存
	obj.Layer_Save = function(){
		var rd = obj.layer_rd;
		var ID = (rd ? rd["ID"] : '');
		
		var BacCode   = $.form.GetValue("txtBacCode");
		var BacDesc   = $.form.GetValue("txtBacDesc");
		var BacName   = $.form.GetValue("txtBacName");
		var BacTypeDr = $.form.GetValue("cboBacType");
		var BacCatDr  = $.form.GetValue("cboBacCat");
		var WCode     = $.form.GetValue("txtWCode");
		var IsActive  = $.form.GetValue("chkActive");
		var IsCommon  = $.form.GetValue("chkIsCommon");
		var InputStr = ID;
		InputStr += "^" + BacCode;
		InputStr += "^" + BacDesc;
		InputStr += "^" + BacName;
		InputStr += "^" + BacTypeDr;
		InputStr += "^" + BacCatDr;
		InputStr += "^" + WCode;
		InputStr += "^" + IsActive;
		InputStr += "^" + "";
		InputStr += "^" + "";
		InputStr += "^" + IsCommon;
		if (BacCode == '') {
			layer.alert("代码不允许为空",{icon: 0});
			return;
		}
		if (BacDesc == '') {
			layer.alert("名称不允许为空",{icon: 0});
			return;
		}
		
        if (BacName == '') {
			layer.alert("英文名不允许为空",{icon: 0});
			return;
		}
		var retval = $.Tool.RunServerMethod("DHCHAI.DP.LabBacteria","Update",InputStr);
		if (parseInt(retval)>0){
			obj.gridLabBacteria.ajax.reload(function(){
				var rowIndex = $.Tool.GetTableRowIndex(obj.gridLabBacteria,retval);
				if (rowIndex > -1){
					var rd =obj.gridLabBacteria.row(rowIndex).data();
					obj.layer_rd = rd;
				} else {
					obj.layer_rd = '';
				}
				layer.msg('保存成功!',{icon: 1});
			},false);
		} else {
			if(parseInt(retval)=='-100'){
				layer.alert('细菌代码、名称不允许修改!',{icon: 0});
			}else {
				layer.msg('保存失败!',{icon: 2});
			}
		}
	}
	
	//细菌编辑窗体-添加
	obj.Layer_Add = function(){
		var rd = "";
		var ID = (rd ? rd["ID"] : '');
		
			var BacCode   = $.form.GetValue("txtBacCode");
		var BacDesc   = $.form.GetValue("txtBacDesc");
		var BacName   = $.form.GetValue("txtBacName");
		var BacTypeDr = $.form.GetValue("cboBacType");
		var BacCatDr  = $.form.GetValue("cboBacCat");
		var WCode     = $.form.GetValue("txtWCode");
		var IsActive  = $.form.GetValue("chkActive");
		var IsCommon  = $.form.GetValue("chkIsCommon");
		var InputStr = ID;
		InputStr += "^" + BacCode;
		InputStr += "^" + BacDesc;
		InputStr += "^" + BacName;
		InputStr += "^" + BacTypeDr;
		InputStr += "^" + BacCatDr;
		InputStr += "^" + WCode;
		InputStr += "^" + IsActive;
		InputStr += "^" + "";
		InputStr += "^" + "";
		InputStr += "^" + IsCommon;
		if (BacCode == '') {
			layer.alert("代码不允许为空",{icon: 0});
			return;
		}
		if (BacDesc == '') {
			layer.alert("名称不允许为空",{icon: 0});
			return;
		}
		
        if (BacName == '') {
			layer.alert("英文名不允许为空",{icon: 0});
			return;
		}
		var retval = $.Tool.RunServerMethod("DHCHAI.DP.LabBacteria","Update",InputStr);
		if (parseInt(retval)>0){
			obj.gridLabBacteria.ajax.reload(function(){
				var rowIndex = $.Tool.GetTableRowIndex(obj.gridLabBacteria,retval);
				if (rowIndex > -1){
					var rd =obj.gridLabBacteria.row(rowIndex).data();
					obj.layer_rd = rd;
				} else {
					obj.layer_rd = '';
				}
				layer.msg('保存成功!',{icon: 1});
			},false);
		} else {
			if(parseInt(retval)=='-100'){
				layer.alert('细菌代码、名称重复!',{icon: 0});
			}else {
				layer.msg('保存失败!',{icon: 2});
			}
		}
	}
}