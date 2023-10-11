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
var gramInAmount="Item10"; //0131 gram
var Timepoint24="07:00" //24h统计时间点
var Timepoint12="16:00" //日间小结时间点
var DHCPatOrdListT103=new Ext.data.JsonStore({data:[],fields:['OrdDate','OrdTime','ARCIMDesc','PriorDes','Meth','PHFreq','Dose','DoseUnit','OrdStat','Doctor','Oew','OrdSub','SeqNo','oeoriId','refed']});
var DHCNURXH_WATERT101=new Ext.data.JsonStore({data:[],fields:['Num','totelg','totelml','Food','Unit','Water','Comment','Type','GroupNodDes','rw']});
var DHCNURTEMRefT1=new Ext.data.JsonStore({data:[],fields:['RecDate','RecTime','Item1','Item7','Item4','Item5','Item6']});
var insertOrderData={}; // EH 右键引用医嘱存储标志
var success2CA=[];
var GetNurseRecSet=document.getElementById('GetNurseRecSet');
if (GetNurseRecSet){
	var ret=cspRunServerMethod(GetNurseRecSet.value,"DHCNURBG_WZHZ");
	var hh=ret.split("^");
	SumInName=hh[0].split("&")[0];
	SumInAmount=hh[0].split("&")[1];
	SumOutName=hh[1].split("&")[0];
	SumOutAmount=hh[1].split("&")[1];
	PartInName=hh[2].split("&")[0].split("!")[0];
	PartInAmount=hh[2].split("&")[1];
	PartOutName=hh[3].split("&")[0].split("!")[0];
	PartOutAmount=hh[3].split("&")[1];
	DisplaySumInName=hh[7].split("&")[0].split("!")[0];
	DisplaySumInAmount=hh[7].split("&")[1];
	DisplaySumOutName=hh[8].split("&")[0].split("!")[0];
	DisplaySumOutAmount=hh[8].split("&")[1];
    ICountCls=hh[9];
    OCountCls=hh[10];
    OrdInName=hh[11].split("&")[0];;
    OrdInAmount=hh[11].split("&")[1];;
	//debugger;
	//alert(OrdInName);
}
var UserType="";
var GetUserType=document.getElementById('GetUserType');
if (GetUserType){
	UserType=cspRunServerMethod(GetUserType.value,session['LOGON.USERID']);
}
var grid;
var DiagnosDr="";
var CurrHeadDr="";
var IEVersionFlag=IEVersion();
//获取IE浏览器版本
function IEVersion() {
	var userAgent = navigator.userAgent; //取得浏览器的userAgent字符串  
	var isIE = userAgent.indexOf("compatible") > -1 && userAgent.indexOf("MSIE") > -1; //判断是否IE<11浏览器  
	var isEdge = userAgent.indexOf("Edge") > -1 && !isIE; //判断是否IE的Edge浏览器  
	var isIE11 = userAgent.indexOf('Trident') > -1 && userAgent.indexOf("rv:11.0") > -1;
	if(isIE) {
		var reIE = new RegExp("MSIE (\\d+\\.\\d+);");
		reIE.test(userAgent);
		var fIEVersion = parseFloat(RegExp["$1"]);
		if(fIEVersion == 7) {
			return 7;
		} else if(fIEVersion == 8) {
			return 8;
		} else if(fIEVersion == 9) {
			return 9;
		} else if(fIEVersion == 10) {
			return 10;
		} else {
			return 6;//IE版本<=7
		}   
	} else if(isEdge) {
		return 'edge';//edge
	} else if(isIE11) {
		return 11; //IE11  
	}else{
		return -1;//不是ie浏览器
	}
}

