
var unitsUrl = 'dhcst.mbccolldrugaction.csp';
var gParentId=""
var Gnode
var NumberI='10' //��ҩ
Ext.onReady(function() {
	var gUserId = session['LOGON.USERID'];
	var gUserName=session['LOGON.USERNAME']
	Ext.QuickTips.init();// ������Ϣ��ʾ
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
var BarCode = new Ext.form.TextField({
		fieldLabel : '����',
		id : 'BarCode',
		name : 'BarCode',
		anchor : '90%',
		width : 140,
		listeners : {
			specialkey : function(field, e) {
			var keyCode=e.getKey();
			if ( keyCode== Ext.EventObject.ENTER) {
			    RecSave();
			}
		    }
		}
		});	

  		// ��ӡ��ť
		var PrintBT = new Ext.Toolbar.Button({
					id:'PrintBT',
					text : '��ӡ',
					tooltip : '�����ӡ',
					width : 70,
					height : 30,
					iconCls : 'page_print',
					handler : function() {
	                                 var DDateTime=GetDate();
	                                  var DateStr=DDateTime.split("^")
	                                  var Ddate=DateStr[0]
	                                  var Dtime=DateStr[1]
	                                   //PrintRec(DhcIngr,gParam[13]);
	                                   PrintUpdate(Ddate,Dtime)	                                   
					}
				});
function GetDate()
{
 var myDate = new Date(); 
 var year=myDate.getFullYear(); //��ȡ���������(4λ,1970-????)
 var month=myDate.getMonth(); //��ȡ��ǰ�·�(0-11,0����1��)
 var date=myDate.getDate();   //��ȡ��ǰ��(1-31)
 var hours=myDate.getHours();  //��ȡ��ǰСʱ��(0-23)
 var minutes=myDate.getMinutes(); //��ȡ��ǰ������(0-59)
 var seconds=myDate.getSeconds(); //��ȡ��ǰ����(0-59)
 var month=month+1
 var ymd=year+"-"+month+"-"+date
 var hms=hours+":"+minutes+":"+seconds
 return  ymd+"^"+hms
}
	// ����һ����д

	var Tree = Ext.tree;

	// ������ڵ��Loader

	var treeloader = new Tree.TreeLoader({

				dataUrl : unitsUrl + '?action=ListTreeData'

			});
	// ���һ���������

	var treepanel = new Tree.TreePanel({

				//el : 'tree-panel',// 
				region : 'west',
				title : '������ͼ',
				width : 300,
				//minSize : 180,
				//maxSize : 250,
				split : true,
				//autoHeight : true,
				height : 300,
				frame : true,
				autoScroll : true,
				enableDD : false,
				containerScroll : true,
				border : true,
				animate : true,  
                            collapsible: true,           //�Ƿ�����۵� 
                             
				//rootVisible:false,
				loader : treeloader//,
				//tbar:[AddRootBT, '-', AddBT, '-', UpdBT]

			});

	// �첽���ظ��ڵ�
	var rootnode = new Tree.AsyncTreeNode({

				text : '����',

				id : 'id',

				value : '0',

				level : '0',

				draggable : false , // ���ڵ㲻�����϶�

				expanded : true

			});

	// Ϊtree���ø��ڵ�

	treepanel.setRootNode(rootnode);

	// ��Ӧ����ǰ�¼�������node����

	treeloader.on('beforeload', function(treeloader, node) {
                            
				if (node == rootnode) {
					node.attributes.id = '0';
				}
				Gnode=node.attributes.id
				treeloader.baseParams = {
					id : node.attributes.id,
					level : node.attributes.level,
					Number:NumberI,
					UserI:gUserId,
					actiontype : 'load'
				}

			}, this);;


	// ������굥���¼�

	//treepanel.on('dblclick', treeClick);
//ɨ�豣��
function RecSave(){

        var prescno=Ext.getCmp("BarCode").getValue();
		var mask=ShowLoadMask(Ext.getBody(),"���������Ժ�...");
		 Ext.Ajax.request({
			 url: unitsUrl+'?action=RecSave',
			 params: {Prescno:prescno,User:gUserId},
			 failure: function(result, request) {
			     mask.hide();
			     Msg.info("error", "������������!");
			    },
			  success: function(result, request) {
					var jsonData = Ext.util.JSON.decode( result.responseText );
					 mask.hide();
					 
					if (jsonData.success=='true') {
						Msg.info("success", "����ɹ�!");
						
                        ChildGridDs.removeAll();
                        ChildGridDs.setBaseParam("locId",'0')
                        ChildGridDs.setBaseParam("Number",NumberI)
                        ChildGridDs.setBaseParam("User",gUserId)
                        ChildGridDs.load();
					}else if (jsonData.info=="-10"){
					     Msg.info("warning", "������Ϊ��!");
					}
					 else if (jsonData.info=="-20"){
					     Msg.info("warning", "�Ǵ��崦��!");
				       }
					 else if (jsonData.info=="-30"){
					      Msg.info("warning", "�ô�����ɨ��!")
					}
					else if (jsonData.info=="-40"){
					      Msg.info("warning", "�����Ų�����!")
					}
					else if (jsonData.info=="-50"){
					      Msg.info("warning", "�ô�������δ��ҩ!")
					}
					else{
					      Msg.info("error", "����ʧ��!");
						
					}
				},
				scope: this
			});
 	 Ext.getCmp("BarCode").setValue("");
        Ext.getCmp("BarCode").focus();
	treepanel.getRootNode().reload();
	}
function PrintUpdate(Ddate,Dtime){
    if (ChildGrid.getStore().getCount()==0)
    {  Msg.info("warning", "��ѡ��Ҫ��ӡ������!");
	   return;}
	var locid=Gnode
    if (locid=="") {	
          Msg.info("warning", "��ѡ��Ҫ��ӡ������!");
	   return;} 	
    var loadMask=ShowLoadMask(document.body,"������...");
     Ext.Ajax.request({
			 url: unitsUrl+'?action=PrintUpdate',
			 params: {locid:locid,User:gUserId,Number:NumberI,Ddate:Ddate,Dtime:Dtime},
			 success : function(result, request) {
			 		 var jsonData = Ext.util.JSON.decode(result.responseText);
					 loadMask.hide();
					 if (jsonData.success == 'true') {
						 Msg.info("success", "���³ɹ�!");
						 PrintJYReg(locid,gUserId,Ddate,Dtime,Ddate,Dtime,"","20",gUserName)
						 ChildGridDs.removeAll();
						 ChildGridDs.setBaseParam("locId",'0')
						 ChildGridDs.setBaseParam("Number",NumberI)
						 ChildGridDs.setBaseParam("User",gUserId)
						 ChildGridDs.load();
					  }
			          else {Msg.info("success", "����ʧ��!");}
    	
	                 },
	           scope: this
     })
	treepanel.getRootNode().reload();
    }
   function addNewRow() {
	var record = Ext.data.Record.create([
                    
                    {
			  name : 'MBCId',
			  type : 'string'
			},
                    {
			  name : 'PatLoc',
			  type : 'string'
			}, {
			  name : 'PatNo',
			  type : 'string'
			}, {
			  name : 'PatName',
			  type : 'string'
		       }, {
			  name : 'Prescno',
			  type : 'string'
			}, {
			  name : 'State',
			  type : 'string'
		       }
	]);
					
   }
    
    var ChildGridProxy= new Ext.data.HttpProxy({url:unitsUrl+'?action=GetChild',method:'GET'});
    var ChildGridDs = new Ext.data.Store({
	proxy:ChildGridProxy,
    reader:new Ext.data.JsonReader({
        root:'rows'
    }, [      {name:'MBCId'},
		{name:'PatLoc'},
		{name:'PatNo'},
		{name:'PatName'},
		{name:'Prescno'},
		{name:'State'}
	]),
	pruneModifiedRecords:true,
    remoteSort:false
    });
    //ģ��
    var ChildGridCm = new Ext.grid.ColumnModel([
	 new Ext.grid.RowNumberer(),
	 {
        header:"rowid",
        dataIndex:'MBCId',
        width:100,
        align:'left',
        sortable:true,
        hidden:true
	 }, {
        header:"����",
        dataIndex:'PatLoc',
        width:100,
        align:'left',
        sortable:true
	 },{
        header:"�ǼǺ�",
        dataIndex:'PatNo',
        width:200,
        align:'left',
        sortable:true
	 },{
        header:"��������",
        dataIndex:'PatName',
        width:200,
        align:'left',
        sortable:true
	 },{
        header:"������",
        dataIndex:'Prescno',
        width:200,
        align:'left',
        sortable:true
	 },{
        header:"״̬",
        dataIndex:'State',
        width:200,
        align:'left',
        sortable:true
	 }
	 
	 ])
    ChildGrid = new Ext.grid.EditorGridPanel({
	store:ChildGridDs,
	cm:ChildGridCm,
	trackMouseOver:true,
	stripeRows:true,
	//sm:new Ext.grid.CellSelectionModel({}),
	sm : new Ext.grid.RowSelectionModel({
		 singleSelect : true
		 }),
	loadMask:true,
    tbar:[BarCode,"����",'-',PrintBT],
	clicksToEdit:1
    });  
    var ChildPanel = new Ext.Panel({
		title:'��ҩ����',
		activeTab: 0,
		region:'center',
		layout:'fit',
		items:[ChildGrid]                                 
	});        	  
        
    treepanel.on('click',function(node,e){
	ChildGridDs.proxy = new Ext.data.HttpProxy({url:unitsUrl+'?action=GetChild&locId='+node.attributes.id+'&Number='+NumberI+'&UserI='+gUserId,method:'GET'});
	ChildGridDs.load();
   });  
	var por = new Ext.Viewport({

				layout : 'border', // ʹ��border����

				items : [treepanel,ChildPanel]

			});



});
