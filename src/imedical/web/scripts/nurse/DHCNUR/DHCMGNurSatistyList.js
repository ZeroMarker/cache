/**
 * @author Administrator
 */
var ret = "";
var checkret = "";
var comboret = "";
var arrgrid = new Array();

function SizeChange(changewidth) {
	// alert("aa");
	var fheight = document.body.offsetHeight;
	var fwidth = document.body.offsetWidth;

	var fm = Ext.getCmp('gform');
	fm.setHeight(fheight);
	// alert(changewidth);
	fm.setWidth(fwidth + changewidth);
	// alert(fwidth+"df");
	setsize("mygridpl", "gform", "mygrid");
	// alert("dd");
}
// var commould
// =CreateComboBoxQ("commould","MouldName","rw","模块","","150","web.DHCMgNurSysComm","GetMould.RecQuery","sid",0,0);

var WardLoc = new Ext.form.ComboBox({
			name : 'WardLoc',
			id : 'WardLoc',
			store : new Ext.data.Store({
						proxy : new Ext.data.HttpProxy({
									url : "../csp/dhc.nurse.ext.common.getdata.csp"
								}),
						reader : new Ext.data.JsonReader({
									root : 'rows',
									totalProperty : 'results',
									fields : [{
												'name' : 'LocDes',
												'mapping' : 'LocDes'
											}, {
												'name' : 'LocDr',
												'mapping' : 'LocDr'
											}]
								}),
						baseParams : {
							className : 'web.DHCMgNurSysComm',
							methodName : 'FindWardLoc',
							type : 'Query'
						}
					}),
			tabIndex : '0',
			listWidth : '400',
			height : 18,
			width : 191,
			xtype : 'combo',
			displayField : 'LocDes',
			valueField : 'LocDr',
			hideTrigger : false,
			queryParam : 'HsDr',
			forceSelection : true,
			triggerAction : 'all',
			minChars : 1,
			pageSize : 10,
			typeAhead : true,
			typeAheadDelay : 1000,
			loadingText : 'Searching...'
		});

