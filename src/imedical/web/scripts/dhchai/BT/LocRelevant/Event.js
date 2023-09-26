//页面Event
function InitLocRelevWinEvent(obj){
	CheckSpecificKey();
	/*****搜索功能*****/
    $("#btnsearch_one").on('click', function(){
       $('#gridLocRelev').DataTable().search($('#search_one').val(),true,true).draw();
    });
	$("#btnsearch_two").on('click', function(){
       $('#gridLoc').DataTable().search($('#search_two').val(),true,true).draw();
    });
	
    $("#search_one").keyup(function(event){
        if (event.keyCode == 13) {
	        obj.gridLocRelev.search(this.value).draw();
        }
    });
	$("#search_two").keyup(function(event){
        if (event.keyCode == 13) {
	        obj.gridLoc.search(this.value).draw();
        }
    });
    /****************/
	$('#cboCat').on('change',function(){
		obj.gridLocRelev.ajax.reload();
	});
	
	$("#btnAdd").addClass('disabled');
	$("#btnEdit").addClass('disabled');
    $("#btnDelete").addClass('disabled');
	obj.gridLocRelev.on('select', function(e, dt, type, indexes) {
		var selectedRows = dt.rows({selected: true}).count();
		if ( selectedRows !== 1 ) return;
		var rd = obj.gridLocRelev.rows({selected: true}).data().toArray()[0];
		obj.SelectLocRelevID = rd["ID"];
		$("#btnAdd").addClass('disabled');
		$("#btnEdit").removeClass('disabled');
		$("#btnDelete").removeClass('disabled');
		obj.gridLoc.ajax.reload();
	});
	
	obj.gridLocRelev.on('deselect', function(e, dt, type, indexes) {
		var selectedRows = dt.rows({selected: true}).count();
		obj.SelectLocRelevID = "";
        $("#btnAdd").removeClass('disabled');
        $("#btnEdit").addClass('disabled');
        $("#btnDelete").addClass('disabled');
		obj.gridLoc.ajax.reload();
	});
	
	obj.gridLocRelev.on('dblclick', 'tr', function(e) {
		var rd = obj.gridLocRelev.row(this).data();
		
		obj.layer_rd = rd;
		obj.Layer();
	});
	
	$("#btnDelete").on('click', function(){
		var flag = $("#btnDelete").hasClass("disabled");
		if(flag) return ;
		var selectedRows = obj.gridLocRelev.rows({selected: true}).count();
		if ( selectedRows !== 1 ) return;
		var rd = obj.gridLocRelev.rows({selected: true}).data().toArray()[0];
		
		var ID = rd["ID"];
		layer.confirm( '确认是否删除?', {
			btn: ['确认','取消'],    //btn位置对应function的位置
			btnAlign: 'c'
			},
			function(){ 
				var flg = $.Tool.RunServerMethod("DHCHAI.BT.LocRelevant","DeleteById",ID);
				if (parseInt(flg)<0){
					layer.msg('删除失败!',{icon: 2});
				} else {
					obj.gridLocRelev.rows({selected:true}).remove().draw(false);
					layer.msg('删除成功!',{icon: 1});
					obj.gridLoc.ajax.reload();
				}
		 });
	
	});
	
	$("#btnEdit").on('click', function(){
		var flag = $("#btnEdit").hasClass("disabled");
		if(flag) return ;
		var selectedRows = obj.gridLocRelev.rows({selected: true}).count();
		if ( selectedRows !== 1 ) return;
		var rd = obj.gridLocRelev.rows({selected: true}).data().toArray()[0];
		
		obj.layer_rd = rd;
	    obj.Layer();

	});
	
	$("#btnAdd").on('click', function(){
		layer.alert('不选中左侧列表时点击右侧列表的关联按钮即可添加!',{icon: 0});
	});
	
	//关联与取消关联按钮(添加)
	$('#gridLoc').on('click', "a", function (e) {
        e.preventDefault();
		var tr = $(this).closest('tr');
		var row = obj.gridLoc.row(tr);
		var LocData = row.data();
		var LocID = LocData["ID"];
		var LocType = $(this).text();
		var selectedRows = obj.gridLocRelev.rows({selected: true}).count();
		if ( selectedRows != 1 ) {
			//新增科室相关性
			obj.ClickLocID = LocID;
			obj.layer_rd = "";
			obj.Layer();
			return;
		} else {
			//判断 取消最后关联
			if((LocType=="取消关联")&&(obj.relevCount==1)){
				layer.msg('请点击删除按钮!',{icon: 7});
				return;
			}
			//关联和取消关联
			obj.ClickLocID = "";
			var rd = obj.gridLocRelev.rows({selected: true}).data().toArray()[0];
			
			var retval = $.Tool.RunServerMethod("DHCHAI.BTS.LocRelevantSrv","relateRelevLoc", rd["ID"], LocID, $.LOGON.USERID);
			if (parseInt(retval)>0){
				obj.gridLocRelev.ajax.reload();
				obj.gridLoc.ajax.reload();
				layer.msg('保存成功!',{icon: 1});
			} else {
				layer.msg('保存失败!',{icon: 2});
			}
		}
	});
	
	//编辑窗体-初始化
	obj.Layer = function(){
		var rd = obj.layer_rd;
		if (rd) {
			$.form.SetValue("txtName",(rd["Name"]));
			$.form.SetValue("chkActive",(rd["IsActive"]==1));
		} else {
			$.form.SetValue("chkActive",true);
			$.form.SetValue("txtName",'');
		}
		
		layer.config({  
			extend: 'layerskin/style.css' 
		});
	
		layer.open({
			type: 1,
			zIndex: 100,
			area: '400px',
			skin: 'layer-class',
			title: '科室相关性编辑', 
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
	
	//编辑窗体-保存
	obj.Layer_Save = function(){
		var rd = obj.layer_rd;
		var ID = (rd ? rd["ID"] : '');
		var LocIDList = (rd ? rd["LocIDList"].split(",").join("|") : '');
		
		var Name	 = $.form.GetValue("txtName");
		var IsActive = $.form.GetValue("chkActive");
		var CatValue = $.form.GetValue("cboCat");
		
		if (CatValue == "") {
			layer.alert('分类不可为空!',{icon: 0});
			return;
		}
		
		var InputStr = ID;
		InputStr += "^" + Name;
		InputStr += "^" + CatValue;
		//InputStr += "^" + LocIDList;
		InputStr += "^" + (LocIDList==""?obj.ClickLocID:LocIDList);
		InputStr += "^" + IsActive;
		InputStr += "^^^" + $.LOGON.USERID;
		var retval = $.Tool.RunServerMethod("DHCHAI.BT.LocRelevant","Update",InputStr);
		if (parseInt(retval)>0){
			obj.gridLocRelev.ajax.reload(function(){
				var rowIndex = $.Tool.GetTableRowIndex(obj.gridLocRelev,retval);
				if (rowIndex > -1){
					var rd =obj.gridLocRelev.row(rowIndex).data();
					obj.layer_rd = rd;
				} else {
					obj.layer_rd = '';
				}
				layer.msg('保存成功!',{icon: 1});
			},false);
		} else {
			if(parseInt(retval)=='-2'){
				layer.alert('代码重复!',{icon: 0});
			}else {
				layer.msg('保存失败!',{icon: 2});
			}
		}
	}
	
	//编辑窗体-添加
	obj.Layer_Add = function(){
		var rd = obj.layer_rd;
		var ID = (rd ? rd["ID"] : '');
		var LocIDList = (rd ? rd["LocIDList"].split(",").join("|") : '');
		
		var Name	 = $.form.GetValue("txtName");
		var IsActive = $.form.GetValue("chkActive");
		var CatValue = $.form.GetValue("cboCat");
		
		if (CatValue == "") {
			layer.alert('分类不可为空!',{icon: 0});
			return;
		}
		
		var InputStr = "";
		InputStr += "^" + Name;
		InputStr += "^" + CatValue;
		InputStr += "^" + obj.ClickLocID;
		InputStr += "^" + IsActive;
		InputStr += "^^^" + $.LOGON.USERID;
		var retval = $.Tool.RunServerMethod("DHCHAI.BT.LocRelevant","Update",InputStr);
		if (parseInt(retval)>0){
			obj.gridLocRelev.ajax.reload();
			layer.msg('保存成功!',{icon: 1});
		} else {
			if(parseInt(retval)=='-2'){
				layer.alert('代码重复!',{icon: 0});
			}else {
				layer.msg('保存失败!',{icon: 2});
			}
		}
	}
	
}