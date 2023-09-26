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

var UserType="";
var GetUserType=document.getElementById('GetUserType');
if (GetUserType){
	UserType=cspRunServerMethod(GetUserType.value,session['LOGON.USERID']);
}


var grid;
var arrtim=new Array();
var GetQueryData = document.getElementById('GetQueryData1');
var a = cspRunServerMethod(GetQueryData.value, "web.DHCTHREEEX.GetTimePoint", "" , "AddTim");
var storetim = new Ext.data.JsonStore({
			data : arrtim,
			fields : ['idv', 'des']
		});
function AddTim(str)
{
	//var a=new Object(eval(str));
	var obj = eval('(' + str + ')');
	//obj.PregHPregDate=getDate(obj.PregHPregDate);
	arrtim.push(obj);
	//debugger;
}
function gethead()
{
	var GetHead=document.getElementById('GetHead');
	var ret=cspRunServerMethod(GetHead.value,EpisodeID);
	var hh=ret.split("^");
	return hh[0];
	//debugger;
}
var timField = new Ext.form.ComboBox({
			id : 'mygridttime',
			hiddenName : 'mygridttime1',
			store : storetim,
			width : 150,
			fieldLabel : '固定时间',
			valueField : 'idv',
			displayField : 'des',
			allowBlank : true,
			mode : 'local',
			anchor : '100%'
		});
timField.on('select', function() {
			find();
		});
function BodyLoadHandler(){
	setsize("mygridpl","gform","mygrid");
	//fm.doLayout(); 
    grid1=Ext.getCmp("mygrid");
	grid1.on('click',gridclick);

	var but1=Ext.getCmp("mygridbut1");
	but1.hide();
	//but1.on('click',additm);
	var but=Ext.getCmp("mygridbut2");
	but.setText("保存");
	but.on('click',save);
	var gettime=document.getElementById('getTime');
	var timindex=cspRunServerMethod(gettime.value);

	var cmbtim=Ext.getCmp("mygridttime");
	cmbtim.setValue(timindex);
	
	Ext.override(Ext.Editor, {
			onSpecialKey : function(field, e) {
				var key = e.getKey();
				this.fireEvent('specialkey', field, e);
			}
		});
	Ext.override(Ext.grid.RowSelectionModel, {
			onEditorKey : function(F, E) {
				var C = E.getKey(), G, D = this.grid, B = D.activeEditor;
				var A = E.shiftKey;
				var keyCode=E.keyCode;
				if (C == E.TAB) {
					E.stopEvent();
					B.completeEdit();
					if (A) {
						G = D.walkCells(B.row, B.col - 1, -1, this.acceptsNav,
								this);
					} else {
						G = D.walkCells(B.row, B.col + 1, 1, this.acceptsNav,
								this);
					}
				} else {
					if (C == E.ENTER) {
						
						E.stopEvent();
						// alert(B);
						B.completeEdit();
						save("1");
						if (this.moveEditorOnEnter !== false) {
							if (A) {
								// G = D.walkCells(B.row - 1, B.col, -1,
								// this.acceptsNav,this)
								G = D.walkCells(B.row, B.col - 1, -1,
										this.acceptsNav, this);
							} else {
								// G = D.walkCells(B.row + 1, B.col, 1,
								// this.acceptsNav,this)
								G = D.walkCells(B.row, B.col + 1, 1,
										this.acceptsNav, this);
							}
						}
					} else {
						if (C == E.ESC) {
							B.cancelEdit();

						}
						else
								{

									switch(keyCode)
									{
										case 39:
												G = D.walkCells(B.row, B.col + 1, 1,this.acceptsNav, this);
												break;
										case 37:		
												G = D.walkCells(B.row, B.col - 1, -1,this.acceptsNav, this);
												break;
										case 40:
												G = D.walkCells(B.row+1, B.col , 1,this.acceptsNav, this);
												break;
										case 38:
												G = D.walkCells(B.row-1, B.col , 1,this.acceptsNav, this);
												break;
										default:
													break;
									}
								}
					}
				}
				if (G) {
					D.startEditing(G[0], G[1]);
				}
			}
		});
    var sm2 = new Ext.grid.RowSelectionModel({   
        moveEditorOnEnter: true,   
        singleSelect: false,   
        listeners: {   
            //rowselect : function(sm, row, rec) {   
                //centerForm.getForm().loadRecord(rec);   
           // }   
        }   
  
    });
	
	
  	grid=Ext.getCmp('mygrid');
  	//grid.setTitle(gethead());
  	var mydate=new Date();
  	var tobar=grid.getTopToolbar();
	tobar.addItem(
	    {
			xtype:'datefield',
			format: 'Y-m-d',
			id:'mygridstdate',
			value:(diffDate(new Date(),0))
		}
      ,timField
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
			text: "特殊字符",
			handler:SepcialChar,
			id:'PrintBut'
		  }
	  );
 		tobar.addButton({
			className : 'new-topic-button',
			text : "需测体温查询",
			handler : SchXC,
			id : 'mygridSchXC'
		});
	//tobar.render(grid.tbar);
	tobar.addButton(
	{
			//className: 'new-topic-button',
			text: "质控提醒",
			handler:makesure,
			id:'makesure'
		  }
	  );

	tobar.doLayout(); 
 	if (UserType=="DOCTOR")
 	{
 		if (but1) but1.hide();
 		if (but) but.hide();
 		var obj=Ext.getCmp("PrintBut");
 		if (obj) obj.hide();
  		var obj=Ext.getCmp("XPrintSet");
 		if (obj) obj.hide();		
 	}
 	else
 	{
		grid.addListener('rowcontextmenu', rightClickFn);
		grid.addListener('rowclick', rowClickFn);
		grid.on('beforeedit', beforeEditFn);
 	}

