/**
 * @author Administrator
 */

 
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
var but1=Ext.getCmp("mygridbut1");
but1.on('click',additm);
var but=Ext.getCmp("mygridbut2");
but.setText("保存");
but.on('click',save);
 
  grid=Ext.getCmp('mygrid');
  grid.setTitle(gethead());
  var mydate=new Date();
  var tobar=grid.getTopToolbar();
	tobar.addItem(
	    {
			xtype:'datefield',
			format: 'Y-m-d',
			
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
			format: 'Y-m-d',
			id:'mygridenddate',
			value:(diffDate(new Date(),1))
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
}
//document.body.onload=BodyLoadHandler;
 //date.on('change', function(){alert(1);});
var rightClick = new Ext.menu.Menu(  {
                id : 'rightClickCont',
                items : [   {
                    id:'rMenu2',
                    text : '病情措施及处理',
                    handler:Measure
                },  {
                    id:'rMenu3',
                    text : '多选数据',
                    handler:MultiFun
                }]
            });
			
function MultiFun()
{
	var GetMulti=document.getElementById('GetMulti');
	var getcheckform=document.getElementById('getcheckform');	
	var ret= cspRunServerMethod(GetMulti.value, "DHCNUR1");
    var grid=Ext.getCmp('mygrid');
    var tt=ret.split('^');
	var ab="";
	for (i=0;i<tt.length;i++)
	{
		if (tt[i]=="") continue;
		//debugger;
		var dd=grid.getSelectionModel().getSelections()[0].get(tt[i]); 
		if (dd==undefined)dd=""
		if (dd!="") ab=ab+dd+"^"+tt[i]+"!";
		else ab=ab+"^"+tt[i]+"!";
	}
	var tabstr=cspRunServerMethod(getcheckform.value, "DHCNUR1",ab);
	var tabarr=tabstr.split('!');
		var tbitm=new Array();
		for (i = 0; i < tabarr.length; i++) 
		{
			if (tabarr[i] == "") 
				continue;
			var itmm = tabarr[i].split('^');
			tbitm.push({
				xtype: 'panel',
				id: itmm[0],
				title: itmm[1],
				//height: 1000,
				layout: 'absolute',
				//frame:false,
				//palin:false,
				closable: false,
				items: eval(itmm[2])
			
			})
				//alert(itmm[2]);
		}
	var subttab=new Ext.TabPanel({
	    activeTab : 0,//
        autoTabs: true,
        resizeTabs:true, 
        //height:200,
      //  width:300,
        enableTabScroll:true,
 	   items:tbitm
     });
	 
	var window = new Ext.Window({
		title: '多选',
		width: 250,
		height: 480,
		id:'mulForm',
		autoScroll: true,
		layout: 'fit',
		plain: true,
		frame:true,
		items: subttab ,  
		buttons:[{id:'mulselbut',text:'保存',handler:SaveMulCheck}]
	});
	
   window.show();

 
}
var checkret="";

function SaveMulCheck()
{
    var gform=Ext.getCmp("mulForm");
    gform.items.each(eachItem, this);  
	var aa=checkret.split('^');
	var ht = new Hashtable();
	//debugger;
	for (i = 0; i < aa.length; i++) {
		if (aa[i] == "") 
			continue;
		var itm = aa[i].split('|');
		var aitm = itm[0].split('_');
		if (ht.contains(aitm[0])) {
		  var val=ht.items(aitm[0])
		  ht.remove(aitm[0]);
		  var dd=val+";"+itm[1];
		  ht.add(aitm[0],dd);
		}
		else {
		ht.add(aitm[0], itm[1])
	    }
		
	}
	var mygrid=Ext.getCmp('mygrid');
	 for(var i in ht.keys())
	 {
	  var key =ht.keys()[i];
      var restr = ht.items(key)
	   mygrid.getSelectionModel().getSelections()[0].set(key,restr); 
	 	
	 }
	//alert(checkret);

}
function rightClickFn(client, rowIndex, e)  {
          e.preventDefault();
          grid=client;
		  CurrRowIndex=rowIndex;
          rightClick.showAt(e.getXY());
            }
function rowClickFn(grid, rowIndex, e)  {
              //  alert('你单击了' + rowIndex);
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
 	var a=cspRunServerMethod(GetNurPrnSet.value,"DHCNUR1",EpisodeID,'addprnset');
    mygrid.store.loadData(REC);   
	

}
function addprnset(par)
{
	var a=par.split("^");
	//alert(a);
	a[4]=getDate(a[4]);
	if (a[6]!="")a[6]=getDate(a[6]);
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
	var but1=Ext.getCmp(lab+"but1");
	but1.hide();
	var but2=Ext.getCmp(lab+"but2");
	but2.hide();
	
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
	//alert(parr);
	// debugger;
	var a = cspRunServerMethod(GetQueryData.value, "web.DHCNurseRecordComm:GetCareRec", "parr$" + parr, "AddRec");
	mygrid.store.loadData(REC);
}
function AddRec(a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q,r)
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
	Wound:i,
	SetTubeName:j,
	TubeTend:k,
	TractName:l,
    TractStatus:m,
    TractAmount:n, 
    NurQt:o,
 	CaseMeasure:p,
	rw:q,
	par:r
	});
}
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
	{name:'Wound'},
	{name:'SetTubeName'},
	{name:'TubeTend'},
	{name:'TractName'},
    {name:'TractStatus'},
    {name:'TractAmount'},
    {name:'NurQt'},
	{name:'CaseMeasure'},  //TractAmount
	{name:'rw'},
	{name:'par'}
      ]);
	var grid = Ext.getCmp("mygrid");

    var count = grid.store.getCount(); 
    var r = new Plant({CareDate:new Date(),CareTime:new Date().dateFormat('H:i')}); 
    grid.store.commitChanges(); 
    grid.store.insert(count,r); 
   return;
   }
