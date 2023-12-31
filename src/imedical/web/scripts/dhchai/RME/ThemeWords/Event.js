//页面Event
function InitThemeWordsEvent(obj){
	CheckSpecificKey();
	layer.config({  
		extend: 'layerskin/style.css' 
	});
	
	$.form.SelectRender('cboThemeTypeS');
	$('#cboThemeTypeS').on('change',function(){
		obj.gridThemeWords.ajax.reload();
	});
	
	 /*****搜索功能*****/
    $("#btnsearch").on('click', function(){
       $('#gridThemeWords').DataTable().search($('#search').val(),true,true).draw();
       
    });
	
    $("#search").keyup(function(event){
        if (event.keyCode == 13) {
	        obj.gridThemeWords.search(this.value).draw();
        }
    });
    /**********************/
    $("#btnAdd").addClass('disabled');
    $("#btnEdit").addClass('disabled');
    $("#btnDelete").addClass('disabled');
	obj.gridThemeWords.on('select', function(e, dt, type, indexes) {
		var selectedRows = dt.rows({selected: true}).count();
		$("#btnAdd").addClass('disabled');
		$("#btnEdit").removeClass('disabled');
		$("#btnDelete").removeClass('disabled');
	});
	
	obj.gridThemeWords.on('deselect', function(e, dt, type, indexes) {
		var selectedRows = dt.rows({selected: true}).count();
		$("#btnAdd").removeClass('disabled');
        $("#btnEdit").addClass('disabled');
        $("#btnDelete").addClass('disabled');
	});
	
	obj.gridThemeWords.on('dblclick', 'tr', function(e) {
		var rd = obj.gridThemeWords.row(this).data();
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
		var selectedRows = obj.gridThemeWords.rows({selected: true}).count();
		if ( selectedRows !== 1 ) return;
		var rd =  obj.gridThemeWords.rows({selected: true}).data().toArray()[0];
		
		obj.layer_rd = rd;
	    obj.Layer();
	
	});
	
	$("#btnDelete").on('click', function(){
		var flag = $("#btnDelete").hasClass("disabled");
		if(flag) return ;
		var selectedRows =  obj.gridThemeWords.rows({selected: true}).count();
		if ( selectedRows !== 1 ) return;
		var rd =  obj.gridThemeWords.rows({selected: true}).data().toArray()[0];
		
		var ID = rd["ID"];
		layer.confirm( '确认是否删除?', {
			btn: ['确认','取消'],    //btn位置对应function的位置
			btnAlign: 'c'
			},
			function(){ 
				var flg = $.Tool.RunServerMethod("DHCHAI.RME.ThemeWords","DeleteById",ID);
				if (parseInt(flg)<0){
					if (parseInt(flg)=='-777') {
						layer.msg('-777：当前无删除权限，请启用删除权限后再删除记录!',{icon: 2});
					}else {
						layer.msg('删除失败!',{icon: 2});
					}
				} else {
					 obj.gridThemeWords.rows({selected:true}).remove().draw(false);
					layer.msg('删除成功!',{icon: 1});
				}
		 });
	});
	
	//主题词库窗体-初始化
	obj.Layer = function(){
		$.form.iCheckRender(); //单选按钮
		$.form.SelectRender('cboThemeType');
		$.form.SelectRender('cboWordType');	
        var rd = obj.layer_rd;
		if (rd){
			$("#cboThemeType").val(rd["ThemeTypeDr"]).select2();
			$.form.SetValue("txtKeyWord",rd["KeyWord"]);
			$("#cboWordType").val(rd["WordTypeDr"]).select2();
			$.form.SetValue("txtLimitWord",rd["LimitWord"]);
			$.form.SetValue("txtContext",rd["Context"]);
			$.form.SetValue("chkCheckOne",rd["IsActive"]== 1);
			
		} else {
			$.form.SetValue("cboThemeType","");
			$.form.SetValue("txtKeyWord","");
			$.form.SetValue("cboWordType","");
			$.form.SetValue("txtLimitWord","");
			$.form.SetValue("txtContext","");
			$.form.SetValue("chkCheckOne","");
		}
		layer.open({
			type: 1,
			zIndex: 100,
			area: '600px',
			skin: 'layer-class',
			title: '主题词库编辑', 
			content: $('#layer'),
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
	
	//主题词库窗体-保存
	obj.LayerOne_Save = function(){
		var rd = obj.layer_rd;
		var ID = (rd ? rd["ID"] : '');
		                                                                
		var ThemeTypeDr = $.form.GetValue("cboThemeType");
		var KeyWord     = $.form.GetValue("txtKeyWord"); 
		var WordTypeDr  = $.form.GetValue("cboWordType");    		                                                                            
		var LimitWords  = $.form.GetValue("txtLimitWord");
		var Context     = $.form.GetValue("txtContext"); 
		var IsActive    = $.form.GetValue("chkCheckOne");
		if (ThemeTypeDr == '') {
			layer.alert("主题类型不允许为空",{icon: 0});
			return;
		}
	    if (KeyWord == '') {
			layer.alert("主题关键词不允许为空",{icon: 0});
			return;
		}
		if (WordTypeDr == '') {
			layer.alert("关键词分类不允许为空",{icon: 0});
			return;
		}
	    if (Context == '') {
			layer.alert("主题词语境不允许为空",{icon: 0});
			return;
		}
		var InputStr = ID;
		InputStr += "^" + ThemeTypeDr; // 主题类型DR
		InputStr += "^" + KeyWord;     // 主题关键词
		InputStr += "^" + LimitWords;  // 关联属性
		InputStr += "^" + WordTypeDr;  // 关键词分类DR
		InputStr += "^" + Context;     // 主题词语境
		InputStr += "^" + IsActive;    // 是否有效
		InputStr += "^" + "";          // 处置日期
		InputStr += "^" + "";          // 处置时间
		InputStr += "^" + $.LOGON.USERDESC; // 处置人姓名

		var retval = $.Tool.RunServerMethod("DHCHAI.RME.ThemeWords","Update",InputStr);
		if (parseInt(retval)>0){
			obj.gridThemeWords.ajax.reload(function(){
				var rowIndex = $.Tool.GetTableRowIndex(obj.gridThemeWords,retval);
				if (rowIndex > -1){
					var rd =obj.gridThemeWords.row(rowIndex).data();
					obj.layer_rd = rd;
				} else {
					obj.layer_rd = '';
				}
				layer.msg('保存成功!',{icon: 1});
			},false);
		} else {
			if(parseInt(retval)=='-100'){
				layer.alert('唯一性重复!',{icon: 0});
			}else {
				layer.msg('保存失败!',{icon: 2});
			};
			
		}
	}
	
	//主题词库窗体-添加
	obj.LayerOne_Add = function(){
		var rd = "";
		var ID = (rd ? rd["ID"] : '');
	    var ThemeTypeDr = $.form.GetValue("cboThemeType");
		var KeyWord     = $.form.GetValue("txtKeyWord"); 
		var WordTypeDr  = $.form.GetValue("cboWordType");    		                                                                            
		var LimitWords  = $.form.GetValue("txtLimitWord");
		var Context     = $.form.GetValue("txtContext"); 
		var IsActive    = $.form.GetValue("chkCheckOne");
		if (ThemeTypeDr == '') {
			layer.alert("主题类型不允许为空",{icon: 0});
			return;
		}
	    if (KeyWord == '') {
			layer.alert("主题关键词不允许为空",{icon: 0});
			return;
		}
		if (WordTypeDr == '') {
			layer.alert("关键词分类不允许为空",{icon: 0});
			return;
		}
	    if (Context == '') {
			layer.alert("主题词语境不允许为空",{icon: 0});
			return;
		}
		var InputStr = ID;
		InputStr += "^" + ThemeTypeDr; // 主题类型DR
		InputStr += "^" + KeyWord;     // 主题关键词
		InputStr += "^" + LimitWords;  // 关联属性
		InputStr += "^" + WordTypeDr;  // 关键词分类DR
		InputStr += "^" + Context;     // 主题词语境
		InputStr += "^" + IsActive;    // 是否有效
		InputStr += "^" + "";          // 处置日期
		InputStr += "^" + "";          // 处置时间
		InputStr += "^" + $.LOGON.USERDESC; // 处置人姓名

		var retval = $.Tool.RunServerMethod("DHCHAI.RME.ThemeWords","Update",InputStr);
		if (parseInt(retval)>0){
			obj.gridThemeWords.ajax.reload(function(){
				var rowIndex = $.Tool.GetTableRowIndex(obj.gridThemeWords,retval);
				if (rowIndex > -1){
					var rd =obj.gridThemeWords.row(rowIndex).data();
					obj.layer_rd = rd;
				} else {
					obj.layer_rd = '';
				}
				layer.msg('保存成功!',{icon: 1});
			},false);
		} else {
			if(parseInt(retval)=='-100'){
				layer.alert('唯一性重复!',{icon: 0});
			}else {
				layer.msg('保存失败!',{icon: 2});
			};
			
		}
	}
	
}