Ext.QuickTips.init();//注意，提示初始化必须要有
grid.getStore().on('load',function(s,records){
          var girdcount=0;
          s.each(function(r){
               girdcount=girdcount+1;
          });
       //scope:this
       });
if (timindex!="") 
	find();
	
	var da=diffDate(new Date(),+0)
  da=getDate(da) 
  da=da.getDay() //当前是周几
  //cspRunServerMethod(Refresh,session['LOGON.CTLOCID'],da); //刷新质控表数据，如果不弹出质控界面，取消屏蔽
  	var lnk= "DHCNurEmrComm.csp?"+"&EmrCode=DHCNUR_TEMZK&EpisodeID="+EpisodeID  ;//打开体温单自动弹出质控界面 ，如果不需要屏蔽此两句
	  window.open(lnk,"ht1222m",'left=460,top=20,toolbar=no,location=no,directories=no,resizable=yes,width=1000,height=800');
//alert();
//debugger;
}

function makesure()
{
		var lnk= "DHCNurEmrComm.csp?"+"&EmrCode=DHCNUR_TEMZK&EpisodeID="+EpisodeID  ;//"&DtId="+DtId+"&ExamId="+ExamId
	  window.open(lnk,"ht1222m",'left=460,top=20,toolbar=no,location=no,directories=no,resizable=yes,width=1000,height=800');
}

var REC=new Array();

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
	var StDate = formatDate(Ext.getCmp("mygridstdate").getValue());
	var StTime = Ext.getCmp("mygridttime").lastSelectionText;
	var GetQueryData = document.getElementById('GetQueryData');
	var mygrid = Ext.getCmp("mygrid");
	var parr =session['LOGON.CTLOCID']+"^^"+StDate+"^"+StTime;
	if ((StTime=="")||(StTime==undefined)) return;
	//alert(StDate+"--"+StTime);
	//debugger;
	// debugger;
	var a = cspRunServerMethod(GetQueryData.value, "web.DHCThreeNew:GetAllPatient", "Parr$" + parr, "AddRec");
	mygrid.store.loadData(REC);
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

function AddRec(str)
{
	//var a=new Object(eval(str));
	var obj = eval('(' + str + ')');
	//obj.PregHPregDate=getDate(obj.PregHPregDate);
	REC.push(obj);
	//debugger;
}
function(record,rowIndex,rowParams,store)
 {   
                    //禁用数据显示红色   
 if(record.data.pstate!=0)
 { 
    return 'x-grid-record-red';   
 }
 else
 { 
   return '';   
  }   
                       
} //end for getRowClass  

