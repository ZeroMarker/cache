///PMP.DevelopControl.js ///����ƽ--2015-03-11--��Ŀ����--������Ա����

Ext.onReady(function() {
    var userId = session['LOGON.USERID'];
    var gGroupId=session['LOGON.GROUPID'];
    var gLocId=session['LOGON.CTLOCID'];
    Ext.QuickTips.init();
    Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
    SelectProduct.load(); 
    DevDetailStore.load();
    AddDetailType.load();
    DetailStore.load();
    ImListStore.load();
    ImListNStore.load();
    DetailAppraisalStore.load();
   
  //��������������б�
  var Imnm=new Ext.grid.RowNumberer();
	var Imsm=new Ext.grid.CheckboxSelectionModel(); 
	var ImListCm=new Ext.grid.ColumnModel([Imnm,
	  { header:'ImRowid',
			dataIndex:'ImRowid',
			width:60,
			sortable:true,
			hidden : true
	  },{
	    header:'����',
			dataIndex:'ImOperation',
			width:30,
			sortable:true,
			xtype:'actioncolumn',
			items:[{xtype:"tbfill"},{
      icon:'../scripts/Pmp/Image/album.gif',tooltip: "�鿴����",handler:function(ImListGrid, rowIndex, colIndex){
       var rec = ImListGrid.getStore().getAt(rowIndex);
       var ImRowidC=rec.get('ImRowid');
       var ImNameC=rec.get('ImName');
       var ImStatusC=rec.get('ImStatus');
       var ImCreatDateC=rec.get('ImCreatDate');
       var ImCreatUserC=rec.get('ImCreatUser');
       var ImCreateLocC=rec.get('ImCreateLoc');
       var ImCreateTelC=rec.get('ImCreateTel');
       var ImMenuC=rec.get('ImMenu');
       var ImSituationC=rec.get('ImSituation');
       var ImStandby3C=rec.get('ImStandby3');
       var ImEmergencyC=rec.get('ImEmergency');
       var ImCodeC=rec.get('ImCode');
       var ImTypeC=rec.get('ImType');
       var ImDegreeC=rec.get('ImDegree');
       ImListMenu(ImRowidC,ImNameC,ImStatusC,ImCreatDateC,ImCreatUserC,ImCreateLocC,ImCreateTelC,ImMenuC,ImSituationC,ImStandby3C,ImEmergencyC,ImCodeC,ImTypeC,ImDegreeC);
       }}]
     },{
      header:'��������',
			dataIndex:'ImName',
			width:150,
			sortable:true
		 },{
      header:'����״̬',
			dataIndex:'ImStatus',
			width:100,
			sortable:true
     },{
      header:'��������',
			dataIndex:'ImCreatDate',
			width:100,
			sortable:true
     },{
      header:'�����û�',
			dataIndex:'ImCreatUser',
			width:60,
			sortable:true
		 },{
      header:'��������',
			dataIndex:'ImCreateLoc',
			width:60,
			sortable:true
		},{
      header:'�����绰',
			dataIndex:'ImCreateTel',
			width:60,
			sortable:true
		 },{
      header:'�����˵�',
			dataIndex:'ImMenu',
			width:60,
			sortable:true
		},{
      header:'������״',
			dataIndex:'ImSituation',
			width:60,
			sortable:true
		},{
      header:'Ҫ��Ч��',
			dataIndex:'ImStandby3',
			width:100,
			sortable:true
		},{
      header:'�����̶�',
			dataIndex:'ImEmergency',
			width:60,
			sortable:true
		},{
      header:'�������',
			dataIndex:'ImCode',
			width:60,
			sortable:true
		},{
      header:'��������',
			dataIndex:'ImType',
			width:60,
			sortable:true
		},{
      header:'���س̶�',
			dataIndex:'ImDegree',
			width:60,
			sortable:true
		}]);
	var ImListToolBar=new Ext.PagingToolbar({
		id:'ImListToolBar',
		store:ImListStore,
		displayInfo:true,
		pageSize:20,
		displayMsg:"��ǰ��¼{0}---{1}��  ��{2}����¼",
		emptyMsg:"û������",
		firstText:'��һҳ',
		lastText:'���һҳ',
		prevText:'��һҳ',
		refreshText:'ˢ��',
		nextText:'��һҳ'		
	});
	var ImListGrid=new Ext.grid.GridPanel({
		id:'ImListGrid',
		height :360,
		store:ImListStore,
		loadMask:true,
		cm:ImListCm,
		params:{InPut:'InPut'},
		sm:new Ext.grid.RowSelectionModel({singleSelect:true}),
		bbar:ImListToolBar
	});
	
	//����δ��������б�
	var ImNnm=new Ext.grid.RowNumberer();
	var ImNsm=new Ext.grid.CheckboxSelectionModel(); 
	var ImListNCm=new Ext.grid.ColumnModel([ImNnm,
	  { header:'ImNRowid',
			dataIndex:'ImNRowid',
			width:60,
			sortable:true,
			hidden : true
	  },{
	    header:'����',
			dataIndex:'ImNOperation',
			width:30,
			sortable:true,
			xtype:'actioncolumn',
			items:[{xtype:"tbfill"},{
      icon:'../scripts/Pmp/Image/album.gif',tooltip: "�鿴����",handler:function(ImListNGrid, rowIndex, colIndex){
       var rec = ImListNGrid.getStore().getAt(rowIndex);
       var ImNRowidC=rec.get('ImNRowid');
       var ImNNameC=rec.get('ImNName');
       var ImNStatusC=rec.get('ImNStatus');
       var ImNCreatDateC=rec.get('ImNCreatDate');
       var ImNCreatUserC=rec.get('ImNCreatUser');
       var ImNCreateLocC=rec.get('ImNCreateLoc');
       var ImNCreateTelC=rec.get('ImNCreateTel');
       var ImNMenuC=rec.get('ImNMenu');
       var ImNSituationC=rec.get('ImNSituation');
       var ImNStandby3C=rec.get('ImNStandby3');
       var ImNEmergencyC=rec.get('ImNEmergency');
       var ImNCodeC=rec.get('ImNCode');
       var ImNTypeC=rec.get('ImNType');
       var ImNDegreeC=rec.get('ImNDegree');
       ImListMenu(ImNRowidC,ImNNameC,ImNStatusC,ImNCreatDateC,ImNCreatUserC,ImNCreateLocC,ImNCreateTelC,ImNMenuC,ImNSituationC,ImNStandby3C,ImNEmergencyC,ImNCodeC,ImNTypeC,ImNDegreeC);
       }}]
     },{
      header:'��������',
			dataIndex:'ImNName',
			width:150,
			sortable:true
		 },{
      header:'����״̬',
			dataIndex:'ImNStatus',
			width:100,
			sortable:true
     },{
      header:'��������',
			dataIndex:'ImNCreatDate',
			width:100,
			sortable:true
     },{
      header:'�����û�',
			dataIndex:'ImNCreatUser',
			width:60,
			sortable:true
		 },{
      header:'��������',
			dataIndex:'ImCreateLoc',
			width:60,
			sortable:true
		},{
      header:'�����绰',
			dataIndex:'ImNCreateTel',
			width:60,
			sortable:true
		 },{
      header:'�����˵�',
			dataIndex:'ImNMenu',
			width:60,
			sortable:true
		},{
      header:'������״',
			dataIndex:'ImNSituation',
			width:60,
			sortable:true
		},{
      header:'Ҫ��Ч��',
			dataIndex:'ImNStandby3',
			width:100,
			sortable:true
		},{
      header:'�����̶�',
			dataIndex:'ImNEmergency',
			width:60,
			sortable:true
		},{
      header:'�������',
			dataIndex:'ImNCode',
			width:60,
			sortable:true
		},{
      header:'��������',
			dataIndex:'ImNType',
			width:60,
			sortable:true
		},{
      header:'���س̶�',
			dataIndex:'ImNDegree',
			width:60,
			sortable:true
		}]);
	var ImListNToolBar=new Ext.PagingToolbar({
		id:'ImListNToolBar',
		store:ImListNStore,
		displayInfo:true,
		pageSize:20,
		displayMsg:"��ǰ��¼{0}---{1}��  ��{2}����¼",
		emptyMsg:"û������",
		firstText:'��һҳ',
		lastText:'���һҳ',
		prevText:'��һҳ',
		refreshText:'ˢ��',
		nextText:'��һҳ'		
	});
	var ImListNGrid=new Ext.grid.GridPanel({
		id:'ImListNGrid',
		height : 360,
		store:ImListNStore,
		loadMask:true,
		cm:ImListNCm,
		params:{InPut:'InPut'},
		sm:new Ext.grid.RowSelectionModel({singleSelect:true}),
		bbar:ImListNToolBar
	});
	
   //����������Ա������Ϣ 
  var Devnm=new Ext.grid.RowNumberer();
	var Devsm=new Ext.grid.CheckboxSelectionModel(); 
	var DetailCm=new Ext.grid.ColumnModel([Devnm,
	  { header:'DevRowiddetail',
			dataIndex:'DevRowiddetail',
			width:60,
			sortable:true,
			hidden : true
	  },{
	    header:'DevRowid',
			dataIndex:'DevRowid',
			width:60,
			sortable:true,
			hidden : true
		},{
		  header:'����',
			dataIndex:'Devdetail',
			width:60,
			sortable:true,
			xtype:'actioncolumn',
			items:[{xtype:"tbfill"},{
      icon:'../scripts/Pmp/Image/edit3.gif',tooltip: "��������",handler:function(DetailGrid, rowIndex, colIndex){
       var rec = DetailGrid.getStore().getAt(rowIndex);
       var Subdetailname=rec.get('DevNamedetail');
       var SubdetailRowid=rec.get('DevRowid');
       var SubdetailTel=rec.get('DevTeldetail');
       var SubdetailEmail="";
       var SubdetailProduct=rec.get('DevProductdetail');
       var SubdetailInDate="";
       var SubdetailInTime="";
       var SubdetailOutDate="";
       var SubdetailOutTime="";
       var SubdetailBusine=rec.get('DevMenudetail');
       var SubRowid=rec.get('DevRowiddetail');
       var SubType=rec.get('DevUpTypedetail');
       var type="Update";
       AddDevDetail(SubdetailRowid,SubRowid,Subdetailname,SubdetailTel,SubdetailEmail,SubdetailProduct,SubdetailInDate,SubdetailInTime,SubdetailOutDate,SubdetailOutTime,SubdetailBusine,SubType,type);
      }}]
		},{
		  header:'����',
			dataIndex:'DevNamedetail',
			width:60,
			sortable:true
		},{
		  header:'��ϵ��ʽ',
			dataIndex:'DevTeldetail',
			width:100,
			sortable:true
		},{
		  header:'��Ʒ��',
			dataIndex:'DevProductdetail',
			width:100,
			sortable:true
		},{
		  header:'��������',
			dataIndex:'DevUpDatedetail',
			width:100,
			sortable:true
		},{
		  header:'����ʱ��',
			dataIndex:'DevUpTimedetail',
			width:100,
			sortable:true
		},{
		  header:'�����û�',
			dataIndex:'DevUpUserdetail',
			width:100,
			sortable:true
		},{
		  header:'��������',
			dataIndex:'DevUpTypedetail',
			width:60,
			sortable:true
		},{
		  header:'��������',
			dataIndex:'DevMenudetail',
			width:200,
			sortable:true
		}]);
	var DetailToolBar=new Ext.PagingToolbar({
		id:'DetailToolBar',
		store:DetailStore,
		displayInfo:true,
		pageSize:20,
		displayMsg:"��ǰ��¼{0}---{1}��  ��{2}����¼",
		emptyMsg:"û������",
		firstText:'��һҳ',
		lastText:'���һҳ',
		prevText:'��һҳ',
		refreshText:'ˢ��',
		nextText:'��һҳ'		
	});
	var DetailGrid=new Ext.grid.GridPanel({
		id:'DetaiGrid',
		height : 160,
		store:DetailStore,
		loadMask:true,
		cm:DetailCm,
		params:{InPut:'InPut'},
		sm:new Ext.grid.RowSelectionModel({singleSelect:true}),
		bbar:DetailToolBar
	});
	
  var cb = new Ext.grid.RowSelectionModel({     
    singleSelect:true //���ֵ��false����������ѡ����У�����ֻ��ѡ��һ��     
});
 //����������ϸ��Ϣ�б� 
  var DevAppraisalnm=new Ext.grid.RowNumberer();
	var DevAppraisalsm=new Ext.grid.CheckboxSelectionModel(); 
	var DetailAppraisalCm=new Ext.grid.ColumnModel([DevAppraisalnm,
	  { header:'����',
			dataIndex:'Appraisal',
			width:30,
			sortable:true,
			xtype:'actioncolumn',
			items:[{xtype:"tbfill"},{
      icon:'../scripts/Pmp/Image/edit3.gif',tooltip: "��������",handler:function(DetailAppraisalGrid, rowIndex, colIndex){
      var rec = DetailAppraisalGrid.getStore().getAt(rowIndex);}}]
	  },{
		  header:'AppraisalRowid',
			dataIndex:'AppraisalRowid',
			width:60,
			sortable:true,
			hidden : true
		},{
		  header:'����',
			dataIndex:'AppraisalName',
			width:60,
			sortable:true
		},{
		  header:'��������',
			dataIndex:'AppraisalType',
			width:60,
			sortable:true
		},{
		  header:'�ܷ�',
			dataIndex:'AppraisalSum',
			width:60,
			sortable:true
		},{
		  header:'���������',
			dataIndex:'AppraisalAttendance',
			width:80,
			sortable:true
		},{
		  header:'Ч�������',
			dataIndex:'AppraisalWorkEff',
			width:80,
			sortable:true
		},{
		  header:'̬�������',
			dataIndex:'AppraisalWorkAtt',
			width:80,
			sortable:true
		},{
		  header:'���������',
			dataIndex:'AppraisalOtherStais',
			width:80,
			sortable:true
	  },{
		  header:'��������',
			dataIndex:'AppraisalMenu',
			width:150,
			sortable:true
		},{
		  header:'�������',
			dataIndex:'AppraisalBY5',
			width:150,
			sortable:true
		},{
		  header:'�����û�',
			dataIndex:'AppraisalUser',
			width:100,
			sortable:true
		},{
		  header:'��������',
			dataIndex:'AppraisalDate',
			width:150,
			sortable:true
		}]);
	var DetailAppraisalToolBar=new Ext.PagingToolbar({
		id:'DetailAppraisalToolBar',
		store:DetailAppraisalStore,
		displayInfo:true,
		pageSize:20,
		displayMsg:"��ǰ��¼{0}---{1}��  ��{2}����¼",
		emptyMsg:"û������",
		firstText:'��һҳ',
		lastText:'���һҳ',
		prevText:'��һҳ',
		refreshText:'ˢ��',
		nextText:'��һҳ'		
	});
	var DetailAppraisalGrid=new Ext.grid.GridPanel({
		   id:'DetailAppraisalGrid',
		   height:350,
		   store:DetailAppraisalStore,
		   loadMask:true,
		   cm:DetailAppraisalCm,
		   params:{InPut:'DevRowid'},
		   sm:new Ext.grid.RowSelectionModel({singleSelect:true}),
		   bbar:DetailAppraisalToolBar
	});

  //����������Ա�б�
	var nm=new Ext.grid.RowNumberer();
	var sm=new Ext.grid.CheckboxSelectionModel(); 
	var DevDetailCm=new Ext.grid.ColumnModel([nm,
	  { 
	    header:'����',
			dataIndex:'Menu',
			width:60,
			xtype:'actioncolumn',
			sortable:true,
			autoScroll : true,
			items:[{xtype:"tbfill"},{
      icon:'../scripts/epr/Pics/attending.gif',tooltip: "�������",handler:function(DevDetailGrid, rowIndex, colIndex){
      var rec = DevDetailGrid.getStore().getAt(rowIndex);
      var Assname=rec.get('DevName');
      var AssRowid=rec.get('Rowid');
      var AssTel=rec.get('DevTel');
      var AssEmail=rec.get('DevEmail');
      var AssProduct=rec.get('DevProduct');
      //alert("Edit " + rec.get('Rowid'));
      var Str="  ������"+Assname+"   �绰��"+AssTel+" "+AssEmail+"   ��Ʒ�飺"+AssProduct;
      SelectUser(userId,AssRowid,Str,AssRowid);}  
      },{xtype:"tbseparator"},
      {icon:'../scripts/Pmp/Image/drop-add.gif',tooltip: "��Ӹ��Ӽ�¼",handler:function(DevDetailGrid, rowIndex, colIndex){
      var rec = DevDetailGrid.getStore().getAt(rowIndex);
      var Adddetailname=rec.get('DevName');
      var AdddetailRowid=rec.get('Rowid');
      var AdddetailTel=rec.get('DevTel');
      var AdddetailEmail=rec.get('DevEmail');
      var AdddetailProduct=rec.get('DevProduct');
      var AdddetailInDate=rec.get('DevInDate');
      var AdddetailInTime=rec.get('DevInTime');
      var AdddetailOutDate=rec.get('DevOutDate');
      var AdddetailOutTime=rec.get('DevOutTime');
      var AdddetailBusine=rec.get('DevBusine');
      var SubType="";
      var SubRowid="";
      var type="Add";
      AddDevDetail(AdddetailRowid,SubRowid,Adddetailname,AdddetailTel,AdddetailEmail,AdddetailProduct,AdddetailInDate,AdddetailInTime,AdddetailOutDate,AdddetailOutTime,AdddetailBusine,SubType,type);}
      },{xtype:"tbseparator"},  
      {icon:'../scripts/Pmp/Image/hmenu-unlock (2).gif',tooltip: "��ϸ��Ϣ",handler:function(DevDetailGrid, rowIndex, colIndex){
      var rec = DevDetailGrid.getStore().getAt(rowIndex);
      var detailname=rec.get('DevName');
      var detailRowid=rec.get('Rowid');
      var detailTel=rec.get('DevTel');
      var detailEmail=rec.get('DevEmail');
      var detailProduct=rec.get('DevProduct');
      var detailInDate=rec.get('DevInDate');
      var detailInTime=rec.get('DevInTime');
      var detailOutDate=rec.get('DevOutDate');
      var detailOutTime=rec.get('DevOutTime');
      var detailBusine=rec.get('DevBusine');
      //alert("Edit " + rec.get('Rowid'));
      DevDetail(detailRowid,detailname,detailTel,detailEmail,detailProduct,detailInDate,detailInTime,detailOutDate,detailOutTime,detailBusine);}  
      }],
			handler:function(){alert("hello")}
	  },{
	    header:'Rowid',
			dataIndex:'Rowid',
			width:30,
			hidden : true,
			sortable:true
		},{
			header:'����',
			dataIndex:'DevName',
			width:60,
			sortable:true
		},{
			header:'״̬',
			dataIndex:'DevStatus',
			width:100,
			sortable:true,
			renderer:function(v){
      if(v!="��ǰ��Ŀ��"){
      return '<span style="color:red">'+v+'</span>';}
      else {return v;}}
		},{
			header:'����',
			dataIndex:'DevAppraisal',
			width:60,
			sortable:true,
			renderer:function(v){
      if(v!="��������"){
      return '<span style="color:red">'+v+'</span>';}
      else {return v;}}
		},{
			header:'��ϵ�绰',
			dataIndex:'DevTel',
			width:100,
			sortable:true
		},{
			header:'��������',
			dataIndex:'DevEmail',
			width:100,
			sortable:true
		},{
			header:'��Ʒ��',
			dataIndex:'DevProduct',
			width:100,
			sortable:true
		},{
			header:'��������',
			dataIndex:'DevInDate',
			width:100,
			sortable:true
		},{
			header:'����ʱ��',
			dataIndex:'DevInTime',
			width:100,
			sortable:true
		},{
			header:'�뿪����',
			dataIndex:'DevOutDate',
			width:100,
			sortable:true
		},{
			header:'�뿪ʱ��',
			dataIndex:'DevOutTime',
			width:100,
			sortable:true
		},{
			header:'����ԭ��',
			dataIndex:'DevBusine',
			width:100,
			sortable:true
		}]);
		var PagingToolBar=new Ext.PagingToolbar({
		id:'PagingToolBar',
		store:DevDetailStore,
		displayInfo:true,
		pageSize:20,
		displayMsg:"��ǰ��¼{0}---{1}��  ��{2}����¼",
		emptyMsg:"û������",
		firstText:'��һҳ',
		lastText:'���һҳ',
		prevText:'��һҳ',
		refreshText:'ˢ��',
		nextText:'��һҳ'		
	});
	var DevDetailGrid=new Ext.grid.GridPanel({
		//title:'������ϸ',
		id:'DevDetaiGrid',
		height : 380,
		store:DevDetailStore,
		loadMask:true,
		cm:DevDetailCm,
		params:{InPut:'InPut'},
		sm:new Ext.grid.RowSelectionModel({singleSelect:true}),
		bbar:PagingToolBar
		,listeners : {// ��񵥻��¼�  
		"rowclick":function(DevDetaiGrid, rowIndex,columnIndex,e) {
		              //Ext.Msg.alert('����',DevDetaiGrid.getStore().getAt(rowIndex).data.Rowid);
		              var InPut=DevDetaiGrid.getStore().getAt(rowIndex).data.Rowid;
		              //var fieldName = this.getColumnModel().getDataIndex(columnIndex);
		              //alert(fieldName+"fieldName");
		              //DevDetaiGrid.getView().getCell(rowIndex,columnIndex).style.background-color="#FF6600";  
		              //Ext.Msg.alert('help',InPut);
		              DetailStore.removeAll();
			            DetailStore.load({params:{InPut:InPut}});
			            ImListNStore.removeAll();
			            ImListNStore.load({params:{InPut:InPut}});
			            ImListStore.removeAll();
			            ImListStore.load({params:{InPut:InPut}});
		              //UserShowAll(DevDetaiGrid.getStore().getAt(rowIndex).data); ��ȡ��ǰ��ѡ�е����������� 
		              
		            },
	  "cellclick":function(DevDetaiGrid , rowIndex , cellIndex ,e){
		      var record = DevDetaiGrid.getStore().getAt(rowIndex);    //��ȡ�����еļ�¼
          var fieldName = DevDetaiGrid.getColumnModel().getDataIndex(cellIndex );//��ȡ��Ԫ�����������
          var callValue = record .get(fieldName);//��õ�Ԫ������
          var DevRowid=record.data.Rowid;
          if(fieldName=="DevAppraisal"){
          if(callValue!="��������"){
          var DevAppraisalwindow=new Ext.Window({
			         title:"������ϸ��¼",
			         layout:"form",
			         width:1000,
		           height:400,
		           frame:true, 
		           plain:true,
		           minimizable:true,
		           //maximizable:true,
		           closable:"true",
		           buttonAlign:"center",
		           bodyStyle:"padding:7px",
		           items:DetailAppraisalGrid
		           }).show();
              DetailAppraisalStore.removeAll();
			        DetailAppraisalStore.load({params:{InPut:DevRowid}});
			      };
			      
          }; 
		  }}  
	});
		
	/*
	//���mouseover�¼�    ����ƶ������������ʾ����
	DevDetailGrid.on('mouseover',function(e){  
	 //����mouse���ڵ�target����ȡ���е�λ��
  var index = DevDetailGrid.getView().findRowIndex(e.getTarget());  
   if(index!==false){     //��ȡ������ȷ����ʱ������Ϊ��������target��û��ȡ����ʱ��᷵��false��
      var record = DevDetailStore.getAt(index);//�����е�recordȡ����
      var str = Ext.encode(record.data);      //��װһ���ַ����������Ҫ���Լ�����ɣ�����Ұ������л�
      var rowEl = Ext.get(e.getTarget()); //��targetת����Ext.Element����
      rowEl.set({
     'ext:qtip':str  //��������tip����
     },false);
       }
   });
   
   */
  
	//DevDetailGrid.addListener('rowclick', rowclickFn);   //�����¼�
	
	 //DevDetailGrid.addListener('rowdblclick', rowclickFn);   //˫���¼�
	
    ChartInfoAddFun();                                   
    function ChartInfoAddFun() {  
     var myPanel=new Ext.Viewport({ 
        layout:"border",        
        items:[{
	        region:"north",
	        collapsible:true,   //��������
	        height:0,
	        frame:true,     //�������  ��ɫΪǳɫ
	        title:"��������"
	        ,html:"<h1>�ù�����Ҫ�����Ʒ�鿪�����ֳ��Ĺ����ļ�¼!</h1>"
	        },
	        {region:"south",
	        height:200,
	        collapsible:true,
	        collapsible:true,
	        frame:true,     //�������  
	        title:"������չ��Ϣ",
	        layout:"form",
	        items:DetailGrid	
	        },
	        {region:"center",
	        collapsible:true,
	        frame:true,     
	        title:"�����б�",
	        layout:"form",
	        items:DevDetailGrid	        
	        },
	        {region:"west",
	        width:250,
	        collapsible:true,
	        frame:true,     //������� 
	        height:200,
	        bodyStyle:"padding:5px",
	        labelWidth:60,   //������
	        title:"��������",
	        layout:"form",
			    //tools:[{id:"save"},{id:"help", handler:function(){Ext.Msg.alert('help','please help me!');}},{id:"close"}],
			    tbar:[{xtype:"tbfill"},
			      {//pressed:true,   //��ť͹��
			      tooltip: "��ӿ�����Ϣ",text:"<img SRC='../scripts/Pmp/Image/file-add.gif'>��������",
			      handler:function(){
			        var DevNamec=Ext.getDom("Name").value;
			        var DevTelc=Ext.getDom("Tel").value;
			        var DevEmailc=Ext.getDom("Email").value;
			        var DevProductc=Ext.getDom("Product").value;
			        var DevBusinessReasonc=Ext.getCmp("BusinessReason").getValue();  //Ext.getDom("BusinessReason").getvalue();
			        var DevInDatec=Ext.getCmp('InDate').value;
			        var DevInTimec=Ext.getCmp('InTime').value;
			        var DevOutDatec=Ext.getCmp('OutDate').value;
			        var DevOutTimec=Ext.getCmp('OutTime').value;
			        var DevDLBY1c=Ext.getDom("DLBY1").value;
			        if((DevNamec=="")||(DevNamec=="null")||(DevNamec=="����������")){
			        Ext.Msg.alert('��ܰ��ʾ',"������������Ϊ�գ�");
			        return;
			        };
			        if((DevTelc=="")||(DevTelc=="null")||(DevTelc=="��������ϵ��ʽ")){
			        Ext.Msg.alert('��ܰ��ʾ',"��ϵ��ʽ����Ϊ�գ�");
			        return;
			        };
			        if((DevProductc=="")||(DevProductc=="null")||(DevProductc=="undefined")){
			        Ext.Msg.alert('��ܰ��ʾ',"����������Ϊ�գ�");
			        return;
			        };
			        if((DevInDatec=="")||(DevInDatec=="null")||(DevInDatec=="undefined")){
			        Ext.Msg.alert('��ܰ��ʾ',"�������ڲ���Ϊ�գ�");
			        return;
			        };
			        if((DevInTimec=="")||(DevInTimec=="null")||(DevInTimec=="undefined")){
			        Ext.Msg.alert('��ܰ��ʾ',"����ʱ�䲻��Ϊ�գ�");
			        return;
			        };
			        if(DevOutDatec=="undefined"){var DevOutDatec="";};
			        if(DevOutTimec=="undefined"){var DevOutTimec="";};
			        if((DevDLBY1c=="")||(DevDLBY1c=="null")||(DevDLBY1c=="undefined")){
			        Ext.Msg.alert('��ܰ��ʾ',"�������Ͳ���Ϊ�գ�");
			        return;
			        };
			        DevInsert(DevNamec,DevTelc,DevEmailc,DevProductc,DevBusinessReasonc,DevInDatec,DevInTimec,DevOutDatec,DevOutTimec,DevDLBY1c);
			        
				      }},
				  {xtype:"tbseparator"},
				  {tooltip: "����������������",text:"<img SRC='../scripts/Pmp/Image/eb_find1.gif'>���ټ���",
			      handler:function(){
				      var DevNamec=Ext.getDom("Name").value;
			        var DevTelc=Ext.getDom("Tel").value;
			        var DevEmailc=Ext.getDom("Email").value;
			        var DevProductc=Ext.getDom("Product").value;
			        var DevBusinessReasonc=Ext.getCmp("BusinessReason").getValue()  //Ext.getDom("BusinessReason").getvalue();
			        var DevInDatec=Ext.getCmp('InDate').value;
			        var DevInTimec=Ext.getCmp('InTime').value;
			        var DevOutDatec=Ext.getCmp('OutDate').value;
			        var DevOutTimec=Ext.getCmp('OutTime').value;
			        if(DevProductc=="undfined"){var DevProductc=""};
			        if(DevInTimec=="undefined"){var DevInTimec=""};
			        if(DevOutDatec=="undefined"){var DevOutDatec="";}
			        if(DevOutTimec=="undefined"){var DevOutTimec="";}
			        SelectDevDetail(DevNamec,DevTelc,DevEmailc,DevProductc,DevBusinessReasonc,DevInDatec,DevInTimec,DevOutDatec,DevOutTimec);}},
				  {xtype:"tbseparator"},
				  {tooltip: "����������������",text:"<img SRC='../scripts/dhcmed/img/delete.gif'>���",
			      handler:function(){
			        Ext.getCmp("Name").setValue(""); 
			        Ext.getCmp("Tel").setValue(""); 
			        Ext.getCmp("Email").setValue(""); 
			        //Ext.getCmp("Product").setValue("");
			        //Ext.getCmp("BusinessReason").getStore().load();
			        Ext.getCmp("InDate").setValue(new Date());
			        Ext.getCmp("OutDate").setValue(new Date());
			        Ext.getCmp("BusinessReason").setValue("")}}],
			      //tbar:[{text:'����������topToolbar'}],
            //bbar:[{text:'�ײ�������bottomToolbar'}],
            //buttons:[{text:"��������"},{text:"�� ��"},{text:"�� ��"}],
			listeners:{
				"render":function(myPanel){
							myPanel.add(new Ext.form.TextField({
								id:"Name",
								emptyText:'����������',
								width : 150,
								fieldLabel:"��������",
								 listeners: {
               //���������¼�
                "specialkey": function (field, e) {
                   //�ж��Ƿ�س�
                  if (e.keyCode == 13) {
                    //���õ�¼�¼�
                    var DevNamec=Ext.getDom("Name").value;
			        var DevTelc=Ext.getDom("Tel").value;
			        var DevEmailc=Ext.getDom("Email").value;
			        var DevProductc=Ext.getDom("Product").value;
			        var DevBusinessReasonc=Ext.getCmp("BusinessReason").getValue()  //Ext.getDom("BusinessReason").getvalue();
			        var DevInDatec=Ext.getCmp('InDate').value;
			        var DevInTimec=Ext.getCmp('InTime').value;
			        var DevOutDatec=Ext.getCmp('OutDate').value;
			        var DevOutTimec=Ext.getCmp('OutTime').value;
			        if(DevProductc=="undfined"){var DevProductc=""};
			        if(DevInTimec=="undefined"){var DevInTimec=""};
			        if(DevOutDatec=="undefined"){var DevOutDatec="";}
			        if(DevOutTimec=="undefined"){var DevOutTimec="";}
			        SelectDevDetail(DevNamec,DevTelc,DevEmailc,DevProductc,DevBusinessReasonc,DevInDatec,DevInTimec,DevOutDatec,DevOutTimec);
                 }
                     }
                         }
								})),
							myPanel.add(new Ext.form.TextField({
									id:"Tel",
									width : 150,
									regex:  /^\d+(\.\d{1,2})?$/,
                  regexText: '��������ȷ����������',
                  vtype: 'alphanum',
								  fieldLabel:"��ϵ��ʽ",
								  listeners: {
               //���������¼�
                "specialkey": function (field, e) {
                   //�ж��Ƿ�س�
                  if (e.keyCode == 13) {
                    //���õ�¼�¼�
                    var DevNamec=Ext.getDom("Name").value;
			        var DevTelc=Ext.getDom("Tel").value;
			        var DevEmailc=Ext.getDom("Email").value;
			        var DevProductc=Ext.getDom("Product").value;
			        var DevBusinessReasonc=Ext.getCmp("BusinessReason").getValue()  //Ext.getDom("BusinessReason").getvalue();
			        var DevInDatec=Ext.getCmp('InDate').value;
			        var DevInTimec=Ext.getCmp('InTime').value;
			        var DevOutDatec=Ext.getCmp('OutDate').value;
			        var DevOutTimec=Ext.getCmp('OutTime').value;
			        if(DevProductc=="undfined"){var DevProductc=""};
			        if(DevInTimec=="undefined"){var DevInTimec=""};
			        if(DevOutDatec=="undefined"){var DevOutDatec="";}
			        if(DevOutTimec=="undefined"){var DevOutTimec="";}
			        SelectDevDetail(DevNamec,DevTelc,DevEmailc,DevProductc,DevBusinessReasonc,DevInDatec,DevInTimec,DevOutDatec,DevOutTimec);
                 }
                     }
                         }
									})),
							myPanel.add(new Ext.form.TextField({
									id:"Email",
									width : 150,
									regex: /^\s*\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*(\;\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*)*(\;)*\s*$/,
									regexText: '��������ȷ�ĵ��������ַ',
								  fieldLabel:"��������",
								  listeners: {
               //���������¼�
                "specialkey": function (field, e) {
                   //�ж��Ƿ�س�
                  if (e.keyCode == 13) {
                    //���õ�¼�¼�
                    var DevNamec=Ext.getDom("Name").value;
			        var DevTelc=Ext.getDom("Tel").value;
			        var DevEmailc=Ext.getDom("Email").value;
			        var DevProductc=Ext.getDom("Product").value;
			        var DevBusinessReasonc=Ext.getCmp("BusinessReason").getValue()  //Ext.getDom("BusinessReason").getvalue();
			        var DevInDatec=Ext.getCmp('InDate').value;
			        var DevInTimec=Ext.getCmp('InTime').value;
			        var DevOutDatec=Ext.getCmp('OutDate').value;
			        var DevOutTimec=Ext.getCmp('OutTime').value;
			        if(DevProductc=="undfined"){var DevProductc=""};
			        if(DevInTimec=="undefined"){var DevInTimec=""};
			        if(DevOutDatec=="undefined"){var DevOutDatec="";}
			        if(DevOutTimec=="undefined"){var DevOutTimec="";}
			        SelectDevDetail(DevNamec,DevTelc,DevEmailc,DevProductc,DevBusinessReasonc,DevInDatec,DevInTimec,DevOutDatec,DevOutTimec);
                 }
                     }
                         }
									})),
							myPanel.add(new Ext.form.ComboBox({
									id:"Product",
									width : 150,
								  fieldLabel:"������",
								  name:'Product',
								  mode : 'local',
								  //triggerAction : 'all', 
								  store : SelectProduct,   //��ȡ����
                  valueField : 'RowId',   //��ֵ̨
                  displayField : 'Description',   //������ʾֵ
                  valueNotFoundText : '',
                  params:{InPut:'Product'}   //��β���ֵ
                                    })),
							myPanel.add(new Ext.form.DateField({
									id:"InDate",
									width : 150,
								    fieldLabel:'��������',
								    enableKeyEvents : true,
	                                emptyText:'��ѡ������',
	                                format:'Y-m-d',
	                                value:new Date().add(Date.DAY,0)
	                               // ,disabledDays:[0,6]
									})),
							myPanel.add(new Ext.form.TimeField({
									id:"InTime",
								    fieldLabel:'����ʱ��',
								    renderTo: Ext.get('times'), 
								    width : 150,
	                                emptyText:'��ѡ��ʱ��',
	                                regex : /^(0\d{1}|1\d{1}|2[0-3]):[0-5]\d{1}:([0-5]\d{1})$/,
		                              regexText:'ʱ���ʽ������ȷ��ʽhh:mm:ss',
	                                autoShow: true,
	                                format: 'H:i:s',
	                                increment:1    //ʱ����
									})),
							myPanel.add(new Ext.form.DateField({
									id:"OutDate",
									width : 150,
								    fieldLabel:'�뿪����',
								    enableKeyEvents : true,
	                                //emptyText:'��ѡ������',
	                                format:'Y-m-d'
	                                //value:new Date().add(Date.DAY,0),
	                                //,disabledDays:[0,6]
									})),
							myPanel.add(new Ext.form.TimeField({
									id:"OutTime",
								    fieldLabel:'�뿪ʱ��',
								    renderTo: Ext.get('times'), 
								    width : 150,
	                                //emptyText:'��ѡ��ʱ��',
	                                autoShow: true,
	                                regex : /^(0\d{1}|1\d{1}|2[0-3]):[0-5]\d{1}:([0-5]\d{1})$/,
		                              regexText:'ʱ���ʽ������ȷ��ʽhh:mm:ss',
	                                format: 'H:i:s',
	                                increment:1
									})),
						  myPanel.add(new Ext.form.ComboBox({
								id:"DLBY1",
								width : 150,
								fieldLabel:"�������",
								emptyText:'��ѡ�������������',
								name:'DLBY1',
							  mode : 'local',
								store : AddDetailType,   //��ȡ����
                valueField : 'RowId',   //��ֵ̨
                displayField : 'Description',   //������ʾֵ
                valueNotFoundText : '',
                params:{InPut:'DLBY1'}   //��β���ֵ
								})),
							myPanel.add(new Ext.form.TextField({
									id:"BusinessReason",
									width : 150,
								    fieldLabel:"����ԭ��",
								    listeners : {
                                    change : function(field,newValue,oldValue){
                                    Ext.Msg.alert('help',newValue+'---'+'oldValue');},
                                    focus:function(){
                                       var buvalue=Ext.getDom("BusinessReason").value;
	                                     var mywindow=new Ext.Window({
			                             title:"����ԭ��",
			                             width:520,
		                                 height:300,
		                                 layout:'column',
				                         Resizable:'yes',
		                                 minimizable:true,
		                                 closable:"true",   
		                                 buttonAlign:"center",
		                                 
		                                 items:[{xtype:'htmleditor',id:'Business',defaultValue:buvalue
		                                 //,fontFamilies: ["����", "����", "����"]
		                                 //,style:'color:white;background-color:#000000'   //���ñ�������
		                                 }],
		                                 tbar:[{text:'ȷ��',tooltip: "ȷ�ϳ���ԭ��",
					                     handler:function(){
					                     Ext.getCmp("BusinessReason").setValue(Ext.getCmp("Business").getValue());
					                     mywindow.close();}
					}]}).show();
	                                    }  //ѡ���¼�
                                                }
									}))							
				}
				}
	        },
	        {region:"east",
	        width:750,
	        collapsible:true,
	        frame:true,     
	        title:"���������¼",
	        xtype:"tabpanel", 
	        collapsed:true,
	        items:[{title:"���������",frame:true,items:[ImListGrid]}, 
          {title:"δ�������",frame:true,items:[ImListNGrid]}] 
	        }]
	     });
    }
})
function DevInsert(DevNamec,DevTelc,DevEmailc,DevProductc,DevBusinessReasonc,DevInDatec,DevInTimec,DevOutDatec,DevOutTimec,DevDLBY1c) {
        var InPut=DevNamec+"^"+DevTelc+"^"+DevEmailc+"^"+DevProductc+"^"+DevBusinessReasonc+"^"+DevInDatec+"^"+DevInTimec+"^"+DevOutDatec+"^"+DevOutTimec+"^"+DevDLBY1c;
				//alert(InPut);
				var url = "PMP.Common.csp?actiontype=DevInsert&InPut="+InPut;
				//alert(url);
				Ext.Ajax.request({
							url : url,
							method : 'POST',
							waitMsg : '���ݴ洢��..',
							success : function(result, request) {
								var jsonData = Ext.util.JSON
										.decode(result.responseText);
								if (jsonData.success == 'true') {
								  SelectDevDetail(DevNamec,DevTelc,DevEmailc,"","","","","","");
									Ext.Msg.alert("success", "���ݲ���ɹ�!");
									
									//clearData();
								} else {
									var ret=jsonData.info;
									if(ret==-1){
										Ext.Msg.alert("error", "����ʧ��!");
									}
								}
							},
							scope : this
						});
		}
