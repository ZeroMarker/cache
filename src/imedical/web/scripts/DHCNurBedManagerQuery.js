var Hosid=session['LOGON.HOSPID'];    //获取默认登陆院区

var CTHosStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
			url : ExtToolSetting.RunQueryPageURL
		}));
var CTHosStore = new Ext.data.Store({
		proxy:CTHosStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'Hoscode'
		},
		[
			{name: 'HosDesc', mapping : 'HosDesc'}
			,{name: 'HosCode', mapping: 'HosCode'}
		])
     });
var CTHos = new Ext.form.ComboBox({
		id : 'CTHos'
		,width : 80
		,store : CTHosStore
		,minChars : 1
		,displayField : 'HosDesc'
		,fieldLabel : '院区'
		,editable : true
		,triggerAction : 'all'
		,anchor : '100%'
		,valueField : 'HosCode'
		,listeners:  
               {      
                    select : function(Combox, record,index)  
                    { 					
					 //cboWardStoreProxy.load("Nur.DHCBedManager","QryCTLoc",cboWard.getRawValue(),"W","",CTHos.getValue());
		             cboWardStore.load();
					 CTLoc.load();
                    }    
               }  
});	
var CTLocStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
			url : ExtToolSetting.RunQueryPageURL
		}));
var CTLocStore = new Ext.data.Store({
		proxy: CTLocStoreProxy,
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
var CTLoc = new Ext.form.ComboBox({
		id : 'CTLoc'
		,width : 100
		,store : CTLocStore
		,minChars : 1
		,displayField : 'CTLocDesc'
		,fieldLabel : '科室'
		,editable : true
		,triggerAction : 'all'
		,anchor : '100%'
		,valueField : 'CTLocID'
});
var cboWardStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
			url : ExtToolSetting.RunQueryPageURL
		}));
