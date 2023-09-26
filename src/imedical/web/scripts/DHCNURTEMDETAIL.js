/**
 * @author Administrator
 */
var UserType="";
var GetUserType=document.getElementById('GetUserType');
if (GetUserType){
	UserType=cspRunServerMethod(GetUserType.value,session['LOGON.USERID']);
}

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
	grid1=Ext.getCmp("mygrid");
	var but1=Ext.getCmp("mygridbut1");
	but1.hide();
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
	tobar.addItem({
		xtype:'datefield',
		format: 'Y-m-d',
		id:'mygridstartdate',
		value:(diffDate(new Date(),-3))
		}, {
		xtype:'datefield',
		format: 'Y-m-d',
		id:'mygridenddate',
		value:(diffDate(new Date(),0))
	});
	tobar.addButton(
	{
		className: 'new-topic-button',
		text: "查询",
		handler:find,
		id:'mygridSch'
	});
	//tobar.render(grid.tbar);
	tobar.doLayout(); 
 	if (UserType=="DOCTOR")
 	{
 		if (but1) but1.hide();
 		if (but) but.hide();
 	}
	Ext.QuickTips.init();//注意，提示初始化必须要有
	find();
}
var REC=new Array();
function find(){
	REC = new Array();
	var adm = EpisodeID;
	var StartDate = formatDate(Ext.getCmp("mygridstartdate").getValue());
	var EndDate = formatDate(Ext.getCmp("mygridenddate").getValue());
	var GetQueryData = document.getElementById('GetQueryData');
	var mygrid = Ext.getCmp("mygrid");
	var parr =adm+"^"+StartDate+"^"+EndDate;
	if ((StartDate=="")||(EndDate=="")) return;
	var a = cspRunServerMethod(GetQueryData.value, "web.DHCThreeNew:GetPatTempData", "Parr$" + parr, "AddRec");
	mygrid.store.loadData(REC);
}

function AddRec(str)
{
	//var a=new Object(eval(str));
	var obj = eval('(' + str + ')');
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
	var RecSave=document.getElementById('RecSave');
	for (var i = 0; i < list.length; i++) {
		var obj=list[i];
		var str="";
		var StDate="";
		var StTime="";
		var flag="0";
		for (var p in obj) {
			var aa = formatDate(obj[p]);	
			//alert(aa);
			if (p=='RecDate') StDate=obj[p];
			if (p=='RecTime') StTime=obj[p];
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
				str = str + p + "|" + DBC2SBC(obj[p]) + '^';
			}else
			{
			  	str = str + p + "|" + aa + '^';	
			}
		}
		if ((str!="")&&(flag=="0"))
		{
		   	//alert(EpisodeID);
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
function DBC2SBC(str)   
{
	var result = '';
	if ((str)&&(str.length)) {
		for (var i = 0; i < str.length; i++) {
			var code = str.charCodeAt(i);
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
