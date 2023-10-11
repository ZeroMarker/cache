/**
 * @Title: 基础数据平台-BDP数据导入
 * @Author: 谷雪萍 DHC-BDP  modified by chenying 2017
 * @Description: 数据导入界面
 * @Created on 2016-3-16
 */
 document.write('<script type="text/javascript" src="../scripts_lib/ext3.2.1/ux/PagingMemoryProxy.js"></script>');
Ext.onReady(function() {
	///陈莹 2019-03-28 
	///根据系统配置 获取日期格式  
	///2017-07-25 判断系统有没有定义日期格式  ///bug重现方式： 30/06/2017,将30改为3后，日期变为06/03/2017
 	if (typeof(websys_DateFormat) == "undefined") {
		var BDPDateFormat=tkMakeServerCall("web.DHCBL.BDP.FunLib","GetDateFormat");
 	} else {
    	var BDPDateFormat=websys_DateFormat
	}
     
	///2019-02-13
	function isIE()
	{
		////navigator.userAgent.indexOf("compatible") > -1 && navigator.userAgent.indexOf("MSIE") > -1  //ie6,7,8,9,10
		//// navigator.userAgent.indexOf('Trident') > -1 &&  navigator.userAgent.indexOf("rv:11.0") > -1;  //ie11  //"ActiveXObject" in window
		if((!!window.ActiveXObject)||(navigator.userAgent.indexOf('Trident')>-1&&navigator.userAgent.indexOf("rv:11.0")>-1))
		{	return true;}
		else
		{  
			return false;
		}
	}
	/// 获取文件路径 2017-07-11
	/// 使用方法：var filepath=getPath(document.getElementById("fileupload"));
	function getPath(obj) {
            if (obj) {
                if (window.navigator.userAgent.indexOf("MSIE") >= 1) {
                    obj.select(); return document.selection.createRange().text;
                }
                else if (window.navigator.userAgent.indexOf("Firefox") >= 1) {
                    if (obj.files) {
                        return obj.files.item(0).getAsDataURL();
                    }
                    return obj.value;
                }
                return obj.value;
            }
        }
	
	
	
	var WindowHeight=Math.max(document.documentElement.clientHeight,document.body.clientHeight)-20
	var WindowWidth=Math.max(document.documentElement.clientWidth,document.body.clientWidth)-10
	
	var table=Ext.BDP.FunLib.getParam('AutCode');    //获取传过来的表
	
	
	var sheetstr=tkMakeServerCall("web.DHCBL.BDP.BDPDataImport","GetEILinkInfo",table);
	var sheet_from=1,sheet_to=1 //,row_from=sheetstr;
	//if (row_from=="") 
	var row_from=3		
			
	var EILType="BDPData";
	var sheetname,sheetid,colModel;
	var col = [], Record=[],colError = [],RecordError=[];
	var Alldata=[],data =[],AllDataEr=[],TxtData=[],personRecord,PageData=[];
	var xlApp,xlBook,xlsheet,xlsheet2,fso,txtfile;
	var errorpre_grid,error_grid,error_store,errorpre_store,grid,tb,sm,store;
	var colcount=0,rowcount=0,count=0,errorcount=0,selectModel=0,AllErrorcount=0;
	var GridpageSize=25,errorGridpageSize=25,errorpreGridpageSize=25;
	//var ErrorMsgInfo="请尝试以下解决方法：(1)打开IE,在[internet选项]-[安全]-[受信任的站点]-[站点]中添加开始界面到可信任的站点，然后在[自定义级别]中对[没有标记为安全的ActiveX控件进行初始化和脚本运行]这一项设置为启用，确定后，重启浏览器。(2)运行:regsvr32 scrrun.dll。(3)运行regedit，找到：HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Internet Explorer\ActiveX Compatibility\{00000566-0000-0010-8000-00AA006D2EA4},在右窗格中，双击“Compatibility Flags”。在“编辑 DWORD 值”对话框中，确保选中“十六进制”选项，在“数值数据”框中键入 0，然后单击“确定”。 "
	var ErrorMsgInfo="请先确认本机有安装office软件，并且要读取的表格文件不是受保护视图。打开IE,在[internet选项]-[安全]-[受信任的站点]-[站点]中添加开始界面到可信任的站点，然后在[自定义级别]中对[没有标记为安全的ActiveX控件进行初始化和脚本运行]这一项设置为启用，确定后，重启浏览器。 "
	//2019-03-11 chenying
	var row,taskcount;
	
	///查看导入日志
	var Log_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.BDP.BDPDataImport&pClassMethod=GetDataLogOfImport";
	var logds = new Ext.data.Store({
				proxy : new Ext.data.HttpProxy({url : Log_ACTION_URL}),
				reader : new Ext.data.JsonReader({
							totalProperty : 'total',
							root : 'data',
							successProperty : 'success'
						}, [{
									name : 'ID',
									mapping : 'ID',
									type : 'string'
								}, {
									name : 'IpAddress',
									mapping : 'IpAddress',
									type : 'string'
								}, {
									name : 'TableName',
									mapping : 'TableName',
									type : 'string'
								}, {
									name : 'ClassName',
									mapping : 'ClassName',
									type : 'string'
								}, {
									name : 'ClassNameDesc',
									mapping : 'ClassNameDesc',
									type : 'string'
								}, {
									name : 'ObjectReference',
									mapping : 'ObjectReference',
									type : 'string'
								}, {
									name : 'ObjectDesc',
									mapping : 'ObjectDesc',
									type : 'string'
								}, {
									name : 'UpdateUserDR',
									mapping : 'UpdateUserDR',
									type : 'string'
								}, {
									name : 'UpdateUserName',
									mapping : 'UpdateUserName',
									type : 'string'
								}, {
									name : 'UpdateDate',
									mapping : 'UpdateDate',
									type : 'string'
								}, {
									name : 'UpdateTime',
									mapping : 'UpdateTime',
									type : 'time'
								}, {
									name : 'OperateType',
									mapping : 'OperateType',
									type : 'string'
								} 
						])
			});
			
	var pagesize_pop=10;
	var logpaging = new Ext.PagingToolbar({
				pageSize : pagesize_pop,
				store : logds,
				displayInfo : true,
				displayMsg : '显示第 {0} 条到 {1} 条记录,一共 {2} 条',
				emptyMsg : "没有记录",
				plugins : [new Ext.BDP.FunLib.PagingToolbarResizer()],
				listeners : {
					"change":function (t,p) {
						pagesize_main=this.pageSize;
					}
				}
			});		
	//创建grid
	var loggrid = new Ext.grid.GridPanel({
				id : 'loggrid',
				region : 'center',
				closable : true,
				trackMouseOver : true,
				// monitorResize : true,
				trackMouseOver : true,
				columnLines : true,
				store : logds,
				stripeRows : true,
				stateful : true,
				viewConfig : {
					forceFit: true,  
					scrollOffset: 0 , 
					emptyText:"<span style='color:red;<font size=15>;font-weight:bold;'>没有检索到相关数据。</span>",
    				autoFill:true,
    				enableRowBody: true  
				},
				sm:new Ext.grid.RowSelectionModel({singleSelect:true}),
				columns : [new Ext.grid.CheckboxSelectionModel(),  
						 {
							header : 'ID',
							sortable : true,
							dataIndex : 'ID',
							width : 20,
							hidden : true
						},{
							header : '功能描述',
							sortable : true,
							dataIndex : 'ClassNameDesc', 
							renderer: Ext.BDP.FunLib.Component.GirdTipShow,
							width : 70
						},{
							header : '表名称',
							hidden:true,
							sortable : true,
							dataIndex : 'TableName',
							renderer: Ext.BDP.FunLib.Component.GirdTipShow,
							width : 60
						}, {
							header : '类名称',
							sortable : true,
							hidden:true,
							dataIndex : 'ClassName',
							renderer: Ext.BDP.FunLib.Component.GirdTipShow,
							width :60
						},{
							header : '对象ID',
							sortable : true,
							dataIndex : 'ObjectReference',
							width : 30
						},{
							header : '对象描述',
							sortable : true,
							width:70,
							dataIndex : 'ObjectDesc'
						}, {
							header : '操作人 ',
							sortable : true,
							dataIndex : 'UpdateUserName',
							renderer: Ext.BDP.FunLib.Component.GirdTipShow,
							width:55
						}, {
							header : '操作类型',
							sortable : true,
							dataIndex : 'OperateType',
							width : 40,
							renderer : function(v){
								if(v=='R'){return "<img src='"+Ext.BDP.FunLib.Path.URL_Icon +"plugin.gif''>"+"   读取";}
								if(v=='U'){return "<img src='"+Ext.BDP.FunLib.Path.URL_Icon +"update.gif''>"+"   修改";}
								if(v=='D'){return "<img src='"+Ext.BDP.FunLib.Path.URL_Icon +"delete.gif''>"+"   删除";}
								if(v=='A'){return "<img src='"+Ext.BDP.FunLib.Path.URL_Icon +"add.gif''>"+"   添加";}
							}
						} , {
							header : '操作人IP',
							sortable : true,
							dataIndex : 'IpAddress',
							width : 60
						},  {
							header : '操作人ID',
							sortable : true,
							hidden:true,
							width:35,
							dataIndex : 'UpdateUserDR'
						}, {
							header : '操作日期',
							sortable : true,
							//renderer : Ext.util.Format.dateRenderer('Y-m/d'),
							dataIndex : 'UpdateDate',
							width:65
						}, {
							header : '操作时间',
							sortable : true,
							dataIndex : 'UpdateTime',
							width:65
						}],
				title : '基础数据日志管理',
				//tools:Ext.BDP.FunLib.Component.HelpMsg,
				monitorResize: true,
				doLayout: function() {
					this.setSize(Ext.get(this.getEl().dom.parentNode).getSize(true));
					Ext.grid.GridPanel.prototype.doLayout.call(this);
			   },
				bbar : logpaging,
				//tbar : tb,
				stateId : 'loggrid'
			});		
	
	var logPanel = new Ext.Window({
		height:WindowHeight,
		width:WindowWidth,
		title:'导入基础数据日志管理',
		layout : 'border',
		id:'logPanel',
		closeAction : 'hide',
		items:[loggrid]
	})
			
	
 	///动态生成列表格
  	var DetailCM=[]	
    var Detailfd = [];
    var DetailsDs=new Ext.data.JsonStore({
   		fields:Detailfd
  	});
 
	 var DetailGrid=new Ext.grid.GridPanel({
	   columns:DetailCM,
	   store:DetailsDs,
	   width:700,
	   height:400,
	   autoScroll:true
  	});
 
	var win = new Ext.Window({
		width :900,
		layout : 'fit',
		plain : true,
		modal : true,
		frame : true,
		collapsible : true,
		constrain : true,
		hideCollapseTool : true,
		titleCollapse : true,
		buttonAlign : 'center',
		closeAction : 'hide',
		items :[DetailGrid],
		viewConfig : {
					forceFit: true, // 注意不要用autoFill:true,那样设置的话当GridPanel的大小变化(比如你resize了它)时不会自动调整column的宽度
					scrollOffset: 0 ,//不加这个的话,会在grid的最右边有个空白,留作滚动条的位置
    				autoFill:true,
    				enableRowBody: true  
				},
		listeners : {
				"show" : function() {
								 
				},
				"hide" : function(){
						  DetailCM = []	
   						  Detailfd = [];  
						  win.hide()
					}
				}	 
			});
			
	////无法解析json时的弹出窗口
	var winU = new Ext.Window({
		title : '修正的数据',
		width : 900,
		layout : 'fit',
		plain : true, 
		modal : true,
		frame : true,
		autoScroll : true,
		collapsible : true,
		constrain : true,
		hideCollapseTool : true,
		titleCollapse : true,
		buttonAlign : 'center',
		closeAction : 'hide',
		items : [new Ext.form.TextArea({
				id : 'UpdateDataText',
				readOnly : true,
				width :900,
				height : 400
		})]
	});
	
	////日志的原始数据与修正数据进行比对，颜色显示
	loggrid.on("rowdblclick", function(grid, rowIndex, e){
		var gsm = grid.getSelectionModel(); 
		var rows = gsm.getSelections(); 
		var Operation=grid.selModel.getSelections()[0].get('OperateType');
		if(Operation=="U"){
			Operation="修改操作"			
		}
		if(Operation=="A"){
			Operation="添加操作"			
		}
		if(Operation=="D"){
			Operation="删除操作"			
		}
		if(rows.length>0)
		{
		   	var ClassUserName=grid.selModel.getSelections()[0].get('ClassName');
		   	if ((ClassUserName!="User.BDPPreferences")&&(ClassUserName!="User.BDPTableList"))
		   	{
				var link="dhc.bdp.bdp.timeline.csp?actiontype=datadetail&id="+grid.selModel.getSelections()[0].get('ID');
				var link=encodeURI(link)
				if ('undefined'!==typeof websys_getMWToken)
		        {
					link += "&MWToken="+websys_getMWToken() //增加token
				}
				var Log_Win = new Ext.Window
				({
					title:grid.selModel.getSelections()[0].get('ClassNameDesc')+"->"+Operation,
					width :900,
					height :400,
					layout : 'fit',
				 	plain : true, 
				 	modal : true,
				 	frame : true,
					// autoScroll : true,
				 	constrain : true,
					closeAction : 'hide'  
					});
				 	Log_Win.html='<iframe src=" '+link+' " width="100%" height="100%"></iframe>';
				 	Log_Win.show();
			   	}
			   	else
				{
					try
					{
						var OldValueJson=""
						var redata =""
						var record = grid.getSelectionModel().getSelected();
						var id=record.get('ID');
						var ShowOperate=record.get('OperateType'); 
						var UserClass=record.get("ClassName");
						var ClassNameDesc = record.get('ClassNameDesc');
				        var showTitleName=ClassNameDesc 
				        var returnJson=tkMakeServerCall("web.DHCBL.BDP.BDPDataChangeLog","GetDataDetail",id);
				        var objectJson=eval('(' + returnJson + ')');
				     	var newdata =objectJson.NewValue    
				     	/// 再次调用后台json数据 
				     	
				     	/// 正常情况下,NewValue 是非空的 
				     	if (newdata!=""){
					        var jsondata = eval('(' + newdata + ')');
					        var newjson = "{";
					        var oldjson2="{";
					        var olddata= objectJson.OldValue     /// record.get('OldValue');		
				       
				       		 /// 原始数据存在  undefined 情况未处理？？捕获异常后抛出异常
				       	 	if (olddata!=""){ 
				        		//修改 :存在一种情况：操作是修改，但是没有OldValue,只有 NewValue
				     	 		 var oldjson= eval('('+olddata+')')
					     		 redata = [oldjson,jsondata]
				        	}
						    else{
						    	////olddata 为空
						    	 redata = [jsondata]
						    }
							for(var x in jsondata)
							{
								
							  	if (newjson!= "{")
						     	{
						     		newjson = newjson + ","
						     	}
						     	if (oldjson2!= "{")
						     	{
						     		oldjson2 = oldjson2 + ","
						     	}
						     	/// 获取属性
						     	var Property=tkMakeServerCall("web.DHCBL.BDP.BDPTableList","GetPropDescByCode",UserClass,x);
						     	var PropertyData=tkMakeServerCall("web.DHCBL.BDP.BDPTableList","GetPropValue",UserClass,x,jsondata[x]);
						     	
					     	    PropertyData=PropertyData.substring(1,(PropertyData.length-1));
							 
						     	var res = {fields:[{name:""+x+""}],columns:[{header:""+Property+"",dataIndex:""+x+"",width:130,sortable:true}]};  
						     	var columns = res.columns;
					    		var fields = res.fields;
					     		for (var i = 0; i < fields.length; i++) {
					     	 		Detailfd.push(fields[i].name);
					     	 		DetailCM.push(columns[i]);
					     		}
					     		if(olddata!=""){
					     			var PropertyDataY=tkMakeServerCall("web.DHCBL.BDP.BDPTableList","GetPropValue",UserClass,x,oldjson[x]);
					     		 	PropertyDataY=PropertyDataY.substring(1,(PropertyDataY.length-1));
					     			// 原始数据与现数据进行比较
					     			if(PropertyDataY!=PropertyData)
						     		{ ///bordeR-bottom:20px solid blue;   bordeR-bottom:20px solid red; 
						  	   	 		newjson = newjson + x+":"+'"<span style='+"'color:Red;bold:true;text-decoration:none'"+'>'+PropertyData +'</span>"'	
						     			oldjson2= oldjson2 + x+":"+'"<span style='+"'color:blue;bold:true; text-decoration:none'"+'>'+PropertyDataY +'</span>"'	
						     		}
						     		else
						     		{
						     			newjson = newjson + x+":"+'"'+PropertyData +'"'	
						     			oldjson2= oldjson2+ x+":"+'"'+PropertyDataY +'"'	
						     		}  		
					     		}
					     		else{ /// 如果是 添加或者删除时，进行拼串
					     			newjson = newjson + x+":"+'"'+PropertyData +'"'	
					     		}
					  		}
						   		var newjson = newjson + "}";
						 		var newjsondata = eval('(' + newjson + ')');
						 		
						 		var oldjson = oldjson2 + "}";
						 		var oldjson = eval('(' + oldjson + ')');
								win.show();
						 	}
						 	else{
								///  newdata为空的情况 : 直接进入 异常捕获了，没有进行下一步的执行。	
						 		Ext.getCmp('UpdateDataText').setValue(OldValue);
						 	}
						 
							var ss=new Ext.data.JsonStore({ 
								fields:Detailfd  
							}) 	
							DetailGrid.reconfigure(ss,new Ext.grid.ColumnModel(DetailCM));
							
							Ext.BDP.FunLib.Newline(DetailGrid);
							if(olddata!=""){
								ss.loadData([oldjson,newjsondata]);  
								win.setIconClass("icon-update")
								win.setTitle(showTitleName+"      "+"修改数据：第一行为原始数据，第二行为修正后数据")
							}
							else{
								if(ShowOperate=="U"){
									ss.loadData([newjsondata])
									win.setTitle(showTitleName+"     "+"修改数据：修正后数据")
									win.setIconClass("icon-update")
								}
								
								if (ShowOperate=="A"){
									ss.loadData([newjsondata])
									win.setTitle(showTitleName+"     "+"添加数据")
									win.setIconClass("icon-add")
								}
							   if (ShowOperate=="D"){
							   		ss.loadData([newjsondata])
									win.setTitle(showTitleName+"      "+"删除数据")
									win.setIconClass("icon-delete")
								} 
							  }
						 }
					 	catch (e) 
						{
							/// 捕获异常后
					   		if((newdata!="")&&(ShowOperate=="U")){
					   			Ext.getCmp('UpdateDataText').setValue(olddata+"->"+newdata);
					   		}
						   	if((olddata!="")&&(ShowOperate=="U")){
						   		Ext.getCmp('UpdateDataText').setValue(olddata+"->"+newdata); 
						   	}
						   	if((ShowOperate=="A")||(ShowOperate=="D")){
						   		if(newdata!=""){
						   			Ext.getCmp('UpdateDataText').setValue(newdata); 
						   	}
					   	}
					   	winU.show()  
					 }
				}
			 }
	});		
	
	///查看导入日志 end
	
	
	

	
	
	////数据预览， 校验，导入，错误信息查看弹出框
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
		
	
	function ReturnResult(strrr,Vtype)
	{
		
			if ((strrr.indexOf("^")<=0))
			{
				Ext.Msg.show({
					title : '提示',
					msg : strrr,
					icon : Ext.Msg.ERROR,
					buttons : Ext.Msg.OK
				});
				return;
								
			}
			else
			{
				///strrr=TotalCount_"^"_SuccessCount_"^"_ErrorCount  
				
				var ReturnCount=strrr.split("^");		
				var TotalCount=ReturnCount[0];
				var SuccessCount=ReturnCount[1];
				var ErrorCount=ReturnCount[2];
					
				
				if (ErrorCount!=0)
				{
					////2016-10-27 导入失败的数据 重新生成一个excel
					var AllErrorcount=tkMakeServerCall("web.DHCBL.BDP.BDPDataImport","GetExErrorDataCount",EILType,table);
					AllDataEr=[];
			      	if (AllErrorcount>0)
					{
						for (var i=1;i<=AllErrorcount;i++){
							var dataEr=[]
							var DataDetailStr2=tkMakeServerCall("web.DHCBL.BDP.BDPDataImport","GetErrorFieldValue",table,i);
							var Detail2=DataDetailStr2.split("&%");		
							for (var j=1;j<=Detail2.length;j++){
								dataEr.push(Detail2[j-1])
							}
							AllDataEr.push(dataEr);
						}
						
					}
					
					if (Vtype=="V")
					{
						errorpre_store.proxy= new Ext.ux.data.PagingMemoryProxy(AllDataEr);  
        				errorpre_store.load({params:{start:0, limit:errorpreGridpageSize}});
        				//errorpre_store.removeAll();
        				//errorpre_store.loadData(AllDataEr);
						centertab.setActiveTab(1); 
						alert("校验完成，共计"+TotalCount+"条数据，"+SuccessCount+"条数据校验通过，"+ErrorCount+"条数据校验失败。")
					}
					else
					{
						error_store.proxy= new Ext.ux.data.PagingMemoryProxy(AllDataEr);  
        				error_store.load({params:{start:0, limit:errorGridpageSize}});
						//error_store.removeAll();
						//error_store.loadData(AllDataEr);
						centertab.setActiveTab(2); 
						alert("导入完成，共计"+TotalCount+"条数据，"+SuccessCount+"条数据导入成功，"+ErrorCount+"条数据导入失败。")
					}
				
				}
				else
				{
					if (Vtype=="V")
					{
						///2019-01-30
						errorpre_store.proxy= new Ext.ux.data.PagingMemoryProxy([]);  
        				errorpre_store.load({params:{start:0, limit:errorpreGridpageSize}});
        				Ext.getCmp("error_grid").getStore().removeAll();
						Ext.getCmp("errorpre_grid").getStore().removeAll();
						alert("校验完成，共计"+TotalCount+"条数据，"+SuccessCount+"条数据校验通过，"+ErrorCount+"条数据校验失败。")
					}
					else
					{
						Ext.getCmp("errorpre_grid").getStore().removeAll();
						Ext.getCmp("error_grid").getStore().removeAll();
						alert("导入完成，共计"+TotalCount+"条数据，"+SuccessCount+"条数据导入成功，"+ErrorCount+"条数据导入失败。")
						centertab.setActiveTab(0);  
						logds.baseParams={table:table};
						logds.load();
						logPanel.show();
					}
				}
				
				
				
		}
	}
	var idTmr="";
	function Cleanup(){   
	 	window.clearInterval(idTmr);   
	 	CollectGarbage();
	}
	//2019-1-30 改成真的进度条。 chenying
	ImportData=function(){
		
		var strrr =tkMakeServerCall("web.DHCBL.BDP.BDPDataImport","BeforeSaveImportData",EILType);
		if (strrr!="")
		{
			
			Ext.Msg.show({
				title : '提示',
				msg : strrr,
				icon : Ext.Msg.ERROR,
				buttons : Ext.Msg.OK
			});
			return;
		}
		var errorRow="";//没有插入的行
		var updateRow="";
		var skipRow="";
		
		var errorMsg="";
		
		var row=0,taskcount=rowcount-2;
		var ProgressText='';
		var winproBar = new Ext.Window({
				closable:false,
				modal:true,
				width:314,
				items:[
					new Ext.ProgressBar({id:'proBar1',text:'',width:300})
				] 
		});
		
		var proBar=new Ext.getCmp('proBar1');
		//导入数据
		Ext.TaskMgr.start({  
		  run:function(){
		  	row++;
		  	if(row>taskcount) //当到达最后一行退出
		  	{
		  		if(errorRow!=""){
					errorMsg="导入完成，第"+errorRow+"行插入失败!" ;			
				}else{
					errorMsg="导入完成!"
				}
				Ext.MessageBox.hide();
				//alert(errorMsg)
				
				
				//idTmr = window.setInterval("Cleanup();",1);
				Ext.TaskMgr.stop(this);
				winproBar.close();
				var strrr =tkMakeServerCall("web.DHCBL.BDP.BDPDataImport","AfterSaveImportData",EILType);
				ReturnResult(strrr,"S")
		  	}
		  	else
		  	{
				var Flag =tkMakeServerCall("web.DHCBL.BDP.BDPDataImport","SaveImportDatai",EILType,row+2);
				//alert(tempStr)
				/*if (Flag=="0"){  //保存失败
					if(errorRow!=""){
						errorRow=errorRow+","+i
					}else{
						errorRow=i
					}
				}*/

				tempStr=""
			    progressText = "正在导入第"+row+"条记录,总共"+taskcount+"条记录!";  
			    proBar.updateProgress(row/taskcount,progressText);
			  }
				 
		  },  
		  interval:20  
		});
		winproBar.show();
							
		
						
	
	}
	/*
	ImportData=function(){
		
					
							Ext.MessageBox.wait('正在导入,请稍候...请勿刷新或关闭窗口','提示');
							var SaveImportDataUrl = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.BDP.BDPDataImport&pClassMethod=SaveImportData";
							Ext.Ajax.timeout = 180000000;  //毫秒  默认为30000(30秒)
							
							Ext.Ajax.request({
								url : SaveImportDataUrl,
								method : 'POST',
								params : {
									'type' : EILType
								},
								callback : function(options, success, response) {
									if (success) {
										var strrr=response.responseText;
										Ext.MessageBox.hide();
										if (strrr=="")
										{
											Ext.Msg.show({
													title : '提示',
													msg : '程序报错，校验失败!',
													icon : Ext.Msg.ERROR,
													buttons : Ext.Msg.OK
												});
										}
										else
										{
											ReturnResult(strrr,"S")	
										}
									} else {
										Ext.MessageBox.hide();
										Ext.Msg.show({
													title : '提示',
													msg : '异步通讯失败,请检查网络连接!',
													icon : Ext.Msg.ERROR,
													buttons : Ext.Msg.OK
												});
									}
								}
							}, this);
							
							
	
	}*/
	
	
	var BasePanel = new Ext.Window({
		height:WindowHeight,
		width:WindowWidth,
		title:'数据预览',
		layout : 'border',
		id:'BasePanel',
		closeAction : 'hide',
		items:[centertab],
		buttonAlign:'center',
		buttons:[{
				text:'预校验数据',
				iconCls : 'icon-ok',
				handler:function(){
						//if (selectModel!=0)	
							Ext.MessageBox.wait('正在校验,请稍候...请勿刷新或关闭窗口','提示');
							///var strrr =tkMakeServerCall("web.DHCBL.BDP.BDPDataImport","PreCheckValidate",EILType);
							var PreCheckValidateUrl = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.BDP.BDPDataImport&pClassMethod=PreCheckValidate";
							///2017-04-07  解决后台返回结果超过一分钟时页面提示刷新的问题
							Ext.Ajax.timeout = 180000000;  //毫秒  默认为30000(30秒)
							
							Ext.Ajax.request({
								url : PreCheckValidateUrl,
								method : 'POST',
								params : {
									'type' : EILType
								},
								callback : function(options, success, response) {
									if (success) {
										var strrr=response.responseText;
										Ext.MessageBox.hide();
										if (strrr=="")
										{
											Ext.Msg.show({
													title : '提示',
													msg : '程序报错，校验失败!',
													icon : Ext.Msg.ERROR,
													buttons : Ext.Msg.OK
												});
										}
										else
										{
											ReturnResult(strrr,"V")	
										}
									} else {
										Ext.MessageBox.hide();
										Ext.Msg.show({
													title : '提示',
													msg : '异步通讯失败,请检查网络连接!',
													icon : Ext.Msg.ERROR,
													buttons : Ext.Msg.OK
												});
									}
								}
							}, this);
						
						
							
						
				}
			},	
			{
				text:'一键导入',
				iconCls : 'icon-save',
				handler:function(){
					
					
					winPassword.setTitle('导入Excel文件密码');
					winPassword.show();  
					
					
					
				}
			},{
				text:'关闭',
				iconCls : 'icon-close',
				handler:function(){
					BasePanel.hide();
					
					
				}
			}],
		listeners : {
			"show" : function() {
			},
			"hide" : function() {
				centertab.removeAll();
				var killstr =tkMakeServerCall("web.DHCBL.BDP.BDPDataImport","KillImportGof")
			},
			"close" : function() {
			}
		}
	});
	
	
	
	
	function ExportErrorLogToExcel()
	{
			if (!isIE())
			{
				alert("请在IE下执行！"); return;
			}
			try{
		    	xlApp= new ActiveXObject("Excel.Application");
				xlBook = xlApp.Workbooks.Add();///默认三个sheet
			}catch(e){
				//alert(e.message);
				var emsg="不能生成表格文件。"+ErrorMsgInfo;
				Ext.Msg.show({
					title : '提示',
					msg : emsg ,
					minWidth : 200,
					icon : Ext.Msg.INFO,
					buttons : Ext.Msg.OK
				}) 
			    return;
			}
			
			errorcount=tkMakeServerCall("web.DHCBL.BDP.BDPDataImport","GetExErrorDataCount",EILType,table);
			
			if (errorcount>0)
			{
			
				
				xlBook.worksheets(1).select(); 
				xlsheet = xlBook.ActiveSheet; 
				//var table=Ext.BDP.FunLib.TableName;
				sheetname=tkMakeServerCall("web.DHCBL.BDP.BDPDataImport","GetMenuDesc",table);  ////获取菜单导入导出代码对应的描述
				if (sheetname!="") 
				{
					xlsheet.name=sheetname;
				}

				///第一行为描述，第二行为字段名，数据从第三行开始
				var TitleInfoStr=tkMakeServerCall("web.DHCBL.BDP.BDPDataImport","GetFieldInfo",table);  
				///收费项目代码*&TARICode*&1&%收费项目名称*&TARIDesc*&1&%单价*&TPPrice*&1&%收费项目单位*&TARIUOM*&1&%科目类别（代码）*&TARIItemCatDR*&0
				var TitleInfoArr=TitleInfoStr.split("&%");
				//第二行	
				for (var m = 0; m < TitleInfoArr.length; m++) {
					var CellTitleInfo=TitleInfoArr[m]
					var CellTitleInfoarr=CellTitleInfo.split("*&");
					
					xlsheet.cells(row_from-2,m+1)=CellTitleInfoarr[0];   ///第一行 字段描述
		    		xlsheet.cells(row_from-1,m+1)=CellTitleInfoarr[1];   ///第二行 字段名
		    		
		    		xlsheet.cells(row_from-2,m+1).Font.Bold = true; //设置为粗体
					xlsheet.cells(row_from-1,m+1).Font.Bold = true; //设置为粗体 
					xlsheet.cells(row_from-2,m+1).WrapText=true;  //设置为自动换行*
					xlsheet.cells(row_from-1,m+1).WrapText=true;  //设置为自动换行*
					//设置单元格底色*(1-黑色，2-白色，3-红色，4-绿色，5-蓝色，6-黄色，7-粉红色，8-天蓝色，9-酱土色.)
					//xlsheet.cells(1,i+1).Interior.ColorIndex = 5;  ///蓝色底色
					///xlsheet.cells(2,i+1).Interior.ColorIndex = 5;
					if (CellTitleInfoarr[2]==1)
					{
						//设置设置字体颜色
						xlsheet.cells(row_from-2,m+1).Font.ColorIndex = 3;  ///字体红色
						xlsheet.cells(row_from-1,m+1).Font.ColorIndex = 3;
					}
					else
					{
						xlsheet.cells(row_from-2,m+1).Font.ColorIndex = 1;  
						xlsheet.cells(row_from-1,m+1).Font.ColorIndex = 1;
					}
				}
				xlsheet.cells(row_from-2,TitleInfoArr.length+1)="对应表格行";
				xlsheet.cells(row_from-2,TitleInfoArr.length+2)="报错信息";
				xlsheet.cells(row_from-2,TitleInfoArr.length+1).Font.Bold = true; //设置为粗体
				xlsheet.cells(row_from-2,TitleInfoArr.length+2).Font.Bold = true; //设置为粗体\

				
				
				
				var row=0,taskcount=errorcount;
				var ProgressText='';
				var winproBar = new Ext.Window({
						closable:false,
						modal:true,
						width:314,
						items:[
							new Ext.ProgressBar({id:'proBar2',text:'',width:300})
						] 
				});
				var proBar=new Ext.getCmp('proBar2');
				//导出错误数据
				Ext.TaskMgr.start({  
				  run:function(){
				  	row++;
				  	if(row>taskcount) //当到达最后一行退出
				  	{
				  		var ExcelInstruction=tkMakeServerCall("web.DHCBL.BDP.BDPDataImport","GetExcelInstruction",table);
						try
						{
							xlBook.worksheets(2).select(); 
							xlsheet2 = xlBook.ActiveSheet;
							xlsheet2.cells(1,1)=ExcelInstruction;
							xlsheet2.name="说明";
							xlBook.worksheets(1).select(); 
						}
						catch(e)
						{
							
							xlBook.worksheets(1).select(); 
						}
						
						//alert(errorMsg)
						
						
						//idTmr = window.setInterval("Cleanup();",1);
						Ext.TaskMgr.stop(this);
						winproBar.close();
						
						xlApp.Visible=true;	
						xlBook.Close(savechanges=true);
						
						
						//var fname = xlApp.Application.GetSaveAsFilename(sheetname+".xls", "Excel Spreadsheets (*.xls), *.xls");
						//xlBook.SaveAs(fname);
						//xlApp.Quit();
						CollectGarbage();
						xlApp=null;
						xlsheet=null;
						xlsheet2=null;	
							
				  	}
				  	else
				  	{
						var DataDetailStr=tkMakeServerCall("web.DHCBL.BDP.BDPDataImport","GetExcelErrorFieldValue",table,row);
						var Detail=DataDetailStr.split("&%");		
						for (var j=1;j<=Detail.length;j++){
							xlsheet.cells(row_from-1+row,j)="'"+Detail[j-1];
							
						}
						progressText = "正在导出第"+row+"条记录,总共"+(taskcount)+"条记录!";  
					    proBar.updateProgress(row/taskcount,progressText);
					  }
						 
				  },  
				  interval:20  
				});
				winproBar.show();
		
			
				
				
				
			}
			else
			{
				
				
				Ext.Msg.show({
						title : '提示',
						msg : '没有错误数据' ,
						minWidth : 200,
						icon : Ext.Msg.INFO,
						buttons : Ext.Msg.OK
					}) 
				    return;
			}
	}
	
	   
	
	
	
	
	
	
	
	
	
	
	
	function ExportAllErrorInfoToExcel()
	{
			if (!isIE())
			{
				alert("请在IE下执行！"); return;
			}
			try{
		    	xlApp= new ActiveXObject("Excel.Application");
				xlBook = xlApp.Workbooks.Add();///默认三个sheet
			}catch(e){
				//alert(e.message);
				var emsg="不能生成表格文件。"+ErrorMsgInfo;
				Ext.Msg.show({
					title : '提示',
					msg : emsg ,
					minWidth : 200,
					icon : Ext.Msg.INFO,
					buttons : Ext.Msg.OK
				}) 
			    return;
			}
			
			errorcount=tkMakeServerCall("web.DHCBL.BDP.BDPDataImport","GetAllExErrorDataCount",EILType,table);
			
			if (errorcount>0)
			{
				xlBook.worksheets(1).select(); 
				xlsheet = xlBook.ActiveSheet; 
				//var table=Ext.BDP.FunLib.TableName;
				sheetname=tkMakeServerCall("web.DHCBL.BDP.BDPDataImport","GetMenuDesc",table);  ////获取菜单导入导出代码对应的描述
				if (sheetname!="") 
				{
					xlsheet.name=sheetname;
				}
	
				
				
				///第一行为描述，第二行为字段名，数据从第三行开始
				var TitleInfoStr=tkMakeServerCall("web.DHCBL.BDP.BDPDataImport","GetFieldInfo",table);  
				///收费项目代码*&TARICode*&1&%收费项目名称*&TARIDesc*&1&%单价*&TPPrice*&1&%收费项目单位*&TARIUOM*&1&%科目类别（代码）*&TARIItemCatDR*&0
				var TitleInfoArr=TitleInfoStr.split("&%");
				//第二行	
				for (var m = 0; m < TitleInfoArr.length; m++) {
					var CellTitleInfo=TitleInfoArr[m]
					var CellTitleInfoarr=CellTitleInfo.split("*&");
					
					xlsheet.cells(row_from-2,m+1)=CellTitleInfoarr[0];   ///第一行 字段描述
		    		xlsheet.cells(row_from-1,m+1)=CellTitleInfoarr[1];   ///第二行 字段名
		    		
		    		xlsheet.cells(row_from-2,m+1).Font.Bold = true; //设置为粗体
					xlsheet.cells(row_from-1,m+1).Font.Bold = true; //设置为粗体 
					xlsheet.cells(row_from-2,m+1).WrapText=true;  //设置为自动换行*
					xlsheet.cells(row_from-1,m+1).WrapText=true;  //设置为自动换行*
					//设置单元格底色*(1-黑色，2-白色，3-红色，4-绿色，5-蓝色，6-黄色，7-粉红色，8-天蓝色，9-酱土色.)
					//xlsheet.cells(1,i+1).Interior.ColorIndex = 5;  ///蓝色底色
					///xlsheet.cells(2,i+1).Interior.ColorIndex = 5;
					if (CellTitleInfoarr[2]==1)
					{
						//设置设置字体颜色
						xlsheet.cells(row_from-2,m+1).Font.ColorIndex = 3;  ///字体红色
						xlsheet.cells(row_from-1,m+1).Font.ColorIndex = 3;
					}
					else
					{
						xlsheet.cells(row_from-2,m+1).Font.ColorIndex = 1;  
						xlsheet.cells(row_from-1,m+1).Font.ColorIndex = 1;
					}
				}
				xlsheet.cells(row_from-2,TitleInfoArr.length+1)="对应表格行";
				xlsheet.cells(row_from-2,TitleInfoArr.length+2)="报错信息";
				xlsheet.cells(row_from-2,TitleInfoArr.length+1).Font.Bold = true; //设置为粗体
				xlsheet.cells(row_from-2,TitleInfoArr.length+2).Font.Bold = true; //设置为粗体\
				

				var row=0,taskcount=errorcount-2;
				var ProgressText='';
				var winproBar = new Ext.Window({
						closable:false,
						modal:true,
						width:314,
						items:[
							new Ext.ProgressBar({id:'proBar3',text:'',width:300})
						] 
				});
				var proBar=new Ext.getCmp('proBar3');
				///导出全部错误信息
				Ext.TaskMgr.start({  
				  run:function(){
				  	row++;
				  	if(row>taskcount) //当到达最后一行退出
				  	{
				  		var ExcelInstruction=tkMakeServerCall("web.DHCBL.BDP.BDPDataImport","GetExcelInstruction",table);
						try
						{
							xlBook.worksheets(2).select(); 
							xlsheet2 = xlBook.ActiveSheet;
							xlsheet2.cells(1,1)=ExcelInstruction;
							xlsheet2.name="说明";
							xlBook.worksheets(1).select(); 
						}
						catch(e)
						{
							
							xlBook.worksheets(1).select(); 
						}
						
						//alert(errorMsg)			
						//idTmr = window.setInterval("Cleanup();",1);
						Ext.TaskMgr.stop(this);
						winproBar.close();
						
						xlApp.Visible=true;	
						xlBook.Close(savechanges=true);
						//var fname = xlApp.Application.GetSaveAsFilename(sheetname+".xls", "Excel Spreadsheets (*.xls), *.xls");
						//xlBook.SaveAs(fname);
						//xlApp.Quit();
						CollectGarbage();
						xlApp=null;
						xlsheet=null;
						xlsheet2=null;	
							
				  	}
				  	else
				  	{
				  		
				  		////要加2
						var DataDetailStr=tkMakeServerCall("web.DHCBL.BDP.BDPDataImport","GetExcelAllErrorFieldValue",table,row+2);
						var Detail=DataDetailStr.split("&%");		
						for (var j=1;j<=Detail.length;j++){
							xlsheet.cells(row_from-1+row,j)="'"+Detail[j-1];
							
						}
						progressText = "正在导出第"+row+"条记录,总共"+(taskcount)+"条记录!";  
					    proBar.updateProgress(row/taskcount,progressText);
					  }
						 
				  },  
				  interval:20  
				});
				winproBar.show();
				
			}
			else
			{
				Ext.Msg.show({
						title : '提示',
						msg : '没有错误数据' ,
						minWidth : 200,
						icon : Ext.Msg.INFO,
						buttons : Ext.Msg.OK
					}) 
				    return;
			}
	}
	
 	
 	
 	
 	////装载数据
	function PreReadData(filepath,table,filetype)
	{
		//console.log(new Date());
		Alldata=[];
		var errorMsg="", errorRow="";     //没有插入的行，错误信息
		var killstr =tkMakeServerCall("web.DHCBL.BDP.BDPDataImport","KillImportGof");   ///k ^TMPIMPORTDATA(mySysID)

		sheetid=1;
		if (filetype=="EXCEL") 
		{
			
			if (sheetstr=="") {alert("请先设置导入导出配置表"); return;}
			
			
			/*var sheetTmp = sheetstr.split("&%");
			
			
			if (sheetTmp[0]=="") {alert("请先设置导入导出配置表"); return;}
			else{ sheet_from=parseInt(sheetTmp[0]);}
		
			if (sheetTmp[1]=="") {alert("请先设置导入导出配置表"); return;}
			else{ sheet_to=parseInt(sheetTmp[1]);}
			
			if (sheetTmp[2]=="") {var row_from=3;}
			else{ row_from=parseInt(sheetTmp[2]);}
			*/
			
			
			try{ 
				xlApp = new ActiveXObject("Excel.application"); 
				xlBook = xlApp.Workbooks.open(filepath);   //xlBook = xlApp.Workbooks.add(ImportFile);
			}		
			catch(e){
				var emsg="不能读取表格文件。"+ErrorMsgInfo;
				Ext.Msg.show({
					title : '提示',
					msg : emsg ,
					minWidth : 200,
					icon : Ext.Msg.INFO,
					buttons : Ext.Msg.OK
				}) 
				return;
			}

			///for(var sheetid=sheet_from;sheetid<=sheet_to;sheetid++) {
	
			xlBook.worksheets(sheetid).select(); 
			xlsheet = xlBook.ActiveSheet; 
			sheetname=tkMakeServerCall("web.DHCBL.BDP.BDPDataImport","GetMenuDesc",table);  ////获取菜单导入导出代码对应的描述
			if (sheetname=="导入说明") 
			{
				//alert("导入的表格数据不对");
				return;
			}
			/////2016-10-28 读取时有两个列忽略   
			rowcount=xlsheet.UsedRange.Cells.Rows.Count ;  ///行数			alert(rowcount)
			
			colcount=xlsheet.UsedRange.Cells.Columns.Count;  ///列数
			
			sheetname=tkMakeServerCall("web.DHCBL.BDP.BDPDataImport","GetMenuDesc",table);  ////获取菜单导入导出代码对应的描述
			//表格 医院列识别码特殊
			if (table=="CT_Loc")
			{
				if (xlsheet.Cells(2,1).value!='CTLOCHospitalDR')
				{
					//科室模板里的医院为CTLOCHospitalDR
					xlBook.Close(savechanges=false);
					CollectGarbage();
					xlApp=null;
					xlsheet=null;
					alert('非公有数据，医院列必须在第一列！')
					return;
				}	
			}
			else if (table=="DHC_TarItemPrice")
			{
				if (xlsheet.Cells(2,1).value!='TPHospitalDR')
				{
					//收费项价格 TPHospitalDR
					xlBook.Close(savechanges=false);
					CollectGarbage();
					xlApp=null;
					xlsheet=null;
					alert('非公有数据，医院列必须在第一列！')
					return;	
				}
			}
			else if (table=="SS_UserOtherLogonLoc")
			{
				if (xlsheet.Cells(2,1).value!='OTHLLHospitalDR')
				{
					//用户其他登录科室 OTHLLHospitalDR
					xlBook.Close(savechanges=false);
					CollectGarbage();
					xlApp=null;
					xlsheet=null;
					alert('非公有数据，医院列必须在第一列！')
					return;	
				}
			}
			else if (table=="DHCExaBorough")
			{
				if (xlsheet.Cells(2,1).value!='ExabHospitalDr')
				{
					//分诊区 ExabHospitalDr
					xlBook.Close(savechanges=false);
					CollectGarbage();
					xlApp=null;
					xlsheet=null;
					alert('非公有数据，医院列必须在第一列！')
					return;	
				}
			}
			else if (table=="ARC_OrdSets")
			{
				if (xlsheet.Cells(2,1).value!='FavUseHospDr')
				{
					//医嘱套 FavUseHospDr
					xlBook.Close(savechanges=false);
					CollectGarbage();
					xlApp=null;
					xlsheet=null;
					alert('非公有数据，医院列必须在第一列！')
					return;	
				}
			}
			else if (table=="CT_LocBuilding")
			{
				if (xlsheet.Cells(2,1).value!='CTLBHospitalDR')
				{
					//医院楼 CTLBHospitalDR
					xlBook.Close(savechanges=false);
					CollectGarbage();
					xlApp=null;
					xlsheet=null;
					alert('非公有数据，医院列必须在第一列！')
					return;	
				}
			}
			else if (table=="SS_User") //用户 表格 医院列识别码比较特殊  放在第4列。
			{
				/*if ((xlsheet.Cells(2,1).value!='SSUSRHospitalDR'))
				{	
					alert('非公有数据，医院列必须在第一列！')
					return;
					
				}*/
			}
			else
			{
				var TableName =tkMakeServerCall("web.DHCBL.BDP.BDPEIMenu","GetTableNameByCode",table)  //获取菜单对应的表结构登记代码
				var DataTypeFlag =tkMakeServerCall("web.DHCBL.BDP.BDPMappingHOSP","GetDataType",TableName)  //获取表的公私有类型
				if (DataTypeFlag!="G")
				{
					if ((xlsheet.Cells(2,1).value!='LinkHospId'))
					{	
						xlBook.Close(savechanges=false);
						CollectGarbage();
						xlApp=null;
						xlsheet=null;
						alert('非公有数据，第一列必须是医院！')
						return;
						
					}
				}
			}
			
			
			var propdescStr="",propnameStr="";
			
			//alert(colcount)
			for (var n=1;n<=colcount;n++){
				
				var propdesc="";
				var propname="";
				
				////2017-03-17 遇到第一行和第二行为空的列则跳出循环 不导入这些数据
				if ((typeof(xlsheet.Cells(row_from-1,n).value)=="undefined")) 
				{
					//break;
				}
				else 
				{
					propname=xlsheet.Cells(row_from-1,n).value;
				}
				
				if ((typeof(xlsheet.Cells(row_from-2,n).value)=="undefined"))
				{
					//break;
				}
				else 
				{
					propdesc=xlsheet.Cells(row_from-2,n).value;
				}
				
				
				if ((xlsheet.Cells(row_from-2,n).value=="对应表格行")||(xlsheet.Cells(row_from-2,n).value=="报错信息"))
				{
					break;
				}
				else
				{
					if ((n==1))
					{
						propnameStr=propname;
						propdescStr=propdesc;
					}
					else
					{
						
						propnameStr=propnameStr+("&%"+propname)
						propdescStr=propdescStr+("&%"+propdesc);		
						
					}
				}
			}
			///2017-03-23 校验字段列有没有空，有没有重复的，有没有没配置的  有没有必填项缺少的
			var flagstr =tkMakeServerCall("web.DHCBL.BDP.BDPDataImport","ValidatePropertyName",table,propnameStr)
			if (flagstr!="") 
			{
				xlBook.Close(savechanges=false);
				CollectGarbage();
				xlApp=null;
				xlsheet=null;
				alert(flagstr);
				return;
			}
			
			///默认全导入  导入类型为只追加
			var imstr =tkMakeServerCall("web.DHCBL.BDP.BDPDataImport","ImportTabBaseInfo",EILType,sheetid,sheetname,table,propdescStr,propnameStr);    //propdescStr
			if (imstr!=1) {
				xlBook.Close(savechanges=false);
				CollectGarbage();
				xlApp=null;
				xlsheet=null;
				alert(imstr);
				return;
				
			}
			

			colcount=n-1
			
			col = [], Record=[];
    		col.push({header: '对应表格行',sortable : true,dataIndex : 'row',width:80});
    		Record.push({name : 'row',type : 'int'});
    		for (var line=1;line<=colcount;line++)	
			{
				//fields.push({name : 'name',mapping : 'mapping',type : 'string'});	
	    		col.push({header: 'name',sortable : true,dataIndex : 'mapping',width:140,renderer : Ext.BDP.FunLib.Component.GirdTipShow});	
				var namev="";
				if (typeof(xlsheet.Cells(row_from-1,line).value)=="undefined") namev="";
				else namev=xlsheet.Cells(row_from-1,line).value;
				
				var headv="";
				if (typeof(xlsheet.Cells(row_from-2,line).value)=="undefined") headv="";
				else headv=xlsheet.Cells(row_from-2,line).value;
				
				col[line].header=headv;
				col[line].dataIndex=namev;
				
				Record.push({name : 'name',type : 'string'});
				Record[line].name=namev;
			
			}
			
			
		}
		else
		{
			if (filetype=="TXT") 
			{
				///txt要求是ANSI编码
				try{ 
					fso = new ActiveXObject("Scripting.FileSystemObject");
					txtfile = fso.OpenTextFile(filepath, 1,true);  /// 只读=1，只写=2 ，追加=8 等权限。（ForReading 、 ForWriting 或 ForAppending 。
					///var f=fso.opentextfile(filepath,1，true); 
				}		
				catch(e){
					alert((e.message))
					/*var emsg="不能读取txt文件。"+ErrorMsgInfo;
					Ext.Msg.show({
						title : '提示',
						msg : emsg ,
						minWidth : 200,
						icon : Ext.Msg.INFO,
						buttons : Ext.Msg.OK
					}) */
					return;
				}	
				
				
				sheetname=tkMakeServerCall("web.DHCBL.BDP.BDPDataImport","GetImportTableNameDesc",table); //获取sheet的表中文含义
				//读取第一行，列头
				var TxtlineinfoDesc=txtfile.ReadLine();
				var TxtlineinfoDescArray=new Array();   
		  		TxtlineinfoDescArray=TxtlineinfoDesc.split("	");
		  		
		  		var propdescStr="",propnameStr="";
				
				colcount=0;  ///列数 字段个数
				for(var i=0;i<TxtlineinfoDescArray.length;i++){
					colcount=colcount+1;
					if ((TxtlineinfoDescArray[i]=="对应表格行")||(TxtlineinfoDescArray[i]=="报错信息"))  ///导入时略过报错信息
					{
						break;
					}
				}
				
				col = [], Record=[];
				col.push({header: '对应表格行',sortable : true,dataIndex : 'row',width:80});
				Record.push({name : 'row',type : 'int'});
				
				for(var i=0;i<colcount;i++){
					var propdesc="";
					var namev="";
					var headv="";
					if (TxtlineinfoDescArray[i]=="undefined")
					{
						propdesc="";
						namev="";
						headv="";
					}
					else
					{
						propdesc=TxtlineinfoDescArray[i];
						namev=TxtlineinfoDescArray[i];
						headv=TxtlineinfoDescArray[i];
					}
					
					if (i==0) propdescStr=propdesc;
					else propdescStr=propdescStr+("&%"+propdesc);

					col.push({header: 'name',sortable : true,dataIndex : 'mapping',width:140,renderer : Ext.BDP.FunLib.Component.GirdTipShow});	
					
					col[i+1].header=headv;
					col[i+1].dataIndex=namev;
					
					Record.push({name : 'name',type : 'string'});
					Record[i+1].name=namev;
					
				}
				
				var TxtlineinfoName=txtfile.ReadLine();
				var TxtlineinfoNameArray=new Array();   
		  		TxtlineinfoNameArray=TxtlineinfoName.split("	");
		  		
		  		colcount=0;  ///列数 字段个数
				for(var i=0;i<TxtlineinfoNameArray.length;i++){
					colcount=colcount+1;
					if ((TxtlineinfoNameArray[i]=="对应表格行")||(TxtlineinfoNameArray[i]=="报错信息"))  ///导入时略过报错信息
					{
						break;
					}
				}
				
				for(var i=0;i<colcount;i++){
					var propname="";
					if (TxtlineinfoNameArray[i]=="undefined")
					{
						propname="";
					}
					else
					{
						propname=TxtlineinfoNameArray[i];
						
					}
					
					if (i==0) propnameStr=propname;
					else propnameStr=propnameStr+("&%"+propname);
				}
				///2017-03-23 校验字段列有没有空，有没有重复的，有没有没配置的  有没有必填项缺少的
				var flagstr =tkMakeServerCall("web.DHCBL.BDP.BDPDataImport","ValidatePropertyName",table,propnameStr)
				if (flagstr!="") 
				{
					alert(flagstr);
					return;
				}
				
				
				rowcount=2;
				TxtData=[]
				while (!txtfile.AtEndOfStream)  //判断是否读取到最后一行 
				{ 
					rowcount=rowcount+1;  // 行数
					TxtData[rowcount]=txtfile.ReadLine();
				}
				
				///默认全导入  导入类型为只追加  ///要改成传name
				var imstr =tkMakeServerCall("web.DHCBL.BDP.BDPDataImport","ImportTabBaseInfo",EILType,sheetid,sheetname,table,propdescStr,propnameStr);
				if (imstr!=1) {alert(imstr);return;}

				
			}
			else ///GOF
			{
				var im=tkMakeServerCall("web.DHCBL.BDP.BDPDataImport","ImportGof",filepath,EILType);
				
				var datainfo =tkMakeServerCall("web.DHCBL.BDP.BDPDataImport","GetImportGofInfo",EILType);  //1&%CT_Country&%国家
				if (datainfo=="") {
				
					alert("请先设置导入gof相关配置");return; 
					
					}
				
				var arryTmp = datainfo.split("#%");
				//for(var intRow = 0; intRow < arryTmp.length; intRow ++)
				//{
					var intRow = 0
					var goftable_id=intRow+1;
					var myPortlet = arryTmp[intRow];
					if(myPortlet == "") return;
					
					var arryField = myPortlet.split("&%");
					sheetid=arryField[0];
					var tablename=arryField[1];
					
					rowcount =tkMakeServerCall("web.DHCBL.BDP.BDPDataImport","GetTableGofCount",EILType,sheetid,table);  //20
		    		sheetname=arryField[2]; //获取sheet的表中文含义
					
					
					//}	
					
					var fieldinfo =tkMakeServerCall("web.DHCBL.BDP.BDPDataImport","GetTableGridCm",EILType,sheetid,table);
		    		///KBDCode&%代码#%KBDCode&%代码#%KBDName&%描述#%TableName&%数据来源
		    		col = [],Record=[];
		    		col.push({header: 'row',sortable : true,dataIndex : 'row',width:80});
		    		Record.push({name : 'row',type : 'int'});
		    		
		    		var colarray = fieldinfo.split("#%");
		    		colcount=colarray.length;
					for(var coli = 0; coli < colarray.length; coli ++)
					{
						var colistr = colarray[coli];  //KBDCode&%代码
						if(colistr == "") continue;
						
						var Field = colistr.split("&%");
						var fieldname=Field[0];
						var fieldnamedesc=Field[1];
						col.push({header: 'name',sortable : true,dataIndex : 'mapping',width:140,renderer : Ext.BDP.FunLib.Component.GirdTipShow});	
						//fields[line-1].name=namev;
						//fields[line-1].mapping=namev;
						
						col[coli+1].header=fieldnamedesc;
						col[coli+1].dataIndex=fieldname;
						Record.push({name : 'name',type : 'string'});
						Record[coli+1].name=fieldname;	
						
					}
			}
			
			
		}
		
		
		if (rowcount>0)
		{
			sm = new Ext.grid.CheckboxSelectionModel({singleSelect : false});
    		
			// caihaozhe 
			/*sm.on("rowselect", function(e, rowIndex, record) {
				var rowid = record.get('row');
				var tabid =centertab.getActiveTab().id.replace("_tab","");
				var str= new Array();   
				str=tabid.split("##");
				var gridid = str[0];
				var tablename2 = str[1];
				selectModel=selectModel+1;
				Ext.getCmp(gridid +'_grid').getView().getRow(rowIndex).className='x-grid3-row x-grid3-row-selected x-grid3-row-chz';
			    var Flag =tkMakeServerCall("web.DHCBL.BDP.BDPDataImport","updatedataflag",EILType,gridid,tablename2,rowid,"Y");
			});*/
			
			/*sm.on("rowdeselect", function(e, rowIndex, record) {
				var rowid = record.get('row');
				var tabid =centertab.getActiveTab().id.replace("_tab","");
				var str= new Array();   
				str=tabid.split("##");
				var gridid = str[0];
				var tablename2 = str[1];
				selectModel=selectModel-1;
				Ext.getCmp(gridid +'_grid').getView().getRow(rowIndex).className='x-grid3-row';
				var Flag =tkMakeServerCall("web.DHCBL.BDP.BDPDataImport","updatedataflag",EILType,gridid,tablename2,rowid,"N");       
			});*/

			
			
			
			personRecord = Ext.data.Record.create(Record);
			
			colModel = new Ext.grid.ColumnModel({columns:col});
			//colModel.columns.unshift(sm);  //添加到数组的头部
				//||(table=="DHC_PHCCat")
				var importtypedata=[{
						name : '追加数据',value : 'J'
					/*}, {
						name : '修正数据',value : 'U'*/
					}, {
						name : '新装数据(慎选)',value : 'N'
					}]	
					
				if ((table=="INC_Itm")||(table=="DHC_TarItem")||(table=="ARC_ItmMast")||(table=="DHC_TarItemPrice")||(table=="SS_Group")||(table=="BDP_TableList")||(table=="SSUSRFreeText3")||(table=="TARIInsuCode"))
				{
					importtypedata=[{
						name : '追加数据',value : 'J'
					}]	
				}
				tb = new Ext.Toolbar({
					items : [//'是否导入这张表：', 
						/*{
					id : EILType+"#"+sheetid+"#"+'tableflag',
					width:80,
					hidden:true,
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
									name : '是',value : 'Y'
								}, {
									name : '否',value : 'N'
								}]
					}),
					listeners : {
								'select' : function(combo, record, index) {
									var typeFlag =tkMakeServerCall("web.DHCBL.BDP.BDPDataImport","updatetableflag",this.id,this.value);	
								}
							}
						},*/
						
						'导入类型：', {
							id : EILType+"#"+sheetid+"#"+'importtype',
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
								data : importtypedata
							}),
							listeners : {
										'select' : function(combo, record, index) {
											var typeFlag =tkMakeServerCall("web.DHCBL.BDP.BDPDataImport","updateimporttype",this.id,this.value);	
										}
									}
								}   ,'->',
								
								 new Ext.Button({
									iconCls : 'icon-refresh',
									text : '<font style="color:red;">重新装载数据</font>',
									handler : function() {
										
										
										
											Ext.getCmp(EILType+"#"+sheetid+"#"+'importtype').setValue("J");
											Ext.getCmp(EILType+"#"+sheetid+"#"+'importtype').setRawValue("追加数据");
											Alldata=[];
											var errorMsg="", errorRow="";     //没有插入的行，错误信息
											var killstr =tkMakeServerCall("web.DHCBL.BDP.BDPDataImport","KillImportGof");   ///k ^TMPIMPORTDATA(mySysID)
									
											sheetid=1;
											if (filetype=="EXCEL") 
											{
												if (sheetstr=="") {alert("请先设置导入导出配置表"); return;}
												
												try{ 
													xlApp = new ActiveXObject("Excel.application"); 
													xlBook = xlApp.Workbooks.open(filepath);   //xlBook = xlApp.Workbooks.add(ImportFile);
												}		
												catch(e){
													var emsg="不能读取表格文件。"+ErrorMsgInfo;
													Ext.Msg.show({
														title : '提示',
														msg : emsg ,
														minWidth : 200,
														icon : Ext.Msg.INFO,
														buttons : Ext.Msg.OK
													}) 
													return;
												}
									
												///for(var sheetid=sheet_from;sheetid<=sheet_to;sheetid++) {
										
												xlBook.worksheets(sheetid).select(); 
												xlsheet = xlBook.ActiveSheet; 
												sheetname=tkMakeServerCall("web.DHCBL.BDP.BDPDataImport","GetMenuDesc",table);  ////获取菜单导入导出代码对应的描述
												if (sheetname=="导入说明") 
												{
													//alert("导入的表格数据不对");
													return;
												}
												/////2016-10-28 读取时有两个列忽略   
												rowcount=xlsheet.UsedRange.Cells.Rows.Count ;  ///行数			alert(rowcount)
												
												colcount=xlsheet.UsedRange.Cells.Columns.Count;  ///列数
												
												
												var propdescStr="",propnameStr="";
												
												//alert(colcount)
												for (var n=1;n<=colcount;n++){
													var propdesc="";
													var propname="";
													
													////2017-03-17 遇到第一行和第二行为空的列则跳出循环 不导入这些数据
													if ((typeof(xlsheet.Cells(row_from-1,n).value)=="undefined")) 
													{
														//break;
													}
													else 
													{
														propname=xlsheet.Cells(row_from-1,n).value;
													}
													
													if ((typeof(xlsheet.Cells(row_from-2,n).value)=="undefined"))
													{
														//break;
													}
													else 
													{
														propdesc=xlsheet.Cells(row_from-2,n).value;
													}
													
													
													if ((xlsheet.Cells(row_from-2,n).value=="对应表格行")||(xlsheet.Cells(row_from-2,n).value=="报错信息"))
													{
														break;
													}
													else
													{
														if ((n==1))
														{
															propnameStr=propname;
															propdescStr=propdesc;
														}
														else
														{
															
															propnameStr=propnameStr+("&%"+propname)
															propdescStr=propdescStr+("&%"+propdesc);		
															
														}
													}
												}
												
												
												///2017-03-23 校验字段列有没有空，有没有重复的，有没有没配置的  有没有必填项缺少的
												var flagstr =tkMakeServerCall("web.DHCBL.BDP.BDPDataImport","ValidatePropertyName",table,propnameStr)
												if (flagstr!="") 
												{
													alert(flagstr);
													return;
												}
												
												///默认全导入  导入类型为只追加
												var imstr =tkMakeServerCall("web.DHCBL.BDP.BDPDataImport","ImportTabBaseInfo",EILType,sheetid,sheetname,table,propdescStr,propnameStr);    //propdescStr
												if (imstr!=1) {alert(imstr);return;}
												
									
												colcount=n-1
												
												col = [], Record=[];
									    		col.push({header: '对应表格行',sortable : true,dataIndex : 'row',width:80});
									    		Record.push({name : 'row',type : 'int'});
									    		for (var line=1;line<=colcount;line++)	
												{
													//fields.push({name : 'name',mapping : 'mapping',type : 'string'});	
										    		col.push({header: 'name',sortable : true,dataIndex : 'mapping',width:140,renderer : Ext.BDP.FunLib.Component.GirdTipShow});	
													var namev="";
													if (typeof(xlsheet.Cells(row_from-1,line).value)=="undefined") namev="";
													else namev=xlsheet.Cells(row_from-1,line).value;
													
													var headv="";
													if (typeof(xlsheet.Cells(row_from-2,line).value)=="undefined") headv="";
													else headv=xlsheet.Cells(row_from-2,line).value;
													
													col[line].header=headv;
													col[line].dataIndex=namev;
													
													Record.push({name : 'name',type : 'string'});
													Record[line].name=namev;
												
												}
												
												
											}
											else
											{
												if (filetype=="TXT") 
												{
													///txt要求是ANSI编码
													try{ 
														fso = new ActiveXObject("Scripting.FileSystemObject");
														txtfile = fso.OpenTextFile(filepath, 1,true);  /// 只读=1，只写=2 ，追加=8 等权限。（ForReading 、 ForWriting 或 ForAppending 。
														///var f=fso.opentextfile(filepath,1，true); 
													}		
													catch(e){
														alert((e.message))
														return;
													}	
													
													
													sheetname=tkMakeServerCall("web.DHCBL.BDP.BDPDataImport","GetImportTableNameDesc",table); //获取sheet的表中文含义
													//读取第一行，列头
													var TxtlineinfoDesc=txtfile.ReadLine();
													var TxtlineinfoDescArray=new Array();   
											  		TxtlineinfoDescArray=TxtlineinfoDesc.split("	");
											  		
											  		var propdescStr="",propnameStr="";
													
													colcount=0;  ///列数 字段个数
													for(var i=0;i<TxtlineinfoDescArray.length;i++){
														colcount=colcount+1;
														if ((TxtlineinfoDescArray[i]=="对应表格行")||(TxtlineinfoDescArray[i]=="报错信息"))  ///导入时略过报错信息
														{
															break;
														}
													}
													
													col = [], Record=[];
													col.push({header: '对应表格行',sortable : true,dataIndex : 'row',width:80});
													Record.push({name : 'row',type : 'int'});
													
													for(var i=0;i<colcount;i++){
														var propdesc="";
														var namev="";
														var headv="";
														if (TxtlineinfoDescArray[i]=="undefined")
														{
															propdesc="";
															namev="";
															headv="";
														}
														else
														{
															propdesc=TxtlineinfoDescArray[i];
															namev=TxtlineinfoDescArray[i];
															headv=TxtlineinfoDescArray[i];
														}
														
														if (i==0) propdescStr=propdesc;
														else propdescStr=propdescStr+("&%"+propdesc);
									
														col.push({header: 'name',sortable : true,dataIndex : 'mapping',width:140,renderer : Ext.BDP.FunLib.Component.GirdTipShow});	
														
														col[i+1].header=headv;
														col[i+1].dataIndex=namev;
														
														Record.push({name : 'name',type : 'string'});
														Record[i+1].name=namev;
														
													}
													
													var TxtlineinfoName=txtfile.ReadLine();
													var TxtlineinfoNameArray=new Array();   
											  		TxtlineinfoNameArray=TxtlineinfoName.split("	");
											  		
											  		colcount=0;  ///列数 字段个数
													for(var i=0;i<TxtlineinfoNameArray.length;i++){
														colcount=colcount+1;
														if ((TxtlineinfoNameArray[i]=="对应表格行")||(TxtlineinfoNameArray[i]=="报错信息"))  ///导入时略过报错信息
														{
															break;
														}
													}
													
													for(var i=0;i<colcount;i++){
														var propname="";
														if (TxtlineinfoNameArray[i]=="undefined")
														{
															propname="";
														}
														else
														{
															propname=TxtlineinfoNameArray[i];
															
														}
														
														if (i==0) propnameStr=propname;
														else propnameStr=propnameStr+("&%"+propname);
													}
													///2017-03-23 校验字段列有没有空，有没有重复的，有没有没配置的  有没有必填项缺少的
													var flagstr =tkMakeServerCall("web.DHCBL.BDP.BDPDataImport","ValidatePropertyName",table,propnameStr)
													if (flagstr!="") 
													{
														alert(flagstr);
														return;
													}
													
													
													rowcount=2;
													TxtData=[]
													while (!txtfile.AtEndOfStream)  //判断是否读取到最后一行 
													{ 
														rowcount=rowcount+1;  // 行数
														TxtData[rowcount]=txtfile.ReadLine();
													}
													
													///默认全导入  导入类型为只追加  ///要改成传name
													var imstr =tkMakeServerCall("web.DHCBL.BDP.BDPDataImport","ImportTabBaseInfo",EILType,sheetid,sheetname,table,propdescStr,propnameStr);
													if (imstr!=1) {alert(imstr);return;}
									
													
												}
												else ///GOF
												{
													var im=tkMakeServerCall("web.DHCBL.BDP.BDPDataImport","ImportGof",filepath,EILType);
													
													var datainfo =tkMakeServerCall("web.DHCBL.BDP.BDPDataImport","GetImportGofInfo",EILType);  //1&%CT_Country&%国家
													if (datainfo=="") {
													
														alert("请先设置导入gof相关配置");return; 
														
														}
													
													var arryTmp = datainfo.split("#%");
													//for(var intRow = 0; intRow < arryTmp.length; intRow ++)
													//{
													var intRow = 0
													var goftable_id=intRow+1;
													var myPortlet = arryTmp[intRow];
													if(myPortlet == "") return;
													
													var arryField = myPortlet.split("&%");
													sheetid=arryField[0];
													var tablename=arryField[1];
													
													rowcount =tkMakeServerCall("web.DHCBL.BDP.BDPDataImport","GetTableGofCount",EILType,sheetid,table);  //20
										    		sheetname=arryField[2]; //获取sheet的表中文含义
													
													
													//}	
													
													var fieldinfo =tkMakeServerCall("web.DHCBL.BDP.BDPDataImport","GetTableGridCm",EILType,sheetid,table);
										    		///KBDCode&%代码#%KBDCode&%代码#%KBDName&%描述#%TableName&%数据来源
										    		col = [],Record=[];
										    		col.push({header: 'row',sortable : true,dataIndex : 'row',width:80});
										    		Record.push({name : 'row',type : 'int'});
										    		
										    		var colarray = fieldinfo.split("#%");
										    		colcount=colarray.length;
													for(var coli = 0; coli < colarray.length; coli ++)
													{
														var colistr = colarray[coli];  //KBDCode&%代码
														if(colistr == "") continue;
														
														var Field = colistr.split("&%");
														var fieldname=Field[0];
														var fieldnamedesc=Field[1];
														col.push({header: 'name',sortable : true,dataIndex : 'mapping',width:140,renderer : Ext.BDP.FunLib.Component.GirdTipShow});	
														//fields[line-1].name=namev;
														//fields[line-1].mapping=namev;
														
														col[coli+1].header=fieldnamedesc;
														col[coli+1].dataIndex=fieldname;
														Record.push({name : 'name',type : 'string'});
														Record[coli+1].name=fieldname;	
														
													}
												}
												
												
											}
											
											
											if (rowcount>0)
											{
												if (filetype=="EXCEL")  { row=0,taskcount=rowcount-2}			
												if (filetype=="TXT") { row=0,taskcount=TxtData.length-2 }
												if (filetype=="GOF"){  row=0,taskcount=rowcount  }			
												var ProgressText='';
												var winproBar = new Ext.Window({
														closable:false,
														modal:true,
														width:314,
														items:[
															new Ext.ProgressBar({id:'proBar4',text:'',width:300})
														] 
												});
												var proBar=new Ext.getCmp('proBar4');
												//装载预览
												Ext.TaskMgr.start({  
												  run:function(){
												  	row++;
												  	if(row>taskcount) //当到达最后一行退出
												  	{
												  		//idTmr = window.setInterval("Cleanup();",1);
														Ext.TaskMgr.stop(this);
														winproBar.close();
														
											            var store = new Ext.data.Store({
											                proxy: new Ext.ux.data.PagingMemoryProxy(Alldata),
											                remoteSort:true,
											                pageSize:GridpageSize,
											                reader: new Ext.data.ArrayReader({}, Record )
											            });
												        Ext.getCmp(sheetid +'_grid').reconfigure(store,new Ext.grid.ColumnModel(col)); 
												     	Ext.getCmp(sheetid +'_grid').getBottomToolbar().bind(store);   ///2017-12-01 解决页码条数据总条数不刷新的问题
												     	store.loadData(Alldata)
											            centertab.setActiveTab(0);  
														BasePanel.show();
														CollectGarbage();
														if (filetype=="EXCEL") 
														{
															xlBook.Close (savechanges=false);
															CollectGarbage();
															//xlApp.Quit(); 
															xlApp=null;
															xlsheet=null;
															xlBook=null;
														}
														else
														{
															if (filetype=="TXT") 
															{
																txtfile.close(); 
															}
															else  ///GOF
															{	
															}
														}
															
												  	}
												  	else
												  	{
												  		if (filetype=="EXCEL") 
														{
																var tempStr="";
																var data =[];
																for (var j=0;j<=colcount;j++){
																	if (j==0)
																	{
																		data.push(row+2);
																	}
																	else
																	{
																		var cellvalue="";
																		if (typeof(xlsheet.Cells(row+2,j).value)=="undefined")
																		{
																			cellvalue="";
																		}
																		else if(typeof(xlsheet.Cells(row+2,j).value)=="date") 
																		{
																			cellvalue=xlsheet.Cells(row+2,j).value;
																			if (cellvalue!="") cellvalue=(new Date(cellvalue)).format(BDPDateFormat)   ///20170830 对表格里为日期的数据进行转换成文本格式对应的标准日期格式
																		}
																		else if (typeof(xlsheet.Cells(row+2,j).value)=="number") 
																		{
																		 	///20171201 对表格里为数字的数据进行转换成文本格式，有些数字虽然设置了文本，但实际仍是数值类型 ??
																		 	///74.1  ->74.10000000000001,  31.08 -> 31.080000000000002
																			xlsheet.Columns(j).NumberFormatLocal = "@";   ///设置某列单元格格式为文本格式  20170830
																			xlsheet.Cells(row+2,j).value="'"+xlsheet.Cells(row+2,j).value
																			//if (j==11) alert(cellvalue)
																			cellvalue=xlsheet.Cells(row+2,j).value;
																			//if (j==11) alert(cellvalue)
																		}
																		else
																		{
																			cellvalue=xlsheet.Cells(row+2,j).value;
																		}
																		
																		
																		if (j==1)  tempStr=cellvalue;
																		else tempStr=tempStr+("&%"+cellvalue);
																		data.push(cellvalue);
																	}
																}
																
																Alldata.push(data);
																var Flag =tkMakeServerCall("web.DHCBL.BDP.BDPDataImport","ImportIntoGlobal",EILType,table,sheetid,row+2,tempStr,"Y");  //默认Y ，不通过勾选选择了  2017-2-11
															
														}
														else
														{
															if (filetype=="TXT")
															{
																
																	var tempStr="";
																	var data =[];
																	var Txtlineinfo=TxtData[row+2]
																	var TxtlineinfoArray=new Array();   
															  		TxtlineinfoArray=Txtlineinfo.split("	");
															  		
																	for(var j=0;j<=TxtlineinfoArray.length;j++){
																		
																		if (j==0)
																		{
																			data.push(row+2);
																			tempStr=cellvalue;
																		}
																		else
																		{
																			var cellvalue="";
																			if (TxtlineinfoArray[j]=="undefined") cellvalue="";
																			else cellvalue=TxtlineinfoArray[j-1];
												
																			if (j==1)  tempStr=cellvalue;
																			else tempStr=tempStr+("&%"+cellvalue);		
																			
																			data.push(cellvalue);
																			
																		}
																	}
																	Alldata.push(data);
																	
																	var Flag =tkMakeServerCall("web.DHCBL.BDP.BDPDataImport","ImportIntoGlobal",EILType,table,sheetid,row+2,tempStr,"Y");	
																
															}
															else ///GOF
															{
																var tempStr="";
																var data =[];
																var gofiinfo =tkMakeServerCall("web.DHCBL.BDP.BDPDataImport","GetTableGofiinfo",EILType,sheetid,table,row);
																var gofiinfoArray=gofiinfo.split("&%")
																///OralDrug&%口服药品&%PHC_Instruc
																for (var j=0;j<=colcount;j++){
																	if (j==0) data.push(row);
																	else  data.push(gofiinfoArray[j-1]);
																}
																Alldata.push(data);
															}
															
														}
														progressText = "正在读取第"+row+"条记录,总共"+(taskcount)+"条记录!";  
													    proBar.updateProgress(row/taskcount,progressText);
													  }
														 
												  },  
												  interval:20  
												});
												winproBar.show();	
												
												
													
											}
											else
											{
												Ext.Msg.show({
														title : '提示',
														msg : '没有数据' ,
														minWidth : 200,
														icon : Ext.Msg.INFO,
														buttons : Ext.Msg.OK
													}) 
												return;
											}
										
										
										
								
										
										
									}
								})
								
								
								///'<font style="color:red;">√ 请勾选需要导入的数据！</font>'
								]
					});
							
					//Ext.getCmp(EILType+"#"+sheetid+"#"+'tableflag').setValue("Y");
					//Ext.getCmp(EILType+"#"+sheetid+"#"+'tableflag').setRawValue("是");
					Ext.getCmp(EILType+"#"+sheetid+"#"+'importtype').setValue("J");
					Ext.getCmp(EILType+"#"+sheetid+"#"+'importtype').setRawValue("追加数据");

		      		
		      		
				AllDataEr=[];
				colError = [],RecordError=[];
	    		
	    		var titleStr=tkMakeServerCall("web.DHCBL.BDP.BDPDataImport","GetFieldDesc",table);
				var title=titleStr.split("&%");
				colcount=title.length;
				
				
				colError.push({header: '对应表格行',sortable : true,dataIndex : 'row',width:80});
	    		RecordError.push({name : 'row',type : 'int'});
	    		
	    		
				colError.push({header: '报错信息',sortable : true,dataIndex : 'errorinfo',width:340,renderer : Ext.BDP.FunLib.Component.GirdTipShow});
	    		RecordError.push({name : 'errorinfo',type : 'string'});
	    		
	    		
				for (var m = 0; m < title.length; m++) {    				
					colError.push({header: '行',sortable : true,dataIndex : 'name',width:140,renderer : Ext.BDP.FunLib.Component.GirdTipShow});
	    			
	    			colError[m+2].header=title[m];
					colError[m+2].dataIndex=title[m];
					
					RecordError.push({name : 'name',type : 'string'});
					RecordError[m+2].name=title[m];
				}
				
				
				
				var colModelError = new Ext.grid.ColumnModel({columns:colError});
				//colModelError.columns.unshift(new Ext.grid.CheckboxSelectionModel({singleSelect : false}))  //添加到数组的头部
				
				
				
				
				
			
				error_store=new Ext.data.Store({
			                proxy: new Ext.ux.data.PagingMemoryProxy([]),
			                remoteSort:true,
			                pageSize:errorGridpageSize,
			                reader: new Ext.data.ArrayReader({}, RecordError )
			            })
			     
			   var error_pagingToolbar = new Ext.PagingToolbar({
					pageSize : errorGridpageSize,
					store : error_store,
					displayInfo : true,
					displayMsg : '显示第 {0} 条到 {1} 条记录,一共 {2} 条',
					emptyMsg : "没有记录",
					plugins : [new Ext.BDP.FunLib.PagingToolbarResizer()],
					listeners : {
						"change":function (t,p) {
							errorGridpageSize=this.pageSize;
						}
					}
				});         
			    
				error_grid=new Ext.grid.GridPanel({
					id : 'error_grid',
					//sm : new Ext.grid.CheckboxSelectionModel({singleSelect : false}), 
					region:'center',
					height:600,
					store :error_store,
					bbar: error_pagingToolbar,
					trackMouseOver : true,
					cm:colModelError,
					stripeRows : true,
					viewConfig : {
						forceFit : (colcount<=4)
					},
					tbar : new Ext.Toolbar({
						items : [new Ext.Button({
									iconCls : 'icon-export',
									text : '导出错误信息到Excel',
									handler : function() {
										ExportErrorLogToExcel()
									}
					
								}), '-'
								,
								new Ext.Button({
									iconCls : 'icon-export',
									text : '导出所有数据及其错误信息到Excel',
									handler : function() {
										ExportAllErrorInfoToExcel()
									}
					
								}), '-'
								
								
						]
					}),    
					columnLines : true, //在列分隔处显示分隔符
					stateId : 'error_grid'
				});
				
				
				errorpre_store=new Ext.data.Store({
			                proxy: new Ext.ux.data.PagingMemoryProxy([]),
			                remoteSort:true,
			                pageSize:errorpreGridpageSize,
			                reader: new Ext.data.ArrayReader({}, RecordError )
			            })
			    var errorpre_pagingToolbar = new Ext.PagingToolbar({
					pageSize : errorpreGridpageSize,
					store : errorpre_store,
					displayInfo : true,
					displayMsg : '显示第 {0} 条到 {1} 条记录,一共 {2} 条',
					emptyMsg : "没有记录",
					plugins : [new Ext.BDP.FunLib.PagingToolbarResizer()],
					listeners : {
						"change":function (t,p) {
							errorpreGridpageSize=this.pageSize;
						}
					}
				});         
			            
			      
			
				errorpre_grid=new Ext.grid.GridPanel({
					id : 'errorpre_grid',
					//sm : new Ext.grid.CheckboxSelectionModel({singleSelect : false}), 
					region:'center',
					height:600,
			        store :errorpre_store,
					bbar: errorpre_pagingToolbar,
					trackMouseOver : true,
					cm: new Ext.grid.ColumnModel({columns:colError}),
					stripeRows : true,
					viewConfig : {
						forceFit : (colcount<=4)
					},
					tbar : new Ext.Toolbar({
						items : [new Ext.Button({
									iconCls : 'icon-export',
									text : '导出错误信息到Excel',
									handler : function() {
										ExportErrorLogToExcel()
									}
					
								}), '-'
								,
								new Ext.Button({
									iconCls : 'icon-export',
									text : '导出所有数据及其错误信息到Excel',
									handler : function() {
										ExportAllErrorInfoToExcel()
									}
					
								}), '-'
								
								
								]
					}),    
					columnLines : true, //在列分隔处显示分隔符
					stateId : 'errorpre_grid'
				});
				
				///sm.selectAll(); 
				if (filetype=="EXCEL")  { row=0,taskcount=rowcount-2}			
				if (filetype=="TXT") { row=0,taskcount=TxtData.length-2 }
				if (filetype=="GOF"){  row=0,taskcount=rowcount  }			
				var ProgressText='';
				var winproBar = new Ext.Window({
						closable:false,
						modal:true,
						width:314,
						items:[
							new Ext.ProgressBar({id:'proBar5',text:'',width:300})
						] 
				});
				var proBar=new Ext.getCmp('proBar5');
				//装载预览
				Ext.TaskMgr.start({  
				  run:function(){
				  	row++;
				  	if(row>taskcount) //当到达最后一行退出
				  	{
				  		//idTmr = window.setInterval("Cleanup();",1);
						Ext.TaskMgr.stop(this);
						winproBar.close();
						
			            var store = new Ext.data.Store({
			                proxy: new Ext.ux.data.PagingMemoryProxy(Alldata),
			                remoteSort:true,
			                pageSize:GridpageSize,
			                reader: new Ext.data.ArrayReader({}, Record )
			            });
				        
			            
			            var pagingToolbar = new Ext.PagingToolbar({
								pageSize : GridpageSize,
								store : store,
								displayInfo : true,
								displayMsg : '显示第 {0} 条到 {1} 条记录,一共 {2} 条',
								emptyMsg : "没有记录",
								plugins : [new Ext.BDP.FunLib.PagingToolbarResizer()],
								listeners : {
									"change":function (t,p) {
										GridpageSize=this.pageSize;
									}
								}
							});
			          	
						var	grid=new Ext.grid.GridPanel({
							id : sheetid +'_grid',
							//sm : sm,
							region:'center',
							height:600,
							store : store,
							trackMouseOver : true,
							cm:colModel,
							tbar:tb,
							bbar: pagingToolbar,
							stripeRows : true,
							viewConfig : {
								forceFit : (colcount<6)
							},
							columnLines : true, //在列分隔处显示分隔符
							stateId : sheetid +'_grid'
						});
						store.load({params:{start:0, limit:GridpageSize}});
						
						var tabId = sheetid +"_tab" +"##" + table;
						
						var tabname;
						if (sheetname=="")
						{
							tabname="数据";
						}
						else 
						{
							tabname=sheetname;
						}
						var obj2=centertab.add({
					    	id:tabId,
					    	layout:'fit',
				        	title:tabname,
				        	items:[grid]
				  		 });
				  		
						
				
				 
						var obj4=centertab.add({
					    	id:'errorpre_gridtab',
					    	layout:'fit',
				        	title:"校验结果",
				        	items:[errorpre_grid]
				  		 });
				 		
				 		var obj3=centertab.add({
					    	id:'error_gridtab',
					    	layout:'fit',
				        	title:"导入结果",
				        	items:[error_grid]
				  		 });
						      	
				    	///Ext.MessageBox.hide();    	
						centertab.setActiveTab(0);  
						BasePanel.show();
						CollectGarbage();
						if (filetype=="EXCEL") 
						{
							xlBook.Close (savechanges=false);
							CollectGarbage();
							//xlApp.Quit(); 
							xlApp=null;
							xlsheet=null;
							xlBook=null;
						}
						else
						{
							if (filetype=="TXT") 
							{
								txtfile.close(); 
							}
							else  ///GOF
							{	
							}
						}
							
				  	}
				  	else
				  	{
				  		if (filetype=="EXCEL") 
						{
								var tempStr="";
								var data =[];
								for (var j=0;j<=colcount;j++){
									if (j==0)
									{
										data.push(row+2);
									}
									else
									{
										var cellvalue="";
										if (typeof(xlsheet.Cells(row+2,j).value)=="undefined")
										{
											cellvalue="";
										}
										else if(typeof(xlsheet.Cells(row+2,j).value)=="date") 
										{
											cellvalue=xlsheet.Cells(row+2,j).value;
											if (cellvalue!="") cellvalue=(new Date(cellvalue)).format(BDPDateFormat)   ///20170830 对表格里为日期的数据进行转换成文本格式对应的标准日期格式
										}
										else if (typeof(xlsheet.Cells(row+2,j).value)=="number") 
										{
										 	///20171201 对表格里为数字的数据进行转换成文本格式，有些数字虽然设置了文本，但实际仍是数值类型 ??
										 	///74.1  ->74.10000000000001,  31.08 -> 31.080000000000002
											xlsheet.Columns(j).NumberFormatLocal = "@";   ///设置某列单元格格式为文本格式  20170830
											xlsheet.Cells(row+2,j).value="'"+xlsheet.Cells(row+2,j).value
											//if (j==11) alert(cellvalue)
											cellvalue=xlsheet.Cells(row+2,j).value;
											//if (j==11) alert(cellvalue)
										}
										else
										{
											cellvalue=xlsheet.Cells(row+2,j).value;
										}
										
										
										if (j==1)  tempStr=cellvalue;
										else tempStr=tempStr+("&%"+cellvalue);
										data.push(cellvalue);
									}
								}
								
								Alldata.push(data);
								var Flag =tkMakeServerCall("web.DHCBL.BDP.BDPDataImport","ImportIntoGlobal",EILType,table,sheetid,row+2,tempStr,"Y");  //默认Y ，不通过勾选选择了  2017-2-11
							
						}
						else
						{
							if (filetype=="TXT")
							{
								
									var tempStr="";
									var data =[];
									var Txtlineinfo=TxtData[row+2]
									var TxtlineinfoArray=new Array();   
							  		TxtlineinfoArray=Txtlineinfo.split("	");
							  		
									for(var j=0;j<=TxtlineinfoArray.length;j++){
										
										if (j==0)
										{
											data.push(row+2);
											tempStr=cellvalue;
										}
										else
										{
											var cellvalue="";
											if (TxtlineinfoArray[j]=="undefined") cellvalue="";
											else cellvalue=TxtlineinfoArray[j-1];
				
											if (j==1)  tempStr=cellvalue;
											else tempStr=tempStr+("&%"+cellvalue);		
											
											data.push(cellvalue);
											
										}
									}
									Alldata.push(data);
									
									var Flag =tkMakeServerCall("web.DHCBL.BDP.BDPDataImport","ImportIntoGlobal",EILType,table,sheetid,row+2,tempStr,"Y");	
								
							}
							else ///GOF
							{
								var tempStr="";
								var data =[];
								var gofiinfo =tkMakeServerCall("web.DHCBL.BDP.BDPDataImport","GetTableGofiinfo",EILType,sheetid,table,row);
								var gofiinfoArray=gofiinfo.split("&%")
								///OralDrug&%口服药品&%PHC_Instruc
								for (var j=0;j<=colcount;j++){
									if (j==0) data.push(row);
									else  data.push(gofiinfoArray[j-1]);
								}
								Alldata.push(data);
							}
							
						}
						progressText = "正在读取第"+row+"条记录,总共"+(taskcount)+"条记录!";  
					    proBar.updateProgress(row/taskcount,progressText);
					  }
						 
				  },  
				  interval:20  
				});
				winproBar.show();	
			
				
		}
		else
		{
			Ext.Msg.show({
					title : '提示',
					msg : '没有数据' ,
					minWidth : 200,
					icon : Ext.Msg.INFO,
					buttons : Ext.Msg.OK
				}) 
			return;
		}
	}
	//装载数据
	function ExcelReadData(){
		if (!isIE())
		{
			alert("请在IE下执行！"); return;
		}
		var filepath=getPath(document.getElementById("ExcelImportPath"));  //2017-07-11 ie8下部分浏览器版本获取的路径为C:\fakepath\
		
		//var filepath=Ext.getCmp("ExcelImportPath").getValue();
		//var filepath="C:\\Users\\AMANDA\\Desktop\\1管理型基础数据维护数据模板.xlsx";
		if( filepath.indexOf("fakepath")>=0 ) {
			alert("请在IE下执行！"); return;
			
		}
		if( filepath.indexOf(".xls")<=0 ) {alert("请选择excel表格文件！"); return;}
		
		var EILFileType="EXCEL";  
		
		PreReadData(filepath,table,EILFileType)
	}
	
	
	///导出Excel模板文件2016-3-22
	function ExcelExportTemplet()
	{
		if (!isIE())
		{
			alert("请在IE下执行！"); return;
		}
		try{
	    	xlApp = new ActiveXObject("Excel.Application");
			xlBook = xlApp.Workbooks.Add();///默认三个sheet
		}catch(e){
			///alert(e.message);
			var emsg="不能生成表格文件。"+ErrorMsgInfo;
			Ext.Msg.show({
				title : '提示',
				msg : emsg ,
				minWidth : 200,
				icon : Ext.Msg.INFO,
				buttons : Ext.Msg.OK
			})
		    return;
		}
		
		
		xlBook.worksheets(1).select(); 
		xlsheet = xlBook.ActiveSheet;
		////  工作簿名&%字段name1^字段描述1^是否必填0&#字段name2^字段描述2^是否必填1 ///按照顺序字段取字段信息，有维护顺序的排在前面，空的排在后面
		var excelinfostr=tkMakeServerCall("web.DHCBL.BDP.BDPDataImport","GetTempletFieldDesc",table);
		if (excelinfostr=="") {alert("请先设置导入导出配置表"); return;}
		var excelinfo=excelinfostr.split("&%");
		xlsheet.name=excelinfo[0];
		sheetname=excelinfo[0];
		var fieldinfostr=excelinfo[1];
		
		var fieldInfoArray=fieldinfostr.split("&#");
		for (var i=0;i<(fieldInfoArray.length);i++){
			
			var fieldInfo=fieldInfoArray[i]
			var fieldArr=fieldInfo.split("^");
			
			xlsheet.cells(row_from-2,i+1)=fieldArr[0];
			xlsheet.cells(row_from-1,i+1)=fieldArr[1];
			///xlsheet.Columns("A:A").NumberFormatLocal = "@"
			xlsheet.Columns(i+1).NumberFormatLocal = "@";   ///设置某列单元格格式为文本格式  20170830
			//xlsheet.Cells(row_from-2,i+1).NumberFormatLocal = "@";   ///设置某行某列单元格格式为文本格式
			///设置单元格样式 2017-2-7 chenying
			xlsheet.cells(row_from-2,i+1).Font.Bold = true; //设置为粗体
			xlsheet.cells(row_from-1,i+1).Font.Bold = true; //设置为粗体
			xlsheet.cells(row_from-2,i+1).WrapText=true;  //设置为自动换行*
			xlsheet.cells(row_from-1,i+1).WrapText=true;  //设置为自动换行*
			//设置单元格底色*(1-黑色，2-白色，3-红色，4-绿色，5-蓝色，6-黄色，7-粉红色，8-天蓝色，9-酱土色.)
			//xlsheet.cells(1,i+1).Interior.ColorIndex = 5;  ///蓝色底色
			//xlsheet.cells(2,i+1).Interior.ColorIndex = 5;
			if (fieldArr[2]==1)
			{
				//设置设置字体颜色
				xlsheet.cells(row_from-2,i+1).Font.ColorIndex = 3;  ///红色
				xlsheet.cells(row_from-1,i+1).Font.ColorIndex = 3;
			}
			else
			{
				xlsheet.cells(row_from-2,i+1).Font.ColorIndex = 1; 
				xlsheet.cells(row_from-1,i+1).Font.ColorIndex = 1;
				
			}
		}
		
		var ExcelInstruction=tkMakeServerCall("web.DHCBL.BDP.BDPDataImport","GetExcelInstruction",table);
		try
		{
			xlBook.worksheets(2).select(); 
			xlsheet2 = xlBook.ActiveSheet;
			xlsheet2.cells(1,1)=ExcelInstruction;
			//xlsheet2.cells(2,1)="从第三行开始准备数据";
			xlsheet2.name="导入说明";
			xlBook.worksheets(1).select(); 
		}
		catch(e)
		{
			xlBook.worksheets(1).select(); 
		}
		
		
		xlApp.Visible=true;
		//var fname="D:\\"+sheetname+".xls";
		//var fname = xlApp.Application.GetSaveAsFilename(sheetname+".xls", "Excel Spreadsheets (*.xls), *.xls");  // "Excel 工作簿, *.xlsx"
    	//xlBook.SaveAs(fname);
		Ext.Msg.show({
			title : '提示',
			msg : '导出完成！',
			icon : Ext.Msg.INFO,
			buttons : Ext.Msg.OK,
			fn : function(btn){
				xlBook.Close(savechanges=true);
		        CollectGarbage();
				xlApp=null;
				xlsheet=null;
				xlsheet2=null;
				}
			});
		
		
	
	}
	
	function TxtImportData(){
		if (!isIE())
		{
			alert("请在IE下执行！"); return;
		}
		var filepath=getPath(document.getElementById("TxtImportPath"));  //2017-07-11 ie8下部分浏览器版本获取的路径为C:\fakepath\
		var EILFileType="TXT";

		
		//var filepath = document.getElementById("TxtImportPath").value;
		if( filepath.indexOf("fakepath")>=0 ) { alert("请在IE下执行！"); return;}
			
		if( filepath.indexOf(".txt")<=0 ) {alert("请选择txt文件！"); return;}
		
		PreReadData(filepath,table,EILFileType)
		
	}
	    ///***************************输入密码*******************************/
	/**密码输入表单*/
	var formPassword = new Ext.form.FormPanel({
		id : 'form-submit',
		labelAlign : 'right',
		labelWidth : 130,
		frame :true,
		defaultType : 'textfield',
		items:[{
			fieldLabel : '<font color=red>*</font>请输入管理员密码',
			name : 'password',
			id:'password',
			inputType : 'password',
			allowBlank : false,
			blankText: '不能为空'
		}]
	})
	
	/**密码输入窗口**/
	var winPassword=new Ext.Window({
		title : '',
		width : 350,
		height:150,
		layout : 'fit',
		plain : true,//true则主体背景透明
		modal : true,
		frame : true,
		autoScroll : true,
		collapsible : true,
		constrain : true,
		hideCollapseTool : true,
		titleCollapse : true,
		buttonAlign : 'center',
		closable:false,
		closeAction : 'hide',
		items : formPassword,
		buttons:[{
			text:"确定",
			iconCls : 'icon-ok',
			id:'submit_btn',
			handler:function(){
				var password = Ext.getCmp("form-submit").getForm().findField("password").getValue();
			    if (password=="") {
			    	Ext.Msg.show({ title : '提示', msg : '密码不能为空!', minWidth : 200, icon : Ext.Msg.ERROR, buttons : Ext.Msg.OK });
			        return;
			    }
			    var ImportType=Ext.getCmp(EILType+"#"+sheetid+"#"+'importtype').getValue()
			    ///新装、追加、修改时密码不同
			    var validateflag=tkMakeServerCall("web.DHCBL.BDP.BDPDataImport","ValidatePassword",password,ImportType);
				
				if (validateflag==1){	
					Ext.getCmp("form-submit").getForm().findField("password").reset();
					winPassword.hide();
					ImportData()
					
			    }else{
					Ext.Msg.show({ title : '提示', msg : '密码错误请重试!', minWidth : 200, icon : Ext.Msg.ERROR, buttons : Ext.Msg.OK });
				}

			}
			
		},{
			text : '关闭',
			iconCls : 'icon-close',
			handler : function() {
				Ext.getCmp("form-submit").getForm().findField("password").reset();
				winPassword.hide();
			}
		}],
		listeners : {
			"show" : function() {
				Ext.getCmp("password").focus(true,500);
			}
		}
	})
	
	
	
	var formSearch = new Ext.form.FormPanel({
		title:'BDP数据导入',
		frame:true,
		border:false,
		region: 'center',
		autoScroll:true,
		width:600,
		height:200,
		split: true,
		buttonAlign:'center',
		items:[{
			xtype: 'fieldset',
			title:'从Excel文件导入',
			labelWidth:120,		
			labelAlign:'right',
			autoHeight: true,
			width:700,
			defaultType:'textfield',
			items:[
				 {
						xtype:'fieldset',
						border:false,
						items:[
							{
								layout:'column',
								baseCls : 'x-plain',//form透明,不显示框框
								items:[
									{
										columnWidth:.5,
										baseCls : 'x-plain',//form透明,不显示框框
										//frame:true,
										layout:'form',
										items:[
											{iconCls : 'icon-export',text:'下载导入数据模板',xtype : 'button',
												listeners : {
													"click" : function() { 
															if (!isIE())
															{
																alert("请在IE下执行！"); return;
															}
														
															ExcelExportTemplet();  
														
													}
												}
											}
											]
									}
							]}
						]},	
			{width: 400,fieldLabel:'装载Excel文件',xtype : 'textfield',inputType:'file',id : 'ExcelImportPath'},
			{iconCls : 'icon-import',text:'装载',xtype : 'button',
				listeners : {
					"click" : function() {  
						if (!isIE())
						{
							alert("请在IE下执行！"); return;
						}
						ExcelReadData();
						
						
					}
				}
			}
			
			]
		
		},{
			xtype: 'fieldset',
			title:'从txt文件导入',
			labelWidth:120,		
			labelAlign:'right',
			autoHeight: true,
			width:700,
			defaultType:'textfield',
			items:[
						 
			{width: 400,fieldLabel:'装载txt文件',xtype : 'textfield',inputType:'file',id : 'TxtImportPath'},
			{iconCls : 'icon-import',text:'装载',xtype : 'button',
				listeners : {
					"click" : function() {
						if (!isIE())
						{
							alert("请在IE下执行！"); return;
						}
		
						TxtImportData();
						
					}
				}
			}
			]
		},
		{
                	title:"备注说明",
                	width:700,
					html : "<ui><li>1.需在IE下执行操作，"+ErrorMsgInfo+"</li></ui>"
							+"<ui><li>2.如果提示导入时缺少配置，请先确认字段名称是否正确，如果字段名称正确请在'导入配置表管理'页面进行配置。</li></ui> "
						 	+"<ui><li>3.从Excel文件导入时需选择.xls/.xlsx格式的文件。如需要导入日期、时间，需将这一列格式设置为文本，请注意。</li></ui> "
						 	+"<ui><li>4.从txt文件导入时需选择.txt格式的文件。并且用记事本将文件另存为编码为ANSI格式。</li></ui> " 
						 	///+"<ui><li>5.从Gof文件导入时需选择.gof格式的文件,并需要远程到服务器执行操作，且gof文件存放路径不能有中文。点击导入按钮时提示'A JavaScript exception was caught during execution of HyperEvent: SyntaxError:缺少; '时，请选择'取消'。此弹出框为系统方法自行弹出，没有影响导入导出功能。</li></ui> " 
						 							
                
		}]
	});

	
	// 创建viewport
	var viewport = new Ext.Viewport({
				layout : 'border',
				items : [formSearch]
	});
	
	
	

});