var QualScore=0;
function BodyLoadHandler() {
	//alert(CheckRoomId);
	 var getItmValue=document.getElementById('getItmValue');
     var getsschk=document.getElementById('getsschk');
     var NurTyp=cspRunServerMethod(getsschk.value,session['LOGON.USERID']);
     QualScore=cspRunServerMethod(getItmValue.value,CheckCode);
     
    
	// fm.doLayout();
	// but.hide();
	var grid = Ext.getCmp('mygrid');
	
	var mydate = new Date();
	var tobar = grid.getTopToolbar();
	var but1 = Ext.getCmp("mygridbut1");
	but1.hide();
	var but = Ext.getCmp("mygridbut2");
	but.hide();
	var loctyp=Ext.getCmp("LocTyp");
	var SortPos=Ext.getCmp("SortPos");
	var gform=Ext.getCmp("gform");
    grid.setTitle(CheckTitle);
    //alert(CheckTitle)
   // debugger;
	//tobar.addItem("-","检查类型",checktyp);
	tobar.addItem("-","病区",WardLoc);
	//tobar.addItem("-","检查日期",stdate);
	//tobar.addItem("-",eddate);
	//tobar.addItem("-","科室",LocDes);
    //gform.remove(LocDes);
	tbar2=new Ext.Toolbar({
		
		});	


		  tbar2.addButton(   {
			//className: 'new-topic-button', 
			text: "查询",
			handler:function(){SchQual();},
			id:'btnSch'
		  });
	
tbar2.render(grid.tbar);
	// tobar.render(grid.tbar);
	tobar.doLayout();
	
	WardLoc.store.on(
    "beforeLoad",function(){
         WardLoc.store.baseParams.HsDr=1;
         WardLoc.store.baseParams.typ="Ward";
        
    });
    
    var mygrid = Ext.getCmp("mygrid");
	mygrid.store.on(
    "beforeLoad",function(){
  	
 	 	var ward=Ext.getCmp("WardLoc").getValue();
 	 	
	    //if (chktyp=="") return;
	    var mygrid = Ext.getCmp("mygrid");
        mygrid.store.baseParams.CheckTyp=CheckTyp;
        mygrid.store.baseParams.QualDr=CheckRoomId;
        mygrid.store.baseParams.WardLoc=ward;
    });
	setsize("mygridpl", "gform", "mygrid",30);

	setGrpLayout(NurTyp);

 	/*
	 * Ext.getCmp("commould").getStore().load({ params : { start : 0, limit :
	 * 10, sid:2 }, callback : function() { //Ext.getCmp("commould").setValue(2) }
	 * }); var cmb=Ext.getCmp("commould"); cmb.on("select",loadgrid); var
	 * stdata=grid.store; stdata.on( "beforeLoad",function(){
	 * stdata.baseParams.mouldid=cmb.getValue();} );
	 * 
	 * grid.store.load({params:{start:0, limit:10}});
	 */
	SchQual();
	//loadgrid();
	
}
function SchQual() {
	/*
	 * var grid = Ext.getCmp("mygrid"); var
	 * GetQueryData=document.getElementById('GetQueryData'); arrgrid=new
	 * Array(); var a = cspRunServerMethod(GetQueryData.value,
	 * "web.DHCNurHDCodeComm:HDMode", "","AddRec");
	 * grid.store.loadData(arrgrid);
	 */
	//alert(CheckRoomId);
	var mygrid = Ext.getCmp("mygrid");
 
	mygrid.store.load({
				params : {
					start : 0,
					limit : 30
				}
			});
}
function setGrpLayout(NurTyp)
{
   if (NurTyp=="1")
   {
     cmbitm.add("WardLoc","ward");

   	  Ext.getCmp("CheckTyp").setValue("Nur");
   	  comboload1(Ext.getCmp("WardLoc"),session['LOGON.CTLOCID']);
   }
  if (NurTyp=="2")
   {
      //CheckTyp,WardLoc

   	 // Ext.getCmp("CheckTyp").setValue("LocNur");
   	  
   	  var getchktypPar=document.getElementById('getchktypPar');
      var Par=cspRunServerMethod(getchktypPar.value,session['LOGON.USERID']);
 
      cmbitm.add("WardLoc","Par");
   	  comboload2(Ext.getCmp("WardLoc"),Par);
   
   	  
   }
  if (NurTyp=="3")
   {
      //CheckTyp,WardLoc
   	  Ext.getCmp("CheckTyp").setValue("MasterNur");
   	 // comboload1(Ext.getCmp("WardLoc"),session['LOGON.CTLOCID']);
   }
}
var cmbitm = new Hashtable();
function comboload2(itm, val) {
    itm.getStore().baseParams[cmbitm.items(itm.id)]=val;
    //alert(cmbitm.items(itm.id));
	if (val != "") {
		itm.getStore().load({
					params : {
						start : 0,
						limit : 10
					},
					callback : function() {
						itm.setValue(session['LOGON.CTLOCID']);
					}
				});
	}
}
function comboload1(itm, val) {
    itm.getStore().baseParams[cmbitm.items(itm.id)]=val;
   //alert(val);
	if (val != "") {
		itm.getStore().load({
					params : {
						start : 0,
						limit : 10
					},
					callback : function() {
						itm.setValue(val);
					}
				});
	}
}
function setCheckLayout(NurTyp)
{
   if (NurTyp=="1")
   {
      cmbitm.add("CheckWard","ward");
      cmbitm.add("CheckUser","nur");

   	  comboload1(Ext.getCmp("CheckUser"),session['LOGON.USERID']);
   	  comboload1(Ext.getCmp("CheckWard"),session['LOGON.CTLOCID']);
   }
  if (NurTyp=="2")
   {
      //CheckTyp,WardLoc
      var getchktypPar=document.getElementById('getchktypPar');
      var Par=cspRunServerMethod(getchktypPar.value,session['LOGON.USERID']);
      cmbitm.add("CheckWard","Par");

   	  comboload2(Ext.getCmp("WardLoc"),Par);
   	  cmbitm.add("CheckUser","nur");

   	  comboload1(Ext.getCmp("CheckUser"),session['LOGON.USERID']);

   	  
   }
  if (NurTyp=="3")
   {
      //CheckTyp,WardLoc
   	 // comboload1(Ext.getCmp("WardLoc"),session['LOGON.CTLOCID']);
   	  cmbitm.add("CheckUser","nur");

   	  comboload1(Ext.getCmp("CheckUser"),session['LOGON.USERID']);

   }
}

