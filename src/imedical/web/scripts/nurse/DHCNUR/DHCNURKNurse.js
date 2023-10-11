/*
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
var modeldata=[['ward','病房'],['jz','急诊'],['mz','门诊'],['yj','医技']];
var store = new Ext.data.SimpleStore({
    fields: ['id', 'desc'],
    data : modeldata
});
var arrgrid = new Array();
var storenurse = new Ext.data.JsonStore({
			data :[],
			fields : ['desc', 'id']
		});
var storenurse1 = new Ext.data.SimpleStore({
			
			fields : ['id', 'desc'],
			data :modeldata
		});
var KNurse = new Ext.data.JsonStore({
			data :[],
			fields : ['id', 'desc']
			
		});
	var KNurseName = new Ext.data.JsonStore({
			data :[],
			fields : ['id', 'desc']
			
		});
var patward = new Ext.form.ComboBox({
			id : 'patward',
			//hiddenName : 'region1',
			store : storenurse,
			width : 250,
      //fieldLabel : '区',
			valueField : 'id',
			displayField : 'desc',
			value:"",
			allowBlank : true,
			mode : 'local',
			listeners: {
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
							var text = getPinyin(record.get('desc'));
							return regExp.test(text); 
						});
						combo.expand();
						combo.select(0, true); 
						return false;
					}
				}
			}
		});
	var LocType = new Ext.form.ComboBox({
			id : 'LocType',
			//hiddenName : 'region1',
			store : storenurse1,
			width : 50,
			fieldLabel : '科室性质',
			valueField : 'id',
			value:"",
			displayField : 'desc',
			allowBlank : true,
			mode : 'local'
		});
var KNurse = new Ext.form.ComboBox({
			id : 'KNurse',
			//hiddenName : 'region1',
			store : KNurse,
			width : 70,
			fieldLabel : '科护士长',
			valueField : 'id',
			value:"",
			displayField : 'desc',
			allowBlank : true,
			mode : 'local'
		});
KNurse.on('select', function() {
		
		});
var KNurseName = new Ext.form.ComboBox({
			id : 'KNurseName',
			//hiddenName : 'region1',
			store : KNurseName,
			width : 70,
			fieldLabel : '科护士长姓名',
			valueField : 'id',
			value:"",
			displayField : 'desc',
			allowBlank : true,
			mode : 'local'
		});
KNurseName.on('select', function() 
    {
	    var KNurseName = Ext.getCmp("KNurseName");
			var id=KNurseName.getValue()
			var Getval=document.getElementById('Getval');
	    if (Getval) 
	    {
		  var ret=cspRunServerMethod(Getval.value,id);
		  //alert(ret);
	  	var tt=ret.split('^');
	 		var mygriddate = Ext.getCmp("KNurse");
	    mygriddate.setValue(tt[0]);
	    var mygridtime = Ext.getCmp("mygridlabledesc3");
	    mygridtime.setValue(tt[1]);	
	     }
		});
function BodyLoadHandler(){
	setsize("mygridpl", "gform", "mygrid");
	//fm.doLayout(); 
 //alert(233)
	var but1 = Ext.getCmp("mygridbut1");
	but1.hide();
	but1.on('click', newEvent);
	
	var but = Ext.getCmp("mygridbut2");
	but.hide();

	var grid = Ext.getCmp('mygrid');
	var len = grid.getColumnModel().getColumnCount();
	for (var i = 0; i < len; i++) {
		if (grid.getColumnModel().getDataIndex(i) == 'rw') {
			grid.getColumnModel().setHidden(i, true);
		}
		if (grid.getColumnModel().getDataIndex(i) == 'par') {
			grid.getColumnModel().setHidden(i, true);
		}
		if (grid.getColumnModel().getDataIndex(i) == 'loc') {
			grid.getColumnModel().setHidden(i, true);
		}
		if (grid.getColumnModel().getDataIndex(i) == 'type') {
			grid.getColumnModel().setHidden(i, true);
		}
	}
	var mydate = new Date();
	var tobar = grid.getTopToolbar();
	grid.on('rowdblclick',modccevent);
	tobar.addItem('总护士长姓名',
		KNurseName)
  tobar.addItem('总护士长工号',
		KNurse);
	 
	 tobar.addItem( '总护士长区域', {
				xtype : 'textfield',
			  id : 'mygridlabledesc3',
				width:100,
				fieldLabel : '总护士长区域'
			  });
	tobar.addItem('病区科室',
		patward,'-' ,'科室性质',LocType,'-');
	
	tobar.addButton({
		//className: 'new-topic-button',
		text: "增加",
		icon:'../images/uiimages/edit_add.png',
		handler: Save,
		id: 'mygridSch1'
	});
	tobar.addButton({
		//className: 'new-topic-button',
		text: "查询",
		handler: find,
		icon:'../images/uiimages/search.png',
		id: 'mygridSch'
	});
	tobar.addButton({
		//className: 'new-topic-button',
		text: "清屏",
		icon:'../images/uiimages/clearscreen.png',
		handler: clearall,
		id: 'mygridSchclear'
	});
	tobar.addItem("-");
	tobar.addButton({
		//className: 'new-topic-button',
		text: "删除",
		icon:'../images/uiimages/edit_remove.png',
		handler:delete1,
		id: 'delete'
	});
	
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
   grid.addListener('rowclick', function()
   { var grid = Ext.getCmp('mygrid');
   	var objRow=grid.getSelectionModel().getSelections();
 // alert(objRow.length)
	if (objRow.length == 0) {
		return;
	}
	else {
		
	 var grid = Ext.getCmp("mygrid");
	var rowObj = grid.getSelectionModel().getSelections();
	var mygriddate = Ext.getCmp("KNurse");
	mygriddate.setValue(rowObj[0].get("UserId"));
	var mygridtime = Ext.getCmp("KNurseName");
	mygridtime.setValue(rowObj[0].get("rw"));	
	var mygridtime = Ext.getCmp("mygridlabledesc3");
	mygridtime.setValue(rowObj[0].get("Location"));	
	var typ = Ext.getCmp("patward");
	typ.setValue(rowObj[0].get("loc"));
		var typ = Ext.getCmp("LocType");
	typ.setValue(rowObj[0].get("type"));
	}}
   );
	inidata("patward","Desc","web.DHCNurblsjflwh:GetWard","Loc$W");
	//inidata("KNurse","Desc","Nur.DHCNURLocData:GetKNurse","Loc$W");
	inidata("KNurseName","Desc","Nur.DHCNURLocData:GetKNurse","Loc$W");
    inidata("CCERR","Desc","web.DHCNurblsjflwh:CRItem","");
    //patward.setValue(session['LOGON.CTLOCID']);
     //alert(session['LOGON.GROUPID'])
    if (session['LOGON.GROUPID']==20)
    {
    	//patward.disable()
    }
    var mygriddate = Ext.getCmp("KNurse");
    mygriddate.disable()
    var mygridtime = Ext.getCmp("mygridlabledesc3");
    mygridtime.disable()
    var typ = Ext.getCmp("LocType");
	//typ.setValue("ward");
    //layoutset();
    //var CCEV=Ext.getCmp("CCERR");
    //alert(CCEV.value);
  find();
  grid.setTitle("大科护士长负责科室维护")
  //grid.getBottomToolbar().hide();
//alert();
//debugger;
}
function rowClickFn(grid, rowIndex, e)  {
               // alert('你单击了' + rowIndex);
                //var grid=Ext.getCmp("mygrid");
	
		//var rw = objRow[0].get("rw");
		//var chl = objRow[0].get("par");
		//var par = objRow[0].get("par");
		//var id=rw+"||"+chl;
		//alert(par);
		//var a = cspRunServerMethod(SetStatus.value,id);
		//find()
	}
	
            
function delete1()
{
	var grid=Ext.getCmp("mygrid");
	var objRow=grid.getSelectionModel().getSelections();
	if (objRow.length == 0) {
		return;
	}
	else {
	   var SetStatus=document.getElementById('delete');
		var rw = objRow[0].get("rw");
		var chl = objRow[0].get("par");
		var id=rw+"^"+chl;
		//alert(par);
		var a = cspRunServerMethod(SetStatus.value,id);

	}
			find()
	}

function Save()
{
		var patward = Ext.getCmp("patward");
		var LocType = Ext.getCmp("LocType");
		var Id = Ext.getCmp("KNurse");
			var Name = Ext.getCmp("KNurseName");
				var Type = Ext.getCmp("mygridlabledesc3");
		//alert(patward.getValue())
		//alert(Id.getValue())
	var RecSave = document.getElementById('Save');
	var mygrid = Ext.getCmp("mygrid");
	if (patward.getValue()=="")
	{
		alert("科室不能为空")
		return;
		}
	var parr = Id.getValue() + "^" + Name.getValue() + "^" + Type.getValue() + "^" + patward.getValue() + "^" + LocType.getValue() 
	//alert(parr);
	//debugger;
	var a = cspRunServerMethod(RecSave.value, parr,"");
	if (a!=0)
	{alert(a)}
	find()
	///mygrid.store.loadData(REC);
	
}
function xiugai()
{ var grid=Ext.getCmp("mygrid");
	var objRow=grid.getSelectionModel().getSelections();
	if (objRow.length == 0) {
		return;
	}
	else {
	   var SetStatus=document.getElementById('delete');
		var rw = objRow[0].get("rw");
		
		var par = objRow[0].get("par");
		var id=rw+"||"+par;
	
		var patward = Ext.getCmp("patward");
		var LocType = Ext.getCmp("LocType");
		var Id = Ext.getCmp("KNurse");
			var Name = Ext.getCmp("KNurseName");
				var Type = Ext.getCmp("mygridlabledesc3");
		//alert(patward.getValue())
		//alert(Id.getValue())
	var RecSave = document.getElementById('Save');
	var mygrid = Ext.getCmp("mygrid");
	var parr = Id.getValue() + "^" + Name.getValue() + "^" + Type.getValue() + "^" + patward.getValue() + "^" + LocType.getValue() 
	alert(parr);
	//debugger;
	var a = cspRunServerMethod(RecSave.value, parr,id);
	find()
}
	///mygrid.store.loadData(REC);
	
}
function layoutset()
{
	var GetLayoutItem=document.getElementById('GetLayoutItem');
	//alert(GetLayoutItem);
	var ret=cspRunServerMethod(GetLayoutItem.value,session['LOGON.GROUPID'] ,EmrCode);
	var arr=ret.split("^");
	for (var i=0;i<arr.length;i++)
	{
		var itm=arr[i];
		//alert(itm);
		if (itm=="") continue;
		var itmarr=itm.split("|");
		var com=Ext.getCmp(itmarr[0]);
		com.disable();
	}
}
function SetStatusFu(stat)
{
	var grid=Ext.getCmp("mygrid");
	var objRow=grid.getSelectionModel().getSelections();
	if (objRow.length == 0) {
		return;
	}
	else {
	    var SetStatus=document.getElementById('SetStatus');
		//var rw = objRow[0].get("rw");
		//var chl = objRow[0].get("chl");
		var par = objRow[0].get("par");
		//var id=rw+"||"+chl;
		//alert(par);
		var a = cspRunServerMethod(SetStatus.value,par,stat,session['LOGON.USERID'] );
		find()
	}

}
function SubmitFu()
{ //提交
   
   SetStatusFu('S');
}
function AuditFu()
{ //审核
  SetStatusFu('A');
}
function RefundFu()
{ //退回
	SetStatusFu('V');
}
function modccevent()
{
	
}
function inidata(cmbname,desc,quer,parr)
{
	var cmb=Ext.getCmp(cmbname);
	var querymth=document.getElementById('GetQueryCombox');
	if (cmb!=null)	
	{
 	 arrgrid=new Array();
	 var a = cspRunServerMethod(querymth.value, quer, parr , "AddRec",desc);
	 //alert(arrgrid)
	// debugger;
     cmb.store.loadData(arrgrid);
	}

}

function newEvent()
{
	// var CurrAdm=selections[rowIndex].get("Adm");
	//if (DtId=="")return;
	//var getcurExamId=document.getElementById('getcurExamId');
	//var ExamId=cspRunServerMethod(getcurExamId.value,SpId);
    // alert(ExamId);
	var lnk= "dhcnuremrcomm.csp?"+"&EmrCode=DHCNURykdYWSH&EpisodeID="+EpisodeID  ;//"&DtId="+DtId+"&ExamId="+ExamId
	window.open(lnk,"htm",'toolbar=no,location=no,directories=no,resizable=yes,width=860,height=700');



}

var REC=new Array();

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
function clearall()
{
	    var patward = Ext.getCmp("patward");
	    patward.setValue("")
		var LocType = Ext.getCmp("LocType");
		LocType.setValue("");
		var obj = Ext.getCmp("KNurse");
        obj.setValue("")
		var obj = Ext.getCmp("KNurseName");
		obj.setValue("")
		var obj = Ext.getCmp("mygridlabledesc3");
		obj.setValue("")
		find()
}
function find()
{
		var patward = Ext.getCmp("patward");
		var LocType = Ext.getCmp("LocType");
		var Id = Ext.getCmp("KNurse");
			var Name = Ext.getCmp("KNurseName");
				var Type = Ext.getCmp("mygridlabledesc3");
	var mygrid = Ext.getCmp("mygrid");
	var parr = Id.getValue() + "^" + Name.getValue() + "^" + Type.getValue() + "^" + patward.getValue() + "^" + LocType.getValue() 
  //alert(parr);
	var GetQueryData=document.getElementById('GetQueryData');
	arrgrid=new Array();
	//var grid = Ext.getCmp("mygrid");
	//var a = cspRunServerMethod(GetQueryData.value, "Nur.DHCNURLocDataSub:CRItem", "parr$"+parr, "AddRec");	
  //grid.store.loadData(arrgrid);   
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


function AddRec(str)
{
	//var a=new Object(eval(str));
	//alert(str);
	str=str.replace(/\t+/g,"").replace(/\n+/g,"").replace(/\r+/g,"").replace(/\s+/g,"");  //去除字符串中空格
	var obj = eval('(' + str + ')');
	
	//obj.CareDate=getDate(obj.CareDate);
	//obj.PregHPregDate=getDate(obj.PregHPregDate);
	arrgrid.push(obj);
	//debugger;
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

function MultiFun()
{
	var GetMulti=document.getElementById('GetMulti');
	var getcheckform=document.getElementById('getcheckform');	
	var ret= cspRunServerMethod(GetMulti.value, "DHCNUR6");
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
	var tabstr=cspRunServerMethod(getcheckform.value, "DHCNUR6",ab);
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
		width: 450,
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
  checkret="";
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
      var restr = ht.items(key);
	   mygrid.getSelectionModel().getSelections()[0].set(key,restr); 
	 }
	alert(checkret);

}
function add(a1, a2){
	attenitm.push({
		xtype:'panel',
		id: a1,
		title: a2,
		region:'center',
		height:1000,
		layout:'fit',
		closable:true,
		items:[]
	})
}
function multiSel(ret)
{
		var grid1=Ext.getCmp('multigrid');
		var code=grid1.getSelectionModel().getSelections()[0].get("itm3"); 
        var itname=grid1.getSelectionModel().getSelections()[0].get("itm4"); 
	    var getcheckform=document.getElementById('getcheckform');
		alert(itname+"!!"+code)
		var ret=cspRunServerMethod(getcheckform.value, "DHCNUR6",itname,code,"");	
		var CareDate=grid.getSelectionModel().getSelections()[0].get("CareDate"); 
		var aa=new Array();
		aa=eval(aa);
    /*
		debugger;
		for(var i=0;i<items.length;i++){ 

            panl.remove(items[i]); 

          } 
    
       panl.doLayout();
		panl.add(new Ext.form.Checkbox({    
                    id:"addboxModule",                
                    name:"userModule",
                    boxLabel : 'moduleName' 
                   }));*/

		panl.doLayout();
		debugger;
		
 
}
function addMulitm(ret)
{
	var grid1=Ext.getCmp('multigrid');
  	var Plant = Ext.data.Record.create([
	{name:'itm1'},
	{name:'itm2'},
	{name:'itm3'},
	{name:'itm4'}
      ]);
	var itm=ret.split('^');
	for (i = 0; i < itm.length; i++) {
		if (itm[i]=="") continue;
		var aa=itm[i].split('!');
		var count = grid1.store.getCount();
		var r = new Plant({
			itm1: aa[0],
			itm2: "",
			itm3:aa[1],
			itm4:aa[2]
		});
		grid1.store.commitChanges();
		grid1.store.insert(count, r);
	}
   return;
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
	var objRow=grid.getSelectionModel().getSelections();
	if (objRow.length == 0) { Ext.Msg.alert('提示', "请先点'统计'按钮!"); return; }
	else
	{
	  var countstr=""; //合计项
	  var countcls=ICountCls+"&"+OCountCls;
	  var tt=countcls.split('&');
	  for (i=0;i<tt.length;i++)
	  {
	  	if (tt[i]=="") continue;
		countstr=countstr+tt[i]+"|"+objRow[0].get(tt[i])+"^";
	  }
	  var CareDate=objRow[0].get("CareDate");
	  var CareTime=objRow[0].get("CareTime");
	  var inamount=objRow[0].get(DisplaySumInAmount);
	  var OutQtAmount=objRow[0].get(DisplaySumOutAmount);
	  var InPart=objRow[0].get(PartInAmount);
	  var OutPart=objRow[0].get(PartOutAmount);
	  //var StatTime=objRow[0].get("Item1");
	  //var StatHours=objRow[0].get("Item2");
	  var CaseMeasure=objRow[0].get("CaseMeasure");
	  var CaseMeasureArr=CaseMeasure.split(" ");
	  if (CaseMeasureArr.length>1)
	  {
	  	var StatTime=CaseMeasureArr[0];
	  	var StatHours=CaseMeasureArr[1];
	  }
	  else
	  {
	  	var StatTime="";
	  	var StatHours="";
	  }
		var str=countstr+"^SumInAmount|"+inamount+"^SumOutAmount|"+OutQtAmount+"^CareDate|"+formatDate(CareDate)+"^CareTime|"+CareTime+"^Typ|Nod^"+"InPart|"+InPart+"^OutPart|"+OutPart+"^StatTime|"+StatTime+"^StatHours|"+StatHours;
		var diaggrid = Ext.getCmp('diaggrid');
		if (diaggrid) {
  		var selModel=diaggrid.getSelectionModel();
  		if (selModel.hasSelection()) {   
  			var objDiagRow = selModel.getSelections();		  			
				DiagnosDr=objDiagRow[0].get("rw");
			}
			else {
				DiagnosDr="";	
			}
		}
		else {
			DiagnosDr="";
		}
		str=str+"^DiagnosDr|"+DiagnosDr;
		//alert(str);
		var a=cspRunServerMethod(SaveOutIn.value,EpisodeID,str,session['LOGON.USERID'],"DHCNUR6");
		find();
	}
}
function InOutSum()
{
	var SaveOutIn=document.getElementById('SaveOutIn');
	var objRow=grid.getSelectionModel().getSelections();
	if (objRow.length == 0) { Ext.Msg.alert('提示', "请先点'统计'按钮!"); return; }
	else
	{
	  var countstr=""; //合计项
	  var countcls=ICountCls+"&"+OCountCls;
	  var tt=countcls.split('&');
	  for (i=0;i<tt.length;i++)
	  {
	  	if (tt[i]=="") continue;
		countstr=countstr+tt[i]+"|"+objRow[0].get(tt[i])+"^";
	  }
      var CareDate=objRow[0].get("CareDate"); 
	  var CareTime=objRow[0].get("CareTime");
	  var inamount=objRow[0].get(DisplaySumInAmount);
	  var OutQtAmount=objRow[0].get(DisplaySumOutAmount);
	  var InPart=objRow[0].get(PartInAmount);
	  var OutPart=objRow[0].get(PartOutAmount);
		//var StatTime=objRow[0].get("Item1");
	  //var StatHours=objRow[0].get("Item2");
	  var CaseMeasure=objRow[0].get("CaseMeasure");
	  var CaseMeasureArr=CaseMeasure.split(" ");
	  if (CaseMeasureArr.length>1)
	  {
	  	var StatTime=CaseMeasureArr[0];
	  	var StatHours=CaseMeasureArr[1];
	  }
	  else
	  {
	  	var StatTime="";
	  	var StatHours="";
	  }
		var str=countstr+"^SumInAmount|"+inamount+"^SumOutAmount|"+OutQtAmount+"^CareDate|"+formatDate(CareDate)+"^CareTime|"+CareTime+"^Typ|Sum^"+"InPart|"+InPart+"^OutPart|"+OutPart+"^StatTime|"+StatTime+"^StatHours|"+StatHours;
		//alert(str);
		var diaggrid = Ext.getCmp('diaggrid');
		if (diaggrid) {
  		var selModel=diaggrid.getSelectionModel();
  		if (selModel.hasSelection()) {   
  			var objDiagRow = selModel.getSelections();		  			
				DiagnosDr=objDiagRow[0].get("rw");
			}
			else {
				DiagnosDr="";	
			}
		}
		else {
			DiagnosDr="";
		}
		str=str+"^DiagnosDr|"+DiagnosDr;
		//alert(str);
		var a=cspRunServerMethod(SaveOutIn.value,EpisodeID,str,session['LOGON.USERID'],"DHCNUR6");
		find();
 }
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
		width: 450,
		height: 550,
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

	var	grid1=Ext.getCmp("ordgrid");
	tobar=grid1.getTopToolbar();
	tobar.addItem(
	    {
			xtype:'datefield',
			format: 'Y-m-d',
			id:'ordgridstdate',
			value:(diffDate(new Date(),-1))
		},
	    {
			xtype:'datefield',
			format: 'Y-m-d',
			id:'ordgridenddate',
			value:new Date()
		}
	);
	tobar.addButton(
	  {
		className: 'new-topic-button',
		text: "查询",
		//handler:find,
		id:'ordgridSch'
	  }

	);

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
function add(a,b,c,d,e,f,g,h,i,j,k,l,m,n,o)
{ //OrdDate,OrdTime,ARCIMDesc,PriorDes,Meth,PHFreq,Dose,PhQtyOrd,OrdStat,Doctor,Oew,OrdSub,Sel,SeqNo
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
		OrdSub: m,
		SeqNo: o
	});
}


