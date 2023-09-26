//PMP.ObLogging.js
var userId = session['LOGON.USERID'];
var gGroupId=session['LOGON.GROUPID'];
var gLocId=session['LOGON.CTLOCID'];
var username=session['LOGON.USERNAME'];
//var objAudit = ExtTool.StaticServerObject("web.PMP.Common");
Ext.onReady(function(){ 
    Ext.QuickTips.init();
    Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
   // ObStore.removeAll();
    //ObStore.load({params:{InPut:userId}}); 
// create the Data Store
ObUserstore.load();
ObIpmlboxstore.load();
AdjunctObStore.load();
store.load();

    // pluggable renders
    function renderTopic(value, p, record){
	    strRet = "<div style='color:#8968CD;font-weight:bold'>"+ value + '<br/>'+record.data.forumtitle+"</div>";
	    return strRet

	    
    }
    function renderTopic1(value, p, record){
        return String.format(
                '<b><a target="_blank">{0}</a></b><a target="_blank">{1} Forum</a>',
                //'<b><a href="http://extjs.com/forum/showthread.php?t={2}" target="_blank">{0}</a></b><a href="http://extjs.com/forum/forumdisplay.php?f={3}" target="_blank">{1} Forum</a>',  ��������
                value, record.data.forumtitle, record.id, record.data.forumid);
    }
    function renderLast(value, p, r){
        return String.format('{0}<br/>by {1}', value, r.data['lastposter']); //value.dateFormat('M j, Y, g:i a')
    }

    var ObGrid = new Ext.grid.GridPanel({
        width:410,
        height:610,
        //title:'ExtJS.com - Browse Forums',
        store: store,
        trackMouseOver:false,
        disableSelection:true,
        loadMask: true,

        // grid columns
        columns:[{
            id: 'topic', // id assigned so we can apply custom css (e.g. .x-grid-col-topic b { color:#333 })
            header: "����",
            dataIndex: 'title',
            width: 220,
            renderer: renderTopic,
            sortable: true
        },{
            header: "������",
            dataIndex: 'author',
            width: 100,
            hidden: true,
            sortable: true
        },{
            header: "�������",
            dataIndex: 'ObSolution',
            width: 100,
            hidden: true,
            sortable: true
        },{
            header: "����",
            dataIndex: 'ObRowid',
            width: 70,
            align: 'right',
            hidden: true,
            sortable: true
        },{
            id: 'last',
            header: "������Ϣ",
            dataIndex: 'ObDate',
            width: 150,
            renderer: renderLast,
            sortable: true
        }],

        // customize view config
        sm:new Ext.grid.RowSelectionModel({singleSelect:true}),
        viewConfig: {
            forceFit:true,
            enableRowBody:true,
            showPreview:true,
            getRowClass : function(record, rowIndex, p, store){
                if(this.showPreview){
                    p.body = '<p><br/>'+record.data.ObMenu+'</p>'+'<br/>';
                    return 'x-grid3-row-expanded';
                }
                return 'x-grid3-row-collapsed';
            }
        },
        tbar:Obtbar,
        // paging bar on the bottom
        bbar: new Ext.PagingToolbar({
            pageSize: 25,
            store: store,
            displayInfo: true,
            displayMsg: '{0} - {1} of {2}',
           // emptyMsg: "No rows to display",
            items:[
                '-', {
                pressed: true,
                enableToggle:true,
                text:'��ʾ����',
                cls: 'x-btn-text-icon details',
                toggleHandler: function(btn, pressed){
                    var view = ObGrid.getView();
                    view.showPreview = pressed;
                    view.refresh();
                }
            }]
        }),
        listeners : {// ��񵥻��¼�  
		"rowclick":function(ObGrid, rowIndex,columnIndex,e) {
		 var data=ObGrid.getStore().getAt(rowIndex).data;
		 OjrowclickS(data);
		}}
    });

    // render it
   // grid.render('topic-grid');
    
    // trigger the data store load
    store.load({params:{start:userId, limit:25}});

var Type=[[1,"������¼"],[2,"������"],[3,"С֪ʶ"],[4,"�����¼"],[5,"�绰����"]];   
var proxyR=new Ext.data.MemoryProxy(Type);
var TypeR=Ext.data.Record.create([
    //Type�ṹ name��type��ʾÿһ�е����ƺ��������� mapping����ֵ������Ԫ�ص�ӳ���ϵ
     {name:"Typeid",type:"int",mapping:0},
     {name:"Typename",type:"string",mapping:1}
 ]);
var reader=new Ext.data.ArrayReader({},TypeR);
var Typestore=new Ext.data.Store({
   proxy:proxyR,
   reader:reader
  // autoLoad:true
  });
 Typestore.load();
var Typecombobox=new Ext.form.ComboBox({
    id:'Typecombobox',
	fieldLabel:'��������',
    triggerAction:"all",         //�Ƿ����Զ���ѯ����
    store:Typestore,               //��������Դ
    width:150,
    displayField:"Typename",     //����ĳһ���߼�������Ϊ��ʾֵ
    valueField:"Typeid",                 //����ĳһ���߼�������Ϊʵ��ֵ
    mode:"local",                   //����������Ա�����local �������Զ����remoteĬ��Ϊremote
    emptyText:"��ѡ������",    //û��ѡ��ʱ���Ĭ��ֵ
    value:'1'  
  });
 //������ѡ��
 var ObIpm = new Ext.ux.form.LovCombo({
			id:'ObIpm',
			fieldLabel: '��������',
			valueField: 'RowId',
			displayField:'Description',
			emptyText:'��ѡ������...',
			triggerAction:'all',
			//allowBlank: false,
			width:150,
			listWidth : 150,
			store:ObIpmlboxstore,
            //minChars: 1,
			pageSize: 10,
			//selectOnFocus:true,
			//forceSelection:'true',
			editable:true			
		});


var Obtitle=new Ext.form.TextField({
			id:"Obtitle",
			width : 150,
			fieldLabel:'��¼��ǩ',
			emptyText: '��������ӱ�ǩ'
			});
var ROWID=new Ext.form.TextField({
			id:"ROWID",
			width : 150
			,hidden:true
			});
var ObMaintitle=new Ext.form.TextField({
			id:"ObMaintitle",
			width : 630,
			fieldLabel:'��¼����',
			emptyText: '��������ӱ���'
			});
var ObDate=new Ext.form.DateField({
			id:"ObDate",
			width : 150,
			fieldLabel:'��������',
			enableKeyEvents : true,
	        emptyText:'���������',
	        format:'Y-m-d',
	        value:new Date().add(Date.DAY,0)
	         // ,disabledDays:[0,6]   //��Чʱ��
			});
var ObUpDate=new Ext.form.DateField({
			id:"ObUpDate",
			width : 150,
			fieldLabel:'��������',
			enableKeyEvents : true,
	        emptyText:'���������',
	        format:'Y-m-d',
	        value:new Date().add(Date.DAY,0)
	         // ,disabledDays:[0,6]   //��Чʱ��
			});
var ObUser=new Ext.form.ComboBox({
	id:"ObUser",
	width : 150,
	fieldLabel:"�����û�",
	emptyText:'������ѡ��',
	name:'ObUser',
	mode : 'local',
	store : ObUserstore,   //��ȡ����
    valueField : 'RowId',   //��ֵ̨
    displayField : 'Description',   //������ʾֵ
    valueNotFoundText : '',
    value:userId,
    params:{InPut:'ObUser'}   //��β���ֵ
	});
var ObContent=new Ext.Panel({
	//renderTo:Ext.getBody(),
	//title:'�����¼',
	//width:700,
	height:145,
	autoHeight : true,
    //autoWidth : true,
	//autoHeight : true,
	layout:'column',
	Resizable:'yes',
	items:[{xtype:'htmleditor',id:'ObContenti',width:700}]
	});
var ObSolution=new Ext.Panel({
	//renderTo:Ext.getBody(),
	//title:'�������',
	//width:700,
	height:145,
	autoHeight : true,
    autoWidth : true,
	layout:'column',
	Resizable:'yes',
	items:[{xtype:'htmleditor',id:'Solutioni',width:700}]
	});
var AdjunctObnm=new Ext.grid.RowNumberer();
var AdjunctObsm=new Ext.grid.CheckboxSelectionModel(); 
var AdjunctObCm=new Ext.grid.ColumnModel([AdjunctObnm,
	  {
	    header:'AdjunctObRowid',
			dataIndex:'AdjunctObRowid',
			width:60,
			sortable:true,
			hidden : true
		},{
		  header:'�ļ�����',
			dataIndex:'AdjunctObName',
			width:220,
			sortable:true
		},{
		  header:'�ϴ�ʱ��',
			dataIndex:'AdjunctObTime',
			width:140,
			sortable:true
		},{
		  header:'�ϴ���',
			dataIndex:'AdjunctObUser',
			width:140,
			sortable:true
		},{
		  header:'�ϴ�����',
			dataIndex:'AdjunctObType',
			width:120,
			sortable:true
		},{
		  header:'ftp�ļ�����',
			dataIndex:'AdjunctFTPObName',
			width:220,
			hidden:true,
			sortable:true
		},{
		  header:'����',
			dataIndex:'AdjunctObdetail',
			width:60,
			sortable:true,
			xtype:'actioncolumn',
			items:[{
			      xtype:"tbfill"
			      },{
			      id:'AdjunctButton',
			      hidden:function(AdjunctObGrid, rowIndex, colIndex){
			      var rec = AdjunctObGrid.getStore().getAt(rowIndex);
			      return true;
			      },
            icon:'../scripts/Pmp/Image/download1.gif',pressed:true,tooltip: "����",handler:function(AdjunctObGrid, rowIndex, colIndex){
            var rec = AdjunctObGrid.getStore().getAt(rowIndex);
			var data=rec.data;
            if (Ext.getCmp("ROWID").getValue()!=""){
			var FujianName=data.AdjunctObName;
			var AdjunctFTPObName=data.AdjunctFTPObName;
			BrowseFolder(FujianName);
			var lenth=VerStrstr.split("\\").length
			if (lenth>1){
			var ret=FileDownload(VerStrstr,AdjunctFTPObName,"DownLoad");
			if (ret==true){
			var ip=getIpAddress();
			tkMakeServerCall("DHCPM.Application.PMApply","PMPDownloads",data.AdjunctObRowid,"PMP_ImprovementAdjunct",ip);
			Ext.MessageBox.alert('Status','���سɹ���·����'+VerStrstr);
			}
			else{
			Ext.Msg.show({
	          title : '��ܰ��ʾ',
			  msg : '����ʧ��',
			  icon : Ext.Msg.WARNING,
			  buttons : Ext.Msg.OK
			  });
	         return;
			};
			}
			}
			else{
			 Ext.Msg.show({
	          title : '��ܰ��ʾ',
			  msg : '��������Ϊ�ϴ�',
			  icon : Ext.Msg.WARNING,
			  buttons : Ext.Msg.OK
			  });
	         return;
			};
			}}]}]);
	var AdjunctObToolBar=new Ext.PagingToolbar({
		id:'AdjunctObToolBar',
		store:AdjunctObStore,
		displayInfo:true,
		pageSize:5,
		displayMsg:"��ǰ��¼{0}---{1}��  ��{2}����¼",
		emptyMsg:"û������",
		firstText:'��һҳ',
		lastText:'���һҳ',
		prevText:'��һҳ',
		refreshText:'ˢ��',
		nextText:'��һҳ',
		items:[
            '-', {
            pressed: true,
            enableToggle:true,
            text:'��Ӹ���',
            icon:'../scripts/Pmp/Image/file-add.gif',
            cls: 'x-btn-text-icon details',
            toggleHandler: function(){
	            AddAdjunct();
	            }
            }]		
	});
	var AdjunctObGrid=new Ext.grid.GridPanel({
		id:'AdjunctObGrid',
		height : 170,
		title:'�����б�',
		store:AdjunctObStore,
		loadMask:true,
		cm:AdjunctObCm,
		params:{InPut:'InPut'},
		sm:new Ext.grid.RowSelectionModel({singleSelect:true}),
		bbar:AdjunctObToolBar
	});
var Obpanal=new Ext.form.FormPanel({
			  labelAlign:'left',    
              autoHeight : true,
              //autoWidth : true,
              //bodyStyle:'margin-left:10',
              buttonAlign:'center',  
              frame:true,
              layout:"form",
              hideLabel:false,
              labelWidth:60,
              items:[{layout:'column',
                     items:[{  
                            columnWidth:.33,  
                            layout:'form',    
                            items:Typecombobox 
                           },{  
                            columnWidth:.33,  
                            layout:'form',    
                            autoHeight:true,    
                            items:ObDate
                           },{  
                            columnWidth:.33,  
                            layout:'form',    
                            autoHeight:true, 
                            items:ObUpDate}]
                     },{
					 layout:'column',
                     items:[{  
                            columnWidth:.33,  
                            layout:'form',    
                            items:Obtitle 
                           },{  
                            columnWidth:.33,  
                            layout:'form',    
                            autoHeight:true,    
                            items:ObIpm
                           },{  
                            columnWidth:.33,  
                            layout:'form',    
                            autoHeight:true,    
                            items:ObUser
                           }]
                     },{
	                 layout:'column',
                     items:[{    
                           layout:'form', 
                           columnWidth:1,						   
                           items:ObMaintitle}]
                    },
                    ObContent,
                    ObSolution,
                    AdjunctObGrid]
              });
    ChartInfoAddFun();                     
function ChartInfoAddFun() {
var pnNorth=new Ext.Panel({  
    id:'pnNorth',  
    autoWidth:true,  
    heigth:80,  
    frame:true,  
    region:'north',  
    html:'���������Ŀ����--������¼'  
});  
var pnWest=new Ext.Panel({  
    id:'pnWest',  
    title:'ȫ���ʼ�',  
    width:400, 
    //autoWidth:true	
    heigth:'auto',  
    split:true,//��ʾ�ָ���  
    region:'west',  
    collapsible:true,
    items:ObGrid 
      
});  
var pnCenter=new Ext.Panel({  
    id:'pnCenter',  
    //title:btnRecSubmit,   //"<div class='controlBtn' >"+"<a href='javascript:void({0});' onclick='javscript:RecInsert'>�����¼</a>"+"</div>",  
    width:400,  
	tbar:[{text:"<img SRC='../scripts/Pmp/Image/save.gif'>�����¼",tooltip: "�����¼",handler:function(){
	//Ext.MessageBox.alert("���ǰ�ť1","����ͨ����ť1���������ĵ�����");
	var ROWIDvalue=Ext.getCmp("ROWID").getValue();
	var Obtitlevalue=Ext.getCmp("Obtitle").getValue();
	var ObMaintitlevalue=Ext.getCmp("ObMaintitle").getValue();
    var ObDatevalue=Ext.getCmp("ObDate").getValue();
    var ObUpDatevalue=Ext.getCmp("ObUpDate").getValue();
	//��ʼ
	var ObIpmValue=Ext.getCmp("ObIpm").getValue();
	var ObUservalue=Ext.getCmp("ObUser").getValue();
	var AddValue=ObIpmValue+"^"+ObUservalue;
    //Ext.getCmp("ObDate").getValue();
    //alert(data.ObDate);
	if(ObDatevalue!=""){
	ObDatevalue=ObDatevalue.format('Y-m-d');
	};
	if(ObUpDatevalue!=""){
	ObUpDatevalue=ObUpDatevalue.format('Y-m-d');
	};
    var ObContentivalue=Ext.getCmp("ObContenti").getValue();
    //Solutioni
    var Solutionivalue=Ext.getCmp("Solutioni").getValue();
	var Typecomboboxvalue=Ext.getCmp("Typecombobox").getValue();
	var demRowIDList1=""
	var listret=tkMakeServerCall("web.PMP.Common","AdjunctIP");
	if (AdjunctObStore.getCount()>0){
	var JLGDR="Y";
	for(var batchNum = 0; batchNum < AdjunctObStore.getCount(); batchNum++){
	var objbatch = AdjunctObStore.getAt(batchNum);
	var fujianname=objbatch.get("AdjunctObName")
	var ret=FileDownload(fujianname,"","UpLoad");
	var returnret=ret.split("//")[0];
	if (returnret=="true"){
	var returnname=ret.split("//")[1];
	if (demRowIDList1!=""){
	demRowIDList1=demRowIDList1+"@@"+objbatch.get("AdjunctObType")+"^"+objbatch.get("AdjunctObName")+"^"+returnname;
	}
	else {
	demRowIDList1=objbatch.get("AdjunctObType")+"^"+objbatch.get("AdjunctObName")+"^"+returnname;
	};
	}
	};
	}
	else {
	var JLGDR="N";
	};
	var ip=getIpAddress();
	var Input=ROWIDvalue+"^"+Obtitlevalue+"^"+ObMaintitlevalue+"^"+ObDatevalue+"^"+ObUpDatevalue+"^"+Typecomboboxvalue+"^"+JLGDR+"^"+objbatch.get("AdjunctObType");
	var AddUpdateObRet=tkMakeServerCall("web.PMP.Common","AddUpdateOb",Input,ObContentivalue,Solutionivalue,demRowIDList1,ip,AddValue);
	if (AddUpdateObRet=="1"){
	Ext.MessageBox.alert('��ʾ',"OK��");
	store.load();
	}
	else {
	Ext.Msg.show({
	          title : '��ܰ��ʾ',
			  msg : '����ʧ��!������룺'+AddUpdateObRet,
			  icon : Ext.Msg.WARNING,
			  buttons : Ext.Msg.OK
			  });
	return;
	};
	}},ROWID],
    heigth:'auto',  
    //frame:true,
    split:true,//��ʾ�ָ���  
    region:'center',  
    //collapsible:true,
    items:Obpanal
}); 
var main=new Ext.Viewport({  
    layout:"border",  
    items:[  
        pnWest,  
        pnCenter  
    ]  
});  
}
})
function AddAdjunct(){
    BrowseFolder('');
	var Typecomboboxvalue=Ext.getDom("Typecombobox").value;
	var ObUpDatevalue=Ext.getDom("ObUpDate").value;
	if (VerStrstr!=""){
	if (Ext.getCmp("ROWID").getValue()!=""){
	var retupdile=FileDownload(VerStrstr,"","UpLoad");
	var retupdiletype=retupdile.split("//")[0];
	var retupdilename=retupdile.split("//")[1];
	if (retupdiletype=="true"){
	var ip=getIpAddress();
	var AdddujianRet=tkMakeServerCall("DHCPM.Application.PMApply","AdjunctAll",VerStrstr,retupdilename,Ext.getCmp("ROWID").getValue(),"Work",ip);
	if (AdddujianRet=="1"){
	var Plant = AdjunctObStore.recordType;
	var p = new Plant({AdjunctObRowid:'',AdjunctObName:VerStrstr,AdjunctObTime:ObUpDatevalue,AdjunctObUser:username,AdjunctObType:Typecomboboxvalue});
    //AdjunctObGrid.stopEditing();
    AdjunctObStore.insert(0, p);
	//alert(VerStrstr);
	//FileDownload('','1','UpLoad');
    //AdjunctObGrid.startEditing(0, 0);
	}
	}
	else{
	Ext.Msg.show({
	          title : '��ܰ��ʾ',
			  msg : '�ϴ�ʧ�ܣ�',
			  icon : Ext.Msg.WARNING,
			  buttons : Ext.Msg.OK
			  });
	return;
	};
	}
	else{
	var Plant = AdjunctObStore.recordType;
	var p = new Plant({AdjunctObRowid:'',AdjunctObName:VerStrstr,AdjunctObTime:ObUpDatevalue,AdjunctObUser:username,AdjunctObType:Typecomboboxvalue});
    //AdjunctObGrid.stopEditing();
    AdjunctObStore.insert(0, p);
	//alert(VerStrstr);
	//FileDownload('','1','UpLoad');
    //AdjunctObGrid.startEditing(0, 0);
	}
	}
	else {
	return;
	};
	
	}
function OjrowclickS(data){
//alert(data.ObRowid);ObRowid
Ext.getCmp("ROWID").setValue(data.ObRowid);
Ext.getCmp("Obtitle").setValue(data.forumtitle);
Ext.getCmp("ObMaintitle").setValue(data.title);
var detailInDateid = new Date(Date.parse(data.ObDate.replace(/-/g,"/")));  
Ext.getCmp("ObDate").setValue(detailInDateid.format('Y-m-d'));
Ext.getCmp("ObUpDate").setValue(detailInDateid.format('Y-m-d'));
//Ext.getCmp("ObDate").setValue(data.ObDate);
//alert(data.ObDate);
Ext.getCmp("ObContenti").setValue(data.ObMenu);
//Solutioni
Ext.getCmp("Solutioni").setValue(data.ObSolution);
//Ext.getCmp("ObUservalue").setValue(data.gluser);
AdjunctObStore.removeAll();
AdjunctObStore.load({params:{InPut:data.ObRowid,type:'select'}});
}