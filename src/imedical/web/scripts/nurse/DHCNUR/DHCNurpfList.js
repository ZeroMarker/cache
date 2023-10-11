var ret="";
var checkret="";
var comboret="";
var ht = new Hashtable();
var arrgrid=new Array();
function gethead()
{
	var GetHead=document.getElementById('GetHead');
	var ret=cspRunServerMethod(GetHead.value,EpisodeID);
	return ret;
	//debugger;
}
function BodyLoadHandler(){

	setsize("mygridpl", "gform", "mygrid");
	var grid=Ext.getCmp('mygrid');
	//alert(1);
	//grid.on('dblclick', griddblclick);
	var but1 = Ext.getCmp("mygridbut1");
	but1.on('click', newrec);
	var but = Ext.getCmp("mygridbut2");
	but.setText("修改");
	but.on('click', modrec);
	
	grid.on('rowdblclick',modrec);
	grid = Ext.getCmp('mygrid');
	//debugger;
	//grid.setTitle(gethead());
	var mydate = new Date();
	var tobar = grid.getTopToolbar();
	
	tobar.addButton({
		className: 'new-topic-button',
		text: "查询",
		handler: find,
		id: 'mygridSch'
	});	
	tobar.addItem ("-",{
			xtype:'checkbox',
			id:'IfCancelRec',
			checked:false,
			boxLabel:'显示作废记录' 		
	});
		grid.addListener('rowcontextmenu', rightClickFn);
	
	//tobar.addButton({
		//className: 'new-topic-button',
		//text: "删除",
		//handler: delete,
		//id: 'mygridSch1'
	//});	
	 var bbar = grid.getBottomToolbar ();
	  bbar.hide();
	  //上半部分
	  var bbar2 = new Ext.PagingToolbar({
		pageSize:20,
		store:grid.store,
		displayInfo:true,
		displayMsg:'显示第 {0} 条到 {1} 条记录，一共 {2} 条',
		emptyMsg:"没有记录"
	});
	bbar2.render(grid.bbar);  //病情变化部分
	find();
}

function rightClickFn(client, rowIndex, e)  {
          e.preventDefault();
          grid=client;
		  CurrRowIndex=rowIndex;
          rightClick.showAt(e.getXY());
            }
var rightClick = new Ext.menu.Menu(  {
            id : 'rightClickCont',
            items : [    {
                id:'rMenu7',
                text : '作废',
                handler:CancelRecord
            },{
                id:'rMenu8',
                text : '撤销作废',
                handler:Cancelzf
            }]
        });
