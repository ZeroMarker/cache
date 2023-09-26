//页面Event
function InitCRuleDefWinEvent(obj){
	$.form.iCheckRender(); //单选按钮
	CheckSpecificKey();
	layer.config({  
		extend: 'layerskin/style.css' 
	});

    /*****搜索功能*****/
    $("#btnsearch_one").on('click', function(){
       $('#gridCRuleDef').DataTable().search($('#search_one').val(),true,true).draw();
       
    });
	
    $("#search_one").keyup(function(event){
        if (event.keyCode == 13) {
	        obj.gridCRuleDef.search(this.value).draw();
        }
    });
   /**********************/

    $("#btnEdit_one").addClass('disabled');
    $("#btnDelete_one").addClass('disabled');
	obj.gridCRuleDef.on('select', function(e, dt, type, indexes) {
		var selectedRows = dt.rows({selected: true}).count();
		$("#btnAdd_one").addClass('disabled');
		$("#btnEdit_one").removeClass('disabled');
		$("#btnDelete_one").removeClass('disabled');
		obj.gridCRuleDefExt.ajax.reload(function(){
			$("#btnAdd_two").removeClass('disabled');
		});
	});
	
	obj.gridCRuleDef.on('deselect', function(e, dt, type, indexes) {
		var selectedRows = dt.rows({selected: true}).count();
		$("#btnAdd_one").removeClass('disabled');
        $("#btnEdit_one").addClass('disabled');
        $("#btnDelete_one").addClass('disabled');
        obj.gridCRuleDefExt.ajax.reload(function(){
			$("#btnAdd_two").addClass('disabled');
		});
	});
	
	obj.gridCRuleDef.on('dblclick', 'tr', function(e) {
		var rd = obj.gridCRuleDef.row(this).data();
		obj.layer_rd = rd;
		obj.Layer_one();
	    
	});
	
	$("#btnAdd_one").on('click', function(){
		var flag = $("#btnAdd_one").hasClass("disabled");
		if(flag) return ;	
		obj.layer_rd = '';
		obj.Layer_one();
		
	});
	
	$("#btnEdit_one").on('click', function(){
		var flag = $("#btnEdit_one").hasClass("disabled");
		if(flag) return ;
		var selectedRows = obj.gridCRuleDef.rows({selected: true}).count();
		if ( selectedRows !== 1 ) return;
		var rd = obj.gridCRuleDef.rows({selected: true}).data().toArray()[0];
		
		obj.layer_rd = rd;
	    obj.Layer_one();

	});

	$("#btnDelete_one").on('click', function(){
		var flag = $("#btnDelete_one").hasClass("disabled");
		if(flag) return ;
		var selectedRows = obj.gridCRuleDef.rows({selected: true}).count();
		if ( selectedRows !== 1 ) return;
		var rd = obj.gridCRuleDef.rows({selected: true}).data().toArray()[0];
		
		var ID = rd["ID"];
		layer.confirm( '确认是否删除?', {
			btn: ['确认','取消'],    //btn位置对应function的位置
			btnAlign: 'c'
			},
			function(){ 
				var flg = $.Tool.RunServerMethod("DHCHAI.IR.CRuleDef","DeleteById",ID);
				if (parseInt(flg)<0){
					layer.msg('删除失败!',{icon: 2});
				} else {
					obj.gridCRuleDef.rows({selected:true}).remove().draw(false);
					layer.msg('删除成功!',{icon: 1});
				}
		 });
	});
  
	//感染诊断标准定义编辑窗体-初始化
	obj.Layer_one = function(){	
		$.form.iCheckRender();
		$.form.SelectRender("cboInfPos");  //渲染下拉框
		
        var rd = obj.layer_rd;
		if (rd){
			$.form.SetValue("cboInfPos",rd["InfPosID"],rd["InfPosDesc"]);
			$.form.SetValue("txtTitle",rd["Title"]);
			$.form.SetValue("txtNote",rd["Note"]);
			$.form.SetValue("txtIndNo",rd["IndNo"]);
			$.form.SetValue("txtMaxAge",rd["MaxAge"]);
			$.form.SetValue("txtMinAge",rd["MinAge"]);
			$.form.SetValue("chkActive",rd["IsActive"]== 1);
		} else {
			$.form.SetValue("cboInfPos", '');
			$.form.SetValue("txtTitle", '');  
			$.form.SetValue("txtNote", '');  
			$.form.SetValue("txtIndNo",''); 
			$.form.SetValue("txtMaxAge",'');
			$.form.SetValue("txtMinAge", '');
			$.form.SetValue("chkActive", '');	
		}
		
	
		layer.open({
			type: 1,
			zIndex: 100,
			area: '600px',
			skin: 'layer-class',
			title: '感染诊断标准编辑', 
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
	
	//感染诊断标准定义配置窗体-保存
	obj.LayerOne_Save = function(){
		var rd = obj.layer_rd;
		var ID = (rd ? rd["ID"] : '');
		
		var PosDr = $.form.GetValue('cboInfPos');
		var Title = $.form.GetValue("txtTitle");
		var Note = $.form.GetValue("txtNote");
		var IndNo = $.form.GetValue("txtIndNo");
		var MaxAge = $.form.GetValue("txtMaxAge");
		var MinAge = $.form.GetValue("txtMinAge");
		var IsActive = $.form.GetValue("chkActive");
		
		if (PosDr == '') {
			layer.alert("感染诊断描述不允许为空",{icon: 0});
			return;
		}
		if (Title == '') {
			layer.alert("标准定义不允许为空",{icon: 0});
			return;
		}
		if (Note == '') {
			layer.alert("标准解读不允许为空",{icon: 0});
			return;
		}
		if ((MaxAge !="")&&(MinAge!="")&&(parseInt(MaxAge)>parseInt(MinAge))) {
			layer.alert("年龄下限不能大于年龄上限");
			return;
		}
		var InputStr = ID;
		InputStr += "^" + PosDr;
		InputStr += "^" + Title;
		InputStr += "^" + Note;
		InputStr += "^" + IndNo;
		InputStr += "^" + IsActive;
		InputStr += "^" + MaxAge;
		InputStr += "^" + MinAge;
		
		var retval = $.Tool.RunServerMethod("DHCHAI.IR.CRuleDef","Update",InputStr);
		if (parseInt(retval)>0){
			obj.gridCRuleDef.ajax.reload(function(){
				var rowIndex = $.Tool.GetTableRowIndex(obj.gridCRuleDef,retval);
				if (rowIndex > -1){
					var rd =obj.gridCRuleDef.row(rowIndex).data();
					obj.layer_rd = rd;
				} else {
					obj.layer_rd = '';
				}
				layer.msg('保存成功!',{icon: 1});
			},false);
		} else {
			layer.msg('感染诊断描述重复!',{icon: 2});
			
		}
	}
	
	//感染诊断标准定义配置窗体-添加
	 obj.LayerOne_Add = function(){
		var rd = "";
		var ID = (rd ? rd["ID"] : '');
	
	    var PosDr = $.form.GetValue('cboInfPos');
		var Title = $.form.GetValue("txtTitle");
		var Note = $.form.GetValue("txtNote");
		var IndNo = $.form.GetValue("txtIndNo");
		var MaxAge = $.form.GetValue("txtMaxAge");
		var MinAge = $.form.GetValue("txtMinAge");
		var IsActive = $.form.GetValue("chkActive");
		
		if (PosDr == '') {
			layer.alert("感染诊断部位不允许为空",{icon: 0});
			return;
		}
		if (Title == '') {
			layer.alert("标准定义不允许为空",{icon: 0});
			return;
		}
		if (Note == '') {
			layer.alert("标准解读不允许为空",{icon: 0});
			return;
		}
		if ((MaxAge !="")&&(MinAge!="")&&(parseInt(MaxAge)>parseInt(MinAge))) {
			layer.alert("年龄下限不能大于年龄上限");
			return;
		}
		var InputStr = ID;
		InputStr += "^" + PosDr;
		InputStr += "^" + Title;
		InputStr += "^" + Note;
		InputStr += "^" + IndNo;
		InputStr += "^" + IsActive;
		InputStr += "^" + MaxAge;
		InputStr += "^" + MinAge;
	
	    var retval = $.Tool.RunServerMethod("DHCHAI.IR.CRuleDef","Update",InputStr);
		if (parseInt(retval)>0){
			obj.gridCRuleDef.ajax.reload(function(){
				var rowIndex = $.Tool.GetTableRowIndex(obj.gridCRuleDef,retval);
				if (rowIndex > -1){
					var rd =obj.gridCRuleDef.row(rowIndex).data();
					obj.layer_rd = rd;
				} else {
					obj.layer_rd = '';
				}
				layer.msg('保存成功!',{icon: 1});
			},false);
		} else {
			layer.msg('感染诊断描述重复!',{icon: 2});
			
		}
	}
	
	//感染诊断定义
	/*****搜索功能*****/
    $("#btnsearch_two").on('click', function(){
       $('#gridCRuleDefExt').DataTable().search($('#search_two').val(),true,true).draw();
       
    });
	
    $("#search_two").keyup(function(event){
        if (event.keyCode == 13) {
	        obj.gridCRuleDefExt.search(this.value).draw();
        }
    });
    /****************/
    $("#btnAdd_two").addClass('disabled');
    $("#btnEdit_two").addClass('disabled');
    $("#btnDelete_two").addClass('disabled');
	obj.gridCRuleDefExt.on('select', function(e, dt, type, indexes) {
		var selectedRows = dt.rows({selected: true}).count();
		$("#btnAdd_two").addClass('disabled');
		$("#btnEdit_two").removeClass('disabled');
		$("#btnDelete_two").removeClass('disabled')
	});
	
	obj.gridCRuleDefExt.on('deselect', function(e, dt, type, indexes) {
		var selectedRows = dt.rows({selected: true}).count();
		$("#btnAdd_two").removeClass('disabled');
        $("#btnEdit_two").addClass('disabled');
        $("#btnDelete_two").addClass('disabled');
	});
	
	obj.gridCRuleDefExt.on('dblclick', 'tr', function(e) {
		
		var selectedRows = obj.gridCRuleDef.rows({selected: true}).count();
		if ( selectedRows !== 1 ) {
			layer.alert('请先选择感染诊断标准，再添加数据!',{icon: 0});
			return;
		}	
		var rd = obj.gridCRuleDefExt.row(this).data();	
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
		var selectedRows = obj.gridCRuleDefExt.rows({selected: true}).count();
		if ( selectedRows !== 1 ) return;
		var rd = obj.gridCRuleDefExt.rows({selected: true}).data().toArray()[0];
		
		obj.layer_rd = rd;
	    obj.Layer_two();

	});
	$("#btnDelete_two").on('click', function(){
		var flag = $("#btnDelete_two").hasClass("disabled");
		if(flag) return ;
		var selectedRows = obj.gridCRuleDefExt.rows({selected: true}).count();
		if ( selectedRows !== 1 ) return;
		var rd = obj.gridCRuleDefExt.rows({selected: true}).data().toArray()[0];
		
		var ID = rd["ID"];
		layer.confirm( '确认是否删除?', {
			btn: ['确认','取消'],    //btn位置对应function的位置
			btnAlign: 'c'
			},
			function(){ 
				var flg = $.Tool.RunServerMethod("DHCHAI.IR.CRuleDefExt","DeleteById",ID);
				if (parseInt(flg)<0){
					layer.msg('删除失败!',{icon: 2});
				} else {
					obj.gridCRuleDefExt.rows({selected:true}).remove().draw(false);
					layer.msg('删除成功!',{icon: 1});
				}
		 });
		
	});
	
	//感染诊断定义编辑窗体-初始化
	obj.Layer_two = function(){	
		$.form.iCheckRender();
		$.form.SelectRender("cboDiagType");  //渲染下拉框

		var rd = obj.layer_rd;
		
		if (rd){
			$.form.SetValue("txtExtTitle",rd["Title"]);
			$.form.SetValue("txtExtNote",rd["Note"]);
			$.form.SetValue("cboDiagType",rd["TypeID"],rd["TypeDesc"]);
			$.form.SetValue("txtExtIndNo",rd["IndNo"]);
			$.form.SetValue("chkExtActive",rd["IsActive"]== 1);
		} else {
			$.form.SetValue("txtExtTitle",'');   
			$.form.SetValue("txtExtNote",'');   
			$.form.SetValue("cboDiagType",'');
			$.form.SetValue("txtExtIndNo",'');   
			$.form.SetValue("chkExtActive",'');  
		}

		layer.open({
			type: 1,
			zIndex: 100,
			area: '600px',
			skin: 'layer-class',
			title: '感染诊断标准编辑', 
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
	
	
	//感染诊断定义编辑窗体-保存
	obj.LayerTwo_Save = function(){
		var rd = obj.layer_rd;
		var ID = (rd ? rd["ID"] : '');
		
		var Parref = (rd ? rd["RuleDefID"] : '');
		if (Parref=="") {
			var rdRule = obj.gridCRuleDef.rows({selected: true}).data().toArray()[0];
			Parref = rdRule["ID"];
		}
		var SubID  =(ID ?ID.split("||")[1] : '');    
		var Title  = $.form.GetValue("txtExtTitle");
		var Note   = $.form.GetValue("txtExtNote");
		var TypeDr  = $.form.GetValue("cboDiagType");
		var IndNo   = $.form.GetValue("txtExtIndNo");
		var IsActive = $.form.GetValue("chkExtActive");
		
		var InputStr = Parref;
		InputStr += "^" + SubID;
		InputStr += "^" + Title;
		InputStr += "^" + Note;
		InputStr += "^" + TypeDr;
		InputStr += "^" + IndNo;
		InputStr += "^" + IsActive;
		
		if (Title == '') {
			layer.alert("诊断定义不允许为空",{icon: 0});
			return;
		}
		if (Note == '') {
			layer.alert("诊断解读不允许为空",{icon: 0});
			return;
		}
		if (TypeDr == '') {
			layer.alert("诊断类型不允许为空",{icon: 0});
			return;
		}

		var retval = $.Tool.RunServerMethod("DHCHAI.IR.CRuleDefExt","Update",InputStr);
		if (parseInt(retval)>0){
			obj.gridCRuleDefExt.ajax.reload(function(){
				var rowIndex = $.Tool.GetTableRowIndex(obj.gridCRuleDefExt,retval);
				if (rowIndex > -1){
					var rd =obj.gridCRuleDefExt.row(rowIndex).data();
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
	
	//感染诊断定义编辑窗体-添加
	obj.LayerTwo_Add = function(){
		var rd = "";
		var ID = (rd ? rd["ID"] : '');
		
		var Parref = (rd ? rd["RuleDefID"] : '');
		if (Parref=="") {
			var rdRule = obj.gridCRuleDef.rows({selected: true}).data().toArray()[0];
			Parref = rdRule["ID"];
		}
		var Title = $.form.GetValue("txtExtTitle");
		var Note = $.form.GetValue("txtExtNote");
		var TypeDr  = $.form.GetValue("cboDiagType");
		var IndNo   = $.form.GetValue("txtExtIndNo");
		var IsActive = $.form.GetValue("chkExtActive");
		
		if (Title == '') {
			layer.alert("诊断定义不允许为空",{icon: 0});
			return;
		}
		if (Note == '') {
			layer.alert("诊断解读不允许为空",{icon: 0});
			return;
		}
		if (TypeDr == '') {
			layer.alert("诊断类型不允许为空",{icon: 0});
			return;
		}
		
		var InputStr = Parref;
		InputStr += "^" + ID;
		InputStr += "^" + Title;
		InputStr += "^" + Note;
		InputStr += "^" + TypeDr;
		InputStr += "^" + IndNo;
		InputStr += "^" + IsActive;
	 
		var retval = $.Tool.RunServerMethod("DHCHAI.IR.CRuleDefExt","Update",InputStr);
		if (parseInt(retval)>0){
			obj.gridCRuleDefExt.ajax.reload(function(){
				var rowIndex = $.Tool.GetTableRowIndex(obj.gridCRuleDefExt,retval);
				if (rowIndex > -1){
					var rd =obj.gridCRuleDefExt.row(rowIndex).data();
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