function grid1click() {

	var grid = Ext.getCmp("mygrid1");
	var rowObj = grid.getSelectionModel().getSelections();
	if (rowObj.length == 0) {
		//alert("请选择一条记录！");
		return;
	}

	var sort = rowObj[0].get("SortPos");
    var sortpos=Ext.getCmp("SortPos1");
    sortpos.setValue(sort);

}
function ModCheck(NurTyp)
{
  	var grid = Ext.getCmp("mygrid");
	var rowObj = grid.getSelectionModel().getSelections();
	if (rowObj.length == 0) {
		alert("请选择一条记录！");
		return;
	}

	var Par = rowObj[0].get("rw");
	CheckValue = new Hashtable();
    CheckReason = new Hashtable();

	Check(NurTyp,Par);

}
function NewCheck(NurTyp) 
{
  Check(NurTyp,"");
  CheckValue = new Hashtable();
  CheckReason = new Hashtable();

  Ext.getCmp("CheckScore").setValue(QualScore);
}
function Check(NurTyp,Par){

	var arr = new Array();

	// alert(curmenuid);
	// 录入界面
	var a = cspRunServerMethod(pdata1, "", "DHCMGNurCheckGrade", "", "");
	// alert(a);
	arr = eval(a);
	var window = new Ext.Window({
				title : '质控评分',
				id : "gform2",
				x:10,
				y:2,
				width : 890,
				height : 560,
				autoScroll : true,
				layout : 'absolute',
				// plain: true,
				// modal: true,
				// bodyStyle: 'padding:5px;',
				// /buttonAlign: 'center',
				items : arr
			});

	/*	var but1 = Ext.getCmp("butSave");
	but1.on('click', itmAdd);
	var but = Ext.getCmp("butMod");
	but.on('click', itmMod);
	var but2 = Ext.getCmp("butClear");
	but2.on('click', clearscreen);
*///debugger;
	window.show();
	var but1 = Ext.getCmp("mygrid1but1");
	but1.hide();
	var but = Ext.getCmp("mygrid1but2");
	but.hide();
     Ext.getCmp("CheckDate").setValue(new Date());
	var grid = Ext.getCmp('mygrid1');
    var stdata=Ext.getCmp("mygrid1").store;
	stdata.on(
	"beforeLoad",function(){ 
	stdata.baseParams.parr=CheckCode+"^"+Par;}
	 )
	/*
	 * var cmould=Ext.getCmp("NurProduct"); var
	 * cmparent=Ext.getCmp("ParentMenuNod"); var cmbstore=cmparent.getStore();
	 * cmbstore.on(
	 * "beforeLoad",function(){cmbstore.baseParams.mouldid=cmould.getValue();} );
	 * 
	 * Ext.getCmp('mygrid1').store.load({params:{start:0,
	 * limit:10,Par:curmenuid}});
	 */
	Ext.getCmp('CheckWard').store.on(
    "beforeLoad",function(){
    	var wardstore=Ext.getCmp('CheckWard').store;
         wardstore.baseParams.HsDr=1;
         wardstore.baseParams.typ="Ward";
         
    });
		Ext.getCmp('CheckUser').store.on(
    "beforeLoad",function(){
    	var CheckUser=Ext.getCmp('CheckUser').store;
         CheckUser.baseParams.nur=session['LOGON.USERID'];
        
    });
    var btnSure=Ext.getCmp("btnSure");
    btnSure.on("click",function(){SureCheck(Par);});
    if (Par!="")
	{
	   	var getVal = document.getElementById('getVal');
	    var ret=cspRunServerMethod(getVal.value,Par);
        var arr=ret.split('^');
        cmbitm.add("CheckWard","ward");
        cmbitm.add("CheckUser","nur");
   	    comboload1(Ext.getCmp("CheckWard"),arr[1]);
  	    comboload1(Ext.getCmp("CheckUser"),arr[3]);
  	    Ext.getCmp("CheckScore").setValue(arr[2]);
  	    Ext.getCmp("CheckDate").value=arr[0];
  	    Ext.getCmp("CheckDate").disable(); 
  	    Ext.getCmp("CheckWard").disable(); 
  	    Ext.getCmp("CheckUser").disable();
  	    setqualitmdata(Par);//初始化扣分值，与扣分原因
 	}
 	var pagesize=50;

    var cmb=Ext.getCmp("CheckWard");
    cmb.on("select",function(){iniform(pagesize);});

	if (Par=="") setCheckLayout(NurTyp);
	grid.on("afteredit",afterEidt,grid)
	Ext.getCmp('mygrid1').toolbars[1].pageSize=pagesize;
	Ext.getCmp("mygrid1").store.load({
				params : {
					start : 0,
					limit :pagesize
				}
			});
}
function iniform(pagesize)
{
   Ext.getCmp("CheckScore").setValue(QualScore);
   Ext.getCmp("mygrid1").store.load({
				params : {
					start : 0,
					limit :pagesize
				}
			});

}
function SetScore()
{ //计算得分
    var Score=QualScore;
 	for (var i=0 ; i<CheckValue.keys().length;i++)//for...in statement get all of Array's index
	{
		var key = CheckValue.keys()[i];
		if (CheckValue.items(key)=="") continue;
		Score=Score-parseFloat(CheckValue.items(key)).toFixed(2);
	}
  Ext.getCmp("CheckScore").setValue(Score);
}
function DelCheck()
{
	var grid = Ext.getCmp("mygrid");
	var rowObj = grid.getSelectionModel().getSelections();
	if (rowObj.length == 0) {
		alert("请选择一条记录！");
		return;
	}

	var Par = rowObj[0].get("rw");
	var delQual = document.getElementById('delQual');
	var ret=cspRunServerMethod(delQual.value,Par);
	SchQual();

}
function SureCheck(CheckPar)
{
   var CheckDate=Ext.getCmp("CheckDate").value;
   var CheckUser=Ext.getCmp("CheckUser").getValue();
   var CheckWard=Ext.getCmp("CheckWard").getValue();
   var CheckTyp=Ext.getCmp("CheckTyp").getValue();
   var CheckScore=Ext.getCmp("CheckScore").getValue();
   if (CheckUser=="") 
   {
      alert("检查者不能为空！");
      return;
   }
  if (CheckWard=="") 
   {
      alert("检查病区不能为空！");
      return;
   }
  var chkval="";
  var checkreason="";
  for (var i=0 ; i<CheckValue.keys().length;i++)//for...in statement get all of Array's index
	{
		var key = CheckValue.keys()[i];
		chkval=chkval+key+"|"+CheckValue.items(key)+"^";
	}
  for (var i=0 ; i<CheckReason.keys().length;i++)//for...in statement get all of Array's index
	{
		var key = CheckReason.keys()[i];
		checkreason=checkreason+key+"|"+CheckReason.items(key)+"^";
	}
	
	var SaveQual = document.getElementById('SaveQual');
		alert(CheckPar);
	// alert(NurRecId);checkdate, user, checktyp, qualcode, wloc, score, ques, checkpat,checkrw
	CheckPar=cspRunServerMethod(SaveQual.value,CheckDate,CheckUser,CheckTyp,CheckCode,CheckWard,CheckScore,"","",CheckPar);
//	debugger;
	alert(CheckPar);
	if (CheckPar!="" )
	{
	  	var SaveQualItem = document.getElementById('SaveQualItem');
        CheckPar=cspRunServerMethod(SaveQualItem.value,CheckCode,chkval,checkreason,CheckPar);

	}

  
}

