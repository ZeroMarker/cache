//页面Event
function InitCRuleTsAbWinEvent(obj){
	CheckSpecificKey();
     /*****搜索功能*****/
    $("#btnsearch").on('click', function(){
       $('#gridCRuleTsAb').DataTable().search($('#search').val(),true,true).draw();
       
    });
	
    $("#search").keyup(function(event){
        if (event.keyCode == 13) {
	        obj.gridCRuleTsAb.search(this.value).draw();
        }
    });
   /**********************/
    $("#btnEdit").addClass('disabled');
    $("#btnDelete").addClass('disabled');
	obj.gridCRuleTsAb.on('select', function(e, dt, type, indexes) {
		var selectedRows = dt.rows({selected: true}).count();
		$("#btnAdd").addClass('disabled');
		$("#btnEdit").removeClass('disabled');
		$("#btnDelete").removeClass('disabled');
	});
	
	obj.gridCRuleTsAb.on('deselect', function(e, dt, type, indexes) {
		var selectedRows = dt.rows({selected: true}).count();
		$("#btnAdd").removeClass('disabled');
        $("#btnEdit").addClass('disabled');
        $("#btnDelete").addClass('disabled');
	});
	
	obj.gridCRuleTsAb.on('dblclick', 'tr', function(e) {
		var rd = obj.gridCRuleTsAb.row(this).data();
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
		var selectedRows = obj.gridCRuleTsAb.rows({selected: true}).count();
		if ( selectedRows !== 1 ) return;
		var rd = obj.gridCRuleTsAb.rows({selected: true}).data().toArray()[0];
		
		obj.layer_rd = rd;
	    obj.Layer();

	});

	$("#btnDelete").on('click', function(){
		var flag = $("#btnDelete").hasClass("disabled");
		if(flag) return ;
		var selectedRows = obj.gridCRuleTsAb.rows({selected: true}).count();
		if ( selectedRows !== 1 ) return;
		var rd = obj.gridCRuleTsAb.rows({selected: true}).data().toArray()[0];
		
		var ID = rd["ID"];
		layer.confirm( '确认是否删除?', {
			btn: ['确认','取消']    //btn位置对应function的位置
			},
			function(){ 
				var flg = $.Tool.RunServerMethod("DHCHAI.IR.CRuleTestAb","DeleteById",ID);
				if (parseInt(flg)<0){
					layer.msg('删除失败!',{icon: 2});
				} else {
					obj.gridCRuleTsAb.rows({selected:true}).remove().draw(false);
					layer.msg('删除成功!',{icon: 1});
				}
		 });
	});
  
	//常规检验项目编辑窗体-初始化
	obj.Layer = function(){	
        
        $.form.iCheckRender();
        var rd = obj.layer_rd;
		if (rd){
			$.form.SetValue("txtTestSet",rd["TestSet"]);
			$.form.SetValue("txtTestCode",rd["TestCode"]);
			$.form.SetValue("chkTCFlag",rd["TCFlag"]== 1);  
			$.form.SetValue("chkTSPFlag",rd["TSPFlag"]== 1); 
			$.form.SetValue("chkTRFFlag",rd["TRFFlag"]== 1); 
			$.form.SetValue("chkTRFlag",rd["TRFlag"]== 1);  
			$.form.SetValue("chkTRMaxFlg",rd["TRVMaxFlag"]== 1);
			$.form.SetValue("txtMaxValM",rd["MaxValM"]); 
			$.form.SetValue("txtMaxValF",rd["MaxValF"]); 
			$.form.SetValue("chkTRMinFlg",rd["TRVMinFlag"]== 1);
			$.form.SetValue("txtMinValM",rd["MinValM"]); 
			$.form.SetValue("txtMinValF",rd["MinValF"]);
		} else {
			$.form.SetValue("txtTestSet",''); 
			$.form.SetValue("txtTestCode",'');
			$.form.SetValue("chkTCFlag",'');
			$.form.SetValue("chkTSPFlag",'');
			$.form.SetValue("chkTRFFlag",'');
			$.form.SetValue("chkTRFlag",'');
			$.form.SetValue("chkTRMaxFlg",'');
			$.form.SetValue("txtMaxValM",'');
			$.form.SetValue("txtMaxValF",'');
			$.form.SetValue("chkTRMinFlg",'');
			$.form.SetValue("txtMinValM",'');
			$.form.SetValue("txtMinValF",'');
		}
			layer.config({  
			extend: 'layerskin/style.css' 
		});
	
		layer.open({
			type: 1,
			zIndex: 100,
			area: '600px',
			skin: 'layer-class',
			title: '常规检验项目维护编辑', 
			content: $('#layer'),
			btn: ['添加','保存','取消'],
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

	//常规检验项目配置窗体-保存
	obj.Layer_Save = function(){
		var rd = obj.layer_rd;
		var ID = (rd ? rd["ID"] : '');
		
		var TestSet    = $.form.GetValue("txtTestSet");                                                                             
		var TestCode   = $.form.GetValue("txtTestCode");
		var TCFlag     = $.form.GetValue("chkTCFlag");
		var TSPFlag    = $.form.GetValue("chkTSPFlag");
		var TRFFlag    = $.form.GetValue("chkTRFFlag");
		var TRFlag     = $.form.GetValue("chkTRFlag");
		var TRVMaxFlag = $.form.GetValue("chkTRMaxFlg");
		var MaxValM	   = $.form.GetValue("txtMaxValM");
		var MaxValF	   = $.form.GetValue("txtMaxValF");
		var TRVMinFlag = $.form.GetValue("chkTRMinFlg");
		var MinValM    = $.form.GetValue("txtMinValM");
		var MinValF    = $.form.GetValue("txtMinValF");
		
		if (TestSet == '') {
			layer.alert("检验医嘱不允许为空",{icon: 0});
			return;
		}
		if (TestCode == '') {
			layer.alert("检验项目不允许为空",{icon: 0});
			return;
		}
		
		var InputStr = ID;
		InputStr += "^" + TestSet;
		InputStr += "^" + TestCode;
		InputStr += "^" + TCFlag;  
		InputStr += "^" + TSPFlag; 
		InputStr += "^" + TRFFlag; 
		InputStr += "^" + TRFlag;  
		InputStr += "^" + TRVMaxFlag;
		InputStr += "^" + MaxValM; 
		InputStr += "^" + MaxValF; 
		InputStr += "^" + TRVMinFlag;
		InputStr += "^" + MinValM; 
		InputStr += "^" + MinValF; 
	   
		var retval = $.Tool.RunServerMethod("DHCHAI.IR.CRuleTestAb","Update",InputStr);
		
		if (parseInt(retval)>0){
			obj.gridCRuleTsAb.ajax.reload(function(){
				var rowIndex = $.Tool.GetTableRowIndex(obj.gridCRuleTsAb,retval);
				if (rowIndex > -1){
					var rd =obj.gridCRuleTsAb.row(rowIndex).data();
					obj.layer_rd = rd;
				} else {
					obj.layer_rd = '';
				}
				layer.msg('保存成功!',{icon: 1});
			},false);
		} else {
			if(parseInt(retval)=='-2'){
				layer.alert('检验医嘱、检验项目重复!',{icon: 0});
			}else {
				layer.msg('保存失败!',{icon: 2});
			};
			
		}
	}
	
	//常规检验项目配置窗体-添加
	obj.Layer_Add = function(){
		var rd = "";
		var ID = (rd ? rd["ID"] : '');
	
	   	var TestSet    = $.form.GetValue("txtTestSet");                                                                             
		var TestCode   = $.form.GetValue("txtTestCode");
		var TCFlag     = $.form.GetValue("chkTCFlag");
		var TSPFlag    = $.form.GetValue("chkTSPFlag");
		var TRFFlag    = $.form.GetValue("chkTRFFlag");
		var TRFlag     = $.form.GetValue("chkTRFlag");
		var TRVMaxFlag = $.form.GetValue("chkTRMaxFlg");
		var MaxValM	   = $.form.GetValue("txtMaxValM");
		var MaxValF	   = $.form.GetValue("txtMaxValF");
		var TRVMinFlag = $.form.GetValue("chkTRMinFlg");
		var MinValM    = $.form.GetValue("txtMinValM");
		var MinValF    = $.form.GetValue("txtMinValF");
		
		if (TestSet == '') {
			layer.alert("检验医嘱不允许为空",{icon: 0});
			return;
		}
		if (TestCode == '') {
			layer.alert("检验项目不允许为空",{icon: 0});
			return;
		}
		
		var InputStr = ID;
		InputStr += "^" + TestSet;
		InputStr += "^" + TestCode;
		InputStr += "^" + TCFlag;  
		InputStr += "^" + TSPFlag; 
		InputStr += "^" + TRFFlag; 
		InputStr += "^" + TRFlag;  
		InputStr += "^" + TRVMaxFlag;
		InputStr += "^" + MaxValM; 
		InputStr += "^" + MaxValF; 
		InputStr += "^" + TRVMinFlag;
		InputStr += "^" + MinValM; 
		InputStr += "^" + MinValF; 
	  
		var retval = $.Tool.RunServerMethod("DHCHAI.IR.CRuleTestAb","Update",InputStr);
		
		if (parseInt(retval)>0){
			obj.gridCRuleTsAb.ajax.reload(function(){
				var rowIndex = $.Tool.GetTableRowIndex(obj.gridCRuleTsAb,retval);
				if (rowIndex > -1){
					var rd =obj.gridCRuleTsAb.row(rowIndex).data();
					obj.layer_rd = rd;
				} else {
					obj.layer_rd = '';
				}
				layer.msg('保存成功!',{icon: 1});
			},false);
		} else {
			if(parseInt(retval)=='-2'){
				layer.alert('检验医嘱、检验项目重复!',{icon: 0});
			}else {
				layer.msg('保存失败!',{icon: 2});
			};
			
		}
	}
}
