///PMP.DevelopControl.js ///张枕平--2015-03-11--项目管理--开发人员管理

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
   
  //创建已完成需求列表
  var Imnm=new Ext.grid.RowNumberer();
	var Imsm=new Ext.grid.CheckboxSelectionModel(); 
	var ImListCm=new Ext.grid.ColumnModel([Imnm,
	  { header:'ImRowid',
			dataIndex:'ImRowid',
			width:60,
			sortable:true,
			hidden : true
	  },{
	    header:'操作',
			dataIndex:'ImOperation',
			width:30,
			sortable:true,
			xtype:'actioncolumn',
			items:[{xtype:"tbfill"},{
      icon:'../scripts/Pmp/Image/album.gif',tooltip: "查看详情",handler:function(ImListGrid, rowIndex, colIndex){
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
      header:'需求名称',
			dataIndex:'ImName',
			width:150,
			sortable:true
		 },{
      header:'需求状态',
			dataIndex:'ImStatus',
			width:100,
			sortable:true
     },{
      header:'创建日期',
			dataIndex:'ImCreatDate',
			width:100,
			sortable:true
     },{
      header:'创建用户',
			dataIndex:'ImCreatUser',
			width:60,
			sortable:true
		 },{
      header:'创建科室',
			dataIndex:'ImCreateLoc',
			width:60,
			sortable:true
		},{
      header:'创建电话',
			dataIndex:'ImCreateTel',
			width:60,
			sortable:true
		 },{
      header:'所属菜单',
			dataIndex:'ImMenu',
			width:60,
			sortable:true
		},{
      header:'问题现状',
			dataIndex:'ImSituation',
			width:60,
			sortable:true
		},{
      header:'要求效果',
			dataIndex:'ImStandby3',
			width:100,
			sortable:true
		},{
      header:'紧急程度',
			dataIndex:'ImEmergency',
			width:60,
			sortable:true
		},{
      header:'需求编码',
			dataIndex:'ImCode',
			width:60,
			sortable:true
		},{
      header:'需求类型',
			dataIndex:'ImType',
			width:60,
			sortable:true
		},{
      header:'严重程度',
			dataIndex:'ImDegree',
			width:60,
			sortable:true
		}]);
	var ImListToolBar=new Ext.PagingToolbar({
		id:'ImListToolBar',
		store:ImListStore,
		displayInfo:true,
		pageSize:20,
		displayMsg:"当前记录{0}---{1}条  共{2}条记录",
		emptyMsg:"没有数据",
		firstText:'第一页',
		lastText:'最后一页',
		prevText:'上一页',
		refreshText:'刷新',
		nextText:'下一页'		
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
	
	//创建未完成需求列表
	var ImNnm=new Ext.grid.RowNumberer();
	var ImNsm=new Ext.grid.CheckboxSelectionModel(); 
	var ImListNCm=new Ext.grid.ColumnModel([ImNnm,
	  { header:'ImNRowid',
			dataIndex:'ImNRowid',
			width:60,
			sortable:true,
			hidden : true
	  },{
	    header:'操作',
			dataIndex:'ImNOperation',
			width:30,
			sortable:true,
			xtype:'actioncolumn',
			items:[{xtype:"tbfill"},{
      icon:'../scripts/Pmp/Image/album.gif',tooltip: "查看详情",handler:function(ImListNGrid, rowIndex, colIndex){
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
      header:'需求名称',
			dataIndex:'ImNName',
			width:150,
			sortable:true
		 },{
      header:'需求状态',
			dataIndex:'ImNStatus',
			width:100,
			sortable:true
     },{
      header:'创建日期',
			dataIndex:'ImNCreatDate',
			width:100,
			sortable:true
     },{
      header:'创建用户',
			dataIndex:'ImNCreatUser',
			width:60,
			sortable:true
		 },{
      header:'创建科室',
			dataIndex:'ImCreateLoc',
			width:60,
			sortable:true
		},{
      header:'创建电话',
			dataIndex:'ImNCreateTel',
			width:60,
			sortable:true
		 },{
      header:'所属菜单',
			dataIndex:'ImNMenu',
			width:60,
			sortable:true
		},{
      header:'问题现状',
			dataIndex:'ImNSituation',
			width:60,
			sortable:true
		},{
      header:'要求效果',
			dataIndex:'ImNStandby3',
			width:100,
			sortable:true
		},{
      header:'紧急程度',
			dataIndex:'ImNEmergency',
			width:60,
			sortable:true
		},{
      header:'需求编码',
			dataIndex:'ImNCode',
			width:60,
			sortable:true
		},{
      header:'需求类型',
			dataIndex:'ImNType',
			width:60,
			sortable:true
		},{
      header:'严重程度',
			dataIndex:'ImNDegree',
			width:60,
			sortable:true
		}]);
	var ImListNToolBar=new Ext.PagingToolbar({
		id:'ImListNToolBar',
		store:ImListNStore,
		displayInfo:true,
		pageSize:20,
		displayMsg:"当前记录{0}---{1}条  共{2}条记录",
		emptyMsg:"没有数据",
		firstText:'第一页',
		lastText:'最后一页',
		prevText:'上一页',
		refreshText:'刷新',
		nextText:'下一页'		
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
	
   //创建开发人员附加信息 
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
		  header:'操作',
			dataIndex:'Devdetail',
			width:60,
			sortable:true,
			xtype:'actioncolumn',
			items:[{xtype:"tbfill"},{
      icon:'../scripts/Pmp/Image/edit3.gif',tooltip: "更新数据",handler:function(DetailGrid, rowIndex, colIndex){
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
		  header:'姓名',
			dataIndex:'DevNamedetail',
			width:60,
			sortable:true
		},{
		  header:'联系方式',
			dataIndex:'DevTeldetail',
			width:100,
			sortable:true
		},{
		  header:'产品组',
			dataIndex:'DevProductdetail',
			width:100,
			sortable:true
		},{
		  header:'更新日期',
			dataIndex:'DevUpDatedetail',
			width:100,
			sortable:true
		},{
		  header:'更新时间',
			dataIndex:'DevUpTimedetail',
			width:100,
			sortable:true
		},{
		  header:'更新用户',
			dataIndex:'DevUpUserdetail',
			width:100,
			sortable:true
		},{
		  header:'更新类型',
			dataIndex:'DevUpTypedetail',
			width:60,
			sortable:true
		},{
		  header:'更新内容',
			dataIndex:'DevMenudetail',
			width:200,
			sortable:true
		}]);
	var DetailToolBar=new Ext.PagingToolbar({
		id:'DetailToolBar',
		store:DetailStore,
		displayInfo:true,
		pageSize:20,
		displayMsg:"当前记录{0}---{1}条  共{2}条记录",
		emptyMsg:"没有数据",
		firstText:'第一页',
		lastText:'最后一页',
		prevText:'上一页',
		refreshText:'刷新',
		nextText:'下一页'		
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
    singleSelect:true //如果值是false，表明可以选择多行；否则只能选择一行     
});
 //创建评价详细信息列表 
  var DevAppraisalnm=new Ext.grid.RowNumberer();
	var DevAppraisalsm=new Ext.grid.CheckboxSelectionModel(); 
	var DetailAppraisalCm=new Ext.grid.ColumnModel([DevAppraisalnm,
	  { header:'操作',
			dataIndex:'Appraisal',
			width:30,
			sortable:true,
			xtype:'actioncolumn',
			items:[{xtype:"tbfill"},{
      icon:'../scripts/Pmp/Image/edit3.gif',tooltip: "更新数据",handler:function(DetailAppraisalGrid, rowIndex, colIndex){
      var rec = DetailAppraisalGrid.getStore().getAt(rowIndex);}}]
	  },{
		  header:'AppraisalRowid',
			dataIndex:'AppraisalRowid',
			width:60,
			sortable:true,
			hidden : true
		},{
		  header:'姓名',
			dataIndex:'AppraisalName',
			width:60,
			sortable:true
		},{
		  header:'评价类型',
			dataIndex:'AppraisalType',
			width:60,
			sortable:true
		},{
		  header:'总分',
			dataIndex:'AppraisalSum',
			width:60,
			sortable:true
		},{
		  header:'出勤满意度',
			dataIndex:'AppraisalAttendance',
			width:80,
			sortable:true
		},{
		  header:'效率满意度',
			dataIndex:'AppraisalWorkEff',
			width:80,
			sortable:true
		},{
		  header:'态度满意度',
			dataIndex:'AppraisalWorkAtt',
			width:80,
			sortable:true
		},{
		  header:'其他满意度',
			dataIndex:'AppraisalOtherStais',
			width:80,
			sortable:true
	  },{
		  header:'整体评价',
			dataIndex:'AppraisalMenu',
			width:150,
			sortable:true
		},{
		  header:'意见或建议',
			dataIndex:'AppraisalBY5',
			width:150,
			sortable:true
		},{
		  header:'评价用户',
			dataIndex:'AppraisalUser',
			width:100,
			sortable:true
		},{
		  header:'评价日期',
			dataIndex:'AppraisalDate',
			width:150,
			sortable:true
		}]);
	var DetailAppraisalToolBar=new Ext.PagingToolbar({
		id:'DetailAppraisalToolBar',
		store:DetailAppraisalStore,
		displayInfo:true,
		pageSize:20,
		displayMsg:"当前记录{0}---{1}条  共{2}条记录",
		emptyMsg:"没有数据",
		firstText:'第一页',
		lastText:'最后一页',
		prevText:'上一页',
		refreshText:'刷新',
		nextText:'下一页'		
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

  //创建开发人员列表
	var nm=new Ext.grid.RowNumberer();
	var sm=new Ext.grid.CheckboxSelectionModel(); 
	var DevDetailCm=new Ext.grid.ColumnModel([nm,
	  { 
	    header:'操作',
			dataIndex:'Menu',
			width:60,
			xtype:'actioncolumn',
			sortable:true,
			autoScroll : true,
			items:[{xtype:"tbfill"},{
      icon:'../scripts/epr/Pics/attending.gif',tooltip: "添加评价",handler:function(DevDetailGrid, rowIndex, colIndex){
      var rec = DevDetailGrid.getStore().getAt(rowIndex);
      var Assname=rec.get('DevName');
      var AssRowid=rec.get('Rowid');
      var AssTel=rec.get('DevTel');
      var AssEmail=rec.get('DevEmail');
      var AssProduct=rec.get('DevProduct');
      //alert("Edit " + rec.get('Rowid'));
      var Str="  姓名："+Assname+"   电话："+AssTel+" "+AssEmail+"   产品组："+AssProduct;
      SelectUser(userId,AssRowid,Str,AssRowid);}  
      },{xtype:"tbseparator"},
      {icon:'../scripts/Pmp/Image/drop-add.gif',tooltip: "添加附加记录",handler:function(DevDetailGrid, rowIndex, colIndex){
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
      {icon:'../scripts/Pmp/Image/hmenu-unlock (2).gif',tooltip: "详细信息",handler:function(DevDetailGrid, rowIndex, colIndex){
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
			header:'姓名',
			dataIndex:'DevName',
			width:60,
			sortable:true
		},{
			header:'状态',
			dataIndex:'DevStatus',
			width:100,
			sortable:true,
			renderer:function(v){
      if(v!="当前项目组"){
      return '<span style="color:red">'+v+'</span>';}
      else {return v;}}
		},{
			header:'评价',
			dataIndex:'DevAppraisal',
			width:60,
			sortable:true,
			renderer:function(v){
      if(v!="暂无评价"){
      return '<span style="color:red">'+v+'</span>';}
      else {return v;}}
		},{
			header:'联系电话',
			dataIndex:'DevTel',
			width:100,
			sortable:true
		},{
			header:'电子邮箱',
			dataIndex:'DevEmail',
			width:100,
			sortable:true
		},{
			header:'产品组',
			dataIndex:'DevProduct',
			width:100,
			sortable:true
		},{
			header:'到达日期',
			dataIndex:'DevInDate',
			width:100,
			sortable:true
		},{
			header:'到达时间',
			dataIndex:'DevInTime',
			width:100,
			sortable:true
		},{
			header:'离开日期',
			dataIndex:'DevOutDate',
			width:100,
			sortable:true
		},{
			header:'离开时间',
			dataIndex:'DevOutTime',
			width:100,
			sortable:true
		},{
			header:'出差原因',
			dataIndex:'DevBusine',
			width:100,
			sortable:true
		}]);
		var PagingToolBar=new Ext.PagingToolbar({
		id:'PagingToolBar',
		store:DevDetailStore,
		displayInfo:true,
		pageSize:20,
		displayMsg:"当前记录{0}---{1}条  共{2}条记录",
		emptyMsg:"没有数据",
		firstText:'第一页',
		lastText:'最后一页',
		prevText:'上一页',
		refreshText:'刷新',
		nextText:'下一页'		
	});
	var DevDetailGrid=new Ext.grid.GridPanel({
		//title:'开发明细',
		id:'DevDetaiGrid',
		height : 380,
		store:DevDetailStore,
		loadMask:true,
		cm:DevDetailCm,
		params:{InPut:'InPut'},
		sm:new Ext.grid.RowSelectionModel({singleSelect:true}),
		bbar:PagingToolBar
		,listeners : {// 表格单击事件  
		"rowclick":function(DevDetaiGrid, rowIndex,columnIndex,e) {
		              //Ext.Msg.alert('数据',DevDetaiGrid.getStore().getAt(rowIndex).data.Rowid);
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
		              //UserShowAll(DevDetaiGrid.getStore().getAt(rowIndex).data); 获取当前被选中的索引的数据 
		              
		            },
	  "cellclick":function(DevDetaiGrid , rowIndex , cellIndex ,e){
		      var record = DevDetaiGrid.getStore().getAt(rowIndex);    //获取所在行的记录
          var fieldName = DevDetaiGrid.getColumnModel().getDataIndex(cellIndex );//获取单元格的索引名称
          var callValue = record .get(fieldName);//获得单元格数据
          var DevRowid=record.data.Rowid;
          if(fieldName=="DevAppraisal"){
          if(callValue!="暂无评价"){
          var DevAppraisalwindow=new Ext.Window({
			         title:"评价详细记录",
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
	//添加mouseover事件    鼠标移动到表格上面显示内容
	DevDetailGrid.on('mouseover',function(e){  
	 //根据mouse所在的target可以取到列的位置
  var index = DevDetailGrid.getView().findRowIndex(e.getTarget());  
   if(index!==false){     //当取到了正确的列时，（因为如果传入的target列没有取到的时候会返回false）
      var record = DevDetailStore.getAt(index);//把这列的record取出来
      var str = Ext.encode(record.data);      //组装一个字符串，这个需要你自己来完成，这儿我把他序列化
      var rowEl = Ext.get(e.getTarget()); //把target转换成Ext.Element对象
      rowEl.set({
     'ext:qtip':str  //设置它的tip属性
     },false);
       }
   });
   
   */
  
	//DevDetailGrid.addListener('rowclick', rowclickFn);   //单击事件
	
	 //DevDetailGrid.addListener('rowdblclick', rowclickFn);   //双击事件
	
    ChartInfoAddFun();                                   
    function ChartInfoAddFun() {  
     var myPanel=new Ext.Viewport({ 
        layout:"border",        
        items:[{
	        region:"north",
	        collapsible:true,   //界面收缩
	        height:0,
	        frame:true,     //面板属性  底色为浅色
	        title:"开发管理"
	        ,html:"<h1>该功能主要管理产品组开发到现场的工作的记录!</h1>"
	        },
	        {region:"south",
	        height:200,
	        collapsible:true,
	        collapsible:true,
	        frame:true,     //面板属性  
	        title:"开发拓展信息",
	        layout:"form",
	        items:DetailGrid	
	        },
	        {region:"center",
	        collapsible:true,
	        frame:true,     
	        title:"开发列表",
	        layout:"form",
	        items:DevDetailGrid	        
	        },
	        {region:"west",
	        width:250,
	        collapsible:true,
	        frame:true,     //面板属性 
	        height:200,
	        bodyStyle:"padding:5px",
	        labelWidth:60,   //标题宽度
	        title:"参数条件",
	        layout:"form",
			    //tools:[{id:"save"},{id:"help", handler:function(){Ext.Msg.alert('help','please help me!');}},{id:"close"}],
			    tbar:[{xtype:"tbfill"},
			      {//pressed:true,   //按钮凸起
			      tooltip: "添加开发信息",text:"<img SRC='../scripts/Pmp/Image/file-add.gif'>开发到场",
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
			        if((DevNamec=="")||(DevNamec=="null")||(DevNamec=="请输入姓名")){
			        Ext.Msg.alert('温馨提示',"开发姓名不能为空！");
			        return;
			        };
			        if((DevTelc=="")||(DevTelc=="null")||(DevTelc=="请输入联系方式")){
			        Ext.Msg.alert('温馨提示',"联系方式不能为空！");
			        return;
			        };
			        if((DevProductc=="")||(DevProductc=="null")||(DevProductc=="undefined")){
			        Ext.Msg.alert('温馨提示',"组别归属不能为空！");
			        return;
			        };
			        if((DevInDatec=="")||(DevInDatec=="null")||(DevInDatec=="undefined")){
			        Ext.Msg.alert('温馨提示',"到达日期不能为空！");
			        return;
			        };
			        if((DevInTimec=="")||(DevInTimec=="null")||(DevInTimec=="undefined")){
			        Ext.Msg.alert('温馨提示',"到达时间不能为空！");
			        return;
			        };
			        if(DevOutDatec=="undefined"){var DevOutDatec="";};
			        if(DevOutTimec=="undefined"){var DevOutTimec="";};
			        if((DevDLBY1c=="")||(DevDLBY1c=="null")||(DevDLBY1c=="undefined")){
			        Ext.Msg.alert('温馨提示',"内容类型不能为空！");
			        return;
			        };
			        DevInsert(DevNamec,DevTelc,DevEmailc,DevProductc,DevBusinessReasonc,DevInDatec,DevInTimec,DevOutDatec,DevOutTimec,DevDLBY1c);
			        
				      }},
				  {xtype:"tbseparator"},
				  {tooltip: "按照条件检索数据",text:"<img SRC='../scripts/Pmp/Image/eb_find1.gif'>高速检索",
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
				  {tooltip: "清除条件区域的数据",text:"<img SRC='../scripts/dhcmed/img/delete.gif'>清除",
			      handler:function(){
			        Ext.getCmp("Name").setValue(""); 
			        Ext.getCmp("Tel").setValue(""); 
			        Ext.getCmp("Email").setValue(""); 
			        //Ext.getCmp("Product").setValue("");
			        //Ext.getCmp("BusinessReason").getStore().load();
			        Ext.getCmp("InDate").setValue(new Date());
			        Ext.getCmp("OutDate").setValue(new Date());
			        Ext.getCmp("BusinessReason").setValue("")}}],
			      //tbar:[{text:'顶部工具栏topToolbar'}],
            //bbar:[{text:'底部工具栏bottomToolbar'}],
            //buttons:[{text:"开发到场"},{text:"检 索"},{text:"清 屏"}],
			listeners:{
				"render":function(myPanel){
							myPanel.add(new Ext.form.TextField({
								id:"Name",
								emptyText:'请输入姓名',
								width : 150,
								fieldLabel:"开发姓名",
								 listeners: {
               //监听键盘事件
                "specialkey": function (field, e) {
                   //判断是否回车
                  if (e.keyCode == 13) {
                    //调用登录事件
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
                  regexText: '请输入正确的数据类型',
                  vtype: 'alphanum',
								  fieldLabel:"联系方式",
								  listeners: {
               //监听键盘事件
                "specialkey": function (field, e) {
                   //判断是否回车
                  if (e.keyCode == 13) {
                    //调用登录事件
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
									regexText: '请输入正确的电子邮箱地址',
								  fieldLabel:"电子邮箱",
								  listeners: {
               //监听键盘事件
                "specialkey": function (field, e) {
                   //判断是否回车
                  if (e.keyCode == 13) {
                    //调用登录事件
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
								  fieldLabel:"组别归属",
								  name:'Product',
								  mode : 'local',
								  //triggerAction : 'all', 
								  store : SelectProduct,   //获取内容
                  valueField : 'RowId',   //后台值
                  displayField : 'Description',   //界面显示值
                  valueNotFoundText : '',
                  params:{InPut:'Product'}   //入参参数值
                                    })),
							myPanel.add(new Ext.form.DateField({
									id:"InDate",
									width : 150,
								    fieldLabel:'到达日期',
								    enableKeyEvents : true,
	                                emptyText:'请选择日期',
	                                format:'Y-m-d',
	                                value:new Date().add(Date.DAY,0)
	                               // ,disabledDays:[0,6]
									})),
							myPanel.add(new Ext.form.TimeField({
									id:"InTime",
								    fieldLabel:'到达时间',
								    renderTo: Ext.get('times'), 
								    width : 150,
	                                emptyText:'请选择时间',
	                                regex : /^(0\d{1}|1\d{1}|2[0-3]):[0-5]\d{1}:([0-5]\d{1})$/,
		                              regexText:'时间格式错误，正确格式hh:mm:ss',
	                                autoShow: true,
	                                format: 'H:i:s',
	                                increment:1    //时间间隔
									})),
							myPanel.add(new Ext.form.DateField({
									id:"OutDate",
									width : 150,
								    fieldLabel:'离开日期',
								    enableKeyEvents : true,
	                                //emptyText:'请选择日期',
	                                format:'Y-m-d'
	                                //value:new Date().add(Date.DAY,0),
	                                //,disabledDays:[0,6]
									})),
							myPanel.add(new Ext.form.TimeField({
									id:"OutTime",
								    fieldLabel:'离开时间',
								    renderTo: Ext.get('times'), 
								    width : 150,
	                                //emptyText:'请选择时间',
	                                autoShow: true,
	                                regex : /^(0\d{1}|1\d{1}|2[0-3]):[0-5]\d{1}:([0-5]\d{1})$/,
		                              regexText:'时间格式错误，正确格式hh:mm:ss',
	                                format: 'H:i:s',
	                                increment:1
									})),
						  myPanel.add(new Ext.form.ComboBox({
								id:"DLBY1",
								width : 150,
								fieldLabel:"添加类型",
								emptyText:'请选择添加内容类型',
								name:'DLBY1',
							  mode : 'local',
								store : AddDetailType,   //获取内容
                valueField : 'RowId',   //后台值
                displayField : 'Description',   //界面显示值
                valueNotFoundText : '',
                params:{InPut:'DLBY1'}   //入参参数值
								})),
							myPanel.add(new Ext.form.TextField({
									id:"BusinessReason",
									width : 150,
								    fieldLabel:"出差原因",
								    listeners : {
                                    change : function(field,newValue,oldValue){
                                    Ext.Msg.alert('help',newValue+'---'+'oldValue');},
                                    focus:function(){
                                       var buvalue=Ext.getDom("BusinessReason").value;
	                                     var mywindow=new Ext.Window({
			                             title:"出差原因",
			                             width:520,
		                                 height:300,
		                                 layout:'column',
				                         Resizable:'yes',
		                                 minimizable:true,
		                                 closable:"true",   
		                                 buttonAlign:"center",
		                                 
		                                 items:[{xtype:'htmleditor',id:'Business',defaultValue:buvalue
		                                 //,fontFamilies: ["宋体", "隶书", "黑体"]
		                                 //,style:'color:white;background-color:#000000'   //设置背景属性
		                                 }],
		                                 tbar:[{text:'确认',tooltip: "确认出差原因",
					                     handler:function(){
					                     Ext.getCmp("BusinessReason").setValue(Ext.getCmp("Business").getValue());
					                     mywindow.close();}
					}]}).show();
	                                    }  //选中事件
                                                }
									}))							
				}
				}
	        },
	        {region:"east",
	        width:750,
	        collapsible:true,
	        frame:true,     
	        title:"处理需求记录",
	        xtype:"tabpanel", 
	        collapsed:true,
	        items:[{title:"已完成需求",frame:true,items:[ImListGrid]}, 
          {title:"未完成需求",frame:true,items:[ImListNGrid]}] 
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
							waitMsg : '数据存储中..',
							success : function(result, request) {
								var jsonData = Ext.util.JSON
										.decode(result.responseText);
								if (jsonData.success == 'true') {
								  SelectDevDetail(DevNamec,DevTelc,DevEmailc,"","","","","","");
									Ext.Msg.alert("success", "数据插入成功!");
									
									//clearData();
								} else {
									var ret=jsonData.info;
									if(ret==-1){
										Ext.Msg.alert("error", "插入失败!");
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
							waitMsg : '数据查询中..',
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
		
			// 变更按钮是否可用
			//查询^清除^新增^保存^删除^完成^取消完成
		}
function rowclickFn(DevDetailGrid, rowindex, e){  
    Ext.Msg.alert('help','单击事件');    
    DevDetailGrid.getSelectionModel().each(function(rec){   
    alert(rec.get(DevName)); //fieldName，记录中的字段名     
    });     
}    
function UserShowAll(record){
         Ext.Msg.alert('明细数据',record.DevName);
}
//添加评价功能
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
								fieldLabel:"出勤得分"
								});
var Appraisalwindow=new Ext.Window({
			  title:"开发评价",
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
		    frame:true,     //面板属性  底色为浅色
		    labelWidth:70,  //标题宽度
		    tbar:[{tooltip: "保存数据",text:"<img SRC='../scripts/Pmp/Image/add16.gif'>保存",handler:function(){
		    var Attendancevalue=Ext.getDom("Attendancevalue").value;
		    var WorkEfficiencyvalue=Ext.getDom("WorkEfficiency1value").value;
		    var WorkAttitudevlaue=Ext.getDom("WorkAttitudevlaue").value;
		    var OtherStaisvlaue=Ext.getDom("OtherStaisvlaue").value;
		    var AppMenuvlaue=Ext.getDom("AppMenu").value;
		    var AppProposalvlaue=Ext.getDom("AppProposal").value;
		    var Rowidvlaue=Ext.getDom("Rowid").value;
		    if((Attendancevalue=="")||(Attendancevalue=="0")){
		    Ext.Msg.alert('温馨提示','出勤满意度还未打分！');
		    return;
		    };
		    if((WorkEfficiencyvalue=="")||(WorkEfficiencyvalue=="0")){
		    Ext.Msg.alert('温馨提示','效率满意度还未打分！');
		    return;
		    };
		    if((WorkAttitudevlaue=="")||(WorkAttitudevlaue=="0")){
		    Ext.Msg.alert('温馨提示','态度满意度还未打分！');
		    return;
		    };
		    if((OtherStaisvlaue=="")||(OtherStaisvlaue=="0")){
		    Ext.Msg.alert('温馨提示','其他满意度还未打分！');
		    return;
		    };
		    if(Rowidvlaue==""){
		    Ext.Msg.alert('温馨提示','未选中数据！');
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
		            frame:true,     //面板属性  底色为浅色
		            labelWidth:40,   //标题宽度
		            tbar:[{id:'Attendance',tooltip: "出勤满意度",text:"<img SRC='../scripts/Pmp/Image/APP1.gif'>出勤满意度",
		            listeners: {
                mouseover: function(e) {
               // Ext.getDom("Attendance").innerHTML ="../scripts/Pmp/Image/APP2.gif";
                //Ext.getDom(e.getId()).innerHTML ='../scripts/Pmp/Image/APP2.gif';
               //Ext.getCmp('Attendance').btnEl.setStyle('background-color',"yellow");   //按钮背景颜色  
               //Ext.getCmp('Attendance').btnInnerEl.setStyle('color',"green");  //按钮字体颜色
                //Ext.getCmp('Attendance').btnEl.setStyle('background-image','-webkit-linear-gradient(top,red,yellow 40%,yellow 30%,red)');  背景颜色渐变
                //Attendance.seticon('../scripts/Pmp/Image/APP2.gif');
                // set a new config which says we moused over, if not already set
                if (!this.mousedOver) {
                this.mousedOver = true;
                //alert('You moused over a button!\n\nI wont do this again.');
                          }
        },mouseout:function(e){
        //Ext.getCmp('Attendance').btnEl.setStyle('background-color',"blue");   //按钮背景颜色 
        }
   
    }},
		            {xtype:"tbseparator"},
		            {id:'Attendance1',tooltip: "严重缺勤",text:"<img SRC='../scripts/Pmp/Image/APP2.gif'>",
		            listeners: {
		            //鼠标悬浮事件
                mouseover: function(e) {
                if(Attendancetype1=="0"){
                Ext.getCmp('Attendance1').btnEl.setStyle('background-color',"red");   //按钮背景颜色  
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
		            {id:'Attendance2',tooltip: "偶尔缺勤",text:"<img SRC='../scripts/Pmp/Image/APP2.gif'>",
		            listeners: {
                mouseover: function(e) {
                if(Attendancetype2=="0"){
                Ext.getCmp('Attendance1').btnEl.setStyle('background-color',"red");   //按钮背景颜色  
                Ext.getCmp('Attendance2').btnEl.setStyle('background-color',"red");   //按钮背景颜色  
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
		            {id:'Attendance3',tooltip: "正常出勤",text:"<img SRC='../scripts/Pmp/Image/APP2.gif'>",
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
		            {id:'Attendance4',tooltip: "偶尔加班",text:"<img SRC='../scripts/Pmp/Image/APP2.gif'>",
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
		            {id:'Attendance5',tooltip: "优秀出勤",text:"<img SRC='../scripts/Pmp/Image/APP2.gif'>",
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
								bbar:[{id:'WorkEfficiency',tooltip: "效率满意度",text:"<img SRC='../scripts/Pmp/Image/APP1.gif'>效率满意度",
		            listeners: {
                mouseover: function(e) {},
                mouseout:function(e){}}},
								{xtype:"tbseparator"},
								{id:'WorkEfficiency1',tooltip: "效率极差",text:"<img SRC='../scripts/Pmp/Image/APP2.gif'>",
		            listeners: {
                mouseover: function(e) {
                if(WorkEfficiencytype1=="0"){
                Ext.getCmp('WorkEfficiency1').btnEl.setStyle('background-color',"red");   //按钮背景颜色  
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
								{id:'WorkEfficiency2',tooltip: "效率较差",text:"<img SRC='../scripts/Pmp/Image/APP2.gif'>",
		            listeners: {
                mouseover: function(e) {
                if(WorkEfficiencytype2=="0"){
                Ext.getCmp('WorkEfficiency1').btnEl.setStyle('background-color',"red");   //按钮背景颜色  
                Ext.getCmp('WorkEfficiency2').btnEl.setStyle('background-color',"red");   //按钮背景颜色  
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
								{id:'WorkEfficiency3',tooltip: "效率良好",text:"<img SRC='../scripts/Pmp/Image/APP2.gif'>",
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
								{id:'WorkEfficiency4',tooltip: "效率优秀",text:"<img SRC='../scripts/Pmp/Image/APP2.gif'>",
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
								{id:'WorkEfficiency5',tooltip: "效率超高",text:"<img SRC='../scripts/Pmp/Image/APP2.gif'>",
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
								fieldLabel:"出勤得分"
								})),
				Appraisalwindow.add(new Ext.form.TextField({
								id:"WorkEfficiency1value",
								width : 150,
								hidden : true,
								fieldLabel:"工作效率得分"
								})),
			 Appraisalwindow.add(new Ext.form.TextField({
								id:"WorkAttitudevlaue",
								width : 150,
								hidden : true,
								fieldLabel:"工作态度"
								})),
				Appraisalwindow.add(new Ext.form.TextField({
								id:"OtherStaisvlaue",
								width : 150,
								hidden : true,
								fieldLabel:"其他评价"
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
		            frame:true,     //面板属性  底色为浅色
		            labelWidth:40,   //标题宽度
		            tbar:[{id:'WorkAttitude',tooltip: "态度满意度",text:"<img SRC='../scripts/Pmp/Image/APP1.gif'>态度满意度"},
		            {xtype:"tbseparator"},
		            {id:'WorkAttitude1',tooltip: "态度极差",text:"<img SRC='../scripts/Pmp/Image/APP2.gif'>",
		            listeners: {
                mouseover: function(e) {
                Ext.getCmp('WorkAttitude1').btnEl.setStyle('background-color',"red");   //按钮背景颜色  
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
		            {id:'WorkAttitude2',tooltip: "态度一般",text:"<img SRC='../scripts/Pmp/Image/APP2.gif'>",
		            listeners: {
                mouseover: function(e) {
                Ext.getCmp('WorkAttitude1').btnEl.setStyle('background-color',"red");   //按钮背景颜色  
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
		            {id:'WorkAttitude3',tooltip: "态度较好",text:"<img SRC='../scripts/Pmp/Image/APP2.gif'>",
		            listeners: {
                mouseover: function(e) {
                Ext.getCmp('WorkAttitude1').btnEl.setStyle('background-color',"red");   //按钮背景颜色  
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
		            {id:'WorkAttitude4',tooltip: "态度很好",text:"<img SRC='../scripts/Pmp/Image/APP2.gif'>",
		            listeners: {
                mouseover: function(e) {
                Ext.getCmp('WorkAttitude1').btnEl.setStyle('background-color',"red");   //按钮背景颜色  
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
		            {id:'WorkAttitude5',tooltip: "态度极其端正",text:"<img SRC='../scripts/Pmp/Image/APP2.gif'>",
		            listeners: {
                mouseover: function(e) {
                Ext.getCmp('WorkAttitude1').btnEl.setStyle('background-color',"red");   //按钮背景颜色  
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
								bbar:[{id:'OtherStais',tooltip: "其他满意度",text:"<img SRC='../scripts/Pmp/Image/APP1.gif'>其他满意度"},
								{xtype:"tbseparator"},
								{id:'OtherStais1',tooltip: "极差",text:"<img SRC='../scripts/Pmp/Image/APP2.gif'>",
		            listeners: {
                mouseover: function(e) {
                Ext.getCmp('OtherStais1').btnEl.setStyle('background-color',"red");   //按钮背景颜色  
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
								{id:'OtherStais2',tooltip: "较差",text:"<img SRC='../scripts/Pmp/Image/APP2.gif'>",
		            listeners: {
                mouseover: function(e) {
                Ext.getCmp('OtherStais1').btnEl.setStyle('background-color',"red");   //按钮背景颜色  
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
								{id:'OtherStais3',tooltip: "良好",text:"<img SRC='../scripts/Pmp/Image/APP2.gif'>",
		            listeners: {
                mouseover: function(e) {
                Ext.getCmp('OtherStais1').btnEl.setStyle('background-color',"red");   //按钮背景颜色  
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
								{id:'OtherStais4',tooltip: "优秀",text:"<img SRC='../scripts/Pmp/Image/APP2.gif'>",
		            listeners: {
                mouseover: function(e) {
                Ext.getCmp('OtherStais1').btnEl.setStyle('background-color',"red");   //按钮背景颜色  
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
								{id:'OtherStais5',tooltip: "超高",text:"<img SRC='../scripts/Pmp/Image/APP2.gif'>",
		            listeners: {
                mouseover: function(e) {
                Ext.getCmp('OtherStais1').btnEl.setStyle('background-color',"red");   //按钮背景颜色  
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
			          	 title:'整体评价',
				           width:500,
				           height:180,
				           layout:'column',
				           Resizable:'yes',
				    			 items:[{xtype:'htmleditor',id:'AppMenu'}]})),
				Appraisalwindow.add(new Ext.Panel({
			          	 renderTo:Ext.getBody(),
				           width:500,
				           title:'意见或建议',
				           height:180,
				           layout:'column',
				           Resizable:'yes',
				    			 items:[{xtype:'htmleditor',id:'AppProposal'}]}))
								}}
			}).show();
}
//加载开发详细数据界面
function DevDetail(detailRowid,detailname,detailTel,detailEmail,detailProduct,detailInDate,detailInTime,detailOutDate,detailOutTime,detailBusine){
var mywindow=new Ext.Window({
			  title:"开发详细信息",
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
		    frame:true,     //面板属性  底色为浅色
		    labelWidth:70,  //标题宽度
		    tbar:[{
		           text:"<img SRC='../scripts/Pmp/Image/save.gif'>更 新",tooltip: "修改开发基本信息",
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
			                 Ext.Msg.alert('温馨提示',"请重新加载数据！");
			                 return;
			                        };
			                 if((UpdateNamec=="")||(UpdateNamec=="null")||(UpdateNamec=="请输入姓名")){
			                 Ext.Msg.alert('温馨提示',"开发姓名不能为空！");
			                 return;
			                        };
			                 if((UpdateTelc=="")||(UpdateTelc=="null")||(UpdateTelc=="请输入联系方式")){
			                 Ext.Msg.alert('温馨提示',"联系方式不能为空！");
			                 return;
			                        };
			                 if((UpdateProductc=="")||(UpdateProductc=="null")||(UpdateProductc=="undefined")){
			                 Ext.Msg.alert('温馨提示',"组别归属不能为空！");
			                 return;
			                        };
			                 if((UpdateInDatec=="")||(UpdateInDatec=="null")||(UpdateInDatec=="undefined")){
			                 Ext.Msg.alert('温馨提示',"到达日期不能为空！");
			                 return;
			                        };
			                 if((UpdateInTimec=="")||(UpdateInTimec=="null")||(UpdateInTimec=="undefined")){
			                 Ext.Msg.alert('温馨提示',"到达时间不能为空！");
			                 return;
			                        };
			                 if(UpdateOutDatec=="undefined"){var UpdateOutDatec="";};
			                 if(UpdateOutTimec=="undefined"){var UpdateOutTimec="";};
			                 var NewDate=UpdateRowid+"^"+UpdateNamec+"^"+UpdateTelc+"^"+UpdateEmailc+"^"+UpdateProductc+"^"+UpdateInDatec+"^"+UpdateInTimec+"^"+UpdateOutDatec+"^"+UpdateOutTimec+"^"+UpdateBusinessReasonc;
			                 if(OldData==NewDate){
			                 Ext.Msg.alert('温馨提示','您未修改任何数据,不用更新！');
			                 return;};
			                 InPut=UpdateNamec+"^"+UpdateTelc+"^"+UpdateEmailc+"^"+UpdateProductc+"^"+UpdateInDatec+"^"+UpdateInTimec+"^"+UpdateOutDatec+"^"+UpdateOutTimec+"^"+UpdateBusinessReasonc;
			                 UpdateDetail(NewDate);
			                 getDetail(InPut);
			                 mywindow.close();
		                   }},
		          {xtype:"tbseparator"},
		          {
		           text:"<img SRC='../scripts/Pmp/Image/add16.gif'>评 价",tooltip: "添加评价",
		           handler:function(){
		                   var UpdateNamec=Ext.getDom("DetailName").value;
			                 var UpdateTelc=Ext.getDom("DetailTel").value;
			                 var UpdateEmailc=Ext.getDom("DetailEmail").value;
			                 var UpdateProductc=Ext.getDom("DetailProduct").value;
		                   var Str="  姓名："+UpdateNamec+"   电话："+UpdateTelc+" "+UpdateEmailc+"   产品组："+UpdateProductc;
                       DevAddAppraisal(Str,detailRowid);
                       mywindow.close();
		                   }},
		          {xtype:"tbseparator"},
		          {
		           text:"<img SRC='../scripts/Pmp/Image/eb_find.gif'>查看需求",
		           handler:function(){
		                   Ext.Msg.alert('提示','该功能正在开发中。。。');
		                   }},
		          {xtype:"tbseparator"},
		          {
		           text:"<img SRC='../scripts/Pmp/Image/reset.gif'>删除记录",tooltip: "删除此条数据",
		           handler:function(){
		                   var DeleteRowid=Ext.getDom("DetailRowid").value;
		                   if(DeleteRowid==""){
			                 Ext.Msg.alert('温馨提示',"请重新加载数据！");
			                 return;
			                        };
			                 Ext.MessageBox.confirm('删除确认','您是否要删除该条数据？',function(btn)
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
		           text:"<img SRC='../scripts/Pmp/Image/arrow_left.gif'>返 回",tooltip: "返回上一级",
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
								emptyText:'请输入姓名',
								width : 430,
								fieldLabel:"开发姓名"

								})),
							mywindow.add(new Ext.form.TextField({
									id:"DetailTel",
									width : 430,
									regex:  /^\d+(\.\d{1,2})?$/,
                  regexText: '请输入正确的数据类型',
                  vtype: 'alphanum',
								  fieldLabel:"联系方式"
									})),
							mywindow.add(new Ext.form.TextField({
									id:"DetailEmail",
									width : 430,
									regex: /^\s*\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*(\;\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*)*(\;)*\s*$/,
									regexText: '请输入正确的电子邮箱地址',
								  fieldLabel:"电子邮箱"
									})),
							mywindow.add(new Ext.form.ComboBox({
									id:"DetailProduct",
									width : 430,
								  fieldLabel:"组别归属",
								  name:'DetailProduct',
								  mode : 'local',
								  //triggerAction : 'all', 
								  store : SelectProduct,   //获取内容
                  valueField : 'RowId',   //后台值
                  displayField : 'Description',   //界面显示值
                  valueNotFoundText : '',
                  params:{InPut:'DetailProduct'}   //入参参数值
                                    })),
							mywindow.add(new Ext.form.DateField({
									id:"DetailInDate",
									width : 430,
								    fieldLabel:'到达日期',
								    enableKeyEvents : true,
	                                emptyText:'请选择日期',
	                                format:'Y-m-d',
	                                value:new Date().add(Date.DAY,0),
	                                disabledDays:[0,6]
									})),
							mywindow.add(new Ext.form.TimeField({
									id:"DetailInTime",
								    fieldLabel:'到达时间',
								    renderTo: Ext.get('times'), 
								    width : 430,
	                                emptyText:'请选择时间',
	                                regex : /^(0\d{1}|1\d{1}|2[0-3]):[0-5]\d{1}:([0-5]\d{1})$/,
		                              regexText:'时间格式错误，正确格式hh:mm:ss',
	                                autoShow: true,
	                                format: 'H:i:s',
	                                increment:1    //时间间隔
									})),
							mywindow.add(new Ext.form.DateField({
									id:"DetailOutDate",
									width : 430,
								    fieldLabel:'离开日期',
								    enableKeyEvents : true,
	                                //emptyText:'请选择日期',
	                                format:'Y-m-d',
	                                //value:new Date().add(Date.DAY,0),
	                                disabledDays:[0,6]
									})),
							mywindow.add(new Ext.form.TimeField({
									id:"DetailOutTime",
								    fieldLabel:'离开时间',
								    renderTo: Ext.get('times'), 
								    width : 430,
	                                //emptyText:'请选择时间',
	                                regex : /^(0\d{1}|1\d{1}|2[0-3]):[0-5]\d{1}:([0-5]\d{1})$/,
		                              regexText:'时间格式错误，正确格式hh:mm:ss',
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

//查询产品组ID
function SelectProductId(detailProduct){
        var url = "PMP.Common.csp?actiontype=SelectProductId&InPut="+detailProduct;
				Ext.Ajax.request({
							url : url,
							method : 'POST',
							waitMsg : '数据处理中...',
							success : function(result, request) {
								var jsonData = Ext.util.JSON
										.decode(result.responseText);
								var ret=jsonData.info;
								if (jsonData.success == 'true') {
								//Ext.Msg.alert("success", ret);
											//addComboData(Ext.getCmp("DetailProduct").getStore(),ret,detailProduct);
              			Ext.getCmp("DetailProduct").setValue(ret);  //产品组赋值
									
								} else {
							if(ret==-1){
										Ext.Msg.alert("error", "字典中无此产品组");
										return;
									}
								}
							},
							scope : this
						});
}
//查询产品组ID
function SelectProductIdId(detailProduct){
        var url = "PMP.Common.csp?actiontype=AddDetailTypeid&InPut="+detailProduct;
				Ext.Ajax.request({
							url : url,
							method : 'POST',
							waitMsg : '数据处理中...',
							success : function(result, request) {
								var jsonData = Ext.util.JSON
										.decode(result.responseText);
								var ret=jsonData.info;
								if (jsonData.success == 'true') {
								//Ext.Msg.alert("success", ret);
											//addComboData(Ext.getCmp("DetailProduct").getStore(),ret,detailProduct);
              			Ext.getCmp("AddDetailType").setValue(ret);  //产品组赋值
									
								} else {
							if(ret==-1){
										Ext.Msg.alert("error", "字典中无此产品组");
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
							waitMsg : '数据存储中..',
							success : function(result, request) {
								var jsonData = Ext.util.JSON
										.decode(result.responseText);
								if (jsonData.success == 'true') {
									Ext.Msg.alert("success", "数据更新成功!");
									//clearData();
								} else {
									var ret=jsonData.info;
									if(ret==-1){
										Ext.Msg.alert("error", "数据更新失败!"+ret);
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
							waitMsg : '数据存储中..',
							success : function(result, request) {
								var jsonData = Ext.util.JSON
										.decode(result.responseText);
								if (jsonData.success == 'true') {
									Ext.Msg.alert("success", "数据删除成功!");
									//clearData();
								} else {
									var ret=jsonData.info;
										Ext.Msg.alert("error", "数据删除失败!  "+ret);	
								}
							},
							scope : this
						});
}
function AddDevDetail(AdddetailRowid,SubRowid,Adddetailname,AdddetailTel,AdddetailEmail,AdddetailProduct,AdddetailInDate,AdddetailInTime,AdddetailOutDate,AdddetailOutTime,AdddetailBusine,SubType,type){
   var UserMenu="  姓名："+Adddetailname+"   电话："+AdddetailTel+" "+AdddetailEmail+"   产品组："+AdddetailProduct;
   var Addwindow=new Ext.Window({
			  title:"添加开发附加记录",
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
		    frame:true,     //面板属性  底色为浅色
		    labelWidth:70,  //标题宽度
		    tbar:[{
		           text:"<img SRC='../scripts/Pmp/Image/save.gif'>保存",tooltip: "确认添加附加信息",
		           handler:function(){
		                   var AddDevRowid=Ext.getDom("AddDetailRowid").value;
			                 var AddDevType=Ext.getDom("AddDetailType").value;
			                 var AddDevMenu=Ext.getCmp("AddDetailMenu").getValue();
			                 if(AddDevRowid==""){
			                 Ext.Msg.alert('温馨提示','请重新选择数据');
			                 return;};
			                 if((AddDevType=="")||(AddDevType=="undefind")){
			                 Ext.Msg.alert('温馨提示','请选择添加内容类型');
			                 return;};
			                 if((AddDevMenu=="")||(AddDevMenu=="undefind")){
			                 Ext.Msg.alert('温馨提示','请填写内容');
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
								fieldLabel:"添加类型",
								emptyText:'请选择添加内容类型',
								name:'AddDetailType',
							  mode : 'local',
								store : AddDetailType,   //获取内容
                valueField : 'RowId',   //后台值
                displayField : 'Description',   //界面显示值
                valueNotFoundText : '',
                params:{InPut:'AddDetailType'}   //入参参数值
								})),
							Addwindow.add(new Ext.Panel({
			          renderTo:Ext.getBody(),
				        width:510,
				        height:300,
				        title:'详细内容',
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
							waitMsg : '数据存储中..',
							success : function(result, request) {
								var jsonData = Ext.util.JSON
										.decode(result.responseText);
								if (jsonData.success == 'true') {
									Ext.Msg.alert("success", "数据更新成功!");
									//clearData();
								} else {
									var ret=jsonData.info;
									if(ret==-1){
										Ext.Msg.alert("error", "数据更新失败!"+ret);
									}
								}
							},
							scope : this
						});
}
function ImListMenu(ImNRowidC,ImNNameC,ImNStatusC,ImNCreatDateC,ImNCreatUserC,ImNCreateLocC,ImNCreateTelC,ImNMenuC,ImNSituationC,ImNStandby3C,ImNEmergencyC,ImNCodeC,ImNTypeC,ImNDegreeC){
        //alert("需求详情");
 //创建附件明细信息 
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
		  header:'文件名称',
			dataIndex:'AdjunctFlagName',
			width:220,
			sortable:true
		},{
		  header:'上传时间',
			dataIndex:'AdjunctFlagTime',
			width:140,
			sortable:true
		},{
		  header:'上传者',
			dataIndex:'AdjunctFlagUser',
			width:140,
			sortable:true
		},{
		  header:'上传类型',
			dataIndex:'AdjunctFlagType',
			width:120,
			sortable:true
		},{
		  header:'操作',
			dataIndex:'AdjunctFlagdetail',
			width:60,
			sortable:true,
			xtype:'actioncolumn',
			items:[{xtype:"tbfill"},{
      icon:'../scripts/Pmp/Image/download1.gif',tooltip: "下载",handler:function(AdjunctFlagGrid, rowIndex, colIndex){
       var rec = AdjunctFlagGrid.getStore().getAt(rowIndex);
       Ext.Msg.alert('温馨提示','该功能正在开发中。。。。');
       }}]}]);
	var AdjunctFlagToolBar=new Ext.PagingToolbar({
		id:'AdjunctFlagToolBar',
		store:AdjunctFlagStore,
		displayInfo:true,
		pageSize:5,
		displayMsg:"当前记录{0}---{1}条  共{2}条记录",
		emptyMsg:"没有数据",
		firstText:'第一页',
		lastText:'最后一页',
		prevText:'上一页',
		refreshText:'刷新',
		nextText:'下一页'		
	});
	var AdjunctFlagGrid=new Ext.grid.GridPanel({
		id:'AdjunctFlagGrid',
		height : 160,
		title:'附件列表',
		store:AdjunctFlagStore,
		loadMask:true,
		cm:AdjunctFlagCm,
		params:{InPut:'InPut'},
		sm:new Ext.grid.RowSelectionModel({singleSelect:true}),
		bbar:AdjunctFlagToolBar
	});
var Improvementwindow=new Ext.Window({
			  title:"需求详情",
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
		    frame:true,     //面板属性  底色为浅色
		    labelWidth:50,  //标题宽度
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
                                    items:[{id:'ImprovementName',width:365,fieldLabel:'名称'}]
                                    },{  
                                    columnWidth:.33,  
                                    layout:'form',  
                                    //xtype:'fieldset',  
                                    autoHeight:true,  
                                    defaultType:'textfield',   
                                    items:[{id:'ImprovementCode',width:160,fieldLabel:'编号'}]}
                                    ]},{
                                    layout:'column',
                                    items:[{  
                                    columnWidth:.33,  
                                    layout:'form',  
                                    //xtype:'fieldset',  
                                    //autoHeight:true,  
                                    defaultType:'textfield',   
                                    items:[{id:'ImprovementStatus',width:140,fieldLabel:'状态'}]
                                    },{  
                                    columnWidth:.33,  
                                    layout:'form',  
                                    //xtype:'fieldset',  
                                    autoHeight:true,  
                                    defaultType:'textfield',   
                                    items:[{id:'ImprovementCreatDate',width:130,fieldLabel:'申请时间'}]},
                                    {  
                                    columnWidth:.33,  
                                    layout:'form',  
                                    //xtype:'fieldset',  
                                    autoHeight:true,  
                                    defaultType:'textfield',   
                                    items:[{id:'ImprovementCreateLoc',width:160,fieldLabel:'申请科室'}]}]
                                    },{
                                    layout:'column',
                                    items:[{  
                                    columnWidth:.33,  
                                    layout:'form',  
                                    //xtype:'fieldset',  
                                    //autoHeight:true,  
                                    defaultType:'textfield',   
                                    items:[{id:'ImprovementCreateUser',width:140,fieldLabel:'申请用户'}]
                                    },{  
                                    columnWidth:.33,  
                                    layout:'form',  
                                    //xtype:'fieldset',  
                                    autoHeight:true,  
                                    defaultType:'textfield',   
                                    items:[{id:'ImprovementCreateTel',width:130,fieldLabel:'联系方式'}]},
                                    {  
                                    columnWidth:.33,  
                                    layout:'form',  
                                    //xtype:'fieldset',  
                                    autoHeight:true,  
                                    defaultType:'textfield',   
                                    items:[{id:'ImprovementMenu',width:160,fieldLabel:'所属菜单'}]}]
                                    },{
                                    layout:'column',
                                    items:[{  
                                    columnWidth:.33,  
                                    layout:'form',  
                                    //xtype:'fieldset',  
                                    //autoHeight:true,  
                                    defaultType:'textfield',   
                                    items:[{id:'ImprovementDegree',width:140,fieldLabel:'严重程度'}]
                                    },{  
                                    columnWidth:.33,  
                                    layout:'form',  
                                    //xtype:'fieldset',  
                                    autoHeight:true,  
                                    defaultType:'textfield',   
                                    items:[{id:'ImprovementEmergency',width:130,fieldLabel:'紧急程度'}]},
                                    {  
                                    columnWidth:.33,  
                                    layout:'form',  
                                    //xtype:'fieldset',  
                                    autoHeight:true,  
                                    defaultType:'textfield',   
                                    items:[{id:'ImprovementModule',width:160,fieldLabel:'所属模块'}]}]
                                    },{
                                    layout:'column',
                                    items:[{  
                                    columnWidth:.33,  
                                    layout:'form',  
                                    //xtype:'fieldset',  
                                    //autoHeight:true,  
                                    defaultType:'textfield',   
                                    items:[{id:'ImprovementAsEngi',width:140,fieldLabel:'工程师'}]
                                    },{  
                                    columnWidth:.33,  
                                    layout:'form',  
                                    //xtype:'fieldset',  
                                    autoHeight:true,  
                                    defaultType:'textfield',   
                                    items:[{id:'ImprovementStandby2',width:130,fieldLabel:'沟通人员'}]},
                                    {  
                                    columnWidth:.33,  
                                    layout:'form',  
                                    //xtype:'fieldset',  
                                    autoHeight:true,  
                                    defaultType:'textfield',   
                                    items:[{id:'ImprovementStandby4',width:160,fieldLabel:'沟通结果'}]}]
                                    },{  
                                    xtype:'fieldset',  
                                    autoHeight:true,  
                                    id:'ImprovementSituation',
                                    title:'需求描述',  
                                    items:[{  
                                    width:600,  
                                    height:80,  
                                    xtype:'textarea'}]
                                    },{  
                                    xtype:'fieldset',  
                                    autoHeight:true,  
                                    id:'ImprovementStandby3',
                                    title:'要求效果',  
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
   Ext.Msg.alert('温馨提示','未选中数据');
   return;
   };
   var url = "PMP.Common.csp?actiontype=AddAppraisal&Rowidvlaue="+Rowidvlaue+"&InPut="+str;
				//alert(url);
				Ext.Ajax.request({
							url : url,
							method : 'POST',
							waitMsg : '数据存储中..',
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
									Ext.Msg.alert("success", "数据更新成功!");
									//clearData();
								} else {
									var ret=jsonData.info;
									if(ret==-1){
										Ext.Msg.alert("error", "数据更新失败!"+ret);
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
							waitMsg : '数据存储中..',
							success : function(result, request) {
								var jsonData = Ext.util.JSON
										.decode(result.responseText);
										var ret=jsonData.info;
								if (jsonData.success == 'true') {
									//Ext.Msg.alert("success", "数据操作成功!"+ret);
									if(ret=="1"){
									Ext.MessageBox.confirm('提示','您已经评价过，是否要重新评价？',function(btn){
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
										Ext.Msg.alert("error", "数据更新失败!"+ret);
									}
								}
							},
							scope : this
						});
}