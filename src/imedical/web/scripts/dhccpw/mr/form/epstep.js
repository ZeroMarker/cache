function InitEpStepWindow(PathWayID,UserID,winTitle){
	var obj = new Object();
	obj.UserID=UserID;
	obj.PathWayID=PathWayID;
	obj.winTitle=winTitle;
	if (!obj.PathWayID) return;
	
	obj.cboPrimalCompStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
			url : ExtToolSetting.RunQueryPageURL
		}));
	obj.cboPrimalCompStore = new Ext.data.Store({
		proxy: obj.cboPrimalCompStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'CPWID'
		}, 
		[
			{name: 'CPWID', mapping: 'CPWID'}
			,{name: 'CPWDesc', mapping: 'CPWDesc'}
		])
	});
	obj.cboPrimalCompStoreProxy.on('beforeload', function(objProxy, param){
			param.ClassName = 'web.DHCCPW.MR.ClinPathWaysEstimate';
			param.QueryName = 'QryPrimalComp';
			param.Arg1 = obj.PathWayID;
			param.ArgCnt = 1;
	});
	var cboPrimalComp = new Ext.form.ComboBox({
		id : 'cboPrimalComp'
		,store:obj.cboPrimalCompStore
		,displayField:'CPWDesc'
		,valueField:'CPWID'
		,blankText:'��ѡ��ϲ�֢'
		,emptyText:'��ѡ��ϲ�֢'
		,fieldLabel: '�����б�'
		,typeAhead:true
		,editbale:false
		,width : 120
		,listeners:{
			'blur': function(){
				obj.cboPrimalCompStore.removeAll();
			}
			,'focus': function(){
				obj.cboPrimalCompStore.load({});
			}
	    }
	});
	
	var btnAddComplication = new Ext.Toolbar.Button({
		tooltip: '��Ӻϲ�֢'
		,id: 'btnAddComplication'
		,iconCls: 'icon-add'
		,text : '���'
		,handler: function(){
			obj.AddComplication();
		}
	});
	
	obj.cboEstimateCompStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
			url : ExtToolSetting.RunQueryPageURL
		}));
	obj.cboEstimateCompStore = new Ext.data.Store({
		proxy: obj.cboEstimateCompStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'CPWID'
		}, 
		[
			{name: 'CPWID', mapping: 'CPWID'}
			,{name: 'CPWDesc', mapping: 'CPWDesc'}
		])
	});
	obj.cboEstimateCompStoreProxy.on('beforeload', function(objProxy, param){
			param.ClassName = 'web.DHCCPW.MR.ClinPathWaysEstimate';
			param.QueryName = 'QryEstimateComp';
			param.Arg1 = obj.PathWayID;
			param.ArgCnt = 1;
	});
	var cboEstimateComp = new Ext.form.ComboBox({
		id : 'cboEstimateComp'
		,store:obj.cboEstimateCompStore
		,displayField:'CPWDesc'
		,valueField:'CPWID'
		,blankText:'��ѡ��ϲ�֢'
		,emptyText:'��ѡ��ϲ�֢'
		,fieldLabel: '�����б�'
		,typeAhead:true
		,editbale:false
		,width : 120
		,listeners:{
	        'blur': function(){
				obj.cboEstimateCompStore.removeAll();
			}
			,'focus': function(){
				obj.cboEstimateCompStore.load({});
			}
		}
	});
	
	var btnDelComplication = new Ext.Toolbar.Button({
		tooltip: '�Ƴ��ϲ�֢'
		,id: 'btnDelComplication'
		,iconCls: 'icon-delete'
		,text : '�Ƴ�'
		,handler: function(){
			obj.DelComplication();
		}
	});
	
	var btnUpdateEvent = new Ext.Toolbar.Button({
		tooltip: '����'
		,id: 'btnUpdateEvent'
		,iconCls: 'icon-update'
		,text : '����'
		,handler: function(){
			obj.UpdateEvent();
		}
	});
	
	var btnExitEvent = new Ext.Toolbar.Button({
		tooltip: '�ر�'
		,id: 'btnExitEvent'
		,iconCls: 'icon-exit'
		,text : '�ر�'
		,handler: function(){
			obj.ExitEvent();
		}
	});
	
    obj.EpStepGridPanelStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
			url : ExtToolSetting.RunQueryPageURL
	}));
	obj.EpStepGridPanelStore = new Ext.data.Store({
		proxy: obj.EpStepGridPanelStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'EpStepNo'
		}, 
		[
			{name: 'EpStepRowID', mapping: 'EpStepRowID'}
			,{name: 'EpStepNo', mapping: 'EpStepNo'}
			,{name: 'EpStepDesc', mapping: 'EpStepDesc'}
			,{name: 'EpStepDay', mapping: 'EpStepDay'}
			,{name: 'EpRowID', mapping: 'EpRowID'}
			,{name: 'EpDesc', mapping: 'EpDesc'}
			,{name: 'EpStepEstTime', mapping: 'EpStepEstTime'}
		])
	});
	obj.EpStepGridPanel = new Ext.grid.GridPanel({
		id : 'EpStepGridPanel'
		,ddGroup : 'EstGridDDGroup'
		,store : obj.EpStepGridPanelStore
		,columns: [
			{header: '����', width: 100, dataIndex: 'EpStepDesc', sortable: false}
			,{header: '�ο�ʱ��', width: 60, dataIndex: 'EpStepDay', sortable: false}
		]
		,enableDragDrop : true
		,stripeRows : true
		,autoExpandColumn : 'EpStepDesc'
		,title : '�����б�'
		,region : 'west'
		,width : 240
		,bodyStyle : 'width:100%'
        ,autoWidth : true
        ,autoScroll : true
		,viewConfig : {
            forceFit : true
        }
	});
	obj.EpStepGridPanelStoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'web.DHCCPW.MR.ClinPathWaysEstimate';
		param.QueryName = 'QryPrimalEpSteps';
		param.Arg1 = obj.PathWayID;
		param.ArgCnt = 1;
	});
	obj.EpStepGridPanelStore.load({});
	
	try {
    	var objClass = ExtTool.StaticServerObject("web.DHCCPW.MR.ClinPathWaysEstimate");
		if (objClass){
			var JsonExp=objClass.BuildEstStepsJsonHeader(obj.PathWayID);
			//window.eval(JsonExp);  //��������:gridHeader��gridColumn��storeFields
			eval(JsonExp); //�Ǽ���ģʽ �������贰�ڵ�������
		}
    }catch (e) {
    	var gridHeader="",gridColumn="",storeFields="";
    	ExtTool.alert("����", "��ȡ��̬Json���ݴ���!");
    }
    if ((gridHeader=="")||(gridColumn=="")||(storeFields=="")) return;
    obj.gridHeader=gridHeader;
	obj.gridColumn=gridColumn;
	obj.storeFields=storeFields;
	
	obj.EstStepGridPanelStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : './dhccpw.flexiblestore.csp'
		,timeout: 300000
		,method:'POST'
	}));
	obj.EstStepGridPanelStore = new Ext.data.Store({
		proxy: obj.EstStepGridPanelStoreProxy,
		reader: new Ext.data.JsonReader(
			{
				root: 'record'
				,totalProperty: 'total'
			}
			,obj.storeFields
		)
	});
	obj.EstStepGridPanel = new Ext.grid.GridPanel({
		id : 'EstStepGridPanel'
		,ddGroup : 'EpGridDDGroup'
		,store : obj.EstStepGridPanelStore
		,columns: obj.gridColumn
		,enableDragDrop : true
		,stripeRows : true
		,title : '�����б�'
		,region : 'center'
		,bodyStyle : 'width:100%'
        ,autoWidth : true
        ,autoScroll : true
		//,viewConfig : {
        //    forceFit : true
        //}
	});
	obj.EstStepGridPanelStoreProxy.on('beforeload', function(objProxy, param){
			param.ClassName = 'web.DHCCPW.MR.ClinPathWaysEstimate';
			param.MethodName = 'BuildEstStepsJsonStore';
			param.Arg1 = obj.PathWayID;
			param.ArgCnt = 1;
	});
	obj.EstStepGridPanelStore.load({});
	
	obj.EpStepWindow = new Ext.Window({
		id : 'EpStepWindow'
		,buttonAlign : 'center'
		,maximized : false
		,resizable : false
		,title : winTitle
		,layout : 'border'
		,width : 650
		,height : 400
		,modal: true
		,closable : false
		,items:[
			obj.EpStepGridPanel
			,obj.EstStepGridPanel
		]
		,bbar: [
			'<I>��ӻ��Ƴ� �ϲ�֢: </I>'
			,'-'
			,cboPrimalComp
			,btnAddComplication
			,'-'
			,cboEstimateComp
			,btnDelComplication
			//,'-'
			//,btnUpdateEvent
			,'-'
			,btnExitEvent
			,'-'
		]
		,listeners: {
			beforeclose:function(){
				window.location.reload();
			}
		}
	});
	
    obj.AddComplication = function(){
    	obj.cboPrimalComp=Ext.getCmp('cboPrimalComp');
    	var newHeader=obj.cboPrimalComp.getRawValue();
    	var newComp=obj.cboPrimalComp.getValue();
    	if ((newHeader=="")||(newComp=="")) return;
    	var newDataIndex="Comp"+newComp;
    	var newColumn=new Ext.grid.CheckColumn({header:newHeader, dataIndex: newDataIndex, width: 100, checked :true});
    	var newColumnModel=obj.EstStepGridPanel.getColumnModel();
		newColumnModel.config.push(newColumn);
		var newField=new Ext.data.Field({name: newDataIndex, mapping: newDataIndex});
		var newStore=obj.EstStepGridPanel.getStore();
		newStore.fields.add(newField);
		obj.EstStepGridPanel.reconfigure(newStore,newColumnModel);
		
		var tmpStore=obj.EstStepGridPanel.getStore();
		for (var rowIndex=0;rowIndex<tmpStore.getCount();rowIndex++)
		{
			var objRec = tmpStore.getAt(rowIndex);
		    objRec.set(newDataIndex, true);
		    obj.EstStepGridPanelStore.commitChanges();
		}
		obj.EstStepGridPanel.getView().refresh();
		
		//��ӱ��ϲ�֢
		var objMRClinicalPathWaysSrv = ExtTool.StaticServerObject("web.DHCCPW.MR.ClinicalPathWays");
		var ret=objMRClinicalPathWaysSrv.AddComplication(obj.PathWayID,newComp)
		if (ret<=0){
			ExtTool.alert("��ʾ","��Ӻϲ�֢ʧ��!");
		}
		obj.cboPrimalComp.clearValue();
		
		obj.UpdateEvent();
    }
    
    obj.DelComplication = function(){
    	obj.cboEstimateComp=Ext.getCmp('cboEstimateComp');
    	var estHeader=obj.cboEstimateComp.getRawValue();
    	var estComp=obj.cboEstimateComp.getValue();
    	if ((estHeader=="")||(estComp=="")) return;
    	
    	//ɾ�����ϲ�֢ǰ�ȼ��ϲ�֢�Ƿ�����ɾ��
		//����ʵʩ��¼��������ɾ��
		var objMRClinicalPathWaysSrv = ExtTool.StaticServerObject("web.DHCCPW.MR.ClinicalPathWays");
		var errList=objMRClinicalPathWaysSrv.CheckCompToDel(obj.PathWayID,estComp)
		if (errList!==''){
			ExtTool.alert("��ʾ",errList);
			return;
		}
    	
    	var estDataIndex="Comp"+estComp;
    	var estColumnModel=obj.EstStepGridPanel.getColumnModel();
    	var estColumnModelConfig=estColumnModel.config;
    	for (var columnIndex=0;columnIndex<estColumnModelConfig.length;columnIndex++){
    		if (estColumnModelConfig[columnIndex].dataIndex==estDataIndex){
    			estColumnModel.config=estColumnModelConfig.slice(0,columnIndex).concat(estColumnModelConfig.slice(columnIndex+1,estColumnModelConfig.length));
    		}
    	}
		var estStore=obj.EstStepGridPanel.getStore();
		obj.EstStepGridPanel.reconfigure(estStore,estColumnModel);
		
		var tmpStore=obj.EstStepGridPanel.getStore();
		for (var rowIndex=0;rowIndex<tmpStore.getCount();rowIndex++)
		{
			var objRec = tmpStore.getAt(rowIndex);
		    objRec.set(estDataIndex, false);
		    obj.EstStepGridPanelStore.commitChanges();
		}
		obj.EstStepGridPanel.getView().refresh();
		
		//ɾ�����ϲ�֢
		var ret=objMRClinicalPathWaysSrv.DelComplication(obj.PathWayID,estComp)
		if (ret<=0){
			ExtTool.alert("��ʾ","ɾ���Ϸ�֢ʧ��!");
		}
		obj.cboEstimateComp.clearValue();
		
		obj.UpdateEvent();
    }
    
    obj.EstStepGridPanel.on('cellclick',function(grid, rowIndex, columnIndex, e){
	    var objRec = grid.getStore().getAt(rowIndex);
	    var fieldName = grid.getColumnModel().getDataIndex(columnIndex);
	    var tmpCompList=fieldName.split("Comp");
	    if (tmpCompList.length<2) return;
	    var recValue = objRec.get(fieldName);
	    objRec.set(fieldName, (!recValue));
	    obj.EstStepGridPanelStore.commitChanges();
		obj.EstStepGridPanel.getView().refresh();
		
		obj.UpdateEvent();
	})
	
	obj.UpdateEvent = function(){
		var estList="";
		var estStore=obj.EstStepGridPanel.getStore();
		var estColumnModel=obj.EstStepGridPanel.getColumnModel();
		for (var rowIndex=0;rowIndex<estStore.getCount();rowIndex++){
			var objRec = estStore.getAt(rowIndex);
			var estStepID=objRec.get("EpStepRowID");
			var estTime=objRec.get("EpStepEstTime");
			var estCompList="";
			for (var columnIndex=0;columnIndex<estColumnModel.getColumnCount();columnIndex++){
				var fieldName=estColumnModel.getDataIndex(columnIndex);
				var tmpCompList=fieldName.split("Comp");
		    	if (tmpCompList.length<2) continue;
		    	var estComp=objRec.get(fieldName);
		    	if (estComp) {
		    		if (estCompList==''){
		    			estCompList=tmpCompList[1];
		    		}else{
		    			estCompList=estCompList+","+tmpCompList[1];
		    		}
		    	}
			}
			if (estList==''){
				var estList=estStepID+"/"+estTime+"/"+estCompList;
			}else{
				var estList=estList+"$"+estStepID+"/"+estTime+"/"+estCompList;
			}
		}
		if (estList=='') {
			ExtTool.alert("��ʾ","δ��ӱ�����!");
			return;
		}
		var estList=obj.PathWayID+"^"+estList+"^"+obj.UserID;
		//alert(estList);
		var objMRClinPathWaysEstimate = ExtTool.StaticServerObject("web.DHCCPW.MR.ClinPathWaysEstimate");
		var ret=objMRClinPathWaysEstimate.UpdateEstimate(estList)
		if (ret<=0){
			ExtTool.alert("��ʾ","�ύ�����б�ʧ��!");
		}
	}
	
	obj.ExitEvent = function(){
		var estStore=obj.EstStepGridPanel.getStore();
		if (estStore.getCount()<1)
		{
			ExtTool.alert("��ʾ","δ������Ʋ���!");
			return;
		}
		obj.EpStepWindow.close();
	}
	return obj;
}

