//定义控件的全局变量
var IPURL = "http://127.0.0.1/dthealth/web/csp/";
////////我的事务/////////////
var PrjTransaction=0;
var PaperTransaction=0;
var MonoTransaction=0;
var PrjAchTransaction=0;
var PatentTransaction=0;

/////////我的科研//////////////
var PrjMySRM = 0;
var prjMySRMArrived = 0;
var PrjMySRMCheck = 0;
var PaperMySRM = 0;
var MonoMySRM = 0;
var PrjAchSRM = 0;
var PatentSRM = 0;

var projUrl = 'herp.srm.srmhomepageexe.csp';
var HomePageUrl = 'herp.srm.srmhomepageexe.csp';

var userdr = session['LOGON.USERCODE'];  
var subuser = session['LOGON.USERID'];  
/**
Ext.Ajax.request({				   	    			        
                     url: projUrl+'?action=GetJournalInfo',
					           success: function(result, request){
					         	 var jsonData = Ext.util.JSON.decode( result.responseText );  
						         if (jsonData.success=='true'){
							         var data = jsonData.info;	
							         var dataarr = data.split("^",-1);
							         var typename = dataarr[2];
							         var levelname = dataarr[3]; 			
							         //var ifs = dataarr[4];	   
                                      PrjTransaction = 12;	 									 
					         	}
				         	},
					       scope: this
				   	    });          
**/			
/* var SRMPanel = new Ext.form.FormPanel({
		region:'west',
		frame:true,
		layout: 'border',
		width:300,		
		items:[]
		}); */
///////////////////////////我的事务///////////////////////xtype:'label',text///////////
var MyTransactionPanel = new Ext.form.FormPanel({
		title:'我的事务',
		region:'west',
		frame:true,
		//collapsible:true,
		width:520,
		//height:200,
        //minSize: 175,  
        //maxSize: 400,  
		reader: new Ext.data.JsonReader(
		//successProperty: 'success',
		{root:'rows'},             
		[{name:'rowid',mapping:'rowid'}, 
		{name:'name',mapping:'name'}
		]),
		//defaultType: 'textfield',
	    //defaults: {width:200},
		items:[
		  /* {
		  xtype:'textfield',
		  //xtype:'label',
		  width:200,
		  fieldLabel: '产品名称',
		  name: 'rowid',
		  id: 'rowid',
		  //hidden: true,
		  allowBlank: false
	     }, */
		  {
			xtype: 'panel',
			layout:"column",
			height:25,
			hideLabel:true,
			isFormField:true,
			items:[
			        {xtype:'displayfield',columnWidth:.02},
					/* {name:'label1',id:'label1',xtype:'label',columnWidth:.98,html:'☆科研项目'+'<a href="http://www.sina.com.cn" target="_blank"><span style="text-decoration:underline"><span style="color:#FF0000">'+PrjTransaction+'</span></span></a>'+'项待审核'} */
					{xtype:'label',columnWidth:.3,html:'☆科研项目'},
					{name:'prjnum',id:'prjnum',xtype:'displayfield',columnWidth:.05},
					{xtype:'label',columnWidth:.2,text:'项待审核'}
				]
			}, {
				xtype: 'panel',
				layout:"column",
				hideLabel:true,
				height:25,
				isFormField:true,
				items:[
					{columnWidth:.02,xtype:'displayfield'},
					//{columnWidth:.1,xtype:'label',text: '☆科研论文15篇待审核'}
					{xtype:'label',columnWidth:.3,html:'☆科研论文'},
					{name:'papernum',id:'papernum',xtype:'displayfield',columnWidth:.05},
					{xtype:'label',columnWidth:.2,text:'篇待审核'}
				]
			},{
				xtype: 'panel',
				layout:"column",
				hideLabel:true,
				height:25,
				isFormField:true,
				items:[
				    {columnWidth:.02,xtype:'displayfield'},
					//{columnWidth:.1,xtype:'label',text: '☆专著5部待审核'}
					{xtype:'label',columnWidth:.3,html:'☆专著'},
					{name:'monographnum',id:'monographnum',xtype:'displayfield',columnWidth:.05},
					{xtype:'label',columnWidth:.2,text:'部待审核'}
				]
			},{
				xtype: 'panel',
				layout:"column",
				hideLabel:true,
				height:25,
				isFormField:true,
				items:[
				    {columnWidth:.02,xtype:'displayfield'},
					//{columnWidth:.1,xtype:'label',text: '☆获奖5篇待审核'}
					{xtype:'label',columnWidth:.3,html:'☆获奖'},
					{name:'prjachinum',id:'prjachinum',xtype:'displayfield',columnWidth:.05},
					{xtype:'label',columnWidth:.2,text:'篇待审核'}
				]
			},{
				xtype: 'panel',
				layout:"column",
				hideLabel:true,
				height:25,
				isFormField:true,
				items:[
				    {columnWidth:.02,xtype:'displayfield'},
					//{columnWidth:.1,xtype:'label',text: '☆其他成果(专利5篇)'}
					{xtype:'label',columnWidth:.5,html:'☆其他成果(专利)'},
					{name:'patentnum',id:'patentnum',xtype:'displayfield',columnWidth:.05},
					{xtype:'label',columnWidth:.2,text:'项待审核'},
				]
			}
		]
});

