/**
 * @author Administrator
 */
var locdata = new Array();
var condata = new Array();
var persondata=new Array();
var nursedata=new Array();
var loc = session['LOGON.CTLOCID'];
cspRunServerMethod(getloc, 'addloc');
function addloc(a, b) {
	locdata.push({
				loc : a,
				locdes : b
			});
}
var storeloc = new Ext.data.JsonStore({
			data : locdata,
			fields : ['loc', 'locdes']
});
var locField = new Ext.form.ComboBox({
			id : 'locsys',
			hiddenName : 'loc1',
			store : storeloc,
			listeners:{
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
						var text = getPinyin(record.data[me.displayField]);
						return regExp.test(text)|regExp.test(record.data[me.displayField]); 
					});
					combo.expand();
					combo.select(0, true);
					return false;
				}
		    }
	},
			width : 150,
			fieldLabel : '科室',
			valueField : 'loc',
			displayField : 'locdes',
			allowBlank : true,
			mode : 'local',
			anchor : '100%'
});
var storeperson = new Ext.data.JsonStore({
			data : persondata,
			fields : ['id', 'desc']
});
var person= new Ext.form.ComboBox({
			id : 'personstr',
			hiddenName : 'personstr1',
			store :storeperson, 
			width : 100,
			fieldLabel : '患者',
			valueField : 'id',
			displayField : 'desc',
			allowBlank : true,
			mode : 'local',
			anchor : '100%'
});

var persondddd=new Ext.form.ComboBox({
	name:'患者dddd',
	id:'personstrss',
	hiddenName : 'personstr1ssss',
	store:new Ext.data.Store({
		proxy:new Ext.data.HttpProxy({
			url:"../csp/dhc.nurse.ext.common.getdata.csp"
		}),
		reader:new Ext.data.JsonReader({
			root:'rows',
			totalProperty:'results',
			fields:[{
				'name':'LocCode',
				'mapping':'LocCode'
			},{
				'name':'LocDes',
				'mapping':'LocDes'
			},{
				'name':'rw',
				'name':'rw'
			}]
		}),
		baseParams:{
			className:'User.DHCNurMedTourRecord',
			methodName:'GetNurMedTourperson',
			type:'Query'
		}
	}),
	tabIndex:'0',
	listWidth:'150',
	height:18,
	width:150,
	xtype:'combo',
	displayField:'LocDes',
	valueField:'LocCode',
	hideTrigger:false,
	forceSelection:true,
	triggerAction:'all',
	minChars:1,
	pageSize:10,
	typeAhead:true,
	typeAheadDelay:1000,
	//editable:false,
	loadingText:'Searching...'
});

var storenurse = new Ext.data.JsonStore({
			data : nursedata,
			fields : ['nurseid', 'nursedesc']
});
var nurse = new Ext.form.ComboBox({
			id : 'nursestr',
			hiddenName : 'nursestr1',
			store :storenurse, 
			width : 50,
			fieldLabel : '巡视人',
			valueField : 'nurseid',
			displayField : 'nursedesc',
			allowBlank : true,
			mode : 'local',
			anchor : '100%'
});

	function addnurse(a, b) {
	nursedata.push({
				nurseid : a,
				nursedesc: b
			});}
function addperson(a, b) {
	persondata.push({
				id : a,
				desc: b
			});
		}
function BodyLoadHandler() {
	setsize("mygridpl", "gform", "mygrid");
	var grid = Ext.getCmp("mygrid");
	var but = Ext.getCmp("mygridbut1");
	but.hide();

	var but = Ext.getCmp("mygridbut2");
	but.hide();
	var tobar = grid.getTopToolbar();
	
	tobar.addItem('开始日期',{
			xtype:'datefield',
			//format: 'Y-m-d',
			id:'mygridstdate',
			value:new Date() //(showNowDay())
		},'-','结束日期',{
			xtype:'datefield',
			//format: 'Y-m-d',
			id:'mygridenddate',
			value:new Date() //(showNowDay())
		},'-','科室', locField,'-','患者', person,'-','巡视人', nurse);
	tobar.addButton({
			//className: 'new-topic-button',
			text : "查询",
			handler : function() {
				searchFn();
			},
			icon:'../images/uiimages/search.png',
			id : 'btnSearch'
		});
       tobar.addButton(
       {
	        className: 'new-topic-button1',
	        text: "导出EXCEL",
	        icon:'../images/uiimages/senddetails.png',
	        handler:function(){exportFn()},
	        id:'btnPrt'
       }

    
//grid.on('rowclick',rowClickFn);
);
   var bbar = grid.getBottomToolbar ();
	bbar.hide();
	tobar.doLayout();
    Ext.getCmp("locsys").setValue(session['LOGON.CTLOCID']);
   

}
function exportFn() 
{ 
	var xls = new ActiveXObject ("Excel.Application"); 
	 
	xls.visible =true;  //设置excel为可见 
	var xlBook = xls.Workbooks.Add; 
	var xlSheet = xlBook.Worksheets(1); 
	
	//var grid = Ext.getCmp('ApplyRecordGrid');
  var grid = Ext.getCmp("mygrid");
 	var cm = grid.getColumnModel(); 
	var colCount = cm.getColumnCount(); 
	var temp_obj = []; 
	
	//只下载没有隐藏的列(isHidden()为true表示隐藏,其他都为显示) 
	//临时数组,存放所有当前显示列的下标 
	 for(i=0;i <colCount;i++){ 
		if(cm.isHidden(i) == true){ 
		}else{ 
			temp_obj.push(i); 
		} 
	} 
	for(i=1;i <=temp_obj.length-2;i++){ 
		//显示列的列标题 
		xlSheet.Cells(1,i).Value = cm.getColumnHeader(temp_obj[i]); 
	} 
	var store = grid.getStore(); 
	var recordCount = store.getCount(); 
	var view = grid.getView(); 
	for(i=1;i <=recordCount;i++){ 
		for(j=1;j <=temp_obj.length-2;j++){ 
			//EXCEL数据从第二行开始,故row = i + 1; 
			xlSheet.Cells(i + 1,j).Value = view.getCell(i - 1,temp_obj[j]).innerText; 
		} 
	} 
	xlSheet.Columns.AutoFit; 
	xls.ActiveWindow.Zoom = 75 
	xls.UserControl = true;  //很重要,不能省略,不然会出问题 意思是excel交由用户控制 
    xls=null; 
    xlBook=null; 
    xlSheet=null; 
}


