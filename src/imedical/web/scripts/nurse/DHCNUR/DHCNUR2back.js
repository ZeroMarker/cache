/**
 * @author Administrator
 */
/*
 grid.store.on('load', function() {
    grid.el.select("table[class=x-grid3-row-table]").each(function(x) {
        x.addClass('x-grid3-cell-text-visible');
    });
});

grid.getStore().on('load',function(s,records){
          var girdcount=0;
          s.each(function(r){
              if(r.get('10')=='数据错误'){
                    grid.getView().getRow(girdcount).style.backgroundColor='#F7FE2E';
              }
              girdcount=girdcount+1;
          });
       //scope:this
       });
*/
var grid;

function BodyLoadHandler(){
var but1=Ext.getCmp("mygridbut1");
but1.text="gg";
but1.on('click',additm);
var but=Ext.getCmp("mygridbut2");
but.setText("保存");
but.on('click',save);
 
  grid=Ext.getCmp('mygrid');
  var mydate=new Date();
  var tobar=grid.getTopToolbar();
	tobar.addItem(
	    {
			xtype:'datefield',
			format: 'Y-m-d',
			id:'mygridstdate',
			value:(diffDate(new Date(),-1))
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
			format: 'Y-m-d',
			id:'mygridenddate',
			value:new Date()
		},
	    {
			xtype:'timefield',
			width:100,
			id:'mygridendtime',
			format: 'H:i',
			value:'18:00'
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
    	tobar.addButton(
		  {
			//className: 'new-topic-button',
			text: "统计",
			handler:findStat,
			id:'mygridStat'
		  }
	  );
   	tobar.addButton(
		  {
			//className: 'new-topic-button',
			text: "打印",
			handler:printNurRec,
			id:'PrintBut'
		  }
	  );
 	tobar.addButton(
		  {
			//className: 'new-topic-button',
			text: "续打印设置",
			handler:PrintSet,
			id:'XPrintSet'
		  }
	  );

	//tobar.render(grid.tbar);
	tobar.doLayout(); 

grid.addListener('rowcontextmenu', rightClickFn);
grid.addListener('rowclick', rowClickFn);
grid.getStore().on('load',function(s,records){
          var girdcount=0;
          s.each(function(r){
              if(r.get('InDruggery')=='总入量='){
                    grid.getView().getRow(girdcount).style.backgroundColor='#F7FE2E';
              }
              if(r.get('InDruggery')=='入量='){
                    grid.getView().getRow(girdcount).style.backgroundColor='#A7FE2E';
              }
              girdcount=girdcount+1;
          });
       //scope:this
       });
}
var REC=new Array();
function PrintSet()
{
	var arr = new Array();
	var a = cspRunServerMethod(pdata1, "", "DHCNURXPRNSET", EpisodeID, "");
	arr = eval(a);
	var window = new Ext.Window({
		width: 750,
		height: 250,
		autoScroll: true,
		layout: 'absolute',
		plain: true,
		frame: true,
		//modal: true,
		//bodyStyle: 'padding:5px;',
		///buttonAlign: 'center',
		items: arr
	});
	 var but2=Ext.getCmp('xpprnsetbut2');
	 but2.hide();
     var butin=Ext.getCmp('xpprnsetbut1');
     butin.text="确定";
 //debugger;
     butin.on('click',xpprnsetSave);
	window.show();
	
	var GetNurPrnSet=document.getElementById('GetNurPrnSet');
	var mygrid=Ext.getCmp("xpprnset");
	//alert(parr);
   // debugger;
    REC=new Array();
 	var a=cspRunServerMethod(GetNurPrnSet.value,"DHCNUR2",EpisodeID,'addprnset');
    mygrid.store.loadData(REC);   
	

}
function addprnset(par)
{
	var a=par.split("^");
	a[4]=getDate(a[4]);
	a[6]=getDate(a[6]);
	REC.push({patname:a[0],
	       bedcode:a[1],
	       pagno:a[2],
	       prnpos:a[3],
	       stdate:a[4],
	       sttime:a[5],
	       edate:a[6],
	       etime:a[7],
	       rectyp:a[8],
	       rw:a[9],
	       EpisodeID:a[10]
		   })
}
function xpprnsetSave()
{
	var mygrid=Ext.getCmp("xpprnset");
	var store=mygrid.store;
	//alert(parr);
	var SavePrnSet=document.getElementById('SPrnSet');
		
	    var list = [];
        for (var i = 0; i < store.getCount(); i++) {
		
			list.push(store.getAt(i).data);
		//	debugger;
		}
		for (var i = 0; i < list.length; i++) {
			var obj = list[i];
			var str = "";
    		for (var p in obj) {
				var aa = formatDate(obj[p]);
				if (p == "") 
					continue;
				if (aa == "") {
				
					str = str + p + "|" + obj[p] + '^';
				}
				else {
					str = str + p + "|" + aa + '^';
				}
				
			}
			//alert(str);
		   var a=cspRunServerMethod(SavePrnSet.value,str); //page, caredattim, prnpos, adm,Typ,user

		}
			

}
function addtitCon(tobar,lab)
{
	tobar.addItem(
	    {
			xtype:'datefield',
			format: 'Y-m-d',
			id:lab+'stdate',
			value:(diffDate(new Date(),-1))
		},
	    {
			xtype:'datefield',
			format: 'Y-m-d',
			id:lab+'enddate',
			value:new Date()
		}
	);
	tobar.addButton(
	  {
		className: 'new-topic-button',
		text: "查询",
		//handler:find,
		id:lab+'Sch'
	  }

	);
}

function findStat()
{  //查询出入量合计
    var adm=EpisodeID;
	var StDate= Ext.getCmp("mygridstdate");
	var StTime= Ext.getCmp("mygridsttime");
	var Enddate= Ext.getCmp("mygridenddate");
	var EndTime= Ext.getCmp("mygridendtime");
	var GeInOutAmount=document.getElementById('GeInOutAmount');
	var mygrid=Ext.getCmp("mygrid");
	
	//var parr=adm+"^"+StDate.value+"^"+StTime.value+"^"+Enddate.value+"^"+EndTime.value+"^";
	//alert(parr);
   debugger;
 	var a=cspRunServerMethod(GeInOutAmount.value,adm,StDate.value,StTime.value,Enddate.value,EndTime.value);
    additm();
	var tt=a.split('^');
	mygrid.getSelectionModel().selectRow(mygrid.store.getCount()-1);   
	mygrid.getSelectionModel().getSelections()[0].set("InDruggery","入量合计="); 
    mygrid.getSelectionModel().getSelections()[0].set("OutQt","出量合计="); 
	mygrid.getSelectionModel().getSelections()[0].set("InDruggeryAmount",tt[0]); 
    mygrid.getSelectionModel().getSelections()[0].set("OutQtAmount",tt[1]); 
//	OutQtAmount:a2,

	
}
function FailChange(val)
{
	if (val>0)
	{
	return '<span style="color:red">' + val + '</span>';
	}
	return val
}

function IntensiveSch()
{
	
}

function AddRec(a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q,r,s,t,u,v,w,x,y,z,z1,a1,a2,a3,a4,a5,a6,a7,a8,a9,a10,a11,a12,a13,a14)
{
	//debugger;
	a=getDate(a);
	REC.push({
    CareDate:a,
	CareTime:b,
	Temperature:c, 
	HeartRate:d,
	Breath:e,
	HPressure:f,
	LPressure:g,
	SPO2:h,
	Mind:i,
	LPupilScale:j, 
	RPupilScale:k,
	LPupilEcho:l, 
	RPupilEcho:m,
	AbsorbPhlegm:n, 
	Atomization:o,
	AbsorbOMth:p,
	AbsorbRate:q,
	Wound:r,
	SetTubeName:s,
	TubeTend:t,
	TractName:u,
    CurePump:v,
    InDruggery:w, 
    InDruggeryAmount:x,
    InQt:y,
	InQtAmount:z,
    Emiction:z1,
    OutQt:a1, 
	OutQtAmount:a2,
	MornNurse:a3, 
	NightNurse:a4, 
	NurseDirect:a5,
	SkinNurse:a6,
	SkinHealth:a7,
	BodyPos:a8,
	DrainageNur:a9,
	MRestrict:a10, 
	InformDoc:a11,
	CaseMeasure:a12,
	rw:a13,
	par:a14
	});
}


function save()
{
    var store = grid.store;
	var rowCount = store.getCount(); //记录数
	var cm = grid.getColumnModel();
	var colCount = cm.getColumnCount(); 
	
 	    var list = [];
        for (var i = 0; i < store.getCount(); i++) {
		
			list.push(store.getAt(i).data);
		//	debugger;
		}

    var IntersiveSave=document.getElementById('IntersiveSave');
	
 	    for (var i = 0; i < list.length; i++) {
			  var obj=list[i];
			  var str="";
			  var CareDate="";
			  var CareTime="";
			  
              for (var p in obj) {
			  	var aa = formatDate(obj[p]);
				if (p=="CareDate") CareDate=aa;
				if (p=='CareTime') CareTime=obj[p];
				if (p=="") continue;
			  	if (aa == "") 
				{
			  	
			  	str = str + p + "|" + obj[p] + '^';
			    }else
				{
				  	str = str + p + "|" + aa + '^';	
				}
			}
			if (str!="")
			{
				if (str.indexOf("CareDate")==-1)
				{
					str=str+"CareDate|"+CareDate+"^CareTime|"+CareTime;
					//debugger;
				}
			//alert(str);
				var a=cspRunServerMethod(IntersiveSave.value,EpisodeID,str,session['LOGON.USERID']);
			}
		}

} 
//Ext.util.Format.dateRenderer
//ext.util.format.date(ext.getcmp("控件id").getvalue(),y-m-d)Y-m-d H:m:s
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
  	var Plant = Ext.data.Record.create([
   {name:'CareDate'},
	{name:'CareTime'},
	{name:'Temperature'}, 
	{name:'HeartRate'},
	{name:'Breath'},
	{name:'HPressure'},
	{name:'LPressure'},
	{name:'SPO2'},
	{name:'Mind'},
	{name:'LPupilScale'}, 
	{name:'RPupilScale'},
	{name:'LPupilEcho'}, 
	{name:'RPupilEcho'},
	{name:'AbsorbPhlegm'}, 
	{name:'Atomization'},
	{name:'AbsorbOMth'},
	{name:'AbsorbRate'},
	{name:'Wound'},
	{name:'SetTubeName'},
	{name:'TubeTend'},
	{name:'TractName'},
    {name:'CurePump'},
    {name:'InDruggery'}, 
    {name:'InDruggeryAmount'},
    {name:'InQt'},
	{name:'InQtAmount'},
    {name:'Emiction'},
    {name:'OutQt'}, 
	{name:'OutQtAmount'},
	{name:'MornNurse'}, 
	{name:'NightNurse'}, 
	{name:'NurseDirect'},
	{name:'SkinNurse'},
	{name:'SkinHealth'},
	{name:'BodyPos'},
	{name:'DrainageNur'},
	{name:'MRestrict'}, 
	{name:'InformDoc'},
	{name:'CaseMeasure'},
	{name:'rw'},
	{name:'par'}
      ]);
    var count = grid.store.getCount(); 
    var r = new Plant({CareDate:new Date(),CareTime:new Date().dateFormat('H:i')}); 
    grid.store.commitChanges(); 
    grid.store.insert(count,r); 
   return;
   }
var rightClick = new Ext.menu.Menu(  {
                id : 'rightClickCont',
                items : [  {
                    id:'rMenu1',
                    text : '医嘱',
                    handler:OrdSch
                },  {
                    id:'rMenu2',
                    text : '病情措施及处理',
                    handler:Measure
                },  {
                    id:'rMenu3',
                    text : '插入出入量小结',
                    handler:InOutNod
                },  {
                    id:'rMenu4',
                    text : '插入24小时出入量',
                    handler:InOutSum
                }]
            });
function rightClickFn(client, rowIndex, e)  {
          e.preventDefault();
          grid=client;
		  CurrRowIndex=rowIndex;
          rightClick.showAt(e.getXY());
            }
function rowClickFn(grid, rowIndex, e)  {
              //  alert('你单击了' + rowIndex);
            }
function Measure1()
{
    selections = grid.getSelectionModel().getSelections();
 	var arr = new Array();
	var a = cspRunServerMethod(pdata1, "", "DHCNURMeasure", EpisodeID, "");
	arr = eval(a);
	var window = new Ext.Window({
		title: '医嘱',
		width: 550,
		height: 450,
		autoScroll: true,
		layout: 'absolute',
		plain: true,
		frame:true,
		//modal: true,
		//bodyStyle: 'padding:5px;',
		///buttonAlign: 'center',
		items: arr
	});
 var mydate=new Date();
 var butord=Ext.getCmp('_Button5');
 butord.on=('click',OrdSch1);



 window.show();
}
function InOutNod()
{ //小结
    
	var SaveOutIn=document.getElementById('SaveOutIn');
	var CareDate=grid.getSelectionModel().getSelections()[0].get("CareDate"); 
    var CareTime=grid.getSelectionModel().getSelections()[0].get("CareTime"); 
    var inamount=grid.getSelectionModel().getSelections()[0].get("InDruggeryAmount"); 
    var OutQtAmount=grid.getSelectionModel().getSelections()[0].get("OutQtAmount"); 
	var str="SumInAmount|"+inamount+"^SumOutAmount|"+OutQtAmount+"^CareDate|"+formatDate(CareDate)+"^CareTime|"+CareTime+"^Typ|Nod";
	var a=cspRunServerMethod(SaveOutIn.value,EpisodeID,str,session['LOGON.USERID']);
		alert(a);
	
}
function InOutSum()
{
	var SaveOutIn=document.getElementById('SaveOutIn');
	var CareDate=grid.getSelectionModel().getSelections()[0].get("CareDate"); 
    var CareTime=grid.getSelectionModel().getSelections()[0].get("CareTime"); 
    var inamount=grid.getSelectionModel().getSelections()[0].get("InDruggeryAmount"); 
    var OutQtAmount=grid.getSelectionModel().getSelections()[0].get("OutQtAmount"); 
	var str="SumInAmount|"+inamount+"^SumOutAmount|"+OutQtAmount+"^CareDate|"+formatDate(CareDate)+"^CareTime|"+CareTime+"^Typ|Sum";
	//alert(str);
	var a=cspRunServerMethod(SaveOutIn.value,EpisodeID,str,session['LOGON.USERID']);
	alert(a);

}
function OrdSch1(){
	// var CurrAdm=selections[rowIndex].get("Adm");
	selections = grid.getSelectionModel().getSelections();
	var arr = new Array();
	var a = cspRunServerMethod(pdata1, "", "DHCPatOrdList", EpisodeID, "");
	arr = eval(a);
	var window = new Ext.Window({
		title: '医嘱',
		width: 550,
		height: 550,
		autoScroll: true,
		layout: 'absolute',
		plain: true,
		frame: true,
		//modal: true,
		//bodyStyle: 'padding:5px;',
		///buttonAlign: 'center',
		items: arr
	});
	 var butin=Ext.getCmp('ordgridbut1');
     butin.text="确定";
 //debugger;
     butin.on('click',SureIn);
	window.show();

}
function OrdSch()
{         
   // var CurrAdm=selections[rowIndex].get("Adm");
    selections = grid.getSelectionModel().getSelections();
 	var arr = new Array();
	var a = cspRunServerMethod(pdata1, "", "DHCPatOrdList", EpisodeID, "");
	arr = eval(a);
	var window = new Ext.Window({
		title: '医嘱',
		width: 550,
		height: 550,
		autoScroll: true,
		layout: 'fit',
		plain: true,
		frame:true,
		//modal: true,
		//bodyStyle: 'padding:5px;',
		///buttonAlign: 'center',
		items: arr
	});
var mydate=new Date();

var	grid1=Ext.getCmp("ordgrid");
tobar=grid1.getTopToolbar();
addtitCon(tobar,grid1.id);

 var butin=Ext.getCmp('ordgridbut2');
 butin.hide();
 var butin=Ext.getCmp('ordgridbut1');
 butin.text="确定";
 //debugger;
 butin.on('click',SureIn);
 var butschord=Ext.getCmp('ordgridSch');
butschord.on('click',SchOrd);

window.show();

}
var condata=new Array();
function add(a,b,c,d,e,f,g,h,i,j,k,l,m)
{ //OrdDate,OrdTime,ARCIMDesc,PriorDes,Meth,PHFreq,Dose,PhQtyOrd,OrdStat,Doctor,Oew,OrdSub
 	condata.push({
		OrdDate: a,
		OrdTime: b,
		ARCIMDesc: c,
		PriorDes: d,
		Meth: e,
		PHFreq: f,
		Dose: g,
		DoseUnit: h,
		PhQtyOrd: i,
		OrdStat: j,
		Doctor: k,
		Oew: l,
		OrdSub: m
	});
}
function SureIn()
 {
	var grid = Ext.getCmp('ordgrid');
	var mygrid=Ext.getCmp('mygrid');
	/*var store = grid.store;
	var rowCount = store.getCount(); //记录数
	var cm = grid.getColumnModel();
	var colCount = cm.getColumnCount(); //列数
	var view = grid.getView();*/
    var selModel = grid.getSelectionModel();   
    if (selModel.hasSelection()) {   
       // Ext.Msg.confirm("警告", "确定要删除吗？", function(button) {   
                var selections = selModel.getSelections();   
				//debugger;
                Ext.each(selections, function(item) {   
                    var des=item.data.ARCIMDesc;
					var ml=item.data.Dose;
					//mygrid.getStore().getAt(0).set("InDruggery",des); 
                	//mygrid.getStore().getAt(0).set("InDruggeryAmount",ml); 
					mygrid.getSelectionModel().getSelections()[0].set("InDruggery",des); 
                	mygrid.getSelectionModel().getSelections()[0].set("InDruggeryAmount",ml); 
                });   
     }   


 
 }
//document.body.onload=BodyLoadHandler;
 //date.on('change', function(){alert(1);});

function Measure()
{
   /* selections = grid.getSelectionModel().getSelections();
 	var arr = new Array();
	var a = cspRunServerMethod(pdata1, "", "DHCNURMeasure", EpisodeID, "");
	arr = eval(a);*/
	var arr = new Array();
	var a = cspRunServerMethod(pdata1, "", "DHCPatOrdList", EpisodeID, "");
	arr = eval(a);
	var arrlab = new Array();
	a = cspRunServerMethod(pdata1, "", "DHCNurLabRec", EpisodeID, "");
	arrlab = eval(a);
	var arrcheck = new Array();
	a = cspRunServerMethod(pdata1, "", "DHCNurCheckRec", EpisodeID, "");
	arrcheck = eval(a);
	var arrResult = new Array();
	a = cspRunServerMethod(pdata1, "", "DHCNurLCResult", EpisodeID, "");
	arrResult = eval(a);
//DHCNurLCResult
	        var north_item = new Ext.Panel({   
                title: '',   
                region: 'north',   
                //contentEl: 'north-div',   
                split: true,   
				frame:true,
                border: true,   
                //collapsible: true,   
                height: 300,   
					items:[{xtype:"tabpanel",
							activeTab:0,
							 frame:true,
				  items:[
				         {title:"医嘱",
						  width: 550,
						  height: 300,
						  autoScroll: true,
					      layout:'fit',
						  items:arr
						 },		
				         {title:"检查",
						  width: 550,
						  height: 300,
						  autoScroll: true,
					      layout:'fit',
						  items:arrcheck
						 },		
				         {title:"检验",
						  width: 550,
						  height: 300,
						  autoScroll: true,
					      layout:'fit',
						  items:arrlab
						 }
						 ]			
				 }] 
				  
            });   
 
            var arr = new Array();
	        var a = cspRunServerMethod(pdata1, "", "DHCNURMeasure", EpisodeID, "");
	        arr = eval(a);
            
            //中间   
            var center_item = new Ext.Panel({   
                region: 'center',   
          		autoScroll: true,
                split: true,   
                layout: 'fit',   
                collapsible: false,  
				height:150, 
                minSize: 120,   
  				frame:true,
                items: arrResult
            });    
            //南边，状态栏   
            var south_item = new Ext.Panel({   
                region: 'south',   
              //  contentEl: 'south-div',   
                split: true,   
               // border: true,   
               // collapsible: true,   
         		autoScroll: true,
                layout: 'absolute',   
                 minSize: 120,  
				height:170,
  				frame:true,
                items: arr 
            });   
    
            //中间的中间，功能菜单   
 
	var window = new Ext.Window({
		title: '医嘱',
		width: 700,
		height: 680,
		id:'CaseForm',
		autoScroll: true,
		layout: 'border',
		plain: true,
		frame:true,
		items: [north_item, center_item,south_item]   
	});
	var grid=Ext.getCmp("LabGrid");
	var tobar=grid.getTopToolbar();
	addtitCon(tobar,grid.id);
	grid=Ext.getCmp("CheckGrid");
	tobar=grid.getTopToolbar();
	addtitCon(tobar,grid.id);
	grid=Ext.getCmp("ordgrid");
	tobar=grid.getTopToolbar();
	addtitCon(tobar,grid.id);
	
	var butschlab=Ext.getCmp('LabGridSch');
	butschlab.on('click',Schlab);
	
	var butschord=Ext.getCmp('ordgridSch');
	butschord.on('click',SchOrd);
	
	var butschcheck=Ext.getCmp('CheckGridSch');
	butschcheck.on('click',SchCheck);
	
	var gridc=Ext.getCmp('CheckGrid');
	gridc.on('click',gridcheckclick);
	
	var gridl=Ext.getCmp('LabGrid');
	gridl.on('click',gridLabclick);
	var mygrid=Ext.getCmp("mygrid");
   
   var butsure=Ext.getCmp('_Button6');
   butsure.on('click',sureMeasure);
	var rowObj = mygrid.getSelectionModel().getSelections();
	var len = rowObj.length;
	if (len < 1) {
		//Ext.Msg.show({title:'注意',msg:'请选择需要修改的数据!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
		return;
	}
	else {
		var content = rowObj[0].get("CaseMeasure");
		var TxtCaseMeasure=Ext.getCmp('TxtCaseMeasure');
		TxtCaseMeasure.setValue(content);
	}
 //var mydate=new Date();
 //var butord=Ext.getCmp('_Button5');
 //butord.on=('click',OrdSch1);



 window.show();
}
function sureMeasure()
{
	var TxtCaseMeasure=Ext.getCmp('TxtCaseMeasure');
	var frm=Ext.getCmp('CaseForm');
	debugger;
	grid.getSelectionModel().getSelections()[0].set("CaseMeasure",TxtCaseMeasure.getRawValue());
	frm.close();

}
function gridcheckclick()
{
	 var grid=Ext.getCmp("CheckGrid");
  
	var rowObj = grid.getSelectionModel().getSelections();
	var len = rowObj.length;
	var GetRadiaNote=document.getElementById('GetRadiaNote');
	if(len < 1)
	{
		//Ext.Msg.show({title:'注意',msg:'请选择需要修改的数据!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
		return;
	}
	else
	{
		var rowid = rowObj[0].get("ORW");
		var a=cspRunServerMethod(GetRadiaNote.value,rowid);
        var LCResult=Ext.getCmp('LCResult');
		a=a.replace("_$c(13,10)_",String.fromCharCode(13)+String.fromCharCode(10));
		var aa=a.split("_$c_");
		var txt="";
		for (i=0;i<aa.length;i++)
		{
			if (aa[i]=="")  continue;
			txt=txt+aa[i];//+String.fromCharCode(13)+String.fromCharCode(10);
		}
		LCResult.setValue(txt);
		//EpisodeID=rowObj[0].get("EpisodeId");
		/*for (i = 0; i < top.frames.length; i++) {
			alert(top.frames[i].name);
		}
		var frm = top.frames[0].document.forms["fEPRMENU"];
	    frm.EpisodeID.value=EpisodeID;
        ModConsult();*/
	}
}
function gridLabclick()
{
	 var grid=Ext.getCmp("LabGrid");
  
	var rowObj = grid.getSelectionModel().getSelections();
	var len = rowObj.length;
	var GetLabItemdata=document.getElementById('GetLabItemdata');
	if(len < 1)
	{
		//Ext.Msg.show({title:'注意',msg:'请选择需要修改的数据!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
		return;
	}
	else
	{
		var labno = rowObj[0].get("LabEpisodeNo");
		var tesc=rowObj[0].get("testcode");
		var ARCIMDes=rowObj[0].get("ARCIMDes");
		var a=cspRunServerMethod(GetLabItemdata.value,labno,tesc);
        var LCResult=Ext.getCmp('LCResult');
		//a=a.replace("&",String.fromCharCode(13)+String.fromCharCode(10));
		var aa=a.split("$");
		var aresult=aa[1].split('&');
		var txt="";
		for (i=0;i<aresult.length;i++)
		{
			if (aresult[i]=="")  continue;
			var labar=aresult[i].split("^");
			txt=txt+labar+String.fromCharCode(13)+String.fromCharCode(10);
		}
		LCResult.setValue("        "+ARCIMDes+String.fromCharCode(13)+String.fromCharCode(10)+txt);
		//EpisodeID=rowObj[0].get("EpisodeId");
		/*for (i = 0; i < top.frames.length; i++) {
			alert(top.frames[i].name);
		}
		var frm = top.frames[0].document.forms["fEPRMENU"];
	    frm.EpisodeID.value=EpisodeID;
        ModConsult();*/
	}
}
function SchOrd()
{
	condata=new Array();
	var adm=EpisodeID;
	var StDate= Ext.getCmp("ordgridstdate");
	var Enddate= Ext.getCmp("ordgridenddate");
	var GetQueryData=document.getElementById('GetQueryData');
	var ordgrid=Ext.getCmp("ordgrid");
    var parr=adm+"^"+StDate.value+"^"+Enddate.value;
 	var a=cspRunServerMethod(GetQueryData.value,"web.DHCNUREMR:GetPatOrd","parr$"+parr,"add");
   // grid.width=document.body.offsetWidth;
    
    ordgrid.store.loadData(condata);   
}
function Schlab()
{
	condata=new Array();
	var adm=EpisodeID;
	var StDate= Ext.getCmp("LabGridstdate");
	var Enddate= Ext.getCmp("LabGridenddate");
	var GetQueryData=document.getElementById('GetQueryData');
	var ordgrid=Ext.getCmp("LabGrid");
    //var parr=adm+"^"+StDate.value+"^"+Enddate.value;
	//alert(adm);
 	var a=cspRunServerMethod(GetQueryData.value,"web.DHCNurJYRESULT:GetLabNo","Adm$"+adm,"AddLab");
   // grid.width=document.body.offsetWidth;
    
    ordgrid.store.loadData(condata);   
}
function AddLab(a,b,c,d,e,f,g,h)
{
	//OrdDate,OrdTime,ARCIMDesc,ORW,DateEx,TimeEx ,CPTEx,ArcimDR
		condata.push({
			ARCIMDes:a,
			LabEpisodeNo:b,
			StDateTime:c,
			RowId:d,
			testcode:e,
			LabCpt:f,
			LabDate:g,
			LabTime:h
		});
}
function AddCheck(a,b,c,d,e,f,g,h)
{
	//OrdDate,OrdTime,ARCIMDesc,ORW,DateEx,TimeEx ,CPTEx,ArcimDR
		condata.push({
			OrdDate:a,
			OrdTime:b,
			ARCIMDesc:c,
			ORW:d,
			DateEx:e,
			TimeEx:f ,
			CPTEx:g,
			ArcimDR:h
		});
}
function SchCheck()
{
	condata=new Array();
	var adm=EpisodeID;
	var StDate= Ext.getCmp("CheckGridstdate");
	var Enddate= Ext.getCmp("CheckGridenddate");
	var GetQueryData=document.getElementById('GetQueryData');
	var ordgrid=Ext.getCmp("CheckGrid");
    var parr=adm+"^"+StDate.value+"^"+Enddate.value;
 	var a=cspRunServerMethod(GetQueryData.value,"web.DHCNurJYRESULT:GetOrdRadia","parr$"+parr,"AddCheck");
   // grid.width=document.body.offsetWidth;
    
    ordgrid.store.loadData(condata);   
}

function printNurRec()
{
	       
		   var GetPrnSet=document.getElementById('GetPrnSet');
	       //debugger;
			var a=cspRunServerMethod(GetPrnSet.value,"DHCNUR2",EpisodeID); //page, caredattim, prnpos, adm,Typ,user
           alert(a);
			if (a=="") return;
			var tm=a.split("^");
			var stdate=tm[2];
			var stim=tm[3];
			var edate=tm[4];
			var etim=tm[5];
			
			PrintComm.Pages=tm[1];
			PrintComm.stprintpos=tm[0];
			alert(PrintComm.Pages);
		    PrintComm.SetConnectStr("CN_IPTCP:127.0.0.1[1972]:websrc");
            PrintComm.ItmName = "DHCNURPRN2Mould";  //338155!2010-07-13!0:00!!
			//debugger;
			var parr=EpisodeID+"!"+stdate+"!"+stim+"!"+edate+"!"+etim;
            PrintComm.ID = "";
            PrintComm.MultID = ""; 
			//PrintComm.MthArr="web.DHCConsult:getConsultInfo&id:"+myid;
			PrintComm.SetParrm(parr);  // ="EpisodeId" ;  //"p1:0^p2:"
            PrintComm.PrintOut();
			var SavePrnSet=document.getElementById('SavePrnSet');
	       //debugger;
		    var CareDateTim=PrintComm.CareDateTim;
			if (CareDateTim=="") return ;
			var pages=PrintComm.Pages;
			//debugger;
			var stprintpos=PrintComm.stPrintPos;
			var a=cspRunServerMethod(SavePrnSet.value,pages,CareDateTim,stprintpos,EpisodeID,"DHCNUR2",session['LOGON.USERID']); //page, caredattim, prnpos, adm,Typ,user
			//alert(a);

			
}

var Data; 
//存储获取的数据 
var DataStore; 
//数据存储器 
var Pager; 
//分页器 
var PerCount=4; 
//每页的数据量 
var Grid; 
//GridPanel容器 
function find()
{
	REC=new Array();
	var adm=EpisodeID;
	var StDate= Ext.getCmp("mygridstdate");
	var StTime= Ext.getCmp("mygridsttime");
	var Enddate= Ext.getCmp("mygridenddate");
	var EndTime= Ext.getCmp("mygridendtime");
	var GetQueryData=document.getElementById('GetQueryData');
	var mygrid=Ext.getCmp("mygrid");
	var parr=adm+"^"+StDate.value+"^"+StTime.value+"^"+Enddate.value+"^"+EndTime.value+"^";
	//alert(parr);
   // debugger;
 	var a=cspRunServerMethod(GetQueryData.value,"web.DHCNurseRecordComm:GetIntensiveCareRec","parr$"+parr,"AddRec");
   // grid.width=document.body.offsetWidth;
     Data=REC;
    	DataStore = new Ext.data.Store({
		//数据存储器 
		proxy: new Ext.data.MemoryProxy(Data),
		reader: new Ext.data.JsonReader({
			root: 'd'
		}, [ {name:'CareDate'},
	{name:'CareTime'},
	{name:'Temperature'}, 
	{name:'HeartRate'},
	{name:'Breath'},
	{name:'HPressure'},
	{name:'LPressure'},
	{name:'SPO2'},
	{name:'Mind'},
	{name:'LPupilScale'}, 
	{name:'RPupilScale'},
	{name:'LPupilEcho'}, 
	{name:'RPupilEcho'},
	{name:'AbsorbPhlegm'}, 
	{name:'Atomization'},
	{name:'AbsorbOMth'},
	{name:'AbsorbRate'},
	{name:'Wound'},
	{name:'SetTubeName'},
	{name:'TubeTend'},
	{name:'TractName'},
    {name:'CurePump'},
    {name:'InDruggery'}, 
    {name:'InDruggeryAmount'},
    {name:'InQt'},
	{name:'InQtAmount'},
    {name:'Emiction'},
    {name:'OutQt'}, 
	{name:'OutQtAmount'},
	{name:'MornNurse'}, 
	{name:'NightNurse'}, 
	{name:'NurseDirect'},
	{name:'SkinNurse'},
	{name:'SkinHealth'},
	{name:'BodyPos'},
	{name:'DrainageNur'},
	{name:'MRestrict'}, 
	{name:'InformDoc'},
	{name:'CaseMeasure'},
	{name:'rw'},
	{name:'par'}])
	});
	debugger;
    mygrid.store=DataStore;   
	DataStore.load();
	//mygrid.getBottomToolbar().store.loadData(REC);   
	//debugger;
	var Pager = new Ext.PagingToolbar({
 	id: 'Grid_Pager',
 	pageSize: PerCount,
 	store: DataStore,
 	displayInfo: true,
 	paramNames: {
 		start: 'start',
 		limit: 'limit',
 		cid: 'cid'
 	},
 	displayInfo: true,
 	displayMsg: '显示第 {0} 条到 {1} 条记录，一共 {2} 条',
 	emptyMsg: '没有数据',
 	updateInfo: function()//重写UpdateInfo 
		{
			if (this.displayEl) {
				var count = this.store.getCount();
				var msg = count == 0 ? this.emptyMsg : String.format(this.displayMsg, this.cursor + 1, Math.min(this.cursor + this.pageSize - 1, Data.d.length - 1) + 1, Data.d.length);
				this.displayEl.update(msg);
			}
		},
		onLoad: function(store, r, o)//重写OnLoad 
		{
			if (!this.rendered) {
				this.dsLoaded = [store, r, o];
				return;
			}
			var d = this.getPageData(), ap = d.activePage, ps = d.pages;
			this.afterTextEl.el.innerHTML = String.format(this.afterPageText, d.pages);
			this.field.dom.value = ap;
			this.first.setDisabled(ap == 1);
			this.prev.setDisabled(ap == 1);
			this.next.setDisabled(ap == ps);
			this.last.setDisabled(ap == ps);
			this.loading.enable();
			this.updateInfo();
		},
		doLoad: function(start)//重写doLoad 
		{
			var TempData = {
				'd': []
			};
			var i = 0;
			var len = this.pageSize;
			for (i = 0; i < len; i++) {
				if (Data.d[start + i] != null) {
					TempData.d.push(Data.d[start + i]);
				}
			}
			this.store.loadData(TempData, false);
		},
		getPageData: function()//重写getPageData 
		{
			var total = Data.d.length;
			return {
				total: total,
				activePage: Math.ceil((this.cursor + this.pageSize) / this.pageSize),
				pages: total < this.pageSize ? 1 : Math.ceil(total / this.pageSize)
			};
		}
		, 
        onClick:function (which)//重写onClick 
        { 
            switch(which) 
            { 
                case "first": 
                this.doLoad(0); 
                break; 
                case "prev": 
                var t=this.cursor; 
                this.cursor=Math.max(0,t-this.pageSize); 
                this.doLoad(Math.max(0,t-this.pageSize)); 
                break; 
                case "next": 
                var t=this.cursor; 
                this.cursor=t+this.pageSize; 
                this.doLoad(t+this.pageSize); 
                break; 
                case "last": 
                var total=Data.d.length; 
                var extra=total%this.pageSize; 
                var lastStart=extra?(total-extra):total-this.pageSize; 
                this.cursor=extra?(total-extra):total-this.pageSize; 
                this.doLoad(lastStart); 
                break; 
                case "refresh": 
                var t=this.cursor; 
                this.cursor=t; 
                this.doLoad(t); 
                break; 
            } 
        } 
	}
    ); 
	mygrid.bottomToolbar=Pager;
}
function GetPagerData(InData)//从静态数据中获取每页的数据 
{ 
    var TempData=//为什么要用'd'作为json数据的根，因为从WebService获取Json数据经查看就是以'd'为根的 
    { 
        'd':[] 
    }; 
    if(InData.length>PerCount) 
    { 
        for(var i=0;i<=PerCount-1;i++) 
        { 
            TempData.d.push(InData.d[i]); 
        } 
    } 
    else 
    { 
        for(var i=0;i<=InData.d.length-1;i++) 
        { 
            TempData.d.push(InData.d[i]); 
        } 
    } 
    return TempData; 
} 

function SerGrid(){
	Data =//获取数据之前的Loading数据 
	{
		'd': [{
			'字段1': '数据载入中',
			'字段2': '数据载入中',
			'字段3': '数据载入中',
			'字段4': '数据载入中',
			'字段5': '数据载入中'
		}]
	};

	
}

 