MyTransactionPanel.form.load({      
	  method:'POST',  
	  url: projUrl+'?action=GetSRMtotal&userdr='+'userdr',
	  success:function(form,action){ //加载成功的处理函数  
                    MyTransactionPanel.load();  
                    
					 PrjTransaction=action.response.responseText;
					 var jsonData = Ext.util.JSON.decode( action.response.responseText )
					 var records = jsonData.rows;
					 PrjTransaction = records[0].srmproject;
					 PaperTransaction = records[0].srmpaper;
					 MonoTransaction = records[0].srmpatent;
					 PrjAchTransaction = records[0].srmMonograph;
					 PatentTransaction = records[0].srmaward;
					 //prjnum.html=PrjTransaction;
					 //Ext.getCmp('label1').setText(PrjTransaction);
					 Ext.getCmp('prjnum').setValue('<a href="#" onclick = "getprjnum()" ><span style="text-decoration:underline"><span style="color:#FF0000">'+PrjTransaction+'</span></span></a>');
					 Ext.getCmp('papernum').setValue('<a href="#" onclick = "getpapernum()"  target="_blank"><span style="text-decoration:underline"><span style="color:#FF0000">'+PaperTransaction+'</span></span></a>');
					 Ext.getCmp('monographnum').setValue('<a href="#" onclick = "getmononum()"  target="_blank"><span style="text-decoration:underline"><span style="color:#FF0000">'+MonoTransaction+'</span></span></a>');
					 Ext.getCmp('prjachinum').setValue('<a href="#" onclick = "getprjachnum()"  target="_blank"><span style="text-decoration:underline"><span style="color:#FF0000">'+PrjAchTransaction+'</span></span></a>');
				     Ext.getCmp('patentnum').setValue('<a href="#" onclick = "getpatentnum()"  target="_blank"><span style="text-decoration:underline"><span style="color:#FF0000">'+PatentTransaction+'</span></span></a>');
                     //Ext.Msg.alert('提示','find成功');  
                },  
                failure:function(form,action){          //加载失败的处理函数  
                    Ext.Msg.alert('提示','find失败');  
                }
	}); 


