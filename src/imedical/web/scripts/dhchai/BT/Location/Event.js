//页面Event
function InitLocationWinEvent(obj){
	CheckSpecificKey();
	$.form.iCheckRender();  //渲染复选框|单选钮
	$.form.SelectRender("cboHospital");  //渲染下拉框

	$('#cboHospital').on('change',function(){
		/*
		var hospId = $.form.GetValue('cboHospital');
		if (hospId == ''){
			layer.alert('请选择医院!',{icon: 0});
			return;
		}
		*/
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
    $("#btnVirtual").addClass('disabled');
    $("#btnLocLink").addClass('disabled');
	obj.gridLocation.on('select', function(e, dt, type, indexes) {
		var selectedRows = dt.rows({selected: true}).count();
		$("#btnsyn").addClass('disabled');
		$("#btnEdit").removeClass('disabled');
        $("#btnVirtual").removeClass('disabled');
        $("#btnLocLink").removeClass('disabled');
	});
	
	obj.gridLocation.on('deselect', function(e, dt, type, indexes) {
		var selectedRows = dt.rows({selected: true}).count(); 
		$("#btnsyn").removeClass('disabled');
        $("#btnEdit").addClass('disabled');
        $("#btnVirtual").addClass('disabled');
        $("#btnLocLink").addClass('disabled');
	});
	
	obj.gridLocation.on('dblclick', 'tr', function(e) {
		var rd = obj.gridLocation.row(this).data();
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
		var retval = $.Tool.RunServerMethod("DHCHAI.DI.DHS.SyncHisInfo","SyncLocation",$.LOGON.HISCode,"",$.LOGON.USERID);
		if (parseInt(retval)>0){
			layer.msg('科室列表同步成功!',{icon: 1});
		} else {
			layer.msg('科室列表同步失败!',{icon: 2});
		}
		obj.gridLocation.ajax.reload();
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
	
	//科室信息编辑窗体-初始化
	obj.Layer = function(){
		$.form.SelectRender("#layer");  //渲染下拉框
		var rd = obj.layer_rd;
		if (rd){
			$.form.SetValue("txtLocCode",rd["LocCode"]);
			$.form.SetValue("txtLocDesc",rd["LocDesc"]);
			$.form.SetValue("txtLocDesc2",rd["LocDesc2"]);
			$.form.SetValue("cboLocType",rd["LocTypeDr"],rd["LocTypeDesc"]);
			$.form.SetValue("cboLocCate",rd["LocCateDr"],rd["LocCateDesc"]);
			$.form.SetValue("cboLocGroup",rd["GroupDr"],rd["GroupDesc"]);
			$.form.SetValue("cboLocHosp",rd["HospDr"],rd["HospDesc"]);
			$.form.SetValue("cboLocICUType",rd["ICUTpDr"],rd["ICUTpDesc"]);
			$.form.SetValue('chkIsICU',(rd["IsICU"] =='是'));
			$.form.SetValue('chkIsNICU',(rd["IsNICU"] =='是'));
			$.form.SetValue('chkIsOPER',(rd["IsOPER"] =='是'));
			$.form.SetValue('chkIsActive',(rd["IsActive"] =='是'));
			$.form.SetValue('txtIndNo',rd["IndNo"]);							   
		} else {
			$.form.SetValue("txtLocCode",'');
			$.form.SetValue("txtLocDesc",'');
			$.form.SetValue("txtLocDesc2",'');
			$.form.SetValue("cboLocType",'');
			$.form.SetValue("cboLocCate",'');
			$.form.SetValue("cboLocGroup",'');
			$.form.SetValue("cboLocHosp",'');
			$.form.SetValue("cboLocICUType",'');
			$.form.SetValue('chkIsICU','');
			$.form.SetValue('chkIsNICU','');
			$.form.SetValue('chkIsOPER','');
			$.form.SetValue('chkIsActive','');
			$.form.SetValue('txtIndNo','');					  
		}
		layer.open({
		  type: 1,
		  zIndex: 100,
		  area: '600px',
		  title: '科室信息编辑', 
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
		var XCode = (rd ? rd["XCode"] : '');
		var ParLocDr = (rd ? rd["ParLocDr"] : '');
	
		var LocCode = $.form.GetValue("txtLocCode");
		var LocDesc = $.form.GetValue("txtLocDesc");
		var LocDesc2 = $.form.GetValue("txtLocDesc2");
		var LocType = $.form.GetValue("cboLocType");
		var LocCate = $.form.GetValue("cboLocCate");
		var LocGroup = $.form.GetValue("cboLocGroup");
		var LocHosp = $.form.GetValue("cboLocHosp");
		var IsICU = $.form.GetValue("chkIsICU");
		var IsNICU = $.form.GetValue("chkIsNICU");
		var IsOPER = $.form.GetValue("chkIsOPER");
		var LocICUType = $.form.GetValue("cboLocICUType");
		var IsActive = $.form.GetValue("chkIsActive");
		var ActUserDr = $.LOGON.USERID;
		var IndNo = $.form.GetValue("txtIndNo");								  
		
		if (LocCode == '') {
			layer.alert("科室代码不允许为空",{icon: 0});
			return;
		}
		if (LocDesc == '') {
			layer.alert("科室名称不允许为空",{icon: 0});
			return;
		}
		if (LocHosp == '') {
			layer.alert("科室所属院区不允许为空",{icon: 0});
			return;
		}
		if ((IsICU==1)&&(IsNICU==1)) {
			layer.alert("科室不能同时属于重症病房和新生儿病房",{icon: 0});
			return;
		}
		var InputStr = ID;
		InputStr += "^" + LocCode;
		InputStr += "^" + LocDesc;
		InputStr += "^" + LocDesc2;
		InputStr += "^" + LocType;
		InputStr += "^" + LocCate;
		InputStr += "^" + LocGroup;
		InputStr += "^" + LocHosp;
		InputStr += "^" + IsOPER;
		InputStr += "^" + IsICU;
		InputStr += "^" + IsNICU;
		InputStr += "^" + LocICUType;
		InputStr += "^" + XCode;
		InputStr += "^" + IsActive;
		InputStr += "^" + "";
		InputStr += "^" + "";
		InputStr += "^" + ActUserDr;
		InputStr += "^" + ParLocDr;
		InputStr += "^" + IndNo;
		
		var retval = $.Tool.RunServerMethod("DHCHAI.BT.Location","Update",InputStr);
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
			if(parseInt(retval)=='-2'){
				layer.alert('代码重复!',{icon: 0});
			}else {
				layer.msg('保存失败!',{icon: 2});
			}
		}
	}
	
	//虚拟病区
	$("#btnVirtual").on('click', function(){
		var flag = $("#btnVirtual").hasClass("disabled");
		if(flag) return ;
		var selectedRows = obj.gridLocation.rows({selected: true}).count();
		if ( selectedRows !== 1 ) return;
		var rd = obj.gridLocation.rows({selected: true}).data().toArray()[0];
	    obj.layer_rd = rd;
		obj.Layer2();
	});
	
	//虚拟病区编辑窗体
	obj.Layer2 = function(){
		$.form.SelectRender("#layer");  //渲染下拉框
		var rd = obj.layer_rd;
		if (!rd) return;
		
		var LocTypeDesc=rd["LocTypeDesc"];
		var LocCateDesc=rd["LocCateDesc"];
		if ((LocTypeDesc.indexOf("病区")<0)||(LocCateDesc.indexOf("住院")<0)){
			layer.alert("非住院病区,不允许虚拟病区!",{icon: 0});
			return;
		}
		
		$.form.SetValue("txtLocCode",rd["LocCode"]);
		$.form.SetValue("txtLocDesc",rd["LocDesc"]);
		$.form.SetValue("txtLocDesc2",rd["LocDesc2"]+'虚拟病区');
		$.form.SetValue("cboLocType",rd["LocTypeDr"],rd["LocTypeDesc"]);
		$.form.SetValue("cboLocCate",rd["LocCateDr"],rd["LocCateDesc"]);
		$.form.SetValue("cboLocGroup",rd["GroupDr"],rd["GroupDesc"]);
		$.form.SetValue("cboLocHosp",rd["HospDr"],rd["HospDesc"]);
		$.form.SetValue("cboLocICUType",rd["ICUTpDr"],rd["ICUTpDesc"]);
		$.form.SetValue('chkIsICU',(rd["IsICU"] =='是'));
		$.form.SetValue('chkIsNICU',(rd["IsNICU"] =='是'));
		$.form.SetValue('chkIsOPER',(rd["IsOPER"] =='是'));
		$.form.SetValue('chkIsActive',(rd["IsActive"] =='是'));
		$.form.SetValue('txtIndNo',rd["IndNo"]);
		
		layer.open({
		  type: 1,
		  zIndex: 100,
		  area: '600px',
		  title: '虚拟病区信息编辑',
		  content: $('#layer'),
		  btn: ['保存','关闭'],
		  btnAlign: 'c',
		  yes: function(index, layero){
			  obj.Layer_Save2();
		   }
		});
	}
	
	obj.Layer_Save2 = function(){
		var rd = obj.layer_rd;
		var ParLocDr = (rd ? rd["ID"] : '');
		var XCode = (rd ? rd["XCode"] : '');
		
		var LocCode = $.form.GetValue("txtLocCode");
		var LocDesc = $.form.GetValue("txtLocDesc");
		var LocDesc2 = $.form.GetValue("txtLocDesc2");
		var LocType = $.form.GetValue("cboLocType");
		var LocCate = $.form.GetValue("cboLocCate");
		var LocGroup = $.form.GetValue("cboLocGroup");
		var LocHosp = $.form.GetValue("cboLocHosp");
		var IsICU = $.form.GetValue("chkIsICU");
		var IsNICU = $.form.GetValue("chkIsNICU");
		var IsOPER = $.form.GetValue("chkIsOPER");
		var LocICUType = $.form.GetValue("cboLocICUType");
		var IsActive = $.form.GetValue("chkIsActive");
		var ActUserDr = $.LOGON.USERID;
		var IndNo = $.form.GetValue("txtIndNo");	
		
		if (LocCode == '') {
			layer.alert("科室代码不允许为空",{icon: 0});
			return;
		}
		if (LocDesc == '') {
			layer.alert("科室名称不允许为空",{icon: 0});
			return;
		}
		if (LocHosp == '') {
			layer.alert("科室所属院区不允许为空",{icon: 0});
			return;
		}
		if ((IsICU==1)&&(IsNICU==1)) {
			layer.alert("科室不能同时属于ICU科室和NICU科室",{icon: 0});
			return;
		}
		var InputStr = "";
		InputStr += "^" + LocCode;
		InputStr += "^" + LocDesc;
		InputStr += "^" + LocDesc2;
		InputStr += "^" + LocType;
		InputStr += "^" + LocCate;
		InputStr += "^" + LocGroup;
		InputStr += "^" + LocHosp;
		InputStr += "^" + IsOPER;
		InputStr += "^" + IsICU;
		InputStr += "^" + IsNICU;
		InputStr += "^" + LocICUType;
		InputStr += "^" + XCode;
		InputStr += "^" + IsActive;
		InputStr += "^" + "";
		InputStr += "^" + "";
		InputStr += "^" + ActUserDr;
		InputStr += "^" + ParLocDr;
		InputStr += "^" + IndNo;
		
		var retval = $.Tool.RunServerMethod("DHCHAI.BT.Location","Update2",InputStr);
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
			if(parseInt(retval)=='-2'){
				layer.alert('代码重复!',{icon: 0});
			}else {
				layer.msg('保存失败!',{icon: 2});
			}
		}
	}

	// 关联科室
	$("#btnLocLink").on('click', function(){
		var flag = $("#btnLocLink").hasClass("disabled");
		if(flag) return ;
		var selectedRows = obj.gridLocation.rows({selected: true}).count();
		if ( selectedRows !== 1 ) return;
		var rd = obj.gridLocation.rows({selected: true}).data().toArray()[0];
		obj.Layer_LocLink(rd);
	});

	obj.Layer_LocLink = function(rd){
		obj.LinkID = rd["ID"];
		obj.LinkHosp = rd['HospDr'];
		obj.LinkLocTypeCode = rd['LocTypeCode'];
		obj.gridLocLink.ajax.reload();
		layer.open({
		  type: 1,
		  zIndex: 100,
		  area: ['600px','360px'],
		  title: '关联科室',
		  content: $('#layer_LocLink'),
		  btn: ['关闭'],
		  btnAlign: 'c'
		});
	}

	obj.gridLocLink.on('select', function(e, dt, type, indexes) {
		var selectedRows = dt.rows({selected: true}).count();
		$("#btnAddLink").addClass('disabled');
        $("#btnEditLink").removeClass('disabled');
        $("#btnDeleteLink").removeClass('disabled');
	});
	
	obj.gridLocLink.on('deselect', function(e, dt, type, indexes) {
		var selectedRows = dt.rows({selected: true}).count(); 
		$("#btnAddLink").removeClass('disabled');
        $("#btnDeleteLink").addClass('disabled');
        $("#btnEditLink").addClass('disabled');
	});

	obj.gridLocLink.on('dblclick', 'tr', function(e) {
		var rd = obj.gridLocLink.row(this).data();
		$("#btnAddLink").removeClass('disabled');
        $("#btnEditLink").addClass('disabled');
        $("#btnDeleteLink").addClass('disabled');
	});

	$("#btnDeleteLink").on('click', function(){
		var flag = $("#btnDeleteLink").hasClass("disabled");
		if(flag) return ;
		var selectedRows = obj.gridLocLink.rows({selected: true}).count();
		if ( selectedRows !== 1 ) return;
		var rd = obj.gridLocLink.rows({selected: true}).data().toArray()[0];
		
		var ID = rd["RowID"];
		layer.confirm( '确认是否删除?', {
			btn: ['确认','取消'],    //btn位置对应function的位置
			btnAlign: 'c'
			},
			function(){ 
				var flg = $.Tool.RunServerMethod("DHCHAI.BT.LocationLink","DeleteById",ID);
				if (parseInt(flg)<0){
					layer.msg('删除失败!',{icon: 2});
				} else {
					obj.gridLocLink.rows({selected:true}).remove().draw(false);
					layer.msg('删除成功!',{icon: 1});
				}
		 });
	});

	$("#btnAddLink").on('click', function(){
		var flag = $("#btnAddLink").hasClass("disabled");
		if(flag) return ;
		obj.LayerEditLink();
	});

	$("#btnEditLink").on('click', function(){
		var flag = $("#btnEditLink").hasClass("disabled");
		if(flag) return ;
		var selectedRows = obj.gridLocLink.rows({selected: true}).count();
		if ( selectedRows !== 1 ) return;
		var rd = obj.gridLocLink.rows({selected: true}).data().toArray()[0];
		obj.LayerEditLink(rd);
	});

	obj.LayerEditLink = function(rd){
		if (obj.LinkLocTypeCode=='E'){
			var paramStr = obj.LinkHosp+"^^I|E^W^1"
		}else if(obj.LinkLocTypeCode=='W'){
			var paramStr = obj.LinkHosp+"^^I|E^E^1"
		}else{
			var paramStr = obj.LinkHosp+"^^I|E^^1"
		}
		$("#cboLocation").data("param",paramStr);
		$.form.SelectRender("cboLocation");  //渲染下拉框
		if (typeof(rd)!=='undefined'){
			$.form.SetValue("cboLocation",rd['LinkLocID'],rd['LinkLocDesc2']);
			var title='关联科室修改';
		}else{
			var title='关联科室增加';
		}

		layer.open({
		  type: 1,
		  zIndex: 100,
		  area: '400px',
		  title: title,
		  content: $('#layer_EditLocLink'),
		  btn: ['保存','关闭'],
		  btnAlign: 'c',
		  yes: function(index, layero){
			  obj.LayerEditLink_Save(rd);
		   }
		});
	}

	obj.LayerEditLink_Save = function(rd){
		var LinkLocID = $.form.GetValue("cboLocation");
		if (LinkLocID==''){
			layer.msg('请选择关联科室！',{icon: 0})
			return;
		}
		InputStr = (typeof(rd)=='undefined'?'':rd['RowID']);
		InputStr += "^" + obj.LinkID;
		InputStr += "^" + LinkLocID;
		InputStr += "^" + 1;
		InputStr += "^" + '';
		InputStr += "^" + '';
		InputStr += "^" + $.LOGON.USERID;
		var retval = $.Tool.RunServerMethod("DHCHAI.BT.LocationLink","Update",InputStr);
		if (parseInt(retval)>0){
			obj.gridLocLink.ajax.reload(function(){
				layer.msg('保存成功!',{icon: 1});
			},false);
		} else {
			layer.msg('保存失败!',{icon: 2});
		}
	}

}