function save()
{
 	var grid = Ext.getCmp("mygrid");
    var store = grid.store;
	var rowCount = store.getCount(); //记录数
	var cm = grid.getColumnModel();
	var colCount = cm.getColumnCount(); 
	
 	    var list = [];
        for (var i = 0; i < store.getCount(); i++) {
		
			list.push(store.getAt(i).data);
		//	debugger;
		}

    var IntersiveSave=document.getElementById('SurgerySave');
	
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
                height: 200,   
					items:[{xtype:"tabpanel",
							activeTab:0,
							 frame:true,
				  items:[
				         {title:"医嘱",
						  width: 550,
						  height: 200,
						  autoScroll: true,
					      layout:'absolute',
						  items:arr
						 },		
				         {title:"检查",
						  width: 550,
						  height: 200,
						  autoScroll: true,
					      layout:'absolute',
						  items:arrcheck
						 },		
				         {title:"检验",
						  width: 550,
						  height: 200,
						  autoScroll: true,
					      layout:'absolute',
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
				height:100, 
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
		width: 550,
		height: 580,
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
	//debugger;
	var grid=Ext.getCmp("mygrid");
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
function eachItem(item,index,length) {   
 	 if (item.xtype=="checkbox") {   
            //修改下拉框的请求地址    
			//debugger;
			if (item.checked==true) checkret=checkret+item.id+"|"+item.boxLabel+"^";   
      
    } 
	  
    if (item.items && item.items.getCount() > 0) {   
       item.items.each(eachItem, this);   
    }   
}   

 function printNurRec()
{
	       
		   var GetPrnSet=document.getElementById('GetPrnSet');
		   var GetHead=document.getElementById('GetHead');
		   var ret=cspRunServerMethod(GetHead.value,EpisodeID);
		   var hh=ret.split("^");

	       //debugger;
			var a=cspRunServerMethod(GetPrnSet.value,"DHCNUR1",EpisodeID); //page, caredattim, prnpos, adm,Typ,user
           //alert(a);
			if (a=="") return;
			var tm=a.split("^");
			var stdate=tm[2];
			var stim=tm[3];
			var edate=tm[4];
			var etim=tm[5];
			
			PrintComm.RHeadCaption=hh[0];
			PrintComm.LHeadCaption=hh[1];
	
			PrintComm.Pages=tm[1];
			PrintComm.stprintpos=tm[0];
			//alert(PrintComm.Pages);
		    PrintComm.SetConnectStr(CacheDB);
			PrintComm.WebUrl=webIP+"/dthealth/web/DWR.DoctorRound.cls";
            PrintComm.ItmName = "DHCNurPrnMould1";  //338155!2010-07-13!0:00!!
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
			var a=cspRunServerMethod(SavePrnSet.value,pages,CareDateTim,stprintpos,EpisodeID,"DHCNUR1",session['LOGON.USERID']); //page, caredattim, prnpos, adm,Typ,user
			//alert(a);

			
}
