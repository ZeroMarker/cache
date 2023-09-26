function InitviewScreenEvent(obj) {
	
	obj.LoadEvent = function(args) {
		obj.CTLoc.on("expand", obj.CTLoc_OnExpand, obj);
		obj.cboWard.on("expand", obj.cboWard_OnExpand, obj);
		obj.CTDoctor.on("expand", obj.CTDoctor_OnExpand, obj);
		//obj.ResultGridPanel.on("rowclick", obj.ResultGridPanel_OnRowClick, obj);
		//obj.btnExport.on("click", obj.btnExport_OnClick, obj);
		obj.btnQuery.on("click", obj.btnQuery_OnClick, obj);
		obj.btnCancle.on("click", obj.btnCancle_OnClick, obj);
		obj.btnCancleAllocate.on("click", obj.btnCancleAllocate_OnClick, obj);
		obj.btnReCancle.on("click", obj.btnReCancle_OnClick, obj);
		obj.btnHang.on("click", obj.btnHang_OnClick, obj);
		obj.btnCancleHang.on("click", obj.btnCancleHang_OnClick, obj);
		obj.ChangeAppInfo.on("click", obj.ChangeAppInfo_OnClick, obj);
		Ext.get('paadmadmno').on("keydown",obj.paadmadmno_OnKeydown, obj);
		Ext.get('papminame').on("keydown",obj.papminame_OnKeydown, obj);
		Ext.get('paadmno').on("keydown",obj.paadmno_OnKeydown, obj);
	};
	
	obj.CTLoc_OnExpand = function() {
		obj.CTLocStore.load({});
	};
	obj.cboWard_OnExpand = function() {
		obj.cboWardStore.load({});
	};
	obj.CTDoctor_OnExpand = function() {
		obj.CTDoctorStore.load({});
	};
	
	obj.btnQuery_OnClick = function(){
		//obj.ResultGridPanelStore.load({});
		var IPBookNo = obj.paadmadmno.getValue();
		var PAPMINO = obj.paadmno.getValue();
		var PatName = obj.papminame.getValue();
		var BookStartDate = obj.registerStartDate.getRawValue();
		var BookEndDate = obj.registerEndDate.getRawValue();
		var AppDate = obj.orderInDate.getRawValue();
		var AppWard = Ext.getCmp('cboWard').getValue();
		var AppLoc =  Ext.getCmp('CTLoc').getValue();
		var AppDoc = Ext.getCmp('CTDoctor').getValue();
		var IfAllocate = Ext.getCmp('IfAllocate').getValue();
		var SortMethod = Ext.getCmp('SortMethod').getValue();
		var DateCondition = Ext.getCmp('DateCondition').getValue();
		var AccompanySex = Ext.getCmp('AccompanySex').getValue();
		/*
		for (var i = 0; i < obj.IfAllocate.items.length; i++) {   
        	if (obj.IfAllocate.items.itemAt(i).checked) {
	        	if (obj.IfAllocate.items.itemAt(i).name=="Allocate"){IfAllocate=1;}
	        	if (obj.IfAllocate.items.itemAt(i).name=="IsCancle"){IfAllocate=2;}
	        }    
        }
        */
        
		if ((PAPMINO!="")&&(PAPMINO.length<10)) {
			for (var i=(10-PAPMINO.length-1); i>=0; i--) {
				PAPMINO="0"+PAPMINO;
			}
		}
		//alert("PAPMINO=="+PAPMINO);
		Ext.getCmp('paadmno').setValue(PAPMINO);
        //alert(Ext.getCmp('IfAllocate').getValue());
		Ext.Ajax.request({
			url:'DHCDocIPAppointmentdata.csp',
			params:{action:'GetIPAppPatientList',IPBookNo:IPBookNo, PAPMINO:PAPMINO, PatName:PatName, BookStartDate:BookStartDate, BookEndDate:BookEndDate, AppDate:AppDate, AppWard:AppWard, AppLoc:AppLoc, AppDoc:AppDoc, IfAllocate:IfAllocate, SortMethod:SortMethod,DateCondition:DateCondition,AccompanySex:AccompanySex,PageFlag:2} ,
			success: function(result, request) {
				var gridResultStore=obj.gridResultStore;
				gridResultStore.removeAll();
				var jsonData = Ext.util.JSON.decode( result.responseText );
				if (jsonData.PatientList!='') {
					//alert(jsonData.PatientList)
					
					var PatientListArr=jsonData.PatientList.split("!");
					
					for (var i=0;i<PatientListArr.length;i++) {
						//{name: 'checked', mapping : 'checked'}
						var IPAppID = PatientListArr[i].split("^")[1];
						var myPAPMINO = PatientListArr[i].split("^")[2];
						var myBookDate = PatientListArr[i].split("^")[4];
						var myPatName = PatientListArr[i].split("^")[5];
						var myPatSex = PatientListArr[i].split("^")[6];
						var PatType = PatientListArr[i].split("^")[7];
						var myAppLoc = PatientListArr[i].split("^")[8];
						var myAppDate = PatientListArr[i].split("^")[9];
						var BedNo = PatientListArr[i].split("^")[10];
						var IPStatus = PatientListArr[i].split("^")[11];
						//var IPDate = PatientListArr[i].split("^")[12];
						var PatAddress = PatientListArr[i].split("^")[15];
						var PatMobPhone = PatientListArr[i].split("^")[16];
						var TelH = PatientListArr[i].split("^")[17];
						var PatNameFlag = PatientListArr[i].split("^")[18];
						var AccompanySex = PatientListArr[i].split("^")[19];
						
						var record = new Object();
			       		record.IPAppID = IPAppID ;
			       		record.myPAPMINO = myPAPMINO ;
			       		record.myBookDate = myBookDate ;
			       		record.myPatName = myPatName ;
			       		record.myPatSex = myPatSex ;
			       		record.PatType = PatType ;
			       		record.myAppLoc = myAppLoc ;
			       		record.myAppDate = myAppDate ;
			       		record.BedNo = BedNo ;
			       		record.IPStatus = IPStatus ;
			       		//record.IPDate = IPDate ;
			       		record.PatAddress = PatAddress ;
			       		record.PatMobPhone = PatMobPhone;
		  	     		record.TelH = TelH;
			       		record.AccompanySex = AccompanySex ;
			       		var records = new Ext.data.Record(record);
			       		
						gridResultStore.add(records);
						
						if (PatNameFlag==0) {
		 	      			//var recordNo = PatientListArr[i].split("^")[0];
		 	      			obj.gridResult.getSelectionModel().selectRow(i);
		 	      		}
		 	      		
					}
				}
				

			},
			scope: this
		}) ;
	};
	
	obj.paadmadmno_OnKeydown = function(e) {
		
		keycode=websys_getKey(e);
		if ((keycode==13)||(keycode==9)){
			obj.btnQuery_OnClick();
		}
	}
	obj.papminame_OnKeydown = function(e) {
		
		keycode=websys_getKey(e);
		if ((keycode==13)||(keycode==9)){
			obj.btnQuery_OnClick();
		}
	}
	
	obj.paadmno_OnKeydown = function(e) {
		keycode=websys_getKey(e);
		if ((keycode==13)||(keycode==9)){
			obj.btnQuery_OnClick();
		}
	}
	
	obj.btnCancle_OnClick = function() {
		
		var selections=obj.gridResult.getSelectionModel().getSelections();
		//alert("selections=="+selections.length);
		if (selections.length == 0) {
			alert("����ѡ���¼!");
			return ;
		}
		
		var IPAppIDArr=""
		for (var i = 0; i < selections.length; i++) { 
			var record = selections[i]; 
			var IPAppID=record.get("IPAppID");
			//CancleID
			if (IPAppIDArr=="") {
				IPAppIDArr=IPAppID;
			}else {
				IPAppIDArr=IPAppIDArr+"^"+IPAppID;
			}
		}	
			var CancleReasonStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
					url : ExtToolSetting.RunQueryPageURL
			}));
    
			var CancleReasonStore = new Ext.data.Store({
					proxy: CancleReasonStoreProxy,
					autoLoad:true,
					reader: new Ext.data.JsonReader({
						root: 'record',
						totalProperty: 'total',
						idProperty: 'RowId'
					}, 
				[
					{name: 'checked', mapping : 'checked'}
					,{name: 'RowId', mapping : 'RowId'}
					,{name: 'Code', mapping : 'Code'}
					,{name: 'Desc', mapping: 'Desc'} 
				])
			});

			var CancleReasonCheckCol = new Ext.grid.CheckColumn({header:'', dataIndex: 'checked', width: 100 });
	
			var CancleReason = new Ext.grid.GridPanel({
				id : 'CancleReason'
				,store : CancleReasonStore
				,region : 'center'
				,layout: 'fit'
				,autoHeight:true
				,buttonAlign : 'center'
				,loadMask : { msg : '���ڶ�ȡ����,���Ժ�...'}  
				,columns: [
					new Ext.grid.RowNumberer({header:"���"	,width:30})
					,{header: 'RowId', width: 100, dataIndex: 'RowId', sortable: true,hidden:true}
					,{header: '����', width: 100, dataIndex: 'Code', sortable: true}
					,{header: '����', width: 150, dataIndex: 'Desc', sortable: true}		
				]
			});
	
			CancleReasonStoreProxy.on('beforeload', function(objProxy, param){
				param.ClassName = 'web.DHCDocIPAppointment';
				param.QueryName = 'FindCancleReason';			
				param.Arg1 = '';
				param.Arg2 = '';
				param.ArgCnt = 2;
			});
			
			var TextField = new Ext.form.TextField({
				id : 'TextField'
				,width : 80
				,anchor : '100%'
				,fieldLabel : '��д��'
			});
			
			var TextPanel = new Ext.Panel({
				id : 'TextPanel',
				buttonAlign : 'center',
				columnWidth : .10,
				width : 200,
				bodyBorder : 'padding:0 0 0 0',
				layout : 'form',
				items : [TextField]
			});
	
			var Define = new Ext.Button({
				id : 'Define'
				,fieldLabel : ''
				//,anchor : '55%'
				//,hideLabel:true
				//,xtype: 'tbfill' 
				//,xtype : 'tbspacer'
				,width : 120
				,text : 'ȷ��'

			});		
			
			var win = new Ext.Window({
	    				width:300,
	    				collapsible:true,//�������
						height:300,
						items:[CancleReason,TextPanel,Define]
						});
			
			Define.on("click",function(){
				var winselections=CancleReason.getSelectionModel().getSelections();
				var CancleDesc=TextField.getRawValue();
				//alert("selections=="+selections.length);
				if (winselections.length == 0&& CancleDesc=="") {
					alert("����ѡ���¼!");
					return ;
				}
				
				//for (var i = 0; i < winselections.length; i++) {
				var CancleID="" 
				if (winselections.length != 0) {
					var winrecord = winselections[0]; 
					CancleID=winrecord.get("RowId");
				}
					//alert("CancleID=="+CancleID);
					Ext.Ajax.request({
						url:'DHCDocIPAppointmentdata.csp',
						params:{action:'Cancle',IPAppID:IPAppIDArr, CancleID:CancleID, CancleDesc:CancleDesc} ,
						success: function(result, request) {
							var jsonData = Ext.util.JSON.decode( result.responseText );
							if (jsonData.success!='') {
								//alert(jsonData.success)
								if (jsonData.success=="true"){
									alert("���ϳɹ�!");
									obj.btnQuery_OnClick();
								}else {
									alert("����ʧ��!�������:"+jsonData.info);
								}
							}
						},
						scope: this
					}) ;
				//}
				
				win.close();
			});
			
			win.show();
			
		//}
		
	};
	
	obj.ChangeAppInfo_OnClick = function() {
		
		var selections=obj.gridResult.getSelectionModel().getSelections();
		//alert("selections=="+selections.length);
		if (selections.length == 0) {
			alert("����ѡ���¼!");
			return ;
		}
		
		var IPAppIDArr=""
		for (var i = 0; i < selections.length; i++) { 
			var record = selections[i]; 
			var IPAppID=record.get("IPAppID");
			if (IPAppIDArr=="") {
				IPAppIDArr=IPAppID;
			}else {
				IPAppIDArr=IPAppIDArr+"^"+IPAppID;
			}
		}	
			var winCTHospitalStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
				url : ExtToolSetting.RunQueryPageURL
			}));
			var winCTHospitalStore = new Ext.data.Store({
				proxy: winCTHospitalStoreProxy,
				autoLoad : true, 
				reader: new Ext.data.JsonReader({
					root: 'record',
					totalProperty: 'total',
					idProperty: 'HosCode'
				}, 
				[
					{name: 'checked', mapping : 'checked'}
					,{name: 'HosDesc', mapping: 'HosDesc'}
					,{name: 'HosCode', mapping: 'HosCode'}
				])
			});
			
			var winCTHospital = new Ext.form.ComboBox({
				id : 'winCTHospital'
				//,selectOnFocus : true
				//,forceSelection : true
				,minChars : 1
				,displayField : 'HosDesc'
				,fieldLabel : 'ԤԼԺ��'
				,store : winCTHospitalStore
				//,mode : 'local'  //remote
				,typeAhead : true
				,triggerAction : 'all'
				,editable : true //false����ֹ�û�ֱ��������������ı������������Ӧ �ڴ�����ť�Ͻ��������Ȼ������ֵ��(Ĭ��Ϊtrue)�� 
				,anchor : '100%'
				,valueField : 'HosCode'
			});
			
			winCTHospitalStoreProxy.on('beforeload', function(objProxy, param){
					param.ClassName = 'Nur.DHCBedManager';
					param.QueryName = 'GetHospital';			
					param.Arg1 = '';
					param.ArgCnt = 1;
			});
			
			var winConditionChild5=new Ext.Panel({
				id : 'winConditionChild5'
				,buttonAlign:'center'
				,labelAligh:'center'
				,labelWidth:70
				,columnWidth : .2
				,layout:'form'
				,items:[winCTHospital]
			});
			
			var winCTLocStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
				url : ExtToolSetting.RunQueryPageURL
			}));
			var winCTLocStore = new Ext.data.Store({
				proxy: winCTLocStoreProxy,
				reader: new Ext.data.JsonReader({
					root: 'record',
					totalProperty: 'total',
					idProperty: 'CTLocID'
				}, 
				[
					{name: 'checked', mapping : 'checked'}
					,{name: 'CTLocID', mapping: 'CTLocID'}
					,{name: 'CTLocCode', mapping: 'CTLocCode'}
					,{name: 'CTLocDesc', mapping: 'CTLocDesc'}
				])
			});
			var winCTLoc = new Ext.form.ComboBox({
				id : 'winCTLoc'
				,width : 100
				,store : winCTLocStore
				,minChars : 1
				,displayField : 'CTLocDesc'
				,fieldLabel : 'ԤԼ����'
				,editable : true
				,triggerAction : 'all'		
				,anchor : '100%'
				,valueField : 'CTLocID'
			});
			winCTLocStoreProxy.on('beforeload', function(objProxy, param){
				param.ClassName = 'web.DHCDocIPAppointment';
				param.QueryName = 'QryCTLoc';
				param.Arg1 = winCTLoc.getRawValue();
				param.Arg2 = 'E';
				param.Arg3 = wincboWard.getValue();
				param.Arg4 = winCTHospital.getValue();
				param.ArgCnt = 4;
		 	});
		 	var winConditionChild1=new Ext.Panel({
				id : 'winConditionChild1'
				,buttonAlign:'center'
				,labelAligh:'center'
				,labelWidth:70
				,columnWidth : .2
				,layout:'form'
				,items:[winCTLoc]
			});
			
			var wincboWardStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
				url : ExtToolSetting.RunQueryPageURL
			}));
			var wincboWardStore = new Ext.data.Store({
				proxy: wincboWardStoreProxy,
				reader: new Ext.data.JsonReader({
					root: 'record',
					totalProperty: 'total',
				idProperty: 'CTLocID'
				}, 
				[
					{name: 'checked', mapping : 'checked'}
					,{name: 'CTLocID', mapping: 'CTLocID'}
					,{name: 'CTLocCode', mapping: 'CTLocCode'}
					,{name: 'CTLocDesc', mapping: 'CTLocDesc'}
				])
			});
			var wincboWard = new Ext.form.ComboBox({
				id : 'wincboWard'
				,width : 100
				,minChars : 1 //���Զ���ɺ�typeAhead ����֮ǰ���û���������������ַ���
				,selectOnFocus : true //true �����ڻ�ý���ʱ���ѡ�б��������д��ڵ��ı��� ����editable = true ʱӦ��(Ĭ��Ϊfalse)�� 
				,forceSelection : true //true �����޶�ѡ���ֵ���б��е�ֵ֮һ�� false���������û����������������ֵ (Ĭ��Ϊfalse) 
				,store : wincboWardStore
				,displayField : 'CTLocDesc'
				,fieldLabel : 'ԤԼ����'
				,editable : true //false����ֹ�û�ֱ��������������ı������������Ӧ �ڴ�����ť�Ͻ��������Ȼ������ֵ��(Ĭ��Ϊtrue)�� 
				,triggerAction : 'all'  //�������������ʱ��Ҫִ�еĲ�����
				,anchor : '100%'
				,valueField : 'CTLocID'
			});
			wincboWardStoreProxy.on('beforeload', function(objProxy, param){
				param.ClassName = 'web.DHCDocIPAppointment';
				param.QueryName = 'QryCTLoc';
				param.Arg1 = wincboWard.getRawValue();
				param.Arg2 = 'W';
				param.Arg3 = winCTLoc.getValue();
				param.Arg4 = winCTHospital.getValue();
				param.ArgCnt = 4;
			});
			var winConditionChild2=new Ext.Panel({
				id : 'winConditionChild2'
				,buttonAlign:'center'
				,labelAligh:'center'
				,labelWidth:70
				,columnWidth : .2
				,layout:'form'
				,items:[wincboWard]
			});
			
			var winCTDoctorStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
				url : ExtToolSetting.RunQueryPageURL
			}));
			var winCTDoctorStore = new Ext.data.Store({
				proxy: winCTDoctorStoreProxy,
				reader: new Ext.data.JsonReader({
					root: 'record',
					totalProperty: 'total',
					idProperty: 'CTPCPRowId'
				}, 
				[
					{name: 'checked', mapping : 'checked'}
					,{name: 'CTPCPRowId', mapping: 'CTPCPRowId'}
					,{name: 'CTPCPCode', mapping: 'CTPCPCode'}
					,{name: 'CTPCPDesc', mapping: 'CTPCPDesc'}
				])
			});
			
			var winCTDoctor = new Ext.form.ComboBox({
				id : 'winCTDoctor'
				//,selectOnFocus : true
				//,forceSelection : true
				,minChars : 1
				,displayField : 'CTPCPDesc'
				,fieldLabel : 'ԤԼҽ��'
				,store : winCTDoctorStore
				//,mode : 'local'  //remote
				,typeAhead : true
				,triggerAction : 'all'
				,editable : true //false����ֹ�û�ֱ��������������ı������������Ӧ �ڴ�����ť�Ͻ��������Ȼ������ֵ��(Ĭ��Ϊtrue)�� 
				,anchor : '100%'
				,valueField : 'CTPCPRowId'
			});
			winCTDoctorStoreProxy.on('beforeload', function(objProxy, param){
				param.ClassName = 'web.DHCDocIPAppointment';
				param.QueryName = 'FindCTCareProvByLoc';			
				param.Arg1 = winCTLoc.getValue();
				param.ArgCnt = 1;
			});
			var winConditionChild3=new Ext.Panel({
				id : 'winConditionChild3'
				,buttonAlign:'center'
				,labelAligh:'center'
				,labelWidth:70
				,columnWidth : .2
				,layout:'form'
				,items:[winCTDoctor]
			});
			
			winCTHospital.on('blur', function(){
				winCTLocStore.load({});
				wincboWardStore.load({});
			});
			winCTLoc.on('blur', function(){
				wincboWardStore.load({});
				winCTDoctorStore.load({});
			});
			wincboWard.on('blur', function(){
				winCTLocStore.load({});
				winCTDoctorStore.load({});
			});
			
			var Define = new Ext.Button({
				id : 'Define'
				,fieldLabel : ''
				,width : 100
				,text : 'ȷ��'
			});	
			var winConditionChild4=new Ext.Panel({
				id : 'winConditionChild4'
				,buttonAlign:'center'
				,labelAligh:'center'
				,labelWidth:70
				,columnWidth : .2
				,layout:'form'
				,items:[Define]
			});
				
			var QueryCondition = new Ext.form.FormPanel({
				id : 'QueryCondition',
				buttonAlign : 'center',
				labelAlign : 'center', 
				labelWidth : 100,
				bodyBorder : 'padding:0 0 0 0',
				layout : 'column',
				region : 'north',
				frame : true,
				height : 80,
				//,buttonAlign : 'center'  //��ӵ���ǰpanel������ buttons �Ķ��뷽ʽ��
				//,columnWidth : .60 //columnWidth ��ʾʹ�ðٷֱȵ���ʽָ���п�ȣ���width ����ʹ�þ������صķ�ʽָ���п��
				//,layout : 'form' //���ַ�ʽ
				items : [winConditionChild5,winConditionChild1, winConditionChild2, winConditionChild3,winConditionChild4]
			});
			
			var Changewin = new Ext.Window({
   				width:1100,
   				collapsible:true,//�������
				height:300,
				autoScroll:true,
				autoHeight:true,
				items : [QueryCondition]
			});
			
			Define.on("click",function(){
				var winLocId=Ext.getCmp('winCTLoc').getValue();
				var winWardId=Ext.getCmp('wincboWard').getValue();
				var winDocId=Ext.getCmp('winCTDoctor').getValue();
				//alert("IPAppIDArr=="+IPAppIDArr);
				Ext.Ajax.request({
					url:'DHCDocIPAppointmentdata.csp',
					params:{action:'ChangeAppInfo',IPAppID:IPAppIDArr, LocId:winLocId, WardId:winWardId, DocId:winDocId},
					success: function(result, request) { 
						var jsonData = Ext.util.JSON.decode( result.responseText );
						if (jsonData.success!='') {
							//alert(jsonData.success)
							if (jsonData.success=="true"){
								alert("����ɹ�!");
								obj.btnQuery_OnClick();
							}else {
								var ErrCode=jsonData.info
								alert("����ʧ��!�������:"+ErrCode);
							}
						}
						Changewin.close();
					},
					scope: this
				});
			});
			Changewin.show();
			
		//}
	}
	
	obj.btnCancleAllocate_OnClick = function() {
		
		var selections=obj.gridResult.getSelectionModel().getSelections();
		//alert("selections=="+selections.length);
		if (selections.length == 0) {
			alert("����ѡ���˼�¼!");
			return ;
		}
		
		var IPAppIDArr="";
		for (var i = 0; i < selections.length; i++) { 
			var record = selections[i]; 
			var IPAppID=record.get("IPAppID");
			if (IPAppIDArr=="") {
				IPAppIDArr=IPAppID;
			}else {
				IPAppIDArr=IPAppIDArr+"^"+IPAppID;
			}
		}
			Ext.Ajax.request({
				url:'DHCDocIPAppointmentdata.csp',
				params:{action:'CancleAllocate',IPAppID:IPAppIDArr} ,
				success: function(result, request) {
					var jsonData = Ext.util.JSON.decode( result.responseText );
					//alert(jsonData.success)
					if (jsonData.success!='') {	
						if (jsonData.success=="true"){
							alert("ȡ������ɹ�!");
							obj.btnQuery_OnClick();
						}else {
							alert("ȡ������ʧ��!�������:"+jsonData.info);
						}
					}
				},
				scope: this
			}) ;
		//}
	}
	
	obj.btnReCancle_OnClick = function() {
		var selections=obj.gridResult.getSelectionModel().getSelections();
		//alert("selections=="+selections.length);
		if (selections.length == 0) {
			alert("����ѡ���˼�¼!");
			return ;
		}
		var IPAppIDArr="";
		for (var i = 0; i < selections.length; i++) { 
			var record = selections[i]; 
			var IPAppID=record.get("IPAppID");
			if (IPAppIDArr=="") {
				IPAppIDArr=IPAppID;
			}else {
				IPAppIDArr=IPAppIDArr+"^"+IPAppID;
			}
		}
			Ext.Ajax.request({
				url:'DHCDocIPAppointmentdata.csp',
				params:{action:'ReCancle',IPAppID:IPAppIDArr} ,
				success: function(result, request) {
					var jsonData = Ext.util.JSON.decode( result.responseText );
					//alert(jsonData.success)
					if (jsonData.success!='') {	
						if (jsonData.success=="true"){
							alert("ȡ�����ϳɹ�!");
							obj.btnQuery_OnClick();
						}else {
							alert("ȡ������ʧ��!�������:"+jsonData.info);
						}
					}
				},
				scope: this
			}) ;
		//}
	}
	
	obj.btnHang_OnClick = function() {
		var selections=obj.gridResult.getSelectionModel().getSelections();
		//alert("selections=="+selections.length);
		if (selections.length == 0) {
			alert("����ѡ���˼�¼!");
			return ;
		}
		
		var IPAppIDArr="";
		for (var i = 0; i < selections.length; i++) { 
			var record = selections[i]; 
			var IPAppID=record.get("IPAppID");
			if (IPAppIDArr=="") {
				IPAppIDArr=IPAppID;
			}else {
				IPAppIDArr=IPAppIDArr+"^"+IPAppID;
			}
		}
			Ext.Ajax.request({
				url:'DHCDocIPAppointmentdata.csp',
				params:{action:'Hang',IPAppID:IPAppIDArr} ,
				success: function(result, request) {
					var jsonData = Ext.util.JSON.decode( result.responseText );
					//alert(jsonData.success)
					if (jsonData.success!='') {	
						if (jsonData.success=="true"){
							alert("����ɹ�!");
							obj.btnQuery_OnClick();
						}else {
							alert("����ʧ��!�������:"+jsonData.info);
						}
					}
				},
				scope: this
			}) ;
		//}
	}
	
	obj.btnCancleHang_OnClick = function() {
		
		var selections=obj.gridResult.getSelectionModel().getSelections();
		//alert("selections=="+selections.length);
		if (selections.length == 0) {
			alert("����ѡ���˼�¼!");
			return ;
		}
		
		var IPAppIDArr="";
		for (var i = 0; i < selections.length; i++) { 
			var record = selections[i]; 
			var IPAppID=record.get("IPAppID");
			if (IPAppIDArr=="") {
				IPAppIDArr=IPAppID;
			}else {
				IPAppIDArr=IPAppIDArr+"^"+IPAppID;
			}
		}
			Ext.Ajax.request({
				url:'DHCDocIPAppointmentdata.csp',
				params:{action:'CancleHang',IPAppID:IPAppIDArr} ,
				success: function(result, request) {
					var jsonData = Ext.util.JSON.decode( result.responseText );
					//alert(jsonData.success)
					if (jsonData.success!='') {	
						if (jsonData.success=="true"){
							alert("ȡ������ɹ�!");
							obj.btnQuery_OnClick();
						}else {
							alert("ȡ������ʧ��!�������:"+jsonData.info);
						}
					}
				},
				scope: this
			}) ;
		//}
		
	}
	
	/*
	obj.btnExport_OnClick = function() {
		if (obj.RstGridPanel.store.data.length < 1) {
			ExtTool.alert("ȷ��", "�޼�¼,��������!");
			return;
		}
		var strFileName = ProjectDesc + "����";
		var objExcelTool = Ext.dhcc.DataToExcelTool;
		objExcelTool.ExprotGrid(obj.RstGridPanel, strFileName);
	};
	
	obj.btnQuery_click = function() {
		obj.GridStore.removeAll();
		obj.GridStore.reader = new Ext.data.JsonReader({
			root : 'record',
			totalProperty : 'total'
				,idProperty: 'ReportID'
			}, obj.storeFields)
		obj.GridStore.load({});
		obj.GridColumns = new Ext.grid.ColumnModel(obj.gridColumn);
		//obj.GridColumns.rows = obj.GridColumnHeaderGroup.config.rows;
		obj.RstGridPanel.reconfigure(obj.GridStore, obj.GridColumns);
	}; */
	
}