getprjnum = function(){
    /* var win = new Ext.Window({
	     title: '弹出窗口',
		 width: 400,
		 height: 400
	}); */
	/* window.location=IPURL+"herp.srm.SRMEnPaperRewAud.csp";
	var prjdata = "|||||||"+userdr+"|";
    itemGrid.load({params:{data:data,sortField:'', sortDir:'',start:0,limit:25}});   */    
    //win.show();
	alert("it's true");
};
getpapernum = function(){
	/* window.location=IPURL+"herp.srm.SRMEnPaperRewAud.csp"; */
	alert("it's true");
};
getprjachnum = function(){
	// window.location=IPURL+"herp.srm.auditprjachievement.csp";
	alert("it's true");
};
getmononum = function(){
	// window.location=IPURL+"herp.srm.monographrewardaudit.csp";
	alert("it's true");
};
getpatentnum = function(){
	// window.location=IPURL+"herp.srm.srmpatentrewardaudit.csp";
	alert("it's true");
};
///////////////////////////我的科研//////////////////////////////////
var MySRMPanel = new Ext.form.FormPanel({
		title:'我的科研',
		region:'center',
		//collapsible:true,
		frame:true,
		width:250,
		reader: new Ext.data.JsonReader(
		//successProperty: 'success',
		{root:'rows'},             
		[{name:'rowid',mapping:'rowid'}, 
		{name:'name',mapping:'name'}
		]),
		items:[{
			xtype: 'panel',
			layout:"column",
			height:25,
			hideLabel:true,
			isFormField:true,
			items:[
					{xtype:'displayfield',columnWidth:.02},
					/* {name:'label1',id:'label1',xtype:'label',columnWidth:.98,html:'☆科研项目'+'<a href="http://www.sina.com.cn" target="_blank"><span style="text-decoration:underline"><span style="color:#FF0000">'+PrjTransaction+'</span></span></a>'+'项待审核'} */
					{xtype:'label',columnWidth:.2,html:'☆科研项目'},
					{name:'MySRMprjnum',id:'MySRMprjnum',xtype:'displayfield',columnWidth:.07},
					{xtype:'label',columnWidth:.2,text:'项'}
				]
			},{
				xtype: 'panel',
				layout:"column",
				hideLabel:true,
				height:30,
				isFormField:true,
				items:[
					{xtype:'displayfield',columnWidth:.02},
					{xtype:'label',columnWidth:.2,html:'☆科研到账'},
					{name:'MySRMprjArrived',id:'MySRMprjArrived',xtype:'displayfield',columnWidth:.07},
					{xtype:'label',columnWidth:.2,text:'万元'}
				]
			},{
				xtype: 'panel',
				layout:"column",
				hideLabel:true,
				height:30,
				isFormField:true,
				items:[
					{xtype:'displayfield',columnWidth:.02},
					{xtype:'label',columnWidth:.2,html:'☆科研支出'},
					{name:'MySRMprjCheck',id:'MySRMprjCheck',xtype:'displayfield',columnWidth:.07},
					{xtype:'label',columnWidth:.2,text:'万元'}
				]
			},{
				xtype: 'panel',
				layout:"column",
				hideLabel:true,
				height:30,
				isFormField:true,
				items:[
					{xtype:'displayfield',columnWidth:.02},
					{xtype:'label',columnWidth:.2,html:'☆科研论文'},
					{name:'MySRMpapernum',id:'MySRMpapernum',xtype:'displayfield',columnWidth:.05},
					{xtype:'label',columnWidth:.2,text:'篇'}
				]
			},{
				xtype: 'panel',
				layout:"column",
				hideLabel:true,
				height:30,
				isFormField:true,
				items:[
					{xtype:'displayfield',columnWidth:.02},
					{xtype:'label',columnWidth:.2,html:'☆科研专著'},
					{name:'MySRMmonographnum',id:'MySRMmonographnum',xtype:'displayfield',columnWidth:.05},
					{xtype:'label',columnWidth:.2,text:'部'}
				]
			},
			{
				xtype: 'panel',
				layout:"column",
				hideLabel:true,
				height:30,
				isFormField:true,
				items:[
					{xtype:'displayfield',columnWidth:.02},
					{xtype:'label',columnWidth:.3,html:'☆其他成果(☆获奖'},
					{name:'MySRMprjachinum',id:'MySRMprjachinum',xtype:'displayfield',columnWidth:.05},
					{xtype:'label',columnWidth:.1,text:'项'},
					{xtype:'label',columnWidth:.1,html:'☆专利'},
					{name:'MySRMpatentnum',id:'MySRMpatentnum',xtype:'displayfield',columnWidth:.05},
					{xtype:'label',columnWidth:.1,text:'项)'}
				]
			}
		]
});
MySRMPanel.form.load({      
	  method:'POST',  
	  url: HomePageUrl+'?action=GetMySRMtotal&start=0&limit=10&str='+'Medline',
	  success:function(form,action){ //加载成功的处理函数  
                    MySRMPanel.load();  
                    
					 //PrjTransaction=action.response.responseText;
					 var MySRMjsonData = Ext.util.JSON.decode( action.response.responseText )
					 var MySRMrecords = MySRMjsonData.rows;
					 PrjMySRM = MySRMrecords[0].MySRMprjnum;
					 prjMySRMArrived = MySRMrecords[0].MySRMprjArrived;
					 PrjMySRMCheck = MySRMrecords[0].MySRMprjCheck;
					 PaperMySRM = MySRMrecords[0].MySRMpapernum;
					 MonoMySRM = MySRMrecords[0].MySRMmonographnum;
					 PrjAchSRM = MySRMrecords[0].MySRMprjachinum;
					 PatentSRM = MySRMrecords[0].MySRMpatentnum;
					 //prjnum.html=PrjTransaction;
					 //Ext.getCmp('label1').setText(PrjTransaction);
					 Ext.getCmp('MySRMprjnum').setValue('<span style="color:#FF0000">'+PrjMySRM+'</span>');
					 Ext.getCmp('MySRMprjArrived').setValue('<span style="color:#FF0000">'+prjMySRMArrived+'</span>');
					 Ext.getCmp('MySRMprjCheck').setValue('<span style="color:#FF0000">'+PrjMySRMCheck+'</span>');
					 Ext.getCmp('MySRMpapernum').setValue('<span style="color:#FF0000">'+PaperMySRM+'</span>');
					 Ext.getCmp('MySRMmonographnum').setValue('<span style="color:#FF0000">'+MonoMySRM+'</span>');
					 Ext.getCmp('MySRMprjachinum').setValue('<span style="color:#FF0000">'+PrjAchSRM+'</span>');
				     Ext.getCmp('MySRMpatentnum').setValue('<span style="color:#FF0000">'+PatentSRM+'</span>');
                     //Ext.Msg.alert('提示','find成功');  
                },  
                failure:function(form,action){          //加载失败的处理函数  
                    Ext.Msg.alert('提示','MySRMfind失败');  
                }
	}); 
