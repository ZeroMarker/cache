var dateFormat=tkMakeServerCall("web.DHCClinicCom","GetDateFormat");
function InitCommon(obj)
{
	obj.comAppLocStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.comAppLocStore = new Ext.data.Store({
		proxy: obj.comAppLocStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'ctlocId'
		}, 
		[
			{name: 'checked', mapping : 'checked'}
			,{name: 'ctlocDesc', mapping: 'ctlocDesc'}
			,{name: 'ctlocId', mapping: 'ctlocId'}
		])
	});
	obj.comAppLocStoreProxy.on('beforeload',function(objProxy, param){
		param.ClassName = 'web.DHCClinicCom';
		param.QueryName = 'FindLocList';
		param.Arg1 = "";
		param.Arg2 = 'INOPDEPT^OUTOPDEPT^EMOPDEPT';
		param.ArgCnt = 2;
	});
	obj.comAppLocStore.load({});

		//查询日期
	obj.itemDateFrm = new Ext.form.DateField({
		id : 'itemDateFrm'
		,value : new Date()
		,format : dateFormat
		,fieldLabel : '开始日期'
		,labelSeparator: ''
		,anchor : '95%'
	});
	obj.itemTimeFrm = new Ext.form.TimeField({
		id:'itemTimeFrm'
		,value : '00:00:00'
		,format : 'H:i:s'
		,fieldLabel:'开始时间'
		,anchor : '95%'
	});
	obj.itemDateTo = new Ext.form.DateField({
		id : 'itemDateTo'
		,value : new Date()
		,format : dateFormat
		,labelSeparator: ''
		,fieldLabel : '结束日期'
		,anchor : '95%'
	});
	obj.itemTimeTo = new Ext.form.TimeField({
		id:'itemTimeTo'
		,value : '23:59:59'
		,format : 'H:i:s'
		,fieldLabel:'结束时间'
		,anchor : '95%'
	});
	obj.itemComAppLoc = new Ext.ux.form.LovCombo({
		id:'itemComAppLoc'
		,fieldLabel : '申请科室'
      	,minChars : 1
		,displayField : 'ctlocDesc'
		,store : obj.comAppLocStore
		,triggerAction : 'all'
		,labelSeparator: ''
		,hideTrigger:false
		,anchor : '95%'
		,valueField : 'ctlocId'
		,mode: 'local'
		,grow:true
		,lazyRender : true
		,hideOnSelect:false
		,autoHeight:true
		,queryInFields:true
		,selectOnFocus:false
		,queryFields:['ctlocDesc'] //这个数组是用来设定查询字段的。
    });
	obj.chkDateTypeOP = new Ext.form.Radio({
		id : 'chkDateTypeOP'
		,name : 'chkDateType'
		,checked : true
		,fieldLabel : '手术'
		,anchor : '95%'
	});
	obj.chkDateTypeAdm = new Ext.form.Radio({
		id : 'chkDateTypeAdm'
		,name : 'chkDateType'
		,fieldLabel : '入院'
		,anchor : '95%'
	});
	obj.chkDateTypeDischarge = new Ext.form.Radio({
		id : 'chkDateTypeDischarge'
		,name : 'chkDateType'
		,fieldLabel : '出院'
		,anchor : '95%'
	});
	obj.checkDateTypeOPPanel = new Ext.Panel({
		id : 'checkDateTypeOPPanel'
		,buttonAlign : 'center'
		,columnWidth : .3
		,labelWidth:40
		,layout : 'form'
		,items : [
			obj.chkDateTypeOP
		]
	});
	obj.checkDateTypeAdmPanel = new Ext.Panel({
		id : 'checkDateTypeAdmPanel'
		,buttonAlign : 'center'
		,columnWidth : .3
		,labelWidth:40
		,layout : 'form'
		,items : [
			obj.chkDateTypeAdm
		]
	});
	obj.checkDateTypeDischargePanel = new Ext.Panel({
		id : 'checkDateTypeDischargePanel'
		,buttonAlign : 'center'
		,columnWidth : .3
		,labelWidth:40
		,layout : 'form'
		,items : [
			obj.chkDateTypeDischarge
		]
	});
	obj.selectDateTypeFormPanel = new Ext.form.FormPanel({
		id : 'selectDateTypeFormPanel'
		,buttonAlign : 'center'
		,labelWidth : 30
		,width : 300
		,height : 30
		,bodyStyle : 'padding-left:25px;'
		,region : 'north'
		,labelAlign : 'right'
		,layout : 'column'
		,items : [
			obj.checkDateTypeOPPanel
			,obj.checkDateTypeAdmPanel
			,obj.checkDateTypeDischargePanel
		]
		,minButtonWidth : 10
	});
	obj.selectDateFormPanel = new Ext.form.FormPanel({
		id : 'selectDateFormPanel'
		,buttonAlign : 'center'
		,labelWidth : 80
		,region : 'center'
		,labelAlign : 'right'
		,layout : 'form'
		,items : [
			obj.itemDateFrm
			//,obj.itemTimeFrm
			,obj.itemDateTo
			//,obj.itemTimeTo
			,obj.itemComAppLoc
		]
		,minButtonWidth : 10
	});
	obj.SeachDatePanel = new Ext.Panel({
		id : 'SeachDatePanel'
		,buttonAlign : 'center'
		,height : 125
		,layout : 'border'
		,region : 'north'
		,autoScroll : true
		,frame :true
		,items:[
			obj.selectDateTypeFormPanel
			,obj.selectDateFormPanel
		]
	});

	obj.SetButtonAbility = function(isEnable)
	{
		for(var i=0;i<obj.selectInquiryPanel.buttons.length;i++)
		{
			if(isEnable)obj.selectInquiryPanel.buttons[i].enable();
			else obj.selectInquiryPanel.buttons[i].disable();
		}
	}

	obj.ResetStartEndDate = function()
	{
		var anciId = obj.anciId;
		var startEndDateStr = obj._DHCANOPStat.GetLastInquiryDuration(anciId);
		var separator = String.fromCharCode(3);
		var dateArr = startEndDateStr.split(separator);
		obj.itemDateFrm.setValue(dateArr[0]);
		obj.itemDateTo.setValue(dateArr[1]);
		obj.itemComAppLoc.setValue(dateArr[2]);
		if(dateArr[3] == "Adm") obj.chkDateTypeAdm.setValue(true);
		else if(dateArr[3] == "Discharge") obj.chkDateTypeDischarge.setValue(true);
		else obj.chkDateTypeOP.setValue(true);
	}

	obj.SetColumnVisible = function(colIndex)
	{
		obj.gridcm.setHidden(Number(colIndex));
		obj.retGridPanel.reconfigure(obj.retGridPanelStore,obj.gridcm);
	}

	obj.RefreshInquiryResult=function()
	{
		if(!obj.CheckSelectInquiry()) return;
		var count = obj.retGridHeaderStore.getCount();
		if(count<1)
		{
			alert("未配置显示项目,请先配置好显示项目再查询");
			return;
		}
		if(obj.chkDateTypeOP.getValue()) obj.dateType = "OP";
		if(obj.chkDateTypeAdm.getValue()) obj.dateType = "Adm";
		if(obj.chkDateTypeDischarge.getValue()) obj.dateType = "Discharge";

		obj.retGridPanelStore.removeAll();
		obj.retGridPanelStore.load({
			params : {
				start:obj.currentPageStart
				,limit:obj.pageSize
				,filter:obj.queryFilter
			}
		});
		obj.SetButtonAbility(false);
	}

	obj.CheckSelectInquiry = function()
	{
		var anciId=obj.comInquiry.getValue();
		if(!Number(anciId))
		{
			alert("请选择查询策略!");
			return false;
		}
		return true;
	}
}