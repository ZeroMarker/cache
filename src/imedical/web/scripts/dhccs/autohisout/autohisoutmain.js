var tempVouchNo=-1;
var vouchNo=-1;
var tmpStore;
function checkFun(){
			var bdate = (beginDate.getValue()===""?"":beginDate.getValue().format('Y-m-d'));
			var sdate = (stopDate.getValue()===""?"":stopDate.getValue().format('Y-m-d'));
			if((bdate==="")||(sdate==="")){
				Ext.Msg.alert('提示','收费时间不能为空!');
			}else{
				if(bdate>sdate){
					Ext.Msg.alert('提示','结束时间不能小于开始时间!');
				}else{
					Ext.Ajax.request({
						url:'dhc.cs.autohisoutexe.csp?action=GetOPReportCatDetailByDateHead&stDate='+bdate+'&endDate='+sdate+'&inOut=DHCOPB002',
						waitMsg:'...',
						failure: function(result, request) {
							Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
						},
						success: function(result, request) {
							var jsonData = Ext.util.JSON.decode( result.responseText );
							var cmItems = []; 
							var cmConfig = {}; 
							cmItems.push(new Ext.grid.RowNumberer()); 
							//cmItems.push(new Ext.grid.CheckboxSelectionModel());
							var jsonHeadNum = jsonData.results; 
							var jsonHeadList = jsonData.rows; 
							var tmpDataMapping = [];
							for(var i=0;i<jsonHeadList.length;i++){ 
								cmConfig = {header : jsonHeadList[i].title,dataIndex : jsonHeadList[i].name,width : 75,sortable : true,align:'right'};
								cmItems.push(cmConfig); 
								tmpDataMapping.push(jsonHeadList[i].name);  
							}
							var tmpColumnModel = new Ext.grid.ColumnModel(cmItems);
							tmpStore = new Ext.data.Store({
								proxy:new Ext.data.HttpProxy({url:'dhc.cs.autohisoutexe.csp?action=GetOPReportCatDetailByDateJson&stDate='+bdate+'&endDate='+sdate+'&inOut=DHCOPB002', method:'GET'}),
								reader:new Ext.data.JsonReader({totalProperty:"results",root:'rows',id: 'rowid'}, tmpDataMapping),
								remoteSort: true
							});
							
							tmpColumnModel.setRenderer(1,function(value,meta,rec,rowIndex,colIndex,store){
								var tmpValue=value.split("/");
								var tmpY=tmpValue[2];
								var tmpM=tmpValue[1];
								var tmpD=tmpValue[0];
								var tmpDate=null;
								if(typeof(tmpY)=="undefined"){
									return value
								}else{
									tmpDate=new Date(tmpY,tmpM-1,tmpD).format('Y-m-d');
									return "<font color=blue>"+tmpDate+"</font>";
									//return "<a href='dhc.cs.autohisclearingperson.csp?date="+tmpDate+"'>"+tmpDate+"</a>";
								}
							});
								
							tempVouchNo = tmpDataMapping.indexOf("临时凭证号")+1;
							vouchNo = tmpDataMapping.indexOf("凭证编号")+1;
							
							tmpColumnModel.setRenderer(tempVouchNo,function(value,meta,rec,rowIndex,colIndex,store){
								return "<font color=blue>"+value+"</font>";
							});
							
							tmpColumnModel.setRenderer(vouchNo,function(value,meta,rec,rowIndex,colIndex,store){
								return "<font color=blue>"+value+"</font>";
							});
							
							autohisoutMain.reconfigure(tmpStore,tmpColumnModel);
							tmpStore.load();
						},
						scope: this
					});
				}
			}
		}


var initCM = new Ext.grid.ColumnModel([
		{header : '日期',dataIndex:'日期',width : 100,sortable : true},
		{header : '临时凭证号',dataIndex:'临时凭证号',width : 100,sortable : true},
		{header : '凭证编号',dataIndex:'凭证编号',width : 100,sortable : true}
	]);

var addUnittypesButton = new Ext.Toolbar.Button({
		text: '查询',
		tooltip: '查询区间内的数据',        
		iconCls: 'add',
		handler: function(){
						checkFun();
					}
	});
	
	
