/**
 * @author Administrator
 */
/*
 * grid.store.on('load', function() {
 * grid.el.select("table[class=x-grid3-row-table]").each(function(x) {
 * x.addClass('x-grid3-cell-text-visible'); }); });
 * 
 * grid.getStore().on('load',function(s,records){ var girdcount=0;
 * s.each(function(r){ if(r.get('10')=='数据错误'){
 * grid.getView().getRow(girdcount).style.backgroundColor='#F7FE2E'; }
 * girdcount=girdcount+1; }); //scope:this });
 */
var grid;
var grid1;
var recId;
var locdata = new Array();
var modledata = new Array();
var loc = session['LOGON.CTLOCID'];
cspRunServerMethod(getloc, 'addloc');

//根下拉
var GArr
function getgname(seloc)
{
 	 GArr=tkMakeServerCall("User.DHCNURMenu","GetGName",seloc)
 	// alert(GArr)
 	 if (GArr=="")
 	 {
 	   GArr=[]
 	 }
	 //alert(GArr)
 	 GArr=eval(GArr);
}
getgname("")
function addloc(a, b) {
	locdata.push({
				loc : a,
				locdes : b
			});
}
var storeloc = new Ext.data.JsonStore({
			data : locdata,
			fields : ['loc', 'locdes']
		});
//var THeight=window.screen.height-180;   
var THeight=window.screen.availHeight-window.screenTop-30;
var locField = new Ext.form.ComboBox({
			id : 'locsys',
			hiddenName : 'loc1',
			store : storeloc,
			listeners:{
		    focus: {
				fn: function (e) {
				e.expand();
				this.doQuery(this.allQuery, true);
				},
				buffer: 200
			},
			beforequery: function (e) {
				var combo = e.combo;
				var me = this;
				if (!e.forceAll) {
					var input = e.query;
					var regExp = new RegExp("^" + input + ".*", "i");
						combo.store.filterBy(function (record, id) {
						var text = getPinyin(record.data[me.displayField]);
						return regExp.test(text)|regExp.test(record.data[me.displayField]); 
					});
					combo.expand();
					combo.select(0, true);
					return false;
				}
		    }
	},
			width : 150,
			height:THeight,
			fieldLabel : '科室',
			valueField : 'loc',
			displayField : 'locdes',
			triggerAction : 'all',
			allowBlank : true,
			forceSelection :true,
			mode : 'local',
			anchor : '100%'
			
			
		});
locField.on('select', function() {
			find();
		});
		
var checkColumn = new Ext.grid.CheckboxSelectionModel({ 
       header: 'Indoor?',
       dataIndex: 'indoor',
       width: 55
    });
	var pwidth=document.body.clientWidth;