function printNurRec()
{
		var GetPrnSet=document.getElementById('GetPrnSet');
		var GetHead=document.getElementById('GetPatInfo');
		var ret=cspRunServerMethod(GetHead.value,EpisodeID);
		var hh=ret.split("^");
		//alert("ddd");
		//debugger;
		var a=cspRunServerMethod(GetPrnSet.value,"DHCNUR6",EpisodeID); //page, caredattim, prnpos, adm,Typ,user
		if (a=="") return;
		var GetLableRec=document.getElementById('GetLableRec');
		var LabHead=cspRunServerMethod(GetLableRec.value,"DHCNUR6^"+session['LOGON.CTLOCID']);
		var tm=a.split("^");
		var stdate="" //tm[2];
		var stim="" //tm[3];
		var edate="" //tm[4];
		var etim="" //tm[5];
		//PrintComm.RHeadCaption=hh[1];
		//PrintComm.LHeadCaption=hh[0];
		//PrintComm.RFootCaption="第";
		//PrintComm.LFootCaption="页";
		//PrintComm.LFootCaption=hh[2];
		PrintComm.TitleStr=ret;
		PrintComm.SetPreView("1");
		PrintComm.PrnLoc=session['LOGON.CTLOCID'];
		var aa=tm[1].split("&");
		//PrintComm.stPage=aa[0];
		//if (aa.length>1) PrintComm.stRow=aa[1];
		PrintComm.stPage=0;
		PrintComm.stRow=0;
		PrintComm.previewPrint="1"; //是否弹出设置界面
		//PrintComm.stprintpos=tm[0];
		PrintComm.stprintpos=0;
		//alert(PrintComm.Pages);
		PrintComm.SetConnectStr(CacheDB);
		PrintComm.ItmName = "DHCNurPrnMould6"; //338155!2010-07-13!0:00!!
		//debugger;
		var parr=EpisodeID+"!"+stdate+"!"+stim+"!"+edate+"!"+etim+"!DHCNUR6";
		PrintComm.ID = "";
		PrintComm.MultID = "";
		//PrintComm.MthArr="web.DHCConsult:getConsultInfo&id:"+myid;
		if(LabHead!="")PrintComm.LabHead=LabHead;
		PrintComm.SetParrm(parr); // ="EpisodeId" ; //"p1:0^p2:"
		PrintComm.PrintOut();
		var SavePrnSet=document.getElementById('SavePrnSet');
		//debugger;
		var CareDateTim=PrintComm.CareDateTim;
		if (CareDateTim=="") return ;
		var pages=PrintComm.pages;
		var stRow=PrintComm.stRow;
		//debugger;
		var stprintpos=PrintComm.stPrintPos;
		//alert(pages+","+CareDateTim+","+stprintpos+","+EpisodeID+","+"DHCNUR6"+","+session['LOGON.USERID']+","+PrintComm.PrnFlag);
		//PrnFlag==1说明是打印预览
		if (PrintComm.PrnFlag==1) return;
		//如果原记录保存打印到第8页则当打印第8页之前页时不保存打印记录
		if (pages<aa[0]) return;
		var a=cspRunServerMethod(SavePrnSet.value,pages,CareDateTim,stprintpos,EpisodeID,"DHCNUR6",session['LOGON.USERID']); //page, caredattim, prnpos, adm,Typ,user
		//find();
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

function DBC2SBC(str)   
{
	var result = '';
	if ((str)&&(str.length)) {
		for (i = 0; i < str.length; i++) {
			code = str.charCodeAt(i);
			if (code >= 65281 && code <= 65373) {
				result += String.fromCharCode(str.charCodeAt(i) - 65248);
			}
			else {
				if (code == 12288) {
					result += String.fromCharCode(str.charCodeAt(i) - 12288 + 32);
				}
				else {
					result += str.charAt(i);
				}
			}
		}
	}
	else{
		result=str;
	}  
	return result;   
}

