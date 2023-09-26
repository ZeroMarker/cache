//页面Event
function InitCCLocGroupWinEvent(obj){
	CheckSpecificKey();
	$.form.SelectRender("cboHospital");  //渲染下拉框
	$.form.SelectRender("cboLocGrpType");
	$('#cboLocGrpType').on('change',function(){
		obj.gridLocation.ajax.reload();
	});
	$('#cboHospital').on('change',function(){
		obj.gridLocation.ajax.reload();
	});
	/*****搜索功能*****/
    $("#btnsearch").on('click', function(){
       $('#gridLocation').DataTable().search($('#search').val(),true,true).draw();
       
    });
	
    $("#search").keyup(function(event){
        if (event.keyCode == 13) {
	        obj.gridLocation.search(this.value).draw();
        }
    });
    /****************/
    $("#btnEdit").addClass('disabled');
	obj.gridLocation.on('select', function(e, dt, type, indexes) {
		var selectedRows = dt.rows({selected: true}).count();
		$("#btnEdit").removeClass('disabled');
	});
	
	obj.gridLocation.on('deselect', function(e, dt, type, indexes) {
		var selectedRows = dt.rows({selected: true}).count(); 
        $("#btnEdit").addClass('disabled');
	});
	
	obj.gridLocation.on('dblclick', 'tr', function(e) {
		var rd = obj.gridLocation.row(this).data();
		if (!rd) return ;
        obj.layer_rd = rd;
		obj.Layer();
	});
	
	$("#btnEdit").on('click', function(){
		var flag = $("#btnEdit").hasClass("disabled");
		if(flag) return ;
		var selectedRows = obj.gridLocation.rows({selected: true}).count();
		if ( selectedRows !== 1 ) return;
		var rd = obj.gridLocation.rows({selected: true}).data().toArray()[0];
	    obj.layer_rd = rd;
		obj.Layer();
	});
	
	//科室责任人编辑窗体-初始化
	obj.Layer = function(){
		var rd = obj.layer_rd;
		if (rd){
			$.form.SetValue("txtLocUser",rd["LocUser"]);
		} else {
			$.form.SetValue("txtLocUser",'');
		}
		layer.open({
		  type: 1,
		  zIndex: 100,
		  area: ['400px','200px'],
		  title: '科室责任人编辑', 
		  content: $('#layer'),
		  btn: ['保存','关闭'],
		  btnAlign: 'c',
		  yes: function(index, layero){
			  obj.Layer_Save();
		   }
		});
	}
	
	obj.Layer_Save = function(){
		var rd = obj.layer_rd;   
		var LocID = (rd ? rd["ID"] : '');   // 科室ID
		var CCLocGroupID = (rd ? rd["CCLocGroupID"] : '');  // 院感工作科室分组表ID
		
		var LocUser = $.form.GetValue("txtLocUser");
		var LocGrpDr = $.form.GetValue("cboLocGrpType");
		var InputStr = CCLocGroupID;
		InputStr += "^" + LocID;
		InputStr += "^" + LocGrpDr;
		InputStr += "^" + LocUser;
		InputStr += "^" + "";
		InputStr += "^" + "";
		InputStr += "^" + $.LOGON.USERID;;
		
		var retval = $.Tool.RunServerMethod("DHCHAI.IR.CCLocGroup","Update",InputStr);
		if (parseInt(retval)>0){
			obj.gridLocation.ajax.reload(function(){
				var rowIndex = $.Tool.GetTableRowIndex(obj.gridLocation,retval);
				if (rowIndex > -1){
					var rd =obj.gridLocation.row(rowIndex).data();
					obj.layer_rd = rd;
				} else {
					obj.layer_rd = '';
				}
				layer.msg('保存成功!',{icon: 1});
			},false);
		} else {
			if(parseInt(retval)=='-100'){
				layer.alert('唯一性错误!',{icon: 0});
			}else {
				layer.msg('保存失败!',{icon: 2});
			}
		}
	}
}