var modelgrid = new Ext.grid.EditorGridPanel({
		x:260,
		y:0,
		id : 'mygrid1',
		name : 'mygrid1',
		title : '科室列表',
        title: '模版选择',
        clicksToEdit : 1,
        stripeRows : true,
        frame: false,
		//width: pwidth,//900,
        height: THeight,
		tbar : [{
					id : 'mygridbut3',
					icon:'../images/uiimages/filesave.png',
					text : '保存(按科室)',
					handler : save
		},{
					id : 'mygridbut4',
					icon:'../images/uiimages/saveapplycard.png',
					text : '保存(按全院)',
					handler : save2
		},{
					id : 'mygridbut7',
					icon:'../images/uiimages/filter.png',
					text : '查询已筛选',
					handler : findselect
		},{
					id : 'mygridbut5',
					icon:'../images/uiimages/read-unexec.png',
					text : '保存(筛选)',
					handler : saveselect
		},{
					id : 'mygridbut6',
					icon:'../images/uiimages/search.png',
					text : '查询所有模板',
					handler : findall
		},{
					id : 'mygridbut8',
					text : '根目录维护',
					icon:'../images/uiimages/schedulesets.png',
					handler : MainMenu
		},{
					id : 'mygridbut9',
					text : '子目录查询',
					icon:'../images/uiimages/searchallloc.png',
					handler : MainMenuSub
		},{
					id : 'mygridbut10',
					text : '表格弹出式关联维护',
					icon:'../images/uiimages/register.png',
					handler : ListLink
		}],
        store: new Ext.data.JsonStore({
					data : [],
					fields : ['ModelKey', 'ModelDesc',{name:'IfShow',type:'bool'},{name:'IfAllShow',type:'bool'},{name:'IfSelect',type:'bool'},'ModelSort','ModelName','GItem']
				}),
        colModel : new Ext.grid.ColumnModel({
			columns : [{
						header : '模版关键字',
						dataIndex : 'ModelKey',
						width : 150
					
					}, {
						header : '模版名称',
						dataIndex : 'ModelDesc',
						width : 220
					}, {
						type: 'bool',
						header : '科室是否显示',
						dataIndex : 'IfShow',
						width : 96,
						//renderre:	function(value){
						//				if(value==true){
						//					value = "<div class=\"x-grid3-col-checker-on\"> </div>";
						//				}
						//				else{         
						//					value = "<div class=\"x-grid3-col-checker\"> </div>"; 
						//				}     
						//				return value; 
						//			}
						//renderer: function(v){
						//		if(v=='Y') return '<input type=checkbox checked onclick="javascript:alert(this.checked)" />';
						//		else  return '<input type=checkbox onclick="javascript:alert(this.checked);" />';
						//	}
						editor : new Ext.grid.GridEditor(new Ext.form.Checkbox(
								{
									allowBlank : true
								})),
						renderer: function(value){
							if (value==1) return "是";
							else return "否";
						}
					}, {
						type: 'bool',
						header : '是否全院显示',
						dataIndex : 'IfAllShow',
						width :96,				
						editor : new Ext.grid.GridEditor(new Ext.form.Checkbox(
								{
									allowBlank : true
								})),
						renderer: function(value){
							if (value==1) return "是";
							else return "否";
						}
					}, {
						type: 'bool',
						header : '是否筛选',
						dataIndex : 'IfSelect',
						width : 66,				
						editor : new Ext.grid.GridEditor(new Ext.form.Checkbox(
								{
									allowBlank : true
								})),
						renderer: function(value){
							
							if (value==1) return "是";
							else return "否";
						}
					}, {
						header : '显示顺序',
						dataIndex : 'ModelSort',
						width : 66,
						editor : new Ext.grid.GridEditor(new Ext.form.TextField(
								{
									readOnly : false
								}))
					},{
						header : '显示名称',
						dataIndex : 'ModelName',
						width : 180,
						editor : new Ext.grid.GridEditor(new Ext.form.TextField(
								{
									readOnly : false
								}))
					}, {
						header : '根目录',
						dataIndex : 'GItem',
						width : 100,
						editor : new Ext.grid.GridEditor(
						  new Ext.form.ComboBox({
						  displayField:'desc',
						  triggerAction : 'all', 
						  valueField:'id',
						  store:new Ext.data.JsonStore({
						     data :GArr,
						    fields: ['desc', 'id']}),
						  mode:'local'}))
						//renderer: function(value,display,p3,p4,p5,p6){
						//	if (value!="")
							//{
							 
							 //debugger
						//	}
						//	return value
						//},
					
					}
					],
			rows : [],
			defaultSortable : true
		}),
		enableColumnMove : false,
		viewConfig : {
			forceFit : false
		},
		plugins : [new Ext.ux.plugins.GroupHeaderGrid()],
		sm : new Ext.grid.RowSelectionModel({
					singleSelect : false
				})
    });
 //弹出根目录   
function MainMenu()
{	
	 var lnk= "DHCNurEmrComm.csp?"+"&EmrCode=DHCNURMenu&EpisodeID="  ;//"&DtId="+DtId+"&ExamId="+ExamId
	 //alert(lnk)
	 var wind22455=window.open(lnk,"htm33444455",'left=300,top=100,toolbar=no,location=no,directories=no,resizable=yes,width=860,height=500');
}

 //弹出子目录   
function MainMenuSub()
{	
	 var lnk= "DHCNurEmrComm.csp?"+"&EmrCode=DHCNURMenuSub&EpisodeID="+LOC;//"&DtId="+DtId+"&ExamId="+ExamId
	 //alert(lnk)
	 var wind224552=window.open(lnk,"htm3344445522",'left=300,top=100,toolbar=no,location=no,directories=no,resizable=yes,width=860,height=600');
}
 //表格弹出式模板关联列表js和弹出界面js   
