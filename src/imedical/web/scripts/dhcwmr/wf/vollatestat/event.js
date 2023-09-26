function InitviewScreenEvents(obj){
	obj.LoadEvents = function(){
		obj.btnLateStat.on('click',obj.btnLateStat_click,obj);
		obj.btnExport.on('click',obj.btnExport_click,obj);
		
		if (SSHospCode == '37-QYFY'){
			Common_SetValue('msggridVolLateStat','病案回收统计');
		} else {
			Common_SetValue('msggridVolLateStat','病案迟归统计');
		}
		
		obj.dfDateFrom.setValue('');
		obj.dfDateTo.setValue('');
		
		obj.cboLocGroup.on("select",obj.cboLocGroup_select,obj);
		obj.cboHospital.on("select",obj.cboHospital_select,obj);
		obj.cboHospital.setValue(CTHospID);
		obj.cboHospital.setRawValue(CTHospDesc);
		obj.cboHospital_select();
	}
	
	obj.cboHospital_select = function(combo,record,index){
		//加载病案类型
		obj.cboMrType.getStore().removeAll();
		obj.cboMrType.getStore().load({
			callback : function(r,option,success){
				if (success) {
					if (r.length > 0) {
						obj.cboMrType.setValue(r[0].get("MrTypeID"));
						obj.cboMrType.setRawValue(r[0].get("MrTypeDesc"));
					}
				}
			}
		});
		//加载科室组
		obj.cboLocGroup.getStore().removeAll();
		obj.cboLocGroup.getStore().load({
			callback : function(r,option,success){
				if (success) {
					if (r.length > 0){
						obj.cboLocGroup.setValue(r[0].get("GroupID"));
						obj.cboLocGroup.setRawValue(r[0].get("GroupDesc"));
					}
				}
			}
		});
	}
	
	obj.cboLocGroup_select = function(combo,record,index){
		obj.cboLoc.setValue();
		obj.cboLoc.setRawValue();
		obj.cboLoc.getStore().removeAll();
		obj.cboLoc.getStore().load({});
	}
	
	obj.btnLateStat_click = function (){
		var DateFrom = Common_GetValue("dfDateFrom");
		var DateTo = Common_GetValue("dfDateTo");
		if ((DateFrom=='')||(DateTo=='')){
			window.alert("请选择开始日期、截止日期！");
			return;
		}
		Common_LoadCurrPage('gridVolLateStat',1);
	}
	
	obj.btnExport_click = function (){
		if (obj.gridVolLateStatStore.getCount()<1) {
			window.alert("请先查询再导出Excel！");
			return;
		}
		
		if (SSHospCode == '37-QYFY'){
			ExportGridByCls(obj.gridVolLateStat,'病案回收统计');
		} else {
			ExportGridByCls(obj.gridVolLateStat,'病案迟归统计');
		}
	}
}

//查看明细数据
function DisplayLateDetail(LocStr,LateDay){
	var LocID = LocStr.split("^")[0];
	if (LocID=="-") LocID="";
	if ((Common_GetValue("cboLoc")!="")&&(LocID=="")) {
		LocID = Common_GetValue("cboLoc");
	}
	var objParam = new Object();
	objParam.Hospital = Common_GetValue("cboHospital");
	objParam.MrType = Common_GetValue("cboMrType");
	objParam.DateFrom = Common_GetValue("dfDateFrom");
	objParam.DateTo = Common_GetValue("dfDateTo");
	objParam.LocGroup = Common_GetValue("cboLocGroup");
	objParam.LocID = LocID;
	objParam.LateDay = LateDay;
	
	var LocDesc = (LocStr.split("^")[1]=="合计"?"":LocStr.split("^")[1]);
	var LateDesc = "";
	if (LateDay<0) {
		LateDesc = "死亡";
	}else if (LateDay>0){
		LateDesc = LateDay + "日迟归";
	}else{
		LateDesc = "出院";
	}
	var winTitle=LocDesc +" "+ LateDesc + "明细列表";
	LateDtlLookUpHeader(objParam,winTitle);
}