function save()
{
		var store = grid.store;
		var rowCount = store.getCount(); //记录数
		var cm = grid.getColumnModel();
		var colCount = cm.getColumnCount(); 
		var StDate = formatDate(Ext.getCmp("mygridstdate").getValue());
		var StTime = Ext.getCmp("mygridttime").lastSelectionText;
    	if ((StTime=="")||(StTime==undefined)) return;
		var list = [];
		var rowObj = grid.getSelectionModel().getSelections();
			var len = rowObj.length;
			for (var r = 0;r < len; r++) {
			list.push(rowObj[r].data);
	    }
		//for (var i = 0; i < store.getCount(); i++) {
		//	list.push(store.getAt(i).data);
			//	debugger;
		//}
    var RecSave=document.getElementById('RecSave');
		for (var i = 0; i < list.length; i++) {
		  var obj=list[i];
		  var str="";
		  var CareDate="";
		  var CareTime="";
		  var flag="0";
			for (var p in obj) {
				obj[p]=obj[p].replace(/ /g,"")
				var aa = formatDate(obj[p]);	
				//alert(aa);			
				if (p=="Adm") EpisodeID=obj[p];
				//alert(p);
				if (p=='CareTime') CareTime=obj[p];
				if (p=="") continue;
											if (p=='Item1') {
					if (isNaN(obj[p])){
						if ((obj[p]!="")&&(obj[p].split(".").length>2)) {
							alert("体温输入格式不对,包括多个点!");
							return;		
						}
						else {
							alert("体温值请录入数字!");
							return;
						}
					}
					else {
						if ((obj[p]!="")&&((obj[p] < 34)||(obj[p] > 43))) {
							alert("体温值小于34或大于43!");
							return;
						}
					}
				}
				if (p=='Item7') {
					if (isNaN(obj[p])){
						alert("脉搏值请录入数字!");
						return;
					}
					else {
						if ((obj[p]!="")&&((obj[p] < 20)||(obj[p] > 200))) {
							alert("脉搏值小于20或大于200!");
							return;
						}
					}
				}
				if (aa == "") 
				{
						str = str + p + "|" + obj[p] + '^';
				}else
				{
				  	str = str + p + "|" + aa + '^';	
				}
			}
			
			if ((str!="")&&(flag=="0"))
			{
				if (str.indexOf("CareDate")==-1)
				{
					str=str+"CareDate|"+CareDate+"^CareTime|"+CareTime;
					//debugger;
				}
			  // alert(EpisodeID);
			  //alert(str);
				var a=cspRunServerMethod(RecSave.value,EpisodeID,str,session['LOGON.USERID'],"DHCNUR6",session['LOGON.GROUPDESC'],StDate,StTime);
				if (a!="0")
				{
					alert(a);
					return;
				}
			}
		}
find();
} 
//Ext.util.Format.dateRenderer
//ext.util.format.date(ext.getcmp("控件id").getvalue(),y-m-d)Y-m-d H:m:s
function gettime()
{
	var a=Ext.util.Format.dateRenderer('h:m');
	return a;
}
function gridclick()
{
	 var grid=Ext.getCmp("mygrid");
  
	var rowObj = grid.getSelectionModel().getSelections();
	var len = rowObj.length;
	if(len < 1)
	{
		//Ext.Msg.show({title:'注意',msg:'请选择需要修改的数据!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
		return;
	}
	else
	{
		EpisodeID=rowObj[0].get("Adm");
		/*for (i = 0; i < top.frames.length; i++) {
			alert(top.frames[i].name);
		}*/
		var frm = top.document.forms["fEPRMENU"];
	  //frm.EpisodeID.value=EpisodeID;
    // ModConsult();
	}
}
function diffDate(val,addday){
	var year=val.getYear();
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
/*

*/
var rightClick = new Ext.menu.Menu(  {
                id : 'rightClickCont',
                items : [ 
					 {
					 id:'rMenu1',
					 text : '外出登记',
					 handler:OrdSch
				 },  {
                    id:'rMenu2',
                    text : '事件登记',
                    handler:QtEvent
                },	{
                    id:'rMenu4',
                    text : '预览',
                    handler:temppreview
                },
					{
                    id:'rMenu5',
                    text : '数据明细',
                    handler:PatDataDetail
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
function OrdSch()
{         
	var rowObj = grid1.getSelectionModel().getSelections();
	if (rowObj.length == 0) { Ext.Msg.alert('提示', "请先选择一条记录!"); return; }
	var Adm=rowObj[0].get("Adm"); 
	// var CurrAdm=selections[rowIndex].get("Adm");
	var lnk= "DHCNurEmrComm.csp?"+"&EmrCode=DHCNUROUTREG"+"&EpisodeID="+Adm;
	window.open(lnk,"htm",'toolbar=no,location=no,directories=no,resizable=yes,width=760,height=500');
 

}
function temppreview()
{         
		var rowObj = grid1.getSelectionModel().getSelections();
		if (rowObj.length == 0) { Ext.Msg.alert('提示', "请先选择一条记录!"); return; }
		var Adm=rowObj[0].get("Adm"); 
		TempShow(Adm);
	// var CurrAdm=selections[rowIndex].get("Adm");
	///var lnk= "DHCNurTempature.csp?"+"&EpisodeID="+Adm;
	//window.open(lnk,"htm",'toolbar=no,location=no,directories=no,status=yes,resizable=no,width=860,height=800');
 

}
function QtEvent()
{         
	var rowObj = grid1.getSelectionModel().getSelections();
	if (rowObj.length == 0) { Ext.Msg.alert('提示', "请先选择一条记录!"); return; }
	var Adm=rowObj[0].get("Adm");  
	// var CurrAdm=selections[rowIndex].get("Adm");
	var lnk= "DHCNurEmrComm.csp?"+"&EmrCode=DHCNURQTDATA"+"&EpisodeID="+Adm;
	window.open(lnk,"htm",'toolbar=no,location=no,directories=no,resizable=yes,width=460,height=300');
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

//document.body.onload=BodyLoadHandler;
 //date.on('change', function(){alert(1);});



function printNurRec()
{
		  var GetPrnSet=document.getElementById('GetPrnSet');
			var GetHead=document.getElementById('GetHead');
		  var ret=cspRunServerMethod(GetHead.value,EpisodeID);
		  var hh=ret.split("^");
	    //debugger;
			var a=cspRunServerMethod(GetPrnSet.value,"DHCNUR6",EpisodeID); //page, caredattim, prnpos, adm,Typ,user
			if (a=="") return;
			var GetLableRec=document.getElementById('GetLableRec');
			var LabHead=cspRunServerMethod(GetLableRec.value,"DHCNUR6^"+session['LOGON.CTLOCID']);
			var tm=a.split("^");
			var stdate=tm[2];
			var stim=tm[3];
			var edate=tm[4];
			var etim=tm[5];
			PrintComm.RHeadCaption=hh[1];
			PrintComm.LHeadCaption=hh[0];
			//PrintComm.RFootCaption="第";
			//PrintComm.LFootCaption="页";
			PrintComm.LFootCaption=hh[2];
			PrintComm.SetPreView("1");
			var aa=tm[1].split("&");
			PrintComm.stPage=aa[0];
			if (aa.length>1) PrintComm.stRow=aa[1];
			PrintComm.stprintpos=tm[0];
			//alert(PrintComm.Pages);
			PrintComm.SetConnectStr(CacheDB);
			PrintComm.ItmName = "DHCNurPrnMould6";  //338155!2010-07-13!0:00!!
			//debugger;
			var parr=EpisodeID+"!"+stdate+"!"+stim+"!"+edate+"!"+etim+"!DHCNUR6";
			PrintComm.ID = "";
			PrintComm.MultID = ""; 
			//PrintComm.MthArr="web.DHCConsult:getConsultInfo&id:"+myid;
			PrintComm.LabHead=LabHead;			
			PrintComm.SetParrm(parr);  // ="EpisodeId" ;  //"p1:0^p2:"
			PrintComm.PrintOut();
			var SavePrnSet=document.getElementById('SavePrnSet');
			//debugger;
			var CareDateTim=PrintComm.CareDateTim;
			if (CareDateTim=="") return ;
			var pages=PrintComm.Pages;
			var stRow=PrintComm.stRow;
			//debugger;
			var stprintpos=PrintComm.stPrintPos;			
			//alert(pages+","+CareDateTim+","+stprintpos+","+EpisodeID+","+"DHCNUR6"+","+session['LOGON.USERID']);
			//暂时判断坐标为0里,说明是打印预览
			if (PrintComm.PrnFlag==1) return;
			var a=cspRunServerMethod(SavePrnSet.value,pages+"|"+stRow,CareDateTim,stprintpos,EpisodeID,"DHCNUR6",session['LOGON.USERID']); //page, caredattim, prnpos, adm,Typ,user
			//alert(a);			
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

function beforeEditFn(e){
	grid.rowIndex = e.row;   //得到当前的行
	grid.columnIndex = e.column;	//得到当前的列
}
var storespechar = new Array();
function SepcialChar() {
	var grid = new Ext.grid.GridPanel({
		id : 'mygridspecchar',
		name : 'mygridspecchar',
		title : '',
		stripeRows : true,
		height : 250,
		width : 120,
		tbar : [{
					id : 'insertBtn',
					handler:insertSpecChar,
					text : '插入'
				}],
		store : new Ext.data.JsonStore({
					data : [],
					fields : ['desc', 'rw']
				}),
		colModel : new Ext.grid.ColumnModel({
			columns : [{
						header : '特珠字符',
						dataIndex : 'desc',
						width : 110
					}, {
						header : 'rw',
						dataIndex : 'rw',
						width : 0
					}],
			rows : [],
			defaultSortable : true
		}),
		enableColumnMove : false,
		viewConfig : {
			forceFit : false
		}
	});
	storespechar = new Array();
	var GetQueryData = document.getElementById('GetQueryData1');
	var parr="";
	var a = cspRunServerMethod(GetQueryData.value,"User.DHCTEMPSPECIALCHAR:CRItem", "", "AddSpecChar");
	grid.store.loadData(storespechar);
	var window = new Ext.Window({
		title: '特殊字符',
		width: 138,
		height: 285,
		autoScroll: true,
		layout: 'absolute',
		plain: true,
		frame:true,
		//modal: true,
		//bodyStyle: 'padding:5px;',
		///buttonAlign: 'center',
		items : grid,
		listeners:{'close':function(){
			Ext.getCmp('mygrid').startEditing(Ext.getCmp('mygrid').rowIndex , Ext.getCmp('mygrid').columnIndex);
		}}
	});
	window.show();
}
function AddSpecChar(str)
{
	var obj = eval('(' + str + ')');
	storespechar.push(obj);
}

function insertSpecChar() {
	var grid = Ext.getCmp('mygridspecchar');
	//弹出界面中Grid
    var selModel = grid.getSelectionModel();   
    if (selModel.hasSelection()) {  
		var selections = selModel.getSelections();
		var rowIndex = grid.store.indexOf(grid.getSelectionModel().getSelected());
		var specchardesc=grid.store.getAt(rowIndex).data.desc;
		var mygrid=Ext.getCmp('mygrid');
		var oldStr=mygrid.store.getAt(mygrid.rowIndex).get(mygrid.getColumnModel().getDataIndex(mygrid.columnIndex));
		if (oldStr) specchardesc=oldStr+specchardesc
		mygrid.store.getAt(mygrid.rowIndex).set(mygrid.getColumnModel().getDataIndex(mygrid.columnIndex),specchardesc);
		mygrid.startEditing(mygrid.rowIndex , mygrid.columnIndex);
	}
}

function PatDataDetail()
{         
	var rowObj = grid1.getSelectionModel().getSelections();
	if (rowObj.length == 0) { Ext.Msg.alert('提示', "请先选择一条记录!"); return; }
	var Adm=rowObj[0].get("Adm");
	var lnk= "DHCNurEmrComm.csp?"+"&EmrCode=DHCNURTEMDETAIL"+"&EpisodeID="+Adm;
	window.open(lnk,"htm",'toolbar=no,location=no,directories=no,resizable=yes,width=900,height=600,left=50,top=90');
} 
 
  function SchXC()
{
	REC = new Array();
	var adm = EpisodeID;
	var StDate = formatDate(Ext.getCmp("mygridstdate").getValue());
	var StTime = Ext.getCmp("mygridttime").lastSelectionText;
	var GetQueryData = document.getElementById('GetQueryData');
	var mygrid = Ext.getCmp("mygrid");
	var parr =session['LOGON.CTLOCID']+"^^"+StDate+"^"+StTime;
	if ((StTime=="")||(StTime==undefined)) return;
	//alert(StDate+"--"+StTime);
	//debugger;
	// debugger;
	var a = cspRunServerMethod(GetQueryData.value, "web.DHCNurNeedMeasureTempPat:GetNeedMeaserPat", "Parr$" + parr, "AddRec");
	mygrid.store.loadData(REC);
	buttonFlag="0";
}

