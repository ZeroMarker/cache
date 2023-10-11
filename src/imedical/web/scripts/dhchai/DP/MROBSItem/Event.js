//护理项目Event
function InitMROBSItemWinEvent(obj){
	CheckSpecificKey();
	layer.config({  
		extend: 'layerskin/style.css' 
	});
	
   /*****搜索*****/
    $("#btnsearch").on('click', function(){
       $('#gridMROBSItem').DataTable().search($('#search').val(),true,true).draw();
       
    });
	
    $("#search").keyup(function(event){
        if (event.keyCode == 13) {
	        obj.gridMROBSItem.search(this.value).draw();
        }
    });
   /**********************/
    $("#btnEdit").addClass('disabled');
    $("#btnDelete").addClass('disabled');
	obj.gridMROBSItem.on('select', function(e, dt, type, indexes) {
		var selectedRows = dt.rows({selected: true}).count();
		$("#btnAdd").addClass('disabled');
		$("#btnEdit").removeClass('disabled');
		$("#btnDelete").removeClass('disabled');
		
	});
	
	obj.gridMROBSItem.on('deselect', function(e, dt, type, indexes) {
		var selectedRows = dt.rows({selected: true}).count();
		$("#btnAdd").removeClass('disabled');
        $("#btnEdit").addClass('disabled');
        $("#btnDelete").addClass('disabled');
       
	});
	
	obj.gridMROBSItem.on('dblclick', 'tr', function(e) {
		var rd = obj.gridMROBSItem.row(this).data();
		
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
		var selectedRows = obj.gridMROBSItem.rows({selected: true}).count();
		if ( selectedRows !== 1 ) return;
		var rd = obj.gridMROBSItem.rows({selected: true}).data().toArray()[0];
		
		obj.layer_rd = rd;
	    obj.Layer();
		
	});
	
	$("#btnDelete").on('click', function(){
		var flag = $("#btnDelete").hasClass("disabled");
		if(flag) return ;
		var selectedRows = obj.gridMROBSItem.rows({selected: true}).count();
		if ( selectedRows !== 1 ) return;
		var rd = obj.gridMROBSItem.rows({selected: true}).data().toArray()[0];
		
		var ID = rd["ID"];
		layer.confirm( '确认是否删除?', {
			btn: ['确认','取消'],    //btn位置对应function的位置
			btnAlign: 'c'
			},
			function(){ 
				var flg = $.Tool.RunServerMethod("DHCHAI.DP.MROBSItem","DeleteById",ID);
				if (parseInt(flg)<0){
					if (parseInt(flg)=='-777') {
						layer.msg('-777：当前无删除权限，请启用删除权限后再删除记录!',{icon: 2});
					}else {
						layer.msg('删除失败!',{icon: 2});
					}
				} else {
					obj.gridMROBSItem.rows({selected:true}).remove().draw(false);
					layer.msg('删除成功!',{icon: 1});
				}
		 });
		
	});
	
	//鎶ょ悊鍒嗙被淇℃伅缂栬緫绐椾綋-鍒濆鍖?
	obj.Layer = function(){
		$.form.iCheckRender();
		$.form.SelectRender('cboBTCatDr');
		var rd = obj.layer_rd;
		if (rd){
			$.form.SetValue("txtBTItemCode",rd["BTItemCode"]);
			$.form.SetValue("txtBTItemDesc",rd["BTItemDesc"]);
			$.form.SetValue("cboBTCatDr",rd["BTCatDr"],rd["BTCatDesc"]);
			$.form.SetValue("chkIsActive",rd["BTIsActive"]== 1);
		} else {
			$.form.SetValue("txtBTItemCode",'');
			$.form.SetValue("txtBTItemDesc",'');
			$.form.SetValue("cboBTCatDr",'');
			$.form.SetValue("chkIsActive",true);
		}
		
		layer.open({
			type: 1,
			zIndex: 100,
			area: '600px',
			skin: 'layer-class',
			title: '护理项目编辑', 
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
	//护理项目-保存
	obj.Layer_Save = function(){
		var rd = obj.layer_rd;
		var ID = (rd ? rd["ID"] : '');
		
		var BTItemCode = $.form.GetValue("txtBTItemCode");
		var BTItemDesc = $.form.GetValue("txtBTItemDesc");
		var BTCatDr = $.form.GetValue("cboBTCatDr");
		var IsActive = $.form.GetValue("chkIsActive");

		var ErrorStr = "";
		if (BTItemCode == '') {
			ErrorStr += '护理项目代码不允许为空！<br/>';	
		}
		if (BTItemDesc == '') {
			ErrorStr += '护理项目名称不允许为空！<br/>';
		}
		if (ErrorStr != '') {
			layer.alert(ErrorStr,{icon: 0});
			return;
		}
		
		var InputStr = ID;
		InputStr += "^" + BTItemCode;
		InputStr += "^" + BTItemDesc;
		InputStr += "^" + BTCatDr;
		InputStr += "^" + IsActive;
		
		var retval = $.Tool.RunServerMethod("DHCHAI.DP.MROBSItem","Update",InputStr);
		if (parseInt(retval)>0){
			obj.gridMROBSItem.ajax.reload(function(){
				var rowIndex = $.Tool.GetTableRowIndex(obj.gridMROBSItem,retval);
				if (rowIndex > -1){
					var rd =obj.gridMROBSItem.row(rowIndex).data();
					obj.layer_rd = rd;
				} else {
					obj.layer_rd = '';
				}
				layer.msg('保存成功!',{icon: 1});
			},false);
		} else {
			if(parseInt(retval)=='-100'){
				layer.alert('护理代码、名称重复！',{icon: 0});
			}else {
				layer.msg('保存失败',{icon: 2});
			}
		}
	}
	//护理项目-添加
	obj.Layer_Add = function(){
		var rd = "";
		var ID = (rd ? rd["ID"] : '');
		
		var BTItemCode = $.form.GetValue("txtBTItemCode");
		var BTItemDesc = $.form.GetValue("txtBTItemDesc");
		var BTCatDr = $.form.GetValue("cboBTCatDr");
		var IsActive = $.form.GetValue("chkIsActive");

		var ErrorStr = "";
		if (BTItemCode == '') {
			ErrorStr += '护理项目代码不允许为空！<br/>';	
		}
		if (BTItemDesc == '') {
			ErrorStr += '护理项目名称不允许为空！<br/>';
		}
		if (ErrorStr != '') {
			layer.alert(ErrorStr,{icon: 0});
			return;
		}
		
		var InputStr = ID;
		InputStr += "^" + BTItemCode;
		InputStr += "^" + BTItemDesc;
		InputStr += "^" + BTCatDr;
		InputStr += "^" + IsActive;
		
		var retval = $.Tool.RunServerMethod("DHCHAI.DP.MROBSItem","Update",InputStr);
		if (parseInt(retval)>0){
			obj.gridMROBSItem.ajax.reload(function(){
				var rowIndex = $.Tool.GetTableRowIndex(obj.gridMROBSItem,retval);
				if (rowIndex > -1){
					var rd =obj.gridMROBSItem.row(rowIndex).data();
					obj.layer_rd = rd;
				} else {
					obj.layer_rd = '';
				}
				layer.msg('保存成功!',{icon: 1});
			},false);
		} else {
			if(parseInt(retval)=='-100'){
				layer.alert('护理代码、名称重复！',{icon: 0});
			}else {
				layer.msg('保存失败',{icon: 2});
			}
		}
	}
}