var tempVouchNo=-1;
var vouchNo=-1;

var initIncomeCM = new Ext.grid.ColumnModel([
		{header : '日期',dataIndex:'日期',width : 100,sortable : true},
		{header : '临时凭证号',dataIndex:'临时凭证号',width : 100,sortable : true},
		{header : '凭证编号',dataIndex:'凭证编号',width : 100,sortable : true}
	]);

function checkFun1(){
	
			var bdate = (beginIncomeDate.getValue()===""?"":beginIncomeDate.getValue().format('Y-m-d'));
			var sdate = (stopIncomeDate.getValue()===""?"":stopIncomeDate.getValue().format('Y-m-d'));
			if((bdate==="")||(sdate==="")){
				Ext.Msg.alert('提示','收费时间不能为空!');
			}else{
				if(bdate>sdate){
					Ext.Msg.alert('提示','结束时间不能小于开始时间!');
				}else{
					Ext.Ajax.request({
						url:'dhc.cs.autohisoutexe.csp?action=OPIncomeHead&stDate='+bdate+'&endDate='+sdate+'&inOut=DHCOPB0022',
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
								//if(jsonHeadList[i].title!='病人类型'){ /////////////////病人类型////////////////
									cmConfig = {header : jsonHeadList[i].title,dataIndex : jsonHeadList[i].name,width : 75,sortable : true,align:'right'};
									cmItems.push(cmConfig); 
									tmpDataMapping.push(jsonHeadList[i].name);
								//}								
							}
							var tmpColumnModel = new Ext.grid.ColumnModel(cmItems);
							var tmpStore = new Ext.data.Store({
								proxy:new Ext.data.HttpProxy({url:'dhc.cs.autohisoutexe.csp?action=OPIncomeJson&stDate='+bdate+'&endDate='+sdate+'&inOut=DHCOPB0022', method:'GET'}),
								reader:new Ext.data.JsonReader({totalProperty:"results",root:'rows',id: 'rowid'}, tmpDataMapping),
								remoteSort: true
							});
							
							tmpColumnModel.setRenderer(1,function(value,meta,rec,rowIndex,colIndex,store){
								//alert(value);
								//var tmpValue=value.split("/");
								//var tmpY=tmpValue[2];
								//var tmpM=tmpValue[1];
								//var tmpD=tmpValue[0];
								//var tmpDate=null;
								//if(typeof(tmpY)=="undefined"){
								//	return value
								//}else{
								//	tmpDate=new Date(tmpY,tmpM-1,tmpD).format('Y-m-d');
								//	return "<font color=blue>"+tmpDate+"</font>";
								//}
								if(value!='合计'){
									return "<font color=blue>"+value+"</font>";
								}else{
									return value;
								}
							});
							
							tmpColumnModel.setRenderer(2,function(value,meta,rec,rowIndex,colIndex,store){
									return "<font color=blue>"+value+"</font>";
							});
														
							tempVouchNo = tmpDataMapping.indexOf("临时凭证编号")+1;///////////////////////////////////////////////////////
							vouchNo = tmpDataMapping.indexOf("凭证号")+1;//////////////////////////////////////////////////////////
							//alert(tempVouchNo);
							tmpColumnModel.setRenderer(tempVouchNo,function(value,meta,rec,rowIndex,colIndex,store){
								return "<font color=blue>"+value+"</font>";
							});
							
							tmpColumnModel.setRenderer(vouchNo,function(value,meta,rec,rowIndex,colIndex,store){
								return "<font color=blue>"+value+"</font>";
							});
			
							autohisoutincomeMain.reconfigure(tmpStore,tmpColumnModel);
							tmpStore.load();
						},
						scope: this
					});
				}
			}
		}

var searchOPIncomeButton = new Ext.Toolbar.Button({
		text: '查询',
		tooltip: '查询区间内的数据',        
		iconCls: 'add',
		handler: function(){
			checkFun1();
		}
	});
/*
var editUnittypesButton  = new Ext.Toolbar.Button({
		text: '按科室查询',        
		tooltip: '按科室查询',
		iconCls: 'add',
		handler: function(){
			var bdate = (beginIncomeDate.getValue()===""?"":beginIncomeDate.getValue().format('Y-m-d'));
			var sdate = (stopIncomeDate.getValue()===""?"":stopIncomeDate.getValue().format('Y-m-d'));
			if((bdate==="")||(sdate==="")){
				Ext.Msg.alert('提示','收费时间不能为空!');
			}else{
				//location.href='dhc.cs.autohisdept.csp?bdate='+bdate+'&sdate='+sdate;
				OPReportCatDetailByLocFun(bdate, sdate);
			}			
		}
	});
*/
var beginIncomeDate = new Ext.form.DateField({
		format:'Y-m-d'
	});
	
var stopIncomeDate = new Ext.form.DateField({
		format:'Y-m-d'
	});

var genButton1 = new Ext.Toolbar.Button({
		text: '生成',
		tooltip: '生成',        
		iconCls: 'add',
		handler: function(){

				var operator = session['LOGON.USERCODE'];
				
				var bdate = (beginIncomeDate.getValue()===""?"":beginIncomeDate.getValue().format('Y-m-d'));
				var sdate = (stopIncomeDate.getValue()===""?"":stopIncomeDate.getValue().format('Y-m-d'));
	
				Ext.Ajax.request({
					url: 'dhc.cs.autohisoutexe.csp?action=IOVouch&yearPeriodId=1&stDate='+bdate+'&endDate='+sdate+'&operator='+operator+'&inOut=DHCOPB0022',
					waitMsg:'保存中...',
					failure: function(result, request) {
						Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
					},
					success: function(result, request) {
						var jsonData = Ext.util.JSON.decode( result.responseText );
						if (jsonData.success=='true') {
							Ext.Msg.show({title:'注意',msg:'凭证生成成功!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
							checkFun1();
						}else{
							Ext.Msg.show({title:'错误',msg:'凭证生成失败!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
						}
					},
					scope: this
				});
			//}
		}
	});
	
var autohisoutincomeMain = new Ext.grid.GridPanel({
		title: '门诊结算',
		store: new Ext.data.Store(),
		cm: initIncomeCM,
		trackMouseOver: true,
		stripeRows: true,
		sm: new Ext.grid.RowSelectionModel({singleSelect:true}),
		//sm:new Ext.grid.CheckboxSelectionModel(),
		loadMask: true,
		listeners : {
			'cellclick' : function(grid, rowIndex, columnIndex, e){
				var record = grid.getStore().getAt(rowIndex);  // Get the Record
				var fieldName = grid.getColumnModel().getDataIndex(1); // Get field name
				var tmpDate = record.get(fieldName);
				var tmpDate = dateChange(tmpDate);

				//alert(columnIndex);
				if(columnIndex==1){
					if(tmpDate!='合计'){
						autohisclearingpersonFun(tmpDate);
					}
				}else if(columnIndex==2){
					if(tmpDate!=''){
						//alert(tmpDate);
						autohisadmreasonFun(tmpDate);
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
		tbar: ['收费时间:',beginIncomeDate,'至',stopIncomeDate,'-',searchOPIncomeButton,'-',genButton1]
	});