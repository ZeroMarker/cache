//页面Event
function InitHospitalWinEvent(obj){
	CheckSpecificKey();
	/*****搜索功能*****/
    $("#btnsearch").on('click', function(){
       $('#gridHospital').DataTable().search($('#search').val(),true,true).draw();
       
    });
	
    $("#search").keyup(function(event){
        if (event.keyCode == 13) {
	        obj.gridHospital.search(this.value).draw();
        }
    });
    /****************/
    $("#btnEdit").addClass('disabled');
	obj.gridHospital.on('select', function(e, dt, type, indexes) {
		var selectedRows = dt.rows({selected: true}).count();
		$("#btnsyn").addClass('disabled');
		$("#btnEdit").removeClass('disabled');
	});
	
	obj.gridHospital.on('deselect', function(e, dt, type, indexes) {
		var selectedRows = dt.rows({selected: true}).count();
		$("#btnsyn").removeClass('disabled');
        $("#btnEdit").addClass('disabled');
	});
	
	obj.gridHospital.on('dblclick', 'tr', function(e) {
		var rd = obj.gridHospital.row(this).data();
		
		obj.layer_rd = rd;
		obj.Layer();
	});
	
	$("#btnsyn").on('click', function(){
		var flag = $("#btnsyn").hasClass("disabled");
		if(flag) return ;
		if (!$.LOGON.HISCode) {
			layer.msg('HIS系统代码为空!',{icon: 2});
			return;
		}
		var retval = $.Tool.RunServerMethod("DHCHAI.DI.DHS.SyncHisInfo","SyncHospital",$.LOGON.HISCode,$.LOGON.USERID);
		if (parseInt(retval)>0){
			layer.msg('医院信息同步成功!',{icon: 1});
		} else {
			layer.msg('医院列表同步失败!',{icon: 2});
		}
		obj.gridHospital.ajax.reload();
	});
	
	$("#btnEdit").on('click', function(){
		var flag = $("#btnEdit").hasClass("disabled");
		if(flag) return ;
		var selectedRows = obj.gridHospital.rows({selected: true}).count();
		if ( selectedRows !== 1 ) return;
		var rd = obj.gridHospital.rows({selected: true}).data().toArray()[0];
		
		obj.layer_rd = rd;
		obj.Layer();
	});
	
	//医院信息编辑窗体-初始化
	obj.Layer = function(){
		$.form.SelectRender('cboHospGroup');
		
		var rd = obj.layer_rd;
		if (rd){
			$.form.SetValue('txtHospCode',rd["BTCode"]);
			$.form.SetValue('txtHospDesc',rd["BTDesc"]);
			$.form.SetValue('txtHospDesc2',rd["BTDesc2"]);
			$.form.SetValue('cboHospGroup',rd["BTGroupDr"],rd["BTGroupDesc"]);
		} else {
			$.form.SetValue('txtHospCode','');
			$.form.SetValue('txtHospDesc','');
			$.form.SetValue('txtHospDesc2','');
			$.form.SetValue('cboHospGroup','');
		}
		
		layer.open({
			type: 1,
			zIndex: 100,
			area: '600px',
			title: '医院信息维护编辑', 
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
		var ID = (rd ? rd["ID"] : '');
		var XCode = (rd ? rd["BTXCode"] : '');
		
		var HospCode = $.form.GetValue('txtHospCode');
		var HospDesc = $.form.GetValue('txtHospDesc');
		var HospDesc2 = $.form.GetValue('txtHospDesc2');
		var HospGroupDr = $.form.GetValue('cboHospGroup');
		var ActUserDr = $.LOGON.USERID;
		
		if (HospCode == '') {
			layer.alert("组织机构代码不允许为空",{icon: 0});
			return;
		}
		if (HospDesc == '') {
			layer.alert("医疗机构名称不允许为空",{icon: 0});
			return;
		}
		if (HospGroupDr == '') {
			layer.alert("医院分组不允许为空",{icon: 0});
			return;
		}
		
		var InputStr = ID;
		InputStr += "^" + HospCode;
		InputStr += "^" + HospDesc;
		InputStr += "^" + HospDesc2;
		InputStr += "^" + HospGroupDr;
		InputStr += "^" + XCode;
		InputStr += "^" + 1;
		InputStr += "^" + "";
		InputStr += "^" + "";
		InputStr += "^" + ActUserDr;
		var retval = $.Tool.RunServerMethod("DHCHAI.BT.Hospital","Update",InputStr);
		if (parseInt(retval)>0){
			obj.gridHospital.ajax.reload(function(){
				var rowIndex = $.Tool.GetTableRowIndex(obj.gridHospital,retval);
				if (rowIndex > -1){
					var rd =obj.gridHospital.row(rowIndex).data();
					obj.layer_rd = rd;
				} else {
					obj.layer_rd = '';
				}
			layer.msg('保存成功!',{icon: 1});
			},false);
		} else {
			layer.msg('保存失败!',{icon: 2});
		}
	}
	
}