function ListLink()
{	
	 var lnk= "DHCNurEmrComm.csp?"+"&EmrCode=DHCNURListLink&EpisodeID="  ;//"&DtId="+DtId+"&ExamId="+ExamId
	 //alert(lnk)
	 var wind2245523=window.open(lnk,"htm33444455223",'left=300,top=100,toolbar=no,location=no,directories=no,resizable=yes,width=860,height=600');
}
function setsize(gpl,fgm,grd)
{
	var gfrm=Ext.getCmp(fgm);
	var fheight=gfrm.getHeight();
	var fwidth=gfrm.getWidth();
	var fm=Ext.getCmp(grd);
	var pl=Ext.getCmp(gpl);
	gfrm.autoScroll=true;
	if (fwidth>2000)  //IE11 兼容
	{
	   var zoon=detectZoom()
	   var woff=35;
	   var hoff=40;
	   if (zoon==125)
	   {
           woff=135
           hoff=70
	   }
	   if (zoon==150)
	   {
           woff=190
           hoff=75
	   }
	   fwidth=window.screen.availWidth-window.screenLeft-woff;
	   fheight=window.screen.availHeight-window.screenTop-hoff;
    }
	pl.setHeight(fheight-10);
	pl.setWidth(260);
}
function BodyLoadHandler() {
	setsize("mygridpl", "gform", "mygrid");
	var fm = Ext.getCmp('gform');
	fm.add(modelgrid);
	var but1 = Ext.getCmp("mygridbut1");
	but1.hide();
	var but = Ext.getCmp("mygridbut2");
	but.setText("保存");
	but.hide();
	
	grid = Ext.getCmp('mygrid');
	// grid.setTitle(gethead());

	var mydate = new Date();
	var tobar = grid.getTopToolbar();
	var bbar = grid.getBottomToolbar ();
	bbar.hide();
	tobar.addItem('科室', locField);
	tobar.addItem('-');
	tobar.addButton({
				//className : 'new-topic-button',
				icon:'../images/uiimages/search.png',
				text : "查询",
				handler : find,
				id : 'mygridSch'
			});
	tobar.addItem('-');
	// tobar.render(grid.tbar);
	tobar.doLayout();
	grid.addListener('rowclick', rowClickFn);
	grid1 = Ext.getCmp('mygrid1');
	grid1.on('beforeedit', waterbeforeEditFn);
	grid1.on('afteredit', waterafterEditFn);
	//find();
	Ext.QuickTips.init();//注意，提示初始化必须要有
  
setTimeout("findselect()",0)
//	findselect()
}
var select
function waterbeforeEditFn(e)
{   
   select=grid1.getSelectionModel().getSelections()[0]
}
//选择根目录
function waterafterEditFn(e)
{
		//alert(e.grid+","+e.record+","+e.field+","+e.value+","+e.originalValue+","+e.row+","+e.column);
		var errflag=0;
		var curfield=e.field;
		var curvalue=e.value;
		if (curfield=="GItem")
		{
		  //alert(curvalue)	
		  var code=select.get("ModelKey")
		  var name=select.get("ModelDesc")
		  var gname=tkMakeServerCall("User.DHCNURMenu","getnamebyid",curvalue)  //根目录名称
		  var parr =curvalue + "^" + code +"^"+LOC+"^"+name+"^"+gname
		  
		  var a=tkMakeServerCall("User.DHCNURMenuSub","Additm",parr) //保存
		  //alert(a)
		 
		  
		  
		  if (LOC=="")
		  {
		     loaddepmodelset("9000");
		  }
		  else
		  {
		   loaddepmodelset(LOC);
		  }
	     //var a = cspRunServerMethod(RecSave.value, parr,"");
		}
		alert("保存成功！")
}
var REC = new Array();
var LOC=""
var SelectedLocDesc="" ; //选中科室
function rowClickFn(grid, rowIndex, e) {
	//alert('你单击了' + rowIndex);
	var grid = Ext.getCmp("mygrid");
	var rowObj = grid.getSelectionModel().getSelections();
  LOC = rowObj[0].get("LocID");
  var LocDesc = rowObj[0].get("LocDesc");
  if (LocDesc.indexOf('-')>-1)
  {
	  var  arr=LocDesc.split('-');
	  SelectedLocDesc=arr[1]
	 
  }
  grid1.setTitle("选择的病区是："+LocDesc)
  var saveselect = Ext.getCmp("mygridbut4");
  saveselect.setDisabled(true)
  var saveselect = Ext.getCmp("mygridbut5"); 
  saveselect.setDisabled(true)
	  
  findbyloc(LOC);
 
  getgname(LOC)
	  
 
}
function find() {
	REC = new Array();
	var GetDep = document.getElementById('GetDep');
	var mygrid = Ext.getCmp("mygrid");
	var loc = Ext.get("loc1").dom.value;
	// debugger;
	//alert(loc)
	if (GetDep) 
	{
		var a = cspRunServerMethod(GetDep.value,loc,"AddRec");
	}
	mygrid.store.loadData(REC);
}
function AddRec(a1, a2) {
	// debugger;
	REC.push({
				LocDesc : a1,
				LocID : a2
			});
}
function loaddepmodelset(locId)
{
	REC = new Array();
    //gitmobj.store.loadData(GArr)
	var GetDepModelSet = document.getElementById('GetDepModelSet');
	if (GetDepModelSet)
	{	 
		 tkMakeServerCall("User.DHCNURMenuSub","GetDepModelSet2014",locId,"adddepmodel")		
	}
	var mygrid1 = Ext.getCmp("mygrid1");
	mygrid1.store.loadData(REC);
	mygrid1.getStore().on('load',function(s,records){
          var girdcount=0;
          s.each(function(r){
             // alert(r.get("IfAllShow"))
              if (r.get("IfAllShow")){
                    //grid1.getView().getRow(girdcount).style.backgroundColor='#F7FE2E';
                    grid1.getView().getCell(girdcount,3).style.backgroundColor="#FF0000"	
              }
			
               if (r.get("IfShow")){
                    //grid1.getView().getRow(girdcount).style.backgroundColor='#F7FE2E';
                    grid1.getView().getCell(girdcount,2).style.backgroundColor="#B0C4DE"	
              }
              if (r.get("IfSelect")){
                    //grid1.getView().getRow(girdcount).style.backgroundColor='#F7FE2E';
                    grid1.getView().getCell(girdcount,4).style.backgroundColor="#66CD00"	
              }
              else{                  
                  //  grid1.getView().getRow(girdcount).style.backgroundColor='#A7FE2E';                  
              }            
              girdcount=girdcount+1;
          });
       //scope:this
       });  
}
//普通
function adddepmodel(a1,a2,a3,a4,a5,a6,a7,a8)
{
	REC.push({
		ModelKey:a1,
		ModelDesc:a2,
		IfShow:a3,
		IfAllShow:a6,
		IfSelect:a7,
		ModelSort:a4,
		ModelName:a5,
		GItem:a8
	});
}
function save()
{
	var grid = Ext.getCmp("mygrid");
	var rowObj = grid.getSelectionModel().getSelections();
	var loc="";
	if (rowObj.length>0)
	{
		var loc = rowObj[0].get("LocID");
	}
	if (loc == "") { Ext.Msg.alert('提示', "先选择科室!"); return; }
  	var grid1 = Ext.getCmp("mygrid1");
    var store = grid1.store;
	var rowCount = store.getCount(); //记录数
	var cm = grid1.getColumnModel();
	var colCount = cm.getColumnCount();
	var str="";
	for (var i = 0; i < store.getCount(); i++) {
		var IfShow=store.getAt(i).get("IfShow");
		var IfShow2=store.getAt(i).get("IfShow2");
		if (IfShow==1)
		{
			var ModelKey=store.getAt(i).get("ModelKey");
			var ModelDesc=store.getAt(i).get("ModelDesc");
			var ModelName=store.getAt(i).get("ModelName");
			var ModelSort=store.getAt(i).get("ModelSort");
			if (ModelSort=="") ModelSort=i+1;
			if (ModelName!="")
			{
				str=str+ModelKey+"|"+ModelName+"|"+ModelSort+"^";
			}
			else
			{
				str=str+ModelKey+"|"+ModelDesc+"|"+ModelSort+"^";
			}
		}
	}
	var SaveDepModel=document.getElementById('SaveDepModel');
	//alert(str)
	if (SaveDepModel)
	{
		var ee=cspRunServerMethod(SaveDepModel.value,LOC,str);
		if (ee!="0")
		{
			alert(ee);
			return;	
		}
		else
		{
			findbyloc(LOC);
		}
	}
}
//按科室查询
function findbyloc(loc)
{
   loaddepmodelset(loc);
   var saveselect = Ext.getCmp("mygridbut3"); //按科室保存
  saveselect.setDisabled(false)
  var saveselect = Ext.getCmp("mygridbut4"); //按全院保存
  saveselect.setDisabled(true)
  var saveselect = Ext.getCmp("mygridbut5"); //保存筛选
  saveselect.setDisabled(true)
 
}
//查询所有
function findall()
{
  LOC=""
  loaddepmodelset("");
  var saveselect = Ext.getCmp("mygridbut3"); //按科室保存
  saveselect.setDisabled(true)
  var saveselect = Ext.getCmp("mygridbut4"); //按全院保存
  saveselect.setDisabled(true)
  var saveselect = Ext.getCmp("mygridbut5"); //保存筛选
  saveselect.setDisabled(false)
  grid1.setTitle("库中所有模板")
}
//查询筛选
function findselect()
{
  LOC=""
  loaddepmodelset("9000");
  var saveselect = Ext.getCmp("mygridbut3"); //按科室保存
  saveselect.setDisabled(true)
  var saveselect = Ext.getCmp("mygridbut4"); //按全院保存
  saveselect.setDisabled(false)
  var saveselect = Ext.getCmp("mygridbut5"); //保存筛选
  saveselect.setDisabled(true)
  grid1.setTitle("已筛选记录(未选中任何病区)")
}
//保存(全院)
function save2()
{
	var grid = Ext.getCmp("mygrid");
	var rowObj = grid.getSelectionModel().getSelections();
	var loc="";
	if (rowObj.length>0)
	{
		var loc = rowObj[0].get("LocID");
	}
	//if (loc == "") { Ext.Msg.alert('提示', "先选择科室!"); return; }
  	var grid1 = Ext.getCmp("mygrid1");
    var store = grid1.store;
	var rowCount = store.getCount(); //记录数
	var cm = grid1.getColumnModel();
	var colCount = cm.getColumnCount();
	var str="";
	//alert(store.getCount())
	for (var i = 0; i < store.getCount(); i++) {
		var IfAllShow=store.getAt(i).get("IfAllShow");
		if (IfAllShow==1)
		{
			var ModelKey=store.getAt(i).get("ModelKey");
			var ModelDesc=store.getAt(i).get("ModelDesc");
			var ModelName=store.getAt(i).get("ModelName");
			var ModelSort=store.getAt(i).get("ModelSort");
			if (ModelSort=="") ModelSort=i+1;
			if (ModelName!="")
			{
				str=str+ModelKey+"|"+ModelName+"|"+ModelSort+"^";
			}
			else
			{
				str=str+ModelKey+"|"+ModelDesc+"|"+ModelSort+"^";
			}
		}
	}
	//alert(str)
	var SaveDepModel=document.getElementById('SaveDepModel');
	if (SaveDepModel)
	{ 
	  var loc="All"
		var ee=cspRunServerMethod(SaveDepModel.value,loc,str);
		if (ee!="0")
		{
			alert(ee);
			return;	
		}
		else
		{ 
		  //alert(33)
			loaddepmodelset("9000");
		}
	}
}