function CancelRecord()
{
	var objCancelRecord=document.getElementById('CancelRecord');
	var objRow=grid.getSelectionModel().getSelections();
	if (objRow.length == 0) 
	{
		alert("请先选择一条护理记录!");
		return;
	} else 
	{
		var flag = confirm("你确定要作废此条记录吗!")
		if (flag) 
		{
		            var par=objRow[0].get("rw");
					var rw=objRow[0].get("chl");
					//alert(par+","+rw+","+session['LOGON.USERID']+","+session['LOGON.GROUPDESC']);
					if (objCancelRecord) 
					{
						var a = cspRunServerMethod(objCancelRecord.value, par, rw, session['LOGON.USERID'], session['LOGON.GROUPDESC']);
						if (a!=0){
							alert(a);
							return;
						}else{
							find();
						}
					}
	   }
	}
}
function Cancelzf()
{
	var objCancelRecord=document.getElementById('Cancelzf');
	var objRow=grid.getSelectionModel().getSelections();
	if (objRow.length == 0) 
	{
		alert("请先选择一条护理记录!");
		return;
	} else 
	{
		var flag = confirm("你确定要撤销作废记录吗!")
		if (flag) 
		{
			        var par=objRow[0].get("rw");
					var rw=objRow[0].get("chl");
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
	}
}
	function find()
{
	var mygrid1 = Ext.getCmp("mygrid");
	var IfCancelRec=Ext.getCmp("IfCancelRec").getValue();
	var parr ="DHCNurPFB^"+EpisodeID+"^IfCancelRec^"+IfCancelRec;
	mygrid1.store.on(
    "beforeLoad",function(){    
       //alert(MID)	
       mygrid1.store.baseParams.parr=parr;
    });	
	mygrid1.store.load({
		params : {
			start : 0,
			limit : 20
		}
	});
}
function find222()
{
	//var StDate = Ext.getCmp("mygridstdate");
	//var Enddate = Ext.getCmp("mygridenddate");
	var GetQueryData = document.getElementById('GetQueryData');
	var mygrid = Ext.getCmp("mygrid");
		var IfCancelRec=Ext.getCmp("IfCancelRec").getValue();
	var parr ="DHCNurPFB^"+EpisodeID+"^IfCancelRec^"+IfCancelRec;
	//var parr ="DHCNurPFB^"+EpisodeID;
	arrgrid=new Array();
	//alert(EpisodeID);
	//alert(parr);
	var a = cspRunServerMethod(GetQueryData.value, "web.DHCNurMouldDataComm:MoudData", "parr$" +parr,"AddRec");
	//alert(a);
  mygrid.store.loadData(arrgrid);   

}
function AddRec(str)
{
	//var a=new Object(eval(str));
	//alert(str);
	var obj = eval('(' + str + ')');
	arrgrid.push(obj);
	//debugger;
}

function newrec()
{
	// var CurrAdm=selections[rowIndex].get("Adm");
	
	//if (DtId=="")return;
	//var getcurExamId=document.getElementById('getcurExamId');
	//var ExamId=cspRunServerMethod(getcurExamId.value,SpId);
    // alert(ExamId);
	var lnk= "DHCNurEmrComm.csp?"+"&EmrCode=DHCNurPFB"+"&EpisodeID="+EpisodeID+"&NurRecId=";;
	//var topValue=(window.screen.height-720)/6;
	//var leftValue=(window.screen.width-700)/2;
	var widthValue=700;
	var heightValue=720;
	if(heightValue>(window.screen.height-100)) heightValue=window.screen.height-100;
	if(widthValue>(window.screen.width-15)) widthValue=window.screen.width-15;
	var topValue=(window.screen.height-heightValue-100)/2;
	var leftValue=(window.screen.width-widthValue-15)/2;
	window.open(lnk, "htm", 'toolbar=no,location=no,directories=no,resizable=yes,top='+topValue+',left='+leftValue+',width='+widthValue+',height='+heightValue);
	//window.open(lnk,"htm",'toolbar=no,location=no,directories=no,resizable=yes,top='+topValue+',left='+leftValue+',width=700,height=720');



}
function reloadtree()
{
	window.parent.reloadtree();
}
function modrec()
{
    var mygrid = Ext.getCmp("mygrid");
	var rowObj = mygrid.getSelectionModel().getSelections();
	
	var len = rowObj.length;
	if (len < 1) {
		alert("请选择需要修改的数据!")
		return;
	} else {
	id = rowObj[0].get("rw")+"||"+rowObj[0].get("chl");
	}
	if(id)
	//alert(id);
	var lnk= "DHCNurEmrComm.csp?"+"&EmrCode=DHCNurPFB"+"&EpisodeID="+EpisodeID+"&NurRecId="+id;;
	var widthValue=700;
	var heightValue=720;
	if(heightValue>(window.screen.height-100)) heightValue=window.screen.height-100;
	if(widthValue>(window.screen.width-15)) widthValue=window.screen.width-15;
	var topValue=(window.screen.height-heightValue-100)/2;
	var leftValue=(window.screen.width-widthValue-15)/2;
	window.open(lnk, "htm", 'toolbar=no,location=no,directories=no,resizable=yes,top='+topValue+',left='+leftValue+',width='+widthValue+',height='+heightValue);
	//window.open(lnk,"htm",'toolbar=no,location=no,directories=no,resizable=yes,top='+topValue+',left='+leftValue+',width=700,height=720');
}