/*grid.on("afteredit",afterEidt,grid); //EditorGridPanel的afteredit事件
 
function afterEidt(e){
    e.row;;//修改过的行从0开始
    e.column;//修改列
    e.originalValue;//原始值
    e.value;//修改后的值
    e.grid;//当前修改的grid
    e.field;//正在被编辑的字段名
    e.record;//正在被编辑的行
}
var row = e.record;
var price = row.get("price");
var totalPrice = parseInt(e.value) * price;
totalPrice = parseFloat(totalPrice).toFixed(2);
row.set(e.grid.getColumnModel().getDataIndex(7), totalPrice);
1.var classificationRadioGroup = Ext.getCmp('classifications');   
2.                var classifications = "";   
3.                classificationRadioGroup.eachItem(function(item){   
4.                    if(item.checked == true){   
5.                        classifications += item.inputValue+";";   
6.                    }   
7.                });  

*
*var sex=Ext.getCmp('selectsex');
*2 sex.eachItem(function(item){
*3     if(item.checked===true){
*4         alert(item.inputValue);5     }
*6 });
Ext.override(Ext.form.RadioGroup, {      
 getValue: function(){   
         var v;           
         if (this.rendered) {               
         this.items.each(function(item){                   
         if (!item.getValue())                        
         return true;                   
         v = item.getRawValue();                  
          return false;               });           
          }           
          else {               
          for (var k in this.items) {                   
          if (this.items[k].checked) {                       
          v = this.items[k].inputValue;                       
          break;                   }               }           }           
          return v;       },       
          setValue: function(v){           
          if (this.rendered)                
          this.items.each(function(item){                   
          item.setValue(item.getRawValue() == v);               
          });           
          else {               
          for (var k in this.items) {                   
          this.items[k].checked = this.items[k].inputValue == v; 
          }   
        }  
       } 
    });  
*/
var CheckValue = new Hashtable();
var CheckReason = new Hashtable();
function setqualitmdata(Par)
{

	var getval = document.getElementById('getqualitmdata');
	var ret = cspRunServerMethod(getval.value, Par);
	var tm = ret.split('^')
	for (var i=0;i<tm.length;i++)
	{
	   if (tm[i]=="") continue;
	   var arr=tm[i].split('|');
	   CheckValue.add(arr[0],arr[2]);
	   CheckReason.add(arr[0],arr[1]);
	}


}
function afterEidt(e)
{ //拿到选中的列 ,下面是在editGridPanel中
 //var record = grid.getSelectionModel().selection.record; 
 //如果是在GridPanel中，拿到record的方法为如下
 //var record = grid.getSelectionModel().getSelected();
  //调用record的set方法格式为
 
 //record.set(名称,值)
 
 //其中名称是dataindex对应的值。
 
 //最后提交以下
 //record.commit()
  var row = e.record;
  if (row.get("CheckScore")=="") return;
  
  var itmvalue =parseFloat( row.get("ItemValue")).toFixed(2);
  var numflag = isNaN(row.get("CheckScore"));
  if (numflag==true) row.set("CheckScore","");
  numflag=isNaN(row.get("ItemValue"));
   if (numflag==true) {
  	alert("分值类型不对！");
  	return;
  }
 var flag =row.get("MinLevel");
 var ItemCode =row.get("ItemCode");
 var CheckMem =row.get("CheckMem");
  if (flag=="N") row.set("CheckScore","");
  var checkscore =parseFloat( row.get("CheckScore")).toFixed(2);
  alert(checkscore);
  if (parseFloat(checkscore)>parseFloat(itmvalue))
  {
  	//alert(itmvalue);
    row.set("CheckScore","");
  }else{
  	//扣分
   if(CheckValue.contains(ItemCode))
  	{
  	   CheckValue.remove(ItemCode);
   	}else{
   	}
  	CheckValue.add(ItemCode,checkscore);
  }
  //扣分原因
  if (CheckReason.contains(ItemCode))
  	{
  	   CheckReason.remove(ItemCode);
   	}else{
   	}
  	CheckReason.add(ItemCode,CheckMem);
  	SetScore();
}
function QuickCheckIn() {
/*	var grid = Ext.getCmp("mygrid");
	var rowObj = grid.getSelectionModel().getSelections();
	if (rowObj.length == 0) {
		alert("请选择一条记录！");
		return;
	}

	var menuid = rowObj[0].get("rw");
	curmenuid = menuid;*/

	var arr = new Array();

	// alert(curmenuid);
	// 录入界面
	var a = cspRunServerMethod(pdata1, "", "DHCMgNurCheckQuickIn", "", "");
	// alert(a);
	arr = eval(a);
	var window = new Ext.Window({
				title : '快速评分',
				id : "gform3",
				x:150,
				y:2,
				width : 350,
				height : 550,
				autoScroll : true,
				layout : 'absolute',
				// plain: true,
				// modal: true,
				// bodyStyle: 'padding:5px;',
				// /buttonAlign: 'center',
				items : arr
			});

	// debugger;
	window.show();
	/*	var but1 = Ext.getCmp("butSave");
	but1.on('click', itmAdd);
	var but = Ext.getCmp("butMod");
	but.on('click', itmMod);
	var but2 = Ext.getCmp("butClear");
	but2.on('click', clearscreen);
*/
	/*
	 * var cmould=Ext.getCmp("NurProduct"); var
	 * cmparent=Ext.getCmp("ParentMenuNod"); var cmbstore=cmparent.getStore();
	 * cmbstore.on(
	 * "beforeLoad",function(){cmbstore.baseParams.mouldid=cmould.getValue();} );
	 * 
	 * Ext.getCmp('mygrid1').store.load({params:{start:0,
	 * limit:10,Par:curmenuid}});
	 */
	// setvalue(menuid);
	//alert(curmenuid);
	//var mygrid = Ext.getCmp("mygrid2");
	var but1 = Ext.getCmp("mygrid2but1");
	but1.hide();
	var but = Ext.getCmp("mygrid2but2");
	but.hide();
	var btnSure=Ext.getCmp('btnSure');
	btnSure.on("click",quickSure);
    Ext.getCmp("CheckDate").setValue(new Date());

	Ext.getCmp("mygrid2").store.on(
    "beforeLoad",function(){
 	    var hsdr=1;
	    var mygrid = Ext.getCmp("mygrid2");

         mygrid.store.baseParams.HsDr=hsdr;
         mygrid.store.baseParams.typ="Ward";
        
    });
      cmbitm.add("CheckUser","nur");
   	  comboload1(Ext.getCmp("CheckUser"),session['LOGON.USERID']);

    setgrid();
}
function quickSure()
{
	var grid = Ext.getCmp("mygrid2");
	var store = grid.store;
	var rowCount = store.getCount(); // 记录数
	var cm = grid.getColumnModel();
	var colCount = cm.getColumnCount();
	var list = [];
	var CheckDate=Ext.getCmp("CheckDate").value;
    var CheckUser=Ext.getCmp("CheckUser").getValue();
    var CheckTyp=Ext.getCmp("CheckTyp").getValue();
    var CheckScore=QualScore;
   if (CheckUser=="") 
   {
      alert("检查者不能为空！");
      return;
   }

	// for (var i = 0; i < store.getCount(); i++) {
	// list.push(store.getAt(i).data);
	// //debugger;
	// }
	var rowObj = grid.getSelectionModel().getSelections();
	var len = rowObj.length;
	for (var r = 0; r < len; r++) {
		list.push(rowObj[r].data);
	}
	var SaveQt = document.getElementById('SaveMulitms');
	var rw = "";
	var str = "";

	for (var i = 0; i < list.length; i++) {
		var obj = list[i];
				rw = obj["LocDr"];
				str=str+rw+"^";

		}
		if (str != "") {
			//checkuser, wards, qualcode, checkdate, checktyp
		var a = cspRunServerMethod(SaveQt.value, CheckUser,str,CheckCode,CheckDate,CheckTyp,CheckScore);
		if (a != 0) {
         SchQual();
       }

	}

}
function setgrid() {
	/*
	 * var grid = Ext.getCmp("mygrid"); var
	 * GetQueryData=document.getElementById('GetQueryData'); arrgrid=new
	 * Array(); var a = cspRunServerMethod(GetQueryData.value,
	 * "web.DHCNurHDCodeComm:HDMode", "","AddRec");
	 * grid.store.loadData(arrgrid);
	 */
	var grid1 = Ext.getCmp("mygrid2");



	grid1.store.load({
				params : {
					start : 0,
					limit : 30
				}
			});
}
var CurrSelItm = "";
function SaveItm()
{
  	ret = "";
	checkret = "";
	comboret = "";
	var Save = document.getElementById('Save');
	var gform = Ext.getCmp("gform2");
	gform.items.each(eachItem, this);
	// alert(NurRecId);
	// var rw=cspRunServerMethod(getemrcodeid.value,code,NurRecId);
	// alert(rw);
	// var parr=ret+"&"+checkret+"&"+comboret;
	//alert(ret + "^" + checkret + "^" + comboret);
	var parr = "rw|" + CurrSelItm + "^Par|" + curmenuid + "^" + ret + "^"
			+ checkret + "^" + comboret;
	//alert(parr);
	// return;
	// var
	// id=cspRunServerMethod(SaveExam.value,"id|"+ret+"^CTLocDr|"+session['LOGON.CTLOCID']+"^"+checkret+"^"+comboret);
	// //+"^UserDr|"+session['LOGON.USERID']
	// alert(parr);
	var row = cspRunServerMethod(Save.value, parr);
	//alert(row);
	// win.close();
	Ext.getCmp("mygrid2").store.load({
				params : {
					start : 0,
					limit : 10,
					Par : curmenuid
				}
			});
	return;
}
function itmAdd() {
   CurrSelItm=""
   SaveItm();
}
function itmMod() {
	//alert(CurrSelItm);
	if (CurrSelItm=="") return;
	SaveItm();
}
function clearscreen() {
   Ext.getCmp("ItemDesc").setValue("");
  Ext.getCmp("ItemCode").setValue("");
  Ext.getCmp("ItemLevel").setValue("");
  Ext.getCmp("ItemMem").setValue("");
  Ext.getCmp("ItemValue").setValue("");
  setbutstatus(0);
}
function setbutstatus(flag)
{
   	var but1 = Ext.getCmp("butSave");
	var but = Ext.getCmp("butMod");
	var but2 = Ext.getCmp("butClear");
	if (flag==0)
	{
      but.disable();
      but1.enable();
	}else{
	
	 but1.disable();
	 but.enable();
	 
	}
}
function griddblclick()
{
	var grid=Ext.getCmp("mygrid2");
  	var rowObj = grid.getSelectionModel().getSelections();
	var len = rowObj.length;
	var list = [];
	
	if (rowObj.length == 0) {
		return;
	}
	CurrSelItm = rowObj[0].get("rw");
    setbutstatus(1);
	for (var r = 0; r < len; r++) {
		list.push(rowObj[r].data);
	}
	for (var i = 0; i < list.length; i++) {
	var obj = list[i];
	for (var p in obj) {
		var itm= Ext.getCmp(p);
		if (itm!=undefined) itm.setValue(obj[p]);
	}
	}


}


