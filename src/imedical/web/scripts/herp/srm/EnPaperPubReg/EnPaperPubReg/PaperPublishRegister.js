
var userdr = session['LOGON.USERCODE'];

var groupdesc = session['LOGON.GROUPDESC'];
if (groupdesc=="科研管理系统(信息修改)")
{ var userdr=""
	}


var projUrl = 'herp.srm.SRMEnPaperPubRegexe.csp';

// 定义起始时间控件
	var startDate = new Ext.form.DateField({
		  id:'startDate',
		  fieldLabel: '开始日期',
			width:200,
			//format:'Y-m-d',
			columnWidth : .12,
			renderer : function(v, p, r, i) {			
			if (v instanceof Date) {
				return new Date(v).format("Y-m-d");
			} else {return v;}
			},
			selectOnFocus:'true'
	});
	var endDate = new Ext.form.DateField({
		  id:'endDate',
		  fieldLabel: '结束日期',
			width:200,
			//format:'Y-m-d',
			columnWidth : .12,
			renderer : function(v, p, r, i) {			
			if (v instanceof Date) {
				return new Date(v).format("Y-m-d");
			} else {return v;}
			},
			selectOnFocus:'true'
	});
/////////////////开始时间////////////////////////////
var StartdDateField = new Ext.form.DateField({
		id : 'StartdDateField',
		//format : 'Y-m-d',
		fieldLabel:'开始日期',
		width : 120,
		editable:true,
		emptyText : '请选择开始日期...'
	});

/////////////////结束时间////////////////////////////
var EnddDateField = new Ext.form.DateField({
		id : 'EnddDateField',
		//format : 'Y-m-d',
		fieldLabel:'结束日期',
		width : 120,
		editable:true,
		emptyText : '请选择结束日期...'
	});
//md.formatDate(searchContractDate.getValue())


/////////////////科室////////////////////////
var DeptDs = new Ext.data.Store({
	//autoLoad:true,
	proxy:"",
	reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','name'])
});


DeptDs.on('beforeload', function(ds, o){
	ds.proxy=new Ext.data.HttpProxy({
	url:projUrl+'?action=GetDept&str='+encodeURIComponent(Ext.getCmp('DeptField').getRawValue()),method:'POST'});
});

var DeptField = new Ext.form.ComboBox({
	id: 'DeptField',
	fieldLabel: '科室',
	width:120,
	listWidth : 250,
	allowBlank: true,
	store:DeptDs,
	valueField: 'rowid',
	displayField: 'name',
	triggerAction: 'all',
	emptyText:'请选择科室...',
	name: 'DeptField',
	minChars: 1,
	pageSize: 10,
	selectOnFocus:true,
	forceSelection:true,
	editable:true
});


/////////////////论文题目
var PaperName = new Ext.form.TextField({
                width: 120,
                allowBlank: true,
                name: 'PaperName',
                fieldLabel: '论文题目',
                blankText: '请输入论文题目'
            });


/////////////////期刊名称
var PeriodiNamDs = new Ext.data.Store({
	//autoLoad:true,
	proxy:"",
	reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','name'])
});

PeriodiNamDs.on('beforeload', function(ds, o){
	ds.proxy=new Ext.data.HttpProxy({
	url:projUrl+'?action=GetJournalDict&str='+encodeURIComponent(Ext.getCmp('PeriodiNam').getRawValue()),method:'POST'});
});

var PeriodiNam = new Ext.form.ComboBox({
	id: 'PeriodiNam',
	fieldLabel: '期刊名称',
	width:120,
	listWidth : 250,
	allowBlank: true,
	store:PeriodiNamDs,
	valueField: 'rowid',
	displayField: 'name',
	triggerAction: 'all',
	emptyText:'请选择期刊名称...',
	name: 'PeriodiNam',
	minChars: 1,
	pageSize: 10,
	selectOnFocus:true,
	forceSelection:true,
	editable:true
});

/////////////////第一作者
var FisAuthorDs = new Ext.data.Store({
	//autoLoad:true,
	proxy:"",
	reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','name'])
});

FisAuthorDs.on('beforeload', function(ds, o){
	ds.proxy=new Ext.data.HttpProxy({
	url:projUrl+'?action=GetAuthor&str='+encodeURIComponent(Ext.getCmp('FisAuthor').getRawValue()),method:'POST'});
});

var FisAuthorField = new Ext.form.ComboBox({
	id: 'FisAuthor',
	fieldLabel: '第一作者',
	width:120,
	listWidth : 250,
	allowBlank: true,
	store:FisAuthorDs,
	valueField: 'rowid',
	displayField: 'name',
	triggerAction: 'all',
	emptyText:'请选择第一作者...',
	name: 'FisAuthor',
	minChars: 1,
	pageSize: 10,
	selectOnFocus:true,
	forceSelection:true,
	editable:true
});

