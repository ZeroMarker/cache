(function(){
	Ext.ns("dhcwl.RptMgmt.Export");
})();
///描述: 		查询对象
///编写者：		WZ
///编写日期: 		2016-11
dhcwl.RptMgmt.Export=function(){
	var serviceUrl="dhcwl/rptmgmt/export.csp";
	var outThis=this;
	var outputList= new Array();
	var rangeForm= new Ext.FormPanel({
		frame: true,
		bodyStyle: 'padding:10px 0 0 10px;',
		//bodyStyle: 'padding-left:5px;',
		//xtype: 'fieldset',
		autoHeight: true,
		//defaultType: 'radio', // each item will be a radio button
		items: [{
			layout:'form',  
			xtype:'fieldset',  
			////autoHeight:true,  
			defaultType: 'radio', // each item will be a radio button
			title:'数据范围',  			
			items:[{
				checked: true,
				hideLabel :true,
				//fieldLabel: '数据范围',
				//fieldLabel: '',
				boxLabel: '导出全部数据',
				name: 'expRange',
				inputValue: 'allRecs'
			}, {
				//fieldLabel: '',
				hideLabel :true,
				//labelSeparator: '',
				boxLabel: '导出部分数据',
				name: 'expRange',
				inputValue: 'selRecs'
			}]
		},{
			layout:'form',  
			xtype:'fieldset',  
			////autoHeight:true,  
			defaultType: 'radio', // each item will be a radio button
			title:'文件格式',  	
			items:[{
				checked: true,
				hideLabel :true,
				//fieldLabel: '',
				boxLabel: 'excel格式',
				name: 'fileType',
				inputValue: 'excelType'
			}, {
				//fieldLabel: '',
				//labelSeparator: '',
				hideLabel :true,
				boxLabel: 'XML格式',
				name: 'fileType',
				inputValue: 'xmlType'
			}]
		}]			
		
    });	
	
	var rangeWin = new Ext.Window({
        width:300,
		height:300,
		resizable:false,
		closable : false,
		title:'导出',
		modal:true,
		//items:[saveAsForm,rptGrid],
		items:rangeForm ,		
		layout:'fit',
			
		buttons: [
		{
			text: '<span style="line-Height:1">取消</span>',
			icon   : '../images/uiimages/cancel.png',
			handler:CloseWin			
		},{
			text: '<span style="line-Height:1">下一步</span>',
			icon   : '../images/uiimages/moveright.png',
			handler: OnRangeNext
		}]
	});	
	
	function OnSave() {	
	}
	
	function OnRangeNext() {
		var rangeRecs=rangeForm.getForm().findField("expRange").getGroupValue();
		var fileType=rangeForm.getForm().findField("fileType").getGroupValue();

		if (rangeRecs=='allRecs') {
			if (fileType=='excelType') {
				var excelObj=new dhcwl.RptMgmt.util.Excel();
				excelObj.setTitle("报表管理导出");
				excelObj.setHead(['菜单名称','当前页面(标题)名称','raq名称','CSP名称','主程序query','统计口径',
				'业务表','指标','数据条件','显示条件','逻辑说明',
				'高级客户','项目工程师','开发工程师','备注','日期',
				'最后更新日期','使用科室']);
				excelObj.setfieldNames(['MenuName','AuxiliaryMenuName','RaqName','CSPName','QueryName','Spec',
				'HisTableName','KPIName','Filter','RowColShow','ProgramLogic',
				'AdvUser','ProMaintainer','DepMaintainer','Demo','CreateDate',
				'UPdateDate','UsedByDep']);
				excelObj.setServerUrl(serviceUrl+'?action=expExcel&sqlTableName=DHCWL_RptMgmt.RptCfg&rangeRecs=allRecs');
				rangeWin.body.mask("正在导出数据,请稍后......");
				
				//
				var task = new Ext.util.DelayedTask(function(){
					excelObj.exportExcel(exportCallback,outThis);	
					CloseWin();
				});

				task.delay(10); 
			};
			if (fileType=='xmlType') {
				rangeWin.body.mask("正在导出数据,请稍后......");
				dhcwl.mkpi.Util.ajaxExc(serviceUrl,
				{
					action:'expXml',
					rangeRecs:'allRecs',
					sqlTableName:'DHCWL_RptMgmt.RptCfg'
				}, function(responseText){
					//alert(responseText);
					if(responseText){
						try{
							var strtip=dhcwl.mkpi.Util.trimLeft(responseText).substr(0,4)
							if (strtip=="导出错误") {
								Ext.Msg.show({title:'错误',msg:responseText,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
								return;						
							}

							ret=dhcwl.mkpi.Util.writeFile("报表管理导出"+dhcwl.mkpi.Util.nowDateTime()+'.mgmt',dhcwl.mkpi.Util.trimLeft(responseText));
							rangeWin.body.unmask();
							Ext.Msg.alert("提示","导出已完成！");
							CloseWin();
							//if (ret!="") Ext.MessageBox.alert("提示","导出成功！");
						}catch(e){
							Ext.Msg.show({title:'错误',msg:"写文件错误！",buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							return;
						}				
					}else{
						Ext.Msg.show({title : '错误',msg : "导出失败！\n" +responseText,buttons : Ext.Msg.OK,icon : Ext.MessageBox.ERROR});
					}
				}
				,outThis,true);


			
			}
			
		}else if (rangeRecs=='selRecs') {
			rangeWin.hide();
			searchRptWin.show();
			searchRptGrid.getStore().load({params:{start:0,limit:50}});	
			
		}
	}
	
	function exportCallback(msg) {

		rangeWin.body.unmask();
		Ext.Msg.alert("提示",msg);
	}
	
	//////////////////////////////////////////////////////////////////////
	///部分导出窗口
    var store = new Ext.data.Store({
        proxy: new Ext.data.HttpProxy({url:'dhcwl/rptmgmt/showmain.csp?action=getSavedMgmt'}),
        reader: new Ext.data.JsonReader({
            totalProperty: 'totalNum',
            root: 'root',
        	fields:[
				{name:'ID'},
				{name:'AdvUser'},
				{name:'AuxiliaryMenuName'},
				{name:'CSPName'},
				{name:'CreateDate'},
				{name:'Demo'},
				{name:'DepMaintainer'},
				{name:'Filter'},
				{name:'HisTableName'},
				{name:'KPIName'},
				{name:'MenuName'},
				{name:'ProMaintainer'},
				{name:'ProgramLogic'},
				{name:'QueryName'},
				{name:'RaqName'},
				{name:'RowColShow'},
				{name:'Spec'},
				{name:'UPdateDate'}
			]
    	})
    });
	
	var sm = new Ext.grid.CheckboxSelectionModel({
		listeners :{
			'rowdeselect':function(csm, rowIndex, recorde){
				var ID=recorde.get('ID');
				selIDsRemove(ID);
			}
			,'rowselect':function(csm, rowIndex, recorde){
				var ID=recorde.get('ID');
				selIDsAdd(ID);
			}
		}
	});
	var columnModel = new Ext.grid.ColumnModel({
            defaults: {
                width: 100,
                sortable: false
            },
            columns: [
				new Ext.grid.RowNumberer(),
				sm,
				{header:'菜单名称',dataIndex:'MenuName', width: 150},
				{header:'菜单表达式',dataIndex:'RaqName', width: 150},
				{header:'CSP名称',dataIndex:'CSPName', width: 150},
				{header:'使用（科室）部门',dataIndex:'AuxiliaryMenuName', width: 150}
				
			]
	});
	
	

    var searchRptGrid = new Ext.grid.GridPanel({
        store: store,
        cm: columnModel,
		sm: sm,
        viewConfig: {
            forceFit:true
        }, 		
        tbar:new Ext.Toolbar({
        	layout: 'hbox',
        	items : [		
			'菜单名称:',
			{
				name:'MenuName',
				//width: 100,	
				xtype:'textfield'	
			},
			"-",
			"Raq名称:",
			{
				name:'RaqName',
				//value:'raq',
				xtype:'textfield'
			},			
			"-",
			"CSP名称:",
			{
				name:'CSPName',
				xtype:'textfield'
			},{
				text: '<span style="line-Height:1">查询</span>',
				icon   : '../images/uiimages/search.png',	
				xtype:'button',
				handler:OnSearch
			},	
			"-",
			{
				text: '<span style="line-Height:1">清空</span>',					
				icon   : '../images/uiimages/clearscreen.png',
				xtype:'button',
				handler:OnReset			
			}				
				
			]
		}),			
		bbar: new Ext.PagingToolbar({
			pageSize:50,
			store:store,
			displayInfo:true,
			displayMsg:'{0}~{1}条,共 {2} 条',
			emptyMsg:'sorry,data not found!',
			listeners :{
				'change':function(pt,page){
					var ID="";
					var AllRowCnt=store.getCount();
					var selRowCnt=0;					
					for(var i=store.getCount()-1;i>-1;i--){
						ID=store.getAt(i).get("ID");
						if(selIDsCheck(ID)){
							sm.selectRow(i,true,false);
							selRowCnt++
						}
					}
					
					var hd_checker = searchRptGrid.getEl().select('div.x-grid3-hd-checker');
			    	var hd = hd_checker.first();
			    	if(hd!=null ){
			    	    if(AllRowCnt!=selRowCnt && hd.hasClass('x-grid3-hd-checker-on')){
			    	    	hd.removeClass('x-grid3-hd-checker-on');
				    	}else if(AllRowCnt==selRowCnt && !hd.hasClass('x-grid3-hd-checker-on'))
				    	{
				    		hd.addClass('x-grid3-hd-checker-on');
				    	}
			    	}					
				}
			}
		})
    });	
	
	
	var searchRptWin=new Ext.Window({
        width:700,
		height:600,
		title:'已配置的raq数据',
		layout:'fit',	
		items: searchRptGrid,
		buttons: [
		{
			text: '<span style="line-Height:1">取消</span>',
			icon   : '../images/uiimages/cancel.png',
			handler: CloseWin
		},		{
			text: '<span style="line-Height:1">上一步</span>',
			icon   : '../images/uiimages/moveleft.png',
			handler: OnSearchRptWinPrevious 
		},		{
			text: '<span style="line-Height:1">下一步</span>',
			icon   : '../images/uiimages/moveright.png',
			handler: OnSearchRptWinNext 
		}]		
		
    });
	
	function OnSearchRptWinPrevious() {
		rangeWin.show();
		searchRptWin.hide();
	}
		
	function OnSearchRptWinNext() {
		var rangeRecs=rangeForm.getForm().findField("expRange").getGroupValue();
		var fileType=rangeForm.getForm().findField("fileType").getGroupValue();
		if (fileType=='excelType') {		
			var excelObj=new dhcwl.RptMgmt.util.Excel();
			excelObj.setTitle("报表管理导出");
			excelObj.setHead(['菜单名称','当前页面(标题)名称','raq名称','CSP名称','主程序query','统计口径',
			'业务表','指标','数据条件','显示条件','逻辑说明',
			'高级客户','项目工程师','开发工程师','备注','日期',
			'最后更新日期','附属菜单','使用科室']);
			excelObj.setfieldNames(['MenuName','AuxiliaryMenuName','RaqName','CSPName','QueryName','Spec',
			'HisTableName','KPIName','Filter','RowColShow','ProgramLogic',
			'AdvUser','ProMaintainer','DepMaintainer','Demo','CreateDate',
			'UPdateDate','UsedByDep']);
			
			excelObj.setServerUrl(serviceUrl+'?action=expExcel&sqlTableName=DHCWL_RptMgmt.RptCfg&rangeRecs='+outputList.join());
			searchRptWin.body.mask("正在导出数据,请稍后......");
			//excelObj.exportExcel(exportCallback,outThis);	
			//CloseWin();
			
			searchRptWin.body.mask("正在导出数据,请稍后......");
			
			//
			var task = new Ext.util.DelayedTask(function(){
				excelObj.exportExcel(exportCallback,outThis);	
				CloseWin();
			});

			task.delay(10); 			
			
		}
		if (fileType=='xmlType') {
			searchRptWin.body.mask("正在导出数据,请稍后......");
			dhcwl.mkpi.Util.ajaxExc(serviceUrl,
			{
				action:'expXml',
				rangeRecs:outputList.join(),
				sqlTableName:'DHCWL_RptMgmt.RptCfg'
			}, function(responseText){
				//alert(responseText);
				if(responseText){
					try{
						var strtip=dhcwl.mkpi.Util.trimLeft(responseText).substr(0,4)
						if (strtip=="导出错误") {
							Ext.Msg.show({title:'错误',msg:responseText,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							return;						
						}

						ret=dhcwl.mkpi.Util.writeFile("报表管理导出"+dhcwl.mkpi.Util.nowDateTime()+'.mgmt',dhcwl.mkpi.Util.trimLeft(responseText));
						searchRptWin.body.unmask();
						Ext.Msg.alert("提示","导出已完成！");	
						CloseWin();						
						//if (ret!="") Ext.MessageBox.alert("提示","导出成功！");
					}catch(e){
						Ext.Msg.show({title:'错误',msg:"写文件错误！",buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
						return;
					}				
				}else{
					Ext.Msg.show({title : '错误',msg : "导出失败！\n" +responseText,buttons : Ext.Msg.OK,icon : Ext.MessageBox.ERROR});
				}
			}
			,outThis,true);
		}		
	}
	
	function OnSearch() {
		//1、得到页面查询值
		var menuNameInx=searchRptGrid.getTopToolbar().items.findIndex("name","MenuName");
		var MenuName=searchRptGrid.getTopToolbar().items.itemAt(menuNameInx).getValue();
		var raqNameInx=searchRptGrid.getTopToolbar().items.findIndex("name","RaqName");
		var RaqName=searchRptGrid.getTopToolbar().items.itemAt(raqNameInx).getValue();
		var cSPNameInx=searchRptGrid.getTopToolbar().items.findIndex("name","CSPName");
		var CSPName=searchRptGrid.getTopToolbar().items.itemAt(cSPNameInx).getValue();
		
		//2、设置查询参数
		searchRptGrid.getStore().setBaseParam("MenuName",MenuName);	
		searchRptGrid.getStore().setBaseParam("RaqName",RaqName);	
		searchRptGrid.getStore().setBaseParam("CSPName",CSPName);	
		searchRptGrid.getStore().reload({params:{start:0,limit:50}});
	}
	
	function OnReset() {
		var menuNameInx=searchRptGrid.getTopToolbar().items.findIndex("name","MenuName");
		var MenuName=searchRptGrid.getTopToolbar().items.itemAt(menuNameInx).setValue("");
		var raqNameInx=searchRptGrid.getTopToolbar().items.findIndex("name","RaqName");
		var RaqName=searchRptGrid.getTopToolbar().items.itemAt(raqNameInx).setValue("");
		var cSPNameInx=searchRptGrid.getTopToolbar().items.findIndex("name","CSPName");
		var CSPName=searchRptGrid.getTopToolbar().items.itemAt(cSPNameInx).setValue("");
		
		//2、设置查询参数
		searchRptGrid.getStore().setBaseParam("MenuName","");	
		searchRptGrid.getStore().setBaseParam("RaqName","");	
		searchRptGrid.getStore().setBaseParam("CSPName","");		
		
	}
	
	function OnLoad() {
		if(outThis.onLoadCallback)
		{
		}
				
	}
	function CloseWin() {
			rangeWin.close();
			searchRptWin.close();
	}
 
	function selIDsRemove(ID) {
		
		if(!ID||ID=="") return;
		
		var len=outputList.length;
		for(var i=0;i<len;i++){
			if(outputList[i]==ID){
				for(var j=i;j<len;j++){
					outputList[j]=outputList[j+1];
				}
				outputList.length=len-1;
				break;
			}
		}			
	}
	
	function selIDsAdd(ID) {
		if(!ID||ID=="") return;
		for(var i=outputList.length-1;i>-1;i--){
			if(outputList[i]==ID)
				return;
		}
		outputList.push(ID);		
	}

	function selIDsCheck(ID) {
		if(!ID||ID=="") return false;
		for(var i=outputList.length-1;i>-1;i--){
			if(outputList[i]==ID){
				return true;
			}
		}
		return false;		
	}
		
	this.showRangeWin=function() {
		rangeWin.show();
	}

	this.initForAddWin=function() {

	}
	
	this.initParam=function(inParam) {
	}
}