var cboWardStore = new Ext.data.Store({
		proxy: cboWardStoreProxy,
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
var cboWard = new Ext.form.ComboBox({
		id : 'cboWard'
		,width : 100
		,minChars : 1 
		,selectOnFocus : true //true 将会在获得焦点时理解选中表单项中所有存在的文本。 仅当editable = true 时应用(默认为false)。 
		,forceSelection : true 
		,store : cboWardStore
		,displayField : 'CTLocDesc'
		,fieldLabel : '病区'
		,editable : true 
		,triggerAction : 'all'  
		,anchor : '100%'
		,valueField : 'CTLocID'
	});
	
var FindAll = new Ext.form.Radio({
		 boxLabel: '全部',
		                xtype: 'radiogroup',
                        name: 'rad',
                        value: '1',
						id:'FindAll',
                        width: '100',
						anchor : '100%'
	});
var Findempty = new Ext.form.Radio({
		boxLabel: '空床',
		                xtype: 'radiogroup',
                        name: 'rad',
						id:'Findempty',
						checked: true,
                        value: '2',
                        width: '100',
						anchor : '100%'
	});
var Findnotempty = new Ext.form.Radio({
		boxLabel: '非空',
		                xtype: 'radiogroup',
                        name: 'rad',
						id:'Findnotempty',
                        value: '3',
                        width: '100',
						anchor : '100%'
	});
	
var SearchToday = new Ext.form.DateField(
	                   {
                    xtype: 'datefield',
                    fieldLabel: '当前',
					id:'startdate',
					width:50,
					format:'Y-m-d',
					value:new Date(),
                    name: 'date',
					anchor : '100%'
                }
	);	
var SearchTom = new Ext.form.DateField(
	                   {
                    xtype: 'datefield',
                    fieldLabel: '结束',
					id:'enddate',
					width:50,
					format:'Y-m-d',
					value:new Date(),
                    name: 'date',
					anchor : '100%'
                }
	);	
	//明天
var Tom = new Ext.form.Checkbox(
	                    {  
                        boxLabel  : '明天',  
                        name      : 'Tom',  
                        inputValue: '1',  
                        id        : 'Tom',     // checked:'true'
						width:50,
						anchor : '100%'
                        }  
	);	
//后天
var Tomstom = new Ext.form.Checkbox(
	                    {  
                        boxLabel  : '后天',  
                        name      : 'Tomstom',  
                        inputValue: '1',  
                        id        : 'Tomstom',
						width:50,
                        anchor : '100%'						
                        }  
	);	
//大后天
var Tomstomafter = new Ext.form.Checkbox(
	                    {  
                        boxLabel  : '大后天',  
                        name      : 'Tomstomafter',  
                        inputValue: '2', 
                        id        : 'Tomstomafter',
                        anchor : '100%'						
                        }  
	);
var Searchbyward = new Ext.form.Checkbox(
	                    {  
                        boxLabel  : '按病区',  
                        name      : 'searchtype',  
                        inputValue: '1',  
						checked   : true,
                        id        : 'Searchbyward',
						anchor : '100%'
                        }  
	);
var Searchbyloc = new Ext.form.Checkbox(
	                    {  
                        boxLabel  : '按科室',  
                        name      : 'searchtype',  
                        inputValue: '2',  
                        id        : 'Searchbyloc',
                        anchor : '100%'						
                        }  
	);	

var btnQuery = new Ext.Button({
		id : 'btnQuery'
		,fieldLabel : ''
		//,anchor : '55%'
		//,hideLabel:true
		//,xtype: 'tbfill' 
		//,xtype : 'tbspacer'
		,width : 60
		,iconCls : 'icon-find'
		,text : '查询'
		,margins : {top:0, right:0, bottom:0, left:100}

	});
	/*
var BedAuthStatus = new Ext.form.TextField({
		id : 'BedAuthStatus' 
		,width : 20
		,anchor : '100%'
		,fieldLabel : '状态' 
	});	
	*/
var btnUpdateWardBed = new Ext.Button({
		id : 'btnUpdateWardBed'
		,fieldLabel : ''
		//,anchor : '55%'
		//,hideLabel:true
		//,xtype: 'tbfill' 
		//,xtype : 'tbspacer'
		,width : 100
		,text : '开放病区床位权限'
		,margins : {top:0, right:0, bottom:0, left:100}

	});
var btnCloseWardBed = new Ext.Button({
		id : 'btnCloseWardBed'
		,fieldLabel : ''
		//,anchor : '55%'
		//,hideLabel:true
		//,xtype: 'tbfill' 
		//,xtype : 'tbspacer'
		,width : 100
		,text : '收回病区权限'
		,margins : {top:0, right:0, bottom:0, left:100}

	});
var btnUpdateAllBed = new Ext.Button({
		id : 'btnUpdateAllBed'
		,fieldLabel : ''
		//,anchor : '55%'
		//,hideLabel:true
		//,xtype: 'tbfill' 
		//,xtype : 'tbspacer'
		,width : 100
		,text : '开放所有权限'
		,margins : {top:0, right:0, bottom:0, left:100}

	});
var btnCloseAllBed = new Ext.Button({
		id : 'btnCloseAllBed'
		,fieldLabel : ''
		//,anchor : '55%'
		//,hideLabel:true
		//,xtype: 'tbfill' 
		//,xtype : 'tbspacer'
		,width : 100
		,text : '收回所有权限'
		,margins : {top:0, right:0, bottom:0, left:100}

	});

	
var pConditionChild1 = new Ext.Panel({
		id : 'pConditionChild1'
		,buttonAlign : 'center'  //添加到当前panel的所有 buttons 的对齐方式。
		,columnWidth : .20 //columnWidth 表示使用百分比的形式指定列宽度，而width 则是使用绝对象素的方式指定列宽度
		,layout : 'form' //布局方式
		,items : [
		cboWard,
		CTLoc
		]  //一个单独项，或子组件组成的数组，加入到此容器中。
	});
	
	
var pConditionChild2 = new Ext.Panel({
		id : 'pConditionChild2'
		,buttonAlign : 'center'  //添加到当前panel的所有 buttons 的对齐方式。
		,columnWidth : .10//columnWidth 表示使用百分比的形式指定列宽度，而width 则是使用绝对象素的方式指定列宽度
		,layout : 'form' //布局方式
		,items : [
		Searchbyward,
		Searchbyloc
		
		]  //一个单独项，或子组件组成的数组，加入到此容器中。
	});
	
var pConditionChild3 = new Ext.Panel({
		id : 'pConditionChild3'
		,buttonAlign : 'center'  //添加到当前panel的所有 buttons 的对齐方式。
		,columnWidth : .15 //columnWidth 表示使用百分比的形式指定列宽度，而width 则是使用绝对象素的方式指定列宽度
		,layout : 'form' //布局方式
		,items : [
		SearchToday,
		SearchTom
		
		]  //一个单独项，或子组件组成的数组，加入到此容器中。
	});
var pConditionChild4 = new Ext.Panel({
		id : 'pConditionChild4'
		,buttonAlign : 'center'  //添加到当前panel的所有 buttons 的对齐方式。
		,columnWidth : .04 //columnWidth 表示使用百分比的形式指定列宽度，而width 则是使用绝对象素的方式指定列宽度
		,layout : 'column' //布局方式  column
		,items : [
		FindAll,
		Findempty,
		Findnotempty
		
		]  //一个单独项，或子组件组成的数组，加入到此容器中。
	});
	
	/*pConditionChild5 = new Ext.Panel({
		id : 'pConditionChild5'
		,buttonAlign : 'center'  //添加到当前panel的所有 buttons 的对齐方式。
		,columnWidth : .12 //columnWidth 表示使用百分比的形式指定列宽度，而width 则是使用绝对象素的方式指定列宽度
		,layout : 'form' //布局方式
		,items : [
		SearchToday
		
		]  //一个单独项，或子组件组成的数组，加入到此容器中。
	});
	pConditionChild9 = new Ext.Panel({
		id : 'pConditionChild9'
		,buttonAlign : 'center'  //添加到当前panel的所有 buttons 的对齐方式。
		,columnWidth : .10 //columnWidth 表示使用百分比的形式指定列宽度，而width 则是使用绝对象素的方式指定列宽度
		,layout : 'fit' //布局方式anchor
		,items : [
		SearchTom
		
		]  //一个单独项，或子组件组成的数组，加入到此容器中。
	});
	*/
var pConditionChild5 = new Ext.Panel({
		id : 'pConditionChild5'
		,buttonAlign : 'center'  //添加到当前panel的所有 buttons 的对齐方式。
		,columnWidth : .10 //columnWidth 表示使用百分比的形式指定列宽度，而width 则是使用绝对象素的方式指定列宽度
		,layout : 'form' //布局方式fit
		,items : [
		btnQuery
		]  //一个单独项，或子组件组成的数组，加入到此容器中。
	});
	
var pConditionChild6 = new Ext.Panel({
		id : 'pConditionChild6'
		,buttonAlign : 'center'  //添加到当前panel的所有 buttons 的对齐方式。
		,columnWidth : .1 //columnWidth 表示使用百分比的形式指定列宽度，而width 则是使用绝对象素的方式指定列宽度
		,layout : 'form' //布局方式  anchor
		,items : [
		Tom,
		Tomstom,
		Tomstomafter
		
		]  //一个单独项，或子组件组成的数组，加入到此容器中。
	});
	
var pConditionChild7 = new Ext.Panel({
		id : 'pConditionChild7'
		,buttonAlign : 'center'  //添加到当前panel的所有 buttons 的对齐方式。
		,columnWidth : .10 //columnWidth 表示使用百分比的形式指定列宽度，而width 则是使用绝对象素的方式指定列宽度
		,layout : 'form' //布局方式
		,items : [
		//btnUpdateWardBed,
		btnUpdateAllBed
		
		]  //一个单独项，或子组件组成的数组，加入到此容器中。
	});
var pConditionChild8 = new Ext.Panel({
		id : 'pConditionChild8'
		,buttonAlign : 'left'  //添加到当前panel的所有 buttons 的对齐方式。
		,columnWidth : .10 //columnWidth 表示使用百分比的形式指定列宽度，而width 则是使用绝对象素的方式指定列宽度
		,layout : 'form' //布局方式
		,items : [
		//btnCloseWardBed ,
		btnCloseAllBed
		
		]  //一个单独项，或子组件组成的数组，加入到此容器中。
	});
	
var pConditionChild9 = new Ext.Panel({
		id : 'pConditionChild9'
		,buttonAlign : 'center'  //添加到当前panel的所有 buttons 的对齐方式。
		,columnWidth : .20 //columnWidth 表示使用百分比的形式指定列宽度，而width 则是使用绝对象素的方式指定列宽度
		,layout : 'form' //布局方式
		,items : [
		CTHos
		]  //一个单独项，或子组件组成的数组，加入到此容器中。
	});
	
var ConditionPanel = new Ext.form.FormPanel({
		id : 'ConditionPanel',
		buttonAlign : 'center', //添加到当前panel的所有 buttons 的对齐方式。 
		labelAlign : 'right', //该容器中可用的文本对齐值，合法值有 "left", "top" 和 "right" (默认为 "left").
		labelWidth : 40,
		bodyBorder : 'padding:0 0 0 0',
		layout : 'column',
		region : 'north',
		frame : true,
		height : 90,
		//title : winTitle,
		items : [
			pConditionChild1
			,pConditionChild2
			,pConditionChild3
			,pConditionChild6
			,pConditionChild4
			,pConditionChild5
			,pConditionChild7
		]
		//buttons : [
			//btnQuery
			//,btnExport
		//]
	});
	
	
var gridResultStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
			url : ExtToolSetting.RunQueryPageURL
		}));