///////////////////////////系统消息//////////////////////////////////
var SystemMessageDs = new Ext.data.Store({
		proxy:  new Ext.data.HttpProxy({url:'../csp/herp.srm.srmhomepageexe.csp' + '?action=GetSystemMessage&start='+0+'&limit='+100}),
	    reader: new Ext.data.JsonReader({
	        root: 'rows',
	        totalProperty: 'results'
	    }, [
			'rowid',
			'year',
			'title',
			'message',
			'subuser',
			'subdate',
			'IsAttachment'	
		]),
	    remoteSort: true
	    //与排序相关的参数还有remoteSort，这个参数是用来实现后台排序功能的。当设置为 remoteSort:true时，store会在向后台请求数据时自动加入sort和dir两个参数，分别对应排序的字段和排序的方式，由后台获取并处理这两个参数，在后台对所需数据进行排序操作。remoteSort:true也会导致每次执行sort()时都要去后台重新加载数据，而不能只对本地数据进行排序。
});
var PagingToolbar = new Ext.PagingToolbar({
		id:'PagingToolbar',
		pageSize: 20,
		store: SystemMessageDs,
		atLoad : true,
		displayInfo: true,  
		displayMsg: '当前显示{0} - {1}，共计{2}',
		emptyMsg: "没有数据"//,

});
//设置默认排序字段和排序方向
SystemMessageDs.setDefaultSort('rowid', 'subdate');	
//数据库数据模型
var SystemMessageCm = new Ext.grid.ColumnModel([
	new Ext.grid.RowNumberer(), 
	//new Ext.grid.CheckboxSelectionModel ({singleSelect : false}), 
	{
		id:'rowid',
		header:'ID',
		hidden:true
		
	},
	{
		id:'title',
		header:'标题',
		align:'center',
		//width:320,
		dataIndex: 'title',
                    renderer : function(value, cellmeta, record, rowIndex, columnIndex, store)
						{ 
							return '<span style="color:blue;cursor:hand">'+value+'</span>'	 
						}
	},
	{
		id:'message',
		header:'内容',
		align:'center',
		width:80,
		dataIndex: 'message',
                    renderer : function(value, cellmeta, record, rowIndex, columnIndex, store)
						{ 
							return '<span style="color:blue;cursor:hand">'+value+'</span>'	 
						}
	},
	{
			id:'upload',
			header: '附件',
			align:'center',
			allowBlank: false,
			width:40,
			editable:false,
			dataIndex: 'upload',
			renderer : function(v, p, r){			
			return '<span style="color:blue"><u>上传</u></span>';
			}
	},{
			id:'download',
			header: '下载',
			align:'center',
			allowBlank: false,
			width:40,
			editable:false,
			dataIndex: 'download',
			renderer : function(v, p, r){
			return '<span style="color:blue"><u>下载</u></span>';
			} 
	},
	{
			id:'IsAttachment',
			header: '是否有附件',
			allowBlank: false,
			width:40,
			hidden:true,
			editable:false,
			dataIndex: 'IsAttachment',
			renderer : function(v, p, r){
			return '<span style="color:blue"><u>下载</u></span>';
			} 
	}
	
]);

