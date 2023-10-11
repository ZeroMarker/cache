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
var stdate=new Ext.form.DateField(
{
			name : 'StDate',
			id : 'StDate',
			format : 'Y-m-d',
			tabIndex : '0',
			height : 20,
			width : 119,
			xtype : 'datefield',
			value : new Date()
		}
);
var eddate=new Ext.form.DateField(
{
			name : 'EndDate',
			id : 'EndDate',
			format : 'Y-m-d',
			tabIndex : '0',
			height : 21,
			width : 116,
			xtype : 'datefield',
			value : new Date()
		}
);


var QualScore=0;
var NurTyp="";
function BodyLoadHandler() {
	//alert("a");
     
     //var getsschk=document.getElementById('getsschk');
    // NurTyp=cspRunServerMethod(getsschk.value,session['LOGON.USERID']);

	// fm.doLayout();
	// but.hide();
	var grid = Ext.getCmp('mygrid');
	
	var mydate = new Date();
	var tobar = grid.getTopToolbar();
	var but1 = Ext.getCmp("mygridbut1");
	//but1.hide();
	var but = Ext.getCmp("mygridbut2");
	//but.hide();
	
	
    setsize("mygridpl", "gform", "mygrid",0);

    var mygrid = Ext.getCmp("mygrid");
	mygrid.store.on(
    "beforeLoad",function(){
  	
      	//var stdate=Ext.getCmp("StDate").value;
 	 	//var eddate=Ext.getCmp("EndDate").value;
	    var mygrid = Ext.getCmp("mygrid");
       mygrid.store.baseParams.CheckQual=CheckRoomId;
    });


 	/*
	 * Ext.getCmp("commould").getStore().load({ params : { start : 0, limit :
	 * 10, sid:2 }, callback : function() { //Ext.getCmp("commould").setValue(2) }
	 * }); var cmb=Ext.getCmp("commould"); cmb.on("select",loadgrid); var
	 * stdata=grid.store; stdata.on( "beforeLoad",function(){
	 * stdata.baseParams.mouldid=cmb.getValue();} );
	 * 
	 * grid.store.load({params:{start:0, limit:10}});
	 */
	//loadgrid();
	
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

	var mygrid = Ext.getCmp("mygrid");

 
	mygrid.store.load({
				params : {
					start : 0,
					limit : 30
				}
			});
}

var cmbitm = new Hashtable();


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

function DelItm()
{
   var grid = Ext.getCmp("mygrid2");
	var rowObj = grid.getSelectionModel().getSelections();
	if (rowObj.length == 0) {
		alert("请选择一条记录！");
		return;
	}
	var p = rowObj[0].get("Par");
	var rw=rowObj[0].get("rw");
	var DelItm = document.getElementById('DelItm');
	var ret=cspRunServerMethod(DelItm.value,p+"||"+rw);
	setgrid();

}
function checkitmgrid()
{
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
	Ext.getCmp("mygrid1").store.load({
				params : {
					start : 0,
					limit : 50
				}
			});
}
function ModCheck()
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
	Check(Par);

}

