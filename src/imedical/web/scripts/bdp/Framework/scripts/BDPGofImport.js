

//var filepathid="ExcelImportPath";
		
		var ImType="";
		var pagesize=16;
		var selectModel=0
		var Gclassname="web.DHCBL.BDP.BDPDataImport";
	/** 初始化Home TabPanel */
	var centertabgof =  new Ext.TabPanel({
                id:'main-tabs-gof',
                activeTab:0,
                region:'center',
                enableTabScroll:true,
                resizeTabs: true,
                tabWidth:130,
				minTabWidth:120,
                //margins:'0 5 5 0',
                resizeTabs:true,
                //tabWidth:150
               	items:[]
		});
	
	    
	     
	    
	var BasePanelgof = new Ext.Window({
		height:500,
		width:900,
		id:'BasePanelgof',
		title:'数据预览',
		layout : 'border',
		closeAction : 'hide',
		items:[centertabgof],
		buttonAlign:'center',
		buttons:[{
				text:'一键导入',
				handler:function(){
					/*Ext.MessageBox.confirm('提示', '确定要导入数据吗?', function(btn) {
						if (btn == 'yes') {*/
						if (selectModel!=0)	
						{	var strrr =tkMakeServerCall(Gclassname,"GOFSave",ImType);
							if (strrr=="") alert("导入完成。")
							else  alert(strrr);
							
						}
						else
						{
							alert("请选择要导入的行！")
							
						}
						/*}
					}, this);*/
				}
			},{
				text:'取消',
				handler:function(){
					BasePanelgof.hide();
					
					
				}
			}],
		listeners : {
			"show" : function() {
			},
			"hide" : function() {
				centertabgof.removeAll();
			},
			"close" : function() {
			}
		}
	});
	