var addButton = new Ext.Toolbar.Button({
					text : '添加',
					tooltip : '添加',
					iconCls : 'add',
					handler : function() {
						SystemInfoAddFun();
					}
				});

var editButton = new Ext.Toolbar.Button({
					text : '修改',
					tooltip : '修改',
					iconCls : 'option',
					handler : function() {
						SystemInfoEditFun();
					}
				});
var delButton = new Ext.Toolbar.Button({
			text : '删除',
			tooltip : '删除',
			iconCls : 'remove',
			handler : function() {
				var rowObj = SystemMessageGrid.getSelectionModel().getSelections();
				var len = rowObj.length;
				var tmpRowid = "";
		
				if (len < 1) {
					Ext.Msg.show({
								title : '注意',
								msg : '请选择需要删除的数据!',
								buttons : Ext.Msg.OK,
								icon : Ext.MessageBox.WARNING
							});
					return;
				} else {
					tmpRowid = rowObj[0].get("rowid");
					Ext.MessageBox.confirm('提示', '确定要删除选定的行?', function(btn) {
						if (btn == 'yes') {
							Ext.Ajax.request({
								url : HomePageUrl + '?action=del&rowid=' + tmpRowid,
								waitMsg : '删除中...',
								failure : function(result, request) {
									Ext.Msg.show({
												title : '错误',
												msg : '请检查网络连接!',
												buttons : Ext.Msg.OK,
												icon : Ext.MessageBox.ERROR
											});
								},
								success : function(result, request) {
									var jsonData = Ext.util.JSON
											.decode(result.responseText);
									if (jsonData.success == 'true') {
										Ext.Msg.show({
													title : '注意',
													msg : '操作成功!',
													buttons : Ext.Msg.OK,
													icon : Ext.MessageBox.INFO
												});
										SystemMessageDs.load({
													params : {
														start : 0,
														limit : 25
													}
												});
									} else {
										Ext.Msg.show({
													title : '错误',
													msg : '错误',
													buttons : Ext.Msg.OK,
													icon : Ext.MessageBox.ERROR
												});
									}
								},
								scope : this
							});
						}
					})
				}
			}
});

