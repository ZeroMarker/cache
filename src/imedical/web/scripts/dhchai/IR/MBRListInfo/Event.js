//页面Event
function InitMBRListInfoWinEvent(obj){
	CheckSpecificKey();
	/*****搜索功能*****/
    $("#btnsearch").on('click', function(){
       $('#gridMBRInfo').DataTable().search($('#search').val(),true,true).draw();
       
    });
	$.form.CheckBoxRender();
    $("#search").keyup(function(event){
        if (event.keyCode == 13) {
	        obj.gridMBRInfo.search(this.value).draw();
        }
    });
    /****************/
    $("#btnAction").addClass('disabled');
	obj.gridMBRInfo.on('select', function(e, dt, type, indexes) {
		var selectedRows = dt.rows({selected: true}).count();
		$("#btnAction").removeClass('disabled');
	});
	
	obj.gridMBRInfo.on('deselect', function(e, dt, type, indexes) {
		var selectedRows = dt.rows({selected: true}).count();
		$("#btnAction").addClass('disabled');
	});
	
	$("#btnAction").on('click', function(){
		var selectedRows = obj.gridMBRInfo.rows({selected: true}).count();
		if ( selectedRows !== 1 ) return;
		var rd = obj.gridMBRInfo.rows({selected: true}).data().toArray()[0];
		obj.layer_rd = rd;
		obj.btnAction_Click();
	});
	obj.btnAction_Click = function()
	{
		var MRBActFlag=obj.layer_rd["MRBActFlag"];
		if (MRBActFlag==""){   // 未做隔离处理
			$.form.SelectRender('cboMRBIsoOEOrd');
			$("#cboMRBIsoOEOrd option:selected").next().attr("selected", true);
			$("#cboMRBIsoOEOrd").select2();
			layer.config({  
				extend: 'layerskin/style.css' 
			});
			// 获取唯一隔离医嘱
			var ISOOEOrdDesc = $.Tool.RunServerMethod('DHCHAI.IRS.CtlMRBSrv','GetISOOEOrd');
			if(ISOOEOrdDesc==""){ // 隔离医嘱不唯一
				// 如果多耐分类未维护隔离医嘱,给出提示,不能下医嘱
				var MRBID = obj.layer_rd["MRBID"];
				// 初始化快捷消息信息
				var DataQuery = $.Tool.RunQuery('DHCHAI.IRS.CRuleMRBSrv','QryMRBOEOrdByMRBID',MRBID);
				if(DataQuery){
					var arrDT = DataQuery.record;
					if (arrDT.length<1){
						layer.msg('多耐分类未维护隔离医嘱，请先维护隔离医嘱!', {icon: 2});
						return false;
					}
					else if (arrDT.length==1)
					{
						//唯一的隔离医嘱时就直接下隔离医嘱
						var firstObj = arrDT[0];
						var MRBShieldDesc = firstObj.BTOrdDesc;
						if ((MRBShieldDesc=="")||(MRBShieldDesc=='--请选择--')){
							layer.msg('维护的隔离医嘱名称不正确，请确认!', {icon: 0});
							return false;
						}
						// 调用接口下隔离医嘱
					  	var ret = $.Tool.RunServerMethod('DHCHAI.DP.OEItmMast','SaveOrderItem',EpisodeDr,MRBShieldDesc,session['LOGON.USERID'],session['LOGON.CTLOCID']);
						if(parseInt(ret)>0){
							// Exec 方法功能处理消息
							if(DetailsId!=""){
								var ret = $.Tool.RunServerMethod('websys.DHCMessageInterface','ExecAll',DetailsId);
								//var ret = $.Tool.RunServerMethod('websys.DHCMessageInterface','Exec',"","1079",Paadm,"","ResultID="+ResultID,session['LOGON.USERID']);
							}
							layer.msg('处置成功,已下隔离医嘱!', {icon: 1});
							obj.gridMBRInfo.ajax.reload(function(){},false);					
						}else{
							layer.msg('处置失败!', {icon: 2});
							return false;
						}
					}
					else{
						layer.open({
							type: 1,
							zIndex: 100,
							area: ['600px','240px'],
							skin: 'layer-class',
							title: '处置隔离编辑', 
							content: $('#layer'),
							btn: ['下隔离医嘱','取消'],
							btnAlign: 'c',
							yes: function(index, layero){
								var MRBShieldDesc = $.form.GetText("cboMRBIsoOEOrd");
								if ((MRBShieldDesc=="")||(MRBShieldDesc=='--请选择--')){
									layer.msg('请选择隔离医嘱!', {icon: 0});
									return false;
								}
							  	// 调用接口下隔离医嘱
							  	var ret = $.Tool.RunServerMethod('DHCHAI.DP.OEItmMast','SaveOrderItem',EpisodeDr,MRBShieldDesc,session['LOGON.USERID'],session['LOGON.CTLOCID']);
								if(parseInt(ret)>0){
									// Exec 方法功能处理消息
									if(DetailsId!=""){
										var ret = $.Tool.RunServerMethod('websys.DHCMessageInterface','ExecAll',DetailsId);
										//var ret = $.Tool.RunServerMethod('websys.DHCMessageInterface','Exec',"","1079",Paadm,"","ResultID="+ResultID,session['LOGON.USERID']);
									}
									layer.msg('处置成功,已下隔离医嘱!', {icon: 1});
									layer.close(index);	
									obj.gridMBRInfo.ajax.reload(function(){},false);					
								}else{
									layer.msg('处置失败!', {icon: 2});
									return false;
								}
							},
							success: function(layero){
								var button = layero.find(".layui-layer-btn0");
							}	
						});
					}
				}else{
					layer.msg('多耐分类未维护隔离医嘱，请先维护隔离医嘱!', {icon: 2});
					return false;
				}
				
			}else{
				var MRBShieldDesc = ISOOEOrdDesc;
			  	// 调用接口下隔离医嘱
			  	var ret = $.Tool.RunServerMethod('DHCHAI.DP.OEItmMast','SaveOrderItem',EpisodeDr,MRBShieldDesc,session['LOGON.USERID'],session['LOGON.CTLOCID']);
				if(parseInt(ret)>0){
					// Exec 方法功能处理消息
					if(DetailsId!=""){
						var ret = $.Tool.RunServerMethod('websys.DHCMessageInterface','ExecAll',DetailsId);
						//var ret = $.Tool.RunServerMethod('websys.DHCMessageInterface','Exec',"","1079",Paadm,"","ResultID="+ResultID,session['LOGON.USERID']);
					}
					layer.msg('处置成功,已下隔离医嘱!', {icon: 1});
					obj.gridMBRInfo.ajax.reload(function(){},false);					
				}else{
					layer.msg('下隔离医嘱失败!', {icon: 2});
					return false;
				}
			} 
		}else{
			// Exec 方法功能处理消息
			if(DetailsId!=""){
				var ret = $.Tool.RunServerMethod('websys.DHCMessageInterface','ExecAll',DetailsId);
			}
			layer.msg("该条记录已做隔离处理!",{icon: 1});
		}
	};
}