var gridResultStore = new Ext.data.Store({
		id: 'gridResultStoretore',
		proxy: gridResultStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'IPAppID'
		}, 
		[
		    {name: 'BedId', mapping : 'BedId'}
			,{name: 'BedCode', mapping : 'BedCode'}
			,{name: 'BedStatus', mapping: 'BedStatus'}
			,{name: 'BedBill', mapping: 'BedBill'}
			,{name: 'BedAvailTime', mapping: 'BedAvailTime'}
			
			,{name: 'PatName', mapping: 'PatName'}
			,{name: 'PatSex', mapping: 'PatSex'}
			,{name: 'PatAge', mapping: 'PatAge'}
			,{name: 'BedOwn', mapping: 'BedOwn'}
			,{name: 'RegNo', mapping: 'RegNo'}
			,{name: 'EpisodeID', mapping: 'EpisodeID'}
			,{name: 'IPDate', mapping: 'IPDate'}
			,{name: 'Patward', mapping: 'Patward'}
			,{name: 'WardID', mapping: 'WardID'}
		])
	});
var gridResultCheckCol = new Ext.grid.CheckColumn({header:'', dataIndex: 'checked', width: 50 });
var gridResult = new Ext.grid.GridPanel({
		id : 'gridResult'
		,store : gridResultStore
		,region : 'center'
		,buttonAlign : 'center'
		,loadMask : { msg : '正在读取数据,请稍后...'} //一个 Ext.LoadMask 配置，或者为true以便在加载时遮罩grid。 默认为 false .
		//,plugins: expCtrlDetail //一个对象或者一个对象数组，为组件提供特殊的功能。 对一个合法的插件唯一的要求是它含有一个init()方法， 能接收一个Ext.Component型的参数。当组件被创建时，如果有可用的插件，组件将会调用每个插件的init方法，并将自身的引用作为方法参数传递给它。然后，每个插件就可以调用方法或者响应组件上的事件，就像需要的那样提供自己的功能。 
		,columns: [
			/*new Ext.grid.RowNumberer({header:"床号"	,width:60})*/
			{header: '床位id', width: 50, dataIndex: 'BedId', sortable: true}
			,{header: '床位号', width: 100, dataIndex: 'BedCode', sortable: true}
			,{header: '床位状态', width: 100, dataIndex: 'BedStatus', sortable: true}
			,{header: '床位费用', width: 100, dataIndex: 'BedBill', sortable: true}
			,{header: '预空时间', width: 100, dataIndex: 'BedAvailTime', sortable: true}
			,{header: '病人姓名', width: 100, dataIndex: 'PatName', sortable: true}
			,{header: '性别', width: 100, dataIndex: 'PatSex', sortable: true}
			,{header: '年龄', width: 100, dataIndex: 'PatAge', sortable: true}
			,{header: '床位归属', width: 100, dataIndex: 'BedOwn', sortable: true}
			,{header: '登记号', width: 100, dataIndex: 'RegNo', sortable: true}
			,{header: '就诊号', width: 100, dataIndex: 'EpisodeID', sortable: true}
			,{header: '入院日期', width: 100, dataIndex: 'IPDate', sortable: true}		
			,{header: '病区', width: 100, dataIndex: 'Patward', sortable: true}
			,{header: '病区id', width: 50, dataIndex: 'WardID', sortable: true}
		]
		,bbar: new Ext.PagingToolbar({
			pageSize : 1000,
			store : gridResultStore,
			displayMsg: '显示记录： {0} - {1} 合计： {2}',
			displayInfo: true,
			emptyMsg: ''
		})
	});

