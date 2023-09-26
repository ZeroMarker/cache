function InitviewScreenEvents(obj){
	obj.LoadEvents = function(){
		obj.btnQuery.on('click',obj.btnQuery_click,obj);
		
		/*
		//开始日期为昨天
		var curDate = new Date();
		var preDate = new Date(curDate.getTime() - 24*60*60*1000);
		var timeYesterday = preDate.format("Y") +"-" +preDate.format("m") + "-"+(preDate.format("d"));
		Common_SetValue('dfDateFrom',timeYesterday);
		*/
		
		Common_SetValue('dfDateFrom','');
		Common_SetValue('dfDateTo','');
		
		obj.cboHospital.setValue(CTHospID);
		obj.cboHospital.setRawValue(CTHospDesc);
		obj.cboHospital.disable();
		//加载病案类型
		obj.cboMrType.getStore().removeAll();
		obj.cboMrType.getStore().load({
			callback : function(r,option,success){
				if (success) {
					if (r.length > 0) {
						obj.cboMrType.setValue(r[0].get("MrTypeID"));
						obj.cboMrType.setRawValue(r[0].get("MrTypeDesc"));
						Common_LoadCurrPage('DischAdmGrid',1);
					}
				}
			}
		});
	}
	
	obj.btnQuery_click = function (){
		Common_LoadCurrPage('DischAdmGrid',1);
	}
	
	obj.LnkEprEditPage = function(EpisodeID){
		location.href = 'dhceprredirect.csp?1=1&EpisodeID=' + EpisodeID + '&2=2';
	}
}
