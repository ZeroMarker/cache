//页面Event
function InitNavigationWinEvent(obj){
	$.form.iCheckRender(); //单选按钮
	CheckSpecificKey();
	
	
    //****************表格搜索 STT****************
    $("#btnsearch").on('click', function(){
       $('#gridNavigation').DataTable().search($('#search').val(),true,true).draw();
    });
	
    $("#search").keyup(function(event){
        if (event.keyCode == 13) {
	        obj.gridNavigation.search(this.value).draw();
        }
    });
    //****************表格搜索 END****************
   
    $("#btnEdit").addClass('disabled');
    $("#btnDelete").addClass('disabled');
	obj.gridNavigation.on('select', function(e, dt, type, indexes) {
		var selectedRows = dt.rows({selected: true}).count();
		$("#btnAdd").addClass('disabled');
		$("#btnEdit").removeClass('disabled');
		$("#btnDelete").removeClass('disabled');
	});
	
	obj.gridNavigation.on('deselect', function(e, dt, type, indexes) {
		var selectedRows = dt.rows({selected: true}).count();
		$("#btnAdd").removeClass('disabled');
        $("#btnEdit").addClass('disabled');
        $("#btnDelete").addClass('disabled');
	});
	
	obj.gridNavigation.on('dblclick', 'tr', function(e) {
		var rd = obj.gridNavigation.row(this).data();
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
		var selectedRows = obj.gridNavigation.rows({selected: true}).count();
		if ( selectedRows !== 1 ) return;
		var rd = obj.gridNavigation.rows({selected: true}).data().toArray()[0];
		
		obj.layer_rd = rd;
	    obj.Layer();
	});
	
	$("#btnDelete").on('click', function(){
		var selectedRows = obj.gridNavigation.rows({selected: true}).count();
		if ( selectedRows !== 1 ) return;
		var rd = obj.gridNavigation.rows({selected: true}).data().toArray()[0];
		
		var ID = rd["ID"];
		layer.confirm( '确认是否删除?', {
				btn: ['确认','取消'],    //btn位置对应function的位置
				btnAlign: 'c'
			},
			function(){
				var flg = $.Tool.RunServerMethod("DHCHAI.STA.Navigation","DeleteById",ID);
				if (parseInt(flg)<0){
					layer.msg('删除失败!',{icon: 2});
				} else {
					obj.gridNavigation.rows({selected:true}).remove().draw(false);
					layer.msg('删除成功!',{icon: 1});
				}
			}
		);
	});
    
    //报表
    $('#gridNavigation').on('click','a.btnSta', function (e) {
	    e.preventDefault();
		var tr = $(this).closest('tr');
		var row = obj.gridNavigation.row(tr);
		var rowData = row.data();
		
		obj.reportName=rowData["StatCode"];
	    if(obj.reportName=='') return ;

		var IPAddress=$.Tool.RunServerMethod("DHCHAI.BT.Config","GetValByCode","ReportIPAddress",$.LOGON.HOSPID);
		var url ="";
		if(obj.reportName.indexOf(".csp")>=0)
		{
			url = obj.reportName;
		}
		else
		{
			url = 'dhccpmrunqianreport.csp?report='+obj.reportName+'&reportName='+obj.reportName;
		}
	    //var url = IPAddress + 'dhccpmrunqianreport.jsp?report='+obj.reportName+'&reportName='+obj.reportName;		
		
		//主菜单
		var data = [{
			"menuId": rowData.ID,
			"menuCode": rowData.Code,
			"menuDesc": rowData.Desc,
			"menuResource": url,
			"menuOrder": rowData.IndNo,
			"menuIcon": "icon"
		}];
		
		if( typeof window.parent.showNavTab === 'function' ){   //bootstrap 版本
		    window.parent.showNavTab(data[0]['menuCode'], data[0]['menuDesc'], data[0]['menuResource'], data[0]['menuCode'], data[0]['menuIcon'], false);
		}else{ //HISUI 版本
		    window.parent.addTab({
				code:rowData.Code,
				url:url,
				title:rowData.Desc,
				valueExp:""
			});
		}	    
    });
    
	//指标集信息编辑窗体-初始化
	obj.Layer = function(){
		var rd = obj.layer_rd;
		if (rd){
			$.form.SetValue("txtCode",rd["Code"]);
			$.form.SetValue("txtDesc",rd["Desc"]);
			$.form.SetValue("txtStatCode",rd["StatCode"]);
			$.form.SetValue("txtStatDesc",rd["StatDesc"]);
			$.form.SetValue("txtIndNo",rd["IndNo"]);
			$.form.SetValue("txtMethod",rd["Method"]);
		} else {
			$.form.SetValue("txtCode",'');
			$.form.SetValue("txtDesc",'');
			$.form.SetValue("txtStatDesc",'');
			$.form.SetValue("txtStatCode",'');
			$.form.SetValue("txtIndNo",'');
			$.form.SetValue("txtMethod",'');
		}

		layer.config({  
			extend: 'layerskin/style.css' 
		});
		
		layer.open({
			type: 1,
			zIndex: 100,
			area: '600px',
			skin: 'layer-class',
			title: '指标集导航编辑', 
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
	
	
	//指标集信息配置窗体-保存
	obj.Layer_Save = function(){
		var rd = obj.layer_rd;
		var ID = (rd ? rd["ID"] : '');
		
		var Code     = $.form.GetValue("txtCode");
		var Desc     = $.form.GetValue("txtDesc");
		var StatCode = $.form.GetValue("txtStatCode");
		var StatDesc = $.form.GetValue("txtStatDesc");
		var IndNo    = $.form.GetValue("txtIndNo");	
		var Method   = $.form.GetValue("txtMethod");
		
		if (Code == '') {
			layer.alert("统计指标代码不允许为空",{icon: 0});
			return;
		}
		if (Desc == '') {
			layer.alert("统计指标名称不允许为空",{icon: 0});
			return;
		}
		
		var InputStr = ID;
		InputStr += "^" + Code;
		InputStr += "^" + Desc;
		InputStr += "^" + StatCode;
		InputStr += "^" + StatDesc;
		InputStr += "^" + IndNo;
		InputStr += "^" + Method;
		InputStr += "^" + "";
		InputStr += "^" + "";
		InputStr += "^" + $.LOGON.USERID;
		
		var retval = $.Tool.RunServerMethod("DHCHAI.STA.Navigation","Update",InputStr);
		if (parseInt(retval)>0){
			obj.gridNavigation.ajax.reload(function(){
				var rowIndex = $.Tool.GetTableRowIndex(obj.gridNavigation,retval);
				if (rowIndex > -1){
					var rd =obj.gridNavigation.row(rowIndex).data();
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
	
	//指标集信息配置窗体-添加
    obj.Layer_Add = function(){
		var rd = "";
		var ID = (rd ? rd["ID"] : '');
		
		var Code     = $.form.GetValue("txtCode");
		var Desc     = $.form.GetValue("txtDesc");
		var StatCode = $.form.GetValue("txtStatCode");
		var StatDesc = $.form.GetValue("txtStatDesc");
		var IndNo    = $.form.GetValue("txtIndNo");	
		var Method   = $.form.GetValue("txtMethod");
		
		if (Code == '') {
			layer.alert("统计指标代码不允许为空",{icon: 0});
			return;
		}
		if (Desc == '') {
			layer.alert("统计指标名称不允许为空",{icon: 0});
			return;
		}
		
		var InputStr = ID;
		InputStr += "^" + Code;
		InputStr += "^" + Desc;
		InputStr += "^" + StatCode;
		InputStr += "^" + StatDesc;
		InputStr += "^" + IndNo;
		InputStr += "^" + Method;
		InputStr += "^" + "";
		InputStr += "^" + "";
		InputStr += "^" + $.LOGON.USERID;
		
	    var retval = $.Tool.RunServerMethod("DHCHAI.STA.Navigation","Update",InputStr);
		if (parseInt(retval)>0){
			obj.gridNavigation.ajax.reload(function(){
				var rowIndex = $.Tool.GetTableRowIndex(obj.gridNavigation,retval);
				if (rowIndex > -1){
					var rd =obj.gridNavigation.row(rowIndex).data();
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
}