var pnScreen = new Ext.Panel({
		id : 'pnScreen'
		,buttonAlign : 'center'
		,frame : true
		,layout : 'border'
		,items:[
		
			ConditionPanel,
			gridResult
		]
	});

CTHosStoreProxy.on('beforeload', function(objProxy, param){
			param.ClassName = 'Nur.DHCBedManager';
			param.QueryName = 'GetHospital';
			param.Arg1 = CTHos.getRawValue();;
			param.ArgCnt = 1;
	 });
	 
CTLocStoreProxy.on('beforeload', function(objProxy, param){
			param.ClassName = 'Nur.DHCBedManager';
			param.QueryName = 'QryCTLoc';
			param.Arg1 = CTLoc.getRawValue();
			param.Arg2 = 'E';
			param.Arg3 = "";  //cboWard.getValue();
			param.Arg4 = Hosid;  //CTHos.getValue();;
			param.ArgCnt = 4;
	 });
cboWardStoreProxy.on('beforeload', function(objProxy, param){
			param.ClassName = 'Nur.DHCBedManager';
			param.QueryName = 'QryCTLoc';
			param.Arg1 = cboWard.getRawValue();
			param.Arg2 = 'W';
			param.Arg3 = "";
			param.Arg4 = Hosid;   //CTHos.getValue();
			param.ArgCnt = 4;
	});
 gridResultStoreProxy.on('beforeload', function(objProxy, param){
            var Arg2=cboWard.getValue();
			var Arg3 = FindAll.getValue();
			var Arg4=Findempty.getValue();
			var Arg5=Findnotempty.getValue();
			var Arg6=SearchToday.getValue();
			var Arg7=SearchTom.getValue();
			param.ClassName = 'Nur.DHCBedManager';
			param.QueryName = 'Findbed';
			param.Arg1 = "";
			param.Arg2 = Arg2;
			param.Arg3 = Arg3;
			param.Arg4 = Arg4;
			param.Arg5 = Arg5;
			param.Arg6 = Arg6;
			param.Arg7 = Arg7;
    });	
	/*
var SearchToday = Ext.getCmp("SearchToday")
	//alert(SearchToday.checked)
	var SearchTom = Ext.getCmp("SearchTom")
	SearchToday.on("check", function() {

				if (SearchToday.getValue()) {
					SearchTom.setValue("false")
				}
			});
	SearchTom.on("check", function() {

				if (SearchTom.getValue()) {
					SearchToday.setValue("false")
				}
			});
	*/		
	var Searchbyward = Ext.getCmp("Searchbyward")
	//alert(SearchToday.checked)
	var Searchbyloc = Ext.getCmp("Searchbyloc")
	Searchbyward.on("check", function() {

				if (Searchbyward.getValue()) {
					Searchbyloc.setValue("false")
				}
			});
	Searchbyloc.on("check", function() {

				if (Searchbyloc.getValue()) {
					Searchbyward.setValue("false")
				}
			});
			
			