function InitEpStepWindowHeader(PathWayID,UserID,winTitle,IsOffShoot)
{
	var objEpStepWindow = new InitEpStepWindow(PathWayID,UserID,winTitle);
	objEpStepWindow.EpStepWindow.show();
	var numTop=(screen.availHeight-objEpStepWindow.EpStepWindow.height)/3;
	var numLeft=(screen.availWidth-objEpStepWindow.EpStepWindow.width)/2;
	objEpStepWindow.EpStepWindow.setPosition(numLeft,numTop);
	ExtDeignerHelper.HandleResize(objEpStepWindow);
	
	if (IsOffShoot=='Yes')
	{
		var objMRClinPathWaysEstimate = ExtTool.StaticServerObject("web.DHCCPW.MR.ClinPathWaysEstimate");
		var EpStepGridTargetEl = objEpStepWindow.EpStepGridPanel.getView().scroller.dom;
	    var EpStepGridTarget = new Ext.dd.DropTarget(EpStepGridTargetEl, {
	            ddGroup    : 'EpGridDDGroup',
	            notifyDrop : function(ddSource, e, data){
	                    var records =  ddSource.dragData.selections;
	                    
	                    //�Ƴ�����ǰ�ȼ�鲽���Ƿ�����ɾ��
	                    //����ʵʩ��¼��������ɾ����ǩ����������ɾ��
	                    var errList="";
	                    for (var recordsIndex=0;recordsIndex<records.length;recordsIndex++){
		                    var estStepID=records[recordsIndex].get("EpStepRowID");
					        var ret=objMRClinPathWaysEstimate.CheckEstStepToDel(objEpStepWindow.PathWayID,estStepID)
							if (ret!==''){
								errList = errList + ret + CHR_ER;
							}
	                	}
	                	if (errList!==''){
		                	ExtTool.alert("��ʾ",errList);
							return false;
						}
	                    
	                    Ext.each(records, ddSource.grid.store.remove, ddSource.grid.store);
	                    objEpStepWindow.EpStepGridPanel.store.add(records);
	                    objEpStepWindow.EpStepGridPanel.store.sort('EpStepNo', 'ASC');
	                    objEpStepWindow.UpdateEvent();
	                    return true
	            }
	    });
	    
	    var EstStepGridTargetEl = objEpStepWindow.EstStepGridPanel.getView().scroller.dom;
	    var EstStepGridTarget = new Ext.dd.DropTarget(EstStepGridTargetEl, {
	            ddGroup    : 'EstGridDDGroup',
	            notifyDrop : function(ddSource, e, data){
	                    var records =  ddSource.dragData.selections;
	                    Ext.each(records, ddSource.grid.store.remove, ddSource.grid.store);
	                    objEpStepWindow.EstStepGridPanel.store.add(records);
	                    
						var tmpColumnModel=objEpStepWindow.EstStepGridPanel.getColumnModel();
						var tmpStore=objEpStepWindow.EstStepGridPanel.getStore();
						for (var columnIndex=0;columnIndex<tmpColumnModel.getColumnCount();columnIndex++){
							var fieldName=tmpColumnModel.getDataIndex(columnIndex);
							var tmpCompList=fieldName.split("Comp");
					    	if (tmpCompList.length<2) continue;
					    	for (var recordsIndex=0;recordsIndex<records.length;recordsIndex++){
								var objRec=tmpStore.getAt(tmpStore.getCount()-recordsIndex-1);
						    	objRec.set(fieldName, true);
					    		objEpStepWindow.EstStepGridPanelStore.commitChanges();
							}
						}
						objEpStepWindow.EstStepGridPanel.getView().refresh();
						objEpStepWindow.EstStepGridPanel.store.sort('EpStepNo', 'ASC');
						objEpStepWindow.UpdateEvent();
	                    return true
	            }
	    });
	}
	
	
}