function gethead()
{
	var GetCurrHeadDR=document.getElementById('GetCurrHeadDR');
	//alert(EmrCode);
	var ret=cspRunServerMethod(GetCurrHeadDR.value,EpisodeID,session['LOGON.USERID'],EmrCode);
	if (ret!="")
	{
		var dd=ret.split("||");
		CurrHeadDr=dd[0]+"_"+dd[1];
	} 
	
	var GetHead=document.getElementById('GetHead');
	var ret=cspRunServerMethod(GetHead.value,EpisodeID);
	var hh=ret.split("^");
	return hh[0]+"  "+hh[1];
	//debugger;
}
var PrnLoc=session['LOGON.CTLOCID']
function BodyLoadHandler(){
	setsize("mygridpl","gform","mygrid");
	
	//fm.doLayout(); 
	var but1=Ext.getCmp("mygridbut1");
	but1.on('click',additm);
	var but=Ext.getCmp("mygridbut2");
	but.setText("选行保存");
	//but.on('click',save);
	but.on('click',SaveCAOne);
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
	if(IEVersionFlag=="11")
	{
		var admdate=diffDateIE11(new Date(),0)
	}else{
		var admdate=diffDate(new Date(),0)
	}
  	var PatInfo=document.getElementById('GetPatInfo');
	if (PatInfo) {
		var ret=cspRunServerMethod(PatInfo.value,EpisodeID);
	 	var tt=ret.split('^');
		if (tt.length>1) {
		var datestr=(tt[14]).split("@");
		if (datestr.length>1) {admdate=datestr[1];}
		}
	}
  	var mydate=new Date();
  	var tobar=grid.getTopToolbar();
  	tobar.addButton(
	  {
		className: 'new-topic-button',
		text: "全部保存",
		//handler:saveAll,
	handler:saveAllCAMult,
		id:'mygridSch22'
	  }

	);
	if(IEVersionFlag=="11")
	{	
		tobar.addItem(
			{
				xtype:'datefield',
				format: 'Y-m-d',
				id:'mygridstdate',
				value:diffDateIE11(new Date(),0)
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
				value:diffDateIE11(new Date(),1)
			},
			{
				xtype:'timefield',
				width:100,
				id:'mygridendtime',
				format: 'H:i',
				value:'0:00'
			}
		);
	}else{
		tobar.addItem(
			{
				xtype:'datefield',
				format: 'Y-m-d',
				id:'mygridstdate',
				value:diffDate(new Date(),0)
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
	}
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
 	//tobar.addButton(
	//	  {
	//		//className: 'new-topic-button',
	//		text: "续打印设置",
	//		handler:PrintSet,
	//		id:'XPrintSet'
	//	  }
	//  );
	tobar.addItem ("-",{
			xtype:'checkbox',
			id:'showAllCases',
			checked:false,
			boxLabel:'全部' 		
	});
   	tobar.addItem ("-",{
			xtype:'checkbox',
			id:'IfCancelRec',
			checked:false,
			boxLabel:'显示作废记录' 		
	});
		tobar.addItem ("-",{
			xtype:'checkbox',
			id:'reversed',
			checked:true,
			boxLabel:'逆序' 		
	});
	//tobar.render(grid.tbar);
	tbar2=new Ext.Toolbar({	});				
   tbar2.addItem("-");            
   tbar2.addButton(
	 {
			text: "24h统计(07-07)",
			handler:findStat24,
			id:'mygridStat24'
		  }
	  );
	  tbar2.addItem("-");
	 tbar2.addButton(
		  {	
			text: "日间小结(07-16)",
			handler:findStatxj,
			id:'mygridStatxj'
		  }
	  );
	tbar2.addItem("-");
	 tbar2.addButton(
		{
			text: "按时间段统计",
			handler:findStattj,
			id:'mygridStat'
		});
		tbar2.addItem("-");
	 tbar2.addButton(
		{
			text: "出入量项目",
			handler:Selectwater,
			id:'mygridStat'
		});
		tbar2.addButton(
		{
			text: "护士长审核",
			handler:NurseAudit,
			id:'NurseAudit12'
		});
		tbar2.addButton(
		{
			text:'同步出入量到体征',
			handler:Grid_Insert2Temp,
			id:'Insert2Temp'

		});
		tbar2.addItem("-");
		tbar2.addButton(
	  {
		className: 'new-topic-button',
		text: "体温单明细数据",
		handler:PatDataDetail,
		id:'mygridtemdetail'
	  });
	tbar2.render(grid.tbar);
	tobar.doLayout(); 
	var obj=Ext.getCmp('NurseAudit12');
	if(session['LOGON.GROUPID']!="45") obj.hide();
 	if (UserType=="DOCTOR")
 	{
 		if (but1) but1.hide();
 		if (but) but.hide();
		var obj=Ext.getCmp('mygridSch22');
		if (obj) obj.hide();
		var obj=Ext.getCmp('mygridStat');
		if (obj) obj.hide();
 		var obj=Ext.getCmp("PrintBut");
 		if (obj) obj.hide();
  		var obj=Ext.getCmp("XPrintSet");
 		if (obj) obj.hide();
		var obj=Ext.getCmp('IfCancelRec');
		if (obj) obj.hide();
		var obj=Ext.getCmp('showAllCases');
		if (obj) obj.hide();
		grid.on('beforeedit',function(e) {e.cancel = true;});		
 	}
 	else
 	{
		grid.addListener('rowcontextmenu', rightClickFn);
		grid.addListener('rowclick', rowClickFn);
		grid.addListener('afteredit', AfterEditFn);
		grid.addListener('afteredit', AfterEditFn2);
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

//alert();
//debugger;
//insertord();
//find();
}
/*
function insertord()
{  				
  //var vtype="YZXCQSY"   
  var vtype="YTCRLD"   //执行单名	
  var StDate= Ext.getCmp("mygridstdate").value;
	var Enddate= Ext.getCmp("mygridenddate").value;
  var parr=PrnLoc+"^"+bedCode+"^"+EmrCode+"^"+session['LOGON.WARDID']+"^"+EpisodeID+"^"+session['LOGON.USERID']
  //alert(parr+"^"+StDate+"^"+Enddate+"^"+vtype+"^"+session['LOGON.CTLOCID'])
	var a=tkMakeServerCall("web.DHCNurseCount","InserOrderByTime",parr,StDate,Enddate,vtype,session['LOGON.CTLOCID'],"false","false","","","true","0","00:00","23:59")					
  //alert(a)
  //find()
  //alert("插入输液成功")
  
}
*/
//插入生命体征
function InsertPatObservations()
{  				
  //var vtype="YZXCQSY"   
  var vtype="YTCRLD"   //执行单名	
  var StDate= Ext.getCmp("mygridstdate").value;
	var Enddate= Ext.getCmp("mygridenddate").value;
  var parr=EpisodeID+"^"+StDate+"^"+Enddate;
  //alert(session['LOGON.USERID'])
  //alert(session['LOGON.GROUPDESC'])
	var a=tkMakeServerCall("Nur.DHCNurseRecSub","InsertPatObservations1",parr,session['LOGON.USERID'],"DHCNURBG_WZHZ",session['LOGON.GROUPDESC'])					
  //alert(a)
 
  
}

//选择食物表
var watergrid=""

function Selectwater()
{         
	// var CurrAdm=selections[rowIndex].get("Adm");
	//selections = grid.getSelectionModel().getSelections();
	var arr = new Array();
	var a = cspRunServerMethod(pdata1, "", "DHCNURXH_WATER", EpisodeID, "");
	arr = eval(a); //食物
	//alert(arr)
	//var arrord = new Array();
	//var a2 = cspRunServerMethod(pdata1, "", "DHCPatOrdList", EpisodeID, "");
	//arrord = eval(a2);
	if (typeof(arr[0].items)!="undefined") 
	{
	   arr[0].items[0].getBottomToolbar().hide();  //屏蔽底部栏
	}
  var window2 = new Ext.Window({
		title: '食物及出量',
		width: 850,
		height: 600,
		y:140,
		x:140,
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
	watergrid=Ext.getCmp("watergrid");
	var tobar=watergrid.getTopToolbar();
	//alert(tobar)
		fooddata = new Array();
	 cspRunServerMethod(getfoodlist,'addfood');
	//tobar.addItem('项目名称', foodField);
 
	tobar.addItem ("-",{
			xtype:'checkbox',
			id:'IItem',
			checked:false,
			boxLabel:'入量项' 		
	});
	tobar.addItem ("-",{
			xtype:'checkbox',
			id:'OItem',
			checked:true,
			boxLabel:'出量项' 		
	});
	tobar.addItem ("-",{
			xtype:'textfield',
			id:'fname',		
			width:'80',
			boxLabel:'食物名称' 		
	},"-");
	tobar.addButton(
	  {
		className: 'new-topic-button',
		text: "查询",
		id:'schfood'
	  });
	var butin=Ext.getCmp('watergridbut2');
	butin.hide();
	var butin=Ext.getCmp('watergridbut1');
	butin.text="确定";
	butin.hide()
	butin.on('click',SureInFood);
	var butschord=Ext.getCmp('schfood');
	butschord.on('click',schfood);
	var fname=Ext.getCmp('fname');	
	var IItem=Ext.getCmp('IItem');
	var OItem=Ext.getCmp('OItem');
	IItem.on('check',function(check)
	   {
	      var checkval=IItem.getValue(); //当前值	          
	      //alert(checkval)             
	      if (checkval==true)
	      {
	        OItem.setValue("false")
	        schfood()
	      }
	      else
	      {
	        OItem.setValue("true")
	        schfood()
	      }
	   }
	   );
	 OItem.on('check',function(check)
	   {
	      var checkval=OItem.getValue(); //当前值	          
	      //alert(checkval)             
	      if (checkval==true)
	      {
	        IItem.setValue("false")
	        schfood()
	      }
	      else
	      {
	        IItem.setValue("true")
	        schfood()
	      }
	   }
	   );
	watergrid.on('beforeedit', waterbeforeEditFn);
	watergrid.on('afteredit', waterafterEditFn);	
	var mydate=new Date();
 
	window2.show();
	schfood()
}

function addfood(a, b) {
	fooddata.push({
				id : a,
				desc : b
			});
}

function SureInFood()
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
 
 //查询食物
function schfood()
{	
  var	foodgrid=Ext.getCmp("watergrid");
  var	food=Ext.getCmp("fname")
  var foodname=food.getValue()
  //alert(food==undefined)
 
 // alert(foodname)
	var GetQueryData=document.getElementById('GetQueryData');
	foodarrgrid=new Array();
	var IItem=Ext.getCmp("IItem").getValue(); //入量项
	var OItem=Ext.getCmp("OItem").getValue(); //出量项
	var parr=foodname+"^"+session['LOGON.CTLOCID']+"^"+IItem+"^"+OItem+"^"+EpisodeID
	
	//alert(parr)
	var a = cspRunServerMethod(GetQueryData.value, "Nur.DHCNurWater:CRItem", "parr$"+parr, "AddFoodRec");
  //alert(a);
  //foodgrid.store.loadData(new Array())
  foodgrid.store.loadData(foodarrgrid);   
}

var select
function waterbeforeEditFn(e)
{   
   select=watergrid.getSelectionModel().getSelections()[0]
}
function waterafterEditFn(e)
{
		//alert(e.grid+","+e.record+","+e.field+","+e.value+","+e.originalValue+","+e.row+","+e.column);
		var errflag=0;
		var curfield=e.field;
		var curvalue=e.value;
		var rw=select.get("rw") //id
	//	alert(rw)
	//	alert(curfield)
		if ((curfield=="Num")&&(rw!=""))
		{		
		   
		   var unitml=select.get("Water") //单位水量
		   var unit=select.get("Unit") //单位重量
		   var totelml=unitml*curvalue		 
		   var totelg=unit*curvalue  
		   select.set("totelml",totelml)
		   select.set("totelg",totelg)
		   var foodname=select.get("Food")+"×"+curvalue //食物名称
		   var instr="CareDate|"+formatDate(new Date())+"^CareTime|"+new Date().dateFormat('H:i')+"^Item8|"+foodname+"^Item9|"+totelml+"^Item10|"+totelml
		   savewater(instr)
		   var rw=select.get("rw")
		   /// alert(isNaN(rw))
		   if (isNaN(rw)==false) 
		   {
		     var infreqstr="rw|"+rw+"^Loc|"+session['LOGON.CTLOCID']+"^Food|"+select.get("Food")
		     //alert(infreqstr)
		     savefoodfreq(infreqstr) //插入频次
		   }
		   find()
		   return
		}	
		if ((curfield=="totelg")&&(rw!=""))
		{	
			 var totelg=select.get("totelg")
			 var unit=select.get("Unit")
			 var unitml=select.get("Water")		
			 var nums=totelg/unit
		   var totelml=nums*unitml	
		   totelml=totelml.toFixed(1) 	   
		   select.set("totelml",totelml)
		   select.set("Num",nums)
		   var foodname=select.get("Food")+"×"+nums //食物名称
		   var instr="CareDate|"+formatDate(new Date())+"^CareTime|"+new Date().dateFormat('H:i')+"^Item8|"+foodname+"^Item9|"+totelml+"^Item10|"+totelml
		   savewater(instr)
		   var rw=select.get("rw")
		    if (isNaN(rw)==false) 
		   {
		     var infreqstr="rw|"+rw+"^Loc|"+session['LOGON.CTLOCID']+"^Food|"+select.get("Food")
		     savefoodfreq(infreqstr) //插入频次
		   }
		   find()
		   return
	  }		
	  if (curfield=="totelml")  //总水量
		{
		
		   var IItem=Ext.getCmp('IItem');
	     var OItem=Ext.getCmp('OItem');
	     if (rw!="") //已经维护项
	     {
	      if (IItem.getValue()==true)
	      {
			   var totelg=select.get("totelg")
			   var unit=select.get("Unit")
			   var unitml=select.get("Water")	
			   var totelml=select.get("totelml")		
			   var nums=totelml/unitml
			   nums=nums.toFixed(1)
			   //alert(nums)
		     var totelg=nums*unit	
		     totelg=totelg.toFixed(1)  
		     select.set("totelg",totelg)
		     select.set("Num",nums)
		     var foodname=select.get("Food")+"×"+nums //食物名称
		     var instr="CareDate|"+formatDate(new Date())+"^CareTime|"+new Date().dateFormat('H:i')+"^Item8|"+foodname+"^Item9|"+totelml+"^Item10|"+totelml
		     savewater(instr)
		     var rw=select.get("rw")
		     if (isNaN(rw)==false) 
		     {
		       var infreqstr="rw|"+rw+"^Loc|"+session['LOGON.CTLOCID']+"^Food|"+select.get("Food")
		       savefoodfreq(infreqstr) //插入频次
		     }
		     find()
		     return
		    }
		    if (OItem.getValue()==true) //插入出量项目
	      {
	       var totelml=select.get("totelml")	
	       var foodname=select.get("Food")
	       var instr="CareDate|"+formatDate(new Date())+"^CareTime|"+new Date().dateFormat('H:i')+"^Item11|"+foodname+"^Item12|"+totelml
		     savewater(instr)	
		     var rw=select.get("rw")
		     if (isNaN(rw)==false) 
		     {
		       var infreqstr="rw|"+rw+"^Loc|"+session['LOGON.CTLOCID']+"^Food|"+select.get("Food")
		       savefoodfreq(infreqstr) //插入频次
		     }
		     find()
		     return
	      }
	     
	     }
	     if (rw=="") //空白项
	     {
	        var foodname=select.get("Food")
	        var type=select.get("Type")
	        var totelml=curvalue
	        if (foodname!="")
	        {
	          if (type=="I")
	          {
	            var instr="CareDate|"+formatDate(new Date())+"^CareTime|"+new Date().dateFormat('H:i')+"^Item8|"+foodname+"^Item9|"+totelml+"^Item10|"+totelml
		          savewater(instr)	
		          find()
	          }
	          if (type=="O")
	          {
	             var instr="CareDate|"+formatDate(new Date())+"^CareTime|"+new Date().dateFormat('H:i')+"^Item11|"+foodname+"^Item12|"+totelml
		           savewater(instr)	
		           find()
	          }
	        }
	     }	  	         
	  }		
	   // alert(curfield)
	    if ((curfield=="Food")&&(rw==""))  //总水量
		  {
		      var foodname=curvalue
	        var type=select.get("Type")
	        var totelml=select.get("totelml")
	        //alert(totelml)
	        if (totelml!="")
	        {
	          if (type=="I")
	          {
	            var instr="CareDate|"+formatDate(new Date())+"^CareTime|"+new Date().dateFormat('H:i')+"^Item8|"+foodname+"^Item9|"+totelml+"^Item10|"+totelml
		          savewater(instr)
		          find()	
	          }
	          if (type=="O")
	          {
	             var instr="CareDate|"+formatDate(new Date())+"^CareTime|"+new Date().dateFormat('H:i')+"^Item11|"+foodname+"^Item12|"+totelml
		           savewater(instr)	
		           find()
	          }
	        }
		  }
}
//插入水量
function savewater(str)
{
	    //alert(str)
  	  var RecSave=document.getElementById('RecSave');			
			str=str+"^RecLoc|"+PrnLoc+"^RecBed|"+bedCode; //转科用
			var a=cspRunServerMethod(RecSave.value,EpisodeID,str,session['LOGON.USERID'],EmrCode,session['LOGON.GROUPDESC']);
			
}
//插食物频次
function savefoodfreq(str)
{		
	var a=tkMakeServerCall("Nur.DHCNurWaterSub","Save",str)
			
}

function AddFoodRec(str)
{
	var obj = eval('(' + str + ')');
	//alert(str)
	foodarrgrid.push(obj);
}
//是否插入食物或水果
function ifaddwater()
{
         Ext.Msg.show({    
	       title:'确认一下',    
	       msg: '是否是否填写食物或水果？',    
	       buttons:{"ok":"是     ","cancel":"  否"},
	       fn:  function(btn, text){    
	            if (btn == 'ok')
	            {   	
	               Selectwater()
	            }
					    else
	            {   
	              additm()
	            }	            
	        },    
	       animEl: 'newbutton'   
	       });

}
//按时间段
function findStattj()
{ 
  var adm=EpisodeID;
	var StDate= Ext.getCmp("mygridstdate").value;
	var StTime= Ext.getCmp("mygridsttime").value;
	var Enddate= Ext.getCmp("mygridenddate").value;
	var EndTime= Ext.getCmp("mygridendtime").value;
	var mygrid=Ext.getCmp("mygrid");
  //alert(adm+"|"+StDate+"|"+StTime+"|"+Enddate+"|"+EndTime+"|"+"DHCNURBG_WZHZ"+"|"+"Sum"+"|"+session['LOGON.USERID'])
 	var a=tkMakeServerCall("Nur.DHCNurPatSumInOut","SaveInOutAmountComm",adm,StDate,StTime,Enddate,EndTime,"DHCNURBG_WZHZ","Sum",session['LOGON.USERID']);
	if (a=="") { Ext.Msg.alert('提示', "无护理记录数据!"); return; }
	find();
}

//24h统计
function findStat24()
{ 
  InOrdSum()
  find()
}

function findStatxj()
{ 
  var adm=EpisodeID;
  if(IEVersionFlag=="11"){
	var StDate=diffDateIE11(new Date(),0)
  }else{
	var StDate=diffDate(new Date(),0)
  }
	var StTime= Timepoint24;
	if(IEVersionFlag=="11"){
		var Enddate= diffDateIE11(new Date(),0)
	}else{
		var Enddate= diffDate(new Date(),0)
	}
	var EndTime= Timepoint12;
	var mygrid=Ext.getCmp("mygrid");
  //alert(adm+"|"+StDate+"|"+StTime+"|"+Enddate+"|"+EndTime+"|"+"DHCNURBG_WZHZ"+"|"+"Sum"+"|"+session['LOGON.USERID'])
 	var a=tkMakeServerCall("Nur.DHCNurPatSumInOut","SaveInOutAmountComm",adm,StDate,StTime,Enddate,EndTime,"DHCNURBG_WZHZ","Day",session['LOGON.USERID']);
	if (a=="") { Ext.Msg.alert('提示', "无护理记录数据!"); return; }
	find();
}

function formatDateordnew(val,addday){
	var year=val.getYear();
	var mon=val.getMonth();
	var dat=val.getDate()+addday;
	var datt=new Date(year,mon,dat);
	return formatDateord(datt);
}

 function formatDateord(value){
  	try
	{
	   return value ? value.dateFormat('d/m/Y') : '';
	}
	catch(err)
	{
	   return '';
	}
 };

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
 	var a=cspRunServerMethod(GetNurPrnSet.value,"DHCNURBG_WZHZ",EpisodeID,'addprnset');
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
	if(IEVersionFlag=="11"){
		tobar.addItem(
			{
				xtype:'datefield',
				format: 'Y-m-d',
				id:lab+'stdate',
				value:(diffDateIE11(new Date(),-1))
			},
			{
				xtype:'datefield',
				format: 'Y-m-d',
				id:lab+'enddate',
				value:new Date()
			}
		);
	}else{
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
	}
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
	//var link="dhcnurtempature.csp?EpisodeID="+EpisodeID;
   /// window.open (link,'体温单','height=1,width=1,top=0,left=0,toolbar=no,menubar=no,scrollbars=no, resizable=no,location=no, status=no') 
   // window.close();
  // alert(parent.frames.length);
  //insertord();
  //InsertPatObservations();
  insertOrderData={}; // 清空缓存
  MeasureRel = new Hashtable();
  REC = new Array();
	var adm = EpisodeID;
	var StDate = Ext.getCmp("mygridstdate");
	var StTime = Ext.getCmp("mygridsttime");
	var Enddate = Ext.getCmp("mygridenddate");
	var EndTime = Ext.getCmp("mygridendtime");
	var GetQueryData = document.getElementById('GetQueryData');
	var mygrid = Ext.getCmp("mygrid");
	var IfCancelRec=Ext.getCmp("IfCancelRec").getValue();
	var showAllCases=Ext.getCmp("showAllCases").getValue();
	var reversed=Ext.getCmp("reversed");
	reversed=reversed?reversed.getValue():'';
	var parr = adm + "^" + StDate.value + "^" + StTime.value + "^" + Enddate.value + "^" + EndTime.value + "^"+"DHCNURBG_WZHZ" + "^" + IfCancelRec+"^"+CurrHeadDr+'^^^'+reversed;
	//if (showAllCases) {parr = parr + "^^false"}
	// debugger;
	var a = cspRunServerMethod(GetQueryData.value, "web.DHCNurHCRecComm:GetCareRecComm", "parr$" + parr, "AddRec");
	mygrid.store.loadData(REC);
}
function findStat()
{  //查询出入液量合计
    var adm=EpisodeID;
	var StDate= Ext.getCmp("mygridstdate");
	var StTime= Ext.getCmp("mygridsttime");
	var Enddate= Ext.getCmp("mygridenddate");
	var EndTime= Ext.getCmp("mygridendtime");
	var GeInOutAmount=document.getElementById('GeInOutAmount');
	var mygrid=Ext.getCmp("mygrid");
  //alert(adm+"|"+StDate.value+"|"+StTime.value+"|"+Enddate.value+"|"+EndTime.value+"|"+"DHCNURBG_WZHZ")
 	var a=cspRunServerMethod(GeInOutAmount.value,adm,StDate.value,StTime.value,Enddate.value,EndTime.value,"DHCNURBG_WZHZ");
	if (a=="") { Ext.Msg.alert('提示', "无护理记录数据!"); return; }
	//additm();
	additmstat(Enddate.value,EndTime.value);
	var tt=a.split('^');
	//alert(a);
	mygrid.getSelectionModel().selectRow(mygrid.store.getCount()-1);   
	for (i=0;i<tt.length;i++)
	{
		itm=tt[i].split('|');
		mygrid.getSelectionModel().getSelections()[0].set(itm[0],itm[1]); 
	}
	//alert(tt);

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
	//alert(str)
	var obj = eval('(' + str + ')');
	obj.CareDate=getDate(obj.CareDate);
	//obj.PregHPregDate=getDate(obj.PregHPregDate);
	REC.push(obj);
	//debugger;
}
function AddRecTem(str)
{
	//var a=new Object(eval(str));
	//alert(str)
	var obj = eval('(' + str + ')');
	//obj.PregHPregDate=getDate(obj.PregHPregDate);
	REC.push(obj);
	//debugger;
}


function setColors(record,rowIndex,rowParams,store)
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

function PreBlkCM(CM)//20121227 for two spaces prefixed
{
	var reg = / /g;
	var CMOut = CM.replace(reg,"");
	CMOut = " " + " " + " " + " " + CMOut;
	return CMOut;
}

function save()
{
	var failed=false;
	success2CA=[];
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
	//	for (var i = 0; i < store.getCount(); i++) {
		//	list.push(store.getAt(i).data);
			//	debugger;
	//	}
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
		var totalRow = list[i][DisplaySumInName]; //统计不保存
	  if ((totalRow) && (totalRow.indexOf("入液量") > -1)) {continue;}
	  var obj=list[i];
	  var str="";
	  var CareDate="";
	  var CareTime="";
	  var flag="0";
		for (var p in obj) {
			var aa = formatDate(obj[p]);	
			if (p=="CareDate") CareDate=aa;
			if (p=='CareTime') CareTime=obj[p];
			if (p=="CaseMeasure") {obj[p]=PreBlkCM(obj[p]);}//20121227 for two spaces prefixed
			if (p=="") continue;
			//alert(DisplaySumInName);
			//if ((p == DisplaySumInName) && (obj[p].indexOf("入液量") != -1)) {
		//		flag = "1";
		//	}
		//	if ((p==DisplaySumOutName)&&(obj[p].indexOf("出液量")!= -1))
		//	{
		//		flag="1";
		//	} 
		if ((p=="Item19")&&(parseInt(obj[p])<4))
			{
				alert("病情稳定请按护理级别巡视观察。");
			}
			if ((p=="Item19")&&(parseInt(obj[p])==4))
			{
				alert("病情可能恶化请报告、交接班、白板标识、建议提升护理级别，增加巡视观察次数。");
			}
			if ((p=="Item19")&&(parseInt(obj[p])<=7)&&(parseInt(obj[p])>=5))
			{
				alert("病情重、潜在危险大请建立静脉通路、高年资护士负责、制订护理计划、入住ICU。");
			}
			if ((p=="Item19")&&(parseInt(obj[p])>=8))
			{
				alert("病情危重至少2条静脉通路、24小时专人守护、急诊科就地救治。");
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
			str=str+"DiagnosDr|"+DiagnosDr+"^HeadDR|"+CurrHeadDr;
			str=str+"^RecLoc|"+session['LOGON.CTLOCID']+"^RecBed|"+bedCode+"^RecWard|"+curward; //每条记录关联科室床号
			str=str+"^"+CaseMeasureID;
			//alert(str);
			var a=cspRunServerMethod(RecSave.value,EpisodeID,str,session['LOGON.USERID'],"DHCNURBG_WZHZ",session['LOGON.GROUPDESC']);
			//if (a!="0")
			//{
			//	alert(a);
			//	return;
			//}
			if (a.indexOf('&')>-1)
			{
				var flags=a.split('&')
			  if (flags[0]!="0")
			  {
				 alert(a);
				 failed=true;
				 break;
				 //return;
			  }
			  else
			  {
			  		RecMainInfo=str;			  
			  		RecMainInfoId=flags[1]; //保存成功返回值
					success2CA.push({
						rec:rowObj[i],
						RecMainInfo:str,
						RecMainInfoId:flags[1] // 保存成功返回值
					});
			  }			 
			}
			else
			{
					alert(a);
					failed=true;
					break;
					//return
			}
		}
	}
	Grid_onSave();
	if(!failed){
	find();
	}
} 
function saveAll()
{
	var failed=false;
	success2CA=[];
	var store = grid.store;
	var rowCount = store.getCount(); //记录数
	var cm = grid.getColumnModel();
	var colCount = cm.getColumnCount();
	var list = [];
	//var rowObj = grid.getSelectionModel().getSelections();
	//	var len = rowObj.length;
	//	for (var r = 0;r < len; r++) {
	//	list.push(rowObj[r].data);
	//}		
		for (var i = 0; i < store.getCount(); i++) {
			list.push(store.getAt(i).data);
			//	debugger;
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
		var totalRow = list[i][DisplaySumInName]; //统计不保存
	  if ((totalRow) && (totalRow.indexOf("入液量") > -1)) {continue;}
	  var obj=list[i];
	  var str="";
	  var CareDate="";
	  var CareTime="";
	  var flag="0";
		for (var p in obj) {
			var aa = formatDate(obj[p]);				
			if (p=="CareDate") CareDate=aa;
			if (p=='CareTime') CareTime=obj[p];
			if (p=="CaseMeasure") {obj[p]=PreBlkCM(obj[p]);}//20121227 for two spaces prefixed
			if (p=="") continue;
			//alert(DisplaySumInName);
			//if ((p == DisplaySumInName) && (obj[p].indexOf("入液量") != -1)) {
		//		flag = "1";
		//	}
		//	if ((p==DisplaySumOutName)&&(obj[p].indexOf("出液量")!= -1))
		//	{
		//		flag="1";
		//	} 
		/*if ((p=="Item19")&&(parseInt(obj[p])<4))
			{
				alert("病情稳定请按护理级别巡视观察。");
			}
			if ((p=="Item19")&&(parseInt(obj[p])==4))
			{
				alert("病情可能恶化请报告、交接班、白板标识、建议提升护理级别，增加巡视观察次数。");
			}
			if ((p=="Item19")&&(parseInt(obj[p])<=7)&&(parseInt(obj[p])>=5))
			{
				alert("病情重、潜在危险大请建立静脉通路、高年资护士负责、制订护理计划、入住ICU。");
			}
			if ((p=="Item19")&&(parseInt(obj[p])>=8))
			{
				alert("病情危重至少2条静脉通路、24小时专人守护、急诊科就地救治。");
			}*/
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
			str=str+"DiagnosDr|"+DiagnosDr+"^HeadDR|"+CurrHeadDr;
			str=str+"^RecLoc|"+session['LOGON.CTLOCID']+"^RecBed|"+bedCode+"^RecWard|"+curward;
			str=str+"^"+CaseMeasureID;
			//alert(str);
			var a=cspRunServerMethod(RecSave.value,EpisodeID,str,session['LOGON.USERID'],"DHCNURBG_WZHZ",session['LOGON.GROUPDESC']);
			///if (a!="0")
			//{
			//	alert(a);
			//	return;
			//}
			if (a.indexOf('&')>-1)
			{
				var flags=a.split('&')
			  if (flags[0]!="0")
			  {
				 alert(a);
				 failed=true;
				 break;
				 //return;
			  }
			  else
			  {
			  		RecMainInfo=str;			  
			  		RecMainInfoId=flags[1]; //保存成功返回值
					success2CA.push({
						rec:store.getAt(i),
						RecMainInfo:str,
						RecMainInfoId:flags[1] // 保存成功返回值
					});
			  }			 
			}
			else
			{
					alert(a);
					failed=true;
					break;
					//return
			}
		}
	}
	Grid_onSave();
	if(!failed){
	find();
	}
} 
function Grid_onSave(){
	var store=Ext.getCmp('mygrid').store;
	for(var i=0;i<success2CA.length;i++){
		for(var j=0;j<store.getCount();j++){ // EH 保存引用入量标志
			if(store.getAt(j)==success2CA[i].rec){
				if(insertOrderData.hasOwnProperty(j)){
					var rw=success2CA[i].RecMainInfoId;
					var data=insertOrderData[j].data.join('^');
					var ret=tkMakeServerCall('web.DHCNUREMR','OrderExRefed',rw,data);
				}
				break;
			}
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
	var year=val.getYear();
	var mon=val.getMonth();
	var dat=val.getDate()+addday;
	var datt=new Date(year,mon,dat);
	return formatDate(datt);
}
function diffDateIE11(val,addday){
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
	{name:'CaseMeasure'},
	{name:'User'},
	{name:'rw'},
	{name:'par'}
      ]);
    var count = grid.store.getCount(); 
    var parr=EpisodeID+"^"+new Date().dateFormat('Y-m-d')+"^"+(new Date().dateFormat('H:i'));
    var PatObservations=document.getElementById('GetPatObservations');
	  
	  var ret=cspRunServerMethod(PatObservations.value,parr);	
	  //alert(ret)
	  /*if(ret!="")
	  {
	 	var tt=ret.split('^');
	 	
    var r = new Plant({CareDate:new Date(),CareTime:getValueByCode(tt[1]),Item2:tt[2],Item3:tt[5],Item4:tt[4],Item5:(tt[6]+"/"+tt[7])}); 
    }
    else
    	{
    		var r = new Plant({CareDate:new Date(),CareTime:new Date().dateFormat('H:i')}); 
    	}*/
    var r = new Plant({CareDate:new Date(),CareTime:new Date().dateFormat('H:i')});
    grid.store.commitChanges(); 
    //grid.store.insert(count,r); 
	grid.store.insert(0,r);
	return;
}
function NurseAudit()
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
	{name:'CaseMeasure'},
	{name:'User'},
	{name:'rw'},
	{name:'par'}
      ]);
    var count = grid.store.getCount(); 
    var parr=EpisodeID+"^"+new Date().dateFormat('Y-m-d')+"^"+(new Date().dateFormat('H:i'));
    var PatObservations=document.getElementById('GetPatObservations');
	  /*if(ret!="")
	  {
	 	var tt=ret.split('^');
	 	
    var r = new Plant({CareDate:new Date(),CareTime:getValueByCode(tt[1]),Item2:tt[2],Item3:tt[5],Item4:tt[4],Item5:(tt[6]+"/"+tt[7])}); 
    }
    else
    	{
    		var r = new Plant({CareDate:new Date(),CareTime:new Date().dateFormat('H:i')}); 
    	}*/
    var r = new Plant({CareDate:new Date(),CareTime:new Date().dateFormat('H:i')});
    var str="";
	  var ret=cspRunServerMethod(PatObservations.value,parr);	
	  var RecSave=document.getElementById('RecSave');
	  str=str+"CareDate|"+new Date().dateFormat('Y-m-d')+"^CareTime|"+new Date().dateFormat('H:i')+"^";
	  str=str+"DiagnosDr|"+"^HeadDR|"
		str=str+"DiagnosDr|"+"^HeadDR|"+"^Item16|"+session['LOGON.USERNAME'];
		str=str+"^RecLoc|"+session['LOGON.CTLOCID']+"^RecBed|"+bedCode+"^RecWard|"+curward; //每条记录关联科室床
		//alert(str);
		var a=cspRunServerMethod(RecSave.value,EpisodeID,str,session['LOGON.USERID'],"DHCNURBG_WZHZ",session['LOGON.GROUPDESC']);
    grid.store.commitChanges(); 
    grid.store.insert(count,r); 
	find();
}
function getValueByCode(tempStr)
{
	var retStr=tempStr;
	var strArr = tempStr.split("|");
	if (strArr.length>1) 
	{
		retStr=strArr[1];
	}
	return retStr;
}
var rightClick = new Ext.menu.Menu(  {
            id : 'rightClickCont',
            items : [  {
                id:'rMenu1',
                text : '医嘱',
                handler:OrdSch
            },  
            /*{
                id:'rMenu2',
                text : '病情措施及处理',
                handler:Measure
            }, */ 
            {
                id:'rMenu2',
                text : '病情措施及处理',
                handler:MeasureNew
            },  
            {
                id:'rMenu4',
                text : '插入出入液量小结',
                handler:InOutNod
            },  {
                id:'rMenu5',
                text : '插入24小时出入液量',
                handler:InOutSum
            }, {
                id:'rMenu6',
                text : '出入量项目',
                handler:Selectwater
            }, {
                id:'rMenu8',
                text : '体征',
                handler:TemSch
            },  {
                id:'rMenu7',
                text : '作废',
                handler:CancelRecord
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
function MultiFun()
{
	var GetMulti=document.getElementById('GetMulti');
	var getcheckform=document.getElementById('getcheckform');	
	var ret= cspRunServerMethod(GetMulti.value, "DHCNURBG_WZHZ");
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
	var tabstr=cspRunServerMethod(getcheckform.value, "DHCNURBG_WZHZ",ab);
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
	//alert(checkret);

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
		//alert(itname+"!!"+code)
		var ret=cspRunServerMethod(getcheckform.value, "DHCNURBG_WZHZ",itname,code,"");	
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
   
function MeasureNew()
{
   
	MeasureRel = new Hashtable();
	var grid1=Ext.getCmp('mygrid');
	var objRow=grid1.getSelectionModel().getSelections();
	if (objRow.length == 0) { Ext.Msg.alert('提示', "请先选择一条护理记录!"); return; }
	var par=grid1.getSelectionModel().getSelections()[0].get("par"); 
	var rw=grid1.getSelectionModel().getSelections()[0].get("rw"); 
	var rowid=par+"||"+rw;
	if (par==undefined)
	{
		rowid="";
	}
	var parr="DHCNURBG_WZHZ^"+EpisodeID+"^CaseMeasureXml^"+rowid;
  var arr = new Array();
	var a = cspRunServerMethod(pdata1, "", "DHCNURMeasure", EpisodeID, "");
	arr = eval(a);
  var emrknowurl="dhcnuremrknow.csp?EmrCode=DHCNurKnowldge&Parr="+parr+"&EpisodeID="+EpisodeID;                  
  var south_item = new Ext.Panel({   
                region: 'south',                
                split: false,   
               	border: false,   
               	// collapsible: true,   
         		    autoScroll: false,
                layout: 'absolute',   
                minSize: 100,  
				        height:570, //内层高度（600-30）预留30的高度给确定按钮
  				      frame:true,
                //items: arr 
				        buttons: [ {
						      text: '确定',						     
						      handler: function(){							
							    sureMeasure();
						      }
					        }, {
						      text: '取消',
						      handler: function(){
							    window.close();
						      }
					       }],
				        html: '<iframe id ="southTab" name="ddd" style="width:100%; height:120%" src='+emrknowurl+' ></iframe>'                
                 });   
	var window = new Ext.Window({ 
		title: '病情措施及处理',
		width: 900,  //宽度
		modal:true,
		height: 600,  //高度
		id:'CaseForm',
		autoScroll: false,
		layout: 'absolute',
		plain: true,
		frame:true,
		items: south_item   
	});
	var mygrid=Ext.getCmp("mygrid");
	var rowObj = mygrid.getSelectionModel().getSelections();
	var len = rowObj.length;
	if (len < 1)
	{
		Ext.Msg.show({title:'注意',msg:'请选择一条数据!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
		return;
	}
  window.show();
}
function Measure1()
{
  selections = grid.getSelectionModel().getSelections();
 	var arr = new Array();
	var a = cspRunServerMethod(pdata1, "", "DHCNURMeasure", EpisodeID, "");
	alert(a)
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
		str=str+"^DiagnosDr|"+DiagnosDr+"^HeadDR|"+CurrHeadDr;
		//alert(str);
		var a=cspRunServerMethod(SaveOutIn.value,EpisodeID,str,session['LOGON.USERID'],"DHCNURBG_WZHZ");
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
	  //var InPart=objRow[0].get(PartInAmount);
	  //var OutPart=objRow[0].get(PartOutAmount);
	  var InPart="";
	  var OutPart="";
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
		str=str+"^DiagnosDr|"+DiagnosDr+"^HeadDR|"+CurrHeadDr;
		//alert(str);
		var a=cspRunServerMethod(SaveOutIn.value,EpisodeID,str,session['LOGON.USERID'],"DHCNURBG_WZHZ");
		find();
 }
}

function InOrdSum()
{
	var adm=EpisodeID;
	if(IEVersionFlag=="11")
	{
		var StDate=diffDateIE11(new Date(),-1)	
	}else{
		var StDate=diffDate(new Date(),-1)	
	}
	var StTime= Timepoint24;
	if(IEVersionFlag=="11")
	{
		var Enddate= diffDateIE11(new Date(),0)
	}else{
		var Enddate= diffDate(new Date(),0)
	}
	var EndTime=Timepoint24;   //Ext.getCmp("mygridendtime");
	var GeInOutAmount=document.getElementById('GeInOutAmount');
	var mygrid=Ext.getCmp("mygrid");
  //alert(adm+"|"+StDate+"|"+StTime+"|"+Enddate+"|"+EndTime+"|"+"DHCNURBG_WZHZ"+"|"+"Sum"+"|"+session['LOGON.USERID'])
 	var a=tkMakeServerCall("Nur.DHCNurPatSumInOut","SaveInOutAmountComm",adm,StDate,StTime,Enddate,EndTime,"DHCNURBG_WZHZ","Sum",session['LOGON.USERID']);
	if (a=="") { Ext.Msg.alert('提示', "无护理记录数据!"); return; }

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
	var colModel=grid1.getColumnModel();
	var cms=colModel.columns;
	if(cms){
		var num=cms.length;
		for(var i=0;i<num;i++){
			if(cms[i].dataIndex=='ARCIMDesc'){
					cms[i].renderer=function(a,b,c,d,f,g){
					if(c.get('refed')>0){
						b.attr="style='background-color:"+"lightgreen"+";'";
					}
					return a;
				}
			}
		}
	}
	tobar=grid1.getTopToolbar();
	if(IEVersionFlag=="11")
	{
		tobar.addItem(
			{
				xtype:'datefield',
				format: 'Y-m-d',
				id:'ordgridstdate',
				value:(diffDateIE11(new Date(),-1))
			},
			{
				xtype:'datefield',
				format: 'Y-m-d',
				id:'ordgridenddate',
				value:new Date()
			}
		);
	}else{
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
	}
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
	SchOrd();
}
function TemSch()
{         
	// var CurrAdm=selections[rowIndex].get("Adm");
	selections = grid.getSelectionModel().getSelections();
	var arr = new Array();
	var a = cspRunServerMethod(pdata1, "", "DHCNURTEMRef", EpisodeID, "");
	arr = eval(a);
	var window = new Ext.Window({
		id:'temgridwin',
		title: '体征',
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

	var	grid1=Ext.getCmp("temgrid");
	tobar=grid1.getTopToolbar();
	if(IEVersionFlag=="11")
	{
		tobar.addItem(
			{
				xtype:'datefield',
				format: 'Y-m-d',
				id:'temgridstdate',
				value:(diffDateIE11(new Date(),-1))
			},
			{
				xtype:'datefield',
				format: 'Y-m-d',
				id:'temgridenddate',
				value:new Date()
			}
		);
	}else{
		tobar.addItem(
			{
				xtype:'datefield',
				format: 'Y-m-d',
				id:'temgridstdate',
				value:(diffDate(new Date(),-1))
			},
			{
				xtype:'datefield',
				format: 'Y-m-d',
				id:'temgridenddate',
				value:new Date()
			}
		);		
	}
	tobar.addButton(
	  {
		className: 'new-topic-button',
		text: "查询",
		//handler:find,
		id:'temgridSch'
	  }

	);

	var butin=Ext.getCmp('temgridbut2');
	butin.hide();
	var butin=Ext.getCmp('temgridbut1');
	butin.text="确定";
	//debugger;
	butin.on('click',SureTem);
	grid1.on('rowdblclick',SureTem);
	var butschord=Ext.getCmp('temgridSch');
	butschord.on('click',SchTem);
	window.show();
	SchTem();
}
var condata=new Array();
function add(a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q)
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
		SeqNo: o,
		oeoriId:p,
		refed:q
	});
}
//0131EASTER
function toNumericStr(inStr)
{
	var outStr = "";
	var reg = /\d/;
	var accuracy = 8;
	var firstNZ = false;
	inStr = inStr.toString();
	for (var i = 0; i < inStr.length; i++) {
		var subStr = inStr.charAt(i);
		if ((reg.test(subStr)) || (subStr == ".")) {
			if ((firstNZ == false) && (subStr != "0")) firstNZ = true;
			if (firstNZ == true) outStr = outStr + subStr;
		}
	}
	if (outStr.charAt(0) == ".") outStr = "0" + outStr;
	if (outStr.charAt(1) != ".") return outStr;
	outStr = outStr.substr(0,accuracy);
	for (var i = outStr.length - 1; i > -1; i--) {
		if (outStr.charAt(i) != "0") break;
	}
	outStr = outStr.substr(0,i + 1);
	return outStr;
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
	var isInList=[];
    var selModel = grid.getSelectionModel();
	var rowObj = selModel.getSelections();
	//var len = rowObj.length;
	var len = grid.store.getCount();
	for(var r = 0; r < len; r++) {
		isInList[r] = false;
	}	
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
					var arr3=[]; // EH
					var mg=0,ml=0;
					var tempml=item.data.Dose;
					var unit=item.data.DoseUnit;
					if (unit.toUpperCase()=="ML") ml=eval(ml)+eval(tempml);
					if (unit.toUpperCase()=="G") mg=eval(mg)+eval(tempml);
					else if (unit.toUpperCase()=="MG") mg=eval(mg)+eval(tempml/(1000.0));
					var seqno=item.data.SeqNo;
					var orddate=item.data.OrdDate;
					var ordtime=item.data.OrdTime;
					var rowIndex = grid.store.indexOf(item);
					arr3.push(item.get('oeoriId'));
					caredate=item.get('OrdDate');
					caretime=item.get('OrdTime');
					/*for (var i = rowIndex-1; i >=0; i--) {
						var subdes=store.getAt(i).data.ARCIMDesc;
						subdes=subdes.replace("_____","");
						var submg=0,subml=0;
						var tempsubml=store.getAt(i).data.Dose;
						var subunit=store.getAt(i).data.DoseUnit;
						if (unit.toUpperCase()=="ML") subml=subml+tempsubml;;
						if (subunit.toUpperCase()=="G") submg=submg+tempsubml;
						else if (subunit.toUpperCase()=="MG") submg=submg+tempsubml/(1000.0);
						var subseqno=store.getAt(i).data.SeqNo;
						if (subseqno==seqno)
						{
							des=subdes+"+"+des;
							ml=ml+subml;
							mg=mg+submg;
						}
						else
						{
							break;	
						}
					}
					
					for (var i = rowIndex+1; i < store.getCount(); i++) {
						var subdes=store.getAt(i).data.ARCIMDesc;
						subdes=subdes.replace("_____","");
						var submg=0,subml=0;
						var tempsubml=store.getAt(i).data.Dose;
						var subunit=store.getAt(i).data.DoseUnit;
						if (unit.toUpperCase()=="ML") subml=subml+tempsubml;
						if (subunit.toUpperCase()=="G") submg=submg+tempsubml;
						else if (subunit.toUpperCase()=="MG") submg=submg+tempsubml/(1000.0);
						var subseqno=store.getAt(i).data.SeqNo;
						if (subseqno==seqno)
						{
							des=des+"+"+subdes;
							ml=ml+subml;
							mg=mg+submg;
						}
						else
						{
							break;	
						}
					}*/
					//20130131EASTER
					for (var i = 0; i < store.getCount(); i++) {
						if (i==rowIndex) continue;
						var subseqno=store.getAt(i).data.SeqNo;
						if (subseqno!=seqno) continue;
						var suborddate=store.getAt(i).data.OrdDate;
						if(suborddate!=orddate) continue;
						var subordtime=store.getAt(i).data.OrdTime;
						if(subordtime!=ordtime) continue;
						var subdes=store.getAt(i).data.ARCIMDesc;
						subdes=subdes.replace("_____","");
						if(subdes==des) continue;
						//alert(subdes)
						var submg=0,subml=0;
						var tempsubml=store.getAt(i).data.Dose;
						var subunit=store.getAt(i).data.DoseUnit;
						if (subunit.toUpperCase()=="ML") subml=eval(subml)+eval(tempsubml);
						if (subunit.toUpperCase()=="G") submg=eval(submg)+eval(tempsubml);
						else if (subunit.toUpperCase()=="MG") submg=eval(submg)+eval(tempsubml/(1000.0));
						//if (i<rowIndex) {des=subdes+"+"+des; isInList[num-1]=true;}
						if (i<rowIndex) {des=subdes+"+"+des; isInList[i]=true;}
						else {
							des=des+"+"+subdes; 
							//isInList[num+1]=true;
							isInList[i]=true;
							}
						if ((eval(submg)==0)&&(eval(subml)==0)) continue;
						//if (1) alert(eval(20)/(1000.0)+eval(100)/(1000.0))
						ml=eval(ml)+eval(subml);
						mg=eval(mg)+eval(submg);
						arr3.push(store.getAt(i).get('oeoriId'));
					}
					//if (isInList[num] == false){
					if (isInList[rowIndex] == false){
					var rec=null; // EH 引用医嘱
					if (num == 0) {
						//caredate=mygrid.getStore().getAt(0).get("CareDate");
						//caretime=mygrid.getStore().getAt(0).get("CareTime");
						var objRow=mygrid.getSelectionModel().getSelections();
						if (objRow.length == 0) { Ext.Msg.alert('提示', "请先选择某行!"); return; }
						else
						{
							objRow[0].set("CareDate", caredate);
							objRow[0].set("CareTime", caretime);
								objRow[0].set(OrdInName, des);									
								objRow[0].set(OrdInAmount, ((ml==0)?"":toNumericStr(ml)));
								objRow[0].set(gramInAmount, ((mg==0)?"":toNumericStr(mg)));
								rec=objRow[0];
						}
					}else{
						additm();
						mygrid.getSelectionModel().selectRow(mygrid.store.getCount()-1);   
						var objRow=mygrid.getSelectionModel().getSelections();
						objRow[0].set("CareDate", caredate);
						objRow[0].set("CareTime", caretime);
						objRow[0].set(OrdInName, des);
						objRow[0].set(OrdInAmount, ((ml==0)?"":toNumericStr(ml)));
						objRow[0].set(gramInAmount, ((mg==0)?"":toNumericStr(mg)));
						rec=objRow[0];
					}
					if((rec!=null)&&(arr3.length>0)){
						add2OrderRef(rec,arr3)
					}
					//isInList[num]=true;
					isInList[rowIndex]=true;
					}
					num++;
				});   
     }
 }
 function add2OrderRef(rec,arr3){
	for(var i=0;i<grid.store.getCount();i++){ /// 缓存选中医嘱
		if(grid.store.getAt(i)==rec){
			var par=rec.get('par');
			var rw=rec.get('rw');
			var added=false;
			if((par)&&(rw)){
				if(insertOrderData.hasOwnProperty(i)){
					if(insertOrderData[i].rw==''){
						insertOrderData[i].rw=par+'||'+rw;
					}
					if(insertOrderData[i].rw==(par+'||'+rw)){
						var data=insertOrderData[i].data;
						for(var k=0;k<arr3.length;k++){
							if(data.indexOf(arr3[k])==-1){
								data.push(arr3[k]);
							}
						}
						added=true;
					}
				}
				if(!added){
					insertOrderData[i]={};
					insertOrderData[i].rw=par+'||'+rw;
					insertOrderData[i].data=arr3;
				}
			}
			if(!added){
				insertOrderData[i]={};
				insertOrderData[i].rw='';
				insertOrderData[i].data=arr3;
			}
			break;
		}
	}
}
function PatDataDetail()
{         
	
	var lnk= "DHCNurEmrComm.csp?"+"&EmrCode=DHCNURTEMDETAIL"+"&EpisodeID="+EpisodeID;
	window.open(lnk,"htm33",'toolbar=no,location=no,directories=no,resizable=yes,width=900,height=600,left=50,top=90');
}
function Grid_Insert2Temp(){ /// 导入到体征
	var data=[ // 对照关系：出入量名称,体征字段,出入量类型
		['呕吐','Item30','O'],
		['尿','Item9','O'],
		['引流','Item28','O'],
		['痰液','Item29','O'],
		['总入量','Item23','I'],
		['总出量','Item14','O']
	];
	var parr='';
	for(var i=0;i<data.length;i++){
		parr+=(i>0)?'^':'';
		parr+=data[i][0]+'|'+data[i][1];
		if(data[i][2]!=undefined){
			parr+='|'+data[i][2];
		}
	}
	var ret=tkMakeServerCall('Nur.DHCNurPatSumInOut','beforeInsert2Temp',EpisodeID,parr,session['LOGON.USERID'],EmrCode);
	var arr=ret.split('&')
	var sucess=arr[0];
	var value=arr[1];
	if(parseInt(sucess)<0){
		alert(value);
		return false;
	}else if(sucess=='0'){
		ret=tkMakeServerCall('Nur.DHCNurPatSumInOut','Insert2Temp',EpisodeID,value,session['LOGON.USERID'],EmrCode);
		if(ret=='0'){
			alert('操作成功！');
			return true;
		}
	}else if(sucess=='1'){
		if(!window.confirm('是否覆盖现有记录？')){
			return false;
		}
		ret=tkMakeServerCall('Nur.DHCNurPatSumInOut','Insert2Temp',EpisodeID,value,session['LOGON.USERID'],EmrCode);
		if(ret=='0'){
			alert('操作成功！');
			return true;
		}
	}
	alert('操作失败！');
	return false;
}
 function GetofRecf(rec,f){
	 var val=rec.get(f);
	 if(val==undefined){
		 return '';
	 }
	 return val;
 }
 function SureTem()
 {
	var grid = Ext.getCmp('temgrid');
	var mygrid=Ext.getCmp('mygrid');
	var store = grid.store;
	var rowCount = store.getCount(); //记录数
	/*var cm = grid.getColumnModel();
	var colCount = cm.getColumnCount(); //列数
	var view = grid.getView();*/

    var selModel = grid.getSelectionModel();
	var mySelModel=mygrid.getSelectionModel();
    if (selModel.hasSelection()) {
		var rec=selModel.getSelections()[0];
		var tem=GetofRecf(rec,'Item1');
		var pulse=GetofRecf(rec,'Item7');
		var breath=GetofRecf(rec,'Item4');
		var lbp=GetofRecf(rec,'Item5');
		var rbp=GetofRecf(rec,'Item6');
		var bp='';
		if(lbp&&rbp){
			bp=lbp.toString()+'/'+rbp.toString();
		}
		if (mySelModel.hasSelection()) {
			var row=mySelModel.getSelections()[0];
			var previous=GetofRecf(row,'Item2').toString();
			previous+=GetofRecf(row,'Item3').toString();
			previous+=GetofRecf(row,'Item4').toString();
			previous+=GetofRecf(row,'Item5').toString();
			if(previous!=''){
				if(!window.confirm('是否替换之前的数据？')){
					return;
				}
			}
			row.set('Item2',tem);
			row.set('Item3',pulse);
			row.set('Item4',breath);
			row.set('Item5',bp);
			Ext.getCmp('temgridwin').close();
		}
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
     var objRow=grid1.getSelectionModel().getSelections();
	if (objRow.length == 0) { Ext.Msg.alert('提示', "请先选择一条护理记录!"); return; }
	var par=grid1.getSelectionModel().getSelections()[0].get("par"); 
	var rw=grid1.getSelectionModel().getSelections()[0].get("rw"); 
   // debugger;
	var rowid=par+"||"+rw;
	if (par==undefined)
	{
		rowid="";
	}
	var parr="DHCNURBG_WZHZ^"+EpisodeID+"^CaseMeasureXml^"+rowid;
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
   // var parr="DHCNURBG_WZHZ^"+EpisodeID+"^CaseMeasureXml";
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
	var GetQueryData=document.getElementById('GetQueryData1');
	var ordgrid=Ext.getCmp("ordgrid");
	var parr=adm+"^"+StDate.value+"^"+Enddate.value;
 	var a=cspRunServerMethod(GetQueryData.value,"web.DHCNUREMR:GetPatOrd","parr$"+parr,"add");
	// grid.width=document.body.offsetWidth;
	ordgrid.store.loadData(condata);
}
function SchTem()
{
	REC=new Array();
	var adm=EpisodeID;
	var StDate= Ext.getCmp("temgridstdate");
	var Enddate= Ext.getCmp("temgridenddate");
	var GetQueryData=document.getElementById('GetQueryData');
	var temgrid=Ext.getCmp("temgrid");
	var parr=adm+"^"+StDate.value+"^"+Enddate.value;
 	var a=cspRunServerMethod(GetQueryData.value,"web.DHCThreeNew:GetPatTempData","parr$"+parr,"AddRecTem");
	// grid.width=document.body.offsetWidth;
	temgrid.store.loadData(REC);
}
function Schlab()
{
	condata=new Array();
	var adm=EpisodeID;
	var StDate= Ext.getCmp("LabGridstdate");
	var Enddate= Ext.getCmp("LabGridenddate");
	var GetQueryData=document.getElementById('GetQueryData1');
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
	//alert(GetQueryData);
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
		var a=cspRunServerMethod(GetPrnSet.value,"DHCNURBG_WZHZ",EpisodeID); //page, caredattim, prnpos, adm,Typ,user
		if (a=="") return;
		var GetLableRec=document.getElementById('GetLableRec');
		var LabHead=cspRunServerMethod(GetLableRec.value,"DHCNURBG_WZHZ^"+session['LOGON.CTLOCID']+"^"+EpisodeID+"^"+session['LOGON.USERID']);
		//alert("DHCNURBG_WZHZ^"+session['LOGON.CTLOCID']+"^"+EpisodeID+"^"+session['LOGON.USERID'])
		var tm=a.split("^");
		//alert(tm)
		var stdate=""; //tm[2];
		var stim=""; //tm[3];
		var edate=""; //tm[4];
		var etim=""; //tm[5];
		//PrintComm.RHeadCaption=hh[1];
		//PrintComm.LHeadCaption=hh[0];
		//PrintComm.RFootCaption="第";
		//PrintComm.LFootCaption="页";
		//PrintComm.LFootCaption=hh[2];
		//alert(ret);
		PrintComm.TitleStr=ret;
		PrintComm.SetPreView("1");
		PrintComm.PrnLoc=session['LOGON.CTLOCID'];
		PrintComm.PrnBed=bedCode ;//转科关联为空打印当前床号
		PrintComm.qmwildth="50"
		PrintComm.qmheight="16"
		PrintComm.WebUrl=WebIp+"/dthealth/web/DWR.DoctorRound.cls";
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
		PrintComm.ItmName = "DHCNurPrnMouldqy_wz"; //338155!2010-07-13!0:00!!
		//debugger;
		var parr=EpisodeID+"!"+stdate+"!"+stim+"!"+edate+"!"+etim+"!DHCNURBG_WZHZ!"+CurrHeadDr+"!"+session['LOGON.CTLOCID'];
	  //alert(1)
		//alert(parr);
	
		PrintComm.ID = "";
		PrintComm.MultID = "";
		//PrintComm.MthArr="web.DHCConsult:getConsultInfo&id:"+myid;
		if(LabHead!="")PrintComm.LabHead=LabHead;
		PrintComm.SetParrm(parr); // ="EpisodeId" ; //"p1:0^p2:"
		PrintComm.dxflag=1;
		PrintComm.PrintOut();
		var SavePrnSet=document.getElementById('SavePrnSet');
		//debugger;
		var CareDateTim=PrintComm.CareDateTim;
		if (CareDateTim=="") return ;
		var pages=PrintComm.pages;
		var stRow=PrintComm.stRow;
		//debugger;
		var stprintpos=PrintComm.stPrintPos;
		//alert(pages+","+CareDateTim+","+stprintpos+","+EpisodeID+","+"DHCNURBG_WZHZ"+","+session['LOGON.USERID']+","+PrintComm.PrnFlag);
		//PrnFlag==1说明是打印预览
		if (PrintComm.PrnFlag==1) return;
		//如果原记录保存打印到第8页则当打印第8页之前页时不保存打印记录
		if (pages<aa[0]) return;
		var a=cspRunServerMethod(SavePrnSet.value,pages,CareDateTim,stprintpos,EpisodeID,"DHCNURBG_WZHZ",session['LOGON.USERID']); //page, caredattim, prnpos, adm,Typ,user
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
function UpdateRelDiagnos()
{
	var arr = new Array();
	var a = cspRunServerMethod(pdata1, "", "DHCNurRelDiagnos", EpisodeID, "");
	arr = eval(a);
	var window = new Ext.Window({
		title: '关联诊断记录',
		width: 615,
		height: 235,
		autoScroll: true,
		layout: 'absolute',
		plain: true,
		frame:true,
		//modal: true,
		//bodyStyle: 'padding:5px;',
		///buttonAlign: 'center',
		items: arr
	});
	var butin=Ext.getCmp('diaggridbut1');
	butin.text="确定";
	butin.on('click',UpdateDiagnos);
	var but2=Ext.getCmp('diaggridbut2');
	but2.text="插入小结";
	but2.on('click',UpdateDiagnos1);
	var diaggrid = Ext.getCmp('diaggrid');
	var diagtobar=diaggrid.getTopToolbar();
	diagtobar.addButton({
		className: 'new-topic-button',
		text: "插入24小时",
		handler:UpdateDiagnos2,
		id:'diaggridbut3'
  	});
	//debugger;
	var objRow=grid.getSelectionModel().getSelections();
	if (objRow.length > 0) {
		var inname = objRow[0].get(DisplaySumInName);
		var outname = objRow[0].get(DisplaySumOutName);
		if ((inname)&&(outname)&&((inname.indexOf("入液量") != -1) || (outname.indexOf("出液量") != -1))) {
			butin.hide();
		}
		else {
			but2.hide();
			var but3 = Ext.getCmp('diaggridbut3');
			but3.hide();
		}
	}
	SchDiag();
	window.show();
}
function UpdateDiagnos()
{
	var diaggrid=Ext.getCmp("diaggrid");
	var objDiagnosRow=diaggrid.getSelectionModel().getSelections();
	if (objDiagnosRow.length == 0) { Ext.Msg.alert('提示', "请先选择一条诊断记录!"); return; }
	var objRow=grid.getSelectionModel().getSelections();
	if (objRow.length == 0) { Ext.Msg.alert('提示', "请先选择一条护理记录!"); return; }
	else
	{
		save();
	}
}
function UpdateDiagnos1()
{
	var diaggrid=Ext.getCmp("diaggrid");
	var objDiagnosRow=diaggrid.getSelectionModel().getSelections();
	if (objDiagnosRow.length == 0) { Ext.Msg.alert('提示', "请先选择一条诊断记录!"); return; }
	var objRow=grid.getSelectionModel().getSelections();
	if (objRow.length == 0) { Ext.Msg.alert('提示', "请先选择一条统计记录!"); return; }
	else
	{
		InOutNod();
	}
}
function UpdateDiagnos2()
{
	var diaggrid=Ext.getCmp("diaggrid");
	var objDiagnosRow=diaggrid.getSelectionModel().getSelections();
	if (objDiagnosRow.length == 0) { Ext.Msg.alert('提示', "请先选择一条诊断记录!"); return; }
	var objRow=grid.getSelectionModel().getSelections();
	if (objRow.length == 0) { Ext.Msg.alert('提示', "请先选择一条统计记录!"); return; }
	else
	{
		InOutSum();
	}
}
function SchDiag()
{
	condata=new Array();
	var adm=EpisodeID;
	//var GetQueryData=document.getElementById('GetQueryDatal');
		var GetQueryData=document.getElementById('GetQueryData1');
	//alert(GetQueryData);
	var diaggrid=Ext.getCmp("diaggrid");
	//alert(adm);
 	var a=cspRunServerMethod(GetQueryData.value,"web.DHCNurseRecordComm:GetCopyDiagnos","parr$"+adm,"AddDiag");
  	diaggrid.store.loadData(condata);   
}
function AddDiag(a1,a2,a3,a4,a5)
{
	condata.push({
		DiagNos:a1,
		RecUser:a2,
		RecDate:a3,
		RecTime:a4,
		rw:a5
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
function CancelRecord()
{
	var objCancelRecord=document.getElementById('CancelRecord');
	var objRow=grid.getSelectionModel().getSelections();
	if (objRow.length == 0) { Ext.Msg.alert('提示', "请先选择一条护理记录!"); return; }
	if (!(parseInt(objRow[0].get("rw")) > 0)) { Ext.Msg.alert('提示', "该记录还未保存!"); return; }
	else
	{
		Ext.Msg.show({    
	       title:'再确认一下',    
	       msg: '你确定要作废此条护理记录吗?',    
	       buttons:{"ok":"确定","cancel":"取消"},
	       fn:  function(btn, text){    
	            if (btn == 'ok'){    
					var par=objRow[0].get("par");
					var rw=objRow[0].get("rw");
					//alert(par+","+rw+","+session['LOGON.USERID']+","+session['LOGON.GROUPDESC']);
					if (objCancelRecord) {
						var a = cspRunServerMethod(objCancelRecord.value, par, rw, session['LOGON.USERID'], session['LOGON.GROUPDESC']);
						if (a!=0){
							alert(a);
							return;
						}else{
							find();
						}
					}
	            }    
	        },    
	       animEl: 'newbutton'   
	    });
	}
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
	{name:'CaseMeasure'},
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
function AfterEditFn(e)
{
	var curfield=e.field;
	var curvalue=e.value;
	var grid=Ext.getCmp("mygrid");
	var selectedrow=grid.getSelectionModel().getSelections()[0];
	//selectedrow.set(curfield,"")
    var parr=session['LOGON.CTLOCID']+"^"+EmrCode+"^"+curfield+"^"+curvalue;
	var ret=tkMakeServerCall("web.DHCNurLifeSignRelated","getSetting",parr);
	if(ret!="")
	{
		if(ret.indexOf('^')>-1)
		{
			var arrret=ret.split("^");
			var len=arrret.length;
			for(var i=0;i<len;i++)
			{
				var tt=arrret[i];
				var arrtt=tt.split("|");
				var Itemid=arrtt[0];
				var Itemval=arrtt[1];
				selectedrow.set(Itemid,Itemval);
			}
		}
		else
		{
			var tt=ret;
			var arrtt=tt.split("|");
			var Itemid=arrtt[0];
			var Itemval=arrtt[1];
			selectedrow.set(Itemid,Itemval);
		}
	}
}
var selectedrow="" //选中行

function AfterEditFn2(e)
{
  selectedrow=grid.getSelectionModel().getSelections()[0];
	var curfield=e.field;
	var curvalue=e.value;
	var totel=0;
	var totel1=0;
	var totel2=0;
	var totel3=0;
	var totel4=0;
	var totel5=0;
	var totel6=0;
	var xx=selectedrow.get("Item18");

		if (xx=="完全清醒")
		{
		  totel1=0;
		}		
		if (xx=="对声音有反应")
			{
		  totel1=1;
		}
   	 if (xx=="对疼痛有反应")
		{			
		  totel1=2;
		}
		if (xx=="无反应")
		{
		  totel1=3;
		}
	totel=parseInt(totel)+parseInt(totel1);
	var num5=selectedrow.get("Item2");
	if (num5=="") num5=0;
	if (isNaN(num5)) num5=0;
	switch(true)
     {
     case num5==0:
      break;
     case ((num5<=38)&&(num5>=36.1)):
     totel2=0;
     break;
     case (((num5<=38.5)&&(num5>=38.1))||((num5<=36)&&(num5>=35.1))):
     totel2=1;   
     break;
     case ((num5<=35.0)||(num5>=38.6)):
     totel2=2;
     break;     
     }
    //totel=parseInt(totel)+parseInt(totel2);
    var num4=selectedrow.get("Item3");
	if (num4=="") num4=0;
	if (isNaN(num4)) num4=0;
	switch(true)
     {
     case num4==0:
      break;
     case ((num4<=40)||((num4>=111)&&(num4<=129))):
     totel3=2;
     break;
     case (((num4<=50)&&(num4>=41))||((num4<=110)&&(num4>=101))):
     totel3=1;
    
     break;
     case (num4>=130):
     totel3=3;
    
     break;
     case ((num4<=100)||(num4>=51)):
     totel3=0;
     
     break;
     
     }
    //totel=parseInt(totel)+parseInt(totel3);
    var num3=selectedrow.get("Item4");
	if (num3=="") num3=0;
	if (isNaN(num3)) num3=0;
	switch(true)
     {
     case num3==0:
      break;
     case ((num3<=8)||((num3>=21)&&(num3<=29))):
     totel4=2;
     break;
     case ((num3<=20)&&(num3>=15)):
     totel4=1;
    
     break;
     case (num3>=30):
     totel4=3;
    
     break;
     case ((num3<=14)&&(num3>=9)):
     totel4=0;
     
     break;
     
     }
    //totel=parseInt(totel)+parseInt(totel4);
  	var ret=selectedrow.get("Item5");
  	if (ret){
  	var str=ret.split('/');
  	var num10=str[0];
	  if (num10=="") num10=0;
	  if (isNaN(num10)) num10=0;
	
	  switch(true)
     {
     case num10==0:
      break;
     case (num10<=70):
    totel5=3;
     break;
     case ((num10>=200)||((num10>=71)&&(num10<=80))):
    totel5=2;
    
     break;
     case ((num10<=100)&&(num10>=81)):
     totel5=1;
     
     break;
     case ((num10>=101)&&(num10<=199)):
     totel5=0;
     break;   
     default:
     totel5=2;
     
     }   
   }
//totel=parseInt(totel)+parseInt(totel5);
	var ret=selectedrow.get("Item11");
	if (ret){
  	if (ret.indexOf('尿')!=-1)
  	{
	  	var num2=selectedrow.get("Item12");
	  	if ((num2=="")||(num2==undefined)) 
	  	{
	  		num2=0;
	  	}
			else if(num2.indexOf('无')!=-1)
			{
				num2=3;
			}
	switch(true)
   {
     case num2==0:
      break;
     case num2==3:
     totel6=3;
     break; 
     case (num2<30):
     totel6=2;
     break;
      
     }
   
  	}
  	}
  	//alert(totel1)
  	//alert(totel2)
  	//alert(totel3)
  	//alert(totel4)
  	//alert(totel5)
  	//alert(totel6)
  	totel=parseInt(totel1)+parseInt(totel2)+parseInt(totel3)+parseInt(totel4)+parseInt(totel5)+parseInt(totel6);
	selectedrow.set("Item19",totel)
  
}