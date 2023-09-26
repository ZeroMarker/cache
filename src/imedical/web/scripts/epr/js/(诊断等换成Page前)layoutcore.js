var tabpannel;    

Ext.onReady(function(){

        //Ext.state.Manager.setProvider(new Ext.state.CookieProvider());

//-----------------------------------
	var dataExam=[[1, '����B��','14/08/2008','B����','���ĺ�','�ε���Ƣδ���쳣']];		   
	var storeExam=new Ext.data.SimpleStore({data:dataExam,fields:["id","item","dateTime","examDept","examDoc","result"]});
	var gridExam = new Ext.grid.GridPanel({
		title:'�����',
		el:'Exam',
		border:false,
		columns:[{header:"�����Ŀ",dataIndex:"item"},
		{header:"�������",dataIndex:"dateTime"},
		{header:"������",dataIndex:"examDept"},
		{header:"���ҽ��",dataIndex:"examDoc"},
		{header:"�����",dataIndex:"result"}
		],
		store:storeExam,
		autoExpandColumn:4
		});
	
	var dataTest=[[1, '��ϸ������','WBC','23.00','H *10^9./L','(4.00-10.00)']];		   
	var storeTest=new Ext.data.SimpleStore({data:dataTest,fields:["id","item","english","result","unit","normal"]});
	var gridTest = new Ext.grid.GridPanel({
		title:'������',
		el:'TestTab',
		border:false,
		columns:[{header:"������Ŀ",dataIndex:"item"},
		{header:"Ӣ�Ķ���",dataIndex:"english"},
		{header:"���",dataIndex:"result"},
		{header:"��λ",dataIndex:"unit"},
		{header:"�ο�ֵ",dataIndex:"normal"}
		],
		store:storeTest,
		autoExpandColumn:4
		});

	var storeOrd = new Ext.data.Store
            ({
                proxy : new Ext.data.HttpProxy({ url : '~/web/web.eprajax.orderdata.cls' }),
                reader : new Ext.data.JsonReader(
                {
                    totalProperty : 'totalProperty',            //��ҳʱ��������
                    root : 'root'                               //��������
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
                    condition : '����', value : '����'
                });
             }); 		   
			   
	var gridOrd = new Ext.grid.GridPanel({
		title:'����ҽ��',
		border:false,
		columns:[{header:"����ʱ��",dataIndex:"ordDateTime"},
		{header:"ִ��ʱ��",dataIndex:"excDateTime"},
		{header:"����",dataIndex:"name"},
		{header:"����",dataIndex:"dosage"},
		{header:"��λ",dataIndex:"unit"},
		{header:"Ƶ��",dataIndex:"frequency"},
		{header:"�Ƴ�",dataIndex:"period"},
		{header:"����",dataIndex:"category"},
		{header:"״̬",dataIndex:"status"},
		{header:"������",dataIndex:"prescriptionID"},
		{header:"ҩƷ״̬",dataIndex:"pharmStatus"},
		{header:"���ҽ��",dataIndex:"auditor"}
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
	         title: '�ʿ���ʾ',
                 autoScroll: false
                }),
		new Ext.BoxComponent({
		 id: 'epredit',
		 el: 'frameepredit',
	         title: '������д',
                 autoScroll: false
                }),
		new Ext.BoxComponent({
		 id: 'eprlist',
		 el: 'frameeprlist',
	         title: '�����б�',
                 autoScroll: false
                }),
		new Ext.BoxComponent({
		 id: 'eprbrowser',
		 el: 'frameeprbrowser',
	         title: '�������',
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
                    title:'����ҽ��',
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