/////////////////通讯作者
var ComAuthorDs = new Ext.data.Store({
	//autoLoad:true,
	proxy:"",
	reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','name'])
});


ComAuthorDs.on('beforeload', function(ds, o){
	ds.proxy=new Ext.data.HttpProxy({
	url:projUrl+'?action=GetAuthor&str='+encodeURIComponent(Ext.getCmp('ComAuthor').getRawValue()),method:'POST'});
});

var ComAuthorField = new Ext.form.ComboBox({
	id: 'ComAuthor',
	fieldLabel: '第一通讯作者',
	width:120,
	listWidth : 250,
	allowBlank: true,
	store:ComAuthorDs,
	valueField: 'rowid',
	displayField: 'name',
	triggerAction: 'all',
	emptyText:'请选择第一通讯作者...',
	name: 'ComAuthor',
	minChars: 1,
	pageSize: 10,
	selectOnFocus:true,
	forceSelection:true,
	editable:true
});

/////////////////查询按钮响应函数//////////////
function SearchFun()
{

	var startTime= startDate.getValue();
	if (startTime!=="")
    {
       //startTime=startTime.format ('Y-m-d');
    }
	var endTime  = endDate.getValue();
	if (endTime!=="")
    {
       //endTime=endTime.format ('Y-m-d');
    }
        var Dept      = DeptField.getValue();
        var PaperNames= PaperName.getValue();
        var PeriodiNams= PeriodiNam.getRawValue();  
        var FisAuthor = FisAuthorField.getValue();
        var ComAuthor = ComAuthorField.getValue();
        var date = startTime+"|"+endTime+"|"+Dept+"|"+PaperNames+"|"+PeriodiNams+"|"+FisAuthor+"|"+ComAuthor+"|"+userdr 

        itemGrid.load({params:{date:date,sortField:'',sortDir:'',start:0,limit:25}});      
}

//////////////////////////////////////////////
var queryPanel = new Ext.FormPanel({
	height : 130,
	region : 'north',
	frame : true,

	defaults : {
		bodyStyle : 'padding:5px'
	},
	items : [{
		xtype : 'panel',
		layout : "column",
		items : [{
			xtype : 'displayfield',
			value : '<center><p style="font-weight:bold;font-size:100%">论文报销与奖励申请</p></center>',
			columnWidth : 1,
			height : '32'
		}]
	}, {
		columnWidth : 1,
		xtype : 'panel',
		layout : "column",
		items : [{
				xtype : 'displayfield',
				value : '申请时间:',
				columnWidth : .09
				},startDate,{
				xtype:'displayfield',
				value:'',
				columnWidth:.02
				},{
				xtype:'displayfield',
				value:'至:',
				columnWidth:.03
				},endDate,{
				xtype:'displayfield',
				value:'',
				columnWidth:.02
				},{
				xtype : 'displayfield',
				value : '科室:',
				columnWidth : .09
				},DeptField,{
				xtype:'displayfield',
				value:'',
				columnWidth:.02
				},{
				xtype : 'displayfield',
				value : '论文题目:',
				columnWidth : .09
				},PaperName,{
				xtype:'displayfield',
				value:'',
				columnWidth:.02
				}]
	}, {
		columnWidth : 1,
		xtype : 'panel',
		layout : "column",
		items : [{
				xtype : 'displayfield',
				value : '期刊名称:',
				columnWidth : .09
				},PeriodiNam,
				{
				xtype:'displayfield',
				value:'',
				columnWidth:.02
				},{
				xtype : 'displayfield',
				value : '第一作者:',
				columnWidth : .09
				},FisAuthorField,{
				xtype:'displayfield',
				value:'',
				columnWidth:.02
				},{
				xtype : 'displayfield',
				value : '第一通讯作者:',
				columnWidth : .12
				},ComAuthorField,{
				xtype:'displayfield',
				value:'',
				columnWidth:.06
				},{
				columnWidth:0.05,
				xtype:'button',
				text: '查询',
				handler:function(b){SearchFun();},
				iconCls: 'find'
				}]
	}]
	
});

