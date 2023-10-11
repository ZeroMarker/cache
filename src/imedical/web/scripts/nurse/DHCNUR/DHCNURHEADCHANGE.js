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
var SumInName="";
var SumInAmount="";
var SumOutName="";
var SumOutAmount="";
var PartInName="";
var PartInAmount="";
var PartOutName="";
var PartOutAmount="";
var DisplaySumInName="";
var DisplaySumInAmount="";
var DisplaySumOutName="";
var DisplaySumOutAmount="";
var OrdInName="";
var OrdInAmount="";
var ICountCls="";
var OCountCls="";

var UserType="";
var GetUserType=document.getElementById('GetUserType');
if (GetUserType){
	UserType=cspRunServerMethod(GetUserType.value,session['LOGON.USERID']);
}
var grid;
var DiagnosDr="";
function gethead()
{
	var GetHead=document.getElementById('GetHead');
	var ret=cspRunServerMethod(GetHead.value,EpisodeID);
	var hh=ret.split("^");
	return hh[0]+"  "+hh[1];
	//debugger;
}

function BodyLoadHandler(){
	setsize("mygridpl","gform","mygrid");
	//fm.doLayout(); 
	Ext.getCmp('mygrid').getColumnModel().setHidden(14,true);//隐藏最后3列
	Ext.getCmp('mygrid').getColumnModel().setHidden(15,true);//隐藏最后3列
	Ext.getCmp('mygrid').getColumnModel().setHidden(16,true);//隐藏最后3列
	var but1=Ext.getCmp("mygridbut1");
	but1.on('click',additm);
	var but=Ext.getCmp("mygridbut2");
	but.setText("保存");
	but.on('click',save);
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
  	grid.setTitle(gethead());
  	var mydate=new Date();
  	var tobar=grid.getTopToolbar();
  	/*
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
*/
	tobar.addButton(
	  {
		className: 'new-topic-button',
		text: "查询",
		handler:find,
		id:'mygridSch'
	  }

	);
	/*
	tobar.addButton(
	{
			className: 'new-topic-button',
			text: "手术名称维护",
			handler:SSWH,
			id:'ssweihu'
	}
	);
 tobar.addButton(
	{
			className: 'new-topic-button',
			text: "引流项目维护",
			handler:SelectList,
			id:'SelectList'
	}
	);
*/
	//tobar.render(grid.tbar);
	 // tbar2.render(grid.tbar);
	 	var bbar = grid.getBottomToolbar ();
	  bbar.hide();
	  //上半部分
	  var bbar2 = new Ext.PagingToolbar({
		pageSize:30,
		store:grid.store,
		displayInfo:true,
		displayMsg:'显示第 {0} 条到 {1} 条记录，一共 {2} 条',
		emptyMsg:"没有记录"
	  });
	  bbar2.render(grid.bbar);
	tobar.doLayout(); 
 	if (UserType=="DOCTOR")
 	{
 		if (but1) but1.hide();
 		if (but) but.hide();
 		//var obj=Ext.getCmp("PrintBut");
 		//if (obj) obj.hide();
  		var obj=Ext.getCmp("XPrintSet");
 		if (obj) obj.hide();		
 	}
 	else
 	{
		//grid.addListener('rowcontextmenu', rightClickFn);
		//grid.addListener('rowclick', rowClickFn);
 	}
grid.on('mouseover',function(e){//添加mouseover事件
	var index = grid.getView().findRowIndex(e.getTarget());//根据mouse所在的target可以取到列的位置
	if(index!==false){//当取到了正确的列时，（因为如果传入的target列没有取到的时候会返回false）
		var store = grid.getStore();
		var totalRow="";
		if (store.getCount()>0) totalRow=store.getAt(index).get(DisplaySumInName);
		if ((totalRow)&&(totalRow.indexOf("入液量")>-1))
		{
			//var record = store.getAt(index);//把这列的record取出来
			//var str = Ext.encode(record.data);//组装一个字符串，这个需要你自己来完成，这儿我把他序列化
			var par=store.getAt(index).get("par");
			var rw=store.getAt(index).get("rw");
			var totalRow1,totalRow2,totalRow3,totalRow4;
			if ((par)&&(rw))
			{
				var GetSubInOut=document.getElementById('GetSubInOut');
				if (GetSubInOut)
				{
					var ret=cspRunServerMethod(GetSubInOut.value,par+"^"+rw);
					var retArr=ret.split("@");
					totalRow1=retArr[0];
					totalRow2=retArr[1];
					totalRow3=retArr[2];
					totalRow4=retArr[3];
				}	 	
			}
			else
			{
				totalRow1=store.getAt(index).get(PartInName);
				totalRow2=store.getAt(index).get(PartInAmount);
				totalRow3=store.getAt(index).get(PartOutName);
				totalRow4=store.getAt(index).get(PartOutAmount);
			}
			//var str="<p>"+totalRow1+"</p><p>"+totalRow2+"</p><p>"+totalRow3+"</p><p>"+totalRow4+"</p>";
			var str="<TABLE borderColor=#000000 width='100%' bgColor=#ffffff border=1 cellSpacing=0 cellPadding=0><TBODY>";
			str=str+"<TR bgColor=#D2E9FF><TD></TD><TD>名称</TD><TD>量</TD></TR>";
			var totalRow2Arr=totalRow2.split(";");
			str=str+"<TR><TD bgColor=#D2E9FF rowSpan="+(totalRow2Arr.length-1)+">入液量分项</TD><TD>"+totalRow2Arr[0].replace(":","</TD><TD>")+"</TD></TR>";
			for (var i=1;i<(totalRow2Arr.length-1);i++)
			{
				str=str+"<TR><TD>"+totalRow2Arr[i].replace(":","</TD><TD>")+"</TD></TR>";
			}
			var totalRow4Arr=totalRow4.split(";");
			str=str+"<TR><TD bgColor=#D2E9FF rowSpan="+(totalRow4Arr.length-1)+">出液量分项</TD><TD>"+totalRow4Arr[0].replace(":","</TD><TD>")+"</TD></TR>";
			for (var i=1;i<(totalRow4Arr.length-1);i++)
			{
				str=str+"<TR><TD>"+totalRow4Arr[i].replace(":","</TD><TD>")+"</TD></TR>";
			}
			str=str+"</TBODY></TABLE>";
			var rowEl = Ext.get(e.getTarget());//把target转换成Ext.Element对象
			rowEl.set({
				'ext:qtip':str  //设置它的tip属性
			},false);
	  }
	}
});
Ext.QuickTips.init();//注意，提示初始化必须要有
grid.getStore().on('load',function(s,records){
          var girdcount=0;
          s.each(function(r){
              if(r.get(DisplaySumInName)=='总入液量='){
                    grid.getView().getRow(girdcount).style.backgroundColor='#F7FE2E';
              }
              if(r.get(DisplaySumInName)=='入液量='){
                    grid.getView().getRow(girdcount).style.backgroundColor='#A7FE2E';
              }
              girdcount=girdcount+1;
          });
       //scope:this
       });
find()
//alert();
//debugger;
}

 //手术名称维护
 function SSWH()
{
		
	 	var lnk= "DHCNurEmrComm.csp?"+"&EmrCode=DHCNurHeadKnowledge&EpisodeID="+EpisodeID+"&headcode="+headcode //""+"&Status="+""  ;//"&DtId="+DtId+"&ExamId="+ExamId
	  var objret = window.showModalDialog(lnk,'titleSS',"dialogWidth:500px;dialogHeight:500px;center:yes;resizable:no;status:no;scroll:YES;help:no;edge:raised;");  	 
    if(objret ==undefined)
    {       
            self.location.reload();             
    }
}
 var wind3;   //全局变量
 var kkk=0
 var ddd=0
 
 //下拉选维护
 function SelectList()
{
		
		//var lnk= "DHCNurEmrComm.csp?"+"&EmrCode=DHCNurHeadKnowledge&EpisodeID="+EpisodeID+"&headcode="+EmrCode  //""+"&Status="+""  ;//"&DtId="+DtId+"&ExamId="+ExamId
	 	var lnk= "DHCNurEmrComm.csp?"+"&EmrCode=DHCNurHeadKnowledge&EpisodeID="+EpisodeID+"&headcode="+headcode //""+"&Status="+""  ;//"&DtId="+DtId+"&ExamId="+ExamId
	  //alert(lnk)
	  /*
     var ddd=kkk%2 
	  
	   if (ddd==0)
	   {	   	
	   wind3= window.open(lnk,"selectlist",'left=400,top=300,toolbar=no,location=no,directories=no,resizable=yes,width=600,height=400');
	   kkk=kkk+1;
	   }
	   else 
	   	{
	   		 if(typeof(wind3)!="undefined"&&wind3.open&&!wind3.closed)  //判断是否存在子窗口并处于打开状态
         {   
            wind3.close();  //关闭子窗口
            //CurrHeadDr= Ext.get("loc1").dom.value;
            //var a=cspRunServerMethod(Savecurhead,EpisodeID, CurrHeadDr, session['LOGON.USERID'], EmrCode);
            self.location.reload(); 
           // find()
          }      
          kkk=kkk+1;
	   	}
	   	*/
	  var objret = window.showModalDialog(lnk,'title35555',"dialogWidth:500px;dialogHeight:500px;center:yes;resizable:no;status:no;scroll:YES;help:no;edge:raised;");  
	   //alert(objret)
    if(objret ==undefined)
    {        // alert(1255)
            self.location.reload();             
    }

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
 	var a=cspRunServerMethod(GetNurPrnSet.value,"DHCNUR6",EpisodeID,'addprnset');
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
function handleGridLoadEvent(store,records)
{
	var grid=Ext.getCmp('mygrid');
	var gridcount=0;
	store.each(function(r){
		if(r.get('CareDate')!=""){
			 var date=getDate(r.get('CareDate'));
			 grid.store.getAt(gridcount).set("CareDate",date);
		}else if(r.get('PersonFlag')==0){	
		}
		gridcount=gridcount+1;
	})
}
function find(){
	//var link="dhcnurtempature.csp?EpisodeID="+EpisodeID;
   /// window.open (link,'体温单','height=1,width=1,top=0,left=0,toolbar=no,menubar=no,scrollbars=no, resizable=no,location=no, status=no') 
   // window.close();
  // alert(parent.frames.length);
    MeasureRel = new Hashtable();
    REC = new Array();
	var adm = EpisodeID;
	//var StDate = Ext.getCmp("mygridstdate");
	//var StTime = Ext.getCmp("mygridsttime");
	//var Enddate = Ext.getCmp("mygridenddate");
	//var EndTime = Ext.getCmp("mygridendtime");
	var GetQueryData = document.getElementById('GetQueryData');
	var mygrid = Ext.getCmp("mygrid");
	var parr = adm + "^" +"DHCNURHEADCHANGE"+"^"+headcode ;
	 mygrid.store.on("beforeLoad",function(){   
      mygrid.store.baseParams.parr=parr;    
   });    
     mygrid.getStore().addListener('load',handleGridLoadEvent);
     mygrid.store.load({
    	params:{
    		start:0,
    		limit:30
    	}	
   })
	// debugger;
	//var a = cspRunServerMethod(GetQueryData.value, "NurEmr.webheadchange:GetHeadChange", "parr$" + parr, "AddRec");
	//mygrid.store.loadData(REC);
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
	obj.CareDate=getDate(obj.CareDate);
	//obj.PregHPregDate=getDate(obj.PregHPregDate);
	REC.push(obj);
	//debugger;
}
function save()
{
	var store = grid.store;
	var rowCount = store.getCount(); //记录数
	var cm = grid.getColumnModel();
	var colCount = cm.getColumnCount();
	var list = [];
	var rowObj = grid.getSelectionModel().getSelections();
		var len = rowObj.length;
		for (var r = 0;r < len; r++) {
		list.push(rowObj[r].data);
	}		
	var grid1=Ext.getCmp('mygrid');
	var rwIndex=grid1.getSelectionModel().last;
	var CaseMeasureID="CaseMeasureID|";
	//debugger;
	if (MeasureRel.contains(rwIndex))
	{
		var rid=MeasureRel.items(rwIndex);		
		CaseMeasureID=CaseMeasureID+rid;
	}
	//for (var i = 0; i < store.getCount(); i++) {
	//	list.push(store.getAt(i).data);
	//	//	debugger;
	//}
	var RecSave=document.getElementById('RecSave');
	for (var i = 0; i < list.length; i++) {
	  var obj=list[i];
	  var str="";
	  var CareDate="";
	  var CareTime="";
	  var flag="0";
		for (var p in obj) {
			var aa = formatDate(obj[p]);				
			if (p=="CareDate") CareDate=aa;
			if (p=='CareTime') CareTime=obj[p];
			if (p=="") continue;
			if ((p == DisplaySumInName) && (obj[p].indexOf("入液量") != -1)) {
				flag = "1";
			}
			if ((p==DisplaySumOutName)&&(obj[p].indexOf("出液量")!= -1))
			{
				flag="1";
			} 
			if (aa == "") 
			{
					str = str + p + "|" + DBC2SBC(obj[p]) + '^';
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
			if((CareDate=="")||(CareTime==""))
			{
				alert("日期或时间不能为空！");
				return;
			}
			//alert(str);
			var a=cspRunServerMethod(RecSave.value,EpisodeID,str,session['LOGON.USERID'],"DHCNURHEADCHANGE");
			if (a!="0")
			{
				//alert(a);
				find()
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
	{name:'Item1'},
	{name:'Item2'},
	{name:'Item3'},
	{name:'Item4'},
	{name:'Item5'},
	{name:'Item6'},
	{name:'Item7'},
	{name:'Item8'},
	{name:'Item9'}, 
	{name:'Item10'},
	{name:'Item11'},
	{name:'Item12'},
	{name:'Item13'},
	{name:'Item14'},
	{name:'Item15'},
	{name:'Item16'},
	{name:'Item17'}, 
	{name:'Item18'},
	{name:'Item19'}, 
	{name:'Item20'},
	{name:'Item21'},
	{name:'Item22'},
	{name:'Item23'},
	{name:'Item24'},
	{name:'Item25'},
	{name:'Item26'},
	{name:'Item27'},
	{name:'Item28'},
	{name:'Item29'},
	{name:'Item30'},
	{name:'Item31'},
	{name:'Item32'},
	{name:'Item33'},
	{name:'Item34'},
	{name:'Item35'},
	{name:'Item36'},
	{name:'Item37'},
	{name:'Item38'},
	{name:'Item39'},
	{name:'Item40'},
	{name:'Item41'},
	{name:'Item42'},
	{name:'Item43'},
	{name:'Item44'},
	{name:'Item45'},
	{name:'Item46'},
	{name:'Item47'}, 
	{name:'Item48'},
	{name:'Item49'},
	{name:'Item50'},
	{name:'User'},
	{name:'rw'},
	{name:'par'}
      ]);
    var count = grid.store.getCount(); 
    var r = new Plant({CareDate:new Date(),CareTime:new Date().dateFormat('H:i'),NurRecTyp:headcode}); 
    grid.store.commitChanges(); 
    grid.store.insert(count,r); 
	return;
}
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
		handler:find,
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
function SureIn()
 {
	var grid = Ext.getCmp('ordgrid');
	var mygrid=Ext.getCmp('mygrid');
	var store = grid.store;
	var rowCount = store.getCount(); //记录数
	/*var cm = grid.getColumnModel();
	var colCount = cm.getColumnCount(); //列数
	var view = grid.getView();*/
	var num=0;
    var selModel = grid.getSelectionModel();   
    if (selModel.hasSelection()) {   
       	// Ext.Msg.confirm("警告", "确定要删除吗？", function(button) {   
				var selections = selModel.getSelections();
				//var rowIndex = grid.store.indexOf(grid.getSelectionModel().getSelected());
				//grid.getSelectionModel().selectRow(rowIndex);
				//debugger;
				var caredate,caretime;
				Ext.each(selections, function(item) {
					var des=item.data.ARCIMDesc;
					des=des.replace("_____","");
					var ml=item.data.Dose;
					var unit=item.data.DoseUnit;
					if ((unit!="ml")&&(unit!="ML")) ml=0;
					var seqno=item.data.SeqNo;
					var rowIndex = grid.store.indexOf(item);
					for (var i = rowIndex-1; i >=0; i--) {
						var subdes=store.getAt(i).data.ARCIMDesc;
						subdes=subdes.replace("_____","");
						var subml=store.getAt(i).data.Dose;
						var subunit=store.getAt(i).data.DoseUnit;
						if (subunit!="ml") subml=0;
						var subseqno=store.getAt(i).data.SeqNo;
						if (subseqno==seqno)
						{
							des=subdes+","+des;
							ml=eval(ml)+eval(subml);
						}
						else
						{
							break;	
						}
					}
					for (var i = rowIndex+1; i < store.getCount(); i++) {
						var subdes=store.getAt(i).data.ARCIMDesc;
						subdes=subdes.replace("_____","");
						var subml=store.getAt(i).data.Dose;
						var subunit=store.getAt(i).data.DoseUnit;
						if ((subunit!="ml")&&(subunit!="ML")) subml=0;
						var subseqno=store.getAt(i).data.SeqNo;
						if (subseqno==seqno)
						{
							des=des+","+subdes;
							ml=eval(ml)+eval(subml);
						}
						else
						{
							break;	
						}
					}
					if (num == 0) {
						caredate=mygrid.getStore().getAt(0).get("CareDate");
						caretime=mygrid.getStore().getAt(0).get("CareTime");
						var objRow=mygrid.getSelectionModel().getSelections();
						if (objRow.length == 0) { Ext.Msg.alert('提示', "请先选择某行!"); return; }
						else
						{
								objRow[0].set(OrdInName, des);
								objRow[0].set(OrdInAmount, ml);
						}
					}else{
						additm();
						mygrid.getSelectionModel().selectRow(mygrid.store.getCount()-1);   
						mygrid.getSelectionModel().getSelections()[0].set("CareDate", caredate);
						mygrid.getSelectionModel().getSelections()[0].set("CareTime", caretime);
						mygrid.getSelectionModel().getSelections()[0].set(OrdInName, des);
						mygrid.getSelectionModel().getSelections()[0].set(OrdInAmount, ml);
					}
					num++;
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
	//EmrCode,EpisodeId,fieldCode
		MeasureRel = new Hashtable();
     var grid1=Ext.getCmp('mygrid');
	var par=grid1.getSelectionModel().getSelections()[0].get("par"); 
	var rw=grid1.getSelectionModel().getSelections()[0].get("rw"); 
   // debugger;
	var rowid=par+"||"+rw;
	if (par==undefined)
	{
		rowid="";
	}
	var parr="DHCNUR6^"+EpisodeID+"^CaseMeasureXml^"+rowid;
	//alert(parr);
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
			items:[{
				xtype:"tabpanel",
				activeTab:0,
				frame:true,
				items:[
	  				{title:"医嘱",
			  			width: 550,
			  			height: 200,
			  			autoScroll: true,
		      			layout:'absolute',
			  			items:arr},		
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
			 			}]			
			 }]
		});   
 
            var arr = new Array();
	        var a = cspRunServerMethod(pdata1, "", "DHCNURMeasure", EpisodeID, "");
	        arr = eval(a);
            var emrknowurl="dhcnuremrknow.csp?EmrCode=DHCNurKnowldge&Parr="+parr+"&EpisodeID="+EpisodeID;
			//alert(emrknowurl);
            //中间   
            var center_item = new Ext.Panel({   
                region: 'center',   
          		autoScroll: true,
                split: true,   
                layout: 'fit',   
                collapsible: false,  
				height:50, 
                minSize: 50,   
  				frame:true,
                items: arrResult
            });    
            //南边，状态栏   
            var south_item = new Ext.Panel({   
                region: 'south',   
              	// contentEl: 'south-div',   
                split: true,   
               	// border: true,   
               	// collapsible: true,   
         		autoScroll: true,
                layout: 'absolute',   
                minSize: 200,  
				height:200,
  				frame:true,
                //items: arr 
				buttons: [{
						text: '确定',
						handler: function(){
							//	Save();
							//	window.close();
							sureMeasure();
						}
					}, {
						text: '取消',
						handler: function(){
							window.close();
						}
					}],
				html: '<iframe id ="southTab" name="ddd" style="width:100%; height:100%" src='+emrknowurl+' ></iframe>'
                
            });   
    
            //中间的中间，功能菜单   
 	//alert(parr);
	var window = new Ext.Window({ 
		title: '医嘱',
		width: 550,
		modal:true,
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
   
   ////var butsure=Ext.getCmp('_Button6');
   //butsure.on('click',sureMeasure);
	var rowObj = mygrid.getSelectionModel().getSelections();
	var len = rowObj.length;
	if (len < 1) {
		//Ext.Msg.show({title:'注意',msg:'请选择需要修改的数据!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
		return;
	}
	else {
		//var content = rowObj[0].get("CaseMeasure");
		//var TxtCaseMeasure=Ext.getCmp('TxtCaseMeasure');
		//TxtCaseMeasure.setValue(content);
	}
 //var mydate=new Date();
 //var butord=Ext.getCmp('_Button5');
 //butord.on=('click',OrdSch1);

 window.show();
 //alert();
}
var CaseMeasureID=""; //邦定的处置ID
var MeasureRel = new Hashtable();
function sureMeasure()
{
	 var gform=Ext.getCmp("gform");
   //gform.items.each(eachItem, this);  

	var TxtCaseMeasure=Ext.getCmp('TxtCaseMeasure');
	var frm=Ext.getCmp('CaseForm');
	var aa=document.getElementById("southTab");
	var CareCon=Ext.get("southTab").dom.contentWindow.document.getElementById("DesignForm");
	//alert(CareCon.QichTextCon.GetCellText());
	var win=Ext.get("southTab").dom.contentWindow;
   // var parr="DHCNUR6^"+EpisodeID+"^CaseMeasureXml";
	var ret=southTab.Save();
	
	var grid1=Ext.getCmp('mygrid');
	CaseMeasureID=ret; 
	var rwIndex=grid1.getSelectionModel().last;
	MeasureRel.add(rwIndex,CaseMeasureID);
	//debugger;
	grid.getSelectionModel().getSelections()[0].set("CaseMeasure",CareCon.QichTextCon.GetCellText());
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
		if (a=="-1") return;
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
	var GetQueryData=document.getElementById('GetQueryData1');
	var ordgrid=Ext.getCmp("CheckGrid");
    var parr=adm+"^"+StDate.value+"^"+Enddate.value;
 	var a=cspRunServerMethod(GetQueryData.value,"web.DHCNurJYRESULT:GetOrdRadia","parr$"+parr,"AddCheck");
   // grid.width=document.body.offsetWidth;
    
    ordgrid.store.loadData(condata);   
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

function additmstat(statenddate,statendtime)
{
  	var Plant = Ext.data.Record.create([
	{name:'CareDate'}, 
	{name:'CareTime'},
	{name:'Item1'},
	{name:'Item2'},
	{name:'Item3'},
	{name:'Item4'},
	{name:'Item5'},
	{name:'Item6'},
	{name:'Item7'},
	{name:'Item8'},
	{name:'Item9'}, 
	{name:'Item10'},
	{name:'Item11'},
	{name:'Item12'},
	{name:'Item13'},
	{name:'Item14'},
	{name:'Item15'},
	{name:'Item16'},
	{name:'Item17'}, 
	{name:'Item18'},
	{name:'Item19'}, 
	{name:'Item20'},
	{name:'Item21'},
	{name:'Item22'},
	{name:'Item23'},
	{name:'Item24'},
	{name:'Item25'},
	{name:'Item26'},
	{name:'Item27'},
	{name:'Item28'},
	{name:'Item29'},
	{name:'Item30'},
	{name:'Item31'},
	{name:'Item32'},
	{name:'Item33'},
	{name:'Item34'},
	{name:'Item35'},
	{name:'Item36'},
	{name:'Item37'},
	{name:'Item38'},
	{name:'Item39'},
	{name:'Item40'},
	{name:'Item41'},
	{name:'Item42'},
	{name:'Item43'},
	{name:'Item44'},
	{name:'Item45'},
	{name:'Item46'},
	{name:'Item47'}, 
	{name:'Item48'},
	{name:'Item49'},
	{name:'Item50'},
	{name:'User'},
	{name:'rw'},
	{name:'par'}
      ]);
    var count = grid.store.getCount(); 
    var r = new Plant({CareDate:getDate(statenddate),CareTime:statendtime}); 
    grid.store.commitChanges(); 
    grid.store.insert(count,r); 
   return;
}