function SelectDevDetail(DevNamec,DevTelc,DevEmailc,DevProductc,DevBusinessReasonc,DevInDatec,DevInTimec,DevOutDatec,DevOutTimec){
        var InPut=DevNamec+"^"+DevTelc+"^"+DevEmailc+"^"+DevProductc+"^"+DevBusinessReasonc+"^"+DevInDatec+"^"+DevInTimec+"^"+DevOutDatec+"^"+DevOutTimec;
				getDetail(InPut);
				/*
				var url = "PMP.Common.csp?actiontype=DevDetailStore&InPut="+InPut;
				Ext.Ajax.request({
							url : url,
							method : 'POST',
							waitMsg : '���ݲ�ѯ��..',
							success : function(result,request) {
							//alert(result.responseText);
							var jsonData = Ext.util.JSON
									.decode(result.responseText);
									
							},
							
							scope : this
						});
						*/
}
function getDetail(InPut) {
        //Ext.Msg.alert('help',InPut);
		   	DevDetailStore.removeAll();
			  DevDetailStore.load({params:{InPut:InPut}});
		
			// �����ť�Ƿ����
			//��ѯ^���^����^����^ɾ��^���^ȡ�����
		}
function rowclickFn(DevDetailGrid, rowindex, e){  
    Ext.Msg.alert('help','�����¼�');    
    DevDetailGrid.getSelectionModel().each(function(rec){   
    alert(rec.get(DevName)); //fieldName����¼�е��ֶ���     
    });     
}    
function UserShowAll(record){
         Ext.Msg.alert('��ϸ����',record.DevName);
}
//������۹���
function DevAddAppraisal(Str,AssRowid){
 //alert(userId);
 
/*
for(i=1;i++;i<6){
   var type="Attendancetype"+i;
   var type="0";
   alert(type);
   var type1="WorkEfficiencytype"+i;
   var type1="0";
};
*/
    var Attendancetype1="0";
    var Attendancetype2="0";
    var Attendancetype3="0";
    var Attendancetype4="0";
    var Attendancetype5="0";
    var WorkEfficiencytype1="0";
    var WorkEfficiencytype2="0";
    var WorkEfficiencytype3="0";
    var WorkEfficiencytype4="0";
    var WorkEfficiencytype5="0";
     var app=new Ext.form.TextField({
								id:"app",
								width : 130,
								//hidden : true,
								fieldLabel:"���ڵ÷�"
								});
var Appraisalwindow=new Ext.Window({
			  title:"��������",
			  layout:"form",
			  width:530,
		    height:600,
		    frame:true, 
		    plain:true,
		    minimizable:true,
		    //maximizable:true,
		    closable:"true",
		    buttonAlign:"center",
		    bodyStyle:"padding:5px",
		    //defaults:{xtype:"button",width:180},
		    frame:true,     //�������  ��ɫΪǳɫ
		    labelWidth:70,  //������
		    tbar:[{tooltip: "��������",text:"<img SRC='../scripts/Pmp/Image/add16.gif'>����",handler:function(){
		    var Attendancevalue=Ext.getDom("Attendancevalue").value;
		    var WorkEfficiencyvalue=Ext.getDom("WorkEfficiency1value").value;
		    var WorkAttitudevlaue=Ext.getDom("WorkAttitudevlaue").value;
		    var OtherStaisvlaue=Ext.getDom("OtherStaisvlaue").value;
		    var AppMenuvlaue=Ext.getDom("AppMenu").value;
		    var AppProposalvlaue=Ext.getDom("AppProposal").value;
		    var Rowidvlaue=Ext.getDom("Rowid").value;
		    if((Attendancevalue=="")||(Attendancevalue=="0")){
		    Ext.Msg.alert('��ܰ��ʾ','��������Ȼ�δ��֣�');
		    return;
		    };
		    if((WorkEfficiencyvalue=="")||(WorkEfficiencyvalue=="0")){
		    Ext.Msg.alert('��ܰ��ʾ','Ч������Ȼ�δ��֣�');
		    return;
		    };
		    if((WorkAttitudevlaue=="")||(WorkAttitudevlaue=="0")){
		    Ext.Msg.alert('��ܰ��ʾ','̬������Ȼ�δ��֣�');
		    return;
		    };
		    if((OtherStaisvlaue=="")||(OtherStaisvlaue=="0")){
		    Ext.Msg.alert('��ܰ��ʾ','��������Ȼ�δ��֣�');
		    return;
		    };
		    if(Rowidvlaue==""){
		    Ext.Msg.alert('��ܰ��ʾ','δѡ�����ݣ�');
		    return;
		    };
		    var str=Attendancevalue+"^"+WorkEfficiencyvalue+"^"+WorkAttitudevlaue+"^"+OtherStaisvlaue+"^"+AppMenuvlaue+"^"+AppProposalvlaue+"^"+Rowidvlaue;
		    //Ext.Msg.alert('help',Attendancevalue+"^"+WorkEfficiencyvalue+"^"+WorkAttitudevlaue+"^"+OtherStaisvlaue+"^"+AppMenuvlaue+"^"+AppProposalvlaue+"^"+Rowidvlaue);
		    //Ext.Msg.alert('help',WorkEfficiencyvalue);
		    AddAppraisal(Rowidvlaue,str);
		    
		    }
		    },
		    {xtype:"tbseparator"},
		    {tooltip: Str,bodyStyle:'font-size:25px',text:"<img SRC='../scripts/Pmp/Image/user_suit.gif'>"+Str}],
		    listeners:{
				"render":function(Appraisalwindow){
							  Appraisalwindow.add(new Ext.Panel({
			          layout:"form",
			          width:500,
		            height:5,
		            closable:"true",
		            buttonAlign:"center",
		            frame:true,     //�������  ��ɫΪǳɫ
		            labelWidth:40,   //������
		            tbar:[{id:'Attendance',tooltip: "���������",text:"<img SRC='../scripts/Pmp/Image/APP1.gif'>���������",
		            listeners: {
                mouseover: function(e) {
               // Ext.getDom("Attendance").innerHTML ="../scripts/Pmp/Image/APP2.gif";
                //Ext.getDom(e.getId()).innerHTML ='../scripts/Pmp/Image/APP2.gif';
               //Ext.getCmp('Attendance').btnEl.setStyle('background-color',"yellow");   //��ť������ɫ  
               //Ext.getCmp('Attendance').btnInnerEl.setStyle('color',"green");  //��ť������ɫ
                //Ext.getCmp('Attendance').btnEl.setStyle('background-image','-webkit-linear-gradient(top,red,yellow 40%,yellow 30%,red)');  ������ɫ����
                //Attendance.seticon('../scripts/Pmp/Image/APP2.gif');
                // set a new config which says we moused over, if not already set
                if (!this.mousedOver) {
                this.mousedOver = true;
                //alert('You moused over a button!\n\nI wont do this again.');
                          }
        },mouseout:function(e){
        //Ext.getCmp('Attendance').btnEl.setStyle('background-color',"blue");   //��ť������ɫ 
        }
   
    }},
		            {xtype:"tbseparator"},
		            {id:'Attendance1',tooltip: "����ȱ��",text:"<img SRC='../scripts/Pmp/Image/APP2.gif'>",
		            listeners: {
		            //��������¼�
                mouseover: function(e) {
                if(Attendancetype1=="0"){
                Ext.getCmp('Attendance1').btnEl.setStyle('background-color',"red");   //��ť������ɫ  
                Ext.getCmp('Attendance2').btnEl.setStyle('background-color',"blue");
                Ext.getCmp('Attendance3').btnEl.setStyle('background-color',"blue");
                Ext.getCmp('Attendance4').btnEl.setStyle('background-color',"blue");
                Ext.getCmp('Attendance5').btnEl.setStyle('background-color',"blue");
                Ext.getCmp("Attendancevalue").setValue("1");
                }},
                handler:function(){
                Ext.getCmp('Attendance1').btnEl.setStyle('background-color',"red");
                Ext.getCmp('Attendance2').btnEl.setStyle('background-color',"blue");
                Ext.getCmp('Attendance3').btnEl.setStyle('background-color',"blue");
                Ext.getCmp('Attendance4').btnEl.setStyle('background-color',"blue");
                Ext.getCmp('Attendance5').btnEl.setStyle('background-color',"blue");
                var Attendancetype1="1";
                Ext.getCmp("Attendancevalue").setValue("1");
                
                }}},
		            {xtype:"tbseparator"},
		            {id:'Attendance2',tooltip: "ż��ȱ��",text:"<img SRC='../scripts/Pmp/Image/APP2.gif'>",
		            listeners: {
                mouseover: function(e) {
                if(Attendancetype2=="0"){
                Ext.getCmp('Attendance1').btnEl.setStyle('background-color',"red");   //��ť������ɫ  
                Ext.getCmp('Attendance2').btnEl.setStyle('background-color',"red");   //��ť������ɫ  
                Ext.getCmp('Attendance3').btnEl.setStyle('background-color',"blue");
                Ext.getCmp('Attendance4').btnEl.setStyle('background-color',"blue");
                Ext.getCmp('Attendance5').btnEl.setStyle('background-color',"blue");
                Ext.getCmp("Attendancevalue").setValue("2");
                }},
                handler:function(){
                Ext.getCmp('Attendance1').btnEl.setStyle('background-color',"red");
                Ext.getCmp('Attendance2').btnEl.setStyle('background-color',"red");
                Ext.getCmp('Attendance3').btnEl.setStyle('background-color',"blue");
                Ext.getCmp('Attendance4').btnEl.setStyle('background-color',"blue");
                Ext.getCmp('Attendance5').btnEl.setStyle('background-color',"blue");
                Ext.getCmp("Attendancevalue").setValue("2");
                var Attendancetype2="1";
                }}},
		            {xtype:"tbseparator"},
		            {id:'Attendance3',tooltip: "��������",text:"<img SRC='../scripts/Pmp/Image/APP2.gif'>",
		            listeners: {
                mouseover: function(e) {
                if(Attendancetype3=="0"){
                Ext.getCmp('Attendance1').btnEl.setStyle('background-color',"red");
                Ext.getCmp('Attendance2').btnEl.setStyle('background-color',"red");
                Ext.getCmp('Attendance3').btnEl.setStyle('background-color',"red");
                Ext.getCmp('Attendance4').btnEl.setStyle('background-color',"blue");
                Ext.getCmp('Attendance5').btnEl.setStyle('background-color',"blue");
                Ext.getCmp("Attendancevalue").setValue("3");
                }},
                handler:function(){
                Ext.getCmp('Attendance1').btnEl.setStyle('background-color',"red");
                Ext.getCmp('Attendance2').btnEl.setStyle('background-color',"red");
                Ext.getCmp('Attendance3').btnEl.setStyle('background-color',"red");
                Ext.getCmp('Attendance4').btnEl.setStyle('background-color',"blue");
                Ext.getCmp('Attendance5').btnEl.setStyle('background-color',"blue");
                Ext.getCmp("Attendancevalue").setValue("3");
                var Attendancetype3="1";
                }}},
		            {xtype:"tbseparator"},
		            {id:'Attendance4',tooltip: "ż���Ӱ�",text:"<img SRC='../scripts/Pmp/Image/APP2.gif'>",
		            listeners: {
                mouseover: function(e) {
                if(Attendancetype4=="0"){
                Ext.getCmp('Attendance1').btnEl.setStyle('background-color',"red");
                Ext.getCmp('Attendance2').btnEl.setStyle('background-color',"red");
                Ext.getCmp('Attendance3').btnEl.setStyle('background-color',"red");
                Ext.getCmp('Attendance4').btnEl.setStyle('background-color',"red");
                Ext.getCmp('Attendance5').btnEl.setStyle('background-color',"blue");
                Ext.getCmp("Attendancevalue").setValue("4");
                }},
                handler:function(){
                Ext.getCmp('Attendance1').btnEl.setStyle('background-color',"red");
                Ext.getCmp('Attendance2').btnEl.setStyle('background-color',"red");
                Ext.getCmp('Attendance3').btnEl.setStyle('background-color',"red");
                Ext.getCmp('Attendance4').btnEl.setStyle('background-color',"red");
                Ext.getCmp('Attendance5').btnEl.setStyle('background-color',"blue");
                Ext.getCmp("Attendancevalue").setValue("4");
                var Attendancetype4="1";
                }}},
		            {xtype:"tbseparator"},
		            {id:'Attendance5',tooltip: "�������",text:"<img SRC='../scripts/Pmp/Image/APP2.gif'>",
		            listeners: {
                mouseover: function(e) {
                if(Attendancetype5=="0"){
                Ext.getCmp('Attendance1').btnEl.setStyle('background-color',"red");
                Ext.getCmp('Attendance2').btnEl.setStyle('background-color',"red");
                Ext.getCmp('Attendance3').btnEl.setStyle('background-color',"red");
                Ext.getCmp('Attendance4').btnEl.setStyle('background-color',"red");
                Ext.getCmp('Attendance5').btnEl.setStyle('background-color',"red");
                Ext.getCmp("Attendancevalue").setValue("5");
                }},
                handler:function(){
                Ext.getCmp('Attendance1').btnEl.setStyle('background-color',"red");
                Ext.getCmp('Attendance2').btnEl.setStyle('background-color',"red");
                Ext.getCmp('Attendance3').btnEl.setStyle('background-color',"red");
                Ext.getCmp('Attendance4').btnEl.setStyle('background-color',"red");
                Ext.getCmp('Attendance5').btnEl.setStyle('background-color',"red");
                Ext.getCmp("Attendancevalue").setValue("5");
                var Attendancetype5="1";
                }}}],
								bbar:[{id:'WorkEfficiency',tooltip: "Ч�������",text:"<img SRC='../scripts/Pmp/Image/APP1.gif'>Ч�������",
		            listeners: {
                mouseover: function(e) {},
                mouseout:function(e){}}},
								{xtype:"tbseparator"},
								{id:'WorkEfficiency1',tooltip: "Ч�ʼ���",text:"<img SRC='../scripts/Pmp/Image/APP2.gif'>",
		            listeners: {
                mouseover: function(e) {
                if(WorkEfficiencytype1=="0"){
                Ext.getCmp('WorkEfficiency1').btnEl.setStyle('background-color',"red");   //��ť������ɫ  
                Ext.getCmp('WorkEfficiency2').btnEl.setStyle('background-color',"blue");
                Ext.getCmp('WorkEfficiency3').btnEl.setStyle('background-color',"blue");
                Ext.getCmp('WorkEfficiency4').btnEl.setStyle('background-color',"blue");
                Ext.getCmp('WorkEfficiency5').btnEl.setStyle('background-color',"blue");
                Ext.getCmp("WorkEfficiency1value").setValue("1");
                }},
                handler:function(){
                Ext.getCmp('WorkEfficiency1').btnEl.setStyle('background-color',"red");
                Ext.getCmp('WorkEfficiency2').btnEl.setStyle('background-color',"blue");
                Ext.getCmp('WorkEfficiency3').btnEl.setStyle('background-color',"blue");
                Ext.getCmp('WorkEfficiency4').btnEl.setStyle('background-color',"blue");
                Ext.getCmp('WorkEfficiency5').btnEl.setStyle('background-color',"blue");
                Ext.getCmp("WorkEfficiency1value").setValue("1");
                var WorkEfficiencytype1="1";
                }}},
								{xtype:"tbseparator"},
								{id:'WorkEfficiency2',tooltip: "Ч�ʽϲ�",text:"<img SRC='../scripts/Pmp/Image/APP2.gif'>",
		            listeners: {
                mouseover: function(e) {
                if(WorkEfficiencytype2=="0"){
                Ext.getCmp('WorkEfficiency1').btnEl.setStyle('background-color',"red");   //��ť������ɫ  
                Ext.getCmp('WorkEfficiency2').btnEl.setStyle('background-color',"red");   //��ť������ɫ  
                Ext.getCmp('WorkEfficiency3').btnEl.setStyle('background-color',"blue");
                Ext.getCmp('WorkEfficiency4').btnEl.setStyle('background-color',"blue");
                Ext.getCmp('WorkEfficiency5').btnEl.setStyle('background-color',"blue");
                Ext.getCmp("WorkEfficiency1value").setValue("2");
                }},
                handler:function(){
                Ext.getCmp('WorkEfficiency1').btnEl.setStyle('background-color',"red");
                Ext.getCmp('WorkEfficiency2').btnEl.setStyle('background-color',"red");
                Ext.getCmp('WorkEfficiency3').btnEl.setStyle('background-color',"blue");
                Ext.getCmp('WorkEfficiency4').btnEl.setStyle('background-color',"blue");
                Ext.getCmp('WorkEfficiency5').btnEl.setStyle('background-color',"blue");
                Ext.getCmp("WorkEfficiency1value").setValue("2");
                var WorkEfficiencytype2="1";
                }}},
								{xtype:"tbseparator"},
								{id:'WorkEfficiency3',tooltip: "Ч������",text:"<img SRC='../scripts/Pmp/Image/APP2.gif'>",
		            listeners: {
                 mouseover: function(e) {
                 if(WorkEfficiencytype3=="0"){
                Ext.getCmp('WorkEfficiency1').btnEl.setStyle('background-color',"red");
                Ext.getCmp('WorkEfficiency2').btnEl.setStyle('background-color',"red");
                Ext.getCmp('WorkEfficiency3').btnEl.setStyle('background-color',"red");
                Ext.getCmp('WorkEfficiency4').btnEl.setStyle('background-color',"blue");
                Ext.getCmp('WorkEfficiency5').btnEl.setStyle('background-color',"blue");
                Ext.getCmp("WorkEfficiency1value").setValue("3");
                }},
                handler:function(){
                Ext.getCmp('WorkEfficiency1').btnEl.setStyle('background-color',"red");
                Ext.getCmp('WorkEfficiency2').btnEl.setStyle('background-color',"red");
                Ext.getCmp('WorkEfficiency3').btnEl.setStyle('background-color',"red");
                Ext.getCmp('WorkEfficiency4').btnEl.setStyle('background-color',"blue");
                Ext.getCmp('WorkEfficiency5').btnEl.setStyle('background-color',"blue");
                Ext.getCmp("WorkEfficiency1value").setValue("3");
                var WorkEfficiencytype3="1";
                }}},
                {xtype:"tbseparator"},
								{id:'WorkEfficiency4',tooltip: "Ч������",text:"<img SRC='../scripts/Pmp/Image/APP2.gif'>",
		            listeners: {
                mouseover: function(e) {
                if(WorkEfficiencytype4=="0"){
                Ext.getCmp('WorkEfficiency1').btnEl.setStyle('background-color',"red");
                Ext.getCmp('WorkEfficiency2').btnEl.setStyle('background-color',"red");
                Ext.getCmp('WorkEfficiency3').btnEl.setStyle('background-color',"red");
                Ext.getCmp('WorkEfficiency4').btnEl.setStyle('background-color',"red");
                Ext.getCmp('WorkEfficiency5').btnEl.setStyle('background-color',"blue");
                Ext.getCmp("WorkEfficiency1value").setValue("4");
                }},
                handler:function(){
                Ext.getCmp('WorkEfficiency1').btnEl.setStyle('background-color',"red");
                Ext.getCmp('WorkEfficiency2').btnEl.setStyle('background-color',"red");
                Ext.getCmp('WorkEfficiency3').btnEl.setStyle('background-color',"red");
                Ext.getCmp('WorkEfficiency4').btnEl.setStyle('background-color',"red");
                Ext.getCmp('WorkEfficiency5').btnEl.setStyle('background-color',"blue");
                Ext.getCmp("WorkEfficiency1value").setValue("4");
                var WorkEfficiencytype4="1";
                }}},
								{xtype:"tbseparator"},
								{id:'WorkEfficiency5',tooltip: "Ч�ʳ���",text:"<img SRC='../scripts/Pmp/Image/APP2.gif'>",
		            listeners: {
                mouseover: function(e) {
                if(WorkEfficiencytype5=="0"){
                Ext.getCmp('WorkEfficiency1').btnEl.setStyle('background-color',"red");
                Ext.getCmp('WorkEfficiency2').btnEl.setStyle('background-color',"red");
                Ext.getCmp('WorkEfficiency3').btnEl.setStyle('background-color',"red");
                Ext.getCmp('WorkEfficiency4').btnEl.setStyle('background-color',"red");
                Ext.getCmp('WorkEfficiency5').btnEl.setStyle('background-color',"red");
                Ext.getCmp("WorkEfficiency1value").setValue("5");
                }},
                handler:function(){
                Ext.getCmp('WorkEfficiency1').btnEl.setStyle('background-color',"red");
                Ext.getCmp('WorkEfficiency2').btnEl.setStyle('background-color',"red");
                Ext.getCmp('WorkEfficiency3').btnEl.setStyle('background-color',"red");
                Ext.getCmp('WorkEfficiency4').btnEl.setStyle('background-color',"red");
                Ext.getCmp('WorkEfficiency5').btnEl.setStyle('background-color',"red");
                Ext.getCmp("WorkEfficiency1value").setValue("5");
                var WorkEfficiencytype5="1";
                }}}]
								})),
			 Appraisalwindow.add(new Ext.form.TextField({
								id:"Attendancevalue",
								width : 150,
								hidden : true,
								fieldLabel:"���ڵ÷�"
								})),
				Appraisalwindow.add(new Ext.form.TextField({
								id:"WorkEfficiency1value",
								width : 150,
								hidden : true,
								fieldLabel:"����Ч�ʵ÷�"
								})),
			 Appraisalwindow.add(new Ext.form.TextField({
								id:"WorkAttitudevlaue",
								width : 150,
								hidden : true,
								fieldLabel:"����̬��"
								})),
				Appraisalwindow.add(new Ext.form.TextField({
								id:"OtherStaisvlaue",
								width : 150,
								hidden : true,
								fieldLabel:"��������"
								})),
			 Appraisalwindow.add(new Ext.form.TextField({
								id:"Rowid",
								width : 150,
								hidden : true,
								fieldLabel:"Rowid"
								}));
			Ext.getCmp("Rowid").setValue(AssRowid);
			 Appraisalwindow.add(new Ext.Panel({
			          layout:"form",
			          width:500,
		            height:5,
		            closable:"true",
		            buttonAlign:"center",
		            frame:true,     //�������  ��ɫΪǳɫ
		            labelWidth:40,   //������
		            tbar:[{id:'WorkAttitude',tooltip: "̬�������",text:"<img SRC='../scripts/Pmp/Image/APP1.gif'>̬�������"},
		            {xtype:"tbseparator"},
		            {id:'WorkAttitude1',tooltip: "̬�ȼ���",text:"<img SRC='../scripts/Pmp/Image/APP2.gif'>",
		            listeners: {
                mouseover: function(e) {
                Ext.getCmp('WorkAttitude1').btnEl.setStyle('background-color',"red");   //��ť������ɫ  
                Ext.getCmp('WorkAttitude2').btnEl.setStyle('background-color',"blue");
                Ext.getCmp('WorkAttitude3').btnEl.setStyle('background-color',"blue");
                Ext.getCmp('WorkAttitude4').btnEl.setStyle('background-color',"blue");
                Ext.getCmp('WorkAttitude5').btnEl.setStyle('background-color',"blue");
                Ext.getCmp("WorkAttitudevlaue").setValue("1");
                },
                handler:function(){
                Ext.getCmp('WorkAttitude1').btnEl.setStyle('background-color',"red");
                Ext.getCmp('WorkAttitude2').btnEl.setStyle('background-color',"blue");
                Ext.getCmp('WorkAttitude3').btnEl.setStyle('background-color',"blue");
                Ext.getCmp('WorkAttitude4').btnEl.setStyle('background-color',"blue");
                Ext.getCmp('WorkAttitude5').btnEl.setStyle('background-color',"blue");
                Ext.getCmp("WorkAttitudevlaue").setValue("1");
                }}},
		            {xtype:"tbseparator"},
		            {id:'WorkAttitude2',tooltip: "̬��һ��",text:"<img SRC='../scripts/Pmp/Image/APP2.gif'>",
		            listeners: {
                mouseover: function(e) {
                Ext.getCmp('WorkAttitude1').btnEl.setStyle('background-color',"red");   //��ť������ɫ  
                Ext.getCmp('WorkAttitude2').btnEl.setStyle('background-color',"red");
                Ext.getCmp('WorkAttitude3').btnEl.setStyle('background-color',"blue");
                Ext.getCmp('WorkAttitude4').btnEl.setStyle('background-color',"blue");
                Ext.getCmp('WorkAttitude5').btnEl.setStyle('background-color',"blue");
                Ext.getCmp("WorkAttitudevlaue").setValue("2");
                },
                handler:function(){
                Ext.getCmp('WorkAttitude1').btnEl.setStyle('background-color',"red");
                Ext.getCmp('WorkAttitude2').btnEl.setStyle('background-color',"red");
                Ext.getCmp('WorkAttitude3').btnEl.setStyle('background-color',"blue");
                Ext.getCmp('WorkAttitude4').btnEl.setStyle('background-color',"blue");
                Ext.getCmp('WorkAttitude5').btnEl.setStyle('background-color',"blue");
                Ext.getCmp("WorkAttitudevlaue").setValue("2");
                }}},
		            {xtype:"tbseparator"},
		            {id:'WorkAttitude3',tooltip: "̬�ȽϺ�",text:"<img SRC='../scripts/Pmp/Image/APP2.gif'>",
		            listeners: {
                mouseover: function(e) {
                Ext.getCmp('WorkAttitude1').btnEl.setStyle('background-color',"red");   //��ť������ɫ  
                Ext.getCmp('WorkAttitude2').btnEl.setStyle('background-color',"red");
                Ext.getCmp('WorkAttitude3').btnEl.setStyle('background-color',"red");
                Ext.getCmp('WorkAttitude4').btnEl.setStyle('background-color',"blue");
                Ext.getCmp('WorkAttitude5').btnEl.setStyle('background-color',"blue");
                Ext.getCmp("WorkAttitudevlaue").setValue("3");
                },
                handler:function(){
                Ext.getCmp('WorkAttitude1').btnEl.setStyle('background-color',"red");
                Ext.getCmp('WorkAttitude2').btnEl.setStyle('background-color',"red");
                Ext.getCmp('WorkAttitude3').btnEl.setStyle('background-color',"red");
                Ext.getCmp('WorkAttitude4').btnEl.setStyle('background-color',"blue");
                Ext.getCmp('WorkAttitude5').btnEl.setStyle('background-color',"blue");
                Ext.getCmp("WorkAttitudevlaue").setValue("3");
                }}},
		            {xtype:"tbseparator"},
		            {id:'WorkAttitude4',tooltip: "̬�Ⱥܺ�",text:"<img SRC='../scripts/Pmp/Image/APP2.gif'>",
		            listeners: {
                mouseover: function(e) {
                Ext.getCmp('WorkAttitude1').btnEl.setStyle('background-color',"red");   //��ť������ɫ  
                Ext.getCmp('WorkAttitude2').btnEl.setStyle('background-color',"red");
                Ext.getCmp('WorkAttitude3').btnEl.setStyle('background-color',"red");
                Ext.getCmp('WorkAttitude4').btnEl.setStyle('background-color',"red");
                Ext.getCmp('WorkAttitude5').btnEl.setStyle('background-color',"blue");
                Ext.getCmp("WorkAttitudevlaue").setValue("4");
                },
                handler:function(){
                Ext.getCmp('WorkAttitude1').btnEl.setStyle('background-color',"red");
                Ext.getCmp('WorkAttitude2').btnEl.setStyle('background-color',"red");
                Ext.getCmp('WorkAttitude3').btnEl.setStyle('background-color',"red");
                Ext.getCmp('WorkAttitude4').btnEl.setStyle('background-color',"yellow");
                Ext.getCmp('WorkAttitude5').btnEl.setStyle('background-color',"blue");
                Ext.getCmp("WorkAttitudevlaue").setValue("4"); 
                }}},
		            {xtype:"tbseparator"},
		            {id:'WorkAttitude5',tooltip: "̬�ȼ������",text:"<img SRC='../scripts/Pmp/Image/APP2.gif'>",
		            listeners: {
                mouseover: function(e) {
                Ext.getCmp('WorkAttitude1').btnEl.setStyle('background-color',"red");   //��ť������ɫ  
                Ext.getCmp('WorkAttitude2').btnEl.setStyle('background-color',"red");
                Ext.getCmp('WorkAttitude3').btnEl.setStyle('background-color',"red");
                Ext.getCmp('WorkAttitude4').btnEl.setStyle('background-color',"red");
                Ext.getCmp('WorkAttitude5').btnEl.setStyle('background-color',"red");
                Ext.getCmp("WorkAttitudevlaue").setValue("5");
                },
                handler:function(){
                Ext.getCmp('WorkAttitude1').btnEl.setStyle('background-color',"red");
                Ext.getCmp('WorkAttitude2').btnEl.setStyle('background-color',"red");
                Ext.getCmp('WorkAttitude3').btnEl.setStyle('background-color',"red");
                Ext.getCmp('WorkAttitude4').btnEl.setStyle('background-color',"red");
                Ext.getCmp('WorkAttitude5').btnEl.setStyle('background-color',"red");
                Ext.getCmp("WorkAttitudevlaue").setValue("5");
                }}}],
								bbar:[{id:'OtherStais',tooltip: "���������",text:"<img SRC='../scripts/Pmp/Image/APP1.gif'>���������"},
								{xtype:"tbseparator"},
								{id:'OtherStais1',tooltip: "����",text:"<img SRC='../scripts/Pmp/Image/APP2.gif'>",
		            listeners: {
                mouseover: function(e) {
                Ext.getCmp('OtherStais1').btnEl.setStyle('background-color',"red");   //��ť������ɫ  
                Ext.getCmp('OtherStais2').btnEl.setStyle('background-color',"blue");
                Ext.getCmp('OtherStais3').btnEl.setStyle('background-color',"blue");
                Ext.getCmp('OtherStais4').btnEl.setStyle('background-color',"blue");
                Ext.getCmp('OtherStais5').btnEl.setStyle('background-color',"blue");
                Ext.getCmp("OtherStaisvlaue").setValue("1");
                },
                handler:function(){
                Ext.getCmp('OtherStais1').btnEl.setStyle('background-color',"red");
                Ext.getCmp('OtherStais2').btnEl.setStyle('background-color',"blue");
                Ext.getCmp('OtherStais3').btnEl.setStyle('background-color',"blue");
                Ext.getCmp('OtherStais4').btnEl.setStyle('background-color',"blue");
                Ext.getCmp('OtherStais5').btnEl.setStyle('background-color',"blue");
                Ext.getCmp("OtherStaisvlaue").setValue("1");
                }}},
								{xtype:"tbseparator"},
								{id:'OtherStais2',tooltip: "�ϲ�",text:"<img SRC='../scripts/Pmp/Image/APP2.gif'>",
		            listeners: {
                mouseover: function(e) {
                Ext.getCmp('OtherStais1').btnEl.setStyle('background-color',"red");   //��ť������ɫ  
                Ext.getCmp('OtherStais2').btnEl.setStyle('background-color',"red");
                Ext.getCmp('OtherStais3').btnEl.setStyle('background-color',"blue");
                Ext.getCmp('OtherStais4').btnEl.setStyle('background-color',"blue");
                Ext.getCmp('OtherStais5').btnEl.setStyle('background-color',"blue");
                Ext.getCmp("OtherStaisvlaue").setValue("2");
                },
                handler:function(){
                Ext.getCmp('OtherStais1').btnEl.setStyle('background-color',"red");
                Ext.getCmp('OtherStais2').btnEl.setStyle('background-color',"red");
                Ext.getCmp('OtherStais3').btnEl.setStyle('background-color',"blue");
                Ext.getCmp('OtherStais4').btnEl.setStyle('background-color',"blue");
                Ext.getCmp('OtherStais5').btnEl.setStyle('background-color',"blue");
                Ext.getCmp("OtherStaisvlaue").setValue("2");
                }}},
								{xtype:"tbseparator"},
								{id:'OtherStais3',tooltip: "����",text:"<img SRC='../scripts/Pmp/Image/APP2.gif'>",
		            listeners: {
                mouseover: function(e) {
                Ext.getCmp('OtherStais1').btnEl.setStyle('background-color',"red");   //��ť������ɫ  
                Ext.getCmp('OtherStais2').btnEl.setStyle('background-color',"red");
                Ext.getCmp('OtherStais3').btnEl.setStyle('background-color',"red");
                Ext.getCmp('OtherStais4').btnEl.setStyle('background-color',"blue");
                Ext.getCmp('OtherStais5').btnEl.setStyle('background-color',"blue");
                Ext.getCmp("OtherStaisvlaue").setValue("3");
                },
                handler:function(){
                Ext.getCmp('OtherStais1').btnEl.setStyle('background-color',"red");
                Ext.getCmp('OtherStais2').btnEl.setStyle('background-color',"red");
                Ext.getCmp('OtherStais3').btnEl.setStyle('background-color',"red");
                Ext.getCmp('OtherStais4').btnEl.setStyle('background-color',"blue");
                Ext.getCmp('OtherStais5').btnEl.setStyle('background-color',"blue");
                Ext.getCmp("OtherStaisvlaue").setValue("3");
                }}},
								{xtype:"tbseparator"},
								{id:'OtherStais4',tooltip: "����",text:"<img SRC='../scripts/Pmp/Image/APP2.gif'>",
		            listeners: {
                mouseover: function(e) {
                Ext.getCmp('OtherStais1').btnEl.setStyle('background-color',"red");   //��ť������ɫ  
                Ext.getCmp('OtherStais2').btnEl.setStyle('background-color',"red");
                Ext.getCmp('OtherStais3').btnEl.setStyle('background-color',"red");
                Ext.getCmp('OtherStais4').btnEl.setStyle('background-color',"red");
                Ext.getCmp('OtherStais5').btnEl.setStyle('background-color',"blue");
                Ext.getCmp("OtherStaisvlaue").setValue("4");
                },
                handler:function(){
                Ext.getCmp('OtherStais1').btnEl.setStyle('background-color',"red");
                Ext.getCmp('OtherStais2').btnEl.setStyle('background-color',"red");
                Ext.getCmp('OtherStais3').btnEl.setStyle('background-color',"red");
                Ext.getCmp('OtherStais4').btnEl.setStyle('background-color',"red");
                Ext.getCmp('OtherStais5').btnEl.setStyle('background-color',"blue");
                Ext.getCmp("OtherStaisvlaue").setValue("4");
                }}},
								{xtype:"tbseparator"},
								{id:'OtherStais5',tooltip: "����",text:"<img SRC='../scripts/Pmp/Image/APP2.gif'>",
		            listeners: {
                mouseover: function(e) {
                Ext.getCmp('OtherStais1').btnEl.setStyle('background-color',"red");   //��ť������ɫ  
                Ext.getCmp('OtherStais2').btnEl.setStyle('background-color',"red");
                Ext.getCmp('OtherStais3').btnEl.setStyle('background-color',"red");
                Ext.getCmp('OtherStais4').btnEl.setStyle('background-color',"red");
                Ext.getCmp('OtherStais5').btnEl.setStyle('background-color',"red");
                Ext.getCmp("OtherStaisvlaue").setValue("5");
                },
                handler:function(){
                Ext.getCmp('OtherStais1').btnEl.setStyle('background-color',"red");
                Ext.getCmp('OtherStais2').btnEl.setStyle('background-color',"red");
                Ext.getCmp('OtherStais3').btnEl.setStyle('background-color',"red");
                Ext.getCmp('OtherStais4').btnEl.setStyle('background-color',"red");
                Ext.getCmp('OtherStais5').btnEl.setStyle('background-color',"red");
                Ext.getCmp("OtherStaisvlaue").setValue("5");
                }}}]
								})),
				Appraisalwindow.add(new Ext.Panel({
			          	 renderTo:Ext.getBody(),
			          	 title:'��������',
				           width:500,
				           height:180,
				           layout:'column',
				           Resizable:'yes',
				    			 items:[{xtype:'htmleditor',id:'AppMenu'}]})),
				Appraisalwindow.add(new Ext.Panel({
			          	 renderTo:Ext.getBody(),
				           width:500,
				           title:'�������',
				           height:180,
				           layout:'column',
				           Resizable:'yes',
				    			 items:[{xtype:'htmleditor',id:'AppProposal'}]}))
								}}
			}).show();
}
//���ؿ�����ϸ���ݽ���
function DevDetail(detailRowid,detailname,detailTel,detailEmail,detailProduct,detailInDate,detailInTime,detailOutDate,detailOutTime,detailBusine){
var mywindow=new Ext.Window({
			  title:"������ϸ��Ϣ",
			  layout:"form",
			  width:550,
		    height:500,
		    frame:true, 
		    plain:true,
		    minimizable:true,
		    //maximizable:true,
		    closable:"true",
		    buttonAlign:"center",
		    bodyStyle:"padding:7px",
		    //defaults:{xtype:"textfield",width:180},
		    frame:true,     //�������  ��ɫΪǳɫ
		    labelWidth:70,  //������
		    tbar:[{
		           text:"<img SRC='../scripts/Pmp/Image/save.gif'>�� ��",tooltip: "�޸Ŀ���������Ϣ",
		           handler:function(){
		                   var OldData=detailRowid+"^"+detailname+"^"+detailTel+"^"+detailEmail+"^"+detailProduct+"^"+detailInDate+"^"+detailInTime+"^"+detailOutDate+"^"+detailOutTime+"^"+detailBusine;
		                   var UpdateRowid=Ext.getCmp("DetailRowid").value;
		                   var UpdateNamec=Ext.getCmp("DetailName").value;
			                 var UpdateTelc=Ext.getCmp("DetailTel").value;
			                 var UpdateEmailc=Ext.getDom("DetailEmail").value;
			                 var UpdateProductc=Ext.getDom("DetailProduct").value;
			                 var UpdateBusinessReasonc=Ext.getCmp("DetailBusine").getValue();
			                 var UpdateInDatec=Ext.getCmp('DetailInDate').value;
			                 var UpdateInTimec=Ext.getCmp('DetailInTime').value;
			                 var UpdateOutDatec=Ext.getCmp('DetailOutDate').value;
			                 var UpdateOutTimec=Ext.getCmp('DetailOutTime').value;
			                 if(UpdateRowid==""){
			                 Ext.Msg.alert('��ܰ��ʾ',"�����¼������ݣ�");
			                 return;
			                        };
			                 if((UpdateNamec=="")||(UpdateNamec=="null")||(UpdateNamec=="����������")){
			                 Ext.Msg.alert('��ܰ��ʾ',"������������Ϊ�գ�");
			                 return;
			                        };
			                 if((UpdateTelc=="")||(UpdateTelc=="null")||(UpdateTelc=="��������ϵ��ʽ")){
			                 Ext.Msg.alert('��ܰ��ʾ',"��ϵ��ʽ����Ϊ�գ�");
			                 return;
			                        };
			                 if((UpdateProductc=="")||(UpdateProductc=="null")||(UpdateProductc=="undefined")){
			                 Ext.Msg.alert('��ܰ��ʾ',"����������Ϊ�գ�");
			                 return;
			                        };
			                 if((UpdateInDatec=="")||(UpdateInDatec=="null")||(UpdateInDatec=="undefined")){
			                 Ext.Msg.alert('��ܰ��ʾ',"�������ڲ���Ϊ�գ�");
			                 return;
			                        };
			                 if((UpdateInTimec=="")||(UpdateInTimec=="null")||(UpdateInTimec=="undefined")){
			                 Ext.Msg.alert('��ܰ��ʾ',"����ʱ�䲻��Ϊ�գ�");
			                 return;
			                        };
			                 if(UpdateOutDatec=="undefined"){var UpdateOutDatec="";};
			                 if(UpdateOutTimec=="undefined"){var UpdateOutTimec="";};
			                 var NewDate=UpdateRowid+"^"+UpdateNamec+"^"+UpdateTelc+"^"+UpdateEmailc+"^"+UpdateProductc+"^"+UpdateInDatec+"^"+UpdateInTimec+"^"+UpdateOutDatec+"^"+UpdateOutTimec+"^"+UpdateBusinessReasonc;
			                 if(OldData==NewDate){
			                 Ext.Msg.alert('��ܰ��ʾ','��δ�޸��κ�����,���ø��£�');
			                 return;};
			                 InPut=UpdateNamec+"^"+UpdateTelc+"^"+UpdateEmailc+"^"+UpdateProductc+"^"+UpdateInDatec+"^"+UpdateInTimec+"^"+UpdateOutDatec+"^"+UpdateOutTimec+"^"+UpdateBusinessReasonc;
			                 UpdateDetail(NewDate);
			                 getDetail(InPut);
			                 mywindow.close();
		                   }},
		          {xtype:"tbseparator"},
		          {
		           text:"<img SRC='../scripts/Pmp/Image/add16.gif'>�� ��",tooltip: "�������",
		           handler:function(){
		                   var UpdateNamec=Ext.getDom("DetailName").value;
			                 var UpdateTelc=Ext.getDom("DetailTel").value;
			                 var UpdateEmailc=Ext.getDom("DetailEmail").value;
			                 var UpdateProductc=Ext.getDom("DetailProduct").value;
		                   var Str="  ������"+UpdateNamec+"   �绰��"+UpdateTelc+" "+UpdateEmailc+"   ��Ʒ�飺"+UpdateProductc;
                       DevAddAppraisal(Str,detailRowid);
                       mywindow.close();
		                   }},
		          {xtype:"tbseparator"},
		          {
		           text:"<img SRC='../scripts/Pmp/Image/eb_find.gif'>�鿴����",
		           handler:function(){
		                   Ext.Msg.alert('��ʾ','�ù������ڿ����С�����');
		                   }},
		          {xtype:"tbseparator"},
		          {
		           text:"<img SRC='../scripts/Pmp/Image/reset.gif'>ɾ����¼",tooltip: "ɾ����������",
		           handler:function(){
		                   var DeleteRowid=Ext.getDom("DetailRowid").value;
		                   if(DeleteRowid==""){
			                 Ext.Msg.alert('��ܰ��ʾ',"�����¼������ݣ�");
			                 return;
			                        };
			                 Ext.MessageBox.confirm('ɾ��ȷ��','���Ƿ�Ҫɾ���������ݣ�',function(btn)
						                {
							               if(+btn=="yes"){
							                return;
							                DeleteDetail(DeleteRowid);
			                        //getDetail();
			                        var InPut=""
			                        getDetail(InPut);
			                         mywindow.close();
			                         }
							                });
			                 
		                   }},
		          {xtype:"tbseparator"},
		          {
		           text:"<img SRC='../scripts/Pmp/Image/arrow_left.gif'>�� ��",tooltip: "������һ��",
		           handler:function(){
		                   mywindow.close();
		                   }}],
		    listeners:{
				"render":function(mywindow){
				      mywindow.add(new Ext.form.TextField({
								id:"DetailRowid",
								width : 430,
								hidden : true,
								fieldLabel:"DetailRowid"
								})),
							mywindow.add(new Ext.form.TextField({
								id:"DetailName",
								emptyText:'����������',
								width : 430,
								fieldLabel:"��������"

								})),
							mywindow.add(new Ext.form.TextField({
									id:"DetailTel",
									width : 430,
									regex:  /^\d+(\.\d{1,2})?$/,
                  regexText: '��������ȷ����������',
                  vtype: 'alphanum',
								  fieldLabel:"��ϵ��ʽ"
									})),
							mywindow.add(new Ext.form.TextField({
									id:"DetailEmail",
									width : 430,
									regex: /^\s*\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*(\;\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*)*(\;)*\s*$/,
									regexText: '��������ȷ�ĵ��������ַ',
								  fieldLabel:"��������"
									})),
							mywindow.add(new Ext.form.ComboBox({
									id:"DetailProduct",
									width : 430,
								  fieldLabel:"������",
								  name:'DetailProduct',
								  mode : 'local',
								  //triggerAction : 'all', 
								  store : SelectProduct,   //��ȡ����
                  valueField : 'RowId',   //��ֵ̨
                  displayField : 'Description',   //������ʾֵ
                  valueNotFoundText : '',
                  params:{InPut:'DetailProduct'}   //��β���ֵ
                                    })),
							mywindow.add(new Ext.form.DateField({
									id:"DetailInDate",
									width : 430,
								    fieldLabel:'��������',
								    enableKeyEvents : true,
	                                emptyText:'��ѡ������',
	                                format:'Y-m-d',
	                                value:new Date().add(Date.DAY,0),
	                                disabledDays:[0,6]
									})),
							mywindow.add(new Ext.form.TimeField({
									id:"DetailInTime",
								    fieldLabel:'����ʱ��',
								    renderTo: Ext.get('times'), 
								    width : 430,
	                                emptyText:'��ѡ��ʱ��',
	                                regex : /^(0\d{1}|1\d{1}|2[0-3]):[0-5]\d{1}:([0-5]\d{1})$/,
		                              regexText:'ʱ���ʽ������ȷ��ʽhh:mm:ss',
	                                autoShow: true,
	                                format: 'H:i:s',
	                                increment:1    //ʱ����
									})),
							mywindow.add(new Ext.form.DateField({
									id:"DetailOutDate",
									width : 430,
								    fieldLabel:'�뿪����',
								    enableKeyEvents : true,
	                                //emptyText:'��ѡ������',
	                                format:'Y-m-d',
	                                //value:new Date().add(Date.DAY,0),
	                                disabledDays:[0,6]
									})),
							mywindow.add(new Ext.form.TimeField({
									id:"DetailOutTime",
								    fieldLabel:'�뿪ʱ��',
								    renderTo: Ext.get('times'), 
								    width : 430,
	                                //emptyText:'��ѡ��ʱ��',
	                                regex : /^(0\d{1}|1\d{1}|2[0-3]):[0-5]\d{1}:([0-5]\d{1})$/,
		                              regexText:'ʱ���ʽ������ȷ��ʽhh:mm:ss',
		                              autoShow: true,
	                                format: 'H:i:s',
	                                increment:1
									})),
							mywindow.add(new Ext.Panel({
			          	 renderTo:Ext.getBody(),
				           width:510,
				           height:300,
				           layout:'column',
				           Resizable:'yes',
				    			items:[{xtype:'htmleditor',id:'DetailBusine'}]}))
									}}
			}).show();
			//detailRowid,detailname,detailTel,detailEmail,detailProduct,detailInDate,detailInTime,detailOutDate,detailOutTime,detailBusine
			if(detailBusine!=""){
			SelectProductId(detailProduct);
			//alert(ProductId);
			}
			//alert(rec.get('DetailName')+"11111111");
			
			Ext.getCmp("DetailRowid").setValue(detailRowid);
			Ext.getCmp("DetailName").setValue(detailname);
			Ext.getCmp("DetailTel").setValue(detailTel);
			Ext.getCmp("DetailEmail").setValue(detailEmail);
			Ext.getCmp("DetailBusine").setValue(detailBusine);
			var detailInDateid = new Date(Date.parse(detailInDate.replace(/-/g,"/")));  
      Ext.getCmp("DetailInDate").setValue(detailInDateid.format('Y-m-d'));
      var detailOutDateid = new Date(Date.parse(detailOutDate.replace(/-/g,"/")));  
      Ext.getCmp("DetailOutDate").setValue(detailOutDateid.format('Y-m-d'));
      Ext.getCmp("DetailInTime").setValue(detailInTime);
      Ext.getCmp("DetailOutTime").setValue(detailOutTime);
}