var itemGrid = new dhc.herp.Grid({
			region : 'center',
			url : projUrl,	
			//atLoad:true,        
			fields : [
			new Ext.grid.CheckboxSelectionModel(
			{    hidden : true,
				editable:false
				
				}
			
			),
			    {
						header : 'ID',
						dataIndex : 'rowid',
						hidden : true
					}, {
						id : 'RecordType',
						header : '期刊类型',
						width : 120,
						editable:false,
						hidden:true,
						dataIndex : 'RecordType'
					},{
						id : 'JourLevel',
						header : '期刊级别',
						width : 120,
						editable:false,
						hidden:true,
						dataIndex : 'JourLevel'
					},{
						id : 'JName',
						header : ' 期刊名称',
						editable:false,
						width : 120,
						hidden:true,
						dataIndex : 'JName'
					},{
						id : 'PaperType',
						header : '论文类别 ',
						width : 120,
						editable:false,
						hidden:true,
						allowBlank : false,                
						dataIndex : 'PaperType'
					},{
						id : 'Title',
						header : '论文题目 ',
						width : 180,
						editable:false,
						allowBlank : false,   
					  renderer : function(value,cellmeta, record,rowIndex, columnIndex, store) { 
						           return '<span style="color:blue;cursor:hand;TEXT-DECORATION:underline">'+value+'</span>';
						},           
						dataIndex : 'Title'
					},{
						id : 'CompleteUnit',
						header : '第几完成单位 ',
						width : 120,
						editable:false,
						allowBlank : false,                
						dataIndex : 'CompleteUnit'
					},{
						id : 'RegInfo',
						header : ' 年卷期页',
						editable:false,
						width : 120,
						hidden:true,
						dataIndex : 'RegInfo'
					},{
						id : 'PubYear',
						header : '年',
						//xtype:'numbercolumn',
						width : 120,
						editable : false,
						align:'right',
						hidden:true,
						dataIndex : 'PubYear'
					},{
						id : 'Roll',
						header : '卷',
						//xtype:'numbercolumn',
						width : 120,
						editable : false,
						align:'right',
						hidden:true,
						dataIndex : 'Roll'
					},{
						id : 'Period',
						header : '期',
						//xtype:'numbercolumn',
						width : 120,
						editable : false,
						align:'right',
						hidden:true,
						dataIndex : 'Period'
					},{
						id : 'StartPage',
						header : '起始页',
						//xtype:'numbercolumn',
						hidden:true,
						width : 120,
						editable : false,
						align:'right',
						dataIndex : 'StartPage'
					},{
						id : 'EndPage',
						header : '结束页',
						//xtype:'numbercolumn',
						hidden:true,
						width : 120,
						editable : false,
						align:'right',
						dataIndex : 'EndPage'
					},{
						id : 'FristAuthor',
						header : ' 第一作者',
						//xtype:'numbercolumn',
						width : 120,
						editable : false,
						align:'left',
						dataIndex : 'FristAuthor'
					}, {
						id : 'FristAuthorRange',
						header : '第一作者排名',
						//xtype:'numbercolumn',
						width : 120,
						editable : false,
						align:'right',
						hidden:true,
						dataIndex : 'FristAuthorRange'
					},{
						id : 'FristAuthorDept',
						header : ' 第一作者科室',
						//xtype:'numbercolumn',
						width : 120,
						editable : false,
						align:'right',
						hidden:true,
						dataIndex : 'FristAuthorDept'
					}, {
						id : 'FristAuthorComp',
						header : '第一作者单位',
						width : 120,
						align:'right',
						editable:false,
						hidden:true,
						dataIndex : 'FristAuthorComp'
					},{
						id : 'CorrAuthor',
						header : '第一通讯作者',
						editable:false,
						width : 120,
						dataIndex : 'CorrAuthor'
					},{
						id : 'CorrAuthorRange',
						header : '通讯作者排名',
						editable:false,
						width : 120,
						align:'right',
						hidden:true,
						dataIndex : 'CorrAuthorRange'
					},{
						id : 'CorrAuthorDept',
						header : '第一通讯作科室',
						editable:false,
						width : 120,
						align:'right',
						hidden:true,
						dataIndex : 'CorrAuthorDept'
					},{
						id : 'CorrAuthorComp',
						header : '通讯作者单位',
						editable:false,
						width : 120,
						hidden:true,
						align:'right',
						dataIndex : 'CorrAuthorComp'
					},{
						id : 'AllAuthorInfo',
						header : '论文作者',
						editable:false,
						width : 120,
						hidden:false,
						renderer : function(value,cellmeta, record,rowIndex, columnIndex, store) { 
						           return '<span style="color:blue;cursor:hand;TEXT-DECORATION:underline">'+value+'</span>';
						},
						dataIndex : 'AllAuthorInfo'
					},{
						id : 'AllCorrAuthorInfo',
						header : '论文通讯作者',
						editable:false,
						width : 120,
						hidden:false,
						renderer : function(value,cellmeta, record,rowIndex, columnIndex, store) { 
						           return '<span style="color:blue;cursor:hand;TEXT-DECORATION:underline">'+value+'</span>';
						},
						dataIndex : 'AllCorrAuthorInfo'
					},{
						id : 'IF',
						header : '影响因子',
						hidden:false,
						editable:false,
						width : 120,
						hidden:true,
						dataIndex : 'IF'
					},{
						id : 'InvoiceCode',
						header : '发票代码 ',
						width : 120,
						editable:false,
						hidden:true,
						allowBlank : false,                
						dataIndex : 'InvoiceCode'
					},{
						id : 'InvoiceNo',
						header : '发票号码 ',
						width : 120,
						editable:false,
						hidden:true,
						allowBlank : false,                
						dataIndex : 'InvoiceNo'
					},{
						id : 'PageCharge',
						header : '版面费',
						editable:false,
						width : 80,
						dataIndex : 'PageCharge'
					},{
						id : 'UnitMoney',
						header : '货币单位',
						editable:false,
						width : 80,
						dataIndex : 'UnitMoney'
					},{
						id : 'Ratio',
						header : '报销比例',
						editable:false,
						//hidden:true,
						width : 80,
						dataIndex : 'Ratio'
					},{
						id : 'REAmount',
						header : '实报版面费',
						editable:false,
						width : 80,
						dataIndex : 'REAmount'
					},{
						id : 'RewardAmount',
						header : '奖励金额(元)',
						editable:false,
						width : 120,
						dataIndex : 'RewardAmount'
					},{
						id : 'SubUser',
						header : '申请人',
						editable:false,
						width : 120,
						dataIndex : 'SubUser'
					},{
						id : 'DeptName',
						header : '申请人科室',
						editable:false,
						width : 120,
						dataIndex : 'DeptName'
					},{
						id : 'SubDate',
						header : '申请时间',
						hidden:false,
						editable:false,
						width : 120,
						dataIndex : 'SubDate'
					},{
						id : 'DataStatus',
						header : '提交状态',
						editable:false,
						hidden:false,
						width : 120,
						dataIndex : 'DataStatus'
					},{
						id : 'CheckState',
						header : '审批状态',
						editable:false,
						width : 120,
						dataIndex : 'CheckState'
					},{
						id : 'Desc',
						header : '审批意见',
						editable:false,
						width : 180,
						dataIndex : 'Desc'
					},{
						id : 'AuthorsInfo',
						header : '作者排名',
						editable:false,
						width : 120,
						hidden:true,
						dataIndex : 'AuthorsInfo'
					},{
						id : 'CorrAuthorsInfo',
						header : '通讯作者排名',
						editable:false,
						width : 120,
						hidden:true,
						dataIndex : 'CorrAuthorsInfo'
					}, {
							id:'upload',
							header: '原文',
							allowBlank: false,
							width:50,
							editable:false,
							dataIndex: 'upload',
							renderer : function(v, p, r){			
							return '<span style="color:blue"><u>上传</u></span>';
							}
					}, {
							id:'upload1',
							header: '收录证明',
							allowBlank: false,
							width:70,
							editable:false,
							dataIndex: 'upload',
							renderer : function(v, p, r){			
							return '<span style="color:blue"><u>上传</u></span>';
							}
					},{
							id:'download',
							header: '附件',
							allowBlank: false,
							width:40,
							editable:false,
							dataIndex: 'download',
							renderer : function(v, p, r){
								//alert(itemGrid1);
							return '<span style="color:blue"><u>下载</u></span>';
							//return '<span style="color:gray;cursor:hand">审核</span>';
					    } 
					},{
							id:'ESICited',
							header: '是否ESI高被引',
							allowBlank: false,
							width:40,
							editable:false,
							hidden:true,
							dataIndex: 'ESICited'
					}] 

		});
		