var ReadGof=function (efilepath,type,table)
	{
		
		//Ext.MessageBox.wait('正在读取GOF数据，请勿刷新或关闭页面，请稍候...','提示');
		ImType=type;
		
	var datainfo =tkMakeServerCall(Gclassname,"GetGofInfo",type);
	//alert(datainfo)
	
	//2&%%IHBI.KPITargetVal   #%   3&%%IHBI.KBaseDefine  #%    4&%%IHBI.BaseKPIDefine
	if (datainfo=="") {alert("请先设置导入gof相关配置");return; }
	var arryTmp = datainfo.split("#%");
	for(var intRow = 0; intRow < arryTmp.length; intRow ++)
	{
		var goftable_id=intRow+1;
		var myPortlet = arryTmp[intRow];
		if(myPortlet == "") continue;
		var arryField = myPortlet.split("&%");
		var igofnum=arryField[0];
		var tablename=arryField[1];

		if ((tablename=="")||(tablename!=table)){
			alert("不是该表的数据!请重新选择gof文件!");
			continue;
		}

		var tablenamedesc=arryField[2];
		var tabId = igofnum +"_goftab" +"##" + tablename;
	    var obj = Ext.getCmp(tabId);
	    if (obj)
	    {
	    	obj.setTitle(tablenamedesc);
	    }
	    else
	    {
	    	
	    		var fieldinfo =tkMakeServerCall(Gclassname,"GetTableGridCm",type,igofnum,tablename);
	    		///KBDCode&%代码#%KBDCode&%代码#%KBDName&%描述#%TableName&%数据来源
	    		var col = [];
	    		var Record=[];
	    		col.push({header: 'row',sortable : true,dataIndex : 'row'});
	    		Record.push({name : 'row',type : 'int'});
	    		
	    		
	    		var colarray = fieldinfo.split("#%");
	    		var colarraylength=colarray.length;
				for(var coli = 0; coli < colarray.length; coli ++)
				{
					var colistr = colarray[coli];  //KBDCode&%代码
					if(colistr == "") continue;
					
					var Field = colistr.split("&%");
					var fieldname=Field[0];
					var fieldnamedesc=Field[1];
					col.push({header: 'name',sortable : true,dataIndex : 'mapping'});	
					//fields[line-1].name=namev;
					//fields[line-1].mapping=namev;
					
					col[coli+1].header=fieldnamedesc;
					col[coli+1].dataIndex=fieldname;
					Record.push({name : 'name',type : 'string'});
					Record[coli+1].name=fieldname;	
					
				}
	    		
				var sm = new Ext.grid.CheckboxSelectionModel({singleSelect : false});
				var colModel = new Ext.grid.ColumnModel({columns:col});
				colModel.columns.push(sm)
				var personRecord = Ext.data.Record.create(Record);
	    			
	    			// caihaozhe 
	    			sm.on("rowselect", function(e, rowIndex, record) {
	    				var rowid = record.get('row');
	    				var tabid =centertabgof.getActiveTab().id.replace("_goftab","");
	    				var str= new Array();   
  						str=tabid.split("##");
	    				var gridid = str[0];
	    				var tablename = str[1];
						selectModel=selectModel+1;
						Ext.getCmp(gridid +'_gofgrid').getView().getRow(rowIndex).className='x-grid3-row x-grid3-row-selected x-grid3-row-chz';
					  	var Flag =tkMakeServerCall(Gclassname,"updategofdataflag",type,gridid,tablename,rowid,"Y");
	    			});
	    			
	    			sm.on("rowdeselect", function(e, rowIndex, record) {
						//alert(record.get('row'))
	    				var rowid = record.get('row');
	    				var tabid =centertabgof.getActiveTab().id.replace("_goftab","");
	    				var str= new Array();   
  						str=tabid.split("##");
	    				var gridid = str[0];
	    				var tablename = str[1];
	    				selectModel=selectModel+1;
	    				Ext.getCmp(gridid +'_gofgrid').getView().getRow(rowIndex).className='x-grid3-row';
	    				var Flag =tkMakeServerCall(Gclassname,"updategofdataflag",type,gridid,tablename,rowid,"N");
					        
	    			});

	    			
	    			///var Alldata = [['boy1', 0], ['boy2', 0]];
	    			
	    			var Alldata =[];
		    		var data =[];
	    			
		    		
		    		var propStr="";
					var gofcount =tkMakeServerCall(Gclassname,"GetTableGofCount",type,igofnum,tablename);  //20
	    	
		    		//从第row_from行开始读取
					for(var i=1;i<=gofcount;i++){
						var tempStr="";
						var data =[];
						
						
						var gofiinfo =tkMakeServerCall(Gclassname,"GetTableGofiinfo",type,igofnum,tablename,i);
						var gofiinfoArray=gofiinfo.split("&%")
						///OralDrug&%口服药品&%PHC_Instruc
						for (var j=0;j<=colarraylength;j++){
							if (j==0)
							{
								data.push(i);
							}
							else
							{
								
								data.push(gofiinfoArray[j-1]);
								
							}
						}
						////data:  100001,1,1,1,1,1,1
						Alldata.push(data);
	
					} 
	    			
	    			var ds = new Ext.data.Store({
	        			proxy: new Ext.data.MemoryProxy(Alldata),
	        			reader: new Ext.data.ArrayReader({}, personRecord)  
	       
	    			});
	
	    			
						
						
						
					/*var ds = new Ext.data.Store({
						proxy : new Ext.data.HttpProxy({ url : QUERY_ACTION_URL }),// 调用的动作
						reader : new Ext.data.JsonReader({
								totalProperty : 'total',
								root : 'data',
								successProperty : 'success'
							}, fields)
						});*/
					/*var paging = new Ext.PagingToolbar({
						pageSize : pagesize,
						store : ds,	
						plugins : [new Ext.BDP.FunLib.PagingToolbarResizer()],
	               		 listeners : {
	         			 "change":function (t,p)
	         			{ 
	             			pagesize=this.pageSize;
	         			}
	          			},										     //-----------刚ds发生load事件时会触发paging
						displayInfo : true,										 //-----------是否显示右下方的提示信息false为不显示
						//displayMsg : '显示第 {0} 条到 {1} 条记录，一共 {2} 条',    //-----------提示信息，这里规定了一种显示格式，默认也可以
						emptyMsg : "没有记录"
					});*/
					
					
					
					var tb = new Ext.Toolbar({
						id : tablename+'tb',
						items : ['是否导入这张表：', {
									id : type+"#"+goftable_id+"#"+'goftableflag',
									width:80,
		              	anchor: '85%',
						editable:false,
						xtype:'combo',
						triggerAction : 'all',
						forceSelection: true,
						selectOnFocus:true,
						mode:'local',
						queryParam:'desc',
						listWidth:80,
						valueField:'value',
						displayField:'name',
						store : new Ext.data.JsonStore({
							fields : ['name', 'value'],
							data : [{
										name : '是',
										value : 'Y'
									}, {
										name : '否',
										value : 'N'
									
									}]
						}),
						listeners : {
									'select' : function(combo, record, index) {
										//alert(this.id)  ///type+"#"+sheet_id+"#"+'importtype'
										//alert(this.value)  //combo.value
										//alert(this.id)
										var typeFlag =tkMakeServerCall(Gclassname,"updategoftableflag",this.id,this.value);
										
										
									}
								}
							},'-','导入类型：', {
								id : type+"#"+goftable_id+"#"+'gofimporttype',
								width:100,
	              	anchor: '85%',
					editable:false,
					xtype:'combo',
					triggerAction : 'all',
					forceSelection: true,
					selectOnFocus:true,
					mode:'local',
					queryParam:'desc',
					listWidth:100,
					valueField:'value',
					displayField:'name',
					store : new Ext.data.JsonStore({
							fields : ['name', 'value'],
							data : [{
										name : '只追加数据',
										value : 'J'
										
									}, {
										name : '修正数据',
										value : 'U'
									
									}]
						}),
						listeners : {
									'select' : function(combo, record, index) {
										//alert(this.id)  ///type+"#"+sheet_id+"#"+'importtype'
										//alert(this.value)  //combo.value
										
										var typeFlag =tkMakeServerCall(Gclassname,"updategofimporttype",this.id,this.value);
										
										
									}
								}
							},'-',/*'是否全选这个表所有数据：', {
								id : type+"#"+goftable_id+"#"+'selectalldata',
								width:100,
	              	anchor: '85%',
					editable:false,
					xtype:'combo',
					triggerAction : 'all',
					forceSelection: true,
					selectOnFocus:true,
					mode:'local',
					queryParam:'desc',
					listWidth:100,
					valueField:'value',
					displayField:'name',
					store : new Ext.data.JsonStore({
							fields : ['name', 'value'],
							data : [{
										name : '否',
										value : 'N'
										
									}, {
										name : '是',
										value : 'Y'
									
									}]
						}),
						listeners : {
									'select' : function(combo, record, index) {
										alert(this.id)  ///type+"#"+sheet_id+"#"+'importtype'
										
										//alert(this.value)  //combo.value
										var selectid=this.id;
										var selectidarr= new Array();   
  										selectidarr=selectid.split("#");
	    								var smid = selectidarr[1];
										//var typeFlag =tkMakeServerCall(Gclassname,"updategofimporttype",this.id,this.value);
										Ext.getCmp(smid +'_gofgrid').sm.fireEvent( "selectAll" , e )
										 ds.each(function(record){
											selMod.selectRecords(record, true)
											 }, this);
									}
								}
							},*/
							'->','<font style="color:red;">√ 请勾选需要导入的数据！</font>']
				});
				
				
				
				Ext.getCmp(type+"#"+goftable_id+"#"+'goftableflag').setValue("Y");
				Ext.getCmp(type+"#"+goftable_id+"#"+'goftableflag').setRawValue("是");
				Ext.getCmp(type+"#"+goftable_id+"#"+'gofimporttype').setValue("J");
				Ext.getCmp(type+"#"+goftable_id+"#"+'gofimporttype').setRawValue("只追加");
				///Ext.getCmp(type+"#"+goftable_id+"#"+'selectalldata').setValue("N");
				///Ext.getCmp(type+"#"+goftable_id+"#"+'selectalldata').setRawValue("否");
				var	grid=new Ext.grid.GridPanel({
					id : goftable_id +'_gofgrid',
					sm : sm,  //new Ext.grid.CheckboxSelectionModel({singleSelect : false}), 
					region:'center',
					height:600,
					store : ds,
					trackMouseOver : true,
					cm:colModel,
					//bbar : paging,
					tbar:tb,
					stripeRows : true,
					viewConfig : {
						forceFit : true
					},
					columnLines : true, //在列分隔处显示分隔符
					stateId : goftable_id +'_gofgrid'
				});
				
				grid.getStore().load({
					params : {
						start : 0/*,
						limit : pagesize*/
					}
				});
				
				 //sm.clearSelections();//清除全部的选区  
				   /*     var storeLength = grid.store.getCount();  
				        for(var i = 0; i < storeLength; i++){  
				            var record = grid.store.getAt(i);  
				            //获取record中selected的值  
				           // var selected = record.data['selected'];  
				           // if(!selected){  
				                //var id = record.get('id');  
				                //传入一个id，根据id查询缓存里的Record，返回其索引  
				                //var si = store.indexOfId(id);  
				                sm.selectRow(i, true);  
				          //  }  
				        }      */
				
				
				//sm.selectRecords(Alldata, true);
				///grid.getSelectionModel().selectAll();
				var tabs=Ext.getCmp('main-tabs-gof');
				
	   			var obj2=tabs.add({
	    	    	id:tabId,
	    	    	layout:'fit',
	            	title:tablenamedesc,
	            	items:[grid],
	            	closable:false
	      		 });
	      		 
	      		 
	      		
	    	}
	    
	
	}
	
	Ext.MessageBox.hide();
	tabs.setActiveTab(0);   	
	BasePanelgof.show();
	
	
	
		
		 
			
            
    
}
	
	
	