//��ѯ��Ʒ��ID
function SelectProductId(detailProduct){
        var url = "PMP.Common.csp?actiontype=SelectProductId&InPut="+detailProduct;
				Ext.Ajax.request({
							url : url,
							method : 'POST',
							waitMsg : '���ݴ�����...',
							success : function(result, request) {
								var jsonData = Ext.util.JSON
										.decode(result.responseText);
								var ret=jsonData.info;
								if (jsonData.success == 'true') {
								//Ext.Msg.alert("success", ret);
											//addComboData(Ext.getCmp("DetailProduct").getStore(),ret,detailProduct);
              			Ext.getCmp("DetailProduct").setValue(ret);  //��Ʒ�鸳ֵ
									
								} else {
							if(ret==-1){
										Ext.Msg.alert("error", "�ֵ����޴˲�Ʒ��");
										return;
									}
								}
							},
							scope : this
						});
}
//��ѯ��Ʒ��ID
function SelectProductIdId(detailProduct){
        var url = "PMP.Common.csp?actiontype=AddDetailTypeid&InPut="+detailProduct;
				Ext.Ajax.request({
							url : url,
							method : 'POST',
							waitMsg : '���ݴ�����...',
							success : function(result, request) {
								var jsonData = Ext.util.JSON
										.decode(result.responseText);
								var ret=jsonData.info;
								if (jsonData.success == 'true') {
								//Ext.Msg.alert("success", ret);
											//addComboData(Ext.getCmp("DetailProduct").getStore(),ret,detailProduct);
              			Ext.getCmp("AddDetailType").setValue(ret);  //��Ʒ�鸳ֵ
									
								} else {
							if(ret==-1){
										Ext.Msg.alert("error", "�ֵ����޴˲�Ʒ��");
										return;
									}
								}
							},
							scope : this
						});
}
function UpdateDetail(NewDate){
        var url = "PMP.Common.csp?actiontype=UpdateDetail&InPut="+NewDate;
				Ext.Ajax.request({
							url : url,
							method : 'POST',
							waitMsg : '���ݴ洢��..',
							success : function(result, request) {
								var jsonData = Ext.util.JSON
										.decode(result.responseText);
								if (jsonData.success == 'true') {
									Ext.Msg.alert("success", "���ݸ��³ɹ�!");
									//clearData();
								} else {
									var ret=jsonData.info;
									if(ret==-1){
										Ext.Msg.alert("error", "���ݸ���ʧ��!"+ret);
									}
								}
							},
							scope : this
						});
}
function DeleteDetail(DeleteRowid){
        var url = "PMP.Common.csp?actiontype=DeleteDetail&InPut="+DeleteRowid;
				Ext.Ajax.request({
							url : url,
							method : 'POST',
							waitMsg : '���ݴ洢��..',
							success : function(result, request) {
								var jsonData = Ext.util.JSON
										.decode(result.responseText);
								if (jsonData.success == 'true') {
									Ext.Msg.alert("success", "����ɾ���ɹ�!");
									//clearData();
								} else {
									var ret=jsonData.info;
										Ext.Msg.alert("error", "����ɾ��ʧ��!  "+ret);	
								}
							},
							scope : this
						});
}
function AddDevDetail(AdddetailRowid,SubRowid,Adddetailname,AdddetailTel,AdddetailEmail,AdddetailProduct,AdddetailInDate,AdddetailInTime,AdddetailOutDate,AdddetailOutTime,AdddetailBusine,SubType,type){
   var UserMenu="  ������"+Adddetailname+"   �绰��"+AdddetailTel+" "+AdddetailEmail+"   ��Ʒ�飺"+AdddetailProduct;
   var Addwindow=new Ext.Window({
			  title:"��ӿ������Ӽ�¼",
			  layout:"form",
			  width:550,
		    height:410,
		    frame:true, 
		    plain:true,
		    minimizable:true,
		    //maximizable:true,
		    closable:"true",
		    buttonAlign:"center",
		    bodyStyle:"padding:7px",
		    //defaults:{xtype:"textfield",width:180},
		    frame:true,     //�������  ��ɫΪǳɫ
		    labelWidth:70,  //������
		    tbar:[{
		           text:"<img SRC='../scripts/Pmp/Image/save.gif'>����",tooltip: "ȷ����Ӹ�����Ϣ",
		           handler:function(){
		                   var AddDevRowid=Ext.getDom("AddDetailRowid").value;
			                 var AddDevType=Ext.getDom("AddDetailType").value;
			                 var AddDevMenu=Ext.getCmp("AddDetailMenu").getValue();
			                 if(AddDevRowid==""){
			                 Ext.Msg.alert('��ܰ��ʾ','������ѡ������');
			                 return;};
			                 if((AddDevType=="")||(AddDevType=="undefind")){
			                 Ext.Msg.alert('��ܰ��ʾ','��ѡ�������������');
			                 return;};
			                 if((AddDevMenu=="")||(AddDevMenu=="undefind")){
			                 Ext.Msg.alert('��ܰ��ʾ','����д����');
			                 return;};
			                 //alert(AddDevRowid+"^"+AddDevType+"^"+AddDevMenu);
			                 AddDetailNenu(AddDevRowid,AddDevType,AddDevMenu,type,SubRowid);
			                 Addwindow.close();
		                   }},
		          {xtype:"tbseparator"},{
		           text:"<img SRC='../scripts/Pmp/Image/user.gif'>"+UserMenu,tooltip: UserMenu}],
		    listeners:{
				"render":function(Addwindow){
				      Addwindow.add(new Ext.form.TextField({
								id:"AddDetailRowid",
								width : 200,
								hidden : true,
								fieldLabel:"AddDetailRowid"
								})),
							Addwindow.add(new Ext.form.ComboBox({
								id:"AddDetailType",
								width : 200,
								fieldLabel:"�������",
								emptyText:'��ѡ�������������',
								name:'AddDetailType',
							  mode : 'local',
								store : AddDetailType,   //��ȡ����
                valueField : 'RowId',   //��ֵ̨
                displayField : 'Description',   //������ʾֵ
                valueNotFoundText : '',
                params:{InPut:'AddDetailType'}   //��β���ֵ
								})),
							Addwindow.add(new Ext.Panel({
			          renderTo:Ext.getBody(),
				        width:510,
				        height:300,
				        title:'��ϸ����',
				        layout:'column',
				        Resizable:'yes',
				    	  items:[{xtype:'htmleditor',id:'AddDetailMenu'}]}))
								}}
		    }).show();    
		    Ext.getCmp("AddDetailRowid").setValue(AdddetailRowid);  
		    if(type=="Update"){
		    Ext.getCmp("AddDetailMenu").setValue(AdddetailBusine); 
		    SelectProductIdId(SubType);
		    }; 
}
function AddDetailNenu(AddDevRowid,AddDevType,AddDevMenu,type,SubRowid){
        var url = "PMP.Common.csp?actiontype=AddDetailNenu&AddDevRowid="+AddDevRowid+"&AddDevType="+AddDevType+"&AddDevMenu="+AddDevMenu+"&type="+type+"&SubRowid="+SubRowid;
				//alert(url);
				Ext.Ajax.request({
							url : url,
							method : 'POST',
							waitMsg : '���ݴ洢��..',
							success : function(result, request) {
								var jsonData = Ext.util.JSON
										.decode(result.responseText);
								if (jsonData.success == 'true') {
									Ext.Msg.alert("success", "���ݸ��³ɹ�!");
									//clearData();
								} else {
									var ret=jsonData.info;
									if(ret==-1){
										Ext.Msg.alert("error", "���ݸ���ʧ��!"+ret);
									}
								}
							},
							scope : this
						});
}
function ImListMenu(ImNRowidC,ImNNameC,ImNStatusC,ImNCreatDateC,ImNCreatUserC,ImNCreateLocC,ImNCreateTelC,ImNMenuC,ImNSituationC,ImNStandby3C,ImNEmergencyC,ImNCodeC,ImNTypeC,ImNDegreeC){
        //alert("��������");
 //����������ϸ��Ϣ 
  var AdjunctFlagnm=new Ext.grid.RowNumberer();
	var AdjunctFlagsm=new Ext.grid.CheckboxSelectionModel(); 
	var AdjunctFlagCm=new Ext.grid.ColumnModel([AdjunctFlagnm,
	  {
	    header:'AdjunctFlagRowid',
			dataIndex:'AdjunctFlagRowid',
			width:60,
			sortable:true,
			hidden : true
		},{
		  header:'�ļ�����',
			dataIndex:'AdjunctFlagName',
			width:220,
			sortable:true
		},{
		  header:'�ϴ�ʱ��',
			dataIndex:'AdjunctFlagTime',
			width:140,
			sortable:true
		},{
		  header:'�ϴ���',
			dataIndex:'AdjunctFlagUser',
			width:140,
			sortable:true
		},{
		  header:'�ϴ�����',
			dataIndex:'AdjunctFlagType',
			width:120,
			sortable:true
		},{
		  header:'����',
			dataIndex:'AdjunctFlagdetail',
			width:60,
			sortable:true,
			xtype:'actioncolumn',
			items:[{xtype:"tbfill"},{
      icon:'../scripts/Pmp/Image/download1.gif',tooltip: "����",handler:function(AdjunctFlagGrid, rowIndex, colIndex){
       var rec = AdjunctFlagGrid.getStore().getAt(rowIndex);
       Ext.Msg.alert('��ܰ��ʾ','�ù������ڿ����С�������');
       }}]}]);
	var AdjunctFlagToolBar=new Ext.PagingToolbar({
		id:'AdjunctFlagToolBar',
		store:AdjunctFlagStore,
		displayInfo:true,
		pageSize:5,
		displayMsg:"��ǰ��¼{0}---{1}��  ��{2}����¼",
		emptyMsg:"û������",
		firstText:'��һҳ',
		lastText:'���һҳ',
		prevText:'��һҳ',
		refreshText:'ˢ��',
		nextText:'��һҳ'		
	});
	var AdjunctFlagGrid=new Ext.grid.GridPanel({
		id:'AdjunctFlagGrid',
		height : 160,
		title:'�����б�',
		store:AdjunctFlagStore,
		loadMask:true,
		cm:AdjunctFlagCm,
		params:{InPut:'InPut'},
		sm:new Ext.grid.RowSelectionModel({singleSelect:true}),
		bbar:AdjunctFlagToolBar
	});
var Improvementwindow=new Ext.Window({
			  title:"��������",
			  layout:"column",
			  width:750,
		    height:630,
		    frame:true, 
		    plain:true,
		    minimizable:true,
		    //maximizable:true,
		    closable:"true",
		    //buttonAlign:"center",
		    bodyStyle:'margin-left:5',
		    //defaults:{xtype:"textfield",width:180},
		    frame:true,     //�������  ��ɫΪǳɫ
		    labelWidth:50,  //������
         listeners:{
				"render":function(Improvementwindow){
				  Improvementwindow.add(new Ext.form.FormPanel({
				              labelAlign:'left',    
                              labelWidth:60,  
                              buttonAlign:'center',  
                              frame:true,  
                              width:730,  
                              items:[{  
                                    layout:'column',
                                    items:[{  
                                    columnWidth:.66,  
                                    layout:'form',  
                                    //xtype:'fieldset',  
                                    //autoHeight:true,  
                                    defaultType:'textfield',   
                                    items:[{id:'ImprovementName',width:365,fieldLabel:'����'}]
                                    },{  
                                    columnWidth:.33,  
                                    layout:'form',  
                                    //xtype:'fieldset',  
                                    autoHeight:true,  
                                    defaultType:'textfield',   
                                    items:[{id:'ImprovementCode',width:160,fieldLabel:'���'}]}
                                    ]},{
                                    layout:'column',
                                    items:[{  
                                    columnWidth:.33,  
                                    layout:'form',  
                                    //xtype:'fieldset',  
                                    //autoHeight:true,  
                                    defaultType:'textfield',   
                                    items:[{id:'ImprovementStatus',width:140,fieldLabel:'״̬'}]
                                    },{  
                                    columnWidth:.33,  
                                    layout:'form',  
                                    //xtype:'fieldset',  
                                    autoHeight:true,  
                                    defaultType:'textfield',   
                                    items:[{id:'ImprovementCreatDate',width:130,fieldLabel:'����ʱ��'}]},
                                    {  
                                    columnWidth:.33,  
                                    layout:'form',  
                                    //xtype:'fieldset',  
                                    autoHeight:true,  
                                    defaultType:'textfield',   
                                    items:[{id:'ImprovementCreateLoc',width:160,fieldLabel:'�������'}]}]
                                    },{
                                    layout:'column',
                                    items:[{  
                                    columnWidth:.33,  
                                    layout:'form',  
                                    //xtype:'fieldset',  
                                    //autoHeight:true,  
                                    defaultType:'textfield',   
                                    items:[{id:'ImprovementCreateUser',width:140,fieldLabel:'�����û�'}]
                                    },{  
                                    columnWidth:.33,  
                                    layout:'form',  
                                    //xtype:'fieldset',  
                                    autoHeight:true,  
                                    defaultType:'textfield',   
                                    items:[{id:'ImprovementCreateTel',width:130,fieldLabel:'��ϵ��ʽ'}]},
                                    {  
                                    columnWidth:.33,  
                                    layout:'form',  
                                    //xtype:'fieldset',  
                                    autoHeight:true,  
                                    defaultType:'textfield',   
                                    items:[{id:'ImprovementMenu',width:160,fieldLabel:'�����˵�'}]}]
                                    },{
                                    layout:'column',
                                    items:[{  
                                    columnWidth:.33,  
                                    layout:'form',  
                                    //xtype:'fieldset',  
                                    //autoHeight:true,  
                                    defaultType:'textfield',   
                                    items:[{id:'ImprovementDegree',width:140,fieldLabel:'���س̶�'}]
                                    },{  
                                    columnWidth:.33,  
                                    layout:'form',  
                                    //xtype:'fieldset',  
                                    autoHeight:true,  
                                    defaultType:'textfield',   
                                    items:[{id:'ImprovementEmergency',width:130,fieldLabel:'�����̶�'}]},
                                    {  
                                    columnWidth:.33,  
                                    layout:'form',  
                                    //xtype:'fieldset',  
                                    autoHeight:true,  
                                    defaultType:'textfield',   
                                    items:[{id:'ImprovementModule',width:160,fieldLabel:'����ģ��'}]}]
                                    },{
                                    layout:'column',
                                    items:[{  
                                    columnWidth:.33,  
                                    layout:'form',  
                                    //xtype:'fieldset',  
                                    //autoHeight:true,  
                                    defaultType:'textfield',   
                                    items:[{id:'ImprovementAsEngi',width:140,fieldLabel:'����ʦ'}]
                                    },{  
                                    columnWidth:.33,  
                                    layout:'form',  
                                    //xtype:'fieldset',  
                                    autoHeight:true,  
                                    defaultType:'textfield',   
                                    items:[{id:'ImprovementStandby2',width:130,fieldLabel:'��ͨ��Ա'}]},
                                    {  
                                    columnWidth:.33,  
                                    layout:'form',  
                                    //xtype:'fieldset',  
                                    autoHeight:true,  
                                    defaultType:'textfield',   
                                    items:[{id:'ImprovementStandby4',width:160,fieldLabel:'��ͨ���'}]}]
                                    },{  
                                    xtype:'fieldset',  
                                    autoHeight:true,  
                                    id:'ImprovementSituation',
                                    title:'��������',  
                                    items:[{  
                                    width:600,  
                                    height:80,  
                                    xtype:'textarea'}]
                                    },{  
                                    xtype:'fieldset',  
                                    autoHeight:true,  
                                    id:'ImprovementStandby3',
                                    title:'Ҫ��Ч��',  
                                    items:[{  
                                    width:600,  
                                    height:80,  
                                    xtype:'textarea'}]
                                    },AdjunctFlagGrid 
        ]}))
								}}
								}).show();
		//ImNStatusC,ImNCreatDateC,ImNCreatUserC,ImNCreateLocC,ImNCreateTelC,ImNMenuC,ImNSituationC,ImNStandby3C,ImNEmergencyC,ImNCodeC,ImNTypeC,ImNDegreeC
		Ext.getCmp("ImprovementName").setValue(ImNNameC);
		Ext.getCmp("ImprovementCode").setValue(ImNCodeC);
		Ext.getCmp("ImprovementStatus").setValue(ImNStatusC);
		Ext.getCmp("ImprovementCreatDate").setValue(ImNCreatDateC);
		Ext.getCmp("ImprovementCreateLoc").setValue(ImNCreateLocC);
		Ext.getCmp("ImprovementCreateUser").setValue(ImNCreatUserC);
		Ext.getCmp("ImprovementCreateTel").setValue(ImNCreateTelC);
		Ext.getCmp("ImprovementMenu").setValue(ImNMenuC);
		Ext.getCmp("ImprovementDegree").setValue(ImNDegreeC);
		Ext.getCmp("ImprovementEmergency").setValue(ImNEmergencyC);
		Ext.getCmp("ImprovementModule").setValue("");
		document.getElementById("ImprovementStandby3").value=ImNStandby3C;
		document.getElementById("ImprovementSituation").value=ImNSituationC;
		//Ext.getCmp("ImprovementStandby3").setValue(ImNStandby3C);
		//Ext.getCmp("ImprovementSituation").setValue(ImNSituationC);
		AdjunctFlagStore.removeAll();
	  AdjunctFlagStore.load({params:{InPut:ImNRowidC}});
}
function AddAppraisal(Rowidvlaue,str){
   if(Rowidvlaue==""){
   Ext.Msg.alert('��ܰ��ʾ','δѡ������');
   return;
   };
   var url = "PMP.Common.csp?actiontype=AddAppraisal&Rowidvlaue="+Rowidvlaue+"&InPut="+str;
				//alert(url);
				Ext.Ajax.request({
							url : url,
							method : 'POST',
							waitMsg : '���ݴ洢��..',
							success : function(result, request) {
								var jsonData = Ext.util.JSON
										.decode(result.responseText);
								if (jsonData.success == 'true') {
								  DetailStore.removeAll();
			            DetailStore.load({params:{InPut:Rowidvlaue}});
			            ImListNStore.removeAll();
			            ImListNStore.load({params:{InPut:Rowidvlaue}});
			            ImListStore.removeAll();
			            ImListStore.load({params:{InPut:Rowidvlaue}});
			            SelectDevDetail("","","","","","","","","");
									Ext.Msg.alert("success", "���ݸ��³ɹ�!");
									//clearData();
								} else {
									var ret=jsonData.info;
									if(ret==-1){
										Ext.Msg.alert("error", "���ݸ���ʧ��!"+ret);
									}
								}
							},
							scope : this
						});
}
function SelectUser(userId,DevRowid,Str,AssRowid){
var url = "PMP.Common.csp?actiontype=SelectUser&userId="+userId+"&DevRowid="+DevRowid;
				//alert(url);
				Ext.Ajax.request({
							url : url,
							method : 'POST',
							waitMsg : '���ݴ洢��..',
							success : function(result, request) {
								var jsonData = Ext.util.JSON
										.decode(result.responseText);
										var ret=jsonData.info;
								if (jsonData.success == 'true') {
									//Ext.Msg.alert("success", "���ݲ����ɹ�!"+ret);
									if(ret=="1"){
									Ext.MessageBox.confirm('��ʾ','���Ѿ����۹����Ƿ�Ҫ�������ۣ�',function(btn){
							   if(btn=="yes"){
							   DevAddAppraisal(Str,AssRowid);
							   }
							   else {
							   return;
							   }
							})
									};
									if(ret=="0"){
									DevAddAppraisal(Str,AssRowid);
									};
									//clearData();
								} else {
									if(ret==-1){
										Ext.Msg.alert("error", "���ݸ���ʧ��!"+ret);
									}
								}
							},
							scope : this
						});
}