function setvalue(menid) {

	var ha = new Hashtable();
	var getval = document.getElementById('getVal');
	var ret = cspRunServerMethod(getval.value, menid);
	var tm = ret.split('^')
	// alert(ret);
	sethashvalue(ha, tm)
	// debugger;
	// var tm1=ret.split('^')
	// debugger;
	// sethashvalue(ha,tm1);

	var gform = Ext.getCmp("gform2");
	gform.items.each(eachItem, this);

	for (var i = 0; i < ht.keys().length; i++)// for...in statement get all of
												// Array's index
	{
		var key = ht.keys()[i];
		// restr += ht.items(key) + " " + ht.parent[key] + "<br/>";
		if (key.indexOf("_") == -1) {
			var itm = Ext.getCmp(key);
			if (ha.contains(key))
				if (itm.xtype == "combo") {

					comboload(itm, ha.items(key));

				} else {
					itm.setValue(ha.items(key));
				}

		} else {
			var aa = key.split('_');
			if (ha.contains(aa[0])) {
				setcheckvalue(key, ha.items(aa[0]));
			}
		}
	}

}
function comboload(itm, str) {
	var aa = str.split('!');
	var par = itm.id;
	// alert(aa.length);
	if (aa.length < 2) {
		itm.setValue(str);
		return;
	}
	if (str != "") {
		itm.getStore().load({
					params : {
						start : 0,
						limit : 10,
						locdes : aa[0]
					},
					callback : function() {
						itm.setValue(aa[1])
					}
				});
	}
}
function Save(win, menuid) {
	ret = "";
	checkret = "";
	comboret = "";
	var Save = document.getElementById('Save2');
	var gform = Ext.getCmp("gform2");
	gform.items.each(eachItem, this);
	// alert(NurRecId);
	// var rw=cspRunServerMethod(getemrcodeid.value,code,NurRecId);
	// alert(rw);
	// var parr=ret+"&"+checkret+"&"+comboret;
	// alert(ret+"^"+checkret+"^"+comboret);
	var parr = "rw|" + menuid + "^" + ret + "^" + checkret + "^" + comboret;
	// alert(parr);
	// var
	// id=cspRunServerMethod(SaveExam.value,"id|"+ret+"^CTLocDr|"+session['LOGON.CTLOCID']+"^"+checkret+"^"+comboret);
	// //+"^UserDr|"+session['LOGON.USERID']
	// alert(parr);
	menuid = cspRunServerMethod(Save.value, parr);
	curmenuid = menuid;
	win.close();
	loadgrid();
	return;

}