function Check(Par){

	var arr = new Array();

	// alert(curmenuid);
	// 录入界面
	var a = cspRunServerMethod(pdata1, "", "DHCNurQualCheck", "", "");
	// alert(a);
	arr = eval(a);
	var window = new Ext.Window({
				title : '查房',
				id : "gform2",
				x:10,
				y:2,
				width : 510,
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
  Ext.getCmp("mygrid2").store.removeAll();
  Ext.getCmp("mygrid3").store.removeAll();
  var but1=Ext.getCmp("mygrid2but1");
    but1.setText("删除");
    but1.on('click',function(){delitm(Ext.getCmp("mygrid2"));});
    var but=Ext.getCmp("mygrid2but2");
    but.hide();
   var but1=Ext.getCmp("mygrid3but1");
    but1.setText("删除");
    but1.on('click',function(){delitm(Ext.getCmp("mygrid3"));});
    var but=Ext.getCmp("mygrid3but2");
    but.hide();

  //
  var btnMulti=Ext.getCmp("btnMulti"); ///butClear
  btnMulti.on("click",function(){multiCheck();});
 var btnadd1=Ext.getCmp("btnadd1"); ///butClear
  btnadd1.on("click",function(){
   var Nurse=Ext.getCmp("Nurse");
   if (Nurse.getValue()=="") return;
   var des=Nurse.lastSelectionText;
   var rw=Nurse.getValue();
   additmNurse("mygrid2",des,rw);});
  


	/*	var but1 = Ext.getCmp("mygrid1but1");
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

	 * var cmould=Ext.getCmp("NurProduct"); var
	 * cmparent=Ext.getCmp("ParentMenuNod"); var cmbstore=cmparent.getStore();
	 * cmbstore.on(
	 * "beforeLoad",function(){cmbstore.baseParams.mouldid=cmould.getValue();} );
	 * 
	 * Ext.getCmp('mygrid1').store.load({params:{start:0,
	 * limit:10,Par:curmenuid}});
	 */
    var btnSure=Ext.getCmp("btnSure");
    btnSure.on("click",function(){SureCheck(Par);});
    if (Par!="")
	{
	   	var getVal = document.getElementById('getVal');
	    var ret=cspRunServerMethod(getVal.value,Par);
      	var getitms = document.getElementById('getitms1');
	    var ret1=cspRunServerMethod(getitms.value,Par);
        var ha = new Hashtable();

        var tm=ret.split('^')
	    sethashvalue(ha,tm)
   	    //Ext.getCmp("CheckScore").setValue(arr[2]);
  	    Ext.getCmp("CheckMem").setValue(ha.items("CheckMem"));
 	    Ext.getCmp("CheckStDate").setValue(ha.items("CheckStDate"));
  	    Ext.getCmp("CheckEdDate").setValue(ha.items("CheckEdDate"));
 	    Ext.getCmp("CheckTitle").setValue(ha.items("CheckTitle"));
  	    
   	    if (ret1!="")
	    {
	        var gr=ret1.split("$");
	        var arr2=gr[0].split("!");
	        var arr1=gr[1].split("!");
	        for (var i=0;i<arr1.length;i++)
	        {
	            if (arr1[i]!="")
	            {
	              var itm=arr1[i].split("^");
	              additmItm("mygrid3",itm[0],itm[1]);
	            }
	        }
	        for (var i=0;i<arr2.length;i++)
	        {
	            if (arr2[i]!="")
	            {
	              var itm=arr2[i].split("^");
	              additmNurse("mygrid2",itm[0],itm[1]);
	            }
	        }
	    }
 	}
 	var pagesize=50;

/*	if (Par=="") setCheckLayout(NurTyp);
	grid.on("afteredit",afterEidt,grid)
	Ext.getCmp('mygrid1').toolbars[1].pageSize=pagesize;
	Ext.getCmp("mygrid1").store.load({
				params : {
					start : 0,
					limit :pagesize
				}
			});
*/
}

function SureCheck(Par)
{
    var CheckStDate=Ext.getCmp("CheckStDate").value;
    var CheckEdDate=Ext.getCmp("CheckEdDate").value;
    var users=getgriditm(Ext.getCmp("mygrid2"));;
    var checkItms=getgriditm(Ext.getCmp("mygrid3"));
    var CheckTitle=Ext.getCmp("CheckTitle").getValue();
    var CheckMem=Ext.getCmp("CheckMem").getRawValue();
   // var CheckTyp=Ext.getCmp("CheckTyp").getValue();
    var parr="rw|"+Par+"^CheckTitle|"+CheckTitle+"^CheckMem|"+CheckMem+"^CheckStDate|"+CheckStDate+"^CheckEdDate|"+CheckEdDate+"^CheckTyp|"+CheckTyp+"^NurTyp|"+NurTyp;
    //alert(parr);
 	var Save = document.getElementById('Save');
    cspRunServerMethod(Save.value,parr,users,checkItms);
   // SchQual();
}
function delitm(grid)
{
  grid.store.remove(grid.getSelectionModel().getSelected());
}

function getgriditm(grid)
{
    var n = grid.getStore().getCount();
    var store = grid.store;
    var ret="";
    for( var j=0;j<n;j++)
    {
       var rw=store.getAt(j).get("rw");
       ret=ret+"^"+rw;
    }
   return ret;
}
function additmNurse(griditm,Nurse,idrw)
{
     var grid=Ext.getCmp(griditm);
     var n = grid.getStore().getCount();
     var store = grid.store;
 
    for( var j=0;j<n;j++)
    {
       var rw=store.getAt(j).get("rw");
       if (rw==idrw)return;
    }
    
    var Plant = Ext.data.Record.create([
           // the "name" below matches the tag name to read, except "availDate"
           // which is mapped to the tag "availability"

      ]);
                var count = grid.store.getCount(); 
                var r = new Plant({User:Nurse,rw:idrw}); 
                grid.store.commitChanges(); 
                grid.store.insert(count,r); 
                return;

}function additmItm(griditm,Qual,idrw)
{
    var grid=Ext.getCmp(griditm);
    var n = grid.getStore().getCount();
     var store = grid.store;
 
    for( var j=0;j<n;j++)
    {
       var rw=store.getAt(j).get("rw");
       if (rw==idrw)return;
    }
    
    var Plant = Ext.data.Record.create([
           // the "name" below matches the tag name to read, except "availDate"
           // which is mapped to the tag "availability"

      ]);
                var count = grid.store.getCount(); 
                var r = new Plant({Qual:Qual,rw:idrw}); 
                grid.store.commitChanges(); 
                grid.store.insert(count,r); 
                return;

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