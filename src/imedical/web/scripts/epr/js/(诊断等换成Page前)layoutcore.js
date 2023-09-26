var tabpannel;    

Ext.onReady(function(){

        //Ext.state.Manager.setProvider(new Ext.state.CookieProvider());

//-----------------------------------
	var dataExam=[[1, '腹部B超','14/08/2008','B超室','张文和','肝胆胰脾未见异常']];		   
	var storeExam=new Ext.data.SimpleStore({data:dataExam,fields:["id","item","dateTime","examDept","examDoc","result"]});
	var gridExam = new Ext.grid.GridPanel({
		title:'检查结果',
		el:'Exam',
		border:false,
		columns:[{header:"检查项目",dataIndex:"item"},
		{header:"检查日期",dataIndex:"dateTime"},
		{header:"检查科室",dataIndex:"examDept"},
		{header:"检查医生",dataIndex:"examDoc"},
		{header:"检查结果",dataIndex:"result"}
		],
		store:storeExam,
		autoExpandColumn:4
		});
	
	var dataTest=[[1, '白细胞计数','WBC','23.00','H *10^9./L','(4.00-10.00)']];		   
	var storeTest=new Ext.data.SimpleStore({data:dataTest,fields:["id","item","english","result","unit","normal"]});
	var gridTest = new Ext.grid.GridPanel({
		title:'化验结果',
		el:'TestTab',
		border:false,
		columns:[{header:"检验项目",dataIndex:"item"},
		{header:"英文对照",dataIndex:"english"},
		{header:"结果",dataIndex:"result"},
		{header:"单位",dataIndex:"unit"},
		{header:"参考值",dataIndex:"normal"}
		],
		store:storeTest,
		autoExpandColumn:4
		});

	var storeOrd = new Ext.data.Store
            ({
                proxy : new Ext.data.HttpProxy({ url : '~/web/web.eprajax.orderdata.cls' }),
                reader : new Ext.data.JsonReader(
                {
                    totalProperty : 'totalProperty',            //分页时的总条数
                    root : 'root'                               //具体数据
                }, 
                [
                    { name : 'ordDateTime' },
                    { name : 'excDateTime' },
                    { name : 'name' },
                    { name : 'dosage' },
                    { name : 'unit' },
                    { name : 'frequency' },
                    { name : 'period' },
                    { name : 'category' },
                    { name : 'status' },
                    { name : 'prescriptionID' },
                    { name : 'pharmStatus' },
                    { name : 'auditor' }                   
                ])
            });
            
            storeOrd.on('beforeload', function(){
            Ext.apply(
                this.baseParams,
                {
                    condition : '参数', value : '参数'
                });
             }); 		   
			   
	var gridOrd = new Ext.grid.GridPanel({
		title:'本次医嘱',
		border:false,
		columns:[{header:"开立时间",dataIndex:"ordDateTime"},
		{header:"执行时间",dataIndex:"excDateTime"},
		{header:"名称",dataIndex:"name"},
		{header:"剂量",dataIndex:"dosage"},
		{header:"单位",dataIndex:"unit"},
		{header:"频次",dataIndex:"frequency"},
		{header:"疗程",dataIndex:"period"},
		{header:"种类",dataIndex:"category"},
		{header:"状态",dataIndex:"status"},
		{header:"处方号",dataIndex:"prescriptionID"},
		{header:"药品状态",dataIndex:"pharmStatus"},
		{header:"审核医生",dataIndex:"auditor"}
		],
		store:storeOrd,
		autoExpandColumn:11
		});
		
		storeOrd.load(
		{
		params : { start : 0, limit : 25, condition : 'condition', value : 'value' }
		});

//--------------------------------------------------
	tabpannel = new Ext.TabPanel({
              region:'center',
              deferredRender: false,
              activeTab:0,
              minTabWidth: 100,
              resizeTabs: true,
              border: false,	
	      enableTabScroll: false,
	      defaults: {autoScroll:false},
	      autoDestroy: false,
	      listeners:{
                remove: function(tp, c) {c.hide();}
	      },
              items:[
		new Ext.BoxComponent({
		 id: 'eprquality',
		 el: 'frameeprquality',
	         title: '质控提示',
                 autoScroll: false
                }),
		new Ext.BoxComponent({
		 id: 'epredit',
		 el: 'frameepredit',
	         title: '病历书写',
                 autoScroll: false
                }),
		new Ext.BoxComponent({
		 id: 'eprlist',
		 el: 'frameeprlist',
	         title: '病程列表',
                 autoScroll: false
                }),
		new Ext.BoxComponent({
		 id: 'eprbrowser',
		 el: 'frameeprbrowser',
	         title: '病历浏览',
                 autoScroll: false
                })
		]
       });

       var southTab = new Ext.TabPanel({
                            border:false,
                            activeTab:0,
                            tabPosition:'bottom',
                            deferredRender: false,
                            items:[gridOrd,gridExam,gridTest]
                        })
        
       var viewport = new Ext.Viewport({
            layout:'border',
            items:[
                {
		    id:'southregion',
                    region:'south',
		    contentEl: 'south',
                    split:true,
                    height: 200,
                    minSize: 100,
                    maxSize: 360,
                    collapsible: true,
		    collapsed: true,
                    title:'本次医嘱',
                    layout:'fit',
                    autoScroll:true,
		    items:[southTab]
                },tabpannel
             ]
        });

	southTab.on('tabchange', function(tab, activetabItem){viewport.getComponent('southregion').setTitle(activetabItem.title);});
	tabpannel.remove('eprlist');
	tabpannel.remove('epredit');
	Ext.getDom("frameeprbrowser").src='./epr.eprbrowser.csp';
	Ext.getDom("frameeprquality").src='./epr.qualityreport.csp?EpisodeID=' + EpisodeID;
    });