var SystemMessageGrid = new Ext.grid.GridPanel({
	id:'SystemMessageGrid',
	region:'center',
	//layout:'fit',
	readerModel:'local',
	url:projUrl,
	atLoad:true,
	store:SystemMessageDs,
	cm:SystemMessageCm,	
	sm:new Ext.grid.CheckboxSelectionModel(),
	trackMouseOver:true,
	loadMask:true,
	bbar:PagingToolbar,
    tbar:[addButton,'-',editButton,'-',delButton]	
});

SystemMessageDs.load({
			params:{start:0, limit:PagingToolbar.pageSize},
		    callback:function(record,options,success ){
			SystemMessageGrid.fireEvent('rowclick',this,0);
			}

});
SystemMessageGrid.on('cellclick', function(g, rowIndex, columnIndex, e) {
	
	var records = SystemMessageGrid.getSelectionModel().getSelections();
	if (columnIndex == 3) {        	
		var rowid  = records[0].get("rowid");
		var messagetitle  = records[0].get("message");
		//alert("aaa");
		alert(messagetitle);
		//GetSystemMessageDetail(rowid,messagetitle);这里写弹出消息的详细内容的窗口window
	}
		
});
uploadMainFun(SystemMessageGrid,'rowid','XX001',4);
downloadMainFun(SystemMessageGrid,'rowid','XX001',5);

///////////////////////////科研动态//////////////////////////////////
var SRMDynamicPanel = new Ext.form.FormPanel({
        //title :'科研动态',
		region:'south',
		defaults:{
			//collapsible:true,
			autoScroll : true
		},
		//collapsible:true,
		height:300,
		layout:'border',
		//html:'<div id="mychartdiv"></div>'
		items:[
			{
				title:'科研动态',
				//collapsible:true,
				layout:'fit',
				html:'<div id="mychartdiv"></div>',
				region:'center'
			},
			{
				title:'系统消息',
				//collapsible:true,
				//html:'<div id="mychartdiv"></div>',
				region:'east',
				layout:'fit',
				width:350,
				items:SystemMessageGrid
			}
		]
});

Ext.Ajax.request({
	           url: HomePageUrl+'?action=GetChartTotal&userdr='+userdr,				
	           async:false,
	           success:function (response){ 
	           json = response.responseText;
	           jsonData = Ext.util.JSON.decode(json);   
	           var a = jsonData.rows;
	           //var data = json.split("^")
	           //var a = Ext.util.JSON.decode(data[0]).rows;
	           //var b = Ext.util.JSON.decode(data[1]).rows; 
	           //var c = Ext.util.JSON.decode(data[2]).rows; 
	           //var d = Ext.util.JSON.decode(data[3]).rows;
	           //alert(a+b+c+d)
	           
	           var  myChart6 = new FusionCharts("../scripts/herpg/Charts/swf/MSColumn2D.swf", "myChat6","600", "300", "0", "1");  
	           myChart6.setJSONData({      
             	chart:{      
                    caption:"近一年科研成果动态",     
                    //xaxisname:"hjb",     
                    yaxisname:"数量",    
                    showvalues:1,
                    showname:1,      
                    //numberprefix:"￥",
                    //labelDisplay:"WRAP",
                    exportAction:'download',
                    exportEnabled:1,
                    exportAtClient:1,
                    exportHandler:"FCExporter"  }, 
                    categories:[{  "category":a }  
               		],      
            		dataset:[        
                           	  {   "data":a  },
                  
            		 ] 
            	}); 
                myChart6.render("mychartdiv");
	           },
	           scope:this
	       })
///////////////////////////消息与预警//////////////////////////////////
/*var SRMNewsPanel = new Ext.form.FormPanel({
		region:'east',
		width:350,
		//collapsible:true,
		title:'消息与预警'
});*/