function setgrid1() {
	/*
	 * var grid = Ext.getCmp("mygrid"); var
	 * GetQueryData=document.getElementById('GetQueryData'); arrgrid=new
	 * Array(); var a = cspRunServerMethod(GetQueryData.value,
	 * "web.DHCNurHDCodeComm:HDMode", "","AddRec");
	 * grid.store.loadData(arrgrid);
	 */
	var mygrid = Ext.getCmp("mygrid1");
	// var parr = getParameters()
	// alert(parr);
	// debugger;
	mygrid.store.load({
				params : {
					start : 0,
					limit : 10
				}
			});

}

function additm() {
	var grid = Ext.getCmp('mygrid1');
	var Plant = Ext.data.Record.create([
			// the "name" below matches the tag name to read, except "availDate"
			// which is mapped to the tag "availability"

			]);
	var count = grid.store.getCount();
	var r = new Plant();
	grid.store.commitChanges();
	grid.store.insert(count, r);
	return;

}

function typdelete() {
	var grid = Ext.getCmp("mygrid");
	var rowObj = grid.getSelectionModel().getSelections();
	var len = rowObj.length;
	if (len == 0) {
		Ext.Msg.alert('提示', "请先选择一行!");
		return;
	};
	var QtDelete = document.getElementById('QtDelete');
	if (QtDelete) {
		var id = rowObj[0].get("rw");
		var ee = cspRunServerMethod(QtDelete.value, id);
		if (ee != "0") {
			alert(ee);
			return;
		}
	}
	setgrid();
};