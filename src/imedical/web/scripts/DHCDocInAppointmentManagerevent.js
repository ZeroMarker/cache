function InitviewScreenEvent(obj){

	obj.LoadEvent = function(args) {
		obj.CTLoc.on("expand", obj.CTLoc_OnExpand, obj);
		obj.cboWard.on("expand", obj.cboWard_OnExpand, obj);
		obj.CTDoctor.on("expand", obj.CTDoctor_OnExpand, obj);
		//obj.ResultGridPanel.on("rowclick", obj.ResultGridPanel_OnRowClick, obj);
		//obj.btnExport.on("click", obj.btnExport_OnClick, obj);
		obj.findButton.on("click", obj.find_onclick, obj);
		obj.CancleButton.on("click", obj.btnCancle_OnClick, obj);
		obj.CancleallotButton.on("click", obj.btnCancleAllocate_OnClick, obj);
		obj.allotButton.on("click", obj.btnAllocate_OnClick, obj);
		Ext.get('paadmInNo').on("keydown",obj.paadmInNo_OnKeydown, obj);
		Ext.get('papminame').on("keydown",obj.papminame_OnKeydown, obj);
		Ext.get('paadmNo').on("keydown",obj.paadmNo_OnKeydown, obj);
		//obj.gridResultStore.load({params : {start : 0,limit : 100}});
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
	obj.paadmInNo_OnKeydown = function(e) {
		keycode=websys_getKey(e);
		if ((keycode==13)||(keycode==9)){
			obj.find_onclick();
		}
	}
	obj.papminame_OnKeydown = function(e) {	
		keycode=websys_getKey(e);
		if ((keycode==13)||(keycode==9)){
			obj.find_onclick();
		}
	}
	
	obj.paadmNo_OnKeydown = function(e) {
		keycode=websys_getKey(e);
		if ((keycode==13)||(keycode==9)){
			//alert("nk")
			obj.find_onclick();
		}
	}
	obj.find_onclick = function(){  	
		var PAPMINO = obj.paadmNo.getValue();
		var IfAllocate = "";		
		if ((PAPMINO!="")&&(PAPMINO.length<10)) {
			for (var i=(10-PAPMINO.length-1); i>=0; i--) {
				PAPMINO="0"+PAPMINO;
			}
		}	
		Ext.getCmp('paadmNo').setValue(PAPMINO);
		for (var i = 0; i < obj.noBedInPaadm.items.length; i++) {   
			if (obj.noBedInPaadm.items.itemAt(i).checked) {
				if (obj.noBedInPaadm.items.itemAt(i).name=="noBed"){IfAllocate="Al";}
			}    
		}
		var sex=Ext.getCmp('AccompanySex').getValue();
		if(sex==0){
			sex=""
		}
		Ext.getCmp('noBedInPaadm').setValue(IfAllocate);
		obj.AppPatientStoreProxy.on('beforeload', function(objProxy, param){ 
			param.ClassName = 'web.DHCDocIPAppointment';
			param.QueryName = 'GetIPAppPatientList';
			param.Arg1 = obj.paadmInNo.getValue();
			param.Arg2 = obj.paadmNo.getValue();
			param.Arg3 = obj.papminame.getValue();
			param.Arg4 = obj.startDate.getRawValue();
			param.Arg5 = obj.endDate.getRawValue();
			param.Arg6 = "";
			param.Arg7 = Ext.getCmp('cboWard').getValue();
			param.Arg8 = Ext.getCmp('CTLoc').getValue();
			param.Arg9 =  Ext.getCmp('CTDoctor').getValue();
			param.Arg10 = IfAllocate;
			param.Arg11 = Ext.getCmp('SortMethod').getValue();
			param.Arg12 =  "";
			param.Arg13 = sex;
			param.Arg14= 1;
			param.ArgCnt = 13; 
    });
    obj.AppPatientStore.load({params : {start : 0,limit : 100}});	
	};
	obj.AppPatient.on("rowclick",function(grid, rowIndex, e){  //当一行被点击时触发
			//var selections=grid.getSelectionModel().getSelections();  //返回所有选中的记录 
			
			Ext.getCmp("bedcboWard").setValue();
			Ext.getCmp("bedcboWard").setRawValue();
			//alert(Ext.getCmp("bedcboWard").getRawValue())
			//alert("kkk")
			CheckRowClick();
		});
		
	function CheckRowClick() {	
		var selections=obj.AppPatient.getSelectionModel().getSelections();
			//alert("selections=="+selections.length);
		if (selections.length == 0) {
			//alert("请先选择病人记录!");
			return ;
		}	
		//alert("rowIndex=="+rowIndex);
			
		for (var i = 0; i < selections.length; i++) { 
			var record = selections[i]; 
			var IPAppID=record.get("IPAppID");
			var AppLocID=record.get("AppLocID");
			var BedNoDr=record.get("BedNoDr");
			//alert(AppLocID)	
			var ConDate=Ext.getCmp("ConditionDate").getRawValue();
			var WardId=Ext.getCmp("bedcboWard").getRawValue();
			//alert("ConDate=="+ConDate);
				
			Ext.Ajax.request({
				url:'DHCDocIPAppointmentdata.csp',
				params:{action:'GetBedList',IPAppID:IPAppID,BedNoDr:BedNoDr,ConDate:ConDate,WardId:WardId} ,
				success: function(result, request) {
					var jsonData = Ext.util.JSON.decode( result.responseText );
					//alert(jsonData.BedList)
					if (jsonData.BedList!='') {	
						//空床列表store填充
						obj.AppBedStore.removeAll();
						var BedListArr=jsonData.BedList.split("!");
					
						for (var i=0;i<BedListArr.length;i++) {
							//BedId,BedCode,BedStatus,BedBill,PatName,PatSex,PatAge,Note,BedChild,BedOwn,EpisodeID,PatWardID,WardDesc
							//BedId,BedCode,BedStatus,BedBill,PatName,PatSex,PatAge,BedOwn,RegNo,EpisodeID,IPDate,Patward,WardID
							var BedRowId = BedListArr[i].split("^")[0];
							var BedNo = BedListArr[i].split("^")[1];
							var BedState = BedListArr[i].split("^")[2];
							var BedWard = BedListArr[i].split("^")[8];
							var BedSex = BedListArr[i].split("^")[5];
							var BedBill = BedListArr[i].split("^")[3];
								
							var record = new Object();
							record.BedRowId = BedRowId ;
							record.BedNo = BedNo ;
							record.BedState = BedState ;
							record.BedWard = BedWard ;
							record.BedSex = BedSex ;
							record.BedBill = BedBill ;
							var records = new Ext.data.Record(record);
					
							obj.AppBedStore.add(records);
						}
					}
				},
				scope: this
			}) ;
			Ext.Ajax.request({
				url:'DHCDocIPAppointmentdata.csp',
				params:{action:'GetPatientInfo',IPAppID:IPAppID} ,
				success: function(result, request) {
					var jsonData = Ext.util.JSON.decode( result.responseText );
					obj.paInfoStore.removeAll();
					//alert(jsonData.PatientList)
					if (jsonData.PatientList!='') {	
						//病人详细信息列表store填充
						var PatientInfo=jsonData.PatientList
						var PatientInfoStr=PatientInfo.split("^");
						var MedicalNo = PatientInfoStr[0];
						var PatientName = PatientInfoStr[1];
						var PatientInNo = PatientInfoStr[2];
						var PatientAdmNo = PatientInfoStr[3];
						var PatientSex = PatientInfoStr[4];
						var PatientType= PatientInfoStr[5]; 
						var PatientLoc = PatientInfoStr[6];
						var PatientWard = PatientInfoStr[7];
						var RegisterDate = PatientInfoStr[8];
						var AppDate = PatientInfoStr[9];
						var AdmissionDate = PatientInfoStr[10];
						var PatientBed = PatientInfoStr[11];
						var PatientState = PatientInfoStr[12];
						//var AdmissionEvid = PatientInfoStr[13]
						var PatAddress = PatientInfoStr[14];
						var PatMobPhone = PatientInfoStr[15];
						var TelH = PatientInfoStr[16];
						var AllocateDate = PatientInfoStr[17];
						var AccompanySex = PatientInfoStr[18];
						var PatAge = PatientInfoStr[19];
						var myInfoEnterUser = PatientInfoStr[20];
						var myBedDistributeUser = PatientInfoStr[21];
						var myInfoCancelUser = PatientInfoStr[22];
						var record = new Object();
		  	     		record.MedicalNo = MedicalNo ;
		  	     		record.PatientName = PatientName ;
		  	     		record.PatientInNo = PatientInNo ;
		  	     		record.PatientAdmNo = PatientAdmNo ;
		  	     		record.PatientSex = PatientSex ;
		  	     		record.PatientType = PatientType ;
		  	     		record.PatientLoc = PatientLoc ;
		  	     		record.PatientWard = PatientWard ;
		  	     		record.RegisterDate = RegisterDate ;
		  	     		record.AppDate = AppDate ;
		  	     		record.AdmissionDate = AdmissionDate ;
		  	     		record.PatientBed = PatientBed ;
		  	     		record.PatientState = PatientState ;
		  	     		//record.AdmissionEvid = AdmissionEvid ;
		  	     		record.PatAddress = PatAddress ;
		  	     		record.PatMobPhone = PatMobPhone;
		  	     		record.TelH = TelH;
		  	     		record.AllocateDate = AllocateDate;
		  	     		record.AccompanySex = AccompanySex;
		  	     		record.PatAge = PatAge;
		  	     		record.myInfoEnterUser = myInfoEnterUser;
		  	     		record.myBedDistributeUser = myBedDistributeUser;
		  	     		record.myInfoCancelUser = myInfoCancelUser;
		  	     		var records = new Ext.data.Record(record);
		       		
					
						obj.paInfoStore.add(records);
						
					}
				},
				scope: this
			}) ;
		}
	};
	
	obj.btnCancle_OnClick = function(){
		
		var selections=obj.AppPatient.getSelectionModel().getSelections();
		//alert("selections=="+selections.length);
		if (selections.length == 0) {
			alert("请先选择病人记录!");
			return ;
		}
		
		for (var i = 0; i < selections.length; i++) { 
			var record = selections[i]; 
			var IPAppID=record.get("IPAppID");
			//CancleID
			var CancleID="";
			
			obj.CancleReasonStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
					url : ExtToolSetting.RunQueryPageURL
			}));
	
			obj.CancleReasonStore = new Ext.data.Store({
					proxy: obj.CancleReasonStoreProxy,
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

			obj.CancleReasonCheckCol = new Ext.grid.CheckColumn({header:'', dataIndex: 'checked', width: 100 });
	
			obj.CancleReason = new Ext.grid.GridPanel({
				id : 'CancleReason'
				,store : obj.CancleReasonStore
				,region : 'center'
				,layout: 'fit'
				,autoHeight:true
				,buttonAlign : 'center'
				,loadMask : { msg : '正在读取数据,请稍后...'}  
				,columns: [
					new Ext.grid.RowNumberer({header:"序号"	,width:20})
					,{header: 'RowId', width: 100, dataIndex: 'RowId', sortable: true,hidden:true}
					,{header: '代码', width: 100, dataIndex: 'Code', sortable: true}
					,{header: '描述', width: 150, dataIndex: 'Desc', sortable: true}		
				]
			});
	
			obj.CancleReasonStoreProxy.on('beforeload', function(objProxy, param){
				param.ClassName = 'web.DHCDocIPAppointment';
				param.QueryName = 'FindCancleReason';			
				param.Arg1 = '';
				param.Arg2 = '';
				param.ArgCnt = 2;
			});
			
			obj.TextField = new Ext.form.TextField({
				id : 'TextField'
				,width : 80
				,anchor : '100%'
				,fieldLabel : '填写框'
			});
			
			obj.TextPanel = new Ext.Panel({
				id : 'TextPanel',
				buttonAlign : 'center',
				columnWidth : .10,
				width : 200,
				bodyBorder : 'padding:0 0 0 0',
				layout : 'form',
				items : [obj.TextField]
			});
	
			obj.Define = new Ext.Button({
				id : 'Define'
				,fieldLabel : ''
				//,anchor : '55%'
				//,hideLabel:true
				//,xtype: 'tbfill' 
				//,xtype : 'tbspacer'
				,width : 120
				,text : '确定'

			});		
			
			obj.win = new Ext.Window({
						width:300,
						collapsible:true,//面板伸缩
						height:300,
						items:[obj.CancleReason,obj.TextPanel,obj.Define]
						});
			//alert("IPAppID="+IPAppID)
			obj.Define.on("click",function(){
				var winselections=obj.CancleReason.getSelectionModel().getSelections();
				var CancleDesc=obj.TextField.getRawValue();
				//alert("selections=="+selections.length);
				if (winselections.length == 0&& CancleDesc=="") {
					alert("请先选择记录!");
					return ;
				}
				
				//for (obj.i = 0; i < selections.length; i++) { 
				var CancleID="" 
				if (winselections.length != 0) {
					var winrecord = winselections[0]; 
					var CancleID=winrecord.get("RowId");
					//alert("CancleID=="+CancleID);
				}
				Ext.Ajax.request({
					url:'DHCDocIPAppointmentdata.csp',
					params:{action:'Cancle',IPAppID:IPAppID, CancleID:CancleID, CancleDesc:CancleDesc} ,
					success: function(result, request) {
						var jsonData = Ext.util.JSON.decode( result.responseText );
						if (jsonData.success!='') {
						//alert(jsonData.success)
							if (jsonData.success=="true"){
								alert("作废成功!");
								obj.find_onclick();
							}else {
								alert("作废失败!错误代码:"+jsonData.info);
							}
						}
					},
					scope: this
				}) ;
				obj.win.close();
			});	
		obj.win.show();	
		}
	};
		
	obj.btnAllocate_OnClick=function(){
		var selections=obj.AppPatient.getSelectionModel().getSelections();
		//alert("selections=="+selections.length);
		if (selections.length == 0) {
			alert("请先选择病人记录!");
			return ;
		}
			
		var BedSelections=obj.AppBed.getSelectionModel().getSelections();
		if (BedSelections.length == 0) {
			alert("请先选择空床!");
			return ;
		}
			
		var OneDayFlag=1;
		var ret=confirm("病人是否长期住院?");
		if (ret) {OneDayFlag=0;}
		//alert("OneDayFlag=="+OneDayFlag);
		
		var BedRecord = BedSelections[0];
		var BedID=BedRecord.get("BedRowId");
			
		for (var i = 0; i < selections.length; i++) { 
			var record = selections[i]; 
			var IPAppID=record.get("IPAppID");
			var AppDate=obj.ConditionDate.getRawValue();
			//BedID
			//obj.BedID="";
			//alert("IPAppID=="+IPAppID+"  BedID=="+BedID);
			Ext.Ajax.request({
				url:'DHCDocIPAppointmentdata.csp',
				params:{action:'Allocate',IPAppID:IPAppID, BedID:BedID,AppDate:AppDate,OneDayFlag:OneDayFlag} ,
				success: function(result, request) {
					var jsonData = Ext.util.JSON.decode( result.responseText );
						//alert(jsonData.success)
					if (jsonData.success!='') {	
						if (jsonData.success=="true"){
							alert("分配成功!");
							obj.find_onclick();
						}else {
							if (jsonData.info=="-300") {
								alert("预约日期不能小于当前日期!");
							}else if (jsonData.info=="-300") {
								alert("该床位已经预约!");
							}
							else {
								alert("分配失败!错误代码:"+jsonData.info);
							}
						}
					}
				},
			scope: this
			}) ;
		}
	};
			
			
	obj.btnCancleAllocate_OnClick=function(){
		var selections=obj.AppPatient.getSelectionModel().getSelections();
		//alert("selections=="+selections.length);
		if (selections.length == 0) {
			alert("请先选择病人记录!");
			return ;
		}
			
		for (var i = 0; i < selections.length; i++) { 
			var record = selections[i]; 
			var IPAppID=record.get("IPAppID");
			Ext.Ajax.request({
				url:'DHCDocIPAppointmentdata.csp',
				params:{action:'CancleAllocate',IPAppID:IPAppID} ,
				success: function(result, request) {
					var jsonData = Ext.util.JSON.decode( result.responseText );
					//alert(jsonData.success)
					if (jsonData.success!='') {	
						if (jsonData.success=="true"){
							alert("取消分配成功!");
							obj.find_onclick();
						}else {
							alert("取消分配失败!错误代码:"+jsonData.info);
						}
					}
				},
				scope: this
			}) ;
		}
			
	};

		Ext.get('Tomorrow').on("click", function(){
			if (Ext.getCmp('Tomorrow').getValue()) {
				Ext.getCmp('AfterTomorrow').setValue(false);
				Ext.getCmp('DHT').setValue(false);
			}
			Ext.getCmp('ConditionDate').setValue(new Date().add(Date.DAY, +1));
			CheckRowClick();
			//alert("nk")
		});
		Ext.get('AfterTomorrow').on("click", function(){
			if (Ext.getCmp('AfterTomorrow').getValue()) {
				Ext.getCmp('Tomorrow').setValue(false);
				Ext.getCmp('DHT').setValue(false);
				Ext.getCmp('ConditionDate').setValue(new Date().add(Date.DAY, +2));
			}else {
				Ext.getCmp('ConditionDate').setValue(new Date().add(Date.DAY, +1));
			}
			CheckRowClick();
		});
		Ext.get('DHT').on("click", function(){
			if (Ext.getCmp('DHT').getValue()) {
				Ext.getCmp('AfterTomorrow').setValue(false);
				Ext.getCmp('Tomorrow').setValue(false);
				Ext.getCmp('ConditionDate').setValue(new Date().add(Date.DAY, +3));
			}else {
				Ext.getCmp('ConditionDate').setValue(new Date().add(Date.DAY, +1));
			}	
			CheckRowClick();	
		});
		Ext.get('ConditionDate').on("focus", function(){
			CheckRowClick();
		});
		Ext.get('bedcboWard').on("focus", function(){
		CheckRowClick();
		});
		
}