var cmb = Ext.getCmp("personstr");
cmb.on('focus', cmbkey);
function cmbkey(field, e) {
		getlistdata("", field);
	}
function getlistdata(p, cmb) {
	loc=Ext.getCmp("locsys").getValue();
	var obj= Ext.getCmp("personstr")
    persondata=new Array(); 
    //alert(loc)   
    var getpersonobj=document.getElementById('GetNurMedTourperson');
    cspRunServerMethod(getpersonobj.value,loc,'addperson');
	cmb.store.loadData(persondata);
	}
	
	
var cmb2 = Ext.getCmp("nursestr");
cmb2.on('focus', cmbkey2);
function cmbkey2(field, e) {
		getlistdata2("", field);
	}
function getlistdata2(p, cmb2) {
	  nursedata=new Array();
	  loc=Ext.getCmp("locsys").getValue();  
	  var GetDocobj=document.getElementById('GetDoc');
	  cspRunServerMethod(GetDocobj.value,loc,'addnurse');
	  cmb2.store.loadData(nursedata);
}



function searchFn()
{
	var conloc = Ext.get("loc1").dom.value;
	var stdate = Ext.getCmp("mygridstdate").value;
	var edate = Ext.getCmp("mygridenddate").value;
	var person = Ext.get("personstr1").dom.value;	
	var nurse= Ext.get("nursestr1").dom.value;
	var GetQueryData=document.getElementById('GetQueryData');
	//alert(stdate+"^"+edate+"^"+conloc+"^"+person+"^"+nurse);
	arrgrid = new Array();
    cspRunServerMethod(GetQueryData.value,"Nur.DHCNurTourRec:GetTourRec","parr$"+stdate+"^"+edate+"^"+conloc+"^"+person+"^"+nurse+"^","AddRec");
	var grid = Ext.getCmp("mygrid");
	grid.store.loadData(arrgrid);
	/*/
	var mygrid = Ext.getCmp("mygrid");
	var parr=stdate+"^"+edate+"^"+conloc+"^"+person+"^"+nurse+"^";
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
   */
}

function AddRec(str)
{
	var obj = eval('(' + str + ')');
	arrgrid.push(obj);
}

function GetFirstDay()
{
    var s="";
    var myDate = new Date();
    var year = myDate.getYear();
    var month = myDate.getMonth();
    return(new Date(year,month,1));
}

function showMonthFirstDay() 
{ 
	var Nowdate=new Date(); 
	var MonthFirstDay=new Date(Nowdate.getYear(),Nowdate.getMonth(),1);
	return MonthFirstDay;
} 
function showMonthLastDay() 
{ 
	var Nowdate=new Date(); 
	var MonthNextFirstDay=new Date(Nowdate.getYear(),Nowdate.getMonth()+1,1); 
	var MonthLastDay=new Date(MonthNextFirstDay-86400000);
	return MonthLastDay;
}

function showNowDay() 
{ 
	var myDate=new Date();
	 	var Month=myDate.getMonth()+1;
	 	var MDate=myDate.getDate();
	 	if ((((myDate.getDate()).toString()).length)==1)  //修改日期日头格式
	 	{
	 		var MDate="0"+(myDate.getDate()).toString();
	 	}
	 	if ((((myDate.getMonth()+1).toString()).length)==1)  //修改日期月份格式
	 	{
	 		var Month="0"+(myDate.getMonth()+1).toString();
	 	}
	   	var nowDate=myDate.getYear()+"-"+Month+"-"+MDate;
	return nowDate;
}
