// /名称: 调价单
// /描述: 编辑调价单
// /编写者：zhangdongmei
// /编写日期: 2012.02.06
var rpdecimal=2;
var spdecimal=2;
var colArr=[];
Ext.onReady(function() {
	var userId = session['LOGON.USERID'];
	var HospId=session['LOGON.HOSPID'];
	var LocId=session['LOGON.CTLOCID'];
	var GroupId=session['LOGON.GROUPID'];
	//var LoginLocId = session['LOGON.COMMUNITYROWID'];   //DTHealth需要改一下
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	if(gParam.length<1){
		GetParams();  //初始化参数配置
	}	
	if(gParamCommon.length<1){
		GetParamCommon();  //初始化公共参数配置 wyx 公共变量取类组设置gParamCommon[9]

	}
	
		// 药品类组
		var StkGrpType=new Ext.ux.StkGrpComboBox({ 
			id : 'StkGrpType',
			name : 'StkGrpType',
			fieldLabel:'<font color=blue>类　　组</font>',
			StkType:App_StkTypeCode,     //标识类组类型
			LocId:LocId,
			UserId:userId,
			//width : 150
			anchor:'90%'
		}); 
		
		// 调价单号
		var AspBatNo = new Ext.form.TextField({
					fieldLabel : '调价单号',
					id : 'AspBatNo',
					name : 'AspBatNo',
					//width : 160
					anchor:'90%'
				});

		var StartDate=new Ext.ux.DateField({
			id:'StartDate',
			name:'StartDate',
			fieldLabel:'开始日期',
			//width:150,
			anchor:'90%',
			value:new Date().add(Date.DAY,-1)
		})
		
		var EndDate=new Ext.ux.DateField({
			id:'EndDate',
			name:'EndDate',
			fieldLabel:'截止日期',
			//width:150,
			value:new Date(),
			anchor:'90%'
		})
		
		var IncId=new Ext.form.TextField({
			id:'IncId',
			name:'IncId',
			value:''
		});
		
		var IncDesc=new Ext.form.TextField({
			id:'IncDesc',
			name:'IncDesc',
			fieldLabel:'药品名称',
			//width:150,
			anchor:'90%',
			listeners:{
				'specialkey':function(field,e){
					var keycode=e.getKey();
					if(keycode==13){
						var input=field.getValue();
						var stkgrpid=Ext.getCmp("StkGrpType").getValue();
						
						GetPhaOrderWindow(input, stkgrpid, App_StkTypeCode, "", "N","", HospId, getDrug);
					}
				}
			}
		});
		
		/**
		 * 返回方法
		*/
		function getDrug(record) {
			if (record == null || record == "") {
				return;
			}
			var inciDr = record.get("InciDr");
			var inciCode=record.get("InciCode");
			var inciDesc=record.get("InciDesc");
			Ext.getCmp("IncId").setValue(inciDr);
			Ext.getCmp("IncDesc").setValue(inciDesc);
		}
		// 查询
		var SearchBT = new Ext.Toolbar.Button({
				id : "SearchBT",
				text : '查询',
				tooltip : '点击查询',
				width : 70,
				height : 30,
				iconCls : 'page_find',
				handler : function() {
					AdjPriceSearch();
				}
		});

		//查询调价信息
		function AdjPriceSearch(){
			var stkgrpid=Ext.getCmp("StkGrpType").getValue();
			var stdate=Ext.getCmp("StartDate").getValue().format(App_StkDateFormat);
			var eddate=Ext.getCmp("EndDate").getValue().format(App_StkDateFormat);
			
			var inciDesc=Ext.getCmp("IncDesc").getValue();
			if (inciDesc==""){
				Ext.getCmp("IncId").setValue("");
			}
			var incid=Ext.getCmp("IncId").getValue();
			if(Ext.getCmp("IncDesc").getValue()==""){incid="";}			
			var aspno=Ext.getCmp("AspBatNo").getValue();
			
			var params=aspno+"^N^"+incid+"^"+stkgrpid;
			DetailStore.load({params:{start:0,limit:999,StartDate:stdate,EndDate:eddate,Others:params}});
		}
		// 清空按钮
		var ClearBT = new Ext.Toolbar.Button({
					id : "ClearBT",
					text : '清屏',
					tooltip : '点击清屏',
					width : 70,
					height : 30,
					iconCls : 'page_clearscreen',
					handler : function() {
						clearData();
					}
				});
		/**
		 * 清空方法
		 */
		function clearData() {	
			Ext.getCmp("StartDate").setValue(new Date().add(Date.DAY,-1));
			Ext.getCmp("EndDate").setValue(new Date());
			Ext.getCmp("StkGrpType").setValue("");
			StkGrpType.store.load();
			Ext.getCmp("AspBatNo").setValue("");
			Ext.getCmp("IncDesc").setValue("");			
			//Ext.getCmp("SupplyPhaLoc").setDisabled(0);
			DetailGrid.store.removeAll();
			DetailGrid.getView().refresh();
			// 变更按钮是否可用
			//changeButtonEnable("1^1^1^1^1^0^0^0");
		}
				/**
		 * 清空方法2 仅供“新建”使用
		 */
		function clearData2() {	
			Ext.getCmp("StartDate").setValue(new Date().add(Date.DAY,-1));
			Ext.getCmp("EndDate").setValue(new Date());
			//Ext.getCmp("StkGrpType").setValue("");
			//StkGrpType.store.load();
			Ext.getCmp("AspBatNo").setValue("");
			Ext.getCmp("IncDesc").setValue("");			
			//Ext.getCmp("SupplyPhaLoc").setDisabled(0);
			DetailGrid.store.removeAll();
			DetailGrid.getView().refresh();
			// 变更按钮是否可用
			//changeButtonEnable("1^1^1^1^1^0^0^0");
		}
  var AddDetailBT=new Ext.Button({
	text:'增加一条',
	tooltip:'',
	iconCls:'page_add',
	handler:function()
	{	
		addNewRow();
	}
});

var DelDetailBT=new Ext.Button({
	text:'删除一条',
	tooltip:'',
	iconCls:'page_delete',
	handler:function()
	{
		deleteDrug();
	}
});

		// 新建按钮
		var AddBT = new Ext.Toolbar.Button({
					id : "AddBT",
					text : '新建',
					tooltip : '点击新建',
					width : 70,
					height : 30,
					iconCls : 'page_add',
					handler : function() {
						clearData2();
						addNewRow();                        // 新增一行
							
					}
				});
		/**
		 * 新增一行
		 * 
		 */
		function addNewRow() {
			// 判断是否已经有添加行
			var aspReasonId="";
			var aspReason="";
			var aspRemark="";
			var preexedate="";
			var preexedate=new Date().add(Date.DAY,1);
			var rowCount = DetailGrid.getStore().getCount();
			if (rowCount > 0) {
				var rowData = DetailStore.data.items[rowCount - 1];
				var data = rowData.get("InciId");
				if (data == null || data.length <= 0) {
					Msg.info("warning", "已存在新建行!");
					return;
				}
				var aspno=rowData.get("AspNo");
				var curaspno=Ext.getCmp("AspBatNo").getValue();
				aspRemark=rowData.get("Remark");
				if(aspno!="" & aspno!=null & (curaspno==null || curaspno=="")){
					Msg.info("warning","不能追加，请选择某一调价单进行追加，如果要新建调价单，请先清空！");
					return;
				}
				//默认调价原因
				if(IfSetAspReason()=='Y'){
					aspReasonId=rowData.get("AdjReasonId");
					aspReason=rowData.get("AdjReason");
				}
				//默认计划生效日期
				if(gParam[2]=='Y'){
					preexedate=rowData.get("PreExecuteDate");
				}
			}
			var record = Ext.data.Record.create([{
						name : 'AspBatRowid',
						type : 'string'
					}, {
						name : 'Incib',
						type : 'string'
					}, {
						name : 'StkCatDesc',
						type : 'string'
					}, {
						name : 'InciId',
						type : 'string'
					}, {
						name : 'InciCode',
						type : 'string'
					}, {
						name : 'InciDesc',
						type : 'string'
					}, {
						name : 'AspUomId',
						type : 'string'
					}, {
						name : 'PriorSpUom',
						type : 'double'
					}, {
						name : 'MaxSp',
						type : 'double'
					},{
						name : 'ResultSpUom',
						type : 'double'
					},{
						name : 'DiffSpUom',
						type : 'double'
					}, {
						name : 'PriorRpUom',
						type : 'double'
					}, {
						name : 'ResultRpUom',
						type : 'double'
					},{
						name : 'DiffRpUom',
						type : 'double'
					}, {
						name : 'AdjDate',
						type : 'date'
					}, {
						name : 'PreExecuteDate',  //计划生效日期
						type : 'date'
					}, {
						name : 'ExeDate',  //实际生效日期
						type : 'date'
					}, {
						name : 'AdjReasonId',
						type : 'string'
					},{
						name:'AdjReason',
						type:'string'
					},{
						name : 'MarkType',
						type : 'string'
					}, {
						name : 'WarrentNo',      //物价文件号
						type : 'string'
					}, {
						name : 'WnoDate',      //物价文件日期
						type : 'string'
					},{
						name : 'InvNo',      		//发票号，发票号
						type : 'string'
					}, {
						name : 'InvDate',      	//发票日期,发票日期
						type : 'string'
					}, {
						name : 'Remark',
						type : 'string'
					}, {
						name : 'AspNo',
						type : 'string'
					}, {
						name : 'AdjUserName',
						type : 'string'
					}, {
			            name: 'FreeDrugFlag',
			            type: 'string'
			        }]);
			var NewRecord = new record({
						AspBatId : '',
						Incib:'',
						StkCatDesc: '',
						InciId : '',
						InciCode : '',
						InciDesc : '',
						AspUomId : '',
						PriorSpUom : 0,
						MaxSp : 0,
						ResultSpUom : 0,
						DiffSpUom : 0,
						PriorRpUom : 0,
						ResultRpUom : 0,
						DiffRpUom : 0,
						AdjDate : new Date(),
						PreExecuteDate : preexedate,
						AdjReasonId:aspReasonId,
						AdjReason:aspReason,
						MarkType : '',
						WarrentNo : '',
						WarrentDate:'',
						InvNo:'',
						InvDate:'',
						Remark : aspRemark,
						AspNo : '',
						AdjUserName : '',
						FreeDrugFlag:''
					});
			DetailStore.add(NewRecord);
			var colindex=GetColIndex(DetailGrid,"InciDesc");
			DetailGrid.getSelectionModel().select(DetailStore.getCount() - 1, colindex);
			DetailGrid.startEditing(DetailStore.getCount() - 1, colindex);

		};

		// 保存按钮
		var SaveBT = new Ext.Toolbar.Button({
					id : "SaveBT",
					text : '保存',
					tooltip : '点击保存',
					width : 70,
					height : 30,
					iconCls : 'page_save',
					handler : function() {
						if(CheckDataBeforeSave()==true){
							// 保存调价单
							save();
							// 变更按钮是否可用
							//changeButtonEnable("0^0^1^1^1^1^1^1");
						}
					}
				});

	function CheckDataBeforeSave(){
		var rowCount = DetailGrid.getStore().getCount();
		if (rowCount<=0) 
			{ 
				Msg.info("warning","没有调价记录!");	return false;}			
		 
		for (var i = 0; i < rowCount; i++) {
			var rowData = DetailStore.getAt(i);
			 
			//新增或数据发生变化时执行下述操作
			if(rowData.data.newRecord || rowData.dirty){
				
				var ResultSp = rowData.get("ResultSpUom");
				var ResultRp = rowData.get("ResultRpUom");
				var freedrugflag=rowData.get('FreeDrugFlag');
				if((freedrugflag=="Y")&&((ResultRp!=0)||(ResultSp!=0))){
					Msg.info("warning", "第"+(i+1)+"行免费药调后进价和调后售价都必须为0!");
					return false;
					break;
				}
				var AdjSpReasonId = rowData.get("AdjReasonId");
				var AdjSpUomId = rowData.get("AspUomId");
				var PriceFileDate =Ext.util.Format.date(rowData.get("PreExecuteDate"),'Y-m-d');
				var unequalflag=CheckRpEqualSp(i);
				if (unequalflag==false)
				{	
					Msg.info("warning","第"+(i+1)+"行药品为零加成,进售价不符,请核实！");

				}
				if (ResultSp == null || ResultSp.length <= 0) {
					Msg.info("warning", "第"+(i+1)+"行调后售价不能为空!");
					return false;
					break;
				}
				
				if (ResultSp == null || ResultSp.length <= 0) {
					Msg.info("warning", "第"+(i+1)+"行调后售价不能为空!");
					return false;
					break;
				}
				if (AdjSpUomId == null || AdjSpUomId.length <= 0) {
					Msg.info("warning", "第"+(i+1)+"行单位不能为空!");
					return false;
					break;
				}
				if (PriceFileDate == null || PriceFileDate.length <= 0) {
					Msg.info("warning", "第"+(i+1)+"行计划生效日期不能为空!");
					return false;
					break;
				}
				var nowdate = new Date();
				if (PriceFileDate <= nowdate.format("Y-m-d")) {
					Msg.info("warning", "第"+(i+1)+"行计划生效日期不能小于或等于当前日期!");
					return false;
					break;
				}
				if (AdjSpReasonId == null || AdjSpReasonId.length <= 0) {
					Msg.info("warning", "第"+(i+1)+"行调价原因不能为空!");
					return false;
					break;
				}
				
			}	
		}	
		return true;
	}
		/*根据药品判断是否零加成*/
	function CheckRpEqualSp(rownum)
	{
		var adjsaleData = DetailStore.getAt(rownum);
		var adjsaleInci = adjsaleData.get("InciId");  //药品id
		///判断药品类组
		var equalflag=tkMakeServerCall("web.DHCST.Common.AppCommon","GetZeroMarginByInci",adjsaleInci,GroupId,LocId,userId)   //是否需要售价等于进价
		if (equalflag!="Y")
		{
			return true;
		}
	    var ResultSp = adjsaleData.get("ResultSpUom");
		var ResultRp = adjsaleData.get("ResultRpUom");
		if (ResultSp!=ResultRp)
		{
			return false;
		}	
	}

		/**
		 * 保存调价单
		 */
		function save() {
			//调价单号
			var AspBatNo = Ext.getCmp("AspBatNo").getValue();
			var StkGrp=Ext.getCmp("StkGrpType").getValue();
			if((StkGrp=="")&&(gParamCommon[9]=='N')){
			    Msg.info("warning","当前参数设置类组不允许为空!");	
				return ;
			}
			var list="";
			//保存明细
			var rowCount = DetailGrid.getStore().getCount();
			
			if (rowCount==0) 
			
			{Msg.info("warning","没有调价记录!");	return ;}
			for (var i = 0; i < rowCount; i++) {
				var rowData = DetailStore.getAt(i);
			 
				//新增或数据发生变化时执行下述操作
				if(rowData.data.newRecord || rowData.dirty){
					
					
					var AspBatId = rowData.get("AspBatId");
					var Incib = rowData.get("Incib");
					var IncRowid = rowData.get("InciId");
					
					if(IncRowid=="" || IncRowid.length<=0)
					{
						//移除空行
						DetailGrid.getStore().remove(rowData);
						break;
					}
					
					var PreExecuteDate =Ext.util.Format.date(rowData.get("PreExecuteDate"),App_StkDateFormat);
					/*
					if((PreExecuteDate!="")&(PreExecuteDate!=null)){
						PreExecuteDate=PreExecuteDate.format('Y-m-d');
					}*/
					var IncDesc=rowData.get("InciDesc");
					var AdjSpUomId = rowData.get("AspUomId");
					var ResultSp = rowData.get("ResultSpUom");
					var ResultRp = rowData.get("ResultRpUom");
					if (ResultSp<ResultRp) {
						Msg.info("warning", "第"+(i+1)+"行调后售价小于调后进价!");
						return false;
						break;
					}
					var AdjSpReasonId = rowData.get("AdjReasonId");
					//alert(AdjSpReasonId)
					
					var PriceFileNo = rowData.get("WarrentNo");
					var PriceFileDate =Ext.util.Format.date(rowData.get("WnoDate"),'Y-m-d');;
					var Remark = rowData.get("Remark");
					var PriorRp=rowData.get("PriorRpUom");
					var PriorSp=rowData.get("PriorSpUom");
					var data =AspBatId+"^"+Incib+"^"+ PreExecuteDate + "^" + IncRowid + "^" + AdjSpUomId + "^"
							+ ResultSp + "^" + ResultRp + "^" + userId+ "^" + AdjSpReasonId+ "^" + HospId+ "^" 
							+ PriceFileNo +"^" + PriceFileDate +"^" + Remark+"^"+PriorRp+"^"+PriorSp;
					
					if(list==""){
						list=data;
					}else{
						list=list+xRowDelim()+data;
					}					
				}
			}
			if (list==""){
				Msg.info("warning","没有需要保存的数据");
				return;						
			}
			var mask=ShowLoadMask(Ext.getBody(),"处理中请稍候...");
			var url = DictUrl+ "inadjpriceactionbatch.csp?actiontype=Save";
			Ext.Ajax.request({
				url : url,
				method : 'POST',
				params: {AspNo:AspBatNo,StkGrp:StkGrp,LocId:LocId,list:list},
				waitMsg : '保存中...',
				success : function(result, request) {
					var jsonData = Ext.util.JSON
							.decode(result.responseText);
					mask.hide();
					if (jsonData.success == 'true') {
						Msg.info("success","保存成功!");
						// 回传
						if(AspBatNo==""){
							AspBatNo = jsonData.info;
							Ext.getCmp("AspBatNo").setValue(AspBatNo);
						}						
						AdjPriceSearch();
						
					} else {
						var ret=jsonData.info;
						var arr=ret.split("^");
						ret=arr[0];
						var IncDesc=arr[1];
						if(ret==-5){
							Msg.info("error", IncDesc+"存在未生效的调价单，不能新建调价单！");
						}else if(ret==-7){
							Msg.info("error", IncDesc+"当天已调价，不能再建调价单！");
						}else if(ret==-1){
							Msg.info("error", "药品"+IncDesc+"Id不能为空！");
						}else if(ret==-2){
							Msg.info("error", "药品"+IncDesc+"无效！");
						}else if(ret==-3){
							Msg.info("error", "调价单号不能为空！");
						}else if(ret==-4){
							Msg.info("error", "计划生效日期不能为空！");
						}else{
							Msg.info("error", IncDesc+"保存失败："+jsonData.info);
						}
					}
				},
				scope : this
			});	
		
		}

		/**
		 * 删除选中行药品
		 */
		function deleteDrug() {
			
			var cell = DetailGrid.getSelectionModel().getSelectedCell();
			if (cell == null) {
				Msg.info("warning", "没有选中行!");
				return;
			}
			// 选中行
			var row = cell[0];
			var record = DetailGrid.getStore().getAt(row);
			var AspBatId = record.get("AspBatId");
			if (AspBatId == null || AspBatId.length <= 0) {
				DetailGrid.getStore().remove(record);
				DetailGrid.getView().refresh();
			} else {
				Ext.MessageBox.show({
							title : '提示',
							msg : '是否确定删除该药品调价信息',
							buttons : Ext.MessageBox.YESNO,
							fn : showResult,
							icon : Ext.MessageBox.QUESTION
						});

			}
		}
		/**
		 * 删除提示
		 */
		function showResult(btn) {
			if (btn == "yes") {
				var cell = DetailGrid.getSelectionModel().getSelectedCell();
				var row = cell[0];
				var record = DetailGrid.getStore().getAt(row);
				var AspBatId = record.get("AspBatId");
				;
				// 删除该行数据
				var url = DictUrl
						+ "inadjpriceactionbatch.csp?actiontype=DeleteAspBatItm&AspBatId="
						+ AspBatId;
               var mask=ShowLoadMask(Ext.getBody(),"处理中请稍候...");
				Ext.Ajax.request({
							url : url,
							method : 'POST',
							waitMsg : '删除中...',
							success : function(result, request) {
								var jsonData = Ext.util.JSON
										.decode(result.responseText);
									mask.hide();
								if (jsonData.success == 'true') {
									Msg.info("success", "删除成功!");
									DetailGrid.getStore().remove(record);
									DetailGrid.getView().refresh();
								} else {
									Msg.info("error", "删除失败："+jsonData.info);
								}
							},
							scope : this
						});
			}
		}
	
		// 单位
		var CTUom = new Ext.form.ComboBox({
					fieldLabel : '单位',
					id : 'CTUom',
					name : 'CTUom',
					anchor : '90%',
					width : 120,
					store : ItmUomStore,
					valueField : 'RowId',
					displayField : 'Description',
					allowBlank : false,
					triggerAction : 'all',
					emptyText : '单位...',
					selectOnFocus : true,
					forceSelection : true,
					minChars : 1,
					pageSize : 10,
					listWidth : 250,
					valueNotFoundText : ''
				});
				
		ReasonForAdjSpStore.load();
		var AdjSpReason = new Ext.form.ComboBox({
					fieldLabel : '调价原因',
					id : 'AdjSpReason',
					name : 'AdjSpReason',
					anchor : '90%',
					width : 100,
					store : ReasonForAdjSpStore,
					valueField : 'RowId',
					displayField : 'Description',
					allowBlank : false,
					triggerAction : 'all',
					emptyText : '调价原因...',
					selectOnFocus : true,
					forceSelection : true,
					listWidth : 150,
					minChars : 1,
					valueNotFoundText : ''
				});
				
		
				
		function rendererReason(value, p, r) {
			var combo = Ext.getCmp('AdjSpReason');
			var index = ReasonForAdjSpStore.find(combo.valueField, value);
			var record = ReasonForAdjSpStore.getAt(index);
			var recordv = combo.findRecord(combo.valueField, value);
			if (value == '' || !recordv) {
				return value;
			}
			var displayText = "";
			if (record == null) {
				displayText = value;
			} else {
				displayText = recordv.get(combo.displayField);
			}
			return displayText;
		}
		
		var ADJRSNCommStore = new Ext.data.Store({
			proxy : "",
			reader : new Ext.data.JsonReader({
				totalProperty : "results",
				root : 'rows'
			}, ['Description', 'RowId'])
		});
		
		ADJRSNCommStore.on('beforeload', function(ds, o){
			ds.proxy=new Ext.data.HttpProxy({url : 'dhcst.otherutil.csp?actiontype=ReasonForAdjSpStore&start=0&limit=1000',method:'GET'});
			
		});
		
		var ADJRSNComm = new Ext.form.ComboBox({
			fieldLabel : '调价原因',
			id : 'ADJRSNComm',
			name : 'ADJRSNComm',
			anchor : '90%',
			width : 120,
			store : ADJRSNCommStore,
			valueField : 'RowId',
			displayField : 'Description',
			//allowBlank : false,
			triggerAction : 'all',
			emptyText : '调价原因...',
			selectOnFocus : true,
			forceSelection : true,
			minChars : 1,
			//pageSize : 10,
			listWidth : 250,
			valueNotFoundText : '',
			listeners : {
				specialkey : function(field, e) {
					if (e.getKey() == Ext.EventObject.ENTER) {
						if(setEnterSort(DetailGrid,colArr)){
								addNewRow();
						}
					}
				}
			}
		});	

		//录入调后进价后设置调后售价
		function SetMtSp(Rp){
			var cell = DetailGrid.getSelectionModel().getSelectedCell();
			var record = DetailGrid.getStore().getAt(cell[0]);
			var uomId=record.get("AspUomId");
			var inci=record.get("InciId");
			if(inci==null || inci==""){
				return;
			}
			if(uomId==null || uomId==""){
				return;
			}
			if(Rp==null || Rp==""){
				return;
			}
			//零加成默认售价等于进价
			var equalflag=tkMakeServerCall("web.DHCST.Common.AppCommon","GetZeroMarginByInci",inci,GroupId,LocId,userId)   //是否需要售价等于进价
			if (equalflag=="Y")
			{
				record.set("ResultSpUom",Rp);
			}

			//根据定价类型计算售价
			if((equalflag!="Y")&&(GetCalSpFlag()==1)){				
				var url=DictUrl+"inadjpriceactionbatch.csp?actiontype=GetMtSp&InciId="+inci+"&UomId="+uomId+"&Rp="+Rp;
				var sp=ExecuteDBSynAccess(url);
				if(sp==0){
					Msg.info("warning","调后售价为0，请检查该药品定价类型是否正确！");
				}
				record.set("ResultSpUom",sp);
			}
		}
		// 调价明细
		// 访问路径
		var DetailUrl =DictUrl+ "inadjpriceactionbatch.csp?actiontype=QueryAspBatInfo";
		// 通过AJAX方式调用后台数据
		var proxy = new Ext.data.HttpProxy({
					url : DetailUrl,
					method : "GET"
				});
		
		// 指定列参数
		var fields = ["AspBatId","AspBatNo","BatExp","Incib", "StkCatDesc", "InciId", "InciCode","InciDesc", "AspUomId","AspUomDesc",
				"PriorSpUom", "MaxSp", "ResultSpUom", "DiffSpUom","PriorRpUom", "ResultRpUom", "DiffRpUom",{name:'AdjDate',type:'date',dateFormat:App_StkDateFormat}, 
				{name:'PreExecuteDate',type:'date',dateFormat:App_StkDateFormat},"MarkType", "WarrentNo",{name: "WnoDate",type:'date',dateFormat:App_StkDateFormat}, 
				,"AdjReasonId", "AdjReason","Remark", "AdjUserName","BUomId","ConFacPur","FreeDrugFlag"];
		// 支持分页显示的读取方式
		var reader = new Ext.data.JsonReader({
					root : 'rows',
					totalProperty : "results",
					id : "AspBatId",
					fields : fields
				});
		// 数据集
		var DetailStore = new Ext.data.Store({
					proxy : proxy,
					reader : reader
				});
		DetailStore.on("update",function(store,record,opt){
			var priorsp=record.get("PriorSpUom");
			var resultsp=record.get("ResultSpUom");
			var priorrp=record.get("PriorRpUom");
			var resultrp=record.get("ResultRpUom");
			record.set("DiffSpUom",Math.round((resultsp-priorsp)*10000)/10000);
			record.set("DiffRpUom",Math.round((resultrp-priorrp)*10000)/10000);
		});
		var nm = new Ext.grid.RowNumberer();
		var DetailCm = new Ext.grid.ColumnModel([nm, {
					header : "AspBatId",
					dataIndex : 'AspBatId',
					width : 100,
					align : 'left',
					sortable : true,
					hidden : true
				}, {
					header : "调价单号",
					dataIndex : 'AspBatNo',
					width : 120,
					align : 'right',
					sortable : true
				}, {
					header : "Incib",
					dataIndex : 'Incib',
					width : 80,
					align : 'left',
					sortable : true,
					hidden : true
				}, {
					header : "RowId",
					dataIndex : 'InciId',
					width : 80,
					align : 'left',
					sortable : true,
					hidden : true
				}, {
					header : '药品代码',
					dataIndex : 'InciCode',
					width : 80,
					align : 'left',
					sortable : true
				}, {
					header : '药品名称',
					dataIndex : 'InciDesc',
					width : 230,
					align : 'left',
					sortable : true,
					editor : new Ext.grid.GridEditor(new Ext.form.TextField({
								selectOnFocus : true,
								allowBlank : false,
								listeners : {
									specialkey : function(field, e) {
										if (e.getKey() == Ext.EventObject.ENTER) {
											
											var group = Ext
													.getCmp("StkGrpType")
													.getValue();
											//GetPhaOrderInfo(field.getValue(),
													//group);
											var stkgrp = Ext.getCmp("StkGrpType").getValue();
									             GetPhaOrderInfoBat(field.getValue(), stkgrp);
										}
									}
								}
							}))
				}, {
				       header : "批次/效期",
				       dataIndex : 'BatExp',
				       width : 150,
				       align : 'left',
				       sortable : true
			       }, {
					header : "调价单位",
					dataIndex : 'AspUomId',
					width : 80,
					align : 'left',
					sortable : true,
					editor : new Ext.grid.GridEditor(CTUom),
					renderer : Ext.util.Format.comboRenderer2(CTUom,"AspUomId","AspUomDesc") // pass combo instance to reusable renderer					
				}, {
					header : "调前售价",
					dataIndex : 'PriorSpUom',
					width : 90,
					align : 'right',
					sortable : true
				}, {
					header : "调前进价",
					dataIndex : 'PriorRpUom',
					width : 90,
					align : 'right',
					sortable : true
				}, {
					header : "调后进价",
					dataIndex : 'ResultRpUom',
					width : 90,
					align : 'right',
					sortable : true,
					editor : new Ext.grid.GridEditor(new Ext.form.NumberField({
						selectOnFocus : true,
						id:'ResultRpUomEditor',
						allowBlank : false,
						allowNegative : false,
						listeners : {
							'blur' : function(field, e) {
						
									var resultRpNew = field.getValue();
									if (resultRpNew == null || resultRpNew.length <= 0) {
										Msg.info("warning", "调后进价不能为空!");
										return;
									}
									var cell = DetailGrid.getSelectionModel().getSelectedCell();
									var rowData = DetailStore.getAt(cell[0]);
									var freedrugflag=rowData.get('FreeDrugFlag');
									if((freedrugflag=="Y")&&(resultRpNew!=0)){
										Msg.info("warning", "第"+(cell[0]+1)+"行免费药调后进价必须为0!");
										return;
									}
								},
							'change':function(field,e){
									var resultRpNew = field.getValue();
									var cell = DetailGrid.getSelectionModel().getSelectedCell();
									var rowData = DetailStore.getAt(cell[0]);
									var freedrugflag=rowData.get('FreeDrugFlag');
									if((freedrugflag=="Y")&&(resultRpNew!=0)){
										//Msg.info("warning", "免费药调后进价必须为0!");
										return;
									}
									SetMtSp(resultRpNew);
							},
							'specialkey': function(field, e) {
								if (e.getKey() == Ext.EventObject.ENTER) {
									var resultRpNew = field.getValue();
									var cell = DetailGrid.getSelectionModel().getSelectedCell();
									var record = DetailGrid.getStore().getAt(cell[0]);
									var freedrugflag=record.get('FreeDrugFlag');
									if((freedrugflag=="Y")&&(resultRpNew!=0)){
										//Msg.info("warning", "免费药调后进价必须为0!");
										return;
									}
									SetMtSp(resultRpNew);
									if(setEnterSort(DetailGrid,colArr)){
											addNewRow();
									}
									
								}
							}
						}
					}))
				}, {
					header : "调后售价",
					dataIndex : 'ResultSpUom',
					width : 80,
					align : 'right',
					sortable : true,
					editor : new Ext.grid.GridEditor(new Ext.form.NumberField({
						selectOnFocus : true,
						allowBlank : false,
						allowNegative : false,
						id:'ResultSpUomEditor',
						listeners : {
							'change' : function(field, newValue,oldValue) {
									var resultSpNew = field.getValue();
									if (resultSpNew == null || resultSpNew.length <= 0) {
										Msg.info("warning", "调后售价不能为空!");
										return;
									}
									var cell = DetailGrid.getSelectionModel().getSelectedCell();
									var rowData = DetailStore.getAt(cell[0]);
									var freedrugflag=rowData.get('FreeDrugFlag');
									if((freedrugflag=="Y")&&(resultSpNew!=0)){
										//Msg.info("warning", "免费药调后售价必须为0!");
										return;
									}
							},
							'blur':function(field,e){
									var resultSpNew = field.getValue();
									if (resultSpNew == null || resultSpNew.length <= 0) {
										Msg.info("warning", "调后售价不能为空!");
										return;
									}
									var cell = DetailGrid.getSelectionModel().getSelectedCell();
									var rowData = DetailStore.getAt(cell[0]);
									var ResultSp = field.getValue();
					                var ResultRp = rowData.get("ResultRpUom");
					                var freedrugflag=rowData.get('FreeDrugFlag');
									if((freedrugflag=="Y")&&(ResultSp!=0)){
										Msg.info("warning", "第"+(cell[0]+1)+"行免费药调后售价必须为0!");
										return;
									}
					                var MaxSp= rowData.get("MaxSp");
					                if((ResultSp<ResultRp)&(MaxSp!="")){
					                 Msg.info("warning", "第"+(cell[0]+1)+"行调后售价小于调后进价!");
				                      }
					                if((MaxSp<ResultSp)&(MaxSp!="")){
					                 Msg.info("warning", "第"+(cell[0]+1)+"行调后售价大于最高售价!");
				                        return;
				                      }	
				                     var colindex=GetColIndex(DetailGrid,"ResultSpUom");
									DetailGrid.stopEditing(cell[0], colindex);
				                    var unequalflag=CheckRpEqualSp(cell[0]);
									if (unequalflag==false)
									{	
										Msg.info("warning","该药品为零加成,进售价不符,请核实!");
									}	
							},
							'specialkey': function(field, e) {
								if (e.getKey() == Ext.EventObject.ENTER) {
                                        var cell = DetailGrid.getSelectionModel().getSelectedCell();
                                        var record = DetailGrid.getStore().getAt(cell[0]);  
					                    var ResultSp = field.getValue();
						                var freedrugflag=record.get('FreeDrugFlag');
										if((freedrugflag=="Y")&&(ResultSp!=0)){
											//Msg.info("warning", "免费药调后售价必须为0!");
											return;
										}
										var MaxSp=record.get("MaxSp");
					                    if((MaxSp!="")&&(MaxSp<ResultSp)){
											Msg.info("warning", "调后售价大于最高售价!");
				                            return;
				                        }								
								
										if(setEnterSort(DetailGrid,colArr)){
											addNewRow();
										}	
								}
							}
						}
					}))
				}, {
					header : "差价(售价)",
					dataIndex : 'DiffSpUom',
					width : 90,
					align : 'right',
					sortable : true
				}, {
					header : "差价(进价)",
					dataIndex : 'DiffRpUom',
					width : 90,
					align : 'right',
			
					sortable : true
				}, {
					header : "最高售价",
					dataIndex : 'MaxSp',
					width : 80,
					align : 'right',
					sortable : true
				}, {
					header : "计划生效日期",
					dataIndex : 'PreExecuteDate',
					align : 'center',
					sortable : true,
					renderer : Ext.util.Format.dateRenderer(App_StkDateFormat),
					editor : new Ext.ux.DateField({
						selectOnFocus : true,
						allowBlank : false,
						format : App_StkDateFormat,
						listeners : {
							///specialkey : function(field, e) {
							'change' :function(field, e) {
								///if (e.getKey() == Ext.EventObject.ENTER) {
									
									var expDate = field.getValue();
									if (expDate == null || expDate.length <= 0) {
										Msg.info("warning", "计划生效日期不能为空!");
										return;
									}

									var nowdate = new Date();
									if (expDate.format("Y-m-d") <= nowdate.format("Y-m-d")) {
										Msg.info("warning", "计划生效日期不能小于或等于当前日期!");
										return;
									}
									///addNewRow();
								///}
							},
							'specialkey': function(field, e) {
								
								if (e.getKey() == Ext.EventObject.ENTER) {
									if(setEnterSort(DetailGrid,colArr)){
											addNewRow();
									}
									
								}
							}
						}
					})
				}, {
					header : "制单日期",
					dataIndex : 'AdjDate',
					width : 80,
					align : 'center',
					sortable : true,
					renderer : Ext.util.Format.dateRenderer(App_StkDateFormat)					
				}, {
					header:'实际生效日期',
					width : 100,
					dataIndex:'ExeDate',
					align : 'center',
					renderer : Ext.util.Format.dateRenderer(App_StkDateFormat)
				}, {
					header : "定价类型",
					dataIndex : 'MarkType',
					width : 80,
					align : 'left',
					sortable : true
				}, {
					header : "物价文件号",
					dataIndex : 'WarrentNo',
					width : 80,
					align : 'left',
					sortable : true,
					editor: new Ext.form.TextField({
                    	allowBlank: true,
                    	listeners : {
							specialkey : function(field, e) {
								if (e.getKey() == Ext.EventObject.ENTER) {
									if(setEnterSort(DetailGrid,colArr)){
											addNewRow();
									}
								}
							}
						}
                	})
				}, {
					header : "物价文件日期",
					dataIndex : 'WnoDate',
					width : 100,
					align : 'center',
					sortable : true,
					renderer : Ext.util.Format.dateRenderer(App_StkDateFormat),
					editor : new Ext.ux.DateField({
						selectOnFocus : true,
						allowBlank : false,
						format : App_StkDateFormat,
						listeners : {
							specialkey : function(field, e) {
								if (e.getKey() == Ext.EventObject.ENTER) {
									if(setEnterSort(DetailGrid,colArr)){
											addNewRow();
									}
								}
							}
						}
					})
				},{
					header : "调价原因",
					dataIndex : 'AdjReasonId',
					width:80,
		        	align:'left',
		        	sortable:true,
					renderer:rendererReason,
					editor:new Ext.grid.GridEditor(ADJRSNComm)
					//editor : new Ext.grid.GridEditor(AdjSpReason),
					//renderer : Ext.util.Format.comboRenderer(AdjSpReason) // pass combo instance to reusable renderer
				}, {
					header : "调价人",
					dataIndex : 'AdjUserName',
					width : 80,
					align : 'left',
					sortable : true
				},{
					header : "库存分类",
					dataIndex : 'StkCatDesc',
					width : 80,
					align : 'left',
					sortable : true
				},{
					header : "备注",
					dataIndex : 'Remark',
					width : 350,
					align : 'left',
					sortable : true,
					renderer:formatQtip,
					editor: new Ext.form.TextField({
                    	allowBlank: true,
						listeners : {
							specialkey : function(field, e) {
								if (e.getKey() == Ext.EventObject.ENTER) {
									if(setEnterSort(DetailGrid,colArr)){
											addNewRow();
									}
								}
							}
						}
					})
				 }, {
		            header: "免费药标识",
		            dataIndex: 'FreeDrugFlag',
		            width: 80,
		            align: 'left',
		            sortable: true
		        }]);
		var GridColSetBT = new Ext.Toolbar.Button({
	      text:'列设置',
          tooltip:'列设置',
          iconCls:'page_gear',
          //	width : 70,
         //	height : 30,
	      handler:function(){
		    GridColSet(DetailGrid,"DHCSTADJSPBATCH");
	      }
        });
		var DetailGrid = new Ext.grid.EditorGridPanel({
					id : 'DetailGrid',
					title : '调价单明细(批次)',
					//region:'center',
					cm : DetailCm,
					store : DetailStore,
					trackMouseOver : true,
					stripeRows : true,
					loadMask : true,
					tbar:[AddDetailBT,'-',DelDetailBT,'-',GridColSetBT],
					sm : new Ext.grid.CellSelectionModel({}),
					clicksToEdit : 1,
					listeners:{
						'beforeedit':function(e)
						{
							if (e.field=='AdjReasonId'){
								if (e.record.data['AdjReasonId']!='') ADJRSNComm.setValue(e.record.data['AdjReasonId']);
							}
							/*取配置,动态设置小数保留位数,yunhaibao201511224*/
							if((e.field=="ResultRpUom")||(e.field=="ResultSpUom")){
								  var adjpriceuomid=e.record.get('AspUomId');
								  var adjpriceinci=e.record.get('InciId');
								  var decimalstr=tkMakeServerCall("web.DHCST.Common.AppCommon","GetDecimalCommon",GroupId,LocId,userId,adjpriceinci,adjpriceuomid);
								  var decimalarr=decimalstr.split("^");
								  Ext.getCmp("ResultRpUomEditor").decimalPrecision=decimalarr[0];
								  Ext.getCmp("ResultSpUomEditor").decimalPrecision=decimalarr[2];
							}
						}
					
						
					}
				});

	/*
		DetailGrid.addListener("rowcontextmenu",function(grid,rowindex,e){
			e.preventDefault();
			menu.showAt(e.getXY());
			
		});*/
		DetailGrid.addListener("rowclick",function(grid,rowindex,e){
			if(rowindex>=0){
				var record=DetailGrid.getStore().getAt(rowindex);
				var aspno=record.get("AspBatNo");
				if(aspno!=null & aspno!=""){
					Ext.getCmp("AspBatNo").setValue(aspno);
				}
			}
		});
		var menu=new Ext.menu.Menu({
			id:'rightMenu',
			height:30,
			items:[{
				id:'delete',
				text:'删除',
				handler:deleteDrug
			}]
		});
		
		/**
		 * 调用药品窗体并返回结果
		 */
		function GetPhaOrderInfo(item, group) {
						
			if (item != null && item.length > 0) {
				GetPhaOrderWindow(item, group,App_StkTypeCode, "", "N", "0", "",
						getDrugList);
			}
		}
		/**
		 * 调用药品窗体并返回结果批次
		 */
		function GetPhaOrderInfoBat(item, stkgrp) {
			if (item != null && item.length > 0) {
				IncItmBatWindowAll(item, stkgrp,LocId, App_StkTypeCode, "N", "",
						getDrugList);
			}
		}

		function addComboData(store, id, desc) {
			var defaultData = {
			RowId : id,
			Description : desc
			};
			var r = new store.recordType(defaultData);
			store.add(r);
		}	

		//检查是否已经录入了某药品的调价记录
		function CheckRepeatItm(incib){
			var flag=false;  //不重复
			var rowCount=DetailGrid.getStore().getCount()-1;
			for(var i=rowCount-1;i>=0;i--){
				var rowData=DetailGrid.getStore().getAt(i);
				var incIB=rowData.get("Incib");
				if(incIB==incib){
					flag=true;
					break;
				}
			}
			
			return flag;
		}
		/**
		 * 返回方法
		*/
		function getDrugList(record) {
			if (record == null || record == "") {
				return;
			}
			var incib=record.get("Incib");
			var inciDr = record.get("InciDr");
			var inciCode=record.get("InciCode");
			var inciDesc=record.get("InciDesc");
			var batExp=record.get("BatExp");
			var rp=record.get("Rp");
			var sp=record.get("Sp");
			if(CheckRepeatItm(incib)==true){
				Msg.info("warning","该批次药品调价记录已经录入，不能重复录入");
				return;
			}
			var cell = DetailGrid.getSelectionModel().getSelectedCell();
			// 选中行
			var row = cell[0];
			var rowData = DetailGrid.getStore().getAt(row);
			rowData.set("Incib",incib);
			rowData.set("InciId",inciDr);
			rowData.set("InciCode",inciCode);
			rowData.set("InciDesc",inciDesc);
			rowData.set("BatExp",batExp)
			rowData.set("PriorSpUom", sp); 
			rowData.set("PriorRpUom", rp);
			rowData.set("ResultSpUom", sp); 
			rowData.set("ResultRpUom", rp);
			;
			//取其它药品信息//modify 由于价格信息都从in_adjpricebatch调取，此处调用的都是药品的辅助信息故不用再重写
			var url = DictUrl
				+ "inadjpriceaction.csp?actiontype=GetItmInfo&InciId="
				+ inciDr+"&Params="+GroupId+"^"+LocId+"^"+userId;

			Ext.Ajax.request({
						url : url,
						method : 'GET',
						waitMsg : '查询中...',
						success : function(result, request) {
							var jsonData = Ext.util.JSON
									.decode(result.responseText);
							if (jsonData.success == 'true') {
								
								var data=jsonData.info.split("^");
								rowData.set("StkCatDesc", data[3]);
								rowData.set("MarkType", data[5]);
								rowData.set("WarrentNo", data[10]);
								rowData.set("MaxSp", data[13]);
								var BUomId=data[6];
								var BUomDesc=data[7];
								var PurUomId=data[8];
								var PurUomDesc=data[9];
								var ConFacPur=data[14];     //大单位到小单位之间的转换关系
								
								addComboData(ItmUomStore,PurUomId,PurUomDesc);
								rowData.set("AspUomId", PurUomId);    //默认为大单位调价
								//rowData.set("PriorSpUom", data[11]); 
								//rowData.set("PriorRpUom", data[12]); 
								rowData.set("BUomId", BUomId); 
								rowData.set("ConFacPur", ConFacPur); 
								rowData.set("WnoDate", Date.parseDate(data[16],App_StkDateFormat));
								var ss=new Date().format(App_StkDateFormat)
								rowData.set("AdjDate", Date.parseDate(ss,App_StkDateFormat)); 
								rowData.set("FreeDrugFlag", data[17]);
								//光标跳到调后售价
									if(setEnterSort(DetailGrid,colArr)){
											addNewRow();
									}
							} 
						},
						scope : this
					});
			
			/*
			//加载调价单位
			ItmUomStore.proxy = new Ext.data.HttpProxy({
								url : DictUrl
										+ 'orderutil.csp?actiontype=INCIUom&ItmRowid='
										+ inciDr
							});
			ItmUomStore.reload();
			//取药品信息
			getItmInfo(inciDr);  */
			
		}
		
		/**
		 * 单位展开事件
		 */
		CTUom.on('expand', function(combo) {
					var cell = DetailGrid.getSelectionModel().getSelectedCell();
					var record = DetailGrid.getStore().getAt(cell[0]);
					var IncRowid = record.get("InciId");
					/*
					var url = DictUrl
							+ 'drugutil.csp?actiontype=INCIUom&ItmRowid='
							+ IncRowid;
					ItmUomStore.proxy = new Ext.data.HttpProxy({
								url : url
							});*/
					ItmUomStore.removeAll();		
					ItmUomStore.load({params:{ItmRowid:IncRowid}});
				});

		/**
		 * 单位变换事件
		 * var fields = ["AspBatId", "StkCatDesc", "InciId", "InciCode",
				"InciDesc", "MarkType", "PriceFileNo", "AspUomId",
				"PriorSpUom", "MaxSp", "ResultSpUom", "DiffSpUom",
				"PriorRpUom", "ResultRpUom", "DiffRpUom", "AdjDate",
				"PreExecuteDate", "Remark", "AspNo", "AdjUserName",
				"BUomId","ConFacPur"];
		 */
		CTUom.on('select', function(combo) {
					var cell = DetailGrid.getSelectionModel().getSelectedCell();
					var record = DetailGrid.getStore().getAt(cell[0]);
					
					var value = combo.getValue();        //目前选择的单位id
					var BUom = record.get("BUomId");
					var ConFac = record.get("ConFacPur");   //大单位到小单位的转换关系					
					var AdjUom = record.get("AspUomId");    //目前显示的调价单位
					var PriorSpUom = record.get("PriorSpUom");
					var PriorRpUom = record.get("PriorRpUom");
					var ResultSpUom = record.get("ResultSpUom");
					var ResultRpUom = record.get("ResultRpUom");
					
					if (value == null || value.length <= 0) {
						return;
					} else if (AdjUom == value) {
						return;
					} else if (value==BUom) {     //新选择的单位为基本单位，原显示的单位为大单位
						record.set("PriorSpUom", PriorSpUom/ConFac);
						record.set("PriorRpUom", PriorRpUom/ConFac);
						record.set("DiffRpUom", (ResultRpUom-PriorRpUom/ConFac));
						record.set("DiffSpUom", (ResultSpUom-PriorSpUom/ConFac));
					} else{  //新选择的单位为大单位，原先是单位为小单位
						record.set("PriorSpUom", PriorSpUom*ConFac);
						record.set("PriorRpUom", PriorRpUom*ConFac);
						record.set("DiffRpUom", (ResultRpUom-PriorRpUom*ConFac));
						record.set("DiffSpUom", (ResultSpUom-PriorSpUom*ConFac));
					}
					record.set("AspUomId", combo.getValue());
					
				});

		// 变换行颜色
		function changeBgColor(row, color) {
			DetailGrid.getView().getRow(row).style.backgroundColor = color;
		}

		// 变更按钮是否可用
		function changeButtonEnable(str) {
			var list = str.split("^");
			for (var i = 0; i < list.length; i++) {
				if (list[i] == "1") {
					list[i] = false;
				} else {
					list[i] = true;
				}
			}
			/*
			SearchInItBT.setDisabled(list[0]);
			SearchRqNoBT.setDisabled(list[1]);
			ClearBT.setDisabled(list[2]);
			AddBT.setDisabled(list[3]);
			SaveBT.setDisabled(list[4]);
			DeleteBT.setDisabled(list[5]);
			DeleteDrugBT.setDisabled(list[6]);
			CheckBT.setDisabled(list[7]);
			*/
		}
		
		var HisListTab = new Ext.form.FormPanel({
			labelWidth : 60,
			labelAlign : 'right',
			title:'调价单录入(批次)',
			frame : true,
			tbar : [SearchBT, '-', ClearBT, '-', AddBT,	'-', SaveBT],
			autoHeight:true,	
			items : [{
				xtype : 'fieldset',
				title : '查询信息', //--<font color=blue>蓝色字体显示的项目既是查询条件也是调价录入限制条件</font>',
				layout : 'column',
				autoHeight:true,
				style: DHCSTFormStyle.FrmPaddingV,
				defaults:{border:false},
				items : [{
						columnWidth : .3,
						labelAlign : 'right',		
						xtype: 'fieldset',
						items : [StartDate,EndDate]
					}, {
						columnWidth : .3,
						labelAlign : 'right',		
						xtype: 'fieldset',	
						items : [StkGrpType,AspBatNo]
					}, {
						columnWidth : .4,
						labelAlign : 'right',		
						xtype: 'fieldset',	
						autoHeight: true,
						items : [IncDesc]
					}]
				
			}]		
						
		});
	
	var mainPanel = new Ext.Viewport({
		layout:'border',
		items:[{
			region:'north',
			height:DHCSTFormStyle.FrmHeight(2),
			layout:'fit',
			items:[HisListTab]
		},{
			region:'center',
			layout:'fit',
			items:[DetailGrid]
		}],
		renderTo:'mainPanel'
	});	
		//悬浮提示
	function formatQtip(data,metadata){   
	    var title ="备注";  
	    var tip =data;   
	    metadata.attr = 'ext:qtitle="' + title + '"' + ' ext:qtip="' + tip + '"';    
	    return data;    
	}
	RefreshGridColSet(DetailGrid,"DHCSTADJSPBATCH");  
	colArr=sortColoumByEnterSort(DetailGrid); //将回车的调整顺序初始化好
	
	var RpRule=tkMakeServerCall("web.DHCSTCOMMPARA","GetRpRule",HospId)
	if(RpRule!=3){
		Msg.info("warning","非批次价模式请用统一价调价菜单!!!");
		SearchBT.setDisabled(true);
		ClearBT.setDisabled(true);
		AddBT.setDisabled(true);
		SaveBT.setDisabled(true);
		AddDetailBT.setDisabled(true);
		DelDetailBT.setDisabled(true);
		return;
	}
	
})