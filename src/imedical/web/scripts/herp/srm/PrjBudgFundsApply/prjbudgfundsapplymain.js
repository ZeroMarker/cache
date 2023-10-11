var userid = session['LOGON.USERID'];
var usercode = session['LOGON.USERCODE'];

var groupdesc = session['LOGON.GROUPDESC'];
/* if (groupdesc==srmrdgroupdesc)
{  usercode=""
} */
if (groupdesc=="科研管理系统(信息查询)")
{  usercode=""
}	
var prjbudgfundsURL='herp.srm.prjbudgfundsapplyexe.csp';
	
//查询年度
var yearDs = new Ext.data.Store({
	//autoLoad:true,
	proxy:"",
	reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','name'])
});


yearDs.on('beforeload', function(ds, o){
	ds.proxy=new Ext.data.HttpProxy({
	url:prjbudgfundsURL+'?action=yearlist&str='+encodeURIComponent(Ext.getCmp('yearField').getRawValue()),method:'POST'});
});

var yearField = new Ext.form.ComboBox({
	id: 'yearField',
	fieldLabel: '年度',
	width:120,
	listWidth : 260,
	//allowBlank: false,
	store: yearDs,
	valueField: 'rowid',
	displayField: 'name',
	triggerAction: 'all',
	//emptyText:'请选择年度...',
	name: 'yearField',
	minChars: 1,
	pageSize: 10,
	selectOnFocus:true,
	forceSelection:'true',
	editable:true
});

//项目类型  prjtypelist
var propertyStore = new Ext.data.Store({
	//autoLoad:true,
	proxy:"",
	reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','Name'])
});


propertyStore.on('beforeload', function(ds, o){
	ds.proxy=new Ext.data.HttpProxy({
	url:prjbudgfundsURL+'?action=prjtypelist&str='+encodeURIComponent(Ext.getCmp('propertycomb').getRawValue()),method:'POST'});
});

var propertycomb = new Ext.form.ComboBox({
	id: 'propertycomb',
	fieldLabel: '年度',
	width:120,
	listWidth : 260,
	//allowBlank: false,
	store: propertyStore,
	valueField: 'rowid',
	displayField: 'Name',
	triggerAction: 'all',
	//emptyText:'请选择项目类型...',
	name: 'propertycomb',
	minChars: 1,
	pageSize: 10,
	selectOnFocus:true,
	forceSelection:'true',
	editable:true
});


/////////////项目名称////////////////
var ProjectName = new Ext.form.TextField({
			//columnWidth : .1,
			width : 120,
			//emptyText:'项目名称或编码...',
			//columnWidth : .15,
			selectOnFocus : true
		});
		
var searchButton = new Ext.Toolbar.Button({
	text: '查询',
    //tooltip:'查询',        
    iconCls: 'search',
	handler:function(){
	
	var year=yearField.getValue();
	var prjcode=ProjectName.getValue();
	var prjtype = propertycomb.getValue();  
	
	/* if (groupdesc==srmrdgroupdesc)
	{  usercode=""
	} */
	if (groupdesc=="科研管理系统(信息查询)")
	{  usercode=""
	}
	
	prjbudgfundsGrid.load(({params:{year:year,prjtype:prjtype,prjcode:prjcode,usercode:usercode,start:0, limit:25}}));
	}
});


