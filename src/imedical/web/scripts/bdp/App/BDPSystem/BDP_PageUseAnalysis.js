 ////Fuction: 系统配置-页面使用分析 
 /// Creator: sunfenghao
 /// CreateDate: 2016-1-15
 document.write(' <script src="../scripts/bdp/App/BDPSystem/echarts/build/dist/echarts.js" charset="UTF-8"></script>'); 
 document.write(' <script src="../scripts/bdp/App/BDPSystem/ext-basex.js"> </script> '); 
 document.write('<div id="main" style="height:95%;width:65%;"></div>'); 
 Ext.onReady(function() {
  var ObjectReference="";
  var ClassN="";
  var QUERY_ACTION_URL2 = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.BDP.BDPMenuUseFrency&pClassQuery=GetList";
  var ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.BDP.BDPMenuUseFrency&pClassMethod=GetFrecency";
  
  var browser=navigator.appName 
  var b_version=navigator.appVersion 
  var version=b_version.split(";"); 
  var trim_Version=version[1].replace(/[ ]/g,""); 
   
  if((browser=="Microsoft Internet Explorer")&&((trim_Version=="MSIE6.0") ||(trim_Version=="MSIE7.0") ||(trim_Version=="MSIE8.0") ||(trim_Version=="MSIE9.0")))
  {  
    document.getElementById('main').style.height="90%"
    document.getElementById('main').style.width="65%"
  }
  else{ 
    document.getElementById('main').style.height="100%"
    document.getElementById('main').style.width="100%"
  }
   /************************************数据存储***********************************/
   var ds = new Ext.data.Store({
       proxy : new Ext.data.HttpProxy({
           url : ACTION_URL
        }), 
       reader : new Ext.data.JsonReader({
          totalProperty : 'total',
          root : 'data' 
      }, [ {
         name : 'Count',
         mapping : 'Count',
         type : 'int'
        },{ 
         name : 'ClassName',
         mapping : 'ClassName',
         type : 'string'
        },{
         name : 'ClassNameDesc',
         mapping : 'ClassNameDesc',
         type : 'string'
        },{
         name : 'TableName:',    
         mapping : 'TableName:',
         type : 'string'
        }
      ]),
   	remoteSort: true,
    sortInfo:{field:'Count',direction:'DESC'}
  });
 /***********************************数据加载************************************/
  var pagebar = new Ext.PagingToolbar({
        pageSize: 20,
        store: ds,
        displayInfo: true,
        displayMsg: '共有 {2} 条数据',
        emptyMsg: "没有记录"    ,
    	listeners : {
		    "change":function (t,p)
		     {   
		       	var NewArr=new Array();
		        var NewXAisArr=new Array();
		        var data=t.store.data.items;
                if (data.length>0){
	            for (var i=0;i<data.length;i++)
	            {
	               NewArr.push(data[i].json.Count);
	               NewXAisArr.push(data[i].json.ClassNameDesc)
	             }
	             refreshData(NewXAisArr,NewArr);  
		      } 
              else{
                document.getElementById('main').style.height="100%"
                document.getElementById('main').style.width="100%"
             }
           }
         } 
 	});
 var sm = new Ext.grid.CheckboxSelectionModel({
      singleSelect : true,
      checkOnly : false,
      width : 20
 });
ds.load({
   	 params : {
		        start : 0,
		        limit : 20 
		      } 
   }); 
/************************************创建列表************************************/
 var cm=new Ext.grid.ColumnModel(    
 [{
       header : 'ClassName',
       width : 120,
       dataIndex :'ClassName' 
      },{
       header : '类名称',
       width : 120,
       dataIndex : 'ClassNameDesc'
      }, {
       header : '使用次数',
       width : 80,
     sortable : true,
       dataIndex :'Count'
      } 
   ]);
 var grid = new Ext.grid.GridPanel({
    id : 'grid',
    width : 360,
    region : 'west',
    store : ds,
    trackMouseOver : true,
    cm:cm,
    bbar : pagebar,
    stateId : 'grid' ,
  	viewConfig : {
          forceFit : true,
          emptyText:"<span style='color:red;<font size=25>;font-weight:bold;'>对不起,没有检索到相关数据.</span>'",
          enableRowBody: true  
    },
  	listeners: 
  	{  
       sortchange: function (ct, column) 
   	   {  
          if(column.field=="Count")
      	  {
      		var arr2=new Array();
            var xAxisArr2=new Array();
	      	var len=grid.getStore().data.length
	      	var data=grid.getStore().data.items.json
	      	for (var i=0;i<len;i++)
	      	{
              arr2.push(grid.getStore().data.items[i].json.Count);
              xAxisArr2.push(grid.getStore().data.items[i].json.ClassNameDesc)
            }
            refreshData(xAxisArr2,arr2);    
      	  }  
    	}   
     }   
   });
 
///////////////////////////////////////////////////////////////////////////////////////////
var ds2 = new Ext.data.Store({
        proxy : new Ext.data.HttpProxy({ url : QUERY_ACTION_URL2 }), 
        reader : new Ext.data.JsonReader({
              totalProperty : 'total',
              root : 'data',
              successProperty : 'success'
            }, [{
                  name : 'ID',
                  mapping : 'ID',
                  type : 'string'
                } , {
                  name : 'TableName',
                  mapping : 'TableName',
                  type : 'string'
                } , {
                  name : 'ClassName',
                  mapping : 'ClassName',
                  type : 'string'
                }, {
                  name : 'ClassNameDesc',
                  mapping : 'ClassNameDesc',
                  type : 'string'
                },{
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
                },  {
                  name : 'IpAddress',
                  mapping : 'IpAddress',
                  type : 'string'
                }, {
                  name : 'UpdateUserName',
                  mapping : 'UpdateUserName',
                  type : 'string'
                }, {
                  name : 'UpdateDate',
                  mapping : 'UpdateDate',
                  type : 'date',
                  dateFormat : 'm/d/Y'
                }, {
                  name : 'UpdateTime',
                  mapping : 'UpdateTime',
                  type : 'time'
                }, {
                  name : 'OperateType',
                  mapping : 'OperateType',
                  type : 'string'
                }, {
                  name : 'NewValue',
                  mapping : 'NewValue',
                  type : 'string'
                },{
                  name:'OldValue',
                  mapping:'OldValue',
                  type:'string'
                },{
                  name:'StrJson',
                  mapping:'StrJson',
                  type:'string'
                } ,{
                  name:'ExpanderStrJson',
                  mapping:'ExpanderStrJson',
                  type:'string'                 
                } 
            ])
      }); 
/****************************************grid分页工具条******************************/
var paging2 = new Ext.PagingToolbar({
        pageSize : 20,
        store : ds2,
        displayInfo : true,
        displayMsg : '显示第 {0} 条到 {1} 条记录,一共 {2} 条',
        emptyMsg : "没有记录"
  });
   
 var OrderAllergyMaintain = new Ext.form.FormPanel({
    id : 'form-viceadmin',
    labelAlign : 'right',
    height : 80,
    split : true,
    frame : true,
    labelWidth : 80,
    items : [{
      border : false,
      items : [{
        layout : "column",
        xtype : 'fieldset',
        items:[{
          columnWidth : .25,  
          layout : "form",  
          items:[{
            fieldLabel : '开始日期',
            xtype : 'datefield',
            format : BDPDateFormat,
            width : 120,
            id : 'datefrom' ,
		    enableKeyEvents : true,
		    listeners : {   
		       'keyup' : function(field, e)
		        { 
		          Ext.BDP.FunLib.Component.GetCurrentDate(field,e); 
		        }}
		     }]
        }, {
          columnWidth : .25,
          layout : "form",
          items : [{ 
            fieldLabel : '结束日期',
            xtype : 'datefield',
            width : 120,
            id : 'dateto' ,
            format : BDPDateFormat,
      		enableKeyEvents : true,
      		listeners : {   
		        'keyup' : function(field, e)
		        { 
		          Ext.BDP.FunLib.Component.GetCurrentDate(field,e);
		        }}      
          	}]
      },{ 
      	  columnWidth : .25,
          layout : "form",
          items : [{ 
	      xtype:'textfield',
	      fieldLabel:'类名称',
	      id:'className',
	      width:120
	      }]
	    },{
          xtype:'button',
          text : '搜索',
          width : 60,
          iconCls:'icon-search',
          handler : function() 
	      {
            var datefrom=Ext.getCmp('datefrom').getValue();
            var dateto=Ext.getCmp('dateto').getValue();
      		var classDesc=Ext.getCmp('className').getValue();
            var arr2=new Array();
            var xAxisArr2=new Array();
      		grid.getStore().baseParams = { classDesc:classDesc,datefrom:datefrom,dateto:dateto }; 
            grid.getStore().load({
              params : {
                  start : 0,
                  limit : 20
                },
              callback:function(r,options,success){
            	if(success){
		          var data=grid.getStore().reader.jsonData.data;
		          var len=grid.getStore().data.length
		          var data=grid.getStore().data.items.json
		          for (var i=0;i<len;i++)
		          {
		            arr2.push(grid.getStore().data.items[i].json.Count);
		            xAxisArr2.push(grid.getStore().data.items[i].json.ClassNameDesc)
		          }
                  getEcharts(datefrom,dateto,classDesc)
		          // refreshData(xAxisArr2,arr2);    
                };
              } 
          }); 
   		}
     },{
	      xtype:'button',
	      text : '重置',
	      width : 60,
          iconCls:'icon-refresh',
	      handler : function() {
	        Ext.getCmp('datefrom').reset();
	        Ext.getCmp('dateto').reset();
	        Ext.getCmp('className').reset();
	        grid.getStore().baseParams = { classDesc:'',datefrom:'',dateto:'' };  
	        ds.load({
	          params:{
			            start : 0,
			            limit : 20 
			          }  
	         }); 
     	 }
    },{ 
      columnWidth : .2,
      layout : "form",
      items : [{ 
			      xtype:'combo',
			      fieldLabel:'更换皮肤',
			      id:'changethemeF',
			      width:80,
			      name:'changetheme',
			      readOnly : Ext.BDP.FunLib.Component.DisableFlag('changethemeF'),
			      style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('changethemeF')),
			      store:new Ext.data.SimpleStore({
			      fields:['changetheme','value'],
			      data:[
			          ['macarons','macarons'],
			          ['infographic','infographic'],
			          ['default','default']
			        ]
			       }),
		       	displayField:'value',
		       	valueField:'changetheme',
		       	mode:'local',
		       	triggerAction:'all',
		       	enableKeyEvents : true,
		       	validationEvent : 'blur' ,
		        listeners : {
			        "select" : function(ec){
			           theme=Ext.getCmp('changethemeF').getValue();   
			           myChart.setTheme(theme)     
			        }
		       }
      		}]
    	}]
     }]
  }] 
 });

/** ***********************************创建grid ****************************************/
var grid2 = new Ext.grid.GridPanel({
        id : 'grid',
        region : 'center',
        store : ds2,
        trackMouseOver : true,        
        columns : [ 
            {
              header : 'ID',
              sortable : true,
              dataIndex : 'ID',
              hidden : true
            },{
              header : '更新日期',
              sortable : true,
              renderer : Ext.util.Format.dateRenderer(BDPDateFormat),
              dataIndex : 'UpdateDate',
              width : 80
            }, {
              header : '更新时间',
              sortable : true,
              dataIndex : 'UpdateTime',
              width : 70
            }, {
              header : '操作类型',
              sortable : true,
              width:60,
              dataIndex : 'OperateType',
              renderer : function(v){
                if(v=='U'){return "<img src='../scripts/bdp/Framework/icons/update.gif'>"+"   修改";}
                if(v=='D'){return "<img src='../scripts/bdp/Framework/icons/delete.gif'>"+"   删除";}
                if(v=='A'){return "<img src='../scripts/bdp/Framework/icons/add.gif'>"+"   新增";;}
              }
            },{
              header:'表名称',
              sortable:true,
              dataIndex:'TableName',
              hidden:true,
              width : 100
            },{
              header : '类名称',
              sortable : true,
              hidden:true,
              dataIndex : 'ClassName',
              width : 80
            },{
              header : '类描述',
              sortable : true,
              dataIndex : 'ClassNameDesc',
              width : 80
            },{
              header:'对象ID',
              sortable:true,
              width:80,
              dataIndex:'ObjectReference'
            },{
              header : '对象描述',
              sortable : true,
              width:90, 
              dataIndex : 'ObjectDesc'
            },{
              header : '用户',
              sortable : true,
              hidden:true,
              dataIndex : 'UpdateUserDR', 
              width : 80
            }, {
              header : '用户名',
              sortable : true,
              dataIndex : 'UpdateUserName',
              width : 80
            }, {
              header : '用户IP',
              sortable : true,
              dataIndex : 'IpAddress',
              width : 80
            },  {
              header:'原始数据',
              sortable:true,
              hidden:true,
              dataIndex:'OldValue',
              width:10
            },{
              header : '修正的数据',
              sortable : true,
              dataIndex : 'NewValue',
              hidden:true,
              width : 10
            },{
              header:'数据明细(原始数据->修正数据)',
              sortable:true,
        	  dataIndex:'StrJson',
              width:430 ,
	          renderer: function(value, meta, record) {    
		         meta.attr = 'style="white-space:normal;word-wrap:break-word; width:91%;"'; 
		         return value;     
		      }  
            }],
        stripeRows : true,
        autoStroll:true,
        columnLines : true, 
    	viewConfig : {
          forceFit: true
      	},
        sm : new Ext.grid.CheckboxSelectionModel(), 
        bbar : paging2,
        stateId : 'grid2'
      });

    var myChart; 
    var datefrom=""
    datefrom=Ext.getCmp('datefrom').getValue();
    var dateto=""
    dateto=Ext.getCmp('dateto').getValue();
    var classDesc=""
    classDesc=Ext.getCmp('className').getValue();  
    ///  后台取数据
    var ss;
    var getEcharts=function(datefrom,dateto,classDesc){ 
    Ext.Ajax.request({
       url : ACTION_URL,
       method : 'GET',
       dataType: 'json',
       async: false,  //同步
   	   params:{
		      'classDesc':classDesc,
		      'datefrom':datefrom ,
		      'dateto':dateto,
		      'start':0,
		      'limit':20,
		      'dir':grid.getStore().sortInfo.direction 
       		},
       callback:function(options, success, response) {
             if (success) {
        		ss=response.responseText;
             } 
           }
        });
        return ss;   
      }
    var myChart ;
    var arr=new Array();
    var xAxisArr=new Array();
    var ClassNameArr=new Array();
    var showStr=getEcharts(datefrom,dateto,classDesc);
    try{
	    ss=showStr.substring(28,showStr.length-1);
       
	    if(ss.indexOf(":[{")>=0){
	      ss=showStr.substring(28+ss.indexOf(":[{")+1,showStr.length-1);
	    }
	    ss=eval(ss);       
		for(var i=0;i<ss.length;i++)
		{
		    arr.push(ss[i].Count); 
		    xAxisArr.push(ss[i].ClassNameDesc);  
		 }  
   }catch (e) {
   	  Ext.Msg.alert("提示","数据解析失败!")
   } 
    /*********************************配置Echarts 图表*************************************************/
     require.config({
           paths: {
               echarts: '../scripts/bdp/App/BDPSystem/echarts/build/dist'
          }
     });
    // use
    require(
            [
                'echarts',
		        'echarts/theme/default',
		        'echarts/theme/macarons',
		        'echarts/theme/infographic',
		        'echarts/chart/bar',
		        'echarts/chart/line' 
            ],  
 	function DrawEChart(ec,theme) {
    	myChart = ec.init(document.getElementById('main'),theme); 
    	var  option = {
            title : {
      			text: '页面使用统计(双击左侧记录查看详情)'  ,
           		x: 'center'   
          	}, 
          	//是否启用拖拽重计算特性，默认关闭(即值为false)  
          calculable: true,  
	      tooltip : {
	     	 trigger:'axis'
	      },
          toolbox:{
     		show : true,
      		feature:{
            	magicType:{show: true, type: ['line', 'bar']},
            	restore:{show: true}
        	 }
   		  }, 
          legend: {  
	          show: true,  
	          x: 'left',  
	          y: 'top',  
	          data: ['使用量']  
	      },  
          xAxis:[{
              data:xAxisArr
           }],
          yAxis:[{
                   type : 'value'
                }],
           series:[{   
                    "type":"bar",
                     "data":arr
                 }],
           noDataLoadingOption :{
                    text: '暂无数据',
                    effect:'bubble',
                    effectOption : {
                    effect: {
                            n: 0 //气泡个数为0 
                    }
                }
           } 
         };    
    	window.onresize = myChart.resize;
    	myChart.setOption(option);
         /// 点击柱子时的事件
        var ecConfig = require('echarts/config');
        myChart.on(ecConfig.EVENT.CLICK, function (param) {
        var DataIndex=param.dataIndex
       	var ClassName=ds.data.items[DataIndex].data.ClassName ;
       	var UserClassNameDesc=ds.data.items[DataIndex].data.ClassNameDesc;
        var Log_Win = new Ext.Window({
	              title:param.name +'使用记录',
	              width :1100,
	              height :420,
	              layout : 'fit',
	              plain : true, 
	              modal : true,
	              frame : true,
	              constrain : true,
	              closeAction : 'hide' ,
	              items:grid2
         });
      	var datefrom=Ext.getCmp('datefrom').getValue();
        var dateto=Ext.getCmp('dateto').getValue();
        grid2.getStore().baseParams={UserClass:ClassName,UserClassNameDesc:UserClassNameDesc,datefrom:datefrom,dateto:dateto};
          ds2.load({
	          params : {
	              start : 0,
	              limit : 20
	            } 
	       });
          Log_Win.show();
        });
     })
   var refreshData=function(xAxisArr2,arr2)
   {
    if(!myChart){
       document.getElementById('main').style.height="100%"
       document.getElementById('main').style.width="100%"
       return;
    } 
  var option = myChart.getOption(); 
  if ((arr2!="")&&(xAxisArr2!=""))
  { 
    myChart.clear();
    option.xAxis =[{
     	data:xAxisArr2
     }];
    option.series =[{
      	"type":"bar",
         "data":arr2
     }] 
    myChart.setOption(option,true); 
  }
  else
  {
     // 将横坐标置空
    option.xAxis=[];
    option.series =[];
    myChart.clear();
    myChart.setOption(option);  
  }
 }
 grid.on("rowdblclick",function(grid,rowIndex,e){
    var record = grid.getSelectionModel().getSelected();  
    var UserClass=record.data.ClassName;
  	var UserClassNameDesc=record.data.ClassNameDesc;
    var Log_Win2 = new Ext.Window({
              title:record.data.ClassNameDesc +'使用记录',
              width :1100,
              height :420,
              layout : 'fit',
              plain : true, 
              modal : true,
              frame : true,
              constrain : true,
              closeAction : 'hide' ,
              items:grid2
          });
      var datefrom=Ext.getCmp('datefrom').getValue();
          var dateto=Ext.getCmp('dateto').getValue();
          grid2.getStore().baseParams={'UserClass':UserClass, 'UserClassNameDesc':UserClassNameDesc,'datefrom':datefrom, 'dateto':dateto};
          ds2.load({
            params : {
			          start : 0,
			          limit : 20
			        } 
        	});
       	 Log_Win2.show();
    }); 
  
    var viewport = new Ext.Viewport({
      	layout:'border',
        items: [{
                region:'north',
                height:80,
                items:[OrderAllergyMaintain]
              },grid,{
               region:'center',
               contentEl: 'main'
            }    
         ]
      });
   });
  
