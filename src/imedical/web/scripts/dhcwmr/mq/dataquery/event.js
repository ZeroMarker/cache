function InitviewScreenEvent(obj) {
	obj.LoadEvent = function(args){
		obj.btnAddCond.on('click', obj.btnAddCond_onclick, obj);
		obj.btnAddCfg.on('click', obj.btnAddCfg_onclick, obj);
		obj.btnDelCfg.on('click', obj.btnDelCfg_onclick, obj);
		obj.btnQuery.on('click', obj.btnQuery_onclick, obj);
		obj.btnExport.on('click', obj.btnExport_onclick, obj);
		obj.btnQryItemDic.on('click',obj.btnQryItemDic_click,obj);
		obj.cboDataCat.on('select', obj.cboDataCat_select, obj);
		obj.cboDataSubCat.on('select', obj.cboDataSubCat_select, obj);
		obj.gridOutCol.on('cellclick',obj.gridOutCol_cellclick,obj);
		obj.gridInputCond.on('cellclick',obj.gridInputCond_cellclick,obj);
		obj.chkDataSubCat.on('check',obj.chkDataSubCat_check,obj);
		obj.cboCondCfg.on('select',obj.cboCondCfg_select,obj);
		obj.cboOutDataSubCat.on('select',obj.cboOutDataSubCat_select,obj);
		obj.txtItemAlias.on('specialKey',obj.txtItemAlias_specialKey,obj);
		//初始化页面数据
		obj.InitData();
	}
	obj.InitData = function()
	{
		//加载订制样式下拉框
		obj.cboCondCfg_load(0);
		//加载加载条件大类、子类
		obj.cboDataCat.getStore().load({
			callback : function(r,option,success){
				if (success) {
					if (r.length > 0){
						obj.cboDataCat.setValue(r[0].get('ID'));
						obj.cboDataCat.setRawValue(r[0].get('Desc'));
						obj.cboDataCat_select();
					}
				}
			}
		});
		//加载逻辑关系
		obj.cboLogical.getStore().removeAll();
		obj.cboLogical.getStore().load({
			callback : function(r,option,success){
				if (success) {
					if (r.length > 0) {
						obj.cboLogical.setValue(r[0].get('DicRowId'));
						obj.cboLogical.setRawValue(r[0].get('DicDesc'));
					} else {
						obj.cboLogical.setValue('');
						obj.cboLogical.setRawValue('');
					}
				}
			}
		}); 
	}
	obj.txtItemAlias_specialKey = function(field, e) {
		if (e.getKey() != Ext.EventObject.ENTER) return;
		Common_LoadCurrPage('gridOutCol',1)
	}
	obj.btnQryItemDic_click = function()
	{
		var DataField = Common_GetValue('cboDataField');
		if (DataField=='')
		{
			ExtTool.alert('提示','请选择数据项！');
			return;
		}
		var objDicSet = ExtTool.RunServerMethod('DHCWMR.MQ.ItemDic','GetObjByItem',DataField);
		if (objDicSet=='')
		{
			ExtTool.alert('提示','该数据项不是字典！');
			return;
		}else{
			if (!objDicSet.IsActive)
			{
				ExtTool.alert('提示','该数据项不是字典！');
				return;
			}
		}
		var className	= objDicSet.IDQryClassName;
		var qryName		= objDicSet.IDQryMethodName;
		var displayCode = objDicSet.IDDisCode;
		var displayDesc = objDicSet.IDDisDesc;
		var Args		= objDicSet.IDArgs;
		var IsLoadAll	= objDicSet.IsLoadAll;
		var ChooseValue	= objDicSet.IDChooseValue;
		var win = new InitDicQry(className,qryName,displayCode,displayDesc,Args,IsLoadAll,ChooseValue);
		win.WinDicQry.show();
	}

	obj.cboCondCfg_load = function(cfgId){
		obj.cboCondCfgStore.removeAll();
		obj.cboCondCfgStore.load({
			callback : function(r,option,success){
				if (success) {
					if (r.length > 0) {
						var rowIndex = -1;
						if (cfgId){
							rowIndex = obj.cboCondCfg.getStore().find('ID',cfgId);
						}
						if (rowIndex > -1){
							obj.cboCondCfg.setValue(r[rowIndex].get('ID'));
							obj.cboCondCfg.setRawValue(r[rowIndex].get('Desc'));
						} else {
							obj.cboCondCfg.setValue(r[0].get('ID'));
							obj.cboCondCfg.setRawValue(r[0].get('Desc'));
						}
					} else {
						obj.cboCondCfg.setValue('');
						obj.cboCondCfg.setRawValue('');
					}
					obj.cboCondCfg_select();
				}
			}
		});
	}
	
	obj.cboCondCfg_select = function(combo,record,index){
		var DateType = '';
		var LogicalStr = '';
		var CfgID=obj.cboCondCfg.getValue();
		if (CfgID){
			var objCfg = ExtTool.RunServerMethod('DHCWMR.MQ.CondConfig','GetObjById',CfgID);
			if (objCfg){
				var DateType = objCfg.CCDateType;
			}
		}
		obj.cboDateType.getStore().removeAll();
		obj.cboDateType.getStore().load({
			callback : function(r,option,success){
				if (success) {
					if (r.length > 0){
						var isSelected = 0;
						if (DateType != ''){
							for (var ind = 0; ind < r.length; ind++){
								if (r[ind].get('DicRowId') == DateType){
									obj.cboDateType.setValue(r[ind].get('DicRowId'));
									obj.cboDateType.setRawValue(r[ind].get('DicDesc'));
									isSelected = 1;
								}
							}
						}
						if (isSelected != 1){
							obj.cboDateType.setValue(r[0].get('DicRowId'));
							obj.cboDateType.setRawValue(r[0].get('DicDesc'));
						}
					}
				}
			}
		});
		obj.chkDataSubCat.setValue(false);
		Common_SetDisabled('cboOutDataSubCat',true);
		Common_SetValue('cboOutDataSubCat','','');
		Common_LoadCurrPage('gridInputCond',1);
		obj.LoadGridOutCol(1,CfgID,'','');
		obj.reloadResultColumn();
	}

	obj.cboDataCat_select = function(combo,record,index){
		obj.cboDataSubCatStore.removeAll();
		obj.cboDataSubCatStore.load({
			callback : function(r,option,success){
				if (success) {
					if (r.length > 0){
						obj.cboDataSubCat.setValue(r[0].get('ID'));
						obj.cboDataSubCat.setRawValue(r[0].get('Desc'));
						obj.cboDataSubCat_select();
					} else {
						obj.cboDataSubCat.setValue('');
						obj.cboDataSubCat.setRawValue('');
						obj.cboDataSubCat_select();
					}
				}
			}
		});
	}
	
	obj.cboDataSubCat_select =function(combo,record,index){
		Common_SetValue('cboDataField','','');
		obj.cboDataFieldStore.removeAll();
		obj.cboDataFieldStore.load({});
	}

	//增加查询条件
	obj.btnAddCond_onclick = function()
	{
		var CfgID=obj.cboCondCfg.getValue();
		if (CfgID=='-1') CfgID='';
		var CfgDesc=obj.cboCondCfg.getRawValue();
		var DateType = Common_GetValue('cboDateType');
		//大类,子类,数据项,操作符,比较值,逻辑关系
		var ItemCat = Common_GetValue('cboDataCat');
		var ItemSubCat = Common_GetValue('cboDataSubCat');
		var DataField = Common_GetValue('cboDataField');
		var OperCode = Common_GetValue('cboOperCode');
		var CompVal = Common_GetValue('txtCompValue');
		var Logical = Common_GetValue('cboLogical');
		var Error = '';
		if (Logical == '') Error += '逻辑关系、'
		if (ItemCat == '') Error += '大类、'
		if (ItemSubCat == '') Error += '子类、'
		if (OperCode == '') Error += '操作符、'
		if (CompVal == '') Error += '比较值、'
		if (Error){
			ExtTool.alert('提示',Error+'为空！');
			return;
		}
		//列表定义中的条件
		var CondValue = obj.GetCondValue();
		//新加条件
		var Type = (DataField==''?'DataSubCat':'DataItem');
		var addCondValue=Type+CHR_3+(DataField==''?ItemSubCat:DataField)+CHR_2+OperCode+CHR_2+CompVal;
		if (CondValue){
			CondValue +=  CHR_1 + addCondValue + CHR_2 + Logical;
		}else{
			CondValue = addCondValue;
		}
		var InputStr=CfgID;
				InputStr += '^' + CfgDesc;
				InputStr += '^' + DateType;
				InputStr += '^' + CondValue;
		var ret = ExtTool.RunServerMethod('DHCWMR.MQ.CondConfig','Update',InputStr,'^')
		if (parseInt(ret)<0) {
			ExtTool.alert('提示','保存条件失败！');
			return;
		}else{
			obj.cboCondCfg.setValue(parseInt(ret));
			obj.cboCondCfg.setRawValue(CfgDesc);
			Common_LoadCurrPage('gridInputCond',1);
		}
	}
	
	obj.gridInputCond_cellclick = function(grid, rowIndex, columnIndex, e){
		if (columnIndex !=0) return;
		var CfgID=obj.cboCondCfg.getValue();
		var CfgDesc=obj.cboCondCfg.getRawValue();
		var DateType = Common_GetValue('cboDateType');
		if (CfgID<1) return;
		var objStore = grid.getStore();
		var record = objStore.getAt(rowIndex);
		var ID = record.get('ID');
		if (record.get('IsChecked') == '1'){
			grid.getStore().removeAt(rowIndex);
			grid.getStore().commitChanges();
			grid.getView().refresh();
			//保存配置
			var CondValue = obj.GetCondValue();
			var InputStr=CfgID;
				InputStr += '^' + CfgDesc;
				InputStr += '^' + DateType;
				InputStr += '^' + CondValue;
			var ret = ExtTool.RunServerMethod('DHCWMR.MQ.CondConfig','Update',InputStr,'^')
			if (parseInt(ret)<0) {
				ExtTool.alert('提示','保存样式失败！');
				return;
			}else{
				Common_LoadCurrPage('gridInputCond',1);
			}
		}
	}

	obj.btnAddCfg_onclick = function()
	{
		var DateType = Common_GetValue('cboDateType');
		Ext.Msg.prompt('增加样式', '样式名', function (btn, cfgName) {  
			if (btn == 'ok') {  
				var InputStr='';
					InputStr += '^' + cfgName;
					InputStr += '^' + DateType;
					InputStr += '^' + '';
				var ret = ExtTool.RunServerMethod('DHCWMR.MQ.CondConfig','Update',InputStr,'^')
				if (parseInt(ret)<0) {
					ExtTool.alert('提示','保存样式失败！');
					return;
				}else{
					obj.cboCondCfg_load(parseInt(ret));
				}
			}  
		})   
	}
	obj.btnDelCfg_onclick = function(){
		var CfgId   = obj.cboCondCfg.getValue();
		var CfgDesc   = obj.cboCondCfg.getRawValue();
		if (CfgId == ''){
			ExtTool.alert('提示','请选择订制样式!');
			return;
		}
		Ext.MessageBox.confirm('删除', '是否删除订制样式【' + CfgDesc + '】?', function(btn,text){
			if(btn=='yes'){
				var ret = ExtTool.RunServerMethod('DHCWMR.MQ.CondConfig','DeleteById',CfgId);
				if (parseInt(ret) > 0) {
					obj.cboCondCfg_load(0);
				} else {
					ExtTool.alert('错误','删除订制样式错误!');
					return;
				}
			}
		});
	}
	
	obj.chkDataSubCat_check = function ()
	{
		obj.gridOutColStore.removeAll();
		var isCheck = obj.chkDataSubCat.getValue();
		if (isCheck){
			Common_SetDisabled('cboOutDataSubCat',false);
			var DataCat = Common_GetValue('cboDataCat')
			var CfgID=obj.cboCondCfg.getValue();
			if (CfgID<0) CfgID='';
			obj.LoadGridOutCol(2,CfgID,'DataSubCat','');
		}else{
			Common_SetDisabled('cboOutDataSubCat',true);
			Common_SetValue('cboOutDataSubCat','','');
			var CfgID=obj.cboCondCfg.getValue();
			if (CfgID<0) return;
			obj.LoadGridOutCol(1,CfgID,'','');
		}
	}

	obj.cboOutDataSubCat_select = function(combo,record,index){
		var DataCatID=obj.cboOutDataSubCat.getValue();
		if (DataCatID=='') return;
		var CfgID=obj.cboCondCfg.getValue();
		if (CfgID<0) CfgID='';
		obj.LoadGridOutCol(2,CfgID,'DataItem',DataCatID);
	}

	//加载输出列配置grid
	obj.LoadGridOutCol = function(Model,CfgID,DataType,ArgID)
	{
		obj.gridOutCol_QryArg_Mode=Model;
		obj.gridOutCol_QryArg_CondfigID = CfgID;
		obj.gridOutCol_QryArg_DataType=DataType;
		obj.gridOutCol_QryArg_argID=ArgID;
		Common_LoadCurrPage('gridOutCol',1);
	}

	obj.gridOutCol_cellclick = function(grid, rowIndex, columnIndex, e){
		if (columnIndex !=1) return;
		var CfgID=obj.cboCondCfg.getValue();
		if (CfgID=='-1') CfgID='';
		var CfgDesc=obj.cboCondCfg.getRawValue();
		var DateType = Common_GetValue('cboDateType');
		var objStore = grid.getStore();
		var record = objStore.getAt(rowIndex);
		var ID = record.get('ID');
		var Desc = record.get('Desc');
		var DataType = record.get('DataType');
		if (record.get('IsChecked') != '1'){
			if (obj.ResultGrid.colModel.getColumnCount()>=50)
			{
				ExtTool.alert('提示','输出列不能超过50列！');
				return;
			}
			//保存配置
			var CondValue = obj.GetCondValue();
			var InputStr  = CfgID;
				InputStr += '^' + CfgDesc;
				InputStr += '^' + DateType;
				InputStr += '^' + CondValue;
			var ret = ExtTool.RunServerMethod('DHCWMR.MQ.CondConfig','Update',InputStr,'^')
			if (parseInt(ret)<0) {
				ExtTool.alert('提示','保存样式失败！');
				return;
			}else{
				CfgID = parseInt(ret);
			}
			//保存输出列
			var InputStr=ret;
				InputStr += '^' + '';
				InputStr += '^' + (DataType=='DataSubCat'?ID:'');
				InputStr += '^' + (DataType=='DataSubCat'?'':ID);
			var ret = ExtTool.RunServerMethod('DHCWMR.MQ.CondColConfig','Update',InputStr,'^')
			if (parseInt(ret)<0) {
				ExtTool.alert('提示','保存输出列失败！');
				return;
			}
			obj.cboCondCfg.setValue(CfgID);
			obj.cboCondCfg.setRawValue(CfgDesc);
		}else{
			//删除输出列
			var ret = ExtTool.RunServerMethod('DHCWMR.MQ.CondColConfig','DeleteById',ID)
			if (parseInt(ret)<0) {
				ExtTool.alert('提示','删除输出列失败！');
				return;
			}
		}
		grid.getStore().removeAt(rowIndex);
		grid.getStore().commitChanges();
		grid.getView().refresh();
		obj.reloadResultColumn();
		obj.ResultDataArray=[];
		obj.loadPagingMemory(0);
	}
	
	//刷新输出表头
	obj.reloadResultColumn   = function()
	{
		//刷新前清除grid数据
		obj.ResultGridStore.removeAll();
		var CfgID=obj.cboCondCfg.getValue();
		var conn = Ext.lib.Ajax.getConnectionObject().conn;
		var url = ExtToolSetting.RunQueryPageURL + '?1=1'
		url += '&ClassName=' + 'DHCWMR.MQService.ConditionSrv'
		url += '&QueryName=' + 'QryCondCol'
		url += '&Arg1=' + '1'
		url += '&Arg2=' + CfgID
		url += '&Arg3=' + ''
		url += '&Arg4=' + ''
		url += '&ArgCnt=' + 4
		url += '&2=2'
		conn.open('post',url,false);
		conn.send(null);
		if (conn.status != '200') {
			ExtTool.alert('错误', '加载错误!');
			return;
		}
		var jsonData = new Ext.decode(conn.responseText);
		if (jsonData.total>0){
			var arrColumnModel=[new Ext.grid.RowNumberer()];
			for (var row = 0; row < jsonData.record.length; row++){
				var record = jsonData.record[row];
				var Desc = record.Desc;
				var colwidth = 20*Desc.length;  //根据列描述确定列宽
				var OutType = record.OutType	//输出数据类型 (TEXT-字符串、NUMBER-数字、DATE-日期、TIME-时间)
				arrColumnModel.push({'header':Desc, 'width':colwidth, dataIndex: 'item'+(row+1), sortable: true, menuDisabled:true, align: 'center'});  
			}
			arrColumnModel.push({'header':'', 'width':1, dataIndex: '', sortable: true, menuDisabled:true, align: 'center'});  
			var columnModel = new Ext.grid.ColumnModel(arrColumnModel);
			obj.ResultGrid.reconfigure(obj.ResultGridStore, columnModel);
		}else{
			//条件未定义列的情况下特殊处理(设置一个隐藏列)
			var arrColumnModel=[];
			arrColumnModel.push({'header':'', 'width':100, dataIndex: 'item', sortable: true, menuDisabled:true, align: 'center' ,hidden :true});  
			var columnModel = new Ext.grid.ColumnModel(arrColumnModel);
			obj.ResultGrid.reconfigure(obj.ResultGridStore, columnModel);
		}

	}

	obj.Process = function(CfgID,MACAddr,DateType,FromDate,ToDate){
		var CfgID		= CfgID;
		var MACAddr		= MACAddr;
		var DateType	= DateType;
		var FromDate	= FromDate;
		var ToDate		= ToDate;
		var SysQryFlag  = obj.SysQryFlag;
		Ext.Ajax.request({
			url : 'dhcwmr.mq.outputresult.csp',
			method : 'GET',
			timeout: 100000,
			params  : {
				CondID : CfgID,
				DataIndex : MACAddr,
				DateType : DateType,
				DateFrom : FromDate,
				DateTo : ToDate,
				SysQryFlag : SysQryFlag,
				OperType : 'Qry'
			},
			success : function(response) {
				try {
					var Json = Ext.decode(response.responseText);
				} catch(err) {
					ExtTool.alert('提示',err.message+'!');
					return;
				}
				var err =Json.err;
				var BarText = Json.BarText;
				var RadioNum = Json.RadioNum;
				var taskStop = Json.taskStop;
				obj.SysQryFlag = Json.SysQryFlag;
				taskStop = parseInt(taskStop);
				if (err)
				{
					ExtTool.alert('提示',err);
					return;
				}
				for (row=0;row<Json.record.length ;row++ )
				{
					obj.ResultDataArray.push(Json.record[row]);
				}
				if (taskStop==1) {
					obj.progressBar.hide();
					obj.loadPagingMemory(1);
				}else {
					var RadioNum = RadioNum*1;
					if (RadioNum < 0) {
						obj.progressBar.hide();
						obj.loadPagingMemory(1);
					} else {
						obj.progressBar.updateProgress(RadioNum,BarText);
						obj.Process(CfgID,MACAddr,DateType,FromDate,ToDate);
					}
				}
			},
			failure: function(response, opts) {
				obj.progressBar.hide();
				obj.loadPagingMemory(1);
			}
		});
	}
	
	obj.loadPagingMemory = function(flg)
	{
		if (obj.ResultDataArray.length<1)
		{
			if (flg==1)
			{
				ExtTool.alert('提示','没有相关数据');
			}
		}
		obj.ResultGridStore.proxy = new Ext.data.PagingMemoryProxy(obj.ResultDataArray); //PagingMemoryProxy()一次性读取数据
		obj.ResultGridStore.load({params:{start:0, limit:500}});
	}

	obj.btnQuery_onclick = function()
	{   
		var CfgID=obj.cboCondCfg.getValue();
		var DateType = Common_GetValue('cboDateType');
		var FromDate = Common_GetValue('dtFromDate');
		var ToDate = Common_GetValue('dtToDate');
		if (CfgID=='-1') {
			ExtTool.alert('提示', '请维护查询信息!');
			return;
		}
		if (obj.ResultGrid.colModel.getColumnCount()==1)
		{
			ExtTool.alert('提示','请维护输出列！');
			return;
		}
		if(!MACAddr){
			MACAddr=session['LOGON.USERID'];
		}
		if (MACAddr == '') {
			ExtTool.alert('提示', 'MAC地址不允许为空!');
			return;
		}
		obj.progressBar=Ext.Msg.show({
			title : '正在检索',
			msg:'检索进度：',
			progress:true,
			width:300,
			height:30
		});
		obj.ProcessFlag = 0;		//递归调用循环标志
		obj.SysQryFlag = 0;			//系统循环Qry标志
		obj.ResultDataArray = [];	//存储Qry结果
		obj.Process(CfgID,MACAddr,DateType,FromDate,ToDate)
	}

	obj.GetCondValue = function()
	{
		var CondValue='';
		for (var ind = 0; ind < obj.gridInputCondStore.getCount(); ind++){
			var record = obj.gridInputCondStore.getAt(ind);
			var tmpLogicalID = (ind=='0'?'':record.get('LogicalID'));
			var tmpQryType = record.get('QryType');
			var tmpQryID = record.get('QryID');
			var tmpOperID = record.get('OperID');
			var tmpCompVal = record.get('CompVal');
			var tmpCondValue=tmpQryType+CHR_3+tmpQryID+CHR_2+tmpOperID+CHR_2+tmpCompVal;
			if (CondValue){
				CondValue +=  CHR_1 + tmpCondValue + CHR_2 + tmpLogicalID;
			}else{
				CondValue = tmpCondValue;
			}
		}
		return CondValue;
	}
	
	obj.btnExport_onclick = function()
	{
		if (obj.ResultGrid.colModel.getColumnCount()==1)
		{
			ExtTool.alert('提示','请维护输出列！');
			return;
		}
		if (obj.ResultGridStore.getCount()<1) {
			ExtTool.alert('提示','请先查询再导出！');
			return;
		}
		if (MACAddr == '') {
			ExtTool.alert('提示', 'MAC地址不允许为空!');
			return;
		}
		obj.progressBar.updateProgress(0,'正在导出','导出进度：');
		obj.progressBar=Ext.Msg.show({
			title : '正在导出',
			msg:'导出进度：',
			progress:true,
			width:300,
			height:30
		});
		try {
			xls = new ActiveXObject("Excel.Application");
		}catch (e) {
			xls =null;
			alert("Creat ExcelApplacation Error!");
			return null;
		}
		xls.Visible = false;
		xlBook = xls.Workbooks.Add();
		xlSheet=xlBook.Worksheets(1);
		//处理Excel表头,返回取值字段fields
		var fields = BuildHeaderByGrid(obj.ResultGrid,1,1);
		var total = obj.ResultGrid.getStore().reader.arrayData.length;
		obj.SysExportFlg = 0;			//系统循环Qry标志
		obj.fields = fields;
		if (fields != ''){
			obj.ExportProcess("fillxlSheet",MACAddr,total);
		}
	}

	obj.ExportProcess = function(itmjs,DataIndex,total){
		var itmjs			= itmjs;
		var DataIndex		= DataIndex;
		var total			= total;
		Ext.Ajax.request({
			url : 'dhcwmr.mq.outputresult.csp',
			method : 'GET',
			timeout: 100000,
			params  : {
				itmjs : itmjs,
				DataIndex : DataIndex,
				SysExportFlg : obj.SysExportFlg,
				ViewFields : obj.fields,
				OperType : 'Export',
				total :total
			},
			success : function(response) {
				try {
					var Json = Ext.decode(response.responseText);
				} catch(err) {
					ExtTool.alert('提示',err.message+'!');
					return;
				}
				var fillxlCode = Json.fillxlCode;
				var BarText = Json.BarText;
				var RadioNum = Json.RadioNum;
				var ExportStop = Json.ExportStop;
				var err =Json.err;
				obj.SysExportFlg = Json.SysExportFlg;
				ExportStop = parseInt(ExportStop);
				eval(fillxlCode);
				if (err)
				{
					ExtTool.alert('提示',err);
					return;
				}
				if (ExportStop==1) {
					obj.progressBar.hide();
					obj.SaveExcel();
				}else {
					var RadioNum = RadioNum*1;
					if (RadioNum < 0) {
						obj.progressBar.hide();
						obj.SaveExcel();
					} else {
						obj.progressBar.updateProgress(RadioNum,BarText);
						obj.ExportProcess("fillxlSheet",MACAddr,total);
					}
				}
			},
			failure: function(response, opts) {
				obj.progressBar.hide();
				obj.SaveExcel();
			}
		});
	}

	obj.SaveExcel = function(){
		filename = "病案综合查询结果.xls";
		var fname = xls.Application.GetSaveAsFilename(filename, "Excel Spreadsheets (*.xls), *.xls");
		if (fname != false){
			try {
				xlBook.SaveAs(fname);
			}catch(e){
				return false;
			}
		}
		xlSheet=null;
		xlBook.Close (savechanges=false);
		xls.Quit();
		xlSheet=null;
		xlBook=null;
		xls=null;
		idTmr=window.setInterval("Cleanup();",1);
		
		return true;
	}
}