//保存(筛选)
function saveselect()
{
	var grid = Ext.getCmp("mygrid");
	var rowObj = grid.getSelectionModel().getSelections();
	var loc="";
	if (rowObj.length>0)
	{
		var loc = rowObj[0].get("LocID");
	}
	//if (loc == "") { Ext.Msg.alert('提示', "先选择科室!"); return; }
  	var grid1 = Ext.getCmp("mygrid1");
    var store = grid1.store;
	var rowCount = store.getCount(); //记录数
	var cm = grid1.getColumnModel();
	var colCount = cm.getColumnCount();
	var str="";
	//alert(store.getCount())
	for (var i = 0; i < store.getCount(); i++) {
		var IfAllShow=store.getAt(i).get("IfSelect");
		if (IfAllShow==1)
		{
			var ModelKey=store.getAt(i).get("ModelKey");
			var ModelDesc=store.getAt(i).get("ModelDesc");
			var ModelName=store.getAt(i).get("ModelName");
			var ModelSort=store.getAt(i).get("ModelSort");
			if (ModelSort=="") ModelSort=i+1;
			if (ModelName!="")
			{
				str=str+ModelKey+"|"+ModelName+"|"+ModelSort+"^";
			}
			else
			{
				str=str+ModelKey+"|"+ModelDesc+"|"+ModelSort+"^";
			}
		}
	}
	//alert(str)
	var SaveDepModel=document.getElementById('SaveDepModel');
	if (SaveDepModel)
	{ 
	  var loc="9000"
		var ee=cspRunServerMethod(SaveDepModel.value,loc,str);
		if (ee!="0")
		{
			alert(ee);
			return;	
		}
		else
		{ 
		  //alert(33)
			loaddepmodelset("");
		}
	}
}