var prjbudgfundsGrid = new dhc.herp.Gridlyfmain({
	title: '项目经费编制信息列表',
			iconCls: 'list',
    region : 'north',
    url: prjbudgfundsURL,
    fields: [
    new Ext.grid.CheckboxSelectionModel({editable:false,singleSelect:true}),
    {
        id:'rowid',
        header: '项目ID',
        editable:false,
        dataIndex: 'rowid',
        hidden: true
    },{
        id:'yeardr',
        header: '年度dr',
        dataIndex: 'yeardr',
        width:60,
		hidden:true,
		editable:false
    },{
        id:'year',
        header: '年度',
        dataIndex: 'year',
        width:60,
		editable:false
    },{ 
        id:'code',
        header: '项目编码',
        dataIndex: 'code',
        width:100,
		editable:false
    },{
        id:'name',
        header: '项目名称',
        dataIndex: 'name',
        width:180,
        editable:false,
renderer: function formatQtip(data,metadata)
						{
							var title = "";
							var tip = data;
							metadata.attr = 'ext:qtitle="' + title + '"' + 'ext:qtip="' + tip + '"';
							return data;
						}		
    },{
        id:'deptdr',
        header: '责任科室',
        width:100,
		editable:false,
        dataIndex: 'deptdr',	
        hidden: true
    },{
        id:'deptname',
        header: '责任科室',
        dataIndex: 'deptname',
        width:120,
		//tip:true,
		editable:false,
		renderer: function formatQtip(data,metadata)
						{
							var title = "";
							var tip = data;
							metadata.attr = 'ext:qtitle="' + title + '"' + 'ext:qtip="' + tip + '"';
							return data;
						}
    },{
        id:'headdr',
        header: '项目负责人ID',
        width:100,
		//tip:true,
		allowBlank: false,
		editable:false,
        dataIndex: 'headdr',	
        hidden: true
    }, {
        id:'head',
        header: '项目负责人',
        width:80,
		//tip:true,
		allowBlank: false,
		editable:false,
        dataIndex: 'head'
    },{
	    id:'subsourse',
    	header: '项目来源',
        dataIndex: 'subsourse',
        width: 180,		
        hidden:false,  
        editable:false
    },{
    	id:'grafunds',
        header: '批准经费(万元)',
        width:100,
	    editable:false,
	    xtype:'numbercolumn',
	    align:'right',
        dataIndex: 'grafunds',
        renderer: function(val)
         {
	         val=val.replace(/(^\s*)|(\s*$)/g, "");
	         val=Ext.util.Format.number(val,'0.00');
	         val=val.replace(/(\d{1,3})(?=(\d{3})+(?:$|\D))/g,"$1,")
	         return val?val:'';
		 }
    },{
    	id:'fundown',
        header: '自筹资金(万元)',
        width:80,
        align:'right',
		hidden:true,
        xtype:'numbercolumn',
	    allowBlank: true,
        dataIndex: 'fundown'
    },{
    	id:'fundgov',
        header: '政府拨款(万元)',
        width:80,
		hidden:true,
	    align:'right',
	    allowBlank: true,
	    xtype:'numbercolumn',
        dataIndex: 'fundgov'
    },{
       id:'prjstatus',
       header: '项目状态',
       width:100,
	   //hidden:true,  
	   allowBlank: true,
	   editable:false,
       dataIndex: 'prjstatus'
  },{
       id:'prjstatusindex',
       header: '项目状态id',
       width:100,
	   hidden:true,  
	   allowBlank: true,
	   editable:false,
       dataIndex: '项目状态id'
  },{
       id:'resaudit1',
       header: '审核状态',
       width:100,
	   hidden:true,  
	   allowBlank: true,
	   editable:false,
       dataIndex: 'resaudit1'
  },{           
       id:'sedate',
       header: '起止时间',
       allowBlank: false,
       width:150,
       editable:false,
       dataIndex: 'sedate'
  },{
			id:'download',
			header: '下载',
			allowBlank: false,
			width:40,
			editable:false,
			dataIndex: 'download',
			renderer : function(v, p, r){
			return '<span style="color:blue"><u>下载</u></span>';
			} 
		}],
	layout:"fit",
	split : true,
	collapsible : true,
	containerScroll : true,
	xtype : 'grid',
	sm : new Ext.grid.RowSelectionModel({
				singleSelect : true
			}),
	//loadMask : true,
	tbar:['','立项年度','',yearField,'','项目类型','',propertycomb,'','项目名称','',ProjectName,'-',searchButton],
    //atLoad : true, // 是否自动刷新
	height:300,
	trackMouseOver: true,
	stripeRows: true

});

/* if (groupdesc==srmrdgroupdesc)
{  usercode=""
} */
if (groupdesc=="科研管理系统(信息查询)")
{  usercode=""
}
	
prjbudgfundsGrid.load({	
	params:{start:0, limit:25,usercode:usercode}
});

var row="";

prjbudgfundsGrid.on('rowclick',function(grid,rowIndex,e){	
	row=rowIndex;
    var prjdr="";
	var selectedRow = prjbudgfundsGrid.getSelectionModel().getSelections();
	prjdr=selectedRow[0].data['rowid'];
	//alert(usercode);
	prjbudgfundsDetail.load({params:{start:0, limit:25,prjdr:prjdr,usercode:session['LOGON.USERCODE']}});	
});

//uploadMainFun(itemGrid,'rowid','P004',9);
downloadMainFun(prjbudgfundsGrid,'rowid','P007',19);