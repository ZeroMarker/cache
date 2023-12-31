//页面Event
function InitRMEWordsWinEvent(obj){
	CheckSpecificKey();
	layer.config({  
		extend: 'layerskin/style.css' 
	});
	
	$.form.SelectRender('cboThemeType');
	$('#cboThemeType').on('change',function(){
		obj.gridThemeWords.ajax.reload();
		obj.gridThWordsMap.ajax.reload();
	});
	
	//主题词库列表
	//*********************搜索功能Stt*********************
    $("#btnsearch_TW").on('click', function(){
       $('#gridThemeWords').DataTable().search($('#search_TW').val(),true,true).draw();
    });
	
    $("#search_TW").keyup(function(event){
        if (event.keyCode == 13) {
	        obj.gridThemeWords.search(this.value).draw();
        }
    });
	//*********************搜索功能End*********************
	obj.gridThemeWords.on('select', function(e, dt, type, indexes) {
		var rd =  dt.rows({selected: true}).data().toArray()[0];
		var ThemeWordDr = rd["ID"];
		if (!ThemeWordDr) return;
		if ($("#btnAdd").hasClass("disabled")){
			$("#btnAdd").removeClass('disabled');
		}
		obj.ThemeWordsDr=ThemeWordDr;
		obj.gridThWordsMap.ajax.reload();
	});
	
	obj.gridThemeWords.on('deselect', function(e, dt, type, indexes) {
		var selectedRows = dt.rows({selected: true}).count();
		$("#btnAdd").addClass('disabled');
		obj.ThemeWordsDr="";
        obj.gridThWordsMap.ajax.reload();
	});
	
    // 归一词、同义词维护
	//*********************搜索功能Stt*********************
    $("#btnsearch_TWMap").on('click', function(){
       $('#gridThWordsMap').DataTable().search($('#search_TWMap').val(),true,true).draw();
    });
	
    $("#search_TWMap").keyup(function(event){
        if (event.keyCode == 13) {
	        obj.gridThWordsMap.search(this.value).draw();
        }
    });
	//*********************搜索功能End*********************
	$("#btnAdd").addClass('disabled');
    $("#btnEdit").addClass('disabled');
    $("#btnDelete").addClass('disabled');
	obj.gridThWordsMap.on('select', function(e, dt, type, indexes) {
		var selectedRows = dt.rows({selected: true}).count();
		$("#btnEdit").removeClass('disabled');
		$("#btnDelete").removeClass('disabled');
	});
	
	obj.gridThWordsMap.on('deselect', function(e, dt, type, indexes) {
		var selectedRows = dt.rows({selected: true}).count();
        $("#btnEdit").addClass('disabled');
        $("#btnDelete").addClass('disabled');
	});
	
	obj.gridThWordsMap.on('dblclick', 'tr', function(e) {
		var rd = obj.gridThWordsMap.row(this).data();
		obj.KeyLayer_rd = rd;
		obj.Layer();
	});
	
	//增加对照信息
	$("#btnAdd").on('click', function(){
		//$("#btnAdd").addClass('disabled');
		var rd =  obj.gridThemeWords.rows({selected: true}).data().toArray()[0];
		var ThemeWordDr = rd["ID"];
		
		if (ThemeWordDr == '') {
			layer.alert("主题词不允许为空",{icon: 0});
			return;
		}
		
		obj.KeyLayer_rd = '';
	    obj.Layer();
	});
	
	$("#btnDelete").on('click', function(){
		var flag = $("#btnDelete").hasClass("disabled");
		if(flag) return ;
		var selectedRows =  obj.gridThWordsMap.rows({selected: true}).count();
		if ( selectedRows !== 1 ) return;
		var rd =  obj.gridThWordsMap.rows({selected: true}).data().toArray()[0];
		
		var ThWordsMapDr = rd["ThWordsMapDr"];
		var ParserWordDr = rd["ParserWordDr"];
		layer.confirm( '确认是否删除?', {
			btn: ['确认','取消'],    //btn位置对应function的位置
			btnAlign: 'c'
			},
			function(){
				var InputStr = ThWordsMapDr;        // 主题词对照记录
				InputStr += "^" + ParserWordDr;     // 同义词
				InputStr += "^" + $.LOGON.USERID;   // 更新人
				var flg = $.Tool.RunServerMethod("DHCHAI.RMES.ThWordsMapSrv","DeleteRMEModel",InputStr);
				if (parseInt(flg)<1){
					layer.msg('删除失败!',{icon: 2});
				} else {
					obj.gridThWordsMap.ajax.reload();  // 刷新归一词
					obj.gridThWordsMap.rows({selected:true}).remove().draw(false);
					layer.msg('删除成功!',{icon: 1});
				}
			}
		 );
	});
	
	// 主题词映射窗体-初始化
	obj.Layer = function(){
        var rd = obj.KeyLayer_rd;
		if (rd){
			$.form.SetValue("txtParserWord" ,rd["ParserWord"]);
			$.form.SetValue("txtOneWord" ,rd["OneWord"]);
			$.form.SetValue("txtContext" ,rd["Context"]);
		} else {
			$.form.SetValue("txtParserWord" ,'');
			$.form.SetValue("txtOneWord" ,'');
			$.form.SetValue("txtContext" ,'');
		}
		layer.open({
			type: 1,
			zIndex: 100,
			area: '600px',
			skin: 'layer-class',
			title: '语义词标注', 
			content: $('#layer'),
			btn: ['保存','关闭'],
			btnAlign: 'c',
			yes: function(index, layero){
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
	// 主题词映射窗体-保存
	obj.Layer_Save = function(){
		var rd = obj.KeyLayer_rd;
		var ThWordsDr = obj.ThemeWordsDr;
		var ThTypeDr = $.form.GetValue("cboThemeType");
		var ParserWord = $.form.GetValue("txtParserWord");
		var OneWord = $.form.GetValue("txtOneWord");
        var Context    = $.form.GetValue("txtContext");
		
		if (ParserWord == '') {
			layer.alert("语义词不允许为空",{icon: 0});
			return;
		}
		
		var InputStr = ThTypeDr;            // 主题类型
		InputStr += "^" + ThWordsDr;        // 主题词
		InputStr += "^" + ParserWord;       // 语义词
		InputStr += "^" + OneWord;          // 归一词
		InputStr += "^" + Context;          // 语境
		InputStr += "^" + $.LOGON.USERID;   // 更新人
		var retval = $.Tool.RunServerMethod("DHCHAI.RMES.ThWordsMapSrv","UpdateRMEModel",InputStr);
		if (parseInt(retval)>0){
			obj.gridThWordsMap.ajax.reload(function(){
				var rowIndex = $.Tool.GetTableRowIndex(obj.gridThWordsMap,retval);
				if (rowIndex > -1){
					var rd =obj.gridThWordsMap.row(rowIndex).data();
					obj.KeyLayer_rd = rd;
				} else {
					obj.KeyLayer_rd = '';
				}
				layer.msg('保存成功!',{icon: 1});
			},false);
		} else {
			layer.msg('保存失败!',{icon: 2});
		}
	}
}