/////////////////添加按钮////////////////////////////
var addButton = new Ext.Toolbar.Button({
	text: '添加',
        tooltip:'添加',        
        iconCls:'add',
	handler:function(){
	AddFun();			
	}
	
});

/////////////////修改按钮//////////////////
var editButton = new Ext.Toolbar.Button({
	text: '修改',
        tooltip:'修改',        
        iconCls:'option',
	handler:function(){
		var rowObj = itemGrid.getSelectionModel().getSelections();
		if(rowObj.length<1){
		 Ext.Msg.show({title:'提示',msg:'请选择需要修改的行!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
		 return;
		}
		var state = rowObj[0].get("DataStatus");
		var AuthorInfoID = rowObj[0].get("AuthorsInfo");
		var CorrAuthorInfoID = rowObj[0].get("CorrAuthorsInfo");
		
		
		
		if((state == "未提交")||(groupdesc=="科研管理系统(信息修改)" )){EditFun(AuthorInfoID,CorrAuthorInfoID);}
		else {Ext.Msg.show({title:'警告',msg:'数据已提交，不可再修改！',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});}	
			
	}
	
});

////////////////删除按钮/////////////////////
var delButton = new Ext.Toolbar.Button({
	text:'删除',
	tooltip:'删除',
	iconCls:'remove',
	handler:function(){
		var rowObj = itemGrid.getSelectionModel().getSelections();
		var state = rowObj[0].get("DataStatus");
		if(state == "未提交" ){delFun();}
		else {Ext.Msg.show({title:'警告',msg:'数据已提交，不可再删除！',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});}	
	}	
});

/////////////////提交按钮/////////////////////
var submitButton = new Ext.Toolbar.Button({
		text: '提交',
        tooltip:'提交',        
        iconCls:'option',
		handler:function(){
		var rowObj = itemGrid.getSelectionModel().getSelections();
		
			var len = rowObj.length;
			if (len<1){
				Ext.Msg.show({title:'注意',msg:'请选择需要提交的数据!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			    return;
			}
			
			//////////////////////////判断是否有附件上传记录///////////////////////////
				Ext.Ajax.request({
					url:'herp.srm.uploadexe.csp?action=GetUpLoadInfo&RecDr='+rowObj[0].get("rowid")+'&SysNo='+'P00201',
					success: function(result, request){
						var jsonData = Ext.util.JSON.decode( result.responseText );
						
						if (jsonData.success=='true'){				
							Ext.Msg.show({title:'注意',msg:'请上传原文附件!',icon:Ext.MessageBox.INFO,buttons:Ext.Msg.OK});					
						
							return;
						}
						
					},
					scope: this			
				  });
		///////////////////////////////////////
		
			var state = rowObj[0].get("DataStatus");
		if(state == "未提交"){submitFun();}
		else {Ext.Msg.show({title:'警告',msg:'数据已提交，不可再提交！',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});}				
		}
	
});
  itemGrid.addButton('-');
  itemGrid.addButton(addButton);
  itemGrid.addButton('-');
  itemGrid.addButton(editButton);
  itemGrid.addButton('-');
  itemGrid.addButton(delButton);
  itemGrid.addButton('-');
  itemGrid.addButton(submitButton);
  //itemGrid.addButton('-');
  //itemGrid.addButton(upLaodButton);

  
    itemGrid.btnAddHide();     //隐藏增加按钮
    itemGrid.btnSaveHide();    //隐藏保存按钮
    itemGrid.btnResetHide();   //隐藏重置按钮
    itemGrid.btnDeleteHide();  //隐藏删除按钮
    itemGrid.btnPrintHide();   //隐藏打印按钮

itemGrid.load({params:{start:0, limit:12, userdr:userdr}});


var date = "|||||||"+userdr;
itemGrid.load({params:{date:date,sortField:'', sortDir:'',start:0,limit:25}});      


// 单击gird的单元格事件
itemGrid.on('cellclick', function(g, rowIndex, columnIndex, e) {
	//  论文题目
	if (columnIndex == 7) {
		PaperDetail(itemGrid);
	}
	//作者排名
	if (columnIndex == 23) {
		var records = itemGrid.getSelectionModel().getSelections();
		var authorinfo = records[0].get("AuthorsInfo");
//		var corrauthorinfo = records[0].get("CorrAuthorsInfo");
//		authorinfo=authorinfo+','+corrauthorinfo;
    var title = records[0].get("Title");
		AuthorInfoList(title,authorinfo);
	}
	if (columnIndex == 24) {
		var records = itemGrid.getSelectionModel().getSelections();
		var corrauthorinfo = records[0].get("CorrAuthorsInfo");
		//alert(authorinfo);
		var title = records[0].get("Title");
		CorrAuthorInfoList(title,corrauthorinfo);
	}
	
		
	
});

if (groupdesc=="科研管理系统(信息修改)")
{
	 addButton.disable();//设置为不可用
	  delButton.disable();//设置为不可用
	  submitButton.disable();//设置为不可用
	  
	
	}
uploadMainFun(itemGrid,'rowid','P00201',41);//原文上传
uploadMainFun(itemGrid,'rowid','P00202',42);//收录证明上传
downloadMainFun(itemGrid,'rowid','P00201,P00202',43);//下载原文和收录证明