var genButton = new Ext.Toolbar.Button({
		text: '生成',
		tooltip: '生成',        
		iconCls: 'add',
		handler: function(){
			//var rows=autohisoutMain.getSelectionModel().getSelections();
			//var len = rows.length;
			//if(len == 0){ 
			//	Ext.Msg.alert('注意','请先选择数据行!');
			//}else{
			//	var strBusino = '';
			//	for(var i=0;i <len;i++){ 
			//		if(i==0){
			//			strBusino = rows[i].get('No'); 
			//		}else{
			//			strBusino = strBusino + ',' + rows[i].get('No'); 
			//		}
			//	} 
				//var yearPeriodId = accountingPeriodCB.getValue();
				//var busiTypeId = businessTypeCB.getValue();
				var operator = session['LOGON.USERCODE'];
				
				var bdate = (beginDate.getValue()===""?"":beginDate.getValue().format('Y-m-d'));
				var sdate = (stopDate.getValue()===""?"":stopDate.getValue().format('Y-m-d'));
	
				Ext.Ajax.request({
					url: 'dhc.cs.autohisoutexe.csp?action=IOVouch&yearPeriodId=1&stDate='+bdate+'&endDate='+sdate+'&operator='+operator+'&inOut=DHCOPB002',
					waitMsg:'保存中...',
					failure: function(result, request) {
						Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
					},
					success: function(result, request) {
						var jsonData = Ext.util.JSON.decode( result.responseText );
						if (jsonData.success=='true') {
							Ext.Msg.show({title:'注意',msg:'凭证生成成功!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
							checkFun();
						}else{
							Ext.Msg.show({title:'错误',msg:'凭证生成失败!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
						}
					},
					scope: this
				});
			//}
		}
	});
	
//'日/月/年' --> '年-月-日'	
//'其它' --> '其它'
var dateChange = function(value){
		var tmpValue=value.split("/");
		var tmpY=tmpValue[2];
		var tmpM=tmpValue[1];
		var tmpD=tmpValue[0];
		var tmpDate=null;
		if(typeof(tmpY)=="undefined"){
			return value
		}else{
			tmpDate=new Date(tmpY,tmpM-1,tmpD).format('Y-m-d');
			return tmpDate;
		}
	}

var editUnittypesButton  = new Ext.Toolbar.Button({
		text: '按科室查询',        
		tooltip: '按科室查询',
		iconCls: 'add',
		handler: function(){
			var bdate = (beginDate.getValue()===""?"":beginDate.getValue().format('Y-m-d'));
			var sdate = (stopDate.getValue()===""?"":stopDate.getValue().format('Y-m-d'));
			if((bdate==="")||(sdate==="")){
				Ext.Msg.alert('提示','收费时间不能为空!');
			}else{
				//location.href='dhc.cs.autohisdept.csp?bdate='+bdate+'&sdate='+sdate;
				OPReportCatDetailByLocFun(bdate, sdate);
			}			
		}
	});

var beginDate = new Ext.form.DateField({
		format:'Y-m-d'
	});
	
var stopDate = new Ext.form.DateField({
		format:'Y-m-d'
	});

var autohisoutMain = new Ext.grid.GridPanel({
		title: '门诊收入',
		store: new Ext.data.Store(),
		cm: initCM,
		trackMouseOver: true,
		stripeRows: true,
		//sm:new Ext.grid.CheckboxSelectionModel(),
		sm: new Ext.grid.RowSelectionModel({ singleSelect: true }),
		loadMask: true,
		listeners : {
			'cellclick' : function(grid, rowIndex, columnIndex, e){
				if(columnIndex==1){
					var record = grid.getStore().getAt(rowIndex);  // Get the Record
					var fieldName = grid.getColumnModel().getDataIndex(columnIndex); // Get field name
					var tmpDate = record.get(fieldName);
					var tmpDate = dateChange(tmpDate);
					//alert(tmpDate);
					if(tmpDate!='合计'){
						autohisclearingpersonFun(tmpDate);
					}
				}else if(columnIndex==tempVouchNo){
					var record = grid.getStore().getAt(rowIndex);  // Get the Record
					var fieldName = grid.getColumnModel().getDataIndex(columnIndex); // Get field name
					var tmpData = record.get(fieldName);
					if(tmpData!=''){
						autohisinvouchFun(grid, rowIndex, columnIndex, e, tmpData);
					}
				}else if(columnIndex==vouchNo){
					var record = grid.getStore().getAt(rowIndex);  // Get the Record
					var fieldName = grid.getColumnModel().getDataIndex(columnIndex); // Get field name
					var tmpData = record.get(fieldName);
					if(tmpData!=''){
						alert(tmpData);					
					}
				}
			}
		},
		tbar: ['收费时间:',beginDate,'至',stopDate,'-',addUnittypesButton,'-',editUnittypesButton,'-',genButton]
	});