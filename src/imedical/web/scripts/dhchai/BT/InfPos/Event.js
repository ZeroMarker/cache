//页面Event
function InitInfPosWinEvent(obj){
	CheckSpecificKey();
	$.form.iCheckRender();
	//$.form.SelectRender("winInfPosEditModal");  //渲染下拉框
	/*****搜索功能*****/
    $("#btnsearch").on('click', function(){
       $('#gridInfPos').DataTable().search($('#search').val(),true,true).draw();
       
    });
	
    $("#search").keyup(function(event){
        if (event.keyCode == 13) {
	        obj.gridInfPos.search(this.value).draw();
        }
    });
    /****************/
    $("#btnEdit").addClass('disabled');
    $("#btnDelete").addClass('disabled');
	obj.gridInfPos.on('select', function(e, dt, type, indexes) {
		var rd = dt.rows({selected: true}).data().toArray()[0];
		obj.layer_rd = rd;
		obj.gridInfSub.ajax.reload();
		var selectedRows = dt.rows({selected: true}).count();
		$("#btnAdd").addClass('disabled');
		$("#btnEdit").removeClass('disabled');
		$("#btnDelete").removeClass('disabled');
	});
	
	obj.gridInfPos.on('deselect', function(e, dt, type, indexes) {
		var selectedRows = dt.rows({selected: true}).count();
		$("#btnAdd").removeClass('disabled');
        $("#btnEdit").addClass('disabled');
        $("#btnDelete").addClass('disabled');
	});
	
	obj.gridInfPos.on('dblclick', 'tr', function(e) {
		var rd = obj.gridInfPos.row(this).data();
		obj.layer_rd = rd;
		obj.Layer();
	});
	$('#gridInfSub tbody').on('change', '.icheckbox_square-blue input[type=checkbox]', function(){
    	if(this.checked){
	    	// 建立关联关系
	    	var InfSubDesc = $(this).parent().parent().next().text(); 	
	    	if (obj.layer_rd){
		    	var InfPosDiagFlag = obj.layer_rd["DiagFlag"];
		    	if (InfPosDiagFlag=="0"){
			    	this.checked=false;
			    	layer.alert("感染部位不能关联诊断分类！",{icon: 0});
			    	return;
			    }
			   
		    	var InfPosDesc = obj.layer_rd["Desc"];
		    	var inputStr=InfPosDesc+"^"+InfSubDesc;
		    	var flg = $.Tool.RunServerMethod("DHCHAI.BTS.InfPosSrv","ImportInfDiagMap",inputStr,"^");
		    	if (parseInt(flg) <= 0) {
					layer.alert("错误提示:关联感染诊断分类错误!",{icon: 0});
					return;
				}else {
					$(this).parent().addClass("checked");
				}
		    }else{
			    this.checked=false;
			    layer.alert('请先选择感染诊断!',{icon: 0});
				return;
			}
    	}else{
	    	// 取消关联    	
	    	var InfSubDesc = $(this).parent().parent().next().text();
	    	var InfPosDesc = obj.layer_rd["Desc"];
	    	var inputStr=InfPosDesc+"^"+InfSubDesc;
	    	var flg = $.Tool.RunServerMethod("DHCHAI.BTS.InfPosSrv","CancelInfDiagMap",inputStr,"^");
	    	if (parseInt(flg) < 0) {
				layer.alert("错误提示:取消关联感染诊断分类错误!",{icon: 0});
				return;
			}else {
				$(this).parent().removeClass("checked");
			}
	    }
    });
   
	$(".check-All .iCheck-helper").click(function(){
		if ($(".check-All .iCheck-helper").attr("class").indexOf("checked")>0){
			obj.checkAll = 0;
			$(".check-All .iCheck-helper").removeClass("checked");
			$(".check-All .icheckbox_square-blue").removeClass("checked");
		}
		else{
			obj.checkAll = 1;
			if (obj.layer_rd){
		    	var InfPosDiagFlag = obj.layer_rd["DiagFlag"];
		    	if (InfPosDiagFlag=="0"){
			    	layer.alert("感染部位不能关联诊断分类！",{icon: 0});
			    	obj.checkAll = 0;
			    }
			}
			if(obj.checkAll==1){
				$(".check-All .iCheck-helper").addClass("checked");
				$(".check-All .icheckbox_square-blue").addClass("checked");
			}else{
				$(".check-All .icheckbox_square-blue").removeClass("checked");
			}
		}
		obj.gridInfSub.ajax.reload();
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
		var selectedRows = obj.gridInfPos.rows({selected: true}).count();
		if ( selectedRows !== 1 ) return;
		var rd = obj.gridInfPos.rows({selected: true}).data().toArray()[0];
		
		obj.layer_rd = rd;
		obj.Layer();
	});
	
	$("#btnDelete").on('click', function(){
		var flag = $("#btnDelete").hasClass("disabled");
		if(flag) return ;
		var selectedRows = obj.gridInfPos.rows({selected: true}).count();
		if ( selectedRows !== 1 ) return;
		var rd = obj.gridInfPos.rows({selected: true}).data().toArray()[0];
		
		var ID = rd["ID"];
		layer.confirm( '确认是否删除?', {
			btn: ['确认','取消'],    //btn位置对应function的位置
			btnAlign: 'c'
			},
			function(){ 
				var flg = $.Tool.RunServerMethod("DHCHAI.BT.InfPos","DeleteById",ID);
				if (parseInt(flg)<0){
					layer.msg('删除失败!',{icon: 2});
				} else {
					obj.gridInfPos.rows({selected:true}).remove().draw(false);
					layer.msg('删除成功!',{icon: 1});
				}
		 });
		
	});
	
	//感染诊断（部位）信息编辑窗体-初始化
	obj.Layer = function(){
		var rd = obj.layer_rd;
		if (rd){
			$.form.SetValue("txtBTCode",rd["Code"]);
			$.form.SetValue("txtBTDesc",rd["Desc"]);
			$.form.SetValue("txtGCode",rd["GCode"]);
			$.form.SetValue("chkDiagFlag",rd["DiagFlag"]== 1);
			$.form.SetValue("chkActive",rd["IsActive"]== 1);
		} else {
			$.form.SetValue("txtBTCode",'');
			$.form.SetValue("txtBTDesc",'');
			$.form.SetValue("txtGCode",'');
			$.form.SetValue("chkDiagFlag",false);
			$.form.SetValue("chkActive",false);
		}
		
		layer.config({  
			extend: 'layerskin/style.css' 
		});
	
		layer.open({
			type: 1,
			zIndex: 100,
			area: '600px',
			skin: 'layer-class',
			title: '感染诊断部位编辑', 
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
	
	//感染诊断（部位）信息编辑窗体-保存
	obj.Layer_Save = function(){
		var rd = obj.layer_rd;
		var ID = (rd ? rd["ID"] : '');
		
		var Code = $.form.GetValue("txtBTCode");
		var Desc = $.form.GetValue("txtBTDesc");
		var GCode  = $.form.GetValue("txtGCode");
		var DiagFlag   = $.form.GetValue("chkDiagFlag");
		var IsActive = $.form.GetValue("chkActive");
		
		if (Code == '') {
			layer.alert("代码不允许为空",{icon: 0});
			return;
		}
		if (Desc == '') {
			layer.alert("名称不允许为空",{icon: 0});
			return;
		}
		if (GCode == '') {
			layer.alert("层级编码不允许为空",{icon: 0});
			return;
		}
		//当诊断标志按钮关闭时，判断是否关联诊断分类
		if (DiagFlag == 0){			
			var rechk = $.Tool.RunServerMethod("DHCHAI.BT.InfPosExt","CheckIsMap",ID)
			if(rechk == 10 || rechk == 11){
				layer.msg("该诊断已关联诊断分类，请先取消关联",{time: 3000,icon: 0});
				$.form.SetValue("chkDiagFlag",rd["DiagFlag"]== 1);
				return
			}
		}
		
		var InputStr = ID;
		InputStr += "^" + Code;
		InputStr += "^" + Desc;
		InputStr += "^" + DiagFlag;
		InputStr += "^" + GCode;
		InputStr += "^" + IsActive;
		
		var retval = $.Tool.RunServerMethod("DHCHAI.BT.InfPos","Update",InputStr);
		if (parseInt(retval)>0){
			obj.gridInfPos.ajax.reload(function(){
				var rowIndex = $.Tool.GetTableRowIndex(obj.gridInfPos,retval);
				if (rowIndex > -1){
					var rd =obj.gridInfPos.row(rowIndex).data();
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
	
	//感染诊断（部位）信息编辑窗体-添加
	obj.Layer_Add = function(){
		var rd = "";
		var ID = (rd ? rd["ID"] : '');
		var Code = $.form.GetValue("txtBTCode");
		var Desc = $.form.GetValue("txtBTDesc");
		var GCode  = $.form.GetValue("txtGCode");
		var DiagFlag   = $.form.GetValue("chkDiagFlag");
		var IsActive = $.form.GetValue("chkActive");
		
		if (Code == '') {
			layer.alert("代码不允许为空",{icon: 0});
			return;
		}
		if (Desc == '') {
			layer.alert("名称不允许为空",{icon: 0});
			return;
		}
		if (GCode == '') {
			layer.alert("层级编码不允许为空",{icon: 0});
			return;
		}
		
		var InputStr = ID;
		InputStr += "^" + Code;
		InputStr += "^" + Desc;
		InputStr += "^" + DiagFlag;
		InputStr += "^" + GCode;
		InputStr += "^" + IsActive;
	
		var retval = $.Tool.RunServerMethod("DHCHAI.BT.InfPos","Update",InputStr);
		if (parseInt(retval)>0){
			obj.gridInfPos.ajax.reload(function(){
				var rowIndex = $.Tool.GetTableRowIndex(obj.gridInfPos,retval);
				if (rowIndex > -1){
					var rd =obj.gridInfPos.row(rowIndex).data();
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
	
	$('#gridInfPos').on('click','a.btnInfPosGist', function (e) {
		e.preventDefault();
		var tr = $(this).closest('tr');
		var row = obj.gridInfPos.row(tr);
		var rowData = row.data();
		obj.layer_rd = rowData;
	    obj.gridInfPosGist.ajax.reload();
		layer.open({
			type: 1,
			zIndex: 101,
			area: '800px',
			title: '诊断依据编辑',
			content: $('#layerPosGist')			
		});
	    $("#bodyPosGist").mCustomScrollbar({
			theme: "dark-thick",
			axis: "y",
			scrollInertia: 100
	    });
    });
    
    $("#btnGistEdit").addClass('disabled');
    $("#btnGistDelete").addClass('disabled');
    obj.gridInfPosGist.on('select', function (e, dt, type, indexes) {
		var selectedRows = dt.rows({selected: true}).count();
		$("#btnGistAdd").addClass('disabled')
		$("#btnGistEdit").removeClass('disabled');
		$("#btnGistDelete").removeClass('disabled');
	});
	
	obj.gridInfPosGist.on('deselect', function(e, dt, type, indexes) {
		var selectedRows = dt.rows({selected: true}).count();
		$("#btnGistAdd").removeClass('disabled');
        $("#btnGistEdit").addClass('disabled');
        $("#btnGistDelete").addClass('disabled');
	});
	$("#btnGistAdd").on('click', function(){
		var flag = $("btnGistAdd").hasClass("disabled");
		if(flag) return ;
		obj.layergist_rd = '';
		obj.Layer_Gist();
	});
	
	$("#btnGistEdit").on('click', function(){
		var flag = $("#btnGistEdit").hasClass("disabled");
		if(flag) return ;
		var selectedRows = obj.gridInfPosGist.rows({selected: true}).count();
		if ( selectedRows !== 1 ) return;
		var rd = obj.gridInfPosGist.rows({selected: true}).data().toArray()[0];
		
		obj.layergist_rd = rd;
		obj.Layer_Gist();
	});
	
	$("#btnGistDelete").on('click', function(){
		var flag = $("#btnGistDelete").hasClass("disabled");
		if(flag) return ;
		var selectedRows = obj.gridInfPosGist.rows({selected: true}).count();
		if ( selectedRows !== 1 ) return;
		var rd = obj.gridInfPosGist.rows({selected: true}).data().toArray()[0];
		
		var ID = rd["ID"];
		layer.confirm( '确认是否删除?', {
			btn: ['确认','取消'],    //btn位置对应function的位置
			btnAlign: 'c'
			},
			function(){ 
				var flg = $.Tool.RunServerMethod("DHCHAI.BT.InfPosGist","DeleteById",ID);
				if (parseInt(flg)<0){
					layer.msg('删除失败!',{icon: 2});
				} else {
					obj.gridInfPosGist.rows({selected:true}).remove().draw(false);
					layer.msg('删除成功!',{icon: 1});
				}
		 });
		
	});
	
	//感染诊断诊断依据编辑窗体-初始化
	obj.Layer_Gist = function(){
		$.form.SelectRender("cboDiagType");  //渲染下拉框
		var rd = obj.layergist_rd;
		if (rd){
			$.form.SetValue("txtCode",rd["Code"]);
			$.form.SetValue("txtDesc",rd["Desc"]);
			$.form.SetValue("cboDiagType",rd["TypeDr"],rd["TypeDesc"]);
		} else {
			$.form.SetValue("txtCode",'');
			$.form.SetValue("txtDesc",'');
			$.form.SetValue("cboDiagType",'');
		}
		
		layer.config({  
			extend: 'layerskin/style.css' 
		});
	
		layer.open({
			type: 1,
			zIndex: 102,
			area: '600px',
			skin: 'layer-class',
			title: '诊断依据编辑', 
			content: $('#layergist'),
			btn: ['添加','保存','关闭'],
			btnAlign: 'c',
			yes: function(index, layero){
			  	obj.Layer_Gist_Add();
			},
			btn2: function(index, layero){
				obj.Layer_Gist_Save();
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
	
	//感染诊断诊断依据编辑窗体-保存
	obj.Layer_Gist_Save = function(){
		var rd = obj.layergist_rd;
		var ID = (rd ? rd["ID"] : '');
		var ObjInfPos =obj.layer_rd;
		
		var DiagCode = $.form.GetValue("txtCode");
		var DiagDesc = $.form.GetValue("txtDesc");
		var TypeDr = $.form.GetValue("cboDiagType");
		
		if (TypeDr == '') {
			layer.alert("诊断依据类型不允许为空",{icon: 0});
			return;
		}
		if (DiagCode == '') {
			layer.alert("诊断依据代码不允许为空",{icon: 0});
			return;
		}
		if (DiagDesc == '') {
			layer.alert("诊断依据内容不允许为空",{icon: 0});
			return;
		}
		
		var InputStr = ID;
		InputStr += "^" + ObjInfPos["ID"];
		InputStr += "^" + TypeDr;
		InputStr += "^" + DiagCode;
		InputStr += "^" + DiagDesc;
		InputStr += "^" + "";
		InputStr += "^" + "";
		InputStr += "^" + $.LOGON.USERID;;
		
		var retval = $.Tool.RunServerMethod("DHCHAI.BT.InfPosGist","Update",InputStr);
		if (parseInt(retval)>0){
			obj.gridInfPosGist.ajax.reload(function(){
				var rowIndex = $.Tool.GetTableRowIndex(obj.gridInfPosGist,retval);
				if (rowIndex > -1){
					var rd =obj.gridInfPosGist.row(rowIndex).data();
					obj.layergist_rd = rd;
				} else {
					obj.layergist_rd = '';
				}
				layer.msg('保存成功!',{icon: 1});
			},false);
		} else {
			if(parseInt(retval)=='-2'){
				layer.alert('不允许重复添加!',{icon: 0});
			}else {
				layer.msg('保存失败!',{icon: 2});
			}
		}
	}
	
	//感染诊断诊断依据信息编辑窗体-添加
	obj.Layer_Gist_Add = function(){
		var rd = "";
		var ID = (rd ? rd["ID"] : '');
		var ObjInfPos =obj.layer_rd;
		
		var DiagCode = $.form.GetValue("txtCode");
		var DiagDesc = $.form.GetValue("txtDesc");
		var TypeDr = $.form.GetValue("cboDiagType");
       
		if (TypeDr == '') {
			layer.alert("诊断依据类型不允许为空",{icon: 0});
			return;
		}
		if (DiagCode == '') {
			layer.alert("诊断依据代码不允许为空",{icon: 0});
			return;
		}
		if (DiagDesc == '') {
			layer.alert("诊断依据内容不允许为空",{icon: 0});
			return;
		}
		
		var InputStr = ID;
		InputStr += "^" + ObjInfPos["ID"];
		InputStr += "^" + TypeDr;
		InputStr += "^" + DiagCode;
		InputStr += "^" + DiagDesc;
		InputStr += "^" + "";
		InputStr += "^" + "";
		InputStr += "^" + $.LOGON.USERID;;
	
		var retval = $.Tool.RunServerMethod("DHCHAI.BT.InfPosGist","Update",InputStr);
		if (parseInt(retval)>0){
			obj.gridInfPosGist.ajax.reload(function(){
				var rowIndex = $.Tool.GetTableRowIndex(obj.gridInfPosGist,retval);
				if (rowIndex > -1){
					var rd =obj.gridInfPosGist.row(rowIndex).data();
					obj.layergist_rd = rd;
				} else {
					obj.layergist_rd = '';
				}
				layer.msg('保存成功!',{icon: 1});
			},false);
		} else {
			if(parseInt(retval)=='-2'){
				layer.alert('诊断依据内容重复!',{icon: 0});
			}else {
				layer.msg('保存失败!',{icon: 2});
			}
		}
	}
}
