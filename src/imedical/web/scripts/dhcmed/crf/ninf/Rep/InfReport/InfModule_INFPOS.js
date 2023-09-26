
function InitINFPOS(obj)
{
	//易感因素
	obj.INFPOS_cbgInfFactors = Common_CheckboxGroupToDic("INFPOS_cbgInfFactors","<span style='color:red'><b>易感因素</b></span>","NINFInfInfFactors",6);
	//侵害性操作
	obj.INFPOS_cbgInvasiveOper = Common_CheckboxGroupToDic("INFPOS_cbgInvasiveOper","<span style='color:red'><b>侵害性操作</b></span>","NINFInfInvasiveOper",6);
	
	//感染信息 编辑框
	obj.INFPOS_gridInfPos_RowEditer_objRec = '';
	obj.INFPOS_gridInfPos_RowEditer = function(objRec) {
		obj.INFPOS_gridInfPos_RowEditer_objRec = objRec;
		var winGridRowEditer = Ext.getCmp('INFPOS_gridInfPos_RowEditer');
		if (!winGridRowEditer)
		{
			obj.INFPOS_gridInfPos_RowEditer_cboInfPos = Common_ComboToInfPos("INFPOS_gridInfPos_RowEditer_cboInfPos","<span style='color:red'><b>感染部位</b></span>","INFPOS_gridInfPos_RowEditer_cboInfDiag","","95%");
			obj.INFPOS_gridInfPos_RowEditer_cboInfDate = Common_DateFieldToDate("INFPOS_gridInfPos_RowEditer_cboInfDate","<span style='color:red'><b>感染日期</b></span>","95%");
			obj.INFPOS_gridInfPos_RowEditer_cboInfEndDate = Common_DateFieldToDate("INFPOS_gridInfPos_RowEditer_cboInfEndDate","结束日期","95%");  //Modified By LiYang 2013-05-18 增加感染结束日期列
			obj.INFPOS_gridInfPos_RowEditer_cboInfEndResult = Common_ComboToDic("INFPOS_gridInfPos_RowEditer_cboInfEndResult","感染转归","NINFInfEndResult","","95%"); //Modified By LiYang 2013-05-18 增加感染转归列
			obj.INFPOS_gridInfPos_RowEditer_cboInfDiag = Common_ComboToInfDia("INFPOS_gridInfPos_RowEditer_cboInfDiag","<span style='color:red'><b>感染诊断</b></span>","INFPOS_gridInfPos_RowEditer_cboInfPos","95%");
			obj.INFPOS_gridInfPos_RowEditer_cboInfDiagCat = Common_ComboToInfDiagCat("INFPOS_gridInfPos_RowEditer_cboInfDiagCat","<span style='color:red'><b>诊断分类</b></span>","INFPOS_gridInfPos_RowEditer_cboInfDiag","95%");
			obj.INFPOS_gridInfPos_RowEditer_txtDiagnosisBasis = Common_TextAreaToDC("INFPOS_gridInfPos_RowEditer_txtDiagnosisBasis","诊断依据",70,"95%","INFPOS_gridInfPos_RowEditer_cboInfPos","INFPOS_gridInfPos_RowEditer_cboInfDiag","DiagnosisBasis");
			obj.INFPOS_gridInfPos_RowEditer_txtDiseaseCourse = Common_TextArea("INFPOS_gridInfPos_RowEditer_txtDiseaseCourse","感染性疾病病程",65,500,"95%");
			obj.INFPOS_gridInfPos_RowEditer_gridInfOperStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
				url : ExtToolSetting.RunQueryPageURL
			}));
			obj.INFPOS_gridInfPos_RowEditer_gridInfOperStore = new Ext.data.Store({
				proxy : obj.INFPOS_gridInfPos_RowEditer_gridInfOperStoreProxy,
				reader : new Ext.data.JsonReader({
					root : 'record',
					totalProperty : 'total',
					idProperty : 'IDRowID'
				}, [
					{name : 'IsChecked',mapping : 'IsChecked'}
					,{name : 'IDRowID',mapping : 'IDRowID'}
					,{name : 'IDCode',mapping : 'IDCode'}
					,{name : 'IDDesc',mapping : 'IDDesc'}
				])
			});
			obj.INFPOS_gridInfPos_RowEditer_gridInfOper = new Ext.grid.EditorGridPanel({
				id : 'INFPOS_gridInfPos_RowEditer_gridInfOper',
				store : obj.INFPOS_gridInfPos_RowEditer_gridInfOperStore,
				selModel : new Ext.grid.RowSelectionModel({
					singleSelect : true
				}),
				columnLines : true,
				region : 'center',
				loadMask : true,
				height : 300,
				//tbar : ['与此次感染直接相关的侵害性操作'],
				columns : [
					{header : '选择',width : 35,dataIndex : 'IsChecked',sortable : false,menuDisabled : true,align : 'center',
						renderer : function(v, m, rd, r, c, s) {
							var IsChecked = rd.get("IsChecked");
							if (IsChecked == '1') {
								return "<IMG src='../scripts/dhcmed/img/checked.gif'>";
							} else {
								return "<IMG src='../scripts/dhcmed/img/unchecked.gif'>";
							}
						}
					},
					{header : '与此次感染直接相关的<br>侵害性操作',width : 150,dataIndex : 'IDDesc',sortable : false,menuDisabled : true,align : 'left'}
				],
				listeners : {
					'rowclick' : function() {
						var objRecOper = obj.INFPOS_gridInfPos_RowEditer_gridInfOper.getSelectionModel().getSelected();
						if (objRecOper.get("IsChecked") == '1') {
							var newValue = '0';
						} else {
							var newValue = '1';
						}
						objRecOper.set("IsChecked", newValue);
					}
				},
				viewConfig : {
					forceFit : true
				}
			});
			obj.INFPOS_gridInfPos_RowEditer_gridInfOperStoreProxy.on('beforeload', function(objProxy, param) {
				param.ClassName = 'DHCMed.NINFService.Dic.MapPosOperDic';
				param.QueryName = 'QryOperByInfPos1';
				param.Arg1 = Common_GetValue('INFPOS_gridInfPos_RowEditer_cboInfPos');
				param.Arg2 = obj.strInfPosOpers;
				param.ArgCnt = 2;
			});
			obj.INFPOS_gridInfPos_RowEditer_cboInfPos.on('select',function(){
				var objCmp = Ext.getCmp('INFPOS_gridInfPos_RowEditer_gridInfOper');
				if (objCmp){
					objCmp.getStore().removeAll();
					objCmp.getStore().load({});
				}
				var objCmp = Ext.getCmp('INFPOS_gridInfPos_RowEditer_cboInfDiagCat');
				if (objCmp){
					objCmp.setValue('');
					objCmp.setRawValue('');
					var objStore = objCmp.getStore();
					objStore.removeAll();
				}
			});
			obj.INFPOS_gridInfPos_RowEditer_cboInfDiag.on('select',function(){
				var objCmp = Ext.getCmp('INFPOS_gridInfPos_RowEditer_cboInfDiagCat');
				if (objCmp){
					objCmp.setValue('');
					objCmp.setRawValue('');
					var objStore = objCmp.getStore();
					objStore.removeAll();
					objStore.load({
						callback : function() {
							if (objStore.getTotalCount()>0) {
								document.all['cboInfDiagCatPn'].style.display = 'block';
							} else {
								document.all['cboInfDiagCatPn'].style.display = 'none';
							}
						}
						,scope : objStore
						,add : false
					});
				}
			});
			
			winGridRowEditer = new Ext.Window({
				id : 'INFPOS_gridInfPos_RowEditer',
				height : 400,
				closeAction: 'hide',
				width : 600,
				modal : true,
				title : '感染信息-编辑',
				layout : 'border',
				frame : true,
				items: [
					{
						region: 'center',
						layout : 'form',
						frame : true,
						labelAlign : 'right',
						labelWidth : 60,
						items : [
							obj.INFPOS_gridInfPos_RowEditer_cboInfDate
							,obj.INFPOS_gridInfPos_RowEditer_cboInfPos
							,obj.INFPOS_gridInfPos_RowEditer_cboInfDiag
							,{
								id : 'cboInfDiagCatPn',
								layout : 'form',
								labelAlign : 'right',
								labelWidth : 60,
								items : [
									obj.INFPOS_gridInfPos_RowEditer_cboInfDiagCat
								]
							}
							//,obj.INFPOS_gridInfPos_RowEditer_cboInfEndDate
							//,obj.INFPOS_gridInfPos_RowEditer_cboInfEndResult
							,obj.INFPOS_gridInfPos_RowEditer_txtDiagnosisBasis
							,obj.INFPOS_gridInfPos_RowEditer_txtDiseaseCourse
						]
					},{
						region: 'east',
						layout : 'fit',
						width : 240,
						frame : true,
						items : [obj.INFPOS_gridInfPos_RowEditer_gridInfOper]
					}
				],
				bbar : [
					'->',
					new Ext.Toolbar.Button({
						id: "INFPOS_gridInfPos_RowEditer_btnUpdate",
						width : 80,
						text : "<img SRC='../scripts/dhcmed/img/update.png'>确定",
						listeners : {
							'click' : function(){
								var InfPosID = Common_GetValue('INFPOS_gridInfPos_RowEditer_cboInfPos');
								var InfPosDesc = Common_GetText('INFPOS_gridInfPos_RowEditer_cboInfPos');
								var InfDate = Common_GetText('INFPOS_gridInfPos_RowEditer_cboInfDate');
								var InfEndDate = '' //Common_GetText('INFPOS_gridInfPos_RowEditer_cboInfEndDate'); //Add By LiYang 2013-05-18 增加医院感染结束日期
								var InfEndResult = Common_GetValue('INFPOS_gridInfPos_RowEditer_cboInfEndResult'); //Add By LiYang 2013-05-18 增加医院感染转归(ID)
								var InfEndResultDesc = Common_GetText('INFPOS_gridInfPos_RowEditer_cboInfEndResult'); //Add By LiYang 2013-05-18 增加医院感染转归(Desc)
								var InfDiagnosID = Common_GetValue('INFPOS_gridInfPos_RowEditer_cboInfDiag');
								var InfDiagnosDesc = Common_GetText('INFPOS_gridInfPos_RowEditer_cboInfDiag');
								var InfDiagCatID = Common_GetValue('INFPOS_gridInfPos_RowEditer_cboInfDiagCat');
								var InfDiagCatDesc = Common_GetText('INFPOS_gridInfPos_RowEditer_cboInfDiagCat');
								var InfPosOprValues = "";
								var InfPosOprDescs = "";
								var objGridInfOper = Ext.getCmp('INFPOS_gridInfPos_RowEditer_gridInfOper');
								var objStore = objGridInfOper.getStore();
								for (var ind = 0; ind < objStore.getCount(); ind++) {
									var tmpRec = objStore.getAt(ind);
									if (tmpRec.get("IsChecked") == 1) {
										InfPosOprValues = InfPosOprValues + CHR_1 + tmpRec.get("IDRowID") + CHR_2 + CHR_2 + CHR_2 + CHR_2;
										if (InfPosOprDescs != "") {
											InfPosOprDescs = InfPosOprDescs + "," + tmpRec.get("IDDesc");
										} else {
											InfPosOprDescs = tmpRec.get("IDDesc");
										}
									}
								}
								//诊断依据+感染性疾病病程
								var DiagnosisBasis = Common_GetValue('INFPOS_gridInfPos_RowEditer_txtDiagnosisBasis');
								var DiseaseCourse = Common_GetValue('INFPOS_gridInfPos_RowEditer_txtDiseaseCourse');
								
								var errInfo = '';
								if ((InfPosID == '')||(InfPosDesc == '')) {
									errInfo = errInfo + '感染部位为空!<br>'
								}
								if ((InfDiagnosID == '')||(InfDiagnosDesc == '')) {
									errInfo = errInfo + '感染诊断为空!<br>'
								}
								if ((InfDiagCatID == '')||(InfDiagCatDesc == '')) {
									var cboInfDiagCat = Ext.getCmp('INFPOS_gridInfPos_RowEditer_cboInfDiagCat');
									if (cboInfDiagCat){
										if (cboInfDiagCat.getStore().getTotalCount()>0){
											errInfo = errInfo + '感染诊断分类为空!<br>'
										}
									}
								}
								if (InfDate == '') {
									errInfo = errInfo + '感染日期为空!<br>'
								} else {
									var today = new Date();
									var CurrDate = today.getYear() + "-" + (today.getMonth() + 1) + "-" + today.getDate();
									var flg = Common_CompareDate(InfDate,CurrDate);
									if (!flg) errInfo = errInfo + '感染日期大于当前日期!<br>'
									
									var objPaadm = obj.CurrPaadm;
									var flg = Common_CompareDate(objPaadm.AdmitDate,InfDate);
									if (!flg) errInfo = errInfo + '感染日期小于入院日期!<br>'
									
									if (objPaadm.DisDate) {
										var flg = Common_CompareDate(InfDate,objPaadm.DisDate);
										if (!flg) errInfo = errInfo + '感染日期大于出院日期!<br>'
									}
								}
								//Add By LiYang 2013-05-18 校验感染结束日期，要晚于感染日期
								if (InfEndDate != '')
								{
									var flg = Common_CompareDate(InfDate,InfEndDate);
									if (!flg) errInfo = errInfo + '感染日期大于感染结束日期!<br>'
									var today = new Date();
									var CurrDate = today.getYear() + "-" + (today.getMonth() + 1) + "-" + today.getDate();
									var flg = Common_CompareDate(InfEndDate,CurrDate);
									if (!flg) errInfo = errInfo + '感染结束日期大于当前日期!<br>'									
								}
								if (InfEndResult != '')
								{
									var strText = Common_GetText('INFPOS_gridInfPos_RowEditer_cboInfEndResult');
									if((objPaadm.DisDate == "") && ((strText == '恶化') || (strText == '携带')))
									{
										errInfo = errInfo + '感染转归情况：【恶化】，【携带】选项只能在患者出院后才能选择！<br>'
									}									
								}
								if ((InfPosOprValues == '')||(InfPosOprDescs == '')) {
									//errInfo = errInfo + '与感染相关的侵害性操作为空!<br>'
								}
								if (errInfo != '') {
									ExtTool.alert("提示",errInfo);
									return;
								}
								
								var objRec = obj.INFPOS_gridInfPos_RowEditer_objRec;
								var objGrid = Ext.getCmp('INFPOS_gridInfPos');
								if (objGrid) {
									var objStore = objGrid.getStore();
									
									//判断是否存在相同感染部位,相同感染日期数据
									var IsBoolean = false;
									for (var ind = 0; ind < objStore.getCount(); ind++) {
										var tmpRec = objStore.getAt(ind);
										if (objRec) {
											if (tmpRec.id == objRec.id) continue;
										}
										if ((InfPosDesc == tmpRec.get('InfPosDesc'))&&(InfDate == tmpRec.get('InfDate'))) {
											IsBoolean = true;
										}
									}
									if (IsBoolean) {
										ExtTool.alert("提示","存在相同感染部位,相同感染日期数据!");
										return;
									}
									
									if (objRec) {
										objRec.set('InfPosID',InfPosID);
										objRec.set('InfPosDesc',InfPosDesc);
										objRec.set('InfDate',InfDate);
										objRec.set('InfEndDate', InfEndDate); //Add By LiYang 2013-05-18 保存感染结束日期
										objRec.set('InfDiagnosID',InfDiagnosID);
										objRec.set('InfDiagnosDesc',InfDiagnosDesc);
										objRec.set('InfDiagCatID',InfDiagCatID);
										objRec.set('InfDiagCatDesc',InfDiagCatDesc);
										objRec.set('InfPosOprValues',InfPosOprValues);
										objRec.set('InfPosOprDescs',InfPosOprDescs);
										objRec.set('InfEndResultID', InfEndResult); //Add By LiYang 2013-05-19 医院感染转归ID
										objRec.set('InfEndResultDesc', InfEndResultDesc);	//Add By LiYang 2013-05-19 医院感染转归Desc
										objRec.set('DiagnosisBasis', DiagnosisBasis);
										objRec.set('DiseaseCourse', DiseaseCourse);
										objRec.commit();
									} else {
										var RecordType = objStore.recordType;
										var RecordData = new RecordType({
											RepID : ''
											,SubID : ''
											,DataSource : ''
											,InfPosID : InfPosID
											,InfPosDesc : InfPosDesc
											,InfDate : InfDate
											,InfEndDate : InfEndDate //Add By LiYang 2013-05-18 保存感染结束日期
											,InfDiagnosID : InfDiagnosID
											,InfDiagnosDesc : InfDiagnosDesc
											,InfDiagCatID : InfDiagCatID
											,InfDiagCatDesc : InfDiagCatDesc
											,InfPosOprValues : InfPosOprValues
											,InfPosOprDescs : InfPosOprDescs
											,InfEndResultID : InfEndResult //Add By LiYang 2013-05-19 医院感染转归ID
											,InfEndResultDesc : InfEndResultDesc //Add By LiYang 2013-05-19 医院感染转归Desc
											,DiagnosisBasis : DiagnosisBasis
											,DiseaseCourse : DiseaseCourse
										});
										objStore.insert(objStore.getCount(), RecordData);
										objGrid.getView().focusRow(objGrid.getStore().getCount()-1);
									}
								}
								
								winGridRowEditer.hide();
							}
						}
					}),
					new Ext.Toolbar.Button({
						id: "INFPOS_gridInfPos_RowEditer_btnCancel",
						width : 80,
						text : "<img SRC='../scripts/dhcmed/img/cancel.png'>取消",
						listeners : {
							'click' : function(){
								winGridRowEditer.hide();
							}
						}
					})
				],
				listeners :{
					'beforeshow' : function(){
						var objRec = obj.INFPOS_gridInfPos_RowEditer_objRec;
						if (objRec) {
							Common_SetValue('INFPOS_gridInfPos_RowEditer_cboInfPos',objRec.get('InfPosID'),objRec.get('InfPosDesc'));
							Common_SetValue('INFPOS_gridInfPos_RowEditer_cboInfDate',objRec.get('InfDate'));
							Common_SetValue('INFPOS_gridInfPos_RowEditer_cboInfEndDate',objRec.get('InfEndDate')); //Add By LiYang 2013-05-18 显示感染结束日期
							Common_SetValue('INFPOS_gridInfPos_RowEditer_cboInfEndResult',objRec.get('InfEndResultID'), objRec.get('InfEndResultDesc')); //Add By LiYang 2013-05-18 显示感染转归
							Common_SetDisabled("INFPOS_gridInfPos_RowEditer_cboInfPos",(objRec.get('DataSource') != ''));
							Common_SetDisabled("INFPOS_gridInfPos_RowEditer_cboInfDate",(objRec.get('DataSource') != ''));
							Common_SetValue('INFPOS_gridInfPos_RowEditer_cboInfDiag',objRec.get('InfDiagnosID'),objRec.get('InfDiagnosDesc'));
							Common_SetValue('INFPOS_gridInfPos_RowEditer_cboInfDiagCat',objRec.get('InfDiagCatID'),objRec.get('InfDiagCatDesc'));
							Common_SetValue('INFPOS_gridInfPos_RowEditer_txtDiagnosisBasis',objRec.get('DiagnosisBasis'));
							Common_SetValue('INFPOS_gridInfPos_RowEditer_txtDiseaseCourse',objRec.get('DiseaseCourse'));
							obj.strInfPosOpers = "";
							var InfPosOprValues = objRec.get('InfPosOprValues');
							InfPosOprValues = InfPosOprValues.replace(/<\$C2>/gi,CHR_2);
							var arrInfPosOprValue = InfPosOprValues.split(CHR_1);
							for (var ind = 0; ind < arrInfPosOprValue.length; ind++) {
								var strRec = arrInfPosOprValue[ind];
								if (!strRec) continue;
								var arrField = strRec.split(CHR_2);
								if (!arrField[0]) continue;
								obj.strInfPosOpers = obj.strInfPosOpers + "," + arrField[0];
							}
							obj.INFPOS_gridInfPos_RowEditer_gridInfOperStore.load({});
						} else {
							Common_SetValue('INFPOS_gridInfPos_RowEditer_cboInfPos','','');
							Common_SetValue('INFPOS_gridInfPos_RowEditer_cboInfDate','');
							Common_SetValue('INFPOS_gridInfPos_RowEditer_cboInfEndDate',''); //Add By LiYang 2013-05-18 初始化感染结束日期
							Common_SetValue('INFPOS_gridInfPos_RowEditer_cboInfEndResult',''); //Add By LiYang 2013-05-18 初始化感染转归
							Common_SetValue('INFPOS_gridInfPos_RowEditer_cboInfDiag','','');
							Common_SetValue('INFPOS_gridInfPos_RowEditer_cboInfDiagCat','','');
							Common_SetValue('INFPOS_gridInfPos_RowEditer_cbgInvasiveOper','');
							Common_SetValue('INFPOS_gridInfPos_RowEditer_txtDiagnosisBasis','');
							Common_SetValue('INFPOS_gridInfPos_RowEditer_txtDiseaseCourse','');
							obj.strInfPosOpers = obj.tmpInfPosOpers;
							obj.INFPOS_gridInfPos_RowEditer_gridInfOperStore.load({});
						}
						
						//是否隐藏感染诊断子分类下拉框
						document.all['cboInfDiagCatPn'].style.display = 'none';
						if (objRec){
							if (objRec.get('InfDiagCatID') != '') {
								document.all['cboInfDiagCatPn'].style.display = 'block';
							}
						}
					}
				}
			});
		}
		winGridRowEditer.show();
	}
	
	//感染信息 显示
	obj.INFPOS_gridInfPos_btnAdd = new Ext.Button({
		id : 'INFPOS_gridInfPos_btnAdd'
		,iconCls : 'icon-add'
		,width: 80
		,text : '增加'
		,listeners : {
			'click' :  function(){
				obj.INFPOS_gridInfPos_RowEditer('');
			}
		}
	});
	obj.INFPOS_gridInfPos_btnDel = new Ext.Button({
		id : 'INFPOS_gridInfPos_btnDel'
		,iconCls : 'icon-delete'
		,width: 80
		,text : '删除'
		,listeners : {
			'click' :  function(){
			
				//Add By LiYang 2014-07-08 FixBug：1667 医院感染管理-感染报告管理-感染报告查询-将报告的感染信息删除，不做提交或审核，重新打开报告时感染诊断被删除
				if(obj.CurrReport)
				{
					if(obj.CurrReport.ReportStatus){
						if((obj.CurrReport.ReportStatus.Code == "2")||
							(obj.CurrReport.ReportStatus.Code == "3")||
							(obj.CurrReport.ReportStatus.Code == "0"))
						{
							ExtTool.alert("错误提示", "“" + obj.CurrReport.ReportStatus.Description + "”状态的报告不能再删除项目！");
							return;
						}
					}
				}
			
			
				var objGrid = Ext.getCmp("INFPOS_gridInfPos");
				if (objGrid){
					var arrRec = objGrid.getSelectionModel().getSelections();
					if (arrRec.length>0){
						Ext.MessageBox.confirm('删除', '是否删除选中数据记录?', function(btn,text){
							if(btn=="yes"){
								for (var indRec = 0; indRec < arrRec.length; indRec++){
									var objRec = arrRec[indRec];
									if (objRec.get('SubID')) {
										var RecID = objRec.get('RepID') + '||' + objRec.get('SubID');
										var flg = obj.ClsInfReportInfPosSrv.DelSubRec(objRec.get('RepID') + '||' + objRec.get('SubID'));
										if (parseInt(flg) > 0) {
											objGrid.getStore().remove(objRec);
										} else {
											ExtTool.alert("错误提示","删除诊断错误!error=" + flg);
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
	});
	obj.INFPOS_gridInfPos_iniFun = function() {
		var tmpGridPanel = new Ext.grid.GridPanel({
			id: arguments[0],
			store : new Ext.data.Store({
				proxy: new Ext.data.HttpProxy({
					url : ExtToolSetting.RunQueryPageURL,
					listeners : {
						'beforeload' :  function(objProxy, param){
							param.ClassName = 'DHCMed.NINFService.Rep.InfReportInfPos';
							param.QueryName = 'QrySubRec';
							param.Arg1      = obj.CurrReport.RowID;
							param.Arg2      = '';
							param.ArgCnt    = 2;
						}
					}
				}),
				reader: new Ext.data.JsonReader(
					{
						root: 'record',
						totalProperty: 'total'
					},
					[
						{name: 'RepID', mapping: 'RepID'}
						,{name: 'SubID', mapping: 'SubID'}
						,{name: 'DataSource', mapping: 'DataSource'}
						,{name: 'InfPosID', mapping: 'InfPosID'}
						,{name: 'InfPosDesc', mapping: 'InfPosDesc'}
						,{name: 'InfDate', mapping: 'InfDate'}
						,{name: 'InfEndDate', mapping: 'InfEndDate'} //Add By LiYang 2013-05-18 显示感染结束日期
						,{name: 'InfDiagnosID', mapping: 'InfDiagnosID'}
						,{name: 'InfDiagnosDesc', mapping: 'InfDiagnosDesc'}
						,{name: 'InfDiagCatID', mapping: 'InfDiagCatID'}
						,{name: 'InfDiagCatDesc', mapping: 'InfDiagCatDesc'}
						,{name: 'InfPosOprValues', mapping: 'InfPosOprValues'}
						,{name: 'InfPosOprDescs', mapping: 'InfPosOprDescs'}
						,{name: 'InfEndResultID', mapping: 'InfEndResultID'} //Add By LiYang 2013-05-18 显示感染转归
						,{name: 'InfEndResultDesc', mapping: 'InfEndResultDesc'}//Add By LiYang 2013-05-18 显示感染转归描述
						,{name: 'DiagnosisBasis', mapping: 'DiagnosisBasis'}  //add by zf 20130615 诊断依据
						,{name: 'DiseaseCourse', mapping: 'DiseaseCourse'}  //add by zf 20130615 感染性疾病病程
					]
				)
			})
			,height : 180
			,columnLines : true
			,style:'overflow:auto;overflow-y:hidden'
			,loadMask : true
			,selModel : new Ext.grid.RowSelectionModel({
				singleSelect : true
			})
			,anchor : '100%'
			,columns: [
				new Ext.grid.RowNumberer()
				,{header: '感染日期', width: 80, dataIndex: 'InfDate', sortable: false, menuDisabled:true, align:'center' }
				,{header: '感染部位', width: 80, dataIndex: 'InfPosDesc', sortable: false, menuDisabled:true, align:'center' }
				,{header: '感染诊断', width: 100, dataIndex: 'InfDiagnosDesc', sortable: false, menuDisabled:true, align:'left',
					renderer : function(v, m, rd, r, c, s) {
						m.attr = 'style="white-space:normal;"';
						var str = rd.get('InfDiagnosDesc');
						var InfDiagCatDesc = rd.get('InfDiagCatDesc');
						if (InfDiagCatDesc != ''){
							str = str + '【' + InfDiagCatDesc + '】';
						}
						return str;
					}
				}
				//,{header: '结束日期', width: 80, dataIndex: 'InfEndDate', sortable: false, menuDisabled:true, align:'center' } //Add By LiYang 2013-05-18 显示感染结束日期
				//,{header: '感染转归', width: 80, dataIndex: 'InfEndResultDesc', sortable: false, menuDisabled:true, align:'center' } //Add By LiYang 2013-05-18 显示感染转归
				,{header: '与此次感染直接<br>相关的侵害性操作', width: 120, dataIndex: 'InfPosOprDescs', sortable: false, menuDisabled:true, align:'center' }
				,{header: '诊断依据', width: 200, dataIndex: 'DiagnosisBasis', sortable: false, menuDisabled:true, align:'left',
					renderer : function(v, m, rd, r, c, s) {
						m.attr = 'style="white-space:normal;"';
						return v;
					}
				}
				,{header: '感染性<br>疾病病程', width: 200, dataIndex: 'DiseaseCourse', sortable: false, menuDisabled:true, align:'left',
					renderer : function(v, m, rd, r, c, s) {
						m.attr = 'style="white-space:normal;"';
						return v;
					}
				}
			],
			viewConfig : {
				forceFit : true
			}
		});
		
		return tmpGridPanel;
	}
	obj.INFPOS_gridInfPos = obj.INFPOS_gridInfPos_iniFun("INFPOS_gridInfPos");
	
	//感染相关 界面布局
	obj.INFPOS_ViewPort = {
		//title : '感染相关',
		layout : 'fit',
		//frame : true,
		height : 500,
		anchor : '-20',
		tbar : ['<b>感染相关</b>'],
		items : [
			{
				layout : 'border',
				frame : true,
				items : [
					{
						region: 'north',
						layout : 'form',
						height : 220,
						//frame : true,
						labelAlign : 'right',
						labelWidth : 60,
						items : [
							obj.INFPOS_cbgInfFactors,
							obj.INFPOS_cbgInvasiveOper
						]
					},{
						region: 'center',
						layout : 'border',
						items : [
							{
								region: 'center',
								layout : 'fit',
								buttonAlign : 'left',
								//frame : true,
								items : [obj.INFPOS_gridInfPos],
								bbar : [obj.INFPOS_gridInfPos_btnAdd,obj.INFPOS_gridInfPos_btnDel,'->','…']
							},{
								region: 'west',
								layout : 'fit',
								width : 68,
								html: '<table border="0" width="100%" height="30px"><tr><td align="center" >感染信息:</td></tr></table>'
							}
						]
					}
				]
			}
		]
	}
	
	//感染相关 界面初始化
	obj.INFPOS_InitView = function(){
		obj.tmpInfPosOpers = "";
		
		//初始化"易感因素,侵害性操作"界面元素值
		var varInfFactors = '';
		var varInvasiveOperation = '';
		if(obj.CurrReport.RowID == "") {
			//Add By LiYang 2012-11-27 获取综合监测数据
			obj.tmpInfPosOpers = GetEpisodeIntCtlResult(EpisodeID);
			Common_SetValue('INFPOS_cbgInfFactors',obj.tmpInfPosOpers);
			Common_SetValue('INFPOS_cbgInvasiveOper',obj.tmpInfPosOpers);
		} else {
			if (obj.CurrReport.ChildSumm.InfFactors) {
				var arrInfFactors = obj.CurrReport.ChildSumm.InfFactors;
				for (var ind = 0; ind < arrInfFactors.length; ind++) {
					var objDic = arrInfFactors[ind];
					if (objDic) {
						varInfFactors = (varInfFactors == '' ? objDic.RowID : varInfFactors + ',' + objDic.RowID);
					}
				}
			}
			Common_SetValue('INFPOS_cbgInfFactors',varInfFactors);
			if (obj.CurrReport.ChildSumm.InvasiveOperation) {
				var arrInvasiveOperation = obj.CurrReport.ChildSumm.InvasiveOperation;
				for (var ind = 0; ind < arrInvasiveOperation.length; ind++) {
					var objDic = arrInvasiveOperation[ind];
					if (objDic) {
						varInvasiveOperation = (varInvasiveOperation == '' ? objDic.RowID : varInvasiveOperation + ',' + objDic.RowID);
					}
				}
			}
			Common_SetValue('INFPOS_cbgInvasiveOper',varInvasiveOperation);
		}
		
		//初始化"感染信息"load及rowdblclick事件
		var objGrid = Ext.getCmp("INFPOS_gridInfPos");
		if (objGrid){
			objGrid.getStore().load({});
			objGrid.on('rowdblclick',function(){
				var rowIndex = arguments[1];
				var objRec = this.getStore().getAt(rowIndex);
				obj.INFPOS_gridInfPos_RowEditer(objRec);
			},objGrid);
		}
	}
	
	//感染相关 数据存储
	obj.INFPOS_SaveData = function(){
		var errinfo = '';
		
		//易感因素
		obj.CurrReport.ChildSumm.InfFactors = new Array();
		var itmValue = Common_GetValue('INFPOS_cbgInfFactors');
		var arrValue = itmValue.split(',');
		if (itmValue) {
			for (var ind = 0; ind < arrValue.length; ind++) {
				var objDic = obj.ClsSSDictionary.GetObjById(arrValue[ind]);
				if (objDic) {
					obj.CurrReport.ChildSumm.InfFactors.push(objDic);
				}
			}
		}
		
		//侵害性操作
		obj.CurrReport.ChildSumm.InvasiveOperation = new Array();
		var itmValue = Common_GetValue('INFPOS_cbgInvasiveOper');
		var arrValue = itmValue.split(',');
		if (itmValue) {
			for (var ind = 0; ind < arrValue.length; ind++) {
				var objDic = obj.ClsSSDictionary.GetObjById(arrValue[ind]);
				if (objDic) {
					obj.CurrReport.ChildSumm.InvasiveOperation.push(objDic);
				}
			}
		}
		
		//感染信息
		obj.CurrReport.ChildInfPos   = new Array();
		objSumm = obj.CurrReport.ChildSumm;
		var objCmp = Ext.getCmp('INFPOS_gridInfPos');
		if (objCmp) {
			var objStore = objCmp.getStore();
			for (var indRec = 0; indRec < objStore.getCount(); indRec++) {
				var objRec = objStore.getAt(indRec);
				var objInfPos = obj.ClsInfReportInfPosSrv.GetSubObj('');
				if (objInfPos) {
					objInfPos.RowID = objRec.get('RepID') + '||' + objRec.get('SubID');
					objInfPos.DataSource = objRec.get('DataSource');
					objInfPos.InfPos = obj.ClsInfPosition.GetObjById(objRec.get('InfPosID'));
					objInfPos.InfDate = objRec.get('InfDate'); 
					objInfPos.InfEndDate = objRec.get('InfEndDate');//感染结束日期
					objInfPos.InfEndResult = objRec.get('InfEndResultID'); //感染转归
					objInfPos.InfDiag = obj.ClsInfDiagnose.GetObjById(objRec.get('InfDiagnosID'));
					objInfPos.InfDiagCat = obj.ClsSSDictionary.GetObjById(objRec.get('InfDiagCatID')); //感染诊断子分类
					objInfPos.DiagnosisBasis = objRec.get('DiagnosisBasis');
					objInfPos.DiseaseCourse = objRec.get('DiseaseCourse');
					
					//与感染相关的侵害性操作
					objInfPos.InfPosOpr = new Array();
					var InfPosOprValues = objRec.get('InfPosOprValues');
					InfPosOprValues = InfPosOprValues.replace(/<\$C2>/gi,CHR_2);
					var arrInfPosOpr = InfPosOprValues.split(CHR_1);
					for (var indOpr = 0; indOpr < arrInfPosOpr.length; indOpr++) {
						var strRec = arrInfPosOpr[indOpr];
						if (strRec == '') continue;
						var arrField = strRec.split(CHR_2);
						var objInfPosOpr = new Object();
						objInfPosOpr.InvasiveOper = obj.ClsSSDictionary.GetObjById(arrField[0]);
						objInfPosOpr.StartDate = ''; //Add By LiYang 2013-05-19 增加医院感染结束日期
						objInfPosOpr.StartTime = '';
						objInfPosOpr.EndDate = '';
						objInfPosOpr.EndTime = '';
						objInfPos.InfPosOpr.push(objInfPosOpr);
						
						//"与感染部位有关的侵害性操作"添加到"侵害性操作"项中
						var isActive = false;
						var arrInvasiveOperation = obj.CurrReport.ChildSumm.InvasiveOperation;
						for (var indInvOpr = 0; indInvOpr < arrInvasiveOperation.length; indInvOpr++) {
							var tmpDic = arrInvasiveOperation[indInvOpr];
							if (!tmpDic) continue;
							if (tmpDic.RowID == objInfPosOpr.InvasiveOper.RowID) {
								isActive = true;
							}
						}
						if (!isActive) {
							obj.CurrReport.ChildSumm.InvasiveOperation.push(objInfPosOpr.InvasiveOper);
						}
					}
					
					//数据完成性校验
					var rowerrinfo = '';
					if (!objInfPos.InfPos) {
						rowerrinfo = rowerrinfo + '感染部位&nbsp;'
					}
					if (!objInfPos.InfDate) {
						rowerrinfo = rowerrinfo + '感染日期&nbsp;'
					}
					if (!objInfPos.InfDiag) {
						rowerrinfo = rowerrinfo + '感染诊断&nbsp;'
					}
					if (objInfPos.InfPosOpr.length < 1) {
						//rowerrinfo = rowerrinfo + '与感染相关的侵害性操作&nbsp;'
					}
					if (rowerrinfo) {
						var row = objStore.indexOfId(objRec.id);  //获取行号
						rowerrinfo = rowerrinfo + '感染信息 第' + (row + 1) + '行 ' + rowerrinfo + '未填!<br>';
					}
					
					obj.CurrReport.ChildInfPos.push(objInfPos);
				}
			}
		}
		
		//数据完整性校验
		if (obj.CurrReport.ChildInfPos.length < 1) {
			errinfo = errinfo + '感染信息未填!<br>'
		}
		if (obj.CurrReport.ChildSumm.InfFactors.length < 1) {
			errinfo = errinfo + '易感因素未填!<br>'
		}
		if (obj.CurrReport.ChildSumm.InvasiveOperation.length < 1) {
			//errinfo = errinfo + '侵害性操作未填!<br>'
		}
		
		return errinfo;
	}
	
	return obj;
}