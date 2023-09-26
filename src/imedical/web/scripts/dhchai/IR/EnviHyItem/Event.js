//页面Event
function InitEnviHyItemWinEvent(obj){
	CheckSpecificKey();
	/*****搜索功能*****/
    $("#btnsearch").on('click', function(){
       $('#gridEvItem').DataTable().search($('#search').val(),true,true).draw();
       
    });
	
    $("#search").keyup(function(event){
        if (event.keyCode == 13) {
	        obj.gridEvItem.search(this.value).draw();
        }
    });
    /****************/
    $("#btnEdit").addClass('disabled');
    $("#btnDelete").addClass('disabled');
	obj.gridEvItem.on('select', function(e, dt, type, indexes) {
		var selectedRows = dt.rows({selected: true}).count();
		$("#btnAdd").addClass('disabled');
		$("#btnEdit").removeClass('disabled');
		$("#btnDelete").removeClass('disabled');
	});
	
	obj.gridEvItem.on('deselect', function(e, dt, type, indexes) {
		var selectedRows = dt.rows({selected: true}).count();
		$("#btnAdd").removeClass('disabled');
        $("#btnEdit").addClass('disabled');
        $("#btnDelete").addClass('disabled');
	});
	
	obj.gridEvItem.on('dblclick', 'tr', function(e) {
		var rd = obj.gridEvItem.row(this).data();
		
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
		var selectedRows = obj.gridEvItem.rows({selected: true}).count();
		if ( selectedRows !== 1 ) return;
		var rd = obj.gridEvItem.rows({selected: true}).data().toArray()[0];
		
		obj.layer_rd = rd;
		obj.Layer();
	});
	
	$("#btnDelete").on('click', function(){
		var flag = $("#btnDelete").hasClass("disabled");
		if(flag) return ;
		var selectedRows = obj.gridEvItem.rows({selected: true}).count();
		if ( selectedRows !== 1 ) return;
		var rd = obj.gridEvItem.rows({selected: true}).data().toArray()[0];
		
		var ID = rd["ID"];
		layer.confirm( '确认是否删除?', {
			btn: ['确认','取消'],    //btn位置对应function的位置
			btnAlign: 'c'
			},
			function(){ 
				var flg = $.Tool.RunServerMethod("DHCHAI.IR.EnviHyItem","DeleteById",ID);
				if (parseInt(flg)<0){
					layer.msg('删除失败!',{icon: 2});
				} else {
					obj.gridEvItem.rows({selected:true}).remove().draw(false);
					layer.msg('删除成功!',{icon: 1});
				}
		 });
	});
	
	//监测项目编辑窗体-初始化
	obj.Layer = function(){
		$.form.iCheckRender();
		$.form.SelectRender('cboSpecimenType');
		$.form.SelectRender('cboItemType');
		$.form.SelectRender('cboEnvironmentCate');
		var rd = obj.layer_rd;
		if (rd){
			$.form.SetValue("txtItemDesc",rd["ItemDesc"]);
			$.form.SetValue('cboItemType',rd["ItemTypeID"],rd["ItemTypeDesc"]);
			$.form.SetValue('cboSpecimenType',rd["SpecimenTypeID"],rd["SpecimenTypeDesc"]);
			$.form.SetValue("txtNorm",rd["Norm"]);
			$.form.SetValue("txtNormMax",rd["NormMax"]);
			$.form.SetValue("txtNormMin",rd["NormMin"]);
			$.form.SetValue("txtSpecimenNum",rd["SpecimenNum"]);
			$.form.SetValue("txtCenterNum",rd["CenterNum"]);
			$.form.SetValue("txtSurroundNum",rd["SurroundNum"]);
			$.form.SetValue("txtForMula",rd["ForMula"]);
			$.form.SetValue("txtFreq",rd["Freq"]);
			$.form.SetValue("txtUom",rd["Uom"]);
			$.form.SetValue('cboEnvironmentCate',rd["EnvironmentCateID"],rd["EnvironmentCateDesc"]);
			$.form.SetValue("chkActive",rd["IsActive"]== 1);
		} else {
			$.form.SetValue("txtItemDesc",'');
			$.form.SetValue('cboSpecimenType','');
			$.form.SetValue('cboItemType','');
			$.form.SetValue("txtNorm",'');
			$.form.SetValue("txtNormMax",'');
			$.form.SetValue("txtNormMin",'');
			$.form.SetValue("txtSpecimenNum",'');
			$.form.SetValue("txtCenterNum",'');
			$.form.SetValue("txtSurroundNum",'');
			$.form.SetValue("txtForMula",'');
			$.form.SetValue("txtFreq",'');
			$.form.SetValue("txtUom",'');
			$.form.SetValue("cboEnvironmentCate",'');
			$.form.SetValue("chkActive",'');
		}
		
		layer.config({  
			extend: 'layerskin/style.css' 
		});
	
		layer.open({
			type: 1,
			zIndex: 100,
			area: '700px',
			skin: 'layer-class',
			title: '监测项目编辑', 
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
				var button0 = layero.find(".layui-layer-btn0");
				var button1 = layero.find(".layui-layer-btn1");
				if (rd) {
					$(button0).hide();
				}else{
					$(button1).hide();
				}
				
			}	
		}); 	
	}
	
	//监测项目编辑窗体-保存
	obj.Layer_Save = function(){
		var rd = obj.layer_rd;
		var ID = (rd ? rd["ID"] : '');
		
		var ItemDesc = $.form.GetValue("txtItemDesc");
		var ItemTypeDesc = $.form.GetText('cboItemType');
		var ItemTypeID = $.form.GetValue('cboItemType');
		var EnvironmentCateDesc = $.form.GetText('cboEnvironmentCate');
		var SpecimenTypeDesc = $.form.GetText('cboSpecimenType');
		var SpecimenTypeID = $.form.GetValue('cboSpecimenType');
		var Norm = $.form.GetValue("txtNorm");
		var NormMax = $.form.GetValue("txtNormMax");
		var NormMin = $.form.GetValue("txtNormMin");
		var SpecimenNum = $.form.GetValue("txtSpecimenNum");
		var CenterNum = $.form.GetValue("txtCenterNum");
		var SurroundNum = $.form.GetValue("txtSurroundNum");
		var ForMula = $.form.GetValue("txtForMula");
		var Freq = $.form.GetValue("txtFreq");
		var Uom = $.form.GetValue("txtUom");
		var IsActive =$.form.GetValue("chkActive");
		if (ItemTypeID == '') {
			layer.alert("项目类型不允许为空",{icon: 0});
			return;
		}
		if (ItemDesc == '') {
			layer.alert("项目名称不允许为空",{icon: 0});
			return;
		}
		if (SpecimenTypeID == '') {
			layer.alert("标本类型不允许为空",{icon: 0});
			return;
		}
		if (Norm == '') {
			layer.alert("检测标准不允许为空",{icon: 0});
			return;
		}
		if (NormMax == '') {
			layer.alert("中心值不允许为空",{icon: 0});
			return;
		}
		if (NormMin == '') {
			layer.alert("周边值不允许为空",{icon: 0});
			return;
		}
		if (SpecimenNum == '') {
			layer.alert("标本个数不允许为空",{icon: 0});
			return;
		}
		if (CenterNum == '') {
			layer.alert("中心个数不允许为空",{icon: 0});
			return;
		}
		if (SurroundNum == '') {
			layer.alert("周边个数不允许为空",{icon: 0});
			return;
		}
		if (parseInt(CenterNum)>parseInt(SpecimenNum)){
			layer.alert("中心个数不允许大于标本个数",{icon: 0});
			return;
		}
		if (parseInt(SurroundNum)>parseInt(SpecimenNum)){
			layer.alert("周边个数不允许大于标本个数",{icon: 0});
			return;
		}
		if ((parseInt(CenterNum)+parseInt(SurroundNum))>parseInt(SpecimenNum)){
			layer.alert("中心个数、周边个数总数不允许大于标本个数",{icon: 0});
			return;
		}

		var InputStr = ID;
		InputStr += "^" + ItemDesc;
		InputStr += "^" + SpecimenTypeDesc;
		InputStr += "^" + Norm;
		InputStr += "^" + NormMax;
		InputStr += "^" + NormMin;
		InputStr += "^" + SpecimenNum;
		InputStr += "^" + CenterNum;
		InputStr += "^" + SurroundNum;
		InputStr += "^" + ForMula;
		InputStr += "^" + Freq;
		InputStr += "^" + Uom;
		InputStr += "^" + IsActive;
		InputStr += "^" + ItemTypeDesc;
		InputStr += "^" + EnvironmentCateDesc;
		var retval = $.Tool.RunServerMethod("DHCHAI.IR.EnviHyItem","Update",InputStr);
		if (parseInt(retval)>0){
			obj.gridEvItem.ajax.reload(function(){
				var rowIndex = $.Tool.GetTableRowIndex(obj.gridEvItem,retval);
				if (rowIndex > -1){
					var rd =obj.gridEvItem.row(rowIndex).data();
					obj.layer_rd = rd;
				} else {
					obj.layer_rd = '';
				}
				layer.msg('保存成功!',{icon: 1});
			},false);
		} else {
			if(parseInt(retval)=='-100'){
				layer.alert('项目名称重复!',{icon: 0});
			}else {
				layer.msg('保存失败!',{icon: 2});
			}
		}
	}
	
	//监测项目编辑窗体-提交
	obj.Layer_Add = function(){
		var rd = "";
		var ID = (rd ? rd["ID"] : '');
		
		var ItemDesc = $.form.GetValue("txtItemDesc");
		var ItemTypeDesc = $.form.GetText('cboItemType');
		var ItemTypeID = $.form.GetValue('cboItemType');
		var EnvironmentCateDesc = $.form.GetText('cboEnvironmentCate');
		var SpecimenTypeDesc = $.form.GetText('cboSpecimenType');
		var SpecimenTypeID = $.form.GetValue('cboSpecimenType');
		var Norm = $.form.GetValue("txtNorm");
		var NormMax = $.form.GetValue("txtNormMax");
		var NormMin = $.form.GetValue("txtNormMin");
		var SpecimenNum = $.form.GetValue("txtSpecimenNum");
		var CenterNum = $.form.GetValue("txtCenterNum");
		var SurroundNum = $.form.GetValue("txtSurroundNum");
		var ForMula = $.form.GetValue("txtForMula");
		var Freq = $.form.GetValue("txtFreq");
		var Uom = $.form.GetValue("txtUom");
		var IsActive =$.form.GetValue("chkActive");
		if (ItemTypeID == '') {
			layer.alert("项目类型不允许为空",{icon: 0});
			return;
		}
		if (ItemDesc == '') {
			layer.alert("项目名称不允许为空",{icon: 0});
			return;
		}
		if (SpecimenTypeID == '') {
			layer.alert("标本类型不允许为空",{icon: 0});
			return;
		}
		if (Norm == '') {
			layer.alert("检测标准不允许为空",{icon: 0});
			return;
		}
		if (NormMax == '') {
			layer.alert("中心值不允许为空",{icon: 0});
			return;
		}
		if (NormMin == '') {
			layer.alert("周边值不允许为空",{icon: 0});
			return;
		}
		if (SpecimenNum == '') {
			layer.alert("标本个数不允许为空",{icon: 0});
			return;
		}
		if (CenterNum == '') {
			layer.alert("中心个数不允许为空",{icon: 0});
			return;
		}
		if (SurroundNum == '') {
			layer.alert("周边个数不允许为空",{icon: 0});
			return;
		}
		if (parseInt(CenterNum)>parseInt(SpecimenNum)){
			layer.alert("中心个数不允许大于标本个数",{icon: 0});
			return;
		}
		if (parseInt(SurroundNum)>parseInt(SpecimenNum)){
			layer.alert("周边个数不允许大于标本个数",{icon: 0});
			return;
		}
		if ((parseInt(CenterNum)+parseInt(SurroundNum))>parseInt(SpecimenNum)){
			layer.alert("中心个数、周边个数总数不允许大于标本个数",{icon: 0});
			return;
		}
		
		var InputStr = ID;
		InputStr += "^" + ItemDesc;
		InputStr += "^" + SpecimenTypeDesc;
		InputStr += "^" + Norm;
		InputStr += "^" + NormMax;
		InputStr += "^" + NormMin;
		InputStr += "^" + SpecimenNum;
		InputStr += "^" + CenterNum;
		InputStr += "^" + SurroundNum;
		InputStr += "^" + ForMula;
		InputStr += "^" + Freq;
		InputStr += "^" + Uom;
		InputStr += "^" + IsActive;
		InputStr += "^" + ItemTypeDesc;
		InputStr += "^" + EnvironmentCateDesc;
		var retval = $.Tool.RunServerMethod("DHCHAI.IR.EnviHyItem","Update",InputStr);
		if (parseInt(retval)>0){
			obj.gridEvItem.ajax.reload(function(){
				var rowIndex = $.Tool.GetTableRowIndex(obj.gridEvItem,retval);
				if (rowIndex > -1){
					var rd =obj.gridEvItem.row(rowIndex).data();
					obj.layer_rd = rd;
				} else {
					obj.layer_rd = '';
				}
				layer.msg('保存成功!',{icon: 1});
			},false);
		} else {
			if(parseInt(retval)=='-100'){
				layer.alert('项目名称重复!',{icon: 0});
			}else {
				layer.msg('保存失败!',{icon: 2});
			}
		}
	}
}