var objParam = new Object();
function InitviewScreenEvents(obj){
	obj.LoadEvents = function(){
		obj.cboHospital.setValue(CTHospID);
		obj.cboHospital.setRawValue(CTHospDesc);
		obj.cboHospital.on('select',obj.cboHospital_select,obj);
		obj.cboMrType.on("select",obj.cboMrType_select,obj);
		obj.btnQuery.on('click',obj.btnQuery_click,obj);
		obj.btnExport.on('click',obj.btnExport_click,obj);
		
		obj.cboHospital_select();
	}
	
	obj.cboHospital_select = function(){
		obj.cboMrType.getStore().removeAll();
		obj.cboMrType.getStore().load({
			callback : function(r,option,success){
				if (success) {
					if (r.length > 0) {
						obj.cboMrType.setValue(r[0].get("MrTypeID"));
						obj.cboMrType.setRawValue(r[0].get("MrTypeDesc"));
						obj.cboMrType_select();
					}
				}
			}
		});
	}
	
	obj.cboMrType_select = function(combo,record,index){
		obj.ViewColumnModel();
	}
	
	obj.ViewColumnModel = function(){
		var conn = Ext.lib.Ajax.getConnectionObject().conn;
		var url = ExtToolSetting.RunQueryPageURL + '?1=1'
		url += '&ClassName=' + 'DHCWMR.SSService.WorkFlowSrv'
		url += '&QueryName=' + 'QryWFItemByMrType'
		url += '&Arg1=' + Common_GetValue('cboMrType');
		url += '&ArgCnt=' + 1
		url += '&2=2'
		conn.open('post',url,false);
		conn.send(null);
		
		if (conn.status != '200') {
			ExtTool.alert('错误', '查询Query报错!');
			return;
		}
		
		var jsonData = new Ext.decode(conn.responseText);
		if (jsonData.total < 0){
			ExtTool.alert('提示', '无有效操作项目!');
			return;
		}
		
		var arrColumnModel = new Array();
		var arrColumn = new Array();
		var item = {header: '操作员', width: 80, dataIndex: 'UserDesc', sortable: false, menuDisabled:true, align : 'center'};
		arrColumnModel.push(item);
		for (var row = 0; row < jsonData.record.length; row++){
			if (jsonData.record[row].SysOpera == 'I') continue;
			var ItemDesc = jsonData.record[row].WFItemDesc;
			var ItemID   = jsonData.record[row].WFItemID;
			var WFItemStr = ItemID+"^"+ItemDesc;
			arrColumn.push(WFItemStr);
			item = {header: ItemDesc, width: 80, dataIndex: 'Item' + (row + 1), sortable: false, menuDisabled:true, align : 'center'
					,renderer : function(v, m, rd, r, c, s){
						var UserStr = rd.get("UserID") + "^" + rd.get("UserDesc");
						var value = v;
						return " <a href='#' onclick='DisplayWorkDetail(\""+UserStr+"\",\""+arrColumn[c-1]+"\");'>"+value+"</a>";
					}
			}
			arrColumnModel.push(item);
		}
		var colQd = new Ext.grid.ColumnModel(arrColumnModel);
		obj.WorkLoadGrid.reconfigure(obj.WorkLoadGridStore, colQd);
	}
	
	obj.btnQuery_click = function (){
		var MrTypeID = Common_GetValue("cboMrType");
		if (MrTypeID==''){
			window.alert("请选择病案类型!");
			return;
		}
		objParam.Hospital = Common_GetValue("cboHospital");
		objParam.MrType = Common_GetValue("cboMrType");
		objParam.DateFrom = Common_GetValue("dfDateFrom");
		objParam.DateTo = Common_GetValue("dfDateTo");
		
		var DateFrom = Common_GetValue("dfDateFrom");
		var DateTo = Common_GetValue("dfDateTo");
		if ((DateFrom=='')||(DateTo=='')){
			window.alert("请选择开始日期、截止日期！");
			return;
		}
		Common_LoadCurrPage('WorkLoadGrid',1);
	}
	
	obj.btnExport_click = function (){
		if (obj.WorkLoadGridStore.getCount()<1) {
			window.alert("请先查询再导出Excel！");
			return;
		}
		if ("undefined"==typeof EnableLocalWeb || 0==EnableLocalWeb ){
			ExprotGrid(obj.WorkLoadGrid,'工作量统计');
		}else{
			ExprotGridStrNew(obj.WorkLoadGrid,'工作量统计');
		}
	}
}

//查看明细数据
function DisplayWorkDetail(UserStr,WFItemStr){
	var UserID = UserStr.split("^")[0];
	var WFItemID = WFItemStr.split("^")[0];
	var winTitle="工作量明细列表( 操作人：" + UserStr.split("^")[1] + " 操作项目：" + WFItemStr.split("^")[1]+" )";
	WorkDtlLookUpHeader(objParam,UserID,WFItemID,winTitle);
}
