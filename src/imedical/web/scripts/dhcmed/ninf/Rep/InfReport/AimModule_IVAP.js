	
function InitIVAP(obj)
{
	//上机时间
	obj.IVAP_txtIntubateDateTime = Common_DateFieldToDateTime("IVAP_txtIntubateDateTime","上机时间");
	
	//脱机时间
	obj.IVAP_txtExtubateDateTime = Common_DateFieldToDateTime("IVAP_txtExtubateDateTime","脱机时间");
	
	//置管地点
	obj.IVAP_cboIntubatePlace = Common_ComboToDic("IVAP_cboIntubatePlace","置管地点","NINFICUIntubatePlace");
	
	//气道类型
	obj.IVAP_cboVAPIntubateType = Common_ComboToDic("IVAP_cboVAPIntubateType","气道类型","NINFICUVAPIntubateType");
	
	//置管人员类型
	obj.IVAP_cboIntubateUserType = Common_ComboToDic("IVAP_cboIntubateUserType","置管人员","NINFICUIntubateUserType");
	
	//置管人员
	obj.IVAP_cboIntubateUser = Common_ComboToSSUser("IVAP_cboIntubateUser","置管人员");
	
	//是否感染
	obj.IVAP_chkIsInf = Common_Checkbox("IVAP_chkIsInf","是否感染");
	obj.IVAP_chkIsInf.on('check',function(checkbox,value){
		var objItem1 = Ext.getCmp("IVAP_txtInfDate");
		if (objItem1) {
			objItem1.setDisabled((!value));
		}
		var objItem1 = Ext.getCmp("IVAP_cboInfPy");
		if (objItem1) {
			objItem1.setDisabled((!value));
		}
		if (!value) {
			Common_SetValue('IVAP_txtInfDate','');
			Common_SetValue('IVAP_cboInfPy','','');
		}
	},obj.IVAP_chkIsInf);
	
	//感染日期
	obj.IVAP_txtInfDate = Common_DateFieldToDate("IVAP_txtInfDate","感染日期");
	
	//病原体
	obj.IVAP_cboInfPy = Common_ComboToPathogeny("IVAP_cboInfPy","病原体");

	//行编辑
	obj.IVAP_GridRowViewPort = {
		layout : 'form',
		labelAlign : 'right',
		labelWidth : 60,
		frame : true,
		items : [
			obj.IVAP_cboVAPIntubateType
			,obj.IVAP_txtIntubateDateTime
			,obj.IVAP_txtExtubateDateTime
			,obj.IVAP_cboIntubateUserType
			,obj.IVAP_cboIntubatePlace
			,obj.IVAP_chkIsInf
			,obj.IVAP_txtInfDate
		]
	}
	
	obj.IVAP_GridRowDataCheck = function(objRec){
		var errInfo = '';
		
		if (objRec) {
			var IVAP_txtIntubateDateTime = objRec.get('IntubateDateTime');
			if (IVAP_txtIntubateDateTime=='') {
				errInfo = errInfo + '上机时间未填!';
			}
			var IVAP_cboIntubatePlace = objRec.get('IntubatePlaceDesc');
			if (IVAP_cboIntubatePlace=='') {
				errInfo = errInfo + '置管地点未填!';
			}
			var IVAP_cboVAPIntubateType = objRec.get('VAPIntubateTypeDesc');
			if (IVAP_cboVAPIntubateType=='') {
				errInfo = errInfo + '气道类型未填!';
			}
			var IVAP_cboIntubateUserType = objRec.get('IntubateUserTypeDesc');
			if (IVAP_cboIntubateUserType=='') {
				errInfo = errInfo + '置管人员未填!';
			}
			var IVAP_cboIntubateUser = objRec.get('IntubateUserDesc');
			if (IVAP_cboIntubateUser=='') {
				//errInfo = errInfo + '置管人员未填!';
			}
			var IVAP_txtExtubateDateTime = objRec.get('ExtubateDateTime');
			if (IVAP_txtExtubateDateTime=='') {
				//errInfo = errInfo + '脱机时间未填!';
			}
			var IVAP_txtInfDate = Common_GetValue('InfDate');
		} else {
			var IVAP_txtIntubateDateTime = Common_GetValue('IVAP_txtIntubateDateTime');
			if (IVAP_txtIntubateDateTime=='') {
				errInfo = errInfo + '上机时间未填!';
			}
			var IVAP_cboIntubatePlace = Common_GetValue('IVAP_cboIntubatePlace');
			if (IVAP_cboIntubatePlace=='') {
				errInfo = errInfo + '置管地点未填!';
			}
			var IVAP_cboVAPIntubateType = Common_GetValue('IVAP_cboVAPIntubateType');
			if (IVAP_cboVAPIntubateType=='') {
				errInfo = errInfo + '气道类型未填!';
			}
			var IVAP_cboIntubateUserType = Common_GetValue('IVAP_cboIntubateUserType');
			if (IVAP_cboIntubateUserType=='') {
				errInfo = errInfo + '置管人员未填!';
			}
			var IVAP_cboIntubateUser = Common_GetValue('IVAP_cboIntubateUser');
			if (IVAP_cboIntubateUser=='') {
				//errInfo = errInfo + '置管人员未填!';
			}
			var IVAP_txtExtubateDateTime = Common_GetValue('IVAP_txtExtubateDateTime');
			if (IVAP_txtExtubateDateTime=='') {
				//errInfo = errInfo + '脱机时间未填!';
			}
			var IVAP_txtInfDate = Common_GetValue('IVAP_txtInfDate');
		}
		/*
		var today = new Date();
		//getYear()获取当前年份(2位),getFullYear()获取完整的年份(4位,1970-????)
		var CurrDate = today.getFullYear() + "-" + (today.getMonth() + 1) + "-" + today.getDate();
		if (IVAP_txtIntubateDateTime != '') {
			var IntubateDate = IVAP_txtIntubateDateTime.split(" ")[0];
			var IntubateTime = IVAP_txtIntubateDateTime.split(" ")[1];
			//var flg = Common_CompareDate(IntubateDate,CurrDate);
			//if (!flg) errInfo = errInfo + '上机日期大于当前日期!<br>'
			
			var objPaadm = obj.CurrPaadm;
			var flg = Common_CompareDate(objPaadm.AdmitDate,IntubateDate);
			if (!flg) errInfo = errInfo + '上机日期小于入院日期!<br>'
			if ((objPaadm.AdmitDate==IntubateDate)&&(objPaadm.AdmitTime>IntubateTime))
				errInfo = errInfo + '上机时间小于入院时间!<br>'
				
			if (objPaadm.DisDate) {
				var flg = Common_CompareDate(IntubateDate,objPaadm.DisDate);
				if (!flg) errInfo = errInfo + '上机日期大于出院日期!<br>'
				if ((objPaadm.DisDate==IntubateDate)&&(objPaadm.DisTime<IntubateTime))
					errInfo = errInfo + '上机时间大于出院时间!<br>'
			}
			
			var InfDate = IVAP_txtInfDate;
			if (InfDate) {
				var flg = Common_CompareDate(IntubateDate,InfDate);
				if (!flg) errInfo = errInfo + '上机日期大于感染日期!<br>'
			}
			
			if (IVAP_txtExtubateDateTime != '') {
				var ExtubateDate = IVAP_txtExtubateDateTime.split(" ")[0];
				var ExtubateTime = IVAP_txtExtubateDateTime.split(" ")[1];
				var flg = Common_CompareDate(IntubateDate,ExtubateDate);
				if (!flg) errInfo = errInfo + '脱机日期大于上机日期!<br>'
				
				var flg = Common_CompareDate(ExtubateDate,CurrDate);
				if (!flg) errInfo = errInfo + '脱机日期大于当前日期!<br>'
				
				var flg = Common_CompareDate(objPaadm.AdmitDate,ExtubateDate);
				if (!flg) errInfo = errInfo + '脱机日期小于入院日期!<br>'
				if ((objPaadm.AdmitDate==ExtubateDate)&&(objPaadm.AdmitTime>ExtubateTime))
					errInfo = errInfo + '脱机时间小于入院时间!<br>'
					
				if (objPaadm.DisDate) {
					var flg = Common_CompareDate(ExtubateDate,objPaadm.DisDate);
					if (!flg) errInfo = errInfo + '脱机日期大于出院日期!<br>'
					if ((objPaadm.DisDate==ExtubateDate)&&(objPaadm.DisTime<ExtubateTime))
						errInfo = errInfo + '脱机时间大于出院时间!<br>'
				}
			}
			//update by likai for bug:2142 拔管时间为空，感染日期可以大于当前日期
			var InfDate = IVAP_txtInfDate;
			if ((InfDate)&&(IVAP_txtExtubateDateTime != '')) {
				var flg = Common_CompareDate(InfDate,ExtubateDate);
				if (!flg) errInfo = errInfo + '感染日期大于脱机日期!<br>'
				}
			if (InfDate) {
				var flg = Common_CompareDate(InfDate,CurrDate);
				if (!flg) errInfo = errInfo + '感染日期大于当前日期!<br>'
				}
		}*/
		var objPaadm = obj.CurrPaadm;
		var dt1 = Common_DateParse(objPaadm.AdmitDate); //转换为数字
		var dt2 = Common_DateParse(objPaadm.DisDate);
		if (IVAP_txtIntubateDateTime != '') {
			var IntubateDate = Common_DateParse(IVAP_txtIntubateDateTime.split(" ")[0]);
			//var IntubateTime = IVAP_txtIntubateDateTime.split(" ")[1];
			
			var dt3 = Common_DateParse(IVAP_txtIntubateDateTime);
			if (dt3<dt1) errInfo = errInfo + '上机日期小于入院日期!<br>'
			if ((objPaadm.DisDate!="")&&(dt3>dt2)) errInfo = errInfo + '上机日期大于出院日期!<br>'		
									
			if (IVAP_txtInfDate) {
				var InfDate = Common_DateParse(IVAP_txtInfDate);
				if (IntubateDate>InfDate) errInfo = errInfo + '上机日期大于感染日期!<br>'
			}
			
			if (IVAP_txtExtubateDateTime != '') {
				var ExtubateDate = Common_DateParse(IVAP_txtExtubateDateTime.split(" ")[0]);
				//var ExtubateTime = IVAP_txtExtubateDateTime.split(" ")[1];
				var dt4 = Common_DateParse(IVAP_txtExtubateDateTime);
				if (dt4<dt1) errInfo = errInfo + '脱机日期小于入院日期!<br>'
				if (dt4<dt3) errInfo = errInfo + '脱机日期小于上机日期!<br>'
				if ((objPaadm.DisDate!="")&&(dt4>dt2)) errInfo = errInfo + '脱机日期大于出院日期!<br>'
				
				if (Common_ComputeDays("IVAP_txtExtubateDateTime")<0) errInfo = errInfo + '脱机日期大于当前日期!<br>'
								
				if (IVAP_txtInfDate) {
					var InfDate = Common_DateParse(IVAP_txtInfDate);
					if (InfDate>ExtubateDate) errInfo = errInfo + '感染日期大于脱机日期!<br>'
					if (Common_ComputeDays("IVAP_txtInfDate")<0) errInfo = errInfo + '感染日期大于当前日期!<br>'
				}							
			}
		}
		
		return errInfo;
	}
	
	obj.IVAP_GridRowDataSave = function(objRec){
		var IntubateDateTime = Common_GetValue('IVAP_txtIntubateDateTime');
		var arrDateTime = IntubateDateTime.split(' ');
		if (arrDateTime.length>1){
			var IntubateDate = arrDateTime[0];
			var IntubateTime = arrDateTime[1];
		} else {
			var IntubateDate = '';
			var IntubateTime = '';
		}
		var ExtubateDateTime = Common_GetValue('IVAP_txtExtubateDateTime');
		var arrDateTime = ExtubateDateTime.split(' ');
		if (arrDateTime.length>1){
			var ExtubateDate = arrDateTime[0];
			var ExtubateTime = arrDateTime[1];
		} else {
			var ExtubateDate = '';
			var ExtubateTime = '';
		}
		var IntubatePlaceID = Common_GetValue('IVAP_cboIntubatePlace');
		var IntubatePlaceDesc = Common_GetText('IVAP_cboIntubatePlace');
		var IntubateUserTypeID = Common_GetValue('IVAP_cboIntubateUserType');
		var IntubateUserTypeDesc = Common_GetText('IVAP_cboIntubateUserType');
		var IntubateUserID = Common_GetValue('IVAP_cboIntubateUser');
		var IntubateUserDesc = Common_GetText('IVAP_cboIntubateUser');
		var InfDate = Common_GetValue('IVAP_txtInfDate');
		var IsInfection = (InfDate != '' ? '是' : '否');
		var InfPyID = Common_GetValue('IVAP_cboInfPy');
		var InfPyDesc = Common_GetText('IVAP_cboInfPy');
		var InfPyValue = InfPyID + CHR_2 + InfPyDesc;
		var VAPIntubateTypeID = Common_GetValue('IVAP_cboVAPIntubateType');
		var VAPIntubateTypeDesc = Common_GetText('IVAP_cboVAPIntubateType');
		
		if (objRec) {      //提交数据
			objRec.set('IndRec',objRec.get('IndRec'));
			objRec.set('RepID',objRec.get('RepID'));
			objRec.set('SubID',objRec.get('SubID'));
			objRec.set('IsChecked','1');
			objRec.set('DataSource',objRec.get('DataSource'));
			
			objRec.set('IntubateDate',IntubateDate);
			objRec.set('IntubateTime',IntubateTime);
			objRec.set('IntubateDateTime',IntubateDateTime);
			objRec.set('ExtubateDate',ExtubateDate);
			objRec.set('ExtubateTime',ExtubateTime);
			objRec.set('ExtubateDateTime',ExtubateDateTime);
			objRec.set('IntubatePlaceID',IntubatePlaceID);
			objRec.set('IntubatePlaceDesc',IntubatePlaceDesc);
			objRec.set('IntubateUserTypeID',IntubateUserTypeID);
			objRec.set('IntubateUserTypeDesc',IntubateUserTypeDesc);
			objRec.set('IntubateUserID',IntubateUserID);
			objRec.set('IntubateUserDesc',IntubateUserDesc);
			objRec.set('IsInfection',IsInfection);
			objRec.set('InfDate',InfDate);
			objRec.set('InfPyIDs',InfPyID);
			objRec.set('InfPyDescs',InfPyDesc);
			objRec.set('InfPyValues',InfPyValue);
			objRec.set('VAPIntubateTypeID',VAPIntubateTypeID);
			objRec.set('VAPIntubateTypeDesc',VAPIntubateTypeDesc);
			objRec.commit();
		} else {                 //插入数据
			var objGrid = Ext.getCmp('IVAP_gridVAP');
			if (objGrid){
				var objStore = objGrid.getStore();
				var RecordType = objStore.recordType;
				var RecordData = new RecordType({
					IndRec : ''
					,RepID : obj.CurrReport.RowID
					,SubID : ''
					,IsChecked : '1'
					,DataSource : ''
					,IntubateDate : IntubateDate
					,IntubateTime : IntubateTime
					,IntubateDateTime : IntubateDateTime
					,ExtubateDate : ExtubateDate
					,ExtubateTime : ExtubateTime
					,ExtubateDateTime : ExtubateDateTime
					,IntubatePlaceID : IntubatePlaceID
					,IntubatePlaceDesc : IntubatePlaceDesc
					,IntubateUserTypeID : IntubateUserTypeID
					,IntubateUserTypeDesc : IntubateUserTypeDesc
					,IntubateUserID : IntubateUserID
					,IntubateUserDesc : IntubateUserDesc
					,IsInfection : IsInfection
					,InfDate : InfDate
					,InfPyIDs : InfPyID
					,InfPyDescs : InfPyDesc
					,InfPyValues : InfPyValue
					,VAPIntubateTypeID : VAPIntubateTypeID
					,VAPIntubateTypeDesc : VAPIntubateTypeDesc
				});
				objStore.insert(objStore.getCount(), RecordData);
				objGrid.getView().focusRow(objGrid.getStore().getCount()-1);
			}
		}
	}
	
	obj.IVAP_GridRowDataSet = function(objRec){
		if (objRec){
			Common_SetValue('IVAP_txtIntubateDateTime',objRec.get('IntubateDateTime'));
			Common_SetValue('IVAP_txtExtubateDateTime',objRec.get('ExtubateDateTime'));
			Common_SetValue('IVAP_cboIntubatePlace',objRec.get('IntubatePlaceID'),objRec.get('IntubatePlaceDesc'));
			Common_SetValue('IVAP_cboIntubateUserType',objRec.get('IntubateUserTypeID'),objRec.get('IntubateUserTypeDesc'));
			Common_SetValue('IVAP_cboIntubateUser',objRec.get('IntubateUserID'),objRec.get('IntubateUserDesc'));
			Common_SetValue('IVAP_cboVAPIntubateType',objRec.get('VAPIntubateTypeID'),objRec.get('VAPIntubateTypeDesc'));
			
			//是否感染,感染日期,病原体
			Common_SetValue('IVAP_chkIsInf',(objRec.get('IsInfection')=='是'));
			Common_SetValue('IVAP_txtInfDate',objRec.get('InfDate'));
			var strInfPyValues = objRec.get('InfPyValues');
			strInfPyValues = strInfPyValues.replace(/<\$C1>/gi,CHR_1);
			strInfPyValues = strInfPyValues.replace(/<\$C2>/gi,CHR_2);
			var arrInfPyValues = strInfPyValues.split(CHR_1);
			if (arrInfPyValues.length > 0) {
				var strInfPyValue = arrInfPyValues[0];
				var arrInfPyValue = strInfPyValue.split(CHR_2);
				if (arrInfPyValue.length >= 2) {
					Common_SetValue('IVAP_cboInfPy',arrInfPyValue[0],arrInfPyValue[1]);
				}
			} else {
				Common_SetValue('IVAP_cboInfPy','','');
			}
			var objItem1 = Ext.getCmp("IVAP_txtInfDate");
			if (objItem1) {
				objItem1.setDisabled((objRec.get('IsInfection')!='是'));
			}
			var objItem1 = Ext.getCmp("IVAP_cboInfPy");
			if (objItem1) {
				objItem1.setDisabled((objRec.get('IsInfection')!='是'));
			}
		} else {
			Common_SetValue('IVAP_txtIntubateDateTime','');
			Common_SetValue('IVAP_txtExtubateDateTime','');
			Common_SetValue('IVAP_cboIntubatePlace','','');
			Common_SetValue('IVAP_cboIntubateUserType','','');
			Common_SetValue('IVAP_cboIntubateUser','','');
			Common_SetValue('IVAP_cboVAPIntubateType','','');
			Common_SetValue('IVAP_chkIsInf','');
			Common_SetValue('IVAP_txtInfDate','');
			Common_SetValue('IVAP_cboInfPy','','');
			var objItem1 = Ext.getCmp("IVAP_txtInfDate");
			if (objItem1) {
				objItem1.setDisabled(true);
			}
			var objItem1 = Ext.getCmp("IVAP_cboInfPy");
			if (objItem1) {
				objItem1.setDisabled(true);
			}
		}
	}
	
	obj.IVAP_GridRowEditer = function(objRec){
		obj.IVAP_GridRowEditer_objRec = objRec;
		var winGridRowEditer = Ext.getCmp('IVAP_GridRowEditer');
		if (!winGridRowEditer){
			winGridRowEditer = new Ext.Window({
				id : 'IVAP_GridRowEditer',
				height : 280,
				closeAction: 'hide',
				width : 300,
				modal : true,
				title : '呼吸机-编辑',
				layout : 'fit',
				frame : true,
				items: [
					obj.IVAP_GridRowViewPort
				],
				buttons : [
					'->',
					new Ext.Toolbar.Button({
						id: "IVAP_GridRowEditer_btnUpdate",
						width : 80,
						text : "确定",
						iconCls : 'icon-update',
						listeners : {
							'click' : function(){
								var errInfo = obj.IVAP_GridRowDataCheck('');
								if (errInfo){
									ExtTool.alert("提示",errInfo);
									return;
								}
								obj.IVAP_GridRowDataSave(obj.IVAP_GridRowEditer_objRec);
								winGridRowEditer.hide();
							}
						}
					}),
					new Ext.Toolbar.Button({
						id: "IVAP_GridRowEditer_btnCancel",
						width : 80,
						text : "取消",
						iconCls : 'icon-undo',
						listeners : {
							'click' : function(){
								winGridRowEditer.hide();
							}
						}
					})
				]
			});
		}
		winGridRowEditer.show();
		obj.IVAP_GridRowDataSet(objRec);
	}
	
	//主列表
	obj.IVAP_GridToVAP = function(){
		var tmpGridPanel = new Ext.grid.GridPanel({
			id: arguments[0],
			store : new Ext.data.Store({
				proxy: new Ext.data.HttpProxy({
					url : ExtToolSetting.RunQueryPageURL,
					listeners : {
						'beforeload' :  function(objProxy, param){
							param.ClassName = 'DHCMed.NINFService.Rep.InfReportICU';
							param.QueryName = 'QrySubRec';
							param.Arg1      = obj.CurrReport.RowID;
							param.Arg2      = obj.CurrReport.EpisodeID;
							param.Arg3      = 'VAP';
							param.ArgCnt    = 3;
						}
					}
				}),
				reader: new Ext.data.JsonReader(
					{
						root: 'record',
						totalProperty: 'total',
						idProperty: 'IndRec'
					},
					[
						{name: 'IndRec', mapping: 'IndRec'}
						,{name: 'RepID', mapping: 'RepID'}
						,{name: 'SubID', mapping: 'SubID'}
						,{name: 'IsChecked', mapping: 'IsChecked'}
						,{name: 'DataSource', mapping: 'DataSource'}
						,{name: 'IntubateTypeID', mapping: 'IntubateTypeID'}
						,{name: 'IntubateTypeDesc', mapping: 'IntubateTypeDesc'}
						,{name: 'IntubateDate', mapping: 'IntubateDate'}
						,{name: 'IntubateTime', mapping: 'IntubateTime'}
						,{name: 'IntubateDateTime', mapping: 'IntubateDateTime'}
						,{name: 'ExtubateDate', mapping: 'ExtubateDate'}
						,{name: 'ExtubateTime', mapping: 'ExtubateTime'}
						,{name: 'ExtubateDateTime', mapping: 'ExtubateDateTime'}
						,{name: 'IntubatePlaceID', mapping: 'IntubatePlaceID'}
						,{name: 'IntubatePlaceDesc', mapping: 'IntubatePlaceDesc'}
						,{name: 'IntubateUserTypeID', mapping: 'IntubateUserTypeID'}
						,{name: 'IntubateUserTypeDesc', mapping: 'IntubateUserTypeDesc'}
						,{name: 'IntubateUserID', mapping: 'IntubateUserID'}
						,{name: 'IntubateUserDesc', mapping: 'IntubateUserDesc'}
						,{name: 'IsInfection', mapping: 'IsInfection'}
						,{name: 'InfDate', mapping: 'InfDate'}
						,{name: 'InfPyIDs', mapping: 'InfPyIDs'}
						,{name: 'InfPyDescs', mapping: 'InfPyDescs'}
						,{name: 'InfPyValues', mapping: 'InfPyValues'}
						,{name: 'VAPIntubateTypeID', mapping: 'VAPIntubateTypeID'}
						,{name: 'VAPIntubateTypeDesc', mapping: 'VAPIntubateTypeDesc'}
					]
				)
			})
			,height : 150
			//,overflow:'scroll'
			//,overflow-y:hidden
			//,style:'overflow:auto;overflow-y:hidden'
			//,loadMask : true
			,frame : true
			,anchor : '100%'
			,columns: [
				new Ext.grid.RowNumberer()
				,{header: '选择', width: 30, dataIndex: 'IsChecked', sortable: false, menuDisabled:true, align: 'center'
					,renderer: function(v, m, rd, r, c, s){
						var IsChecked = rd.get("IsChecked");
						if (IsChecked == '1') {
							return "<IMG src='../scripts/dhcmed/img/checked.gif'>";
						} else {
							return "<IMG src='../scripts/dhcmed/img/unchecked.gif'>";
						}
					}
				}
				,{header: '气道类型', width: 60, dataIndex: 'VAPIntubateTypeDesc', sortable: false, menuDisabled:true, align:'center' }
				,{header: '上机时间', width: 100, dataIndex: 'IntubateDateTime', sortable: false, menuDisabled:true, align:'center' }
				,{header: '脱机时间', width: 100, dataIndex: 'ExtubateDateTime', sortable: false, menuDisabled:true, align:'center' }
				,{header: '置管人员', width: 100, dataIndex: 'IntubateUserTypeDesc', sortable: false, menuDisabled:true, align:'center' }
				,{header: '置管地点', width: 100, dataIndex: 'IntubatePlaceDesc', sortable: false, menuDisabled:true, align:'center' }
				,{header: '是否感染', width: 60, dataIndex: 'IsInfection', sortable: false, menuDisabled:true, align:'center' }
				,{header: '感染日期', width: 80, dataIndex: 'InfDate', sortable: false, menuDisabled:true, align:'center' }
			],
			buttonAlign : 'left',
			buttons : [
				new Ext.Toolbar.Button({
					id: arguments[0] + "_btnAdd",
					width : 80,
					text : "增加",
					iconCls : 'icon-add',
					listeners : {
						'click' : function(){
							obj.IVAP_GridRowEditer("");
						}
					}
				}),
				new Ext.Toolbar.Button({
					id: arguments[0] + "_btnDelete",
					width : 80,
					text : "删除",
					iconCls : 'icon-delete',
					listeners : {
						'click' : function(){
						//Add By zhoubo 2014-12-20 FixBug：1772:删除中心静脉置管/呼吸机/泌尿道插管/病原学检验记录,不进行提交操作，报告中的记录被删除
						if(obj.CurrReport)
						{
								//Modified By LiYang 2015-03-27 FixBug:公共卫生事件-医院感染报告-报告没有提交成功，通过【删除】按钮删除已录入的数据时，提示"“提交"状态的报告不能再删除数据”
								//再增加判断一下RowID是否为空，为空说明报告未保存，可以任意修改，否则已经提交就不能操作了
								//if(obj.CurrReport.ReportStatus){
								if((obj.CurrReport.ReportStatus)&&(obj.CurrReport.RowID != "")){
								if((obj.CurrReport.ReportStatus.Code == "2")||(obj.CurrReport.ReportStatus.Code == "3")||(obj.CurrReport.ReportStatus.Code == "0"))
								{
									ExtTool.alert("错误提示", "“" + obj.CurrReport.ReportStatus.Description + "”状态的报告不能再删除项目！");
									return;
								}
							}
						}
							var objGrid = Ext.getCmp("IVAP_gridVAP");
							if (objGrid){
								//var objRecArr = objGrid.getSelectionModel().getSelections();
								var objRecArr = objGrid.getStore().getRange(); //Modified By LiYang 2014-07-03 FixBug:1776 公共卫生事件-医院感染报告-ICU感染监测，添加中心静脉置管记录后，直接点击【删除】按钮，提示"请选中数据记录，再点击删除！"
								for (var indRec = 0; indRec < objRecArr.length; indRec++){ //add by zhoubo 2014-12-12  fixBug:1683
									var objRec = objRecArr[indRec];
									var flag=0
									if(objRec.get("IsChecked") == "1"){							
										var flag=1;
									}
								}
								if (objRecArr.length>0&&flag==1){
									Ext.MessageBox.confirm('删除', '是否删除选中数据记录?', function(btn,text){
										if(btn=="yes"){
											for (var indRec = 0; indRec < objRecArr.length; indRec++){
												var objRec = objRecArr[indRec];
												if(objRec.get("IsChecked") == "0") //Add By LiYang 2014-07-03 FixBug: 1683 
													continue;
												if (objRec.get('SubID')) {
													var RecID = objRec.get('RepID') + '||' + objRec.get('SubID');
													var flg = obj.ClsInfReportICUSrv.DelSubRec(objRec.get('RepID') + '||' + objRec.get('SubID'));
													if (parseInt(flg) > 0) {
														objGrid.getStore().remove(objRec);
													} else {
														ExtTool.alert("错误提示","删除呼吸机信息错误!error=" + flg);
													}
												} else {
													objGrid.getStore().remove(objRec);
												}
											}
										}
									});
								} else {
									ExtTool.alert("提示","请选中数据记录,再点击删除!");
								}
							}
						}
					}
				})
			],
			viewConfig : {
				forceFit : true
			}
		});
		
		return tmpGridPanel;
	}
	obj.IVAP_gridVAP = obj.IVAP_GridToVAP("IVAP_gridVAP");
	
	//双击行触发事件
	obj.IVAP_gridVAP.on('rowdblclick',function(){
		var rowIndex = arguments[1];
		var objRec = this.getStore().getAt(rowIndex);
		obj.IVAP_GridRowEditer(objRec);
	});
	//单击单元格触发事件
	obj.IVAP_gridVAP.on('cellclick',function(grid, rowIndex, columnIndex, e){
		var objRec = grid.getStore().getAt(rowIndex);
		var fieldName = grid.getColumnModel().getDataIndex(columnIndex);
		if (fieldName != 'IsChecked') return;
		
		var recValue = objRec.get('IsChecked');
		if (recValue == '1') {
			var newValue = '0';
		} else {
			var newValue = '1';
		}
		objRec.set('IsChecked', newValue);
		grid.getStore().commitChanges();
		grid.getView().refresh();
	});
	
	//界面布局
	obj.IVAP_ViewPort = {
		id : 'IVAPViewPort',
		layout : 'fit',
		//frame : true,
		height : 200,
		anchor : '-20',
		tbar : ['<img SRC="../scripts/dhcmed/img/UC.png"><b style="font-size:16px;">呼吸机</b>'],
		items : [
			obj.IVAP_gridVAP
		]
	}
	
	//初始化页面
	obj.IVAP_InitView = function(){
		obj.IVAP_gridVAP.getStore().load({});
	}
	
	//数据存储
	obj.IVAP_SaveData = function(){
		var errinfo = '';
		
		var objStore = obj.IVAP_gridVAP.getStore();
		for (var indRec = 0; indRec < objStore.getCount(); indRec++) {
			var objRec = objStore.getAt(indRec);
			
			if (objRec.get('IsChecked') == '1') {
				//数据完整性校验
				var flg = obj.IVAP_GridRowDataCheck(objRec);
				if (flg){
					var row = objStore.indexOfId(objRec.id);  //获取行号
					errinfo = errinfo + '呼吸机 第' + (row + 1) + '行 数据错误!<br>'
				}
				
				var objICU = obj.ClsInfReportICUSrv.GetSubObj('');
				if (objICU) {
					if (objRec.get('RepID')&&objRec.get('SubID')) objICU.RowID = objRec.get('RepID') + '||' + objRec.get('SubID');
					objICU.DataSource = objRec.get('DataSource');
					objICU.IntubateType = obj.ClsSSDictionary.GetByTypeCode('NINFICUIntubateType','VAP','');
					objICU.IntubateDate = objRec.get('IntubateDate');
					objICU.IntubateTime = objRec.get('IntubateTime');
					objICU.ExtubateDate = objRec.get('ExtubateDate');
					objICU.ExtubateTime = objRec.get('ExtubateTime');
					objICU.IntubatePlace = obj.ClsSSDictionary.GetObjById(objRec.get('IntubatePlaceID'));
					objICU.IntubateUserType = obj.ClsSSDictionary.GetObjById(objRec.get('IntubateUserTypeID'));
					objICU.IntubateUser = objRec.get('IntubateUserID');
					objICU.InfDate = objRec.get('InfDate');
					
					objICU.InfPathogeny = new Array();
					var InfPyValues = objRec.get('InfPyValues');
					InfPyValues = InfPyValues.replace(/<\$C1>/gi,CHR_1);
					InfPyValues = InfPyValues.replace(/<\$C2>/gi,CHR_2);
					var arrPy = InfPyValues.split(CHR_1);
					for (var indPy = 0; indPy < arrPy.length; indPy++) {
						var strPyField = arrPy[indPy];
						if (strPyField == '') continue;
						var arrPyField = strPyField.split(CHR_2);
						
						var objPy = new Object();
						objPy.PathogenyID = arrPyField[0]
						objPy.PathogenyDesc = arrPyField[1]
						if (!arrPyField[1]) continue;
						
						objICU.InfPathogeny.push(objPy);
					}
					
					objICU.VAPIntubateType = obj.ClsSSDictionary.GetObjById(objRec.get('VAPIntubateTypeID'));
					obj.CurrReport.ChildICU.push(objICU);
				}
			} else {
				if (objRec.get('SubID') != '') {
					var RecID = objRec.get('RepID') + '||' + objRec.get('SubID');
					var flg = obj.ClsInfReportICUSrv.DelSubRec(RecID);
					if (parseInt(flg) > 0) {
						//删除成功
					} else {
						ExtTool.alert("错误提示","删除呼吸机信息错误!error=" + flg);
					}
				}
			}
		}
		
		return errinfo;
	}
	
	return obj;
}