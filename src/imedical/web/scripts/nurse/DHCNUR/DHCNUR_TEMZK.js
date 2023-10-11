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

var modeldatasj=[['DB','大便次数未填写'],['TZ','周五体重未填写'],['RY','入院生命体征未填写'],['XC','需测体温未填写'],['ZK','转科事件未填写'],['QB','全部事件']];
var KNurseNameStore = new Ext.data.SimpleStore({
    fields: ['id', 'desc'],
    data : modeldatasj
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
			mode : 'local'
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
var SJTypeBox = new Ext.form.ComboBox({
			id : 'SJType',
			//hiddenName : 'region1',
			store : KNurseNameStore,
			width : 150,
			fieldLabel : '根目录名',
			valueField : 'id',
			value:"",
			displayField : 'desc',
			editable: false,
			allowBlank : false,
			triggerAction : 'all',
			mode : 'local'
		});
SJTypeBox.on('select', function() 
    {
	    find()     
		});
		var modledata = new Array();
var GetModel = document.getElementById('GetModel');
if (GetModel) {
	cspRunServerMethod(GetModel.value, 'addmodel');
}

function addmodel(a, b) {
	modledata.push({
				modle : a,
				modledesc : b
			});
}
var modlestore = new Ext.data.JsonStore({
			data : modledata,
			fields : ['modle', 'modledesc']
		});
var combo = new Ext.form.ComboBox({
			id : 'mygridmodle',
			store : modlestore,
			valueField : 'modle',
			displayField : 'modledesc',
			typeAhead : true,
			mode : 'local',
			triggerAction : 'all',
			// emptyText:'按模版查询...',
			selectOnFocus : true,
			width : 160,
			listeners : {
				select : function(combo, record, index) {
					//lablecombo.clearValue();
					//labledata = [];
					//var GetMoldelBlank = document.getElementById('GetMoldelBlank');
					//cspRunServerMethod(GetMoldelBlank.value, combo.value,'addmodelblank');
					//alert(Ext.encode(labledata))
					//lablecombo.store.loadData(labledata);
				}
			}
		});
function BodyLoadHandler(){
setsize("mygridpl", "gform", "mygrid");
	//fm.doLayout(); 
	var but1 = Ext.getCmp("mygridbut1");
	but1.hide();
	//but1.on('click', newEvent);	
	var but = Ext.getCmp("mygridbut2");
	but.hide();

	var grid = Ext.getCmp('mygrid');
	var grid1 = Ext.getCmp('mygrid');
	var mydate = new Date();
	var tobar = grid.getTopToolbar();
	var bbar = grid.getBottomToolbar ();
	//bbar.hide();
	//grid.on('rowdblclick',modccevent);
	tobar.addItem('质控事件',
		SJTypeBox,'床号', {
				xtype : 'textfield',
				id : 'ch',
				fieldLabel : '床号',
				width:'50'
			},'姓名', {
				xtype : 'textfield',
				id : 'xm',
				fieldLabel : '姓名',
				width:'60'
			}),
	
	tobar.addButton({
		className: 'new-topic-button',
		text: "刷新",
		handler: find,
		icon:'../images/uiimages/reload.png',
		id: 'mygridSch'
	});
	tobar.addItem("-");
		tobar.addButton({
		className: 'new-topic-button',
		text: "质控说明",
		icon:'../images/uiimages/log.png',
		handler: zksm,
		id: 'mygridSch33'
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
   /*
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
	var mygridtime = Ext.getCmp("KNurseName");
	mygridtime.setValue("QB")
	mygridtime.setValue(rowObj[0].get("rw"));	
	}}
   );
   */
  var mygridtime = Ext.getCmp("SJType");
	mygridtime.setValue("QB")
	//inidata("patward","Desc","web.DHCNurblsjflwh:GetWard","Loc$W");
	//inidata("KNurse","Desc","Nur.DHCNURLocData:GetKNurse","Loc$W");
	//inidata("KNurseName","Desc","User.DHCNURMenuSub:GetRootname","Loc$W");
   // inidata("CCERR","Desc","web.DHCNurblsjflwh:CRItem","");  
   	grid.addListener('rowcontextmenu', rightClickFn);
   		grid.addListener('rowclick', rowClickFn);
		grid.on('beforeedit', beforeEditFn);
  find();
 
//alert();
//debugger;
}
function beforeEditFn(e){
	grid.rowIndex = e.row;   //得到当前的行
	grid.columnIndex = e.column;	//得到当前的列
}
function zksm()
{       
	var lnk= "DHCNurEmrComm.csp?"+"&EmrCode=DHCNURZKSM"+"&EpisodeID=";
	window.open(lnk,"htmzksm",'toolbar=no,location=no,directories=no,resizable=yes,width=350,height=400');
 

}
function OrdSch()
{         var grid1 = Ext.getCmp('mygrid');
	var rowObj = grid1.getSelectionModel().getSelections();
	if (rowObj.length == 0) { Ext.Msg.alert('提示', "请先选择一条记录!"); return; }
	var Adm=rowObj[0].get("Adm"); 
	// var CurrAdm=selections[rowIndex].get("Adm");
	var lnk= "DHCNurEmrComm.csp?"+"&EmrCode=DHCNUROUTREG"+"&EpisodeID="+Adm;
	window.open(lnk,"htm",'toolbar=no,location=no,directories=no,resizable=yes,width=760,height=500');
}
function temppreview()
{         
	  var grid1 = Ext.getCmp('mygrid');
		var rowObj = grid1.getSelectionModel().getSelections();
		
		if (rowObj.length == 0) { Ext.Msg.alert('提示', "请先选择一条记录!"); return; }
		var Adm=rowObj[0].get("Adm"); 
		TempShowNew(Adm);
		//TempShow(Adm);
	// var CurrAdm=selections[rowIndex].get("Adm");
	///var lnk= "DHCNurTempature.csp?"+"&EpisodeID="+Adm;
	//window.open(lnk,"htm",'toolbar=no,location=no,directories=no,status=yes,resizable=no,width=860,height=800');
}
function QtInsert()
{
	 var grid1 = Ext.getCmp('mygrid');
	var rowObj = grid1.getSelectionModel().getSelections();
		
	if (rowObj.length == 0) { Ext.Msg.alert('提示', "请先选择一条记录!"); return; }
	var Adm=rowObj[0].get("Adm"); 
	var types=rowObj[0].get("type"); 
	var rq=rowObj[0].get("rq"); 
	var xctime=rowObj[0].get("xctime"); 
	if (types!="ZK")
	{
		Ext.Msg.alert('提示', "只有选中转科事件提醒才能插入转科事件!"); return;
		}
	var QtInsert = document.getElementById('QtInsert');
	//alert(QtInsert)
	if (QtInsert) {
		//alert(Adm+","+rq+","+xctime);
		var str="插入"+rq+"/"+xctime+"转入事件"
		alert('提示:'+ str)
		var ee=cspRunServerMethod(QtInsert.value,Adm,rq,xctime,"2",session['LOGON.USERID']);
		if (ee != "0") {
			alert(ee);
			return;
		}
		else 
			{ //alert("成功")
				  find()
				 Ext.Msg.show({    
	       title:'确认一下',    
	       msg: '保存成功!需要修改转入事件时间吗？',    
	       buttons:{"ok":"是     ","cancel":"  否"},
	       fn:  function(btn, text){    
	            if (btn == 'ok'){   
	
	            var lnk= "DHCNurEmrComm.csp?"+"&EmrCode=DHCNURQTDATA"+"&EpisodeID="+Adm;
	            window.open(lnk,"htm3",'toolbar=no,location=no,directories=no,resizable=yes,width=525,height=300');
	            
	            }
					        else
	            {   	}
	            
	        },    
	       animEl: 'newbutton'   
	       });
	       
	     
				}
	}
}
function QtEvent()
{         var grid1 = Ext.getCmp('mygrid');
	var rowObj = grid1.getSelectionModel().getSelections();
	if (rowObj.length == 0) { Ext.Msg.alert('提示', "请先选择一条记录!"); return; }
	var Adm=rowObj[0].get("Adm");  
	// var CurrAdm=selections[rowIndex].get("Adm");
	var lnk= "DHCNurEmrComm.csp?"+"&EmrCode=DHCNURQTDATA"+"&EpisodeID="+Adm;
	window.open(lnk,"htm",'toolbar=no,location=no,directories=no,resizable=yes,width=520,height=300');
}
function PatDataDetail()
{         var grid1 = Ext.getCmp('mygrid');
	var rowObj = grid1.getSelectionModel().getSelections();
	if (rowObj.length == 0) { Ext.Msg.alert('提示', "请先选择一条记录!"); return; }
	var Adm=rowObj[0].get("Adm");
	var lnk= "DHCNurEmrComm.csp?"+"&EmrCode=DHCNURTEMDETAIL"+"&EpisodeID="+Adm;
	window.open(lnk,"htm",'toolbar=no,location=no,directories=no,resizable=yes,width=900,height=600,left=50,top=90');
} 
function tranlist()
{         var grid1 = Ext.getCmp('mygrid');
	var rowObj = grid1.getSelectionModel().getSelections();
	if (rowObj.length == 0) { Ext.Msg.alert('提示', "请先选择一条记录!"); return; }
	var Adm=rowObj[0].get("Adm");  
	// var CurrAdm=selections[rowIndex].get("Adm");
	var lnk= "DHCNurEmrComm.csp?"+"&EmrCode=DHCNURTRAN"+"&EpisodeID="+Adm;
	window.open(lnk,"htm233",'toolbar=no,location=no,directories=no,resizable=yes,width=660,height=300');
}
var rightClick = new Ext.menu.Menu(  {
                id : 'rightClickCont',
                items : [ 
					      {
                    id:'rMenu2',
                    text : '事件登记',
                    handler:QtEvent
                },	{
                    id:'rMenu8',
                    text : '插入转科事件',
                    handler:QtInsert
                },	{
                    id:'rMenu4',
                    text : '预览',
                    handler:temppreview
                },
					      {
                    id:'rMenu5',
                    text : '数据明细',
                    handler:PatDataDetail
                },
					      {
                    id:'rMenu6',
                    text : '转移记录',
                    handler:tranlist
                }]
            });
function rightClickFn(client, rowIndex, e)  {
          e.preventDefault();
          grid=client;
		  CurrRowIndex=rowIndex;
          rightClick.showAt(e.getXY());
            }
function rowClickFn(grid, rowIndex, e)  {
                //alert('你单击了' + rowIndex);
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
{ var modle = Ext.getCmp("mygridmodle");
	//	var patward = Ext.getCmp("patward");
	//	var LocType = Ext.getCmp("LocType");
	//	var Id = Ext.getCmp("KNurse");
			var Name = Ext.getCmp("KNurseName");
	//			var Type = Ext.getCmp("mygridlabledesc3");
		//alert(patward.getValue())
		//alert(Id.getValue())
	var RecSave = document.getElementById('Save');
	var mygrid = Ext.getCmp("mygrid");
	if (patward.getValue()=="")
	{
		//alert("科室不能为空")
	//	return;
		}
		var modelname = Ext.getCmp("mygridmodle").lastSelectionText;
		var gname = Ext.getCmp("KNurseName").lastSelectionText;
	//	alert(StTime)
	var parr =Name.getValue() + "^" + modle.getValue() +"^"+session['LOGON.CTLOCID']+"^"+modelname+"^"+gname
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
	//alert(parr);
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
function find()
{
		//var patward = Ext.getCmp("patward");
		//var LocType = Ext.getCmp("LocType");
		//var Id = Ext.getCmp("KNurse");
			var Name = Ext.getCmp("SJType");
			//	var Type = Ext.getCmp("mygridlabledesc3");
	var da=diffDate(new Date(),+0)
  da=getDate(da) 
  da=da.getDay()
  ///da=5
  //alert(da)
  var ch=Ext.getCmp("ch").getValue();
  var xm=Ext.getCmp("xm").getValue();
	var mygrid = Ext.getCmp("mygrid");
	var parr = session['LOGON.CTLOCID'] + "^" + Name.getValue() + "^" +ch+ "^" + xm+ "^" + da
	//var parr="^^^^"
  //alert(parr);
 // alert(new Date())

 
	var GetQueryData=document.getElementById('GetQueryData');
	arrgrid=new Array();
	var grid = Ext.getCmp("mygrid");
	//var a = cspRunServerMethod(GetQueryData.value, "Nur.DHCTEMQC:CRItem", "parr$"+parr, "AddRec");	
    //grid.store.loadData(arrgrid); 
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

