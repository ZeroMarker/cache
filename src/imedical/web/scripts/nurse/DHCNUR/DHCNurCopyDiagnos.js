
var grid;
function gethead()
{
		   var GetHead=document.getElementById('GetHead');
		   var ret=cspRunServerMethod(GetHead.value,EpisodeID);
		   var hh=ret.split("^");
		   return hh[0];
	       //debugger;

}

function BodyLoadHandler(){
setsize("mygridpl","gform","mygrid");
//fm.doLayout(); 
var but1=Ext.getCmp("mygridbut1");
but1.on('click',additm);
var but=Ext.getCmp("mygridbut2");
but.setText("保存");
but.on('click',save);
 
  grid=Ext.getCmp('mygrid');
  grid.setTitle(gethead());
  var mydate=new Date();
  var tobar=grid.getTopToolbar();
  tobar.addButton(
	  {
			//className: 'new-topic-button',
			text: "全部保存",
			handler:saveall,
			id:'mysaveall'
	  }
  );
	tobar.addButton(
	  {
			//className: 'new-topic-button',
			text: "删除",
			handler:diagDelete,
			id:'mygridDelete'
	  }
  );
	tobar.addItem(
	    {
			xtype:'datefield',
			//format: 'Y-m-d',
			id:'mygridstdate',
			value:(diffDate(new Date(),0))
		},
	    {
			xtype:'timefield',
			width:100,
			format: 'H:i',
			value:'0:00',
			id:'mygridsttime'
		},
	    {
			xtype:'datefield',
			//format: 'Y-m-d',
			id:'mygridenddate',
			value:diffDate(new Date(),1)
		},
	    {
			xtype:'timefield',
			width:100,
			id:'mygridendtime',
			format: 'H:i',
			value:'0:00'
		}
	);
	tobar.addButton(
	  {
		className: 'new-topic-button',
		text: "查询",
		handler:find,
		id:'mygridSch'
	  }
	);
	//tobar.render(grid.tbar);
	var bbar = grid.getBottomToolbar ();
	bbar.hide();
	var bbar2 = new Ext.PagingToolbar({
	    pageSize:30,
		store:grid.store,
		displayInfo:true,
		displayMsg:'显示第 {0} 条到 {1} 条记录，一共 {2} 条',
		emptyMsg:"没有记录"
	});
	bbar2.render(grid.bbar);
	tobar.doLayout();
	find();
}
var REC=new Array();
function find(){
	REC = new Array();
	var adm = EpisodeID;
	var StDate = Ext.getCmp("mygridstdate");
	var StTime = Ext.getCmp("mygridsttime");
	var Enddate = Ext.getCmp("mygridenddate");
	var EndTime = Ext.getCmp("mygridendtime");
	var GetQueryData = document.getElementById('GetQueryData');
	var mygrid = Ext.getCmp("mygrid");
	var parr = adm + "^" + StDate.value + "^" + StTime.value + "^" + Enddate.value + "^" + EndTime.value + "^";
	// debugger;
	//var a = cspRunServerMethod(GetQueryData.value, "web.DHCNurseRecordComm:GetCopyDiagnos", "parr$" + parr, "AddRec");
	//mygrid.store.loadData(REC);
	var mygrid = Ext.getCmp("mygrid");
    mygrid.store.on("beforeLoad",function(){   
       mygrid.store.baseParams.parr=parr;    //传参数，根据原来的方式修改
    });    
    //mygrid.getStore().addListener('load',handleGridLoadEvent); //护理记录表格需要：日期转换及出入量统计行加颜色
    mygrid.store.load({
    	params:{
    		start:0,
    		limit:30
    	}	
   })
}
function diagDelete()
{
	var grid=Ext.getCmp("mygrid");
	var rowObj = grid.getSelectionModel().getSelections();
	var len = rowObj.length;
	var DiagnosDelete=document.getElementById('DiagnosDelete');
	if (rowObj.length == 0) 
	{
		alert("请先选择一条护理记录!");
		return;
	} else 
	{
		var flag = confirm("你确定要删除此条记录吗!")
		if (flag) 
		{
			var rw = rowObj[0].get("rw");
		    if (!rw) return;
		    var parr=rw+"^"+session['LOGON.USERID']+"^"+session['LOGON.GROUPDESC'];	    
		    //alert(parr)                                	//alert(parr)
		    var ee=cspRunServerMethod(DiagnosDelete.value,parr);
		    if (ee!="0")
		    {
		         alert(ee);
		 	     return;	
		    }
		    else
		    {
		    	find()
		    }	
		}
	}
	//find();
}
function FailChange(val)
{
	if (val>0)
	{
	return '<span style="color:red">' + val + '</span>';
	}
	return val
}
function AddRec(a,b,c,d,f)
{
	//debugger;
	REC.push({
		DiagNos:a,
		RecUser:b,
		RecDate:c, 
		RecTime:d,
		rw:f
	});
}
function saveall()
{
	savecomm("N")
}
function save()
{
 	var grid=Ext.getCmp("mygrid");
	var rowObj = grid.getSelectionModel().getSelections();
	//var record=grid.getSelectionModel().getSelected();
	var len = rowObj.length;
	var DiagnosSave=document.getElementById('DiagnosSave');
	if (len == 0) 
	{ 
		 alert("先选择行!");
		 return; 
  }
	else
	{
		var DiagNos = rowObj[0].get("DiagNos");
		if (!DiagNos) { alert( "诊断不能为空!"); return; }
		var rw = rowObj[0].get("rw");
		if (!rw) rw="";
		var RecDate1 = rowObj[0].get("RecDate");
		var RecDate = formatDate(RecDate1);
		var RecTime = rowObj[0].get("RecTime");		
		var parr=EpisodeID+"^"+rw+"^"+DiagNos+"^"+session['LOGON.USERID']+"^"+session['LOGON.GROUPDESC']+"^"+RecDate+"^"+RecTime;
		//alert(parr);
		var ee=cspRunServerMethod(DiagnosSave.value,parr);
		if (ee!="0")
		{
			alert(ee);
			return;	
		}
	}
    find();
	window.parent.reloadtree2(EmrCode,"表格");
}
function savecomm(singleflag)
{
	var grid1=Ext.getCmp('mygrid');
	var grid=Ext.getCmp('mygrid');
  var store = grid.store;
	var rowCount = store.getCount(); //记录数
	var cm = grid.getColumnModel();
	var colCount = cm.getColumnCount();
	var list = [];
	if (singleflag=="Y")
	{
	    var rowObj = grid.getSelectionModel().getSelections();
		  var len = rowObj.length;	
		  for (var r = 0;r < len; r++) {
		     list.push(rowObj[r].data);
	    }	
	}	
	else
	{
	    for (var i = 0; i < store.getCount(); i++) {
		    list.push(store.getAt(i).data);
	    }
	}
	for (var i = 0; i < list.length; i++) {
	  var obj=list[i];
	  var DiagNos=obj["DiagNos"]
	  if (!DiagNos) 
	  {
	     continue;
	  }
	  var rw = obj["rw"];
		if (!rw) rw="";
		var RecDate1 = obj["RecDate"];
		var RecDate = formatDate(RecDate1);
		var RecTime = obj["RecTime"];		
		var parr=EpisodeID+"^"+rw+"^"+DiagNos+"^"+session['LOGON.USERID']+"^"+session['LOGON.GROUPDESC']+"^"+RecDate+"^"+RecTime;
		//alert(parr);
		var ee=cspRunServerMethod(DiagnosSave.value,parr);
		if (ee!="0")
		{
			alert(ee);
			return;	
		}
	}
	
	find()
	window.parent.reloadtree2(EmrCode,"表格");
}
function gettime()
{
	var a=Ext.util.Format.dateRenderer('h:m');
	return a;
}
function diffDate(val,addday){
	var year=val.getFullYear();
	var mon=val.getMonth();
	var dat=val.getDate()+addday;
	var datt=new Date(year,mon,dat);
	return formatDate(datt);
}
function getDate(val)
{
	var a=val.split('-');
	var dt=new Date(a[0],a[1]-1,a[2]);
	return dt;
}
function formatDate(value){
	try
	{
	   return value ? value.dateFormat('Y-m-d') : '';
	}
	catch(err)
	{
	   return '';
	}
 };
function additm()
{ 
	var grid=Ext.getCmp("mygrid");
	var Plant = Ext.data.Record.create([
		{name:'DiagNos'}, 
		{name:'RecUser'},
		{name:'RecDate'},
		{name:'RecTime'},
		{name:'rw'}
	]);
	var count = grid.store.getCount(); 
	//var r = new Plant({RecDate:formatDate(new Date())}); 
	var r = new Plant({RecDate:new Date(),RecTime:new Date().dateFormat('H:i')}); 
	grid.store.commitChanges(); 
	grid.store.insert(count,r);
	return;
}
function formatDate(value){
  	try
	{
	   return value ? value.dateFormat('Y-m-d') : '';
	}
	catch(err)
	{
	   return '';
	}
 };



 
