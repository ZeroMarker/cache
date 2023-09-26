Ext.QuickTips.init();


var url = '../web.eprajax.epsodeListGrid.cls?patientID='+ patientID + '&admType=' + admType + '&argDiagnosDesc=' + argDiagnosDesc;
//ȡ�þ����б�����Դ�����д����admType��argDiagnosDesc��Ϊ�գ���ȡȫ������
function GetGridStore()
{
	var store = new Ext.data.JsonStore({
        //url:'../web.eprajax.epsodeListGrid.cls?patientID='+ patientID ,
        url:url,
        //url:'http://172.21.21.31/trakcarelive/trak/web/csp/web.eprajax.epsodeListGrid.cls?patientID=424'
        fields: [
           {name: 'AdmDate'},
           {name: 'AdmType'},
           {name: 'Diagnosis'},
           {name: 'CurDept'},
           {name: 'MainDoc'},
           {name:'DisDate'},
           {name:'EpisodeID'}
        ]
    });
    
    return store;
}

//���������б��Grid
function getGridPanel()
{
    var store = GetGridStore();
    store.load();
    
    var sm = new Ext.grid.CheckboxSelectionModel({
        listeners:{
           // 'rowdeselect':function(cm,index,record)
            //{
				//debugger;
				//alert(index);
                //ȡ��ѡ�еĶ��󴥷����¼�
                //var dom = record.data;//ȡ��ѡ�еĶ���
            //},
            'rowselect':function(record,index,e)
            {
                //ѡ�ж��󴥷����¼�
                
                //var dom1 = record.data;//ѡ�еĶ���
                //alert(dom1["AdmDate"]);
                
                episodeID = grid.getStore().getAt(index).data['EpisodeID'];
                //browser();
                //alert(episodeID);
            }
        }
    });
    
    var cm = new Ext.grid.ColumnModel([sm,
        {header:'��������', dataIndex:'AdmDate', width:70},
        {header:'����', dataIndex:'AdmType', width:40,renderer:gettype},
        {header:'���', dataIndex:'Diagnosis'},
        {header:'����', dataIndex:'CurDept', width:75},
        {header:'����ҽ��', dataIndex:'MainDoc', width:60},
        {header:'��Ժ����', dataIndex:'DisDate',width:70}
    ]);
    
    var grid = new Ext.grid.GridPanel({
        id:'episodeGrid',
        layout:'fit',
        border:false,
        store:store,
        cm:cm,
        sm:sm,
        forceFit:true,
        autoScroll:true,
        frame:true,
        tbar:[
			'��������',
			'-',
			{
				id:'cboAdmType',
				//emptyText:'��������',
				width:80,
				resizable: false,
				xtype :'combo',
				valueField:'returnValue',
				displayField:'displayText',
				readOnly: true,
				triggerAction : 'all', 
				mode: 'local',
				store: new Ext.data.SimpleStore({
					fields:['returnValue','displayText'],
					data:[['','ȫ��'],['O','����'],['E','����'],['I','סԺ']]
				})
			},
			//'-',
			{
				id:'txtArgDiagnosDesc',
				emptyText:'�������',
                xtype: 'textfield',
                //enable:false,
                //width: 100
                width:0	
			},
			'-',
			//'->',
			{id:'btnconfirm',text:'ȷ��',cls: 'x-btn-text-icon' ,icon:'../scripts/epr/Pics/btnConfirm.gif',pressed:false,handler:confirm},
			'-',
			{id:'btncompare',name:'btncompare',text:'�Ա�',cls: 'x-btn-text-icon' ,icon:'../scripts/epr/Pics/browser.gif',pressed:false}
		]
    });
    
    return grid;
}


var grid = getGridPanel();
var frmMainContent = new Ext.Viewport({
	id: 'viewport',
	shim: false,
	animCollapse: false,
	constrainHeader: true, 
	margins:'0 0 0 0',           
	layout: "border",  
	border: false,              
	items: [{
		border:false,
		region:'west',
		layout:'fit',
		split: true,
		collapsible: true,  
		width:300,
		items:grid
	},{
		border: false,
		region: "center",
		layout: "border",
		items: [{
			border: false,
			region: "center",
			layout: "fit",
			html:'<iframe id="frmTabPanel" name="frmTabPanel" style="width:100%;height:100%" src="epr.newfw.epsodeListTabPanel.csp?patientID=' + patientID + '&episodeID="'+ episodeID +'"></iframe>'
		}]
    }]
});

grid.on('rowdblclick',function(g,index,e)
{
	//debugger;
	episodeID = g.getStore().getAt(index).data['EpisodeID'];
	browser();
})

//������Աȡ��������Աȴ���

var btn = Ext.getCmp('btncompare');
var win;
btn.on('click',function(){
	if(!win)
	{
		win = new Ext.Window({
			id:'compareWin',
			layout:'fit',		//�Զ���ӦWindow��С 
			width:1000,
			height:600, 
			title:'�����Ա�',
			//animCollapse:true,
			closeAction:'hide',
			animateTarget: 'btn',
			//collapsible: true,
			//maximizable:false,
			raggable: true,	//�����϶�
			modal:true,			//�ڵ������ҳ��
			resizable:true,	//���ô��ڴ�С
			items: [
				new Ext.Panel({
					id:'comparePanel',
					layout:'fit',
					border:false,
					html:'<iframe id="frmCompare" style="width:100%; height:100%" src="epr.newfw.epsodeListComparePhoto.csp"></iframe>'
				})
			]//,
			//buttons:[{
					//text:"�ر�",
					//handler:function(){
						//win.hide();
					//}
			//}]
		}); 
	}
	win.show(this);
	compare();
});