//********************
var Tomstomafter = Ext.getCmp("Tomstomafter")
	//alert(SearchToday.checked)
	var Tomstom = Ext.getCmp("Tomstom")
	var Tom=Ext.getCmp("Tom")
	//大后天
	Tomstomafter.on("check", function() {

				if (Tomstomafter.getValue()) {
					Tomstom.setValue("false")
					Tom.setValue("false")
					Ext.getCmp("enddate").setValue(new Date().add(Date.DAY, +3));
					Search_onclick();
				}
			});
//后天
	Tomstom.on("check", function() {

				if (Tomstom.getValue()) {
					Tomstomafter.setValue("false")
					Tom.setValue("false")
					Ext.getCmp("enddate").setValue(new Date().add(Date.DAY, +2));
					Search_onclick();
				}
			});
//明天
Tom.on("check", function() {

				if (Tom.getValue()) {
					Tomstomafter.setValue("false")
					Tomstom.setValue("false")
					Ext.getCmp("enddate").setValue(new Date().add(Date.DAY, +1));
					Search_onclick();
				}
			});
//*******************************
function Search_onclick()
{
            //alert(1)
		    var SearchByLoc=Searchbyloc.getValue();     //按科室查询
			var Searchbyward = Ext.getCmp("Searchbyward");
		    var Searchbyward=Searchbyward.getValue();     //按病区查询
			var CTLoc = Ext.getCmp("CTLoc");
		    var CTLoc=CTLoc.getValue();
			var WardID = cboWard.getValue(); 
			var FindAll = Ext.getCmp("FindAll");
			var FindAll =FindAll.getValue();   
			var Findempty = Ext.getCmp("Findempty");
			var Findempty =Findempty.getValue(); 
        	var Findnotempty = Ext.getCmp("Findnotempty");		
			var Findnotempty =Findnotempty.getValue(); 
			//alert(2)
		    var SearchToday = Ext.getCmp("enddate");
			var SearchToday =SearchToday.value;   
			var SearchTom = Ext.getCmp("enddate");	
			var SearchTom =SearchTom.value; 		
			//alert(SearchByLoc+"#"+Searchbyward+"#"+CTLoc+"#"+WardID+"#"+FindAll+"#"+Findempty+"#"+Findnotempty+"#"+SearchToday+"#"+SearchTom);
			
		Ext.Ajax.request({
			url:'DHCNurBedManagerequest.csp',
			params:{action:'GetBedList',SearchByLoc:SearchByLoc,Searchbyward:Searchbyward,CTLoc:CTLoc,WardID:WardID, FindAll:FindAll, Findempty:Findempty, Findnotempty:Findnotempty, SearchToday:SearchToday, SearchTom:SearchTom} ,
			success: function(result, request) {
				//var gridResultStore=obj.gridResultStore;
				gridResultStore.removeAll();
				var jsonData = Ext.util.JSON.decode( result.responseText );
				if (jsonData.GetBedList!='') {
					var GetBedListArr=jsonData.GetBedList.split("!");
					for (var i=0;i<GetBedListArr.length;i++) {
						//{name: 'checked', mapping : 'checked'}
						var BedId = GetBedListArr[i].split("^")[0];
						var BedCode = GetBedListArr[i].split("^")[1];
						var BedStatus = GetBedListArr[i].split("^")[2];
						var BedBill = GetBedListArr[i].split("^")[3];
						var BedAvailTime = GetBedListArr[i].split("^")[14];
						var PatName = GetBedListArr[i].split("^")[4];
						var PatSex = GetBedListArr[i].split("^")[5];
						var PatAge = GetBedListArr[i].split("^")[6];
						var BedOwn = GetBedListArr[i].split("^")[9];
						var RegNo = GetBedListArr[i].split("^")[12];
						var EpisodeID = GetBedListArr[i].split("^")[10];
						var IPDate = GetBedListArr[i].split("^")[7];
						var Patward = GetBedListArr[i].split("^")[8];
						var WardID = GetBedListArr[i].split("^")[13];
						//alert(GetBedListArr[i])
						var record = new Object();
			       		record.BedId = BedId ;
			       		record.BedCode = BedCode ;
			       		record.BedStatus = BedStatus ;
			       		record.BedBill = BedBill ;
			       		record.PatName = PatName ;
			       		record.PatSex = PatSex ;
			       		record.PatAge = PatAge ;
			       		record.BedOwn = BedOwn ;
			       		record.RegNo = RegNo ;
			       		record.EpisodeID = EpisodeID ;
			       		record.IPDate = IPDate ;
						record.Patward=Patward;
						record.WardID=WardID;
						record.BedAvailTime=BedAvailTime
			       		var records = new Ext.data.Record(record);
			       		
						gridResultStore.add(records);
					}
				}
			},
			scope: this
		}) ;
}
function btnUpdateAllBed_onclick()
{
var btnUpdateAllBed=Ext.getCmp("btnUpdateAllBed");
if(btnUpdateAllBed.text=="开放所有权限")
{
var ret=tkMakeServerCall("Nur.DHCBedManager","UpdateAllBed");
	if(ret=="0")
	{
	alert("开放权限成功")
	btnUpdateAllBed.setText("收回所有权限");
	}

}
else
{
var ret=tkMakeServerCall("Nur.DHCBedManager","CloseAllBed");
	if(ret=="0")
	{
	alert("收回权限成功")
	btnUpdateAllBed.setText("开放所有权限");
	}
}
}
/*
Ext.onReady(function(){
new Ext.Viewport({
		id : 'viewScreen'
		,frame : true
		,layout : 'fit'
		,items:[
			pnScreen
			
		]
	}),
Ext.get('btnQuery').on("click",Search_onclick);
Ext.get('btnUpdateAllBed').on("click",btnUpdateAllBed_onclick);
var ret=tkMakeServerCall("Nur.DHCBedManager","GetBedStatus");
if (ret=="1") 
{
var btnUpdateAllBed=Ext.getCmp("btnUpdateAllBed");
btnUpdateAllBed.setText("收回所有权限");
}
else
{
var btnUpdateAllBed=Ext.getCmp("btnUpdateAllBed");
btnUpdateAllBed.setText("开放所有权限");
}
//Search_onclick();
//Ext.get('btnQuery').on("click",Search_onclick);
//Search_onclick();
}
)*/
var init=function(){

new Ext.Viewport({
		id : 'viewScreen'
		,frame : true
		,layout : 'fit'
		,items:[
			pnScreen
			
		]
	}),
Ext.get('btnQuery').on("click",Search_onclick);
Ext.get('btnUpdateAllBed').on("click",btnUpdateAllBed_onclick);
var ret=tkMakeServerCall("Nur.DHCBedManager","GetBedStatus");
if (ret=="1") 
{
var btnUpdateAllBed=Ext.getCmp("btnUpdateAllBed");
btnUpdateAllBed.setText("收回所有权限");
}
else
{
var btnUpdateAllBed=Ext.getCmp("btnUpdateAllBed");
btnUpdateAllBed.setText("开放所有权限");
}
Getmessage();  //alert(3)


}
Ext.onReady(init);
