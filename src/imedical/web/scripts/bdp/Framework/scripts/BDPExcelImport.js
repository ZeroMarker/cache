

//var filepathid="ExcelImportPath";
		
		var ImType="";
		var Eclassname="web.DHCBL.BDP.BDPDataImport";
		
		var selectModel=0
	/** 初始化Home TabPanel */
	var centertab =  new Ext.TabPanel({
                id:'main-tabs',
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
	
	  //中国标准时间 转换函数 JS   alert(format("Thu Aug 22 2013 15:12:00 GMT+0800", 'yyyy-MM-dd HH:mm:ss'));
	/*var format = function(time, format){
    var t = new Date(time);
    var tf = function(i){return (i < 10 ? '0' : '') + i};
    return format.replace(/yyyy|MM|dd|HH|mm|ss/g, function(a){
        switch(a){
            case 'yyyy':
                return tf(t.getFullYear());
                break;
            case 'MM':
                return tf(t.getMonth() + 1);
                break;
            case 'mm':
                return tf(t.getMinutes());
                break;
            case 'dd':
                return tf(t.getDate());
                break;
            case 'HH':
                return tf(t.getHours());
                break;
            case 'ss':
                return tf(t.getSeconds());
                break;
        }
    })
}    */
	    
	var BasePanel = new Ext.Window({
		height:500,
		width:900,
		title:'数据预览',
		layout : 'border',
		id:'BasePanel',
		closeAction : 'hide',
		items:[centertab],
		buttonAlign:'center',
		buttons:[{
				text:'一键导入',
				id:'import',
				handler:function(){
					/*Ext.MessageBox.confirm('提示', '确定要导入数据吗?', function(btn) {
						if (btn == 'yes') {*/
					if (selectModel!=0)	
					{
							var strrr =tkMakeServerCall(Eclassname,"EXCELSave",ImType);
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
					BasePanel.hide();
					
					
				}
			}],
		listeners : {
			"show" : function() {
			},
			"hide" : function() {
				centertab.removeAll();
			},
			"close" : function() {
			}
		}
	});
	
var ReadExcel=function (efilepath,sheet_from,sheet_to,row_from,type,table)
	{
		ImType=type;
		
		try{ 
			var oXL = new ActiveXObject("Excel.application"); 
			var oWB = oXL.Workbooks.open(efilepath);   //xlBook = xlApp.Workbooks.add(ImportFile);
		}		
		catch(e){
			/*var emsg="请在IE下导入，并在[internet选项]-[安全]-[受信任的站点]-[站点]中添加开始界面到可信任的站点，然后在[自定义级别]中对[没有标记为安全的ActiveX控件进行初始化和脚本运行]这一项设置为启用!"
			Ext.Msg.show({
				title : '提示',
				msg : emsg ,
				minWidth : 200,
				icon : Ext.Msg.INFO,
				buttons : Ext.Msg.OK
			}) */
			alert(e.message);
			return;
		}
		
		
		//Ext.MessageBox.wait('正在读取数据，请勿刷新或关闭页面，请稍候...','提示');
	
	//var dateStr=""  //日期格式的字段所在列
	//var timeStr=""  //时间格式的字段所在列
	
	var errorMsg="";//错误信息
	var killstr =tkMakeServerCall(Eclassname,"KillTMPIMPORT",type);   ///k ^TMPEXCELDATA(type)

	for(var sheet_id=sheet_from;sheet_id<=sheet_to;sheet_id++) {
		//alert(sheet_id);
		var errorRow="";//没有插入的行
		var errorMsg="";
		oWB.worksheets(sheet_id).select(); 
		var oSheet = oWB.ActiveSheet; 
		var rowcount=oSheet.UsedRange.Cells.Rows.Count ;  ///行数  var rowcount=oXL.Worksheets(sheet_id).UsedRange.Cells.Rows.Count ; 
		var colcount=oSheet.UsedRange.Cells.Columns.Count ;  ///列数
		var sheetname=oSheet.name;  //获取sheet的表中文含义
		
		var tablename=tkMakeServerCall(Eclassname,"GetImportTableName",sheetname);  ///oSheet.Cells(1,1).value;////获取sheet的表名
		//var tablename=table
		if ((tablename=="")||(tablename!=table)){
			alert("不是该表的数据!请重新选择Excel文件!");
			continue;
		}
		var propdescStr="";
		for (var n=1;n<=colcount;n++){
			var propdesc="";
			
			if (typeof(oSheet.Cells(1,n).value)=="undefined")
			{
				propdesc="";
			}
			else
			{
				propdesc=oSheet.Cells(1,n).value;
			}
			
			
			if (n==1) 
			{
				propdescStr=propdesc;
			}
			else
			{
				propdescStr=propdescStr+("&%"+propdesc);		
			}
			
			/*if(oSheet.Cells(1,n).value.indexOf("日期") > 0 )   //日期格式的列拼串
			{
				dateStr="["+n+"]^"+dateStr
			}
			if(oSheet.Cells(1,n).value.indexOf("时间") > 0 )   //时间格式的列拼串
			{
				timeStr="["+n+"]^"+timeStr
			}*/
		
		}
	
		///默认全导入  导入类型为只追加
		var imstr =tkMakeServerCall(Eclassname,"ImportTabBaseInfo",type,sheet_id,sheetname,tablename,propdescStr);
		
		///s ^TMPIMPORT(type,sheetnum)=tableflag_"#"_importtype
		 var tabId = sheet_id +"_tab" +"##" + tablename;
	    var obj = Ext.getCmp(tabId);
	    if (obj)
	    {
	    	obj.setTitle(sheetname);
	    }
	    else
	    {		
	    		cls=tablename.split(".");
	    		var classname=cls[1];
	    		///	var QUERY_ACTION_URL = "../bi/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.KB."+classname+"&pClassQuery=GetList";
	    		///var fields=[];
	    		var col = [];
	    		var Record=[];
	    		col.push({header: '对应表格行',sortable : true,dataIndex : 'row'});
	    		Record.push({name : 'row',type : 'int'});
	    		for (var line=1;line<=colcount;line++)	
				{
					//fields.push({name : 'name',mapping : 'mapping',type : 'string'});	
					col.push({header: 'name',sortable : true,dataIndex : 'mapping'});	
					var namev="";
					if (typeof(oSheet.Cells(1,line).value)=="undefined")
					{
						namev="";
					}
					else
					{
						namev=oSheet.Cells(1,line).value;
					}
					
					var headv="";
					if (typeof(oSheet.Cells(1,line).value)=="undefined")
					{
						headv="";
					}
					else
					{
						headv=oSheet.Cells(1,line).value;
					}
					//fields[line-1].name=namev;
					//fields[line-1].mapping=namev;
					
					col[line].header=headv;
					col[line].dataIndex=namev;
					
					Record.push({name : 'name',type : 'string'});
					Record[line].name=namev;
					//alert(namev)
					
				}
				var sm = new Ext.grid.CheckboxSelectionModel({singleSelect : false});
				
				/*
				var sm = new Ext.grid.CheckboxSelectionModel({   
					singleSelect : false,
				    //checkOnly:true,  
				    
				       // 解决sm全选不选中不显示的sm 
				     
				    selectAll : function(){  
				        sm.clearSelections();//清除全部的选区  
				        var storeLength = sm.grid.store.getCount();  
				        for(var i = 0; i < storeLength; i++){  
				            var record = sm.grid.store.getAt(i);  
				            //获取record中selected的值  
				            var selected = record.data['selected'];  
				            if(!selected){  
				                var id = record.get('id');  
				                //传入一个id，根据id查询缓存里的Record，返回其索引  
				                var si = store.indexOfId(id);  
				                sm.selectRow(i, true);  
				            }  
				        }      
				    },  
				     
				        //解决sm是否显示问题 
				    
				    renderer:function(v, p, record){  
				        //获取record中selected的值  
				        var selected = record.data['selected'];  
				        if(!selected){  
				            //selected为false时候显示  
				            return '<div class="x-grid3-row-checker"> </div>';  
				        }else{  
				            //selected为true显示空  
				            return '';  
				        }  
				    }  
				});  
				
				*/
				
					var colModel = new Ext.grid.ColumnModel({columns:col});
					colModel.columns.push(sm)
					var personRecord = Ext.data.Record.create(Record);
	    			
	    			
	    			// caihaozhe 
	    			sm.on("rowselect", function(e, rowIndex, record) {
	    				///^TMPIMPORT("BIData",3,"%IHBI.BaseKPIDefine")
					  	var rowid = record.get('row');
	    				var tabid =centertab.getActiveTab().id.replace("_tab","");
	    				var str= new Array();   
  						str=tabid.split("##");
	    				var gridid = str[0];
	    				var tablename = str[1];
						selectModel=selectModel+1;
						Ext.getCmp(gridid +'_grid').getView().getRow(rowIndex).className='x-grid3-row x-grid3-row-selected x-grid3-row-chz';
					    //updatedataflag(type,sheetid,tablename,row,dataflag)
						var Flag =tkMakeServerCall(Eclassname,"updatedataflag",type,gridid,tablename,rowid,"Y");
	    			});
	    			
	    			sm.on("rowdeselect", function(e, rowIndex, record) {
						//alert(record.get('row'))
	    				var rowid = record.get('row');
	    				var tabid =centertab.getActiveTab().id.replace("_tab","");
	    				var str= new Array();   
  						str=tabid.split("##");
	    				var gridid = str[0];
	    				var tablename = str[1];
						selectModel=selectModel-1
	    				Ext.getCmp(gridid +'_grid').getView().getRow(rowIndex).className='x-grid3-row';
	    				var Flag =tkMakeServerCall(Eclassname,"updatedataflag",type,gridid,tablename,rowid,"N");
					        
	    			});

	    			
	    			///var Alldata = [['boy1', 0], ['boy2', 0]];
	    			
	    			var Alldata =[];
		    		var data =[];
	    			
		    		//从第row_from行开始读取
					for(var i=row_from;i<=rowcount;i++){
						var tempStr="";
						var data =[];
						for (var j=0;j<=colcount;j++){

							if (j==0)
							{
								data.push(i);
							}
							else
							{
						
					
								var cellvalue="";
								if (typeof(oSheet.Cells(i,j).value)=="undefined")
								{
									cellvalue="";
								}
								else
								{
									cellvalue=oSheet.Cells(i,j).value;
								}
								/*if (cellvalue!="")   //处理日期和时间的格式
								{
									//alert(cellvalue)
									var dateflag="" ,timeflag=""
									dateflag=dateStr.indexOf("["+j+"]")  //判断是否是日期格式
									timeflag=timeStr.indexOf("["+j+"]")  //判断是否是时间格式
									if(dateflag>-1)
									{
										cellvalue=format(cellvalue, 'yyyy/MM/dd')
									}
									if(timeflag>-1)
									{
										cellvalue=format(cellvalue, 'HH:mm:ss')
									}
								}*/
								if (j==1) 
								{
									tempStr=cellvalue;
								}
								else
								{
									tempStr=tempStr+("&%"+cellvalue);		
								}
								data.push(cellvalue);
								
							}
						}
						
						////data:  100001,1,1,1,1,1,1
						Alldata.push(data);
						
						//BIData,tablename,sheetnum,row,datastr,dataflag
						var Flag =tkMakeServerCall(Eclassname,"ImportIntoGlobal",type,tablename,sheet_id,i,tempStr,"N");
						
					} 
					//alert(format(oSheet.Cells(2,4).value, 'yyyy/MM/dd'));
	    			//alert(oSheet.Cells(2,4).value);
	    			
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
									id : type+"#"+sheet_id+"#"+'tableflag',
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
										
										var typeFlag =tkMakeServerCall(Eclassname,"updatetableflag",this.id,this.value);
										
										
									}
								}
							},'-','导入类型：', {
								id : type+"#"+sheet_id+"#"+'importtype',
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
										
										var typeFlag =tkMakeServerCall(Eclassname,"updateimporttype",this.id,this.value);
										
										
									}
								}
							},'->','<font style="color:red;">√ 请勾选需要导入的数据！</font>']
				});
				
				Ext.getCmp(type+"#"+sheet_id+"#"+'tableflag').setValue("Y");
				Ext.getCmp(type+"#"+sheet_id+"#"+'tableflag').setRawValue("是");
				Ext.getCmp(type+"#"+sheet_id+"#"+'importtype').setValue("J");
				Ext.getCmp(type+"#"+sheet_id+"#"+'importtype').setRawValue("只追加");
				var	grid=new Ext.grid.GridPanel({
					id : sheet_id +'_grid',
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
					stateId : sheet_id +'_grid'
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
				var tabs=Ext.getCmp('main-tabs');
				
	   			var obj2=tabs.add({
	    	    	id:tabId,
	    	    	layout:'fit',
	            	title:sheetname,
	            	items:[grid],
	            	closable:false
	      		 });
	      		 
	      		
	    	}
	    
			
            
          
	}
		
	Ext.MessageBox.hide();    	
	tabs.setActiveTab(0);   	
	BasePanel.show();
	
	
		
	oWB.Close (savechanges=false);
	oXL.Quit(); 
	CollectGarbage();
	oXL=null;
	oSheet=null;
	oWB=null;
	
		
	
	/* var whatsthetime = function(){
	//alert(new Date());
	 	var model = Ext.getCmp(tabn[sheet_from]+'_grid').getSelectionModel();  
    	model.selectAll();//选择所有行 
	}
	whatsthetime.defer(1000);//执行之前等待三秒
*/
	 //var model=Ext.getCmp(tablename+'_grid').getSelectionModel();
	
	//model.selectAll()	
}
	
	
	